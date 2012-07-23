Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.samsung.com ([203.254.224.25]:51420 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752673Ab2GWMO1 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 23 Jul 2012 08:14:27 -0400
Received: from epcpsbgm1.samsung.com (mailout2.samsung.com [203.254.224.25])
 by mailout2.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0M7M008DT4NTNKU0@mailout2.samsung.com> for
 linux-media@vger.kernel.org; Mon, 23 Jul 2012 21:14:24 +0900 (KST)
Received: from localhost.localdomain ([107.108.73.106])
 by mmp1.samsung.com (Oracle Communications Messaging Server 7u4-24.01
 (7.0.4.24.0) 64bit (built Nov 17 2011))
 with ESMTPA id <0M7M006154NPVNB0@mmp1.samsung.com> for
 linux-media@vger.kernel.org; Mon, 23 Jul 2012 21:14:24 +0900 (KST)
From: Arun Kumar K <arun.kk@samsung.com>
To: linux-media@vger.kernel.org
Cc: jtp.park@samsung.com, janghyuck.kim@samsung.com,
	jaeryul.oh@samsung.com, ch.naveen@samsung.com, arun.kk@samsung.com,
	m.szyprowski@samsung.com, k.debski@samsung.com,
	kmpark@infradead.org, joshi@samsung.com
Subject: [PATCH v3 2/4] [media] s5p-mfc: Decoder and encoder common files
Date: Mon, 23 Jul 2012 17:59:15 +0530
Message-id: <1343046557-25353-3-git-send-email-arun.kk@samsung.com>
In-reply-to: <1343046557-25353-1-git-send-email-arun.kk@samsung.com>
References: <1343046557-25353-1-git-send-email-arun.kk@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Jeongtae Park <jtp.park@samsung.com>

New v4l controls for the MFCv6 firmware are implemented. Also
modifies the files for v5 and v6 coexistence.

Signed-off-by: Jeongtae Park <jtp.park@samsung.com>
Singed-off-by: Janghyuck Kim <janghyuck.kim@samsung.com>
Singed-off-by: Jaeryul Oh <jaeryul.oh@samsung.com>
Signed-off-by: Naveen Krishna Chatradhi <ch.naveen@samsung.com>
Signed-off-by: Arun Kumar K <arun.kk@samsung.com>
---
 drivers/media/video/s5p-mfc/s5p_mfc_dec.c |  223 ++++++++++++++++++++---------
 drivers/media/video/s5p-mfc/s5p_mfc_dec.h |    1 +
 drivers/media/video/s5p-mfc/s5p_mfc_enc.c |  200 +++++++++++++++-----------
 drivers/media/video/s5p-mfc/s5p_mfc_enc.h |    1 +
 4 files changed, 271 insertions(+), 154 deletions(-)

diff --git a/drivers/media/video/s5p-mfc/s5p_mfc_dec.c b/drivers/media/video/s5p-mfc/s5p_mfc_dec.c
index 4dd32fc..cc1eba4 100644
--- a/drivers/media/video/s5p-mfc/s5p_mfc_dec.c
+++ b/drivers/media/video/s5p-mfc/s5p_mfc_dec.c
@@ -23,85 +23,114 @@
 #include <linux/workqueue.h>
 #include <media/v4l2-ctrls.h>
 #include <media/videobuf2-core.h>
-#include "regs-mfc.h"
 #include "s5p_mfc_common.h"
 #include "s5p_mfc_debug.h"
 #include "s5p_mfc_dec.h"
 #include "s5p_mfc_intr.h"
 #include "s5p_mfc_opr.h"
 #include "s5p_mfc_pm.h"
-#include "s5p_mfc_shm.h"
+
+#define DEF_SRC_FMT_DEC	4
+#define DEF_DST_FMT_DEC	0
 
 static struct s5p_mfc_fmt formats[] = {
 	{
+		.name		= "4:2:0 2 Planes 16x16 Tiles",
+		.fourcc		= V4L2_PIX_FMT_NV12MT_16X16,
+		.codec_mode	= S5P_MFC_CODEC_NONE,
+		.type		= MFC_FMT_RAW,
+		.num_planes	= 2,
+	},
+	{
 		.name		= "4:2:0 2 Planes 64x32 Tiles",
 		.fourcc		= V4L2_PIX_FMT_NV12MT,
-		.codec_mode	= S5P_FIMV_CODEC_NONE,
+		.codec_mode	= S5P_MFC_CODEC_NONE,
+		.type		= MFC_FMT_RAW,
+		.num_planes	= 2,
+	},
+	{
+		.name		= "4:2:0 2 Planes Y/CbCr",
+		.fourcc		= V4L2_PIX_FMT_NV12M,
+		.codec_mode	= S5P_MFC_CODEC_NONE,
+		.type		= MFC_FMT_RAW,
+		.num_planes	= 2,
+	},
+	{
+		.name		= "4:2:0 2 Planes Y/CrCb",
+		.fourcc		= V4L2_PIX_FMT_NV21M,
+		.codec_mode	= S5P_MFC_CODEC_NONE,
 		.type		= MFC_FMT_RAW,
 		.num_planes	= 2,
-	 },
+	},
+	{
+		.name		= "H264 Encoded Stream",
+		.fourcc		= V4L2_PIX_FMT_H264,
+		.codec_mode	= S5P_MFC_CODEC_H264_DEC,
+		.type		= MFC_FMT_DEC,
+		.num_planes	= 1,
+	},
 	{
-		.name = "4:2:0 2 Planes",
-		.fourcc = V4L2_PIX_FMT_NV12M,
-		.codec_mode = S5P_FIMV_CODEC_NONE,
-		.type = MFC_FMT_RAW,
-		.num_planes = 2,
+		.name		= "H264/MVC Encoded Stream",
+		.fourcc		= V4L2_PIX_FMT_H264_MVC,
+		.codec_mode	= S5P_MFC_CODEC_H264_MVC_DEC,
+		.type		= MFC_FMT_DEC,
+		.num_planes	= 1,
 	},
 	{
-		.name = "H264 Encoded Stream",
-		.fourcc = V4L2_PIX_FMT_H264,
-		.codec_mode = S5P_FIMV_CODEC_H264_DEC,
-		.type = MFC_FMT_DEC,
-		.num_planes = 1,
+		.name		= "H263 Encoded Stream",
+		.fourcc		= V4L2_PIX_FMT_H263,
+		.codec_mode	= S5P_MFC_CODEC_H263_DEC,
+		.type		= MFC_FMT_DEC,
+		.num_planes	= 1,
 	},
 	{
-		.name = "H263 Encoded Stream",
-		.fourcc = V4L2_PIX_FMT_H263,
-		.codec_mode = S5P_FIMV_CODEC_H263_DEC,
-		.type = MFC_FMT_DEC,
-		.num_planes = 1,
+		.name		= "MPEG1 Encoded Stream",
+		.fourcc		= V4L2_PIX_FMT_MPEG1,
+		.codec_mode	= S5P_MFC_CODEC_MPEG2_DEC,
+		.type		= MFC_FMT_DEC,
+		.num_planes	= 1,
 	},
 	{
-		.name = "MPEG1 Encoded Stream",
-		.fourcc = V4L2_PIX_FMT_MPEG1,
-		.codec_mode = S5P_FIMV_CODEC_MPEG2_DEC,
-		.type = MFC_FMT_DEC,
-		.num_planes = 1,
+		.name		= "MPEG2 Encoded Stream",
+		.fourcc		= V4L2_PIX_FMT_MPEG2,
+		.codec_mode	= S5P_MFC_CODEC_MPEG2_DEC,
+		.type		= MFC_FMT_DEC,
+		.num_planes	= 1,
 	},
 	{
-		.name = "MPEG2 Encoded Stream",
-		.fourcc = V4L2_PIX_FMT_MPEG2,
-		.codec_mode = S5P_FIMV_CODEC_MPEG2_DEC,
-		.type = MFC_FMT_DEC,
-		.num_planes = 1,
+		.name		= "MPEG4 Encoded Stream",
+		.fourcc		= V4L2_PIX_FMT_MPEG4,
+		.codec_mode	= S5P_MFC_CODEC_MPEG4_DEC,
+		.type		= MFC_FMT_DEC,
+		.num_planes	= 1,
 	},
 	{
-		.name = "MPEG4 Encoded Stream",
-		.fourcc = V4L2_PIX_FMT_MPEG4,
-		.codec_mode = S5P_FIMV_CODEC_MPEG4_DEC,
-		.type = MFC_FMT_DEC,
-		.num_planes = 1,
+		.name		= "XviD Encoded Stream",
+		.fourcc		= V4L2_PIX_FMT_XVID,
+		.codec_mode	= S5P_MFC_CODEC_MPEG4_DEC,
+		.type		= MFC_FMT_DEC,
+		.num_planes	= 1,
 	},
 	{
-		.name = "XviD Encoded Stream",
-		.fourcc = V4L2_PIX_FMT_XVID,
-		.codec_mode = S5P_FIMV_CODEC_MPEG4_DEC,
-		.type = MFC_FMT_DEC,
-		.num_planes = 1,
+		.name		= "VC1 Encoded Stream",
+		.fourcc		= V4L2_PIX_FMT_VC1_ANNEX_G,
+		.codec_mode	= S5P_MFC_CODEC_VC1_DEC,
+		.type		= MFC_FMT_DEC,
+		.num_planes	= 1,
 	},
 	{
-		.name = "VC1 Encoded Stream",
-		.fourcc = V4L2_PIX_FMT_VC1_ANNEX_G,
-		.codec_mode = S5P_FIMV_CODEC_VC1_DEC,
-		.type = MFC_FMT_DEC,
-		.num_planes = 1,
+		.name		= "VC1 RCV Encoded Stream",
+		.fourcc		= V4L2_PIX_FMT_VC1_ANNEX_L,
+		.codec_mode	= S5P_MFC_CODEC_VC1RCV_DEC,
+		.type		= MFC_FMT_DEC,
+		.num_planes	= 1,
 	},
 	{
-		.name = "VC1 RCV Encoded Stream",
-		.fourcc = V4L2_PIX_FMT_VC1_ANNEX_L,
-		.codec_mode = S5P_FIMV_CODEC_VC1RCV_DEC,
-		.type = MFC_FMT_DEC,
-		.num_planes = 1,
+		.name		= "VP8 Encoded Stream",
+		.fourcc		= V4L2_PIX_FMT_VP8,
+		.codec_mode	= S5P_MFC_CODEC_VP8_DEC,
+		.type		= MFC_FMT_DEC,
+		.num_planes	= 1,
 	},
 };
 
