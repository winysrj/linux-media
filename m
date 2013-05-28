Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.w1.samsung.com ([210.118.77.12]:47748 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759009Ab3E1H06 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 28 May 2013 03:26:58 -0400
Received: from eucpsbgm2.samsung.com (unknown [203.254.199.245])
 by mailout2.w1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MNH00BQBZAWJB70@mailout2.w1.samsung.com> for
 linux-media@vger.kernel.org; Tue, 28 May 2013 08:26:57 +0100 (BST)
From: Andrzej Hajda <a.hajda@samsung.com>
To: Kamil Debski <k.debski@samsung.com>, linux-media@vger.kernel.org
Cc: Jeongtae Park <jtp.park@samsung.com>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	Andrzej Hajda <a.hajda@samsung.com>
Subject: [PATCH 3/3] s5p-mfc: added missing end-of-lines in debug messages
Date: Tue, 28 May 2013 09:26:16 +0200
Message-id: <1369725976-7828-4-git-send-email-a.hajda@samsung.com>
In-reply-to: <1369725976-7828-1-git-send-email-a.hajda@samsung.com>
References: <1369725976-7828-1-git-send-email-a.hajda@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Many debug messages missed end-of-line.

Signed-off-by: Andrzej Hajda <a.hajda@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/media/platform/s5p-mfc/s5p_mfc.c        |  2 +-
 drivers/media/platform/s5p-mfc/s5p_mfc_debug.h  |  4 ++--
 drivers/media/platform/s5p-mfc/s5p_mfc_enc.c    | 16 ++++++++--------
 drivers/media/platform/s5p-mfc/s5p_mfc_opr_v5.c |  4 ++--
 drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c | 16 ++++++++--------
 drivers/media/platform/s5p-mfc/s5p_mfc_pm.c     |  4 ++--
 6 files changed, 23 insertions(+), 23 deletions(-)

diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc.c b/drivers/media/platform/s5p-mfc/s5p_mfc.c
index 01f9ae0..e04d97f 100644
--- a/drivers/media/platform/s5p-mfc/s5p_mfc.c
+++ b/drivers/media/platform/s5p-mfc/s5p_mfc.c
@@ -562,7 +562,7 @@ static void s5p_mfc_handle_stream_complete(struct s5p_mfc_ctx *ctx,
 	struct s5p_mfc_dev *dev = ctx->dev;
 	struct s5p_mfc_buf *mb_entry;
 
-	mfc_debug(2, "Stream completed");
+	mfc_debug(2, "Stream completed\n");
 
 	s5p_mfc_clear_int_flags(dev);
 	ctx->int_type = reason;
diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc_debug.h b/drivers/media/platform/s5p-mfc/s5p_mfc_debug.h
index bd5cd4a..8e608f5 100644
--- a/drivers/media/platform/s5p-mfc/s5p_mfc_debug.h
+++ b/drivers/media/platform/s5p-mfc/s5p_mfc_debug.h
@@ -30,8 +30,8 @@ extern int debug;
 #define mfc_debug(level, fmt, args...)
 #endif
 
-#define mfc_debug_enter() mfc_debug(5, "enter")
-#define mfc_debug_leave() mfc_debug(5, "leave")
+#define mfc_debug_enter() mfc_debug(5, "enter\n")
+#define mfc_debug_leave() mfc_debug(5, "leave\n")
 
 #define mfc_err(fmt, args...)				\
 	do {						\
diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc_enc.c b/drivers/media/platform/s5p-mfc/s5p_mfc_enc.c
index 64bb31e..f6eb28d 100644
--- a/drivers/media/platform/s5p-mfc/s5p_mfc_enc.c
+++ b/drivers/media/platform/s5p-mfc/s5p_mfc_enc.c
@@ -717,9 +717,9 @@ static int enc_post_frame_start(struct s5p_mfc_ctx *ctx)
 
 	slice_type = s5p_mfc_hw_call(dev->mfc_ops, get_enc_slice_type, dev);
 	strm_size = s5p_mfc_hw_call(dev->mfc_ops, get_enc_strm_size, dev);
-	mfc_debug(2, "Encoded slice type: %d", slice_type);
-	mfc_debug(2, "Encoded stream size: %d", strm_size);
-	mfc_debug(2, "Display order: %d",
+	mfc_debug(2, "Encoded slice type: %d\n", slice_type);
+	mfc_debug(2, "Encoded stream size: %d\n", strm_size);
+	mfc_debug(2, "Display order: %d\n",
 		  mfc_read(dev, S5P_FIMV_ENC_SI_PIC_CNT));
 	spin_lock_irqsave(&dev->irqlock, flags);
 	if (slice_type >= 0) {
@@ -1533,14 +1533,14 @@ int vidioc_encoder_cmd(struct file *file, void *priv,
 
 		spin_lock_irqsave(&dev->irqlock, flags);
 		if (list_empty(&ctx->src_queue)) {
-			mfc_debug(2, "EOS: empty src queue, entering finishing state");
+			mfc_debug(2, "EOS: empty src queue, entering finishing state\n");
 			ctx->state = MFCINST_FINISHING;
 			if (s5p_mfc_ctx_ready(ctx))
 				set_work_bit_irqsave(ctx);
 			spin_unlock_irqrestore(&dev->irqlock, flags);
 			s5p_mfc_hw_call(dev->mfc_ops, try_run, dev);
 		} else {
-			mfc_debug(2, "EOS: marking last buffer of stream");
+			mfc_debug(2, "EOS: marking last buffer of stream\n");
 			buf = list_entry(ctx->src_queue.prev,
 						struct s5p_mfc_buf, list);
 			if (buf->flags & MFC_BUF_FLAG_USED)
@@ -1609,9 +1609,9 @@ static int check_vb_with_fmt(struct s5p_mfc_fmt *fmt, struct vb2_buffer *vb)
 			mfc_err("failed to get plane cookie\n");
 			return -EINVAL;
 		}
-		mfc_debug(2, "index: %d, plane[%d] cookie: 0x%08zx",
-				vb->v4l2_buf.index, i,
-				vb2_dma_contig_plane_dma_addr(vb, i));
+		mfc_debug(2, "index: %d, plane[%d] cookie: 0x%08zx\n",
+			  vb->v4l2_buf.index, i,
+			  vb2_dma_contig_plane_dma_addr(vb, i));
 	}
 	return 0;
 }
diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc_opr_v5.c b/drivers/media/platform/s5p-mfc/s5p_mfc_opr_v5.c
index 0af05a2..368582b 100644
--- a/drivers/media/platform/s5p-mfc/s5p_mfc_opr_v5.c
+++ b/drivers/media/platform/s5p-mfc/s5p_mfc_opr_v5.c
@@ -1275,8 +1275,8 @@ static int s5p_mfc_run_enc_frame(struct s5p_mfc_ctx *ctx)
 	spin_unlock_irqrestore(&dev->irqlock, flags);
 	dev->curr_ctx = ctx->num;
 	s5p_mfc_clean_ctx_int_flags(ctx);
-	mfc_debug(2, "encoding buffer with index=%d state=%d",
-			src_mb ? src_mb->b->v4l2_buf.index : -1, ctx->state);
+	mfc_debug(2, "encoding buffer with index=%d state=%d\n",
+		  src_mb ? src_mb->b->v4l2_buf.index : -1, ctx->state);
 	s5p_mfc_encode_one_frame_v5(ctx);
 	return 0;
 }
diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c b/drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c
index 7e76fce..2799132 100644
--- a/drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c
+++ b/drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c
@@ -449,8 +449,8 @@ static int s5p_mfc_set_enc_stream_buffer_v6(struct s5p_mfc_ctx *ctx,
 	WRITEL(addr, S5P_FIMV_E_STREAM_BUFFER_ADDR_V6); /* 16B align */
 	WRITEL(size, S5P_FIMV_E_STREAM_BUFFER_SIZE_V6);
 
-	mfc_debug(2, "stream buf addr: 0x%08lx, size: 0x%d",
-		addr, size);
+	mfc_debug(2, "stream buf addr: 0x%08lx, size: 0x%d\n",
+		  addr, size);
 
 	return 0;
 }
@@ -463,8 +463,8 @@ static void s5p_mfc_set_enc_frame_buffer_v6(struct s5p_mfc_ctx *ctx,
 	WRITEL(y_addr, S5P_FIMV_E_SOURCE_LUMA_ADDR_V6); /* 256B align */
 	WRITEL(c_addr, S5P_FIMV_E_SOURCE_CHROMA_ADDR_V6);
 
-	mfc_debug(2, "enc src y buf addr: 0x%08lx", y_addr);
-	mfc_debug(2, "enc src c buf addr: 0x%08lx", c_addr);
+	mfc_debug(2, "enc src y buf addr: 0x%08lx\n", y_addr);
+	mfc_debug(2, "enc src c buf addr: 0x%08lx\n", c_addr);
 }
 
 static void s5p_mfc_get_enc_frame_buffer_v6(struct s5p_mfc_ctx *ctx,
@@ -479,8 +479,8 @@ static void s5p_mfc_get_enc_frame_buffer_v6(struct s5p_mfc_ctx *ctx,
 	enc_recon_y_addr = READL(S5P_FIMV_E_RECON_LUMA_DPB_ADDR_V6);
 	enc_recon_c_addr = READL(S5P_FIMV_E_RECON_CHROMA_DPB_ADDR_V6);
 
-	mfc_debug(2, "recon y addr: 0x%08lx", enc_recon_y_addr);
-	mfc_debug(2, "recon c addr: 0x%08lx", enc_recon_c_addr);
+	mfc_debug(2, "recon y addr: 0x%08lx\n", enc_recon_y_addr);
+	mfc_debug(2, "recon c addr: 0x%08lx\n", enc_recon_c_addr);
 }
 
 /* Set encoding ref & codec buffer */
@@ -1431,8 +1431,8 @@ static inline int s5p_mfc_run_enc_frame(struct s5p_mfc_ctx *ctx)
 	src_y_addr = vb2_dma_contig_plane_dma_addr(src_mb->b, 0);
 	src_c_addr = vb2_dma_contig_plane_dma_addr(src_mb->b, 1);
 
-	mfc_debug(2, "enc src y addr: 0x%08lx", src_y_addr);
-	mfc_debug(2, "enc src c addr: 0x%08lx", src_c_addr);
+	mfc_debug(2, "enc src y addr: 0x%08lx\n", src_y_addr);
+	mfc_debug(2, "enc src c addr: 0x%08lx\n", src_c_addr);
 
 	s5p_mfc_set_enc_frame_buffer_v6(ctx, src_y_addr, src_c_addr);
 
diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc_pm.c b/drivers/media/platform/s5p-mfc/s5p_mfc_pm.c
index 6aa38a5..95e7f6d 100644
--- a/drivers/media/platform/s5p-mfc/s5p_mfc_pm.c
+++ b/drivers/media/platform/s5p-mfc/s5p_mfc_pm.c
@@ -98,7 +98,7 @@ int s5p_mfc_clock_on(void)
 	int ret;
 #ifdef CLK_DEBUG
 	atomic_inc(&clk_ref);
-	mfc_debug(3, "+ %d", atomic_read(&clk_ref));
+	mfc_debug(3, "+ %d\n", atomic_read(&clk_ref));
 #endif
 	ret = clk_enable(pm->clock_gate);
 	return ret;
@@ -108,7 +108,7 @@ void s5p_mfc_clock_off(void)
 {
 #ifdef CLK_DEBUG
 	atomic_dec(&clk_ref);
-	mfc_debug(3, "- %d", atomic_read(&clk_ref));
+	mfc_debug(3, "- %d\n", atomic_read(&clk_ref));
 #endif
 	clk_disable(pm->clock_gate);
 }
-- 
1.8.1.2

