Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.samsung.com ([203.254.224.33]:64610 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751233AbaIKN1c (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 11 Sep 2014 09:27:32 -0400
Received: from epcpsbgm2.samsung.com (epcpsbgm2 [203.254.230.27])
 by mailout3.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0NBQ0086RO1UK210@mailout3.samsung.com> for
 linux-media@vger.kernel.org; Thu, 11 Sep 2014 22:27:30 +0900 (KST)
From: Kamil Debski <k.debski@samsung.com>
To: linux-media@vger.kernel.org
Cc: hverkuil@xs4all.nl, Kamil Debski <k.debski@samsung.com>
Subject: [PATCH] s5p-mfc: Fix sparse errors in the MFC driver
Date: Thu, 11 Sep 2014 15:27:20 +0200
Message-id: <1410442040-20591-1-git-send-email-k.debski@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The following error: "error: incompatible types in conditional expression
(different base types)" was reported multiple times for the s5p-mfc
driver. This error was caused by two macro definitions - s5p_mfc_hw_call
(in s5p_mfc_common.h) and WRITEL (in s5p_mfc_opr_v6.c).

In the former case the macro assumed that all ops return a value, but some
ops return void. The solution to this problem was the addition of a
s5p_mfc_hw_call_void macro.

In the latter case the macro used the ?: construction to check whether
the address is non zero. This is not necessary after the driver left the
development and debugging cycle, so the READL and WRITEL macros were
removed.

Signed-off-by: Kamil Debski <k.debski@samsung.com>
---
 drivers/media/platform/s5p-mfc/s5p_mfc.c        |   46 +--
 drivers/media/platform/s5p-mfc/s5p_mfc_common.h |    6 +
 drivers/media/platform/s5p-mfc/s5p_mfc_ctrl.c   |   16 +-
 drivers/media/platform/s5p-mfc/s5p_mfc_dec.c    |   20 +-
 drivers/media/platform/s5p-mfc/s5p_mfc_enc.c    |   26 +-
 drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c |  471 +++++++++++------------
 6 files changed, 293 insertions(+), 292 deletions(-)

diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc.c b/drivers/media/platform/s5p-mfc/s5p_mfc.c
index d180440..01e17f4 100644
--- a/drivers/media/platform/s5p-mfc/s5p_mfc.c
+++ b/drivers/media/platform/s5p-mfc/s5p_mfc.c
@@ -150,10 +150,10 @@ static void s5p_mfc_watchdog_worker(struct work_struct *work)
 		if (!ctx)
 			continue;
 		ctx->state = MFCINST_ERROR;
-		s5p_mfc_hw_call(dev->mfc_ops, cleanup_queue, &ctx->dst_queue,
-				&ctx->vq_dst);
-		s5p_mfc_hw_call(dev->mfc_ops, cleanup_queue, &ctx->src_queue,
-				&ctx->vq_src);
+		s5p_mfc_hw_call_void(dev->mfc_ops, cleanup_queue,
+						&ctx->dst_queue, &ctx->vq_dst);
+		s5p_mfc_hw_call_void(dev->mfc_ops, cleanup_queue,
+						&ctx->src_queue, &ctx->vq_src);
 		clear_work_bit(ctx);
 		wake_up_ctx(ctx, S5P_MFC_R2H_CMD_ERR_RET, 0);
 	}
@@ -327,12 +327,12 @@ static void s5p_mfc_handle_frame(struct s5p_mfc_ctx *ctx,
 	if (res_change == S5P_FIMV_RES_INCREASE ||
 		res_change == S5P_FIMV_RES_DECREASE) {
 		ctx->state = MFCINST_RES_CHANGE_INIT;
-		s5p_mfc_hw_call(dev->mfc_ops, clear_int_flags, dev);
+		s5p_mfc_hw_call_void(dev->mfc_ops, clear_int_flags, dev);
 		wake_up_ctx(ctx, reason, err);
 		if (test_and_clear_bit(0, &dev->hw_lock) == 0)
 			BUG();
 		s5p_mfc_clock_off();
-		s5p_mfc_hw_call(dev->mfc_ops, try_run, dev);
+		s5p_mfc_hw_call_void(dev->mfc_ops, try_run, dev);
 		return;
 	}
 	if (ctx->dpb_flush_flag)
@@ -400,7 +400,7 @@ leave_handle_frame:
 	if ((ctx->src_queue_cnt == 0 && ctx->state != MFCINST_FINISHING)
 				    || ctx->dst_queue_cnt < ctx->pb_count)
 		clear_work_bit(ctx);
-	s5p_mfc_hw_call(dev->mfc_ops, clear_int_flags, dev);
+	s5p_mfc_hw_call_void(dev->mfc_ops, clear_int_flags, dev);
 	wake_up_ctx(ctx, reason, err);
 	if (test_and_clear_bit(0, &dev->hw_lock) == 0)
 		BUG();
@@ -409,7 +409,7 @@ leave_handle_frame:
 	if (test_bit(0, &dev->enter_suspend))
 		wake_up_dev(dev, reason, err);
 	else
-		s5p_mfc_hw_call(dev->mfc_ops, try_run, dev);
+		s5p_mfc_hw_call_void(dev->mfc_ops, try_run, dev);
 }
 
 /* Error handling for interrupt */
@@ -435,10 +435,10 @@ static void s5p_mfc_handle_error(struct s5p_mfc_dev *dev,
 			ctx->state = MFCINST_ERROR;
 			/* Mark all dst buffers as having an error */
 			spin_lock_irqsave(&dev->irqlock, flags);
-			s5p_mfc_hw_call(dev->mfc_ops, cleanup_queue,
+			s5p_mfc_hw_call_void(dev->mfc_ops, cleanup_queue,
 						&ctx->dst_queue, &ctx->vq_dst);
 			/* Mark all src buffers as having an error */
-			s5p_mfc_hw_call(dev->mfc_ops, cleanup_queue,
+			s5p_mfc_hw_call_void(dev->mfc_ops, cleanup_queue,
 						&ctx->src_queue, &ctx->vq_src);
 			spin_unlock_irqrestore(&dev->irqlock, flags);
 			wake_up_ctx(ctx, reason, err);
@@ -452,7 +452,7 @@ static void s5p_mfc_handle_error(struct s5p_mfc_dev *dev,
 	}
 	if (test_and_clear_bit(0, &dev->hw_lock) == 0)
 		BUG();
-	s5p_mfc_hw_call(dev->mfc_ops, clear_int_flags, dev);
+	s5p_mfc_hw_call_void(dev->mfc_ops, clear_int_flags, dev);
 	s5p_mfc_clock_off();
 	wake_up_dev(dev, reason, err);
 	return;
@@ -476,7 +476,7 @@ static void s5p_mfc_handle_seq_done(struct s5p_mfc_ctx *ctx,
 		ctx->img_height = s5p_mfc_hw_call(dev->mfc_ops, get_img_height,
 				dev);
 
-		s5p_mfc_hw_call(dev->mfc_ops, dec_calc_dpb_size, ctx);
+		s5p_mfc_hw_call_void(dev->mfc_ops, dec_calc_dpb_size, ctx);
 
 		ctx->pb_count = s5p_mfc_hw_call(dev->mfc_ops, get_dpb_count,
 				dev);
@@ -503,12 +503,12 @@ static void s5p_mfc_handle_seq_done(struct s5p_mfc_ctx *ctx,
 			ctx->head_processed = 1;
 		}
 	}
-	s5p_mfc_hw_call(dev->mfc_ops, clear_int_flags, dev);
+	s5p_mfc_hw_call_void(dev->mfc_ops, clear_int_flags, dev);
 	clear_work_bit(ctx);
 	if (test_and_clear_bit(0, &dev->hw_lock) == 0)
 		BUG();
 	s5p_mfc_clock_off();
-	s5p_mfc_hw_call(dev->mfc_ops, try_run, dev);
+	s5p_mfc_hw_call_void(dev->mfc_ops, try_run, dev);
 	wake_up_ctx(ctx, reason, err);
 }
 
@@ -523,7 +523,7 @@ static void s5p_mfc_handle_init_buffers(struct s5p_mfc_ctx *ctx,
 	if (ctx == NULL)
 		return;
 	dev = ctx->dev;
-	s5p_mfc_hw_call(dev->mfc_ops, clear_int_flags, dev);
+	s5p_mfc_hw_call_void(dev->mfc_ops, clear_int_flags, dev);
 	ctx->int_type = reason;
 	ctx->int_err = err;
 	ctx->int_cond = 1;
@@ -550,7 +550,7 @@ static void s5p_mfc_handle_init_buffers(struct s5p_mfc_ctx *ctx,
 		s5p_mfc_clock_off();
 
 		wake_up(&ctx->queue);
-		s5p_mfc_hw_call(dev->mfc_ops, try_run, dev);
+		s5p_mfc_hw_call_void(dev->mfc_ops, try_run, dev);
 	} else {
 		if (test_and_clear_bit(0, &dev->hw_lock) == 0)
 			BUG();
@@ -591,7 +591,7 @@ static void s5p_mfc_handle_stream_complete(struct s5p_mfc_ctx *ctx,
 
 	s5p_mfc_clock_off();
 	wake_up(&ctx->queue);
-	s5p_mfc_hw_call(dev->mfc_ops, try_run, dev);
+	s5p_mfc_hw_call_void(dev->mfc_ops, try_run, dev);
 }
 
 /* Interrupt processing */
@@ -628,12 +628,12 @@ static irqreturn_t s5p_mfc_irq(int irq, void *priv)
 		if (ctx->c_ops->post_frame_start) {
 			if (ctx->c_ops->post_frame_start(ctx))
 				mfc_err("post_frame_start() failed\n");
-			s5p_mfc_hw_call(dev->mfc_ops, clear_int_flags, dev);
+			s5p_mfc_hw_call_void(dev->mfc_ops, clear_int_flags, dev);
 			wake_up_ctx(ctx, reason, err);
 			if (test_and_clear_bit(0, &dev->hw_lock) == 0)
 				BUG();
 			s5p_mfc_clock_off();
-			s5p_mfc_hw_call(dev->mfc_ops, try_run, dev);
+			s5p_mfc_hw_call_void(dev->mfc_ops, try_run, dev);
 		} else {
 			s5p_mfc_handle_frame(ctx, reason, err);
 		}
@@ -663,7 +663,7 @@ static irqreturn_t s5p_mfc_irq(int irq, void *priv)
 	case S5P_MFC_R2H_CMD_WAKEUP_RET:
 		if (ctx)
 			clear_work_bit(ctx);
-		s5p_mfc_hw_call(dev->mfc_ops, clear_int_flags, dev);
+		s5p_mfc_hw_call_void(dev->mfc_ops, clear_int_flags, dev);
 		wake_up_dev(dev, reason, err);
 		clear_bit(0, &dev->hw_lock);
 		clear_bit(0, &dev->enter_suspend);
@@ -685,12 +685,12 @@ static irqreturn_t s5p_mfc_irq(int irq, void *priv)
 
 	default:
 		mfc_debug(2, "Unknown int reason\n");
-		s5p_mfc_hw_call(dev->mfc_ops, clear_int_flags, dev);
+		s5p_mfc_hw_call_void(dev->mfc_ops, clear_int_flags, dev);
 	}
 	mfc_debug_leave();
 	return IRQ_HANDLED;
 irq_cleanup_hw:
-	s5p_mfc_hw_call(dev->mfc_ops, clear_int_flags, dev);
+	s5p_mfc_hw_call_void(dev->mfc_ops, clear_int_flags, dev);
 	ctx->int_type = reason;
 	ctx->int_err = err;
 	ctx->int_cond = 1;
@@ -699,7 +699,7 @@ irq_cleanup_hw:
 
 	s5p_mfc_clock_off();
 
-	s5p_mfc_hw_call(dev->mfc_ops, try_run, dev);
+	s5p_mfc_hw_call_void(dev->mfc_ops, try_run, dev);
 	mfc_debug(2, "Exit via irq_cleanup_hw\n");
 	return IRQ_HANDLED;
 }
diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc_common.h b/drivers/media/platform/s5p-mfc/s5p_mfc_common.h
index 01816ff..f508773 100644
--- a/drivers/media/platform/s5p-mfc/s5p_mfc_common.h
+++ b/drivers/media/platform/s5p-mfc/s5p_mfc_common.h
@@ -698,6 +698,12 @@ struct mfc_control {
 #define s5p_mfc_hw_call(f, op, args...) \
 	((f && f->op) ? f->op(args) : -ENODEV)
 
+#define s5p_mfc_hw_call_void(f, op, args...) \
+do { \
+	if (f && f->op) \
+		f->op(args); \
+} while(0)
+
 #define fh_to_ctx(__fh) container_of(__fh, struct s5p_mfc_ctx, fh)
 #define ctrl_to_ctx(__ctrl) \
 	container_of((__ctrl)->handler, struct s5p_mfc_ctx, ctrl_handler)
diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc_ctrl.c b/drivers/media/platform/s5p-mfc/s5p_mfc_ctrl.c
index 23d247d..3c10e31 100644
--- a/drivers/media/platform/s5p-mfc/s5p_mfc_ctrl.c
+++ b/drivers/media/platform/s5p-mfc/s5p_mfc_ctrl.c
@@ -294,7 +294,7 @@ void s5p_mfc_deinit_hw(struct s5p_mfc_dev *dev)
 	s5p_mfc_clock_on();
 
 	s5p_mfc_reset(dev);
-	s5p_mfc_hw_call(dev->mfc_ops, release_dev_context_buffer, dev);
+	s5p_mfc_hw_call_void(dev->mfc_ops, release_dev_context_buffer, dev);
 
 	s5p_mfc_clock_off();
 }
@@ -397,7 +397,7 @@ int s5p_mfc_open_mfc_inst(struct s5p_mfc_dev *dev, struct s5p_mfc_ctx *ctx)
 
 	set_work_bit_irqsave(ctx);
 	s5p_mfc_clean_ctx_int_flags(ctx);
-	s5p_mfc_hw_call(dev->mfc_ops, try_run, dev);
+	s5p_mfc_hw_call_void(dev->mfc_ops, try_run, dev);
 	if (s5p_mfc_wait_for_done_ctx(ctx,
 		S5P_MFC_R2H_CMD_OPEN_INSTANCE_RET, 0)) {
 		/* Error or timeout */
@@ -411,9 +411,9 @@ int s5p_mfc_open_mfc_inst(struct s5p_mfc_dev *dev, struct s5p_mfc_ctx *ctx)
 
 err_free_desc_buf:
 	if (ctx->type == MFCINST_DECODER)
-		s5p_mfc_hw_call(dev->mfc_ops, release_dec_desc_buffer, ctx);
+		s5p_mfc_hw_call_void(dev->mfc_ops, release_dec_desc_buffer, ctx);
 err_free_inst_buf:
-	s5p_mfc_hw_call(dev->mfc_ops, release_instance_buffer, ctx);
+	s5p_mfc_hw_call_void(dev->mfc_ops, release_instance_buffer, ctx);
 err:
 	return ret;
 }
@@ -423,17 +423,17 @@ void s5p_mfc_close_mfc_inst(struct s5p_mfc_dev *dev, struct s5p_mfc_ctx *ctx)
 	ctx->state = MFCINST_RETURN_INST;
 	set_work_bit_irqsave(ctx);
 	s5p_mfc_clean_ctx_int_flags(ctx);
-	s5p_mfc_hw_call(dev->mfc_ops, try_run, dev);
+	s5p_mfc_hw_call_void(dev->mfc_ops, try_run, dev);
 	/* Wait until instance is returned or timeout occurred */
 	if (s5p_mfc_wait_for_done_ctx(ctx,
 				S5P_MFC_R2H_CMD_CLOSE_INSTANCE_RET, 0))
 		mfc_err("Err returning instance\n");
 
 	/* Free resources */
-	s5p_mfc_hw_call(dev->mfc_ops, release_codec_buffers, ctx);
-	s5p_mfc_hw_call(dev->mfc_ops, release_instance_buffer, ctx);
+	s5p_mfc_hw_call_void(dev->mfc_ops, release_codec_buffers, ctx);
+	s5p_mfc_hw_call_void(dev->mfc_ops, release_instance_buffer, ctx);
 	if (ctx->type == MFCINST_DECODER)
-		s5p_mfc_hw_call(dev->mfc_ops, release_dec_desc_buffer, ctx);
+		s5p_mfc_hw_call_void(dev->mfc_ops, release_dec_desc_buffer, ctx);
 
 	ctx->inst_no = MFC_NO_INSTANCE_SET;
 	ctx->state = MFCINST_FREE;
diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc_dec.c b/drivers/media/platform/s5p-mfc/s5p_mfc_dec.c
index fe4d21c..a13c1ce 100644
--- a/drivers/media/platform/s5p-mfc/s5p_mfc_dec.c
+++ b/drivers/media/platform/s5p-mfc/s5p_mfc_dec.c
@@ -543,7 +543,7 @@ static int reqbufs_capture(struct s5p_mfc_dev *dev, struct s5p_mfc_ctx *ctx,
 		ret = vb2_reqbufs(&ctx->vq_dst, reqbufs);
 		if (ret)
 			goto out;
-		s5p_mfc_hw_call(dev->mfc_ops, release_codec_buffers, ctx);
+		s5p_mfc_hw_call_void(dev->mfc_ops, release_codec_buffers, ctx);
 		ctx->dst_bufs_cnt = 0;
 	} else if (ctx->capture_state == QUEUE_FREE) {
 		WARN_ON(ctx->dst_bufs_cnt != 0);
@@ -571,7 +571,7 @@ static int reqbufs_capture(struct s5p_mfc_dev *dev, struct s5p_mfc_ctx *ctx,
 
 		if (s5p_mfc_ctx_ready(ctx))
 			set_work_bit_irqsave(ctx);
-		s5p_mfc_hw_call(dev->mfc_ops, try_run, dev);
+		s5p_mfc_hw_call_void(dev->mfc_ops, try_run, dev);
 		s5p_mfc_wait_for_done_ctx(ctx, S5P_MFC_R2H_CMD_INIT_BUFFERS_RET,
 					  0);
 	} else {
@@ -846,7 +846,7 @@ static int vidioc_decoder_cmd(struct file *file, void *priv,
 			if (s5p_mfc_ctx_ready(ctx))
 				set_work_bit_irqsave(ctx);
 			spin_unlock_irqrestore(&dev->irqlock, flags);
-			s5p_mfc_hw_call(dev->mfc_ops, try_run, dev);
+			s5p_mfc_hw_call_void(dev->mfc_ops, try_run, dev);
 		} else {
 			mfc_err("EOS: marking last buffer of stream");
 			buf = list_entry(ctx->src_queue.prev,
@@ -1044,7 +1044,7 @@ static int s5p_mfc_start_streaming(struct vb2_queue *q, unsigned int count)
 	/* If context is ready then dev = work->data;schedule it to run */
 	if (s5p_mfc_ctx_ready(ctx))
 		set_work_bit_irqsave(ctx);
-	s5p_mfc_hw_call(dev->mfc_ops, try_run, dev);
+	s5p_mfc_hw_call_void(dev->mfc_ops, try_run, dev);
 	return 0;
 }
 
@@ -1065,8 +1065,8 @@ static void s5p_mfc_stop_streaming(struct vb2_queue *q)
 	}
 	if (q->type == V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE) {
 		spin_lock_irqsave(&dev->irqlock, flags);
-		s5p_mfc_hw_call(dev->mfc_ops, cleanup_queue, &ctx->dst_queue,
-				&ctx->vq_dst);
+		s5p_mfc_hw_call_void(dev->mfc_ops, cleanup_queue,
+						&ctx->dst_queue, &ctx->vq_dst);
 		INIT_LIST_HEAD(&ctx->dst_queue);
 		ctx->dst_queue_cnt = 0;
 		ctx->dpb_flush_flag = 1;
@@ -1076,7 +1076,7 @@ static void s5p_mfc_stop_streaming(struct vb2_queue *q)
 			ctx->state = MFCINST_FLUSH;
 			set_work_bit_irqsave(ctx);
 			s5p_mfc_clean_ctx_int_flags(ctx);
-			s5p_mfc_hw_call(dev->mfc_ops, try_run, dev);
+			s5p_mfc_hw_call_void(dev->mfc_ops, try_run, dev);
 			if (s5p_mfc_wait_for_done_ctx(ctx,
 				S5P_MFC_R2H_CMD_DPB_FLUSH_RET, 0))
 				mfc_err("Err flushing buffers\n");
@@ -1084,8 +1084,8 @@ static void s5p_mfc_stop_streaming(struct vb2_queue *q)
 	}
 	if (q->type == V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE) {
 		spin_lock_irqsave(&dev->irqlock, flags);
-		s5p_mfc_hw_call(dev->mfc_ops, cleanup_queue, &ctx->src_queue,
-				&ctx->vq_src);
+		s5p_mfc_hw_call_void(dev->mfc_ops, cleanup_queue,
+						&ctx->src_queue, &ctx->vq_src);
 		INIT_LIST_HEAD(&ctx->src_queue);
 		ctx->src_queue_cnt = 0;
 		spin_unlock_irqrestore(&dev->irqlock, flags);
@@ -1124,7 +1124,7 @@ static void s5p_mfc_buf_queue(struct vb2_buffer *vb)
 	}
 	if (s5p_mfc_ctx_ready(ctx))
 		set_work_bit_irqsave(ctx);
-	s5p_mfc_hw_call(dev->mfc_ops, try_run, dev);
+	s5p_mfc_hw_call_void(dev->mfc_ops, try_run, dev);
 }
 
 static struct vb2_ops s5p_mfc_dec_qops = {
diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc_enc.c b/drivers/media/platform/s5p-mfc/s5p_mfc_enc.c
index 41f3b7f..4ebfcd6 100644
--- a/drivers/media/platform/s5p-mfc/s5p_mfc_enc.c
+++ b/drivers/media/platform/s5p-mfc/s5p_mfc_enc.c
@@ -767,7 +767,7 @@ static int enc_pre_seq_start(struct s5p_mfc_ctx *ctx)
 	dst_mb = list_entry(ctx->dst_queue.next, struct s5p_mfc_buf, list);
 	dst_addr = vb2_dma_contig_plane_dma_addr(dst_mb->b, 0);
 	dst_size = vb2_plane_size(dst_mb->b, 0);
-	s5p_mfc_hw_call(dev->mfc_ops, set_enc_stream_buffer, ctx, dst_addr,
+	s5p_mfc_hw_call_void(dev->mfc_ops, set_enc_stream_buffer, ctx, dst_addr,
 			dst_size);
 	spin_unlock_irqrestore(&dev->irqlock, flags);
 	return 0;
@@ -800,7 +800,7 @@ static int enc_post_seq_start(struct s5p_mfc_ctx *ctx)
 		ctx->state = MFCINST_RUNNING;
 		if (s5p_mfc_ctx_ready(ctx))
 			set_work_bit_irqsave(ctx);
-		s5p_mfc_hw_call(dev->mfc_ops, try_run, dev);
+		s5p_mfc_hw_call_void(dev->mfc_ops, try_run, dev);
 	} else {
 		enc_pb_count = s5p_mfc_hw_call(dev->mfc_ops,
 				get_enc_dpb_count, dev);
@@ -825,15 +825,15 @@ static int enc_pre_frame_start(struct s5p_mfc_ctx *ctx)
 	src_mb = list_entry(ctx->src_queue.next, struct s5p_mfc_buf, list);
 	src_y_addr = vb2_dma_contig_plane_dma_addr(src_mb->b, 0);
 	src_c_addr = vb2_dma_contig_plane_dma_addr(src_mb->b, 1);
-	s5p_mfc_hw_call(dev->mfc_ops, set_enc_frame_buffer, ctx, src_y_addr,
-			src_c_addr);
+	s5p_mfc_hw_call_void(dev->mfc_ops, set_enc_frame_buffer, ctx,
+							src_y_addr, src_c_addr);
 	spin_unlock_irqrestore(&dev->irqlock, flags);
 
 	spin_lock_irqsave(&dev->irqlock, flags);
 	dst_mb = list_entry(ctx->dst_queue.next, struct s5p_mfc_buf, list);
 	dst_addr = vb2_dma_contig_plane_dma_addr(dst_mb->b, 0);
 	dst_size = vb2_plane_size(dst_mb->b, 0);
-	s5p_mfc_hw_call(dev->mfc_ops, set_enc_stream_buffer, ctx, dst_addr,
+	s5p_mfc_hw_call_void(dev->mfc_ops, set_enc_stream_buffer, ctx, dst_addr,
 			dst_size);
 	spin_unlock_irqrestore(&dev->irqlock, flags);
 
@@ -858,7 +858,7 @@ static int enc_post_frame_start(struct s5p_mfc_ctx *ctx)
 		  mfc_read(dev, S5P_FIMV_ENC_SI_PIC_CNT));
 	spin_lock_irqsave(&dev->irqlock, flags);
 	if (slice_type >= 0) {
-		s5p_mfc_hw_call(dev->mfc_ops, get_enc_frame_buffer, ctx,
+		s5p_mfc_hw_call_void(dev->mfc_ops, get_enc_frame_buffer, ctx,
 				&enc_y_addr, &enc_c_addr);
 		list_for_each_entry(mb_entry, &ctx->src_queue, list) {
 			mb_y_addr = vb2_dma_contig_plane_dma_addr(mb_entry->b, 0);
@@ -1124,7 +1124,7 @@ static int vidioc_s_fmt(struct file *file, void *priv, struct v4l2_format *f)
 			pix_fmt_mp->width, pix_fmt_mp->height,
 			ctx->img_width, ctx->img_height);
 
-		s5p_mfc_hw_call(dev->mfc_ops, enc_calc_src_size, ctx);
+		s5p_mfc_hw_call_void(dev->mfc_ops, enc_calc_src_size, ctx);
 		pix_fmt_mp->plane_fmt[0].sizeimage = ctx->luma_size;
 		pix_fmt_mp->plane_fmt[0].bytesperline = ctx->buf_width;
 		pix_fmt_mp->plane_fmt[1].sizeimage = ctx->chroma_size;
@@ -1701,7 +1701,7 @@ static int vidioc_encoder_cmd(struct file *file, void *priv,
 			if (s5p_mfc_ctx_ready(ctx))
 				set_work_bit_irqsave(ctx);
 			spin_unlock_irqrestore(&dev->irqlock, flags);
-			s5p_mfc_hw_call(dev->mfc_ops, try_run, dev);
+			s5p_mfc_hw_call_void(dev->mfc_ops, try_run, dev);
 		} else {
 			mfc_debug(2, "EOS: marking last buffer of stream\n");
 			buf = list_entry(ctx->src_queue.prev,
@@ -1945,7 +1945,7 @@ static int s5p_mfc_start_streaming(struct vb2_queue *q, unsigned int count)
 	/* If context is ready then dev = work->data;schedule it to run */
 	if (s5p_mfc_ctx_ready(ctx))
 		set_work_bit_irqsave(ctx);
-	s5p_mfc_hw_call(dev->mfc_ops, try_run, dev);
+	s5p_mfc_hw_call_void(dev->mfc_ops, try_run, dev);
 
 	return 0;
 }
@@ -1966,14 +1966,14 @@ static void s5p_mfc_stop_streaming(struct vb2_queue *q)
 	ctx->state = MFCINST_FINISHED;
 	spin_lock_irqsave(&dev->irqlock, flags);
 	if (q->type == V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE) {
-		s5p_mfc_hw_call(dev->mfc_ops, cleanup_queue, &ctx->dst_queue,
-				&ctx->vq_dst);
+		s5p_mfc_hw_call_void(dev->mfc_ops, cleanup_queue,
+						&ctx->dst_queue, &ctx->vq_dst);
 		INIT_LIST_HEAD(&ctx->dst_queue);
 		ctx->dst_queue_cnt = 0;
 	}
 	if (q->type == V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE) {
 		cleanup_ref_queue(ctx);
-		s5p_mfc_hw_call(dev->mfc_ops, cleanup_queue, &ctx->src_queue,
+		s5p_mfc_hw_call_void(dev->mfc_ops, cleanup_queue, &ctx->src_queue,
 				&ctx->vq_src);
 		INIT_LIST_HEAD(&ctx->src_queue);
 		ctx->src_queue_cnt = 0;
@@ -2014,7 +2014,7 @@ static void s5p_mfc_buf_queue(struct vb2_buffer *vb)
 	}
 	if (s5p_mfc_ctx_ready(ctx))
 		set_work_bit_irqsave(ctx);
-	s5p_mfc_hw_call(dev->mfc_ops, try_run, dev);
+	s5p_mfc_hw_call_void(dev->mfc_ops, try_run, dev);
 }
 
 static struct vb2_ops s5p_mfc_enc_qops = {
diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c b/drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c
index c1c12f8..e9d1eaf 100644
--- a/drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c
+++ b/drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c
@@ -43,11 +43,6 @@
 	} while (0)
 #endif /* S5P_MFC_DEBUG_REGWRITE */
 
-#define READL(reg) \
-	(WARN_ON_ONCE(!(reg)) ? 0 : readl(reg))
-#define WRITEL(data, reg) \
-	(WARN_ON_ONCE(!(reg)) ? 0 : writel((data), (reg)))
-
 #define IS_MFCV6_V2(dev) (!IS_MFCV7_PLUS(dev) && dev->fw_ver == MFC_FW_V2)
 
 /* Allocate temporary buffers for decoding */
@@ -416,10 +411,10 @@ static int s5p_mfc_set_dec_stream_buffer_v6(struct s5p_mfc_ctx *ctx,
 	mfc_debug(2, "inst_no: %d, buf_addr: 0x%08x,\n"
 		"buf_size: 0x%08x (%d)\n",
 		ctx->inst_no, buf_addr, strm_size, strm_size);
-	WRITEL(strm_size, mfc_regs->d_stream_data_size);
-	WRITEL(buf_addr, mfc_regs->d_cpb_buffer_addr);
-	WRITEL(buf_size->cpb, mfc_regs->d_cpb_buffer_size);
-	WRITEL(start_num_byte, mfc_regs->d_cpb_buffer_offset);
+	writel(strm_size, mfc_regs->d_stream_data_size);
+	writel(buf_addr, mfc_regs->d_cpb_buffer_addr);
+	writel(buf_size->cpb, mfc_regs->d_cpb_buffer_size);
+	writel(start_num_byte, mfc_regs->d_cpb_buffer_offset);
 
 	mfc_debug_leave();
 	return 0;
@@ -443,17 +438,17 @@ static int s5p_mfc_set_dec_frame_buffer_v6(struct s5p_mfc_ctx *ctx)
 	mfc_debug(2, "Total DPB COUNT: %d\n", ctx->total_dpb_count);
 	mfc_debug(2, "Setting display delay to %d\n", ctx->display_delay);
 
-	WRITEL(ctx->total_dpb_count, mfc_regs->d_num_dpb);
-	WRITEL(ctx->luma_size, mfc_regs->d_first_plane_dpb_size);
-	WRITEL(ctx->chroma_size, mfc_regs->d_second_plane_dpb_size);
+	writel(ctx->total_dpb_count, mfc_regs->d_num_dpb);
+	writel(ctx->luma_size, mfc_regs->d_first_plane_dpb_size);
+	writel(ctx->chroma_size, mfc_regs->d_second_plane_dpb_size);
 
-	WRITEL(buf_addr1, mfc_regs->d_scratch_buffer_addr);
-	WRITEL(ctx->scratch_buf_size, mfc_regs->d_scratch_buffer_size);
+	writel(buf_addr1, mfc_regs->d_scratch_buffer_addr);
+	writel(ctx->scratch_buf_size, mfc_regs->d_scratch_buffer_size);
 
 	if (IS_MFCV8(dev)) {
-		WRITEL(ctx->img_width,
+		writel(ctx->img_width,
 			mfc_regs->d_first_plane_dpb_stride_size);
-		WRITEL(ctx->img_width,
+		writel(ctx->img_width,
 			mfc_regs->d_second_plane_dpb_stride_size);
 	}
 
@@ -462,8 +457,8 @@ static int s5p_mfc_set_dec_frame_buffer_v6(struct s5p_mfc_ctx *ctx)
 
 	if (ctx->codec_mode == S5P_FIMV_CODEC_H264_DEC ||
 			ctx->codec_mode == S5P_FIMV_CODEC_H264_MVC_DEC){
-		WRITEL(ctx->mv_size, mfc_regs->d_mv_buffer_size);
-		WRITEL(ctx->mv_count, mfc_regs->d_num_mv);
+		writel(ctx->mv_size, mfc_regs->d_mv_buffer_size);
+		writel(ctx->mv_count, mfc_regs->d_num_mv);
 	}
 
 	frame_size = ctx->luma_size;
@@ -476,11 +471,11 @@ static int s5p_mfc_set_dec_frame_buffer_v6(struct s5p_mfc_ctx *ctx)
 		/* Bank2 */
 		mfc_debug(2, "Luma %d: %x\n", i,
 					ctx->dst_bufs[i].cookie.raw.luma);
-		WRITEL(ctx->dst_bufs[i].cookie.raw.luma,
+		writel(ctx->dst_bufs[i].cookie.raw.luma,
 				mfc_regs->d_first_plane_dpb + i * 4);
 		mfc_debug(2, "\tChroma %d: %x\n", i,
 					ctx->dst_bufs[i].cookie.raw.chroma);
-		WRITEL(ctx->dst_bufs[i].cookie.raw.chroma,
+		writel(ctx->dst_bufs[i].cookie.raw.chroma,
 				mfc_regs->d_second_plane_dpb + i * 4);
 	}
 	if (ctx->codec_mode == S5P_MFC_CODEC_H264_DEC ||
@@ -494,7 +489,7 @@ static int s5p_mfc_set_dec_frame_buffer_v6(struct s5p_mfc_ctx *ctx)
 
 			mfc_debug(2, "\tBuf1: %x, size: %d\n",
 					buf_addr1, buf_size1);
-			WRITEL(buf_addr1, mfc_regs->d_mv_buffer + i * 4);
+			writel(buf_addr1, mfc_regs->d_mv_buffer + i * 4);
 			buf_addr1 += frame_size_mv;
 			buf_size1 -= frame_size_mv;
 		}
@@ -507,8 +502,8 @@ static int s5p_mfc_set_dec_frame_buffer_v6(struct s5p_mfc_ctx *ctx)
 		return -ENOMEM;
 	}
 
-	WRITEL(ctx->inst_no, mfc_regs->instance_id);
-	s5p_mfc_hw_call(dev->mfc_cmds, cmd_host2risc, dev,
+	writel(ctx->inst_no, mfc_regs->instance_id);
+	s5p_mfc_hw_call_void(dev->mfc_cmds, cmd_host2risc, dev,
 			S5P_FIMV_CH_INIT_BUFS_V6, NULL);
 
 	mfc_debug(2, "After setting buffers.\n");
@@ -522,8 +517,8 @@ static int s5p_mfc_set_enc_stream_buffer_v6(struct s5p_mfc_ctx *ctx,
 	struct s5p_mfc_dev *dev = ctx->dev;
 	const struct s5p_mfc_regs *mfc_regs = dev->mfc_regs;
 
-	WRITEL(addr, mfc_regs->e_stream_buffer_addr); /* 16B align */
-	WRITEL(size, mfc_regs->e_stream_buffer_size);
+	writel(addr, mfc_regs->e_stream_buffer_addr); /* 16B align */
+	writel(size, mfc_regs->e_stream_buffer_size);
 
 	mfc_debug(2, "stream buf addr: 0x%08lx, size: 0x%d\n",
 		  addr, size);
@@ -537,8 +532,8 @@ static void s5p_mfc_set_enc_frame_buffer_v6(struct s5p_mfc_ctx *ctx,
 	struct s5p_mfc_dev *dev = ctx->dev;
 	const struct s5p_mfc_regs *mfc_regs = dev->mfc_regs;
 
-	WRITEL(y_addr, mfc_regs->e_source_first_plane_addr);
-	WRITEL(c_addr, mfc_regs->e_source_second_plane_addr);
+	writel(y_addr, mfc_regs->e_source_first_plane_addr);
+	writel(c_addr, mfc_regs->e_source_second_plane_addr);
 
 	mfc_debug(2, "enc src y buf addr: 0x%08lx\n", y_addr);
 	mfc_debug(2, "enc src c buf addr: 0x%08lx\n", c_addr);
@@ -551,11 +546,11 @@ static void s5p_mfc_get_enc_frame_buffer_v6(struct s5p_mfc_ctx *ctx,
 	const struct s5p_mfc_regs *mfc_regs = dev->mfc_regs;
 	unsigned long enc_recon_y_addr, enc_recon_c_addr;
 
-	*y_addr = READL(mfc_regs->e_encoded_source_first_plane_addr);
-	*c_addr = READL(mfc_regs->e_encoded_source_second_plane_addr);
+	*y_addr = readl(mfc_regs->e_encoded_source_first_plane_addr);
+	*c_addr = readl(mfc_regs->e_encoded_source_second_plane_addr);
 
-	enc_recon_y_addr = READL(mfc_regs->e_recon_luma_dpb_addr);
-	enc_recon_c_addr = READL(mfc_regs->e_recon_chroma_dpb_addr);
+	enc_recon_y_addr = readl(mfc_regs->e_recon_luma_dpb_addr);
+	enc_recon_c_addr = readl(mfc_regs->e_recon_chroma_dpb_addr);
 
 	mfc_debug(2, "recon y addr: 0x%08lx\n", enc_recon_y_addr);
 	mfc_debug(2, "recon c addr: 0x%08lx\n", enc_recon_c_addr);
@@ -577,24 +572,24 @@ static int s5p_mfc_set_enc_ref_buffer_v6(struct s5p_mfc_ctx *ctx)
 	mfc_debug(2, "Buf1: %p (%d)\n", (void *)buf_addr1, buf_size1);
 
 	for (i = 0; i < ctx->pb_count; i++) {
-		WRITEL(buf_addr1, mfc_regs->e_luma_dpb + (4 * i));
+		writel(buf_addr1, mfc_regs->e_luma_dpb + (4 * i));
 		buf_addr1 += ctx->luma_dpb_size;
-		WRITEL(buf_addr1, mfc_regs->e_chroma_dpb + (4 * i));
+		writel(buf_addr1, mfc_regs->e_chroma_dpb + (4 * i));
 		buf_addr1 += ctx->chroma_dpb_size;
-		WRITEL(buf_addr1, mfc_regs->e_me_buffer + (4 * i));
+		writel(buf_addr1, mfc_regs->e_me_buffer + (4 * i));
 		buf_addr1 += ctx->me_buffer_size;
 		buf_size1 -= (ctx->luma_dpb_size + ctx->chroma_dpb_size +
 			ctx->me_buffer_size);
 	}
 
-	WRITEL(buf_addr1, mfc_regs->e_scratch_buffer_addr);
-	WRITEL(ctx->scratch_buf_size, mfc_regs->e_scratch_buffer_size);
+	writel(buf_addr1, mfc_regs->e_scratch_buffer_addr);
+	writel(ctx->scratch_buf_size, mfc_regs->e_scratch_buffer_size);
 	buf_addr1 += ctx->scratch_buf_size;
 	buf_size1 -= ctx->scratch_buf_size;
 
-	WRITEL(buf_addr1, mfc_regs->e_tmv_buffer0);
+	writel(buf_addr1, mfc_regs->e_tmv_buffer0);
 	buf_addr1 += ctx->tmv_buffer_size >> 1;
-	WRITEL(buf_addr1, mfc_regs->e_tmv_buffer1);
+	writel(buf_addr1, mfc_regs->e_tmv_buffer1);
 	buf_addr1 += ctx->tmv_buffer_size >> 1;
 	buf_size1 -= ctx->tmv_buffer_size;
 
@@ -605,8 +600,8 @@ static int s5p_mfc_set_enc_ref_buffer_v6(struct s5p_mfc_ctx *ctx)
 		return -ENOMEM;
 	}
 
-	WRITEL(ctx->inst_no, mfc_regs->instance_id);
-	s5p_mfc_hw_call(dev->mfc_cmds, cmd_host2risc, dev,
+	writel(ctx->inst_no, mfc_regs->instance_id);
+	s5p_mfc_hw_call_void(dev->mfc_cmds, cmd_host2risc, dev,
 			S5P_FIMV_CH_INIT_BUFS_V6, NULL);
 
 	mfc_debug_leave();
@@ -621,15 +616,15 @@ static int s5p_mfc_set_slice_mode(struct s5p_mfc_ctx *ctx)
 
 	/* multi-slice control */
 	/* multi-slice MB number or bit size */
-	WRITEL(ctx->slice_mode, mfc_regs->e_mslice_mode);
+	writel(ctx->slice_mode, mfc_regs->e_mslice_mode);
 	if (ctx->slice_mode == V4L2_MPEG_VIDEO_MULTI_SICE_MODE_MAX_MB) {
-		WRITEL(ctx->slice_size.mb, mfc_regs->e_mslice_size_mb);
+		writel(ctx->slice_size.mb, mfc_regs->e_mslice_size_mb);
 	} else if (ctx->slice_mode ==
 			V4L2_MPEG_VIDEO_MULTI_SICE_MODE_MAX_BYTES) {
-		WRITEL(ctx->slice_size.bits, mfc_regs->e_mslice_size_bits);
+		writel(ctx->slice_size.bits, mfc_regs->e_mslice_size_bits);
 	} else {
-		WRITEL(0x0, mfc_regs->e_mslice_size_mb);
-		WRITEL(0x0, mfc_regs->e_mslice_size_bits);
+		writel(0x0, mfc_regs->e_mslice_size_mb);
+		writel(0x0, mfc_regs->e_mslice_size_bits);
 	}
 
 	return 0;
@@ -645,21 +640,21 @@ static int s5p_mfc_set_enc_params(struct s5p_mfc_ctx *ctx)
 	mfc_debug_enter();
 
 	/* width */
-	WRITEL(ctx->img_width, mfc_regs->e_frame_width); /* 16 align */
+	writel(ctx->img_width, mfc_regs->e_frame_width); /* 16 align */
 	/* height */
-	WRITEL(ctx->img_height, mfc_regs->e_frame_height); /* 16 align */
+	writel(ctx->img_height, mfc_regs->e_frame_height); /* 16 align */
 
 	/* cropped width */
-	WRITEL(ctx->img_width, mfc_regs->e_cropped_frame_width);
+	writel(ctx->img_width, mfc_regs->e_cropped_frame_width);
 	/* cropped height */
-	WRITEL(ctx->img_height, mfc_regs->e_cropped_frame_height);
+	writel(ctx->img_height, mfc_regs->e_cropped_frame_height);
 	/* cropped offset */
-	WRITEL(0x0, mfc_regs->e_frame_crop_offset);
+	writel(0x0, mfc_regs->e_frame_crop_offset);
 
 	/* pictype : IDR period */
 	reg = 0;
 	reg |= p->gop_size & 0xFFFF;
-	WRITEL(reg, mfc_regs->e_gop_config);
+	writel(reg, mfc_regs->e_gop_config);
 
 	/* multi-slice control */
 	/* multi-slice MB number or bit size */
@@ -667,65 +662,65 @@ static int s5p_mfc_set_enc_params(struct s5p_mfc_ctx *ctx)
 	reg = 0;
 	if (p->slice_mode == V4L2_MPEG_VIDEO_MULTI_SICE_MODE_MAX_MB) {
 		reg |= (0x1 << 3);
-		WRITEL(reg, mfc_regs->e_enc_options);
+		writel(reg, mfc_regs->e_enc_options);
 		ctx->slice_size.mb = p->slice_mb;
 	} else if (p->slice_mode == V4L2_MPEG_VIDEO_MULTI_SICE_MODE_MAX_BYTES) {
 		reg |= (0x1 << 3);
-		WRITEL(reg, mfc_regs->e_enc_options);
+		writel(reg, mfc_regs->e_enc_options);
 		ctx->slice_size.bits = p->slice_bit;
 	} else {
 		reg &= ~(0x1 << 3);
-		WRITEL(reg, mfc_regs->e_enc_options);
+		writel(reg, mfc_regs->e_enc_options);
 	}
 
 	s5p_mfc_set_slice_mode(ctx);
 
 	/* cyclic intra refresh */
-	WRITEL(p->intra_refresh_mb, mfc_regs->e_ir_size);
-	reg = READL(mfc_regs->e_enc_options);
+	writel(p->intra_refresh_mb, mfc_regs->e_ir_size);
+	reg = readl(mfc_regs->e_enc_options);
 	if (p->intra_refresh_mb == 0)
 		reg &= ~(0x1 << 4);
 	else
 		reg |= (0x1 << 4);
-	WRITEL(reg, mfc_regs->e_enc_options);
+	writel(reg, mfc_regs->e_enc_options);
 
 	/* 'NON_REFERENCE_STORE_ENABLE' for debugging */
-	reg = READL(mfc_regs->e_enc_options);
+	reg = readl(mfc_regs->e_enc_options);
 	reg &= ~(0x1 << 9);
-	WRITEL(reg, mfc_regs->e_enc_options);
+	writel(reg, mfc_regs->e_enc_options);
 
 	/* memory structure cur. frame */
 	if (ctx->src_fmt->fourcc == V4L2_PIX_FMT_NV12M) {
 		/* 0: Linear, 1: 2D tiled*/
-		reg = READL(mfc_regs->e_enc_options);
+		reg = readl(mfc_regs->e_enc_options);
 		reg &= ~(0x1 << 7);
-		WRITEL(reg, mfc_regs->e_enc_options);
+		writel(reg, mfc_regs->e_enc_options);
 		/* 0: NV12(CbCr), 1: NV21(CrCb) */
-		WRITEL(0x0, mfc_regs->pixel_format);
+		writel(0x0, mfc_regs->pixel_format);
 	} else if (ctx->src_fmt->fourcc == V4L2_PIX_FMT_NV21M) {
 		/* 0: Linear, 1: 2D tiled*/
-		reg = READL(mfc_regs->e_enc_options);
+		reg = readl(mfc_regs->e_enc_options);
 		reg &= ~(0x1 << 7);
-		WRITEL(reg, mfc_regs->e_enc_options);
+		writel(reg, mfc_regs->e_enc_options);
 		/* 0: NV12(CbCr), 1: NV21(CrCb) */
-		WRITEL(0x1, mfc_regs->pixel_format);
+		writel(0x1, mfc_regs->pixel_format);
 	} else if (ctx->src_fmt->fourcc == V4L2_PIX_FMT_NV12MT_16X16) {
 		/* 0: Linear, 1: 2D tiled*/
-		reg = READL(mfc_regs->e_enc_options);
+		reg = readl(mfc_regs->e_enc_options);
 		reg |= (0x1 << 7);
-		WRITEL(reg, mfc_regs->e_enc_options);
+		writel(reg, mfc_regs->e_enc_options);
 		/* 0: NV12(CbCr), 1: NV21(CrCb) */
-		WRITEL(0x0, mfc_regs->pixel_format);
+		writel(0x0, mfc_regs->pixel_format);
 	}
 
 	/* memory structure recon. frame */
 	/* 0: Linear, 1: 2D tiled */
-	reg = READL(mfc_regs->e_enc_options);
+	reg = readl(mfc_regs->e_enc_options);
 	reg |= (0x1 << 8);
-	WRITEL(reg, mfc_regs->e_enc_options);
+	writel(reg, mfc_regs->e_enc_options);
 
 	/* padding control & value */
-	WRITEL(0x0, mfc_regs->e_padding_ctrl);
+	writel(0x0, mfc_regs->e_padding_ctrl);
 	if (p->pad) {
 		reg = 0;
 		/** enable */
@@ -736,64 +731,64 @@ static int s5p_mfc_set_enc_params(struct s5p_mfc_ctx *ctx)
 		reg |= ((p->pad_cb & 0xFF) << 8);
 		/** y value */
 		reg |= p->pad_luma & 0xFF;
-		WRITEL(reg, mfc_regs->e_padding_ctrl);
+		writel(reg, mfc_regs->e_padding_ctrl);
 	}
 
 	/* rate control config. */
 	reg = 0;
 	/* frame-level rate control */
 	reg |= ((p->rc_frame & 0x1) << 9);
-	WRITEL(reg, mfc_regs->e_rc_config);
+	writel(reg, mfc_regs->e_rc_config);
 
 	/* bit rate */
 	if (p->rc_frame)
-		WRITEL(p->rc_bitrate,
+		writel(p->rc_bitrate,
 			mfc_regs->e_rc_bit_rate);
 	else
-		WRITEL(1, mfc_regs->e_rc_bit_rate);
+		writel(1, mfc_regs->e_rc_bit_rate);
 
 	/* reaction coefficient */
 	if (p->rc_frame) {
 		if (p->rc_reaction_coeff < TIGHT_CBR_MAX) /* tight CBR */
-			WRITEL(1, mfc_regs->e_rc_mode);
+			writel(1, mfc_regs->e_rc_mode);
 		else					  /* loose CBR */
-			WRITEL(2, mfc_regs->e_rc_mode);
+			writel(2, mfc_regs->e_rc_mode);
 	}
 
 	/* seq header ctrl */
-	reg = READL(mfc_regs->e_enc_options);
+	reg = readl(mfc_regs->e_enc_options);
 	reg &= ~(0x1 << 2);
 	reg |= ((p->seq_hdr_mode & 0x1) << 2);
 
 	/* frame skip mode */
 	reg &= ~(0x3);
 	reg |= (p->frame_skip_mode & 0x3);
-	WRITEL(reg, mfc_regs->e_enc_options);
+	writel(reg, mfc_regs->e_enc_options);
 
 	/* 'DROP_CONTROL_ENABLE', disable */
-	reg = READL(mfc_regs->e_rc_config);
+	reg = readl(mfc_regs->e_rc_config);
 	reg &= ~(0x1 << 10);
-	WRITEL(reg, mfc_regs->e_rc_config);
+	writel(reg, mfc_regs->e_rc_config);
 
 	/* setting for MV range [16, 256] */
 	reg = (p->mv_h_range & S5P_FIMV_E_MV_RANGE_V6_MASK);
-	WRITEL(reg, mfc_regs->e_mv_hor_range);
+	writel(reg, mfc_regs->e_mv_hor_range);
 
 	reg = (p->mv_v_range & S5P_FIMV_E_MV_RANGE_V6_MASK);
-	WRITEL(reg, mfc_regs->e_mv_ver_range);
+	writel(reg, mfc_regs->e_mv_ver_range);
 
-	WRITEL(0x0, mfc_regs->e_frame_insertion);
-	WRITEL(0x0, mfc_regs->e_roi_buffer_addr);
-	WRITEL(0x0, mfc_regs->e_param_change);
-	WRITEL(0x0, mfc_regs->e_rc_roi_ctrl);
-	WRITEL(0x0, mfc_regs->e_picture_tag);
+	writel(0x0, mfc_regs->e_frame_insertion);
+	writel(0x0, mfc_regs->e_roi_buffer_addr);
+	writel(0x0, mfc_regs->e_param_change);
+	writel(0x0, mfc_regs->e_rc_roi_ctrl);
+	writel(0x0, mfc_regs->e_picture_tag);
 
-	WRITEL(0x0, mfc_regs->e_bit_count_enable);
-	WRITEL(0x0, mfc_regs->e_max_bit_count);
-	WRITEL(0x0, mfc_regs->e_min_bit_count);
+	writel(0x0, mfc_regs->e_bit_count_enable);
+	writel(0x0, mfc_regs->e_max_bit_count);
+	writel(0x0, mfc_regs->e_min_bit_count);
 
-	WRITEL(0x0, mfc_regs->e_metadata_buffer_addr);
-	WRITEL(0x0, mfc_regs->e_metadata_buffer_size);
+	writel(0x0, mfc_regs->e_metadata_buffer_addr);
+	writel(0x0, mfc_regs->e_metadata_buffer_size);
 
 	mfc_debug_leave();
 
@@ -814,10 +809,10 @@ static int s5p_mfc_set_enc_params_h264(struct s5p_mfc_ctx *ctx)
 	s5p_mfc_set_enc_params(ctx);
 
 	/* pictype : number of B */
-	reg = READL(mfc_regs->e_gop_config);
+	reg = readl(mfc_regs->e_gop_config);
 	reg &= ~(0x3 << 16);
 	reg |= ((p->num_b_frame & 0x3) << 16);
-	WRITEL(reg, mfc_regs->e_gop_config);
+	writel(reg, mfc_regs->e_gop_config);
 
 	/* profile & level */
 	reg = 0;
@@ -825,19 +820,19 @@ static int s5p_mfc_set_enc_params_h264(struct s5p_mfc_ctx *ctx)
 	reg |= ((p_h264->level & 0xFF) << 8);
 	/** profile - 0 ~ 3 */
 	reg |= p_h264->profile & 0x3F;
-	WRITEL(reg, mfc_regs->e_picture_profile);
+	writel(reg, mfc_regs->e_picture_profile);
 
 	/* rate control config. */
-	reg = READL(mfc_regs->e_rc_config);
+	reg = readl(mfc_regs->e_rc_config);
 	/** macroblock level rate control */
 	reg &= ~(0x1 << 8);
 	reg |= ((p->rc_mb & 0x1) << 8);
-	WRITEL(reg, mfc_regs->e_rc_config);
+	writel(reg, mfc_regs->e_rc_config);
 
 	/** frame QP */
 	reg &= ~(0x3F);
 	reg |= p_h264->rc_frame_qp & 0x3F;
-	WRITEL(reg, mfc_regs->e_rc_config);
+	writel(reg, mfc_regs->e_rc_config);
 
 	/* max & min value of QP */
 	reg = 0;
@@ -845,16 +840,16 @@ static int s5p_mfc_set_enc_params_h264(struct s5p_mfc_ctx *ctx)
 	reg |= ((p_h264->rc_max_qp & 0x3F) << 8);
 	/** min QP */
 	reg |= p_h264->rc_min_qp & 0x3F;
-	WRITEL(reg, mfc_regs->e_rc_qp_bound);
+	writel(reg, mfc_regs->e_rc_qp_bound);
 
 	/* other QPs */
-	WRITEL(0x0, mfc_regs->e_fixed_picture_qp);
+	writel(0x0, mfc_regs->e_fixed_picture_qp);
 	if (!p->rc_frame && !p->rc_mb) {
 		reg = 0;
 		reg |= ((p_h264->rc_b_frame_qp & 0x3F) << 16);
 		reg |= ((p_h264->rc_p_frame_qp & 0x3F) << 8);
 		reg |= p_h264->rc_frame_qp & 0x3F;
-		WRITEL(reg, mfc_regs->e_fixed_picture_qp);
+		writel(reg, mfc_regs->e_fixed_picture_qp);
 	}
 
 	/* frame rate */
@@ -862,38 +857,38 @@ static int s5p_mfc_set_enc_params_h264(struct s5p_mfc_ctx *ctx)
 		reg = 0;
 		reg |= ((p->rc_framerate_num & 0xFFFF) << 16);
 		reg |= p->rc_framerate_denom & 0xFFFF;
-		WRITEL(reg, mfc_regs->e_rc_frame_rate);
+		writel(reg, mfc_regs->e_rc_frame_rate);
 	}
 
 	/* vbv buffer size */
 	if (p->frame_skip_mode ==
 			V4L2_MPEG_MFC51_VIDEO_FRAME_SKIP_MODE_BUF_LIMIT) {
-		WRITEL(p_h264->cpb_size & 0xFFFF,
+		writel(p_h264->cpb_size & 0xFFFF,
 				mfc_regs->e_vbv_buffer_size);
 
 		if (p->rc_frame)
-			WRITEL(p->vbv_delay, mfc_regs->e_vbv_init_delay);
+			writel(p->vbv_delay, mfc_regs->e_vbv_init_delay);
 	}
 
 	/* interlace */
 	reg = 0;
 	reg |= ((p_h264->interlace & 0x1) << 3);
-	WRITEL(reg, mfc_regs->e_h264_options);
+	writel(reg, mfc_regs->e_h264_options);
 
 	/* height */
 	if (p_h264->interlace) {
-		WRITEL(ctx->img_height >> 1,
+		writel(ctx->img_height >> 1,
 				mfc_regs->e_frame_height); /* 32 align */
 		/* cropped height */
-		WRITEL(ctx->img_height >> 1,
+		writel(ctx->img_height >> 1,
 				mfc_regs->e_cropped_frame_height);
 	}
 
 	/* loop filter ctrl */
-	reg = READL(mfc_regs->e_h264_options);
+	reg = readl(mfc_regs->e_h264_options);
 	reg &= ~(0x3 << 1);
 	reg |= ((p_h264->loop_filter_mode & 0x3) << 1);
-	WRITEL(reg, mfc_regs->e_h264_options);
+	writel(reg, mfc_regs->e_h264_options);
 
 	/* loopfilter alpha offset */
 	if (p_h264->loop_filter_alpha < 0) {
@@ -903,7 +898,7 @@ static int s5p_mfc_set_enc_params_h264(struct s5p_mfc_ctx *ctx)
 		reg = 0x00;
 		reg |= (p_h264->loop_filter_alpha & 0xF);
 	}
-	WRITEL(reg, mfc_regs->e_h264_lf_alpha_offset);
+	writel(reg, mfc_regs->e_h264_lf_alpha_offset);
 
 	/* loopfilter beta offset */
 	if (p_h264->loop_filter_beta < 0) {
@@ -913,28 +908,28 @@ static int s5p_mfc_set_enc_params_h264(struct s5p_mfc_ctx *ctx)
 		reg = 0x00;
 		reg |= (p_h264->loop_filter_beta & 0xF);
 	}
-	WRITEL(reg, mfc_regs->e_h264_lf_beta_offset);
+	writel(reg, mfc_regs->e_h264_lf_beta_offset);
 
 	/* entropy coding mode */
-	reg = READL(mfc_regs->e_h264_options);
+	reg = readl(mfc_regs->e_h264_options);
 	reg &= ~(0x1);
 	reg |= p_h264->entropy_mode & 0x1;
-	WRITEL(reg, mfc_regs->e_h264_options);
+	writel(reg, mfc_regs->e_h264_options);
 
 	/* number of ref. picture */
-	reg = READL(mfc_regs->e_h264_options);
+	reg = readl(mfc_regs->e_h264_options);
 	reg &= ~(0x1 << 7);
 	reg |= (((p_h264->num_ref_pic_4p - 1) & 0x1) << 7);
-	WRITEL(reg, mfc_regs->e_h264_options);
+	writel(reg, mfc_regs->e_h264_options);
 
 	/* 8x8 transform enable */
-	reg = READL(mfc_regs->e_h264_options);
+	reg = readl(mfc_regs->e_h264_options);
 	reg &= ~(0x3 << 12);
 	reg |= ((p_h264->_8x8_transform & 0x3) << 12);
-	WRITEL(reg, mfc_regs->e_h264_options);
+	writel(reg, mfc_regs->e_h264_options);
 
 	/* macroblock adaptive scaling features */
-	WRITEL(0x0, mfc_regs->e_mb_rc_config);
+	writel(0x0, mfc_regs->e_mb_rc_config);
 	if (p->rc_mb) {
 		reg = 0;
 		/** dark region */
@@ -945,95 +940,95 @@ static int s5p_mfc_set_enc_params_h264(struct s5p_mfc_ctx *ctx)
 		reg |= ((p_h264->rc_mb_static & 0x1) << 1);
 		/** high activity region */
 		reg |= p_h264->rc_mb_activity & 0x1;
-		WRITEL(reg, mfc_regs->e_mb_rc_config);
+		writel(reg, mfc_regs->e_mb_rc_config);
 	}
 
 	/* aspect ratio VUI */
-	READL(mfc_regs->e_h264_options);
+	readl(mfc_regs->e_h264_options);
 	reg &= ~(0x1 << 5);
 	reg |= ((p_h264->vui_sar & 0x1) << 5);
-	WRITEL(reg, mfc_regs->e_h264_options);
+	writel(reg, mfc_regs->e_h264_options);
 
-	WRITEL(0x0, mfc_regs->e_aspect_ratio);
-	WRITEL(0x0, mfc_regs->e_extended_sar);
+	writel(0x0, mfc_regs->e_aspect_ratio);
+	writel(0x0, mfc_regs->e_extended_sar);
 	if (p_h264->vui_sar) {
 		/* aspect ration IDC */
 		reg = 0;
 		reg |= p_h264->vui_sar_idc & 0xFF;
-		WRITEL(reg, mfc_regs->e_aspect_ratio);
+		writel(reg, mfc_regs->e_aspect_ratio);
 		if (p_h264->vui_sar_idc == 0xFF) {
 			/* extended SAR */
 			reg = 0;
 			reg |= (p_h264->vui_ext_sar_width & 0xFFFF) << 16;
 			reg |= p_h264->vui_ext_sar_height & 0xFFFF;
-			WRITEL(reg, mfc_regs->e_extended_sar);
+			writel(reg, mfc_regs->e_extended_sar);
 		}
 	}
 
 	/* intra picture period for H.264 open GOP */
 	/* control */
-	READL(mfc_regs->e_h264_options);
+	readl(mfc_regs->e_h264_options);
 	reg &= ~(0x1 << 4);
 	reg |= ((p_h264->open_gop & 0x1) << 4);
-	WRITEL(reg, mfc_regs->e_h264_options);
+	writel(reg, mfc_regs->e_h264_options);
 
 	/* value */
-	WRITEL(0x0, mfc_regs->e_h264_i_period);
+	writel(0x0, mfc_regs->e_h264_i_period);
 	if (p_h264->open_gop) {
 		reg = 0;
 		reg |= p_h264->open_gop_size & 0xFFFF;
-		WRITEL(reg, mfc_regs->e_h264_i_period);
+		writel(reg, mfc_regs->e_h264_i_period);
 	}
 
 	/* 'WEIGHTED_BI_PREDICTION' for B is disable */
-	READL(mfc_regs->e_h264_options);
+	readl(mfc_regs->e_h264_options);
 	reg &= ~(0x3 << 9);
-	WRITEL(reg, mfc_regs->e_h264_options);
+	writel(reg, mfc_regs->e_h264_options);
 
 	/* 'CONSTRAINED_INTRA_PRED_ENABLE' is disable */
-	READL(mfc_regs->e_h264_options);
+	readl(mfc_regs->e_h264_options);
 	reg &= ~(0x1 << 14);
-	WRITEL(reg, mfc_regs->e_h264_options);
+	writel(reg, mfc_regs->e_h264_options);
 
 	/* ASO */
-	READL(mfc_regs->e_h264_options);
+	readl(mfc_regs->e_h264_options);
 	reg &= ~(0x1 << 6);
 	reg |= ((p_h264->aso & 0x1) << 6);
-	WRITEL(reg, mfc_regs->e_h264_options);
+	writel(reg, mfc_regs->e_h264_options);
 
 	/* hier qp enable */
-	READL(mfc_regs->e_h264_options);
+	readl(mfc_regs->e_h264_options);
 	reg &= ~(0x1 << 8);
 	reg |= ((p_h264->open_gop & 0x1) << 8);
-	WRITEL(reg, mfc_regs->e_h264_options);
+	writel(reg, mfc_regs->e_h264_options);
 	reg = 0;
 	if (p_h264->hier_qp && p_h264->hier_qp_layer) {
 		reg |= (p_h264->hier_qp_type & 0x1) << 0x3;
 		reg |= p_h264->hier_qp_layer & 0x7;
-		WRITEL(reg, mfc_regs->e_h264_num_t_layer);
+		writel(reg, mfc_regs->e_h264_num_t_layer);
 		/* QP value for each layer */
 		for (i = 0; i < p_h264->hier_qp_layer &&
 				i < ARRAY_SIZE(p_h264->hier_qp_layer_qp); i++) {
-			WRITEL(p_h264->hier_qp_layer_qp[i],
+			writel(p_h264->hier_qp_layer_qp[i],
 				mfc_regs->e_h264_hierarchical_qp_layer0
 				+ i * 4);
 		}
 	}
 	/* number of coding layer should be zero when hierarchical is disable */
-	WRITEL(reg, mfc_regs->e_h264_num_t_layer);
+	writel(reg, mfc_regs->e_h264_num_t_layer);
 
 	/* frame packing SEI generation */
-	READL(mfc_regs->e_h264_options);
+	readl(mfc_regs->e_h264_options);
 	reg &= ~(0x1 << 25);
 	reg |= ((p_h264->sei_frame_packing & 0x1) << 25);
-	WRITEL(reg, mfc_regs->e_h264_options);
+	writel(reg, mfc_regs->e_h264_options);
 	if (p_h264->sei_frame_packing) {
 		reg = 0;
 		/** current frame0 flag */
 		reg |= ((p_h264->sei_fp_curr_frame_0 & 0x1) << 2);
 		/** arrangement type */
 		reg |= p_h264->sei_fp_arrangement_type & 0x3;
-		WRITEL(reg, mfc_regs->e_h264_frame_packing_sei_info);
+		writel(reg, mfc_regs->e_h264_frame_packing_sei_info);
 	}
 
 	if (p_h264->fmo) {
@@ -1042,7 +1037,7 @@ static int s5p_mfc_set_enc_params_h264(struct s5p_mfc_ctx *ctx)
 			if (p_h264->fmo_slice_grp > 4)
 				p_h264->fmo_slice_grp = 4;
 			for (i = 0; i < (p_h264->fmo_slice_grp & 0xF); i++)
-				WRITEL(p_h264->fmo_run_len[i] - 1,
+				writel(p_h264->fmo_run_len[i] - 1,
 					mfc_regs->e_h264_fmo_run_length_minus1_0
 					+ i * 4);
 			break;
@@ -1054,10 +1049,10 @@ static int s5p_mfc_set_enc_params_h264(struct s5p_mfc_ctx *ctx)
 		case V4L2_MPEG_VIDEO_H264_FMO_MAP_TYPE_WIPE_SCAN:
 			if (p_h264->fmo_slice_grp > 2)
 				p_h264->fmo_slice_grp = 2;
-			WRITEL(p_h264->fmo_chg_dir & 0x1,
+			writel(p_h264->fmo_chg_dir & 0x1,
 				mfc_regs->e_h264_fmo_slice_grp_change_dir);
 			/* the valid range is 0 ~ number of macroblocks -1 */
-			WRITEL(p_h264->fmo_chg_rate,
+			writel(p_h264->fmo_chg_rate,
 			mfc_regs->e_h264_fmo_slice_grp_change_rate_minus1);
 			break;
 		default:
@@ -1068,12 +1063,12 @@ static int s5p_mfc_set_enc_params_h264(struct s5p_mfc_ctx *ctx)
 			break;
 		}
 
-		WRITEL(p_h264->fmo_map_type,
+		writel(p_h264->fmo_map_type,
 				mfc_regs->e_h264_fmo_slice_grp_map_type);
-		WRITEL(p_h264->fmo_slice_grp - 1,
+		writel(p_h264->fmo_slice_grp - 1,
 				mfc_regs->e_h264_fmo_num_slice_grp_minus1);
 	} else {
-		WRITEL(0, mfc_regs->e_h264_fmo_num_slice_grp_minus1);
+		writel(0, mfc_regs->e_h264_fmo_num_slice_grp_minus1);
 	}
 
 	mfc_debug_leave();
@@ -1094,10 +1089,10 @@ static int s5p_mfc_set_enc_params_mpeg4(struct s5p_mfc_ctx *ctx)
 	s5p_mfc_set_enc_params(ctx);
 
 	/* pictype : number of B */
-	reg = READL(mfc_regs->e_gop_config);
+	reg = readl(mfc_regs->e_gop_config);
 	reg &= ~(0x3 << 16);
 	reg |= ((p->num_b_frame & 0x3) << 16);
-	WRITEL(reg, mfc_regs->e_gop_config);
+	writel(reg, mfc_regs->e_gop_config);
 
 	/* profile & level */
 	reg = 0;
@@ -1105,19 +1100,19 @@ static int s5p_mfc_set_enc_params_mpeg4(struct s5p_mfc_ctx *ctx)
 	reg |= ((p_mpeg4->level & 0xFF) << 8);
 	/** profile - 0 ~ 1 */
 	reg |= p_mpeg4->profile & 0x3F;
-	WRITEL(reg, mfc_regs->e_picture_profile);
+	writel(reg, mfc_regs->e_picture_profile);
 
 	/* rate control config. */
-	reg = READL(mfc_regs->e_rc_config);
+	reg = readl(mfc_regs->e_rc_config);
 	/** macroblock level rate control */
 	reg &= ~(0x1 << 8);
 	reg |= ((p->rc_mb & 0x1) << 8);
-	WRITEL(reg, mfc_regs->e_rc_config);
+	writel(reg, mfc_regs->e_rc_config);
 
 	/** frame QP */
 	reg &= ~(0x3F);
 	reg |= p_mpeg4->rc_frame_qp & 0x3F;
-	WRITEL(reg, mfc_regs->e_rc_config);
+	writel(reg, mfc_regs->e_rc_config);
 
 	/* max & min value of QP */
 	reg = 0;
@@ -1125,16 +1120,16 @@ static int s5p_mfc_set_enc_params_mpeg4(struct s5p_mfc_ctx *ctx)
 	reg |= ((p_mpeg4->rc_max_qp & 0x3F) << 8);
 	/** min QP */
 	reg |= p_mpeg4->rc_min_qp & 0x3F;
-	WRITEL(reg, mfc_regs->e_rc_qp_bound);
+	writel(reg, mfc_regs->e_rc_qp_bound);
 
 	/* other QPs */
-	WRITEL(0x0, mfc_regs->e_fixed_picture_qp);
+	writel(0x0, mfc_regs->e_fixed_picture_qp);
 	if (!p->rc_frame && !p->rc_mb) {
 		reg = 0;
 		reg |= ((p_mpeg4->rc_b_frame_qp & 0x3F) << 16);
 		reg |= ((p_mpeg4->rc_p_frame_qp & 0x3F) << 8);
 		reg |= p_mpeg4->rc_frame_qp & 0x3F;
-		WRITEL(reg, mfc_regs->e_fixed_picture_qp);
+		writel(reg, mfc_regs->e_fixed_picture_qp);
 	}
 
 	/* frame rate */
@@ -1142,21 +1137,21 @@ static int s5p_mfc_set_enc_params_mpeg4(struct s5p_mfc_ctx *ctx)
 		reg = 0;
 		reg |= ((p->rc_framerate_num & 0xFFFF) << 16);
 		reg |= p->rc_framerate_denom & 0xFFFF;
-		WRITEL(reg, mfc_regs->e_rc_frame_rate);
+		writel(reg, mfc_regs->e_rc_frame_rate);
 	}
 
 	/* vbv buffer size */
 	if (p->frame_skip_mode ==
 			V4L2_MPEG_MFC51_VIDEO_FRAME_SKIP_MODE_BUF_LIMIT) {
-		WRITEL(p->vbv_size & 0xFFFF, mfc_regs->e_vbv_buffer_size);
+		writel(p->vbv_size & 0xFFFF, mfc_regs->e_vbv_buffer_size);
 
 		if (p->rc_frame)
-			WRITEL(p->vbv_delay, mfc_regs->e_vbv_init_delay);
+			writel(p->vbv_delay, mfc_regs->e_vbv_init_delay);
 	}
 
 	/* Disable HEC */
-	WRITEL(0x0, mfc_regs->e_mpeg4_options);
-	WRITEL(0x0, mfc_regs->e_mpeg4_hec_period);
+	writel(0x0, mfc_regs->e_mpeg4_options);
+	writel(0x0, mfc_regs->e_mpeg4_hec_period);
 
 	mfc_debug_leave();
 
@@ -1179,19 +1174,19 @@ static int s5p_mfc_set_enc_params_h263(struct s5p_mfc_ctx *ctx)
 	reg = 0;
 	/** profile */
 	reg |= (0x1 << 4);
-	WRITEL(reg, mfc_regs->e_picture_profile);
+	writel(reg, mfc_regs->e_picture_profile);
 
 	/* rate control config. */
-	reg = READL(mfc_regs->e_rc_config);
+	reg = readl(mfc_regs->e_rc_config);
 	/** macroblock level rate control */
 	reg &= ~(0x1 << 8);
 	reg |= ((p->rc_mb & 0x1) << 8);
-	WRITEL(reg, mfc_regs->e_rc_config);
+	writel(reg, mfc_regs->e_rc_config);
 
 	/** frame QP */
 	reg &= ~(0x3F);
 	reg |= p_h263->rc_frame_qp & 0x3F;
-	WRITEL(reg, mfc_regs->e_rc_config);
+	writel(reg, mfc_regs->e_rc_config);
 
 	/* max & min value of QP */
 	reg = 0;
@@ -1199,16 +1194,16 @@ static int s5p_mfc_set_enc_params_h263(struct s5p_mfc_ctx *ctx)
 	reg |= ((p_h263->rc_max_qp & 0x3F) << 8);
 	/** min QP */
 	reg |= p_h263->rc_min_qp & 0x3F;
-	WRITEL(reg, mfc_regs->e_rc_qp_bound);
+	writel(reg, mfc_regs->e_rc_qp_bound);
 
 	/* other QPs */
-	WRITEL(0x0, mfc_regs->e_fixed_picture_qp);
+	writel(0x0, mfc_regs->e_fixed_picture_qp);
 	if (!p->rc_frame && !p->rc_mb) {
 		reg = 0;
 		reg |= ((p_h263->rc_b_frame_qp & 0x3F) << 16);
 		reg |= ((p_h263->rc_p_frame_qp & 0x3F) << 8);
 		reg |= p_h263->rc_frame_qp & 0x3F;
-		WRITEL(reg, mfc_regs->e_fixed_picture_qp);
+		writel(reg, mfc_regs->e_fixed_picture_qp);
 	}
 
 	/* frame rate */
@@ -1216,16 +1211,16 @@ static int s5p_mfc_set_enc_params_h263(struct s5p_mfc_ctx *ctx)
 		reg = 0;
 		reg |= ((p->rc_framerate_num & 0xFFFF) << 16);
 		reg |= p->rc_framerate_denom & 0xFFFF;
-		WRITEL(reg, mfc_regs->e_rc_frame_rate);
+		writel(reg, mfc_regs->e_rc_frame_rate);
 	}
 
 	/* vbv buffer size */
 	if (p->frame_skip_mode ==
 			V4L2_MPEG_MFC51_VIDEO_FRAME_SKIP_MODE_BUF_LIMIT) {
-		WRITEL(p->vbv_size & 0xFFFF, mfc_regs->e_vbv_buffer_size);
+		writel(p->vbv_size & 0xFFFF, mfc_regs->e_vbv_buffer_size);
 
 		if (p->rc_frame)
-			WRITEL(p->vbv_delay, mfc_regs->e_vbv_init_delay);
+			writel(p->vbv_delay, mfc_regs->e_vbv_init_delay);
 	}
 
 	mfc_debug_leave();
@@ -1247,57 +1242,57 @@ static int s5p_mfc_set_enc_params_vp8(struct s5p_mfc_ctx *ctx)
 	s5p_mfc_set_enc_params(ctx);
 
 	/* pictype : number of B */
-	reg = READL(mfc_regs->e_gop_config);
+	reg = readl(mfc_regs->e_gop_config);
 	reg &= ~(0x3 << 16);
 	reg |= ((p->num_b_frame & 0x3) << 16);
-	WRITEL(reg, mfc_regs->e_gop_config);
+	writel(reg, mfc_regs->e_gop_config);
 
 	/* profile - 0 ~ 3 */
 	reg = p_vp8->profile & 0x3;
-	WRITEL(reg, mfc_regs->e_picture_profile);
+	writel(reg, mfc_regs->e_picture_profile);
 
 	/* rate control config. */
-	reg = READL(mfc_regs->e_rc_config);
+	reg = readl(mfc_regs->e_rc_config);
 	/** macroblock level rate control */
 	reg &= ~(0x1 << 8);
 	reg |= ((p->rc_mb & 0x1) << 8);
-	WRITEL(reg, mfc_regs->e_rc_config);
+	writel(reg, mfc_regs->e_rc_config);
 
 	/* frame rate */
 	if (p->rc_frame && p->rc_framerate_num && p->rc_framerate_denom) {
 		reg = 0;
 		reg |= ((p->rc_framerate_num & 0xFFFF) << 16);
 		reg |= p->rc_framerate_denom & 0xFFFF;
-		WRITEL(reg, mfc_regs->e_rc_frame_rate);
+		writel(reg, mfc_regs->e_rc_frame_rate);
 	}
 
 	/* frame QP */
 	reg &= ~(0x7F);
 	reg |= p_vp8->rc_frame_qp & 0x7F;
-	WRITEL(reg, mfc_regs->e_rc_config);
+	writel(reg, mfc_regs->e_rc_config);
 
 	/* other QPs */
-	WRITEL(0x0, mfc_regs->e_fixed_picture_qp);
+	writel(0x0, mfc_regs->e_fixed_picture_qp);
 	if (!p->rc_frame && !p->rc_mb) {
 		reg = 0;
 		reg |= ((p_vp8->rc_p_frame_qp & 0x7F) << 8);
 		reg |= p_vp8->rc_frame_qp & 0x7F;
-		WRITEL(reg, mfc_regs->e_fixed_picture_qp);
+		writel(reg, mfc_regs->e_fixed_picture_qp);
 	}
 
 	/* max QP */
 	reg = ((p_vp8->rc_max_qp & 0x7F) << 8);
 	/* min QP */
 	reg |= p_vp8->rc_min_qp & 0x7F;
-	WRITEL(reg, mfc_regs->e_rc_qp_bound);
+	writel(reg, mfc_regs->e_rc_qp_bound);
 
 	/* vbv buffer size */
 	if (p->frame_skip_mode ==
 			V4L2_MPEG_MFC51_VIDEO_FRAME_SKIP_MODE_BUF_LIMIT) {
-		WRITEL(p->vbv_size & 0xFFFF, mfc_regs->e_vbv_buffer_size);
+		writel(p->vbv_size & 0xFFFF, mfc_regs->e_vbv_buffer_size);
 
 		if (p->rc_frame)
-			WRITEL(p->vbv_delay, mfc_regs->e_vbv_init_delay);
+			writel(p->vbv_delay, mfc_regs->e_vbv_init_delay);
 	}
 
 	/* VP8 specific params */
@@ -1319,7 +1314,7 @@ static int s5p_mfc_set_enc_params_vp8(struct s5p_mfc_ctx *ctx)
 	}
 	reg |= (val & 0xF) << 3;
 	reg |= (p_vp8->num_ref & 0x2);
-	WRITEL(reg, mfc_regs->e_vp8_options);
+	writel(reg, mfc_regs->e_vp8_options);
 
 	mfc_debug_leave();
 
@@ -1338,9 +1333,9 @@ static int s5p_mfc_init_decode_v6(struct s5p_mfc_ctx *ctx)
 	mfc_debug(2, "InstNo: %d/%d\n", ctx->inst_no,
 			S5P_FIMV_CH_SEQ_HEADER_V6);
 	mfc_debug(2, "BUFs: %08x %08x %08x\n",
-		  READL(mfc_regs->d_cpb_buffer_addr),
-		  READL(mfc_regs->d_cpb_buffer_addr),
-		  READL(mfc_regs->d_cpb_buffer_addr));
+		  readl(mfc_regs->d_cpb_buffer_addr),
+		  readl(mfc_regs->d_cpb_buffer_addr),
+		  readl(mfc_regs->d_cpb_buffer_addr));
 
 	/* FMO_ASO_CTRL - 0: Enable, 1: Disable */
 	reg |= (fmo_aso_ctrl << S5P_FIMV_D_OPT_FMO_ASO_CTRL_MASK_V6);
@@ -1351,11 +1346,11 @@ static int s5p_mfc_init_decode_v6(struct s5p_mfc_ctx *ctx)
 	 * set to negative value. */
 	if (ctx->display_delay >= 0) {
 		reg |= (0x1 << S5P_FIMV_D_OPT_DDELAY_EN_SHIFT_V6);
-		WRITEL(ctx->display_delay, mfc_regs->d_display_delay);
+		writel(ctx->display_delay, mfc_regs->d_display_delay);
 	}
 
 	if (IS_MFCV7_PLUS(dev) || IS_MFCV6_V2(dev)) {
-		WRITEL(reg, mfc_regs->d_dec_options);
+		writel(reg, mfc_regs->d_dec_options);
 		reg = 0;
 	}
 
@@ -1370,22 +1365,22 @@ static int s5p_mfc_init_decode_v6(struct s5p_mfc_ctx *ctx)
 		reg |= (0x1 << S5P_FIMV_D_OPT_TILE_MODE_SHIFT_V6);
 
 	if (IS_MFCV7_PLUS(dev) || IS_MFCV6_V2(dev))
-		WRITEL(reg, mfc_regs->d_init_buffer_options);
+		writel(reg, mfc_regs->d_init_buffer_options);
 	else
-		WRITEL(reg, mfc_regs->d_dec_options);
+		writel(reg, mfc_regs->d_dec_options);
 
 	/* 0: NV12(CbCr), 1: NV21(CrCb) */
 	if (ctx->dst_fmt->fourcc == V4L2_PIX_FMT_NV21M)
-		WRITEL(0x1, mfc_regs->pixel_format);
+		writel(0x1, mfc_regs->pixel_format);
 	else
-		WRITEL(0x0, mfc_regs->pixel_format);
+		writel(0x0, mfc_regs->pixel_format);
 
 
 	/* sei parse */
-	WRITEL(ctx->sei_fp_parse & 0x1, mfc_regs->d_sei_enable);
+	writel(ctx->sei_fp_parse & 0x1, mfc_regs->d_sei_enable);
 
-	WRITEL(ctx->inst_no, mfc_regs->instance_id);
-	s5p_mfc_hw_call(dev->mfc_cmds, cmd_host2risc, dev,
+	writel(ctx->inst_no, mfc_regs->instance_id);
+	s5p_mfc_hw_call_void(dev->mfc_cmds, cmd_host2risc, dev,
 			S5P_FIMV_CH_SEQ_HEADER_V6, NULL);
 
 	mfc_debug_leave();
@@ -1400,8 +1395,8 @@ static inline void s5p_mfc_set_flush(struct s5p_mfc_ctx *ctx, int flush)
 	if (flush) {
 		dev->curr_ctx = ctx->num;
 		s5p_mfc_clean_ctx_int_flags(ctx);
-		WRITEL(ctx->inst_no, mfc_regs->instance_id);
-		s5p_mfc_hw_call(dev->mfc_cmds, cmd_host2risc, dev,
+		writel(ctx->inst_no, mfc_regs->instance_id);
+		s5p_mfc_hw_call_void(dev->mfc_cmds, cmd_host2risc, dev,
 				S5P_FIMV_H2R_CMD_FLUSH_V6, NULL);
 	}
 }
@@ -1413,19 +1408,19 @@ static int s5p_mfc_decode_one_frame_v6(struct s5p_mfc_ctx *ctx,
 	struct s5p_mfc_dev *dev = ctx->dev;
 	const struct s5p_mfc_regs *mfc_regs = dev->mfc_regs;
 
-	WRITEL(ctx->dec_dst_flag, mfc_regs->d_available_dpb_flag_lower);
-	WRITEL(ctx->slice_interface & 0x1, mfc_regs->d_slice_if_enable);
+	writel(ctx->dec_dst_flag, mfc_regs->d_available_dpb_flag_lower);
+	writel(ctx->slice_interface & 0x1, mfc_regs->d_slice_if_enable);
 
-	WRITEL(ctx->inst_no, mfc_regs->instance_id);
+	writel(ctx->inst_no, mfc_regs->instance_id);
 	/* Issue different commands to instance basing on whether it
 	 * is the last frame or not. */
 	switch (last_frame) {
 	case 0:
-		s5p_mfc_hw_call(dev->mfc_cmds, cmd_host2risc, dev,
+		s5p_mfc_hw_call_void(dev->mfc_cmds, cmd_host2risc, dev,
 				S5P_FIMV_CH_FRAME_START_V6, NULL);
 		break;
 	case 1:
-		s5p_mfc_hw_call(dev->mfc_cmds, cmd_host2risc, dev,
+		s5p_mfc_hw_call_void(dev->mfc_cmds, cmd_host2risc, dev,
 				S5P_FIMV_CH_LAST_FRAME_V6, NULL);
 		break;
 	default:
@@ -1458,12 +1453,12 @@ static int s5p_mfc_init_encode_v6(struct s5p_mfc_ctx *ctx)
 
 	/* Set stride lengths for v7 & above */
 	if (IS_MFCV7_PLUS(dev)) {
-		WRITEL(ctx->img_width, mfc_regs->e_source_first_plane_stride);
-		WRITEL(ctx->img_width, mfc_regs->e_source_second_plane_stride);
+		writel(ctx->img_width, mfc_regs->e_source_first_plane_stride);
+		writel(ctx->img_width, mfc_regs->e_source_second_plane_stride);
 	}
 
-	WRITEL(ctx->inst_no, mfc_regs->instance_id);
-	s5p_mfc_hw_call(dev->mfc_cmds, cmd_host2risc, dev,
+	writel(ctx->inst_no, mfc_regs->instance_id);
+	s5p_mfc_hw_call_void(dev->mfc_cmds, cmd_host2risc, dev,
 			S5P_FIMV_CH_SEQ_HEADER_V6, NULL);
 
 	return 0;
@@ -1479,7 +1474,7 @@ static int s5p_mfc_h264_set_aso_slice_order_v6(struct s5p_mfc_ctx *ctx)
 
 	if (p_h264->aso) {
 		for (i = 0; i < ARRAY_SIZE(p_h264->aso_slice_order); i++) {
-			WRITEL(p_h264->aso_slice_order[i],
+			writel(p_h264->aso_slice_order[i],
 				mfc_regs->e_h264_aso_slice_order_0 + i * 4);
 		}
 	}
@@ -1501,8 +1496,8 @@ static int s5p_mfc_encode_one_frame_v6(struct s5p_mfc_ctx *ctx)
 
 	s5p_mfc_set_slice_mode(ctx);
 
-	WRITEL(ctx->inst_no, mfc_regs->instance_id);
-	s5p_mfc_hw_call(dev->mfc_cmds, cmd_host2risc, dev,
+	writel(ctx->inst_no, mfc_regs->instance_id);
+	s5p_mfc_hw_call_void(dev->mfc_cmds, cmd_host2risc, dev,
 			S5P_FIMV_CH_FRAME_START_V6, NULL);
 
 	mfc_debug(2, "--\n");
@@ -1877,15 +1872,15 @@ static void s5p_mfc_cleanup_queue_v6(struct list_head *lh, struct vb2_queue *vq)
 static void s5p_mfc_clear_int_flags_v6(struct s5p_mfc_dev *dev)
 {
 	const struct s5p_mfc_regs *mfc_regs = dev->mfc_regs;
-	WRITEL(0, mfc_regs->risc2host_command);
-	WRITEL(0, mfc_regs->risc2host_int);
+	writel(0, mfc_regs->risc2host_command);
+	writel(0, mfc_regs->risc2host_int);
 }
 
 static void s5p_mfc_write_info_v6(struct s5p_mfc_ctx *ctx, unsigned int data,
 		unsigned int ofs)
 {
 	s5p_mfc_clock_on();
-	WRITEL(data, (void *)ofs);
+	writel(data, (void *)ofs);
 	s5p_mfc_clock_off();
 }
 
@@ -1895,7 +1890,7 @@ s5p_mfc_read_info_v6(struct s5p_mfc_ctx *ctx, unsigned int ofs)
 	int ret;
 
 	s5p_mfc_clock_on();
-	ret = READL((void *)ofs);
+	ret = readl((void *)ofs);
 	s5p_mfc_clock_off();
 
 	return ret;
@@ -1903,51 +1898,51 @@ s5p_mfc_read_info_v6(struct s5p_mfc_ctx *ctx, unsigned int ofs)
 
 static int s5p_mfc_get_dspl_y_adr_v6(struct s5p_mfc_dev *dev)
 {
-	return READL(dev->mfc_regs->d_display_first_plane_addr);
+	return readl(dev->mfc_regs->d_display_first_plane_addr);
 }
 
 static int s5p_mfc_get_dec_y_adr_v6(struct s5p_mfc_dev *dev)
 {
-	return READL(dev->mfc_regs->d_decoded_first_plane_addr);
+	return readl(dev->mfc_regs->d_decoded_first_plane_addr);
 }
 
 static int s5p_mfc_get_dspl_status_v6(struct s5p_mfc_dev *dev)
 {
-	return READL(dev->mfc_regs->d_display_status);
+	return readl(dev->mfc_regs->d_display_status);
 }
 
 static int s5p_mfc_get_dec_status_v6(struct s5p_mfc_dev *dev)
 {
-	return READL(dev->mfc_regs->d_decoded_status);
+	return readl(dev->mfc_regs->d_decoded_status);
 }
 
 static int s5p_mfc_get_dec_frame_type_v6(struct s5p_mfc_dev *dev)
 {
-	return READL(dev->mfc_regs->d_decoded_frame_type) &
+	return readl(dev->mfc_regs->d_decoded_frame_type) &
 		S5P_FIMV_DECODE_FRAME_MASK_V6;
 }
 
 static int s5p_mfc_get_disp_frame_type_v6(struct s5p_mfc_ctx *ctx)
 {
 	struct s5p_mfc_dev *dev = ctx->dev;
-	return READL(dev->mfc_regs->d_display_frame_type) &
+	return readl(dev->mfc_regs->d_display_frame_type) &
 		S5P_FIMV_DECODE_FRAME_MASK_V6;
 }
 
 static int s5p_mfc_get_consumed_stream_v6(struct s5p_mfc_dev *dev)
 {
-	return READL(dev->mfc_regs->d_decoded_nal_size);
+	return readl(dev->mfc_regs->d_decoded_nal_size);
 }
 
 static int s5p_mfc_get_int_reason_v6(struct s5p_mfc_dev *dev)
 {
-	return READL(dev->mfc_regs->risc2host_command) &
+	return readl(dev->mfc_regs->risc2host_command) &
 		S5P_FIMV_RISC2HOST_CMD_MASK;
 }
 
 static int s5p_mfc_get_int_err_v6(struct s5p_mfc_dev *dev)
 {
-	return READL(dev->mfc_regs->error_code);
+	return readl(dev->mfc_regs->error_code);
 }
 
 static int s5p_mfc_err_dec_v6(unsigned int err)
@@ -1962,63 +1957,63 @@ static int s5p_mfc_err_dspl_v6(unsigned int err)
 
 static int s5p_mfc_get_img_width_v6(struct s5p_mfc_dev *dev)
 {
-	return READL(dev->mfc_regs->d_display_frame_width);
+	return readl(dev->mfc_regs->d_display_frame_width);
 }
 
 static int s5p_mfc_get_img_height_v6(struct s5p_mfc_dev *dev)
 {
-	return READL(dev->mfc_regs->d_display_frame_height);
+	return readl(dev->mfc_regs->d_display_frame_height);
 }
 
 static int s5p_mfc_get_dpb_count_v6(struct s5p_mfc_dev *dev)
 {
-	return READL(dev->mfc_regs->d_min_num_dpb);
+	return readl(dev->mfc_regs->d_min_num_dpb);
 }
 
 static int s5p_mfc_get_mv_count_v6(struct s5p_mfc_dev *dev)
 {
-	return READL(dev->mfc_regs->d_min_num_mv);
+	return readl(dev->mfc_regs->d_min_num_mv);
 }
 
 static int s5p_mfc_get_inst_no_v6(struct s5p_mfc_dev *dev)
 {
-	return READL(dev->mfc_regs->ret_instance_id);
+	return readl(dev->mfc_regs->ret_instance_id);
 }
 
 static int s5p_mfc_get_enc_dpb_count_v6(struct s5p_mfc_dev *dev)
 {
-	return READL(dev->mfc_regs->e_num_dpb);
+	return readl(dev->mfc_regs->e_num_dpb);
 }
 
 static int s5p_mfc_get_enc_strm_size_v6(struct s5p_mfc_dev *dev)
 {
-	return READL(dev->mfc_regs->e_stream_size);
+	return readl(dev->mfc_regs->e_stream_size);
 }
 
 static int s5p_mfc_get_enc_slice_type_v6(struct s5p_mfc_dev *dev)
 {
-	return READL(dev->mfc_regs->e_slice_type);
+	return readl(dev->mfc_regs->e_slice_type);
 }
 
 static int s5p_mfc_get_enc_pic_count_v6(struct s5p_mfc_dev *dev)
 {
-	return READL(dev->mfc_regs->e_picture_count);
+	return readl(dev->mfc_regs->e_picture_count);
 }
 
 static int s5p_mfc_get_sei_avail_status_v6(struct s5p_mfc_ctx *ctx)
 {
 	struct s5p_mfc_dev *dev = ctx->dev;
-	return READL(dev->mfc_regs->d_frame_pack_sei_avail);
+	return readl(dev->mfc_regs->d_frame_pack_sei_avail);
 }
 
 static int s5p_mfc_get_mvc_num_views_v6(struct s5p_mfc_dev *dev)
 {
-	return READL(dev->mfc_regs->d_mvc_num_views);
+	return readl(dev->mfc_regs->d_mvc_num_views);
 }
 
 static int s5p_mfc_get_mvc_view_id_v6(struct s5p_mfc_dev *dev)
 {
-	return READL(dev->mfc_regs->d_mvc_view_id);
+	return readl(dev->mfc_regs->d_mvc_view_id);
 }
 
 static unsigned int s5p_mfc_get_pic_type_top_v6(struct s5p_mfc_ctx *ctx)
-- 
1.7.9.5

