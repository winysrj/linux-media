Return-path: <mchehab@pedra>
Received: from moutng.kundenserver.de ([212.227.17.10]:49412 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932648Ab1EROL5 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 18 May 2011 10:11:57 -0400
Received: from localhost (localhost [127.0.0.1])
	by axis700.grange (Postfix) with ESMTP id A8FB4189B66
	for <linux-media@vger.kernel.org>; Wed, 18 May 2011 16:11:39 +0200 (CEST)
Date: Wed, 18 May 2011 16:11:39 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 5/5] V4L: soc-camera: a missing mediabus code -> fourcc
 translation is not critical
In-Reply-To: <Pine.LNX.4.64.1105181558440.16324@axis700.grange>
Message-ID: <Pine.LNX.4.64.1105181610280.16324@axis700.grange>
References: <Pine.LNX.4.64.1105181558440.16324@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

soc_mbus_get_fmtdesc() returning NULL means only, that no standard
mediabus code -> fourcc conversion is known, this shouldn't be treated
as an error by drivers.

Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
---
 drivers/media/video/mx3_camera.c           |   24 ++++++++++++------------
 drivers/media/video/omap1_camera.c         |    2 +-
 drivers/media/video/pxa_camera.c           |    8 ++------
 drivers/media/video/sh_mobile_ceu_camera.c |    4 ++--
 drivers/media/video/soc_camera.c           |    9 ++++-----
 5 files changed, 21 insertions(+), 26 deletions(-)

