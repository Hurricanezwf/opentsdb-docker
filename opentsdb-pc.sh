#!/bin/bash

set -e

WorkDir=`pwd`

# 本地HBase数据目录
LocalHBaseDir=${WorkDir}/data/hbase-pc/

function start(){
    mkdir -p $LocalHBaseDir

    eval "docker run -d \
        --name opentsdb-pc\
        -v ${LocalHBaseDir}:/data/hbase/ \
        -p 4244:4242 \
        opentsdb-docker:2.2"
}

function stop(){
    docker stop opentsdb-pc
}

function remove(){
    docker stop opentsdb-pc
    docker rm -v opentsdb-pc
}

function reset(){
    stop
    remove
}

function enter(){
    docker exec -it opentsdb-pc /bin/bash
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
        echo "Usage: ./opentsdb-pc.sh [start|stop|rm|reset|enter]"
        exit 1
        ;;
esac
exit 0
