
# boost lib location
cd  /Users/tompyang/Documents/code/mysql/mysql-server
mkdir -p build/{data,build,etc}
# cd build 

# cmake .. -DWITH_BOOST=/Users/tompyang/Documents/code/mysql/boost_versions/boost_1_73_0 -DWITH_SSL=/opt/homebrew/opt/openssl@1.1



cmake . \
-B ./build \
-DWITH_DEBUG=1 \
-DCMAKE_INSTALL_PREFIX=./build/install \
-DMYSQL_DATADIR=./build/data \
-DSYSCONFDIR=./build/etc \
-DMYSQL_TCP_PORT=8024 \
-DWITH_BOOST=/Users/tompyang/Documents/code/mysql/boost_versions/boost_1_73_0 \
-DWITH_SSL=/opt/homebrew/opt/openssl@1.1 \
-DCMAKE_CXX_FLAGS="-Wdeprecated-declarations -Wbitwise-instead-of-logical -Wunqualified-std-cast-call" \
-DCMAKE_C_FLAGS="-Wdeprecated-declarations -Wbitwise-instead-of-logical -Wunqualified-std-cast-call"

# 编译 
cd build
make -j 8 > build.log 2>&1

# 配置文件
cat > etc/my.cnf <<EOF
[mysqld]
port=8024
bind-address = 127.0.0.1
socket=mysql.sock
innodb_file_per_table=1
log-error=mysqld.err
EOF

# 安装包
make install 

# 初始化系统库
install/bin/mysqld --defaults-file=etc/my.cnf --initialize-insecure
# 调试

set debug='d:t,2:o,/Users/tompyang/Documents/code/mysql/mysql-debug/mysqld.trace';


# 生成词法状态机
SOURCE_DIR=/Users/tompyang/Documents/code/mysql/mysql-server
cd ${SOURCE_DIR}/sql 
BUILD_DIR=/Users/tompyang/Documents/code/mysql/mysql-server/build
bison --name-prefix=MYSQL --yacc --warnings='all,no-yacc,no-empty-rule,no-precedence,no-deprecated' --defines=${BUILD_DIR}/sql/sql_yacc.h -v sql_yacc.yy

bison --name-prefix=MYSQL --yacc  --defines=${BUILD_DIR}/sql/sql_yacc.h -v sql_yacc.yy

# 重新编译
rm -rf build 