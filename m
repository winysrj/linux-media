Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.w1.samsung.com ([210.118.77.13]:8592 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751022AbbJBJ7t (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 2 Oct 2015 05:59:49 -0400
From: Andrzej Hajda <a.hajda@samsung.com>
To: linux-media@vger.kernel.org (open list:ARM/SAMSUNG S5P SERIES Multi
	Format Codec (MFC)...)
Cc: Andrzej Hajda <a.hajda@samsung.com>,
	Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	Kamil Debski <k.debski@samsung.com>,
	Jeongtae Park <jtp.park@samsung.com>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	linux-samsung-soc@vger.kernel.org
Subject: [PATCH 1/2] s5p-mfc: end-of-stream handling for newer encoders
Date: Fri, 02 Oct 2015 11:58:53 +0200
Message-id: <1443779934-30088-1-git-send-email-a.hajda@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

MFC encoder supports end-of-stream handling for encoder
in version 5 of hardware. This patch adds it also for newer version.
It was successfully tested on MFC-v8.

Signed-off-by: Andrzej Hajda <a.hajda@samsung.com>
---
 drivers/media/platform/s5p-mfc/s5p_mfc.c        | 25 ++++++++--------
 drivers/media/platform/s5p-mfc/s5p_mfc_enc.c    |  5 ++--
 drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c | 40 ++++++++++++++++++-------
 3 files changed, 44 insertions(+), 26 deletions(-)

diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc.c b/drivers/media/platform/s5p-mfc/s5p_mfc.c
index 8de61dc..21c424e 100644
--- a/drivers/media/platform/s5p-mfc/s5p_mfc.c
+++ b/drivers/media/platform/s5p-mfc/s5p_mfc.c
@@ -181,13 +181,6 @@ unlock:
 		mutex_unlock(&dev->mfc_mutex);
 }
 
-static void s5p_mfc_clear_int_flags(struct s5p_mfc_dev *dev)
-{
-	mfc_write(dev, 0, S5P_FIMV_RISC_HOST_INT);
-	mfc_write(dev, 0, S5P_FIMV_RISC2HOST_CMD);
-	mfc_write(dev, 0xffff, S5P_FIMV_SI_RTN_CHID);
-}
-
 static void s5p_mfc_handle_frame_all_extracted(struct s5p_mfc_ctx *ctx)
 {
 	struct s5p_mfc_buf *dst_buf;
@@ -573,17 +566,13 @@ static void s5p_mfc_handle_init_buffers(struct s5p_mfc_ctx *ctx,
 	}
 }
 
-static void s5p_mfc_handle_stream_complete(struct s5p_mfc_ctx *ctx,
-				 unsigned int reason, unsigned int err)
+static void s5p_mfc_handle_stream_complete(struct s5p_mfc_ctx *ctx)
 {
 	struct s5p_mfc_dev *dev = ctx->dev;
 	struct s5p_mfc_buf *mb_entry;
 
 	mfc_debug(2, "Stream completed\n");
 
-	s5p_mfc_clear_int_flags(dev);
-	ctx->int_type = reason;
-	ctx->int_err = err;
 	ctx->state = MFCINST_FINISHED;
 
 	spin_lock(&dev->irqlock);
@@ -640,6 +629,13 @@ static irqreturn_t s5p_mfc_irq(int irq, void *priv)
 		if (ctx->c_ops->post_frame_start) {
 			if (ctx->c_ops->post_frame_start(ctx))
 				mfc_err("post_frame_start() failed\n");
+
+			if (ctx->state == MFCINST_FINISHING &&
+						list_empty(&ctx->ref_queue)) {
+				s5p_mfc_hw_call_void(dev->mfc_ops, clear_int_flags, dev);
+				s5p_mfc_handle_stream_complete(ctx);
+				break;
+			}
 			s5p_mfc_hw_call_void(dev->mfc_ops, clear_int_flags, dev);
 			wake_up_ctx(ctx, reason, err);
 			WARN_ON(test_and_clear_bit(0, &dev->hw_lock) == 0);
@@ -685,7 +681,10 @@ static irqreturn_t s5p_mfc_irq(int irq, void *priv)
 		break;
 
 	case S5P_MFC_R2H_CMD_COMPLETE_SEQ_RET:
-		s5p_mfc_handle_stream_complete(ctx, reason, err);
+		s5p_mfc_hw_call_void(dev->mfc_ops, clear_int_flags, dev);
+		ctx->int_type = reason;
+		ctx->int_err = err;
+		s5p_mfc_handle_stream_complete(ctx);
 		break;
 
 	case S5P_MFC_R2H_CMD_DPB_FLUSH_RET:
diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc_enc.c b/drivers/media/platform/s5p-mfc/s5p_mfc_enc.c
index 2e57e9f..5280592 100644
--- a/drivers/media/platform/s5p-mfc/s5p_mfc_enc.c
+++ b/drivers/media/platform/s5p-mfc/s5p_mfc_enc.c
@@ -902,9 +902,9 @@ static int enc_post_frame_start(struct s5p_mfc_ctx *ctx)
 			list_add_tail(&mb_entry->list, &ctx->ref_queue);
 			ctx->ref_queue_cnt++;
 		}
-		mfc_debug(2, "enc src count: %d, enc ref count: %d\n",
-			  ctx->src_queue_cnt, ctx->ref_queue_cnt);
 	}
+	mfc_debug(2, "enc src count: %d, enc ref count: %d\n",
+		  ctx->src_queue_cnt, ctx->ref_queue_cnt);
 	if ((ctx->dst_queue_cnt > 0) && (strm_size > 0)) {
 		mb_entry = list_entry(ctx->dst_queue.next, struct s5p_mfc_buf,
 									list);
@@ -927,6 +927,7 @@ static int enc_post_frame_start(struct s5p_mfc_ctx *ctx)
 	spin_unlock_irqrestore(&dev->irqlock, flags);
 	if ((ctx->src_queue_cnt == 0) || (ctx->dst_queue_cnt == 0))
 		clear_work_bit(ctx);
+
 	return 0;
 }
 
diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c b/drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c
index e5cb30e..af4b936 100644
--- a/drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c
+++ b/drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c
@@ -554,7 +554,7 @@ static void s5p_mfc_get_enc_frame_buffer_v6(struct s5p_mfc_ctx *ctx,
 	enc_recon_y_addr = readl(mfc_regs->e_recon_luma_dpb_addr);
 	enc_recon_c_addr = readl(mfc_regs->e_recon_chroma_dpb_addr);
 
-	mfc_debug(2, "recon y addr: 0x%08lx\n", enc_recon_y_addr);
+	mfc_debug(2, "recon y addr: 0x%08lx y_addr: 0x%08lx\n", enc_recon_y_addr, *y_addr);
 	mfc_debug(2, "recon c addr: 0x%08lx\n", enc_recon_c_addr);
 }
 
@@ -1483,6 +1483,7 @@ static int s5p_mfc_encode_one_frame_v6(struct s5p_mfc_ctx *ctx)
 {
 	struct s5p_mfc_dev *dev = ctx->dev;
 	const struct s5p_mfc_regs *mfc_regs = dev->mfc_regs;
+	int cmd;
 
 	mfc_debug(2, "++\n");
 
@@ -1493,9 +1494,13 @@ static int s5p_mfc_encode_one_frame_v6(struct s5p_mfc_ctx *ctx)
 
 	s5p_mfc_set_slice_mode(ctx);
 
+	if (ctx->state != MFCINST_FINISHING)
+		cmd = S5P_FIMV_CH_FRAME_START_V6;
+	else
+		cmd = S5P_FIMV_CH_LAST_FRAME_V6;
+
 	writel(ctx->inst_no, mfc_regs->instance_id);
-	s5p_mfc_hw_call_void(dev->mfc_cmds, cmd_host2risc, dev,
-			S5P_FIMV_CH_FRAME_START_V6, NULL);
+	s5p_mfc_hw_call_void(dev->mfc_cmds, cmd_host2risc, dev, cmd, NULL);
 
 	mfc_debug(2, "--\n");
 
@@ -1592,7 +1597,7 @@ static inline int s5p_mfc_run_enc_frame(struct s5p_mfc_ctx *ctx)
 
 	spin_lock_irqsave(&dev->irqlock, flags);
 
-	if (list_empty(&ctx->src_queue)) {
+	if (list_empty(&ctx->src_queue) && ctx->state != MFCINST_FINISHING) {
 		mfc_debug(2, "no src buffers.\n");
 		spin_unlock_irqrestore(&dev->irqlock, flags);
 		return -EAGAIN;
@@ -1604,15 +1609,28 @@ static inline int s5p_mfc_run_enc_frame(struct s5p_mfc_ctx *ctx)
 		return -EAGAIN;
 	}
 
-	src_mb = list_entry(ctx->src_queue.next, struct s5p_mfc_buf, list);
-	src_mb->flags |= MFC_BUF_FLAG_USED;
-	src_y_addr = vb2_dma_contig_plane_dma_addr(src_mb->b, 0);
-	src_c_addr = vb2_dma_contig_plane_dma_addr(src_mb->b, 1);
+	if (list_empty(&ctx->src_queue)) {
+		/* send null frame */
+		s5p_mfc_set_enc_frame_buffer_v6(ctx, 0, 0);
+		src_mb = NULL;
+	} else {
+		src_mb = list_entry(ctx->src_queue.next, struct s5p_mfc_buf, list);
+		src_mb->flags |= MFC_BUF_FLAG_USED;
+		if (src_mb->b->v4l2_planes[0].bytesused == 0) {
+			s5p_mfc_set_enc_frame_buffer_v6(ctx, 0, 0);
+			ctx->state = MFCINST_FINISHING;
+		} else {
+			src_y_addr = vb2_dma_contig_plane_dma_addr(src_mb->b, 0);
+			src_c_addr = vb2_dma_contig_plane_dma_addr(src_mb->b, 1);
 
-	mfc_debug(2, "enc src y addr: 0x%08lx\n", src_y_addr);
-	mfc_debug(2, "enc src c addr: 0x%08lx\n", src_c_addr);
+			mfc_debug(2, "enc src y addr: 0x%08lx\n", src_y_addr);
+			mfc_debug(2, "enc src c addr: 0x%08lx\n", src_c_addr);
 
-	s5p_mfc_set_enc_frame_buffer_v6(ctx, src_y_addr, src_c_addr);
+			s5p_mfc_set_enc_frame_buffer_v6(ctx, src_y_addr, src_c_addr);
+			if (src_mb->flags & MFC_BUF_FLAG_EOS)
+				ctx->state = MFCINST_FINISHING;
+		}
+	}
 
 	dst_mb = list_entry(ctx->dst_queue.next, struct s5p_mfc_buf, list);
 	dst_mb->flags |= MFC_BUF_FLAG_USED;
-- 
1.9.1

