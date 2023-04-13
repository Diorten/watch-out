#!/bin/bash

sudo airodump-ng -c $1 --bssid $2 $3
sleep 15
kill $PPID
