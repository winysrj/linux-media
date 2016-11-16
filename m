Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:49618 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753320AbcKPQnN (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 16 Nov 2016 11:43:13 -0500
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Devin Heitmueller <dheitmueller@kernellabs.com>,
        Inki Dae <inki.dae@samsung.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Junghak Sung <jh1009.sung@samsung.com>,
        Julia Lawall <Julia.Lawall@lip6.fr>
Subject: [PATCH 05/35] [media] cx23885: use KERN_CONT where needed
Date: Wed, 16 Nov 2016 14:42:37 -0200
Message-Id: <88c01c60cdbc1e4a3f7d35640c9228eb2a200c11.1479314177.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1479314177.git.mchehab@s-opensource.com>
References: <cover.1479314177.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1479314177.git.mchehab@s-opensource.com>
References: <cover.1479314177.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Some continuation messages are not using KERN_CONT.

Since commit 563873318d32 ("Merge branch 'printk-cleanups'"),
this won't work as expected anymore. So, let's add KERN_CONT
to those lines.

While here, add missing log level annotations.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 drivers/media/pci/cx23885/cx23885-core.c | 8 ++++----
 drivers/media/pci/cx23885/cx23885-i2c.c  | 8 ++++----
 2 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/media/pci/cx23885/cx23885-core.c b/drivers/media/pci/cx23885/cx23885-core.c
index 5020a60a4f1f..0d97da3be90b 100644
--- a/drivers/media/pci/cx23885/cx23885-core.c
+++ b/drivers/media/pci/cx23885/cx23885-core.c
@@ -407,12 +407,12 @@ static int cx23885_risc_decode(u32 risc)
 	};
 	int i;
 
-	printk("0x%08x [ %s", risc,
+	printk(KERN_DEBUG "0x%08x [ %s", risc,
 	       instr[risc >> 28] ? instr[risc >> 28] : "INVALID");
 	for (i = ARRAY_SIZE(bits) - 1; i >= 0; i--)
 		if (risc & (1 << (i + 12)))
-			printk(" %s", bits[i]);
-	printk(" count=%d ]\n", risc & 0xfff);
+			printk(KERN_CONT " %s", bits[i]);
+	printk(KERN_CONT " count=%d ]\n", risc & 0xfff);
 	return incr[risc >> 28] ? incr[risc >> 28] : 1;
 }
 
@@ -2003,7 +2003,7 @@ static int cx23885_initdev(struct pci_dev *pci_dev,
 	pci_set_master(pci_dev);
 	err = pci_set_dma_mask(pci_dev, 0xffffffff);
 	if (err) {
-		printk("%s/0: Oops: no 32bit PCI DMA ???\n", dev->name);
+		printk(KERN_ERR "%s/0: Oops: no 32bit PCI DMA ???\n", dev->name);
 		goto fail_ctrl;
 	}
 
diff --git a/drivers/media/pci/cx23885/cx23885-i2c.c b/drivers/media/pci/cx23885/cx23885-i2c.c
index 61591225be9a..19faf9a611ed 100644
--- a/drivers/media/pci/cx23885/cx23885-i2c.c
+++ b/drivers/media/pci/cx23885/cx23885-i2c.c
@@ -119,9 +119,9 @@ static int i2c_sendbytes(struct i2c_adapter *i2c_adap,
 	if (!i2c_wait_done(i2c_adap))
 		goto eio;
 	if (i2c_debug) {
-		printk(" <W %02x %02x", msg->addr << 1, msg->buf[0]);
+		printk(KERN_DEBUG " <W %02x %02x", msg->addr << 1, msg->buf[0]);
 		if (!(ctrl & I2C_NOSTOP))
-			printk(" >\n");
+			printk(KERN_CONT " >\n");
 	}
 
 	for (cnt = 1; cnt < msg->len; cnt++) {
@@ -141,9 +141,9 @@ static int i2c_sendbytes(struct i2c_adapter *i2c_adap,
 		if (!i2c_wait_done(i2c_adap))
 			goto eio;
 		if (i2c_debug) {
-			dprintk(1, " %02x", msg->buf[cnt]);
+			printk(KERN_CONT " %02x", msg->buf[cnt]);
 			if (!(ctrl & I2C_NOSTOP))
-				dprintk(1, " >\n");
+				printk(KERN_CONT " >\n");
 		}
 	}
 	return msg->len;
-- 
2.7.4


