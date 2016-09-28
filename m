Return-path: <linux-media-owner@vger.kernel.org>
Received: from comal.ext.ti.com ([198.47.26.152]:50127 "EHLO comal.ext.ti.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933372AbcI1VVl (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 28 Sep 2016 17:21:41 -0400
From: Benoit Parrot <bparrot@ti.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: <linux-media@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [Patch 14/35] media: ti-vpe: vpdma: Clear IRQs for individual lists
Date: Wed, 28 Sep 2016 16:21:38 -0500
Message-ID: <20160928212138.26950-1-bparrot@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Nikhil Devshatwar <nikhil.nd@ti.com>

VPDMA IRQs are registered for multiple lists
When clearing an IRQ for a list interrupt, all the
IRQs for the individual lists are to be cleared separately.

Signed-off-by: Nikhil Devshatwar <nikhil.nd@ti.com>
Signed-off-by: Benoit Parrot <bparrot@ti.com>
---
 drivers/media/platform/ti-vpe/vpdma.c | 6 +++---
 drivers/media/platform/ti-vpe/vpdma.h | 3 ++-
 drivers/media/platform/ti-vpe/vpe.c   | 2 +-
 3 files changed, 6 insertions(+), 5 deletions(-)

diff --git a/drivers/media/platform/ti-vpe/vpdma.c b/drivers/media/platform/ti-vpe/vpdma.c
index bfb0e19dd45c..96b5633ebb23 100644
--- a/drivers/media/platform/ti-vpe/vpdma.c
+++ b/drivers/media/platform/ti-vpe/vpdma.c
@@ -955,12 +955,12 @@ unsigned int vpdma_get_list_mask(struct vpdma_data *vpdma, int irq_num)
 EXPORT_SYMBOL(vpdma_get_list_mask);
 
 /* clear previosuly occured list intterupts in the LIST_STAT register */
-void vpdma_clear_list_stat(struct vpdma_data *vpdma, int irq_num)
+void vpdma_clear_list_stat(struct vpdma_data *vpdma, int irq_num,
+			   int list_num)
 {
 	u32 reg_addr = VPDMA_INT_LIST0_STAT + VPDMA_INTX_OFFSET * irq_num;
 
-	write_reg(vpdma, reg_addr,
-		read_reg(vpdma, reg_addr));
+	write_reg(vpdma, reg_addr, 3 << (list_num * 2));
 }
 EXPORT_SYMBOL(vpdma_clear_list_stat);
 
diff --git a/drivers/media/platform/ti-vpe/vpdma.h b/drivers/media/platform/ti-vpe/vpdma.h
index f08f4370ce4a..65961147e8f7 100644
--- a/drivers/media/platform/ti-vpe/vpdma.h
+++ b/drivers/media/platform/ti-vpe/vpdma.h
@@ -244,7 +244,8 @@ int vpdma_list_cleanup(struct vpdma_data *vpdma, int list_num,
 /* vpdma list interrupt management */
 void vpdma_enable_list_complete_irq(struct vpdma_data *vpdma, int irq_num,
 		int list_num, bool enable);
-void vpdma_clear_list_stat(struct vpdma_data *vpdma, int irq_num);
+void vpdma_clear_list_stat(struct vpdma_data *vpdma, int irq_num,
+			   int list_num);
 unsigned int vpdma_get_list_stat(struct vpdma_data *vpdma, int irq_num);
 unsigned int vpdma_get_list_mask(struct vpdma_data *vpdma, int irq_num);
 
diff --git a/drivers/media/platform/ti-vpe/vpe.c b/drivers/media/platform/ti-vpe/vpe.c
index 9823ee368a01..000cd073fa8d 100644
--- a/drivers/media/platform/ti-vpe/vpe.c
+++ b/drivers/media/platform/ti-vpe/vpe.c
@@ -1326,7 +1326,7 @@ static irqreturn_t vpe_irq(int irq_vpe, void *data)
 
 	if (irqst0) {
 		if (irqst0 & VPE_INT0_LIST0_COMPLETE)
-			vpdma_clear_list_stat(ctx->dev->vpdma, 0);
+			vpdma_clear_list_stat(ctx->dev->vpdma, 0, 0);
 
 		irqst0 &= ~(VPE_INT0_LIST0_COMPLETE);
 	}
-- 
2.9.0

