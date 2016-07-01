##Run Hadoop Custer within Docker Containers

本库克隆自[https://github.com/kiwenlau/hadoop-cluster-docker](https://github.com/kiwenlau/hadoop-cluster-docker) 并进行了适当修改，修改了部分错误，并修改源为国内的，从国内地址下载响应软件，以加快处理速度。

#####1. download soft
本库中并未提交对应的软件，下面列出用到的软件，下载后重命名为要求的名字并放到本库根目录下：     

软件 | 名字和版本 |地址(如果下载不下载或者不放心，也可以从官方下载)
-----| ----- | -----
scala|scala-2.10.4.tar.gz|http://7xrmam.com1.z0.glb.clouddn.com/scala-2.10.4.tar.gz
spark|spark-1.6.1-bin-hadoop2.6.tgz|http://7xrmam.com1.z0.glb.clouddn.com/spark-1.6.1-bin-hadoop2.6.tgz
hadoop|hadoop-2.7.2.tar.gz|http://7xrmam.com1.z0.glb.clouddn.com/hadoop-2.7.2.tar.gz
#####2. clone github repository

```
git clone https://github.com/sdvdxl/hadoop-cluster-docker.git
```

#####3. create hadoop network

```
docker network create --driver=bridge hadoop
```

#####4. docker build image

```
cd hadoop-cluster-docker
docker build -t hadoop-cluster .
```

#####5. start container

```
./start-container.sh
```

**output:**

```
start hadoop-master container...
start hadoop-slave1 container...
start hadoop-slave2 container...
root@hadoop-master:~# 
```
- start 3 containers with 1 master and 2 slaves
- you will get into the /root directory of hadoop-master container

#####6. start hadoop

```
./start-hadoop.sh
```

#####7. run wordcount

```
./run-wordcount.sh
```

**output**

```
input file1.txt:
Hello Hadoop

input file2.txt:
Hello Docker

wordcount output:
Docker    1
Hadoop    1
Hello    2
```

###Arbitrary size Hadoop cluster

#####1. pull docker images and clone github repository

do 1~3 like section A

#####2. rebuild docker image

```
./resize-cluster.sh 5
```
- specify parameter > 1: 2, 3..
- this script just rebuild hadoop image with different **slaves** file, which pecifies the name of all slave nodes


#####3. start container

```
./start-container.sh 5
```
- use the same parameter as the step 2

#####4. run hadoop cluster 

do 5~6 like section A

