#!/bin/bash

# 筛选范围
want_tv=(HK MO TW JP)
blocklist=(blocked "GOOD TV CH" 立法院)
m3ulist=(hk.m3u mo.m3u tw.m3u jp.m3u)

# 个人环境
workdir="/home/bruce/Developer/GetTV"
pushdir="/data/nginx/index"
jellyfin="/data/jellyfin/media/TV"

pull(){
    for((i=0;i<=${#m3ulist[@]}-1;i++))
    do
        wget https://iptv-org.github.io/iptv/countries/${m3ulist[i]}
    done
}

search(){
    for((k=0;k<=${#m3ulist[@]}-1;k++))
    do
        for((i=0;i<=${#want_tv[@]}-1;i++))
        do
            grep -A 1 "${want_tv[i]}" ${m3ulist[k]}
        done
    done
}

block(){
    for((i=0;i<=${#blocklist[i]}-1;i++))
    do
        sed -i "/${blocklist[i]}/,+1d" iptv.m3u
    done
}

main(){
    cd $workdir
    rm *.m3u
    pull
    if [ $? -eq 1 ]
    then
        echo "下载文件失败，请检查网络" >> /home/bruce/Desktop/getTV.log
        exit 1
    fi
    search > iptv.m3u
    block
    if [ $? -eq 1 ]
    then
        echo "筛选节目失败，请检查原始m3u文件" >> /home/bruce/Desktop/getTV.log
        exit 1
    fi
    cp iptv.m3u $pushdir
    cp iptv.m3u $jellyfin
    if [ `wc -l /home/bruce/Desktop/getTV.log|awk '{print $1}'` -gt 12 ]
    then
        echo "更新m3u文件成功 `date "+%Y-%m-%d %H:%M:%S"`" > /home/bruce/Desktop/getTV.log
    else
        echo "更新m3u文件成功 `date "+%Y-%m-%d %H:%M:%S"`" >> /home/bruce/Desktop/getTV.log
    fi
}

main