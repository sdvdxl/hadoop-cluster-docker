FROM tutum/ubuntu:trusty

MAINTAINER sdvdxl <sdvdxl@163.com>

WORKDIR /root
RUN rm -rf /etc/localtime && ln -s /usr/share/zoneinfo/Asia/Shanghai /etc/localtime
# install openssh-server, openjdk and wget
COPY config/sources.list.trusty /tmp/
RUN cat /tmp/sources.list.trusty>/etc/apt/sources.list
#RUN apt-get update && apt-get install -y openssh-server 
RUN rm -rf /tmp/sources.list.trusty

# install hadoop 2.7.2
ADD soft/hadoop-2.7.2.tar.gz .
RUN mv hadoop-2.7.2 /usr/local/hadoop

# scala
ADD soft/scala-2.10.4.tar.gz /usr/local/jvm
ENV SCALA_HOME=/usr/local/jvm/scala-2.10.4

#spark
COPY soft/spark-1.6.1-bin-hadoop2.6.tgz .
RUN tar -xvf spark-1.6.1-bin-hadoop2.6.tgz && mv spark-1.6.1-bin-hadoop2.6 /usr/local/spark && rm -rf spark-1.6.1-bin-hadoop2.6.tgz 
ENV SPARK_HOME=/usr/local/spark

# set environment variable
COPY soft/jdk-8u91-linux-x64.tar.gz .
RUN mkdir -p /usr/lib/jvm
RUN tar -xvf jdk-8u91-linux-x64.tar.gz && mv jdk1.8.0_91 /usr/lib/jvm/java && rm -rf jdk-8u91-linux-x64.tar.gz
ENV JAVA_HOME=/usr/lib/jvm/java
ENV HADOOP_HOME=/usr/local/hadoop 
ENV HADOOP_CONF_DIR=$HADOOP_HOME/etc/hadoop
ENV YARN_CONF_DIR=$HADOOP_HOME/etc/hadoop
ENV PATH=$PATH:$JAVA_HOME/bin:/usr/local/hadoop/bin:/usr/local/hadoop/sbin:$SCALA_HOME/bin:$SPARK_HOME/bin

# ssh without key
RUN ssh-keygen -t rsa -f ~/.ssh/id_rsa -P '' && \
    cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys


RUN mkdir -p /data/hdfs/namenode && \ 
    mkdir -p /data/hdfs/datanode && \
    mkdir -p /data/logs/hadoop

RUN ln -s /data/logs/hadoop/ /usr/local/hadoop/logs

COPY config/* /tmp/

RUN mv /tmp/ssh_config ~/.ssh/config && \
    mv /tmp/hadoop-env.sh /usr/local/hadoop/etc/hadoop/hadoop-env.sh && \
    mv /tmp/hdfs-site.xml $HADOOP_HOME/etc/hadoop/hdfs-site.xml && \ 
    mv /tmp/core-site.xml $HADOOP_HOME/etc/hadoop/core-site.xml && \
    mv /tmp/mapred-site.xml $HADOOP_HOME/etc/hadoop/mapred-site.xml && \
    mv /tmp/yarn-site.xml $HADOOP_HOME/etc/hadoop/yarn-site.xml && \
    mv /tmp/slaves $HADOOP_HOME/etc/hadoop/slaves && \
    mv /tmp/start-hadoop.sh ~/start-hadoop.sh && \
    mv /tmp/run-wordcount.sh ~/run-wordcount.sh &&\
    mv /tmp/init-hdfs.sh ~/init-hdfs.sh

RUN chmod +x ~/start-hadoop.sh && \
    chmod +x ~/run-wordcount.sh && \
    chmod +x $HADOOP_HOME/sbin/start-dfs.sh && \
    chmod +x $HADOOP_HOME/sbin/start-yarn.sh 

# format namenode
#EXPOSE 9000 50090 36788 50070 22 8030 8031 8032 8033 8088 33531
VOLUME /bigdata
VOLUME /data
CMD [ "sh", "-c", "service ssh start; bash"]

