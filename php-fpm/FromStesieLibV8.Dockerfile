FROM stesie/libv8-8.4 AS builder
MAINTAINER Stefan Siegl <stesie@brokenpipe.de>

RUN apt-get update
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
        software-properties-common && \
    DEBIAN_FRONTEND=noninteractive LC_ALL=C.UTF-8 add-apt-repository ppa:ondrej/php && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
        php7.4-dev git ca-certificates g++ make \
        unzip curl

RUN git clone https://github.com/phpv8/v8js.git /usr/local/src/v8js
WORKDIR /usr/local/src/v8js

RUN phpize
RUN ./configure --with-v8js=/opt/libv8-8.4 LDFLAGS="-lstdc++" CPPFLAGS="-DV8_COMPRESS_POINTERS"
RUN make all -j4

FROM stesie/libv8-8.4
COPY --from=builder /usr/local/src/v8js/modules/v8js.so /usr/lib/php/20190902/

RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
        software-properties-common && \
    DEBIAN_FRONTEND=noninteractive LC_ALL=C.UTF-8 add-apt-repository ppa:ondrej/php && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends php7.4-cli \
        php7.4-fpm php7.4-common php7.4-mysql php7.4-xml php7.4-xmlrpc php7.4-curl php7.4-gd php7.4-imagick php7.4-cli php7.4-dev php7.4-imap php7.4-mbstring php7.4-soap php7.4-zip php7.4-bcmath \
        unzip curl nano && \
    echo extension=v8js.so > /etc/php/7.4/cli/conf.d/99-v8js.ini && \
    echo extension=v8js.so > /etc/php/7.4/fpm/conf.d/99-v8js.ini && \
    apt-get autoremove -y && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*


WORKDIR /tmp

RUN curl -sS https://getcomposer.org/installer -o composer-setup.php && \
    php composer-setup.php --install-dir=/usr/local/bin --filename=composer

WORKDIR /var/www

EXPOSE 9000

CMD ["php-fpm7.4", "-F", "-O"]

