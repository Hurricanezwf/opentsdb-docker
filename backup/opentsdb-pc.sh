#!/bin/bash

set -e

WorkDir=`pwd`

# 本地logs目录
LocalLogDir=${WorkDir}/logs/opentsdb-pc/

# 本地HBase数据目录
LocalHBaseDir=${WorkDir}/data/hbase-pc/

# 本地HBase配置文件
LocalHBaseConfFile=${WorkDir}/etc/hbase-conf/hbase-site.xml

# 本地配置目录
LocalConfDir=${WorkDir}/etc/opentsdb_pc/

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
    mkdir -p $LocalTmpDir/pc

    eval "docker run -d \
        --name opentsdb-pc\
        -p 4244:4242 \
        opentsdb-docker:2.2"

    #eval "docker run -d \
    #    --name opentsdb-pc \
    #    -p 4244:4242 \
    #    -v ${LocalConfDir}:/etc/opentsdb/ \
    #    -v ${LocalPlugInsDir}:/opentsdb-plugins/ \
    #    -v ${LocalStaticDir}:/opentsdb-static/ \
    #    -v ${LocalToolsDir}:/opentsdb-tools/ \
    #    -v ${LocalTmpDir}:/opentsdb-tmp/ \
    #    -v ${LocalHBaseDir}:/data/hbase/ \
    #    -v ${LocalLogDir}:/opentsdb-logs/ \
    #    -v ${LocalHBaseConfFile}:/opt/hbase/conf/hbase-site.xml \
    #    opentsdb:2.2.0"
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
