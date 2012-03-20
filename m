Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.w1.samsung.com ([210.118.77.13]:23652 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757644Ab2CTKjL (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 20 Mar 2012 06:39:11 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN
Received: from euspt2 ([210.118.77.13]) by mailout3.w1.samsung.com
 (Sun Java(tm) System Messaging Server 6.3-8.04 (built Jul 29 2009; 32bit))
 with ESMTP id <0M1600EI4IX3VN70@mailout3.w1.samsung.com> for
 linux-media@vger.kernel.org; Tue, 20 Mar 2012 10:39:03 +0000 (GMT)
Received: from linux.samsung.com ([106.116.38.10])
 by spt2.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0M1600B6CIX6H2@spt2.w1.samsung.com> for
 linux-media@vger.kernel.org; Tue, 20 Mar 2012 10:39:07 +0000 (GMT)
Date: Tue, 20 Mar 2012 11:39:02 +0100
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [PATCH 3/6] s5p-fimc: Simplify locking by removing the context data
 structure spinlock
In-reply-to: <1332239945-32711-1-git-send-email-s.nawrocki@samsung.com>
To: linux-media@vger.kernel.org
Cc: m.szyprowski@samsung.com, riverful.kim@samsung.com,
	sw0312.kim@samsung.com, s.nawrocki@samsung.com,
	Kyungmin Park <kyungmin.park@samsung.com>
Message-id: <1332239945-32711-4-git-send-email-s.nawrocki@samsung.com>
References: <1332239945-32711-1-git-send-email-s.nawrocki@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Access to the memory-to-memory video node is serialized through a
mutex so now there is no point in having per device context structure
spinlock.

Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/media/video/s5p-fimc/fimc-capture.c |   28 +++++++++++++--------------
 drivers/media/video/s5p-fimc/fimc-core.c    |   23 ++++++++--------------
 drivers/media/video/s5p-fimc/fimc-core.h    |   12 +++++-------
 3 files changed, 27 insertions(+), 36 deletions(-)

diff --git a/drivers/media/video/s5p-fimc/fimc-capture.c b/drivers/media/video/s5p-fimc/fimc-capture.c
index a080f0c..dc18ba5 100644
--- a/drivers/media/video/s5p-fimc/fimc-capture.c
+++ b/drivers/media/video/s5p-fimc/fimc-capture.c
@@ -147,21 +147,22 @@ int fimc_capture_config_update(struct fimc_ctx *ctx)
 	if (!test_bit(ST_CAPT_APPLY_CFG, &fimc->state))
 		return 0;
 
-	spin_lock(&ctx->slock);
 	fimc_hw_set_camera_offset(fimc, &ctx->s_frame);
+
 	ret = fimc_set_scaler_info(ctx);
-	if (ret == 0) {
-		fimc_hw_set_prescaler(ctx);
-		fimc_hw_set_mainscaler(ctx);
-		fimc_hw_set_target_format(ctx);
-		fimc_hw_set_rotation(ctx);
-		fimc_prepare_dma_offset(ctx, &ctx->d_frame);
-		fimc_hw_set_out_dma(ctx);
-		if (fimc->variant->has_alpha)
-			fimc_hw_set_rgb_alpha(ctx);
-		clear_bit(ST_CAPT_APPLY_CFG, &fimc->state);
-	}
-	spin_unlock(&ctx->slock);
+	if (ret)
+		return ret;
+
+	fimc_hw_set_prescaler(ctx);
+	fimc_hw_set_mainscaler(ctx);
+	fimc_hw_set_target_format(ctx);
+	fimc_hw_set_rotation(ctx);
+	fimc_prepare_dma_offset(ctx, &ctx->d_frame);
+	fimc_hw_set_out_dma(ctx);
+	if (fimc->variant->has_alpha)
+		fimc_hw_set_rgb_alpha(ctx);
+
+	clear_bit(ST_CAPT_APPLY_CFG, &fimc->state);
 	return ret;
 }
 
@@ -1525,7 +1526,6 @@ int fimc_register_capture_device(struct fimc_dev *fimc,
 
 	INIT_LIST_HEAD(&vid_cap->pending_buf_q);
 	INIT_LIST_HEAD(&vid_cap->active_buf_q);
-	spin_lock_init(&ctx->slock);
 	vid_cap->ctx = ctx;
 
 	q = &fimc->vid_cap.vbq;
diff --git a/drivers/media/video/s5p-fimc/fimc-core.c b/drivers/media/video/s5p-fimc/fimc-core.c
index e184e65..8a5951f 100644
--- a/drivers/media/video/s5p-fimc/fimc-core.c
+++ b/drivers/media/video/s5p-fimc/fimc-core.c
@@ -320,7 +320,7 @@ static int fimc_m2m_shutdown(struct fimc_ctx *ctx)
 	if (!fimc_m2m_pending(fimc))
 		return 0;
 
-	fimc_ctx_state_lock_set(FIMC_CTX_SHUT, ctx);
+	fimc_ctx_state_set(FIMC_CTX_SHUT, ctx);
 
 	ret = wait_event_timeout(fimc->irq_queue,
 			   !fimc_ctx_state_is_set(FIMC_CTX_SHUT, ctx),
@@ -430,14 +430,12 @@ static irqreturn_t fimc_irq_handler(int irq, void *priv)
 			spin_unlock(&fimc->slock);
 			fimc_m2m_job_finish(ctx, VB2_BUF_STATE_DONE);
 
-			spin_lock(&ctx->slock);
 			if (ctx->state & FIMC_CTX_SHUT) {
 				ctx->state &= ~FIMC_CTX_SHUT;
 				wake_up(&fimc->irq_queue);
 			}
-			spin_unlock(&ctx->slock);
+			return IRQ_HANDLED;
 		}
-		return IRQ_HANDLED;
 	} else if (test_bit(ST_CAPT_PEND, &fimc->state)) {
 		fimc_capture_irq_handler(fimc,
 				 !test_bit(ST_CAPT_JPEG, &fimc->state));
@@ -644,7 +642,6 @@ static void fimc_dma_run(void *priv)
 	spin_lock_irqsave(&fimc->slock, flags);
 	set_bit(ST_M2M_PEND, &fimc->state);
 
-	spin_lock(&ctx->slock);
 	ctx->state |= (FIMC_SRC_ADDR | FIMC_DST_ADDR);
 	ret = fimc_prepare_config(ctx, ctx->state);
 	if (ret)
@@ -661,10 +658,8 @@ static void fimc_dma_run(void *priv)
 		fimc_hw_set_input_path(ctx);
 		fimc_hw_set_in_dma(ctx);
 		ret = fimc_set_scaler_info(ctx);
-		if (ret) {
-			spin_unlock(&fimc->slock);
+		if (ret)
 			goto dma_unlock;
-		}
 		fimc_hw_set_prescaler(ctx);
 		fimc_hw_set_mainscaler(ctx);
 		fimc_hw_set_target_format(ctx);
@@ -688,7 +683,6 @@ static void fimc_dma_run(void *priv)
 		       FIMC_SRC_FMT | FIMC_DST_FMT);
 	fimc_hw_activate_input_dma(fimc, true);
 dma_unlock:
-	spin_unlock(&ctx->slock);
 	spin_unlock_irqrestore(&fimc->slock, flags);
 }
 
