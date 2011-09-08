Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.186]:49264 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932404Ab1IHIoR (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 8 Sep 2011 04:44:17 -0400
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>,
	Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: [PATCH 09/13 v3] ov9740: convert to the control framework.
Date: Thu,  8 Sep 2011 10:44:02 +0200
Message-Id: <1315471446-17890-10-git-send-email-g.liakhovetski@gmx.de>
In-Reply-To: <1315471446-17890-1-git-send-email-g.liakhovetski@gmx.de>
References: <1315471446-17890-1-git-send-email-g.liakhovetski@gmx.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
---
 drivers/media/video/ov9740.c |   83 ++++++++++++++----------------------------
 1 files changed, 28 insertions(+), 55 deletions(-)

diff --git a/drivers/media/video/ov9740.c b/drivers/media/video/ov9740.c
index 5920f60..3dd910d 100644
--- a/drivers/media/video/ov9740.c
+++ b/drivers/media/video/ov9740.c
@@ -18,6 +18,7 @@
 #include <media/soc_camera.h>
 #include <media/soc_mediabus.h>
 #include <media/v4l2-chip-ident.h>
+#include <media/v4l2-ctrls.h>
 
 #define to_ov9740(sd)		container_of(sd, struct ov9740_priv, subdev)
 
@@ -194,6 +195,7 @@ struct ov9740_reg {
 
 struct ov9740_priv {
 	struct v4l2_subdev		subdev;
+	struct v4l2_ctrl_handler	hdl;
 
 	int				ident;
 	u16				model;
@@ -394,27 +396,6 @@ static enum v4l2_mbus_pixelcode ov9740_codes[] = {
 	V4L2_MBUS_FMT_YUYV8_2X8,
 };
 
-static const struct v4l2_queryctrl ov9740_controls[] = {
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
 static int ov9740_reg_read(struct i2c_client *client, u16 reg, u8 *val)
 {
@@ -771,36 +752,18 @@ static int ov9740_g_crop(struct v4l2_subdev *sd, struct v4l2_crop *a)
 	return 0;
 }
 
-/* Get status of additional camera capabilities */
-static int ov9740_g_ctrl(struct v4l2_subdev *sd, struct v4l2_control *ctrl)
-{
-	struct ov9740_priv *priv = to_ov9740(sd);
-
-	switch (ctrl->id) {
-	case V4L2_CID_VFLIP:
-		ctrl->value = priv->flag_vflip;
-		break;
-	case V4L2_CID_HFLIP:
-		ctrl->value = priv->flag_hflip;
-		break;
-	default:
-		return -EINVAL;
-	}
-
-	return 0;
-}
-
 /* Set status of additional camera capabilities */
-static int ov9740_s_ctrl(struct v4l2_subdev *sd, struct v4l2_control *ctrl)
+static int ov9740_s_ctrl(struct v4l2_ctrl *ctrl)
 {
-	struct ov9740_priv *priv = to_ov9740(sd);
+	struct ov9740_priv *priv =
+		container_of(ctrl->handler, struct ov9740_priv, hdl);
 
 	switch (ctrl->id) {
 	case V4L2_CID_VFLIP:
-		priv->flag_vflip = ctrl->value;
+		priv->flag_vflip = ctrl->val;
 		break;
 	case V4L2_CID_HFLIP:
-		priv->flag_hflip = ctrl->value;
+		priv->flag_hflip = ctrl->val;
 		break;
 	default:
 		return -EINVAL;
@@ -925,11 +888,6 @@ err:
 	return ret;
 }
 
-static struct soc_camera_ops ov9740_ops = {
-	.controls		= ov9740_controls,
-	.num_controls		= ARRAY_SIZE(ov9740_controls),
-};
-
 /* Request bus settings on camera side */
 static int ov9740_g_mbus_config(struct v4l2_subdev *sd,
 				struct v4l2_mbus_config *cfg)
@@ -958,8 +916,6 @@ static struct v4l2_subdev_video_ops ov9740_video_ops = {
 };
 
 static struct v4l2_subdev_core_ops ov9740_core_ops = {
-	.g_ctrl			= ov9740_g_ctrl,
-	.s_ctrl			= ov9740_s_ctrl,
 	.g_chip_ident		= ov9740_g_chip_ident,
 	.s_power		= ov9740_s_power,
 #ifdef CONFIG_VIDEO_ADV_DEBUG
@@ -973,6 +929,10 @@ static struct v4l2_subdev_ops ov9740_subdev_ops = {
 	.video			= &ov9740_video_ops,
 };
 
+static const struct v4l2_ctrl_ops ov9740_ctrl_ops = {
+	.s_ctrl = ov9740_s_ctrl,
+};
+
 /*
  * i2c_driver function
  */
@@ -980,7 +940,7 @@ static int ov9740_probe(struct i2c_client *client,
 			const struct i2c_device_id *did)
 {
 	struct ov9740_priv *priv;
-	struct soc_camera_device *icd	= client->dev.platform_data;
+	struct soc_camera_device *icd = client->dev.platform_data;
 	struct soc_camera_link *icl;
 	int ret;
 
@@ -1002,12 +962,24 @@ static int ov9740_probe(struct i2c_client *client,
 	}
 
 	v4l2_i2c_subdev_init(&priv->subdev, client, &ov9740_subdev_ops);
+	v4l2_ctrl_handler_init(&priv->hdl, 13);
+	v4l2_ctrl_new_std(&priv->hdl, &ov9740_ctrl_ops,
+			V4L2_CID_VFLIP, 0, 1, 1, 0);
+	v4l2_ctrl_new_std(&priv->hdl, &ov9740_ctrl_ops,
+			V4L2_CID_HFLIP, 0, 1, 1, 0);
+	priv->subdev.ctrl_handler = &priv->hdl;
+	if (priv->hdl.error) {
+		int err = priv->hdl.error;
 
-	icd->ops = &ov9740_ops;
+		kfree(priv);
+		return err;
+	}
 
 	ret = ov9740_video_probe(icd, client);
+	if (!ret)
+		ret = v4l2_ctrl_handler_setup(&priv->hdl);
 	if (ret < 0) {
-		icd->ops = NULL;
+		v4l2_ctrl_handler_free(&priv->hdl);
 		kfree(priv);
 	}
 
@@ -1018,8 +990,9 @@ static int ov9740_remove(struct i2c_client *client)
 {
 	struct ov9740_priv *priv = i2c_get_clientdata(client);
 
+	v4l2_device_unregister_subdev(&priv->subdev);
+	v4l2_ctrl_handler_free(&priv->hdl);
 	kfree(priv);
-
 	return 0;
 }
 
-- 
1.7.2.5

