set -ex

# https://docs.aws.amazon.com/freertos/latest/userguide/getting_started_cypress_psoc64.html

SOURCE_REPO=amazon-freertos
REPO_DIR=amazon-freertos-CI

#git clone $SOURCE_REPO $REPO_DIR

#cd $REPO_DIR

git submodule update --init \
    freertos_kernel \
    libraries/coreJSON \
    libraries/coreMQTT \
    libraries/device_shadow_for_aws_iot_embedded_sdk \
    libraries/3rdparty/http_parser \
    libraries/3rdparty/lwip \
    libraries/3rdparty/mbedtls \
    libraries/3rdparty/pkcs11 \
    libraries/abstractions/pkcs11/corePKCS11 \
    libraries/abstractions/pkcs11/psa \

# Revert doesn't go thru completely due to some submodule foo, but the
# needed files are put into the working tree, so we just ignore error.
git revert 287ed79eb6137443133d2a7200bc5591c02a8973 || true

if [ -d .venv ]; then
    . .venv/bin/activate
else
    python3 -m venv .venv
    . .venv/bin/activate
    python3 -m pip install cysecuretools
fi

which cysecuretools
#cysecuretools version


cd projects/cypress/CY8CKIT_064S0S2_4343W/mtb/aws_demos
rm -rf build
#mkdir -p build
#cd build

cmake -DVENDOR=cypress -DBOARD=CY8CKIT_064S0S2_4343W -DCOMPILER=arm-gcc -DBUILD_CLONE_SUBMODULES=OFF \
    -S ../../../../.. -B build

cmake --build build
