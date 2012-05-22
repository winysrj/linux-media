Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.w1.samsung.com ([210.118.77.11]:27056 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932176Ab2EVPeM (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 22 May 2012 11:34:12 -0400
Received: from euspt1 (mailout1.w1.samsung.com [210.118.77.11])
 by mailout1.w1.samsung.com
 (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14 2004))
 with ESMTP id <0M4F00JR4KH2EP@mailout1.w1.samsung.com> for
 linux-media@vger.kernel.org; Tue, 22 May 2012 16:31:50 +0100 (BST)
Received: from linux.samsung.com ([106.116.38.10])
 by spt1.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0M4F00IBEKKW1X@spt1.w1.samsung.com> for
 linux-media@vger.kernel.org; Tue, 22 May 2012 16:34:08 +0100 (BST)
Date: Tue, 22 May 2012 17:33:55 +0200
From: Andrzej Hajda <a.hajda@samsung.com>
Subject: [PATCH 2/2] s5p-mfc: added encoder support for end of stream handling
In-reply-to: <1337700835-13634-1-git-send-email-a.hajda@samsung.com>
To: linux-media@vger.kernel.org
Cc: hans.verkuil@cisco.com, m.szyprowski@samsung.com,
	k.debski@samsung.com, a.hajda@samsung.com
Message-id: <1337700835-13634-3-git-send-email-a.hajda@samsung.com>
MIME-version: 1.0
Content-type: TEXT/PLAIN
Content-transfer-encoding: 7BIT
References: <1337700835-13634-1-git-send-email-a.hajda@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

s5p-mfc encoder after receiving buffer with flag V4L2_BUF_FLAG_EOS
will put all buffers cached in device into capture queue.
It will indicate end of encoded stream by providing empty buffer.

Signed-off-by: Andrzej Hajda <a.hajda@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/media/video/s5p-mfc/s5p_mfc.c     |   44 +++++++++++++++++++++++++++++
 drivers/media/video/s5p-mfc/s5p_mfc_enc.c |   13 ++------
 drivers/media/video/s5p-mfc/s5p_mfc_opr.c |   33 ++++++++++++++++-----
 3 files changed, 72 insertions(+), 18 deletions(-)

diff --git a/drivers/media/video/s5p-mfc/s5p_mfc.c b/drivers/media/video/s5p-mfc/s5p_mfc.c
index 9bb68e7..fed8f55 100644
--- a/drivers/media/video/s5p-mfc/s5p_mfc.c
+++ b/drivers/media/video/s5p-mfc/s5p_mfc.c
@@ -539,6 +539,45 @@ static void s5p_mfc_handle_init_buffers(struct s5p_mfc_ctx *ctx,
 	}
 }
 
+static void s5p_mfc_handle_complete(struct s5p_mfc_ctx *ctx,
+				 unsigned int reason, unsigned int err)
+{
+	struct s5p_mfc_dev *dev = ctx->dev;
+	struct s5p_mfc_buf *mb_entry;
+	unsigned long flags;
+
+	mfc_debug(2, "Stream completed");
+
+	s5p_mfc_clear_int_flags(dev);
+	ctx->int_type = reason;
+	ctx->int_err = err;
+
+	spin_lock_irqsave(&dev->irqlock, flags);
+	ctx->state = MFCINST_FINISHED;
+
+	if (!list_empty(&ctx->dst_queue)) {
+		mb_entry = list_entry(ctx->dst_queue.next, struct s5p_mfc_buf,
+									list);
+		list_del(&mb_entry->list);
+		ctx->dst_queue_cnt--;
+		vb2_set_plane_payload(mb_entry->b, 0, 0);
+		vb2_buffer_done(mb_entry->b, VB2_BUF_STATE_DONE);
+	}
+
+	spin_unlock_irqrestore(&dev->irqlock, flags);
+	if (ctx->dst_queue_cnt == 0) {
+		spin_lock(&dev->condlock);
+		clear_bit(ctx->num, &dev->ctx_work_bits);
+		spin_unlock(&dev->condlock);
+	}
+
+	if (test_and_clear_bit(0, &dev->hw_lock) == 0)
+		BUG();
+
+	s5p_mfc_clock_off();
+	wake_up(&ctx->queue);
+}
+
 /* Interrupt processing */
 static irqreturn_t s5p_mfc_irq(int irq, void *priv)
 {
@@ -614,6 +653,11 @@ static irqreturn_t s5p_mfc_irq(int irq, void *priv)
 	case S5P_FIMV_R2H_CMD_INIT_BUFFERS_RET:
 		s5p_mfc_handle_init_buffers(ctx, reason, err);
 		break;
+
+	case S5P_FIMV_R2H_CMD_ENC_COMPLETE_RET:
+		s5p_mfc_handle_complete(ctx, reason, err);
+		break;
+
 	default:
 		mfc_debug(2, "Unknown int reason\n");
 		s5p_mfc_clear_int_flags(dev);
diff --git a/drivers/media/video/s5p-mfc/s5p_mfc_enc.c b/drivers/media/video/s5p-mfc/s5p_mfc_enc.c
index acedb20..8dec186 100644
--- a/drivers/media/video/s5p-mfc/s5p_mfc_enc.c
+++ b/drivers/media/video/s5p-mfc/s5p_mfc_enc.c
@@ -584,7 +584,7 @@ static int s5p_mfc_ctx_ready(struct s5p_mfc_ctx *ctx)
 		return 1;
 	/* context is ready to encode remain frames */
 	if (ctx->state == MFCINST_FINISHING &&
-		ctx->src_queue_cnt >= 1 && ctx->dst_queue_cnt >= 1)
+		ctx->dst_queue_cnt >= 1)
 		return 1;
 	mfc_debug(2, "ctx is not ready\n");
 	return 0;
