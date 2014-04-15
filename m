Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ee0-f51.google.com ([74.125.83.51]:39714 "EHLO
	mail-ee0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750913AbaDOUdY (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 15 Apr 2014 16:33:24 -0400
Received: by mail-ee0-f51.google.com with SMTP id c13so8203376eek.10
        for <linux-media@vger.kernel.org>; Tue, 15 Apr 2014 13:33:22 -0700 (PDT)
From: =?UTF-8?q?Andr=C3=A9=20Roth?= <neolynx@gmail.com>
To: linux-media@vger.kernel.org
Cc: =?UTF-8?q?Andr=C3=A9=20Roth?= <neolynx@gmail.com>
Subject: [PATCH] libdvbv5: improve CRC size handling
Date: Tue, 15 Apr 2014 22:33:01 +0200
Message-Id: <1397593981-18337-1-git-send-email-neolynx@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

- provide buffer without CRC to the table parsers
- remove unneeded defines

Signed-off-by: André Roth <neolynx@gmail.com>
---
 lib/include/libdvbv5/descriptors.h | 3 +--
 lib/libdvbv5/dvb-scan.c            | 2 +-
 lib/libdvbv5/tables/atsc_eit.c     | 2 +-
 lib/libdvbv5/tables/cat.c          | 4 ++--
 lib/libdvbv5/tables/eit.c          | 2 +-
 lib/libdvbv5/tables/mgt.c          | 2 +-
 lib/libdvbv5/tables/nit.c          | 2 +-
 lib/libdvbv5/tables/pat.c          | 2 +-
 lib/libdvbv5/tables/pmt.c          | 4 ++--
 lib/libdvbv5/tables/sdt.c          | 4 ++--
 lib/libdvbv5/tables/vct.c          | 2 +-
 11 files changed, 14 insertions(+), 15 deletions(-)

diff --git a/lib/include/libdvbv5/descriptors.h b/lib/include/libdvbv5/descriptors.h
index 66197f6..94d85a9 100644
--- a/lib/include/libdvbv5/descriptors.h
+++ b/lib/include/libdvbv5/descriptors.h
@@ -31,8 +31,7 @@
 #include <stdint.h>
 
 #define DVB_MAX_PAYLOAD_PACKET_SIZE 4096
-#define DVB_PID_SDT      17
-#define DVB_PMT_TABLE_ID 2
+#define DVB_CRC_SIZE 4
 
 struct dvb_v5_fe_parms;
 
diff --git a/lib/libdvbv5/dvb-scan.c b/lib/libdvbv5/dvb-scan.c
index 5cd38f8..b16f4c4 100644
--- a/lib/libdvbv5/dvb-scan.c
+++ b/lib/libdvbv5/dvb-scan.c
@@ -222,7 +222,7 @@ static int dvb_parse_section(struct dvb_v5_fe_parms *parms,
 		set_bit(h->section_id, priv->is_read_bits);
 
 	if (dvb_table_initializers[tid])
-		dvb_table_initializers[tid](parms, buf, buf_length,
+		dvb_table_initializers[tid](parms, buf, buf_length - DVB_CRC_SIZE,
 						 sect->table);
 	else
 		dvb_logerr("%s: no initializer for table %d",
diff --git a/lib/libdvbv5/tables/atsc_eit.c b/lib/libdvbv5/tables/atsc_eit.c
index 83a495c..cf69fff 100644
--- a/lib/libdvbv5/tables/atsc_eit.c
+++ b/lib/libdvbv5/tables/atsc_eit.c
@@ -25,7 +25,7 @@
 ssize_t atsc_table_eit_init(struct dvb_v5_fe_parms *parms, const uint8_t *buf,
 		ssize_t buflen, struct atsc_table_eit **table)
 {
-	const uint8_t *p = buf, *endbuf = buf + buflen - 4; /* minus CRC */;
+	const uint8_t *p = buf, *endbuf = buf + buflen;
 	struct atsc_table_eit *eit;
 	struct atsc_table_eit_event **head;
 	size_t size;
diff --git a/lib/libdvbv5/tables/cat.c b/lib/libdvbv5/tables/cat.c
index 394eb3c..f5887b2 100644
--- a/lib/libdvbv5/tables/cat.c
+++ b/lib/libdvbv5/tables/cat.c
@@ -25,7 +25,7 @@
 ssize_t dvb_table_cat_init(struct dvb_v5_fe_parms *parms, const uint8_t *buf,
 		ssize_t buflen, struct dvb_table_cat **table)
 {
-	const uint8_t *p = buf, *endbuf = buf + buflen - 4;
+	const uint8_t *p = buf, *endbuf = buf + buflen;
 	struct dvb_table_cat *cat;
 	struct dvb_desc **head_desc;
 	size_t size;
@@ -59,7 +59,7 @@ ssize_t dvb_table_cat_init(struct dvb_v5_fe_parms *parms, const uint8_t *buf,
 	while (*head_desc != NULL)
 		head_desc = &(*head_desc)->next;
 
-	size = cat->header.section_length + 3 - 4; /* plus header, minus CRC */
+	size = cat->header.section_length + 3 - DVB_CRC_SIZE; /* plus header, minus CRC */
 	if (buf + size > endbuf) {
 		dvb_logerr("%s: short read %zd/%zd bytes", __func__,
 			   endbuf - buf, size);
diff --git a/lib/libdvbv5/tables/eit.c b/lib/libdvbv5/tables/eit.c
index 1870722..ff68536 100644
--- a/lib/libdvbv5/tables/eit.c
+++ b/lib/libdvbv5/tables/eit.c
@@ -25,7 +25,7 @@
 ssize_t dvb_table_eit_init(struct dvb_v5_fe_parms *parms, const uint8_t *buf,
 		ssize_t buflen, struct dvb_table_eit **table)
 {
-	const uint8_t *p = buf, *endbuf = buf + buflen - 4; /* minus CRC */
+	const uint8_t *p = buf, *endbuf = buf + buflen;
 	struct dvb_table_eit *eit;
 	struct dvb_table_eit_event **head;
 	size_t size;
diff --git a/lib/libdvbv5/tables/mgt.c b/lib/libdvbv5/tables/mgt.c
index bf77348..ffdea53 100644
--- a/lib/libdvbv5/tables/mgt.c
+++ b/lib/libdvbv5/tables/mgt.c
@@ -25,7 +25,7 @@
 ssize_t atsc_table_mgt_init(struct dvb_v5_fe_parms *parms, const uint8_t *buf,
 		ssize_t buflen, struct atsc_table_mgt **table)
 {
-	const uint8_t *p = buf, *endbuf = buf + buflen - 4; /* minus CRC */
+	const uint8_t *p = buf, *endbuf = buf + buflen;
 	struct atsc_table_mgt *mgt;
 	struct atsc_table_mgt_table **head;
 	struct dvb_desc **head_desc;
diff --git a/lib/libdvbv5/tables/nit.c b/lib/libdvbv5/tables/nit.c
index 054b36b..243506d 100644
--- a/lib/libdvbv5/tables/nit.c
+++ b/lib/libdvbv5/tables/nit.c
@@ -25,7 +25,7 @@
 ssize_t dvb_table_nit_init(struct dvb_v5_fe_parms *parms, const uint8_t *buf,
 			ssize_t buflen, struct dvb_table_nit **table)
 {
-	const uint8_t *p = buf, *endbuf = buf + buflen - 4;
+	const uint8_t *p = buf, *endbuf = buf + buflen;
 	struct dvb_table_nit *nit;
 	struct dvb_table_nit_transport **head;
 	struct dvb_desc **head_desc;
diff --git a/lib/libdvbv5/tables/pat.c b/lib/libdvbv5/tables/pat.c
index 544bac4..29dbfff 100644
--- a/lib/libdvbv5/tables/pat.c
+++ b/lib/libdvbv5/tables/pat.c
@@ -26,7 +26,7 @@
 ssize_t dvb_table_pat_init(struct dvb_v5_fe_parms *parms, const uint8_t *buf,
 			ssize_t buflen, struct dvb_table_pat **table)
 {
-	const uint8_t *p = buf, *endbuf = buf + buflen - 4;
+	const uint8_t *p = buf, *endbuf = buf + buflen;
 	struct dvb_table_pat *pat;
 	struct dvb_table_pat_program **head;
 	size_t size;
diff --git a/lib/libdvbv5/tables/pmt.c b/lib/libdvbv5/tables/pmt.c
index b81dad7..305d9e8 100644
--- a/lib/libdvbv5/tables/pmt.c
+++ b/lib/libdvbv5/tables/pmt.c
@@ -28,7 +28,7 @@
 ssize_t dvb_table_pmt_init(struct dvb_v5_fe_parms *parms, const uint8_t *buf,
 			ssize_t buflen, struct dvb_table_pmt **table)
 {
-	const uint8_t *p = buf, *endbuf = buf + buflen - 4;
+	const uint8_t *p = buf, *endbuf = buf + buflen;
 	struct dvb_table_pmt *pmt;
 	struct dvb_table_pmt_stream **head;
 	struct dvb_desc **head_desc;
@@ -68,7 +68,7 @@ ssize_t dvb_table_pmt_init(struct dvb_v5_fe_parms *parms, const uint8_t *buf,
 	while (*head_desc != NULL)
 		head_desc = &(*head_desc)->next;
 
-	size = pmt->header.section_length + 3 - 4; /* plus header, minus CRC */
+	size = pmt->header.section_length + 3 - DVB_CRC_SIZE; /* plus header, minus CRC */
 	if (buf + size > endbuf) {
 		dvb_logerr("%s: short read %zd/%zd bytes", __func__,
 			   endbuf - buf, size);
diff --git a/lib/libdvbv5/tables/sdt.c b/lib/libdvbv5/tables/sdt.c
index a64726f..4285a9a 100644
--- a/lib/libdvbv5/tables/sdt.c
+++ b/lib/libdvbv5/tables/sdt.c
@@ -26,7 +26,7 @@
 ssize_t dvb_table_sdt_init(struct dvb_v5_fe_parms *parms, const uint8_t *buf,
 			ssize_t buflen, struct dvb_table_sdt **table)
 {
-	const uint8_t *p = buf, *endbuf = buf + buflen - 4;
+	const uint8_t *p = buf, *endbuf = buf + buflen;
 	struct dvb_table_sdt *sdt;
 	struct dvb_table_sdt_service **head;
 	size_t size;
@@ -61,7 +61,7 @@ ssize_t dvb_table_sdt_init(struct dvb_v5_fe_parms *parms, const uint8_t *buf,
 	while (*head != NULL)
 		head = &(*head)->next;
 
-	size = sdt->header.section_length + 3 - 4; /* plus header, minus CRC */
+	size = sdt->header.section_length + 3 - DVB_CRC_SIZE; /* plus header, minus CRC */
 	if (buf + size > endbuf) {
 		dvb_logerr("%s: short read %zd/%zd bytes", __func__,
 			   endbuf - buf, size);
diff --git a/lib/libdvbv5/tables/vct.c b/lib/libdvbv5/tables/vct.c
index 970023d..e6bc1a2 100644
--- a/lib/libdvbv5/tables/vct.c
+++ b/lib/libdvbv5/tables/vct.c
@@ -27,7 +27,7 @@
 ssize_t atsc_table_vct_init(struct dvb_v5_fe_parms *parms, const uint8_t *buf,
 			ssize_t buflen, struct atsc_table_vct **table)
 {
-	const uint8_t *p = buf, *endbuf = buf + buflen - 4;
+	const uint8_t *p = buf, *endbuf = buf + buflen;
 	struct atsc_table_vct *vct;
 	struct atsc_table_vct_channel **head;
 	size_t size;
-- 
1.9.1

