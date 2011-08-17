Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:47331 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753685Ab1HQQCN (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 17 Aug 2011 12:02:13 -0400
Received: by bke11 with SMTP id 11so807840bke.19
        for <linux-media@vger.kernel.org>; Wed, 17 Aug 2011 09:02:12 -0700 (PDT)
Date: Wed, 17 Aug 2011 16:02:07 +0000 (UTC)
From: Bastian Hecht <hechtb@googlemail.com>
To: linux-media@vger.kernel.org
cc: laurent.pinchart@ideasonboard.com,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: [PATCH] media: Add camera controls for the ov5642 driver
Message-ID: <alpine.DEB.2.02.1108171553540.17550@ipanema>
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

diff --git a/drivers/media/video/ov5642.c b/drivers/media/video/ov5642.c
index 1b40d90..069a720 100644
--- a/drivers/media/video/ov5642.c
+++ b/drivers/media/video/ov5642.c
@@ -74,6 +74,34 @@
 #define REG_AVG_WINDOW_END_Y_HIGH	0x5686
 #define REG_AVG_WINDOW_END_Y_LOW	0x5687
 
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
 /* active pixel array size */
 #define OV5642_SENSOR_SIZE_X	2592
 #define OV5642_SENSOR_SIZE_Y	1944
@@ -109,6 +137,9 @@
  * 1:1 scale. Hopefully these restrictions will be removed in the future.
  */
 
+static int ov5642_s_ctrl(struct v4l2_subdev *sd, struct v4l2_control *ctrl);
+static int ov5642_g_ctrl(struct v4l2_subdev *sd, struct v4l2_control *ctrl);
+
 struct regval_list {
 	u16 reg_num;
 	u8 value;
@@ -608,6 +639,145 @@ static struct regval_list ov5642_default_regs_finalise[] = {
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
@@ -627,6 +797,24 @@ struct ov5642 {
 	const struct ov5642_datafmt	*fmt;
 	struct v4l2_rect                crop_rect;
 	struct ov5642_out_size		out_size;
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
@@ -672,6 +860,27 @@ static int reg_read(struct i2c_client *client, u16 reg, u8 *val)
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
@@ -804,6 +1013,100 @@ static int ov5642_set_resolution(struct v4l2_subdev *sd)
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
+	set_ctrl.id = OV5642_CONTROL_GRAY_SCALE;
+	set_ctrl.value = priv->grayscale;
+	if (!ret)
+		ret = ov5642_s_ctrl(sd, &set_ctrl);
+
+	set_ctrl.id = OV5642_CONTROL_SOLARIZE;
+	set_ctrl.value = priv->solarize;
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
 static int ov5642_try_fmt(struct v4l2_subdev *sd, struct v4l2_mbus_framefmt *mf)
 {
 	const struct ov5642_datafmt *fmt   = ov5642_find_datafmt(mf->code);
@@ -856,6 +1159,9 @@ static int ov5642_s_fmt(struct v4l2_subdev *sd, struct v4l2_mbus_framefmt *mf)
 	if (!ret)
 		ret = ov5642_write_array(client, ov5642_default_regs_finalise);
 
+	/* the chip has been reset, so configure it again */
+	if (!ret)
+		ret = ov5642_restore_state(sd);
 	return ret;
 }
 
@@ -904,6 +1210,387 @@ static int ov5642_g_chip_ident(struct v4l2_subdev *sd,
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
 	struct i2c_client *client = v4l2_get_subdevdata(sd);
@@ -956,6 +1643,8 @@ static struct v4l2_subdev_video_ops ov5642_subdev_video_ops = {
 
 static struct v4l2_subdev_core_ops ov5642_subdev_core_ops = {
 	.g_chip_ident	= ov5642_g_chip_ident,
+	.g_ctrl		= ov5642_g_ctrl,
+	.s_ctrl		= ov5642_s_ctrl,
 #ifdef CONFIG_VIDEO_ADV_DEBUG
 	.g_register	= ov5642_get_register,
 	.s_register	= ov5642_set_register,
@@ -967,6 +1656,11 @@ static struct v4l2_subdev_ops ov5642_subdev_ops = {
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
@@ -1020,7 +1714,7 @@ static int ov5642_probe(struct i2c_client *client,
 
 	v4l2_i2c_subdev_init(&priv->subdev, client, &ov5642_subdev_ops);
 
-	icd->ops		= NULL;
+	icd->ops		= &soc_ov5642_ops;
 	priv->fmt		= &ov5642_colour_fmts[0];
 
 	priv->crop_rect.width	= OV5642_DEFAULT_WIDTH;
@@ -1030,6 +1724,15 @@ static int ov5642_probe(struct i2c_client *client,
 	priv->out_size.width	= OV5642_DEFAULT_WIDTH;
 	priv->out_size.height	= OV5642_DEFAULT_HEIGHT;
 
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
