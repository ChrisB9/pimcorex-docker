ARG FROM=webdevops/php-nginx-dev:8.0
FROM $FROM

COPY --from=mlocati/php-extension-installer /usr/bin/install-php-extensions /usr/bin/

RUN set -eux; \
    apt-get update; \
    apt-get install -y lsb-release; \
    echo "deb http://deb.debian.org/debian $(lsb_release -sc)-backports main" > /etc/apt/sources.list.d/backports.list; \
    apt-get update; \
    DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
        autoconf \
        automake \
        build-essential \
        bash-completion \
        cmake \
        cron \
        curl \
        dpkg-dev \
        exiftool \
        exa \
        ffmpeg \
        g++ \
        ghostscript \
        git \
        graphviz \
        html2text \
        inkscape \
        iputils-ping \
        jpegoptim \
        libbz2-dev \
        libc-client-dev \
        libdjvulibre-dev \
        libfftw3-dev \
        libfontconfig1-dev \
        libfreetype6-dev \
        libicu-dev \
        libjpeg-dev \
        libjpeg62-turbo-dev \
        libkrb5-dev \
        liblcms2-dev \
        liblqr-1-0-dev \
        libltdl-dev \
        liblzma-dev \
        libonig-dev \
        libopenexr-dev \
        libopenjp2-7-dev \
        libpango1.0-dev \
        libpng-dev \
        libreoffice \
        librsvg2-dev \
        libtiff-dev \
        libtool \
        libwebp-dev \
        libwmf-dev \
        libx11-dev \
        libxext-dev \
        libxml2-dev \
        libxpm-dev \
        libxslt1-dev \
        libxslt1.1 \
        libxt-dev \
        libz-dev \
        libzip-dev \
        locales \
        locales-all \
        make \
        nasm \
        ninja-build \
        opencv-data \
        openssl \
        pkg-config \
        pngcrush \
        poppler-utils \
        python3-pip \
        ufraw \
        unzip \
        webp \
        wget \
        zlib1g-dev \
        && curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- --default-toolchain stable -y

RUN install-php-extensions \
    apcu \xdebug-^3 \
    mongodb \
    zip \
    soap \
    gd \
    pcntl \
    redis \
    imagick

RUN set -eux; \
    cd /tmp; \
    \
    wget https://github.com/wkhtmltopdf/wkhtmltopdf/releases/download/0.12.4/wkhtmltox-0.12.4_linux-generic-amd64.tar.xz; \
        tar xvf wkhtmltox-0.12.4_linux-generic-amd64.tar.xz; \
        mv wkhtmltox/bin/wkhtmlto* /usr/bin/; \
    \
    git clone https://github.com/mozilla/mozjpeg.git ; \
        cd mozjpeg; \
        cmake -G"Unix Makefiles"; \
        make; \
        make install; \
        cd ..; \
    \
    git clone https://gitlab.com/wavexx/facedetect; \
        pip3 install --no-cache-dir --upgrade pip setuptools wheel; \
        pip3 install --no-cache-dir scikit-build; \
        pip3 install --no-cache-dir numpy opencv-python; \
        cd facedetect; \
        cp facedetect /usr/local/bin; \
        cd ..; \
    \
    git clone https://github.com/google/zopfli.git; \
        cd zopfli; \
        make; \
        cp zopfli /usr/bin/zopflipng; \
        cd ..; \
    \
    wget http://static.jonof.id.au/dl/kenutils/pngout-20150319-linux.tar.gz; \
        tar -xf pngout-20150319-linux.tar.gz; \
        rm pngout-20150319-linux.tar.gz; \
        cp pngout-20150319-linux/x86_64/pngout /bin/pngout; \
    \
    wget http://prdownloads.sourceforge.net/advancemame/advancecomp-1.17.tar.gz; \
        tar zxvf advancecomp-1.17.tar.gz; \
        cd advancecomp-1.17; \
        ./configure; \
        make; \
        make install; \
        cd ..; \
    \
    curl -sL https://deb.nodesource.com/setup_14.x | bash -; \
        apt-get install -y nodejs; \
        npm install -g sqip yarn; \
        npm cache clean --force

