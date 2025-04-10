#!/bin/bash

# Define ports to check
PORTS="10250 10257 10258 6443 2379 2380 10259"

echo "Checking for processes using ports: $PORTS"
PIDS=$(lsof -t -i :10250 -i :10257 -i :10258 -i :6443 -i :2379 -i :2380 -i :10259)

if [ -n "$PIDS" ]; then
    echo "Killing processes: $PIDS"
    kill -9 $PIDS
else
    echo "No processes found using the specified ports."
fi


kubeadm reset -f


# Remove Kubernetes configuration
echo "Removing /etc/kubernetes directory..."
cd /etc && rm -rf kubernetes
rm -rf /var/lib/kubelet
#cd /etc/cni
#sudo rm -rf net.d
# Remove etcd data
echo "Removing /var/lib/etcd data..."
cd /var/lib/etcd && rm -rf *

# Navigate to script directory and execute master.sh
echo "Running master.sh..."
cd /home/vagrant/kubeadm-scripts/scripts && ./master.sh
