#
# PHP7-FPM + extras for Wordpress
# Libs: GD, ImageMagick, opcache, mysqli  
#
# Copyright (c) 2016 Youdowell AG - All rights reserved 
#

FROM php:fpm

# Update
RUN apt-get update --fix-missing && apt-get -y dist-upgrade

# Install PHP extensions
RUN apt-get install --no-install-recommends -y \
    libmcrypt-dev libicu52 libmcrypt4 \
    libpng12-dev libjpeg-dev libpq-dev file re2c libicu-dev zlib1g-dev \
    libmagickcore-dev libmagickwand-dev libmagick++-dev libjpeg-dev libpng12-dev \
    imagemagick xfonts-base xfonts-75dpi libfreetype6-dev \
	&& rm -rf /var/lib/apt/lists/*

RUN docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-png-dir=/usr/lib --with-jpeg-dir=/usr/lib \
	&& docker-php-ext-install gd mbstring mysqli zip opcache bcmath sockets intl mcrypt

ENV PHP_INI_DIR /usr/local/etc/php

RUN pecl install imagick-beta && \
  echo "extension=imagick.so" >> "$PHP_INI_DIR/conf.d/ext-imagick.ini" &&  \  
  echo "date.timezone=UTC" >> "$PHP_INI_DIR/conf.d/timezone.ini"
    
## Configure Opcache
RUN ( \
    echo "opcache.memory_consumption=128"; \
    echo "opcache.interned_strings_buffer=8"; \
    echo "opcache.max_accelerated_files=4000"; \
    echo "opcache.revalidate_freq=60"; \
    echo "opcache.fast_shutdown=1"; \
    echo "opcache.enable_cli=1"; \
    ) > "$PHP_INI_DIR/conf.d/opcache-recommended.ini"

VOLUME /var/www/html
CMD ["php-fpm"]
