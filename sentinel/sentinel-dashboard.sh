#!/bin/sh
APP_NAME=sentinel-dashboard
#jar��·��
JAR_PATH='/usr/local/work/cloud'
#jar����
JAR_NAME=sentinel-dashboard-1.7.2.jar
#��־·��
LOG_PATH='/usr/local/work/logs'
#PID  ������PID�ļ�
PID=$JAR_NAME\.pid
 
#ʹ��˵����������ʾ�������
usage() {
    echo "Usage: sh ִ�нű�.sh [start|stop|restart|status]"
    exit 1
}
 
#�������Ƿ�������
is_exist(){
  pid=`ps -ef|grep $JAR_NAME|grep -v grep|awk '{print $2}' `
  #��������ڷ���1�����ڷ���0    
  if [ -z "${pid}" ]; then
   return 1
  else
    return 0
  fi
}
 
#��������
start(){
  is_exist
  if [ $? -eq "0" ]; then
    echo ">>> $APP_NAME is already running PID=${pid} <<<"
  else
    nohup java -Dserver.port=8600 -Dcsp.sentinel.dashboard.server=localhost:8600 -Dproject.name=sentinel-dashboard -jar $JAR_PATH/$JAR_NAME >> $LOG_PATH/$APP_NAME.log 2>&1 &
    echo $! > $PID
    echo ">>> start $APP_NAME successed PID=$! <<<"
   fi
  }
 
#ֹͣ����
stop(){
  #is_exist
  pidf=$(cat $PID)
  #echo "$pidf" 
  echo ">>> PID = $pidf begin kill $pidf <<<"
  kill $pidf
  rm -rf $PID
  sleep 2
  is_exist
  if [ $? -eq "0" ]; then
    echo ">>> PID = $pid begin kill -9 $pid  <<<"
    kill -9  $pid
    sleep 2
    echo ">>> $APP_NAME process stopped <<<" 
  else
    echo ">>> $APP_NAME is not running <<<"
  fi 
}
 
#�������״̬
status(){
  is_exist
  if [ $? -eq "0" ]; then
    echo ">>> $APP_NAME is running PID is ${pid} <<<"
  else
    echo ">>> $APP_NAME is not running <<<"
  fi
}
 
#����
restart(){
  stop
  start
}
 
#�������������ѡ��ִ�ж�Ӧ��������������ִ��ʹ��˵��
case "$1" in
  "start")
    start
    ;;
  "stop")
    stop
    ;;
  "status")
    status
    ;;
  "restart")
    restart
    ;;
  *)
    usage
    ;;
esac
exit 0