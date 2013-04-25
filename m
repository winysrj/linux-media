Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.186]:61769 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932373Ab3DYOPs (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 25 Apr 2013 10:15:48 -0400
Received: from localhost (localhost [127.0.0.1])
	by axis700.grange (Postfix) with ESMTP id 3514640BB3
	for <linux-media@vger.kernel.org>; Thu, 25 Apr 2013 16:15:46 +0200 (CEST)
Date: Thu, 25 Apr 2013 16:15:46 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 1/2] V4L2: sh_mobile_ceu_camera: remove CEU specific data
 from generic functions
In-Reply-To: <Pine.LNX.4.64.1304251601080.21045@axis700.grange>
Message-ID: <Pine.LNX.4.64.1304251613350.21045@axis700.grange>
References: <Pine.LNX.4.64.1304251601080.21045@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Several functions in the sh_mobile_ceu_camera driver implement generic
algorithms and can be re-used by other V4L2 camera host drivers too. These
functions attempt to optimise scaling and cropping functions of the
subdevice, e.g. a camera sensor. This patch makes those functions generic
for future re-use by other camera host drivers.

Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
---
 .../platform/soc_camera/sh_mobile_ceu_camera.c     |  130 +++++++++++---------
 1 files changed, 71 insertions(+), 59 deletions(-)

diff --git a/drivers/media/platform/soc_camera/sh_mobile_ceu_camera.c b/drivers/media/platform/soc_camera/sh_mobile_ceu_camera.c
index 99d9029..4de3e7f 100644
--- a/drivers/media/platform/soc_camera/sh_mobile_ceu_camera.c
+++ b/drivers/media/platform/soc_camera/sh_mobile_ceu_camera.c
@@ -1005,7 +1005,7 @@ static bool sh_mobile_ceu_packing_supported(const struct soc_mbus_pixelfmt *fmt)
 		 fmt->packing == SOC_MBUS_PACKING_EXTEND16);
 }
 
