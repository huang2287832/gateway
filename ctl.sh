#!/bin/sh

start(){
#	nohup ./http_main &
	nohup ./http_main > /dev/null 2> ./log/error.log&     # 忽略输出
	echo ====================服务器启动完毕====================
}

started()
{
	PID=`ps awux | grep http_main | grep -v "grep" | awk '{print $2}'`
	if [ "$PID" != '' ] ; then
		echo "--------------------------------------------------"
		echo ""
		echo ====================服务器已启动====================
		echo ""
		echo "--------------------------------------------------"
		return 0
	else
		echo ====================服务器未启动====================
		return 1
	fi
}

stop(){
    PID=`ps awux | grep http_main | grep -v "grep" | awk '{print $2}'`
	if [ "$PID" != '' ] ; then
		kill -9 ${PID}
		echo ====================服务器已关闭====================
		return 0
	else
		return 1
	fi
}

restart(){
	stop
	start
	echo ====================服务器重启完毕====================
}


# 如果编译的结果需要gdb调试则使用参数-gcflags “-N -l”,会关闭内联优化(可调试版本,性能低)
# 如果编译的结果需要发布.则使用-ldflags “-w -s”,可以去掉调试信息,减小大约一半的大小,关闭内联优化(不可调试版本,性能高)
# -s: 去掉符号信息 -w: 去掉DWARF调试信息
build(){
	go build -ldflags '-w -s' -o http_main main.go
	upx http_main		# 再加壳压缩
	zip -r gateway.zip ./*	# scp -p gateway.zip root@10.154.19.186:~/gateway_server
}

help()
{
	echo " manager  command:     "
	echo " start    以交互方式启动  "
	echo " started  查询服务器是否已启动"
	echo " restart  重启服务器  "
	echo " stop     关闭服务器  "
	echo " build    生成linux包  "
}

case $1 in
	'start') start ;;
	'started') started ;;
	'restart') restart ;;
	'stop') stop ;;
	'build') build ;;
	*) help ;;
esac