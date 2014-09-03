Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:33423 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934340AbaICWoH (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 3 Sep 2014 18:44:07 -0400
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH 1/5] [media] xc4000: Fix bad alignments
Date: Wed,  3 Sep 2014 19:43:51 -0300
Message-Id: <97e0e1e867952d369f245fce0d6791eacb40b2bb.1409784200.git.m.chehab@samsung.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

As reported by cocinelle:

drivers/media/tuners/xc4000.c:573:2-28: code aligned with following code on line 574
drivers/media/tuners/xc4000.c:575:2-29: code aligned with following code on line 576
drivers/media/tuners/xc4000.c:577:2-29: code aligned with following code on line 578
drivers/media/tuners/xc4000.c:579:2-27: code aligned with following code on line 580
drivers/media/tuners/xc4000.c:581:2-29: code aligned with following code on line 582
drivers/media/tuners/xc4000.c:583:2-29: code aligned with following code on line 584
drivers/media/tuners/xc4000.c:585:2-28: code aligned with following code on line 586
drivers/media/tuners/xc4000.c:587:2-27: code aligned with following code on line 588
drivers/media/tuners/xc4000.c:589:2-28: code aligned with following code on line 590
drivers/media/tuners/xc4000.c:591:2-29: code aligned with following code on line 592
drivers/media/tuners/xc4000.c:593:2-28: code aligned with following code on line 594
drivers/media/tuners/xc4000.c:595:2-26: code aligned with following code on line 596
drivers/media/tuners/xc4000.c:597:2-30: code aligned with following code on line 598
drivers/media/tuners/xc4000.c:599:2-27: code aligned with following code on line 600
drivers/media/tuners/xc4000.c:601:2-28: code aligned with following code on line 602
drivers/media/tuners/xc4000.c:603:2-28: code aligned with following code on line 604
drivers/media/tuners/xc4000.c:605:2-28: code aligned with following code on line 606
drivers/media/tuners/xc4000.c:607:2-26: code aligned with following code on line 608
drivers/media/tuners/xc4000.c:609:2-28: code aligned with following code on line 610
drivers/media/tuners/xc4000.c:611:2-30: code aligned with following code on line 612
drivers/media/tuners/xc4000.c:613:2-31: code aligned with following code on line 614
drivers/media/tuners/xc4000.c:615:2-30: code aligned with following code on line 616
drivers/media/tuners/xc4000.c:617:2-33: code aligned with following code on line 618
drivers/media/tuners/xc4000.c:619:2-33: code aligned with following code on line 620
drivers/media/tuners/xc4000.c:621:2-32: code aligned with following code on line 622
drivers/media/tuners/xc4000.c:623:2-34: code aligned with following code on line 624
drivers/media/tuners/xc4000.c:625:2-29: code aligned with following code on line 626
drivers/media/tuners/xc4000.c:627:2-29: code aligned with following code on line 628
drivers/media/tuners/xc4000.c:629:2-30: code aligned with following code on line 630
drivers/media/tuners/xc4000.c:631:2-29: code aligned with following code on line 632

Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>

diff --git a/drivers/media/tuners/xc4000.c b/drivers/media/tuners/xc4000.c
index f9ab79e3432d..219ebafae70f 100644
--- a/drivers/media/tuners/xc4000.c
+++ b/drivers/media/tuners/xc4000.c
@@ -569,67 +569,67 @@ static int xc4000_readreg(struct xc4000_priv *priv, u16 reg, u16 *val)
 #define dump_firm_type(t)	dump_firm_type_and_int_freq(t, 0)
 static void dump_firm_type_and_int_freq(unsigned int type, u16 int_freq)
 {
-	 if (type & BASE)
+	if (type & BASE)
 		printk(KERN_CONT "BASE ");
-	 if (type & INIT1)
+	if (type & INIT1)
 		printk(KERN_CONT "INIT1 ");
-	 if (type & F8MHZ)
+	if (type & F8MHZ)
 		printk(KERN_CONT "F8MHZ ");
-	 if (type & MTS)
+	if (type & MTS)
 		printk(KERN_CONT "MTS ");
-	 if (type & D2620)
+	if (type & D2620)
 		printk(KERN_CONT "D2620 ");
-	 if (type & D2633)
+	if (type & D2633)
 		printk(KERN_CONT "D2633 ");
-	 if (type & DTV6)
+	if (type & DTV6)
 		printk(KERN_CONT "DTV6 ");
-	 if (type & QAM)
+	if (type & QAM)
 		printk(KERN_CONT "QAM ");
-	 if (type & DTV7)
+	if (type & DTV7)
 		printk(KERN_CONT "DTV7 ");
-	 if (type & DTV78)
+	if (type & DTV78)
 		printk(KERN_CONT "DTV78 ");
-	 if (type & DTV8)
+	if (type & DTV8)
 		printk(KERN_CONT "DTV8 ");
-	 if (type & FM)
+	if (type & FM)
 		printk(KERN_CONT "FM ");
-	 if (type & INPUT1)
+	if (type & INPUT1)
 		printk(KERN_CONT "INPUT1 ");
-	 if (type & LCD)
+	if (type & LCD)
 		printk(KERN_CONT "LCD ");
-	 if (type & NOGD)
+	if (type & NOGD)
 		printk(KERN_CONT "NOGD ");
-	 if (type & MONO)
+	if (type & MONO)
 		printk(KERN_CONT "MONO ");
-	 if (type & ATSC)
+	if (type & ATSC)
 		printk(KERN_CONT "ATSC ");
-	 if (type & IF)
+	if (type & IF)
 		printk(KERN_CONT "IF ");
-	 if (type & LG60)
+	if (type & LG60)
 		printk(KERN_CONT "LG60 ");
-	 if (type & ATI638)
+	if (type & ATI638)
 		printk(KERN_CONT "ATI638 ");
-	 if (type & OREN538)
+	if (type & OREN538)
 		printk(KERN_CONT "OREN538 ");
-	 if (type & OREN36)
+	if (type & OREN36)
 		printk(KERN_CONT "OREN36 ");
-	 if (type & TOYOTA388)
+	if (type & TOYOTA388)
 		printk(KERN_CONT "TOYOTA388 ");
-	 if (type & TOYOTA794)
+	if (type & TOYOTA794)
 		printk(KERN_CONT "TOYOTA794 ");
-	 if (type & DIBCOM52)
+	if (type & DIBCOM52)
 		printk(KERN_CONT "DIBCOM52 ");
-	 if (type & ZARLINK456)
+	if (type & ZARLINK456)
 		printk(KERN_CONT "ZARLINK456 ");
-	 if (type & CHINA)
+	if (type & CHINA)
 		printk(KERN_CONT "CHINA ");
-	 if (type & F6MHZ)
+	if (type & F6MHZ)
 		printk(KERN_CONT "F6MHZ ");
-	 if (type & INPUT2)
+	if (type & INPUT2)
 		printk(KERN_CONT "INPUT2 ");
-	 if (type & SCODE)
+	if (type & SCODE)
 		printk(KERN_CONT "SCODE ");
-	 if (type & HAS_IF)
+	if (type & HAS_IF)
 		printk(KERN_CONT "HAS_IF_%d ", int_freq);
 }
 
-- 
1.9.3

