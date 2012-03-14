Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.17.8]:54349 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753518Ab2CNPCW (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 14 Mar 2012 11:02:22 -0400
Date: Wed, 14 Mar 2012 16:02:20 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
cc: linux-sh@vger.kernel.org
Subject: [PATCH 1/2] V4L: sh_mobile_ceu_camera: maximum image size depends
 on the hardware version
Message-ID: <Pine.LNX.4.64.1203141600210.25284@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Newer CEU versions, e.g., the one, used on sh7372, support image sizes
larger than 2560x1920. Retrieve maximum sizes from platform properties.

Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
---
 drivers/media/video/sh_mobile_ceu_camera.c |   35 +++++++++++++++++++++------
 include/media/sh_mobile_ceu.h              |    2 +
 2 files changed, 29 insertions(+), 8 deletions(-)

diff --git a/drivers/media/video/sh_mobile_ceu_camera.c b/drivers/media/video/sh_mobile_ceu_camera.c
index f854d85..424dfac 100644
--- a/drivers/media/video/sh_mobile_ceu_camera.c
+++ b/drivers/media/video/sh_mobile_ceu_camera.c
@@ -112,6 +112,10 @@ struct sh_mobile_ceu_dev {
 
 	u32 cflcr;
 
+	/* static max sizes either from platform data or default */
+	int max_width;
+	int max_height;
+
 	enum v4l2_field field;
 	int sequence;
 
@@ -1081,7 +1085,15 @@ static int sh_mobile_ceu_get_formats(struct soc_camera_device *icd, unsigned int
 		if (ret < 0)
 			return ret;
 
-		while ((mf.width > 2560 || mf.height > 1920) && shift < 4) {
+		/*
+		 * All currently existing CEU implementations support 2560x1920
+		 * or larger frames. If the sensor is proposing too big a frame,
+		 * don't bother with possibly supportred by the CEU larger
+		 * sizes, just try VGA multiples. If needed, this can be
+		 * adjusted in the future.
+		 */
+		while ((mf.width > pcdev->max_width ||
+			mf.height > pcdev->max_height) && shift < 4) {
 			/* Try 2560x1920, 1280x960, 640x480, 320x240 */
 			mf.width	= 2560 >> shift;
 			mf.height	= 1920 >> shift;
@@ -1377,6 +1389,8 @@ static int client_s_crop(struct soc_camera_device *icd, struct v4l2_crop *crop,
 static int client_s_fmt(struct soc_camera_device *icd,
 			struct v4l2_mbus_framefmt *mf, bool ceu_can_scale)
 {
+	struct soc_camera_host *ici = to_soc_camera_host(icd->parent);
+	struct sh_mobile_ceu_dev *pcdev = ici->priv;
 	struct sh_mobile_ceu_cam *cam = icd->host_priv;
 	struct v4l2_subdev *sd = soc_camera_to_subdev(icd);
 	struct device *dev = icd->parent;
@@ -1410,8 +1424,8 @@ static int client_s_fmt(struct soc_camera_device *icd,
 	if (ret < 0)
 		return ret;
 
-	max_width = min(cap.bounds.width, 2560);
-	max_height = min(cap.bounds.height, 1920);
+	max_width = min(cap.bounds.width, pcdev->max_width);
+	max_height = min(cap.bounds.height, pcdev->max_height);
 
 	/* Camera set a format, but geometry is not precise, try to improve */
 	tmp_w = mf->width;
@@ -1551,7 +1565,7 @@ static int sh_mobile_ceu_set_crop(struct soc_camera_device *icd,
 	if (ret < 0)
 		return ret;
 
-	if (mf.width > 2560 || mf.height > 1920)
+	if (mf.width > pcdev->max_width || mf.height > pcdev->max_height)
 		return -EINVAL;
 
 	/* 4. Calculate camera scales */
@@ -1834,6 +1848,8 @@ static int sh_mobile_ceu_set_fmt(struct soc_camera_device *icd,
 static int sh_mobile_ceu_try_fmt(struct soc_camera_device *icd,
 				 struct v4l2_format *f)
 {
+	struct soc_camera_host *ici = to_soc_camera_host(icd->parent);
+	struct sh_mobile_ceu_dev *pcdev = ici->priv;
 	const struct soc_camera_format_xlate *xlate;
 	struct v4l2_pix_format *pix = &f->fmt.pix;
 	struct v4l2_subdev *sd = soc_camera_to_subdev(icd);
@@ -1854,8 +1870,8 @@ static int sh_mobile_ceu_try_fmt(struct soc_camera_device *icd,
 	/* FIXME: calculate using depth and bus width */
 
 	/* CFSZR requires height and width to be 4-pixel aligned */
-	v4l_bound_align_image(&pix->width, 2, 2560, 2,
-			      &pix->height, 4, 1920, 2, 0);
+	v4l_bound_align_image(&pix->width, 2, pcdev->max_width, 2,
+			      &pix->height, 4, pcdev->max_height, 2, 0);
 
 	width = pix->width;
 	height = pix->height;
@@ -1890,8 +1906,8 @@ static int sh_mobile_ceu_try_fmt(struct soc_camera_device *icd,
 			 * requested a bigger rectangle, it will not return a
 			 * smaller one.
 			 */
-			mf.width = 2560;
-			mf.height = 1920;
+			mf.width = pcdev->max_width;
+			mf.height = pcdev->max_height;
 			ret = v4l2_device_call_until_err(sd->v4l2_dev,
 					soc_camera_grp_id(icd), video,
 					try_mbus_fmt, &mf);
@@ -2082,6 +2098,9 @@ static int __devinit sh_mobile_ceu_probe(struct platform_device *pdev)
 		goto exit_kfree;
 	}
 
+	pcdev->max_width = pcdev->pdata->max_width ? : 2560;
+	pcdev->max_height = pcdev->pdata->max_height ? : 1920;
+
 	base = ioremap_nocache(res->start, resource_size(res));
 	if (!base) {
 		err = -ENXIO;
diff --git a/include/media/sh_mobile_ceu.h b/include/media/sh_mobile_ceu.h
index 48413b4..a90a765 100644
--- a/include/media/sh_mobile_ceu.h
+++ b/include/media/sh_mobile_ceu.h
@@ -18,6 +18,8 @@ struct sh_mobile_ceu_companion {
 
 struct sh_mobile_ceu_info {
 	unsigned long flags;
+	int max_width;
+	int max_height;
 	struct sh_mobile_ceu_companion *csi2;
 };
 
-- 
1.7.2.5

