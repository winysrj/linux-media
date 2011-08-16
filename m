Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:38902 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751377Ab1HPM7F (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 16 Aug 2011 08:59:05 -0400
Received: by fxh19 with SMTP id 19so4173451fxh.19
        for <linux-media@vger.kernel.org>; Tue, 16 Aug 2011 05:59:04 -0700 (PDT)
Date: Tue, 16 Aug 2011 12:58:58 +0000 (UTC)
From: Bastian Hecht <hechtb@googlemail.com>
To: linux-media@vger.kernel.org
cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: [PATCH] media: Added extensive feature set to the OV5642 camera
 driver
Message-ID: <alpine.DEB.2.02.1108161255100.16286@ipanema>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The driver now supports arbitray resolutions (width up to 2592, height
up to 720), automatic/manual gain, automatic/manual white balance,
automatic/manual exposure control, vertical flip, brightness control,
contrast control and saturation control. Additionally the following
effects are available now: rotating the hue in the colorspace, gray
scale image and solarize effect.

Signed-of-by: Bastian Hecht <hechtb@gmail.com>

---
diff --git a/drivers/media/video/ov5642.c b/drivers/media/video/ov5642.c
index 6410bda..069a720 100644
--- a/drivers/media/video/ov5642.c
+++ b/drivers/media/video/ov5642.c
@@ -14,8 +14,10 @@
  * published by the Free Software Foundation.
  */
 
+#include <linux/bitops.h>
 #include <linux/delay.h>
 #include <linux/i2c.h>
+#include <linux/kernel.h>
 #include <linux/slab.h>
 #include <linux/videodev2.h>
 
@@ -28,13 +30,25 @@
 #define REG_CHIP_ID_HIGH		0x300a
 #define REG_CHIP_ID_LOW			0x300b
 
+#define REG_RED_GAIN_HIGH		0x3400
+#define REG_RED_GAIN_LOW		0x3401
+#define REG_BLUE_GAIN_HIGH		0x3404
+#define REG_BLUE_GAIN_LOW		0x3405
+#define REG_AWB_MANUAL			0x3406
+#define REG_EXP_HIGH			0x3500
+#define REG_EXP_MIDDLE			0x3501
+#define REG_EXP_LOW			0x3502
+#define REG_EXP_GAIN_CTRL		0x3503
+#define REG_GAIN			0x350b
+#define REG_EXTEND_FRAME_TIME_HIGH	0x350c
+#define REG_EXTEND_FRAME_TIME_LOW	0x350d
 #define REG_WINDOW_START_X_HIGH		0x3800
 #define REG_WINDOW_START_X_LOW		0x3801
 #define REG_WINDOW_START_Y_HIGH		0x3802
 #define REG_WINDOW_START_Y_LOW		0x3803
 #define REG_WINDOW_WIDTH_HIGH		0x3804
 #define REG_WINDOW_WIDTH_LOW		0x3805
-#define REG_WINDOW_HEIGHT_HIGH 		0x3806
+#define REG_WINDOW_HEIGHT_HIGH		0x3806
 #define REG_WINDOW_HEIGHT_LOW		0x3807
 #define REG_OUT_WIDTH_HIGH		0x3808
 #define REG_OUT_WIDTH_LOW		0x3809
@@ -44,19 +58,87 @@
 #define REG_OUT_TOTAL_WIDTH_LOW		0x380d
 #define REG_OUT_TOTAL_HEIGHT_HIGH	0x380e
 #define REG_OUT_TOTAL_HEIGHT_LOW	0x380f
+#define REG_FLIP_SUBSAMPLE		0x3818
+#define REG_OUTPUT_FORMAT		0x4300
+#define REG_ISP_CTRL_01			0x5001
+#define REG_DIGITAL_EFFECTS		0x5580
+#define REG_HUE_COS			0x5581
+#define REG_HUE_SIN			0x5582
+#define REG_BLUE_SATURATION		0x5583
+#define REG_RED_SATURATION		0x5584
+#define REG_CONTRAST			0x5588
+#define REG_BRIGHTNESS			0x5589
+#define REG_D_E_AUXILLARY		0x558a
+#define REG_AVG_WINDOW_END_X_HIGH	0x5682
+#define REG_AVG_WINDOW_END_X_LOW	0x5683
+#define REG_AVG_WINDOW_END_Y_HIGH	0x5686
+#define REG_AVG_WINDOW_END_Y_LOW	0x5687
+
+/* default values in native space */
+#define DEFAULT_RBBALANCE		0x400
+#define DEFAULT_CONTRAST		0x20
+#define DEFAULT_SATURATION		0x40
+
+#define MAX_EXP_NATIVE			0x01ffff
+#define MAX_GAIN_NATIVE			0x1f
+#define MAX_RBBALANCE_NATIVE		0x0fff
+#define MAX_EXP				0xffff
+#define MAX_GAIN			0xff
+#define MAX_RBBALANCE			0xff
+#define MAX_HUE_TRIG_NATIVE		0x80
+
+#define OV5642_CONTROL_BLUE_SATURATION	(V4L2_CID_PRIVATE_BASE + 0)
+#define OV5642_CONTROL_RED_SATURATION	(V4L2_CID_PRIVATE_BASE + 1)
+#define OV5642_CONTROL_GRAY_SCALE	(V4L2_CID_PRIVATE_BASE + 2)
+#define OV5642_CONTROL_SOLARIZE		(V4L2_CID_PRIVATE_BASE + 3)
+
+#define EXP_V4L2_TO_NATIVE(x) ((x) << 4)
+#define EXP_NATIVE_TO_V4L2(x) ((x) >> 4)
+#define GAIN_V4L2_TO_NATIVE(x) ((x) * MAX_GAIN_NATIVE / MAX_GAIN)
+#define GAIN_NATIVE_TO_V4L2(x) ((x) * MAX_GAIN / MAX_GAIN_NATIVE)
+#define RBBALANCE_V4L2_TO_NATIVE(x) ((x) * MAX_RBBALANCE_NATIVE / MAX_RBBALANCE)
+#define RBBALANCE_NATIVE_TO_V4L2(x) ((x) * MAX_RBBALANCE / MAX_RBBALANCE_NATIVE)
+
+/* flaw in the datasheet. we need some extra lines */
+#define MANUAL_LONG_EXP_SAFETY_DISTANCE	20
+
+/* active pixel array size */
+#define OV5642_SENSOR_SIZE_X	2592
+#define OV5642_SENSOR_SIZE_Y	1944
+
+/* current maximum working size */
+#define OV5642_MAX_WIDTH	OV5642_SENSOR_SIZE_X
+#define OV5642_MAX_HEIGHT	720
+
+/* default sizes */
+#define OV5642_DEFAULT_WIDTH	1280
+#define OV5642_DEFAULT_HEIGHT	OV5642_MAX_HEIGHT
+
+/* minimum extra blanking */
+#define BLANKING_EXTRA_WIDTH		500
+#define BLANKING_EXTRA_HEIGHT		20
 
 /*
- * define standard resolution.
- * Works currently only for up to 720 lines
- * eg. 320x240, 640x480, 800x600, 1280x720, 2048x720
+ * the sensor's autoexposure is buggy when setting total_height low.
+ * It tries to expose longer than 1 frame period without taking care of it
+ * and this leads to weird output. So we set 1000 lines as minimum.
  */
 
-#define OV5642_WIDTH		1280
-#define OV5642_HEIGHT		720
-#define OV5642_TOTAL_WIDTH	3200
-#define OV5642_TOTAL_HEIGHT	2000
-#define OV5642_SENSOR_SIZE_X	2592
-#define OV5642_SENSOR_SIZE_Y	1944
+#define BLANKING_MIN_HEIGHT		1000
+
+/*
+ * About OV5642 resolution, cropping and binning:
+ * This sensor supports it all, at least in the feature description.
+ * Unfortunately, no combination of appropriate registers settings could make
+ * the chip work the intended way. As it works with predefined register lists,
+ * some undocumented registers are presumably changed there to achieve their
+ * goals.
+ * This driver currently only works for resolutions up to 720 lines with a
+ * 1:1 scale. Hopefully these restrictions will be removed in the future.
+ */
+
+static int ov5642_s_ctrl(struct v4l2_subdev *sd, struct v4l2_control *ctrl);
+static int ov5642_g_ctrl(struct v4l2_subdev *sd, struct v4l2_control *ctrl);
 
 struct regval_list {
 	u16 reg_num;
@@ -105,10 +187,8 @@ static struct regval_list ov5642_default_regs_init[] = {
 	{ 0x471d, 0x5  },
 	{ 0x4708, 0x6  },
 	{ 0x370c, 0xa0 },
-	{ 0x5687, 0x94 },
 	{ 0x501f, 0x0  },
 	{ 0x5000, 0x4f },
-	{ 0x5001, 0xcf },
 	{ 0x4300, 0x30 },
 	{ 0x4300, 0x30 },
 	{ 0x460b, 0x35 },
@@ -121,11 +201,8 @@ static struct regval_list ov5642_default_regs_init[] = {
 	{ 0x4402, 0x90 },
 	{ 0x460c, 0x22 },
 	{ 0x3815, 0x44 },
-	{ 0x3503, 0x7  },
 	{ 0x3501, 0x73 },
 	{ 0x3502, 0x80 },
-	{ 0x350b, 0x0  },
-	{ 0x3818, 0xc8 },
 	{ 0x3824, 0x11 },
 	{ 0x3a00, 0x78 },
 	{ 0x3a1a, 0x4  },
@@ -140,12 +217,6 @@ static struct regval_list ov5642_default_regs_init[] = {
 	{ 0x350d, 0xd0 },
 	{ 0x3a0d, 0x8  },
 	{ 0x3a0e, 0x6  },
-	{ 0x3500, 0x0  },
-	{ 0x3501, 0x0  },
-	{ 0x3502, 0x0  },
-	{ 0x350a, 0x0  },
-	{ 0x350b, 0x0  },
-	{ 0x3503, 0x0  },
 	{ 0x3a0f, 0x3c },
 	{ 0x3a10, 0x32 },
 	{ 0x3a1b, 0x3c },
@@ -298,7 +369,7 @@ static struct regval_list ov5642_default_regs_init[] = {
 	{ 0x54b7, 0xdf },
 	{ 0x5402, 0x3f },
 	{ 0x5403, 0x0  },
-	{ 0x3406, 0x0  },
+	{ REG_AWB_MANUAL, 0x0  },
 	{ 0x5180, 0xff },
 	{ 0x5181, 0x52 },
 	{ 0x5182, 0x11 },
@@ -515,7 +586,6 @@ static struct regval_list ov5642_default_regs_init[] = {
 	{ 0x5088, 0x0  },
 	{ 0x5089, 0x0  },
 	{ 0x302b, 0x0  },
-	{ 0x3503, 0x7  },
 	{ 0x3011, 0x8  },
 	{ 0x350c, 0x2  },
 	{ 0x350d, 0xe4 },
@@ -526,7 +596,6 @@ static struct regval_list ov5642_default_regs_init[] = {
 
 static struct regval_list ov5642_default_regs_finalise[] = {
 	{ 0x3810, 0xc2 },
-	{ 0x3818, 0xc9 },
 	{ 0x381c, 0x10 },
 	{ 0x381d, 0xa0 },
 	{ 0x381e, 0x5  },
@@ -541,23 +610,20 @@ static struct regval_list ov5642_default_regs_finalise[] = {
 	{ 0x3a0d, 0x2  },
 	{ 0x3a0e, 0x1  },
 	{ 0x401c, 0x4  },
-	{ 0x5682, 0x5  },
-	{ 0x5683, 0x0  },
-	{ 0x5686, 0x2  },
-	{ 0x5687, 0xcc },
-	{ 0x5001, 0x4f },
+	{ REG_ISP_CTRL_01, 0xff },
+	{ REG_DIGITAL_EFFECTS, 0x6 },
 	{ 0x589b, 0x6  },
 	{ 0x589a, 0xc5 },
-	{ 0x3503, 0x0  },
+	{ REG_EXP_GAIN_CTRL, 0x0  },
 	{ 0x460c, 0x20 },
 	{ 0x460b, 0x37 },
 	{ 0x471c, 0xd0 },
 	{ 0x471d, 0x5  },
 	{ 0x3815, 0x1  },
-	{ 0x3818, 0xc1 },
+	{ REG_FLIP_SUBSAMPLE, 0xc1 },
 	{ 0x501f, 0x0  },
 	{ 0x5002, 0xe0 },
-	{ 0x4300, 0x32 }, /* UYVY */
+	{ REG_OUTPUT_FORMAT, 0x32 },
 	{ 0x3002, 0x1c },
 	{ 0x4800, 0x14 },
 	{ 0x4801, 0xf  },
@@ -573,14 +639,182 @@ static struct regval_list ov5642_default_regs_finalise[] = {
 	{ 0xffff, 0xff },
 };
 
+static const struct v4l2_queryctrl ov5642_controls[] = {
+	{
+		.id		= V4L2_CID_AUTOGAIN,
+		.type		= V4L2_CTRL_TYPE_BOOLEAN,
+		.name		= "Automatic Gain Control",
+		.minimum	= 0,
+		.maximum	= 1,
+		.step		= 1,
+		.default_value	= 1,
+	},
+	{
+		.id		= V4L2_CID_GAIN,
+		.type		= V4L2_CTRL_TYPE_INTEGER,
+		.name		= "Gain",
+		.minimum	= 0,
+		.maximum	= MAX_GAIN,
+		.step		= 1,
+		.default_value	= 0,
+	},
+	{
+		.id		= V4L2_CID_AUTO_WHITE_BALANCE,
+		.type		= V4L2_CTRL_TYPE_BOOLEAN,
+		.name		= "Automatic White Balance",
+		.minimum	= 0,
+		.maximum	= 1,
+		.step		= 1,
+		.default_value	= 1,
+	},
+	{
+		.id		= V4L2_CID_BLUE_BALANCE,
+		.type		= V4L2_CTRL_TYPE_INTEGER,
+		.name		= "Blue Balance",
+		.minimum	= 0,
+		.maximum	= MAX_RBBALANCE,
+		.step		= 1,
+		.default_value	= DEFAULT_RBBALANCE,
+	},
+	{
+		.id		= V4L2_CID_RED_BALANCE,
+		.type		= V4L2_CTRL_TYPE_INTEGER,
+		.name		= "Red Balance",
+		.minimum	= 0,
+		.maximum	= MAX_RBBALANCE,
+		.step		= 1,
+		.default_value	= DEFAULT_RBBALANCE,
+	},
+	{
+		.id		= V4L2_CID_EXPOSURE_AUTO,
+		.type		= V4L2_CTRL_TYPE_INTEGER,
+		.name		= "Automatic Exposure Control",
+		.minimum	= 0,
+		.maximum	= 1,
+		.step		= 1,
+		.default_value	= V4L2_EXPOSURE_AUTO,
+	},
+	{
+		.id		= V4L2_CID_EXPOSURE,
+		.type		= V4L2_CTRL_TYPE_INTEGER,
+		.name		= "Exposure",
+		.minimum	= 0,
+		.maximum	= MAX_EXP,
+		.step		= 1,
+		.default_value	= 0,
+	},
+	/* vflip works out of the box. hflip doesn't work. */
+	{
+		.id		= V4L2_CID_VFLIP,
+		.type		= V4L2_CTRL_TYPE_BOOLEAN,
+		.name		= "Flip Vertically",
+		.minimum	= 0,
+		.maximum	= 1,
+		.step		= 1,
+		.default_value	= 0,
+	},
+	{
+		.id		= V4L2_CID_BRIGHTNESS,
+		.type		= V4L2_CTRL_TYPE_INTEGER,
+		.name		= "Brightness",
+		.minimum	= 0,
+		.maximum	= 255,
+		.step		= 1,
+		.default_value	= 0,
+	},
+	{
+		.id		= V4L2_CID_CONTRAST,
+		.type		= V4L2_CTRL_TYPE_INTEGER,
+		.name		= "Contrast",
+		.minimum	= 0,
+		.maximum	= 255,
+		.step		= 1,
+		.default_value	= DEFAULT_CONTRAST,
+	},
+	{
+		.id		= OV5642_CONTROL_BLUE_SATURATION,
+		.type		= V4L2_CTRL_TYPE_INTEGER,
+		.name		= "Blue Saturation",
+		.minimum	= 0,
+		.maximum	= 255,
+		.step		= 1,
+		.default_value	= DEFAULT_SATURATION,
+	},
+	{
+		.id		= OV5642_CONTROL_RED_SATURATION,
+		.type		= V4L2_CTRL_TYPE_INTEGER,
+		.name		= "Red Saturation",
+		.minimum	= 0,
+		.maximum	= 255,
+		.step		= 1,
+		.default_value	= DEFAULT_SATURATION,
+	},
+	{
+		.id		= V4L2_CID_HUE,
+		.type		= V4L2_CTRL_TYPE_INTEGER,
+		.name		= "Hue",
+		.minimum	= -180,
+		.maximum	= 175,
+		.step		= 5,
+		.default_value	= 0,
+	},
+	{
+		.id		= OV5642_CONTROL_SOLARIZE,
+		.type		= V4L2_CTRL_TYPE_BOOLEAN,
+		.name		= "Solarize",
+		.minimum	= 0,
+		.maximum	= 1,
+		.step		= 1,
+		.default_value	= 0,
+	},
+	{
+		.id		= OV5642_CONTROL_GRAY_SCALE,
+		.type		= V4L2_CTRL_TYPE_BOOLEAN,
+		.name		= "Gray Scale Image",
+		.minimum	= 0,
+		.maximum	= 1,
+		.step		= 1,
+		.default_value	= 0,
+	},
+};
+
 struct ov5642_datafmt {
 	enum v4l2_mbus_pixelcode	code;
 	enum v4l2_colorspace		colorspace;
 };
 
+/* the output resolution and blanking information */
+struct ov5642_out_size {
+	int width;
+	int height;
+	int total_width;
+	int total_height;
+};
+
 struct ov5642 {
 	struct v4l2_subdev		subdev;
+
 	const struct ov5642_datafmt	*fmt;
+	struct v4l2_rect                crop_rect;
+	struct ov5642_out_size		out_size;
+
+	bool agc;
+	bool awb;
+	bool aec;
+	bool vflip;
+	bool grayscale;
+	bool solarize;
+
+	/* values in v4l2 space */
+	int gain;
+	int blue_balance;
+	int red_balance;
+	int blue_saturation;
+	int red_saturation;
+	int exposure;
+	int brightness;
+	int contrast;
+	int hue;
 };
 
 static const struct ov5642_datafmt ov5642_colour_fmts[] = {
@@ -593,8 +827,7 @@ static struct ov5642 *to_ov5642(const struct i2c_client *client)
 }
 
 /* Find a data format by a pixel code in an array */
-static const struct ov5642_datafmt
-			*ov5642_find_datafmt(enum v4l2_mbus_pixelcode code)
+static const struct ov5642_datafmt *ov5642_find_datafmt(enum v4l2_mbus_pixelcode code)
 {
 	int i;
 
@@ -627,6 +860,27 @@ static int reg_read(struct i2c_client *client, u16 reg, u8 *val)
 	return 0;
 }
 
+/*
+ * convenience function to read 16 bit register values that are split up
+ * into two consecutive high and low parts
+ */
+static int reg_read16(struct i2c_client *client, u16 reg, u16 *val16)
+{
+	int ret;
+	u8 val8;
+
+	ret = reg_read(client, reg, &val8);
+	if (ret)
+		return ret;
+	*val16 = val8 << 8;
+	ret = reg_read(client, reg + 1, &val8);
+	if (ret)
+		return ret;
+	*val16 |= val8;
+
+	return 0;
+}
+
 static int reg_write(struct i2c_client *client, u16 reg, u8 val)
 {
 	int ret;
@@ -641,6 +895,26 @@ static int reg_write(struct i2c_client *client, u16 reg, u8 val)
 
 	return 0;
 }
+
+/*
+ * convenience function to write 16 bit register values that are split up
+ * into two consecutive high and low parts
+ */
+static int reg_write16(struct i2c_client *client, u16 reg, u16 val16)
+{
+	int ret;
+	u8 val8;
+
+	val8 = val16 >> 8;
+	ret = reg_write(client, reg, val8);
+	if (ret)
+		return ret;
+	val8 = val16 & 0x00ff;
+	ret = reg_write(client, reg + 1, val8);
+
+	return ret;
+}
+
 #ifdef CONFIG_VIDEO_ADV_DEBUG
 static int ov5642_get_register(struct v4l2_subdev *sd, struct v4l2_dbg_register *reg)
 {
@@ -684,68 +958,166 @@ static int ov5642_write_array(struct i2c_client *client,
 	return 0;
 }
 
-static int ov5642_set_resolution(struct i2c_client *client)
+static int ov5642_set_resolution(struct v4l2_subdev *sd)
 {
+	struct i2c_client *client = v4l2_get_subdevdata(sd);
+	struct ov5642 *priv = to_ov5642(client);
+	int width = priv->out_size.width;
+	int height = priv->out_size.height;
+	int total_width = priv->out_size.total_width;
+	int total_height = priv->out_size.total_height;
+	int start_x = (OV5642_SENSOR_SIZE_X - width) / 2;
+	int start_y = (OV5642_SENSOR_SIZE_Y - height) / 2;
 	int ret;
-	u8 start_x_high = ((OV5642_SENSOR_SIZE_X - OV5642_WIDTH) / 2) >> 8;
-	u8 start_x_low  = ((OV5642_SENSOR_SIZE_X - OV5642_WIDTH) / 2) & 0xff;
-	u8 start_y_high = ((OV5642_SENSOR_SIZE_Y - OV5642_HEIGHT) / 2) >> 8;
-	u8 start_y_low  = ((OV5642_SENSOR_SIZE_Y - OV5642_HEIGHT) / 2) & 0xff;
-
-	u8 width_high	= OV5642_WIDTH  >> 8;
-	u8 width_low	= OV5642_WIDTH  & 0xff;
-	u8 height_high	= OV5642_HEIGHT >> 8;
-	u8 height_low	= OV5642_HEIGHT & 0xff;
-
-	u8 total_width_high  = OV5642_TOTAL_WIDTH  >> 8;
-	u8 total_width_low   = OV5642_TOTAL_WIDTH  & 0xff;
-	u8 total_height_high = OV5642_TOTAL_HEIGHT >> 8;
-	u8 total_height_low  = OV5642_TOTAL_HEIGHT & 0xff;
-
-	ret = reg_write(client, REG_WINDOW_START_X_HIGH, start_x_high);
+
+	/* This should set the starting point for cropping. Doesn't work so far. */
+	ret = reg_write16(client, REG_WINDOW_START_X_HIGH, start_x);
 	if (!ret)
-		ret = reg_write(client, REG_WINDOW_START_X_LOW, start_x_low);
+		ret = reg_write16(client, REG_WINDOW_START_Y_HIGH, start_y);
+	if (!ret) {
+		priv->crop_rect.left = start_x;
+		priv->crop_rect.top = start_y;
+	}
+
 	if (!ret)
-		ret = reg_write(client, REG_WINDOW_START_Y_HIGH, start_y_high);
+		ret = reg_write16(client, REG_WINDOW_WIDTH_HIGH, width);
 	if (!ret)
-		ret = reg_write(client, REG_WINDOW_START_Y_LOW, start_y_low);
+		ret = reg_write16(client, REG_WINDOW_HEIGHT_HIGH, height);
+	if (ret)
+		return ret;
+	priv->crop_rect.width = width;
+	priv->crop_rect.height = height;
 
+	/* Set the output window size. Only 1:1 scale is supported so far. */
+	ret = reg_write16(client, REG_OUT_WIDTH_HIGH, width);
 	if (!ret)
-		ret = reg_write(client, REG_WINDOW_WIDTH_HIGH, width_high);
+		ret = reg_write16(client, REG_OUT_HEIGHT_HIGH, height);
+
+	/* Total width = output size + blanking */
 	if (!ret)
-		ret = reg_write(client, REG_WINDOW_WIDTH_LOW , width_low);
+		ret = reg_write16(client, REG_OUT_TOTAL_WIDTH_HIGH, total_width);
 	if (!ret)
-		ret = reg_write(client, REG_WINDOW_HEIGHT_HIGH, height_high);
+		ret = reg_write16(client, REG_OUT_TOTAL_HEIGHT_HIGH, total_height);
+
+	/* set the maximum integration time */
 	if (!ret)
-		ret = reg_write(client, REG_WINDOW_HEIGHT_LOW,  height_low);
+		ret = reg_write16(client, REG_EXTEND_FRAME_TIME_HIGH,
+								total_height);
 
+	/* Sets the window for AWB calculations */
 	if (!ret)
-		ret = reg_write(client, REG_OUT_WIDTH_HIGH, width_high);
+		ret = reg_write16(client, REG_AVG_WINDOW_END_X_HIGH, width);
 	if (!ret)
-		ret = reg_write(client, REG_OUT_WIDTH_LOW , width_low);
+		ret = reg_write16(client, REG_AVG_WINDOW_END_Y_HIGH, height);
+
+	return ret;
+}
+
+static int ov5642_restore_state(struct v4l2_subdev *sd)
+{
+	struct i2c_client *client = v4l2_get_subdevdata(sd);
+	struct ov5642 *priv = to_ov5642(client);
+	struct v4l2_control set_ctrl;
+	int tmp_red_balance = priv->red_balance;
+	int tmp_blue_balance = priv->blue_balance;
+	int tmp_gain = priv->gain;
+	int tmp_exp = priv->exposure;
+	int ret;
+
+	set_ctrl.id = V4L2_CID_AUTOGAIN;
+	set_ctrl.value = priv->agc;
+	ret = ov5642_s_ctrl(sd, &set_ctrl);
+
+	if (!priv->agc) {
+		set_ctrl.id = V4L2_CID_GAIN;
+		set_ctrl.value = tmp_gain;
+		if (!ret)
+			ret = ov5642_s_ctrl(sd, &set_ctrl);
+	}
+
+	set_ctrl.id = V4L2_CID_AUTO_WHITE_BALANCE;
+	set_ctrl.value = priv->awb;
 	if (!ret)
-		ret = reg_write(client, REG_OUT_HEIGHT_HIGH, height_high);
+		ret = ov5642_s_ctrl(sd, &set_ctrl);
+
+	if (!priv->awb) {
+		set_ctrl.id = V4L2_CID_RED_BALANCE;
+		set_ctrl.value = tmp_red_balance;
+		if (!ret)
+			ret = ov5642_s_ctrl(sd, &set_ctrl);
+
+		set_ctrl.id = V4L2_CID_BLUE_BALANCE;
+		set_ctrl.value = tmp_blue_balance;
+		if (!ret)
+			ret = ov5642_s_ctrl(sd, &set_ctrl);
+	}
+
+	set_ctrl.id = V4L2_CID_EXPOSURE_AUTO;
+	set_ctrl.value = priv->aec;
 	if (!ret)
-		ret = reg_write(client, REG_OUT_HEIGHT_LOW,  height_low);
+		ret = ov5642_s_ctrl(sd, &set_ctrl);
 
+	if (priv->aec == V4L2_EXPOSURE_MANUAL) {
+		set_ctrl.id = V4L2_CID_EXPOSURE;
+		set_ctrl.value = tmp_exp;
+		if (!ret)
+			ret = ov5642_s_ctrl(sd, &set_ctrl);
+	}
+
+	set_ctrl.id = V4L2_CID_VFLIP;
+	set_ctrl.value = priv->vflip;
+	if (!ret)
+		ret = ov5642_s_ctrl(sd, &set_ctrl);
+
+	set_ctrl.id = OV5642_CONTROL_GRAY_SCALE;
+	set_ctrl.value = priv->grayscale;
+	if (!ret)
+		ret = ov5642_s_ctrl(sd, &set_ctrl);
+
+	set_ctrl.id = OV5642_CONTROL_SOLARIZE;
+	set_ctrl.value = priv->solarize;
 	if (!ret)
-		ret = reg_write(client, REG_OUT_TOTAL_WIDTH_HIGH, total_width_high);
+		ret = ov5642_s_ctrl(sd, &set_ctrl);
+
+	set_ctrl.id = OV5642_CONTROL_BLUE_SATURATION;
+	set_ctrl.value = priv->blue_saturation;
 	if (!ret)
-		ret = reg_write(client, REG_OUT_TOTAL_WIDTH_LOW, total_width_low);
+		ret = ov5642_s_ctrl(sd, &set_ctrl);
+
+	set_ctrl.id = OV5642_CONTROL_RED_SATURATION;
+	set_ctrl.value = priv->red_saturation;
 	if (!ret)
-		ret = reg_write(client, REG_OUT_TOTAL_HEIGHT_HIGH, total_height_high);
+		ret = ov5642_s_ctrl(sd, &set_ctrl);
+
+	set_ctrl.id = V4L2_CID_BRIGHTNESS;
+	set_ctrl.value = priv->brightness;
 	if (!ret)
-		ret = reg_write(client, REG_OUT_TOTAL_HEIGHT_LOW,  total_height_low);
+		ret = ov5642_s_ctrl(sd, &set_ctrl);
+
+	set_ctrl.id = V4L2_CID_CONTRAST;
+	set_ctrl.value = priv->contrast;
+	if (!ret)
+		ret = ov5642_s_ctrl(sd, &set_ctrl);
+
+	set_ctrl.id = V4L2_CID_HUE;
+	set_ctrl.value = priv->hue;
+	if (!ret)
+		ret = ov5642_s_ctrl(sd, &set_ctrl);
 
 	return ret;
 }
 
-static int ov5642_try_fmt(struct v4l2_subdev *sd,
-			  struct v4l2_mbus_framefmt *mf)
+static int ov5642_try_fmt(struct v4l2_subdev *sd, struct v4l2_mbus_framefmt *mf)
 {
-	const struct ov5642_datafmt *fmt = ov5642_find_datafmt(mf->code);
+	const struct ov5642_datafmt *fmt   = ov5642_find_datafmt(mf->code);
 
-	dev_dbg(sd->v4l2_dev->dev, "%s(%u) width: %u heigth: %u\n",
+	dev_dbg(sd->v4l2_dev->dev, "%s(%u) request width: %u heigth: %u\n",
+			__func__, mf->code, mf->width, mf->height);
+
+	v4l_bound_align_image(&mf->width, 48, OV5642_MAX_WIDTH, 1,
+			      &mf->height, 32, OV5642_MAX_HEIGHT, 1, 0);
+
+	dev_dbg(sd->v4l2_dev->dev, "%s(%u) return width: %u heigth: %u\n",
 			__func__, mf->code, mf->width, mf->height);
 
 	if (!fmt) {
@@ -753,20 +1125,16 @@ static int ov5642_try_fmt(struct v4l2_subdev *sd,
 		mf->colorspace	= ov5642_colour_fmts[0].colorspace;
 	}
 
-	mf->width	= OV5642_WIDTH;
-	mf->height	= OV5642_HEIGHT;
 	mf->field	= V4L2_FIELD_NONE;
 
 	return 0;
 }
 
-static int ov5642_s_fmt(struct v4l2_subdev *sd,
-			struct v4l2_mbus_framefmt *mf)
+static int ov5642_s_fmt(struct v4l2_subdev *sd, struct v4l2_mbus_framefmt *mf)
 {
 	struct i2c_client *client = v4l2_get_subdevdata(sd);
 	struct ov5642 *priv = to_ov5642(client);
-
-	dev_dbg(sd->v4l2_dev->dev, "%s(%u)\n", __func__, mf->code);
+	int ret;
 
 	/* MIPI CSI could have changed the format, double-check */
 	if (!ov5642_find_datafmt(mf->code))
@@ -774,17 +1142,30 @@ static int ov5642_s_fmt(struct v4l2_subdev *sd,
 
 	ov5642_try_fmt(sd, mf);
 
+	priv->out_size.width		= mf->width;
+	priv->out_size.height		= mf->height;
+	priv->out_size.total_width	= mf->width + BLANKING_EXTRA_WIDTH;
+	priv->out_size.total_height	= max_t(int, mf->height +
+							BLANKING_EXTRA_HEIGHT,
+							BLANKING_MIN_HEIGHT);
+	priv->crop_rect.width		= mf->width;
+	priv->crop_rect.height		= mf->height;
+
 	priv->fmt = ov5642_find_datafmt(mf->code);
 
-	ov5642_write_array(client, ov5642_default_regs_init);
-	ov5642_set_resolution(client);
-	ov5642_write_array(client, ov5642_default_regs_finalise);
+	ret = ov5642_write_array(client, ov5642_default_regs_init);
+	if (!ret)
+		ret = ov5642_set_resolution(sd);
+	if (!ret)
+		ret = ov5642_write_array(client, ov5642_default_regs_finalise);
 
-	return 0;
+	/* the chip has been reset, so configure it again */
+	if (!ret)
+		ret = ov5642_restore_state(sd);
+	return ret;
 }
 
-static int ov5642_g_fmt(struct v4l2_subdev *sd,
-			struct v4l2_mbus_framefmt *mf)
+static int ov5642_g_fmt(struct v4l2_subdev *sd, struct v4l2_mbus_framefmt *mf)
 {
 	struct i2c_client *client = v4l2_get_subdevdata(sd);
 	struct ov5642 *priv = to_ov5642(client);
@@ -793,10 +1174,12 @@ static int ov5642_g_fmt(struct v4l2_subdev *sd,
 
 	mf->code	= fmt->code;
 	mf->colorspace	= fmt->colorspace;
-	mf->width	= OV5642_WIDTH;
-	mf->height	= OV5642_HEIGHT;
+	mf->width	= priv->out_size.width;
+	mf->height	= priv->out_size.height;
 	mf->field	= V4L2_FIELD_NONE;
 
+	dev_dbg(sd->v4l2_dev->dev, "%s return width: %u heigth: %u\n", __func__,
+			mf->width, mf->height);
 	return 0;
 }
 
@@ -827,16 +1210,400 @@ static int ov5642_g_chip_ident(struct v4l2_subdev *sd,
 	return 0;
 }
 
+/*
+ * Hue needs trigonometric functions. There is a switch on the ov5642 to use
+ * angles directly, but this seems to massively increase saturation as well.
+ *
+ * The following naive approximate trig functions require an argument
+ * carefully limited to -180 <= theta <= 180.
+ *
+ * Taken directly from ov7670.c
+ */
+#define SIN_STEP 5
+static const int ov5642_sin_table[] = {
+	   0,	 87,   173,   258,   342,   422,
+	 499,	573,   642,   707,   766,   819,
+	 866,	906,   939,   965,   984,   996,
+	1000
+};
+
+static int ov5642_sin(int theta)
+{
+	int chs = 1;
+	int sin;
+
+	if (theta < 0) {
+		theta = -theta;
+		chs = -1;
+	}
+	if (theta <= 90)
+		sin = ov5642_sin_table[theta / SIN_STEP];
+	else {
+		theta -= 90;
+		sin = 1000 - ov5642_sin_table[theta / SIN_STEP];
+	}
+	return sin * chs;
+}
+
+static int ov5642_cosine(int theta)
+{
+	theta = 90 - theta;
+	if (theta > 180)
+		theta -= 360;
+	else if (theta < -180)
+		theta += 360;
+	return ov5642_sin(theta);
+}
+
+static int ov5642_g_ctrl(struct v4l2_subdev *sd, struct v4l2_control *ctrl)
+{
+	struct i2c_client *client = v4l2_get_subdevdata(sd);
+	struct ov5642 *priv = to_ov5642(client);
+	int ret = 0;
+	u8 val8;
+	u16 val16;
+	u32 val32;
+
+	switch (ctrl->id) {
+	case V4L2_CID_AUTOGAIN:
+		ctrl->value = priv->agc;
+		break;
+	case V4L2_CID_GAIN:
+		if (priv->agc) {
+			ret = reg_read(client, REG_GAIN, &val8);
+			if (ret)
+				break;
+			ctrl->value = GAIN_NATIVE_TO_V4L2(val8);
+		} else {
+			ctrl->value = priv->gain;
+		}
+		break;
+	case V4L2_CID_AUTO_WHITE_BALANCE:
+		ctrl->value = priv->awb;
+		break;
+	case V4L2_CID_BLUE_BALANCE:
+		if (priv->awb) {
+			ret = reg_read16(client, REG_BLUE_GAIN_HIGH, &val16);
+			if (!ret)
+				ctrl->value = RBBALANCE_NATIVE_TO_V4L2(val16);
+		} else {
+			ctrl->value = priv->blue_balance;
+		}
+		break;
+	case V4L2_CID_RED_BALANCE:
+		if (priv->awb) {
+			ret = reg_read16(client, REG_RED_GAIN_HIGH, &val16);
+			if (!ret)
+				ctrl->value = RBBALANCE_NATIVE_TO_V4L2(val16);
+		} else {
+			ctrl->value = priv->red_balance;
+		}
+		break;
+	case V4L2_CID_EXPOSURE_AUTO:
+		ctrl->value = priv->aec;
+		break;
+	case V4L2_CID_EXPOSURE:
+		if (priv->aec == V4L2_EXPOSURE_AUTO) {
+			ret = reg_read(client, REG_EXP_HIGH, &val8);
+			if (ret)
+				break;
+			val32 = val8 << 16;
+			ret = reg_read16(client, REG_EXP_MIDDLE, &val16);
+			if (ret)
+				break;
+			val32 |= val16;
+			ctrl->value = EXP_NATIVE_TO_V4L2(val32);
+		} else {
+			ctrl->value = priv->exposure;
+		}
+		break;
+	case V4L2_CID_VFLIP:
+		ctrl->value = priv->vflip;
+		break;
+	case V4L2_CID_BRIGHTNESS:
+		ctrl->value = priv->brightness;
+		break;
+	case V4L2_CID_CONTRAST:
+		ctrl->value = priv->contrast;
+		break;
+	case OV5642_CONTROL_BLUE_SATURATION:
+		ctrl->value = priv->blue_saturation;
+		break;
+	case OV5642_CONTROL_RED_SATURATION:
+		ctrl->value = priv->red_saturation;
+		break;
+	case V4L2_CID_HUE:
+		ctrl->value = priv->hue;
+		break;
+	case OV5642_CONTROL_GRAY_SCALE:
+		ctrl->value = priv->grayscale;
+		break;
+	case OV5642_CONTROL_SOLARIZE:
+		ctrl->value = priv->solarize;
+		break;
+	};
+
+	return ret;
+}
+
+static int ov5642_s_ctrl(struct v4l2_subdev *sd, struct v4l2_control *ctrl)
+{
+	struct i2c_client *client = v4l2_get_subdevdata(sd);
+	struct ov5642 *priv = to_ov5642(client);
+	int ret = 0;
+	u8 val8;
+	u16 val16;
+	u32 val32;
+	int trig;
+	struct v4l2_control aux_ctrl;
+
+	switch (ctrl->id) {
+	case V4L2_CID_AUTOGAIN:
+		if (!ctrl->value) {
+			aux_ctrl.id = V4L2_CID_GAIN;
+			ret = ov5642_g_ctrl(sd, &aux_ctrl);
+			if (ret)
+				break;
+			priv->gain = aux_ctrl.value;
+		}
+
+		ret = reg_read(client, REG_EXP_GAIN_CTRL, &val8);
+		if (ret)
+			break;
+		val8 = ctrl->value ? val8 & ~BIT(1) : val8 | BIT(1);
+		ret = reg_write(client, REG_EXP_GAIN_CTRL, val8);
+		if (!ret)
+			priv->agc = ctrl->value;
+		break;
+	case V4L2_CID_GAIN:
+		/* turn auto function off */
+		if (priv->agc) {
+			aux_ctrl.id = V4L2_CID_AUTOGAIN;
+			aux_ctrl.value = false;
+			ret = ov5642_s_ctrl(sd, &aux_ctrl);
+			if (ret)
+				break;
+		}
+
+		val8 = GAIN_V4L2_TO_NATIVE(ctrl->value);
+		ret = reg_write(client, REG_GAIN, val8);
+		if (!ret)
+			priv->gain = ctrl->value;
+		break;
+	case V4L2_CID_AUTO_WHITE_BALANCE:
+		if (!ctrl->value) {
+			aux_ctrl.id = V4L2_CID_BLUE_BALANCE;
+			ret = ov5642_g_ctrl(sd, &aux_ctrl);
+			if (ret)
+				break;
+			priv->blue_balance = aux_ctrl.value;
+			aux_ctrl.id = V4L2_CID_RED_BALANCE;
+			ret = ov5642_g_ctrl(sd, &aux_ctrl);
+			if (ret)
+				break;
+			priv->red_balance = aux_ctrl.value;
+		}
+		ret = reg_write(client, REG_AWB_MANUAL, !ctrl->value);
+		if (!ret)
+			priv->awb = ctrl->value;
+		break;
+	case V4L2_CID_BLUE_BALANCE:
+	case V4L2_CID_RED_BALANCE:
+		/* turn auto function off */
+		if (priv->awb) {
+			aux_ctrl.id = V4L2_CID_AUTO_WHITE_BALANCE;
+			aux_ctrl.value = false;
+			ret = ov5642_s_ctrl(sd, &aux_ctrl);
+			if (ret)
+				break;
+		}
+		val16 = RBBALANCE_V4L2_TO_NATIVE(ctrl->value);
+		if (ctrl->id == V4L2_CID_BLUE_BALANCE) {
+			ret = reg_write16(client, REG_BLUE_GAIN_HIGH, val16);
+			if (!ret)
+				priv->blue_balance = ctrl->value;
+		} else {
+			ret = reg_write16(client, REG_RED_GAIN_HIGH, val16);
+			if (!ret)
+				priv->red_balance = ctrl->value;
+		}
+		break;
+	case V4L2_CID_EXPOSURE_AUTO:
+		if (ctrl->value == V4L2_EXPOSURE_MANUAL) {
+			aux_ctrl.id = V4L2_CID_EXPOSURE;
+			ret = ov5642_g_ctrl(sd, &aux_ctrl);
+			if (ret)
+				break;
+			priv->exposure = aux_ctrl.value;
+		}
+		ret = reg_read(client, REG_EXP_GAIN_CTRL, &val8);
+		if (ret)
+			break;
+		val8 = ctrl->value == V4L2_EXPOSURE_MANUAL ? val8 | BIT(0) | BIT(2)
+							: val8 & ~(BIT(0) | BIT(2));
+		ret = reg_write(client, REG_EXP_GAIN_CTRL, val8);
+		if (ret)
+			break;
+		priv->aec = ctrl->value;
+		break;
+	case V4L2_CID_EXPOSURE:
+		/*
+		 * the exposure time is given in lines, i.e. how much time is
+		 * needed to transmit 1 line. The register value is divided by
+		 * 16 in the form of xxxx.x.
+		 * So the last nibble (0x3502[0:3]) is the time for a fraction
+		 * of 1 line: x/16
+		 */
+
+		/* turn auto function off */
+		if (priv->aec) {
+			aux_ctrl.id = V4L2_CID_EXPOSURE_AUTO;
+			aux_ctrl.value = V4L2_EXPOSURE_MANUAL;
+			ret = ov5642_s_ctrl(sd, &aux_ctrl);
+			if (ret)
+				break;
+		}
+
+		val32 = EXP_V4L2_TO_NATIVE(ctrl->value);
+
+		/*
+		 * if we expose longer than 1 frame, we must lower the fps
+		 * by increasing blanking
+		 */
+		if (val32 / 16 + MANUAL_LONG_EXP_SAFETY_DISTANCE >
+						priv->out_size.total_height) {
+			ret = reg_write16(client, REG_EXTEND_FRAME_TIME_HIGH,
+					val32 / 16 + BLANKING_EXTRA_HEIGHT);
+			if (ret)
+				break;
+			dev_dbg(sd->v4l2_dev->dev,
+				"%s: Increasing vert. blanking. Total height: %d.\n",
+				__func__, val32 / 16 + BLANKING_EXTRA_HEIGHT);
+		} else if (priv->exposure + MANUAL_LONG_EXP_SAFETY_DISTANCE >
+						priv->out_size.total_height) {
+			/*
+			 * if we increased blanking in the past, but lowered the
+			 * exposure now sufficiently, we can go back to normal
+			 * timings
+			 */
+			ret = reg_write16(client, REG_EXTEND_FRAME_TIME_HIGH,
+					priv->out_size.total_height);
+			if (ret)
+				break;
+			dev_dbg(sd->v4l2_dev->dev,
+				"%s: Resetting to normal frame time\n",	__func__);
+		}
+		ret = reg_write(client, REG_EXP_HIGH, val32 >> 16);
+		if (ret)
+			break;
+		ret = reg_write16(client, REG_EXP_MIDDLE, val32);
+		if (!ret)
+			priv->exposure = ctrl->value;
+		break;
+	case V4L2_CID_VFLIP:
+		ret = reg_read(client, REG_FLIP_SUBSAMPLE, &val8);
+		if (ret)
+			break;
+		val8 = ctrl->value ? val8 | BIT(5) : val8 & ~BIT(5);
+		ret = reg_write(client, REG_FLIP_SUBSAMPLE, val8);
+		if (!ret)
+			priv->vflip = ctrl->value;
+		break;
+	case V4L2_CID_BRIGHTNESS:
+		ret = reg_write(client, REG_BRIGHTNESS, ctrl->value);
+		if (!ret)
+			priv->brightness = ctrl->value;
+		break;
+	case V4L2_CID_CONTRAST:
+		ret = reg_write(client, REG_CONTRAST, ctrl->value);
+		if (!ret)
+			priv->contrast = ctrl->value;
+		break;
+	case OV5642_CONTROL_BLUE_SATURATION:
+		ret = reg_write(client, REG_BLUE_SATURATION, ctrl->value);
+		if (!ret)
+			priv->blue_saturation = ctrl->value;
+		break;
+	case OV5642_CONTROL_RED_SATURATION:
+		ret = reg_write(client, REG_RED_SATURATION, ctrl->value);
+		if (!ret)
+			priv->red_saturation = ctrl->value;
+		break;
+	case V4L2_CID_HUE:
+		ret = reg_read(client, REG_DIGITAL_EFFECTS, &val8);
+		if (ret)
+			break;
+		val8 = ctrl->value != 0 ? val8 | BIT(0) : val8 & ~BIT(0);
+		ret = reg_write(client, REG_DIGITAL_EFFECTS, val8);
+		if (ret)
+			break;
+
+		if (!ctrl->value) {
+			priv->hue = 0;
+			break;
+		} else {
+			trig = ov5642_sin(ctrl->value) *
+						MAX_HUE_TRIG_NATIVE / 1000;
+			ret = reg_write(client, REG_HUE_SIN, abs(trig));
+			if (ret)
+				break;
+			ret = reg_read(client, REG_D_E_AUXILLARY, &val8);
+			if (ret)
+				break;
+			/* determine bits for sine signs */
+			val8 = trig < 0 ? (val8 & ~BIT(0)) | BIT(1) :
+						(val8 | BIT(0)) & ~BIT(1);
+
+			trig = ov5642_cosine(ctrl->value) *
+						MAX_HUE_TRIG_NATIVE / 1000;
+			ret = reg_write(client, REG_HUE_COS, abs(trig));
+
+			/* determine bits for cosine signs */
+			val8 = trig < 0 ? val8 | BIT(4) | BIT(5) :
+						val8 & ~(BIT(4) | BIT(5));
+
+			ret = reg_write(client, REG_D_E_AUXILLARY, val8);
+			if (ret)
+				break;
+
+			priv->hue = ctrl->value;
+			break;
+		}
+	case OV5642_CONTROL_GRAY_SCALE:
+		ret = reg_read(client, REG_DIGITAL_EFFECTS, &val8);
+		if (ret)
+			break;
+		val8 = ctrl->value ? val8 | BIT(5) : val8 & ~BIT(5);
+		ret = reg_write(client, REG_DIGITAL_EFFECTS, val8);
+		if (!ret)
+			priv->grayscale = ctrl->value;
+		break;
+	case OV5642_CONTROL_SOLARIZE:
+		ret = reg_read(client, REG_D_E_AUXILLARY, &val8);
+		if (ret)
+			break;
+		val8 = ctrl->value ? val8 | BIT(7) : val8 & ~BIT(7);
+		ret = reg_write(client, REG_D_E_AUXILLARY, val8);
+		if (!ret)
+			priv->solarize = ctrl->value;
+		break;
+	}
+	return ret;
+}
+
 static int ov5642_g_crop(struct v4l2_subdev *sd, struct v4l2_crop *a)
 {
+	struct i2c_client *client = v4l2_get_subdevdata(sd);
+	struct ov5642 *priv = to_ov5642(client);
 	struct v4l2_rect *rect = &a->c;
-
 	a->type		= V4L2_BUF_TYPE_VIDEO_CAPTURE;
-	rect->top	= 0;
-	rect->left	= 0;
-	rect->width	= OV5642_WIDTH;
-	rect->height	= OV5642_HEIGHT;
+	rect->top	= priv->crop_rect.top;
+	rect->left	= priv->crop_rect.left;
+	rect->width	= priv->crop_rect.width;
+	rect->height	= priv->crop_rect.height;
 
+	dev_dbg(sd->v4l2_dev->dev, "%s crop width: %u heigth: %u\n", __func__,
+			rect->width, rect->height);
 	return 0;
 }
 
@@ -844,8 +1611,8 @@ static int ov5642_cropcap(struct v4l2_subdev *sd, struct v4l2_cropcap *a)
 {
 	a->bounds.left			= 0;
 	a->bounds.top			= 0;
-	a->bounds.width			= OV5642_WIDTH;
-	a->bounds.height		= OV5642_HEIGHT;
+	a->bounds.width			= OV5642_MAX_WIDTH;
+	a->bounds.height		= OV5642_MAX_HEIGHT;
 	a->defrect			= a->bounds;
 	a->type				= V4L2_BUF_TYPE_VIDEO_CAPTURE;
 	a->pixelaspect.numerator	= 1;
@@ -858,9 +1625,8 @@ static int ov5642_g_mbus_config(struct v4l2_subdev *sd,
 				struct v4l2_mbus_config *cfg)
 {
 	cfg->type = V4L2_MBUS_CSI2;
-	cfg->flags = V4L2_MBUS_CSI2_2_LANE |
-		V4L2_MBUS_CSI2_CHANNEL_0 |
-		V4L2_MBUS_CSI2_CONTINUOUS_CLOCK;
+	cfg->flags = V4L2_MBUS_CSI2_2_LANE | V4L2_MBUS_CSI2_CHANNEL_0 |
+					V4L2_MBUS_CSI2_CONTINUOUS_CLOCK;
 
 	return 0;
 }
@@ -877,6 +1643,8 @@ static struct v4l2_subdev_video_ops ov5642_subdev_video_ops = {
 
 static struct v4l2_subdev_core_ops ov5642_subdev_core_ops = {
 	.g_chip_ident	= ov5642_g_chip_ident,
+	.g_ctrl		= ov5642_g_ctrl,
+	.s_ctrl		= ov5642_s_ctrl,
 #ifdef CONFIG_VIDEO_ADV_DEBUG
 	.g_register	= ov5642_get_register,
 	.s_register	= ov5642_set_register,
@@ -888,6 +1656,11 @@ static struct v4l2_subdev_ops ov5642_subdev_ops = {
 	.video	= &ov5642_subdev_video_ops,
 };
 
+static struct soc_camera_ops soc_ov5642_ops = {
+	.controls		= ov5642_controls,
+	.num_controls		= ARRAY_SIZE(ov5642_controls),
+};
+
 static int ov5642_video_probe(struct soc_camera_device *icd,
 			      struct i2c_client *client)
 {
@@ -941,8 +1714,24 @@ static int ov5642_probe(struct i2c_client *client,
 
 	v4l2_i2c_subdev_init(&priv->subdev, client, &ov5642_subdev_ops);
 
-	icd->ops	= NULL;
-	priv->fmt	= &ov5642_colour_fmts[0];
+	icd->ops		= &soc_ov5642_ops;
+	priv->fmt		= &ov5642_colour_fmts[0];
+
+	priv->crop_rect.width	= OV5642_DEFAULT_WIDTH;
+	priv->crop_rect.height	= OV5642_DEFAULT_HEIGHT;
+	priv->crop_rect.left	= (OV5642_MAX_WIDTH - OV5642_DEFAULT_WIDTH) / 2;
+	priv->crop_rect.top	= (OV5642_MAX_HEIGHT - OV5642_DEFAULT_HEIGHT) / 2;
+	priv->out_size.width	= OV5642_DEFAULT_WIDTH;
+	priv->out_size.height	= OV5642_DEFAULT_HEIGHT;
+
+	priv->aec		= V4L2_EXPOSURE_AUTO;
+	priv->agc		= true;
+	priv->awb		= true;
+	priv->blue_balance	= RBBALANCE_NATIVE_TO_V4L2(DEFAULT_RBBALANCE);
+	priv->red_balance	= RBBALANCE_NATIVE_TO_V4L2(DEFAULT_RBBALANCE);
+	priv->contrast		= DEFAULT_CONTRAST;
+	priv->blue_saturation	= DEFAULT_SATURATION;
+	priv->red_saturation	= DEFAULT_SATURATION;
 
 	ret = ov5642_video_probe(icd, client);
 	if (ret < 0)
@@ -951,6 +1740,7 @@ static int ov5642_probe(struct i2c_client *client,
 	return 0;
 
 error:
+	icd->ops = NULL;
 	kfree(priv);
 	return ret;
 }
@@ -961,6 +1751,7 @@ static int ov5642_remove(struct i2c_client *client)
 	struct soc_camera_device *icd = client->dev.platform_data;
 	struct soc_camera_link *icl = to_soc_camera_link(icd);
 
+	icd->ops = NULL;
 	if (icl->free_bus)
 		icl->free_bus(icl);
 	kfree(priv);
