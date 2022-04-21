#!/bin/bash

want_tv=(
    ,CCTV ,上海 ,东方卫视 ,SiTV游戏风云 ,完美游戏 ,NewTV精品体育
    ,NewTV超级体育 ,SiTV劲爆体育 ,五星体育 ,百事通体育 ,纯享4K
    ,TVB ,香港 ,鳳凰 ,RTHK ,Phoenix ,HKSTV
    ,澳門 ,澳门 ,澳视
    ,華視 ,民視 ,東森 ,壹電 ,三立 ,台視
    ,NHK ,TV ,Tokyo ,Nippon ,J ,Fuji ,Disney ,BS ,Animax
)

workdir="/home/bruce/Developer/tv"
pushdir="/data/nginx/index"

pull(){
    wget https://iptv-org.github.io/iptv/countries/cn.m3u
    wget https://iptv-org.github.io/iptv/countries/hk.m3u
    wget https://iptv-org.github.io/iptv/countries/mo.m3u
    wget https://iptv-org.github.io/iptv/countries/tw.m3u
    wget https://iptv-org.github.io/iptv/countries/jp.m3u
}

search(){
    j=(cn.m3u hk.m3u mo.m3u tw.m3u jp.m3u)
    for((k=0;k<=${#j[@]}-1;k++))
    do
        for((i=0;i<=${#want_tv[@]}-1;i++))
        do
            grep -A 1 "${want_tv[i]}" ${j[k]}
        done
    done
}

cd $workdir
rm *.m3u
pull
if [ $? -eq 1 ]
then
    echo "下载文件失败，请检查网络" >> /home/bruce/Desktop/getTV.log
fi

search > $pushdir/tv.m3u
sed -i '/blocked/,+1d' $pushdir/tv.m3u
search > /data/jellyfin/media/TV/tv.m3u
sed -i '/blocked/,+1d' /data/jellyfin/media/TV/tv.m3u
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