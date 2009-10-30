Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:57053 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S932142AbZJ3OBa (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 30 Oct 2009 10:01:30 -0400
Date: Fri, 30 Oct 2009 15:01:32 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
cc: Hans Verkuil <hverkuil@xs4all.nl>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>,
	Muralidharan Karicheri <m-karicheri2@ti.com>
Subject: [PATCH/RFC 8/9 v2] soc-camera: convert to the new imagebus API
In-Reply-To: <Pine.LNX.4.64.0910301338140.4378@axis700.grange>
Message-ID: <Pine.LNX.4.64.0910301439560.4378@axis700.grange>
References: <Pine.LNX.4.64.0910301338140.4378@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
---

As you see in the diffstat, the biggest is the patch for rj54n1cb0c.c, 
which does not only convert it to image-bus, but also adds some 
functionality. It might be better to split that off...

 arch/sh/boards/board-ap325rxa.c            |    4 +-
 arch/sh/boards/mach-kfr2r09/setup.c        |   13 +-
 drivers/media/video/mt9m001.c              |  117 +++---
 drivers/media/video/mt9m111.c              |  139 +++---
 drivers/media/video/mt9t031.c              |   67 ++--
 drivers/media/video/mt9v022.c              |  126 +++---
 drivers/media/video/mx1_camera.c           |   77 +++-
 drivers/media/video/mx3_camera.c           |  270 ++++++-----
 drivers/media/video/ov772x.c               |  177 +++----
 drivers/media/video/ov9640.c               |   62 ++--
 drivers/media/video/pxa_camera.c           |  265 ++++++-----
 drivers/media/video/rj54n1cb0c.c           |  726 +++++++++++++++++++---------
 drivers/media/video/sh_mobile_ceu_camera.c |  335 +++++++------
 drivers/media/video/soc_camera.c           |   72 ++--
 drivers/media/video/soc_camera_platform.c  |   37 +-
 drivers/media/video/tw9910.c               |   91 ++--
 include/media/rj54n1cb0c.h                 |   19 +
 include/media/soc_camera.h                 |   24 +-
 include/media/soc_camera_platform.h        |    2 +-
 19 files changed, 1491 insertions(+), 1132 deletions(-)
 create mode 100644 include/media/rj54n1cb0c.h

diff --git a/arch/sh/boards/board-ap325rxa.c b/arch/sh/boards/board-ap325rxa.c
index a3afe43..30fa8b8 100644
--- a/arch/sh/boards/board-ap325rxa.c
+++ b/arch/sh/boards/board-ap325rxa.c
@@ -317,8 +317,8 @@ static struct soc_camera_platform_info camera_info = {
 	.format_name = "UYVY",
 	.format_depth = 16,
 	.format = {
-		.pixelformat = V4L2_PIX_FMT_UYVY,
-		.colorspace = V4L2_COLORSPACE_SMPTE170M,
+		.code = V4L2_IMGBUS_FMT_UYVY,
+		.field = V4L2_FIELD_NONE,
 		.width = 640,
 		.height = 480,
 	},
diff --git a/arch/sh/boards/mach-kfr2r09/setup.c b/arch/sh/boards/mach-kfr2r09/setup.c
index ce01d6a..18df641 100644
--- a/arch/sh/boards/mach-kfr2r09/setup.c
+++ b/arch/sh/boards/mach-kfr2r09/setup.c
@@ -18,6 +18,7 @@
 #include <linux/input.h>
 #include <linux/i2c.h>
 #include <linux/usb/r8a66597.h>
+#include <media/rj54n1cb0c.h>
 #include <media/soc_camera.h>
 #include <media/sh_mobile_ceu.h>
 #include <video/sh_mobile_lcdc.h>
@@ -254,6 +255,9 @@ static struct i2c_board_info kfr2r09_i2c_camera = {
 
 static struct clk *camera_clk;
 
+/* set VIO_CKO clock to 25MHz */
+#define CEU_MCLK_FREQ 25000000
+
 #define DRVCRB 0xA405018C
 static int camera_power(struct device *dev, int mode)
 {
@@ -266,8 +270,7 @@ static int camera_power(struct device *dev, int mode)
 		if (IS_ERR(camera_clk))
 			return PTR_ERR(camera_clk);
 
-		/* set VIO_CKO clock to 25MHz */
-		rate = clk_round_rate(camera_clk, 25000000);
+		rate = clk_round_rate(camera_clk, CEU_MCLK_FREQ);
 		ret = clk_set_rate(camera_clk, rate);
 		if (ret < 0)
 			goto eclkrate;
@@ -317,11 +320,17 @@ eclkrate:
 	return ret;
 }
 
+static struct rj54n1_pdata rj54n1_priv = {
+	.mclk_freq	= CEU_MCLK_FREQ,
+	.ioctl_high	= false,
+};
+
 static struct soc_camera_link rj54n1_link = {
 	.power		= camera_power,
 	.board_info	= &kfr2r09_i2c_camera,
 	.i2c_adapter_id	= 1,
 	.module_name	= "rj54n1cb0c",
+	.priv		= &rj54n1_priv,
 };
 
 static struct platform_device kfr2r09_camera = {
diff --git a/drivers/media/video/mt9m001.c b/drivers/media/video/mt9m001.c
index cc90660..e1c8578 100644
--- a/drivers/media/video/mt9m001.c
+++ b/drivers/media/video/mt9m001.c
@@ -48,41 +48,27 @@
 #define MT9M001_COLUMN_SKIP		20
 #define MT9M001_ROW_SKIP		12
 
-static const struct soc_camera_data_format mt9m001_colour_formats[] = {
+static const enum v4l2_imgbus_pixelcode mt9m001_colour_codes[] = {
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
+	V4L2_IMGBUS_FMT_SBGGR10,
+	V4L2_IMGBUS_FMT_SBGGR8,
 };
 
-static const struct soc_camera_data_format mt9m001_monochrome_formats[] = {
+static const enum v4l2_imgbus_pixelcode mt9m001_monochrome_codes[] = {
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
+	V4L2_IMGBUS_FMT_Y10,
+	V4L2_IMGBUS_FMT_GREY,
 };
 
 struct mt9m001 {
 	struct v4l2_subdev subdev;
 	struct v4l2_rect rect;	/* Sensor window */
-	__u32 fourcc;
+	enum v4l2_imgbus_pixelcode code;
+	const enum v4l2_imgbus_pixelcode *codes;
+	int num_codes;
 	int model;	/* V4L2_IDENT_MT9M001* codes from v4l2-chip-ident.h */
 	unsigned int gain;
 	unsigned int exposure;
@@ -209,8 +195,7 @@ static int mt9m001_s_crop(struct v4l2_subdev *sd, struct v4l2_crop *a)
 	const u16 hblank = 9, vblank = 25;
 	unsigned int total_h;
 
-	if (mt9m001->fourcc == V4L2_PIX_FMT_SBGGR8 ||
-	    mt9m001->fourcc == V4L2_PIX_FMT_SBGGR16)
+	if (mt9m001->codes == mt9m001_colour_codes)
 		/*
 		 * Bayer format - even number of rows for simplicity,
 		 * but let the user play with the top row.
@@ -290,32 +275,31 @@ static int mt9m001_cropcap(struct v4l2_subdev *sd, struct v4l2_cropcap *a)
 	return 0;
 }
 
-static int mt9m001_g_fmt(struct v4l2_subdev *sd, struct v4l2_format *f)
+static int mt9m001_g_fmt(struct v4l2_subdev *sd,
+			 struct v4l2_imgbus_framefmt *imgf)
 {
 	struct i2c_client *client = sd->priv;
 	struct mt9m001 *mt9m001 = to_mt9m001(client);
-	struct v4l2_pix_format *pix = &f->fmt.pix;
 
-	pix->width		= mt9m001->rect.width;
-	pix->height		= mt9m001->rect.height;
-	pix->pixelformat	= mt9m001->fourcc;
-	pix->field		= V4L2_FIELD_NONE;
-	pix->colorspace		= V4L2_COLORSPACE_SRGB;
+	imgf->width	= mt9m001->rect.width;
+	imgf->height	= mt9m001->rect.height;
+	imgf->code	= mt9m001->code;
+	imgf->field	= V4L2_FIELD_NONE;
 
 	return 0;
 }
 
-static int mt9m001_s_fmt(struct v4l2_subdev *sd, struct v4l2_format *f)
+static int mt9m001_s_fmt(struct v4l2_subdev *sd,
+			 struct v4l2_imgbus_framefmt *imgf)
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
+			.width	= imgf->width,
+			.height	= imgf->height,
 		},
 	};
 	int ret;
@@ -323,28 +307,27 @@ static int mt9m001_s_fmt(struct v4l2_subdev *sd, struct v4l2_format *f)
 	/* No support for scaling so far, just crop. TODO: use skipping */
 	ret = mt9m001_s_crop(sd, &a);
 	if (!ret) {
-		pix->width = mt9m001->rect.width;
-		pix->height = mt9m001->rect.height;
-		mt9m001->fourcc = pix->pixelformat;
+		imgf->width	= mt9m001->rect.width;
+		imgf->height	= mt9m001->rect.height;
+		mt9m001->code	= imgf->code;
 	}
 
 	return ret;
 }
 
-static int mt9m001_try_fmt(struct v4l2_subdev *sd, struct v4l2_format *f)
+static int mt9m001_try_fmt(struct v4l2_subdev *sd,
+			   struct v4l2_imgbus_framefmt *imgf)
 {
 	struct i2c_client *client = sd->priv;
 	struct mt9m001 *mt9m001 = to_mt9m001(client);
-	struct v4l2_pix_format *pix = &f->fmt.pix;
 
-	v4l_bound_align_image(&pix->width, MT9M001_MIN_WIDTH,
+	v4l_bound_align_image(&imgf->width, MT9M001_MIN_WIDTH,
 		MT9M001_MAX_WIDTH, 1,
-		&pix->height, MT9M001_MIN_HEIGHT + mt9m001->y_skip_top,
+		&imgf->height, MT9M001_MIN_HEIGHT + mt9m001->y_skip_top,
 		MT9M001_MAX_HEIGHT + mt9m001->y_skip_top, 0, 0);
 
-	if (pix->pixelformat == V4L2_PIX_FMT_SBGGR8 ||
-	    pix->pixelformat == V4L2_PIX_FMT_SBGGR16)
-		pix->height = ALIGN(pix->height - 1, 2);
+	if (mt9m001->codes == mt9m001_colour_codes)
+		imgf->height = ALIGN(imgf->height - 1, 2);
 
 	return 0;
 }
@@ -608,11 +591,11 @@ static int mt9m001_video_probe(struct soc_camera_device *icd,
 	case 0x8411:
 	case 0x8421:
 		mt9m001->model = V4L2_IDENT_MT9M001C12ST;
-		icd->formats = mt9m001_colour_formats;
+		mt9m001->codes = mt9m001_colour_codes;
 		break;
 	case 0x8431:
 		mt9m001->model = V4L2_IDENT_MT9M001C12STM;
-		icd->formats = mt9m001_monochrome_formats;
+		mt9m001->codes = mt9m001_monochrome_codes;
 		break;
 	default:
 		dev_err(&client->dev,
@@ -620,7 +603,7 @@ static int mt9m001_video_probe(struct soc_camera_device *icd,
 		return -ENODEV;
 	}
 
-	icd->num_formats = 0;
+	mt9m001->num_codes = 0;
 
 	/*
 	 * This is a 10bit sensor, so by default we only allow 10bit.
@@ -633,14 +616,14 @@ static int mt9m001_video_probe(struct soc_camera_device *icd,
 		flags = SOCAM_DATAWIDTH_10;
 
 	if (flags & SOCAM_DATAWIDTH_10)
-		icd->num_formats++;
+		mt9m001->num_codes++;
 	else
-		icd->formats++;
+		mt9m001->codes++;
 
 	if (flags & SOCAM_DATAWIDTH_8)
-		icd->num_formats++;
+		mt9m001->num_codes++;
 
-	mt9m001->fourcc = icd->formats->fourcc;
+	mt9m001->code = mt9m001->codes[0];
 
 	dev_info(&client->dev, "Detected a MT9M001 chip ID %x (%s)\n", data,
 		 data == 0x8431 ? "C12STM" : "C12ST");
@@ -686,14 +669,28 @@ static struct v4l2_subdev_core_ops mt9m001_subdev_core_ops = {
 #endif
 };
 
+static int mt9m001_enum_fmt(struct v4l2_subdev *sd, int index,
+			    enum v4l2_imgbus_pixelcode *code)
+{
+	struct i2c_client *client = sd->priv;
+	struct mt9m001 *mt9m001 = to_mt9m001(client);
+
+	if ((unsigned int)index >= mt9m001->num_codes)
+		return -EINVAL;
+
+	*code = mt9m001->codes[index];
+	return 0;
+}
+
 static struct v4l2_subdev_video_ops mt9m001_subdev_video_ops = {
-	.s_stream	= mt9m001_s_stream,
-	.s_fmt		= mt9m001_s_fmt,
-	.g_fmt		= mt9m001_g_fmt,
-	.try_fmt	= mt9m001_try_fmt,
-	.s_crop		= mt9m001_s_crop,
-	.g_crop		= mt9m001_g_crop,
-	.cropcap	= mt9m001_cropcap,
+	.s_stream		= mt9m001_s_stream,
+	.s_imgbus_fmt		= mt9m001_s_fmt,
+	.g_imgbus_fmt		= mt9m001_g_fmt,
+	.try_imgbus_fmt		= mt9m001_try_fmt,
+	.s_crop			= mt9m001_s_crop,
+	.g_crop			= mt9m001_g_crop,
+	.cropcap		= mt9m001_cropcap,
+	.enum_imgbus_fmt	= mt9m001_enum_fmt,
 };
 
 static struct v4l2_subdev_sensor_ops mt9m001_subdev_sensor_ops = {
diff --git a/drivers/media/video/mt9m111.c b/drivers/media/video/mt9m111.c
index 30db625..b5147e8 100644
--- a/drivers/media/video/mt9m111.c
+++ b/drivers/media/video/mt9m111.c
@@ -131,15 +131,15 @@
 #define JPG_FMT(_name, _depth, _fourcc) \
 	COL_FMT(_name, _depth, _fourcc, V4L2_COLORSPACE_JPEG)
 
-static const struct soc_camera_data_format mt9m111_colour_formats[] = {
-	JPG_FMT("CbYCrY 16 bit", 16, V4L2_PIX_FMT_UYVY),
-	JPG_FMT("CrYCbY 16 bit", 16, V4L2_PIX_FMT_VYUY),
-	JPG_FMT("YCbYCr 16 bit", 16, V4L2_PIX_FMT_YUYV),
-	JPG_FMT("YCrYCb 16 bit", 16, V4L2_PIX_FMT_YVYU),
-	RGB_FMT("RGB 565", 16, V4L2_PIX_FMT_RGB565),
-	RGB_FMT("RGB 555", 16, V4L2_PIX_FMT_RGB555),
-	RGB_FMT("Bayer (sRGB) 10 bit", 10, V4L2_PIX_FMT_SBGGR16),
-	RGB_FMT("Bayer (sRGB) 8 bit", 8, V4L2_PIX_FMT_SBGGR8),
+static const enum v4l2_imgbus_pixelcode mt9m111_colour_codes[] = {
+	V4L2_IMGBUS_FMT_UYVY,
+	V4L2_IMGBUS_FMT_VYUY,
+	V4L2_IMGBUS_FMT_YUYV,
+	V4L2_IMGBUS_FMT_YVYU,
+	V4L2_IMGBUS_FMT_RGB565,
+	V4L2_IMGBUS_FMT_RGB555,
+	V4L2_IMGBUS_FMT_SBGGR10_2X8_PADHI_LE,
+	V4L2_IMGBUS_FMT_SBGGR8,
 };
 
 enum mt9m111_context {
@@ -152,7 +152,7 @@ struct mt9m111 {
 	int model;	/* V4L2_IDENT_MT9M11x* codes from v4l2-chip-ident.h */
 	enum mt9m111_context context;
 	struct v4l2_rect rect;
-	u32 pixfmt;
+	enum v4l2_imgbus_pixelcode code;
 	unsigned int gain;
 	unsigned char autoexposure;
 	unsigned char datawidth;
@@ -258,8 +258,8 @@ static int mt9m111_setup_rect(struct i2c_client *client,
 	int width = rect->width;
 	int height = rect->height;
 
-	if (mt9m111->pixfmt == V4L2_PIX_FMT_SBGGR8 ||
-	    mt9m111->pixfmt == V4L2_PIX_FMT_SBGGR16)
+	if (mt9m111->code == V4L2_IMGBUS_FMT_SBGGR8 ||
+	    mt9m111->code == V4L2_IMGBUS_FMT_SBGGR10_2X8_PADHI_LE)
 		is_raw_format = 1;
 	else
 		is_raw_format = 0;
@@ -307,7 +307,8 @@ static int mt9m111_setup_pixfmt(struct i2c_client *client, u16 outfmt)
 
 static int mt9m111_setfmt_bayer8(struct i2c_client *client)
 {
-	return mt9m111_setup_pixfmt(client, MT9M111_OUTFMT_PROCESSED_BAYER);
+	return mt9m111_setup_pixfmt(client, MT9M111_OUTFMT_PROCESSED_BAYER |
+				    MT9M111_OUTFMT_RGB);
 }
 
 static int mt9m111_setfmt_bayer10(struct i2c_client *client)
@@ -401,8 +402,8 @@ static int mt9m111_make_rect(struct i2c_client *client,
 {
 	struct mt9m111 *mt9m111 = to_mt9m111(client);
 
-	if (mt9m111->pixfmt == V4L2_PIX_FMT_SBGGR8 ||
-	    mt9m111->pixfmt == V4L2_PIX_FMT_SBGGR16) {
+	if (mt9m111->code == V4L2_IMGBUS_FMT_SBGGR8 ||
+	    mt9m111->code == V4L2_IMGBUS_FMT_SBGGR10_2X8_PADHI_LE) {
 		/* Bayer format - even size lengths */
 		rect->width	= ALIGN(rect->width, 2);
 		rect->height	= ALIGN(rect->height, 2);
@@ -460,120 +461,120 @@ static int mt9m111_cropcap(struct v4l2_subdev *sd, struct v4l2_cropcap *a)
 	return 0;
 }
 
-static int mt9m111_g_fmt(struct v4l2_subdev *sd, struct v4l2_format *f)
+static int mt9m111_g_fmt(struct v4l2_subdev *sd,
+			 struct v4l2_imgbus_framefmt *imgf)
 {
 	struct i2c_client *client = sd->priv;
 	struct mt9m111 *mt9m111 = to_mt9m111(client);
-	struct v4l2_pix_format *pix = &f->fmt.pix;
 
-	pix->width		= mt9m111->rect.width;
-	pix->height		= mt9m111->rect.height;
-	pix->pixelformat	= mt9m111->pixfmt;
-	pix->field		= V4L2_FIELD_NONE;
-	pix->colorspace		= V4L2_COLORSPACE_SRGB;
+	imgf->width	= mt9m111->rect.width;
+	imgf->height	= mt9m111->rect.height;
+	imgf->code	= mt9m111->code;
+	imgf->field	= V4L2_FIELD_NONE;
 
 	return 0;
 }
 
-static int mt9m111_set_pixfmt(struct i2c_client *client, u32 pixfmt)
+static int mt9m111_set_pixfmt(struct i2c_client *client,
+			      enum v4l2_imgbus_pixelcode code)
 {
 	struct mt9m111 *mt9m111 = to_mt9m111(client);
 	int ret;
 
-	switch (pixfmt) {
-	case V4L2_PIX_FMT_SBGGR8:
+	switch (code) {
+	case V4L2_IMGBUS_FMT_SBGGR8:
 		ret = mt9m111_setfmt_bayer8(client);
 		break;
-	case V4L2_PIX_FMT_SBGGR16:
+	case V4L2_IMGBUS_FMT_SBGGR10_2X8_PADHI_LE:
 		ret = mt9m111_setfmt_bayer10(client);
 		break;
-	case V4L2_PIX_FMT_RGB555:
+	case V4L2_IMGBUS_FMT_RGB555:
 		ret = mt9m111_setfmt_rgb555(client);
 		break;
-	case V4L2_PIX_FMT_RGB565:
+	case V4L2_IMGBUS_FMT_RGB565:
 		ret = mt9m111_setfmt_rgb565(client);
 		break;
-	case V4L2_PIX_FMT_UYVY:
+	case V4L2_IMGBUS_FMT_UYVY:
 		mt9m111->swap_yuv_y_chromas = 0;
 		mt9m111->swap_yuv_cb_cr = 0;
 		ret = mt9m111_setfmt_yuv(client);
 		break;
-	case V4L2_PIX_FMT_VYUY:
+	case V4L2_IMGBUS_FMT_VYUY:
 		mt9m111->swap_yuv_y_chromas = 0;
 		mt9m111->swap_yuv_cb_cr = 1;
 		ret = mt9m111_setfmt_yuv(client);
 		break;
-	case V4L2_PIX_FMT_YUYV:
+	case V4L2_IMGBUS_FMT_YUYV:
 		mt9m111->swap_yuv_y_chromas = 1;
 		mt9m111->swap_yuv_cb_cr = 0;
 		ret = mt9m111_setfmt_yuv(client);
 		break;
-	case V4L2_PIX_FMT_YVYU:
+	case V4L2_IMGBUS_FMT_YVYU:
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
 
 	if (!ret)
-		mt9m111->pixfmt = pixfmt;
+		mt9m111->code = code;
 
 	return ret;
 }
 
-static int mt9m111_s_fmt(struct v4l2_subdev *sd, struct v4l2_format *f)
+static int mt9m111_s_fmt(struct v4l2_subdev *sd,
+			 struct v4l2_imgbus_framefmt *imgf)
 {
 	struct i2c_client *client = sd->priv;
 	struct mt9m111 *mt9m111 = to_mt9m111(client);
-	struct v4l2_pix_format *pix = &f->fmt.pix;
 	struct v4l2_rect rect = {
 		.left	= mt9m111->rect.left,
 		.top	= mt9m111->rect.top,
-		.width	= pix->width,
-		.height	= pix->height,
+		.width	= imgf->width,
+		.height	= imgf->height,
 	};
 	int ret;
 
 	dev_dbg(&client->dev,
-		"%s fmt=%x left=%d, top=%d, width=%d, height=%d\n", __func__,
-		pix->pixelformat, rect.left, rect.top, rect.width, rect.height);
+		"%s code=%x left=%d, top=%d, width=%d, height=%d\n", __func__,
+		imgf->code, rect.left, rect.top, rect.width, rect.height);
 
 	ret = mt9m111_make_rect(client, &rect);
 	if (!ret)
-		ret = mt9m111_set_pixfmt(client, pix->pixelformat);
+		ret = mt9m111_set_pixfmt(client, imgf->code);
 	if (!ret)
 		mt9m111->rect = rect;
 	return ret;
 }
 
-static int mt9m111_try_fmt(struct v4l2_subdev *sd, struct v4l2_format *f)
+static int mt9m111_try_fmt(struct v4l2_subdev *sd,
+			   struct v4l2_imgbus_framefmt *imgf)
 {
-	struct v4l2_pix_format *pix = &f->fmt.pix;
-	bool bayer = pix->pixelformat == V4L2_PIX_FMT_SBGGR8 ||
-		pix->pixelformat == V4L2_PIX_FMT_SBGGR16;
+	bool bayer = imgf->code == V4L2_IMGBUS_FMT_SBGGR8 ||
+		imgf->code == V4L2_IMGBUS_FMT_SBGGR10_2X8_PADHI_LE;
 
 	/*
 	 * With Bayer format enforce even side lengths, but let the user play
 	 * with the starting pixel
 	 */
 
-	if (pix->height > MT9M111_MAX_HEIGHT)
-		pix->height = MT9M111_MAX_HEIGHT;
-	else if (pix->height < 2)
-		pix->height = 2;
+	if (imgf->height > MT9M111_MAX_HEIGHT)
+		imgf->height = MT9M111_MAX_HEIGHT;
+	else if (imgf->height < 2)
+		imgf->height = 2;
 	else if (bayer)
-		pix->height = ALIGN(pix->height, 2);
+		imgf->height = ALIGN(imgf->height, 2);
 
-	if (pix->width > MT9M111_MAX_WIDTH)
-		pix->width = MT9M111_MAX_WIDTH;
-	else if (pix->width < 2)
-		pix->width = 2;
+	if (imgf->width > MT9M111_MAX_WIDTH)
+		imgf->width = MT9M111_MAX_WIDTH;
+	else if (imgf->width < 2)
+		imgf->width = 2;
 	else if (bayer)
-		pix->width = ALIGN(pix->width, 2);
+		imgf->width = ALIGN(imgf->width, 2);
 
 	return 0;
 }
@@ -863,7 +864,7 @@ static int mt9m111_restore_state(struct i2c_client *client)
 	struct mt9m111 *mt9m111 = to_mt9m111(client);
 
 	mt9m111_set_context(client, mt9m111->context);
-	mt9m111_set_pixfmt(client, mt9m111->pixfmt);
+	mt9m111_set_pixfmt(client, mt9m111->code);
 	mt9m111_setup_rect(client, &mt9m111->rect);
 	mt9m111_set_flip(client, mt9m111->hflip, MT9M111_RMB_MIRROR_COLS);
 	mt9m111_set_flip(client, mt9m111->vflip, MT9M111_RMB_MIRROR_ROWS);
@@ -952,9 +953,6 @@ static int mt9m111_video_probe(struct soc_camera_device *icd,
 		goto ei2c;
 	}
 
-	icd->formats = mt9m111_colour_formats;
-	icd->num_formats = ARRAY_SIZE(mt9m111_colour_formats);
-
 	dev_info(&client->dev, "Detected a MT9M11x chip ID %x\n", data);
 
 ei2c:
@@ -971,13 +969,24 @@ static struct v4l2_subdev_core_ops mt9m111_subdev_core_ops = {
 #endif
 };
 
+static int mt9m111_enum_fmt(struct v4l2_subdev *sd, int index,
+			    enum v4l2_imgbus_pixelcode *code)
+{
+	if ((unsigned int)index >= ARRAY_SIZE(mt9m111_colour_codes))
+		return -EINVAL;
+
+	*code = mt9m111_colour_codes[index];
+	return 0;
+}
+
 static struct v4l2_subdev_video_ops mt9m111_subdev_video_ops = {
-	.s_fmt		= mt9m111_s_fmt,
-	.g_fmt		= mt9m111_g_fmt,
-	.try_fmt	= mt9m111_try_fmt,
-	.s_crop		= mt9m111_s_crop,
-	.g_crop		= mt9m111_g_crop,
-	.cropcap	= mt9m111_cropcap,
+	.s_imgbus_fmt		= mt9m111_s_fmt,
+	.g_imgbus_fmt		= mt9m111_g_fmt,
+	.try_imgbus_fmt		= mt9m111_try_fmt,
+	.s_crop			= mt9m111_s_crop,
+	.g_crop			= mt9m111_g_crop,
+	.cropcap		= mt9m111_cropcap,
+	.enum_imgbus_fmt	= mt9m111_enum_fmt,
 };
 
 static struct v4l2_subdev_ops mt9m111_subdev_ops = {
diff --git a/drivers/media/video/mt9t031.c b/drivers/media/video/mt9t031.c
index 0d2a8fd..c95c277 100644
--- a/drivers/media/video/mt9t031.c
+++ b/drivers/media/video/mt9t031.c
@@ -60,13 +60,8 @@
 	SOCAM_VSYNC_ACTIVE_HIGH | SOCAM_DATA_ACTIVE_HIGH |	\
 	SOCAM_MASTER | SOCAM_DATAWIDTH_10)
 
-static const struct soc_camera_data_format mt9t031_colour_formats[] = {
-	{
-		.name		= "Bayer (sRGB) 10 bit",
-		.depth		= 10,
-		.fourcc		= V4L2_PIX_FMT_SGRBG10,
-		.colorspace	= V4L2_COLORSPACE_SRGB,
-	}
+static const enum v4l2_imgbus_pixelcode mt9t031_code[] = {
+	V4L2_IMGBUS_FMT_SGRBG10,
 };
 
 struct mt9t031 {
@@ -377,27 +372,26 @@ static int mt9t031_cropcap(struct v4l2_subdev *sd, struct v4l2_cropcap *a)
 	return 0;
 }
 
-static int mt9t031_g_fmt(struct v4l2_subdev *sd, struct v4l2_format *f)
+static int mt9t031_g_fmt(struct v4l2_subdev *sd,
+			 struct v4l2_imgbus_framefmt *imgf)
 {
 	struct i2c_client *client = sd->priv;
 	struct mt9t031 *mt9t031 = to_mt9t031(client);
-	struct v4l2_pix_format *pix = &f->fmt.pix;
 
-	pix->width		= mt9t031->rect.width / mt9t031->xskip;
-	pix->height		= mt9t031->rect.height / mt9t031->yskip;
-	pix->pixelformat	= V4L2_PIX_FMT_SGRBG10;
-	pix->field		= V4L2_FIELD_NONE;
-	pix->colorspace		= V4L2_COLORSPACE_SRGB;
+	imgf->width	= mt9t031->rect.width / mt9t031->xskip;
+	imgf->height	= mt9t031->rect.height / mt9t031->yskip;
+	imgf->code	= V4L2_IMGBUS_FMT_SGRBG10;
+	imgf->field	= V4L2_FIELD_NONE;
 
 	return 0;
 }
 
-static int mt9t031_s_fmt(struct v4l2_subdev *sd, struct v4l2_format *f)
+static int mt9t031_s_fmt(struct v4l2_subdev *sd,
+			 struct v4l2_imgbus_framefmt *imgf)
 {
 	struct i2c_client *client = sd->priv;
 	struct mt9t031 *mt9t031 = to_mt9t031(client);
 	struct soc_camera_device *icd = client->dev.platform_data;
-	struct v4l2_pix_format *pix = &f->fmt.pix;
 	u16 xskip, yskip;
 	struct v4l2_rect rect = mt9t031->rect;
 
@@ -405,8 +399,8 @@ static int mt9t031_s_fmt(struct v4l2_subdev *sd, struct v4l2_format *f)
 	 * try_fmt has put width and height within limits.
 	 * S_FMT: use binning and skipping for scaling
 	 */
-	xskip = mt9t031_skip(&rect.width, pix->width, MT9T031_MAX_WIDTH);
-	yskip = mt9t031_skip(&rect.height, pix->height, MT9T031_MAX_HEIGHT);
+	xskip = mt9t031_skip(&rect.width, imgf->width, MT9T031_MAX_WIDTH);
+	yskip = mt9t031_skip(&rect.height, imgf->height, MT9T031_MAX_HEIGHT);
 
 	/* mt9t031_set_params() doesn't change width and height */
 	return mt9t031_set_params(icd, &rect, xskip, yskip);
@@ -416,13 +410,12 @@ static int mt9t031_s_fmt(struct v4l2_subdev *sd, struct v4l2_format *f)
  * If a user window larger than sensor window is requested, we'll increase the
  * sensor window.
  */
-static int mt9t031_try_fmt(struct v4l2_subdev *sd, struct v4l2_format *f)
+static int mt9t031_try_fmt(struct v4l2_subdev *sd,
+			   struct v4l2_imgbus_framefmt *imgf)
 {
-	struct v4l2_pix_format *pix = &f->fmt.pix;
-
 	v4l_bound_align_image(
-		&pix->width, MT9T031_MIN_WIDTH, MT9T031_MAX_WIDTH, 1,
-		&pix->height, MT9T031_MIN_HEIGHT, MT9T031_MAX_HEIGHT, 1, 0);
+		&imgf->width, MT9T031_MIN_WIDTH, MT9T031_MAX_WIDTH, 1,
+		&imgf->height, MT9T031_MIN_HEIGHT, MT9T031_MAX_HEIGHT, 1, 0);
 
 	return 0;
 }
@@ -682,7 +675,6 @@ static int mt9t031_s_ctrl(struct v4l2_subdev *sd, struct v4l2_control *ctrl)
  */
 static int mt9t031_video_probe(struct i2c_client *client)
 {
-	struct soc_camera_device *icd = client->dev.platform_data;
 	struct mt9t031 *mt9t031 = to_mt9t031(client);
 	s32 data;
 	int ret;
@@ -697,8 +689,6 @@ static int mt9t031_video_probe(struct i2c_client *client)
 	switch (data) {
 	case 0x1621:
 		mt9t031->model = V4L2_IDENT_MT9T031;
-		icd->formats = mt9t031_colour_formats;
-		icd->num_formats = ARRAY_SIZE(mt9t031_colour_formats);
 		break;
 	default:
 		dev_err(&client->dev,
@@ -729,14 +719,25 @@ static struct v4l2_subdev_core_ops mt9t031_subdev_core_ops = {
 #endif
 };
 
+static int mt9t031_enum_fmt(struct v4l2_subdev *sd, int index,
+			    enum v4l2_imgbus_pixelcode *code)
+{
+	if ((unsigned int)index >= ARRAY_SIZE(mt9t031_code))
+		return -EINVAL;
+
+	*code = mt9t031_code[index];
+	return 0;
+}
+
 static struct v4l2_subdev_video_ops mt9t031_subdev_video_ops = {
-	.s_stream	= mt9t031_s_stream,
-	.s_fmt		= mt9t031_s_fmt,
-	.g_fmt		= mt9t031_g_fmt,
-	.try_fmt	= mt9t031_try_fmt,
-	.s_crop		= mt9t031_s_crop,
-	.g_crop		= mt9t031_g_crop,
-	.cropcap	= mt9t031_cropcap,
+	.s_stream		= mt9t031_s_stream,
+	.s_imgbus_fmt		= mt9t031_s_fmt,
+	.g_imgbus_fmt		= mt9t031_g_fmt,
+	.try_imgbus_fmt		= mt9t031_try_fmt,
+	.s_crop			= mt9t031_s_crop,
+	.g_crop			= mt9t031_g_crop,
+	.cropcap		= mt9t031_cropcap,
+	.enum_imgbus_fmt	= mt9t031_enum_fmt,
 };
 
 static struct v4l2_subdev_ops mt9t031_subdev_ops = {
diff --git a/drivers/media/video/mt9v022.c b/drivers/media/video/mt9v022.c
index f60a9a1..9fc32d0 100644
--- a/drivers/media/video/mt9v022.c
+++ b/drivers/media/video/mt9v022.c
@@ -64,41 +64,27 @@ MODULE_PARM_DESC(sensor_type, "Sensor type: \"colour\" or \"monochrome\"");
 #define MT9V022_COLUMN_SKIP		1
 #define MT9V022_ROW_SKIP		4
 
-static const struct soc_camera_data_format mt9v022_colour_formats[] = {
+static const enum v4l2_imgbus_pixelcode mt9v022_colour_codes[] = {
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
+	V4L2_IMGBUS_FMT_SBGGR10,
+	V4L2_IMGBUS_FMT_SBGGR8,
 };
 
-static const struct soc_camera_data_format mt9v022_monochrome_formats[] = {
+static const enum v4l2_imgbus_pixelcode mt9v022_monochrome_codes[] = {
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
+	V4L2_IMGBUS_FMT_Y10,
+	V4L2_IMGBUS_FMT_GREY,
 };
 
 struct mt9v022 {
 	struct v4l2_subdev subdev;
 	struct v4l2_rect rect;	/* Sensor window */
-	__u32 fourcc;
+	enum v4l2_imgbus_pixelcode code;
+	const enum v4l2_imgbus_pixelcode *codes;
+	int num_codes;
 	int model;	/* V4L2_IDENT_MT9V022* codes from v4l2-chip-ident.h */
 	u16 chip_control;
 	unsigned short y_skip_top;	/* Lines to skip at the top */
@@ -275,8 +261,7 @@ static int mt9v022_s_crop(struct v4l2_subdev *sd, struct v4l2_crop *a)
 	int ret;
 
 	/* Bayer format - even size lengths */
-	if (mt9v022->fourcc == V4L2_PIX_FMT_SBGGR8 ||
-	    mt9v022->fourcc == V4L2_PIX_FMT_SBGGR16) {
+	if (mt9v022->codes == mt9v022_colour_codes) {
 		rect.width	= ALIGN(rect.width, 2);
 		rect.height	= ALIGN(rect.height, 2);
 		/* Let the user play with the starting pixel */
@@ -354,32 +339,31 @@ static int mt9v022_cropcap(struct v4l2_subdev *sd, struct v4l2_cropcap *a)
 	return 0;
 }
 
-static int mt9v022_g_fmt(struct v4l2_subdev *sd, struct v4l2_format *f)
+static int mt9v022_g_fmt(struct v4l2_subdev *sd,
+			 struct v4l2_imgbus_framefmt *imgf)
 {
 	struct i2c_client *client = sd->priv;
 	struct mt9v022 *mt9v022 = to_mt9v022(client);
-	struct v4l2_pix_format *pix = &f->fmt.pix;
 
-	pix->width		= mt9v022->rect.width;
-	pix->height		= mt9v022->rect.height;
-	pix->pixelformat	= mt9v022->fourcc;
-	pix->field		= V4L2_FIELD_NONE;
-	pix->colorspace		= V4L2_COLORSPACE_SRGB;
+	imgf->width	= mt9v022->rect.width;
+	imgf->height	= mt9v022->rect.height;
+	imgf->code	= mt9v022->code;
+	imgf->field	= V4L2_FIELD_NONE;
 
 	return 0;
 }
 
-static int mt9v022_s_fmt(struct v4l2_subdev *sd, struct v4l2_format *f)
+static int mt9v022_s_fmt(struct v4l2_subdev *sd,
+			 struct v4l2_imgbus_framefmt *imgf)
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
+			.width	= imgf->width,
+			.height	= imgf->height,
 		},
 	};
 	int ret;
@@ -388,14 +372,14 @@ static int mt9v022_s_fmt(struct v4l2_subdev *sd, struct v4l2_format *f)
 	 * The caller provides a supported format, as verified per call to
 	 * icd->try_fmt(), datawidth is from our supported format list
 	 */
-	switch (pix->pixelformat) {
-	case V4L2_PIX_FMT_GREY:
-	case V4L2_PIX_FMT_Y16:
+	switch (imgf->code) {
+	case V4L2_IMGBUS_FMT_GREY:
+	case V4L2_IMGBUS_FMT_Y10:
 		if (mt9v022->model != V4L2_IDENT_MT9V022IX7ATM)
 			return -EINVAL;
 		break;
-	case V4L2_PIX_FMT_SBGGR8:
-	case V4L2_PIX_FMT_SBGGR16:
+	case V4L2_IMGBUS_FMT_SBGGR8:
+	case V4L2_IMGBUS_FMT_SBGGR10:
 		if (mt9v022->model != V4L2_IDENT_MT9V022IX7ATC)
 			return -EINVAL;
 		break;
@@ -409,25 +393,25 @@ static int mt9v022_s_fmt(struct v4l2_subdev *sd, struct v4l2_format *f)
 	/* No support for scaling on this camera, just crop. */
 	ret = mt9v022_s_crop(sd, &a);
 	if (!ret) {
-		pix->width = mt9v022->rect.width;
-		pix->height = mt9v022->rect.height;
-		mt9v022->fourcc = pix->pixelformat;
+		imgf->width	= mt9v022->rect.width;
+		imgf->height	= mt9v022->rect.height;
+		mt9v022->code	= imgf->code;
 	}
 
 	return ret;
 }
 
-static int mt9v022_try_fmt(struct v4l2_subdev *sd, struct v4l2_format *f)
+static int mt9v022_try_fmt(struct v4l2_subdev *sd,
+			   struct v4l2_imgbus_framefmt *imgf)
 {
 	struct i2c_client *client = sd->priv;
 	struct mt9v022 *mt9v022 = to_mt9v022(client);
-	struct v4l2_pix_format *pix = &f->fmt.pix;
-	int align = pix->pixelformat == V4L2_PIX_FMT_SBGGR8 ||
-		pix->pixelformat == V4L2_PIX_FMT_SBGGR16;
+	int align = imgf->code == V4L2_IMGBUS_FMT_SBGGR8 ||
+		imgf->code == V4L2_IMGBUS_FMT_SBGGR10;
 
-	v4l_bound_align_image(&pix->width, MT9V022_MIN_WIDTH,
+	v4l_bound_align_image(&imgf->width, MT9V022_MIN_WIDTH,
 		MT9V022_MAX_WIDTH, align,
-		&pix->height, MT9V022_MIN_HEIGHT + mt9v022->y_skip_top,
+		&imgf->height, MT9V022_MIN_HEIGHT + mt9v022->y_skip_top,
 		MT9V022_MAX_HEIGHT + mt9v022->y_skip_top, align, 0);
 
 	return 0;
@@ -749,17 +733,17 @@ static int mt9v022_video_probe(struct soc_camera_device *icd,
 			    !strcmp("color", sensor_type))) {
 		ret = reg_write(client, MT9V022_PIXEL_OPERATION_MODE, 4 | 0x11);
 		mt9v022->model = V4L2_IDENT_MT9V022IX7ATC;
-		icd->formats = mt9v022_colour_formats;
+		mt9v022->codes = mt9v022_colour_codes;
 	} else {
 		ret = reg_write(client, MT9V022_PIXEL_OPERATION_MODE, 0x11);
 		mt9v022->model = V4L2_IDENT_MT9V022IX7ATM;
-		icd->formats = mt9v022_monochrome_formats;
+		mt9v022->codes = mt9v022_monochrome_codes;
 	}
 
 	if (ret < 0)
 		goto ei2c;
 
-	icd->num_formats = 0;
+	mt9v022->num_codes = 0;
 
 	/*
 	 * This is a 10bit sensor, so by default we only allow 10bit.
@@ -772,14 +756,14 @@ static int mt9v022_video_probe(struct soc_camera_device *icd,
 		flags = SOCAM_DATAWIDTH_10;
 
 	if (flags & SOCAM_DATAWIDTH_10)
-		icd->num_formats++;
+		mt9v022->num_codes++;
 	else
-		icd->formats++;
+		mt9v022->codes++;
 
 	if (flags & SOCAM_DATAWIDTH_8)
-		icd->num_formats++;
+		mt9v022->num_codes++;
 
-	mt9v022->fourcc = icd->formats->fourcc;
+	mt9v022->code = mt9v022->codes[0];
 
 	dev_info(&client->dev, "Detected a MT9V022 chip ID %x, %s sensor\n",
 		 data, mt9v022->model == V4L2_IDENT_MT9V022IX7ATM ?
@@ -823,14 +807,28 @@ static struct v4l2_subdev_core_ops mt9v022_subdev_core_ops = {
 #endif
 };
 
+static int mt9v022_enum_fmt(struct v4l2_subdev *sd, int index,
+			    enum v4l2_imgbus_pixelcode *code)
+{
+	struct i2c_client *client = sd->priv;
+	struct mt9v022 *mt9v022 = to_mt9v022(client);
+
+	if ((unsigned int)index >= mt9v022->num_codes)
+		return -EINVAL;
+
+	*code = mt9v022->codes[index];
+	return 0;
+}
+
 static struct v4l2_subdev_video_ops mt9v022_subdev_video_ops = {
-	.s_stream	= mt9v022_s_stream,
-	.s_fmt		= mt9v022_s_fmt,
-	.g_fmt		= mt9v022_g_fmt,
-	.try_fmt	= mt9v022_try_fmt,
-	.s_crop		= mt9v022_s_crop,
-	.g_crop		= mt9v022_g_crop,
-	.cropcap	= mt9v022_cropcap,
+	.s_stream		= mt9v022_s_stream,
+	.s_imgbus_fmt		= mt9v022_s_fmt,
+	.g_imgbus_fmt		= mt9v022_g_fmt,
+	.try_imgbus_fmt		= mt9v022_try_fmt,
+	.s_crop			= mt9v022_s_crop,
+	.g_crop			= mt9v022_g_crop,
+	.cropcap		= mt9v022_cropcap,
+	.enum_imgbus_fmt	= mt9v022_enum_fmt,
 };
 
 static struct v4l2_subdev_sensor_ops mt9v022_subdev_sensor_ops = {
diff --git a/drivers/media/video/mx1_camera.c b/drivers/media/video/mx1_camera.c
index 659d20a..8e73c77 100644
--- a/drivers/media/video/mx1_camera.c
+++ b/drivers/media/video/mx1_camera.c
@@ -93,9 +93,9 @@
 /* buffer for one video frame */
 struct mx1_buffer {
 	/* common v4l buffer stuff -- must be first */
-	struct videobuf_buffer vb;
-	const struct soc_camera_data_format *fmt;
-	int inwork;
+	struct videobuf_buffer		vb;
+	enum v4l2_imgbus_pixelcode	code;
+	int				inwork;
 };
 
 /*
@@ -127,9 +127,13 @@ static int mx1_videobuf_setup(struct videobuf_queue *vq, unsigned int *count,
 			      unsigned int *size)
 {
 	struct soc_camera_device *icd = vq->priv_data;
+	int bytes_per_line = v4l2_imgbus_bytes_per_line(icd->user_width,
+						icd->current_fmt->host_fmt);
 
-	*size = icd->user_width * icd->user_height *
-		((icd->current_fmt->depth + 7) >> 3);
+	if (bytes_per_line < 0)
+		return bytes_per_line;
+
+	*size = bytes_per_line * icd->user_height;
 
 	if (!*count)
 		*count = 32;
@@ -168,6 +172,11 @@ static int mx1_videobuf_prepare(struct videobuf_queue *vq,
 	struct soc_camera_device *icd = vq->priv_data;
 	struct mx1_buffer *buf = container_of(vb, struct mx1_buffer, vb);
 	int ret;
+	int bytes_per_line = v4l2_imgbus_bytes_per_line(icd->user_width,
+						icd->current_fmt->host_fmt);
+
+	if (bytes_per_line < 0)
+		return bytes_per_line;
 
 	dev_dbg(icd->dev.parent, "%s (vb=0x%p) 0x%08lx %d\n", __func__,
 		vb, vb->baddr, vb->bsize);
@@ -183,18 +192,18 @@ static int mx1_videobuf_prepare(struct videobuf_queue *vq,
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
@@ -496,12 +505,10 @@ static int mx1_camera_set_bus_param(struct soc_camera_device *icd, __u32 pixfmt)
 
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
@@ -554,7 +561,8 @@ static int mx1_camera_set_fmt(struct soc_camera_device *icd,
 	struct v4l2_subdev *sd = soc_camera_to_subdev(icd);
 	const struct soc_camera_format_xlate *xlate;
 	struct v4l2_pix_format *pix = &f->fmt.pix;
-	int ret;
+	struct v4l2_imgbus_framefmt imgf;
+	int ret, buswidth;
 
 	xlate = soc_camera_xlate_by_fourcc(icd, pix->pixelformat);
 	if (!xlate) {
@@ -563,12 +571,28 @@ static int mx1_camera_set_fmt(struct soc_camera_device *icd,
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
 
+	imgf.width	= pix->width;
+	imgf.height	= pix->height;
+	imgf.code	= xlate->code;
+	imgf.field	= pix->field;
+
+	ret = v4l2_subdev_call(sd, video, s_imgbus_fmt, &imgf);
+	if (ret < 0)
+		return ret;
+
+	pix->width		= imgf.width;
+	pix->height		= imgf.height;
+	pix->field		= imgf.field;
+	icd->current_fmt	= xlate;
+
 	return ret;
 }
 
@@ -576,10 +600,29 @@ static int mx1_camera_try_fmt(struct soc_camera_device *icd,
 			      struct v4l2_format *f)
 {
 	struct v4l2_subdev *sd = soc_camera_to_subdev(icd);
+	const struct soc_camera_format_xlate *xlate;
+	struct v4l2_pix_format *pix = &f->fmt.pix;
+	struct v4l2_imgbus_framefmt imgf;
+	int ret;
 	/* TODO: limit to mx1 hardware capabilities */
 
+	xlate = soc_camera_xlate_by_fourcc(icd, pix->pixelformat);
+	if (!xlate) {
+		dev_warn(icd->dev.parent, "Format %x not found\n",
+			 pix->pixelformat);
+		return -EINVAL;
+	}
+
 	/* limit to sensor capabilities */
-	return v4l2_subdev_call(sd, video, try_fmt, f);
+	ret = v4l2_subdev_call(sd, video, try_imgbus_fmt, &imgf);
+	if (ret < 0)
+		return ret;
+
+	pix->width	= imgf.width;
+	pix->height	= imgf.height;
+	pix->field	= imgf.field;
+
+	return 0;
 }
 
 static int mx1_camera_reqbufs(struct soc_camera_file *icf,
diff --git a/drivers/media/video/mx3_camera.c b/drivers/media/video/mx3_camera.c
index 545a430..ab551f1 100644
--- a/drivers/media/video/mx3_camera.c
+++ b/drivers/media/video/mx3_camera.c
@@ -62,7 +62,7 @@
 struct mx3_camera_buffer {
 	/* common v4l buffer stuff -- must be first */
 	struct videobuf_buffer			vb;
-	const struct soc_camera_data_format	*fmt;
+	enum v4l2_imgbus_pixelcode		code;
 
 	/* One descriptot per scatterlist (per frame) */
 	struct dma_async_tx_descriptor		*txd;
@@ -117,8 +117,6 @@ struct dma_chan_request {
 	enum ipu_channel	id;
 };
 
-static int mx3_camera_set_bus_param(struct soc_camera_device *icd, __u32 pixfmt);
-
 static u32 csi_reg_read(struct mx3_camera_dev *mx3, off_t reg)
 {
 	return __raw_readl(mx3->base + reg);
@@ -210,17 +208,16 @@ static int mx3_videobuf_setup(struct videobuf_queue *vq, unsigned int *count,
 	struct soc_camera_device *icd = vq->priv_data;
 	struct soc_camera_host *ici = to_soc_camera_host(icd->dev.parent);
 	struct mx3_camera_dev *mx3_cam = ici->priv;
-	/*
-	 * bits-per-pixel (depth) as specified in camera's pixel format does
-	 * not necessarily match what the camera interface writes to RAM, but
-	 * it should be good enough for now.
-	 */
-	unsigned int bpp = DIV_ROUND_UP(icd->current_fmt->depth, 8);
+	int bytes_per_line = v4l2_imgbus_bytes_per_line(icd->user_width,
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
@@ -240,21 +237,26 @@ static int mx3_videobuf_prepare(struct videobuf_queue *vq,
 	struct mx3_camera_dev *mx3_cam = ici->priv;
 	struct mx3_camera_buffer *buf =
 		container_of(vb, struct mx3_camera_buffer, vb);
-	/* current_fmt _must_ always be set */
-	size_t new_size = icd->user_width * icd->user_height *
-		((icd->current_fmt->depth + 7) >> 3);
+	size_t new_size;
 	int ret;
+	int bytes_per_line = v4l2_imgbus_bytes_per_line(icd->user_width,
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
@@ -347,13 +349,13 @@ static void mx3_videobuf_queue(struct videobuf_queue *vq,
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
@@ -567,28 +569,33 @@ static int test_platform_param(struct mx3_camera_dev *mx3_cam,
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
@@ -637,91 +644,95 @@ static bool chan_filter(struct dma_chan *chan, void *arg)
 		pdata->dma_dev == chan->device->dev;
 }
 
-static const struct soc_camera_data_format mx3_camera_formats[] = {
+static const struct v4l2_imgbus_pixelfmt mx3_camera_formats[] = {
 	{
-		.name		= "Bayer (sRGB) 8 bit",
-		.depth		= 8,
-		.fourcc		= V4L2_PIX_FMT_SBGGR8,
-		.colorspace	= V4L2_COLORSPACE_SRGB,
+		.fourcc			= V4L2_PIX_FMT_SBGGR8,
+		.colorspace		= V4L2_COLORSPACE_SRGB,
+		.name			= "Bayer (sRGB) 8 bit",
+		.bits_per_sample	= 8,
+		.packing		= V4L2_IMGBUS_PACKING_NONE,
+		.order			= V4L2_IMGBUS_ORDER_LE,
 	}, {
-		.name		= "Monochrome 8 bit",
-		.depth		= 8,
-		.fourcc		= V4L2_PIX_FMT_GREY,
-		.colorspace	= V4L2_COLORSPACE_JPEG,
+		.fourcc			= V4L2_PIX_FMT_GREY,
+		.colorspace		= V4L2_COLORSPACE_JPEG,
+		.name			= "Monochrome 8 bit",
+		.bits_per_sample	= 8,
+		.packing		= V4L2_IMGBUS_PACKING_NONE,
+		.order			= V4L2_IMGBUS_ORDER_LE,
 	},
 };
 
-static bool buswidth_supported(struct soc_camera_host *ici, int depth)
+/* This will be corrected as we get more formats */
+static bool mx3_camera_packing_supported(const struct v4l2_imgbus_pixelfmt *fmt)
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
+	return	fmt->packing == V4L2_IMGBUS_PACKING_NONE ||
+		(fmt->bits_per_sample == 8 &&
+		 fmt->packing == V4L2_IMGBUS_PACKING_2X8) ||
+		(fmt->bits_per_sample > 8 &&
+		 fmt->packing == V4L2_IMGBUS_PACKING_EXTEND16);
 }
 
 static int mx3_camera_get_formats(struct soc_camera_device *icd, int idx,
 				  struct soc_camera_format_xlate *xlate)
 {
+	struct v4l2_subdev *sd = soc_camera_to_subdev(icd);
+	struct device *dev = icd->dev.parent;
 	struct soc_camera_host *ici = to_soc_camera_host(icd->dev.parent);
-	int formats = 0, buswidth, ret;
+	int formats = 0, ret;
+	enum v4l2_imgbus_pixelcode code;
+	const struct v4l2_imgbus_pixelfmt *fmt;
 
-	buswidth = icd->formats[idx].depth;
+	ret = v4l2_subdev_call(sd, video, enum_imgbus_fmt, idx, &code);
+	if (ret < 0)
+		/* No more formats */
+		return 0;
 
-	if (!buswidth_supported(ici, buswidth))
+	fmt = v4l2_imgbus_get_fmtdesc(code);
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
+	case V4L2_IMGBUS_FMT_SGRBG10:
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
+	case V4L2_IMGBUS_FMT_Y10:
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
@@ -805,8 +816,7 @@ static int mx3_camera_set_crop(struct soc_camera_device *icd,
 	struct soc_camera_host *ici = to_soc_camera_host(icd->dev.parent);
 	struct mx3_camera_dev *mx3_cam = ici->priv;
 	struct v4l2_subdev *sd = soc_camera_to_subdev(icd);
-	struct v4l2_format f = {.type = V4L2_BUF_TYPE_VIDEO_CAPTURE};
-	struct v4l2_pix_format *pix = &f.fmt.pix;
+	struct v4l2_imgbus_framefmt imgf;
 	int ret;
 
 	soc_camera_limit_side(&rect->left, &rect->width, 0, 2, 4096);
@@ -817,19 +827,19 @@ static int mx3_camera_set_crop(struct soc_camera_device *icd,
 		return ret;
 
 	/* The capture device might have changed its output  */
-	ret = v4l2_subdev_call(sd, video, g_fmt, &f);
+	ret = v4l2_subdev_call(sd, video, g_imgbus_fmt, &imgf);
 	if (ret < 0)
 		return ret;
 
-	if (pix->width & 7) {
+	if (imgf.width & 7) {
 		/* Ouch! We can only handle 8-byte aligned width... */
-		stride_align(&pix->width);
-		ret = v4l2_subdev_call(sd, video, s_fmt, &f);
+		stride_align(&imgf.width);
+		ret = v4l2_subdev_call(sd, video, s_imgbus_fmt, &imgf);
 		if (ret < 0)
 			return ret;
 	}
 
-	if (pix->width != icd->user_width || pix->height != icd->user_height) {
+	if (imgf.width != icd->user_width || imgf.height != icd->user_height) {
 		/*
 		 * We now know pixel formats and can decide upon DMA-channel(s)
 		 * So far only direct camera-to-memory is supported
@@ -840,14 +850,14 @@ static int mx3_camera_set_crop(struct soc_camera_device *icd,
 				return ret;
 		}
 
-		configure_geometry(mx3_cam, pix->width, pix->height);
+		configure_geometry(mx3_cam, imgf.width, imgf.height);
 	}
 
 	dev_dbg(icd->dev.parent, "Sensor cropped %dx%d\n",
-		pix->width, pix->height);
+		imgf.width, imgf.height);
 
-	icd->user_width = pix->width;
-	icd->user_height = pix->height;
+	icd->user_width		= imgf.width;
+	icd->user_height	= imgf.height;
 
 	return ret;
 }
@@ -860,6 +870,7 @@ static int mx3_camera_set_fmt(struct soc_camera_device *icd,
 	struct v4l2_subdev *sd = soc_camera_to_subdev(icd);
 	const struct soc_camera_format_xlate *xlate;
 	struct v4l2_pix_format *pix = &f->fmt.pix;
+	struct v4l2_imgbus_framefmt imgf;
 	int ret;
 
 	xlate = soc_camera_xlate_by_fourcc(icd, pix->pixelformat);
@@ -884,11 +895,19 @@ static int mx3_camera_set_fmt(struct soc_camera_device *icd,
 
 	configure_geometry(mx3_cam, pix->width, pix->height);
 
-	ret = v4l2_subdev_call(sd, video, s_fmt, f);
-	if (!ret) {
-		icd->buswidth = xlate->buswidth;
-		icd->current_fmt = xlate->host_fmt;
-	}
+	imgf.width	= pix->width;
+	imgf.height	= pix->height;
+	imgf.code	= xlate->code;
+	imgf.field	= pix->field;
+
+	ret = v4l2_subdev_call(sd, video, s_imgbus_fmt, &imgf);
+	if (ret < 0)
+		return ret;
+
+	pix->width		= imgf.width;
+	pix->height		= imgf.height;
+	pix->field		= imgf.field;
+	icd->current_fmt	= xlate;
 
 	dev_dbg(icd->dev.parent, "Sensor set %dx%d\n", pix->width, pix->height);
 
@@ -901,8 +920,8 @@ static int mx3_camera_try_fmt(struct soc_camera_device *icd,
 	struct v4l2_subdev *sd = soc_camera_to_subdev(icd);
 	const struct soc_camera_format_xlate *xlate;
 	struct v4l2_pix_format *pix = &f->fmt.pix;
+	struct v4l2_imgbus_framefmt imgf;
 	__u32 pixfmt = pix->pixelformat;
-	enum v4l2_field field;
 	int ret;
 
 	xlate = soc_camera_xlate_by_fourcc(icd, pixfmt);
@@ -917,23 +936,34 @@ static int mx3_camera_try_fmt(struct soc_camera_device *icd,
 	if (pix->width > 4096)
 		pix->width = 4096;
 
-	pix->bytesperline = pix->width *
-		DIV_ROUND_UP(xlate->host_fmt->depth, 8);
+	pix->bytesperline = v4l2_imgbus_bytes_per_line(pix->width,
+						       xlate->host_fmt);
+	if (pix->bytesperline < 0)
+		return pix->bytesperline;
 	pix->sizeimage = pix->height * pix->bytesperline;
 
-	/* camera has to see its format, but the user the original one */
-	pix->pixelformat = xlate->cam_fmt->fourcc;
 	/* limit to sensor capabilities */
-	ret = v4l2_subdev_call(sd, video, try_fmt, f);
-	pix->pixelformat = xlate->host_fmt->fourcc;
+	imgf.width	= pix->width;
+	imgf.height	= pix->height;
+	imgf.field	= pix->field;
+	imgf.code	= xlate->code;
+	ret = v4l2_subdev_call(sd, video, try_imgbus_fmt, &imgf);
+	if (ret < 0)
+		return ret;
 
-	field = pix->field;
+	pix->width	= imgf.width;
+	pix->height	= imgf.height;
 
-	if (field == V4L2_FIELD_ANY) {
+	switch (imgf.field) {
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
+			imgf.field);
+		ret = -EINVAL;
 	}
 
 	return ret;
@@ -969,18 +999,26 @@ static int mx3_camera_set_bus_param(struct soc_camera_device *icd, __u32 pixfmt)
 	struct mx3_camera_dev *mx3_cam = ici->priv;
 	unsigned long bus_flags, camera_flags, common_flags;
 	u32 dw, sens_conf;
-	int ret = test_platform_param(mx3_cam, icd->buswidth, &bus_flags);
+	const struct v4l2_imgbus_pixelfmt *fmt;
+	int buswidth;
+	int ret;
 	const struct soc_camera_format_xlate *xlate;
 	struct device *dev = icd->dev.parent;
 
+	fmt = v4l2_imgbus_get_fmtdesc(icd->current_fmt->code);
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
@@ -1081,7 +1119,7 @@ static int mx3_camera_set_bus_param(struct soc_camera_device *icd, __u32 pixfmt)
 		sens_conf |= 1 << CSI_SENS_CONF_DATA_POL_SHIFT;
 
 	/* Just do what we're asked to do */
-	switch (xlate->host_fmt->depth) {
+	switch (xlate->host_fmt->bits_per_sample) {
 	case 4:
 		dw = 0 << CSI_SENS_CONF_DATA_WIDTH_SHIFT;
 		break;
diff --git a/drivers/media/video/ov772x.c b/drivers/media/video/ov772x.c
index dbaf508..f969011 100644
--- a/drivers/media/video/ov772x.c
+++ b/drivers/media/video/ov772x.c
@@ -382,7 +382,7 @@ struct regval_list {
 };
 
 struct ov772x_color_format {
-	const struct soc_camera_data_format *format;
+	const enum v4l2_imgbus_pixelcode code;
 	u8 dsp3;
 	u8 com3;
 	u8 com7;
@@ -434,93 +434,50 @@ static const struct regval_list ov772x_vga_regs[] = {
 };
 
 /*
- * supported format list
- */
-
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
-};
-
-/*
- * color format list
+ * supported color format list
  */
 static const struct ov772x_color_format ov772x_cfmts[] = {
 	{
-		.format = &ov772x_fmt_lists[0],
-		.dsp3   = 0x0,
-		.com3   = SWAP_YUV,
-		.com7   = OFMT_YUV,
+		.code	= V4L2_IMGBUS_FMT_YUYV,
+		.dsp3	= 0x0,
+		.com3	= SWAP_YUV,
+		.com7	= OFMT_YUV,
 	},
 	{
-		.format = &ov772x_fmt_lists[1],
-		.dsp3   = UV_ON,
-		.com3   = SWAP_YUV,
-		.com7   = OFMT_YUV,
+		.code	= V4L2_IMGBUS_FMT_YVYU,
+		.dsp3	= UV_ON,
+		.com3	= SWAP_YUV,
+		.com7	= OFMT_YUV,
 	},
 	{
-		.format = &ov772x_fmt_lists[2],
-		.dsp3   = 0x0,
-		.com3   = 0x0,
-		.com7   = OFMT_YUV,
+		.code	= V4L2_IMGBUS_FMT_UYVY,
+		.dsp3	= 0x0,
+		.com3	= 0x0,
+		.com7	= OFMT_YUV,
 	},
 	{
-		.format = &ov772x_fmt_lists[3],
-		.dsp3   = 0x0,
-		.com3   = SWAP_RGB,
-		.com7   = FMT_RGB555 | OFMT_RGB,
+		.code	= V4L2_IMGBUS_FMT_RGB555,
+		.dsp3	= 0x0,
+		.com3	= SWAP_RGB,
+		.com7	= FMT_RGB555 | OFMT_RGB,
 	},
 	{
-		.format = &ov772x_fmt_lists[4],
-		.dsp3   = 0x0,
-		.com3   = 0x0,
-		.com7   = FMT_RGB555 | OFMT_RGB,
+		.code	= V4L2_IMGBUS_FMT_RGB555X,
+		.dsp3	= 0x0,
+		.com3	= 0x0,
+		.com7	= FMT_RGB555 | OFMT_RGB,
 	},
 	{
-		.format = &ov772x_fmt_lists[5],
-		.dsp3   = 0x0,
-		.com3   = SWAP_RGB,
-		.com7   = FMT_RGB565 | OFMT_RGB,
+		.code	= V4L2_IMGBUS_FMT_RGB565,
+		.dsp3	= 0x0,
+		.com3	= SWAP_RGB,
+		.com7	= FMT_RGB565 | OFMT_RGB,
 	},
 	{
-		.format = &ov772x_fmt_lists[6],
-		.dsp3   = 0x0,
-		.com3   = 0x0,
-		.com7   = FMT_RGB565 | OFMT_RGB,
+		.code	= V4L2_IMGBUS_FMT_RGB565X,
+		.dsp3	= 0x0,
+		.com3	= 0x0,
+		.com7	= FMT_RGB565 | OFMT_RGB,
 	},
 };
 
@@ -649,8 +606,8 @@ static int ov772x_s_stream(struct v4l2_subdev *sd, int enable)
 
 	ov772x_mask_set(client, COM2, SOFT_SLEEP_MODE, 0);
 
-	dev_dbg(&client->dev, "format %s, win %s\n",
-		priv->fmt->format->name, priv->win->name);
+	dev_dbg(&client->dev, "format %d, win %s\n",
+		priv->fmt->code, priv->win->name);
 
 	return 0;
 }
@@ -806,8 +763,8 @@ static const struct ov772x_win_size *ov772x_select_win(u32 width, u32 height)
 	return win;
 }
 
-static int ov772x_set_params(struct i2c_client *client,
-			     u32 *width, u32 *height, u32 pixfmt)
+static int ov772x_set_params(struct i2c_client *client, u32 *width, u32 *height,
+			     enum v4l2_imgbus_pixelcode code)
 {
 	struct ov772x_priv *priv = to_ov772x(client);
 	int ret = -EINVAL;
@@ -819,7 +776,7 @@ static int ov772x_set_params(struct i2c_client *client,
 	 */
 	priv->fmt = NULL;
 	for (i = 0; i < ARRAY_SIZE(ov772x_cfmts); i++) {
-		if (pixfmt == ov772x_cfmts[i].format->fourcc) {
+		if (code == ov772x_cfmts[i].code) {
 			priv->fmt = ov772x_cfmts + i;
 			break;
 		}
@@ -925,7 +882,7 @@ static int ov772x_set_params(struct i2c_client *client,
 	 */
 	val = priv->win->com7_bit | priv->fmt->com7;
 	ret = ov772x_mask_set(client,
-			      COM7, (SLCT_MASK | FMT_MASK | OFMT_MASK),
+			      COM7, SLCT_MASK | FMT_MASK | OFMT_MASK,
 			      val);
 	if (ret < 0)
 		goto ov772x_set_fmt_error;
@@ -981,54 +938,50 @@ static int ov772x_cropcap(struct v4l2_subdev *sd, struct v4l2_cropcap *a)
 	return 0;
 }
 
-static int ov772x_g_fmt(struct v4l2_subdev *sd, struct v4l2_format *f)
+static int ov772x_g_fmt(struct v4l2_subdev *sd,
+			struct v4l2_imgbus_framefmt *imgf)
 {
 	struct i2c_client *client = sd->priv;
 	struct ov772x_priv *priv = to_ov772x(client);
-	struct v4l2_pix_format *pix = &f->fmt.pix;
 
 	if (!priv->win || !priv->fmt) {
 		u32 width = VGA_WIDTH, height = VGA_HEIGHT;
 		int ret = ov772x_set_params(client, &width, &height,
-					    V4L2_PIX_FMT_YUYV);
+					    V4L2_IMGBUS_FMT_YUYV);
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
+	imgf->width	= priv->win->width;
+	imgf->height	= priv->win->height;
+	imgf->code	= priv->fmt->code;
+	imgf->field	= V4L2_FIELD_NONE;
 
 	return 0;
 }
 
-static int ov772x_s_fmt(struct v4l2_subdev *sd, struct v4l2_format *f)
+static int ov772x_s_fmt(struct v4l2_subdev *sd,
+			struct v4l2_imgbus_framefmt *imgf)
 {
 	struct i2c_client *client = sd->priv;
-	struct v4l2_pix_format *pix = &f->fmt.pix;
 
-	return ov772x_set_params(client, &pix->width, &pix->height,
-				 pix->pixelformat);
+	return ov772x_set_params(client, &imgf->width, &imgf->height,
+				 imgf->code);
 }
 
 static int ov772x_try_fmt(struct v4l2_subdev *sd,
-			  struct v4l2_format *f)
+			  struct v4l2_imgbus_framefmt *imgf)
 {
-	struct v4l2_pix_format *pix = &f->fmt.pix;
 	const struct ov772x_win_size *win;
 
 	/*
 	 * select suitable win
 	 */
-	win = ov772x_select_win(pix->width, pix->height);
+	win = ov772x_select_win(imgf->width, imgf->height);
 
-	pix->width  = win->width;
-	pix->height = win->height;
-	pix->field  = V4L2_FIELD_NONE;
+	imgf->width  = win->width;
+	imgf->height = win->height;
+	imgf->field  = V4L2_FIELD_NONE;
 
 	return 0;
 }
@@ -1057,9 +1010,6 @@ static int ov772x_video_probe(struct soc_camera_device *icd,
 		return -ENODEV;
 	}
 
-	icd->formats     = ov772x_fmt_lists;
-	icd->num_formats = ARRAY_SIZE(ov772x_fmt_lists);
-
 	/*
 	 * check and show product ID and manufacturer ID
 	 */
@@ -1109,13 +1059,24 @@ static struct v4l2_subdev_core_ops ov772x_subdev_core_ops = {
 #endif
 };
 
+static int ov772x_enum_fmt(struct v4l2_subdev *sd, int index,
+			   enum v4l2_imgbus_pixelcode *code)
+{
+	if ((unsigned int)index >= ARRAY_SIZE(ov772x_cfmts))
+		return -EINVAL;
+
+	*code = ov772x_cfmts[index].code;
+	return 0;
+}
+
 static struct v4l2_subdev_video_ops ov772x_subdev_video_ops = {
-	.s_stream	= ov772x_s_stream,
-	.g_fmt		= ov772x_g_fmt,
-	.s_fmt		= ov772x_s_fmt,
-	.try_fmt	= ov772x_try_fmt,
-	.cropcap	= ov772x_cropcap,
-	.g_crop		= ov772x_g_crop,
+	.s_stream		= ov772x_s_stream,
+	.g_imgbus_fmt		= ov772x_g_fmt,
+	.s_imgbus_fmt		= ov772x_s_fmt,
+	.try_imgbus_fmt		= ov772x_try_fmt,
+	.cropcap		= ov772x_cropcap,
+	.g_crop			= ov772x_g_crop,
+	.enum_imgbus_fmt	= ov772x_enum_fmt,
 };
 
 static struct v4l2_subdev_ops ov772x_subdev_ops = {
diff --git a/drivers/media/video/ov9640.c b/drivers/media/video/ov9640.c
index c81ae21..b63d921 100644
--- a/drivers/media/video/ov9640.c
+++ b/drivers/media/video/ov9640.c
@@ -160,13 +160,8 @@ static const struct ov9640_reg ov9640_regs_rgb[] = {
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
+static const enum v4l2_imgbus_pixelcode ov9640_fmt_codes[] = {
+	V4L2_IMGBUS_FMT_UYVY,
 };
 
 static const struct v4l2_queryctrl ov9640_controls[] = {
@@ -434,20 +429,22 @@ static void ov9640_res_roundup(u32 *width, u32 *height)
 }
 
 /* Prepare necessary register changes depending on color encoding */
-static void ov9640_alter_regs(u32 pixfmt, struct ov9640_reg_alt *alt)
+static void ov9640_alter_regs(enum v4l2_imgbus_pixelcode code,
+			      struct ov9640_reg_alt *alt)
 {
-	switch (pixfmt) {
-	case V4L2_PIX_FMT_UYVY:
+	switch (code) {
+	default:
+	case V4L2_IMGBUS_FMT_UYVY:
 		alt->com12	= OV9640_COM12_YUV_AVG;
 		alt->com13	= OV9640_COM13_Y_DELAY_EN |
 					OV9640_COM13_YUV_DLY(0x01);
 		break;
-	case V4L2_PIX_FMT_RGB555:
+	case V4L2_IMGBUS_FMT_RGB555:
 		alt->com7	= OV9640_COM7_RGB;
 		alt->com13	= OV9640_COM13_RGB_AVG;
 		alt->com15	= OV9640_COM15_RGB_555;
 		break;
-	case V4L2_PIX_FMT_RGB565:
+	case V4L2_IMGBUS_FMT_RGB565:
 		alt->com7	= OV9640_COM7_RGB;
 		alt->com13	= OV9640_COM13_RGB_AVG;
 		alt->com15	= OV9640_COM15_RGB_565;
@@ -456,8 +453,8 @@ static void ov9640_alter_regs(u32 pixfmt, struct ov9640_reg_alt *alt)
 }
 
 /* Setup registers according to resolution and color encoding */
-static int ov9640_write_regs(struct i2c_client *client,
-		u32 width, u32 pixfmt, struct ov9640_reg_alt *alts)
+static int ov9640_write_regs(struct i2c_client *client, u32 width,
+		enum v4l2_imgbus_pixelcode code, struct ov9640_reg_alt *alts)
 {
 	const struct ov9640_reg	*ov9640_regs, *matrix_regs;
 	int			ov9640_regs_len, matrix_regs_len;
@@ -500,7 +497,7 @@ static int ov9640_write_regs(struct i2c_client *client,
 	}
 
 	/* select color matrix configuration for given color encoding */
-	if (pixfmt == V4L2_PIX_FMT_UYVY) {
+	if (code == V4L2_IMGBUS_FMT_UYVY) {
 		matrix_regs	= ov9640_regs_yuv;
 		matrix_regs_len	= ARRAY_SIZE(ov9640_regs_yuv);
 	} else {
@@ -562,15 +559,15 @@ static int ov9640_prog_dflt(struct i2c_client *client)
 }
 
 /* set the format we will capture in */
-static int ov9640_s_fmt(struct v4l2_subdev *sd, struct v4l2_format *f)
+static int ov9640_s_fmt(struct v4l2_subdev *sd,
+			struct v4l2_imgbus_framefmt *imgf)
 {
 	struct i2c_client *client = sd->priv;
-	struct v4l2_pix_format *pix = &f->fmt.pix;
 	struct ov9640_reg_alt alts = {0};
 	int ret;
 
-	ov9640_res_roundup(&pix->width, &pix->height);
-	ov9640_alter_regs(pix->pixelformat, &alts);
+	ov9640_res_roundup(&imgf->width, &imgf->height);
+	ov9640_alter_regs(imgf->code, &alts);
 
 	ov9640_reset(client);
 
@@ -578,16 +575,25 @@ static int ov9640_s_fmt(struct v4l2_subdev *sd, struct v4l2_format *f)
 	if (ret)
 		return ret;
 
-	return ov9640_write_regs(client, pix->width, pix->pixelformat, &alts);
+	return ov9640_write_regs(client, imgf->width, imgf->code, &alts);
 }
 
-static int ov9640_try_fmt(struct v4l2_subdev *sd, struct v4l2_format *f)
+static int ov9640_try_fmt(struct v4l2_subdev *sd,
+			  struct v4l2_imgbus_framefmt *imgf)
 {
-	struct v4l2_pix_format *pix = &f->fmt.pix;
+	ov9640_res_roundup(&imgf->width, &imgf->height);
+	imgf->field  = V4L2_FIELD_NONE;
 
-	ov9640_res_roundup(&pix->width, &pix->height);
-	pix->field  = V4L2_FIELD_NONE;
+	return 0;
+}
 
+static int ov9640_enum_fmt(struct v4l2_subdev *sd, int index,
+			   enum v4l2_imgbus_pixelcode *code)
+{
+	if ((unsigned int)index >= ARRAY_SIZE(ov9640_fmt_codes))
+		return -EINVAL;
+
+	*code = ov9640_fmt_codes[index];
 	return 0;
 }
 
@@ -637,9 +643,6 @@ static int ov9640_video_probe(struct soc_camera_device *icd,
 		goto err;
 	}
 
-	icd->formats		= ov9640_fmt_lists;
-	icd->num_formats	= ARRAY_SIZE(ov9640_fmt_lists);
-
 	/*
 	 * check and show product ID and manufacturer ID
 	 */
@@ -703,8 +706,9 @@ static struct v4l2_subdev_core_ops ov9640_core_ops = {
 
 static struct v4l2_subdev_video_ops ov9640_video_ops = {
 	.s_stream		= ov9640_s_stream,
-	.s_fmt			= ov9640_s_fmt,
-	.try_fmt		= ov9640_try_fmt,
+	.s_imgbus_fmt		= ov9640_s_fmt,
+	.try_imgbus_fmt		= ov9640_try_fmt,
+	.enum_imgbus_fmt	= ov9640_enum_fmt,
 	.cropcap		= ov9640_cropcap,
 	.g_crop			= ov9640_g_crop,
 
diff --git a/drivers/media/video/pxa_camera.c b/drivers/media/video/pxa_camera.c
index f063f59..8dece33 100644
--- a/drivers/media/video/pxa_camera.c
+++ b/drivers/media/video/pxa_camera.c
@@ -183,16 +183,12 @@ struct pxa_cam_dma {
 /* buffer for one video frame */
 struct pxa_buffer {
 	/* common v4l buffer stuff -- must be first */
-	struct videobuf_buffer vb;
-
-	const struct soc_camera_data_format        *fmt;
-
+	struct videobuf_buffer		vb;
+	enum v4l2_imgbus_pixelcode	code;
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
@@ -243,11 +239,15 @@ static int pxa_videobuf_setup(struct videobuf_queue *vq, unsigned int *count,
 			      unsigned int *size)
 {
 	struct soc_camera_device *icd = vq->priv_data;
+	int bytes_per_line = v4l2_imgbus_bytes_per_line(icd->user_width,
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
@@ -433,6 +433,11 @@ static int pxa_videobuf_prepare(struct videobuf_queue *vq,
 	struct pxa_buffer *buf = container_of(vb, struct pxa_buffer, vb);
 	int ret;
 	int size_y, size_u = 0, size_v = 0;
+	int bytes_per_line = v4l2_imgbus_bytes_per_line(icd->user_width,
+						icd->current_fmt->host_fmt);
+
+	if (bytes_per_line < 0)
+		return bytes_per_line;
 
 	dev_dbg(dev, "%s (vb=0x%p) 0x%08lx %d\n", __func__,
 		vb, vb->baddr, vb->bsize);
@@ -456,18 +461,18 @@ static int pxa_videobuf_prepare(struct videobuf_queue *vq,
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
@@ -1157,9 +1162,15 @@ static int pxa_camera_set_bus_param(struct soc_camera_device *icd, __u32 pixfmt)
 	struct soc_camera_host *ici = to_soc_camera_host(icd->dev.parent);
 	struct pxa_camera_dev *pcdev = ici->priv;
 	unsigned long bus_flags, camera_flags, common_flags;
-	int ret = test_platform_param(pcdev, icd->buswidth, &bus_flags);
+	const struct v4l2_imgbus_pixelfmt *fmt;
+	int ret;
 	struct pxa_cam *cam = icd->host_priv;
 
+	fmt = v4l2_imgbus_get_fmtdesc(icd->current_fmt->code);
+	if (!fmt)
+		return -EINVAL;
+
+	ret = test_platform_param(pcdev, fmt->bits_per_sample, &bus_flags);
 	if (ret < 0)
 		return ret;
 
@@ -1223,59 +1234,50 @@ static int pxa_camera_try_bus_param(struct soc_camera_device *icd,
 	return soc_camera_bus_param_compatible(camera_flags, bus_flags) ? 0 : -EINVAL;
 }
 
-static const struct soc_camera_data_format pxa_camera_formats[] = {
+static const struct v4l2_imgbus_pixelfmt pxa_camera_formats[] = {
 	{
-		.name		= "Planar YUV422 16 bit",
-		.depth		= 16,
-		.fourcc		= V4L2_PIX_FMT_YUV422P,
-		.colorspace	= V4L2_COLORSPACE_JPEG,
+		.fourcc			= V4L2_PIX_FMT_YUV422P,
+		.colorspace		= V4L2_COLORSPACE_JPEG,
+		.name			= "Planar YUV422 16 bit",
+		.bits_per_sample	= 8,
+		.packing		= V4L2_IMGBUS_PACKING_2X8,
+		.order			= V4L2_IMGBUS_ORDER_LE,
 	},
 };
 
-static bool buswidth_supported(struct soc_camera_device *icd, int depth)
-{
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
+/* This will be corrected as we get more formats */
+static bool pxa_camera_packing_supported(const struct v4l2_imgbus_pixelfmt *fmt)
 {
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
+	return	fmt->packing == V4L2_IMGBUS_PACKING_NONE ||
+		(fmt->bits_per_sample == 8 &&
+		 fmt->packing == V4L2_IMGBUS_PACKING_2X8) ||
+		(fmt->bits_per_sample > 8 &&
+		 fmt->packing == V4L2_IMGBUS_PACKING_EXTEND16);
 }
 
 static int pxa_camera_get_formats(struct soc_camera_device *icd, int idx,
 				  struct soc_camera_format_xlate *xlate)
 {
+	struct v4l2_subdev *sd = soc_camera_to_subdev(icd);
 	struct device *dev = icd->dev.parent;
-	int formats = 0, buswidth, ret;
+	int formats = 0, ret;
 	struct pxa_cam *cam;
+	enum v4l2_imgbus_pixelcode code;
+	const struct v4l2_imgbus_pixelfmt *fmt;
 
-	buswidth = required_buswidth(icd->formats + idx);
+	ret = v4l2_subdev_call(sd, video, enum_imgbus_fmt, idx, &code);
+	if (ret < 0)
+		/* No more formats */
+		return 0;
 
-	if (!buswidth_supported(icd, buswidth))
+	fmt = v4l2_imgbus_get_fmtdesc(code);
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
+	case V4L2_IMGBUS_FMT_UYVY:
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
+	case V4L2_IMGBUS_FMT_VYUY:
+	case V4L2_IMGBUS_FMT_YUYV:
+	case V4L2_IMGBUS_FMT_YVYU:
+	case V4L2_IMGBUS_FMT_RGB565:
+	case V4L2_IMGBUS_FMT_RGB555:
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
+	struct v4l2_imgbus_framefmt imgf;
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
+	ret = v4l2_subdev_call(sd, video, g_imgbus_fmt, &imgf);
 	if (ret < 0)
 		return ret;
 
-	pix_tmp = *pix;
-	if (pxa_camera_check_frame(pix)) {
+	if (pxa_camera_check_frame(imgf.width, imgf.height)) {
 		/*
 		 * Camera cropping produced a frame beyond our capabilities.
 		 * FIXME: just extract a subframe, that we can process.
 		 */
-		v4l_bound_align_image(&pix->width, 48, 2048, 1,
-			&pix->height, 32, 2048, 0,
-			icd->current_fmt->fourcc == V4L2_PIX_FMT_YUV422P ?
-				4 : 0);
-		ret = v4l2_subdev_call(sd, video, s_fmt, &f);
+		v4l_bound_align_image(&imgf.width, 48, 2048, 1,
+			&imgf.height, 32, 2048, 0,
+			fourcc == V4L2_PIX_FMT_YUV422P ? 4 : 0);
+		ret = v4l2_subdev_call(sd, video, s_imgbus_fmt, &imgf);
 		if (ret < 0)
 			return ret;
 
-		if (pxa_camera_check_frame(pix)) {
+		if (pxa_camera_check_frame(imgf.width, imgf.height)) {
 			dev_warn(icd->dev.parent,
 				 "Inconsistent state. Use S_FMT to repair\n");
 			return -EINVAL;
@@ -1414,10 +1407,10 @@ static int pxa_camera_set_crop(struct soc_camera_device *icd,
 		recalculate_fifo_timeout(pcdev, sense.pixel_clock);
 	}
 
-	icd->user_width = pix->width;
-	icd->user_height = pix->height;
+	icd->user_width		= imgf.width;
+	icd->user_height	= imgf.height;
 
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
+	struct v4l2_imgbus_framefmt imgf;
 	int ret;
 
 	xlate = soc_camera_xlate_by_fourcc(icd, pix->pixelformat);
@@ -1445,26 +1437,27 @@ static int pxa_camera_set_fmt(struct soc_camera_device *icd,
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
+	imgf.width	= pix->width;
+	imgf.height	= pix->height;
+	imgf.code	= xlate->code;
+	imgf.field	= pix->field;
+
+	ret = v4l2_subdev_call(sd, video, s_imgbus_fmt, &imgf);
 
 	icd->sense = NULL;
 
 	if (ret < 0) {
 		dev_warn(dev, "Failed to configure for format %x\n",
 			 pix->pixelformat);
-	} else if (pxa_camera_check_frame(pix)) {
+	} else if (pxa_camera_check_frame(imgf.width, imgf.height)) {
 		dev_warn(dev,
 			 "Camera driver produced an unsupported frame %dx%d\n",
-			 pix->width, pix->height);
+			 imgf.width, imgf.height);
 		ret = -EINVAL;
 	} else if (sense.flags & SOCAM_SENSE_PCLK_CHANGED) {
 		if (sense.pixel_clock > sense.pixel_clock_max) {
@@ -1476,10 +1469,13 @@ static int pxa_camera_set_fmt(struct soc_camera_device *icd,
 		recalculate_fifo_timeout(pcdev, sense.pixel_clock);
 	}
 
-	if (!ret) {
-		icd->buswidth = xlate->buswidth;
-		icd->current_fmt = xlate->host_fmt;
-	}
+	if (ret < 0)
+		return ret;
+
+	pix->width		= imgf.width;
+	pix->height		= imgf.height;
+	pix->field		= imgf.field;
+	icd->current_fmt	= xlate;
 
 	return ret;
 }
@@ -1487,17 +1483,16 @@ static int pxa_camera_set_fmt(struct soc_camera_device *icd,
 static int pxa_camera_try_fmt(struct soc_camera_device *icd,
 			      struct v4l2_format *f)
 {
-	struct soc_camera_host *ici = to_soc_camera_host(icd->dev.parent);
 	struct v4l2_subdev *sd = soc_camera_to_subdev(icd);
 	const struct soc_camera_format_xlate *xlate;
 	struct v4l2_pix_format *pix = &f->fmt.pix;
+	struct v4l2_imgbus_framefmt imgf;
 	__u32 pixfmt = pix->pixelformat;
-	enum v4l2_field field;
 	int ret;
 
 	xlate = soc_camera_xlate_by_fourcc(icd, pixfmt);
 	if (!xlate) {
-		dev_warn(ici->v4l2_dev.dev, "Format %x not found\n", pixfmt);
+		dev_warn(icd->dev.parent, "Format %x not found\n", pixfmt);
 		return -EINVAL;
 	}
 
@@ -1511,22 +1506,34 @@ static int pxa_camera_try_fmt(struct soc_camera_device *icd,
 			      &pix->height, 32, 2048, 0,
 			      pixfmt == V4L2_PIX_FMT_YUV422P ? 4 : 0);
 
-	pix->bytesperline = pix->width *
-		DIV_ROUND_UP(xlate->host_fmt->depth, 8);
+	pix->bytesperline = v4l2_imgbus_bytes_per_line(pix->width,
+						       xlate->host_fmt);
+	if (pix->bytesperline < 0)
+		return pix->bytesperline;
 	pix->sizeimage = pix->height * pix->bytesperline;
 
-	/* camera has to see its format, but the user the original one */
-	pix->pixelformat = xlate->cam_fmt->fourcc;
 	/* limit to sensor capabilities */
-	ret = v4l2_subdev_call(sd, video, try_fmt, f);
-	pix->pixelformat = pixfmt;
+	imgf.width	= pix->width;
+	imgf.height	= pix->height;
+	imgf.field	= pix->field;
+	imgf.code	= xlate->code;
 
-	field = pix->field;
+	ret = v4l2_subdev_call(sd, video, try_imgbus_fmt, &imgf);
+	if (ret < 0)
+		return ret;
 
-	if (field == V4L2_FIELD_ANY) {
-		pix->field = V4L2_FIELD_NONE;
-	} else if (field != V4L2_FIELD_NONE) {
-		dev_err(icd->dev.parent, "Field type %d unsupported.\n", field);
+	pix->width	= imgf.width;
+	pix->height	= imgf.height;
+
+	switch (imgf.field) {
+	case V4L2_FIELD_ANY:
+	case V4L2_FIELD_NONE:
+		pix->field	= V4L2_FIELD_NONE;
+		break;
+	default:
+		/* TODO: support interlaced at least in pass-through mode */
+		dev_err(icd->dev.parent, "Field type %d unsupported.\n",
+			imgf.field);
 		return -EINVAL;
 	}
 
diff --git a/drivers/media/video/rj54n1cb0c.c b/drivers/media/video/rj54n1cb0c.c
index 373f2a3..9d9512f 100644
--- a/drivers/media/video/rj54n1cb0c.c
+++ b/drivers/media/video/rj54n1cb0c.c
@@ -16,6 +16,7 @@
 #include <media/v4l2-subdev.h>
 #include <media/v4l2-chip-ident.h>
 #include <media/soc_camera.h>
+#include <media/rj54n1cb0c.h>
 
 #define RJ54N1_DEV_CODE			0x0400
 #define RJ54N1_DEV_CODE2		0x0401
@@ -38,6 +39,7 @@
 #define RJ54N1_H_OBEN_OFS		0x0413
 #define RJ54N1_V_OBEN_OFS		0x0414
 #define RJ54N1_RESIZE_CONTROL		0x0415
+#define RJ54N1_STILL_CONTROL		0x0417
 #define RJ54N1_INC_USE_SEL_H		0x0425
 #define RJ54N1_INC_USE_SEL_L		0x0426
 #define RJ54N1_MIRROR_STILL_MODE	0x0427
@@ -49,10 +51,21 @@
 #define RJ54N1_RA_SEL_UL		0x0530
 #define RJ54N1_BYTE_SWAP		0x0531
 #define RJ54N1_OUT_SIGPO		0x053b
+#define RJ54N1_WB_SEL_WEIGHT_I		0x054e
+#define RJ54N1_BIT8_WB			0x0569
+#define RJ54N1_HCAPS_WB			0x056a
+#define RJ54N1_VCAPS_WB			0x056b
+#define RJ54N1_HCAPE_WB			0x056c
+#define RJ54N1_VCAPE_WB			0x056d
+#define RJ54N1_EXPOSURE_CONTROL		0x058c
 #define RJ54N1_FRAME_LENGTH_S_H		0x0595
 #define RJ54N1_FRAME_LENGTH_S_L		0x0596
 #define RJ54N1_FRAME_LENGTH_P_H		0x0597
 #define RJ54N1_FRAME_LENGTH_P_L		0x0598
+#define RJ54N1_PEAK_H			0x05b7
+#define RJ54N1_PEAK_50			0x05b8
+#define RJ54N1_PEAK_60			0x05b9
+#define RJ54N1_PEAK_DIFF		0x05ba
 #define RJ54N1_IOC			0x05ef
 #define RJ54N1_TG_BYPASS		0x0700
 #define RJ54N1_PLL_L			0x0701
@@ -68,6 +81,7 @@
 #define RJ54N1_OCLK_SEL_EN		0x0713
 #define RJ54N1_CLK_RST			0x0717
 #define RJ54N1_RESET_STANDBY		0x0718
+#define RJ54N1_FWFLG			0x07fe
 
 #define E_EXCLK				(1 << 7)
 #define SOFT_STDBY			(1 << 4)
@@ -78,29 +92,34 @@
 #define RESIZE_HOLD_SEL			(1 << 2)
 #define RESIZE_GO			(1 << 1)
 
+/*
+ * When cropping, the camera automatically centers the cropped region, there
+ * doesn't seem to be a way to specify an explicit location of the rectangle.
+ */
 #define RJ54N1_COLUMN_SKIP		0
 #define RJ54N1_ROW_SKIP			0
 #define RJ54N1_MAX_WIDTH		1600
 #define RJ54N1_MAX_HEIGHT		1200
 
+#define PLL_L				2
+#define PLL_N				0x31
+
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
+static const enum v4l2_imgbus_pixelcode rj54n1_colour_codes[] = {
+	V4L2_IMGBUS_FMT_YUYV,
+	V4L2_IMGBUS_FMT_YVYU,
+	V4L2_IMGBUS_FMT_RGB565,
+	V4L2_IMGBUS_FMT_RGB565X,
+	V4L2_IMGBUS_FMT_SBGGR10_2X8_PADHI_BE,
+	V4L2_IMGBUS_FMT_SBGGR10_2X8_PADLO_BE,
+	V4L2_IMGBUS_FMT_SBGGR10_2X8_PADHI_LE,
+	V4L2_IMGBUS_FMT_SBGGR10_2X8_PADLO_LE,
+	V4L2_IMGBUS_FMT_SBGGR10,
 };
 
 struct rj54n1_clock_div {
-	u8 ratio_tg;
+	u8 ratio_tg;	/* can be 0 or an odd number */
 	u8 ratio_t;
 	u8 ratio_r;
 	u8 ratio_op;
@@ -109,12 +128,14 @@ struct rj54n1_clock_div {
 
 struct rj54n1 {
 	struct v4l2_subdev subdev;
+	struct rj54n1_clock_div clk_div;
+	enum v4l2_imgbus_pixelcode code;
 	struct v4l2_rect rect;	/* Sensor window */
+	unsigned int tgclk_mhz;
+	bool auto_wb;
 	unsigned short width;	/* Output window */
 	unsigned short height;
 	unsigned short resize;	/* Sensor * 1024 / resize = Output */
-	struct rj54n1_clock_div clk_div;
-	u32 fourcc;
 	unsigned short scale;
 	u8 bank;
 };
@@ -171,7 +192,7 @@ const static struct rj54n1_reg_val bank_7[] = {
 	{0x714, 0xff},
 	{0x715, 0xff},
 	{0x716, 0x1f},
-	{0x7FE, 0x02},
+	{0x7FE, 2},
 };
 
 const static struct rj54n1_reg_val bank_8[] = {
@@ -359,7 +380,7 @@ const static struct rj54n1_reg_val bank_8[] = {
 	{0x8BB, 0x00},
 	{0x8BC, 0xFF},
 	{0x8BD, 0x00},
-	{0x8FE, 0x02},
+	{0x8FE, 2},
 };
 
 const static struct rj54n1_reg_val bank_10[] = {
@@ -440,12 +461,24 @@ static int reg_write_multiple(struct i2c_client *client,
 	return 0;
 }
 
-static int rj54n1_s_stream(struct v4l2_subdev *sd, int enable)
+static int rj54n1_enum_fmt(struct v4l2_subdev *sd, int index,
+			   enum v4l2_imgbus_pixelcode *code)
 {
-	/* TODO: start / stop streaming */
+	if ((unsigned int)index >= ARRAY_SIZE(rj54n1_colour_codes))
+		return -EINVAL;
+
+	*code = rj54n1_colour_codes[index];
 	return 0;
 }
 
+static int rj54n1_s_stream(struct v4l2_subdev *sd, int enable)
+{
+	struct i2c_client *client = sd->priv;
+
+	/* Switch between preview and still shot modes */
+	return reg_set(client, RJ54N1_STILL_CONTROL, (!enable) << 7, 0x80);
+}
+
 static int rj54n1_set_bus_param(struct soc_camera_device *icd,
 				unsigned long flags)
 {
@@ -502,6 +535,44 @@ static int rj54n1_commit(struct i2c_client *client)
 	return ret;
 }
 
+static int rj54n1_sensor_scale(struct v4l2_subdev *sd, u32 *in_w, u32 *in_h,
+			       u32 *out_w, u32 *out_h);
+
+static int rj54n1_s_crop(struct v4l2_subdev *sd, struct v4l2_crop *a)
+{
+	struct i2c_client *client = sd->priv;
+	struct rj54n1 *rj54n1 = to_rj54n1(client);
+	struct v4l2_rect *rect = &a->c;
+	unsigned int dummy, output_w, output_h,
+		input_w = rect->width, input_h = rect->height;
+	int ret;
+
+	/* arbitrary minimum width and height, edges unimportant */
+	soc_camera_limit_side(&dummy, &input_w,
+		     RJ54N1_COLUMN_SKIP, 8, RJ54N1_MAX_WIDTH);
+
+	soc_camera_limit_side(&dummy, &input_h,
+		     RJ54N1_ROW_SKIP, 8, RJ54N1_MAX_HEIGHT);
+
+	output_w = (input_w * 1024 + rj54n1->resize / 2) / rj54n1->resize;
+	output_h = (input_h * 1024 + rj54n1->resize / 2) / rj54n1->resize;
+
+	dev_dbg(&client->dev, "Scaling for %ux%u : %u = %ux%u\n",
+		input_w, input_h, rj54n1->resize, output_w, output_h);
+
+	ret = rj54n1_sensor_scale(sd, &input_w, &input_h, &output_w, &output_h);
+	if (ret < 0)
+		return ret;
+
+	rj54n1->width		= output_w;
+	rj54n1->height		= output_h;
+	rj54n1->resize		= ret;
+	rj54n1->rect.width	= input_w;
+	rj54n1->rect.height	= input_h;
+
+	return 0;
+}
+
 static int rj54n1_g_crop(struct v4l2_subdev *sd, struct v4l2_crop *a)
 {
 	struct i2c_client *client = sd->priv;
@@ -527,16 +598,16 @@ static int rj54n1_cropcap(struct v4l2_subdev *sd, struct v4l2_cropcap *a)
 	return 0;
 }
 
-static int rj54n1_g_fmt(struct v4l2_subdev *sd, struct v4l2_format *f)
+static int rj54n1_g_fmt(struct v4l2_subdev *sd,
+			struct v4l2_imgbus_framefmt *imgf)
 {
 	struct i2c_client *client = sd->priv;
 	struct rj54n1 *rj54n1 = to_rj54n1(client);
-	struct v4l2_pix_format *pix = &f->fmt.pix;
 
-	pix->pixelformat	= rj54n1->fourcc;
-	pix->field		= V4L2_FIELD_NONE;
-	pix->width		= rj54n1->width;
-	pix->height		= rj54n1->height;
+	imgf->code	= rj54n1->code;
+	imgf->field	= V4L2_FIELD_NONE;
+	imgf->width	= rj54n1->width;
+	imgf->height	= rj54n1->height;
 
 	return 0;
 }
@@ -550,11 +621,44 @@ static int rj54n1_sensor_scale(struct v4l2_subdev *sd, u32 *in_w, u32 *in_h,
 			       u32 *out_w, u32 *out_h)
 {
 	struct i2c_client *client = sd->priv;
+	struct rj54n1 *rj54n1 = to_rj54n1(client);
 	unsigned int skip, resize, input_w = *in_w, input_h = *in_h,
 		output_w = *out_w, output_h = *out_h;
-	u16 inc_sel;
+	u16 inc_sel, wb_bit8, wb_left, wb_right, wb_top, wb_bottom;
+	unsigned int peak, peak_50, peak_60;
 	int ret;
 
+	/*
+	 * We have a problem with crops, where the window is larger than 512x384
+	 * and output window is larger than a half of the input one. In this
+	 * case we have to either reduce the input window to equal or below
+	 * 512x384 or the output window to equal or below 1/2 of the input.
+	 */
+	if (output_w > max(512U, input_w / 2)) {
+		if (2 * output_w > RJ54N1_MAX_WIDTH) {
+			input_w = RJ54N1_MAX_WIDTH;
+			output_w = RJ54N1_MAX_WIDTH / 2;
+		} else {
+			input_w = output_w * 2;
+		}
+
+		dev_dbg(&client->dev, "Adjusted output width: in %u, out %u\n",
+			input_w, output_w);
+	}
+
+	if (output_h > max(384U, input_h / 2)) {
+		if (2 * output_h > RJ54N1_MAX_HEIGHT) {
+			input_h = RJ54N1_MAX_HEIGHT;
+			output_h = RJ54N1_MAX_HEIGHT / 2;
+		} else {
+			input_h = output_h * 2;
+		}
+
+		dev_dbg(&client->dev, "Adjusted output height: in %u, out %u\n",
+			input_h, output_h);
+	}
+
+	/* Idea: use the read mode for snapshots, handle separate geometries */
 	ret = rj54n1_set_rect(client, RJ54N1_X_OUTPUT_SIZE_S_L,
 			      RJ54N1_Y_OUTPUT_SIZE_S_L,
 			      RJ54N1_XY_OUTPUT_SIZE_S_H, output_w, output_h);
@@ -566,17 +670,27 @@ static int rj54n1_sensor_scale(struct v4l2_subdev *sd, u32 *in_w, u32 *in_h,
 	if (ret < 0)
 		return ret;
 
-	if (output_w > input_w || output_h > input_h) {
+	if (output_w > input_w && output_h > input_h) {
 		input_w = output_w;
 		input_h = output_h;
 
 		resize = 1024;
 	} else {
 		unsigned int resize_x, resize_y;
-		resize_x = input_w * 1024 / output_w;
-		resize_y = input_h * 1024 / output_h;
-
-		resize = min(resize_x, resize_y);
+		resize_x = (input_w * 1024 + output_w / 2) / output_w;
+		resize_y = (input_h * 1024 + output_h / 2) / output_h;
+
+		/* We want max(resize_x, resize_y), check if it still fits */
+		if (resize_x > resize_y &&
+		    (output_h * resize_x + 512) / 1024 > RJ54N1_MAX_HEIGHT)
+			resize = (RJ54N1_MAX_HEIGHT * 1024 + output_h / 2) /
+				output_h;
+		else if (resize_y > resize_x &&
+			 (output_w * resize_y + 512) / 1024 > RJ54N1_MAX_WIDTH)
+			resize = (RJ54N1_MAX_WIDTH * 1024 + output_w / 2) /
+				output_w;
+		else
+			resize = max(resize_x, resize_y);
 
 		/* Prohibited value ranges */
 		switch (resize) {
@@ -589,12 +703,9 @@ static int rj54n1_sensor_scale(struct v4l2_subdev *sd, u32 *in_w, u32 *in_h,
 		case 8160 ... 8191:
 			resize = 8159;
 			break;
-		case 16320 ... 16383:
+		case 16320 ... 16384:
 			resize = 16319;
 		}
-
-		input_w = output_w * resize / 1024;
-		input_h = output_h * resize / 1024;
 	}
 
 	/* Set scaling */
@@ -607,13 +718,22 @@ static int rj54n1_sensor_scale(struct v4l2_subdev *sd, u32 *in_w, u32 *in_h,
 
 	/*
 	 * Configure a skipping bitmask. The sensor will select a skipping value
-	 * among set bits automatically.
+	 * among set bits automatically. This is very unclear in the datasheet
+	 * too. I was told, in this register one enables all skipping values,
+	 * that are required for a specific resize, and the camera selects
+	 * automatically, which ones to use. But it is unclear how to identify,
+	 * which cropping values are needed. Secondly, why don't we just set all
+	 * bits and let the camera choose? Would it increase processing time and
+	 * reduce the framerate? Using 0xfffc for INC_USE_SEL doesn't seem to
+	 * improve the image quality or stability for larger frames (see comment
+	 * above), but I didn't check the framerate.
 	 */
 	skip = min(resize / 1024, (unsigned)15);
+
 	inc_sel = 1 << skip;
 
 	if (inc_sel <= 2)
-		inc_sel = 0xc;
+		inc_sel = 0xC;
 	else if (resize & 1023 && skip < 15)
 		inc_sel |= 1 << (skip + 1);
 
@@ -621,6 +741,43 @@ static int rj54n1_sensor_scale(struct v4l2_subdev *sd, u32 *in_w, u32 *in_h,
 	if (!ret)
 		ret = reg_write(client, RJ54N1_INC_USE_SEL_H, inc_sel >> 8);
 
+	if (!rj54n1->auto_wb) {
+		/* Auto white balance window */
+		wb_left	  = output_w / 16;
+		wb_right  = (3 * output_w / 4 - 3) / 4;
+		wb_top	  = output_h / 16;
+		wb_bottom = (3 * output_h / 4 - 3) / 4;
+		wb_bit8	  = ((wb_left >> 2) & 0x40) | ((wb_top >> 4) & 0x10) |
+			((wb_right >> 6) & 4) | ((wb_bottom >> 8) & 1);
+
+		if (!ret)
+			ret = reg_write(client, RJ54N1_BIT8_WB, wb_bit8);
+		if (!ret)
+			ret = reg_write(client, RJ54N1_HCAPS_WB, wb_left);
+		if (!ret)
+			ret = reg_write(client, RJ54N1_VCAPS_WB, wb_top);
+		if (!ret)
+			ret = reg_write(client, RJ54N1_HCAPE_WB, wb_right);
+		if (!ret)
+			ret = reg_write(client, RJ54N1_VCAPE_WB, wb_bottom);
+	}
+
+	/* Antiflicker */
+	peak = 12 * RJ54N1_MAX_WIDTH * (1 << 14) * resize / rj54n1->tgclk_mhz /
+		10000;
+	peak_50 = peak / 6;
+	peak_60 = peak / 5;
+
+	if (!ret)
+		ret = reg_write(client, RJ54N1_PEAK_H,
+				((peak_50 >> 4) & 0xf0) | (peak_60 >> 8));
+	if (!ret)
+		ret = reg_write(client, RJ54N1_PEAK_50, peak_50);
+	if (!ret)
+		ret = reg_write(client, RJ54N1_PEAK_60, peak_60);
+	if (!ret)
+		ret = reg_write(client, RJ54N1_PEAK_DIFF, peak / 150);
+
 	/* Start resizing */
 	if (!ret)
 		ret = reg_write(client, RJ54N1_RESIZE_CONTROL,
@@ -629,8 +786,6 @@ static int rj54n1_sensor_scale(struct v4l2_subdev *sd, u32 *in_w, u32 *in_h,
 	if (ret < 0)
 		return ret;
 
-	dev_dbg(&client->dev, "resize %u, skip %u\n", resize, skip);
-
 	/* Constant taken from manufacturer's example */
 	msleep(230);
 
@@ -638,190 +793,37 @@ static int rj54n1_sensor_scale(struct v4l2_subdev *sd, u32 *in_w, u32 *in_h,
 	if (ret < 0)
 		return ret;
 
-	*in_w = input_w;
-	*in_h = input_h;
+	*in_w = (output_w * resize + 512) / 1024;
+	*in_h = (output_h * resize + 512) / 1024;
 	*out_w = output_w;
 	*out_h = output_h;
 
-	return resize;
-}
-
-static int rj54n1_set_clock(struct i2c_client *client)
-{
-	struct rj54n1 *rj54n1 = to_rj54n1(client);
-	int ret;
-
-	/* Enable external clock */
-	ret = reg_write(client, RJ54N1_RESET_STANDBY, E_EXCLK | SOFT_STDBY);
-	/* Leave stand-by */
-	if (!ret)
-		ret = reg_write(client, RJ54N1_RESET_STANDBY, E_EXCLK);
-
-	if (!ret)
-		ret = reg_write(client, RJ54N1_PLL_L, 2);
-	if (!ret)
-		ret = reg_write(client, RJ54N1_PLL_N, 0x31);
-
-	/* TGCLK dividers */
-	if (!ret)
-		ret = reg_write(client, RJ54N1_RATIO_TG,
-				rj54n1->clk_div.ratio_tg);
-	if (!ret)
-		ret = reg_write(client, RJ54N1_RATIO_T,
-				rj54n1->clk_div.ratio_t);
-	if (!ret)
-		ret = reg_write(client, RJ54N1_RATIO_R,
-				rj54n1->clk_div.ratio_r);
-
-	/* Enable TGCLK & RAMP */
-	if (!ret)
-		ret = reg_write(client, RJ54N1_RAMP_TGCLK_EN, 3);
-
-	/* Disable clock output */
-	if (!ret)
-		ret = reg_write(client, RJ54N1_OCLK_DSP, 0);
-
-	/* Set divisors */
-	if (!ret)
-		ret = reg_write(client, RJ54N1_RATIO_OP,
-				rj54n1->clk_div.ratio_op);
-	if (!ret)
-		ret = reg_write(client, RJ54N1_RATIO_O,
-				rj54n1->clk_div.ratio_o);
-
-	/* Enable OCLK */
-	if (!ret)
-		ret = reg_write(client, RJ54N1_OCLK_SEL_EN, 1);
-
-	/* Use PLL for Timing Generator, write 2 to reserved bits */
-	if (!ret)
-		ret = reg_write(client, RJ54N1_TG_BYPASS, 2);
-
-	/* Take sensor out of reset */
-	if (!ret)
-		ret = reg_write(client, RJ54N1_RESET_STANDBY,
-				E_EXCLK | SEN_RSTX);
-	/* Enable PLL */
-	if (!ret)
-		ret = reg_write(client, RJ54N1_PLL_EN, 1);
-
-	/* Wait for PLL to stabilise */
-	msleep(10);
-
-	/* Enable clock to frequency divider */
-	if (!ret)
-		ret = reg_write(client, RJ54N1_CLK_RST, 1);
-
-	if (!ret)
-		ret = reg_read(client, RJ54N1_CLK_RST);
-	if (ret != 1) {
-		dev_err(&client->dev,
-			"Resetting RJ54N1CB0C clock failed: %d!\n", ret);
-		return -EIO;
-	}
-	/* Start the PLL */
-	ret = reg_set(client, RJ54N1_OCLK_DSP, 1, 1);
-
-	/* Enable OCLK */
-	if (!ret)
-		ret = reg_write(client, RJ54N1_OCLK_SEL_EN, 1);
-
-	return ret;
-}
-
-static int rj54n1_reg_init(struct i2c_client *client)
-{
-	int ret = rj54n1_set_clock(client);
-
-	if (!ret)
-		ret = reg_write_multiple(client, bank_7, ARRAY_SIZE(bank_7));
-	if (!ret)
-		ret = reg_write_multiple(client, bank_10, ARRAY_SIZE(bank_10));
-
-	/* Set binning divisors */
-	if (!ret)
-		ret = reg_write(client, RJ54N1_SCALE_1_2_LEV, 3 | (7 << 4));
-	if (!ret)
-		ret = reg_write(client, RJ54N1_SCALE_4_LEV, 0xf);
-
-	/* Switch to fixed resize mode */
-	if (!ret)
-		ret = reg_write(client, RJ54N1_RESIZE_CONTROL,
-				RESIZE_HOLD_SEL | 1);
-
-	/* Set gain */
-	if (!ret)
-		ret = reg_write(client, RJ54N1_Y_GAIN, 0x84);
-
-	/* Mirror the image back: default is upside down and left-to-right... */
-	if (!ret)
-		ret = reg_set(client, RJ54N1_MIRROR_STILL_MODE, 3, 3);
-
-	if (!ret)
-		ret = reg_write_multiple(client, bank_4, ARRAY_SIZE(bank_4));
-	if (!ret)
-		ret = reg_write_multiple(client, bank_5, ARRAY_SIZE(bank_5));
-	if (!ret)
-		ret = reg_write_multiple(client, bank_8, ARRAY_SIZE(bank_8));
-
-	if (!ret)
-		ret = reg_write(client, RJ54N1_RESET_STANDBY,
-				E_EXCLK | DSP_RSTX | SEN_RSTX);
-
-	/* Commit init */
-	if (!ret)
-		ret = rj54n1_commit(client);
-
-	/* Take DSP, TG, sensor out of reset */
-	if (!ret)
-		ret = reg_write(client, RJ54N1_RESET_STANDBY,
-				E_EXCLK | DSP_RSTX | TG_RSTX | SEN_RSTX);
-
-	if (!ret)
-		ret = reg_write(client, 0x7fe, 2);
-
-	/* Constant taken from manufacturer's example */
-	msleep(700);
+	dev_dbg(&client->dev, "Scaled for %ux%u : %u = %ux%u, skip %u\n",
+		*in_w, *in_h, resize, output_w, output_h, skip);
 
-	return ret;
+	return resize;
 }
 
-/* FIXME: streaming output only up to 800x600 is functional */
-static int rj54n1_try_fmt(struct v4l2_subdev *sd, struct v4l2_format *f)
-{
-	struct v4l2_pix_format *pix = &f->fmt.pix;
+static int rj54n1_reg_init(struct i2c_client *client);
+static int rj54n1_try_fmt(struct v4l2_subdev *sd,
+			  struct v4l2_imgbus_framefmt *imgf);
 
-	pix->field = V4L2_FIELD_NONE;
-
-	if (pix->width > 800)
-		pix->width = 800;
-	if (pix->height > 600)
-		pix->height = 600;
-
-	return 0;
-}
-
-static int rj54n1_s_fmt(struct v4l2_subdev *sd, struct v4l2_format *f)
+static int rj54n1_s_fmt(struct v4l2_subdev *sd,
+			struct v4l2_imgbus_framefmt *imgf)
 {
 	struct i2c_client *client = sd->priv;
 	struct rj54n1 *rj54n1 = to_rj54n1(client);
-	struct v4l2_pix_format *pix = &f->fmt.pix;
-	unsigned int output_w, output_h,
+	unsigned int output_w, output_h, max_w, max_h,
 		input_w = rj54n1->rect.width, input_h = rj54n1->rect.height;
 	int ret;
 
-	/*
-	 * The host driver can call us without .try_fmt(), so, we have to take
-	 * care ourseleves
-	 */
-	ret = rj54n1_try_fmt(sd, f);
+	rj54n1_try_fmt(sd, imgf);
 
 	/*
 	 * Verify if the sensor has just been powered on. TODO: replace this
 	 * with proper PM, when a suitable API is available.
 	 */
-	if (!ret)
-		ret = reg_read(client, RJ54N1_RESET_STANDBY);
+	ret = reg_read(client, RJ54N1_RESET_STANDBY);
 	if (ret < 0)
 		return ret;
 
@@ -831,50 +833,122 @@ static int rj54n1_s_fmt(struct v4l2_subdev *sd, struct v4l2_format *f)
 			return ret;
 	}
 
+	dev_dbg(&client->dev, "%s: code = %d, width = %u, height = %u\n",
+		__func__, imgf->code, imgf->width, imgf->height);
+
 	/* RA_SEL_UL is only relevant for raw modes, ignored otherwise. */
-	switch (pix->pixelformat) {
-	case V4L2_PIX_FMT_YUYV:
+	switch (imgf->code) {
+	case V4L2_IMGBUS_FMT_YUYV:
+		ret = reg_write(client, RJ54N1_OUT_SEL, 0);
+		if (!ret)
+			ret = reg_set(client, RJ54N1_BYTE_SWAP, 8, 8);
+		break;
+	case V4L2_IMGBUS_FMT_YVYU:
 		ret = reg_write(client, RJ54N1_OUT_SEL, 0);
 		if (!ret)
+			ret = reg_set(client, RJ54N1_BYTE_SWAP, 0, 8);
+		break;
+	case V4L2_IMGBUS_FMT_RGB565:
+		ret = reg_write(client, RJ54N1_OUT_SEL, 0x11);
+		if (!ret)
 			ret = reg_set(client, RJ54N1_BYTE_SWAP, 8, 8);
 		break;
-	case V4L2_PIX_FMT_RGB565:
+	case V4L2_IMGBUS_FMT_RGB565X:
 		ret = reg_write(client, RJ54N1_OUT_SEL, 0x11);
 		if (!ret)
+			ret = reg_set(client, RJ54N1_BYTE_SWAP, 0, 8);
+		break;
+	case V4L2_IMGBUS_FMT_SBGGR10_2X8_PADLO_LE:
+		ret = reg_write(client, RJ54N1_OUT_SEL, 4);
+		if (!ret)
 			ret = reg_set(client, RJ54N1_BYTE_SWAP, 8, 8);
+		if (!ret)
+			ret = reg_write(client, RJ54N1_RA_SEL_UL, 0);
+		break;
+	case V4L2_IMGBUS_FMT_SBGGR10_2X8_PADHI_LE:
+		ret = reg_write(client, RJ54N1_OUT_SEL, 4);
+		if (!ret)
+			ret = reg_set(client, RJ54N1_BYTE_SWAP, 8, 8);
+		if (!ret)
+			ret = reg_write(client, RJ54N1_RA_SEL_UL, 8);
+		break;
+	case V4L2_IMGBUS_FMT_SBGGR10_2X8_PADLO_BE:
+		ret = reg_write(client, RJ54N1_OUT_SEL, 4);
+		if (!ret)
+			ret = reg_set(client, RJ54N1_BYTE_SWAP, 0, 8);
+		if (!ret)
+			ret = reg_write(client, RJ54N1_RA_SEL_UL, 0);
+		break;
+	case V4L2_IMGBUS_FMT_SBGGR10_2X8_PADHI_BE:
+		ret = reg_write(client, RJ54N1_OUT_SEL, 4);
+		if (!ret)
+			ret = reg_set(client, RJ54N1_BYTE_SWAP, 0, 8);
+		if (!ret)
+			ret = reg_write(client, RJ54N1_RA_SEL_UL, 8);
+		break;
+	case V4L2_IMGBUS_FMT_SBGGR10:
+		ret = reg_write(client, RJ54N1_OUT_SEL, 5);
 		break;
 	default:
 		ret = -EINVAL;
 	}
 
+	/* Special case: a raw mode with 10 bits of data per clock tick */
+	if (!ret)
+		ret = reg_set(client, RJ54N1_OCLK_SEL_EN,
+			      (imgf->code == V4L2_IMGBUS_FMT_SBGGR10) << 1, 2);
+
 	if (ret < 0)
 		return ret;
 
-	/* Supported scales 1:1 - 1:16 */
-	if (pix->width < input_w / 16)
-		pix->width = input_w / 16;
-	if (pix->height < input_h / 16)
-		pix->height = input_h / 16;
+	/* Supported scales 1:1 >= scale > 1:16 */
+	max_w = imgf->width * (16 * 1024 - 1) / 1024;
+	if (input_w > max_w)
+		input_w = max_w;
+	max_h = imgf->height * (16 * 1024 - 1) / 1024;
+	if (input_h > max_h)
+		input_h = max_h;
 
-	output_w = pix->width;
-	output_h = pix->height;
+	output_w = imgf->width;
+	output_h = imgf->height;
 
 	ret = rj54n1_sensor_scale(sd, &input_w, &input_h, &output_w, &output_h);
 	if (ret < 0)
 		return ret;
 
-	rj54n1->fourcc		= pix->pixelformat;
+	rj54n1->code		= imgf->code;
 	rj54n1->resize		= ret;
 	rj54n1->rect.width	= input_w;
 	rj54n1->rect.height	= input_h;
 	rj54n1->width		= output_w;
 	rj54n1->height		= output_h;
 
-	pix->width		= output_w;
-	pix->height		= output_h;
-	pix->field		= V4L2_FIELD_NONE;
+	imgf->width		= output_w;
+	imgf->height		= output_h;
+	imgf->field		= V4L2_FIELD_NONE;
 
-	return ret;
+	return 0;
+}
+
+static int rj54n1_try_fmt(struct v4l2_subdev *sd,
+			  struct v4l2_imgbus_framefmt *imgf)
+{
+	struct i2c_client *client = sd->priv;
+	int align = imgf->code == V4L2_IMGBUS_FMT_SBGGR10 ||
+		imgf->code == V4L2_IMGBUS_FMT_SBGGR10_2X8_PADHI_BE ||
+		imgf->code == V4L2_IMGBUS_FMT_SBGGR10_2X8_PADLO_BE ||
+		imgf->code == V4L2_IMGBUS_FMT_SBGGR10_2X8_PADHI_LE ||
+		imgf->code == V4L2_IMGBUS_FMT_SBGGR10_2X8_PADLO_LE;
+
+	dev_dbg(&client->dev, "%s: code = %d, width = %u, height = %u\n",
+		__func__, imgf->code, imgf->width, imgf->height);
+
+	imgf->field = V4L2_FIELD_NONE;
+
+	v4l_bound_align_image(&imgf->width, 112, RJ54N1_MAX_WIDTH, align,
+			      &imgf->height, 84, RJ54N1_MAX_HEIGHT, align, 0);
+
+	return 0;
 }
 
 static int rj54n1_g_chip_ident(struct v4l2_subdev *sd,
@@ -963,6 +1037,14 @@ static const struct v4l2_queryctrl rj54n1_controls[] = {
 		.step		= 1,
 		.default_value	= 66,
 		.flags		= V4L2_CTRL_FLAG_SLIDER,
+	}, {
+		.id		= V4L2_CID_AUTO_WHITE_BALANCE,
+		.type		= V4L2_CTRL_TYPE_BOOLEAN,
+		.name		= "Auto white balance",
+		.minimum	= 0,
+		.maximum	= 1,
+		.step		= 1,
+		.default_value	= 1,
 	},
 };
 
@@ -976,6 +1058,7 @@ static struct soc_camera_ops rj54n1_ops = {
 static int rj54n1_g_ctrl(struct v4l2_subdev *sd, struct v4l2_control *ctrl)
 {
 	struct i2c_client *client = sd->priv;
+	struct rj54n1 *rj54n1 = to_rj54n1(client);
 	int data;
 
 	switch (ctrl->id) {
@@ -998,6 +1081,9 @@ static int rj54n1_g_ctrl(struct v4l2_subdev *sd, struct v4l2_control *ctrl)
 
 		ctrl->value = data / 2;
 		break;
+	case V4L2_CID_AUTO_WHITE_BALANCE:
+		ctrl->value = rj54n1->auto_wb;
+		break;
 	}
 
 	return 0;
@@ -1007,6 +1093,7 @@ static int rj54n1_s_ctrl(struct v4l2_subdev *sd, struct v4l2_control *ctrl)
 {
 	int data;
 	struct i2c_client *client = sd->priv;
+	struct rj54n1 *rj54n1 = to_rj54n1(client);
 	const struct v4l2_queryctrl *qctrl;
 
 	qctrl = soc_camera_find_qctrl(&rj54n1_ops, ctrl->id);
@@ -1037,6 +1124,13 @@ static int rj54n1_s_ctrl(struct v4l2_subdev *sd, struct v4l2_control *ctrl)
 		else if (reg_write(client, RJ54N1_Y_GAIN, ctrl->value * 2) < 0)
 			return -EIO;
 		break;
+	case V4L2_CID_AUTO_WHITE_BALANCE:
+		/* Auto WB area - whole image */
+		if (reg_set(client, RJ54N1_WB_SEL_WEIGHT_I, ctrl->value << 7,
+			    0x80) < 0)
+			return -EIO;
+		rj54n1->auto_wb = ctrl->value;
+		break;
 	}
 
 	return 0;
@@ -1053,26 +1147,178 @@ static struct v4l2_subdev_core_ops rj54n1_subdev_core_ops = {
 };
 
 static struct v4l2_subdev_video_ops rj54n1_subdev_video_ops = {
-	.s_stream	= rj54n1_s_stream,
-	.s_fmt		= rj54n1_s_fmt,
-	.g_fmt		= rj54n1_g_fmt,
-	.try_fmt	= rj54n1_try_fmt,
-	.g_crop		= rj54n1_g_crop,
-	.cropcap	= rj54n1_cropcap,
+	.s_stream		= rj54n1_s_stream,
+	.s_imgbus_fmt		= rj54n1_s_fmt,
+	.g_imgbus_fmt		= rj54n1_g_fmt,
+	.try_imgbus_fmt		= rj54n1_try_fmt,
+	.s_crop			= rj54n1_s_crop,
+	.g_crop			= rj54n1_g_crop,
+	.cropcap		= rj54n1_cropcap,
+	.enum_imgbus_fmt	= rj54n1_enum_fmt,
+};
+
+static struct v4l2_subdev_sensor_ops rj54n1_subdev_sensor_ops = {
 };
 
 static struct v4l2_subdev_ops rj54n1_subdev_ops = {
 	.core	= &rj54n1_subdev_core_ops,
 	.video	= &rj54n1_subdev_video_ops,
+	.sensor	= &rj54n1_subdev_sensor_ops,
 };
 
-static int rj54n1_pin_config(struct i2c_client *client)
+static int rj54n1_set_clock(struct i2c_client *client)
+{
+	struct rj54n1 *rj54n1 = to_rj54n1(client);
+	int ret;
+
+	/* Enable external clock */
+	ret = reg_write(client, RJ54N1_RESET_STANDBY, E_EXCLK | SOFT_STDBY);
+	/* Leave stand-by. Note: use this when implementing suspend / resume */
+	if (!ret)
+		ret = reg_write(client, RJ54N1_RESET_STANDBY, E_EXCLK);
+
+	if (!ret)
+		ret = reg_write(client, RJ54N1_PLL_L, PLL_L);
+	if (!ret)
+		ret = reg_write(client, RJ54N1_PLL_N, PLL_N);
+
+	/* TGCLK dividers */
+	if (!ret)
+		ret = reg_write(client, RJ54N1_RATIO_TG,
+				rj54n1->clk_div.ratio_tg);
+	if (!ret)
+		ret = reg_write(client, RJ54N1_RATIO_T,
+				rj54n1->clk_div.ratio_t);
+	if (!ret)
+		ret = reg_write(client, RJ54N1_RATIO_R,
+				rj54n1->clk_div.ratio_r);
+
+	/* Enable TGCLK & RAMP */
+	if (!ret)
+		ret = reg_write(client, RJ54N1_RAMP_TGCLK_EN, 3);
+
+	/* Disable clock output */
+	if (!ret)
+		ret = reg_write(client, RJ54N1_OCLK_DSP, 0);
+
+	/* Set divisors */
+	if (!ret)
+		ret = reg_write(client, RJ54N1_RATIO_OP,
+				rj54n1->clk_div.ratio_op);
+	if (!ret)
+		ret = reg_write(client, RJ54N1_RATIO_O,
+				rj54n1->clk_div.ratio_o);
+
+	/* Enable OCLK */
+	if (!ret)
+		ret = reg_write(client, RJ54N1_OCLK_SEL_EN, 1);
+
+	/* Use PLL for Timing Generator, write 2 to reserved bits */
+	if (!ret)
+		ret = reg_write(client, RJ54N1_TG_BYPASS, 2);
+
+	/* Take sensor out of reset */
+	if (!ret)
+		ret = reg_write(client, RJ54N1_RESET_STANDBY,
+				E_EXCLK | SEN_RSTX);
+	/* Enable PLL */
+	if (!ret)
+		ret = reg_write(client, RJ54N1_PLL_EN, 1);
+
+	/* Wait for PLL to stabilise */
+	msleep(10);
+
+	/* Enable clock to frequency divider */
+	if (!ret)
+		ret = reg_write(client, RJ54N1_CLK_RST, 1);
+
+	if (!ret)
+		ret = reg_read(client, RJ54N1_CLK_RST);
+	if (ret != 1) {
+		dev_err(&client->dev,
+			"Resetting RJ54N1CB0C clock failed: %d!\n", ret);
+		return -EIO;
+	}
+
+	/* Start the PLL */
+	ret = reg_set(client, RJ54N1_OCLK_DSP, 1, 1);
+
+	/* Enable OCLK */
+	if (!ret)
+		ret = reg_write(client, RJ54N1_OCLK_SEL_EN, 1);
+
+	return ret;
+}
+
+static int rj54n1_reg_init(struct i2c_client *client)
 {
+	struct rj54n1 *rj54n1 = to_rj54n1(client);
+	int ret = rj54n1_set_clock(client);
+
+	if (!ret)
+		ret = reg_write_multiple(client, bank_7, ARRAY_SIZE(bank_7));
+	if (!ret)
+		ret = reg_write_multiple(client, bank_10, ARRAY_SIZE(bank_10));
+
+	/* Set binning divisors */
+	if (!ret)
+		ret = reg_write(client, RJ54N1_SCALE_1_2_LEV, 3 | (7 << 4));
+	if (!ret)
+		ret = reg_write(client, RJ54N1_SCALE_4_LEV, 0xf);
+
+	/* Switch to fixed resize mode */
+	if (!ret)
+		ret = reg_write(client, RJ54N1_RESIZE_CONTROL,
+				RESIZE_HOLD_SEL | 1);
+
+	/* Set gain */
+	if (!ret)
+		ret = reg_write(client, RJ54N1_Y_GAIN, 0x84);
+
 	/*
-	 * Experimentally found out IOCTRL wired to 0. TODO: add to platform
-	 * data: 0 or 1 << 7.
+	 * Mirror the image back: default is upside down and left-to-right...
+	 * Set manual preview / still shot switching
 	 */
-	return reg_write(client, RJ54N1_IOC, 0);
+	if (!ret)
+		ret = reg_write(client, RJ54N1_MIRROR_STILL_MODE, 0x27);
+
+	if (!ret)
+		ret = reg_write_multiple(client, bank_4, ARRAY_SIZE(bank_4));
+
+	/* Auto exposure area */
+	if (!ret)
+		ret = reg_write(client, RJ54N1_EXPOSURE_CONTROL, 0x80);
+	/* Check current auto WB config */
+	if (!ret)
+		ret = reg_read(client, RJ54N1_WB_SEL_WEIGHT_I);
+	if (ret >= 0) {
+		rj54n1->auto_wb = ret & 0x80;
+		ret = reg_write_multiple(client, bank_5, ARRAY_SIZE(bank_5));
+	}
+	if (!ret)
+		ret = reg_write_multiple(client, bank_8, ARRAY_SIZE(bank_8));
+
+	if (!ret)
+		ret = reg_write(client, RJ54N1_RESET_STANDBY,
+				E_EXCLK | DSP_RSTX | SEN_RSTX);
+
+	/* Commit init */
+	if (!ret)
+		ret = rj54n1_commit(client);
+
+	/* Take DSP, TG, sensor out of reset */
+	if (!ret)
+		ret = reg_write(client, RJ54N1_RESET_STANDBY,
+				E_EXCLK | DSP_RSTX | TG_RSTX | SEN_RSTX);
+
+	/* Start register update? Same register as 0x?FE in many bank_* sets */
+	if (!ret)
+		ret = reg_write(client, RJ54N1_FWFLG, 2);
+
+	/* Constant taken from manufacturer's example */
+	msleep(700);
+
+	return ret;
 }
 
 /*
@@ -1080,7 +1326,8 @@ static int rj54n1_pin_config(struct i2c_client *client)
  * this wasn't our capture interface, so, we wait for the right one
  */
 static int rj54n1_video_probe(struct soc_camera_device *icd,
-			      struct i2c_client *client)
+			      struct i2c_client *client,
+			      struct rj54n1_pdata *priv)
 {
 	int data1, data2;
 	int ret;
@@ -1101,7 +1348,8 @@ static int rj54n1_video_probe(struct soc_camera_device *icd,
 		goto ei2c;
 	}
 
-	ret = rj54n1_pin_config(client);
+	/* Configure IOCTL polarity from the platform data: 0 or 1 << 7. */
+	ret = reg_write(client, RJ54N1_IOC, priv->ioctl_high << 7);
 	if (ret < 0)
 		goto ei2c;
 
@@ -1119,6 +1367,7 @@ static int rj54n1_probe(struct i2c_client *client,
 	struct soc_camera_device *icd = client->dev.platform_data;
 	struct i2c_adapter *adapter = to_i2c_adapter(client->dev.parent);
 	struct soc_camera_link *icl;
+	struct rj54n1_pdata *rj54n1_priv;
 	int ret;
 
 	if (!icd) {
@@ -1127,11 +1376,13 @@ static int rj54n1_probe(struct i2c_client *client,
 	}
 
 	icl = to_soc_camera_link(icd);
-	if (!icl) {
+	if (!icl || !icl->priv) {
 		dev_err(&client->dev, "RJ54N1CB0C: missing platform data!\n");
 		return -EINVAL;
 	}
 
+	rj54n1_priv = icl->priv;
+
 	if (!i2c_check_functionality(adapter, I2C_FUNC_SMBUS_BYTE_DATA)) {
 		dev_warn(&adapter->dev,
 			 "I2C-Adapter doesn't support I2C_FUNC_SMBUS_BYTE\n");
@@ -1153,10 +1404,12 @@ static int rj54n1_probe(struct i2c_client *client,
 	rj54n1->rect.height	= RJ54N1_MAX_HEIGHT;
 	rj54n1->width		= RJ54N1_MAX_WIDTH;
 	rj54n1->height		= RJ54N1_MAX_HEIGHT;
-	rj54n1->fourcc		= V4L2_PIX_FMT_YUYV;
+	rj54n1->code		= rj54n1_colour_codes[0];
 	rj54n1->resize		= 1024;
+	rj54n1->tgclk_mhz	= (rj54n1_priv->mclk_freq / PLL_L * PLL_N) /
+		(clk_div.ratio_tg + 1) / (clk_div.ratio_t + 1);
 
-	ret = rj54n1_video_probe(icd, client);
+	ret = rj54n1_video_probe(icd, client, rj54n1_priv);
 	if (ret < 0) {
 		icd->ops = NULL;
 		i2c_set_clientdata(client, NULL);
@@ -1164,9 +1417,6 @@ static int rj54n1_probe(struct i2c_client *client,
 		return ret;
 	}
 
-	icd->formats		= rj54n1_colour_formats;
-	icd->num_formats	= ARRAY_SIZE(rj54n1_colour_formats);
-
 	return ret;
 }
 
diff --git a/drivers/media/video/sh_mobile_ceu_camera.c b/drivers/media/video/sh_mobile_ceu_camera.c
index 0b7e32b..746aed0 100644
--- a/drivers/media/video/sh_mobile_ceu_camera.c
+++ b/drivers/media/video/sh_mobile_ceu_camera.c
@@ -37,6 +37,7 @@
 #include <media/soc_camera.h>
 #include <media/sh_mobile_ceu.h>
 #include <media/videobuf-dma-contig.h>
+#include <media/v4l2-imagebus.h>
 
 /* register offsets for sh7722 / sh7723 */
 
@@ -84,7 +85,7 @@
 /* per video frame buffer */
 struct sh_mobile_ceu_buffer {
 	struct videobuf_buffer vb; /* v4l buffer must be first */
-	const struct soc_camera_data_format *fmt;
+	enum v4l2_imgbus_pixelcode code;
 };
 
 struct sh_mobile_ceu_dev {
@@ -113,8 +114,8 @@ struct sh_mobile_ceu_cam {
 	struct v4l2_rect ceu_rect;
 	unsigned int cam_width;
 	unsigned int cam_height;
-	const struct soc_camera_data_format *extra_fmt;
-	const struct soc_camera_data_format *camera_fmt;
+	const struct v4l2_imgbus_pixelfmt *extra_fmt;
+	enum v4l2_imgbus_pixelcode code;
 };
 
 static unsigned long make_bus_param(struct sh_mobile_ceu_dev *pcdev)
@@ -195,10 +196,13 @@ static int sh_mobile_ceu_videobuf_setup(struct videobuf_queue *vq,
 	struct soc_camera_device *icd = vq->priv_data;
 	struct soc_camera_host *ici = to_soc_camera_host(icd->dev.parent);
 	struct sh_mobile_ceu_dev *pcdev = ici->priv;
-	int bytes_per_pixel = (icd->current_fmt->depth + 7) >> 3;
+	int bytes_per_line = v4l2_imgbus_bytes_per_line(icd->user_width,
+						icd->current_fmt->host_fmt);
 
-	*size = PAGE_ALIGN(icd->user_width * icd->user_height *
-			   bytes_per_pixel);
+	if (bytes_per_line < 0)
+		return bytes_per_line;
+
+	*size = PAGE_ALIGN(bytes_per_line * icd->user_height);
 
 	if (0 == *count)
 		*count = 2;
@@ -282,7 +286,7 @@ static int sh_mobile_ceu_capture(struct sh_mobile_ceu_dev *pcdev)
 		ceu_write(pcdev, CDBYR, phys_addr_bottom);
 	}
 
-	switch (icd->current_fmt->fourcc) {
+	switch (icd->current_fmt->host_fmt->fourcc) {
 	case V4L2_PIX_FMT_NV12:
 	case V4L2_PIX_FMT_NV21:
 	case V4L2_PIX_FMT_NV16:
@@ -309,8 +313,13 @@ static int sh_mobile_ceu_videobuf_prepare(struct videobuf_queue *vq,
 {
 	struct soc_camera_device *icd = vq->priv_data;
 	struct sh_mobile_ceu_buffer *buf;
+	int bytes_per_line = v4l2_imgbus_bytes_per_line(icd->user_width,
+						icd->current_fmt->host_fmt);
 	int ret;
 
+	if (bytes_per_line < 0)
+		return bytes_per_line;
+
 	buf = container_of(vb, struct sh_mobile_ceu_buffer, vb);
 
 	dev_dbg(icd->dev.parent, "%s (vb=0x%p) 0x%08lx %zd\n", __func__,
@@ -329,18 +338,18 @@ static int sh_mobile_ceu_videobuf_prepare(struct videobuf_queue *vq,
 
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
@@ -564,7 +573,8 @@ static void sh_mobile_ceu_set_rect(struct soc_camera_device *icd,
 		}
 		width = cdwdr_width = out_width;
 	} else {
-		unsigned int w_factor = (icd->current_fmt->depth + 7) >> 3;
+		unsigned int w_factor = (7 +
+			icd->current_fmt->host_fmt->bits_per_sample) >> 3;
 
 		width = out_width * w_factor / 2;
 
@@ -671,24 +681,24 @@ static int sh_mobile_ceu_set_bus_param(struct soc_camera_device *icd,
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
+		case V4L2_IMGBUS_FMT_UYVY:
 			value = 0x00000000; /* Cb0, Y0, Cr0, Y1 */
 			break;
-		case V4L2_PIX_FMT_VYUY:
+		case V4L2_IMGBUS_FMT_VYUY:
 			value = 0x00000100; /* Cr0, Y0, Cb0, Y1 */
 			break;
-		case V4L2_PIX_FMT_YUYV:
+		case V4L2_IMGBUS_FMT_YUYV:
 			value = 0x00000200; /* Y0, Cb0, Y1, Cr0 */
 			break;
-		case V4L2_PIX_FMT_YVYU:
+		case V4L2_IMGBUS_FMT_YVYU:
 			value = 0x00000300; /* Y0, Cr0, Y1, Cb0 */
 			break;
 		default:
@@ -696,8 +706,8 @@ static int sh_mobile_ceu_set_bus_param(struct soc_camera_device *icd,
 		}
 	}
 
-	if (icd->current_fmt->fourcc == V4L2_PIX_FMT_NV21 ||
-	    icd->current_fmt->fourcc == V4L2_PIX_FMT_NV61)
+	if (icd->current_fmt->host_fmt->fourcc == V4L2_PIX_FMT_NV21 ||
+	    icd->current_fmt->host_fmt->fourcc == V4L2_PIX_FMT_NV61)
 		value ^= 0x00000100; /* swap U, V to change from NV1x->NVx1 */
 
 	value |= common_flags & SOCAM_VSYNC_ACTIVE_LOW ? 1 << 1 : 0;
@@ -744,7 +754,8 @@ static int sh_mobile_ceu_set_bus_param(struct soc_camera_device *icd,
 	return 0;
 }
 
-static int sh_mobile_ceu_try_bus_param(struct soc_camera_device *icd)
+static int sh_mobile_ceu_try_bus_param(struct soc_camera_device *icd,
+				       unsigned char buswidth)
 {
 	struct soc_camera_host *ici = to_soc_camera_host(icd->dev.parent);
 	struct sh_mobile_ceu_dev *pcdev = ici->priv;
@@ -753,48 +764,79 @@ static int sh_mobile_ceu_try_bus_param(struct soc_camera_device *icd)
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
+static const struct v4l2_imgbus_pixelfmt sh_mobile_ceu_formats[] = {
 	{
-		.name		= "NV61",
-		.depth		= 16,
-		.fourcc		= V4L2_PIX_FMT_NV61,
-		.colorspace	= V4L2_COLORSPACE_JPEG,
+		.fourcc			= V4L2_PIX_FMT_NV12,
+		.colorspace		= V4L2_COLORSPACE_JPEG,
+		.name			= "NV12",
+		.bits_per_sample	= 12,
+		.packing		= V4L2_IMGBUS_PACKING_NONE,
+		.order			= V4L2_IMGBUS_ORDER_LE,
+	}, {
+		.fourcc			= V4L2_PIX_FMT_NV21,
+		.colorspace		= V4L2_COLORSPACE_JPEG,
+		.name			= "NV21",
+		.bits_per_sample	= 12,
+		.packing		= V4L2_IMGBUS_PACKING_NONE,
+		.order			= V4L2_IMGBUS_ORDER_LE,
+	}, {
+		.fourcc			= V4L2_PIX_FMT_NV16,
+		.colorspace		= V4L2_COLORSPACE_JPEG,
+		.name			= "NV16",
+		.bits_per_sample	= 16,
+		.packing		= V4L2_IMGBUS_PACKING_NONE,
+		.order			= V4L2_IMGBUS_ORDER_LE,
+	}, {
+		.fourcc			= V4L2_PIX_FMT_NV61,
+		.colorspace		= V4L2_COLORSPACE_JPEG,
+		.name			= "NV61",
+		.bits_per_sample	= 16,
+		.packing		= V4L2_IMGBUS_PACKING_NONE,
+		.order			= V4L2_IMGBUS_ORDER_LE,
 	},
 };
 
+/* This will be corrected as we get more formats */
+static bool sh_mobile_ceu_packing_supported(const struct v4l2_imgbus_pixelfmt *fmt)
+{
+	return	fmt->packing == V4L2_IMGBUS_PACKING_NONE ||
+		(fmt->bits_per_sample == 8 &&
+		 fmt->packing == V4L2_IMGBUS_PACKING_2X8_PADHI) ||
+		(fmt->bits_per_sample > 8 &&
+		 fmt->packing == V4L2_IMGBUS_PACKING_EXTEND16);
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
+	enum v4l2_imgbus_pixelcode code;
+	const struct v4l2_imgbus_pixelfmt *fmt;
+
+	ret = v4l2_subdev_call(sd, video, enum_imgbus_fmt, idx, &code);
+	if (ret < 0)
+		/* No more formats */
+		return 0;
 
-	ret = sh_mobile_ceu_try_bus_param(icd);
+	fmt = v4l2_imgbus_get_fmtdesc(code);
+	if (!fmt) {
+		dev_err(icd->dev.parent,
+			"Invalid format code #%d: %d\n", idx, code);
+		return -EINVAL;
+	}
+
+	ret = sh_mobile_ceu_try_bus_param(icd, fmt->bits_per_sample);
 	if (ret < 0)
 		return 0;
 
@@ -812,13 +854,13 @@ static int sh_mobile_ceu_get_formats(struct soc_camera_device *icd, int idx,
 	if (!idx)
 		cam->extra_fmt = NULL;
 
-	switch (icd->formats[idx].fourcc) {
-	case V4L2_PIX_FMT_UYVY:
-	case V4L2_PIX_FMT_VYUY:
-	case V4L2_PIX_FMT_YUYV:
-	case V4L2_PIX_FMT_YVYU:
+	switch (code) {
+	case V4L2_IMGBUS_FMT_UYVY:
+	case V4L2_IMGBUS_FMT_VYUY:
+	case V4L2_IMGBUS_FMT_YUYV:
+	case V4L2_IMGBUS_FMT_YVYU:
 		if (cam->extra_fmt)
-			goto add_single_format;
+			break;
 
 		/*
 		 * Our case is simple so far: for any of the above four camera
@@ -829,32 +871,31 @@ static int sh_mobile_ceu_get_formats(struct soc_camera_device *icd, int idx,
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
@@ -1034,17 +1075,15 @@ static int client_s_crop(struct v4l2_subdev *sd, struct v4l2_crop *crop,
 static int get_camera_scales(struct v4l2_subdev *sd, struct v4l2_rect *rect,
 			     unsigned int *scale_h, unsigned int *scale_v)
 {
-	struct v4l2_format f;
+	struct v4l2_imgbus_framefmt imgf;
 	int ret;
 
-	f.type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
-
-	ret = v4l2_subdev_call(sd, video, g_fmt, &f);
+	ret = v4l2_subdev_call(sd, video, g_imgbus_fmt, &imgf);
 	if (ret < 0)
 		return ret;
 
-	*scale_h = calc_generic_scale(rect->width, f.fmt.pix.width);
-	*scale_v = calc_generic_scale(rect->height, f.fmt.pix.height);
+	*scale_h = calc_generic_scale(rect->width, imgf.width);
+	*scale_v = calc_generic_scale(rect->height, imgf.height);
 
 	return 0;
 }
@@ -1059,32 +1098,29 @@ static int get_camera_subwin(struct soc_camera_device *icd,
 	if (!ceu_rect->width) {
 		struct v4l2_subdev *sd = soc_camera_to_subdev(icd);
 		struct device *dev = icd->dev.parent;
-		struct v4l2_format f;
-		struct v4l2_pix_format *pix = &f.fmt.pix;
+		struct v4l2_imgbus_framefmt imgf;
 		int ret;
 		/* First time */
 
-		f.type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
-
-		ret = v4l2_subdev_call(sd, video, g_fmt, &f);
+		ret = v4l2_subdev_call(sd, video, g_imgbus_fmt, &imgf);
 		if (ret < 0)
 			return ret;
 
-		dev_geo(dev, "camera fmt %ux%u\n", pix->width, pix->height);
+		dev_geo(dev, "camera fmt %ux%u\n", imgf.width, imgf.height);
 
-		if (pix->width > 2560) {
+		if (imgf.width > 2560) {
 			ceu_rect->width	 = 2560;
-			ceu_rect->left	 = (pix->width - 2560) / 2;
+			ceu_rect->left	 = (imgf.width - 2560) / 2;
 		} else {
-			ceu_rect->width	 = pix->width;
+			ceu_rect->width	 = imgf.width;
 			ceu_rect->left	 = 0;
 		}
 
-		if (pix->height > 1920) {
+		if (imgf.height > 1920) {
 			ceu_rect->height = 1920;
-			ceu_rect->top	 = (pix->height - 1920) / 2;
+			ceu_rect->top	 = (imgf.height - 1920) / 2;
 		} else {
-			ceu_rect->height = pix->height;
+			ceu_rect->height = imgf.height;
 			ceu_rect->top	 = 0;
 		}
 
@@ -1101,13 +1137,12 @@ static int get_camera_subwin(struct soc_camera_device *icd,
 	return 0;
 }
 
-static int client_s_fmt(struct soc_camera_device *icd, struct v4l2_format *f,
-			bool ceu_can_scale)
+static int client_s_fmt(struct soc_camera_device *icd,
+			struct v4l2_imgbus_framefmt *imgf, bool ceu_can_scale)
 {
 	struct v4l2_subdev *sd = soc_camera_to_subdev(icd);
 	struct device *dev = icd->dev.parent;
-	struct v4l2_pix_format *pix = &f->fmt.pix;
-	unsigned int width = pix->width, height = pix->height, tmp_w, tmp_h;
+	unsigned int width = imgf->width, height = imgf->height, tmp_w, tmp_h;
 	unsigned int max_width, max_height;
 	struct v4l2_cropcap cap;
 	int ret;
@@ -1121,29 +1156,29 @@ static int client_s_fmt(struct soc_camera_device *icd, struct v4l2_format *f,
 	max_width = min(cap.bounds.width, 2560);
 	max_height = min(cap.bounds.height, 1920);
 
-	ret = v4l2_subdev_call(sd, video, s_fmt, f);
+	ret = v4l2_subdev_call(sd, video, s_imgbus_fmt, imgf);
 	if (ret < 0)
 		return ret;
 
-	dev_geo(dev, "camera scaled to %ux%u\n", pix->width, pix->height);
+	dev_geo(dev, "camera scaled to %ux%u\n", imgf->width, imgf->height);
 
-	if ((width == pix->width && height == pix->height) || !ceu_can_scale)
+	if ((width == imgf->width && height == imgf->height) || !ceu_can_scale)
 		return 0;
 
 	/* Camera set a format, but geometry is not precise, try to improve */
-	tmp_w = pix->width;
-	tmp_h = pix->height;
+	tmp_w = imgf->width;
+	tmp_h = imgf->height;
 
 	/* width <= max_width && height <= max_height - guaranteed by try_fmt */
 	while ((width > tmp_w || height > tmp_h) &&
 	       tmp_w < max_width && tmp_h < max_height) {
 		tmp_w = min(2 * tmp_w, max_width);
 		tmp_h = min(2 * tmp_h, max_height);
-		pix->width = tmp_w;
-		pix->height = tmp_h;
-		ret = v4l2_subdev_call(sd, video, s_fmt, f);
+		imgf->width = tmp_w;
+		imgf->height = tmp_h;
+		ret = v4l2_subdev_call(sd, video, s_imgbus_fmt, imgf);
 		dev_geo(dev, "Camera scaled to %ux%u\n",
-			pix->width, pix->height);
+			imgf->width, imgf->height);
 		if (ret < 0) {
 			/* This shouldn't happen */
 			dev_err(dev, "Client failed to set format: %d\n", ret);
@@ -1161,27 +1196,26 @@ static int client_s_fmt(struct soc_camera_device *icd, struct v4l2_format *f,
  */
 static int client_scale(struct soc_camera_device *icd, struct v4l2_rect *rect,
 			struct v4l2_rect *sub_rect, struct v4l2_rect *ceu_rect,
-			struct v4l2_format *f, bool ceu_can_scale)
+			struct v4l2_imgbus_framefmt *imgf, bool ceu_can_scale)
 {
 	struct v4l2_subdev *sd = soc_camera_to_subdev(icd);
 	struct sh_mobile_ceu_cam *cam = icd->host_priv;
 	struct device *dev = icd->dev.parent;
-	struct v4l2_format f_tmp = *f;
-	struct v4l2_pix_format *pix_tmp = &f_tmp.fmt.pix;
+	struct v4l2_imgbus_framefmt imgf_tmp = *imgf;
 	unsigned int scale_h, scale_v;
 	int ret;
 
 	/* 5. Apply iterative camera S_FMT for camera user window. */
-	ret = client_s_fmt(icd, &f_tmp, ceu_can_scale);
+	ret = client_s_fmt(icd, &imgf_tmp, ceu_can_scale);
 	if (ret < 0)
 		return ret;
 
 	dev_geo(dev, "5: camera scaled to %ux%u\n",
-		pix_tmp->width, pix_tmp->height);
+		imgf_tmp.width, imgf_tmp.height);
 
 	/* 6. Retrieve camera output window (g_fmt) */
 
-	/* unneeded - it is already in "f_tmp" */
+	/* unneeded - it is already in "imgf_tmp" */
 
 	/* 7. Calculate new camera scales. */
 	ret = get_camera_scales(sd, rect, &scale_h, &scale_v);
@@ -1190,10 +1224,10 @@ static int client_scale(struct soc_camera_device *icd, struct v4l2_rect *rect,
 
 	dev_geo(dev, "7: camera scales %u:%u\n", scale_h, scale_v);
 
-	cam->cam_width		= pix_tmp->width;
-	cam->cam_height		= pix_tmp->height;
-	f->fmt.pix.width	= pix_tmp->width;
-	f->fmt.pix.height	= pix_tmp->height;
+	cam->cam_width	= imgf_tmp.width;
+	cam->cam_height	= imgf_tmp.height;
+	imgf->width	= imgf_tmp.width;
+	imgf->height	= imgf_tmp.height;
 
 	/*
 	 * 8. Calculate new CEU crop - apply camera scales to previously
@@ -1257,8 +1291,7 @@ static int sh_mobile_ceu_set_crop(struct soc_camera_device *icd,
 	struct v4l2_rect *cam_rect = &cam_crop.c, *ceu_rect = &cam->ceu_rect;
 	struct v4l2_subdev *sd = soc_camera_to_subdev(icd);
 	struct device *dev = icd->dev.parent;
-	struct v4l2_format f;
-	struct v4l2_pix_format *pix = &f.fmt.pix;
+	struct v4l2_imgbus_framefmt imgf;
 	unsigned int scale_comb_h, scale_comb_v, scale_ceu_h, scale_ceu_v,
 		out_width, out_height;
 	u32 capsr, cflcr;
@@ -1307,25 +1340,24 @@ static int sh_mobile_ceu_set_crop(struct soc_camera_device *icd,
 	 * 5. Using actual input window and calculated combined scales calculate
 	 *    camera target output window.
 	 */
-	pix->width		= scale_down(cam_rect->width, scale_comb_h);
-	pix->height		= scale_down(cam_rect->height, scale_comb_v);
+	imgf.width	= scale_down(cam_rect->width, scale_comb_h);
+	imgf.height	= scale_down(cam_rect->height, scale_comb_v);
 
-	dev_geo(dev, "5: camera target %ux%u\n", pix->width, pix->height);
+	dev_geo(dev, "5: camera target %ux%u\n", imgf.width, imgf.height);
 
 	/* 6. - 9. */
-	pix->pixelformat	= cam->camera_fmt->fourcc;
-	pix->colorspace		= cam->camera_fmt->colorspace;
+	imgf.code	= cam->code;
+	imgf.field	= pcdev->is_interlaced ? V4L2_FIELD_INTERLACED :
+						V4L2_FIELD_NONE;
 
 	capsr = capture_save_reset(pcdev);
 	dev_dbg(dev, "CAPSR 0x%x, CFLCR 0x%x\n", capsr, pcdev->cflcr);
 
 	/* Make relative to camera rectangle */
-	rect->left		-= cam_rect->left;
-	rect->top		-= cam_rect->top;
-
-	f.type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
+	rect->left	-= cam_rect->left;
+	rect->top	-= cam_rect->top;
 
-	ret = client_scale(icd, cam_rect, rect, ceu_rect, &f,
+	ret = client_scale(icd, cam_rect, rect, ceu_rect, &imgf,
 			   pcdev->image_mode && !pcdev->is_interlaced);
 
 	dev_geo(dev, "6-9: %d\n", ret);
@@ -1373,8 +1405,7 @@ static int sh_mobile_ceu_set_fmt(struct soc_camera_device *icd,
 	struct sh_mobile_ceu_dev *pcdev = ici->priv;
 	struct sh_mobile_ceu_cam *cam = icd->host_priv;
 	struct v4l2_pix_format *pix = &f->fmt.pix;
-	struct v4l2_format cam_f = *f;
-	struct v4l2_pix_format *cam_pix = &cam_f.fmt.pix;
+	struct v4l2_imgbus_framefmt imgf;
 	struct v4l2_subdev *sd = soc_camera_to_subdev(icd);
 	struct device *dev = icd->dev.parent;
 	__u32 pixfmt = pix->pixelformat;
@@ -1443,9 +1474,10 @@ static int sh_mobile_ceu_set_fmt(struct soc_camera_device *icd,
 	 * 4. Calculate camera output window by applying combined scales to real
 	 *    input window.
 	 */
-	cam_pix->width = scale_down(cam_rect->width, scale_h);
-	cam_pix->height = scale_down(cam_rect->height, scale_v);
-	cam_pix->pixelformat = xlate->cam_fmt->fourcc;
+	imgf.width	= scale_down(cam_rect->width, scale_h);
+	imgf.height	= scale_down(cam_rect->height, scale_v);
+	imgf.code	= xlate->code;
+	imgf.field	= pix->field;
 
 	switch (pixfmt) {
 	case V4L2_PIX_FMT_NV12:
@@ -1458,11 +1490,10 @@ static int sh_mobile_ceu_set_fmt(struct soc_camera_device *icd,
 		image_mode = false;
 	}
 
-	dev_geo(dev, "4: camera output %ux%u\n",
-		cam_pix->width, cam_pix->height);
+	dev_geo(dev, "4: camera output %ux%u\n", imgf.width, imgf.height);
 
 	/* 5. - 9. */
-	ret = client_scale(icd, cam_rect, &cam_subrect, &ceu_rect, &cam_f,
+	ret = client_scale(icd, cam_rect, &cam_subrect, &ceu_rect, &imgf,
 			   image_mode && !is_interlaced);
 
 	dev_geo(dev, "5-9: client scale %d\n", ret);
@@ -1470,20 +1501,20 @@ static int sh_mobile_ceu_set_fmt(struct soc_camera_device *icd,
 	/* Done with the camera. Now see if we can improve the result */
 
 	dev_dbg(dev, "Camera %d fmt %ux%u, requested %ux%u\n",
-		ret, cam_pix->width, cam_pix->height, pix->width, pix->height);
+		ret, imgf.width, imgf.height, pix->width, pix->height);
 	if (ret < 0)
 		return ret;
 
 	/* 10. Use CEU scaling to scale to the requested user window. */
 
 	/* We cannot scale up */
-	if (pix->width > cam_pix->width)
-		pix->width = cam_pix->width;
+	if (pix->width > imgf.width)
+		pix->width = imgf.width;
 	if (pix->width > ceu_rect.width)
 		pix->width = ceu_rect.width;
 
-	if (pix->height > cam_pix->height)
-		pix->height = cam_pix->height;
+	if (pix->height > imgf.height)
+		pix->height = imgf.height;
 	if (pix->height > ceu_rect.height)
 		pix->height = ceu_rect.height;
 
@@ -1497,10 +1528,9 @@ static int sh_mobile_ceu_set_fmt(struct soc_camera_device *icd,
 
 	pcdev->cflcr = scale_h | (scale_v << 16);
 
-	icd->buswidth = xlate->buswidth;
-	icd->current_fmt = xlate->host_fmt;
-	cam->camera_fmt = xlate->cam_fmt;
-	cam->ceu_rect = ceu_rect;
+	cam->code		= xlate->code;
+	cam->ceu_rect		= ceu_rect;
+	icd->current_fmt	= xlate;
 
 	pcdev->is_interlaced = is_interlaced;
 	pcdev->image_mode = image_mode;
@@ -1514,6 +1544,7 @@ static int sh_mobile_ceu_try_fmt(struct soc_camera_device *icd,
 	const struct soc_camera_format_xlate *xlate;
 	struct v4l2_pix_format *pix = &f->fmt.pix;
 	struct v4l2_subdev *sd = soc_camera_to_subdev(icd);
+	struct v4l2_imgbus_framefmt imgf;
 	__u32 pixfmt = pix->pixelformat;
 	int width, height;
 	int ret;
@@ -1532,18 +1563,24 @@ static int sh_mobile_ceu_try_fmt(struct soc_camera_device *icd,
 	width = pix->width;
 	height = pix->height;
 
-	pix->bytesperline = pix->width *
-		DIV_ROUND_UP(xlate->host_fmt->depth, 8);
-	pix->sizeimage = pix->height * pix->bytesperline;
-
-	pix->pixelformat = xlate->cam_fmt->fourcc;
+	pix->bytesperline = v4l2_imgbus_bytes_per_line(width, xlate->host_fmt);
+	if (pix->bytesperline < 0)
+		return pix->bytesperline;
+	pix->sizeimage = height * pix->bytesperline;
 
 	/* limit to sensor capabilities */
-	ret = v4l2_subdev_call(sd, video, try_fmt, f);
-	pix->pixelformat = pixfmt;
+	imgf.width	= pix->width;
+	imgf.height	= pix->height;
+	imgf.field	= pix->field;
+	imgf.code	= xlate->code;
+	ret = v4l2_subdev_call(sd, video, try_imgbus_fmt, &imgf);
 	if (ret < 0)
 		return ret;
 
+	pix->width	= imgf.width;
+	pix->height	= imgf.height;
+	pix->field	= imgf.field;
+
 	switch (pixfmt) {
 	case V4L2_PIX_FMT_NV12:
 	case V4L2_PIX_FMT_NV21:
@@ -1555,7 +1592,7 @@ static int sh_mobile_ceu_try_fmt(struct soc_camera_device *icd,
 			int tmp_w = pix->width, tmp_h = pix->height;
 			pix->width = 2560;
 			pix->height = 1920;
-			ret = v4l2_subdev_call(sd, video, try_fmt, f);
+			ret = v4l2_subdev_call(sd, video, try_imgbus_fmt, &imgf);
 			if (ret < 0) {
 				/* Shouldn't actually happen... */
 				dev_err(icd->dev.parent,
@@ -1661,7 +1698,7 @@ static int sh_mobile_ceu_set_ctrl(struct soc_camera_device *icd,
 
 	switch (ctrl->id) {
 	case V4L2_CID_SHARPNESS:
-		switch (icd->current_fmt->fourcc) {
+		switch (icd->current_fmt->host_fmt->fourcc) {
 		case V4L2_PIX_FMT_NV12:
 		case V4L2_PIX_FMT_NV21:
 		case V4L2_PIX_FMT_NV16:
diff --git a/drivers/media/video/soc_camera.c b/drivers/media/video/soc_camera.c
index bf77935..7c624f9 100644
--- a/drivers/media/video/soc_camera.c
+++ b/drivers/media/video/soc_camera.c
@@ -40,18 +40,6 @@ static LIST_HEAD(hosts);
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
@@ -207,21 +195,26 @@ static int soc_camera_dqbuf(struct file *file, void *priv,
 /* Always entered with .video_lock held */
 static int soc_camera_init_user_formats(struct soc_camera_device *icd)
 {
+	struct v4l2_subdev *sd = soc_camera_to_subdev(icd);
 	struct soc_camera_host *ici = to_soc_camera_host(icd->dev.parent);
-	int i, fmts = 0, ret;
+	int i, fmts = 0, raw_fmts = 0, ret;
+	enum v4l2_imgbus_pixelcode code;
+
+	while (!v4l2_subdev_call(sd, video, enum_imgbus_fmt, raw_fmts, &code))
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
@@ -242,11 +235,11 @@ static int soc_camera_init_user_formats(struct soc_camera_device *icd)
 
 	/* Second pass - actually fill data formats */
 	fmts = 0;
-	for (i = 0; i < icd->num_formats; i++)
+	for (i = 0; i < raw_fmts; i++)
 		if (!ici->ops->get_formats) {
-			icd->user_formats[i].host_fmt = icd->formats + i;
-			icd->user_formats[i].cam_fmt = icd->formats + i;
-			icd->user_formats[i].buswidth = icd->formats[i].depth;
+			v4l2_subdev_call(sd, video, enum_imgbus_fmt, i, &code);
+			icd->user_formats[i].host_fmt = v4l2_imgbus_get_fmtdesc(code);
+			icd->user_formats[i].code = code;
 		} else {
 			ret = ici->ops->get_formats(icd, i,
 						    &icd->user_formats[fmts]);
@@ -255,7 +248,7 @@ static int soc_camera_init_user_formats(struct soc_camera_device *icd)
 			fmts += ret;
 		}
 
-	icd->current_fmt = icd->user_formats[0].host_fmt;
+	icd->current_fmt = &icd->user_formats[0];
 
 	return 0;
 
@@ -281,7 +274,7 @@ static void soc_camera_free_user_formats(struct soc_camera_device *icd)
 #define pixfmtstr(x) (x) & 0xff, ((x) >> 8) & 0xff, ((x) >> 16) & 0xff, \
 	((x) >> 24) & 0xff
 
-/* Called with .vb_lock held */
+/* Called with .vb_lock held, or from the first open(2), see comment there */
 static int soc_camera_set_fmt(struct soc_camera_file *icf,
 			      struct v4l2_format *f)
 {
@@ -302,7 +295,7 @@ static int soc_camera_set_fmt(struct soc_camera_file *icf,
 	if (ret < 0) {
 		return ret;
 	} else if (!icd->current_fmt ||
-		   icd->current_fmt->fourcc != pix->pixelformat) {
+		   icd->current_fmt->host_fmt->fourcc != pix->pixelformat) {
 		dev_err(&icd->dev,
 			"Host driver hasn't set up current format correctly!\n");
 		return -EINVAL;
@@ -369,8 +362,8 @@ static int soc_camera_open(struct file *file)
 				.width		= icd->user_width,
 				.height		= icd->user_height,
 				.field		= icd->field,
-				.pixelformat	= icd->current_fmt->fourcc,
-				.colorspace	= icd->current_fmt->colorspace,
+				.pixelformat	= icd->current_fmt->host_fmt->fourcc,
+				.colorspace	= icd->current_fmt->host_fmt->colorspace,
 			},
 		};
 
@@ -390,7 +383,12 @@ static int soc_camera_open(struct file *file)
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
@@ -534,7 +532,7 @@ static int soc_camera_enum_fmt_vid_cap(struct file *file, void  *priv,
 {
 	struct soc_camera_file *icf = file->private_data;
 	struct soc_camera_device *icd = icf->icd;
-	const struct soc_camera_data_format *format;
+	const struct v4l2_imgbus_pixelfmt *format;
 
 	WARN_ON(priv != file->private_data);
 
@@ -543,7 +541,8 @@ static int soc_camera_enum_fmt_vid_cap(struct file *file, void  *priv,
 
 	format = icd->user_formats[f->index].host_fmt;
 
-	strlcpy(f->description, format->name, sizeof(f->description));
+	if (format->name)
+		strlcpy(f->description, format->name, sizeof(f->description));
 	f->pixelformat = format->fourcc;
 	return 0;
 }
@@ -560,12 +559,14 @@ static int soc_camera_g_fmt_vid_cap(struct file *file, void *priv,
 	pix->width		= icd->user_width;
 	pix->height		= icd->user_height;
 	pix->field		= icf->vb_vidq.field;
-	pix->pixelformat	= icd->current_fmt->fourcc;
-	pix->bytesperline	= pix->width *
-		DIV_ROUND_UP(icd->current_fmt->depth, 8);
+	pix->pixelformat	= icd->current_fmt->host_fmt->fourcc;
+	pix->bytesperline	= v4l2_imgbus_bytes_per_line(pix->width,
+						icd->current_fmt->host_fmt);
+	if (pix->bytesperline < 0)
+		return pix->bytesperline;
 	pix->sizeimage		= pix->height * pix->bytesperline;
 	dev_dbg(&icd->dev, "current_fmt->fourcc: 0x%08x\n",
-		icd->current_fmt->fourcc);
+		icd->current_fmt->host_fmt->fourcc);
 	return 0;
 }
 
@@ -894,7 +895,7 @@ static int soc_camera_probe(struct device *dev)
 	struct soc_camera_link *icl = to_soc_camera_link(icd);
 	struct device *control = NULL;
 	struct v4l2_subdev *sd;
-	struct v4l2_format f = {.type = V4L2_BUF_TYPE_VIDEO_CAPTURE};
+	struct v4l2_imgbus_framefmt imgf;
 	int ret;
 
 	dev_info(dev, "Probing %s\n", dev_name(dev));
@@ -965,9 +966,10 @@ static int soc_camera_probe(struct device *dev)
 
 	/* Try to improve our guess of a reasonable window format */
 	sd = soc_camera_to_subdev(icd);
-	if (!v4l2_subdev_call(sd, video, g_fmt, &f)) {
-		icd->user_width		= f.fmt.pix.width;
-		icd->user_height	= f.fmt.pix.height;
+	if (!v4l2_subdev_call(sd, video, g_imgbus_fmt, &imgf)) {
+		icd->user_width		= imgf.width;
+		icd->user_height	= imgf.height;
+		icd->field		= imgf.field;
 	}
 
 	/* Do we have to sysfs_remove_link() before device_unregister()? */
diff --git a/drivers/media/video/soc_camera_platform.c b/drivers/media/video/soc_camera_platform.c
index c7c9151..573480c 100644
--- a/drivers/media/video/soc_camera_platform.c
+++ b/drivers/media/video/soc_camera_platform.c
@@ -22,7 +22,7 @@
 
 struct soc_camera_platform_priv {
 	struct v4l2_subdev subdev;
-	struct soc_camera_data_format format;
+	struct v4l2_imgbus_framefmt format;
 };
 
 static struct soc_camera_platform_priv *get_priv(struct platform_device *pdev)
@@ -58,36 +58,33 @@ soc_camera_platform_query_bus_param(struct soc_camera_device *icd)
 }
 
 static int soc_camera_platform_try_fmt(struct v4l2_subdev *sd,
-				       struct v4l2_format *f)
+				       struct v4l2_imgbus_framefmt *imgf)
 {
 	struct soc_camera_platform_info *p = v4l2_get_subdevdata(sd);
-	struct v4l2_pix_format *pix = &f->fmt.pix;
 
-	pix->width = p->format.width;
-	pix->height = p->format.height;
+	imgf->width = p->format.width;
+	imgf->height = p->format.height;
 	return 0;
 }
 
-static void soc_camera_platform_video_probe(struct soc_camera_device *icd,
-					    struct platform_device *pdev)
+static struct v4l2_subdev_core_ops platform_subdev_core_ops;
+
+static int soc_camera_platform_enum_fmt(struct v4l2_subdev *sd, int index,
+					enum v4l2_imgbus_pixelcode *code)
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
-	.s_stream	= soc_camera_platform_s_stream,
-	.try_fmt	= soc_camera_platform_try_fmt,
+	.s_stream		= soc_camera_platform_s_stream,
+	.try_imgbus_fmt		= soc_camera_platform_try_fmt,
+	.enum_imgbus_fmt	= soc_camera_platform_enum_fmt,
 };
 
 static struct v4l2_subdev_ops platform_subdev_ops = {
@@ -132,8 +129,6 @@ static int soc_camera_platform_probe(struct platform_device *pdev)
 
 	ici = to_soc_camera_host(icd->dev.parent);
 
-	soc_camera_platform_video_probe(icd, pdev);
-
 	v4l2_subdev_init(&priv->subdev, &platform_subdev_ops);
 	v4l2_set_subdevdata(&priv->subdev, p);
 	strncpy(priv->subdev.name, dev_name(&pdev->dev), V4L2_SUBDEV_NAME_SIZE);
diff --git a/drivers/media/video/tw9910.c b/drivers/media/video/tw9910.c
index 35373d8..09ea042 100644
--- a/drivers/media/video/tw9910.c
+++ b/drivers/media/video/tw9910.c
@@ -240,13 +240,8 @@ static const struct regval_list tw9910_default_regs[] =
 	ENDMARKER,
 };
 
-static const struct soc_camera_data_format tw9910_color_fmt[] = {
-	{
-		.name       = "VYUY",
-		.fourcc     = V4L2_PIX_FMT_VYUY,
-		.depth      = 16,
-		.colorspace = V4L2_COLORSPACE_SMPTE170M,
-	}
+static const enum v4l2_imgbus_pixelcode tw9910_color_codes[] = {
+	V4L2_IMGBUS_FMT_VYUY,
 };
 
 static const struct tw9910_scale_ctrl tw9910_ntsc_scales[] = {
@@ -762,11 +757,11 @@ static int tw9910_cropcap(struct v4l2_subdev *sd, struct v4l2_cropcap *a)
 	return 0;
 }
 
-static int tw9910_g_fmt(struct v4l2_subdev *sd, struct v4l2_format *f)
+static int tw9910_g_fmt(struct v4l2_subdev *sd,
+			struct v4l2_imgbus_framefmt *imgf)
 {
 	struct i2c_client *client = sd->priv;
 	struct tw9910_priv *priv = to_tw9910(client);
-	struct v4l2_pix_format *pix = &f->fmt.pix;
 
 	if (!priv->scale) {
 		int ret;
@@ -783,74 +778,74 @@ static int tw9910_g_fmt(struct v4l2_subdev *sd, struct v4l2_format *f)
 			return ret;
 	}
 
-	f->type			= V4L2_BUF_TYPE_VIDEO_CAPTURE;
-
-	pix->width		= priv->scale->width;
-	pix->height		= priv->scale->height;
-	pix->pixelformat	= V4L2_PIX_FMT_VYUY;
-	pix->colorspace		= V4L2_COLORSPACE_SMPTE170M;
-	pix->field		= V4L2_FIELD_INTERLACED;
+	imgf->width	= priv->scale->width;
+	imgf->height	= priv->scale->height;
+	imgf->code	= V4L2_IMGBUS_FMT_VYUY;
+	imgf->field	= V4L2_FIELD_INTERLACED;
 
 	return 0;
 }
 
-static int tw9910_s_fmt(struct v4l2_subdev *sd, struct v4l2_format *f)
+static int tw9910_s_fmt(struct v4l2_subdev *sd,
+			struct v4l2_imgbus_framefmt *imgf)
 {
 	struct i2c_client *client = sd->priv;
 	struct tw9910_priv *priv = to_tw9910(client);
-	struct v4l2_pix_format *pix = &f->fmt.pix;
 	/* See tw9910_s_crop() - no proper cropping support */
 	struct v4l2_crop a = {
 		.c = {
 			.left	= 0,
 			.top	= 0,
-			.width	= pix->width,
-			.height	= pix->height,
+			.width	= imgf->width,
+			.height	= imgf->height,
 		},
 	};
 	int i, ret;
 
+	WARN_ON(imgf->field != V4L2_FIELD_ANY &&
+		imgf->field != V4L2_FIELD_INTERLACED);
+
 	/*
 	 * check color format
 	 */
-	for (i = 0; i < ARRAY_SIZE(tw9910_color_fmt); i++)
-		if (pix->pixelformat == tw9910_color_fmt[i].fourcc)
+	for (i = 0; i < ARRAY_SIZE(tw9910_color_codes); i++)
+		if (imgf->code == tw9910_color_codes[i])
 			break;
 
-	if (i == ARRAY_SIZE(tw9910_color_fmt))
+	if (i == ARRAY_SIZE(tw9910_color_codes))
 		return -EINVAL;
 
 	ret = tw9910_s_crop(sd, &a);
 	if (!ret) {
-		pix->width = priv->scale->width;
-		pix->height = priv->scale->height;
+		imgf->width	= priv->scale->width;
+		imgf->height	= priv->scale->height;
 	}
 	return ret;
 }
 
-static int tw9910_try_fmt(struct v4l2_subdev *sd, struct v4l2_format *f)
+static int tw9910_try_fmt(struct v4l2_subdev *sd,
+			  struct v4l2_imgbus_framefmt *imgf)
 {
 	struct i2c_client *client = sd->priv;
 	struct soc_camera_device *icd = client->dev.platform_data;
-	struct v4l2_pix_format *pix = &f->fmt.pix;
 	const struct tw9910_scale_ctrl *scale;
 
-	if (V4L2_FIELD_ANY == pix->field) {
-		pix->field = V4L2_FIELD_INTERLACED;
-	} else if (V4L2_FIELD_INTERLACED != pix->field) {
-		dev_err(&client->dev, "Field type invalid.\n");
+	if (V4L2_FIELD_ANY == imgf->field) {
+		imgf->field = V4L2_FIELD_INTERLACED;
+	} else if (V4L2_FIELD_INTERLACED != imgf->field) {
+		dev_err(&client->dev, "Field type %d invalid.\n", imgf->field);
 		return -EINVAL;
 	}
 
 	/*
 	 * select suitable norm
 	 */
-	scale = tw9910_select_norm(icd, pix->width, pix->height);
+	scale = tw9910_select_norm(icd, imgf->width, imgf->height);
 	if (!scale)
 		return -EINVAL;
 
-	pix->width  = scale->width;
-	pix->height = scale->height;
+	imgf->width	= scale->width;
+	imgf->height	= scale->height;
 
 	return 0;
 }
@@ -878,9 +873,6 @@ static int tw9910_video_probe(struct soc_camera_device *icd,
 		return -ENODEV;
 	}
 
-	icd->formats     = tw9910_color_fmt;
-	icd->num_formats = ARRAY_SIZE(tw9910_color_fmt);
-
 	/*
 	 * check and show Product ID
 	 * So far only revisions 0 and 1 have been seen
@@ -918,14 +910,25 @@ static struct v4l2_subdev_core_ops tw9910_subdev_core_ops = {
 #endif
 };
 
+static int tw9910_enum_fmt(struct v4l2_subdev *sd, int index,
+			   enum v4l2_imgbus_pixelcode *code)
+{
+	if ((unsigned int)index >= ARRAY_SIZE(tw9910_color_codes))
+		return -EINVAL;
+
+	*code = tw9910_color_codes[index];
+	return 0;
+}
+
 static struct v4l2_subdev_video_ops tw9910_subdev_video_ops = {
-	.s_stream	= tw9910_s_stream,
-	.g_fmt		= tw9910_g_fmt,
-	.s_fmt		= tw9910_s_fmt,
-	.try_fmt	= tw9910_try_fmt,
-	.cropcap	= tw9910_cropcap,
-	.g_crop		= tw9910_g_crop,
-	.s_crop		= tw9910_s_crop,
+	.s_stream		= tw9910_s_stream,
+	.g_imgbus_fmt		= tw9910_g_fmt,
+	.s_imgbus_fmt		= tw9910_s_fmt,
+	.try_imgbus_fmt		= tw9910_try_fmt,
+	.cropcap		= tw9910_cropcap,
+	.g_crop			= tw9910_g_crop,
+	.s_crop			= tw9910_s_crop,
+	.enum_imgbus_fmt	= tw9910_enum_fmt,
 };
 
 static struct v4l2_subdev_ops tw9910_subdev_ops = {
diff --git a/include/media/rj54n1cb0c.h b/include/media/rj54n1cb0c.h
new file mode 100644
index 0000000..8ae3288
--- /dev/null
+++ b/include/media/rj54n1cb0c.h
@@ -0,0 +1,19 @@
+/*
+ * RJ54N1CB0C Private data
+ *
+ * Copyright (C) 2009, Guennadi Liakhovetski <g.liakhovetski@gmx.de>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#ifndef __RJ54N1CB0C_H__
+#define __RJ54N1CB0C_H__
+
+struct rj54n1_pdata {
+	unsigned int	mclk_freq;
+	bool		ioctl_high;
+};
+
+#endif
diff --git a/include/media/soc_camera.h b/include/media/soc_camera.h
index 831efff..d0ef622 100644
--- a/include/media/soc_camera.h
+++ b/include/media/soc_camera.h
@@ -26,13 +26,10 @@ struct soc_camera_device {
 	s32 user_height;
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
@@ -161,23 +158,13 @@ static inline struct v4l2_subdev *soc_camera_to_subdev(
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
@@ -185,9 +172,8 @@ struct soc_camera_data_format {
  * format setup.
  */
 struct soc_camera_format_xlate {
-	const struct soc_camera_data_format *cam_fmt;
-	const struct soc_camera_data_format *host_fmt;
-	unsigned char buswidth;
+	enum v4l2_imgbus_pixelcode code;
+	const struct v4l2_imgbus_pixelfmt *host_fmt;
 };
 
 struct soc_camera_ops {
diff --git a/include/media/soc_camera_platform.h b/include/media/soc_camera_platform.h
index 88b3b57..a105268 100644
--- a/include/media/soc_camera_platform.h
+++ b/include/media/soc_camera_platform.h
@@ -19,7 +19,7 @@ struct device;
 struct soc_camera_platform_info {
 	const char *format_name;
 	unsigned long format_depth;
-	struct v4l2_pix_format format;
+	struct v4l2_imgbus_framefmt format;
 	unsigned long bus_param;
 	struct device *dev;
 	int (*set_capture)(struct soc_camera_platform_info *info, int enable);
-- 
1.6.2.4

