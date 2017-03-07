# PHP7-FPM
FROM php:7.0.12-fpm

LABEL Vendor="lyberteam"
LABEL Description="This is a new php-fpm image(version for now 7.0.9)"
LABEL version="1.0"

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
	nodejs \
	npm \
        git \
        unzip \
        mc \
        vim \
        wget \
#        libevent-dev \
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
        --with-jpeg-dir=/usr/include \
    && docker-php-ext-install gd \
    && docker-php-ext-install mbstring \
    && docker-php-ext-enable opcache gd

## Install Xdebug
RUN echo "Install xdebug by pecl"
RUN yes | pecl install xdebug \
    && echo "zend_extension=$(find /usr/local/lib/php/extensions/ -name xdebug.so)" > /usr/local/etc/php/conf.d/xdebug.ini \
    && echo "xdebug.remote_enable=on" >> /usr/local/etc/php/conf.d/xdebug.ini \
    && echo "xdebug.remote_autostart=on" >> /usr/local/etc/php/conf.d/xdebug.ini \
    && echo "xdebug.default_enable=on" >> /usr/local/etc/php/conf.d/xdebug.ini \
    && echo "xdebug.remote_port=9001" >> /usr/local/etc/php/conf.d/xdebug.ini \
    && echo "xdebug.remote_connect_back=on" >> /usr/local/etc/php/conf.d/xdebug.ini

## You can comment the next line if you don't want change xdebug configuration and build your own image
#COPY xdebug.ini /usr/local/etc/php/conf.d/xdebug.ini

# Change TimeZone
RUN echo "Set Timezone to Europe/Kiev"
RUN echo "Europe/Kiev" > /etc/timezone

# Install composer globally
RUN echo "Install composer globally"

RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/bin/ --filename=composer

RUN printf "\n" | pecl install apcu-beta && echo extension=apcu.so > /usr/local/etc/php/conf.d/10-apcu.ini
RUN printf "\n" | pecl install apcu_bc-beta && echo extension=apc.so > /usr/local/etc/php/conf.d/apc.ini

RUN printf "\n" | pecl install channel://pecl.php.net/amqp-1.7.0alpha2 && echo extension=amqp.so > /usr/local/etc/php/conf.d/amqp.ini

RUN pecl install channel://pecl.php.net/ev-1.0.0RC3 && echo extension=ev.so > /usr/local/etc/php/conf.d/ev.ini

RUN ln -sf /dev/stdout /var/log/access.log && ln -sf /dev/stderr /var/log/error.log

COPY php.ini /usr/local/etc/php/

RUN /bin/bash -c 'rm -f /usr/local/etc/php-fpm.d/www.conf.default'
ADD symfony.pool.conf /usr/local/etc/php-fpm.d/
RUN rm -f /usr/local/etc/php-fpm.d/www.conf

## Install PHP CODE_SNIFFER
RUN echo "installing Code_sniffer phpcs"
RUN curl -OL https://squizlabs.github.io/PHP_CodeSniffer/phpcs.phar
RUN chmod +x phpcs.phar
RUN mv phpcs.phar /usr/local/bin/phpcs
RUN phpcs --version

RUN echo "installing Code_sniffer phpcbf"
RUN curl -OL https://squizlabs.github.io/PHP_CodeSniffer/phpcbf.phar
RUN chmod +x phpcbf.phar
RUN mv phpcbf.phar /usr/local/bin/phpcbf
RUN phpcbf --version

## Install PHPLOC
RUN echo "installing PHPLOC"
RUN wget https://phar.phpunit.de/phploc.phar
RUN chmod +x phploc.phar
RUN mv phploc.phar /usr/local/bin/phploc
RUN phploc --version

## Install PHP_DEPEND
RUN echo "installing PHP_DEPEND"
RUN wget http://static.pdepend.org/php/latest/pdepend.phar
RUN chmod +x pdepend.phar
RUN mv pdepend.phar /usr/local/bin/pdepend
RUN pdepend --version

## Install PHPUNIT
RUN echo "installing PHPUNIT"
RUN wget https://phar.phpunit.de/phpunit.phar
RUN chmod +x phpunit.phar
RUN mv phpunit.phar /usr/local/bin/phpunit
RUN phpunit --version

## Install PHPMD
RUN echo "installing PHPMD"
RUN wget -c http://static.phpmd.org/php/latest/phpmd.phar
RUN chmod +x phpmd.phar
RUN mv phpmd.phar /usr/local/bin/phpmd
RUN phpmd --version

## Install PHPCPD
RUN echo "installing PHPCPD"
RUN wget https://phar.phpunit.de/phpcpd.phar
RUN chmod +x phpcpd.phar
RUN mv phpcpd.phar /usr/local/bin/phpcpd
RUN phpcpd --version

## Install PHPDOX
RUN echo "installing PHPDOX"
RUN wget http://phpdox.de/releases/phpdox.phar
RUN chmod +x phpdox.phar
RUN mv phpdox.phar /usr/local/bin/phpdox
RUN phpdox --version

## Install wkhtmltopdf
RUN echo "Install wkhtmltopdf and xvfb"
RUN apt-get install -y \
    wkhtmltopdf \
    xvfb
RUN echo "Create xvfb wrapper for wkhtmltopdf and create special sh script"
RUN touch /usr/local/bin/wkhtmltopdf
RUN chmod a+x /usr/local/bin/wkhtmltopdf
RUN echo 'xvfb-run -a -s "-screen 0 640x480x16" wkhtmltopdf "$@"' > /usr/local/bin/wkhtmltopdf
RUN chmod a+x /usr/local/bin/wkhtmltopdf

RUN usermod -u 1000 www-data

CMD ["php-fpm"]

EXPOSE 9000

## Reconfigure timezones
RUN  dpkg-reconfigure -f noninteractive tzdata