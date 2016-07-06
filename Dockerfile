FROM tutum/ubuntu:trusty

MAINTAINER sdvdxl <sdvdxl@163.com>

WORKDIR /root
#修改时区
RUN rm -rf /etc/localtime && ln -s /usr/share/zoneinfo/Asia/Shanghai /etc/localtime

COPY  config/sources.list.trusty /etc/apt/sources.list
RUN apt-get update && apt-get install -q telnet
# install hadoop 2.7.2
ADD soft/hadoop-2.7.2.tar.gz /usr/local

RUN mkdir -p /usr/local/jvm

# scala
ADD soft/scala-2.10.4.tar.gz /usr/local/jvm

#spark
ADD soft/spark-1.6.1-bin-hadoop2.6.tar.gz  /usr/local

# java
ADD soft/jdk-8u91-linux-x64.tar.gz /usr/local/jvm

# set environment variable
ENV JAVA_HOME=/usr/local/jvm/jdk1.8.0_91
ENV SPARK_HOME=/usr/local/spark-1.6.1-bin-hadoop2.6
ENV SCALA_HOME=/usr/local/jvm/scala-2.10.4.
ENV HADOOP_HOME=/usr/local/hadoop-2.7.2
ENV HADOOP_CONF_DIR=$HADOOP_HOME/etc/hadoop
ENV YARN_CONF_DIR=$HADOOP_HOME/etc/hadoop
ENV PATH=$PATH:$JAVA_HOME/bin:$HADOOP_HOME/bin:/usr/local/hadoop/sbin:$SCALA_HOME/bin:$SPARK_HOME/bin

# ssh without key
RUN ssh-keygen -t rsa -f ~/.ssh/id_rsa -P '' && \
    cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys


RUN mkdir -p /data/hdfs/namenode && \ 
    mkdir -p /data/hdfs/datanode && \
    mkdir -p /data/logs/hadoop

RUN ln -s /data/logs/hadoop/ $HADOOP_HOME/logs

COPY config/ssh_config /root/.ssh/config
COPY config/hadoop-env.sh config/hdfs-site.xml config/hdfs-site.xml config/core-site.xml \
     config/core-site.xml config/mapred-site.xml config/yarn-site.xml config/yarn-site.xml \
    config/slaves $HADOOP_HOME/etc/hadoop/
COPY config/start-hadoop.sh config/run-wordcount.sh config/init-hdfs.sh /root/

RUN chmod +x ~/start-hadoop.sh && \
    chmod +x ~/run-wordcount.sh && \
    chmod +x $HADOOP_HOME/sbin/start-dfs.sh && \
    chmod +x $HADOOP_HOME/sbin/start-yarn.sh 

# format namenode
#EXPOSE 9000 50090 36788 50070 22 8030 8031 8032 8033 8088 33531
VOLUME /bigdata
VOLUME /data
CMD [ "sh", "-c", "service ssh restart; bash"]

