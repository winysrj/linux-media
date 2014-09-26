Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.samsung.com ([203.254.224.25]:8539 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752990AbaIZFA3 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 26 Sep 2014 01:00:29 -0400
Received: from epcpsbgr3.samsung.com
 (u143.gpu120.samsung.co.kr [203.254.230.143])
 by mailout2.samsung.com (Oracle Communications Messaging Server 7u4-24.01
 (7.0.4.24.0) 64bit (built Nov 17 2011))
 with ESMTP id <0NCH00LPXSKRQS40@mailout2.samsung.com> for
 linux-media@vger.kernel.org; Fri, 26 Sep 2014 14:00:27 +0900 (KST)
From: Kiran AVND <avnd.kiran@samsung.com>
To: linux-media@vger.kernel.org
Cc: k.debski@samsung.com, wuchengli@chromium.org, posciak@chromium.org,
	arun.m@samsung.com, ihf@chromium.org, prathyush.k@samsung.com,
	arun.kk@samsung.com, kiran@chromium.org
Subject: [PATCH v2 13/14] [media] s5p-mfc: fix a race in interrupt flags
 handling
Date: Fri, 26 Sep 2014 10:22:21 +0530
Message-id: <1411707142-4881-14-git-send-email-avnd.kiran@samsung.com>
In-reply-to: <1411707142-4881-1-git-send-email-avnd.kiran@samsung.com>
References: <1411707142-4881-1-git-send-email-avnd.kiran@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Pawel Osciak <posciak@chromium.org>

Interrupt result flags have to be cleared before a hardware job is run.
Otherwise, if they are cleared asynchronously, we may end up clearing them
after the interrupt for which we wanted to wait has already arrived, thus
overwriting the job results that we intended to wait for.

To prevent this, clear the flags only under hw_lock and before running
a hardware job.

Signed-off-by: Pawel Osciak <posciak@chromium.org>
Signed-off-by: Kiran AVND <avnd.kiran@samsung.com>
---
 drivers/media/platform/s5p-mfc/s5p_mfc_ctrl.c   |    2 --
 drivers/media/platform/s5p-mfc/s5p_mfc_dec.c    |    3 ---
 drivers/media/platform/s5p-mfc/s5p_mfc_enc.c    |    1 -
 drivers/media/platform/s5p-mfc/s5p_mfc_opr_v5.c |   13 ++-----------
 drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c |   12 ++----------
 5 files changed, 4 insertions(+), 27 deletions(-)

diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc_ctrl.c b/drivers/media/platform/s5p-mfc/s5p_mfc_ctrl.c
index 565a6ed..ca0a5cd 100644
--- a/drivers/media/platform/s5p-mfc/s5p_mfc_ctrl.c
+++ b/drivers/media/platform/s5p-mfc/s5p_mfc_ctrl.c
@@ -468,7 +468,6 @@ int s5p_mfc_open_mfc_inst(struct s5p_mfc_dev *dev, struct s5p_mfc_ctx *ctx)
 	}
 
 	set_work_bit_irqsave(ctx);
