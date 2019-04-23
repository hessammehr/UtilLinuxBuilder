# Note that this script can accept some limited command-line arguments, run
# `julia build_tarballs.jl --help` to see a usage message.
using BinaryBuilder

name = "UtilLinuxBuilder"
version = v"2.33.0"

# Collection of sources required to build UtilLinuxBuilder
sources = [
    "https://mirrors.edge.kernel.org/pub/linux/utils/util-linux/v2.33/util-linux-2.33.tar.xz" =>
    "f261b9d73c35bfeeea04d26941ac47ee1df937bd3b0583e748217c1ea423658a",

]

# Bash recipe for building across all platforms
script = raw"""
cd $WORKSPACE/srcdir
cd util-linux-2.33/
./configure --prefix=$prefix --host=$target
make
make install

"""

# These are the platforms we will build for by default, unless further
# platforms are passed in on the command line
platforms = [
    Linux(:i686, libc=:glibc),
    Linux(:x86_64, libc=:glibc),
    Linux(:aarch64, libc=:glibc),
    Linux(:armv7l, libc=:glibc, call_abi=:eabihf),
    Linux(:powerpc64le, libc=:glibc),
    Linux(:i686, libc=:musl),
    Linux(:x86_64, libc=:musl),
    Linux(:aarch64, libc=:musl),
    Linux(:armv7l, libc=:musl, call_abi=:eabihf)
]

# The products that we will ensure are always built
products(prefix) = [
    LibraryProduct(prefix, "libuuid", :libuuid),
    LibraryProduct(prefix, "libmount", :libmount),
    LibraryProduct(prefix, "libblkid", :libblkid),
    LibraryProduct(prefix, "libsmartcols", :libsmartcols),
    LibraryProduct(prefix, "libfdisk", Symbol("lobfdisk\e[D\e[D\e[D\e[D\e[D\e[i\e[4~\e[C\e[C\e[C\e[C\e[C\e[C\e[C\e[C\e[D\e[D"))
]

# Dependencies that must be installed before this package can be built
dependencies = [
    
]

# Build the tarballs, and possibly a `build.jl` as well.
build_tarballs(ARGS, name, version, sources, script, platforms, products, dependencies)

