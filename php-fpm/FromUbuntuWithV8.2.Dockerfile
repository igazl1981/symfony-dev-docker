FROM ubuntu:18.04

RUN add-apt-repository ppa:ondrej/php
RUN apt-get update && apt-get install -y software-properties-common
RUN apt-get update
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
        php7.4-fpm php7.4-common php7.4-mysql php7.4-xml php7.4-xmlrpc php7.4-curl php7.4-gd php7.4-imagick php7.4-cli php7.4-dev php7.4-imap php7.4-mbstring php7.4-soap php7.4-zip php7.4-bcmath

RUN sed -i 's/listen = \/run\/php\/php7.4-fpm.sock/listen = 9000/g' /etc/php/7.4/fpm/pool.d/www.conf

RUN DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
        build-essential curl git python libglib2.0-dev

WORKDIR /tmp

RUN git clone https://chromium.googlesource.com/chromium/tools/depot_tools.git
RUN fetch v8
RUN cd v8

# (optional) If you'd like to build a certain version:
RUN git checkout 8.0.426.30
RUN gclient sync
RUN tools/dev/v8gen.py -vv x64.release -- is_component_build=true use_custom_libcxx=false
RUN mkdir -p /opt/v8/{lib,include}
RUN cp out.gn/x64.release/lib*.so out.gn/x64.release/*_blob.bin \
        out.gn/x64.release/icudtl.dat /opt/v8/lib/
RUN cp -R include/* /opt/v8/include/


EXPOSE 9000

CMD ["php-fpm7.4", "-F", "-O"]