-	s5p_mfc_clean_ctx_int_flags(ctx);
 	s5p_mfc_hw_call(dev->mfc_ops, try_run, dev);
 	if (s5p_mfc_wait_for_done_ctx(ctx,
 		S5P_MFC_R2H_CMD_OPEN_INSTANCE_RET, 0)) {
@@ -494,7 +493,6 @@ void s5p_mfc_close_mfc_inst(struct s5p_mfc_dev *dev, struct s5p_mfc_ctx *ctx)
 {
 	ctx->state = MFCINST_RETURN_INST;
 	set_work_bit_irqsave(ctx);
-	s5p_mfc_clean_ctx_int_flags(ctx);
 	s5p_mfc_hw_call(dev->mfc_ops, try_run, dev);
 	/* Wait until instance is returned or timeout occurred */
 	if (s5p_mfc_wait_for_done_ctx(ctx,
diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc_dec.c b/drivers/media/platform/s5p-mfc/s5p_mfc_dec.c
index 301d74f..7eef03a 100644
--- a/drivers/media/platform/s5p-mfc/s5p_mfc_dec.c
+++ b/drivers/media/platform/s5p-mfc/s5p_mfc_dec.c
@@ -350,7 +350,6 @@ static int vidioc_g_fmt(struct file *file, void *priv, struct v4l2_format *f)
 						MFCINST_RES_CHANGE_END)) {
 		/* If the MFC is parsing the header,
 		 * so wait until it is finished */
-		s5p_mfc_clean_ctx_int_flags(ctx);
 		s5p_mfc_wait_for_done_ctx(ctx, S5P_MFC_R2H_CMD_SEQ_DONE_RET,
 									0);
 	}
@@ -762,7 +761,6 @@ static int s5p_mfc_dec_g_v_ctrl(struct v4l2_ctrl *ctrl)
 			return -EINVAL;
 		}
 		/* Should wait for the header to be parsed */
-		s5p_mfc_clean_ctx_int_flags(ctx);
 		s5p_mfc_wait_for_done_ctx(ctx,
 				S5P_MFC_R2H_CMD_SEQ_DONE_RET, 0);
 		if (ctx->state >= MFCINST_HEAD_PARSED &&
@@ -1076,7 +1074,6 @@ static void s5p_mfc_stop_streaming(struct vb2_queue *q)
 		if (IS_MFCV6_PLUS(dev) && (ctx->state == MFCINST_RUNNING)) {
 			ctx->state = MFCINST_FLUSH;
 			set_work_bit_irqsave(ctx);
-			s5p_mfc_clean_ctx_int_flags(ctx);
 			s5p_mfc_hw_call(dev->mfc_ops, try_run, dev);
 			if (s5p_mfc_wait_for_done_ctx(ctx,
 				S5P_MFC_R2H_CMD_DPB_FLUSH_RET, 0))
diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc_enc.c b/drivers/media/platform/s5p-mfc/s5p_mfc_enc.c
index 653f28f..407dc63 100644
--- a/drivers/media/platform/s5p-mfc/s5p_mfc_enc.c
+++ b/drivers/media/platform/s5p-mfc/s5p_mfc_enc.c
@@ -1679,7 +1679,6 @@ static int s5p_mfc_enc_g_v_ctrl(struct v4l2_ctrl *ctrl)
 			return -EINVAL;
 		}
 		/* Should wait for the header to be produced */
-		s5p_mfc_clean_ctx_int_flags(ctx);
 		s5p_mfc_wait_for_done_ctx(ctx,
 				S5P_MFC_R2H_CMD_SEQ_DONE_RET, 0);
 		if (ctx->state >= MFCINST_HEAD_PARSED &&
diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc_opr_v5.c b/drivers/media/platform/s5p-mfc/s5p_mfc_opr_v5.c
index f882905..40a98ad 100644
--- a/drivers/media/platform/s5p-mfc/s5p_mfc_opr_v5.c
+++ b/drivers/media/platform/s5p-mfc/s5p_mfc_opr_v5.c
@@ -1178,7 +1178,6 @@ static void s5p_mfc_run_res_change(struct s5p_mfc_ctx *ctx)
 
 	s5p_mfc_set_dec_stream_buffer_v5(ctx, 0, 0, 0);
 	dev->curr_ctx = ctx->num;
-	s5p_mfc_clean_ctx_int_flags(ctx);
 	s5p_mfc_decode_one_frame_v5(ctx, MFC_DEC_RES_CHANGE);
 }
 
@@ -1192,7 +1191,6 @@ static int s5p_mfc_run_dec_frame(struct s5p_mfc_ctx *ctx, int last_frame)
 		last_frame = MFC_DEC_LAST_FRAME;
 		s5p_mfc_set_dec_stream_buffer_v5(ctx, 0, 0, 0);
 		dev->curr_ctx = ctx->num;
-		s5p_mfc_clean_ctx_int_flags(ctx);
 		s5p_mfc_decode_one_frame_v5(ctx, last_frame);
 		return 0;
 	}
@@ -1212,7 +1210,6 @@ static int s5p_mfc_run_dec_frame(struct s5p_mfc_ctx *ctx, int last_frame)
 		ctx->consumed_stream, temp_vb->b->v4l2_planes[0].bytesused);
 	spin_unlock_irqrestore(&dev->irqlock, flags);
 	dev->curr_ctx = ctx->num;
