Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.17.9]:64008 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755659Ab1G2K5D (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 29 Jul 2011 06:57:03 -0400
Received: from 6a.grange (6a.grange [192.168.1.11])
	by axis700.grange (Postfix) with ESMTPS id E3CBD189B6E
	for <linux-media@vger.kernel.org>; Fri, 29 Jul 2011 12:56:59 +0200 (CEST)
Received: from lyakh by 6a.grange with local (Exim 4.72)
	(envelope-from <g.liakhovetski@gmx.de>)
	id 1QmkkV-0007mz-O5
	for linux-media@vger.kernel.org; Fri, 29 Jul 2011 12:56:59 +0200
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: linux-media@vger.kernel.org
Subject: [PATCH 01/59] V4L: sh_mobile_ceu_camera: output image sizes must be a multiple of 4
Date: Fri, 29 Jul 2011 12:56:01 +0200
Message-Id: <1311937019-29914-2-git-send-email-g.liakhovetski@gmx.de>
In-Reply-To: <1311937019-29914-1-git-send-email-g.liakhovetski@gmx.de>
References: <1311937019-29914-1-git-send-email-g.liakhovetski@gmx.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

CEU can only produce images with 4 pixel aligned width and height.
Enforce this alignment, adjust comments and simplify some calculations.

Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
---
 drivers/media/video/sh_mobile_ceu_camera.c |   49 +++++++++++++++++----------
 1 files changed, 31 insertions(+), 18 deletions(-)

diff --git a/drivers/media/video/sh_mobile_ceu_camera.c b/drivers/media/video/sh_mobile_ceu_camera.c
index e540898..2e5a01d 100644
--- a/drivers/media/video/sh_mobile_ceu_camera.c
+++ b/drivers/media/video/sh_mobile_ceu_camera.c
@@ -121,7 +121,7 @@ struct sh_mobile_ceu_dev {
 };
 
 struct sh_mobile_ceu_cam {
-	/* CEU offsets within scaled by the CEU camera output */
+	/* CEU offsets within the camera output, before the CEU scaler */
 	unsigned int ceu_left;
 	unsigned int ceu_top;
 	/* Client output, as seen by the CEU */
@@ -628,22 +628,22 @@ static void sh_mobile_ceu_set_rect(struct soc_camera_device *icd)
 	left_offset	= cam->ceu_left;
 	top_offset	= cam->ceu_top;
 
-	/* CEU cropping (CFSZR) is applied _after_ the scaling filter (CFLCR) */
+	WARN_ON(icd->user_width & 3 || icd->user_height & 3);
+
+	width = icd->user_width;
+
 	if (pcdev->image_mode) {
 		in_width = cam->width;
 		if (!pcdev->is_16bit) {
 			in_width *= 2;
 			left_offset *= 2;
 		}
-		width = icd->user_width;
-		cdwdr_width = icd->user_width;
+		cdwdr_width = width;
 	} else {
-		int bytes_per_line = soc_mbus_bytes_per_line(icd->user_width,
+		int bytes_per_line = soc_mbus_bytes_per_line(width,
 						icd->current_fmt->host_fmt);
 		unsigned int w_factor;
 
-		width = icd->user_width;
-
 		switch (icd->current_fmt->host_fmt->packing) {
 		case SOC_MBUS_PACKING_2X8_PADHI:
 			w_factor = 2;
@@ -653,10 +653,10 @@ static void sh_mobile_ceu_set_rect(struct soc_camera_device *icd)
 		}
 
 		in_width = cam->width * w_factor;
-		left_offset = left_offset * w_factor;
+		left_offset *= w_factor;
 
 		if (bytes_per_line < 0)
-			cdwdr_width = icd->user_width;
+			cdwdr_width = width;
 		else
 			cdwdr_width = bytes_per_line;
 	}
@@ -664,7 +664,7 @@ static void sh_mobile_ceu_set_rect(struct soc_camera_device *icd)
 	height = icd->user_height;
 	in_height = cam->height;
 	if (V4L2_FIELD_NONE != pcdev->field) {
-		height /= 2;
+		height = (height / 2) & ~3;
 		in_height /= 2;
 		top_offset /= 2;
 		cdwdr_width *= 2;
@@ -686,6 +686,7 @@ static void sh_mobile_ceu_set_rect(struct soc_camera_device *icd)
 
 	ceu_write(pcdev, CAMOR, camor);
 	ceu_write(pcdev, CAPWR, (in_height << 16) | in_width);
+	/* CFSZR clipping is applied _after_ the scaling filter (CFLCR) */
 	ceu_write(pcdev, CFSZR, (height << 16) | width);
 	ceu_write(pcdev, CDWDR, cdwdr_width);
 }
@@ -1414,7 +1415,10 @@ static int sh_mobile_ceu_set_crop(struct soc_camera_device *icd,
 	capsr = capture_save_reset(pcdev);
 	dev_dbg(dev, "CAPSR 0x%x, CFLCR 0x%x\n", capsr, pcdev->cflcr);
 
-	/* 1. - 2. Apply iterative camera S_CROP for new input window. */
+	/*
+	 * 1. - 2. Apply iterative camera S_CROP for new input window, read back
+	 * actual camera rectangle.
+	 */
 	ret = client_s_crop(icd, a, &cam_crop);
 	if (ret < 0)
 		return ret;
@@ -1498,8 +1502,9 @@ static int sh_mobile_ceu_set_crop(struct soc_camera_device *icd,
 		ceu_write(pcdev, CFLCR, cflcr);
 	}
 
-	icd->user_width	 = out_width;
-	icd->user_height = out_height;
+	icd->user_width	 = out_width & ~3;
+	icd->user_height = out_height & ~3;
+	/* Offsets are applied at the CEU scaling filter input */
 	cam->ceu_left	 = scale_down(rect->left - cam_rect->left, scale_cam_h) & ~1;
 	cam->ceu_top	 = scale_down(rect->top - cam_rect->top, scale_cam_v) & ~1;
 
@@ -1538,7 +1543,7 @@ static int sh_mobile_ceu_get_crop(struct soc_camera_device *icd,
  * CEU crop, mapped backed onto the client input (subrect).
  */
 static void calculate_client_output(struct soc_camera_device *icd,
-		struct v4l2_pix_format *pix, struct v4l2_mbus_framefmt *mf)
+		const struct v4l2_pix_format *pix, struct v4l2_mbus_framefmt *mf)
 {
 	struct sh_mobile_ceu_cam *cam = icd->host_priv;
 	struct device *dev = icd->parent;
@@ -1623,7 +1628,7 @@ static int sh_mobile_ceu_set_fmt(struct soc_camera_device *icd,
 	}
 
 	/* 1.-4. Calculate client output geometry */
-	calculate_client_output(icd, &f->fmt.pix, &mf);
+	calculate_client_output(icd, pix, &mf);
 	mf.field	= pix->field;
 	mf.colorspace	= pix->colorspace;
 	mf.code		= xlate->code;
@@ -1700,6 +1705,10 @@ static int sh_mobile_ceu_set_fmt(struct soc_camera_device *icd,
 	pcdev->field = field;
 	pcdev->image_mode = image_mode;
 
+	/* CFSZR requirement */
+	pix->width	&= ~3;
+	pix->height	&= ~3;
+
 	return 0;
 }
 
@@ -1725,7 +1734,8 @@ static int sh_mobile_ceu_try_fmt(struct soc_camera_device *icd,
 
 	/* FIXME: calculate using depth and bus width */
 
-	v4l_bound_align_image(&pix->width, 2, 2560, 1,
+	/* CFSZR requires height and width to be 4-pixel aligned */
+	v4l_bound_align_image(&pix->width, 2, 2560, 2,
 			      &pix->height, 4, 1920, 2, 0);
 
 	width = pix->width;
@@ -1778,6 +1788,9 @@ static int sh_mobile_ceu_try_fmt(struct soc_camera_device *icd,
 			pix->height = height;
 	}
 
+	pix->width	&= ~3;
+	pix->height	&= ~3;
+
 	dev_geo(icd->parent, "%s(): return %d, fmt 0x%x, %ux%u\n",
 		__func__, ret, pix->pixelformat, pix->width, pix->height);
 
@@ -1824,8 +1837,8 @@ static int sh_mobile_ceu_set_livecrop(struct soc_camera_device *icd,
 			     out_height != f.fmt.pix.height))
 			ret = -EINVAL;
 		if (!ret) {
-			icd->user_width		= out_width;
-			icd->user_height	= out_height;
+			icd->user_width		= out_width & ~3;
+			icd->user_height	= out_height & ~3;
 			ret = sh_mobile_ceu_set_bus_param(icd,
 					icd->current_fmt->host_fmt->fourcc);
 		}
-- 
1.7.2.5

