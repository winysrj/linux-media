Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.17.8]:50548 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932413Ab1IHIoR (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 8 Sep 2011 04:44:17 -0400
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>,
	Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: [PATCH 07/13 v3] ov2640: convert to the control framework.
Date: Thu,  8 Sep 2011 10:44:00 +0200
Message-Id: <1315471446-17890-8-git-send-email-g.liakhovetski@gmx.de>
In-Reply-To: <1315471446-17890-1-git-send-email-g.liakhovetski@gmx.de>
References: <1315471446-17890-1-git-send-email-g.liakhovetski@gmx.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
---
 drivers/media/video/ov2640.c |   90 ++++++++++++-----------------------------
 1 files changed, 27 insertions(+), 63 deletions(-)

diff --git a/drivers/media/video/ov2640.c b/drivers/media/video/ov2640.c
index 2826aff..981767f 100644
--- a/drivers/media/video/ov2640.c
+++ b/drivers/media/video/ov2640.c
@@ -24,6 +24,7 @@
 #include <media/soc_mediabus.h>
 #include <media/v4l2-chip-ident.h>
 #include <media/v4l2-subdev.h>
+#include <media/v4l2-ctrls.h>
 
 #define VAL_SET(x, mask, rshift, lshift)  \
 		((((x) >> rshift) & mask) << lshift)
@@ -300,11 +301,10 @@ struct ov2640_win_size {
 
 struct ov2640_priv {
 	struct v4l2_subdev		subdev;
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
@@ -701,43 +678,23 @@ static int ov2640_s_stream(struct v4l2_subdev *sd, int enable)
 	return 0;
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
@@ -1022,20 +979,17 @@ static int ov2640_video_probe(struct soc_camera_device *icd,
 		 "%s Product ID %0x:%0x Manufacturer ID %x:%x\n",
 		 devname, pid, ver, midh, midl);
 
-	return 0;
+	return v4l2_ctrl_handler_setup(&priv->hdl);
 
 err:
 	return ret;
 }
 
-static struct soc_camera_ops ov2640_ops = {
-	.controls		= ov2640_controls,
-	.num_controls		= ARRAY_SIZE(ov2640_controls),
+static const struct v4l2_ctrl_ops ov2640_ctrl_ops = {
+	.s_ctrl = ov2640_s_ctrl,
 };
 
 static struct v4l2_subdev_core_ops ov2640_subdev_core_ops = {
-	.g_ctrl		= ov2640_g_ctrl,
-	.s_ctrl		= ov2640_s_ctrl,
 	.g_chip_ident	= ov2640_g_chip_ident,
 #ifdef CONFIG_VIDEO_ADV_DEBUG
 	.g_register	= ov2640_g_register,
@@ -1113,12 +1067,22 @@ static int ov2640_probe(struct i2c_client *client,
 	}
 
 	v4l2_i2c_subdev_init(&priv->subdev, client, &ov2640_subdev_ops);
+	v4l2_ctrl_handler_init(&priv->hdl, 2);
+	v4l2_ctrl_new_std(&priv->hdl, &ov2640_ctrl_ops,
+			V4L2_CID_VFLIP, 0, 1, 1, 0);
+	v4l2_ctrl_new_std(&priv->hdl, &ov2640_ctrl_ops,
+			V4L2_CID_HFLIP, 0, 1, 1, 0);
+	priv->subdev.ctrl_handler = &priv->hdl;
+	if (priv->hdl.error) {
+		int err = priv->hdl.error;
 
-	icd->ops = &ov2640_ops;
+		kfree(priv);
+		return err;
+	}
 
 	ret = ov2640_video_probe(icd, client);
 	if (ret) {
-		icd->ops = NULL;
+		v4l2_ctrl_handler_free(&priv->hdl);
 		kfree(priv);
 	} else {
 		dev_info(&adapter->dev, "OV2640 Probed\n");
@@ -1130,9 +1094,9 @@ static int ov2640_probe(struct i2c_client *client,
 static int ov2640_remove(struct i2c_client *client)
 {
 	struct ov2640_priv       *priv = to_ov2640(client);
-	struct soc_camera_device *icd = client->dev.platform_data;
 
-	icd->ops = NULL;
+	v4l2_device_unregister_subdev(&priv->subdev);
+	v4l2_ctrl_handler_free(&priv->hdl);
 	kfree(priv);
 	return 0;
 }
-- 
1.7.2.5

