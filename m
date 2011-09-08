Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.171]:64625 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932369Ab1IHIoL (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 8 Sep 2011 04:44:11 -0400
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>,
	Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: [PATCH 10/13 v3] mt9m001: convert to the control framework.
Date: Thu,  8 Sep 2011 10:44:03 +0200
Message-Id: <1315471446-17890-11-git-send-email-g.liakhovetski@gmx.de>
In-Reply-To: <1315471446-17890-1-git-send-email-g.liakhovetski@gmx.de>
References: <1315471446-17890-1-git-send-email-g.liakhovetski@gmx.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
[g.liakhovetski@gmx.de: simplified pointer arithmetic]
Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
---
 drivers/media/video/mt9m001.c |  218 +++++++++++++++--------------------------
 1 files changed, 77 insertions(+), 141 deletions(-)

diff --git a/drivers/media/video/mt9m001.c b/drivers/media/video/mt9m001.c
index 3555e85..42bb3c8 100644
--- a/drivers/media/video/mt9m001.c
+++ b/drivers/media/video/mt9m001.c
@@ -17,6 +17,7 @@
 #include <media/soc_mediabus.h>
 #include <media/v4l2-subdev.h>
 #include <media/v4l2-chip-ident.h>
+#include <media/v4l2-ctrls.h>
 
 /*
  * mt9m001 i2c address 0x5d
@@ -85,15 +86,19 @@ static const struct mt9m001_datafmt mt9m001_monochrome_fmts[] = {
 
 struct mt9m001 {
 	struct v4l2_subdev subdev;
+	struct v4l2_ctrl_handler hdl;
+	struct {
+		/* exposure/auto-exposure cluster */
+		struct v4l2_ctrl *autoexposure;
+		struct v4l2_ctrl *exposure;
+	};
 	struct v4l2_rect rect;	/* Sensor window */
 	const struct mt9m001_datafmt *fmt;
 	const struct mt9m001_datafmt *fmts;
 	int num_fmts;
 	int model;	/* V4L2_IDENT_MT9M001* codes from v4l2-chip-ident.h */
-	unsigned int gain;
-	unsigned int exposure;
+	unsigned int total_h;
 	unsigned short y_skip_top;	/* Lines to skip at the top */
-	unsigned char autoexposure;
 };
 
 static struct mt9m001 *to_mt9m001(const struct i2c_client *client)
@@ -171,10 +176,8 @@ static int mt9m001_s_crop(struct v4l2_subdev *sd, struct v4l2_crop *a)
 	struct i2c_client *client = v4l2_get_subdevdata(sd);
 	struct mt9m001 *mt9m001 = to_mt9m001(client);
 	struct v4l2_rect rect = a->c;
-	struct soc_camera_device *icd = client->dev.platform_data;
 	int ret;
 	const u16 hblank = 9, vblank = 25;
-	unsigned int total_h;
 
 	if (mt9m001->fmts == mt9m001_colour_fmts)
 		/*
@@ -193,7 +196,7 @@ static int mt9m001_s_crop(struct v4l2_subdev *sd, struct v4l2_crop *a)
 	soc_camera_limit_side(&rect.top, &rect.height,
 		     MT9M001_ROW_SKIP, MT9M001_MIN_HEIGHT, MT9M001_MAX_HEIGHT);
 
-	total_h = rect.height + mt9m001->y_skip_top + vblank;
+	mt9m001->total_h = rect.height + mt9m001->y_skip_top + vblank;
 
 	/* Blanking and start values - default... */
 	ret = reg_write(client, MT9M001_HORIZONTAL_BLANKING, hblank);
@@ -213,17 +216,8 @@ static int mt9m001_s_crop(struct v4l2_subdev *sd, struct v4l2_crop *a)
 	if (!ret)
 		ret = reg_write(client, MT9M001_WINDOW_HEIGHT,
 				rect.height + mt9m001->y_skip_top - 1);
