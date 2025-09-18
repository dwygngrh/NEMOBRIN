#!/bin/bash
# Program untuk instalasi library NEMO di HPC BRIN
# buat executable: chmod +x install_nemo_library.sh
# run program : ./install_nemo_library.sh
##############################################
FC=ifort
PFC=mpiifort
CC=icc
PCC=mpiicc
CXX=icx
#
### src dir
mkdir library_intel
src=${HOME}/library_intel/src
mkdir ${src}
#
## install dir
INSDIR=${HOME}/library_intel/parallel

###############################################
# install curl
wget https://curl.se/download/curl-8.11.0.tar.gz
curl=curl-8.11.0
tar -xvf ${curl}.tar.gz
cd ${curl}
####./configure --prefix=${INSDIR}/curl 
./configure --prefix=${INSDIR}/curl --without-ssl --without-libpsl
make clean
make && make install
##############################################
# install zlib
cd ${src} 
zlib=zlib-1.3.1
wget --no-check-certificate https://zlib.net/zlib-1.3.1.tar.gz 
tar -xvf ${zlib}.tar.gz
cd ${zlib}
CC=${CC} ./configure --prefix=${INSDIR}/zlib
./configure --prefix=${INSDIR}/zlib
make clean
make && make install
##############################################
# install hdf5
cd ${src}
hdf5=hdf5-1.14.3
wget --no-check-certificate https://support.hdfgroup.org/ftp/HDF5/releases/hdf5-1.14/hdf5-1.14.3/src/hdf5-1.14.3.tar.gz 
tar -xvf ${hdf5}.tar.gz
cd ${hdf5}
CC=${PCC} FC=${PFC} CFLAGS=-fPIC ./configure --enable-shared --enable-parallel --enable-fortran --enable-fortran2003 --with-zlib=${INSDIR}/zlib --with-curl=${INSDIR}/curl --prefix=${INSDIR}/hdf5
make clean
make
make install
##############################################
# install libxml2
cd ${src}
git clone https://github.com/GNOME/libxml2.git
cd libxml2
./configure --with-zlib=${INSDIR}/zlib --prefix=${INSDIR}/libxml2
make clean
make 
make install
##############################################
# install netcdf-c
cd ${src}
wget --no-check-certificate https://downloads.unidata.ucar.edu/netcdf-c/4.9.1/netcdf-c-4.9.1.tar.gz
netcdfc=netcdf-c-4.9.1
tar -xvf ${netcdfc}.tar.gz
cd ${netcdfc}
CC=${PCC} LDFLAGS=-L${INSDIR}/hdf5/lib LIBS=-lhdf5 CPPFLAGS=-I${INSDIR}/hdf5/include ./configure --prefix=${INSDIR}/netcdf --disable-libxml2 --with-curl=${INSDIR} --disable-byterange
make clean
make 
make install
##############################################
# install netcdf-f
cd ${src}
wget --no-check-certificate https://downloads.unidata.ucar.edu/netcdf-fortran/4.6.1/netcdf-fortran-4.6.1.tar.gz
netcdff=netcdf-fortran-4.6.1
tar -xvf ${netcdff}.tar.gz
cd ${netcdff}
FC=mpiifort LDFLAGS=-L$INSDIR/netcdf/lib CPPFLAGS=-I$INSDIR/netcdf/include LIBS=-lnetcdf ./configure --prefix=$INSDIR/netcdf --enable-parallel-tests
make clean
make 
make install
