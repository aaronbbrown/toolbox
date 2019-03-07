FROM debian:stretch

ENV DEBIAN_FRONTEND noninteractive

RUN echo "deb http://httpredir.debian.org/debian stretch-backports main contrib non-free" >> /etc/apt/sources.list
RUN apt-get update && apt-get install -y --no-install-recommends \
      atop \
      ca-certificates \
      coreutils \
      curl \
      dnsutils \
      dstat \
      findutils \
      htop \
      iptables \
      jq \
      less \
      lsof \
      ltrace \
      man-db \
      manpages \
      mtr \
      net-tools \
      netcat-traditional \
      ngrep \
      procps \
      sed \
      socat \
      silversearcher-ag \
      strace \
      sysstat \
      tcpdump \
      traceroute \
      tshark \
      vim-tiny \
      wget \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# Add sysdig repository
RUN curl -s https://s3.amazonaws.com/download.draios.com/DRAIOS-GPG-KEY.public | apt-key add - && \
    curl -s -o /etc/apt/sources.list.d/draios.list https://s3.amazonaws.com/download.draios.com/stable/deb/draios.list

# Install packages from our repo
RUN apt-get update && apt-get install -y \
    bcc-tools \
    gpstree \
    sysdig \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# Add vegeta
WORKDIR /tmp
RUN wget -q https://github.com/tsenart/vegeta/releases/download/cli%2Fv12.2.1/vegeta-12.2.1-linux-amd64.tar.gz && \
    echo -n "b1ca092c0a45a5c7d3092d9c2e00505dc40b9091bc01267651e887e12b30f1ca  vegeta-12.2.1-linux-amd64.tar.gz" | sha256sum -c - && \
    tar -xzvf vegeta-12.2.1-linux-amd64.tar.gz && \
    mv -v vegeta /usr/local/bin
