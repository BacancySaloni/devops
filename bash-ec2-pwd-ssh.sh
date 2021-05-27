udo adduser bacancy1  --disabled-password --system
echo "bacancy1:bacancy1" | sudo chpasswd
sudo usermod -aG sudo bacancy1
sudo usermod -s /bin/bash bacancy1
cd /home/bacancy1
sudo mkdir .ssh
sudo touch /home/bacancy1/.ssh/authorized_keys
#sudo touch /home/ubuntu/.ssh/id_rsa.pub
sudo cp /home/ubuntu/.ssh/id_rsa.pub /home/bacancy1/.ssh/authorized_keys
sudo chmod -R go= /home/bacancy1/.ssh

