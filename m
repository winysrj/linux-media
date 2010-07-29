Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout-de.gmx.net ([213.165.64.22]:42655 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1753438Ab0G2Hh7 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 29 Jul 2010 03:37:59 -0400
Received: from lyakh (helo=localhost)
	by axis700.grange with local-esmtp (Exim 4.63)
	(envelope-from <g.liakhovetski@gmx.de>)
	id 1OeNgu-00064w-BR
	for linux-media@vger.kernel.org; Thu, 29 Jul 2010 09:38:08 +0200
Date: Thu, 29 Jul 2010 09:38:08 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH] V4L2: sh_vou: VOU does support the full PAL resolution too
Message-ID: <Pine.LNX.4.64.1007290937280.16266@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

SH7724 datasheet specifies 480 pixels as the VOU maximum vertical resolution.
This is a bug in the datasheet, VOU also supports the full PAL resolution: 576
lines. Adjust the driver accordingly.

Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
---
 drivers/media/video/sh_vou.c |   56 +++++++++++++++++++++++++----------------
 1 files changed, 34 insertions(+), 22 deletions(-)

diff --git a/drivers/media/video/sh_vou.c b/drivers/media/video/sh_vou.c
index e9d5e6a..80351db 100644
--- a/drivers/media/video/sh_vou.c
+++ b/drivers/media/video/sh_vou.c
@@ -57,7 +57,7 @@ enum sh_vou_status {
 };
 
 #define VOU_MAX_IMAGE_WIDTH	720
