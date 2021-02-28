# Symfony development env

The repository contains 3 images, and a compose file to start an environment for Symfony.

# nginx

1. Check the docker-compose.yml for nginx setup and change `workspace` to the symfony directory you want to run.
2. Update the `root` directory where the public files are.
    2.a. `root /var/www/symfony-5-ssr/public;` means the `workspace/symfony-5-ssr` is a directory with Symfony installed in it.
   
# php-fpm

The compose file uses `FromStesieLibV8.Dockerfile` for building the FPM image.

It contains the V8JS extension too for server-side rendering function.

## FromOfficialPhp.Dockerfile

It uses the official `php-fpm` image and installs the composer for managing the symfony apps.

## FromUbuntu.Dockerfile

It uses ubuntu as a base and installs the 7.4 version of php.

# database

It is a regular `mariadb` image where the init.sql is mapped into the container which will build the initial database if needed.

