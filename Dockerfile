FROM dockerimages/ubuntu-vm:14.04
RUN echo "deb http://repos.mesosphere.io/ubuntu trusty main" | sudo tee /etc/apt/sources.list.d/mesosphere.list
RUN sudo apt-key adv --keyserver keyserver.ubuntu.com --recv E56151BF
RUN sudo apt-get -y update
RUN sudo apt-get -y install curl python-setuptools python-pip python-dev python-protobuf zookeeperd mesos deimos chronos marathon docker.io
RUN echo 1 | sudo dd of=/var/lib/zookeeper/myid
RUN sudo ln -sf /usr/bin/docker.io /usr/local/bin/docker
RUN sudo sed -i '$acomplete -F _docker docker' /etc/bash_completion.d/docker.io
RUN sudo mkdir -p /etc/mesos-master
RUN echo in_memory | sudo dd of=/etc/mesos-master/registry
RUN sudo mkdir -p /etc/mesos-slave
## Configure Deimos as a containerizer
RUN echo /usr/local/bin/deimos | sudo tee /etc/mesos-slave/containerizer_path
RUN echo external | sudo tee /etc/mesos-slave/isolation

#sudo initctl reload-configuration
#sudo service docker.io restart
#sudo restart zookeeper
#sudo restart marathon
#sudo restart mesos-master
#sudo restart mesos-slave
# Adding to runit
mkdir /etc/service/marathon && \
mkdir /etc/service/zookeeper && \
mkdir /etc/service/mesos-master && \
mkdir /etc/service/mesos-slave && \
echo <<EOF > /etc/service/marathon/run
#!/bin/sh
set -e
exec /usr/sbin/sshd -D
EOF>>