-	s5p_mfc_clean_ctx_int_flags(ctx);
 	if (temp_vb->b->v4l2_planes[0].bytesused == 0) {
 		last_frame = MFC_DEC_LAST_FRAME;
 		mfc_debug(2, "Setting ctx->state to FINISHING\n");
@@ -1273,7 +1270,6 @@ static int s5p_mfc_run_enc_frame(struct s5p_mfc_ctx *ctx)
 	s5p_mfc_set_enc_stream_buffer_v5(ctx, dst_addr, dst_size);
 	spin_unlock_irqrestore(&dev->irqlock, flags);
 	dev->curr_ctx = ctx->num;
-	s5p_mfc_clean_ctx_int_flags(ctx);
 	mfc_debug(2, "encoding buffer with index=%d state=%d\n",
 		  src_mb ? src_mb->b->v4l2_buf.index : -1, ctx->state);
 	s5p_mfc_encode_one_frame_v5(ctx);
@@ -1297,7 +1293,6 @@ static void s5p_mfc_run_init_dec(struct s5p_mfc_ctx *ctx)
 				0, temp_vb->b->v4l2_planes[0].bytesused);
 	spin_unlock_irqrestore(&dev->irqlock, flags);
 	dev->curr_ctx = ctx->num;
-	s5p_mfc_clean_ctx_int_flags(ctx);
 	s5p_mfc_init_decode_v5(ctx);
 }
 
@@ -1317,7 +1312,6 @@ static void s5p_mfc_run_init_enc(struct s5p_mfc_ctx *ctx)
 	s5p_mfc_set_enc_stream_buffer_v5(ctx, dst_addr, dst_size);
 	spin_unlock_irqrestore(&dev->irqlock, flags);
 	dev->curr_ctx = ctx->num;
-	s5p_mfc_clean_ctx_int_flags(ctx);
 	s5p_mfc_init_encode_v5(ctx);
 }
 
@@ -1352,7 +1346,6 @@ static int s5p_mfc_run_init_dec_buffers(struct s5p_mfc_ctx *ctx)
 				0, temp_vb->b->v4l2_planes[0].bytesused);
 	spin_unlock_irqrestore(&dev->irqlock, flags);
 	dev->curr_ctx = ctx->num;
-	s5p_mfc_clean_ctx_int_flags(ctx);
 	ret = s5p_mfc_set_dec_frame_buffer_v5(ctx);
 	if (ret) {
 		mfc_err("Failed to alloc frame mem\n");
@@ -1396,6 +1389,8 @@ static void s5p_mfc_try_run_v5(struct s5p_mfc_dev *dev)
 	 * Now obtaining frames from MFC buffer
 	 */
 	s5p_mfc_clock_on();
+	s5p_mfc_clean_ctx_int_flags(ctx);
+
 	if (ctx->type == MFCINST_DECODER) {
 		s5p_mfc_set_dec_desc_buffer(ctx);
 		switch (ctx->state) {
@@ -1406,12 +1401,10 @@ static void s5p_mfc_try_run_v5(struct s5p_mfc_dev *dev)
 			ret = s5p_mfc_run_dec_frame(ctx, MFC_DEC_FRAME);
 			break;
 		case MFCINST_INIT:
-			s5p_mfc_clean_ctx_int_flags(ctx);
 			ret = s5p_mfc_hw_call(dev->mfc_cmds, open_inst_cmd,
 					ctx);
 			break;
 		case MFCINST_RETURN_INST:
-			s5p_mfc_clean_ctx_int_flags(ctx);
 			ret = s5p_mfc_hw_call(dev->mfc_cmds, close_inst_cmd,
 					ctx);
 			break;
@@ -1444,12 +1437,10 @@ static void s5p_mfc_try_run_v5(struct s5p_mfc_dev *dev)
 			ret = s5p_mfc_run_enc_frame(ctx);
 			break;
 		case MFCINST_INIT:
-			s5p_mfc_clean_ctx_int_flags(ctx);
 			ret = s5p_mfc_hw_call(dev->mfc_cmds, open_inst_cmd,
 					ctx);
 			break;
 		case MFCINST_RETURN_INST:
-			s5p_mfc_clean_ctx_int_flags(ctx);
 			ret = s5p_mfc_hw_call(dev->mfc_cmds, close_inst_cmd,
 					ctx);
 			break;
diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c b/drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c
index 991008a..9104a75 100644
--- a/drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c
+++ b/drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c
@@ -1399,7 +1399,6 @@ static inline void s5p_mfc_set_flush(struct s5p_mfc_ctx *ctx, int flush)
 
 	if (flush) {
 		dev->curr_ctx = ctx->num;
-		s5p_mfc_clean_ctx_int_flags(ctx);
 		WRITEL(ctx->inst_no, mfc_regs->instance_id);
 		s5p_mfc_hw_call(dev->mfc_cmds, cmd_host2risc, dev,
 				S5P_FIMV_H2R_CMD_FLUSH_V6, NULL);
@@ -1540,7 +1539,6 @@ static inline void s5p_mfc_run_dec_last_frames(struct s5p_mfc_ctx *ctx)
 
 	s5p_mfc_set_dec_stream_buffer_v6(ctx, 0, 0, 0);
 	dev->curr_ctx = ctx->num;
-	s5p_mfc_clean_ctx_int_flags(ctx);
 	s5p_mfc_decode_one_frame_v6(ctx, MFC_DEC_LAST_FRAME);
 }
 
@@ -1577,7 +1575,6 @@ static inline int s5p_mfc_run_dec_frame(struct s5p_mfc_ctx *ctx)
 	spin_unlock_irqrestore(&dev->irqlock, flags);
 
 	dev->curr_ctx = ctx->num;
-	s5p_mfc_clean_ctx_int_flags(ctx);
 	if (temp_vb->b->v4l2_planes[0].bytesused == 0) {
 		last_frame = 1;
 		mfc_debug(2, "Setting ctx->state to FINISHING\n");
@@ -1634,7 +1631,6 @@ static inline int s5p_mfc_run_enc_frame(struct s5p_mfc_ctx *ctx)
 	spin_unlock_irqrestore(&dev->irqlock, flags);
 
 	dev->curr_ctx = ctx->num;
-	s5p_mfc_clean_ctx_int_flags(ctx);
 	s5p_mfc_encode_one_frame_v6(ctx);
 
 	return 0;
@@ -1656,7 +1652,6 @@ static inline void s5p_mfc_run_init_dec(struct s5p_mfc_ctx *ctx)
 			temp_vb->b->v4l2_planes[0].bytesused);
 	spin_unlock_irqrestore(&dev->irqlock, flags);
 	dev->curr_ctx = ctx->num;
-	s5p_mfc_clean_ctx_int_flags(ctx);
 	s5p_mfc_init_decode_v6(ctx);
 }
 
@@ -1676,7 +1671,6 @@ static inline void s5p_mfc_run_init_enc(struct s5p_mfc_ctx *ctx)
 	s5p_mfc_set_enc_stream_buffer_v6(ctx, dst_addr, dst_size);
 	spin_unlock_irqrestore(&dev->irqlock, flags);
 	dev->curr_ctx = ctx->num;
-	s5p_mfc_clean_ctx_int_flags(ctx);
 	s5p_mfc_init_encode_v6(ctx);
 }
 
@@ -1696,7 +1690,6 @@ static inline int s5p_mfc_run_init_dec_buffers(struct s5p_mfc_ctx *ctx)
 	}
 
 	dev->curr_ctx = ctx->num;
