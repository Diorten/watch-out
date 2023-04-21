# watch-out
An easy-to-use router copier that allows for a wide range of sniffing or phishing activities.

# <center> INFORMATION </center> 
<h4><b><center> FOLLOWING TOOL IS MADE ONLY FOR EDUCATIONAL PURPOSES

USING FOLOWING SCRIPT OUTSIDE EDUCATIONAL SETTING IS STRONGLY PROHIBITED</center></b></h3>

</br>

## Preparations
Before using script, you have to know if your network card supports AP mode, check it by typing `iw list` in your terminal.

Then check if your packets can be transfered between network interfaces by typing `sysctl net.ipv4.ip_forward`, and ensure if it's enabled by value `1`.



## Important dependencies
Like any other script, there are some dependencies needed to run every line of code.

Script should install dependencies without any problems, but if there will happen something with installation, there are some quick tips:
1. Check if you have installed `airmon-ng` and `sudo aireplay-ng`
2. Check if you have istalled tool called `create_ap`, and it's folder is with your script - without it you can't run AP and WiFi connection at the same time
3. Find out `xterm` module installed in your system
4. Check if you have installed `hostapd` and `dhcpd` to run AP spot :)
5. 