@@ -291,7 +320,7 @@ static int vidioc_g_fmt(struct file *file, void *priv, struct v4l2_format *f)
 		/* If the MFC is parsing the header,
 		 * so wait until it is finished */
 		s5p_mfc_clean_ctx_int_flags(ctx);
-		s5p_mfc_wait_for_done_ctx(ctx, S5P_FIMV_R2H_CMD_SEQ_DONE_RET,
+		s5p_mfc_wait_for_done_ctx(ctx, S5P_MFC_R2H_CMD_SEQ_DONE_RET,
 									0);
 	}
 	if (f->type == V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE &&
@@ -336,21 +365,36 @@ static int vidioc_g_fmt(struct file *file, void *priv, struct v4l2_format *f)
 /* Try format */
 static int vidioc_try_fmt(struct file *file, void *priv, struct v4l2_format *f)
 {
+	struct s5p_mfc_dev *dev = video_drvdata(file);
 	struct s5p_mfc_fmt *fmt;
 
-	if (f->type != V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE) {
-		mfc_err("This node supports decoding only\n");
-		return -EINVAL;
-	}
-	fmt = find_format(f, MFC_FMT_DEC);
-	if (!fmt) {
-		mfc_err("Unsupported format\n");
-		return -EINVAL;
-	}
-	if (fmt->type != MFC_FMT_DEC) {
-		mfc_err("\n");
-		return -EINVAL;
+	mfc_debug(2, "Type is %d\n", f->type);
+	if (f->type == V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE) {
+		fmt = find_format(f, MFC_FMT_DEC);
+		if (!fmt) {
+			mfc_err("Unsupported format for source.\n");
+			return -EINVAL;
+		}
+		if (!IS_MFCV6(dev) && (fmt->fourcc == V4L2_PIX_FMT_VP8)) {
+			mfc_err("Not supported format.\n");
+			return -EINVAL;
+		}
+	} else if (f->type == V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE) {
+		fmt = find_format(f, MFC_FMT_RAW);
+		if (!fmt) {
+			mfc_err("Unsupported format for destination.\n");
+			return -EINVAL;
+		}
+		if (IS_MFCV6(dev) && (fmt->fourcc == V4L2_PIX_FMT_NV12MT)) {
+			mfc_err("Not supported format.\n");
+			return -EINVAL;
+		} else if (!IS_MFCV6(dev) &&
+				(fmt->fourcc != V4L2_PIX_FMT_NV12MT)) {
+			mfc_err("Not supported format.\n");
+			return -EINVAL;
+		}
 	}
+
 	return 0;
 }
 
@@ -373,8 +417,29 @@ static int vidioc_s_fmt(struct file *file, void *priv, struct v4l2_format *f)
 		ret = -EBUSY;
 		goto out;
 	}
+	if (f->type == V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE) {
+		fmt = find_format(f, MFC_FMT_RAW);
+		if (!fmt) {
+			mfc_err("Unsupported format for source.\n");
+			return -EINVAL;
+		}
+		if (!IS_MFCV6(dev) && (fmt->fourcc != V4L2_PIX_FMT_NV12MT)) {
+			mfc_err("Not supported format.\n");
+			return -EINVAL;
+		} else if (IS_MFCV6(dev) &&
+				(fmt->fourcc == V4L2_PIX_FMT_NV12MT)) {
+			mfc_err("Not supported format.\n");
+			return -EINVAL;
+		}
+		ctx->dst_fmt = fmt;
+		mfc_debug_leave();
+		return ret;
+	} else if (f->type != V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE) {
+		mfc_err("Wrong type error for S_FMT : %d", f->type);
+		return -EINVAL;
+	}
 	fmt = find_format(f, MFC_FMT_DEC);
-	if (!fmt || fmt->codec_mode == S5P_FIMV_CODEC_NONE) {
+	if (!fmt || fmt->codec_mode == S5P_MFC_CODEC_NONE) {
 		mfc_err("Unknown codec\n");
 		ret = -EINVAL;
 		goto out;
@@ -385,6 +450,10 @@ static int vidioc_s_fmt(struct file *file, void *priv, struct v4l2_format *f)
 		ret = -EINVAL;
 		goto out;
 	}
+	if (!IS_MFCV6(dev) && (fmt->fourcc == V4L2_PIX_FMT_VP8)) {
+		mfc_err("Not supported format.\n");
+		return -EINVAL;
+	}
 	ctx->src_fmt = fmt;
 	ctx->codec_mode = fmt->codec_mode;
 	mfc_debug(2, "The codec number is: %d\n", ctx->codec_mode);
@@ -498,7 +567,7 @@ static int vidioc_reqbufs(struct file *file, void *priv,
 		}
 		s5p_mfc_try_run(dev);
 		s5p_mfc_wait_for_done_ctx(ctx,
-					 S5P_FIMV_R2H_CMD_INIT_BUFFERS_RET, 0);
+					S5P_MFC_R2H_CMD_INIT_BUFFERS_RET, 0);
 	}
 	return ret;
 }
