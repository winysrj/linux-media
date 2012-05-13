Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f178.google.com ([209.85.212.178]:41796 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751421Ab2EMM3N (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 13 May 2012 08:29:13 -0400
Received: by wibhn6 with SMTP id hn6so1588914wib.1
        for <linux-media@vger.kernel.org>; Sun, 13 May 2012 05:29:12 -0700 (PDT)
From: =?UTF-8?q?Andr=C3=A9=20Roth?= <neolynx@gmail.com>
To: linux-media@vger.kernel.org
Cc: =?UTF-8?q?Andr=C3=A9=20Roth?= <neolynx@gmail.com>
Subject: [PATCH 1/6] libdvbv5 shared lib
Date: Sun, 13 May 2012 14:29:03 +0200
Message-Id: <1336912143-25890-1-git-send-email-neolynx@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

---
 Makefile.am                                        |    3 +-
 configure.ac                                       |    3 +-
 {utils/dvb => lib/include}/dvb-demux.h             |    0
 {utils/dvb => lib/include}/dvb-fe.h                |    0
 {utils/dvb => lib/include}/dvb-file.h              |    0
 {utils/dvb => lib/include}/dvb_frontend.h          |    0
 {utils/dvb => lib/include}/libsat.h                |    0
 {utils/dvb => lib/include}/libscan.h               |    0
 lib/libdvbv5/Makefile.am                           |   20 ++++++++++++++
 {utils/dvb => lib/libdvbv5}/descriptors.c          |    0
 {utils/dvb => lib/libdvbv5}/descriptors.h          |    0
 {utils/dvb => lib/libdvbv5}/dvb-demux.c            |    0
 {utils/dvb => lib/libdvbv5}/dvb-fe.c               |    0
 {utils/dvb => lib/libdvbv5}/dvb-file.c             |    0
 .../libdvbv5}/dvb-legacy-channel-format.c          |    0
 {utils/dvb => lib/libdvbv5}/dvb-v5-std.h           |    0
 {utils/dvb => lib/libdvbv5}/dvb-v5.h               |    0
 {utils/dvb => lib/libdvbv5}/dvb-zap-format.c       |    0
 {utils/dvb => lib/libdvbv5}/gen_dvb_structs.pl     |    0
 {utils/dvb => lib/libdvbv5}/libsat.c               |    0
 {utils/dvb => lib/libdvbv5}/libscan.c              |    0
 {utils/dvb => lib/libdvbv5}/parse_string.c         |    0
 {utils/dvb => lib/libdvbv5}/parse_string.h         |    0
 utils/dvb/Makefile.am                              |   27 +++----------------
 24 files changed, 29 insertions(+), 24 deletions(-)
 rename {utils/dvb => lib/include}/dvb-demux.h (100%)
 rename {utils/dvb => lib/include}/dvb-fe.h (100%)
 rename {utils/dvb => lib/include}/dvb-file.h (100%)
 rename {utils/dvb => lib/include}/dvb_frontend.h (100%)
 rename {utils/dvb => lib/include}/libsat.h (100%)
 rename {utils/dvb => lib/include}/libscan.h (100%)
 create mode 100644 lib/libdvbv5/Makefile.am
 rename {utils/dvb => lib/libdvbv5}/descriptors.c (100%)
 rename {utils/dvb => lib/libdvbv5}/descriptors.h (100%)
 rename {utils/dvb => lib/libdvbv5}/dvb-demux.c (100%)
 rename {utils/dvb => lib/libdvbv5}/dvb-fe.c (100%)
 rename {utils/dvb => lib/libdvbv5}/dvb-file.c (100%)
 rename {utils/dvb => lib/libdvbv5}/dvb-legacy-channel-format.c (100%)
 rename {utils/dvb => lib/libdvbv5}/dvb-v5-std.h (100%)
 rename {utils/dvb => lib/libdvbv5}/dvb-v5.h (100%)
 rename {utils/dvb => lib/libdvbv5}/dvb-zap-format.c (100%)
 rename {utils/dvb => lib/libdvbv5}/gen_dvb_structs.pl (100%)
 rename {utils/dvb => lib/libdvbv5}/libsat.c (100%)
 rename {utils/dvb => lib/libdvbv5}/libscan.c (100%)
 rename {utils/dvb => lib/libdvbv5}/parse_string.c (100%)
 rename {utils/dvb => lib/libdvbv5}/parse_string.h (100%)

diff --git a/Makefile.am b/Makefile.am
index 44a37de..ffe46a6 100644
--- a/Makefile.am
+++ b/Makefile.am
@@ -4,7 +4,8 @@ ACLOCAL_AMFLAGS = -I m4
 SUBDIRS = \
 	lib/libv4lconvert \
 	lib/libv4l2 \
-	lib/libv4l1
+	lib/libv4l1 \
+	lib/libdvbv5
 
 if WITH_V4LUTILS
 SUBDIRS += \
diff --git a/configure.ac b/configure.ac
index 2a90bb9..ad33e3b 100644
--- a/configure.ac
+++ b/configure.ac
@@ -13,6 +13,7 @@ AC_CONFIG_FILES([Makefile
 	lib/libv4lconvert/Makefile
 	lib/libv4l2/Makefile
 	lib/libv4l1/Makefile
+	lib/libdvbv5/Makefile
 
 	utils/libv4l2util/Makefile
 	utils/libmedia_dev/Makefile
@@ -78,7 +79,7 @@ AS_IF([test "x$with_jpeg" != xno],
                                       AC_DEFINE([HAVE_JPEG],[1],[whether we use libjpeg])],
                                      [AC_MSG_ERROR(cannot find libjpeg (v6 or later required))])],
                        [AC_MSG_ERROR(cannot find jpeglib.h)])])
