Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-la0-f47.google.com ([209.85.215.47]:44794 "EHLO
	mail-la0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750746AbbBUVpl (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 21 Feb 2015 16:45:41 -0500
Received: by lams18 with SMTP id s18so12251462lam.11
        for <linux-media@vger.kernel.org>; Sat, 21 Feb 2015 13:45:40 -0800 (PST)
From: Olli Salonen <olli.salonen@iki.fi>
To: linux-media@vger.kernel.org
Cc: Olli Salonen <olli.salonen@iki.fi>
Subject: [PATCH] saa7164: free_irq before pci_disable_device
Date: Sat, 21 Feb 2015 23:45:26 +0200
Message-Id: <1424555126-26151-1-git-send-email-olli.salonen@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Free the IRQ before disabling the device. Otherwise errors like this when unloading the module:

[21135.458560] ------------[ cut here ]------------
[21135.458569] WARNING: CPU: 4 PID: 1696 at /home/apw/COD/linux/fs/proc/generic.c:521 remove_proc_entry+0x1a1/0x1b0()
[21135.458572] remove_proc_entry: removing non-empty directory 'irq/47', leaking at least 'saa7164[0]'

Signed-off-by: Olli Salonen <olli.salonen@iki.fi>
---
 drivers/media/pci/saa7164/saa7164-core.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/pci/saa7164/saa7164-core.c b/drivers/media/pci/saa7164/saa7164-core.c
index 4b0bec3..9cf3c6c 100644
--- a/drivers/media/pci/saa7164/saa7164-core.c
+++ b/drivers/media/pci/saa7164/saa7164-core.c
@@ -1436,11 +1436,11 @@ static void saa7164_finidev(struct pci_dev *pci_dev)
 	saa7164_i2c_unregister(&dev->i2c_bus[1]);
 	saa7164_i2c_unregister(&dev->i2c_bus[2]);
 
-	pci_disable_device(pci_dev);
-
 	/* unregister stuff */
 	free_irq(pci_dev->irq, dev);
 
+	pci_disable_device(pci_dev);
+
 	mutex_lock(&devlist);
 	list_del(&dev->devlist);
 	mutex_unlock(&devlist);
-- 
1.9.1

