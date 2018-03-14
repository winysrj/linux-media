Return-path: <linux-media-owner@vger.kernel.org>
Received: from bin-mail-out-05.binero.net ([195.74.38.228]:25363 "EHLO
        bin-mail-out-05.binero.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1753063AbeCNCtf (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 13 Mar 2018 22:49:35 -0400
From: =?UTF-8?q?Niklas=20S=C3=B6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org
Cc: linux-renesas-soc@vger.kernel.org, tomoharu.fukawa.eb@renesas.com,
        =?UTF-8?q?Niklas=20S=C3=B6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>
Subject: [PATCH v2 1/2] rcar-vin: allocate a scratch buffer at stream start
Date: Wed, 14 Mar 2018 03:49:09 +0100
Message-Id: <20180314024910.16676-2-niklas.soderlund+renesas@ragnatech.se>
In-Reply-To: <20180314024910.16676-1-niklas.soderlund+renesas@ragnatech.se>
References: <20180314024910.16676-1-niklas.soderlund+renesas@ragnatech.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Before starting a capture, allocate a scratch buffer which can be used
by the driver to give to the hardware if no buffers are available from
userspace. The buffer is not used in this patch but prepares for future
refactoring where the scratch buffer can be used to avoid the need to
fallback on single capture mode if userspace can't queue buffers as fast
as the VIN driver consumes them.

Signed-off-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
Reviewed-by: Jacopo Mondi <jacopo+renesas@jmondi.org>
Reviewed-by: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
---
 drivers/media/platform/rcar-vin/rcar-dma.c | 19 +++++++++++++++++++
 drivers/media/platform/rcar-vin/rcar-vin.h |  4 ++++
 2 files changed, 23 insertions(+)

diff --git a/drivers/media/platform/rcar-vin/rcar-dma.c b/drivers/media/platform/rcar-vin/rcar-dma.c
index 23fdff7a7370842e..1f91b056188ebdb3 100644
--- a/drivers/media/platform/rcar-vin/rcar-dma.c
+++ b/drivers/media/platform/rcar-vin/rcar-dma.c
@@ -1076,6 +1076,17 @@ static int rvin_start_streaming(struct vb2_queue *vq, unsigned int count)
 	unsigned long flags;
 	int ret;
 
+	/* Allocate scratch buffer. */
+	vin->scratch = dma_alloc_coherent(vin->dev, vin->format.sizeimage,
+					  &vin->scratch_phys, GFP_KERNEL);
+	if (!vin->scratch) {
+		spin_lock_irqsave(&vin->qlock, flags);
+		return_all_buffers(vin, VB2_BUF_STATE_QUEUED);
+		spin_unlock_irqrestore(&vin->qlock, flags);
+		vin_err(vin, "Failed to allocate scratch buffer\n");
+		return -ENOMEM;
+	}
+
 	sd = vin_to_source(vin);
 	v4l2_subdev_call(sd, video, s_stream, 1);
 
@@ -1091,6 +1102,10 @@ static int rvin_start_streaming(struct vb2_queue *vq, unsigned int count)
 
 	spin_unlock_irqrestore(&vin->qlock, flags);
 
+	if (ret)
+		dma_free_coherent(vin->dev, vin->format.sizeimage, vin->scratch,
+				  vin->scratch_phys);
+
 	return ret;
 }
 
@@ -1141,6 +1156,10 @@ static void rvin_stop_streaming(struct vb2_queue *vq)
 
 	/* disable interrupts */
 	rvin_disable_interrupts(vin);
+
+	/* Free scratch buffer. */
+	dma_free_coherent(vin->dev, vin->format.sizeimage, vin->scratch,
+			  vin->scratch_phys);
 }
 
 static const struct vb2_ops rvin_qops = {
diff --git a/drivers/media/platform/rcar-vin/rcar-vin.h b/drivers/media/platform/rcar-vin/rcar-vin.h
index 5382078143fb3869..00b405f78d0912c9 100644
--- a/drivers/media/platform/rcar-vin/rcar-vin.h
+++ b/drivers/media/platform/rcar-vin/rcar-vin.h
@@ -102,6 +102,8 @@ struct rvin_graph_entity {
  *
  * @lock:		protects @queue
  * @queue:		vb2 buffers queue
+ * @scratch:		cpu address for scratch buffer
+ * @scratch_phys:	physical address of the scratch buffer
  *
  * @qlock:		protects @queue_buf, @buf_list, @continuous, @sequence
  *			@state
@@ -130,6 +132,8 @@ struct rvin_dev {
 
 	struct mutex lock;
 	struct vb2_queue queue;
+	void *scratch;
+	dma_addr_t scratch_phys;
 
 	spinlock_t qlock;
 	struct vb2_v4l2_buffer *queue_buf[HW_BUFFER_NUM];
-- 
2.16.2
