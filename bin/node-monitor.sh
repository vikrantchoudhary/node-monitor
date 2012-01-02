#!/bin/bash

GIT_PROJECT=git://github.com/franklovecchio/node-monitor.git

case "$1" in
     'start')
		echo "Starting node-monitor"

		cd ~/node-monitor/run
		
		export AWS_ACCESS_KEY_ID=ID;
		export AWS_SECRET_ACCESS_KEY=KEY;
	
		#node client.js > /dev/null 2>&1 &
		node client.js ec2=true debug=false console=false cloudwatch=true
		
		;;
	'stop')
		echo "Stopping node-monitor"
		
		NODE_MONITOR=`ps -ef | grep -v grep | grep client.js | awk '{print $2'}`
		kill -9 $NODE_MONITOR
		for PID in `ps -ef | grep -v grep | grep "tail -F" | awk '{print $2}'`; do
        	echo "Killing: " + $PID
        	kill -9	$PID
		done
		
		;;
	'update')
		echo "Updating node-monitor"
		cd ~/
		rm ~/.node-monitor/*
		cp ~/node-monitor/plugins/*_config ~/.node-monitor/
		rm -r ~/node-monitor
		git clone $GIT_PROJECT
		cp ~/.node-monitor/* ~/node-monitor/plugins/
		cd ~/node-monitor/bin
		wget http://s3.amazonaws.com/ec2metadata/ec2-metadata
		chmod a+x ~/node-monitor/ec2-metadata
		
		;;
	'install-debian-with-deps')
	    yes | apt-get update 
	    apt-get -y install libssl-dev git-core scons pkg-config build-essential curl gcc g++ python3.2
		cd ~/
		wget https://github.com/joyent/node/zipball/v0.6.6 && tar -xzf v0.6.6
		cd ~/joyent-node-19a9663
		./configure
		make
		make install
		export PATH=$PATH:/opt/node/bin
		curl http://npmjs.org/install.sh | sudo sh
		mkdir ~/.node-monitor
		cd ~/node-monitor
		npm link

		;;
	'install-debian')
		yes | apt-get install git-core scons curl build-essential openssl libssl-dev
		cd ~/node-monitor
		npm link
		
		;;
	'install-centos')
		yes | yum install gcc gcc-c++ autoconf automake openssl-devel nginx unzip gcc-c++ screen git-core monit
		cd /monitoring
		git clone https://github.com/joyent/node.git && cd /monitoring/node
		git checkout v0.4.8
		./configure
		make
		make install
		cd /monitoring
		sed -i "s/Defaults    secure_path = \/sbin:\/bin:\/usr\/sbin:\/usr\/bin/Defaults    secure_path = \/sbin:\/bin:\/usr\/sbin:\/usr\/bin:\/usr\/local\/bin/g" /etc/sudoers
		curl http://npmjs.org/install.sh | sudo sh
		npm install iconv forever ec2 knox
		
		;;
	'')
		echo "Usage: $0 [start|stop|update|install-debian|install-debian-with-deps|install-centos]"
		;;
	'?')
		echo "Usage: $0 [start|stop|update|install-debian|install-debian-with-deps|install-centos]"
		;;
esac
