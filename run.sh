#!/bin/bash

sed -i "s/www-data.*/www-data:x:33:33:www-data:\/home\/www:\/bin\/bash/g" /etc/passwd
rsync -av /etc/resolv.conf /home/etc/resolv.conf

chown 33:33 /home/www
chmod 700 /home/www

if [ ! -f /.www-data_pw_set ]; then
	PASS=${SFTP_PASS:-$(pwgen -s 12 1)}
	_word=$( [ ${SFTP_PASS} ] && echo "preset" || echo "random" )
	echo "=> Setting a ${_word} password to the www-data user"
	echo "www-data:$PASS" | chpasswd

	echo "=> Done!"
	touch /.www-data_pw_set

	echo "========================================================================"
	echo "You can now connect to this Ubuntu container via FileZilla using:"
	echo ""
	echo "    sftp://www-data:$PASS@<host>:<port>"
	echo "and enter the www-data password '$PASS' when prompted"
	echo ""
	echo "Please remember to change the above password as soon as possible!"
	echo "========================================================================"
else
	echo "www-data password already set!"
fi

exec /usr/sbin/sshd -D