-	     
+
 AM_CONDITIONAL([HAVE_JPEG], [$have_jpeg])
 
 PKG_CHECK_MODULES(QT, [QtCore >= 4.4 QtGui >= 4.4], [qt_pkgconfig=true], [qt_pkgconfig=false])
diff --git a/utils/dvb/dvb-demux.h b/lib/include/dvb-demux.h
similarity index 100%
rename from utils/dvb/dvb-demux.h
rename to lib/include/dvb-demux.h
diff --git a/utils/dvb/dvb-fe.h b/lib/include/dvb-fe.h
similarity index 100%
rename from utils/dvb/dvb-fe.h
rename to lib/include/dvb-fe.h
diff --git a/utils/dvb/dvb-file.h b/lib/include/dvb-file.h
similarity index 100%
rename from utils/dvb/dvb-file.h
rename to lib/include/dvb-file.h
diff --git a/utils/dvb/dvb_frontend.h b/lib/include/dvb_frontend.h
similarity index 100%
rename from utils/dvb/dvb_frontend.h
rename to lib/include/dvb_frontend.h
diff --git a/utils/dvb/libsat.h b/lib/include/libsat.h
similarity index 100%
rename from utils/dvb/libsat.h
rename to lib/include/libsat.h
diff --git a/utils/dvb/libscan.h b/lib/include/libscan.h
similarity index 100%
rename from utils/dvb/libscan.h
rename to lib/include/libscan.h
diff --git a/lib/libdvbv5/Makefile.am b/lib/libdvbv5/Makefile.am
new file mode 100644
index 0000000..90a0f50
--- /dev/null
+++ b/lib/libdvbv5/Makefile.am
@@ -0,0 +1,20 @@
+lib_LTLIBRARIES = libdvbv5.la
+
+libdvbv5_la_SOURCES = \
+  dvb-demux.c dvb-demux.h \
+  dvb-fe.c dvb-fe.h \
+  dvb-file.c dvb-file.h \
+  dvb_frontend.h  dvb-v5.h  dvb-v5-std.h \
+  dvb-legacy-channel-format.c \
+  dvb-zap-format.c \
+  descriptors.c descriptors.h \
+  libsat.c libsat.h \
+  libscan.c libscan.h \
+  parse_string.c parse_string.h
+#libdvbv5_la_CPPFLAGS = -fvisibility=hidden
+#libdvbv5_la_LDFLAGS = -version-info 0 -lpthread
+
+EXTRA_DIST = gen_dvb_structs.pl
+
+sync-with-kernel:
+	./gen_dvb_structs.pl $(KERNEL_DIR)/include/
diff --git a/utils/dvb/descriptors.c b/lib/libdvbv5/descriptors.c
similarity index 100%
rename from utils/dvb/descriptors.c
rename to lib/libdvbv5/descriptors.c
diff --git a/utils/dvb/descriptors.h b/lib/libdvbv5/descriptors.h
similarity index 100%
rename from utils/dvb/descriptors.h
rename to lib/libdvbv5/descriptors.h
diff --git a/utils/dvb/dvb-demux.c b/lib/libdvbv5/dvb-demux.c
similarity index 100%
rename from utils/dvb/dvb-demux.c
rename to lib/libdvbv5/dvb-demux.c
diff --git a/utils/dvb/dvb-fe.c b/lib/libdvbv5/dvb-fe.c
similarity index 100%
rename from utils/dvb/dvb-fe.c
rename to lib/libdvbv5/dvb-fe.c
diff --git a/utils/dvb/dvb-file.c b/lib/libdvbv5/dvb-file.c
similarity index 100%
rename from utils/dvb/dvb-file.c
rename to lib/libdvbv5/dvb-file.c
diff --git a/utils/dvb/dvb-legacy-channel-format.c b/lib/libdvbv5/dvb-legacy-channel-format.c
similarity index 100%
rename from utils/dvb/dvb-legacy-channel-format.c
rename to lib/libdvbv5/dvb-legacy-channel-format.c
diff --git a/utils/dvb/dvb-v5-std.h b/lib/libdvbv5/dvb-v5-std.h
similarity index 100%
rename from utils/dvb/dvb-v5-std.h
rename to lib/libdvbv5/dvb-v5-std.h
diff --git a/utils/dvb/dvb-v5.h b/lib/libdvbv5/dvb-v5.h
similarity index 100%
rename from utils/dvb/dvb-v5.h
rename to lib/libdvbv5/dvb-v5.h
diff --git a/utils/dvb/dvb-zap-format.c b/lib/libdvbv5/dvb-zap-format.c
similarity index 100%
rename from utils/dvb/dvb-zap-format.c
rename to lib/libdvbv5/dvb-zap-format.c
diff --git a/utils/dvb/gen_dvb_structs.pl b/lib/libdvbv5/gen_dvb_structs.pl
similarity index 100%
rename from utils/dvb/gen_dvb_structs.pl
rename to lib/libdvbv5/gen_dvb_structs.pl
diff --git a/utils/dvb/libsat.c b/lib/libdvbv5/libsat.c
similarity index 100%
rename from utils/dvb/libsat.c
rename to lib/libdvbv5/libsat.c
diff --git a/utils/dvb/libscan.c b/lib/libdvbv5/libscan.c
similarity index 100%
rename from utils/dvb/libscan.c
rename to lib/libdvbv5/libscan.c
diff --git a/utils/dvb/parse_string.c b/lib/libdvbv5/parse_string.c
similarity index 100%
rename from utils/dvb/parse_string.c
rename to lib/libdvbv5/parse_string.c
diff --git a/utils/dvb/parse_string.h b/lib/libdvbv5/parse_string.h
similarity index 100%
rename from utils/dvb/parse_string.h
rename to lib/libdvbv5/parse_string.h
diff --git a/utils/dvb/Makefile.am b/utils/dvb/Makefile.am
index dc499a9..bab1409 100644
--- a/utils/dvb/Makefile.am
+++ b/utils/dvb/Makefile.am
@@ -1,37 +1,20 @@
 bin_PROGRAMS = dvb-fe-tool dvbv5-zap dvbv5-scan dvb-format-convert
