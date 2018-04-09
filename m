Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f67.google.com ([74.125.82.67]:35249 "EHLO
        mail-wm0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753384AbeDIQsF (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 9 Apr 2018 12:48:05 -0400
Received: by mail-wm0-f67.google.com with SMTP id r82so18180769wme.0
        for <linux-media@vger.kernel.org>; Mon, 09 Apr 2018 09:48:04 -0700 (PDT)
From: Daniel Scheller <d.scheller.oss@gmail.com>
To: linux-media@vger.kernel.org, mchehab@kernel.org,
        mchehab@s-opensource.com
Subject: [PATCH v2 09/19] [media] ddbridge: improve separated MSI IRQ handling
Date: Mon,  9 Apr 2018 18:47:42 +0200
Message-Id: <20180409164752.641-10-d.scheller.oss@gmail.com>
In-Reply-To: <20180409164752.641-1-d.scheller.oss@gmail.com>
References: <20180409164752.641-1-d.scheller.oss@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Daniel Scheller <d.scheller@gmx.net>

Improve IRQ handling in the separated MSG/I2C and IO/TSDATA handlers by
applying a mask for recognized bits immediately upon reading the IRQ mask
from the hardware, so only the bits/IRQs that actually were set will be
acked.

Picked up from the upstream dddvb-0.9.33 release.

Signed-off-by: Daniel Scheller <d.scheller@gmx.net>
---
 drivers/media/pci/ddbridge/ddbridge-core.c | 22 ++++++++++++----------
 1 file changed, 12 insertions(+), 10 deletions(-)

diff --git a/drivers/media/pci/ddbridge/ddbridge-core.c b/drivers/media/pci/ddbridge/ddbridge-core.c
index 5fbb0996a12c..9d91221dacc4 100644
--- a/drivers/media/pci/ddbridge/ddbridge-core.c
+++ b/drivers/media/pci/ddbridge/ddbridge-core.c
@@ -2443,16 +2443,17 @@ static void irq_handle_io(struct ddb *dev, u32 s)
 irqreturn_t ddb_irq_handler0(int irq, void *dev_id)
 {
 	struct ddb *dev = (struct ddb *)dev_id;
-	u32 s = ddbreadl(dev, INTERRUPT_STATUS);
+	u32 mask = 0x8fffff00;
+	u32 s = mask & ddbreadl(dev, INTERRUPT_STATUS);
 
+	if (!s)
+		return IRQ_NONE;
 	do {
 		if (s & 0x80000000)
 			return IRQ_NONE;
-		if (!(s & 0xfffff00))
-			return IRQ_NONE;
-		ddbwritel(dev, s & 0xfffff00, INTERRUPT_ACK);
+		ddbwritel(dev, s, INTERRUPT_ACK);
 		irq_handle_io(dev, s);
-	} while ((s = ddbreadl(dev, INTERRUPT_STATUS)));
+	} while ((s = mask & ddbreadl(dev, INTERRUPT_STATUS)));
 
 	return IRQ_HANDLED;
 }
@@ -2460,16 +2461,17 @@ irqreturn_t ddb_irq_handler0(int irq, void *dev_id)
 irqreturn_t ddb_irq_handler1(int irq, void *dev_id)
 {
 	struct ddb *dev = (struct ddb *)dev_id;
-	u32 s = ddbreadl(dev, INTERRUPT_STATUS);
+	u32 mask = 0x8000000f;
+	u32 s = mask & ddbreadl(dev, INTERRUPT_STATUS);
 
+	if (!s)
+		return IRQ_NONE;
 	do {
 		if (s & 0x80000000)
 			return IRQ_NONE;
-		if (!(s & 0x0000f))
-			return IRQ_NONE;
-		ddbwritel(dev, s & 0x0000f, INTERRUPT_ACK);
+		ddbwritel(dev, s, INTERRUPT_ACK);
 		irq_handle_msg(dev, s);
-	} while ((s = ddbreadl(dev, INTERRUPT_STATUS)));
+	} while ((s = mask & ddbreadl(dev, INTERRUPT_STATUS)));
 
 	return IRQ_HANDLED;
 }
-- 
2.16.1
