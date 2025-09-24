#!/bin/bash

BASHRC="$HOME/.bashrc"

cat << 'EOF' >> "$BASHRC"

# >>> NetCDF & HDF5 paths (auto-generated) >>>
export NETCDF4_DIR=/mgpfs/home/$USER/library_intel/parallel/netcdf
export HDF5_DIR=/mgpfs/home/$USER/library_intel/parallel/hdf5

export PATH=$NETCDF4_DIR/bin:$HDF5_DIR/bin:$PATH
export CPATH=$NETCDF4_DIR/include:$HDF5_DIR/include:$CPATH
export LIBRARY_PATH=$NETCDF4_DIR/lib:$HDF5_DIR/lib:$LIBRARY_PATH
export LD_LIBRARY_PATH=$NETCDF4_DIR/lib:$HDF5_DIR/lib:$LD_LIBRARY_PATH
# <<< NetCDF & HDF5 paths <<<

EOF

echo "jalankan: source ~/.bashrc   untuk aktifase"

