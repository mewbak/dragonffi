#!/bin/bash
#

DIR=$(dirname $(realpath $0))
. "$DIR/common.sh"

configure_pip

LLVM_FILE=llvm.tar.xz
echo "b3ad93c3d69dfd528df9c5bb1a434367babb8f3baea47fbb99bf49f1b03c94ca  $LLVM_FILE" >$LLVM_FILE.sha256
wget http://releases.llvm.org/7.0.0/clang+llvm-7.0.0-x86_64-apple-darwin.tar.xz -O $LLVM_FILE && shasum -a256 -c $LLVM_FILE.sha256
mkdir llvm
tar xf $LLVM_FILE --strip-components 1 -C llvm

echo "b0886eafe77a8d58571c81cd03d988c30ad714f3a81732b8bc44e9ab461052a5  llvm/bin/FileCheck" >llvm/bin/FileCheck.sha256
echo "8830943258417cccd1732f201080910fd5b9f0dc2db2c35c20e8dc880c740630  llvm/bin/count" >llvm/bin/count.sha256

for TOOL in FileCheck count; do
  wget https://files.geekou.info/$TOOL.osx -O llvm/bin/$TOOL && shasum -a256 -c llvm/bin/$TOOL.sha256
  chmod +x llvm/bin/$TOOL
done


brew install ccache ninja
if [ "${PYTHON_VERSION:0:1}" == "3" ]; then
  $PYTHON_EXECUTABLE -m pip install lit
fi
