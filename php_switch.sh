#!/bin/bash
#切换php版本 重启nginx php-fpm
#strugglelinux@gmail.com
#
# ./php_switch.sh 5   switch php5
#
php_dir="/usr/local/php$1"
php_bin_dir="$php_dir/bin"
php_sbin_dir="$php_dir/sbin"
nginx_dir="/usr/local/nginx"
nginx_sbin_dir="$nginx_dir/sbin"

if [ -d $php_dir ] 
then 
    #判断php-fpm 是否存在
    msg={`ps -ef | grep "php-fpm"`}
    if  [[ "$msg" != "" ]]  #存在
    then 
        kill={`pkill -9 php-fpm`} #终止 php-fpm
    fi 
    run_fmp_cmd={`$php_sbin_dir/php-fpm  >& /dev/null &`} #启动 php-fpm
    msg={`ps -ef | grep "$php_sbin_dir/php-fpm"`}
    if [[ "$msg" != "" ]]  #存在
    then 
        echo  "$php_sbin_dir/php-fpm 启动成功"
    fi
    #判断nginx是否启动
    nginx={`ps -ef | grep "nginx"`}
    opt=""
    if  [[ "$nginx" != "" ]]
    then 
        reload={`$nginx_sbin_dir/nginx -s reload`}  #重启
        opt="reload"
    else
        start={`$nginx_sbin_dir/nginx -c $nginx_dir/conf/nginx.conf`} #启动
        opt="start"
    fi 
    nginx={`ps -ef | grep "$nginx_sbin_dir/nginx"`}
    if [[ "$nginx" != "" ]]  #存在
    then 
        echo  "$nginx_sbin_dir/nginx ${opt} 成功"
    fi
else 
    echo "无对应版本 php $1"
    exit
fi