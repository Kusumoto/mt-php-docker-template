FROM php:7.2-fpm-alpine

RUN apk update && \
    apk add --no-cache --virtual .build-deps libxml2-dev \
    libmcrypt-dev \
    imagemagick-dev \
    freetype-dev \
    build-base \
    libjpeg-turbo-dev \
    icu-dev \
    bzip2-dev \
    libpng-dev && \
    apk add autoconf \ 
    supervisor \
    libtool \
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
    pecl install -o -f redis \
    docker-php-ext-enable redis \
    apk del .build-deps && \
    rm -rf /var/cache/apk/* && \
    curl -s http://getcomposer.org/installer | php && \
    mv composer.phar /usr/local/bin/composer

RUN rm /usr/bin/iconv \
  && curl -SL http://ftp.gnu.org/pub/gnu/libiconv/libiconv-1.14.tar.gz | tar -xz -C . \
  && cd libiconv-1.14 \
  && ./configure --prefix=/usr/local \
  && curl -SL https://raw.githubusercontent.com/mxe/mxe/7e231efd245996b886b501dad780761205ecf376/src/libiconv-1-fixes.patch \
  | patch -p1 -u  \
  && make \
  && make install \
  && libtool --finish /usr/local/lib \
  && cd .. \
  && rm -rf libiconv-1.14

ENV LD_PRELOAD /usr/local/lib/preloadable_libiconv.so

COPY docker-entrypoint.sh /

ENV TZ Asia/Bangkok

EXPOSE 9000

WORKDIR /var/www

ENTRYPOINT [ "sh", "/docker-entrypoint.sh" ]

CMD ["php-fpm"]