RUN wget https://github.com/dalance/amber/releases/download/v0.5.8/amber-v0.5.8-x86_64-lnx.zip \
    && unzip amber-v0.5.8-x86_64-lnx.zip \
    && rm amber-v0.5.8-x86_64-lnx.zip \
    && mv amb* /usr/local/bin/

    RUN apt-get update && \
  apt-get install -y sudo vim bash-completion mariadb-client && \
  usermod -aG sudo application && \
  echo "%sudo ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers && \
  cargo install broot

RUN cd /tmp \
        && apt-get update && apt-get install -y libperl-dev python3-pip \
        && export NGVER=$(nginx -v 2>&1 >/dev/null | cut -d/ -f 2) \
        && wget https://nginx.org/download/nginx-${NGVER}.tar.gz && tar zxf nginx-${NGVER}.tar.gz && rm nginx-${NGVER}.tar.gz \
        && mv nginx-${NGVER}/ nginx-src/ \
        && git clone https://github.com/google/ngx_brotli.git \
        && cd ngx_brotli && git submodule update --init && cd ../nginx-src \
        && ./configure \
                --with-http_ssl_module \
        		--with-http_realip_module \
        		--with-http_addition_module \
        		--with-http_sub_module \
        		--with-http_dav_module \
        		--with-http_flv_module \
        		--with-http_mp4_module \
        		--with-http_gunzip_module \
        		--with-http_gzip_static_module \
        		--with-http_random_index_module \
        		--with-http_secure_link_module \
        		--with-http_stub_status_module \
        		--with-http_auth_request_module \
        		--with-http_perl_module=dynamic \
        		--with-threads \
        		--with-stream \
        		--with-stream_ssl_module \
        		--with-stream_ssl_preread_module \
        		--with-stream_realip_module \
        		--with-http_slice_module \
        		--with-mail \
        		--with-mail_ssl_module \
        		--with-compat \
        		--with-file-aio \
        		--with-http_v2_module \
                --with-compat \
                --add-dynamic-module=../ngx_brotli \
        && make modules \
        && cp objs/*.so /usr/lib/nginx/modules \
        && mkdir -p /etc/nginx/modules-enabled \
        && echo "load_module modules/ngx_http_brotli_filter_module.so;" >> /etc/nginx/modules-enabled/brotli.conf \
        && echo "load_module modules/ngx_http_brotli_static_module.so;" >> /etc/nginx/modules-enabled/brotli.conf \
        && rm -rf /var/lib/apt/lists/* \
        && rm -rf /tmp/install-nginx \
        && sed -i 's/user www-data;/user application application;/g' /etc/nginx/nginx.conf

COPY nginx.conf /etc/nginx/nginx.conf


RUN apt-get autoremove -y; \
        apt-get remove -y autoconf automake libtool nasm make cmake ninja-build pkg-config libz-dev build-essential g++; \
        apt-get clean; rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /usr/share/doc/* ~/.composer

# https://stackoverflow.com/questions/52998331/imagemagick-security-policy-pdf-blocking-conversion#comment110879511_59193253
RUN sed -i '/disable ghostscript format types/,+6d' /etc/ImageMagick-6/policy.xml

RUN curl https://raw.githubusercontent.com/git/git/v$(git --version | awk 'NF>1{print $NF}')/contrib/completion/git-completion.bash > /home/$APPLICATION_USER/.git-completion.bash && \
curl https://raw.githubusercontent.com/git/git/v$(git --version | awk 'NF>1{print $NF}')/contrib/completion/git-prompt.sh > /home/$APPLICATION_USER/.git-prompt.sh && \
curl https://raw.githubusercontent.com/ogham/exa/master/completions/bash/exa > /home/$APPLICATION_USER/.completions.bash

RUN docker-service enable postfix

COPY additional_bashrc.sh /home/$APPLICATION_USER/.additional_bashrc.sh
RUN echo "source ~/.additional_bashrc.sh" >> /home/$APPLICATION_USER/.bashrc
COPY pimcore.conf /opt/docker/etc/nginx/vhost.common.d/00-pimcore.conf
COPY php.ini /opt/docker/etc/php/php.webdevops.ini
COPY entrypoints/entrypoint.sh /opt/docker/bin/entrypoint.sh
COPY entrypoints/uid-gid.sh /opt/docker/provision/entrypoint.d/00-application-uid-gid.sh

WORKDIR /app/
