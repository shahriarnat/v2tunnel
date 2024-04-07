clear

echo -e "\e[35m------- PingTunnel-V2ray Server/Client Side Installation ------\r\n\e[0m"

GRN=$'\033[32m'
NTC=$'\033[0m'

echo -e "\e[32mSelect choose service side:\n\e[35m1.\e[0m Client\n\e[35m2.\e[0m Server\e[0m"
read -p "" side

if [ $side -eq 2 ] 
then 
	clear

	read -p "${GRN}Enter tunnel password:${NTC}" password

	XUI_CHK=$(docker ps -a --filter "name=xui" | cut -f1 -d" " | awk 'NR==2')
	if [ -z "$XUI_CHK" ]
	then
		docker pull alireza7/x-ui
	else
		echo -e "\e[32mxui already installed\e[0m"
	fi

	PTNL_CHK=$(docker ps -a --filter "name=pingtunnel-server" | cut -f1 -d" " | awk 'NR==2')
	if [ -z "$PTNL_CHK" ]
	then
		docker pull shnn786/pingtunnel
	else
		echo -e "\e[32mpingtunnel already installed\e[0m"
	fi

	XUI_CHK=$(docker ps --filter "name=xui" | cut -f1 -d" " | awk 'NR==2')
	if [ -z "$XUI_CHK" ]
	then
		docker run --name xui \
		-v $PWD/x-ui/db/:/etc/x-ui/ \
		-v $PWD/x-ui/cert/:/root/cert/ \
		--restart=unless-stopped \
		-d -p 127.0.0.1:19999:54321 -p 127.0.0.1:20000-20100:20000-20100 alireza7/x-ui
	else
		echo -e "\e[32mxui is running\e[0m"
	fi

	PTNL_CHK=$(docker ps --filter "name=pingtunnel-server" | cut -f1 -d" " | awk 'NR==2')
	if [ -z "$PTNL_CHK" ]
	then
		docker run --name pingtunnel-server -d \
		-v $PWD/pingtunnel/pingtunnel:/root/pingtunnel \
		--privileged \
		--network host \
		--restart=always \
		shnn786/pingtunnel ./pingtunnel -type server -key $password
	else
		echo -e "\e[32mpingtunnel is running\e[0m"
	fi

fi

if [ $side -eq 1 ]
then 
	clear

	apt update
 	yes | apt install iptables-persistent
  
	iptables -A POSTROUTING -s 172.17.0.0/16 ! -o docker0 -j MASQUERADE
  	
	iptables-save
 	
  curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash

  export NVM_DIR="$HOME/.nvm"
  [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
  [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

  apn install npm
  appt install nvm
  nvm install 20
  node -v
  npm -v

	read -p "${GRN}Enter tunnel password:${NTC}" password
	read -p "${GRN}Server IPv4 address:${NTC}" ipv4
	read -p "${GRN}Listener socks5 port:${NTC}" port
	

	PTNL_CHK=$(docker ps -a --filter "name=pingtunnel-client" | cut -f1 -d" " | awk 'NR==2')
	if [ -z "$PTNL_CHK" ]
	then
		docker pull shnn786/pingtunnel
	else
		echo -e "\e[32mpingtunnel already installed\e[0m"
	fi
	
	PTNL_CHK=$(docker ps --filter "name=pingtunnel-client" | cut -f1 -d" " | awk 'NR==2')
	if [ -z "$PTNL_CHK" ]
	then
		docker run --name pingtunnel-client -d \
		--restart=always \
		-p 127.0.0.1:$port:1080 \
		shnn786/pingtunnel ./pingtunnel -type client -l :1080 -s $ipv4 -sock5 1 -key $password
	else
		echo -e "\e[32mpingtunnel is running\e[0m"
	fi

	cd pf2sox
  npm i pm2 -g
  npm i
  chmod +x start.sh
  bash start.sh

fi 
