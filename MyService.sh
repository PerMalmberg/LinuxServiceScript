#!/bin/sh

# Copyright (c) 2016 Per Malmberg
# Licensed under the MIT license, see LICENSE file.


SERVICE_NAME="MyService"
PATH_TO_JAR="/usr/local/MyProject/MyJar.jar"
PATH_TO_JAVA="java"

STD_OUT="/dev/null"
STD_ERR="/dev/null"

PATH_TO_PID="/tmp/$SERVICE_NAME-pid"

StartService() 
{
	if [ -f $PATH_TO_JAR ]; then
		echo "Starting $SERVICE_NAME ..."
		if [ -f $PATH_TO_PID ]; then
			echo "$SERVICE_NAME is already running ..."
		else
			nohup $PATH_TO_JAVA -jar $PATH_TO_JAR 2>> $STD_ERR 1>> $STD_OUT & echo $! > $PATH_TO_PID
			echo "$SERVICE_NAME started ..."
		fi
	else
		echo "Specified JAR ($PATH_TO_JAR) does not exist"
	fi
}

StopService()
{
	if [ -f $PATH_TO_PID ]; then
		PID=$(cat $PATH_TO_PID);
		echo "$SERVICE_NAME stopping ..."
		kill "$PID"
		echo "$SERVICE_NAME stopped ..."
		Clean
	else
		echo "$SERVICE_NAME is not running ..."
	fi
}

Clean()
{
	rm "$PATH_TO_PID"
}

case $1 in
	start)
		StartService
	;;
	stop)
		StopService
	;;
	restart)
		StopService
		StartService
	;;
	clean)
		echo "Removing PID file"
		Clean
	;;
esac
