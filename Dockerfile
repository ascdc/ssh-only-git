FROM ubuntu:trusty
MAINTAINER ASCDC <ascdc@gmail.com>

ADD run.sh /run.sh
ADD make_chroot_jail.sh /usr/local/sbin/make_chroot_jail.sh

RUN DEBIAN_FRONTEND=noninteractive && \
	chmod +x /*.sh && \
	apt-get update && \
	apt-get -y dist-upgrade && \
	apt-get install ssh openssh-server nano sudo debianutils coreutils git rsync pwgen -y && \
	sed -i "s/Subsystem.*/Subsystem sftp internal-sftp/g" /etc/ssh/sshd_config && \
	echo "Match user www-data" /etc/ssh/sshd_config && \
	echo "	ChrootDirectory /home" /etc/ssh/sshd_config && \
	echo "	AllowTCPForwarding no" /etc/ssh/sshd_config && \
	echo "	X11Forwarding no" /etc/ssh/sshd_config && \
	mkdir -p /home/www && \
	chmod 700 /home/www && \
	chown www-data:www-data /home/www && \
	chmod 700 /usr/local/sbin/make_chroot_jail.sh && \	
	make_chroot_jail.sh www-data /bin/bash /home && \
	rsync -av /dev/random /home/dev/random && \
	rsync -av /dev/urandom /home/dev/urandom && \
	rsync -av /etc/resolv.conf /home/etc/resolv.conf && \
	mkdir -p /home/usr/local/share/ca-certificates/ && \
	mkdir -p /home/usr/share/ca-certificates/ && \
	mkdir -p /home/etc/ssl/ && \
	rsync -av /usr/local/share/ca-certificates/ /home/usr/local/share/ca-certificates/ && \
	rsync -av /usr/sbin/update-ca-certificates /home/usr/sbin/ && \
	rsync -av /etc/ssl/ /home/etc/ssl/
	
ENV SFTP_PASS **None**

ENTRYPOINT ["/run.sh"]