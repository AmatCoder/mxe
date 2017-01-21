# This file is part of MXE.
# See index.html for further information.

PKG             := mednaffe
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 0.8.4
$(PKG)_CHECKSUM := bce530c56e2347f459afedab861c53170e9ced91
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION)-src.zip
$(PKG)_URL      :=https://sites.google.com/site/amatcoder/mednaffe/downloads/$($(PKG)_FILE)?attredirects=0&d=1
$(PKG)_DEPS     := gtk2 sdl2

define $(PKG)_UPDATE
    echo 'TODO: write update script for $(PKG).' >&2;
    echo $($(PKG)_VERSION)
endef

define $(PKG)_BUILD
    cd '$(1)'/share/win && $(TARGET)-windres mednaffe.rc -O coff -o mednaffe.res && mv -f *.txt -t ../../../../
    cd '$(1)'/src && $(TARGET)-gcc -Wl,--export-all-symbols -s -O2 -std=c99 -Wall -DGTK2_ENABLED -DSTATIC_ENABLED -mwindows -mms-bitfields -o mednaffe.exe mednaffe.c active.c command.c gui.c list.c toggles.c prefs.c about.c input.c log.c  joystick_win.c md5.c `i686-w64-mingw32.static-pkg-config --libs --cflags sdl2 gtk+-2.0 gmodule-export-2.0` && mv -f mednaffe.exe ../../../mednaffe.exe
endef
