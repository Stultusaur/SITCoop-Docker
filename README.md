# SITCoop using SPT-AKI version 3.7.5
This docker will download the SPT-Aki version 3.7.5 and SITCoop server version release: 1.5.1 | Client version 1.9.8767.26420
**WARNING:** You have to run the docker container using the -i -t switches, (interactive and TTY), this is due to how the nodeJS application runs.

Note this docker container does not automatically update to new version, due to how the SPT-Aki and SITCoop files are named. I may look into making it automatic in the future.

## Example Env params
| Name | Value | Example |
| --- | --- | --- |
| SERVER_DIR | Folder for gamefile | /serverdata/serverfiles |
| EXTERNAL_IP | External IP | 127.0.0.1 |
| LOCAL_IP | Local IP | 0.0.0.0 |
| UID | User Identifier | 99 |
| GID | Group Identifier | 100 |

## Run example
```
docker run --name SITCoop -d -t -i \
	--env 'UID=99' \
	--env 'GID=100' \
    --env 'EXTERNAL_IP=127.0.0.1' \
    --volume /path/to/sitcoop:/serverdata/serverfiles \
    stultusaur/sitcoop:latest
```
To find your external IP go to https://whatismyipaddress.com/

This docker container was created with assistance from ich777/docker-steamcmd-server

If any issues arise, please create an issue with any logs/information available.

# Regards
Thank you to Christoph "ich777" Hummer, would not have gotten this container created as fast without his base images.
Thanks to Paulov and everyone else that helps supporting the SIT Coop mod.
Thank to SPT-Aki Devs for creating SPT-Aki.