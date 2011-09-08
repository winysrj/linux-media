Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.17.9]:62214 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932426Ab1IHIoS (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 8 Sep 2011 04:44:18 -0400
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>,
	Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: [PATCH 11/13 v3] mt9m111: convert to the control framework.
Date: Thu,  8 Sep 2011 10:44:04 +0200
Message-Id: <1315471446-17890-12-git-send-email-g.liakhovetski@gmx.de>
In-Reply-To: <1315471446-17890-1-git-send-email-g.liakhovetski@gmx.de>
References: <1315471446-17890-1-git-send-email-g.liakhovetski@gmx.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
[g.liakhovetski@gmx.de: simplified pointer arithmetic]
Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
---
 drivers/media/video/mt9m111.c |  203 ++++++++++-------------------------------
 1 files changed, 48 insertions(+), 155 deletions(-)

diff --git a/drivers/media/video/mt9m111.c b/drivers/media/video/mt9m111.c
index d7a0773..41df6c3 100644
--- a/drivers/media/video/mt9m111.c
+++ b/drivers/media/video/mt9m111.c
@@ -17,6 +17,7 @@
 #include <media/soc_camera.h>
 #include <media/soc_mediabus.h>
 #include <media/v4l2-common.h>
+#include <media/v4l2-ctrls.h>
 #include <media/v4l2-chip-ident.h>
 
 /*
@@ -178,6 +179,8 @@ enum mt9m111_context {
 
 struct mt9m111 {
 	struct v4l2_subdev subdev;
+	struct v4l2_ctrl_handler hdl;
+	struct v4l2_ctrl *gain;
 	int model;	/* V4L2_IDENT_MT9M111 or V4L2_IDENT_MT9M112 code
 			 * from v4l2-chip-ident.h */
 	enum mt9m111_context context;
@@ -185,13 +188,8 @@ struct mt9m111 {
 	struct mutex power_lock; /* lock to protect power_count */
 	int power_count;
 	const struct mt9m111_datafmt *fmt;
-	unsigned int gain;
-	unsigned char autoexposure;
 	unsigned char datawidth;
 	unsigned int powered:1;
-	unsigned int hflip:1;
-	unsigned int vflip:1;
-	unsigned int autowhitebalance:1;
 };
 
 static struct mt9m111 *to_mt9m111(const struct i2c_client *client)
@@ -645,48 +643,6 @@ static int mt9m111_s_register(struct v4l2_subdev *sd,
 }
 #endif
 
-static const struct v4l2_queryctrl mt9m111_controls[] = {
-	{
-		.id		= V4L2_CID_VFLIP,
-		.type		= V4L2_CTRL_TYPE_BOOLEAN,
-		.name		= "Flip Verticaly",
-		.minimum	= 0,
-		.maximum	= 1,
-		.step		= 1,
-		.default_value	= 0,
-	}, {
-		.id		= V4L2_CID_HFLIP,
-		.type		= V4L2_CTRL_TYPE_BOOLEAN,
-		.name		= "Flip Horizontaly",
-		.minimum	= 0,
-		.maximum	= 1,
-		.step		= 1,
-		.default_value	= 0,
-	}, {	/* gain = 1/32*val (=>gain=1 if val==32) */
-		.id		= V4L2_CID_GAIN,
-		.type		= V4L2_CTRL_TYPE_INTEGER,
-		.name		= "Gain",
-		.minimum	= 0,
-		.maximum	= 63 * 2 * 2,
-		.step		= 1,
-		.default_value	= 32,
-		.flags		= V4L2_CTRL_FLAG_SLIDER,
-	}, {
-		.id		= V4L2_CID_EXPOSURE_AUTO,
-		.type		= V4L2_CTRL_TYPE_BOOLEAN,
-		.name		= "Auto Exposure",
-		.minimum	= 0,
-		.maximum	= 1,
-		.step		= 1,
-		.default_value	= 1,
-	}
-};
-
-static struct soc_camera_ops mt9m111_ops = {
-	.controls		= mt9m111_controls,
-	.num_controls		= ARRAY_SIZE(mt9m111_controls),
-};
-
 static int mt9m111_set_flip(struct mt9m111 *mt9m111, int flip, int mask)
 {
 	struct i2c_client *client = v4l2_get_subdevdata(&mt9m111->subdev);
@@ -727,7 +683,6 @@ static int mt9m111_set_global_gain(struct mt9m111 *mt9m111, int gain)
 	if (gain > 63 * 2 * 2)
 		return -EINVAL;
 
-	mt9m111->gain = gain;
 	if ((gain >= 64 * 2) && (gain < 63 * 2 * 2))
 		val = (1 << 10) | (1 << 9) | (gain / 4);
 	else if ((gain >= 64) && (gain < 64 * 2))
@@ -741,118 +696,47 @@ static int mt9m111_set_global_gain(struct mt9m111 *mt9m111, int gain)
 static int mt9m111_set_autoexposure(struct mt9m111 *mt9m111, int on)
 {
 	struct i2c_client *client = v4l2_get_subdevdata(&mt9m111->subdev);
-	int ret;
 
 	if (on)
-		ret = reg_set(OPER_MODE_CTRL, MT9M111_OPMODE_AUTOEXPO_EN);
-	else
-		ret = reg_clear(OPER_MODE_CTRL, MT9M111_OPMODE_AUTOEXPO_EN);
-
-	if (!ret)
-		mt9m111->autoexposure = on;
-
-	return ret;
+		return reg_set(OPER_MODE_CTRL, MT9M111_OPMODE_AUTOEXPO_EN);
+	return reg_clear(OPER_MODE_CTRL, MT9M111_OPMODE_AUTOEXPO_EN);
 }
 
 static int mt9m111_set_autowhitebalance(struct mt9m111 *mt9m111, int on)
 {
 	struct i2c_client *client = v4l2_get_subdevdata(&mt9m111->subdev);
-	int ret;
 
 	if (on)
-		ret = reg_set(OPER_MODE_CTRL, MT9M111_OPMODE_AUTOWHITEBAL_EN);
-	else
-		ret = reg_clear(OPER_MODE_CTRL, MT9M111_OPMODE_AUTOWHITEBAL_EN);
-
-	if (!ret)
-		mt9m111->autowhitebalance = on;
-
-	return ret;
+		return reg_set(OPER_MODE_CTRL, MT9M111_OPMODE_AUTOWHITEBAL_EN);
+	return reg_clear(OPER_MODE_CTRL, MT9M111_OPMODE_AUTOWHITEBAL_EN);
 }
 
-static int mt9m111_g_ctrl(struct v4l2_subdev *sd, struct v4l2_control *ctrl)
+static int mt9m111_s_ctrl(struct v4l2_ctrl *ctrl)
 {
-	struct i2c_client *client = v4l2_get_subdevdata(sd);
-	struct mt9m111 *mt9m111 = container_of(sd, struct mt9m111, subdev);
-	int data;
+	struct mt9m111 *mt9m111 = container_of(ctrl->handler,
+					       struct mt9m111, hdl);
 
 	switch (ctrl->id) {
 	case V4L2_CID_VFLIP:
-		if (mt9m111->context == HIGHPOWER)
-			data = reg_read(READ_MODE_B);
-		else
-			data = reg_read(READ_MODE_A);
-
-		if (data < 0)
-			return -EIO;
-		ctrl->value = !!(data & MT9M111_RMB_MIRROR_ROWS);
-		break;
-	case V4L2_CID_HFLIP:
-		if (mt9m111->context == HIGHPOWER)
-			data = reg_read(READ_MODE_B);
-		else
-			data = reg_read(READ_MODE_A);
-
-		if (data < 0)
-			return -EIO;
-		ctrl->value = !!(data & MT9M111_RMB_MIRROR_COLS);
-		break;
-	case V4L2_CID_GAIN:
-		data = mt9m111_get_global_gain(mt9m111);
-		if (data < 0)
-			return data;
-		ctrl->value = data;
-		break;
-	case V4L2_CID_EXPOSURE_AUTO:
-		ctrl->value = mt9m111->autoexposure;
-		break;
-	case V4L2_CID_AUTO_WHITE_BALANCE:
-		ctrl->value = mt9m111->autowhitebalance;
-		break;
-	}
-	return 0;
-}
-
-static int mt9m111_s_ctrl(struct v4l2_subdev *sd, struct v4l2_control *ctrl)
-{
-	struct mt9m111 *mt9m111 = container_of(sd, struct mt9m111, subdev);
-	const struct v4l2_queryctrl *qctrl;
-	int ret;
-
-	qctrl = soc_camera_find_qctrl(&mt9m111_ops, ctrl->id);
-	if (!qctrl)
-		return -EINVAL;
-
-	switch (ctrl->id) {
-	case V4L2_CID_VFLIP:
-		mt9m111->vflip = ctrl->value;
-		ret = mt9m111_set_flip(mt9m111, ctrl->value,
+		return mt9m111_set_flip(mt9m111, ctrl->val,
 					MT9M111_RMB_MIRROR_ROWS);
-		break;
 	case V4L2_CID_HFLIP:
-		mt9m111->hflip = ctrl->value;
-		ret = mt9m111_set_flip(mt9m111, ctrl->value,
+		return mt9m111_set_flip(mt9m111, ctrl->val,
 					MT9M111_RMB_MIRROR_COLS);
-		break;
 	case V4L2_CID_GAIN:
-		ret = mt9m111_set_global_gain(mt9m111, ctrl->value);
-		break;
+		return mt9m111_set_global_gain(mt9m111, ctrl->val);
 	case V4L2_CID_EXPOSURE_AUTO:
-		ret =  mt9m111_set_autoexposure(mt9m111, ctrl->value);
-		break;
+		return mt9m111_set_autoexposure(mt9m111, ctrl->val);
 	case V4L2_CID_AUTO_WHITE_BALANCE:
-		ret =  mt9m111_set_autowhitebalance(mt9m111, ctrl->value);
-		break;
-	default:
-		ret = -EINVAL;
+		return mt9m111_set_autowhitebalance(mt9m111, ctrl->val);
 	}
 
-	return ret;
+	return -EINVAL;
 }
 
 static int mt9m111_suspend(struct mt9m111 *mt9m111)
 {
-	mt9m111->gain = mt9m111_get_global_gain(mt9m111);
+	v4l2_ctrl_s_ctrl(mt9m111->gain, mt9m111_get_global_gain(mt9m111));
 
 	return 0;
 }
@@ -862,11 +746,7 @@ static void mt9m111_restore_state(struct mt9m111 *mt9m111)
 	mt9m111_set_context(mt9m111, mt9m111->context);
 	mt9m111_set_pixfmt(mt9m111, mt9m111->fmt->code);
 	mt9m111_setup_rect(mt9m111, &mt9m111->rect);
-	mt9m111_set_flip(mt9m111, mt9m111->hflip, MT9M111_RMB_MIRROR_COLS);
-	mt9m111_set_flip(mt9m111, mt9m111->vflip, MT9M111_RMB_MIRROR_ROWS);
-	mt9m111_set_global_gain(mt9m111, mt9m111->gain);
-	mt9m111_set_autoexposure(mt9m111, mt9m111->autoexposure);
-	mt9m111_set_autowhitebalance(mt9m111, mt9m111->autowhitebalance);
+	v4l2_ctrl_handler_setup(&mt9m111->hdl);
 }
 
 static int mt9m111_resume(struct mt9m111 *mt9m111)
@@ -894,8 +774,6 @@ static int mt9m111_init(struct mt9m111 *mt9m111)
 		ret = mt9m111_reset(mt9m111);
 	if (!ret)
 		ret = mt9m111_set_context(mt9m111, mt9m111->context);
-	if (!ret)
-		ret = mt9m111_set_autoexposure(mt9m111, mt9m111->autoexposure);
 	if (ret)
 		dev_err(&client->dev, "mt9m111 init failed: %d\n", ret);
 	return ret;
@@ -916,9 +794,6 @@ static int mt9m111_video_probe(struct soc_camera_device *icd,
 	BUG_ON(!icd->parent ||
 	       to_soc_camera_host(icd->parent)->nr != icd->iface);
 
-	mt9m111->autoexposure = 1;
-	mt9m111->autowhitebalance = 1;
-
 	data = reg_read(CHIP_VERSION);
 
 	switch (data) {
@@ -932,17 +807,16 @@ static int mt9m111_video_probe(struct soc_camera_device *icd,
 		dev_info(&client->dev, "Detected a MT9M112 chip ID %x\n", data);
 		break;
 	default:
-		ret = -ENODEV;
 		dev_err(&client->dev,
 			"No MT9M111/MT9M112/MT9M131 chip detected register read %x\n",
 			data);
-		goto ei2c;
+		return -ENODEV;
 	}
 
 	ret = mt9m111_init(mt9m111);
-
-ei2c:
-	return ret;
+	if (ret)
+		return ret;
+	return v4l2_ctrl_handler_setup(&mt9m111->hdl);
 }
 
 static int mt9m111_s_power(struct v4l2_subdev *sd, int on)
@@ -979,9 +853,11 @@ out:
 	return ret;
 }
 
+static const struct v4l2_ctrl_ops mt9m111_ctrl_ops = {
+	.s_ctrl = mt9m111_s_ctrl,
+};
+
 static struct v4l2_subdev_core_ops mt9m111_subdev_core_ops = {
-	.g_ctrl		= mt9m111_g_ctrl,
-	.s_ctrl		= mt9m111_s_ctrl,
 	.g_chip_ident	= mt9m111_g_chip_ident,
 	.s_power	= mt9m111_s_power,
 #ifdef CONFIG_VIDEO_ADV_DEBUG
@@ -1063,10 +939,27 @@ static int mt9m111_probe(struct i2c_client *client,
 		return -ENOMEM;
 
 	v4l2_i2c_subdev_init(&mt9m111->subdev, client, &mt9m111_subdev_ops);
+	v4l2_ctrl_handler_init(&mt9m111->hdl, 5);
+	v4l2_ctrl_new_std(&mt9m111->hdl, &mt9m111_ctrl_ops,
+			V4L2_CID_VFLIP, 0, 1, 1, 0);
+	v4l2_ctrl_new_std(&mt9m111->hdl, &mt9m111_ctrl_ops,
+			V4L2_CID_HFLIP, 0, 1, 1, 0);
+	v4l2_ctrl_new_std(&mt9m111->hdl, &mt9m111_ctrl_ops,
+			V4L2_CID_AUTO_WHITE_BALANCE, 0, 1, 1, 1);
+	mt9m111->gain = v4l2_ctrl_new_std(&mt9m111->hdl, &mt9m111_ctrl_ops,
+			V4L2_CID_GAIN, 0, 63 * 2 * 2, 1, 32);
+	v4l2_ctrl_new_std_menu(&mt9m111->hdl,
+			&mt9m111_ctrl_ops, V4L2_CID_EXPOSURE_AUTO, 1, 0,
+			V4L2_EXPOSURE_AUTO);
+	mt9m111->subdev.ctrl_handler = &mt9m111->hdl;
+	if (mt9m111->hdl.error) {
+		int err = mt9m111->hdl.error;
 
-	/* Second stage probe - when a capture adapter is there */
-	icd->ops		= &mt9m111_ops;
+		kfree(mt9m111);
+		return err;
+	}
 
+	/* Second stage probe - when a capture adapter is there */
 	mt9m111->rect.left	= MT9M111_MIN_DARK_COLS;
 	mt9m111->rect.top	= MT9M111_MIN_DARK_ROWS;
 	mt9m111->rect.width	= MT9M111_MAX_WIDTH;
@@ -1075,7 +968,7 @@ static int mt9m111_probe(struct i2c_client *client,
 
 	ret = mt9m111_video_probe(icd, client);
 	if (ret) {
-		icd->ops = NULL;
+		v4l2_ctrl_handler_free(&mt9m111->hdl);
 		kfree(mt9m111);
 	}
 
@@ -1085,9 +978,9 @@ static int mt9m111_probe(struct i2c_client *client,
 static int mt9m111_remove(struct i2c_client *client)
 {
 	struct mt9m111 *mt9m111 = to_mt9m111(client);
-	struct soc_camera_device *icd = client->dev.platform_data;
 
-	icd->ops = NULL;
+	v4l2_device_unregister_subdev(&mt9m111->subdev);
+	v4l2_ctrl_handler_free(&mt9m111->hdl);
 	kfree(mt9m111);
 
 	return 0;
-- 
1.7.2.5

