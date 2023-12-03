FROM ubuntu:20.04

ENV TZ=Europe/Moscow
ARG RANGER_VERSION=2.4.0
ARG DEBIAN_FRONTEND=noninteractive
ARG RANGER_USER=ranger
ARG RANGER_USER_PASS="ranger"
ARG LANDSCAPE=dev
ARG HADOOP_VERSION=3.1.3

ENV JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64
ENV RANGER_HOME=/opt/apache-ranger/ranger-current-admin
ENV HADOOP_HOME=/etc/hadoop-default


RUN apt update -y && \
    apt install -y  \
    openjdk-8-jdk  \
    tzdata \
    jq  \
    jsvc  \
    wget  \
    python3.9  \
    net-tools  \
    bc \
    curl \
    apt-transport-https \
    gnupg \
    lsb-release && \
    rm -rf /var/lib/apt/lists/* && \
    cp /usr/share/zoneinfo/${TZ} /etc/localtime && \
    echo ${TZ} > /etc/timezone && \
    mkdir /opt/apache-ranger &&  \
    useradd -m -s /bin/bash $RANGER_USER && \
    echo "$RANGER_USER:$RANGER_USER_PASS" | chpasswd && \
    mkdir -p ${HADOOP_HOME}

WORKDIR /opt/apache-ranger

ADD https://apache-hadoop/git//apache-ranger-${RANGER_VERSION}.tar.gz /opt/apache-ranger

RUN tar -xzf ranger-${RANGER_VERSION}-admin.tar.gz &&  \
    ln -sf /opt/apache-ranger/ranger-${RANGER_VERSION}-admin ${RANGER_HOME} && \
    mkdir -p /etc/ranger/admin/keys &&  \
    rm -rf ranger-${RANGER_VERSION}-admin.tar.gz &&  \
    mkdir -p ${RANGER_HOME}/ews/webapp/WEB-INF/classes/conf && \
    mkdir -p ${RANGER_HOME}/ews/logs && \
    rm -rf ${RANGER_HOME}/install.properties && \
    cd ${RANGER_HOME}/ews/lib && \
    wget  https://jdbc.postgresql.org/download/postgresql-42.7.0.jar && \
    mv ${RANGER_HOME}/ews/lib/postgresql-42.7.0.jar ${RANGER_HOME}/ews/lib/postgresql.jar && \
    mkdir -p /var/run/ranger && \
    chown -R ${RANGER_USER}: /var/run/ranger

WORKDIR ${RANGER_HOME}

COPY install.properties ${RANGER_HOME}
COPY docker-entrypoint.sh ${RANGER_HOME}
COPY ${HADOOP_HOME}/core-site.xml ${RANGER_HOME}/ews/webapp/WEB-INF/classes/conf

RUN chmod +x ${RANGER_HOME}/docker-entrypoint.sh && \
    chown -R $RANGER_USER: /opt/apache-ranger

EXPOSE 6080

#USER ranger

ENTRYPOINT ${RANGER_HOME}/docker-entrypoint.sh
