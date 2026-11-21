# Stage 1: Build
FROM node:22-alpine AS build
WORKDIR /app

COPY package.json package-lock.json ./
RUN npm ci

COPY js/ js/
RUN npm run build

# Stage 2: Serve
FROM nginx:alpine

# Copy static assets
COPY assets/ /usr/share/nginx/html/assets/
COPY css/ /usr/share/nginx/html/css/
COPY index.html /usr/share/nginx/html/

# Copy bundled JS from build stage
COPY --from=build /app/dist/ /usr/share/nginx/html/dist/

# Nginx config for SPA
COPY nginx.conf /etc/nginx/conf.d/default.conf

EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
