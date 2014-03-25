Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ee0-f51.google.com ([74.125.83.51]:65063 "EHLO
	mail-ee0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754742AbaCYSUu (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 25 Mar 2014 14:20:50 -0400
Received: by mail-ee0-f51.google.com with SMTP id c13so769256eek.38
        for <linux-media@vger.kernel.org>; Tue, 25 Mar 2014 11:20:49 -0700 (PDT)
From: =?UTF-8?q?Andr=C3=A9=20Roth?= <neolynx@gmail.com>
To: LMML <linux-media@vger.kernel.org>
Cc: =?UTF-8?q?Andr=C3=A9=20Roth?= <neolynx@gmail.com>
Subject: [PATCH 11/11] libdvbv5: fix PMT parser
Date: Tue, 25 Mar 2014 19:20:01 +0100
Message-Id: <1395771601-3509-11-git-send-email-neolynx@gmail.com>
In-Reply-To: <1395771601-3509-1-git-send-email-neolynx@gmail.com>
References: <1395771601-3509-1-git-send-email-neolynx@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

- check for correct table ID
- parse all descriptos
- improve table printing

Signed-off-by: André Roth <neolynx@gmail.com>
---
 lib/include/libdvbv5/pmt.h     | 10 ++++--
 lib/libdvbv5/descriptors/pmt.c | 80 ++++++++++++++++++++++++++++--------------
 2 files changed, 61 insertions(+), 29 deletions(-)

diff --git a/lib/include/libdvbv5/pmt.h b/lib/include/libdvbv5/pmt.h
index 07b77ce..e6273f0 100644
--- a/lib/include/libdvbv5/pmt.h
+++ b/lib/include/libdvbv5/pmt.h
@@ -27,7 +27,7 @@
 
 #include <libdvbv5/header.h>
 
-#define DVB_TABLE_PMT      2
+#define DVB_TABLE_PMT      0x02
 
 enum dvb_streams {
 	stream_reserved0	= 0x00, // ITU-T | ISO/IEC Reserved
@@ -69,7 +69,7 @@ struct dvb_table_pmt_stream {
 	union {
 		uint16_t bitfield2;
 		struct {
-			uint16_t section_length:10;
+			uint16_t desc_length:10;
 			uint16_t zero:2;
 			uint16_t reserved2:4;
 		} __attribute__((packed));
@@ -91,14 +91,18 @@ struct dvb_table_pmt {
 	union {
 		uint16_t bitfield2;
 		struct {
-			uint16_t prog_length:10;
+			uint16_t desc_length:10;
 			uint16_t zero3:2;
 			uint16_t reserved3:4;
 		} __attribute__((packed));
 	} __attribute__((packed));
+	struct dvb_desc *descriptor;
 	struct dvb_table_pmt_stream *stream;
 } __attribute__((packed));
 
+#define dvb_pmt_field_first header
+#define dvb_pmt_field_last descriptor
+
 #define dvb_pmt_stream_foreach(_stream, _pmt) \
   for (struct dvb_table_pmt_stream *_stream = _pmt->stream; _stream; _stream = _stream->next) \
 
diff --git a/lib/libdvbv5/descriptors/pmt.c b/lib/libdvbv5/descriptors/pmt.c
index 32ee7e4..adedf5a 100644
--- a/lib/libdvbv5/descriptors/pmt.c
+++ b/lib/libdvbv5/descriptors/pmt.c
@@ -1,6 +1,5 @@
 /*
- * Copyright (c) 2011-2012 - Mauro Carvalho Chehab
- * Copyright (c) 2012 - Andre Roth <neolynx@gmail.com>
+ * Copyright (c) 2013 - Andre Roth <neolynx@gmail.com>
  *
  * This program is free software; you can redistribute it and/or
  * modify it under the terms of the GNU General Public License
@@ -33,27 +32,43 @@ void dvb_table_pmt_init(struct dvb_v5_fe_parms *parms, const uint8_t *buf,
 	struct dvb_table_pmt_stream **head = &pmt->stream;
 	size_t size;
 
+	if (buf[0] != DVB_TABLE_PMT) {
+		dvb_logerr("%s: invalid marker 0x%02x, sould be 0x%02x", __func__, buf[0], DVB_TABLE_PMT);
+		*table_length = 0;
+		return;
+	}
+
 	if (*table_length > 0) {
 		/* find end of current list */
 		while (*head != NULL)
 			head = &(*head)->next;
 	} else {
-		size = offsetof(struct dvb_table_pmt, stream);
+		size = offsetof(struct dvb_table_pmt, dvb_pmt_field_last);
 		if (p + size > endbuf) {
-			dvb_logerr("PMT table was truncated. Need %zu bytes, but has only %zu.",
-				size, buflen);
+			dvb_logerr("%s: short read %zd/%zd bytes", __func__,
+				   size, endbuf - p);
 			return;
 		}
-		memcpy(table, p, size);
+		memcpy(pmt, p, size);
 		p += size;
-		*table_length = sizeof(struct dvb_table_pmt);
 
 		bswap16(pmt->bitfield);
 		bswap16(pmt->bitfield2);
+		pmt->descriptor = NULL;
 		pmt->stream = NULL;
 
-		/* skip prog section */
-		p += pmt->prog_length;
+		/* parse the descriptors */
+		if (pmt->desc_length > 0 ) {
+			size = pmt->desc_length;
+			if (p + size > endbuf) {
+				dvb_logwarn("%s: decsriptors short read %zd/%zd bytes", __func__,
+					   size, endbuf - p);
+				size = endbuf - p;
+			}
+			dvb_parse_descriptors(parms, p, size,
+					      &pmt->descriptor);
+			p += size;
+		}
 	}
 
 	/* get the stream entries */
@@ -74,15 +89,25 @@ void dvb_table_pmt_init(struct dvb_v5_fe_parms *parms, const uint8_t *buf,
 		*head = stream;
 		head = &(*head)->next;
 
-		/* get the descriptors for each program */
-		dvb_parse_descriptors(parms, p, stream->section_length,
-				      &stream->descriptor);
-
-		p += stream->section_length;
+		/* parse the descriptors */
+		if (stream->desc_length > 0) {
+			size = stream->desc_length;
+			if (p + size > endbuf) {
+				dvb_logwarn("%s: decsriptors short read %zd/%zd bytes", __func__,
+					   size, endbuf - p);
+				size = endbuf - p;
+			}
+			dvb_parse_descriptors(parms, p, size,
+					      &stream->descriptor);
+
+			p += size;
+		}
 	}
-	if (endbuf - p)
-		dvb_logerr("PAT table has %zu spurious bytes at the end.",
-			   endbuf - p);
+	if (p < endbuf)
+		dvb_logwarn("%s: %zu spurious bytes at the end",
+			   __func__, endbuf - p);
+
+	*table_length = p - buf;
 }
 
 void dvb_table_pmt_free(struct dvb_table_pmt *pmt)
@@ -94,29 +119,32 @@ void dvb_table_pmt_free(struct dvb_table_pmt *pmt)
 		stream = stream->next;
 		free(tmp);
 	}
+	dvb_free_descriptors((struct dvb_desc **) &pmt->descriptor);
 	free(pmt);
 }
 
 void dvb_table_pmt_print(struct dvb_v5_fe_parms *parms, const struct dvb_table_pmt *pmt)
 {
-	dvb_log("PMT");
+	dvb_loginfo("PMT");
 	dvb_table_header_print(parms, &pmt->header);
-	dvb_log("|- pcr_pid       %d", pmt->pcr_pid);
-	dvb_log("|  reserved2     %d", pmt->reserved2);
-	dvb_log("|  prog length   %d", pmt->prog_length);
-	dvb_log("|  zero3         %d", pmt->zero3);
-	dvb_log("|  reserved3     %d", pmt->reserved3);
-	dvb_log("|\\  pid     type");
+	dvb_loginfo("|- pcr_pid          %04x", pmt->pcr_pid);
+	dvb_loginfo("|  reserved2           %d", pmt->reserved2);
+	dvb_loginfo("|  descriptor length   %d", pmt->desc_length);
+	dvb_loginfo("|  zero3               %d", pmt->zero3);
+	dvb_loginfo("|  reserved3          %d", pmt->reserved3);
+	dvb_print_descriptors(parms, pmt->descriptor);
+	dvb_loginfo("|\\");
 	const struct dvb_table_pmt_stream *stream = pmt->stream;
 	uint16_t streams = 0;
 	while(stream) {
-		dvb_log("|- %5d   %s (%d)", stream->elementary_pid,
+		dvb_loginfo("|- stream 0x%04x: %s (%x)", stream->elementary_pid,
 				pmt_stream_name[stream->type], stream->type);
+		dvb_loginfo("|    descriptor length   %d", stream->desc_length);
 		dvb_print_descriptors(parms, stream->descriptor);
 		stream = stream->next;
 		streams++;
 	}
-	dvb_log("|_  %d streams", streams);
+	dvb_loginfo("|_  %d streams", streams);
 }
 
 const char *pmt_stream_name[] = {
-- 
1.8.3.2

