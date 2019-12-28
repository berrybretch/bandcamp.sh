#!/usr/bin/bash
getAudio () {
        # $1 = name; $2 = link
        songLink=$(curl $2 | sed '/trackinfo/!d; s/.*https/https/; s/\".*//; s/ .*//')
        echo ${songLink}
        curl --output "$1.mp3" "${songLink}"
}

author=$(echo "$1" | sed 's/https:\/\///; s/\.bandcamp.*//')
echo "Author: ${author}"

album=$(echo "$1" | sed 's/.*album\///; s/-/ /g')
echo "Album: ${album}"

mkdir "${album}"
cd "${album}"

curl "$1" | sed '/href=\"\/track\//!d; /download/d; /info_link/d'| while read p || [[ -n $p ]]; do
        link=$(echo "$p" | sed 's/.*\/track/\/track/; s/\".*//')
        name=$(echo "$p" | sed 's/.*itemprop=\"name\">//; s/<\/span><\/a>//')
        echo "https://${author}.bandcamp.com${link} - ${name}"
        getAudio "${name}" "https://${author}.bandcamp.com${link}"
done

cd ..
