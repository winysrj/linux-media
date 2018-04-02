Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr0-f193.google.com ([209.85.128.193]:38885 "EHLO
        mail-wr0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753261AbeDBSYh (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 2 Apr 2018 14:24:37 -0400
Received: by mail-wr0-f193.google.com with SMTP id m13so15024324wrj.5
        for <linux-media@vger.kernel.org>; Mon, 02 Apr 2018 11:24:37 -0700 (PDT)
From: Daniel Scheller <d.scheller.oss@gmail.com>
To: linux-media@vger.kernel.org, mchehab@kernel.org,
        mchehab@s-opensource.com
Subject: [PATCH 06/20] [media] ddbridge: move MSI IRQ cleanup to a helper function
Date: Mon,  2 Apr 2018 20:24:13 +0200
Message-Id: <20180402182427.20918-7-d.scheller.oss@gmail.com>
In-Reply-To: <20180402182427.20918-1-d.scheller.oss@gmail.com>
References: <20180402182427.20918-1-d.scheller.oss@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Daniel Scheller <d.scheller@gmx.net>

Introduce the ddb_msi_exit() helper to be used for cleaning up previously
allocated MSI IRQ vectors. Deduplicates code and makes things look
cleaner as for all cleanup work the CONFIG_PCI_MSI ifdeffery is only
needed in the helper now. Also, replace the call to the deprecated
pci_disable_msi() function with pci_free_irq_vectors().

Picked up from the upstream dddvb-0.9.33 release.

Signed-off-by: Daniel Scheller <d.scheller@gmx.net>
---
 drivers/media/pci/ddbridge/ddbridge-main.c | 16 ++++++++++------
 1 file changed, 10 insertions(+), 6 deletions(-)

diff --git a/drivers/media/pci/ddbridge/ddbridge-main.c b/drivers/media/pci/ddbridge/ddbridge-main.c
index 7088162af9d3..77089081db1f 100644
--- a/drivers/media/pci/ddbridge/ddbridge-main.c
+++ b/drivers/media/pci/ddbridge/ddbridge-main.c
@@ -65,16 +65,20 @@ static void ddb_irq_disable(struct ddb *dev)
 	ddbwritel(dev, 0, MSI1_ENABLE);
 }
 
+static void ddb_msi_exit(struct ddb *dev)
+{
+#ifdef CONFIG_PCI_MSI
+	if (dev->msi)
+		pci_free_irq_vectors(dev->pdev);
+#endif
+}
+
 static void ddb_irq_exit(struct ddb *dev)
 {
 	ddb_irq_disable(dev);
 	if (dev->msi == 2)
 		free_irq(dev->pdev->irq + 1, dev);
 	free_irq(dev->pdev->irq, dev);
-#ifdef CONFIG_PCI_MSI
-	if (dev->msi)
-		pci_disable_msi(dev->pdev);
-#endif
 }
 
 static void ddb_remove(struct pci_dev *pdev)
@@ -86,6 +90,7 @@ static void ddb_remove(struct pci_dev *pdev)
 	ddb_i2c_release(dev);
 
 	ddb_irq_exit(dev);
+	ddb_msi_exit(dev);
 	ddb_ports_release(dev);
 	ddb_buffers_free(dev);
 
@@ -230,8 +235,7 @@ static int ddb_probe(struct pci_dev *pdev,
 	ddb_irq_exit(dev);
 fail0:
 	dev_err(&pdev->dev, "fail0\n");
-	if (dev->msi)
-		pci_disable_msi(dev->pdev);
+	ddb_msi_exit(dev);
 fail:
 	dev_err(&pdev->dev, "fail\n");
 
-- 
2.16.1
