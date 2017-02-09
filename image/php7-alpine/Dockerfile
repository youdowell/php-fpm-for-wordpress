#
# PHP7-FPM on Alpine Linus + extras for Wordpress
# Libs: gd, opcache, mysqli, mcrypt  
#
FROM php:7.1-fpm-alpine
MAINTAINER Andrew Usov "andrew.usov@youdowell.com"

RUN set -xe \
	&& apk add --no-cache \
		bash \
		sed \
	&& apk add --no-cache --virtual .build-deps \
		freetype-dev \
		icu \
		icu-dev \
		libintl \
		libjpeg-turbo-dev \
		libmcrypt-dev \
		libpng-dev \
		libxml2-dev \
	&& docker-php-ext-configure gd --with-freetype-dir=/usr --with-png-dir=/usr --with-jpeg-dir=/usr \
	&& docker-php-ext-install \
		gd \
		mysqli \
		opcache \
		iconv \
		mcrypt \
		intl \
		zip \
	&& runDeps="$( \
		scanelf --needed --nobanner --recursive \
			/usr/local/lib/php/extensions \
			| awk '{ gsub(/,/, "\nso:", $2); print "so:" $2 }' \
			| sort -u \
			| xargs -r apk info --installed \
			| sort -u \
	)" \
	&& apk add --virtual .wordpress-phpexts-rundeps $runDeps \
	&& apk del .build-deps \
	\
	&& { \
		echo 'opcache.memory_consumption=128'; \
		echo 'opcache.interned_strings_buffer=8'; \
		echo 'opcache.max_accelerated_files=4000'; \
		echo 'opcache.revalidate_freq=2'; \
		echo 'opcache.fast_shutdown=1'; \
		echo 'opcache.enable_cli=1'; \
	} > /usr/local/etc/php/conf.d/opcache-recommended.ini

# PhpRedis
RUN set -xe; \
	docker-php-source extract; \
	curl -L -o /tmp/redis.tar.gz https://github.com/phpredis/phpredis/archive/php7.tar.gz; \
	tar xfz /tmp/redis.tar.gz; \
	rm -r /tmp/redis.tar.gz; \
	mv phpredis-php7 /usr/src/php/ext/redis; \
	docker-php-ext-install redis; \
	docker-php-source delete

WORKDIR /var/www/html

ADD docker-entrypoint.sh /usr/local/bin/

ENTRYPOINT ["docker-entrypoint.sh"]
CMD ["php-fpm", "-F"]
