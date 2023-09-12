#prerequisite install java and update Ubuntu server
sudo apt update
sudo apt install default-jdk
# create a kafka user
sudo adduser kafka
# add kafka user to sudoers group
sudo usermod -aG sudo kafka
su - kafka
#password: $password
# create a directory to store kafka binaries
mkdir ~/Downloads
wget https://downloads.apache.org/kafka/3.5.1/kafka_2.13-3.5.1.tgz -o ~/Downloads/kafka.tgz
tar -xvf ~/Downloads/kafka.tgz
mv Downloads/kafka/ usr/local/kafka
# configuring Apache kafka

#edit zookeeper file unit
$zookeeper_text = "[Unit] \nDescription=Apache Zookeeper server\n Documentation=http://zookeeper.apache.org\n Requires=network.target remote-fs.target\n
After=network.target remote-fs.target\n [Service]\n Type=simple\n ExecStart=/usr/local/kafka/bin/zookeeper-server-start.sh /usr/local/kafka/config/zookeeper.properties\n ExecStop=/usr/local/kafka/bin/zookeeper-server-stop.sh\n
Restart=on-abnormal\n [Install]\n WantedBy=multi-user.target" 

 sudo echo -e  $zookeeper_text  >> /etc/systemd/system/zookeeper.service 

 #edit kafka file unit
 $kafka_text = "[Unit]\nDescription=Apache Kafka Server\nDocumentation=http://kafka.apache.org/documentation.html\n
Requires=zookeeper.service\n[Service]\nType=simple\nEnvironment=/usr/local/java\nExecStart=/usr/local/kafka/bin/kafka-server-start.sh /usr/local/kafka/config/server.properties\n
ExecStop=/usr/local/kafka/bin/kafka-server-stop.sh\n[Install]\nWantedBy=multi-user.target"

sudo echo -e $kafka_text >> /etc/systemd/system/kafka.service
# starting Apache kafka
sudo systemctl start kafka
# checking Apache kafka status 
sudo systemctl status kafka
sudo systemctl enable zookeeper
sudo systemctl enable kafka


