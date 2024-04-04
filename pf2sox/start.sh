pm2 start main.js -- 19999 --name "port-19999"
pm2 start main.js -- 20002 --name "port-20002"
pm2 start main.js -- 20001 --name "port-20001"
pm2 start main.js -- 20003 --name "port-20003"
pm2 start main.js -- 20004 --name "port-20004"
pm2 start main.js -- 20005 --name "port-20005"

pm2 startup
pm2 save