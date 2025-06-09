qcy=`bluetoothctl devices Connected | grep -o "QCY"`

if [ "$qcy" = "QCY" ]; then
  echo "󱡏"
else
  echo "󱡐"
fi