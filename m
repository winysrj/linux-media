Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-out-098.synserver.de ([212.40.185.98]:1072 "EHLO
	smtp-out-188.synserver.de" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751297AbbKULQq (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 21 Nov 2015 06:16:46 -0500
From: Lars-Peter Clausen <lars@metafoo.de>
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: linux-media@vger.kernel.org, Lars-Peter Clausen <lars@metafoo.de>
Subject: [PATCH] [media] dm1105: Remove unnecessary synchronize_irq() before free_irq()
Date: Sat, 21 Nov 2015 12:16:38 +0100
Message-Id: <1448104598-23513-1-git-send-email-lars@metafoo.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Calling synchronize_irq() right before free_irq() is quite useless. On one
hand the IRQ can easily fire again before free_irq() is entered, on the
other hand free_irq() itself calls synchronize_irq() internally (in a race
condition free way), before any state associated with the IRQ is freed.

Patch was generated using the following semantic patch:
// <smpl>
@@
expression irq;
@@
-synchronize_irq(irq);
 free_irq(irq, ...);
// </smpl>

Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
---
 drivers/media/pci/dm1105/dm1105.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/media/pci/dm1105/dm1105.c b/drivers/media/pci/dm1105/dm1105.c
index 88915fb..5dd5047 100644
--- a/drivers/media/pci/dm1105/dm1105.c
+++ b/drivers/media/pci/dm1105/dm1105.c
@@ -1206,7 +1206,6 @@ static void dm1105_remove(struct pci_dev *pdev)
 	i2c_del_adapter(&dev->i2c_adap);
 
 	dm1105_hw_exit(dev);
-	synchronize_irq(pdev->irq);
 	free_irq(pdev->irq, dev);
 	pci_iounmap(pdev, dev->io_mem);
 	pci_release_regions(pdev);
-- 
2.1.4

