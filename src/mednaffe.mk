# This file is part of MXE.
# See index.html for further information.

PKG             := mednaffe
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 0.8.8
$(PKG)_CHECKSUM := e73544806acd832de0d05729c48b333c700dfed6
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION)-src.zip
$(PKG)_URL      :=https://github.com/AmatCoder/mednaffe/archive/$($(PKG)_VERSION).zip
$(PKG)_DEPS     := gtk2 sdl2

define $(PKG)_UPDATE
    echo 'TODO: write update script for $(PKG).' >&2;
    echo $($(PKG)_VERSION)
endef

define $(PKG)_BUILD
    cd '$(1)'/share/win && $(TARGET)-windres mednaffe.rc -O coff -o mednaffe.res && mv -f *.txt -t ../../../../
    cd '$(1)'/src && $(TARGET)-gcc -Wl,--export-all-symbols -O2 -s -std=c99 -Wall -DGTK2_ENABLED -DSTATIC_ENABLED -mwindows -mms-bitfields -o mednaffe.exe mednaffe.c active.c command.c gui.c list.c toggles.c prefs.c about.c input.c log.c joystick_win.c resource.c ../share/win/mednaffe.res `i686-w64-mingw32.static-pkg-config --libs --cflags sdl2 gtk+-2.0 gmodule-export-2.0` && mv -f mednaffe.exe ../../../mednaffe.exe

    cd '$(1)'/../../  && $(TARGET)-strip -s mednaffe.exe
    # cd '$(1)'/../../  && upx --best --compress-icons=0 mednaffe.exe
    # cd '$(1)'/../../ && zip -r - *.txt mednaffe-licenses mednaffe.exe > mednaffe-$($(PKG)_VERSION)-win.zip
endef
