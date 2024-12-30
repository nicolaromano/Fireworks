#!/usr/bin/env bash

colors=(
    "$(tput setaf 5)" # purple
    "$(tput setaf 15)" # white
    "$(tput setaf 33)" # blue
    "$(tput setaf 40)" # green
    "$(tput setaf 190)" # yellow
    "$(tput setaf 196)" # red
    "$(tput setaf 219)" # orange
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

    nframes=$((RANDOM % 5 + 5)) # between 4 and 9 frames

    tput bold    
    tput cup 1 $((ncols / 2 - 7))    
    echo -n "${firework_color}Happy New Year!"
    tput sgr0

    # ypos can't be less than nframes or more than nrows - nframes
    ypos=$((ypos < nframes ? nframes : ypos))
    ypos=$((ypos > nrows - nframes ? nrows - nframes : ypos))
    # xpos can't be less than nframes or more than ncols - nframes
    xpos=$((xpos < nframes ? nframes : xpos))
    xpos=$((xpos > ncols - nframes ? ncols - nframes : xpos))

    # Draw the firework
    # The firework's tail
    for j in $(seq 1 $nframes); do
        tput cup $((ypos + nframes - j)) $xpos
        echo -n "${firework_color}ǁ"
        sleep 0.1
    done
    tput cup $ypos $xpos
    # The firework's head
    echo -n "${firework_color}*"        

    # Draw the firework explosion
    for frame in $(seq 1 $nframes); do
        tput cup $((ypos - frame)) $((xpos - frame))            
        echo -n "${firework_color}\\"
        tput cup $((ypos - frame)) $((xpos + frame))
        echo -n "${firework_color}/"
        tput cup $((ypos + frame)) $((xpos - frame))
        echo -n "${firework_color}/"
        tput cup $((ypos + frame)) $((xpos + frame))
        echo -n "${firework_color}\\"
        tput cup $ypos $((xpos - frame))
        echo -n "${firework_color}-"
        tput cup $ypos $((xpos + frame))
        echo -n "${firework_color}-"
        # Remove the firework tail
        tput cup $((ypos + nframes - frame)) $xpos
        echo -n " "
        sleep 0.1
    done

    # Clear the screen
    tput clear
done