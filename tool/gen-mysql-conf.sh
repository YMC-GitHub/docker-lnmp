#!/bin/sh

THIS_FILE_PATH=$(
    cd $(dirname $0)
    pwd
)
source $THIS_FILE_PATH/function-list.sh
THIS_PROJECT_PATH=$(path_resolve "$THIS_FILE_PATH" "../")
RUN_SCRIPT_PATH=$(pwd)
function main_fun() {

    local PM_PATH=
    local CM_PATH=
    local name=
    local TXT=
    local file=

    PM_PATH="$THIS_PROJECT_PATH/mysql/conf/"
    CM_PATH=/etc/nginx/
    name=my
    file="${PM_PATH}${name}.cnf"
    TXT=$(
        cat <<EOF
[mysqld]
user=mysql
default-storage-engine=INNODB
character-set-server=utf8
explicit_defaults_for_timestamp=true
[client]
default-character-set=utf8
[mysql]
default-character-set=utf8
EOF
    )
    mkdir -p "$PM_PATH"
    echo "gen mysql conf:$file"
    TXT=$(echo "$TXT" | sed "s/^ *#.*//g" | sed "/^$/d")
    echo "$TXT" >"$file"
}
main_fun
#### usage
#./tool/gen-mysql-conf.sh
