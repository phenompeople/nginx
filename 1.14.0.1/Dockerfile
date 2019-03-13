FROM amazonlinux:2
LABEL maintainer="rajesh.jonnalagadda@phenompeople.com" \
      version="1.14.0"
RUN yum install -q -e 0 -y wget make perl gcc-c++ pcre-devel zlib-devel file shadow-utils tar gzip&& \
    useradd -d  /opt/phenom phenom -u 1004 && \
    mkdir -p /opt/phenom/scripts

ENV LANG en_US.UTF-8

ARG NGINX_VERSION=1.14.0
ARG OPENSSL_VERSION=1.1.1
ARG PCRE_VERSION=8.42
ARG ZLIB_VERSION=1.2.11
ARG LUAJIT_VERSION=2.0.5
ARG NGINX_DEV_KIT_VERSION=v0.3.0
ARG NGINX_LUA_MOD_VERSION=v0.10.13
ARG NGINX_MORE_HEADERS=0.33
ARG NGINX_AJP_VERSION=master
EXPOSE 80 443

ENV PCRE_VERSION=${PCRE_VERSION} \
    ZLIB_VERSION=${ZLIB_VERSION} \
    OPENSSL_VERSION=${OPENSSL_VERSION} \
    NGINX_VERSION=${NGINX_VERSION} \
    LUAJIT_VERSION=${LUAJIT_VERSION} \
    NGINX_DEV_KIT_VERSION=${NGINX_DEV_KIT_VERSION} \
    NGINX_LUA_MOD_VERSION=${NGINX_LUA_MOD_VERSION} \
    NGINX_AJP_VERSION=${NGINX_AJP_VERSION} \
    NGINX_SETUP_DIR='/opt/cache/nginx'

ADD setup /opt/phenom/scripts
RUN /opt/phenom/scripts/install.sh
COPY config/nginx.conf /etc/nginx/nginx.conf
ADD index.html /usr/local/nginx/html/index.html
VOLUME  /etc/nginx/conf.d
RUN yum remove -q -e 0 -y wget make perl gcc-c++ pcre-devel zlib-devel file && \
    yum clean all && \
    rm -rf /opt/phenom/scripts
ENTRYPOINT ["nginx", "-g", "daemon off;"]
