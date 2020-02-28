FROM php:7.4-fpm

# Устанавливаем расширения PHP
RUN apt-get update && apt-get install -y \
        libssl-dev \
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
        libxml2-dev \
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
        soap \
        exif \
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
        sockets \
        soap \
        exif

RUN pecl install amqp && docker-php-ext-enable amqp
RUN pecl install mongodb && echo "extension=mongodb.so" >> /usr/local/etc/php/conf.d/mongodb.ini
RUN pecl install redis && docker-php-ext-enable redis

RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer \
    && composer --version
    
RUN composer global require deployer/deployer
RUN composer global require deployer/recipes --dev

RUN curl -sS https://get.symfony.com/cli/installer | bash \
    && mv /root/.symfony/bin/symfony /usr/local/bin/symfony \
    && symfony -V

# Сахар для терминала
RUN echo 'alias sf="php bin/console"' >> ~/.bashrc

# Фикс привелегий
RUN usermod -u 1000 www-data
