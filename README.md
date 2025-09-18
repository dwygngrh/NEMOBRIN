# NEMOBRIN
Instalasi NEMO di HPC BRIN
Selamat datang!  
setting model NEMO di cluster  
indomodel versi NEMO akan memberikan informasi bagaimana install nemo di cluster.  
NEMO yang akan diinstall ialah NEMO versi 4.0 dengan konfigurasi grid 1/48 wilayah timur indonesia  
## 1. Persiapan Library  
Saat pertama login anda akan berada di direktory HOME.  
### 2. Jalankan perintah ini  
echo module purge >> .bashrc  
echo module load intel/2023.2.0 >> .bashrc  
echo module load mpi/2021.10.0 >> .bashrc  
### 3. running script library  
chmod +x install_nemo_library_intel.sh  
./install_nemo_library_.sh  

Step 1-3 HANYA DIJALANKAN SEKALI SAJA!!  

## Persiapan source code
Untuk menginstall NEMO dibutuhkan dua source code 
1. NEMO   
2. XIOS.
 
NEMO melakukan komputasi paralel MPI.
Perhitungan akan di bagi ke tiap prossesor sehingga tiap prossesor akan memberikan satu output file per perhitungan.    
Untuk menggabungkan file dari tiap prosessor dibutuhkan software XIOS. 
Untuk NEMO versi 4.2 dibutuhkan XIOS versi 3.0. Selain itu tersedia XIOS versi 2.0. 
download source code NEMO dan XIOS melalui link berikut:  
### buat direktory   
mkdir NEMO  
mkdir SOURCE  
cd SOURCE  
### 4. Download XIOS  
svn co http://forge.ipsl.jussieu.fr/ioserver/svn/XIOS3/trunk/ xios3    
### 5. Download NEMO  
git clone https://forge.nemo-ocean.eu/nemo/nemo.git nemo42  
### 6. Download OASISMCT Untuk kopel dengan atmosfir  
git clone https://gitlab.com/cerfacs/oasis3-mct.git oasis3  
### 7. Download WRF dan WPS Untuk model atmosfir  
git clone https://github.com/wrf-model/WRF.git  
git clone https://github.com/wrf-model/WPS.git  
## Proses Instalasi Software
### 8. INSTALL OASIS-MCT3 (jika ingin running model kopel laut-atm) SKIP jika hanya ingin running model ocean
cd /home/yoga/NEMO42/source/oasis3-mct/util/make_dir  
ubah di make.inc 
include  /home/yoga/NEMO42/source/oasis3-mct/util/make_dir/make.intel-RCO-brin  
#### buat architecture  
cp make.intel18.0.1.163_intelmpi2018.1.163-ddt_nemo make.intel-RCO-brin
ubah di make.intel-RCO-brin
COUPLE          = /home/yoga/NEMO42/source/oasis3-mct
NETCDF_INC_DIR= ${NETCDF_INC} 
NETCDF_INCLUDE  = ${NETCDF_INC}
### 9. INSTALL XIOS  
Jika ingin running kopel atmosfir, XIOS di instal dengan KEY OASIS. 
Jika hanya running laut saja jangan ditambahkan KEY OASIS
XIOS dapat di install dengan KEY oasis "-DUSE_OMCT" atau tidak
cd xios2 atau cd xios3
Install XIOS tanpa KEY OASIS : ./make_xios --full --prod --arch Intel_BRIN -j4 |& tee compile_log.txt
Install XIOS dengan KEY OASIS : ./make_xios --full --use_oasis oasis3_mct --prod --arch Intel_BRIN -j4 |& tee compile_log.txt
############################################################
# Install NEMO
 cd NEMO
  arch-linux_local.fcm
