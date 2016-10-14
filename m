Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:48634 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754874AbcJNRrG (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 14 Oct 2016 13:47:06 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Subject: [PATCH 17/25] [media] dvb_filter: use KERN_CONT where needed
Date: Fri, 14 Oct 2016 14:45:55 -0300
Message-Id: <7d355ee603b141724ae44d16ebb3723acfc3b468.1476466574.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1476466574.git.mchehab@s-opensource.com>
References: <cover.1476466574.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1476466574.git.mchehab@s-opensource.com>
References: <cover.1476466574.git.mchehab@s-opensource.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Some continuation messages are not using KERN_CONT.

Since commit 563873318d32 ("Merge branch 'printk-cleanups"),
this won't work as expected anymore. So, let's add KERN_CONT
to those lines.

While here, add missing log level annotations.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 drivers/media/pci/ttpci/dvb_filter.c | 13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

diff --git a/drivers/media/pci/ttpci/dvb_filter.c b/drivers/media/pci/ttpci/dvb_filter.c
index 227f93e2ef10..b67127b67d4e 100644
--- a/drivers/media/pci/ttpci/dvb_filter.c
+++ b/drivers/media/pci/ttpci/dvb_filter.c
@@ -17,7 +17,6 @@ static u32 ac3_frames[3][32] =
      {96,120,144,168,192,240,288,336,384,480,576,672,768,960,1152,1344,
       1536,1728,1920,0,0,0,0,0,0,0,0,0,0,0,0,0}};
 
-
 int dvb_filter_get_ac3info(u8 *mbuf, int count, struct dvb_audio_info *ai, int pr)
 {
 	u8 *headr;
@@ -38,7 +37,7 @@ int dvb_filter_get_ac3info(u8 *mbuf, int count, struct dvb_audio_info *ai, int p
 
 	if (!found) return -1;
 	if (pr)
-		printk("Audiostream: AC3");
+		printk(KERN_DEBUG "Audiostream: AC3");
 
 	ai->off = c;
 	if (c+5 >= count) return -1;
@@ -50,19 +49,19 @@ int dvb_filter_get_ac3info(u8 *mbuf, int count, struct dvb_audio_info *ai, int p
 	ai->bit_rate = ac3_bitrates[frame >> 1]*1000;
 
 	if (pr)
-		printk("  BRate: %d kb/s", (int) ai->bit_rate/1000);
+		printk(KERN_CONT "  BRate: %d kb/s", (int) ai->bit_rate/1000);
 
 	ai->frequency = (headr[2] & 0xc0 ) >> 6;
 	fr = (headr[2] & 0xc0 ) >> 6;
 	ai->frequency = freq[fr]*100;
-	if (pr) printk ("  Freq: %d Hz\n", (int) ai->frequency);
-
+	if (pr)
+		printk(KERN_CONT "  Freq: %d Hz\n", (int) ai->frequency);
 
 	ai->framesize = ac3_frames[fr][frame >> 1];
 	if ((frame & 1) &&  (fr == 1)) ai->framesize++;
 	ai->framesize = ai->framesize << 1;
-	if (pr) printk ("  Framesize %d\n",(int) ai->framesize);
-
+	if (pr)
+		printk(KERN_DEBUG "  Framesize %d\n", (int) ai->framesize);
 
 	return 0;
 }
-- 
2.7.4


