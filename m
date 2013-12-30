Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ee0-f47.google.com ([74.125.83.47]:41545 "EHLO
	mail-ee0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755810Ab3L3Mtc (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 30 Dec 2013 07:49:32 -0500
Received: by mail-ee0-f47.google.com with SMTP id e51so4342899eek.34
        for <linux-media@vger.kernel.org>; Mon, 30 Dec 2013 04:49:30 -0800 (PST)
From: =?UTF-8?q?Andr=C3=A9=20Roth?= <neolynx@gmail.com>
To: linux-media@vger.kernel.org
Cc: =?UTF-8?q?Andr=C3=A9=20Roth?= <neolynx@gmail.com>
Subject: [PATCH 10/18] libdvbv5: prefix VCT with atsc_ instead of dvb_
Date: Mon, 30 Dec 2013 13:48:43 +0100
Message-Id: <1388407731-24369-10-git-send-email-neolynx@gmail.com>
In-Reply-To: <1388407731-24369-1-git-send-email-neolynx@gmail.com>
References: <1388407731-24369-1-git-send-email-neolynx@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: André Roth <neolynx@gmail.com>
---
 lib/include/descriptors/vct.h  | 30 +++++++++++++++---------------
 lib/include/dvb-scan.h         |  2 +-
 lib/libdvbv5/descriptors.c     | 16 ++++++++--------
 lib/libdvbv5/descriptors/vct.c | 37 ++++++++++++++++++-------------------
 lib/libdvbv5/dvb-file.c        |  2 +-
 lib/libdvbv5/dvb-scan.c        | 10 +++++-----
 6 files changed, 48 insertions(+), 49 deletions(-)

diff --git a/lib/include/descriptors/vct.h b/lib/include/descriptors/vct.h
index 2d269dc..f3dad6c 100644
--- a/lib/include/descriptors/vct.h
+++ b/lib/include/descriptors/vct.h
@@ -25,14 +25,14 @@
 #include <stdint.h>
 #include <unistd.h> /* ssize_t */
 
-#include "descriptors/header.h"
+#include "descriptors/atsc_header.h"
 #include "descriptors.h"
 
-#define DVB_TABLE_TVCT     0xc8
-#define DVB_TABLE_CVCT     0xc9
-#define DVB_TABLE_VCT_PID  0x1ffb
+#define ATSC_TABLE_TVCT     0xc8
+#define ATSC_TABLE_CVCT     0xc9
+#define ATSC_TABLE_VCT_PID  0x1ffb
 
-struct dvb_table_vct_channel {
+struct atsc_table_vct_channel {
 	uint16_t	__short_name[7];
 
 	union {
@@ -77,15 +77,15 @@ struct dvb_table_vct_channel {
 	 * to the data parsed from the MPEG TS. So, metadata are added there
 	 */
 	struct dvb_desc *descriptor;
-	struct dvb_table_vct_channel *next;
+	struct atsc_table_vct_channel *next;
 
 	/* The channel_short_name is converted to locale charset by vct.c */
 
 	char short_name[32];
 } __attribute__((packed));
 
-struct dvb_table_vct {
-	struct dvb_table_header header;
+struct atsc_table_vct {
+	struct atsc_table_header header;
 
 	uint8_t ATSC_protocol_version;
 	uint8_t num_channels_in_section;
@@ -94,12 +94,12 @@ struct dvb_table_vct {
 	 * Everything after descriptor (including it) won't be bit-mapped
 	 * to the data parsed from the MPEG TS. So, metadata are added there
 	 */
-	struct dvb_table_vct_channel *channel;
+	struct atsc_table_vct_channel *channel;
 	struct dvb_desc *descriptor;
 } __attribute__((packed));
 
 
-union dvb_table_vct_descriptor_length {
+union atsc_table_vct_descriptor_length {
 	uint16_t bitfield;
 	struct {
 		uint16_t descriptor_length:10;
@@ -107,8 +107,8 @@ union dvb_table_vct_descriptor_length {
 	};
 };
 
-#define dvb_vct_channel_foreach(_channel, _vct) \
-	for (struct dvb_table_vct_channel *_channel = _vct->channel; _channel; _channel = _channel->next) \
+#define atsc_vct_channel_foreach(_channel, _vct) \
+	for (struct atsc_table_vct_channel *_channel = _vct->channel; _channel; _channel = _channel->next) \
 
 struct dvb_v5_fe_parms;
 
@@ -116,9 +116,9 @@ struct dvb_v5_fe_parms;
 extern "C" {
 #endif
 
-void dvb_table_vct_init (struct dvb_v5_fe_parms *parms, const uint8_t *buf, ssize_t buflen, uint8_t *table, ssize_t *table_length);
-void dvb_table_vct_free(struct dvb_table_vct *vct);
-void dvb_table_vct_print(struct dvb_v5_fe_parms *parms, struct dvb_table_vct *vct);
+void atsc_table_vct_init (struct dvb_v5_fe_parms *parms, const uint8_t *buf, ssize_t buflen, uint8_t *table, ssize_t *table_length);
+void atsc_table_vct_free(struct atsc_table_vct *vct);
+void atsc_table_vct_print(struct dvb_v5_fe_parms *parms, struct atsc_table_vct *vct);
 
 #ifdef __cplusplus
 }
diff --git a/lib/include/dvb-scan.h b/lib/include/dvb-scan.h
index b5dbfa9..9aef531 100644
--- a/lib/include/dvb-scan.h
+++ b/lib/include/dvb-scan.h
@@ -49,7 +49,7 @@ struct dvb_v5_descriptors {
 	unsigned num_entry;
 
 	struct dvb_table_pat *pat;
-	struct dvb_table_vct *vct;
+	struct atsc_table_vct *vct;
 	struct dvb_v5_descriptors_program *program;
 	struct dvb_table_nit *nit;
 	struct dvb_table_sdt *sdt;
diff --git a/lib/libdvbv5/descriptors.c b/lib/libdvbv5/descriptors.c
index 737acfa..226349e 100644
--- a/lib/libdvbv5/descriptors.c
+++ b/lib/libdvbv5/descriptors.c
@@ -78,16 +78,16 @@ void dvb_desc_default_print(struct dvb_v5_fe_parms *parms, const struct dvb_desc
 }
 
 const struct dvb_table_init dvb_table_initializers[] = {
-	[DVB_TABLE_PAT] = { dvb_table_pat_init, sizeof(struct dvb_table_pat) },
-	[DVB_TABLE_PMT] = { dvb_table_pmt_init, sizeof(struct dvb_table_pmt) },
-	[DVB_TABLE_NIT] = { dvb_table_nit_init, sizeof(struct dvb_table_nit) },
-	[DVB_TABLE_SDT] = { dvb_table_sdt_init, sizeof(struct dvb_table_sdt) },
-	[DVB_TABLE_EIT] = { dvb_table_eit_init, sizeof(struct dvb_table_eit) },
-	[DVB_TABLE_TVCT] = { dvb_table_vct_init, sizeof(struct dvb_table_vct) },
-	[DVB_TABLE_CVCT] = { dvb_table_vct_init, sizeof(struct dvb_table_vct) },
+	[DVB_TABLE_PAT]          = { dvb_table_pat_init, sizeof(struct dvb_table_pat) },
+	[DVB_TABLE_PMT]          = { dvb_table_pmt_init, sizeof(struct dvb_table_pmt) },
+	[DVB_TABLE_NIT]          = { dvb_table_nit_init, sizeof(struct dvb_table_nit) },
+	[DVB_TABLE_SDT]          = { dvb_table_sdt_init, sizeof(struct dvb_table_sdt) },
+	[DVB_TABLE_EIT]          = { dvb_table_eit_init, sizeof(struct dvb_table_eit) },
 	[DVB_TABLE_EIT_SCHEDULE] = { dvb_table_eit_init, sizeof(struct dvb_table_eit) },
 	[ATSC_TABLE_MGT]         = { atsc_table_mgt_init, sizeof(struct atsc_table_mgt) },
 	[ATSC_TABLE_EIT]         = { atsc_table_eit_init, sizeof(struct atsc_table_eit) },
+	[ATSC_TABLE_TVCT]        = { atsc_table_vct_init, sizeof(struct atsc_table_vct) },
+	[ATSC_TABLE_CVCT]        = { atsc_table_vct_init, sizeof(struct atsc_table_vct) },
 };
 
 char *default_charset = "iso-8859-1";
@@ -1359,6 +1359,6 @@ void hexdump(struct dvb_v5_fe_parms *parms, const char *prefix, const unsigned c
 		for (i = strlen(hex); i < 49; i++)
 			strncat(spaces, " ", sizeof(spaces));
 		ascii[j] = '\0';
-		dvb_log("%s%s %s %s", prefix, hex, spaces, ascii);
+		dvb_log("%s %s %s %s", prefix, hex, spaces, ascii);
 	}
 }
diff --git a/lib/libdvbv5/descriptors/vct.c b/lib/libdvbv5/descriptors/vct.c
index c1578ad..493f184 100644
--- a/lib/libdvbv5/descriptors/vct.c
+++ b/lib/libdvbv5/descriptors/vct.c
@@ -23,14 +23,14 @@
 #include "dvb-fe.h"
 #include "parse_string.h"
 
-void dvb_table_vct_init(struct dvb_v5_fe_parms *parms, const uint8_t *buf,
+void atsc_table_vct_init(struct dvb_v5_fe_parms *parms, const uint8_t *buf,
 			ssize_t buflen, uint8_t *table, ssize_t *table_length)
 {
 	const uint8_t *p = buf, *endbuf = buf + buflen - 4;
-	struct dvb_table_vct *vct = (void *)table;
-	struct dvb_table_vct_channel **head = &vct->channel;
+	struct atsc_table_vct *vct = (void *)table;
+	struct atsc_table_vct_channel **head = &vct->channel;
 	int i, n;
-	size_t size = offsetof(struct dvb_table_vct, channel);
+	size_t size = offsetof(struct atsc_table_vct, channel);
 
 	if (p + size > endbuf) {
 		dvb_logerr("VCT table was truncated. Need %zu bytes, but has only %zu.",
@@ -45,16 +45,16 @@ void dvb_table_vct_init(struct dvb_v5_fe_parms *parms, const uint8_t *buf,
 	} else {
 		memcpy(vct, p, size);
 
-		*table_length = sizeof(struct dvb_table_vct);
+		*table_length = sizeof(struct atsc_table_vct);
 
 		vct->channel = NULL;
 		vct->descriptor = NULL;
 	}
 	p += size;
 
-	size = offsetof(struct dvb_table_vct_channel, descriptor);
+	size = offsetof(struct atsc_table_vct_channel, descriptor);
 	for (n = 0; n < vct->num_channels_in_section; n++) {
-		struct dvb_table_vct_channel *channel;
+		struct atsc_table_vct_channel *channel;
 
 		if (p + size > endbuf) {
 			dvb_logerr("VCT channel table is missing %d elements",
@@ -63,7 +63,7 @@ void dvb_table_vct_init(struct dvb_v5_fe_parms *parms, const uint8_t *buf,
 			break;
 		}
 
-		channel = malloc(sizeof(struct dvb_table_vct_channel));
+		channel = malloc(sizeof(struct atsc_table_vct_channel));
 
 		memcpy(channel, p, size);
 		p += size;
@@ -104,9 +104,9 @@ void dvb_table_vct_init(struct dvb_v5_fe_parms *parms, const uint8_t *buf,
 	}
 
 	/* Get extra descriptors */
-	size = sizeof(union dvb_table_vct_descriptor_length);
+	size = sizeof(union atsc_table_vct_descriptor_length);
 	while (p + size <= endbuf) {
-		union dvb_table_vct_descriptor_length *d = (void *)p;
+		union atsc_table_vct_descriptor_length *d = (void *)p;
 		bswap16(d->descriptor_length);
 		p += size;
 		dvb_parse_descriptors(parms, p, d->descriptor_length,
@@ -117,12 +117,12 @@ void dvb_table_vct_init(struct dvb_v5_fe_parms *parms, const uint8_t *buf,
 			   endbuf - p);
 }
 
-void dvb_table_vct_free(struct dvb_table_vct *vct)
+void atsc_table_vct_free(struct atsc_table_vct *vct)
 {
-	struct dvb_table_vct_channel *channel = vct->channel;
+	struct atsc_table_vct_channel *channel = vct->channel;
 	while(channel) {
 		dvb_free_descriptors((struct dvb_desc **) &channel->descriptor);
-		struct dvb_table_vct_channel *tmp = channel;
+		struct atsc_table_vct_channel *tmp = channel;
 		channel = channel->next;
 		free(tmp);
 	}
@@ -131,19 +131,19 @@ void dvb_table_vct_free(struct dvb_table_vct *vct)
 	free(vct);
 }
 
-void dvb_table_vct_print(struct dvb_v5_fe_parms *parms, struct dvb_table_vct *vct)
+void atsc_table_vct_print(struct dvb_v5_fe_parms *parms, struct atsc_table_vct *vct)
 {
-	if (vct->header.table_id == DVB_TABLE_CVCT)
+	if (vct->header.table_id == ATSC_TABLE_CVCT)
 		dvb_log("CVCT");
 	else
 		dvb_log("TVCT");
 
-	dvb_table_header_print(parms, &vct->header);
+	atsc_table_header_print(parms, &vct->header);
 
 	dvb_log("|- Protocol version %d", vct->ATSC_protocol_version);
 	dvb_log("|- #channels        %d", vct->num_channels_in_section);
 	dvb_log("|\\  channel_id");
-	const struct dvb_table_vct_channel *channel = vct->channel;
+	const struct atsc_table_vct_channel *channel = vct->channel;
 	uint16_t channels = 0;
 	while(channel) {
 		dvb_log("|- Channel                %d.%d: %s",
@@ -159,7 +159,7 @@ void dvb_table_vct_print(struct dvb_v5_fe_parms *parms, struct dvb_table_vct *vc
 		dvb_log("|   access controlled     %d", channel->access_controlled);
 		dvb_log("|   hidden                %d", channel->hidden);
 
-		if (vct->header.table_id == DVB_TABLE_CVCT) {
+		if (vct->header.table_id == ATSC_TABLE_CVCT) {
 			dvb_log("|   path select           %d", channel->path_select);
 			dvb_log("|   out of band           %d", channel->out_of_band);
 		}
@@ -173,4 +173,3 @@ void dvb_table_vct_print(struct dvb_v5_fe_parms *parms, struct dvb_table_vct *vc
 	}
 	dvb_log("|_  %d channels", channels);
 }
-
diff --git a/lib/libdvbv5/dvb-file.c b/lib/libdvbv5/dvb-file.c
index b6fdc04..9abb1f7 100644
--- a/lib/libdvbv5/dvb-file.c
+++ b/lib/libdvbv5/dvb-file.c
@@ -1027,7 +1027,7 @@ int store_dvb_channel(struct dvb_file **dvb_file,
 	}
 
 	if (dvb_scan_handler->vct) {
-		dvb_vct_channel_foreach(d, dvb_scan_handler->vct) {
+		atsc_vct_channel_foreach(d, dvb_scan_handler->vct) {
 			char *channel = NULL;
 			char *vchannel = NULL;
 
diff --git a/lib/libdvbv5/dvb-scan.c b/lib/libdvbv5/dvb-scan.c
index 520bf9c..6f3def6 100644
--- a/lib/libdvbv5/dvb-scan.c
+++ b/lib/libdvbv5/dvb-scan.c
@@ -271,7 +271,7 @@ void dvb_scan_free_handler_table(struct dvb_v5_descriptors *dvb_scan_handler)
 	if (dvb_scan_handler->pat)
 		dvb_table_pat_free(dvb_scan_handler->pat);
 	if (dvb_scan_handler->vct)
-		dvb_table_vct_free(dvb_scan_handler->vct);
+		atsc_table_vct_free(dvb_scan_handler->vct);
 	if (dvb_scan_handler->nit)
 		dvb_table_nit_free(dvb_scan_handler->nit);
 	if (dvb_scan_handler->sdt)
@@ -329,14 +329,14 @@ struct dvb_v5_descriptors *dvb_get_ts_tables(struct dvb_v5_fe_parms *parms,
 			nit_time = 12;
 			break;
 		case SYS_ATSC:
-			atsc_filter = DVB_TABLE_TVCT;
+			atsc_filter = ATSC_TABLE_TVCT;
 			pat_pmt_time = 2;
 			vct_time = 2;
 			sdt_time = 5;
 			nit_time = 5;
 			break;
 		case SYS_DVBC_ANNEX_B:
-			atsc_filter = DVB_TABLE_CVCT;
+			atsc_filter = ATSC_TABLE_CVCT;
 			pat_pmt_time = 2;
 			vct_time = 2;
 			sdt_time = 5;
@@ -367,7 +367,7 @@ struct dvb_v5_descriptors *dvb_get_ts_tables(struct dvb_v5_fe_parms *parms,
 	/* ATSC-specific VCT table */
 	if (atsc_filter) {
 		rc = dvb_read_section(parms, dmx_fd,
-				      atsc_filter, DVB_TABLE_VCT_PID,
+				      atsc_filter, ATSC_TABLE_VCT_PID,
 				      (uint8_t **)&dvb_scan_handler->vct,
 				      vct_time * timeout_multiply);
 		if (parms->abort)
@@ -375,7 +375,7 @@ struct dvb_v5_descriptors *dvb_get_ts_tables(struct dvb_v5_fe_parms *parms,
 		if (rc < 0)
 			dvb_logerr("error while waiting for VCT table");
 		else if (parms->verbose)
-			dvb_table_vct_print(parms, dvb_scan_handler->vct);
+			atsc_table_vct_print(parms, dvb_scan_handler->vct);
 	}
 
 	/* PMT tables */
-- 
1.8.3.2

