Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:53601 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751577AbZK0Nsh (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 27 Nov 2009 08:48:37 -0500
Date: Fri, 27 Nov 2009 14:48:45 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
cc: Hans Verkuil <hverkuil@xs4all.nl>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>,
	Paul Mundt <lethal@linux-sh.org>
Subject: [PATCH 2/2 v2] soc-camera: convert to the new mediabus API
In-Reply-To: <Pine.LNX.4.64.0911261822520.5450@axis700.grange>
Message-ID: <Pine.LNX.4.64.0911271349360.4383@axis700.grange>
References: <Pine.LNX.4.64.0911261509100.5450@axis700.grange>
 <dc06c2b1fe49c7b64007ec24817e190a.squirrel@webmail.xs4all.nl>
 <Pine.LNX.4.64.0911261822520.5450@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Convert soc-camera core and all soc-camera drivers to the new mediabus 
API. This also takes soc-camera client drivers one step closer to also be 
usable with generic v4l2-subdev host drivers.

Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
---

There goes another mega-patch convert everyone-and-their-mother to the new 
world rules. I think, in the future I'll really try to make a migration 
path for such cases to be able to convert drivers one by one. There really 
too many of them in the meantime for such global conversions. Otherwise, 
not much to say. For the biggest part this conversion shouldn't affect 
functionality. However, there are a couple of exceptions, where this 
transition also brought some improvements with it. Notably, 
sh_mobile_ceu_camera had its size calculations fixed, mt9t031 now also 
exports SGRBG10 instead of SBGGR10, which makes it more compatible with 
standard user-space tools, like mplayer and gstreamer, which prefer that 
format. Even though its matrix differ from that of mt9v022 and mt9m001 
(colour variant), at least according to the datasheet, it is easier to 
select a different starting pixel using cropping, than to teach all those 
tools all four Bayer variants.

All in all - please review and test. I tested this on 4 platforms with 5 
clients. ap325rxa, i.MX1, mt9m111, mt9t031, ov9640 and soc-camera_platform 
escaped my tests.

Paul, I had to modify ap325rxa, because it is using soc_camera_platform. 
Would need your ack for that trivial hunk.

Obviously, it depends on

[PATCH 1/2 v3] v4l: add a media-bus API for configuring v4l2 subdev pixel 
and frame formats

submitted yesterday.

Thanks
Guennadi

diff --git a/arch/sh/boards/board-ap325rxa.c b/arch/sh/boards/board-ap325rxa.c
index a3afe43..6d2f584 100644
--- a/arch/sh/boards/board-ap325rxa.c
+++ b/arch/sh/boards/board-ap325rxa.c
@@ -317,8 +317,9 @@ static struct soc_camera_platform_info camera_info = {
 	.format_name = "UYVY",
 	.format_depth = 16,
 	.format = {
-		.pixelformat = V4L2_PIX_FMT_UYVY,
+		.code = V4L2_MBUS_FMT_UYVY,
 		.colorspace = V4L2_COLORSPACE_SMPTE170M,
+		.field = V4L2_FIELD_NONE,
 		.width = 640,
 		.height = 480,
 	},
diff --git a/drivers/media/video/mt9m001.c b/drivers/media/video/mt9m001.c
index cc90660..3dd63cf 100644
--- a/drivers/media/video/mt9m001.c
+++ b/drivers/media/video/mt9m001.c
@@ -16,6 +16,7 @@
 #include <media/v4l2-subdev.h>
 #include <media/v4l2-chip-ident.h>
 #include <media/soc_camera.h>
+#include <media/soc_mediabus.h>
 
 /*
  * mt9m001 i2c address 0x5d
@@ -48,41 +49,27 @@
 #define MT9M001_COLUMN_SKIP		20
 #define MT9M001_ROW_SKIP		12
 
-static const struct soc_camera_data_format mt9m001_colour_formats[] = {
+static const struct soc_mbus_datafmt mt9m001_colour_fmts[] = {
 	/*
 	 * Order important: first natively supported,
 	 * second supported with a GPIO extender
 	 */
-	{
-		.name		= "Bayer (sRGB) 10 bit",
-		.depth		= 10,
-		.fourcc		= V4L2_PIX_FMT_SBGGR16,
-		.colorspace	= V4L2_COLORSPACE_SRGB,
-	}, {
-		.name		= "Bayer (sRGB) 8 bit",
-		.depth		= 8,
-		.fourcc		= V4L2_PIX_FMT_SBGGR8,
-		.colorspace	= V4L2_COLORSPACE_SRGB,
-	}
+	{V4L2_MBUS_FMT_SBGGR10, V4L2_COLORSPACE_SRGB},
+	{V4L2_MBUS_FMT_SBGGR8, V4L2_COLORSPACE_SRGB},
 };
 
-static const struct soc_camera_data_format mt9m001_monochrome_formats[] = {
+static const struct soc_mbus_datafmt mt9m001_monochrome_fmts[] = {
 	/* Order important - see above */
-	{
-		.name		= "Monochrome 10 bit",
-		.depth		= 10,
-		.fourcc		= V4L2_PIX_FMT_Y16,
-	}, {
-		.name		= "Monochrome 8 bit",
-		.depth		= 8,
-		.fourcc		= V4L2_PIX_FMT_GREY,
-	},
+	{V4L2_MBUS_FMT_Y10, V4L2_COLORSPACE_JPEG},
+	{V4L2_MBUS_FMT_GREY, V4L2_COLORSPACE_JPEG},
 };
 
 struct mt9m001 {
 	struct v4l2_subdev subdev;
 	struct v4l2_rect rect;	/* Sensor window */
-	__u32 fourcc;
+	const struct soc_mbus_datafmt *fmt;
+	const struct soc_mbus_datafmt *fmts;
+	int num_fmts;
 	int model;	/* V4L2_IDENT_MT9M001* codes from v4l2-chip-ident.h */
 	unsigned int gain;
 	unsigned int exposure;
@@ -209,8 +196,7 @@ static int mt9m001_s_crop(struct v4l2_subdev *sd, struct v4l2_crop *a)
 	const u16 hblank = 9, vblank = 25;
 	unsigned int total_h;
 
-	if (mt9m001->fourcc == V4L2_PIX_FMT_SBGGR8 ||
-	    mt9m001->fourcc == V4L2_PIX_FMT_SBGGR16)
+	if (mt9m001->fmts == mt9m001_colour_fmts)
 		/*
 		 * Bayer format - even number of rows for simplicity,
 		 * but let the user play with the top row.
@@ -290,32 +276,32 @@ static int mt9m001_cropcap(struct v4l2_subdev *sd, struct v4l2_cropcap *a)
 	return 0;
 }
 
-static int mt9m001_g_fmt(struct v4l2_subdev *sd, struct v4l2_format *f)
+static int mt9m001_g_fmt(struct v4l2_subdev *sd,
+			 struct v4l2_mbus_framefmt *mf)
 {
 	struct i2c_client *client = sd->priv;
 	struct mt9m001 *mt9m001 = to_mt9m001(client);
-	struct v4l2_pix_format *pix = &f->fmt.pix;
 
-	pix->width		= mt9m001->rect.width;
-	pix->height		= mt9m001->rect.height;
-	pix->pixelformat	= mt9m001->fourcc;
-	pix->field		= V4L2_FIELD_NONE;
-	pix->colorspace		= V4L2_COLORSPACE_SRGB;
+	mf->width	= mt9m001->rect.width;
+	mf->height	= mt9m001->rect.height;
+	mf->code	= mt9m001->fmt->code;
+	mf->colorspace	= mt9m001->fmt->colorspace;
+	mf->field	= V4L2_FIELD_NONE;
 
 	return 0;
 }
 
-static int mt9m001_s_fmt(struct v4l2_subdev *sd, struct v4l2_format *f)
+static int mt9m001_s_fmt(struct v4l2_subdev *sd,
+			 struct v4l2_mbus_framefmt *mf)
 {
 	struct i2c_client *client = sd->priv;
 	struct mt9m001 *mt9m001 = to_mt9m001(client);
-	struct v4l2_pix_format *pix = &f->fmt.pix;
 	struct v4l2_crop a = {
 		.c = {
 			.left	= mt9m001->rect.left,
 			.top	= mt9m001->rect.top,
-			.width	= pix->width,
-			.height	= pix->height,
+			.width	= mf->width,
+			.height	= mf->height,
 		},
 	};
 	int ret;
@@ -323,28 +309,39 @@ static int mt9m001_s_fmt(struct v4l2_subdev *sd, struct v4l2_format *f)
 	/* No support for scaling so far, just crop. TODO: use skipping */
 	ret = mt9m001_s_crop(sd, &a);
 	if (!ret) {
-		pix->width = mt9m001->rect.width;
-		pix->height = mt9m001->rect.height;
-		mt9m001->fourcc = pix->pixelformat;
+		mf->width	= mt9m001->rect.width;
+		mf->height	= mt9m001->rect.height;
+		mt9m001->fmt	= soc_mbus_find_datafmt(mf->code,
+					mt9m001->fmts, mt9m001->num_fmts);
+		mf->colorspace	= mt9m001->fmt->colorspace;
 	}
 
 	return ret;
 }
 
-static int mt9m001_try_fmt(struct v4l2_subdev *sd, struct v4l2_format *f)
+static int mt9m001_try_fmt(struct v4l2_subdev *sd,
+			   struct v4l2_mbus_framefmt *mf)
 {
 	struct i2c_client *client = sd->priv;
 	struct mt9m001 *mt9m001 = to_mt9m001(client);
-	struct v4l2_pix_format *pix = &f->fmt.pix;
+	const struct soc_mbus_datafmt *fmt;
 
-	v4l_bound_align_image(&pix->width, MT9M001_MIN_WIDTH,
+	v4l_bound_align_image(&mf->width, MT9M001_MIN_WIDTH,
 		MT9M001_MAX_WIDTH, 1,
-		&pix->height, MT9M001_MIN_HEIGHT + mt9m001->y_skip_top,
+		&mf->height, MT9M001_MIN_HEIGHT + mt9m001->y_skip_top,
 		MT9M001_MAX_HEIGHT + mt9m001->y_skip_top, 0, 0);
 
-	if (pix->pixelformat == V4L2_PIX_FMT_SBGGR8 ||
-	    pix->pixelformat == V4L2_PIX_FMT_SBGGR16)
-		pix->height = ALIGN(pix->height - 1, 2);
+	if (mt9m001->fmts == mt9m001_colour_fmts)
+		mf->height = ALIGN(mf->height - 1, 2);
+
+	fmt = soc_mbus_find_datafmt(mf->code, mt9m001->fmts,
+				    mt9m001->num_fmts);
+	if (!fmt) {
+		fmt = mt9m001->fmt;
+		mf->code = fmt->code;
+	}
+
+	mf->colorspace	= fmt->colorspace;
 
 	return 0;
 }
@@ -608,11 +605,11 @@ static int mt9m001_video_probe(struct soc_camera_device *icd,
 	case 0x8411:
 	case 0x8421:
 		mt9m001->model = V4L2_IDENT_MT9M001C12ST;
-		icd->formats = mt9m001_colour_formats;
+		mt9m001->fmts = mt9m001_colour_fmts;
 		break;
 	case 0x8431:
 		mt9m001->model = V4L2_IDENT_MT9M001C12STM;
-		icd->formats = mt9m001_monochrome_formats;
+		mt9m001->fmts = mt9m001_monochrome_fmts;
 		break;
 	default:
 		dev_err(&client->dev,
@@ -620,7 +617,7 @@ static int mt9m001_video_probe(struct soc_camera_device *icd,
 		return -ENODEV;
 	}
 
-	icd->num_formats = 0;
+	mt9m001->num_fmts = 0;
 
 	/*
 	 * This is a 10bit sensor, so by default we only allow 10bit.
@@ -633,14 +630,14 @@ static int mt9m001_video_probe(struct soc_camera_device *icd,
 		flags = SOCAM_DATAWIDTH_10;
 
 	if (flags & SOCAM_DATAWIDTH_10)
-		icd->num_formats++;
+		mt9m001->num_fmts++;
 	else
-		icd->formats++;
+		mt9m001->fmts++;
 
 	if (flags & SOCAM_DATAWIDTH_8)
-		icd->num_formats++;
+		mt9m001->num_fmts++;
 
-	mt9m001->fourcc = icd->formats->fourcc;
+	mt9m001->fmt = &mt9m001->fmts[0];
 
 	dev_info(&client->dev, "Detected a MT9M001 chip ID %x (%s)\n", data,
 		 data == 0x8431 ? "C12STM" : "C12ST");
@@ -686,14 +683,28 @@ static struct v4l2_subdev_core_ops mt9m001_subdev_core_ops = {
 #endif
 };
 
+static int mt9m001_enum_fmt(struct v4l2_subdev *sd, int index,
+			    enum v4l2_mbus_pixelcode *code)
+{
+	struct i2c_client *client = sd->priv;
+	struct mt9m001 *mt9m001 = to_mt9m001(client);
+
+	if ((unsigned int)index >= mt9m001->num_fmts)
+		return -EINVAL;
+
+	*code = mt9m001->fmts[index].code;
+	return 0;
+}
+
 static struct v4l2_subdev_video_ops mt9m001_subdev_video_ops = {
 	.s_stream	= mt9m001_s_stream,
-	.s_fmt		= mt9m001_s_fmt,
-	.g_fmt		= mt9m001_g_fmt,
-	.try_fmt	= mt9m001_try_fmt,
+	.s_mbus_fmt	= mt9m001_s_fmt,
+	.g_mbus_fmt	= mt9m001_g_fmt,
+	.try_mbus_fmt	= mt9m001_try_fmt,
 	.s_crop		= mt9m001_s_crop,
 	.g_crop		= mt9m001_g_crop,
 	.cropcap	= mt9m001_cropcap,
+	.enum_mbus_fmt	= mt9m001_enum_fmt,
 };
 
 static struct v4l2_subdev_sensor_ops mt9m001_subdev_sensor_ops = {
diff --git a/drivers/media/video/mt9m111.c b/drivers/media/video/mt9m111.c
index 30db625..9d75500 100644
--- a/drivers/media/video/mt9m111.c
+++ b/drivers/media/video/mt9m111.c
@@ -17,6 +17,7 @@
 #include <media/v4l2-common.h>
 #include <media/v4l2-chip-ident.h>
 #include <media/soc_camera.h>
+#include <media/soc_mediabus.h>
 
 /*
  * mt9m111 and mt9m112 i2c address is 0x5d or 0x48 (depending on SAddr pin)
@@ -123,23 +124,15 @@
 #define MT9M111_MAX_HEIGHT	1024
 #define MT9M111_MAX_WIDTH	1280
 
-#define COL_FMT(_name, _depth, _fourcc, _colorspace) \
-	{ .name = _name, .depth = _depth, .fourcc = _fourcc, \
-	.colorspace = _colorspace }
-#define RGB_FMT(_name, _depth, _fourcc) \
-	COL_FMT(_name, _depth, _fourcc, V4L2_COLORSPACE_SRGB)
-#define JPG_FMT(_name, _depth, _fourcc) \
-	COL_FMT(_name, _depth, _fourcc, V4L2_COLORSPACE_JPEG)
-
-static const struct soc_camera_data_format mt9m111_colour_formats[] = {
-	JPG_FMT("CbYCrY 16 bit", 16, V4L2_PIX_FMT_UYVY),
-	JPG_FMT("CrYCbY 16 bit", 16, V4L2_PIX_FMT_VYUY),
-	JPG_FMT("YCbYCr 16 bit", 16, V4L2_PIX_FMT_YUYV),
-	JPG_FMT("YCrYCb 16 bit", 16, V4L2_PIX_FMT_YVYU),
-	RGB_FMT("RGB 565", 16, V4L2_PIX_FMT_RGB565),
-	RGB_FMT("RGB 555", 16, V4L2_PIX_FMT_RGB555),
-	RGB_FMT("Bayer (sRGB) 10 bit", 10, V4L2_PIX_FMT_SBGGR16),
-	RGB_FMT("Bayer (sRGB) 8 bit", 8, V4L2_PIX_FMT_SBGGR8),
+static const struct soc_mbus_datafmt mt9m111_colour_fmts[] = {
+	{V4L2_MBUS_FMT_YUYV, V4L2_COLORSPACE_JPEG},
+	{V4L2_MBUS_FMT_YVYU, V4L2_COLORSPACE_JPEG},
+	{V4L2_MBUS_FMT_UYVY, V4L2_COLORSPACE_JPEG},
+	{V4L2_MBUS_FMT_VYUY, V4L2_COLORSPACE_JPEG},
+	{V4L2_MBUS_FMT_RGB555, V4L2_COLORSPACE_SRGB},
+	{V4L2_MBUS_FMT_RGB565, V4L2_COLORSPACE_SRGB},
+	{V4L2_MBUS_FMT_SBGGR8, V4L2_COLORSPACE_SRGB},
+	{V4L2_MBUS_FMT_SBGGR10_2X8_PADHI_LE, V4L2_COLORSPACE_SRGB},
 };
 
 enum mt9m111_context {
@@ -152,7 +145,7 @@ struct mt9m111 {
 	int model;	/* V4L2_IDENT_MT9M11x* codes from v4l2-chip-ident.h */
 	enum mt9m111_context context;
 	struct v4l2_rect rect;
-	u32 pixfmt;
+	const struct soc_mbus_datafmt *fmt;
 	unsigned int gain;
 	unsigned char autoexposure;
 	unsigned char datawidth;
@@ -258,8 +251,8 @@ static int mt9m111_setup_rect(struct i2c_client *client,
 	int width = rect->width;
 	int height = rect->height;
 
-	if (mt9m111->pixfmt == V4L2_PIX_FMT_SBGGR8 ||
-	    mt9m111->pixfmt == V4L2_PIX_FMT_SBGGR16)
+	if (mt9m111->fmt->code == V4L2_MBUS_FMT_SBGGR8 ||
+	    mt9m111->fmt->code == V4L2_MBUS_FMT_SBGGR10_2X8_PADHI_LE)
 		is_raw_format = 1;
 	else
 		is_raw_format = 0;
@@ -307,7 +300,8 @@ static int mt9m111_setup_pixfmt(struct i2c_client *client, u16 outfmt)
 
 static int mt9m111_setfmt_bayer8(struct i2c_client *client)
 {
-	return mt9m111_setup_pixfmt(client, MT9M111_OUTFMT_PROCESSED_BAYER);
+	return mt9m111_setup_pixfmt(client, MT9M111_OUTFMT_PROCESSED_BAYER |
+				    MT9M111_OUTFMT_RGB);
 }
 
 static int mt9m111_setfmt_bayer10(struct i2c_client *client)
@@ -401,8 +395,8 @@ static int mt9m111_make_rect(struct i2c_client *client,
 {
 	struct mt9m111 *mt9m111 = to_mt9m111(client);
 
-	if (mt9m111->pixfmt == V4L2_PIX_FMT_SBGGR8 ||
-	    mt9m111->pixfmt == V4L2_PIX_FMT_SBGGR16) {
+	if (mt9m111->fmt->code == V4L2_MBUS_FMT_SBGGR8 ||
+	    mt9m111->fmt->code == V4L2_MBUS_FMT_SBGGR10_2X8_PADHI_LE) {
 		/* Bayer format - even size lengths */
 		rect->width	= ALIGN(rect->width, 2);
 		rect->height	= ALIGN(rect->height, 2);
@@ -460,120 +454,139 @@ static int mt9m111_cropcap(struct v4l2_subdev *sd, struct v4l2_cropcap *a)
 	return 0;
 }
 
-static int mt9m111_g_fmt(struct v4l2_subdev *sd, struct v4l2_format *f)
+static int mt9m111_g_fmt(struct v4l2_subdev *sd,
+			 struct v4l2_mbus_framefmt *mf)
 {
 	struct i2c_client *client = sd->priv;
 	struct mt9m111 *mt9m111 = to_mt9m111(client);
-	struct v4l2_pix_format *pix = &f->fmt.pix;
 
-	pix->width		= mt9m111->rect.width;
-	pix->height		= mt9m111->rect.height;
-	pix->pixelformat	= mt9m111->pixfmt;
-	pix->field		= V4L2_FIELD_NONE;
-	pix->colorspace		= V4L2_COLORSPACE_SRGB;
+	mf->width	= mt9m111->rect.width;
+	mf->height	= mt9m111->rect.height;
+	mf->code	= mt9m111->fmt->code;
+	mf->field	= V4L2_FIELD_NONE;
 
 	return 0;
 }
 
-static int mt9m111_set_pixfmt(struct i2c_client *client, u32 pixfmt)
+static int mt9m111_set_pixfmt(struct i2c_client *client,
+			      enum v4l2_mbus_pixelcode code)
 {
 	struct mt9m111 *mt9m111 = to_mt9m111(client);
 	int ret;
 
-	switch (pixfmt) {
-	case V4L2_PIX_FMT_SBGGR8:
+	switch (code) {
+	case V4L2_MBUS_FMT_SBGGR8:
 		ret = mt9m111_setfmt_bayer8(client);
 		break;
-	case V4L2_PIX_FMT_SBGGR16:
+	case V4L2_MBUS_FMT_SBGGR10_2X8_PADHI_LE:
 		ret = mt9m111_setfmt_bayer10(client);
 		break;
-	case V4L2_PIX_FMT_RGB555:
+	case V4L2_MBUS_FMT_RGB555:
 		ret = mt9m111_setfmt_rgb555(client);
 		break;
-	case V4L2_PIX_FMT_RGB565:
+	case V4L2_MBUS_FMT_RGB565:
 		ret = mt9m111_setfmt_rgb565(client);
 		break;
-	case V4L2_PIX_FMT_UYVY:
+	case V4L2_MBUS_FMT_UYVY:
 		mt9m111->swap_yuv_y_chromas = 0;
 		mt9m111->swap_yuv_cb_cr = 0;
 		ret = mt9m111_setfmt_yuv(client);
 		break;
-	case V4L2_PIX_FMT_VYUY:
+	case V4L2_MBUS_FMT_VYUY:
 		mt9m111->swap_yuv_y_chromas = 0;
 		mt9m111->swap_yuv_cb_cr = 1;
 		ret = mt9m111_setfmt_yuv(client);
 		break;
-	case V4L2_PIX_FMT_YUYV:
+	case V4L2_MBUS_FMT_YUYV:
 		mt9m111->swap_yuv_y_chromas = 1;
 		mt9m111->swap_yuv_cb_cr = 0;
 		ret = mt9m111_setfmt_yuv(client);
 		break;
-	case V4L2_PIX_FMT_YVYU:
+	case V4L2_MBUS_FMT_YVYU:
 		mt9m111->swap_yuv_y_chromas = 1;
 		mt9m111->swap_yuv_cb_cr = 1;
 		ret = mt9m111_setfmt_yuv(client);
 		break;
 	default:
 		dev_err(&client->dev, "Pixel format not handled : %x\n",
-			pixfmt);
+			code);
 		ret = -EINVAL;
 	}
 
-	if (!ret)
-		mt9m111->pixfmt = pixfmt;
-
 	return ret;
 }
 
-static int mt9m111_s_fmt(struct v4l2_subdev *sd, struct v4l2_format *f)
+static int mt9m111_s_fmt(struct v4l2_subdev *sd,
+			 struct v4l2_mbus_framefmt *mf)
 {
 	struct i2c_client *client = sd->priv;
+	const struct soc_mbus_datafmt *fmt;
 	struct mt9m111 *mt9m111 = to_mt9m111(client);
-	struct v4l2_pix_format *pix = &f->fmt.pix;
 	struct v4l2_rect rect = {
 		.left	= mt9m111->rect.left,
 		.top	= mt9m111->rect.top,
-		.width	= pix->width,
-		.height	= pix->height,
+		.width	= mf->width,
+		.height	= mf->height,
 	};
 	int ret;
 
+	fmt = soc_mbus_find_datafmt(mf->code, mt9m111_colour_fmts,
+				    ARRAY_SIZE(mt9m111_colour_fmts));
+	if (!fmt)
+		return -EINVAL;
+
 	dev_dbg(&client->dev,
-		"%s fmt=%x left=%d, top=%d, width=%d, height=%d\n", __func__,
-		pix->pixelformat, rect.left, rect.top, rect.width, rect.height);
+		"%s code=%x left=%d, top=%d, width=%d, height=%d\n", __func__,
+		mf->code, rect.left, rect.top, rect.width, rect.height);
 
 	ret = mt9m111_make_rect(client, &rect);
 	if (!ret)
-		ret = mt9m111_set_pixfmt(client, pix->pixelformat);
-	if (!ret)
-		mt9m111->rect = rect;
+		ret = mt9m111_set_pixfmt(client, mf->code);
+	if (!ret) {
+		mt9m111->rect	= rect;
+		mt9m111->fmt	= fmt;
+		mf->colorspace	= fmt->colorspace;
+	}
+
 	return ret;
 }
 
-static int mt9m111_try_fmt(struct v4l2_subdev *sd, struct v4l2_format *f)
+static int mt9m111_try_fmt(struct v4l2_subdev *sd,
+			   struct v4l2_mbus_framefmt *mf)
 {
-	struct v4l2_pix_format *pix = &f->fmt.pix;
-	bool bayer = pix->pixelformat == V4L2_PIX_FMT_SBGGR8 ||
-		pix->pixelformat == V4L2_PIX_FMT_SBGGR16;
+	struct i2c_client *client = sd->priv;
+	struct mt9m111 *mt9m111 = to_mt9m111(client);
+	const struct soc_mbus_datafmt *fmt;
+	bool bayer = mf->code == V4L2_MBUS_FMT_SBGGR8 ||
+		mf->code == V4L2_MBUS_FMT_SBGGR10_2X8_PADHI_LE;
+
+	fmt = soc_mbus_find_datafmt(mf->code, mt9m111_colour_fmts,
+				    ARRAY_SIZE(mt9m111_colour_fmts));
+	if (!fmt) {
+		fmt = mt9m111->fmt;
+		mf->code = fmt->code;
+	}
 
 	/*
 	 * With Bayer format enforce even side lengths, but let the user play
 	 * with the starting pixel
 	 */
 
-	if (pix->height > MT9M111_MAX_HEIGHT)
-		pix->height = MT9M111_MAX_HEIGHT;
-	else if (pix->height < 2)
-		pix->height = 2;
+	if (mf->height > MT9M111_MAX_HEIGHT)
+		mf->height = MT9M111_MAX_HEIGHT;
+	else if (mf->height < 2)
+		mf->height = 2;
 	else if (bayer)
-		pix->height = ALIGN(pix->height, 2);
+		mf->height = ALIGN(mf->height, 2);
 
-	if (pix->width > MT9M111_MAX_WIDTH)
-		pix->width = MT9M111_MAX_WIDTH;
-	else if (pix->width < 2)
-		pix->width = 2;
+	if (mf->width > MT9M111_MAX_WIDTH)
+		mf->width = MT9M111_MAX_WIDTH;
+	else if (mf->width < 2)
+		mf->width = 2;
 	else if (bayer)
-		pix->width = ALIGN(pix->width, 2);
+		mf->width = ALIGN(mf->width, 2);
+
+	mf->colorspace = fmt->colorspace;
 
 	return 0;
 }
@@ -863,7 +876,7 @@ static int mt9m111_restore_state(struct i2c_client *client)
 	struct mt9m111 *mt9m111 = to_mt9m111(client);
 
 	mt9m111_set_context(client, mt9m111->context);
-	mt9m111_set_pixfmt(client, mt9m111->pixfmt);
+	mt9m111_set_pixfmt(client, mt9m111->fmt->code);
 	mt9m111_setup_rect(client, &mt9m111->rect);
 	mt9m111_set_flip(client, mt9m111->hflip, MT9M111_RMB_MIRROR_COLS);
 	mt9m111_set_flip(client, mt9m111->vflip, MT9M111_RMB_MIRROR_ROWS);
@@ -952,9 +965,6 @@ static int mt9m111_video_probe(struct soc_camera_device *icd,
 		goto ei2c;
 	}
 
-	icd->formats = mt9m111_colour_formats;
-	icd->num_formats = ARRAY_SIZE(mt9m111_colour_formats);
-
 	dev_info(&client->dev, "Detected a MT9M11x chip ID %x\n", data);
 
 ei2c:
@@ -971,13 +981,24 @@ static struct v4l2_subdev_core_ops mt9m111_subdev_core_ops = {
 #endif
 };
 
+static int mt9m111_enum_fmt(struct v4l2_subdev *sd, int index,
+			    enum v4l2_mbus_pixelcode *code)
+{
+	if ((unsigned int)index >= ARRAY_SIZE(mt9m111_colour_fmts))
+		return -EINVAL;
+
+	*code = mt9m111_colour_fmts[index].code;
+	return 0;
+}
+
 static struct v4l2_subdev_video_ops mt9m111_subdev_video_ops = {
-	.s_fmt		= mt9m111_s_fmt,
-	.g_fmt		= mt9m111_g_fmt,
-	.try_fmt	= mt9m111_try_fmt,
+	.s_mbus_fmt	= mt9m111_s_fmt,
+	.g_mbus_fmt	= mt9m111_g_fmt,
+	.try_mbus_fmt	= mt9m111_try_fmt,
 	.s_crop		= mt9m111_s_crop,
 	.g_crop		= mt9m111_g_crop,
 	.cropcap	= mt9m111_cropcap,
+	.enum_mbus_fmt	= mt9m111_enum_fmt,
 };
 
 static struct v4l2_subdev_ops mt9m111_subdev_ops = {
@@ -1024,6 +1045,7 @@ static int mt9m111_probe(struct i2c_client *client,
 	mt9m111->rect.top	= MT9M111_MIN_DARK_ROWS;
 	mt9m111->rect.width	= MT9M111_MAX_WIDTH;
 	mt9m111->rect.height	= MT9M111_MAX_HEIGHT;
+	mt9m111->fmt		= &mt9m111_colour_fmts[0];
 
 	ret = mt9m111_video_probe(icd, client);
 	if (ret) {
diff --git a/drivers/media/video/mt9t031.c b/drivers/media/video/mt9t031.c
index e3f664f..99b9548 100644
--- a/drivers/media/video/mt9t031.c
+++ b/drivers/media/video/mt9t031.c
@@ -16,6 +16,7 @@
 #include <media/v4l2-subdev.h>
 #include <media/v4l2-chip-ident.h>
 #include <media/soc_camera.h>
+#include <media/soc_mediabus.h>
 
 /*
  * mt9t031 i2c address 0x5d
@@ -60,13 +61,8 @@
 	SOCAM_VSYNC_ACTIVE_HIGH | SOCAM_DATA_ACTIVE_HIGH |	\
 	SOCAM_MASTER | SOCAM_DATAWIDTH_10)
 
-static const struct soc_camera_data_format mt9t031_colour_formats[] = {
-	{
-		.name		= "Bayer (sRGB) 10 bit",
-		.depth		= 10,
-		.fourcc		= V4L2_PIX_FMT_SGRBG10,
-		.colorspace	= V4L2_COLORSPACE_SRGB,
-	}
+static const struct soc_mbus_datafmt mt9t031_fmts[] = {
+	{V4L2_MBUS_FMT_SBGGR10, V4L2_COLORSPACE_SRGB},
 };
 
 struct mt9t031 {
@@ -378,27 +374,27 @@ static int mt9t031_cropcap(struct v4l2_subdev *sd, struct v4l2_cropcap *a)
 	return 0;
 }
 
-static int mt9t031_g_fmt(struct v4l2_subdev *sd, struct v4l2_format *f)
+static int mt9t031_g_fmt(struct v4l2_subdev *sd,
+			 struct v4l2_mbus_framefmt *mf)
 {
 	struct i2c_client *client = sd->priv;
 	struct mt9t031 *mt9t031 = to_mt9t031(client);
-	struct v4l2_pix_format *pix = &f->fmt.pix;
 
-	pix->width		= mt9t031->rect.width / mt9t031->xskip;
-	pix->height		= mt9t031->rect.height / mt9t031->yskip;
-	pix->pixelformat	= V4L2_PIX_FMT_SGRBG10;
-	pix->field		= V4L2_FIELD_NONE;
-	pix->colorspace		= V4L2_COLORSPACE_SRGB;
+	mf->width	= mt9t031->rect.width / mt9t031->xskip;
+	mf->height	= mt9t031->rect.height / mt9t031->yskip;
+	mf->code	= V4L2_MBUS_FMT_SBGGR10;
+	mf->colorspace	= V4L2_COLORSPACE_SRGB;
+	mf->field	= V4L2_FIELD_NONE;
 
 	return 0;
 }
 
-static int mt9t031_s_fmt(struct v4l2_subdev *sd, struct v4l2_format *f)
+static int mt9t031_s_fmt(struct v4l2_subdev *sd,
+			 struct v4l2_mbus_framefmt *mf)
 {
 	struct i2c_client *client = sd->priv;
 	struct mt9t031 *mt9t031 = to_mt9t031(client);
 	struct soc_camera_device *icd = client->dev.platform_data;
-	struct v4l2_pix_format *pix = &f->fmt.pix;
 	u16 xskip, yskip;
 	struct v4l2_rect rect = mt9t031->rect;
 
@@ -406,8 +402,11 @@ static int mt9t031_s_fmt(struct v4l2_subdev *sd, struct v4l2_format *f)
 	 * try_fmt has put width and height within limits.
 	 * S_FMT: use binning and skipping for scaling
 	 */
-	xskip = mt9t031_skip(&rect.width, pix->width, MT9T031_MAX_WIDTH);
-	yskip = mt9t031_skip(&rect.height, pix->height, MT9T031_MAX_HEIGHT);
+	xskip = mt9t031_skip(&rect.width, mf->width, MT9T031_MAX_WIDTH);
+	yskip = mt9t031_skip(&rect.height, mf->height, MT9T031_MAX_HEIGHT);
+
+	mf->code	= V4L2_MBUS_FMT_SBGGR10;
+	mf->colorspace	= V4L2_COLORSPACE_SRGB;
 
 	/* mt9t031_set_params() doesn't change width and height */
 	return mt9t031_set_params(icd, &rect, xskip, yskip);
@@ -417,13 +416,15 @@ static int mt9t031_s_fmt(struct v4l2_subdev *sd, struct v4l2_format *f)
  * If a user window larger than sensor window is requested, we'll increase the
  * sensor window.
  */
-static int mt9t031_try_fmt(struct v4l2_subdev *sd, struct v4l2_format *f)
+static int mt9t031_try_fmt(struct v4l2_subdev *sd,
+			   struct v4l2_mbus_framefmt *mf)
 {
-	struct v4l2_pix_format *pix = &f->fmt.pix;
-
 	v4l_bound_align_image(
-		&pix->width, MT9T031_MIN_WIDTH, MT9T031_MAX_WIDTH, 1,
-		&pix->height, MT9T031_MIN_HEIGHT, MT9T031_MAX_HEIGHT, 1, 0);
+		&mf->width, MT9T031_MIN_WIDTH, MT9T031_MAX_WIDTH, 1,
+		&mf->height, MT9T031_MIN_HEIGHT, MT9T031_MAX_HEIGHT, 1, 0);
+
+	mf->code	= V4L2_MBUS_FMT_SBGGR10;
+	mf->colorspace	= V4L2_COLORSPACE_SRGB;
 
 	return 0;
 }
@@ -684,7 +685,6 @@ static int mt9t031_s_ctrl(struct v4l2_subdev *sd, struct v4l2_control *ctrl)
  */
 static int mt9t031_video_probe(struct i2c_client *client)
 {
-	struct soc_camera_device *icd = client->dev.platform_data;
 	struct mt9t031 *mt9t031 = to_mt9t031(client);
 	s32 data;
 	int ret;
@@ -699,8 +699,6 @@ static int mt9t031_video_probe(struct i2c_client *client)
 	switch (data) {
 	case 0x1621:
 		mt9t031->model = V4L2_IDENT_MT9T031;
-		icd->formats = mt9t031_colour_formats;
-		icd->num_formats = ARRAY_SIZE(mt9t031_colour_formats);
 		break;
 	default:
 		dev_err(&client->dev,
@@ -741,14 +739,25 @@ static struct v4l2_subdev_core_ops mt9t031_subdev_core_ops = {
 #endif
 };
 
+static int mt9t031_enum_fmt(struct v4l2_subdev *sd, int index,
+			    enum v4l2_mbus_pixelcode *code)
+{
+	if ((unsigned int)index >= ARRAY_SIZE(mt9t031_fmts))
+		return -EINVAL;
+
+	*code = mt9t031_fmts[index].code;
+	return 0;
+}
+
 static struct v4l2_subdev_video_ops mt9t031_subdev_video_ops = {
 	.s_stream	= mt9t031_s_stream,
-	.s_fmt		= mt9t031_s_fmt,
-	.g_fmt		= mt9t031_g_fmt,
-	.try_fmt	= mt9t031_try_fmt,
+	.s_mbus_fmt	= mt9t031_s_fmt,
+	.g_mbus_fmt	= mt9t031_g_fmt,
+	.try_mbus_fmt	= mt9t031_try_fmt,
 	.s_crop		= mt9t031_s_crop,
 	.g_crop		= mt9t031_g_crop,
 	.cropcap	= mt9t031_cropcap,
+	.enum_mbus_fmt	= mt9t031_enum_fmt,
 };
 
 static struct v4l2_subdev_sensor_ops mt9t031_subdev_sensor_ops = {
diff --git a/drivers/media/video/mt9v022.c b/drivers/media/video/mt9v022.c
index f60a9a1..42c3619 100644
--- a/drivers/media/video/mt9v022.c
+++ b/drivers/media/video/mt9v022.c
@@ -17,6 +17,7 @@
 #include <media/v4l2-subdev.h>
 #include <media/v4l2-chip-ident.h>
 #include <media/soc_camera.h>
+#include <media/soc_mediabus.h>
 
 /*
  * mt9v022 i2c address 0x48, 0x4c, 0x58, 0x5c
@@ -64,41 +65,27 @@ MODULE_PARM_DESC(sensor_type, "Sensor type: \"colour\" or \"monochrome\"");
 #define MT9V022_COLUMN_SKIP		1
 #define MT9V022_ROW_SKIP		4
 
-static const struct soc_camera_data_format mt9v022_colour_formats[] = {
+static const struct soc_mbus_datafmt mt9v022_colour_fmts[] = {
 	/*
 	 * Order important: first natively supported,
 	 * second supported with a GPIO extender
 	 */
-	{
-		.name		= "Bayer (sRGB) 10 bit",
-		.depth		= 10,
-		.fourcc		= V4L2_PIX_FMT_SBGGR16,
-		.colorspace	= V4L2_COLORSPACE_SRGB,
-	}, {
-		.name		= "Bayer (sRGB) 8 bit",
-		.depth		= 8,
-		.fourcc		= V4L2_PIX_FMT_SBGGR8,
-		.colorspace	= V4L2_COLORSPACE_SRGB,
-	}
+	{V4L2_MBUS_FMT_SBGGR10, V4L2_COLORSPACE_SRGB},
+	{V4L2_MBUS_FMT_SBGGR8, V4L2_COLORSPACE_SRGB},
 };
 
-static const struct soc_camera_data_format mt9v022_monochrome_formats[] = {
+static const struct soc_mbus_datafmt mt9v022_monochrome_fmts[] = {
 	/* Order important - see above */
-	{
-		.name		= "Monochrome 10 bit",
-		.depth		= 10,
-		.fourcc		= V4L2_PIX_FMT_Y16,
-	}, {
-		.name		= "Monochrome 8 bit",
-		.depth		= 8,
-		.fourcc		= V4L2_PIX_FMT_GREY,
-	},
+	{V4L2_MBUS_FMT_Y10, V4L2_COLORSPACE_JPEG},
+	{V4L2_MBUS_FMT_GREY, V4L2_COLORSPACE_JPEG},
 };
 
 struct mt9v022 {
 	struct v4l2_subdev subdev;
 	struct v4l2_rect rect;	/* Sensor window */
-	__u32 fourcc;
+	const struct soc_mbus_datafmt *fmt;
+	const struct soc_mbus_datafmt *fmts;
+	int num_fmts;
 	int model;	/* V4L2_IDENT_MT9V022* codes from v4l2-chip-ident.h */
 	u16 chip_control;
 	unsigned short y_skip_top;	/* Lines to skip at the top */
@@ -275,8 +262,7 @@ static int mt9v022_s_crop(struct v4l2_subdev *sd, struct v4l2_crop *a)
 	int ret;
 
 	/* Bayer format - even size lengths */
-	if (mt9v022->fourcc == V4L2_PIX_FMT_SBGGR8 ||
-	    mt9v022->fourcc == V4L2_PIX_FMT_SBGGR16) {
+	if (mt9v022->fmts == mt9v022_colour_fmts) {
 		rect.width	= ALIGN(rect.width, 2);
 		rect.height	= ALIGN(rect.height, 2);
 		/* Let the user play with the starting pixel */
@@ -354,32 +340,32 @@ static int mt9v022_cropcap(struct v4l2_subdev *sd, struct v4l2_cropcap *a)
 	return 0;
 }
 
-static int mt9v022_g_fmt(struct v4l2_subdev *sd, struct v4l2_format *f)
+static int mt9v022_g_fmt(struct v4l2_subdev *sd,
+			 struct v4l2_mbus_framefmt *mf)
 {
 	struct i2c_client *client = sd->priv;
 	struct mt9v022 *mt9v022 = to_mt9v022(client);
-	struct v4l2_pix_format *pix = &f->fmt.pix;
 
-	pix->width		= mt9v022->rect.width;
-	pix->height		= mt9v022->rect.height;
-	pix->pixelformat	= mt9v022->fourcc;
-	pix->field		= V4L2_FIELD_NONE;
-	pix->colorspace		= V4L2_COLORSPACE_SRGB;
+	mf->width	= mt9v022->rect.width;
+	mf->height	= mt9v022->rect.height;
+	mf->code	= mt9v022->fmt->code;
+	mf->colorspace	= mt9v022->fmt->colorspace;
+	mf->field	= V4L2_FIELD_NONE;
 
 	return 0;
 }
 
-static int mt9v022_s_fmt(struct v4l2_subdev *sd, struct v4l2_format *f)
+static int mt9v022_s_fmt(struct v4l2_subdev *sd,
+			 struct v4l2_mbus_framefmt *mf)
 {
 	struct i2c_client *client = sd->priv;
 	struct mt9v022 *mt9v022 = to_mt9v022(client);
-	struct v4l2_pix_format *pix = &f->fmt.pix;
 	struct v4l2_crop a = {
 		.c = {
 			.left	= mt9v022->rect.left,
 			.top	= mt9v022->rect.top,
-			.width	= pix->width,
-			.height	= pix->height,
+			.width	= mf->width,
+			.height	= mf->height,
 		},
 	};
 	int ret;
@@ -388,14 +374,14 @@ static int mt9v022_s_fmt(struct v4l2_subdev *sd, struct v4l2_format *f)
 	 * The caller provides a supported format, as verified per call to
 	 * icd->try_fmt(), datawidth is from our supported format list
 	 */
-	switch (pix->pixelformat) {
-	case V4L2_PIX_FMT_GREY:
-	case V4L2_PIX_FMT_Y16:
+	switch (mf->code) {
+	case V4L2_MBUS_FMT_GREY:
+	case V4L2_MBUS_FMT_Y10:
 		if (mt9v022->model != V4L2_IDENT_MT9V022IX7ATM)
 			return -EINVAL;
 		break;
-	case V4L2_PIX_FMT_SBGGR8:
-	case V4L2_PIX_FMT_SBGGR16:
+	case V4L2_MBUS_FMT_SBGGR8:
+	case V4L2_MBUS_FMT_SBGGR10:
 		if (mt9v022->model != V4L2_IDENT_MT9V022IX7ATC)
 			return -EINVAL;
 		break;
@@ -409,27 +395,39 @@ static int mt9v022_s_fmt(struct v4l2_subdev *sd, struct v4l2_format *f)
 	/* No support for scaling on this camera, just crop. */
 	ret = mt9v022_s_crop(sd, &a);
 	if (!ret) {
-		pix->width = mt9v022->rect.width;
-		pix->height = mt9v022->rect.height;
-		mt9v022->fourcc = pix->pixelformat;
+		mf->width	= mt9v022->rect.width;
+		mf->height	= mt9v022->rect.height;
+		mt9v022->fmt	= soc_mbus_find_datafmt(mf->code,
+					mt9v022->fmts, mt9v022->num_fmts);
+		mf->colorspace	= mt9v022->fmt->colorspace;
 	}
 
 	return ret;
 }
 
-static int mt9v022_try_fmt(struct v4l2_subdev *sd, struct v4l2_format *f)
+static int mt9v022_try_fmt(struct v4l2_subdev *sd,
+			   struct v4l2_mbus_framefmt *mf)
 {
 	struct i2c_client *client = sd->priv;
 	struct mt9v022 *mt9v022 = to_mt9v022(client);
-	struct v4l2_pix_format *pix = &f->fmt.pix;
-	int align = pix->pixelformat == V4L2_PIX_FMT_SBGGR8 ||
-		pix->pixelformat == V4L2_PIX_FMT_SBGGR16;
+	const struct soc_mbus_datafmt *fmt;
+	int align = mf->code == V4L2_MBUS_FMT_SBGGR8 ||
+		mf->code == V4L2_MBUS_FMT_SBGGR10;
 
-	v4l_bound_align_image(&pix->width, MT9V022_MIN_WIDTH,
+	v4l_bound_align_image(&mf->width, MT9V022_MIN_WIDTH,
 		MT9V022_MAX_WIDTH, align,
-		&pix->height, MT9V022_MIN_HEIGHT + mt9v022->y_skip_top,
+		&mf->height, MT9V022_MIN_HEIGHT + mt9v022->y_skip_top,
 		MT9V022_MAX_HEIGHT + mt9v022->y_skip_top, align, 0);
 
+	fmt = soc_mbus_find_datafmt(mf->code, mt9v022->fmts,
+				    mt9v022->num_fmts);
+	if (!fmt) {
+		fmt = mt9v022->fmt;
+		mf->code = fmt->code;
+	}
+
+	mf->colorspace	= fmt->colorspace;
+
 	return 0;
 }
 
@@ -749,17 +747,17 @@ static int mt9v022_video_probe(struct soc_camera_device *icd,
 			    !strcmp("color", sensor_type))) {
 		ret = reg_write(client, MT9V022_PIXEL_OPERATION_MODE, 4 | 0x11);
 		mt9v022->model = V4L2_IDENT_MT9V022IX7ATC;
-		icd->formats = mt9v022_colour_formats;
+		mt9v022->fmts = mt9v022_colour_fmts;
 	} else {
 		ret = reg_write(client, MT9V022_PIXEL_OPERATION_MODE, 0x11);
 		mt9v022->model = V4L2_IDENT_MT9V022IX7ATM;
-		icd->formats = mt9v022_monochrome_formats;
+		mt9v022->fmts = mt9v022_monochrome_fmts;
 	}
 
 	if (ret < 0)
 		goto ei2c;
 
-	icd->num_formats = 0;
+	mt9v022->num_fmts = 0;
 
 	/*
 	 * This is a 10bit sensor, so by default we only allow 10bit.
@@ -772,14 +770,14 @@ static int mt9v022_video_probe(struct soc_camera_device *icd,
 		flags = SOCAM_DATAWIDTH_10;
 
 	if (flags & SOCAM_DATAWIDTH_10)
-		icd->num_formats++;
+		mt9v022->num_fmts++;
 	else
-		icd->formats++;
+		mt9v022->fmts++;
 
 	if (flags & SOCAM_DATAWIDTH_8)
-		icd->num_formats++;
+		mt9v022->num_fmts++;
 
-	mt9v022->fourcc = icd->formats->fourcc;
+	mt9v022->fmt = &mt9v022->fmts[0];
 
 	dev_info(&client->dev, "Detected a MT9V022 chip ID %x, %s sensor\n",
 		 data, mt9v022->model == V4L2_IDENT_MT9V022IX7ATM ?
@@ -823,14 +821,28 @@ static struct v4l2_subdev_core_ops mt9v022_subdev_core_ops = {
 #endif
 };
 
+static int mt9v022_enum_fmt(struct v4l2_subdev *sd, int index,
+			    enum v4l2_mbus_pixelcode *code)
+{
+	struct i2c_client *client = sd->priv;
+	struct mt9v022 *mt9v022 = to_mt9v022(client);
+
+	if ((unsigned int)index >= mt9v022->num_fmts)
+		return -EINVAL;
+
+	*code = mt9v022->fmts[index].code;
+	return 0;
+}
+
 static struct v4l2_subdev_video_ops mt9v022_subdev_video_ops = {
 	.s_stream	= mt9v022_s_stream,
-	.s_fmt		= mt9v022_s_fmt,
-	.g_fmt		= mt9v022_g_fmt,
-	.try_fmt	= mt9v022_try_fmt,
+	.s_mbus_fmt	= mt9v022_s_fmt,
+	.g_mbus_fmt	= mt9v022_g_fmt,
+	.try_mbus_fmt	= mt9v022_try_fmt,
 	.s_crop		= mt9v022_s_crop,
 	.g_crop		= mt9v022_g_crop,
 	.cropcap	= mt9v022_cropcap,
+	.enum_mbus_fmt	= mt9v022_enum_fmt,
 };
 
 static struct v4l2_subdev_sensor_ops mt9v022_subdev_sensor_ops = {
diff --git a/drivers/media/video/mx1_camera.c b/drivers/media/video/mx1_camera.c
index 4c1a439..2ba14fb 100644
--- a/drivers/media/video/mx1_camera.c
+++ b/drivers/media/video/mx1_camera.c
@@ -37,6 +37,7 @@
 #include <media/v4l2-common.h>
 #include <media/v4l2-dev.h>
 #include <media/videobuf-dma-contig.h>
+#include <media/soc_mediabus.h>
 
 #include <asm/dma.h>
 #include <asm/fiq.h>
@@ -94,9 +95,9 @@
 /* buffer for one video frame */
 struct mx1_buffer {
 	/* common v4l buffer stuff -- must be first */
-	struct videobuf_buffer vb;
-	const struct soc_camera_data_format *fmt;
-	int inwork;
+	struct videobuf_buffer		vb;
+	enum v4l2_mbus_pixelcode	code;
+	int				inwork;
 };
 
 /*
@@ -128,9 +129,13 @@ static int mx1_videobuf_setup(struct videobuf_queue *vq, unsigned int *count,
 			      unsigned int *size)
 {
 	struct soc_camera_device *icd = vq->priv_data;
+	int bytes_per_line = soc_mbus_bytes_per_line(icd->user_width,
+						icd->current_fmt->host_fmt);
 
-	*size = icd->user_width * icd->user_height *
-		((icd->current_fmt->depth + 7) >> 3);
+	if (bytes_per_line < 0)
+		return bytes_per_line;
+
+	*size = bytes_per_line * icd->user_height;
 
 	if (!*count)
 		*count = 32;
@@ -169,6 +174,11 @@ static int mx1_videobuf_prepare(struct videobuf_queue *vq,
 	struct soc_camera_device *icd = vq->priv_data;
 	struct mx1_buffer *buf = container_of(vb, struct mx1_buffer, vb);
 	int ret;
+	int bytes_per_line = soc_mbus_bytes_per_line(icd->user_width,
+						icd->current_fmt->host_fmt);
+
+	if (bytes_per_line < 0)
+		return bytes_per_line;
 
 	dev_dbg(icd->dev.parent, "%s (vb=0x%p) 0x%08lx %d\n", __func__,
 		vb, vb->baddr, vb->bsize);
@@ -184,18 +194,18 @@ static int mx1_videobuf_prepare(struct videobuf_queue *vq,
 	 */
 	buf->inwork = 1;
 
-	if (buf->fmt	!= icd->current_fmt ||
+	if (buf->code	!= icd->current_fmt->code ||
 	    vb->width	!= icd->user_width ||
 	    vb->height	!= icd->user_height ||
 	    vb->field	!= field) {
-		buf->fmt	= icd->current_fmt;
+		buf->code	= icd->current_fmt->code;
 		vb->width	= icd->user_width;
 		vb->height	= icd->user_height;
 		vb->field	= field;
 		vb->state	= VIDEOBUF_NEEDS_INIT;
 	}
 
-	vb->size = vb->width * vb->height * ((buf->fmt->depth + 7) >> 3);
+	vb->size = bytes_per_line * vb->height;
 	if (0 != vb->baddr && vb->bsize < vb->size) {
 		ret = -EINVAL;
 		goto out;
@@ -497,12 +507,10 @@ static int mx1_camera_set_bus_param(struct soc_camera_device *icd, __u32 pixfmt)
 
 	/* MX1 supports only 8bit buswidth */
 	common_flags = soc_camera_bus_param_compatible(camera_flags,
-							       CSI_BUS_FLAGS);
+						       CSI_BUS_FLAGS);
 	if (!common_flags)
 		return -EINVAL;
 
-	icd->buswidth = 8;
-
 	/* Make choises, based on platform choice */
 	if ((common_flags & SOCAM_VSYNC_ACTIVE_HIGH) &&
 		(common_flags & SOCAM_VSYNC_ACTIVE_LOW)) {
@@ -555,7 +563,8 @@ static int mx1_camera_set_fmt(struct soc_camera_device *icd,
 	struct v4l2_subdev *sd = soc_camera_to_subdev(icd);
 	const struct soc_camera_format_xlate *xlate;
 	struct v4l2_pix_format *pix = &f->fmt.pix;
-	int ret;
+	struct v4l2_mbus_framefmt mf;
+	int ret, buswidth;
 
 	xlate = soc_camera_xlate_by_fourcc(icd, pix->pixelformat);
 	if (!xlate) {
@@ -564,12 +573,33 @@ static int mx1_camera_set_fmt(struct soc_camera_device *icd,
 		return -EINVAL;
 	}
 
-	ret = v4l2_subdev_call(sd, video, s_fmt, f);
-	if (!ret) {
-		icd->buswidth = xlate->buswidth;
-		icd->current_fmt = xlate->host_fmt;
+	buswidth = xlate->host_fmt->bits_per_sample;
+	if (buswidth > 8) {
+		dev_warn(icd->dev.parent,
+			 "bits-per-sample %d for format %x unsupported\n",
+			 buswidth, pix->pixelformat);
+		return -EINVAL;
 	}
 
+	mf.width	= pix->width;
+	mf.height	= pix->height;
+	mf.field	= pix->field;
+	mf.colorspace	= pix->colorspace;
+	mf.code		= xlate->code;
+
+	ret = v4l2_subdev_call(sd, video, s_mbus_fmt, &mf);
+	if (ret < 0)
+		return ret;
+
+	if (mf.code != xlate->code)
+		return -EINVAL;
+
+	pix->width		= mf.width;
+	pix->height		= mf.height;
+	pix->field		= mf.field;
+	pix->colorspace		= mf.colorspace;
+	icd->current_fmt	= xlate;
+
 	return ret;
 }
 
@@ -577,10 +607,36 @@ static int mx1_camera_try_fmt(struct soc_camera_device *icd,
 			      struct v4l2_format *f)
 {
 	struct v4l2_subdev *sd = soc_camera_to_subdev(icd);
+	const struct soc_camera_format_xlate *xlate;
+	struct v4l2_pix_format *pix = &f->fmt.pix;
+	struct v4l2_mbus_framefmt mf;
+	int ret;
 	/* TODO: limit to mx1 hardware capabilities */
 
+	xlate = soc_camera_xlate_by_fourcc(icd, pix->pixelformat);
+	if (!xlate) {
+		dev_warn(icd->dev.parent, "Format %x not found\n",
+			 pix->pixelformat);
+		return -EINVAL;
+	}
+
+	mf.width	= pix->width;
+	mf.height	= pix->height;
+	mf.field	= pix->field;
+	mf.colorspace	= pix->colorspace;
+	mf.code		= xlate->code;
+
 	/* limit to sensor capabilities */
-	return v4l2_subdev_call(sd, video, try_fmt, f);
+	ret = v4l2_subdev_call(sd, video, try_mbus_fmt, &mf);
+	if (ret < 0)
+		return ret;
+
+	pix->width	= mf.width;
+	pix->height	= mf.height;
+	pix->field	= mf.field;
+	pix->colorspace	= mf.colorspace;
+
+	return 0;
 }
 
 static int mx1_camera_reqbufs(struct soc_camera_file *icf,
diff --git a/drivers/media/video/mx3_camera.c b/drivers/media/video/mx3_camera.c
index ae7d483..566e9b4 100644
--- a/drivers/media/video/mx3_camera.c
+++ b/drivers/media/video/mx3_camera.c
@@ -23,6 +23,7 @@
 #include <media/v4l2-dev.h>
 #include <media/videobuf-dma-contig.h>
 #include <media/soc_camera.h>
+#include <media/soc_mediabus.h>
 
 #include <mach/ipu.h>
 #include <mach/mx3_camera.h>
@@ -63,7 +64,7 @@
 struct mx3_camera_buffer {
 	/* common v4l buffer stuff -- must be first */
 	struct videobuf_buffer			vb;
-	const struct soc_camera_data_format	*fmt;
+	enum v4l2_mbus_pixelcode		code;
 
 	/* One descriptot per scatterlist (per frame) */
 	struct dma_async_tx_descriptor		*txd;
@@ -118,8 +119,6 @@ struct dma_chan_request {
 	enum ipu_channel	id;
 };
 
-static int mx3_camera_set_bus_param(struct soc_camera_device *icd, __u32 pixfmt);
-
 static u32 csi_reg_read(struct mx3_camera_dev *mx3, off_t reg)
 {
 	return __raw_readl(mx3->base + reg);
@@ -211,17 +210,16 @@ static int mx3_videobuf_setup(struct videobuf_queue *vq, unsigned int *count,
 	struct soc_camera_device *icd = vq->priv_data;
 	struct soc_camera_host *ici = to_soc_camera_host(icd->dev.parent);
 	struct mx3_camera_dev *mx3_cam = ici->priv;
-	/*
-	 * bits-per-pixel (depth) as specified in camera's pixel format does
-	 * not necessarily match what the camera interface writes to RAM, but
-	 * it should be good enough for now.
-	 */
-	unsigned int bpp = DIV_ROUND_UP(icd->current_fmt->depth, 8);
+	int bytes_per_line = soc_mbus_bytes_per_line(icd->user_width,
+						icd->current_fmt->host_fmt);
+
+	if (bytes_per_line < 0)
+		return bytes_per_line;
 
 	if (!mx3_cam->idmac_channel[0])
 		return -EINVAL;
 
-	*size = icd->user_width * icd->user_height * bpp;
+	*size = bytes_per_line * icd->user_height;
 
 	if (!*count)
 		*count = 32;
@@ -241,21 +239,26 @@ static int mx3_videobuf_prepare(struct videobuf_queue *vq,
 	struct mx3_camera_dev *mx3_cam = ici->priv;
 	struct mx3_camera_buffer *buf =
 		container_of(vb, struct mx3_camera_buffer, vb);
-	/* current_fmt _must_ always be set */
-	size_t new_size = icd->user_width * icd->user_height *
-		((icd->current_fmt->depth + 7) >> 3);
+	size_t new_size;
 	int ret;
+	int bytes_per_line = soc_mbus_bytes_per_line(icd->user_width,
+						icd->current_fmt->host_fmt);
+
+	if (bytes_per_line < 0)
+		return bytes_per_line;
+
+	new_size = bytes_per_line * icd->user_height;
 
 	/*
 	 * I think, in buf_prepare you only have to protect global data,
 	 * the actual buffer is yours
 	 */
 
-	if (buf->fmt	!= icd->current_fmt ||
+	if (buf->code	!= icd->current_fmt->code ||
 	    vb->width	!= icd->user_width ||
 	    vb->height	!= icd->user_height ||
 	    vb->field	!= field) {
-		buf->fmt	= icd->current_fmt;
+		buf->code	= icd->current_fmt->code;
 		vb->width	= icd->user_width;
 		vb->height	= icd->user_height;
 		vb->field	= field;
@@ -348,13 +351,13 @@ static void mx3_videobuf_queue(struct videobuf_queue *vq,
 	struct dma_async_tx_descriptor *txd = buf->txd;
 	struct idmac_channel *ichan = to_idmac_chan(txd->chan);
 	struct idmac_video_param *video = &ichan->params.video;
-	const struct soc_camera_data_format *data_fmt = icd->current_fmt;
 	dma_cookie_t cookie;
+	u32 fourcc = icd->current_fmt->host_fmt->fourcc;
 
 	BUG_ON(!irqs_disabled());
 
 	/* This is the configuration of one sg-element */
-	video->out_pixel_fmt	= fourcc_to_ipu_pix(data_fmt->fourcc);
+	video->out_pixel_fmt	= fourcc_to_ipu_pix(fourcc);
 	video->out_width	= icd->user_width;
 	video->out_height	= icd->user_height;
 	video->out_stride	= icd->user_width;
@@ -568,28 +571,33 @@ static int test_platform_param(struct mx3_camera_dev *mx3_cam,
 	 * If requested data width is supported by the platform, use it or any
 	 * possible lower value - i.MX31 is smart enough to schift bits
 	 */
+	if (mx3_cam->platform_flags & MX3_CAMERA_DATAWIDTH_15)
+		*flags |= SOCAM_DATAWIDTH_15 | SOCAM_DATAWIDTH_10 |
+			SOCAM_DATAWIDTH_8 | SOCAM_DATAWIDTH_4;
+	else if (mx3_cam->platform_flags & MX3_CAMERA_DATAWIDTH_10)
+		*flags |= SOCAM_DATAWIDTH_10 | SOCAM_DATAWIDTH_8 |
+			SOCAM_DATAWIDTH_4;
+	else if (mx3_cam->platform_flags & MX3_CAMERA_DATAWIDTH_8)
+		*flags |= SOCAM_DATAWIDTH_8 | SOCAM_DATAWIDTH_4;
+	else if (mx3_cam->platform_flags & MX3_CAMERA_DATAWIDTH_4)
+		*flags |= SOCAM_DATAWIDTH_4;
+
 	switch (buswidth) {
 	case 15:
-		if (!(mx3_cam->platform_flags & MX3_CAMERA_DATAWIDTH_15))
+		if (!(*flags & SOCAM_DATAWIDTH_15))
 			return -EINVAL;
-		*flags |= SOCAM_DATAWIDTH_15 | SOCAM_DATAWIDTH_10 |
-			SOCAM_DATAWIDTH_8 | SOCAM_DATAWIDTH_4;
 		break;
 	case 10:
-		if (!(mx3_cam->platform_flags & MX3_CAMERA_DATAWIDTH_10))
+		if (!(*flags & SOCAM_DATAWIDTH_10))
 			return -EINVAL;
-		*flags |= SOCAM_DATAWIDTH_10 | SOCAM_DATAWIDTH_8 |
-			SOCAM_DATAWIDTH_4;
 		break;
 	case 8:
-		if (!(mx3_cam->platform_flags & MX3_CAMERA_DATAWIDTH_8))
+		if (!(*flags & SOCAM_DATAWIDTH_8))
 			return -EINVAL;
-		*flags |= SOCAM_DATAWIDTH_8 | SOCAM_DATAWIDTH_4;
 		break;
 	case 4:
-		if (!(mx3_cam->platform_flags & MX3_CAMERA_DATAWIDTH_4))
+		if (!(*flags & SOCAM_DATAWIDTH_4))
 			return -EINVAL;
-		*flags |= SOCAM_DATAWIDTH_4;
 		break;
 	default:
 		dev_warn(mx3_cam->soc_host.v4l2_dev.dev,
@@ -638,91 +646,92 @@ static bool chan_filter(struct dma_chan *chan, void *arg)
 		pdata->dma_dev == chan->device->dev;
 }
 
-static const struct soc_camera_data_format mx3_camera_formats[] = {
+static const struct soc_mbus_pixelfmt mx3_camera_formats[] = {
 	{
-		.name		= "Bayer (sRGB) 8 bit",
-		.depth		= 8,
-		.fourcc		= V4L2_PIX_FMT_SBGGR8,
-		.colorspace	= V4L2_COLORSPACE_SRGB,
+		.fourcc			= V4L2_PIX_FMT_SBGGR8,
+		.name			= "Bayer BGGR (sRGB) 8 bit",
+		.bits_per_sample	= 8,
+		.packing		= SOC_MBUS_PACKING_NONE,
+		.order			= SOC_MBUS_ORDER_LE,
 	}, {
-		.name		= "Monochrome 8 bit",
-		.depth		= 8,
-		.fourcc		= V4L2_PIX_FMT_GREY,
-		.colorspace	= V4L2_COLORSPACE_JPEG,
+		.fourcc			= V4L2_PIX_FMT_GREY,
+		.name			= "Monochrome 8 bit",
+		.bits_per_sample	= 8,
+		.packing		= SOC_MBUS_PACKING_NONE,
+		.order			= SOC_MBUS_ORDER_LE,
 	},
 };
 
-static bool buswidth_supported(struct soc_camera_host *ici, int depth)
+/* This will be corrected as we get more formats */
+static bool mx3_camera_packing_supported(const struct soc_mbus_pixelfmt *fmt)
 {
-	struct mx3_camera_dev *mx3_cam = ici->priv;
-
-	switch (depth) {
-	case 4:
-		return !!(mx3_cam->platform_flags & MX3_CAMERA_DATAWIDTH_4);
-	case 8:
-		return !!(mx3_cam->platform_flags & MX3_CAMERA_DATAWIDTH_8);
-	case 10:
-		return !!(mx3_cam->platform_flags & MX3_CAMERA_DATAWIDTH_10);
-	case 15:
-		return !!(mx3_cam->platform_flags & MX3_CAMERA_DATAWIDTH_15);
-	}
-	return false;
+	return	fmt->packing == SOC_MBUS_PACKING_NONE ||
+		(fmt->bits_per_sample == 8 &&
+		 fmt->packing == SOC_MBUS_PACKING_2X8_PADHI) ||
+		(fmt->bits_per_sample > 8 &&
+		 fmt->packing == SOC_MBUS_PACKING_EXTEND16);
 }
 
 static int mx3_camera_get_formats(struct soc_camera_device *icd, int idx,
 				  struct soc_camera_format_xlate *xlate)
 {
-	struct soc_camera_host *ici = to_soc_camera_host(icd->dev.parent);
-	int formats = 0, buswidth, ret;
+	struct v4l2_subdev *sd = soc_camera_to_subdev(icd);
+	struct device *dev = icd->dev.parent;
+	int formats = 0, ret;
+	enum v4l2_mbus_pixelcode code;
+	const struct soc_mbus_pixelfmt *fmt;
 
-	buswidth = icd->formats[idx].depth;
+	ret = v4l2_subdev_call(sd, video, enum_mbus_fmt, idx, &code);
+	if (ret < 0)
+		/* No more formats */
+		return 0;
 
-	if (!buswidth_supported(ici, buswidth))
+	fmt = soc_mbus_get_fmtdesc(code);
+	if (!fmt) {
+		dev_err(icd->dev.parent,
+			"Invalid format code #%d: %d\n", idx, code);
 		return 0;
+	}
 
-	ret = mx3_camera_try_bus_param(icd, buswidth);
+	/* This also checks support for the requested bits-per-sample */
+	ret = mx3_camera_try_bus_param(icd, fmt->bits_per_sample);
 	if (ret < 0)
 		return 0;
 
-	switch (icd->formats[idx].fourcc) {
-	case V4L2_PIX_FMT_SGRBG10:
+	switch (code) {
+	case V4L2_MBUS_FMT_SBGGR10:
 		formats++;
 		if (xlate) {
-			xlate->host_fmt = &mx3_camera_formats[0];
-			xlate->cam_fmt = icd->formats + idx;
-			xlate->buswidth = buswidth;
+			xlate->host_fmt	= &mx3_camera_formats[0];
+			xlate->code	= code;
 			xlate++;
-			dev_dbg(icd->dev.parent,
-				"Providing format %s using %s\n",
-				mx3_camera_formats[0].name,
-				icd->formats[idx].name);
+			dev_dbg(dev, "Providing format %s using code %d\n",
+				mx3_camera_formats[0].name, code);
 		}
-		goto passthrough;
-	case V4L2_PIX_FMT_Y16:
+		break;
+	case V4L2_MBUS_FMT_Y10:
 		formats++;
 		if (xlate) {
-			xlate->host_fmt = &mx3_camera_formats[1];
-			xlate->cam_fmt = icd->formats + idx;
-			xlate->buswidth = buswidth;
+			xlate->host_fmt	= &mx3_camera_formats[1];
+			xlate->code	= code;
 			xlate++;
-			dev_dbg(icd->dev.parent,
-				"Providing format %s using %s\n",
-				mx3_camera_formats[0].name,
-				icd->formats[idx].name);
+			dev_dbg(dev, "Providing format %s using code %d\n",
+				mx3_camera_formats[1].name, code);
 		}
+		break;
 	default:
-passthrough:
-		/* Generic pass-through */
-		formats++;
-		if (xlate) {
-			xlate->host_fmt = icd->formats + idx;
-			xlate->cam_fmt = icd->formats + idx;
-			xlate->buswidth = buswidth;
-			xlate++;
-			dev_dbg(icd->dev.parent,
-				"Providing format %s in pass-through mode\n",
-				icd->formats[idx].name);
-		}
+		if (!mx3_camera_packing_supported(fmt))
+			return 0;
+	}
+
+	/* Generic pass-through */
+	formats++;
+	if (xlate) {
+		xlate->host_fmt	= fmt;
+		xlate->code	= code;
+		xlate++;
+		dev_dbg(dev, "Providing format %x in pass-through mode\n",
+			xlate->host_fmt->fourcc);
 	}
 
 	return formats;
@@ -806,8 +815,7 @@ static int mx3_camera_set_crop(struct soc_camera_device *icd,
 	struct soc_camera_host *ici = to_soc_camera_host(icd->dev.parent);
 	struct mx3_camera_dev *mx3_cam = ici->priv;
 	struct v4l2_subdev *sd = soc_camera_to_subdev(icd);
-	struct v4l2_format f = {.type = V4L2_BUF_TYPE_VIDEO_CAPTURE};
-	struct v4l2_pix_format *pix = &f.fmt.pix;
+	struct v4l2_mbus_framefmt mf;
 	int ret;
 
 	soc_camera_limit_side(&rect->left, &rect->width, 0, 2, 4096);
@@ -818,19 +826,19 @@ static int mx3_camera_set_crop(struct soc_camera_device *icd,
 		return ret;
 
 	/* The capture device might have changed its output  */
-	ret = v4l2_subdev_call(sd, video, g_fmt, &f);
+	ret = v4l2_subdev_call(sd, video, g_mbus_fmt, &mf);
 	if (ret < 0)
 		return ret;
 
-	if (pix->width & 7) {
+	if (mf.width & 7) {
 		/* Ouch! We can only handle 8-byte aligned width... */
-		stride_align(&pix->width);
-		ret = v4l2_subdev_call(sd, video, s_fmt, &f);
+		stride_align(&mf.width);
+		ret = v4l2_subdev_call(sd, video, s_mbus_fmt, &mf);
 		if (ret < 0)
 			return ret;
 	}
 
-	if (pix->width != icd->user_width || pix->height != icd->user_height) {
+	if (mf.width != icd->user_width || mf.height != icd->user_height) {
 		/*
 		 * We now know pixel formats and can decide upon DMA-channel(s)
 		 * So far only direct camera-to-memory is supported
@@ -841,14 +849,14 @@ static int mx3_camera_set_crop(struct soc_camera_device *icd,
 				return ret;
 		}
 
-		configure_geometry(mx3_cam, pix->width, pix->height);
+		configure_geometry(mx3_cam, mf.width, mf.height);
 	}
 
 	dev_dbg(icd->dev.parent, "Sensor cropped %dx%d\n",
-		pix->width, pix->height);
+		mf.width, mf.height);
 
-	icd->user_width = pix->width;
-	icd->user_height = pix->height;
+	icd->user_width		= mf.width;
+	icd->user_height	= mf.height;
 
 	return ret;
 }
@@ -861,6 +869,7 @@ static int mx3_camera_set_fmt(struct soc_camera_device *icd,
 	struct v4l2_subdev *sd = soc_camera_to_subdev(icd);
 	const struct soc_camera_format_xlate *xlate;
 	struct v4l2_pix_format *pix = &f->fmt.pix;
+	struct v4l2_mbus_framefmt mf;
 	int ret;
 
 	xlate = soc_camera_xlate_by_fourcc(icd, pix->pixelformat);
@@ -885,11 +894,24 @@ static int mx3_camera_set_fmt(struct soc_camera_device *icd,
 
 	configure_geometry(mx3_cam, pix->width, pix->height);
 
-	ret = v4l2_subdev_call(sd, video, s_fmt, f);
-	if (!ret) {
-		icd->buswidth = xlate->buswidth;
-		icd->current_fmt = xlate->host_fmt;
-	}
+	mf.width	= pix->width;
+	mf.height	= pix->height;
+	mf.field	= pix->field;
+	mf.colorspace	= pix->colorspace;
+	mf.code		= xlate->code;
+
+	ret = v4l2_subdev_call(sd, video, s_mbus_fmt, &mf);
+	if (ret < 0)
+		return ret;
+
+	if (mf.code != xlate->code)
+		return -EINVAL;
+
+	pix->width		= mf.width;
+	pix->height		= mf.height;
+	pix->field		= mf.field;
+	pix->colorspace		= mf.colorspace;
+	icd->current_fmt	= xlate;
 
 	dev_dbg(icd->dev.parent, "Sensor set %dx%d\n", pix->width, pix->height);
 
@@ -902,8 +924,8 @@ static int mx3_camera_try_fmt(struct soc_camera_device *icd,
 	struct v4l2_subdev *sd = soc_camera_to_subdev(icd);
 	const struct soc_camera_format_xlate *xlate;
 	struct v4l2_pix_format *pix = &f->fmt.pix;
+	struct v4l2_mbus_framefmt mf;
 	__u32 pixfmt = pix->pixelformat;
-	enum v4l2_field field;
 	int ret;
 
 	xlate = soc_camera_xlate_by_fourcc(icd, pixfmt);
@@ -918,23 +940,37 @@ static int mx3_camera_try_fmt(struct soc_camera_device *icd,
 	if (pix->width > 4096)
 		pix->width = 4096;
 
-	pix->bytesperline = pix->width *
-		DIV_ROUND_UP(xlate->host_fmt->depth, 8);
+	pix->bytesperline = soc_mbus_bytes_per_line(pix->width,
+						    xlate->host_fmt);
+	if (pix->bytesperline < 0)
+		return pix->bytesperline;
 	pix->sizeimage = pix->height * pix->bytesperline;
 
-	/* camera has to see its format, but the user the original one */
-	pix->pixelformat = xlate->cam_fmt->fourcc;
 	/* limit to sensor capabilities */
-	ret = v4l2_subdev_call(sd, video, try_fmt, f);
-	pix->pixelformat = xlate->host_fmt->fourcc;
+	mf.width	= pix->width;
+	mf.height	= pix->height;
+	mf.field	= pix->field;
+	mf.colorspace	= pix->colorspace;
+	mf.code		= xlate->code;
 
-	field = pix->field;
+	ret = v4l2_subdev_call(sd, video, try_mbus_fmt, &mf);
+	if (ret < 0)
+		return ret;
 
-	if (field == V4L2_FIELD_ANY) {
+	pix->width	= mf.width;
+	pix->height	= mf.height;
+	pix->colorspace	= mf.colorspace;
+
+	switch (mf.field) {
+	case V4L2_FIELD_ANY:
 		pix->field = V4L2_FIELD_NONE;
-	} else if (field != V4L2_FIELD_NONE) {
-		dev_err(icd->dev.parent, "Field type %d unsupported.\n", field);
-		return -EINVAL;
+		break;
+	case V4L2_FIELD_NONE:
+		break;
+	default:
+		dev_err(icd->dev.parent, "Field type %d unsupported.\n",
+			mf.field);
+		ret = -EINVAL;
 	}
 
 	return ret;
@@ -970,18 +1006,26 @@ static int mx3_camera_set_bus_param(struct soc_camera_device *icd, __u32 pixfmt)
 	struct mx3_camera_dev *mx3_cam = ici->priv;
 	unsigned long bus_flags, camera_flags, common_flags;
 	u32 dw, sens_conf;
-	int ret = test_platform_param(mx3_cam, icd->buswidth, &bus_flags);
+	const struct soc_mbus_pixelfmt *fmt;
+	int buswidth;
+	int ret;
 	const struct soc_camera_format_xlate *xlate;
 	struct device *dev = icd->dev.parent;
 
+	fmt = soc_mbus_get_fmtdesc(icd->current_fmt->code);
+	if (!fmt)
+		return -EINVAL;
+
+	buswidth = fmt->bits_per_sample;
+	ret = test_platform_param(mx3_cam, buswidth, &bus_flags);
+
 	xlate = soc_camera_xlate_by_fourcc(icd, pixfmt);
 	if (!xlate) {
 		dev_warn(dev, "Format %x not found\n", pixfmt);
 		return -EINVAL;
 	}
 
-	dev_dbg(dev, "requested bus width %d bit: %d\n",
-		icd->buswidth, ret);
+	dev_dbg(dev, "requested bus width %d bit: %d\n", buswidth, ret);
 
 	if (ret < 0)
 		return ret;
@@ -1082,7 +1126,7 @@ static int mx3_camera_set_bus_param(struct soc_camera_device *icd, __u32 pixfmt)
 		sens_conf |= 1 << CSI_SENS_CONF_DATA_POL_SHIFT;
 
 	/* Just do what we're asked to do */
-	switch (xlate->host_fmt->depth) {
+	switch (xlate->host_fmt->bits_per_sample) {
 	case 4:
 		dw = 0 << CSI_SENS_CONF_DATA_WIDTH_SHIFT;
 		break;
diff --git a/drivers/media/video/ov772x.c b/drivers/media/video/ov772x.c
index dbaf508..9f00aa1 100644
--- a/drivers/media/video/ov772x.c
+++ b/drivers/media/video/ov772x.c
@@ -24,6 +24,7 @@
 #include <media/v4l2-chip-ident.h>
 #include <media/v4l2-subdev.h>
 #include <media/soc_camera.h>
+#include <media/soc_mediabus.h>
 #include <media/ov772x.h>
 
 /*
@@ -382,7 +383,7 @@ struct regval_list {
 };
 
 struct ov772x_color_format {
-	const struct soc_camera_data_format *format;
+	const struct soc_mbus_datafmt *fmt;
 	u8 dsp3;
 	u8 com3;
 	u8 com7;
@@ -399,7 +400,7 @@ struct ov772x_win_size {
 struct ov772x_priv {
 	struct v4l2_subdev                subdev;
 	struct ov772x_camera_info        *info;
-	const struct ov772x_color_format *fmt;
+	const struct ov772x_color_format *cfmt;
 	const struct ov772x_win_size     *win;
 	int                               model;
 	unsigned short                    flag_vflip:1;
@@ -433,94 +434,71 @@ static const struct regval_list ov772x_vga_regs[] = {
 	ENDMARKER,
 };
 
-/*
- * supported format list
- */
+enum ov772x_fmt {
+	OV772X_FMT_YUYV,
+	OV772X_FMT_YVYU,
+	OV772X_FMT_UYVY,
+	OV772X_FMT_RGB555,
+	OV772X_FMT_RGB555X,
+	OV772X_FMT_RGB565,
+	OV772X_FMT_RGB565X,
+};
 
-#define SETFOURCC(type) .name = (#type), .fourcc = (V4L2_PIX_FMT_ ## type)
-static const struct soc_camera_data_format ov772x_fmt_lists[] = {
-	{
-		SETFOURCC(YUYV),
-		.depth      = 16,
-		.colorspace = V4L2_COLORSPACE_JPEG,
-	},
-	{
-		SETFOURCC(YVYU),
-		.depth      = 16,
-		.colorspace = V4L2_COLORSPACE_JPEG,
-	},
-	{
-		SETFOURCC(UYVY),
-		.depth      = 16,
-		.colorspace = V4L2_COLORSPACE_JPEG,
-	},
-	{
-		SETFOURCC(RGB555),
-		.depth      = 16,
-		.colorspace = V4L2_COLORSPACE_SRGB,
-	},
-	{
-		SETFOURCC(RGB555X),
-		.depth      = 16,
-		.colorspace = V4L2_COLORSPACE_SRGB,
-	},
-	{
-		SETFOURCC(RGB565),
-		.depth      = 16,
-		.colorspace = V4L2_COLORSPACE_SRGB,
-	},
-	{
-		SETFOURCC(RGB565X),
-		.depth      = 16,
-		.colorspace = V4L2_COLORSPACE_SRGB,
-	},
+static const struct soc_mbus_datafmt ov772x_fmts[] = {
+	[OV772X_FMT_YUYV]	= {V4L2_MBUS_FMT_YUYV, V4L2_COLORSPACE_JPEG},
+	[OV772X_FMT_YVYU]	= {V4L2_MBUS_FMT_YVYU, V4L2_COLORSPACE_JPEG},
+	[OV772X_FMT_UYVY]	= {V4L2_MBUS_FMT_UYVY, V4L2_COLORSPACE_JPEG},
+	[OV772X_FMT_RGB555]	= {V4L2_MBUS_FMT_RGB555, V4L2_COLORSPACE_SRGB},
+	[OV772X_FMT_RGB555X]	= {V4L2_MBUS_FMT_RGB555X, V4L2_COLORSPACE_SRGB},
+	[OV772X_FMT_RGB565]	= {V4L2_MBUS_FMT_RGB565, V4L2_COLORSPACE_SRGB},
+	[OV772X_FMT_RGB565X]	= {V4L2_MBUS_FMT_RGB565X, V4L2_COLORSPACE_SRGB},
 };
 
 /*
- * color format list
+ * supported color format list
  */
 static const struct ov772x_color_format ov772x_cfmts[] = {
 	{
-		.format = &ov772x_fmt_lists[0],
-		.dsp3   = 0x0,
-		.com3   = SWAP_YUV,
-		.com7   = OFMT_YUV,
+		.fmt	= &ov772x_fmts[OV772X_FMT_YUYV],
+		.dsp3	= 0x0,
+		.com3	= SWAP_YUV,
+		.com7	= OFMT_YUV,
 	},
 	{
-		.format = &ov772x_fmt_lists[1],
-		.dsp3   = UV_ON,
-		.com3   = SWAP_YUV,
-		.com7   = OFMT_YUV,
+		.fmt	= &ov772x_fmts[OV772X_FMT_YVYU],
+		.dsp3	= UV_ON,
+		.com3	= SWAP_YUV,
+		.com7	= OFMT_YUV,
 	},
 	{
-		.format = &ov772x_fmt_lists[2],
-		.dsp3   = 0x0,
-		.com3   = 0x0,
-		.com7   = OFMT_YUV,
+		.fmt	= &ov772x_fmts[OV772X_FMT_UYVY],
+		.dsp3	= 0x0,
+		.com3	= 0x0,
+		.com7	= OFMT_YUV,
 	},
 	{
-		.format = &ov772x_fmt_lists[3],
-		.dsp3   = 0x0,
-		.com3   = SWAP_RGB,
-		.com7   = FMT_RGB555 | OFMT_RGB,
+		.fmt	= &ov772x_fmts[OV772X_FMT_RGB555],
+		.dsp3	= 0x0,
+		.com3	= SWAP_RGB,
+		.com7	= FMT_RGB555 | OFMT_RGB,
 	},
 	{
-		.format = &ov772x_fmt_lists[4],
-		.dsp3   = 0x0,
-		.com3   = 0x0,
-		.com7   = FMT_RGB555 | OFMT_RGB,
+		.fmt	= &ov772x_fmts[OV772X_FMT_RGB555X],
+		.dsp3	= 0x0,
+		.com3	= 0x0,
+		.com7	= FMT_RGB555 | OFMT_RGB,
 	},
 	{
-		.format = &ov772x_fmt_lists[5],
-		.dsp3   = 0x0,
-		.com3   = SWAP_RGB,
-		.com7   = FMT_RGB565 | OFMT_RGB,
+		.fmt	= &ov772x_fmts[OV772X_FMT_RGB565],
+		.dsp3	= 0x0,
+		.com3	= SWAP_RGB,
+		.com7	= FMT_RGB565 | OFMT_RGB,
 	},
 	{
-		.format = &ov772x_fmt_lists[6],
-		.dsp3   = 0x0,
-		.com3   = 0x0,
-		.com7   = FMT_RGB565 | OFMT_RGB,
+		.fmt	= &ov772x_fmts[OV772X_FMT_RGB565X],
+		.dsp3	= 0x0,
+		.com3	= 0x0,
+		.com7	= FMT_RGB565 | OFMT_RGB,
 	},
 };
 
@@ -642,15 +620,15 @@ static int ov772x_s_stream(struct v4l2_subdev *sd, int enable)
 		return 0;
 	}
 
-	if (!priv->win || !priv->fmt) {
+	if (!priv->win || !priv->cfmt) {
 		dev_err(&client->dev, "norm or win select error\n");
 		return -EPERM;
 	}
 
 	ov772x_mask_set(client, COM2, SOFT_SLEEP_MODE, 0);
 
-	dev_dbg(&client->dev, "format %s, win %s\n",
-		priv->fmt->format->name, priv->win->name);
+	dev_dbg(&client->dev, "format %d, win %s\n",
+		priv->cfmt->fmt->code, priv->win->name);
 
 	return 0;
 }
@@ -806,8 +784,8 @@ static const struct ov772x_win_size *ov772x_select_win(u32 width, u32 height)
 	return win;
 }
 
-static int ov772x_set_params(struct i2c_client *client,
-			     u32 *width, u32 *height, u32 pixfmt)
+static int ov772x_set_params(struct i2c_client *client, u32 *width, u32 *height,
+			     enum v4l2_mbus_pixelcode code)
 {
 	struct ov772x_priv *priv = to_ov772x(client);
 	int ret = -EINVAL;
@@ -817,14 +795,14 @@ static int ov772x_set_params(struct i2c_client *client,
 	/*
 	 * select format
 	 */
-	priv->fmt = NULL;
+	priv->cfmt = NULL;
 	for (i = 0; i < ARRAY_SIZE(ov772x_cfmts); i++) {
-		if (pixfmt == ov772x_cfmts[i].format->fourcc) {
-			priv->fmt = ov772x_cfmts + i;
+		if (code == ov772x_cfmts[i].fmt->code) {
+			priv->cfmt = ov772x_cfmts + i;
 			break;
 		}
 	}
-	if (!priv->fmt)
+	if (!priv->cfmt)
 		goto ov772x_set_fmt_error;
 
 	/*
@@ -894,7 +872,7 @@ static int ov772x_set_params(struct i2c_client *client,
 	/*
 	 * set DSP_CTRL3
 	 */
-	val = priv->fmt->dsp3;
+	val = priv->cfmt->dsp3;
 	if (val) {
 		ret = ov772x_mask_set(client,
 				      DSP_CTRL3, UV_MASK, val);
@@ -905,7 +883,7 @@ static int ov772x_set_params(struct i2c_client *client,
 	/*
 	 * set COM3
 	 */
-	val = priv->fmt->com3;
+	val = priv->cfmt->com3;
 	if (priv->info->flags & OV772X_FLAG_VFLIP)
 		val |= VFLIP_IMG;
 	if (priv->info->flags & OV772X_FLAG_HFLIP)
@@ -923,9 +901,9 @@ static int ov772x_set_params(struct i2c_client *client,
 	/*
 	 * set COM7
 	 */
-	val = priv->win->com7_bit | priv->fmt->com7;
+	val = priv->win->com7_bit | priv->cfmt->com7;
 	ret = ov772x_mask_set(client,
-			      COM7, (SLCT_MASK | FMT_MASK | OFMT_MASK),
+			      COM7, SLCT_MASK | FMT_MASK | OFMT_MASK,
 			      val);
 	if (ret < 0)
 		goto ov772x_set_fmt_error;
@@ -951,7 +929,7 @@ ov772x_set_fmt_error:
 
 	ov772x_reset(client);
 	priv->win = NULL;
-	priv->fmt = NULL;
+	priv->cfmt = NULL;
 
 	return ret;
 }
@@ -981,54 +959,71 @@ static int ov772x_cropcap(struct v4l2_subdev *sd, struct v4l2_cropcap *a)
 	return 0;
 }
 
-static int ov772x_g_fmt(struct v4l2_subdev *sd, struct v4l2_format *f)
+static int ov772x_g_fmt(struct v4l2_subdev *sd,
+			struct v4l2_mbus_framefmt *mf)
 {
 	struct i2c_client *client = sd->priv;
 	struct ov772x_priv *priv = to_ov772x(client);
-	struct v4l2_pix_format *pix = &f->fmt.pix;
 
-	if (!priv->win || !priv->fmt) {
+	if (!priv->win || !priv->cfmt) {
 		u32 width = VGA_WIDTH, height = VGA_HEIGHT;
 		int ret = ov772x_set_params(client, &width, &height,
-					    V4L2_PIX_FMT_YUYV);
+					    V4L2_MBUS_FMT_YUYV);
 		if (ret < 0)
 			return ret;
 	}
 
-	f->type			= V4L2_BUF_TYPE_VIDEO_CAPTURE;
-
-	pix->width		= priv->win->width;
-	pix->height		= priv->win->height;
-	pix->pixelformat	= priv->fmt->format->fourcc;
-	pix->colorspace		= priv->fmt->format->colorspace;
-	pix->field		= V4L2_FIELD_NONE;
+	mf->width	= priv->win->width;
+	mf->height	= priv->win->height;
+	mf->code	= priv->cfmt->fmt->code;
+	mf->colorspace	= priv->cfmt->fmt->colorspace;
+	mf->field	= V4L2_FIELD_NONE;
 
 	return 0;
 }
 
-static int ov772x_s_fmt(struct v4l2_subdev *sd, struct v4l2_format *f)
+static int ov772x_s_fmt(struct v4l2_subdev *sd,
+			struct v4l2_mbus_framefmt *mf)
 {
 	struct i2c_client *client = sd->priv;
-	struct v4l2_pix_format *pix = &f->fmt.pix;
+	struct ov772x_priv *priv = to_ov772x(client);
+	int ret = ov772x_set_params(client, &mf->width, &mf->height,
+				    mf->code);
+
+	if (!ret)
+		mf->colorspace = priv->cfmt->fmt->colorspace;
 
-	return ov772x_set_params(client, &pix->width, &pix->height,
-				 pix->pixelformat);
+	return ret;
 }
 
 static int ov772x_try_fmt(struct v4l2_subdev *sd,
-			  struct v4l2_format *f)
+			  struct v4l2_mbus_framefmt *mf)
 {
-	struct v4l2_pix_format *pix = &f->fmt.pix;
+	struct i2c_client *client = sd->priv;
+	struct ov772x_priv *priv = to_ov772x(client);
 	const struct ov772x_win_size *win;
+	const struct soc_mbus_datafmt *fmt;
 
 	/*
 	 * select suitable win
 	 */
-	win = ov772x_select_win(pix->width, pix->height);
+	win = ov772x_select_win(mf->width, mf->height);
+
+	mf->width	= win->width;
+	mf->height	= win->height;
+	mf->field	= V4L2_FIELD_NONE;
+
+	fmt = soc_mbus_find_datafmt(mf->code, ov772x_fmts,
+				    ARRAY_SIZE(ov772x_fmts));
+	if (!fmt) {
+		if (priv->cfmt)
+			fmt = priv->cfmt->fmt;
+		else
+			fmt = &ov772x_fmts[0];
+		mf->code = fmt->code;
+	}
 
-	pix->width  = win->width;
-	pix->height = win->height;
-	pix->field  = V4L2_FIELD_NONE;
+	mf->colorspace	= fmt->colorspace;
 
 	return 0;
 }
@@ -1057,9 +1052,6 @@ static int ov772x_video_probe(struct soc_camera_device *icd,
 		return -ENODEV;
 	}
 
-	icd->formats     = ov772x_fmt_lists;
-	icd->num_formats = ARRAY_SIZE(ov772x_fmt_lists);
-
 	/*
 	 * check and show product ID and manufacturer ID
 	 */
@@ -1109,13 +1101,24 @@ static struct v4l2_subdev_core_ops ov772x_subdev_core_ops = {
 #endif
 };
 
+static int ov772x_enum_fmt(struct v4l2_subdev *sd, int index,
+			   enum v4l2_mbus_pixelcode *code)
+{
+	if ((unsigned int)index >= ARRAY_SIZE(ov772x_cfmts))
+		return -EINVAL;
+
+	*code = ov772x_cfmts[index].fmt->code;
+	return 0;
+}
+
 static struct v4l2_subdev_video_ops ov772x_subdev_video_ops = {
 	.s_stream	= ov772x_s_stream,
-	.g_fmt		= ov772x_g_fmt,
-	.s_fmt		= ov772x_s_fmt,
-	.try_fmt	= ov772x_try_fmt,
+	.g_mbus_fmt	= ov772x_g_fmt,
+	.s_mbus_fmt	= ov772x_s_fmt,
+	.try_mbus_fmt	= ov772x_try_fmt,
 	.cropcap	= ov772x_cropcap,
 	.g_crop		= ov772x_g_crop,
+	.enum_mbus_fmt	= ov772x_enum_fmt,
 };
 
 static struct v4l2_subdev_ops ov772x_subdev_ops = {
diff --git a/drivers/media/video/ov9640.c b/drivers/media/video/ov9640.c
index c81ae21..7fe9064 100644
--- a/drivers/media/video/ov9640.c
+++ b/drivers/media/video/ov9640.c
@@ -28,6 +28,7 @@
 #include <media/v4l2-chip-ident.h>
 #include <media/v4l2-common.h>
 #include <media/soc_camera.h>
+#include <media/soc_mediabus.h>
 
 #include "ov9640.h"
 
@@ -160,13 +161,8 @@ static const struct ov9640_reg ov9640_regs_rgb[] = {
  * this version of the driver. To test and debug these formats add two entries
  * to the below array, see ov722x.c for an example.
  */
-static const struct soc_camera_data_format ov9640_fmt_lists[] = {
-	{
-		.name		= "UYVY",
-		.fourcc		= V4L2_PIX_FMT_UYVY,
-		.depth		= 16,
-		.colorspace	= V4L2_COLORSPACE_JPEG,
-	},
+static const struct soc_mbus_datafmt ov9640_fmt_fmts[] = {
+	{V4L2_MBUS_FMT_UYVY, V4L2_COLORSPACE_JPEG},
 };
 
 static const struct v4l2_queryctrl ov9640_controls[] = {
@@ -434,20 +430,22 @@ static void ov9640_res_roundup(u32 *width, u32 *height)
 }
 
 /* Prepare necessary register changes depending on color encoding */
-static void ov9640_alter_regs(u32 pixfmt, struct ov9640_reg_alt *alt)
+static void ov9640_alter_regs(enum v4l2_mbus_pixelcode code,
+			      struct ov9640_reg_alt *alt)
 {
-	switch (pixfmt) {
-	case V4L2_PIX_FMT_UYVY:
+	switch (code) {
+	default:
+	case V4L2_MBUS_FMT_UYVY:
 		alt->com12	= OV9640_COM12_YUV_AVG;
 		alt->com13	= OV9640_COM13_Y_DELAY_EN |
 					OV9640_COM13_YUV_DLY(0x01);
 		break;
-	case V4L2_PIX_FMT_RGB555:
+	case V4L2_MBUS_FMT_RGB555:
 		alt->com7	= OV9640_COM7_RGB;
 		alt->com13	= OV9640_COM13_RGB_AVG;
 		alt->com15	= OV9640_COM15_RGB_555;
 		break;
-	case V4L2_PIX_FMT_RGB565:
+	case V4L2_MBUS_FMT_RGB565:
 		alt->com7	= OV9640_COM7_RGB;
 		alt->com13	= OV9640_COM13_RGB_AVG;
 		alt->com15	= OV9640_COM15_RGB_565;
@@ -456,8 +454,8 @@ static void ov9640_alter_regs(u32 pixfmt, struct ov9640_reg_alt *alt)
 }
 
 /* Setup registers according to resolution and color encoding */
-static int ov9640_write_regs(struct i2c_client *client,
-		u32 width, u32 pixfmt, struct ov9640_reg_alt *alts)
+static int ov9640_write_regs(struct i2c_client *client, u32 width,
+		enum v4l2_mbus_pixelcode code, struct ov9640_reg_alt *alts)
 {
 	const struct ov9640_reg	*ov9640_regs, *matrix_regs;
 	int			ov9640_regs_len, matrix_regs_len;
@@ -500,7 +498,7 @@ static int ov9640_write_regs(struct i2c_client *client,
 	}
 
 	/* select color matrix configuration for given color encoding */
-	if (pixfmt == V4L2_PIX_FMT_UYVY) {
+	if (code == V4L2_MBUS_FMT_UYVY) {
 		matrix_regs	= ov9640_regs_yuv;
 		matrix_regs_len	= ARRAY_SIZE(ov9640_regs_yuv);
 	} else {
@@ -562,15 +560,15 @@ static int ov9640_prog_dflt(struct i2c_client *client)
 }
 
 /* set the format we will capture in */
-static int ov9640_s_fmt(struct v4l2_subdev *sd, struct v4l2_format *f)
+static int ov9640_s_fmt(struct v4l2_subdev *sd,
+			struct v4l2_mbus_framefmt *mf)
 {
 	struct i2c_client *client = sd->priv;
-	struct v4l2_pix_format *pix = &f->fmt.pix;
 	struct ov9640_reg_alt alts = {0};
 	int ret;
 
-	ov9640_res_roundup(&pix->width, &pix->height);
-	ov9640_alter_regs(pix->pixelformat, &alts);
+	ov9640_res_roundup(&mf->width, &mf->height);
+	ov9640_alter_regs(mf->code, &alts);
 
 	ov9640_reset(client);
 
@@ -578,19 +576,37 @@ static int ov9640_s_fmt(struct v4l2_subdev *sd, struct v4l2_format *f)
 	if (ret)
 		return ret;
 
-	return ov9640_write_regs(client, pix->width, pix->pixelformat, &alts);
+	ret = ov9640_write_regs(client, mf->width, mf->code, &alts);
+	if (!ret) {
+		mf->code	= V4L2_MBUS_FMT_UYVY;
+		mf->colorspace	= V4L2_COLORSPACE_JPEG;
+	}
+
+	return ret;
 }
 
-static int ov9640_try_fmt(struct v4l2_subdev *sd, struct v4l2_format *f)
+static int ov9640_try_fmt(struct v4l2_subdev *sd,
+			  struct v4l2_mbus_framefmt *mf)
 {
-	struct v4l2_pix_format *pix = &f->fmt.pix;
+	ov9640_res_roundup(&mf->width, &mf->height);
 
-	ov9640_res_roundup(&pix->width, &pix->height);
-	pix->field  = V4L2_FIELD_NONE;
+	mf->field	= V4L2_FIELD_NONE;
+	mf->code	= V4L2_MBUS_FMT_UYVY;
+	mf->colorspace	= V4L2_COLORSPACE_JPEG;
 
 	return 0;
 }
 
+static int ov9640_enum_fmt(struct v4l2_subdev *sd, int index,
+			   enum v4l2_mbus_pixelcode *code)
+{
+	if ((unsigned int)index >= ARRAY_SIZE(ov9640_fmt_fmts))
+		return -EINVAL;
+
+	*code = ov9640_fmt_fmts[index].code;
+	return 0;
+}
+
 static int ov9640_g_crop(struct v4l2_subdev *sd, struct v4l2_crop *a)
 {
 	a->c.left	= 0;
@@ -637,9 +653,6 @@ static int ov9640_video_probe(struct soc_camera_device *icd,
 		goto err;
 	}
 
-	icd->formats		= ov9640_fmt_lists;
-	icd->num_formats	= ARRAY_SIZE(ov9640_fmt_lists);
-
 	/*
 	 * check and show product ID and manufacturer ID
 	 */
@@ -702,11 +715,12 @@ static struct v4l2_subdev_core_ops ov9640_core_ops = {
 };
 
 static struct v4l2_subdev_video_ops ov9640_video_ops = {
-	.s_stream		= ov9640_s_stream,
-	.s_fmt			= ov9640_s_fmt,
-	.try_fmt		= ov9640_try_fmt,
-	.cropcap		= ov9640_cropcap,
-	.g_crop			= ov9640_g_crop,
+	.s_stream	= ov9640_s_stream,
+	.s_mbus_fmt	= ov9640_s_fmt,
+	.try_mbus_fmt	= ov9640_try_fmt,
+	.enum_mbus_fmt	= ov9640_enum_fmt,
+	.cropcap	= ov9640_cropcap,
+	.g_crop		= ov9640_g_crop,
 
 };
 
diff --git a/drivers/media/video/pxa_camera.c b/drivers/media/video/pxa_camera.c
index f063f59..c54ef98 100644
--- a/drivers/media/video/pxa_camera.c
+++ b/drivers/media/video/pxa_camera.c
@@ -32,6 +32,7 @@
 #include <media/v4l2-dev.h>
 #include <media/videobuf-dma-sg.h>
 #include <media/soc_camera.h>
+#include <media/soc_mediabus.h>
 
 #include <linux/videodev2.h>
 
@@ -183,16 +184,12 @@ struct pxa_cam_dma {
 /* buffer for one video frame */
 struct pxa_buffer {
 	/* common v4l buffer stuff -- must be first */
-	struct videobuf_buffer vb;
-
-	const struct soc_camera_data_format        *fmt;
-
+	struct videobuf_buffer		vb;
+	enum v4l2_mbus_pixelcode	code;
 	/* our descriptor lists for Y, U and V channels */
-	struct pxa_cam_dma dmas[3];
-
-	int			inwork;
-
-	enum pxa_camera_active_dma active_dma;
+	struct pxa_cam_dma		dmas[3];
+	int				inwork;
+	enum pxa_camera_active_dma	active_dma;
 };
 
 struct pxa_camera_dev {
@@ -243,11 +240,15 @@ static int pxa_videobuf_setup(struct videobuf_queue *vq, unsigned int *count,
 			      unsigned int *size)
 {
 	struct soc_camera_device *icd = vq->priv_data;
+	int bytes_per_line = soc_mbus_bytes_per_line(icd->user_width,
+						icd->current_fmt->host_fmt);
+
+	if (bytes_per_line < 0)
+		return bytes_per_line;
 
 	dev_dbg(icd->dev.parent, "count=%d, size=%d\n", *count, *size);
 
-	*size = roundup(icd->user_width * icd->user_height *
-			((icd->current_fmt->depth + 7) >> 3), 8);
+	*size = bytes_per_line * icd->user_height;
 
 	if (0 == *count)
 		*count = 32;
@@ -433,6 +434,11 @@ static int pxa_videobuf_prepare(struct videobuf_queue *vq,
 	struct pxa_buffer *buf = container_of(vb, struct pxa_buffer, vb);
 	int ret;
 	int size_y, size_u = 0, size_v = 0;
+	int bytes_per_line = soc_mbus_bytes_per_line(icd->user_width,
+						icd->current_fmt->host_fmt);
+
+	if (bytes_per_line < 0)
+		return bytes_per_line;
 
 	dev_dbg(dev, "%s (vb=0x%p) 0x%08lx %d\n", __func__,
 		vb, vb->baddr, vb->bsize);
@@ -456,18 +462,18 @@ static int pxa_videobuf_prepare(struct videobuf_queue *vq,
 	 */
 	buf->inwork = 1;
 
-	if (buf->fmt	!= icd->current_fmt ||
+	if (buf->code	!= icd->current_fmt->code ||
 	    vb->width	!= icd->user_width ||
 	    vb->height	!= icd->user_height ||
 	    vb->field	!= field) {
-		buf->fmt	= icd->current_fmt;
+		buf->code	= icd->current_fmt->code;
 		vb->width	= icd->user_width;
 		vb->height	= icd->user_height;
 		vb->field	= field;
 		vb->state	= VIDEOBUF_NEEDS_INIT;
 	}
 
-	vb->size = vb->width * vb->height * ((buf->fmt->depth + 7) >> 3);
+	vb->size = bytes_per_line * vb->height;
 	if (0 != vb->baddr && vb->bsize < vb->size) {
 		ret = -EINVAL;
 		goto out;
@@ -1157,9 +1163,15 @@ static int pxa_camera_set_bus_param(struct soc_camera_device *icd, __u32 pixfmt)
 	struct soc_camera_host *ici = to_soc_camera_host(icd->dev.parent);
 	struct pxa_camera_dev *pcdev = ici->priv;
 	unsigned long bus_flags, camera_flags, common_flags;
-	int ret = test_platform_param(pcdev, icd->buswidth, &bus_flags);
+	const struct soc_mbus_pixelfmt *fmt;
+	int ret;
 	struct pxa_cam *cam = icd->host_priv;
 
+	fmt = soc_mbus_get_fmtdesc(icd->current_fmt->code);
+	if (!fmt)
+		return -EINVAL;
+
+	ret = test_platform_param(pcdev, fmt->bits_per_sample, &bus_flags);
 	if (ret < 0)
 		return ret;
 
@@ -1223,59 +1235,49 @@ static int pxa_camera_try_bus_param(struct soc_camera_device *icd,
 	return soc_camera_bus_param_compatible(camera_flags, bus_flags) ? 0 : -EINVAL;
 }
 
-static const struct soc_camera_data_format pxa_camera_formats[] = {
+static const struct soc_mbus_pixelfmt pxa_camera_formats[] = {
 	{
-		.name		= "Planar YUV422 16 bit",
-		.depth		= 16,
-		.fourcc		= V4L2_PIX_FMT_YUV422P,
-		.colorspace	= V4L2_COLORSPACE_JPEG,
+		.fourcc			= V4L2_PIX_FMT_YUV422P,
+		.name			= "Planar YUV422 16 bit",
+		.bits_per_sample	= 8,
+		.packing		= SOC_MBUS_PACKING_2X8_PADHI,
+		.order			= SOC_MBUS_ORDER_LE,
 	},
 };
 
-static bool buswidth_supported(struct soc_camera_device *icd, int depth)
+/* This will be corrected as we get more formats */
+static bool pxa_camera_packing_supported(const struct soc_mbus_pixelfmt *fmt)
 {
-	struct soc_camera_host *ici = to_soc_camera_host(icd->dev.parent);
-	struct pxa_camera_dev *pcdev = ici->priv;
-
-	switch (depth) {
-	case 8:
-		return !!(pcdev->platform_flags & PXA_CAMERA_DATAWIDTH_8);
-	case 9:
-		return !!(pcdev->platform_flags & PXA_CAMERA_DATAWIDTH_9);
-	case 10:
-		return !!(pcdev->platform_flags & PXA_CAMERA_DATAWIDTH_10);
-	}
-	return false;
-}
-
-static int required_buswidth(const struct soc_camera_data_format *fmt)
-{
-	switch (fmt->fourcc) {
-	case V4L2_PIX_FMT_UYVY:
-	case V4L2_PIX_FMT_VYUY:
-	case V4L2_PIX_FMT_YUYV:
-	case V4L2_PIX_FMT_YVYU:
-	case V4L2_PIX_FMT_RGB565:
-	case V4L2_PIX_FMT_RGB555:
-		return 8;
-	default:
-		return fmt->depth;
-	}
+	return	fmt->packing == SOC_MBUS_PACKING_NONE ||
+		(fmt->bits_per_sample == 8 &&
+		 fmt->packing == SOC_MBUS_PACKING_2X8_PADHI) ||
+		(fmt->bits_per_sample > 8 &&
+		 fmt->packing == SOC_MBUS_PACKING_EXTEND16);
 }
 
 static int pxa_camera_get_formats(struct soc_camera_device *icd, int idx,
 				  struct soc_camera_format_xlate *xlate)
 {
+	struct v4l2_subdev *sd = soc_camera_to_subdev(icd);
 	struct device *dev = icd->dev.parent;
-	int formats = 0, buswidth, ret;
+	int formats = 0, ret;
 	struct pxa_cam *cam;
+	enum v4l2_mbus_pixelcode code;
+	const struct soc_mbus_pixelfmt *fmt;
 
-	buswidth = required_buswidth(icd->formats + idx);
+	ret = v4l2_subdev_call(sd, video, enum_mbus_fmt, idx, &code);
+	if (ret < 0)
+		/* No more formats */
+		return 0;
 
-	if (!buswidth_supported(icd, buswidth))
+	fmt = soc_mbus_get_fmtdesc(code);
+	if (!fmt) {
+		dev_err(dev, "Invalid format code #%d: %d\n", idx, code);
 		return 0;
+	}
 
-	ret = pxa_camera_try_bus_param(icd, buswidth);
+	/* This also checks support for the requested bits-per-sample */
+	ret = pxa_camera_try_bus_param(icd, fmt->bits_per_sample);
 	if (ret < 0)
 		return 0;
 
@@ -1289,45 +1291,40 @@ static int pxa_camera_get_formats(struct soc_camera_device *icd, int idx,
 		cam = icd->host_priv;
 	}
 
-	switch (icd->formats[idx].fourcc) {
-	case V4L2_PIX_FMT_UYVY:
+	switch (code) {
+	case V4L2_MBUS_FMT_UYVY:
 		formats++;
 		if (xlate) {
-			xlate->host_fmt = &pxa_camera_formats[0];
-			xlate->cam_fmt = icd->formats + idx;
-			xlate->buswidth = buswidth;
+			xlate->host_fmt	= &pxa_camera_formats[0];
+			xlate->code	= code;
 			xlate++;
-			dev_dbg(dev, "Providing format %s using %s\n",
-				pxa_camera_formats[0].name,
-				icd->formats[idx].name);
+			dev_dbg(dev, "Providing format %s using code %d\n",
+				pxa_camera_formats[0].name, code);
 		}
-	case V4L2_PIX_FMT_VYUY:
-	case V4L2_PIX_FMT_YUYV:
-	case V4L2_PIX_FMT_YVYU:
-	case V4L2_PIX_FMT_RGB565:
-	case V4L2_PIX_FMT_RGB555:
-		formats++;
-		if (xlate) {
-			xlate->host_fmt = icd->formats + idx;
-			xlate->cam_fmt = icd->formats + idx;
-			xlate->buswidth = buswidth;
-			xlate++;
+	case V4L2_MBUS_FMT_VYUY:
+	case V4L2_MBUS_FMT_YUYV:
+	case V4L2_MBUS_FMT_YVYU:
+	case V4L2_MBUS_FMT_RGB565:
+	case V4L2_MBUS_FMT_RGB555:
+		if (xlate)
 			dev_dbg(dev, "Providing format %s packed\n",
-				icd->formats[idx].name);
-		}
+				fmt->name);
 		break;
 	default:
-		/* Generic pass-through */
-		formats++;
-		if (xlate) {
-			xlate->host_fmt = icd->formats + idx;
-			xlate->cam_fmt = icd->formats + idx;
-			xlate->buswidth = icd->formats[idx].depth;
-			xlate++;
+		if (!pxa_camera_packing_supported(fmt))
+			return 0;
+		if (xlate)
 			dev_dbg(dev,
 				"Providing format %s in pass-through mode\n",
-				icd->formats[idx].name);
-		}
+				fmt->name);
+	}
+
+	/* Generic pass-through */
+	formats++;
+	if (xlate) {
+		xlate->host_fmt	= fmt;
+		xlate->code	= code;
+		xlate++;
 	}
 
 	return formats;
@@ -1339,11 +1336,11 @@ static void pxa_camera_put_formats(struct soc_camera_device *icd)
 	icd->host_priv = NULL;
 }
 
-static int pxa_camera_check_frame(struct v4l2_pix_format *pix)
+static int pxa_camera_check_frame(u32 width, u32 height)
 {
 	/* limit to pxa hardware capabilities */
-	return pix->height < 32 || pix->height > 2048 || pix->width < 48 ||
-		pix->width > 2048 || (pix->width & 0x01);
+	return height < 32 || height > 2048 || width < 48 || width > 2048 ||
+		(width & 0x01);
 }
 
 static int pxa_camera_set_crop(struct soc_camera_device *icd,
@@ -1358,9 +1355,9 @@ static int pxa_camera_set_crop(struct soc_camera_device *icd,
 		.master_clock = pcdev->mclk,
 		.pixel_clock_max = pcdev->ciclk / 4,
 	};
-	struct v4l2_format f;
-	struct v4l2_pix_format *pix = &f.fmt.pix, pix_tmp;
+	struct v4l2_mbus_framefmt mf;
 	struct pxa_cam *cam = icd->host_priv;
+	u32 fourcc = icd->current_fmt->host_fmt->fourcc;
 	int ret;
 
 	/* If PCLK is used to latch data from the sensor, check sense */
@@ -1377,27 +1374,23 @@ static int pxa_camera_set_crop(struct soc_camera_device *icd,
 		return ret;
 	}
 
-	f.type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
-
-	ret = v4l2_subdev_call(sd, video, g_fmt, &f);
+	ret = v4l2_subdev_call(sd, video, g_mbus_fmt, &mf);
 	if (ret < 0)
 		return ret;
 
-	pix_tmp = *pix;
-	if (pxa_camera_check_frame(pix)) {
+	if (pxa_camera_check_frame(mf.width, mf.height)) {
 		/*
 		 * Camera cropping produced a frame beyond our capabilities.
 		 * FIXME: just extract a subframe, that we can process.
 		 */
-		v4l_bound_align_image(&pix->width, 48, 2048, 1,
-			&pix->height, 32, 2048, 0,
-			icd->current_fmt->fourcc == V4L2_PIX_FMT_YUV422P ?
-				4 : 0);
-		ret = v4l2_subdev_call(sd, video, s_fmt, &f);
+		v4l_bound_align_image(&mf.width, 48, 2048, 1,
+			&mf.height, 32, 2048, 0,
+			fourcc == V4L2_PIX_FMT_YUV422P ? 4 : 0);
+		ret = v4l2_subdev_call(sd, video, s_mbus_fmt, &mf);
 		if (ret < 0)
 			return ret;
 
-		if (pxa_camera_check_frame(pix)) {
+		if (pxa_camera_check_frame(mf.width, mf.height)) {
 			dev_warn(icd->dev.parent,
 				 "Inconsistent state. Use S_FMT to repair\n");
 			return -EINVAL;
@@ -1414,10 +1407,10 @@ static int pxa_camera_set_crop(struct soc_camera_device *icd,
 		recalculate_fifo_timeout(pcdev, sense.pixel_clock);
 	}
 
-	icd->user_width = pix->width;
-	icd->user_height = pix->height;
+	icd->user_width		= mf.width;
+	icd->user_height	= mf.height;
 
-	pxa_camera_setup_cicr(icd, cam->flags, icd->current_fmt->fourcc);
+	pxa_camera_setup_cicr(icd, cam->flags, fourcc);
 
 	return ret;
 }
@@ -1429,14 +1422,13 @@ static int pxa_camera_set_fmt(struct soc_camera_device *icd,
 	struct pxa_camera_dev *pcdev = ici->priv;
 	struct device *dev = icd->dev.parent;
 	struct v4l2_subdev *sd = soc_camera_to_subdev(icd);
-	const struct soc_camera_data_format *cam_fmt = NULL;
 	const struct soc_camera_format_xlate *xlate = NULL;
 	struct soc_camera_sense sense = {
 		.master_clock = pcdev->mclk,
 		.pixel_clock_max = pcdev->ciclk / 4,
 	};
 	struct v4l2_pix_format *pix = &f->fmt.pix;
-	struct v4l2_format cam_f = *f;
+	struct v4l2_mbus_framefmt mf;
 	int ret;
 
 	xlate = soc_camera_xlate_by_fourcc(icd, pix->pixelformat);
@@ -1445,26 +1437,31 @@ static int pxa_camera_set_fmt(struct soc_camera_device *icd,
 		return -EINVAL;
 	}
 
-	cam_fmt = xlate->cam_fmt;
-
 	/* If PCLK is used to latch data from the sensor, check sense */
 	if (pcdev->platform_flags & PXA_CAMERA_PCLK_EN)
+		/* The caller holds a mutex. */
 		icd->sense = &sense;
 
-	cam_f.fmt.pix.pixelformat = cam_fmt->fourcc;
-	ret = v4l2_subdev_call(sd, video, s_fmt, &cam_f);
-	cam_f.fmt.pix.pixelformat = pix->pixelformat;
-	*pix = cam_f.fmt.pix;
+	mf.width	= pix->width;
+	mf.height	= pix->height;
+	mf.field	= pix->field;
+	mf.colorspace	= pix->colorspace;
+	mf.code		= xlate->code;
+
+	ret = v4l2_subdev_call(sd, video, s_mbus_fmt, &mf);
+
+	if (mf.code != xlate->code)
+		return -EINVAL;
 
 	icd->sense = NULL;
 
 	if (ret < 0) {
 		dev_warn(dev, "Failed to configure for format %x\n",
 			 pix->pixelformat);
-	} else if (pxa_camera_check_frame(pix)) {
+	} else if (pxa_camera_check_frame(mf.width, mf.height)) {
 		dev_warn(dev,
 			 "Camera driver produced an unsupported frame %dx%d\n",
-			 pix->width, pix->height);
+			 mf.width, mf.height);
 		ret = -EINVAL;
 	} else if (sense.flags & SOCAM_SENSE_PCLK_CHANGED) {
 		if (sense.pixel_clock > sense.pixel_clock_max) {
@@ -1476,10 +1473,14 @@ static int pxa_camera_set_fmt(struct soc_camera_device *icd,
 		recalculate_fifo_timeout(pcdev, sense.pixel_clock);
 	}
 
-	if (!ret) {
-		icd->buswidth = xlate->buswidth;
-		icd->current_fmt = xlate->host_fmt;
-	}
+	if (ret < 0)
+		return ret;
+
+	pix->width		= mf.width;
+	pix->height		= mf.height;
+	pix->field		= mf.field;
+	pix->colorspace		= mf.colorspace;
+	icd->current_fmt	= xlate;
 
 	return ret;
 }
@@ -1487,17 +1488,16 @@ static int pxa_camera_set_fmt(struct soc_camera_device *icd,
 static int pxa_camera_try_fmt(struct soc_camera_device *icd,
 			      struct v4l2_format *f)
 {
-	struct soc_camera_host *ici = to_soc_camera_host(icd->dev.parent);
 	struct v4l2_subdev *sd = soc_camera_to_subdev(icd);
 	const struct soc_camera_format_xlate *xlate;
 	struct v4l2_pix_format *pix = &f->fmt.pix;
+	struct v4l2_mbus_framefmt mf;
 	__u32 pixfmt = pix->pixelformat;
-	enum v4l2_field field;
 	int ret;
 
 	xlate = soc_camera_xlate_by_fourcc(icd, pixfmt);
 	if (!xlate) {
-		dev_warn(ici->v4l2_dev.dev, "Format %x not found\n", pixfmt);
+		dev_warn(icd->dev.parent, "Format %x not found\n", pixfmt);
 		return -EINVAL;
 	}
 
@@ -1511,22 +1511,36 @@ static int pxa_camera_try_fmt(struct soc_camera_device *icd,
 			      &pix->height, 32, 2048, 0,
 			      pixfmt == V4L2_PIX_FMT_YUV422P ? 4 : 0);
 
-	pix->bytesperline = pix->width *
-		DIV_ROUND_UP(xlate->host_fmt->depth, 8);
+	pix->bytesperline = soc_mbus_bytes_per_line(pix->width,
+						    xlate->host_fmt);
+	if (pix->bytesperline < 0)
+		return pix->bytesperline;
 	pix->sizeimage = pix->height * pix->bytesperline;
 
-	/* camera has to see its format, but the user the original one */
-	pix->pixelformat = xlate->cam_fmt->fourcc;
 	/* limit to sensor capabilities */
-	ret = v4l2_subdev_call(sd, video, try_fmt, f);
-	pix->pixelformat = pixfmt;
+	mf.width	= pix->width;
+	mf.height	= pix->height;
+	mf.field	= pix->field;
+	mf.colorspace	= pix->colorspace;
+	mf.code		= xlate->code;
 
-	field = pix->field;
+	ret = v4l2_subdev_call(sd, video, try_mbus_fmt, &mf);
+	if (ret < 0)
+		return ret;
 
-	if (field == V4L2_FIELD_ANY) {
-		pix->field = V4L2_FIELD_NONE;
-	} else if (field != V4L2_FIELD_NONE) {
-		dev_err(icd->dev.parent, "Field type %d unsupported.\n", field);
+	pix->width	= mf.width;
+	pix->height	= mf.height;
+	pix->colorspace	= mf.colorspace;
+
+	switch (mf.field) {
+	case V4L2_FIELD_ANY:
+	case V4L2_FIELD_NONE:
+		pix->field	= V4L2_FIELD_NONE;
+		break;
+	default:
+		/* TODO: support interlaced at least in pass-through mode */
+		dev_err(icd->dev.parent, "Field type %d unsupported.\n",
+			mf.field);
 		return -EINVAL;
 	}
 
diff --git a/drivers/media/video/rj54n1cb0c.c b/drivers/media/video/rj54n1cb0c.c
index 373f2a3..2b6827a 100644
--- a/drivers/media/video/rj54n1cb0c.c
+++ b/drivers/media/video/rj54n1cb0c.c
@@ -16,6 +16,7 @@
 #include <media/v4l2-subdev.h>
 #include <media/v4l2-chip-ident.h>
 #include <media/soc_camera.h>
+#include <media/soc_mediabus.h>
 
 #define RJ54N1_DEV_CODE			0x0400
 #define RJ54N1_DEV_CODE2		0x0401
@@ -85,18 +86,16 @@
 
 /* I2C addresses: 0x50, 0x51, 0x60, 0x61 */
 
-static const struct soc_camera_data_format rj54n1_colour_formats[] = {
-	{
-		.name		= "YUYV",
-		.depth		= 16,
-		.fourcc		= V4L2_PIX_FMT_YUYV,
-		.colorspace	= V4L2_COLORSPACE_JPEG,
-	}, {
-		.name		= "RGB565",
-		.depth		= 16,
-		.fourcc		= V4L2_PIX_FMT_RGB565,
-		.colorspace	= V4L2_COLORSPACE_SRGB,
-	}
+static const struct soc_mbus_datafmt rj54n1_colour_fmts[] = {
+	{V4L2_MBUS_FMT_YUYV, V4L2_COLORSPACE_JPEG},
+	{V4L2_MBUS_FMT_YVYU, V4L2_COLORSPACE_JPEG},
+	{V4L2_MBUS_FMT_RGB565, V4L2_COLORSPACE_SRGB},
+	{V4L2_MBUS_FMT_RGB565X, V4L2_COLORSPACE_SRGB},
+	{V4L2_MBUS_FMT_SBGGR10_2X8_PADHI_LE, V4L2_COLORSPACE_SRGB},
+	{V4L2_MBUS_FMT_SBGGR10_2X8_PADLO_LE, V4L2_COLORSPACE_SRGB},
+	{V4L2_MBUS_FMT_SBGGR10_2X8_PADHI_BE, V4L2_COLORSPACE_SRGB},
+	{V4L2_MBUS_FMT_SBGGR10_2X8_PADLO_BE, V4L2_COLORSPACE_SRGB},
+	{V4L2_MBUS_FMT_SBGGR10, V4L2_COLORSPACE_SRGB},
 };
 
 struct rj54n1_clock_div {
@@ -109,12 +108,12 @@ struct rj54n1_clock_div {
 
 struct rj54n1 {
 	struct v4l2_subdev subdev;
+	const struct soc_mbus_datafmt *fmt;
 	struct v4l2_rect rect;	/* Sensor window */
 	unsigned short width;	/* Output window */
 	unsigned short height;
 	unsigned short resize;	/* Sensor * 1024 / resize = Output */
 	struct rj54n1_clock_div clk_div;
-	u32 fourcc;
 	unsigned short scale;
 	u8 bank;
 };
@@ -440,6 +439,16 @@ static int reg_write_multiple(struct i2c_client *client,
 	return 0;
 }
 
+static int rj54n1_enum_fmt(struct v4l2_subdev *sd, int index,
+			   enum v4l2_mbus_pixelcode *code)
+{
+	if ((unsigned int)index >= ARRAY_SIZE(rj54n1_colour_fmts))
+		return -EINVAL;
+
+	*code = rj54n1_colour_fmts[index].code;
+	return 0;
+}
+
 static int rj54n1_s_stream(struct v4l2_subdev *sd, int enable)
 {
 	/* TODO: start / stop streaming */
@@ -527,16 +536,17 @@ static int rj54n1_cropcap(struct v4l2_subdev *sd, struct v4l2_cropcap *a)
 	return 0;
 }
 
-static int rj54n1_g_fmt(struct v4l2_subdev *sd, struct v4l2_format *f)
+static int rj54n1_g_fmt(struct v4l2_subdev *sd,
+			struct v4l2_mbus_framefmt *mf)
 {
 	struct i2c_client *client = sd->priv;
 	struct rj54n1 *rj54n1 = to_rj54n1(client);
-	struct v4l2_pix_format *pix = &f->fmt.pix;
 
-	pix->pixelformat	= rj54n1->fourcc;
-	pix->field		= V4L2_FIELD_NONE;
-	pix->width		= rj54n1->width;
-	pix->height		= rj54n1->height;
+	mf->code	= rj54n1->fmt->code;
+	mf->colorspace	= rj54n1->fmt->colorspace;
+	mf->field	= V4L2_FIELD_NONE;
+	mf->width	= rj54n1->width;
+	mf->height	= rj54n1->height;
 
 	return 0;
 }
@@ -787,26 +797,44 @@ static int rj54n1_reg_init(struct i2c_client *client)
 }
 
 /* FIXME: streaming output only up to 800x600 is functional */
-static int rj54n1_try_fmt(struct v4l2_subdev *sd, struct v4l2_format *f)
+static int rj54n1_try_fmt(struct v4l2_subdev *sd,
+			  struct v4l2_mbus_framefmt *mf)
 {
-	struct v4l2_pix_format *pix = &f->fmt.pix;
+	struct i2c_client *client = sd->priv;
+	struct rj54n1 *rj54n1 = to_rj54n1(client);
+	const struct soc_mbus_datafmt *fmt;
+	int align = mf->code == V4L2_MBUS_FMT_SBGGR10 ||
+		mf->code == V4L2_MBUS_FMT_SBGGR10_2X8_PADHI_BE ||
+		mf->code == V4L2_MBUS_FMT_SBGGR10_2X8_PADLO_BE ||
+		mf->code == V4L2_MBUS_FMT_SBGGR10_2X8_PADHI_LE ||
+		mf->code == V4L2_MBUS_FMT_SBGGR10_2X8_PADLO_LE;
+
+	dev_dbg(&client->dev, "%s: code = %d, width = %u, height = %u\n",
+		__func__, mf->code, mf->width, mf->height);
+
+	fmt = soc_mbus_find_datafmt(mf->code, rj54n1_colour_fmts,
+				    ARRAY_SIZE(rj54n1_colour_fmts));
+	if (!fmt) {
+		fmt = rj54n1->fmt;
+		mf->code = fmt->code;
+	}
 
-	pix->field = V4L2_FIELD_NONE;
+	mf->field	= V4L2_FIELD_NONE;
+	mf->colorspace	= fmt->colorspace;
 
-	if (pix->width > 800)
-		pix->width = 800;
-	if (pix->height > 600)
-		pix->height = 600;
+	v4l_bound_align_image(&mf->width, 112, RJ54N1_MAX_WIDTH, align,
+			      &mf->height, 84, RJ54N1_MAX_HEIGHT, align, 0);
 
 	return 0;
 }
 
-static int rj54n1_s_fmt(struct v4l2_subdev *sd, struct v4l2_format *f)
+static int rj54n1_s_fmt(struct v4l2_subdev *sd,
+			struct v4l2_mbus_framefmt *mf)
 {
 	struct i2c_client *client = sd->priv;
 	struct rj54n1 *rj54n1 = to_rj54n1(client);
-	struct v4l2_pix_format *pix = &f->fmt.pix;
-	unsigned int output_w, output_h,
+	const struct soc_mbus_datafmt *fmt;
+	unsigned int output_w, output_h, max_w, max_h,
 		input_w = rj54n1->rect.width, input_h = rj54n1->rect.height;
 	int ret;
 
@@ -814,7 +842,7 @@ static int rj54n1_s_fmt(struct v4l2_subdev *sd, struct v4l2_format *f)
 	 * The host driver can call us without .try_fmt(), so, we have to take
 	 * care ourseleves
 	 */
-	ret = rj54n1_try_fmt(sd, f);
+	ret = rj54n1_try_fmt(sd, mf);
 
 	/*
 	 * Verify if the sensor has just been powered on. TODO: replace this
@@ -832,49 +860,101 @@ static int rj54n1_s_fmt(struct v4l2_subdev *sd, struct v4l2_format *f)
 	}
 
 	/* RA_SEL_UL is only relevant for raw modes, ignored otherwise. */
-	switch (pix->pixelformat) {
-	case V4L2_PIX_FMT_YUYV:
+	switch (mf->code) {
+	case V4L2_MBUS_FMT_YUYV:
 		ret = reg_write(client, RJ54N1_OUT_SEL, 0);
 		if (!ret)
 			ret = reg_set(client, RJ54N1_BYTE_SWAP, 8, 8);
 		break;
-	case V4L2_PIX_FMT_RGB565:
+	case V4L2_MBUS_FMT_YVYU:
+		ret = reg_write(client, RJ54N1_OUT_SEL, 0);
+		if (!ret)
+			ret = reg_set(client, RJ54N1_BYTE_SWAP, 0, 8);
+		break;
+	case V4L2_MBUS_FMT_RGB565:
 		ret = reg_write(client, RJ54N1_OUT_SEL, 0x11);
 		if (!ret)
 			ret = reg_set(client, RJ54N1_BYTE_SWAP, 8, 8);
 		break;
+	case V4L2_MBUS_FMT_RGB565X:
+		ret = reg_write(client, RJ54N1_OUT_SEL, 0x11);
+		if (!ret)
+			ret = reg_set(client, RJ54N1_BYTE_SWAP, 0, 8);
+		break;
+	case V4L2_MBUS_FMT_SBGGR10_2X8_PADLO_LE:
+		ret = reg_write(client, RJ54N1_OUT_SEL, 4);
+		if (!ret)
+			ret = reg_set(client, RJ54N1_BYTE_SWAP, 8, 8);
+		if (!ret)
+			ret = reg_write(client, RJ54N1_RA_SEL_UL, 0);
+		break;
+	case V4L2_MBUS_FMT_SBGGR10_2X8_PADHI_LE:
+		ret = reg_write(client, RJ54N1_OUT_SEL, 4);
+		if (!ret)
+			ret = reg_set(client, RJ54N1_BYTE_SWAP, 8, 8);
+		if (!ret)
+			ret = reg_write(client, RJ54N1_RA_SEL_UL, 8);
+		break;
+	case V4L2_MBUS_FMT_SBGGR10_2X8_PADLO_BE:
+		ret = reg_write(client, RJ54N1_OUT_SEL, 4);
+		if (!ret)
+			ret = reg_set(client, RJ54N1_BYTE_SWAP, 0, 8);
+		if (!ret)
+			ret = reg_write(client, RJ54N1_RA_SEL_UL, 0);
+		break;
+	case V4L2_MBUS_FMT_SBGGR10_2X8_PADHI_BE:
+		ret = reg_write(client, RJ54N1_OUT_SEL, 4);
+		if (!ret)
+			ret = reg_set(client, RJ54N1_BYTE_SWAP, 0, 8);
+		if (!ret)
+			ret = reg_write(client, RJ54N1_RA_SEL_UL, 8);
+		break;
+	case V4L2_MBUS_FMT_SBGGR10:
+		ret = reg_write(client, RJ54N1_OUT_SEL, 5);
+		break;
 	default:
 		ret = -EINVAL;
 	}
 
+	/* Special case: a raw mode with 10 bits of data per clock tick */
+	if (!ret)
+		ret = reg_set(client, RJ54N1_OCLK_SEL_EN,
+			      (mf->code == V4L2_MBUS_FMT_SBGGR10) << 1, 2);
+
 	if (ret < 0)
 		return ret;
 
-	/* Supported scales 1:1 - 1:16 */
-	if (pix->width < input_w / 16)
-		pix->width = input_w / 16;
-	if (pix->height < input_h / 16)
-		pix->height = input_h / 16;
+	/* Supported scales 1:1 >= scale > 1:16 */
+	max_w = mf->width * (16 * 1024 - 1) / 1024;
+	if (input_w > max_w)
+		input_w = max_w;
+	max_h = mf->height * (16 * 1024 - 1) / 1024;
+	if (input_h > max_h)
+		input_h = max_h;
 
-	output_w = pix->width;
-	output_h = pix->height;
+	output_w = mf->width;
+	output_h = mf->height;
 
 	ret = rj54n1_sensor_scale(sd, &input_w, &input_h, &output_w, &output_h);
 	if (ret < 0)
 		return ret;
 
-	rj54n1->fourcc		= pix->pixelformat;
+	fmt = soc_mbus_find_datafmt(mf->code, rj54n1_colour_fmts,
+				    ARRAY_SIZE(rj54n1_colour_fmts));
+
+	rj54n1->fmt		= fmt;
 	rj54n1->resize		= ret;
 	rj54n1->rect.width	= input_w;
 	rj54n1->rect.height	= input_h;
 	rj54n1->width		= output_w;
 	rj54n1->height		= output_h;
 
-	pix->width		= output_w;
-	pix->height		= output_h;
-	pix->field		= V4L2_FIELD_NONE;
+	mf->width		= output_w;
+	mf->height		= output_h;
+	mf->field		= V4L2_FIELD_NONE;
+	mf->colorspace		= fmt->colorspace;
 
-	return ret;
+	return 0;
 }
 
 static int rj54n1_g_chip_ident(struct v4l2_subdev *sd,
@@ -1054,9 +1134,10 @@ static struct v4l2_subdev_core_ops rj54n1_subdev_core_ops = {
 
 static struct v4l2_subdev_video_ops rj54n1_subdev_video_ops = {
 	.s_stream	= rj54n1_s_stream,
-	.s_fmt		= rj54n1_s_fmt,
-	.g_fmt		= rj54n1_g_fmt,
-	.try_fmt	= rj54n1_try_fmt,
+	.s_mbus_fmt	= rj54n1_s_fmt,
+	.g_mbus_fmt	= rj54n1_g_fmt,
+	.try_mbus_fmt	= rj54n1_try_fmt,
+	.enum_mbus_fmt	= rj54n1_enum_fmt,
 	.g_crop		= rj54n1_g_crop,
 	.cropcap	= rj54n1_cropcap,
 };
@@ -1153,7 +1234,7 @@ static int rj54n1_probe(struct i2c_client *client,
 	rj54n1->rect.height	= RJ54N1_MAX_HEIGHT;
 	rj54n1->width		= RJ54N1_MAX_WIDTH;
 	rj54n1->height		= RJ54N1_MAX_HEIGHT;
-	rj54n1->fourcc		= V4L2_PIX_FMT_YUYV;
+	rj54n1->fmt		= &rj54n1_colour_fmts[0];
 	rj54n1->resize		= 1024;
 
 	ret = rj54n1_video_probe(icd, client);
@@ -1164,9 +1245,6 @@ static int rj54n1_probe(struct i2c_client *client,
 		return ret;
 	}
 
-	icd->formats		= rj54n1_colour_formats;
-	icd->num_formats	= ARRAY_SIZE(rj54n1_colour_formats);
-
 	return ret;
 }
 
diff --git a/drivers/media/video/sh_mobile_ceu_camera.c b/drivers/media/video/sh_mobile_ceu_camera.c
index e362c40..c67bab7 100644
--- a/drivers/media/video/sh_mobile_ceu_camera.c
+++ b/drivers/media/video/sh_mobile_ceu_camera.c
@@ -38,6 +38,8 @@
 #include <media/soc_camera.h>
 #include <media/sh_mobile_ceu.h>
 #include <media/videobuf-dma-contig.h>
+#include <media/v4l2-mediabus.h>
+#include <media/soc_mediabus.h>
 
 /* register offsets for sh7722 / sh7723 */
 
@@ -85,7 +87,7 @@
 /* per video frame buffer */
 struct sh_mobile_ceu_buffer {
 	struct videobuf_buffer vb; /* v4l buffer must be first */
-	const struct soc_camera_data_format *fmt;
+	enum v4l2_mbus_pixelcode code;
 };
 
 struct sh_mobile_ceu_dev {
@@ -114,8 +116,8 @@ struct sh_mobile_ceu_cam {
 	struct v4l2_rect ceu_rect;
 	unsigned int cam_width;
 	unsigned int cam_height;
-	const struct soc_camera_data_format *extra_fmt;
-	const struct soc_camera_data_format *camera_fmt;
+	const struct soc_mbus_pixelfmt *extra_fmt;
+	enum v4l2_mbus_pixelcode code;
 };
 
 static unsigned long make_bus_param(struct sh_mobile_ceu_dev *pcdev)
@@ -196,10 +198,13 @@ static int sh_mobile_ceu_videobuf_setup(struct videobuf_queue *vq,
 	struct soc_camera_device *icd = vq->priv_data;
 	struct soc_camera_host *ici = to_soc_camera_host(icd->dev.parent);
 	struct sh_mobile_ceu_dev *pcdev = ici->priv;
-	int bytes_per_pixel = (icd->current_fmt->depth + 7) >> 3;
+	int bytes_per_line = soc_mbus_bytes_per_line(icd->user_width,
+						icd->current_fmt->host_fmt);
 
-	*size = PAGE_ALIGN(icd->user_width * icd->user_height *
-			   bytes_per_pixel);
+	if (bytes_per_line < 0)
+		return bytes_per_line;
+
+	*size = PAGE_ALIGN(bytes_per_line * icd->user_height);
 
 	if (0 == *count)
 		*count = 2;
@@ -283,7 +288,7 @@ static int sh_mobile_ceu_capture(struct sh_mobile_ceu_dev *pcdev)
 		ceu_write(pcdev, CDBYR, phys_addr_bottom);
 	}
 
-	switch (icd->current_fmt->fourcc) {
+	switch (icd->current_fmt->host_fmt->fourcc) {
 	case V4L2_PIX_FMT_NV12:
 	case V4L2_PIX_FMT_NV21:
 	case V4L2_PIX_FMT_NV16:
@@ -310,8 +315,13 @@ static int sh_mobile_ceu_videobuf_prepare(struct videobuf_queue *vq,
 {
 	struct soc_camera_device *icd = vq->priv_data;
 	struct sh_mobile_ceu_buffer *buf;
+	int bytes_per_line = soc_mbus_bytes_per_line(icd->user_width,
+						icd->current_fmt->host_fmt);
 	int ret;
 
+	if (bytes_per_line < 0)
+		return bytes_per_line;
+
 	buf = container_of(vb, struct sh_mobile_ceu_buffer, vb);
 
 	dev_dbg(icd->dev.parent, "%s (vb=0x%p) 0x%08lx %zd\n", __func__,
@@ -330,18 +340,18 @@ static int sh_mobile_ceu_videobuf_prepare(struct videobuf_queue *vq,
 
 	BUG_ON(NULL == icd->current_fmt);
 
-	if (buf->fmt	!= icd->current_fmt ||
+	if (buf->code	!= icd->current_fmt->code ||
 	    vb->width	!= icd->user_width ||
 	    vb->height	!= icd->user_height ||
 	    vb->field	!= field) {
-		buf->fmt	= icd->current_fmt;
+		buf->code	= icd->current_fmt->code;
 		vb->width	= icd->user_width;
 		vb->height	= icd->user_height;
 		vb->field	= field;
 		vb->state	= VIDEOBUF_NEEDS_INIT;
 	}
 
-	vb->size = vb->width * vb->height * ((buf->fmt->depth + 7) >> 3);
+	vb->size = vb->height * bytes_per_line;
 	if (0 != vb->baddr && vb->bsize < vb->size) {
 		ret = -EINVAL;
 		goto out;
@@ -563,19 +573,30 @@ static void sh_mobile_ceu_set_rect(struct soc_camera_device *icd,
 			in_width *= 2;
 			left_offset *= 2;
 		}
-		width = cdwdr_width = out_width;
+		width = out_width;
+		cdwdr_width = out_width;
 	} else {
-		unsigned int w_factor = (icd->current_fmt->depth + 7) >> 3;
+		int bytes_per_line = soc_mbus_bytes_per_line(out_width,
+						icd->current_fmt->host_fmt);
+		unsigned int w_factor;
 
-		width = out_width * w_factor / 2;
+		width = out_width;
 
-		if (!pcdev->is_16bit)
-			w_factor *= 2;
+		switch (icd->current_fmt->host_fmt->packing) {
+		case SOC_MBUS_PACKING_2X8_PADHI:
+			w_factor = 2;
+			break;
+		default:
+			w_factor = 1;
+		}
 
-		in_width = rect->width * w_factor / 2;
-		left_offset = left_offset * w_factor / 2;
+		in_width = rect->width * w_factor;
+		left_offset = left_offset * w_factor;
 
-		cdwdr_width = width * 2;
+		if (bytes_per_line < 0)
+			cdwdr_width = out_width;
+		else
+			cdwdr_width = bytes_per_line;
 	}
 
 	height = out_height;
@@ -672,24 +693,24 @@ static int sh_mobile_ceu_set_bus_param(struct soc_camera_device *icd,
 	value = 0x00000010; /* data fetch by default */
 	yuv_lineskip = 0;
 
-	switch (icd->current_fmt->fourcc) {
+	switch (icd->current_fmt->host_fmt->fourcc) {
 	case V4L2_PIX_FMT_NV12:
 	case V4L2_PIX_FMT_NV21:
 		yuv_lineskip = 1; /* skip for NV12/21, no skip for NV16/61 */
 		/* fall-through */
 	case V4L2_PIX_FMT_NV16:
 	case V4L2_PIX_FMT_NV61:
-		switch (cam->camera_fmt->fourcc) {
-		case V4L2_PIX_FMT_UYVY:
+		switch (cam->code) {
+		case V4L2_MBUS_FMT_UYVY:
 			value = 0x00000000; /* Cb0, Y0, Cr0, Y1 */
 			break;
-		case V4L2_PIX_FMT_VYUY:
+		case V4L2_MBUS_FMT_VYUY:
 			value = 0x00000100; /* Cr0, Y0, Cb0, Y1 */
 			break;
-		case V4L2_PIX_FMT_YUYV:
+		case V4L2_MBUS_FMT_YUYV:
 			value = 0x00000200; /* Y0, Cb0, Y1, Cr0 */
 			break;
-		case V4L2_PIX_FMT_YVYU:
+		case V4L2_MBUS_FMT_YVYU:
 			value = 0x00000300; /* Y0, Cr0, Y1, Cb0 */
 			break;
 		default:
@@ -697,8 +718,8 @@ static int sh_mobile_ceu_set_bus_param(struct soc_camera_device *icd,
 		}
 	}
 
-	if (icd->current_fmt->fourcc == V4L2_PIX_FMT_NV21 ||
-	    icd->current_fmt->fourcc == V4L2_PIX_FMT_NV61)
+	if (icd->current_fmt->host_fmt->fourcc == V4L2_PIX_FMT_NV21 ||
+	    icd->current_fmt->host_fmt->fourcc == V4L2_PIX_FMT_NV61)
 		value ^= 0x00000100; /* swap U, V to change from NV1x->NVx1 */
 
 	value |= common_flags & SOCAM_VSYNC_ACTIVE_LOW ? 1 << 1 : 0;
@@ -745,7 +766,8 @@ static int sh_mobile_ceu_set_bus_param(struct soc_camera_device *icd,
 	return 0;
 }
 
-static int sh_mobile_ceu_try_bus_param(struct soc_camera_device *icd)
+static int sh_mobile_ceu_try_bus_param(struct soc_camera_device *icd,
+				       unsigned char buswidth)
 {
 	struct soc_camera_host *ici = to_soc_camera_host(icd->dev.parent);
 	struct sh_mobile_ceu_dev *pcdev = ici->priv;
@@ -754,48 +776,75 @@ static int sh_mobile_ceu_try_bus_param(struct soc_camera_device *icd)
 	camera_flags = icd->ops->query_bus_param(icd);
 	common_flags = soc_camera_bus_param_compatible(camera_flags,
 						       make_bus_param(pcdev));
-	if (!common_flags)
+	if (!common_flags || buswidth > 16 ||
+	    (buswidth > 8 && !(common_flags & SOCAM_DATAWIDTH_16)))
 		return -EINVAL;
 
 	return 0;
 }
 
-static const struct soc_camera_data_format sh_mobile_ceu_formats[] = {
-	{
-		.name		= "NV12",
-		.depth		= 12,
-		.fourcc		= V4L2_PIX_FMT_NV12,
-		.colorspace	= V4L2_COLORSPACE_JPEG,
-	},
-	{
-		.name		= "NV21",
-		.depth		= 12,
-		.fourcc		= V4L2_PIX_FMT_NV21,
-		.colorspace	= V4L2_COLORSPACE_JPEG,
-	},
-	{
-		.name		= "NV16",
-		.depth		= 16,
-		.fourcc		= V4L2_PIX_FMT_NV16,
-		.colorspace	= V4L2_COLORSPACE_JPEG,
-	},
+static const struct soc_mbus_pixelfmt sh_mobile_ceu_formats[] = {
 	{
-		.name		= "NV61",
-		.depth		= 16,
-		.fourcc		= V4L2_PIX_FMT_NV61,
-		.colorspace	= V4L2_COLORSPACE_JPEG,
+		.fourcc			= V4L2_PIX_FMT_NV12,
+		.name			= "NV12",
+		.bits_per_sample	= 12,
+		.packing		= SOC_MBUS_PACKING_NONE,
+		.order			= SOC_MBUS_ORDER_LE,
+	}, {
+		.fourcc			= V4L2_PIX_FMT_NV21,
+		.name			= "NV21",
+		.bits_per_sample	= 12,
+		.packing		= SOC_MBUS_PACKING_NONE,
+		.order			= SOC_MBUS_ORDER_LE,
+	}, {
+		.fourcc			= V4L2_PIX_FMT_NV16,
+		.name			= "NV16",
+		.bits_per_sample	= 16,
+		.packing		= SOC_MBUS_PACKING_NONE,
+		.order			= SOC_MBUS_ORDER_LE,
+	}, {
+		.fourcc			= V4L2_PIX_FMT_NV61,
+		.name			= "NV61",
+		.bits_per_sample	= 16,
+		.packing		= SOC_MBUS_PACKING_NONE,
+		.order			= SOC_MBUS_ORDER_LE,
 	},
 };
 
+/* This will be corrected as we get more formats */
+static bool sh_mobile_ceu_packing_supported(const struct soc_mbus_pixelfmt *fmt)
+{
+	return	fmt->packing == SOC_MBUS_PACKING_NONE ||
+		(fmt->bits_per_sample == 8 &&
+		 fmt->packing == SOC_MBUS_PACKING_2X8_PADHI) ||
+		(fmt->bits_per_sample > 8 &&
+		 fmt->packing == SOC_MBUS_PACKING_EXTEND16);
+}
+
 static int sh_mobile_ceu_get_formats(struct soc_camera_device *icd, int idx,
 				     struct soc_camera_format_xlate *xlate)
 {
+	struct v4l2_subdev *sd = soc_camera_to_subdev(icd);
 	struct device *dev = icd->dev.parent;
 	int ret, k, n;
 	int formats = 0;
 	struct sh_mobile_ceu_cam *cam;
+	enum v4l2_mbus_pixelcode code;
+	const struct soc_mbus_pixelfmt *fmt;
 
-	ret = sh_mobile_ceu_try_bus_param(icd);
+	ret = v4l2_subdev_call(sd, video, enum_mbus_fmt, idx, &code);
+	if (ret < 0)
+		/* No more formats */
+		return 0;
+
+	fmt = soc_mbus_get_fmtdesc(code);
+	if (!fmt) {
+		dev_err(icd->dev.parent,
+			"Invalid format code #%d: %d\n", idx, code);
+		return -EINVAL;
+	}
+
+	ret = sh_mobile_ceu_try_bus_param(icd, fmt->bits_per_sample);
 	if (ret < 0)
 		return 0;
 
@@ -813,13 +862,13 @@ static int sh_mobile_ceu_get_formats(struct soc_camera_device *icd, int idx,
 	if (!idx)
 		cam->extra_fmt = NULL;
 
-	switch (icd->formats[idx].fourcc) {
-	case V4L2_PIX_FMT_UYVY:
-	case V4L2_PIX_FMT_VYUY:
-	case V4L2_PIX_FMT_YUYV:
-	case V4L2_PIX_FMT_YVYU:
+	switch (code) {
+	case V4L2_MBUS_FMT_UYVY:
+	case V4L2_MBUS_FMT_VYUY:
+	case V4L2_MBUS_FMT_YUYV:
+	case V4L2_MBUS_FMT_YVYU:
 		if (cam->extra_fmt)
-			goto add_single_format;
+			break;
 
 		/*
 		 * Our case is simple so far: for any of the above four camera
@@ -830,32 +879,31 @@ static int sh_mobile_ceu_get_formats(struct soc_camera_device *icd, int idx,
 		 * the host_priv pointer and check whether the format you're
 		 * going to add now is already there.
 		 */
-		cam->extra_fmt = (void *)sh_mobile_ceu_formats;
+		cam->extra_fmt = sh_mobile_ceu_formats;
 
 		n = ARRAY_SIZE(sh_mobile_ceu_formats);
 		formats += n;
 		for (k = 0; xlate && k < n; k++) {
-			xlate->host_fmt = &sh_mobile_ceu_formats[k];
-			xlate->cam_fmt = icd->formats + idx;
-			xlate->buswidth = icd->formats[idx].depth;
+			xlate->host_fmt	= &sh_mobile_ceu_formats[k];
+			xlate->code	= code;
 			xlate++;
-			dev_dbg(dev, "Providing format %s using %s\n",
-				sh_mobile_ceu_formats[k].name,
-				icd->formats[idx].name);
+			dev_dbg(dev, "Providing format %s using code %d\n",
+				sh_mobile_ceu_formats[k].name, code);
 		}
+		break;
 	default:
-add_single_format:
-		/* Generic pass-through */
-		formats++;
-		if (xlate) {
-			xlate->host_fmt = icd->formats + idx;
-			xlate->cam_fmt = icd->formats + idx;
-			xlate->buswidth = icd->formats[idx].depth;
-			xlate++;
-			dev_dbg(dev,
-				"Providing format %s in pass-through mode\n",
-				icd->formats[idx].name);
-		}
+		if (!sh_mobile_ceu_packing_supported(fmt))
+			return 0;
+	}
+
+	/* Generic pass-through */
+	formats++;
+	if (xlate) {
+		xlate->host_fmt	= fmt;
+		xlate->code	= code;
+		xlate++;
+		dev_dbg(dev, "Providing format %s in pass-through mode\n",
+			xlate->host_fmt->name);
 	}
 
 	return formats;
@@ -1035,17 +1083,15 @@ static int client_s_crop(struct v4l2_subdev *sd, struct v4l2_crop *crop,
 static int get_camera_scales(struct v4l2_subdev *sd, struct v4l2_rect *rect,
 			     unsigned int *scale_h, unsigned int *scale_v)
 {
-	struct v4l2_format f;
+	struct v4l2_mbus_framefmt mf;
 	int ret;
 
-	f.type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
-
-	ret = v4l2_subdev_call(sd, video, g_fmt, &f);
+	ret = v4l2_subdev_call(sd, video, g_mbus_fmt, &mf);
 	if (ret < 0)
 		return ret;
 
-	*scale_h = calc_generic_scale(rect->width, f.fmt.pix.width);
-	*scale_v = calc_generic_scale(rect->height, f.fmt.pix.height);
+	*scale_h = calc_generic_scale(rect->width, mf.width);
+	*scale_v = calc_generic_scale(rect->height, mf.height);
 
 	return 0;
 }
@@ -1060,32 +1106,29 @@ static int get_camera_subwin(struct soc_camera_device *icd,
 	if (!ceu_rect->width) {
 		struct v4l2_subdev *sd = soc_camera_to_subdev(icd);
 		struct device *dev = icd->dev.parent;
-		struct v4l2_format f;
-		struct v4l2_pix_format *pix = &f.fmt.pix;
+		struct v4l2_mbus_framefmt mf;
 		int ret;
 		/* First time */
 
-		f.type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
-
-		ret = v4l2_subdev_call(sd, video, g_fmt, &f);
+		ret = v4l2_subdev_call(sd, video, g_mbus_fmt, &mf);
 		if (ret < 0)
 			return ret;
 
-		dev_geo(dev, "camera fmt %ux%u\n", pix->width, pix->height);
+		dev_geo(dev, "camera fmt %ux%u\n", mf.width, mf.height);
 
-		if (pix->width > 2560) {
+		if (mf.width > 2560) {
 			ceu_rect->width	 = 2560;
-			ceu_rect->left	 = (pix->width - 2560) / 2;
+			ceu_rect->left	 = (mf.width - 2560) / 2;
 		} else {
-			ceu_rect->width	 = pix->width;
+			ceu_rect->width	 = mf.width;
 			ceu_rect->left	 = 0;
 		}
 
-		if (pix->height > 1920) {
+		if (mf.height > 1920) {
 			ceu_rect->height = 1920;
-			ceu_rect->top	 = (pix->height - 1920) / 2;
+			ceu_rect->top	 = (mf.height - 1920) / 2;
 		} else {
-			ceu_rect->height = pix->height;
+			ceu_rect->height = mf.height;
 			ceu_rect->top	 = 0;
 		}
 
@@ -1102,13 +1145,12 @@ static int get_camera_subwin(struct soc_camera_device *icd,
 	return 0;
 }
 
-static int client_s_fmt(struct soc_camera_device *icd, struct v4l2_format *f,
-			bool ceu_can_scale)
+static int client_s_fmt(struct soc_camera_device *icd,
+			struct v4l2_mbus_framefmt *mf, bool ceu_can_scale)
 {
 	struct v4l2_subdev *sd = soc_camera_to_subdev(icd);
 	struct device *dev = icd->dev.parent;
-	struct v4l2_pix_format *pix = &f->fmt.pix;
-	unsigned int width = pix->width, height = pix->height, tmp_w, tmp_h;
+	unsigned int width = mf->width, height = mf->height, tmp_w, tmp_h;
 	unsigned int max_width, max_height;
 	struct v4l2_cropcap cap;
 	int ret;
@@ -1122,29 +1164,29 @@ static int client_s_fmt(struct soc_camera_device *icd, struct v4l2_format *f,
 	max_width = min(cap.bounds.width, 2560);
 	max_height = min(cap.bounds.height, 1920);
 
-	ret = v4l2_subdev_call(sd, video, s_fmt, f);
+	ret = v4l2_subdev_call(sd, video, s_mbus_fmt, mf);
 	if (ret < 0)
 		return ret;
 
-	dev_geo(dev, "camera scaled to %ux%u\n", pix->width, pix->height);
+	dev_geo(dev, "camera scaled to %ux%u\n", mf->width, mf->height);
 
-	if ((width == pix->width && height == pix->height) || !ceu_can_scale)
+	if ((width == mf->width && height == mf->height) || !ceu_can_scale)
 		return 0;
 
 	/* Camera set a format, but geometry is not precise, try to improve */
-	tmp_w = pix->width;
-	tmp_h = pix->height;
+	tmp_w = mf->width;
+	tmp_h = mf->height;
 
 	/* width <= max_width && height <= max_height - guaranteed by try_fmt */
 	while ((width > tmp_w || height > tmp_h) &&
 	       tmp_w < max_width && tmp_h < max_height) {
 		tmp_w = min(2 * tmp_w, max_width);
 		tmp_h = min(2 * tmp_h, max_height);
-		pix->width = tmp_w;
-		pix->height = tmp_h;
-		ret = v4l2_subdev_call(sd, video, s_fmt, f);
+		mf->width = tmp_w;
+		mf->height = tmp_h;
+		ret = v4l2_subdev_call(sd, video, s_mbus_fmt, mf);
 		dev_geo(dev, "Camera scaled to %ux%u\n",
-			pix->width, pix->height);
+			mf->width, mf->height);
 		if (ret < 0) {
 			/* This shouldn't happen */
 			dev_err(dev, "Client failed to set format: %d\n", ret);
@@ -1162,27 +1204,26 @@ static int client_s_fmt(struct soc_camera_device *icd, struct v4l2_format *f,
  */
 static int client_scale(struct soc_camera_device *icd, struct v4l2_rect *rect,
 			struct v4l2_rect *sub_rect, struct v4l2_rect *ceu_rect,
-			struct v4l2_format *f, bool ceu_can_scale)
+			struct v4l2_mbus_framefmt *mf, bool ceu_can_scale)
 {
 	struct v4l2_subdev *sd = soc_camera_to_subdev(icd);
 	struct sh_mobile_ceu_cam *cam = icd->host_priv;
 	struct device *dev = icd->dev.parent;
-	struct v4l2_format f_tmp = *f;
-	struct v4l2_pix_format *pix_tmp = &f_tmp.fmt.pix;
+	struct v4l2_mbus_framefmt mf_tmp = *mf;
 	unsigned int scale_h, scale_v;
 	int ret;
 
 	/* 5. Apply iterative camera S_FMT for camera user window. */
-	ret = client_s_fmt(icd, &f_tmp, ceu_can_scale);
+	ret = client_s_fmt(icd, &mf_tmp, ceu_can_scale);
 	if (ret < 0)
 		return ret;
 
 	dev_geo(dev, "5: camera scaled to %ux%u\n",
-		pix_tmp->width, pix_tmp->height);
+		mf_tmp.width, mf_tmp.height);
 
 	/* 6. Retrieve camera output window (g_fmt) */
 
-	/* unneeded - it is already in "f_tmp" */
+	/* unneeded - it is already in "mf_tmp" */
 
 	/* 7. Calculate new camera scales. */
 	ret = get_camera_scales(sd, rect, &scale_h, &scale_v);
@@ -1191,10 +1232,11 @@ static int client_scale(struct soc_camera_device *icd, struct v4l2_rect *rect,
 
 	dev_geo(dev, "7: camera scales %u:%u\n", scale_h, scale_v);
 
-	cam->cam_width		= pix_tmp->width;
-	cam->cam_height		= pix_tmp->height;
-	f->fmt.pix.width	= pix_tmp->width;
-	f->fmt.pix.height	= pix_tmp->height;
+	cam->cam_width	= mf_tmp.width;
+	cam->cam_height	= mf_tmp.height;
+	mf->width	= mf_tmp.width;
+	mf->height	= mf_tmp.height;
+	mf->colorspace	= mf_tmp.colorspace;
 
 	/*
 	 * 8. Calculate new CEU crop - apply camera scales to previously
@@ -1258,8 +1300,7 @@ static int sh_mobile_ceu_set_crop(struct soc_camera_device *icd,
 	struct v4l2_rect *cam_rect = &cam_crop.c, *ceu_rect = &cam->ceu_rect;
 	struct v4l2_subdev *sd = soc_camera_to_subdev(icd);
 	struct device *dev = icd->dev.parent;
-	struct v4l2_format f;
-	struct v4l2_pix_format *pix = &f.fmt.pix;
+	struct v4l2_mbus_framefmt mf;
 	unsigned int scale_comb_h, scale_comb_v, scale_ceu_h, scale_ceu_v,
 		out_width, out_height;
 	u32 capsr, cflcr;
@@ -1308,25 +1349,24 @@ static int sh_mobile_ceu_set_crop(struct soc_camera_device *icd,
 	 * 5. Using actual input window and calculated combined scales calculate
 	 *    camera target output window.
 	 */
-	pix->width		= scale_down(cam_rect->width, scale_comb_h);
-	pix->height		= scale_down(cam_rect->height, scale_comb_v);
+	mf.width	= scale_down(cam_rect->width, scale_comb_h);
+	mf.height	= scale_down(cam_rect->height, scale_comb_v);
 
-	dev_geo(dev, "5: camera target %ux%u\n", pix->width, pix->height);
+	dev_geo(dev, "5: camera target %ux%u\n", mf.width, mf.height);
 
 	/* 6. - 9. */
-	pix->pixelformat	= cam->camera_fmt->fourcc;
-	pix->colorspace		= cam->camera_fmt->colorspace;
+	mf.code		= cam->code;
+	mf.field	= pcdev->is_interlaced ? V4L2_FIELD_INTERLACED :
+						V4L2_FIELD_NONE;
 
 	capsr = capture_save_reset(pcdev);
 	dev_dbg(dev, "CAPSR 0x%x, CFLCR 0x%x\n", capsr, pcdev->cflcr);
 
 	/* Make relative to camera rectangle */
-	rect->left		-= cam_rect->left;
-	rect->top		-= cam_rect->top;
+	rect->left	-= cam_rect->left;
+	rect->top	-= cam_rect->top;
 
-	f.type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
-
-	ret = client_scale(icd, cam_rect, rect, ceu_rect, &f,
+	ret = client_scale(icd, cam_rect, rect, ceu_rect, &mf,
 			   pcdev->image_mode && !pcdev->is_interlaced);
 
 	dev_geo(dev, "6-9: %d\n", ret);
@@ -1374,8 +1414,7 @@ static int sh_mobile_ceu_set_fmt(struct soc_camera_device *icd,
 	struct sh_mobile_ceu_dev *pcdev = ici->priv;
 	struct sh_mobile_ceu_cam *cam = icd->host_priv;
 	struct v4l2_pix_format *pix = &f->fmt.pix;
-	struct v4l2_format cam_f = *f;
-	struct v4l2_pix_format *cam_pix = &cam_f.fmt.pix;
+	struct v4l2_mbus_framefmt mf;
 	struct v4l2_subdev *sd = soc_camera_to_subdev(icd);
 	struct device *dev = icd->dev.parent;
 	__u32 pixfmt = pix->pixelformat;
@@ -1444,9 +1483,11 @@ static int sh_mobile_ceu_set_fmt(struct soc_camera_device *icd,
 	 * 4. Calculate camera output window by applying combined scales to real
 	 *    input window.
 	 */
-	cam_pix->width = scale_down(cam_rect->width, scale_h);
-	cam_pix->height = scale_down(cam_rect->height, scale_v);
-	cam_pix->pixelformat = xlate->cam_fmt->fourcc;
+	mf.width	= scale_down(cam_rect->width, scale_h);
+	mf.height	= scale_down(cam_rect->height, scale_v);
+	mf.field	= pix->field;
+	mf.colorspace	= pix->colorspace;
+	mf.code		= xlate->code;
 
 	switch (pixfmt) {
 	case V4L2_PIX_FMT_NV12:
@@ -1459,11 +1500,10 @@ static int sh_mobile_ceu_set_fmt(struct soc_camera_device *icd,
 		image_mode = false;
 	}
 
-	dev_geo(dev, "4: camera output %ux%u\n",
-		cam_pix->width, cam_pix->height);
+	dev_geo(dev, "4: camera output %ux%u\n", mf.width, mf.height);
 
 	/* 5. - 9. */
-	ret = client_scale(icd, cam_rect, &cam_subrect, &ceu_rect, &cam_f,
+	ret = client_scale(icd, cam_rect, &cam_subrect, &ceu_rect, &mf,
 			   image_mode && !is_interlaced);
 
 	dev_geo(dev, "5-9: client scale %d\n", ret);
@@ -1471,37 +1511,48 @@ static int sh_mobile_ceu_set_fmt(struct soc_camera_device *icd,
 	/* Done with the camera. Now see if we can improve the result */
 
 	dev_dbg(dev, "Camera %d fmt %ux%u, requested %ux%u\n",
-		ret, cam_pix->width, cam_pix->height, pix->width, pix->height);
+		ret, mf.width, mf.height, pix->width, pix->height);
 	if (ret < 0)
 		return ret;
 
+	if (mf.code != xlate->code)
+		return -EINVAL;
+
 	/* 10. Use CEU scaling to scale to the requested user window. */
 
 	/* We cannot scale up */
-	if (pix->width > cam_pix->width)
-		pix->width = cam_pix->width;
+	if (pix->width > mf.width)
+		pix->width = mf.width;
 	if (pix->width > ceu_rect.width)
 		pix->width = ceu_rect.width;
 
-	if (pix->height > cam_pix->height)
-		pix->height = cam_pix->height;
+	if (pix->height > mf.height)
+		pix->height = mf.height;
 	if (pix->height > ceu_rect.height)
 		pix->height = ceu_rect.height;
 
-	/* Let's rock: scale pix->{width x height} down to width x height */
-	scale_h = calc_scale(ceu_rect.width, &pix->width);
-	scale_v = calc_scale(ceu_rect.height, &pix->height);
+	pix->colorspace = mf.colorspace;
+
+	if (image_mode) {
+		/* Scale pix->{width x height} down to width x height */
+		scale_h = calc_scale(ceu_rect.width, &pix->width);
+		scale_v = calc_scale(ceu_rect.height, &pix->height);
+
+		pcdev->cflcr = scale_h | (scale_v << 16);
+	} else {
+		pix->width = ceu_rect.width;
+		pix->height = ceu_rect.height;
+		scale_h = scale_v = 0;
+		pcdev->cflcr = 0;
+	}
 
 	dev_geo(dev, "10: W: %u : 0x%x = %u, H: %u : 0x%x = %u\n",
 		ceu_rect.width, scale_h, pix->width,
 		ceu_rect.height, scale_v, pix->height);
 
-	pcdev->cflcr = scale_h | (scale_v << 16);
-
-	icd->buswidth = xlate->buswidth;
-	icd->current_fmt = xlate->host_fmt;
-	cam->camera_fmt = xlate->cam_fmt;
-	cam->ceu_rect = ceu_rect;
+	cam->code		= xlate->code;
+	cam->ceu_rect		= ceu_rect;
+	icd->current_fmt	= xlate;
 
 	pcdev->is_interlaced = is_interlaced;
 	pcdev->image_mode = image_mode;
@@ -1515,6 +1566,7 @@ static int sh_mobile_ceu_try_fmt(struct soc_camera_device *icd,
 	const struct soc_camera_format_xlate *xlate;
 	struct v4l2_pix_format *pix = &f->fmt.pix;
 	struct v4l2_subdev *sd = soc_camera_to_subdev(icd);
+	struct v4l2_mbus_framefmt mf;
 	__u32 pixfmt = pix->pixelformat;
 	int width, height;
 	int ret;
@@ -1533,18 +1585,27 @@ static int sh_mobile_ceu_try_fmt(struct soc_camera_device *icd,
 	width = pix->width;
 	height = pix->height;
 
-	pix->bytesperline = pix->width *
-		DIV_ROUND_UP(xlate->host_fmt->depth, 8);
-	pix->sizeimage = pix->height * pix->bytesperline;
-
-	pix->pixelformat = xlate->cam_fmt->fourcc;
+	pix->bytesperline = soc_mbus_bytes_per_line(width, xlate->host_fmt);
+	if (pix->bytesperline < 0)
+		return pix->bytesperline;
+	pix->sizeimage = height * pix->bytesperline;
 
 	/* limit to sensor capabilities */
-	ret = v4l2_subdev_call(sd, video, try_fmt, f);
-	pix->pixelformat = pixfmt;
+	mf.width	= pix->width;
+	mf.height	= pix->height;
+	mf.field	= pix->field;
+	mf.code		= xlate->code;
+	mf.colorspace	= pix->colorspace;
+
+	ret = v4l2_subdev_call(sd, video, try_mbus_fmt, &mf);
 	if (ret < 0)
 		return ret;
 
+	pix->width	= mf.width;
+	pix->height	= mf.height;
+	pix->field	= mf.field;
+	pix->colorspace	= mf.colorspace;
+
 	switch (pixfmt) {
 	case V4L2_PIX_FMT_NV12:
 	case V4L2_PIX_FMT_NV21:
@@ -1553,21 +1614,25 @@ static int sh_mobile_ceu_try_fmt(struct soc_camera_device *icd,
 		/* FIXME: check against rect_max after converting soc-camera */
 		/* We can scale precisely, need a bigger image from camera */
 		if (pix->width < width || pix->height < height) {
-			int tmp_w = pix->width, tmp_h = pix->height;
-			pix->width = 2560;
-			pix->height = 1920;
-			ret = v4l2_subdev_call(sd, video, try_fmt, f);
+			/*
+			 * We presume, the sensor behaves sanely, i.e., if
+			 * requested a bigger rectangle, it will not return a
+			 * smaller one.
+			 */
+			mf.width = 2560;
+			mf.height = 1920;
+			ret = v4l2_subdev_call(sd, video, try_mbus_fmt, &mf);
 			if (ret < 0) {
 				/* Shouldn't actually happen... */
 				dev_err(icd->dev.parent,
-					"FIXME: try_fmt() returned %d\n", ret);
-				pix->width = tmp_w;
-				pix->height = tmp_h;
+					"FIXME: client try_fmt() = %d\n", ret);
+				return ret;
 			}
 		}
-		if (pix->width > width)
+		/* We will scale exactly */
+		if (mf.width > width)
 			pix->width = width;
-		if (pix->height > height)
+		if (mf.height > height)
 			pix->height = height;
 	}
 
@@ -1662,7 +1727,7 @@ static int sh_mobile_ceu_set_ctrl(struct soc_camera_device *icd,
 
 	switch (ctrl->id) {
 	case V4L2_CID_SHARPNESS:
-		switch (icd->current_fmt->fourcc) {
+		switch (icd->current_fmt->host_fmt->fourcc) {
 		case V4L2_PIX_FMT_NV12:
 		case V4L2_PIX_FMT_NV21:
 		case V4L2_PIX_FMT_NV16:
diff --git a/drivers/media/video/soc_camera.c b/drivers/media/video/soc_camera.c
index 44d49a0..23bdedd 100644
--- a/drivers/media/video/soc_camera.c
+++ b/drivers/media/video/soc_camera.c
@@ -31,6 +31,7 @@
 #include <media/v4l2-ioctl.h>
 #include <media/v4l2-dev.h>
 #include <media/videobuf-core.h>
+#include <media/soc_mediabus.h>
 
 /* Default to VGA resolution */
 #define DEFAULT_WIDTH	640
@@ -40,18 +41,6 @@ static LIST_HEAD(hosts);
 static LIST_HEAD(devices);
 static DEFINE_MUTEX(list_lock);		/* Protects the list of hosts */
 
-const struct soc_camera_data_format *soc_camera_format_by_fourcc(
-	struct soc_camera_device *icd, unsigned int fourcc)
-{
-	unsigned int i;
-
-	for (i = 0; i < icd->num_formats; i++)
-		if (icd->formats[i].fourcc == fourcc)
-			return icd->formats + i;
-	return NULL;
-}
-EXPORT_SYMBOL(soc_camera_format_by_fourcc);
-
 const struct soc_camera_format_xlate *soc_camera_xlate_by_fourcc(
 	struct soc_camera_device *icd, unsigned int fourcc)
 {
@@ -207,21 +196,26 @@ static int soc_camera_dqbuf(struct file *file, void *priv,
 /* Always entered with .video_lock held */
 static int soc_camera_init_user_formats(struct soc_camera_device *icd)
 {
+	struct v4l2_subdev *sd = soc_camera_to_subdev(icd);
 	struct soc_camera_host *ici = to_soc_camera_host(icd->dev.parent);
-	int i, fmts = 0, ret;
+	int i, fmts = 0, raw_fmts = 0, ret;
+	enum v4l2_mbus_pixelcode code;
+
+	while (!v4l2_subdev_call(sd, video, enum_mbus_fmt, raw_fmts, &code))
+		raw_fmts++;
 
 	if (!ici->ops->get_formats)
 		/*
 		 * Fallback mode - the host will have to serve all
 		 * sensor-provided formats one-to-one to the user
 		 */
-		fmts = icd->num_formats;
+		fmts = raw_fmts;
 	else
 		/*
 		 * First pass - only count formats this host-sensor
 		 * configuration can provide
 		 */
-		for (i = 0; i < icd->num_formats; i++) {
+		for (i = 0; i < raw_fmts; i++) {
 			ret = ici->ops->get_formats(icd, i, NULL);
 			if (ret < 0)
 				return ret;
@@ -242,11 +236,12 @@ static int soc_camera_init_user_formats(struct soc_camera_device *icd)
 
 	/* Second pass - actually fill data formats */
 	fmts = 0;
-	for (i = 0; i < icd->num_formats; i++)
+	for (i = 0; i < raw_fmts; i++)
 		if (!ici->ops->get_formats) {
-			icd->user_formats[i].host_fmt = icd->formats + i;
-			icd->user_formats[i].cam_fmt = icd->formats + i;
-			icd->user_formats[i].buswidth = icd->formats[i].depth;
+			v4l2_subdev_call(sd, video, enum_mbus_fmt, i, &code);
+			icd->user_formats[i].host_fmt =
+				soc_mbus_get_fmtdesc(code);
+			icd->user_formats[i].code = code;
 		} else {
 			ret = ici->ops->get_formats(icd, i,
 						    &icd->user_formats[fmts]);
@@ -255,7 +250,7 @@ static int soc_camera_init_user_formats(struct soc_camera_device *icd)
 			fmts += ret;
 		}
 
-	icd->current_fmt = icd->user_formats[0].host_fmt;
+	icd->current_fmt = &icd->user_formats[0];
 
 	return 0;
 
@@ -281,7 +276,7 @@ static void soc_camera_free_user_formats(struct soc_camera_device *icd)
 #define pixfmtstr(x) (x) & 0xff, ((x) >> 8) & 0xff, ((x) >> 16) & 0xff, \
 	((x) >> 24) & 0xff
 
-/* Called with .vb_lock held */
+/* Called with .vb_lock held, or from the first open(2), see comment there */
 static int soc_camera_set_fmt(struct soc_camera_file *icf,
 			      struct v4l2_format *f)
 {
@@ -302,7 +297,7 @@ static int soc_camera_set_fmt(struct soc_camera_file *icf,
 	if (ret < 0) {
 		return ret;
 	} else if (!icd->current_fmt ||
-		   icd->current_fmt->fourcc != pix->pixelformat) {
+		   icd->current_fmt->host_fmt->fourcc != pix->pixelformat) {
 		dev_err(&icd->dev,
 			"Host driver hasn't set up current format correctly!\n");
 		return -EINVAL;
@@ -310,6 +305,7 @@ static int soc_camera_set_fmt(struct soc_camera_file *icf,
 
 	icd->user_width		= pix->width;
 	icd->user_height	= pix->height;
+	icd->colorspace		= pix->colorspace;
 	icf->vb_vidq.field	=
 		icd->field	= pix->field;
 
@@ -369,8 +365,9 @@ static int soc_camera_open(struct file *file)
 				.width		= icd->user_width,
 				.height		= icd->user_height,
 				.field		= icd->field,
-				.pixelformat	= icd->current_fmt->fourcc,
-				.colorspace	= icd->current_fmt->colorspace,
+				.colorspace	= icd->colorspace,
+				.pixelformat	=
+					icd->current_fmt->host_fmt->fourcc,
 			},
 		};
 
@@ -390,7 +387,12 @@ static int soc_camera_open(struct file *file)
 			goto eiciadd;
 		}
 
-		/* Try to configure with default parameters */
+		/*
+		 * Try to configure with default parameters. Notice: this is the
+		 * very first open, so, we cannot race against other calls,
+		 * apart from someone else calling open() simultaneously, but
+		 * .video_lock is protecting us against it.
+		 */
 		ret = soc_camera_set_fmt(icf, &f);
 		if (ret < 0)
 			goto esfmt;
@@ -534,7 +536,7 @@ static int soc_camera_enum_fmt_vid_cap(struct file *file, void  *priv,
 {
 	struct soc_camera_file *icf = file->private_data;
 	struct soc_camera_device *icd = icf->icd;
-	const struct soc_camera_data_format *format;
+	const struct soc_mbus_pixelfmt *format;
 
 	WARN_ON(priv != file->private_data);
 
@@ -543,7 +545,8 @@ static int soc_camera_enum_fmt_vid_cap(struct file *file, void  *priv,
 
 	format = icd->user_formats[f->index].host_fmt;
 
-	strlcpy(f->description, format->name, sizeof(f->description));
+	if (format->name)
+		strlcpy(f->description, format->name, sizeof(f->description));
 	f->pixelformat = format->fourcc;
 	return 0;
 }
@@ -560,12 +563,15 @@ static int soc_camera_g_fmt_vid_cap(struct file *file, void *priv,
 	pix->width		= icd->user_width;
 	pix->height		= icd->user_height;
 	pix->field		= icf->vb_vidq.field;
-	pix->pixelformat	= icd->current_fmt->fourcc;
-	pix->bytesperline	= pix->width *
-		DIV_ROUND_UP(icd->current_fmt->depth, 8);
+	pix->pixelformat	= icd->current_fmt->host_fmt->fourcc;
+	pix->bytesperline	= soc_mbus_bytes_per_line(pix->width,
+						icd->current_fmt->host_fmt);
+	pix->colorspace		= icd->colorspace;
+	if (pix->bytesperline < 0)
+		return pix->bytesperline;
 	pix->sizeimage		= pix->height * pix->bytesperline;
 	dev_dbg(&icd->dev, "current_fmt->fourcc: 0x%08x\n",
-		icd->current_fmt->fourcc);
+		icd->current_fmt->host_fmt->fourcc);
 	return 0;
 }
 
@@ -894,7 +900,7 @@ static int soc_camera_probe(struct device *dev)
 	struct soc_camera_link *icl = to_soc_camera_link(icd);
 	struct device *control = NULL;
 	struct v4l2_subdev *sd;
-	struct v4l2_format f = {.type = V4L2_BUF_TYPE_VIDEO_CAPTURE};
+	struct v4l2_mbus_framefmt mf;
 	int ret;
 
 	dev_info(dev, "Probing %s\n", dev_name(dev));
@@ -965,9 +971,11 @@ static int soc_camera_probe(struct device *dev)
 
 	/* Try to improve our guess of a reasonable window format */
 	sd = soc_camera_to_subdev(icd);
-	if (!v4l2_subdev_call(sd, video, g_fmt, &f)) {
-		icd->user_width		= f.fmt.pix.width;
-		icd->user_height	= f.fmt.pix.height;
+	if (!v4l2_subdev_call(sd, video, g_mbus_fmt, &mf)) {
+		icd->user_width		= mf.width;
+		icd->user_height	= mf.height;
+		icd->colorspace		= mf.colorspace;
+		icd->field		= mf.field;
 	}
 
 	/* Do we have to sysfs_remove_link() before device_unregister()? */
diff --git a/drivers/media/video/soc_camera_platform.c b/drivers/media/video/soc_camera_platform.c
index c7c9151..10b003a 100644
--- a/drivers/media/video/soc_camera_platform.c
+++ b/drivers/media/video/soc_camera_platform.c
@@ -22,7 +22,6 @@
 
 struct soc_camera_platform_priv {
 	struct v4l2_subdev subdev;
-	struct soc_camera_data_format format;
 };
 
 static struct soc_camera_platform_priv *get_priv(struct platform_device *pdev)
@@ -58,36 +57,36 @@ soc_camera_platform_query_bus_param(struct soc_camera_device *icd)
 }
 
 static int soc_camera_platform_try_fmt(struct v4l2_subdev *sd,
-				       struct v4l2_format *f)
+				       struct v4l2_mbus_framefmt *mf)
 {
 	struct soc_camera_platform_info *p = v4l2_get_subdevdata(sd);
-	struct v4l2_pix_format *pix = &f->fmt.pix;
 
-	pix->width = p->format.width;
-	pix->height = p->format.height;
+	mf->width	= p->format.width;
+	mf->height	= p->format.height;
+	mf->code	= p->format.code;
+	mf->colorspace	= p->format.colorspace;
+
 	return 0;
 }
 
-static void soc_camera_platform_video_probe(struct soc_camera_device *icd,
-					    struct platform_device *pdev)
+static struct v4l2_subdev_core_ops platform_subdev_core_ops;
+
+static int soc_camera_platform_enum_fmt(struct v4l2_subdev *sd, int index,
+					enum v4l2_mbus_pixelcode *code)
 {
-	struct soc_camera_platform_priv *priv = get_priv(pdev);
-	struct soc_camera_platform_info *p = pdev->dev.platform_data;
+	struct soc_camera_platform_info *p = v4l2_get_subdevdata(sd);
 
-	priv->format.name = p->format_name;
-	priv->format.depth = p->format_depth;
-	priv->format.fourcc = p->format.pixelformat;
-	priv->format.colorspace = p->format.colorspace;
+	if (index)
+		return -EINVAL;
 
-	icd->formats = &priv->format;
-	icd->num_formats = 1;
+	*code = p->format.code;
+	return 0;
 }
 
-static struct v4l2_subdev_core_ops platform_subdev_core_ops;
-
 static struct v4l2_subdev_video_ops platform_subdev_video_ops = {
 	.s_stream	= soc_camera_platform_s_stream,
-	.try_fmt	= soc_camera_platform_try_fmt,
+	.try_mbus_fmt	= soc_camera_platform_try_fmt,
+	.enum_mbus_fmt	= soc_camera_platform_enum_fmt,
 };
 
 static struct v4l2_subdev_ops platform_subdev_ops = {
@@ -128,12 +127,10 @@ static int soc_camera_platform_probe(struct platform_device *pdev)
 	/* Set the control device reference */
 	dev_set_drvdata(&icd->dev, &pdev->dev);
 
-	icd->ops		= &soc_camera_platform_ops;
+	icd->ops = &soc_camera_platform_ops;
 
 	ici = to_soc_camera_host(icd->dev.parent);
 
-	soc_camera_platform_video_probe(icd, pdev);
-
 	v4l2_subdev_init(&priv->subdev, &platform_subdev_ops);
 	v4l2_set_subdevdata(&priv->subdev, p);
 	strncpy(priv->subdev.name, dev_name(&pdev->dev), V4L2_SUBDEV_NAME_SIZE);
diff --git a/drivers/media/video/tw9910.c b/drivers/media/video/tw9910.c
index 8ec1031..5c64a2c 100644
--- a/drivers/media/video/tw9910.c
+++ b/drivers/media/video/tw9910.c
@@ -26,6 +26,7 @@
 #include <media/v4l2-chip-ident.h>
 #include <media/v4l2-subdev.h>
 #include <media/soc_camera.h>
+#include <media/soc_mediabus.h>
 #include <media/tw9910.h>
 
 #define GET_ID(val)  ((val & 0xF8) >> 3)
@@ -251,13 +252,8 @@ static const struct regval_list tw9910_default_regs[] =
 	ENDMARKER,
 };
 
-static const struct soc_camera_data_format tw9910_color_fmt[] = {
-	{
-		.name       = "VYUY",
-		.fourcc     = V4L2_PIX_FMT_VYUY,
-		.depth      = 16,
-		.colorspace = V4L2_COLORSPACE_SMPTE170M,
-	}
+static const struct soc_mbus_datafmt tw9910_fmts[] = {
+	{V4L2_MBUS_FMT_VYUY, V4L2_COLORSPACE_JPEG},
 };
 
 static const struct tw9910_scale_ctrl tw9910_ntsc_scales[] = {
@@ -814,11 +810,11 @@ static int tw9910_cropcap(struct v4l2_subdev *sd, struct v4l2_cropcap *a)
 	return 0;
 }
 
-static int tw9910_g_fmt(struct v4l2_subdev *sd, struct v4l2_format *f)
+static int tw9910_g_fmt(struct v4l2_subdev *sd,
+			struct v4l2_mbus_framefmt *mf)
 {
 	struct i2c_client *client = sd->priv;
 	struct tw9910_priv *priv = to_tw9910(client);
-	struct v4l2_pix_format *pix = &f->fmt.pix;
 
 	if (!priv->scale) {
 		int ret;
@@ -835,74 +831,85 @@ static int tw9910_g_fmt(struct v4l2_subdev *sd, struct v4l2_format *f)
 			return ret;
 	}
 
-	f->type			= V4L2_BUF_TYPE_VIDEO_CAPTURE;
-
-	pix->width		= priv->scale->width;
-	pix->height		= priv->scale->height;
-	pix->pixelformat	= V4L2_PIX_FMT_VYUY;
-	pix->colorspace		= V4L2_COLORSPACE_SMPTE170M;
-	pix->field		= V4L2_FIELD_INTERLACED;
+	mf->width	= priv->scale->width;
+	mf->height	= priv->scale->height;
+	mf->code	= V4L2_MBUS_FMT_VYUY;
+	mf->colorspace	= V4L2_COLORSPACE_JPEG;
+	mf->field	= V4L2_FIELD_INTERLACED;
 
 	return 0;
 }
 
-static int tw9910_s_fmt(struct v4l2_subdev *sd, struct v4l2_format *f)
+static int tw9910_s_fmt(struct v4l2_subdev *sd,
+			struct v4l2_mbus_framefmt *mf)
 {
 	struct i2c_client *client = sd->priv;
 	struct tw9910_priv *priv = to_tw9910(client);
-	struct v4l2_pix_format *pix = &f->fmt.pix;
+	const struct soc_mbus_datafmt *fmt;
 	/* See tw9910_s_crop() - no proper cropping support */
 	struct v4l2_crop a = {
 		.c = {
 			.left	= 0,
 			.top	= 0,
-			.width	= pix->width,
-			.height	= pix->height,
+			.width	= mf->width,
+			.height	= mf->height,
 		},
 	};
-	int i, ret;
+	int ret;
+
+	WARN_ON(mf->field != V4L2_FIELD_ANY &&
+		mf->field != V4L2_FIELD_INTERLACED);
 
 	/*
 	 * check color format
 	 */
-	for (i = 0; i < ARRAY_SIZE(tw9910_color_fmt); i++)
-		if (pix->pixelformat == tw9910_color_fmt[i].fourcc)
-			break;
-
-	if (i == ARRAY_SIZE(tw9910_color_fmt))
+	fmt = soc_mbus_find_datafmt(mf->code, tw9910_fmts,
+				    ARRAY_SIZE(tw9910_fmts));
+	if (!fmt)
 		return -EINVAL;
 
+	mf->colorspace = fmt->colorspace;
+
 	ret = tw9910_s_crop(sd, &a);
 	if (!ret) {
-		pix->width = priv->scale->width;
-		pix->height = priv->scale->height;
+		mf->width	= priv->scale->width;
+		mf->height	= priv->scale->height;
 	}
 	return ret;
 }
 
-static int tw9910_try_fmt(struct v4l2_subdev *sd, struct v4l2_format *f)
+static int tw9910_try_fmt(struct v4l2_subdev *sd,
+			  struct v4l2_mbus_framefmt *mf)
 {
 	struct i2c_client *client = sd->priv;
 	struct soc_camera_device *icd = client->dev.platform_data;
-	struct v4l2_pix_format *pix = &f->fmt.pix;
 	const struct tw9910_scale_ctrl *scale;
+	const struct soc_mbus_datafmt *fmt;
 
-	if (V4L2_FIELD_ANY == pix->field) {
-		pix->field = V4L2_FIELD_INTERLACED;
-	} else if (V4L2_FIELD_INTERLACED != pix->field) {
-		dev_err(&client->dev, "Field type invalid.\n");
+	if (V4L2_FIELD_ANY == mf->field) {
+		mf->field = V4L2_FIELD_INTERLACED;
+	} else if (V4L2_FIELD_INTERLACED != mf->field) {
+		dev_err(&client->dev, "Field type %d invalid.\n", mf->field);
 		return -EINVAL;
 	}
 
+	fmt = soc_mbus_find_datafmt(mf->code, tw9910_fmts,
+				    ARRAY_SIZE(tw9910_fmts));
+	if (!fmt) {
+		fmt = tw9910_fmts;
+		mf->code = fmt->code;
+	}
+	mf->colorspace = fmt->colorspace;
+
 	/*
 	 * select suitable norm
 	 */
-	scale = tw9910_select_norm(icd, pix->width, pix->height);
+	scale = tw9910_select_norm(icd, mf->width, mf->height);
 	if (!scale)
 		return -EINVAL;
 
-	pix->width  = scale->width;
-	pix->height = scale->height;
+	mf->width	= scale->width;
+	mf->height	= scale->height;
 
 	return 0;
 }
@@ -930,9 +937,6 @@ static int tw9910_video_probe(struct soc_camera_device *icd,
 		return -ENODEV;
 	}
 
-	icd->formats     = tw9910_color_fmt;
-	icd->num_formats = ARRAY_SIZE(tw9910_color_fmt);
-
 	/*
 	 * check and show Product ID
 	 * So far only revisions 0 and 1 have been seen
@@ -973,14 +977,25 @@ static struct v4l2_subdev_core_ops tw9910_subdev_core_ops = {
 #endif
 };
 
+static int tw9910_enum_fmt(struct v4l2_subdev *sd, int index,
+			   enum v4l2_mbus_pixelcode *code)
+{
+	if ((unsigned int)index >= ARRAY_SIZE(tw9910_fmts))
+		return -EINVAL;
+
+	*code = tw9910_fmts[index].code;
+	return 0;
+}
+
 static struct v4l2_subdev_video_ops tw9910_subdev_video_ops = {
 	.s_stream	= tw9910_s_stream,
-	.g_fmt		= tw9910_g_fmt,
-	.s_fmt		= tw9910_s_fmt,
-	.try_fmt	= tw9910_try_fmt,
+	.g_mbus_fmt	= tw9910_g_fmt,
+	.s_mbus_fmt	= tw9910_s_fmt,
+	.try_mbus_fmt	= tw9910_try_fmt,
 	.cropcap	= tw9910_cropcap,
 	.g_crop		= tw9910_g_crop,
 	.s_crop		= tw9910_s_crop,
+	.enum_mbus_fmt	= tw9910_enum_fmt,
 };
 
 static struct v4l2_subdev_ops tw9910_subdev_ops = {
diff --git a/include/media/soc_camera.h b/include/media/soc_camera.h
index 831efff..dcc5b86 100644
--- a/include/media/soc_camera.h
+++ b/include/media/soc_camera.h
@@ -24,15 +24,13 @@ struct soc_camera_device {
 	struct device *pdev;		/* Platform device */
 	s32 user_width;
 	s32 user_height;
+	enum v4l2_colorspace colorspace;
 	unsigned char iface;		/* Host number */
 	unsigned char devnum;		/* Device number per host */
-	unsigned char buswidth;		/* See comment in .c */
 	struct soc_camera_sense *sense;	/* See comment in struct definition */
 	struct soc_camera_ops *ops;
 	struct video_device *vdev;
-	const struct soc_camera_data_format *current_fmt;
-	const struct soc_camera_data_format *formats;
-	int num_formats;
+	const struct soc_camera_format_xlate *current_fmt;
 	struct soc_camera_format_xlate *user_formats;
 	int num_user_formats;
 	enum v4l2_field field;		/* Preserve field over close() */
@@ -161,23 +159,13 @@ static inline struct v4l2_subdev *soc_camera_to_subdev(
 int soc_camera_host_register(struct soc_camera_host *ici);
 void soc_camera_host_unregister(struct soc_camera_host *ici);
 
-const struct soc_camera_data_format *soc_camera_format_by_fourcc(
-	struct soc_camera_device *icd, unsigned int fourcc);
 const struct soc_camera_format_xlate *soc_camera_xlate_by_fourcc(
 	struct soc_camera_device *icd, unsigned int fourcc);
 
-struct soc_camera_data_format {
-	const char *name;
-	unsigned int depth;
-	__u32 fourcc;
-	enum v4l2_colorspace colorspace;
-};
-
 /**
  * struct soc_camera_format_xlate - match between host and sensor formats
- * @cam_fmt: sensor format provided by the sensor
- * @host_fmt: host format after host translation from cam_fmt
- * @buswidth: bus width for this format
+ * @code: code of a sensor provided format
+ * @host_fmt: host format after host translation from code
  *
  * Host and sensor translation structure. Used in table of host and sensor
  * formats matchings in soc_camera_device. A host can override the generic list
@@ -185,9 +173,8 @@ struct soc_camera_data_format {
  * format setup.
  */
 struct soc_camera_format_xlate {
-	const struct soc_camera_data_format *cam_fmt;
-	const struct soc_camera_data_format *host_fmt;
-	unsigned char buswidth;
+	enum v4l2_mbus_pixelcode code;
+	const struct soc_mbus_pixelfmt *host_fmt;
 };
 
 struct soc_camera_ops {
diff --git a/include/media/soc_camera_platform.h b/include/media/soc_camera_platform.h
index 88b3b57..0ecefe2 100644
--- a/include/media/soc_camera_platform.h
+++ b/include/media/soc_camera_platform.h
@@ -19,7 +19,7 @@ struct device;
 struct soc_camera_platform_info {
 	const char *format_name;
 	unsigned long format_depth;
-	struct v4l2_pix_format format;
+	struct v4l2_mbus_framefmt format;
 	unsigned long bus_param;
 	struct device *dev;
 	int (*set_capture)(struct soc_camera_platform_info *info, int enable);
