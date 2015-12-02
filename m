Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.w1.samsung.com ([210.118.77.11]:17065 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755720AbbLBIXp (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 2 Dec 2015 03:23:45 -0500
Received: from eucpsbgm1.samsung.com (unknown [203.254.199.244])
 by mailout1.w1.samsung.com
 (Oracle Communications Messaging Server 7.0.5.31.0 64bit (built May  5 2014))
 with ESMTP id <0NYQ009DB1ZIXL00@mailout1.w1.samsung.com> for
 linux-media@vger.kernel.org; Wed, 02 Dec 2015 08:23:42 +0000 (GMT)
From: Andrzej Hajda <a.hajda@samsung.com>
To: Kamil Debski <k.debski@samsung.com>
Cc: Andrzej Hajda <a.hajda@samsung.com>,
	Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	linux-media@vger.kernel.org (open list:ARM/SAMSUNG S5P SERIES Multi
	Format Codec (MFC)...), s.nawrocki@samsung.com
Subject: [PATCH 5/6] s5p-mfc: merge together s5p_mfc_hw_call and
 s5p_mfc_hw_call_void
Date: Wed, 02 Dec 2015 09:22:32 +0100
Message-id: <1449044553-27115-6-git-send-email-a.hajda@samsung.com>
In-reply-to: <1449044553-27115-1-git-send-email-a.hajda@samsung.com>
References: <1449044553-27115-1-git-send-email-a.hajda@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Both macros can be merged into one.

Signed-off-by: Andrzej Hajda <a.hajda@samsung.com>
---
 drivers/media/platform/s5p-mfc/s5p_mfc.c        | 38 ++++++++++++-------------
 drivers/media/platform/s5p-mfc/s5p_mfc_common.h |  8 +-----
 drivers/media/platform/s5p-mfc/s5p_mfc_ctrl.c   | 16 +++++------
 drivers/media/platform/s5p-mfc/s5p_mfc_dec.c    | 12 ++++----
 drivers/media/platform/s5p-mfc/s5p_mfc_enc.c    | 20 ++++++-------
 drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c | 16 +++++------
 6 files changed, 52 insertions(+), 58 deletions(-)

diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc.c b/drivers/media/platform/s5p-mfc/s5p_mfc.c
index c4d9e34..81ffb67 100644
--- a/drivers/media/platform/s5p-mfc/s5p_mfc.c
+++ b/drivers/media/platform/s5p-mfc/s5p_mfc.c
@@ -374,11 +374,11 @@ static void s5p_mfc_handle_frame(struct s5p_mfc_ctx *ctx,
 	if (res_change == S5P_FIMV_RES_INCREASE ||
 		res_change == S5P_FIMV_RES_DECREASE) {
 		ctx->state = MFCINST_RES_CHANGE_INIT;
-		s5p_mfc_hw_call_void(dev->mfc_ops, clear_int_flags, dev);
+		s5p_mfc_hw_call(dev->mfc_ops, clear_int_flags, dev);
 		wake_up_ctx(ctx, reason, err);
 		WARN_ON(test_and_clear_bit(0, &dev->hw_lock) == 0);
 		s5p_mfc_clock_off();
-		s5p_mfc_hw_call_void(dev->mfc_ops, try_run, dev);
+		s5p_mfc_hw_call(dev->mfc_ops, try_run, dev);
 		return;
 	}
 	if (ctx->dpb_flush_flag)
@@ -446,7 +446,7 @@ leave_handle_frame:
 	if ((ctx->src_queue_cnt == 0 && ctx->state != MFCINST_FINISHING)
 				    || ctx->dst_queue_cnt < ctx->pb_count)
 		clear_work_bit(ctx);
-	s5p_mfc_hw_call_void(dev->mfc_ops, clear_int_flags, dev);
+	s5p_mfc_hw_call(dev->mfc_ops, clear_int_flags, dev);
 	wake_up_ctx(ctx, reason, err);
 	WARN_ON(test_and_clear_bit(0, &dev->hw_lock) == 0);
 	s5p_mfc_clock_off();
@@ -454,7 +454,7 @@ leave_handle_frame:
 	if (test_bit(0, &dev->enter_suspend))
 		wake_up_dev(dev, reason, err);
 	else
-		s5p_mfc_hw_call_void(dev->mfc_ops, try_run, dev);
+		s5p_mfc_hw_call(dev->mfc_ops, try_run, dev);
 }
 
 /* Error handling for interrupt */
@@ -490,7 +490,7 @@ static void s5p_mfc_handle_error(struct s5p_mfc_dev *dev,
 		}
 	}
 	WARN_ON(test_and_clear_bit(0, &dev->hw_lock) == 0);
-	s5p_mfc_hw_call_void(dev->mfc_ops, clear_int_flags, dev);
+	s5p_mfc_hw_call(dev->mfc_ops, clear_int_flags, dev);
 	s5p_mfc_clock_off();
 	wake_up_dev(dev, reason, err);
 	return;
@@ -514,7 +514,7 @@ static void s5p_mfc_handle_seq_done(struct s5p_mfc_ctx *ctx,
 		ctx->img_height = s5p_mfc_hw_call(dev->mfc_ops, get_img_height,
 				dev);
 
-		s5p_mfc_hw_call_void(dev->mfc_ops, dec_calc_dpb_size, ctx);
+		s5p_mfc_hw_call(dev->mfc_ops, dec_calc_dpb_size, ctx);
 
 		ctx->pb_count = s5p_mfc_hw_call(dev->mfc_ops, get_dpb_count,
 				dev);
@@ -541,11 +541,11 @@ static void s5p_mfc_handle_seq_done(struct s5p_mfc_ctx *ctx,
 			ctx->head_processed = 1;
 		}
 	}
-	s5p_mfc_hw_call_void(dev->mfc_ops, clear_int_flags, dev);
+	s5p_mfc_hw_call(dev->mfc_ops, clear_int_flags, dev);
 	clear_work_bit(ctx);
 	WARN_ON(test_and_clear_bit(0, &dev->hw_lock) == 0);
 	s5p_mfc_clock_off();
-	s5p_mfc_hw_call_void(dev->mfc_ops, try_run, dev);
+	s5p_mfc_hw_call(dev->mfc_ops, try_run, dev);
 	wake_up_ctx(ctx, reason, err);
 }
 
