Return-path: <mchehab@pedra>
Received: from smtp-vbr5.xs4all.nl ([194.109.24.25]:4566 "EHLO
	smtp-vbr5.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932544Ab1AKXGi (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 11 Jan 2011 18:06:38 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Magnus Damm <magnus.damm@gmail.com>,
	Kuninori Morimoto <morimoto.kuninori@renesas.com>,
	Alberto Panizzo <maramaopercheseimorto@gmail.com>,
	Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>,
	Marek Vasut <marek.vasut@gmail.com>,
	Robert Jarzmik <robert.jarzmik@free.fr>
Subject: [RFC PATCH 11/12] ov6550: convert to the control framework.
Date: Wed, 12 Jan 2011 00:06:11 +0100
Message-Id: <fe2d065b38ff7d719ced0a27038c74f6974dcf34.1294786597.git.hverkuil@xs4all.nl>
In-Reply-To: <1294787172-13638-1-git-send-email-hverkuil@xs4all.nl>
References: <1294787172-13638-1-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <8aa4d48eaf40a1e967e4a7450d9313de0e2c8452.1294786597.git.hverkuil@xs4all.nl>
References: <8aa4d48eaf40a1e967e4a7450d9313de0e2c8452.1294786597.git.hverkuil@xs4all.nl>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Signed-off-by: Hans Verkuil <hverkuil@xs4all.nl>
---
 drivers/media/video/ov6650.c |  383 +++++++++++++++---------------------------
 1 files changed, 135 insertions(+), 248 deletions(-)

diff --git a/drivers/media/video/ov6650.c b/drivers/media/video/ov6650.c
index cf93de9..98abfcc 100644
--- a/drivers/media/video/ov6650.c
+++ b/drivers/media/video/ov6650.c
@@ -31,6 +31,7 @@
 
 #include <media/soc_camera.h>
 #include <media/v4l2-chip-ident.h>
+#include <media/v4l2-ctrls.h>
 
 
 /* Register definitions */
@@ -177,7 +178,25 @@ struct ov6650_reg {
 
 struct ov6650 {
 	struct v4l2_subdev	subdev;
+	struct v4l2_ctrl_handler hdl;
+	struct {
+		/* exposure/autoexposure cluster */
+		struct v4l2_ctrl *autoexposure;
+		struct v4l2_ctrl *exposure;
+	};
+	struct {
+		/* gain/autogain cluster */
+		struct v4l2_ctrl *autogain;
+		struct v4l2_ctrl *gain;
+	};
+	struct {
+		/* blue/red/autowhitebalance cluster */
+		struct v4l2_ctrl *autowb;
+		struct v4l2_ctrl *blue;
+		struct v4l2_ctrl *red;
+	};
 
+	/*
 	int			gain;
 	int			blue;
 	int			red;
@@ -190,7 +209,7 @@ struct ov6650 {
 	bool			vflip;
 	bool			hflip;
 	bool			awb;
-	bool			agc;
+	bool			agc;*/
 	bool			half_scale;	/* scale down output by 2 */
 	struct v4l2_rect	rect;		/* sensor cropping window */
 	unsigned long		pclk_limit;	/* from host */
@@ -210,126 +229,6 @@ static enum v4l2_mbus_pixelcode ov6650_codes[] = {
 	V4L2_MBUS_FMT_GREY8_1X8,
 };
 
-static const struct v4l2_queryctrl ov6650_controls[] = {
-	{
-		.id		= V4L2_CID_AUTOGAIN,
-		.type		= V4L2_CTRL_TYPE_BOOLEAN,
-		.name		= "AGC",
-		.minimum	= 0,
-		.maximum	= 1,
-		.step		= 1,
-		.default_value	= 1,
-	},
-	{
-		.id		= V4L2_CID_GAIN,
-		.type		= V4L2_CTRL_TYPE_INTEGER,
-		.name		= "Gain",
-		.minimum	= 0,
-		.maximum	= 0x3f,
-		.step		= 1,
-		.default_value	= DEF_GAIN,
-	},
-	{
-		.id		= V4L2_CID_AUTO_WHITE_BALANCE,
-		.type		= V4L2_CTRL_TYPE_BOOLEAN,
-		.name		= "AWB",
-		.minimum	= 0,
-		.maximum	= 1,
-		.step		= 1,
-		.default_value	= 1,
-	},
-	{
-		.id		= V4L2_CID_BLUE_BALANCE,
-		.type		= V4L2_CTRL_TYPE_INTEGER,
-		.name		= "Blue",
-		.minimum	= 0,
-		.maximum	= 0xff,
-		.step		= 1,
-		.default_value	= DEF_BLUE,
-	},
-	{
-		.id		= V4L2_CID_RED_BALANCE,
-		.type		= V4L2_CTRL_TYPE_INTEGER,
-		.name		= "Red",
-		.minimum	= 0,
-		.maximum	= 0xff,
-		.step		= 1,
-		.default_value	= DEF_RED,
-	},
-	{
-		.id		= V4L2_CID_SATURATION,
-		.type		= V4L2_CTRL_TYPE_INTEGER,
-		.name		= "Saturation",
-		.minimum	= 0,
-		.maximum	= 0xf,
-		.step		= 1,
-		.default_value	= 0x8,
-	},
-	{
-		.id		= V4L2_CID_HUE,
-		.type		= V4L2_CTRL_TYPE_INTEGER,
-		.name		= "Hue",
-		.minimum	= 0,
-		.maximum	= HUE_MASK,
-		.step		= 1,
-		.default_value	= DEF_HUE,
-	},
-	{
-		.id		= V4L2_CID_BRIGHTNESS,
-		.type		= V4L2_CTRL_TYPE_INTEGER,
-		.name		= "Brightness",
-		.minimum	= 0,
-		.maximum	= 0xff,
-		.step		= 1,
-		.default_value	= 0x80,
-	},
-	{
-		.id		= V4L2_CID_EXPOSURE_AUTO,
-		.type		= V4L2_CTRL_TYPE_INTEGER,
-		.name		= "AEC",
-		.minimum	= 0,
-		.maximum	= 3,
-		.step		= 1,
-		.default_value	= 0,
-	},
-	{
-		.id		= V4L2_CID_EXPOSURE,
-		.type		= V4L2_CTRL_TYPE_INTEGER,
-		.name		= "Exposure",
-		.minimum	= 0,
-		.maximum	= 0xff,
-		.step		= 1,
-		.default_value	= DEF_AECH,
-	},
-	{
-		.id		= V4L2_CID_GAMMA,
-		.type		= V4L2_CTRL_TYPE_INTEGER,
-		.name		= "Gamma",
-		.minimum	= 0,
-		.maximum	= 0xff,
-		.step		= 1,
-		.default_value	= 0x12,
-	},
-	{
-		.id		= V4L2_CID_VFLIP,
-		.type		= V4L2_CTRL_TYPE_BOOLEAN,
-		.name		= "Flip Vertically",
-		.minimum	= 0,
-		.maximum	= 1,
-		.step		= 1,
-		.default_value	= 0,
-	},
-	{
-		.id		= V4L2_CID_HFLIP,
-		.type		= V4L2_CTRL_TYPE_BOOLEAN,
-		.name		= "Flip Horizontally",
-		.minimum	= 0,
-		.maximum	= 1,
-		.step		= 1,
-		.default_value	= 0,
-	},
-};
-
 /* read a register */
 static int ov6650_reg_read(struct i2c_client *client, u8 reg, u8 *val)
 {
@@ -466,166 +365,109 @@ static unsigned long ov6650_query_bus_param(struct soc_camera_device *icd)
 }
 
 /* Get status of additional camera capabilities */
-static int ov6650_g_ctrl(struct v4l2_subdev *sd, struct v4l2_control *ctrl)
+static int ov6550_g_volatile_ctrl(struct v4l2_ctrl *ctrl)
 {
+	struct v4l2_subdev *sd =
+		&container_of(ctrl->handler, struct ov6650, hdl)->subdev;
 	struct i2c_client *client = v4l2_get_subdevdata(sd);
 	struct ov6650 *priv = to_ov6650(client);
-	uint8_t reg;
+	uint8_t reg, reg2;
 	int ret = 0;
 
 	switch (ctrl->id) {
 	case V4L2_CID_AUTOGAIN:
-		ctrl->value = priv->agc;
-		break;
-	case V4L2_CID_GAIN:
-		if (priv->agc) {
-			ret = ov6650_reg_read(client, REG_GAIN, &reg);
-			ctrl->value = reg;
-		} else {
-			ctrl->value = priv->gain;
-		}
-		break;
+		if (!ctrl->cur.val)
+			return 0;
+		ret = ov6650_reg_read(client, REG_GAIN, &reg);
+		if (!ret)
+			priv->gain->cur.val = reg;
+		return ret;
 	case V4L2_CID_AUTO_WHITE_BALANCE:
-		ctrl->value = priv->awb;
-		break;
-	case V4L2_CID_BLUE_BALANCE:
-		if (priv->awb) {
-			ret = ov6650_reg_read(client, REG_BLUE, &reg);
-			ctrl->value = reg;
-		} else {
-			ctrl->value = priv->blue;
-		}
-		break;
-	case V4L2_CID_RED_BALANCE:
-		if (priv->awb) {
-			ret = ov6650_reg_read(client, REG_RED, &reg);
-			ctrl->value = reg;
-		} else {
-			ctrl->value = priv->red;
+		if (!ctrl->cur.val)
+			return 0;
+		ret = ov6650_reg_read(client, REG_BLUE, &reg);
+		if (!ret)
+			ret = ov6650_reg_read(client, REG_RED, &reg2);
+		if (!ret) {
+			priv->blue->cur.val = reg;
+			priv->red->cur.val = reg2;
 		}
-		break;
-	case V4L2_CID_SATURATION:
-		ctrl->value = priv->saturation;
-		break;
-	case V4L2_CID_HUE:
-		ctrl->value = priv->hue;
-		break;
-	case V4L2_CID_BRIGHTNESS:
-		ctrl->value = priv->brightness;
-		break;
+		return ret;
 	case V4L2_CID_EXPOSURE_AUTO:
-		ctrl->value = priv->aec;
-		break;
-	case V4L2_CID_EXPOSURE:
-		if (priv->aec) {
-			ret = ov6650_reg_read(client, REG_AECH, &reg);
-			ctrl->value = reg;
-		} else {
-			ctrl->value = priv->exposure;
-		}
-		break;
-	case V4L2_CID_GAMMA:
-		ctrl->value = priv->gamma;
-		break;
-	case V4L2_CID_VFLIP:
-		ctrl->value = priv->vflip;
-		break;
-	case V4L2_CID_HFLIP:
-		ctrl->value = priv->hflip;
-		break;
+		if (ctrl->cur.val != V4L2_CID_EXPOSURE_AUTO)
+			return 0;
+		ret = ov6650_reg_read(client, REG_AECH, &reg);
+		if (!ret)
+			priv->exposure->cur.val = reg;
+		return ret;
 	}
-	return ret;
+	return -EINVAL;
 }
 
 /* Set status of additional camera capabilities */
-static int ov6650_s_ctrl(struct v4l2_subdev *sd, struct v4l2_control *ctrl)
+static int ov6550_s_ctrl(struct v4l2_ctrl *ctrl)
 {
+	struct v4l2_subdev *sd =
+		&container_of(ctrl->handler, struct ov6650, hdl)->subdev;
 	struct i2c_client *client = v4l2_get_subdevdata(sd);
 	struct ov6650 *priv = to_ov6650(client);
 	int ret = 0;
 
 	switch (ctrl->id) {
 	case V4L2_CID_AUTOGAIN:
+		/* Force manual gain if only the gain was changed */
+		if (!ctrl->has_new)
+			ctrl->val = 0;
 		ret = ov6650_reg_rmw(client, REG_COMB,
-				ctrl->value ? COMB_AGC : 0, COMB_AGC);
-		if (!ret)
-			priv->agc = ctrl->value;
-		break;
-	case V4L2_CID_GAIN:
-		ret = ov6650_reg_write(client, REG_GAIN, ctrl->value);
-		if (!ret)
-			priv->gain = ctrl->value;
-		break;
+				ctrl->val ? COMB_AGC : 0, COMB_AGC);
+		if (!ret && !ctrl->val)
+			ret = ov6650_reg_write(client, REG_GAIN, priv->gain->val);
+		return ret;;
 	case V4L2_CID_AUTO_WHITE_BALANCE:
+		/* Force manual balance if only the red and/or blue balance
+		   was changed */
+		if (!ctrl->has_new)
+			ctrl->val = 0;
 		ret = ov6650_reg_rmw(client, REG_COMB,
-				ctrl->value ? COMB_AWB : 0, COMB_AWB);
-		if (!ret)
-			priv->awb = ctrl->value;
-		break;
-	case V4L2_CID_BLUE_BALANCE:
-		ret = ov6650_reg_write(client, REG_BLUE, ctrl->value);
-		if (!ret)
-			priv->blue = ctrl->value;
-		break;
-	case V4L2_CID_RED_BALANCE:
-		ret = ov6650_reg_write(client, REG_RED, ctrl->value);
-		if (!ret)
-			priv->red = ctrl->value;
-		break;
+				ctrl->val ? COMB_AWB : 0, COMB_AWB);
+		if (!ret && !ctrl->val) {
+			ret = ov6650_reg_write(client, REG_BLUE, priv->blue->val);
+			if (!ret)
+				ret = ov6650_reg_write(client, REG_BLUE,
+							priv->red->val);
+		}
+		return ret;
 	case V4L2_CID_SATURATION:
-		ret = ov6650_reg_rmw(client, REG_SAT, SET_SAT(ctrl->value),
+		return ov6650_reg_rmw(client, REG_SAT, SET_SAT(ctrl->val),
 				SAT_MASK);
-		if (!ret)
-			priv->saturation = ctrl->value;
-		break;
 	case V4L2_CID_HUE:
-		ret = ov6650_reg_rmw(client, REG_HUE, SET_HUE(ctrl->value),
+		return ov6650_reg_rmw(client, REG_HUE, SET_HUE(ctrl->val),
 				HUE_MASK);
-		if (!ret)
-			priv->hue = ctrl->value;
-		break;
 	case V4L2_CID_BRIGHTNESS:
-		ret = ov6650_reg_write(client, REG_BRT, ctrl->value);
-		if (!ret)
-			priv->brightness = ctrl->value;
-		break;
+		return ov6650_reg_write(client, REG_BRT, ctrl->val);
 	case V4L2_CID_EXPOSURE_AUTO:
-		switch (ctrl->value) {
-		case V4L2_EXPOSURE_AUTO:
+		/* Force manual exposure if only the exposure was changed */
+		if (!ctrl->has_new)
+			ctrl->val = V4L2_EXPOSURE_MANUAL;
+		if (ctrl->val == V4L2_EXPOSURE_AUTO)
 			ret = ov6650_reg_rmw(client, REG_COMB, COMB_AEC, 0);
-			break;
-		default:
+		else
 			ret = ov6650_reg_rmw(client, REG_COMB, 0, COMB_AEC);
-			break;
-		}
-		if (!ret)
-			priv->aec = ctrl->value;
-		break;
-	case V4L2_CID_EXPOSURE:
-		ret = ov6650_reg_write(client, REG_AECH, ctrl->value);
-		if (!ret)
-			priv->exposure = ctrl->value;
-		break;
+		if (!ret && ctrl->val == V4L2_EXPOSURE_MANUAL)
+			ret = ov6650_reg_write(client, REG_AECH,
+						priv->exposure->val);
+		return ret;
 	case V4L2_CID_GAMMA:
-		ret = ov6650_reg_write(client, REG_GAM1, ctrl->value);
-		if (!ret)
-			priv->gamma = ctrl->value;
-		break;
+		return ov6650_reg_write(client, REG_GAM1, ctrl->val);
 	case V4L2_CID_VFLIP:
-		ret = ov6650_reg_rmw(client, REG_COMB,
-				ctrl->value ? COMB_FLIP_V : 0, COMB_FLIP_V);
-		if (!ret)
-			priv->vflip = ctrl->value;
-		break;
+		return ov6650_reg_rmw(client, REG_COMB,
+				ctrl->val ? COMB_FLIP_V : 0, COMB_FLIP_V);
 	case V4L2_CID_HFLIP:
-		ret = ov6650_reg_rmw(client, REG_COMB,
-				ctrl->value ? COMB_FLIP_H : 0, COMB_FLIP_H);
-		if (!ret)
-			priv->hflip = ctrl->value;
-		break;
+		return ov6650_reg_rmw(client, REG_COMB,
+				ctrl->val ? COMB_FLIP_H : 0, COMB_FLIP_H);
 	}
 
-	return ret;
+	return -EINVAL;
 }
 
 /* Get chip identification */
@@ -1097,13 +939,14 @@ static int ov6650_video_probe(struct soc_camera_device *icd,
 static struct soc_camera_ops ov6650_ops = {
 	.set_bus_param		= ov6650_set_bus_param,
 	.query_bus_param	= ov6650_query_bus_param,
-	.controls		= ov6650_controls,
-	.num_controls		= ARRAY_SIZE(ov6650_controls),
+};
+
+static const struct v4l2_ctrl_ops ov6550_ctrl_ops = {
+	.g_volatile_ctrl = ov6550_g_volatile_ctrl,
+	.s_ctrl = ov6550_s_ctrl,
 };
 
 static struct v4l2_subdev_core_ops ov6650_core_ops = {
-	.g_ctrl			= ov6650_g_ctrl,
-	.s_ctrl			= ov6650_s_ctrl,
 	.g_chip_ident		= ov6650_g_chip_ident,
 #ifdef CONFIG_VIDEO_ADV_DEBUG
 	.g_register		= ov6650_get_register,
@@ -1159,6 +1002,45 @@ static int ov6650_probe(struct i2c_client *client,
 	}
 
 	v4l2_i2c_subdev_init(&priv->subdev, client, &ov6650_subdev_ops);
+	v4l2_ctrl_handler_init(&priv->hdl, 13);
+	v4l2_ctrl_new_std(&priv->hdl, &ov6550_ctrl_ops,
+			V4L2_CID_VFLIP, 0, 1, 1, 0);
+	v4l2_ctrl_new_std(&priv->hdl, &ov6550_ctrl_ops,
+			V4L2_CID_HFLIP, 0, 1, 1, 0);
+	priv->autogain = v4l2_ctrl_new_std(&priv->hdl, &ov6550_ctrl_ops,
+			V4L2_CID_AUTOGAIN, 0, 1, 1, 1);
+	priv->gain = v4l2_ctrl_new_std(&priv->hdl, &ov6550_ctrl_ops,
+			V4L2_CID_GAIN, 0, 0x3f, 1, DEF_GAIN);
+	priv->autowb = v4l2_ctrl_new_std(&priv->hdl, &ov6550_ctrl_ops,
+			V4L2_CID_AUTO_WHITE_BALANCE, 0, 1, 1, 1);
+	priv->blue = v4l2_ctrl_new_std(&priv->hdl, &ov6550_ctrl_ops,
+			V4L2_CID_BLUE_BALANCE, 0, 0xff, 1, DEF_BLUE);
+	priv->red = v4l2_ctrl_new_std(&priv->hdl, &ov6550_ctrl_ops,
+			V4L2_CID_RED_BALANCE, 0, 0xff, 1, DEF_RED);
+	v4l2_ctrl_new_std(&priv->hdl, &ov6550_ctrl_ops,
+			V4L2_CID_SATURATION, 0, 0xf, 1, 0x8);
+	v4l2_ctrl_new_std(&priv->hdl, &ov6550_ctrl_ops,
+			V4L2_CID_HUE, 0, HUE_MASK, 1, DEF_HUE);
+	v4l2_ctrl_new_std(&priv->hdl, &ov6550_ctrl_ops,
+			V4L2_CID_BRIGHTNESS, 0, 0xff, 1, 0x80);
+	priv->autoexposure = v4l2_ctrl_new_std_menu(&priv->hdl,
+			&ov6550_ctrl_ops, V4L2_CID_EXPOSURE_AUTO, 1, 0,
+			V4L2_EXPOSURE_AUTO);
+	priv->exposure = v4l2_ctrl_new_std(&priv->hdl, &ov6550_ctrl_ops,
+			V4L2_CID_EXPOSURE, 0, 0xff, 1, DEF_AECH);
+	v4l2_ctrl_new_std(&priv->hdl, &ov6550_ctrl_ops,
+			V4L2_CID_GAMMA, 0, 0xff, 1, 0x12);
+
+	priv->subdev.ctrl_handler = &priv->hdl;
+	if (priv->hdl.error) {
+		int err = priv->hdl.error;
+
+		kfree(priv);
+		return err;
+	}
+	v4l2_ctrl_cluster(2, &priv->autogain);
+	v4l2_ctrl_cluster(3, &priv->autowb);
+	v4l2_ctrl_cluster(2, &priv->autoexposure);
 
 	icd->ops = &ov6650_ops;
 
@@ -1171,9 +1053,12 @@ static int ov6650_probe(struct i2c_client *client,
 	priv->colorspace  = V4L2_COLORSPACE_JPEG;
 
 	ret = ov6650_video_probe(icd, client);
+	if (!ret)
+		ret = v4l2_ctrl_handler_setup(&priv->hdl);
 
 	if (ret) {
 		icd->ops = NULL;
+		v4l2_ctrl_handler_free(&priv->hdl);
 		kfree(priv);
 	}
 
@@ -1184,6 +1069,8 @@ static int ov6650_remove(struct i2c_client *client)
 {
 	struct ov6650 *priv = to_ov6650(client);
 
+	v4l2_device_unregister_subdev(&priv->subdev);
+	v4l2_ctrl_handler_free(&priv->hdl);
 	kfree(priv);
 	return 0;
 }
-- 
1.7.0.4

