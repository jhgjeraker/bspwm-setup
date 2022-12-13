#!/bin/bash

if ! ls -a1 "$HOME/" | grep '.screenlayout'; then
    echo 'Directory $HOME/.screenlayout missing.'
    exit
fi

if ! ls -a1 "$HOME/.screenlayout" | grep "m$1.sh"; then
    echo "No such file m$1.sh."
    exit
fi

sh "$HOME/.screenlayout/m$1.sh"

# Reset bspwm monitors and polybar.
bash /usr/local/bin/bspwm-monitor-setup.sh
bash /usr/local/bin/bspwm-refresh.sh
