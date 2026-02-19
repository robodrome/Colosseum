#! /bin/bash

RPC_VERSION_FOLDER="rpclib-2.3.0"
folder_name="Release"
build_dir=build


mkdir -p build
cd build

CC=/usr/bin/clang-18 CXX=/usr/bin/clang++-18 cmake ../cmake -DCMAKE_CXX_FLAGS='-stdlib=libc++ -I/usr/lib/llvm-17/include/c++/v1~'

make -j$(nproc)

cd ..

mkdir -p AirLib/lib/x64/$folder_name
mkdir -p AirLib/deps/rpclib/lib
mkdir -p AirLib/deps/MavLinkCom/lib
cp $build_dir/output/lib/libAirLib.a AirLib/lib
cp $build_dir/output/lib/libMavLinkCom.a AirLib/deps/MavLinkCom/lib
cp $build_dir/output/lib/librpc.a AirLib/deps/rpclib/lib/librpc.a

# Update AirLib/lib, AirLib/deps, Plugins folders with new binaries
rsync -a --delete build/output/lib/ AirLib/lib/x64/$folder_name
rsync -a --delete external/rpclib/$RPC_VERSION_FOLDER/include AirLib/deps/rpclib
rsync -a --delete MavLinkCom/include AirLib/deps/MavLinkCom
rsync -a --delete AirLib Unreal/Plugins/AirSim/Source
rm -rf Unreal/Plugins/AirSim/Source/AirLib/src

# DO NOT auto-install into all Unreal projects anymore

echo ""
echo ""
echo "=================================================================="
echo " Colosseum plugin built successfully."
echo "=================================================================="
echo ""
echo "The AirSim plugin is located at:"
echo ""
echo "  $(pwd)/Unreal/Plugins/AirSim"
echo ""
echo "To use it in a specific Unreal project:"
echo ""
echo "Option 1: Copy plugin into your project:"
echo ""
echo "  cp -r Unreal/Plugins/AirSim \\"
echo "    ~/Documents/Unreal\\ Projects/<YourProject>/Plugins/"
echo ""
echo "Option 2 (Recommended): Create symbolic link:"
echo ""
echo "  ln -s $(pwd)/Unreal/Plugins/AirSim \\"
echo "    ~/Documents/Unreal\\ Projects/<YourProject>/Plugins/AirSim"
echo ""
echo "Then rebuild your Unreal project."
echo "=================================================================="
