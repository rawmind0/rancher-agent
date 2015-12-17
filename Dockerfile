FROM rawmind/rancher-python:0.0.1
MAINTAINER Raul Sanchez <rawmind@gmail.com>

# Install rancher agent and dependecies
RUN apk add --update iptables bridge-utils libaio conntrack-tools libffi-dev python-dev openssl-dev gcc musl-dev \
  && pip install eventlet cattle docker-py \
  && pip install --upgrade requests[security]==2.7.0 \
  && apk del libffi-dev python-dev musl-dev openssl-dev gcc && rm -rf /var/cache/apk/* \
  && curl -s http://stedolan.github.io/jq/download/linux64/jq > /usr/bin/jq; chmod +x /usr/bin/jq \
  && curl -s -L https://get.docker.com/builds/Linux/x86_64/docker-1.6.0 > /usr/bin/docker; chmod +x /usr/bin/docker \
  && curl -s -L https://github.com/rancherio/thin-provisioning-tools/releases/download/rancher-v0.1/pdata_tools > /usr/bin/pdata_tools; chmod +x /usr/bin/pdata_tools \
  && mkdir -p /var/lib/cattle /var/lib/rancher

LABEL "io.rancher.container.system"="rancher-agent"
ENV RANCHER_AGENT_IMAGE cf-registry.innotechapp.com/rancher-agent:0.0.0

COPY register.py resolve_url.py agent.sh run.sh /

ENTRYPOINT ["/run.sh"]
