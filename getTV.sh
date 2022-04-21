#!/bin/bash

# 筛选范围
want_tv=(HK MO TW JP)

# 个人环境
workdir="/home/bruce/Developer/GetTV"
pushdir="/data/nginx/index"
jellyfin="/data/jellyfin/media/TV"

pull(){
    wget https://iptv-org.github.io/iptv/countries/hk.m3u
    wget https://iptv-org.github.io/iptv/countries/mo.m3u
    wget https://iptv-org.github.io/iptv/countries/tw.m3u
    wget https://iptv-org.github.io/iptv/countries/jp.m3u
}

search(){
    j=(hk.m3u mo.m3u tw.m3u jp.m3u)
    for((k=0;k<=${#j[@]}-1;k++))
    do
        for((i=0;i<=${#want_tv[@]}-1;i++))
        do
            grep -A 1 "${want_tv[i]}" ${j[k]}
        done
    done
}
#search > iptv.m3u

main(){
    cd $workdir
    rm *.m3u
    pull
    if [ $? -eq 1 ]
    then
        echo "下载文件失败，请检查网络" >> /home/bruce/Desktop/getTV.log
    fi
    search > $pushdir/iptv.m3u
    sed -i '/blocked/,+1d' $pushdir/iptv.m3u
    search > $jellyfin/iptv.m3u
    sed -i '/blocked/,+1d' $jellyfin/iptv.m3u
    if [ $? -eq 0 ]
    then
        if [ `wc -l /home/bruce/Desktop/getTV.log|awk '{print $1}'` -gt 12 ]
        then
            rm /home/bruce/Desktop/getTV.log
        fi
        echo "更新m3u文件成功 `date "+%Y-%m-%d %H:%M:%S"`" >> /home/bruce/Desktop/getTV.log
    else
        if [ `wc -l /home/bruce/Desktop/getTV.log|awk '{print $1}'` -gt 12 ]
        then
            rm /home/bruce/Desktop/getTV.log
        fi
        echo "更新文件失败，请检查源文件 `date "+%Y-%m-%d %H:%M:%S"`" >> /home/bruce/Desktop/getTV.log
        exit 1
    fi
}

main