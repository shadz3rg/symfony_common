FROM php:7.2-fpm

# Устанавливаем расширения PHP
RUN apt-get update && apt-get install -y \
        libssl1.0-dev \
        openssl \
        openssh-client \
        rsync \
        unzip \
        libicu-dev \
        libpq-dev \
        libpng-dev \
        libzip-dev \
        librabbitmq-dev \
        libssh-dev \
        git \
        graphviz \
    && docker-php-ext-install \
        gd \
        zip \
        intl \
        opcache \
        pdo \
        pdo_mysql \
        pdo_pgsql \
        pcntl \
        bcmath \
        sockets \
    && docker-php-ext-enable \
        gd \
        zip \
        intl \
        opcache \
        pdo \
        pdo_mysql \
        pdo_pgsql \
        pcntl \
        bcmath \
        sockets

RUN pecl install amqp && docker-php-ext-enable amqp
RUN pecl install mongodb && echo "extension=mongodb.so" >> /usr/local/etc/php/conf.d/mongodb.ini

RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer \
    && composer --version
    
RUN composer global require deployer/deployer
RUN composer global require deployer/recipes --dev
    
# Сахар для терминала
RUN echo 'alias sf="php bin/console"' >> ~/.bashrc

# Фикс привелегий
RUN usermod -u 1000 www-data