-#define VOU_MAX_IMAGE_HEIGHT	480
+#define VOU_MAX_IMAGE_HEIGHT	576
 
 struct sh_vou_device {
 	struct v4l2_device v4l2_dev;
@@ -527,20 +527,17 @@ struct sh_vou_geometry {
 static void vou_adjust_input(struct sh_vou_geometry *geo, v4l2_std_id std)
 {
 	/* The compiler cannot know, that best and idx will indeed be set */
-	unsigned int best_err = UINT_MAX, best = 0, width_max, height_max;
+	unsigned int best_err = UINT_MAX, best = 0, img_height_max;
 	int i, idx = 0;
 
-	if (std & V4L2_STD_525_60) {
-		width_max = 858;
-		height_max = 262;
-	} else {
-		width_max = 864;
-		height_max = 312;
-	}
+	if (std & V4L2_STD_525_60)
+		img_height_max = 480;
+	else
+		img_height_max = 576;
 
 	/* Image width must be a multiple of 4 */
 	v4l_bound_align_image(&geo->in_width, 0, VOU_MAX_IMAGE_WIDTH, 2,
-			      &geo->in_height, 0, VOU_MAX_IMAGE_HEIGHT, 1, 0);
+			      &geo->in_height, 0, img_height_max, 1, 0);
 
 	/* Select scales to come as close as possible to the output image */
 	for (i = ARRAY_SIZE(vou_scale_h_num) - 1; i >= 0; i--) {
@@ -573,7 +570,7 @@ static void vou_adjust_input(struct sh_vou_geometry *geo, v4l2_std_id std)
 		unsigned int found = geo->output.height * vou_scale_v_den[i] /
 			vou_scale_v_num[i];
 
-		if (found > VOU_MAX_IMAGE_HEIGHT)
+		if (found > img_height_max)
 			/* scales increase */
 			break;
 
@@ -597,15 +594,18 @@ static void vou_adjust_input(struct sh_vou_geometry *geo, v4l2_std_id std)
  */
 static void vou_adjust_output(struct sh_vou_geometry *geo, v4l2_std_id std)
 {
-	unsigned int best_err = UINT_MAX, best, width_max, height_max;
+	unsigned int best_err = UINT_MAX, best, width_max, height_max,
+		img_height_max;
 	int i, idx;
 
 	if (std & V4L2_STD_525_60) {
 		width_max = 858;
 		height_max = 262 * 2;
+		img_height_max = 480;
 	} else {
 		width_max = 864;
 		height_max = 312 * 2;
+		img_height_max = 576;
 	}
 
 	/* Select scales to come as close as possible to the output image */
@@ -644,7 +644,7 @@ static void vou_adjust_output(struct sh_vou_geometry *geo, v4l2_std_id std)
 		unsigned int found = geo->in_height * vou_scale_v_num[i] /
 			vou_scale_v_den[i];
 
-		if (found > VOU_MAX_IMAGE_HEIGHT)
+		if (found > img_height_max)
 			/* scales increase */
 			break;
 
@@ -673,6 +673,7 @@ static int sh_vou_s_fmt_vid_out(struct file *file, void *priv,
 	struct video_device *vdev = video_devdata(file);
 	struct sh_vou_device *vou_dev = video_get_drvdata(vdev);
 	struct v4l2_pix_format *pix = &fmt->fmt.pix;
+	unsigned int img_height_max;
 	int pix_idx;
 	struct sh_vou_geometry geo;
 	struct v4l2_mbus_framefmt mbfmt = {
@@ -701,9 +702,14 @@ static int sh_vou_s_fmt_vid_out(struct file *file, void *priv,
 	if (pix_idx == ARRAY_SIZE(vou_fmt))
 		return -EINVAL;
 
+	if (vou_dev->std & V4L2_STD_525_60)
+		img_height_max = 480;
+	else
+		img_height_max = 576;
+
 	/* Image width must be a multiple of 4 */
 	v4l_bound_align_image(&pix->width, 0, VOU_MAX_IMAGE_WIDTH, 2,
-			      &pix->height, 0, VOU_MAX_IMAGE_HEIGHT, 1, 0);
+			      &pix->height, 0, img_height_max, 1, 0);
 
 	geo.in_width = pix->width;
 	geo.in_height = pix->height;
@@ -724,7 +730,7 @@ static int sh_vou_s_fmt_vid_out(struct file *file, void *priv,
 
 	/* Sanity checks */
 	if ((unsigned)mbfmt.width > VOU_MAX_IMAGE_WIDTH ||
-	    (unsigned)mbfmt.height > VOU_MAX_IMAGE_HEIGHT ||
+	    (unsigned)mbfmt.height > img_height_max ||
 	    mbfmt.code != V4L2_MBUS_FMT_YUYV8_2X8)
 		return -EIO;
 
@@ -940,6 +946,7 @@ static int sh_vou_s_crop(struct file *file, void *fh, struct v4l2_crop *a)
 		.field = V4L2_FIELD_INTERLACED,
 		.colorspace = V4L2_COLORSPACE_SMPTE170M,
 	};
+	unsigned int img_height_max;
 	int ret;
 
 	dev_dbg(vou_dev->v4l2_dev.dev, "%s(): %ux%u@%u:%u\n", __func__,
@@ -948,14 +955,19 @@ static int sh_vou_s_crop(struct file *file, void *fh, struct v4l2_crop *a)
 	if (a->type != V4L2_BUF_TYPE_VIDEO_OUTPUT)
 		return -EINVAL;
 
+	if (vou_dev->std & V4L2_STD_525_60)
+		img_height_max = 480;
+	else
+		img_height_max = 576;
+
 	v4l_bound_align_image(&rect->width, 0, VOU_MAX_IMAGE_WIDTH, 1,
-			      &rect->height, 0, VOU_MAX_IMAGE_HEIGHT, 1, 0);
+			      &rect->height, 0, img_height_max, 1, 0);
 
 	if (rect->width + rect->left > VOU_MAX_IMAGE_WIDTH)
 		rect->left = VOU_MAX_IMAGE_WIDTH - rect->width;
 
-	if (rect->height + rect->top > VOU_MAX_IMAGE_HEIGHT)
-		rect->top = VOU_MAX_IMAGE_HEIGHT - rect->height;
+	if (rect->height + rect->top > img_height_max)
+		rect->top = img_height_max - rect->height;
 
 	geo.output = *rect;
 	geo.in_width = pix->width;
@@ -980,7 +992,7 @@ static int sh_vou_s_crop(struct file *file, void *fh, struct v4l2_crop *a)
 
 	/* Sanity checks */
 	if ((unsigned)mbfmt.width > VOU_MAX_IMAGE_WIDTH ||
-	    (unsigned)mbfmt.height > VOU_MAX_IMAGE_HEIGHT ||
+	    (unsigned)mbfmt.height > img_height_max ||
 	    mbfmt.code != V4L2_MBUS_FMT_YUYV8_2X8)
 		return -EIO;
 
@@ -1329,13 +1341,13 @@ static int __devinit sh_vou_probe(struct platform_device *pdev)
 	rect->left		= 0;
 	rect->top		= 0;
 	rect->width		= VOU_MAX_IMAGE_WIDTH;
-	rect->height		= VOU_MAX_IMAGE_HEIGHT;
+	rect->height		= 480;
 	pix->width		= VOU_MAX_IMAGE_WIDTH;
-	pix->height		= VOU_MAX_IMAGE_HEIGHT;
+	pix->height		= 480;
 	pix->pixelformat	= V4L2_PIX_FMT_YVYU;
 	pix->field		= V4L2_FIELD_NONE;
 	pix->bytesperline	= VOU_MAX_IMAGE_WIDTH * 2;
-	pix->sizeimage		= VOU_MAX_IMAGE_WIDTH * 2 * VOU_MAX_IMAGE_HEIGHT;
+	pix->sizeimage		= VOU_MAX_IMAGE_WIDTH * 2 * 480;
 	pix->colorspace		= V4L2_COLORSPACE_SMPTE170M;
 
 	region = request_mem_region(reg_res->start, resource_size(reg_res),
-- 
1.7.2

