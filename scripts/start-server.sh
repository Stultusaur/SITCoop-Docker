#!/bin/bash
if [ ! -f ${SERVER_DIR}/Aki.Server.exe ]; then
  echo "Aki.Server.exe not found, downloading version 3.7.5"
  wget --content-disposition --quiet -O ${SERVER_DIR}/AkiServer.zip 'https://dev.sp-tarkov.com/attachments/1608ad54-029c-4ba1-93c6-b4d43f9f13c4'
  7za x ${SERVER_DIR}/AkiServer.zip -o${SERVER_DIR}/ -aoa
  rm ${SERVER_DIR}/AkiServer.zip -f

elif [ -f ${SERVER_DIR}/Aki.Server.exe ]; then
  ExifCommand="$(exiftool -ProductVersion ${SERVER_DIR}/Aki.Server.exe)"
  if [[ "$ExifCommand" == *3.7.3* ]] && [ ${UPDATE} = true ]; then
    echo "$ExifCommand version is installed, updating to 3.7.5"
    echo "Archiving current SPT install to backup.tar"
    tar --exclude "${SERVER_DIR}/WINE64" -cf ${SERVER_DIR}/backup.tar ${SERVER_DIR}/*
    wget --content-disposition --quiet -O ${SERVER_DIR}/AkiServer.zip 'https://dev.sp-tarkov.com/attachments/1608ad54-029c-4ba1-93c6-b4d43f9f13c4'
    7za x ${SERVER_DIR}/AkiServer.zip -o${SERVER_DIR}/ -aoa -y -bsp0 -bso0
    rm ${SERVER_DIR}/AkiServer.zip -f
  fi
fi

if [ -f ${COOP_DIR}/package.json ]; then 
  SITCoopVersion=$(grep  '"version":' ${COOP_DIR}/package.json)
  if [[ "$SITCoopVersion" != *1.5.1* ]] && [ ${UPDATE} = true ]; then
    echo "$SITCoopVersion found, downloading 1.5.1"
    wget --content-disposition --quiet -O ${SERVER_DIR}/user/mods/SITCoop.zip 'https://github.com/stayintarkov/SIT.Aki-Server-Mod/releases/download/1.5.1/SITCoop.zip'
    7za x ${SERVER_DIR}/user/mods/SITCoop.zip -o${SERVER_DIR}/user/mods -aoa -y -bsp0 -bso0
  fi
elif [ ! -f ${COOP_DIR}/package.json ]; then
  echo "SITCoop not found, downloading"
  mkdir -p ${SERVER_DIR}/user/mods
  wget --content-disposition --quiet -O ${SERVER_DIR}/user/mods/SITCoop.zip 'https://github.com/stayintarkov/SIT.Aki-Server-Mod/releases/download/1.5.1/SITCoop.zip'
  7za x ${SERVER_DIR}/user/mods/SITCoop.zip -o${SERVER_DIR}/user/mods -aoa -y -bsp0 -bso0
  # mv ${SERVER_DIR}/user/mods/SIT.Aki-Server-Mod-2023-12-04 ${COOP_DIR}
  mkdir ${COOP_DIR}/config
  rm ${SERVER_DIR}/user/mods/SITCoop.zip -f
fi

if [ ! -f ${COOP_DIR}/config/coopConfig.json ]; then
  echo "coopConfig.json not found, creating"
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

#export WINEARCH=win64
export WINEPREFIX=/serverdata/serverfiles/WINE64
export WINEDEBUG=-all
echo "---Checking if WINE workdirectory is present---"
if [ ! -d ${SERVER_DIR}/WINE64 ]; then
  echo "---WINE workdirectory not found, creating please wait...---"
  mkdir ${SERVER_DIR}/WINE64
else
  echo "---WINE workdirectory found---"
fi
echo "---Checking if WINE is properly installed---"
if [ ! -d ${SERVER_DIR}/WINE64/drive_c/windows ]; then
  echo "---Setting up WINE---"
  cd ${SERVER_DIR}
  winecfg > /dev/null 2>&1
  sleep 15
else
  echo "---WINE properly set up---"
fi

chmod -R ${DATA_PERM} ${DATA_DIR}
echo "---Start Server---"

if [ ! -f ${SERVER_DIR}/Aki.Server.exe ]; then
  echo "---Something went wrong, can't find the executable, putting container into sleep mode!---"
  sleep infinity
else
  cd ${SERVER_DIR}
  NODE_SKIP_PLATFORM_CHECK=1 wine64 ${SERVER_DIR}/Aki.Server.exe
fi
