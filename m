Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:65151 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753193Ab1IFNaY (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 6 Sep 2011 09:30:24 -0400
Received: by fxh19 with SMTP id 19so4588052fxh.19
        for <linux-media@vger.kernel.org>; Tue, 06 Sep 2011 06:30:22 -0700 (PDT)
Date: Tue, 6 Sep 2011 13:30:16 +0000 (UTC)
From: Bastian Hecht <hechtb@googlemail.com>
To: linux-media@vger.kernel.org
Subject: [PATCH/RFC] media: Add camera controls for the ov5642 driver
Message-ID: <alpine.DEB.2.02.1109061316450.15153@ipanema>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The driver now supports automatic/manual gain, automatic/manual white
balance, automatic/manual exposure control, vertical flip, brightness
control, contrast control and saturation control. Additionally the
following effects are available now: rotating the hue in the colorspace,
gray scale image and solarize effect.

Signed-off-by: Bastian Hecht <hechtb@gmail.com>
---
INCOMPLETE: There are some missing defines in videodev2.h that are 
discussed currently. If something like V4L2_CID_{RED,BLUE}_GAIN is added 
to them, my current V4L2_CID_{RED,BLUE}_BALANCE will become 
V4L2_CID_{RED,BLUE}_GAIN and OV5642_CONTROL_{RED,BLUE}_SATURATION will 
become V4L2_CID_{RED,BLUE}_BALANCE. The remaining code is complete.

diff --git a/drivers/media/video/ov5642.c b/drivers/media/video/ov5642.c
index 41b3f51..56459f2 100644
--- a/drivers/media/video/ov5642.c
+++ b/drivers/media/video/ov5642.c
@@ -30,6 +30,18 @@
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
@@ -46,13 +58,54 @@
 #define REG_OUT_TOTAL_WIDTH_LOW		0x380d
 #define REG_OUT_TOTAL_HEIGHT_HIGH	0x380e
 #define REG_OUT_TOTAL_HEIGHT_LOW	0x380f
+#define REG_FLIP_SUBSAMPLE		0x3818
 #define REG_OUTPUT_FORMAT		0x4300
 #define REG_ISP_CTRL_01			0x5001
+#define REG_DIGITAL_EFFECTS		0x5580
+#define REG_HUE_COS			0x5581
+#define REG_HUE_SIN			0x5582
+#define REG_BLUE_SATURATION		0x5583
+#define REG_RED_SATURATION		0x5584
+#define REG_CONTRAST			0x5588
+#define REG_BRIGHTNESS			0x5589
+#define REG_D_E_AUXILLARY		0x558a
 #define REG_AVG_WINDOW_END_X_HIGH	0x5682
 #define REG_AVG_WINDOW_END_X_LOW	0x5683
 #define REG_AVG_WINDOW_END_Y_HIGH	0x5686
 #define REG_AVG_WINDOW_END_Y_LOW	0x5687
 
+/* default register initialisation */
+#define REG_EXP_GAIN_INIT		0x00
+#define REG_FLIP_SUBSAMPLE_INIT		0xc1
+#define REG_DIGITAL_EFFECTS_INIT	0x06
+#define REG_D_E_AUXILLARY_INIT		0x01
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
 /* active pixel array size */
 #define OV5642_SENSOR_SIZE_X	2592
 #define OV5642_SENSOR_SIZE_Y	1944
@@ -85,6 +138,9 @@
  */
 #define BLANKING_MIN_HEIGHT		1000
 
+static int ov5642_s_ctrl(struct v4l2_subdev *sd, struct v4l2_control *ctrl);
+static int ov5642_g_ctrl(struct v4l2_subdev *sd, struct v4l2_control *ctrl);
+
 struct regval_list {
 	u16 reg_num;
 	u8 value;
@@ -132,10 +188,8 @@ static struct regval_list ov5642_default_regs_init[] = {
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
@@ -148,11 +202,8 @@ static struct regval_list ov5642_default_regs_init[] = {
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
@@ -167,12 +218,6 @@ static struct regval_list ov5642_default_regs_init[] = {
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
@@ -325,7 +370,7 @@ static struct regval_list ov5642_default_regs_init[] = {
 	{ 0x54b7, 0xdf },
 	{ 0x5402, 0x3f },
 	{ 0x5403, 0x0  },
-	{ 0x3406, 0x0  },
+	{ REG_AWB_MANUAL, 0x0  },
 	{ 0x5180, 0xff },
 	{ 0x5181, 0x52 },
 	{ 0x5182, 0x11 },
@@ -542,7 +587,6 @@ static struct regval_list ov5642_default_regs_init[] = {
 	{ 0x5088, 0x0  },
 	{ 0x5089, 0x0  },
 	{ 0x302b, 0x0  },
-	{ 0x3503, 0x7  },
 	{ 0x3011, 0x8  },
 	{ 0x350c, 0x2  },
 	{ 0x350d, 0xe4 },
@@ -553,7 +597,6 @@ static struct regval_list ov5642_default_regs_init[] = {
 
 static struct regval_list ov5642_default_regs_finalise[] = {
 	{ 0x3810, 0xc2 },
-	{ 0x3818, 0xc9 },
 	{ 0x381c, 0x10 },
 	{ 0x381d, 0xa0 },
 	{ 0x381e, 0x5  },
@@ -568,23 +611,20 @@ static struct regval_list ov5642_default_regs_finalise[] = {
 	{ 0x3a0d, 0x2  },
 	{ 0x3a0e, 0x1  },
 	{ 0x401c, 0x4  },
-	{ 0x5682, 0x5  },
-	{ 0x5683, 0x0  },
-	{ 0x5686, 0x2  },
-	{ 0x5687, 0xcc },
-	{ 0x5001, 0x4f },
+	{ REG_ISP_CTRL_01, 0xff },
+	{ REG_DIGITAL_EFFECTS, REG_DIGITAL_EFFECTS_INIT },
 	{ 0x589b, 0x6  },
 	{ 0x589a, 0xc5 },
-	{ 0x3503, 0x0  },
+	{ REG_EXP_GAIN_CTRL, REG_EXP_GAIN_INIT },
 	{ 0x460c, 0x20 },
 	{ 0x460b, 0x37 },
 	{ 0x471c, 0xd0 },
 	{ 0x471d, 0x5  },
 	{ 0x3815, 0x1  },
-	{ 0x3818, 0xc1 },
+	{ REG_FLIP_SUBSAMPLE, REG_FLIP_SUBSAMPLE_INIT },
 	{ 0x501f, 0x0  },
 	{ 0x5002, 0xe0 },
-	{ 0x4300, 0x32 }, /* UYVY */
+	{ REG_OUTPUT_FORMAT, 0x32 },
 	{ 0x3002, 0x1c },
 	{ 0x4800, 0x14 },
 	{ 0x4801, 0xf  },
@@ -600,6 +640,145 @@ static struct regval_list ov5642_default_regs_finalise[] = {
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
+		.id		= V4L2_CID_COLORFX,
+		.type		= V4L2_CTRL_TYPE_BOOLEAN,
+		.name		= "Effects - Solarize",
+		.minimum	= 0,
+		.maximum	= 10,
+		.step		= 10,
+		.default_value	= 0,
+	},
+	{
+		.id		= V4L2_CID_COLOR_KILLER,
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
@@ -613,6 +792,31 @@ struct ov5642 {
 	/* blanking information */
 	int total_width;
 	int total_height;
+
+	/* controls */
+	bool agc;
+	bool awb;
+	bool aec;
+	bool vflip;
+	bool grayscale;
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
+	int effects; /* only used for solarize */
+
+	/* cached register values */
+	int reg_exp_gain;
+	int reg_flip_subsample;
+	int reg_digital_effects;
+	int reg_d_e_auxillary;
 };
 
 static const struct ov5642_datafmt ov5642_colour_fmts[] = {
@@ -659,6 +863,27 @@ static int reg_read(struct i2c_client *client, u16 reg, u8 *val)
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
@@ -775,6 +1000,11 @@ static int ov5642_set_resolution(struct v4l2_subdev *sd)
 	if (!ret)
 		ret = reg_write16(client, REG_OUT_TOTAL_HEIGHT_HIGH, total_height);
 
+	/* set the maximum integration time */
+	if (!ret)
+		ret = reg_write16(client, REG_EXTEND_FRAME_TIME_HIGH,
+								total_height);
+
 	/* Sets the window for AWB calculations */
 	if (!ret)
 		ret = reg_write16(client, REG_AVG_WINDOW_END_X_HIGH, width);
@@ -784,6 +1014,100 @@ static int ov5642_set_resolution(struct v4l2_subdev *sd)
 	return ret;
 }
 
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
+	if (!ret)
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
+	if (!ret)
+		ret = ov5642_s_ctrl(sd, &set_ctrl);
+
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
+	set_ctrl.id = V4L2_CID_COLOR_KILLER;
+	set_ctrl.value = priv->grayscale;
+	if (!ret)
+		ret = ov5642_s_ctrl(sd, &set_ctrl);
+
+	set_ctrl.id = V4L2_CID_COLORFX;
+	set_ctrl.value = priv->effects;
+	if (!ret)
+		ret = ov5642_s_ctrl(sd, &set_ctrl);
+
+	set_ctrl.id = OV5642_CONTROL_BLUE_SATURATION;
+	set_ctrl.value = priv->blue_saturation;
+	if (!ret)
+		ret = ov5642_s_ctrl(sd, &set_ctrl);
+
+	set_ctrl.id = OV5642_CONTROL_RED_SATURATION;
+	set_ctrl.value = priv->red_saturation;
+	if (!ret)
+		ret = ov5642_s_ctrl(sd, &set_ctrl);
+
+	set_ctrl.id = V4L2_CID_BRIGHTNESS;
+	set_ctrl.value = priv->brightness;
+	if (!ret)
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
+
+	return ret;
+}
+
 static int ov5642_try_fmt(struct v4l2_subdev *sd,
 			  struct v4l2_mbus_framefmt *mf)
 {
@@ -889,6 +1213,392 @@ static int ov5642_s_crop(struct v4l2_subdev *sd, struct v4l2_crop *a)
 	if (!ret)
 		ret = ov5642_write_array(client, ov5642_default_regs_finalise);
 
+	priv->reg_exp_gain = REG_EXP_GAIN_INIT;
+	priv->reg_flip_subsample = REG_FLIP_SUBSAMPLE_INIT;
+	priv->reg_digital_effects = REG_DIGITAL_EFFECTS_INIT;
+	priv->reg_d_e_auxillary = REG_D_E_AUXILLARY_INIT;
+
+	/* the chip has been reset, so configure it again */
+	if (!ret)
+		ret = ov5642_restore_state(sd);
+	return ret;
+}
+
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
+	case V4L2_CID_COLOR_KILLER:
+		ctrl->value = priv->grayscale;
+		break;
+	case V4L2_CID_COLORFX:
+		ctrl->value = priv->effects;
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
+		priv->reg_exp_gain = ctrl->value ? priv->reg_exp_gain & ~BIT(1)
+						: priv->reg_exp_gain | BIT(1);
+		ret = reg_write(client, REG_EXP_GAIN_CTRL, priv->reg_exp_gain);
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
+
+		priv->reg_exp_gain = ctrl->value == V4L2_EXPOSURE_MANUAL
+					? priv->reg_exp_gain | BIT(0) | BIT(2)
+					: priv->reg_exp_gain & ~(BIT(0) | BIT(2));
+		ret = reg_write(client, REG_EXP_GAIN_CTRL, priv->reg_exp_gain);
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
+						priv->total_height) {
+			ret = reg_write16(client, REG_EXTEND_FRAME_TIME_HIGH,
+					val32 / 16 + BLANKING_EXTRA_HEIGHT);
+			if (ret)
+				break;
+			dev_dbg(sd->v4l2_dev->dev,
+				"%s: Increasing vert. blanking. Total height: %d.\n",
+				__func__, val32 / 16 + BLANKING_EXTRA_HEIGHT);
+		} else if (priv->exposure + MANUAL_LONG_EXP_SAFETY_DISTANCE >
+						priv->total_height) {
+			/*
+			 * if we increased blanking in the past, but lowered the
+			 * exposure now sufficiently, we can go back to normal
+			 * timings
+			 */
+			ret = reg_write16(client, REG_EXTEND_FRAME_TIME_HIGH,
+					priv->total_height);
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
+		priv->reg_flip_subsample = ctrl->value
+					? priv->reg_flip_subsample | BIT(5)
+					: priv->reg_flip_subsample & ~BIT(5);
+		ret = reg_write(client, REG_FLIP_SUBSAMPLE,
+						priv->reg_flip_subsample);
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
+		priv->reg_digital_effects = ctrl->value
+					? priv->reg_digital_effects | BIT(0)
+					: priv->reg_digital_effects & ~BIT(0);
+		ret = reg_write(client, REG_DIGITAL_EFFECTS,
+						priv->reg_digital_effects);
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
+
+			/* determine bits for sine signs */
+			priv->reg_d_e_auxillary = trig < 0
+				? (priv->reg_d_e_auxillary & ~BIT(0)) | BIT(1)
+				: (priv->reg_d_e_auxillary | BIT(0)) & ~BIT(1);
+
+			trig = ov5642_cosine(ctrl->value) *
+						MAX_HUE_TRIG_NATIVE / 1000;
+			ret = reg_write(client, REG_HUE_COS, abs(trig));
+
+			/* determine bits for cosine signs */
+			priv->reg_d_e_auxillary = trig < 0
+				? priv->reg_d_e_auxillary | BIT(4) | BIT(5)
+				: priv->reg_d_e_auxillary & ~(BIT(4) | BIT(5));
+
+			ret = reg_write(client, REG_D_E_AUXILLARY,
+						priv->reg_d_e_auxillary);
+			if (ret)
+				break;
+
+			priv->hue = ctrl->value;
+			break;
+		}
+	case V4L2_CID_COLOR_KILLER:
+		priv->reg_digital_effects = ctrl->value
+					? priv->reg_digital_effects | BIT(5)
+					: priv->reg_digital_effects & ~BIT(5);
+		ret = reg_write(client, REG_DIGITAL_EFFECTS,
+						priv->reg_digital_effects);
+		if (!ret)
+			priv->grayscale = ctrl->value;
+		break;
+	case V4L2_CID_COLORFX:
+		priv->reg_d_e_auxillary = ctrl->value == V4L2_COLORFX_SOLARIZE
+					? priv->reg_d_e_auxillary | BIT(7)
+					: priv->reg_d_e_auxillary & ~BIT(7);
+		ret = reg_write(client, REG_D_E_AUXILLARY,
+						priv->reg_d_e_auxillary);
+		if (!ret)
+			priv->effects = ctrl->value;
+		break;
+	}
 	return ret;
 }
 
@@ -933,18 +1643,28 @@ static int ov5642_g_mbus_config(struct v4l2_subdev *sd,
 static int ov5642_s_power(struct v4l2_subdev *sd, int on)
 {
 	struct i2c_client *client;
+	struct ov5642 *priv;
 	int ret;
 
 	if (!on)
 		return 0;
 
 	client = v4l2_get_subdevdata(sd);
+	priv = to_ov5642(client);
 	ret = ov5642_write_array(client, ov5642_default_regs_init);
 	if (!ret)
 		ret = ov5642_set_resolution(sd);
 	if (!ret)
 		ret = ov5642_write_array(client, ov5642_default_regs_finalise);
 
+	priv->reg_exp_gain = REG_EXP_GAIN_INIT;
+	priv->reg_flip_subsample = REG_FLIP_SUBSAMPLE_INIT;
+	priv->reg_digital_effects = REG_DIGITAL_EFFECTS_INIT;
+	priv->reg_d_e_auxillary = REG_D_E_AUXILLARY_INIT;
+
+	/* the chip has been reset, so configure it again */
+	if (!ret)
+		ret = ov5642_restore_state(sd);
 	return ret;
 }
 
@@ -962,6 +1682,8 @@ static struct v4l2_subdev_video_ops ov5642_subdev_video_ops = {
 static struct v4l2_subdev_core_ops ov5642_subdev_core_ops = {
 	.s_power	= ov5642_s_power,
 	.g_chip_ident	= ov5642_g_chip_ident,
+	.g_ctrl		= ov5642_g_ctrl,
+	.s_ctrl		= ov5642_s_ctrl,
 #ifdef CONFIG_VIDEO_ADV_DEBUG
 	.g_register	= ov5642_get_register,
 	.s_register	= ov5642_set_register,
@@ -973,6 +1695,11 @@ static struct v4l2_subdev_ops ov5642_subdev_ops = {
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
@@ -1026,7 +1753,7 @@ static int ov5642_probe(struct i2c_client *client,
 
 	v4l2_i2c_subdev_init(&priv->subdev, client, &ov5642_subdev_ops);
 
-	icd->ops		= NULL;
+	icd->ops		= &soc_ov5642_ops;
 	priv->fmt		= &ov5642_colour_fmts[0];
 
 	priv->crop_rect.width	= OV5642_DEFAULT_WIDTH;
@@ -1038,6 +1765,15 @@ static int ov5642_probe(struct i2c_client *client,
 	priv->total_width = OV5642_DEFAULT_WIDTH + BLANKING_EXTRA_WIDTH;
 	priv->total_height = BLANKING_MIN_HEIGHT;
 
+	priv->aec		= V4L2_EXPOSURE_AUTO;
+	priv->agc		= true;
+	priv->awb		= true;
+	priv->blue_balance	= RBBALANCE_NATIVE_TO_V4L2(DEFAULT_RBBALANCE);
+	priv->red_balance	= RBBALANCE_NATIVE_TO_V4L2(DEFAULT_RBBALANCE);
+	priv->contrast		= DEFAULT_CONTRAST;
+	priv->blue_saturation	= DEFAULT_SATURATION;
+	priv->red_saturation	= DEFAULT_SATURATION;
+
 	ret = ov5642_video_probe(icd, client);
 	if (ret < 0)
 		goto error;


diff --git a/include/linux/videodev2.h b/include/linux/videodev2.h
index fca24cc..b0c7f78 100644
--- a/include/linux/videodev2.h
+++ b/include/linux/videodev2.h
@@ -1144,6 +1144,7 @@ enum v4l2_colorfx {
 	V4L2_COLORFX_GRASS_GREEN = 7,
 	V4L2_COLORFX_SKIN_WHITEN = 8,
 	V4L2_COLORFX_VIVID = 9,
+	V4L2_COLORFX_SOLARIZE = 10,
 };
 #define V4L2_CID_AUTOBRIGHTNESS			(V4L2_CID_BASE+32)
 #define V4L2_CID_BAND_STOP_FILTER		(V4L2_CID_BASE+33)
