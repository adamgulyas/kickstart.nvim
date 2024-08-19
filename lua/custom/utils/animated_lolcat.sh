#!/usr/bin/env bash

counter=0

while :
do
    counter=$((counter+1))
    tput cup 0 0          # Move cursor back to line 0, column 0 again after clear
    lolcat $1 -S $counter -f  # Output text with lolcat
    echo "\033[0K\r"     # Clear line
    # sleep .1              # Sleep for a short delay
done
