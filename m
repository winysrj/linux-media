Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:48627 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754653AbcJNRrG (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 14 Oct 2016 13:47:06 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Subject: [PATCH 25/25] [media] nxt6000: use pr_foo() macros instead of printk()
Date: Fri, 14 Oct 2016 14:46:03 -0300
Message-Id: <1f22b75d204b912d67f8e3a2dea4a47cbe222ace.1476466574.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1476466574.git.mchehab@s-opensource.com>
References: <cover.1476466574.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1476466574.git.mchehab@s-opensource.com>
References: <cover.1476466574.git.mchehab@s-opensource.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Replace printk() macros by their pr_foo() counterparts and
use pr_cont() for the continuation lines.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 drivers/media/dvb-frontends/nxt6000.c | 136 +++++++++++++++++++---------------
 1 file changed, 76 insertions(+), 60 deletions(-)

diff --git a/drivers/media/dvb-frontends/nxt6000.c b/drivers/media/dvb-frontends/nxt6000.c
index 73f9505367ac..1545d898b125 100644
--- a/drivers/media/dvb-frontends/nxt6000.c
+++ b/drivers/media/dvb-frontends/nxt6000.c
@@ -19,6 +19,8 @@
     Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
 */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/init.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
@@ -39,7 +41,11 @@ struct nxt6000_state {
 };
 
 static int debug;
-#define dprintk if (debug) printk
+#define dprintk(fmt, arg...) do {					\
+	if (debug)							\
+		printk(KERN_DEBUG pr_fmt("%s: " fmt),			\
+		       __func__, ##arg);				\
+} while (0)
 
 static int nxt6000_writereg(struct nxt6000_state* state, u8 reg, u8 data)
 {
@@ -215,119 +221,129 @@ static void nxt6000_dump_status(struct nxt6000_state *state)
 {
 	u8 val;
 
-/*
-	printk("RS_COR_STAT: 0x%02X\n", nxt6000_readreg(fe, RS_COR_STAT));
-	printk("VIT_SYNC_STATUS: 0x%02X\n", nxt6000_readreg(fe, VIT_SYNC_STATUS));
-	printk("OFDM_COR_STAT: 0x%02X\n", nxt6000_readreg(fe, OFDM_COR_STAT));
-	printk("OFDM_SYR_STAT: 0x%02X\n", nxt6000_readreg(fe, OFDM_SYR_STAT));
-	printk("OFDM_TPS_RCVD_1: 0x%02X\n", nxt6000_readreg(fe, OFDM_TPS_RCVD_1));
-	printk("OFDM_TPS_RCVD_2: 0x%02X\n", nxt6000_readreg(fe, OFDM_TPS_RCVD_2));
-	printk("OFDM_TPS_RCVD_3: 0x%02X\n", nxt6000_readreg(fe, OFDM_TPS_RCVD_3));
-	printk("OFDM_TPS_RCVD_4: 0x%02X\n", nxt6000_readreg(fe, OFDM_TPS_RCVD_4));
-	printk("OFDM_TPS_RESERVED_1: 0x%02X\n", nxt6000_readreg(fe, OFDM_TPS_RESERVED_1));
-	printk("OFDM_TPS_RESERVED_2: 0x%02X\n", nxt6000_readreg(fe, OFDM_TPS_RESERVED_2));
-*/
-	printk("NXT6000 status:");
+#if 0
+	pr_info("RS_COR_STAT: 0x%02X\n",
+		nxt6000_readreg(fe, RS_COR_STAT));
+	pr_info("VIT_SYNC_STATUS: 0x%02X\n",
+		nxt6000_readreg(fe, VIT_SYNC_STATUS));
+	pr_info("OFDM_COR_STAT: 0x%02X\n",
+		nxt6000_readreg(fe, OFDM_COR_STAT));
+	pr_info("OFDM_SYR_STAT: 0x%02X\n",
+		nxt6000_readreg(fe, OFDM_SYR_STAT));
+	pr_info("OFDM_TPS_RCVD_1: 0x%02X\n",
+		nxt6000_readreg(fe, OFDM_TPS_RCVD_1));
+	pr_info("OFDM_TPS_RCVD_2: 0x%02X\n",
+		nxt6000_readreg(fe, OFDM_TPS_RCVD_2));
+	pr_info("OFDM_TPS_RCVD_3: 0x%02X\n",
+		nxt6000_readreg(fe, OFDM_TPS_RCVD_3));
+	pr_info("OFDM_TPS_RCVD_4: 0x%02X\n",
+		nxt6000_readreg(fe, OFDM_TPS_RCVD_4));
+	pr_info("OFDM_TPS_RESERVED_1: 0x%02X\n",
+		nxt6000_readreg(fe, OFDM_TPS_RESERVED_1));
+	pr_info("OFDM_TPS_RESERVED_2: 0x%02X\n",
+		nxt6000_readreg(fe, OFDM_TPS_RESERVED_2));
+#endif
+	pr_info("NXT6000 status:");
 
 	val = nxt6000_readreg(state, RS_COR_STAT);
 
-	printk(" DATA DESCR LOCK: %d,", val & 0x01);
-	printk(" DATA SYNC LOCK: %d,", (val >> 1) & 0x01);
+	pr_cont(" DATA DESCR LOCK: %d,", val & 0x01);
+	pr_cont(" DATA SYNC LOCK: %d,", (val >> 1) & 0x01);
 
 	val = nxt6000_readreg(state, VIT_SYNC_STATUS);
 
-	printk(" VITERBI LOCK: %d,", (val >> 7) & 0x01);
+	pr_cont(" VITERBI LOCK: %d,", (val >> 7) & 0x01);
 
 	switch ((val >> 4) & 0x07) {
 
 	case 0x00:
-		printk(" VITERBI CODERATE: 1/2,");
+		pr_cont(" VITERBI CODERATE: 1/2,");
 		break;
 
 	case 0x01:
-		printk(" VITERBI CODERATE: 2/3,");
+		pr_cont(" VITERBI CODERATE: 2/3,");
 		break;
 
 	case 0x02:
-		printk(" VITERBI CODERATE: 3/4,");
+		pr_cont(" VITERBI CODERATE: 3/4,");
 		break;
 
 	case 0x03:
-		printk(" VITERBI CODERATE: 5/6,");
+		pr_cont(" VITERBI CODERATE: 5/6,");
 		break;
 
 	case 0x04:
-		printk(" VITERBI CODERATE: 7/8,");
+		pr_cont(" VITERBI CODERATE: 7/8,");
 		break;
 
 	default:
-		printk(" VITERBI CODERATE: Reserved,");
+		pr_cont(" VITERBI CODERATE: Reserved,");
 
 	}
 
 	val = nxt6000_readreg(state, OFDM_COR_STAT);
 
-	printk(" CHCTrack: %d,", (val >> 7) & 0x01);
-	printk(" TPSLock: %d,", (val >> 6) & 0x01);
-	printk(" SYRLock: %d,", (val >> 5) & 0x01);
-	printk(" AGCLock: %d,", (val >> 4) & 0x01);
+	pr_cont(" CHCTrack: %d,", (val >> 7) & 0x01);
+	pr_cont(" TPSLock: %d,", (val >> 6) & 0x01);
+	pr_cont(" SYRLock: %d,", (val >> 5) & 0x01);
+	pr_cont(" AGCLock: %d,", (val >> 4) & 0x01);
 
 	switch (val & 0x0F) {
 
 	case 0x00:
-		printk(" CoreState: IDLE,");
+		pr_cont(" CoreState: IDLE,");
 		break;
 
 	case 0x02:
-		printk(" CoreState: WAIT_AGC,");
+		pr_cont(" CoreState: WAIT_AGC,");
 		break;
 
 	case 0x03:
-		printk(" CoreState: WAIT_SYR,");
+		pr_cont(" CoreState: WAIT_SYR,");
 		break;
 
 	case 0x04:
-		printk(" CoreState: WAIT_PPM,");
+		pr_cont(" CoreState: WAIT_PPM,");
 		break;
 
 	case 0x01:
-		printk(" CoreState: WAIT_TRL,");
+		pr_cont(" CoreState: WAIT_TRL,");
 		break;
 
 	case 0x05:
-		printk(" CoreState: WAIT_TPS,");
+		pr_cont(" CoreState: WAIT_TPS,");
 		break;
 
 	case 0x06:
-		printk(" CoreState: MONITOR_TPS,");
+		pr_cont(" CoreState: MONITOR_TPS,");
 		break;
 
 	default:
-		printk(" CoreState: Reserved,");
+		pr_cont(" CoreState: Reserved,");
 
 	}
 
 	val = nxt6000_readreg(state, OFDM_SYR_STAT);
 
-	printk(" SYRLock: %d,", (val >> 4) & 0x01);
-	printk(" SYRMode: %s,", (val >> 2) & 0x01 ? "8K" : "2K");
+	pr_cont(" SYRLock: %d,", (val >> 4) & 0x01);
+	pr_cont(" SYRMode: %s,", (val >> 2) & 0x01 ? "8K" : "2K");
 
 	switch ((val >> 4) & 0x03) {
 
 	case 0x00:
-		printk(" SYRGuard: 1/32,");
+		pr_cont(" SYRGuard: 1/32,");
 		break;
 
 	case 0x01:
-		printk(" SYRGuard: 1/16,");
+		pr_cont(" SYRGuard: 1/16,");
 		break;
 
 	case 0x02:
-		printk(" SYRGuard: 1/8,");
+		pr_cont(" SYRGuard: 1/8,");
 		break;
 
 	case 0x03:
-		printk(" SYRGuard: 1/4,");
+		pr_cont(" SYRGuard: 1/4,");
 		break;
 	}
 
@@ -336,77 +352,77 @@ static void nxt6000_dump_status(struct nxt6000_state *state)
 	switch ((val >> 4) & 0x07) {
 
 	case 0x00:
-		printk(" TPSLP: 1/2,");
+		pr_cont(" TPSLP: 1/2,");
 		break;
 
 	case 0x01:
-		printk(" TPSLP: 2/3,");
+		pr_cont(" TPSLP: 2/3,");
 		break;
 
 	case 0x02:
-		printk(" TPSLP: 3/4,");
+		pr_cont(" TPSLP: 3/4,");
 		break;
 
 	case 0x03:
-		printk(" TPSLP: 5/6,");
+		pr_cont(" TPSLP: 5/6,");
 		break;
 
 	case 0x04:
-		printk(" TPSLP: 7/8,");
+		pr_cont(" TPSLP: 7/8,");
 		break;
 
 	default:
-		printk(" TPSLP: Reserved,");
+		pr_cont(" TPSLP: Reserved,");
 
 	}
 
 	switch (val & 0x07) {
 
 	case 0x00:
-		printk(" TPSHP: 1/2,");
+		pr_cont(" TPSHP: 1/2,");
 		break;
 
 	case 0x01:
-		printk(" TPSHP: 2/3,");
+		pr_cont(" TPSHP: 2/3,");
 		break;
 
 	case 0x02:
-		printk(" TPSHP: 3/4,");
+		pr_cont(" TPSHP: 3/4,");
 		break;
 
 	case 0x03:
-		printk(" TPSHP: 5/6,");
+		pr_cont(" TPSHP: 5/6,");
 		break;
 
 	case 0x04:
-		printk(" TPSHP: 7/8,");
+		pr_cont(" TPSHP: 7/8,");
 		break;
 
 	default:
-		printk(" TPSHP: Reserved,");
+		pr_cont(" TPSHP: Reserved,");
 
 	}
 
 	val = nxt6000_readreg(state, OFDM_TPS_RCVD_4);
 
-	printk(" TPSMode: %s,", val & 0x01 ? "8K" : "2K");
+	pr_cont(" TPSMode: %s,", val & 0x01 ? "8K" : "2K");
 
 	switch ((val >> 4) & 0x03) {
 
 	case 0x00:
-		printk(" TPSGuard: 1/32,");
+		pr_cont(" TPSGuard: 1/32,");
 		break;
 
 	case 0x01:
-		printk(" TPSGuard: 1/16,");
+		pr_cont(" TPSGuard: 1/16,");
 		break;
 
 	case 0x02:
-		printk(" TPSGuard: 1/8,");
+		pr_cont(" TPSGuard: 1/8,");
 		break;
 
 	case 0x03:
-		printk(" TPSGuard: 1/4,");
+		pr_cont(" TPSGuard: 1/4,");
 		break;
 
 	}
@@ -416,8 +432,8 @@ static void nxt6000_dump_status(struct nxt6000_state *state)
 	val = nxt6000_readreg(state, RF_AGC_STATUS);
 	val = nxt6000_readreg(state, RF_AGC_STATUS);
 
-	printk(" RF AGC LOCK: %d,", (val >> 4) & 0x01);
-	printk("\n");
+	pr_cont(" RF AGC LOCK: %d,", (val >> 4) & 0x01);
+	pr_cont("\n");
 }
 
 static int nxt6000_read_status(struct dvb_frontend *fe, enum fe_status *status)
-- 
2.7.4


