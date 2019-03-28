FROM php:5.6-apache
LABEL company="Wakwizus"
LABEL maintainer="jimmy@walkwizus.fr"

RUN a2enmod rewrite

RUN set -ex; \
    \
    apt-get update -y; \
    apt-get install -y \
    libmagickwand-dev \
    libjpeg-dev \
    libpng-dev \
    libmcrypt-dev \
    libxml2-dev \
    libxslt1-dev \
    zlib1g-dev \
    libicu-dev \
    g++ \
    ssmtp \
    git \
    nano

RUN pecl install imagick \
    && docker-php-ext-install mcrypt zip bz2 mbstring xsl \
    && docker-php-ext-configure gd --with-png-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
    && docker-php-ext-install gd json mcrypt pdo_mysql \
    && docker-php-ext-enable imagick \
    && docker-php-ext-install soap \
    && docker-php-ext-enable soap \
    && docker-php-ext-install mysqli \
    && docker-php-ext-configure intl \
    && docker-php-ext-install intl \
    && docker-php-ext-install fileinfo \
    && docker-php-ext-configure opcache --enable-opcache \
    && docker-php-ext-install opcache \
    && docker-php-ext-install bcmath \
    && docker-php-ext-enable bcmath \
    && docker-php-ext-install sockets \
    && docker-php-ext-enable sockets 

RUN php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');" \
    && php composer-setup.php --install-dir=/usr/local/bin/ --filename=composer \
    && php -r "unlink('composer-setup.php');" \
    && composer global require hirak/prestissimo

RUN pecl install apcu-4.0.11 \
    && docker-php-ext-enable apcu

RUN docker-php-ext-install calendar

COPY etc/php.ini /usr/local/etc/php/conf.d/00_magento.ini

WORKDIR /var/www/html