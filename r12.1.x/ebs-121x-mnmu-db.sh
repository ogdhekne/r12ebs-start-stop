#!/bin/bash
#-----------------------------------------------------------------------------------------------------------#
# Startup/Shutdown Utility Script for Oracle E-Business Suite 12.1.X                                        #
# This script is licenced under GPLv2 ; you can get your copy from http://www.gnu.org/licenses/gpl-2.0.html #
# (C) Omkar Dhekne ; ogdhekne@yahoo.in                                                                      #
# This script requires 'dialog' package installed in system. To check # rpm -qa  | grep dialog              #
# * IMPORTANT: Set BASE, SID, HOST  before running script.                                                  #
#-----------------------------------------------------------------------------------------------------------#

# -- STORE MENU OPTIONS SELECTED BY USER:
	INPUT=$HOME/.menu.sh.$$

# -- TRAP AND DELETE TEMP FILES:
	trap "rm $INPUT; exit" SIGHUP SIGINT SIGTERM

# -- ENV:
	export BASE=""
	export SID=""
	export HOST="`hostname -a`"

# -- COLORS:
	export RESET="\e[0m"
	export GRAY="\e[100m"

# -- PROCESSES:
    export LISTN="$(ps -ef |  grep tns | grep 11.2.0 | wc -l)"
    export DB="$(ps -ef | grep ora_ | grep $SID | wc -l)"
    export APP="$(ps -ef | grep FND | wc -l)"

# -- FUNC:

start()
{

# -- START DB:
	source $BASE/db/tech_st/11.1.0/$SID\_$HOST.env

	$BASE/db/tech_st/11.1.0/appsutil/scripts/$SID\_$HOST/addlnctl.sh start $SID
	$BASE/db/tech_st/11.1.0/appsutil/scripts/$SID\_$HOST/addbctl.sh start

# -- PRINT MESSAGE:
	echo "                                           "
	echo -e "Press ${GRAY:-} [Enter] ${RESET:-} to return main-menu."
	read enter
}

stop()
{

# -- STOP DB:
	source $BASE/db/tech_st/11.1.0/$SID\_$HOST.env

	$BASE/db/tech_st/11.1.0/appsutil/scripts/$SID\_$HOST/addlnctl.sh stop $SID
	$BASE/db/tech_st/11.1.0/appsutil/scripts/$SID\_$HOST/addbctl.sh stop immediate

# -- PRINT MESSAGE:
	echo "                                           "
	echo -e "Press ${GRAY:-} [Enter] ${RESET:-} to return main-menu."
	read enter

}

status()
{
    echo "                                           "
# -- PRINT STATUS OF DB, APPS & LISNTENER
    cat <<EOF
    Processes:
    DB: $DB   APPS: $APP  LISTENER: $LISTN
EOF

# -- PRINT MESSAGE:
	echo "                                           "
	echo -e "Press ${GRAY:-} [Enter] ${RESET:-} to return main-menu."
	read enter

}


# -- SET INFINITE LOOP:

while true
do

# -- MAIN MENU:
dialog --clear --backtitle "STARTUP/SHUTDOWN UTILITY FOR EBS 12.1.X " \
--title "[ M A I N - M E N U ]" \
--menu "               NOTE: USE ARROW KEYS TO NAVIGATE" 15 68 4	 \
Startup "Start DB Services." \
Shutdown "Stop DB Services." \
Status "Status of DB & LISTENER." \
Exit "Exit to the shell" 2>"${INPUT}"

menuitem=$(<"${INPUT}")


# -- MAKE DESCISION:
case $menuitem in
	Startup) start;;
	Shutdown) stop;;
	Status) status;;
	Exit) echo "Bye"; break;;
esac

done

# -- IF TEMP FILES FOUND, DELETE THEM:
	[ -f $INPUT ] && rm $INPUT
