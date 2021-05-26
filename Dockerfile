FROM ubuntu:20.04

ADD https://github.com/krallin/tini/releases/download/v0.19.0/tini /sbin/tini
ADD https://github.com/tsl0922/ttyd/releases/download/1.6.3/ttyd.x86_64 /usr/bin/ttyd
RUN chmod a+x /sbin/tini /usr/bin/ttyd

ENV TZ=UTC TERM=xterm-256color

RUN apt-get update -qy \
    && apt-get install -qy --no-install-recommends tzdata \
    && ln -fs /usr/share/zoneinfo/UTC /etc/localtime && dpkg-reconfigure -f noninteractive tzdata \
    && apt-get install -qy --no-install-recommends \
        python3 \
        python3-setuptools \
        python3-pip \
        zip \
        unzip \
        p7zip-full \
        wget \
        nano \
        detox \
        tmux \
        curl \
        aria2 \
        htop \
        net-tools \
        fakeroot \
        git \
        xterm \
    && apt-get autoclean -qy \
    && apt-get autoremove -qy \
    && pip3 install gdown \
    && pip3 install speedtest-cli \
    && rm -rf /var/lib/apt/lists/*

COPY . .    
ADD ./mc /app/mc
RUN chmod +x /app/mc && mv /app/mc /usr/local/bin/
ENV LOGIN_USER admin
ENV LOGIN_PASSWORD admin

#EXPOSE 7681

ENTRYPOINT ["/sbin/tini", "--"]
#CMD ["ttyd", "bash"]
CMD while true; do fakeroot -- bash start.sh; sleep 2; done
