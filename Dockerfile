FROM php:7.3-fpm

# Устанавливаем расширения PHP
RUN apt-get update && apt-get install -y \
        libssl-dev \
        openssl \
        unzip \
        libicu-dev \
        libpq-dev \
        libpng-dev \
        libzip-dev \
    && docker-php-ext-install \
        gd \
        zip \
        intl \
        opcache \
        pdo \
        pdo_mysql \
        pdo_pgsql \
        pcntl \
    && docker-php-ext-enable \
        gd \
        zip \
        intl \
        opcache \
        pdo \
        pdo_mysql \
        pdo_pgsql \
        pcntl

RUN pecl install mongodb && echo "extension=mongodb.so" >> /usr/local/etc/php/conf.d/mongodb.ini

RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer \
    && composer --version
    
# Сахар для терминала
RUN echo 'alias sf="php bin/console"' >> ~/.bashrc

# Фикс привелегий
RUN usermod -u 1000 www-data
