Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f174.google.com ([209.85.212.174]:57111 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752975Ab1LVPFe (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 22 Dec 2011 10:05:34 -0500
Received: by wibhm6 with SMTP id hm6so2585404wib.19
        for <linux-media@vger.kernel.org>; Thu, 22 Dec 2011 07:05:32 -0800 (PST)
From: Javier Martin <javier.martin@vista-silicon.com>
To: linux-media@vger.kernel.org
Cc: mchehab@infradead.org, g.liakhovetski@gmx.de, lethal@linux-sh.org,
	hans.verkuil@cisco.com, s.hauer@pengutronix.de,
	Javier Martin <javier.martin@vista-silicon.com>
Subject: [PATCH] media i.MX27 camera: Fix field_count handling.
Date: Thu, 22 Dec 2011 16:05:21 +0100
Message-Id: <1324566321-13953-1-git-send-email-javier.martin@vista-silicon.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

To properly detect frame loss the driver must keep
track of a frame_count.

Furthermore, field_count use was erroneous because
in progressive format this must be incremented twice.

Signed-off-by: Javier Martin <javier.martin@vista-silicon.com>
---
 drivers/media/video/mx2_camera.c  |    5 ++++-
 drivers/media/video/mx2_emmaprp.c |   29 ++++++++++-------------------
 2 files changed, 14 insertions(+), 20 deletions(-)

diff --git a/drivers/media/video/mx2_camera.c b/drivers/media/video/mx2_camera.c
index ea1f4dc..ca76dd2 100644
--- a/drivers/media/video/mx2_camera.c
+++ b/drivers/media/video/mx2_camera.c
@@ -255,6 +255,7 @@ struct mx2_camera_dev {
 	dma_addr_t		discard_buffer_dma;
 	size_t			discard_size;
 	struct mx2_fmt_cfg	*emma_prp;
+	u32			frame_count;
 };
 
 /* buffer for one video frame */
@@ -368,6 +369,7 @@ static int mx2_camera_add_device(struct soc_camera_device *icd)
 	writel(pcdev->csicr1, pcdev->base_csi + CSICR1);
 
 	pcdev->icd = icd;
+	pcdev->frame_count = 0;
 
 	dev_info(icd->parent, "Camera driver attached to camera %d\n",
 		 icd->devnum);
@@ -1211,7 +1213,8 @@ static void mx27_camera_frame_done_emma(struct mx2_camera_dev *pcdev,
 		list_del(&vb->queue);
 		vb->state = state;
 		do_gettimeofday(&vb->ts);
-		vb->field_count++;
+		vb->field_count = pcdev->frame_count * 2;
+		pcdev->frame_count++;
 
 		wake_up(&vb->done);
 	}
diff --git a/drivers/media/video/mx2_emmaprp.c b/drivers/media/video/mx2_emmaprp.c
index 607b73f..fb87665 100644
--- a/drivers/media/video/mx2_emmaprp.c
+++ b/drivers/media/video/mx2_emmaprp.c
@@ -16,6 +16,7 @@
  * Free Software Foundation; either version 2 of the
  * License, or (at your option) any later version
  */
+
 #include <linux/module.h>
 #include <linux/clk.h>
 #include <linux/slab.h>
@@ -35,7 +36,7 @@ MODULE_AUTHOR("Javier Martin <javier.martin@vista-silicon.com");
 MODULE_LICENSE("GPL");
 MODULE_VERSION("0.0.1");
 
-static bool debug;
+static bool debug = true;
 module_param(debug, bool, 0644);
 
 #define MIN_W 32
@@ -250,10 +251,11 @@ static int emmaprp_job_ready(void *priv)
 {
 	struct emmaprp_ctx *ctx = priv;
 	struct emmaprp_dev *pcdev = ctx->dev;
+	struct dma_chan *chan = pcdev->dma_chan;
 
 	if ((v4l2_m2m_num_src_bufs_ready(ctx->m2m_ctx) > 0)
 	    && (v4l2_m2m_num_dst_bufs_ready(ctx->m2m_ctx) > 0)
-	    && (atomic_read(&pcdev->busy) == 0))
+	    && (dma_async_memcpy_complete(chan, ctx->cookie, NULL, NULL) == 0))
 		return 1;
 
 	dprintk(pcdev, "Task not ready to run\n");
@@ -290,10 +292,8 @@ static void emmaprp_unlock(void *priv)
 static void emmaprp_dma_callback(void *data)
 {
 	struct emmaprp_dev *pcdev = (struct emmaprp_dev *)data;
-	struct dma_chan *chan = pcdev->dma_chan;
 	struct vb2_buffer *src_vb, *dst_vb;
 	struct emmaprp_ctx *curr_ctx;
-	enum dma_status status;
 	unsigned long flags;
 
 	curr_ctx = v4l2_m2m_get_curr_priv(pcdev->m2m_dev);
@@ -306,26 +306,18 @@ static void emmaprp_dma_callback(void *data)
 	if (curr_ctx->aborting)
 		goto irq_ok;
 
-	status = dma_async_memcpy_complete(chan, curr_ctx->cookie, NULL, NULL);
-	if (status != DMA_SUCCESS) {
-		v4l2_warn(&pcdev->v4l2_dev,
-			  "DMA got completion callback but status is \'%s\'\n",
-			  status == DMA_ERROR ? "error" : "in progress");
-		goto irq_ok;
-	}
-
 	src_vb = v4l2_m2m_src_buf_remove(curr_ctx->m2m_ctx);
 	dst_vb = v4l2_m2m_dst_buf_remove(curr_ctx->m2m_ctx);
 	dst_vb->v4l2_buf.sequence = src_vb->v4l2_buf.sequence;
-
+printk("%s: dstbuf sequence =%d, srcbuf sequence = %d\n", __func__, dst_vb->v4l2_buf.sequence, src_vb->v4l2_buf.sequence);
 	spin_lock_irqsave(&pcdev->irqlock, flags);
 	v4l2_m2m_buf_done(src_vb, VB2_BUF_STATE_DONE);
 	v4l2_m2m_buf_done(dst_vb, VB2_BUF_STATE_DONE);
 	spin_unlock_irqrestore(&pcdev->irqlock, flags);
 
 irq_ok:
-	atomic_set(&pcdev->busy, 0);
 	v4l2_m2m_job_finish(pcdev->m2m_dev, curr_ctx->m2m_ctx);
+printk("DMA IRQ\n");
 }
 
 static void emmaprp_device_run(void *priv)
@@ -342,7 +334,6 @@ static void emmaprp_device_run(void *priv)
 	unsigned int d_size, s_size;
 	dma_addr_t p_in, p_out;
 	enum dma_ctrl_flags flags;
-	dma_cookie_t cookie;
 
 	atomic_set(&ctx->dev->busy, 1);
 
@@ -382,12 +373,12 @@ static void emmaprp_device_run(void *priv)
 	}
 	tx->callback = emmaprp_dma_callback;
 	tx->callback_param = pcdev;
-	cookie = tx->tx_submit(tx);
-	ctx->cookie = cookie;
-	if (dma_submit_error(cookie)) {
+	ctx->cookie = tx->tx_submit(tx);
+
+	if (dma_submit_error(ctx->cookie)) {
 		v4l2_warn(&pcdev->v4l2_dev,
 			  "DMA submit error %d with src=0x%x dst=0x%x len=0x%x\n",
-			  cookie, p_in, p_out, s_size * 3/2);
+			  ctx->cookie, p_in, p_out, s_size * 3/2);
 		return;
 	}
 	dma_async_issue_pending(chan);
-- 
1.7.0.4

