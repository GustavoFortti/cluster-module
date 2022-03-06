#!/bin/bash

# start ssh server
/etc/init.d/ssh start

# Passando alguns parâmetros iniciais para o start do serviço
echo 'export HDFS_NAMENODE_USER="root"' >> $HADOOP_HOME/etc/hadoop/hadoop-env.sh
echo 'export HDFS_NAMENODE_GROUP="root"' >> $HADOOP_HOME/etc/hadoop/hadoop-env.sh
echo 'export HDFS_DATANODE_USER="root"' >> $HADOOP_HOME/etc/hadoop/hadoop-env.sh
echo 'export HDFS_SECONDARYNAMENODE_USER="root"' >> $HADOOP_HOME/etc/hadoop/hadoop-env.sh
echo 'export YARN_NODEMANAGER_USER="root"' >> $HADOOP_HOME/etc/hadoop/yarn-env.sh
echo 'export YARN_RESOURCEMANAGER_USER="root"' >> $HADOOP_HOME/etc/hadoop/yarn-env.sh

# format namenode
$HADOOP_HOME/bin/hdfs namenode -format

# start hadoop
$HADOOP_HOME/sbin/start-dfs.sh
$HADOOP_HOME/sbin/start-yarn.sh

# start spark
# keep container running
# tail -f /dev/null
/bin/bash 