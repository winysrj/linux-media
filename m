Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.samsung.com ([203.254.224.33]:27763 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755034Ab3H2Oes (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 29 Aug 2013 10:34:48 -0400
Received: from epcpsbgm1.samsung.com (epcpsbgm1 [203.254.230.26])
 by mailout3.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MSA00EHRR5ZBTR0@mailout3.samsung.com> for
 linux-media@vger.kernel.org; Thu, 29 Aug 2013 23:34:47 +0900 (KST)
From: Kamil Debski <k.debski@samsung.com>
To: linux-media@vger.kernel.org
Cc: arun.kk@samsung.com, sheu@google.com,
	m.krawczuk@partner.samsung.com, m.chehab@samsung.com,
	Kamil Debski <k.debski@samsung.com>
Subject: [PATCH] s5p-mfc: Fix build break in s5p_mfc_dec.c and s5p_mfc_enc.c
Date: Thu, 29 Aug 2013 16:34:31 +0200
Message-id: <1377786871-25653-1-git-send-email-k.debski@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The build break was caused by the merge conflict between the following
patches:
- [media] s5p-mfc: Fix input/output format reporting
  b2634562ad90be16441cff1127136457ea619466
- [media] s5p-mfc: Rename IS_MFCV6 macro
  722b979e555d002ca97c9254a91ff3bc5e83763c

Reported-by: Mateusz Krawczuk <m.krawczuk@partner.samsung.com>
Signed-off-by: Kamil Debski <k.debski@samsung.com>
---

Hi Mauro,

There is a build break in the current linux-next (20130829).
This patch fixes the merge confilct that caused the build break.

Best wishes,
Kamil Debski

 drivers/media/platform/s5p-mfc/s5p_mfc_dec.c |   47 +++-----------------------
 drivers/media/platform/s5p-mfc/s5p_mfc_enc.c |   44 ++++++------------------
 2 files changed, 16 insertions(+), 75 deletions(-)

diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc_dec.c b/drivers/media/platform/s5p-mfc/s5p_mfc_dec.c
index c46d12c..5c764f9 100644
--- a/drivers/media/platform/s5p-mfc/s5p_mfc_dec.c
+++ b/drivers/media/platform/s5p-mfc/s5p_mfc_dec.c
@@ -390,7 +390,7 @@ static int vidioc_try_fmt(struct file *file, void *priv, struct v4l2_format *f)
 			mfc_err("Not supported format.\n");
 			return -EINVAL;
 		}
-		if (!IS_MFCV6(dev)) {
+		if (!IS_MFCV6_PLUS(dev)) {
 			if (fmt->fourcc == V4L2_PIX_FMT_VP8) {
 				mfc_err("Not supported format.\n");
 				return -EINVAL;
@@ -435,31 +435,9 @@ static int vidioc_s_fmt(struct file *file, void *priv, struct v4l2_format *f)
 		goto out;
 	}
 	if (f->type == V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE) {
-		fmt = find_format(f, MFC_FMT_RAW);
-		if (!fmt) {
-			mfc_err("Unsupported format for source.\n");
-			return -EINVAL;
-		}
-		if (!IS_MFCV6_PLUS(dev) &&
-				(fmt->fourcc != V4L2_PIX_FMT_NV12MT)) {
-			mfc_err("Not supported format.\n");
-			return -EINVAL;
-		} else if (IS_MFCV6_PLUS(dev) &&
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
 	} else if (f->type == V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE) {
 		/* src_fmt is validated by call to vidioc_try_fmt */
@@ -482,22 +460,7 @@ static int vidioc_s_fmt(struct file *file, void *priv, struct v4l2_format *f)
 		ret = -EINVAL;
 		goto out;
 	}
-	if (!IS_MFCV6_PLUS(dev) && (fmt->fourcc == V4L2_PIX_FMT_VP8)) {
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
index 306c72b..41f5a3c 100644
--- a/drivers/media/platform/s5p-mfc/s5p_mfc_enc.c
+++ b/drivers/media/platform/s5p-mfc/s5p_mfc_enc.c
@@ -978,6 +978,11 @@ static int vidioc_try_fmt(struct file *file, void *priv, struct v4l2_format *f)
 			return -EINVAL;
 		}
 
+		if (!IS_MFCV7(dev) && (fmt->fourcc == V4L2_PIX_FMT_VP8)) {
+			mfc_err("VP8 is supported only in MFC v7\n");
+			return -EINVAL;
+		}
+
 		if (pix_fmt_mp->plane_fmt[0].sizeimage == 0) {
 			mfc_err("must be set encoding output size\n");
 			return -EINVAL;
@@ -992,12 +997,12 @@ static int vidioc_try_fmt(struct file *file, void *priv, struct v4l2_format *f)
 			return -EINVAL;
 		}
 
-		if (!IS_MFCV6(dev)) {
+		if (!IS_MFCV6_PLUS(dev)) {
 			if (fmt->fourcc == V4L2_PIX_FMT_NV12MT_16X16) {
 				mfc_err("Not supported format.\n");
 				return -EINVAL;
 			}
-		} else if (IS_MFCV6(dev)) {
+		} else if (IS_MFCV6_PLUS(dev)) {
 			if (fmt->fourcc == V4L2_PIX_FMT_NV12MT) {
 				mfc_err("Not supported format.\n");
 				return -EINVAL;
@@ -1033,15 +1038,8 @@ static int vidioc_s_fmt(struct file *file, void *priv, struct v4l2_format *f)
 		goto out;
 	}
 	if (f->type == V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE) {
-		fmt = find_format(f, MFC_FMT_ENC);
-		if (!fmt) {
-			mfc_err("failed to set capture format\n");
-			return -EINVAL;
-		}
-		if (!IS_MFCV7(dev) && (fmt->fourcc == V4L2_PIX_FMT_VP8)) {
-			mfc_err("VP8 is supported only in MFC v7\n");
-			return -EINVAL;
-		}
+		/* dst_fmt is validated by call to vidioc_try_fmt */
+		ctx->dst_fmt = find_format(f, MFC_FMT_ENC);
 		ctx->state = MFCINST_INIT;
 		ctx->codec_mode = ctx->dst_fmt->codec_mode;
 		ctx->enc_dst_buf_size =	pix_fmt_mp->plane_fmt[0].sizeimage;
@@ -1063,28 +1061,8 @@ static int vidioc_s_fmt(struct file *file, void *priv, struct v4l2_format *f)
 		}
 		mfc_debug(2, "Got instance number: %d\n", ctx->inst_no);
 	} else if (f->type == V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE) {
-		fmt = find_format(f, MFC_FMT_RAW);
-		if (!fmt) {
-			mfc_err("failed to set output format\n");
-			return -EINVAL;
-		}
-
-		if (!IS_MFCV6_PLUS(dev) &&
-				(fmt->fourcc == V4L2_PIX_FMT_NV12MT_16X16)) {
-			mfc_err("Not supported format.\n");
-			return -EINVAL;
-		} else if (IS_MFCV6_PLUS(dev) &&
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
1.7.9.5

