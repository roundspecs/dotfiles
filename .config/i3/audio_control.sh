#!/bin/bash

# Define path to the volume_img directory
ICON_DIR="/home/roundspecs/dotfiles/.config/i3/volume_img"

# Helper function to get current volume
get_volume() {
  pactl get-sink-volume @DEFAULT_SINK@ | grep "Volume:" | awk 'NR==1 {print $5}' | sed 's/[^0-9]*//g'
}

# Helper function to get current mute status
get_mute_status() {
  pactl get-sink-mute @DEFAULT_SINK@ | awk '{print $2}'
}

# Command-line arguments
ACTION=$1

case $ACTION in
raise)
  pactl set-sink-volume @DEFAULT_SINK@ +5%
  VOL=$(get_volume)
  dunstify --hints=int:value:"$VOL" -u low -r 2593 -t 2000 " ++Volume" --icon "$ICON_DIR/inc.png"
  ;;
lower)
  pactl set-sink-volume @DEFAULT_SINK@ -5%
  VOL=$(get_volume)
  dunstify --hints=int:value:"$VOL" -u low -r 2593 -t 2000 " --Volume" --icon "$ICON_DIR/dec.png"
  ;;
mute)
  pactl set-sink-mute @DEFAULT_SINK@ toggle
  MUTE_STATUS=$(get_mute_status)
  dunstify -u low -r 2593 -t 2000 " Mute: $MUTE_STATUS"
  ;;
mic-mute)
  pactl set-source-mute @DEFAULT_SOURCE@ toggle
  MIC_MUTE_STATUS=$(pactl get-source-mute @DEFAULT_SOURCE@)
  dunstify -u low -r 2593 -t 2000 " $MIC_MUTE_STATUS"
  ;;
*)
  echo "Usage: $0 {raise|lower|mute|mic-mute}"
  exit 1
  ;;
esac

# Refresh i3status or other status bar
$refresh_i3status
