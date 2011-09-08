Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.186]:59664 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932418Ab1IHIoR (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 8 Sep 2011 04:44:17 -0400
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>,
	Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: [PATCH 04/13 v3] ov772x: convert to the control framework.
Date: Thu,  8 Sep 2011 10:43:57 +0200
Message-Id: <1315471446-17890-5-git-send-email-g.liakhovetski@gmx.de>
In-Reply-To: <1315471446-17890-1-git-send-email-g.liakhovetski@gmx.de>
References: <1315471446-17890-1-git-send-email-g.liakhovetski@gmx.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
[g.liakhovetski@gmx.de: simplified pointer arithmetic]
Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
---
 drivers/media/video/ov772x.c |  114 +++++++++++++----------------------------
 1 files changed, 36 insertions(+), 78 deletions(-)

diff --git a/drivers/media/video/ov772x.c b/drivers/media/video/ov772x.c
index f77e899..9b54042 100644
--- a/drivers/media/video/ov772x.c
+++ b/drivers/media/video/ov772x.c
@@ -25,6 +25,7 @@
 #include <media/ov772x.h>
 #include <media/soc_camera.h>
 #include <media/soc_mediabus.h>
+#include <media/v4l2-ctrls.h>
 #include <media/v4l2-chip-ident.h>
 #include <media/v4l2-subdev.h>
 
@@ -401,6 +402,7 @@ struct ov772x_win_size {
 
 struct ov772x_priv {
 	struct v4l2_subdev                subdev;
+	struct v4l2_ctrl_handler	  hdl;
 	struct ov772x_camera_info        *info;
 	const struct ov772x_color_format *cfmt;
 	const struct ov772x_win_size     *win;
@@ -518,36 +520,6 @@ static const struct ov772x_win_size ov772x_win_qvga = {
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
@@ -621,52 +593,30 @@ static int ov772x_s_stream(struct v4l2_subdev *sd, int enable)
 	return 0;
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
+	struct ov772x_priv *priv = container_of(ctrl->handler,
+						struct ov772x_priv, hdl);
+	struct v4l2_subdev *sd = &priv->subdev;
 	struct i2c_client *client = v4l2_get_subdevdata(sd);
-	struct ov772x_priv *priv = container_of(sd, struct ov772x_priv, subdev);
 	int ret = 0;
 	u8 val;
 
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
@@ -674,7 +624,7 @@ static int ov772x_s_ctrl(struct v4l2_subdev *sd, struct v4l2_control *ctrl)
 						      BNDF_ON_OFF, 0);
 		} else {
 			/* Switch the filter on, set AEC low limit */
-			val = 256 - ctrl->value;
+			val = 256 - ctrl->val;
 			ret = ov772x_mask_set(client, COM8,
 					      BNDF_ON_OFF, BNDF_ON_OFF);
 			if (!ret)
@@ -682,11 +632,11 @@ static int ov772x_s_ctrl(struct v4l2_subdev *sd, struct v4l2_control *ctrl)
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
@@ -1042,18 +992,14 @@ static int ov772x_video_probe(struct soc_camera_device *icd,
 		 ver,
 		 i2c_smbus_read_byte_data(client, MIDH),
 		 i2c_smbus_read_byte_data(client, MIDL));
-
-	return 0;
+	return v4l2_ctrl_handler_setup(&priv->hdl);
 }
 
-static struct soc_camera_ops ov772x_ops = {
-	.controls		= ov772x_controls,
-	.num_controls		= ARRAY_SIZE(ov772x_controls),
+static const struct v4l2_ctrl_ops ov772x_ctrl_ops = {
+	.s_ctrl = ov772x_s_ctrl,
 };
 
 static struct v4l2_subdev_core_ops ov772x_subdev_core_ops = {
-	.g_ctrl		= ov772x_g_ctrl,
-	.s_ctrl		= ov772x_s_ctrl,
 	.g_chip_ident	= ov772x_g_chip_ident,
 #ifdef CONFIG_VIDEO_ADV_DEBUG
 	.g_register	= ov772x_g_register,
@@ -1139,12 +1085,24 @@ static int ov772x_probe(struct i2c_client *client,
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
 
-	icd->ops		= &ov772x_ops;
+		kfree(priv);
+		return err;
+	}
 
 	ret = ov772x_video_probe(icd, client);
 	if (ret) {
-		icd->ops = NULL;
+		v4l2_ctrl_handler_free(&priv->hdl);
 		kfree(priv);
 	}
 
@@ -1154,9 +1112,9 @@ static int ov772x_probe(struct i2c_client *client,
 static int ov772x_remove(struct i2c_client *client)
 {
 	struct ov772x_priv *priv = to_ov772x(client);
-	struct soc_camera_device *icd = client->dev.platform_data;
 
-	icd->ops = NULL;
+	v4l2_device_unregister_subdev(&priv->subdev);
+	v4l2_ctrl_handler_free(&priv->hdl);
 	kfree(priv);
 	return 0;
 }
-- 
1.7.2.5

