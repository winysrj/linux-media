Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.samsung.com ([203.254.224.25]:30416 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754377Ab3DXNRe (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 24 Apr 2013 09:17:34 -0400
Received: from epcpsbgr3.samsung.com
 (u143.gpu120.samsung.co.kr [203.254.230.143])
 by mailout2.samsung.com (Oracle Communications Messaging Server 7u4-24.01
 (7.0.4.24.0) 64bit (built Nov 17 2011))
 with ESMTP id <0MLR0052HGX2UU00@mailout2.samsung.com> for
 linux-media@vger.kernel.org; Wed, 24 Apr 2013 22:17:32 +0900 (KST)
From: Arun Kumar K <arun.kk@samsung.com>
To: linux-media@vger.kernel.org
Cc: k.debski@samsung.com, jtp.park@samsung.com, s.nawrocki@samsung.com,
	sheu@google.com, arunkk.samsung@gmail.com
Subject: [PATCH v3] [media] s5p-mfc: Update v6 encoder buffer alloc
Date: Wed, 24 Apr 2013 19:11:53 +0530
Message-id: <1366810913-17828-1-git-send-email-arun.kk@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

MFC v6 needs minimum number of output buffers to be queued
for encoder depending on the stream type and profile.
The patch modifies the driver so that encoding cannot be
started with lesser number of OUTPUT buffers than required.

This also fixes the crash happeninig during multi instance
encoder-decoder simultaneous run due to memory allocation
happening from interrupt context.

Signed-off-by: Arun Kumar K <arun.kk@samsung.com>
---
Changes from v2:
- Addressed review comments from Kamil Debski
  https://patchwork.kernel.org/patch/2335091/

Changes from v1:
- Corrected the commit message as pointed out by John Sheu.
  http://www.spinics.net/lists/linux-media/msg61477.html  
---
 drivers/media/platform/s5p-mfc/s5p_mfc.c        |    4 +-
 drivers/media/platform/s5p-mfc/s5p_mfc_common.h |    3 +-
 drivers/media/platform/s5p-mfc/s5p_mfc_dec.c    |   20 +++----
 drivers/media/platform/s5p-mfc/s5p_mfc_enc.c    |   64 +++++++++++++++++------
 drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c |   29 +++-------
 5 files changed, 67 insertions(+), 53 deletions(-)

diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc.c b/drivers/media/platform/s5p-mfc/s5p_mfc.c
index e810b1a..2cbd442 100644
--- a/drivers/media/platform/s5p-mfc/s5p_mfc.c
+++ b/drivers/media/platform/s5p-mfc/s5p_mfc.c
@@ -399,7 +399,7 @@ static void s5p_mfc_handle_frame(struct s5p_mfc_ctx *ctx,
 leave_handle_frame:
 	spin_unlock_irqrestore(&dev->irqlock, flags);
 	if ((ctx->src_queue_cnt == 0 && ctx->state != MFCINST_FINISHING)
-				    || ctx->dst_queue_cnt < ctx->dpb_count)
+				    || ctx->dst_queue_cnt < ctx->pb_count)
 		clear_work_bit(ctx);
 	s5p_mfc_hw_call(dev->mfc_ops, clear_int_flags, dev);
 	wake_up_ctx(ctx, reason, err);
@@ -475,7 +475,7 @@ static void s5p_mfc_handle_seq_done(struct s5p_mfc_ctx *ctx,
 
 		s5p_mfc_hw_call(dev->mfc_ops, dec_calc_dpb_size, ctx);
 
-		ctx->dpb_count = s5p_mfc_hw_call(dev->mfc_ops, get_dpb_count,
+		ctx->pb_count = s5p_mfc_hw_call(dev->mfc_ops, get_dpb_count,
 				dev);
 		ctx->mv_count = s5p_mfc_hw_call(dev->mfc_ops, get_mv_count,
 				dev);
diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc_common.h b/drivers/media/platform/s5p-mfc/s5p_mfc_common.h
index 202d1d7..975d1b2 100644
--- a/drivers/media/platform/s5p-mfc/s5p_mfc_common.h
+++ b/drivers/media/platform/s5p-mfc/s5p_mfc_common.h
@@ -138,6 +138,7 @@ enum s5p_mfc_inst_state {
 	MFCINST_INIT = 100,
 	MFCINST_GOT_INST,
 	MFCINST_HEAD_PARSED,
+	MFCINST_HEAD_PRODUCED,
 	MFCINST_BUFS_SET,
 	MFCINST_RUNNING,
 	MFCINST_FINISHING,
@@ -602,7 +603,7 @@ struct s5p_mfc_ctx {
 	int after_packed_pb;
 	int sei_fp_parse;
 
-	int dpb_count;
+	int pb_count;
 	int total_dpb_count;
 	int mv_count;
 	/* Buffers */
diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc_dec.c b/drivers/media/platform/s5p-mfc/s5p_mfc_dec.c
index 4af53bd..00b0703 100644
--- a/drivers/media/platform/s5p-mfc/s5p_mfc_dec.c
+++ b/drivers/media/platform/s5p-mfc/s5p_mfc_dec.c
@@ -210,11 +210,11 @@ static int s5p_mfc_ctx_ready(struct s5p_mfc_ctx *ctx)
 	/* Context is to decode a frame */
 	if (ctx->src_queue_cnt >= 1 &&
 	    ctx->state == MFCINST_RUNNING &&
-	    ctx->dst_queue_cnt >= ctx->dpb_count)
+	    ctx->dst_queue_cnt >= ctx->pb_count)
 		return 1;
 	/* Context is to return last frame */
 	if (ctx->state == MFCINST_FINISHING &&
-	    ctx->dst_queue_cnt >= ctx->dpb_count)
+	    ctx->dst_queue_cnt >= ctx->pb_count)
 		return 1;
 	/* Context is to set buffers */
 	if (ctx->src_queue_cnt >= 1 &&
@@ -224,7 +224,7 @@ static int s5p_mfc_ctx_ready(struct s5p_mfc_ctx *ctx)
 	/* Resolution change */
 	if ((ctx->state == MFCINST_RES_CHANGE_INIT ||
 		ctx->state == MFCINST_RES_CHANGE_FLUSH) &&
-		ctx->dst_queue_cnt >= ctx->dpb_count)
+		ctx->dst_queue_cnt >= ctx->pb_count)
 		return 1;
 	if (ctx->state == MFCINST_RES_CHANGE_END &&
 		ctx->src_queue_cnt >= 1)
@@ -537,7 +537,7 @@ static int vidioc_reqbufs(struct file *file, void *priv,
 			mfc_err("vb2_reqbufs on capture failed\n");
 			return ret;
 		}
-		if (reqbufs->count < ctx->dpb_count) {
+		if (reqbufs->count < ctx->pb_count) {
 			mfc_err("Not enough buffers allocated\n");
 			reqbufs->count = 0;
 			s5p_mfc_clock_on();
@@ -751,7 +751,7 @@ static int s5p_mfc_dec_g_v_ctrl(struct v4l2_ctrl *ctrl)
 	case V4L2_CID_MIN_BUFFERS_FOR_CAPTURE:
 		if (ctx->state >= MFCINST_HEAD_PARSED &&
 		    ctx->state < MFCINST_ABORT) {
-			ctrl->val = ctx->dpb_count;
+			ctrl->val = ctx->pb_count;
 			break;
 		} else if (ctx->state != MFCINST_INIT) {
 			v4l2_err(&dev->v4l2_dev, "Decoding not initialised\n");
@@ -763,7 +763,7 @@ static int s5p_mfc_dec_g_v_ctrl(struct v4l2_ctrl *ctrl)
 				S5P_MFC_R2H_CMD_SEQ_DONE_RET, 0);
 		if (ctx->state >= MFCINST_HEAD_PARSED &&
 		    ctx->state < MFCINST_ABORT) {
-			ctrl->val = ctx->dpb_count;
+			ctrl->val = ctx->pb_count;
 		} else {
 			v4l2_err(&dev->v4l2_dev, "Decoding not initialised\n");
 			return -EINVAL;
@@ -924,10 +924,10 @@ static int s5p_mfc_queue_setup(struct vb2_queue *vq,
 		/* Output plane count is 2 - one for Y and one for CbCr */
 		*plane_count = 2;
 		/* Setup buffer count */
-		if (*buf_count < ctx->dpb_count)
-			*buf_count = ctx->dpb_count;
-		if (*buf_count > ctx->dpb_count + MFC_MAX_EXTRA_DPB)
-			*buf_count = ctx->dpb_count + MFC_MAX_EXTRA_DPB;
+		if (*buf_count < ctx->pb_count)
+			*buf_count = ctx->pb_count;
+		if (*buf_count > ctx->pb_count + MFC_MAX_EXTRA_DPB)
+			*buf_count = ctx->pb_count + MFC_MAX_EXTRA_DPB;
 		if (*buf_count > MFC_MAX_BUFFERS)
 			*buf_count = MFC_MAX_BUFFERS;
 	} else {
diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc_enc.c b/drivers/media/platform/s5p-mfc/s5p_mfc_enc.c
index 4f6b553..5e019aa 100644
--- a/drivers/media/platform/s5p-mfc/s5p_mfc_enc.c
+++ b/drivers/media/platform/s5p-mfc/s5p_mfc_enc.c
@@ -592,7 +592,7 @@ static int s5p_mfc_ctx_ready(struct s5p_mfc_ctx *ctx)
 		return 1;
 	/* context is ready to encode a frame */
 	if ((ctx->state == MFCINST_RUNNING ||
-		ctx->state == MFCINST_HEAD_PARSED) &&
+		ctx->state == MFCINST_HEAD_PRODUCED) &&
 		ctx->src_queue_cnt >= 1 && ctx->dst_queue_cnt >= 1)
 		return 1;
 	/* context is ready to encode remaining frames */
@@ -649,6 +649,7 @@ static int enc_post_seq_start(struct s5p_mfc_ctx *ctx)
 	struct s5p_mfc_enc_params *p = &ctx->enc_params;
 	struct s5p_mfc_buf *dst_mb;
 	unsigned long flags;
+	unsigned int enc_pb_count;
 
 	if (p->seq_hdr_mode == V4L2_MPEG_VIDEO_HEADER_MODE_SEPARATE) {
 		spin_lock_irqsave(&dev->irqlock, flags);
@@ -661,18 +662,19 @@ static int enc_post_seq_start(struct s5p_mfc_ctx *ctx)
 		vb2_buffer_done(dst_mb->b, VB2_BUF_STATE_DONE);
 		spin_unlock_irqrestore(&dev->irqlock, flags);
 	}
-	if (IS_MFCV6(dev)) {
-		ctx->state = MFCINST_HEAD_PARSED; /* for INIT_BUFFER cmd */
-	} else {
+
+	if (!IS_MFCV6(dev)) {
 		ctx->state = MFCINST_RUNNING;
 		if (s5p_mfc_ctx_ready(ctx))
 			set_work_bit_irqsave(ctx);
 		s5p_mfc_hw_call(dev->mfc_ops, try_run, dev);
-	}
-
-	if (IS_MFCV6(dev))
-		ctx->dpb_count = s5p_mfc_hw_call(dev->mfc_ops,
+	} else {
+		enc_pb_count = s5p_mfc_hw_call(dev->mfc_ops,
 				get_enc_dpb_count, dev);
+		if (ctx->pb_count < enc_pb_count)
+			ctx->pb_count = enc_pb_count;
+		ctx->state = MFCINST_HEAD_PRODUCED;
+	}
 
 	return 0;
 }
@@ -1055,15 +1057,13 @@ static int vidioc_reqbufs(struct file *file, void *priv,
 		}
 		ctx->capture_state = QUEUE_BUFS_REQUESTED;
 
-		if (!IS_MFCV6(dev)) {
-			ret = s5p_mfc_hw_call(ctx->dev->mfc_ops,
-					alloc_codec_buffers, ctx);
-			if (ret) {
-				mfc_err("Failed to allocate encoding buffers\n");
-				reqbufs->count = 0;
-				ret = vb2_reqbufs(&ctx->vq_dst, reqbufs);
-				return -ENOMEM;
-			}
+		ret = s5p_mfc_hw_call(ctx->dev->mfc_ops,
+				alloc_codec_buffers, ctx);
+		if (ret) {
+			mfc_err("Failed to allocate encoding buffers\n");
+			reqbufs->count = 0;
+			ret = vb2_reqbufs(&ctx->vq_dst, reqbufs);
+			return -ENOMEM;
 		}
 	} else if (reqbufs->type == V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE) {
 		if (ctx->output_state != QUEUE_FREE) {
@@ -1071,6 +1071,19 @@ static int vidioc_reqbufs(struct file *file, void *priv,
 							ctx->output_state);
 			return -EINVAL;
 		}
+
+		if (IS_MFCV6(dev)) {
+			/* Check for min encoder buffers */
+			if (ctx->pb_count &&
+				(reqbufs->count < ctx->pb_count)) {
+				reqbufs->count = ctx->pb_count;
+				mfc_debug(2, "Minimum %d output buffers needed\n",
+						ctx->pb_count);
+			} else {
+				ctx->pb_count = reqbufs->count;
+			}
+		}
+
 		ret = vb2_reqbufs(&ctx->vq_src, reqbufs);
 		if (ret != 0) {
 			mfc_err("error in vb2_reqbufs() for E(S)\n");
@@ -1760,11 +1773,28 @@ static int s5p_mfc_start_streaming(struct vb2_queue *q, unsigned int count)
 	struct s5p_mfc_ctx *ctx = fh_to_ctx(q->drv_priv);
 	struct s5p_mfc_dev *dev = ctx->dev;
 
+	if (IS_MFCV6(dev) && (q->type == V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE)) {
+
+		if ((ctx->state == MFCINST_GOT_INST) &&
+			(dev->curr_ctx == ctx->num) && dev->hw_lock) {
+			s5p_mfc_wait_for_done_ctx(ctx,
+						S5P_MFC_R2H_CMD_SEQ_DONE_RET,
+						0);
+		}
+
+		if (ctx->src_bufs_cnt < ctx->pb_count) {
+			mfc_err("Need minimum %d OUTPUT buffers\n",
+					ctx->pb_count);
+			return -EINVAL;
+		}
+	}
+
 	v4l2_ctrl_handler_setup(&ctx->ctrl_handler);
 	/* If context is ready then dev = work->data;schedule it to run */
 	if (s5p_mfc_ctx_ready(ctx))
 		set_work_bit_irqsave(ctx);
 	s5p_mfc_hw_call(dev->mfc_ops, try_run, dev);
+
 	return 0;
 }
 
diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c b/drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c
index db57f25..383ae77 100644
--- a/drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c
+++ b/drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c
@@ -167,7 +167,7 @@ static int s5p_mfc_alloc_codec_buffers_v6(struct s5p_mfc_ctx *ctx)
 				S5P_FIMV_SCRATCH_BUFFER_ALIGN_V6);
 		ctx->bank1.size =
 			ctx->scratch_buf_size + ctx->tmv_buffer_size +
-			(ctx->dpb_count * (ctx->luma_dpb_size +
+			(ctx->pb_count * (ctx->luma_dpb_size +
 			ctx->chroma_dpb_size + ctx->me_buffer_size));
 		ctx->bank2.size = 0;
 		break;
@@ -181,7 +181,7 @@ static int s5p_mfc_alloc_codec_buffers_v6(struct s5p_mfc_ctx *ctx)
 				S5P_FIMV_SCRATCH_BUFFER_ALIGN_V6);
 		ctx->bank1.size =
 			ctx->scratch_buf_size + ctx->tmv_buffer_size +
-			(ctx->dpb_count * (ctx->luma_dpb_size +
+			(ctx->pb_count * (ctx->luma_dpb_size +
 			ctx->chroma_dpb_size + ctx->me_buffer_size));
 		ctx->bank2.size = 0;
 		break;
@@ -198,7 +198,6 @@ static int s5p_mfc_alloc_codec_buffers_v6(struct s5p_mfc_ctx *ctx)
 		}
 		BUG_ON(ctx->bank1.dma & ((1 << MFC_BANK1_ALIGN_ORDER) - 1));
 	}
-
 	return 0;
 }
 
@@ -497,7 +496,7 @@ static int s5p_mfc_set_enc_ref_buffer_v6(struct s5p_mfc_ctx *ctx)
 
 	mfc_debug(2, "Buf1: %p (%d)\n", (void *)buf_addr1, buf_size1);
 
-	for (i = 0; i < ctx->dpb_count; i++) {
+	for (i = 0; i < ctx->pb_count; i++) {
 		WRITEL(buf_addr1, S5P_FIMV_E_LUMA_DPB_V6 + (4 * i));
 		buf_addr1 += ctx->luma_dpb_size;
 		WRITEL(buf_addr1, S5P_FIMV_E_CHROMA_DPB_V6 + (4 * i));
@@ -520,7 +519,7 @@ static int s5p_mfc_set_enc_ref_buffer_v6(struct s5p_mfc_ctx *ctx)
 	buf_size1 -= ctx->tmv_buffer_size;
 
 	mfc_debug(2, "Buf1: %u, buf_size1: %d (ref frames %d)\n",
-			buf_addr1, buf_size1, ctx->dpb_count);
+			buf_addr1, buf_size1, ctx->pb_count);
 	if (buf_size1 < 0) {
 		mfc_debug(2, "Not enough memory has been allocated.\n");
 		return -ENOMEM;
@@ -1522,22 +1521,6 @@ static inline int s5p_mfc_run_init_enc_buffers(struct s5p_mfc_ctx *ctx)
 	struct s5p_mfc_dev *dev = ctx->dev;
 	int ret;
 
-	ret = s5p_mfc_alloc_codec_buffers_v6(ctx);
-	if (ret) {
-		mfc_err("Failed to allocate encoding buffers.\n");
-		return -ENOMEM;
-	}
-
-	/* Header was generated now starting processing
-	 * First set the reference frame buffers
-	 */
-	if (ctx->capture_state != QUEUE_BUFS_REQUESTED) {
-		mfc_err("It seems that destionation buffers were not\n"
-			"requested.MFC requires that header should be generated\n"
-			"before allocating codec buffer.\n");
-		return -EAGAIN;
-	}
-
 	dev->curr_ctx = ctx->num;
 	s5p_mfc_clean_ctx_int_flags(ctx);
 	ret = s5p_mfc_set_enc_ref_buffer_v6(ctx);
@@ -1582,7 +1565,7 @@ static void s5p_mfc_try_run_v6(struct s5p_mfc_dev *dev)
 	mfc_debug(1, "Seting new context to %p\n", ctx);
 	/* Got context to run in ctx */
 	mfc_debug(1, "ctx->dst_queue_cnt=%d ctx->dpb_count=%d ctx->src_queue_cnt=%d\n",
-		ctx->dst_queue_cnt, ctx->dpb_count, ctx->src_queue_cnt);
+		ctx->dst_queue_cnt, ctx->pb_count, ctx->src_queue_cnt);
 	mfc_debug(1, "ctx->state=%d\n", ctx->state);
 	/* Last frame has already been sent to MFC
 	 * Now obtaining frames from MFC buffer */
@@ -1647,7 +1630,7 @@ static void s5p_mfc_try_run_v6(struct s5p_mfc_dev *dev)
 		case MFCINST_GOT_INST:
 			s5p_mfc_run_init_enc(ctx);
 			break;
-		case MFCINST_HEAD_PARSED: /* Only for MFC6.x */
+		case MFCINST_HEAD_PRODUCED:
 			ret = s5p_mfc_run_init_enc_buffers(ctx);
 			break;
 		default:
-- 
1.7.9.5