-static int client_g_rect(struct v4l2_subdev *sd, struct v4l2_rect *rect);
+static int soc_camera_client_g_rect(struct v4l2_subdev *sd, struct v4l2_rect *rect);
 
 static struct soc_camera_device *ctrl_to_icd(struct v4l2_ctrl *ctrl)
 {
@@ -1084,7 +1084,7 @@ static int sh_mobile_ceu_get_formats(struct soc_camera_device *icd, unsigned int
 		/* FIXME: subwindow is lost between close / open */
 
 		/* Cache current client geometry */
-		ret = client_g_rect(sd, &rect);
+		ret = soc_camera_client_g_rect(sd, &rect);
 		if (ret < 0)
 			return ret;
 
@@ -1208,18 +1208,23 @@ static bool is_inside(const struct v4l2_rect *r1, const struct v4l2_rect *r2)
 		r1->top + r1->height < r2->top + r2->height;
 }
 
-static unsigned int scale_down(unsigned int size, unsigned int scale)
+static unsigned int soc_camera_shift_scale(unsigned int size, unsigned int shift,
+					   unsigned int scale)
 {
-	return (size * 4096 + scale / 2) / scale;
+	return ((size << shift) + scale / 2) / scale;
 }
 
-static unsigned int calc_generic_scale(unsigned int input, unsigned int output)
+static unsigned int soc_camera_calc_scale(unsigned int input, unsigned int shift,
+					  unsigned int output)
 {
-	return (input * 4096 + output / 2) / output;
+	return soc_camera_shift_scale(input, shift, output);
 }
 
+#define scale_down(size, scale) soc_camera_shift_scale(size, 12, scale)
+#define calc_generic_scale(in, out) soc_camera_shift_scale(in, 12, out)
+
 /* Get and store current client crop */
-static int client_g_rect(struct v4l2_subdev *sd, struct v4l2_rect *rect)
+static int soc_camera_client_g_rect(struct v4l2_subdev *sd, struct v4l2_rect *rect)
 {
 	struct v4l2_crop crop;
 	struct v4l2_cropcap cap;
@@ -1244,10 +1249,8 @@ static int client_g_rect(struct v4l2_subdev *sd, struct v4l2_rect *rect)
 }
 
 /* Client crop has changed, update our sub-rectangle to remain within the area */
-static void update_subrect(struct sh_mobile_ceu_cam *cam)
+static void update_subrect(struct v4l2_rect *rect, struct v4l2_rect *subrect)
 {
-	struct v4l2_rect *rect = &cam->rect, *subrect = &cam->subrect;
-
 	if (rect->width < subrect->width)
 		subrect->width = rect->width;
 
@@ -1275,19 +1278,18 @@ static void update_subrect(struct sh_mobile_ceu_cam *cam)
  * 2. if (1) failed, try to double the client image until we get one big enough
  * 3. if (2) failed, try to request the maximum image
  */
-static int client_s_crop(struct soc_camera_device *icd, struct v4l2_crop *crop,
-			 struct v4l2_crop *cam_crop)
+static int soc_camera_client_s_crop(struct v4l2_subdev *sd,
+			struct v4l2_crop *crop, struct v4l2_crop *cam_crop,
+			struct v4l2_rect *target_rect, struct v4l2_rect *subrect)
 {
-	struct v4l2_subdev *sd = soc_camera_to_subdev(icd);
 	struct v4l2_rect *rect = &crop->c, *cam_rect = &cam_crop->c;
 	struct device *dev = sd->v4l2_dev->dev;
-	struct sh_mobile_ceu_cam *cam = icd->host_priv;
 	struct v4l2_cropcap cap;
 	int ret;
 	unsigned int width, height;
 
 	v4l2_subdev_call(sd, video, s_crop, crop);
-	ret = client_g_rect(sd, cam_rect);
+	ret = soc_camera_client_g_rect(sd, cam_rect);
 	if (ret < 0)
 		return ret;
 
@@ -1299,7 +1301,7 @@ static int client_s_crop(struct soc_camera_device *icd, struct v4l2_crop *crop,
 		/* Even if camera S_CROP failed, but camera rectangle matches */
 		dev_dbg(dev, "Camera S_CROP successful for %dx%d@%d:%d\n",
 			rect->width, rect->height, rect->left, rect->top);
-		cam->rect = *cam_rect;
+		*target_rect = *cam_rect;
 		return 0;
 	}
 
@@ -1365,7 +1367,7 @@ static int client_s_crop(struct soc_camera_device *icd, struct v4l2_crop *crop,
 				cam_rect->top;
 
 		v4l2_subdev_call(sd, video, s_crop, cam_crop);
-		ret = client_g_rect(sd, cam_rect);
+		ret = soc_camera_client_g_rect(sd, cam_rect);
 		dev_geo(dev, "Camera S_CROP %d for %dx%d@%d:%d\n", ret,
 			cam_rect->width, cam_rect->height,
 			cam_rect->left, cam_rect->top);
@@ -1379,15 +1381,15 @@ static int client_s_crop(struct soc_camera_device *icd, struct v4l2_crop *crop,
 		 */
 		*cam_rect = cap.bounds;
 		v4l2_subdev_call(sd, video, s_crop, cam_crop);
-		ret = client_g_rect(sd, cam_rect);
+		ret = soc_camera_client_g_rect(sd, cam_rect);
 		dev_geo(dev, "Camera S_CROP %d for max %dx%d@%d:%d\n", ret,
 			cam_rect->width, cam_rect->height,
 			cam_rect->left, cam_rect->top);
 	}
 
 	if (!ret) {
-		cam->rect = *cam_rect;
-		update_subrect(cam);
+		*target_rect = *cam_rect;
+		update_subrect(target_rect, subrect);
 	}
 
 	return ret;
@@ -1395,15 +1397,13 @@ static int client_s_crop(struct soc_camera_device *icd, struct v4l2_crop *crop,
 
 /* Iterative s_mbus_fmt, also updates cached client crop on success */
 static int client_s_fmt(struct soc_camera_device *icd,
-			struct v4l2_mbus_framefmt *mf, bool ceu_can_scale)
+			struct v4l2_rect *rect, struct v4l2_rect *subrect,
+			unsigned int max_width, unsigned int max_height,
+			struct v4l2_mbus_framefmt *mf, bool host_can_scale)
 {
-	struct soc_camera_host *ici = to_soc_camera_host(icd->parent);
-	struct sh_mobile_ceu_dev *pcdev = ici->priv;
-	struct sh_mobile_ceu_cam *cam = icd->host_priv;
 	struct v4l2_subdev *sd = soc_camera_to_subdev(icd);
 	struct device *dev = icd->parent;
 	unsigned int width = mf->width, height = mf->height, tmp_w, tmp_h;
-	unsigned int max_width, max_height;
 	struct v4l2_cropcap cap;
 	bool ceu_1to1;
 	int ret;
@@ -1423,7 +1423,7 @@ static int client_s_fmt(struct soc_camera_device *icd,
 	}
 
 	ceu_1to1 = false;
-	if (!ceu_can_scale)
+	if (!host_can_scale)
 		goto update_cache;
 
 	cap.type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
@@ -1432,8 +1432,10 @@ static int client_s_fmt(struct soc_camera_device *icd,
 	if (ret < 0)
 		return ret;
 
-	max_width = min(cap.bounds.width, pcdev->max_width);
-	max_height = min(cap.bounds.height, pcdev->max_height);
+	if (max_width > cap.bounds.width)
+		max_width = cap.bounds.width;
+	if (max_height > cap.bounds.height)
+		max_height = cap.bounds.height;
 
 	/* Camera set a format, but geometry is not precise, try to improve */
 	tmp_w = mf->width;
@@ -1460,29 +1462,36 @@ static int client_s_fmt(struct soc_camera_device *icd,
 
 update_cache:
 	/* Update cache */
-	ret = client_g_rect(sd, &cam->rect);
+	ret = soc_camera_client_g_rect(sd, rect);
 	if (ret < 0)
 		return ret;
 
 	if (ceu_1to1)
-		cam->subrect = cam->rect;
+		*subrect = *rect;
 	else
-		update_subrect(cam);
+		update_subrect(rect, subrect);
 
 	return 0;
 }
 
 /**
- * @width	- on output: user width, mapped back to input
- * @height	- on output: user height, mapped back to input
+ * @icd		- soc-camera device
+ * @rect	- camera cropping window
+ * @subrect	- part of rect, sent to the user
  * @mf		- in- / output camera output window
+ * @width	- on input: max host input width
+ *		  on output: user width, mapped back to input
+ * @height	- on input: max host input height
+ *		  on output: user height, mapped back to input
+ * @host_can_scale - host can scale this pixel format
+ * @shift	- shift, used for scaling
  */
-static int client_scale(struct soc_camera_device *icd,
+static int soc_camera_client_scale(struct soc_camera_device *icd,
+			struct v4l2_rect *rect, struct v4l2_rect *subrect,
 			struct v4l2_mbus_framefmt *mf,
 			unsigned int *width, unsigned int *height,
-			bool ceu_can_scale)
+			bool host_can_scale, unsigned int shift)
 {
-	struct sh_mobile_ceu_cam *cam = icd->host_priv;
 	struct device *dev = icd->parent;
 	struct v4l2_mbus_framefmt mf_tmp = *mf;
 	unsigned int scale_h, scale_v;
@@ -1492,7 +1501,8 @@ static int client_scale(struct soc_camera_device *icd,
 	 * 5. Apply iterative camera S_FMT for camera user window (also updates
 	 *    client crop cache and the imaginary sub-rectangle).
 	 */
-	ret = client_s_fmt(icd, &mf_tmp, ceu_can_scale);
+	ret = client_s_fmt(icd, rect, subrect, *width, *height,
+			   &mf_tmp, host_can_scale);
 	if (ret < 0)
 		return ret;
 
@@ -1504,8 +1514,8 @@ static int client_scale(struct soc_camera_device *icd,
 	/* unneeded - it is already in "mf_tmp" */
 
 	/* 7. Calculate new client scales. */
-	scale_h = calc_generic_scale(cam->rect.width, mf_tmp.width);
-	scale_v = calc_generic_scale(cam->rect.height, mf_tmp.height);
+	scale_h = soc_camera_calc_scale(rect->width, shift, mf_tmp.width);
+	scale_v = soc_camera_calc_scale(rect->height, shift, mf_tmp.height);
 
 	mf->width	= mf_tmp.width;
 	mf->height	= mf_tmp.height;
@@ -1515,8 +1525,8 @@ static int client_scale(struct soc_camera_device *icd,
 	 * 8. Calculate new CEU crop - apply camera scales to previously
 	 *    updated "effective" crop.
 	 */
-	*width = scale_down(cam->subrect.width, scale_h);
-	*height = scale_down(cam->subrect.height, scale_v);
+	*width = soc_camera_shift_scale(subrect->width, shift, scale_h);
+	*height = soc_camera_shift_scale(subrect->height, shift, scale_v);
 
 	dev_geo(dev, "8: new client sub-window %ux%u\n", *width, *height);
 
@@ -1559,7 +1569,8 @@ static int sh_mobile_ceu_set_crop(struct soc_camera_device *icd,
 	 * 1. - 2. Apply iterative camera S_CROP for new input window, read back
 	 * actual camera rectangle.
 	 */
-	ret = client_s_crop(icd, &a_writable, &cam_crop);
+	ret = soc_camera_client_s_crop(sd, &a_writable, &cam_crop,
+				       &cam->rect, &cam->subrect);
 	if (ret < 0)
 		return ret;
 
@@ -1683,16 +1694,16 @@ static int sh_mobile_ceu_get_crop(struct soc_camera_device *icd,
  * client crop. New scales are calculated from the requested output format and
  * CEU crop, mapped backed onto the client input (subrect).
  */
-static void calculate_client_output(struct soc_camera_device *icd,
-		const struct v4l2_pix_format *pix, struct v4l2_mbus_framefmt *mf)
+static void soc_camera_calc_client_output(struct soc_camera_device *icd,
+		struct v4l2_rect *rect, struct v4l2_rect *subrect,
+		const struct v4l2_pix_format *pix, struct v4l2_mbus_framefmt *mf,
+		unsigned int shift)
 {
-	struct sh_mobile_ceu_cam *cam = icd->host_priv;
 	struct device *dev = icd->parent;
-	struct v4l2_rect *cam_subrect = &cam->subrect;
 	unsigned int scale_v, scale_h;
 
-	if (cam_subrect->width == cam->rect.width &&
-	    cam_subrect->height == cam->rect.height) {
+	if (subrect->width == rect->width &&
+	    subrect->height == rect->height) {
 		/* No sub-cropping */
 		mf->width	= pix->width;
 		mf->height	= pix->height;
@@ -1702,8 +1713,8 @@ static void calculate_client_output(struct soc_camera_device *icd,
 	/* 1.-2. Current camera scales and subwin - cached. */
 
 	dev_geo(dev, "2: subwin %ux%u@%u:%u\n",
-		cam_subrect->width, cam_subrect->height,
-		cam_subrect->left, cam_subrect->top);
+		subrect->width, subrect->height,
+		subrect->left, subrect->top);
 
 	/*
 	 * 3. Calculate new combined scales from input sub-window to requested
@@ -1714,8 +1725,8 @@ static void calculate_client_output(struct soc_camera_device *icd,
 	 * TODO: CEU cannot scale images larger than VGA to smaller than SubQCIF
 	 * (128x96) or larger than VGA
 	 */
-	scale_h = calc_generic_scale(cam_subrect->width, pix->width);
-	scale_v = calc_generic_scale(cam_subrect->height, pix->height);
+	scale_h = soc_camera_calc_scale(subrect->width, shift, pix->width);
+	scale_v = soc_camera_calc_scale(subrect->height, shift, pix->height);
 
 	dev_geo(dev, "3: scales %u:%u\n", scale_h, scale_v);
 
@@ -1723,8 +1734,8 @@ static void calculate_client_output(struct soc_camera_device *icd,
 	 * 4. Calculate desired client output window by applying combined scales
 	 *    to client (real) input window.
 	 */
-	mf->width	= scale_down(cam->rect.width, scale_h);
-	mf->height	= scale_down(cam->rect.height, scale_v);
+	mf->width = soc_camera_shift_scale(rect->width, shift, scale_h);
+	mf->height = soc_camera_shift_scale(rect->height, shift, scale_v);
 }
 
 /* Similar to set_crop multistage iterative algorithm */
@@ -1739,8 +1750,8 @@ static int sh_mobile_ceu_set_fmt(struct soc_camera_device *icd,
 	struct v4l2_mbus_framefmt mf;
 	__u32 pixfmt = pix->pixelformat;
 	const struct soc_camera_format_xlate *xlate;
-	/* Keep Compiler Happy */
-	unsigned int ceu_sub_width = 0, ceu_sub_height = 0;
+	unsigned int ceu_sub_width = pcdev->max_width,
+		ceu_sub_height = pcdev->max_height;
 	u16 scale_v, scale_h;
 	int ret;
 	bool image_mode;
@@ -1767,7 +1778,7 @@ static int sh_mobile_ceu_set_fmt(struct soc_camera_device *icd,
 	}
 
 	/* 1.-4. Calculate desired client output geometry */
-	calculate_client_output(icd, pix, &mf);
+	soc_camera_calc_client_output(icd, &cam->rect, &cam->subrect, pix, &mf, 12);
 	mf.field	= pix->field;
 	mf.colorspace	= pix->colorspace;
 	mf.code		= xlate->code;
@@ -1789,8 +1800,9 @@ static int sh_mobile_ceu_set_fmt(struct soc_camera_device *icd,
 	dev_geo(dev, "4: request camera output %ux%u\n", mf.width, mf.height);
 
 	/* 5. - 9. */
-	ret = client_scale(icd, &mf, &ceu_sub_width, &ceu_sub_height,
-			   image_mode && V4L2_FIELD_NONE == field);
+	ret = soc_camera_client_scale(icd, &cam->rect, &cam->subrect,
+				&mf, &ceu_sub_width, &ceu_sub_height,
+				image_mode && V4L2_FIELD_NONE == field, 12);
 
 	dev_geo(dev, "5-9: client scale return %d\n", ret);
 
-- 
1.7.2.5

