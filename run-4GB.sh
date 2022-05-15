#!/bin/sh
# James Chambers - V1.0 - March 24th 2018
# Marc Tönsing - V1.2 - September 16th 2019
# Modified by Joey Reinhart
# Minecraft Server low spec startup script using screen
cd $HOME/minecraft/
printf "Updating Server.\n"
BUILD="$(curl -L -s http://papermc.io/api/v2/projects/paper/versions/1.18.2 | jq '.builds[-1]')"
curl -s -o server.jar https://papermc.io/api/v2/projects/paper/versions/1.18.2/builds/$BUILD/downloads/paper-1.18.2-$BUILD.jar
printf "Starting Minecraft server.  To view window type screen -r minecraft.\n"
printf "To minimize the window and let the server run in the background, press Ctrl+A then Ctrl+D\n"
/usr/bin/screen -dmS minecraft /usr/bin/java -jar -Xms2500M -Xmx2500M $HOME/minecraft/server.jar
