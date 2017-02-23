FROM ubuntu:16.04

RUN apt-get update && apt-get install -y systemd && apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
RUN cd /lib/systemd/system/sysinit.target.wants/; ls | grep -v systemd-tmpfiles-setup | xargs rm -f $1 \
rm -f /lib/systemd/system/multi-user.target.wants/*;\
rm -f /etc/systemd/system/*.wants/*;\
rm -f /lib/systemd/system/local-fs.target.wants/*; \
rm -f /lib/systemd/system/sockets.target.wants/*udev*; \
rm -f /lib/systemd/system/sockets.target.wants/*initctl*; \
rm -f /lib/systemd/system/basic.target.wants/*;\
rm -f /lib/systemd/system/anaconda.target.wants/*; \
rm -f /lib/systemd/system/plymouth*; \
rm -f /lib/systemd/system/systemd-update-utmp*;

RUN systemctl set-default multi-user.target

# touk / touktouk
RUN useradd \
    --home-dir /home/touk \
    --password '$6$l2p2QCii$PWv1hJjh9fj9FuM7RzDRZZQXwFUiST/LA8fv3n3BAuSdoTWU9pVSdZhu0K4cOYC4HLrq9l96s3zxXv7JlDK920'  \
    touk

RUN apt-get update && \
    apt-get install openssh-server sudo python -y && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

ADD files/ssh/* /etc/ssh/

RUN mkdir -p /root/.ssh/ && \
    mkdir -p /home/touk/.ssh
ADD files/authorized_keys /root/.ssh
ADD files/authorized_keys /home/touk/.ssh

RUN chmod 600 /root/.ssh/authorized_keys  && \
    chmod 600 /home/touk/.ssh/authorized_keys && \
    chown touk:touk /home/touk/.ssh/authorized_keys

RUN chmod 600 /etc/ssh/ssh_host_* && \
    chmod 644 /etc/ssh/ssh_host_*.pub

ADD files/sudoers.d/ /etc/sudoers.d/

RUN systemctl enable ssh.service

RUN apt-get update && apt-get install unzip -y && apt-get clean
ENV init /lib/systemd/systemd
VOLUME [ "/sys/fs/cgroup" ]

CMD ["/lib/systemd/systemd"]
