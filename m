Return-path: <linux-media-owner@vger.kernel.org>
Received: from bear.ext.ti.com ([198.47.19.11]:58208 "EHLO bear.ext.ti.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933687AbcI1VWO (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 28 Sep 2016 17:22:14 -0400
From: Benoit Parrot <bparrot@ti.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: <linux-media@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [Patch 19/35] media: ti-vpe: vpdma: allocate and maintain hwlist
Date: Wed, 28 Sep 2016 16:22:11 -0500
Message-ID: <20160928212211.27175-1-bparrot@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Nikhil Devshatwar <nikhil.nd@ti.com>

VPDMA block used in ti-vip and ti-vpe modules have support for
up to 8 hardware descriptor lists. A descriptor list can be
submitted to any of the 8 lists (as long as it's not busy).

When multiple clients want to transfer data in parallel, its easier
to allocate one list per client and let it use it. This way, the
list numbers need not be hard-coded into the driver.

Add support for allocating hwlist and maintain them with a priv data.

Signed-off-by: Nikhil Devshatwar <nikhil.nd@ti.com>
Signed-off-by: Benoit Parrot <bparrot@ti.com>
---
 drivers/media/platform/ti-vpe/vpdma.c | 44 +++++++++++++++++++++++++++++++++++
 drivers/media/platform/ti-vpe/vpdma.h |  9 +++++++
 2 files changed, 53 insertions(+)

diff --git a/drivers/media/platform/ti-vpe/vpdma.c b/drivers/media/platform/ti-vpe/vpdma.c
index 96b5633ebb23..9f396ff03394 100644
--- a/drivers/media/platform/ti-vpe/vpdma.c
+++ b/drivers/media/platform/ti-vpe/vpdma.c
@@ -904,6 +904,50 @@ void vpdma_add_in_dtd(struct vpdma_desc_list *list, int width,
 }
 EXPORT_SYMBOL(vpdma_add_in_dtd);
 
+int vpdma_hwlist_alloc(struct vpdma_data *vpdma, void *priv)
+{
+	int i, list_num = -1;
+	unsigned long flags;
+
+	spin_lock_irqsave(&vpdma->lock, flags);
+	for (i = 0; i < VPDMA_MAX_NUM_LIST &&
+	    vpdma->hwlist_used[i] == true; i++)
+		;
+
+	if (i < VPDMA_MAX_NUM_LIST) {
+		list_num = i;
+		vpdma->hwlist_used[i] = true;
+		vpdma->hwlist_priv[i] = priv;
+	}
+	spin_unlock_irqrestore(&vpdma->lock, flags);
+
+	return list_num;
+}
+EXPORT_SYMBOL(vpdma_hwlist_alloc);
+
+void *vpdma_hwlist_get_priv(struct vpdma_data *vpdma, int list_num)
+{
+	if (!vpdma || list_num >= VPDMA_MAX_NUM_LIST)
+		return NULL;
+
+	return vpdma->hwlist_priv[list_num];
+}
+EXPORT_SYMBOL(vpdma_hwlist_get_priv);
+
+void *vpdma_hwlist_release(struct vpdma_data *vpdma, int list_num)
+{
+	void *priv;
+	unsigned long flags;
+
+	spin_lock_irqsave(&vpdma->lock, flags);
+	vpdma->hwlist_used[list_num] = false;
+	priv = vpdma->hwlist_priv;
+	spin_unlock_irqrestore(&vpdma->lock, flags);
+
+	return priv;
+}
+EXPORT_SYMBOL(vpdma_hwlist_release);
+
 /* set or clear the mask for list complete interrupt */
 void vpdma_enable_list_complete_irq(struct vpdma_data *vpdma, int irq_num,
 		int list_num, bool enable)
diff --git a/drivers/media/platform/ti-vpe/vpdma.h b/drivers/media/platform/ti-vpe/vpdma.h
index 65961147e8f7..ccf871ad8800 100644
--- a/drivers/media/platform/ti-vpe/vpdma.h
+++ b/drivers/media/platform/ti-vpe/vpdma.h
@@ -13,6 +13,7 @@
 #ifndef __TI_VPDMA_H_
 #define __TI_VPDMA_H_
 
+#define VPDMA_MAX_NUM_LIST		8
 /*
  * A vpdma_buf tracks the size, DMA address and mapping status of each
  * driver DMA area.
@@ -36,6 +37,8 @@ struct vpdma_data {
 	struct platform_device	*pdev;
 
 	spinlock_t		lock;
+	bool			hwlist_used[VPDMA_MAX_NUM_LIST];
+	void			*hwlist_priv[VPDMA_MAX_NUM_LIST];
 	/* callback to VPE driver when the firmware is loaded */
 	void (*cb)(struct platform_device *pdev);
 };
@@ -215,6 +218,12 @@ bool vpdma_list_busy(struct vpdma_data *vpdma, int list_num);
 void vpdma_update_dma_addr(struct vpdma_data *vpdma,
 	struct vpdma_desc_list *list, dma_addr_t dma_addr,
 	void *write_dtd, int drop, int idx);
+
+/* VPDMA hardware list funcs */
+int vpdma_hwlist_alloc(struct vpdma_data *vpdma, void *priv);
+void *vpdma_hwlist_get_priv(struct vpdma_data *vpdma, int list_num);
+void *vpdma_hwlist_release(struct vpdma_data *vpdma, int list_num);
+
 /* helpers for creating vpdma descriptors */
 void vpdma_add_cfd_block(struct vpdma_desc_list *list, int client,
 		struct vpdma_buf *blk, u32 dest_offset);
-- 
2.9.0

