# Grok Execution environment - simple container.

# Capabilities: Python 3.13.16, Docker in Docker (for subagents?),

- looking into Podman as rootless container host for Grokbot or others. there are probaly better alternatives

## WSL one time setup (tested from powershell)

````
wsl sudo adduser 'guest' [Give it a password, but if you launch as root you may not need it]



```wsl
wsl -u
docker compose up -d
docker attach grok-grok-1
authorize at https://accounts.x.ai/oauth2/device/consent?user_code=
(only applicable for demo.. if we can use api that would be easier..)
(also it keeps asking if we want to opt in which is annoying)

````


# Run Linux Docker in Docker via WSL 2. This runs it once and with a lot of priv, but needed for sockets and whatnot?

docker run --privileged -d --name local-dind docker:dind

now verify docker can be run from container.
ok, this is extra.. we can run as many containers as we need.

# or maybe this option: a rootless hardened image from docker hub (something) enterprise.

https://hub.docker.com/hardened-images/catalog/dhi/docker-dind/images
https://cristina.tech/2022/11/21/use-podman-to-build-docker-images-in-gitlab-cicd

docker login dhi.io
docker pull dhi.io/docker-dind:29-alpine-dev

and then map outer container network to this dind image for isolation on dind runners

podman run -it ubuntu

cleanup: wipe dhi.io/docker-dind and that local-dind from above that's running privileged.

Can I get a token with Docker hub (hub.docker.com) to give podman a secure login.

podman login docker.io --authfile ~/.docker/config.json

A program needs a file. You have a string. Some programs accept - to read from StdIn.
echo your string into the StdInput pipe to the program.  
echo "[value]" | [program] -
echo "relicx74:keyhere" | base64 -
echo "[base64 user:pass]" | base64 -d -

finding: the only way I've been able to cli login to docker.io via podmon is to not use a password on my relicx74 account. I've tried a valid credential.

but if credsStore is in ~/.docker/config.json then docker uses wincred, pass (linux) or osxkeychain

# Skipping for now.. Podman can run local and existing pods. I'll need to get them if needed.

# Troubleshooting the files needed for a new container.

need to somehow login as guest on wsl.. so wsl -u or something
adduser 'guest' from wsl

from grok docs:
sessions live in /root/.grok/sessions/ # so...
$HOME is /root/.grok # and other files are here as well. # project skills go in <cwd> (the github folder on host, which gets mounted as the dockerfile defined WORKDIR "/work" directory)

Put project skills in <cwd>/.grok/skills/ and personal ones in /root/.grok/skills/ on the persisted mount. --trust is what lets the project skills load.

/root on agent is generally the project folder on the host.

# key learning: -v from docker run command doesn't make a persistent volume that overlays files. Instead any files from image get nuked in favor of host files.

The solution is to use a named volume docker compose. We're going to add in wsl so that Grok can hopefully run docker in docker (for his subagents?). Fun. :-)

```
need to base64 encode [user]:[password] (without the brackets)

```
