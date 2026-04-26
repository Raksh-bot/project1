# ---------- Stage 1: Build ----------
FROM node:20-alpine AS builder

WORKDIR /app
 
# Copy dependency files first (for better caching)
COPY package*.json ./

# Install dependencies
RUN npm ci

# Copy rest of the code
COPY . .

# Build application
RUN npm run build


# ---------- Stage 2: Production ----------
# ---------- Stage 2: Production ----------
FROM nginx:alpine

# Copy built files
COPY --from=builder /app/dist /usr/share/nginx/html

# Expose default nginx port
EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
#r
