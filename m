Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wg0-f41.google.com ([74.125.82.41]:35260 "EHLO
	mail-wg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755735Ab3GKQC5 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 11 Jul 2013 12:02:57 -0400
Received: by mail-wg0-f41.google.com with SMTP id y10so12140266wgg.4
        for <linux-media@vger.kernel.org>; Thu, 11 Jul 2013 09:02:55 -0700 (PDT)
From: Luis Alves <ljalvs@gmail.com>
To: linux-media@vger.kernel.org
Cc: mchehab@infradead.org, crope@iki.fi, Luis Alves <ljalvs@gmail.com>
Subject: [PATCH] Fixed misleading error when handling IR interrupts.
Date: Thu, 11 Jul 2013 17:02:44 +0100
Message-Id: <1373558564-14968-1-git-send-email-ljalvs@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,
Handling the AV Core/IR interrupts schedules its workqueue but
the schedule_work function returns false if @work was already on the
kernel-global workqueue and true otherwise.

Printing an error message if @work wasn't in the queue is wrong.

Regards,
Luis


Signed-off-by: Luis Alves <ljalvs@gmail.com>
---
 drivers/media/pci/cx23885/cx23885-core.c |    5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/drivers/media/pci/cx23885/cx23885-core.c b/drivers/media/pci/cx23885/cx23885-core.c
index 268654a..9f63d93 100644
--- a/drivers/media/pci/cx23885/cx23885-core.c
+++ b/drivers/media/pci/cx23885/cx23885-core.c
@@ -1941,10 +1941,7 @@ static irqreturn_t cx23885_irq(int irq, void *dev_id)
 
 	if ((pci_status & pci_mask) & PCI_MSK_AV_CORE) {
 		cx23885_irq_disable(dev, PCI_MSK_AV_CORE);
-		if (!schedule_work(&dev->cx25840_work))
-			printk(KERN_ERR "%s: failed to set up deferred work for"
-			       " AV Core/IR interrupt. Interrupt is disabled"
-			       " and won't be re-enabled\n", dev->name);
+		schedule_work(&dev->cx25840_work);
 		handled++;
 	}
 
-- 
1.7.9.5

