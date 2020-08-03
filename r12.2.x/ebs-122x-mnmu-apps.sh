#!/bin/bash
#-----------------------------------------------------------------------------------------------------------#
# Startup/Shutdown Utility Script for Oracle E-Business Suite 12.2.x - MULTI NODE - MULTI USER : APPS       #
# This script is licenced under GPLv2 ; you can get your copy from http://www.gnu.org/licenses/gpl-2.0.html #
# (C) Omkar Dhekne ; ogdhekne@yahoo.in                                                                      #
# This script requires 'dialog' package installed in system. To check # rpm -qa  | grep dialog              #
# Note: A_PASS: PASSWORD FOR APPS SCHEMA ; W_PASS: WEBLOGIC SERVER PASSWORD                                 #
# * IMPORTANT: Set BASE, SID, HOST, A_PASS, W_PASS  before running script.                                  #
#-----------------------------------------------------------------------------------------------------------#

# -- STORE MENU OPTIONS SELECTED BY USER:
	INPUT=$HOME/.menu.sh.$$

# -- TRAP AND DELETE TEMP FILES:
	trap "rm $INPUT; exit" SIGHUP SIGINT SIGTERM

# -- ENV:
	export BASE=""
	export SID=""
	export HOST="`hostname -a`"
	export A_PASS=""
	export W_PASS=""

# -- COLORS:

	export RESET="\e[0m"
	export GRAY="\e[100m"

# -- PROCESSES:
    export LISTN="$(ps -ef |  grep tns | grep 12.1.0 | sed '$ d' | wc -l)"
    export DB="$(ps -ef | grep ora_ | grep $SID | sed '$ d' | wc -l)"
    export APP="$(ps -ef | grep fs1 | sed '$ d' | wc -l)"

# -- FUNC:

start()
{

# -- START APPS:
	source $BASE/fs1/EBSapps/appl/APPS$SID\_$HOST.env

	{ echo apps; echo $A_PASS; echo $W_PASS; } | sh $BASE/fs1/inst/apps/$SID\_$HOST/admin/scripts/adstrtal.sh @ -nopromptmsg

# -- PRINT MESSAGE:
	echo "                                           "
	echo -e "Press ${GRAY:-} [Enter] ${RESET:-} to return main-menu."
	read enter
}

stop()
{

# -- STOP APPS:
	source $BASE/fs1/EBSapps/appl/APPS$SID\_$HOST.env

	{ echo apps; echo $A_PASS; echo $W_PASS; } | sh $BASE/fs1/inst/apps/$SID\_$HOST/admin/scripts/adstpall.sh @ -nopromptmsg


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
    Processes: APPS: $APP
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
dialog --clear --backtitle "STARTUP/SHUTDOWN UTILITY FOR EBS 12.2.x " \
--title "[ M A I N - M E N U ]" \
--menu "               NOTE: USE ARROW KEYS TO NAVIGATE" 15 68 4	 \
Startup "Start APPS Services." \
Shutdown "Stop APPS Services." \
Status "Status of APPS." \
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
