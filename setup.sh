#!/bin/bash
# Original Minecraft Server Installation Script - James A. Chambers - https://www.jamesachambers.com.
# Changes and simplifications by Marc Tönsing
# Modified by Joey Reinhart

printf "Minecraft Server installation script by James Chambers and Marc Tönsing - V1.0\n"
printf "Modified by Joey Reinhart\n"
printf "This script automaticly agrees to the Minecraft EULA for you\n"
printf "If you don't want to agree to the EULA press Ctrl+C now or wait 5 secconds for the script to start\n"
printf "You can read the EULA at https://www.minecraft.net/en-us/eula\n"

sleep 5

if [ -d "minecraft" ]; then
  printf "minecraft server directory already exists!  Exiting...\n"
  exit 1
fi

printf "Updating packages...\n"
sudo apt update > /dev/null

printf "Installing Java, screen and jq...\n"
sudo apt install openjdk-17-jre-headless screen jq -y > /dev/null

printf "Creating minecraft server directory...\n"
mkdir minecraft
cd minecraft

printf "Getting latest Paper Minecraft server...\n"
BUILD="$(curl -L -s http://papermc.io/api/v2/projects/paper/versions/1.18.2 | jq '.builds[-1]')"
curl -s -o server.jar https://papermc.io/api/v2/projects/paper/versions/1.18.2/builds/$BUILD/downloads/paper-1.18.2-$BUILD.jar

printf "Building the Minecraft server...\n"
java -jar server.jar > /dev/null

printf "Accepting the EULA...\n"
printf "eula=true\n" > eula.txt

printf "Grabbing run.sh from repository...\n"
curl -s -o run.sh https://raw.githubusercontent.com/oofmaster69420/RaspberryPiMinecraftServer/master/run-8GB.sh

TotalMemory=$(awk '/MemTotal/ { printf "%.0f\n", $2/1024 }' /proc/meminfo)
if [ $TotalMemory -lt 6000 ]; then
  curl -s -o run.sh https://raw.githubusercontent.com/oofmaster69420/RaspberryPiMinecraftServer/master/run-4GB.sh
fi

if [ $TotalMemory -lt 2500 ]; then
  curl -s -o run.sh https://raw.githubusercontent.com/oofmaster69420/RaspberryPiMinecraftServer/master/run-2GB.sh
fi

chmod +x run.sh

echo "Setup is complete. To run the server go to the minecraft directory and type ./run.sh"
echo "Don't forget to set up port forwarding on your router. The default port is 25565"
echo "Don't forget to set up the server.properties file to your liking."
echo "You can add plugins by placing the plugin files in the plugins folder inside the minecraft server directory"
