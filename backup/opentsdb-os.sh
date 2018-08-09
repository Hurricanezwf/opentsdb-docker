#!/bin/bash

set -e

WorkDir=`pwd`

# 本地logs目录
LocalLogDir=${WorkDir}/logs/opentsdb-os/

# 本地HBase数据目录
LocalHBaseDir=${WorkDir}/data/hbase-os/

# 本地配置目录
LocalConfDir=${WorkDir}/etc/opentsdb_os/

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
    mkdir -p $LocalTmpDir/os

    eval "docker run -d \
        --name opentsdb-os \
        -p 4243:4243 \
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
