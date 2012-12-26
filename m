Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.187]:61928 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752458Ab2LZRgC (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 26 Dec 2012 12:36:02 -0500
Received: from 6a.grange (6a.grange [192.168.1.11])
	by axis700.grange (Postfix) with ESMTPS id 4E13540B9D
	for <linux-media@vger.kernel.org>; Wed, 26 Dec 2012 18:35:59 +0100 (CET)
Received: from lyakh by 6a.grange with local (Exim 4.72)
	(envelope-from <g.liakhovetski@gmx.de>)
	id 1Tnuta-0001cR-UH
	for linux-media@vger.kernel.org; Wed, 26 Dec 2012 18:35:58 +0100
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: linux-media@vger.kernel.org
Subject: [PATCH 4/6] media: soc-camera: split struct soc_camera_link into host and subdevice parts
Date: Wed, 26 Dec 2012 18:35:56 +0100
Message-Id: <1356543358-6180-5-git-send-email-g.liakhovetski@gmx.de>
In-Reply-To: <1356543358-6180-1-git-send-email-g.liakhovetski@gmx.de>
References: <1356543358-6180-1-git-send-email-g.liakhovetski@gmx.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

struct soc_camera_link currently contains fields, used both by sensor and
bridge drivers. To make subdevice driver re-use simpler, split it into a
host and a subdevice parts.

Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
---
 drivers/media/i2c/soc_camera/imx074.c              |   14 ++--
 drivers/media/i2c/soc_camera/mt9m001.c             |   38 ++++----
 drivers/media/i2c/soc_camera/mt9m111.c             |   21 ++--
 drivers/media/i2c/soc_camera/mt9t031.c             |   22 ++--
 drivers/media/i2c/soc_camera/mt9t112.c             |   18 ++--
 drivers/media/i2c/soc_camera/mt9v022.c             |   36 ++++----
 drivers/media/i2c/soc_camera/ov2640.c              |   12 +-
 drivers/media/i2c/soc_camera/ov5642.c              |   16 ++--
 drivers/media/i2c/soc_camera/ov6650.c              |   16 ++--
 drivers/media/i2c/soc_camera/ov772x.c              |   14 ++--
 drivers/media/i2c/soc_camera/ov9640.c              |   12 +-
 drivers/media/i2c/soc_camera/ov9740.c              |   14 ++--
 drivers/media/i2c/soc_camera/rj54n1cb0c.c          |   24 +++---
 drivers/media/i2c/soc_camera/tw9910.c              |   18 ++--
 drivers/media/platform/soc_camera/soc_camera.c     |   97 ++++++++++----------
 .../platform/soc_camera/soc_camera_platform.c      |    2 +-
 include/media/soc_camera.h                         |   93 ++++++++++++++++---
 include/media/soc_camera_platform.h                |   10 ++-
 18 files changed, 273 insertions(+), 204 deletions(-)

diff --git a/drivers/media/i2c/soc_camera/imx074.c b/drivers/media/i2c/soc_camera/imx074.c
index f8534ee..1c06571 100644
--- a/drivers/media/i2c/soc_camera/imx074.c
+++ b/drivers/media/i2c/soc_camera/imx074.c
@@ -271,9 +271,9 @@ static int imx074_g_chip_ident(struct v4l2_subdev *sd,
 static int imx074_s_power(struct v4l2_subdev *sd, int on)
 {
 	struct i2c_client *client = v4l2_get_subdevdata(sd);
-	struct soc_camera_link *icl = soc_camera_i2c_to_link(client);
+	struct soc_camera_subdev_desc *ssdd = soc_camera_i2c_to_desc(client);
 
-	return soc_camera_set_power(&client->dev, icl, on);
+	return soc_camera_set_power(&client->dev, ssdd, on);
 }
 
 static int imx074_g_mbus_config(struct v4l2_subdev *sd,
@@ -430,10 +430,10 @@ static int imx074_probe(struct i2c_client *client,
 {
 	struct imx074 *priv;
 	struct i2c_adapter *adapter = to_i2c_adapter(client->dev.parent);
-	struct soc_camera_link *icl = soc_camera_i2c_to_link(client);
+	struct soc_camera_subdev_desc *ssdd = soc_camera_i2c_to_desc(client);
 	int ret;
 
-	if (!icl) {
+	if (!ssdd) {
 		dev_err(&client->dev, "IMX074: missing platform data!\n");
 		return -EINVAL;
 	}
@@ -464,10 +464,10 @@ static int imx074_probe(struct i2c_client *client,
 static int imx074_remove(struct i2c_client *client)
 {
 	struct imx074 *priv = to_imx074(client);
-	struct soc_camera_link *icl = soc_camera_i2c_to_link(client);
+	struct soc_camera_subdev_desc *ssdd = soc_camera_i2c_to_desc(client);
 
-	if (icl->free_bus)
-		icl->free_bus(icl);
+	if (ssdd->free_bus)
+		ssdd->free_bus(ssdd);
 	kfree(priv);
 
 	return 0;
diff --git a/drivers/media/i2c/soc_camera/mt9m001.c b/drivers/media/i2c/soc_camera/mt9m001.c
index 19f8a07..9ae7066 100644
--- a/drivers/media/i2c/soc_camera/mt9m001.c
+++ b/drivers/media/i2c/soc_camera/mt9m001.c
@@ -23,7 +23,7 @@
 /*
  * mt9m001 i2c address 0x5d
  * The platform has to define struct i2c_board_info objects and link to them
- * from struct soc_camera_link
+ * from struct soc_camera_host_desc
  */
 
 /* mt9m001 selected register addresses */
@@ -380,9 +380,9 @@ static int mt9m001_s_register(struct v4l2_subdev *sd,
 static int mt9m001_s_power(struct v4l2_subdev *sd, int on)
 {
 	struct i2c_client *client = v4l2_get_subdevdata(sd);
-	struct soc_camera_link *icl = soc_camera_i2c_to_link(client);
+	struct soc_camera_subdev_desc *ssdd = soc_camera_i2c_to_desc(client);
 
-	return soc_camera_set_power(&client->dev, icl, on);
+	return soc_camera_set_power(&client->dev, ssdd, on);
 }
 
 static int mt9m001_g_volatile_ctrl(struct v4l2_ctrl *ctrl)
@@ -482,7 +482,7 @@ static int mt9m001_s_ctrl(struct v4l2_ctrl *ctrl)
  * Interface active, can use i2c. If it fails, it can indeed mean, that
  * this wasn't our capture interface, so, we wait for the right one
  */
-static int mt9m001_video_probe(struct soc_camera_link *icl,
+static int mt9m001_video_probe(struct soc_camera_subdev_desc *ssdd,
 			       struct i2c_client *client)
 {
 	struct mt9m001 *mt9m001 = to_mt9m001(client);
@@ -526,8 +526,8 @@ static int mt9m001_video_probe(struct soc_camera_link *icl,
 	 * The platform may support different bus widths due to
 	 * different routing of the data lines.
 	 */
-	if (icl->query_bus_param)
-		flags = icl->query_bus_param(icl);
+	if (ssdd->query_bus_param)
+		flags = ssdd->query_bus_param(ssdd);
 	else
 		flags = SOCAM_DATAWIDTH_10;
 
@@ -558,10 +558,10 @@ done:
 	return ret;
 }
 
-static void mt9m001_video_remove(struct soc_camera_link *icl)
+static void mt9m001_video_remove(struct soc_camera_subdev_desc *ssdd)
 {
-	if (icl->free_bus)
-		icl->free_bus(icl);
+	if (ssdd->free_bus)
+		ssdd->free_bus(ssdd);
 }
 
 static int mt9m001_g_skip_top_lines(struct v4l2_subdev *sd, u32 *lines)
@@ -605,14 +605,14 @@ static int mt9m001_g_mbus_config(struct v4l2_subdev *sd,
 				struct v4l2_mbus_config *cfg)
 {
 	struct i2c_client *client = v4l2_get_subdevdata(sd);
-	struct soc_camera_link *icl = soc_camera_i2c_to_link(client);
+	struct soc_camera_subdev_desc *ssdd = soc_camera_i2c_to_desc(client);
 
 	/* MT9M001 has all capture_format parameters fixed */
 	cfg->flags = V4L2_MBUS_PCLK_SAMPLE_FALLING |
 		V4L2_MBUS_HSYNC_ACTIVE_HIGH | V4L2_MBUS_VSYNC_ACTIVE_HIGH |
 		V4L2_MBUS_DATA_ACTIVE_HIGH | V4L2_MBUS_MASTER;
 	cfg->type = V4L2_MBUS_PARALLEL;
-	cfg->flags = soc_camera_apply_board_flags(icl, cfg);
+	cfg->flags = soc_camera_apply_board_flags(ssdd, cfg);
 
 	return 0;
 }
@@ -621,12 +621,12 @@ static int mt9m001_s_mbus_config(struct v4l2_subdev *sd,
 				const struct v4l2_mbus_config *cfg)
 {
 	const struct i2c_client *client = v4l2_get_subdevdata(sd);
-	struct soc_camera_link *icl = soc_camera_i2c_to_link(client);
+	struct soc_camera_subdev_desc *ssdd = soc_camera_i2c_to_desc(client);
 	struct mt9m001 *mt9m001 = to_mt9m001(client);
 	unsigned int bps = soc_mbus_get_fmtdesc(mt9m001->fmt->code)->bits_per_sample;
 
-	if (icl->set_bus_param)
-		return icl->set_bus_param(icl, 1 << (bps - 1));
+	if (ssdd->set_bus_param)
+		return ssdd->set_bus_param(ssdd, 1 << (bps - 1));
 
 	/*
 	 * Without board specific bus width settings we only support the
@@ -663,10 +663,10 @@ static int mt9m001_probe(struct i2c_client *client,
 {
 	struct mt9m001 *mt9m001;
 	struct i2c_adapter *adapter = to_i2c_adapter(client->dev.parent);
-	struct soc_camera_link *icl = soc_camera_i2c_to_link(client);
+	struct soc_camera_subdev_desc *ssdd = soc_camera_i2c_to_desc(client);
 	int ret;
 
-	if (!icl) {
+	if (!ssdd) {
 		dev_err(&client->dev, "MT9M001 driver needs platform data\n");
 		return -EINVAL;
 	}
@@ -713,7 +713,7 @@ static int mt9m001_probe(struct i2c_client *client,
 	mt9m001->rect.width	= MT9M001_MAX_WIDTH;
 	mt9m001->rect.height	= MT9M001_MAX_HEIGHT;
 
-	ret = mt9m001_video_probe(icl, client);
+	ret = mt9m001_video_probe(ssdd, client);
 	if (ret) {
 		v4l2_ctrl_handler_free(&mt9m001->hdl);
 		kfree(mt9m001);
@@ -725,11 +725,11 @@ static int mt9m001_probe(struct i2c_client *client,
 static int mt9m001_remove(struct i2c_client *client)
 {
 	struct mt9m001 *mt9m001 = to_mt9m001(client);
-	struct soc_camera_link *icl = soc_camera_i2c_to_link(client);
+	struct soc_camera_subdev_desc *ssdd = soc_camera_i2c_to_desc(client);
 
 	v4l2_device_unregister_subdev(&mt9m001->subdev);
 	v4l2_ctrl_handler_free(&mt9m001->hdl);
-	mt9m001_video_remove(icl);
+	mt9m001_video_remove(ssdd);
 	kfree(mt9m001);
 
 	return 0;
diff --git a/drivers/media/i2c/soc_camera/mt9m111.c b/drivers/media/i2c/soc_camera/mt9m111.c
index 62fd94a..7851166 100644
--- a/drivers/media/i2c/soc_camera/mt9m111.c
+++ b/drivers/media/i2c/soc_camera/mt9m111.c
@@ -24,7 +24,8 @@
 /*
  * MT9M111, MT9M112 and MT9M131:
  * i2c address is 0x48 or 0x5d (depending on SADDR pin)
- * The platform has to define i2c_board_info and call i2c_register_board_info()
+ * The platform has to define struct i2c_board_info objects and link to them
+ * from struct soc_camera_host_desc
  */
 
 /*
@@ -799,17 +800,17 @@ static int mt9m111_init(struct mt9m111 *mt9m111)
 static int mt9m111_power_on(struct mt9m111 *mt9m111)
 {
 	struct i2c_client *client = v4l2_get_subdevdata(&mt9m111->subdev);
-	struct soc_camera_link *icl = soc_camera_i2c_to_link(client);
+	struct soc_camera_subdev_desc *ssdd = soc_camera_i2c_to_desc(client);
 	int ret;
 
-	ret = soc_camera_power_on(&client->dev, icl);
+	ret = soc_camera_power_on(&client->dev, ssdd);
 	if (ret < 0)
 		return ret;
 
 	ret = mt9m111_resume(mt9m111);
 	if (ret < 0) {
 		dev_err(&client->dev, "Failed to resume the sensor: %d\n", ret);
-		soc_camera_power_off(&client->dev, icl);
+		soc_camera_power_off(&client->dev, ssdd);
 	}
 
 	return ret;
@@ -818,10 +819,10 @@ static int mt9m111_power_on(struct mt9m111 *mt9m111)
 static void mt9m111_power_off(struct mt9m111 *mt9m111)
 {
 	struct i2c_client *client = v4l2_get_subdevdata(&mt9m111->subdev);
-	struct soc_camera_link *icl = soc_camera_i2c_to_link(client);
+	struct soc_camera_subdev_desc *ssdd = soc_camera_i2c_to_desc(client);
 
 	mt9m111_suspend(mt9m111);
-	soc_camera_power_off(&client->dev, icl);
+	soc_camera_power_off(&client->dev, ssdd);
 }
 
 static int mt9m111_s_power(struct v4l2_subdev *sd, int on)
@@ -879,13 +880,13 @@ static int mt9m111_g_mbus_config(struct v4l2_subdev *sd,
 				struct v4l2_mbus_config *cfg)
 {
 	struct i2c_client *client = v4l2_get_subdevdata(sd);
-	struct soc_camera_link *icl = soc_camera_i2c_to_link(client);
+	struct soc_camera_subdev_desc *ssdd = soc_camera_i2c_to_desc(client);
 
 	cfg->flags = V4L2_MBUS_MASTER | V4L2_MBUS_PCLK_SAMPLE_RISING |
 		V4L2_MBUS_HSYNC_ACTIVE_HIGH | V4L2_MBUS_VSYNC_ACTIVE_HIGH |
 		V4L2_MBUS_DATA_ACTIVE_HIGH;
 	cfg->type = V4L2_MBUS_PARALLEL;
-	cfg->flags = soc_camera_apply_board_flags(icl, cfg);
+	cfg->flags = soc_camera_apply_board_flags(ssdd, cfg);
 
 	return 0;
 }
@@ -956,10 +957,10 @@ static int mt9m111_probe(struct i2c_client *client,
 {
 	struct mt9m111 *mt9m111;
 	struct i2c_adapter *adapter = to_i2c_adapter(client->dev.parent);
-	struct soc_camera_link *icl = soc_camera_i2c_to_link(client);
+	struct soc_camera_subdev_desc *ssdd = soc_camera_i2c_to_desc(client);
 	int ret;
 
-	if (!icl) {
+	if (!ssdd) {
 		dev_err(&client->dev, "mt9m111: driver needs platform data\n");
 		return -EINVAL;
 	}
diff --git a/drivers/media/i2c/soc_camera/mt9t031.c b/drivers/media/i2c/soc_camera/mt9t031.c
index 40800b1..9ca6d65 100644
--- a/drivers/media/i2c/soc_camera/mt9t031.c
+++ b/drivers/media/i2c/soc_camera/mt9t031.c
@@ -31,8 +31,8 @@
 
 /*
  * mt9t031 i2c address 0x5d
- * The platform has to define i2c_board_info and link to it from
- * struct soc_camera_link
+ * The platform has to define struct i2c_board_info objects and link to them
+ * from struct soc_camera_host_desc
  */
 
 /* mt9t031 selected register addresses */
@@ -608,18 +608,18 @@ static struct device_type mt9t031_dev_type = {
 static int mt9t031_s_power(struct v4l2_subdev *sd, int on)
 {
 	struct i2c_client *client = v4l2_get_subdevdata(sd);
-	struct soc_camera_link *icl = soc_camera_i2c_to_link(client);
+	struct soc_camera_subdev_desc *ssdd = soc_camera_i2c_to_desc(client);
 	struct video_device *vdev = soc_camera_i2c_to_vdev(client);
 	int ret;
 
 	if (on) {
-		ret = soc_camera_power_on(&client->dev, icl);
+		ret = soc_camera_power_on(&client->dev, ssdd);
 		if (ret < 0)
 			return ret;
 		vdev->dev.type = &mt9t031_dev_type;
 	} else {
 		vdev->dev.type = NULL;
-		soc_camera_power_off(&client->dev, icl);
+		soc_camera_power_off(&client->dev, ssdd);
 	}
 
 	return 0;
@@ -707,13 +707,13 @@ static int mt9t031_g_mbus_config(struct v4l2_subdev *sd,
 				struct v4l2_mbus_config *cfg)
 {
 	struct i2c_client *client = v4l2_get_subdevdata(sd);
-	struct soc_camera_link *icl = soc_camera_i2c_to_link(client);
+	struct soc_camera_subdev_desc *ssdd = soc_camera_i2c_to_desc(client);
 
 	cfg->flags = V4L2_MBUS_MASTER | V4L2_MBUS_PCLK_SAMPLE_RISING |
 		V4L2_MBUS_PCLK_SAMPLE_FALLING | V4L2_MBUS_HSYNC_ACTIVE_HIGH |
 		V4L2_MBUS_VSYNC_ACTIVE_HIGH | V4L2_MBUS_DATA_ACTIVE_HIGH;
 	cfg->type = V4L2_MBUS_PARALLEL;
-	cfg->flags = soc_camera_apply_board_flags(icl, cfg);
+	cfg->flags = soc_camera_apply_board_flags(ssdd, cfg);
 
 	return 0;
 }
@@ -722,9 +722,9 @@ static int mt9t031_s_mbus_config(struct v4l2_subdev *sd,
 				const struct v4l2_mbus_config *cfg)
 {
 	struct i2c_client *client = v4l2_get_subdevdata(sd);
-	struct soc_camera_link *icl = soc_camera_i2c_to_link(client);
+	struct soc_camera_subdev_desc *ssdd = soc_camera_i2c_to_desc(client);
 
-	if (soc_camera_apply_board_flags(icl, cfg) &
+	if (soc_camera_apply_board_flags(ssdd, cfg) &
 	    V4L2_MBUS_PCLK_SAMPLE_FALLING)
 		return reg_clear(client, MT9T031_PIXEL_CLOCK_CONTROL, 0x8000);
 	else
@@ -758,11 +758,11 @@ static int mt9t031_probe(struct i2c_client *client,
 			 const struct i2c_device_id *did)
 {
 	struct mt9t031 *mt9t031;
-	struct soc_camera_link *icl = soc_camera_i2c_to_link(client);
+	struct soc_camera_subdev_desc *ssdd = soc_camera_i2c_to_desc(client);
 	struct i2c_adapter *adapter = to_i2c_adapter(client->dev.parent);
 	int ret;
 
-	if (!icl) {
+	if (!ssdd) {
 		dev_err(&client->dev, "MT9T031 driver needs platform data\n");
 		return -EINVAL;
 	}
diff --git a/drivers/media/i2c/soc_camera/mt9t112.c b/drivers/media/i2c/soc_camera/mt9t112.c
index de7cd83..92bb65d 100644
--- a/drivers/media/i2c/soc_camera/mt9t112.c
+++ b/drivers/media/i2c/soc_camera/mt9t112.c
@@ -779,9 +779,9 @@ static int mt9t112_s_register(struct v4l2_subdev *sd,
 static int mt9t112_s_power(struct v4l2_subdev *sd, int on)
 {
 	struct i2c_client *client = v4l2_get_subdevdata(sd);
-	struct soc_camera_link *icl = soc_camera_i2c_to_link(client);
+	struct soc_camera_subdev_desc *ssdd = soc_camera_i2c_to_desc(client);
 
-	return soc_camera_set_power(&client->dev, icl, on);
+	return soc_camera_set_power(&client->dev, ssdd, on);
 }
 
 static struct v4l2_subdev_core_ops mt9t112_subdev_core_ops = {
@@ -991,13 +991,13 @@ static int mt9t112_g_mbus_config(struct v4l2_subdev *sd,
 				 struct v4l2_mbus_config *cfg)
 {
 	struct i2c_client *client = v4l2_get_subdevdata(sd);
-	struct soc_camera_link *icl = soc_camera_i2c_to_link(client);
+	struct soc_camera_subdev_desc *ssdd = soc_camera_i2c_to_desc(client);
 
 	cfg->flags = V4L2_MBUS_MASTER | V4L2_MBUS_VSYNC_ACTIVE_HIGH |
 		V4L2_MBUS_HSYNC_ACTIVE_HIGH | V4L2_MBUS_DATA_ACTIVE_HIGH |
 		V4L2_MBUS_PCLK_SAMPLE_RISING | V4L2_MBUS_PCLK_SAMPLE_FALLING;
 	cfg->type = V4L2_MBUS_PARALLEL;
-	cfg->flags = soc_camera_apply_board_flags(icl, cfg);
+	cfg->flags = soc_camera_apply_board_flags(ssdd, cfg);
 
 	return 0;
 }
@@ -1006,10 +1006,10 @@ static int mt9t112_s_mbus_config(struct v4l2_subdev *sd,
 				 const struct v4l2_mbus_config *cfg)
 {
 	struct i2c_client *client = v4l2_get_subdevdata(sd);
-	struct soc_camera_link *icl = soc_camera_i2c_to_link(client);
+	struct soc_camera_subdev_desc *ssdd = soc_camera_i2c_to_desc(client);
 	struct mt9t112_priv *priv = to_mt9t112(client);
 
-	if (soc_camera_apply_board_flags(icl, cfg) & V4L2_MBUS_PCLK_SAMPLE_RISING)
+	if (soc_camera_apply_board_flags(ssdd, cfg) & V4L2_MBUS_PCLK_SAMPLE_RISING)
 		priv->flags |= PCLK_RISING;
 
 	return 0;
@@ -1078,7 +1078,7 @@ static int mt9t112_probe(struct i2c_client *client,
 			 const struct i2c_device_id *did)
 {
 	struct mt9t112_priv *priv;
-	struct soc_camera_link *icl = soc_camera_i2c_to_link(client);
+	struct soc_camera_subdev_desc *ssdd = soc_camera_i2c_to_desc(client);
 	struct v4l2_rect rect = {
 		.width = VGA_WIDTH,
 		.height = VGA_HEIGHT,
@@ -1087,7 +1087,7 @@ static int mt9t112_probe(struct i2c_client *client,
 	};
 	int ret;
 
-	if (!icl || !icl->priv) {
+	if (!ssdd || !ssdd->drv_priv) {
 		dev_err(&client->dev, "mt9t112: missing platform data!\n");
 		return -EINVAL;
 	}
@@ -1096,7 +1096,7 @@ static int mt9t112_probe(struct i2c_client *client,
 	if (!priv)
 		return -ENOMEM;
 
-	priv->info = icl->priv;
+	priv->info = ssdd->drv_priv;
 
 	v4l2_i2c_subdev_init(&priv->subdev, client, &mt9t112_subdev_ops);
 
diff --git a/drivers/media/i2c/soc_camera/mt9v022.c b/drivers/media/i2c/soc_camera/mt9v022.c
index 7509802..33fb5c3 100644
--- a/drivers/media/i2c/soc_camera/mt9v022.c
+++ b/drivers/media/i2c/soc_camera/mt9v022.c
@@ -25,7 +25,7 @@
 /*
  * mt9v022 i2c address 0x48, 0x4c, 0x58, 0x5c
  * The platform has to define struct i2c_board_info objects and link to them
- * from struct soc_camera_link
+ * from struct soc_camera_host_desc
  */
 
 static char *sensor_type;
@@ -508,9 +508,9 @@ static int mt9v022_s_register(struct v4l2_subdev *sd,
 static int mt9v022_s_power(struct v4l2_subdev *sd, int on)
 {
 	struct i2c_client *client = v4l2_get_subdevdata(sd);
-	struct soc_camera_link *icl = soc_camera_i2c_to_link(client);
+	struct soc_camera_subdev_desc *ssdd = soc_camera_i2c_to_desc(client);
 
-	return soc_camera_set_power(&client->dev, icl, on);
+	return soc_camera_set_power(&client->dev, ssdd, on);
 }
 
 static int mt9v022_g_volatile_ctrl(struct v4l2_ctrl *ctrl)
@@ -655,7 +655,7 @@ static int mt9v022_s_ctrl(struct v4l2_ctrl *ctrl)
 static int mt9v022_video_probe(struct i2c_client *client)
 {
 	struct mt9v022 *mt9v022 = to_mt9v022(client);
-	struct soc_camera_link *icl = soc_camera_i2c_to_link(client);
+	struct soc_camera_subdev_desc *ssdd = soc_camera_i2c_to_desc(client);
 	s32 data;
 	int ret;
 	unsigned long flags;
@@ -715,8 +715,8 @@ static int mt9v022_video_probe(struct i2c_client *client)
 	 * The platform may support different bus widths due to
 	 * different routing of the data lines.
 	 */
-	if (icl->query_bus_param)
-		flags = icl->query_bus_param(icl);
+	if (ssdd->query_bus_param)
+		flags = ssdd->query_bus_param(ssdd);
 	else
 		flags = SOCAM_DATAWIDTH_10;
 
@@ -784,7 +784,7 @@ static int mt9v022_g_mbus_config(struct v4l2_subdev *sd,
 				struct v4l2_mbus_config *cfg)
 {
 	struct i2c_client *client = v4l2_get_subdevdata(sd);
-	struct soc_camera_link *icl = soc_camera_i2c_to_link(client);
+	struct soc_camera_subdev_desc *ssdd = soc_camera_i2c_to_desc(client);
 
 	cfg->flags = V4L2_MBUS_MASTER | V4L2_MBUS_SLAVE |
 		V4L2_MBUS_PCLK_SAMPLE_RISING | V4L2_MBUS_PCLK_SAMPLE_FALLING |
@@ -792,7 +792,7 @@ static int mt9v022_g_mbus_config(struct v4l2_subdev *sd,
 		V4L2_MBUS_VSYNC_ACTIVE_HIGH | V4L2_MBUS_VSYNC_ACTIVE_LOW |
 		V4L2_MBUS_DATA_ACTIVE_HIGH;
 	cfg->type = V4L2_MBUS_PARALLEL;
-	cfg->flags = soc_camera_apply_board_flags(icl, cfg);
+	cfg->flags = soc_camera_apply_board_flags(ssdd, cfg);
 
 	return 0;
 }
@@ -801,15 +801,15 @@ static int mt9v022_s_mbus_config(struct v4l2_subdev *sd,
 				 const struct v4l2_mbus_config *cfg)
 {
 	struct i2c_client *client = v4l2_get_subdevdata(sd);
-	struct soc_camera_link *icl = soc_camera_i2c_to_link(client);
+	struct soc_camera_subdev_desc *ssdd = soc_camera_i2c_to_desc(client);
 	struct mt9v022 *mt9v022 = to_mt9v022(client);
-	unsigned long flags = soc_camera_apply_board_flags(icl, cfg);
+	unsigned long flags = soc_camera_apply_board_flags(ssdd, cfg);
 	unsigned int bps = soc_mbus_get_fmtdesc(mt9v022->fmt->code)->bits_per_sample;
 	int ret;
 	u16 pixclk = 0;
 
-	if (icl->set_bus_param) {
-		ret = icl->set_bus_param(icl, 1 << (bps - 1));
+	if (ssdd->set_bus_param) {
+		ret = ssdd->set_bus_param(ssdd, 1 << (bps - 1));
 		if (ret)
 			return ret;
 	} else if (bps != 10) {
@@ -873,12 +873,12 @@ static int mt9v022_probe(struct i2c_client *client,
 			 const struct i2c_device_id *did)
 {
 	struct mt9v022 *mt9v022;
-	struct soc_camera_link *icl = soc_camera_i2c_to_link(client);
+	struct soc_camera_subdev_desc *ssdd = soc_camera_i2c_to_desc(client);
 	struct i2c_adapter *adapter = to_i2c_adapter(client->dev.parent);
 	struct mt9v022_platform_data *pdata;
 	int ret;
 
-	if (!icl) {
+	if (!ssdd) {
 		dev_err(&client->dev, "MT9V022 driver needs platform data\n");
 		return -EINVAL;
 	}
@@ -893,7 +893,7 @@ static int mt9v022_probe(struct i2c_client *client,
 	if (!mt9v022)
 		return -ENOMEM;
 
-	pdata = icl->priv;
+	pdata = ssdd->drv_priv;
 	v4l2_i2c_subdev_init(&mt9v022->subdev, client, &mt9v022_subdev_ops);
 	v4l2_ctrl_handler_init(&mt9v022->hdl, 6);
 	v4l2_ctrl_new_std(&mt9v022->hdl, &mt9v022_ctrl_ops,
@@ -961,11 +961,11 @@ static int mt9v022_probe(struct i2c_client *client,
 static int mt9v022_remove(struct i2c_client *client)
 {
 	struct mt9v022 *mt9v022 = to_mt9v022(client);
-	struct soc_camera_link *icl = soc_camera_i2c_to_link(client);
+	struct soc_camera_subdev_desc *ssdd = soc_camera_i2c_to_desc(client);
 
 	v4l2_device_unregister_subdev(&mt9v022->subdev);
-	if (icl->free_bus)
-		icl->free_bus(icl);
+	if (ssdd->free_bus)
+		ssdd->free_bus(ssdd);
 	v4l2_ctrl_handler_free(&mt9v022->hdl);
 	kfree(mt9v022);
 
diff --git a/drivers/media/i2c/soc_camera/ov2640.c b/drivers/media/i2c/soc_camera/ov2640.c
index 66698a8..c57a509 100644
--- a/drivers/media/i2c/soc_camera/ov2640.c
+++ b/drivers/media/i2c/soc_camera/ov2640.c
@@ -771,9 +771,9 @@ static int ov2640_s_register(struct v4l2_subdev *sd,
 static int ov2640_s_power(struct v4l2_subdev *sd, int on)
 {
 	struct i2c_client *client = v4l2_get_subdevdata(sd);
-	struct soc_camera_link *icl = soc_camera_i2c_to_link(client);
+	struct soc_camera_subdev_desc *ssdd = soc_camera_i2c_to_desc(client);
 
-	return soc_camera_set_power(&client->dev, icl, on);
+	return soc_camera_set_power(&client->dev, ssdd, on);
 }
 
 /* Select the nearest higher resolution for capture */
@@ -1046,13 +1046,13 @@ static int ov2640_g_mbus_config(struct v4l2_subdev *sd,
 				struct v4l2_mbus_config *cfg)
 {
 	struct i2c_client *client = v4l2_get_subdevdata(sd);
-	struct soc_camera_link *icl = soc_camera_i2c_to_link(client);
+	struct soc_camera_subdev_desc *ssdd = soc_camera_i2c_to_desc(client);
 
 	cfg->flags = V4L2_MBUS_PCLK_SAMPLE_RISING | V4L2_MBUS_MASTER |
 		V4L2_MBUS_VSYNC_ACTIVE_HIGH | V4L2_MBUS_HSYNC_ACTIVE_HIGH |
 		V4L2_MBUS_DATA_ACTIVE_HIGH;
 	cfg->type = V4L2_MBUS_PARALLEL;
-	cfg->flags = soc_camera_apply_board_flags(icl, cfg);
+	cfg->flags = soc_camera_apply_board_flags(ssdd, cfg);
 
 	return 0;
 }
@@ -1080,11 +1080,11 @@ static int ov2640_probe(struct i2c_client *client,
 			const struct i2c_device_id *did)
 {
 	struct ov2640_priv	*priv;
-	struct soc_camera_link	*icl = soc_camera_i2c_to_link(client);
+	struct soc_camera_subdev_desc *ssdd = soc_camera_i2c_to_desc(client);
 	struct i2c_adapter	*adapter = to_i2c_adapter(client->dev.parent);
 	int			ret;
 
-	if (!icl) {
+	if (!ssdd) {
 		dev_err(&adapter->dev,
 			"OV2640: Missing platform_data for driver\n");
 		return -EINVAL;
diff --git a/drivers/media/i2c/soc_camera/ov5642.c b/drivers/media/i2c/soc_camera/ov5642.c
index 8577e0c..b892d01 100644
--- a/drivers/media/i2c/soc_camera/ov5642.c
+++ b/drivers/media/i2c/soc_camera/ov5642.c
@@ -934,13 +934,13 @@ static int ov5642_g_mbus_config(struct v4l2_subdev *sd,
 static int ov5642_s_power(struct v4l2_subdev *sd, int on)
 {
 	struct i2c_client *client = v4l2_get_subdevdata(sd);
-	struct soc_camera_link *icl = soc_camera_i2c_to_link(client);
+	struct soc_camera_subdev_desc *ssdd = soc_camera_i2c_to_desc(client);
 	int ret;
 
 	if (!on)
-		return soc_camera_power_off(&client->dev, icl);
+		return soc_camera_power_off(&client->dev, ssdd);
 
-	ret = soc_camera_power_on(&client->dev, icl);
+	ret = soc_camera_power_on(&client->dev, ssdd);
 	if (ret < 0)
 		return ret;
 
@@ -1020,10 +1020,10 @@ static int ov5642_probe(struct i2c_client *client,
 			const struct i2c_device_id *did)
 {
 	struct ov5642 *priv;
-	struct soc_camera_link *icl = soc_camera_i2c_to_link(client);
+	struct soc_camera_subdev_desc *ssdd = soc_camera_i2c_to_desc(client);
 	int ret;
 
-	if (!icl) {
+	if (!ssdd) {
 		dev_err(&client->dev, "OV5642: missing platform data!\n");
 		return -EINVAL;
 	}
@@ -1057,10 +1057,10 @@ error:
 static int ov5642_remove(struct i2c_client *client)
 {
 	struct ov5642 *priv = to_ov5642(client);
-	struct soc_camera_link *icl = soc_camera_i2c_to_link(client);
+	struct soc_camera_subdev_desc *ssdd = soc_camera_i2c_to_desc(client);
 
-	if (icl->free_bus)
-		icl->free_bus(icl);
+	if (ssdd->free_bus)
+		ssdd->free_bus(ssdd);
 	kfree(priv);
 
 	return 0;
diff --git a/drivers/media/i2c/soc_camera/ov6650.c b/drivers/media/i2c/soc_camera/ov6650.c
index e87feb0..1ae8b8d 100644
--- a/drivers/media/i2c/soc_camera/ov6650.c
+++ b/drivers/media/i2c/soc_camera/ov6650.c
@@ -435,9 +435,9 @@ static int ov6650_set_register(struct v4l2_subdev *sd,
 static int ov6650_s_power(struct v4l2_subdev *sd, int on)
 {
 	struct i2c_client *client = v4l2_get_subdevdata(sd);
-	struct soc_camera_link *icl = soc_camera_i2c_to_link(client);
+	struct soc_camera_subdev_desc *ssdd = soc_camera_i2c_to_desc(client);
 
-	return soc_camera_set_power(&client->dev, icl, on);
+	return soc_camera_set_power(&client->dev, ssdd, on);
 }
 
 static int ov6650_g_crop(struct v4l2_subdev *sd, struct v4l2_crop *a)
@@ -892,7 +892,7 @@ static int ov6650_g_mbus_config(struct v4l2_subdev *sd,
 				struct v4l2_mbus_config *cfg)
 {
 	struct i2c_client *client = v4l2_get_subdevdata(sd);
-	struct soc_camera_link *icl = soc_camera_i2c_to_link(client);
+	struct soc_camera_subdev_desc *ssdd = soc_camera_i2c_to_desc(client);
 
 	cfg->flags = V4L2_MBUS_MASTER |
 		V4L2_MBUS_PCLK_SAMPLE_RISING | V4L2_MBUS_PCLK_SAMPLE_FALLING |
@@ -900,7 +900,7 @@ static int ov6650_g_mbus_config(struct v4l2_subdev *sd,
 		V4L2_MBUS_VSYNC_ACTIVE_HIGH | V4L2_MBUS_VSYNC_ACTIVE_LOW |
 		V4L2_MBUS_DATA_ACTIVE_HIGH;
 	cfg->type = V4L2_MBUS_PARALLEL;
-	cfg->flags = soc_camera_apply_board_flags(icl, cfg);
+	cfg->flags = soc_camera_apply_board_flags(ssdd, cfg);
 
 	return 0;
 }
@@ -910,8 +910,8 @@ static int ov6650_s_mbus_config(struct v4l2_subdev *sd,
 				const struct v4l2_mbus_config *cfg)
 {
 	struct i2c_client *client = v4l2_get_subdevdata(sd);
-	struct soc_camera_link *icl = soc_camera_i2c_to_link(client);
-	unsigned long flags = soc_camera_apply_board_flags(icl, cfg);
+	struct soc_camera_subdev_desc *ssdd = soc_camera_i2c_to_desc(client);
+	unsigned long flags = soc_camera_apply_board_flags(ssdd, cfg);
 	int ret;
 
 	if (flags & V4L2_MBUS_PCLK_SAMPLE_RISING)
@@ -963,10 +963,10 @@ static int ov6650_probe(struct i2c_client *client,
 			const struct i2c_device_id *did)
 {
 	struct ov6650 *priv;
-	struct soc_camera_link *icl = soc_camera_i2c_to_link(client);
+	struct soc_camera_subdev_desc *ssdd = soc_camera_i2c_to_desc(client);
 	int ret;
 
-	if (!icl) {
+	if (!ssdd) {
 		dev_err(&client->dev, "Missing platform_data for driver\n");
 		return -EINVAL;
 	}
diff --git a/drivers/media/i2c/soc_camera/ov772x.c b/drivers/media/i2c/soc_camera/ov772x.c
index e4a1075..5172ce9 100644
--- a/drivers/media/i2c/soc_camera/ov772x.c
+++ b/drivers/media/i2c/soc_camera/ov772x.c
@@ -667,9 +667,9 @@ static int ov772x_s_register(struct v4l2_subdev *sd,
 static int ov772x_s_power(struct v4l2_subdev *sd, int on)
 {
 	struct i2c_client *client = v4l2_get_subdevdata(sd);
-	struct soc_camera_link *icl = soc_camera_i2c_to_link(client);
+	struct soc_camera_subdev_desc *ssdd = soc_camera_i2c_to_desc(client);
 
-	return soc_camera_set_power(&client->dev, icl, on);
+	return soc_camera_set_power(&client->dev, ssdd, on);
 }
 
 static const struct ov772x_win_size *ov772x_select_win(u32 width, u32 height)
@@ -1019,13 +1019,13 @@ static int ov772x_g_mbus_config(struct v4l2_subdev *sd,
 				struct v4l2_mbus_config *cfg)
 {
 	struct i2c_client *client = v4l2_get_subdevdata(sd);
-	struct soc_camera_link *icl = soc_camera_i2c_to_link(client);
+	struct soc_camera_subdev_desc *ssdd = soc_camera_i2c_to_desc(client);
 
 	cfg->flags = V4L2_MBUS_PCLK_SAMPLE_RISING | V4L2_MBUS_MASTER |
 		V4L2_MBUS_VSYNC_ACTIVE_HIGH | V4L2_MBUS_HSYNC_ACTIVE_HIGH |
 		V4L2_MBUS_DATA_ACTIVE_HIGH;
 	cfg->type = V4L2_MBUS_PARALLEL;
-	cfg->flags = soc_camera_apply_board_flags(icl, cfg);
+	cfg->flags = soc_camera_apply_board_flags(ssdd, cfg);
 
 	return 0;
 }
@@ -1054,11 +1054,11 @@ static int ov772x_probe(struct i2c_client *client,
 			const struct i2c_device_id *did)
 {
 	struct ov772x_priv	*priv;
-	struct soc_camera_link	*icl = soc_camera_i2c_to_link(client);
+	struct soc_camera_subdev_desc *ssdd = soc_camera_i2c_to_desc(client);
 	struct i2c_adapter	*adapter = to_i2c_adapter(client->dev.parent);
 	int			ret;
 
-	if (!icl || !icl->priv) {
+	if (!ssdd || !ssdd->drv_priv) {
 		dev_err(&client->dev, "OV772X: missing platform data!\n");
 		return -EINVAL;
 	}
@@ -1074,7 +1074,7 @@ static int ov772x_probe(struct i2c_client *client,
 	if (!priv)
 		return -ENOMEM;
 
-	priv->info = icl->priv;
+	priv->info = ssdd->drv_priv;
 
 	v4l2_i2c_subdev_init(&priv->subdev, client, &ov772x_subdev_ops);
 	v4l2_ctrl_handler_init(&priv->hdl, 3);
diff --git a/drivers/media/i2c/soc_camera/ov9640.c b/drivers/media/i2c/soc_camera/ov9640.c
index b323684..0ce2124 100644
--- a/drivers/media/i2c/soc_camera/ov9640.c
+++ b/drivers/media/i2c/soc_camera/ov9640.c
@@ -336,9 +336,9 @@ static int ov9640_set_register(struct v4l2_subdev *sd,
 static int ov9640_s_power(struct v4l2_subdev *sd, int on)
 {
 	struct i2c_client *client = v4l2_get_subdevdata(sd);
-	struct soc_camera_link *icl = soc_camera_i2c_to_link(client);
+	struct soc_camera_subdev_desc *ssdd = soc_camera_i2c_to_desc(client);
 
-	return soc_camera_set_power(&client->dev, icl, on);
+	return soc_camera_set_power(&client->dev, ssdd, on);
 }
 
 /* select nearest higher resolution for capture */
@@ -657,13 +657,13 @@ static int ov9640_g_mbus_config(struct v4l2_subdev *sd,
 				struct v4l2_mbus_config *cfg)
 {
 	struct i2c_client *client = v4l2_get_subdevdata(sd);
-	struct soc_camera_link *icl = soc_camera_i2c_to_link(client);
+	struct soc_camera_subdev_desc *ssdd = soc_camera_i2c_to_desc(client);
 
 	cfg->flags = V4L2_MBUS_PCLK_SAMPLE_RISING | V4L2_MBUS_MASTER |
 		V4L2_MBUS_VSYNC_ACTIVE_HIGH | V4L2_MBUS_HSYNC_ACTIVE_HIGH |
 		V4L2_MBUS_DATA_ACTIVE_HIGH;
 	cfg->type = V4L2_MBUS_PARALLEL;
-	cfg->flags = soc_camera_apply_board_flags(icl, cfg);
+	cfg->flags = soc_camera_apply_board_flags(ssdd, cfg);
 
 	return 0;
 }
@@ -690,10 +690,10 @@ static int ov9640_probe(struct i2c_client *client,
 			const struct i2c_device_id *did)
 {
 	struct ov9640_priv *priv;
-	struct soc_camera_link *icl = soc_camera_i2c_to_link(client);
+	struct soc_camera_subdev_desc *ssdd = soc_camera_i2c_to_desc(client);
 	int ret;
 
-	if (!icl) {
+	if (!ssdd) {
 		dev_err(&client->dev, "Missing platform_data for driver\n");
 		return -EINVAL;
 	}
diff --git a/drivers/media/i2c/soc_camera/ov9740.c b/drivers/media/i2c/soc_camera/ov9740.c
index 7a55889..cdaaf5e 100644
--- a/drivers/media/i2c/soc_camera/ov9740.c
+++ b/drivers/media/i2c/soc_camera/ov9740.c
@@ -787,12 +787,12 @@ static int ov9740_g_chip_ident(struct v4l2_subdev *sd,
 static int ov9740_s_power(struct v4l2_subdev *sd, int on)
 {
 	struct i2c_client *client = v4l2_get_subdevdata(sd);
-	struct soc_camera_link *icl = soc_camera_i2c_to_link(client);
+	struct soc_camera_subdev_desc *ssdd = soc_camera_i2c_to_desc(client);
 	struct ov9740_priv *priv = to_ov9740(sd);
 	int ret;
 
 	if (on) {
-		ret = soc_camera_power_on(&client->dev, icl);
+		ret = soc_camera_power_on(&client->dev, ssdd);
 		if (ret < 0)
 			return ret;
 
@@ -806,7 +806,7 @@ static int ov9740_s_power(struct v4l2_subdev *sd, int on)
 			priv->current_enable = true;
 		}
 
-		soc_camera_power_off(&client->dev, icl);
+		soc_camera_power_off(&client->dev, ssdd);
 	}
 
 	return 0;
@@ -905,13 +905,13 @@ static int ov9740_g_mbus_config(struct v4l2_subdev *sd,
 				struct v4l2_mbus_config *cfg)
 {
 	struct i2c_client *client = v4l2_get_subdevdata(sd);
-	struct soc_camera_link *icl = soc_camera_i2c_to_link(client);
+	struct soc_camera_subdev_desc *ssdd = soc_camera_i2c_to_desc(client);
 
 	cfg->flags = V4L2_MBUS_PCLK_SAMPLE_RISING | V4L2_MBUS_MASTER |
 		V4L2_MBUS_VSYNC_ACTIVE_HIGH | V4L2_MBUS_HSYNC_ACTIVE_HIGH |
 		V4L2_MBUS_DATA_ACTIVE_HIGH;
 	cfg->type = V4L2_MBUS_PARALLEL;
-	cfg->flags = soc_camera_apply_board_flags(icl, cfg);
+	cfg->flags = soc_camera_apply_board_flags(ssdd, cfg);
 
 	return 0;
 }
@@ -951,10 +951,10 @@ static int ov9740_probe(struct i2c_client *client,
 			const struct i2c_device_id *did)
 {
 	struct ov9740_priv *priv;
-	struct soc_camera_link *icl = soc_camera_i2c_to_link(client);
+	struct soc_camera_subdev_desc *ssdd = soc_camera_i2c_to_desc(client);
 	int ret;
 
-	if (!icl) {
+	if (!ssdd) {
 		dev_err(&client->dev, "Missing platform_data for driver\n");
 		return -EINVAL;
 	}
diff --git a/drivers/media/i2c/soc_camera/rj54n1cb0c.c b/drivers/media/i2c/soc_camera/rj54n1cb0c.c
index 02f0400..297e288 100644
--- a/drivers/media/i2c/soc_camera/rj54n1cb0c.c
+++ b/drivers/media/i2c/soc_camera/rj54n1cb0c.c
@@ -1183,9 +1183,9 @@ static int rj54n1_s_register(struct v4l2_subdev *sd,
 static int rj54n1_s_power(struct v4l2_subdev *sd, int on)
 {
 	struct i2c_client *client = v4l2_get_subdevdata(sd);
-	struct soc_camera_link *icl = soc_camera_i2c_to_link(client);
+	struct soc_camera_subdev_desc *ssdd = soc_camera_i2c_to_desc(client);
 
-	return soc_camera_set_power(&client->dev, icl, on);
+	return soc_camera_set_power(&client->dev, ssdd, on);
 }
 
 static int rj54n1_s_ctrl(struct v4l2_ctrl *ctrl)
@@ -1245,14 +1245,14 @@ static int rj54n1_g_mbus_config(struct v4l2_subdev *sd,
 				struct v4l2_mbus_config *cfg)
 {
 	struct i2c_client *client = v4l2_get_subdevdata(sd);
-	struct soc_camera_link *icl = soc_camera_i2c_to_link(client);
+	struct soc_camera_subdev_desc *ssdd = soc_camera_i2c_to_desc(client);
 
 	cfg->flags =
 		V4L2_MBUS_PCLK_SAMPLE_RISING | V4L2_MBUS_PCLK_SAMPLE_FALLING |
 		V4L2_MBUS_MASTER | V4L2_MBUS_DATA_ACTIVE_HIGH |
 		V4L2_MBUS_HSYNC_ACTIVE_HIGH | V4L2_MBUS_VSYNC_ACTIVE_HIGH;
 	cfg->type = V4L2_MBUS_PARALLEL;
-	cfg->flags = soc_camera_apply_board_flags(icl, cfg);
+	cfg->flags = soc_camera_apply_board_flags(ssdd, cfg);
 
 	return 0;
 }
@@ -1261,10 +1261,10 @@ static int rj54n1_s_mbus_config(struct v4l2_subdev *sd,
 				const struct v4l2_mbus_config *cfg)
 {
 	struct i2c_client *client = v4l2_get_subdevdata(sd);
-	struct soc_camera_link *icl = soc_camera_i2c_to_link(client);
+	struct soc_camera_subdev_desc *ssdd = soc_camera_i2c_to_desc(client);
 
 	/* Figures 2.5-1 to 2.5-3 - default falling pixclk edge */
-	if (soc_camera_apply_board_flags(icl, cfg) &
+	if (soc_camera_apply_board_flags(ssdd, cfg) &
 	    V4L2_MBUS_PCLK_SAMPLE_RISING)
 		return reg_write(client, RJ54N1_OUT_SIGPO, 1 << 4);
 	else
@@ -1334,17 +1334,17 @@ static int rj54n1_probe(struct i2c_client *client,
 			const struct i2c_device_id *did)
 {
 	struct rj54n1 *rj54n1;
-	struct soc_camera_link *icl = soc_camera_i2c_to_link(client);
+	struct soc_camera_subdev_desc *ssdd = soc_camera_i2c_to_desc(client);
 	struct i2c_adapter *adapter = to_i2c_adapter(client->dev.parent);
 	struct rj54n1_pdata *rj54n1_priv;
 	int ret;
 
-	if (!icl || !icl->priv) {
+	if (!ssdd || !ssdd->drv_priv) {
 		dev_err(&client->dev, "RJ54N1CB0C: missing platform data!\n");
 		return -EINVAL;
 	}
 
-	rj54n1_priv = icl->priv;
+	rj54n1_priv = ssdd->drv_priv;
 
 	if (!i2c_check_functionality(adapter, I2C_FUNC_SMBUS_BYTE_DATA)) {
 		dev_warn(&adapter->dev,
@@ -1398,11 +1398,11 @@ static int rj54n1_probe(struct i2c_client *client,
 static int rj54n1_remove(struct i2c_client *client)
 {
 	struct rj54n1 *rj54n1 = to_rj54n1(client);
-	struct soc_camera_link *icl = soc_camera_i2c_to_link(client);
+	struct soc_camera_subdev_desc *ssdd = soc_camera_i2c_to_desc(client);
 
 	v4l2_device_unregister_subdev(&rj54n1->subdev);
-	if (icl->free_bus)
-		icl->free_bus(icl);
+	if (ssdd->free_bus)
+		ssdd->free_bus(ssdd);
 	v4l2_ctrl_handler_free(&rj54n1->hdl);
 	kfree(rj54n1);
 
diff --git a/drivers/media/i2c/soc_camera/tw9910.c b/drivers/media/i2c/soc_camera/tw9910.c
index 140716e..cc34c59 100644
--- a/drivers/media/i2c/soc_camera/tw9910.c
+++ b/drivers/media/i2c/soc_camera/tw9910.c
@@ -569,9 +569,9 @@ static int tw9910_s_register(struct v4l2_subdev *sd,
 static int tw9910_s_power(struct v4l2_subdev *sd, int on)
 {
 	struct i2c_client *client = v4l2_get_subdevdata(sd);
-	struct soc_camera_link *icl = soc_camera_i2c_to_link(client);
+	struct soc_camera_subdev_desc *ssdd = soc_camera_i2c_to_desc(client);
 
-	return soc_camera_set_power(&client->dev, icl, on);
+	return soc_camera_set_power(&client->dev, ssdd, on);
 }
 
 static int tw9910_set_frame(struct v4l2_subdev *sd, u32 *width, u32 *height)
@@ -847,14 +847,14 @@ static int tw9910_g_mbus_config(struct v4l2_subdev *sd,
 				struct v4l2_mbus_config *cfg)
 {
 	struct i2c_client *client = v4l2_get_subdevdata(sd);
-	struct soc_camera_link *icl = soc_camera_i2c_to_link(client);
+	struct soc_camera_subdev_desc *ssdd = soc_camera_i2c_to_desc(client);
 
 	cfg->flags = V4L2_MBUS_PCLK_SAMPLE_RISING | V4L2_MBUS_MASTER |
 		V4L2_MBUS_VSYNC_ACTIVE_HIGH | V4L2_MBUS_VSYNC_ACTIVE_LOW |
 		V4L2_MBUS_HSYNC_ACTIVE_HIGH | V4L2_MBUS_HSYNC_ACTIVE_LOW |
 		V4L2_MBUS_DATA_ACTIVE_HIGH;
 	cfg->type = V4L2_MBUS_PARALLEL;
-	cfg->flags = soc_camera_apply_board_flags(icl, cfg);
+	cfg->flags = soc_camera_apply_board_flags(ssdd, cfg);
 
 	return 0;
 }
@@ -863,9 +863,9 @@ static int tw9910_s_mbus_config(struct v4l2_subdev *sd,
 				const struct v4l2_mbus_config *cfg)
 {
 	struct i2c_client *client = v4l2_get_subdevdata(sd);
-	struct soc_camera_link *icl = soc_camera_i2c_to_link(client);
+	struct soc_camera_subdev_desc *ssdd = soc_camera_i2c_to_desc(client);
 	u8 val = VSSL_VVALID | HSSL_DVALID;
-	unsigned long flags = soc_camera_apply_board_flags(icl, cfg);
+	unsigned long flags = soc_camera_apply_board_flags(ssdd, cfg);
 
 	/*
 	 * set OUTCTR1
@@ -911,15 +911,15 @@ static int tw9910_probe(struct i2c_client *client,
 	struct tw9910_video_info	*info;
 	struct i2c_adapter		*adapter =
 		to_i2c_adapter(client->dev.parent);
-	struct soc_camera_link		*icl = soc_camera_i2c_to_link(client);
+	struct soc_camera_subdev_desc	*ssdd = soc_camera_i2c_to_desc(client);
 	int				ret;
 
-	if (!icl || !icl->priv) {
+	if (!ssdd || !ssdd->drv_priv) {
 		dev_err(&client->dev, "TW9910: missing platform data!\n");
 		return -EINVAL;
 	}
 
-	info = icl->priv;
+	info = ssdd->drv_priv;
 
 	if (!i2c_check_functionality(adapter, I2C_FUNC_SMBUS_BYTE_DATA)) {
 		dev_err(&client->dev,
diff --git a/drivers/media/platform/soc_camera/soc_camera.c b/drivers/media/platform/soc_camera/soc_camera.c
index 560390d..4285a8b 100644
--- a/drivers/media/platform/soc_camera/soc_camera.c
+++ b/drivers/media/platform/soc_camera/soc_camera.c
@@ -50,22 +50,22 @@ static LIST_HEAD(hosts);
 static LIST_HEAD(devices);
 static DEFINE_MUTEX(list_lock);		/* Protects the list of hosts */
 
-int soc_camera_power_on(struct device *dev, struct soc_camera_link *icl)
+int soc_camera_power_on(struct device *dev, struct soc_camera_subdev_desc *ssdd)
 {
-	int ret = regulator_bulk_enable(icl->num_regulators,
-					icl->regulators);
+	int ret = regulator_bulk_enable(ssdd->num_regulators,
+					ssdd->regulators);
 	if (ret < 0) {
 		dev_err(dev, "Cannot enable regulators\n");
 		return ret;
 	}
 
-	if (icl->power) {
-		ret = icl->power(dev, 1);
+	if (ssdd->power) {
+		ret = ssdd->power(dev, 1);
 		if (ret < 0) {
 			dev_err(dev,
 				"Platform failed to power-on the camera.\n");
-			regulator_bulk_disable(icl->num_regulators,
-					       icl->regulators);
+			regulator_bulk_disable(ssdd->num_regulators,
+					       ssdd->regulators);
 		}
 	}
 
@@ -73,13 +73,13 @@ int soc_camera_power_on(struct device *dev, struct soc_camera_link *icl)
 }
 EXPORT_SYMBOL(soc_camera_power_on);
 
-int soc_camera_power_off(struct device *dev, struct soc_camera_link *icl)
+int soc_camera_power_off(struct device *dev, struct soc_camera_subdev_desc *ssdd)
 {
 	int ret = 0;
 	int err;
 
-	if (icl->power) {
-		err = icl->power(dev, 0);
+	if (ssdd->power) {
+		err = ssdd->power(dev, 0);
 		if (err < 0) {
 			dev_err(dev,
 				"Platform failed to power-off the camera.\n");
@@ -87,8 +87,8 @@ int soc_camera_power_off(struct device *dev, struct soc_camera_link *icl)
 		}
 	}
 
-	err = regulator_bulk_disable(icl->num_regulators,
-				     icl->regulators);
+	err = regulator_bulk_disable(ssdd->num_regulators,
+				     ssdd->regulators);
 	if (err < 0) {
 		dev_err(dev, "Cannot disable regulators\n");
 		ret = ret ? : err;
@@ -136,29 +136,29 @@ EXPORT_SYMBOL(soc_camera_xlate_by_fourcc);
 
 /**
  * soc_camera_apply_board_flags() - apply platform SOCAM_SENSOR_INVERT_* flags
- * @icl:	camera platform parameters
+ * @ssdd:	camera platform parameters
  * @cfg:	media bus configuration
  * @return:	resulting flags
  */
-unsigned long soc_camera_apply_board_flags(struct soc_camera_link *icl,
+unsigned long soc_camera_apply_board_flags(struct soc_camera_subdev_desc *ssdd,
 					   const struct v4l2_mbus_config *cfg)
 {
 	unsigned long f, flags = cfg->flags;
 
 	/* If only one of the two polarities is supported, switch to the opposite */
-	if (icl->flags & SOCAM_SENSOR_INVERT_HSYNC) {
+	if (ssdd->flags & SOCAM_SENSOR_INVERT_HSYNC) {
 		f = flags & (V4L2_MBUS_HSYNC_ACTIVE_HIGH | V4L2_MBUS_HSYNC_ACTIVE_LOW);
 		if (f == V4L2_MBUS_HSYNC_ACTIVE_HIGH || f == V4L2_MBUS_HSYNC_ACTIVE_LOW)
 			flags ^= V4L2_MBUS_HSYNC_ACTIVE_HIGH | V4L2_MBUS_HSYNC_ACTIVE_LOW;
 	}
 
-	if (icl->flags & SOCAM_SENSOR_INVERT_VSYNC) {
+	if (ssdd->flags & SOCAM_SENSOR_INVERT_VSYNC) {
 		f = flags & (V4L2_MBUS_VSYNC_ACTIVE_HIGH | V4L2_MBUS_VSYNC_ACTIVE_LOW);
 		if (f == V4L2_MBUS_VSYNC_ACTIVE_HIGH || f == V4L2_MBUS_VSYNC_ACTIVE_LOW)
 			flags ^= V4L2_MBUS_VSYNC_ACTIVE_HIGH | V4L2_MBUS_VSYNC_ACTIVE_LOW;
 	}
 
-	if (icl->flags & SOCAM_SENSOR_INVERT_PCLK) {
+	if (ssdd->flags & SOCAM_SENSOR_INVERT_PCLK) {
 		f = flags & (V4L2_MBUS_PCLK_SAMPLE_RISING | V4L2_MBUS_PCLK_SAMPLE_FALLING);
 		if (f == V4L2_MBUS_PCLK_SAMPLE_RISING || f == V4L2_MBUS_PCLK_SAMPLE_FALLING)
 			flags ^= V4L2_MBUS_PCLK_SAMPLE_RISING | V4L2_MBUS_PCLK_SAMPLE_FALLING;
@@ -509,7 +509,7 @@ static int soc_camera_open(struct file *file)
 {
 	struct video_device *vdev = video_devdata(file);
 	struct soc_camera_device *icd = dev_get_drvdata(vdev->parent);
-	struct soc_camera_link *icl = to_soc_camera_link(icd);
+	struct soc_camera_desc *sdesc = to_soc_camera_desc(icd);
 	struct soc_camera_host *ici;
 	int ret;
 
@@ -552,8 +552,8 @@ static int soc_camera_open(struct file *file)
 		};
 
 		/* The camera could have been already on, try to reset */
-		if (icl->reset)
-			icl->reset(icd->pdev);
+		if (sdesc->subdev_desc.reset)
+			sdesc->subdev_desc.reset(icd->pdev);
 
 		ret = ici->ops->add(icd);
 		if (ret < 0) {
@@ -1070,23 +1070,24 @@ static void scan_add_host(struct soc_camera_host *ici)
 
 #ifdef CONFIG_I2C_BOARDINFO
 static int soc_camera_init_i2c(struct soc_camera_device *icd,
-			       struct soc_camera_link *icl)
+			       struct soc_camera_desc *sdesc)
 {
 	struct i2c_client *client;
 	struct soc_camera_host *ici = to_soc_camera_host(icd->parent);
-	struct i2c_adapter *adap = i2c_get_adapter(icl->i2c_adapter_id);
+	struct soc_camera_host_desc *shd = &sdesc->host_desc;
+	struct i2c_adapter *adap = i2c_get_adapter(shd->i2c_adapter_id);
 	struct v4l2_subdev *subdev;
 
 	if (!adap) {
 		dev_err(icd->pdev, "Cannot get I2C adapter #%d. No driver?\n",
-			icl->i2c_adapter_id);
+			shd->i2c_adapter_id);
 		goto ei2cga;
 	}
 
-	icl->board_info->platform_data = icl;
+	shd->board_info->platform_data = &sdesc->subdev_desc;
 
 	subdev = v4l2_i2c_new_subdev_board(&ici->v4l2_dev, adap,
-				icl->board_info, NULL);
+				shd->board_info, NULL);
 	if (!subdev)
 		goto ei2cnd;
 
@@ -1114,7 +1115,7 @@ static void soc_camera_free_i2c(struct soc_camera_device *icd)
 	i2c_put_adapter(adap);
 }
 #else
-#define soc_camera_init_i2c(icd, icl)	(-ENODEV)
+#define soc_camera_init_i2c(icd, sdesc)	(-ENODEV)
 #define soc_camera_free_i2c(icd)	do {} while (0)
 #endif
 
@@ -1124,7 +1125,9 @@ static int video_dev_create(struct soc_camera_device *icd);
 static int soc_camera_probe(struct soc_camera_device *icd)
 {
 	struct soc_camera_host *ici = to_soc_camera_host(icd->parent);
-	struct soc_camera_link *icl = to_soc_camera_link(icd);
+	struct soc_camera_desc *sdesc = to_soc_camera_desc(icd);
+	struct soc_camera_host_desc *shd = &sdesc->host_desc;
+	struct soc_camera_subdev_desc *ssdd = &sdesc->subdev_desc;
 	struct device *control = NULL;
 	struct v4l2_subdev *sd;
 	struct v4l2_mbus_framefmt mf;
@@ -1143,14 +1146,14 @@ static int soc_camera_probe(struct soc_camera_device *icd)
 	if (ret < 0)
 		return ret;
 
-	ret = devm_regulator_bulk_get(icd->pdev, icl->num_regulators,
-				      icl->regulators);
+	ret = devm_regulator_bulk_get(icd->pdev, ssdd->num_regulators,
+				      ssdd->regulators);
 	if (ret < 0)
 		goto ereg;
 
 	/* The camera could have been already on, try to reset */
-	if (icl->reset)
-		icl->reset(icd->pdev);
+	if (ssdd->reset)
+		ssdd->reset(icd->pdev);
 
 	mutex_lock(&ici->host_lock);
 	ret = ici->ops->add(icd);
@@ -1164,18 +1167,18 @@ static int soc_camera_probe(struct soc_camera_device *icd)
 		goto evdc;
 
 	/* Non-i2c cameras, e.g., soc_camera_platform, have no board_info */
-	if (icl->board_info) {
-		ret = soc_camera_init_i2c(icd, icl);
+	if (shd->board_info) {
+		ret = soc_camera_init_i2c(icd, sdesc);
 		if (ret < 0)
 			goto eadddev;
-	} else if (!icl->add_device || !icl->del_device) {
+	} else if (!ssdd->add_device || !ssdd->del_device) {
 		ret = -EINVAL;
 		goto eadddev;
 	} else {
-		if (icl->module_name)
-			ret = request_module(icl->module_name);
+		if (shd->module_name)
+			ret = request_module(shd->module_name);
 
-		ret = icl->add_device(icd);
+		ret = ssdd->add_device(icd);
 		if (ret < 0)
 			goto eadddev;
 
@@ -1186,7 +1189,7 @@ static int soc_camera_probe(struct soc_camera_device *icd)
 		control = to_soc_camera_control(icd);
 		if (!control || !control->driver || !dev_get_drvdata(control) ||
 		    !try_module_get(control->driver->owner)) {
-			icl->del_device(icd);
+			ssdd->del_device(icd);
 			ret = -ENODEV;
 			goto enodrv;
 		}
@@ -1237,10 +1240,10 @@ evidstart:
 	soc_camera_free_user_formats(icd);
 eiufmt:
 ectrl:
-	if (icl->board_info) {
+	if (shd->board_info) {
 		soc_camera_free_i2c(icd);
 	} else {
-		icl->del_device(icd);
+		ssdd->del_device(icd);
 		module_put(control->driver->owner);
 	}
 enodrv:
@@ -1263,7 +1266,7 @@ ereg:
  */
 static int soc_camera_remove(struct soc_camera_device *icd)
 {
-	struct soc_camera_link *icl = to_soc_camera_link(icd);
+	struct soc_camera_desc *sdesc = to_soc_camera_desc(icd);
 	struct video_device *vdev = icd->vdev;
 
 	BUG_ON(!icd->parent);
@@ -1274,12 +1277,12 @@ static int soc_camera_remove(struct soc_camera_device *icd)
 		icd->vdev = NULL;
 	}
 
-	if (icl->board_info) {
+	if (sdesc->host_desc.board_info) {
 		soc_camera_free_i2c(icd);
 	} else {
 		struct device_driver *drv = to_soc_camera_control(icd)->driver;
 		if (drv) {
-			icl->del_device(icd);
+			sdesc->subdev_desc.del_device(icd);
 			module_put(drv->owner);
 		}
 	}
@@ -1538,18 +1541,18 @@ static int soc_camera_video_start(struct soc_camera_device *icd)
 
 static int __devinit soc_camera_pdrv_probe(struct platform_device *pdev)
 {
-	struct soc_camera_link *icl = pdev->dev.platform_data;
+	struct soc_camera_desc *sdesc = pdev->dev.platform_data;
 	struct soc_camera_device *icd;
 
-	if (!icl)
+	if (!sdesc)
 		return -EINVAL;
 
 	icd = devm_kzalloc(&pdev->dev, sizeof(*icd), GFP_KERNEL);
 	if (!icd)
 		return -ENOMEM;
 
-	icd->iface = icl->bus_id;
-	icd->link = icl;
+	icd->iface = sdesc->host_desc.bus_id;
+	icd->sdesc = sdesc;
 	icd->pdev = &pdev->dev;
 	platform_set_drvdata(pdev, icd);
 
diff --git a/drivers/media/platform/soc_camera/soc_camera_platform.c b/drivers/media/platform/soc_camera/soc_camera_platform.c
index 7cf7fd1..51e29d1 100644
--- a/drivers/media/platform/soc_camera/soc_camera_platform.c
+++ b/drivers/media/platform/soc_camera/soc_camera_platform.c
@@ -54,7 +54,7 @@ static int soc_camera_platform_s_power(struct v4l2_subdev *sd, int on)
 {
 	struct soc_camera_platform_info *p = v4l2_get_subdevdata(sd);
 
-	return soc_camera_set_power(p->icd->control, p->icd->link, on);
+	return soc_camera_set_power(p->icd->control, &p->icd->sdesc->subdev_desc, on);
 }
 
 static struct v4l2_subdev_core_ops platform_subdev_core_ops = {
diff --git a/include/media/soc_camera.h b/include/media/soc_camera.h
index 5a662c9..2dc3ddd 100644
--- a/include/media/soc_camera.h
+++ b/include/media/soc_camera.h
@@ -23,11 +23,11 @@
 #include <media/v4l2-device.h>
 
 struct file;
-struct soc_camera_link;
+struct soc_camera_desc;
 
 struct soc_camera_device {
 	struct list_head list;		/* list of all registered devices */
-	struct soc_camera_link *link;
+	struct soc_camera_desc *sdesc;
 	struct device *pdev;		/* Platform device */
 	struct device *parent;		/* Camera host device */
 	struct device *control;		/* E.g., the i2c client */
@@ -116,14 +116,66 @@ struct soc_camera_host_ops {
 struct i2c_board_info;
 struct regulator_bulk_data;
 
-struct soc_camera_link {
-	/* Camera bus id, used to match a camera and a bus */
-	int bus_id;
+struct soc_camera_subdev_desc {
 	/* Per camera SOCAM_SENSOR_* bus flags */
 	unsigned long flags;
+
+	/* sensor driver private platform data */
+	void *drv_priv;
+
+	/* Optional regulators that have to be managed on power on/off events */
+	struct regulator_bulk_data *regulators;
+	int num_regulators;
+
+	/*
+	 * For non-I2C devices platform has to provide methods to add a device
+	 * to the system and to remove it
+	 */
+	int (*add_device)(struct soc_camera_device *);
+	void (*del_device)(struct soc_camera_device *);
+
+	/* Optional callbacks to power on or off and reset the sensor */
+	int (*power)(struct device *, int);
+	int (*reset)(struct device *);
+
+	/*
+	 * some platforms may support different data widths than the sensors
+	 * native ones due to different data line routing. Let the board code
+	 * overwrite the width flags.
+	 */
+	int (*set_bus_param)(struct soc_camera_subdev_desc *, unsigned long flags);
+	unsigned long (*query_bus_param)(struct soc_camera_subdev_desc *);
+	void (*free_bus)(struct soc_camera_subdev_desc *);
+};
+
+struct soc_camera_host_desc {
+	/* Camera bus id, used to match a camera and a bus */
+	int bus_id;
 	int i2c_adapter_id;
 	struct i2c_board_info *board_info;
 	const char *module_name;
+};
+
+/*
+ * This MUST be kept binary-identical to struct soc_camera_link below, until
+ * it is completely replaced by this one, after which we can split it into its
+ * two components.
+ */
+struct soc_camera_desc {
+	struct soc_camera_subdev_desc subdev_desc;
+	struct soc_camera_host_desc host_desc;
+};
+
+/* Prepare to replace this struct: don't change its layout any more! */
+struct soc_camera_link {
+	/*
+	 * Subdevice part - keep at top and compatible to
+	 * struct soc_camera_subdev_desc
+	 */
+
+	/* Per camera SOCAM_SENSOR_* bus flags */
+	unsigned long flags;
+
 	void *priv;
 
 	/* Optional regulators that have to be managed on power on/off events */
@@ -147,6 +199,17 @@ struct soc_camera_link {
 	int (*set_bus_param)(struct soc_camera_link *, unsigned long flags);
 	unsigned long (*query_bus_param)(struct soc_camera_link *);
 	void (*free_bus)(struct soc_camera_link *);
+
+	/*
+	 * Host part - keep at bottom and compatible to
+	 * struct soc_camera_host_desc
+	 */
+
+	/* Camera bus id, used to match a camera and a bus */
+	int bus_id;
+	int i2c_adapter_id;
+	struct i2c_board_info *board_info;
+	const char *module_name;
 };
 
 static inline struct soc_camera_host *to_soc_camera_host(
@@ -157,10 +220,10 @@ static inline struct soc_camera_host *to_soc_camera_host(
 	return container_of(v4l2_dev, struct soc_camera_host, v4l2_dev);
 }
 
-static inline struct soc_camera_link *to_soc_camera_link(
+static inline struct soc_camera_desc *to_soc_camera_desc(
 	const struct soc_camera_device *icd)
 {
-	return icd->link;
+	return icd->sdesc;
 }
 
 static inline struct device *to_soc_camera_control(
@@ -250,19 +313,17 @@ static inline void soc_camera_limit_side(int *start, int *length,
 		*start = start_min + length_max - *length;
 }
 
-unsigned long soc_camera_apply_sensor_flags(struct soc_camera_link *icl,
-					    unsigned long flags);
-unsigned long soc_camera_apply_board_flags(struct soc_camera_link *icl,
+unsigned long soc_camera_apply_board_flags(struct soc_camera_subdev_desc *ssdd,
 					   const struct v4l2_mbus_config *cfg);
 
-int soc_camera_power_on(struct device *dev, struct soc_camera_link *icl);
-int soc_camera_power_off(struct device *dev, struct soc_camera_link *icl);
+int soc_camera_power_on(struct device *dev, struct soc_camera_subdev_desc *ssdd);
+int soc_camera_power_off(struct device *dev, struct soc_camera_subdev_desc *ssdd);
 
 static inline int soc_camera_set_power(struct device *dev,
-				       struct soc_camera_link *icl, bool on)
+				struct soc_camera_subdev_desc *ssdd, bool on)
 {
-	return on ? soc_camera_power_on(dev, icl)
-		  : soc_camera_power_off(dev, icl);
+	return on ? soc_camera_power_on(dev, ssdd)
+		  : soc_camera_power_off(dev, ssdd);
 }
 
 /* This is only temporary here - until v4l2-subdev begins to link to video_device */
@@ -274,7 +335,7 @@ static inline struct video_device *soc_camera_i2c_to_vdev(const struct i2c_clien
 	return icd ? icd->vdev : NULL;
 }
 
-static inline struct soc_camera_link *soc_camera_i2c_to_link(const struct i2c_client *client)
+static inline struct soc_camera_subdev_desc *soc_camera_i2c_to_desc(const struct i2c_client *client)
 {
 	return client->dev.platform_data;
 }
diff --git a/include/media/soc_camera_platform.h b/include/media/soc_camera_platform.h
index 8aa4200..1e5065da 100644
--- a/include/media/soc_camera_platform.h
+++ b/include/media/soc_camera_platform.h
@@ -38,10 +38,12 @@ static inline int soc_camera_platform_add(struct soc_camera_device *icd,
 					  void (*release)(struct device *dev),
 					  int id)
 {
-	struct soc_camera_platform_info *info = plink->priv;
+	struct soc_camera_subdev_desc *ssdd =
+		(struct soc_camera_subdev_desc *)plink;
+	struct soc_camera_platform_info *info = ssdd->drv_priv;
 	int ret;
 
-	if (icd->link != plink)
+	if (&icd->sdesc->subdev_desc != ssdd)
 		return -ENODEV;
 
 	if (*pdev)
@@ -70,7 +72,9 @@ static inline void soc_camera_platform_del(const struct soc_camera_device *icd,
 					   struct platform_device *pdev,
 					   const struct soc_camera_link *plink)
 {
-	if (icd->link != plink || !pdev)
+	const struct soc_camera_subdev_desc *ssdd =
+		(const struct soc_camera_subdev_desc *)plink;
+	if (&icd->sdesc->subdev_desc != ssdd || !pdev)
 		return;
 
 	platform_device_unregister(pdev);
-- 
1.7.2.5

