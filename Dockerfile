# Multi-stage Dockerfile for Vue.js development
FROM node:22-alpine as base

# Set working directory
WORKDIR /app

# Install git (needed for some npm packages)
RUN apk add --no-cache git

# Copy package files first for better caching
COPY package*.json ./

# Install base dependencies
RUN npm ci --only=production && npm cache clean --force

# Development stage
FROM base as development

# Install all dependencies (including dev dependencies)
RUN npm ci

# Copy source code
COPY . .

# Create non-root user for security
RUN addgroup -g 1001 -S nodejs && \
    adduser -S vuejs -u 1001 -G nodejs

# Change ownership of the app directory
RUN chown -R vuejs:nodejs /app

# Switch to non-root user
USER vuejs

# Expose the port
EXPOSE 5200

# Start the development server
CMD ["npm", "run", "dev", "--", "--host", "0.0.0.0", "--port", "5200"]

# Production build stage
FROM base as build

# Install all dependencies for building
RUN npm ci

# Copy source code
COPY . .

# Build the application
RUN npm run build

# Production stage
FROM nginx:alpine as production

# Copy built assets to nginx html directory
COPY --from=build /app/dist /usr/share/nginx/html

# Replace default nginx server config with ours
COPY default.conf /etc/nginx/conf.d/default.conf

# Set proper permissions
RUN chown -R nginx:nginx /usr/share/nginx/html

# Expose port 80
EXPOSE 80

# Start nginx
CMD ["nginx", "-g", "daemon off;"]