@@ -590,7 +659,7 @@ static int vidioc_streamon(struct file *file, void *priv,
 			s5p_mfc_try_run(dev);
 
 			if (s5p_mfc_wait_for_done_ctx(ctx,
-				S5P_FIMV_R2H_CMD_OPEN_INSTANCE_RET, 0)) {
+				S5P_MFC_R2H_CMD_OPEN_INSTANCE_RET, 0)) {
 				/* Error or timeout */
 				mfc_err("Error getting instance from hardware\n");
 				s5p_mfc_release_instance_buffer(ctx);
@@ -663,7 +732,7 @@ static int s5p_mfc_dec_g_v_ctrl(struct v4l2_ctrl *ctrl)
 		/* Should wait for the header to be parsed */
 		s5p_mfc_clean_ctx_int_flags(ctx);
 		s5p_mfc_wait_for_done_ctx(ctx,
-				S5P_FIMV_R2H_CMD_SEQ_DONE_RET, 0);
+				S5P_MFC_R2H_CMD_SEQ_DONE_RET, 0);
 		if (ctx->state >= MFCINST_HEAD_PARSED &&
 		    ctx->state < MFCINST_ABORT) {
 			ctrl->val = ctx->dpb_count;
@@ -696,10 +765,10 @@ static int vidioc_g_crop(struct file *file, void *priv,
 			return -EINVAL;
 		}
 	if (ctx->src_fmt->fourcc == V4L2_PIX_FMT_H264) {
-		left = s5p_mfc_read_shm(ctx, CROP_INFO_H);
+		left = s5p_mfc_get_crop_info_h(ctx);
 		right = left >> S5P_FIMV_SHARED_CROP_RIGHT_SHIFT;
 		left = left & S5P_FIMV_SHARED_CROP_LEFT_MASK;
-		top = s5p_mfc_read_shm(ctx, CROP_INFO_V);
+		top = s5p_mfc_get_crop_info_v(ctx);
 		bottom = top >> S5P_FIMV_SHARED_CROP_BOTTOM_SHIFT;
 		top = top & S5P_FIMV_SHARED_CROP_TOP_MASK;
 		cr->c.left = left;
@@ -750,6 +819,7 @@ static int s5p_mfc_queue_setup(struct vb2_queue *vq,
 			void *allocators[])
 {
 	struct s5p_mfc_ctx *ctx = fh_to_ctx(vq->drv_priv);
+	struct s5p_mfc_dev *dev = ctx->dev;
 
 	/* Video output for decoding (source)
 	 * this can be set after getting an instance */
@@ -785,7 +855,13 @@ static int s5p_mfc_queue_setup(struct vb2_queue *vq,
 	    vq->type == V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE) {
 		psize[0] = ctx->luma_size;
 		psize[1] = ctx->chroma_size;
-		allocators[0] = ctx->dev->alloc_ctx[MFC_BANK2_ALLOC_CTX];
+
+		if (IS_MFCV6(dev))
+			allocators[0] =
+				ctx->dev->alloc_ctx[MFC_BANK1_ALLOC_CTX];
+		else
+			allocators[0] =
+				ctx->dev->alloc_ctx[MFC_BANK2_ALLOC_CTX];
 		allocators[1] = ctx->dev->alloc_ctx[MFC_BANK1_ALLOC_CTX];
 	} else if (vq->type == V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE &&
 		   ctx->state == MFCINST_INIT) {
@@ -897,7 +973,7 @@ static int s5p_mfc_stop_streaming(struct vb2_queue *q)
 		dev->curr_ctx == ctx->num && dev->hw_lock) {
 		ctx->state = MFCINST_ABORT;
 		s5p_mfc_wait_for_done_ctx(ctx,
-					S5P_FIMV_R2H_CMD_FRAME_DONE_RET, 0);
+					S5P_MFC_R2H_CMD_FRAME_DONE_RET, 0);
 		aborted = 1;
 	}
 	spin_lock_irqsave(&dev->irqlock, flags);
@@ -1035,3 +1111,10 @@ void s5p_mfc_dec_ctrls_delete(struct s5p_mfc_ctx *ctx)
 		ctx->ctrls[i] = NULL;
 }
 
+void s5p_mfc_dec_init(struct s5p_mfc_ctx *ctx)
+{
+	ctx->src_fmt = &formats[DEF_SRC_FMT_DEC];
+	ctx->dst_fmt = &formats[DEF_DST_FMT_DEC];
+	mfc_debug(2, "Default src_fmt is %x, dest_fmt is %x\n",
+			(unsigned int)ctx->src_fmt, (unsigned int)ctx->dst_fmt);
+}
diff --git a/drivers/media/video/s5p-mfc/s5p_mfc_dec.h b/drivers/media/video/s5p-mfc/s5p_mfc_dec.h
index fb8b215..c53baf8 100644
--- a/drivers/media/video/s5p-mfc/s5p_mfc_dec.h
+++ b/drivers/media/video/s5p-mfc/s5p_mfc_dec.h
@@ -19,5 +19,6 @@ const struct v4l2_ioctl_ops *get_dec_v4l2_ioctl_ops(void);
 struct s5p_mfc_fmt *get_dec_def_fmt(bool src);
 int s5p_mfc_dec_ctrls_setup(struct s5p_mfc_ctx *ctx);
 void s5p_mfc_dec_ctrls_delete(struct s5p_mfc_ctx *ctx);
+void s5p_mfc_dec_init(struct s5p_mfc_ctx *ctx);
 
 #endif /* S5P_MFC_DEC_H_ */
diff --git a/drivers/media/video/s5p-mfc/s5p_mfc_enc.c b/drivers/media/video/s5p-mfc/s5p_mfc_enc.c
index 03d8334..eeefd45 100644
--- a/drivers/media/video/s5p-mfc/s5p_mfc_enc.c
+++ b/drivers/media/video/s5p-mfc/s5p_mfc_enc.c
@@ -24,48 +24,64 @@
 #include <linux/workqueue.h>
 #include <media/v4l2-ctrls.h>
 #include <media/videobuf2-core.h>
-#include "regs-mfc.h"
 #include "s5p_mfc_common.h"
 #include "s5p_mfc_debug.h"
 #include "s5p_mfc_enc.h"
 #include "s5p_mfc_intr.h"
 #include "s5p_mfc_opr.h"
 
+#define DEF_SRC_FMT_ENC	2
+#define DEF_DST_FMT_ENC	4
+
 static struct s5p_mfc_fmt formats[] = {
 	{
-		.name = "4:2:0 2 Planes 64x32 Tiles",
-		.fourcc = V4L2_PIX_FMT_NV12MT,
-		.codec_mode = S5P_FIMV_CODEC_NONE,
-		.type = MFC_FMT_RAW,
-		.num_planes = 2,
+		.name		= "4:2:0 2 Planes 16x16 Tiles",
+		.fourcc		= V4L2_PIX_FMT_NV12MT_16X16,
+		.codec_mode	= S5P_MFC_CODEC_NONE,
+		.type		= MFC_FMT_RAW,
+		.num_planes	= 2,
+	},
+	{
+		.name		= "4:2:0 2 Planes 64x32 Tiles",
+		.fourcc		= V4L2_PIX_FMT_NV12MT,
+		.codec_mode	= S5P_MFC_CODEC_NONE,
+		.type		= MFC_FMT_RAW,
+		.num_planes	= 2,
+	},
+	{
+		.name		= "4:2:0 2 Planes Y/CbCr",
+		.fourcc		= V4L2_PIX_FMT_NV12M,
+		.codec_mode	= S5P_MFC_CODEC_NONE,
+		.type		= MFC_FMT_RAW,
+		.num_planes	= 2,
 	},
 	{
-		.name = "4:2:0 2 Planes",
-		.fourcc = V4L2_PIX_FMT_NV12M,
-		.codec_mode = S5P_FIMV_CODEC_NONE,
-		.type = MFC_FMT_RAW,
-		.num_planes = 2,
+		.name		= "4:2:0 2 Planes Y/CrCb",
+		.fourcc		= V4L2_PIX_FMT_NV21M,
+		.codec_mode	= S5P_MFC_CODEC_NONE,
+		.type		= MFC_FMT_RAW,
+		.num_planes	= 2,
 	},
 	{
-		.name = "H264 Encoded Stream",
-		.fourcc = V4L2_PIX_FMT_H264,
-		.codec_mode = S5P_FIMV_CODEC_H264_ENC,
-		.type = MFC_FMT_ENC,
-		.num_planes = 1,
+		.name		= "H264 Encoded Stream",
+		.fourcc		= V4L2_PIX_FMT_H264,
+		.codec_mode	= S5P_MFC_CODEC_H264_ENC,
+		.type		= MFC_FMT_ENC,
+		.num_planes	= 1,
 	},
 	{
-		.name = "MPEG4 Encoded Stream",
-		.fourcc = V4L2_PIX_FMT_MPEG4,
-		.codec_mode = S5P_FIMV_CODEC_MPEG4_ENC,
-		.type = MFC_FMT_ENC,
-		.num_planes = 1,
+		.name		= "MPEG4 Encoded Stream",
+		.fourcc		= V4L2_PIX_FMT_MPEG4,
+		.codec_mode	= S5P_MFC_CODEC_MPEG4_ENC,
+		.type		= MFC_FMT_ENC,
+		.num_planes	= 1,
 	},
 	{
-		.name = "H263 Encoded Stream",
-		.fourcc = V4L2_PIX_FMT_H263,
-		.codec_mode = S5P_FIMV_CODEC_H263_ENC,
-		.type = MFC_FMT_ENC,
-		.num_planes = 1,
+		.name		= "H263 Encoded Stream",
+		.fourcc		= V4L2_PIX_FMT_H263,
+		.codec_mode	= S5P_MFC_CODEC_H263_ENC,
+		.type		= MFC_FMT_ENC,
+		.num_planes	= 1,
 	},
 };
 
@@ -637,17 +653,26 @@ static int enc_post_seq_start(struct s5p_mfc_ctx *ctx)
 		list_del(&dst_mb->list);
 		ctx->dst_queue_cnt--;
 		vb2_set_plane_payload(dst_mb->b, 0,
-						s5p_mfc_get_enc_strm_size());
+						s5p_mfc_get_enc_strm_size(dev));
 		vb2_buffer_done(dst_mb->b, VB2_BUF_STATE_DONE);
 		spin_unlock_irqrestore(&dev->irqlock, flags);
 	}
