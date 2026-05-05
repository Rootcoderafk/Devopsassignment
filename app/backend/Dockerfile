# Stage 1: Build
FROM node:20-slim AS builder

WORKDIR /app

COPY package.json ./
RUN npm install --production

COPY . .

# Stage 2: Production
FROM node:20-slim

WORKDIR /app

# Add a non-root user
RUN groupadd -r nodejs && useradd -r -g nodejs nodejs

COPY --from=builder /app /app

# Set permissions
RUN chown -R nodejs:nodejs /app

USER nodejs

EXPOSE 3000

CMD ["node", "server.js"]
