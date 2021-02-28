FROM php:7.4-fpm-buster

COPY wait-for-it.sh /usr/bin/wait-for-it

RUN chmod +x /usr/bin/wait-for-it

RUN apt-get update -y --fix-missing && apt-get upgrade -y;

RUN apt-get install -y git

RUN docker-php-ext-install pdo_mysql

COPY --from=composer /usr/bin/composer /usr/bin/composer

WORKDIR /var/www

CMD wait-for-it database:3306;  php-fpm
# Removed extra steps on startup
#CMD composer install ; wait-for-it database:3306 -- bin/console doctrine:migrations:migrate ;  php-fpm

EXPOSE 9000
