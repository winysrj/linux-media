Return-path: <linux-media-owner@vger.kernel.org>
Received: from msa104.auone-net.jp ([61.117.18.164]:36087 "EHLO
	msa104.auone-net.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751032Ab0BFFpg (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 6 Feb 2010 00:45:36 -0500
Date: Sat, 6 Feb 2010 14:45:33 +0900
From: Kusanagi Kouichi <slash@ac.auone-net.jp>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] cx23885: Enable Message Signaled Interrupts(MSI).
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Message-Id: <20100206054534.A84CF15C033@msa104.auone-net.jp>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Kusanagi Kouichi <slash@ac.auone-net.jp>
---
 drivers/media/video/cx23885/cx23885-core.c |    9 +++++++--
 1 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/media/video/cx23885/cx23885-core.c b/drivers/media/video/cx23885/cx23885-core.c
index 0dde57e..7101c51 100644
--- a/drivers/media/video/cx23885/cx23885-core.c
+++ b/drivers/media/video/cx23885/cx23885-core.c
@@ -1953,8 +1953,12 @@ static int __devinit cx23885_initdev(struct pci_dev *pci_dev,
 		goto fail_irq;
 	}
 
-	err = request_irq(pci_dev->irq, cx23885_irq,
-			  IRQF_SHARED | IRQF_DISABLED, dev->name, dev);
+	if (!pci_enable_msi(pci_dev))
+		err = request_irq(pci_dev->irq, cx23885_irq,
+				  IRQF_DISABLED, dev->name, dev);
+	else
+		err = request_irq(pci_dev->irq, cx23885_irq,
+				  IRQF_SHARED | IRQF_DISABLED, dev->name, dev);
 	if (err < 0) {
 		printk(KERN_ERR "%s: can't get IRQ %d\n",
 		       dev->name, pci_dev->irq);
@@ -2000,6 +2004,7 @@ static void __devexit cx23885_finidev(struct pci_dev *pci_dev)
 
 	/* unregister stuff */
 	free_irq(pci_dev->irq, dev);
+	pci_disable_msi(pci_dev);
 
 	cx23885_dev_unregister(dev);
 	v4l2_device_unregister(v4l2_dev);
-- 
1.6.6.1

