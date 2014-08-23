Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-we0-f173.google.com ([74.125.82.173]:56894 "EHLO
	mail-we0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751213AbaHWQnG (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 23 Aug 2014 12:43:06 -0400
Received: by mail-we0-f173.google.com with SMTP id q58so11781894wes.32
        for <linux-media@vger.kernel.org>; Sat, 23 Aug 2014 09:43:04 -0700 (PDT)
From: Gregor Jasny <gjasny@googlemail.com>
To: linux-media@vger.kernel.org
Cc: m.chehab@samsung.com, Gregor Jasny <gjasny@googlemail.com>
Subject: [PATCH 2/5] libdvbv5: Rename and hide charset definitions
Date: Sat, 23 Aug 2014 18:42:40 +0200
Message-Id: <1408812163-18309-3-git-send-email-gjasny@googlemail.com>
In-Reply-To: <1408812163-18309-1-git-send-email-gjasny@googlemail.com>
References: <1408812163-18309-1-git-send-email-gjasny@googlemail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Gregor Jasny <gjasny@googlemail.com>
---
 lib/include/libdvbv5/descriptors.h             | 2 --
 lib/libdvbv5/descriptors.c                     | 3 ---
 lib/libdvbv5/descriptors/desc_event_extended.c | 2 +-
 lib/libdvbv5/descriptors/desc_event_short.c    | 4 ++--
 lib/libdvbv5/descriptors/desc_network_name.c   | 2 +-
 lib/libdvbv5/descriptors/desc_service.c        | 4 ++--
 lib/libdvbv5/descriptors/desc_ts_info.c        | 2 +-
 lib/libdvbv5/parse_string.c                    | 3 +++
 lib/libdvbv5/parse_string.h                    | 3 +++
 lib/libdvbv5/tables/vct.c                      | 2 +-
 10 files changed, 14 insertions(+), 13 deletions(-)

diff --git a/lib/include/libdvbv5/descriptors.h b/lib/include/libdvbv5/descriptors.h
index 88b8ad2..47738d8 100644
--- a/lib/include/libdvbv5/descriptors.h
+++ b/lib/include/libdvbv5/descriptors.h
@@ -38,8 +38,6 @@ struct dvb_v5_fe_parms;
 typedef void (*dvb_table_init_func)(struct dvb_v5_fe_parms *parms, const uint8_t *buf, ssize_t buflen, void **table);
 
 extern const dvb_table_init_func dvb_table_initializers[256];
-extern char *default_charset;
-extern char *output_charset;
 
 #define bswap16(b) do {\
 	b = ntohs(b); \
diff --git a/lib/libdvbv5/descriptors.c b/lib/libdvbv5/descriptors.c
index 5f61332..8e7ebb1 100644
--- a/lib/libdvbv5/descriptors.c
+++ b/lib/libdvbv5/descriptors.c
@@ -96,9 +96,6 @@ const dvb_table_init_func dvb_table_initializers[256] = {
 	[ATSC_TABLE_CVCT]        = TABLE_INIT(atsc_table_vct),
 };
 
-char *default_charset = "iso-8859-1";
-char *output_charset = "utf-8";
-
 int dvb_desc_parse(struct dvb_v5_fe_parms *parms, const uint8_t *buf,
 			   uint16_t buflen, struct dvb_desc **head_desc)
 {
diff --git a/lib/libdvbv5/descriptors/desc_event_extended.c b/lib/libdvbv5/descriptors/desc_event_extended.c
index 6af38f2..71e747a 100644
--- a/lib/libdvbv5/descriptors/desc_event_extended.c
+++ b/lib/libdvbv5/descriptors/desc_event_extended.c
@@ -59,7 +59,7 @@ int dvb_desc_event_extended_init(struct dvb_v5_fe_parms *parms, const uint8_t *b
 	len = *buf;
 	len1 = len;
 	buf++;
-	parse_string(parms, &event->text, &event->text_emph, buf, len1, default_charset, output_charset);
+	parse_string(parms, &event->text, &event->text_emph, buf, len1, dvb_default_charset, dvb_output_charset);
 	buf += len;
 	return 0;
 }
diff --git a/lib/libdvbv5/descriptors/desc_event_short.c b/lib/libdvbv5/descriptors/desc_event_short.c
index adb38fe..9b19269 100644
--- a/lib/libdvbv5/descriptors/desc_event_short.c
+++ b/lib/libdvbv5/descriptors/desc_event_short.c
@@ -42,7 +42,7 @@ int dvb_desc_event_short_init(struct dvb_v5_fe_parms *parms, const uint8_t *buf,
 	len = buf[0];
 	buf++;
 	len1 = len;
-	parse_string(parms, &event->name, &event->name_emph, buf, len1, default_charset, output_charset);
+	parse_string(parms, &event->name, &event->name_emph, buf, len1, dvb_default_charset, dvb_output_charset);
 	buf += len;
 
 	event->text = NULL;
@@ -50,7 +50,7 @@ int dvb_desc_event_short_init(struct dvb_v5_fe_parms *parms, const uint8_t *buf,
 	len = buf[0];
 	len2 = len;
 	buf++;
-	parse_string(parms, &event->text, &event->text_emph, buf, len2, default_charset, output_charset);
+	parse_string(parms, &event->text, &event->text_emph, buf, len2, dvb_default_charset, dvb_output_charset);
 	buf += len;
 	return 0;
 }
diff --git a/lib/libdvbv5/descriptors/desc_network_name.c b/lib/libdvbv5/descriptors/desc_network_name.c
index a34a27f..17cdbd4 100644
--- a/lib/libdvbv5/descriptors/desc_network_name.c
+++ b/lib/libdvbv5/descriptors/desc_network_name.c
@@ -33,7 +33,7 @@ int dvb_desc_network_name_init(struct dvb_v5_fe_parms *parms, const uint8_t *buf
 	len1 = len;
 	net->network_name = NULL;
 	net->network_name_emph = NULL;
-	parse_string(parms, &net->network_name, &net->network_name_emph, buf, len1, default_charset, output_charset);
+	parse_string(parms, &net->network_name, &net->network_name_emph, buf, len1, dvb_default_charset, dvb_output_charset);
 	buf += len;
 	return 0;
 }
diff --git a/lib/libdvbv5/descriptors/desc_service.c b/lib/libdvbv5/descriptors/desc_service.c
index 069317a..6858c32 100644
--- a/lib/libdvbv5/descriptors/desc_service.c
+++ b/lib/libdvbv5/descriptors/desc_service.c
@@ -37,7 +37,7 @@ int dvb_desc_service_init(struct dvb_v5_fe_parms *parms, const uint8_t *buf, str
 	len = buf[0];
 	buf++;
 	len1 = len;
-	parse_string(parms, &service->provider, &service->provider_emph, buf, len1, default_charset, output_charset);
+	parse_string(parms, &service->provider, &service->provider_emph, buf, len1, dvb_default_charset, dvb_output_charset);
 	buf += len;
 
 	service->name = NULL;
@@ -45,7 +45,7 @@ int dvb_desc_service_init(struct dvb_v5_fe_parms *parms, const uint8_t *buf, str
 	len = buf[0];
 	len2 = len;
 	buf++;
-	parse_string(parms, &service->name, &service->name_emph, buf, len2, default_charset, output_charset);
+	parse_string(parms, &service->name, &service->name_emph, buf, len2, dvb_default_charset, dvb_output_charset);
 	buf += len;
 	return 0;
 }
diff --git a/lib/libdvbv5/descriptors/desc_ts_info.c b/lib/libdvbv5/descriptors/desc_ts_info.c
index 75501af..713c1b8 100644
--- a/lib/libdvbv5/descriptors/desc_ts_info.c
+++ b/lib/libdvbv5/descriptors/desc_ts_info.c
@@ -40,7 +40,7 @@ int dvb_desc_ts_info_init(struct dvb_v5_fe_parms *parms,
 	d->ts_name = NULL;
 	d->ts_name_emph = NULL;
 	parse_string(parms, &d->ts_name, &d->ts_name_emph, buf, len,
-		     default_charset, output_charset);
+		     dvb_default_charset, dvb_output_charset);
 	p += len;
 
 	memcpy(&d->transmission_type, p, sizeof(d->transmission_type));
diff --git a/lib/libdvbv5/parse_string.c b/lib/libdvbv5/parse_string.c
index 0e94cf2..db47c3a 100644
--- a/lib/libdvbv5/parse_string.c
+++ b/lib/libdvbv5/parse_string.c
@@ -35,6 +35,9 @@
 
 #define CS_OPTIONS "//TRANSLIT"
 
+char *dvb_default_charset = "iso-8859-1";
+char *dvb_output_charset = "utf-8";
+
 struct charset_conv {
 	unsigned len;
 	unsigned char  data[3];
diff --git a/lib/libdvbv5/parse_string.h b/lib/libdvbv5/parse_string.h
index 39f7dc4..e269ff3 100644
--- a/lib/libdvbv5/parse_string.h
+++ b/lib/libdvbv5/parse_string.h
@@ -34,6 +34,9 @@ void parse_string(struct dvb_v5_fe_parms *parms, char **dest, char **emph,
 		  const unsigned char *src, size_t len,
 		  char *default_charset, char *output_charset);
 
+extern char *dvb_default_charset;
+extern char *dvb_output_charset;
+
 #if HAVE_VISIBILITY
 #pragma GCC visibility pop
 #endif
diff --git a/lib/libdvbv5/tables/vct.c b/lib/libdvbv5/tables/vct.c
index e761a7d..73bae63 100644
--- a/lib/libdvbv5/tables/vct.c
+++ b/lib/libdvbv5/tables/vct.c
@@ -101,7 +101,7 @@ ssize_t atsc_table_vct_init(struct dvb_v5_fe_parms *parms, const uint8_t *buf,
 				 (const unsigned char *)channel->__short_name,
 				 sizeof(channel->__short_name),
 				 "UTF-16",
-				 output_charset);
+				 dvb_output_charset);
 
 		/* Fill descriptors */
 
-- 
2.1.0

