Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:62911 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965106Ab1JFRct (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 6 Oct 2011 13:32:49 -0400
Message-ID: <4E8DE450.7030302@redhat.com>
Date: Thu, 06 Oct 2011 14:24:32 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: linux-media <linux-media@vger.kernel.org>
Subject: Re: [RFC] Merge v4l-utils. dvb-apps and mediactl to media-utils.git
References: <201110061423.22064.hverkuil@xs4all.nl> <4E8DACAF.5070207@redhat.com>
In-Reply-To: <4E8DACAF.5070207@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em 06-10-2011 10:27, Mauro Carvalho Chehab escreveu:
> Em 06-10-2011 09:23, Hans Verkuil escreveu:
>> Currently we have three repositories containing libraries and utilities that
>> are relevant to the media drivers:
>>
>> dvb-apps (http://linuxtv.org/hg/dvb-apps/)
>> v4l-utils (http://git.linuxtv.org/v4l-utils.git)
>> media-ctl (git://git.ideasonboard.org/media-ctl.git)
>>
>> It makes no sense to me to have three separate repositories, one still using
>> mercurial and one that isn't even on linuxtv.org.
>>
>> I propose to combine them all to one media-utils.git repository. I think it
>> makes a lot of sense to do this.
>>
>> After the switch the other repositories are frozen (with perhaps a README
>> pointing to the new media-utils.git).
>>
>> I'm not sure if there are plans to make new stable releases of either of these
>> repositories any time soon. If there are, then it might make sense to wait
>> until that new stable release before merging.
>>
>> Comments?
>
> I like that idea. It helps to have the basic tools into one single repository,
> and to properly distribute it.
>
> I think through, that we should work to have an smart configure script that
> would allow enabling/disabling the several components of the utils, like the
> --enable/--disable approach used by autoconf scripts:
> --enable-libv4l
> --enable-dvb
> --enable-ir
> --enable-v4l
> --enable-mc
> ...
>
> Of course, using "--disable-libv4l" would mean that libv4l-aware utils would
> be statically linked with the current libv4l libraries.
>
> This would help distributions to migrate to it, as they can keep having separate
> packages for each component for the existing stable distros, while merging
> into a single source package for future distros.

A patch for the above ended by being simple to add. For now, I've just
added two options, to allow disabling dynamic libv4l compilation/install
and to allow disabling v4l-utils. It is not hard to add more flags there
to allow selecting other things.

-

Add support to disable libv4l and/or v4l-utils

Add some autogen magic to allow disabling the compilation of
v4l-utils or libv4l.

If libv4l is disabled but v4l-utils is enabled, it will still
build libv4l statically, and will linkedit the v4l-utils against
the static libraries.

This way distributions can ship v4l-utils on a separate package
from libv4l, and even having things like providing a v4l-utils
based on a different version of libv4l.

This changeset also opens space to add more libraries and other
packages, as the first step to turn it into a media-utils tree.

While here, adds a v4l-utils.spec rpm file, as found on Fedora.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

diff --git a/.gitignore b/.gitignore
index 1f62182..2b7d617 100644
--- a/.gitignore
+++ b/.gitignore
@@ -4,3 +4,7 @@
  *.so.0
  *.pc
  *.a
+config.log
+config.status
+Makefile
+configure
diff --git a/Make.rules b/Make.rules
index 13d8464..759c75b 100644
--- a/Make.rules
+++ b/Make.rules
@@ -1,5 +1,3 @@
-V4L_UTILS_VERSION=0.9.0-test
-
  # These ones can be overriden from the cmdline
  
  CFLAGS := -g -O1
@@ -17,7 +15,7 @@ MANDIR = $(PREFIX)/share/man
  
  # Note the -I../.. this assumes all sources live in a 2 level dir hierarchy!
  override CPPFLAGS += -I../../include -I../../lib/include -D_GNU_SOURCE -DV4L_UTILS_VERSION='"$(V4L_UTILS_VERSION)"'
-override LDFLAGS += -L../../lib/libv4l1 -L../../lib/libv4l2 -L../../lib/libv4lconvert
+override LDFLAGS += -L../../lib/libv4l1 -L../../lib/libv4l2 -L../../lib/libv4lconvert -ldl -ljpeg
  
  # And last various rules
  
diff --git a/Makefile b/Makefile
deleted file mode 100644
index fa0cb05..0000000
--- a/Makefile
+++ /dev/null
@@ -1,37 +0,0 @@
-all install:
-	$(MAKE) -C lib $@
-	$(MAKE) -C utils $@
-
-sync-with-kernel:
-	@if [ ! -f $(KERNEL_DIR)/include/linux/videodev2.h -o \
-	      ! -f $(KERNEL_DIR)/include/linux/ivtv.h -o \
-	      ! -f $(KERNEL_DIR)/include/media/v4l2-chip-ident.h ]; then \
-	  echo "Error you must set KERNEL_DIR to point to an extracted kernel source dir"; \
-	  exit 1; \
-	fi
-	cp -a $(KERNEL_DIR)/include/linux/videodev2.h include/linux
-	cp -a $(KERNEL_DIR)/include/linux/ivtv.h include/linux
-	cp -a $(KERNEL_DIR)/include/media/v4l2-chip-ident.h include/media
-	$(MAKE) -C utils $@
-
-clean::
-	rm -f include/*/*~
-	$(MAKE) -C lib $@
-	$(MAKE) -C utils $@
-
-tag:
-	@git tag -a -m "Tag as v4l-utils-$(V4L_UTILS_VERSION)" v4l-utils-$(V4L_UTILS_VERSION)
-	@echo "Tagged as v4l-utils-$(V4L_UTILS_VERSION)"
-
-archive-no-tag:
-	@git archive --format=tar --prefix=v4l-utils-$(V4L_UTILS_VERSION)/ v4l-utils-$(V4L_UTILS_VERSION) > v4l-utils-$(V4L_UTILS_VERSION).tar
-	@bzip2 -f v4l-utils-$(V4L_UTILS_VERSION).tar
-
-archive: clean tag archive-no-tag
-
-export: clean
-	tar --transform s/^\./v4l-utils-$(V4L_UTILS_VERSION)/g \
-		--exclude=.git -jcvf \
-		/tmp/v4l-utils-$(V4L_UTILS_VERSION).tar.bz2 .
-
-include Make.rules
diff --git a/Makefile.in b/Makefile.in
new file mode 100644
index 0000000..d38f9e7
--- /dev/null
+++ b/Makefile.in
@@ -0,0 +1,67 @@
+CC			= @CC@
+CXX			= @CXX@
+V4L_UTILS_VERSION	= @V4L_UTILS_VERSION@
+CFLAGS			= @CFLAGS@
+WITH_LIBV4		= @WITH_LIBV4L@
+WITH_V4LUTILS		= @WITH_V4LUTILS@
+
+LIBV4L_ARGS=
+ifeq ($(WITH_LIBV4L),no)
+ifeq ($(WITH_V4LUTILS),yes)
+	LIBV4L_ARGS="LINKTYPE=static"
+endif
+endif
+
+all:
+  ifeq ($(WITH_LIBV4L),yes)
+	echo with Libv4l $(LIBV4L_ARGS)
+	$(MAKE) -C lib $(LIBV4L_ARGS) $@
+  else ifeq ($(WITH_V4LUTILS),yes)
+	echo with Libv4l static
+	$(MAKE) -C lib $(LIBV4L_ARGS) $@
+  endif
+  ifeq ($(WITH_V4LUTILS),yes)
+	$(MAKE) -C utils $(LIBV4L_ARGS) $@
+  endif
+
+install:
+  ifeq ($(WITH_LIBV4L),yes)
+	$(MAKE) -C lib $@
+  endif
+  ifeq ($(WITH_V4LUTILS),yes)
+	$(MAKE) -C utils $@
+  endif
+
+sync-with-kernel:
+	@if [ ! -f $(KERNEL_DIR)/include/linux/videodev2.h -o \
+	      ! -f $(KERNEL_DIR)/include/linux/ivtv.h -o \
+	      ! -f $(KERNEL_DIR)/include/media/v4l2-chip-ident.h ]; then \
+	  echo "Error you must set KERNEL_DIR to point to an extracted kernel source dir"; \
+	  exit 1; \
+	fi
+	cp -a $(KERNEL_DIR)/include/linux/videodev2.h include/linux
+	cp -a $(KERNEL_DIR)/include/linux/ivtv.h include/linux
+	cp -a $(KERNEL_DIR)/include/media/v4l2-chip-ident.h include/media
+	$(MAKE) -C utils $@
+
+clean::
+	rm -f include/*/*~
+	$(MAKE) -C lib $@
+	$(MAKE) -C utils $@
+
+tag:
+	@git tag -a -m "Tag as v4l-utils-$(V4L_UTILS_VERSION)" v4l-utils-$(V4L_UTILS_VERSION)
+	@echo "Tagged as v4l-utils-$(V4L_UTILS_VERSION)"
+
+archive-no-tag:
+	@git archive --format=tar --prefix=v4l-utils-$(V4L_UTILS_VERSION)/ v4l-utils-$(V4L_UTILS_VERSION) > v4l-utils-$(V4L_UTILS_VERSION).tar
+	@bzip2 -f v4l-utils-$(V4L_UTILS_VERSION).tar
+
+archive: clean tag archive-no-tag
+
+export: clean
+	tar --transform s/^\./v4l-utils-$(V4L_UTILS_VERSION)/g \
+		--exclude=.git -jcvf \
+		/tmp/v4l-utils-$(V4L_UTILS_VERSION).tar.bz2 .
+
+include Make.rules
diff --git a/configure.in b/configure.in
new file mode 100644
index 0000000..0f9a058
--- /dev/null
+++ b/configure.in
@@ -0,0 +1,42 @@
+AC_INIT(v4l-utils.spec.in)
+
+V4L_UTILS_VERSION=0.9.0-test
+
+dnl ---------------------------------------------------------------------
+dnl Checks for programs.
+AC_PROG_CC
+AC_PROG_CXX
+AC_LANG_C
+AC_PROG_MAKE_SET
+AC_HEADER_STDC
+
+dnl ---------------------------------------------------------------------
+dnl Options
+
+AC_ARG_ENABLE(libv4l,
+  [  --disable-libv4l        disable dynamic libv4l compilation],
+  [case "${enableval}" in
+     yes | no ) WITH_LIBV4L="${enableval}" ;;
+     *) AC_MSG_ERROR(bad value ${enableval} for --disable-ctemplate) ;;
+   esac],
+  [WITH_LIBV4L="yes"]
+)
+
+AC_ARG_ENABLE(v4l-utils,
+  [  --disable-v4l-utils     disable v4l-utils compilation],
+  [case "${enableval}" in
+     yes | no ) WITH_V4LUTILS="${enableval}" ;;
+     *) AC_MSG_ERROR(bad value ${enableval} for --disable-ctemplate) ;;
+   esac],
+  [WITH_V4LUTILS="yes"]
+)
+
+dnl ---------------------------------------------------------------------
+dnl Substitute vars
+AC_SUBST(V4L_UTILS_VERSION)
+AC_SUBST(WITH_LIBV4L)
+AC_SUBST(WITH_V4LUTILS)
+
+dnl ---------------------------------------------------------------------
+dnl read Makefile.in and write Makefile
+AC_OUTPUT(Makefile)
diff --git a/makefile b/makefile
new file mode 100644
index 0000000..20c0822
--- /dev/null
+++ b/makefile
@@ -0,0 +1,23 @@
+.PHONY: default configure distclean
+
+ifeq ($(wildcard configure),)
+default: configure
+else
+default: all
+endif
+
+configure:
+	@set -ex; autoconf
+	@rm -rf autom4te.cache
+	@echo "*** You should now run ./configure or make ***"
+distclean:
+	-$(MAKE) -f Makefile clean
+	-rm Makefile configure config.h v4l-utils.spec
+
+-include Makefile
+
+ifeq ($(wildcard Makefile),)
+all:
+	./configure
+	@$(MAKE) -f Makefile all
+endif
diff --git a/utils/qv4l2/qv4l2.pro b/utils/qv4l2/qv4l2.pro
index 87cf097..939b71f 100644
--- a/utils/qv4l2/qv4l2.pro
+++ b/utils/qv4l2/qv4l2.pro
@@ -9,6 +9,6 @@ CONFIG += debug
  # Input
  HEADERS += qv4l2.h general-tab.h v4l2-api.h capture-win.h
  SOURCES += qv4l2.cpp general-tab.cpp ctrl-tab.cpp v4l2-api.cpp capture-win.cpp
