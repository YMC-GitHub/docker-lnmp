#!/bin/sh

THIS_FILE_PATH=$(
    cd $(dirname $0)
    pwd
)
source $THIS_FILE_PATH/function-list.sh
THIS_PROJECT_PATH=$(path_resolve "$THIS_FILE_PATH" "../")
RUN_SCRIPT_PATH=$(pwd)

TXT=$(
    cat $THIS_FILE_PATH/readme.md
)
echo "gen readme.md :$THIS_PROJECT_PATH/readme.md"
echo "$TXT" >"$THIS_PROJECT_PATH/readme.md"

function write_introduction() {
    echo "write_introduction" >/dev/null 2>&1
}
function write_architecture() {
    echo "write_architecture" >/dev/null 2>&1
}
function write_build() {
    echo "write_build" >/dev/null 2>&1
}
function write_run() {
    echo "write_run" >/dev/null 2>&1
}
function write_contributors() {
    echo "write_contributors" >/dev/null 2>&1
    local TXT=
    TXT=$(
        cat <<EOF
Micooz micooz@hotmail.com
sndnvaps sndnvaps@gmail.com
ymc-github yemiancheng@gmail.com
EOF
    )
    echo "$TXT"
}
#### usage
#./tool/gen-readme.sh
