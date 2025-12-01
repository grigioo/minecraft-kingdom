#!/bin/env bash

MODS_DIR="$HOME/Projects/minecraft-kingdom/mods/"
LISTS_DIR="$HOME/Projects/minecraft-kingdom/lists/"

while IFS=';' read -r NAME URL; do
    # ID equals name in URL
    MOD_ID=$(echo "$URL" | awk -F '/' '{print $5}')
    CLEAN_NAME=$( echo "$NAME" | sed 's# #-#g;s#:##g;s#\.##g;s#'\''##g' )

    echo "Ищем последнюю версию для: $NAME (ID: $MOD_ID)..."
    
    # GET link form API
    # DOWNLOAD_URL=$(curl -s "https://api.modrinth.com/v2/project/$MOD_ID/version" | \
    #                jq -r '[.[ ] | select(any(.game_versions[]; . == "1.21.8") and any(.loaders[]; . == "fabric"))] | .[0].files[0].url')

    DOWNLOAD_INFO=$(curl -s "https://api.modrinth.com/v2/project/$MOD_ID/version" | \
        jq -r '[ 
            .[ ] | select(any(.game_versions[]; . == "1.21.8") and any(.loaders[]; . == "fabric")) 
        ] | .[0] | { 
            "url": .files[0].url, 
            "env": if .environment == null then "client-server" else
                if (.environment.client == "required" and .environment.server == "unsupported") then "client" else
                if (.environment.client == "unsupported" and .environment.server == "required") then "server" else
                "client-server"
                end end end 
        }')

    DOWNLOAD_URL=$(echo "$DOWNLOAD_INFO" | jq -r '.url')
    CATEGORY=$(echo "$DOWNLOAD_INFO" | jq -r '.env')

    mkdir -p "$MODS_DIR/$CATEGORY"

    if [ -n "$DOWNLOAD_URL" ]; then
        echo "   -> Скачивание по URL: $DOWNLOAD_URL"
        wget -O "$MODS_DIR/$CATEGORY/$CLEAN_NAME.jar" "$DOWNLOAD_URL"
    else
        echo "   -> Ошибка: Не найдена подходящая версия для $NAME."
    fi

done < $LISTS_DIR/mods-url.txt