@@ -827,9 +821,9 @@ static int fimc_s_ctrl(struct v4l2_ctrl *ctrl)
 	unsigned long flags;
 	int ret;
 
-	spin_lock_irqsave(&ctx->slock, flags);
+	spin_lock_irqsave(&ctx->fimc_dev->slock, flags);
 	ret = __fimc_s_ctrl(ctx, ctrl);
-	spin_unlock_irqrestore(&ctx->slock, flags);
+	spin_unlock_irqrestore(&ctx->fimc_dev->slock, flags);
 
 	return ret;
 }
@@ -1174,9 +1168,9 @@ static int fimc_m2m_s_fmt_mplane(struct file *file, void *fh,
 	ctx->scaler.enabled = 1;
 
 	if (f->type == V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE)
-		fimc_ctx_state_lock_set(FIMC_PARAMS | FIMC_DST_FMT, ctx);
+		fimc_ctx_state_set(FIMC_PARAMS | FIMC_DST_FMT, ctx);
 	else
-		fimc_ctx_state_lock_set(FIMC_PARAMS | FIMC_SRC_FMT, ctx);
+		fimc_ctx_state_set(FIMC_PARAMS | FIMC_SRC_FMT, ctx);
 
 	dbg("f_w: %d, f_h: %d", frame->f_width, frame->f_height);
 
@@ -1363,7 +1357,7 @@ static int fimc_m2m_s_crop(struct file *file, void *fh, struct v4l2_crop *cr)
 	f->width  = cr->c.width;
 	f->height = cr->c.height;
 
-	fimc_ctx_state_lock_set(FIMC_PARAMS, ctx);
+	fimc_ctx_state_set(FIMC_PARAMS, ctx);
 
 	return 0;
 }
