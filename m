Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:33422 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933998AbaICWoH (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 3 Sep 2014 18:44:07 -0400
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH 2/5] [media] tuner-xc2028: fix bad alignments
Date: Wed,  3 Sep 2014 19:43:52 -0300
Message-Id: <c56019fc40c5b7a7b3aa7be7f17c6b993cd853b5.1409784200.git.m.chehab@samsung.com>
In-Reply-To: <97e0e1e867952d369f245fce0d6791eacb40b2bb.1409784200.git.m.chehab@samsung.com>
References: <97e0e1e867952d369f245fce0d6791eacb40b2bb.1409784200.git.m.chehab@samsung.com>
In-Reply-To: <97e0e1e867952d369f245fce0d6791eacb40b2bb.1409784200.git.m.chehab@samsung.com>
References: <97e0e1e867952d369f245fce0d6791eacb40b2bb.1409784200.git.m.chehab@samsung.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

As reported by cocinelle:

drivers/media/tuners/tuner-xc2028.c:182:2-18: code aligned with following code on line 183
drivers/media/tuners/tuner-xc2028.c:184:2-19: code aligned with following code on line 185
drivers/media/tuners/tuner-xc2028.c:186:2-19: code aligned with following code on line 187
drivers/media/tuners/tuner-xc2028.c:188:2-17: code aligned with following code on line 189
drivers/media/tuners/tuner-xc2028.c:190:2-19: code aligned with following code on line 191
drivers/media/tuners/tuner-xc2028.c:192:2-19: code aligned with following code on line 193
drivers/media/tuners/tuner-xc2028.c:194:2-18: code aligned with following code on line 195
drivers/media/tuners/tuner-xc2028.c:196:2-17: code aligned with following code on line 197
drivers/media/tuners/tuner-xc2028.c:198:2-18: code aligned with following code on line 199
drivers/media/tuners/tuner-xc2028.c:200:2-19: code aligned with following code on line 201
drivers/media/tuners/tuner-xc2028.c:202:2-18: code aligned with following code on line 203
drivers/media/tuners/tuner-xc2028.c:204:2-16: code aligned with following code on line 205
drivers/media/tuners/tuner-xc2028.c:206:2-20: code aligned with following code on line 207
drivers/media/tuners/tuner-xc2028.c:208:2-17: code aligned with following code on line 209
drivers/media/tuners/tuner-xc2028.c:210:2-18: code aligned with following code on line 211
drivers/media/tuners/tuner-xc2028.c:212:2-18: code aligned with following code on line 213
drivers/media/tuners/tuner-xc2028.c:214:2-18: code aligned with following code on line 215
drivers/media/tuners/tuner-xc2028.c:216:2-16: code aligned with following code on line 217
drivers/media/tuners/tuner-xc2028.c:218:2-18: code aligned with following code on line 219
drivers/media/tuners/tuner-xc2028.c:220:2-20: code aligned with following code on line 221
drivers/media/tuners/tuner-xc2028.c:222:2-21: code aligned with following code on line 223
drivers/media/tuners/tuner-xc2028.c:224:2-20: code aligned with following code on line 225
drivers/media/tuners/tuner-xc2028.c:226:2-23: code aligned with following code on line 227
drivers/media/tuners/tuner-xc2028.c:228:2-23: code aligned with following code on line 229
drivers/media/tuners/tuner-xc2028.c:230:2-22: code aligned with following code on line 231
drivers/media/tuners/tuner-xc2028.c:232:2-24: code aligned with following code on line 233
drivers/media/tuners/tuner-xc2028.c:234:2-19: code aligned with following code on line 235
drivers/media/tuners/tuner-xc2028.c:236:2-19: code aligned with following code on line 237
drivers/media/tuners/tuner-xc2028.c:238:2-20: code aligned with following code on line 239
drivers/media/tuners/tuner-xc2028.c:240:2-19: code aligned with following code on line 241

Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>

diff --git a/drivers/media/tuners/tuner-xc2028.c b/drivers/media/tuners/tuner-xc2028.c
index 565eeebb3aeb..d12f5e4ad8bf 100644
--- a/drivers/media/tuners/tuner-xc2028.c
+++ b/drivers/media/tuners/tuner-xc2028.c
@@ -178,67 +178,67 @@ static int xc2028_get_reg(struct xc2028_data *priv, u16 reg, u16 *val)
 #define dump_firm_type(t) 	dump_firm_type_and_int_freq(t, 0)
 static void dump_firm_type_and_int_freq(unsigned int type, u16 int_freq)
 {
-	 if (type & BASE)
+	if (type & BASE)
 		printk("BASE ");
-	 if (type & INIT1)
+	if (type & INIT1)
 		printk("INIT1 ");
-	 if (type & F8MHZ)
+	if (type & F8MHZ)
 		printk("F8MHZ ");
-	 if (type & MTS)
+	if (type & MTS)
 		printk("MTS ");
-	 if (type & D2620)
+	if (type & D2620)
 		printk("D2620 ");
-	 if (type & D2633)
+	if (type & D2633)
 		printk("D2633 ");
-	 if (type & DTV6)
+	if (type & DTV6)
 		printk("DTV6 ");
-	 if (type & QAM)
+	if (type & QAM)
 		printk("QAM ");
-	 if (type & DTV7)
+	if (type & DTV7)
 		printk("DTV7 ");
-	 if (type & DTV78)
+	if (type & DTV78)
 		printk("DTV78 ");
-	 if (type & DTV8)
+	if (type & DTV8)
 		printk("DTV8 ");
-	 if (type & FM)
+	if (type & FM)
 		printk("FM ");
-	 if (type & INPUT1)
+	if (type & INPUT1)
 		printk("INPUT1 ");
-	 if (type & LCD)
+	if (type & LCD)
 		printk("LCD ");
-	 if (type & NOGD)
+	if (type & NOGD)
 		printk("NOGD ");
-	 if (type & MONO)
+	if (type & MONO)
 		printk("MONO ");
-	 if (type & ATSC)
+	if (type & ATSC)
 		printk("ATSC ");
-	 if (type & IF)
+	if (type & IF)
 		printk("IF ");
-	 if (type & LG60)
+	if (type & LG60)
 		printk("LG60 ");
-	 if (type & ATI638)
+	if (type & ATI638)
 		printk("ATI638 ");
-	 if (type & OREN538)
+	if (type & OREN538)
 		printk("OREN538 ");
-	 if (type & OREN36)
+	if (type & OREN36)
 		printk("OREN36 ");
-	 if (type & TOYOTA388)
+	if (type & TOYOTA388)
 		printk("TOYOTA388 ");
-	 if (type & TOYOTA794)
+	if (type & TOYOTA794)
 		printk("TOYOTA794 ");
-	 if (type & DIBCOM52)
+	if (type & DIBCOM52)
 		printk("DIBCOM52 ");
-	 if (type & ZARLINK456)
+	if (type & ZARLINK456)
 		printk("ZARLINK456 ");
-	 if (type & CHINA)
+	if (type & CHINA)
 		printk("CHINA ");
-	 if (type & F6MHZ)
+	if (type & F6MHZ)
 		printk("F6MHZ ");
-	 if (type & INPUT2)
+	if (type & INPUT2)
 		printk("INPUT2 ");
-	 if (type & SCODE)
+	if (type & SCODE)
 		printk("SCODE ");
-	 if (type & HAS_IF)
+	if (type & HAS_IF)
 		printk("HAS_IF_%d ", int_freq);
 }
 
-- 
1.9.3

