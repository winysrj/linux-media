Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.samsung.com ([203.254.224.34]:28615 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757407Ab2KVUDe (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 22 Nov 2012 15:03:34 -0500
Received: from epcpsbgm2.samsung.com (epcpsbgm2 [203.254.230.27])
 by mailout4.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MDV00GVEVGKE3Q0@mailout4.samsung.com> for
 linux-media@vger.kernel.org; Thu, 22 Nov 2012 18:53:30 +0900 (KST)
Received: from localhost.localdomain ([107.108.73.106])
 by mmp1.samsung.com (Oracle Communications Messaging Server 7u4-24.01
 (7.0.4.24.0) 64bit (built Nov 17 2011))
 with ESMTPA id <0MDV00DYRVFJUT40@mmp1.samsung.com> for
 linux-media@vger.kernel.org; Thu, 22 Nov 2012 18:53:30 +0900 (KST)
From: Arun Kumar K <arun.kk@samsung.com>
To: linux-media@vger.kernel.org
Cc: k.debski@samsung.com, jtp.park@samsung.com, s.nawrocki@samsung.com,
	arun.m@samsung.com, arun.kk@samsung.com
Subject: [PATCH] [media] s5p-mfc: Flush DPB buffers during stream off
Date: Thu, 22 Nov 2012 15:45:55 +0530
Message-id: <1353579355-11994-1-git-send-email-arun.kk@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Flushing of delay DPB buffers have to be done during stream off.
In MFC v6, it is done with a risc to host command.

Signed-off-by: Arun Kumar K <arun.kk@samsung.com>
Signed-off-by: Arun Mankuzhi <arun.m@samsung.com>
---
 drivers/media/platform/s5p-mfc/s5p_mfc.c        |    6 ++++++
 drivers/media/platform/s5p-mfc/s5p_mfc_common.h |    1 +
 drivers/media/platform/s5p-mfc/s5p_mfc_dec.c    |   15 +++++++++++++--
 drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c |   17 +++++++++++------
 4 files changed, 31 insertions(+), 8 deletions(-)

diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc.c b/drivers/media/platform/s5p-mfc/s5p_mfc.c
index d3cd738..b73b6f2 100644
--- a/drivers/media/platform/s5p-mfc/s5p_mfc.c
+++ b/drivers/media/platform/s5p-mfc/s5p_mfc.c
@@ -691,6 +691,12 @@ static irqreturn_t s5p_mfc_irq(int irq, void *priv)
 		s5p_mfc_handle_stream_complete(ctx, reason, err);
 		break;
 
+	case S5P_MFC_R2H_CMD_DPB_FLUSH_RET:
+		clear_work_bit(ctx);
+		ctx->state = MFCINST_RUNNING;
+		wake_up(&ctx->queue);
+		goto irq_cleanup_hw;
+
 	default:
 		mfc_debug(2, "Unknown int reason\n");
 		s5p_mfc_hw_call(dev->mfc_ops, clear_int_flags, dev);
diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc_common.h b/drivers/media/platform/s5p-mfc/s5p_mfc_common.h
index f02e049..3b9b600 100644
--- a/drivers/media/platform/s5p-mfc/s5p_mfc_common.h
+++ b/drivers/media/platform/s5p-mfc/s5p_mfc_common.h
@@ -145,6 +145,7 @@ enum s5p_mfc_inst_state {
 	MFCINST_RETURN_INST,
 	MFCINST_ERROR,
 	MFCINST_ABORT,
+	MFCINST_FLUSH,
 	MFCINST_RES_CHANGE_INIT,
 	MFCINST_RES_CHANGE_FLUSH,
 	MFCINST_RES_CHANGE_END,
diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc_dec.c b/drivers/media/platform/s5p-mfc/s5p_mfc_dec.c
index eb6a70b..4ba62f6 100644
--- a/drivers/media/platform/s5p-mfc/s5p_mfc_dec.c
+++ b/drivers/media/platform/s5p-mfc/s5p_mfc_dec.c
@@ -977,24 +977,35 @@ static int s5p_mfc_stop_streaming(struct vb2_queue *q)
 					S5P_MFC_R2H_CMD_FRAME_DONE_RET, 0);
 		aborted = 1;
 	}
-	spin_lock_irqsave(&dev->irqlock, flags);
 	if (q->type == V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE) {
+		spin_lock_irqsave(&dev->irqlock, flags);
 		s5p_mfc_hw_call(dev->mfc_ops, cleanup_queue, &ctx->dst_queue,
 				&ctx->vq_dst);
 		INIT_LIST_HEAD(&ctx->dst_queue);
 		ctx->dst_queue_cnt = 0;
 		ctx->dpb_flush_flag = 1;
 		ctx->dec_dst_flag = 0;
+		spin_unlock_irqrestore(&dev->irqlock, flags);
+		if (IS_MFCV6(dev) && (ctx->state == MFCINST_RUNNING)) {
+			ctx->state = MFCINST_FLUSH;
+			set_work_bit_irqsave(ctx);
+			s5p_mfc_clean_ctx_int_flags(ctx);
+			s5p_mfc_hw_call(dev->mfc_ops, try_run, dev);
+			if (s5p_mfc_wait_for_done_ctx(ctx,
+				S5P_MFC_R2H_CMD_DPB_FLUSH_RET, 0))
+				mfc_err("Err flushing buffers\n");
+		}
 	}
 	if (q->type == V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE) {
+		spin_lock_irqsave(&dev->irqlock, flags);
 		s5p_mfc_hw_call(dev->mfc_ops, cleanup_queue, &ctx->src_queue,
 				&ctx->vq_src);
 		INIT_LIST_HEAD(&ctx->src_queue);
 		ctx->src_queue_cnt = 0;
+		spin_unlock_irqrestore(&dev->irqlock, flags);
 	}
 	if (aborted)
 		ctx->state = MFCINST_RUNNING;
-	spin_unlock_irqrestore(&dev->irqlock, flags);
 	return 0;
 }
 
diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c b/drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c
index 3a8cfd9..a47e6db 100644
--- a/drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c
+++ b/drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c
@@ -1253,12 +1253,14 @@ int s5p_mfc_init_decode_v6(struct s5p_mfc_ctx *ctx)
 static inline void s5p_mfc_set_flush(struct s5p_mfc_ctx *ctx, int flush)
 {
 	struct s5p_mfc_dev *dev = ctx->dev;
-	unsigned int dpb;
-	if (flush)
-		dpb = READL(S5P_FIMV_SI_CH0_DPB_CONF_CTRL) | (1 << 14);
-	else
-		dpb = READL(S5P_FIMV_SI_CH0_DPB_CONF_CTRL) & ~(1 << 14);
-	WRITEL(dpb, S5P_FIMV_SI_CH0_DPB_CONF_CTRL);
+
+	if (flush) {
+		dev->curr_ctx = ctx->num;
+		s5p_mfc_clean_ctx_int_flags(ctx);
+		WRITEL(ctx->inst_no, S5P_FIMV_INSTANCE_ID_V6);
+		s5p_mfc_hw_call(dev->mfc_cmds, cmd_host2risc, dev,
+				S5P_FIMV_H2R_CMD_FLUSH_V6, NULL);
+	}
 }
 
 /* Decode a single frame */
@@ -1656,6 +1658,9 @@ void s5p_mfc_try_run_v6(struct s5p_mfc_dev *dev)
 		case MFCINST_HEAD_PARSED:
 			ret = s5p_mfc_run_init_dec_buffers(ctx);
 			break;
+		case MFCINST_FLUSH:
+			s5p_mfc_set_flush(ctx, ctx->dpb_flush_flag);
+			break;
 		case MFCINST_RES_CHANGE_INIT:
 			s5p_mfc_run_dec_last_frames(ctx);
 			break;
-- 
1.7.0.4

