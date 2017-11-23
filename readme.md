# Docker简介

## 一、运行 tomcat 8.5

### 1. 部署 tomcat 8.5
- 1.下载并运行，*docker run -dit --name tomcat -p 8080:8080 tomcat:8.5*
- 2.查看镜像，*docker images*
- 3.查看容器，*docker ps -a*

### 2. 添加管理员
- 1.使用浏览器打开 http://127.0.0.1:8080/, 可以看见首页，但是无法进入管理界面。
- 2.进入容器内查看文件，*docker exec -it tomcat bash* 
- 3.复制 tomcat-users.xml，*docker cp [tomcat-users.xml](https://github.com/xray2100/docker-brief/blob/master/tomcat-users.xml) tomcat:/usr/local/tomcat/conf/*
- 4.复制 manager.xml，*docker cp [manager.xml](https://github.com/xray2100/docker-brief/blob/master/manager.xml) tomcat:/usr/local/tomcat/conf/Catalina/localhost/*

### 3. 重新运行容器
- 1.停止容器，*docker stop tomcat*
- 2.启动容器，*docker start tomcat*
- 3.使用浏览器打开 http://127.0.0.1:8080/, 部署WebApp。

### 4. 移除
- 1.删除容器，*docker rm tomcat*
- 2.获取镜像标识符，*docker images* 获取 ImageID
- 3.删除镜像，*docker rmi &lt;ImageID>*

## 二、运行 Spring Boot 应用

### 1. 部署 MySQL 数据库
- 1.下载并运行，*docker run --name mysql -e MYSQL_ROOT_PASSWORD=Techown1 -d mysql:5.5*
- 2.进入容器，*docker exec -it mysql bash* 
- 3.创建 auth 数据库

### 2. 部署 Spring Boot 应用
- 1.下载 [auth.jar](https://github.com/xray2100/docker-brief/blob/master/auth.jar) 和 [auth.dockerfile](https://github.com/xray2100/docker-brief/blob/master/auth.dockerfile)
- 2.生成镜像，*docker build -t auth:0.1 -f auth.dockerfile .* 
- 3.查看镜像，*docker images*
- 4.启动应用，*docker run --name auth -p 8080:8088 --link mysql:localhost -d auth:0.1* 
- 5.查看日志，*docker logs -f auth* 
- 6.调用应用 http://localhost:8080/authr/sleep
- 7.查看监控 http://localhost:8080/jolokia/read/java.lang:type=Memory

### 3. 其他命令
- 1.查看容器运行状态，*docker stats auth*
- 2.查看镜像细节，*docker image inspect auth:0.1*
- 3.查看容器细节，*docker container inspect auth*

### 4. 其他容器运行参数
- 1.限制容器的CPU和内存
  - a.运行命令，*docker run **-m 1024m --cpus=0.5** --name auth -p 8080:8088 --link mysql:localhost -d auth:0.1*
  - b.查看运行状态，*docker container stats auth*

- 2.设置应用的最大内存和线程数
  - a.运行命令，*docker run -m 512m --cpus=0.5 **-e server.tomcat.max-threads='60'** --name auth -p 8080:8088 --link mysql:localhost -d auth:0.1*
  - b.在浏览器里查看内存，http://localhost:8080/jolokia/read/java.lang:type=Memory
  - c.在浏览器里查看线程，http://localhost:8080/jolokia/read/Tomcat:type=ThreadPool,name=%22http-nio-8088%22/maxThreads
  
### 5. 容器的导出和导入
- 1.将容器转为一个镜像，命令中第一个auth是容器名字，第二个auth:0.2是镜像名字和标签
  - *docker commit auth auth:0.2*
- 2.将镜像导出为一个文件
  - *docker save auth:0.2 > auth.0.2.di.tar*
- 3.删除镜像和容器
  - *docker rm auth*
  - *docker rmi auth:0.2*
- 4.从一个文件导入镜像
  - *docker load < auth.0.2.di.tar*
- 5.运行这个镜像
  - *docker run -m 1024m --cpus=0.5 --name auth -p 8080:8088 --link mysql:localhost -d auth:0.2*
- 6.原先设置的环境变量都已经被写入镜像，所以运行是不用设置了




