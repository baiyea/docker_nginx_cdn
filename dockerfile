# 基础包
FROM centos

# DockerFile维护信息
MAINTAINER 2018-08-09 degao g_2007@qq.com

# 安装基础支持，解压啥的。
RUN yum -y install gcc*  make pcre-devel zlib-devel

# 把安装包、扩展增加到容器，注意，只有tar支持自动解压
ADD install/nginx-1.8.1.tar.gz  /usr/src/
ADD install/ngx_cache_purge-master.tar.gz  /usr/src/nginx-1.8.1/plugin/

# 定义后面的执行命令到工作路径
WORKDIR /usr/src/nginx-1.8.1/

# 创建Nginx执行用户
RUN useradd -s /sbin/nologin -M nginx

# 安装Nginx
RUN ./configure \
	--prefix=/usr/local/nginx \
	--user=nginx \
	--group=nginx \
	--with-http_stub_status_module \
	--add-module=/usr/src/nginx-1.8.1/plugin/ngx_cache_purge-master/ \
    && make \
    && make install

# 关联
RUN ln -s /usr/local/nginx/sbin/* /usr/local/sbin/

# 容器监听的端口
EXPOSE 80

# 执行
WORKDIR /
RUN nginx
CMD ["nginx", "-g", "daemon off;"]