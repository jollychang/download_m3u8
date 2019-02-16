#author: 9crk
#contact: admin@9crk.com
#date&place: 20190211 after LiuLangDiQiu showup

max_task=100
playlist=$1
url_f=${playlist%/*}


wget $playlist -O playlist.m3u8

cat playlist.m3u8|while read line
do
	if [[ $line =~ ".ts" ]]
	then
		url="$url_f/$line"
		echo $url
		wget -q -c $url &
		while true
		do
			num=`ps -ef|grep wget|awk '{print NR}'|tail -n1`
			if [ $max_task -gt $num ];then
				break
			fi
		done
	fi
done

while true
do
	num=`ps -ef|grep wget|awk '{print NR}'|tail -n1`
        if [ 2 -gt $num ];then
        	break
        fi
done

ffmpeg -user_agent "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_9_5) AppleWebKit/601.7.8 (KHTML, like Gecko) Version/9.1.3 Safari/537.86.7" -i playlist.m3u8 -bsf:a aac_adtstoasc -c copy media.flv
rm *.ts
