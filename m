Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f67.google.com ([74.125.82.67]:50831 "EHLO
        mail-wm0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753030AbeDBSYi (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 2 Apr 2018 14:24:38 -0400
Received: by mail-wm0-f67.google.com with SMTP id t67so7622254wmt.0
        for <linux-media@vger.kernel.org>; Mon, 02 Apr 2018 11:24:38 -0700 (PDT)
From: Daniel Scheller <d.scheller.oss@gmail.com>
To: linux-media@vger.kernel.org, mchehab@kernel.org,
        mchehab@s-opensource.com
Subject: [PATCH 07/20] [media] ddbridge: request/free_irq using pci_irq_vector, enable MSI-X
Date: Mon,  2 Apr 2018 20:24:14 +0200
Message-Id: <20180402182427.20918-8-d.scheller.oss@gmail.com>
In-Reply-To: <20180402182427.20918-1-d.scheller.oss@gmail.com>
References: <20180402182427.20918-1-d.scheller.oss@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Daniel Scheller <d.scheller@gmx.net>

Instead of trying to manage IRQ numbers on itself, utilise the
pci_irq_vector() function to do this, which will take care of correct IRQ
numbering for MSI and non-MSI IRQs. While at it, request and enable MSI-X
interrupts for hardware (boards and cards) that support this.

Picked up from the upstream dddvb-0.9.33 release.

Signed-off-by: Daniel Scheller <d.scheller@gmx.net>
---
 drivers/media/pci/ddbridge/ddbridge-main.c | 24 ++++++++++++++----------
 1 file changed, 14 insertions(+), 10 deletions(-)

diff --git a/drivers/media/pci/ddbridge/ddbridge-main.c b/drivers/media/pci/ddbridge/ddbridge-main.c
index 77089081db1f..008be9066814 100644
--- a/drivers/media/pci/ddbridge/ddbridge-main.c
+++ b/drivers/media/pci/ddbridge/ddbridge-main.c
@@ -77,8 +77,8 @@ static void ddb_irq_exit(struct ddb *dev)
 {
 	ddb_irq_disable(dev);
 	if (dev->msi == 2)
-		free_irq(dev->pdev->irq + 1, dev);
-	free_irq(dev->pdev->irq, dev);
+		free_irq(pci_irq_vector(dev->pdev, 1), dev);
+	free_irq(pci_irq_vector(dev->pdev, 0), dev);
 }
 
 static void ddb_remove(struct pci_dev *pdev)
@@ -105,7 +105,8 @@ static void ddb_irq_msi(struct ddb *dev, int nr)
 	int stat;
 
 	if (msi && pci_msi_enabled()) {
-		stat = pci_alloc_irq_vectors(dev->pdev, 1, nr, PCI_IRQ_MSI);
+		stat = pci_alloc_irq_vectors(dev->pdev, 1, nr,
+					     PCI_IRQ_MSI | PCI_IRQ_MSIX);
 		if (stat >= 1) {
 			dev->msi = stat;
 			dev_info(dev->dev, "using %d MSI interrupt(s)\n",
@@ -137,21 +138,24 @@ static int ddb_irq_init(struct ddb *dev)
 	if (dev->msi)
 		irq_flag = 0;
 	if (dev->msi == 2) {
-		stat = request_irq(dev->pdev->irq, ddb_irq_handler0,
-				   irq_flag, "ddbridge", (void *)dev);
+		stat = request_irq(pci_irq_vector(dev->pdev, 0),
+				   ddb_irq_handler0, irq_flag, "ddbridge",
+				   (void *)dev);
 		if (stat < 0)
 			return stat;
-		stat = request_irq(dev->pdev->irq + 1, ddb_irq_handler1,
-				   irq_flag, "ddbridge", (void *)dev);
+		stat = request_irq(pci_irq_vector(dev->pdev, 1),
+				   ddb_irq_handler1, irq_flag, "ddbridge",
+				   (void *)dev);
 		if (stat < 0) {
-			free_irq(dev->pdev->irq, dev);
+			free_irq(pci_irq_vector(dev->pdev, 0), dev);
 			return stat;
 		}
 	} else
 #endif
 	{
-		stat = request_irq(dev->pdev->irq, ddb_irq_handler,
-				   irq_flag, "ddbridge", (void *)dev);
+		stat = request_irq(pci_irq_vector(dev->pdev, 0),
+				   ddb_irq_handler, irq_flag, "ddbridge",
+				   (void *)dev);
 		if (stat < 0)
 			return stat;
 	}
-- 
2.16.1
