# Use Node image to build Angular app
FROM node:18-alpine as build

WORKDIR /app
COPY . .
RUN npm install && npm run build

# Use Nginx to serve the app
FROM nginx:alpine
COPY --from=build /app/dist/contact /usr/share/nginx/html
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
