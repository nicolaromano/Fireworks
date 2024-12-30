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
trap cleanup EXIT # run cleanup on exit

tput smcup # save screen
tput civis # hide cursor

ncols=$(tput cols)
nrows=$(tput lines)

while true; do
    # Choose a random x position for the firework
    xpos=$((RANDOM % ncols))
    ypos=$((RANDOM % nrows))
    firework_color=${colors[$RANDOM % ncolors]}

    nframes=$((RANDOM % 5 + 5)) # between 5 and 9 frames

    # ypos can't be less than nframes or more than nrows - nframes
    ypos=$((ypos < nframes ? nframes : ypos))
    ypos=$((ypos > nrows - nframes ? nrows - nframes : ypos))
    # xpos can't be less than nframes or more than ncols - nframes
    xpos=$((xpos < nframes ? nframes : xpos))
    xpos=$((xpos > ncols - nframes ? ncols - nframes : xpos))

    # Draw the firework
    for j in $(seq 1 5); do
        tput cup $((ypos + 5 - j)) $xpos
        echo -n "${firework_color}ǁ"
        sleep 0.1
    done
    tput cup $ypos $xpos
    echo -n "${firework_color}*"        

    for j in $(seq 1 5); do
        tput cup $((ypos + 6 - j)) $xpos
        echo -n "${firework_color} "
    done

    for frame in $(seq 1 $nframes); do
        for i in $(seq 1 $frame); do
            tput cup $((ypos - i)) $((xpos - i))            
            echo -n "${firework_color}\\"
            tput cup $((ypos - i)) $((xpos + i))
            echo -n "${firework_color}/"
            tput cup $((ypos + i)) $((xpos - i))
            echo -n "${firework_color}/"
            tput cup $((ypos + i)) $((xpos + i))
            echo -n "${firework_color}\\"
            tput cup $ypos $((xpos - i))
            echo -n "${firework_color}-"
            tput cup $ypos $((xpos + i))
            echo -n "${firework_color}-"
            sleep 0.06
        done
    # Clear the screen
    done
    tput clear
done


EOF
