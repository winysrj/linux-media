Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.samsung.com ([203.254.224.33]:44592 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751250Ab3FYKdq (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 25 Jun 2013 06:33:46 -0400
Received: from epcpsbgr2.samsung.com
 (u142.gpu120.samsung.co.kr [203.254.230.142])
 by mailout3.samsung.com (Oracle Communications Messaging Server 7u4-24.01
 (7.0.4.24.0) 64bit (built Nov 17 2011))
 with ESMTP id <0MOY008OL2O1QT30@mailout3.samsung.com> for
 linux-media@vger.kernel.org; Tue, 25 Jun 2013 19:33:45 +0900 (KST)
From: Arun Kumar K <arun.kk@samsung.com>
To: linux-media@vger.kernel.org
Cc: k.debski@samsung.com, jtp.park@samsung.com, s.nawrocki@samsung.com,
	hverkuil@xs4all.nl, avnd.kiran@samsung.com,
	arunkk.samsung@gmail.com
Subject: [PATCH v3 2/8] [media] s5p-mfc: Rename IS_MFCV6 macro
Date: Tue, 25 Jun 2013 16:27:09 +0530
Message-id: <1372157835-27663-3-git-send-email-arun.kk@samsung.com>
In-reply-to: <1372157835-27663-1-git-send-email-arun.kk@samsung.com>
References: <1372157835-27663-1-git-send-email-arun.kk@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The MFC v6 specific code holds good for MFC v7 also as
the v7 version is a superset of v6 and the HW interface
remains more or less similar. This patch renames the macro
IS_MFCV6() to IS_MFCV6_PLUS() so that it can be used
for v7 also.

Signed-off-by: Arun Kumar K <arun.kk@samsung.com>
---
 drivers/media/platform/s5p-mfc/s5p_mfc_cmd.c    |    2 +-
 drivers/media/platform/s5p-mfc/s5p_mfc_common.h |    2 +-
 drivers/media/platform/s5p-mfc/s5p_mfc_ctrl.c   |   12 ++++++------
 drivers/media/platform/s5p-mfc/s5p_mfc_dec.c    |   18 ++++++++++--------
 drivers/media/platform/s5p-mfc/s5p_mfc_enc.c    |   16 +++++++++-------
 drivers/media/platform/s5p-mfc/s5p_mfc_opr.c    |    2 +-
 6 files changed, 28 insertions(+), 24 deletions(-)

diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc_cmd.c b/drivers/media/platform/s5p-mfc/s5p_mfc_cmd.c
index f0a41c9..242c033 100644
--- a/drivers/media/platform/s5p-mfc/s5p_mfc_cmd.c
+++ b/drivers/media/platform/s5p-mfc/s5p_mfc_cmd.c
@@ -20,7 +20,7 @@ static struct s5p_mfc_hw_cmds *s5p_mfc_cmds;
 
 void s5p_mfc_init_hw_cmds(struct s5p_mfc_dev *dev)
 {
-	if (IS_MFCV6(dev))
+	if (IS_MFCV6_PLUS(dev))
 		s5p_mfc_cmds = s5p_mfc_init_hw_cmds_v6();
 	else
 		s5p_mfc_cmds = s5p_mfc_init_hw_cmds_v5();
diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc_common.h b/drivers/media/platform/s5p-mfc/s5p_mfc_common.h
index ef4074c..d47016d 100644
--- a/drivers/media/platform/s5p-mfc/s5p_mfc_common.h
+++ b/drivers/media/platform/s5p-mfc/s5p_mfc_common.h
@@ -683,6 +683,6 @@ void set_work_bit_irqsave(struct s5p_mfc_ctx *ctx);
 #define HAS_PORTNUM(dev)	(dev ? (dev->variant ? \
 				(dev->variant->port_num ? 1 : 0) : 0) : 0)
 #define IS_TWOPORT(dev)		(dev->variant->port_num == 2 ? 1 : 0)
-#define IS_MFCV6(dev)		(dev->variant->version >= 0x60 ? 1 : 0)
+#define IS_MFCV6_PLUS(dev)	(dev->variant->version >= 0x60 ? 1 : 0)
 
 #endif /* S5P_MFC_COMMON_H_ */
diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc_ctrl.c b/drivers/media/platform/s5p-mfc/s5p_mfc_ctrl.c
index dc1fc94..7cab684 100644
--- a/drivers/media/platform/s5p-mfc/s5p_mfc_ctrl.c
+++ b/drivers/media/platform/s5p-mfc/s5p_mfc_ctrl.c
@@ -164,7 +164,7 @@ int s5p_mfc_reset(struct s5p_mfc_dev *dev)
 
 	mfc_debug_enter();
 
-	if (IS_MFCV6(dev)) {
+	if (IS_MFCV6_PLUS(dev)) {
 		/* Reset IP */
 		/*  except RISC, reset */
 		mfc_write(dev, 0xFEE, S5P_FIMV_MFC_RESET_V6);
@@ -213,7 +213,7 @@ int s5p_mfc_reset(struct s5p_mfc_dev *dev)
 
 static inline void s5p_mfc_init_memctrl(struct s5p_mfc_dev *dev)
 {
-	if (IS_MFCV6(dev)) {
+	if (IS_MFCV6_PLUS(dev)) {
 		mfc_write(dev, dev->bank1, S5P_FIMV_RISC_BASE_ADDRESS_V6);
 		mfc_debug(2, "Base Address : %08x\n", dev->bank1);
 	} else {
@@ -226,7 +226,7 @@ static inline void s5p_mfc_init_memctrl(struct s5p_mfc_dev *dev)
 
 static inline void s5p_mfc_clear_cmds(struct s5p_mfc_dev *dev)
 {
-	if (IS_MFCV6(dev)) {
+	if (IS_MFCV6_PLUS(dev)) {
 		/* Zero initialization should be done before RESET.
 		 * Nothing to do here. */
 	} else {
@@ -264,7 +264,7 @@ int s5p_mfc_init_hw(struct s5p_mfc_dev *dev)
 	s5p_mfc_clear_cmds(dev);
 	/* 3. Release reset signal to the RISC */
 	s5p_mfc_clean_dev_int_flags(dev);
-	if (IS_MFCV6(dev))
+	if (IS_MFCV6_PLUS(dev))
 		mfc_write(dev, 0x1, S5P_FIMV_RISC_ON_V6);
 	else
 		mfc_write(dev, 0x3ff, S5P_FIMV_SW_RESET);
@@ -301,7 +301,7 @@ int s5p_mfc_init_hw(struct s5p_mfc_dev *dev)
 		s5p_mfc_clock_off();
 		return -EIO;
 	}
-	if (IS_MFCV6(dev))
+	if (IS_MFCV6_PLUS(dev))
 		ver = mfc_read(dev, S5P_FIMV_FW_VERSION_V6);
 	else
 		ver = mfc_read(dev, S5P_FIMV_FW_VERSION);
@@ -380,7 +380,7 @@ int s5p_mfc_wakeup(struct s5p_mfc_dev *dev)
 		return ret;
 	}
 	/* 4. Release reset signal to the RISC */
-	if (IS_MFCV6(dev))
+	if (IS_MFCV6_PLUS(dev))
 		mfc_write(dev, 0x1, S5P_FIMV_RISC_ON_V6);
 	else
 		mfc_write(dev, 0x3ff, S5P_FIMV_SW_RESET);
diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc_dec.c b/drivers/media/platform/s5p-mfc/s5p_mfc_dec.c
index 00b0703..56a1d3b 100644
--- a/drivers/media/platform/s5p-mfc/s5p_mfc_dec.c
+++ b/drivers/media/platform/s5p-mfc/s5p_mfc_dec.c
@@ -382,7 +382,7 @@ static int vidioc_try_fmt(struct file *file, void *priv, struct v4l2_format *f)
 			mfc_err("Unsupported format for source.\n");
 			return -EINVAL;
 		}
-		if (!IS_MFCV6(dev) && (fmt->fourcc == V4L2_PIX_FMT_VP8)) {
+		if (!IS_MFCV6_PLUS(dev) && (fmt->fourcc == V4L2_PIX_FMT_VP8)) {
 			mfc_err("Not supported format.\n");
 			return -EINVAL;
 		}
@@ -392,10 +392,11 @@ static int vidioc_try_fmt(struct file *file, void *priv, struct v4l2_format *f)
 			mfc_err("Unsupported format for destination.\n");
 			return -EINVAL;
 		}
-		if (IS_MFCV6(dev) && (fmt->fourcc == V4L2_PIX_FMT_NV12MT)) {
+		if (IS_MFCV6_PLUS(dev) &&
+				(fmt->fourcc == V4L2_PIX_FMT_NV12MT)) {
 			mfc_err("Not supported format.\n");
 			return -EINVAL;
-		} else if (!IS_MFCV6(dev) &&
+		} else if (!IS_MFCV6_PLUS(dev) &&
 				(fmt->fourcc != V4L2_PIX_FMT_NV12MT)) {
 			mfc_err("Not supported format.\n");
 			return -EINVAL;
@@ -430,10 +431,11 @@ static int vidioc_s_fmt(struct file *file, void *priv, struct v4l2_format *f)
 			mfc_err("Unsupported format for source.\n");
 			return -EINVAL;
 		}
-		if (!IS_MFCV6(dev) && (fmt->fourcc != V4L2_PIX_FMT_NV12MT)) {
+		if (!IS_MFCV6_PLUS(dev) &&
+				(fmt->fourcc != V4L2_PIX_FMT_NV12MT)) {
 			mfc_err("Not supported format.\n");
 			return -EINVAL;
-		} else if (IS_MFCV6(dev) &&
+		} else if (IS_MFCV6_PLUS(dev) &&
 				(fmt->fourcc == V4L2_PIX_FMT_NV12MT)) {
 			mfc_err("Not supported format.\n");
 			return -EINVAL;
@@ -457,7 +459,7 @@ static int vidioc_s_fmt(struct file *file, void *priv, struct v4l2_format *f)
 		ret = -EINVAL;
 		goto out;
 	}
-	if (!IS_MFCV6(dev) && (fmt->fourcc == V4L2_PIX_FMT_VP8)) {
+	if (!IS_MFCV6_PLUS(dev) && (fmt->fourcc == V4L2_PIX_FMT_VP8)) {
 		mfc_err("Not supported format.\n");
 		return -EINVAL;
 	}
@@ -942,7 +944,7 @@ static int s5p_mfc_queue_setup(struct vb2_queue *vq,
 		psize[0] = ctx->luma_size;
 		psize[1] = ctx->chroma_size;
 
-		if (IS_MFCV6(dev))
+		if (IS_MFCV6_PLUS(dev))
 			allocators[0] =
 				ctx->dev->alloc_ctx[MFC_BANK1_ALLOC_CTX];
 		else
@@ -1067,7 +1069,7 @@ static int s5p_mfc_stop_streaming(struct vb2_queue *q)
 		ctx->dpb_flush_flag = 1;
 		ctx->dec_dst_flag = 0;
 		spin_unlock_irqrestore(&dev->irqlock, flags);
-		if (IS_MFCV6(dev) && (ctx->state == MFCINST_RUNNING)) {
+		if (IS_MFCV6_PLUS(dev) && (ctx->state == MFCINST_RUNNING)) {
 			ctx->state = MFCINST_FLUSH;
 			set_work_bit_irqsave(ctx);
 			s5p_mfc_clean_ctx_int_flags(ctx);
diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc_enc.c b/drivers/media/platform/s5p-mfc/s5p_mfc_enc.c
index 2549967..f734ccc 100644
--- a/drivers/media/platform/s5p-mfc/s5p_mfc_enc.c
+++ b/drivers/media/platform/s5p-mfc/s5p_mfc_enc.c
@@ -663,7 +663,7 @@ static int enc_post_seq_start(struct s5p_mfc_ctx *ctx)
 		spin_unlock_irqrestore(&dev->irqlock, flags);
 	}
 
-	if (!IS_MFCV6(dev)) {
+	if (!IS_MFCV6_PLUS(dev)) {
 		ctx->state = MFCINST_RUNNING;
 		if (s5p_mfc_ctx_ready(ctx))
 			set_work_bit_irqsave(ctx);
@@ -993,11 +993,11 @@ static int vidioc_s_fmt(struct file *file, void *priv, struct v4l2_format *f)
 			return -EINVAL;
 		}
 
-		if (!IS_MFCV6(dev) &&
+		if (!IS_MFCV6_PLUS(dev) &&
 				(fmt->fourcc == V4L2_PIX_FMT_NV12MT_16X16)) {
 			mfc_err("Not supported format.\n");
 			return -EINVAL;
-		} else if (IS_MFCV6(dev) &&
+		} else if (IS_MFCV6_PLUS(dev) &&
 				(fmt->fourcc == V4L2_PIX_FMT_NV12MT)) {
 			mfc_err("Not supported format.\n");
 			return -EINVAL;
@@ -1072,7 +1072,7 @@ static int vidioc_reqbufs(struct file *file, void *priv,
 			return -EINVAL;
 		}
 
-		if (IS_MFCV6(dev)) {
+		if (IS_MFCV6_PLUS(dev)) {
 			/* Check for min encoder buffers */
 			if (ctx->pb_count &&
 				(reqbufs->count < ctx->pb_count)) {
@@ -1353,7 +1353,7 @@ static int s5p_mfc_enc_s_ctrl(struct v4l2_ctrl *ctrl)
 				S5P_FIMV_ENC_PROFILE_H264_BASELINE;
 			break;
 		case V4L2_MPEG_VIDEO_H264_PROFILE_CONSTRAINED_BASELINE:
-			if (IS_MFCV6(dev))
+			if (IS_MFCV6_PLUS(dev))
 				p->codec.h264.profile =
 				S5P_FIMV_ENC_PROFILE_H264_CONSTRAINED_BASELINE;
 			else
@@ -1662,9 +1662,10 @@ static int s5p_mfc_queue_setup(struct vb2_queue *vq,
 			*buf_count = 1;
 		if (*buf_count > MFC_MAX_BUFFERS)
 			*buf_count = MFC_MAX_BUFFERS;
+
 		psize[0] = ctx->luma_size;
 		psize[1] = ctx->chroma_size;
-		if (IS_MFCV6(dev)) {
+		if (IS_MFCV6_PLUS(dev)) {
 			allocators[0] =
 				ctx->dev->alloc_ctx[MFC_BANK1_ALLOC_CTX];
 			allocators[1] =
@@ -1773,7 +1774,8 @@ static int s5p_mfc_start_streaming(struct vb2_queue *q, unsigned int count)
 	struct s5p_mfc_ctx *ctx = fh_to_ctx(q->drv_priv);
 	struct s5p_mfc_dev *dev = ctx->dev;
 
-	if (IS_MFCV6(dev) && (q->type == V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE)) {
+	if (IS_MFCV6_PLUS(dev) &&
+			(q->type == V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE)) {
 
 		if ((ctx->state == MFCINST_GOT_INST) &&
 			(dev->curr_ctx == ctx->num) && dev->hw_lock) {
diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc_opr.c b/drivers/media/platform/s5p-mfc/s5p_mfc_opr.c
index 10f8ac3..3c01c33 100644
--- a/drivers/media/platform/s5p-mfc/s5p_mfc_opr.c
+++ b/drivers/media/platform/s5p-mfc/s5p_mfc_opr.c
@@ -21,7 +21,7 @@ static struct s5p_mfc_hw_ops *s5p_mfc_ops;
 
 void s5p_mfc_init_hw_ops(struct s5p_mfc_dev *dev)
 {
-	if (IS_MFCV6(dev)) {
+	if (IS_MFCV6_PLUS(dev)) {
 		s5p_mfc_ops = s5p_mfc_init_hw_ops_v6();
 		dev->warn_start = S5P_FIMV_ERR_WARNINGS_START_V6;
 	} else {
-- 
1.7.9.5

