Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr13.xs4all.nl ([194.109.24.33]:3519 "EHLO
	smtp-vbr13.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753147Ab0EINzu (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 9 May 2010 09:55:50 -0400
Message-Id: <a62f14806c8cef3e95bb11ee18f8ce20b79db580.1273413060.git.hverkuil@xs4all.nl>
In-Reply-To: <cover.1273413060.git.hverkuil@xs4all.nl>
References: <cover.1273413060.git.hverkuil@xs4all.nl>
From: Hans Verkuil <hverkuil@xs4all.nl>
Date: Sun, 09 May 2010 15:57:20 +0200
Subject: [PATCH 6/6] [RFC] tvp514x: simplify try/g/s_fmt handling
To: linux-media@vger.kernel.org
Cc: hvaibhav@ti.com
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Since there is only one possible format just have all three calls
do the same.

Signed-off-by: Hans Verkuil <hverkuil@xs4all.nl>
---
 drivers/media/video/tvp514x.c |   98 ++++-------------------------------------
 1 files changed, 9 insertions(+), 89 deletions(-)

diff --git a/drivers/media/video/tvp514x.c b/drivers/media/video/tvp514x.c
index 1c3417b..b0465d2 100644
--- a/drivers/media/video/tvp514x.c
+++ b/drivers/media/video/tvp514x.c
@@ -87,7 +87,6 @@ static int tvp514x_s_stream(struct v4l2_subdev *sd, int enable);
  * @pdata: Board specific
  * @ver: Chip version
  * @streaming: TVP5146/47 decoder streaming - enabled or disabled.
- * @pix: Current pixel format
  * @current_std: Current standard
  * @num_stds: Number of standards
  * @std_list: Standards list
@@ -102,8 +101,6 @@ struct tvp514x_decoder {
 	int ver;
 	int streaming;
 
-	struct v4l2_pix_format pix;
-
 	enum tvp514x_std current_std;
 	int num_stds;
 	const struct tvp514x_std_info *std_list;
@@ -956,16 +953,15 @@ tvp514x_enum_fmt_cap(struct v4l2_subdev *sd, struct v4l2_fmtdesc *fmt)
 }
 
 /**
- * tvp514x_try_fmt_cap() - V4L2 decoder interface handler for try_fmt
+ * tvp514x_fmt_cap() - V4L2 decoder interface handler for try/s/g_fmt
  * @sd: pointer to standard V4L2 sub-device structure
  * @f: pointer to standard V4L2 VIDIOC_TRY_FMT ioctl structure
  *
- * Implement the VIDIOC_TRY_FMT ioctl for the CAPTURE buffer type. This
- * ioctl is used to negotiate the image capture size and pixel format
- * without actually making it take effect.
+ * Implement the VIDIOC_TRY/S/G_FMT ioctl for the CAPTURE buffer type. This
+ * ioctl is used to negotiate the image capture size and pixel format.
  */
 static int
-tvp514x_try_fmt_cap(struct v4l2_subdev *sd, struct v4l2_format *f)
+tvp514x_fmt_cap(struct v4l2_subdev *sd, struct v4l2_format *f)
 {
 	struct tvp514x_decoder *decoder = to_decoder(sd);
 	struct v4l2_pix_format *pix;
@@ -975,8 +971,7 @@ tvp514x_try_fmt_cap(struct v4l2_subdev *sd, struct v4l2_format *f)
 		return -EINVAL;
 
 	if (f->type != V4L2_BUF_TYPE_VIDEO_CAPTURE)
-		/* only capture is supported */
-		f->type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
+		return -EINVAL;
 
 	pix = &f->fmt.pix;
 
@@ -992,7 +987,7 @@ tvp514x_try_fmt_cap(struct v4l2_subdev *sd, struct v4l2_format *f)
 	pix->colorspace = V4L2_COLORSPACE_SMPTE170M;
 	pix->priv = 0;
 
-	v4l2_dbg(1, debug, sd, "Try FMT: bytesperline - %d"
+	v4l2_dbg(1, debug, sd, "FMT: bytesperline - %d"
 			"Width - %d, Height - %d\n",
 			pix->bytesperline,
 			pix->width, pix->height);
@@ -1000,68 +995,6 @@ tvp514x_try_fmt_cap(struct v4l2_subdev *sd, struct v4l2_format *f)
 }
 
 /**
- * tvp514x_s_fmt_cap() - V4L2 decoder interface handler for s_fmt
- * @sd: pointer to standard V4L2 sub-device structure
- * @f: pointer to standard V4L2 VIDIOC_S_FMT ioctl structure
- *
- * If the requested format is supported, configures the HW to use that
- * format, returns error code if format not supported or HW can't be
- * correctly configured.
- */
-static int
-tvp514x_s_fmt_cap(struct v4l2_subdev *sd, struct v4l2_format *f)
-{
-	struct tvp514x_decoder *decoder = to_decoder(sd);
-	struct v4l2_pix_format *pix;
-	int rval;
-
-	if (f == NULL)
-		return -EINVAL;
-
-	if (f->type != V4L2_BUF_TYPE_VIDEO_CAPTURE)
-		/* only capture is supported */
-		return -EINVAL;
-
-	pix = &f->fmt.pix;
-	rval = tvp514x_try_fmt_cap(sd, f);
-	if (rval)
-		return rval;
-
-		decoder->pix = *pix;
-
-	return rval;
-}
-
-/**
- * tvp514x_g_fmt_cap() - V4L2 decoder interface handler for tvp514x_g_fmt_cap
- * @sd: pointer to standard V4L2 sub-device structure
- * @f: pointer to standard V4L2 v4l2_format structure
- *
- * Returns the decoder's current pixel format in the v4l2_format
- * parameter.
- */
-static int
-tvp514x_g_fmt_cap(struct v4l2_subdev *sd, struct v4l2_format *f)
-{
-	struct tvp514x_decoder *decoder = to_decoder(sd);
-
-	if (f == NULL)
-		return -EINVAL;
-
-	if (f->type != V4L2_BUF_TYPE_VIDEO_CAPTURE)
-		/* only capture is supported */
-		return -EINVAL;
-
-	f->fmt.pix = decoder->pix;
-
-	v4l2_dbg(1, debug, sd, "Current FMT: bytesperline - %d"
-			"Width - %d, Height - %d\n",
-			decoder->pix.bytesperline,
-			decoder->pix.width, decoder->pix.height);
-	return 0;
-}
-
-/**
  * tvp514x_g_parm() - V4L2 decoder interface handler for g_parm
  * @sd: pointer to standard V4L2 sub-device structure
  * @a: pointer to standard V4L2 VIDIOC_G_PARM ioctl structure
@@ -1198,9 +1131,9 @@ static const struct v4l2_subdev_video_ops tvp514x_video_ops = {
 	.s_routing = tvp514x_s_routing,
 	.querystd = tvp514x_querystd,
 	.enum_fmt = tvp514x_enum_fmt_cap,
-	.g_fmt = tvp514x_g_fmt_cap,
-	.try_fmt = tvp514x_try_fmt_cap,
-	.s_fmt = tvp514x_s_fmt_cap,
+	.g_fmt = tvp514x_fmt_cap,
+	.try_fmt = tvp514x_fmt_cap,
+	.s_fmt = tvp514x_fmt_cap,
 	.g_parm = tvp514x_g_parm,
 	.s_parm = tvp514x_s_parm,
 	.s_stream = tvp514x_s_stream,
@@ -1213,19 +1146,6 @@ static const struct v4l2_subdev_ops tvp514x_ops = {
 
 static struct tvp514x_decoder tvp514x_dev = {
 	.streaming = 0,
-
-	.pix = {
-		/* Default to NTSC 8-bit YUV 422 */
-		.width = NTSC_NUM_ACTIVE_PIXELS,
-		.height = NTSC_NUM_ACTIVE_LINES,
-		.pixelformat = V4L2_PIX_FMT_UYVY,
-		.field = V4L2_FIELD_INTERLACED,
-		.bytesperline = NTSC_NUM_ACTIVE_PIXELS * 2,
-		.sizeimage =
-		NTSC_NUM_ACTIVE_PIXELS * 2 * NTSC_NUM_ACTIVE_LINES,
-		.colorspace = V4L2_COLORSPACE_SMPTE170M,
-		},
-
 	.current_std = STD_NTSC_MJ,
 	.std_list = tvp514x_std_list,
 	.num_stds = ARRAY_SIZE(tvp514x_std_list),
-- 
1.6.4.2

