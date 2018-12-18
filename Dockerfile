FROM ubuntu:18.04
ARG docker_ver=18.09.0

ENV JAVA_HOME /usr/lib/jvm/java-8-openjdk-amd64
# links to commit hashes are listed inside posted Dockerfiles https://hub.docker.com/r/library/docker/
# NOTE: must match engine version that is directly pulled from Alpine's Dockerfile
# - go to https://hub.docker.com/r/library/docker/
# - click on the matching alpine version tag (eg, 18.09.0-dind)
# - pull the DIND_COMMIT has from the Dockerfile that opens, for 18.09.0-dind it will be:
#   https://raw.githubusercontent.com/docker-library/docker/91bbc4f7b06c06020d811dafb2266bcd7cf6c06d/18.09/dind/Dockerfile
ENV DIND_COMMIT 52379fa76dee07ca038624d639d9e14f4fb719ff

RUN apt-get update -y       \
    && apt-get upgrade -y   \
    && apt-get install -y   \
       apt-transport-https  \
       build-essential      \
       bzip2                \
       ca-certificates      \
       curl                 \
       git                  \
       iptables             \
       jq                   \
       lvm2                 \
       lxc                  \
       openjdk-8-jdk-headless  \
       unzip                \
       zip

# docker
RUN curl -fsSL "https://download.docker.com/linux/ubuntu/gpg" | apt-key add -qq - \
    && echo "deb [arch=amd64] https://download.docker.com/linux/ubuntu bionic stable" > /etc/apt/sources.list.d/docker.list \
    && apt-get update -qq \
    && apt-get install -y -qq --no-install-recommends docker-ce=5:"${docker_ver}~3-0~ubuntu-bionic"
# fetch DIND script
RUN curl -sSL https://raw.githubusercontent.com/docker/docker/${DIND_COMMIT}/hack/dind -o /usr/local/bin/dind \
    && chmod a+x /usr/local/bin/dind

COPY ./wrapper.sh /usr/local/bin/wrapper.sh
RUN chmod a+x /usr/local/bin/wrapper.sh

VOLUME /var/lib/docker
ENTRYPOINT []
CMD []
