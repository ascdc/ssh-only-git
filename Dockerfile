FROM ubuntu:trusty
MAINTAINER ASCDC <ascdc@gmail.com>

ADD run.sh /run.sh

RUN DEBIAN_FRONTEND=noninteractive && \
	chmod +x /*.sh && \
	apt-get update && \
	apt-get -y dist-upgrade && \
	apt-get -y install openssh-server pwgen git && \
	mkdir -p /var/run/sshd && \
	sed -i "s/PermitRootLogin.*/PermitRootLogin no/g" /etc/ssh/sshd_config && \
	mkdir -p /home/www/programs/ && \
	echo "if [ -f ~/.bashrc ]; then  " >> /home/www/.bash_profile && \
	echo "	. ~/.bashrc  " >> /home/www/.bash_profile && \
	echo "fi  " >> /home/www/.bash_profile && \
	echo "# User specific environment and startup programs  " >> /home/www/.bash_profile && \
	echo "PATH=$HOME/programs  " >> /home/www/.bash_profile && \
	echo "export PATH" >> /home/www/.bash_profile && \
	echo "export ll='ls -al'" >> /home/www/.bash_profile && \	
	ln -s /bin/date /home/www/programs/ && \
	ln -s /bin/ls /home/www/programs/ && \
	ln -s /usr/bin/git /home/www/programs/ 
	
	
ENV SFTP_PASS **None**

ENTRYPOINT ["/run.sh"]