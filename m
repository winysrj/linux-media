Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.171]:56322 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932425Ab1IHIoS (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 8 Sep 2011 04:44:18 -0400
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>,
	Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: [PATCH 12/13 v3] mt9t031: convert to the control framework.
Date: Thu,  8 Sep 2011 10:44:05 +0200
Message-Id: <1315471446-17890-13-git-send-email-g.liakhovetski@gmx.de>
In-Reply-To: <1315471446-17890-1-git-send-email-g.liakhovetski@gmx.de>
References: <1315471446-17890-1-git-send-email-g.liakhovetski@gmx.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
[g.liakhovetski@gmx.de: simplified pointer arithmetic]
Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
---
 drivers/media/video/mt9t031.c |  252 ++++++++++++++---------------------------
 1 files changed, 86 insertions(+), 166 deletions(-)

diff --git a/drivers/media/video/mt9t031.c b/drivers/media/video/mt9t031.c
index 25fb833..7ce3799 100644
--- a/drivers/media/video/mt9t031.c
+++ b/drivers/media/video/mt9t031.c
@@ -19,6 +19,7 @@
 #include <media/soc_mediabus.h>
 #include <media/v4l2-chip-ident.h>
 #include <media/v4l2-subdev.h>
+#include <media/v4l2-ctrls.h>
 
 /*
  * mt9t031 i2c address 0x5d
@@ -60,14 +61,18 @@
 
 struct mt9t031 {
 	struct v4l2_subdev subdev;
+	struct v4l2_ctrl_handler hdl;
+	struct {
+		/* exposure/auto-exposure cluster */
+		struct v4l2_ctrl *autoexposure;
+		struct v4l2_ctrl *exposure;
+	};
 	struct v4l2_rect rect;	/* Sensor window */
 	int model;	/* V4L2_IDENT_MT9T031* codes from v4l2-chip-ident.h */
 	u16 xskip;
 	u16 yskip;
-	unsigned int gain;
+	unsigned int total_h;
 	unsigned short y_skip_top;	/* Lines to skip at the top */
-	unsigned int exposure;
-	unsigned char autoexposure;
 };
 
 static struct mt9t031 *to_mt9t031(const struct i2c_client *client)
@@ -175,69 +180,6 @@ static int mt9t031_s_stream(struct v4l2_subdev *sd, int enable)
 	return 0;
 }
 
