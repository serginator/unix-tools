#!/bin/bash

#Global VARs

	#Folder VARs
	EXPLOITS="/pentest/exploits/"
	WIRELESS="/pentest/wireless"

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

#Apt
funAPT(){
	echo -e $YELLOW"*** Updating system ***"$ENDCOLOR
	sleep 1
	sudo apt-get update
	sudo apt-get dist-upgrade -y
	echo -e $YELLOW"*** System updated! ***"$ENDCOLOR
	sleep 2
}
#Fasttrack
funFASTTRACK(){
	echo -e $YELLOW"*** Updating Fast-track ***"$ENDCOLOR
	#cd /pentest/exploits/fasttrack
	#sudo svn update
	cd $EXPLOITS
	sudo svn co http://svn.secmaniac.com/fasttrack
	echo -e $YELLOW"*** Fast-track updated! ***"$ENDCOLOR
	sleep 2
}

#Metasploit :D
funMETASPLOIT(){
	echo -e $YELLOW"*** Updating Metasploit v3***"$ENDCOLOR
	#In Backtrack4-r2, uncomment those lines and comment the others because framework3 is
	#in /opt/metasploit3/msf3, in /pentest is just a link.

	#cd /pentest/exploits/framework3
	#sudo svn update
	cd $EXPLOITS
	#sudo svn co https://metasploit.com/svn/framework3/trunk framework3
	if [ -d "$EXPLOITS/framework3" ];
		then
			cd framework3
			sudo git pull origin
		else
			sudo git clone git://github.com/rapid7/metasploit-framework.git framework3/
		fi



	echo -e $YELLOW"*** Metasploit v3 updated! ***"$ENDCOLOR
	sleep 2
}

#SET :P
funSET(){
	echo -e $YELLOW"*** Updating SET ***"$ENDCOLOR
	#cd /pentest/exploits/SET
	#sudo svn update
	cd $EXPLOITS
	#sudo svn co http://svn.secmaniac.com/social_engineering_toolkit SET
	if [ -d "$EXPLOITS/SET" ]; 
		then
			cd SET
			sudo git pull origin
		else
			sudo git clone git://github.com/trustedsec/social-engineer-toolkit.git SET/
	fi
	echo -e $YELLOW"*** SET updated! ***"$ENDCOLOR
	sleep 2
}

#Exploit DB
funEXPLOITDB(){
	echo -e $YELLOW"*** Updating ExploitDB ***"$ENDCOLOR
	cd $EXPLOITS

	cd exploitdb
	#The SVN repos doesn't exists anymore, so we have to fully download it
	sudo wget http://www.exploit-db.com/archive.tar.bz2
	sudo tar -xvjf archive.tar.bz2
	sudo rm archive.tar.bz2

	#sudo svn co svn://www.exploit-db.com/exploitdb
	#sudo svn co svn://devel.offensive-security.com/exploitdb
echo -e $YELLOW"*** Exploit-DB updated! ***"$ENDCOLOR
	sleep 2
}

#EvilGrade
funEVILGRADE(){
	echo -e $YELLOW"*** Updating EvilGrade ***"$ENDCOLOR
	cd $EXPLOITS
	sudo svn checkout http://isr-evilgrade.googlecode.com/svn/trunk/ evilgrade
	echo -e $YELLOW"*** EvilGrade updated! ***"$ENDCOLOR
	sleep 2
}

#Aircrack-ng
funAIRCRACK(){
	echo -e $YELLOW"*** Updating Aircrack-NG ***"$ENDCOLOR
	#cd /pentest/wireless/aircrack-ng
	#sudo svn update
	if [ -d "$WIRELESS/aircrack-ng" ];
                then
                        cd $WIRELESS
                        sudo git pull origin
                else
                        sudo git clone git://github.com/aircrack-ng/aircrack-ng.git aircrack-ng
        fi
	cd aircrack-ng
	sudo make
	sudo make install
	sudo airodump-ng-oui-update
	echo -e $YELLOW"*** Aircrack-NG updated! ***"$ENDCOLOR
	sleep 2
}