-	s5p_mfc_clean_ctx_int_flags(ctx);
 	ret = s5p_mfc_set_dec_frame_buffer_v6(ctx);
 	if (ret) {
 		mfc_err("Failed to alloc frame mem.\n");
@@ -1711,7 +1704,6 @@ static inline int s5p_mfc_run_init_enc_buffers(struct s5p_mfc_ctx *ctx)
 	int ret;
 
 	dev->curr_ctx = ctx->num;
-	s5p_mfc_clean_ctx_int_flags(ctx);
 	ret = s5p_mfc_set_enc_ref_buffer_v6(ctx);
 	if (ret) {
 		mfc_err("Failed to alloc frame mem.\n");
@@ -1760,6 +1752,8 @@ static void s5p_mfc_try_run_v6(struct s5p_mfc_dev *dev)
 	 * Now obtaining frames from MFC buffer */
 
 	s5p_mfc_clock_on();
+	s5p_mfc_clean_ctx_int_flags(ctx);
+
 	if (ctx->type == MFCINST_DECODER) {
 		switch (ctx->state) {
 		case MFCINST_FINISHING:
@@ -1769,12 +1763,10 @@ static void s5p_mfc_try_run_v6(struct s5p_mfc_dev *dev)
 			ret = s5p_mfc_run_dec_frame(ctx);
 			break;
 		case MFCINST_INIT:
-			s5p_mfc_clean_ctx_int_flags(ctx);
 			ret = s5p_mfc_hw_call(dev->mfc_cmds, open_inst_cmd,
 					ctx);
 			break;
 		case MFCINST_RETURN_INST:
-			s5p_mfc_clean_ctx_int_flags(ctx);
 			ret = s5p_mfc_hw_call(dev->mfc_cmds, close_inst_cmd,
 					ctx);
 			break;
-- 
1.7.9.5

