#!/usr/bin/env bash
set -e
PCRE_SRC_URI="ftp://ftp.csx.cam.ac.uk/pub/software/programming/pcre/pcre-$PCRE_VERSION.tar.gz"
ZLIB_SRC_URI="http://zlib.net/zlib-$ZLIB_VERSION.tar.gz"
OPENSSL_SRC_URI="http://www.openssl.org/source/openssl-$OPENSSL_VERSION.tar.gz"
NGINX_SRC_URI="http://nginx.org/download/nginx-$NGINX_VERSION.tar.gz"
LUAJIT_SRC_URI="http://luajit.org/download/LuaJIT-$LUAJIT_VERSION.tar.gz"
NGINX_DEV_KIT_SRC_URI="https://github.com/simpl/ngx_devel_kit/archive/$NGINX_DEV_KIT_VERSION.tar.gz"
NGINX_LUA_MOD_SRC_URI="https://github.com/openresty/lua-nginx-module/archive/$NGINX_LUA_MOD_VERSION.tar.gz"
NGINX_AJP_MOD_SRC_URI="https://github.com/yaoweibin/nginx_ajp_module/archive/$NGINX_AJP_VERSION.tar.gz"
SOURCE_DIR="$NGINX_SETUP_DIR/sources"

func_create_directory() {
  if [ ! -e $1 ]; then
    echo "Creating Directory : $1"
    mkdir -p $1
  fi
}

download_and_extract(){
  SRC_LOCATION=$1
  func_create_directory $SOURCE_DIR
  SOURCE_BINARY=$(basename $SRC_LOCATION)
  echo "Downloading $SRC_LOCATION"
  wget -q -O $SOURCE_DIR/$SOURCE_BINARY $SRC_LOCATION
  echo "Extracting $SOURCE_DIR/$SOURCE_BINARY"
  tar -xzf $SOURCE_DIR/$SOURCE_BINARY -C $NGINX_SETUP_DIR
}

compile_from_source(){
    echo "Compiling $1 from $NGINX_SETUP_DIR/$1"
    cd $NGINX_SETUP_DIR/$1
    ./configure > /tmp/log_file 2>&1
    make > /tmp/log_file 2>&1
    make install > /tmp/log_file 2>&1
    cd $NGINX_SETUP_DIR
}
download_and_extract $PCRE_SRC_URI
compile_from_source pcre-$PCRE_VERSION
download_and_extract $ZLIB_SRC_URI
compile_from_source zlib-$ZLIB_VERSION
download_and_extract $OPENSSL_SRC_URI
download_and_extract $NGINX_DEV_KIT_SRC_URI
download_and_extract $NGINX_LUA_MOD_SRC_URI
download_and_extract $NGINX_AJP_MOD_SRC_URI

cd $NGINX_SETUP_DIR/openssl-$OPENSSL_VERSION
./Configure darwin64-x86_64-cc --prefix=/usr > /tmp/log_file 2>&1
make > /tmp/log_file 2>&1 && make install > /tmp/log_file 2>&1

download_and_extract $LUAJIT_SRC_URI
cd $NGINX_SETUP_DIR/LuaJIT-$LUAJIT_VERSION
make > /tmp/log_file 2>&1 && make install > /tmp/log_file 2>&1

cd $NGINX_SETUP_DIR
download_and_extract $NGINX_SRC_URI
sed -i 's/Server: nginx/Server: Phenompeople/' $NGINX_SETUP_DIR/nginx-$NGINX_VERSION/src/http/ngx_http_header_filter_module.c

export LUAJIT_LIB=/usr/local/lib
export LUAJIT_INC=/usr/local/include/luajit-2.0
echo "Compiling nginx-$NGINX_VERSION"
cd $NGINX_SETUP_DIR/nginx-$NGINX_VERSION
./configure \
  --prefix=/usr/local/nginx \
  --conf-path=/etc/nginx/nginx.conf \
  --sbin-path=/usr/sbin \
  --http-log-path=/var/log/nginx/access.log \
  --error-log-path=/var/log/nginx/error.log \
  --lock-path=/var/lock/nginx.lock \
  --pid-path=/run/nginx.pid \
  --http-client-body-temp-path=${NGINX_TEMP_DIR}/body \
  --http-fastcgi-temp-path=${NGINX_TEMP_DIR}/fastcgi \
  --http-proxy-temp-path=${NGINX_TEMP_DIR}/proxy \
  --http-scgi-temp-path=${NGINX_TEMP_DIR}/scgi \
  --http-uwsgi-temp-path=${NGINX_TEMP_DIR}/uwsgi \
  --with-pcre-jit \
  --with-http_ssl_module \
  --with-ipv6 \
  --with-http_ssl_module \
  --with-http_stub_status_module \
  --with-http_realip_module \
  --with-http_auth_request_module \
  --with-http_addition_module \
  --with-http_dav_module \
  --with-http_gunzip_module \
  --with-http_gzip_static_module \
  --with-http_v2_module \
  --with-http_sub_module \
  --with-stream \
  --with-stream_ssl_module \
  --with-mail \
  --with-mail_ssl_module \
  --with-threads \
  --with-ld-opt="-Wl,-rpath,/usr/local/lib" \
  --add-dynamic-module=$NGINX_SETUP_DIR/ngx_devel_kit-${NGINX_DEV_KIT_VERSION#v} \
  --add-dynamic-module=$NGINX_SETUP_DIR/lua-nginx-module-${NGINX_LUA_MOD_VERSION#v} \
  --add-module=$NGINX_SETUP_DIR/nginx_ajp_module-${NGINX_AJP_VERSION} \
  --with-pcre=../pcre-$PCRE_VERSION \
  --with-zlib=../zlib-$ZLIB_VERSION \
  --with-openssl=../openssl-$OPENSSL_VERSION

make  && make install
chown -R root:root $NGINX_SETUP_DIR
rm -rf $NGINX_SETUP_DIR/sources /tmp/log_file