#System cleaner
funCLEAN(){
	OLDCONF=$(dpkg -l|grep "^rc"|awk '{print $2}')
	CURKERNEL=$(uname -r|sed 's/-*[a-z]//g'|sed 's/-386//g')
	LINUXPKG="linux-(image|headers|ubuntu-modules|restricted-modules)"
	METALINUXPKG="linux-(image|headers|restricted-modules)-(generic|i386|server|common|rt|xen)"
	OLDKERNELS=$(dpkg -l|awk '{print $2}'|grep -E $LINUXPKG |grep -vE $METALINUXPKG|grep -v $CURKERNEL)

	echo -e $YELLOW"*** Cleaning apt-cache ***"$ENDCOLOR
	sudo apt-get clean -y
	sudo apt-get autoremove -y

	echo -e $YELLOW"*** Cleaning old config files ***"$ENDCOLOR
	sudo apt-get purge $OLDCONF

	echo -e $YELLOW"*** Cleaning old kernels ***"$ENDCOLOR
	sudo apt-get purge $OLDKERNELS

	echo -e $YELLOW"*** Empty trash ***"$ENDCOLOR
	rm -rf /home/*/.local/share/Trash/*/** &> /dev/null
	rm -rf /root/.local/share/Trash/*/** &> /dev/null


	#The tmp cleaner sometimes breaks stuff. Do it on your own.
	#echo -e $YELLOW"*** Cleaning temps in /tmp ***"$ENDCOLOR
	#for file in "$( /usr/bin/find /tmp )"
	#do
	#	rm -rf $file
	#done

	echo -e $YELLOW"*** Everything clean! ***"$ENDCOLOR
	sleep 2
}

clear
while [ $EXIT==0 ]
do
	echo -e "*****************************************************************"
	echo -e "*"$RED"                        Actualizator 2011                      "$ENDCOLOR"*"
	echo -e "*****************************************************************"
	echo -e "*"$YELLOW"   Options speak by themselves, the only one that has          "$ENDCOLOR"*"
	echo -e "*"$YELLOW"   to be explained is Cleaning System. This option             "$ENDCOLOR"*"
	echo -e "*"$YELLOW"   cleans old packets, apt cache, config files,                "$ENDCOLOR"*"
	echo -e "*"$YELLOW"   old kernels and trash.                                      "$ENDCOLOR"*"
	echo -e "*****************************************************************"
	echo -e "*"$PURPLE"                       Made by SeRGiNaToR                      "$ENDCOLOR"*"
	echo -e "*"$PURPLE"                    25-01-2011 - "$BLINK"versión 1.0"$ENDBLINK"                   "$ENDCOLOR"*"
	echo -e "*****************************************************************"
	echo
	echo -e "Options:"
	echo -e "	1) APT-GET"
#	echo -e "	2) Fast-track (/pentest/exploits/fasttrack/)"
	echo -e "	3) Metasploit v3 (/pentest/exploits/framework3/)"
	echo -e "	4) SET (/pentest/exploits/SET/)"
	echo -e "	5) Exploit-DB (/pentest/exploits/exploitdb/)"
#	echo -e "	6) EvilGrade (/pentest/exploits/evilgrade/)"
	echo -e "	7) Aircrack-NG (/pentest/wireless/aircrack-ng/)"
	echo -e "	8) Everything"
	echo -e "	9) System cleaner"
	echo -e "	0) Exit"
	# -n makes it work like print instead of println
	echo -n "What do you want to do? "
	read OPTION
	case $OPTION in
	1 )
		funAPT
		;;
#	2 )
#		funFASTTRACK
#		;;
	3 )
		funMETASPLOIT
		;;
	4 )
		funSET
		;;
	5 )
		funEXPLOITDB
		;;
#	6 )
#		funEVILGRADE
#		;;
	7 )
		funAIRCRACK
		;;
	8 )
		funAPT
#		funFASTTRACK
		funMETASPLOIT
		funSET
		funEXPLOITDB
#		funEVILGRADE
		funAIRCRACK
		;;
	9 )
		funCLEAN
		;;
	0 )
		clear
		echo "Good luck friend!"
		exit
	esac
    clear
done
