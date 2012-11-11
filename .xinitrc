#!/bin/sh
#
# ~/.xinitrc
#
# Executed by startx (run your window manager from here)

if [ -d /etc/X11/xinit/xinitrc.d ]; then
  for f in /etc/X11/xinit/xinitrc.d/*; do
    [ -x "$f" ] && . "$f"
  done
  unset f
fi

# Compositioning manager
compton &

xrdb -merge ~/.Xresources

# Add terminus font to path
xset +fp /usr/share/fonts/local
xset fp rehash

# Background
hsetroot -fill .backgrounds/borealis.jpg

# Startup prgs
dropboxd &

# redshift
# redshift -l 55.7:12.6 -t 5700:3600 -g 0.8 -m vidmode -v &
redshift -l 55.7:12.6 -t 5700:4500 -g 0.8 -m vidmode -v &

# WM/DE
exec i3
# exec dbus-launch qtile
