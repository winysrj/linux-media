Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.17.9]:64656 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755908Ab1G2K5D (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 29 Jul 2011 06:57:03 -0400
Received: from 6a.grange (6a.grange [192.168.1.11])
	by axis700.grange (Postfix) with ESMTPS id 6573718B03D
	for <linux-media@vger.kernel.org>; Fri, 29 Jul 2011 12:57:00 +0200 (CEST)
Received: from lyakh by 6a.grange with local (Exim 4.72)
	(envelope-from <g.liakhovetski@gmx.de>)
	id 1QmkkW-0007nS-3z
	for linux-media@vger.kernel.org; Fri, 29 Jul 2011 12:57:00 +0200
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: linux-media@vger.kernel.org
Subject: [PATCH 10/59] V4L: mt9t112: support the new mbus-config subdev ops
Date: Fri, 29 Jul 2011 12:56:10 +0200
Message-Id: <1311937019-29914-11-git-send-email-g.liakhovetski@gmx.de>
In-Reply-To: <1311937019-29914-1-git-send-email-g.liakhovetski@gmx.de>
References: <1311937019-29914-1-git-send-email-g.liakhovetski@gmx.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Extend the driver to also support [gs]_mbus_config() subdevice video
operations.

Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
---
 drivers/media/video/mt9t112.c |   81 +++++++++++++++++++++--------------------
 1 files changed, 42 insertions(+), 39 deletions(-)

diff --git a/drivers/media/video/mt9t112.c b/drivers/media/video/mt9t112.c
index d2e0a50..a3368d8 100644
--- a/drivers/media/video/mt9t112.c
+++ b/drivers/media/video/mt9t112.c
@@ -34,11 +34,7 @@
 /* #define EXT_CLOCK 24000000 */
 
 /************************************************************************
-
-
 			macro
-
-
 ************************************************************************/
 /*
  * frame size
@@ -80,11 +76,7 @@
 #define VAR8(id, offset) _VAR(id, offset, 0x8000)
 
 /************************************************************************
-
-
 			struct
-
-
 ************************************************************************/
 struct mt9t112_frame_size {
 	u16 width;
@@ -108,15 +100,12 @@ struct mt9t112_priv {
 	int				 model;
 	u32				 flags;
 /* for flags */
-#define INIT_DONE  (1<<0)
+#define INIT_DONE	(1 << 0)
+#define PCLK_RISING	(1 << 1)
 };
 
 /************************************************************************
-
-
 			supported format
-
-
 ************************************************************************/
 
 static const struct mt9t112_format mt9t112_cfmts[] = {
@@ -154,11 +143,7 @@ static const struct mt9t112_format mt9t112_cfmts[] = {
 };
 
 /************************************************************************
-
-
 			general function
-
-
 ************************************************************************/
 static struct mt9t112_priv *to_mt9t112(const struct i2c_client *client)
 {
@@ -758,15 +743,18 @@ static int mt9t112_init_camera(const struct i2c_client *client)
 }
 
 /************************************************************************
-
-
 			soc_camera_ops
-
-
 ************************************************************************/
 static int mt9t112_set_bus_param(struct soc_camera_device *icd,
 				 unsigned long	flags)
 {
+	struct soc_camera_link *icl = to_soc_camera_link(icd);
+	struct i2c_client *client = to_i2c_client(to_soc_camera_control(icd));
+	struct mt9t112_priv *priv = to_mt9t112(client);
+
+	if (soc_camera_apply_sensor_flags(icl, flags) & SOCAM_PCLK_SAMPLE_RISING)
+		priv->flags |= PCLK_RISING;
+
 	return 0;
 }
 
@@ -795,11 +783,7 @@ static struct soc_camera_ops mt9t112_ops = {
 };
 
 /************************************************************************
-
-
 			v4l2_subdev_core_ops
-
-
 ************************************************************************/
 static int mt9t112_g_chip_ident(struct v4l2_subdev *sd,
 				struct v4l2_dbg_chip_ident *id)
@@ -850,11 +834,7 @@ static struct v4l2_subdev_core_ops mt9t112_subdev_core_ops = {
 
 
 /************************************************************************
-
-
 			v4l2_subdev_video_ops
-
-
 ************************************************************************/
 static int mt9t112_s_stream(struct v4l2_subdev *sd, int enable)
 {
@@ -877,8 +857,7 @@ static int mt9t112_s_stream(struct v4l2_subdev *sd, int enable)
 	}
 
 	if (!(priv->flags & INIT_DONE)) {
-		u16 param = (MT9T112_FLAG_PCLK_RISING_EDGE &
-			     priv->info->flags) ? 0x0001 : 0x0000;
+		u16 param = PCLK_RISING & priv->flags ? 0x0001 : 0x0000;
 
 		ECHECKER(ret, mt9t112_init_camera(client));
 
@@ -1027,6 +1006,36 @@ static int mt9t112_enum_fmt(struct v4l2_subdev *sd, unsigned int index,
 	return 0;
 }
 
+static int mt9t112_g_mbus_config(struct v4l2_subdev *sd,
+				 struct v4l2_mbus_config *cfg)
+{
+	struct i2c_client *client = v4l2_get_subdevdata(sd);
+	struct soc_camera_device *icd = client->dev.platform_data;
+	struct soc_camera_link *icl = to_soc_camera_link(icd);
+
+	cfg->flags = V4L2_MBUS_MASTER | V4L2_MBUS_VSYNC_ACTIVE_HIGH |
+		V4L2_MBUS_HSYNC_ACTIVE_HIGH | V4L2_MBUS_DATA_ACTIVE_HIGH |
+		V4L2_MBUS_PCLK_SAMPLE_RISING | V4L2_MBUS_PCLK_SAMPLE_FALLING;
+	cfg->type = V4L2_MBUS_PARALLEL;
+	cfg->flags = soc_camera_apply_board_flags(icl, cfg);
+
+	return 0;
+}
+
+static int mt9t112_s_mbus_config(struct v4l2_subdev *sd,
+				 const struct v4l2_mbus_config *cfg)
+{
+	struct i2c_client *client = v4l2_get_subdevdata(sd);
+	struct soc_camera_device *icd = client->dev.platform_data;
+	struct soc_camera_link *icl = to_soc_camera_link(icd);
+	struct mt9t112_priv *priv = to_mt9t112(client);
+
+	if (soc_camera_apply_board_flags(icl, cfg) & V4L2_MBUS_PCLK_SAMPLE_RISING)
+		priv->flags |= PCLK_RISING;
+
+	return 0;
+}
+
 static struct v4l2_subdev_video_ops mt9t112_subdev_video_ops = {
 	.s_stream	= mt9t112_s_stream,
 	.g_mbus_fmt	= mt9t112_g_fmt,
@@ -1036,14 +1045,12 @@ static struct v4l2_subdev_video_ops mt9t112_subdev_video_ops = {
 	.g_crop		= mt9t112_g_crop,
 	.s_crop		= mt9t112_s_crop,
 	.enum_mbus_fmt	= mt9t112_enum_fmt,
+	.g_mbus_config	= mt9t112_g_mbus_config,
+	.s_mbus_config	= mt9t112_s_mbus_config,
 };
 
 /************************************************************************
-
-
 			i2c driver
-
-
 ************************************************************************/
 static struct v4l2_subdev_ops mt9t112_subdev_ops = {
 	.core	= &mt9t112_subdev_core_ops,
@@ -1147,11 +1154,7 @@ static struct i2c_driver mt9t112_i2c_driver = {
 };
 
 /************************************************************************
-
-
 			module function
-
-
 ************************************************************************/
 static int __init mt9t112_module_init(void)
 {
-- 
1.7.2.5

