FROM  php:8.0.0beta2-fpm-alpine
LABEL maintainer="alex19pov31@gmail.com"

RUN apk add tzdata; \
	mkdir -p /tmp/php_upload/www && chmod -R 777 /tmp/php_upload/www; \
	[ -f /etc/localtime ] && rm /etc/localtime; \
	ln -s /usr/share/zoneinfo/Europe/Moscow /etc/localtime && \
	addgroup -g 1000 nginx && adduser -D -u 1000 -G nginx nginx && \
	apk add curl wget git msmtp libpng-dev libzip-dev oniguruma-dev freetype libjpeg-turbo-dev libmcrypt-dev freetype-dev libcurl curl-dev libxml2-dev autoconf g++ make; \
	docker-php-ext-configure gd && \
	docker-php-ext-configure soap && \
	docker-php-ext-configure pdo && \
	docker-php-ext-configure pdo_mysql && \
	docker-php-ext-install soap mbstring iconv mysqli opcache xml zip gd pdo pdo_mysql && \
	mkdir -p /tmp/php_sessions/www && chown -R nginx:nginx /tmp/php_sessions/ && \
	mkdir -p /home/www && chown -R nginx:nginx /home/www && \
	cd /tmp && php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');" && \
	php composer-setup.php && php -r "unlink('composer-setup.php');" && \
	mv composer.phar /usr/local/bin/composer && chmod +x /usr/local/bin/composer

COPY conf/usr /usr

ENTRYPOINT ["php-fpm"]