Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ee0-f49.google.com ([74.125.83.49]:50434 "EHLO
	mail-ee0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756749AbaDPVWa (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 16 Apr 2014 17:22:30 -0400
Received: by mail-ee0-f49.google.com with SMTP id c41so9171842eek.22
        for <linux-media@vger.kernel.org>; Wed, 16 Apr 2014 14:22:29 -0700 (PDT)
From: =?UTF-8?q?Andr=C3=A9=20Roth?= <neolynx@gmail.com>
To: LMML <linux-media@vger.kernel.org>
Cc: =?UTF-8?q?Andr=C3=A9=20Roth?= <neolynx@gmail.com>
Subject: [PATCH] libdvbv5: improve DVB header handling
Date: Wed, 16 Apr 2014 23:22:10 +0200
Message-Id: <1397683330-5256-1-git-send-email-neolynx@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

the table parsers now initialize the complete table,
and do no longer rely on an already initialized table
header in the supplied buffer.

adds section length checking in PAT as well.

Signed-off-by: André Roth <neolynx@gmail.com>
---
 lib/include/libdvbv5/header.h  |  2 +-
 lib/libdvbv5/dvb-scan.c        | 31 +++++++++++++++----------------
 lib/libdvbv5/tables/atsc_eit.c |  1 +
 lib/libdvbv5/tables/cat.c      |  1 +
 lib/libdvbv5/tables/eit.c      |  1 +
 lib/libdvbv5/tables/header.c   |  3 +--
 lib/libdvbv5/tables/mgt.c      |  1 +
 lib/libdvbv5/tables/nit.c      |  1 +
 lib/libdvbv5/tables/pat.c      | 11 ++++++++++-
 lib/libdvbv5/tables/pmt.c      |  1 +
 lib/libdvbv5/tables/sdt.c      |  1 +
 lib/libdvbv5/tables/vct.c      |  1 +
 12 files changed, 35 insertions(+), 20 deletions(-)

diff --git a/lib/include/libdvbv5/header.h b/lib/include/libdvbv5/header.h
index dc85f46..856e4dc 100644
--- a/lib/include/libdvbv5/header.h
+++ b/lib/include/libdvbv5/header.h
@@ -71,7 +71,7 @@ struct dvb_v5_fe_parms;
 extern "C" {
 #endif
 
-int  dvb_table_header_init (struct dvb_table_header *t);
+void dvb_table_header_init (struct dvb_table_header *t);
 void dvb_table_header_print(struct dvb_v5_fe_parms *parms, const struct dvb_table_header *t);
 
 #ifdef __cplusplus
diff --git a/lib/libdvbv5/dvb-scan.c b/lib/libdvbv5/dvb-scan.c
index b16f4c4..dfb597a 100644
--- a/lib/libdvbv5/dvb-scan.c
+++ b/lib/libdvbv5/dvb-scan.c
@@ -168,39 +168,38 @@ void dvb_table_filter_free(struct dvb_table_filter *sect)
 
 static int dvb_parse_section(struct dvb_v5_fe_parms *parms,
 			     struct dvb_table_filter *sect,
-			     uint8_t *buf, ssize_t buf_length)
+			     const uint8_t *buf, ssize_t buf_length)
 {
-	struct dvb_table_header *h;
+	struct dvb_table_header h;
 	struct dvb_table_filter_priv *priv;
-
 	unsigned char tid;
 
-	h = (struct dvb_table_header *)buf;
-	dvb_table_header_init(h);
+	memcpy(&h, buf, sizeof(struct dvb_table_header));
+	dvb_table_header_init(&h);
 
 	if (parms->verbose)
 		dvb_log("%s: received table 0x%02x, TS ID 0x%04x, section %d/%d",
-			__func__, h->table_id, h->id, h->section_id, h->last_section);
+			__func__, h.table_id, h.id, h.section_id, h.last_section);
 
-	if (sect->tid != h->table_id) {
+	if (sect->tid != h.table_id) {
 		dvb_logdbg("%s: couldn't match ID %d at the active section filters",
-			   __func__, h->table_id);
+			   __func__, h.table_id);
 		return -1;
 	}
 	priv = sect->priv;
-	tid = h->table_id;
+	tid = h.table_id;
 
 	if (priv->first_ts_id < 0)
-		priv->first_ts_id = h->id;
+		priv->first_ts_id = h.id;
 	if (priv->first_section < 0)
-		priv->first_section = h->section_id;
+		priv->first_section = h.section_id;
 	if (priv->last_section < 0)
-		priv->last_section = h->last_section;
+		priv->last_section = h.last_section;
 	else { /* Check if the table was already parsed, but not on first pass */
 		if (!sect->allow_section_gaps && sect->ts_id != -1) {
-			if (test_bit(h->section_id, priv->is_read_bits))
+			if (test_bit(h.section_id, priv->is_read_bits))
 				return 0;
-		} else if (priv->first_ts_id == h->id && priv->first_section == h->section_id) {
+		} else if (priv->first_ts_id == h.id && priv->first_section == h.section_id) {
 			/* tables like EIT can increment sections by gaps > 1.
 			 * in this case, reading is done when a already read
 			 * table is reached. */
@@ -213,13 +212,13 @@ static int dvb_parse_section(struct dvb_v5_fe_parms *parms,
 
 	/* search for an specific TS ID */
 	if (sect->ts_id != -1) {
-		if (h->id != sect->ts_id)
+		if (h.id != sect->ts_id)
 			return 0;
 	}
 
 	/* handle the sections */
 	if (!sect->allow_section_gaps && sect->ts_id != -1)
-		set_bit(h->section_id, priv->is_read_bits);
+		set_bit(h.section_id, priv->is_read_bits);
 
 	if (dvb_table_initializers[tid])
 		dvb_table_initializers[tid](parms, buf, buf_length - DVB_CRC_SIZE,
diff --git a/lib/libdvbv5/tables/atsc_eit.c b/lib/libdvbv5/tables/atsc_eit.c
index cf69fff..6a7c4d2 100644
--- a/lib/libdvbv5/tables/atsc_eit.c
+++ b/lib/libdvbv5/tables/atsc_eit.c
@@ -54,6 +54,7 @@ ssize_t atsc_table_eit_init(struct dvb_v5_fe_parms *parms, const uint8_t *buf,
 	eit = *table;
 	memcpy(eit, p, size);
 	p += size;
+	dvb_table_header_init(&eit->header);
 
 	/* find end of curent list */
 	head = &eit->event;
diff --git a/lib/libdvbv5/tables/cat.c b/lib/libdvbv5/tables/cat.c
index f5887b2..4998307 100644
--- a/lib/libdvbv5/tables/cat.c
+++ b/lib/libdvbv5/tables/cat.c
@@ -53,6 +53,7 @@ ssize_t dvb_table_cat_init(struct dvb_v5_fe_parms *parms, const uint8_t *buf,
 	cat = *table;
 	memcpy(cat, p, size);
 	p += size;
+	dvb_table_header_init(&cat->header);
 
 	/* find end of current lists */
 	head_desc = &cat->descriptor;
diff --git a/lib/libdvbv5/tables/eit.c b/lib/libdvbv5/tables/eit.c
index ff68536..b17ff32 100644
--- a/lib/libdvbv5/tables/eit.c
+++ b/lib/libdvbv5/tables/eit.c
@@ -57,6 +57,7 @@ ssize_t dvb_table_eit_init(struct dvb_v5_fe_parms *parms, const uint8_t *buf,
 	eit = *table;
 	memcpy(eit, p, size);
 	p += size;
+	dvb_table_header_init(&eit->header);
 
 	bswap16(eit->transport_id);
 	bswap16(eit->network_id);
diff --git a/lib/libdvbv5/tables/header.c b/lib/libdvbv5/tables/header.c
index 883283f..14b2372 100644
--- a/lib/libdvbv5/tables/header.c
+++ b/lib/libdvbv5/tables/header.c
@@ -23,11 +23,10 @@
 #include <libdvbv5/descriptors.h>
 #include <libdvbv5/dvb-fe.h>
 
-int dvb_table_header_init(struct dvb_table_header *t)
+void dvb_table_header_init(struct dvb_table_header *t)
 {
 	bswap16(t->bitfield);
 	bswap16(t->id);
-	return 0;
 }
 
 void dvb_table_header_print(struct dvb_v5_fe_parms *parms, const struct dvb_table_header *t)
diff --git a/lib/libdvbv5/tables/mgt.c b/lib/libdvbv5/tables/mgt.c
index ffdea53..b2d59d6 100644
--- a/lib/libdvbv5/tables/mgt.c
+++ b/lib/libdvbv5/tables/mgt.c
@@ -55,6 +55,7 @@ ssize_t atsc_table_mgt_init(struct dvb_v5_fe_parms *parms, const uint8_t *buf,
 	mgt = *table;
 	memcpy(mgt, p, size);
 	p += size;
+	dvb_table_header_init(&mgt->header);
 
 	bswap16(mgt->tables);
 
diff --git a/lib/libdvbv5/tables/nit.c b/lib/libdvbv5/tables/nit.c
index 243506d..08b156c 100644
--- a/lib/libdvbv5/tables/nit.c
+++ b/lib/libdvbv5/tables/nit.c
@@ -54,6 +54,7 @@ ssize_t dvb_table_nit_init(struct dvb_v5_fe_parms *parms, const uint8_t *buf,
 	nit = *table;
 	memcpy(nit, p, size);
 	p += size;
+	dvb_table_header_init(&nit->header);
 
 	bswap16(nit->bitfield);
 
diff --git a/lib/libdvbv5/tables/pat.c b/lib/libdvbv5/tables/pat.c
index 29dbfff..03b75b0 100644
--- a/lib/libdvbv5/tables/pat.c
+++ b/lib/libdvbv5/tables/pat.c
@@ -54,12 +54,21 @@ ssize_t dvb_table_pat_init(struct dvb_v5_fe_parms *parms, const uint8_t *buf,
 	pat = *table;
 	memcpy(pat, buf, size);
 	p += size;
+	dvb_table_header_init(&pat->header);
 
 	/* find end of current list */
 	head = &pat->program;
 	while (*head != NULL)
 		head = &(*head)->next;
 
+	size = pat->header.section_length + 3 - DVB_CRC_SIZE; /* plus header, minus CRC */
+	if (buf + size > endbuf) {
+		dvb_logerr("%s: short read %zd/%zd bytes", __func__,
+			   endbuf - buf, size);
+		return -4;
+	}
+	endbuf = buf + size;
+
 	size = offsetof(struct dvb_table_pat_program, next);
 	while (p + size <= endbuf) {
 		struct dvb_table_pat_program *prog;
@@ -67,7 +76,7 @@ ssize_t dvb_table_pat_init(struct dvb_v5_fe_parms *parms, const uint8_t *buf,
 		prog = malloc(sizeof(struct dvb_table_pat_program));
 		if (!prog) {
 			dvb_logerr("%s: out of memory", __func__);
-			return -4;
+			return -5;
 		}
 
 		memcpy(prog, p, size);
diff --git a/lib/libdvbv5/tables/pmt.c b/lib/libdvbv5/tables/pmt.c
index 305d9e8..d2e2693 100644
--- a/lib/libdvbv5/tables/pmt.c
+++ b/lib/libdvbv5/tables/pmt.c
@@ -57,6 +57,7 @@ ssize_t dvb_table_pmt_init(struct dvb_v5_fe_parms *parms, const uint8_t *buf,
 	pmt = *table;
 	memcpy(pmt, p, size);
 	p += size;
+	dvb_table_header_init(&pmt->header);
 	bswap16(pmt->bitfield);
 	bswap16(pmt->bitfield2);
 
diff --git a/lib/libdvbv5/tables/sdt.c b/lib/libdvbv5/tables/sdt.c
index 4285a9a..d27cec8 100644
--- a/lib/libdvbv5/tables/sdt.c
+++ b/lib/libdvbv5/tables/sdt.c
@@ -54,6 +54,7 @@ ssize_t dvb_table_sdt_init(struct dvb_v5_fe_parms *parms, const uint8_t *buf,
 	sdt = *table;
 	memcpy(sdt, p, size);
 	p += size;
+	dvb_table_header_init(&sdt->header);
 	bswap16(sdt->network_id);
 
 	/* find end of curent list */
diff --git a/lib/libdvbv5/tables/vct.c b/lib/libdvbv5/tables/vct.c
index e6bc1a2..e761a7d 100644
--- a/lib/libdvbv5/tables/vct.c
+++ b/lib/libdvbv5/tables/vct.c
@@ -56,6 +56,7 @@ ssize_t atsc_table_vct_init(struct dvb_v5_fe_parms *parms, const uint8_t *buf,
 	vct = *table;
 	memcpy(vct, p, size);
 	p += size;
+	dvb_table_header_init(&vct->header);
 
 	/* find end of curent list */
 	head = &vct->channel;
-- 
1.9.1

