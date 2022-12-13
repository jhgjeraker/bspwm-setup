#!/bin/bash

mode_1='1 Power Saver'
mode_2='2 Balanced'
mode_3='3 Performance'

bat_perc=$(bash /usr/local/bin/battery.sh)
pwr_mode=$(bash /usr/local/bin/powerprofile.sh)
msg="   Time: $(date)"
msg="$msg&#x0a;Battery: $bat_perc"
msg="$msg&#x0a;Profile: $pwr_mode"

mode="$(echo -e "$mode_1\n$mode_2\n$mode_3" | rofi -mesg "$msg" -dmenu -i -monitor primary)"

# Depending on the distro, power-manager may be `system76-power` or powerprofilesctl.
if command -v powerprofilesctl &> /dev/null; then
    if [[ "$mode" == "$mode_1" ]]; then
        powerprofilesctl set power-saver
    elif [[ "$mode" == "$mode_2" ]]; then
        powerprofilesctl set balanced
    elif [[ "$mode" == "$mode_3" ]]; then
        powerprofilesctl set performance
    fi
elif command -v system76-power &> /dev/null; then
    if [[ "$mode" == "$mode_1" ]]; then
        system76-power profile battery
    elif [[ "$mode" == "$mode_2" ]]; then
        system76-power profile balanced
    elif [[ "$mode" == "$mode_3" ]]; then
        system76-power profile performance
    fi
else
    notify-send "No power-manager found."
    exit
fi

