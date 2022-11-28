FROM debian:buster

ENV DEBIAN_FRONTEND noninteractive

RUN echo "deb http://deb.debian.org/debian buster-backports main contrib non-free" >> /etc/apt/sources.list
RUN apt-get update && apt-get install -y --no-install-recommends \
      apache2-utils \
      atop \
      ca-certificates \
      coreutils \
      curl \
      dnsutils \
      dstat \
      findutils \
      gnupg \
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
    sysdig \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# Add vegeta
WORKDIR /tmp
RUN wget -q 'https://github.com/tsenart/vegeta/releases/download/v12.8.4/vegeta_12.8.4_linux_amd64.tar.gz' && \
    echo -n "c9a8866d748976a5cd012d436887b8af4e99b58e67c3e5da7558858bfc8b0477  vegeta_12.8.4_linux_amd64.tar.gz" | sha256sum -c - && \
    tar -xzvf vegeta_12.8.4_linux_amd64.tar.gz && \
    mv -v vegeta /usr/local/bin
