Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:63496 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S941065AbcISNXk (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 19 Sep 2016 09:23:40 -0400
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Cc: mchehab@s-opensource.com, gjasny@googlemail.com
Subject: [v4l-utils PATCH 2/2] Add --with-static-binaries option to link binaries statically
Date: Mon, 19 Sep 2016 16:22:30 +0300
Message-Id: <1474291350-15655-1-git-send-email-sakari.ailus@linux.intel.com>
In-Reply-To: <1474282225-31559-1-git-send-email-sakari.ailus@linux.intel.com>
References: <1474282225-31559-1-git-send-email-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add a new variable STATIC_LDFLAGS to add the linker flags required for
static linking for each binary built.

Static and dynamic libraries are built by default but the binaries are
otherwise linked dynamically. --with-static-binaries requires that static
libraries are built.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
 configure.ac                      |  5 +++++
 contrib/gconv/Makefile.am         |  4 ++--
 contrib/test/Makefile.am          |  8 ++++----
 lib/libv4l1/Makefile.am           |  2 +-
 lib/libv4l2/Makefile.am           |  2 +-
 utils/cec-compliance/Makefile.am  |  2 +-
 utils/cec-ctl/Makefile.am         |  1 +
 utils/cec-follower/Makefile.am    |  2 +-
 utils/cx18-ctl/Makefile.am        |  1 +
 utils/decode_tm6000/Makefile.am   |  2 +-
 utils/dvb/Makefile.am             | 10 +++++-----
 utils/ir-ctl/Makefile.am          |  2 +-
 utils/ivtv-ctl/Makefile.am        |  2 +-
 utils/keytable/Makefile.am        |  2 +-
 utils/media-ctl/Makefile.am       |  1 +
 utils/qv4l2/Makefile.am           |  6 +++---
 utils/rds-ctl/Makefile.am         |  2 +-
 utils/v4l2-compliance/Makefile.am |  1 +
 utils/v4l2-ctl/Makefile.am        |  1 +
 utils/v4l2-sysfs-path/Makefile.am |  2 +-
 20 files changed, 34 insertions(+), 24 deletions(-)

diff --git a/configure.ac b/configure.ac
index 0d416b0..91597a4 100644
--- a/configure.ac
+++ b/configure.ac
@@ -427,6 +427,11 @@ AM_CONDITIONAL([WITH_V4L2_COMPLIANCE_LIBV4L], [test x${enable_v4l2_compliance_li
 # append -static to libtool compile and link command to enforce static libs
 AS_IF([test x$enable_libdvbv5 = xno], [AC_SUBST([ENFORCE_LIBDVBV5_STATIC], ["-static"])])
 AS_IF([test x$enable_libv4l = xno],   [AC_SUBST([ENFORCE_LIBV4L_STATIC],   ["-static"])])
+AC_ARG_WITH([static-binaries], AS_HELP_STRING([--with-static-binaries], [link binaries statically, requires static libraries to be built]))
+AS_IF([test x$with_static_binaries = xyes],
+      [AS_IF([test x$enable_static = xno],
+	     [AC_MSG_ERROR([--with-static-binaries requires --enable-static])])]
+      [AC_SUBST([STATIC_LDFLAGS], ["--static -static"])])
 
 # misc
 
diff --git a/contrib/gconv/Makefile.am b/contrib/gconv/Makefile.am
index 0e89f5b..2a39e5e 100644
--- a/contrib/gconv/Makefile.am
+++ b/contrib/gconv/Makefile.am
@@ -9,9 +9,9 @@ gconv_base_sources = iconv/skeleton.c iconv/loop.c
 arib-std-b24.c, en300-468-tab00.c: $(gconv_base_sources)
 
 ARIB_STD_B24_la_SOURCES = arib-std-b24.c jis0201.h jis0208.h jisx0213.h
-ARIB_STD_B24_la_LDFLAGS = $(gconv_ldflags) -L@gconvsysdir@ -R @gconvsysdir@ -lJIS -lJISX0213
+ARIB_STD_B24_la_LDFLAGS = $(gconv_ldflags) -L@gconvsysdir@ -R @gconvsysdir@ -lJIS -lJISX0213 $(STATIC_LDFLAGS)
 
 EN300_468_TAB00_la_SOURCES = en300-468-tab00.c
-EN300_468_TAB00_la_LDFLAGS = $(gconv_ldflags)
+EN300_468_TAB00_la_LDFLAGS = $(gconv_ldflags) $(STATIC_LDFLAGS)
 
 EXTRA_DIST = $(gconv_base_sources) $(gconv_DATA) gconv.map
diff --git a/contrib/test/Makefile.am b/contrib/test/Makefile.am
index 4641e21..7914f72 100644
--- a/contrib/test/Makefile.am
+++ b/contrib/test/Makefile.am
@@ -21,18 +21,18 @@ driver_test_LDADD = ../../utils/libv4l2util/libv4l2util.la
 
 pixfmt_test_SOURCES = pixfmt-test.c
 pixfmt_test_CFLAGS = $(X11_CFLAGS)
-pixfmt_test_LDFLAGS = $(X11_LIBS)
+pixfmt_test_LDFLAGS = $(X11_LIBS) $(STATIC_LDFLAGS)
 
 v4l2grab_SOURCES = v4l2grab.c
-v4l2grab_LDFLAGS = $(ARGP_LIBS)
+v4l2grab_LDFLAGS = $(ARGP_LIBS) $(STATIC_LDFLAGS)
 v4l2grab_LDADD = ../../lib/libv4l2/libv4l2.la ../../lib/libv4lconvert/libv4lconvert.la -lpthread
 
 v4l2gl_SOURCES = v4l2gl.c
-v4l2gl_LDFLAGS = $(X11_LIBS) $(GL_LIBS) $(GLU_LIBS) $(ARGP_LIBS)
+v4l2gl_LDFLAGS = $(X11_LIBS) $(GL_LIBS) $(GLU_LIBS) $(ARGP_LIBS) $(STATIC_LDFLAGS)
 v4l2gl_LDADD = ../../lib/libv4l2/libv4l2.la ../../lib/libv4lconvert/libv4lconvert.la
 
 mc_nextgen_test_CFLAGS = $(LIBUDEV_CFLAGS)
-mc_nextgen_test_LDFLAGS = $(LIBUDEV_LIBS)
+mc_nextgen_test_LDFLAGS = $(LIBUDEV_LIBS) $(STATIC_LDFLAGS)
 
 
 ioctl_test_SOURCES = ioctl-test.c ioctl-test.h ioctl_32.h ioctl_64.h
diff --git a/lib/libv4l1/Makefile.am b/lib/libv4l1/Makefile.am
index f768eaa..ea1fdf0 100644
--- a/lib/libv4l1/Makefile.am
+++ b/lib/libv4l1/Makefile.am
@@ -23,7 +23,7 @@ libv4l1_la_LIBADD = ../libv4l2/libv4l2.la
 v4l1compat_la_SOURCES = v4l1compat.c
 
 v4l1compat_la_LIBADD = libv4l1.la
-v4l1compat_la_LDFLAGS = -avoid-version -module -shared -export-dynamic
+v4l1compat_la_LDFLAGS = -avoid-version -module -shared -export-dynamic $(STATIC_LDFLAGS)
 v4l1compat_la_LIBTOOLFLAGS = --tag=disable-static
 
 EXTRA_DIST = libv4l1-kernelcode-license.txt
diff --git a/lib/libv4l2/Makefile.am b/lib/libv4l2/Makefile.am
index 1314a99..316d2e0 100644
--- a/lib/libv4l2/Makefile.am
+++ b/lib/libv4l2/Makefile.am
@@ -22,7 +22,7 @@ libv4l2_la_LIBADD = ../libv4lconvert/libv4lconvert.la
 
 v4l2convert_la_SOURCES = v4l2convert.c
 v4l2convert_la_LIBADD = libv4l2.la
-v4l2convert_la_LDFLAGS = -avoid-version -module -shared -export-dynamic
+v4l2convert_la_LDFLAGS = -avoid-version -module -shared -export-dynamic $(STATIC_LDFLAGS)
 v4l2convert_la_LIBTOOLFLAGS = --tag=disable-static
 
 EXTRA_DIST = Android.mk v4l2-plugin-android.c
diff --git a/utils/cec-compliance/Makefile.am b/utils/cec-compliance/Makefile.am
index 8b0c4f3..f831122 100644
--- a/utils/cec-compliance/Makefile.am
+++ b/utils/cec-compliance/Makefile.am
@@ -2,7 +2,7 @@ bin_PROGRAMS = cec-compliance
 man_MANS = cec-compliance.1
 
 cec_compliance_SOURCES = cec-compliance.cpp cec-test.cpp cec-test-adapter.cpp cec-test-audio.cpp cec-test-power.cpp
-cec_compliance_LDFLAGS = -lrt
+cec_compliance_LDFLAGS = -lrt $(STATIC_LDFLAGS)
 
 cec-compliance.cpp: cec-table.h
 
diff --git a/utils/cec-ctl/Makefile.am b/utils/cec-ctl/Makefile.am
index c11fbfa..f5e2cc5 100644
--- a/utils/cec-ctl/Makefile.am
+++ b/utils/cec-ctl/Makefile.am
@@ -2,6 +2,7 @@ bin_PROGRAMS = cec-ctl
 man_MANS = cec-ctl.1
 
 cec_ctl_SOURCES = cec-ctl.cpp
+cec_ctl_LDFLAGS = $(STATIC_LDFLAGS)
 
 cec-ctl.cpp: cec-ctl-gen.h
 
diff --git a/utils/cec-follower/Makefile.am b/utils/cec-follower/Makefile.am
index 835c7a8..48d6f53 100644
--- a/utils/cec-follower/Makefile.am
+++ b/utils/cec-follower/Makefile.am
@@ -2,7 +2,7 @@ bin_PROGRAMS = cec-follower
 man_MANS = cec-follower.1
 
 cec_follower_SOURCES = cec-follower.cpp cec-processing.cpp cec-log.cpp
-cec_follower_LDFLAGS = -lrt
+cec_follower_LDFLAGS = -lrt $(STATIC_LDFLAGS)
 
 cec-log.cpp: cec-log.h
 
diff --git a/utils/cx18-ctl/Makefile.am b/utils/cx18-ctl/Makefile.am
index 94fce36..71e2100 100644
--- a/utils/cx18-ctl/Makefile.am
+++ b/utils/cx18-ctl/Makefile.am
@@ -1,3 +1,4 @@
 bin_PROGRAMS = cx18-ctl
 
 cx18_ctl_SOURCES = cx18-ctl.c
+cx18_ctl_LDFLAGS = $(STATIC_LDFLAGS)
diff --git a/utils/decode_tm6000/Makefile.am b/utils/decode_tm6000/Makefile.am
index ac4e85e..7c3fbef 100644
--- a/utils/decode_tm6000/Makefile.am
+++ b/utils/decode_tm6000/Makefile.am
@@ -1,4 +1,4 @@
 bin_PROGRAMS = decode_tm6000
 decode_tm6000_SOURCES = decode_tm6000.c
 decode_tm6000_LDADD = ../libv4l2util/libv4l2util.la
-decode_tm6000_LDFLAGS = $(ARGP_LIBS)
+decode_tm6000_LDFLAGS = $(ARGP_LIBS) $(STATIC_LDFLAGS)
diff --git a/utils/dvb/Makefile.am b/utils/dvb/Makefile.am
index d2f9b53..619f508 100644
--- a/utils/dvb/Makefile.am
+++ b/utils/dvb/Makefile.am
@@ -9,23 +9,23 @@ man_MANS = dvb-fe-tool.1 dvbv5-zap.1 dvbv5-scan.1 dvb-format-convert.1
 
 dvb_fe_tool_SOURCES = dvb-fe-tool.c
 dvb_fe_tool_LDADD = ../../lib/libdvbv5/libdvbv5.la @LIBINTL@ $(LIBUDEV_LIBS) $(XMLRPC_LDADD)
-dvb_fe_tool_LDFLAGS = $(ARGP_LIBS) -lm $(LIBUDEV_CFLAGS) $(XMLRPC_LDFLAGS)
+dvb_fe_tool_LDFLAGS = $(ARGP_LIBS) -lm $(LIBUDEV_CFLAGS) $(XMLRPC_LDFLAGS) $(STATIC_LDFLAGS)
 
 dvbv5_zap_SOURCES = dvbv5-zap.c
 dvbv5_zap_LDADD = ../../lib/libdvbv5/libdvbv5.la @LIBINTL@ $(LIBUDEV_LIBS) $(XMLRPC_LDADD)
-dvbv5_zap_LDFLAGS = $(ARGP_LIBS) -lm $(LIBUDEV_CFLAGS) $(XMLRPC_LDFLAGS)
+dvbv5_zap_LDFLAGS = $(ARGP_LIBS) -lm $(LIBUDEV_CFLAGS) $(XMLRPC_LDFLAGS) $(STATIC_LDFLAGS)
 
 dvbv5_scan_SOURCES = dvbv5-scan.c
 dvbv5_scan_LDADD = ../../lib/libdvbv5/libdvbv5.la @LIBINTL@ $(LIBUDEV_LIBS) $(XMLRPC_LDADD)
-dvbv5_scan_LDFLAGS = $(ARGP_LIBS) -lm $(LIBUDEV_CFLAGS) $(XMLRPC_LDFLAGS)
+dvbv5_scan_LDFLAGS = $(ARGP_LIBS) -lm $(LIBUDEV_CFLAGS) $(XMLRPC_LDFLAGS) $(STATIC_LDFLAGS)
 
 dvb_format_convert_SOURCES = dvb-format-convert.c
 dvb_format_convert_LDADD = ../../lib/libdvbv5/libdvbv5.la @LIBINTL@ $(LIBUDEV_LIBS) $(XMLRPC_LDADD)
-dvb_format_convert_LDFLAGS = $(ARGP_LIBS) -lm $(LIBUDEV_CFLAGS) $(XMLRPC_LDFLAGS)
+dvb_format_convert_LDFLAGS = $(ARGP_LIBS) -lm $(LIBUDEV_CFLAGS) $(XMLRPC_LDFLAGS) $(STATIC_LDFLAGS)
 
 dvbv5_daemon_SOURCES = dvbv5-daemon.c
 dvbv5_daemon_LDADD = ../../lib/libdvbv5/libdvbv5.la @LIBINTL@ $(LIBUDEV_LIBS) $(XMLRPC_LDADD) $(PTHREAD_LDADD)
-dvbv5_daemon_LDFLAGS = $(ARGP_LIBS) -lm $(XMLRPC_LDFLAGS) $(PTHREAD_LDFLAGS)
+dvbv5_daemon_LDFLAGS = $(ARGP_LIBS) -lm $(XMLRPC_LDFLAGS) $(PTHREAD_LDFLAGS) $(STATIC_LDFLAGS)
 dvbv5_daemon_CFLAGS =  $(XMLRPC_CFLAGS) $(LIBUDEV_CFLAGS) $(PTHREAD_CFLAGS)
 
 EXTRA_DIST = README
diff --git a/utils/ir-ctl/Makefile.am b/utils/ir-ctl/Makefile.am
index 9a1bfed..bfe85ef 100644
--- a/utils/ir-ctl/Makefile.am
+++ b/utils/ir-ctl/Makefile.am
@@ -3,4 +3,4 @@ man_MANS = ir-ctl.1
 
 ir_ctl_SOURCES = ir-ctl.c
 ir_ctl_LDADD = @LIBINTL@
-ir_ctl_LDFLAGS = $(ARGP_LIBS)
+ir_ctl_LDFLAGS = $(ARGP_LIBS) $(STATIC_LDFLAGS)
diff --git a/utils/ivtv-ctl/Makefile.am b/utils/ivtv-ctl/Makefile.am
index c119667..76509a0 100644
--- a/utils/ivtv-ctl/Makefile.am
+++ b/utils/ivtv-ctl/Makefile.am
@@ -1,4 +1,4 @@
 bin_PROGRAMS = ivtv-ctl
 
 ivtv_ctl_SOURCES = ivtv-ctl.c
-ivtv_ctl_LDFLAGS = -lm
+ivtv_ctl_LDFLAGS = -lm $(STATIC_LDFLAGS)
diff --git a/utils/keytable/Makefile.am b/utils/keytable/Makefile.am
index 62b90ad..aa33996 100644
--- a/utils/keytable/Makefile.am
+++ b/utils/keytable/Makefile.am
@@ -6,7 +6,7 @@ udevrules_DATA = 70-infrared.rules
 
 ir_keytable_SOURCES = keytable.c parse.h
 ir_keytable_LDADD = @LIBINTL@
-ir_keytable_LDFLAGS = $(ARGP_LIBS)
+ir_keytable_LDFLAGS = $(ARGP_LIBS) $(STATIC_LDFLAGS)
 
 EXTRA_DIST = 70-infrared.rules rc_keymaps rc_keymaps_userspace gen_keytables.pl ir-keytable.1 rc_maps.cfg
 
diff --git a/utils/media-ctl/Makefile.am b/utils/media-ctl/Makefile.am
index ee7dcc9..35684e9 100644
--- a/utils/media-ctl/Makefile.am
+++ b/utils/media-ctl/Makefile.am
@@ -26,4 +26,5 @@ noinst_HEADERS = mediactl.h v4l2subdev.h
 
 bin_PROGRAMS = media-ctl
 media_ctl_SOURCES = media-ctl.c options.c options.h tools.h
+media_ctl_LDFLAGS = $(STATIC_LDFLAGS)
 media_ctl_LDADD = libmediactl.la libv4l2subdev.la
diff --git a/utils/qv4l2/Makefile.am b/utils/qv4l2/Makefile.am
index fd58486..fc8827d 100644
--- a/utils/qv4l2/Makefile.am
+++ b/utils/qv4l2/Makefile.am
@@ -12,14 +12,14 @@ qv4l2_CPPFLAGS = -I../common
 
 if WITH_QTGL
 qv4l2_CPPFLAGS += $(QTGL_CFLAGS)
-qv4l2_LDFLAGS = $(QTGL_LIBS)
+qv4l2_LDFLAGS = $(QTGL_LIBS) $(STATIC_LDFLAGS)
 else
 qv4l2_CPPFLAGS += $(QT_CFLAGS)
-qv4l2_LDFLAGS = $(QT_LIBS)
+qv4l2_LDFLAGS = $(QT_LIBS) $(STATIC_LDFLAGS)
 endif
 
 qv4l2_CPPFLAGS += $(ALSA_CFLAGS)
-qv4l2_LDFLAGS += $(ALSA_LIBS) -pthread
+qv4l2_LDFLAGS += $(ALSA_LIBS) -pthread $(STATIC_LDFLAGS)
 
 EXTRA_DIST = enterbutt.png exit.png fileopen.png qv4l2_24x24.png qv4l2_64x64.png qv4l2.png qv4l2.svg \
   snapshot.png video-television.png fileclose.png qv4l2_16x16.png qv4l2_32x32.png qv4l2.desktop \
diff --git a/utils/rds-ctl/Makefile.am b/utils/rds-ctl/Makefile.am
index df546ad..8600118 100644
--- a/utils/rds-ctl/Makefile.am
+++ b/utils/rds-ctl/Makefile.am
@@ -2,4 +2,4 @@ bin_PROGRAMS = rds-ctl
 
 rds_ctl_SOURCES = rds-ctl.cpp
 rds_ctl_LDADD = ../../lib/libv4l2/libv4l2.la ../../lib/libv4lconvert/libv4lconvert.la ../../lib/libv4l2rds/libv4l2rds.la
-
+rds_ctl_LDFLAGS = $(STATIC_LDFLAGS)
diff --git a/utils/v4l2-compliance/Makefile.am b/utils/v4l2-compliance/Makefile.am
index c2b5919..8363e45 100644
--- a/utils/v4l2-compliance/Makefile.am
+++ b/utils/v4l2-compliance/Makefile.am
@@ -6,6 +6,7 @@ v4l2_compliance_SOURCES = v4l2-compliance.cpp v4l2-test-debug.cpp v4l2-test-inpu
 	v4l2-test-controls.cpp v4l2-test-io-config.cpp v4l2-test-formats.cpp v4l2-test-buffers.cpp \
 	v4l2-test-codecs.cpp v4l2-test-colors.cpp v4l2-compliance.h
 v4l2_compliance_CPPFLAGS = -I../common
+v4l2_compliance_LDFLAGS = $(STATIC_LDFLAGS)
 
 if WITH_V4L2_COMPLIANCE_LIBV4L
 v4l2_compliance_LDADD = ../../lib/libv4l2/libv4l2.la ../../lib/libv4lconvert/libv4lconvert.la -lrt -lpthread
diff --git a/utils/v4l2-ctl/Makefile.am b/utils/v4l2-ctl/Makefile.am
index 2a05644..674f0c4 100644
--- a/utils/v4l2-ctl/Makefile.am
+++ b/utils/v4l2-ctl/Makefile.am
@@ -8,6 +8,7 @@ v4l2_ctl_SOURCES = v4l2-ctl.cpp v4l2-ctl.h v4l2-ctl-common.cpp v4l2-ctl-tuner.cp
 	v4l2-ctl-streaming.cpp v4l2-ctl-sdr.cpp v4l2-ctl-edid.cpp v4l2-ctl-modes.cpp \
 	v4l2-tpg-colors.c v4l2-tpg-core.c v4l-stream.c
 v4l2_ctl_CPPFLAGS = -I../common
+v4l2_ctl_LDFLAGS = $(STATIC_LDFLAGS)
 
 if WITH_V4L2_CTL_LIBV4L
 v4l2_ctl_LDADD = ../../lib/libv4l2/libv4l2.la ../../lib/libv4lconvert/libv4lconvert.la -lrt -lpthread
diff --git a/utils/v4l2-sysfs-path/Makefile.am b/utils/v4l2-sysfs-path/Makefile.am
index 6ef4228..d6deede 100644
--- a/utils/v4l2-sysfs-path/Makefile.am
+++ b/utils/v4l2-sysfs-path/Makefile.am
@@ -1,4 +1,4 @@
 bin_PROGRAMS = v4l2-sysfs-path
 v4l2_sysfs_path_SOURCES = v4l2-sysfs-path.c
 v4l2_sysfs_path_LDADD = ../libmedia_dev/libmedia_dev.la
-v4l2_sysfs_path_LDFLAGS = $(ARGP_LIBS)
+v4l2_sysfs_path_LDFLAGS = $(ARGP_LIBS) $(STATIC_LDFLAGS)
-- 
2.7.4

