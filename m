Return-path: <linux-media-owner@vger.kernel.org>
Received: from lelnx193.ext.ti.com ([198.47.27.77]:60371 "EHLO
        lelnx193.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753335AbcKRXVI (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 18 Nov 2016 18:21:08 -0500
From: Benoit Parrot <bparrot@ti.com>
To: <linux-media@vger.kernel.org>, Hans Verkuil <hverkuil@xs4all.nl>
CC: <linux-kernel@vger.kernel.org>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>,
        Jyri Sarha <jsarha@ti.com>,
        Peter Ujfalusi <peter.ujfalusi@ti.com>,
        Benoit Parrot <bparrot@ti.com>
Subject: [Patch v2 13/35] media: ti-vpe: vpdma: Make list post atomic operation
Date: Fri, 18 Nov 2016 17:20:23 -0600
Message-ID: <20161118232045.24665-14-bparrot@ti.com>
In-Reply-To: <20161118232045.24665-1-bparrot@ti.com>
References: <20161118232045.24665-1-bparrot@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Nikhil Devshatwar <nikhil.nd@ti.com>

Writing to the "VPDMA list attribute" register is considered as a list
post. This informs the VPDMA firmware to load the list from the address
which should be taken from the "VPDMA list address" register.

As these two register writes are dependent, it is important that the two
writes happen in atomic manner. This ensures multiple slices (which share
same VPDMA) can post lists asynchronously and all of them point to the
correct addresses.

Slightly modified to implementation for the original patch to use
spin_lock instead of mutex as the list post is also called from
interrupt context.

Signed-off-by: Nikhil Devshatwar <nikhil.nd@ti.com>
Signed-off-by: Benoit Parrot <bparrot@ti.com>
Acked-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/platform/ti-vpe/vpdma.c | 4 ++++
 drivers/media/platform/ti-vpe/vpdma.h | 1 +
 2 files changed, 5 insertions(+)

diff --git a/drivers/media/platform/ti-vpe/vpdma.c b/drivers/media/platform/ti-vpe/vpdma.c
index 7808c9c1828b..ffc281d2b065 100644
--- a/drivers/media/platform/ti-vpe/vpdma.c
+++ b/drivers/media/platform/ti-vpe/vpdma.c
@@ -491,6 +491,7 @@ int vpdma_submit_descs(struct vpdma_data *vpdma,
 			struct vpdma_desc_list *list, int list_num)
 {
 	int list_size;
+	unsigned long flags;
 
 	if (vpdma_list_busy(vpdma, list_num))
 		return -EBUSY;
@@ -498,12 +499,14 @@ int vpdma_submit_descs(struct vpdma_data *vpdma,
 	/* 16-byte granularity */
 	list_size = (list->next - list->buf.addr) >> 4;
 
+	spin_lock_irqsave(&vpdma->lock, flags);
 	write_reg(vpdma, VPDMA_LIST_ADDR, (u32) list->buf.dma_addr);
 
 	write_reg(vpdma, VPDMA_LIST_ATTR,
 			(list_num << VPDMA_LIST_NUM_SHFT) |
 			(list->type << VPDMA_LIST_TYPE_SHFT) |
 			list_size);
+	spin_unlock_irqrestore(&vpdma->lock, flags);
 
 	return 0;
 }
@@ -1090,6 +1093,7 @@ struct vpdma_data *vpdma_create(struct platform_device *pdev,
 
 	vpdma->pdev = pdev;
 	vpdma->cb = cb;
+	spin_lock_init(&vpdma->lock);
 
 	res = platform_get_resource_byname(pdev, IORESOURCE_MEM, "vpdma");
 	if (res == NULL) {
diff --git a/drivers/media/platform/ti-vpe/vpdma.h b/drivers/media/platform/ti-vpe/vpdma.h
index 4dafc1bcf116..f08f4370ce4a 100644
--- a/drivers/media/platform/ti-vpe/vpdma.h
+++ b/drivers/media/platform/ti-vpe/vpdma.h
@@ -35,6 +35,7 @@ struct vpdma_data {
 
 	struct platform_device	*pdev;
 
+	spinlock_t		lock;
 	/* callback to VPE driver when the firmware is loaded */
 	void (*cb)(struct platform_device *pdev);
 };
-- 
2.9.0

