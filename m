Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ee0-f45.google.com ([74.125.83.45]:38277 "EHLO
	mail-ee0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755736Ab3L3Mtf (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 30 Dec 2013 07:49:35 -0500
Received: by mail-ee0-f45.google.com with SMTP id d49so5056453eek.4
        for <linux-media@vger.kernel.org>; Mon, 30 Dec 2013 04:49:34 -0800 (PST)
From: =?UTF-8?q?Andr=C3=A9=20Roth?= <neolynx@gmail.com>
To: linux-media@vger.kernel.org
Cc: =?UTF-8?q?Andr=C3=A9=20Roth?= <neolynx@gmail.com>
Subject: [PATCH 13/18] libdvbv5: improve TS parsing
Date: Mon, 30 Dec 2013 13:48:46 +0100
Message-Id: <1388407731-24369-13-git-send-email-neolynx@gmail.com>
In-Reply-To: <1388407731-24369-1-git-send-email-neolynx@gmail.com>
References: <1388407731-24369-1-git-send-email-neolynx@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: André Roth <neolynx@gmail.com>
---
 lib/include/descriptors/mpeg_ts.h  |  4 ++--
 lib/libdvbv5/descriptors/mpeg_ts.c | 11 ++++++++---
 2 files changed, 10 insertions(+), 5 deletions(-)

diff --git a/lib/include/descriptors/mpeg_ts.h b/lib/include/descriptors/mpeg_ts.h
index 54fee69..de4fc3f 100644
--- a/lib/include/descriptors/mpeg_ts.h
+++ b/lib/include/descriptors/mpeg_ts.h
@@ -38,7 +38,7 @@ struct dvb_mpeg_ts_adaption {
 		uint8_t random_access:1;
 		uint8_t discontinued:1;
 	} __attribute__((packed));
-
+	uint8_t data[];
 } __attribute__((packed));
 
 struct dvb_mpeg_ts {
@@ -67,7 +67,7 @@ struct dvb_v5_fe_parms;
 extern "C" {
 #endif
 
-void dvb_mpeg_ts_init (struct dvb_v5_fe_parms *parms, const uint8_t *buf, ssize_t buflen, uint8_t *table, ssize_t *table_length);
+ssize_t dvb_mpeg_ts_init (struct dvb_v5_fe_parms *parms, const uint8_t *buf, ssize_t buflen, uint8_t *table, ssize_t *table_length);
 void dvb_mpeg_ts_free(struct dvb_mpeg_ts *ts);
 void dvb_mpeg_ts_print(struct dvb_v5_fe_parms *parms, struct dvb_mpeg_ts *ts);
 
diff --git a/lib/libdvbv5/descriptors/mpeg_ts.c b/lib/libdvbv5/descriptors/mpeg_ts.c
index d7ec2c4..b06cdf7 100644
--- a/lib/libdvbv5/descriptors/mpeg_ts.c
+++ b/lib/libdvbv5/descriptors/mpeg_ts.c
@@ -22,27 +22,32 @@
 #include "descriptors.h"
 #include "dvb-fe.h"
 
-void dvb_mpeg_ts_init(struct dvb_v5_fe_parms *parms, const uint8_t *buf, ssize_t buflen, uint8_t *table, ssize_t *table_length)
+ssize_t dvb_mpeg_ts_init(struct dvb_v5_fe_parms *parms, const uint8_t *buf, ssize_t buflen, uint8_t *table, ssize_t *table_length)
 {
 	if (buf[0] != DVB_MPEG_TS) {
 		dvb_logerr("mpeg ts invalid marker %#02x, sould be %#02x", buf[0], DVB_MPEG_TS);
 		*table_length = 0;
-		return;
+		return 0;
 	}
+	ssize_t bytes_read = 0;
 	struct dvb_mpeg_ts *ts = (struct dvb_mpeg_ts *) table;
 	const uint8_t *p = buf;
 	memcpy(table, p, sizeof(struct dvb_mpeg_ts));
 	p += sizeof(struct dvb_mpeg_ts);
+	bytes_read += sizeof(struct dvb_mpeg_ts);
 	*table_length = sizeof(struct dvb_mpeg_ts);
 
 	bswap16(ts->bitfield);
 
 	if (ts->adaptation_field & 0x2) {
 		memcpy(table + *table_length, p, sizeof(struct dvb_mpeg_ts_adaption));
-		p += sizeof(struct dvb_mpeg_ts);
+		p += sizeof(struct dvb_mpeg_ts_adaption);
+		bytes_read += sizeof(struct dvb_mpeg_ts_adaption);
 		*table_length += ts->adaption->length + 1;
+		/* FIXME: copy adaption->lenght bytes */
 	}
 	/*hexdump(parms, "TS: ", buf, buflen);*/
+	return bytes_read;
 }
 
 void dvb_mpeg_ts_free(struct dvb_mpeg_ts *ts)
-- 
1.8.3.2

