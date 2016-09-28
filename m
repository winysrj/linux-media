Return-path: <linux-media-owner@vger.kernel.org>
Received: from devils.ext.ti.com ([198.47.26.153]:55809 "EHLO
        devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933994AbcI1VXh (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 28 Sep 2016 17:23:37 -0400
From: Benoit Parrot <bparrot@ti.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: <linux-media@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [Patch 31/35] media: ti-vpe: vpe: Make sure frame size dont exceed scaler capacity
Date: Wed, 28 Sep 2016 16:23:30 -0500
Message-ID: <20160928212330.27715-1-bparrot@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

When scaler is to be used we need to make sure that the input and
output frame size do not exceed the maximum frame sizes that the
scaler h/w can handle otherwise streaming stall as the scaler
cannot proceed.

The scaler buffer is limited to 2047 pixels (i.e. 11 bits) when
attempting anything larger (2048 for example) the scaler stalls.

Realistically in an mem2mem device we can only check for this type
of issue when start_streaming is called. We can't do it during the
try_fmt/s_fmt because we do not have all of the info needed at that
point. So instead when start_streaming is called we need to check
that the input and output frames size do not exceed the scaler's
capability. The only time larger frame size are allowed is when
the input frame szie is the same as the output frame size.

Now in the case where we need to fail, start_streaming must return
all previously queued buffer back otherwise the vb2 framework
will issue kernel WARN messages.
In this case we also give an error message.

Signed-off-by: Benoit Parrot <bparrot@ti.com>
---
 drivers/media/platform/ti-vpe/sc.h  |  6 ++++
 drivers/media/platform/ti-vpe/vpe.c | 71 ++++++++++++++++++++++++++++---------
 2 files changed, 60 insertions(+), 17 deletions(-)

diff --git a/drivers/media/platform/ti-vpe/sc.h b/drivers/media/platform/ti-vpe/sc.h
index d0aab5ef0eca..f1fe80b38c9f 100644
--- a/drivers/media/platform/ti-vpe/sc.h
+++ b/drivers/media/platform/ti-vpe/sc.h
@@ -173,6 +173,12 @@
 /* number of taps expected by the scaler in it's coefficient memory */
 #define SC_NUM_TAPS_MEM_ALIGN		8
 
+/* Maximum frame width the scaler can handle (in pixels) */
+#define SC_MAX_PIXEL_WIDTH		2047
+
+/* Maximum frame height the scaler can handle (in lines) */
+#define SC_MAX_PIXEL_HEIGHT		2047
+
 /*
  * coefficient memory size in bytes:
  * num phases x num sets(luma and chroma) x num taps(aligned) x coeff size
diff --git a/drivers/media/platform/ti-vpe/vpe.c b/drivers/media/platform/ti-vpe/vpe.c
index d0d222b3a173..2b661163d695 100644
--- a/drivers/media/platform/ti-vpe/vpe.c
+++ b/drivers/media/platform/ti-vpe/vpe.c
@@ -2026,28 +2026,33 @@ static void vpe_buf_queue(struct vb2_buffer *vb)
 	v4l2_m2m_buf_queue(ctx->fh.m2m_ctx, vbuf);
 }
 
-static int vpe_start_streaming(struct vb2_queue *q, unsigned int count)
+static int check_srcdst_sizes(struct vpe_ctx *ctx)
 {
-	struct vpe_ctx *ctx = vb2_get_drv_priv(q);
+	struct vpe_q_data *s_q_data =  &ctx->q_data[Q_DATA_SRC];
+	struct vpe_q_data *d_q_data =  &ctx->q_data[Q_DATA_DST];
+	unsigned int src_w = s_q_data->c_rect.width;
+	unsigned int src_h = s_q_data->c_rect.height;
+	unsigned int dst_w = d_q_data->c_rect.width;
+	unsigned int dst_h = d_q_data->c_rect.height;
 
-	if (ctx->deinterlacing)
-		config_edi_input_mode(ctx, 0x0);
+	if (src_w == dst_w && src_h == dst_h)
+		return 0;
 
-	if (ctx->sequence != 0)
-		set_srcdst_params(ctx);
+	if (src_h <= SC_MAX_PIXEL_HEIGHT &&
+	    src_w <= SC_MAX_PIXEL_WIDTH &&
+	    dst_h <= SC_MAX_PIXEL_HEIGHT &&
+	    dst_w <= SC_MAX_PIXEL_WIDTH)
+		return 0;
 
-	return 0;
+	return -1;
 }
 
-static void vpe_stop_streaming(struct vb2_queue *q)
+static void vpe_return_all_buffers(struct vpe_ctx *ctx,  struct vb2_queue *q,
+				   enum vb2_buffer_state state)
 {
-	struct vpe_ctx *ctx = vb2_get_drv_priv(q);
 	struct vb2_v4l2_buffer *vb;
 	unsigned long flags;
 
-	vpe_dump_regs(ctx->dev);
-	vpdma_dump_regs(ctx->dev->vpdma);
-
 	for (;;) {
 		if (V4L2_TYPE_IS_OUTPUT(q->type))
 			vb = v4l2_m2m_src_buf_remove(ctx->fh.m2m_ctx);
@@ -2056,7 +2061,7 @@ static void vpe_stop_streaming(struct vb2_queue *q)
 		if (!vb)
 			break;
 		spin_lock_irqsave(&ctx->dev->lock, flags);
-		v4l2_m2m_buf_done(vb, VB2_BUF_STATE_ERROR);
+		v4l2_m2m_buf_done(vb, state);
 		spin_unlock_irqrestore(&ctx->dev->lock, flags);
 	}
 
@@ -2069,15 +2074,15 @@ static void vpe_stop_streaming(struct vb2_queue *q)
 		spin_lock_irqsave(&ctx->dev->lock, flags);
 
 		if (ctx->src_vbs[2])
-			v4l2_m2m_buf_done(ctx->src_vbs[2], VB2_BUF_STATE_ERROR);
+			v4l2_m2m_buf_done(ctx->src_vbs[2], state);
 
 		if (ctx->src_vbs[1] && (ctx->src_vbs[1] != ctx->src_vbs[2]))
-			v4l2_m2m_buf_done(ctx->src_vbs[1], VB2_BUF_STATE_ERROR);
+			v4l2_m2m_buf_done(ctx->src_vbs[1], state);
 
 		if (ctx->src_vbs[0] &&
 		    (ctx->src_vbs[0] != ctx->src_vbs[1]) &&
 		    (ctx->src_vbs[0] != ctx->src_vbs[2]))
-			v4l2_m2m_buf_done(ctx->src_vbs[0], VB2_BUF_STATE_ERROR);
+			v4l2_m2m_buf_done(ctx->src_vbs[0], state);
 
 		ctx->src_vbs[2] = NULL;
 		ctx->src_vbs[1] = NULL;
@@ -2088,13 +2093,45 @@ static void vpe_stop_streaming(struct vb2_queue *q)
 		if (ctx->dst_vb) {
 			spin_lock_irqsave(&ctx->dev->lock, flags);
 
-			v4l2_m2m_buf_done(ctx->dst_vb, VB2_BUF_STATE_ERROR);
+			v4l2_m2m_buf_done(ctx->dst_vb, state);
 			ctx->dst_vb = NULL;
 			spin_unlock_irqrestore(&ctx->dev->lock, flags);
 		}
 	}
 }
 
+static int vpe_start_streaming(struct vb2_queue *q, unsigned int count)
+{
+	struct vpe_ctx *ctx = vb2_get_drv_priv(q);
+
+	/* Check any of the size exceed maximum scaling sizes */
+	if (check_srcdst_sizes(ctx)) {
+		vpe_err(ctx->dev,
+			"Conversion setup failed, check source and destination parameters\n"
+			);
+		vpe_return_all_buffers(ctx, q, VB2_BUF_STATE_QUEUED);
+		return -EINVAL;
+	}
+
+	if (ctx->deinterlacing)
+		config_edi_input_mode(ctx, 0x0);
+
+	if (ctx->sequence != 0)
+		set_srcdst_params(ctx);
+
+	return 0;
+}
+
+static void vpe_stop_streaming(struct vb2_queue *q)
+{
+	struct vpe_ctx *ctx = vb2_get_drv_priv(q);
+
+	vpe_dump_regs(ctx->dev);
+	vpdma_dump_regs(ctx->dev->vpdma);
+
+	vpe_return_all_buffers(ctx, q, VB2_BUF_STATE_ERROR);
+}
+
 static const struct vb2_ops vpe_qops = {
 	.queue_setup	 = vpe_queue_setup,
 	.buf_prepare	 = vpe_buf_prepare,
-- 
2.9.0

