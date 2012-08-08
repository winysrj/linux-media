Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.w1.samsung.com ([210.118.77.12]:30437 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752609Ab2HHJ40 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 8 Aug 2012 05:56:26 -0400
Received: from eusync3.samsung.com (mailout2.w1.samsung.com [210.118.77.12])
 by mailout2.w1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0M8F006M0KYQUP20@mailout2.w1.samsung.com> for
 linux-media@vger.kernel.org; Wed, 08 Aug 2012 10:56:50 +0100 (BST)
Received: from localhost.localdomain ([106.116.147.88])
 by eusync3.samsung.com (Oracle Communications Messaging Server 7u4-23.01
 (7.0.4.23.0) 64bit (built Aug 10 2011))
 with ESMTPA id <0M8F00FXAKXTS750@eusync3.samsung.com> for
 linux-media@vger.kernel.org; Wed, 08 Aug 2012 10:56:24 +0100 (BST)
From: Andrzej Hajda <a.hajda@samsung.com>
To: linux-media@vger.kernel.org
Cc: Marek Szyprowski <m.szyprowski@samsung.com>,
	Kamil Debski <k.debski@samsung.com>,
	Andrzej Hajda <a.hajda@samsung.com>,
	Kyungmin Park <kyungmin.park@samsung.com>
Subject: [PATCH,RESEND] v4l/s5p-mfc: added support for end of stream handling
 in MFC encoder
Date: Wed, 08 Aug 2012 11:56:02 +0200
Message-id: <1344419762-14104-1-git-send-email-a.hajda@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

s5p-mfc encoder after receiving V4L2_ENC_CMD_STOP command
will instruct MFC device to release all encoded frames.
After dequeuing last encoded frame driver will generate
V4L2_EVENT_EOS event.

Signed-off-by: Andrzej Hajda <a.hajda@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/media/video/s5p-mfc/s5p_mfc.c        |   43 +++++++++++
 drivers/media/video/s5p-mfc/s5p_mfc_common.h |    5 +-
 drivers/media/video/s5p-mfc/s5p_mfc_ctrl.c   |    8 ++-
 drivers/media/video/s5p-mfc/s5p_mfc_dec.c    |    4 +-
 drivers/media/video/s5p-mfc/s5p_mfc_enc.c    |  106 +++++++++++++++++++++-----
 drivers/media/video/s5p-mfc/s5p_mfc_opr.c    |   48 +++++++++---
 6 files changed, 178 insertions(+), 36 deletions(-)

diff --git a/drivers/media/video/s5p-mfc/s5p_mfc.c b/drivers/media/video/s5p-mfc/s5p_mfc.c
index 9bb68e7..dc9355c 100644
--- a/drivers/media/video/s5p-mfc/s5p_mfc.c
+++ b/drivers/media/video/s5p-mfc/s5p_mfc.c
@@ -19,6 +19,7 @@
 #include <linux/sched.h>
 #include <linux/slab.h>
 #include <linux/videodev2.h>
+#include <media/v4l2-event.h>
 #include <linux/workqueue.h>
 #include <media/videobuf2-core.h>
 #include "regs-mfc.h"
@@ -539,6 +540,40 @@ static void s5p_mfc_handle_init_buffers(struct s5p_mfc_ctx *ctx,
 	}
 }
 
