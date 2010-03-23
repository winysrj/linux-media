Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:39951 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753850Ab0CWObX (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 23 Mar 2010 10:31:23 -0400
Date: Tue, 23 Mar 2010 15:31:24 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
cc: Magnus Damm <damm@opensource.se>,
	"linux-sh@vger.kernel.org" <linux-sh@vger.kernel.org>
Subject: [PATCH] sh_mobile_ceu_camera.c: preserve output window on VIDIOC_S_CROP
Message-ID: <Pine.LNX.4.64.1003231529490.5340@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Current version of sh_mobile_ceu_camera.c interprets the V4L2 API specification
of the VIDIOC_S_CROP ioctl as "change input (for capture devices) area,
preserve scaling factors, therefore change output window," whereas a more
intuitive interpretation of the API is "change input area, preserve output
window." Switch sh_mobile_ceu_camera.c to use this interpretation.

Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
---
 drivers/media/video/sh_mobile_ceu_camera.c |  601 ++++++++++++++--------------
 1 files changed, 309 insertions(+), 292 deletions(-)

diff --git a/drivers/media/video/sh_mobile_ceu_camera.c b/drivers/media/video/sh_mobile_ceu_camera.c
index cb34e74..6dc2630 100644
--- a/drivers/media/video/sh_mobile_ceu_camera.c
+++ b/drivers/media/video/sh_mobile_ceu_camera.c
@@ -114,9 +114,20 @@ struct sh_mobile_ceu_dev {
 };
 
 struct sh_mobile_ceu_cam {
-	struct v4l2_rect ceu_rect;
-	unsigned int cam_width;
-	unsigned int cam_height;
+	/* CEU offsets within scaled by the CEU camera output */
+	unsigned int ceu_left;
+	unsigned int ceu_top;
+	/* Client output, as seen by the CEU */
+	unsigned int width;
+	unsigned int height;
+	/*
+	 * User window from S_CROP / G_CROP, produced by client cropping and
+	 * scaling, CEU scaling and CEU cropping, mapped back onto the client
+	 * input window
+	 */
+	struct v4l2_rect subrect;
+	/* Camera cropping rectangle */
+	struct v4l2_rect rect;
 	const struct soc_mbus_pixelfmt *extra_fmt;
 	enum v4l2_mbus_pixelcode code;
 };
@@ -564,38 +575,36 @@ static u16 calc_scale(unsigned int src, unsigned int *dst)
 }
 
 /* rect is guaranteed to not exceed the scaled camera rectangle */
