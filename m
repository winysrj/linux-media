Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.126.135]:51383 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752148AbeCMNGj (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 13 Mar 2018 09:06:39 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Daniel Scheller <d.scheller@gmx.net>
Cc: Arnd Bergmann <arnd@arndb.de>,
        Binoy Jayan <binoy.jayan@linaro.org>,
        Jasmin Jessich <jasmin@anw.at>, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] media: ngene: avoid unused variable warning
Date: Tue, 13 Mar 2018 14:06:03 +0100
Message-Id: <20180313130620.4040088-1-arnd@arndb.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The newly added pdev variable is only used in an #ifdef, causing a
build warning without CONFIG_PCI_MSI, unless we move the declaration
inside the same #ifdef:

drivers/media/pci/ngene/ngene-core.c: In function 'ngene_start':
drivers/media/pci/ngene/ngene-core.c:1328:17: error: unused variable 'pdev' [-Werror=unused-variable]

Fixes: 6795bf626482 ("media: ngene: convert kernellog printing from printk() to dev_*() macros")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/media/pci/ngene/ngene-core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/pci/ngene/ngene-core.c b/drivers/media/pci/ngene/ngene-core.c
index 3b9a1bfaf6c0..25f16833a475 100644
--- a/drivers/media/pci/ngene/ngene-core.c
+++ b/drivers/media/pci/ngene/ngene-core.c
@@ -1325,7 +1325,6 @@ static int ngene_buffer_config(struct ngene *dev)
 
 static int ngene_start(struct ngene *dev)
 {
-	struct device *pdev = &dev->pci_dev->dev;
 	int stat;
 	int i;
 
@@ -1359,6 +1358,7 @@ static int ngene_start(struct ngene *dev)
 #ifdef CONFIG_PCI_MSI
 	/* enable MSI if kernel and card support it */
 	if (pci_msi_enabled() && dev->card_info->msi_supported) {
+		struct device *pdev = &dev->pci_dev->dev;
 		unsigned long flags;
 
 		ngwritel(0, NGENE_INT_ENABLE);
-- 
2.9.0
