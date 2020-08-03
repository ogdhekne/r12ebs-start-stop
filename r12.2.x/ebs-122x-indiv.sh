#!/bin/bash
#-----------------------------------------------------------------------------------------------------------#
# Startup/Shutdown Utility Script for Oracle E-Business Suite 12.2.x (Individual service - start/stop)      #
# This script is licenced under GPLv2 ; you can get your copy from http://www.gnu.org/licenses/gpl-2.0.html #
# (C) Omkar Dhekne ; ogdhekne@yahoo.in                                                                      #
# Note: A_PASS: PASSWORD FOR APPS SCHEMA ; W_PASS: WEBLOGIC SERVER PASSWORD                                 #
# * IMPORTANT: Set BASE, SID, HOST, A_PASS, W_PASS  before running script.                                  #
#-----------------------------------------------------------------------------------------------------------#

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


# -- FUNC: STARTUP
start()
{

db()
{
# -- START DB:
	source $BASE/fs1/EBSapps/appl/$SID\_$HOST.env

	$BASE/12.1.0/appsutil/scripts/$SID\_$HOST/addbctl.sh start
	$BASE/12.1.0/appsutil/scripts/$SID\_$HOST/addlnctl.sh start $SID

# -- PRINT MESSAGE:
	echo "                                           "
	echo -e "Press ${GRAY:-} [Enter] ${RESET:-} to return main-menu."
	read enter
}


apps()
{
# -- START APPS:
	source $BASE/fs1/EBSapps/appl/APPS$SID\_$HOST.env

	{ echo apps; echo $A_PASS; echo $W_PASS; } | sh $BASE/fs1/inst/apps/$SID\_$HOST/admin/scripts/adstrtal.sh @ -nopromptmsg

# -- PRINT MESSAGE:
	echo "                                           "
	echo -e "Press ${GRAY:-} [Enter] ${RESET:-} to return main-menu."
	read enter
}

}


# -- FUNC: SHUTDOWN
stop()
{

db()
{
# -- STOP DB:
	source $BASE/fs1/EBSapps/appl/$SID\_$HOST.env

	$BASE/12.1.0/appsutil/scripts/$SID\_$HOST/addlnctl.sh stop $SID
	$BASE/12.1.0/appsutil/scripts/$SID\_$HOST/addbctl.sh stop immediate

# -- PRINT MESSAGE:
	echo "                                           "
	echo -e "Press ${GRAY:-} [Enter] ${RESET:-} to return main-menu."
	read enter
}


apps()
{
# -- STOP APPS:
	source $BASE/fs1/EBSapps/appl/APPS$SID\_$HOST.env

	{ echo apps; echo $A_PASS; echo $W_PASS; } | sh $BASE/fs1/inst/apps/$SID\_$HOST/admin/scripts/adstpall.sh @ -nopromptmsg

# -- PRINT MESSAGE:
	echo "                                           "
	echo -e "Press ${GRAY:-} [Enter] ${RESET:-} to return main-menu."
	read enter
}

}


# -- FUNC: STATUS
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

# -- EXECUTE FUCTIONS:
$1 ; $2