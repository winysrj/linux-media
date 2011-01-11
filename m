Return-path: <mchehab@pedra>
Received: from smtp-vbr5.xs4all.nl ([194.109.24.25]:2037 "EHLO
	smtp-vbr5.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932525Ab1AKXGf (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 11 Jan 2011 18:06:35 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Magnus Damm <magnus.damm@gmail.com>,
	Kuninori Morimoto <morimoto.kuninori@renesas.com>,
	Alberto Panizzo <maramaopercheseimorto@gmail.com>,
	Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>,
	Marek Vasut <marek.vasut@gmail.com>,
	Robert Jarzmik <robert.jarzmik@free.fr>
Subject: [RFC PATCH 08/12] ov772x: convert to the control framework.
Date: Wed, 12 Jan 2011 00:06:08 +0100
Message-Id: <ff69512f21a55204f048c5a90b37966a59a7f928.1294786597.git.hverkuil@xs4all.nl>
In-Reply-To: <1294787172-13638-1-git-send-email-hverkuil@xs4all.nl>
References: <1294787172-13638-1-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <8aa4d48eaf40a1e967e4a7450d9313de0e2c8452.1294786597.git.hverkuil@xs4all.nl>
References: <8aa4d48eaf40a1e967e4a7450d9313de0e2c8452.1294786597.git.hverkuil@xs4all.nl>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Signed-off-by: Hans Verkuil <hverkuil@xs4all.nl>
---
 drivers/media/video/ov772x.c |  112 +++++++++++++++---------------------------
 1 files changed, 39 insertions(+), 73 deletions(-)

diff --git a/drivers/media/video/ov772x.c b/drivers/media/video/ov772x.c
index 48895ef..b445ec0 100644
--- a/drivers/media/video/ov772x.c
+++ b/drivers/media/video/ov772x.c
@@ -23,6 +23,7 @@
 #include <linux/videodev2.h>
 #include <media/v4l2-chip-ident.h>
 #include <media/v4l2-subdev.h>
+#include <media/v4l2-ctrls.h>
 #include <media/soc_camera.h>
 #include <media/soc_mediabus.h>
 #include <media/ov772x.h>
@@ -400,6 +401,7 @@ struct ov772x_win_size {
 
 struct ov772x_priv {
 	struct v4l2_subdev                subdev;
+	struct v4l2_ctrl_handler	  hdl;
 	struct ov772x_camera_info        *info;
 	const struct ov772x_color_format *cfmt;
 	const struct ov772x_win_size     *win;
@@ -517,36 +519,6 @@ static const struct ov772x_win_size ov772x_win_qvga = {
 	.regs     = ov772x_qvga_regs,
 };
 
-static const struct v4l2_queryctrl ov772x_controls[] = {
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
-	{
-		.id		= V4L2_CID_BAND_STOP_FILTER,
-		.type		= V4L2_CTRL_TYPE_INTEGER,
-		.name		= "Band-stop filter",
-		.minimum	= 0,
-		.maximum	= 256,
-		.step		= 1,
-		.default_value	= 0,
-	},
-};
-
 /*
  * general function
  */
@@ -643,26 +615,10 @@ static unsigned long ov772x_query_bus_param(struct soc_camera_device *icd)
 	return soc_camera_apply_sensor_flags(icl, flags);
 }
 
-static int ov772x_g_ctrl(struct v4l2_subdev *sd, struct v4l2_control *ctrl)
-{
-	struct ov772x_priv *priv = container_of(sd, struct ov772x_priv, subdev);
-
-	switch (ctrl->id) {
-	case V4L2_CID_VFLIP:
-		ctrl->value = priv->flag_vflip;
-		break;
-	case V4L2_CID_HFLIP:
-		ctrl->value = priv->flag_hflip;
-		break;
-	case V4L2_CID_BAND_STOP_FILTER:
-		ctrl->value = priv->band_filter;
-		break;
-	}
-	return 0;
-}
-
-static int ov772x_s_ctrl(struct v4l2_subdev *sd, struct v4l2_control *ctrl)
+static int ov772x_s_ctrl(struct v4l2_ctrl *ctrl)
 {
+	struct v4l2_subdev *sd =
+		&container_of(ctrl->handler, struct ov772x_priv, hdl)->subdev;
 	struct i2c_client *client = v4l2_get_subdevdata(sd);
 	struct ov772x_priv *priv = container_of(sd, struct ov772x_priv, subdev);
 	int ret = 0;
@@ -670,25 +626,19 @@ static int ov772x_s_ctrl(struct v4l2_subdev *sd, struct v4l2_control *ctrl)
 
 	switch (ctrl->id) {
 	case V4L2_CID_VFLIP:
-		val = ctrl->value ? VFLIP_IMG : 0x00;
-		priv->flag_vflip = ctrl->value;
+		val = ctrl->val ? VFLIP_IMG : 0x00;
+		priv->flag_vflip = ctrl->val;
 		if (priv->info->flags & OV772X_FLAG_VFLIP)
 			val ^= VFLIP_IMG;
-		ret = ov772x_mask_set(client, COM3, VFLIP_IMG, val);
-		break;
+		return ov772x_mask_set(client, COM3, VFLIP_IMG, val);
 	case V4L2_CID_HFLIP:
-		val = ctrl->value ? HFLIP_IMG : 0x00;
-		priv->flag_hflip = ctrl->value;
+		val = ctrl->val ? HFLIP_IMG : 0x00;
+		priv->flag_hflip = ctrl->val;
 		if (priv->info->flags & OV772X_FLAG_HFLIP)
 			val ^= HFLIP_IMG;
-		ret = ov772x_mask_set(client, COM3, HFLIP_IMG, val);
-		break;
+		return ov772x_mask_set(client, COM3, HFLIP_IMG, val);
 	case V4L2_CID_BAND_STOP_FILTER:
-		if ((unsigned)ctrl->value > 256)
-			ctrl->value = 256;
-		if (ctrl->value == priv->band_filter)
-			break;
-		if (!ctrl->value) {
+		if (!ctrl->val) {
 			/* Switch the filter off, it is on now */
 			ret = ov772x_mask_set(client, BDBASE, 0xff, 0xff);
 			if (!ret)
@@ -696,7 +646,7 @@ static int ov772x_s_ctrl(struct v4l2_subdev *sd, struct v4l2_control *ctrl)
 						      BNDF_ON_OFF, 0);
 		} else {
 			/* Switch the filter on, set AEC low limit */
-			val = 256 - ctrl->value;
+			val = 256 - ctrl->val;
 			ret = ov772x_mask_set(client, COM8,
 					      BNDF_ON_OFF, BNDF_ON_OFF);
 			if (!ret)
@@ -704,11 +654,11 @@ static int ov772x_s_ctrl(struct v4l2_subdev *sd, struct v4l2_control *ctrl)
 						      0xff, val);
 		}
 		if (!ret)
-			priv->band_filter = ctrl->value;
-		break;
+			priv->band_filter = ctrl->val;
+		return ret;
 	}
 
-	return ret;
+	return -EINVAL;
 }
 
 static int ov772x_g_chip_ident(struct v4l2_subdev *sd,
@@ -1068,20 +1018,19 @@ static int ov772x_video_probe(struct soc_camera_device *icd,
 		 ver,
 		 i2c_smbus_read_byte_data(client, MIDH),
 		 i2c_smbus_read_byte_data(client, MIDL));
-
-	return 0;
+	return v4l2_ctrl_handler_setup(&priv->hdl);
 }
 
+static const struct v4l2_ctrl_ops ov772x_ctrl_ops = {
+	.s_ctrl = ov772x_s_ctrl,
+};
+
 static struct soc_camera_ops ov772x_ops = {
 	.set_bus_param		= ov772x_set_bus_param,
 	.query_bus_param	= ov772x_query_bus_param,
-	.controls		= ov772x_controls,
-	.num_controls		= ARRAY_SIZE(ov772x_controls),
 };
 
 static struct v4l2_subdev_core_ops ov772x_subdev_core_ops = {
-	.g_ctrl		= ov772x_g_ctrl,
-	.s_ctrl		= ov772x_s_ctrl,
 	.g_chip_ident	= ov772x_g_chip_ident,
 #ifdef CONFIG_VIDEO_ADV_DEBUG
 	.g_register	= ov772x_g_register,
@@ -1150,12 +1099,27 @@ static int ov772x_probe(struct i2c_client *client,
 	priv->info = icl->priv;
 
 	v4l2_i2c_subdev_init(&priv->subdev, client, &ov772x_subdev_ops);
+	v4l2_ctrl_handler_init(&priv->hdl, 3);
+	v4l2_ctrl_new_std(&priv->hdl, &ov772x_ctrl_ops,
+			V4L2_CID_VFLIP, 0, 1, 1, 0);
+	v4l2_ctrl_new_std(&priv->hdl, &ov772x_ctrl_ops,
+			V4L2_CID_HFLIP, 0, 1, 1, 0);
+	v4l2_ctrl_new_std(&priv->hdl, &ov772x_ctrl_ops,
+			V4L2_CID_BAND_STOP_FILTER, 0, 256, 1, 0);
+	priv->subdev.ctrl_handler = &priv->hdl;
+	if (priv->hdl.error) {
+		int err = priv->hdl.error;
+
+		kfree(priv);
+		return err;
+	}
 
-	icd->ops		= &ov772x_ops;
+	icd->ops = &ov772x_ops;
 
 	ret = ov772x_video_probe(icd, client);
 	if (ret) {
 		icd->ops = NULL;
+		v4l2_ctrl_handler_free(&priv->hdl);
 		kfree(priv);
 	}
 
@@ -1167,7 +1131,9 @@ static int ov772x_remove(struct i2c_client *client)
 	struct ov772x_priv *priv = to_ov772x(client);
 	struct soc_camera_device *icd = client->dev.platform_data;
 
+	v4l2_device_unregister_subdev(&priv->subdev);
 	icd->ops = NULL;
+	v4l2_ctrl_handler_free(&priv->hdl);
 	kfree(priv);
 	return 0;
 }
-- 
1.7.0.4

