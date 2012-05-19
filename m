Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f172.google.com ([209.85.212.172]:45708 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758007Ab2ESXjo (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 19 May 2012 19:39:44 -0400
Received: by wibhj8 with SMTP id hj8so1223656wib.1
        for <linux-media@vger.kernel.org>; Sat, 19 May 2012 16:39:43 -0700 (PDT)
From: =?UTF-8?q?Andr=C3=A9=20Roth?= <neolynx@gmail.com>
To: linux-media@vger.kernel.org
Cc: =?UTF-8?q?Andr=C3=A9=20Roth?= <neolynx@gmail.com>
Subject: [PATCH 2/3] renamings for dvb-sat, dvb-scan
Date: Sun, 20 May 2012 01:38:53 +0200
Message-Id: <1337470734-14935-2-git-send-email-neolynx@gmail.com>
In-Reply-To: <1337470734-14935-1-git-send-email-neolynx@gmail.com>
References: <1337470734-14935-1-git-send-email-neolynx@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

---
 lib/include/dvb-fe.h                   |    2 +-
 lib/include/{libsat.h => dvb-sat.h}    |    0
 lib/include/{libscan.h => dvb-scan.h}  |    0
 lib/libdvbv5/Makefile.am               |    6 +++---
 lib/libdvbv5/descriptors.c             |    2 +-
 lib/libdvbv5/dvb-file.c                |    2 +-
 lib/libdvbv5/{libsat.c => dvb-sat.c}   |    0
 lib/libdvbv5/{libscan.c => dvb-scan.c} |    2 +-
 utils/dvb/dvb-format-convert.c         |    2 +-
 utils/dvb/dvbv5-scan.c                 |    2 +-
 utils/dvb/dvbv5-zap.c                  |    2 +-
 11 files changed, 10 insertions(+), 10 deletions(-)
 rename lib/include/{libsat.h => dvb-sat.h} (100%)
 rename lib/include/{libscan.h => dvb-scan.h} (100%)
 rename lib/libdvbv5/{libsat.c => dvb-sat.c} (100%)
 rename lib/libdvbv5/{libscan.c => dvb-scan.c} (99%)

diff --git a/lib/include/dvb-fe.h b/lib/include/dvb-fe.h
index 3fdae4f..0133ff3 100644
--- a/lib/include/dvb-fe.h
+++ b/lib/include/dvb-fe.h
@@ -30,7 +30,7 @@
 #include <sys/ioctl.h>
 #include <string.h>
 #include "dvb-frontend.h"
-#include "libsat.h"
+#include "dvb-sat.h"
 
 #define dvb_log(fmt, arg...) do {\
   parms->logfunc(fmt, ##arg); \
diff --git a/lib/include/libsat.h b/lib/include/dvb-sat.h
similarity index 100%
rename from lib/include/libsat.h
rename to lib/include/dvb-sat.h
diff --git a/lib/include/libscan.h b/lib/include/dvb-scan.h
similarity index 100%
rename from lib/include/libscan.h
rename to lib/include/dvb-scan.h
diff --git a/lib/libdvbv5/Makefile.am b/lib/libdvbv5/Makefile.am
index 67db06a..660841b 100644
--- a/lib/libdvbv5/Makefile.am
+++ b/lib/libdvbv5/Makefile.am
@@ -2,7 +2,7 @@ if WITH_LIBDVBV5
 lib_LTLIBRARIES = libdvbv5.la
 include_HEADERS = ../include/dvb-demux.h ../include/dvb-v5-std.h \
   ../include/dvb-file.h ../include/dvb-frontend.h ../include/dvb-fe.h \
-  ../include/libsat.h ../include/libscan.h
+  ../include/dvb-sat.h ../include/dvb-scan.h
 pkgconfig_DATA = libdvbv5.pc
 else
 noinst_LTLIBRARIES = libdvbv5.la
@@ -18,8 +18,8 @@ libdvbv5_la_SOURCES = \
   dvb-legacy-channel-format.c \
   dvb-zap-format.c \
   descriptors.c descriptors.h \
-  libsat.c ../include/libsat.h \
-  libscan.c ../include/libscan.h \
+  dvb-sat.c ../include/dvb-sat.h \
+  dvb-scan.c ../include/dvb-scan.h \
   parse_string.c parse_string.h
 libdvbv5_la_CPPFLAGS = $(ENFORCE_LIBDVBV5_STATIC)
 libdvbv5_la_LDFLAGS = -version-info 0 $(ENFORCE_LIBDVBV5_STATIC)
diff --git a/lib/libdvbv5/descriptors.c b/lib/libdvbv5/descriptors.c
index 249ae6d..63c4b56 100644
--- a/lib/libdvbv5/descriptors.c
+++ b/lib/libdvbv5/descriptors.c
@@ -23,7 +23,7 @@
 #include <stdio.h>
 
 #include "dvb-fe.h"
-#include "libscan.h"
+#include "dvb-scan.h"
 #include "descriptors.h"
 #include "parse_string.h"
 #include "dvb-frontend.h"
diff --git a/lib/libdvbv5/dvb-file.c b/lib/libdvbv5/dvb-file.c
index d7cf13e..0b9ccda 100644
--- a/lib/libdvbv5/dvb-file.c
+++ b/lib/libdvbv5/dvb-file.c
@@ -25,7 +25,7 @@
 
 #include "dvb-file.h"
 #include "dvb-v5-std.h"
-#include "libscan.h"
+#include "dvb-scan.h"
 
 static const char *parm_name(const struct parse_table *table)
 {
diff --git a/lib/libdvbv5/libsat.c b/lib/libdvbv5/dvb-sat.c
similarity index 100%
rename from lib/libdvbv5/libsat.c
rename to lib/libdvbv5/dvb-sat.c
diff --git a/lib/libdvbv5/libscan.c b/lib/libdvbv5/dvb-scan.c
similarity index 99%
rename from lib/libdvbv5/libscan.c
rename to lib/libdvbv5/dvb-scan.c
index 7916d36..e0a546c 100644
--- a/lib/libdvbv5/libscan.c
+++ b/lib/libdvbv5/dvb-scan.c
@@ -25,7 +25,7 @@
  *	ETSI EN 300 468 V1.11.1 (2010-04)
  *****************************************************************************/
 
-#include "libscan.h"
+#include "dvb-scan.h"
 #include "dvb-frontend.h"
 #include "descriptors.h"
 #include "parse_string.h"
diff --git a/utils/dvb/dvb-format-convert.c b/utils/dvb/dvb-format-convert.c
index 6db5219..cad0f59 100644
--- a/utils/dvb/dvb-format-convert.c
+++ b/utils/dvb/dvb-format-convert.c
@@ -33,7 +33,7 @@
 
 #include "dvb-file.h"
 #include "dvb-demux.h"
-#include "libscan.h"
+#include "dvb-scan.h"
 
 #define PROGRAM_NAME	"dvb-format-convert"
 
diff --git a/utils/dvb/dvbv5-scan.c b/utils/dvb/dvbv5-scan.c
index 64945cc..6cabe8e 100644
--- a/utils/dvb/dvbv5-scan.c
+++ b/utils/dvb/dvbv5-scan.c
@@ -36,7 +36,7 @@
 #include "dvb-file.h"
 #include "dvb-demux.h"
 #include "dvb-v5-std.h"
-#include "libscan.h"
+#include "dvb-scan.h"
 
 #define PROGRAM_NAME	"dvbv5-scan"
 #define DEFAULT_OUTPUT  "dvb_channel.conf"
diff --git a/utils/dvb/dvbv5-zap.c b/utils/dvb/dvbv5-zap.c
index 819ca39..b71d77f 100644
--- a/utils/dvb/dvbv5-zap.c
+++ b/utils/dvb/dvbv5-zap.c
@@ -38,7 +38,7 @@
 #include <linux/dvb/dmx.h>
 #include "dvb-file.h"
 #include "dvb-demux.h"
-#include "libscan.h"
+#include "dvb-scan.h"
 
 #define CHANNEL_FILE	"channels.conf"
 #define PROGRAM_NAME	"dvbv5-zap"
-- 
1.7.2.5

