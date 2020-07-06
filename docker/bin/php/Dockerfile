FROM php:7.4.2-apache-buster

# Surpresses debconf complaints of trying to install apt packages interactively
# https://github.com/moby/moby/issues/4032#issuecomment-192327844

ARG DEBIAN_FRONTEND=noninteractive

# Update
RUN apt-get -y update --fix-missing && \
    apt-get upgrade -y && \
    apt-get --no-install-recommends install -y apt-utils && \
    rm -rf /var/lib/apt/lists/*

# Install useful tools and install important libaries
RUN apt-get -y update && \
    apt-get -y --no-install-recommends install nano wget \
dialog \
libsqlite3-dev \
libsqlite3-0 && \
    apt-get -y --no-install-recommends install default-mysql-client \
zlib1g-dev \
libzip-dev \
libicu-dev && \
    apt-get -y --no-install-recommends install --fix-missing apt-utils \
build-essential \
git \
curl \
libonig-dev && \
    apt-get -y --no-install-recommends install --fix-missing libcurl4 \
libcurl4-openssl-dev \
zip \
openssl && \
    rm -rf /var/lib/apt/lists/* && \
    curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

RUN apt-get -y update
RUN apt-get -y install gnupg

RUN curl https://packages.microsoft.com/keys/microsoft.asc | apt-key add -
RUN curl https://packages.microsoft.com/config/debian/10/prod.list > /etc/apt/sources.list.d/mssql-release.list

RUN apt-get install -y locales \
    && echo "en_US.UTF-8 UTF-8" > /etc/locale.gen \
    && locale-gen \
    && apt-get update \
    && ACCEPT_EULA=Y apt-get -y --no-install-recommends install \
        unixodbc-dev \
        msodbcsql17

RUN apt-get install --no-install-recommends -y \
    gcc make autoconf pkg-config libc-dev g++ libffi-dev libxml2 libmcrypt-dev

# Install xdebug
RUN pecl install xdebug-2.8.0 && \
    docker-php-ext-enable xdebug

RUN pecl install mcrypt-snapshot

# Install PHP extensions
RUN docker-php-ext-install mbstring pdo pdo_mysql \
    && pecl install sqlsrv pdo_sqlsrv \
    && docker-php-ext-enable sqlsrv pdo_sqlsrv

# Install redis
RUN pecl install redis-5.1.1 && \
    docker-php-ext-enable redis

# Other PHP7 Extensions
RUN docker-php-ext-install pdo_mysql && \
    docker-php-ext-install pdo_sqlite && \
    docker-php-ext-install mysqli && \
    docker-php-ext-install curl && \
    docker-php-ext-install tokenizer && \
    docker-php-ext-install json && \
    docker-php-ext-install zip && \
    docker-php-ext-install -j$(nproc) intl && \
    docker-php-ext-install mbstring && \
    docker-php-ext-install gettext

# Install Freetype
RUN apt-get -y update && \
    apt-get --no-install-recommends install -y libfreetype6-dev \
libjpeg62-turbo-dev \
libpng-dev && \
    rm -rf /var/lib/apt/lists/* && \
    docker-php-ext-configure gd --enable-gd --with-freetype --with-jpeg && \
    docker-php-ext-install gd

# Enable apache modules
RUN a2enmod rewrite headers

# Cleanup
RUN rm -rf /usr/src/*

# fxp/composer-asset-plugin
RUN composer global require "fxp/composer-asset-plugin:dev-master"

# RUN useradd -ms /bin/bash user
#RUN usermod -a -G www-data user
#WORKDIR /var/www/html
#ENV HOME /home/html

RUN chmod -R 775 /var/www && \
    chown -R www-data:www-data /var/www
RUN umask 775 /var/www

# set apache run with ubuntu user
RUN sed -i "s/APACHE_RUN_USER:=www-data/APACHE_RUN_USER=www-data/g" /etc/apache2/envvars
RUN sed -i "s/APACHE_RUN_GROUP:=www-data/APACHE_RUN_GROUP=www-data/g" /etc/apache2/envvars
#RUN chown -R www-data:www-data /var/www/html
# RUN chmod g+w /var/www/html/assets
# RUN chmod g+w /var/www/html/_protected/runtime/session
#RUN chmod -R ug+rw /var/www/html
RUN service apache2 restart
