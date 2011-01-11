Return-path: <mchehab@pedra>
Received: from smtp-vbr5.xs4all.nl ([194.109.24.25]:3283 "EHLO
	smtp-vbr5.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932532Ab1AKXGh (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 11 Jan 2011 18:06:37 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Magnus Damm <magnus.damm@gmail.com>,
	Kuninori Morimoto <morimoto.kuninori@renesas.com>,
	Alberto Panizzo <maramaopercheseimorto@gmail.com>,
	Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>,
	Marek Vasut <marek.vasut@gmail.com>,
	Robert Jarzmik <robert.jarzmik@free.fr>
Subject: [RFC PATCH 09/12] rj54n1cb0c: convert to the control framework.
Date: Wed, 12 Jan 2011 00:06:09 +0100
Message-Id: <2fb0f561c34e23fd5d440a429944120dd9a7bd8b.1294786597.git.hverkuil@xs4all.nl>
In-Reply-To: <1294787172-13638-1-git-send-email-hverkuil@xs4all.nl>
References: <1294787172-13638-1-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <8aa4d48eaf40a1e967e4a7450d9313de0e2c8452.1294786597.git.hverkuil@xs4all.nl>
References: <8aa4d48eaf40a1e967e4a7450d9313de0e2c8452.1294786597.git.hverkuil@xs4all.nl>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Signed-off-by: Hans Verkuil <hverkuil@xs4all.nl>
---
 drivers/media/video/rj54n1cb0c.c |  135 +++++++++++---------------------------
 1 files changed, 39 insertions(+), 96 deletions(-)

diff --git a/drivers/media/video/rj54n1cb0c.c b/drivers/media/video/rj54n1cb0c.c
index 57e11b6..f8e4ef0 100644
--- a/drivers/media/video/rj54n1cb0c.c
+++ b/drivers/media/video/rj54n1cb0c.c
@@ -18,6 +18,7 @@
 #include <media/soc_mediabus.h>
 #include <media/v4l2-subdev.h>
 #include <media/v4l2-chip-ident.h>
+#include <media/v4l2-ctrls.h>
 
 #define RJ54N1_DEV_CODE			0x0400
 #define RJ54N1_DEV_CODE2		0x0401
@@ -148,6 +149,7 @@ struct rj54n1_clock_div {
 
 struct rj54n1 {
 	struct v4l2_subdev subdev;
+	struct v4l2_ctrl_handler hdl;
 	struct rj54n1_clock_div clk_div;
 	const struct rj54n1_datafmt *fmt;
 	struct v4l2_rect rect;	/* Sensor window */
@@ -1202,134 +1204,57 @@ static int rj54n1_s_register(struct v4l2_subdev *sd,
 }
 #endif
 
-static const struct v4l2_queryctrl rj54n1_controls[] = {
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
-		.name		= "Gain",
-		.minimum	= 0,
-		.maximum	= 127,
-		.step		= 1,
-		.default_value	= 66,
-		.flags		= V4L2_CTRL_FLAG_SLIDER,
-	}, {
-		.id		= V4L2_CID_AUTO_WHITE_BALANCE,
-		.type		= V4L2_CTRL_TYPE_BOOLEAN,
-		.name		= "Auto white balance",
-		.minimum	= 0,
-		.maximum	= 1,
-		.step		= 1,
-		.default_value	= 1,
-	},
-};
-
 static struct soc_camera_ops rj54n1_ops = {
 	.set_bus_param		= rj54n1_set_bus_param,
 	.query_bus_param	= rj54n1_query_bus_param,
-	.controls		= rj54n1_controls,
-	.num_controls		= ARRAY_SIZE(rj54n1_controls),
 };
 
-static int rj54n1_g_ctrl(struct v4l2_subdev *sd, struct v4l2_control *ctrl)
+static int rj54n1_s_ctrl(struct v4l2_ctrl *ctrl)
 {
+	struct v4l2_subdev *sd =
+		&container_of(ctrl->handler, struct rj54n1, hdl)->subdev;
 	struct i2c_client *client = v4l2_get_subdevdata(sd);
 	struct rj54n1 *rj54n1 = to_rj54n1(client);
 	int data;
 
 	switch (ctrl->id) {
 	case V4L2_CID_VFLIP:
-		data = reg_read(client, RJ54N1_MIRROR_STILL_MODE);
-		if (data < 0)
-			return -EIO;
-		ctrl->value = !(data & 1);
-		break;
-	case V4L2_CID_HFLIP:
-		data = reg_read(client, RJ54N1_MIRROR_STILL_MODE);
-		if (data < 0)
-			return -EIO;
-		ctrl->value = !(data & 2);
-		break;
-	case V4L2_CID_GAIN:
-		data = reg_read(client, RJ54N1_Y_GAIN);
-		if (data < 0)
-			return -EIO;
-
-		ctrl->value = data / 2;
-		break;
-	case V4L2_CID_AUTO_WHITE_BALANCE:
-		ctrl->value = rj54n1->auto_wb;
-		break;
-	}
-
-	return 0;
-}
-
-static int rj54n1_s_ctrl(struct v4l2_subdev *sd, struct v4l2_control *ctrl)
-{
-	int data;
-	struct i2c_client *client = v4l2_get_subdevdata(sd);
-	struct rj54n1 *rj54n1 = to_rj54n1(client);
-	const struct v4l2_queryctrl *qctrl;
-
-	qctrl = soc_camera_find_qctrl(&rj54n1_ops, ctrl->id);
-	if (!qctrl)
-		return -EINVAL;
-
-	switch (ctrl->id) {
-	case V4L2_CID_VFLIP:
-		if (ctrl->value)
+		if (ctrl->val)
 			data = reg_set(client, RJ54N1_MIRROR_STILL_MODE, 0, 1);
 		else
 			data = reg_set(client, RJ54N1_MIRROR_STILL_MODE, 1, 1);
 		if (data < 0)
 			return -EIO;
-		break;
+		return 0;
 	case V4L2_CID_HFLIP:
-		if (ctrl->value)
+		if (ctrl->val)
 			data = reg_set(client, RJ54N1_MIRROR_STILL_MODE, 0, 2);
 		else
 			data = reg_set(client, RJ54N1_MIRROR_STILL_MODE, 2, 2);
 		if (data < 0)
 			return -EIO;
-		break;
+		return 0;
 	case V4L2_CID_GAIN:
-		if (ctrl->value > qctrl->maximum ||
-		    ctrl->value < qctrl->minimum)
-			return -EINVAL;
-		else if (reg_write(client, RJ54N1_Y_GAIN, ctrl->value * 2) < 0)
+		if (reg_write(client, RJ54N1_Y_GAIN, ctrl->val * 2) < 0)
 			return -EIO;
-		break;
+		return 0;
 	case V4L2_CID_AUTO_WHITE_BALANCE:
 		/* Auto WB area - whole image */
-		if (reg_set(client, RJ54N1_WB_SEL_WEIGHT_I, ctrl->value << 7,
+		if (reg_set(client, RJ54N1_WB_SEL_WEIGHT_I, ctrl->val << 7,
 			    0x80) < 0)
 			return -EIO;
-		rj54n1->auto_wb = ctrl->value;
-		break;
+		rj54n1->auto_wb = ctrl->val;
+		return 0;
 	}
 
-	return 0;
+	return -EINVAL;
 }
 
+static const struct v4l2_ctrl_ops rj54n1_ctrl_ops = {
+	.s_ctrl = rj54n1_s_ctrl,
+};
+
 static struct v4l2_subdev_core_ops rj54n1_subdev_core_ops = {
-	.g_ctrl		= rj54n1_g_ctrl,
-	.s_ctrl		= rj54n1_s_ctrl,
 	.g_chip_ident	= rj54n1_g_chip_ident,
 #ifdef CONFIG_VIDEO_ADV_DEBUG
 	.g_register	= rj54n1_g_register,
@@ -1426,6 +1351,22 @@ static int rj54n1_probe(struct i2c_client *client,
 		return -ENOMEM;
 
 	v4l2_i2c_subdev_init(&rj54n1->subdev, client, &rj54n1_subdev_ops);
+	v4l2_ctrl_handler_init(&rj54n1->hdl, 4);
+	v4l2_ctrl_new_std(&rj54n1->hdl, &rj54n1_ctrl_ops,
+			V4L2_CID_VFLIP, 0, 1, 1, 0);
+	v4l2_ctrl_new_std(&rj54n1->hdl, &rj54n1_ctrl_ops,
+			V4L2_CID_HFLIP, 0, 1, 1, 0);
+	v4l2_ctrl_new_std(&rj54n1->hdl, &rj54n1_ctrl_ops,
+			V4L2_CID_GAIN, 0, 127, 1, 66);
+	v4l2_ctrl_new_std(&rj54n1->hdl, &rj54n1_ctrl_ops,
+			V4L2_CID_AUTO_WHITE_BALANCE, 0, 1, 1, 1);
+	rj54n1->subdev.ctrl_handler = &rj54n1->hdl;
+	if (rj54n1->hdl.error) {
+		int err = rj54n1->hdl.error;
+
+		kfree(rj54n1);
+		return err;
+	}
 
 	icd->ops		= &rj54n1_ops;
 
@@ -1444,11 +1385,11 @@ static int rj54n1_probe(struct i2c_client *client,
 	ret = rj54n1_video_probe(icd, client, rj54n1_priv);
 	if (ret < 0) {
 		icd->ops = NULL;
+		v4l2_ctrl_handler_free(&rj54n1->hdl);
 		kfree(rj54n1);
 		return ret;
 	}
-
-	return ret;
+	return v4l2_ctrl_handler_setup(&rj54n1->hdl);
 }
 
 static int rj54n1_remove(struct i2c_client *client)
@@ -1457,9 +1398,11 @@ static int rj54n1_remove(struct i2c_client *client)
 	struct soc_camera_device *icd = client->dev.platform_data;
 	struct soc_camera_link *icl = to_soc_camera_link(icd);
 
+	v4l2_device_unregister_subdev(&rj54n1->subdev);
 	icd->ops = NULL;
 	if (icl->free_bus)
 		icl->free_bus(icl);
+	v4l2_ctrl_handler_free(&rj54n1->hdl);
 	kfree(rj54n1);
 
 	return 0;
-- 
1.7.0.4

