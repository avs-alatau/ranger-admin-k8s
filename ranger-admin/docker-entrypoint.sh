#!/bin/bash

export JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64
export HADOOP_HOME=/etc/hadoop-default
export RANGER_HOME=/opt/apache-ranger/ranger-current-admin
 
cd ${RANGER_HOME} && \
source ./setup.sh
rm -rf ${RANGER_HOME}/ews/webapp/WEB-INF/classes/conf/core-site.xml && \
ln -s ${HADOOP_HOME}/core-site.xml ${RANGER_HOME}/ews/webapp/WEB-INF/classes/conf/ && \
find ${RANGER_HOME} -name "*.sh" -execdir chmod u+x {} + && \
chown -R ranger: /opt/apache-ranger/ranger-current-admin  && \
su - ranger && \
/opt/apache-ranger/ranger-current-admin/ews/ranger-admin-services.sh start  && \
tail -f /opt/apache-ranger/ranger-current-admin/ews/logs/ranger-admin-*.log
