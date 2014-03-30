Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ee0-f54.google.com ([74.125.83.54]:59638 "EHLO
	mail-ee0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751746AbaC3QVz (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 30 Mar 2014 12:21:55 -0400
Received: by mail-ee0-f54.google.com with SMTP id d49so5840734eek.13
        for <linux-media@vger.kernel.org>; Sun, 30 Mar 2014 09:21:54 -0700 (PDT)
From: =?UTF-8?q?Andr=C3=A9=20Roth?= <neolynx@gmail.com>
To: linux-media@vger.kernel.org
Cc: =?UTF-8?q?Andr=C3=A9=20Roth?= <neolynx@gmail.com>
Subject: [PATCH 4/8] libdvbv5: allow table parsers to get specific pointer to table struct
Date: Sun, 30 Mar 2014 18:21:14 +0200
Message-Id: <1396196478-996-4-git-send-email-neolynx@gmail.com>
In-Reply-To: <1396196478-996-1-git-send-email-neolynx@gmail.com>
References: <1396196478-996-1-git-send-email-neolynx@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

this will allow simplifying the parser functions and
to return the number of bytes read or an error code.

Signed-off-by: André Roth <neolynx@gmail.com>
---
 lib/include/libdvbv5/atsc_eit.h     |  2 +-
 lib/include/libdvbv5/cat.h          |  2 +-
 lib/include/libdvbv5/descriptors.h  |  2 +-
 lib/include/libdvbv5/eit.h          |  2 +-
 lib/include/libdvbv5/mgt.h          |  2 +-
 lib/include/libdvbv5/nit.h          |  2 +-
 lib/include/libdvbv5/pat.h          |  2 +-
 lib/include/libdvbv5/pmt.h          |  2 +-
 lib/include/libdvbv5/sdt.h          |  2 +-
 lib/include/libdvbv5/vct.h          |  2 +-
 lib/libdvbv5/descriptors.c          | 24 +++++++++++++-----------
 lib/libdvbv5/descriptors/atsc_eit.c | 17 ++++++++++-------
 lib/libdvbv5/descriptors/cat.c      | 14 ++++++++------
 lib/libdvbv5/descriptors/eit.c      |  5 +++--
 lib/libdvbv5/descriptors/mgt.c      | 16 ++++++++++------
 lib/libdvbv5/descriptors/nit.c      | 23 ++++++++++++-----------
 lib/libdvbv5/descriptors/pat.c      | 13 +++++++------
 lib/libdvbv5/descriptors/pmt.c      | 10 +++++-----
 lib/libdvbv5/descriptors/sdt.c      | 10 ++++++----
 lib/libdvbv5/descriptors/vct.c      | 13 +++++++------
 20 files changed, 91 insertions(+), 74 deletions(-)

diff --git a/lib/include/libdvbv5/atsc_eit.h b/lib/include/libdvbv5/atsc_eit.h
index 0c0d830..c527b1d 100644
--- a/lib/include/libdvbv5/atsc_eit.h
+++ b/lib/include/libdvbv5/atsc_eit.h
@@ -78,7 +78,7 @@ struct dvb_v5_fe_parms;
 extern "C" {
 #endif
 
-void atsc_table_eit_init (struct dvb_v5_fe_parms *parms, const uint8_t *buf, ssize_t buflen, uint8_t *table, ssize_t *table_length);
+ssize_t atsc_table_eit_init (struct dvb_v5_fe_parms *parms, const uint8_t *buf, ssize_t buflen, struct atsc_table_eit *eit, ssize_t *table_length);
 void atsc_table_eit_free(struct atsc_table_eit *eit);
 void atsc_table_eit_print(struct dvb_v5_fe_parms *parms, struct atsc_table_eit *eit);
 void atsc_time(const uint32_t start_time, struct tm *tm);
diff --git a/lib/include/libdvbv5/cat.h b/lib/include/libdvbv5/cat.h
index 4c442a8..df1e417 100644
--- a/lib/include/libdvbv5/cat.h
+++ b/lib/include/libdvbv5/cat.h
@@ -40,7 +40,7 @@ struct dvb_v5_fe_parms;
 extern "C" {
 #endif
 
-void dvb_table_cat_init (struct dvb_v5_fe_parms *parms, const uint8_t *buf, ssize_t buflen, uint8_t *table, ssize_t *table_length);
+ssize_t dvb_table_cat_init (struct dvb_v5_fe_parms *parms, const uint8_t *buf, ssize_t buflen, struct dvb_table_cat *cat, ssize_t *table_length);
 void dvb_table_cat_free(struct dvb_table_cat *cat);
 void dvb_table_cat_print(struct dvb_v5_fe_parms *parms, struct dvb_table_cat *t);
 
diff --git a/lib/include/libdvbv5/descriptors.h b/lib/include/libdvbv5/descriptors.h
index 1ea0957..cc67a38 100644
--- a/lib/include/libdvbv5/descriptors.h
+++ b/lib/include/libdvbv5/descriptors.h
@@ -35,7 +35,7 @@
 
 struct dvb_v5_fe_parms;
 
-typedef void (*dvb_table_init_func)(struct dvb_v5_fe_parms *parms, const uint8_t *buf, ssize_t buflen, uint8_t *table, ssize_t *table_length);
+typedef void (*dvb_table_init_func)(struct dvb_v5_fe_parms *parms, const uint8_t *buf, ssize_t buflen, void *table, ssize_t *table_length);
 
 struct dvb_table_init {
 	dvb_table_init_func init;
diff --git a/lib/include/libdvbv5/eit.h b/lib/include/libdvbv5/eit.h
index 62e070d..fb5ce33 100644
--- a/lib/include/libdvbv5/eit.h
+++ b/lib/include/libdvbv5/eit.h
@@ -79,7 +79,7 @@ extern const char *dvb_eit_running_status_name[8];
 extern "C" {
 #endif
 
-void dvb_table_eit_init (struct dvb_v5_fe_parms *parms, const uint8_t *buf, ssize_t buflen, uint8_t *table, ssize_t *table_length);
+ssize_t dvb_table_eit_init (struct dvb_v5_fe_parms *parms, const uint8_t *buf, ssize_t buflen, struct dvb_table_eit *eit, ssize_t *table_length);
 void dvb_table_eit_free(struct dvb_table_eit *eit);
 void dvb_table_eit_print(struct dvb_v5_fe_parms *parms, struct dvb_table_eit *eit);
 void dvb_time(const uint8_t data[5], struct tm *tm);
diff --git a/lib/include/libdvbv5/mgt.h b/lib/include/libdvbv5/mgt.h
index 346cbb5..4ea905d 100644
--- a/lib/include/libdvbv5/mgt.h
+++ b/lib/include/libdvbv5/mgt.h
@@ -68,7 +68,7 @@ struct dvb_v5_fe_parms;
 extern "C" {
 #endif
 
-void atsc_table_mgt_init (struct dvb_v5_fe_parms *parms, const uint8_t *buf, ssize_t buflen, uint8_t *table, ssize_t *table_length);
+ssize_t atsc_table_mgt_init (struct dvb_v5_fe_parms *parms, const uint8_t *buf, ssize_t buflen, struct atsc_table_mgt *mgt, ssize_t *table_length);
 void atsc_table_mgt_free(struct atsc_table_mgt *mgt);
 void atsc_table_mgt_print(struct dvb_v5_fe_parms *parms, struct atsc_table_mgt *mgt);
 
diff --git a/lib/include/libdvbv5/nit.h b/lib/include/libdvbv5/nit.h
index af57931..7477bd6 100644
--- a/lib/include/libdvbv5/nit.h
+++ b/lib/include/libdvbv5/nit.h
@@ -85,7 +85,7 @@ struct dvb_v5_fe_parms;
 extern "C" {
 #endif
 
-void dvb_table_nit_init (struct dvb_v5_fe_parms *parms, const uint8_t *buf, ssize_t buflen, uint8_t *table, ssize_t *table_length);
+ssize_t dvb_table_nit_init (struct dvb_v5_fe_parms *parms, const uint8_t *buf, ssize_t buflen, struct dvb_table_nit *nit, ssize_t *table_length);
 void dvb_table_nit_free(struct dvb_table_nit *nit);
 void dvb_table_nit_print(struct dvb_v5_fe_parms *parms, struct dvb_table_nit *nit);
 
diff --git a/lib/include/libdvbv5/pat.h b/lib/include/libdvbv5/pat.h
index 4c1fd4d..cd99d3e 100644
--- a/lib/include/libdvbv5/pat.h
+++ b/lib/include/libdvbv5/pat.h
@@ -57,7 +57,7 @@ struct dvb_v5_fe_parms;
 extern "C" {
 #endif
 
-void dvb_table_pat_init (struct dvb_v5_fe_parms *parms, const uint8_t *buf, ssize_t buflen, uint8_t *table, ssize_t *table_length);
+ssize_t dvb_table_pat_init (struct dvb_v5_fe_parms *parms, const uint8_t *buf, ssize_t buflen, struct dvb_table_pat *pat, ssize_t *table_length);
 void dvb_table_pat_free(struct dvb_table_pat *pat);
 void dvb_table_pat_print(struct dvb_v5_fe_parms *parms, struct dvb_table_pat *t);
 
diff --git a/lib/include/libdvbv5/pmt.h b/lib/include/libdvbv5/pmt.h
index e6273f0..432a458 100644
--- a/lib/include/libdvbv5/pmt.h
+++ b/lib/include/libdvbv5/pmt.h
@@ -112,7 +112,7 @@ struct dvb_v5_fe_parms;
 extern "C" {
 #endif
 
-void dvb_table_pmt_init (struct dvb_v5_fe_parms *parms, const uint8_t *buf, ssize_t buflen, uint8_t *table, ssize_t *table_length);
+ssize_t dvb_table_pmt_init (struct dvb_v5_fe_parms *parms, const uint8_t *buf, ssize_t buflen, struct dvb_table_pmt *pmt, ssize_t *table_length);
 void dvb_table_pmt_free(struct dvb_table_pmt *pmt);
 void dvb_table_pmt_print(struct dvb_v5_fe_parms *parms, const struct dvb_table_pmt *pmt);
 
diff --git a/lib/include/libdvbv5/sdt.h b/lib/include/libdvbv5/sdt.h
index 2b3e8e0..f1503ea 100644
--- a/lib/include/libdvbv5/sdt.h
+++ b/lib/include/libdvbv5/sdt.h
@@ -65,7 +65,7 @@ struct dvb_v5_fe_parms;
 extern "C" {
 #endif
 
-void dvb_table_sdt_init (struct dvb_v5_fe_parms *parms, const uint8_t *buf, ssize_t buflen, uint8_t *table, ssize_t *table_length);
+ssize_t dvb_table_sdt_init (struct dvb_v5_fe_parms *parms, const uint8_t *buf, ssize_t buflen, struct dvb_table_sdt *sdt, ssize_t *table_lengh);
 void dvb_table_sdt_free(struct dvb_table_sdt *sdt);
 void dvb_table_sdt_print(struct dvb_v5_fe_parms *parms, struct dvb_table_sdt *sdt);
 
diff --git a/lib/include/libdvbv5/vct.h b/lib/include/libdvbv5/vct.h
index fd7b845..6d41ac5 100644
--- a/lib/include/libdvbv5/vct.h
+++ b/lib/include/libdvbv5/vct.h
@@ -115,7 +115,7 @@ struct dvb_v5_fe_parms;
 extern "C" {
 #endif
 
-void atsc_table_vct_init (struct dvb_v5_fe_parms *parms, const uint8_t *buf, ssize_t buflen, uint8_t *table, ssize_t *table_length);
+ssize_t atsc_table_vct_init (struct dvb_v5_fe_parms *parms, const uint8_t *buf, ssize_t buflen, struct atsc_table_vct *vct, ssize_t *table_length);
 void atsc_table_vct_free(struct atsc_table_vct *vct);
 void atsc_table_vct_print(struct dvb_v5_fe_parms *parms, struct atsc_table_vct *vct);
 
diff --git a/lib/libdvbv5/descriptors.c b/lib/libdvbv5/descriptors.c
index 86bc7af..22fb7c4 100644
--- a/lib/libdvbv5/descriptors.c
+++ b/lib/libdvbv5/descriptors.c
@@ -78,18 +78,20 @@ static void dvb_desc_default_print(struct dvb_v5_fe_parms *parms, const struct d
 	hexdump(parms, "|           ", desc->data, desc->length);
 }
 
+#define TABLE_INIT( _x ) { (dvb_table_init_func) _x##_init, sizeof(struct _x) }
+
 const struct dvb_table_init dvb_table_initializers[] = {
-	[DVB_TABLE_PAT]          = { dvb_table_pat_init, sizeof(struct dvb_table_pat) },
-	[DVB_TABLE_CAT]          = { dvb_table_cat_init, sizeof(struct dvb_table_cat) },
-	[DVB_TABLE_PMT]          = { dvb_table_pmt_init, sizeof(struct dvb_table_pmt) },
-	[DVB_TABLE_NIT]          = { dvb_table_nit_init, sizeof(struct dvb_table_nit) },
-	[DVB_TABLE_SDT]          = { dvb_table_sdt_init, sizeof(struct dvb_table_sdt) },
-	[DVB_TABLE_EIT]          = { dvb_table_eit_init, sizeof(struct dvb_table_eit) },
-	[DVB_TABLE_EIT_SCHEDULE] = { dvb_table_eit_init, sizeof(struct dvb_table_eit) },
-	[ATSC_TABLE_MGT]         = { atsc_table_mgt_init, sizeof(struct atsc_table_mgt) },
-	[ATSC_TABLE_EIT]         = { atsc_table_eit_init, sizeof(struct atsc_table_eit) },
-	[ATSC_TABLE_TVCT]        = { atsc_table_vct_init, sizeof(struct atsc_table_vct) },
-	[ATSC_TABLE_CVCT]        = { atsc_table_vct_init, sizeof(struct atsc_table_vct) },
+	[DVB_TABLE_PAT]          = TABLE_INIT(dvb_table_pat),
+	[DVB_TABLE_CAT]          = TABLE_INIT(dvb_table_cat),
+	[DVB_TABLE_PMT]          = TABLE_INIT(dvb_table_pmt),
+	[DVB_TABLE_NIT]          = TABLE_INIT(dvb_table_nit),
+	[DVB_TABLE_SDT]          = TABLE_INIT(dvb_table_sdt),
+	[DVB_TABLE_EIT]          = TABLE_INIT(dvb_table_eit),
+	[DVB_TABLE_EIT_SCHEDULE] = TABLE_INIT(dvb_table_eit),
+	[ATSC_TABLE_MGT]         = TABLE_INIT(atsc_table_mgt),
+	[ATSC_TABLE_EIT]         = TABLE_INIT(atsc_table_eit),
+	[ATSC_TABLE_TVCT]        = TABLE_INIT(atsc_table_vct),
+	[ATSC_TABLE_CVCT]        = TABLE_INIT(atsc_table_vct),
 };
 
 char *default_charset = "iso-8859-1";
diff --git a/lib/libdvbv5/descriptors/atsc_eit.c b/lib/libdvbv5/descriptors/atsc_eit.c
index 86a7b11..92764df 100644
--- a/lib/libdvbv5/descriptors/atsc_eit.c
+++ b/lib/libdvbv5/descriptors/atsc_eit.c
@@ -21,10 +21,10 @@
 #include <libdvbv5/atsc_eit.h>
 #include <libdvbv5/dvb-fe.h>
 
-void atsc_table_eit_init(struct dvb_v5_fe_parms *parms, const uint8_t *buf, ssize_t buflen, uint8_t *table, ssize_t *table_length)
+ssize_t atsc_table_eit_init(struct dvb_v5_fe_parms *parms, const uint8_t *buf,
+		ssize_t buflen, struct atsc_table_eit *eit, ssize_t *table_length)
 {
 	const uint8_t *p = buf, *endbuf = buf + buflen - 4; /* minus CRC */;
-	struct atsc_table_eit *eit = (struct atsc_table_eit *) table;
 	struct atsc_table_eit_event **head;
 	int i = 0;
 	struct atsc_table_eit_event *last = NULL;
@@ -33,7 +33,7 @@ void atsc_table_eit_init(struct dvb_v5_fe_parms *parms, const uint8_t *buf, ssiz
 	if (p + size > endbuf) {
 		dvb_logerr("%s: short read %zd/%zd bytes", __func__,
 			   size, endbuf - p);
-		return;
+		return -1;
 	}
 
 	if (*table_length > 0) {
@@ -60,7 +60,7 @@ void atsc_table_eit_init(struct dvb_v5_fe_parms *parms, const uint8_t *buf, ssiz
 		if (p + size > endbuf) {
 			dvb_logerr("%s: short read %zd/%zd bytes", __func__,
 				   size, endbuf - p);
-			return;
+			return -2;
 		}
 		event = (struct atsc_table_eit_event *) malloc(sizeof(struct atsc_table_eit_event));
 		memcpy(event, p, size);
@@ -78,7 +78,7 @@ void atsc_table_eit_init(struct dvb_v5_fe_parms *parms, const uint8_t *buf, ssiz
 		if (p + size > endbuf) {
 			dvb_logerr("%s: short read %zd/%zd bytes", __func__,
 				   size, endbuf - p);
-			return;
+			return -3;
 		}
                 /* TODO: parse title */
                 p += size;
@@ -93,7 +93,7 @@ void atsc_table_eit_init(struct dvb_v5_fe_parms *parms, const uint8_t *buf, ssiz
 		if (p + size > endbuf) {
 			dvb_logerr("%s: short read %zd/%zd bytes", __func__,
 				   size, endbuf - p);
-			return;
+			return -4;
 		}
 		memcpy(&dl, p, size);
                 p += size;
@@ -103,13 +103,16 @@ void atsc_table_eit_init(struct dvb_v5_fe_parms *parms, const uint8_t *buf, ssiz
 		if (p + size > endbuf) {
 			dvb_logerr("%s: short read %zd/%zd bytes", __func__,
 				   size, endbuf - p);
-			return;
+			return -5;
 		}
 		dvb_parse_descriptors(parms, p, size, &event->descriptor);
 
 		p += size;
 		last = event;
 	}
+
+	*table_length = p - buf;
+	return p - buf;
 }
 
 void atsc_table_eit_free(struct atsc_table_eit *eit)
diff --git a/lib/libdvbv5/descriptors/cat.c b/lib/libdvbv5/descriptors/cat.c
index 20376de..b7e51e2 100644
--- a/lib/libdvbv5/descriptors/cat.c
+++ b/lib/libdvbv5/descriptors/cat.c
@@ -22,10 +22,9 @@
 #include <libdvbv5/descriptors.h>
 #include <libdvbv5/dvb-fe.h>
 
-void dvb_table_cat_init(struct dvb_v5_fe_parms *parms, const uint8_t *buf,
-			ssize_t buflen, uint8_t *table, ssize_t *table_length)
+ssize_t dvb_table_cat_init(struct dvb_v5_fe_parms *parms, const uint8_t *buf,
+			ssize_t buflen, struct dvb_table_cat *cat, ssize_t *table_length)
 {
-	struct dvb_table_cat *cat = (void *)table;
 	struct dvb_desc **head_desc = &cat->descriptor;
 	const uint8_t *p = buf, *endbuf = buf + buflen - 4;
 	size_t size;
@@ -33,7 +32,7 @@ void dvb_table_cat_init(struct dvb_v5_fe_parms *parms, const uint8_t *buf,
 	if (buf[0] != DVB_TABLE_CAT) {
 		dvb_logerr("%s: invalid marker 0x%02x, sould be 0x%02x", __func__, buf[0], DVB_TABLE_CAT);
 		*table_length = 0;
-		return;
+		return -1;
 	}
 
 	if (*table_length > 0) {
@@ -46,15 +45,18 @@ void dvb_table_cat_init(struct dvb_v5_fe_parms *parms, const uint8_t *buf,
 	if (p + size > endbuf) {
 		dvb_logerr("CAT table was truncated while filling dvb_table_cat. Need %zu bytes, but has only %zu.",
 			   size, buflen);
-		return;
+		return -2;
 	}
 
-	memcpy(table, p, size);
+	memcpy(cat, p, size);
 	p += size;
 	*table_length = sizeof(struct dvb_table_cat);
 
 	size = endbuf - p;
 	dvb_parse_descriptors(parms, p, size, head_desc);
+
+	*table_length = p - buf;
+	return p - buf;
 }
 
 void dvb_table_cat_free(struct dvb_table_cat *cat)
diff --git a/lib/libdvbv5/descriptors/eit.c b/lib/libdvbv5/descriptors/eit.c
index 1b64e29..86e2905 100644
--- a/lib/libdvbv5/descriptors/eit.c
+++ b/lib/libdvbv5/descriptors/eit.c
@@ -22,10 +22,9 @@
 #include <libdvbv5/eit.h>
 #include <libdvbv5/dvb-fe.h>
 
-void dvb_table_eit_init(struct dvb_v5_fe_parms *parms, const uint8_t *buf, ssize_t buflen, uint8_t *table, ssize_t *table_length)
+ssize_t dvb_table_eit_init(struct dvb_v5_fe_parms *parms, const uint8_t *buf, ssize_t buflen, struct dvb_table_eit *eit, ssize_t *table_length)
 {
 	const uint8_t *p = buf;
-	struct dvb_table_eit *eit = (struct dvb_table_eit *) table;
 	struct dvb_table_eit_event **head;
 
 	if (*table_length > 0) {
@@ -90,6 +89,8 @@ void dvb_table_eit_init(struct dvb_v5_fe_parms *parms, const uint8_t *buf, ssize
 		p += event->section_length;
 		last = event;
 	}
+	*table_length = p - buf;
+	return p - buf;
 }
 
 void dvb_table_eit_free(struct dvb_table_eit *eit)
diff --git a/lib/libdvbv5/descriptors/mgt.c b/lib/libdvbv5/descriptors/mgt.c
index ba57c84..b445294 100644
--- a/lib/libdvbv5/descriptors/mgt.c
+++ b/lib/libdvbv5/descriptors/mgt.c
@@ -21,10 +21,10 @@
 #include <libdvbv5/mgt.h>
 #include <libdvbv5/dvb-fe.h>
 
-void atsc_table_mgt_init(struct dvb_v5_fe_parms *parms, const uint8_t *buf, ssize_t buflen, uint8_t *table, ssize_t *table_length)
+ssize_t atsc_table_mgt_init(struct dvb_v5_fe_parms *parms, const uint8_t *buf,
+		ssize_t buflen, struct atsc_table_mgt *mgt, ssize_t *table_length)
 {
 	const uint8_t *p = buf, *endbuf = buf + buflen - 4; /* minus CRC */
-	struct atsc_table_mgt *mgt = (struct atsc_table_mgt *) table;
 	struct dvb_desc **head_desc;
 	struct atsc_table_mgt_table **head;
 	int i = 0;
@@ -34,7 +34,7 @@ void atsc_table_mgt_init(struct dvb_v5_fe_parms *parms, const uint8_t *buf, ssiz
 	if (p + size > endbuf) {
 		dvb_logerr("%s: short read %zd/%zd bytes", __func__,
 			   size, endbuf - p);
-		return;
+		return -1;
 	}
 
 	if (*table_length > 0) {
@@ -48,7 +48,7 @@ void atsc_table_mgt_init(struct dvb_v5_fe_parms *parms, const uint8_t *buf, ssiz
 
 		/* FIXME: read current mgt->tables for loop below */
 	} else {
-		memcpy(table, p, size);
+		memcpy(mgt, p, size);
 		*table_length = sizeof(struct atsc_table_mgt);
 
 		bswap16(mgt->tables);
@@ -67,7 +67,7 @@ void atsc_table_mgt_init(struct dvb_v5_fe_parms *parms, const uint8_t *buf, ssiz
 		if (p + size > endbuf) {
 			dvb_logerr("%s: short read %zd/%zd bytes", __func__,
 				   size, endbuf - p);
-			return;
+			return -2;
 		}
 		table = (struct atsc_table_mgt_table *) malloc(sizeof(struct atsc_table_mgt_table));
 		memcpy(table, p, size);
@@ -90,14 +90,18 @@ void atsc_table_mgt_init(struct dvb_v5_fe_parms *parms, const uint8_t *buf, ssiz
 		if (p + size > endbuf) {
 			dvb_logerr("%s: short read %zd/%zd bytes", __func__,
 				   size, endbuf - p);
-			return;
+			return -3;
 		}
 		dvb_parse_descriptors(parms, p, size, &table->descriptor);
 
 		p += size;
 		last = table;
 	}
+
 	/* TODO: parse MGT descriptors here into head_desc */
+
+	*table_length = p - buf;
+	return p - buf;
 }
 
 void atsc_table_mgt_free(struct atsc_table_mgt *mgt)
diff --git a/lib/libdvbv5/descriptors/nit.c b/lib/libdvbv5/descriptors/nit.c
index 1c08f0e..7749ee1 100644
--- a/lib/libdvbv5/descriptors/nit.c
+++ b/lib/libdvbv5/descriptors/nit.c
@@ -22,11 +22,10 @@
 #include <libdvbv5/nit.h>
 #include <libdvbv5/dvb-fe.h>
 
-void dvb_table_nit_init(struct dvb_v5_fe_parms *parms, const uint8_t *buf,
-			ssize_t buflen, uint8_t *table, ssize_t *table_length)
+ssize_t dvb_table_nit_init(struct dvb_v5_fe_parms *parms, const uint8_t *buf,
+			ssize_t buflen, struct dvb_table_nit *nit, ssize_t *table_length)
 {
 	const uint8_t *p = buf, *endbuf = buf + buflen - 4;
-	struct dvb_table_nit *nit = (void *)table;
 	struct dvb_desc **head_desc = &nit->descriptor;
 	struct dvb_table_nit_transport **head = &nit->transport;
 	size_t size;
@@ -43,7 +42,7 @@ void dvb_table_nit_init(struct dvb_v5_fe_parms *parms, const uint8_t *buf,
 		size = offsetof(struct dvb_table_nit, descriptor);
 		if (p + size > endbuf) {
 			dvb_logerr("NIT table (cont) was truncated");
-			return;
+			return -1;
 		}
 		p += size;
 		t = (struct dvb_table_nit *)buf;
@@ -55,9 +54,9 @@ void dvb_table_nit_init(struct dvb_v5_fe_parms *parms, const uint8_t *buf,
 		if (p + size > endbuf) {
 			dvb_logerr("NIT table was truncated while filling dvb_table_nit. Need %zu bytes, but has only %zu.",
 				   size, buflen);
-			return;
+			return -2;
 		}
-		memcpy(table, p, size);
+		memcpy(nit, p, size);
 		p += size;
 
 		*table_length = sizeof(struct dvb_table_nit);
@@ -71,7 +70,7 @@ void dvb_table_nit_init(struct dvb_v5_fe_parms *parms, const uint8_t *buf,
 	if (p + size > endbuf) {
 		dvb_logerr("NIT table was truncated while getting NIT descriptors. Need %zu bytes, but has only %zu.",
 			   size, endbuf - p);
-		return;
+		return -3;
 	}
 	dvb_parse_descriptors(parms, p, size, head_desc);
 	p += size;
@@ -80,7 +79,7 @@ void dvb_table_nit_init(struct dvb_v5_fe_parms *parms, const uint8_t *buf,
 	if (p + size > endbuf) {
 		dvb_logerr("NIT table was truncated while getting NIT transports. Need %zu bytes, but has only %zu.",
 			   size, endbuf - p);
-		return;
+		return -4;
 	}
 	p += size;
 
@@ -90,8 +89,8 @@ void dvb_table_nit_init(struct dvb_v5_fe_parms *parms, const uint8_t *buf,
 
 		transport = malloc(sizeof(struct dvb_table_nit_transport));
 		if (!transport) {
-			dvb_perror("Out of memory");
-			return;
+			dvb_perror(__func__);
+			return -5;
 		}
 		memcpy(transport, p, size);
 		p += size;
@@ -111,7 +110,7 @@ void dvb_table_nit_init(struct dvb_v5_fe_parms *parms, const uint8_t *buf,
 		if (p + transport->section_length > endbuf) {
 			dvb_logerr("NIT table was truncated while getting NIT transport descriptors. Need %u bytes, but has only %zu.",
 				   transport->section_length, endbuf - p);
-			return;
+			return -6;
 		}
 		dvb_parse_descriptors(parms, p, transport->section_length, head_desc);
 		p += transport->section_length;
@@ -119,6 +118,8 @@ void dvb_table_nit_init(struct dvb_v5_fe_parms *parms, const uint8_t *buf,
 	if (endbuf - p)
 		dvb_logerr("NIT table has %zu spurious bytes at the end.",
 			   endbuf - p);
+	*table_length = p - buf;
+	return p - buf;
 }
 
 void dvb_table_nit_free(struct dvb_table_nit *nit)
diff --git a/lib/libdvbv5/descriptors/pat.c b/lib/libdvbv5/descriptors/pat.c
index ac5b5d4..1bb7781 100644
--- a/lib/libdvbv5/descriptors/pat.c
+++ b/lib/libdvbv5/descriptors/pat.c
@@ -23,10 +23,9 @@
 #include <libdvbv5/descriptors.h>
 #include <libdvbv5/dvb-fe.h>
 
-void dvb_table_pat_init(struct dvb_v5_fe_parms *parms, const uint8_t *buf,
-			ssize_t buflen, uint8_t *table, ssize_t *table_length)
+ssize_t dvb_table_pat_init(struct dvb_v5_fe_parms *parms, const uint8_t *buf,
+			ssize_t buflen, struct dvb_table_pat *pat, ssize_t *table_length)
 {
-	struct dvb_table_pat *pat = (void *)table;
 	struct dvb_table_pat_program **head = &pat->program;
 	const uint8_t *p = buf, *endbuf = buf + buflen - 4;
 	size_t size;
@@ -40,9 +39,9 @@ void dvb_table_pat_init(struct dvb_v5_fe_parms *parms, const uint8_t *buf,
 		if (p + size > endbuf) {
 			dvb_logerr("PAT table was truncated. Need %zu bytes, but has only %zu.",
 					size, buflen);
-			return;
+			return -1;
 		}
-		memcpy(table, buf, size);
+		memcpy(pat, buf, size);
 		p += size;
 		pat->programs = 0;
 		pat->program = NULL;
@@ -56,7 +55,7 @@ void dvb_table_pat_init(struct dvb_v5_fe_parms *parms, const uint8_t *buf,
 		pgm = malloc(sizeof(struct dvb_table_pat_program));
 		if (!pgm) {
 			dvb_perror("Out of memory");
-			return;
+			return -2;
 		}
 
 		memcpy(pgm, p, size);
@@ -74,6 +73,8 @@ void dvb_table_pat_init(struct dvb_v5_fe_parms *parms, const uint8_t *buf,
 	if (endbuf - p)
 		dvb_logerr("PAT table has %zu spurious bytes at the end.",
 			   endbuf - p);
+	*table_length = p - buf;
+	return p - buf;
 }
 
 void dvb_table_pat_free(struct dvb_table_pat *pat)
diff --git a/lib/libdvbv5/descriptors/pmt.c b/lib/libdvbv5/descriptors/pmt.c
index c0af2d4..52bfa29 100644
--- a/lib/libdvbv5/descriptors/pmt.c
+++ b/lib/libdvbv5/descriptors/pmt.c
@@ -25,18 +25,17 @@
 
 #include <string.h> /* memcpy */
 
-void dvb_table_pmt_init(struct dvb_v5_fe_parms *parms, const uint8_t *buf,
-			ssize_t buflen, uint8_t *table, ssize_t *table_length)
+ssize_t dvb_table_pmt_init(struct dvb_v5_fe_parms *parms, const uint8_t *buf,
+			ssize_t buflen, struct dvb_table_pmt *pmt, ssize_t *table_length)
 {
 	const uint8_t *p = buf, *endbuf = buf + buflen - 4;
-	struct dvb_table_pmt *pmt = (void *)table;
 	struct dvb_table_pmt_stream **head = &pmt->stream;
 	size_t size;
 
 	if (buf[0] != DVB_TABLE_PMT) {
 		dvb_logerr("%s: invalid marker 0x%02x, sould be 0x%02x", __func__, buf[0], DVB_TABLE_PMT);
 		*table_length = 0;
-		return;
+		return -1;
 	}
 
 	if (*table_length > 0) {
@@ -48,7 +47,7 @@ void dvb_table_pmt_init(struct dvb_v5_fe_parms *parms, const uint8_t *buf,
 		if (p + size > endbuf) {
 			dvb_logerr("%s: short read %zd/%zd bytes", __func__,
 				   size, endbuf - p);
-			return;
+			return -2;
 		}
 		memcpy(pmt, p, size);
 		p += size;
@@ -109,6 +108,7 @@ void dvb_table_pmt_init(struct dvb_v5_fe_parms *parms, const uint8_t *buf,
 			   __func__, endbuf - p);
 
 	*table_length = p - buf;
+	return p - buf;
 }
 
 void dvb_table_pmt_free(struct dvb_table_pmt *pmt)
diff --git a/lib/libdvbv5/descriptors/sdt.c b/lib/libdvbv5/descriptors/sdt.c
index 5c354f1..4fb6826 100644
--- a/lib/libdvbv5/descriptors/sdt.c
+++ b/lib/libdvbv5/descriptors/sdt.c
@@ -22,11 +22,10 @@
 #include <libdvbv5/sdt.h>
 #include <libdvbv5/dvb-fe.h>
 
-void dvb_table_sdt_init(struct dvb_v5_fe_parms *parms, const uint8_t *buf,
-			ssize_t buflen, uint8_t *table, ssize_t *table_length)
+ssize_t dvb_table_sdt_init(struct dvb_v5_fe_parms *parms, const uint8_t *buf,
+			ssize_t buflen, struct dvb_table_sdt *sdt, ssize_t *table_length)
 {
 	const uint8_t *p = buf, *endbuf = buf + buflen - 4;
-	struct dvb_table_sdt *sdt = (void *)table;
 	struct dvb_table_sdt_service **head = &sdt->service;
 	size_t size = offsetof(struct dvb_table_sdt, service);
 
@@ -38,7 +37,7 @@ void dvb_table_sdt_init(struct dvb_v5_fe_parms *parms, const uint8_t *buf,
 		if (p + size > endbuf) {
 			dvb_logerr("SDT table was truncated. Need %zu bytes, but has only %zu.",
 					size, buflen);
-			return;
+			return -1;
 		}
 		memcpy(sdt, p, size);
 		*table_length = sizeof(struct dvb_table_sdt);
@@ -75,6 +74,9 @@ void dvb_table_sdt_init(struct dvb_v5_fe_parms *parms, const uint8_t *buf,
 	if (endbuf - p)
 		dvb_logerr("SDT table has %zu spurious bytes at the end.",
 			   endbuf - p);
+
+	*table_length = p - buf;
+	return p - buf;
 }
 
 void dvb_table_sdt_free(struct dvb_table_sdt *sdt)
diff --git a/lib/libdvbv5/descriptors/vct.c b/lib/libdvbv5/descriptors/vct.c
index 0f051ac..8606d7e 100644
--- a/lib/libdvbv5/descriptors/vct.c
+++ b/lib/libdvbv5/descriptors/vct.c
@@ -23,11 +23,10 @@
 #include <libdvbv5/dvb-fe.h>
 #include <parse_string.h>
 
-void atsc_table_vct_init(struct dvb_v5_fe_parms *parms, const uint8_t *buf,
-			ssize_t buflen, uint8_t *table, ssize_t *table_length)
+ssize_t atsc_table_vct_init(struct dvb_v5_fe_parms *parms, const uint8_t *buf,
+			ssize_t buflen, struct atsc_table_vct *vct, ssize_t *table_length)
 {
 	const uint8_t *p = buf, *endbuf = buf + buflen - 4;
-	struct atsc_table_vct *vct = (void *)table;
 	struct atsc_table_vct_channel **head = &vct->channel;
 	int i, n;
 	size_t size = offsetof(struct atsc_table_vct, channel);
@@ -35,7 +34,7 @@ void atsc_table_vct_init(struct dvb_v5_fe_parms *parms, const uint8_t *buf,
 	if (p + size > endbuf) {
 		dvb_logerr("VCT table was truncated. Need %zu bytes, but has only %zu.",
 			   size, buflen);
-		return;
+		return -1;
 	}
 
 	if (*table_length > 0) {
@@ -99,7 +98,7 @@ void atsc_table_vct_init(struct dvb_v5_fe_parms *parms, const uint8_t *buf,
 		if (endbuf - p < channel->descriptors_length) {
 			dvb_logerr("%s: short read %d/%zd bytes", __func__,
 				   channel->descriptors_length, endbuf - p);
-			return;
+			return -2;
 		}
 
 		/* get the descriptors for each program */
@@ -118,7 +117,7 @@ void atsc_table_vct_init(struct dvb_v5_fe_parms *parms, const uint8_t *buf,
 		if (endbuf - p < d->descriptor_length) {
 			dvb_logerr("%s: short read %d/%zd bytes", __func__,
 				   d->descriptor_length, endbuf - p);
-			return;
+			return -3;
 		}
 		dvb_parse_descriptors(parms, p, d->descriptor_length,
 				      &vct->descriptor);
@@ -126,6 +125,8 @@ void atsc_table_vct_init(struct dvb_v5_fe_parms *parms, const uint8_t *buf,
 	if (endbuf - p)
 		dvb_logerr("VCT table has %zu spurious bytes at the end.",
 			   endbuf - p);
+	*table_length = p - buf;
+	return p - buf;
 }
 
 void atsc_table_vct_free(struct atsc_table_vct *vct)
-- 
1.8.3.2

