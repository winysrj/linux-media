Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:49736 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753832AbcKPQnS (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 16 Nov 2016 11:43:18 -0500
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Mike Isely <isely@pobox.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Subject: [PATCH 13/35] [media] pvrusb2: use KERNEL_CONT where needed
Date: Wed, 16 Nov 2016 14:42:45 -0200
Message-Id: <9f915cfe2e5edf81ab793924810f8dfaed8bfaed.1479314177.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1479314177.git.mchehab@s-opensource.com>
References: <cover.1479314177.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1479314177.git.mchehab@s-opensource.com>
References: <cover.1479314177.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Some continuation messages are not using KERNEL_CONT.

Since commit 563873318d32 ("Merge branch 'printk-cleanups"),
this won't work as expected anymore. So, let's add KERN_CONT
to those lines.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 drivers/media/usb/pvrusb2/pvrusb2-i2c-core.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/media/usb/pvrusb2/pvrusb2-i2c-core.c b/drivers/media/usb/pvrusb2/pvrusb2-i2c-core.c
index 48d837e39a9c..cc63e5f4c26c 100644
--- a/drivers/media/usb/pvrusb2/pvrusb2-i2c-core.c
+++ b/drivers/media/usb/pvrusb2/pvrusb2-i2c-core.c
@@ -491,18 +491,18 @@ static int pvr2_i2c_xfer(struct i2c_adapter *i2c_adap,
 				"read" : "write"));
 			if ((ret > 0) || !(msgs[idx].flags & I2C_M_RD)) {
 				if (cnt > 8) cnt = 8;
-				printk(" [");
+				printk(KERN_CONT " [");
 				for (offs = 0; offs < (cnt>8?8:cnt); offs++) {
-					if (offs) printk(" ");
-					printk("%02x",msgs[idx].buf[offs]);
+					if (offs) printk(KERN_CONT " ");
+					printk(KERN_CONT "%02x",msgs[idx].buf[offs]);
 				}
-				if (offs < cnt) printk(" ...");
-				printk("]");
+				if (offs < cnt) printk(KERN_CONT " ...");
+				printk(KERN_CONT "]");
 			}
 			if (idx+1 == num) {
-				printk(" result=%d",ret);
+				printk(KERN_CONT " result=%d",ret);
 			}
-			printk("\n");
+			printk(KERN_CONT "\n");
 		}
 		if (!num) {
 			printk(KERN_INFO
-- 
2.7.4


