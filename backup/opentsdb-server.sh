#!/bin/bash

set -e

WorkDir=`pwd`

# 本地logs目录
LocalLogDir=${WorkDir}/logs/opentsdb-server/

# 本地HBase数据目录
LocalHBaseDir=${WorkDir}/data/hbase-server/

# 本地配置目录
LocalConfDir=${WorkDir}/etc/opentsdb_server/

# 本地plugins目录
LocalPlugInsDir=${WorkDir}/share/plugins/

# 本地static目录
LocalStaticDir=${WorkDir}/share/static

# 本地tools目录
LocalToolsDir=${WorkDir}/share/tools/

# 本地tmp目录
LocalTmpDir=${WorkDir}/share/tmp/




function start(){
    mkdir -p $LocalConfDir
    mkdir -p $LocalHBaseDir
    mkdir -p $LocalTmpDir/server

    eval "docker run -d \
        --name opentsdb-server \
        -p 4245:4245 \
        -v ${LocalConfDir}:/etc/opentsdb/ \
        -v ${LocalPlugInsDir}:/opentsdb-plugins/ \
        -v ${LocalStaticDir}:/opentsdb-static/ \
        -v ${LocalToolsDir}:/opentsdb-tools/ \
        -v ${LocalTmpDir}:/opentsdb-tmp/ \
        -v ${LocalHBaseDir}:/data/hbase/ \
        -v ${LocalLogDir}:/opentsdb-logs/ \
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
