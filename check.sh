#!/bin/sh
# クラスタストアのチェックスクリプト

CHK_ETCD=$(docker info |grep "Cluster store: etcd:")

if [ "CHK_ETCD" != "" ];
then
  echo "cluster store: etcd"
  echo  "$ etcdctl ls /swarm"
  etcdctl ls /swarm
  echo  "$ run --rm swarm list etcd://192.168.200.1:2379/swarm"
  docker run --rm swarm list etcd://192.168.200.1:2379/swarm
else
  echo "cluster store: consul"
  echo "$ consule members"
  consule members
  echo "$ docker run --rm swarm list consul://192.168.200.1:8500/docker-swarm"
  docker run --rm swarm list consul://192.168.200.1:8500/docker-swarm
fi

