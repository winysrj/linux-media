Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:55202 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753468Ab2GTNTr (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 20 Jul 2012 09:19:47 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: linux-media@vger.kernel.org
Subject: [PATCH v4] soc-camera: Add and use soc_camera_power_[on|off]() helper functions
Date: Fri, 20 Jul 2012 15:19:50 +0200
Message-Id: <1342790390-12367-1-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <Pine.LNX.4.64.1207201447120.27906@axis700.grange>
References: <Pine.LNX.4.64.1207201447120.27906@axis700.grange>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Instead of forcing all soc-camera drivers to go through the mid-layer to
handle power management, create soc_camera_power_[on|off]() functions
that can be called from the subdev .s_power() operation to manage
regulators and platform-specific power handling. This allows non
soc-camera hosts to use soc-camera-aware clients.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/media/video/imx074.c              |    9 +++
 drivers/media/video/mt9m001.c             |    9 +++
 drivers/media/video/mt9m111.c             |   52 ++++++++++++-----
 drivers/media/video/mt9t031.c             |   11 +++-
 drivers/media/video/mt9t112.c             |    9 +++
 drivers/media/video/mt9v022.c             |    9 +++
 drivers/media/video/ov2640.c              |    9 +++
 drivers/media/video/ov5642.c              |   10 ++-
 drivers/media/video/ov6650.c              |    9 +++
 drivers/media/video/ov772x.c              |    9 +++
 drivers/media/video/ov9640.c              |   10 +++-
 drivers/media/video/ov9740.c              |   24 ++++++--
 drivers/media/video/rj54n1cb0c.c          |    9 +++
 drivers/media/video/soc_camera.c          |   88 ++++++++++++++++-------------
 drivers/media/video/soc_camera_platform.c |   11 +++-
 drivers/media/video/tw9910.c              |    9 +++
 include/media/soc_camera.h                |   10 +++
 17 files changed, 229 insertions(+), 68 deletions(-)

diff --git a/drivers/media/video/imx074.c b/drivers/media/video/imx074.c
index 351e9ba..ade1987 100644
--- a/drivers/media/video/imx074.c
+++ b/drivers/media/video/imx074.c
@@ -268,6 +268,14 @@ static int imx074_g_chip_ident(struct v4l2_subdev *sd,
 	return 0;
 }
 
+static int imx074_s_power(struct v4l2_subdev *sd, int on)
+{
+	struct i2c_client *client = v4l2_get_subdevdata(sd);
+	struct soc_camera_link *icl = soc_camera_i2c_to_link(client);
+
+	return soc_camera_set_power(&client->dev, icl, on);
+}
+
 static int imx074_g_mbus_config(struct v4l2_subdev *sd,
 				struct v4l2_mbus_config *cfg)
 {
@@ -292,6 +300,7 @@ static struct v4l2_subdev_video_ops imx074_subdev_video_ops = {
 
 static struct v4l2_subdev_core_ops imx074_subdev_core_ops = {
 	.g_chip_ident	= imx074_g_chip_ident,
+	.s_power	= imx074_s_power,
 };
 
 static struct v4l2_subdev_ops imx074_subdev_ops = {
diff --git a/drivers/media/video/mt9m001.c b/drivers/media/video/mt9m001.c
index 00583f5..cd71230 100644
--- a/drivers/media/video/mt9m001.c
+++ b/drivers/media/video/mt9m001.c
@@ -377,6 +377,14 @@ static int mt9m001_s_register(struct v4l2_subdev *sd,
 }
 #endif
 
+static int mt9m001_s_power(struct v4l2_subdev *sd, int on)
+{
+	struct i2c_client *client = v4l2_get_subdevdata(sd);
+	struct soc_camera_link *icl = soc_camera_i2c_to_link(client);
+
+	return soc_camera_set_power(&client->dev, icl, on);
+}
+
 static int mt9m001_g_volatile_ctrl(struct v4l2_ctrl *ctrl)
 {
 	struct mt9m001 *mt9m001 = container_of(ctrl->handler,
@@ -566,6 +574,7 @@ static struct v4l2_subdev_core_ops mt9m001_subdev_core_ops = {
 	.g_register	= mt9m001_g_register,
 	.s_register	= mt9m001_s_register,
 #endif
+	.s_power	= mt9m001_s_power,
 };
 
 static int mt9m001_enum_fmt(struct v4l2_subdev *sd, unsigned int index,
diff --git a/drivers/media/video/mt9m111.c b/drivers/media/video/mt9m111.c
index 863d722..e555f77 100644
--- a/drivers/media/video/mt9m111.c
+++ b/drivers/media/video/mt9m111.c
@@ -831,10 +831,37 @@ static int mt9m111_video_probe(struct i2c_client *client)
 	return v4l2_ctrl_handler_setup(&mt9m111->hdl);
 }
 
+static int mt9m111_power_on(struct mt9m111 *mt9m111)
+{
+	struct i2c_client *client = v4l2_get_subdevdata(&mt9m111->subdev);
+	struct soc_camera_link *icl = soc_camera_i2c_to_link(client);
+	int ret;
+
+	ret = soc_camera_power_on(&client->dev, icl);
+	if (ret < 0)
+		return ret;
+
+	ret = mt9m111_resume(mt9m111);
+	if (ret < 0) {
+		dev_err(&client->dev, "Failed to resume the sensor: %d\n", ret);
+		soc_camera_power_off(&client->dev, icl);
+	}
+
+	return ret;
+}
+
+static void mt9m111_power_off(struct mt9m111 *mt9m111)
+{
+	struct i2c_client *client = v4l2_get_subdevdata(&mt9m111->subdev);
+	struct soc_camera_link *icl = soc_camera_i2c_to_link(client);
+
+	mt9m111_suspend(mt9m111);
+	soc_camera_power_off(&client->dev, icl);
+}
+
 static int mt9m111_s_power(struct v4l2_subdev *sd, int on)
 {
 	struct mt9m111 *mt9m111 = container_of(sd, struct mt9m111, subdev);
-	struct i2c_client *client = v4l2_get_subdevdata(sd);
 	int ret = 0;
 
 	mutex_lock(&mt9m111->power_lock);
@@ -844,23 +871,18 @@ static int mt9m111_s_power(struct v4l2_subdev *sd, int on)
 	 * update the power state.
 	 */
 	if (mt9m111->power_count == !on) {
-		if (on) {
-			ret = mt9m111_resume(mt9m111);
-			if (ret) {
-				dev_err(&client->dev,
-					"Failed to resume the sensor: %d\n", ret);
-				goto out;
-			}
-		} else {
-			mt9m111_suspend(mt9m111);
-		}
+		if (on)
+			ret = mt9m111_power_on(mt9m111);
+		else
+			mt9m111_power_off(mt9m111);
 	}
 
-	/* Update the power count. */
-	mt9m111->power_count += on ? 1 : -1;
-	WARN_ON(mt9m111->power_count < 0);
+	if (!ret) {
+		/* Update the power count. */
+		mt9m111->power_count += on ? 1 : -1;
+		WARN_ON(mt9m111->power_count < 0);
+	}
 
-out:
 	mutex_unlock(&mt9m111->power_lock);
 	return ret;
 }
diff --git a/drivers/media/video/mt9t031.c b/drivers/media/video/mt9t031.c
index 1415074..9666e20 100644
--- a/drivers/media/video/mt9t031.c
+++ b/drivers/media/video/mt9t031.c
@@ -616,12 +616,19 @@ static struct device_type mt9t031_dev_type = {
 static int mt9t031_s_power(struct v4l2_subdev *sd, int on)
 {
 	struct i2c_client *client = v4l2_get_subdevdata(sd);
+	struct soc_camera_link *icl = soc_camera_i2c_to_link(client);
 	struct video_device *vdev = soc_camera_i2c_to_vdev(client);
+	int ret;
 
-	if (on)
+	if (on) {
+		ret = soc_camera_power_on(&client->dev, icl);
+		if (ret < 0)
+			return ret;
 		vdev->dev.type = &mt9t031_dev_type;
-	else
+	} else {
 		vdev->dev.type = NULL;
+		soc_camera_power_off(&client->dev, icl);
+	}
 
 	return 0;
 }
diff --git a/drivers/media/video/mt9t112.c b/drivers/media/video/mt9t112.c
index e1ae46a..624ceec 100644
--- a/drivers/media/video/mt9t112.c
+++ b/drivers/media/video/mt9t112.c
@@ -776,12 +776,21 @@ static int mt9t112_s_register(struct v4l2_subdev *sd,
 }
 #endif
 
+static int mt9t112_s_power(struct v4l2_subdev *sd, int on)
+{
+	struct i2c_client *client = v4l2_get_subdevdata(sd);
+	struct soc_camera_link *icl = soc_camera_i2c_to_link(client);
+
+	return soc_camera_set_power(&client->dev, icl, on);
+}
+
 static struct v4l2_subdev_core_ops mt9t112_subdev_core_ops = {
 	.g_chip_ident	= mt9t112_g_chip_ident,
 #ifdef CONFIG_VIDEO_ADV_DEBUG
 	.g_register	= mt9t112_g_register,
 	.s_register	= mt9t112_s_register,
 #endif
+	.s_power	= mt9t112_s_power,
 };
 
 
diff --git a/drivers/media/video/mt9v022.c b/drivers/media/video/mt9v022.c
index 7247924..5f09cb7 100644
--- a/drivers/media/video/mt9v022.c
+++ b/drivers/media/video/mt9v022.c
@@ -445,6 +445,14 @@ static int mt9v022_s_register(struct v4l2_subdev *sd,
 }
 #endif
 
+static int mt9v022_s_power(struct v4l2_subdev *sd, int on)
+{
+	struct i2c_client *client = v4l2_get_subdevdata(sd);
+	struct soc_camera_link *icl = soc_camera_i2c_to_link(client);
+
+	return soc_camera_set_power(&client->dev, icl, on);
+}
+
 static int mt9v022_g_volatile_ctrl(struct v4l2_ctrl *ctrl)
 {
 	struct mt9v022 *mt9v022 = container_of(ctrl->handler,
@@ -664,6 +672,7 @@ static struct v4l2_subdev_core_ops mt9v022_subdev_core_ops = {
 	.g_register	= mt9v022_g_register,
 	.s_register	= mt9v022_s_register,
 #endif
+	.s_power	= mt9v022_s_power,
 };
 
 static int mt9v022_enum_fmt(struct v4l2_subdev *sd, unsigned int index,
diff --git a/drivers/media/video/ov2640.c b/drivers/media/video/ov2640.c
index 7c44d1f..16ed091 100644
--- a/drivers/media/video/ov2640.c
+++ b/drivers/media/video/ov2640.c
@@ -742,6 +742,14 @@ static int ov2640_s_register(struct v4l2_subdev *sd,
 }
 #endif
 
+static int ov2640_s_power(struct v4l2_subdev *sd, int on)
+{
+	struct i2c_client *client = v4l2_get_subdevdata(sd);
+	struct soc_camera_link *icl = soc_camera_i2c_to_link(client);
+
+	return soc_camera_set_power(&client->dev, icl, on);
+}
+
 /* Select the nearest higher resolution for capture */
 static const struct ov2640_win_size *ov2640_select_win(u32 *width, u32 *height)
 {
@@ -988,6 +996,7 @@ static struct v4l2_subdev_core_ops ov2640_subdev_core_ops = {
 	.g_register	= ov2640_g_register,
 	.s_register	= ov2640_s_register,
 #endif
+	.s_power	= ov2640_s_power,
 };
 
 static int ov2640_g_mbus_config(struct v4l2_subdev *sd,
diff --git a/drivers/media/video/ov5642.c b/drivers/media/video/ov5642.c
index 0bc9331..61824c6 100644
--- a/drivers/media/video/ov5642.c
+++ b/drivers/media/video/ov5642.c
@@ -933,13 +933,17 @@ static int ov5642_g_mbus_config(struct v4l2_subdev *sd,
 
 static int ov5642_s_power(struct v4l2_subdev *sd, int on)
 {
-	struct i2c_client *client;
+	struct i2c_client *client = v4l2_get_subdevdata(sd);
+	struct soc_camera_link *icl = soc_camera_i2c_to_link(client);
 	int ret;
 
 	if (!on)
-		return 0;
+		return soc_camera_power_off(&client->dev, icl);
+
+	ret = soc_camera_power_on(&client->dev, icl);
+	if (ret < 0)
+		return ret;
 
-	client = v4l2_get_subdevdata(sd);
 	ret = ov5642_write_array(client, ov5642_default_regs_init);
 	if (!ret)
 		ret = ov5642_set_resolution(sd);
diff --git a/drivers/media/video/ov6650.c b/drivers/media/video/ov6650.c
index 3e028b1..12d57a5 100644
--- a/drivers/media/video/ov6650.c
+++ b/drivers/media/video/ov6650.c
@@ -432,6 +432,14 @@ static int ov6650_set_register(struct v4l2_subdev *sd,
 }
 #endif
 
+static int ov6650_s_power(struct v4l2_subdev *sd, int on)
+{
+	struct i2c_client *client = v4l2_get_subdevdata(sd);
+	struct soc_camera_link *icl = soc_camera_i2c_to_link(client);
+
+	return soc_camera_set_power(&client->dev, icl, on);
+}
+
 static int ov6650_g_crop(struct v4l2_subdev *sd, struct v4l2_crop *a)
 {
 	struct i2c_client *client = v4l2_get_subdevdata(sd);
@@ -866,6 +874,7 @@ static struct v4l2_subdev_core_ops ov6650_core_ops = {
 	.g_register		= ov6650_get_register,
 	.s_register		= ov6650_set_register,
 #endif
+	.s_power		= ov6650_s_power,
 };
 
 /* Request bus settings on camera side */
diff --git a/drivers/media/video/ov772x.c b/drivers/media/video/ov772x.c
index 6d79b89..a022662 100644
--- a/drivers/media/video/ov772x.c
+++ b/drivers/media/video/ov772x.c
@@ -683,6 +683,14 @@ static int ov772x_s_register(struct v4l2_subdev *sd,
 }
 #endif
 
+static int ov772x_s_power(struct v4l2_subdev *sd, int on)
+{
+	struct i2c_client *client = v4l2_get_subdevdata(sd);
+	struct soc_camera_link *icl = soc_camera_i2c_to_link(client);
+
+	return soc_camera_set_power(&client->dev, icl, on);
+}
+
 static const struct ov772x_win_size *ov772x_select_win(u32 width, u32 height)
 {
 	__u32 diff;
@@ -996,6 +1004,7 @@ static struct v4l2_subdev_core_ops ov772x_subdev_core_ops = {
 	.g_register	= ov772x_g_register,
 	.s_register	= ov772x_s_register,
 #endif
+	.s_power	= ov772x_s_power,
 };
 
 static int ov772x_enum_fmt(struct v4l2_subdev *sd, unsigned int index,
diff --git a/drivers/media/video/ov9640.c b/drivers/media/video/ov9640.c
index 23412de..8c13b3b 100644
--- a/drivers/media/video/ov9640.c
+++ b/drivers/media/video/ov9640.c
@@ -333,6 +333,14 @@ static int ov9640_set_register(struct v4l2_subdev *sd,
 }
 #endif
 
+static int ov9640_s_power(struct v4l2_subdev *sd, int on)
+{
+	struct i2c_client *client = v4l2_get_subdevdata(sd);
+	struct soc_camera_link *icl = soc_camera_i2c_to_link(client);
+
+	return soc_camera_set_power(&client->dev, icl, on);
+}
+
 /* select nearest higher resolution for capture */
 static void ov9640_res_roundup(u32 *width, u32 *height)
 {
@@ -631,7 +639,7 @@ static struct v4l2_subdev_core_ops ov9640_core_ops = {
 	.g_register		= ov9640_get_register,
 	.s_register		= ov9640_set_register,
 #endif
-
+	.s_power		= ov9640_s_power,
 };
 
 /* Request bus settings on camera side */
diff --git a/drivers/media/video/ov9740.c b/drivers/media/video/ov9740.c
index 3eb07c2..10c0ba9 100644
--- a/drivers/media/video/ov9740.c
+++ b/drivers/media/video/ov9740.c
@@ -786,17 +786,27 @@ static int ov9740_g_chip_ident(struct v4l2_subdev *sd,
 
 static int ov9740_s_power(struct v4l2_subdev *sd, int on)
 {
+	struct i2c_client *client = v4l2_get_subdevdata(sd);
+	struct soc_camera_link *icl = soc_camera_i2c_to_link(client);
 	struct ov9740_priv *priv = to_ov9740(sd);
-
-	if (!priv->current_enable)
-		return 0;
+	int ret;
 
 	if (on) {
-		ov9740_s_fmt(sd, &priv->current_mf);
-		ov9740_s_stream(sd, priv->current_enable);
+		ret = soc_camera_power_on(&client->dev, icl);
+		if (ret < 0)
+			return ret;
+
+		if (priv->current_enable) {
+			ov9740_s_fmt(sd, &priv->current_mf);
+			ov9740_s_stream(sd, 1);
+		}
 	} else {
-		ov9740_s_stream(sd, 0);
-		priv->current_enable = true;
+		if (priv->current_enable) {
+			ov9740_s_stream(sd, 0);
+			priv->current_enable = true;
+		}
+
+		soc_camera_power_off(&client->dev, icl);
 	}
 
 	return 0;
diff --git a/drivers/media/video/rj54n1cb0c.c b/drivers/media/video/rj54n1cb0c.c
index f6419b2..ca1cee7 100644
--- a/drivers/media/video/rj54n1cb0c.c
+++ b/drivers/media/video/rj54n1cb0c.c
@@ -1180,6 +1180,14 @@ static int rj54n1_s_register(struct v4l2_subdev *sd,
 }
 #endif
 
+static int rj54n1_s_power(struct v4l2_subdev *sd, int on)
+{
+	struct i2c_client *client = v4l2_get_subdevdata(sd);
+	struct soc_camera_link *icl = soc_camera_i2c_to_link(client);
+
+	return soc_camera_set_power(&client->dev, icl, on);
+}
+
 static int rj54n1_s_ctrl(struct v4l2_ctrl *ctrl)
 {
 	struct rj54n1 *rj54n1 = container_of(ctrl->handler, struct rj54n1, hdl);
@@ -1230,6 +1238,7 @@ static struct v4l2_subdev_core_ops rj54n1_subdev_core_ops = {
 	.g_register	= rj54n1_g_register,
 	.s_register	= rj54n1_s_register,
 #endif
+	.s_power	= rj54n1_s_power,
 };
 
 static int rj54n1_g_mbus_config(struct v4l2_subdev *sd,
diff --git a/drivers/media/video/soc_camera.c b/drivers/media/video/soc_camera.c
index 7bf21da..804de72 100644
--- a/drivers/media/video/soc_camera.c
+++ b/drivers/media/video/soc_camera.c
@@ -50,72 +50,78 @@ static LIST_HEAD(hosts);
 static LIST_HEAD(devices);
 static DEFINE_MUTEX(list_lock);		/* Protects the list of hosts */
 
-static int soc_camera_power_on(struct soc_camera_device *icd,
-			       struct soc_camera_link *icl)
+int soc_camera_power_on(struct device *dev, struct soc_camera_link *icl)
 {
-	struct v4l2_subdev *sd = soc_camera_to_subdev(icd);
 	int ret = regulator_bulk_enable(icl->num_regulators,
 					icl->regulators);
 	if (ret < 0) {
-		dev_err(icd->pdev, "Cannot enable regulators\n");
+		dev_err(dev, "Cannot enable regulators\n");
 		return ret;
 	}
 
 	if (icl->power) {
-		ret = icl->power(icd->control, 1);
+		ret = icl->power(dev, 1);
 		if (ret < 0) {
-			dev_err(icd->pdev,
+			dev_err(dev,
 				"Platform failed to power-on the camera.\n");
-			goto elinkpwr;
+			regulator_bulk_disable(icl->num_regulators,
+					       icl->regulators);
 		}
 	}
 
-	ret = v4l2_subdev_call(sd, core, s_power, 1);
-	if (ret < 0 && ret != -ENOIOCTLCMD && ret != -ENODEV)
-		goto esdpwr;
-
-	return 0;
-
-esdpwr:
-	if (icl->power)
-		icl->power(icd->control, 0);
-elinkpwr:
-	regulator_bulk_disable(icl->num_regulators,
-			       icl->regulators);
 	return ret;
 }
+EXPORT_SYMBOL(soc_camera_power_on);
 
-static int soc_camera_power_off(struct soc_camera_device *icd,
-				struct soc_camera_link *icl)
+int soc_camera_power_off(struct device *dev, struct soc_camera_link *icl)
 {
 	struct v4l2_subdev *sd = soc_camera_to_subdev(icd);
 	int ret = 0;
 	int err;
 
-	err = v4l2_subdev_call(sd, core, s_power, 0);
-	if (err < 0 && err != -ENOIOCTLCMD && err != -ENODEV) {
-		dev_err(icd->pdev, "Subdev failed to power-off the camera.\n");
-		ret = err;
-	}
-
 	if (icl->power) {
-		err = icl->power(icd->control, 0);
+		err = icl->power(dev, 0);
 		if (err < 0) {
-			dev_err(icd->pdev,
+			dev_err(dev,
 				"Platform failed to power-off the camera.\n");
-			ret = ret ? : err;
+			ret = err;
 		}
 	}
 
 	err = regulator_bulk_disable(icl->num_regulators,
 				     icl->regulators);
 	if (err < 0) {
-		dev_err(icd->pdev, "Cannot disable regulators\n");
+		dev_err(dev, "Cannot disable regulators\n");
 		ret = ret ? : err;
 	}
 
 	return ret;
 }
+EXPORT_SYMBOL(soc_camera_power_off);
+
+static int __soc_camera_power_on(struct soc_camera_device *icd)
+{
+	struct v4l2_subdev *sd = soc_camera_to_subdev(icd);
+	int ret;
+
+	ret = v4l2_subdev_call(sd, core, s_power, 1);
+	if (ret < 0 && ret != -ENOIOCTLCMD && ret != -ENODEV)
+		return ret;
+
+	return 0;
+}
+
+static int __soc_camera_power_off(struct soc_camera_device *icd)
+{
+	struct v4l2_subdev *sd = soc_camera_to_subdev(icd);
+	int ret;
+
+	ret = v4l2_subdev_call(sd, core, s_power, 0);
+	if (ret < 0 && ret != -ENOIOCTLCMD && ret != -ENODEV)
+		return ret;
+
+	return 0;
+}
 
 const struct soc_camera_format_xlate *soc_camera_xlate_by_fourcc(
 	struct soc_camera_device *icd, unsigned int fourcc)
@@ -548,7 +554,7 @@ static int soc_camera_open(struct file *file)
 			goto eiciadd;
 		}
 
-		ret = soc_camera_power_on(icd, icl);
+		ret = __soc_camera_power_on(icd);
 		if (ret < 0)
 			goto epower;
 
@@ -590,7 +596,7 @@ einitvb:
 esfmt:
 	pm_runtime_disable(&icd->vdev->dev);
 eresume:
-	soc_camera_power_off(icd, icl);
+	__soc_camera_power_off(icd);
 epower:
 	ici->ops->remove(icd);
 eiciadd:
@@ -607,8 +613,6 @@ static int soc_camera_close(struct file *file)
 
 	icd->use_count--;
 	if (!icd->use_count) {
-		struct soc_camera_link *icl = to_soc_camera_link(icd);
-
 		pm_runtime_suspend(&icd->vdev->dev);
 		pm_runtime_disable(&icd->vdev->dev);
 
@@ -616,7 +620,7 @@ static int soc_camera_close(struct file *file)
 			vb2_queue_release(&icd->vb2_vidq);
 		ici->ops->remove(icd);
 
-		soc_camera_power_off(icd, icl);
+		__soc_camera_power_off(icd);
 	}
 
 	if (icd->streamer == file)
@@ -1075,8 +1079,14 @@ static int soc_camera_probe(struct soc_camera_device *icd)
 	 * subdevice has not been initialised yet. We'll have to call it once
 	 * again after initialisation, even though it shouldn't be needed, we
 	 * don't do any IO here.
+	 *
+	 * The device pointer passed to soc_camera_power_on(), and ultimately to
+	 * the platform callback, should be the subdev physical device. However,
+	 * we have no way to retrieve a pointer to that device here. This isn't
+	 * a real issue, as no platform currently uses the device pointer, and
+	 * this soc_camera_power_on() call will be removed in the next commit.
 	 */
-	ret = soc_camera_power_on(icd, icl);
+	ret = soc_camera_power_on(icd->pdev, icl);
 	if (ret < 0)
 		goto epower;
 
@@ -1149,7 +1159,7 @@ static int soc_camera_probe(struct soc_camera_device *icd)
 
 	ici->ops->remove(icd);
 
-	soc_camera_power_off(icd, icl);
+	__soc_camera_power_off(icd);
 
 	mutex_unlock(&icd->video_lock);
 
@@ -1171,7 +1181,7 @@ eadddev:
 	video_device_release(icd->vdev);
 	icd->vdev = NULL;
 evdc:
-	soc_camera_power_off(icd, icl);
+	__soc_camera_power_off(icd);
 epower:
 	ici->ops->remove(icd);
 eadd:
diff --git a/drivers/media/video/soc_camera_platform.c b/drivers/media/video/soc_camera_platform.c
index f59ccad..7cf7fd1 100644
--- a/drivers/media/video/soc_camera_platform.c
+++ b/drivers/media/video/soc_camera_platform.c
@@ -50,7 +50,16 @@ static int soc_camera_platform_fill_fmt(struct v4l2_subdev *sd,
 	return 0;
 }
 
-static struct v4l2_subdev_core_ops platform_subdev_core_ops;
+static int soc_camera_platform_s_power(struct v4l2_subdev *sd, int on)
+{
+	struct soc_camera_platform_info *p = v4l2_get_subdevdata(sd);
+
+	return soc_camera_set_power(p->icd->control, p->icd->link, on);
+}
+
+static struct v4l2_subdev_core_ops platform_subdev_core_ops = {
+	.s_power = soc_camera_platform_s_power,
+};
 
 static int soc_camera_platform_enum_fmt(struct v4l2_subdev *sd, unsigned int index,
 					enum v4l2_mbus_pixelcode *code)
diff --git a/drivers/media/video/tw9910.c b/drivers/media/video/tw9910.c
index 9f53eac..f283650 100644
--- a/drivers/media/video/tw9910.c
+++ b/drivers/media/video/tw9910.c
@@ -566,6 +566,14 @@ static int tw9910_s_register(struct v4l2_subdev *sd,
 }
 #endif
 
+static int tw9910_s_power(struct v4l2_subdev *sd, int on)
+{
+	struct i2c_client *client = v4l2_get_subdevdata(sd);
+	struct soc_camera_link *icl = soc_camera_i2c_to_link(client);
+
+	return soc_camera_set_power(&client->dev, icl, on);
+}
+
 static int tw9910_set_frame(struct v4l2_subdev *sd, u32 *width, u32 *height)
 {
 	struct i2c_client *client = v4l2_get_subdevdata(sd);
@@ -814,6 +822,7 @@ static struct v4l2_subdev_core_ops tw9910_subdev_core_ops = {
 	.g_register	= tw9910_g_register,
 	.s_register	= tw9910_s_register,
 #endif
+	.s_power	= tw9910_s_power,
 };
 
 static int tw9910_enum_fmt(struct v4l2_subdev *sd, unsigned int index,
diff --git a/include/media/soc_camera.h b/include/media/soc_camera.h
index d865dcf..982bfc9 100644
--- a/include/media/soc_camera.h
+++ b/include/media/soc_camera.h
@@ -254,6 +254,16 @@ unsigned long soc_camera_apply_sensor_flags(struct soc_camera_link *icl,
 unsigned long soc_camera_apply_board_flags(struct soc_camera_link *icl,
 					   const struct v4l2_mbus_config *cfg);
 
+int soc_camera_power_on(struct device *dev, struct soc_camera_link *icl);
+int soc_camera_power_off(struct device *dev, struct soc_camera_link *icl);
+
+static inline int soc_camera_set_power(struct device *dev,
+				       struct soc_camera_link *icl, bool on)
+{
+	return on ? soc_camera_power_on(dev, icl)
+		  : soc_camera_power_off(dev, icl);
+}
+
 /* This is only temporary here - until v4l2-subdev begins to link to video_device */
 #include <linux/i2c.h>
 static inline struct video_device *soc_camera_i2c_to_vdev(const struct i2c_client *client)
-- 
Regards,

Laurent Pinchart

