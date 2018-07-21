FROM php:7.2-fpm-alpine

RUN apk update && \
    apk add --no-cache --virtual .build-deps libxml2-dev \
    libmcrypt-dev \
    imagemagick-dev \
    freetype-dev \
    build-base \
    libjpeg-turbo-dev \
    libpng-dev && \
    apk add autoconf \ 
    supervisor \
    tzdata && \
    pecl install -o -f mcrypt-1.0.1 && \
    pecl install -o -f imagick && \
    docker-php-ext-install soap && \
    docker-php-ext-enable mcrypt && \
    docker-php-ext-install pcntl && \
    docker-php-ext-install zip && \
    docker-php-ext-install calendar && \
    docker-php-ext-install pdo_mysql && \
    docker-php-ext-install bcmath && \
    docker-php-ext-enable imagick && \
    docker-php-ext-install gd && \
    docker-php-ext-configure gd \
    --enable-gd-native-ttf \
    --with-jpeg-dir=/usr/lib \
    --with-freetype-dir=/usr/include/freetype2 && \
    docker-php-ext-install gd && \
    pecl install -o -f redis \
    docker-php-ext-enable redis \
    apk del .build-deps && \
    rm -rf /var/cache/apk/* && \
    curl -s http://getcomposer.org/installer | php && \
    mv composer.phar /usr/local/bin/composer

ENV TZ Asia/Bangkok

EXPOSE 9000

WORKDIR /var/www

CMD ["php-fpm"]