-	ctx->state = MFCINST_RUNNING;
-	if (s5p_mfc_ctx_ready(ctx)) {
-		spin_lock_irqsave(&dev->condlock, flags);
-		set_bit(ctx->num, &dev->ctx_work_bits);
-		spin_unlock_irqrestore(&dev->condlock, flags);
+
+	if (IS_MFCV6(dev)) {
+		ctx->state = MFCINST_HEAD_PARSED; /* for INIT_BUFFER cmd */
+	} else {
+		ctx->state = MFCINST_RUNNING;
+		if (s5p_mfc_ctx_ready(ctx)) {
+			spin_lock_irqsave(&dev->condlock, flags);
+			set_bit(ctx->num, &dev->ctx_work_bits);
+			spin_unlock_irqrestore(&dev->condlock, flags);
+		}
+		s5p_mfc_try_run(dev);
 	}
-	s5p_mfc_try_run(dev);
+
+	if (IS_MFCV6(dev))
+		ctx->dpb_count = s5p_mfc_get_enc_dpb_count(dev);
+
 	return 0;
 }
 
@@ -687,8 +712,8 @@ static int enc_post_frame_start(struct s5p_mfc_ctx *ctx)
 	unsigned int strm_size;
 	unsigned long flags;
 
-	slice_type = s5p_mfc_get_enc_slice_type();
-	strm_size = s5p_mfc_get_enc_strm_size();
+	slice_type = s5p_mfc_get_enc_slice_type(dev);
+	strm_size = s5p_mfc_get_enc_strm_size(dev);
 	mfc_debug(2, "Encoded slice type: %d", slice_type);
 	mfc_debug(2, "Encoded stream size: %d", strm_size);
 	mfc_debug(2, "Display order: %d",
@@ -947,7 +972,7 @@ static int vidioc_s_fmt(struct file *file, void *priv, struct v4l2_format *f)
 		s5p_mfc_clean_ctx_int_flags(ctx);
 		s5p_mfc_try_run(dev);
 		if (s5p_mfc_wait_for_done_ctx(ctx, \
-				S5P_FIMV_R2H_CMD_OPEN_INSTANCE_RET, 1)) {
+				S5P_MFC_R2H_CMD_OPEN_INSTANCE_RET, 1)) {
 				/* Error or timeout */
 			mfc_err("Error getting instance from hardware\n");
 			s5p_mfc_release_instance_buffer(ctx);
@@ -961,6 +986,17 @@ static int vidioc_s_fmt(struct file *file, void *priv, struct v4l2_format *f)
 			mfc_err("failed to set output format\n");
 			return -EINVAL;
 		}
