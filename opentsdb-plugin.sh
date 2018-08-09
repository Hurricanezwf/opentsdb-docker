#!/bin/bash

set -e

WorkDir=`pwd`

# 本地HBase数据目录
LocalHBaseDir=${WorkDir}/data/hbase-plugin/


function start(){
    mkdir -p $LocalHBaseDir

    eval "docker run -d \
        --name opentsdb-plugin \
        -p 4242:4242 \
        -v ${LocalHBaseDir}:/data/hbase/ \
        opentsdb-docker:2.2"
}

function stop(){
    docker stop opentsdb-plugin
}

function remove(){
    docker stop opentsdb-plugin
    docker rm -v opentsdb-plugin
}

function reset(){
    stop
    remove
}

function enter(){
    docker exec -it opentsdb-plugin /bin/bash
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
        echo "Usage: ./opentsdb-plugin.sh [start|stop|rm|reset|enter]"
        exit 1
        ;;
esac
exit 0
