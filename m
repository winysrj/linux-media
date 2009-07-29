Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:53022 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753576AbZG2PSi (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 29 Jul 2009 11:18:38 -0400
Date: Wed, 29 Jul 2009 17:18:43 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
cc: Magnus Damm <magnus.damm@gmail.com>, m-karicheri2@ti.com,
	Valentin Longchamp <valentin.longchamp@epfl.ch>,
	Robert Jarzmik <robert.jarzmik@free.fr>,
	Paulius Zaleckas <paulius.zaleckas@teltonika.lt>,
	Darius Augulis <augulis.darius@gmail.com>
Subject: [PATCH 4/4] soc-camera: V4L2 API compliant scaling (S_FMT) and
 cropping (S_CROP)
In-Reply-To: <Pine.LNX.4.64.0907291640010.4983@axis700.grange>
Message-ID: <Pine.LNX.4.64.0907291713590.4983@axis700.grange>
References: <Pine.LNX.4.64.0907291640010.4983@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The initial soc-camera scaling and cropping implementation turned out to be
incompliant with the V4L2 API, e.g., it expected the user to specify cropping
in output window pixels, instead of input window pixels. This patch converts
the soc-camera core and all drivers to comply with the standard.

Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
---
 Documentation/video4linux/sh_mobile_ceu_camera.txt |  157 ++++
 Documentation/video4linux/soc-camera.txt           |   40 +
 drivers/media/video/mt9m001.c                      |  153 +++-
 drivers/media/video/mt9m111.c                      |  113 +++-
 drivers/media/video/mt9t031.c                      |  237 ++++---
 drivers/media/video/mt9v022.c                      |  144 +++-
 drivers/media/video/mx1_camera.c                   |   10 +-
 drivers/media/video/mx3_camera.c                   |  114 ++-
 drivers/media/video/ov772x.c                       |   84 ++-
 drivers/media/video/pxa_camera.c                   |  217 ++++--
 drivers/media/video/sh_mobile_ceu_camera.c         |  835 ++++++++++++++------
 drivers/media/video/soc_camera.c                   |  130 ++--
 drivers/media/video/soc_camera_platform.c          |    4 -
 drivers/media/video/tw9910.c                       |  120 ++-
 include/media/soc_camera.h                         |   21 +-
 15 files changed, 1724 insertions(+), 655 deletions(-)
 create mode 100644 Documentation/video4linux/sh_mobile_ceu_camera.txt

diff --git a/Documentation/video4linux/sh_mobile_ceu_camera.txt b/Documentation/video4linux/sh_mobile_ceu_camera.txt
new file mode 100644
index 0000000..2ae1634
--- /dev/null
+++ b/Documentation/video4linux/sh_mobile_ceu_camera.txt
@@ -0,0 +1,157 @@
+	Cropping and Scaling algorithm, used in the sh_mobile_ceu_camera driver
+	=======================================================================
+
+Terminology
+-----------
+
+sensor scales: horizontal and vertical scales, configured by the sensor driver
+host scales: -"- host driver
+combined scales: sensor_scale * host_scale
+
+
+Generic scaling / cropping scheme
+---------------------------------
+
+-1--
+|
+-2-- -\
+|      --\
+|         --\
++-5-- -\     -- -3--
+|       ---\
+|           --- -4-- -\
+|                      -\
+|                        - -6--
+|
+|                        - -6'-
+|                      -/
+|           --- -4'- -/
+|       ---/
++-5'- -/
+|            -- -3'-
+|         --/
+|      --/
+-2'- -/
+|
+|
+-1'-
+
+Produced by user requests:
+
+S_CROP(left / top = (5) - (1), width / height = (5') - (5))
+S_FMT(width / height = (6') - (6))
+
+Here:
+
+(1) to (1') - whole max width or height
+(1) to (2)  - sensor cropped left or top
+(2) to (2') - sensor cropped width or height
+(3) to (3') - sensor scale
+(3) to (4)  - CEU cropped left or top
+(4) to (4') - CEU cropped width or height
+(5) to (5') - reverse sensor scale applied to CEU cropped width or height
+(2) to (5)  - reverse sensor scale applied to CEU cropped left or top
+(6) to (6') - CEU scale - user window
+
+
+S_FMT
+-----
+
+Do not touch input rectangle - it is already optimal.
+
+1. Calculate current sensor scales:
+
+	scale_s = ((3') - (3)) / ((2') - (2))
+
+2. Calculate "effective" input crop (sensor subwindow) - CEU crop scaled back at
+current sensor scales onto input window - this is user S_CROP:
+
+	width_u = (5') - (5) = ((4') - (4)) * scale_s
+
+3. Calculate new combined scales from "effective" input window to requested user
+window:
+
+	scale_comb = width_u / ((6') - (6))
+
+4. Calculate sensor output window by applying combined scales to real input
+window:
+
+	width_s_out = ((2') - (2)) / scale_comb
+
+5. Apply iterative sensor S_FMT for sensor output window.
+
+	subdev->video_ops->s_fmt(.width = width_s_out)
+
+6. Retrieve sensor output window (g_fmt)
+
+7. Calculate new sensor scales:
+
+	scale_s_new = ((3')_new - (3)_new) / ((2') - (2))
+
+8. Calculate new CEU crop - apply sensor scales to previously calculated
+"effective" crop:
+
+	width_ceu = (4')_new - (4)_new = width_u / scale_s_new
+	left_ceu = (4)_new - (3)_new = ((5) - (2)) / scale_s_new
+
+9. Use CEU cropping to crop to the new window:
+
+	ceu_crop(.width = width_ceu, .left = left_ceu)
+
+10. Use CEU scaling to scale to the requested user window:
+
+	scale_ceu = width_ceu / width
+
+
+S_CROP
+------
+
+If old scale applied to new crop is invalid produce nearest new scale possible
+
+1. Calculate current combined scales.
+
+	scale_comb = (((4') - (4)) / ((6') - (6))) * (((2') - (2)) / ((3') - (3)))
+
+2. Apply iterative sensor S_CROP for new input window.
+
+3. If old combined scales applied to new crop produce an impossible user window,
+adjust scales to produce nearest possible window.
+
+	width_u_out = ((5') - (5)) / scale_comb
+
+	if (width_u_out > max)
+		scale_comb = ((5') - (5)) / max;
+	else if (width_u_out < min)
+		scale_comb = ((5') - (5)) / min;
+
+4. Issue G_CROP to retrieve actual input window.
+
+5. Using actual input window and calculated combined scales calculate sensor
+target output window.
+
+	width_s_out = ((3') - (3)) = ((2') - (2)) / scale_comb
+
+6. Apply iterative S_FMT for new sensor target output window.
+
+7. Issue G_FMT to retrieve the actual sensor output window.
+
+8. Calculate sensor scales.
+
+	scale_s = ((3') - (3)) / ((2') - (2))
+
+9. Calculate sensor output subwindow to be cropped on CEU by applying sensor
+scales to the requested window.
+
+	width_ceu = ((5') - (5)) / scale_s
+
+10. Use CEU cropping for above calculated window.
+
+11. Calculate CEU scales from sensor scales from results of (10) and user window
+from (3)
+
+	scale_ceu = calc_scale(((5') - (5)), &width_u_out)
+
+12. Apply CEU scales.
+
+--
+Author: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
diff --git a/Documentation/video4linux/soc-camera.txt b/Documentation/video4linux/soc-camera.txt
index 178ef3c..3f87c7d 100644
--- a/Documentation/video4linux/soc-camera.txt
+++ b/Documentation/video4linux/soc-camera.txt
@@ -116,5 +116,45 @@ functionality.
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
+factors have to be maintained by camera drivers internally. According to the
+V4L2 API all capture drivers must support the VIDIOC_CROPCAP ioctl, hence we
+rely on camera drivers implementing .cropcap(). If the camera driver does not
+support cropping, it may choose to not implement .s_crop(), but to enable
+cropping support by the camera host driver at least the .g_crop method must be
+implemented.
+
+User window geometry is kept in .user_width and .user_height fields in struct
+soc_camera_device and used by the soc-camera core and host drivers. The core
+updates these fields upon successful completion of a .s_fmt() call, but if these
+fields change elsewhere, e.g., during .s_crop() processing, the host driver is
+responsible for updating them.
+
 --
 Author: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
diff --git a/drivers/media/video/mt9m001.c b/drivers/media/video/mt9m001.c
index 1e7c469..cf9e44f 100644
--- a/drivers/media/video/mt9m001.c
+++ b/drivers/media/video/mt9m001.c
@@ -39,6 +39,13 @@
 #define MT9M001_GLOBAL_GAIN		0x35
 #define MT9M001_CHIP_ENABLE		0xF1
 
+#define MT9M001_MAX_WIDTH		1280
+#define MT9M001_MAX_HEIGHT		1024
+#define MT9M001_MIN_WIDTH		48
+#define MT9M001_MIN_HEIGHT		32
+#define MT9M001_COLUMN_SKIP		20
+#define MT9M001_ROW_SKIP		12
+
 static const struct soc_camera_data_format mt9m001_colour_formats[] = {
 	/* Order important: first natively supported,
 	 * second supported with a GPIO extender */
@@ -70,6 +77,8 @@ static const struct soc_camera_data_format mt9m001_monochrome_formats[] = {
 
 struct mt9m001 {
 	struct v4l2_subdev subdev;
+	struct v4l2_rect rect;	/* Sensor window */
+	__u32 fourcc;
 	int model;	/* V4L2_IDENT_MT9M001* codes from v4l2-chip-ident.h */
 	unsigned char autoexposure;
 };
@@ -196,13 +205,31 @@ static unsigned long mt9m001_query_bus_param(struct soc_camera_device *icd)
 
 static int mt9m001_s_crop(struct v4l2_subdev *sd, struct v4l2_crop *a)
 {
-	struct v4l2_rect *rect = &a->c;
 	struct i2c_client *client = sd->priv;
 	struct mt9m001 *mt9m001 = to_mt9m001(client);
+	struct v4l2_rect rect = a->c;
 	struct soc_camera_device *icd = client->dev.platform_data;
 	int ret;
 	const u16 hblank = 9, vblank = 25;
 
+	if (mt9m001->fourcc == V4L2_PIX_FMT_SBGGR8 ||
+	    mt9m001->fourcc == V4L2_PIX_FMT_SBGGR16)
+		/*
+		 * Bayer format - even number of rows for simplicity,
+		 * but let the user play with the top row.
+		 */
+		rect.height = ALIGN(rect.height, 2);
+
+	/* Datasheet requirement: see register description */
+	rect.width = ALIGN(rect.width, 2);
+	rect.left = ALIGN(rect.left, 2);
+
+	soc_camera_limit_side(&rect.left, &rect.width,
+		     MT9M001_COLUMN_SKIP, MT9M001_MIN_WIDTH, MT9M001_MAX_WIDTH);
+
+	soc_camera_limit_side(&rect.top, &rect.height,
+		     MT9M001_ROW_SKIP, MT9M001_MIN_HEIGHT, MT9M001_MAX_HEIGHT);
+
 	/* Blanking and start values - default... */
 	ret = reg_write(client, MT9M001_HORIZONTAL_BLANKING, hblank);
 	if (!ret)
@@ -211,46 +238,98 @@ static int mt9m001_s_crop(struct v4l2_subdev *sd, struct v4l2_crop *a)
 	/* The caller provides a supported format, as verified per
 	 * call to icd->try_fmt() */
 	if (!ret)
-		ret = reg_write(client, MT9M001_COLUMN_START, rect->left);
+		ret = reg_write(client, MT9M001_COLUMN_START, rect.left);
 	if (!ret)
-		ret = reg_write(client, MT9M001_ROW_START, rect->top);
+		ret = reg_write(client, MT9M001_ROW_START, rect.top);
 	if (!ret)
-		ret = reg_write(client, MT9M001_WINDOW_WIDTH, rect->width - 1);
+		ret = reg_write(client, MT9M001_WINDOW_WIDTH, rect.width - 1);
 	if (!ret)
 		ret = reg_write(client, MT9M001_WINDOW_HEIGHT,
-				rect->height + icd->y_skip_top - 1);
+				rect.height + icd->y_skip_top - 1);
 	if (!ret && mt9m001->autoexposure) {
 		ret = reg_write(client, MT9M001_SHUTTER_WIDTH,
-				rect->height + icd->y_skip_top + vblank);
+				rect.height + icd->y_skip_top + vblank);
 		if (!ret) {
 			const struct v4l2_queryctrl *qctrl =
 				soc_camera_find_qctrl(icd->ops,
 						      V4L2_CID_EXPOSURE);
-			icd->exposure = (524 + (rect->height + icd->y_skip_top +
+			icd->exposure = (524 + (rect.height + icd->y_skip_top +
 						vblank - 1) *
 					 (qctrl->maximum - qctrl->minimum)) /
 				1048 + qctrl->minimum;
 		}
 	}
 
+	if (!ret)
+		mt9m001->rect = rect;
+
 	return ret;
 }
 
+static int mt9m001_g_crop(struct v4l2_subdev *sd, struct v4l2_crop *a)
+{
+	struct i2c_client *client = sd->priv;
+	struct mt9m001 *mt9m001 = to_mt9m001(client);
+
+	a->c	= mt9m001->rect;
+	a->type	= V4L2_BUF_TYPE_VIDEO_CAPTURE;
+
+	return 0;
+}
+
+static int mt9m001_cropcap(struct v4l2_subdev *sd, struct v4l2_cropcap *a)
+{
+	a->bounds.left			= MT9M001_COLUMN_SKIP;
+	a->bounds.top			= MT9M001_ROW_SKIP;
+	a->bounds.width			= MT9M001_MAX_WIDTH;
+	a->bounds.height		= MT9M001_MAX_HEIGHT;
+	a->defrect			= a->bounds;
+	a->type				= V4L2_BUF_TYPE_VIDEO_CAPTURE;
+	a->pixelaspect.numerator	= 1;
+	a->pixelaspect.denominator	= 1;
+
+	return 0;
+}
+
+static int mt9m001_g_fmt(struct v4l2_subdev *sd, struct v4l2_format *f)
+{
+	struct i2c_client *client = sd->priv;
+	struct mt9m001 *mt9m001 = to_mt9m001(client);
+	struct v4l2_pix_format *pix = &f->fmt.pix;
+
+	pix->width		= mt9m001->rect.width;
+	pix->height		= mt9m001->rect.height;
+	pix->pixelformat	= mt9m001->fourcc;
+	pix->field		= V4L2_FIELD_NONE;
+	pix->colorspace		= V4L2_COLORSPACE_SRGB;
+
+	return 0;
+}
+
 static int mt9m001_s_fmt(struct v4l2_subdev *sd, struct v4l2_format *f)
 {
 	struct i2c_client *client = sd->priv;
-	struct soc_camera_device *icd = client->dev.platform_data;
+	struct mt9m001 *mt9m001 = to_mt9m001(client);
+	struct v4l2_pix_format *pix = &f->fmt.pix;
 	struct v4l2_crop a = {
 		.c = {
-			.left	= icd->rect_current.left,
-			.top	= icd->rect_current.top,
-			.width	= f->fmt.pix.width,
-			.height	= f->fmt.pix.height,
+			.left	= mt9m001->rect.left,
+			.top	= mt9m001->rect.top,
+			.width	= pix->width,
+			.height	= pix->height,
 		},
 	};
+	int ret;
 
 	/* No support for scaling so far, just crop. TODO: use skipping */
-	return mt9m001_s_crop(sd, &a);
+	ret = mt9m001_s_crop(sd, &a);
+	if (!ret) {
+		pix->width = mt9m001->rect.width;
+		pix->height = mt9m001->rect.height;
+		mt9m001->fourcc = pix->pixelformat;
+	}
+
+	return ret;
 }
 
 static int mt9m001_try_fmt(struct v4l2_subdev *sd, struct v4l2_format *f)
@@ -259,15 +338,22 @@ static int mt9m001_try_fmt(struct v4l2_subdev *sd, struct v4l2_format *f)
 	struct soc_camera_device *icd = client->dev.platform_data;
 	struct v4l2_pix_format *pix = &f->fmt.pix;
 
-	if (pix->height < 32 + icd->y_skip_top)
-		pix->height = 32 + icd->y_skip_top;
-	if (pix->height > 1024 + icd->y_skip_top)
-		pix->height = 1024 + icd->y_skip_top;
-	if (pix->width < 48)
-		pix->width = 48;
-	if (pix->width > 1280)
-		pix->width = 1280;
-	pix->width &= ~0x01; /* has to be even, unsure why was ~3 */
+	if (pix->height < MT9M001_MIN_HEIGHT + icd->y_skip_top)
+		pix->height = MT9M001_MIN_HEIGHT + icd->y_skip_top;
+	else if (pix->height > MT9M001_MAX_HEIGHT + icd->y_skip_top)
+		pix->height = MT9M001_MAX_HEIGHT + icd->y_skip_top;
+
+	if (pix->pixelformat == V4L2_PIX_FMT_SBGGR8 ||
+	    pix->pixelformat == V4L2_PIX_FMT_SBGGR16)
+		pix->height = ALIGN(pix->height - 1, 2);
+
+	if (pix->width < MT9M001_MIN_WIDTH)
+		pix->width = MT9M001_MIN_WIDTH;
+	else if (pix->width > MT9M001_MAX_WIDTH)
+		pix->width = MT9M001_MAX_WIDTH;
+	else
+		/* Datasheet requirement: see register description */
+		pix->width = ALIGN(pix->width, 2);
 
 	return 0;
 }
@@ -478,11 +564,11 @@ static int mt9m001_s_ctrl(struct v4l2_subdev *sd, struct v4l2_control *ctrl)
 		if (ctrl->value) {
 			const u16 vblank = 25;
 			if (reg_write(client, MT9M001_SHUTTER_WIDTH,
-				      icd->rect_current.height +
+				      mt9m001->rect.height +
 				      icd->y_skip_top + vblank) < 0)
 				return -EIO;
 			qctrl = soc_camera_find_qctrl(icd->ops, V4L2_CID_EXPOSURE);
-			icd->exposure = (524 + (icd->rect_current.height +
+			icd->exposure = (524 + (mt9m001->rect.height +
 						icd->y_skip_top + vblank - 1) *
 					 (qctrl->maximum - qctrl->minimum)) /
 				1048 + qctrl->minimum;
@@ -554,6 +640,8 @@ static int mt9m001_video_probe(struct soc_camera_device *icd,
 	if (flags & SOCAM_DATAWIDTH_8)
 		icd->num_formats++;
 
+	mt9m001->fourcc = icd->formats->fourcc;
+
 	dev_info(&client->dev, "Detected a MT9M001 chip ID %x (%s)\n", data,
 		 data == 0x8431 ? "C12STM" : "C12ST");
 
@@ -584,8 +672,11 @@ static struct v4l2_subdev_core_ops mt9m001_subdev_core_ops = {
 static struct v4l2_subdev_video_ops mt9m001_subdev_video_ops = {
 	.s_stream	= mt9m001_s_stream,
 	.s_fmt		= mt9m001_s_fmt,
+	.g_fmt		= mt9m001_g_fmt,
 	.try_fmt	= mt9m001_try_fmt,
 	.s_crop		= mt9m001_s_crop,
+	.g_crop		= mt9m001_g_crop,
+	.cropcap	= mt9m001_cropcap,
 };
 
 static struct v4l2_subdev_ops mt9m001_subdev_ops = {
@@ -627,15 +718,13 @@ static int mt9m001_probe(struct i2c_client *client,
 
 	/* Second stage probe - when a capture adapter is there */
 	icd->ops		= &mt9m001_ops;
-	icd->rect_max.left	= 20;
-	icd->rect_max.top	= 12;
-	icd->rect_max.width	= 1280;
-	icd->rect_max.height	= 1024;
-	icd->rect_current.left	= 20;
-	icd->rect_current.top	= 12;
-	icd->width_min		= 48;
-	icd->height_min		= 32;
 	icd->y_skip_top		= 1;
+
+	mt9m001->rect.left	= MT9M001_COLUMN_SKIP;
+	mt9m001->rect.top	= MT9M001_ROW_SKIP;
+	mt9m001->rect.width	= MT9M001_MAX_WIDTH;
+	mt9m001->rect.height	= MT9M001_MAX_HEIGHT;
+
 	/* Simulated autoexposure. If enabled, we calculate shutter width
 	 * ourselves in the driver based on vertical blanking and frame width */
 	mt9m001->autoexposure = 1;
diff --git a/drivers/media/video/mt9m111.c b/drivers/media/video/mt9m111.c
index 3637376..21d3722 100644
--- a/drivers/media/video/mt9m111.c
+++ b/drivers/media/video/mt9m111.c
@@ -194,7 +194,7 @@ static int mt9m111_reg_read(struct i2c_client *client, const u16 reg)
 
 	ret = reg_page_map_set(client, reg);
 	if (!ret)
-		ret = swab16(i2c_smbus_read_word_data(client, (reg & 0xff)));
+		ret = swab16(i2c_smbus_read_word_data(client, reg & 0xff));
 
 	dev_dbg(&client->dev, "read  reg.%03x -> %04x\n", reg, ret);
 	return ret;
@@ -257,8 +257,8 @@ static int mt9m111_setup_rect(struct i2c_client *client,
 	int width = rect->width;
 	int height = rect->height;
 
-	if ((mt9m111->pixfmt == V4L2_PIX_FMT_SBGGR8)
-	    || (mt9m111->pixfmt == V4L2_PIX_FMT_SBGGR16))
+	if (mt9m111->pixfmt == V4L2_PIX_FMT_SBGGR8 ||
+	    mt9m111->pixfmt == V4L2_PIX_FMT_SBGGR16)
 		is_raw_format = 1;
 	else
 		is_raw_format = 0;
@@ -395,23 +395,86 @@ static int mt9m111_set_bus_param(struct soc_camera_device *icd, unsigned long f)
 	return 0;
 }
 
+static int mt9m111_make_rect(struct i2c_client *client,
+			     struct v4l2_rect *rect)
+{
+	struct mt9m111 *mt9m111 = to_mt9m111(client);
+
+	if (mt9m111->pixfmt == V4L2_PIX_FMT_SBGGR8 ||
+	    mt9m111->pixfmt == V4L2_PIX_FMT_SBGGR16) {
+		/* Bayer format - even size lengths */
+		rect->width	= ALIGN(rect->width, 2);
+		rect->height	= ALIGN(rect->height, 2);
+		/* Let the user play with the starting pixel */
+	}
+
+	/* FIXME: the datasheet doesn't specify minimum sizes */
+	soc_camera_limit_side(&rect->left, &rect->width,
+		     MT9M111_MIN_DARK_COLS, 2, MT9M111_MAX_WIDTH);
+
+	soc_camera_limit_side(&rect->top, &rect->height,
+		     MT9M111_MIN_DARK_ROWS, 2, MT9M111_MAX_HEIGHT);
+
+	return mt9m111_setup_rect(client, rect);
+}
+
 static int mt9m111_s_crop(struct v4l2_subdev *sd, struct v4l2_crop *a)
 {
-	struct v4l2_rect *rect = &a->c;
+	struct v4l2_rect rect = a->c;
 	struct i2c_client *client = sd->priv;
 	struct mt9m111 *mt9m111 = to_mt9m111(client);
+	struct soc_camera_device *icd = client->dev.platform_data;
 	int ret;
 
 	dev_dbg(&client->dev, "%s left=%d, top=%d, width=%d, height=%d\n",
-		__func__, rect->left, rect->top, rect->width,
-		rect->height);
+		__func__, rect.left, rect.top, rect.width, rect.height);
 
-	ret = mt9m111_setup_rect(client, rect);
+	ret = mt9m111_make_rect(client, &rect);
 	if (!ret)
-		mt9m111->rect = *rect;
+		mt9m111->rect = rect;
 	return ret;
 }
 
+static int mt9m111_g_crop(struct v4l2_subdev *sd, struct v4l2_crop *a)
+{
+	struct i2c_client *client = sd->priv;
+	struct mt9m111 *mt9m111 = to_mt9m111(client);
+
+	a->c	= mt9m111->rect;
+	a->type	= V4L2_BUF_TYPE_VIDEO_CAPTURE;
+
+	return 0;
+}
+
+static int mt9m111_cropcap(struct v4l2_subdev *sd, struct v4l2_cropcap *a)
+{
+	a->bounds.left			= MT9M111_MIN_DARK_COLS;
+	a->bounds.top			= MT9M111_MIN_DARK_ROWS;
+	a->bounds.width			= MT9M111_MAX_WIDTH;
+	a->bounds.height		= MT9M111_MAX_HEIGHT;
+	a->defrect			= a->bounds;
+	a->type				= V4L2_BUF_TYPE_VIDEO_CAPTURE;
+	a->pixelaspect.numerator	= 1;
+	a->pixelaspect.denominator	= 1;
+
+	return 0;
+}
+
+static int mt9m111_g_fmt(struct v4l2_subdev *sd, struct v4l2_format *f)
+{
+	struct i2c_client *client = sd->priv;
+	struct mt9m111 *mt9m111 = to_mt9m111(client);
+	struct v4l2_pix_format *pix = &f->fmt.pix;
+
+	pix->width		= mt9m111->rect.width;
+	pix->height		= mt9m111->rect.height;
+	pix->pixelformat	= mt9m111->pixfmt;
+	pix->field		= V4L2_FIELD_NONE;
+	pix->colorspace		= V4L2_COLORSPACE_SRGB;
+
+	return 0;
+}
+
 static int mt9m111_set_pixfmt(struct i2c_client *client, u32 pixfmt)
 {
 	struct mt9m111 *mt9m111 = to_mt9m111(client);
@@ -478,7 +541,7 @@ static int mt9m111_s_fmt(struct v4l2_subdev *sd, struct v4l2_format *f)
 		__func__, pix->pixelformat, rect.left, rect.top, rect.width,
 		rect.height);
 
-	ret = mt9m111_setup_rect(client, &rect);
+	ret = mt9m111_make_rect(client, &rect);
 	if (!ret)
 		ret = mt9m111_set_pixfmt(client, pix->pixelformat);
 	if (!ret)
@@ -489,11 +552,27 @@ static int mt9m111_s_fmt(struct v4l2_subdev *sd, struct v4l2_format *f)
 static int mt9m111_try_fmt(struct v4l2_subdev *sd, struct v4l2_format *f)
 {
 	struct v4l2_pix_format *pix = &f->fmt.pix;
+	bool bayer = pix->pixelformat == V4L2_PIX_FMT_SBGGR8 ||
+		pix->pixelformat == V4L2_PIX_FMT_SBGGR16;
+
+	/*
+	 * With Bayer format enforce even side lengths, but let the user play
+	 * with the starting pixel
+	 */
 
 	if (pix->height > MT9M111_MAX_HEIGHT)
 		pix->height = MT9M111_MAX_HEIGHT;
+	else if (pix->height < 2)
+		pix->height = 2;
+	else if (bayer)
+		pix->height = ALIGN(pix->height, 2);
+
 	if (pix->width > MT9M111_MAX_WIDTH)
 		pix->width = MT9M111_MAX_WIDTH;
+	else if (pix->width < 2)
+		pix->width = 2;
+	else if (bayer)
+		pix->width = ALIGN(pix->width, 2);
 
 	return 0;
 }
@@ -906,8 +985,11 @@ static struct v4l2_subdev_core_ops mt9m111_subdev_core_ops = {
 
 static struct v4l2_subdev_video_ops mt9m111_subdev_video_ops = {
 	.s_fmt		= mt9m111_s_fmt,
+	.g_fmt		= mt9m111_g_fmt,
 	.try_fmt	= mt9m111_try_fmt,
 	.s_crop		= mt9m111_s_crop,
+	.g_crop		= mt9m111_g_crop,
+	.cropcap	= mt9m111_cropcap,
 };
 
 static struct v4l2_subdev_ops mt9m111_subdev_ops = {
@@ -949,16 +1031,13 @@ static int mt9m111_probe(struct i2c_client *client,
 
 	/* Second stage probe - when a capture adapter is there */
 	icd->ops		= &mt9m111_ops;
-	icd->rect_max.left	= MT9M111_MIN_DARK_COLS;
-	icd->rect_max.top	= MT9M111_MIN_DARK_ROWS;
-	icd->rect_max.width	= MT9M111_MAX_WIDTH;
-	icd->rect_max.height	= MT9M111_MAX_HEIGHT;
-	icd->rect_current.left	= icd->rect_max.left;
-	icd->rect_current.top	= icd->rect_max.top;
-	icd->width_min		= MT9M111_MIN_DARK_ROWS;
-	icd->height_min		= MT9M111_MIN_DARK_COLS;
 	icd->y_skip_top		= 0;
 
+	mt9m111->rect.left	= MT9M111_MIN_DARK_COLS;
+	mt9m111->rect.top	= MT9M111_MIN_DARK_ROWS;
+	mt9m111->rect.width	= MT9M111_MAX_WIDTH;
+	mt9m111->rect.height	= MT9M111_MAX_HEIGHT;
+
 	ret = mt9m111_video_probe(icd, client);
 	if (ret) {
 		icd->ops = NULL;
diff --git a/drivers/media/video/mt9t031.c b/drivers/media/video/mt9t031.c
index d6c677f..f2cf64a 100644
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
@@ -218,56 +219,68 @@ static unsigned long mt9t031_query_bus_param(struct soc_camera_device *icd)
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
 
-	dev_dbg(&client->dev, "xskip %u, width %u/%u, yskip %u, height %u/%u\n",
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
-	case 2:
-		left = (left + 3) & ~3;
+	case 1:
+		rect->left &= ~1;
 		break;
-	case 3:
-		left = roundup(left, 6);
-	}
-
-	switch (ybin) {
 	case 2:
-		top = (top + 3) & ~3;
+		rect->left &= ~3;
 		break;
 	case 3:
-		top = roundup(top, 6);
+		rect->left = rect->left > roundup(MT9T031_COLUMN_SKIP, 6) ?
+			(rect->left / 6) * 6 : roundup(MT9T031_COLUMN_SKIP, 6);
 	}
 
+	rect->top &= ~1;
+
+	dev_dbg(&client->dev, "skip %u:%u, rect %ux%u@%u:%u\n",
+		xskip, yskip, rect->width, rect->height, rect->left, rect->top);
+
 	/* Disable register update, reconfigure atomically */
 	ret = reg_set(client, MT9T031_OUTPUT_CONTROL, 1);
 	if (ret < 0)
@@ -287,27 +300,29 @@ static int mt9t031_set_params(struct soc_camera_device *icd,
 			ret = reg_write(client, MT9T031_ROW_ADDRESS_MODE,
 					((ybin - 1) << 4) | (yskip - 1));
 	}
-	dev_dbg(&client->dev, "new physical left %u, top %u\n", left, top);
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
@@ -318,27 +333,72 @@ static int mt9t031_set_params(struct soc_camera_device *icd,
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
+	rect.width = ALIGN(rect.width, 2);
+	rect.height = ALIGN(rect.height, 2);
+
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
+
+static int mt9t031_cropcap(struct v4l2_subdev *sd, struct v4l2_cropcap *a)
+{
+	a->bounds.left			= MT9T031_COLUMN_SKIP;
+	a->bounds.top			= MT9T031_ROW_SKIP;
+	a->bounds.width			= MT9T031_MAX_WIDTH;
+	a->bounds.height		= MT9T031_MAX_HEIGHT;
+	a->defrect			= a->bounds;
+	a->type				= V4L2_BUF_TYPE_VIDEO_CAPTURE;
+	a->pixelaspect.numerator	= 1;
+	a->pixelaspect.denominator	= 1;
+
+	return 0;
+}
+
+static int mt9t031_g_fmt(struct v4l2_subdev *sd, struct v4l2_format *f)
+{
+	struct i2c_client *client = sd->priv;
+	struct mt9t031 *mt9t031 = to_mt9t031(client);
+	struct v4l2_pix_format *pix = &f->fmt.pix;
 
-	if (rect->top + rect->height > icd->rect_max.height + icd->rect_max.top)
-		rect->top = icd->rect_max.height + icd->rect_max.top -
-			rect->height;
+	pix->width		= mt9t031->rect.width / mt9t031->xskip;
+	pix->height		= mt9t031->rect.height / mt9t031->yskip;
+	pix->pixelformat	= V4L2_PIX_FMT_SGRBG10;
+	pix->field		= V4L2_FIELD_NONE;
+	pix->colorspace		= V4L2_COLORSPACE_SRGB;
 
-	/* CROP - no change in scaling, or in limits */
-	return mt9t031_set_params(icd, rect, mt9t031->xskip, mt9t031->yskip);
+	return 0;
 }
 
 static int mt9t031_s_fmt(struct v4l2_subdev *sd, struct v4l2_format *f)
@@ -346,55 +406,43 @@ static int mt9t031_s_fmt(struct v4l2_subdev *sd, struct v4l2_format *f)
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
+	xskip = mt9t031_skip(&rect.width, pix->width, MT9T031_MAX_WIDTH);
+	yskip = mt9t031_skip(&rect.height, pix->height, MT9T031_MAX_HEIGHT);
 
-	recalculate_limits(icd, xskip, yskip);
-
-	ret = mt9t031_set_params(icd, &rect, xskip, yskip);
-	if (!ret) {
-		mt9t031->xskip = xskip;
-		mt9t031->yskip = yskip;
-	}
-
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
@@ -628,12 +676,12 @@ static int mt9t031_s_ctrl(struct v4l2_subdev *sd, struct v4l2_control *ctrl)
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
@@ -653,12 +701,6 @@ static int mt9t031_video_probe(struct i2c_client *client)
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
 	dev_dbg(&client->dev, "write: %d\n", data);
@@ -696,8 +738,11 @@ static struct v4l2_subdev_core_ops mt9t031_subdev_core_ops = {
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
@@ -739,15 +784,13 @@ static int mt9t031_probe(struct i2c_client *client,
 
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
diff --git a/drivers/media/video/mt9v022.c b/drivers/media/video/mt9v022.c
index 70ad9a1..f94f425 100644
--- a/drivers/media/video/mt9v022.c
+++ b/drivers/media/video/mt9v022.c
@@ -55,6 +55,13 @@ MODULE_PARM_DESC(sensor_type, "Sensor type: \"colour\" or \"monochrome\"");
 /* Progressive scan, master, defaults */
 #define MT9V022_CHIP_CONTROL_DEFAULT	0x188
 
+#define MT9V022_MAX_WIDTH		752
+#define MT9V022_MAX_HEIGHT		480
+#define MT9V022_MIN_WIDTH		48
+#define MT9V022_MIN_HEIGHT		32
+#define MT9V022_COLUMN_SKIP		1
+#define MT9V022_ROW_SKIP		4
+
 static const struct soc_camera_data_format mt9v022_colour_formats[] = {
 	/* Order important: first natively supported,
 	 * second supported with a GPIO extender */
@@ -86,6 +93,8 @@ static const struct soc_camera_data_format mt9v022_monochrome_formats[] = {
 
 struct mt9v022 {
 	struct v4l2_subdev subdev;
+	struct v4l2_rect rect;	/* Sensor window */
+	__u32 fourcc;
 	int model;	/* V4L2_IDENT_MT9V022* codes from v4l2-chip-ident.h */
 	u16 chip_control;
 };
@@ -250,44 +259,101 @@ static unsigned long mt9v022_query_bus_param(struct soc_camera_device *icd)
 
 static int mt9v022_s_crop(struct v4l2_subdev *sd, struct v4l2_crop *a)
 {
-	struct v4l2_rect *rect = &a->c;
 	struct i2c_client *client = sd->priv;
+	struct mt9v022 *mt9v022 = to_mt9v022(client);
+	struct v4l2_rect rect = a->c;
 	struct soc_camera_device *icd = client->dev.platform_data;
 	int ret;
 
+	/* Bayer format - even size lengths */
+	if (mt9v022->fourcc == V4L2_PIX_FMT_SBGGR8 ||
+	    mt9v022->fourcc == V4L2_PIX_FMT_SBGGR16) {
+		rect.width	= ALIGN(rect.width, 2);
+		rect.height	= ALIGN(rect.height, 2);
+		/* Let the user play with the starting pixel */
+	}
+
+	soc_camera_limit_side(&rect.left, &rect.width,
+		     MT9V022_COLUMN_SKIP, MT9V022_MIN_WIDTH, MT9V022_MAX_WIDTH);
+
+	soc_camera_limit_side(&rect.top, &rect.height,
+		     MT9V022_ROW_SKIP, MT9V022_MIN_HEIGHT, MT9V022_MAX_HEIGHT);
+
 	/* Like in example app. Contradicts the datasheet though */
 	ret = reg_read(client, MT9V022_AEC_AGC_ENABLE);
 	if (ret >= 0) {
 		if (ret & 1) /* Autoexposure */
 			ret = reg_write(client, MT9V022_MAX_TOTAL_SHUTTER_WIDTH,
-					rect->height + icd->y_skip_top + 43);
+					rect.height + icd->y_skip_top + 43);
 		else
 			ret = reg_write(client, MT9V022_TOTAL_SHUTTER_WIDTH,
-					rect->height + icd->y_skip_top + 43);
+					rect.height + icd->y_skip_top + 43);
 	}
 	/* Setup frame format: defaults apart from width and height */
 	if (!ret)
-		ret = reg_write(client, MT9V022_COLUMN_START, rect->left);
+		ret = reg_write(client, MT9V022_COLUMN_START, rect.left);
 	if (!ret)
-		ret = reg_write(client, MT9V022_ROW_START, rect->top);
+		ret = reg_write(client, MT9V022_ROW_START, rect.top);
 	if (!ret)
 		/* Default 94, Phytec driver says:
 		 * "width + horizontal blank >= 660" */
 		ret = reg_write(client, MT9V022_HORIZONTAL_BLANKING,
-				rect->width > 660 - 43 ? 43 :
-				660 - rect->width);
+				rect.width > 660 - 43 ? 43 :
+				660 - rect.width);
 	if (!ret)
 		ret = reg_write(client, MT9V022_VERTICAL_BLANKING, 45);
 	if (!ret)
-		ret = reg_write(client, MT9V022_WINDOW_WIDTH, rect->width);
+		ret = reg_write(client, MT9V022_WINDOW_WIDTH, rect.width);
 	if (!ret)
 		ret = reg_write(client, MT9V022_WINDOW_HEIGHT,
-				rect->height + icd->y_skip_top);
+				rect.height + icd->y_skip_top);
 
 	if (ret < 0)
 		return ret;
 
-	dev_dbg(&client->dev, "Frame %ux%u pixel\n", rect->width, rect->height);
+	dev_dbg(&client->dev, "Frame %ux%u pixel\n", rect.width, rect.height);
+
+	mt9v022->rect = rect;
+
+	return 0;
+}
+
+static int mt9v022_g_crop(struct v4l2_subdev *sd, struct v4l2_crop *a)
+{
+	struct i2c_client *client = sd->priv;
+	struct mt9v022 *mt9v022 = to_mt9v022(client);
+
+	a->c	= mt9v022->rect;
+	a->type	= V4L2_BUF_TYPE_VIDEO_CAPTURE;
+
+	return 0;
+}
+
+static int mt9v022_cropcap(struct v4l2_subdev *sd, struct v4l2_cropcap *a)
+{
+	a->bounds.left			= MT9V022_COLUMN_SKIP;
+	a->bounds.top			= MT9V022_ROW_SKIP;
+	a->bounds.width			= MT9V022_MAX_WIDTH;
+	a->bounds.height		= MT9V022_MAX_HEIGHT;
+	a->defrect			= a->bounds;
+	a->type				= V4L2_BUF_TYPE_VIDEO_CAPTURE;
+	a->pixelaspect.numerator	= 1;
+	a->pixelaspect.denominator	= 1;
+
+	return 0;
+}
+
+static int mt9v022_g_fmt(struct v4l2_subdev *sd, struct v4l2_format *f)
+{
+	struct i2c_client *client = sd->priv;
+	struct mt9v022 *mt9v022 = to_mt9v022(client);
+	struct v4l2_pix_format *pix = &f->fmt.pix;
+
+	pix->width		= mt9v022->rect.width;
+	pix->height		= mt9v022->rect.height;
+	pix->pixelformat	= mt9v022->fourcc;
+	pix->field		= V4L2_FIELD_NONE;
+	pix->colorspace		= V4L2_COLORSPACE_SRGB;
 
 	return 0;
 }
@@ -296,16 +362,16 @@ static int mt9v022_s_fmt(struct v4l2_subdev *sd, struct v4l2_format *f)
 {
 	struct i2c_client *client = sd->priv;
 	struct mt9v022 *mt9v022 = to_mt9v022(client);
-	struct soc_camera_device *icd = client->dev.platform_data;
 	struct v4l2_pix_format *pix = &f->fmt.pix;
 	struct v4l2_crop a = {
 		.c = {
-			.left	= icd->rect_current.left,
-			.top	= icd->rect_current.top,
+			.left	= mt9v022->rect.left,
+			.top	= mt9v022->rect.top,
 			.width	= pix->width,
 			.height	= pix->height,
 		},
 	};
+	int ret;
 
 	/* The caller provides a supported format, as verified per call to
 	 * icd->try_fmt(), datawidth is from our supported format list */
@@ -328,7 +394,14 @@ static int mt9v022_s_fmt(struct v4l2_subdev *sd, struct v4l2_format *f)
 	}
 
 	/* No support for scaling on this camera, just crop. */
-	return mt9v022_s_crop(sd, &a);
+	ret = mt9v022_s_crop(sd, &a);
+	if (!ret) {
+		pix->width = mt9v022->rect.width;
+		pix->height = mt9v022->rect.height;
+		mt9v022->fourcc = pix->pixelformat;
+	}
+
+	return ret;
 }
 
 static int mt9v022_try_fmt(struct v4l2_subdev *sd, struct v4l2_format *f)
@@ -336,16 +409,23 @@ static int mt9v022_try_fmt(struct v4l2_subdev *sd, struct v4l2_format *f)
 	struct i2c_client *client = sd->priv;
 	struct soc_camera_device *icd = client->dev.platform_data;
 	struct v4l2_pix_format *pix = &f->fmt.pix;
+	bool bayer = pix->pixelformat == V4L2_PIX_FMT_SBGGR8 ||
+		pix->pixelformat == V4L2_PIX_FMT_SBGGR16;
 
-	if (pix->height < 32 + icd->y_skip_top)
-		pix->height = 32 + icd->y_skip_top;
-	if (pix->height > 480 + icd->y_skip_top)
-		pix->height = 480 + icd->y_skip_top;
-	if (pix->width < 48)
-		pix->width = 48;
-	if (pix->width > 752)
-		pix->width = 752;
-	pix->width &= ~0x03; /* ? */
+	if (pix->height < MT9V022_MIN_HEIGHT + icd->y_skip_top)
+		pix->height = MT9V022_MIN_HEIGHT + icd->y_skip_top;
+	else if (pix->height > MT9V022_MAX_HEIGHT + icd->y_skip_top)
+		pix->height = MT9V022_MAX_HEIGHT + icd->y_skip_top;
+
+	if (bayer)
+		pix->height = ALIGN(pix->height - 1, 2);
+
+	if (pix->width < MT9V022_MIN_WIDTH)
+		pix->width = MT9V022_MIN_WIDTH;
+	else if (pix->width > MT9V022_MAX_WIDTH)
+		pix->width = MT9V022_MAX_WIDTH;
+	else if (bayer)
+		pix->width = ALIGN(pix->width, 2);
 
 	return 0;
 }
@@ -675,6 +755,8 @@ static int mt9v022_video_probe(struct soc_camera_device *icd,
 	if (flags & SOCAM_DATAWIDTH_8)
 		icd->num_formats++;
 
+	mt9v022->fourcc = icd->formats->fourcc;
+
 	dev_info(&client->dev, "Detected a MT9V022 chip ID %x, %s sensor\n",
 		 data, mt9v022->model == V4L2_IDENT_MT9V022IX7ATM ?
 		 "monochrome" : "colour");
@@ -707,8 +789,11 @@ static struct v4l2_subdev_core_ops mt9v022_subdev_core_ops = {
 static struct v4l2_subdev_video_ops mt9v022_subdev_video_ops = {
 	.s_stream	= mt9v022_s_stream,
 	.s_fmt		= mt9v022_s_fmt,
+	.g_fmt		= mt9v022_g_fmt,
 	.try_fmt	= mt9v022_try_fmt,
 	.s_crop		= mt9v022_s_crop,
+	.g_crop		= mt9v022_g_crop,
+	.cropcap	= mt9v022_cropcap,
 };
 
 static struct v4l2_subdev_ops mt9v022_subdev_ops = {
@@ -751,16 +836,13 @@ static int mt9v022_probe(struct i2c_client *client,
 	mt9v022->chip_control = MT9V022_CHIP_CONTROL_DEFAULT;
 
 	icd->ops		= &mt9v022_ops;
-	icd->rect_max.left	= 1;
-	icd->rect_max.top	= 4;
-	icd->rect_max.width	= 752;
-	icd->rect_max.height	= 480;
-	icd->rect_current.left	= 1;
-	icd->rect_current.top	= 4;
-	icd->width_min		= 48;
-	icd->height_min		= 32;
 	icd->y_skip_top		= 1;
 
+	mt9v022->rect.left	= MT9V022_COLUMN_SKIP;
+	mt9v022->rect.top	= MT9V022_ROW_SKIP;
+	mt9v022->rect.width	= MT9V022_MAX_WIDTH;
+	mt9v022->rect.height	= MT9V022_MAX_HEIGHT;
+
 	ret = mt9v022_video_probe(icd, client);
 	if (ret) {
 		icd->ops = NULL;
diff --git a/drivers/media/video/mx1_camera.c b/drivers/media/video/mx1_camera.c
index 9adc57a..9632cb1 100644
--- a/drivers/media/video/mx1_camera.c
+++ b/drivers/media/video/mx1_camera.c
@@ -126,7 +126,7 @@ static int mx1_videobuf_setup(struct videobuf_queue *vq, unsigned int *count,
 {
 	struct soc_camera_device *icd = vq->priv_data;
 
-	*size = icd->rect_current.width * icd->rect_current.height *
+	*size = icd->user_width * icd->user_height *
 		((icd->current_fmt->depth + 7) >> 3);
 
 	if (!*count)
@@ -178,12 +178,12 @@ static int mx1_videobuf_prepare(struct videobuf_queue *vq,
 	buf->inwork = 1;
 
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
 		vb->state	= VIDEOBUF_NEEDS_INIT;
 	}
diff --git a/drivers/media/video/mx3_camera.c b/drivers/media/video/mx3_camera.c
index dd3ca7f..6572ce7 100644
--- a/drivers/media/video/mx3_camera.c
+++ b/drivers/media/video/mx3_camera.c
@@ -220,7 +220,7 @@ static int mx3_videobuf_setup(struct videobuf_queue *vq, unsigned int *count,
 	if (!mx3_cam->idmac_channel[0])
 		return -EINVAL;
 
-	*size = icd->rect_current.width * icd->rect_current.height * bpp;
+	*size = icd->user_width * icd->user_height * bpp;
 
 	if (!*count)
 		*count = 32;
@@ -241,7 +241,7 @@ static int mx3_videobuf_prepare(struct videobuf_queue *vq,
 	struct mx3_camera_buffer *buf =
 		container_of(vb, struct mx3_camera_buffer, vb);
 	/* current_fmt _must_ always be set */
-	size_t new_size = icd->rect_current.width * icd->rect_current.height *
+	size_t new_size = icd->user_width * icd->user_height *
 		((icd->current_fmt->depth + 7) >> 3);
 	int ret;
 
@@ -251,12 +251,12 @@ static int mx3_videobuf_prepare(struct videobuf_queue *vq,
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
@@ -350,9 +350,9 @@ static void mx3_videobuf_queue(struct videobuf_queue *vq,
 
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
@@ -540,7 +540,7 @@ static bool channel_change_requested(struct soc_camera_device *icd,
 
 	/* Do buffers have to be re-allocated or channel re-configured? */
 	return ichan && rect->width * rect->height >
-		icd->rect_current.width * icd->rect_current.height;
+		icd->user_width * icd->user_height;
 }
 
 static int test_platform_param(struct mx3_camera_dev *mx3_cam,
@@ -588,8 +588,8 @@ static int test_platform_param(struct mx3_camera_dev *mx3_cam,
 		*flags |= SOCAM_DATAWIDTH_4;
 		break;
 	default:
-		dev_info(mx3_cam->soc_host.v4l2_dev.dev, "Unsupported bus width %d\n",
-			 buswidth);
+		dev_warn(mx3_cam->soc_host.v4l2_dev.dev,
+			 "Unsupported bus width %d\n", buswidth);
 		return -EINVAL;
 	}
 
@@ -604,8 +604,7 @@ static int mx3_camera_try_bus_param(struct soc_camera_device *icd,
 	unsigned long bus_flags, camera_flags;
 	int ret = test_platform_param(mx3_cam, depth, &bus_flags);
 
-	dev_dbg(icd->dev.parent, "requested bus width %d bit: %d\n",
-		depth, ret);
+	dev_dbg(icd->dev.parent, "request bus width %d bit: %d\n", depth, ret);
 
 	if (ret < 0)
 		return ret;
@@ -726,13 +725,13 @@ passthrough:
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
@@ -744,11 +743,6 @@ static void configure_geometry(struct mx3_camera_dev *mx3_cam,
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
@@ -785,6 +779,22 @@ static int acquire_dma_channel(struct mx3_camera_dev *mx3_cam)
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
@@ -792,20 +802,51 @@ static int mx3_camera_set_crop(struct soc_camera_device *icd,
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
 
-	return v4l2_subdev_call(sd, video, s_crop, a);
+		configure_geometry(mx3_cam, pix->width, pix->height);
+	}
+
+	dev_dbg(icd->dev.parent, "Sensor cropped %dx%d\n",
+		pix->width, pix->height);
+
+	icd->user_width = pix->width;
+	icd->user_height = pix->height;
+
+	return ret;
 }
 
 static int mx3_camera_set_fmt(struct soc_camera_device *icd,
@@ -816,12 +857,6 @@ static int mx3_camera_set_fmt(struct soc_camera_device *icd,
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
@@ -831,6 +866,9 @@ static int mx3_camera_set_fmt(struct soc_camera_device *icd,
 		return -EINVAL;
 	}
 
+	stride_align(&pix->width);
+	dev_dbg(icd->dev.parent, "Set format %dx%d\n", pix->width, pix->height);
+
 	ret = acquire_dma_channel(mx3_cam);
 	if (ret < 0)
 		return ret;
@@ -841,7 +879,7 @@ static int mx3_camera_set_fmt(struct soc_camera_device *icd,
 	 * mxc_v4l2_s_fmt()
 	 */
 
-	configure_geometry(mx3_cam, &rect);
+	configure_geometry(mx3_cam, pix->width, pix->height);
 
 	ret = v4l2_subdev_call(sd, video, s_fmt, f);
 	if (!ret) {
@@ -849,6 +887,8 @@ static int mx3_camera_set_fmt(struct soc_camera_device *icd,
 		icd->current_fmt = xlate->host_fmt;
 	}
 
+	dev_dbg(icd->dev.parent, "Sensor set %dx%d\n", pix->width, pix->height);
+
 	return ret;
 }
 
diff --git a/drivers/media/video/ov772x.c b/drivers/media/video/ov772x.c
index bbf5331..776a91d 100644
--- a/drivers/media/video/ov772x.c
+++ b/drivers/media/video/ov772x.c
@@ -382,11 +382,10 @@ struct regval_list {
 };
 
 struct ov772x_color_format {
-	char                     *name;
-	__u32                     fourcc;
-	u8                        dsp3;
-	u8                        com3;
-	u8                        com7;
+	const struct soc_camera_data_format *format;
+	u8 dsp3;
+	u8 com3;
+	u8 com7;
 };
 
 struct ov772x_win_size {
@@ -481,43 +480,43 @@ static const struct soc_camera_data_format ov772x_fmt_lists[] = {
  */
 static const struct ov772x_color_format ov772x_cfmts[] = {
 	{
-		SETFOURCC(YUYV),
+		.format = &ov772x_fmt_lists[0],
 		.dsp3   = 0x0,
 		.com3   = SWAP_YUV,
 		.com7   = OFMT_YUV,
 	},
 	{
-		SETFOURCC(YVYU),
+		.format = &ov772x_fmt_lists[1],
 		.dsp3   = UV_ON,
 		.com3   = SWAP_YUV,
 		.com7   = OFMT_YUV,
 	},
 	{
-		SETFOURCC(UYVY),
+		.format = &ov772x_fmt_lists[2],
 		.dsp3   = 0x0,
 		.com3   = 0x0,
 		.com7   = OFMT_YUV,
 	},
 	{
-		SETFOURCC(RGB555),
+		.format = &ov772x_fmt_lists[3],
 		.dsp3   = 0x0,
 		.com3   = SWAP_RGB,
 		.com7   = FMT_RGB555 | OFMT_RGB,
 	},
 	{
-		SETFOURCC(RGB555X),
+		.format = &ov772x_fmt_lists[4],
 		.dsp3   = 0x0,
 		.com3   = 0x0,
 		.com7   = FMT_RGB555 | OFMT_RGB,
 	},
 	{
-		SETFOURCC(RGB565),
+		.format = &ov772x_fmt_lists[5],
 		.dsp3   = 0x0,
 		.com3   = SWAP_RGB,
 		.com7   = FMT_RGB565 | OFMT_RGB,
 	},
 	{
-		SETFOURCC(RGB565X),
+		.format = &ov772x_fmt_lists[6],
 		.dsp3   = 0x0,
 		.com3   = 0x0,
 		.com7   = FMT_RGB565 | OFMT_RGB,
@@ -648,8 +647,8 @@ static int ov772x_s_stream(struct v4l2_subdev *sd, int enable)
 
 	ov772x_mask_set(client, COM2, SOFT_SLEEP_MODE, 0);
 
-	dev_dbg(&client->dev,
-		"format %s, win %s\n", priv->fmt->name, priv->win->name);
+	dev_dbg(&client->dev, "format %s, win %s\n",
+		priv->fmt->format->name, priv->win->name);
 
 	return 0;
 }
@@ -818,7 +817,7 @@ static int ov772x_set_params(struct i2c_client *client,
 	 */
 	priv->fmt = NULL;
 	for (i = 0; i < ARRAY_SIZE(ov772x_cfmts); i++) {
-		if (pixfmt == ov772x_cfmts[i].fourcc) {
+		if (pixfmt == ov772x_cfmts[i].format->fourcc) {
 			priv->fmt = ov772x_cfmts + i;
 			break;
 		}
@@ -955,6 +954,56 @@ ov772x_set_fmt_error:
 	return ret;
 }
 
+static int ov772x_g_crop(struct v4l2_subdev *sd, struct v4l2_crop *a)
+{
+	a->c.left	= 0;
+	a->c.top	= 0;
+	a->c.width	= VGA_WIDTH;
+	a->c.height	= VGA_HEIGHT;
+	a->type		= V4L2_BUF_TYPE_VIDEO_CAPTURE;
+
+	return 0;
+}
+
+static int ov772x_cropcap(struct v4l2_subdev *sd, struct v4l2_cropcap *a)
+{
+	a->bounds.left			= 0;
+	a->bounds.top			= 0;
+	a->bounds.width			= VGA_WIDTH;
+	a->bounds.height		= VGA_HEIGHT;
+	a->defrect			= a->bounds;
+	a->type				= V4L2_BUF_TYPE_VIDEO_CAPTURE;
+	a->pixelaspect.numerator	= 1;
+	a->pixelaspect.denominator	= 1;
+
+	return 0;
+}
+
+static int ov772x_g_fmt(struct v4l2_subdev *sd, struct v4l2_format *f)
+{
+	struct i2c_client *client = sd->priv;
+	struct ov772x_priv *priv = to_ov772x(client);
+	struct v4l2_pix_format *pix = &f->fmt.pix;
+
+	if (!priv->win || !priv->fmt) {
+		u32 width = VGA_WIDTH, height = VGA_HEIGHT;
+		int ret = ov772x_set_params(client, &width, &height,
+					    V4L2_PIX_FMT_YUYV);
+		if (ret < 0)
+			return ret;
+	}
+
+	f->type			= V4L2_BUF_TYPE_VIDEO_CAPTURE;
+
+	pix->width		= priv->win->width;
+	pix->height		= priv->win->height;
+	pix->pixelformat	= priv->fmt->format->fourcc;
+	pix->colorspace		= priv->fmt->format->colorspace;
+	pix->field		= V4L2_FIELD_NONE;
+
+	return 0;
+}
+
 static int ov772x_s_fmt(struct v4l2_subdev *sd, struct v4l2_format *f)
 {
 	struct i2c_client *client = sd->priv;
@@ -1060,8 +1109,11 @@ static struct v4l2_subdev_core_ops ov772x_subdev_core_ops = {
 
 static struct v4l2_subdev_video_ops ov772x_subdev_video_ops = {
 	.s_stream	= ov772x_s_stream,
+	.g_fmt		= ov772x_g_fmt,
 	.s_fmt		= ov772x_s_fmt,
 	.try_fmt	= ov772x_try_fmt,
+	.cropcap	= ov772x_cropcap,
+	.g_crop		= ov772x_g_crop,
 };
 
 static struct v4l2_subdev_ops ov772x_subdev_ops = {
@@ -1110,8 +1162,6 @@ static int ov772x_probe(struct i2c_client *client,
 	v4l2_i2c_subdev_init(&priv->subdev, client, &ov772x_subdev_ops);
 
 	icd->ops		= &ov772x_ops;
-	icd->rect_max.width	= MAX_WIDTH;
-	icd->rect_max.height	= MAX_HEIGHT;
 
 	ret = ov772x_video_probe(icd, client);
 	if (ret) {
diff --git a/drivers/media/video/pxa_camera.c b/drivers/media/video/pxa_camera.c
index 4cc3ebc..ee5f69e 100644
--- a/drivers/media/video/pxa_camera.c
+++ b/drivers/media/video/pxa_camera.c
@@ -232,6 +232,10 @@ struct pxa_camera_dev {
 	u32			save_cicr[5];
 };
 
+struct pxa_cam {
+	unsigned long flags;
+};
+
 static const char *pxa_cam_driver_description = "PXA_Camera";
 
 static unsigned int vid_limit = 16;	/* Video memory limit, in Mb */
@@ -246,7 +250,7 @@ static int pxa_videobuf_setup(struct videobuf_queue *vq, unsigned int *count,
 
 	dev_dbg(icd->dev.parent, "count=%d, size=%d\n", *count, *size);
 
-	*size = roundup(icd->rect_current.width * icd->rect_current.height *
+	*size = roundup(icd->user_width * icd->user_height *
 			((icd->current_fmt->depth + 7) >> 3), 8);
 
 	if (0 == *count)
@@ -450,12 +454,12 @@ static int pxa_videobuf_prepare(struct videobuf_queue *vq,
 	buf->inwork = 1;
 
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
 		vb->state	= VIDEOBUF_NEEDS_INIT;
 	}
@@ -1051,57 +1055,17 @@ static int test_platform_param(struct pxa_camera_dev *pcdev,
 	return 0;
 }
 
-static int pxa_camera_set_bus_param(struct soc_camera_device *icd, __u32 pixfmt)
+static void pxa_camera_setup_cicr(struct soc_camera_device *icd,
+				  unsigned long flags, __u32 pixfmt)
 {
 	struct soc_camera_host *ici = to_soc_camera_host(icd->dev.parent);
 	struct pxa_camera_dev *pcdev = ici->priv;
-	unsigned long dw, bpp, bus_flags, camera_flags, common_flags;
+	unsigned long dw, bpp;
 	u32 cicr0, cicr1, cicr2, cicr3, cicr4 = 0;
-	int ret = test_platform_param(pcdev, icd->buswidth, &bus_flags);
-
-	if (ret < 0)
-		return ret;
-
-	camera_flags = icd->ops->query_bus_param(icd);
-
-	common_flags = soc_camera_bus_param_compatible(camera_flags, bus_flags);
-	if (!common_flags)
-		return -EINVAL;
-
-	pcdev->channels = 1;
-
-	/* Make choises, based on platform preferences */
-	if ((common_flags & SOCAM_HSYNC_ACTIVE_HIGH) &&
-	    (common_flags & SOCAM_HSYNC_ACTIVE_LOW)) {
-		if (pcdev->platform_flags & PXA_CAMERA_HSP)
-			common_flags &= ~SOCAM_HSYNC_ACTIVE_HIGH;
-		else
-			common_flags &= ~SOCAM_HSYNC_ACTIVE_LOW;
-	}
-
-	if ((common_flags & SOCAM_VSYNC_ACTIVE_HIGH) &&
-	    (common_flags & SOCAM_VSYNC_ACTIVE_LOW)) {
-		if (pcdev->platform_flags & PXA_CAMERA_VSP)
-			common_flags &= ~SOCAM_VSYNC_ACTIVE_HIGH;
-		else
-			common_flags &= ~SOCAM_VSYNC_ACTIVE_LOW;
-	}
-
-	if ((common_flags & SOCAM_PCLK_SAMPLE_RISING) &&
-	    (common_flags & SOCAM_PCLK_SAMPLE_FALLING)) {
-		if (pcdev->platform_flags & PXA_CAMERA_PCP)
-			common_flags &= ~SOCAM_PCLK_SAMPLE_RISING;
-		else
-			common_flags &= ~SOCAM_PCLK_SAMPLE_FALLING;
-	}
-
-	ret = icd->ops->set_bus_param(icd, common_flags);
-	if (ret < 0)
-		return ret;
 
 	/* Datawidth is now guaranteed to be equal to one of the three values.
 	 * We fix bit-per-pixel equal to data-width... */
-	switch (common_flags & SOCAM_DATAWIDTH_MASK) {
+	switch (flags & SOCAM_DATAWIDTH_MASK) {
 	case SOCAM_DATAWIDTH_10:
 		dw = 4;
 		bpp = 0x40;
@@ -1122,18 +1086,18 @@ static int pxa_camera_set_bus_param(struct soc_camera_device *icd, __u32 pixfmt)
 		cicr4 |= CICR4_PCLK_EN;
 	if (pcdev->platform_flags & PXA_CAMERA_MCLK_EN)
 		cicr4 |= CICR4_MCLK_EN;
-	if (common_flags & SOCAM_PCLK_SAMPLE_FALLING)
+	if (flags & SOCAM_PCLK_SAMPLE_FALLING)
 		cicr4 |= CICR4_PCP;
-	if (common_flags & SOCAM_HSYNC_ACTIVE_LOW)
+	if (flags & SOCAM_HSYNC_ACTIVE_LOW)
 		cicr4 |= CICR4_HSP;
-	if (common_flags & SOCAM_VSYNC_ACTIVE_LOW)
+	if (flags & SOCAM_VSYNC_ACTIVE_LOW)
 		cicr4 |= CICR4_VSP;
 
 	cicr0 = __raw_readl(pcdev->base + CICR0);
 	if (cicr0 & CICR0_ENB)
 		__raw_writel(cicr0 & ~CICR0_ENB, pcdev->base + CICR0);
 
-	cicr1 = CICR1_PPL_VAL(icd->rect_current.width - 1) | bpp | dw;
+	cicr1 = CICR1_PPL_VAL(icd->user_width - 1) | bpp | dw;
 
 	switch (pixfmt) {
 	case V4L2_PIX_FMT_YUV422P:
@@ -1162,7 +1126,7 @@ static int pxa_camera_set_bus_param(struct soc_camera_device *icd, __u32 pixfmt)
 	}
 
 	cicr2 = 0;
-	cicr3 = CICR3_LPF_VAL(icd->rect_current.height - 1) |
+	cicr3 = CICR3_LPF_VAL(icd->user_height - 1) |
 		CICR3_BFW_VAL(min((unsigned short)255, icd->y_skip_top));
 	cicr4 |= pcdev->mclk_divisor;
 
@@ -1176,6 +1140,59 @@ static int pxa_camera_set_bus_param(struct soc_camera_device *icd, __u32 pixfmt)
 		CICR0_SIM_MP : (CICR0_SL_CAP_EN | CICR0_SIM_SP));
 	cicr0 |= CICR0_DMAEN | CICR0_IRQ_MASK;
 	__raw_writel(cicr0, pcdev->base + CICR0);
+}
+
+static int pxa_camera_set_bus_param(struct soc_camera_device *icd, __u32 pixfmt)
+{
+	struct soc_camera_host *ici = to_soc_camera_host(icd->dev.parent);
+	struct pxa_camera_dev *pcdev = ici->priv;
+	unsigned long bus_flags, camera_flags, common_flags;
+	int ret = test_platform_param(pcdev, icd->buswidth, &bus_flags);
+	struct pxa_cam *cam = icd->host_priv;
+
+	if (ret < 0)
+		return ret;
+
+	camera_flags = icd->ops->query_bus_param(icd);
+
+	common_flags = soc_camera_bus_param_compatible(camera_flags, bus_flags);
+	if (!common_flags)
+		return -EINVAL;
+
+	pcdev->channels = 1;
+
+	/* Make choises, based on platform preferences */
+	if ((common_flags & SOCAM_HSYNC_ACTIVE_HIGH) &&
+	    (common_flags & SOCAM_HSYNC_ACTIVE_LOW)) {
+		if (pcdev->platform_flags & PXA_CAMERA_HSP)
+			common_flags &= ~SOCAM_HSYNC_ACTIVE_HIGH;
+		else
+			common_flags &= ~SOCAM_HSYNC_ACTIVE_LOW;
+	}
+
+	if ((common_flags & SOCAM_VSYNC_ACTIVE_HIGH) &&
+	    (common_flags & SOCAM_VSYNC_ACTIVE_LOW)) {
+		if (pcdev->platform_flags & PXA_CAMERA_VSP)
+			common_flags &= ~SOCAM_VSYNC_ACTIVE_HIGH;
+		else
+			common_flags &= ~SOCAM_VSYNC_ACTIVE_LOW;
+	}
+
+	if ((common_flags & SOCAM_PCLK_SAMPLE_RISING) &&
+	    (common_flags & SOCAM_PCLK_SAMPLE_FALLING)) {
+		if (pcdev->platform_flags & PXA_CAMERA_PCP)
+			common_flags &= ~SOCAM_PCLK_SAMPLE_RISING;
+		else
+			common_flags &= ~SOCAM_PCLK_SAMPLE_FALLING;
+	}
+
+	cam->flags = common_flags;
+
+	ret = icd->ops->set_bus_param(icd, common_flags);
+	if (ret < 0)
+		return ret;
+
+	pxa_camera_setup_cicr(icd, common_flags, pixfmt);
 
 	return 0;
 }
@@ -1241,6 +1258,7 @@ static int pxa_camera_get_formats(struct soc_camera_device *icd, int idx,
 {
 	struct device *dev = icd->dev.parent;
 	int formats = 0, buswidth, ret;
+	struct pxa_cam *cam;
 
 	buswidth = required_buswidth(icd->formats + idx);
 
@@ -1251,6 +1269,16 @@ static int pxa_camera_get_formats(struct soc_camera_device *icd, int idx,
 	if (ret < 0)
 		return 0;
 
+	if (!icd->host_priv) {
+		cam = kzalloc(sizeof(*cam), GFP_KERNEL);
+		if (!cam)
+			return -ENOMEM;
+
+		icd->host_priv = cam;
+	} else {
+		cam = icd->host_priv;
+	}
+
 	switch (icd->formats[idx].fourcc) {
 	case V4L2_PIX_FMT_UYVY:
 		formats++;
@@ -1295,6 +1323,33 @@ static int pxa_camera_get_formats(struct soc_camera_device *icd, int idx,
 	return formats;
 }
 
+static void pxa_camera_put_formats(struct soc_camera_device *icd)
+{
+	kfree(icd->host_priv);
+	icd->host_priv = NULL;
+}
+
+static void pxa_camera_adjust_frame(struct v4l2_pix_format *pix)
+{
+	/* limit to pxa hardware capabilities */
+	if (pix->height < 32)
+		pix->height = 32;
+	if (pix->height > 2048)
+		pix->height = 2048;
+	if (pix->width < 48)
+		pix->width = 48;
+	if (pix->width > 2048)
+		pix->width = 2048;
+	pix->width &= ~0x01;
+}
+
+static int pxa_camera_check_frame(struct v4l2_pix_format *pix)
+{
+	/* limit to pxa hardware capabilities */
+	return pix->height < 32 || pix->height > 2048 || pix->width < 48 ||
+		pix->width > 2048 || (pix->width & 0x01);
+}
+
 static int pxa_camera_set_crop(struct soc_camera_device *icd,
 			       struct v4l2_crop *a)
 {
@@ -1307,6 +1362,9 @@ static int pxa_camera_set_crop(struct soc_camera_device *icd,
 		.master_clock = pcdev->mclk,
 		.pixel_clock_max = pcdev->ciclk / 4,
 	};
+	struct v4l2_format f;
+	struct v4l2_pix_format *pix = &f.fmt.pix, pix_tmp;
+	struct pxa_cam *cam = icd->host_priv;
 	int ret;
 
 	/* If PCLK is used to latch data from the sensor, check sense */
@@ -1320,7 +1378,34 @@ static int pxa_camera_set_crop(struct soc_camera_device *icd,
 	if (ret < 0) {
 		dev_warn(dev, "Failed to crop to %ux%u@%u:%u\n",
 			 rect->width, rect->height, rect->left, rect->top);
-	} else if (sense.flags & SOCAM_SENSE_PCLK_CHANGED) {
+		return ret;
+	}
+
+	f.type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
+
+	ret = v4l2_subdev_call(sd, video, g_fmt, &f);
+	if (ret < 0)
+		return ret;
+
+	pix_tmp = *pix;
+	if (pxa_camera_check_frame(pix)) {
+		/*
+		 * Camera cropping produced a frame beyond our capabilities.
+		 * FIXME: just extract a subframe, that we can process.
+		 */
+		pxa_camera_adjust_frame(pix);
+		ret = v4l2_subdev_call(sd, video, s_fmt, &f);
+		if (ret < 0)
+			return ret;
+
+		if (pxa_camera_check_frame(pix)) {
+			dev_warn(icd->dev.parent,
+				 "Inconsistent state. Use S_FMT to repair\n");
+			return -EINVAL;
+		}
+	}
+
+	if (sense.flags & SOCAM_SENSE_PCLK_CHANGED) {
 		if (sense.pixel_clock > sense.pixel_clock_max) {
 			dev_err(dev,
 				"pixel clock %lu set by the camera too high!",
@@ -1330,6 +1415,11 @@ static int pxa_camera_set_crop(struct soc_camera_device *icd,
 		recalculate_fifo_timeout(pcdev, sense.pixel_clock);
 	}
 
+	icd->user_width = pix->width;
+	icd->user_height = pix->height;
+
+	pxa_camera_setup_cicr(icd, cam->flags, icd->current_fmt->fourcc);
+
 	return ret;
 }
 
@@ -1370,6 +1460,11 @@ static int pxa_camera_set_fmt(struct soc_camera_device *icd,
 	if (ret < 0) {
 		dev_warn(dev, "Failed to configure for format %x\n",
 			 pix->pixelformat);
+	} else if (pxa_camera_check_frame(pix)) {
+		dev_warn(dev,
+			 "Camera driver produced an unsupported frame %dx%d\n",
+			 pix->width, pix->height);
+		ret = -EINVAL;
 	} else if (sense.flags & SOCAM_SENSE_PCLK_CHANGED) {
 		if (sense.pixel_clock > sense.pixel_clock_max) {
 			dev_err(dev,
@@ -1405,16 +1500,7 @@ static int pxa_camera_try_fmt(struct soc_camera_device *icd,
 		return -EINVAL;
 	}
 
-	/* limit to pxa hardware capabilities */
-	if (pix->height < 32)
-		pix->height = 32;
-	if (pix->height > 2048)
-		pix->height = 2048;
-	if (pix->width < 48)
-		pix->width = 48;
-	if (pix->width > 2048)
-		pix->width = 2048;
-	pix->width &= ~0x01;
+	pxa_camera_adjust_frame(pix);
 
 	/*
 	 * YUV422P planar format requires images size to be a 16 bytes
@@ -1549,6 +1635,7 @@ static struct soc_camera_host_ops pxa_soc_camera_host_ops = {
 	.resume		= pxa_camera_resume,
 	.set_crop	= pxa_camera_set_crop,
 	.get_formats	= pxa_camera_get_formats,
+	.put_formats	= pxa_camera_put_formats,
 	.set_fmt	= pxa_camera_set_fmt,
 	.try_fmt	= pxa_camera_try_fmt,
 	.init_videobuf	= pxa_camera_init_videobuf,
diff --git a/drivers/media/video/sh_mobile_ceu_camera.c b/drivers/media/video/sh_mobile_ceu_camera.c
index c752adc..4dd2469 100644
--- a/drivers/media/video/sh_mobile_ceu_camera.c
+++ b/drivers/media/video/sh_mobile_ceu_camera.c
@@ -74,6 +74,13 @@
 #define CDBYR2 0x98 /* Capture data bottom-field address Y register 2 */
 #define CDBCR2 0x9c /* Capture data bottom-field address C register 2 */
 
+#undef DEBUG_GEOMETRY
+#ifdef DEBUG_GEOMETRY
+#define dev_geo	dev_info
+#else
+#define dev_geo	dev_dbg
+#endif
+
 /* per video frame buffer */
 struct sh_mobile_ceu_buffer {
 	struct videobuf_buffer vb; /* v4l buffer must be first */
@@ -104,8 +111,9 @@ struct sh_mobile_ceu_dev {
 };
 
 struct sh_mobile_ceu_cam {
-	struct v4l2_rect camera_rect;
-	struct v4l2_rect camera_max;
+	struct v4l2_rect ceu_rect;
+	unsigned int cam_width;
+	unsigned int cam_height;
 	const struct soc_camera_data_format *extra_fmt;
 	const struct soc_camera_data_format *camera_fmt;
 };
@@ -157,7 +165,7 @@ static int sh_mobile_ceu_videobuf_setup(struct videobuf_queue *vq,
 	struct sh_mobile_ceu_dev *pcdev = ici->priv;
 	int bytes_per_pixel = (icd->current_fmt->depth + 7) >> 3;
 
-	*size = PAGE_ALIGN(icd->rect_current.width * icd->rect_current.height *
+	*size = PAGE_ALIGN(icd->user_width * icd->user_height *
 			   bytes_per_pixel);
 
 	if (0 == *count)
@@ -177,8 +185,10 @@ static void free_buffer(struct videobuf_queue *vq,
 			struct sh_mobile_ceu_buffer *buf)
 {
 	struct soc_camera_device *icd = vq->priv_data;
+	struct soc_camera_host *ici = to_soc_camera_host(icd->dev.parent);
+	struct device *dev = icd->dev.parent;
 
-	dev_dbg(icd->dev.parent, "%s (vb=0x%p) 0x%08lx %zd\n", __func__,
+	dev_dbg(dev, "%s (vb=0x%p) 0x%08lx %zd\n", __func__,
 		&buf->vb, buf->vb.baddr, buf->vb.bsize);
 
 	if (in_interrupt())
@@ -186,7 +196,7 @@ static void free_buffer(struct videobuf_queue *vq,
 
 	videobuf_waiton(&buf->vb, 0, 0);
 	videobuf_dma_contig_free(vq, &buf->vb);
-	dev_dbg(icd->dev.parent, "%s freed\n", __func__);
+	dev_dbg(dev, "%s freed\n", __func__);
 	buf->vb.state = VIDEOBUF_NEEDS_INIT;
 }
 
@@ -217,7 +227,7 @@ static void sh_mobile_ceu_capture(struct sh_mobile_ceu_dev *pcdev)
 	phys_addr_top = videobuf_to_dma_contig(pcdev->active);
 	ceu_write(pcdev, CDAYR, phys_addr_top);
 	if (pcdev->is_interlaced) {
-		phys_addr_bottom = phys_addr_top + icd->rect_current.width;
+		phys_addr_bottom = phys_addr_top + icd->user_width;
 		ceu_write(pcdev, CDBYR, phys_addr_bottom);
 	}
 
@@ -226,12 +236,12 @@ static void sh_mobile_ceu_capture(struct sh_mobile_ceu_dev *pcdev)
 	case V4L2_PIX_FMT_NV21:
 	case V4L2_PIX_FMT_NV16:
 	case V4L2_PIX_FMT_NV61:
-		phys_addr_top += icd->rect_current.width *
-			icd->rect_current.height;
+		phys_addr_top += icd->user_width *
+			icd->user_height;
 		ceu_write(pcdev, CDACR, phys_addr_top);
 		if (pcdev->is_interlaced) {
 			phys_addr_bottom = phys_addr_top +
-				icd->rect_current.width;
+				icd->user_width;
 			ceu_write(pcdev, CDBCR, phys_addr_bottom);
 		}
 	}
@@ -245,6 +255,7 @@ static int sh_mobile_ceu_videobuf_prepare(struct videobuf_queue *vq,
 					  enum v4l2_field field)
 {
 	struct soc_camera_device *icd = vq->priv_data;
+	struct soc_camera_host *ici = to_soc_camera_host(icd->dev.parent);
 	struct sh_mobile_ceu_buffer *buf;
 	int ret;
 
@@ -265,12 +276,12 @@ static int sh_mobile_ceu_videobuf_prepare(struct videobuf_queue *vq,
 	BUG_ON(NULL == icd->current_fmt);
 
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
 		vb->state	= VIDEOBUF_NEEDS_INIT;
 	}
@@ -455,18 +466,6 @@ static unsigned int size_dst(unsigned int src, unsigned int scale)
 		mant_pre * 4096 / scale + 1;
 }
 
-static unsigned int size_src(unsigned int dst, unsigned int scale)
-{
-	unsigned int mant_pre = scale >> 12, tmp;
-	if (!dst || !scale)
-		return dst;
-	for (tmp = ((dst - 1) * scale + 2048 * mant_pre) / 4096 + 1;
-	     size_dst(tmp, scale) < dst;
-	     tmp++)
-		;
-	return tmp;
-}
-
 static u16 calc_scale(unsigned int src, unsigned int *dst)
 {
 	u16 scale;
@@ -486,65 +485,46 @@ static u16 calc_scale(unsigned int src, unsigned int *dst)
 
 /* rect is guaranteed to not exceed the scaled camera rectangle */
 static void sh_mobile_ceu_set_rect(struct soc_camera_device *icd,
-				   struct v4l2_rect *rect)
+				   unsigned int out_width,
+				   unsigned int out_height)
 {
 	struct soc_camera_host *ici = to_soc_camera_host(icd->dev.parent);
 	struct sh_mobile_ceu_cam *cam = icd->host_priv;
+	struct v4l2_rect *rect = &cam->ceu_rect;
 	struct sh_mobile_ceu_dev *pcdev = ici->priv;
-	int width, height, cfszr_width, cdwdr_width, in_width, in_height;
-	unsigned int left_offset, top_offset, left, top;
-	unsigned int hscale = pcdev->cflcr & 0xffff;
-	unsigned int vscale = (pcdev->cflcr >> 16) & 0xffff;
+	unsigned int height, width, cdwdr_width, in_width, in_height;
+	unsigned int left_offset, top_offset;
 	u32 camor;
 
-	/* Switch to the camera scale */
-	left = size_src(rect->left, hscale);
-	top = size_src(rect->top, vscale);
-
-	dev_dbg(icd->dev.parent, "Left %u * 0x%x = %u, top %u * 0x%x = %u\n",
-		rect->left, hscale, left, rect->top, vscale, top);
-
-	if (left > cam->camera_rect.left) {
-		left_offset = left - cam->camera_rect.left;
-	} else {
-		left_offset = 0;
-		left = cam->camera_rect.left;
-	}
-
-	if (top > cam->camera_rect.top) {
-		top_offset = top - cam->camera_rect.top;
-	} else {
-		top_offset = 0;
-		top = cam->camera_rect.top;
-	}
+	dev_dbg(icd->dev.parent, "Crop %ux%u@%u:%u\n",
+		rect->width, rect->height, rect->left, rect->top);
 
-	dev_dbg(icd->dev.parent, "New left %u, top %u, offsets %u:%u\n",
-		rect->left, rect->top, left_offset, top_offset);
+	left_offset	= rect->left;
+	top_offset	= rect->top;
 
 	if (pcdev->image_mode) {
-		width = rect->width;
-		in_width = cam->camera_rect.width;
+		in_width = rect->width;
 		if (!pcdev->is_16bit) {
-			width *= 2;
 			in_width *= 2;
 			left_offset *= 2;
 		}
-		cfszr_width = cdwdr_width = rect->width;
+		width = cdwdr_width = out_width;
 	} else {
 		unsigned int w_factor = (icd->current_fmt->depth + 7) >> 3;
+
+		width = out_width * w_factor / 2;
+
 		if (!pcdev->is_16bit)
 			w_factor *= 2;
 
-		width = rect->width * w_factor / 2;
-		in_width = cam->camera_rect.width * w_factor / 2;
+		in_width = rect->width * w_factor / 2;
 		left_offset = left_offset * w_factor / 2;
 
-		cfszr_width = pcdev->is_16bit ? width : width / 2;
-		cdwdr_width = pcdev->is_16bit ? width * 2 : width;
+		cdwdr_width = width * 2;
 	}
 
-	height = rect->height;
-	in_height = cam->camera_rect.height;
+	height = out_height;
+	in_height = rect->height;
 	if (pcdev->is_interlaced) {
 		height /= 2;
 		in_height /= 2;
@@ -552,10 +532,17 @@ static void sh_mobile_ceu_set_rect(struct soc_camera_device *icd,
 		cdwdr_width *= 2;
 	}
 
+	/* Set CAMOR, CAPWR, CFSZR, take care of CDWDR */
 	camor = left_offset | (top_offset << 16);
+
+	dev_geo(icd->dev.parent,
+		"CAMOR 0x%x, CAPWR 0x%x, CFSZR 0x%x, CDWDR 0x%x\n", camor,
+		(in_height << 16) | in_width, (height << 16) | width,
+		cdwdr_width);
+
 	ceu_write(pcdev, CAMOR, camor);
 	ceu_write(pcdev, CAPWR, (in_height << 16) | in_width);
-	ceu_write(pcdev, CFSZR, (height << 16) | cfszr_width);
+	ceu_write(pcdev, CFSZR, (height << 16) | width);
 	ceu_write(pcdev, CDWDR, cdwdr_width);
 }
 
@@ -667,8 +654,8 @@ static int sh_mobile_ceu_set_bus_param(struct soc_camera_device *icd,
 	ceu_write(pcdev, CAPCR, 0x00300000);
 	ceu_write(pcdev, CAIFR, pcdev->is_interlaced ? 0x101 : 0);
 
+	sh_mobile_ceu_set_rect(icd, icd->user_width, icd->user_height);
 	mdelay(1);
-	sh_mobile_ceu_set_rect(icd, &icd->rect_current);
 
 	ceu_write(pcdev, CFLCR, pcdev->cflcr);
 
@@ -691,11 +678,10 @@ static int sh_mobile_ceu_set_bus_param(struct soc_camera_device *icd,
 	ceu_write(pcdev, CDOCR, value);
 	ceu_write(pcdev, CFWCR, 0); /* keep "datafetch firewall" disabled */
 
-	dev_dbg(icd->dev.parent, "S_FMT successful for %c%c%c%c %ux%u@%u:%u\n",
+	dev_dbg(icd->dev.parent, "S_FMT successful for %c%c%c%c %ux%u\n",
 		pixfmt & 0xff, (pixfmt >> 8) & 0xff,
 		(pixfmt >> 16) & 0xff, (pixfmt >> 24) & 0xff,
-		icd->rect_current.width, icd->rect_current.height,
-		icd->rect_current.left, icd->rect_current.top);
+		icd->user_width, icd->user_height);
 
 	capture_restore(pcdev, capsr);
 
@@ -748,6 +734,8 @@ static const struct soc_camera_data_format sh_mobile_ceu_formats[] = {
 static int sh_mobile_ceu_get_formats(struct soc_camera_device *icd, int idx,
 				     struct soc_camera_format_xlate *xlate)
 {
+	struct soc_camera_host *ici = to_soc_camera_host(icd->dev.parent);
+	struct device *dev = icd->dev.parent;
 	int ret, k, n;
 	int formats = 0;
 	struct sh_mobile_ceu_cam *cam;
@@ -762,7 +750,6 @@ static int sh_mobile_ceu_get_formats(struct soc_camera_device *icd, int idx,
 			return -ENOMEM;
 
 		icd->host_priv = cam;
-		cam->camera_max = icd->rect_max;
 	} else {
 		cam = icd->host_priv;
 	}
@@ -797,8 +784,7 @@ static int sh_mobile_ceu_get_formats(struct soc_camera_device *icd, int idx,
 			xlate->cam_fmt = icd->formats + idx;
 			xlate->buswidth = icd->formats[idx].depth;
 			xlate++;
-			dev_dbg(icd->dev.parent,
-				"Providing format %s using %s\n",
+			dev_dbg(dev, "Providing format %s using %s\n",
 				sh_mobile_ceu_formats[k].name,
 				icd->formats[idx].name);
 		}
@@ -811,7 +797,7 @@ add_single_format:
 			xlate->cam_fmt = icd->formats + idx;
 			xlate->buswidth = icd->formats[idx].depth;
 			xlate++;
-			dev_dbg(icd->dev.parent,
+			dev_dbg(dev,
 				"Providing format %s in pass-through mode\n",
 				icd->formats[idx].name);
 		}
@@ -840,176 +826,491 @@ static bool is_inside(struct v4l2_rect *r1, struct v4l2_rect *r2)
 		r1->top + r1->height < r2->top + r2->height;
 }
 
+static unsigned int scale_down(unsigned int size, unsigned int scale)
+{
+	return (size * 4096 + scale / 2) / scale;
+}
+
+static unsigned int scale_up(unsigned int size, unsigned int scale)
+{
+	return (size * scale + 2048) / 4096;
+}
+
+static unsigned int calc_generic_scale(unsigned int input, unsigned int output)
+{
+	return (input * 4096 + output / 2) / output;
+}
+
+static int client_g_rect(struct v4l2_subdev *sd, struct v4l2_rect *rect)
+{
+	struct v4l2_crop crop;
+	struct v4l2_cropcap cap;
+	int ret;
+
+	crop.type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
+
+	ret = v4l2_subdev_call(sd, video, g_crop, &crop);
+	if (!ret) {
+		*rect = crop.c;
+		return ret;
+	}
+
+	/* Camera driver doesn't support .g_crop(), assume default rectangle */
+	cap.type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
+
+	ret = v4l2_subdev_call(sd, video, cropcap, &cap);
+	if (ret < 0)
+		return ret;
+
+	*rect = cap.defrect;
+
+	return ret;
+}
+
 /*
- * CEU can scale and crop, but we don't want to waste bandwidth and kill the
- * framerate by always requesting the maximum image from the client. For
- * cropping we also have to take care of the current scale. The common for both
- * scaling and cropping approach is:
+ * The common for both scaling and cropping iterative approach is:
  * 1. try if the client can produce exactly what requested by the user
  * 2. if (1) failed, try to double the client image until we get one big enough
  * 3. if (2) failed, try to request the maximum image
  */
-static int sh_mobile_ceu_set_crop(struct soc_camera_device *icd,
-				  struct v4l2_crop *a)
+static int client_s_crop(struct v4l2_subdev *sd, struct v4l2_crop *crop,
+			 struct v4l2_crop *cam_crop)
 {
-	struct v4l2_rect *rect = &a->c;
-	struct soc_camera_host *ici = to_soc_camera_host(icd->dev.parent);
-	struct sh_mobile_ceu_dev *pcdev = ici->priv;
-	struct v4l2_crop cam_crop;
-	struct v4l2_rect *cam_rect = &cam_crop.c, target, cam_max;
-	struct sh_mobile_ceu_cam *cam = icd->host_priv;
-	struct v4l2_subdev *sd = soc_camera_to_subdev(icd);
-	unsigned int hscale = pcdev->cflcr & 0xffff;
-	unsigned int vscale = (pcdev->cflcr >> 16) & 0xffff;
-	unsigned short width, height;
-	u32 capsr;
+	struct v4l2_rect *rect = &crop->c, *cam_rect = &cam_crop->c;
+	struct device *dev = sd->v4l2_dev->dev;
+	struct v4l2_cropcap cap;
 	int ret;
+	unsigned int width, height;
 
-	/* Scale back up into client units */
-	cam_rect->left	= size_src(rect->left, hscale);
-	cam_rect->width	= size_src(rect->width, hscale);
-	cam_rect->top	= size_src(rect->top, vscale);
-	cam_rect->height	= size_src(rect->height, vscale);
-
-	target = *cam_rect;
+	v4l2_subdev_call(sd, video, s_crop, crop);
+	ret = client_g_rect(sd, cam_rect);
+	if (ret < 0)
+		return ret;
 
-	capsr = capture_save_reset(pcdev);
-	dev_dbg(icd->dev.parent, "CAPSR 0x%x, CFLCR 0x%x\n",
-		capsr, pcdev->cflcr);
-
-	/* First attempt - see if the client can deliver a perfect result */
-	ret = v4l2_subdev_call(sd, video, s_crop, &cam_crop);
-	if (!ret && !memcmp(&target, &cam_rect, sizeof(target))) {
-		dev_dbg(icd->dev.parent,
-			"Camera S_CROP successful for %ux%u@%u:%u\n",
-			cam_rect->width, cam_rect->height,
-			cam_rect->left, cam_rect->top);
-		goto ceu_set_rect;
+	/*
+	 * Now cam_crop contains the current camera input rectangle, and it must
+	 * be within camera cropcap bounds
+	 */
+	if (!memcmp(rect, cam_rect, sizeof(*rect))) {
+		/* Even if camera S_CROP failed, but camera rectangle matches */
+		dev_dbg(dev, "Camera S_CROP successful for %ux%u@%u:%u\n",
+			rect->width, rect->height, rect->left, rect->top);
+		return 0;
 	}
 
-	/* Try to fix cropping, that camera hasn't managed to do */
-	dev_dbg(icd->dev.parent, "Fix camera S_CROP %d for %ux%u@%u:%u"
-		" to %ux%u@%u:%u\n",
-		ret, cam_rect->width, cam_rect->height,
+	/* Try to fix cropping, that camera hasn't managed to set */
+	dev_geo(dev, "Fix camera S_CROP for %ux%u@%u:%u to %ux%u@%u:%u\n",
+		cam_rect->width, cam_rect->height,
 		cam_rect->left, cam_rect->top,
-		target.width, target.height, target.left, target.top);
+		rect->width, rect->height, rect->left, rect->top);
+
+	/* We need sensor maximum rectangle */
+	ret = v4l2_subdev_call(sd, video, cropcap, &cap);
+	if (ret < 0)
+		return ret;
+
+	soc_camera_limit_side(&rect->left, &rect->width, cap.bounds.left, 2,
+			      cap.bounds.width);
+	soc_camera_limit_side(&rect->top, &rect->height, cap.bounds.top, 4,
+			      cap.bounds.height);
 
 	/*
 	 * Popular special case - some cameras can only handle fixed sizes like
 	 * QVGA, VGA,... Take care to avoid infinite loop.
 	 */
-	width = max(cam_rect->width, 1);
-	height = max(cam_rect->height, 1);
-	cam_max.width = size_src(icd->rect_max.width, hscale);
-	cam_max.left = size_src(icd->rect_max.left, hscale);
-	cam_max.height = size_src(icd->rect_max.height, vscale);
-	cam_max.top = size_src(icd->rect_max.top, vscale);
-	while (!ret && (is_smaller(cam_rect, &target) ||
-			is_inside(cam_rect, &target)) &&
-	       cam_max.width >= width && cam_max.height >= height) {
+	width = max(cam_rect->width, 2);
+	height = max(cam_rect->height, 2);
+
+	while (!ret && (is_smaller(cam_rect, rect) ||
+			is_inside(cam_rect, rect)) &&
+	       (cap.bounds.width > width || cap.bounds.height > height)) {
 
 		width *= 2;
 		height *= 2;
+
 		cam_rect->width = width;
 		cam_rect->height = height;
 
-		/* We do not know what the camera is capable of, play safe */
-		if (cam_rect->left > target.left)
-			cam_rect->left = cam_max.left;
+		/*
+		 * We do not know what capabilities the camera has to set up
+		 * left and top borders. We could try to be smarter in iterating
+		 * them, e.g., if camera current left is to the right of the
+		 * target left, set it to the middle point between the current
+		 * left and minimum left. But that would add too much
+		 * complexity: we would have to iterate each border separately.
+		 */
+		if (cam_rect->left > rect->left)
+			cam_rect->left = cap.bounds.left;
 
-		if (cam_rect->left + cam_rect->width < target.left + target.width)
-			cam_rect->width = target.left + target.width -
+		if (cam_rect->left + cam_rect->width < rect->left + rect->width)
+			cam_rect->width = rect->left + rect->width -
 				cam_rect->left;
 
-		if (cam_rect->top > target.top)
-			cam_rect->top = cam_max.top;
+		if (cam_rect->top > rect->top)
+			cam_rect->top = cap.bounds.top;
 
-		if (cam_rect->top + cam_rect->height < target.top + target.height)
-			cam_rect->height = target.top + target.height -
+		if (cam_rect->top + cam_rect->height < rect->top + rect->height)
+			cam_rect->height = rect->top + rect->height -
 				cam_rect->top;
 
-		if (cam_rect->width + cam_rect->left >
-		    cam_max.width + cam_max.left)
-			cam_rect->left = max(cam_max.width + cam_max.left -
-					     cam_rect->width, cam_max.left);
-
-		if (cam_rect->height + cam_rect->top >
-		    cam_max.height + cam_max.top)
-			cam_rect->top = max(cam_max.height + cam_max.top -
-					    cam_rect->height, cam_max.top);
-
-		ret = v4l2_subdev_call(sd, video, s_crop, &cam_crop);
-		dev_dbg(icd->dev.parent, "Camera S_CROP %d for %ux%u@%u:%u\n",
-			ret, cam_rect->width, cam_rect->height,
+		v4l2_subdev_call(sd, video, s_crop, cam_crop);
+		ret = client_g_rect(sd, cam_rect);
+		dev_geo(dev, "Camera S_CROP %d for %ux%u@%u:%u\n", ret,
+			cam_rect->width, cam_rect->height,
 			cam_rect->left, cam_rect->top);
 	}
 
-	/*
-	 * If the camera failed to configure cropping, it should not modify the
-	 * rectangle
-	 */
-	if ((ret < 0 && (is_smaller(&icd->rect_current, rect) ||
-			 is_inside(&icd->rect_current, rect))) ||
-	    is_smaller(cam_rect, &target) || is_inside(cam_rect, &target)) {
+	/* S_CROP must not modify the rectangle */
+	if (is_smaller(cam_rect, rect) || is_inside(cam_rect, rect)) {
 		/*
 		 * The camera failed to configure a suitable cropping,
 		 * we cannot use the current rectangle, set to max
 		 */
-		*cam_rect = cam_max;
-		ret = v4l2_subdev_call(sd, video, s_crop, &cam_crop);
-		dev_dbg(icd->dev.parent,
-			"Camera S_CROP %d for max %ux%u@%u:%u\n",
-			ret, cam_rect->width, cam_rect->height,
+		*cam_rect = cap.bounds;
+		v4l2_subdev_call(sd, video, s_crop, cam_crop);
+		ret = client_g_rect(sd, cam_rect);
+		dev_geo(dev, "Camera S_CROP %d for max %ux%u@%u:%u\n", ret,
+			cam_rect->width, cam_rect->height,
 			cam_rect->left, cam_rect->top);
-		if (ret < 0 && ret != -ENOIOCTLCMD)
-			/* All failed, hopefully resume current capture */
-			goto resume_capture;
-
-		/* Finally, adjust the target rectangle */
-		if (target.width > cam_rect->width)
-			target.width = cam_rect->width;
-		if (target.height > cam_rect->height)
-			target.height = cam_rect->height;
-		if (target.left + target.width > cam_rect->left + cam_rect->width)
-			target.left = cam_rect->left + cam_rect->width -
-				target.width;
-		if (target.top + target.height > cam_rect->top + cam_rect->height)
-			target.top = cam_rect->top + cam_rect->height -
-				target.height;
 	}
 
-	/* We now have a rectangle, larger than requested, let's crop */
+	return ret;
+}
+
+static int get_camera_scales(struct v4l2_subdev *sd, struct v4l2_rect *rect,
+			     unsigned int *scale_h, unsigned int *scale_v)
+{
+	struct v4l2_format f;
+	int ret;
+
+	f.type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
+
+	ret = v4l2_subdev_call(sd, video, g_fmt, &f);
+	if (ret < 0)
+		return ret;
+
+	*scale_h = calc_generic_scale(rect->width, f.fmt.pix.width);
+	*scale_v = calc_generic_scale(rect->height, f.fmt.pix.height);
+
+	return 0;
+}
+
+static int get_camera_subwin(struct soc_camera_device *icd,
+			     struct v4l2_rect *cam_subrect,
+			     unsigned int cam_hscale, unsigned int cam_vscale)
+{
+	struct sh_mobile_ceu_cam *cam = icd->host_priv;
+	struct v4l2_rect *ceu_rect = &cam->ceu_rect;
+
+	if (!ceu_rect->width) {
+		struct soc_camera_host *ici =
+			to_soc_camera_host(icd->dev.parent);
+		struct v4l2_subdev *sd = soc_camera_to_subdev(icd);
+		struct device *dev = icd->dev.parent;
+		struct v4l2_format f;
+		struct v4l2_pix_format *pix = &f.fmt.pix;
+		int ret;
+		/* First time */
+
+		f.type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
+
+		ret = v4l2_subdev_call(sd, video, g_fmt, &f);
+		if (ret < 0)
+			return ret;
+
+		dev_geo(dev, "camera fmt %ux%u\n", pix->width, pix->height);
+
+		if (pix->width > 2560) {
+			ceu_rect->width	 = 2560;
+			ceu_rect->left	 = (pix->width - 2560) / 2;
+		} else {
+			ceu_rect->width	 = pix->width;
+			ceu_rect->left	 = 0;
+		}
+
+		if (pix->height > 1920) {
+			ceu_rect->height = 1920;
+			ceu_rect->top	 = (pix->height - 1920) / 2;
+		} else {
+			ceu_rect->height = pix->height;
+			ceu_rect->top	 = 0;
+		}
+
+		dev_geo(dev, "initialised CEU rect %ux%u@%u:%u\n",
+			ceu_rect->width, ceu_rect->height,
+			ceu_rect->left, ceu_rect->top);
+	}
+
+	cam_subrect->width	= scale_up(ceu_rect->width, cam_hscale);
+	cam_subrect->left	= scale_up(ceu_rect->left, cam_hscale);
+	cam_subrect->height	= scale_up(ceu_rect->height, cam_vscale);
+	cam_subrect->top	= scale_up(ceu_rect->top, cam_vscale);
+
+	return 0;
+}
+
+static int client_s_fmt(struct soc_camera_device *icd, struct v4l2_format *f,
+			bool ceu_can_scale)
+{
+	struct v4l2_subdev *sd = soc_camera_to_subdev(icd);
+	struct soc_camera_host *ici = to_soc_camera_host(icd->dev.parent);
+	struct device *dev = icd->dev.parent;
+	struct v4l2_pix_format *pix = &f->fmt.pix;
+	unsigned int width = pix->width, height = pix->height, tmp_w, tmp_h;
+	unsigned int max_width, max_height;
+	struct v4l2_cropcap cap;
+	int ret;
+
+	cap.type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
+
+	ret = v4l2_subdev_call(sd, video, cropcap, &cap);
+	if (ret < 0)
+		return ret;
+
+	max_width = min(cap.bounds.width, 2560);
+	max_height = min(cap.bounds.height, 1920);
+
+	ret = v4l2_subdev_call(sd, video, s_fmt, f);
+	if (ret < 0)
+		return ret;
+
+	dev_geo(dev, "camera scaled to %ux%u\n", pix->width, pix->height);
+
+	if ((width == pix->width && height == pix->height) || !ceu_can_scale)
+		return 0;
+
+	/* Camera set a format, but geometry is not precise, try to improve */
+	tmp_w = pix->width;
+	tmp_h = pix->height;
+
+	/* width <= max_width && height <= max_height - guaranteed by try_fmt */
+	while ((width > tmp_w || height > tmp_h) &&
+	       tmp_w < max_width && tmp_h < max_height) {
+		tmp_w = min(2 * tmp_w, max_width);
+		tmp_h = min(2 * tmp_h, max_height);
+		pix->width = tmp_w;
+		pix->height = tmp_h;
+		ret = v4l2_subdev_call(sd, video, s_fmt, f);
+		dev_geo(dev, "Camera scaled to %ux%u\n",
+			pix->width, pix->height);
+		if (ret < 0) {
+			/* This shouldn't happen */
+			dev_err(dev, "Client failed to set format: %d\n", ret);
+			return ret;
+		}
+	}
+
+	return 0;
+}
+
+/**
+ * @rect	- camera cropped rectangle
+ * @sub_rect	- CEU cropped rectangle, mapped back to camera input area
+ * @ceu_rect	- on output calculated CEU crop rectangle
+ */
+static int client_scale(struct soc_camera_device *icd, struct v4l2_rect *rect,
+			struct v4l2_rect *sub_rect, struct v4l2_rect *ceu_rect,
+			struct v4l2_format *f, bool ceu_can_scale)
+{
+	struct v4l2_subdev *sd = soc_camera_to_subdev(icd);
+	struct soc_camera_host *ici = to_soc_camera_host(icd->dev.parent);
+	struct sh_mobile_ceu_cam *cam = icd->host_priv;
+	struct device *dev = icd->dev.parent;
+	struct v4l2_format f_tmp = *f;
+	struct v4l2_pix_format *pix_tmp = &f_tmp.fmt.pix;
+	unsigned int scale_h, scale_v;
+	int ret;
+
+	/* 5. Apply iterative camera S_FMT for camera user window. */
+	ret = client_s_fmt(icd, &f_tmp, ceu_can_scale);
+	if (ret < 0)
+		return ret;
+
+	dev_geo(dev, "5: camera scaled to %ux%u\n",
+		pix_tmp->width, pix_tmp->height);
+
+	/* 6. Retrieve camera output window (g_fmt) */
+
+	/* unneeded - it is already in "f_tmp" */
+
+	/* 7. Calculate new camera scales. */
+	ret = get_camera_scales(sd, rect, &scale_h, &scale_v);
+	if (ret < 0)
+		return ret;
+
+	dev_geo(dev, "7: camera scales %u:%u\n", scale_h, scale_v);
+
+	cam->cam_width		= pix_tmp->width;
+	cam->cam_height		= pix_tmp->height;
+	f->fmt.pix.width	= pix_tmp->width;
+	f->fmt.pix.height	= pix_tmp->height;
 
 	/*
-	 * We have to preserve camera rectangle between close() / open(),
-	 * because soc-camera core calls .set_fmt() on each first open() with
-	 * last before last close() _user_ rectangle, which can be different
-	 * from camera rectangle.
+	 * 8. Calculate new CEU crop - apply camera scales to previously
+	 *    calculated "effective" crop.
 	 */
-	dev_dbg(icd->dev.parent,
-		"SH S_CROP from %ux%u@%u:%u to %ux%u@%u:%u, scale to %ux%u@%u:%u\n",
-		cam_rect->width, cam_rect->height, cam_rect->left, cam_rect->top,
-		target.width, target.height, target.left, target.top,
-		rect->width, rect->height, rect->left, rect->top);
+	ceu_rect->left = scale_down(sub_rect->left, scale_h);
+	ceu_rect->width = scale_down(sub_rect->width, scale_h);
+	ceu_rect->top = scale_down(sub_rect->top, scale_v);
+	ceu_rect->height = scale_down(sub_rect->height, scale_v);
+
+	dev_geo(dev, "8: new CEU rect %ux%u@%u:%u\n",
+		ceu_rect->width, ceu_rect->height,
+		ceu_rect->left, ceu_rect->top);
+
+	return 0;
+}
+
+/* Get combined scales */
+static int get_scales(struct soc_camera_device *icd,
+		      unsigned int *scale_h, unsigned int *scale_v)
+{
+	struct sh_mobile_ceu_cam *cam = icd->host_priv;
+	struct v4l2_subdev *sd = soc_camera_to_subdev(icd);
+	struct v4l2_crop cam_crop;
+	unsigned int width_in, height_in;
+	int ret;
 
-	ret = 0;
+	cam_crop.type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
 
-ceu_set_rect:
-	cam->camera_rect = *cam_rect;
+	ret = client_g_rect(sd, &cam_crop.c);
+	if (ret < 0)
+		return ret;
 
-	rect->width	= size_dst(target.width, hscale);
-	rect->left	= size_dst(target.left, hscale);
-	rect->height	= size_dst(target.height, vscale);
-	rect->top	= size_dst(target.top, vscale);
+	ret = get_camera_scales(sd, &cam_crop.c, scale_h, scale_v);
+	if (ret < 0)
+		return ret;
 
-	sh_mobile_ceu_set_rect(icd, rect);
+	width_in = scale_up(cam->ceu_rect.width, *scale_h);
+	height_in = scale_up(cam->ceu_rect.height, *scale_v);
 
-resume_capture:
-	/* Set CAMOR, CAPWR, CFSZR, take care of CDWDR */
+	*scale_h = calc_generic_scale(cam->ceu_rect.width, icd->user_width);
+	*scale_v = calc_generic_scale(cam->ceu_rect.height, icd->user_height);
+
+	return 0;
+}
+
+/*
+ * CEU can scale and crop, but we don't want to waste bandwidth and kill the
+ * framerate by always requesting the maximum image from the client. See
+ * Documentation/video4linux/sh_mobile_camera_ceu.txt for a description of
+ * scaling and cropping algorithms and for the meaning of referenced here steps.
+ */
+static int sh_mobile_ceu_set_crop(struct soc_camera_device *icd,
+				  struct v4l2_crop *a)
+{
+	struct v4l2_rect *rect = &a->c;
+	struct soc_camera_host *ici = to_soc_camera_host(icd->dev.parent);
+	struct sh_mobile_ceu_dev *pcdev = ici->priv;
+	struct v4l2_crop cam_crop;
+	struct sh_mobile_ceu_cam *cam = icd->host_priv;
+	struct v4l2_rect *cam_rect = &cam_crop.c, *ceu_rect = &cam->ceu_rect;
+	struct v4l2_subdev *sd = soc_camera_to_subdev(icd);
+	struct device *dev = icd->dev.parent;
+	struct v4l2_format f;
+	struct v4l2_pix_format *pix = &f.fmt.pix;
+	unsigned int scale_comb_h, scale_comb_v, scale_ceu_h, scale_ceu_v,
+		out_width, out_height;
+	u32 capsr, cflcr;
+	int ret;
+
+	/* 1. Calculate current combined scales. */
+	ret = get_scales(icd, &scale_comb_h, &scale_comb_v);
+	if (ret < 0)
+		return ret;
+
+	dev_geo(dev, "1: combined scales %u:%u\n", scale_comb_h, scale_comb_v);
+
+	/* 2. Apply iterative camera S_CROP for new input window. */
+	ret = client_s_crop(sd, a, &cam_crop);
+	if (ret < 0)
+		return ret;
+
+	dev_geo(dev, "2: camera cropped to %ux%u@%u:%u\n",
+		cam_rect->width, cam_rect->height,
+		cam_rect->left, cam_rect->top);
+
+	/* On success cam_crop contains current camera crop */
+
+	/*
+	 * 3. If old combined scales applied to new crop produce an impossible
+	 *    user window, adjust scales to produce nearest possible window.
+	 */
+	out_width	= scale_down(rect->width, scale_comb_h);
+	out_height	= scale_down(rect->height, scale_comb_v);
+
+	if (out_width > 2560)
+		out_width = 2560;
+	else if (out_width < 2)
+		out_width = 2;
+
+	if (out_height > 1920)
+		out_height = 1920;
+	else if (out_height < 4)
+		out_height = 4;
+
+	dev_geo(dev, "3: Adjusted output %ux%u\n", out_width, out_height);
+
+	/* 4. Use G_CROP to retrieve actual input window: already in cam_crop */
+
+	/*
+	 * 5. Using actual input window and calculated combined scales calculate
+	 *    camera target output window.
+	 */
+	pix->width		= scale_down(cam_rect->width, scale_comb_h);
+	pix->height		= scale_down(cam_rect->height, scale_comb_v);
+
+	dev_geo(dev, "5: camera target %ux%u\n", pix->width, pix->height);
+
+	/* 6. - 9. */
+	pix->pixelformat	= cam->camera_fmt->fourcc;
+	pix->colorspace		= cam->camera_fmt->colorspace;
+
+	capsr = capture_save_reset(pcdev);
+	dev_dbg(dev, "CAPSR 0x%x, CFLCR 0x%x\n", capsr, pcdev->cflcr);
+
+	/* Make relative to camera rectangle */
+	rect->left		-= cam_rect->left;
+	rect->top		-= cam_rect->top;
+
+	f.type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
+
+	ret = client_scale(icd, cam_rect, rect, ceu_rect, &f,
+			   pcdev->image_mode && !pcdev->is_interlaced);
+
+	dev_geo(dev, "6-9: %d\n", ret);
+
+	/* 10. Use CEU cropping to crop to the new window. */
+	sh_mobile_ceu_set_rect(icd, out_width, out_height);
+
+	dev_geo(dev, "10: CEU cropped to %ux%u@%u:%u\n",
+		ceu_rect->width, ceu_rect->height,
+		ceu_rect->left, ceu_rect->top);
+
+	/*
+	 * 11. Calculate CEU scales from camera scales from results of (10) and
+	 *     user window from (3)
+	 */
+	scale_ceu_h = calc_scale(ceu_rect->width, &out_width);
+	scale_ceu_v = calc_scale(ceu_rect->height, &out_height);
+
+	dev_geo(dev, "11: CEU scales %u:%u\n", scale_ceu_h, scale_ceu_v);
+
+	/* 12. Apply CEU scales. */
+	cflcr = scale_ceu_h | (scale_ceu_v << 16);
+	if (cflcr != pcdev->cflcr) {
+		pcdev->cflcr = cflcr;
+		ceu_write(pcdev, CFLCR, cflcr);
+	}
+
+	/* Restore capture */
 	if (pcdev->active)
 		capsr |= 1;
 	capture_restore(pcdev, capsr);
 
+	icd->user_width = out_width;
+	icd->user_height = out_height;
+
 	/* Even if only camera cropping succeeded */
 	return ret;
 }
@@ -1022,121 +1323,137 @@ static int sh_mobile_ceu_set_fmt(struct soc_camera_device *icd,
 	struct sh_mobile_ceu_dev *pcdev = ici->priv;
 	struct sh_mobile_ceu_cam *cam = icd->host_priv;
 	struct v4l2_pix_format *pix = &f->fmt.pix;
+	struct v4l2_format cam_f = *f;
+	struct v4l2_pix_format *cam_pix = &cam_f.fmt.pix;
 	struct v4l2_subdev *sd = soc_camera_to_subdev(icd);
+	struct device *dev = icd->dev.parent;
 	__u32 pixfmt = pix->pixelformat;
 	const struct soc_camera_format_xlate *xlate;
-	unsigned int width = pix->width, height = pix->height, tmp_w, tmp_h;
-	u16 vscale, hscale;
-	int ret, is_interlaced;
+	struct v4l2_crop cam_crop;
+	struct v4l2_rect *cam_rect = &cam_crop.c, cam_subrect, ceu_rect;
+	unsigned int scale_cam_h, scale_cam_v;
+	u16 scale_v, scale_h;
+	int ret;
+	bool is_interlaced, image_mode;
 
 	switch (pix->field) {
 	case V4L2_FIELD_INTERLACED:
-		is_interlaced = 1;
+		is_interlaced = true;
 		break;
 	case V4L2_FIELD_ANY:
 	default:
 		pix->field = V4L2_FIELD_NONE;
 		/* fall-through */
 	case V4L2_FIELD_NONE:
-		is_interlaced = 0;
+		is_interlaced = false;
 		break;
 	}
 
 	xlate = soc_camera_xlate_by_fourcc(icd, pixfmt);
 	if (!xlate) {
-		dev_warn(icd->dev.parent, "Format %x not found\n", pixfmt);
+		dev_warn(dev, "Format %x not found\n", pixfmt);
 		return -EINVAL;
 	}
 
-	pix->pixelformat = xlate->cam_fmt->fourcc;
-	ret = v4l2_subdev_call(sd, video, s_fmt, f);
-	pix->pixelformat = pixfmt;
-	dev_dbg(icd->dev.parent,
-		"Camera %d fmt %ux%u, requested %ux%u, max %ux%u\n",
-		ret, pix->width, pix->height, width, height,
-		icd->rect_max.width, icd->rect_max.height);
+	/* 1. Calculate current camera scales. */
+	cam_crop.type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
+
+	ret = client_g_rect(sd, cam_rect);
+	if (ret < 0)
+		return ret;
+
+	ret = get_camera_scales(sd, cam_rect, &scale_cam_h, &scale_cam_v);
+	if (ret < 0)
+		return ret;
+
+	dev_geo(dev, "1: camera scales %u:%u\n", scale_cam_h, scale_cam_v);
+
+	/*
+	 * 2. Calculate "effective" input crop (sensor subwindow) - CEU crop
+	 *    scaled back at current camera scales onto input window.
+	 */
+	ret = get_camera_subwin(icd, &cam_subrect, scale_cam_h, scale_cam_v);
 	if (ret < 0)
 		return ret;
 
+	dev_geo(dev, "2: subwin %ux%u@%u:%u\n",
+		cam_subrect.width, cam_subrect.height,
+		cam_subrect.left, cam_subrect.top);
+
+	/*
+	 * 3. Calculate new combined scales from "effective" input window to
+	 *    requested user window.
+	 */
+	scale_h = calc_generic_scale(cam_subrect.width, pix->width);
+	scale_v = calc_generic_scale(cam_subrect.height, pix->height);
+
+	dev_geo(dev, "3: scales %u:%u\n", scale_h, scale_v);
+
+	/*
+	 * 4. Calculate camera output window by applying combined scales to real
+	 *    input window.
+	 */
+	cam_pix->width = scale_down(cam_rect->width, scale_h);
+	cam_pix->height = scale_down(cam_rect->height, scale_v);
+	cam_pix->pixelformat = xlate->cam_fmt->fourcc;
+
 	switch (pixfmt) {
 	case V4L2_PIX_FMT_NV12:
 	case V4L2_PIX_FMT_NV21:
 	case V4L2_PIX_FMT_NV16:
 	case V4L2_PIX_FMT_NV61:
-		pcdev->image_mode = 1;
+		image_mode = true;
 		break;
 	default:
-		pcdev->image_mode = 0;
+		image_mode = false;
 	}
 
-	if ((abs(width - pix->width) < 4 && abs(height - pix->height) < 4) ||
-	    !pcdev->image_mode || is_interlaced) {
-		hscale = 0;
-		vscale = 0;
-		goto out;
-	}
+	dev_geo(dev, "4: camera output %ux%u\n",
+		cam_pix->width, cam_pix->height);
 
-	/* Camera set a format, but geometry is not precise, try to improve */
-	/*
-	 * FIXME: when soc-camera is converted to implement traditional S_FMT
-	 * and S_CROP semantics, replace CEU limits with camera maxima
-	 */
-	tmp_w = pix->width;
-	tmp_h = pix->height;
-	while ((width > tmp_w || height > tmp_h) &&
-	       tmp_w < 2560 && tmp_h < 1920) {
-		tmp_w = min(2 * tmp_w, (__u32)2560);
-		tmp_h = min(2 * tmp_h, (__u32)1920);
-		pix->width = tmp_w;
-		pix->height = tmp_h;
-		pix->pixelformat = xlate->cam_fmt->fourcc;
-		ret = v4l2_subdev_call(sd, video, s_fmt, f);
-		pix->pixelformat = pixfmt;
-		dev_dbg(icd->dev.parent, "Camera scaled to %ux%u\n",
-			pix->width, pix->height);
-		if (ret < 0) {
-			/* This shouldn't happen */
-			dev_err(icd->dev.parent,
-				"Client failed to set format: %d\n", ret);
-			return ret;
-		}
-	}
+	/* 5. - 9. */
+	ret = client_scale(icd, cam_rect, &cam_subrect, &ceu_rect, &cam_f,
+			   image_mode && !is_interlaced);
+
+	dev_geo(dev, "5-9: client scale %d\n", ret);
+
+	/* Done with the camera. Now see if we can improve the result */
+
+	dev_dbg(dev, "Camera %d fmt %ux%u, requested %ux%u\n",
+		ret, cam_pix->width, cam_pix->height, pix->width, pix->height);
+	if (ret < 0)
+		return ret;
+
+	/* 10. Use CEU scaling to scale to the requested user window. */
 
 	/* We cannot scale up */
-	if (width > pix->width)
-		width = pix->width;
+	if (pix->width > cam_pix->width)
+		pix->width = cam_pix->width;
+	if (pix->width > ceu_rect.width)
+		pix->width = ceu_rect.width;
 
-	if (height > pix->height)
-		height = pix->height;
+	if (pix->height > cam_pix->height)
+		pix->height = cam_pix->height;
+	if (pix->height > ceu_rect.height)
+		pix->height = ceu_rect.height;
 
 	/* Let's rock: scale pix->{width x height} down to width x height */
-	hscale = calc_scale(pix->width, &width);
-	vscale = calc_scale(pix->height, &height);
+	scale_h = calc_scale(ceu_rect.width, &pix->width);
+	scale_v = calc_scale(ceu_rect.height, &pix->height);
 
-	dev_dbg(icd->dev.parent, "W: %u : 0x%x = %u, H: %u : 0x%x = %u\n",
-		pix->width, hscale, width, pix->height, vscale, height);
+	dev_geo(dev, "10: W: %u : 0x%x = %u, H: %u : 0x%x = %u\n",
+		ceu_rect.width, scale_h, pix->width,
+		ceu_rect.height, scale_v, pix->height);
 
-out:
-	pcdev->cflcr = hscale | (vscale << 16);
+	pcdev->cflcr = scale_h | (scale_v << 16);
 
 	icd->buswidth = xlate->buswidth;
 	icd->current_fmt = xlate->host_fmt;
 	cam->camera_fmt = xlate->cam_fmt;
-	cam->camera_rect.width = pix->width;
-	cam->camera_rect.height = pix->height;
-
-	icd->rect_max.left = size_dst(cam->camera_max.left, hscale);
-	icd->rect_max.width = size_dst(cam->camera_max.width, hscale);
-	icd->rect_max.top = size_dst(cam->camera_max.top, vscale);
-	icd->rect_max.height = size_dst(cam->camera_max.height, vscale);
-
-	icd->rect_current.left = icd->rect_max.left;
-	icd->rect_current.top = icd->rect_max.top;
+	cam->ceu_rect = ceu_rect;
 
 	pcdev->is_interlaced = is_interlaced;
-
-	pix->width = width;
-	pix->height = height;
+	pcdev->image_mode = image_mode;
 
 	return 0;
 }
diff --git a/drivers/media/video/soc_camera.c b/drivers/media/video/soc_camera.c
index c6cccdf..86e0648 100644
--- a/drivers/media/video/soc_camera.c
+++ b/drivers/media/video/soc_camera.c
@@ -278,6 +278,9 @@ static void soc_camera_free_user_formats(struct soc_camera_device *icd)
 	icd->user_formats = NULL;
 }
 
+#define pixfmtstr(x) (x) & 0xff, ((x) >> 8) & 0xff, ((x) >> 16) & 0xff, \
+	((x) >> 24) & 0xff
+
 /* Called with .vb_lock held */
 static int soc_camera_set_fmt(struct soc_camera_file *icf,
 			      struct v4l2_format *f)
@@ -287,6 +290,9 @@ static int soc_camera_set_fmt(struct soc_camera_file *icf,
 	struct v4l2_pix_format *pix = &f->fmt.pix;
 	int ret;
 
+	dev_dbg(&icd->dev, "S_FMT(%c%c%c%c, %ux%u)\n",
+		pixfmtstr(pix->pixelformat), pix->width, pix->height);
+
 	/* We always call try_fmt() before set_fmt() or set_crop() */
 	ret = ici->ops->try_fmt(icd, f);
 	if (ret < 0)
@@ -302,17 +308,17 @@ static int soc_camera_set_fmt(struct soc_camera_file *icf,
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
@@ -355,8 +361,8 @@ static int soc_camera_open(struct file *file)
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
@@ -557,8 +563,8 @@ static int soc_camera_g_fmt_vid_cap(struct file *file, void *priv,
 
 	WARN_ON(priv != file->private_data);
 
-	pix->width		= icd->rect_current.width;
-	pix->height		= icd->rect_current.height;
+	pix->width		= icd->user_width;
+	pix->height		= icd->user_height;
 	pix->field		= icf->vb_vidq.field;
 	pix->pixelformat	= icd->current_fmt->fourcc;
 	pix->bytesperline	= pix->width *
@@ -722,17 +728,9 @@ static int soc_camera_cropcap(struct file *file, void *fh,
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
@@ -740,11 +738,14 @@ static int soc_camera_g_crop(struct file *file, void *fh,
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
@@ -759,49 +760,33 @@ static int soc_camera_s_crop(struct file *file, void *fh,
 	struct soc_camera_file *icf = file->private_data;
 	struct soc_camera_device *icd = icf->icd;
 	struct soc_camera_host *ici = to_soc_camera_host(icd->dev.parent);
-	struct v4l2_rect rect = a->c;
+	struct v4l2_rect *rect = &a->c;
+	struct v4l2_crop current_crop;
 	int ret;
 
 	if (a->type != V4L2_BUF_TYPE_VIDEO_CAPTURE)
 		return -EINVAL;
 
+	dev_dbg(&icd->dev, "S_CROP(%ux%u@%u:%u)\n",
+		rect->width, rect->height, rect->left, rect->top);
+
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
-		goto unlock;
+	} else {
+		ret = ici->ops->set_crop(icd, a);
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
-	ret = ici->ops->set_crop(icd, a);
-	if (!ret)
-		icd->rect_current = rect;
-
-unlock:
 	mutex_unlock(&icf->vb_vidq.vb_lock);
 
 	return ret;
@@ -926,6 +911,8 @@ static int soc_camera_probe(struct device *dev)
 	struct soc_camera_host *ici = to_soc_camera_host(dev->parent);
 	struct soc_camera_link *icl = to_soc_camera_link(icd);
 	struct device *control = NULL;
+	struct v4l2_subdev *sd;
+	struct v4l2_format f = {.type = V4L2_BUF_TYPE_VIDEO_CAPTURE};
 	int ret;
 
 	dev_info(dev, "Probing %s\n", dev_name(dev));
@@ -982,7 +969,6 @@ static int soc_camera_probe(struct device *dev)
 	if (ret < 0)
 		goto eiufmt;
 
-	icd->rect_current = icd->rect_max;
 	icd->field = V4L2_FIELD_ANY;
 
 	/* ..._video_start() will create a device node, so we have to protect */
@@ -992,9 +978,15 @@ static int soc_camera_probe(struct device *dev)
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
 
@@ -1103,6 +1095,25 @@ static void dummy_release(struct device *dev)
 {
 }
 
+static int default_cropcap(struct soc_camera_device *icd,
+			   struct v4l2_cropcap *a)
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
@@ -1111,7 +1122,6 @@ int soc_camera_host_register(struct soc_camera_host *ici)
 	if (!ici || !ici->ops ||
 	    !ici->ops->try_fmt ||
 	    !ici->ops->set_fmt ||
-	    !ici->ops->set_crop ||
 	    !ici->ops->set_bus_param ||
 	    !ici->ops->querycap ||
 	    !ici->ops->init_videobuf ||
@@ -1122,6 +1132,13 @@ int soc_camera_host_register(struct soc_camera_host *ici)
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
@@ -1321,6 +1338,9 @@ static int __devinit soc_camera_pdrv_probe(struct platform_device *pdev)
 	if (ret < 0)
 		goto escdevreg;
 
+	icd->user_width		= DEFAULT_WIDTH;
+	icd->user_height	= DEFAULT_HEIGHT;
+
 	return 0;
 
 escdevreg:
diff --git a/drivers/media/video/soc_camera_platform.c b/drivers/media/video/soc_camera_platform.c
index aec2cad..3825c35 100644
--- a/drivers/media/video/soc_camera_platform.c
+++ b/drivers/media/video/soc_camera_platform.c
@@ -127,10 +127,6 @@ static int soc_camera_platform_probe(struct platform_device *pdev)
 	/* Set the control device reference */
 	dev_set_drvdata(&icd->dev, &pdev->dev);
 
-	icd->width_min		= 0;
-	icd->rect_max.width	= p->format.width;
-	icd->height_min		= 0;
-	icd->rect_max.height	= p->format.height;
 	icd->y_skip_top		= 0;
 	icd->ops		= &soc_camera_platform_ops;
 
diff --git a/drivers/media/video/tw9910.c b/drivers/media/video/tw9910.c
index 94bd5b0..fbf4130 100644
--- a/drivers/media/video/tw9910.c
+++ b/drivers/media/video/tw9910.c
@@ -715,8 +715,88 @@ tw9910_set_fmt_error:
 	return ret;
 }
 
+static int tw9910_g_crop(struct v4l2_subdev *sd, struct v4l2_crop *a)
+{
+	struct i2c_client *client = sd->priv;
+	struct tw9910_priv *priv = to_tw9910(client);
+
+	if (!priv->scale) {
+		int ret;
+		struct v4l2_crop crop = {
+			.c = {
+				.left	= 0,
+				.top	= 0,
+				.width	= 640,
+				.height	= 480,
+			},
+		};
+		ret = tw9910_s_crop(sd, &crop);
+		if (ret < 0)
+			return ret;
+	}
+
+	a->c.left	= 0;
+	a->c.top	= 0;
+	a->c.width	= priv->scale->width;
+	a->c.height	= priv->scale->height;
+	a->type		= V4L2_BUF_TYPE_VIDEO_CAPTURE;
+
+	return 0;
+}
+
+static int tw9910_cropcap(struct v4l2_subdev *sd, struct v4l2_cropcap *a)
+{
+	a->bounds.left			= 0;
+	a->bounds.top			= 0;
+	a->bounds.width			= 768;
+	a->bounds.height		= 576;
+	a->defrect.left			= 0;
+	a->defrect.top			= 0;
+	a->defrect.width		= 640;
+	a->defrect.height		= 480;
+	a->type				= V4L2_BUF_TYPE_VIDEO_CAPTURE;
+	a->pixelaspect.numerator	= 1;
+	a->pixelaspect.denominator	= 1;
+
+	return 0;
+}
+
+static int tw9910_g_fmt(struct v4l2_subdev *sd, struct v4l2_format *f)
+{
+	struct i2c_client *client = sd->priv;
+	struct tw9910_priv *priv = to_tw9910(client);
+	struct v4l2_pix_format *pix = &f->fmt.pix;
+
+	if (!priv->scale) {
+		int ret;
+		struct v4l2_crop crop = {
+			.c = {
+				.left	= 0,
+				.top	= 0,
+				.width	= 640,
+				.height	= 480,
+			},
+		};
+		ret = tw9910_s_crop(sd, &crop);
+		if (ret < 0)
+			return ret;
+	}
+
+	f->type			= V4L2_BUF_TYPE_VIDEO_CAPTURE;
+
+	pix->width		= priv->scale->width;
+	pix->height		= priv->scale->height;
+	pix->pixelformat	= V4L2_PIX_FMT_VYUY;
+	pix->colorspace		= V4L2_COLORSPACE_SMPTE170M;
+	pix->field		= V4L2_FIELD_INTERLACED;
+
+	return 0;
+}
+
 static int tw9910_s_fmt(struct v4l2_subdev *sd, struct v4l2_format *f)
 {
+	struct i2c_client *client = sd->priv;
+	struct tw9910_priv *priv = to_tw9910(client);
 	struct v4l2_pix_format *pix = &f->fmt.pix;
 	/* See tw9910_s_crop() - no proper cropping support */
 	struct v4l2_crop a = {
@@ -741,8 +821,8 @@ static int tw9910_s_fmt(struct v4l2_subdev *sd, struct v4l2_format *f)
 
 	ret = tw9910_s_crop(sd, &a);
 	if (!ret) {
-		pix->width = a.c.width;
-		pix->height = a.c.height;
+		pix->width = priv->scale->width;
+		pix->height = priv->scale->height;
 	}
 	return ret;
 }
@@ -838,8 +918,11 @@ static struct v4l2_subdev_core_ops tw9910_subdev_core_ops = {
 
 static struct v4l2_subdev_video_ops tw9910_subdev_video_ops = {
 	.s_stream	= tw9910_s_stream,
+	.g_fmt		= tw9910_g_fmt,
 	.s_fmt		= tw9910_s_fmt,
 	.try_fmt	= tw9910_try_fmt,
+	.cropcap	= tw9910_cropcap,
+	.g_crop		= tw9910_g_crop,
 	.s_crop		= tw9910_s_crop,
 };
 
@@ -852,20 +935,6 @@ static struct v4l2_subdev_ops tw9910_subdev_ops = {
  * i2c_driver function
  */
 
-/* This is called during probe, so, setting rect_max is Ok here: scale == 1 */
-static void limit_to_scale(struct soc_camera_device *icd,
-			   const struct tw9910_scale_ctrl *scale)
-{
-	if (scale->width > icd->rect_max.width)
-		icd->rect_max.width  = scale->width;
-	if (scale->width < icd->width_min)
-		icd->width_min = scale->width;
-	if (scale->height > icd->rect_max.height)
-		icd->rect_max.height = scale->height;
-	if (scale->height < icd->height_min)
-		icd->height_min = scale->height;
-}
-
 static int tw9910_probe(struct i2c_client *client,
 			const struct i2c_device_id *did)
 
@@ -876,8 +945,7 @@ static int tw9910_probe(struct i2c_client *client,
 	struct i2c_adapter             *adapter =
 		to_i2c_adapter(client->dev.parent);
 	struct soc_camera_link         *icl;
-	const struct tw9910_scale_ctrl *scale;
-	int                             i, ret;
+	int                             ret;
 
 	if (!icd) {
 		dev_err(&client->dev, "TW9910: missing soc-camera data!\n");
@@ -908,22 +976,6 @@ static int tw9910_probe(struct i2c_client *client,
 	icd->ops     = &tw9910_ops;
 	icd->iface   = info->link.bus_id;
 
-	/*
-	 * set width and height
-	 */
-	icd->rect_max.width  = tw9910_ntsc_scales[0].width; /* set default */
-	icd->width_min  = tw9910_ntsc_scales[0].width;
-	icd->rect_max.height = tw9910_ntsc_scales[0].height;
-	icd->height_min = tw9910_ntsc_scales[0].height;
-
-	scale = tw9910_ntsc_scales;
-	for (i = 0; i < ARRAY_SIZE(tw9910_ntsc_scales); i++)
-		limit_to_scale(icd, scale + i);
-
-	scale = tw9910_pal_scales;
-	for (i = 0; i < ARRAY_SIZE(tw9910_pal_scales); i++)
-		limit_to_scale(icd, scale + i);
-
 	ret = tw9910_video_probe(icd, client);
 	if (ret) {
 		icd->ops = NULL;
diff --git a/include/media/soc_camera.h b/include/media/soc_camera.h
index 344d899..3185e8d 100644
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
+	else if (*start > start_min + length_max - *length)
+		*start = start_min + length_max - *length;
+}
+
 extern unsigned long soc_camera_apply_sensor_flags(struct soc_camera_link *icl,
 						   unsigned long flags);
 
-- 
1.6.2.4

