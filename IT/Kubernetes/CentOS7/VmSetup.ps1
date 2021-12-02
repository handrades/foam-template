#https://www.youtube.com/watch?v=SrhmT-zzoeA

$prefix = 'HK-'
$VMs = echo Master Node1 Node2 Node3
$Ram = 4096MB
$Disk = 20GB

$hypervPath = 'C:\HyperV'

foreach ($VM in $VMs) {
    New-VM -Name "$prefix$VM" -MemoryStartupBytes $Ram -Path $hypervPath
    New-VHD -Path "$($hypervPath)\$prefix$VM\$prefix$VM.vhdx" -SizeBytes $Disk -Dynamic
    Add-VMHardDiskDrive -VMName "$prefix$VM" -Path "$($hypervPath)\$prefix$VM\$prefix$VM.vhdx"
    Set-VMDvdDrive -VMName "$prefix$VM" -ControllerNumber 1 -Path "C:\HyperV\ISOs\CentOS-7-x86_64-Minimal-2009.iso"
}

################
# set manually #
################

# install minimal OS on all nodes
# set time
# set Network to DHCP
# set server name
# set root password
# set handrade username and password

# Once VM restarts set static IP using 'nmtui edit eth0'

# HK-Master 10.10.6.11
# HK-Node1 10.10.6.21
# HK-Node2 10.10.6.22
# HK-Node3 10.10.6.23

##########
# On WSL #
##########

# Install ansible
sudo apt update
sudo apt install software-properties-common
sudo add-apt-repository --yes --update ppa:ansible/ansible
sudo apt install ansible

# enable ssh
ssh-keygen
    #follow prompts

# copy public ssh key to kubernetes nodes
ssh-copy-id handrade@10.10.6.11
ssh-copy-id handrade@10.10.6.21
ssh-copy-id handrade@10.10.6.22
ssh-copy-id handrade@10.10.6.23

# configure DNS on ansible box
sudo -- sh -c "echo '10.10.6.11 hk-master' >> /etc/hosts"
sudo -- sh -c "echo '10.10.6.21 hk-node1' >> /etc/hosts"
sudo -- sh -c "echo '10.10.6.22 hk-node2' >> /etc/hosts"
sudo -- sh -c "echo '10.10.6.23 hk-node3' >> /etc/hosts"

# if you want to ssh from your windows box
echo master node1 node2 node3 | %{scp C:\users\hector.andrade\.ssh\id_rsa.pub hk-$($_):/home/handrade/.ssh/hector.pub}
echo master node1 node2 node3 | %{ssh hk-$($_) 'more /home/handrade/.ssh/hector.pub >> /home/handrade/.ssh/authorized_keys;rm /home/handrade/.ssh/hector.pub'}

###########
# Ansible #
###########

# copy ansible-k8s-setup folder to /home/hektop
cp -r ansible-k8s-setup/ /home/hektop

# make sure ansible sees hosts nodes
ansible masters --list-hosts
ansible workers --list-hosts
ansible all --list-hosts

# install packages on all nodes
ansible-playbook k8s-pkg.yml --syntax-check
ansible-playbook k8s-pkg.yml
#if you get an error when running line above add -kK to enter passwords
ansible-playbook k8s-pkg.yml -kK
#or
ansible-playbook k8s-pkg.yml -K


# configure master node
ansible-playbook k8s-master.yml --syntax-check
ansible-playbook k8s-master.yml
#or
ansible-playbook k8s-master.yml -kK
#or
ansible-playbook k8s-master.yml -K


# configure workers node
ansible-playbook k8s-workers.yml --syntax-check
ansible-playbook k8s-workers.yml
#or
ansible-playbook k8s-workers.yml -kK
#or
ansible-playbook k8s-master.yml -K


#############
# HK-MASTER #
#############
ssh hk-master
kubectl get nodes
