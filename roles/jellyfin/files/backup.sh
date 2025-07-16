#!/bin/bash
echo "Stopping Jellyfin service"
service jellyfin stop

echo "Waiting to stop"
sleep 5

echo "Creating backup folder"
TIMESTAMP=$(date +%Y-%m-%d_%H%M%S)
FOLDER="/home/jellyfin/backup/jellyfin.${TIMESTAMP}"
mkdir -p $FOLDER
jellyfin --version 2> ${FOLDER}/version.txt

echo "Getting media file list"
tree /media/ssd/ > ${FOLDER}/tree.txt

echo "Backing up data"
cp -a /var/lib/jellyfin ${FOLDER}/data

echo "Backing up config"
cp -a /etc/jellyfin ${FOLDER}/config

echo "Deleting metadata backup"
rm -rf ${FOLDER}/data/metadata

echo "Compressing backup"
tar -czvf ${FOLDER}.tar.gz ${FOLDER} && rm -rf ${FOLDER}
chown jellyfin:jellyfin ${FOLDER}.tar.gz

echo "Waiting to start"
sleep 5

echo "Starting Jellyfin service"
service jellyfin start