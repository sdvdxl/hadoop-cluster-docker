#!/bin/bash

# the default node number is 3
N=${1:-3}


# start hadoop master container
 docker rm -f hadoop-master &> /dev/null
echo "start hadoop-master container..."
 docker run -itd \
                --net=hadoop \
                -p 50070:50070 \
                -p 8088:8088 \
                -p 9000:9000 \
                -p 8030:8030 \
                -p 8042:8042 \
                -p 2222:22\
                -v /Users/du/bigdata:/bigdata \
                -v /data:/data \
                --name hadoop-master \
                --hostname hadoop-master \
                hadoop-cluster &> /dev/null


# start hadoop slave container
i=1
while [ $i -lt $N ]
do
	 docker rm -f hadoop-slave$i &> /dev/null
	echo "start hadoop-slave$i container..."
	 docker run -itd \
	                --net=hadoop \
	                --name hadoop-slave$i \
	                --hostname hadoop-slave$i \
	                hadoop-cluster &> /dev/null
	i=$(( $i + 1 ))
done 

# get into hadoop master container
 docker exec -it hadoop-master bash
