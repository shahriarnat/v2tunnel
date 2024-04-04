const net = require('net');
const {SocksClient} = require('socks');

var in_port = parseInt(process.argv.slice(2)[0]);

if (typeof in_port === 'undefined') {
    console.error("\n\n\033[31mlistening port not defined\033[0m -> \033[32mnode main.js port\033[0m\n\n")
    process.abort();
}

// Configuration for your SOCKS5 proxy
const proxyOptions = {
    proxy: {
        host: '127.0.0.1', // Proxy server hostname
        port: 1080,        // Proxy server port
        type: 5            // SOCKS version (5 for SOCKS5)
    },
    command: 'connect',
    destination: {
        host: '127.0.0.1', // Target server hostname
        port: in_port                    // Target server port
    }
};

// Create a server that listens for incoming connections
const server = net.createServer((clientSocket) => {
    //console.log('Client connected');

    // Handle errors on the client socket
    clientSocket.on('error', (err) => {
        console.error('Client socket error:', err.message);
        clientSocket.end();
    });

    let clientProxyConnection = null;
    if (!clientProxyConnection) {

        clientProxyConnection = SocksClient.createConnection(proxyOptions, (err, info) => {
            if (err) {
                console.error('Failed to connect to proxy:', err);
                clientSocket.end();
                return;
            }

            //console.log('Connected to proxy, forwarding data...');
            const proxySocket = info.socket;

            // Handle errors on the proxy socket
            proxySocket.on('error', (err) => {
                console.error('Proxy socket error:', err.message);
                proxySocket.end();
                clientSocket.end();
            });

            // Forward data between the client and the proxy
            clientSocket.pipe(proxySocket);
            proxySocket.pipe(clientSocket);

            // Handle client disconnect
            clientSocket.on('end', () => {
                //console.log('Client disconnected');
                proxySocket.end();
            });

            // Handle proxy disconnect
            proxySocket.on('end', () => {
                //console.log('Proxy connection ended');
                clientSocket.end();
            });
        });
    } else {
        clientSocket.pipe(proxySocket);
        proxySocket.pipe(clientSocket);
    }
});

// Listen on a specific port for incoming connections
const PORT = in_port;
server.listen(PORT, '0.0.0.0', () => {
    console.log(`Server listening on port ${PORT}`);
});