@@ -1467,7 +1461,6 @@ static int fimc_m2m_open(struct file *file)
 	ctx->flags = 0;
 	ctx->in_path = FIMC_DMA;
 	ctx->out_path = FIMC_DMA;
-	spin_lock_init(&ctx->slock);
 
 	ctx->m2m_ctx = v4l2_m2m_ctx_init(fimc->m2m.m2m_dev, ctx, queue_init);
 	if (IS_ERR(ctx->m2m_ctx)) {
diff --git a/drivers/media/video/s5p-fimc/fimc-core.h b/drivers/media/video/s5p-fimc/fimc-core.h
index a18291e..54198c7 100644
--- a/drivers/media/video/s5p-fimc/fimc-core.h
+++ b/drivers/media/video/s5p-fimc/fimc-core.h
@@ -465,7 +465,6 @@ struct fimc_dev {
 
 /**
  * fimc_ctx - the device context data
- * @slock:		spinlock protecting this data structure
  * @s_frame:		source frame properties
  * @d_frame:		destination frame properties
  * @out_order_1p:	output 1-plane YCBCR order
@@ -492,7 +491,6 @@ struct fimc_dev {
  * @ctrls_rdy:		true if the control handler is initialized
  */
 struct fimc_ctx {
-	spinlock_t		slock;
 	struct fimc_frame	s_frame;
 	struct fimc_frame	d_frame;
 	u32			out_order_1p;
@@ -560,13 +558,13 @@ static inline bool fimc_capture_active(struct fimc_dev *fimc)
 	return ret;
 }
 
-static inline void fimc_ctx_state_lock_set(u32 state, struct fimc_ctx *ctx)
+static inline void fimc_ctx_state_set(u32 state, struct fimc_ctx *ctx)
 {
 	unsigned long flags;
 
-	spin_lock_irqsave(&ctx->slock, flags);
+	spin_lock_irqsave(&ctx->fimc_dev->slock, flags);
 	ctx->state |= state;
-	spin_unlock_irqrestore(&ctx->slock, flags);
+	spin_unlock_irqrestore(&ctx->fimc_dev->slock, flags);
 }
 
 static inline bool fimc_ctx_state_is_set(u32 mask, struct fimc_ctx *ctx)
@@ -574,9 +572,9 @@ static inline bool fimc_ctx_state_is_set(u32 mask, struct fimc_ctx *ctx)
 	unsigned long flags;
 	bool ret;
 
-	spin_lock_irqsave(&ctx->slock, flags);
+	spin_lock_irqsave(&ctx->fimc_dev->slock, flags);
 	ret = (ctx->state & mask) == mask;
-	spin_unlock_irqrestore(&ctx->slock, flags);
+	spin_unlock_irqrestore(&ctx->fimc_dev->slock, flags);
 	return ret;
 }
 
-- 
1.7.9.2

