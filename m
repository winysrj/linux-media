Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.w1.samsung.com ([210.118.77.11]:17065 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752479AbbLBIXo (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 2 Dec 2015 03:23:44 -0500
Received: from eucpsbgm1.samsung.com (unknown [203.254.199.244])
 by mailout1.w1.samsung.com
 (Oracle Communications Messaging Server 7.0.5.31.0 64bit (built May  5 2014))
 with ESMTP id <0NYQ009F41ZHFQ00@mailout1.w1.samsung.com> for
 linux-media@vger.kernel.org; Wed, 02 Dec 2015 08:23:41 +0000 (GMT)
From: Andrzej Hajda <a.hajda@samsung.com>
To: Kamil Debski <k.debski@samsung.com>
Cc: Andrzej Hajda <a.hajda@samsung.com>,
	Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	linux-media@vger.kernel.org (open list:ARM/SAMSUNG S5P SERIES Multi
	Format Codec (MFC)...), s.nawrocki@samsung.com
Subject: [PATCH 4/6] s5p-mfc: use spinlock to protect MFC context
Date: Wed, 02 Dec 2015 09:22:31 +0100
Message-id: <1449044553-27115-5-git-send-email-a.hajda@samsung.com>
In-reply-to: <1449044553-27115-1-git-send-email-a.hajda@samsung.com>
References: <1449044553-27115-1-git-send-email-a.hajda@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

MFC driver uses dev->irqlock spinlock to protect queues only, but many context
fields requires protection also - they can be accessed concurrently
from IOCTLs and IRQ handler. The patch increases protection range of irqlock
to those fields also.

Signed-off-by: Andrzej Hajda <a.hajda@samsung.com>
---
 drivers/media/platform/s5p-mfc/s5p_mfc.c        | 15 +++------------
 drivers/media/platform/s5p-mfc/s5p_mfc_common.h |  2 +-
 drivers/media/platform/s5p-mfc/s5p_mfc_dec.c    | 13 +++++++------
 drivers/media/platform/s5p-mfc/s5p_mfc_enc.c    | 14 --------------
 drivers/media/platform/s5p-mfc/s5p_mfc_opr_v5.c | 19 -------------------
 drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c | 18 ------------------
 6 files changed, 11 insertions(+), 70 deletions(-)

diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc.c b/drivers/media/platform/s5p-mfc/s5p_mfc.c
index 79f5c81..c4d9e34 100644
--- a/drivers/media/platform/s5p-mfc/s5p_mfc.c
+++ b/drivers/media/platform/s5p-mfc/s5p_mfc.c
@@ -359,7 +359,6 @@ static void s5p_mfc_handle_frame(struct s5p_mfc_ctx *ctx,
 	unsigned int dst_frame_status;
 	unsigned int dec_frame_status;
 	struct s5p_mfc_buf *src_buf;
-	unsigned long flags;
 	unsigned int res_change;
 
 	dst_frame_status = s5p_mfc_hw_call(dev->mfc_ops, get_dspl_status, dev)
@@ -385,7 +384,6 @@ static void s5p_mfc_handle_frame(struct s5p_mfc_ctx *ctx,
 	if (ctx->dpb_flush_flag)
 		ctx->dpb_flush_flag = 0;
 
-	spin_lock_irqsave(&dev->irqlock, flags);
 	/* All frames remaining in the buffer have been extracted  */
 	if (dst_frame_status == S5P_FIMV_DEC_STATUS_DECODING_EMPTY) {
 		if (ctx->state == MFCINST_RES_CHANGE_FLUSH) {
@@ -445,7 +443,6 @@ static void s5p_mfc_handle_frame(struct s5p_mfc_ctx *ctx,
 		}
 	}
 leave_handle_frame:
-	spin_unlock_irqrestore(&dev->irqlock, flags);
 	if ((ctx->src_queue_cnt == 0 && ctx->state != MFCINST_FINISHING)
 				    || ctx->dst_queue_cnt < ctx->pb_count)
 		clear_work_bit(ctx);
@@ -464,8 +461,6 @@ leave_handle_frame:
 static void s5p_mfc_handle_error(struct s5p_mfc_dev *dev,
 		struct s5p_mfc_ctx *ctx, unsigned int reason, unsigned int err)
 {
-	unsigned long flags;
-
 	mfc_err("Interrupt Error: %08x\n", err);
 
 	if (ctx != NULL) {
@@ -482,11 +477,9 @@ static void s5p_mfc_handle_error(struct s5p_mfc_dev *dev,
 			clear_work_bit(ctx);
 			ctx->state = MFCINST_ERROR;
 			/* Mark all dst buffers as having an error */
-			spin_lock_irqsave(&dev->irqlock, flags);
 			s5p_mfc_cleanup_queue(&ctx->dst_queue, &ctx->vq_dst);
 			/* Mark all src buffers as having an error */
 			s5p_mfc_cleanup_queue(&ctx->src_queue, &ctx->vq_src);
-			spin_unlock_irqrestore(&dev->irqlock, flags);
 			wake_up_ctx(ctx, reason, err);
 			break;
 		default:
@@ -562,7 +555,6 @@ static void s5p_mfc_handle_init_buffers(struct s5p_mfc_ctx *ctx,
 {
 	struct s5p_mfc_buf *src_buf;
 	struct s5p_mfc_dev *dev;
-	unsigned long flags;
 
 	if (ctx == NULL)
 		return;
@@ -575,7 +567,6 @@ static void s5p_mfc_handle_init_buffers(struct s5p_mfc_ctx *ctx,
 	if (err == 0) {
 		ctx->state = MFCINST_RUNNING;
 		if (!ctx->dpb_flush_flag && ctx->head_processed) {
-			spin_lock_irqsave(&dev->irqlock, flags);
 			if (!list_empty(&ctx->src_queue)) {
 				src_buf = list_entry(ctx->src_queue.next,
 					     struct s5p_mfc_buf, list);
@@ -584,7 +575,6 @@ static void s5p_mfc_handle_init_buffers(struct s5p_mfc_ctx *ctx,
 				vb2_buffer_done(&src_buf->b->vb2_buf,
 						VB2_BUF_STATE_DONE);
 			}
-			spin_unlock_irqrestore(&dev->irqlock, flags);
 		} else {
 			ctx->dpb_flush_flag = 0;
 		}
@@ -612,7 +602,6 @@ static void s5p_mfc_handle_stream_complete(struct s5p_mfc_ctx *ctx)
 
 	ctx->state = MFCINST_FINISHED;
 
-	spin_lock(&dev->irqlock);
 	if (!list_empty(&ctx->dst_queue)) {
 		mb_entry = list_entry(ctx->dst_queue.next, struct s5p_mfc_buf,
 									list);
@@ -621,7 +610,6 @@ static void s5p_mfc_handle_stream_complete(struct s5p_mfc_ctx *ctx)
 		vb2_set_plane_payload(&mb_entry->b->vb2_buf, 0, 0);
 		vb2_buffer_done(&mb_entry->b->vb2_buf, VB2_BUF_STATE_DONE);
 	}
-	spin_unlock(&dev->irqlock);
 
 	clear_work_bit(ctx);
 
@@ -643,6 +631,7 @@ static irqreturn_t s5p_mfc_irq(int irq, void *priv)
 	mfc_debug_enter();
 	/* Reset the timeout watchdog */
 	atomic_set(&dev->watchdog_cnt, 0);
+	spin_lock(&dev->irqlock);
 	ctx = dev->ctx[dev->curr_ctx];
 	/* Get the reason of interrupt and the error code */
 	reason = s5p_mfc_hw_call(dev->mfc_ops, get_int_reason, dev);
@@ -734,6 +723,7 @@ static irqreturn_t s5p_mfc_irq(int irq, void *priv)
 		mfc_debug(2, "Unknown int reason\n");
 		s5p_mfc_hw_call_void(dev->mfc_ops, clear_int_flags, dev);
 	}
+	spin_unlock(&dev->irqlock);
 	mfc_debug_leave();
 	return IRQ_HANDLED;
 irq_cleanup_hw:
@@ -747,6 +737,7 @@ irq_cleanup_hw:
 	s5p_mfc_clock_off();
 
 	s5p_mfc_hw_call_void(dev->mfc_ops, try_run, dev);
+	spin_unlock(&dev->irqlock);
 	mfc_debug(2, "Exit via irq_cleanup_hw\n");
 	return IRQ_HANDLED;
 }
diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc_common.h b/drivers/media/platform/s5p-mfc/s5p_mfc_common.h
index f560240..c5c1881 100644
--- a/drivers/media/platform/s5p-mfc/s5p_mfc_common.h
+++ b/drivers/media/platform/s5p-mfc/s5p_mfc_common.h
@@ -308,7 +308,7 @@ struct s5p_mfc_dev {
 	struct s5p_mfc_pm	pm;
 	struct s5p_mfc_variant	*variant;
 	int num_inst;
-	spinlock_t irqlock;	/* lock when operating on videobuf2 queues */
+	spinlock_t irqlock;	/* lock when operating on context */
 	spinlock_t condlock;	/* lock when changing/checking if a context is
 					ready to be processed */
 	struct mutex mfc_mutex; /* video_device lock */
diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc_dec.c b/drivers/media/platform/s5p-mfc/s5p_mfc_dec.c
index c9999bb..62abf2d 100644
--- a/drivers/media/platform/s5p-mfc/s5p_mfc_dec.c
+++ b/drivers/media/platform/s5p-mfc/s5p_mfc_dec.c
@@ -1023,40 +1023,41 @@ static void s5p_mfc_stop_streaming(struct vb2_queue *q)
 	struct s5p_mfc_dev *dev = ctx->dev;
 	int aborted = 0;
 
+	spin_lock_irqsave(&dev->irqlock, flags);
 	if ((ctx->state == MFCINST_FINISHING ||
 		ctx->state ==  MFCINST_RUNNING) &&
 		dev->curr_ctx == ctx->num && dev->hw_lock) {
 		ctx->state = MFCINST_ABORT;
+		spin_unlock_irqrestore(&dev->irqlock, flags);
 		s5p_mfc_wait_for_done_ctx(ctx,
 					S5P_MFC_R2H_CMD_FRAME_DONE_RET, 0);
 		aborted = 1;
+		spin_lock_irqsave(&dev->irqlock, flags);
 	}
 	if (q->type == V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE) {
-		spin_lock_irqsave(&dev->irqlock, flags);
 		s5p_mfc_cleanup_queue(&ctx->dst_queue, &ctx->vq_dst);
 		INIT_LIST_HEAD(&ctx->dst_queue);
 		ctx->dst_queue_cnt = 0;
 		ctx->dpb_flush_flag = 1;
 		ctx->dec_dst_flag = 0;
-		spin_unlock_irqrestore(&dev->irqlock, flags);
 		if (IS_MFCV6_PLUS(dev) && (ctx->state == MFCINST_RUNNING)) {
 			ctx->state = MFCINST_FLUSH;
 			set_work_bit_irqsave(ctx);
 			s5p_mfc_hw_call_void(dev->mfc_ops, try_run, dev);
+			spin_unlock_irqrestore(&dev->irqlock, flags);
 			if (s5p_mfc_wait_for_done_ctx(ctx,
 				S5P_MFC_R2H_CMD_DPB_FLUSH_RET, 0))
 				mfc_err("Err flushing buffers\n");
+			spin_lock_irqsave(&dev->irqlock, flags);
 		}
-	}
-	if (q->type == V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE) {
-		spin_lock_irqsave(&dev->irqlock, flags);
+	} else if (q->type == V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE) {
 		s5p_mfc_cleanup_queue(&ctx->src_queue, &ctx->vq_src);
 		INIT_LIST_HEAD(&ctx->src_queue);
 		ctx->src_queue_cnt = 0;
-		spin_unlock_irqrestore(&dev->irqlock, flags);
 	}
 	if (aborted)
 		ctx->state = MFCINST_RUNNING;
+	spin_unlock_irqrestore(&dev->irqlock, flags);
 }
 
 
diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc_enc.c b/drivers/media/platform/s5p-mfc/s5p_mfc_enc.c
index 58008b0..434bcd0 100644
--- a/drivers/media/platform/s5p-mfc/s5p_mfc_enc.c
+++ b/drivers/media/platform/s5p-mfc/s5p_mfc_enc.c
@@ -769,15 +769,12 @@ static int enc_pre_seq_start(struct s5p_mfc_ctx *ctx)
 	struct s5p_mfc_buf *dst_mb;
 	unsigned long dst_addr;
 	unsigned int dst_size;
-	unsigned long flags;
 
-	spin_lock_irqsave(&dev->irqlock, flags);
 	dst_mb = list_entry(ctx->dst_queue.next, struct s5p_mfc_buf, list);
 	dst_addr = vb2_dma_contig_plane_dma_addr(&dst_mb->b->vb2_buf, 0);
 	dst_size = vb2_plane_size(&dst_mb->b->vb2_buf, 0);
 	s5p_mfc_hw_call_void(dev->mfc_ops, set_enc_stream_buffer, ctx, dst_addr,
 			dst_size);
-	spin_unlock_irqrestore(&dev->irqlock, flags);
 	return 0;
 }
 
@@ -786,11 +783,9 @@ static int enc_post_seq_start(struct s5p_mfc_ctx *ctx)
 	struct s5p_mfc_dev *dev = ctx->dev;
 	struct s5p_mfc_enc_params *p = &ctx->enc_params;
 	struct s5p_mfc_buf *dst_mb;
-	unsigned long flags;
 	unsigned int enc_pb_count;
 
 	if (p->seq_hdr_mode == V4L2_MPEG_VIDEO_HEADER_MODE_SEPARATE) {
-		spin_lock_irqsave(&dev->irqlock, flags);
 		if (!list_empty(&ctx->dst_queue)) {
 			dst_mb = list_entry(ctx->dst_queue.next,
 					struct s5p_mfc_buf, list);
@@ -802,7 +797,6 @@ static int enc_post_seq_start(struct s5p_mfc_ctx *ctx)
 			vb2_buffer_done(&dst_mb->b->vb2_buf,
 					VB2_BUF_STATE_DONE);
 		}
-		spin_unlock_irqrestore(&dev->irqlock, flags);
 	}
 
 	if (!IS_MFCV6_PLUS(dev)) {
@@ -826,25 +820,20 @@ static int enc_pre_frame_start(struct s5p_mfc_ctx *ctx)
 	struct s5p_mfc_dev *dev = ctx->dev;
 	struct s5p_mfc_buf *dst_mb;
 	struct s5p_mfc_buf *src_mb;
-	unsigned long flags;
 	unsigned long src_y_addr, src_c_addr, dst_addr;
 	unsigned int dst_size;
 
-	spin_lock_irqsave(&dev->irqlock, flags);
 	src_mb = list_entry(ctx->src_queue.next, struct s5p_mfc_buf, list);
 	src_y_addr = vb2_dma_contig_plane_dma_addr(&src_mb->b->vb2_buf, 0);
 	src_c_addr = vb2_dma_contig_plane_dma_addr(&src_mb->b->vb2_buf, 1);
 	s5p_mfc_hw_call_void(dev->mfc_ops, set_enc_frame_buffer, ctx,
 							src_y_addr, src_c_addr);
-	spin_unlock_irqrestore(&dev->irqlock, flags);
 
-	spin_lock_irqsave(&dev->irqlock, flags);
 	dst_mb = list_entry(ctx->dst_queue.next, struct s5p_mfc_buf, list);
 	dst_addr = vb2_dma_contig_plane_dma_addr(&dst_mb->b->vb2_buf, 0);
 	dst_size = vb2_plane_size(&dst_mb->b->vb2_buf, 0);
 	s5p_mfc_hw_call_void(dev->mfc_ops, set_enc_stream_buffer, ctx, dst_addr,
 			dst_size);
-	spin_unlock_irqrestore(&dev->irqlock, flags);
 
 	return 0;
 }
@@ -857,7 +846,6 @@ static int enc_post_frame_start(struct s5p_mfc_ctx *ctx)
 	unsigned long mb_y_addr, mb_c_addr;
 	int slice_type;
 	unsigned int strm_size;
-	unsigned long flags;
 
 	slice_type = s5p_mfc_hw_call(dev->mfc_ops, get_enc_slice_type, dev);
 	strm_size = s5p_mfc_hw_call(dev->mfc_ops, get_enc_strm_size, dev);
@@ -865,7 +853,6 @@ static int enc_post_frame_start(struct s5p_mfc_ctx *ctx)
 	mfc_debug(2, "Encoded stream size: %d\n", strm_size);
 	mfc_debug(2, "Display order: %d\n",
 		  mfc_read(dev, S5P_FIMV_ENC_SI_PIC_CNT));
-	spin_lock_irqsave(&dev->irqlock, flags);
 	if (slice_type >= 0) {
 		s5p_mfc_hw_call_void(dev->mfc_ops, get_enc_frame_buffer, ctx,
 				&enc_y_addr, &enc_c_addr);
@@ -929,7 +916,6 @@ static int enc_post_frame_start(struct s5p_mfc_ctx *ctx)
 		vb2_set_plane_payload(&mb_entry->b->vb2_buf, 0, strm_size);
 		vb2_buffer_done(&mb_entry->b->vb2_buf, VB2_BUF_STATE_DONE);
 	}
-	spin_unlock_irqrestore(&dev->irqlock, flags);
 	if ((ctx->src_queue_cnt == 0) || (ctx->dst_queue_cnt == 0))
 		clear_work_bit(ctx);
 
diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc_opr_v5.c b/drivers/media/platform/s5p-mfc/s5p_mfc_opr_v5.c
index 8754b7e..81e1e4c 100644
--- a/drivers/media/platform/s5p-mfc/s5p_mfc_opr_v5.c
+++ b/drivers/media/platform/s5p-mfc/s5p_mfc_opr_v5.c
@@ -1166,7 +1166,6 @@ static int s5p_mfc_run_dec_frame(struct s5p_mfc_ctx *ctx, int last_frame)
 {
 	struct s5p_mfc_dev *dev = ctx->dev;
 	struct s5p_mfc_buf *temp_vb;
-	unsigned long flags;
 
 	if (ctx->state == MFCINST_FINISHING) {
 		last_frame = MFC_DEC_LAST_FRAME;
@@ -1176,11 +1175,9 @@ static int s5p_mfc_run_dec_frame(struct s5p_mfc_ctx *ctx, int last_frame)
 		return 0;
 	}
 
-	spin_lock_irqsave(&dev->irqlock, flags);
 	/* Frames are being decoded */
 	if (list_empty(&ctx->src_queue)) {
 		mfc_debug(2, "No src buffers\n");
-		spin_unlock_irqrestore(&dev->irqlock, flags);
 		return -EAGAIN;
 	}
 	/* Get the next source buffer */
@@ -1189,7 +1186,6 @@ static int s5p_mfc_run_dec_frame(struct s5p_mfc_ctx *ctx, int last_frame)
 	s5p_mfc_set_dec_stream_buffer_v5(ctx,
 		vb2_dma_contig_plane_dma_addr(&temp_vb->b->vb2_buf, 0),
 		ctx->consumed_stream, temp_vb->b->vb2_buf.planes[0].bytesused);
-	spin_unlock_irqrestore(&dev->irqlock, flags);
 	dev->curr_ctx = ctx->num;
 	if (temp_vb->b->vb2_buf.planes[0].bytesused == 0) {
 		last_frame = MFC_DEC_LAST_FRAME;
@@ -1203,21 +1199,17 @@ static int s5p_mfc_run_dec_frame(struct s5p_mfc_ctx *ctx, int last_frame)
 static int s5p_mfc_run_enc_frame(struct s5p_mfc_ctx *ctx)
 {
 	struct s5p_mfc_dev *dev = ctx->dev;
-	unsigned long flags;
 	struct s5p_mfc_buf *dst_mb;
 	struct s5p_mfc_buf *src_mb;
 	unsigned long src_y_addr, src_c_addr, dst_addr;
 	unsigned int dst_size;
 
-	spin_lock_irqsave(&dev->irqlock, flags);
 	if (list_empty(&ctx->src_queue) && ctx->state != MFCINST_FINISHING) {
 		mfc_debug(2, "no src buffers\n");
-		spin_unlock_irqrestore(&dev->irqlock, flags);
 		return -EAGAIN;
 	}
 	if (list_empty(&ctx->dst_queue)) {
 		mfc_debug(2, "no dst buffers\n");
-		spin_unlock_irqrestore(&dev->irqlock, flags);
 		return -EAGAIN;
 	}
 	if (list_empty(&ctx->src_queue)) {
@@ -1249,7 +1241,6 @@ static int s5p_mfc_run_enc_frame(struct s5p_mfc_ctx *ctx)
 	dst_addr = vb2_dma_contig_plane_dma_addr(&dst_mb->b->vb2_buf, 0);
 	dst_size = vb2_plane_size(&dst_mb->b->vb2_buf, 0);
 	s5p_mfc_set_enc_stream_buffer_v5(ctx, dst_addr, dst_size);
-	spin_unlock_irqrestore(&dev->irqlock, flags);
 	dev->curr_ctx = ctx->num;
 	mfc_debug(2, "encoding buffer with index=%d state=%d\n",
 		  src_mb ? src_mb->b->vb2_buf.index : -1, ctx->state);
@@ -1260,11 +1251,9 @@ static int s5p_mfc_run_enc_frame(struct s5p_mfc_ctx *ctx)
 static void s5p_mfc_run_init_dec(struct s5p_mfc_ctx *ctx)
 {
 	struct s5p_mfc_dev *dev = ctx->dev;
-	unsigned long flags;
 	struct s5p_mfc_buf *temp_vb;
 
 	/* Initializing decoding - parsing header */
-	spin_lock_irqsave(&dev->irqlock, flags);
 	mfc_debug(2, "Preparing to init decoding\n");
 	temp_vb = list_entry(ctx->src_queue.next, struct s5p_mfc_buf, list);
 	s5p_mfc_set_dec_desc_buffer(ctx);
@@ -1273,7 +1262,6 @@ static void s5p_mfc_run_init_dec(struct s5p_mfc_ctx *ctx)
 	s5p_mfc_set_dec_stream_buffer_v5(ctx,
 			vb2_dma_contig_plane_dma_addr(&temp_vb->b->vb2_buf, 0),
 			0, temp_vb->b->vb2_buf.planes[0].bytesused);
-	spin_unlock_irqrestore(&dev->irqlock, flags);
 	dev->curr_ctx = ctx->num;
 	s5p_mfc_init_decode_v5(ctx);
 }
@@ -1281,18 +1269,15 @@ static void s5p_mfc_run_init_dec(struct s5p_mfc_ctx *ctx)
 static void s5p_mfc_run_init_enc(struct s5p_mfc_ctx *ctx)
 {
 	struct s5p_mfc_dev *dev = ctx->dev;
-	unsigned long flags;
 	struct s5p_mfc_buf *dst_mb;
 	unsigned long dst_addr;
 	unsigned int dst_size;
 
 	s5p_mfc_set_enc_ref_buffer_v5(ctx);
-	spin_lock_irqsave(&dev->irqlock, flags);
 	dst_mb = list_entry(ctx->dst_queue.next, struct s5p_mfc_buf, list);
 	dst_addr = vb2_dma_contig_plane_dma_addr(&dst_mb->b->vb2_buf, 0);
 	dst_size = vb2_plane_size(&dst_mb->b->vb2_buf, 0);
 	s5p_mfc_set_enc_stream_buffer_v5(ctx, dst_addr, dst_size);
-	spin_unlock_irqrestore(&dev->irqlock, flags);
 	dev->curr_ctx = ctx->num;
 	s5p_mfc_init_encode_v5(ctx);
 }
@@ -1300,7 +1285,6 @@ static void s5p_mfc_run_init_enc(struct s5p_mfc_ctx *ctx)
 static int s5p_mfc_run_init_dec_buffers(struct s5p_mfc_ctx *ctx)
 {
 	struct s5p_mfc_dev *dev = ctx->dev;
-	unsigned long flags;
 	struct s5p_mfc_buf *temp_vb;
 	int ret;
 
@@ -1314,11 +1298,9 @@ static int s5p_mfc_run_init_dec_buffers(struct s5p_mfc_ctx *ctx)
 			"before starting processing\n");
 		return -EAGAIN;
 	}
-	spin_lock_irqsave(&dev->irqlock, flags);
 	if (list_empty(&ctx->src_queue)) {
 		mfc_err("Header has been deallocated in the middle of"
 			" initialization\n");
-		spin_unlock_irqrestore(&dev->irqlock, flags);
 		return -EIO;
 	}
 	temp_vb = list_entry(ctx->src_queue.next, struct s5p_mfc_buf, list);
@@ -1327,7 +1309,6 @@ static int s5p_mfc_run_init_dec_buffers(struct s5p_mfc_ctx *ctx)
 	s5p_mfc_set_dec_stream_buffer_v5(ctx,
 			vb2_dma_contig_plane_dma_addr(&temp_vb->b->vb2_buf, 0),
 			0, temp_vb->b->vb2_buf.planes[0].bytesused);
-	spin_unlock_irqrestore(&dev->irqlock, flags);
 	dev->curr_ctx = ctx->num;
 	ret = s5p_mfc_set_dec_frame_buffer_v5(ctx);
 	if (ret) {
diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c b/drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c
index 764a675..2a9ca428 100644
--- a/drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c
+++ b/drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c
@@ -1520,7 +1520,6 @@ static inline int s5p_mfc_run_dec_frame(struct s5p_mfc_ctx *ctx)
 {
 	struct s5p_mfc_dev *dev = ctx->dev;
 	struct s5p_mfc_buf *temp_vb;
-	unsigned long flags;
 	int last_frame = 0;
 
 	if (ctx->state == MFCINST_FINISHING) {
@@ -1532,11 +1531,9 @@ static inline int s5p_mfc_run_dec_frame(struct s5p_mfc_ctx *ctx)
 		return 0;
 	}
 
-	spin_lock_irqsave(&dev->irqlock, flags);
 	/* Frames are being decoded */
 	if (list_empty(&ctx->src_queue)) {
 		mfc_debug(2, "No src buffers.\n");
-		spin_unlock_irqrestore(&dev->irqlock, flags);
 		return -EAGAIN;
 	}
 	/* Get the next source buffer */
@@ -1546,7 +1543,6 @@ static inline int s5p_mfc_run_dec_frame(struct s5p_mfc_ctx *ctx)
 		vb2_dma_contig_plane_dma_addr(&temp_vb->b->vb2_buf, 0),
 			ctx->consumed_stream,
 			temp_vb->b->vb2_buf.planes[0].bytesused);
-	spin_unlock_irqrestore(&dev->irqlock, flags);
 
 	dev->curr_ctx = ctx->num;
 	if (temp_vb->b->vb2_buf.planes[0].bytesused == 0) {
@@ -1562,7 +1558,6 @@ static inline int s5p_mfc_run_dec_frame(struct s5p_mfc_ctx *ctx)
 static inline int s5p_mfc_run_enc_frame(struct s5p_mfc_ctx *ctx)
 {
 	struct s5p_mfc_dev *dev = ctx->dev;
-	unsigned long flags;
 	struct s5p_mfc_buf *dst_mb;
 	struct s5p_mfc_buf *src_mb;
 	unsigned long src_y_addr, src_c_addr, dst_addr;
@@ -1571,17 +1566,13 @@ static inline int s5p_mfc_run_enc_frame(struct s5p_mfc_ctx *ctx)
 	*/
 	unsigned int dst_size;
 
-	spin_lock_irqsave(&dev->irqlock, flags);
-
 	if (list_empty(&ctx->src_queue) && ctx->state != MFCINST_FINISHING) {
 		mfc_debug(2, "no src buffers.\n");
-		spin_unlock_irqrestore(&dev->irqlock, flags);
 		return -EAGAIN;
 	}
 
 	if (list_empty(&ctx->dst_queue)) {
 		mfc_debug(2, "no dst buffers.\n");
-		spin_unlock_irqrestore(&dev->irqlock, flags);
 		return -EAGAIN;
 	}
 
@@ -1615,8 +1606,6 @@ static inline int s5p_mfc_run_enc_frame(struct s5p_mfc_ctx *ctx)
 
 	s5p_mfc_set_enc_stream_buffer_v6(ctx, dst_addr, dst_size);
 
-	spin_unlock_irqrestore(&dev->irqlock, flags);
-
 	dev->curr_ctx = ctx->num;
 	s5p_mfc_encode_one_frame_v6(ctx);
 
@@ -1626,18 +1615,15 @@ static inline int s5p_mfc_run_enc_frame(struct s5p_mfc_ctx *ctx)
 static inline void s5p_mfc_run_init_dec(struct s5p_mfc_ctx *ctx)
 {
 	struct s5p_mfc_dev *dev = ctx->dev;
-	unsigned long flags;
 	struct s5p_mfc_buf *temp_vb;
 
 	/* Initializing decoding - parsing header */
-	spin_lock_irqsave(&dev->irqlock, flags);
 	mfc_debug(2, "Preparing to init decoding.\n");
 	temp_vb = list_entry(ctx->src_queue.next, struct s5p_mfc_buf, list);
 	mfc_debug(2, "Header size: %d\n", temp_vb->b->vb2_buf.planes[0].bytesused);
 	s5p_mfc_set_dec_stream_buffer_v6(ctx,
 		vb2_dma_contig_plane_dma_addr(&temp_vb->b->vb2_buf, 0), 0,
 			temp_vb->b->vb2_buf.planes[0].bytesused);
-	spin_unlock_irqrestore(&dev->irqlock, flags);
 	dev->curr_ctx = ctx->num;
 	s5p_mfc_init_decode_v6(ctx);
 }
@@ -1645,18 +1631,14 @@ static inline void s5p_mfc_run_init_dec(struct s5p_mfc_ctx *ctx)
 static inline void s5p_mfc_run_init_enc(struct s5p_mfc_ctx *ctx)
 {
 	struct s5p_mfc_dev *dev = ctx->dev;
-	unsigned long flags;
 	struct s5p_mfc_buf *dst_mb;
 	unsigned long dst_addr;
 	unsigned int dst_size;
 
-	spin_lock_irqsave(&dev->irqlock, flags);
-
 	dst_mb = list_entry(ctx->dst_queue.next, struct s5p_mfc_buf, list);
 	dst_addr = vb2_dma_contig_plane_dma_addr(&dst_mb->b->vb2_buf, 0);
 	dst_size = vb2_plane_size(&dst_mb->b->vb2_buf, 0);
 	s5p_mfc_set_enc_stream_buffer_v6(ctx, dst_addr, dst_size);
-	spin_unlock_irqrestore(&dev->irqlock, flags);
 	dev->curr_ctx = ctx->num;
 	s5p_mfc_init_encode_v6(ctx);
 }
-- 
1.9.1

