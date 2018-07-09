#!/bin/bash
APP_HOME=<path_to_myApp>

while true; do
	PIDS=`cat $APP_HOME/app.pid`
            if [ -z "$PIDS" ]; then
            echo "PID not found. Checking app status."
            sleep 1
            PIDS=`/usr/ucb/ps -awwwx | grep $APP_HOME/app.sh | grep -v grep  | /usr/bin/nawk -F" " '{print $1}'`
					if [ -z "$PIDS" ]; then
					echo -e "\e[31m`date`: 1- app is stopped. Respawner will run from the beginning. This incident will be reported.\e[m"
                                        echo -e "\e[33m`date`: 001 - app is stopped\e[m" >> $APP_HOME/incidents.log
										chmod 777 $APP_HOME/incidents.log
                                        sleep 1
										$APP_HOME/app.sh &
										else
					echo "2- app is running but PID file is missing. Respawner will recreate it. This incident will be reported."
					echo -e "\e[33m`date`: 002 - app is already running and its pid is $PIDS but PID file is missing\e[m" >> $APP_HOME/incidents.log
					chmod 777 $APP_HOME/incidents.log
					PIDS=`/usr/ucb/ps -awwwx | grep $APP_HOME/app.sh | grep -v grep  | /usr/bin/nawk -F" " '{print $1}'`
					echo $PIDS >> $APP_HOME/app.pid
					chmod 777 $APP_HOME/app.pid
                    fi
            else
			###
			echo "PID is $PIDS"
			echo "verifying app status"
			PIDS=`/usr/ucb/ps -awwwx | grep $APP_HOME/app.sh | grep -v grep  | /usr/bin/nawk -F" " '{print $1}'`
                                if [ -n "$PIDS" ]; then
								echo -e "\e[33m`date`: 003 app is already running and its pid is $PIDS.\e[m"
								echo -e "\e[33melapsedtime:`ps -o etime= -p "$PIDS"`(dd-hh:mm:ss)\e[m"
								
								echo -e "\e[33m`date`: 003 app is already running and its pid is $PIDS.\e[m" >> $APP_HOME/incidents.log
								echo -e "\e[33melapsedtime:`ps -o etime= -p "$PIDS"`(dd-hh:mm:ss)\e[m" >> $APP_HOME/incidents.log
								chmod 777 $APP_HOME/incidents.log
								
                                else
                                echo -e "\e[31m`date`: 004 - app pid file exists but it is stopped. Respawner will run from the beginning.\e[m"
								echo "`date` 004 app pid file exists but it is stopped." >> $APP_HOME/incidents.log
								chmod 777 $APP_HOME/incidents.log
                                $APP_HOME/planned_events.sh &
								fi
			         fi
    sleep 30
    done