-enum {
-	MT9T031_CTRL_VFLIP,
-	MT9T031_CTRL_HFLIP,
-	MT9T031_CTRL_GAIN,
-	MT9T031_CTRL_EXPOSURE,
-	MT9T031_CTRL_EXPOSURE_AUTO,
-};
-
-static const struct v4l2_queryctrl mt9t031_controls[] = {
-	[MT9T031_CTRL_VFLIP] = {
-		.id		= V4L2_CID_VFLIP,
-		.type		= V4L2_CTRL_TYPE_BOOLEAN,
-		.name		= "Flip Vertically",
-		.minimum	= 0,
-		.maximum	= 1,
-		.step		= 1,
-		.default_value	= 0,
-	},
-	[MT9T031_CTRL_HFLIP] = {
-		.id		= V4L2_CID_HFLIP,
-		.type		= V4L2_CTRL_TYPE_BOOLEAN,
-		.name		= "Flip Horizontally",
-		.minimum	= 0,
-		.maximum	= 1,
-		.step		= 1,
-		.default_value	= 0,
-	},
-	[MT9T031_CTRL_GAIN] = {
-		.id		= V4L2_CID_GAIN,
-		.type		= V4L2_CTRL_TYPE_INTEGER,
-		.name		= "Gain",
-		.minimum	= 0,
-		.maximum	= 127,
-		.step		= 1,
-		.default_value	= 64,
-		.flags		= V4L2_CTRL_FLAG_SLIDER,
-	},
-	[MT9T031_CTRL_EXPOSURE] = {
-		.id		= V4L2_CID_EXPOSURE,
-		.type		= V4L2_CTRL_TYPE_INTEGER,
-		.name		= "Exposure",
-		.minimum	= 1,
-		.maximum	= 255,
-		.step		= 1,
-		.default_value	= 255,
-		.flags		= V4L2_CTRL_FLAG_SLIDER,
-	},
-	[MT9T031_CTRL_EXPOSURE_AUTO] = {
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
-static struct soc_camera_ops mt9t031_ops = {
-	.controls		= mt9t031_controls,
-	.num_controls		= ARRAY_SIZE(mt9t031_controls),
-};
-
 /* target must be _even_ */
 static u16 mt9t031_skip(s32 *source, s32 target, s32 max)
 {
@@ -334,17 +276,10 @@ static int mt9t031_set_params(struct i2c_client *client,
 	if (ret >= 0)
 		ret = reg_write(client, MT9T031_WINDOW_HEIGHT,
 				rect->height + mt9t031->y_skip_top - 1);
-	if (ret >= 0 && mt9t031->autoexposure) {
-		unsigned int total_h = rect->height + mt9t031->y_skip_top + vblank;
-		ret = set_shutter(client, total_h);
-		if (ret >= 0) {
-			const u32 shutter_max = MT9T031_MAX_HEIGHT + vblank;
-			const struct v4l2_queryctrl *qctrl =
-				&mt9t031_controls[MT9T031_CTRL_EXPOSURE];
-			mt9t031->exposure = (shutter_max / 2 + (total_h - 1) *
-				 (qctrl->maximum - qctrl->minimum)) /
-				shutter_max + qctrl->minimum;
-		}
+	if (ret >= 0 && v4l2_ctrl_g_ctrl(mt9t031->autoexposure) == V4L2_EXPOSURE_AUTO) {
+		mt9t031->total_h = rect->height + mt9t031->y_skip_top + vblank;
+
+		ret = set_shutter(client, mt9t031->total_h);
 	}
 
 	/* Re-enable register update, commit all changes */
@@ -513,71 +448,57 @@ static int mt9t031_s_register(struct v4l2_subdev *sd,
 }
 #endif
 
-static int mt9t031_g_ctrl(struct v4l2_subdev *sd, struct v4l2_control *ctrl)
+static int mt9t031_g_volatile_ctrl(struct v4l2_ctrl *ctrl)
 {
-	struct i2c_client *client = v4l2_get_subdevdata(sd);
-	struct mt9t031 *mt9t031 = to_mt9t031(client);
-	int data;
+	struct mt9t031 *mt9t031 = container_of(ctrl->handler,
+					       struct mt9t031, hdl);
+	const u32 shutter_max = MT9T031_MAX_HEIGHT + MT9T031_VERTICAL_BLANK;
+	s32 min, max;
 
 	switch (ctrl->id) {
-	case V4L2_CID_VFLIP:
-		data = reg_read(client, MT9T031_READ_MODE_2);
-		if (data < 0)
-			return -EIO;
-		ctrl->value = !!(data & 0x8000);
-		break;
-	case V4L2_CID_HFLIP:
-		data = reg_read(client, MT9T031_READ_MODE_2);
-		if (data < 0)
-			return -EIO;
-		ctrl->value = !!(data & 0x4000);
-		break;
 	case V4L2_CID_EXPOSURE_AUTO:
-		ctrl->value = mt9t031->autoexposure;
-		break;
-	case V4L2_CID_GAIN:
-		ctrl->value = mt9t031->gain;
-		break;
-	case V4L2_CID_EXPOSURE:
-		ctrl->value = mt9t031->exposure;
+		min = mt9t031->exposure->minimum;
+		max = mt9t031->exposure->maximum;
+		mt9t031->exposure->val =
+			(shutter_max / 2 + (mt9t031->total_h - 1) * (max - min))
+				/ shutter_max + min;
 		break;
 	}
 	return 0;
 }
 
-static int mt9t031_s_ctrl(struct v4l2_subdev *sd, struct v4l2_control *ctrl)
+static int mt9t031_s_ctrl(struct v4l2_ctrl *ctrl)
 {
+	struct mt9t031 *mt9t031 = container_of(ctrl->handler,
+					       struct mt9t031, hdl);
+	struct v4l2_subdev *sd = &mt9t031->subdev;
 	struct i2c_client *client = v4l2_get_subdevdata(sd);
-	struct mt9t031 *mt9t031 = to_mt9t031(client);
-	const struct v4l2_queryctrl *qctrl;
+	struct v4l2_ctrl *exp = mt9t031->exposure;
 	int data;
 
 	switch (ctrl->id) {
 	case V4L2_CID_VFLIP:
-		if (ctrl->value)
+		if (ctrl->val)
 			data = reg_set(client, MT9T031_READ_MODE_2, 0x8000);
 		else
 			data = reg_clear(client, MT9T031_READ_MODE_2, 0x8000);
 		if (data < 0)
 			return -EIO;
-		break;
+		return 0;
 	case V4L2_CID_HFLIP:
-		if (ctrl->value)
+		if (ctrl->val)
 			data = reg_set(client, MT9T031_READ_MODE_2, 0x4000);
 		else
 			data = reg_clear(client, MT9T031_READ_MODE_2, 0x4000);
 		if (data < 0)
 			return -EIO;
-		break;
+		return 0;
 	case V4L2_CID_GAIN:
-		qctrl = &mt9t031_controls[MT9T031_CTRL_GAIN];
-		if (ctrl->value > qctrl->maximum || ctrl->value < qctrl->minimum)
-			return -EINVAL;
 		/* See Datasheet Table 7, Gain settings. */
-		if (ctrl->value <= qctrl->default_value) {
+		if (ctrl->val <= ctrl->default_value) {
 			/* Pack it into 0..1 step 0.125, register values 0..8 */
-			unsigned long range = qctrl->default_value - qctrl->minimum;
-			data = ((ctrl->value - qctrl->minimum) * 8 + range / 2) / range;
+			unsigned long range = ctrl->default_value - ctrl->minimum;
+			data = ((ctrl->val - ctrl->minimum) * 8 + range / 2) / range;
 
 			dev_dbg(&client->dev, "Setting gain %d\n", data);
 			data = reg_write(client, MT9T031_GLOBAL_GAIN, data);
@@ -586,9 +507,9 @@ static int mt9t031_s_ctrl(struct v4l2_subdev *sd, struct v4l2_control *ctrl)
 		} else {
 			/* Pack it into 1.125..128 variable step, register values 9..0x7860 */
 			/* We assume qctrl->maximum - qctrl->default_value - 1 > 0 */
-			unsigned long range = qctrl->maximum - qctrl->default_value - 1;
+			unsigned long range = ctrl->maximum - ctrl->default_value - 1;
 			/* calculated gain: map 65..127 to 9..1024 step 0.125 */
-			unsigned long gain = ((ctrl->value - qctrl->default_value - 1) *
+			unsigned long gain = ((ctrl->val - ctrl->default_value - 1) *
 					       1015 + range / 2) / range + 9;
 
 			if (gain <= 32)		/* calculated gain 9..32 -> 9..32 */
@@ -605,19 +526,13 @@ static int mt9t031_s_ctrl(struct v4l2_subdev *sd, struct v4l2_control *ctrl)
 			if (data < 0)
 				return -EIO;
 		}
+		return 0;
 
-		/* Success */
-		mt9t031->gain = ctrl->value;
-		break;
-	case V4L2_CID_EXPOSURE:
-		qctrl = &mt9t031_controls[MT9T031_CTRL_EXPOSURE];
-		/* mt9t031 has maximum == default */
-		if (ctrl->value > qctrl->maximum || ctrl->value < qctrl->minimum)
-			return -EINVAL;
-		else {
-			const unsigned long range = qctrl->maximum - qctrl->minimum;
-			const u32 shutter = ((ctrl->value - qctrl->minimum) * 1048 +
-					     range / 2) / range + 1;
+	case V4L2_CID_EXPOSURE_AUTO:
+		if (ctrl->val == V4L2_EXPOSURE_MANUAL) {
+			unsigned int range = exp->maximum - exp->minimum;
+			unsigned int shutter = ((exp->val - exp->minimum) * 1048 +
+						 range / 2) / range + 1;
 			u32 old;
 
 			get_shutter(client, &old);
@@ -625,27 +540,15 @@ static int mt9t031_s_ctrl(struct v4l2_subdev *sd, struct v4l2_control *ctrl)
 				old, shutter);
 			if (set_shutter(client, shutter) < 0)
 				return -EIO;
-			mt9t031->exposure = ctrl->value;
-			mt9t031->autoexposure = 0;
-		}
-		break;
-	case V4L2_CID_EXPOSURE_AUTO:
-		if (ctrl->value) {
+		} else {
 			const u16 vblank = MT9T031_VERTICAL_BLANK;
-			const u32 shutter_max = MT9T031_MAX_HEIGHT + vblank;
-			unsigned int total_h = mt9t031->rect.height +
+			mt9t031->total_h = mt9t031->rect.height +
 				mt9t031->y_skip_top + vblank;
 
-			if (set_shutter(client, total_h) < 0)
+			if (set_shutter(client, mt9t031->total_h) < 0)
 				return -EIO;
-			qctrl = &mt9t031_controls[MT9T031_CTRL_EXPOSURE];
-			mt9t031->exposure = (shutter_max / 2 + (total_h - 1) *
-				 (qctrl->maximum - qctrl->minimum)) /
-				shutter_max + qctrl->minimum;
-			mt9t031->autoexposure = 1;
-		} else
-			mt9t031->autoexposure = 0;
-		break;
+		}
+		return 0;
 	default:
 		return -EINVAL;
 	}
@@ -735,15 +638,12 @@ static int mt9t031_video_probe(struct i2c_client *client)
 	dev_info(&client->dev, "Detected a MT9T031 chip ID %x\n", data);
 
 	ret = mt9t031_idle(client);
-	if (ret < 0)
+	if (ret < 0) {
 		dev_err(&client->dev, "Failed to initialise the camera\n");
-	else
+	} else {
 		vdev->dev.type = &mt9t031_dev_type;
-
-	/* mt9t031_idle() has reset the chip to default. */
-	mt9t031->exposure = 255;
-	mt9t031->gain = 64;
-
+		v4l2_ctrl_handler_setup(&mt9t031->hdl);
+	}
 	return ret;
 }
 
@@ -757,9 +657,12 @@ static int mt9t031_g_skip_top_lines(struct v4l2_subdev *sd, u32 *lines)
 	return 0;
 }
 
+static const struct v4l2_ctrl_ops mt9t031_ctrl_ops = {
+	.g_volatile_ctrl = mt9t031_g_volatile_ctrl,
+	.s_ctrl = mt9t031_s_ctrl,
+};
+
 static struct v4l2_subdev_core_ops mt9t031_subdev_core_ops = {
-	.g_ctrl		= mt9t031_g_ctrl,
-	.s_ctrl		= mt9t031_s_ctrl,
 	.g_chip_ident	= mt9t031_g_chip_ident,
 #ifdef CONFIG_VIDEO_ADV_DEBUG
 	.g_register	= mt9t031_g_register,
@@ -844,8 +747,6 @@ static int mt9t031_probe(struct i2c_client *client,
 			dev_err(&client->dev, "MT9T031 driver needs platform data\n");
 			return -EINVAL;
 		}
-
-		icd->ops = &mt9t031_ops;
 	}
 
 	if (!i2c_check_functionality(adapter, I2C_FUNC_SMBUS_WORD_DATA)) {
@@ -859,6 +760,33 @@ static int mt9t031_probe(struct i2c_client *client,
 		return -ENOMEM;
 
 	v4l2_i2c_subdev_init(&mt9t031->subdev, client, &mt9t031_subdev_ops);
+	v4l2_ctrl_handler_init(&mt9t031->hdl, 5);
+	v4l2_ctrl_new_std(&mt9t031->hdl, &mt9t031_ctrl_ops,
+			V4L2_CID_VFLIP, 0, 1, 1, 0);
+	v4l2_ctrl_new_std(&mt9t031->hdl, &mt9t031_ctrl_ops,
+			V4L2_CID_HFLIP, 0, 1, 1, 0);
+	v4l2_ctrl_new_std(&mt9t031->hdl, &mt9t031_ctrl_ops,
+			V4L2_CID_GAIN, 0, 127, 1, 64);
+
+	/*
+	 * Simulated autoexposure. If enabled, we calculate shutter width
+	 * ourselves in the driver based on vertical blanking and frame width
+	 */
+	mt9t031->autoexposure = v4l2_ctrl_new_std_menu(&mt9t031->hdl,
+			&mt9t031_ctrl_ops, V4L2_CID_EXPOSURE_AUTO, 1, 0,
+			V4L2_EXPOSURE_AUTO);
+	mt9t031->exposure = v4l2_ctrl_new_std(&mt9t031->hdl, &mt9t031_ctrl_ops,
+			V4L2_CID_EXPOSURE, 1, 255, 1, 255);
+
+	mt9t031->subdev.ctrl_handler = &mt9t031->hdl;
+	if (mt9t031->hdl.error) {
+		int err = mt9t031->hdl.error;
+
+		kfree(mt9t031);
+		return err;
+	}
+	v4l2_ctrl_auto_cluster(2, &mt9t031->autoexposure,
+				V4L2_EXPOSURE_MANUAL, true);
 
 	mt9t031->y_skip_top	= 0;
 	mt9t031->rect.left	= MT9T031_COLUMN_SKIP;
@@ -866,12 +794,6 @@ static int mt9t031_probe(struct i2c_client *client,
 	mt9t031->rect.width	= MT9T031_MAX_WIDTH;
 	mt9t031->rect.height	= MT9T031_MAX_HEIGHT;
 
-	/*
-	 * Simulated autoexposure. If enabled, we calculate shutter width
-	 * ourselves in the driver based on vertical blanking and frame width
-	 */
-	mt9t031->autoexposure = 1;
-
 	mt9t031->xskip = 1;
 	mt9t031->yskip = 1;
 
@@ -882,8 +804,7 @@ static int mt9t031_probe(struct i2c_client *client,
 	mt9t031_disable(client);
 
 	if (ret) {
-		if (icd)
-			icd->ops = NULL;
+		v4l2_ctrl_handler_free(&mt9t031->hdl);
 		kfree(mt9t031);
 	}
 
@@ -893,10 +814,9 @@ static int mt9t031_probe(struct i2c_client *client,
 static int mt9t031_remove(struct i2c_client *client)
 {
 	struct mt9t031 *mt9t031 = to_mt9t031(client);
-	struct soc_camera_device *icd = client->dev.platform_data;
 
-	if (icd)
-		icd->ops = NULL;
+	v4l2_device_unregister_subdev(&mt9t031->subdev);
+	v4l2_ctrl_handler_free(&mt9t031->hdl);
 	kfree(mt9t031);
 
 	return 0;
-- 
1.7.2.5

