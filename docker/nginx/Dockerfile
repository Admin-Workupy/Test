FROM nginx:1.27.4-alpine

WORKDIR /etc/nginx

COPY ./inc/proxy_params .

COPY ./inc/default.conf.template templates/
