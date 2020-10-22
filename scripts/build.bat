@echo off

rem apollo config db info
rem 因为我的mysql是5.7，apollo使用的驱动是8+,这里需要指定时区
set apollo_config_db_url="jdbc:mysql://localhost:3306/ApolloConfigDB?serverTimezone=UTC&useUnicode=true&characterEncoding=utf-8&useSSL=false"
set apollo_config_db_username="root"
rem 改为自己的mysql密码
set apollo_config_db_password="root"

rem apollo portal db info
set apollo_portal_db_url="jdbc:mysql://localhost:3306/ApolloPortalDB?serverTimezone=UTC&useUnicode=true&characterEncoding=utf-8&useSSL=false"
set apollo_portal_db_username="root"
rem 改为自己的mysql密码
set apollo_portal_db_password="root"

rem meta server url, different environments should have different meta server addresses
rem 因为只有本地一个环境，故这里只需留一个
set dev_meta="http://localhost:8080"
rem set fat_meta="http://someIp:8080"
rem set uat_meta="http://anotherIp:8080"
rem set pro_meta="http://yetAnotherIp:8080"

set META_SERVERS_OPTS=-Ddev_meta=%dev_meta% -Dfat_meta=%fat_meta% -Duat_meta=%uat_meta% -Dpro_meta=%pro_meta%

rem =============== Please do not modify the following content =============== 
rem go to script directory
cd "%~dp0"

cd ..

rem package config-service and admin-service
echo "==== starting to build config-service and admin-service ===="

call mvn clean package -DskipTests -pl apollo-configservice,apollo-adminservice -am -Dapollo_profile=github -Dspring_datasource_url=%apollo_config_db_url% -Dspring_datasource_username=%apollo_config_db_username% -Dspring_datasource_password=%apollo_config_db_password%

echo "==== building config-service and admin-service finished ===="

echo "==== starting to build portal ===="

call mvn clean package -DskipTests -pl apollo-portal -am -Dapollo_profile=github,auth -Dspring_datasource_url=%apollo_portal_db_url% -Dspring_datasource_username=%apollo_portal_db_username% -Dspring_datasource_password=%apollo_portal_db_password% %META_SERVERS_OPTS%

echo "==== building portal finished ===="

pause
