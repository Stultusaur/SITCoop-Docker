FROM ich777/winehq-baseimage

LABEL org.opencontainers.image.authors="stultusaur@gmail.com"
LABEL org.opencontainers.image.source="https://github.com/Stultusaur/SITCoop-Docker"

RUN apt-get update && \
	apt-get -y install --no-install-recommends lib32gcc-s1 lib32stdc++6 lib32z1 screen xvfb winbind p7zip-full exiftool \
	curl git gnupg

RUN curl -fsSL https://deb.nodesource.com/setup_18.x | bash - && \
	apt-get install -y nodejs \
	build-essential && \
	node --version && \ 
	npm --version && \
	rm -rf /var/lib/apt/lists/*

ENV DATA_DIR="/serverdata"
ENV SERVER_DIR="${DATA_DIR}/serverfiles"
ENV COOP_DIR="${SERVER_DIR}/user/mods/SITCoop"
ENV LOCAL_IP="0.0.0.0"
ENV EXTERNAL_IP="127.0.0.1"
ENV UPDATE=true
ENV UMASK=000
ENV UID=99
ENV GID=100
ENV USER="sit"
ENV DATA_PERM=770

EXPOSE 6969/tcp
EXPOSE 6970/tcp

RUN mkdir $DATA_DIR && \
	mkdir $SERVER_DIR && \
	useradd -d $DATA_DIR -s /bin/bash $USER && \
	chown -R $USER $DATA_DIR && \
	ulimit -n 2048

ADD /scripts/ /opt/scripts/
RUN chmod -R 770 /opt/scripts/

#Server Start
ENTRYPOINT ["/opt/scripts/start.sh"]