Return-path: <mchehab@pedra>
Received: from smtp-vbr5.xs4all.nl ([194.109.24.25]:2621 "EHLO
	smtp-vbr5.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932378Ab1AKXGe (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 11 Jan 2011 18:06:34 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Magnus Damm <magnus.damm@gmail.com>,
	Kuninori Morimoto <morimoto.kuninori@renesas.com>,
	Alberto Panizzo <maramaopercheseimorto@gmail.com>,
	Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>,
	Marek Vasut <marek.vasut@gmail.com>,
	Robert Jarzmik <robert.jarzmik@free.fr>
Subject: [RFC PATCH 07/12] mt9v022: convert to the control framework.
Date: Wed, 12 Jan 2011 00:06:07 +0100
Message-Id: <598e92bcd5bbdd88218f071a00f704866bf4e431.1294786597.git.hverkuil@xs4all.nl>
In-Reply-To: <1294787172-13638-1-git-send-email-hverkuil@xs4all.nl>
References: <1294787172-13638-1-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <8aa4d48eaf40a1e967e4a7450d9313de0e2c8452.1294786597.git.hverkuil@xs4all.nl>
References: <8aa4d48eaf40a1e967e4a7450d9313de0e2c8452.1294786597.git.hverkuil@xs4all.nl>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Signed-off-by: Hans Verkuil <hverkuil@xs4all.nl>
---
 drivers/media/video/mt9v022.c |  271 ++++++++++++++++++-----------------------
 1 files changed, 119 insertions(+), 152 deletions(-)

diff --git a/drivers/media/video/mt9v022.c b/drivers/media/video/mt9v022.c
index 6a784c8..49731f9 100644
--- a/drivers/media/video/mt9v022.c
+++ b/drivers/media/video/mt9v022.c
@@ -16,6 +16,7 @@
 
 #include <media/v4l2-subdev.h>
 #include <media/v4l2-chip-ident.h>
+#include <media/v4l2-ctrls.h>
 #include <media/soc_camera.h>
 
 /*
@@ -100,6 +101,17 @@ static const struct mt9v022_datafmt mt9v022_monochrome_fmts[] = {
 
 struct mt9v022 {
 	struct v4l2_subdev subdev;
+	struct v4l2_ctrl_handler hdl;
+	struct {
+		/* exposure/auto-exposure cluster */
+		struct v4l2_ctrl *autoexposure;
+		struct v4l2_ctrl *exposure;
+	};
+	struct {
+		/* gain/auto-gain cluster */
+		struct v4l2_ctrl *autogain;
+		struct v4l2_ctrl *gain;
+	};
 	struct v4l2_rect rect;	/* Sensor window */
 	const struct mt9v022_datafmt *fmt;
 	const struct mt9v022_datafmt *fmts;
@@ -178,6 +190,8 @@ static int mt9v022_init(struct i2c_client *client)
 		ret = reg_clear(client, MT9V022_BLACK_LEVEL_CALIB_CTRL, 1);
 	if (!ret)
 		ret = reg_write(client, MT9V022_DIGITAL_TEST_PATTERN, 0);
+	if (!ret)
+		return v4l2_ctrl_handler_setup(&mt9v022->hdl);
 
 	return ret;
 }
@@ -502,217 +516,133 @@ static int mt9v022_s_register(struct v4l2_subdev *sd,
 }
 #endif
 
-static const struct v4l2_queryctrl mt9v022_controls[] = {
-	{
-		.id		= V4L2_CID_VFLIP,
-		.type		= V4L2_CTRL_TYPE_BOOLEAN,
-		.name		= "Flip Vertically",
-		.minimum	= 0,
-		.maximum	= 1,
-		.step		= 1,
-		.default_value	= 0,
-	}, {
-		.id		= V4L2_CID_HFLIP,
-		.type		= V4L2_CTRL_TYPE_BOOLEAN,
-		.name		= "Flip Horizontally",
-		.minimum	= 0,
-		.maximum	= 1,
-		.step		= 1,
-		.default_value	= 0,
-	}, {
-		.id		= V4L2_CID_GAIN,
-		.type		= V4L2_CTRL_TYPE_INTEGER,
-		.name		= "Analog Gain",
-		.minimum	= 64,
-		.maximum	= 127,
-		.step		= 1,
-		.default_value	= 64,
-		.flags		= V4L2_CTRL_FLAG_SLIDER,
-	}, {
-		.id		= V4L2_CID_EXPOSURE,
-		.type		= V4L2_CTRL_TYPE_INTEGER,
-		.name		= "Exposure",
-		.minimum	= 1,
-		.maximum	= 255,
-		.step		= 1,
-		.default_value	= 255,
-		.flags		= V4L2_CTRL_FLAG_SLIDER,
-	}, {
-		.id		= V4L2_CID_AUTOGAIN,
-		.type		= V4L2_CTRL_TYPE_BOOLEAN,
-		.name		= "Automatic Gain",
-		.minimum	= 0,
-		.maximum	= 1,
-		.step		= 1,
-		.default_value	= 1,
-	}, {
-		.id		= V4L2_CID_EXPOSURE_AUTO,
-		.type		= V4L2_CTRL_TYPE_BOOLEAN,
-		.name		= "Automatic Exposure",
-		.minimum	= 0,
-		.maximum	= 1,
-		.step		= 1,
-		.default_value	= 1,
-	}
-};
-
 static struct soc_camera_ops mt9v022_ops = {
 	.set_bus_param		= mt9v022_set_bus_param,
 	.query_bus_param	= mt9v022_query_bus_param,
-	.controls		= mt9v022_controls,
-	.num_controls		= ARRAY_SIZE(mt9v022_controls),
 };
 
