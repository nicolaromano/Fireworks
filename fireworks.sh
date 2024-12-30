#!/usr/bin/env bash

# Create an array of colors to use with tput

colors=(
    "$(tput setaf 33)" # blue
    "$(tput setaf 190)" # yellow
    "$(tput setaf 196)" # red
    "$(tput setaf 255)" # white
)

ncolors=${#colors[@]}

# configure terminal for drawing
cleanup() {
	tput rmcup # restore screen
	tput cnorm # restore cursor
}
trap cleanup exit # run cleanup on exit

tput smcup # save screen
tput civis # hide cursor

ncols=$(tput cols)
nrows=$(tput lines)

while true; do
    # Choose a random x position for the firework
    xpos=$((RANDOM % ncols))
    ypos=$((RANDOM % nrows))    

    tput cup $ypos $xpos
    echo -n "${colors[$RANDOM % $ncolors]}*"

    sleep 0.4

    # Clear the screen
    tput clear
done


EOF