-	if (!ret && mt9m001->autoexposure) {
-		ret = reg_write(client, MT9M001_SHUTTER_WIDTH, total_h);
-		if (!ret) {
-			const struct v4l2_queryctrl *qctrl =
-				soc_camera_find_qctrl(icd->ops,
-						      V4L2_CID_EXPOSURE);
-			mt9m001->exposure = (524 + (total_h - 1) *
-				 (qctrl->maximum - qctrl->minimum)) /
-				1048 + qctrl->minimum;
-		}
-	}
+	if (!ret && v4l2_ctrl_g_ctrl(mt9m001->autoexposure) == V4L2_EXPOSURE_AUTO)
+		ret = reg_write(client, MT9M001_SHUTTER_WIDTH, mt9m001->total_h);
 
 	if (!ret)
 		mt9m001->rect = rect;
@@ -383,105 +377,48 @@ static int mt9m001_s_register(struct v4l2_subdev *sd,
 }
 #endif
 
-static const struct v4l2_queryctrl mt9m001_controls[] = {
-	{
-		.id		= V4L2_CID_VFLIP,
-		.type		= V4L2_CTRL_TYPE_BOOLEAN,
-		.name		= "Flip Vertically",
-		.minimum	= 0,
-		.maximum	= 1,
-		.step		= 1,
-		.default_value	= 0,
-	}, {
-		.id		= V4L2_CID_GAIN,
-		.type		= V4L2_CTRL_TYPE_INTEGER,
-		.name		= "Gain",
-		.minimum	= 0,
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
-static struct soc_camera_ops mt9m001_ops = {
-	.controls		= mt9m001_controls,
-	.num_controls		= ARRAY_SIZE(mt9m001_controls),
-};
-
-static int mt9m001_g_ctrl(struct v4l2_subdev *sd, struct v4l2_control *ctrl)
+static int mt9m001_g_volatile_ctrl(struct v4l2_ctrl *ctrl)
 {
-	struct i2c_client *client = v4l2_get_subdevdata(sd);
-	struct mt9m001 *mt9m001 = to_mt9m001(client);
-	int data;
+	struct mt9m001 *mt9m001 = container_of(ctrl->handler,
+					       struct mt9m001, hdl);
+	s32 min, max;
 
 	switch (ctrl->id) {
-	case V4L2_CID_VFLIP:
-		data = reg_read(client, MT9M001_READ_OPTIONS2);
-		if (data < 0)
-			return -EIO;
-		ctrl->value = !!(data & 0x8000);
-		break;
 	case V4L2_CID_EXPOSURE_AUTO:
-		ctrl->value = mt9m001->autoexposure;
-		break;
-	case V4L2_CID_GAIN:
-		ctrl->value = mt9m001->gain;
-		break;
-	case V4L2_CID_EXPOSURE:
-		ctrl->value = mt9m001->exposure;
+		min = mt9m001->exposure->minimum;
+		max = mt9m001->exposure->maximum;
+		mt9m001->exposure->val =
+			(524 + (mt9m001->total_h - 1) * (max - min)) / 1048 + min;
 		break;
 	}
 	return 0;
 }
 
-static int mt9m001_s_ctrl(struct v4l2_subdev *sd, struct v4l2_control *ctrl)
+static int mt9m001_s_ctrl(struct v4l2_ctrl *ctrl)
 {
+	struct mt9m001 *mt9m001 = container_of(ctrl->handler,
+					       struct mt9m001, hdl);
+	struct v4l2_subdev *sd = &mt9m001->subdev;
 	struct i2c_client *client = v4l2_get_subdevdata(sd);
-	struct mt9m001 *mt9m001 = to_mt9m001(client);
-	struct soc_camera_device *icd = client->dev.platform_data;
-	const struct v4l2_queryctrl *qctrl;
+	struct v4l2_ctrl *exp = mt9m001->exposure;
 	int data;
 
-	qctrl = soc_camera_find_qctrl(&mt9m001_ops, ctrl->id);
-
-	if (!qctrl)
-		return -EINVAL;
-
 	switch (ctrl->id) {
 	case V4L2_CID_VFLIP:
-		if (ctrl->value)
+		if (ctrl->val)
 			data = reg_set(client, MT9M001_READ_OPTIONS2, 0x8000);
 		else
 			data = reg_clear(client, MT9M001_READ_OPTIONS2, 0x8000);
 		if (data < 0)
 			return -EIO;
-		break;
+		return 0;
+
 	case V4L2_CID_GAIN:
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
 			data = reg_write(client, MT9M001_GLOBAL_GAIN, data);
@@ -490,8 +427,8 @@ static int mt9m001_s_ctrl(struct v4l2_subdev *sd, struct v4l2_control *ctrl)
 		} else {
 			/* Pack it into 1.125..15 variable step, register values 9..67 */
 			/* We assume qctrl->maximum - qctrl->default_value - 1 > 0 */
-			unsigned long range = qctrl->maximum - qctrl->default_value - 1;
-			unsigned long gain = ((ctrl->value - qctrl->default_value - 1) *
+			unsigned long range = ctrl->maximum - ctrl->default_value - 1;
+			unsigned long gain = ((ctrl->val - ctrl->default_value - 1) *
 					       111 + range / 2) / range + 9;
 
 			if (gain <= 32)
@@ -507,47 +444,30 @@ static int mt9m001_s_ctrl(struct v4l2_subdev *sd, struct v4l2_control *ctrl)
 			if (data < 0)
 				return -EIO;
 		}
+		return 0;
 
-		/* Success */
-		mt9m001->gain = ctrl->value;
-		break;
-	case V4L2_CID_EXPOSURE:
-		/* mt9m001 has maximum == default */
-		if (ctrl->value > qctrl->maximum || ctrl->value < qctrl->minimum)
-			return -EINVAL;
-		else {
-			unsigned long range = qctrl->maximum - qctrl->minimum;
-			unsigned long shutter = ((ctrl->value - qctrl->minimum) * 1048 +
+	case V4L2_CID_EXPOSURE_AUTO:
+		if (ctrl->val == V4L2_EXPOSURE_MANUAL) {
+			unsigned long range = exp->maximum - exp->minimum;
+			unsigned long shutter = ((exp->val - exp->minimum) * 1048 +
 						 range / 2) / range + 1;
 
 			dev_dbg(&client->dev,
 				"Setting shutter width from %d to %lu\n",
-				reg_read(client, MT9M001_SHUTTER_WIDTH),
-				shutter);
+				reg_read(client, MT9M001_SHUTTER_WIDTH), shutter);
 			if (reg_write(client, MT9M001_SHUTTER_WIDTH, shutter) < 0)
 				return -EIO;
-			mt9m001->exposure = ctrl->value;
-			mt9m001->autoexposure = 0;
-		}
-		break;
-	case V4L2_CID_EXPOSURE_AUTO:
-		if (ctrl->value) {
+		} else {
 			const u16 vblank = 25;
-			unsigned int total_h = mt9m001->rect.height +
+
+			mt9m001->total_h = mt9m001->rect.height +
 				mt9m001->y_skip_top + vblank;
-			if (reg_write(client, MT9M001_SHUTTER_WIDTH,
-				      total_h) < 0)
+			if (reg_write(client, MT9M001_SHUTTER_WIDTH, mt9m001->total_h) < 0)
 				return -EIO;
-			qctrl = soc_camera_find_qctrl(icd->ops, V4L2_CID_EXPOSURE);
-			mt9m001->exposure = (524 + (total_h - 1) *
-				 (qctrl->maximum - qctrl->minimum)) /
-				1048 + qctrl->minimum;
-			mt9m001->autoexposure = 1;
-		} else
-			mt9m001->autoexposure = 0;
-		break;
+		}
+		return 0;
 	}
-	return 0;
+	return -EINVAL;
 }
 
 /*
@@ -621,10 +541,7 @@ static int mt9m001_video_probe(struct soc_camera_device *icd,
 		dev_err(&client->dev, "Failed to initialise the camera\n");
 
 	/* mt9m001_init() has reset the chip, returning registers to defaults */
-	mt9m001->gain = 64;
-	mt9m001->exposure = 255;
-
-	return ret;
+	return v4l2_ctrl_handler_setup(&mt9m001->hdl);
 }
 
 static void mt9m001_video_remove(struct soc_camera_device *icd)
@@ -647,9 +564,12 @@ static int mt9m001_g_skip_top_lines(struct v4l2_subdev *sd, u32 *lines)
 	return 0;
 }
 
