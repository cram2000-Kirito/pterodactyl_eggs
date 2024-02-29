#!/bin/bash
# ViaProxy Installation Script
# ViaProxy Installation

mkdir viaproxy
cd viaproxy

# Vérifier si la variable VIAPROXY_DOWNLOAD ne contient pas une URL
if echo "$VIAPROXY_DOWNLOAD" | grep -qv '^http[s]?://'; then
    # Vérifier si la version est 'latest'
    if [ "$VIAPROXY_VERSION" = "latest" ]; then
        # Obtenir l'URL du fichier .jar de la dernière release
        VIAPROXY_DOWNLOAD=$(curl --silent "https://api.github.com/repos/ViaVersion/ViaProxy/releases/latest" | jq -r '.assets[1] | select(.name | contains(".jar")) | .browser_download_url')
    else
        # Obtenir l'URL du fichier .jar de la release spécifiée
        VIAPROXY_DOWNLOAD=$(curl --silent "https://api.github.com/repos/ViaVersion/ViaProxy/releases/tags/v${VIAPROXY_VERSION}" | jq -r '.assets[1] | select(.name | contains(".jar")) | .browser_download_url')
    fi
fi

curl -L -o ${VIAPROXY_JARFILE} ${VIAPROXY_DOWNLOAD}

# ViaProxyMultiLaunch Installation

# Vérifier si la variable MULTIAUNCH_DOWNLOAD ne contient pas une URL
if echo "$MULTIAUNCH_DOWNLOAD" | grep -qv '^http[s]?://'; then
    # Vérifier si la version est 'latest'
    if [ "$MULTIAUNCH_VERSION" = "latest" ]; then
        # Obtenir l'URL du fichier .jar de la dernière release
        MULTIAUNCH_DOWNLOAD=$(curl --silent "https://api.github.com/repos/ViaVersionAddons/ViaProxyMultiLaunch/releases/latest" | jq -r '.assets[1] | select(.name | contains(".jar")) | .browser_download_url')
    else
        # Obtenir l'URL du fichier .jar de la release spécifiée
        MULTIAUNCH_DOWNLOAD=$(curl --silent "https://api.github.com/repos/ViaVersionAddons/ViaProxyMultiLaunch/releases/tags/v${MULTIAUNCH_VERSION}" | jq -r '.assets[1] | select(.name | contains(".jar")) | .browser_download_url')
    fi
fi



mkdir plugins
cd plugins
curl -L -o ${MULTIAUNCH_JARFILE} ${VIAPROXY_DOWNLOAD}

# Geyser Installation
curl -L -o Geyser-ViaProxy.jar https://download.geysermc.org/v2/projects/geyser/versions/latest/builds/latest/downloads/viaproxy

echo -e "Install Complete"
