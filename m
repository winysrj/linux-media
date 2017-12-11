Return-path: <linux-media-owner@vger.kernel.org>
Received: from osg.samsung.com ([64.30.133.232]:56486 "EHLO osg.samsung.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752894AbdLKQhf (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 11 Dec 2017 11:37:35 -0500
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Ron Economos <w6rz@comcast.net>,
        Johannes Berg <johannes.berg@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 1/3] media: dvb_net: ensure that dvb_net_ule_handle is fully initialized
Date: Mon, 11 Dec 2017 11:37:24 -0500
Message-Id: <3749c9084b647a3ca80e78a9f5a3bd83ecb1e4cb.1513010227.git.mchehab@s-opensource.com>
To: unlisted-recipients:; (no To-header on input)@bombadil.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

changeset efb9ab67255f ("[media] dvb_net: prepare to split a very
complex function") changed the ULE handling logic, simplifying it.
However, it forgot to keep the initialization for .priv and to
zero .ule_hist fields.

The lack of .priv cause crashes if dvb_net_ule() is called, as
the function assuems that .priv field to be initialized.

With regards to .ule_hist, the current logic is broken and don't
even compile if ULE_DEBUG. Fix it by making the debug vars static
again, and be sure to pass iov parameter to dvb_net_ule_check_crc().

Fixes: efb9ab67255f ("[media] dvb_net: prepare to split a very complex function")

Suggested-by: Ron Economos <w6rz@comcast.net>
Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 drivers/media/dvb-core/dvb_net.c | 57 +++++++++++++++++++---------------------
 1 file changed, 27 insertions(+), 30 deletions(-)

diff --git a/drivers/media/dvb-core/dvb_net.c b/drivers/media/dvb-core/dvb_net.c
index c018e3c06d5d..bff5cd908df6 100644
--- a/drivers/media/dvb-core/dvb_net.c
+++ b/drivers/media/dvb-core/dvb_net.c
@@ -82,6 +82,13 @@ static inline __u32 iov_crc32( __u32 c, struct kvec *iov, unsigned int cnt )
 
 #ifdef ULE_DEBUG
 
+/*
+ * The code inside ULE_DEBUG keeps a history of the
+ * last 100 TS cells processed.
+ */
+static unsigned char ule_hist[100*TS_SZ] = { 0 };
+static unsigned char *ule_where = ule_hist, ule_dump;
+
 static void hexdump(const unsigned char *buf, unsigned short len)
 {
 	print_hex_dump_debug("", DUMP_PREFIX_OFFSET, 16, 1, buf, len, true);
@@ -320,14 +327,6 @@ struct dvb_net_ule_handle {
 	const u8 *ts, *ts_end, *from_where;
 	u8 ts_remain, how_much, new_ts;
 	bool error;
-#ifdef ULE_DEBUG
-	/*
-	 * The code inside ULE_DEBUG keeps a history of the
-	 * last 100 TS cells processed.
-	 */
-	static unsigned char ule_hist[100*TS_SZ];
-	static unsigned char *ule_where = ule_hist, ule_dump;
-#endif
 };
 
 static int dvb_net_ule_new_ts_cell(struct dvb_net_ule_handle *h)
@@ -335,14 +334,14 @@ static int dvb_net_ule_new_ts_cell(struct dvb_net_ule_handle *h)
 	/* We are about to process a new TS cell. */
 
 #ifdef ULE_DEBUG
-	if (h->ule_where >= &h->ule_hist[100*TS_SZ])
-		h->ule_where = h->ule_hist;
-	memcpy(h->ule_where, h->ts, TS_SZ);
-	if (h->ule_dump) {
-		hexdump(h->ule_where, TS_SZ);
-		h->ule_dump = 0;
+	if (ule_where >= &ule_hist[100*TS_SZ])
+		ule_where = ule_hist;
+	memcpy(ule_where, h->ts, TS_SZ);
+	if (ule_dump) {
+		hexdump(ule_where, TS_SZ);
+		ule_dump = 0;
 	}
-	h->ule_where += TS_SZ;
+	ule_where += TS_SZ;
 #endif
 
 	/*
@@ -659,7 +658,7 @@ static int dvb_net_ule_should_drop(struct dvb_net_ule_handle *h)
 }
 
 
-static void dvb_net_ule_check_crc(struct dvb_net_ule_handle *h,
+static void dvb_net_ule_check_crc(struct dvb_net_ule_handle *h, struct kvec iov[3],
 				  u32 ule_crc, u32 expected_crc)
 {
 	u8 dest_addr[ETH_ALEN];
@@ -677,17 +676,17 @@ static void dvb_net_ule_check_crc(struct dvb_net_ule_handle *h,
 		hexdump(iov[1].iov_base, iov[1].iov_len);
 		hexdump(iov[2].iov_base, iov[2].iov_len);
 
-		if (h->ule_where == h->ule_hist) {
-			hexdump(&h->ule_hist[98*TS_SZ], TS_SZ);
-			hexdump(&h->ule_hist[99*TS_SZ], TS_SZ);
-		} else if (h->ule_where == &h->ule_hist[TS_SZ]) {
-			hexdump(&h->ule_hist[99*TS_SZ], TS_SZ);
-			hexdump(h->ule_hist, TS_SZ);
+		if (ule_where == ule_hist) {
+			hexdump(&ule_hist[98*TS_SZ], TS_SZ);
+			hexdump(&ule_hist[99*TS_SZ], TS_SZ);
+		} else if (ule_where == &ule_hist[TS_SZ]) {
+			hexdump(&ule_hist[99*TS_SZ], TS_SZ);
+			hexdump(ule_hist, TS_SZ);
 		} else {
-			hexdump(h->ule_where - TS_SZ - TS_SZ, TS_SZ);
-			hexdump(h->ule_where - TS_SZ, TS_SZ);
+			hexdump(ule_where - TS_SZ - TS_SZ, TS_SZ);
+			hexdump(ule_where - TS_SZ, TS_SZ);
 		}
-		h->ule_dump = 1;
+		ule_dump = 1;
 	#endif
 
 		h->dev->stats.rx_errors++;
@@ -779,6 +778,8 @@ static void dvb_net_ule(struct net_device *dev, const u8 *buf, size_t buf_len)
 	int ret;
 	struct dvb_net_ule_handle h = {
 		.dev = dev,
+		.priv = netdev_priv(dev),
+		.ethh = NULL,
 		.buf = buf,
 		.buf_len = buf_len,
 		.skipped = 0L,
@@ -788,11 +789,7 @@ static void dvb_net_ule(struct net_device *dev, const u8 *buf, size_t buf_len)
 		.ts_remain = 0,
 		.how_much = 0,
 		.new_ts = 1,
-		.ethh = NULL,
 		.error = false,
-#ifdef ULE_DEBUG
-		.ule_where = ule_hist,
-#endif
 	};
 
 	/*
@@ -860,7 +857,7 @@ static void dvb_net_ule(struct net_device *dev, const u8 *buf, size_t buf_len)
 				       *(tail - 2) << 8 |
 				       *(tail - 1);
 
-			dvb_net_ule_check_crc(&h, ule_crc, expected_crc);
+			dvb_net_ule_check_crc(&h, iov, ule_crc, expected_crc);
 
 			/* Prepare for next SNDU. */
 			reset_ule(h.priv);
-- 
2.14.3
