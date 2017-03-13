#!/usr/bin/env bash

SETCOLOR_SUCCESS="echo -en \\033[1;32m"
SETCOLOR_FAILURE="echo -en \\033[1;31m"
SETCOLOR_NORMAL="echo -en \\033[0;39m"

#ps -eo 'cmd,stat' |grep "php-fpm.*master" | sed 's/(.)*.{2\}$//' process_log.txt

echo "################################################################################################################" >> ./process_status_log.txt
ps -eo 'cmd,tty,pid,stat,start_time,user,pid,pcpu,size' >> ./process_status_log.txt

ps -eo 'cmd,tty,pid,stat,start_time,user,pid,pcpu,size' |grep "php-fpm.*master" >> ./process_status_log.txt

echo "################################### PHP-FPM MASTER PROCESS STATUS###############################################" >> ./process_status_log.txt


#status=`ps -eo 'cmd,stat' |grep "php-fpm.*master" | grep -o 'php-fpm:.*' | grep -o '..$'`
status="Ss"
#ps -eo 'cmd,stat' |grep "php-fpm.*master" | grep -o 'php-fpm:.*' | grep -o '..$' >> ./process_status_log.txt
## Получаем наш статус и записываем его в переменную, а так же в файл
echo Process status is - ${status} | tee --append ./process_status_log.txt

if [ ${status} ==  "S+" -o "Ss" -o "R+" ]; then
    $SETCOLOR_SUCCESS
    echo -n "Process health is $(tput hpa $(tput cols))$(tput cub 6)[OK]"
    $SETCOLOR_NORMAL
    echo
    exit 0
else
    $SETCOLOR_FAILURE
    echo -n "Process status is -$(status) $(tput hpa $(tput cols))$(tput cub 6)[fail]"
    $SETCOLOR_NORMAL
    echo
    exit 1
fi

#if [ ${status} ==  "S+" -o "Ss" -o "R+" ]
#then
#echo 'Process is running'
#fi
echo "################################################################################################################" >> ./process_status_log.txt

