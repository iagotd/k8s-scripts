# :8ball: k8s-scripts :8ball:

## Steps to prepare the master node 
1) Send the install-k8s.sh and setup-k8s-master.sh scripts to the master node (remember to use the proper username, IP, path, and password)
```
scp install-k8s.sh setup-k8s-master.sh <REMOTE_USERNAME>@<REMOTE_PUBLIC_IP>:<REMOTE_HOME_DIRECTORY>
```

2) Run scripts (first the install-k8s.sh and then the other)
```
sh install-k8s.sh
sh setup-k8s-master.sh
```

3) Copy the output of the setup-k8s-master.sh script to run on the workers nodes. To be more precise, you should copy the output of the `kubeadm token create --print-join-command` command. Run again if necessary.

4) Verify that the cluster is working with all the nodes after you complete the steps to prepare the worker nodes
```
kubectl get nodes
```

---

## Steps to prepare the worker nodes
1) Send the install-k8s.sh script to the master node (remember to use the proper username, IP, path, and password)
```
scp install-k8s.sh <REMOTE_USERNAME>@<REMOTE_PUBLIC_IP>:<REMOTE_HOME_DIRECTORY>
```

2) Run script
```
sh install-k8s.sh
```

3) Run output of the master `kubeadm token create --print-join-command`