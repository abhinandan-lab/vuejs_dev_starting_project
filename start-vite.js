import { createServer } from 'vite';

createServer({
  server: {
    port: 5200,
    host: true
  }
}).then(server => server.listen());
console.log('Vite server is running on port 5200');