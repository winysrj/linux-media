Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud6.xs4all.net ([194.109.24.24]:49820 "EHLO
	lb1-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752055AbbFEK7z (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 5 Jun 2015 06:59:55 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: linux-sh@vger.kernel.org, Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 08/10] sh-vou: let sh_vou_s_fmt_vid_out call sh_vou_try_fmt_vid_out
Date: Fri,  5 Jun 2015 12:59:24 +0200
Message-Id: <1433501966-30176-9-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1433501966-30176-1-git-send-email-hverkuil@xs4all.nl>
References: <1433501966-30176-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

This ensures that both do the same checks, and simplifies s_fmt_vid_out
a bit.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/platform/sh_vou.c | 86 +++++++++++++++++++----------------------
 1 file changed, 40 insertions(+), 46 deletions(-)

diff --git a/drivers/media/platform/sh_vou.c b/drivers/media/platform/sh_vou.c
index 400efec..489d045 100644
--- a/drivers/media/platform/sh_vou.c
+++ b/drivers/media/platform/sh_vou.c
@@ -675,34 +675,19 @@ static void vou_adjust_output(struct sh_vou_geometry *geo, v4l2_std_id std)
 		 vou_scale_v_num[idx], vou_scale_v_den[idx], best);
 }
 
-static int sh_vou_s_fmt_vid_out(struct file *file, void *priv,
-				struct v4l2_format *fmt)
+static int sh_vou_try_fmt_vid_out(struct file *file, void *priv,
+				  struct v4l2_format *fmt)
 {
 	struct sh_vou_device *vou_dev = video_drvdata(file);
 	struct v4l2_pix_format *pix = &fmt->fmt.pix;
 	unsigned int img_height_max;
 	int pix_idx;
-	struct sh_vou_geometry geo;
-	struct v4l2_subdev_format format = {
-		.which = V4L2_SUBDEV_FORMAT_ACTIVE,
-		/* Revisit: is this the correct code? */
-		.format.code = MEDIA_BUS_FMT_YUYV8_2X8,
-		.format.field = V4L2_FIELD_INTERLACED,
-		.format.colorspace = V4L2_COLORSPACE_SMPTE170M,
-	};
-	struct v4l2_mbus_framefmt *mbfmt = &format.format;
-	int ret;
-
-	dev_dbg(vou_dev->v4l2_dev.dev, "%s(): %ux%u -> %ux%u\n", __func__,
-		vou_dev->rect.width, vou_dev->rect.height,
-		pix->width, pix->height);
 
-	if (pix->field == V4L2_FIELD_ANY)
-		pix->field = V4L2_FIELD_NONE;
+	dev_dbg(vou_dev->v4l2_dev.dev, "%s()\n", __func__);
 
-	if (fmt->type != V4L2_BUF_TYPE_VIDEO_OUTPUT ||
-	    pix->field != V4L2_FIELD_NONE)
-		return -EINVAL;
+	pix->field = V4L2_FIELD_INTERLACED;
+	pix->colorspace = V4L2_COLORSPACE_SMPTE170M;
+	pix->ycbcr_enc = pix->quantization = 0;
 
 	for (pix_idx = 0; pix_idx < ARRAY_SIZE(vou_fmt); pix_idx++)
 		if (vou_fmt[pix_idx].pfmt == pix->pixelformat)
@@ -716,9 +701,37 @@ static int sh_vou_s_fmt_vid_out(struct file *file, void *priv,
 	else
 		img_height_max = 576;
 
-	/* Image width must be a multiple of 4 */
 	v4l_bound_align_image(&pix->width, 0, VOU_MAX_IMAGE_WIDTH, 2,
 			      &pix->height, 0, img_height_max, 1, 0);
+	pix->bytesperline = pix->width * 2;
+
+	return 0;
+}
+
+static int sh_vou_s_fmt_vid_out(struct file *file, void *priv,
+				struct v4l2_format *fmt)
+{
+	struct sh_vou_device *vou_dev = video_drvdata(file);
+	struct v4l2_pix_format *pix = &fmt->fmt.pix;
+	unsigned int img_height_max;
+	struct sh_vou_geometry geo;
+	struct v4l2_subdev_format format = {
+		.which = V4L2_SUBDEV_FORMAT_ACTIVE,
+		/* Revisit: is this the correct code? */
+		.format.code = MEDIA_BUS_FMT_YUYV8_2X8,
+		.format.field = V4L2_FIELD_INTERLACED,
+		.format.colorspace = V4L2_COLORSPACE_SMPTE170M,
+	};
+	struct v4l2_mbus_framefmt *mbfmt = &format.format;
+	int ret = sh_vou_try_fmt_vid_out(file, priv, fmt);
+	int pix_idx;
+
+	if (ret)
+		return ret;
+
+	for (pix_idx = 0; pix_idx < ARRAY_SIZE(vou_fmt); pix_idx++)
+		if (vou_fmt[pix_idx].pfmt == pix->pixelformat)
+			break;
 
 	geo.in_width = pix->width;
 	geo.in_height = pix->height;
@@ -737,6 +750,11 @@ static int sh_vou_s_fmt_vid_out(struct file *file, void *priv,
 	dev_dbg(vou_dev->v4l2_dev.dev, "%s(): %ux%u -> %ux%u\n", __func__,
 		geo.output.width, geo.output.height, mbfmt->width, mbfmt->height);
 
+	if (vou_dev->std & V4L2_STD_525_60)
+		img_height_max = 480;
+	else
+		img_height_max = 576;
+
 	/* Sanity checks */
 	if ((unsigned)mbfmt->width > VOU_MAX_IMAGE_WIDTH ||
 	    (unsigned)mbfmt->height > img_height_max ||
@@ -769,30 +787,6 @@ static int sh_vou_s_fmt_vid_out(struct file *file, void *priv,
 	return 0;
 }
 
-static int sh_vou_try_fmt_vid_out(struct file *file, void *priv,
-				  struct v4l2_format *fmt)
-{
-	struct sh_vou_device *vou_dev = video_drvdata(file);
-	struct v4l2_pix_format *pix = &fmt->fmt.pix;
-	int i;
-
-	dev_dbg(vou_dev->v4l2_dev.dev, "%s()\n", __func__);
-
-	fmt->type = V4L2_BUF_TYPE_VIDEO_OUTPUT;
-	pix->field = V4L2_FIELD_NONE;
-
-	v4l_bound_align_image(&pix->width, 0, VOU_MAX_IMAGE_WIDTH, 1,
-			      &pix->height, 0, VOU_MAX_IMAGE_HEIGHT, 1, 0);
-
-	for (i = 0; i < ARRAY_SIZE(vou_fmt); i++)
-		if (vou_fmt[i].pfmt == pix->pixelformat)
-			return 0;
-
-	pix->pixelformat = vou_fmt[0].pfmt;
-
-	return 0;
-}
-
 static int sh_vou_reqbufs(struct file *file, void *priv,
 			  struct v4l2_requestbuffers *req)
 {
-- 
2.1.4

