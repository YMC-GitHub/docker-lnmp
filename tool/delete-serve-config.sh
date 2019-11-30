#!/bin/sh

THIS_FILE_PATH=$(
    cd $(dirname $0)
    pwd
)
source $THIS_FILE_PATH/function-list.sh
THIS_PROJECT_PATH=$(path_resolve "$THIS_FILE_PATH" "./")
RUN_SCRIPT_PATH=$(pwd)

function main_fun() {
    local name="Ye Miancheng"
    local email="ymc.github@gmail.com"
    local homepage="https://github.com/YMC-GitHub"
    local TXT=
    local nginx_txt=$(add_nginx)
    local php_fpm_txt=$(add_php_fpm)
    local mysql_txt=$(add_mysql)

    local path=

    # for php-fpm
    path="$THIS_PROJECT_PATH/php-fpm/php.ini"
    echo "delete php.ini :$path"
    rm -rf "$path"
    path="$THIS_PROJECT_PATH/php-fpm/php.ini-production"
    echo "delete php.ini-production :$path"
    rm -rf "$path"

    path="$THIS_PROJECT_PATH/nginx/nginx.conf"
    echo "delete nginx.conf :$path"
    rm -rf "$path"
    path="$THIS_PROJECT_PATH/nginx/conf.d/default.conf"
    echo "delete default.conf :$path"
    rm -rf "$path"
    path="$THIS_PROJECT_PATH/nginx/ca/*"
    echo "delete nginx ca :$path"
    rm -rf "$path"
}
main_fun

#### usage
#./tool/gen-readme.sh
