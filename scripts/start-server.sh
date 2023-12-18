#!/bin/bash
if [ ! -f ${SERVER_DIR}/Aki.Server.exe ]; then
  echo "Aki.Server not found"
  wget --content-disposition -O ${SERVER_DIR}/AkiServer.zip 'https://dev.sp-tarkov.com/attachments/5551fbd4-9c7a-41d6-a4a1-db99d7103ea4'
  7za x ${SERVER_DIR}/AkiServer.zip -o${SERVER_DIR}/ -aoa
  rm ${SERVER_DIR}/AkiServer.zip -f
fi

if [ ! -d ${COOP_DIR} ]; then
  mkdir -p ${SERVER_DIR}/user/mods
  wget --content-disposition -O ${SERVER_DIR}/user/mods/SITCoop.zip 'https://github.com/stayintarkov/SIT.Aki-Server-Mod/archive/refs/tags/2023-12-04.zip'
  7za x ${SERVER_DIR}/user/mods/SITCoop.zip -o${SERVER_DIR}/user/mods -aoa
  mv ${SERVER_DIR}/user/mods/SIT.Aki-Server-Mod-2023-12-04 ${COOP_DIR}
  mkdir ${COOP_DIR}/config
  rm ${SERVER_DIR}/user/mods/SITCoop.zip -f
fi

if [ ! -f ${COOP_DIR}/config/coopConfig.json ]; then
  touch ${COOP_DIR}/config/coopConfig.json
  echo -e "{\n\t\"protocol\": \"http\",\n\t\"externalIP\": \"${EXTERNAL_IP}\", \
   \n\t\"webSocketPort\": 6970,\n\t\"webSocketTimeoutSeconds\": 5, \
   \n\t\"webSocketTimeoutCheckStartSeconds\": 120\n}" >> ${COOP_DIR}/config/coopConfig.json
  elif [ -f ${COOP_DIR}/config/coopConfig.json ]; then
    sed -i "s/[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}/${EXTERNAL_IP}/g" ${COOP_DIR}/config/coopConfig.json
fi

if [ -f ${SERVER_DIR}/Aki_Data/Server/configs/http.json ]; then
  sed -i "s/[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}/${LOCAL_IP}/g" ${SERVER_DIR}/Aki_Data/Server/configs/http.json
fi

