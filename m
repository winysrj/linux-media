Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.17.9]:58691 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932423Ab1IHIoR (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 8 Sep 2011 04:44:17 -0400
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>,
	Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: [PATCH 05/13 v3] rj54n1cb0c: convert to the control framework.
Date: Thu,  8 Sep 2011 10:43:58 +0200
Message-Id: <1315471446-17890-6-git-send-email-g.liakhovetski@gmx.de>
In-Reply-To: <1315471446-17890-1-git-send-email-g.liakhovetski@gmx.de>
References: <1315471446-17890-1-git-send-email-g.liakhovetski@gmx.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
[g.liakhovetski@gmx.de: simplified pointer arithmetic]
Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
---
 drivers/media/video/rj54n1cb0c.c |  141 ++++++++++---------------------------
 1 files changed, 38 insertions(+), 103 deletions(-)

diff --git a/drivers/media/video/rj54n1cb0c.c b/drivers/media/video/rj54n1cb0c.c
index c302211..9a87153 100644
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
@@ -1177,132 +1179,51 @@ static int rj54n1_s_register(struct v4l2_subdev *sd,
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
-static struct soc_camera_ops rj54n1_ops = {
-	.controls		= rj54n1_controls,
-	.num_controls		= ARRAY_SIZE(rj54n1_controls),
-};
-
-static int rj54n1_g_ctrl(struct v4l2_subdev *sd, struct v4l2_control *ctrl)
+static int rj54n1_s_ctrl(struct v4l2_ctrl *ctrl)
 {
+	struct rj54n1 *rj54n1 = container_of(ctrl->handler, struct rj54n1, hdl);
+	struct v4l2_subdev *sd = &rj54n1->subdev;
 	struct i2c_client *client = v4l2_get_subdevdata(sd);
-	struct rj54n1 *rj54n1 = to_rj54n1(client);
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
@@ -1432,8 +1353,22 @@ static int rj54n1_probe(struct i2c_client *client,
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
 
-	icd->ops		= &rj54n1_ops;
+		kfree(rj54n1);
+		return err;
+	}
 
 	rj54n1->clk_div		= clk_div;
 	rj54n1->rect.left	= RJ54N1_COLUMN_SKIP;
@@ -1449,12 +1384,11 @@ static int rj54n1_probe(struct i2c_client *client,
 
 	ret = rj54n1_video_probe(icd, client, rj54n1_priv);
 	if (ret < 0) {
-		icd->ops = NULL;
+		v4l2_ctrl_handler_free(&rj54n1->hdl);
 		kfree(rj54n1);
 		return ret;
 	}
-
-	return ret;
+	return v4l2_ctrl_handler_setup(&rj54n1->hdl);
 }
 
 static int rj54n1_remove(struct i2c_client *client)
@@ -1463,9 +1397,10 @@ static int rj54n1_remove(struct i2c_client *client)
 	struct soc_camera_device *icd = client->dev.platform_data;
 	struct soc_camera_link *icl = to_soc_camera_link(icd);
 
-	icd->ops = NULL;
+	v4l2_device_unregister_subdev(&rj54n1->subdev);
 	if (icl->free_bus)
 		icl->free_bus(icl);
+	v4l2_ctrl_handler_free(&rj54n1->hdl);
 	kfree(rj54n1);
 
 	return 0;
-- 
1.7.2.5

