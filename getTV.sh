#!/bin/bash

want_tv=(,CCTV ,上海 ,东方卫视)

rm cn.*
wget https://iptv-org.github.io/iptv/countries/cn.m3u

search(){
    for((i=0;i<=${#want_tv[@]}-1;i++))
    do
        grep -A 1 "${want_tv[i]}" cn.m3u
    done
}

search > tv.m3u