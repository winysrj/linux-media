Return-path: <linux-media-owner@vger.kernel.org>
Received: from fllnx210.ext.ti.com ([198.47.19.17]:42895 "EHLO
        fllnx210.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752730AbcKRXVK (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 18 Nov 2016 18:21:10 -0500
From: Benoit Parrot <bparrot@ti.com>
To: <linux-media@vger.kernel.org>, Hans Verkuil <hverkuil@xs4all.nl>
CC: <linux-kernel@vger.kernel.org>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>,
        Jyri Sarha <jsarha@ti.com>,
        Peter Ujfalusi <peter.ujfalusi@ti.com>,
        Benoit Parrot <bparrot@ti.com>
Subject: [Patch v2 14/35] media: ti-vpe: vpdma: Clear IRQs for individual lists
Date: Fri, 18 Nov 2016 17:20:24 -0600
Message-ID: <20161118232045.24665-15-bparrot@ti.com>
In-Reply-To: <20161118232045.24665-1-bparrot@ti.com>
References: <20161118232045.24665-1-bparrot@ti.com>
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
Acked-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/platform/ti-vpe/vpdma.c | 6 +++---
 drivers/media/platform/ti-vpe/vpdma.h | 3 ++-
 drivers/media/platform/ti-vpe/vpe.c   | 2 +-
 3 files changed, 6 insertions(+), 5 deletions(-)

diff --git a/drivers/media/platform/ti-vpe/vpdma.c b/drivers/media/platform/ti-vpe/vpdma.c
index ffc281d2b065..c0a4e035bc2a 100644
--- a/drivers/media/platform/ti-vpe/vpdma.c
+++ b/drivers/media/platform/ti-vpe/vpdma.c
@@ -953,12 +953,12 @@ unsigned int vpdma_get_list_mask(struct vpdma_data *vpdma, int irq_num)
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
index 151a9280bb85..6fcdd0ea50e4 100644
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

