Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:53943 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1757335AbZF3PON (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 30 Jun 2009 11:14:13 -0400
Date: Tue, 30 Jun 2009 17:14:25 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
cc: m-karicheri2@ti.com, Hans Verkuil <hverkuil@xs4all.nl>,
	Valentin Longchamp <valentin.longchamp@epfl.ch>
Subject: [PATCH RFC] fix cropping and scaling for mx3-camera and mt9t031
 drivers
Message-ID: <Pine.LNX.4.64.0906301656471.5748@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This makes mx3-camera and mt9t031 S_CROP and S_FMT implementations V4L2 
API compliant.

Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
---

This is definitely only an RFC, it only fixes one single configuration - 
i.MX31 (mx3-camera) and MT9T031, and breaks the rest, so, other soc-camera 
drivers do not even compile with this patch. But users of this hardware 
are encouraged to check this out. This is still based off an "old" (pre 
2.6.30) -next snapshot, the same patch stack at 
http://download.open-technology.de/soc-camera/20090617/ shall be applied 
(one patch added), for branch-base see 0000-base. The below patch is also 
under http://download.open-technology.de/testing/. I think, next I shall 
update to a more recent post-2.6.30 tree, and then start converting / 
fixing other drivers.

The addition to the documentation file is also only half-way serious, 
because the whole file is outdated and has to be fixed first.

While trying all possible skipping / binning combinations of mt9t031 I 
came across a problem, that in some configurations the sensor produces 
regular horizontal stripes. They depend on window geometry, with some 
skipping factors they can be eliminated by using properly aligned left 
window border, but with some other AFAICS valid parameter combinations 
stripes persist. And - they seem to depend on lighting conditions... I 
think, I'll try to ask Aptina again... Or does anyone have an idea what I 
might be doing wrong?

I tried to put everyone on CC, interested in the mt9t031 driver, sorry, if 
I forgot anyone.

Thanks
Guennadi

diff --git a/Documentation/video4linux/soc-camera.txt b/Documentation/video4linux/soc-camera.txt
index 178ef3c..9b230dd 100644
--- a/Documentation/video4linux/soc-camera.txt
+++ b/Documentation/video4linux/soc-camera.txt
@@ -116,5 +116,40 @@ functionality.
 struct soc_camera_device also links to an array of struct soc_camera_data_format,
 listing pixel formats, supported by the camera.
 
+VIDIOC_S_CROP and VIDIOC_S_FMT behaviour
+----------------------------------------
+
+Above user ioctls modify image geometry as follows:
+
+VIDIOC_S_CROP: sets location and sizes of the sensor window. Unit is one sensor
+pixel. Changing sensor window sizes preserves any scaling factors, therefore
+user window sizes change as well.
+
+VIDIOC_S_FMT: sets user window. Should preserve previously set sensor window as
+much as possible by modifying scaling factors. If the sensor window cannot be
+preserved precisely, it may be changed too.
+
+In soc-camera there are two locations, where scaling and cropping can taks
+place: in the camera driver and in the host driver. User ioctls are first passed
+to the host driver, which then generally passes them down to the camera driver.
+It is more efficient to perform scaling and cropping in the camera driver to
+save camera bus bandwidth and maximise the framerate. However, if the camera
+driver failed to set the required parameters with sufficient precision, the host
+driver may decide to also use its own scaling and cropping to fulfill the user's
+request.
+
+Camera drivers are interfaced to the soc-camera core and to host drivers over
+the v4l2-subdev API, which is completely functional, it doesn't pass any data.
+Therefore all camera drivers shall reply to .g_fmt() requests with their current
+output geometry. This is necessary to correctly configure the camera bus.
+.s_fmt() and .try_fmt() have to be implemented too. Sensor window and scaling
+factors have to be maintained by camera drivers internally.
+
+User window geometry is kept in .user_width and .user_height fields in struct
+soc_camera_device and used by the soc-camera core and host drivers. The core
+updates these fields upon successful completion of a .s_fmt() call, but if these
+fields change elsewhere, e.g., during .s_crop() processing, the host driver is
+responsible for updating them.
+
 --
 Author: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
diff --git a/drivers/media/video/mt9t031.c b/drivers/media/video/mt9t031.c
index 3bfc008..3b72e6e 100644
--- a/drivers/media/video/mt9t031.c
+++ b/drivers/media/video/mt9t031.c
@@ -47,7 +47,7 @@
 #define MT9T031_MAX_HEIGHT		1536
 #define MT9T031_MAX_WIDTH		2048
 #define MT9T031_MIN_HEIGHT		2
-#define MT9T031_MIN_WIDTH		2
+#define MT9T031_MIN_WIDTH		18
 #define MT9T031_HORIZONTAL_BLANK	142
 #define MT9T031_VERTICAL_BLANK		25
 #define MT9T031_COLUMN_SKIP		32
@@ -69,10 +69,11 @@ static const struct soc_camera_data_format mt9t031_colour_formats[] = {
 
 struct mt9t031 {
 	struct v4l2_subdev subdev;
+	struct v4l2_rect rect;	/* Sensor window */
 	int model;	/* V4L2_IDENT_MT9T031* codes from v4l2-chip-ident.h */
-	unsigned char autoexposure;
 	u16 xskip;
 	u16 yskip;
+	unsigned char autoexposure;
 };
 
 static struct mt9t031 *to_mt9t031(const struct i2c_client *client)
@@ -218,55 +219,62 @@ static unsigned long mt9t031_query_bus_param(struct soc_camera_device *icd)
 	return soc_camera_apply_sensor_flags(icl, MT9T031_BUS_PARAM);
 }
 
-/* Round up minima and round down maxima */
-static void recalculate_limits(struct soc_camera_device *icd,
-			       u16 xskip, u16 yskip)
+/* target must be _even_ */
+static u16 mt9t031_skip(s32 *source, s32 target, s32 max)
 {
-	icd->rect_max.left = (MT9T031_COLUMN_SKIP + xskip - 1) / xskip;
-	icd->rect_max.top = (MT9T031_ROW_SKIP + yskip - 1) / yskip;
-	icd->width_min = (MT9T031_MIN_WIDTH + xskip - 1) / xskip;
-	icd->height_min = (MT9T031_MIN_HEIGHT + yskip - 1) / yskip;
-	icd->rect_max.width = MT9T031_MAX_WIDTH / xskip;
-	icd->rect_max.height = MT9T031_MAX_HEIGHT / yskip;
+	unsigned int skip;
+
+	if (*source < target + target / 2) {
+		*source = target;
+		return 1;
+	}
+
+	skip = min(max, *source + target / 2) / target;
+	if (skip > 8)
+		skip = 8;
+	*source = target * skip;
+
+	return skip;
 }
 
+/* rect is the sensor rectangle, the caller guarantees parameter validity */
 static int mt9t031_set_params(struct soc_camera_device *icd,
 			      struct v4l2_rect *rect, u16 xskip, u16 yskip)
 {
 	struct i2c_client *client = to_i2c_client(to_soc_camera_control(icd));
 	struct mt9t031 *mt9t031 = to_mt9t031(client);
 	int ret;
-	u16 xbin, ybin, width, height, left, top;
+	u16 xbin, ybin;
 	const u16 hblank = MT9T031_HORIZONTAL_BLANK,
 		vblank = MT9T031_VERTICAL_BLANK;
 
-	width = rect->width * xskip;
-	height = rect->height * yskip;
-	left = rect->left * xskip;
-	top = rect->top * yskip;
-
 	xbin = min(xskip, (u16)3);
 	ybin = min(yskip, (u16)3);
 
-	dev_dbg(&icd->dev, "xskip %u, width %u/%u, yskip %u, height %u/%u\n",
-		xskip, width, rect->width, yskip, height, rect->height);
-
-	/* Could just do roundup(rect->left, [xy]bin * 2); but this is cheaper */
+	/*
+	 * Could just do roundup(rect->left, [xy]bin * 2); but this is cheaper.
+	 * There is always a valid suitably aligned value. The worst case is
+	 * xbin = 3, width = 2048. Then we will start at 36, the last read out
+	 * pixel will be 2083, which is < 2085 - first black pixel.
+	 *
+	 * MT9T031 datasheet imposes window left border alignment, depending on
+	 * the selected xskip. Failing to conform to this requirement produces
+	 * dark horizontal stripes in the image. However, even obeying to this
+	 * requirement doesn't eliminate the stripes in all configurations. They
+	 * appear "locally reproducibly," but can differ between tests under
+	 * different lighting conditions.
+	 */
 	switch (xbin) {
 	case 2:
-		left = (left + 3) & ~3;
+		rect->left = rect->left & ~3;
 		break;
 	case 3:
-		left = roundup(left, 6);
+		rect->left = rect->left > roundup(MT9T031_COLUMN_SKIP, 6) ? 
+			(rect->left / 6) * 6 : roundup(MT9T031_COLUMN_SKIP, 6);
 	}
 
-	switch (ybin) {
-	case 2:
-		top = (top + 3) & ~3;
-		break;
-	case 3:
-		top = roundup(top, 6);
-	}
+	dev_dbg(&client->dev, "skip %u:%u, rect %ux%u@%u:%u\n",
+		xskip, yskip, rect->width, rect->height, rect->left, rect->top);
 
 	/* Disable register update, reconfigure atomically */
 	ret = reg_set(client, MT9T031_OUTPUT_CONTROL, 1);
@@ -287,27 +295,29 @@ static int mt9t031_set_params(struct soc_camera_device *icd,
 			ret = reg_write(client, MT9T031_ROW_ADDRESS_MODE,
 					((ybin - 1) << 4) | (yskip - 1));
 	}
-	dev_dbg(&icd->dev, "new physical left %u, top %u\n", left, top);
+	dev_dbg(&client->dev, "new physical left %u, top %u\n",
+		rect->left, rect->top);
 
 	/* The caller provides a supported format, as guaranteed by
 	 * icd->try_fmt_cap(), soc_camera_s_crop() and soc_camera_cropcap() */
 	if (ret >= 0)
-		ret = reg_write(client, MT9T031_COLUMN_START, left);
+		ret = reg_write(client, MT9T031_COLUMN_START, rect->left);
 	if (ret >= 0)
-		ret = reg_write(client, MT9T031_ROW_START, top);
+		ret = reg_write(client, MT9T031_ROW_START, rect->top);
 	if (ret >= 0)
-		ret = reg_write(client, MT9T031_WINDOW_WIDTH, width - 1);
+		ret = reg_write(client, MT9T031_WINDOW_WIDTH, rect->width - 1);
 	if (ret >= 0)
 		ret = reg_write(client, MT9T031_WINDOW_HEIGHT,
-				height + icd->y_skip_top - 1);
+				rect->height + icd->y_skip_top - 1);
 	if (ret >= 0 && mt9t031->autoexposure) {
-		ret = set_shutter(client, height + icd->y_skip_top + vblank);
+		ret = set_shutter(client,
+				  rect->height + icd->y_skip_top + vblank);
 		if (ret >= 0) {
 			const u32 shutter_max = MT9T031_MAX_HEIGHT + vblank;
 			const struct v4l2_queryctrl *qctrl =
 				soc_camera_find_qctrl(icd->ops,
 						      V4L2_CID_EXPOSURE);
-			icd->exposure = (shutter_max / 2 + (height +
+			icd->exposure = (shutter_max / 2 + (rect->height +
 					 icd->y_skip_top + vblank - 1) *
 					 (qctrl->maximum - qctrl->minimum)) /
 				shutter_max + qctrl->minimum;
@@ -318,27 +328,69 @@ static int mt9t031_set_params(struct soc_camera_device *icd,
 	if (ret >= 0)
 		ret = reg_clear(client, MT9T031_OUTPUT_CONTROL, 1);
 
+	if (ret >= 0) {
+		mt9t031->rect = *rect;
+		mt9t031->xskip = xskip;
+		mt9t031->yskip = yskip;
+	}
+
 	return ret < 0 ? ret : 0;
 }
 
 static int mt9t031_s_crop(struct v4l2_subdev *sd, struct v4l2_crop *a)
 {
-	struct v4l2_rect *rect = &a->c;
+	struct v4l2_rect rect = a->c;
 	struct i2c_client *client = sd->priv;
 	struct mt9t031 *mt9t031 = to_mt9t031(client);
 	struct soc_camera_device *icd = client->dev.platform_data;
 
-	/* Make sure we don't exceed sensor limits */
-	if (rect->left + rect->width > icd->rect_max.left + icd->rect_max.width)
-		rect->left = icd->rect_max.width + icd->rect_max.left -
-			rect->width;
+	soc_camera_limit_side(&rect.left, &rect.width,
+		     MT9T031_COLUMN_SKIP, MT9T031_MIN_WIDTH, MT9T031_MAX_WIDTH);
+
+	soc_camera_limit_side(&rect.top, &rect.height,
+		     MT9T031_ROW_SKIP, MT9T031_MIN_HEIGHT, MT9T031_MAX_HEIGHT);
+
+	return mt9t031_set_params(icd, &rect, mt9t031->xskip, mt9t031->yskip);
+}
+
+static int mt9t031_g_crop(struct v4l2_subdev *sd, struct v4l2_crop *a)
+{
+	struct i2c_client *client = sd->priv;
+	struct mt9t031 *mt9t031 = to_mt9t031(client);
+
+	a->c	= mt9t031->rect;
+	a->type	= V4L2_BUF_TYPE_VIDEO_CAPTURE;
+
+	return 0;
+}
 
-	if (rect->top + rect->height > icd->rect_max.height + icd->rect_max.top)
-		rect->top = icd->rect_max.height + icd->rect_max.top -
-			rect->height;
+static int mt9t031_cropcap(struct v4l2_subdev *sd, struct v4l2_cropcap *a)
+{
+	a->bounds.left			= MT9T031_COLUMN_SKIP;
+	a->bounds.top			= MT9T031_ROW_SKIP;
+	a->bounds.width			= MT9T031_MAX_WIDTH;
+	a->bounds.height		= MT9T031_MAX_HEIGHT;
+	a->defrect			= a->bounds;
+	a->type				= V4L2_BUF_TYPE_VIDEO_CAPTURE;
+	a->pixelaspect.numerator	= 1;	/* What are these */
+	a->pixelaspect.denominator	= 1;	/* good for? */
 
-	/* CROP - no change in scaling, or in limits */
-	return mt9t031_set_params(icd, rect, mt9t031->xskip, mt9t031->yskip);
+	return 0;
+}
+
+static int mt9t031_g_fmt(struct v4l2_subdev *sd, struct v4l2_format *f)
+{
+	struct i2c_client *client = sd->priv;
+	struct mt9t031 *mt9t031 = to_mt9t031(client);
+	struct v4l2_pix_format *pix = &f->fmt.pix;
+
+	pix->width		= mt9t031->rect.width / mt9t031->xskip;
+	pix->height		= mt9t031->rect.height / mt9t031->yskip;
+	pix->pixelformat	= V4L2_PIX_FMT_SGRBG10;
+	pix->field		= V4L2_FIELD_NONE;
+	pix->colorspace		= V4L2_COLORSPACE_SRGB;
+
+	return 0;
 }
 
 static int mt9t031_s_fmt(struct v4l2_subdev *sd, struct v4l2_format *f)
@@ -346,55 +398,43 @@ static int mt9t031_s_fmt(struct v4l2_subdev *sd, struct v4l2_format *f)
 	struct i2c_client *client = sd->priv;
 	struct mt9t031 *mt9t031 = to_mt9t031(client);
 	struct soc_camera_device *icd = client->dev.platform_data;
-	int ret;
+	struct v4l2_pix_format *pix = &f->fmt.pix;
 	u16 xskip, yskip;
-	struct v4l2_rect rect = {
-		.left	= icd->rect_current.left,
-		.top	= icd->rect_current.top,
-		.width	= f->fmt.pix.width,
-		.height	= f->fmt.pix.height,
-	};
+	struct v4l2_rect rect = mt9t031->rect;
 
 	/*
-	 * try_fmt has put rectangle within limits.
-	 * S_FMT - use binning and skipping for scaling, recalculate
-	 * limits, used for cropping
+	 * try_fmt has put width and height within limits.
+	 * S_FMT: use binning and skipping for scaling
 	 */
-	/* Is this more optimal than just a division? */
-	for (xskip = 8; xskip > 1; xskip--)
-		if (rect.width * xskip <= MT9T031_MAX_WIDTH)
-			break;
-
-	for (yskip = 8; yskip > 1; yskip--)
-		if (rect.height * yskip <= MT9T031_MAX_HEIGHT)
-			break;
-
-	recalculate_limits(icd, xskip, yskip);
-
-	ret = mt9t031_set_params(icd, &rect, xskip, yskip);
-	if (!ret) {
-		mt9t031->xskip = xskip;
-		mt9t031->yskip = yskip;
-	}
+	xskip = mt9t031_skip(&rect.width, pix->width, MT9T031_MAX_WIDTH);
+	yskip = mt9t031_skip(&rect.height, pix->height, MT9T031_MAX_HEIGHT);
 
-	return ret;
+	/* mt9t031_set_params() doesn't change width and height */
+	return mt9t031_set_params(icd, &rect, xskip, yskip);
 }
 
+/*
+ * If a user window larger than sensor window is requested, we'll increase the
+ * sensor window.
+ */
 static int mt9t031_try_fmt(struct v4l2_subdev *sd, struct v4l2_format *f)
 {
 	struct v4l2_pix_format *pix = &f->fmt.pix;
 
-	if (pix->height < MT9T031_MIN_HEIGHT)
-		pix->height = MT9T031_MIN_HEIGHT;
-	if (pix->height > MT9T031_MAX_HEIGHT)
-		pix->height = MT9T031_MAX_HEIGHT;
+	/* This implicitly uses the fact, that our maxima and minima are even */
 	if (pix->width < MT9T031_MIN_WIDTH)
 		pix->width = MT9T031_MIN_WIDTH;
-	if (pix->width > MT9T031_MAX_WIDTH)
+	else if (pix->width > MT9T031_MAX_WIDTH)
 		pix->width = MT9T031_MAX_WIDTH;
+	else
+		pix->width &= ~0x01; /* has to be even */
 
-	pix->width &= ~0x01; /* has to be even */
-	pix->height &= ~0x01; /* has to be even */
+	if (pix->height < MT9T031_MIN_HEIGHT)
+		pix->height = MT9T031_MIN_HEIGHT;
+	else if (pix->height > MT9T031_MAX_HEIGHT)
+		pix->height = MT9T031_MAX_HEIGHT;
+	else
+		pix->height &= ~0x01; /* has to be even */
 
 	return 0;
 }
@@ -575,7 +615,7 @@ static int mt9t031_s_ctrl(struct v4l2_subdev *sd, struct v4l2_control *ctrl)
 			unsigned long range = qctrl->default_value - qctrl->minimum;
 			data = ((ctrl->value - qctrl->minimum) * 8 + range / 2) / range;
 
-			dev_dbg(&icd->dev, "Setting gain %d\n", data);
+			dev_dbg(&client->dev, "Setting gain %d\n", data);
 			data = reg_write(client, MT9T031_GLOBAL_GAIN, data);
 			if (data < 0)
 				return -EIO;
@@ -595,7 +635,7 @@ static int mt9t031_s_ctrl(struct v4l2_subdev *sd, struct v4l2_control *ctrl)
 				/* calculated gain 65..1024 -> (1..120) << 8 + 0x60 */
 				data = (((gain - 64 + 7) * 32) & 0xff00) | 0x60;
 
-			dev_dbg(&icd->dev, "Setting gain from 0x%x to 0x%x\n",
+			dev_dbg(&client->dev, "Setting gain from 0x%x to 0x%x\n",
 				reg_read(client, MT9T031_GLOBAL_GAIN), data);
 			data = reg_write(client, MT9T031_GLOBAL_GAIN, data);
 			if (data < 0)
@@ -616,7 +656,7 @@ static int mt9t031_s_ctrl(struct v4l2_subdev *sd, struct v4l2_control *ctrl)
 			u32 old;
 
 			get_shutter(client, &old);
-			dev_dbg(&icd->dev, "Setting shutter width from %u to %u\n",
+			dev_dbg(&client->dev, "Setting shutter width from %u to %u\n",
 				old, shutter);
 			if (set_shutter(client, shutter) < 0)
 				return -EIO;
@@ -628,12 +668,12 @@ static int mt9t031_s_ctrl(struct v4l2_subdev *sd, struct v4l2_control *ctrl)
 		if (ctrl->value) {
 			const u16 vblank = MT9T031_VERTICAL_BLANK;
 			const u32 shutter_max = MT9T031_MAX_HEIGHT + vblank;
-			if (set_shutter(client, icd->rect_current.height +
+			if (set_shutter(client, mt9t031->rect.height +
 					icd->y_skip_top + vblank) < 0)
 				return -EIO;
 			qctrl = soc_camera_find_qctrl(icd->ops, V4L2_CID_EXPOSURE);
 			icd->exposure = (shutter_max / 2 +
-					 (icd->rect_current.height +
+					 (mt9t031->rect.height +
 					  icd->y_skip_top + vblank - 1) *
 					 (qctrl->maximum - qctrl->minimum)) /
 				shutter_max + qctrl->minimum;
@@ -653,15 +693,9 @@ static int mt9t031_video_probe(struct i2c_client *client)
 	struct mt9t031 *mt9t031 = to_mt9t031(client);
 	s32 data;
 
-	/* We must have a parent by now. And it cannot be a wrong one.
-	 * So this entire test is completely redundant. */
-	if (!icd->dev.parent ||
-	    to_soc_camera_host(icd->dev.parent)->nr != icd->iface)
-		return -ENODEV;
-
 	/* Enable the chip */
 	data = reg_write(client, MT9T031_CHIP_ENABLE, 1);
-	dev_dbg(&icd->dev, "write: %d\n", data);
+	dev_dbg(&client->dev, "write: %d\n", data);
 
 	/* Read out the chip version register */
 	data = reg_read(client, MT9T031_CHIP_VERSION);
@@ -673,12 +707,12 @@ static int mt9t031_video_probe(struct i2c_client *client)
 		icd->num_formats = ARRAY_SIZE(mt9t031_colour_formats);
 		break;
 	default:
-		dev_err(&icd->dev,
+		dev_err(&client->dev,
 			"No MT9T031 chip detected, register read %x\n", data);
 		return -ENODEV;
 	}
 
-	dev_info(&icd->dev, "Detected a MT9T031 chip ID %x\n", data);
+	dev_info(&client->dev, "Detected a MT9T031 chip ID %x\n", data);
 
 	return 0;
 }
@@ -696,8 +730,11 @@ static struct v4l2_subdev_core_ops mt9t031_subdev_core_ops = {
 static struct v4l2_subdev_video_ops mt9t031_subdev_video_ops = {
 	.s_stream	= mt9t031_s_stream,
 	.s_fmt		= mt9t031_s_fmt,
+	.g_fmt		= mt9t031_g_fmt,
 	.try_fmt	= mt9t031_try_fmt,
 	.s_crop		= mt9t031_s_crop,
+	.g_crop		= mt9t031_g_crop,
+	.cropcap	= mt9t031_cropcap,
 };
 
 static struct v4l2_subdev_ops mt9t031_subdev_ops = {
@@ -739,15 +776,13 @@ static int mt9t031_probe(struct i2c_client *client,
 
 	/* Second stage probe - when a capture adapter is there */
 	icd->ops		= &mt9t031_ops;
-	icd->rect_max.left	= MT9T031_COLUMN_SKIP;
-	icd->rect_max.top	= MT9T031_ROW_SKIP;
-	icd->rect_current.left	= icd->rect_max.left;
-	icd->rect_current.top	= icd->rect_max.top;
-	icd->width_min		= MT9T031_MIN_WIDTH;
-	icd->rect_max.width	= MT9T031_MAX_WIDTH;
-	icd->height_min		= MT9T031_MIN_HEIGHT;
-	icd->rect_max.height	= MT9T031_MAX_HEIGHT;
 	icd->y_skip_top		= 0;
+
+	mt9t031->rect.left	= MT9T031_COLUMN_SKIP;
+	mt9t031->rect.top	= MT9T031_ROW_SKIP;
+	mt9t031->rect.width	= MT9T031_MAX_WIDTH;
+	mt9t031->rect.height	= MT9T031_MAX_HEIGHT;
+
 	/* Simulated autoexposure. If enabled, we calculate shutter width
 	 * ourselves in the driver based on vertical blanking and frame width */
 	mt9t031->autoexposure = 1;
diff --git a/drivers/media/video/mx3_camera.c b/drivers/media/video/mx3_camera.c
index 157aed9..c8cac3a 100644
--- a/drivers/media/video/mx3_camera.c
+++ b/drivers/media/video/mx3_camera.c
@@ -59,6 +59,9 @@
 
 #define MAX_VIDEO_MEM 16
 
+#define pixfmtstr(x) (x) & 0xff, ((x) >> 8) & 0xff, ((x) >> 16) & 0xff, \
+	((x) >> 24) & 0xff
+
 struct mx3_camera_buffer {
 	/* common v4l buffer stuff -- must be first */
 	struct videobuf_buffer			vb;
@@ -220,7 +223,7 @@ static int mx3_videobuf_setup(struct videobuf_queue *vq, unsigned int *count,
 	if (!mx3_cam->idmac_channel[0])
 		return -EINVAL;
 
-	*size = icd->rect_current.width * icd->rect_current.height * bpp;
+	*size = icd->user_width * icd->user_height * bpp;
 
 	if (!*count)
 		*count = 32;
@@ -241,7 +244,7 @@ static int mx3_videobuf_prepare(struct videobuf_queue *vq,
 	struct mx3_camera_buffer *buf =
 		container_of(vb, struct mx3_camera_buffer, vb);
 	/* current_fmt _must_ always be set */
-	size_t new_size = icd->rect_current.width * icd->rect_current.height *
+	size_t new_size = icd->user_width * icd->user_height *
 		((icd->current_fmt->depth + 7) >> 3);
 	int ret;
 
@@ -251,12 +254,12 @@ static int mx3_videobuf_prepare(struct videobuf_queue *vq,
 	 */
 
 	if (buf->fmt	!= icd->current_fmt ||
-	    vb->width	!= icd->rect_current.width ||
-	    vb->height	!= icd->rect_current.height ||
+	    vb->width	!= icd->user_width ||
+	    vb->height	!= icd->user_height ||
 	    vb->field	!= field) {
 		buf->fmt	= icd->current_fmt;
-		vb->width	= icd->rect_current.width;
-		vb->height	= icd->rect_current.height;
+		vb->width	= icd->user_width;
+		vb->height	= icd->user_height;
 		vb->field	= field;
 		if (vb->state != VIDEOBUF_NEEDS_INIT)
 			free_buffer(vq, buf);
@@ -350,9 +353,9 @@ static void mx3_videobuf_queue(struct videobuf_queue *vq,
 
 	/* This is the configuration of one sg-element */
 	video->out_pixel_fmt	= fourcc_to_ipu_pix(data_fmt->fourcc);
-	video->out_width	= icd->rect_current.width;
-	video->out_height	= icd->rect_current.height;
-	video->out_stride	= icd->rect_current.width;
+	video->out_width	= icd->user_width;
+	video->out_height	= icd->user_height;
+	video->out_stride	= icd->user_width;
 
 #ifdef DEBUG
 	/* helps to see what DMA actually has written */
@@ -538,7 +541,7 @@ static bool channel_change_requested(struct soc_camera_device *icd,
 
 	/* Do buffers have to be re-allocated or channel re-configured? */
 	return ichan && rect->width * rect->height >
-		icd->rect_current.width * icd->rect_current.height;
+		icd->user_width * icd->user_height;
 }
 
 static int test_platform_param(struct mx3_camera_dev *mx3_cam,
@@ -586,7 +589,7 @@ static int test_platform_param(struct mx3_camera_dev *mx3_cam,
 		*flags |= SOCAM_DATAWIDTH_4;
 		break;
 	default:
-		dev_info(mx3_cam->soc_host.v4l2_dev.dev, "Unsupported bus width %d\n",
+		dev_warn(mx3_cam->soc_host.v4l2_dev.dev, "Unsupported bus width %d\n",
 			 buswidth);
 		return -EINVAL;
 	}
@@ -720,13 +723,13 @@ passthrough:
 }
 
 static void configure_geometry(struct mx3_camera_dev *mx3_cam,
-			       struct v4l2_rect *rect)
+			       unsigned int width, unsigned int height)
 {
 	u32 ctrl, width_field, height_field;
 
 	/* Setup frame size - this cannot be changed on-the-fly... */
-	width_field = rect->width - 1;
-	height_field = rect->height - 1;
+	width_field = width - 1;
+	height_field = height - 1;
 	csi_reg_write(mx3_cam, width_field | (height_field << 16), CSI_SENS_FRM_SIZE);
 
 	csi_reg_write(mx3_cam, width_field << 16, CSI_FLASH_STROBE_1);
@@ -738,11 +741,6 @@ static void configure_geometry(struct mx3_camera_dev *mx3_cam,
 	ctrl = csi_reg_read(mx3_cam, CSI_OUT_FRM_CTRL) & 0xffff0000;
 	/* Sensor does the cropping */
 	csi_reg_write(mx3_cam, ctrl | 0 | (0 << 8), CSI_OUT_FRM_CTRL);
-
-	/*
-	 * No need to free resources here if we fail, we'll see if we need to
-	 * do this next time we are called
-	 */
 }
 
 static int acquire_dma_channel(struct mx3_camera_dev *mx3_cam)
@@ -779,6 +777,22 @@ static int acquire_dma_channel(struct mx3_camera_dev *mx3_cam)
 	return 0;
 }
 
+/*
+ * FIXME: learn to use stride != width, then we can keep stride properly aligned
+ * and support arbitrary (even) widths.
+ */
+static inline void stride_align(__s32 *width)
+{
+	if (((*width + 7) &  ~7) < 4096)
+		*width = (*width + 7) &  ~7;
+	else
+		*width = *width &  ~7;
+}
+
+/*
+ * As long as we don't implement host-side cropping and scaling, we can use
+ * default g_crop and cropcap from soc_camera.c
+ */
 static int mx3_camera_set_crop(struct soc_camera_device *icd,
 			       struct v4l2_crop *a)
 {
@@ -786,20 +800,51 @@ static int mx3_camera_set_crop(struct soc_camera_device *icd,
 	struct soc_camera_host *ici = to_soc_camera_host(icd->dev.parent);
 	struct mx3_camera_dev *mx3_cam = ici->priv;
 	struct v4l2_subdev *sd = soc_camera_to_subdev(icd);
+	struct v4l2_format f = {.type = V4L2_BUF_TYPE_VIDEO_CAPTURE};
+	struct v4l2_pix_format *pix = &f.fmt.pix;
+	int ret;
 
-	/*
-	 * We now know pixel formats and can decide upon DMA-channel(s)
-	 * So far only direct camera-to-memory is supported
-	 */
-	if (channel_change_requested(icd, rect)) {
-		int ret = acquire_dma_channel(mx3_cam);
+	soc_camera_limit_side(&rect->left, &rect->width, 0, 2, 4096);
+	soc_camera_limit_side(&rect->top, &rect->height, 0, 2, 4096);
+
+	ret = v4l2_subdev_call(sd, video, s_crop, a);
+	if (ret < 0)
+		return ret;
+
+	/* The capture device might have changed its output  */
+	ret = v4l2_subdev_call(sd, video, g_fmt, &f);
+	if (ret < 0)
+		return ret;
+
+	if (pix->width & 7) {
+		/* Ouch! We can only handle 8-byte aligned width... */
+		stride_align(&pix->width);
+		ret = v4l2_subdev_call(sd, video, s_fmt, &f);
 		if (ret < 0)
 			return ret;
 	}
 
-	configure_geometry(mx3_cam, rect);
+	if (pix->width != icd->user_width || pix->height != icd->user_height) {
+		/*
+		 * We now know pixel formats and can decide upon DMA-channel(s)
+		 * So far only direct camera-to-memory is supported
+		 */
+		if (channel_change_requested(icd, rect)) {
+			int ret = acquire_dma_channel(mx3_cam);
+			if (ret < 0)
+				return ret;
+		}
+
+		configure_geometry(mx3_cam, pix->width, pix->height);
+	}
+
+	dev_dbg(&icd->dev, "Sensor cropped for %c%c%c%c %dx%d\n",
+		pixfmtstr(pix->pixelformat), pix->width, pix->height);
 
-	return v4l2_subdev_call(sd, video, s_crop, a);
+	icd->user_width = pix->width;
+	icd->user_height = pix->height;
+
+	return ret;
 }
 
 static int mx3_camera_set_fmt(struct soc_camera_device *icd,
@@ -810,12 +855,6 @@ static int mx3_camera_set_fmt(struct soc_camera_device *icd,
 	struct v4l2_subdev *sd = soc_camera_to_subdev(icd);
 	const struct soc_camera_format_xlate *xlate;
 	struct v4l2_pix_format *pix = &f->fmt.pix;
-	struct v4l2_rect rect = {
-		.left	= icd->rect_current.left,
-		.top	= icd->rect_current.top,
-		.width	= pix->width,
-		.height	= pix->height,
-	};
 	int ret;
 
 	xlate = soc_camera_xlate_by_fourcc(icd, pix->pixelformat);
@@ -824,6 +863,10 @@ static int mx3_camera_set_fmt(struct soc_camera_device *icd,
 		return -EINVAL;
 	}
 
+	stride_align(&pix->width);
+	dev_dbg(&icd->dev, "Configure for %c%c%c%c %dx%d\n",
+		pixfmtstr(xlate->host_fmt->fourcc), pix->width, pix->height);
+
 	ret = acquire_dma_channel(mx3_cam);
 	if (ret < 0)
 		return ret;
@@ -834,7 +877,7 @@ static int mx3_camera_set_fmt(struct soc_camera_device *icd,
 	 * mxc_v4l2_s_fmt()
 	 */
 
-	configure_geometry(mx3_cam, &rect);
+	configure_geometry(mx3_cam, pix->width, pix->height);
 
 	ret = v4l2_subdev_call(sd, video, s_fmt, f);
 	if (!ret) {
@@ -842,6 +885,9 @@ static int mx3_camera_set_fmt(struct soc_camera_device *icd,
 		icd->current_fmt = xlate->host_fmt;
 	}
 
+	dev_dbg(&icd->dev, "Sensor configured for %c%c%c%c %dx%d\n",
+		pixfmtstr(pix->pixelformat), pix->width, pix->height);
+
 	return ret;
 }
 
diff --git a/drivers/media/video/soc_camera.c b/drivers/media/video/soc_camera.c
index 37e5a10..8bddd34 100644
--- a/drivers/media/video/soc_camera.c
+++ b/drivers/media/video/soc_camera.c
@@ -302,17 +302,17 @@ static int soc_camera_set_fmt(struct soc_camera_file *icf,
 		return -EINVAL;
 	}
 
-	icd->rect_current.width		= pix->width;
-	icd->rect_current.height	= pix->height;
-	icf->vb_vidq.field		=
-		icd->field		= pix->field;
+	icd->user_width		= pix->width;
+	icd->user_height	= pix->height;
+	icf->vb_vidq.field	=
+		icd->field	= pix->field;
 
 	if (f->type != V4L2_BUF_TYPE_VIDEO_CAPTURE)
 		dev_warn(&icd->dev, "Attention! Wrong buf-type %d\n",
 			 f->type);
 
 	dev_dbg(&icd->dev, "set width: %d height: %d\n",
-		icd->rect_current.width, icd->rect_current.height);
+		icd->user_width, icd->user_height);
 
 	/* set physical bus parameters */
 	return ici->ops->set_bus_param(icd, pix->pixelformat);
@@ -355,8 +355,8 @@ static int soc_camera_open(struct file *file)
 		struct v4l2_format f = {
 			.type = V4L2_BUF_TYPE_VIDEO_CAPTURE,
 			.fmt.pix = {
-				.width		= icd->rect_current.width,
-				.height		= icd->rect_current.height,
+				.width		= icd->user_width,
+				.height		= icd->user_height,
 				.field		= icd->field,
 				.pixelformat	= icd->current_fmt->fourcc,
 				.colorspace	= icd->current_fmt->colorspace,
@@ -559,8 +559,8 @@ static int soc_camera_g_fmt_vid_cap(struct file *file, void *priv,
 
 	WARN_ON(priv != file->private_data);
 
-	pix->width		= icd->rect_current.width;
-	pix->height		= icd->rect_current.height;
+	pix->width		= icd->user_width;
+	pix->height		= icd->user_height;
 	pix->field		= icf->vb_vidq.field;
 	pix->pixelformat	= icd->current_fmt->fourcc;
 	pix->bytesperline	= pix->width *
@@ -724,17 +724,9 @@ static int soc_camera_cropcap(struct file *file, void *fh,
 {
 	struct soc_camera_file *icf = file->private_data;
 	struct soc_camera_device *icd = icf->icd;
+	struct soc_camera_host *ici = to_soc_camera_host(icd->dev.parent);
 
-	a->type				= V4L2_BUF_TYPE_VIDEO_CAPTURE;
-	a->bounds			= icd->rect_max;
-	a->defrect.left			= icd->rect_max.left;
-	a->defrect.top			= icd->rect_max.top;
-	a->defrect.width		= DEFAULT_WIDTH;
-	a->defrect.height		= DEFAULT_HEIGHT;
-	a->pixelaspect.numerator	= 1;
-	a->pixelaspect.denominator	= 1;
-
-	return 0;
+	return ici->ops->cropcap(icd, a);
 }
 
 static int soc_camera_g_crop(struct file *file, void *fh,
@@ -742,11 +734,14 @@ static int soc_camera_g_crop(struct file *file, void *fh,
 {
 	struct soc_camera_file *icf = file->private_data;
 	struct soc_camera_device *icd = icf->icd;
+	struct soc_camera_host *ici = to_soc_camera_host(icd->dev.parent);
+	int ret;
 
-	a->type	= V4L2_BUF_TYPE_VIDEO_CAPTURE;
-	a->c	= icd->rect_current;
+	mutex_lock(&icf->vb_vidq.vb_lock);
+	ret = ici->ops->get_crop(icd, a);
+	mutex_unlock(&icf->vb_vidq.vb_lock);
 
-	return 0;
+	return ret;
 }
 
 /*
@@ -761,7 +756,7 @@ static int soc_camera_s_crop(struct file *file, void *fh,
 	struct soc_camera_file *icf = file->private_data;
 	struct soc_camera_device *icd = icf->icd;
 	struct soc_camera_host *ici = to_soc_camera_host(icd->dev.parent);
-	struct v4l2_rect rect = a->c;
+	struct v4l2_crop current_crop;
 	int ret;
 
 	if (a->type != V4L2_BUF_TYPE_VIDEO_CAPTURE)
@@ -770,38 +765,20 @@ static int soc_camera_s_crop(struct file *file, void *fh,
 	/* Cropping is allowed during a running capture, guard consistency */
 	mutex_lock(&icf->vb_vidq.vb_lock);
 
+	/* If get_crop fails, we'll let host and / or client drivers decide */
+	ret = ici->ops->get_crop(icd, &current_crop);
+
 	/* Prohibit window size change with initialised buffers */
-	if (icf->vb_vidq.bufs[0] && (rect.width != icd->rect_current.width ||
-				     rect.height != icd->rect_current.height)) {
+	if (icf->vb_vidq.bufs[0] && !ret &&
+	    (a->c.width != current_crop.c.width ||
+	     a->c.height != current_crop.c.height)) {
 		dev_err(&icd->dev,
 			"S_CROP denied: queue initialised and sizes differ\n");
 		ret = -EBUSY;
 		goto unlock;
 	}
 
-	if (rect.width > icd->rect_max.width)
-		rect.width = icd->rect_max.width;
-
-	if (rect.width < icd->width_min)
-		rect.width = icd->width_min;
-
-	if (rect.height > icd->rect_max.height)
-		rect.height = icd->rect_max.height;
-
-	if (rect.height < icd->height_min)
-		rect.height = icd->height_min;
-
-	if (rect.width + rect.left > icd->rect_max.width + icd->rect_max.left)
-		rect.left = icd->rect_max.width + icd->rect_max.left -
-			rect.width;
-
-	if (rect.height + rect.top > icd->rect_max.height + icd->rect_max.top)
-		rect.top = icd->rect_max.height + icd->rect_max.top -
-			rect.height;
-
 	ret = ici->ops->set_crop(icd, a);
-	if (!ret)
-		icd->rect_current = rect;
 
 unlock:
 	mutex_unlock(&icf->vb_vidq.vb_lock);
@@ -928,6 +905,8 @@ static int soc_camera_probe(struct device *dev)
 	struct soc_camera_host *ici = to_soc_camera_host(dev->parent);
 	struct soc_camera_link *icl = to_soc_camera_link(icd);
 	struct device *control = NULL;
+	struct v4l2_subdev *sd;
+	struct v4l2_format f = {.type = V4L2_BUF_TYPE_VIDEO_CAPTURE};
 	int ret;
 
 	dev_info(dev, "Probing %s\n", dev_name(dev));
@@ -984,7 +963,6 @@ static int soc_camera_probe(struct device *dev)
 	if (ret < 0)
 		goto eiufmt;
 
-	icd->rect_current = icd->rect_max;
 	icd->field = V4L2_FIELD_ANY;
 
 	/* ..._video_start() will create a device node, so we have to protect */
@@ -994,9 +972,15 @@ static int soc_camera_probe(struct device *dev)
 	if (ret < 0)
 		goto evidstart;
 
+	/* Try to improve our guess of a reasonable window format */
+	sd = soc_camera_to_subdev(icd);
+	if (!v4l2_subdev_call(sd, video, g_fmt, &f)) {
+		icd->user_width		= f.fmt.pix.width;
+		icd->user_height	= f.fmt.pix.height;
+	}
+
 	/* Do we have to sysfs_remove_link() before device_unregister()? */
-	if (to_soc_camera_control(icd) &&
-	    sysfs_create_link(&icd->dev.kobj, &to_soc_camera_control(icd)->kobj,
+	if (sysfs_create_link(&icd->dev.kobj, &to_soc_camera_control(icd)->kobj,
 			      "control"))
 		dev_warn(&icd->dev, "Failed creating the control symlink\n");
 
@@ -1105,6 +1089,24 @@ static void dummy_release(struct device *dev)
 {
 }
 
+static int default_cropcap(struct soc_camera_device *icd, struct v4l2_cropcap *a)
+{
+	struct v4l2_subdev *sd = soc_camera_to_subdev(icd);
+	return v4l2_subdev_call(sd, video, cropcap, a);
+}
+
+static int default_g_crop(struct soc_camera_device *icd, struct v4l2_crop *a)
+{
+	struct v4l2_subdev *sd = soc_camera_to_subdev(icd);
+	return v4l2_subdev_call(sd, video, g_crop, a);
+}
+
+static int default_s_crop(struct soc_camera_device *icd, struct v4l2_crop *a)
+{
+	struct v4l2_subdev *sd = soc_camera_to_subdev(icd);
+	return v4l2_subdev_call(sd, video, s_crop, a);
+}
+
 int soc_camera_host_register(struct soc_camera_host *ici)
 {
 	struct soc_camera_host *ix;
@@ -1113,7 +1115,6 @@ int soc_camera_host_register(struct soc_camera_host *ici)
 	if (!ici || !ici->ops ||
 	    !ici->ops->try_fmt ||
 	    !ici->ops->set_fmt ||
-	    !ici->ops->set_crop ||
 	    !ici->ops->set_bus_param ||
 	    !ici->ops->querycap ||
 	    !ici->ops->init_videobuf ||
@@ -1124,6 +1125,13 @@ int soc_camera_host_register(struct soc_camera_host *ici)
 	    !ici->v4l2_dev.dev)
 		return -EINVAL;
 
+	if (!ici->ops->set_crop)
+		ici->ops->set_crop = default_s_crop;
+	if (!ici->ops->get_crop)
+		ici->ops->get_crop = default_g_crop;
+	if (!ici->ops->cropcap)
+		ici->ops->cropcap = default_cropcap;
+
 	mutex_lock(&list_lock);
 	list_for_each_entry(ix, &hosts, list) {
 		if (ix->nr == ici->nr) {
@@ -1323,6 +1331,9 @@ static int __devinit soc_camera_pdrv_probe(struct platform_device *pdev)
 	if (ret < 0)
 		goto escdevreg;
 
+	icd->user_width		= DEFAULT_WIDTH;
+	icd->user_height	= DEFAULT_HEIGHT;
+
 	return 0;
 
 escdevreg:
diff --git a/include/media/soc_camera.h b/include/media/soc_camera.h
index 344d899..cbd6654 100644
--- a/include/media/soc_camera.h
+++ b/include/media/soc_camera.h
@@ -22,8 +22,8 @@ struct soc_camera_device {
 	struct list_head list;
 	struct device dev;
 	struct device *pdev;		/* Platform device */
-	struct v4l2_rect rect_current;	/* Current window */
-	struct v4l2_rect rect_max;	/* Maximum window */
+	s32 user_width;
+	s32 user_height;
 	unsigned short width_min;
 	unsigned short height_min;
 	unsigned short y_skip_top;	/* Lines to skip at the top */
@@ -76,6 +76,8 @@ struct soc_camera_host_ops {
 	int (*get_formats)(struct soc_camera_device *, int,
 			   struct soc_camera_format_xlate *);
 	void (*put_formats)(struct soc_camera_device *);
+	int (*cropcap)(struct soc_camera_device *, struct v4l2_cropcap *);
+	int (*get_crop)(struct soc_camera_device *, struct v4l2_crop *);
 	int (*set_crop)(struct soc_camera_device *, struct v4l2_crop *);
 	int (*set_fmt)(struct soc_camera_device *, struct v4l2_format *);
 	int (*try_fmt)(struct soc_camera_device *, struct v4l2_format *);
@@ -277,6 +279,21 @@ static inline unsigned long soc_camera_bus_param_compatible(
 		common_flags;
 }
 
+static inline void soc_camera_limit_side(unsigned int *start,
+		unsigned int *length, unsigned int start_min,
+		unsigned int length_min, unsigned int length_max)
+{
+	if (*length < length_min)
+		*length = length_min;
+	else if (*length > length_max)
+		*length = length_max;
+
+	if (*start < start_min)
+		*start = start_min;
+	else if (*start + *length > start_min + length_max)
+		*start = start_min + length_max - *length;
+}
+
 extern unsigned long soc_camera_apply_sensor_flags(struct soc_camera_link *icl,
 						   unsigned long flags);
 
