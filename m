Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr0-f195.google.com ([209.85.128.195]:33184 "EHLO
        mail-wr0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751134AbdFYJ7u (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 25 Jun 2017 05:59:50 -0400
Received: by mail-wr0-f195.google.com with SMTP id x23so23630066wrb.0
        for <linux-media@vger.kernel.org>; Sun, 25 Jun 2017 02:59:49 -0700 (PDT)
From: Daniel Scheller <d.scheller.oss@gmail.com>
To: linux-media@vger.kernel.org, mchehab@kernel.org,
        mchehab@s-opensource.com
Subject: [PATCH] [media] ddbridge: dev_* logging fixup
Date: Sun, 25 Jun 2017 11:59:46 +0200
Message-Id: <20170625095946.2997-1-d.scheller.oss@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Daniel Scheller <d.scheller@gmx.net>

Fixup

  commit d52786ddd2d5 ("media: ddbridge: make (ddb)readl in while-loops fail-safe")

after/wrt

  commit 11e358bf37e8 ("media: ddbridge: use dev_* macros in favor of printk")

Signed-off-by: Daniel Scheller <d.scheller@gmx.net>
---
 drivers/media/pci/ddbridge/ddbridge-core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/pci/ddbridge/ddbridge-core.c b/drivers/media/pci/ddbridge/ddbridge-core.c
index c5745ae2ba5e..32f4d3746c8e 100644
--- a/drivers/media/pci/ddbridge/ddbridge-core.c
+++ b/drivers/media/pci/ddbridge/ddbridge-core.c
@@ -122,7 +122,7 @@ static inline u32 safe_ddbreadl(struct ddb *dev, u32 adr)
 
 	/* (ddb)readl returns (uint)-1 (all bits set) on failure, catch that */
 	if (val == ~0) {
-		printk(KERN_ERR "ddbreadl failure, adr=%08x\n", adr);
+		dev_err(&dev->pdev->dev, "ddbreadl failure, adr=%08x\n", adr);
 		return 0;
 	}
 
-- 
2.13.0
