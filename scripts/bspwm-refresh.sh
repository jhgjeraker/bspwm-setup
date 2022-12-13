#!/bin/bash

# -----------------------------------------------
# X Configuration
#
# xset r rate 250 30

# Swap Caps Lock with Left Control.
setxkbmap -option ctrl:nocaps

# Update x-cursor to avoid enlargement.
xsetroot -cursor_name left_ptr

# Set whatever wallpaper were last used by feh.
$HOME/.fehbg &

# Relaunch polybar.
bash /usr/local/bin/polybar-launch.sh > /dev/null 2>&1
