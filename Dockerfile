FROM node:alpine AS builder

# Set working directory
WORKDIR /app

# Copy package.json and package-lock.json
COPY package*.json ./

# Install dependencies
RUN npm install

# Copy the rest of the application files
COPY . .

# Build the Next.js application
RUN npm run build
RUN npm run export  # if you are using static export

# Stage 2: Serve with NGINX
FROM nginx:alpine

MAINTAINER mcc <chari.c.media@gmail.com>

# Copy the build output from the builder stage
COPY --from=builder /app/.next /birmingham-biz

# Copy the NGINX configuration file
COPY nginx.conf /etc/nginx/nginx.conf

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
