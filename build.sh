#!/bin/sh
set -xe

cd /tmp
apt-get update
apt-get install -y wget cmake swig mono-devel patch libstdc++-6-dev libpng-dev libjpeg-dev libfreetype6-dev libproj-dev libfribidi-dev libharfbuzz-dev libcairo2-dev libfcgi-dev libgeos-dev libpq-dev libxml2-dev libgif-dev default-libmysqlclient-dev librsvg2-dev libcurl4-gnutls-dev

wget http://releases.llvm.org/6.0.0/clang+llvm-6.0.0-x86_64-linux-gnu-debian8.tar.xz
tar xJf clang+llvm-6.0.0-x86_64-linux-gnu-debian8.tar.xz
mv clang+llvm-6.0.0-x86_64-linux-gnu-debian8 clang

wget http://download.osgeo.org/mapserver/mapserver-7.0.7.tar.gz
tar xzf mapserver-7.0.7.tar.gz
mv mapserver-7.0.7 mapserver

cd mapserver
patch -p1 < /tmp/ms.patch
mkdir build
cd build

CC=/tmp/clang/bin/clang CXX=/tmp/clang/bin/clang++ cmake \
    -DWITH_PROJ=ON \
    -DWITH_KML=ON \
    -DWITH_SOS=ON \
    -DWITH_RSVG=ON \
    -DWITH_MYSQL=ON \
    -DWITH_CLIENT_WMS=ON \
    -DWITH_CLIENT_WFS=ON \
    -DWITH_CURL=ON \
    -DWITH_THREAD_SAFETY=ON \
    -DWITH_PIXMAN=ON \
    -DWITH_CSHARP=ON \
    -DCSHARP_COMPILER=/usr/bin/mcs \
    ../
make -j3
make install
cp -r ./mapscript/csharp /opt

cd /tmp
apt-get install -y libstdc++6 libpng16-16 libjpeg62-turbo libfreetype6 libproj12 libfribidi0 libharfbuzz0b libcairo2 libfcgi0ldbl libgeos-c1v5 libpq5 libxml2 libgif7 librsvg2-2 libcurl3-gnutls
apt-get autoremove -y --purge wget cmake swig mono-devel patch libstdc++-6-dev libpng-dev libjpeg-dev libfreetype6-dev libproj-dev libfribidi-dev libharfbuzz-dev libcairo2-dev libfcgi-dev libgeos-dev libpq-dev libxml2-dev libgif-dev default-libmysqlclient-dev librsvg2-dev libcurl4-gnutls-dev
apt-get clean
rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
