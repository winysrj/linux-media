Return-path: <mchehab@pedra>
Received: from smtp-vbr5.xs4all.nl ([194.109.24.25]:1570 "EHLO
	smtp-vbr5.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932487Ab1AKXGd (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 11 Jan 2011 18:06:33 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Magnus Damm <magnus.damm@gmail.com>,
	Kuninori Morimoto <morimoto.kuninori@renesas.com>,
	Alberto Panizzo <maramaopercheseimorto@gmail.com>,
	Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>,
	Marek Vasut <marek.vasut@gmail.com>,
	Robert Jarzmik <robert.jarzmik@free.fr>
Subject: [RFC PATCH 05/12] ov9640: convert to the control framework.
Date: Wed, 12 Jan 2011 00:06:05 +0100
Message-Id: <fd4db2a1effa6f4e4b83f2b6d616c065f9001048.1294786597.git.hverkuil@xs4all.nl>
In-Reply-To: <1294787172-13638-1-git-send-email-hverkuil@xs4all.nl>
References: <1294787172-13638-1-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <8aa4d48eaf40a1e967e4a7450d9313de0e2c8452.1294786597.git.hverkuil@xs4all.nl>
References: <8aa4d48eaf40a1e967e4a7450d9313de0e2c8452.1294786597.git.hverkuil@xs4all.nl>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Signed-off-by: Hans Verkuil <hverkuil@xs4all.nl>
---
 drivers/media/video/ov9640.c |  124 ++++++++++++++----------------------------
 drivers/media/video/ov9640.h |    4 +-
 2 files changed, 43 insertions(+), 85 deletions(-)

diff --git a/drivers/media/video/ov9640.c b/drivers/media/video/ov9640.c
index 53d88a2..dbda50c 100644
--- a/drivers/media/video/ov9640.c
+++ b/drivers/media/video/ov9640.c
@@ -27,6 +27,7 @@
 #include <linux/videodev2.h>
 #include <media/v4l2-chip-ident.h>
 #include <media/v4l2-common.h>
+#include <media/v4l2-ctrls.h>
 #include <media/soc_camera.h>
 
 #include "ov9640.h"
@@ -162,27 +163,6 @@ static enum v4l2_mbus_pixelcode ov9640_codes[] = {
 	V4L2_MBUS_FMT_RGB565_2X8_LE,
 };
 
-static const struct v4l2_queryctrl ov9640_controls[] = {
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
 static int ov9640_reg_read(struct i2c_client *client, u8 reg, u8 *val)
 {
@@ -307,52 +287,25 @@ static unsigned long ov9640_query_bus_param(struct soc_camera_device *icd)
 	return soc_camera_apply_sensor_flags(icl, flags);
 }
 
-/* Get status of additional camera capabilities */
-static int ov9640_g_ctrl(struct v4l2_subdev *sd, struct v4l2_control *ctrl)
-{
-	struct ov9640_priv *priv = to_ov9640_sensor(sd);
-
-	switch (ctrl->id) {
-	case V4L2_CID_VFLIP:
-		ctrl->value = priv->flag_vflip;
-		break;
-	case V4L2_CID_HFLIP:
-		ctrl->value = priv->flag_hflip;
-		break;
-	}
-	return 0;
-}
-
 /* Set status of additional camera capabilities */
-static int ov9640_s_ctrl(struct v4l2_subdev *sd, struct v4l2_control *ctrl)
+static int ov9640_s_ctrl(struct v4l2_ctrl *ctrl)
 {
-	struct i2c_client *client = v4l2_get_subdevdata(sd);
-	struct ov9640_priv *priv = to_ov9640_sensor(sd);
-
-	int ret = 0;
+	struct ov9640_priv *priv = container_of(ctrl->handler, struct ov9640_priv, hdl);
+	struct i2c_client *client = v4l2_get_subdevdata(&priv->subdev);
 
 	switch (ctrl->id) {
 	case V4L2_CID_VFLIP:
-		priv->flag_vflip = ctrl->value;
-		if (ctrl->value)
-			ret = ov9640_reg_rmw(client, OV9640_MVFP,
+		if (ctrl->val)
+			return ov9640_reg_rmw(client, OV9640_MVFP,
 							OV9640_MVFP_V, 0);
-		else
-			ret = ov9640_reg_rmw(client, OV9640_MVFP,
-							0, OV9640_MVFP_V);
-		break;
+		return ov9640_reg_rmw(client, OV9640_MVFP, 0, OV9640_MVFP_V);
 	case V4L2_CID_HFLIP:
-		priv->flag_hflip = ctrl->value;
-		if (ctrl->value)
-			ret = ov9640_reg_rmw(client, OV9640_MVFP,
+		if (ctrl->val)
+			return ov9640_reg_rmw(client, OV9640_MVFP,
 							OV9640_MVFP_H, 0);
-		else
-			ret = ov9640_reg_rmw(client, OV9640_MVFP,
-							0, OV9640_MVFP_H);
-		break;
+		return ov9640_reg_rmw(client, OV9640_MVFP, 0, OV9640_MVFP_H);
 	}
-
-	return ret;
+	return -EINVAL;
 }
 
 /* Get chip identification */
@@ -664,8 +617,7 @@ static int ov9640_video_probe(struct soc_camera_device *icd,
 	if (!icd->dev.parent ||
 	    to_soc_camera_host(icd->dev.parent)->nr != icd->iface) {
 		dev_err(&client->dev, "Parent missing or invalid!\n");
-		ret = -ENODEV;
-		goto err;
+		return -ENODEV;
 	}
 
 	/*
@@ -673,20 +625,14 @@ static int ov9640_video_probe(struct soc_camera_device *icd,
 	 */
 
 	ret = ov9640_reg_read(client, OV9640_PID, &pid);
+	if (!ret)
+		ret = ov9640_reg_read(client, OV9640_VER, &ver);
+	if (!ret)
+		ret = ov9640_reg_read(client, OV9640_MIDH, &midh);
+	if (!ret)
+		ret = ov9640_reg_read(client, OV9640_MIDL, &midl);
 	if (ret)
-		goto err;
-
-	ret = ov9640_reg_read(client, OV9640_VER, &ver);
-	if (ret)
-		goto err;
-
-	ret = ov9640_reg_read(client, OV9640_MIDH, &midh);
-	if (ret)
-		goto err;
-
-	ret = ov9640_reg_read(client, OV9640_MIDL, &midl);
-	if (ret)
-		goto err;
+		return ret;
 
 	switch (VERSION(pid, ver)) {
 	case OV9640_V2:
@@ -700,27 +646,25 @@ static int ov9640_video_probe(struct soc_camera_device *icd,
 		break;
 	default:
 		dev_err(&client->dev, "Product ID error %x:%x\n", pid, ver);
-		ret = -ENODEV;
-		goto err;
+		return -ENODEV;
 	}
 
 	dev_info(&client->dev, "%s Product ID %0x:%0x Manufacturer ID %x:%x\n",
 		 devname, pid, ver, midh, midl);
 
-err:
-	return ret;
+	return v4l2_ctrl_handler_setup(&priv->hdl);
 }
 
+static const struct v4l2_ctrl_ops ov9640_ctrl_ops = {
+	.s_ctrl = ov9640_s_ctrl,
+};
+
 static struct soc_camera_ops ov9640_ops = {
 	.set_bus_param		= ov9640_set_bus_param,
 	.query_bus_param	= ov9640_query_bus_param,
-	.controls		= ov9640_controls,
-	.num_controls		= ARRAY_SIZE(ov9640_controls),
 };
 
 static struct v4l2_subdev_core_ops ov9640_core_ops = {
-	.g_ctrl			= ov9640_g_ctrl,
-	.s_ctrl			= ov9640_s_ctrl,
 	.g_chip_ident		= ov9640_g_chip_ident,
 #ifdef CONFIG_VIDEO_ADV_DEBUG
 	.g_register		= ov9640_get_register,
@@ -775,12 +719,26 @@ static int ov9640_probe(struct i2c_client *client,
 
 	v4l2_i2c_subdev_init(&priv->subdev, client, &ov9640_subdev_ops);
 
-	icd->ops	= &ov9640_ops;
+	v4l2_ctrl_handler_init(&priv->hdl, 2);
+	v4l2_ctrl_new_std(&priv->hdl, &ov9640_ctrl_ops,
+			V4L2_CID_VFLIP, 0, 1, 1, 0);
+	v4l2_ctrl_new_std(&priv->hdl, &ov9640_ctrl_ops,
+			V4L2_CID_HFLIP, 0, 1, 1, 0);
+	priv->subdev.ctrl_handler = &priv->hdl;
+	if (priv->hdl.error) {
+		int err = priv->hdl.error;
+
+		kfree(priv);
+		return err;
+	}
+
+	icd->ops = &ov9640_ops;
 
 	ret = ov9640_video_probe(icd, client);
 
 	if (ret) {
 		icd->ops = NULL;
+		v4l2_ctrl_handler_free(&priv->hdl);
 		kfree(priv);
 	}
 
@@ -792,6 +750,8 @@ static int ov9640_remove(struct i2c_client *client)
 	struct v4l2_subdev *sd = i2c_get_clientdata(client);
 	struct ov9640_priv *priv = to_ov9640_sensor(sd);
 
+	v4l2_device_unregister_subdev(&priv->subdev);
+	v4l2_ctrl_handler_free(&priv->hdl);
 	kfree(priv);
 	return 0;
 }
diff --git a/drivers/media/video/ov9640.h b/drivers/media/video/ov9640.h
index f8a51b7..6b33a97 100644
--- a/drivers/media/video/ov9640.h
+++ b/drivers/media/video/ov9640.h
@@ -198,12 +198,10 @@ struct ov9640_reg {
 
 struct ov9640_priv {
 	struct v4l2_subdev		subdev;
+	struct v4l2_ctrl_handler	hdl;
 
 	int				model;
 	int				revision;
-
-	bool				flag_vflip;
-	bool				flag_hflip;
 };
 
 #endif	/* __DRIVERS_MEDIA_VIDEO_OV9640_H__ */
-- 
1.7.0.4

