Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:49706 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753809AbcKPQnQ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 16 Nov 2016 11:43:16 -0500
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        mjpeg-users@lists.sourceforge.net
Subject: [PATCH 11/35] [media] zoran: use KERN_CONT where needed
Date: Wed, 16 Nov 2016 14:42:43 -0200
Message-Id: <ce24114e895eb287672f7b46316afaddd0c06831.1479314177.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1479314177.git.mchehab@s-opensource.com>
References: <cover.1479314177.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1479314177.git.mchehab@s-opensource.com>
References: <cover.1479314177.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Some continuation messages are not using KERN_CONT.

Since commit 563873318d32 ("Merge branch 'printk-cleanups"),
this won't work as expected anymore. So, let's add KERN_CONT
to those lines.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 drivers/media/pci/zoran/zoran_device.c | 35 ++++++++++++++--------------------
 1 file changed, 14 insertions(+), 21 deletions(-)

diff --git a/drivers/media/pci/zoran/zoran_device.c b/drivers/media/pci/zoran/zoran_device.c
index 4d47ddac97dc..35b552c178da 100644
--- a/drivers/media/pci/zoran/zoran_device.c
+++ b/drivers/media/pci/zoran/zoran_device.c
@@ -173,12 +173,8 @@ dump_guests (struct zoran *zr)
 			guest[i] = post_office_read(zr, i, 0);
 		}
 
-		printk(KERN_INFO "%s: Guests:", ZR_DEVNAME(zr));
-
-		for (i = 1; i < 8; i++) {
-			printk(" 0x%02x", guest[i]);
-		}
-		printk("\n");
+		printk(KERN_INFO "%s: Guests: %*ph\n",
+		       ZR_DEVNAME(zr), 8, guest);
 	}
 }
 
@@ -216,12 +212,9 @@ detect_guest_activity (struct zoran *zr)
 		if (j >= 8)
 			break;
 	}
-	printk(KERN_INFO "%s: Guests:", ZR_DEVNAME(zr));
 
-	for (i = 1; i < 8; i++) {
-		printk(" 0x%02x", guest0[i]);
-	}
-	printk("\n");
+	printk(KERN_INFO "%s: Guests: %*ph\n", ZR_DEVNAME(zr), 8, guest0);
+
 	if (j == 0) {
 		printk(KERN_INFO "%s: No activity detected.\n", ZR_DEVNAME(zr));
 		return;
@@ -822,39 +815,39 @@ print_interrupts (struct zoran *zr)
 
 	printk(KERN_INFO "%s: interrupts received:", ZR_DEVNAME(zr));
 	if ((res = zr->field_counter) < -1 || res > 1) {
-		printk(" FD:%d", res);
+		printk(KERN_CONT " FD:%d", res);
 	}
 	if ((res = zr->intr_counter_GIRQ1) != 0) {
-		printk(" GIRQ1:%d", res);
+		printk(KERN_CONT " GIRQ1:%d", res);
 		noerr++;
 	}
 	if ((res = zr->intr_counter_GIRQ0) != 0) {
-		printk(" GIRQ0:%d", res);
+		printk(KERN_CONT " GIRQ0:%d", res);
 		noerr++;
 	}
 	if ((res = zr->intr_counter_CodRepIRQ) != 0) {
-		printk(" CodRepIRQ:%d", res);
+		printk(KERN_CONT " CodRepIRQ:%d", res);
 		noerr++;
 	}
 	if ((res = zr->intr_counter_JPEGRepIRQ) != 0) {
-		printk(" JPEGRepIRQ:%d", res);
+		printk(KERN_CONT " JPEGRepIRQ:%d", res);
 		noerr++;
 	}
 	if (zr->JPEG_max_missed) {
-		printk(" JPEG delays: max=%d min=%d", zr->JPEG_max_missed,
+		printk(KERN_CONT " JPEG delays: max=%d min=%d", zr->JPEG_max_missed,
 		       zr->JPEG_min_missed);
 	}
 	if (zr->END_event_missed) {
-		printk(" ENDs missed: %d", zr->END_event_missed);
+		printk(KERN_CONT " ENDs missed: %d", zr->END_event_missed);
 	}
 	//if (zr->jpg_queued_num) {
-	printk(" queue_state=%ld/%ld/%ld/%ld", zr->jpg_que_tail,
+	printk(KERN_CONT " queue_state=%ld/%ld/%ld/%ld", zr->jpg_que_tail,
 	       zr->jpg_dma_tail, zr->jpg_dma_head, zr->jpg_que_head);
 	//}
 	if (!noerr) {
-		printk(": no interrupts detected.");
+		printk(KERN_CONT ": no interrupts detected.");
 	}
-	printk("\n");
+	printk(KERN_CONT "\n");
 }
 
 void
-- 
2.7.4


