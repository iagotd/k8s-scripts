#!bin/bash

# Initilize the cluster
sudo kubeadm init --pod-network-cidr 192.168.0.0/16 --kubernetes-version 1.23.0

# Set up kube config
mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config

# Install the k8s Calico networking plugin
kubectl apply -f https://docs.projectcalico.org/manifest/calico.yaml

# Get a kubeadm token (run output as root on the worker nodes)
kubeadm token create --print-join-command