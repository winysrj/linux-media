Return-path: <linux-media-owner@vger.kernel.org>
Received: from osg.samsung.com ([64.30.133.232]:47233 "EHLO osg.samsung.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752628AbdLKQhf (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 11 Dec 2017 11:37:35 -0500
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Ron Economos <w6rz@comcast.net>,
        "David S. Miller" <davem@davemloft.net>,
        Johannes Berg <johannes.berg@intel.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 3/3] media: dvb-core: allow users to enable DVB net ULE debug
Date: Mon, 11 Dec 2017 11:37:26 -0500
Message-Id: <8359d14bcceb7516aeabfcaa518c134078132751.1513010227.git.mchehab@s-opensource.com>
In-Reply-To: <3749c9084b647a3ca80e78a9f5a3bd83ecb1e4cb.1513010227.git.mchehab@s-opensource.com>
References: <3749c9084b647a3ca80e78a9f5a3bd83ecb1e4cb.1513010227.git.mchehab@s-opensource.com>
In-Reply-To: <3749c9084b647a3ca80e78a9f5a3bd83ecb1e4cb.1513010227.git.mchehab@s-opensource.com>
References: <3749c9084b647a3ca80e78a9f5a3bd83ecb1e4cb.1513010227.git.mchehab@s-opensource.com>
To: unlisted-recipients:; (no To-header on input)@bombadil.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This debug option is there for a long time, but it is only
enabled by editing the source code. Due to that, a breakage
inside its code was only noticed years after a change at
the ULE handling logic.

Make it a Kconfig parameter, as it makes easier for
advanced users to enable, and allow test if the compilation
won't be broken in the future.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 drivers/media/dvb-core/Kconfig   | 13 +++++++++++++
 drivers/media/dvb-core/dvb_net.c | 14 +++++---------
 2 files changed, 18 insertions(+), 9 deletions(-)

diff --git a/drivers/media/dvb-core/Kconfig b/drivers/media/dvb-core/Kconfig
index eeef94a0c84e..f004aea352e0 100644
--- a/drivers/media/dvb-core/Kconfig
+++ b/drivers/media/dvb-core/Kconfig
@@ -40,3 +40,16 @@ config DVB_DEMUX_SECTION_LOSS_LOG
 	  be very verbose.
 
 	  If you are unsure about this, say N here.
+
+config DVB_ULE_DEBUG
+	bool "Enable DVB net ULE packet debug messages"
+	depends on DVB_CORE
+	default n
+	help
+	  Enable extra log messages meant to detect problems while
+	  handling DVB network ULE packet loss inside the Kernel.
+
+	  Should not be enabled on normal cases, as logs can
+	  be very verbose.
+
+	  If you are unsure about this, say N here.
diff --git a/drivers/media/dvb-core/dvb_net.c b/drivers/media/dvb-core/dvb_net.c
index bf0bea5c21c1..d8adc968cbf2 100644
--- a/drivers/media/dvb-core/dvb_net.c
+++ b/drivers/media/dvb-core/dvb_net.c
@@ -38,7 +38,7 @@
  *                       Competence Center for Advanced Satellite Communications.
  *                     Bugfixes and robustness improvements.
  *                     Filtering on dest MAC addresses, if present (D-Bit = 0)
- *                     ULE_DEBUG compile-time option.
+ *                     DVB_ULE_DEBUG compile-time option.
  * Apr 2006: cp v3:    Bugfixes and compliency with RFC 4326 (ULE) by
  *                       Christian Praehauser <cpraehaus@cosy.sbg.ac.at>,
  *                       Paris Lodron University of Salzburg.
@@ -78,12 +78,9 @@ static inline __u32 iov_crc32( __u32 c, struct kvec *iov, unsigned int cnt )
 
 #define DVB_NET_MULTICAST_MAX 10
 
-#undef ULE_DEBUG
-
-#ifdef ULE_DEBUG
-
+#ifdef DVB_ULE_DEBUG
 /*
- * The code inside ULE_DEBUG keeps a history of the
+ * The code inside DVB_ULE_DEBUG keeps a history of the
  * last 100 TS cells processed.
  */
 static unsigned char ule_hist[100*TS_SZ] = { 0 };
@@ -93,7 +90,6 @@ static void hexdump(const unsigned char *buf, unsigned short len)
 {
 	print_hex_dump_debug("", DUMP_PREFIX_OFFSET, 16, 1, buf, len, true);
 }
-
 #endif
 
 struct dvb_net_priv {
@@ -331,7 +327,7 @@ static int dvb_net_ule_new_ts_cell(struct dvb_net_ule_handle *h)
 {
 	/* We are about to process a new TS cell. */
 
-#ifdef ULE_DEBUG
+#ifdef DVB_ULE_DEBUG
 	if (ule_where >= &ule_hist[100*TS_SZ])
 		ule_where = ule_hist;
 	memcpy(ule_where, h->ts, TS_SZ);
@@ -669,7 +665,7 @@ static void dvb_net_ule_check_crc(struct dvb_net_ule_handle *h, struct kvec iov[
 			h->ts_remain > 2 ?
 				*(unsigned short *)h->from_where : 0);
 
-	#ifdef ULE_DEBUG
+	#ifdef DVB_ULE_DEBUG
 		hexdump(iov[0].iov_base, iov[0].iov_len);
 		hexdump(iov[1].iov_base, iov[1].iov_len);
 		hexdump(iov[2].iov_base, iov[2].iov_len);
-- 
2.14.3
