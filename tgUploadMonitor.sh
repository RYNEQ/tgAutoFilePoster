#!/bin/bash

base="$1"

if ! hash inotifywait ; then
	echo "inotify is not installed! please install it first."
	exit 1
fi


inotifywait -m -r -e moved_to -e create "$base" --format "%w%f" | while read f; 
do 
	if [[ -f "$f" ]]; then
		dir=$(dirname "$f")
		file=$(basename "$f")
		u=$(echo "${dir#$base}" |sed 's#^/##; s#/$##'|cut -d/ -f1)
		echo "[$(date)] File [$file] detected to send to [$u]."
		if [[ -n $u ]]; then
			echo "Sending [$f] to [$u] in Telegram"
			~/sendFileToTelegram.py 2391 document "$u" "$(realpath "$f")" 
		else
			echo "File [$f] is not created in target directory; I don't know where should i send it!"
		fi
	fi
done

