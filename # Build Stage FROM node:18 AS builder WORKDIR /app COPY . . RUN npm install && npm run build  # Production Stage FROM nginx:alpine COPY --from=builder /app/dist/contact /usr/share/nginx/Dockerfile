# Build Stage
FROM node:18 AS builder
WORKDIR /app
COPY . .
RUN npm install && npm run build

# Production Stage
FROM nginx:alpine
COPY --from=builder /app/dist/contact /usr/share/nginx/html
EXPOSE 80
