Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qc0-f174.google.com ([209.85.216.174]:55172 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752657Ab2LBMRJ (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 2 Dec 2012 07:17:09 -0500
Received: by mail-qc0-f174.google.com with SMTP id o22so1040999qcr.19
        for <linux-media@vger.kernel.org>; Sun, 02 Dec 2012 04:17:09 -0800 (PST)
MIME-Version: 1.0
Date: Sun, 2 Dec 2012 07:17:08 -0500
Message-ID: <CAPgLHd8BLn1_O4-9rCBbREq4ke2ZaJAVWLhOEF2QwACxub=vUQ@mail.gmail.com>
Subject: [PATCH -next] [media] s5p-mfc: remove unused variable
From: Wei Yongjun <weiyj.lk@gmail.com>
To: kyungmin.park@samsung.com, k.debski@samsung.com,
	jtp.park@samsung.com, mchehab@redhat.com
Cc: yongjun_wei@trendmicro.com.cn,
	linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

The variable index is initialized but never used
otherwise, so remove the unused variable.

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
---
 drivers/media/platform/s5p-mfc/s5p_mfc.c        | 5 -----
 drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c | 6 ------
 2 files changed, 11 deletions(-)

diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc.c b/drivers/media/platform/s5p-mfc/s5p_mfc.c
index 3afe879..856cf00 100644
--- a/drivers/media/platform/s5p-mfc/s5p_mfc.c
+++ b/drivers/media/platform/s5p-mfc/s5p_mfc.c
@@ -273,7 +273,6 @@ static void s5p_mfc_handle_frame_new(struct s5p_mfc_ctx *ctx, unsigned int err)
 	struct s5p_mfc_buf  *dst_buf;
 	size_t dspl_y_addr;
 	unsigned int frame_type;
-	unsigned int index;
 
 	dspl_y_addr = s5p_mfc_hw_call(dev->mfc_ops, get_dspl_y_adr, dev);
 	frame_type = s5p_mfc_hw_call(dev->mfc_ops, get_dec_frame_type, dev);
@@ -310,7 +309,6 @@ static void s5p_mfc_handle_frame_new(struct s5p_mfc_ctx *ctx, unsigned int err)
 			vb2_buffer_done(dst_buf->b,
 				err ? VB2_BUF_STATE_ERROR : VB2_BUF_STATE_DONE);
 
-			index = dst_buf->b->v4l2_buf.index;
 			break;
 		}
 	}
@@ -326,8 +324,6 @@ static void s5p_mfc_handle_frame(struct s5p_mfc_ctx *ctx,
 	unsigned long flags;
 	unsigned int res_change;
 
-	unsigned int index;
-
 	dst_frame_status = s5p_mfc_hw_call(dev->mfc_ops, get_dspl_status, dev)
 				& S5P_FIMV_DEC_STATUS_DECODING_STATUS_MASK;
 	res_change = (s5p_mfc_hw_call(dev->mfc_ops, get_dspl_status, dev)
@@ -387,7 +383,6 @@ static void s5p_mfc_handle_frame(struct s5p_mfc_ctx *ctx,
 			mfc_debug(2, "Running again the same buffer\n");
 			ctx->after_packed_pb = 1;
 		} else {
-			index = src_buf->b->v4l2_buf.index;
 			mfc_debug(2, "MFC needs next buffer\n");
 			ctx->consumed_stream = 0;
 			list_del(&src_buf->list);

diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c b/drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c
index 3a8cfd9..bf4d2f4 100644
--- a/drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c
+++ b/drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c
@@ -1408,7 +1408,6 @@ static inline int s5p_mfc_run_dec_frame(struct s5p_mfc_ctx *ctx)
 	struct s5p_mfc_buf *temp_vb;
 	unsigned long flags;
 	int last_frame = 0;
-	unsigned int index;
 
 	spin_lock_irqsave(&dev->irqlock, flags);
 
@@ -1427,8 +1426,6 @@ static inline int s5p_mfc_run_dec_frame(struct s5p_mfc_ctx *ctx)
 			temp_vb->b->v4l2_planes[0].bytesused);
 	spin_unlock_irqrestore(&dev->irqlock, flags);
 
-	index = temp_vb->b->v4l2_buf.index;
-
 	dev->curr_ctx = ctx->num;
 	s5p_mfc_clean_ctx_int_flags(ctx);
 	if (temp_vb->b->v4l2_planes[0].bytesused == 0) {
@@ -1452,7 +1449,6 @@ static inline int s5p_mfc_run_enc_frame(struct s5p_mfc_ctx *ctx)
 	unsigned int src_y_size, src_c_size;
 	*/
 	unsigned int dst_size;
-	unsigned int index;
 
 	spin_lock_irqsave(&dev->irqlock, flags);
 
@@ -1487,8 +1483,6 @@ static inline int s5p_mfc_run_enc_frame(struct s5p_mfc_ctx *ctx)
 
 	spin_unlock_irqrestore(&dev->irqlock, flags);
 
-	index = src_mb->b->v4l2_buf.index;
-
 	dev->curr_ctx = ctx->num;
 	s5p_mfc_clean_ctx_int_flags(ctx);
 	s5p_mfc_encode_one_frame_v6(ctx);