@@ -559,7 +559,7 @@ static void s5p_mfc_handle_init_buffers(struct s5p_mfc_ctx *ctx,
 	if (ctx == NULL)
 		return;
 	dev = ctx->dev;
-	s5p_mfc_hw_call_void(dev->mfc_ops, clear_int_flags, dev);
+	s5p_mfc_hw_call(dev->mfc_ops, clear_int_flags, dev);
 	ctx->int_type = reason;
 	ctx->int_err = err;
 	ctx->int_cond = 1;
@@ -583,7 +583,7 @@ static void s5p_mfc_handle_init_buffers(struct s5p_mfc_ctx *ctx,
 		s5p_mfc_clock_off();
 
 		wake_up(&ctx->queue);
-		s5p_mfc_hw_call_void(dev->mfc_ops, try_run, dev);
+		s5p_mfc_hw_call(dev->mfc_ops, try_run, dev);
 	} else {
 		WARN_ON(test_and_clear_bit(0, &dev->hw_lock) == 0);
 
@@ -617,7 +617,7 @@ static void s5p_mfc_handle_stream_complete(struct s5p_mfc_ctx *ctx)
 
 	s5p_mfc_clock_off();
 	wake_up(&ctx->queue);
-	s5p_mfc_hw_call_void(dev->mfc_ops, try_run, dev);
+	s5p_mfc_hw_call(dev->mfc_ops, try_run, dev);
 }
 
 /* Interrupt processing */
@@ -658,15 +658,15 @@ static irqreturn_t s5p_mfc_irq(int irq, void *priv)
 
 			if (ctx->state == MFCINST_FINISHING &&
 						list_empty(&ctx->ref_queue)) {
-				s5p_mfc_hw_call_void(dev->mfc_ops, clear_int_flags, dev);
+				s5p_mfc_hw_call(dev->mfc_ops, clear_int_flags, dev);
 				s5p_mfc_handle_stream_complete(ctx);
 				break;
 			}
-			s5p_mfc_hw_call_void(dev->mfc_ops, clear_int_flags, dev);
+			s5p_mfc_hw_call(dev->mfc_ops, clear_int_flags, dev);
 			wake_up_ctx(ctx, reason, err);
 			WARN_ON(test_and_clear_bit(0, &dev->hw_lock) == 0);
 			s5p_mfc_clock_off();
-			s5p_mfc_hw_call_void(dev->mfc_ops, try_run, dev);
+			s5p_mfc_hw_call(dev->mfc_ops, try_run, dev);
 		} else {
 			s5p_mfc_handle_frame(ctx, reason, err);
 		}
