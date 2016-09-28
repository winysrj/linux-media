Return-path: <linux-media-owner@vger.kernel.org>
Received: from arroyo.ext.ti.com ([198.47.19.12]:48720 "EHLO arroyo.ext.ti.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933454AbcI1VWF (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 28 Sep 2016 17:22:05 -0400
From: Benoit Parrot <bparrot@ti.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: <linux-media@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [Patch 17/35] media: ti-vpe: vpe: Post next descriptor only for list complete IRQ
Date: Wed, 28 Sep 2016 16:21:58 -0500
Message-ID: <20160928212158.27085-1-bparrot@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Nikhil Devshatwar <nikhil.nd@ti.com>

vpe_irq checks for the possible interrupt sources and prints the
errors for the DEI_ERROR and DS_UV interrupts. But it also post the
next descriptor list irrespective of whichever interrupt has occurred.

Because of this, driver may release the buffers even before DMA is
complete and also schedule next descriptor list.

Fix this by _actually_ handling the IRQ only when ListComplete IRQ
occurs.

Signed-off-by: Nikhil Devshatwar <nikhil.nd@ti.com>
Signed-off-by: Benoit Parrot <bparrot@ti.com>
---
 drivers/media/platform/ti-vpe/vpe.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/media/platform/ti-vpe/vpe.c b/drivers/media/platform/ti-vpe/vpe.c
index 08b363feb4fc..843cbcbf3944 100644
--- a/drivers/media/platform/ti-vpe/vpe.c
+++ b/drivers/media/platform/ti-vpe/vpe.c
@@ -1304,6 +1304,7 @@ static irqreturn_t vpe_irq(int irq_vpe, void *data)
 	struct vb2_v4l2_buffer *s_vb, *d_vb;
 	unsigned long flags;
 	u32 irqst0, irqst1;
+	bool list_complete = false;
 
 	irqst0 = read_reg(dev, VPE_INT0_STATUS0);
 	if (irqst0) {
@@ -1339,6 +1340,7 @@ static irqreturn_t vpe_irq(int irq_vpe, void *data)
 			vpdma_clear_list_stat(ctx->dev->vpdma, 0, 0);
 
 		irqst0 &= ~(VPE_INT0_LIST0_COMPLETE);
+		list_complete = true;
 	}
 
 	if (irqst0 | irqst1) {
@@ -1347,6 +1349,13 @@ static irqreturn_t vpe_irq(int irq_vpe, void *data)
 			irqst0, irqst1);
 	}
 
+	/*
+	 * Setup next operation only when list complete IRQ occurs
+	 * otherwise, skip the following code
+	 */
+	if (!list_complete)
+		goto handled;
+
 	disable_irqs(ctx);
 
 	vpdma_unmap_desc_buf(dev->vpdma, &ctx->desc_list.buf);
-- 
2.9.0

