FROM debian:bookworm

ENV DEBIAN_FRONTEND noninteractive

RUN echo "deb http://deb.debian.org/debian bookworm-backports main contrib non-free" >> /etc/apt/sources.list
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
      apt-transport-https \
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
#      ltrace \
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

# add Kubernetes repo
RUN curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.30/deb/Release.key | gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg && \
    echo 'deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.30/deb/ /' > /etc/apt/sources.list.d/kubernetes.list

# Install packages from other repos
RUN apt-get update && apt-get install -y \
    kubectl \
    sysdig \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

ARG VEGETA_VERSION=12.11.1
ARG VEGETA_SHA256=1dbdb525fe82e084626e02e73405eb386a3ed1a894426e22f440f6565b3e5d17
# Add vegeta
WORKDIR /tmp
RUN wget -q "https://github.com/tsenart/vegeta/releases/download/v${VEGETA_VERSION}/vegeta_${VEGETA_VERSION}_linux_amd64.tar.gz" && \
    echo -n "${VEGETA_SHA256}  vegeta_${VEGETA_VERSION}_linux_amd64.tar.gz" | sha256sum -c - && \
    tar -xzvf "vegeta_${VEGETA_VERSION}_linux_amd64.tar.gz" && \
    mv -v vegeta /usr/local/bin
