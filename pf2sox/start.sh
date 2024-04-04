pm2 start main.js --name "port-19999" -- 19999
pm2 start main.js --name "port-20001" -- 20001
pm2 start main.js --name "port-20002" -- 20002
pm2 start main.js --name "port-20003" -- 20003
pm2 start main.js --name "port-20004" -- 20004
pm2 start main.js --name "port-20005" -- 20005

pm2 startup
pm2 save