-static int mt9v022_g_ctrl(struct v4l2_subdev *sd, struct v4l2_control *ctrl)
+static int mt9v022_g_volatile_ctrl(struct v4l2_ctrl *ctrl)
 {
+	struct v4l2_subdev *sd =
+		&container_of(ctrl->handler, struct mt9v022, hdl)->subdev;
 	struct i2c_client *client = v4l2_get_subdevdata(sd);
-	const struct v4l2_queryctrl *qctrl;
+	struct mt9v022 *mt9v022 = to_mt9v022(client);
+	struct v4l2_ctrl *gain = mt9v022->gain;
+	struct v4l2_ctrl *exp = mt9v022->exposure;
 	unsigned long range;
 	int data;
 
-	qctrl = soc_camera_find_qctrl(&mt9v022_ops, ctrl->id);
-
 	switch (ctrl->id) {
-	case V4L2_CID_VFLIP:
-		data = reg_read(client, MT9V022_READ_MODE);
-		if (data < 0)
-			return -EIO;
-		ctrl->value = !!(data & 0x10);
-		break;
-	case V4L2_CID_HFLIP:
-		data = reg_read(client, MT9V022_READ_MODE);
-		if (data < 0)
-			return -EIO;
-		ctrl->value = !!(data & 0x20);
-		break;
-	case V4L2_CID_EXPOSURE_AUTO:
-		data = reg_read(client, MT9V022_AEC_AGC_ENABLE);
-		if (data < 0)
-			return -EIO;
-		ctrl->value = !!(data & 0x1);
-		break;
 	case V4L2_CID_AUTOGAIN:
-		data = reg_read(client, MT9V022_AEC_AGC_ENABLE);
-		if (data < 0)
-			return -EIO;
-		ctrl->value = !!(data & 0x2);
-		break;
-	case V4L2_CID_GAIN:
+		if (!ctrl->cur.val)
+			return 0;
 		data = reg_read(client, MT9V022_ANALOG_GAIN);
 		if (data < 0)
 			return -EIO;
 
-		range = qctrl->maximum - qctrl->minimum;
-		ctrl->value = ((data - 16) * range + 24) / 48 + qctrl->minimum;
+		range = gain->maximum - gain->minimum;
+		gain->cur.val = ((data - 16) * range + 24) / 48 + gain->minimum;
+		return 0;
 
-		break;
-	case V4L2_CID_EXPOSURE:
+	case V4L2_CID_EXPOSURE_AUTO:
+		if (ctrl->cur.val != V4L2_CID_EXPOSURE_AUTO)
+			return 0;
 		data = reg_read(client, MT9V022_TOTAL_SHUTTER_WIDTH);
 		if (data < 0)
 			return -EIO;
 
-		range = qctrl->maximum - qctrl->minimum;
-		ctrl->value = ((data - 1) * range + 239) / 479 + qctrl->minimum;
-
-		break;
+		range = exp->maximum - exp->minimum;
+		exp->cur.val = ((data - 1) * range + 239) / 479 + exp->minimum;
+		return 0;
 	}
-	return 0;
+	return -EINVAL;
 }
 
