# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := gtk3
$(PKG)_WEBSITE  := https://gtk.org/
$(PKG)_DESCR    := GTK+
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 3.22.30
$(PKG)_CHECKSUM := a1a4a5c12703d4e1ccda28333b87ff462741dc365131fbc94c218ae81d9a6567
$(PKG)_SUBDIR   := gtk+-$($(PKG)_VERSION)
$(PKG)_FILE     := gtk+-$($(PKG)_VERSION).tar.xz
$(PKG)_URL      := https://download.gnome.org/sources/gtk+/$(call SHORT_PKG_VERSION,$(PKG))/$($(PKG)_FILE)
$(PKG)_DEPS     := cc atk cairo gdk-pixbuf glib jasper jpeg libepoxy libpng pango tiff

define $(PKG)_UPDATE
    $(WGET) -q -O- 'https://git.gnome.org/browse/gtk+/refs/tags' | \
    grep '<a href=' | \
    $(SED) -n 's,.*<a[^>]*>\([0-9]*\.[0-9]*[02468]\.[^<]*\)<.*,\1,p' | \
    grep '^3\.' | \
    head -1
endef

define $(PKG)_BUILD
    cp ./src/gtk3/*.png '$(SOURCE_DIR)'/gtk/icons/16x16/actions/
    cp ./src/gtk3/*.png '$(SOURCE_DIR)'/gtk/icons/16x16/status/
    mkdir -p '$(SOURCE_DIR)'/gtk/theme/Windows10/assets/
    cp ./src/gtk3/Windows10/*.* '$(SOURCE_DIR)'/gtk/theme/Windows10/
    cp ./src/gtk3/Windows10/assets/*.* '$(SOURCE_DIR)'/gtk/theme/Windows10/assets/
    cd '$(BUILD_DIR)' && '$(SOURCE_DIR)/configure' \
        $(MXE_CONFIGURE_OPTS) \
        --enable-explicit-deps \
        --disable-glibtest \
        --disable-modules \
        --disable-xinput \
        --disable-packagekit \
        --disable-cups \
        --disable-papi \
        --disable-cloudprint \
        --disable-test-print-backend \
        --disable-gtk-doc \
        --disable-man \
        --disable-nls \
        --enable-debug=yes \
        --enable-introspection=no \
        --enable-colord=no \
        --with-included-immodules \
        --enable-win32-backend \
        --without-x
    $(MAKE) -C '$(BUILD_DIR)' -j '$(JOBS)' $(MXE_DISABLE_CRUFT) EXTRA_DIST=
    $(MAKE) -C '$(BUILD_DIR)' -j 1 install $(MXE_DISABLE_CRUFT) EXTRA_DIST=

    # cleanup to avoid gtk2/3 conflicts (EXTRA_DIST doesn't exclude it)
    # and *.def files aren't really relevant for MXE
    rm -f '$(PREFIX)/$(TARGET)/lib/gailutil.def'

    '$(TARGET)-gcc' \
        -W -Wall -Werror -ansi \
        '$(TEST_FILE)' -o '$(PREFIX)/$(TARGET)/bin/test-gtk3.exe' \
        `'$(TARGET)-pkg-config' gtk+-3.0 --cflags --libs`
endef
