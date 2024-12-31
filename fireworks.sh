#!/usr/bin/env bash

colors=(
    "$(tput setaf 5)"   # purple
    "$(tput setaf 15)"  # white
    "$(tput setaf 33)"  # blue
    "$(tput setaf 40)"  # green
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

init() {
    tput smcup   # save screen
    tput civis   # hide cursor
    tput setab 0 # Make screen black
    tput clear
}

draw_title() {
    local frame=$1
    local message="   Happy New Year!   "
    local strings_even=(
        "* * * * * * * * * * * * *"
        "                         "
        "* ${message} *"
        "                         "
        "* * * * * * * * * * * * *"
    )
    local strings_odd=(
        " * * * * * * * * * * * * "
        "*                       *"
        "  ${message}  "
        "*                       *"
        " * * * * * * * * * * * * "
    )
    local style=${firework_background}${firework_foreground}

    tput bold
    for i in $(seq 0 4); do
        tput cup $((i + 1)) $((ncols / 2 - 11))
        if [ $((frame % 2)) -eq 0 ]; then # Even frames
            echo -n "${style}${strings_even[$i]}"
        else # Odd frames
            echo -n "${style}${strings_odd[$i]}"
        fi
    done

    tput sgr0
}

init

ncols=$(tput cols)
nrows=$(tput lines)

while true; do
    # Choose a random x position for the firework
    xpos=$((RANDOM % ncols))
    ypos=$((RANDOM % nrows))
    firework_background=$(tput setab 0)              # Black background
    firework_foreground=${colors[$RANDOM % ncolors]} # Random foreground color

    nframes=$((RANDOM % 5 + 5)) # between 4 and 9 frames

    # ypos can't be less than nframes or more than nrows - nframes
    ypos=$((ypos < nframes ? nframes : ypos))
    ypos=$((ypos > nrows - nframes ? nrows - nframes : ypos))
    # xpos can't be less than nframes or more than ncols - nframes
    xpos=$((xpos < nframes ? nframes : xpos))
    xpos=$((xpos > ncols - nframes ? ncols - nframes : xpos))

    # Draw the firework
    # The firework's tail
    for j in $(seq 1 $nframes); do
        draw_title $j

        tput cup $((ypos + nframes - j)) $xpos
        echo -n "${firework_background}${firework_foreground}ǁ"
        sleep 0.1
    done
    tput cup $ypos $xpos
    # The firework's head
    echo -n "${firework_background}${firework_foreground}*"

    # Draw the firework explosion
    for frame in $(seq 1 $nframes); do
        draw_title $frame

        tput cup $((ypos - frame)) $((xpos - frame))
        echo -n "${firework_background}${firework_foreground}\\"
        tput cup $((ypos - frame)) $((xpos + frame))
        echo -n "${firework_background}${firework_foreground}/"
        tput cup $((ypos + frame)) $((xpos - frame))
        echo -n "${firework_background}${firework_foreground}/"
        tput cup $((ypos + frame)) $((xpos + frame))
        echo -n "${firework_background}${firework_foreground}\\"
        tput cup $ypos $((xpos - frame))
        echo -n "${firework_background}${firework_foreground}-"
        tput cup $ypos $((xpos + frame))
        echo -n "${firework_background}${firework_foreground}-"
        # Remove the firework tail
        tput cup $((ypos + nframes - frame)) $xpos
        echo -n " "
        sleep 0.1
    done

    # Clear the screen
    tput setab 0
    tput clear
done