-static int mt9v022_s_ctrl(struct v4l2_subdev *sd, struct v4l2_control *ctrl)
+static int mt9v022_s_ctrl(struct v4l2_ctrl *ctrl)
 {
-	int data;
+	struct v4l2_subdev *sd =
+		&container_of(ctrl->handler, struct mt9v022, hdl)->subdev;
 	struct i2c_client *client = v4l2_get_subdevdata(sd);
-	const struct v4l2_queryctrl *qctrl;
-
-	qctrl = soc_camera_find_qctrl(&mt9v022_ops, ctrl->id);
-	if (!qctrl)
-		return -EINVAL;
+	struct mt9v022 *mt9v022 = to_mt9v022(client);
+	int data;
 
 	switch (ctrl->id) {
 	case V4L2_CID_VFLIP:
-		if (ctrl->value)
+		if (ctrl->val)
 			data = reg_set(client, MT9V022_READ_MODE, 0x10);
 		else
 			data = reg_clear(client, MT9V022_READ_MODE, 0x10);
 		if (data < 0)
 			return -EIO;
-		break;
+		return 0;
 	case V4L2_CID_HFLIP:
-		if (ctrl->value)
+		if (ctrl->val)
 			data = reg_set(client, MT9V022_READ_MODE, 0x20);
 		else
 			data = reg_clear(client, MT9V022_READ_MODE, 0x20);
 		if (data < 0)
 			return -EIO;
-		break;
-	case V4L2_CID_GAIN:
-		/* mt9v022 has minimum == default */
-		if (ctrl->value > qctrl->maximum || ctrl->value < qctrl->minimum)
-			return -EINVAL;
-		else {
-			unsigned long range = qctrl->maximum - qctrl->minimum;
+		return 0;
+	case V4L2_CID_AUTOGAIN:
+		/* Force manual gain if only the gain was changed */
+		if (!ctrl->has_new)
+			ctrl->val = 0;
+		if (ctrl->val) {
+			if (reg_set(client, MT9V022_AEC_AGC_ENABLE, 0x2) < 0)
+				return -EIO;
+		} else {
+			struct v4l2_ctrl *gain = mt9v022->gain;
+			/* mt9v022 has minimum == default */
+			unsigned long range = gain->maximum - gain->minimum;
 			/* Valid values 16 to 64, 32 to 64 must be even. */
-			unsigned long gain = ((ctrl->value - qctrl->minimum) *
+			unsigned long gain_val = ((gain->val - gain->minimum) *
 					      48 + range / 2) / range + 16;
-			if (gain >= 32)
-				gain &= ~1;
+
+			if (gain_val >= 32)
+				gain_val &= ~1;
+
 			/*
 			 * The user wants to set gain manually, hope, she
 			 * knows, what she's doing... Switch AGC off.
 			 */
-
 			if (reg_clear(client, MT9V022_AEC_AGC_ENABLE, 0x2) < 0)
 				return -EIO;
 
 			dev_dbg(&client->dev, "Setting gain from %d to %lu\n",
-				reg_read(client, MT9V022_ANALOG_GAIN), gain);
-			if (reg_write(client, MT9V022_ANALOG_GAIN, gain) < 0)
+				reg_read(client, MT9V022_ANALOG_GAIN), gain_val);
+			if (reg_write(client, MT9V022_ANALOG_GAIN, gain_val) < 0)
 				return -EIO;
 		}
-		break;
-	case V4L2_CID_EXPOSURE:
-		/* mt9v022 has maximum == default */
-		if (ctrl->value > qctrl->maximum || ctrl->value < qctrl->minimum)
-			return -EINVAL;
-		else {
-			unsigned long range = qctrl->maximum - qctrl->minimum;
-			unsigned long shutter = ((ctrl->value - qctrl->minimum) *
-						 479 + range / 2) / range + 1;
+		return 0;
+	case V4L2_CID_EXPOSURE_AUTO:
+		/* Force manual exposure if only the exposure was changed */
+		if (!ctrl->has_new)
+			ctrl->val = V4L2_EXPOSURE_MANUAL;
+		if (ctrl->val == V4L2_EXPOSURE_AUTO) {
+			data = reg_set(client, MT9V022_AEC_AGC_ENABLE, 0x1);
+		} else {
+			struct v4l2_ctrl *exp = mt9v022->exposure;
+			unsigned long range = exp->maximum - exp->minimum;
+			unsigned long shutter = ((exp->val - exp->minimum) *
+					479 + range / 2) / range + 1;
+
 			/*
 			 * The user wants to set shutter width manually, hope,
 			 * she knows, what she's doing... Switch AEC off.
 			 */
-
-			if (reg_clear(client, MT9V022_AEC_AGC_ENABLE, 0x1) < 0)
+			data = reg_clear(client, MT9V022_AEC_AGC_ENABLE, 0x1);
+			if (data < 0)
 				return -EIO;
-
 			dev_dbg(&client->dev, "Shutter width from %d to %lu\n",
-				reg_read(client, MT9V022_TOTAL_SHUTTER_WIDTH),
-				shutter);
+					reg_read(client, MT9V022_TOTAL_SHUTTER_WIDTH),
+					shutter);
 			if (reg_write(client, MT9V022_TOTAL_SHUTTER_WIDTH,
-				      shutter) < 0)
+						shutter) < 0)
 				return -EIO;
 		}
-		break;
-	case V4L2_CID_AUTOGAIN:
-		if (ctrl->value)
-			data = reg_set(client, MT9V022_AEC_AGC_ENABLE, 0x2);
-		else
-			data = reg_clear(client, MT9V022_AEC_AGC_ENABLE, 0x2);
-		if (data < 0)
-			return -EIO;
-		break;
-	case V4L2_CID_EXPOSURE_AUTO:
-		if (ctrl->value)
-			data = reg_set(client, MT9V022_AEC_AGC_ENABLE, 0x1);
-		else
-			data = reg_clear(client, MT9V022_AEC_AGC_ENABLE, 0x1);
-		if (data < 0)
-			return -EIO;
-		break;
+		return 0;
 	}
