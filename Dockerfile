# syntax=docker/dockerfile:1.4

FROM composer as composer

WORKDIR /app

COPY database/ /app/database/
COPY composer.json composer.lock /app/

RUN composer install \
        --no-dev \
        --prefer-dist \
        --no-ansi \
        --no-interaction \
        --no-scripts \
        --no-plugins \
        --optimize-autoloader \
        --ignore-platform-reqs

# Add Build Dependencies
FROM starubiquitous/laravel-env:main

COPY --from=composer /usr/bin/composer /usr/bin/composer
ENV COMPOSER_ALLOW_SUPERUSER=1

WORKDIR /app

COPY --from=composer /app/vendor /app/vendor
COPY . .
COPY .docker/docker-entrypoint.sh /app/
COPY .docker/www.conf /usr/local/etc/php-fpm.d/www.conf

RUN mkdir -p /run/nginx; \
    mkdir -p storage; \
    mkdir -p storage/framework/cache; \
    mkdir -p storage/framework/sessions; \
    mkdir -p storage/framework/testing; \
    mkdir -p storage/framework/views; \
    mkdir -p storage/logs; \
    chmod -R 777 storage bootstrap/cache;\
    chmod +x /app/docker-entrypoint.sh;\
    cp .env.production .env; \
    php artisan key:generate --ansi; \
    php artisan config:clear; \
    php artisan config:cache; \
    composer dump-autoload --optimize ;\
    rm -rf composer.lock package.json .docker .env.example .env.production

COPY .docker/nginx.conf /etc/nginx/http.d/default.conf
COPY .docker/supervisord.conf /etc/supervisor/conf.d/supervisord.conf

VOLUME [ "/app" ]

EXPOSE 80

ENTRYPOINT ["/app/docker-entrypoint.sh"]
