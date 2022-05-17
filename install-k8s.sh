#!bin/bash

# Update /etc/hosts file
cat << EOF | sudo tee -a /etc/hosts


# Custom hosts:
172.31.40.173 k8s-control
172.31.36.197 k8s-worker1
172.31.47.45 k8s-worker2
EOF

# Ensure kernel modules are activated everytime the server starts up
cat << EOF | sudo tee /etc/modules-load.d/containerd.conf
overlay
br_netfilter
EOF

# Activate those modules immediately
sudo modprobe overlay
sudo modprobe br_netfilter

# Add system-level settings needed to make Kubernetes networking work
cat << EOF | sudo tee /etc/sysctl.d/99-kubernetes-cri.conf
net.bridge.bridge-nf-call-iptables  = 1
net.ipv4.ip_forward                 = 1
net.bridge.bridge-nf-call-ip6tables = 1
EOF

# Make those settings work immediately
sudo sysctl --system

# Install containerd package
sudo apt-get update && sudo apt-get install -y containerd

# Create containerd configuration file
sudo mkdir -p /etc/containerd

# Generate file with containerd config default
sudo containerd config default | sudo tee /etc/containerd/config.taml

# Restart containerd to make sure that the new configuration is being used
sudo systemctl restart containerd

# Disable swap to make k8s work. This is required because the K8s scheduler has performance
# and stability issues within K8s when memory swapping is allowed
sudo swapoff -a

# Check if swap is deactivated
sudo cat /etc/fstab

# Install apt-transport and curl so we can update containerd
sudo apt-get update && sudo apt-get install -y apt-transport-https curl

# Add GPG key for the k8s package repository
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -

# Setup k8s repository entry
cat << EOF | sudo tee /etc/apt/sources.list.d/kubernetes.list
deb https://apt.kubernetes.io/ kubernetes-xenial main
EOF

# Pull latest package information
sudo apt-get update

# Install kubelet, kubeadm, and kubectl
sudo apt-get install -y kubelet=1.23.0-00 kubeadm=1.23.0-00 kubectl=1.23.0-00

# Make sure kubelet, kubeadm, and kubectl are not automatically updated
sudo apt-mark hold kubelet kubeadm kubectl