diff --git a/drivers/media/video/mx3_camera.c b/drivers/media/video/mx3_camera.c
index f6063be..0d3993a 100644
--- a/drivers/media/video/mx3_camera.c
+++ b/drivers/media/video/mx3_camera.c
@@ -658,8 +658,8 @@ static int mx3_camera_get_formats(struct soc_camera_device *icd, unsigned int id
 
 	fmt = soc_mbus_get_fmtdesc(code);
 	if (!fmt) {
-		dev_err(icd->dev.parent,
-			"Invalid format code #%u: %d\n", idx, code);
+		dev_warn(icd->dev.parent,
+			 "Unsupported format code #%u: %d\n", idx, code);
 		return 0;
 	}
 
@@ -712,13 +712,9 @@ static int mx3_camera_get_formats(struct soc_camera_device *icd, unsigned int id
 
 static void configure_geometry(struct mx3_camera_dev *mx3_cam,
 			       unsigned int width, unsigned int height,
-			       enum v4l2_mbus_pixelcode code)
+			       const struct soc_mbus_pixelfmt *fmt)
 {
 	u32 ctrl, width_field, height_field;
-	const struct soc_mbus_pixelfmt *fmt;
-
-	fmt = soc_mbus_get_fmtdesc(code);
-	BUG_ON(!fmt);
 
 	if (fourcc_to_ipu_pix(fmt->fourcc) == IPU_PIX_FMT_GENERIC) {
 		/*
@@ -776,8 +772,8 @@ static int acquire_dma_channel(struct mx3_camera_dev *mx3_cam)
  */
 static inline void stride_align(__u32 *width)
 {
-	if (((*width + 7) &  ~7) < 4096)
-		*width = (*width + 7) &  ~7;
+	if (ALIGN(*width, 8) < 4096)
+		*width = ALIGN(*width, 8);
 	else
 		*width = *width &  ~7;
 }
@@ -803,11 +799,14 @@ static int mx3_camera_set_crop(struct soc_camera_device *icd,
 	if (ret < 0)
 		return ret;
 
-	/* The capture device might have changed its output  */
+	/* The capture device might have changed its output sizes */
 	ret = v4l2_subdev_call(sd, video, g_mbus_fmt, &mf);
 	if (ret < 0)
 		return ret;
 
+	if (mf.code != icd->current_fmt->code)
+		return -EINVAL;
+
 	if (mf.width & 7) {
 		/* Ouch! We can only handle 8-byte aligned width... */
 		stride_align(&mf.width);
@@ -817,7 +816,8 @@ static int mx3_camera_set_crop(struct soc_camera_device *icd,
 	}
 
 	if (mf.width != icd->user_width || mf.height != icd->user_height)
-		configure_geometry(mx3_cam, mf.width, mf.height, mf.code);
+		configure_geometry(mx3_cam, mf.width, mf.height,
+				   icd->current_fmt->host_fmt);
 
 	dev_dbg(icd->dev.parent, "Sensor cropped %dx%d\n",
 		mf.width, mf.height);
@@ -855,7 +855,7 @@ static int mx3_camera_set_fmt(struct soc_camera_device *icd,
 	 * mxc_v4l2_s_fmt()
 	 */
 
-	configure_geometry(mx3_cam, pix->width, pix->height, xlate->code);
+	configure_geometry(mx3_cam, pix->width, pix->height, xlate->host_fmt);
 
 	mf.width	= pix->width;
 	mf.height	= pix->height;
diff --git a/drivers/media/video/omap1_camera.c b/drivers/media/video/omap1_camera.c
index fe577a9..e7cfc85 100644
--- a/drivers/media/video/omap1_camera.c
+++ b/drivers/media/video/omap1_camera.c
@@ -1082,7 +1082,7 @@ static int omap1_cam_get_formats(struct soc_camera_device *icd,
 
 	fmt = soc_mbus_get_fmtdesc(code);
 	if (!fmt) {
-		dev_err(dev, "%s: invalid format code #%d: %d\n", __func__,
+		dev_warn(dev, "%s: unsupported format code #%d: %d\n", __func__,
 				idx, code);
 		return 0;
 	}
diff --git a/drivers/media/video/pxa_camera.c b/drivers/media/video/pxa_camera.c
index c1ee09a..b42bfa5 100644
--- a/drivers/media/video/pxa_camera.c
+++ b/drivers/media/video/pxa_camera.c
@@ -1155,15 +1155,11 @@ static int pxa_camera_set_bus_param(struct soc_camera_device *icd, __u32 pixfmt)
 	struct soc_camera_host *ici = to_soc_camera_host(icd->dev.parent);
 	struct pxa_camera_dev *pcdev = ici->priv;
 	unsigned long bus_flags, camera_flags, common_flags;
-	const struct soc_mbus_pixelfmt *fmt;
 	int ret;
 	struct pxa_cam *cam = icd->host_priv;
 
-	fmt = soc_mbus_get_fmtdesc(icd->current_fmt->code);
-	if (!fmt)
-		return -EINVAL;
-
-	ret = test_platform_param(pcdev, fmt->bits_per_sample, &bus_flags);
+	ret = test_platform_param(pcdev, icd->current_fmt->host_fmt->bits_per_sample,
+				  &bus_flags);
 	if (ret < 0)
 		return ret;
 
diff --git a/drivers/media/video/sh_mobile_ceu_camera.c b/drivers/media/video/sh_mobile_ceu_camera.c
index 134e86b..c774917 100644
--- a/drivers/media/video/sh_mobile_ceu_camera.c
+++ b/drivers/media/video/sh_mobile_ceu_camera.c
@@ -891,8 +891,8 @@ static int sh_mobile_ceu_get_formats(struct soc_camera_device *icd, unsigned int
 
 	fmt = soc_mbus_get_fmtdesc(code);
 	if (!fmt) {
-		dev_err(dev, "Invalid format code #%u: %d\n", idx, code);
-		return -EINVAL;
+		dev_warn(dev, "unsupported format code #%u: %d\n", idx, code);
+		return 0;
 	}
 
 	if (!pcdev->pdata->csi2_dev) {
diff --git a/drivers/media/video/soc_camera.c b/drivers/media/video/soc_camera.c
index ddb4c09..1fbb77b 100644
--- a/drivers/media/video/soc_camera.c
+++ b/drivers/media/video/soc_camera.c
@@ -358,8 +358,6 @@ static int soc_camera_init_user_formats(struct soc_camera_device *icd)
 	if (!icd->user_formats)
 		return -ENOMEM;
 
-	icd->num_user_formats = fmts;
-
 	dev_dbg(&icd->dev, "Found %d supported formats.\n", fmts);
 
 	/* Second pass - actually fill data formats */
@@ -367,9 +365,10 @@ static int soc_camera_init_user_formats(struct soc_camera_device *icd)
 	for (i = 0; i < raw_fmts; i++)
 		if (!ici->ops->get_formats) {
 			v4l2_subdev_call(sd, video, enum_mbus_fmt, i, &code);
-			icd->user_formats[i].host_fmt =
+			icd->user_formats[fmts].host_fmt =
 				soc_mbus_get_fmtdesc(code);
-			icd->user_formats[i].code = code;
+			if (icd->user_formats[fmts].host_fmt)
+				icd->user_formats[fmts++].code = code;
 		} else {
 			ret = ici->ops->get_formats(icd, i,
 						    &icd->user_formats[fmts]);
@@ -378,12 +377,12 @@ static int soc_camera_init_user_formats(struct soc_camera_device *icd)
 			fmts += ret;
 		}
 
+	icd->num_user_formats = fmts;
 	icd->current_fmt = &icd->user_formats[0];
 
 	return 0;
 
 egfmt:
-	icd->num_user_formats = 0;
 	vfree(icd->user_formats);
 	return ret;
 }
-- 
1.7.2.5

