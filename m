Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qa0-f73.google.com ([209.85.216.73]:37374 "EHLO
	mail-qa0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757914Ab3E3UmY (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 30 May 2013 16:42:24 -0400
Received: by mail-qa0-f73.google.com with SMTP id n20so13510qaj.2
        for <linux-media@vger.kernel.org>; Thu, 30 May 2013 13:42:23 -0700 (PDT)
From: John Sheu <sheu@google.com>
To: linux-media@vger.kernel.org
Cc: mchehab@redhat.com, pawel@osciak.com, k.debski@samsung.com,
	kyungmin.park@samsung.com, John Sheu <sheu@chromium.org>,
	John Sheu <sheu@google.com>
Subject: [PATCH 2/2] [media] s5p-mfc: Fix input/output format reporting
Date: Thu, 30 May 2013 13:42:08 -0700
Message-Id: <1369946528-26818-1-git-send-email-sheu@google.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: John Sheu <sheu@chromium.org>

The video encode/decode paths have duplicated logic between
VIDIOC_TRY_FMT and VIDIOC_S_FMT that should be de-duped.  Also, video
decode reports V4L2_PIX_FMT_NV12MT_16X16 output format, regardless of
what the actual output has been set at.  Fix this.

Signed-off-by: John Sheu <sheu@google.com>
---
 drivers/media/platform/s5p-mfc/s5p_mfc_dec.c | 79 +++++++++++-----------------
 drivers/media/platform/s5p-mfc/s5p_mfc_enc.c | 46 ++++++----------
 2 files changed, 48 insertions(+), 77 deletions(-)

diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc_dec.c b/drivers/media/platform/s5p-mfc/s5p_mfc_dec.c
index 4af53bd..2effa52 100644
--- a/drivers/media/platform/s5p-mfc/s5p_mfc_dec.c
+++ b/drivers/media/platform/s5p-mfc/s5p_mfc_dec.c
@@ -344,7 +344,7 @@ static int vidioc_g_fmt(struct file *file, void *priv, struct v4l2_format *f)
 		pix_mp->num_planes = 2;
 		/* Set pixelformat to the format in which MFC
 		   outputs the decoded frame */
-		pix_mp->pixelformat = V4L2_PIX_FMT_NV12MT;
+		pix_mp->pixelformat = ctx->dst_fmt->fourcc;
 		pix_mp->plane_fmt[0].bytesperline = ctx->buf_width;
 		pix_mp->plane_fmt[0].sizeimage = ctx->luma_size;
 		pix_mp->plane_fmt[1].bytesperline = ctx->buf_width;
@@ -382,10 +382,16 @@ static int vidioc_try_fmt(struct file *file, void *priv, struct v4l2_format *f)
 			mfc_err("Unsupported format for source.\n");
 			return -EINVAL;
 		}
-		if (!IS_MFCV6(dev) && (fmt->fourcc == V4L2_PIX_FMT_VP8)) {
-			mfc_err("Not supported format.\n");
+		if (fmt->codec_mode == S5P_FIMV_CODEC_NONE) {
+			mfc_err("Unknown codec\n");
 			return -EINVAL;
 		}
+		if (!IS_MFCV6(dev)) {
+			if (fmt->fourcc == V4L2_PIX_FMT_VP8) {
+				mfc_err("Not supported format.\n");
+				return -EINVAL;
+			}
+		}
 	} else if (f->type == V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE) {
 		fmt = find_format(f, MFC_FMT_RAW);
 		if (!fmt) {
@@ -411,7 +417,6 @@ static int vidioc_s_fmt(struct file *file, void *priv, struct v4l2_format *f)
 	struct s5p_mfc_dev *dev = video_drvdata(file);
 	struct s5p_mfc_ctx *ctx = fh_to_ctx(priv);
 	int ret = 0;
-	struct s5p_mfc_fmt *fmt;
 	struct v4l2_pix_format_mplane *pix_mp;
 
 	mfc_debug_enter();
@@ -425,54 +430,32 @@ static int vidioc_s_fmt(struct file *file, void *priv, struct v4l2_format *f)
 		goto out;
 	}
 	if (f->type == V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE) {
-		fmt = find_format(f, MFC_FMT_RAW);
-		if (!fmt) {
-			mfc_err("Unsupported format for source.\n");
-			return -EINVAL;
-		}
-		if (!IS_MFCV6(dev) && (fmt->fourcc != V4L2_PIX_FMT_NV12MT)) {
-			mfc_err("Not supported format.\n");
-			return -EINVAL;
-		} else if (IS_MFCV6(dev) &&
-				(fmt->fourcc == V4L2_PIX_FMT_NV12MT)) {
-			mfc_err("Not supported format.\n");
-			return -EINVAL;
-		}
-		ctx->dst_fmt = fmt;
-		mfc_debug_leave();
-		return ret;
-	} else if (f->type != V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE) {
-		mfc_err("Wrong type error for S_FMT : %d", f->type);
-		return -EINVAL;
-	}
-	fmt = find_format(f, MFC_FMT_DEC);
-	if (!fmt || fmt->codec_mode == S5P_MFC_CODEC_NONE) {
-		mfc_err("Unknown codec\n");
-		ret = -EINVAL;
+		/* dst_fmt is validated by call to vidioc_try_fmt */
+		ctx->dst_fmt = find_format(f, MFC_FMT_RAW);
+		ret = 0;
 		goto out;
-	}
-	if (fmt->type != MFC_FMT_DEC) {
-		mfc_err("Wrong format selected, you should choose "
-					"format for decoding\n");
+	} else if (f->type == V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE) {
+		/* src_fmt is validated by call to vidioc_try_fmt */
+		ctx->src_fmt = find_format(f, MFC_FMT_DEC);
+		ctx->codec_mode = ctx->src_fmt->codec_mode;
+		mfc_debug(2, "The codec number is: %d\n", ctx->codec_mode);
+		pix_mp->height = 0;
+		pix_mp->width = 0;
+		if (pix_mp->plane_fmt[0].sizeimage)
+			ctx->dec_src_buf_size = pix_mp->plane_fmt[0].sizeimage;
+		else
+			pix_mp->plane_fmt[0].sizeimage = ctx->dec_src_buf_size =
+								DEF_CPB_SIZE;
+		pix_mp->plane_fmt[0].bytesperline = 0;
+		ctx->state = MFCINST_INIT;
+		ret = 0;
+		goto out;
+	} else {
+		mfc_err("Wrong type error for S_FMT : %d", f->type);
 		ret = -EINVAL;
 		goto out;
 	}
-	if (!IS_MFCV6(dev) && (fmt->fourcc == V4L2_PIX_FMT_VP8)) {
-		mfc_err("Not supported format.\n");
-		return -EINVAL;
-	}
-	ctx->src_fmt = fmt;
-	ctx->codec_mode = fmt->codec_mode;
-	mfc_debug(2, "The codec number is: %d\n", ctx->codec_mode);
-	pix_mp->height = 0;
-	pix_mp->width = 0;
-	if (pix_mp->plane_fmt[0].sizeimage)
-		ctx->dec_src_buf_size = pix_mp->plane_fmt[0].sizeimage;
-	else
-		pix_mp->plane_fmt[0].sizeimage = ctx->dec_src_buf_size =
-								DEF_CPB_SIZE;
-	pix_mp->plane_fmt[0].bytesperline = 0;
-	ctx->state = MFCINST_INIT;
+
 out:
 	mfc_debug_leave();
 	return ret;
diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc_enc.c b/drivers/media/platform/s5p-mfc/s5p_mfc_enc.c
index 4f6b553..321cd49 100644
--- a/drivers/media/platform/s5p-mfc/s5p_mfc_enc.c
+++ b/drivers/media/platform/s5p-mfc/s5p_mfc_enc.c
@@ -904,6 +904,7 @@ static int vidioc_g_fmt(struct file *file, void *priv, struct v4l2_format *f)
 
 static int vidioc_try_fmt(struct file *file, void *priv, struct v4l2_format *f)
 {
+	struct s5p_mfc_dev *dev = video_drvdata(file);
 	struct s5p_mfc_fmt *fmt;
 	struct v4l2_pix_format_mplane *pix_fmt_mp = &f->fmt.pix_mp;
 
@@ -928,6 +929,18 @@ static int vidioc_try_fmt(struct file *file, void *priv, struct v4l2_format *f)
 			return -EINVAL;
 		}
 
+		if (!IS_MFCV6(dev)) {
+			if (fmt->fourcc == V4L2_PIX_FMT_NV12MT_16X16) {
+				mfc_err("Not supported format.\n");
+				return -EINVAL;
+			}
+		} else if (IS_MFCV6(dev)) {
+			if (fmt->fourcc == V4L2_PIX_FMT_NV12MT) {
+				mfc_err("Not supported format.\n");
+				return -EINVAL;
+			}
+		}
+
 		if (fmt->num_planes != pix_fmt_mp->num_planes) {
 			mfc_err("failed to try output format\n");
 			return -EINVAL;
@@ -945,7 +958,6 @@ static int vidioc_s_fmt(struct file *file, void *priv, struct v4l2_format *f)
 {
 	struct s5p_mfc_dev *dev = video_drvdata(file);
 	struct s5p_mfc_ctx *ctx = fh_to_ctx(priv);
-	struct s5p_mfc_fmt *fmt;
 	struct v4l2_pix_format_mplane *pix_fmt_mp = &f->fmt.pix_mp;
 	int ret = 0;
 
@@ -958,13 +970,9 @@ static int vidioc_s_fmt(struct file *file, void *priv, struct v4l2_format *f)
 		goto out;
 	}
 	if (f->type == V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE) {
-		fmt = find_format(f, MFC_FMT_ENC);
-		if (!fmt) {
-			mfc_err("failed to set capture format\n");
-			return -EINVAL;
-		}
+		/* dst_fmt is validated by call to vidioc_try_fmt */
+		ctx->dst_fmt = find_format(f, MFC_FMT_ENC);
 		ctx->state = MFCINST_INIT;
-		ctx->dst_fmt = fmt;
 		ctx->codec_mode = ctx->dst_fmt->codec_mode;
 		ctx->enc_dst_buf_size =	pix_fmt_mp->plane_fmt[0].sizeimage;
 		pix_fmt_mp->plane_fmt[0].bytesperline = 0;
@@ -985,28 +993,8 @@ static int vidioc_s_fmt(struct file *file, void *priv, struct v4l2_format *f)
 		}
 		mfc_debug(2, "Got instance number: %d\n", ctx->inst_no);
 	} else if (f->type == V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE) {
-		fmt = find_format(f, MFC_FMT_RAW);
-		if (!fmt) {
-			mfc_err("failed to set output format\n");
-			return -EINVAL;
-		}
-
-		if (!IS_MFCV6(dev) &&
-				(fmt->fourcc == V4L2_PIX_FMT_NV12MT_16X16)) {
-			mfc_err("Not supported format.\n");
-			return -EINVAL;
-		} else if (IS_MFCV6(dev) &&
-				(fmt->fourcc == V4L2_PIX_FMT_NV12MT)) {
-			mfc_err("Not supported format.\n");
-			return -EINVAL;
-		}
-
-		if (fmt->num_planes != pix_fmt_mp->num_planes) {
-			mfc_err("failed to set output format\n");
-			ret = -EINVAL;
-			goto out;
-		}
-		ctx->src_fmt = fmt;
+		/* src_fmt is validated by call to vidioc_try_fmt */
+		ctx->src_fmt = find_format(f, MFC_FMT_RAW);
 		ctx->img_width = pix_fmt_mp->width;
 		ctx->img_height = pix_fmt_mp->height;
 		mfc_debug(2, "codec number: %d\n", ctx->src_fmt->codec_mode);
-- 
1.8.2.1

