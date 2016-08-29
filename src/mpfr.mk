# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := mpfr
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 3.1.4
$(PKG)_CHECKSUM := 761413b16d749c53e2bfd2b1dfaa3b027b0e793e404b90b5fbaeef60af6517f5
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION).tar.xz
$(PKG)_URL      := ftp://ftp.gnu.org/pub/gnu/$(PKG)/$($(PKG)_FILE)
$(PKG)_URL_2    := http://www.mpfr.org/mpfr-$($(PKG)_VERSION)/$($(PKG)_FILE)
$(PKG)_TARGETS  := $(BUILD) $(MXE_TARGETS)
$(PKG)_DEPS     := gcc gmp

$(PKG)_DEPS_$(BUILD) := gmp

define $(PKG)_UPDATE
    $(WGET) -q -O- 'http://www.mpfr.org/mpfr-current/#download' | \
    grep 'mpfr-' | \
    $(SED) -n 's,.*mpfr-\([0-9][^>]*\)\.tar.*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    cd '$(1)' && ./configure \
        $(MXE_CONFIGURE_OPTS) \
        --enable-threads=win32 \
        --with-gmp-include='$(PREFIX)/$(TARGET)/include/'
        --with-gmp-lib='$(PREFIX)/$(TARGET)/lib/'
    $(MAKE) -C '$(1)' -j '$(JOBS)'
    $(MAKE) -C '$(1)' -j '$(JOBS)' install

    # build runtime tests to verify toolchain components
    -$(MAKE) -C '$(1)' -j '$(JOBS)' check -k
    rm -rf '$(PREFIX)/$(TARGET)/bin/$(PKG)-tests'
    cp -R '$(1)/tests' '$(PREFIX)/$(TARGET)/bin/$(PKG)-tests'
    (printf 'date /t >  all-tests-$(PKG)-$($(PKG)_VERSION).txt\r\n'; \
     printf 'time /t >> all-tests-$(PKG)-$($(PKG)_VERSION).txt\r\n'; \
     printf 'set PATH=..\\;%%PATH%%\r\n'; \
     printf 'for /R %%%%f in (*.exe) do %%%%f || echo %%%%f fail >> all-tests-$(PKG)-$($(PKG)_VERSION).txt\r\n';) \
     > '$(PREFIX)/$(TARGET)/bin/$(PKG)-tests/all-tests-$(PKG)-$($(PKG)_VERSION).bat'
endef

define $(PKG)_BUILD_$(BUILD)
    mkdir '$(1).build'
    cd    '$(1).build' && '$(1)/configure' \
        $(MXE_CONFIGURE_OPTS) \
        --with-gmp='$(PREFIX)/$(TARGET)'
    $(MAKE) -C '$(1).build' -j '$(JOBS)'
    $(MAKE) -C '$(1).build' -j 1 install
endef
