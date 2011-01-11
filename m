Return-path: <mchehab@pedra>
Received: from smtp-vbr5.xs4all.nl ([194.109.24.25]:4014 "EHLO
	smtp-vbr5.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932191Ab1AKXGc (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 11 Jan 2011 18:06:32 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Magnus Damm <magnus.damm@gmail.com>,
	Kuninori Morimoto <morimoto.kuninori@renesas.com>,
	Alberto Panizzo <maramaopercheseimorto@gmail.com>,
	Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>,
	Marek Vasut <marek.vasut@gmail.com>,
	Robert Jarzmik <robert.jarzmik@free.fr>
Subject: [RFC PATCH 04/12] mt9m111.c: convert to the control framework.
Date: Wed, 12 Jan 2011 00:06:04 +0100
Message-Id: <56c1a8ef6e1a5405881611a18579db98e271fb86.1294786597.git.hverkuil@xs4all.nl>
In-Reply-To: <1294787172-13638-1-git-send-email-hverkuil@xs4all.nl>
References: <1294787172-13638-1-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <8aa4d48eaf40a1e967e4a7450d9313de0e2c8452.1294786597.git.hverkuil@xs4all.nl>
References: <8aa4d48eaf40a1e967e4a7450d9313de0e2c8452.1294786597.git.hverkuil@xs4all.nl>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Signed-off-by: Hans Verkuil <hverkuil@xs4all.nl>
---
 drivers/media/video/mt9m111.c |  184 ++++++++++++-----------------------------
 1 files changed, 54 insertions(+), 130 deletions(-)

diff --git a/drivers/media/video/mt9m111.c b/drivers/media/video/mt9m111.c
index 53fa2a7..2328579 100644
--- a/drivers/media/video/mt9m111.c
+++ b/drivers/media/video/mt9m111.c
@@ -16,6 +16,7 @@
 
 #include <media/v4l2-common.h>
 #include <media/v4l2-chip-ident.h>
+#include <media/v4l2-ctrls.h>
 #include <media/soc_camera.h>
 
 /*
@@ -165,22 +166,19 @@ enum mt9m111_context {
 
 struct mt9m111 {
 	struct v4l2_subdev subdev;
+	struct v4l2_ctrl_handler hdl;
+	struct v4l2_ctrl *gain;
 	int model;	/* V4L2_IDENT_MT9M111 or V4L2_IDENT_MT9M112 code
 			 * from v4l2-chip-ident.h */
 	enum mt9m111_context context;
 	struct v4l2_rect rect;
 	const struct mt9m111_datafmt *fmt;
-	unsigned int gain;
-	unsigned char autoexposure;
 	unsigned char datawidth;
 	unsigned int powered:1;
-	unsigned int hflip:1;
-	unsigned int vflip:1;
 	unsigned int swap_rgb_even_odd:1;
 	unsigned int swap_rgb_red_blue:1;
 	unsigned int swap_yuv_y_chromas:1;
 	unsigned int swap_yuv_cb_cr:1;
-	unsigned int autowhitebalance:1;
 };
 
 static struct mt9m111 *to_mt9m111(const struct i2c_client *client)
@@ -679,43 +677,6 @@ static int mt9m111_s_register(struct v4l2_subdev *sd,
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
 static int mt9m111_resume(struct soc_camera_device *icd);
 static int mt9m111_suspend(struct soc_camera_device *icd, pm_message_t state);
 
@@ -724,8 +685,6 @@ static struct soc_camera_ops mt9m111_ops = {
 	.resume			= mt9m111_resume,
 	.query_bus_param	= mt9m111_query_bus_param,
 	.set_bus_param		= mt9m111_set_bus_param,
-	.controls		= mt9m111_controls,
-	.num_controls		= ARRAY_SIZE(mt9m111_controls),
 };
 
 static int mt9m111_set_flip(struct i2c_client *client, int flip, int mask)
@@ -761,13 +720,11 @@ static int mt9m111_get_global_gain(struct i2c_client *client)
 
 static int mt9m111_set_global_gain(struct i2c_client *client, int gain)
 {
-	struct mt9m111 *mt9m111 = to_mt9m111(client);
 	u16 val;
 
 	if (gain > 63 * 2 * 2)
 		return -EINVAL;
 
-	mt9m111->gain = gain;
 	if ((gain >= 64 * 2) && (gain < 63 * 2 * 2))
 		val = (1 << 10) | (1 << 9) | (gain / 4);
 	else if ((gain >= 64) && (gain < 64 * 2))
@@ -780,115 +737,67 @@ static int mt9m111_set_global_gain(struct i2c_client *client, int gain)
 
 static int mt9m111_set_autoexposure(struct i2c_client *client, int on)
 {
-	struct mt9m111 *mt9m111 = to_mt9m111(client);
 	int ret;
 
 	if (on)
 		ret = reg_set(OPER_MODE_CTRL, MT9M111_OPMODE_AUTOEXPO_EN);
 	else
 		ret = reg_clear(OPER_MODE_CTRL, MT9M111_OPMODE_AUTOEXPO_EN);
-
-	if (!ret)
-		mt9m111->autoexposure = on;
-
 	return ret;
 }
 
 static int mt9m111_set_autowhitebalance(struct i2c_client *client, int on)
 {
-	struct mt9m111 *mt9m111 = to_mt9m111(client);
 	int ret;
 
 	if (on)
 		ret = reg_set(OPER_MODE_CTRL, MT9M111_OPMODE_AUTOWHITEBAL_EN);
 	else
 		ret = reg_clear(OPER_MODE_CTRL, MT9M111_OPMODE_AUTOWHITEBAL_EN);
-
-	if (!ret)
-		mt9m111->autowhitebalance = on;
-
 	return ret;
 }
 
-static int mt9m111_g_ctrl(struct v4l2_subdev *sd, struct v4l2_control *ctrl)
+static int mt9m111_g_volatile_ctrl(struct v4l2_ctrl *ctrl)
 {
+	struct v4l2_subdev *sd =
+		&container_of(ctrl->handler, struct mt9m111, hdl)->subdev;
 	struct i2c_client *client = v4l2_get_subdevdata(sd);
-	struct mt9m111 *mt9m111 = to_mt9m111(client);
 	int data;
 
 	switch (ctrl->id) {
-	case V4L2_CID_VFLIP:
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
 	case V4L2_CID_GAIN:
 		data = mt9m111_get_global_gain(client);
 		if (data < 0)
 			return data;
-		ctrl->value = data;
-		break;
-	case V4L2_CID_EXPOSURE_AUTO:
-		ctrl->value = mt9m111->autoexposure;
-		break;
-	case V4L2_CID_AUTO_WHITE_BALANCE:
-		ctrl->value = mt9m111->autowhitebalance;
-		break;
+		ctrl->cur.val = data;
+		return 0;
 	}
-	return 0;
+	return -EINVAL;
 }
 
-static int mt9m111_s_ctrl(struct v4l2_subdev *sd, struct v4l2_control *ctrl)
+static int mt9m111_s_ctrl(struct v4l2_ctrl *ctrl)
 {
+	struct v4l2_subdev *sd =
+		&container_of(ctrl->handler, struct mt9m111, hdl)->subdev;
 	struct i2c_client *client = v4l2_get_subdevdata(sd);
-	struct mt9m111 *mt9m111 = to_mt9m111(client);
-	const struct v4l2_queryctrl *qctrl;
-	int ret;
-
-	qctrl = soc_camera_find_qctrl(&mt9m111_ops, ctrl->id);
-	if (!qctrl)
-		return -EINVAL;
 
 	switch (ctrl->id) {
 	case V4L2_CID_VFLIP:
-		mt9m111->vflip = ctrl->value;
-		ret = mt9m111_set_flip(client, ctrl->value,
+		return mt9m111_set_flip(client, ctrl->val,
 					MT9M111_RMB_MIRROR_ROWS);
-		break;
 	case V4L2_CID_HFLIP:
-		mt9m111->hflip = ctrl->value;
-		ret = mt9m111_set_flip(client, ctrl->value,
+		return mt9m111_set_flip(client, ctrl->val,
 					MT9M111_RMB_MIRROR_COLS);
-		break;
 	case V4L2_CID_GAIN:
-		ret = mt9m111_set_global_gain(client, ctrl->value);
-		break;
+		return mt9m111_set_global_gain(client, ctrl->val);
+
 	case V4L2_CID_EXPOSURE_AUTO:
-		ret =  mt9m111_set_autoexposure(client, ctrl->value);
-		break;
+		return mt9m111_set_autoexposure(client, ctrl->val);
+
 	case V4L2_CID_AUTO_WHITE_BALANCE:
-		ret =  mt9m111_set_autowhitebalance(client, ctrl->value);
-		break;
-	default:
-		ret = -EINVAL;
+		return mt9m111_set_autowhitebalance(client, ctrl->val);
 	}
-
-	return ret;
+	return -EINVAL;
 }
 
 static int mt9m111_suspend(struct soc_camera_device *icd, pm_message_t state)
@@ -896,8 +805,7 @@ static int mt9m111_suspend(struct soc_camera_device *icd, pm_message_t state)
 	struct i2c_client *client = to_i2c_client(to_soc_camera_control(icd));
 	struct mt9m111 *mt9m111 = to_mt9m111(client);
 
-	mt9m111->gain = mt9m111_get_global_gain(client);
-
+	v4l2_ctrl_s_ctrl(mt9m111->gain, mt9m111_get_global_gain(client));
 	return 0;
 }
 
@@ -908,11 +816,7 @@ static int mt9m111_restore_state(struct i2c_client *client)
 	mt9m111_set_context(client, mt9m111->context);
 	mt9m111_set_pixfmt(client, mt9m111->fmt->code);
 	mt9m111_setup_rect(client, &mt9m111->rect);
-	mt9m111_set_flip(client, mt9m111->hflip, MT9M111_RMB_MIRROR_COLS);
-	mt9m111_set_flip(client, mt9m111->vflip, MT9M111_RMB_MIRROR_ROWS);
-	mt9m111_set_global_gain(client, mt9m111->gain);
-	mt9m111_set_autoexposure(client, mt9m111->autoexposure);
-	mt9m111_set_autowhitebalance(client, mt9m111->autowhitebalance);
+	v4l2_ctrl_handler_setup(&mt9m111->hdl);
 	return 0;
 }
 
@@ -943,8 +847,6 @@ static int mt9m111_init(struct i2c_client *client)
 		ret = mt9m111_reset(client);
 	if (!ret)
 		ret = mt9m111_set_context(client, mt9m111->context);
-	if (!ret)
-		ret = mt9m111_set_autoexposure(client, mt9m111->autoexposure);
 	if (ret)
 		dev_err(&client->dev, "mt9m111 init failed: %d\n", ret);
 	return ret;
@@ -969,9 +871,6 @@ static int mt9m111_video_probe(struct soc_camera_device *icd,
 	    to_soc_camera_host(icd->dev.parent)->nr != icd->iface)
 		return -ENODEV;
 
-	mt9m111->autoexposure = 1;
-	mt9m111->autowhitebalance = 1;
-
 	mt9m111->swap_rgb_even_odd = 1;
 	mt9m111->swap_rgb_red_blue = 1;
 
@@ -988,22 +887,24 @@ static int mt9m111_video_probe(struct soc_camera_device *icd,
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
 
 	ret = mt9m111_init(client);
-
-ei2c:
-	return ret;
+	if (ret)
+		return ret;
+	return v4l2_ctrl_handler_setup(&mt9m111->hdl);
 }
 
+static const struct v4l2_ctrl_ops mt9m111_ctrl_ops = {
+	.g_volatile_ctrl = mt9m111_g_volatile_ctrl,
+	.s_ctrl = mt9m111_s_ctrl,
+};
+
 static struct v4l2_subdev_core_ops mt9m111_subdev_core_ops = {
-	.g_ctrl		= mt9m111_g_ctrl,
-	.s_ctrl		= mt9m111_s_ctrl,
 	.g_chip_ident	= mt9m111_g_chip_ident,
 #ifdef CONFIG_VIDEO_ADV_DEBUG
 	.g_register	= mt9m111_g_register,
@@ -1067,6 +968,26 @@ static int mt9m111_probe(struct i2c_client *client,
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
+
+		kfree(mt9m111);
+		return err;
+	}
+	mt9m111->gain->is_volatile = 1;
 
 	/* Second stage probe - when a capture adapter is there */
 	icd->ops		= &mt9m111_ops;
@@ -1080,6 +1001,7 @@ static int mt9m111_probe(struct i2c_client *client,
 	ret = mt9m111_video_probe(icd, client);
 	if (ret) {
 		icd->ops = NULL;
+		v4l2_ctrl_handler_free(&mt9m111->hdl);
 		kfree(mt9m111);
 	}
 
@@ -1091,7 +1013,9 @@ static int mt9m111_remove(struct i2c_client *client)
 	struct mt9m111 *mt9m111 = to_mt9m111(client);
 	struct soc_camera_device *icd = client->dev.platform_data;
 
+	v4l2_device_unregister_subdev(&mt9m111->subdev);
 	icd->ops = NULL;
+	v4l2_ctrl_handler_free(&mt9m111->hdl);
 	kfree(mt9m111);
 
 	return 0;
-- 
1.7.0.4

