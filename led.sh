#!/bin/bash 
STATE_FILE=/home/pi/.led_state
RUN_BIN_LOC=/home/pi/led-matrix/utils
IMG_LOC=/home/pi/img

if [ "$1" = "Get" ]; then
	if [ -f "$STATE_FILE" ]; then
		echo "1"
	else
		echo "0"
	fi
else # set
	if [ "$4" = "true" ]; then # turn on
		if [ -f "$STATE_FILE" ]; then
			exit 1
		else
			# start process 
			# write pid to file
			cd $RUN_BIN_LOC
			./led-image-viewer -f --led-gpio-mapping=adafruit-hat --led-slowdown-gpio=3 --led-no-hardware-pulse --led-rows=32 --led-cols=64 $IMG_LOC/* &>/dev/null &
			echo "$!" > "$STATE_FILE"
		fi
	else # turn off
		if [ -f "$STATE_FILE" ]; then
			# terminate process
			pid=$(head -n 1 "$STATE_FILE")
			kill -s SIGINT $pid
			rm "$STATE_FILE"
		fi
	fi
fi
