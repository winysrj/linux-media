Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.17.8]:62462 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753116Ab1IUQqS (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 21 Sep 2011 12:46:18 -0400
Received: from localhost (localhost [127.0.0.1])
	by axis700.grange (Postfix) with ESMTP id 5021C18B063
	for <linux-media@vger.kernel.org>; Wed, 21 Sep 2011 18:46:15 +0200 (CEST)
Date: Wed, 21 Sep 2011 18:46:15 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 2/2] V4L: sh_mobile_ceu_camera: simplify scaling and cropping
 algorithms
In-Reply-To: <Pine.LNX.4.64.1109211816380.24024@axis700.grange>
Message-ID: <Pine.LNX.4.64.1109211844260.24024@axis700.grange>
References: <Pine.LNX.4.64.1109211816380.24024@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

With the pad-level API scaling and cropping will be configured on each
entity separately. To prepare for the conversion remove all attempts
to optimise scaling and cropping on the host and clients, as has
previously been done by the sh_mobile_ceu_camera driver.

Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
---

This removes ugliest optimisation attempts and makes the driver 170 lines 
shorter.

 drivers/media/video/sh_mobile_ceu_camera.c |  876 +++++++++++-----------------
 1 files changed, 352 insertions(+), 524 deletions(-)

diff --git a/drivers/media/video/sh_mobile_ceu_camera.c b/drivers/media/video/sh_mobile_ceu_camera.c
index 955947a..d54c72b 100644
--- a/drivers/media/video/sh_mobile_ceu_camera.c
+++ b/drivers/media/video/sh_mobile_ceu_camera.c
@@ -112,7 +112,6 @@ struct sh_mobile_ceu_dev {
 
 	u32 cflcr;
 
-	enum v4l2_field field;
 	int sequence;
 
 	unsigned int image_mode:1;
@@ -121,20 +120,16 @@ struct sh_mobile_ceu_dev {
 };
 
 struct sh_mobile_ceu_cam {
-	/* CEU offsets within the camera output, before the CEU scaler */
-	unsigned int ceu_left;
-	unsigned int ceu_top;
+	/* Client cropping rectangle */
+	struct v4l2_rect rect;
 	/* Client output, as seen by the CEU */
 	unsigned int width;
 	unsigned int height;
 	/*
-	 * User window from S_CROP / G_CROP, produced by client cropping and
-	 * scaling, CEU scaling and CEU cropping, mapped back onto the client
-	 * input window
+	 * CEU offsets and sizes within the camera output, before the CEU
+	 * scaling filter
 	 */
-	struct v4l2_rect subrect;
-	/* Camera cropping rectangle */
-	struct v4l2_rect rect;
+	struct v4l2_rect ceu_rect;
 	const struct soc_mbus_pixelfmt *extra_fmt;
 	enum v4l2_mbus_pixelcode code;
 };
@@ -303,7 +298,7 @@ static int sh_mobile_ceu_capture(struct sh_mobile_ceu_dev *pcdev)
 	if (!pcdev->active)
 		return ret;
 
-	if (V4L2_FIELD_INTERLACED_BT == pcdev->field) {
+	if (V4L2_FIELD_INTERLACED_BT == icd->field) {
 		top1	= CDBYR;
 		top2	= CDBCR;
 		bottom1	= CDAYR;
@@ -329,7 +324,7 @@ static int sh_mobile_ceu_capture(struct sh_mobile_ceu_dev *pcdev)
 	}
 
 	ceu_write(pcdev, top1, phys_addr_top);
-	if (V4L2_FIELD_NONE != pcdev->field) {
+	if (V4L2_FIELD_NONE != icd->field) {
 		if (planar)
 			phys_addr_bottom = phys_addr_top + icd->user_width;
 		else
@@ -343,7 +338,7 @@ static int sh_mobile_ceu_capture(struct sh_mobile_ceu_dev *pcdev)
 		phys_addr_top += icd->user_width *
 			icd->user_height;
 		ceu_write(pcdev, top2, phys_addr_top);
-		if (V4L2_FIELD_NONE != pcdev->field) {
+		if (V4L2_FIELD_NONE != icd->field) {
 			phys_addr_bottom = phys_addr_top + icd->user_width;
 			ceu_write(pcdev, bottom2, phys_addr_bottom);
 		}
@@ -517,7 +512,7 @@ static irqreturn_t sh_mobile_ceu_irq(int irq, void *data)
 	ret = sh_mobile_ceu_capture(pcdev);
 	do_gettimeofday(&vb->v4l2_buf.timestamp);
 	if (!ret) {
-		vb->v4l2_buf.field = pcdev->field;
+		vb->v4l2_buf.field = pcdev->icd->field;
 		vb->v4l2_buf.sequence = pcdev->sequence++;
 	}
 	vb2_buffer_done(vb, ret < 0 ? VB2_BUF_STATE_ERROR : VB2_BUF_STATE_DONE);
@@ -659,17 +654,18 @@ static void sh_mobile_ceu_set_rect(struct soc_camera_device *icd)
 	u32 camor;
 
 	dev_geo(icd->parent, "Crop %ux%u@%u:%u\n",
-		icd->user_width, icd->user_height, cam->ceu_left, cam->ceu_top);
+		icd->user_width, icd->user_height, cam->ceu_rect.left, cam->ceu_rect.top);
 
-	left_offset	= cam->ceu_left;
-	top_offset	= cam->ceu_top;
+	left_offset	= cam->ceu_rect.left;
+	top_offset	= cam->ceu_rect.top;
 
 	WARN_ON(icd->user_width & 3 || icd->user_height & 3);
 
 	width = icd->user_width;
 
+	in_width = min(2560U, cam->width);
+
 	if (pcdev->image_mode) {
-		in_width = cam->width;
 		if (!pcdev->is_16bit) {
 			in_width *= 2;
 			left_offset *= 2;
@@ -688,7 +684,7 @@ static void sh_mobile_ceu_set_rect(struct soc_camera_device *icd)
 			w_factor = 1;
 		}
 
-		in_width = cam->width * w_factor;
+		in_width *= w_factor;
 		left_offset *= w_factor;
 
 		if (bytes_per_line < 0)
@@ -698,8 +694,8 @@ static void sh_mobile_ceu_set_rect(struct soc_camera_device *icd)
 	}
 
 	height = icd->user_height;
-	in_height = cam->height;
-	if (V4L2_FIELD_NONE != pcdev->field) {
+	in_height = min(1920U, cam->height);
+	if (V4L2_FIELD_NONE != icd->field) {
 		height = (height / 2) & ~3;
 		in_height /= 2;
 		top_offset /= 2;
@@ -721,6 +717,10 @@ static void sh_mobile_ceu_set_rect(struct soc_camera_device *icd)
 		cdwdr_width);
 
 	ceu_write(pcdev, CAMOR, camor);
+	/*
+	 * We made sure offset + length doesn't exceed client output for both
+	 * width and height
+	 */
 	ceu_write(pcdev, CAPWR, (in_height << 16) | in_width);
 	/* CFSZR clipping is applied _after_ the scaling filter (CFLCR) */
 	ceu_write(pcdev, CFSZR, (height << 16) | width);
@@ -884,7 +884,7 @@ static int sh_mobile_ceu_set_bus_param(struct soc_camera_device *icd,
 
 	ceu_write(pcdev, CAPCR, 0x00300000);
 
-	switch (pcdev->field) {
+	switch (icd->field) {
 	case V4L2_FIELD_INTERLACED_TB:
 		value = 0x101;
 		break;
@@ -1107,11 +1107,13 @@ static int sh_mobile_ceu_get_formats(struct soc_camera_device *icd, unsigned int
 			return -ENOMEM;
 
 		/* We are called with current camera crop, initialise subrect with it */
-		cam->rect	= rect;
-		cam->subrect	= rect;
-
-		cam->width	= mf.width;
-		cam->height	= mf.height;
+		cam->rect		= rect;
+		cam->ceu_rect.width	= mf.width;
+		cam->ceu_rect.height	= mf.height;
+		cam->ceu_rect.top	= 0;
+		cam->ceu_rect.left	= 0;
+		cam->width		= mf.width;
+		cam->height		= mf.height;
 
 		icd->host_priv = cam;
 	} else {
@@ -1181,24 +1183,6 @@ static bool is_smaller(struct v4l2_rect *r1, struct v4l2_rect *r2)
 	return r1->width < r2->width || r1->height < r2->height;
 }
 
-/* Check if r1 fails to cover r2 */
-static bool is_inside(struct v4l2_rect *r1, struct v4l2_rect *r2)
-{
-	return r1->left > r2->left || r1->top > r2->top ||
-		r1->left + r1->width < r2->left + r2->width ||
-		r1->top + r1->height < r2->top + r2->height;
-}
-
-static unsigned int scale_down(unsigned int size, unsigned int scale)
-{
-	return (size * 4096 + scale / 2) / scale;
-}
-
-static unsigned int calc_generic_scale(unsigned int input, unsigned int output)
-{
-	return (input * 4096 + output / 2) / output;
-}
-
 /* Get and store current client crop */
 static int client_g_rect(struct v4l2_subdev *sd, struct v4l2_rect *rect)
 {
@@ -1224,280 +1208,59 @@ static int client_g_rect(struct v4l2_subdev *sd, struct v4l2_rect *rect)
 	return ret;
 }
 
-/* Client crop has changed, update our sub-rectangle to remain within the area */
-static void update_subrect(struct sh_mobile_ceu_cam *cam)
+static void ceu_full_input(struct sh_mobile_ceu_cam *cam,
+			   const struct v4l2_mbus_framefmt *mf)
 {
-	struct v4l2_rect *rect = &cam->rect, *subrect = &cam->subrect;
-
-	if (rect->width < subrect->width)
-		subrect->width = rect->width;
-
-	if (rect->height < subrect->height)
-		subrect->height = rect->height;
-
-	if (rect->left > subrect->left)
-		subrect->left = rect->left;
-	else if (rect->left + rect->width >
-		 subrect->left + subrect->width)
-		subrect->left = rect->left + rect->width -
-			subrect->width;
-
-	if (rect->top > subrect->top)
-		subrect->top = rect->top;
-	else if (rect->top + rect->height >
-		 subrect->top + subrect->height)
-		subrect->top = rect->top + rect->height -
-			subrect->height;
+	cam->ceu_rect.width	= mf->width;
+	cam->ceu_rect.height	= mf->height;
+	cam->width		= mf->width;
+	cam->height		= mf->height;
 }
 
-/*
- * The common for both scaling and cropping iterative approach is:
- * 1. try if the client can produce exactly what requested by the user
- * 2. if (1) failed, try to double the client image until we get one big enough
- * 3. if (2) failed, try to request the maximum image
- */
-static int client_s_crop(struct soc_camera_device *icd, struct v4l2_crop *crop,
-			 struct v4l2_crop *cam_crop)
+static void ceu_non_native_scale(struct sh_mobile_ceu_dev *pcdev,
+				 struct sh_mobile_ceu_cam *cam,
+				 const struct v4l2_mbus_framefmt *mf)
 {
-	struct v4l2_subdev *sd = soc_camera_to_subdev(icd);
-	struct v4l2_rect *rect = &crop->c, *cam_rect = &cam_crop->c;
-	struct device *dev = sd->v4l2_dev->dev;
-	struct sh_mobile_ceu_cam *cam = icd->host_priv;
-	struct v4l2_cropcap cap;
-	int ret;
-	unsigned int width, height;
-
-	v4l2_subdev_call(sd, video, s_crop, crop);
-	ret = client_g_rect(sd, cam_rect);
-	if (ret < 0)
-		return ret;
+	/* .top == .left == 0 already */
+	ceu_full_input(cam, mf);
 
-	/*
-	 * Now cam_crop contains the current camera input rectangle, and it must
-	 * be within camera cropcap bounds
-	 */
-	if (!memcmp(rect, cam_rect, sizeof(*rect))) {
-		/* Even if camera S_CROP failed, but camera rectangle matches */
-		dev_dbg(dev, "Camera S_CROP successful for %dx%d@%d:%d\n",
-			rect->width, rect->height, rect->left, rect->top);
-		cam->rect = *cam_rect;
-		return 0;
-	}
-
-	/* Try to fix cropping, that camera hasn't managed to set */
-	dev_geo(dev, "Fix camera S_CROP for %dx%d@%d:%d to %dx%d@%d:%d\n",
-		cam_rect->width, cam_rect->height,
-		cam_rect->left, cam_rect->top,
-		rect->width, rect->height, rect->left, rect->top);
-
-	/* We need sensor maximum rectangle */
-	ret = v4l2_subdev_call(sd, video, cropcap, &cap);
-	if (ret < 0)
-		return ret;
-
-	/* Put user requested rectangle within sensor bounds */
-	soc_camera_limit_side(&rect->left, &rect->width, cap.bounds.left, 2,
-			      cap.bounds.width);
-	soc_camera_limit_side(&rect->top, &rect->height, cap.bounds.top, 4,
-			      cap.bounds.height);
-
-	/*
-	 * Popular special case - some cameras can only handle fixed sizes like
-	 * QVGA, VGA,... Take care to avoid infinite loop.
-	 */
-	width = max(cam_rect->width, 2);
-	height = max(cam_rect->height, 2);
-
-	/*
-	 * Loop as long as sensor is not covering the requested rectangle and
-	 * is still within its bounds
-	 */
-	while (!ret && (is_smaller(cam_rect, rect) ||
-			is_inside(cam_rect, rect)) &&
-	       (cap.bounds.width > width || cap.bounds.height > height)) {
-
-		width *= 2;
-		height *= 2;
-
-		cam_rect->width = width;
-		cam_rect->height = height;
-
-		/*
-		 * We do not know what capabilities the camera has to set up
-		 * left and top borders. We could try to be smarter in iterating
-		 * them, e.g., if camera current left is to the right of the
-		 * target left, set it to the middle point between the current
-		 * left and minimum left. But that would add too much
-		 * complexity: we would have to iterate each border separately.
-		 * Instead we just drop to the left and top bounds.
-		 */
-		if (cam_rect->left > rect->left)
-			cam_rect->left = cap.bounds.left;
-
-		if (cam_rect->left + cam_rect->width < rect->left + rect->width)
-			cam_rect->width = rect->left + rect->width -
-				cam_rect->left;
-
-		if (cam_rect->top > rect->top)
-			cam_rect->top = cap.bounds.top;
-
-		if (cam_rect->top + cam_rect->height < rect->top + rect->height)
-			cam_rect->height = rect->top + rect->height -
-				cam_rect->top;
-
-		v4l2_subdev_call(sd, video, s_crop, cam_crop);
-		ret = client_g_rect(sd, cam_rect);
-		dev_geo(dev, "Camera S_CROP %d for %dx%d@%d:%d\n", ret,
-			cam_rect->width, cam_rect->height,
-			cam_rect->left, cam_rect->top);
-	}
-
-	/* S_CROP must not modify the rectangle */
-	if (is_smaller(cam_rect, rect) || is_inside(cam_rect, rect)) {
-		/*
-		 * The camera failed to configure a suitable cropping,
-		 * we cannot use the current rectangle, set to max
-		 */
-		*cam_rect = cap.bounds;
-		v4l2_subdev_call(sd, video, s_crop, cam_crop);
-		ret = client_g_rect(sd, cam_rect);
-		dev_geo(dev, "Camera S_CROP %d for max %dx%d@%d:%d\n", ret,
-			cam_rect->width, cam_rect->height,
-			cam_rect->left, cam_rect->top);
-	}
-
-	if (!ret) {
-		cam->rect = *cam_rect;
-		update_subrect(cam);
-	}
-
-	return ret;
+	/* Possibly we were in a native mode and scaling */
+	pcdev->cflcr = 0;
 }
 
-/* Iterative s_mbus_fmt, also updates cached client crop on success */
-static int client_s_fmt(struct soc_camera_device *icd,
-			struct v4l2_mbus_framefmt *mf, bool ceu_can_scale)
+static void ceu_native_scale(struct sh_mobile_ceu_dev *pcdev,
+			     const struct sh_mobile_ceu_cam *cam,
+			     struct v4l2_pix_format *pix)
 {
-	struct sh_mobile_ceu_cam *cam = icd->host_priv;
-	struct v4l2_subdev *sd = soc_camera_to_subdev(icd);
-	struct device *dev = icd->parent;
-	unsigned int width = mf->width, height = mf->height, tmp_w, tmp_h;
-	unsigned int max_width, max_height;
-	struct v4l2_cropcap cap;
-	bool ceu_1to1;
-	int ret;
-
-	ret = v4l2_device_call_until_err(sd->v4l2_dev, (long)icd, video,
-					 s_mbus_fmt, mf);
-	if (ret < 0)
-		return ret;
-
-	dev_geo(dev, "camera scaled to %ux%u\n", mf->width, mf->height);
-
-	if (width == mf->width && height == mf->height) {
-		/* Perfect! The client has done it all. */
-		ceu_1to1 = true;
-		goto update_cache;
-	}
-
-	ceu_1to1 = false;
-	if (!ceu_can_scale)
-		goto update_cache;
-
-	cap.type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
-
-	ret = v4l2_subdev_call(sd, video, cropcap, &cap);
-	if (ret < 0)
-		return ret;
-
-	max_width = min(cap.bounds.width, 2560);
-	max_height = min(cap.bounds.height, 1920);
+	u16 scale_v, scale_h;
 
-	/* Camera set a format, but geometry is not precise, try to improve */
-	tmp_w = mf->width;
-	tmp_h = mf->height;
+	/* No upscaling */
+	if (pix->width > cam->ceu_rect.width)
+		pix->width = cam->ceu_rect.width;
+	if (pix->height > cam->ceu_rect.height)
+		pix->height = cam->ceu_rect.height;
 
-	/* width <= max_width && height <= max_height - guaranteed by try_fmt */
-	while ((width > tmp_w || height > tmp_h) &&
-	       tmp_w < max_width && tmp_h < max_height) {
-		tmp_w = min(2 * tmp_w, max_width);
-		tmp_h = min(2 * tmp_h, max_height);
-		mf->width = tmp_w;
-		mf->height = tmp_h;
-		ret = v4l2_device_call_until_err(sd->v4l2_dev, (long)icd, video,
-						 s_mbus_fmt, mf);
-		dev_geo(dev, "Camera scaled to %ux%u\n",
-			mf->width, mf->height);
-		if (ret < 0) {
-			/* This shouldn't happen */
-			dev_err(dev, "Client failed to set format: %d\n", ret);
-			return ret;
-		}
-	}
+	/* Scale width x height down to pix->{width x height} */
+	scale_h = calc_scale(cam->ceu_rect.width, &pix->width);
+	scale_v = calc_scale(cam->ceu_rect.height, &pix->height);
 
-update_cache:
-	/* Update cache */
-	ret = client_g_rect(sd, &cam->rect);
-	if (ret < 0)
-		return ret;
+	dev_geo(pcdev->icd->parent, "CEU W: %u : %u -> %u, H: %u : %u -> %u\n",
+		cam->ceu_rect.width, scale_h, pix->width,
+		cam->ceu_rect.height, scale_v, pix->height);
 
-	if (ceu_1to1)
-		cam->subrect = cam->rect;
-	else
-		update_subrect(cam);
-
-	return 0;
+	pcdev->cflcr = scale_h | (scale_v << 16);
 }
 
-/**
- * @width	- on output: user width, mapped back to input
- * @height	- on output: user height, mapped back to input
- * @mf		- in- / output camera output window
- */
-static int client_scale(struct soc_camera_device *icd,
-			struct v4l2_mbus_framefmt *mf,
-			unsigned int *width, unsigned int *height,
-			bool ceu_can_scale)
+static bool ceu_fmt_can_scale(__u32 fourcc)
 {
-	struct sh_mobile_ceu_cam *cam = icd->host_priv;
-	struct device *dev = icd->parent;
-	struct v4l2_mbus_framefmt mf_tmp = *mf;
-	unsigned int scale_h, scale_v;
-	int ret;
-
-	/*
-	 * 5. Apply iterative camera S_FMT for camera user window (also updates
-	 *    client crop cache and the imaginary sub-rectangle).
-	 */
-	ret = client_s_fmt(icd, &mf_tmp, ceu_can_scale);
-	if (ret < 0)
-		return ret;
-
-	dev_geo(dev, "5: camera scaled to %ux%u\n",
-		mf_tmp.width, mf_tmp.height);
-
-	/* 6. Retrieve camera output window (g_fmt) */
-
-	/* unneeded - it is already in "mf_tmp" */
-
-	/* 7. Calculate new client scales. */
-	scale_h = calc_generic_scale(cam->rect.width, mf_tmp.width);
-	scale_v = calc_generic_scale(cam->rect.height, mf_tmp.height);
-
-	mf->width	= mf_tmp.width;
-	mf->height	= mf_tmp.height;
-	mf->colorspace	= mf_tmp.colorspace;
-
-	/*
-	 * 8. Calculate new CEU crop - apply camera scales to previously
-	 *    updated "effective" crop.
-	 */
-	*width = scale_down(cam->subrect.width, scale_h);
-	*height = scale_down(cam->subrect.height, scale_v);
-
-	dev_geo(dev, "8: new client sub-window %ux%u\n", *width, *height);
-
-	return 0;
+	switch (fourcc) {
+	case V4L2_PIX_FMT_NV12:
+	case V4L2_PIX_FMT_NV21:
+	case V4L2_PIX_FMT_NV16:
+	case V4L2_PIX_FMT_NV61:
+		return true;
+	}
+	return false;
 }
 
 /*
@@ -1513,125 +1276,133 @@ static int sh_mobile_ceu_set_crop(struct soc_camera_device *icd,
 	struct device *dev = icd->parent;
 	struct soc_camera_host *ici = to_soc_camera_host(dev);
 	struct sh_mobile_ceu_dev *pcdev = ici->priv;
-	struct v4l2_crop cam_crop;
 	struct sh_mobile_ceu_cam *cam = icd->host_priv;
-	struct v4l2_rect *cam_rect = &cam_crop.c;
 	struct v4l2_subdev *sd = soc_camera_to_subdev(icd);
+	struct v4l2_cropcap cap;
 	struct v4l2_mbus_framefmt mf;
-	unsigned int scale_cam_h, scale_cam_v, scale_ceu_h, scale_ceu_v,
-		out_width, out_height;
-	int interm_width, interm_height;
-	u32 capsr, cflcr;
+	u32 capsr, cflcr = pcdev->cflcr;
+	bool image_mode = ceu_fmt_can_scale(icd->current_fmt->host_fmt->fourcc);
 	int ret;
 
 	dev_geo(dev, "S_CROP(%ux%u@%u:%u)\n", rect->width, rect->height,
 		rect->left, rect->top);
 
+	ret = v4l2_subdev_call(sd, video, cropcap, &cap);
+	if (ret < 0)
+		return ret;
+
+	/* Put user requested rectangle within sensor bounds */
+	soc_camera_limit_side(&rect->left, &rect->width, cap.bounds.left, 2,
+			      cap.bounds.width);
+	soc_camera_limit_side(&rect->top, &rect->height, cap.bounds.top, 4,
+			      cap.bounds.height);
+
 	/* During camera cropping its output window can change too, stop CEU */
 	capsr = capture_save_reset(pcdev);
 	dev_dbg(dev, "CAPSR 0x%x, CFLCR 0x%x\n", capsr, pcdev->cflcr);
 
-	/*
-	 * 1. - 2. Apply iterative camera S_CROP for new input window, read back
-	 * actual camera rectangle.
-	 */
-	ret = client_s_crop(icd, a, &cam_crop);
+	/* Very similar to S_FMT */
+	v4l2_subdev_call(sd, video, s_crop, a);
+	ret = client_g_rect(sd, &cam->rect);
 	if (ret < 0)
 		return ret;
 
-	dev_geo(dev, "1-2: camera cropped to %ux%u@%u:%u\n",
-		cam_rect->width, cam_rect->height,
-		cam_rect->left, cam_rect->top);
-
-	/* On success cam_crop contains current camera crop */
-
-	/* 3. Retrieve camera output window */
+	/* re-read client output */
 	ret = v4l2_subdev_call(sd, video, g_mbus_fmt, &mf);
 	if (ret < 0)
 		return ret;
 
-	if (mf.width > 2560 || mf.height > 1920)
-		return -EINVAL;
-
-	/* 4. Calculate camera scales */
-	scale_cam_h	= calc_generic_scale(cam_rect->width, mf.width);
-	scale_cam_v	= calc_generic_scale(cam_rect->height, mf.height);
-
-	/* Calculate intermediate window */
-	interm_width	= scale_down(rect->width, scale_cam_h);
-	interm_height	= scale_down(rect->height, scale_cam_v);
-
-	if (interm_width < icd->user_width) {
-		u32 new_scale_h;
-
-		new_scale_h = calc_generic_scale(rect->width, icd->user_width);
-
-		mf.width = scale_down(cam_rect->width, new_scale_h);
-	}
-
-	if (interm_height < icd->user_height) {
-		u32 new_scale_v;
-
-		new_scale_v = calc_generic_scale(rect->height, icd->user_height);
+	if (!image_mode) {
+		ceu_full_input(cam, &mf);
+		icd->user_width = mf.width & ~3;
+		icd->user_height = mf.height & ~3;
+	} else {
+		struct v4l2_pix_format pix = {
+			.pixelformat	= icd->current_fmt->host_fmt->fourcc,
+			.colorspace	= icd->colorspace,
+			.field		= icd->field,
+			.width		= icd->user_width & ~3,
+			.height		= icd->user_height & ~3,
+		};
+		/*
+		 * We do not care about client output frame, only check the
+		 * cropping result. If the client crop rectangle is smaller,
+		 * than what user has requested, request client crop = max,
+		 * scale = 1:1 and use CEU cropping instead or additionally
+		 */
+		if (is_smaller(&cam->rect, rect)) {
+			/* Request maximum crop rectangle */
+			*rect = cap.bounds;
+			v4l2_subdev_call(sd, video, s_crop, a);
+			ret = client_g_rect(sd, &cam->rect);
+			if (ret < 0)
+				return ret;
 
-		mf.height = scale_down(cam_rect->height, new_scale_v);
-	}
+			/* re-read client output */
+			ret = v4l2_subdev_call(sd, video, g_mbus_fmt, &mf);
+			if (ret < 0)
+				return ret;
 
-	if (interm_width < icd->user_width || interm_height < icd->user_height) {
-		ret = v4l2_device_call_until_err(sd->v4l2_dev, (int)icd, video,
-						 s_mbus_fmt, &mf);
-		if (ret < 0)
-			return ret;
+			if (!is_smaller(&cam->rect, rect)) {
+				/* Client crop sufficient, configure scale = 1:1 */
+				mf.width = rect->width;
+				mf.height = rect->height;
+				ret = v4l2_device_call_until_err(sd->v4l2_dev, (int)icd,
+								 video, s_mbus_fmt, &mf);
+				if (ret < 0)
+					return ret;
+			}
+		}
 
-		dev_geo(dev, "New camera output %ux%u\n", mf.width, mf.height);
-		scale_cam_h	= calc_generic_scale(cam_rect->width, mf.width);
-		scale_cam_v	= calc_generic_scale(cam_rect->height, mf.height);
-		interm_width	= scale_down(rect->width, scale_cam_h);
-		interm_height	= scale_down(rect->height, scale_cam_v);
-	}
+		/*
+		 * Is the client window bigger than requested and
+		 * scale == 1:1? If yes, apply CEU cropping
+		 */
+		if (cam->rect.width > rect->width &&
+		    cam->rect.height > rect->height &&
+		    cam->rect.width == mf.width &&
+		    cam->rect.height == mf.height) {
+			/* client crop can be improved: client scale == 1:1 */
+			cam->ceu_rect.width = min_t(u32, mf.width, rect->width);
+			cam->ceu_rect.height = min_t(u32, mf.height, rect->height);
+
+			cam->ceu_rect.left = rect->left <= cam->rect.left ? 0 :
+				min_t(u32, rect->left - cam->rect.left,
+				      mf.width - cam->ceu_rect.width);
+
+			cam->ceu_rect.top = rect->top <= cam->rect.top ? 0 :
+				min_t(u32, rect->top - cam->rect.top,
+				      mf.height - cam->ceu_rect.height);
+
+			cam->width = mf.width;
+			cam->height = mf.height;
+		} else {
+			/*
+			 * Either client cropping is perfect, or we cannot
+			 * improve it anyway. Do not apply CEU cropping, scale
+			 * the complete client output
+			 */
+			cam->ceu_rect.left = 0;
+			cam->ceu_rect.top = 0;
+			ceu_full_input(cam, &mf);
+		}
 
-	/* Cache camera output window */
-	cam->width	= mf.width;
-	cam->height	= mf.height;
+		ceu_native_scale(pcdev, cam, &pix);
+		icd->user_width = pix.width;
+		icd->user_height = pix.height;
 
-	if (pcdev->image_mode) {
-		out_width	= min(interm_width, icd->user_width);
-		out_height	= min(interm_height, icd->user_height);
-	} else {
-		out_width	= interm_width;
-		out_height	= interm_height;
 	}
 
-	/*
-	 * 5. Calculate CEU scales from camera scales from results of (5) and
-	 *    the user window
-	 */
-	scale_ceu_h	= calc_scale(interm_width, &out_width);
-	scale_ceu_v	= calc_scale(interm_height, &out_height);
-
-	dev_geo(dev, "5: CEU scales %u:%u\n", scale_ceu_h, scale_ceu_v);
-
 	/* Apply CEU scales. */
-	cflcr = scale_ceu_h | (scale_ceu_v << 16);
-	if (cflcr != pcdev->cflcr) {
-		pcdev->cflcr = cflcr;
-		ceu_write(pcdev, CFLCR, cflcr);
-	}
-
-	icd->user_width	 = out_width & ~3;
-	icd->user_height = out_height & ~3;
-	/* Offsets are applied at the CEU scaling filter input */
-	cam->ceu_left	 = scale_down(rect->left - cam_rect->left, scale_cam_h) & ~1;
-	cam->ceu_top	 = scale_down(rect->top - cam_rect->top, scale_cam_v) & ~1;
+	if (cflcr != pcdev->cflcr)
+		ceu_write(pcdev, CFLCR, pcdev->cflcr);
 
-	/* 6. Use CEU cropping to crop to the new window. */
+	/* Use CEU cropping to crop to the new window. */
 	sh_mobile_ceu_set_rect(icd);
 
-	cam->subrect = *rect;
-
-	dev_geo(dev, "6: CEU cropped to %ux%u@%u:%u\n",
-		icd->user_width, icd->user_height,
-		cam->ceu_left, cam->ceu_top);
+	dev_geo(dev, "cropped to %ux%u@%u:%u\n",
+		cam->ceu_rect.width, cam->ceu_rect.height,
+		cam->rect.left, cam->rect.top);
 
 	/* Restore capture. The CE bit can be cleared by the hardware */
 	if (pcdev->active)
@@ -1648,183 +1419,231 @@ static int sh_mobile_ceu_get_crop(struct soc_camera_device *icd,
 	struct sh_mobile_ceu_cam *cam = icd->host_priv;
 
 	a->type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
-	a->c = cam->subrect;
+	a->c = cam->ceu_rect;
 
 	return 0;
 }
 
-/*
- * Calculate real client output window by applying new scales to the current
- * client crop. New scales are calculated from the requested output format and
- * CEU crop, mapped backed onto the client input (subrect).
- */
-static void calculate_client_output(struct soc_camera_device *icd,
-		const struct v4l2_pix_format *pix, struct v4l2_mbus_framefmt *mf)
+static enum v4l2_field ceu_supported_field(enum v4l2_field *user_field)
 {
-	struct sh_mobile_ceu_cam *cam = icd->host_priv;
-	struct device *dev = icd->parent;
-	struct v4l2_rect *cam_subrect = &cam->subrect;
-	unsigned int scale_v, scale_h;
-
-	if (cam_subrect->width == cam->rect.width &&
-	    cam_subrect->height == cam->rect.height) {
-		/* No sub-cropping */
-		mf->width	= pix->width;
-		mf->height	= pix->height;
-		return;
+	switch (*user_field) {
+	default:
+		*user_field = V4L2_FIELD_NONE;
+		/* fall-through */
+	case V4L2_FIELD_INTERLACED_TB:
+	case V4L2_FIELD_INTERLACED_BT:
+	case V4L2_FIELD_NONE:
+		return *user_field;
+	case V4L2_FIELD_INTERLACED:
+		return V4L2_FIELD_INTERLACED_TB;
 	}
+}
 
-	/* 1.-2. Current camera scales and subwin - cached. */
-
-	dev_geo(dev, "2: subwin %ux%u@%u:%u\n",
-		cam_subrect->width, cam_subrect->height,
-		cam_subrect->left, cam_subrect->top);
+static int ceu_client_crop(struct soc_camera_device *icd,
+			   struct v4l2_mbus_framefmt *mf)
+{
+	struct v4l2_subdev *sd = soc_camera_to_subdev(icd);
+	struct sh_mobile_ceu_cam *cam = icd->host_priv;
+	/* We were sub-cropping with a native format. Reset. */
+	struct v4l2_crop cam_crop = {
+		.type	= V4L2_BUF_TYPE_VIDEO_CAPTURE,
+		.c	= {
+			.width	= cam->ceu_rect.width,
+			.height	= cam->ceu_rect.height,
+			.top	= cam->ceu_rect.top + cam->rect.top,
+			.left	= cam->ceu_rect.left + cam->rect.left,
+		},
+	};
+	int ret;
 
 	/*
-	 * 3. Calculate new combined scales from input sub-window to requested
-	 *    user window.
+	 * re-request cropping - maybe the client can do better with the
+	 * new pixel code
 	 */
+	v4l2_subdev_call(sd, video, s_crop, &cam_crop);
+	ret = client_g_rect(sd, &cam->rect);
+	if (ret < 0)
+		return ret;
 
-	/*
-	 * TODO: CEU cannot scale images larger than VGA to smaller than SubQCIF
-	 * (128x96) or larger than VGA
-	 */
-	scale_h = calc_generic_scale(cam_subrect->width, pix->width);
-	scale_v = calc_generic_scale(cam_subrect->height, pix->height);
+	/* re-read client output */
+	ret = v4l2_subdev_call(sd, video, g_mbus_fmt, mf);
+	if (ret < 0)
+		return ret;
 
-	dev_geo(dev, "3: scales %u:%u\n", scale_h, scale_v);
+	/* Switching from a native format, offsets can be != 0 */
+	cam->ceu_rect.left	= 0;
+	cam->ceu_rect.top	= 0;
 
-	/*
-	 * 4. Calculate desired client output window by applying combined scales
-	 *    to client (real) input window.
-	 */
-	mf->width	= scale_down(cam->rect.width, scale_h);
-	mf->height	= scale_down(cam->rect.height, scale_v);
+	return 0;
+}
+
+/*
+ * Verify, whether the client has scaled into a window, smaller than requested
+ * by the user, and if the requested user output is smaller, than client
+ * cropping rectangle: we do not want to ask the client to upscale more, that
+ * what the user has requested, and we've already tried that.
+ */
+static int ceu_crop_full_window(struct soc_camera_device *icd,
+				struct v4l2_pix_format *pix,
+				struct v4l2_mbus_framefmt *mf)
+{
+	struct v4l2_subdev *sd = soc_camera_to_subdev(icd);
+	struct sh_mobile_ceu_cam *cam = icd->host_priv;
+	unsigned int max_width, max_height;
+	int ret;
+
+	max_width = min(2560, cam->rect.width);
+	max_height = min(1920, cam->rect.height);
+
+	if ((mf->width < pix->width && mf->width < max_width) ||
+	    (mf->height < pix->height && mf->height < max_height)) {
+		enum v4l2_mbus_pixelcode code = mf->code;
+
+		mf->width = max_width;
+		mf->height = max_height;
+		ret = v4l2_device_call_until_err(sd->v4l2_dev, (long)icd,
+						 video, s_mbus_fmt, mf);
+		if (ret < 0)
+			return ret;
+		BUG_ON(mf->code != code);
+	}
+
+	/* We were not cropping, i.e., .top == .left == 0 */
+	ceu_full_input(cam, mf);
+
+	return 0;
 }
 
 /* Similar to set_crop multistage iterative algorithm */
 static int sh_mobile_ceu_set_fmt(struct soc_camera_device *icd,
 				 struct v4l2_format *f)
 {
+	struct v4l2_subdev *sd = soc_camera_to_subdev(icd);
 	struct device *dev = icd->parent;
 	struct soc_camera_host *ici = to_soc_camera_host(dev);
 	struct sh_mobile_ceu_dev *pcdev = ici->priv;
 	struct sh_mobile_ceu_cam *cam = icd->host_priv;
 	struct v4l2_pix_format *pix = &f->fmt.pix;
-	struct v4l2_mbus_framefmt mf;
-	__u32 pixfmt = pix->pixelformat;
+	struct v4l2_mbus_framefmt mf = {
+		.width		= pix->width,
+		.height		= pix->height,
+	};
 	const struct soc_camera_format_xlate *xlate;
-	/* Keep Compiler Happy */
-	unsigned int ceu_sub_width = 0, ceu_sub_height = 0;
-	u16 scale_v, scale_h;
-	int ret;
-	bool image_mode;
+	bool ceu_crop = cam->ceu_rect.left || cam->ceu_rect.top ||
+		cam->ceu_rect.width != cam->rect.width ||
+		cam->ceu_rect.height != cam->rect.height;
+	__u32 pixfmt = pix->pixelformat;
 	enum v4l2_field field;
+	bool image_mode;
+	int ret;
 
-	switch (pix->field) {
-	default:
-		pix->field = V4L2_FIELD_NONE;
-		/* fall-through */
-	case V4L2_FIELD_INTERLACED_TB:
-	case V4L2_FIELD_INTERLACED_BT:
-	case V4L2_FIELD_NONE:
-		field = pix->field;
-		break;
-	case V4L2_FIELD_INTERLACED:
-		field = V4L2_FIELD_INTERLACED_TB;
-		break;
-	}
+	/* .try_fmt() has been called, size valid */
 
 	xlate = soc_camera_xlate_by_fourcc(icd, pixfmt);
 	if (!xlate) {
-		dev_warn(dev, "Format %x not found\n", pixfmt);
-		return -EINVAL;
+		xlate			= icd->current_fmt;
+		dev_warn(dev, "Format %x not found, staying with current %x\n",
+			 pixfmt, xlate->host_fmt->fourcc);
+		pixfmt			= xlate->host_fmt->fourcc;
+		pix->pixelformat	= pixfmt;
+		pix->colorspace		= icd->colorspace;
+		pix->field		= icd->field;
 	}
 
-	/* 1.-4. Calculate desired client output geometry */
-	calculate_client_output(icd, pix, &mf);
-	mf.field	= pix->field;
-	mf.colorspace	= pix->colorspace;
-	mf.code		= xlate->code;
-
-	switch (pixfmt) {
-	case V4L2_PIX_FMT_NV12:
-	case V4L2_PIX_FMT_NV21:
-	case V4L2_PIX_FMT_NV16:
-	case V4L2_PIX_FMT_NV61:
-		image_mode = true;
-		break;
-	default:
-		image_mode = false;
-	}
-
-	dev_geo(dev, "S_FMT(pix=0x%x, fld 0x%x, code 0x%x, %ux%u)\n", pixfmt, mf.field, mf.code,
-		pix->width, pix->height);
-
-	dev_geo(dev, "4: request camera output %ux%u\n", mf.width, mf.height);
-
-	/* 5. - 9. */
-	ret = client_scale(icd, &mf, &ceu_sub_width, &ceu_sub_height,
-			   image_mode && V4L2_FIELD_NONE == field);
-
-	dev_geo(dev, "5-9: client scale return %d\n", ret);
-
-	/* Done with the camera. Now see if we can improve the result */
+	image_mode = ceu_fmt_can_scale(pixfmt);
 
-	dev_geo(dev, "fmt %ux%u, requested %ux%u\n",
-		mf.width, mf.height, pix->width, pix->height);
-	if (ret < 0)
-		return ret;
+	field = ceu_supported_field(&pix->field);
 
-	if (mf.code != xlate->code)
-		return -EINVAL;
+	mf.colorspace	= pix->colorspace;
+	mf.field	= pix->field;
+	mf.code		= xlate->code;
 
-	/* 9. Prepare CEU crop */
-	cam->width = mf.width;
-	cam->height = mf.height;
+	dev_geo(icd->parent, "S_FMT(pix=0x%x, fld 0x%x, code 0x%x, %ux%u)\n",
+		pixfmt, mf.field, mf.code, pix->width, pix->height);
 
-	/* 10. Use CEU scaling to scale to the requested user window. */
+	/*
+	 * We do not call client scaling if:
+	 * (1) pixelformat is the same; and
+	 * (2) it is a natively supported format; and
+	 * (3) CEU performs subcropping, i.e., client scales = 1:1
+	 */
+	if (pixfmt != icd->current_fmt->host_fmt->fourcc ||
+	    !image_mode || !ceu_crop) {
+		field = ceu_supported_field(&pix->field);
 
-	/* We cannot scale up */
-	if (pix->width > ceu_sub_width)
-		ceu_sub_width = pix->width;
+		mf.field	= pix->field;
+		mf.code		= xlate->code;
 
-	if (pix->height > ceu_sub_height)
-		ceu_sub_height = pix->height;
+		/*
+		 * first request client .s_fmt(): this will provide it with the new
+		 * pixel code
+		 */
+		ret = v4l2_device_call_until_err(sd->v4l2_dev, (long)icd, video,
+						 s_mbus_fmt, &mf);
+		if (ret < 0)
+			return ret;
 
-	pix->colorspace = mf.colorspace;
+		xlate = soc_camera_xlate_by_mcode(icd, mf.code);
+		if (!xlate) {
+			xlate = icd->current_fmt;
+			dev_warn(dev,
+				 "Buggy client! Code %x not found, using current %x\n",
+				 mf.code, xlate->code);
+
+			mf.code = xlate->code;
+			mf.field = icd->field;
+			ret = v4l2_device_call_until_err(sd->v4l2_dev, (long)icd,
+							 video, s_mbus_fmt, &mf);
+			if (ret < 0)
+				return ret;
+			/* All tolerance has an end... */
+			BUG_ON(!soc_camera_xlate_by_mcode(icd, mf.code));
+		}
+	}
 
-	if (image_mode) {
-		/* Scale pix->{width x height} down to width x height */
-		scale_h		= calc_scale(ceu_sub_width, &pix->width);
-		scale_v		= calc_scale(ceu_sub_height, &pix->height);
+	if (!image_mode) {
+		if (ceu_crop) {
+			/* switching from a native to a non-native format */
+			ret = ceu_client_crop(icd, &mf);
+			if (ret < 0)
+				return ret;
+		}
+		ceu_non_native_scale(pcdev, cam, &mf);
 	} else {
-		pix->width	= ceu_sub_width;
-		pix->height	= ceu_sub_height;
-		scale_h		= 0;
-		scale_v		= 0;
-	}
+		if (!ceu_crop) {
+			/* We were not cropping and we keep it that way */
+			ret = ceu_crop_full_window(icd, pix, &mf);
+			if (ret < 0)
+				return ret;
+		}
 
-	pcdev->cflcr = scale_h | (scale_v << 16);
+		/*
+		 * If we were cropping, we don't touch our input here, only
+		 * change the output
+		 */
+		ceu_native_scale(pcdev, cam, pix);
+	}
 
 	/*
 	 * We have calculated CFLCR, the actual configuration will be performed
 	 * in sh_mobile_ceu_set_bus_param()
 	 */
 
-	dev_geo(dev, "10: W: %u : 0x%x = %u, H: %u : 0x%x = %u\n",
-		ceu_sub_width, scale_h, pix->width,
-		ceu_sub_height, scale_v, pix->height);
+	dev_geo(dev, "Client: %ux%u@%u:%u -> %ux%u\n",
+		cam->rect.width, cam->rect.height, cam->rect.left, cam->rect.top,
+		cam->width, cam->height);
+	dev_geo(dev, "CEU: %ux%u@%u:%u -> %ux%u\n",
+		cam->ceu_rect.width, cam->ceu_rect.height, cam->ceu_rect.left, cam->ceu_rect.top,
+		pix->width, pix->height);
 
 	cam->code		= xlate->code;
 	icd->current_fmt	= xlate;
 
-	pcdev->field = field;
-	pcdev->image_mode = image_mode;
+	pcdev->image_mode	= image_mode;
 
 	/* CFSZR requirement */
-	pix->width	&= ~3;
-	pix->height	&= ~3;
+	pix->width		&= ~3;
+	pix->height		&= ~3;
 
 	return 0;
 }
@@ -1845,8 +1664,13 @@ static int sh_mobile_ceu_try_fmt(struct soc_camera_device *icd,
 
 	xlate = soc_camera_xlate_by_fourcc(icd, pixfmt);
 	if (!xlate) {
-		dev_warn(icd->parent, "Format %x not found\n", pixfmt);
-		return -EINVAL;
+		xlate			= icd->current_fmt;
+		dev_warn(dev, "Format %x not found, using current %x\n",
+			 pixfmt, xlate->host_fmt->fourcc);
+		pixfmt			= xlate->host_fmt->fourcc;
+		pix->pixelformat	= pixfmt;
+		pix->colorspace		= icd->colorspace;
+		pix->field		= icd->field;
 	}
 
 	/* FIXME: calculate using depth and bus width */
@@ -1866,8 +1690,12 @@ static int sh_mobile_ceu_try_fmt(struct soc_camera_device *icd,
 	mf.colorspace	= pix->colorspace;
 
 	ret = v4l2_device_call_until_err(sd->v4l2_dev, (long)icd, video, try_mbus_fmt, &mf);
-	if (ret < 0)
+	if (ret < 0) {
+		/* Buggy client driver */
+		dev_err(icd->parent,
+			"FIXME: client try_fmt() = %d\n", ret);
 		return ret;
+	}
 
 	pix->width	= mf.width;
 	pix->height	= mf.height;
@@ -1892,7 +1720,7 @@ static int sh_mobile_ceu_try_fmt(struct soc_camera_device *icd,
 			ret = v4l2_device_call_until_err(sd->v4l2_dev, (long)icd, video,
 							 try_mbus_fmt, &mf);
 			if (ret < 0) {
-				/* Shouldn't actually happen... */
+				/* Shouldn't happen */
 				dev_err(icd->parent,
 					"FIXME: client try_fmt() = %d\n", ret);
 				return ret;
@@ -1908,10 +1736,10 @@ static int sh_mobile_ceu_try_fmt(struct soc_camera_device *icd,
 	pix->width	&= ~3;
 	pix->height	&= ~3;
 
-	dev_geo(icd->parent, "%s(): return %d, fmt 0x%x, %ux%u\n",
-		__func__, ret, pix->pixelformat, pix->width, pix->height);
+	dev_geo(icd->parent, "%s(): fmt 0x%x, %ux%u\n",
+		__func__, pix->pixelformat, pix->width, pix->height);
 
-	return ret;
+	return 0;
 }
 
 static int sh_mobile_ceu_set_livecrop(struct soc_camera_device *icd,
@@ -1945,7 +1773,7 @@ static int sh_mobile_ceu_set_livecrop(struct soc_camera_device *icd,
 				.width		= out_width,
 				.height		= out_height,
 				.pixelformat	= icd->current_fmt->host_fmt->fourcc,
-				.field		= pcdev->field,
+				.field		= icd->field,
 				.colorspace	= icd->colorspace,
 			},
 		};
-- 
1.7.2.5

