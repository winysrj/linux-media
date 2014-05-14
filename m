Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pa0-f50.google.com ([209.85.220.50]:59872 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751087AbaENGZK (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 14 May 2014 02:25:10 -0400
From: Arun Kumar K <arun.kk@samsung.com>
To: linux-media@vger.kernel.org, linux-samsung-soc@vger.kernel.org
Cc: k.debski@samsung.com, s.nawrocki@samsung.com, posciak@chromium.org,
	arunkk.samsung@gmail.com
Subject: [PATCH v2] [media] s5p-mfc: Don't allocate codec buffers on STREAMON.
Date: Wed, 14 May 2014 11:55:01 +0530
Message-Id: <1400048701-598-1-git-send-email-arun.kk@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Pawel Osciak <posciak@chromium.org>

Currently, we allocate private codec buffers on STREAMON, which may fail
if we are out of memory. We don't check for failure though, which will
make us crash with the codec accessing random memory.

We shouldn't be failing STREAMON with out of memory errors though. So move
the allocation of private codec buffers to REQBUFS for OUTPUT queue. Also,
move MFC instance opening and closing to REQBUFS as well, as it's tied to
allocation and deallocation of private codec buffers.

Signed-off-by: Pawel Osciak <posciak@chromium.org>
Signed-off-by: Arun Kumar K <arun.kk@samsung.com>
---
Posting only patch 3/3 of the patchset -
MFC cleanup of reqbuf, streamon, open and close
addressing a minor comment from Kamil.
Other dependent patches are:
s5p-mfc: Extract open/close MFC instance commands.
s5p-mfc: Fixes for decode REQBUFS.

Changes from v1
- Addressed review comment from Kamil
  https://patchwork.linuxtv.org/patch/23162/
---
 drivers/media/platform/s5p-mfc/s5p_mfc.c      |    8 +++----
 drivers/media/platform/s5p-mfc/s5p_mfc_ctrl.c |    1 +
 drivers/media/platform/s5p-mfc/s5p_mfc_dec.c  |   30 +++++++++++--------------
 3 files changed, 18 insertions(+), 21 deletions(-)

diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc.c b/drivers/media/platform/s5p-mfc/s5p_mfc.c
index 2faf7e6..aa08aa2 100644
--- a/drivers/media/platform/s5p-mfc/s5p_mfc.c
+++ b/drivers/media/platform/s5p-mfc/s5p_mfc.c
@@ -650,6 +650,7 @@ static irqreturn_t s5p_mfc_irq(int irq, void *priv)
 
 	case S5P_MFC_R2H_CMD_CLOSE_INSTANCE_RET:
 		clear_work_bit(ctx);
+		ctx->inst_no = MFC_NO_INSTANCE_SET;
 		ctx->state = MFCINST_FREE;
 		wake_up(&ctx->queue);
 		goto irq_cleanup_hw;
@@ -770,7 +771,7 @@ static int s5p_mfc_open(struct file *file)
 		goto err_bad_node;
 	}
 	ctx->fh.ctrl_handler = &ctx->ctrl_handler;
-	ctx->inst_no = -1;
+	ctx->inst_no = MFC_NO_INSTANCE_SET;
 	/* Load firmware if this is the first instance */
 	if (dev->num_inst == 1) {
 		dev->watchdog_timer.expires = jiffies +
@@ -880,12 +881,11 @@ static int s5p_mfc_release(struct file *file)
 	vb2_queue_release(&ctx->vq_dst);
 	/* Mark context as idle */
 	clear_work_bit_irqsave(ctx);
-	/* If instance was initialised then
+	/* If instance was initialised and not yet freed,
 	 * return instance and free resources */
-	if (ctx->inst_no != MFC_NO_INSTANCE_SET) {
+	if (ctx->state != MFCINST_FREE && ctx->state != MFCINST_INIT) {
 		mfc_debug(2, "Has to free instance\n");
 		s5p_mfc_close_mfc_inst(dev, ctx);
-		ctx->inst_no = MFC_NO_INSTANCE_SET;
 	}
 	/* hardware locking scheme */
 	if (dev->curr_ctx == ctx->num)
diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc_ctrl.c b/drivers/media/platform/s5p-mfc/s5p_mfc_ctrl.c
index 84d4f9d..2001a75 100644
--- a/drivers/media/platform/s5p-mfc/s5p_mfc_ctrl.c
+++ b/drivers/media/platform/s5p-mfc/s5p_mfc_ctrl.c
@@ -459,5 +459,6 @@ void s5p_mfc_close_mfc_inst(struct s5p_mfc_dev *dev, struct s5p_mfc_ctx *ctx)
 	if (ctx->type == MFCINST_DECODER)
 		s5p_mfc_hw_call(dev->mfc_ops, release_dec_desc_buffer, ctx);
 
+	ctx->inst_no = MFC_NO_INSTANCE_SET;
 	ctx->state = MFCINST_FREE;
 }
diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc_dec.c b/drivers/media/platform/s5p-mfc/s5p_mfc_dec.c
index efc78ae..4586186 100644
--- a/drivers/media/platform/s5p-mfc/s5p_mfc_dec.c
+++ b/drivers/media/platform/s5p-mfc/s5p_mfc_dec.c
@@ -475,11 +475,11 @@ static int reqbufs_output(struct s5p_mfc_dev *dev, struct s5p_mfc_ctx *ctx,
 		ret = vb2_reqbufs(&ctx->vq_src, reqbufs);
 		if (ret)
 			goto out;
+		s5p_mfc_close_mfc_inst(dev, ctx);
 		ctx->src_bufs_cnt = 0;
+		ctx->output_state = QUEUE_FREE;
 	} else if (ctx->output_state == QUEUE_FREE) {
-		/* Can only request buffers after the instance
-		 * has been opened.
-		 */
+		/* Can only request buffers when we have a valid format set. */
 		WARN_ON(ctx->src_bufs_cnt != 0);
 		if (ctx->state != MFCINST_INIT) {
 			mfc_err("Reqbufs called in an invalid state\n");
@@ -493,6 +493,13 @@ static int reqbufs_output(struct s5p_mfc_dev *dev, struct s5p_mfc_ctx *ctx,
 		if (ret)
 			goto out;
 
+		ret = s5p_mfc_open_mfc_inst(dev, ctx);
+		if (ret) {
+			reqbufs->count = 0;
+			vb2_reqbufs(&ctx->vq_src, reqbufs);
+			goto out;
+		}
+
 		ctx->output_state = QUEUE_BUFS_REQUESTED;
 	} else {
 		mfc_err("Buffers have already been requested\n");
@@ -594,7 +601,7 @@ static int vidioc_querybuf(struct file *file, void *priv,
 		return -EINVAL;
 	}
 	mfc_debug(2, "State: %d, buf->type: %d\n", ctx->state, buf->type);
-	if (ctx->state == MFCINST_INIT &&
+	if (ctx->state == MFCINST_GOT_INST &&
 			buf->type == V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE) {
 		ret = vb2_querybuf(&ctx->vq_src, buf);
 	} else if (ctx->state == MFCINST_RUNNING &&
@@ -670,24 +677,13 @@ static int vidioc_streamon(struct file *file, void *priv,
 			   enum v4l2_buf_type type)
 {
 	struct s5p_mfc_ctx *ctx = fh_to_ctx(priv);
-	struct s5p_mfc_dev *dev = ctx->dev;
 	int ret = -EINVAL;
 
 	mfc_debug_enter();
-	if (type == V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE) {
-		if (ctx->state == MFCINST_INIT) {
-			ctx->dst_bufs_cnt = 0;
-			ctx->src_bufs_cnt = 0;
-			ctx->capture_state = QUEUE_FREE;
-			ctx->output_state = QUEUE_FREE;
-			ret = s5p_mfc_open_mfc_inst(dev, ctx);
-			if (ret)
-				return ret;
-		}
+	if (type == V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE)
 		ret = vb2_streamon(&ctx->vq_src, type);
-	} else if (type == V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE) {
+	else if (type == V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE)
 		ret = vb2_streamon(&ctx->vq_dst, type);
-	}
 	mfc_debug_leave();
 	return ret;
 }
-- 
1.7.9.5