-noinst_LTLIBRARIES = libdvbv5.la
-
-libdvbv5_la_SOURCES = \
-  dvb-demux.c dvb-demux.h \
-  dvb-fe.c dvb-fe.h \
-  dvb-file.c dvb-file.h \
-  dvb_frontend.h  dvb-v5.h  dvb-v5-std.h \
-  dvb-legacy-channel-format.c \
-  dvb-zap-format.c \
-  descriptors.c descriptors.h \
-  libsat.c libsat.h \
-  libscan.c libscan.h \
-  parse_string.c parse_string.h
-libdvbv5_la_CPPFLAGS = -static
-libdvbv5_la_LDFLAGS = -static
 
 dvb_fe_tool_SOURCES = dvb-fe-tool.c
-dvb_fe_tool_LDADD = libdvbv5.la
+dvb_fe_tool_LDADD = ../../lib/libdvbv5/libdvbv5.la
 dvb_fe_tool_LDFLAGS = $(ARGP_LIBS)
 
 dvbv5_zap_SOURCES = dvbv5-zap.c
-dvbv5_zap_LDADD = libdvbv5.la
+dvbv5_zap_LDADD = ../../lib/libdvbv5/libdvbv5.la
 dvbv5_zap_LDFLAGS = $(ARGP_LIBS)
 
 dvbv5_scan_SOURCES = dvbv5-scan.c
-dvbv5_scan_LDADD = libdvbv5.la
+dvbv5_scan_LDADD = ../../lib/libdvbv5/libdvbv5.la
 dvbv5_scan_LDFLAGS = $(ARGP_LIBS)
 
 dvb_format_convert_SOURCES = dvb-format-convert.c
-dvb_format_convert_LDADD = libdvbv5.la
+dvb_format_convert_LDADD = ../../lib/libdvbv5/libdvbv5.la
 dvb_format_convert_LDFLAGS = $(ARGP_LIBS)
 
-EXTRA_DIST = README gen_dvb_structs.pl
+EXTRA_DIST = README
 
-sync-with-kernel:
-	./gen_dvb_structs.pl $(KERNEL_DIR)/include/
-- 
1.7.2.5

