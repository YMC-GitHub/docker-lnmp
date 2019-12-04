#!/bin/sh

APP_CODE_PATH=/d/code-store/Shell/forked-docker-lnmp-micooz/app
FE_PATH="${APP_CODE_PATH}/fe"
BE_PATH="${APP_CODE_PATH}/be"
SRC_FE_PATH="${APP_CODE_PATH}/src"
SRC_BE_PATH="${APP_CODE_PATH}/src"
FE_FILE=$(
  cat <<EOF
favicon.ico
index.html
README.md
EOF
)
BE_FILE=$(
  cat <<EOF
index.php
EOF
)

function mv_fe() {
  local list=
  local arr=
  local key=
  local file=
  list="$FE_FILE"
  if [ -n "${1}" ]; then
    list="${1}"
  fi
  list=$(echo "$list" | sed "s/^#.*//g" | sed "/^$/d")
  arr=(${list//,/ })
  # 生成脚本
  for key in ${arr[@]}; do
    file="$SRC_FE_PATH/$key"
    if [ -e $file ]; then
      echo "mv from $SRC_FE_PATH/$key to $FE_PATH/$key"
      mv "$SRC_FE_PATH/$key" "$FE_PATH/$key"
      #git mv "$SRC_BE_PATH/$key" "$BE_PATH/$key"
    fi

  done
}
function mv_be() {
  local list=
  local arr=
  local key=
  local file=
  list="$BE_FILE"
  if [ -n "${1}" ]; then
    list="${1}"
  fi
  list=$(echo "$list" | sed "s/^#.*//g" | sed "/^$/d")
  arr=(${list//,/ })
  # 生成脚本
  for key in ${arr[@]}; do
    file="$SRC_BE_PATH/$key"
    if [ -e $key ]; then
      echo "mv from $SRC_BE_PATH/$key to $BE_PATH/$key"
      mv "$SRC_BE_PATH/$key" "$BE_PATH/$key"
    #git mv "$SRC_BE_PATH/$key" "$BE_PATH/$key"
    fi
  done
}
echo "gen path:$FE_PATH .."
mkdir -p "$FE_PATH"
echo "gen path:$BE_PATH .."
mkdir -p "$BE_PATH"
mv_be
mv_fe
echo "delets path:$SRC_FE_PATH .."
rm -rf "$SRC_FE_PATH"
# then updates nginx config

# updates docker-compose config

# restart cm compose
# docker-compose stop && docker-compose up -d

# curl to relative page  to check

# git commit to repo

#./tool/migrate.sh
