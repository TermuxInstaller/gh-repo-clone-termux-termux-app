TERMUX_PKG_HOMEPAGE=https://godotengine.org
TERMUX_PKG_DESCRIPTION="Advanced cross-platform 2D and 3D game engine"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=4.0
TERMUX_PKG_SRCURL=https://github.com/godotengine/godot/archive/$TERMUX_PKG_VERSION-stable.tar.gz
TERMUX_PKG_SHA256=e6cf28411ae4196db0bcd608f77bcafc0c019ea6dd6cc8c750ca3cc3755df547
TERMUX_PKG_DEPENDS="freetype, libglvnd, libtheora, libvorbis, libvpx, libwebp, libwslay, libxcursor, libxi, libxinerama, libxrandr, mbedtls, miniupnpc, opusfile, ca-certificates"
TERMUX_PKG_BUILD_DEPENDS="yasm, pulseaudio"
TERMUX_PKG_PYTHON_COMMON_DEPS="scons"
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_make() {
	local to_unbundle="libogg libpng libtheora libvorbis libvpx libwebp mbedtls miniupnpc opus pcre2 wslay zlib zstd"
	local system_libs=""
	for _lib in $to_unbundle; do
		system_libs+="builtin_"$_lib"=no "
	done

	export BUILD_NAME=termux
	scons -j16 \
		use_static_cpp=no \
		colored=yes \
		platform=x11 \
		pulseaudio=yes \
		udev=no \
		freetype=no \
		system_certs_path=$TERMUX_PREFIX/etc/tls/cert.pem \
		target=release_debug \
		tools=yes \
		use_llvm=yes \
		CFLAGS="$CFLAGS -fPIC -Wl,-z,relro,-z,now -w" \
		CXXFLAGS="$CXXFLAGS -fPIC -Wl,-z,relro,-z,now -w" \
		LINKFLAGS="$LDFLAGS -lexecinfo" \
		$system_libs
}

termux_step_make_install() {
	ls # TEST
	install -Dm644 misc/dist/linux/org.godotengine.Godot.desktop "$TERMUX_PREFIX/usr/share/applications/godot.desktop"
	install -Dm644 icon.svg "$TERMUX_PREFIX/usr/share/pixmaps/godot.svg"
	install -Dm755 bin/godot.x11.opt.tools.64 "$TERMUX_PREFIX/usr/bin/$pkgname"
	install -Dm644 LICENSE.txt "$TERMUX_PREFIX/usr/share/licenses/godot/LICENSE"
	install -Dm644 misc/dist/linux/godot.6 "$TERMUX_PREFIX/usr/share/man/man6/godot.6"
	install -Dm644 misc/dist/linux/org.godotengine.Godot.xml "$TERMUX_PREFIX/usr/share/mime/packages/org.godotengine.Godot.xml"
}
