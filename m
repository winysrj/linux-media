Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ee0-f53.google.com ([74.125.83.53]:53252 "EHLO
	mail-ee0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933811AbaDIW1X (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 9 Apr 2014 18:27:23 -0400
Received: by mail-ee0-f53.google.com with SMTP id b57so2359876eek.40
        for <linux-media@vger.kernel.org>; Wed, 09 Apr 2014 15:27:21 -0700 (PDT)
From: =?UTF-8?q?Andr=C3=A9=20Roth?= <neolynx@gmail.com>
To: linux-media@vger.kernel.org
Cc: =?UTF-8?q?Andr=C3=A9=20Roth?= <neolynx@gmail.com>
Subject: [PATCH 3/7] libdvbv5: make crc32 public
Date: Thu, 10 Apr 2014 00:26:56 +0200
Message-Id: <1397082420-31198-3-git-send-email-neolynx@gmail.com>
In-Reply-To: <1397082420-31198-1-git-send-email-neolynx@gmail.com>
References: <1397082420-31198-1-git-send-email-neolynx@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

applications reading dvb files might want to
check crc, therefore provide the crc32 function
in the header files.

Signed-off-by: André Roth <neolynx@gmail.com>
---
 lib/{ => include}/libdvbv5/crc32.h |    0
 lib/libdvbv5/Makefile.am           |    1 +
 lib/libdvbv5/crc32.c               |    2 +-
 lib/libdvbv5/dvb-scan.c            |    2 +-
 4 files changed, 3 insertions(+), 2 deletions(-)
 rename lib/{ => include}/libdvbv5/crc32.h (100%)

diff --git a/lib/libdvbv5/crc32.h b/lib/include/libdvbv5/crc32.h
similarity index 100%
rename from lib/libdvbv5/crc32.h
rename to lib/include/libdvbv5/crc32.h
diff --git a/lib/libdvbv5/Makefile.am b/lib/libdvbv5/Makefile.am
index df67544..ce3f806 100644
--- a/lib/libdvbv5/Makefile.am
+++ b/lib/libdvbv5/Makefile.am
@@ -6,6 +6,7 @@ otherinclude_HEADERS = \
 	../include/libdvbv5/dvb-demux.h \
 	../include/libdvbv5/dvb-v5-std.h \
 	../include/libdvbv5/dvb-file.h \
+	../include/libdvbv5/crc32.h \
 	../include/libdvbv5/dvb-frontend.h \
 	../include/libdvbv5/dvb-fe.h \
 	../include/libdvbv5/dvb-sat.h \
diff --git a/lib/libdvbv5/crc32.c b/lib/libdvbv5/crc32.c
index f14dbe1..69d0be3 100644
--- a/lib/libdvbv5/crc32.c
+++ b/lib/libdvbv5/crc32.c
@@ -19,7 +19,7 @@
  *
  */
 
-#include "crc32.h"
+#include <libdvbv5/crc32.h>
 
 static uint32_t crctab[256] = {
   0x00000000, 0x04c11db7, 0x09823b6e, 0x0d4326d9, 0x130476dc, 0x17c56b6b,
diff --git a/lib/libdvbv5/dvb-scan.c b/lib/libdvbv5/dvb-scan.c
index b0636b9..e522225 100644
--- a/lib/libdvbv5/dvb-scan.c
+++ b/lib/libdvbv5/dvb-scan.c
@@ -42,7 +42,7 @@
 #include <libdvbv5/dvb-frontend.h>
 #include <libdvbv5/descriptors.h>
 #include "parse_string.h"
-#include "crc32.h"
+#include <libdvbv5/crc32.h>
 #include <libdvbv5/dvb-fe.h>
 #include <libdvbv5/dvb-file.h>
 #include <libdvbv5/dvb-scan.h>
-- 
1.7.10.4

