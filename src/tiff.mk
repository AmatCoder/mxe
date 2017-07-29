# This file is part of MXE.
# See index.html for further information.

PKG             := tiff
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 4.0.3
$(PKG)_CHECKSUM := 652e97b78f1444237a82cbcfe014310e776eb6f0
$(PKG)_SUBDIR   := tiff-$($(PKG)_VERSION)
$(PKG)_FILE     := tiff-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := http://download.osgeo.org/libtiff/old/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc zlib

define $(PKG)_UPDATE
    $(WGET) -q -O- 'http://www.remotesensing.org/libtiff/' | \
    $(SED) -n 's,.*>v\([0-9][^<]*\)<.*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    cd '$(1)' && ./configure \
        $(MXE_CONFIGURE_OPTS) \
        --without-x \
        --disable-largefile \
        --disable-ccitt \
        --disable-packbits \
        --disable-lzw \
        --disable-thunder \
        --disable-next \
        --disable-logluv \
        --disable-mdi \
        --disable-pixarlog \
        --disable-jpeg \
        --disable-old-jpeg \
        --disable-jbig \
        --disable-lzma

    $(MAKE) -C '$(1)' -j '$(JOBS)' install $(MXE_DISABLE_CRUFT)
endef
