Docker Clusterインストーラ
-----------------------

# 概要

※ 本スクリプトは開発中のため不具合がある可能性があるのでご注意ください。

本スクリプトは、下記のDocker環境(のいずれか)を簡単にセットアップします。

* Dockerのoverlayネットワークのみを利用できるようにする(site_overlaynetwork.yml)
* Docker Swarmクラスタを構築する(site_swarm.yml)
* Kubernatesクラスタを構築する(site_k8s.yml)

# 前提条件

現時点での動作確認バージョンは、Docker 1.9.1と
CentOS 7.2/Ubuntu 15.10を利用しています。

Systemdを採用したバージョンを前提としているため、
Systemd採用以前のUbuntuでは正しく動作しません。

/etc/hostnameが下記の通り設定されている必要があります。

* ホスト名はすべてのノードで異なる名前を設定してください。
* ドメイン名は同じにしてください。

VMをコピーしてノードを作成する場合、ホスト名に注意してください。

# 構成

通常のノードと管理ノードを別々に作成します。
KVは、etcdとconsulが選択できるようになっていますがデフォルトはetcd
を利用します。

## 管理ノード

* Swarmコンテナが管理モード(manage)で動作します
* Swarmコンテナがノードモード(join)で動作するため、ノードとしても利用できます。
* etcd, consul(server mode)を起動します

Kubernatesの場合は、hyperkubeコンテナを利用して、ノードのセットアップを行います。

## 通常ノード

* Swarmコンテナがノードモード(join)で動作します。
* consul(clint mode)を起動します。

Kubernatesの場合は、hyperkubeコンテナを利用して、ノードのセットアップを行います。

# 使い方

## ホストの定義

docker-swarmディレクトリにあるhostsファイルでホスト定義を行います。
manageで管理ノードの設定を、nodesでホストノードの設定を行います。

  [manager]
  192.168.200.1

  
  [manager:vars]
  manage_if=eth0
  
  [nodes]
  192.168.200.2
  192.168.200.3
  192.168.200.4
  ...
  
  [nodes:vars]
  manage_if=eth0
  manager_ip=192.168.200.1

manage_ifはDocker内部で利用する通信のネットワークインタフェースを指定します。
インストール時に指定したインタフェースのIPアドレスを調査してセットアップを行うため、
ネットワークインタフェースには事前にIPアドレスが割り当てられている必要があります。
ホストノード(nodes)の設定では、管理ノードのIPアドレスをmanager_ipに設定する必要
があります。

## 事前準備

Docker ClusterインストーラはAnsibleを利用するため、Ansibleを事前にインストールし、
sh鍵を設定しておく必要があります。

### Ubuntuの場合

  # apt-get install ansible

### CentOSの場合

  # yum install -y epel-release
  # yum install -y ansible

### SSH鍵の設定

Ansibleを実行するホストで、下記のコマンドを実行しSSH鍵を作成します。

  # ssh-keygen

作成された公開鍵id_rsa.pubを各ノードの/root/.ssh/authorized_keysにコピーします。
アクセス権が誤っていると、鍵認証できないので、アクセス権を確認してください。

 # chmod 700 /root/.ssh
 # chmod 600 /root/.ssh/authorized_keys

 
## Swarmクラスタを構築

準備ができたら下記のコマンドを実行します

  # ansible-playbook site.yml -i hosts


# Tips

## プロキシの設定

インターネット接続にプロキシが必要な環境でSwarmクラスタを構築する場合は、
group_vars/allの下記の設定でプロキシの設定を行います。

  http_proxy: http://proxy.myoffice.com:8080/
  no_proxy: 127.0.0.1,192.168.200.1,192.168.200.2
