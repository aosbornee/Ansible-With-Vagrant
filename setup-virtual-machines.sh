#!/bin/bash

vagrant up

scp install-all-dependencies.yml vagrant@192.168.33.12:/home/vagrant/
ssh vagrant@192.168.33.12 << EOF

export ANSIBLE_HOST_KEY_CHECKING=False
ansible web -m copy -a "src=/home/vagrant/app dest=/home/vagrant"

sudo apt-get install sshpass -y
sudo apt-get install software-properties-common -y
sudo apt-get install tree -y
sudo apt-add-repository--yes--update ppa:ansible/ansible;
sudo apt-get install ansible -y


sudo su
cd /etc/ansible
echo "[web]
192.168.33.10 ansible_connection=ssh ansible_ssh_user=vagrant ansible_ssh_pass=vagrant" >> hosts
echo "[db]
192.168.33.11 ansible_connection=ssh ansible_ssh_user=vagrant ansible_ssh_pass=vagrant" >> hosts
echo "[aws]
192.168.33.12 ansible_connection=ssh ansible_ssh_user=vagrant ansible_ssh_pass=vagrant" >> hosts

# go into web server
# sshpass -p 'vagrant' vagrant@192.168.33.10
# sudo apt-get install sshpass -y
# sudo apt-get update -y
# sudo apt-get upgrade -y
# exit

#go into db server
sshpass -p 'vagrant' vagrant@192.168.33.11
sudo apt-get install sshpass -y
sudo apt-get update -y
sudo apt-get upgrade -y
exit

# running my app in controller

#sshpass -p 'vagrant' vagrant@192.168.33.12
#ansible-playbook install-all-dependencies.yml

exit
EOF


ssh vagrant@192.168.33.10 << EOF

echo export DB_HOST="mongodb://vagrant@192.168.33.11:27017/posts" >> ~/.bashrc
sshpass -p 'vagrant' vagrant@192.168.33.10
sudo apt-get install sshpass -y
sudo apt-get update -y
sudo apt-get upgrade -y

exit

EOF

ssh vagrant@192.168.33.12 << EOF

export ANSIBLE_HOST_KEY_CHECKING=False#
ansible web -m copy -a "src=/home/vagrant/app dest=/home/vagrant"
ansible-playbook install-all-dependencies.yml

exit

EOF
