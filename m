Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ed1-f46.google.com ([209.85.208.46]:34033 "EHLO
        mail-ed1-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753358AbeGGLVJ (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Sat, 7 Jul 2018 07:21:09 -0400
Received: by mail-ed1-f46.google.com with SMTP id d3-v6so10474825edi.1
        for <linux-media@vger.kernel.org>; Sat, 07 Jul 2018 04:21:08 -0700 (PDT)
From: =?UTF-8?q?Andr=C3=A9=20Roth?= <neolynx@gmail.com>
To: linux-media@vger.kernel.org
Cc: =?UTF-8?q?Andr=C3=A9=20Roth?= <neolynx@gmail.com>
Subject: [PATCH 1/4] libdvbv5: do not adjust DVB time daylight saving
Date: Sat,  7 Jul 2018 13:20:54 +0200
Message-Id: <20180707112057.7235-1-neolynx@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This makes dvb_time available outside of EIT parsing, and
struct tm to reflect the actual values received from DVB.

Signed-off-by: André Roth <neolynx@gmail.com>
---
 lib/include/libdvbv5/descriptors.h | 11 +++++++++++
 lib/include/libdvbv5/eit.h         | 10 ----------
 lib/libdvbv5/descriptors.c         | 37 +++++++++++++++++++++++++++++++++++++
 lib/libdvbv5/tables/eit.c          | 28 ----------------------------
 4 files changed, 48 insertions(+), 38 deletions(-)

diff --git a/lib/include/libdvbv5/descriptors.h b/lib/include/libdvbv5/descriptors.h
index cb21470c..31f4c73f 100644
--- a/lib/include/libdvbv5/descriptors.h
+++ b/lib/include/libdvbv5/descriptors.h
@@ -47,6 +47,7 @@
 #include <unistd.h>
 #include <stdint.h>
 #include <arpa/inet.h>
+#include <time.h>
 
 /**
  * @brief Maximum size of a table session to be parsed
@@ -159,6 +160,16 @@ uint32_t dvb_bcd(uint32_t bcd);
 void dvb_hexdump(struct dvb_v5_fe_parms *parms, const char *prefix,
 		 const unsigned char *buf, int len);
 
+/**
+ * @brief Converts a DVB formatted timestamp into struct tm
+ * @ingroup dvb_table
+ *
+ * @param data		event on DVB time format
+ * @param tm		pointer to struct tm where the converted timestamp will
+ *			be stored.
+ */
+void dvb_time(const uint8_t data[5], struct tm *tm);
+
 /**
  * @brief parse MPEG-TS descriptors
  * @ingroup dvb_table
diff --git a/lib/include/libdvbv5/eit.h b/lib/include/libdvbv5/eit.h
index 9129861e..5af266b1 100644
--- a/lib/include/libdvbv5/eit.h
+++ b/lib/include/libdvbv5/eit.h
@@ -209,16 +209,6 @@ void dvb_table_eit_free(struct dvb_table_eit *table);
 void dvb_table_eit_print(struct dvb_v5_fe_parms *parms,
 			 struct dvb_table_eit *table);
 
-/**
- * @brief Converts a DVB EIT formatted timestamp into struct tm
- * @ingroup dvb_table
- *
- * @param data		event on DVB EIT time format
- * @param tm		pointer to struct tm where the converted timestamp will
- *			be stored.
- */
-void dvb_time(const uint8_t data[5], struct tm *tm);
-
 #ifdef __cplusplus
 }
 #endif
diff --git a/lib/libdvbv5/descriptors.c b/lib/libdvbv5/descriptors.c
index 0683dc1b..ccec503c 100644
--- a/lib/libdvbv5/descriptors.c
+++ b/lib/libdvbv5/descriptors.c
@@ -56,6 +56,14 @@
 #include <libdvbv5/desc_ca_identifier.h>
 #include <libdvbv5/desc_extension.h>
 
+#ifdef ENABLE_NLS
+# include "gettext.h"
+# include <libintl.h>
+# define _(string) dgettext(LIBDVBV5_DOMAIN, string)
+#else
+# define _(string) string
+#endif
+
 static void dvb_desc_init(uint8_t type, uint8_t length, struct dvb_desc *desc)
 {
 	desc->type   = type;
@@ -1391,3 +1399,32 @@ void dvb_hexdump(struct dvb_v5_fe_parms *parms, const char *prefix, const unsign
 		dvb_loginfo("%s%s %s %s", prefix, hex, spaces, ascii);
 	}
 }
+
+void dvb_time(const uint8_t data[5], struct tm *tm)
+{
+  /* ETSI EN 300 468 V1.4.1 */
+  int year, month, day, hour, min, sec;
+  int k = 0;
+  uint16_t mjd;
+
+  mjd   = *(uint16_t *) data;
+  hour  = dvb_bcd(data[2]);
+  min   = dvb_bcd(data[3]);
+  sec   = dvb_bcd(data[4]);
+  year  = ((mjd - 15078.2) / 365.25);
+  month = ((mjd - 14956.1 - (int) (year * 365.25)) / 30.6001);
+  day   = mjd - 14956 - (int) (year * 365.25) - (int) (month * 30.6001);
+  if (month == 14 || month == 15) k = 1;
+  year += k;
+  month = month - 1 - k * 12;
+
+  tm->tm_sec   = sec;
+  tm->tm_min   = min;
+  tm->tm_hour  = hour;
+  tm->tm_mday  = day;
+  tm->tm_mon   = month - 1;
+  tm->tm_year  = year;
+  tm->tm_isdst = -1; /* do not adjust */
+  mktime( tm );
+}
+
diff --git a/lib/libdvbv5/tables/eit.c b/lib/libdvbv5/tables/eit.c
index a6ba566a..799e4c9a 100644
--- a/lib/libdvbv5/tables/eit.c
+++ b/lib/libdvbv5/tables/eit.c
@@ -154,34 +154,6 @@ void dvb_table_eit_print(struct dvb_v5_fe_parms *parms, struct dvb_table_eit *ei
 	dvb_loginfo("|_  %d events", events);
 }
 
-void dvb_time(const uint8_t data[5], struct tm *tm)
-{
-  /* ETSI EN 300 468 V1.4.1 */
-  int year, month, day, hour, min, sec;
-  int k = 0;
-  uint16_t mjd;
-
-  mjd   = *(uint16_t *) data;
-  hour  = dvb_bcd(data[2]);
-  min   = dvb_bcd(data[3]);
-  sec   = dvb_bcd(data[4]);
-  year  = ((mjd - 15078.2) / 365.25);
-  month = ((mjd - 14956.1 - (int) (year * 365.25)) / 30.6001);
-  day   = mjd - 14956 - (int) (year * 365.25) - (int) (month * 30.6001);
-  if (month == 14 || month == 15) k = 1;
-  year += k;
-  month = month - 1 - k * 12;
-
-  tm->tm_sec   = sec;
-  tm->tm_min   = min;
-  tm->tm_hour  = hour;
-  tm->tm_mday  = day;
-  tm->tm_mon   = month - 1;
-  tm->tm_year  = year;
-  tm->tm_isdst = 1; /* dst in effect, do not adjust */
-  mktime( tm );
-}
-
 
 const char *dvb_eit_running_status_name[8] = {
 	[0] = "Undefined",
-- 
2.14.1