+static void s5p_mfc_handle_stream_complete(struct s5p_mfc_ctx *ctx,
+				 unsigned int reason, unsigned int err)
+{
+	struct s5p_mfc_dev *dev = ctx->dev;
+	struct s5p_mfc_buf *mb_entry;
+
+	mfc_debug(2, "Stream completed");
+
+	s5p_mfc_clear_int_flags(dev);
+	ctx->int_type = reason;
+	ctx->int_err = err;
+	ctx->state = MFCINST_FINISHED;
+
+	spin_lock(&dev->irqlock);
+	if (!list_empty(&ctx->dst_queue)) {
+		mb_entry = list_entry(ctx->dst_queue.next, struct s5p_mfc_buf,
+									list);
+		list_del(&mb_entry->list);
+		ctx->dst_queue_cnt--;
+		vb2_set_plane_payload(mb_entry->b, 0, 0);
+		vb2_buffer_done(mb_entry->b, VB2_BUF_STATE_DONE);
+	}
+	spin_unlock(&dev->irqlock);
+
+	clear_work_bit(ctx);
+
+	if (test_and_clear_bit(0, &dev->hw_lock) == 0)
+		WARN_ON(1);
+
+	s5p_mfc_clock_off();
+	wake_up(&ctx->queue);
+	s5p_mfc_try_run(dev);
+}
+
 /* Interrupt processing */
 static irqreturn_t s5p_mfc_irq(int irq, void *priv)
 {
@@ -614,6 +649,11 @@ static irqreturn_t s5p_mfc_irq(int irq, void *priv)
 	case S5P_FIMV_R2H_CMD_INIT_BUFFERS_RET:
 		s5p_mfc_handle_init_buffers(ctx, reason, err);
 		break;
+
+	case S5P_FIMV_R2H_CMD_ENC_COMPLETE_RET:
+		s5p_mfc_handle_stream_complete(ctx, reason, err);
+		break;
+
 	default:
 		mfc_debug(2, "Unknown int reason\n");
 		s5p_mfc_clear_int_flags(dev);
@@ -882,9 +922,12 @@ static unsigned int s5p_mfc_poll(struct file *file,
 		goto end;
 	}
 	mutex_unlock(&dev->mfc_mutex);
+	poll_wait(file, &ctx->fh.wait, wait);
 	poll_wait(file, &src_q->done_wq, wait);
 	poll_wait(file, &dst_q->done_wq, wait);
 	mutex_lock(&dev->mfc_mutex);
+	if (v4l2_event_pending(&ctx->fh))
+		rc |= POLLPRI;
 	spin_lock_irqsave(&src_q->done_lock, flags);
 	if (!list_empty(&src_q->done_list))
 		src_vb = list_first_entry(&src_q->done_list, struct vb2_buffer,
diff --git a/drivers/media/video/s5p-mfc/s5p_mfc_common.h b/drivers/media/video/s5p-mfc/s5p_mfc_common.h
index bd5706a..8871f0d 100644
--- a/drivers/media/video/s5p-mfc/s5p_mfc_common.h
+++ b/drivers/media/video/s5p-mfc/s5p_mfc_common.h
@@ -146,6 +146,9 @@ enum s5p_mfc_decode_arg {
 	MFC_DEC_RES_CHANGE,
 };
 
+#define MFC_BUF_FLAG_USED	(1 << 0)
+#define MFC_BUF_FLAG_EOS	(1 << 1)
+
 struct s5p_mfc_ctx;
 
 /**
@@ -161,7 +164,7 @@ struct s5p_mfc_buf {
 		} raw;
 		size_t stream;
 	} cookie;
-	int used;
+	int flags;
 };
 
 /**
diff --git a/drivers/media/video/s5p-mfc/s5p_mfc_ctrl.c b/drivers/media/video/s5p-mfc/s5p_mfc_ctrl.c
index 08a5cfe..84c5b8f 100644
--- a/drivers/media/video/s5p-mfc/s5p_mfc_ctrl.c
+++ b/drivers/media/video/s5p-mfc/s5p_mfc_ctrl.c
@@ -78,7 +78,7 @@ int s5p_mfc_alloc_and_load_firmware(struct s5p_mfc_dev *dev)
 	}
 	dev->bank1 = s5p_mfc_bitproc_phys;
 	b_base = vb2_dma_contig_memops.alloc(
-		dev->alloc_ctx[MFC_BANK2_ALLOC_CTX], 1 << MFC_BANK2_ALIGN_ORDER);
+		dev->alloc_ctx[MFC_BANK2_ALLOC_CTX], 1 << MFC_BASE_ALIGN_ORDER);
 	if (IS_ERR(b_base)) {
 		vb2_dma_contig_memops.put(s5p_mfc_bitproc_buf);
 		s5p_mfc_bitproc_phys = 0;
@@ -98,7 +98,11 @@ int s5p_mfc_alloc_and_load_firmware(struct s5p_mfc_dev *dev)
 		release_firmware(fw_blob);
 		return -EIO;
 	}
-	dev->bank2 = bank2_base_phys;
+	/* Valid buffers passed to MFC encoder with LAST_FRAME command
+	 * should not have address of bank2 - MFC will treat it as a null frame.
+	 * To avoid such situation we set bank2 address below the pool address.
+	 */
+	dev->bank2 = bank2_base_phys - (1 << MFC_BASE_ALIGN_ORDER);
 	memcpy(s5p_mfc_bitproc_virt, fw_blob->data, fw_blob->size);
 	wmb();
 	release_firmware(fw_blob);
diff --git a/drivers/media/video/s5p-mfc/s5p_mfc_dec.c b/drivers/media/video/s5p-mfc/s5p_mfc_dec.c
index c5d567f..65be806 100644
--- a/drivers/media/video/s5p-mfc/s5p_mfc_dec.c
+++ b/drivers/media/video/s5p-mfc/s5p_mfc_dec.c
@@ -936,14 +936,14 @@ static void s5p_mfc_buf_queue(struct vb2_buffer *vb)
 
 	if (vq->type == V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE) {
 		mfc_buf = &ctx->src_bufs[vb->v4l2_buf.index];
-		mfc_buf->used = 0;
+		mfc_buf->flags &= ~MFC_BUF_FLAG_USED;
 		spin_lock_irqsave(&dev->irqlock, flags);
 		list_add_tail(&mfc_buf->list, &ctx->src_queue);
 		ctx->src_queue_cnt++;
 		spin_unlock_irqrestore(&dev->irqlock, flags);
 	} else if (vq->type == V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE) {
 		mfc_buf = &ctx->dst_bufs[vb->v4l2_buf.index];
-		mfc_buf->used = 0;
+		mfc_buf->flags &= ~MFC_BUF_FLAG_USED;
 		/* Mark destination as available for use by MFC */
 		spin_lock_irqsave(&dev->irqlock, flags);
 		set_bit(vb->v4l2_buf.index, &ctx->dec_dst_flag);
diff --git a/drivers/media/video/s5p-mfc/s5p_mfc_enc.c b/drivers/media/video/s5p-mfc/s5p_mfc_enc.c
index aa1c244..602bc7d 100644
--- a/drivers/media/video/s5p-mfc/s5p_mfc_enc.c
+++ b/drivers/media/video/s5p-mfc/s5p_mfc_enc.c
@@ -21,6 +21,7 @@
 #include <linux/sched.h>
 #include <linux/version.h>
 #include <linux/videodev2.h>
+#include <media/v4l2-event.h>
 #include <linux/workqueue.h>
 #include <media/v4l2-ctrls.h>
 #include <media/videobuf2-core.h>
@@ -576,9 +577,9 @@ static int s5p_mfc_ctx_ready(struct s5p_mfc_ctx *ctx)
 	if (ctx->state == MFCINST_RUNNING &&
 		ctx->src_queue_cnt >= 1 && ctx->dst_queue_cnt >= 1)
 		return 1;
-	/* context is ready to encode remain frames */
+	/* context is ready to encode remaining frames */
 	if (ctx->state == MFCINST_FINISHING &&
-		ctx->src_queue_cnt >= 1 && ctx->dst_queue_cnt >= 1)
+		ctx->dst_queue_cnt >= 1)
 		return 1;
 	mfc_debug(2, "ctx is not ready\n");
 	return 0;
@@ -724,7 +725,7 @@ static int enc_post_frame_start(struct s5p_mfc_ctx *ctx)
 	if ((ctx->src_queue_cnt > 0) && (ctx->state == MFCINST_RUNNING)) {
 		mb_entry = list_entry(ctx->src_queue.next, struct s5p_mfc_buf,
 									list);
-		if (mb_entry->used) {
+		if (mb_entry->flags & MFC_BUF_FLAG_USED) {
 			list_del(&mb_entry->list);
 			ctx->src_queue_cnt--;
 			list_add_tail(&mb_entry->list, &ctx->ref_queue);
@@ -1119,27 +1120,43 @@ static int vidioc_qbuf(struct file *file, void *priv, struct v4l2_buffer *buf)
 		mfc_err("Call on QBUF after unrecoverable error\n");
 		return -EIO;
 	}
-	if (buf->type == V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE)
+	if (buf->type == V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE) {
+		if (ctx->state == MFCINST_FINISHING) {
+			mfc_err("Call on QBUF after EOS command\n");
+			return -EIO;
+		}
 		return vb2_qbuf(&ctx->vq_src, buf);
-	else if (buf->type == V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE)
+	} else if (buf->type == V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE) {
 		return vb2_qbuf(&ctx->vq_dst, buf);
+	}
 	return -EINVAL;
 }
 
 /* Dequeue a buffer */
 static int vidioc_dqbuf(struct file *file, void *priv, struct v4l2_buffer *buf)
 {
+	const struct v4l2_event ev = {
+		.type = V4L2_EVENT_EOS
+	};
 	struct s5p_mfc_ctx *ctx = fh_to_ctx(priv);
+	int ret;
 
 	if (ctx->state == MFCINST_ERROR) {
 		mfc_err("Call on DQBUF after unrecoverable error\n");
 		return -EIO;
 	}
-	if (buf->type == V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE)
-		return vb2_dqbuf(&ctx->vq_src, buf, file->f_flags & O_NONBLOCK);
-	else if (buf->type == V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE)
-		return vb2_dqbuf(&ctx->vq_dst, buf, file->f_flags & O_NONBLOCK);
-	return -EINVAL;
+	if (buf->type == V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE) {
+		ret = vb2_dqbuf(&ctx->vq_src, buf, file->f_flags & O_NONBLOCK);
+	} else if (buf->type == V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE) {
+		ret = vb2_dqbuf(&ctx->vq_dst, buf, file->f_flags & O_NONBLOCK);
+		if (ret == 0 && ctx->state == MFCINST_FINISHED
+					&& list_empty(&ctx->vq_dst.done_list))
+			v4l2_event_queue_fh(&ctx->fh, &ev);
+	} else {
+		ret = -EINVAL;
+	}
+
+	return ret;
 }
 
 /* Stream on */
@@ -1471,6 +1488,57 @@ static int vidioc_g_parm(struct file *file, void *priv,
 	return 0;
 }
 
+int vidioc_encoder_cmd(struct file *file, void *priv,
+						struct v4l2_encoder_cmd *cmd)
+{
+	struct s5p_mfc_ctx *ctx = fh_to_ctx(priv);
+	struct s5p_mfc_dev *dev = ctx->dev;
+	struct s5p_mfc_buf *buf;
+	unsigned long flags;
+
+	switch (cmd->cmd) {
+	case V4L2_ENC_CMD_STOP:
+		if (cmd->flags != 0)
+			return -EINVAL;
+
+		if (!ctx->vq_src.streaming)
+			return -EINVAL;
+
+		spin_lock_irqsave(&dev->irqlock, flags);
+		if (list_empty(&ctx->src_queue)) {
+			mfc_debug(2, "EOS: empty src queue, entering finishing state");
+			ctx->state = MFCINST_FINISHING;
+			spin_unlock_irqrestore(&dev->irqlock, flags);
+			s5p_mfc_try_run(dev);
+		} else {
+			mfc_debug(2, "EOS: marking last buffer of stream");
+			buf = list_entry(ctx->src_queue.prev,
+						struct s5p_mfc_buf, list);
+			if (buf->flags & MFC_BUF_FLAG_USED)
+				ctx->state = MFCINST_FINISHING;
+			else
+				buf->flags |= MFC_BUF_FLAG_EOS;
+			spin_unlock_irqrestore(&dev->irqlock, flags);
+		}
+		break;
+	default:
+		return -EINVAL;
+
+	}
+	return 0;
+}
+
+static int vidioc_subscribe_event(struct v4l2_fh *fh,
+					struct v4l2_event_subscription *sub)
+{
+	switch (sub->type) {
+	case V4L2_EVENT_EOS:
+		return v4l2_event_subscribe(fh, sub, 2);
+	default:
+		return -EINVAL;
+	}
+}
+
 static const struct v4l2_ioctl_ops s5p_mfc_enc_ioctl_ops = {
 	.vidioc_querycap = vidioc_querycap,
 	.vidioc_enum_fmt_vid_cap = vidioc_enum_fmt_vid_cap,
@@ -1491,6 +1559,9 @@ static const struct v4l2_ioctl_ops s5p_mfc_enc_ioctl_ops = {
 	.vidioc_streamoff = vidioc_streamoff,
 	.vidioc_s_parm = vidioc_s_parm,
 	.vidioc_g_parm = vidioc_g_parm,
+	.vidioc_encoder_cmd = vidioc_encoder_cmd,
+	.vidioc_subscribe_event = vidioc_subscribe_event,
+	.vidioc_unsubscribe_event = v4l2_event_unsubscribe,
 };
 
 static int check_vb_with_fmt(struct s5p_mfc_fmt *fmt, struct vb2_buffer *vb)
@@ -1706,7 +1777,7 @@ static void s5p_mfc_buf_queue(struct vb2_buffer *vb)
 	}
 	if (vq->type == V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE) {
 		mfc_buf = &ctx->dst_bufs[vb->v4l2_buf.index];
-		mfc_buf->used = 0;
+		mfc_buf->flags &= ~MFC_BUF_FLAG_USED;
 		/* Mark destination as available for use by MFC */
 		spin_lock_irqsave(&dev->irqlock, flags);
 		list_add_tail(&mfc_buf->list, &ctx->dst_queue);
@@ -1714,17 +1785,10 @@ static void s5p_mfc_buf_queue(struct vb2_buffer *vb)
 		spin_unlock_irqrestore(&dev->irqlock, flags);
 	} else if (vq->type == V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE) {
 		mfc_buf = &ctx->src_bufs[vb->v4l2_buf.index];
-		mfc_buf->used = 0;
+		mfc_buf->flags &= ~MFC_BUF_FLAG_USED;
 		spin_lock_irqsave(&dev->irqlock, flags);
-		if (vb->v4l2_planes[0].bytesused == 0) {
-			mfc_debug(1, "change state to FINISHING\n");
-			ctx->state = MFCINST_FINISHING;
-			vb2_buffer_done(vb, VB2_BUF_STATE_DONE);
-			cleanup_ref_queue(ctx);
-		} else {
-			list_add_tail(&mfc_buf->list, &ctx->src_queue);
-			ctx->src_queue_cnt++;
-		}
+		list_add_tail(&mfc_buf->list, &ctx->src_queue);
+		ctx->src_queue_cnt++;
 		spin_unlock_irqrestore(&dev->irqlock, flags);
 	} else {
 		mfc_err("unsupported buffer type (%d)\n", vq->type);
diff --git a/drivers/media/video/s5p-mfc/s5p_mfc_opr.c b/drivers/media/video/s5p-mfc/s5p_mfc_opr.c
index e6217cb..9986db0 100644
--- a/drivers/media/video/s5p-mfc/s5p_mfc_opr.c
+++ b/drivers/media/video/s5p-mfc/s5p_mfc_opr.c
@@ -1075,14 +1075,21 @@ int s5p_mfc_init_encode(struct s5p_mfc_ctx *ctx)
 int s5p_mfc_encode_one_frame(struct s5p_mfc_ctx *ctx)
 {
 	struct s5p_mfc_dev *dev = ctx->dev;
+	int cmd;
 	/* memory structure cur. frame */
 	if (ctx->src_fmt->fourcc == V4L2_PIX_FMT_NV12M)
 		mfc_write(dev, 0, S5P_FIMV_ENC_MAP_FOR_CUR);
 	else if (ctx->src_fmt->fourcc == V4L2_PIX_FMT_NV12MT)
 		mfc_write(dev, 3, S5P_FIMV_ENC_MAP_FOR_CUR);
 	s5p_mfc_set_shared_buffer(ctx);
-	mfc_write(dev, (S5P_FIMV_CH_FRAME_START << 16 & 0x70000) |
-		(ctx->inst_no), S5P_FIMV_SI_CH0_INST_ID);
+
+	if (ctx->state == MFCINST_FINISHING)
+		cmd = S5P_FIMV_CH_LAST_FRAME;
+	else
+		cmd = S5P_FIMV_CH_FRAME_START;
+	mfc_write(dev, ((cmd & S5P_FIMV_CH_MASK) << S5P_FIMV_CH_SHIFT)
+				| (ctx->inst_no), S5P_FIMV_SI_CH0_INST_ID);
+
 	return 0;
 }
 
@@ -1133,7 +1140,7 @@ static int s5p_mfc_run_dec_frame(struct s5p_mfc_ctx *ctx, int last_frame)
 	}
 	/* Get the next source buffer */
 	temp_vb = list_entry(ctx->src_queue.next, struct s5p_mfc_buf, list);
-	temp_vb->used = 1;
+	temp_vb->flags |= MFC_BUF_FLAG_USED;
 	s5p_mfc_set_dec_stream_buffer(ctx,
 		vb2_dma_contig_plane_dma_addr(temp_vb->b, 0), ctx->consumed_stream,
 					temp_vb->b->v4l2_planes[0].bytesused);
@@ -1160,7 +1167,7 @@ static int s5p_mfc_run_enc_frame(struct s5p_mfc_ctx *ctx)
 	unsigned int dst_size;
 
 	spin_lock_irqsave(&dev->irqlock, flags);
-	if (list_empty(&ctx->src_queue)) {
+	if (list_empty(&ctx->src_queue) && ctx->state != MFCINST_FINISHING) {
 		mfc_debug(2, "no src buffers\n");
 		spin_unlock_irqrestore(&dev->irqlock, flags);
 		return -EAGAIN;
@@ -1170,19 +1177,40 @@ static int s5p_mfc_run_enc_frame(struct s5p_mfc_ctx *ctx)
 		spin_unlock_irqrestore(&dev->irqlock, flags);
 		return -EAGAIN;
 	}
-	src_mb = list_entry(ctx->src_queue.next, struct s5p_mfc_buf, list);
-	src_mb->used = 1;
-	src_y_addr = vb2_dma_contig_plane_dma_addr(src_mb->b, 0);
-	src_c_addr = vb2_dma_contig_plane_dma_addr(src_mb->b, 1);
-	s5p_mfc_set_enc_frame_buffer(ctx, src_y_addr, src_c_addr);
+	if (list_empty(&ctx->src_queue)) {
+		/* send null frame */
+		s5p_mfc_set_enc_frame_buffer(ctx, dev->bank2, dev->bank2);
+		src_mb = NULL;
+	} else {
+		src_mb = list_entry(ctx->src_queue.next, struct s5p_mfc_buf,
+									list);
+		src_mb->flags |= MFC_BUF_FLAG_USED;
+		if (src_mb->b->v4l2_planes[0].bytesused == 0) {
+			/* send null frame */
+			s5p_mfc_set_enc_frame_buffer(ctx, dev->bank2,
+								dev->bank2);
+			ctx->state = MFCINST_FINISHING;
+		} else {
+			src_y_addr = vb2_dma_contig_plane_dma_addr(src_mb->b,
+									0);
+			src_c_addr = vb2_dma_contig_plane_dma_addr(src_mb->b,
+									1);
+			s5p_mfc_set_enc_frame_buffer(ctx, src_y_addr,
+								src_c_addr);
+			if (src_mb->flags & MFC_BUF_FLAG_EOS)
+				ctx->state = MFCINST_FINISHING;
+		}
+	}
 	dst_mb = list_entry(ctx->dst_queue.next, struct s5p_mfc_buf, list);
-	dst_mb->used = 1;
+	dst_mb->flags |= MFC_BUF_FLAG_USED;
 	dst_addr = vb2_dma_contig_plane_dma_addr(dst_mb->b, 0);
 	dst_size = vb2_plane_size(dst_mb->b, 0);
 	s5p_mfc_set_enc_stream_buffer(ctx, dst_addr, dst_size);
 	spin_unlock_irqrestore(&dev->irqlock, flags);
 	dev->curr_ctx = ctx->num;
 	s5p_mfc_clean_ctx_int_flags(ctx);
+	mfc_debug(2, "encoding buffer with index=%d state=%d",
+			src_mb ? src_mb->b->v4l2_buf.index : -1, ctx->state);
 	s5p_mfc_encode_one_frame(ctx);
 	return 0;
 }
-- 
1.7.0.4

