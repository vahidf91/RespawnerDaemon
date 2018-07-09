# RespawnerDaemon
RespawnerDaemon is a Linux Daemon is a Linux script which protects your application from stopping and in case of stop it will bring your app to live again. Daemons are processes in Linux which run in the background and does not have any interaction with user. 
My intention for writing this script was to create an easy to use Linux Daemon who could protect important applications from stopping. I had options like turning my app to a service, use init systems like `BusyBox` or use `Fork` but I wanted something to log important messages for me. It has a `incidents.log` which logs important messages for admins and a pid file(`app.pid`) that keeps the pid for every run of my app. This process will be repeated every 30 seconds. This Daemon has 4 important states which should be known to the people who use it. 

1-	It searches the directory structure for `app.pid`. If `app.pid` is not found and the app is not running it means the app is stopped gracefully so it starts everthing from the beginning.

2-	If `app.pid` not found and the app is running, It means that a sabotage has happened and the pid file is deleted. So it logs the incident and reproduces `app.pid`.

3-	If `app.pid` found and the app was running it means everything works fine and it writes the elapsed time and the date to the `incidents.log`.

4-	If `app.pid` found and the process was not running it means the process is stopped, so it writes this incidents down and starts the process again and reproduces `app.pid`.

Remember you must force your application to write its pid down in the app.pid whenever it starts and removes `app.pid` whenever it gracefully stops.

You must run RespawnerDaemon in the background so you can turn it into a service or run it with nohup or use `>/dev/null 2>&1 &` at the end of `RespawnerDaemon.sh` start process to make it work in the background. The start command would be like this:

`nuhop RespawnerDaemon.sh >/dev/null 2>&1 &`