-static void sh_mobile_ceu_set_rect(struct soc_camera_device *icd,
-				   unsigned int out_width,
-				   unsigned int out_height)
+static void sh_mobile_ceu_set_rect(struct soc_camera_device *icd)
 {
 	struct soc_camera_host *ici = to_soc_camera_host(icd->dev.parent);
 	struct sh_mobile_ceu_cam *cam = icd->host_priv;
-	struct v4l2_rect *rect = &cam->ceu_rect;
 	struct sh_mobile_ceu_dev *pcdev = ici->priv;
 	unsigned int height, width, cdwdr_width, in_width, in_height;
 	unsigned int left_offset, top_offset;
 	u32 camor;
 
-	dev_dbg(icd->dev.parent, "Crop %ux%u@%u:%u\n",
-		rect->width, rect->height, rect->left, rect->top);
+	dev_geo(icd->dev.parent, "Crop %ux%u@%u:%u\n",
+		icd->user_width, icd->user_height, cam->ceu_left, cam->ceu_top);
 
-	left_offset	= rect->left;
-	top_offset	= rect->top;
+	left_offset	= cam->ceu_left;
+	top_offset	= cam->ceu_top;
 
+	/* CEU cropping (CFSZR) is applied _after_ the scaling filter (CFLCR) */
 	if (pcdev->image_mode) {
-		in_width = rect->width;
+		in_width = cam->width;
 		if (!pcdev->is_16bit) {
 			in_width *= 2;
 			left_offset *= 2;
 		}
-		width = out_width;
-		cdwdr_width = out_width;
+		width = icd->user_width;
+		cdwdr_width = icd->user_width;
 	} else {
-		int bytes_per_line = soc_mbus_bytes_per_line(out_width,
+		int bytes_per_line = soc_mbus_bytes_per_line(icd->user_width,
 						icd->current_fmt->host_fmt);
 		unsigned int w_factor;
 
-		width = out_width;
+		width = icd->user_width;
 
 		switch (icd->current_fmt->host_fmt->packing) {
 		case SOC_MBUS_PACKING_2X8_PADHI:
@@ -605,17 +614,17 @@ static void sh_mobile_ceu_set_rect(struct soc_camera_device *icd,
 			w_factor = 1;
 		}
 
-		in_width = rect->width * w_factor;
+		in_width = cam->width * w_factor;
 		left_offset = left_offset * w_factor;
 
 		if (bytes_per_line < 0)
-			cdwdr_width = out_width;
+			cdwdr_width = icd->user_width;
 		else
 			cdwdr_width = bytes_per_line;
 	}
 
-	height = out_height;
-	in_height = rect->height;
+	height = icd->user_height;
+	in_height = cam->height;
 	if (V4L2_FIELD_NONE != pcdev->field) {
 		height /= 2;
 		in_height /= 2;
@@ -774,9 +783,10 @@ static int sh_mobile_ceu_set_bus_param(struct soc_camera_device *icd,
 	}
 	ceu_write(pcdev, CAIFR, value);
 
-	sh_mobile_ceu_set_rect(icd, icd->user_width, icd->user_height);
+	sh_mobile_ceu_set_rect(icd);
 	mdelay(1);
 
+	dev_geo(icd->dev.parent, "CFLCR 0x%x\n", pcdev->cflcr);
 	ceu_write(pcdev, CFLCR, pcdev->cflcr);
 
 	/*
@@ -865,6 +875,8 @@ static bool sh_mobile_ceu_packing_supported(const struct soc_mbus_pixelfmt *fmt)
 		 fmt->packing == SOC_MBUS_PACKING_EXTEND16);
 }
 
+static int client_g_rect(struct v4l2_subdev *sd, struct v4l2_rect *rect);
+
 static int sh_mobile_ceu_get_formats(struct soc_camera_device *icd, int idx,
 				     struct soc_camera_format_xlate *xlate)
 {
@@ -893,10 +905,55 @@ static int sh_mobile_ceu_get_formats(struct soc_camera_device *icd, int idx,
 		return 0;
 
 	if (!icd->host_priv) {
+		struct v4l2_mbus_framefmt mf;
+		struct v4l2_rect rect;
+		struct device *dev = icd->dev.parent;
+		int shift = 0;
+
+		/* FIXME: subwindow is lost between close / open */
+
+		/* Cache current client geometry */
+		ret = client_g_rect(sd, &rect);
+		if (ret < 0)
+			return ret;
+
+		/* First time */
+		ret = v4l2_subdev_call(sd, video, g_mbus_fmt, &mf);
+		if (ret < 0)
+			return ret;
+
+		while ((mf.width > 2560 || mf.height > 1920) && shift < 4) {
+			/* Try 2560x1920, 1280x960, 640x480, 320x240 */
+			mf.width	= 2560 >> shift;
+			mf.height	= 1920 >> shift;
+			ret = v4l2_subdev_call(sd, video, s_mbus_fmt, &mf);
+			if (ret < 0)
+				return ret;
+			shift++;
+		}
+
+		if (shift == 4) {
+			dev_err(dev, "Failed to configure the client below %ux%x\n",
+				mf.width, mf.height);
+			return -EIO;
+		}
+
+		dev_geo(dev, "camera fmt %ux%u\n", mf.width, mf.height);
+
 		cam = kzalloc(sizeof(*cam), GFP_KERNEL);
 		if (!cam)
 			return -ENOMEM;
 
+		/* We are called with current camera crop, initialise subrect with it */
+		cam->rect	= rect;
+		cam->subrect	= rect;
+
+		cam->width	= mf.width;
+		cam->height	= mf.height;
+
+		cam->width	= mf.width;
+		cam->height	= mf.height;
+
 		icd->host_priv = cam;
 	} else {
 		cam = icd->host_priv;
@@ -978,16 +1035,12 @@ static unsigned int scale_down(unsigned int size, unsigned int scale)
 	return (size * 4096 + scale / 2) / scale;
 }
 
-static unsigned int scale_up(unsigned int size, unsigned int scale)
-{
-	return (size * scale + 2048) / 4096;
-}
-
 static unsigned int calc_generic_scale(unsigned int input, unsigned int output)
 {
 	return (input * 4096 + output / 2) / output;
 }
 
+/* Get and store current client crop */
 static int client_g_rect(struct v4l2_subdev *sd, struct v4l2_rect *rect)
 {
 	struct v4l2_crop crop;
@@ -1006,25 +1059,51 @@ static int client_g_rect(struct v4l2_subdev *sd, struct v4l2_rect *rect)
 	cap.type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
 
 	ret = v4l2_subdev_call(sd, video, cropcap, &cap);
-	if (ret < 0)
-		return ret;
-
-	*rect = cap.defrect;
+	if (!ret)
+		*rect = cap.defrect;
 
 	return ret;
 }
 
+/* Client crop has changed, update our sub-rectangle to remain within the area */
+static void update_subrect(struct sh_mobile_ceu_cam *cam)
+{
+	struct v4l2_rect *rect = &cam->rect, *subrect = &cam->subrect;
+
+	if (rect->width < subrect->width)
+		subrect->width = rect->width;
+
+	if (rect->height < subrect->height)
+		subrect->height = rect->height;
+
+	if (rect->left > subrect->left)
+		subrect->left = rect->left;
+	else if (rect->left + rect->width >
+		 subrect->left + subrect->width)
+		subrect->left = rect->left + rect->width -
+			subrect->width;
+
+	if (rect->top > subrect->top)
+		subrect->top = rect->top;
+	else if (rect->top + rect->height >
+		 subrect->top + subrect->height)
+		subrect->top = rect->top + rect->height -
+			subrect->height;
+}
+
 /*
  * The common for both scaling and cropping iterative approach is:
  * 1. try if the client can produce exactly what requested by the user
  * 2. if (1) failed, try to double the client image until we get one big enough
  * 3. if (2) failed, try to request the maximum image
  */
-static int client_s_crop(struct v4l2_subdev *sd, struct v4l2_crop *crop,
+static int client_s_crop(struct soc_camera_device *icd, struct v4l2_crop *crop,
 			 struct v4l2_crop *cam_crop)
 {
+	struct v4l2_subdev *sd = soc_camera_to_subdev(icd);
 	struct v4l2_rect *rect = &crop->c, *cam_rect = &cam_crop->c;
 	struct device *dev = sd->v4l2_dev->dev;
+	struct sh_mobile_ceu_cam *cam = icd->host_priv;
 	struct v4l2_cropcap cap;
 	int ret;
 	unsigned int width, height;
@@ -1042,6 +1121,7 @@ static int client_s_crop(struct v4l2_subdev *sd, struct v4l2_crop *crop,
 		/* Even if camera S_CROP failed, but camera rectangle matches */
 		dev_dbg(dev, "Camera S_CROP successful for %dx%d@%d:%d\n",
 			rect->width, rect->height, rect->left, rect->top);
+		cam->rect = *cam_rect;
 		return 0;
 	}
 
@@ -1056,6 +1136,7 @@ static int client_s_crop(struct v4l2_subdev *sd, struct v4l2_crop *crop,
 	if (ret < 0)
 		return ret;
 
+	/* Put user requested rectangle within sensor bounds */
 	soc_camera_limit_side(&rect->left, &rect->width, cap.bounds.left, 2,
 			      cap.bounds.width);
 	soc_camera_limit_side(&rect->top, &rect->height, cap.bounds.top, 4,
@@ -1068,6 +1149,10 @@ static int client_s_crop(struct v4l2_subdev *sd, struct v4l2_crop *crop,
 	width = max(cam_rect->width, 2);
 	height = max(cam_rect->height, 2);
 
+	/*
+	 * Loop as long as sensor is not covering the requested rectangle and
+	 * is still within its bounds
+	 */
 	while (!ret && (is_smaller(cam_rect, rect) ||
 			is_inside(cam_rect, rect)) &&
 	       (cap.bounds.width > width || cap.bounds.height > height)) {
@@ -1085,6 +1170,7 @@ static int client_s_crop(struct v4l2_subdev *sd, struct v4l2_crop *crop,
 		 * target left, set it to the middle point between the current
 		 * left and minimum left. But that would add too much
 		 * complexity: we would have to iterate each border separately.
+		 * Instead we just drop to the left and top bounds.
 		 */
 		if (cam_rect->left > rect->left)
 			cam_rect->left = cap.bounds.left;
@@ -1121,77 +1207,19 @@ static int client_s_crop(struct v4l2_subdev *sd, struct v4l2_crop *crop,
 			cam_rect->left, cam_rect->top);
 	}
 
-	return ret;
-}
-
-static int get_camera_scales(struct v4l2_subdev *sd, struct v4l2_rect *rect,
-			     unsigned int *scale_h, unsigned int *scale_v)
-{
-	struct v4l2_mbus_framefmt mf;
-	int ret;
-
-	ret = v4l2_subdev_call(sd, video, g_mbus_fmt, &mf);
-	if (ret < 0)
-		return ret;
-
-	*scale_h = calc_generic_scale(rect->width, mf.width);
-	*scale_v = calc_generic_scale(rect->height, mf.height);
-
-	return 0;
-}
-
-static int get_camera_subwin(struct soc_camera_device *icd,
-			     struct v4l2_rect *cam_subrect,
-			     unsigned int cam_hscale, unsigned int cam_vscale)
-{
-	struct sh_mobile_ceu_cam *cam = icd->host_priv;
-	struct v4l2_rect *ceu_rect = &cam->ceu_rect;
-
-	if (!ceu_rect->width) {
-		struct v4l2_subdev *sd = soc_camera_to_subdev(icd);
-		struct device *dev = icd->dev.parent;
-		struct v4l2_mbus_framefmt mf;
-		int ret;
-		/* First time */
-
-		ret = v4l2_subdev_call(sd, video, g_mbus_fmt, &mf);
-		if (ret < 0)
-			return ret;
-
-		dev_geo(dev, "camera fmt %ux%u\n", mf.width, mf.height);
-
-		if (mf.width > 2560) {
-			ceu_rect->width	 = 2560;
-			ceu_rect->left	 = (mf.width - 2560) / 2;
-		} else {
-			ceu_rect->width	 = mf.width;
-			ceu_rect->left	 = 0;
-		}
-
-		if (mf.height > 1920) {
-			ceu_rect->height = 1920;
-			ceu_rect->top	 = (mf.height - 1920) / 2;
-		} else {
-			ceu_rect->height = mf.height;
-			ceu_rect->top	 = 0;
-		}
-
-		dev_geo(dev, "initialised CEU rect %ux%u@%u:%u\n",
-			ceu_rect->width, ceu_rect->height,
-			ceu_rect->left, ceu_rect->top);
+	if (!ret) {
+		cam->rect = *cam_rect;
+		update_subrect(cam);
 	}
 
-	cam_subrect->width	= scale_up(ceu_rect->width, cam_hscale);
-	cam_subrect->left	= scale_up(ceu_rect->left, cam_hscale);
-	cam_subrect->height	= scale_up(ceu_rect->height, cam_vscale);
-	cam_subrect->top	= scale_up(ceu_rect->top, cam_vscale);
-
-	return 0;
+	return ret;
 }
 
+/* Iterative s_mbus_fmt, also updates cached client crop on success */
 static int client_s_fmt(struct soc_camera_device *icd,
 			struct v4l2_mbus_framefmt *mf, bool ceu_can_scale)
 {
+	struct sh_mobile_ceu_cam *cam = icd->host_priv;
 	struct v4l2_subdev *sd = soc_camera_to_subdev(icd);
 	struct device *dev = icd->dev.parent;
 	unsigned int width = mf->width, height = mf->height, tmp_w, tmp_h;
@@ -1199,6 +1227,15 @@ static int client_s_fmt(struct soc_camera_device *icd,
 	struct v4l2_cropcap cap;
 	int ret;
 
+	ret = v4l2_subdev_call(sd, video, s_mbus_fmt, mf);
+	if (ret < 0)
+		return ret;
+
+	dev_geo(dev, "camera scaled to %ux%u\n", mf->width, mf->height);
+
+	if ((width == mf->width && height == mf->height) || !ceu_can_scale)
+		goto update_cache;
+
 	cap.type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
 
 	ret = v4l2_subdev_call(sd, video, cropcap, &cap);
@@ -1208,15 +1245,6 @@ static int client_s_fmt(struct soc_camera_device *icd,
 	max_width = min(cap.bounds.width, 2560);
 	max_height = min(cap.bounds.height, 1920);
 
-	ret = v4l2_subdev_call(sd, video, s_mbus_fmt, mf);
-	if (ret < 0)
-		return ret;
-
-	dev_geo(dev, "camera scaled to %ux%u\n", mf->width, mf->height);
-
-	if ((width == mf->width && height == mf->height) || !ceu_can_scale)
-		return 0;
-
 	/* Camera set a format, but geometry is not precise, try to improve */
 	tmp_w = mf->width;
 	tmp_h = mf->height;
@@ -1238,26 +1266,37 @@ static int client_s_fmt(struct soc_camera_device *icd,
 		}
 	}
 
+update_cache:
+	/* Update cache */
+	ret = client_g_rect(sd, &cam->rect);
+	if (ret < 0)
+		return ret;
+
+	update_subrect(cam);
+
 	return 0;
 }
 
 /**
- * @rect	- camera cropped rectangle
- * @sub_rect	- CEU cropped rectangle, mapped back to camera input area
- * @ceu_rect	- on output calculated CEU crop rectangle
+ * @width	- on output: user width, mapped back to input
+ * @height	- on output: user height, mapped back to input
+ * @mf		- in- / output camera output window
  */
-static int client_scale(struct soc_camera_device *icd, struct v4l2_rect *rect,
-			struct v4l2_rect *sub_rect, struct v4l2_rect *ceu_rect,
-			struct v4l2_mbus_framefmt *mf, bool ceu_can_scale)
+static int client_scale(struct soc_camera_device *icd,
+			struct v4l2_mbus_framefmt *mf,
+			unsigned int *width, unsigned int *height,
+			bool ceu_can_scale)
 {
-	struct v4l2_subdev *sd = soc_camera_to_subdev(icd);
 	struct sh_mobile_ceu_cam *cam = icd->host_priv;
 	struct device *dev = icd->dev.parent;
 	struct v4l2_mbus_framefmt mf_tmp = *mf;
 	unsigned int scale_h, scale_v;
 	int ret;
 
-	/* 5. Apply iterative camera S_FMT for camera user window. */
+	/*
+	 * 5. Apply iterative camera S_FMT for camera user window (also updates
+	 *    client crop cache and the imaginary sub-rectangle).
+	 */
 	ret = client_s_fmt(icd, &mf_tmp, ceu_can_scale);
 	if (ret < 0)
 		return ret;
@@ -1269,60 +1308,22 @@ static int client_scale(struct soc_camera_device *icd, struct v4l2_rect *rect,
 
 	/* unneeded - it is already in "mf_tmp" */
 
-	/* 7. Calculate new camera scales. */
-	ret = get_camera_scales(sd, rect, &scale_h, &scale_v);
-	if (ret < 0)
-		return ret;
-
-	dev_geo(dev, "7: camera scales %u:%u\n", scale_h, scale_v);
+	/* 7. Calculate new client scales. */
+	scale_h = calc_generic_scale(cam->rect.width, mf_tmp.width);
+	scale_v = calc_generic_scale(cam->rect.height, mf_tmp.height);
 
-	cam->cam_width	= mf_tmp.width;
-	cam->cam_height	= mf_tmp.height;
 	mf->width	= mf_tmp.width;
 	mf->height	= mf_tmp.height;
 	mf->colorspace	= mf_tmp.colorspace;
 
 	/*
 	 * 8. Calculate new CEU crop - apply camera scales to previously
-	 *    calculated "effective" crop.
+	 *    updated "effective" crop.
 	 */
-	ceu_rect->left = scale_down(sub_rect->left, scale_h);
-	ceu_rect->width = scale_down(sub_rect->width, scale_h);
-	ceu_rect->top = scale_down(sub_rect->top, scale_v);
-	ceu_rect->height = scale_down(sub_rect->height, scale_v);
+	*width = scale_down(cam->subrect.width, scale_h);
+	*height = scale_down(cam->subrect.height, scale_v);
 
-	dev_geo(dev, "8: new CEU rect %ux%u@%u:%u\n",
-		ceu_rect->width, ceu_rect->height,
-		ceu_rect->left, ceu_rect->top);
-
-	return 0;
-}
-
-/* Get combined scales */
-static int get_scales(struct soc_camera_device *icd,
-		      unsigned int *scale_h, unsigned int *scale_v)
-{
-	struct sh_mobile_ceu_cam *cam = icd->host_priv;
-	struct v4l2_subdev *sd = soc_camera_to_subdev(icd);
-	struct v4l2_crop cam_crop;
-	unsigned int width_in, height_in;
-	int ret;
-
-	cam_crop.type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
-
-	ret = client_g_rect(sd, &cam_crop.c);
-	if (ret < 0)
-		return ret;
-
-	ret = get_camera_scales(sd, &cam_crop.c, scale_h, scale_v);
-	if (ret < 0)
-		return ret;
-
-	width_in = scale_up(cam->ceu_rect.width, *scale_h);
-	height_in = scale_up(cam->ceu_rect.height, *scale_v);
-
-	*scale_h = calc_generic_scale(width_in, icd->user_width);
-	*scale_v = calc_generic_scale(height_in, icd->user_height);
+	dev_geo(dev, "8: new client sub-window %ux%u\n", *width, *height);
 
 	return 0;
 }
@@ -1341,115 +1342,165 @@ static int sh_mobile_ceu_set_crop(struct soc_camera_device *icd,
 	struct sh_mobile_ceu_dev *pcdev = ici->priv;
 	struct v4l2_crop cam_crop;
 	struct sh_mobile_ceu_cam *cam = icd->host_priv;
-	struct v4l2_rect *cam_rect = &cam_crop.c, *ceu_rect = &cam->ceu_rect;
+	struct v4l2_rect *cam_rect = &cam_crop.c;
 	struct v4l2_subdev *sd = soc_camera_to_subdev(icd);
 	struct device *dev = icd->dev.parent;
 	struct v4l2_mbus_framefmt mf;
-	unsigned int scale_comb_h, scale_comb_v, scale_ceu_h, scale_ceu_v,
-		out_width, out_height;
+	unsigned int scale_cam_h, scale_cam_v, scale_ceu_h, scale_ceu_v,
+		out_width, out_height, scale_h, scale_v;
+	int interm_width, interm_height;
 	u32 capsr, cflcr;
 	int ret;
 
-	/* 1. Calculate current combined scales. */
-	ret = get_scales(icd, &scale_comb_h, &scale_comb_v);
-	if (ret < 0)
-		return ret;
+	dev_geo(dev, "S_CROP(%ux%u@%u:%u)\n", rect->width, rect->height,
+		rect->left, rect->top);
 
-	dev_geo(dev, "1: combined scales %u:%u\n", scale_comb_h, scale_comb_v);
+	/* During camera cropping its output window can change too, stop CEU */
+	capsr = capture_save_reset(pcdev);
+	dev_dbg(dev, "CAPSR 0x%x, CFLCR 0x%x\n", capsr, pcdev->cflcr);
 
-	/* 2. Apply iterative camera S_CROP for new input window. */
-	ret = client_s_crop(sd, a, &cam_crop);
+	/* 1. - 2. Apply iterative camera S_CROP for new input window. */
+	ret = client_s_crop(icd, a, &cam_crop);
 	if (ret < 0)
 		return ret;
 
-	dev_geo(dev, "2: camera cropped to %ux%u@%u:%u\n",
+	dev_geo(dev, "1-2: camera cropped to %ux%u@%u:%u\n",
 		cam_rect->width, cam_rect->height,
 		cam_rect->left, cam_rect->top);
 
 	/* On success cam_crop contains current camera crop */
 
-	/*
-	 * 3. If old combined scales applied to new crop produce an impossible
-	 *    user window, adjust scales to produce nearest possible window.
-	 */
-	out_width	= scale_down(rect->width, scale_comb_h);
-	out_height	= scale_down(rect->height, scale_comb_v);
-
-	if (out_width > 2560)
-		out_width = 2560;
-	else if (out_width < 2)
-		out_width = 2;
-
-	if (out_height > 1920)
-		out_height = 1920;
-	else if (out_height < 4)
-		out_height = 4;
-
-	dev_geo(dev, "3: Adjusted output %ux%u\n", out_width, out_height);
-
-	/* 4. Use G_CROP to retrieve actual input window: already in cam_crop */
-
-	/*
-	 * 5. Using actual input window and calculated combined scales calculate
-	 *    camera target output window.
-	 */
-	mf.width	= scale_down(cam_rect->width, scale_comb_h);
-	mf.height	= scale_down(cam_rect->height, scale_comb_v);
-
-	dev_geo(dev, "5: camera target %ux%u\n", mf.width, mf.height);
-
-	/* 6. - 9. */
-	mf.code		= cam->code;
-	mf.field	= pcdev->field;
-
-	capsr = capture_save_reset(pcdev);
-	dev_dbg(dev, "CAPSR 0x%x, CFLCR 0x%x\n", capsr, pcdev->cflcr);
+	/* 3. Retrieve camera output window */
+	ret = v4l2_subdev_call(sd, video, g_mbus_fmt, &mf);
+	if (ret < 0)
+		return ret;
 
-	/* Make relative to camera rectangle */
-	rect->left	-= cam_rect->left;
-	rect->top	-= cam_rect->top;
+	if (mf.width > 2560 || mf.height > 1920)
+		return -EINVAL;
 
-	ret = client_scale(icd, cam_rect, rect, ceu_rect, &mf,
-			   pcdev->image_mode &&
-			   V4L2_FIELD_NONE == pcdev->field);
+	/* Cache camera output window */
+	cam->width	= mf.width;
+	cam->height	= mf.height;
 
-	dev_geo(dev, "6-9: %d\n", ret);
+	/* 4. Calculate camera scales */
+	scale_cam_h	= calc_generic_scale(cam_rect->width, mf.width);
+	scale_cam_v	= calc_generic_scale(cam_rect->height, mf.height);
 
-	/* 10. Use CEU cropping to crop to the new window. */
-	sh_mobile_ceu_set_rect(icd, out_width, out_height);
+	/* Calculate intermediate window */
+	interm_width	= scale_down(rect->width, scale_cam_h);
+	interm_height	= scale_down(rect->height, scale_cam_v);
 
-	dev_geo(dev, "10: CEU cropped to %ux%u@%u:%u\n",
-		ceu_rect->width, ceu_rect->height,
-		ceu_rect->left, ceu_rect->top);
+	if (pcdev->image_mode) {
+		out_width	= min(interm_width, icd->user_width);
+		out_height	= min(interm_height, icd->user_height);
+	} else {
+		out_width	= interm_width;
+		out_height	= interm_height;
+	}
 
 	/*
-	 * 11. Calculate CEU scales from camera scales from results of (10) and
-	 *     user window from (3)
+	 * 5. Calculate CEU scales from camera scales from results of (5) and
+	 *    the user window
 	 */
-	scale_ceu_h = calc_scale(ceu_rect->width, &out_width);
-	scale_ceu_v = calc_scale(ceu_rect->height, &out_height);
+	scale_ceu_h	= calc_scale(interm_width, &out_width);
+	scale_ceu_v	= calc_scale(interm_height, &out_height);
 
-	dev_geo(dev, "11: CEU scales %u:%u\n", scale_ceu_h, scale_ceu_v);
+	/* Calculate camera scales */
+	scale_h		= calc_generic_scale(cam_rect->width, out_width);
+	scale_v		= calc_generic_scale(cam_rect->height, out_height);
 
-	/* 12. Apply CEU scales. */
+	dev_geo(dev, "5: CEU scales %u:%u\n", scale_ceu_h, scale_ceu_v);
+
+	/* Apply CEU scales. */
 	cflcr = scale_ceu_h | (scale_ceu_v << 16);
 	if (cflcr != pcdev->cflcr) {
 		pcdev->cflcr = cflcr;
 		ceu_write(pcdev, CFLCR, cflcr);
 	}
 
+	icd->user_width	 = out_width;
+	icd->user_height = out_height;
+	cam->ceu_left	 = scale_down(rect->left - cam_rect->left, scale_h) & ~1;
+	cam->ceu_top	 = scale_down(rect->top - cam_rect->top, scale_v) & ~1;
+
+	/* 6. Use CEU cropping to crop to the new window. */
+	sh_mobile_ceu_set_rect(icd);
+
+	cam->subrect = *rect;
+
+	dev_geo(dev, "6: CEU cropped to %ux%u@%u:%u\n",
+		icd->user_width, icd->user_height,
+		cam->ceu_left, cam->ceu_top);
+
 	/* Restore capture */
 	if (pcdev->active)
 		capsr |= 1;
 	capture_restore(pcdev, capsr);
 
-	icd->user_width = out_width;
-	icd->user_height = out_height;
-
 	/* Even if only camera cropping succeeded */
 	return ret;
 }
 
+static int sh_mobile_ceu_get_crop(struct soc_camera_device *icd,
+				  struct v4l2_crop *a)
+{
+	struct sh_mobile_ceu_cam *cam = icd->host_priv;
+
+	a->type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
+	a->c = cam->subrect;
+
+	return 0;
+}
+
+/*
+ * Calculate real client output window by applying new scales to the current
+ * client crop. New scales are calculated from the requested output format and
+ * CEU crop, mapped backed onto the client input (subrect).
+ */
+static void calculate_client_output(struct soc_camera_device *icd,
+		struct v4l2_pix_format *pix, struct v4l2_mbus_framefmt *mf)
+{
+	struct sh_mobile_ceu_cam *cam = icd->host_priv;
+	struct device *dev = icd->dev.parent;
+	struct v4l2_rect *cam_subrect = &cam->subrect;
+	unsigned int scale_v, scale_h;
+
+	if (cam_subrect->width == cam->rect.width &&
+	    cam_subrect->height == cam->rect.height) {
+		/* No sub-cropping */
+		mf->width	= pix->width;
+		mf->height	= pix->height;
+		return;
+	}
+
+	/* 1.-2. Current camera scales and subwin - cached. */
+
+	dev_geo(dev, "2: subwin %ux%u@%u:%u\n",
+		cam_subrect->width, cam_subrect->height,
+		cam_subrect->left, cam_subrect->top);
+
+	/*
+	 * 3. Calculate new combined scales from input sub-window to requested
+	 *    user window.
+	 */
+
+	/*
+	 * TODO: CEU cannot scale images larger than VGA to smaller than SubQCIF
+	 * (128x96) or larger than VGA
+	 */
+	scale_h = calc_generic_scale(cam_subrect->width, pix->width);
+	scale_v = calc_generic_scale(cam_subrect->height, pix->height);
+
+	dev_geo(dev, "3: scales %u:%u\n", scale_h, scale_v);
+
+	/*
+	 * 4. Calculate client output window by applying combined scales to real
+	 *    input window.
+	 */
+	mf->width	= scale_down(cam->rect.width, scale_h);
+	mf->height	= scale_down(cam->rect.height, scale_v);
+}
+
 /* Similar to set_crop multistage iterative algorithm */
 static int sh_mobile_ceu_set_fmt(struct soc_camera_device *icd,
 				 struct v4l2_format *f)
@@ -1459,18 +1510,17 @@ static int sh_mobile_ceu_set_fmt(struct soc_camera_device *icd,
 	struct sh_mobile_ceu_cam *cam = icd->host_priv;
 	struct v4l2_pix_format *pix = &f->fmt.pix;
 	struct v4l2_mbus_framefmt mf;
-	struct v4l2_subdev *sd = soc_camera_to_subdev(icd);
 	struct device *dev = icd->dev.parent;
 	__u32 pixfmt = pix->pixelformat;
 	const struct soc_camera_format_xlate *xlate;
-	struct v4l2_crop cam_crop;
-	struct v4l2_rect *cam_rect = &cam_crop.c, cam_subrect, ceu_rect;
-	unsigned int scale_cam_h, scale_cam_v;
+	unsigned int ceu_sub_width, ceu_sub_height;
 	u16 scale_v, scale_h;
 	int ret;
 	bool image_mode;
 	enum v4l2_field field;
 
+	dev_geo(dev, "S_FMT(pix=0x%x, %ux%u)\n", pixfmt, pix->width, pix->height);
+
 	switch (pix->field) {
 	default:
 		pix->field = V4L2_FIELD_NONE;
@@ -1491,46 +1541,8 @@ static int sh_mobile_ceu_set_fmt(struct soc_camera_device *icd,
 		return -EINVAL;
 	}
 
-	/* 1. Calculate current camera scales. */
-	cam_crop.type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
-
-	ret = client_g_rect(sd, cam_rect);
-	if (ret < 0)
-		return ret;
-
-	ret = get_camera_scales(sd, cam_rect, &scale_cam_h, &scale_cam_v);
-	if (ret < 0)
-		return ret;
-
-	dev_geo(dev, "1: camera scales %u:%u\n", scale_cam_h, scale_cam_v);
-
-	/*
-	 * 2. Calculate "effective" input crop (sensor subwindow) - CEU crop
-	 *    scaled back at current camera scales onto input window.
-	 */
-	ret = get_camera_subwin(icd, &cam_subrect, scale_cam_h, scale_cam_v);
-	if (ret < 0)
-		return ret;
-
-	dev_geo(dev, "2: subwin %ux%u@%u:%u\n",
-		cam_subrect.width, cam_subrect.height,
-		cam_subrect.left, cam_subrect.top);
-
-	/*
-	 * 3. Calculate new combined scales from "effective" input window to
-	 *    requested user window.
-	 */
-	scale_h = calc_generic_scale(cam_subrect.width, pix->width);
-	scale_v = calc_generic_scale(cam_subrect.height, pix->height);
-
-	dev_geo(dev, "3: scales %u:%u\n", scale_h, scale_v);
-
-	/*
-	 * 4. Calculate camera output window by applying combined scales to real
-	 *    input window.
-	 */
-	mf.width	= scale_down(cam_rect->width, scale_h);
-	mf.height	= scale_down(cam_rect->height, scale_v);
+	/* 1.-4. Calculate client output geometry */
+	calculate_client_output(icd, &f->fmt.pix, &mf);
 	mf.field	= pix->field;
 	mf.colorspace	= pix->colorspace;
 	mf.code		= xlate->code;
@@ -1546,17 +1558,17 @@ static int sh_mobile_ceu_set_fmt(struct soc_camera_device *icd,
 		image_mode = false;
 	}
 
-	dev_geo(dev, "4: camera output %ux%u\n", mf.width, mf.height);
+	dev_geo(dev, "4: request camera output %ux%u\n", mf.width, mf.height);
 
 	/* 5. - 9. */
-	ret = client_scale(icd, cam_rect, &cam_subrect, &ceu_rect, &mf,
+	ret = client_scale(icd, &mf, &ceu_sub_width, &ceu_sub_height,
 			   image_mode && V4L2_FIELD_NONE == field);
 
-	dev_geo(dev, "5-9: client scale %d\n", ret);
+	dev_geo(dev, "5-9: client scale return %d\n", ret);
 
 	/* Done with the camera. Now see if we can improve the result */
 
-	dev_dbg(dev, "Camera %d fmt %ux%u, requested %ux%u\n",
+	dev_geo(dev, "Camera %d fmt %ux%u, requested %ux%u\n",
 		ret, mf.width, mf.height, pix->width, pix->height);
 	if (ret < 0)
 		return ret;
@@ -1564,40 +1576,44 @@ static int sh_mobile_ceu_set_fmt(struct soc_camera_device *icd,
 	if (mf.code != xlate->code)
 		return -EINVAL;
 
+	/* 9. Prepare CEU crop */
+	cam->width = mf.width;
+	cam->height = mf.height;
+
 	/* 10. Use CEU scaling to scale to the requested user window. */
 
 	/* We cannot scale up */
-	if (pix->width > mf.width)
-		pix->width = mf.width;
-	if (pix->width > ceu_rect.width)
-		pix->width = ceu_rect.width;
+	if (pix->width > ceu_sub_width)
+		ceu_sub_width = pix->width;
 
-	if (pix->height > mf.height)
-		pix->height = mf.height;
-	if (pix->height > ceu_rect.height)
-		pix->height = ceu_rect.height;
+	if (pix->height > ceu_sub_height)
+		ceu_sub_height = pix->height;
 
 	pix->colorspace = mf.colorspace;
 
 	if (image_mode) {
 		/* Scale pix->{width x height} down to width x height */
-		scale_h = calc_scale(ceu_rect.width, &pix->width);
-		scale_v = calc_scale(ceu_rect.height, &pix->height);
-
-		pcdev->cflcr = scale_h | (scale_v << 16);
+		scale_h		= calc_scale(ceu_sub_width, &pix->width);
+		scale_v		= calc_scale(ceu_sub_height, &pix->height);
 	} else {
-		pix->width = ceu_rect.width;
-		pix->height = ceu_rect.height;
-		scale_h = scale_v = 0;
-		pcdev->cflcr = 0;
+		pix->width	= ceu_sub_width;
+		pix->height	= ceu_sub_height;
+		scale_h		= 0;
+		scale_v		= 0;
 	}
 
+	pcdev->cflcr = scale_h | (scale_v << 16);
+
+	/*
+	 * We have calculated CFLCR, the actual configuration will be performed
+	 * in sh_mobile_ceu_set_bus_param()
+	 */
+
 	dev_geo(dev, "10: W: %u : 0x%x = %u, H: %u : 0x%x = %u\n",
-		ceu_rect.width, scale_h, pix->width,
-		ceu_rect.height, scale_v, pix->height);
+		ceu_sub_width, scale_h, pix->width,
+		ceu_sub_height, scale_v, pix->height);
 
 	cam->code		= xlate->code;
-	cam->ceu_rect		= ceu_rect;
 	icd->current_fmt	= xlate;
 
 	pcdev->field = field;
@@ -1819,6 +1835,7 @@ static struct soc_camera_host_ops sh_mobile_ceu_host_ops = {
 	.remove		= sh_mobile_ceu_remove_device,
 	.get_formats	= sh_mobile_ceu_get_formats,
 	.put_formats	= sh_mobile_ceu_put_formats,
+	.get_crop	= sh_mobile_ceu_get_crop,
 	.set_crop	= sh_mobile_ceu_set_crop,
 	.set_fmt	= sh_mobile_ceu_set_fmt,
 	.try_fmt	= sh_mobile_ceu_try_fmt,
-- 
1.6.2.4

