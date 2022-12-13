#!/bin/bash

if command -v powerprofilesctl &> /dev/null; then
    mode=$(powerprofilesctl list | grep '*')
    if [ "${mode}" == '* performance:' ]; then
        echo 'Performance'
    elif [ "${mode}" == '* balanced:' ]; then
        echo 'Balanced'
    elif [ "${mode}" == '* power-saver:' ]; then
        echo 'Power Saver'
    else
        echo ' ?'
    fi
elif command -v system76-power &> /dev/null; then
    mode=$(system76-power profile | awk '/Power Profile: /{print $3}')
    if [ "${mode}" == 'Performance' ]; then
        echo 'Performance'
    elif [ "${mode}" == 'Balanced' ]; then
        echo 'Balanced'
    elif [ "${mode}" == 'Battery' ]; then
        echo 'Power Saver'
    else
        echo ' ?'
    fi
else
    echo "?"
fi
