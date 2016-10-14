Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:48596 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754157AbcJNRrE (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 14 Oct 2016 13:47:04 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Subject: [PATCH 01/25] [media] tuner-xc2028: mark printk continuation lines as such
Date: Fri, 14 Oct 2016 14:45:39 -0300
Message-Id: <4e8c4f5aef76263c5f98fd2baac8fa0868a96938.1476466574.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1476466574.git.mchehab@s-opensource.com>
References: <cover.1476466574.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1476466574.git.mchehab@s-opensource.com>
References: <cover.1476466574.git.mchehab@s-opensource.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This driver has a lot of printk continuation lines for
debugging purposes. Since commit 563873318d32
("Merge branch 'printk-cleanups"), this won't work as expected
anymore. So, let's add KERN_CONT to those lines.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 drivers/media/tuners/tuner-xc2028.c | 93 +++++++++++++++++++------------------
 1 file changed, 48 insertions(+), 45 deletions(-)

diff --git a/drivers/media/tuners/tuner-xc2028.c b/drivers/media/tuners/tuner-xc2028.c
index 317ef63ee789..55f6c858b9c3 100644
--- a/drivers/media/tuners/tuner-xc2028.c
+++ b/drivers/media/tuners/tuner-xc2028.c
@@ -179,67 +179,67 @@ static int xc2028_get_reg(struct xc2028_data *priv, u16 reg, u16 *val)
 static void dump_firm_type_and_int_freq(unsigned int type, u16 int_freq)
 {
 	if (type & BASE)
-		printk("BASE ");
+		printk(KERN_CONT "BASE ");
 	if (type & INIT1)
-		printk("INIT1 ");
+		printk(KERN_CONT "INIT1 ");
 	if (type & F8MHZ)
-		printk("F8MHZ ");
+		printk(KERN_CONT "F8MHZ ");
 	if (type & MTS)
-		printk("MTS ");
+		printk(KERN_CONT "MTS ");
 	if (type & D2620)
-		printk("D2620 ");
+		printk(KERN_CONT "D2620 ");
 	if (type & D2633)
-		printk("D2633 ");
+		printk(KERN_CONT "D2633 ");
 	if (type & DTV6)
-		printk("DTV6 ");
+		printk(KERN_CONT "DTV6 ");
 	if (type & QAM)
-		printk("QAM ");
+		printk(KERN_CONT "QAM ");
 	if (type & DTV7)
-		printk("DTV7 ");
+		printk(KERN_CONT "DTV7 ");
 	if (type & DTV78)
-		printk("DTV78 ");
+		printk(KERN_CONT "DTV78 ");
 	if (type & DTV8)
-		printk("DTV8 ");
+		printk(KERN_CONT "DTV8 ");
 	if (type & FM)
-		printk("FM ");
+		printk(KERN_CONT "FM ");
 	if (type & INPUT1)
-		printk("INPUT1 ");
+		printk(KERN_CONT "INPUT1 ");
 	if (type & LCD)
-		printk("LCD ");
+		printk(KERN_CONT "LCD ");
 	if (type & NOGD)
-		printk("NOGD ");
+		printk(KERN_CONT "NOGD ");
 	if (type & MONO)
-		printk("MONO ");
+		printk(KERN_CONT "MONO ");
 	if (type & ATSC)
-		printk("ATSC ");
+		printk(KERN_CONT "ATSC ");
 	if (type & IF)
-		printk("IF ");
+		printk(KERN_CONT "IF ");
 	if (type & LG60)
-		printk("LG60 ");
+		printk(KERN_CONT "LG60 ");
 	if (type & ATI638)
-		printk("ATI638 ");
+		printk(KERN_CONT "ATI638 ");
 	if (type & OREN538)
-		printk("OREN538 ");
+		printk(KERN_CONT "OREN538 ");
 	if (type & OREN36)
-		printk("OREN36 ");
+		printk(KERN_CONT "OREN36 ");
 	if (type & TOYOTA388)
-		printk("TOYOTA388 ");
+		printk(KERN_CONT "TOYOTA388 ");
 	if (type & TOYOTA794)
-		printk("TOYOTA794 ");
+		printk(KERN_CONT "TOYOTA794 ");
 	if (type & DIBCOM52)
-		printk("DIBCOM52 ");
+		printk(KERN_CONT "DIBCOM52 ");
 	if (type & ZARLINK456)
-		printk("ZARLINK456 ");
+		printk(KERN_CONT "ZARLINK456 ");
 	if (type & CHINA)
-		printk("CHINA ");
+		printk(KERN_CONT "CHINA ");
 	if (type & F6MHZ)
-		printk("F6MHZ ");
+		printk(KERN_CONT "F6MHZ ");
 	if (type & INPUT2)
-		printk("INPUT2 ");
+		printk(KERN_CONT "INPUT2 ");
 	if (type & SCODE)
-		printk("SCODE ");
+		printk(KERN_CONT "SCODE ");
 	if (type & HAS_IF)
-		printk("HAS_IF_%d ", int_freq);
+		printk(KERN_CONT "HAS_IF_%d ", int_freq);
 }
 
 static  v4l2_std_id parse_audio_std_option(void)
@@ -374,8 +374,8 @@ static int load_all_firmwares(struct dvb_frontend *fe,
 		if (!size || size > endp - p) {
 			tuner_err("Firmware type ");
 			dump_firm_type(type);
-			printk("(%x), id %llx is corrupted "
-			       "(size=%d, expected %d)\n",
+			printk(KERN_CONT
+			       "(%x), id %llx is corrupted (size=%d, expected %d)\n",
 			       type, (unsigned long long)id,
 			       (unsigned)(endp - p), size);
 			goto corrupt;
@@ -390,7 +390,7 @@ static int load_all_firmwares(struct dvb_frontend *fe,
 		tuner_dbg("Reading firmware type ");
 		if (debug) {
 			dump_firm_type_and_int_freq(type, int_freq);
-			printk("(%x), id %llx, size=%d.\n",
+			printk(KERN_CONT "(%x), id %llx, size=%d.\n",
 			       type, (unsigned long long)id, size);
 		}
 
@@ -439,7 +439,8 @@ static int seek_firmware(struct dvb_frontend *fe, unsigned int type,
 	tuner_dbg("%s called, want type=", __func__);
 	if (debug) {
 		dump_firm_type(type);
-		printk("(%x), id %016llx.\n", type, (unsigned long long)*id);
+		printk(KERN_CONT "(%x), id %016llx.\n",
+		       type, (unsigned long long)*id);
 	}
 
 	if (!priv->firm) {
@@ -498,7 +499,8 @@ static int seek_firmware(struct dvb_frontend *fe, unsigned int type,
 		tuner_dbg("Selecting best matching firmware (%d bits) for "
 			  "type=", best_nr_matches);
 		dump_firm_type(type);
-		printk("(%x), id %016llx:\n", type, (unsigned long long)*id);
+		printk(KERN_CONT
+		       "(%x), id %016llx:\n", type, (unsigned long long)*id);
 		i = best_i;
 		goto found;
 	}
@@ -515,7 +517,8 @@ static int seek_firmware(struct dvb_frontend *fe, unsigned int type,
 	tuner_dbg("%s firmware for type=", (i < 0) ? "Can't find" : "Found");
 	if (debug) {
 		dump_firm_type(type);
-		printk("(%x), id %016llx.\n", type, (unsigned long long)*id);
+		printk(KERN_CONT "(%x), id %016llx.\n",
+		       type, (unsigned long long)*id);
 	}
 	return i;
 }
@@ -555,8 +558,8 @@ static int load_firmware(struct dvb_frontend *fe, unsigned int type,
 
 	tuner_info("Loading firmware for type=");
 	dump_firm_type(priv->firm[pos].type);
-	printk("(%x), id %016llx.\n", priv->firm[pos].type,
-	       (unsigned long long)*id);
+	printk(KERN_CONT "(%x), id %016llx.\n",
+	       priv->firm[pos].type, (unsigned long long)*id);
 
 	p = priv->firm[pos].ptr;
 	endp = p + priv->firm[pos].size;
@@ -689,7 +692,7 @@ static int load_scode(struct dvb_frontend *fe, unsigned int type,
 	tuner_info("Loading SCODE for type=");
 	dump_firm_type_and_int_freq(priv->firm[pos].type,
 				    priv->firm[pos].int_freq);
-	printk("(%x), id %016llx.\n", priv->firm[pos].type,
+	printk(KERN_CONT "(%x), id %016llx.\n", priv->firm[pos].type,
 	       (unsigned long long)*id);
 
 	if (priv->firm_version < 0x0202)
@@ -741,15 +744,15 @@ static int check_firmware(struct dvb_frontend *fe, unsigned int type,
 	tuner_dbg("checking firmware, user requested type=");
 	if (debug) {
 		dump_firm_type(new_fw.type);
-		printk("(%x), id %016llx, ", new_fw.type,
+		printk(KERN_CONT "(%x), id %016llx, ", new_fw.type,
 		       (unsigned long long)new_fw.std_req);
 		if (!int_freq) {
-			printk("scode_tbl ");
+			printk(KERN_CONT "scode_tbl ");
 			dump_firm_type(priv->ctrl.scode_table);
-			printk("(%x), ", priv->ctrl.scode_table);
+			printk(KERN_CONT "(%x), ", priv->ctrl.scode_table);
 		} else
-			printk("int_freq %d, ", new_fw.int_freq);
-		printk("scode_nr %d\n", new_fw.scode_nr);
+			printk(KERN_CONT "int_freq %d, ", new_fw.int_freq);
+		printk(KERN_CONT "scode_nr %d\n", new_fw.scode_nr);
 	}
 
 	/*
-- 
2.7.4


