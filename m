Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ie0-f201.google.com ([209.85.223.201]:39570 "EHLO
	mail-ie0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755191Ab3JIX6Q (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 9 Oct 2013 19:58:16 -0400
Received: by mail-ie0-f201.google.com with SMTP id tp5so450186ieb.0
        for <linux-media@vger.kernel.org>; Wed, 09 Oct 2013 16:58:16 -0700 (PDT)
From: John Sheu <sheu@google.com>
To: linux-media@vger.kernel.org
Cc: John Sheu <sheu@google.com>, m.chehab@samsung.com,
	k.debski@samsung.com, pawel@osciak.com
Subject: [PATCH 3/6] [media] s5p-mfc: add support for VIDIOC_{G,S}_CROP to encoder
Date: Wed,  9 Oct 2013 16:49:46 -0700
Message-Id: <1381362589-32237-4-git-send-email-sheu@google.com>
In-Reply-To: <1381362589-32237-1-git-send-email-sheu@google.com>
References: <1381362589-32237-1-git-send-email-sheu@google.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Allow userspace to set the crop rect of the input image buffer to
encode.

Signed-off-by: John Sheu <sheu@google.com>
---
 drivers/media/platform/s5p-mfc/s5p_mfc_common.h |  6 ++-
 drivers/media/platform/s5p-mfc/s5p_mfc_dec.c    |  7 ++--
 drivers/media/platform/s5p-mfc/s5p_mfc_enc.c    | 54 ++++++++++++++++++++++++-
 drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c | 16 +++++---
 4 files changed, 70 insertions(+), 13 deletions(-)

diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc_common.h b/drivers/media/platform/s5p-mfc/s5p_mfc_common.h
index 6920b54..48f706f 100644
--- a/drivers/media/platform/s5p-mfc/s5p_mfc_common.h
+++ b/drivers/media/platform/s5p-mfc/s5p_mfc_common.h
@@ -428,8 +428,10 @@ struct s5p_mfc_vp8_enc_params {
  * struct s5p_mfc_enc_params - general encoding parameters
  */
 struct s5p_mfc_enc_params {
-	u16 width;
-	u16 height;
+	u16 crop_left_offset;
+	u16 crop_right_offset;
+	u16 crop_top_offset;
+	u16 crop_bottom_offset;
 
 	u16 gop_size;
 	enum v4l2_mpeg_video_multi_slice_mode slice_mode;
diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc_dec.c b/drivers/media/platform/s5p-mfc/s5p_mfc_dec.c
index 8faf969..e99bcb8 100644
--- a/drivers/media/platform/s5p-mfc/s5p_mfc_dec.c
+++ b/drivers/media/platform/s5p-mfc/s5p_mfc_dec.c
@@ -334,10 +334,9 @@ static int vidioc_g_fmt(struct file *file, void *priv, struct v4l2_format *f)
 	    ctx->state >= MFCINST_HEAD_PARSED &&
 	    ctx->state < MFCINST_ABORT) {
 		/* This is run on CAPTURE (decode output) */
-		/* Width and height are set to the dimensions
-		   of the movie, the buffer is bigger and
-		   further processing stages should crop to this
-		   rectangle. */
+		/* Width and height are set to the dimensions of the buffer,
+		   The movie's dimensions may be smaller; the cropping rectangle
+		   required should be queried with VIDIOC_G_CROP. */
 		pix_mp->width = ctx->buf_width;
 		pix_mp->height = ctx->buf_height;
 		pix_mp->field = V4L2_FIELD_NONE;
diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc_enc.c b/drivers/media/platform/s5p-mfc/s5p_mfc_enc.c
index 8b24829..4ad9349 100644
--- a/drivers/media/platform/s5p-mfc/s5p_mfc_enc.c
+++ b/drivers/media/platform/s5p-mfc/s5p_mfc_enc.c
@@ -1599,7 +1599,57 @@ static int vidioc_g_parm(struct file *file, void *priv,
 		a->parm.output.timeperframe.numerator =
 					ctx->enc_params.rc_framerate_denom;
 	} else {
-		mfc_err("Setting FPS is only possible for the output queue\n");
+		mfc_err("Getting FPS is only possible for the output queue\n");
+		return -EINVAL;
+	}
+	return 0;
+}
+
+static int vidioc_g_crop(struct file *file, void *priv, struct v4l2_crop *a)
+{
+	struct s5p_mfc_ctx *ctx = fh_to_ctx(priv);
+	struct s5p_mfc_enc_params *p = &ctx->enc_params;
+
+	if (a->type == V4L2_BUF_TYPE_VIDEO_OUTPUT) {
+		a->c.left = p->crop_left_offset;
+		a->c.top = p->crop_top_offset;
+		a->c.width = ctx->img_width -
+			(p->crop_left_offset + p->crop_right_offset);
+		a->c.height = ctx->img_height -
+			(p->crop_top_offset + p->crop_bottom_offset);
+	} else {
+		mfc_err("Getting crop is only possible for the output queue\n");
+		return -EINVAL;
+	}
+	return 0;
+}
+
+static int vidioc_s_crop(struct file *file, void *priv,
+			 const struct v4l2_crop *a)
+{
+	struct s5p_mfc_ctx *ctx = fh_to_ctx(priv);
+	struct s5p_mfc_enc_params *p = &ctx->enc_params;
+
+	if (a->type == V4L2_BUF_TYPE_VIDEO_OUTPUT) {
+		int left, right, top, bottom;
+		left = round_down(a->c.left, 16);
+		right = ctx->img_width - (left + a->c.width);
+		top = round_down(a->c.top, 16);
+		bottom = ctx->img_height - (top + a->c.height);
+		if (left > ctx->img_width)
+			left = ctx->img_width;
+		if (right < 0)
+			right = 0;
+		if (top > ctx->img_height)
+			top = ctx->img_height;
+		if (bottom < 0)
+			bottom = 0;
+		p->crop_left_offset = left;
+		p->crop_right_offset = right;
+		p->crop_top_offset = top;
+		p->crop_bottom_offset = bottom;
+	} else {
+		mfc_err("Setting crop is only possible for the output queue\n");
 		return -EINVAL;
 	}
 	return 0;
@@ -1679,6 +1729,8 @@ static const struct v4l2_ioctl_ops s5p_mfc_enc_ioctl_ops = {
 	.vidioc_streamoff = vidioc_streamoff,
 	.vidioc_s_parm = vidioc_s_parm,
 	.vidioc_g_parm = vidioc_g_parm,
+	.vidioc_g_crop = vidioc_g_crop,
+	.vidioc_s_crop = vidioc_s_crop,
 	.vidioc_encoder_cmd = vidioc_encoder_cmd,
 	.vidioc_subscribe_event = vidioc_subscribe_event,
 	.vidioc_unsubscribe_event = v4l2_event_unsubscribe,
diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c b/drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c
index 5bf6efd..1bb487c 100644
--- a/drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c
+++ b/drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c
@@ -600,12 +600,16 @@ static int s5p_mfc_set_enc_params(struct s5p_mfc_ctx *ctx)
 	/* height */
 	WRITEL(ctx->img_height, S5P_FIMV_E_FRAME_HEIGHT_V6); /* 16 align */
 
-	/* cropped width */
-	WRITEL(ctx->img_width, S5P_FIMV_E_CROPPED_FRAME_WIDTH_V6);
-	/* cropped height */
-	WRITEL(ctx->img_height, S5P_FIMV_E_CROPPED_FRAME_HEIGHT_V6);
-	/* cropped offset */
-	WRITEL(0x0, S5P_FIMV_E_FRAME_CROP_OFFSET_V6);
+	/* cropped width, pixels */
+	WRITEL(ctx->img_width - (p->crop_left_offset + p->crop_right_offset),
+		S5P_FIMV_E_CROPPED_FRAME_WIDTH_V6);
+	/* cropped height, pixels */
+	WRITEL(ctx->img_height - (p->crop_top_offset + p->crop_bottom_offset),
+		S5P_FIMV_E_CROPPED_FRAME_HEIGHT_V6);
+	/* cropped offset, macroblocks */
+	WRITEL(((p->crop_left_offset / 16) & 0x2FF) |
+		(((p->crop_top_offset / 16) & 0x2FF) << 10),
+		S5P_FIMV_E_FRAME_CROP_OFFSET_V6);
 
 	/* pictype : IDR period */
 	reg = 0;
-- 
1.8.4

