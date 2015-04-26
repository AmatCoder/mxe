# This file is part of MXE.
# See index.html for further information.

PKG             := sdl2
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 2.0.3
$(PKG)_CHECKSUM := 21c45586a4e94d7622e371340edec5da40d06ecc
$(PKG)_SUBDIR   := SDL2-$($(PKG)_VERSION)
$(PKG)_FILE     := SDL2-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := http://www.libsdl.org/release/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc

define $(PKG)_UPDATE
    $(WGET) -q -O- 'http://hg.libsdl.org/SDL/tags' | \
    $(SED) -n 's,.*release-\([0-9][^<]*\).*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    cd '$(1)' && aclocal -I acinclude && autoconf && ./configure \
        $(MXE_CONFIGURE_OPTS) \
        --disable-threads \
        --enable-directx \
        --disable-audio \
        --enable-video \
        --disable-render \
        --enable-events \
        --enable-joystick \
        --enable-haptic \
        --disable-power \
        --enable-filesystem \
        --disable-timers \
        --disable-file \
        --disable-loadso \
        --disable-cpuinfo \
        --disable-oss \
        --disable-alsa \
        --disable-alsatest \
        --disable-alsa-shared \
        --disable-esd \
        --disable-esdtest \
        --disable-esd-shared \
        --disable-pulseaudio \
        --disable-pulseaudio-shared \
        --disable-arts \
        --disable-arts-shared \
        --disable-nas \
        --disable-nas-shared \
        --disable-sndio \
        --disable-sndio-shared \
        --disable-diskaudio \
        --disable-dummyaudio \
        --disable-video-wayland \
        --disable-video-wayland-qt-touch \
        --disable-wayland-shared \
        --disable-video-mir \
        --disable-mir-shared \
        --disable-video-x11 \
        --disable-x11-shared \
        --disable-video-x11-xcursor \
        --disable-video-x11-xinerama \
        --disable-video-x11-xinput \
        --disable-video-x11-xrandr \
        --disable-video-x11-scrnsaver \
        --disable-video-x11-xshape \
        --disable-video-x11-vm \
        --disable-video-cocoa \
        --disable-directfb-shared \
        --disable-fusionsound-shared \
        --disable-video-dummy \
        --disable-video-opengl \
        --disable-video-opengles \
        --disable-libudev \
        --disable-dbus \
        --disable-input-tslib \
        --disable-render-d3d
    $(SED) -i 's,defined(__MINGW64_VERSION_MAJOR),defined(__MINGW64_VERSION_MAJOR) \&\& defined(_WIN64),' '$(1)/include/SDL_cpuinfo.h'
    $(SED) -i 's,-XCClinker,,' '$(1)/sdl2.pc'
    $(SED) -i 's,-XCClinker,,' '$(1)/sdl2-config'
    $(MAKE) -C '$(1)' -j '$(JOBS)'
    $(MAKE) -C '$(1)' -j 1 install
    ln -sf '$(PREFIX)/$(TARGET)/bin/sdl2-config' '$(PREFIX)/bin/$(TARGET)-sdl2-config'
endef
