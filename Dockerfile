# PHP7-FPM
FROM php:7.1-fpm

ADD lyberteam-message.sh /var/www/lyberteam/lyberteam-message.sh
RUN chmod +x /var/www/lyberteam/lyberteam-message.sh
RUN /var/www/lyberteam/lyberteam-message.sh


MAINTAINER Lyberteam <lyberteamltd@gmail.com>
LABEL Vendor="Lyberteam"
LABEL Description="This is a new php-fpm image(version for now 7.1)"
LABEL Version="1.4.7"

ENV LYBERTEAM_TIME_ZONE Europe/Kiev
ENV LYBERTEAM_WORKING_DIR /var/www/lyberteam

ENV HEALTHCHECK_INTERVAL_DURATION 40s
ENV HEALTHCHECK_TIMEOUT_DURATION 40s
ENV HEALTHCHECK_RETRIES 5

ENV CUSTOME_STOPSIGNAL SIGINT

RUN apt-get update && apt-get install -y \
        libfreetype6-dev \
        libjpeg62-turbo-dev \
       libpng12-dev \
        libmcrypt-dev \
        libicu-dev \
        libpq-dev \
        libbz2-dev \
        php-pear \
        curl \
	    #nodejs \
	    #npm \
        git \
        unzip \
        mc \
        vim \
        wget \
        libevent-dev \
        librabbitmq-dev \
    && docker-php-ext-install iconv \
    && docker-php-ext-install mcrypt \
    && docker-php-ext-install zip \
    && docker-php-ext-install bz2 \
    && docker-php-ext-install mbstring \
    && docker-php-ext-install intl \
    && docker-php-ext-install pgsql pdo pdo_pgsql \
    && docker-php-ext-install bcmath \
    && docker-php-ext-install opcache \
    && docker-php-ext-configure gd \
        --enable-gd-native-ttf \
        --with-freetype-dir=/usr/include/freetype2 \
        --with-png-dir=/usr/include \
        --with-jpeg-dir=/usr/include

## Install Xdebug
RUN echo "Install xdebug by pecl"
RUN yes | pecl install xdebug \
    && echo "zend_extension=$(find /usr/local/lib/php/extensions/ -name xdebug.so)" > /usr/local/etc/php/conf.d/xdebug.ini \
    && echo "xdebug.remote_enable=off" >> /usr/local/etc/php/conf.d/xdebug.ini \
    && echo "xdebug.remote_autostart=off" >> /usr/local/etc/php/conf.d/xdebug.ini \
    && echo "xdebug.default_enable=off" >> /usr/local/etc/php/conf.d/xdebug.ini \
    && echo "xdebug.remote_port=9001" >> /usr/local/etc/php/conf.d/xdebug.ini \
    && echo "xdebug.remote_connect_back=off" >> /usr/local/etc/php/conf.d/xdebug.ini

## You can comment the next line if you don't want change xdebug configuration and build your own image
#COPY xdebug.ini /usr/local/etc/php/conf.d/xdebug.ini

# Change TimeZone
RUN echo "Set LYBERTEAM_TIME_ZONE, by default - Europe/Kiev"
RUN echo $LYBERTEAM_TIME_ZONE > /etc/timezone

# Install composer globally
RUN echo "Install composer globally"

RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/bin/ --filename=composer

RUN printf "\n" | pecl install apcu-beta && echo extension=apcu.so > /usr/local/etc/php/conf.d/10-apcu.ini
RUN printf "\n" | pecl install apcu_bc-beta && echo extension=apc.so > /usr/local/etc/php/conf.d/apc.ini

RUN printf "\n" | pecl install channel://pecl.php.net/amqp-1.7.0alpha2 && echo extension=amqp.so > /usr/local/etc/php/conf.d/amqp.ini

RUN pecl install channel://pecl.php.net/ev-1.0.0RC3 && echo extension=ev.so > /usr/local/etc/php/conf.d/ev.ini

RUN ln -sf /dev/stdout /var/log/access.log && ln -sf /dev/stderr /var/log/error.log

## Now we copy will copy very simple php.ini file and change the timezone by ENV variable
COPY php.ini /usr/local/etc/php/
##RUN sed -i "/date.timezone/s/Europe\/Kiev/$LYBERTEAM_TIME_ZONE/g" /usr/local/etc/php/php.ini

RUN /bin/bash -c 'rm -f /usr/local/etc/php-fpm.d/www.conf.default'
ADD symfony.pool.conf /usr/local/etc/php-fpm.d/
RUN rm -f /usr/local/etc/php-fpm.d/www.conf


RUN usermod -u 1000 www-data

CMD ["php-fpm"]

## Let's set the working dir
WORKDIR $LYBERTEAM_WORKING_DIR

## Now will customize the healthcheck command for icinga or zabbix service monitor
ADD test-check.sh /usr/local/bin/test-check.sh
RUN chmod +x /usr/local/bin/test-check.sh

HEALTHCHECK CMD /usr/local/bin/test-check.sh


#HEALTHCHECK CMD curl --fail http://localhost:9000 || exit 1
#            ## --interval=$HEALTHCHECK_INTERVAL_DURATION \
#           ## --timeout=$HEALTHCHECK_TIMEOUT_DURATION \
#            ## --retries=$HEALTHCHECK_RETRIES \

## Set the signal to stop the container
STOPSIGNAL $CUSTOME_STOPSIGNAL

EXPOSE 9000

## Reconfigure timezones
RUN  dpkg-reconfigure -f noninteractive tzdata

##ADD run.sh run.sh
##RUN chmod +x run.sh
##ENTRYPOINT ["./run.sh"]