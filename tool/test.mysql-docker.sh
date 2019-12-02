#!/bin/sh

THIS_FILE_PATH=$(
    cd $(dirname $0)
    pwd
)
source $THIS_FILE_PATH/function-list.sh
THIS_PROJECT_PATH=$(path_resolve "$THIS_FILE_PATH" "../")
RUN_SCRIPT_PATH=$(pwd)

###
# 生命周期
###
# tag="${hub}${ower}${repo}${label}"
tag=registry.cn-hangzhou.aliyuncs.com/yemiancheng/mysql:5.7
#tag=registry.cn-hangzhou.aliyuncs.com/yemiancheng/mysql:5.7-alipine
# 创建镜像
#docker image build --tag "$tag" ./mysql
# 创建容器
#docker run -p 3306:3306 --name mysql -e MYSQL_ROOT_PASSWORD=123456 -d "$tag"
#issues:mysqld: Can't create directory '/var/lib/mysql/' (Errcode: 17 - File exists)
#fixs:with --CMD ["mysqld","--initialize --datadir=/var/lib/mysql"]
#referencs
#Ubuntu初始化MySQL碰到的坑
#https://www.cnblogs.com/linxiyue/p/8229048.html

#issues: Can't change dir to '/var/lib/mysql/' (Errcode: 13 - Permission denied)

#docker run -d -p 3306:3306 -e MYSQL_ROOT_PASSWORD=123456 --name mysql -v $(pwd)/mysql/conf/my.cnf:/etc/mysql/my.cnf -v $(pwd)/mysql/data:/var/lib/mysql "$tag"

# 容器状态
# docker container ls --all | grep "mysql"
# 进入容器
# docker exec -it mysql bash
# 登数据库
# mysql -uroot -p123456
# 操作数据
# show databases;
# 设置密码
# SET PASSWORD = PASSWORD('yourpwd');
# 查看时区
# show variables like "%time_zone%";
# 看字符集
# SHOW VARIABLES LIKE 'characterset%';
# SHOW VARIABLES LIKE 'collation_%';
# 设字符集
# SET xx 'utf8';

# ...
# 远程登录设置
# grant all privileges on *.* to root@'%' identified by "password";
# use mysql;
# select host,user,password from user;
# tail /var/log/mysql/error.log
# 备份数据
# 恢复数据
# 创建数据
# 删除数据
# 容器日志
# docker container logs mysql
# 开机自启
# docker update --restart=always mysql
# 停止容器
#docker container stop mysql
# 删除容器
#docker container rm mysql
function test_delete() {
    # 停止容器
    docker container stop mysql
    # 删除容器 + 删数据卷
    docker container rm --force --volumes mysql
    # 删数据卷
    ##fix:--initialize specified but the data directory has files in it. Aborting.
    #docker volume prune --force
}
function test_start() {
    # 创建镜像
    docker image build --tag "$tag" ./mysql
    # 查看镜像
    #docker image inspect "$tag"
    docker image ls | grep "mysql"
    # 创建容器
    #docker run -p 3306:3306 --name mysql -e MYSQL_ROOT_PASSWORD=123456 -d "$tag"
    #ok:docker run -p 3306:3306 --name mysql -e MYSQL_ROOT_PASSWORD=123456 -d "$tag"
    #ok:docker run -d -p 3306:3306 -e MYSQL_ROOT_PASSWORD=123456 --name mysql -v $(pwd)/mysql/conf:/etc/mysql -v $(pwd)/mysql/log:/var/log/mysql "$tag"
    #docker run -d -p 3306:3306 -e MYSQL_ROOT_PASSWORD=123456 --name mysql -v $(pwd)/mysql/conf:/etc/mysql -v $(pwd)/mysql/log:/var/log/mysql "$tag"

    #issues:mysqld: Can't create directory '/var/lib/mysql/' (Errcode: 17 - File exists)
    #no:
    echo "docker run -d --user root:0 -p 3306:3306 -e MYSQL_ROOT_PASSWORD=123456 --name mysql -v $(pwd)/mysql/data:/var/lib/mysql \"$tag\""
    docker run -d -p 3306:3306 -e MYSQL_ROOT_PASSWORD=123456 --name mysql --privileged=true -v $(pwd)/mysql/conf/my.cnf:/etc/mysql/my.cnf:ro -v $(pwd)/mysql/data:/var/lib/mysql:rw "$tag"
    #no:docker run -d -p 3306:3306 -e MYSQL_ROOT_PASSWORD=123456 --name mysql -v $(pwd)/mysql/data:/var/lib/mysql "$tag"
    #no:docker run -d -p 3306:3306 -e MYSQL_ROOT_PASSWORD=123456 --name mysql -v $(pwd)/mysql/conf.d:/etc/mysql/conf.d -v $(pwd)/mysql/log:/var/log/mysql -v $(pwd)/mysql/data:/var/lib/mysql --privileged=true "$tag"
    #issues:mysqld: Can't read dir of '/etc/mysql/conf.d/' (Errcode: 13 - Permission denied)
    #no:docker run -d -p 3306:3306 -e MYSQL_ROOT_PASSWORD=123456 --name mysql -v $(pwd)/mysql/conf.d:/etc/mysql/conf.d -v $(pwd)/mysql/log:/var/log/mysql -v $(pwd)/mysql/data:/var/lib/mysql:rw "$tag"
    #issues:cannot create directory '/var/lib/mysql': Permission denied
    #no:docker run -d -p 3306:3306 -e MYSQL_ROOT_PASSWORD=123456 --name mysql -v $(pwd)/mysql/conf:/etc/mysql -v $(pwd)/mysql/log:/var/log/mysql -v $(pwd)/mysql/data:/var/lib/mysql "$tag"
    # 容器状态
    docker container ls --all | grep "mysql"
    # 容器日志
    sleep 4
    docker container logs mysql
}
function add_user() {
    whoami
    #添加用户
    useradd mysql
    #查看用户
    id mysql
    #查看小组
    cat /etc/group | grep mysql
}
function test_debug() {
    # 容器详情
    #docker container inspect mysql
    # 容器日志
    docker container logs mysql
    #2 mysql配置位置
    # ls /etc/mysql/
    #2 mysql日志位置
    # ls /var/log/mysql
    #2 mysql数据位置
    # ls /var/lib/mysql
    #2 mysql安装位置
    # ls  /var/run/mysqld
    #2 mysql使用用户
}
echo "who i am:"
whoami
echo "test delete:"
test_delete
echo "test start:"
test_start
#test_debug

# 查看服务
#2 mysql配置位置
# ls /etc/mysql/
#2 mysql日志位置
# ls /var/log/mysql
#2 mysql数据位置
# ls /var/lib/mysql
#2 mysql安装位置
# ls  /var/run/mysqld
#2 mysql使用用户

# ./tool/test.mysql-docker.sh
