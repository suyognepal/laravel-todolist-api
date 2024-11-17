FROM php:8.3 as php

RUN apt-get update -y && apt-get install -y \
    unzip \
    libpq-dev \
    libcurl4-gnutls-dev \
    && docker-php-ext-install pdo pdo_mysql bcmath \
    && pecl install -o -f redis \
    && rm -rf /tmp/pear \
    && docker-php-ext-enable redis

RUN useradd -m phpuser && chown -R phpuser:phpuser /var/www

WORKDIR /var/www

COPY . .

COPY --from=composer:2.3.5 /usr/bin/composer /usr/bin/composer

RUN composer install && rm composer.lock

ENV PORT=8000

USER phpuser

ENTRYPOINT [ ".helpers/entrypoint.sh" ]