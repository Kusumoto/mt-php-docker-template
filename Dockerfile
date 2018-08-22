FROM php:7.2-fpm-stretch

RUN apt-get update && \
    apt-get install -y libxml2-dev \
    libmcrypt-dev \
    libmagickwand-dev \
    libfreetype6-dev \
    build-essential \
    libjpeg62-turbo-dev \
    libicu-dev \
    libbz2-dev \
    libpng-dev \
    supervisor \
    cron \
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
    docker-php-ext-install mbstring && \
    docker-php-ext-install intl && \
    docker-php-ext-install iconv && \
    docker-php-ext-install bcmath && \
    docker-php-ext-install bz2 && \
    docker-php-ext-install opcache && \
    docker-php-ext-configure gd \
    --enable-gd-native-ttf \
    --with-jpeg-dir=/usr/lib \
    --with-freetype-dir=/usr/include/freetype2 && \
    docker-php-ext-install gd && \
    pecl install -o -f redis && \
    docker-php-ext-enable redis && \
    curl -s http://getcomposer.org/installer | php && \
    mv composer.phar /usr/local/bin/composer && \
    apt-get autoremove -y build-essential

COPY docker-entrypoint.sh /

ENV TZ Asia/Bangkok

EXPOSE 9000

WORKDIR /var/www

ENTRYPOINT [ "sh", "/docker-entrypoint.sh" ]

CMD ["php-fpm"]
