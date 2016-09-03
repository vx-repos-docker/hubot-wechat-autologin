#!/usr/bin/env bash
wget http://downloads.sourceforge.net/project/zbar/zbar/0.10/zbar-0.10.tar.gz
tar -zvxf zbar-0.10.tar.gz
cd zbar-0.10
./configure --without-imagemagick --disable-video --without-qt --without-gtk --without-x && \
make && make install
cd ..
rm -rf zbar-0.10 zbar-0.10.tar.gz
ldconfig


wget https://pypi.python.org/packages/source/z/zbar/zbar-0.10.tar.bz2
wget https://github.com/npinchot/zbar/commit/d3c1611ad2411fbdc3e79eb96ca704a63d30ae69.diff
tar jxvf zbar-0.10.tar.bz2
cd zbar-0.10
patch -p1 < ../d3c1611ad2411fbdc3e79eb96ca704a63d30ae69.diff
python setup.py install
cd ..
rm -rf zbar-0.10 zbar-0.10.tar.bz2 d3c1611ad2411fbdc3e79eb96ca704a63d30ae69.diff