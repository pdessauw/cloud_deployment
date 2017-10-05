FROM nginx:1.12
LABEL maintainer "National Institute of Standards and Technology"

# Debug tools
RUN apt-get update && apt-get install -y vim wget dnsutils

# Copy the configuration file
COPY ./nginx.conf /etc/nginx/nginx.conf
COPY ./default.conf /etc/nginx/conf.d/default.conf
