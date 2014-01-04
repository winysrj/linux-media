Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ea0-f175.google.com ([209.85.215.175]:36450 "EHLO
	mail-ea0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754491AbaADRIo (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 4 Jan 2014 12:08:44 -0500
Received: by mail-ea0-f175.google.com with SMTP id z10so7149202ead.20
        for <linux-media@vger.kernel.org>; Sat, 04 Jan 2014 09:08:43 -0800 (PST)
From: =?UTF-8?q?Andr=C3=A9=20Roth?= <neolynx@gmail.com>
To: linux-media@vger.kernel.org
Cc: =?UTF-8?q?Andr=C3=A9=20Roth?= <neolynx@gmail.com>
Subject: [PATCH 05/11] libdvbv5: fix PMT parser
Date: Sat,  4 Jan 2014 18:07:55 +0100
Message-Id: <1388855282-19295-5-git-send-email-neolynx@gmail.com>
In-Reply-To: <1388855282-19295-1-git-send-email-neolynx@gmail.com>
References: <1388855282-19295-1-git-send-email-neolynx@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: André Roth <neolynx@gmail.com>
---
 lib/include/libdvbv5/pmt.h     |    6 +++++-
 lib/libdvbv5/descriptors/pmt.c |   22 +++++++++++++++-------
 2 files changed, 20 insertions(+), 8 deletions(-)

diff --git a/lib/include/libdvbv5/pmt.h b/lib/include/libdvbv5/pmt.h
index f1b7cef..a2183ac 100644
--- a/lib/include/libdvbv5/pmt.h
+++ b/lib/include/libdvbv5/pmt.h
@@ -96,9 +96,13 @@ struct dvb_table_pmt {
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
 
@@ -108,7 +112,7 @@ struct dvb_v5_fe_parms;
 extern "C" {
 #endif
 
-void dvb_table_pmt_init (struct dvb_v5_fe_parms *parms, const uint8_t *buf, ssize_t buflen, uint8_t *table, ssize_t *table_length);
+void dvb_table_pmt_init (struct dvb_v5_fe_parms *parms, const uint8_t *buf, ssize_t buflen, struct dvb_table_pmt *pmt, ssize_t *table_length);
 void dvb_table_pmt_free(struct dvb_table_pmt *pmt);
 void dvb_table_pmt_print(struct dvb_v5_fe_parms *parms, const struct dvb_table_pmt *pmt);
 
diff --git a/lib/libdvbv5/descriptors/pmt.c b/lib/libdvbv5/descriptors/pmt.c
index 3915414..5d42eb7 100644
--- a/lib/libdvbv5/descriptors/pmt.c
+++ b/lib/libdvbv5/descriptors/pmt.c
@@ -26,10 +26,9 @@
 #include <string.h> /* memcpy */
 
 void dvb_table_pmt_init(struct dvb_v5_fe_parms *parms, const uint8_t *buf,
-			ssize_t buflen, uint8_t *table, ssize_t *table_length)
+			ssize_t buflen, struct dvb_table_pmt *pmt, ssize_t *table_length)
 {
 	const uint8_t *p = buf, *endbuf = buf + buflen - 4;
-	struct dvb_table_pmt *pmt = (void *)table;
 	struct dvb_table_pmt_stream **head = &pmt->stream;
 	size_t size;
 
@@ -38,13 +37,13 @@ void dvb_table_pmt_init(struct dvb_v5_fe_parms *parms, const uint8_t *buf,
 		while (*head != NULL)
 			head = &(*head)->next;
 	} else {
-		size = offsetof(struct dvb_table_pmt, stream);
+		size = offsetof(struct dvb_table_pmt, dvb_pmt_field_last);
 		if (p + size > endbuf) {
 			dvb_logerr("PMT table was truncated. Need %zu bytes, but has only %zu.",
 				size, buflen);
 			return;
 		}
-		memcpy(table, p, size);
+		memcpy(pmt, p, size);
 		p += size;
 		*table_length = sizeof(struct dvb_table_pmt);
 
@@ -52,7 +51,8 @@ void dvb_table_pmt_init(struct dvb_v5_fe_parms *parms, const uint8_t *buf,
 		bswap16(pmt->bitfield2);
 		pmt->stream = NULL;
 
-		/* skip prog section */
+		dvb_parse_descriptors(parms, p, pmt->prog_length,
+				      &pmt->descriptor);
 		p += pmt->prog_length;
 	}
 
@@ -74,15 +74,22 @@ void dvb_table_pmt_init(struct dvb_v5_fe_parms *parms, const uint8_t *buf,
 		*head = stream;
 		head = &(*head)->next;
 
+		if (stream->section_length > endbuf - p) {
+			dvb_logerr("PMT stream section length > buffer: %zd", stream->section_length - (endbuf - p));
+			stream->section_length = endbuf - p;
+		}
 		/* get the descriptors for each program */
 		dvb_parse_descriptors(parms, p, stream->section_length,
 				      &stream->descriptor);
 
 		p += stream->section_length;
 	}
-	if (endbuf - p)
-		dvb_logerr("PAT table has %zu spurious bytes at the end.",
+	if (p < endbuf)
+		dvb_logerr("PMT table has %zu spurious bytes at the end.",
 			   endbuf - p);
+	if (p > endbuf)
+		dvb_logerr("PMT oops  %zu ",
+			   p - endbuf);
 }
 
 void dvb_table_pmt_free(struct dvb_table_pmt *pmt)
@@ -94,6 +101,7 @@ void dvb_table_pmt_free(struct dvb_table_pmt *pmt)
 		stream = stream->next;
 		free(tmp);
 	}
+	dvb_free_descriptors((struct dvb_desc **) &pmt->descriptor);
 	free(pmt);
 }
 
-- 
1.7.10.4

