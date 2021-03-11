## build stage
FROM node:alpine as build-step
RUN mkdir -p /app
WORKDIR /app
COPY package.json /app
RUN npm install
COPY . /app
RUN npm run build

# server stage
FROM nginx:alpine
RUN rm -rf /usr/share/nginx/html/*
COPY nginx.conf /etc/nginx/conf.d/default.conf
COPY --from=build-step /app/dist/* /usr/share/nginx/html/
CMD ["nginx", "-g", "daemon off;"]