+static const struct v4l2_ctrl_ops mt9m001_ctrl_ops = {
+	.g_volatile_ctrl = mt9m001_g_volatile_ctrl,
+	.s_ctrl = mt9m001_s_ctrl,
+};
+
 static struct v4l2_subdev_core_ops mt9m001_subdev_core_ops = {
-	.g_ctrl		= mt9m001_g_ctrl,
-	.s_ctrl		= mt9m001_s_ctrl,
 	.g_chip_ident	= mt9m001_g_chip_ident,
 #ifdef CONFIG_VIDEO_ADV_DEBUG
 	.g_register	= mt9m001_g_register,
@@ -765,25 +685,40 @@ static int mt9m001_probe(struct i2c_client *client,
 		return -ENOMEM;
 
 	v4l2_i2c_subdev_init(&mt9m001->subdev, client, &mt9m001_subdev_ops);
+	v4l2_ctrl_handler_init(&mt9m001->hdl, 4);
+	v4l2_ctrl_new_std(&mt9m001->hdl, &mt9m001_ctrl_ops,
+			V4L2_CID_VFLIP, 0, 1, 1, 0);
+	v4l2_ctrl_new_std(&mt9m001->hdl, &mt9m001_ctrl_ops,
+			V4L2_CID_GAIN, 0, 127, 1, 64);
+	mt9m001->exposure = v4l2_ctrl_new_std(&mt9m001->hdl, &mt9m001_ctrl_ops,
+			V4L2_CID_EXPOSURE, 1, 255, 1, 255);
+	/*
+	 * Simulated autoexposure. If enabled, we calculate shutter width
+	 * ourselves in the driver based on vertical blanking and frame width
+	 */
+	mt9m001->autoexposure = v4l2_ctrl_new_std_menu(&mt9m001->hdl,
+			&mt9m001_ctrl_ops, V4L2_CID_EXPOSURE_AUTO, 1, 0,
+			V4L2_EXPOSURE_AUTO);
+	mt9m001->subdev.ctrl_handler = &mt9m001->hdl;
+	if (mt9m001->hdl.error) {
+		int err = mt9m001->hdl.error;
 
-	/* Second stage probe - when a capture adapter is there */
-	icd->ops		= &mt9m001_ops;
+		kfree(mt9m001);
+		return err;
+	}
+	v4l2_ctrl_auto_cluster(2, &mt9m001->autoexposure,
+					V4L2_EXPOSURE_MANUAL, true);
 
+	/* Second stage probe - when a capture adapter is there */
 	mt9m001->y_skip_top	= 0;
 	mt9m001->rect.left	= MT9M001_COLUMN_SKIP;
 	mt9m001->rect.top	= MT9M001_ROW_SKIP;
 	mt9m001->rect.width	= MT9M001_MAX_WIDTH;
 	mt9m001->rect.height	= MT9M001_MAX_HEIGHT;
 
-	/*
-	 * Simulated autoexposure. If enabled, we calculate shutter width
-	 * ourselves in the driver based on vertical blanking and frame width
-	 */
-	mt9m001->autoexposure = 1;
-
 	ret = mt9m001_video_probe(icd, client);
 	if (ret) {
-		icd->ops = NULL;
+		v4l2_ctrl_handler_free(&mt9m001->hdl);
 		kfree(mt9m001);
 	}
 
@@ -795,7 +730,8 @@ static int mt9m001_remove(struct i2c_client *client)
 	struct mt9m001 *mt9m001 = to_mt9m001(client);
 	struct soc_camera_device *icd = client->dev.platform_data;
 
-	icd->ops = NULL;
+	v4l2_device_unregister_subdev(&mt9m001->subdev);
+	v4l2_ctrl_handler_free(&mt9m001->hdl);
 	mt9m001_video_remove(icd);
 	kfree(mt9m001);
 
-- 
1.7.2.5

