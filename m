Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:48602 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751889Ab1F2Vty (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 29 Jun 2011 17:49:54 -0400
From: Jarod Wilson <jarod@redhat.com>
To: linux-media@vger.kernel.org
Cc: Jarod Wilson <jarod@redhat.com>,
	Andy Walls <awalls@md.metrocast.net>,
	Kusanagi Kouichi <slash@ac.auone-net.jp>
Subject: [PATCH] Revert "V4L/DVB: cx23885: Enable Message Signaled Interrupts(MSI)"
Date: Wed, 29 Jun 2011 17:49:33 -0400
Message-Id: <1309384173-12933-1-git-send-email-jarod@redhat.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

This reverts commit e38030f3ff02684eb9e25e983a03ad318a10a2ea.

MSI flat-out doesn't work right on cx2388x devices yet. There are now
multiple reports of cards that hard-lock systems when MSI is enabled,
including my own HVR-1250 when trying to use its built-in IR receiver.
Disable MSI and it works just fine. Similar for another user's HVR-1270.
Issues have also been reported with the HVR-1850 when MSI is enabled,
and the 1850 behavior sounds similar to an as-yet-undiagnosed issue I've
seen with an 1800.

References:

http://www.spinics.net/lists/linux-media/msg25956.html
http://www.spinics.net/lists/linux-media/msg33676.html
http://www.spinics.net/lists/linux-media/msg34734.html

CC: Andy Walls <awalls@md.metrocast.net>
CC: Kusanagi Kouichi <slash@ac.auone-net.jp>
Signed-off-by: Jarod Wilson <jarod@redhat.com>
---
 drivers/media/video/cx23885/cx23885-core.c |    9 ++-------
 1 files changed, 2 insertions(+), 7 deletions(-)

diff --git a/drivers/media/video/cx23885/cx23885-core.c b/drivers/media/video/cx23885/cx23885-core.c
index 64d9b21..419777a 100644
--- a/drivers/media/video/cx23885/cx23885-core.c
+++ b/drivers/media/video/cx23885/cx23885-core.c
@@ -2060,12 +2060,8 @@ static int __devinit cx23885_initdev(struct pci_dev *pci_dev,
 		goto fail_irq;
 	}
 
-	if (!pci_enable_msi(pci_dev))
-		err = request_irq(pci_dev->irq, cx23885_irq,
-				  IRQF_DISABLED, dev->name, dev);
-	else
-		err = request_irq(pci_dev->irq, cx23885_irq,
-				  IRQF_SHARED | IRQF_DISABLED, dev->name, dev);
+	err = request_irq(pci_dev->irq, cx23885_irq,
+			  IRQF_SHARED | IRQF_DISABLED, dev->name, dev);
 	if (err < 0) {
 		printk(KERN_ERR "%s: can't get IRQ %d\n",
 		       dev->name, pci_dev->irq);
@@ -2114,7 +2110,6 @@ static void __devexit cx23885_finidev(struct pci_dev *pci_dev)
 
 	/* unregister stuff */
 	free_irq(pci_dev->irq, dev);
-	pci_disable_msi(pci_dev);
 
 	cx23885_dev_unregister(dev);
 	v4l2_device_unregister(v4l2_dev);
-- 
1.7.1

