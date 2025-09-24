# NEMOBRIN
Selamat datang!  
Pembuatan konfigurasi model Regional NEMO di HPC BRIN  
NEMO yang akan diinstall ialah NEMO versi 4.0 dengan konfigurasi grid 1/48 wilayah timur indonesia  
Download file di github ini dan copy ke direktory $HOME di akun HPC. 
Direktory home biasanya /HOME/userid/. sebagai contoh user id dwiy008 maka direktory HOME ialah /home/dwiy008  
gunakan perintah ini scp -p 4022 "nama file" dwiy008@login2.hpc.brin.go.id:/home/dwiy008/  

## 1. Persiapan Library Untuk pertama kali masuk akun BRIN HPC
Saat pertama login anda akan berada di direktory $HOME.  
### Jalankan perintah ini di direktory home    
echo module purge >> .bashrc  
echo module load intel/2023.2.0 >> .bashrc  
echo module load mpi/2021.10.0 >> .bashrc  
echo module load cmake/3.24.2 >> .bashrc  
source .bashrc
### running script library  
chmod +x install_nemo_library_intel.sh  
./install_nemo_library_intel.sh  
jalankan sampai selesai  
masukkan perintah ini setelah selesai  
nf-config 
jika ada menu konfigurasi netcdf dan tidak ada error maka instalasi berhasil  
### buat link ke library yang di buat
chmod +x echo_library.sh  
./echo_library.sh
source .bashrc
### install miniconda
wget https://repo.anaconda.com/miniconda/Miniconda3-py310_24.9.2-0-Linux-x86_64.sh  
chmod +x Miniconda3-py310_24.9.2-0-Linux-x86_64.sh  
./Miniconda3-py310_24.9.2-0-Linux-x86_64.sh  
echo source ${HOME}/miniconda3/etc/profile.d/conda.sh   
conda activate  
conda config --add channels conda-forge  
conda config --set channel_priority strict  
conda install anaconda::pip
pip install svn

## Step 1 HANYA DIJALANKAN SEKALI SAJA!!  
## 2. Persiapan source code
Untuk menginstall NEMO OCEAN saja dibutuhkan dua source code yaitu NEMO dan XIOS.  
Jika akan melakukan kopel atmosfir dibutuhkan source code OASIS-MCT3  
Model atmosfir yang digunakan ialah WRF.  
Catatan :  
- Jangan install OASIS dan WRF jika tidak melakukan kopel dengan atmosfir  
- NEMO melakukan komputasi paralel MPI.
- Perhitungan akan di bagi ke tiap prossesor sehingga tiap prossesor akan memberikan satu output file per perhitungan.    
- Untuk menggabungkan file dari tiap prosessor dibutuhkan software XIOS. 
- Untuk NEMO versi 4.2 dibutuhkan XIOS versi 3.0.
- Seluruh compiler menggunakan INTEL compiler.
## 3. Download Software  
### buat direktory   
mkdir NEMO  
mkdir source    
cd source  
### download XIOS  
download manual dari sini : https://drive.google.com/drive/folders/1OrfhpvsE-bXowlZ4KAD3FBMtO4XkPuJa?usp=drive_link  
nanti file di upload ke hpc direktory $HOME/NEMO/source/  
### download NEMO (masih di direktori $HOME/NEMO/source)  
wget https://forge.nemo-ocean.eu/nemo/nemo/-/archive/4.2.3/nemo-4.2.3.tar.gz 
### download OASISMCT Untuk kopel dengan atmosfir (advanced user only)    
git clone https://gitlab.com/cerfacs/oasis3-mct.git oasis3  
### download WRF dan WPS Untuk model atmosfir  (advanced user only)   
git clone https://github.com/wrf-model/WRF.git  
git clone https://github.com/wrf-model/WPS.git
tar -xvzf nemo-4.2.3.tar.gz -C ../
## 4. Install Software
### INSTALL XIOS (masih di direktori $HOME/NEMO/source)
Jika ingin running kopel atmosfir, XIOS di instal dengan KEY OASIS. 
Jika hanya running laut saja jangan ditambahkan KEY OASIS  
XIOS dapat di install dengan KEY oasis "-DUSE_OMCT" atau tidak  
tar -xvzf xios2.tar.gz -C ../  
cd ../xios2   
Install XIOS tanpa KEY OASIS :  
./make_xios --full --prod --arch ifort_BRIN_2025 -j4 |& tee compile_log.txt  
Install XIOS dengan KEY OASIS (advanced user only):  
./make_xios --full --use_oasis oasis3_mct --prod --arch ifort_BRIN_2025 -j4 |& tee compile_log.txt  
############################################################
### Install NEMO
 cd NEMO
  arch-linux_local.fcm

## ############### Instalasi NEMO selesai #####################
### Install OASIS-MCT3 (jika ingin running model kopel laut-atm) SKIP jika hanya ingin running model ocean
cd /home/yoga/NEMO42/source/oasis3-mct/util/make_dir  
ubah di make.inc 
include  /home/yoga/NEMO42/source/oasis3-mct/util/make_dir/make.intel-RCO-brin  
#### buat architecture  
cp make.intel18.0.1.163_intelmpi2018.1.163-ddt_nemo make.intel-RCO-brin
ubah di make.intel-RCO-brin
COUPLE          = /home/yoga/NEMO42/source/oasis3-mct
NETCDF_INC_DIR= ${NETCDF_INC} 
NETCDF_INCLUDE  = ${NETCDF_INC}
