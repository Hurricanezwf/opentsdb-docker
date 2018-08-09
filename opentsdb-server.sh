#!/bin/bash

set -e

WorkDir=`pwd`

# 本地HBase数据目录
LocalHBaseDir=${WorkDir}/data/hbase-server/



function start(){
    mkdir -p $LocalHBaseDir

    eval "docker run -d \
        --name opentsdb-server \
        -p 4245:4242 \
        -v ${LocalHBaseDir}:/data/hbase/ \
        opentsdb-docker:2.2"
}

function stop(){
    docker stop opentsdb-server
}

function remove(){
    docker stop opentsdb-server
    docker rm -v opentsdb-server
}

function reset(){
    stop
    remove
}

function enter(){
    docker exec -it opentsdb-server /bin/bash
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
        echo "Usage: ./opentsdb-server.sh [start|stop|rm|reset|enter]"
        exit 1
        ;;
esac
exit 0