@@ -696,7 +696,7 @@ static irqreturn_t s5p_mfc_irq(int irq, void *priv)
 	case S5P_MFC_R2H_CMD_WAKEUP_RET:
 		if (ctx)
 			clear_work_bit(ctx);
-		s5p_mfc_hw_call_void(dev->mfc_ops, clear_int_flags, dev);
+		s5p_mfc_hw_call(dev->mfc_ops, clear_int_flags, dev);
 		wake_up_dev(dev, reason, err);
 		clear_bit(0, &dev->hw_lock);
 		clear_bit(0, &dev->enter_suspend);
@@ -707,7 +707,7 @@ static irqreturn_t s5p_mfc_irq(int irq, void *priv)
 		break;
 
 	case S5P_MFC_R2H_CMD_COMPLETE_SEQ_RET:
-		s5p_mfc_hw_call_void(dev->mfc_ops, clear_int_flags, dev);
+		s5p_mfc_hw_call(dev->mfc_ops, clear_int_flags, dev);
 		ctx->int_type = reason;
 		ctx->int_err = err;
 		s5p_mfc_handle_stream_complete(ctx);
@@ -721,13 +721,13 @@ static irqreturn_t s5p_mfc_irq(int irq, void *priv)
 
 	default:
 		mfc_debug(2, "Unknown int reason\n");
-		s5p_mfc_hw_call_void(dev->mfc_ops, clear_int_flags, dev);
+		s5p_mfc_hw_call(dev->mfc_ops, clear_int_flags, dev);
 	}
 	spin_unlock(&dev->irqlock);
 	mfc_debug_leave();
 	return IRQ_HANDLED;
 irq_cleanup_hw:
-	s5p_mfc_hw_call_void(dev->mfc_ops, clear_int_flags, dev);
+	s5p_mfc_hw_call(dev->mfc_ops, clear_int_flags, dev);
 	ctx->int_type = reason;
 	ctx->int_err = err;
 	ctx->int_cond = 1;
@@ -736,7 +736,7 @@ irq_cleanup_hw:
 
 	s5p_mfc_clock_off();
 
-	s5p_mfc_hw_call_void(dev->mfc_ops, try_run, dev);
+	s5p_mfc_hw_call(dev->mfc_ops, try_run, dev);
 	spin_unlock(&dev->irqlock);
 	mfc_debug(2, "Exit via irq_cleanup_hw\n");
 	return IRQ_HANDLED;
diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc_common.h b/drivers/media/platform/s5p-mfc/s5p_mfc_common.h
index c5c1881..ca20bd6 100644
--- a/drivers/media/platform/s5p-mfc/s5p_mfc_common.h
+++ b/drivers/media/platform/s5p-mfc/s5p_mfc_common.h
@@ -694,13 +694,7 @@ struct mfc_control {
 
 /* Macro for making hardware specific calls */
 #define s5p_mfc_hw_call(f, op, args...) \
-	((f && f->op) ? f->op(args) : -ENODEV)
-
-#define s5p_mfc_hw_call_void(f, op, args...) \
-do { \
-	if (f && f->op) \
-		f->op(args); \
-} while (0)
+	((f && f->op) ? f->op(args) : (typeof(f->op(args)))(-ENODEV))
 
 #define fh_to_ctx(__fh) container_of(__fh, struct s5p_mfc_ctx, fh)
 #define ctrl_to_ctx(__ctrl) \
diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc_ctrl.c b/drivers/media/platform/s5p-mfc/s5p_mfc_ctrl.c
index 40d8a03..cc88871 100644
--- a/drivers/media/platform/s5p-mfc/s5p_mfc_ctrl.c
+++ b/drivers/media/platform/s5p-mfc/s5p_mfc_ctrl.c
@@ -319,7 +319,7 @@ void s5p_mfc_deinit_hw(struct s5p_mfc_dev *dev)
 	s5p_mfc_clock_on();
 
 	s5p_mfc_reset(dev);
-	s5p_mfc_hw_call_void(dev->mfc_ops, release_dev_context_buffer, dev);
+	s5p_mfc_hw_call(dev->mfc_ops, release_dev_context_buffer, dev);
 
 	s5p_mfc_clock_off();
 }
@@ -468,7 +468,7 @@ int s5p_mfc_open_mfc_inst(struct s5p_mfc_dev *dev, struct s5p_mfc_ctx *ctx)
 	}
 
 	set_work_bit_irqsave(ctx);
-	s5p_mfc_hw_call_void(dev->mfc_ops, try_run, dev);
+	s5p_mfc_hw_call(dev->mfc_ops, try_run, dev);
 	if (s5p_mfc_wait_for_done_ctx(ctx,
 		S5P_MFC_R2H_CMD_OPEN_INSTANCE_RET, 0)) {
 		/* Error or timeout */
@@ -482,9 +482,9 @@ int s5p_mfc_open_mfc_inst(struct s5p_mfc_dev *dev, struct s5p_mfc_ctx *ctx)
 
 err_free_desc_buf:
 	if (ctx->type == MFCINST_DECODER)
-		s5p_mfc_hw_call_void(dev->mfc_ops, release_dec_desc_buffer, ctx);
+		s5p_mfc_hw_call(dev->mfc_ops, release_dec_desc_buffer, ctx);
 err_free_inst_buf:
-	s5p_mfc_hw_call_void(dev->mfc_ops, release_instance_buffer, ctx);
+	s5p_mfc_hw_call(dev->mfc_ops, release_instance_buffer, ctx);
 err:
 	return ret;
 }