-	return 0;
+	return -EINVAL;
 }
 
 /*
@@ -825,9 +755,12 @@ static int mt9v022_g_skip_top_lines(struct v4l2_subdev *sd, u32 *lines)
 	return 0;
 }
 
+static const struct v4l2_ctrl_ops mt9v022_ctrl_ops = {
+	.g_volatile_ctrl = mt9v022_g_volatile_ctrl,
+	.s_ctrl = mt9v022_s_ctrl,
+};
+
 static struct v4l2_subdev_core_ops mt9v022_subdev_core_ops = {
-	.g_ctrl		= mt9v022_g_ctrl,
-	.s_ctrl		= mt9v022_s_ctrl,
 	.g_chip_ident	= mt9v022_g_chip_ident,
 #ifdef CONFIG_VIDEO_ADV_DEBUG
 	.g_register	= mt9v022_g_register,
@@ -900,10 +833,41 @@ static int mt9v022_probe(struct i2c_client *client,
 		return -ENOMEM;
 
 	v4l2_i2c_subdev_init(&mt9v022->subdev, client, &mt9v022_subdev_ops);
+	v4l2_ctrl_handler_init(&mt9v022->hdl, 6);
+	v4l2_ctrl_new_std(&mt9v022->hdl, &mt9v022_ctrl_ops,
+			V4L2_CID_VFLIP, 0, 1, 1, 0);
+	v4l2_ctrl_new_std(&mt9v022->hdl, &mt9v022_ctrl_ops,
+			V4L2_CID_HFLIP, 0, 1, 1, 0);
+	mt9v022->autogain = v4l2_ctrl_new_std(&mt9v022->hdl, &mt9v022_ctrl_ops,
+			V4L2_CID_AUTOGAIN, 0, 1, 1, 1);
+	mt9v022->gain = v4l2_ctrl_new_std(&mt9v022->hdl, &mt9v022_ctrl_ops,
+			V4L2_CID_GAIN, 0, 127, 1, 64);
+
+	/*
+	 * Simulated autoexposure. If enabled, we calculate shutter width
+	 * ourselves in the driver based on vertical blanking and frame width
+	 */
+	mt9v022->autoexposure = v4l2_ctrl_new_std_menu(&mt9v022->hdl,
+			&mt9v022_ctrl_ops, V4L2_CID_EXPOSURE_AUTO, 1, 0,
+			V4L2_EXPOSURE_AUTO);
+	mt9v022->exposure = v4l2_ctrl_new_std(&mt9v022->hdl, &mt9v022_ctrl_ops,
+			V4L2_CID_EXPOSURE, 1, 255, 1, 255);
+
+	mt9v022->subdev.ctrl_handler = &mt9v022->hdl;
+	if (mt9v022->hdl.error) {
+		int err = mt9v022->hdl.error;
+
+		kfree(mt9v022);
+		return err;
+	}
+	v4l2_ctrl_cluster(2, &mt9v022->autoexposure);
+	v4l2_ctrl_cluster(2, &mt9v022->autogain);
+	mt9v022->gain->is_volatile = true;
+	mt9v022->exposure->is_volatile = true;
 
 	mt9v022->chip_control = MT9V022_CHIP_CONTROL_DEFAULT;
 
-	icd->ops		= &mt9v022_ops;
+	icd->ops = &mt9v022_ops;
 	/*
 	 * MT9V022 _really_ corrupts the first read out line.
 	 * TODO: verify on i.MX31
@@ -917,6 +881,7 @@ static int mt9v022_probe(struct i2c_client *client,
 	ret = mt9v022_video_probe(icd, client);
 	if (ret) {
 		icd->ops = NULL;
+		v4l2_ctrl_handler_free(&mt9v022->hdl);
 		kfree(mt9v022);
 	}
 
@@ -928,8 +893,10 @@ static int mt9v022_remove(struct i2c_client *client)
 	struct mt9v022 *mt9v022 = to_mt9v022(client);
 	struct soc_camera_device *icd = client->dev.platform_data;
 
+	v4l2_device_unregister_subdev(&mt9v022->subdev);
 	icd->ops = NULL;
 	mt9v022_video_remove(icd);
+	v4l2_ctrl_handler_free(&mt9v022->hdl);
 	kfree(mt9v022);
 
 	return 0;
-- 
1.7.0.4

