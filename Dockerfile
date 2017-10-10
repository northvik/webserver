FROM ubuntu:16.04

RUN apt-get update && apt-get install -y --no-install-recommends \
		apache2 \
		software-properties-common \
        git \
        gcc \
        curl \
        mysql-client \
	&& apt-get clean \
	&& rm -fr /var/lib/apt/lists/*

RUN LC_ALL=C.UTF-8 add-apt-repository ppa:ondrej/php

RUN apt-get update \
	&& apt-get install -y --no-install-recommends \
        libapache2-mod-php5.6 \
        php5.6 \
        php5.6-cli \
        php5.6-curl \
        php5.6-dev \
        php5.6-gd \
        php5.6-imap \
        php5.6-mbstring \
        php5.6-mcrypt \
        php5.6-mysql \
        php5.6-pgsql \
        php5.6-pspell \
        php5.6-xml \
        php5.6-xmlrpc \
        php-apcu \
        php-memcached \
        php-pear \
        php-redis \
    && apt-get clean \
    && rm -fr /var/lib/apt/lists/*


RUN echo "ServerName localhost" >> /etc/apache2/apache2.conf

WORKDIR /tmp

COPY composer-setup.php composer-setup.php
RUN  php composer-setup.php --install-dir=/usr/local/bin --filename=composer 

RUN a2enmod rewrite \
    && a2enmod headers
COPY apache.conf /etc/apache2/sites-available/000-default.conf

RUN ln -sf /dev/stdout /var/log/apache2/access.log \
    && ln -sf /dev/stderr /var/log/apache2/error.log

EXPOSE 80
CMD ["apachectl", "-D", "FOREGROUND"]