-LIBS += -L../../lib/libv4l2 -lv4l2 -L../../lib/libv4lconvert -lv4lconvert -lrt -L../libv4l2util -lv4l2util
+LIBS += -L../../lib/libv4l2 -lv4l2 -L../../lib/libv4lconvert -lv4lconvert -lrt -L../libv4l2util -lv4l2util -ldl -ljpeg
  
  RESOURCES += qv4l2.qrc
diff --git a/v4l-utils.spec.in b/v4l-utils.spec.in
new file mode 100644
index 0000000..c37780f
--- /dev/null
+++ b/v4l-utils.spec.in
@@ -0,0 +1,167 @@
+Name:           v4l-utils
+Version:        @@V4L_UTILS_VERSION@@
+Release:        1%{?dist}
+Summary:        Utilities for video4linux and DVB devices
+Group:          Applications/System
+# ir-keytable and v4l2-sysfs-path are GPLv2 only
+License:        GPLv2+ and GPLv2
+URL:            http://www.linuxtv.org/downloads/v4l-utils/
+Source0:        http://linuxtv.org/downloads/v4l-utils/v4l-utils-%{version}.tar.bz2
+Source1:        qv4l2.desktop
+Source2:        qv4l2.svg
+BuildRoot:      %{_tmppath}/%{name}-%{version}-%{release}-root-%(%{__id_u} -n)
+BuildRequires:  qt4-devel libsysfs-devel kernel-headers desktop-file-utils
+# For /etc/udev/rules.d ownership
+Requires:       udev
+Requires:       libv4l = %{version}-%{release}
+
+%description
+v4l-utils is a collection of various video4linux (V4L) and DVB utilities. The
+main v4l-utils package contains cx18-ctl, ir-keytable, ivtv-ctl, v4l2-ctl and
+v4l2-sysfs-path.
+
+
+%package        devel-tools
+Summary:        Utilities for v4l2 / DVB driver development and debugging
+# decode_tm6000 is GPLv2 only
+License:        GPLv2+ and GPLv2
+Requires:       libv4l = %{version}-%{release}
+
+%description    devel-tools
+Utilities for v4l2 / DVB driver authors: decode_tm6000, v4l2-compliance and
+v4l2-dbg.
+
+
+%package -n     qv4l2
+Summary:        QT v4l2 test control and streaming test application
+License:        GPLv2+
+Requires:       libv4l = %{version}-%{release}
+
+%description -n qv4l2
+QT v4l2 test control and streaming test application.
+
+
+%package -n     libv4l
+Summary:        Collection of video4linux support libraries
+Group:          System Environment/Libraries
+# Some of the decompression helpers are GPLv2, the rest is LGPLv2+
+License:        LGPLv2+ and GPLv2
+URL:            http://hansdegoede.livejournal.com/3636.html
+
+%description -n libv4l
+libv4l is a collection of libraries which adds a thin abstraction layer on
+top of video4linux2 devices. The purpose of this (thin) layer is to make it
+easy for application writers to support a wide variety of devices without
+having to write separate code for different devices in the same class. libv4l
+consists of 3 different libraries: libv4lconvert, libv4l1 and libv4l2.
+
+libv4lconvert offers functions to convert from any (known) pixel-format
+to V4l2_PIX_FMT_BGR24 or V4l2_PIX_FMT_YUV420.
+
+libv4l1 offers the (deprecated) v4l1 API on top of v4l2 devices, independent
+of the drivers for those devices supporting v4l1 compatibility (which many
+v4l2 drivers do not).
+
+libv4l2 offers the v4l2 API on top of v4l2 devices, while adding for the
+application transparent libv4lconvert conversion where necessary.
+
+
+%package -n     libv4l-devel
+Summary:        Development files for libv4l
+Group:          Development/Libraries
+License:        LGPLv2+
+URL:            http://hansdegoede.livejournal.com/3636.html
+Requires:       libv4l = %{version}-%{release}
+
+%description -n libv4l-devel
+The libv4l-devel package contains libraries and header files for
+developing applications that use libv4l.
+
+
+%prep
+%setup -q
+
+
+%build
+make %{?_smp_mflags} CFLAGS="$RPM_OPT_FLAGS" CXXFLAGS="$RPM_OPT_FLAGS" \
+  PREFIX=%{_prefix} LIBDIR=%{_libdir}
+
+
+%install
+rm -rf $RPM_BUILD_ROOT
+make install PREFIX=%{_prefix} LIBDIR=%{_libdir} DESTDIR=$RPM_BUILD_ROOT
+# below is the desktop file and icon stuff.
+mkdir -p $RPM_BUILD_ROOT%{_datadir}/applications
+desktop-file-install --dir $RPM_BUILD_ROOT%{_datadir}/applications \
+  %{SOURCE1}
+mkdir -p $RPM_BUILD_ROOT%{_datadir}/icons/hicolor/scalable/apps
+install -p -m 644 %{SOURCE2} \
+  $RPM_BUILD_ROOT%{_datadir}/icons/hicolor/scalable/apps
+
+
+%clean
+rm -rf $RPM_BUILD_ROOT
+
+
+%post -n libv4l -p /sbin/ldconfig
+
+%postun -n libv4l -p /sbin/ldconfig
+
+%post -n qv4l2
+touch --no-create %{_datadir}/icons/hicolor &>/dev/null || :
+
+%postun -n qv4l2
+if [ $1 -eq 0 ] ; then
+    touch --no-create %{_datadir}/icons/hicolor &>/dev/null
+    gtk-update-icon-cache %{_datadir}/icons/hicolor &>/dev/null || :
+fi
+
+%posttrans -n qv4l2
+gtk-update-icon-cache %{_datadir}/icons/hicolor &>/dev/null || :
+
+
+%files
+%defattr(-,root,root,-)
+%doc README
+%dir %{_sysconfdir}/rc_keymaps
+%config(noreplace) %{_sysconfdir}/rc_keymaps/*
+%config(noreplace) %{_sysconfdir}/rc_maps.cfg
+%config(noreplace) %{_sysconfdir}/udev/rules.d/70-infrared.rules
+%{_bindir}/cx18-ctl
+%{_bindir}/ir-keytable
+%{_bindir}/ivtv-ctl
+%{_bindir}/v4l2-ctl
+%{_bindir}/v4l2-sysfs-path
+%{_mandir}/man1/ir-keytable.1*
+
+%files devel-tools
+%defattr(-,root,root,-)
+%doc README
+%{_bindir}/decode_tm6000
+%{_bindir}/v4l2-compliance
+%{_sbindir}/v4l2-dbg
+
+%files -n qv4l2
+%defattr(-,root,root,-)
+%doc README
+%{_bindir}/qv4l2
+%{_datadir}/applications/qv4l2.desktop
+%{_datadir}/icons/hicolor/scalable/apps/qv4l2.svg
+
+%files -n libv4l
+%defattr(-,root,root,-)
+%doc COPYING.LIB COPYING ChangeLog README.lib TODO
+%{_libdir}/libv4l*.so.*
+%{_libdir}/libv4l
+
+%files -n libv4l-devel
+%defattr(-,root,root,-)
+%doc README.lib-multi-threading
+%{_includedir}/libv4l*.h
+%{_libdir}/libv4l*.so
+%{_libdir}/pkgconfig/libv4l*.pc
+
+
+%changelog
+* Thr Oct 06 2011 Mauro Carvalho Chehab <mchehab@redhat.com> 0.9.0-test
+- Initial v4l-utils.spec file
