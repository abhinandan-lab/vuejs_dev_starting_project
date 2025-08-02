import { createServer } from 'vite';

const PORT = process.env.PORT || 5200;

console.log('🎯 Starting Vite development server...');
console.log(`🌐 Target port: ${PORT}`);

createServer({
  server: {
    port: PORT,
    host: true,
    strictPort: false,  // Allow port switching if occupied
    open: false
  }
}).then(server => {
  server.listen();
  console.log(`✅ Vite dev server started on http://localhost:${PORT}`);
  
  // Handle graceful shutdown
  process.on('SIGTERM', async () => {
    console.log('🛑 Shutting down server...');
    await server.close();
    process.exit(0);
  });
}).catch(err => {
  console.error('❌ Failed to start server:', err);
  process.exit(1);
});
