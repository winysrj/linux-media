Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ee0-f49.google.com ([74.125.83.49]:55521 "EHLO
	mail-ee0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754669AbaDOSl2 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 15 Apr 2014 14:41:28 -0400
Received: by mail-ee0-f49.google.com with SMTP id c41so7960844eek.8
        for <linux-media@vger.kernel.org>; Tue, 15 Apr 2014 11:41:26 -0700 (PDT)
From: =?UTF-8?q?Andr=C3=A9=20Roth?= <neolynx@gmail.com>
To: linux-media@vger.kernel.org
Cc: =?UTF-8?q?Andr=C3=A9=20Roth?= <neolynx@gmail.com>
Subject: [PATCH 2/4] libdvbv5: cleanup parser API
Date: Tue, 15 Apr 2014 20:39:31 +0200
Message-Id: <1397587173-1120-2-git-send-email-neolynx@gmail.com>
In-Reply-To: <1397587173-1120-1-git-send-email-neolynx@gmail.com>
References: <1397587173-1120-1-git-send-email-neolynx@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

- fix initialization of dvb_table_initializers
- check return value of dvb_desc_parse
- allocate table inside the parser
- remove unneeded table_length argument

Signed-off-by: André Roth <neolynx@gmail.com>
---
 lib/include/libdvbv5/atsc_eit.h    |  2 +-
 lib/include/libdvbv5/cat.h         |  2 +-
 lib/include/libdvbv5/descriptors.h | 18 ++---------
 lib/include/libdvbv5/eit.h         |  2 +-
 lib/include/libdvbv5/mgt.h         |  2 +-
 lib/include/libdvbv5/nit.h         |  2 +-
 lib/include/libdvbv5/pat.h         |  2 +-
 lib/include/libdvbv5/pmt.h         |  2 +-
 lib/include/libdvbv5/sdt.h         |  2 +-
 lib/include/libdvbv5/vct.h         |  2 +-
 lib/libdvbv5/descriptors.c         |  5 ++--
 lib/libdvbv5/dvb-scan.c            | 27 ++++-------------
 lib/libdvbv5/tables/atsc_eit.c     | 44 ++++++++++++++-------------
 lib/libdvbv5/tables/cat.c          | 28 +++++++++--------
 lib/libdvbv5/tables/eit.c          | 42 +++++++++++++-------------
 lib/libdvbv5/tables/mgt.c          | 54 ++++++++++++++++-----------------
 lib/libdvbv5/tables/nit.c          | 61 +++++++++++++++++---------------------
 lib/libdvbv5/tables/pat.c          | 31 ++++++++++---------
 lib/libdvbv5/tables/pmt.c          | 52 +++++++++++++++-----------------
 lib/libdvbv5/tables/sdt.c          | 36 +++++++++++-----------
 lib/libdvbv5/tables/vct.c          | 47 ++++++++++++++++-------------
 21 files changed, 219 insertions(+), 244 deletions(-)

diff --git a/lib/include/libdvbv5/atsc_eit.h b/lib/include/libdvbv5/atsc_eit.h
index 93d9304..5116a3d 100644
--- a/lib/include/libdvbv5/atsc_eit.h
+++ b/lib/include/libdvbv5/atsc_eit.h
@@ -77,7 +77,7 @@ struct dvb_v5_fe_parms;
 extern "C" {
 #endif
 
-ssize_t atsc_table_eit_init (struct dvb_v5_fe_parms *parms, const uint8_t *buf, ssize_t buflen, struct atsc_table_eit *eit, ssize_t *table_length);
+ssize_t atsc_table_eit_init (struct dvb_v5_fe_parms *parms, const uint8_t *buf, ssize_t buflen, struct atsc_table_eit **table);
 void atsc_table_eit_free(struct atsc_table_eit *eit);
 void atsc_table_eit_print(struct dvb_v5_fe_parms *parms, struct atsc_table_eit *eit);
 void atsc_time(const uint32_t start_time, struct tm *tm);
diff --git a/lib/include/libdvbv5/cat.h b/lib/include/libdvbv5/cat.h
index df1e417..134e3e5 100644
--- a/lib/include/libdvbv5/cat.h
+++ b/lib/include/libdvbv5/cat.h
@@ -40,7 +40,7 @@ struct dvb_v5_fe_parms;
 extern "C" {
 #endif
 
-ssize_t dvb_table_cat_init (struct dvb_v5_fe_parms *parms, const uint8_t *buf, ssize_t buflen, struct dvb_table_cat *cat, ssize_t *table_length);
+ssize_t dvb_table_cat_init (struct dvb_v5_fe_parms *parms, const uint8_t *buf, ssize_t buflen, struct dvb_table_cat **table);
 void dvb_table_cat_free(struct dvb_table_cat *cat);
 void dvb_table_cat_print(struct dvb_v5_fe_parms *parms, struct dvb_table_cat *t);
 
diff --git a/lib/include/libdvbv5/descriptors.h b/lib/include/libdvbv5/descriptors.h
index 8b38977..66197f6 100644
--- a/lib/include/libdvbv5/descriptors.h
+++ b/lib/include/libdvbv5/descriptors.h
@@ -36,14 +36,9 @@
 
 struct dvb_v5_fe_parms;
 
-typedef void (*dvb_table_init_func)(struct dvb_v5_fe_parms *parms, const uint8_t *buf, ssize_t buflen, void *table, ssize_t *table_length);
+typedef void (*dvb_table_init_func)(struct dvb_v5_fe_parms *parms, const uint8_t *buf, ssize_t buflen, void **table);
 
-struct dvb_table_init {
-	dvb_table_init_func init;
-	ssize_t size;
-};
-
-extern const struct dvb_table_init dvb_table_initializers[];
+extern const dvb_table_init_func dvb_table_initializers[256];
 extern char *default_charset;
 extern char *output_charset;
 
@@ -106,15 +101,6 @@ struct dvb_descriptor {
 
 extern const struct dvb_descriptor dvb_descriptors[];
 
-enum dvb_tables {
-	PAT,
-	PMT,
-	NIT,
-	SDT,
-	TVCT,
-	CVCT,
-};
-
 enum descriptors {
 	/* ISO/IEC 13818-1 */
 	video_stream_descriptor				= 0x02,
diff --git a/lib/include/libdvbv5/eit.h b/lib/include/libdvbv5/eit.h
index c959537..97fbf36 100644
--- a/lib/include/libdvbv5/eit.h
+++ b/lib/include/libdvbv5/eit.h
@@ -78,7 +78,7 @@ extern const char *dvb_eit_running_status_name[8];
 extern "C" {
 #endif
 
-ssize_t dvb_table_eit_init (struct dvb_v5_fe_parms *parms, const uint8_t *buf, ssize_t buflen, struct dvb_table_eit *eit, ssize_t *table_length);
+ssize_t dvb_table_eit_init (struct dvb_v5_fe_parms *parms, const uint8_t *buf, ssize_t buflen, struct dvb_table_eit **table);
 void dvb_table_eit_free(struct dvb_table_eit *eit);
 void dvb_table_eit_print(struct dvb_v5_fe_parms *parms, struct dvb_table_eit *eit);
 void dvb_time(const uint8_t data[5], struct tm *tm);
diff --git a/lib/include/libdvbv5/mgt.h b/lib/include/libdvbv5/mgt.h
index d67ad33..eb4403e 100644
--- a/lib/include/libdvbv5/mgt.h
+++ b/lib/include/libdvbv5/mgt.h
@@ -67,7 +67,7 @@ struct dvb_v5_fe_parms;
 extern "C" {
 #endif
 
-ssize_t atsc_table_mgt_init (struct dvb_v5_fe_parms *parms, const uint8_t *buf, ssize_t buflen, struct atsc_table_mgt *mgt, ssize_t *table_length);
+ssize_t atsc_table_mgt_init (struct dvb_v5_fe_parms *parms, const uint8_t *buf, ssize_t buflen, struct atsc_table_mgt **table);
 void atsc_table_mgt_free(struct atsc_table_mgt *mgt);
 void atsc_table_mgt_print(struct dvb_v5_fe_parms *parms, struct atsc_table_mgt *mgt);
 
diff --git a/lib/include/libdvbv5/nit.h b/lib/include/libdvbv5/nit.h
index fdea7a7..63ffcd5 100644
--- a/lib/include/libdvbv5/nit.h
+++ b/lib/include/libdvbv5/nit.h
@@ -85,7 +85,7 @@ struct dvb_v5_fe_parms;
 extern "C" {
 #endif
 
-ssize_t dvb_table_nit_init (struct dvb_v5_fe_parms *parms, const uint8_t *buf, ssize_t buflen, struct dvb_table_nit *nit, ssize_t *table_length);
+ssize_t dvb_table_nit_init (struct dvb_v5_fe_parms *parms, const uint8_t *buf, ssize_t buflen, struct dvb_table_nit **table);
 void dvb_table_nit_free(struct dvb_table_nit *nit);
 void dvb_table_nit_print(struct dvb_v5_fe_parms *parms, struct dvb_table_nit *nit);
 
diff --git a/lib/include/libdvbv5/pat.h b/lib/include/libdvbv5/pat.h
index eb4aeef..a2180d5 100644
--- a/lib/include/libdvbv5/pat.h
+++ b/lib/include/libdvbv5/pat.h
@@ -57,7 +57,7 @@ struct dvb_v5_fe_parms;
 extern "C" {
 #endif
 
-ssize_t dvb_table_pat_init (struct dvb_v5_fe_parms *parms, const uint8_t *buf, ssize_t buflen, struct dvb_table_pat *pat, ssize_t *table_length);
+ssize_t dvb_table_pat_init (struct dvb_v5_fe_parms *parms, const uint8_t *buf, ssize_t buflen, struct dvb_table_pat **table);
 void dvb_table_pat_free(struct dvb_table_pat *pat);
 void dvb_table_pat_print(struct dvb_v5_fe_parms *parms, struct dvb_table_pat *t);
 
diff --git a/lib/include/libdvbv5/pmt.h b/lib/include/libdvbv5/pmt.h
index 432a458..150b45a 100644
--- a/lib/include/libdvbv5/pmt.h
+++ b/lib/include/libdvbv5/pmt.h
@@ -112,7 +112,7 @@ struct dvb_v5_fe_parms;
 extern "C" {
 #endif
 
-ssize_t dvb_table_pmt_init (struct dvb_v5_fe_parms *parms, const uint8_t *buf, ssize_t buflen, struct dvb_table_pmt *pmt, ssize_t *table_length);
+ssize_t dvb_table_pmt_init (struct dvb_v5_fe_parms *parms, const uint8_t *buf, ssize_t buflen, struct dvb_table_pmt **table);
 void dvb_table_pmt_free(struct dvb_table_pmt *pmt);
 void dvb_table_pmt_print(struct dvb_v5_fe_parms *parms, const struct dvb_table_pmt *pmt);
 
diff --git a/lib/include/libdvbv5/sdt.h b/lib/include/libdvbv5/sdt.h
index 9684fbc..8455080 100644
--- a/lib/include/libdvbv5/sdt.h
+++ b/lib/include/libdvbv5/sdt.h
@@ -64,7 +64,7 @@ struct dvb_v5_fe_parms;
 extern "C" {
 #endif
 
-ssize_t dvb_table_sdt_init (struct dvb_v5_fe_parms *parms, const uint8_t *buf, ssize_t buflen, struct dvb_table_sdt *sdt, ssize_t *table_lengh);
+ssize_t dvb_table_sdt_init (struct dvb_v5_fe_parms *parms, const uint8_t *buf, ssize_t buflen, struct dvb_table_sdt **table);
 void dvb_table_sdt_free(struct dvb_table_sdt *sdt);
 void dvb_table_sdt_print(struct dvb_v5_fe_parms *parms, struct dvb_table_sdt *sdt);
 
diff --git a/lib/include/libdvbv5/vct.h b/lib/include/libdvbv5/vct.h
index 10ac301..383c5b1 100644
--- a/lib/include/libdvbv5/vct.h
+++ b/lib/include/libdvbv5/vct.h
@@ -114,7 +114,7 @@ struct dvb_v5_fe_parms;
 extern "C" {
 #endif
 
-ssize_t atsc_table_vct_init (struct dvb_v5_fe_parms *parms, const uint8_t *buf, ssize_t buflen, struct atsc_table_vct *vct, ssize_t *table_length);
+ssize_t atsc_table_vct_init (struct dvb_v5_fe_parms *parms, const uint8_t *buf, ssize_t buflen, struct atsc_table_vct **table);
 void atsc_table_vct_free(struct atsc_table_vct *vct);
 void atsc_table_vct_print(struct dvb_v5_fe_parms *parms, struct atsc_table_vct *vct);
 
diff --git a/lib/libdvbv5/descriptors.c b/lib/libdvbv5/descriptors.c
index c2b0293..bfbf529 100644
--- a/lib/libdvbv5/descriptors.c
+++ b/lib/libdvbv5/descriptors.c
@@ -79,9 +79,10 @@ static void dvb_desc_default_print(struct dvb_v5_fe_parms *parms, const struct d
 	hexdump(parms, "|           ", desc->data, desc->length);
 }
 
-#define TABLE_INIT( _x ) { (dvb_table_init_func) _x##_init, sizeof(struct _x) }
+#define TABLE_INIT(_x) (dvb_table_init_func) _x##_init
 
-const struct dvb_table_init dvb_table_initializers[] = {
+const dvb_table_init_func dvb_table_initializers[256] = {
+	[0 ... 255]              = NULL,
 	[DVB_TABLE_PAT]          = TABLE_INIT(dvb_table_pat),
 	[DVB_TABLE_CAT]          = TABLE_INIT(dvb_table_cat),
 	[DVB_TABLE_PMT]          = TABLE_INIT(dvb_table_pmt),
diff --git a/lib/libdvbv5/dvb-scan.c b/lib/libdvbv5/dvb-scan.c
index 68c0551..5cd38f8 100644
--- a/lib/libdvbv5/dvb-scan.c
+++ b/lib/libdvbv5/dvb-scan.c
@@ -129,7 +129,6 @@ struct dvb_table_filter_priv {
 	unsigned long is_read_bits[BITS_TO_LONGS(256)];
 
 	/* section gaps and multiple ts_id handling */
-	ssize_t table_length;
 	int first_ts_id;
 	int first_section;
 	int done;
@@ -141,7 +140,8 @@ static int dvb_parse_section_alloc(struct dvb_v5_fe_parms *parms,
 	struct dvb_table_filter_priv *priv;
 
 	if (!sect->table) {
-		dvb_logerr("table memory pointer not filled");
+		dvb_logerr("%s: table memory pointer not filled",
+				__func__);
 		return -4;
 	}
 	*sect->table = NULL;
@@ -173,7 +173,6 @@ static int dvb_parse_section(struct dvb_v5_fe_parms *parms,
 	struct dvb_table_header *h;
 	struct dvb_table_filter_priv *priv;
 
-	uint8_t *tbl = NULL;
 	unsigned char tid;
 
 	h = (struct dvb_table_header *)buf;
@@ -222,27 +221,13 @@ static int dvb_parse_section(struct dvb_v5_fe_parms *parms,
 	if (!sect->allow_section_gaps && sect->ts_id != -1)
 		set_bit(h->section_id, priv->is_read_bits);
 
-	tbl = *sect->table;
-	if (!tbl) {
-		if (!dvb_table_initializers[tid].size) {
-			dvb_logerr("%s: no table size for table %d",
-					__func__, tid);
-			return -1;
-		}
-
-		tbl = calloc(dvb_table_initializers[tid].size, 1);
-	}
-
-	if (dvb_table_initializers[tid].init)
-		dvb_table_initializers[tid].init(parms, buf, buf_length,
-						 tbl, &priv->table_length);
+	if (dvb_table_initializers[tid])
+		dvb_table_initializers[tid](parms, buf, buf_length,
+						 sect->table);
 	else
 		dvb_logerr("%s: no initializer for table %d",
 			   __func__, tid);
 
-	/* Store the table */
-	*sect->table = tbl;
-
 	if (!sect->allow_section_gaps && sect->ts_id != -1 &&
 			is_all_bits_set(priv->last_section, priv->is_read_bits))
 		priv->done = 1;
@@ -262,8 +247,6 @@ int dvb_read_sections(struct dvb_v5_fe_parms *parms, int dmx_fd,
 	uint8_t *buf = NULL;
 	uint8_t mask = 0xff;
 
-	/* FIXME: verify if all requested tables are known */
-
 	ret = dvb_parse_section_alloc(parms, sect);
 	if (ret < 0)
 		return ret;
diff --git a/lib/libdvbv5/tables/atsc_eit.c b/lib/libdvbv5/tables/atsc_eit.c
index 38f3810..83a495c 100644
--- a/lib/libdvbv5/tables/atsc_eit.c
+++ b/lib/libdvbv5/tables/atsc_eit.c
@@ -23,9 +23,10 @@
 #include <libdvbv5/dvb-fe.h>
 
 ssize_t atsc_table_eit_init(struct dvb_v5_fe_parms *parms, const uint8_t *buf,
-		ssize_t buflen, struct atsc_table_eit *eit, ssize_t *table_length)
+		ssize_t buflen, struct atsc_table_eit **table)
 {
 	const uint8_t *p = buf, *endbuf = buf + buflen - 4; /* minus CRC */;
+	struct atsc_table_eit *eit;
 	struct atsc_table_eit_event **head;
 	size_t size;
 	int i = 0;
@@ -43,21 +44,22 @@ ssize_t atsc_table_eit_init(struct dvb_v5_fe_parms *parms, const uint8_t *buf,
 		return -2;
 	}
 
-	if (*table_length > 0) {
-		memcpy(eit, p, size);
-
-		/* find end of curent list */
-		head = &eit->event;
-		while (*head != NULL)
-			head = &(*head)->next;
-	} else {
-		memcpy(eit, p, size);
-
-		eit->event = NULL;
-		head = &eit->event;
+	if (!*table) {
+		*table = calloc(sizeof(struct atsc_table_eit), 1);
+		if (!*table) {
+			dvb_logerr("%s: out of memory", __func__);
+			return -3;
+		}
 	}
+	eit = *table;
+	memcpy(eit, p, size);
 	p += size;
 
+	/* find end of curent list */
+	head = &eit->event;
+	while (*head != NULL)
+		head = &(*head)->next;
+
 	while (i++ < eit->events && p < endbuf) {
 		struct atsc_table_eit_event *event;
                 union atsc_table_eit_desc_length dl;
@@ -66,12 +68,12 @@ ssize_t atsc_table_eit_init(struct dvb_v5_fe_parms *parms, const uint8_t *buf,
 		if (p + size > endbuf) {
 			dvb_logerr("%s: short read %zd/%zd bytes", __func__,
 				   endbuf - p, size);
-			return -2;
+			return -4;
 		}
 		event = (struct atsc_table_eit_event *) malloc(sizeof(struct atsc_table_eit_event));
 		if (!event) {
 			dvb_logerr("%s: out of memory", __func__);
-			return -3;
+			return -5;
 		}
 		memcpy(event, p, size);
 		p += size;
@@ -91,7 +93,7 @@ ssize_t atsc_table_eit_init(struct dvb_v5_fe_parms *parms, const uint8_t *buf,
 		if (p + size > endbuf) {
 			dvb_logerr("%s: short read %zd/%zd bytes", __func__,
 				   endbuf - p, size);
-			return -3;
+			return -6;
 		}
                 /* TODO: parse title */
                 p += size;
@@ -101,7 +103,7 @@ ssize_t atsc_table_eit_init(struct dvb_v5_fe_parms *parms, const uint8_t *buf,
 		if (p + size > endbuf) {
 			dvb_logerr("%s: short read %zd/%zd bytes", __func__,
 				   endbuf - p, size);
-			return -4;
+			return -7;
 		}
 		memcpy(&dl, p, size);
                 p += size;
@@ -111,14 +113,16 @@ ssize_t atsc_table_eit_init(struct dvb_v5_fe_parms *parms, const uint8_t *buf,
 		if (p + size > endbuf) {
 			dvb_logerr("%s: short read %zd/%zd bytes", __func__,
 				   endbuf - p, size);
-			return -5;
+			return -8;
+		}
+		if (dvb_desc_parse(parms, p, size,
+					&event->descriptor) != 0 ) {
+			return -9;
 		}
-		dvb_desc_parse(parms, p, size, &event->descriptor);
 
 		p += size;
 	}
 
-	*table_length = p - buf;
 	return p - buf;
 }
 
diff --git a/lib/libdvbv5/tables/cat.c b/lib/libdvbv5/tables/cat.c
index 5acc88e..394eb3c 100644
--- a/lib/libdvbv5/tables/cat.c
+++ b/lib/libdvbv5/tables/cat.c
@@ -23,9 +23,10 @@
 #include <libdvbv5/dvb-fe.h>
 
 ssize_t dvb_table_cat_init(struct dvb_v5_fe_parms *parms, const uint8_t *buf,
-		ssize_t buflen, struct dvb_table_cat *cat, ssize_t *table_length)
+		ssize_t buflen, struct dvb_table_cat **table)
 {
 	const uint8_t *p = buf, *endbuf = buf + buflen - 4;
+	struct dvb_table_cat *cat;
 	struct dvb_desc **head_desc;
 	size_t size;
 
@@ -42,23 +43,27 @@ ssize_t dvb_table_cat_init(struct dvb_v5_fe_parms *parms, const uint8_t *buf,
 		return -2;
 	}
 
-	if (*table_length > 0) {
-		/* find end of current lists */
-		head_desc = &cat->descriptor;
-		while (*head_desc != NULL)
-			head_desc = &(*head_desc)->next;
-	} else {
-		head_desc = &cat->descriptor;
+	if (!*table) {
+		*table = calloc(sizeof(struct dvb_table_cat), 1);
+		if (!*table) {
+			dvb_logerr("%s: out of memory", __func__);
+			return -3;
+		}
 	}
-
+	cat = *table;
 	memcpy(cat, p, size);
 	p += size;
 
+	/* find end of current lists */
+	head_desc = &cat->descriptor;
+	while (*head_desc != NULL)
+		head_desc = &(*head_desc)->next;
+
 	size = cat->header.section_length + 3 - 4; /* plus header, minus CRC */
 	if (buf + size > endbuf) {
 		dvb_logerr("%s: short read %zd/%zd bytes", __func__,
 			   endbuf - buf, size);
-		return -3;
+		return -4;
 	}
 	endbuf = buf + size;
 
@@ -67,7 +72,7 @@ ssize_t dvb_table_cat_init(struct dvb_v5_fe_parms *parms, const uint8_t *buf,
 		uint16_t desc_length = endbuf - p;
 		if (dvb_desc_parse(parms, p, desc_length,
 				      head_desc) != 0) {
-			return -4;
+			return -5;
 		}
 		p += desc_length;
 	}
@@ -76,7 +81,6 @@ ssize_t dvb_table_cat_init(struct dvb_v5_fe_parms *parms, const uint8_t *buf,
 		dvb_logwarn("%s: %zu spurious bytes at the end",
 			   __func__, endbuf - p);
 
-	*table_length = p - buf;
 	return p - buf;
 }
 
diff --git a/lib/libdvbv5/tables/eit.c b/lib/libdvbv5/tables/eit.c
index 21f7897..1870722 100644
--- a/lib/libdvbv5/tables/eit.c
+++ b/lib/libdvbv5/tables/eit.c
@@ -23,9 +23,10 @@
 #include <libdvbv5/dvb-fe.h>
 
 ssize_t dvb_table_eit_init(struct dvb_v5_fe_parms *parms, const uint8_t *buf,
-		ssize_t buflen, struct dvb_table_eit *eit, ssize_t *table_length)
+		ssize_t buflen, struct dvb_table_eit **table)
 {
 	const uint8_t *p = buf, *endbuf = buf + buflen - 4; /* minus CRC */
+	struct dvb_table_eit *eit;
 	struct dvb_table_eit_event **head;
 	size_t size;
 
@@ -46,27 +47,25 @@ ssize_t dvb_table_eit_init(struct dvb_v5_fe_parms *parms, const uint8_t *buf,
 		return -2;
 	}
 
-	if (*table_length > 0) {
-		memcpy(eit, p, sizeof(struct dvb_table_eit) - sizeof(eit->event));
-
-		bswap16(eit->transport_id);
-		bswap16(eit->network_id);
-
-		/* find end of curent list */
-		head = &eit->event;
-		while (*head != NULL)
-			head = &(*head)->next;
-	} else {
-		memcpy(eit, p, sizeof(struct dvb_table_eit) - sizeof(eit->event));
-
-		bswap16(eit->transport_id);
-		bswap16(eit->network_id);
-
-		eit->event = NULL;
-		head = &eit->event;
+	if (!*table) {
+		*table = calloc(sizeof(struct dvb_table_eit), 1);
+		if (!*table) {
+			dvb_logerr("%s: out of memory", __func__);
+			return -3;
+		}
 	}
+	eit = *table;
+	memcpy(eit, p, size);
 	p += size;
 
+	bswap16(eit->transport_id);
+	bswap16(eit->network_id);
+
+	/* find end of curent list */
+	head = &eit->event;
+	while (*head != NULL)
+		head = &(*head)->next;
+
 	/* get the event entries */
 	size = offsetof(struct dvb_table_eit_event, descriptor);
 	while (p + size <= endbuf) {
@@ -75,7 +74,7 @@ ssize_t dvb_table_eit_init(struct dvb_v5_fe_parms *parms, const uint8_t *buf,
 		event = malloc(sizeof(struct dvb_table_eit_event));
 		if (!event) {
 			dvb_logerr("%s: out of memory", __func__);
-			return -3;
+			return -4;
 		}
 		memcpy(event, p, size);
 		p += size;
@@ -105,7 +104,7 @@ ssize_t dvb_table_eit_init(struct dvb_v5_fe_parms *parms, const uint8_t *buf,
 			}
 			if (dvb_desc_parse(parms, p, desc_length,
 					      &event->descriptor) != 0) {
-				return -4;
+				return -5;
 			}
 			p += desc_length;
 		}
@@ -113,7 +112,6 @@ ssize_t dvb_table_eit_init(struct dvb_v5_fe_parms *parms, const uint8_t *buf,
 	if (p < endbuf)
 		dvb_logwarn("%s: %zu spurious bytes at the end",
 			   __func__, endbuf - p);
-	*table_length = p - buf;
 	return p - buf;
 }
 
diff --git a/lib/libdvbv5/tables/mgt.c b/lib/libdvbv5/tables/mgt.c
index f32bc2d..bf77348 100644
--- a/lib/libdvbv5/tables/mgt.c
+++ b/lib/libdvbv5/tables/mgt.c
@@ -23,9 +23,10 @@
 #include <libdvbv5/dvb-fe.h>
 
 ssize_t atsc_table_mgt_init(struct dvb_v5_fe_parms *parms, const uint8_t *buf,
-		ssize_t buflen, struct atsc_table_mgt *mgt, ssize_t *table_length)
+		ssize_t buflen, struct atsc_table_mgt **table)
 {
 	const uint8_t *p = buf, *endbuf = buf + buflen - 4; /* minus CRC */
+	struct atsc_table_mgt *mgt;
 	struct atsc_table_mgt_table **head;
 	struct dvb_desc **head_desc;
 	size_t size;
@@ -44,30 +45,27 @@ ssize_t atsc_table_mgt_init(struct dvb_v5_fe_parms *parms, const uint8_t *buf,
 		return -2;
 	}
 
-	if (*table_length > 0) {
-		memcpy(mgt, p, size);
-
-		bswap16(mgt->tables);
-
-		/* find end of curent lists */
-		head_desc = &mgt->descriptor;
-		while (*head_desc != NULL)
-			head_desc = &(*head_desc)->next;
-		head = &mgt->table;
-		while (*head != NULL)
-			head = &(*head)->next;
-	} else {
-		memcpy(mgt, p, size);
-
-		bswap16(mgt->tables);
-
-		mgt->descriptor = NULL;
-		mgt->table = NULL;
-		head_desc = &mgt->descriptor;
-		head = &mgt->table;
+	if (!*table) {
+		*table = calloc(sizeof(struct atsc_table_mgt), 1);
+		if (!*table) {
+			dvb_logerr("%s: out of memory", __func__);
+			return -3;
+		}
 	}
+	mgt = *table;
+	memcpy(mgt, p, size);
 	p += size;
 
+	bswap16(mgt->tables);
+
+	/* find end of curent lists */
+	head_desc = &mgt->descriptor;
+	while (*head_desc != NULL)
+		head_desc = &(*head_desc)->next;
+	head = &mgt->table;
+	while (*head != NULL)
+		head = &(*head)->next;
+
 	while (i++ < mgt->tables && p < endbuf) {
 		struct atsc_table_mgt_table *table;
 
@@ -75,12 +73,12 @@ ssize_t atsc_table_mgt_init(struct dvb_v5_fe_parms *parms, const uint8_t *buf,
 		if (p + size > endbuf) {
 			dvb_logerr("%s: short read %zd/%zd bytes", __func__,
 				   endbuf - p, size);
-			return -2;
+			return -4;
 		}
 		table = (struct atsc_table_mgt_table *) malloc(sizeof(struct atsc_table_mgt_table));
 		if (!table) {
 			dvb_logerr("%s: out of memory", __func__);
-			return -3;
+			return -5;
 		}
 		memcpy(table, p, size);
 		p += size;
@@ -100,16 +98,18 @@ ssize_t atsc_table_mgt_init(struct dvb_v5_fe_parms *parms, const uint8_t *buf,
 		if (p + size > endbuf) {
 			dvb_logerr("%s: short read %zd/%zd bytes", __func__,
 				   endbuf - p, size);
-			return -3;
+			return -6;
+		}
+		if (dvb_desc_parse(parms, p, size,
+					&table->descriptor) != 0) {
+			return -7;
 		}
-		dvb_desc_parse(parms, p, size, &table->descriptor);
 
 		p += size;
 	}
 
 	/* TODO: parse MGT descriptors here into head_desc */
 
-	*table_length = p - buf;
 	return p - buf;
 }
 
diff --git a/lib/libdvbv5/tables/nit.c b/lib/libdvbv5/tables/nit.c
index 644a861..054b36b 100644
--- a/lib/libdvbv5/tables/nit.c
+++ b/lib/libdvbv5/tables/nit.c
@@ -23,9 +23,10 @@
 #include <libdvbv5/dvb-fe.h>
 
 ssize_t dvb_table_nit_init(struct dvb_v5_fe_parms *parms, const uint8_t *buf,
-			ssize_t buflen, struct dvb_table_nit *nit, ssize_t *table_length)
+			ssize_t buflen, struct dvb_table_nit **table)
 {
 	const uint8_t *p = buf, *endbuf = buf + buflen - 4;
+	struct dvb_table_nit *nit;
 	struct dvb_table_nit_transport **head;
 	struct dvb_desc **head_desc;
 	size_t size;
@@ -43,48 +44,43 @@ ssize_t dvb_table_nit_init(struct dvb_v5_fe_parms *parms, const uint8_t *buf,
 		return -2;
 	}
 
-	if (*table_length > 0) {
-		struct dvb_table_nit *t;
-
-		/* find end of current lists */
-		head_desc = &nit->descriptor;
-		while (*head_desc != NULL)
-			head_desc = &(*head_desc)->next;
-		head = &nit->transport;
-		while (*head != NULL)
-			head = &(*head)->next;
-
-		p += size;
-		t = (struct dvb_table_nit *)buf;
-
-		bswap16(t->bitfield);
-		size = t->desc_length;
-	} else {
-		memcpy(nit, p, size);
-		p += size;
+	if (!*table) {
+		*table = calloc(sizeof(struct dvb_table_nit), 1);
+		if (!*table) {
+			dvb_logerr("%s: out of memory", __func__);
+			return -3;
+		}
+	}
+	nit = *table;
+	memcpy(nit, p, size);
+	p += size;
 
-		head = &nit->transport;
+	bswap16(nit->bitfield);
 
-		nit->descriptor = NULL;
-		nit->transport = NULL;
+	/* find end of current lists */
+	head_desc = &nit->descriptor;
+	while (*head_desc != NULL)
+		head_desc = &(*head_desc)->next;
+	head = &nit->transport;
+	while (*head != NULL)
+		head = &(*head)->next;
 
-		bswap16(nit->bitfield);
-		size = nit->desc_length;
-		head_desc = &nit->descriptor;
-	}
+	size = nit->desc_length;
 	if (p + size > endbuf) {
 		dvb_logerr("%s: short read %zd/%zd bytes", __func__,
 			   endbuf - p, size);
-		return -3;
+		return -4;
+	}
+	if (dvb_desc_parse(parms, p, size, head_desc) != 0) {
+		return -5;
 	}
-	dvb_desc_parse(parms, p, size, head_desc);
 	p += size;
 
 	size = sizeof(union dvb_table_nit_transport_header);
 	if (p + size > endbuf) {
 		dvb_logerr("%s: short read %zd/%zd bytes", __func__,
 			   endbuf - p, size);
-		return -4;
+		return -6;
 	}
 	p += size;
 
@@ -95,7 +91,7 @@ ssize_t dvb_table_nit_init(struct dvb_v5_fe_parms *parms, const uint8_t *buf,
 		transport = malloc(sizeof(struct dvb_table_nit_transport));
 		if (!transport) {
 			dvb_logerr("%s: out of memory", __func__);
-			return -5;
+			return -7;
 		}
 		memcpy(transport, p, size);
 		p += size;
@@ -119,7 +115,7 @@ ssize_t dvb_table_nit_init(struct dvb_v5_fe_parms *parms, const uint8_t *buf,
 			}
 			if (dvb_desc_parse(parms, p, desc_length,
 					      &transport->descriptor) != 0) {
-				return -6;
+				return -8;
 			}
 			p += desc_length;
 		}
@@ -127,7 +123,6 @@ ssize_t dvb_table_nit_init(struct dvb_v5_fe_parms *parms, const uint8_t *buf,
 	if (endbuf - p)
 		dvb_logwarn("%s: %zu spurious bytes at the end",
 			   __func__, endbuf - p);
-	*table_length = p - buf;
 	return p - buf;
 }
 
diff --git a/lib/libdvbv5/tables/pat.c b/lib/libdvbv5/tables/pat.c
index 1a79bca..544bac4 100644
--- a/lib/libdvbv5/tables/pat.c
+++ b/lib/libdvbv5/tables/pat.c
@@ -24,9 +24,10 @@
 #include <libdvbv5/dvb-fe.h>
 
 ssize_t dvb_table_pat_init(struct dvb_v5_fe_parms *parms, const uint8_t *buf,
-			ssize_t buflen, struct dvb_table_pat *pat, ssize_t *table_length)
+			ssize_t buflen, struct dvb_table_pat **table)
 {
 	const uint8_t *p = buf, *endbuf = buf + buflen - 4;
+	struct dvb_table_pat *pat;
 	struct dvb_table_pat_program **head;
 	size_t size;
 
@@ -43,18 +44,21 @@ ssize_t dvb_table_pat_init(struct dvb_v5_fe_parms *parms, const uint8_t *buf,
 		return -2;
 	}
 
-	if (*table_length > 0) {
-		/* find end of current list */
-		head = &pat->program;
-		while (*head != NULL)
-			head = &(*head)->next;
-	} else {
-		memcpy(pat, buf, size);
-		p += size;
-		pat->programs = 0;
-		pat->program = NULL;
-		head = &pat->program;
+	if (!*table) {
+		*table = calloc(sizeof(struct dvb_table_pat), 1);
+		if (!*table) {
+			dvb_logerr("%s: out of memory", __func__);
+			return -3;
+		}
 	}
+	pat = *table;
+	memcpy(pat, buf, size);
+	p += size;
+
+	/* find end of current list */
+	head = &pat->program;
+	while (*head != NULL)
+		head = &(*head)->next;
 
 	size = offsetof(struct dvb_table_pat_program, next);
 	while (p + size <= endbuf) {
@@ -63,7 +67,7 @@ ssize_t dvb_table_pat_init(struct dvb_v5_fe_parms *parms, const uint8_t *buf,
 		prog = malloc(sizeof(struct dvb_table_pat_program));
 		if (!prog) {
 			dvb_logerr("%s: out of memory", __func__);
-			return -3;
+			return -4;
 		}
 
 		memcpy(prog, p, size);
@@ -86,7 +90,6 @@ ssize_t dvb_table_pat_init(struct dvb_v5_fe_parms *parms, const uint8_t *buf,
 	if (endbuf - p)
 		dvb_logwarn("%s: %zu spurious bytes at the end",
 			   __func__, endbuf - p);
-	*table_length = p - buf;
 	return p - buf;
 }
 
diff --git a/lib/libdvbv5/tables/pmt.c b/lib/libdvbv5/tables/pmt.c
index 426c3dc..b81dad7 100644
--- a/lib/libdvbv5/tables/pmt.c
+++ b/lib/libdvbv5/tables/pmt.c
@@ -26,9 +26,10 @@
 #include <string.h> /* memcpy */
 
 ssize_t dvb_table_pmt_init(struct dvb_v5_fe_parms *parms, const uint8_t *buf,
-			ssize_t buflen, struct dvb_table_pmt *pmt, ssize_t *table_length)
+			ssize_t buflen, struct dvb_table_pmt **table)
 {
 	const uint8_t *p = buf, *endbuf = buf + buflen - 4;
+	struct dvb_table_pmt *pmt;
 	struct dvb_table_pmt_stream **head;
 	struct dvb_desc **head_desc;
 	size_t size;
@@ -46,36 +47,32 @@ ssize_t dvb_table_pmt_init(struct dvb_v5_fe_parms *parms, const uint8_t *buf,
 		return -2;
 	}
 
-	if (*table_length > 0) {
-		memcpy(pmt, p, size);
-		bswap16(pmt->bitfield);
-		bswap16(pmt->bitfield2);
-
-		/* find end of current list */
-		head = &pmt->stream;
-		while (*head != NULL)
-			head = &(*head)->next;
-		head_desc = &pmt->descriptor;
-		while (*head_desc != NULL)
-			head_desc = &(*head_desc)->next;
-	} else {
-		memcpy(pmt, p, size);
-		bswap16(pmt->bitfield);
-		bswap16(pmt->bitfield2);
-
-		pmt->descriptor = NULL;
-		pmt->stream = NULL;
-
-		head = &pmt->stream;
-		head_desc = &pmt->descriptor;
+	if (!*table) {
+		*table = calloc(sizeof(struct dvb_table_pmt), 1);
+		if (!*table) {
+			dvb_logerr("%s: out of memory", __func__);
+			return -3;
+		}
 	}
+	pmt = *table;
+	memcpy(pmt, p, size);
 	p += size;
+	bswap16(pmt->bitfield);
+	bswap16(pmt->bitfield2);
+
+	/* find end of current list */
+	head = &pmt->stream;
+	while (*head != NULL)
+		head = &(*head)->next;
+	head_desc = &pmt->descriptor;
+	while (*head_desc != NULL)
+		head_desc = &(*head_desc)->next;
 
 	size = pmt->header.section_length + 3 - 4; /* plus header, minus CRC */
 	if (buf + size > endbuf) {
 		dvb_logerr("%s: short read %zd/%zd bytes", __func__,
 			   endbuf - buf, size);
-		return -3;
+		return -4;
 	}
 	endbuf = buf + size;
 
@@ -89,7 +86,7 @@ ssize_t dvb_table_pmt_init(struct dvb_v5_fe_parms *parms, const uint8_t *buf,
 		}
 		if (dvb_desc_parse(parms, p, desc_length,
 				      head_desc) != 0) {
-			return -3;
+			return -4;
 		}
 		p += desc_length;
 	}
@@ -102,7 +99,7 @@ ssize_t dvb_table_pmt_init(struct dvb_v5_fe_parms *parms, const uint8_t *buf,
 		stream = malloc(sizeof(struct dvb_table_pmt_stream));
 		if (!stream) {
 			dvb_logerr("%s: out of memory", __func__);
-			return -3;
+			return -5;
 		}
 		memcpy(stream, p, size);
 		p += size;
@@ -125,7 +122,7 @@ ssize_t dvb_table_pmt_init(struct dvb_v5_fe_parms *parms, const uint8_t *buf,
 			}
 			if (dvb_desc_parse(parms, p, desc_length,
 					      &stream->descriptor) != 0) {
-				return -4;
+				return -6;
 			}
 			p += desc_length;
 		}
@@ -134,7 +131,6 @@ ssize_t dvb_table_pmt_init(struct dvb_v5_fe_parms *parms, const uint8_t *buf,
 		dvb_logwarn("%s: %zu spurious bytes at the end",
 			   __func__, endbuf - p);
 
-	*table_length = p - buf;
 	return p - buf;
 }
 
diff --git a/lib/libdvbv5/tables/sdt.c b/lib/libdvbv5/tables/sdt.c
index 561ec66..a64726f 100644
--- a/lib/libdvbv5/tables/sdt.c
+++ b/lib/libdvbv5/tables/sdt.c
@@ -24,9 +24,10 @@
 #include <libdvbv5/dvb-fe.h>
 
 ssize_t dvb_table_sdt_init(struct dvb_v5_fe_parms *parms, const uint8_t *buf,
-			ssize_t buflen, struct dvb_table_sdt *sdt, ssize_t *table_length)
+			ssize_t buflen, struct dvb_table_sdt **table)
 {
 	const uint8_t *p = buf, *endbuf = buf + buflen - 4;
+	struct dvb_table_sdt *sdt;
 	struct dvb_table_sdt_service **head;
 	size_t size;
 
@@ -43,28 +44,28 @@ ssize_t dvb_table_sdt_init(struct dvb_v5_fe_parms *parms, const uint8_t *buf,
 		return -2;
 	}
 
-	if (*table_length > 0) {
-		memcpy(sdt, p, size);
-		bswap16(sdt->network_id);
-
-		/* find end of curent list */
-		head = &sdt->service;
-		while (*head != NULL)
-			head = &(*head)->next;
-	} else {
-		memcpy(sdt, p, size);
-		bswap16(sdt->network_id);
-
-		sdt->service = NULL;
-		head = &sdt->service;
+	if (!*table) {
+		*table = calloc(sizeof(struct dvb_table_sdt), 1);
+		if (!*table) {
+			dvb_logerr("%s: out of memory", __func__);
+			return -3;
+		}
 	}
+	sdt = *table;
+	memcpy(sdt, p, size);
 	p += size;
+	bswap16(sdt->network_id);
+
+	/* find end of curent list */
+	head = &sdt->service;
+	while (*head != NULL)
+		head = &(*head)->next;
 
 	size = sdt->header.section_length + 3 - 4; /* plus header, minus CRC */
 	if (buf + size > endbuf) {
 		dvb_logerr("%s: short read %zd/%zd bytes", __func__,
 			   endbuf - buf, size);
-		return -3;
+		return -4;
 	}
 	endbuf = buf + size;
 
@@ -99,7 +100,7 @@ ssize_t dvb_table_sdt_init(struct dvb_v5_fe_parms *parms, const uint8_t *buf,
 			}
 			if (dvb_desc_parse(parms, p, desc_length,
 					      &service->descriptor) != 0) {
-				return -4;
+				return -6;
 			}
 			p += desc_length;
 		}
@@ -109,7 +110,6 @@ ssize_t dvb_table_sdt_init(struct dvb_v5_fe_parms *parms, const uint8_t *buf,
 		dvb_logwarn("%s: %zu spurious bytes at the end",
 			   __func__, endbuf - p);
 
-	*table_length = p - buf;
 	return p - buf;
 }
 
diff --git a/lib/libdvbv5/tables/vct.c b/lib/libdvbv5/tables/vct.c
index 387c6e8..970023d 100644
--- a/lib/libdvbv5/tables/vct.c
+++ b/lib/libdvbv5/tables/vct.c
@@ -25,9 +25,10 @@
 #include <parse_string.h>
 
 ssize_t atsc_table_vct_init(struct dvb_v5_fe_parms *parms, const uint8_t *buf,
-			ssize_t buflen, struct atsc_table_vct *vct, ssize_t *table_length)
+			ssize_t buflen, struct atsc_table_vct **table)
 {
 	const uint8_t *p = buf, *endbuf = buf + buflen - 4;
+	struct atsc_table_vct *vct;
 	struct atsc_table_vct_channel **head;
 	size_t size;
 	int i, n;
@@ -45,21 +46,22 @@ ssize_t atsc_table_vct_init(struct dvb_v5_fe_parms *parms, const uint8_t *buf,
 		return -2;
 	}
 
-	if (*table_length > 0) {
-		/* find end of curent list */
-		head = &vct->channel;
-		while (*head != NULL)
-			head = &(*head)->next;
-	} else {
-		memcpy(vct, p, size);
-
-		vct->channel = NULL;
-		vct->descriptor = NULL;
-
-		head = &vct->channel;
+	if (!*table) {
+		*table = calloc(sizeof(struct atsc_table_vct), 1);
+		if (!*table) {
+			dvb_logerr("%s: out of memory", __func__);
+			return -3;
+		}
 	}
+	vct = *table;
+	memcpy(vct, p, size);
 	p += size;
 
+	/* find end of curent list */
+	head = &vct->channel;
+	while (*head != NULL)
+		head = &(*head)->next;
+
 	size = offsetof(struct atsc_table_vct_channel, descriptor);
 	for (n = 0; n < vct->num_channels_in_section; n++) {
 		struct atsc_table_vct_channel *channel;
@@ -74,7 +76,7 @@ ssize_t atsc_table_vct_init(struct dvb_v5_fe_parms *parms, const uint8_t *buf,
 		channel = malloc(sizeof(struct atsc_table_vct_channel));
 		if (!channel) {
 			dvb_logerr("%s: out of memory", __func__);
-			return -3;
+			return -4;
 		}
 
 		memcpy(channel, p, size);
@@ -111,12 +113,14 @@ ssize_t atsc_table_vct_init(struct dvb_v5_fe_parms *parms, const uint8_t *buf,
 		if (endbuf - p < channel->descriptors_length) {
 			dvb_logerr("%s: short read %d/%zd bytes", __func__,
 				   channel->descriptors_length, endbuf - p);
-			return -2;
+			return -5;
 		}
 
 		/* get the descriptors for each program */
-		dvb_desc_parse(parms, p, channel->descriptors_length,
-				      &channel->descriptor);
+		if (dvb_desc_parse(parms, p, channel->descriptors_length,
+				      &channel->descriptor) != 0) {
+			return -6;
+		}
 
 		p += channel->descriptors_length;
 	}
@@ -130,15 +134,16 @@ ssize_t atsc_table_vct_init(struct dvb_v5_fe_parms *parms, const uint8_t *buf,
 		if (endbuf - p < d->descriptor_length) {
 			dvb_logerr("%s: short read %d/%zd bytes", __func__,
 				   d->descriptor_length, endbuf - p);
-			return -3;
+			return -7;
+		}
+		if (dvb_desc_parse(parms, p, d->descriptor_length,
+				      &vct->descriptor) != 0) {
+			return -8;
 		}
-		dvb_desc_parse(parms, p, d->descriptor_length,
-				      &vct->descriptor);
 	}
 	if (endbuf - p)
 		dvb_logwarn("%s: %zu spurious bytes at the end",
 			   __func__, endbuf - p);
-	*table_length = p - buf;
 	return p - buf;
 }
 
-- 
1.9.1