@@ -1715,15 +1715,8 @@ static void s5p_mfc_buf_queue(struct vb2_buffer *vb)
 		mfc_buf = &ctx->src_bufs[vb->v4l2_buf.index];
 		mfc_buf->used = 0;
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
index e6217cb..4bcf93f 100644
--- a/drivers/media/video/s5p-mfc/s5p_mfc_opr.c
+++ b/drivers/media/video/s5p-mfc/s5p_mfc_opr.c
@@ -1081,8 +1081,14 @@ int s5p_mfc_encode_one_frame(struct s5p_mfc_ctx *ctx)
 	else if (ctx->src_fmt->fourcc == V4L2_PIX_FMT_NV12MT)
 		mfc_write(dev, 3, S5P_FIMV_ENC_MAP_FOR_CUR);
 	s5p_mfc_set_shared_buffer(ctx);
-	mfc_write(dev, (S5P_FIMV_CH_FRAME_START << 16 & 0x70000) |
-		(ctx->inst_no), S5P_FIMV_SI_CH0_INST_ID);
+
+	if (ctx->state == MFCINST_FINISHING)
+		mfc_write(dev, ((S5P_FIMV_CH_LAST_FRAME & S5P_FIMV_CH_MASK) <<
+		S5P_FIMV_CH_SHIFT) | (ctx->inst_no), S5P_FIMV_SI_CH0_INST_ID);
+	else
+		mfc_write(dev, ((S5P_FIMV_CH_FRAME_START & S5P_FIMV_CH_MASK) <<
+		S5P_FIMV_CH_SHIFT) | (ctx->inst_no), S5P_FIMV_SI_CH0_INST_ID);
+
 	return 0;
 }
 
@@ -1160,7 +1166,7 @@ static int s5p_mfc_run_enc_frame(struct s5p_mfc_ctx *ctx)
 	unsigned int dst_size;
 
 	spin_lock_irqsave(&dev->irqlock, flags);
-	if (list_empty(&ctx->src_queue)) {
+	if (list_empty(&ctx->src_queue) && ctx->state != MFCINST_FINISHING) {
 		mfc_debug(2, "no src buffers\n");
 		spin_unlock_irqrestore(&dev->irqlock, flags);
 		return -EAGAIN;
@@ -1170,11 +1176,18 @@ static int s5p_mfc_run_enc_frame(struct s5p_mfc_ctx *ctx)
 		spin_unlock_irqrestore(&dev->irqlock, flags);
 		return -EAGAIN;
 	}
-	src_mb = list_entry(ctx->src_queue.next, struct s5p_mfc_buf, list);
-	src_mb->used = 1;
-	src_y_addr = vb2_dma_contig_plane_dma_addr(src_mb->b, 0);
-	src_c_addr = vb2_dma_contig_plane_dma_addr(src_mb->b, 1);
-	s5p_mfc_set_enc_frame_buffer(ctx, src_y_addr, src_c_addr);
+	if (list_empty(&ctx->src_queue)) {
+		s5p_mfc_set_enc_frame_buffer(ctx, 0, 0);
+	} else {
+		src_mb = list_entry(ctx->src_queue.next, struct s5p_mfc_buf,
+									list);
+		src_mb->used = 1;
+		src_y_addr = vb2_dma_contig_plane_dma_addr(src_mb->b, 0);
+		src_c_addr = vb2_dma_contig_plane_dma_addr(src_mb->b, 1);
+		s5p_mfc_set_enc_frame_buffer(ctx, src_y_addr, src_c_addr);
+		if (src_mb->b->v4l2_buf.flags & V4L2_BUF_FLAG_EOS)
+			ctx->state = MFCINST_FINISHING;
+	}
 	dst_mb = list_entry(ctx->dst_queue.next, struct s5p_mfc_buf, list);
 	dst_mb->used = 1;
 	dst_addr = vb2_dma_contig_plane_dma_addr(dst_mb->b, 0);
@@ -1183,6 +1196,8 @@ static int s5p_mfc_run_enc_frame(struct s5p_mfc_ctx *ctx)
 	spin_unlock_irqrestore(&dev->irqlock, flags);
 	dev->curr_ctx = ctx->num;
 	s5p_mfc_clean_ctx_int_flags(ctx);
+	mfc_debug(2, "encoding %s frame state=%d",
+		list_empty(&ctx->src_queue) ? "null" : "normal", ctx->state);
 	s5p_mfc_encode_one_frame(ctx);
 	return 0;
 }
@@ -1345,6 +1360,8 @@ void s5p_mfc_try_run(struct s5p_mfc_dev *dev)
 	} else if (ctx->type == MFCINST_ENCODER) {
 		switch (ctx->state) {
 		case MFCINST_FINISHING:
+			s5p_mfc_run_enc_frame(ctx);
+			break;
 		case MFCINST_RUNNING:
 			ret = s5p_mfc_run_enc_frame(ctx);
 			break;
-- 
1.7.0.4