+
+		if (!IS_MFCV6(dev) &&
+				(fmt->fourcc == V4L2_PIX_FMT_NV12MT_16X16)) {
+			mfc_err("Not supported format.\n");
+			return -EINVAL;
+		} else if (IS_MFCV6(dev) &&
+				(fmt->fourcc == V4L2_PIX_FMT_NV12MT)) {
+			mfc_err("Not supported format.\n");
+			return -EINVAL;
+		}
+
 		if (fmt->num_planes != pix_fmt_mp->num_planes) {
 			mfc_err("failed to set output format\n");
 			ret = -EINVAL;
@@ -973,45 +1009,13 @@ static int vidioc_s_fmt(struct file *file, void *priv, struct v4l2_format *f)
 		mfc_debug(2, "fmt - w: %d, h: %d, ctx - w: %d, h: %d\n",
 			pix_fmt_mp->width, pix_fmt_mp->height,
 			ctx->img_width, ctx->img_height);
-		if (ctx->src_fmt->fourcc == V4L2_PIX_FMT_NV12M) {
-			ctx->buf_width = ALIGN(ctx->img_width,
-							S5P_FIMV_NV12M_HALIGN);
-			ctx->luma_size = ALIGN(ctx->img_width,
-				S5P_FIMV_NV12M_HALIGN) * ALIGN(ctx->img_height,
-				S5P_FIMV_NV12M_LVALIGN);
-			ctx->chroma_size = ALIGN(ctx->img_width,
-				S5P_FIMV_NV12M_HALIGN) * ALIGN((ctx->img_height
-				>> 1), S5P_FIMV_NV12M_CVALIGN);
-
-			ctx->luma_size = ALIGN(ctx->luma_size,
-							S5P_FIMV_NV12M_SALIGN);
-			ctx->chroma_size = ALIGN(ctx->chroma_size,
-							S5P_FIMV_NV12M_SALIGN);
-
-			pix_fmt_mp->plane_fmt[0].sizeimage = ctx->luma_size;
-			pix_fmt_mp->plane_fmt[0].bytesperline = ctx->buf_width;
-			pix_fmt_mp->plane_fmt[1].sizeimage = ctx->chroma_size;
-			pix_fmt_mp->plane_fmt[1].bytesperline = ctx->buf_width;
-
-		} else if (ctx->src_fmt->fourcc == V4L2_PIX_FMT_NV12MT) {
-			ctx->buf_width = ALIGN(ctx->img_width,
-							S5P_FIMV_NV12MT_HALIGN);
-			ctx->luma_size = ALIGN(ctx->img_width,
-				S5P_FIMV_NV12MT_HALIGN)	* ALIGN(ctx->img_height,
-				S5P_FIMV_NV12MT_VALIGN);
-			ctx->chroma_size = ALIGN(ctx->img_width,
-				S5P_FIMV_NV12MT_HALIGN) * ALIGN((ctx->img_height
-				>> 1), S5P_FIMV_NV12MT_VALIGN);
-			ctx->luma_size = ALIGN(ctx->luma_size,
-							S5P_FIMV_NV12MT_SALIGN);
-			ctx->chroma_size = ALIGN(ctx->chroma_size,
-							S5P_FIMV_NV12MT_SALIGN);
-
-			pix_fmt_mp->plane_fmt[0].sizeimage = ctx->luma_size;
-			pix_fmt_mp->plane_fmt[0].bytesperline = ctx->buf_width;
-			pix_fmt_mp->plane_fmt[1].sizeimage = ctx->chroma_size;
-			pix_fmt_mp->plane_fmt[1].bytesperline = ctx->buf_width;
-		}
+
+		s5p_mfc_enc_calc_src_size(ctx);
+		pix_fmt_mp->plane_fmt[0].sizeimage = ctx->luma_size;
+		pix_fmt_mp->plane_fmt[0].bytesperline = ctx->buf_width;
+		pix_fmt_mp->plane_fmt[1].sizeimage = ctx->chroma_size;
+		pix_fmt_mp->plane_fmt[1].bytesperline = ctx->buf_width;
+
 		ctx->src_bufs_cnt = 0;
 		ctx->output_state = QUEUE_FREE;
 	} else {
@@ -1026,6 +1030,7 @@ out:
 static int vidioc_reqbufs(struct file *file, void *priv,
 					  struct v4l2_requestbuffers *reqbufs)
 {
+	struct s5p_mfc_dev *dev = video_drvdata(file);
 	struct s5p_mfc_ctx *ctx = fh_to_ctx(priv);
 	int ret = 0;
 
@@ -1045,12 +1050,15 @@ static int vidioc_reqbufs(struct file *file, void *priv,
 			return ret;
 		}
 		ctx->capture_state = QUEUE_BUFS_REQUESTED;
-		ret = s5p_mfc_alloc_codec_buffers(ctx);
-		if (ret) {
-			mfc_err("Failed to allocate encoding buffers\n");
-			reqbufs->count = 0;
-			ret = vb2_reqbufs(&ctx->vq_dst, reqbufs);
-			return -ENOMEM;
+
+		if (!IS_MFCV6(dev)) {
+			ret = s5p_mfc_alloc_codec_buffers(ctx);
+			if (ret) {
+				mfc_err("Failed to allocate encoding buffers\n");
+				reqbufs->count = 0;
+				ret = vb2_reqbufs(&ctx->vq_dst, reqbufs);
+				return -ENOMEM;
+			}
 		}
 	} else if (reqbufs->type == V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE) {
 		if (ctx->output_state != QUEUE_FREE) {
@@ -1297,6 +1305,13 @@ static int s5p_mfc_enc_s_ctrl(struct v4l2_ctrl *ctrl)
 			p->codec.h264.profile =
 				S5P_FIMV_ENC_PROFILE_H264_BASELINE;
 			break;
+		case V4L2_MPEG_VIDEO_H264_PROFILE_CONSTRAINED_BASELINE:
+			if (IS_MFCV6(dev))
+				p->codec.h264.profile =
+				S5P_FIMV_ENC_PROFILE_H264_CONSTRAINED_BASELINE;
+			else
+				ret = -EINVAL;
+			break;
 		default:
 			ret = -EINVAL;
 		}
@@ -1516,6 +1531,7 @@ static int s5p_mfc_queue_setup(struct vb2_queue *vq,
 			unsigned int psize[], void *allocators[])
 {
 	struct s5p_mfc_ctx *ctx = fh_to_ctx(vq->drv_priv);
+	struct s5p_mfc_dev *dev = ctx->dev;
 
 	if (ctx->state != MFCINST_GOT_INST) {
 		mfc_err("inavlid state: %d\n", ctx->state);
@@ -1544,8 +1560,17 @@ static int s5p_mfc_queue_setup(struct vb2_queue *vq,
 			*buf_count = MFC_MAX_BUFFERS;
 		psize[0] = ctx->luma_size;
 		psize[1] = ctx->chroma_size;
-		allocators[0] = ctx->dev->alloc_ctx[MFC_BANK2_ALLOC_CTX];
-		allocators[1] = ctx->dev->alloc_ctx[MFC_BANK2_ALLOC_CTX];
+		if (IS_MFCV6(dev)) {
+			allocators[0] =
+				ctx->dev->alloc_ctx[MFC_BANK1_ALLOC_CTX];
+			allocators[1] =
+				ctx->dev->alloc_ctx[MFC_BANK1_ALLOC_CTX];
+		} else {
+			allocators[0] =
+				ctx->dev->alloc_ctx[MFC_BANK2_ALLOC_CTX];
+			allocators[1] =
+				ctx->dev->alloc_ctx[MFC_BANK2_ALLOC_CTX];
+		}
 	} else {
 		mfc_err("inavlid queue type: %d\n", vq->type);
 		return -EINVAL;
@@ -1666,7 +1691,7 @@ static int s5p_mfc_stop_streaming(struct vb2_queue *q)
 		ctx->state == MFCINST_RUNNING) &&
 		dev->curr_ctx == ctx->num && dev->hw_lock) {
 		ctx->state = MFCINST_ABORT;
-		s5p_mfc_wait_for_done_ctx(ctx, S5P_FIMV_R2H_CMD_FRAME_DONE_RET,
+		s5p_mfc_wait_for_done_ctx(ctx, S5P_MFC_R2H_CMD_FRAME_DONE_RET,
 					  0);
 	}
 	ctx->state = MFCINST_FINISHED;
@@ -1826,3 +1851,10 @@ void s5p_mfc_enc_ctrls_delete(struct s5p_mfc_ctx *ctx)
 	for (i = 0; i < NUM_CTRLS; i++)
 		ctx->ctrls[i] = NULL;
 }
+
+void s5p_mfc_enc_init(struct s5p_mfc_ctx *ctx)
+{
+	ctx->src_fmt = &formats[DEF_SRC_FMT_ENC];
+	ctx->dst_fmt = &formats[DEF_DST_FMT_ENC];
+}
+
diff --git a/drivers/media/video/s5p-mfc/s5p_mfc_enc.h b/drivers/media/video/s5p-mfc/s5p_mfc_enc.h
index 405bdd3..413f22f 100644
--- a/drivers/media/video/s5p-mfc/s5p_mfc_enc.h
+++ b/drivers/media/video/s5p-mfc/s5p_mfc_enc.h
@@ -19,5 +19,6 @@ const struct v4l2_ioctl_ops *get_enc_v4l2_ioctl_ops(void);
 struct s5p_mfc_fmt *get_enc_def_fmt(bool src);
 int s5p_mfc_enc_ctrls_setup(struct s5p_mfc_ctx *ctx);
 void s5p_mfc_enc_ctrls_delete(struct s5p_mfc_ctx *ctx);
+void s5p_mfc_enc_init(struct s5p_mfc_ctx *ctx);
 
 #endif /* S5P_MFC_ENC_H_  */
-- 
1.7.0.4

