FROM ich777/winehq-baseimage

LABEL org.opencontainers.image.authors="stultusaur@gmail.com"
LABEL org.opencontainers.image.source="https://github.com/Stultusaur/learningtodocker"

RUN apt-get update && \
	apt-get -y install --no-install-recommends lib32gcc-s1 lib32stdc++6 lib32z1 screen xvfb winbind && \
	rm -rf /var/lib/apt/lists/*

ENV DATA_DIR="/serverdata"
#ENV WINE_DIR="${DATA_DIR}/steamcmd"
ENV SERVER_DIR="${DATA_DIR}/serverfiles"
ENV LOCAL_IP="127.0.0.1"
ENV EXTERNAL_IP=""
ENV UMASK=000
ENV UID=99
ENV GID=100
ENV USER="steam"
ENV DATA_PERM=770