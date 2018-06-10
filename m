Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pg0-f68.google.com ([74.125.83.68]:46934 "EHLO
        mail-pg0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753432AbeFJO6T (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 10 Jun 2018 10:58:19 -0400
Received: by mail-pg0-f68.google.com with SMTP id d2-v6so8527328pga.13
        for <linux-media@vger.kernel.org>; Sun, 10 Jun 2018 07:58:19 -0700 (PDT)
From: tskd08@gmail.com
To: linux-media@vger.kernel.org
Cc: mchehab@s-opensource.com, Akihiro Tsukada <tskd08@gmail.com>
Subject: [PATCH] pci/pt1: suppress compiler warning in xtensa arch
Date: Sun, 10 Jun 2018 23:58:02 +0900
Message-Id: <20180610145802.8188-1-tskd08@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Akihiro Tsukada <tskd08@gmail.com>

Found and reported by kbuild test robot:
Message ID: <201805052003.MC007f9h%fengguang.wu@intel.com>
and holding an address of an empty struct in .driver.pm does no harm
when CONFIG_PM_SLEEP is not defined.

Signed-off-by: Akihiro Tsukada <tskd08@gmail.com>
---
 drivers/media/pci/pt1/pt1.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/media/pci/pt1/pt1.c b/drivers/media/pci/pt1/pt1.c
index 5708f69622c..362305c88df 100644
--- a/drivers/media/pci/pt1/pt1.c
+++ b/drivers/media/pci/pt1/pt1.c
@@ -1443,9 +1443,7 @@ static struct pci_driver pt1_driver = {
 	.probe		= pt1_probe,
 	.remove		= pt1_remove,
 	.id_table	= pt1_id_table,
-#ifdef CONFIG_PM_SLEEP
 	.driver.pm	= &pt1_pm_ops,
-#endif
 };
 
 module_pci_driver(pt1_driver);
-- 
2.17.1