@@ -493,17 +493,17 @@ void s5p_mfc_close_mfc_inst(struct s5p_mfc_dev *dev, struct s5p_mfc_ctx *ctx)
 {
 	ctx->state = MFCINST_RETURN_INST;
 	set_work_bit_irqsave(ctx);
-	s5p_mfc_hw_call_void(dev->mfc_ops, try_run, dev);
+	s5p_mfc_hw_call(dev->mfc_ops, try_run, dev);
 	/* Wait until instance is returned or timeout occurred */
 	if (s5p_mfc_wait_for_done_ctx(ctx,
 				S5P_MFC_R2H_CMD_CLOSE_INSTANCE_RET, 0))
 		mfc_err("Err returning instance\n");
 
 	/* Free resources */
-	s5p_mfc_hw_call_void(dev->mfc_ops, release_codec_buffers, ctx);
-	s5p_mfc_hw_call_void(dev->mfc_ops, release_instance_buffer, ctx);
+	s5p_mfc_hw_call(dev->mfc_ops, release_codec_buffers, ctx);
+	s5p_mfc_hw_call(dev->mfc_ops, release_instance_buffer, ctx);
 	if (ctx->type == MFCINST_DECODER)
-		s5p_mfc_hw_call_void(dev->mfc_ops, release_dec_desc_buffer, ctx);
+		s5p_mfc_hw_call(dev->mfc_ops, release_dec_desc_buffer, ctx);
 
 	ctx->inst_no = MFC_NO_INSTANCE_SET;
 	ctx->state = MFCINST_FREE;
diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc_dec.c b/drivers/media/platform/s5p-mfc/s5p_mfc_dec.c
index 62abf2d..51d5996 100644
--- a/drivers/media/platform/s5p-mfc/s5p_mfc_dec.c
+++ b/drivers/media/platform/s5p-mfc/s5p_mfc_dec.c
@@ -523,7 +523,7 @@ static int reqbufs_capture(struct s5p_mfc_dev *dev, struct s5p_mfc_ctx *ctx,
 		ret = vb2_reqbufs(&ctx->vq_dst, reqbufs);
 		if (ret)
 			goto out;
-		s5p_mfc_hw_call_void(dev->mfc_ops, release_codec_buffers, ctx);
+		s5p_mfc_hw_call(dev->mfc_ops, release_codec_buffers, ctx);
 		ctx->dst_bufs_cnt = 0;
 	} else if (ctx->capture_state == QUEUE_FREE) {
 		WARN_ON(ctx->dst_bufs_cnt != 0);
@@ -551,7 +551,7 @@ static int reqbufs_capture(struct s5p_mfc_dev *dev, struct s5p_mfc_ctx *ctx,
 
 		if (s5p_mfc_ctx_ready(ctx))
 			set_work_bit_irqsave(ctx);
-		s5p_mfc_hw_call_void(dev->mfc_ops, try_run, dev);
+		s5p_mfc_hw_call(dev->mfc_ops, try_run, dev);
 		s5p_mfc_wait_for_done_ctx(ctx, S5P_MFC_R2H_CMD_INIT_BUFFERS_RET,
 					  0);
 	} else {
@@ -831,7 +831,7 @@ static int vidioc_decoder_cmd(struct file *file, void *priv,
 			if (s5p_mfc_ctx_ready(ctx))
 				set_work_bit_irqsave(ctx);
 			spin_unlock_irqrestore(&dev->irqlock, flags);
-			s5p_mfc_hw_call_void(dev->mfc_ops, try_run, dev);
+			s5p_mfc_hw_call(dev->mfc_ops, try_run, dev);
 		} else {
 			mfc_err("EOS: marking last buffer of stream");
 			buf = list_entry(ctx->src_queue.prev,
@@ -1012,7 +1012,7 @@ static int s5p_mfc_start_streaming(struct vb2_queue *q, unsigned int count)
 	/* If context is ready then dev = work->data;schedule it to run */
 	if (s5p_mfc_ctx_ready(ctx))
 		set_work_bit_irqsave(ctx);
-	s5p_mfc_hw_call_void(dev->mfc_ops, try_run, dev);
+	s5p_mfc_hw_call(dev->mfc_ops, try_run, dev);
 	return 0;
 }
 
@@ -1043,7 +1043,7 @@ static void s5p_mfc_stop_streaming(struct vb2_queue *q)
 		if (IS_MFCV6_PLUS(dev) && (ctx->state == MFCINST_RUNNING)) {
 			ctx->state = MFCINST_FLUSH;
 			set_work_bit_irqsave(ctx);
-			s5p_mfc_hw_call_void(dev->mfc_ops, try_run, dev);
+			s5p_mfc_hw_call(dev->mfc_ops, try_run, dev);
 			spin_unlock_irqrestore(&dev->irqlock, flags);
 			if (s5p_mfc_wait_for_done_ctx(ctx,
 				S5P_MFC_R2H_CMD_DPB_FLUSH_RET, 0))
@@ -1090,7 +1090,7 @@ static void s5p_mfc_buf_queue(struct vb2_buffer *vb)
 	}
 	if (s5p_mfc_ctx_ready(ctx))
 		set_work_bit_irqsave(ctx);
-	s5p_mfc_hw_call_void(dev->mfc_ops, try_run, dev);
+	s5p_mfc_hw_call(dev->mfc_ops, try_run, dev);
 }
 
 static struct vb2_ops s5p_mfc_dec_qops = {
diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc_enc.c b/drivers/media/platform/s5p-mfc/s5p_mfc_enc.c
index 434bcd0..0656185 100644
--- a/drivers/media/platform/s5p-mfc/s5p_mfc_enc.c
+++ b/drivers/media/platform/s5p-mfc/s5p_mfc_enc.c
@@ -773,7 +773,7 @@ static int enc_pre_seq_start(struct s5p_mfc_ctx *ctx)
 	dst_mb = list_entry(ctx->dst_queue.next, struct s5p_mfc_buf, list);
 	dst_addr = vb2_dma_contig_plane_dma_addr(&dst_mb->b->vb2_buf, 0);
 	dst_size = vb2_plane_size(&dst_mb->b->vb2_buf, 0);
-	s5p_mfc_hw_call_void(dev->mfc_ops, set_enc_stream_buffer, ctx, dst_addr,
+	s5p_mfc_hw_call(dev->mfc_ops, set_enc_stream_buffer, ctx, dst_addr,
 			dst_size);
 	return 0;
 }
@@ -803,7 +803,7 @@ static int enc_post_seq_start(struct s5p_mfc_ctx *ctx)
 		ctx->state = MFCINST_RUNNING;
 		if (s5p_mfc_ctx_ready(ctx))
 			set_work_bit_irqsave(ctx);
-		s5p_mfc_hw_call_void(dev->mfc_ops, try_run, dev);
+		s5p_mfc_hw_call(dev->mfc_ops, try_run, dev);
 	} else {
 		enc_pb_count = s5p_mfc_hw_call(dev->mfc_ops,
 				get_enc_dpb_count, dev);
@@ -826,13 +826,13 @@ static int enc_pre_frame_start(struct s5p_mfc_ctx *ctx)
 	src_mb = list_entry(ctx->src_queue.next, struct s5p_mfc_buf, list);
 	src_y_addr = vb2_dma_contig_plane_dma_addr(&src_mb->b->vb2_buf, 0);
 	src_c_addr = vb2_dma_contig_plane_dma_addr(&src_mb->b->vb2_buf, 1);
-	s5p_mfc_hw_call_void(dev->mfc_ops, set_enc_frame_buffer, ctx,
+	s5p_mfc_hw_call(dev->mfc_ops, set_enc_frame_buffer, ctx,
 							src_y_addr, src_c_addr);
 
 	dst_mb = list_entry(ctx->dst_queue.next, struct s5p_mfc_buf, list);
 	dst_addr = vb2_dma_contig_plane_dma_addr(&dst_mb->b->vb2_buf, 0);
 	dst_size = vb2_plane_size(&dst_mb->b->vb2_buf, 0);
-	s5p_mfc_hw_call_void(dev->mfc_ops, set_enc_stream_buffer, ctx, dst_addr,
+	s5p_mfc_hw_call(dev->mfc_ops, set_enc_stream_buffer, ctx, dst_addr,
 			dst_size);
 
 	return 0;
@@ -854,7 +854,7 @@ static int enc_post_frame_start(struct s5p_mfc_ctx *ctx)
 	mfc_debug(2, "Display order: %d\n",
 		  mfc_read(dev, S5P_FIMV_ENC_SI_PIC_CNT));
 	if (slice_type >= 0) {
-		s5p_mfc_hw_call_void(dev->mfc_ops, get_enc_frame_buffer, ctx,
+		s5p_mfc_hw_call(dev->mfc_ops, get_enc_frame_buffer, ctx,
 				&enc_y_addr, &enc_c_addr);
 		list_for_each_entry(mb_entry, &ctx->src_queue, list) {
 			mb_y_addr = vb2_dma_contig_plane_dma_addr(
@@ -1106,7 +1106,7 @@ static int vidioc_s_fmt(struct file *file, void *priv, struct v4l2_format *f)
 			pix_fmt_mp->width, pix_fmt_mp->height,
 			ctx->img_width, ctx->img_height);
 
-		s5p_mfc_hw_call_void(dev->mfc_ops, enc_calc_src_size, ctx);
+		s5p_mfc_hw_call(dev->mfc_ops, enc_calc_src_size, ctx);
 		pix_fmt_mp->plane_fmt[0].sizeimage = ctx->luma_size;
 		pix_fmt_mp->plane_fmt[0].bytesperline = ctx->buf_width;
 		pix_fmt_mp->plane_fmt[1].sizeimage = ctx->chroma_size;
@@ -1164,7 +1164,7 @@ static int vidioc_reqbufs(struct file *file, void *priv,
 		if (reqbufs->count == 0) {
 			mfc_debug(2, "Freeing buffers\n");
 			ret = vb2_reqbufs(&ctx->vq_src, reqbufs);
-			s5p_mfc_hw_call_void(dev->mfc_ops, release_codec_buffers,
+			s5p_mfc_hw_call(dev->mfc_ops, release_codec_buffers,
 					ctx);
 			ctx->output_state = QUEUE_FREE;
 			return ret;
@@ -1727,7 +1727,7 @@ static int vidioc_encoder_cmd(struct file *file, void *priv,
 			if (s5p_mfc_ctx_ready(ctx))
 				set_work_bit_irqsave(ctx);
 			spin_unlock_irqrestore(&dev->irqlock, flags);
-			s5p_mfc_hw_call_void(dev->mfc_ops, try_run, dev);
+			s5p_mfc_hw_call(dev->mfc_ops, try_run, dev);
 		} else {
 			mfc_debug(2, "EOS: marking last buffer of stream\n");
 			buf = list_entry(ctx->src_queue.prev,
@@ -1955,7 +1955,7 @@ static int s5p_mfc_start_streaming(struct vb2_queue *q, unsigned int count)
 	/* If context is ready then dev = work->data;schedule it to run */
 	if (s5p_mfc_ctx_ready(ctx))
 		set_work_bit_irqsave(ctx);
-	s5p_mfc_hw_call_void(dev->mfc_ops, try_run, dev);
+	s5p_mfc_hw_call(dev->mfc_ops, try_run, dev);
 
 	return 0;
 }
@@ -2022,7 +2022,7 @@ static void s5p_mfc_buf_queue(struct vb2_buffer *vb)
 	}
 	if (s5p_mfc_ctx_ready(ctx))
 		set_work_bit_irqsave(ctx);
-	s5p_mfc_hw_call_void(dev->mfc_ops, try_run, dev);
+	s5p_mfc_hw_call(dev->mfc_ops, try_run, dev);
 }
 
 static struct vb2_ops s5p_mfc_enc_qops = {
diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c b/drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c
index 2a9ca428..d6f207e 100644
--- a/drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c
+++ b/drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c
@@ -505,7 +505,7 @@ static int s5p_mfc_set_dec_frame_buffer_v6(struct s5p_mfc_ctx *ctx)
 	}
 
 	writel(ctx->inst_no, mfc_regs->instance_id);
-	s5p_mfc_hw_call_void(dev->mfc_cmds, cmd_host2risc, dev,
+	s5p_mfc_hw_call(dev->mfc_cmds, cmd_host2risc, dev,
 			S5P_FIMV_CH_INIT_BUFS_V6, NULL);
 
 	mfc_debug(2, "After setting buffers.\n");
@@ -603,7 +603,7 @@ static int s5p_mfc_set_enc_ref_buffer_v6(struct s5p_mfc_ctx *ctx)
 	}
 
 	writel(ctx->inst_no, mfc_regs->instance_id);
-	s5p_mfc_hw_call_void(dev->mfc_cmds, cmd_host2risc, dev,
+	s5p_mfc_hw_call(dev->mfc_cmds, cmd_host2risc, dev,
 			S5P_FIMV_CH_INIT_BUFS_V6, NULL);
 
 	mfc_debug_leave();
@@ -1378,7 +1378,7 @@ static int s5p_mfc_init_decode_v6(struct s5p_mfc_ctx *ctx)
 	writel(ctx->sei_fp_parse & 0x1, mfc_regs->d_sei_enable);
 
 	writel(ctx->inst_no, mfc_regs->instance_id);
-	s5p_mfc_hw_call_void(dev->mfc_cmds, cmd_host2risc, dev,
+	s5p_mfc_hw_call(dev->mfc_cmds, cmd_host2risc, dev,
 			S5P_FIMV_CH_SEQ_HEADER_V6, NULL);
 
 	mfc_debug_leave();
@@ -1393,7 +1393,7 @@ static inline void s5p_mfc_set_flush(struct s5p_mfc_ctx *ctx, int flush)
 	if (flush) {
 		dev->curr_ctx = ctx->num;
 		writel(ctx->inst_no, mfc_regs->instance_id);
-		s5p_mfc_hw_call_void(dev->mfc_cmds, cmd_host2risc, dev,
+		s5p_mfc_hw_call(dev->mfc_cmds, cmd_host2risc, dev,
 				S5P_FIMV_H2R_CMD_FLUSH_V6, NULL);
 	}
 }
@@ -1413,11 +1413,11 @@ static int s5p_mfc_decode_one_frame_v6(struct s5p_mfc_ctx *ctx,
 	 * is the last frame or not. */
 	switch (last_frame) {
 	case 0:
-		s5p_mfc_hw_call_void(dev->mfc_cmds, cmd_host2risc, dev,
+		s5p_mfc_hw_call(dev->mfc_cmds, cmd_host2risc, dev,
 				S5P_FIMV_CH_FRAME_START_V6, NULL);
 		break;
 	case 1:
-		s5p_mfc_hw_call_void(dev->mfc_cmds, cmd_host2risc, dev,
+		s5p_mfc_hw_call(dev->mfc_cmds, cmd_host2risc, dev,
 				S5P_FIMV_CH_LAST_FRAME_V6, NULL);
 		break;
 	default:
@@ -1455,7 +1455,7 @@ static int s5p_mfc_init_encode_v6(struct s5p_mfc_ctx *ctx)
 	}
 
 	writel(ctx->inst_no, mfc_regs->instance_id);
-	s5p_mfc_hw_call_void(dev->mfc_cmds, cmd_host2risc, dev,
+	s5p_mfc_hw_call(dev->mfc_cmds, cmd_host2risc, dev,
 			S5P_FIMV_CH_SEQ_HEADER_V6, NULL);
 
 	return 0;
@@ -1500,7 +1500,7 @@ static int s5p_mfc_encode_one_frame_v6(struct s5p_mfc_ctx *ctx)
 		cmd = S5P_FIMV_CH_LAST_FRAME_V6;
 
 	writel(ctx->inst_no, mfc_regs->instance_id);
-	s5p_mfc_hw_call_void(dev->mfc_cmds, cmd_host2risc, dev, cmd, NULL);
+	s5p_mfc_hw_call(dev->mfc_cmds, cmd_host2risc, dev, cmd, NULL);
 
 	mfc_debug(2, "--\n");
 
-- 
1.9.1

