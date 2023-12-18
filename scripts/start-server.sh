#!/bin/bash
if [ ! -f ${SERVER_DIR}/Aki.Server.exe ]; then
  echo "Aki.Server not found, downloading"
  wget --content-disposition --quiet -O ${SERVER_DIR}/AkiServer.zip 'https://dev.sp-tarkov.com/attachments/5551fbd4-9c7a-41d6-a4a1-db99d7103ea4'
  7za x ${SERVER_DIR}/AkiServer.zip -o${SERVER_DIR}/ -aoa
  rm ${SERVER_DIR}/AkiServer.zip -f
fi

if [ ! -f ${SERVER_DIR}/start-sit.sh ]; then
  echo "start-sit.sh not found, creating"
  touch ${SERVER_DIR}/start-sit.sh
  echo -e "#!/bin/sh\nNODE_SKIP_PLATFORM_CHECK=1 wine ${SERVER_DIR}/Aki.Server.exe"


if [ ! -d ${COOP_DIR} ]; then
  echo "SITCoop not found, downloading"
  mkdir -p ${SERVER_DIR}/user/mods
  wget --content-disposition --quiet -O ${SERVER_DIR}/user/mods/SITCoop.zip 'https://github.com/stayintarkov/SIT.Aki-Server-Mod/archive/refs/tags/2023-12-04.zip'
  7za x ${SERVER_DIR}/user/mods/SITCoop.zip -o${SERVER_DIR}/user/mods -aoa
  mv ${SERVER_DIR}/user/mods/SIT.Aki-Server-Mod-2023-12-04 ${COOP_DIR}
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
node --version
dotnet --info

if [ ! -f ${SERVER_DIR}/Aki.Server.exe ]; then
  echo "---Something went wrong, can't find the executable, putting container into sleep mode!---"
  sleep infinity
else
  cd ${SERVER_DIR}
  sh "start-sit.sh"
  sleep infinity
fi

