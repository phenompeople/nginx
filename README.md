[![License](https://img.shields.io/badge/License-Apache%202.0-blue.svg)](https://opensource.org/licenses/Apache-2.0)

## Nginx 

Dockerfiles for building Centos based Nginx LuaJIT image.

## Supported tags and respective Dockerfile links

### phenompeople/nginx

[![Docker Automated build](https://img.shields.io/docker/automated/phenompeople/nginx.svg?style=plastic)](https://hub.docker.com/r/phenompeople/nginx/)
[![Docker Build Status](https://img.shields.io/docker/build/phenompeople/nginx.svg?style=plastic)](https://hub.docker.com/r/phenompeople/nginx/)
[![Docker Pulls](https://img.shields.io/docker/pulls/phenompeople/nginx.svg?style=plastic)](https://hub.docker.com/r/phenompeople/nginx/)

* **`1.13.4` 	([1.13.4/Dockerfile](https://bitbucket.org/phenompeople/nginx/src/master/1.13.4/Dockerfile))**
* **`latest`		([1.13.4/Dockerfile](https://bitbucket.org/phenompeople/nginx/src/master/1.13.4/Dockerfile))**
* **`1.12.1`		([1.12.1/Dockerfile](https://bitbucket.org/phenompeople/nginx/src/master/1.12.1/Dockerfile))**
* **`stable` 	([1.12.1/Dockerfile](https://bitbucket.org/phenompeople/nginx/src/master/1.12.1/Dockerfile))**
* **`1.11.10`	([1.11.10/Dockerfile](https://bitbucket.org/phenompeople/nginx/src/master/1.11.10/Dockerfile))**
* **`angular` 	([1.11.10/Dockerfile](https://bitbucket.org/phenompeople/nginx/src/master/1.11.10/Dockerfile))**

### phenompeople/nginx-lua (Deprecated)

This image has been deprecated in favor of the automated nginx image provided. The upstream images are available to pull via docker.elastic.co/phenompeople/nginx:[version] like 1.13.4. The images found here will receive no further updates. Please adjust your usage accordingly.

[![Docker Automated build](https://img.shields.io/docker/automated/phenompeople/nginx-lua.svg?style=plastic)](https://hub.docker.com/r/phenompeople/nginx-lua/)
[![Docker Pulls](https://img.shields.io/docker/pulls/phenompeople/nginx-lua.svg?style=plastic)](https://hub.docker.com/r/phenompeople/nginx-lua/)

* **`1.11.10`**
* **`latest`**
* **`pod`**
* **`angular`**
* **`microsoft`**

### Nginx components

1. **PCRE** 			- Perl Compatible Regular Expressions library is a set of functions that implement regular expression pattern matching using the same syntax and semantics as Perl 5. PCRE has its own native API, as well as a set of wrapper functions that correspond to the POSIX regular expression API.
1. **ZLIB** 			- zlib is designed to be a free, general-purpose, legally unencumbered -- that is, not covered by any patents -- lossless data-compression library for use on virtually any computer hardware and operating system
1. **OPENSSL**		- OpenSSL is a robust, commercial-grade, and full-featured toolkit for the Transport Layer Security (TLS) and Secure Sockets Layer (SSL) protocols. It is also a general-purpose cryptography library.
1. **DEV KIT**		- Nginx Development Kit - an Nginx module that adds additional generic tools that module developers can use in their own modules
1. **AJP**				- Nginx can connect to AJP port directly. The motivation of including these modules is Nginx's high performance and robustness. 	 
1. **LUA**				- Embed the Power of Lua into NGINX HTTP servers

### Component and its version included

```
|---------------------------------|------------|-------------|--------------|-------------|--------------|-------------|
| Component Name                  |  1.13.4    |    latest   |   1.12.1     |   stable    |   1.11.10    |  angular    | 
|---------------------------------|------------|-------------|--------------|-------------|--------------|-------------|
| Nginx - Core                    |  1.13.4    |   1.13.4    |   1.12.1     |  1.12.1     |    1.11.10   |  1.11.10    |    
|---------------------------------|------------|-------------|--------------|-------------|--------------|------------ |
| Open SSL                        |  1.0.2l    |   1.0.2l    |    1.0.2l    |  1.0.2l     |    1.0.2k    |  1.0.2k     |    
|---------------------------------|------------|-------------|--------------|-------------|--------------|-------------|
| PCRE                            |   8.40     |    8.40     |    8.40      |   8.40      |    8.40      |   8.40      |    
|---------------------------------|------------|-------------|--------------|-------------|--------------|-------------|
| ZLIB                            |  1.2.11    |   1.2.11    |    1.2.11    |  1.2.11     |    1.2.11    |  1.2.11     |    
|---------------------------------|------------|-------------|--------------|-------------|--------------|-------------|
| LUAJIT                          |  2.0.5     |   2.0.5     |    2.0.5     |  2.0.5      |   2.0.4      |  2.0.4      |    
|---------------------------------|------------|-------------|--------------|-------------|--------------|-------------|
| Nginx Dev Kit                   |  v0.3.0    |   v0.3.0    |   v0.3.0     | v0.3.0      |   v0.3.0     | v0.3.0      |    
|---------------------------------|------------|-------------|--------------|-------------|--------------|-------------|
| Nginx Lua Mod Version           |  v0.10.10  |   v0.10.10  |   v0.10.10   | v0.10.10    |   v0.10.7    | v0.10.7     |    
|---------------------------------|------------|-------------|--------------|-------------|--------------|-------------|
| Nginx AJP Module                |  master    |  master     |    master    | master      |    master    | master      |    
|---------------------------------|------------|-------------|--------------|-------------|--------------|-------------|
```

#### Pre-Requisites

- install docker-engine [https://docs.docker.com/engine/installation/](https://docs.docker.com/engine/installation/)

### How to use this image 

1.  This image can be used by simply running 

```$ docker run --name=nginx -v /etc/nginx/conf.d:/etc/nginx/conf.d -v /usr/share/nginx/html-p 80:80 -td phenompeople/nginx:latest```

Above command runs nginx container with port 80 mapped to host and connecting to static site and its respective configuration mapped 

1. To make nginx as a reverse proxy and use persistent and updated configuration file(s) map only /etc/nginx/conf.d directory 

```$ docker run --name=nginx -v /etc/nginx/conf.d:/etc/nginx/conf.d -p 80:80 -td phenompeople/nginx:latest```

1. To make nginx as a reverse proxy and use persistent and updated configuration file(s) and TSL/SSL enabled map only /etc/nginx/conf.d directory. Please note that your configuration files should point to the said directory

```$ docker run --name=nginx -v /etc/nginx/conf.d:/etc/nginx/conf.d -v /etc/nginx/ssl:/etc/nginx/ssl -p 80:80 -p 443:443 -td phenompeople/nginx:latest```

Above command runs nginx container with port 80 mapped to host and connecting to static site and its respective configuration mapped 

1. To make image run even after reboot use extra option --restart=always

```$ docker run --restart=always  --name=nginx -v /etc/nginx/conf.d:/etc/nginx/conf.d -v /usr/share/nginx/html-p 80:80 -td phenompeople/nginx:latest```

1. Please define below variables during run time to replace default values, angular JS based container will require DIRECTORY_ROOT to map application 


## Maintainers

* Rajesh Jonnalagadda (<rajesh.jonnalagadda@phenompeople.com>)

## License and Authors

**License:**	Apache License

**Author :** Phenompeople Pvt Ltd (<admin.squad@phenompeople.com>)