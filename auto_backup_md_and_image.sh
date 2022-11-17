#!/bin/bash

CURR='/home/joezhang/Downloads/mx-wc'
NOTE_FOLDER='/home/joezhang/workspace/obsidian_note/Web_Clipper'

while true
do
	cd ${CURR}
	echo "check if there is a web_clipper file?"
	if [ -d "${CURR}/default" ];then
		echo "#### detect web_clipper file, wait for it download the image."
		sleep 5

		echo "#### Start Auto upload!!"
		FILE=$(echo $(find -name "index.md"))
		echo "## markdown file: $FILE"

		cd ./default/mx-wc/
		TITLE=$(echo $(find -name "*.txt")| rev| cut -c 5-| rev| cut -c 3-)
		echo "## web title: $TITLE"
		cd ${CURR}

		IMG_FOLDER=$(echo $(find -name "assets")| cut -c 3-)
		echo "## images folder: $IMG_FOLDER"

		if [ ! -z ${IMG_FOLDER} ];then
			echo "#### This note has images, do backup."
			#upload image to github
			cp -rv $IMG_FOLDER/* obsidian_note_image/
			cd obsidian_note_image/
			git pull -f
			git add .
			git commit -m "${TITLE}-images"
			git push origin
			cd ${CURR}

			#change image link from assets to github
			sed -r -i \
			's|assets/(.*)\)|https://github.com/JoeZhang-tn/obsidian_note_image/blob/main/\1\?raw\=true\)|g' \
			${FILE}
		fi

		cp -rv ${FILE} ${NOTE_FOLDER}/${TITLE}.md

		echo "#### Done, remove this web_clipper file"
		rm -rf default/
		unset FILE TITLE IMG_FOLDER
	fi
	sleep 1
done

