Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.187]:55643 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932196Ab1HaSC5 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 31 Aug 2011 14:02:57 -0400
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Pawel Osciak <pawel@osciak.com>,
	Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Marek Szyprowski <m.szyprowski@samsung.com>
Subject: [PATCH 7/9 v6] dmaengine: ipu-idmac: add support for the DMA_PAUSE control
Date: Wed, 31 Aug 2011 20:02:46 +0200
Message-Id: <1314813768-27752-8-git-send-email-g.liakhovetski@gmx.de>
In-Reply-To: <1314813768-27752-1-git-send-email-g.liakhovetski@gmx.de>
References: <1314813768-27752-1-git-send-email-g.liakhovetski@gmx.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

To support multi-size buffers in the mx3_camera V4L2 driver we have to be
able to stop DMA on a channel without releasing descriptors and completely
halting the hardware. Use the DMA_PAUSE control to implement this mode.

Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Acked-by: Vinod Koul <vinod.koul@linux.intel.com>
Cc: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: Pawel Osciak <pawel@osciak.com>
Cc: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>
---
 drivers/dma/ipu/ipu_idmac.c |   65 +++++++++++++++++++++++++++---------------
 1 files changed, 42 insertions(+), 23 deletions(-)

diff --git a/drivers/dma/ipu/ipu_idmac.c b/drivers/dma/ipu/ipu_idmac.c
index c1a125e..42cdf1c 100644
--- a/drivers/dma/ipu/ipu_idmac.c
+++ b/drivers/dma/ipu/ipu_idmac.c
@@ -1306,6 +1306,7 @@ static irqreturn_t idmac_interrupt(int irq, void *dev_id)
 	    ipu_submit_buffer(ichan, descnew, sgnew, ichan->active_buffer) < 0) {
 		callback = descnew->txd.callback;
 		callback_param = descnew->txd.callback_param;
+		list_del_init(&descnew->list);
 		spin_unlock(&ichan->lock);
 		if (callback)
 			callback(callback_param);
@@ -1427,39 +1428,58 @@ static int __idmac_control(struct dma_chan *chan, enum dma_ctrl_cmd cmd,
 {
 	struct idmac_channel *ichan = to_idmac_chan(chan);
 	struct idmac *idmac = to_idmac(chan->device);
+	struct ipu *ipu = to_ipu(idmac);
+	struct list_head *list, *tmp;
 	unsigned long flags;
 	int i;
 
-	/* Only supports DMA_TERMINATE_ALL */
-	if (cmd != DMA_TERMINATE_ALL)
-		return -ENXIO;
+	switch (cmd) {
+	case DMA_PAUSE:
+		spin_lock_irqsave(&ipu->lock, flags);
+		ipu_ic_disable_task(ipu, chan->chan_id);
 
-	ipu_disable_channel(idmac, ichan,
-			    ichan->status >= IPU_CHANNEL_ENABLED);
+		/* Return all descriptors into "prepared" state */
+		list_for_each_safe(list, tmp, &ichan->queue)
+			list_del_init(list);
 
-	tasklet_disable(&to_ipu(idmac)->tasklet);
+		ichan->sg[0] = NULL;
+		ichan->sg[1] = NULL;
 
-	/* ichan->queue is modified in ISR, have to spinlock */
-	spin_lock_irqsave(&ichan->lock, flags);
-	list_splice_init(&ichan->queue, &ichan->free_list);
+		spin_unlock_irqrestore(&ipu->lock, flags);
 
-	if (ichan->desc)
-		for (i = 0; i < ichan->n_tx_desc; i++) {
-			struct idmac_tx_desc *desc = ichan->desc + i;
-			if (list_empty(&desc->list))
-				/* Descriptor was prepared, but not submitted */
-				list_add(&desc->list, &ichan->free_list);
+		ichan->status = IPU_CHANNEL_INITIALIZED;
+		break;
+	case DMA_TERMINATE_ALL:
+		ipu_disable_channel(idmac, ichan,
+				    ichan->status >= IPU_CHANNEL_ENABLED);
 
-			async_tx_clear_ack(&desc->txd);
-		}
+		tasklet_disable(&ipu->tasklet);
 
-	ichan->sg[0] = NULL;
-	ichan->sg[1] = NULL;
-	spin_unlock_irqrestore(&ichan->lock, flags);
+		/* ichan->queue is modified in ISR, have to spinlock */
+		spin_lock_irqsave(&ichan->lock, flags);
+		list_splice_init(&ichan->queue, &ichan->free_list);
 
-	tasklet_enable(&to_ipu(idmac)->tasklet);
+		if (ichan->desc)
+			for (i = 0; i < ichan->n_tx_desc; i++) {
+				struct idmac_tx_desc *desc = ichan->desc + i;
+				if (list_empty(&desc->list))
+					/* Descriptor was prepared, but not submitted */
+					list_add(&desc->list, &ichan->free_list);
 
-	ichan->status = IPU_CHANNEL_INITIALIZED;
+				async_tx_clear_ack(&desc->txd);
+			}
+
+		ichan->sg[0] = NULL;
+		ichan->sg[1] = NULL;
+		spin_unlock_irqrestore(&ichan->lock, flags);
+
+		tasklet_enable(&ipu->tasklet);
+
+		ichan->status = IPU_CHANNEL_INITIALIZED;
+		break;
+	default:
+		return -ENOSYS;
+	}
 
 	return 0;
 }
@@ -1662,7 +1682,6 @@ static void __exit ipu_idmac_exit(struct ipu *ipu)
 		struct idmac_channel *ichan = ipu->channel + i;
 
 		idmac_control(&ichan->dma_chan, DMA_TERMINATE_ALL, 0);
-		idmac_prep_slave_sg(&ichan->dma_chan, NULL, 0, DMA_NONE, 0);
 	}
 
 	dma_async_device_unregister(&idmac->dma);
-- 
1.7.2.5

