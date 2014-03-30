Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ee0-f52.google.com ([74.125.83.52]:38711 "EHLO
	mail-ee0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751866AbaC3QWC (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 30 Mar 2014 12:22:02 -0400
Received: by mail-ee0-f52.google.com with SMTP id e49so5661354eek.25
        for <linux-media@vger.kernel.org>; Sun, 30 Mar 2014 09:22:00 -0700 (PDT)
From: =?UTF-8?q?Andr=C3=A9=20Roth?= <neolynx@gmail.com>
To: linux-media@vger.kernel.org
Cc: =?UTF-8?q?Andr=C3=A9=20Roth?= <neolynx@gmail.com>
Subject: [PATCH 8/8] libdvbv5: add support for tables with multiple ts_id and section gaps
Date: Sun, 30 Mar 2014 18:21:18 +0200
Message-Id: <1396196478-996-8-git-send-email-neolynx@gmail.com>
In-Reply-To: <1396196478-996-1-git-send-email-neolynx@gmail.com>
References: <1396196478-996-1-git-send-email-neolynx@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

this restores the logic for reading tables like EIT, where the
ts_id indicates the service and the sections are incremented by 8
for example. an application might wish to read a complete EIT
containing all services. in this case the function dvb_read_sections
can be used with allow_section_gaps set to 1 in the dvb_table_filter
struct.

- make struct dvb_table_filter public
- use more generic void * for tables
- make dvb_read_sections public
- fix continuous parsing when table_length > 0
- fix logging

Signed-off-by: André Roth <neolynx@gmail.com>
---
 lib/include/libdvbv5/dvb-scan.h |  25 ++++++++-
 lib/libdvbv5/dvb-scan.c         | 118 +++++++++++++++++++++-------------------
 2 files changed, 86 insertions(+), 57 deletions(-)

diff --git a/lib/include/libdvbv5/dvb-scan.h b/lib/include/libdvbv5/dvb-scan.h
index 9c47c95..206d409 100644
--- a/lib/include/libdvbv5/dvb-scan.h
+++ b/lib/include/libdvbv5/dvb-scan.h
@@ -57,12 +57,33 @@ struct dvb_v5_descriptors {
 	unsigned num_program;
 };
 
-int dvb_read_section(struct dvb_v5_fe_parms *parms, int dmx_fd, unsigned char tid, uint16_t pid, unsigned char **table,
+struct dvb_table_filter {
+	/* Input data */
+	unsigned char tid;
+	uint16_t pid;
+	int ts_id;
+	void **table;
+
+	int allow_section_gaps;
+
+	/*
+	 * Private temp data used by dvb_read_sections().
+	 * Should not be filled outside dvb-scan.c, as they'll be
+	 * overrided
+	 */
+	void *priv;
+};
+
+int dvb_read_section(struct dvb_v5_fe_parms *parms, int dmx_fd, unsigned char tid, uint16_t pid, void **table,
 		unsigned timeout);
 
-int dvb_read_section_with_id(struct dvb_v5_fe_parms *parms, int dmx_fd, unsigned char tid, uint16_t pid, int id, uint8_t **table,
+int dvb_read_section_with_id(struct dvb_v5_fe_parms *parms, int dmx_fd, unsigned char tid, uint16_t pid, int ts_id, void **table,
 		unsigned timeout);
 
+int dvb_read_sections(struct dvb_v5_fe_parms *parms, int dmx_fd,
+			     struct dvb_table_filter *sect,
+			     unsigned timeout);
+
 struct dvb_v5_descriptors *dvb_scan_alloc_handler_table(uint32_t delivery_system,
 						       int verbose);
 
diff --git a/lib/libdvbv5/dvb-scan.c b/lib/libdvbv5/dvb-scan.c
index d4490fb..b0636b9 100644
--- a/lib/libdvbv5/dvb-scan.c
+++ b/lib/libdvbv5/dvb-scan.c
@@ -85,7 +85,7 @@ static int poll(struct dvb_v5_fe_parms *parms, int fd, unsigned int seconds)
 }
 
 int dvb_read_section(struct dvb_v5_fe_parms *parms, int dmx_fd,
-		     unsigned char tid, uint16_t pid, uint8_t **table,
+		     unsigned char tid, uint16_t pid, void **table,
 		     unsigned timeout)
 {
 	return dvb_read_section_with_id(parms, dmx_fd, tid, pid, -1, table, timeout);
@@ -124,86 +124,91 @@ static int is_all_bits_set(int nr, unsigned long *addr)
 }
 
 
-struct tid_pid_table_priv {
+struct dvb_table_filter_priv {
 	int last_section;
 	unsigned long is_read_bits[BITS_TO_LONGS(256)];
-	int done;
-};
-
-struct tid_pid_table {
-	/* Input data */
-	unsigned char tid;
-	uint16_t pid;
-	int ts_id;
-	uint8_t **table;
 
-	/*
-	 * Private temp data used by dvb_read_sections().
-	 * Should not be filled outside dvb-scan.c, as they'll be
-	 * overrided
-	 */
-	void *priv;
+	/* section gaps and multiple ts_id handling */
+	ssize_t table_length;
+	int first_ts_id;
+	int first_section;
+	int done;
 };
 
 static int dvb_parse_section_alloc(struct dvb_v5_fe_parms *parms,
-				   struct tid_pid_table *sect)
+				   struct dvb_table_filter *sect)
 {
-	struct tid_pid_table_priv *priv;
+	struct dvb_table_filter_priv *priv;
 
 	if (!sect->table) {
 		dvb_logerr("table memory pointer not filled");
 		return -4;
 	}
 	*sect->table = NULL;
-	priv = calloc(sizeof(struct tid_pid_table_priv), 1);
+	priv = calloc(sizeof(struct dvb_table_filter_priv), 1);
 	if (!priv) {
 		dvb_perror("Out of memory");
 		return -1;
 	}
 	priv->last_section = -1;
+	priv->first_section = -1;
+	priv->first_ts_id = -1;
 	sect->priv = priv;
 
 	return 0;
 }
 
-static void dvb_parse_section_free(struct tid_pid_table *sect)
+static void dvb_parse_section_free(struct dvb_table_filter *sect)
 {
 	if (sect->priv)
 		free(sect->priv);
 }
 
 static int dvb_parse_section(struct dvb_v5_fe_parms *parms,
-			     struct tid_pid_table *sect,
+			     struct dvb_table_filter *sect,
 			     uint8_t *buf, ssize_t buf_length)
 {
 	struct dvb_table_header *h;
-	struct tid_pid_table_priv *priv;
+	struct dvb_table_filter_priv *priv;
 
 	uint8_t *tbl = NULL;
 	unsigned char tid;
-	ssize_t table_length = 0;
 
 	h = (struct dvb_table_header *)buf;
 	dvb_table_header_init(h);
 
 	if (parms->verbose)
-		dvb_log("Received table 0x%02x, TS ID 0x%04x, section number 0x%02x, last section 0x%02x",
-			h->table_id, h->id, h->section_id, h->last_section);
+		dvb_log("%s: received table 0x%02x, TS ID 0x%04x, section %d/%d",
+			__func__, h->table_id, h->id, h->section_id, h->last_section);
 
 	if (sect->tid != h->table_id) {
-		dvb_logdbg("Something's wrong: couldn't match ID %d at the active section filters",
-			   h->table_id);
+		dvb_logdbg("%s: couldn't match ID %d at the active section filters",
+			   __func__, h->table_id);
 		return -1;
 	}
 	priv = sect->priv;
 	tid = h->table_id;
 
-	/* Check if the table was already parsed */
-
+	if (priv->first_ts_id < 0)
+		priv->first_ts_id = h->id;
+	if (priv->first_section < 0)
+		priv->first_section = h->section_id;
 	if (priv->last_section < 0)
 		priv->last_section = h->last_section;
-	else if (test_bit(h->section_id, priv->is_read_bits))
-		return 0;
+	else { /* Check if the table was already parsed, but not on first pass */
+		if (!sect->allow_section_gaps && sect->ts_id != -1) {
+			if (test_bit(h->section_id, priv->is_read_bits))
+				return 0;
+		} else if (priv->first_ts_id == h->id && priv->first_section == h->section_id) {
+			/* tables like EIT can increment sections by gaps > 1.
+			 * in this case, reading is done when a already read
+			 * table is reached. */
+			dvb_log("%s: section repeated, reading done", __func__);
+			priv->done = 1;
+			return 1;
+		}
+	}
+
 
 	/* search for an specific TS ID */
 	if (sect->ts_id != -1) {
@@ -212,13 +217,14 @@ static int dvb_parse_section(struct dvb_v5_fe_parms *parms,
 	}
 
 	/* handle the sections */
-	set_bit(h->section_id, priv->is_read_bits);
+	if (!sect->allow_section_gaps && sect->ts_id != -1)
+		set_bit(h->section_id, priv->is_read_bits);
 
 	tbl = *sect->table;
 	if (!tbl) {
 		if (!dvb_table_initializers[tid].size) {
-			dvb_logerr("dvb_read_section: no table size for table %d",
-					tid);
+			dvb_logerr("%s: no table size for table %d",
+					__func__, tid);
 			return -1;
 		}
 
@@ -227,15 +233,16 @@ static int dvb_parse_section(struct dvb_v5_fe_parms *parms,
 
 	if (dvb_table_initializers[tid].init)
 		dvb_table_initializers[tid].init(parms, buf, buf_length,
-						 tbl, &table_length);
+						 tbl, &priv->table_length);
 	else
-		dvb_logerr("dvb_read_section: no initializer for table %d",
-			   tid);
+		dvb_logerr("%s: no initializer for table %d",
+			   __func__, tid);
 
 	/* Store the table */
 	*sect->table = tbl;
 
-	if (is_all_bits_set(priv->last_section, priv->is_read_bits))
+	if (!sect->allow_section_gaps && sect->ts_id != -1 &&
+			is_all_bits_set(priv->last_section, priv->is_read_bits))
 		priv->done = 1;
 
 	if (!priv->done)
@@ -245,8 +252,8 @@ static int dvb_parse_section(struct dvb_v5_fe_parms *parms,
 	return 1;
 }
 
-static int dvb_read_sections(struct dvb_v5_fe_parms *parms, int dmx_fd,
-			     struct tid_pid_table *sect,
+int dvb_read_sections(struct dvb_v5_fe_parms *parms, int dmx_fd,
+			     struct dvb_table_filter *sect,
 			     unsigned timeout)
 {
 	int ret;
@@ -266,8 +273,8 @@ static int dvb_read_sections(struct dvb_v5_fe_parms *parms, int dmx_fd,
 		return -1;
 	}
 	if (parms->verbose)
-		dvb_log("Waiting for table ID %d, program ID %d",
-			sect->tid, sect->pid);
+		dvb_log("%s: waiting for table ID 0x%02x, program ID 0x%02x",
+			__func__, sect->tid, sect->pid);
 
 	buf = calloc(DVB_MAX_PAYLOAD_PACKET_SIZE, 1);
 	if (!buf) {
@@ -292,14 +299,14 @@ static int dvb_read_sections(struct dvb_v5_fe_parms *parms, int dmx_fd,
 			break;
 		}
 		if (available <= 0) {
-			dvb_logerr("dvb_read_section: no data read on section filter");
+			dvb_logerr("%s: no data read on section filter", __func__);
 			ret = -1;
 			break;
 		}
 		buf_length = read(dmx_fd, buf, DVB_MAX_PAYLOAD_PACKET_SIZE);
 
 		if (!buf_length) {
-			dvb_logerr("dvb_read_section: buf returned an empty buffer");
+			dvb_logerr("%s: buf returned an empty buffer", __func__);
 			ret = -1;
 			break;
 		}
@@ -311,7 +318,7 @@ static int dvb_read_sections(struct dvb_v5_fe_parms *parms, int dmx_fd,
 
 		crc = crc32(buf, buf_length, 0xFFFFFFFF);
 		if (crc != 0) {
-			dvb_logerr("dvb_read_section: crc error");
+			dvb_logerr("%s: crc error", __func__);
 			ret = -3;
 			break;
 		}
@@ -331,14 +338,15 @@ static int dvb_read_sections(struct dvb_v5_fe_parms *parms, int dmx_fd,
 int dvb_read_section_with_id(struct dvb_v5_fe_parms *parms, int dmx_fd,
 			     unsigned char tid, uint16_t pid,
 			     int ts_id,
-			     uint8_t **table, unsigned timeout)
+			     void **table, unsigned timeout)
 {
-	struct tid_pid_table tab;
+	struct dvb_table_filter tab;
 
 	tab.tid = tid;
 	tab.pid = pid;
 	tab.ts_id = ts_id;
 	tab.table = table;
+	tab.allow_section_gaps = 0;
 
 	return dvb_read_sections(parms, dmx_fd, &tab, timeout);
 }
@@ -446,7 +454,7 @@ struct dvb_v5_descriptors *dvb_get_ts_tables(struct dvb_v5_fe_parms *parms,
 	/* PAT table */
 	rc = dvb_read_section(parms, dmx_fd,
 			      DVB_TABLE_PAT, DVB_TABLE_PAT_PID,
-			      (uint8_t **) &dvb_scan_handler->pat,
+			      (void **)&dvb_scan_handler->pat,
 			      pat_pmt_time * timeout_multiply);
 	if (parms->abort)
 		return dvb_scan_handler;
@@ -462,7 +470,7 @@ struct dvb_v5_descriptors *dvb_get_ts_tables(struct dvb_v5_fe_parms *parms,
 	if (atsc_filter) {
 		rc = dvb_read_section(parms, dmx_fd,
 				      atsc_filter, ATSC_TABLE_VCT_PID,
-				      (uint8_t **)&dvb_scan_handler->vct,
+				      (void **)&dvb_scan_handler->vct,
 				      vct_time * timeout_multiply);
 		if (parms->abort)
 			return dvb_scan_handler;
@@ -489,7 +497,7 @@ struct dvb_v5_descriptors *dvb_get_ts_tables(struct dvb_v5_fe_parms *parms,
 			dvb_log("Program ID %d", program->pid);
 		rc = dvb_read_section(parms, dmx_fd,
 				      DVB_TABLE_PMT, program->pid,
-				      (uint8_t **)&dvb_scan_handler->program[num_pmt].pmt,
+				      (void **)&dvb_scan_handler->program[num_pmt].pmt,
 				      pat_pmt_time * timeout_multiply);
 		if (parms->abort) {
 			dvb_scan_handler->num_program = num_pmt + 1;
@@ -510,7 +518,7 @@ struct dvb_v5_descriptors *dvb_get_ts_tables(struct dvb_v5_fe_parms *parms,
 	/* NIT table */
 	rc = dvb_read_section(parms, dmx_fd,
 			      DVB_TABLE_NIT, DVB_TABLE_NIT_PID,
-			      (uint8_t **)&dvb_scan_handler->nit,
+			      (void **)&dvb_scan_handler->nit,
 			      nit_time * timeout_multiply);
 	if (parms->abort)
 		return dvb_scan_handler;
@@ -523,7 +531,7 @@ struct dvb_v5_descriptors *dvb_get_ts_tables(struct dvb_v5_fe_parms *parms,
 	if (!dvb_scan_handler->vct || other_nit) {
 		rc = dvb_read_section(parms, dmx_fd,
 				DVB_TABLE_SDT, DVB_TABLE_SDT_PID,
-				(uint8_t **)&dvb_scan_handler->sdt,
+				(void **)&dvb_scan_handler->sdt,
 				sdt_time * timeout_multiply);
 		if (parms->abort)
 			return dvb_scan_handler;
@@ -539,7 +547,7 @@ struct dvb_v5_descriptors *dvb_get_ts_tables(struct dvb_v5_fe_parms *parms,
 			dvb_log("Parsing other NIT/SDT");
 		rc = dvb_read_section(parms, dmx_fd,
 				      DVB_TABLE_NIT2, DVB_TABLE_NIT_PID,
-				      (uint8_t **)&dvb_scan_handler->nit,
+				      (void **)&dvb_scan_handler->nit,
 				      nit_time * timeout_multiply);
 		if (parms->abort)
 			return dvb_scan_handler;
@@ -550,7 +558,7 @@ struct dvb_v5_descriptors *dvb_get_ts_tables(struct dvb_v5_fe_parms *parms,
 
 		rc = dvb_read_section(parms, dmx_fd,
 				DVB_TABLE_SDT2, DVB_TABLE_SDT_PID,
-				(uint8_t **)&dvb_scan_handler->sdt,
+				(void **)&dvb_scan_handler->sdt,
 				sdt_time * timeout_multiply);
 		if (parms->abort)
 			return dvb_scan_handler;
-- 
1.8.3.2

