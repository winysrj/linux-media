Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.anw.at ([195.234.101.228]:57917 "EHLO mail.anw.at"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753712AbdLIAS4 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 8 Dec 2017 19:18:56 -0500
From: "Jasmin J." <jasmin@anw.at>
To: linux-media@vger.kernel.org
Cc: hverkuil@xs4all.nl, d.scheller@gmx.net, jasmin@anw.at
Subject: [PATCH] build: Remove patch v3.13_ddbridge_pcimsi
Date: Sat,  9 Dec 2017 01:18:50 +0100
Message-Id: <1512778730-12349-1-git-send-email-jasmin@anw.at>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Jasmin Jessich <jasmin@anw.at>

Signed-off-by: Jasmin Jessich <jasmin@anw.at>
---
 backports/backports.txt               |  3 ---
 backports/v3.13_ddbridge_pcimsi.patch | 29 -----------------------------
 2 files changed, 32 deletions(-)
 delete mode 100644 backports/v3.13_ddbridge_pcimsi.patch

diff --git a/backports/backports.txt b/backports/backports.txt
index 78dfb9c..da097ce 100644
--- a/backports/backports.txt
+++ b/backports/backports.txt
@@ -87,9 +87,6 @@ add v3.16_netdev.patch
 add v3.16_wait_on_bit.patch
 add v3.16_void_gpiochip_remove.patch
 
-[3.13.255]
-add v3.13_ddbridge_pcimsi.patch
-
 [3.12.255]
 add v3.12_kfifo_in.patch
 
diff --git a/backports/v3.13_ddbridge_pcimsi.patch b/backports/v3.13_ddbridge_pcimsi.patch
deleted file mode 100644
index 5f602a7..0000000
--- a/backports/v3.13_ddbridge_pcimsi.patch
+++ /dev/null
@@ -1,29 +0,0 @@
-diff --git a/drivers/media/pci/ddbridge/ddbridge-main.c b/drivers/media/pci/ddbridge/ddbridge-main.c
-index 9ab4736..50c3b4f 100644
---- a/drivers/media/pci/ddbridge/ddbridge-main.c
-+++ b/drivers/media/pci/ddbridge/ddbridge-main.c
-@@ -129,13 +129,18 @@ static void ddb_irq_msi(struct ddb *dev, int nr)
- 	int stat;
- 
- 	if (msi && pci_msi_enabled()) {
--		stat = pci_enable_msi_range(dev->pdev, 1, nr);
--		if (stat >= 1) {
--			dev->msi = stat;
--			dev_info(dev->dev, "using %d MSI interrupt(s)\n",
--				dev->msi);
--		} else
-+		stat = pci_enable_msi_block(dev->pdev, nr);
-+		if (stat == 0) {
-+			dev->msi = nr;
-+		} else if (stat == 1) {
-+			stat = pci_enable_msi(dev->pdev);
-+			dev->msi = 1;
-+		}
-+		if (stat < 0)
- 			dev_info(dev->dev, "MSI not available.\n");
-+		else
-+			dev_info(dev->dev, "using %d MSI interrupts\n",
-+				 dev->msi);
- 	}
- }
- #endif
-- 
2.7.4
