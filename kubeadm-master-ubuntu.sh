#!/bin/bash

# Script made by Suyash Joshi

curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -

sudo add-apt-repository    "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"

curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -

cat << EOF | sudo tee /etc/apt/sources.list.d/kubernetes.list
deb https://apt.kubernetes.io/ kubernetes-xenial main
EOF

sudo apt-get update

sudo apt-get install -y docker-ce kubelet kubeadm kubectl

sudo apt-mark hold docker-ce kubelet kubeadm kubectl

echo "net.bridge.bridge-nf-call-iptables=1" | sudo tee -a /etc/sysctl.conf

sudo sysctl -p

sudo kubeadm init --pod-network-cidr=10.244.0.0/16 --ignore-preflight-errors=all
# See if port 6443 is open in master node.
# sudo su -
# cp /etc/kubernetes/admin.conf $HOME/
# chown $(id -u):$(id -g) $HOME/admin.conf
# export KUBECONFIG=$HOME/admin.conf

# echo 'export KUBECONFIG=$HOME/admin.conf' >> $HOME/.bashrc

# Try following three commands as root user, if problem occurs and then if the persists, execute above commands.
mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config

sudo kubectl apply -f https://raw.githubusercontent.com/coreos/flannel/master/Documentation/kube-flannel.yml

kubeadm token create --print-join-command