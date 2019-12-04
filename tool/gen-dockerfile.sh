#!/bin/sh

THIS_FILE_PATH=$(
  cd $(dirname $0)
  pwd
)
source $THIS_FILE_PATH/function-list.sh
THIS_PROJECT_PATH=$(path_resolve "$THIS_FILE_PATH" "../")
RUN_SCRIPT_PATH=$(pwd)

function add_mysql() {
  local author=
  local email=
  local TXT=
  author=ymc-github
  email=yemiancheng@gmail.com
  local TXT=
  TXT=$(
    cat <<EOF
######
# See: https://github.com/YMC-GitHub/mirror-mysql
######
# data serve with mysql
FROM registry.cn-hangzhou.aliyuncs.com/yemiancheng/mysql:alpine-3.10.3
EXPOSE 3306
#set timezone
#uses local pm time with -v /etc/localtime:/etc/localtime in compose file
#RUN apk add -U tzdata &&  cp "/usr/share/zoneinfo/Asia/Shanghai" "/etc/localtime" && apk del tzdata
#COPY \$(pwd)/mysql/conf/my.cnf /etc/mysql/my.cnf
EOF
  )
  TXT=$(echo "$TXT" | sed "s/^ *#.*//g" | sed "/^$/d")
  echo "$TXT"
}

function add_php_fpm() {
  local author=
  local email=
  local TXT=
  author=ymc-github
  email=yemiancheng@gmail.com
  TXT=$(
    cat <<EOF
######
# See: https://hub.docker.com/_/php/
######
#FROM php:7.2-fpm-alpine
FROM php:7.4.0-fpm-alpine
MAINTAINER ${author} <${email}>
#VOLUME /var/www/html
# Use the default production configuration
#RUN cp "$PHP_INI_DIR/php.ini-production" "$PHP_INI_DIR/php.ini"
#set timezone
#uses local pm time with -v /etc/localtime:/etc/localtime in compose file
#RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.aliyun.com/g' /etc/apk/repositories && apk add -U tzdata &&  cp "/usr/share/zoneinfo/Asia/Shanghai" "/etc/localtime" && apk del tzdata

######
# You can install php extensions using docker-php-ext-install
######
#RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.aliyun.com/g' /etc/apk/repositories &&  apk add -U --no-cache autoconf g++ libtool make curl-dev libxml2-dev linux-headers && docker-php-ext-install -j\$(nproc) pdo_mysql  && docker-php-ext-install -j\$(nproc) mysqli && docker-php-ext-install -j\$(nproc) mysql
# RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.aliyun.com/g' /etc/apk/repositories \
# && apk update\
# && apk add --no-cache libmcrypt-dev freetype-dev libjpeg-turbo-dev \
#         git \
#         # libfreetype6-dev \
#         # libjpeg62-turbo-dev \
#         libpng-dev \
# && docker-php-ext-install mcrypt mysqli pdo pdo_mysql mbstring bcmath zip opcache\
# && docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ --with-png-dir=/usr/include/ \
# && docker-php-ext-install -j$(nproc) gd
RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.aliyun.com/g' /etc/apk/repositories \
  && docker-php-source extract \
  && docker-php-ext-install mysqli pdo pdo_mysql \
  && docker-php-source delete

# in win+virtualbox,have to be root
# in pro :
# use root to start php-fpm
# use nobody to run php-fpm sub process
# sets the root dir belong to nobody in cm
# sets the root dir belong to nobody in vm/pm
# or other user but not root
# add -R arg to allow root user
CMD ["php-fpm","-R"]


EOF
  )
  TXT=$(echo "$TXT" | sed "s/^ *#.*//g" | sed "/^$/d")
  echo "$TXT"
}

function add_nginx() {
  local author=
  local email=
  local TXT=
  author=ymc-github
  email=yemiancheng@gmail.com
  local TXT=
  TXT=$(
    cat <<EOF
######
# See: https://hub.docker.com/_/nginx/
######
# static serve with nginx
FROM nginx:1.17-alpine
MAINTAINER ${author} <${email}>

#update static file dir belong to nginx to fix 403 error
# or uses the root user run
#RUN chown -R nginx:nginx /usr/share/nginx/html
#set timezone
#uses local pm time with -v /etc/localtime:/etc/localtime in compose file
#RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.aliyun.com/g' /etc/apk/repositories && apk add -U tzdata &&  cp "/usr/share/zoneinfo/Asia/Shanghai" "/etc/localtime" && apk del tzdata
EOF
  )
  TXT=$(echo "$TXT" | sed "s/^ *#.*//g" | sed "/^$/d")
  echo "$TXT"
}

function main_fun() {
  local path=
  local TXT=

  path="$THIS_PROJECT_PATH/nginx/Dockerfile"
  echo "gen Dockerfile.yml :$path"
  TXT=$(add_nginx)
  TXT=$(echo "$TXT" | sed "s/^ *#.*//g" | sed "/^$/d")
  echo "$TXT" >"$path"

  path="$THIS_PROJECT_PATH/php-fpm/Dockerfile"
  echo "gen Dockerfile.yml :$path"
  TXT=$(add_php_fpm)
  TXT=$(echo "$TXT" | sed "s/^ *#.*//g" | sed "/^$/d")
  echo "$TXT" >"$path"

  path="$THIS_PROJECT_PATH/mysql/Dockerfile"
  echo "gen Dockerfile.yml :$path"
  TXT=$(add_mysql)
  TXT=$(echo "$TXT" | sed "s/^ *#.*//g" | sed "/^$/d")
  echo "$TXT" >"$path"
}
main_fun

#### usage
#./tool/gen-dockerfile.sh
