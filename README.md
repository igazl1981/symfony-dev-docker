# Symfony development env

The repository contains 3 images, and a compose file to start an environment for Symfony.

# nginx

1. Check the docker-compose.yml for nginx setup and change `workspace` to the symfony directory you want to run.
2. Update the `root` directory where the public files are.
    2.a. `root /var/www/symfony-5-ssr/public;` means the `workspace/symfony-5-ssr` is a directory with Symfony installed in it.
   
# php-fpm

There are several Dockerfile for getting php-fpm ready.

# FromStesieLibV8.Dockerfile

This adds php 7.4 and compiles V8js on its own because the `pecl` version of `v8js` v2.1.1 can not be compiled.

# FromUbuntuXenial.Dockerfile

This is an `Xenial` version of ubuntu to be able to use `ppa:pinepain/libv8` PPA as it does not have repository for `Bionic`.

The PHP is 7.2 because the `v8js` can be installed by `pecl` with this version.

## FromOfficialPhp.Dockerfile

It uses the official `php-fpm` image and installs the composer for managing the symfony apps.

## FromUbuntu.Dockerfile

It uses ubuntu as a base and installs the 7.4 version of php.

# database

It is a regular `mariadb` image where the init.sql is mapped into the container which will build the initial database if needed.

