#!/bin/sh

THIS_FILE_PATH=$(
  cd $(dirname $0)
  pwd
)
source $THIS_FILE_PATH/function-list.sh
THIS_PROJECT_PATH=$(path_resolve "$THIS_FILE_PATH" "../")
RUN_SCRIPT_PATH=$(pwd)

function add_nginx() {
  local TXT=
  TXT=$(
    cat <<EOF
# static web serve with nginx
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
FROM php:7.2-fpm-alpine
MAINTAINER ${author} <${email}>

# Use the default production configuration
#RUN cp "$PHP_INI_DIR/php.ini-production" "$PHP_INI_DIR/php.ini"

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
# See: https://hub.docker.com/_/mysql/
######
# data serve with mysql
FROM mysql:5.7
MAINTAINER ${author} <${email}>
ENV MYSQL_ALLOW_EMPTY_PASSWORD yes
#https://www.jb51.net/article/115422.htm
#VOLUME /etc/mysql
#VOLUME /var/log/mysql
#VOLUME /var/lib/mysql
RUN chown mysql:mysql /var/lib/mysql
#RUN chown $(whoami):$(whoami) /var/lib/mysql && echo $(whoami)
#fix:[Warning] root@localhost is created with an empty password ! Please consider switching off the --initialize-insecure option.
#deletes  --initialize arg
CMD ["--datadir=/var/lib/mysql"]
#
#https://blog.csdn.net/qq_27437073/article/details/79623855
#https://www.cnblogs.com/tanq/p/11235356.html
#https://blog.csdn.net/chengqiuming/article/details/79038772
#https://www.cnblogs.com/linxiyue/p/8229048.html
#https://www.cnblogs.com/songanwei/p/9167326.html
# 进阶：
# 在alpine中运行mysql
#https://blog.phpgao.com/run_mysql_in_alpine.html

EOF
  )
  TXT=$(echo "$TXT" | sed "s/^ *#.*//g" | sed "/^$/d")
  echo "$TXT"
}

function main_fun() {
  local path=
  local TXT=
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
