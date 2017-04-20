## PHP-FPM Image

**Helpful PHP-FPM image from official php:fpm

>This image was done from the official php-fpm image;
>There are also have installed a lot of useful extensions
>DateTime - Europe/Kiev
>Also we configure xdebug.ini for xdebug but all directives are turned off by default
>Composer installed globally
>PHP installed also globally

# Extension by PECL
   * xdebug (2.5.0)
   * redis  (3.1.0)

# PHP extensions
   * iconv 
   * mcrypt 
   * zip 
   * bz2 
   * mbstring 
   * intl 
   * pgsql pdo
   * pdo_pgsql 
   * bcmath 
   * gd
   * `pdo_mysql (new)`

# Programs  
   * curl
   * git
   * unzip
   * mc
   * vim
   * wget
   
# ENVs:
   * LYBERTEAM_VOLUME               - set the volume (default - /var/www/lyberteam )
   * LYBERTEAM_STOPSIGNAL           - default SIGINT
   
# Removed extensions:
   * opcache 
