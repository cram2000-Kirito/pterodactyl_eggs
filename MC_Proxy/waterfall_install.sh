#!/bin/bash
# Waterfall Installation Script
# Server Files: /mnt/server

# Waterfall Installation

PROJECT=waterfall

apt update
apt install -y curl jq

if [ -n "${DL_LINK}" ]; then
	echo -e "Using supplied download url: ${DL_LINK}"
	DOWNLOAD_URL=`eval echo $(echo ${DL_LINK} | sed -e 's/{{/${/g' -e 's/}}/}/g')`
else
	VER_EXISTS=`curl -s https://papermc.io/api/v2/projects/${PROJECT} | jq -r --arg VERSION $MINECRAFT_VERSION '.versions[] | contains($VERSION)' | grep true`
	LATEST_VERSION=`curl -s https://papermc.io/api/v2/projects/${PROJECT} | jq -r '.versions' | jq -r '.[-1]'`

	if [ "${VER_EXISTS}" == "true" ]; then
		echo -e "Version is valid. Using version ${MINECRAFT_VERSION}"
	else
		echo -e "Using the latest ${PROJECT} version"
		MINECRAFT_VERSION=${LATEST_VERSION}
	fi
	
	BUILD_EXISTS=`curl -s https://papermc.io/api/v2/projects/${PROJECT}/versions/${MINECRAFT_VERSION} | jq -r --arg BUILD ${BUILD_NUMBER} '.builds[] | tostring | contains($BUILD)' | grep true`
	LATEST_BUILD=`curl -s https://papermc.io/api/v2/projects/${PROJECT}/versions/${MINECRAFT_VERSION} | jq -r '.builds' | jq -r '.[-1]'`
	
	if [ "${BUILD_EXISTS}" == "true" ]; then
		echo -e "Build is valid for version ${MINECRAFT_VERSION}. Using build ${BUILD_NUMBER}"
	else
		echo -e "Using the latest ${PROJECT} build for version ${MINECRAFT_VERSION}"
		BUILD_NUMBER=${LATEST_BUILD}
	fi
	
	JAR_NAME=${PROJECT}-${MINECRAFT_VERSION}-${BUILD_NUMBER}.jar
	
	echo "Version being downloaded"
	echo -e "MC Version: ${MINECRAFT_VERSION}"
	echo -e "Build: ${BUILD_NUMBER}"
	echo -e "JAR Name of Build: ${JAR_NAME}"
	DOWNLOAD_URL=https://papermc.io/api/v2/projects/${PROJECT}/versions/${MINECRAFT_VERSION}/builds/${BUILD_NUMBER}/downloads/${JAR_NAME}
fi

cd /mnt/server
mkdir waterfall
cd waterfall

echo -e "Running curl -o ${SERVER_JARFILE} ${DOWNLOAD_URL}"

if [ -f ${SERVER_JARFILE} ]; then
	mv ${SERVER_JARFILE} ${SERVER_JARFILE}.old
fi

curl -o ${SERVER_JARFILE} ${DOWNLOAD_URL}

if [ ! -f config.yml ]; then
	echo -e "Downloading ${PROJECT} config.yml"
	curl -o config.yml https://raw.githubusercontent.com/parkervcp/eggs/master/game_eggs/minecraft/proxy/java/waterfall/config.yml
else
	echo -e "${PROJECT} config.yml exists. Will not pull a new file"
fi
