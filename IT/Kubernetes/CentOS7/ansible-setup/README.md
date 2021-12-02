# ansible-k8s-setup
This will setup a kubernetes cluster on Centos7 machines using ansible.
You need these machines:
2. Kubernetes Master - hk-master - 10.10.6.11 - 2 vcpu / 4 gib ram
3. Kubernetes Node1 - hk-node1 - 10.10.6.21 - 1 vcpu / 4 gib ram
4. Kubernetes Node2 - hk-node2 - 10.10.6.22 - 1 vcpu / 4 gib ram
5. Kubernetes Node2 - hk-node3 - 10.10.6.23 - 1 vcpu / 4 gib ram

If you can allocate more compute resources, its better
If you change your machine IP's then you have to change those whereever
those were referred.
