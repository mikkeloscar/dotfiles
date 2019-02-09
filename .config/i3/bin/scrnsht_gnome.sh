#!/bin/bash

directory="$HOME/scrnsht"
mkdir -p "$directory"

file="$directory/gnome-$(date "+%Y-%m-%d--%H-%M-%S").png"
# gnome-screenshot --clipboard --area --remove-border "--file=$file"
gnome-screenshot --area --remove-border "--file=$file"
# import -quality 4 "$file"
xclip -selection clipboard -target image/png -i < "$file"
