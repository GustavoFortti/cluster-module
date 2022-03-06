FROM ubuntu:bionic

# set environment vars
ENV HADOOP_HOME /opt/hadoop
ENV JAVA_HOME /usr/lib/jvm/java-8-openjdk-amd64

# install packages
RUN apt-get update && apt-get install -y \
    net-tools \
    ssh \
    rsync \
    vim \
    openjdk-8-jdk \
    default-jre

# copy and extract hadoop, set JAVA_HOME in hadoop-env.sh, update path
COPY /packages/hadoop-3.3.1.tar.gz /root/ 
RUN tar -xzf /root/hadoop-3.3.1.tar.gz -C /root/ && rm -f /root/hadoop-3.3.1.tar.gz && \
    mv /root/hadoop-3.3.1 $HADOOP_HOME && \
    echo "export PATH=$PATH:$HADOOP_HOME/bin" >> ~/.bashrc && \
    echo "export JAVA_HOME=$JAVA_HOME" >> $HADOOP_HOME/etc/hadoop/hadoop-env.sh 
  
# create ssh keys
RUN ssh-keygen -t rsa -P '' -f ~/.ssh/id_rsa && \
    cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys && \
    chmod 0600 ~/.ssh/authorized_keys

# copy hadoop configs
ADD packages/configure_hadoop/*xml $HADOOP_HOME/etc/hadoop/

# copy script to start hadoop and spark
ADD /packages/configure_system.sh configure_system.sh

# expose various ports
EXPOSE 8088 50070 50075 50030 50060

# start system configuration
CMD bash configure_system.sh