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

# in win+virtualbox,have to be root
# in pro :
# use root to start php-fpm
# use nobody to run php-fpm sub process
# sets the root dir belong to nobody in cm
# sets the root dir belong to nobody in vm/pm
# or other user but not root
# add -R arg to allow root user
CMD ["php-fpm","-R"]
######
# You can install php extensions using docker-php-ext-install
######
#RUN apt-get update && apt-get install -y \
#        libfreetype6-dev \
#        libjpeg62-turbo-dev \
#        libmcrypt-dev \
#        libpng12-dev \
#    && docker-php-ext-install -j\$(nproc) iconv mcrypt \
#    && docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
#    && docker-php-ext-install -j\$(nproc) gd
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
