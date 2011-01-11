Return-path: <mchehab@pedra>
Received: from smtp-vbr5.xs4all.nl ([194.109.24.25]:4618 "EHLO
	smtp-vbr5.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932520Ab1AKXGh (ORCPT
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
Subject: [RFC PATCH 10/12] ov2640: convert to the control framework.
Date: Wed, 12 Jan 2011 00:06:10 +0100
Message-Id: <4f199ecdca2214308de821c7318ecece5058170e.1294786597.git.hverkuil@xs4all.nl>
In-Reply-To: <1294787172-13638-1-git-send-email-hverkuil@xs4all.nl>
References: <1294787172-13638-1-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <8aa4d48eaf40a1e967e4a7450d9313de0e2c8452.1294786597.git.hverkuil@xs4all.nl>
References: <8aa4d48eaf40a1e967e4a7450d9313de0e2c8452.1294786597.git.hverkuil@xs4all.nl>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Signed-off-by: Hans Verkuil <hverkuil@xs4all.nl>
---
 drivers/media/video/ov2640.c |   88 ++++++++++++++---------------------------
 1 files changed, 30 insertions(+), 58 deletions(-)

diff --git a/drivers/media/video/ov2640.c b/drivers/media/video/ov2640.c
index 0cea0cf..7c9dcad 100644
--- a/drivers/media/video/ov2640.c
+++ b/drivers/media/video/ov2640.c
@@ -21,6 +21,7 @@
 #include <linux/videodev2.h>
 #include <media/v4l2-chip-ident.h>
 #include <media/v4l2-subdev.h>
+#include <media/v4l2-ctrls.h>
 #include <media/soc_camera.h>
 #include <media/soc_mediabus.h>
 
@@ -300,11 +301,10 @@ struct ov2640_win_size {
 struct ov2640_priv {
 	struct v4l2_subdev		subdev;
 	struct ov2640_camera_info	*info;
+	struct v4l2_ctrl_handler	hdl;
 	enum v4l2_mbus_pixelcode	cfmt_code;
 	const struct ov2640_win_size	*win;
 	int				model;
-	u16				flag_vflip:1;
-	u16				flag_hflip:1;
 };
 
 /*
@@ -610,29 +610,6 @@ static enum v4l2_mbus_pixelcode ov2640_codes[] = {
 };
 
 /*
- * Supported controls
- */
-static const struct v4l2_queryctrl ov2640_controls[] = {
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
-	},
-};
-
-/*
  * General functions
  */
 static struct ov2640_priv *to_ov2640(const struct i2c_client *client)
@@ -739,43 +716,23 @@ static unsigned long ov2640_query_bus_param(struct soc_camera_device *icd)
 	return soc_camera_apply_sensor_flags(icl, flags);
 }
 
-static int ov2640_g_ctrl(struct v4l2_subdev *sd, struct v4l2_control *ctrl)
-{
-	struct i2c_client  *client = v4l2_get_subdevdata(sd);
-	struct ov2640_priv *priv = to_ov2640(client);
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
-static int ov2640_s_ctrl(struct v4l2_subdev *sd, struct v4l2_control *ctrl)
+static int ov2640_s_ctrl(struct v4l2_ctrl *ctrl)
 {
+	struct v4l2_subdev *sd =
+		&container_of(ctrl->handler, struct ov2640_priv, hdl)->subdev;
 	struct i2c_client  *client = v4l2_get_subdevdata(sd);
-	struct ov2640_priv *priv = to_ov2640(client);
-	int ret = 0;
 	u8 val;
 
 	switch (ctrl->id) {
 	case V4L2_CID_VFLIP:
-		val = ctrl->value ? REG04_VFLIP_IMG : 0x00;
-		priv->flag_vflip = ctrl->value ? 1 : 0;
-		ret = ov2640_mask_set(client, REG04, REG04_VFLIP_IMG, val);
-		break;
+		val = ctrl->val ? REG04_VFLIP_IMG : 0x00;
+		return ov2640_mask_set(client, REG04, REG04_VFLIP_IMG, val);
 	case V4L2_CID_HFLIP:
-		val = ctrl->value ? REG04_HFLIP_IMG : 0x00;
-		priv->flag_hflip = ctrl->value ? 1 : 0;
-		ret = ov2640_mask_set(client, REG04, REG04_HFLIP_IMG, val);
-		break;
+		val = ctrl->val ? REG04_HFLIP_IMG : 0x00;
+		return ov2640_mask_set(client, REG04, REG04_HFLIP_IMG, val);
 	}
 
-	return ret;
+	return -EINVAL;
 }
 
 static int ov2640_g_chip_ident(struct v4l2_subdev *sd,
@@ -1067,7 +1024,7 @@ static int ov2640_video_probe(struct soc_camera_device *icd,
 		 "%s Product ID %0x:%0x Manufacturer ID %x:%x\n",
 		 devname, pid, ver, midh, midl);
 
-	return 0;
+	return v4l2_ctrl_handler_setup(&priv->hdl);
 
 err:
 	return ret;
@@ -1076,13 +1033,13 @@ err:
 static struct soc_camera_ops ov2640_ops = {
 	.set_bus_param		= ov2640_set_bus_param,
 	.query_bus_param	= ov2640_query_bus_param,
-	.controls		= ov2640_controls,
-	.num_controls		= ARRAY_SIZE(ov2640_controls),
+};
+
+static const struct v4l2_ctrl_ops ov2640_ctrl_ops = {
+	.s_ctrl = ov2640_s_ctrl,
 };
 
 static struct v4l2_subdev_core_ops ov2640_subdev_core_ops = {
-	.g_ctrl		= ov2640_g_ctrl,
-	.s_ctrl		= ov2640_s_ctrl,
 	.g_chip_ident	= ov2640_g_chip_ident,
 #ifdef CONFIG_VIDEO_ADV_DEBUG
 	.g_register	= ov2640_g_register,
@@ -1145,12 +1102,25 @@ static int ov2640_probe(struct i2c_client *client,
 	priv->info = icl->priv;
 
 	v4l2_i2c_subdev_init(&priv->subdev, client, &ov2640_subdev_ops);
+	v4l2_ctrl_handler_init(&priv->hdl, 2);
+	v4l2_ctrl_new_std(&priv->hdl, &ov2640_ctrl_ops,
+			V4L2_CID_VFLIP, 0, 1, 1, 0);
+	v4l2_ctrl_new_std(&priv->hdl, &ov2640_ctrl_ops,
+			V4L2_CID_HFLIP, 0, 1, 1, 0);
+	priv->subdev.ctrl_handler = &priv->hdl;
+	if (priv->hdl.error) {
+		int err = priv->hdl.error;
+
+		kfree(priv);
+		return err;
+	}
 
 	icd->ops = &ov2640_ops;
 
 	ret = ov2640_video_probe(icd, client);
 	if (ret) {
 		icd->ops = NULL;
+		v4l2_ctrl_handler_free(&priv->hdl);
 		kfree(priv);
 	} else {
 		dev_info(&adapter->dev, "OV2640 Probed\n");
@@ -1164,7 +1134,9 @@ static int ov2640_remove(struct i2c_client *client)
 	struct ov2640_priv       *priv = to_ov2640(client);
 	struct soc_camera_device *icd = client->dev.platform_data;
 
+	v4l2_device_unregister_subdev(&priv->subdev);
 	icd->ops = NULL;
+	v4l2_ctrl_handler_free(&priv->hdl);
 	kfree(priv);
 	return 0;
 }
-- 
1.7.0.4

