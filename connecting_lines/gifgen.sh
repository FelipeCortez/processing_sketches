#!/bin/sh

palette="/tmp/palette.png"

filters="fps=30,scale=400:-1:flags=lanczos"
#filters="fps=30"

ffmpeg -f image2 -i %d.png -r 30 -s 640x400 /tmp/anim.mkv
ffmpeg -v warning -i /tmp/anim.mkv -vf "$filters,palettegen" -y $palette
ffmpeg -v warning -i /tmp/anim.mkv -i $palette -lavfi "$filters [x]; [x][1:v] paletteuse" -y anim.gif
