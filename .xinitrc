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
# compton -b &

xrdb -merge ~/.Xresources

# # Add terminus font to path
# xset +fp /usr/share/fonts/local
# xset fp rehash

# #disable beep
# xset -b

# Background
# hsetroot -fill .backgrounds/lighthouse.jpg
# hsetroot -fill .backgrounds/green.jpg
# hsetroot -fill .backgrounds/hardwood.jpg
hsetroot -fill .backgrounds/arch_gray_bg.jpg

# Startup prgs

# redshift
redshift -l 55.7:12.6 -t 5700:4500 -g 0.8 -m vidmode &

# systemd user
# /usr/lib/systemd/systemd --user &

# WM/DE
exec i3
# exec gnome-session-cinnamon
# exec dbus-launch qtile
# exec subtle
