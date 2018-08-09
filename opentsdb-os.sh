#!/bin/bash

set -e

WorkDir=`pwd`

# 本地HBase数据目录
LocalHBaseDir=${WorkDir}/data/hbase-os/

function start(){
    mkdir -p $LocalHBaseDir

    eval "docker run -d \
        --name opentsdb-os \
        -p 4243:4242 \
        -v ${LocalHBaseDir}:/data/hbase/ \
        opentsdb-docker:2.2"
}

function stop(){
    docker stop opentsdb-os
}

function remove(){
    docker stop opentsdb-os
    docker rm -v opentsdb-os
}

function reset(){
    stop
    remove
}

function enter(){
    docker exec -it opentsdb-os /bin/bash
}


case $1 in
    start)
        start
        ;;
    stop)
        stop
        ;;
    rm)
        remove 
        ;;
    reset)
        reset
        ;;
    enter)
        enter
        ;;
    *)
        echo "Usage: ./opentsdb-os.sh [start|stop|rm|reset|enter]"
        exit 1
        ;;
esac
exit 0
