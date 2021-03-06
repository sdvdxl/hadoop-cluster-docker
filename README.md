## Run Hadoop Custer within Docker Containers

本库克隆自[https://github.com/kiwenlau/hadoop-cluster-docker](https://github.com/kiwenlau/hadoop-cluster-docker) 并进行了适当修改，修改了部分错误，并修改源为国内的，从国内地址下载响应软件，以加快处理速度，并修改系统时区为+8。

##### 1. 克隆库

```
git clone https://github.com/sdvdxl/hadoop-cluster-docker.git
```
##### 2. 下载软件
本库中并未提交对应的软件，下面列出用到的软件，下载后重命名为要求的名字并放到本库根目录下：     

软件 | 名字和版本 |地址(如果下载不下载或者不放心，也可以从官方下载)
-----| ----- | -----
scala|scala-2.10.4.tar.gz|http://7xrmam.com1.z0.glb.clouddn.com/scala-2.10.4.tar.gz
spark|spark-1.6.1-bin-hadoop2.6.tar.gz|http://7xrmam.com1.z0.glb.clouddn.com/spark-1.6.1-bin-hadoop2.6.tar.gz
hadoop|hadoop-2.7.2.tar.gz|http://7xrmam.com1.z0.glb.clouddn.com/hadoop-2.7.2.tar.gz

##### 3. docker 构建镜像

```
cd hadoop-cluster-docker
docker build -t hadoop-cluster .
```

##### 4. 创建 hadoop network

```
docker network create --driver=bridge hadoop
```



##### 5. 启动容器

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
启动成功后会直接进入master容器内

##### 6. 初始化 hdfs
第一次启动需要使用脚本 `./init-hdfs.sh` 初始化hdfs。

##### 7. 启动 hadoop
```
./start-hadoop.sh
```

##### 8. 运行 wordcount

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

##### 9. 通过web查看application
如果是windows或者mac，通过 `docker-machine ip default` 命令查看docker ip，然后可以在浏览器中通过 `ip:8088` 进行查看。如果是linux直接通过linux主机 `ip:8088` 即可查看。

##### 10. 挂载目录
本镜像可以挂载目录到容器内的 `/data` 和 `/bigdata` 目录。
