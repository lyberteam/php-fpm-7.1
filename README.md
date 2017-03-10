## PHP-FPM Image

**Helpful PHP-FPM image from official php:fpm

>This image was done from the official php-fpm image;
>There are also have installed a lot of useful extensions
>DateTime - Europe/Kiev
>Also we configure xdebug.ini for xdebug but all directives are turned off by default

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
   * opcache 
   * gd 
   * xdebug
   * redis

# Programs  
   * curl 
   * git 
   * unzip 
   * mc 
   * vim
   * wget 
   
# ENVs:
   * LYBERTEAM_WORKING_DIR          - set the WORKDIR (default - /var/www/lyberteam )
   * CUSTOME_STOPSIGNAL             - default SIGINT