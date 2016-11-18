Return-path: <linux-media-owner@vger.kernel.org>
Received: from fllnx210.ext.ti.com ([198.47.19.17]:42902 "EHLO
        fllnx210.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753657AbcKRXVV (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 18 Nov 2016 18:21:21 -0500
From: Benoit Parrot <bparrot@ti.com>
To: <linux-media@vger.kernel.org>, Hans Verkuil <hverkuil@xs4all.nl>
CC: <linux-kernel@vger.kernel.org>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>,
        Jyri Sarha <jsarha@ti.com>,
        Peter Ujfalusi <peter.ujfalusi@ti.com>,
        Benoit Parrot <bparrot@ti.com>
Subject: [Patch v2 24/35] media: ti-vpe: vpe: Fix vb2 buffer cleanup
Date: Fri, 18 Nov 2016 17:20:34 -0600
Message-ID: <20161118232045.24665-25-bparrot@ti.com>
In-Reply-To: <20161118232045.24665-1-bparrot@ti.com>
References: <20161118232045.24665-1-bparrot@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

When stop_streaming is called we need to cleanup the queued
vb2 buffers properly.
This was not previously being done which caused kernel
warning when the application using the resources was killed.
Kernel warnings were also generated on successful completion
of a de-interlacing case as well as upon aborting a
conversion.

Make sure every vb2 buffers is properly handled in all cases.

Signed-off-by: Benoit Parrot <bparrot@ti.com>
Acked-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/platform/ti-vpe/vpe.c | 62 +++++++++++++++++++++++++++++++++++--
 1 file changed, 60 insertions(+), 2 deletions(-)

diff --git a/drivers/media/platform/ti-vpe/vpe.c b/drivers/media/platform/ti-vpe/vpe.c
index ef55fb45d0be..f92ad7a473c1 100644
--- a/drivers/media/platform/ti-vpe/vpe.c
+++ b/drivers/media/platform/ti-vpe/vpe.c
@@ -605,7 +605,10 @@ static void free_vbs(struct vpe_ctx *ctx)
 	spin_lock_irqsave(&dev->lock, flags);
 	if (ctx->src_vbs[2]) {
 		v4l2_m2m_buf_done(ctx->src_vbs[2], VB2_BUF_STATE_DONE);
-		v4l2_m2m_buf_done(ctx->src_vbs[1], VB2_BUF_STATE_DONE);
+		if (ctx->src_vbs[1] && (ctx->src_vbs[1] != ctx->src_vbs[2]))
+			v4l2_m2m_buf_done(ctx->src_vbs[1], VB2_BUF_STATE_DONE);
+		ctx->src_vbs[2] = NULL;
+		ctx->src_vbs[1] = NULL;
 	}
 	spin_unlock_irqrestore(&dev->lock, flags);
 }
@@ -1443,6 +1446,14 @@ static irqreturn_t vpe_irq(int irq_vpe, void *data)
 		ctx->src_vbs[1] = ctx->src_vbs[0];
 	}
 
+	/*
+	 * Since the vb2_buf_done has already been called fir therse
+	 * buffer we can now NULL them out so that we won't try
+	 * to clean out stray pointer later on.
+	*/
+	ctx->src_vbs[0] = NULL;
+	ctx->dst_vb = NULL;
+
 	ctx->bufs_completed++;
 	if (ctx->bufs_completed < ctx->bufs_per_job && job_ready(ctx)) {
 		device_run(ctx);
@@ -2027,9 +2038,57 @@ static int vpe_start_streaming(struct vb2_queue *q, unsigned int count)
 static void vpe_stop_streaming(struct vb2_queue *q)
 {
 	struct vpe_ctx *ctx = vb2_get_drv_priv(q);
+	struct vb2_v4l2_buffer *vb;
+	unsigned long flags;
 
 	vpe_dump_regs(ctx->dev);
 	vpdma_dump_regs(ctx->dev->vpdma);
+
+	for (;;) {
+		if (V4L2_TYPE_IS_OUTPUT(q->type))
+			vb = v4l2_m2m_src_buf_remove(ctx->fh.m2m_ctx);
+		else
+			vb = v4l2_m2m_dst_buf_remove(ctx->fh.m2m_ctx);
+		if (!vb)
+			break;
+		spin_lock_irqsave(&ctx->dev->lock, flags);
+		v4l2_m2m_buf_done(vb, VB2_BUF_STATE_ERROR);
+		spin_unlock_irqrestore(&ctx->dev->lock, flags);
+	}
+
+	/*
+	 * Cleanup the in-transit vb2 buffers that have been
+	 * removed from their respective queue already but for
+	 * which procecessing has not been completed yet.
+	 */
+	if (V4L2_TYPE_IS_OUTPUT(q->type)) {
+		spin_lock_irqsave(&ctx->dev->lock, flags);
+
+		if (ctx->src_vbs[2])
+			v4l2_m2m_buf_done(ctx->src_vbs[2], VB2_BUF_STATE_ERROR);
+
+		if (ctx->src_vbs[1] && (ctx->src_vbs[1] != ctx->src_vbs[2]))
+			v4l2_m2m_buf_done(ctx->src_vbs[1], VB2_BUF_STATE_ERROR);
+
+		if (ctx->src_vbs[0] &&
+		    (ctx->src_vbs[0] != ctx->src_vbs[1]) &&
+		    (ctx->src_vbs[0] != ctx->src_vbs[2]))
+			v4l2_m2m_buf_done(ctx->src_vbs[0], VB2_BUF_STATE_ERROR);
+
+		ctx->src_vbs[2] = NULL;
+		ctx->src_vbs[1] = NULL;
+		ctx->src_vbs[0] = NULL;
+
+		spin_unlock_irqrestore(&ctx->dev->lock, flags);
+	} else {
+		if (ctx->dst_vb) {
+			spin_lock_irqsave(&ctx->dev->lock, flags);
+
+			v4l2_m2m_buf_done(ctx->dst_vb, VB2_BUF_STATE_ERROR);
+			ctx->dst_vb = NULL;
+			spin_unlock_irqrestore(&ctx->dev->lock, flags);
+		}
+	}
 }
 
 static const struct vb2_ops vpe_qops = {
@@ -2222,7 +2281,6 @@ static int vpe_release(struct file *file)
 	vpe_dbg(dev, "releasing instance %p\n", ctx);
 
 	mutex_lock(&dev->dev_mutex);
-	free_vbs(ctx);
 	free_mv_buffers(ctx);
 	vpdma_free_desc_list(&ctx->desc_list);
 	vpdma_free_desc_buf(&ctx->mmr_adb);
-- 
2.9.0

