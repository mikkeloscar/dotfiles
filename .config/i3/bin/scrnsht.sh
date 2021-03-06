#!/bin/bash

directory="$HOME/scrnsht"
mkdir -p "$directory"

file="$directory/$(date "+%Y-%m-%d--%H-%M-%S").png"
import -quality 4 "$file"
xclip -selection clipboard -target image/png -i < "$file"
