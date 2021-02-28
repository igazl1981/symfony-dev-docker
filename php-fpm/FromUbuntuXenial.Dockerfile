FROM ubuntu:16.04

RUN  apt-get update && apt-get install -y software-properties-common python-software-properties language-pack-en-base
RUN DEBIAN_FRONTEND=noninteractive LC_ALL=C.UTF-8 add-apt-repository ppa:ondrej/php
RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
    php7.2-fpm php7.2-common php7.2-mysql php7.2-xml php7.2-xmlrpc php7.2-curl \
    php7.2-gd php7.2-imagick php7.2-cli php7.2-dev php7.2-imap php7.2-mbstring \
    php7.2-soap php7.2-zip php7.2-bcmath

RUN sed -i 's/listen = \/run\/php\/php7.2-fpm.sock/listen = 9000/g' /etc/php/7.2/fpm/pool.d/www.conf

RUN add-apt-repository ppa:pinepain/libv8
RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
    php-pear g++ libv8-6.6-dev \
    nano

RUN pecl channel-update pecl.php.net
RUN pecl install --configureoptions 'with-v8js="/opt/libv8-6.6/"' v8js-2.1.0
RUN echo 'extension=v8js.so' > /etc/php/7.2/mods-available/v8js.ini
RUN phpenmod v8js
RUN mkdir /run/php

EXPOSE 9000

CMD ["php-fpm7.2", "-F", "-O"]
