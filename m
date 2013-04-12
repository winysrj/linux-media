Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.171]:52759 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754533Ab3DLPkw (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 12 Apr 2013 11:40:52 -0400
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: linux-media@vger.kernel.org
Cc: Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Hans Verkuil <hverkuil@xs4all.nl>, linux-sh@vger.kernel.org,
	Magnus Damm <magnus.damm@gmail.com>,
	Sakari Ailus <sakari.ailus@iki.fi>,
	Prabhakar Lad <prabhakar.lad@ti.com>
Subject: [PATCH v9 16/20] soc-camera: switch I2C subdevice drivers to use v4l2-clk
Date: Fri, 12 Apr 2013 17:40:36 +0200
Message-Id: <1365781240-16149-17-git-send-email-g.liakhovetski@gmx.de>
In-Reply-To: <1365781240-16149-1-git-send-email-g.liakhovetski@gmx.de>
References: <1365781240-16149-1-git-send-email-g.liakhovetski@gmx.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Instead of centrally enabling and disabling subdevice master clocks in
soc-camera core, let subdevice drivers do that themselves, using the
V4L2 clock API and soc-camera convenience wrappers.

Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
---
 drivers/media/i2c/soc_camera/imx074.c              |   18 ++-
 drivers/media/i2c/soc_camera/mt9m001.c             |   17 ++-
 drivers/media/i2c/soc_camera/mt9m111.c             |   20 ++-
 drivers/media/i2c/soc_camera/mt9t031.c             |   19 ++-
 drivers/media/i2c/soc_camera/mt9t112.c             |   19 ++-
 drivers/media/i2c/soc_camera/mt9v022.c             |   17 ++-
 drivers/media/i2c/soc_camera/ov2640.c              |   19 ++-
 drivers/media/i2c/soc_camera/ov5642.c              |   20 ++-
 drivers/media/i2c/soc_camera/ov6650.c              |   17 ++-
 drivers/media/i2c/soc_camera/ov772x.c              |   15 ++-
 drivers/media/i2c/soc_camera/ov9640.c              |   17 ++-
 drivers/media/i2c/soc_camera/ov9640.h              |    1 +
 drivers/media/i2c/soc_camera/ov9740.c              |   18 ++-
 drivers/media/i2c/soc_camera/rj54n1cb0c.c          |   17 ++-
 drivers/media/i2c/soc_camera/tw9910.c              |   18 ++-
 drivers/media/platform/soc_camera/soc_camera.c     |  162 +++++++++++++++-----
 .../platform/soc_camera/soc_camera_platform.c      |    2 +-
 include/media/soc_camera.h                         |   13 +-
 18 files changed, 350 insertions(+), 79 deletions(-)

diff --git a/drivers/media/i2c/soc_camera/imx074.c b/drivers/media/i2c/soc_camera/imx074.c
index a2a5cbb..a6a5060 100644
--- a/drivers/media/i2c/soc_camera/imx074.c
+++ b/drivers/media/i2c/soc_camera/imx074.c
@@ -18,6 +18,7 @@
 #include <linux/module.h>
 
 #include <media/soc_camera.h>
+#include <media/v4l2-clk.h>
 #include <media/v4l2-subdev.h>
 #include <media/v4l2-chip-ident.h>
 
@@ -77,6 +78,7 @@ struct imx074_datafmt {
 struct imx074 {
 	struct v4l2_subdev		subdev;
 	const struct imx074_datafmt	*fmt;
+	struct v4l2_clk			*clk;
 };
 
 static const struct imx074_datafmt imx074_colour_fmts[] = {
@@ -272,8 +274,9 @@ static int imx074_s_power(struct v4l2_subdev *sd, int on)
 {
 	struct i2c_client *client = v4l2_get_subdevdata(sd);
 	struct soc_camera_subdev_desc *ssdd = soc_camera_i2c_to_desc(client);
+	struct imx074 *priv = to_imx074(client);
 
-	return soc_camera_set_power(&client->dev, ssdd, on);
+	return soc_camera_set_power(&client->dev, ssdd, priv->clk, on);
 }
 
 static int imx074_g_mbus_config(struct v4l2_subdev *sd,
@@ -431,6 +434,7 @@ static int imx074_probe(struct i2c_client *client,
 	struct imx074 *priv;
 	struct i2c_adapter *adapter = to_i2c_adapter(client->dev.parent);
 	struct soc_camera_subdev_desc *ssdd = soc_camera_i2c_to_desc(client);
+	int ret;
 
 	if (!ssdd) {
 		dev_err(&client->dev, "IMX074: missing platform data!\n");
@@ -451,13 +455,23 @@ static int imx074_probe(struct i2c_client *client,
 
 	priv->fmt	= &imx074_colour_fmts[0];
 
-	return imx074_video_probe(client);
+	priv->clk = v4l2_clk_get(&client->dev, "mclk");
+	if (IS_ERR(priv->clk))
+		return PTR_ERR(priv->clk);
+
+	ret = imx074_video_probe(client);
+	if (ret < 0)
+		v4l2_clk_put(priv->clk);
+
+	return ret;
 }
 
 static int imx074_remove(struct i2c_client *client)
 {
 	struct soc_camera_subdev_desc *ssdd = soc_camera_i2c_to_desc(client);
+	struct imx074 *priv = to_imx074(client);
 
+	v4l2_clk_put(priv->clk);
 	if (ssdd->free_bus)
 		ssdd->free_bus(ssdd);
 
diff --git a/drivers/media/i2c/soc_camera/mt9m001.c b/drivers/media/i2c/soc_camera/mt9m001.c
index dd90898..620f9df 100644
--- a/drivers/media/i2c/soc_camera/mt9m001.c
+++ b/drivers/media/i2c/soc_camera/mt9m001.c
@@ -16,6 +16,7 @@
 
 #include <media/soc_camera.h>
 #include <media/soc_mediabus.h>
+#include <media/v4l2-clk.h>
 #include <media/v4l2-subdev.h>
 #include <media/v4l2-chip-ident.h>
 #include <media/v4l2-ctrls.h>
@@ -94,6 +95,7 @@ struct mt9m001 {
 		struct v4l2_ctrl *exposure;
 	};
 	struct v4l2_rect rect;	/* Sensor window */
+	struct v4l2_clk *clk;
 	const struct mt9m001_datafmt *fmt;
 	const struct mt9m001_datafmt *fmts;
 	int num_fmts;
@@ -381,8 +383,9 @@ static int mt9m001_s_power(struct v4l2_subdev *sd, int on)
 {
 	struct i2c_client *client = v4l2_get_subdevdata(sd);
 	struct soc_camera_subdev_desc *ssdd = soc_camera_i2c_to_desc(client);
+	struct mt9m001 *mt9m001 = to_mt9m001(client);
 
-	return soc_camera_set_power(&client->dev, ssdd, on);
+	return soc_camera_set_power(&client->dev, ssdd, mt9m001->clk, on);
 }
 
 static int mt9m001_g_volatile_ctrl(struct v4l2_ctrl *ctrl)
@@ -710,9 +713,18 @@ static int mt9m001_probe(struct i2c_client *client,
 	mt9m001->rect.width	= MT9M001_MAX_WIDTH;
 	mt9m001->rect.height	= MT9M001_MAX_HEIGHT;
 
+	mt9m001->clk = v4l2_clk_get(&client->dev, "mclk");
+	if (IS_ERR(mt9m001->clk)) {
+		ret = PTR_ERR(mt9m001->clk);
+		goto eclkget;
+	}
+
 	ret = mt9m001_video_probe(ssdd, client);
-	if (ret)
+	if (ret) {
+		v4l2_clk_put(mt9m001->clk);
+eclkget:
 		v4l2_ctrl_handler_free(&mt9m001->hdl);
+	}
 
 	return ret;
 }
@@ -722,6 +734,7 @@ static int mt9m001_remove(struct i2c_client *client)
 	struct mt9m001 *mt9m001 = to_mt9m001(client);
 	struct soc_camera_subdev_desc *ssdd = soc_camera_i2c_to_desc(client);
 
+	v4l2_clk_put(mt9m001->clk);
 	v4l2_device_unregister_subdev(&mt9m001->subdev);
 	v4l2_ctrl_handler_free(&mt9m001->hdl);
 	mt9m001_video_remove(ssdd);
diff --git a/drivers/media/i2c/soc_camera/mt9m111.c b/drivers/media/i2c/soc_camera/mt9m111.c
index 8bd4e0d..5fa9372 100644
--- a/drivers/media/i2c/soc_camera/mt9m111.c
+++ b/drivers/media/i2c/soc_camera/mt9m111.c
@@ -17,6 +17,7 @@
 #include <linux/module.h>
 
 #include <media/soc_camera.h>
+#include <media/v4l2-clk.h>
 #include <media/v4l2-common.h>
 #include <media/v4l2-ctrls.h>
 #include <media/v4l2-chip-ident.h>
@@ -209,6 +210,7 @@ struct mt9m111 {
 			 * from v4l2-chip-ident.h */
 	struct mt9m111_context *ctx;
 	struct v4l2_rect rect;	/* cropping rectangle */
+	struct v4l2_clk *clk;
 	int width;		/* output */
 	int height;		/* sizes */
 	struct mutex power_lock; /* lock to protect power_count */
@@ -801,14 +803,14 @@ static int mt9m111_power_on(struct mt9m111 *mt9m111)
 	struct soc_camera_subdev_desc *ssdd = soc_camera_i2c_to_desc(client);
 	int ret;
 
-	ret = soc_camera_power_on(&client->dev, ssdd);
+	ret = soc_camera_power_on(&client->dev, ssdd, mt9m111->clk);
 	if (ret < 0)
 		return ret;
 
 	ret = mt9m111_resume(mt9m111);
 	if (ret < 0) {
 		dev_err(&client->dev, "Failed to resume the sensor: %d\n", ret);
-		soc_camera_power_off(&client->dev, ssdd);
+		soc_camera_power_off(&client->dev, ssdd, mt9m111->clk);
 	}
 
 	return ret;
@@ -820,7 +822,7 @@ static void mt9m111_power_off(struct mt9m111 *mt9m111)
 	struct soc_camera_subdev_desc *ssdd = soc_camera_i2c_to_desc(client);
 
 	mt9m111_suspend(mt9m111);
-	soc_camera_power_off(&client->dev, ssdd);
+	soc_camera_power_off(&client->dev, ssdd, mt9m111->clk);
 }
 
 static int mt9m111_s_power(struct v4l2_subdev *sd, int on)
@@ -1002,9 +1004,18 @@ static int mt9m111_probe(struct i2c_client *client,
 	mt9m111->lastpage	= -1;
 	mutex_init(&mt9m111->power_lock);
 
+	mt9m111->clk = v4l2_clk_get(&client->dev, "mclk");
+	if (IS_ERR(mt9m111->clk)) {
+		ret = PTR_ERR(mt9m111->clk);
+		goto eclkget;
+	}
+
 	ret = mt9m111_video_probe(client);
-	if (ret)
+	if (ret) {
+		v4l2_clk_put(mt9m111->clk);
+eclkget:
 		v4l2_ctrl_handler_free(&mt9m111->hdl);
+	}
 
 	return ret;
 }
@@ -1013,6 +1024,7 @@ static int mt9m111_remove(struct i2c_client *client)
 {
 	struct mt9m111 *mt9m111 = to_mt9m111(client);
 
+	v4l2_clk_put(mt9m111->clk);
 	v4l2_device_unregister_subdev(&mt9m111->subdev);
 	v4l2_ctrl_handler_free(&mt9m111->hdl);
 
diff --git a/drivers/media/i2c/soc_camera/mt9t031.c b/drivers/media/i2c/soc_camera/mt9t031.c
index 26a15b8..ea791e3 100644
--- a/drivers/media/i2c/soc_camera/mt9t031.c
+++ b/drivers/media/i2c/soc_camera/mt9t031.c
@@ -19,6 +19,7 @@
 
 #include <media/soc_camera.h>
 #include <media/v4l2-chip-ident.h>
+#include <media/v4l2-clk.h>
 #include <media/v4l2-subdev.h>
 #include <media/v4l2-ctrls.h>
 
@@ -76,6 +77,7 @@ struct mt9t031 {
 		struct v4l2_ctrl *exposure;
 	};
 	struct v4l2_rect rect;	/* Sensor window */
+	struct v4l2_clk *clk;
 	int model;	/* V4L2_IDENT_MT9T031* codes from v4l2-chip-ident.h */
 	u16 xskip;
 	u16 yskip;
@@ -610,16 +612,17 @@ static int mt9t031_s_power(struct v4l2_subdev *sd, int on)
 	struct i2c_client *client = v4l2_get_subdevdata(sd);
 	struct soc_camera_subdev_desc *ssdd = soc_camera_i2c_to_desc(client);
 	struct video_device *vdev = soc_camera_i2c_to_vdev(client);
+	struct mt9t031 *mt9t031 = to_mt9t031(client);
 	int ret;
 
 	if (on) {
-		ret = soc_camera_power_on(&client->dev, ssdd);
+		ret = soc_camera_power_on(&client->dev, ssdd, mt9t031->clk);
 		if (ret < 0)
 			return ret;
 		vdev->dev.type = &mt9t031_dev_type;
 	} else {
 		vdev->dev.type = NULL;
-		soc_camera_power_off(&client->dev, ssdd);
+		soc_camera_power_off(&client->dev, ssdd, mt9t031->clk);
 	}
 
 	return 0;
@@ -812,9 +815,18 @@ static int mt9t031_probe(struct i2c_client *client,
 	mt9t031->xskip = 1;
 	mt9t031->yskip = 1;
 
+	mt9t031->clk = v4l2_clk_get(&client->dev, "mclk");
+	if (IS_ERR(mt9t031->clk)) {
+		ret = PTR_ERR(mt9t031->clk);
+		goto eclkget;
+	}
+
 	ret = mt9t031_video_probe(client);
-	if (ret)
+	if (ret) {
+		v4l2_clk_put(mt9t031->clk);
+eclkget:
 		v4l2_ctrl_handler_free(&mt9t031->hdl);
+	}
 
 	return ret;
 }
@@ -823,6 +835,7 @@ static int mt9t031_remove(struct i2c_client *client)
 {
 	struct mt9t031 *mt9t031 = to_mt9t031(client);
 
+	v4l2_clk_put(mt9t031->clk);
 	v4l2_device_unregister_subdev(&mt9t031->subdev);
 	v4l2_ctrl_handler_free(&mt9t031->hdl);
 
diff --git a/drivers/media/i2c/soc_camera/mt9t112.c b/drivers/media/i2c/soc_camera/mt9t112.c
index a7256b7..577cdea 100644
--- a/drivers/media/i2c/soc_camera/mt9t112.c
+++ b/drivers/media/i2c/soc_camera/mt9t112.c
@@ -28,6 +28,7 @@
 #include <media/mt9t112.h>
 #include <media/soc_camera.h>
 #include <media/v4l2-chip-ident.h>
+#include <media/v4l2-clk.h>
 #include <media/v4l2-common.h>
 
 /* you can check PLL/clock info */
@@ -90,6 +91,7 @@ struct mt9t112_priv {
 	struct mt9t112_camera_info	*info;
 	struct i2c_client		*client;
 	struct v4l2_rect		 frame;
+	struct v4l2_clk			*clk;
 	const struct mt9t112_format	*format;
 	int				 model;
 	int				 num_formats;
@@ -781,8 +783,9 @@ static int mt9t112_s_power(struct v4l2_subdev *sd, int on)
 {
 	struct i2c_client *client = v4l2_get_subdevdata(sd);
 	struct soc_camera_subdev_desc *ssdd = soc_camera_i2c_to_desc(client);
+	struct mt9t112_priv *priv = to_mt9t112(client);
 
-	return soc_camera_set_power(&client->dev, ssdd, on);
+	return soc_camera_set_power(&client->dev, ssdd, priv->clk, on);
 }
 
 static struct v4l2_subdev_core_ops mt9t112_subdev_core_ops = {
@@ -1108,18 +1111,26 @@ static int mt9t112_probe(struct i2c_client *client,
 
 	v4l2_i2c_subdev_init(&priv->subdev, client, &mt9t112_subdev_ops);
 
+	priv->clk = v4l2_clk_get(&client->dev, "mclk");
+	if (IS_ERR(priv->clk))
+		return PTR_ERR(priv->clk);
+
 	ret = mt9t112_camera_probe(client);
-	if (ret)
-		return ret;
 
 	/* Cannot fail: using the default supported pixel code */
-	mt9t112_set_params(priv, &rect, V4L2_MBUS_FMT_UYVY8_2X8);
+	if (!ret)
+		mt9t112_set_params(priv, &rect, V4L2_MBUS_FMT_UYVY8_2X8);
+	else
+		v4l2_clk_put(priv->clk);
 
 	return ret;
 }
 
 static int mt9t112_remove(struct i2c_client *client)
 {
+	struct mt9t112_priv *priv = to_mt9t112(client);
+
+	v4l2_clk_put(priv->clk);
 	return 0;
 }
 
diff --git a/drivers/media/i2c/soc_camera/mt9v022.c b/drivers/media/i2c/soc_camera/mt9v022.c
index a295e59..3164f56 100644
--- a/drivers/media/i2c/soc_camera/mt9v022.c
+++ b/drivers/media/i2c/soc_camera/mt9v022.c
@@ -20,6 +20,7 @@
 #include <media/soc_mediabus.h>
 #include <media/v4l2-subdev.h>
 #include <media/v4l2-chip-ident.h>
+#include <media/v4l2-clk.h>
 #include <media/v4l2-ctrls.h>
 
 /*
@@ -149,6 +150,7 @@ struct mt9v022 {
 	struct v4l2_ctrl *hblank;
 	struct v4l2_ctrl *vblank;
 	struct v4l2_rect rect;	/* Sensor window */
+	struct v4l2_clk *clk;
 	const struct mt9v022_datafmt *fmt;
 	const struct mt9v022_datafmt *fmts;
 	const struct mt9v02x_register *reg;
@@ -518,8 +520,9 @@ static int mt9v022_s_power(struct v4l2_subdev *sd, int on)
 {
 	struct i2c_client *client = v4l2_get_subdevdata(sd);
 	struct soc_camera_subdev_desc *ssdd = soc_camera_i2c_to_desc(client);
+	struct mt9v022 *mt9v022 = to_mt9v022(client);
 
-	return soc_camera_set_power(&client->dev, ssdd, on);
+	return soc_camera_set_power(&client->dev, ssdd, mt9v022->clk, on);
 }
 
 static int mt9v022_g_volatile_ctrl(struct v4l2_ctrl *ctrl)
@@ -957,9 +960,18 @@ static int mt9v022_probe(struct i2c_client *client,
 	mt9v022->rect.width	= MT9V022_MAX_WIDTH;
 	mt9v022->rect.height	= MT9V022_MAX_HEIGHT;
 
+	mt9v022->clk = v4l2_clk_get(&client->dev, "mclk");
+	if (IS_ERR(mt9v022->clk)) {
+		ret = PTR_ERR(mt9v022->clk);
+		goto eclkget;
+	}
+
 	ret = mt9v022_video_probe(client);
-	if (ret)
+	if (ret) {
+		v4l2_clk_put(mt9v022->clk);
+eclkget:
 		v4l2_ctrl_handler_free(&mt9v022->hdl);
+	}
 
 	return ret;
 }
@@ -969,6 +981,7 @@ static int mt9v022_remove(struct i2c_client *client)
 	struct mt9v022 *mt9v022 = to_mt9v022(client);
 	struct soc_camera_subdev_desc *ssdd = soc_camera_i2c_to_desc(client);
 
+	v4l2_clk_put(mt9v022->clk);
 	v4l2_device_unregister_subdev(&mt9v022->subdev);
 	if (ssdd->free_bus)
 		ssdd->free_bus(ssdd);
diff --git a/drivers/media/i2c/soc_camera/ov2640.c b/drivers/media/i2c/soc_camera/ov2640.c
index e316842..0c97b8c 100644
--- a/drivers/media/i2c/soc_camera/ov2640.c
+++ b/drivers/media/i2c/soc_camera/ov2640.c
@@ -23,6 +23,7 @@
 
 #include <media/soc_camera.h>
 #include <media/v4l2-chip-ident.h>
+#include <media/v4l2-clk.h>
 #include <media/v4l2-subdev.h>
 #include <media/v4l2-ctrls.h>
 
@@ -303,6 +304,7 @@ struct ov2640_priv {
 	struct v4l2_subdev		subdev;
 	struct v4l2_ctrl_handler	hdl;
 	enum v4l2_mbus_pixelcode	cfmt_code;
+	struct v4l2_clk			*clk;
 	const struct ov2640_win_size	*win;
 	int				model;
 };
@@ -772,8 +774,9 @@ static int ov2640_s_power(struct v4l2_subdev *sd, int on)
 {
 	struct i2c_client *client = v4l2_get_subdevdata(sd);
 	struct soc_camera_subdev_desc *ssdd = soc_camera_i2c_to_desc(client);
+	struct ov2640_priv *priv = to_ov2640(client);
 
-	return soc_camera_set_power(&client->dev, ssdd, on);
+	return soc_camera_set_power(&client->dev, ssdd, priv->clk, on);
 }
 
 /* Select the nearest higher resolution for capture */
@@ -1113,11 +1116,20 @@ static int ov2640_probe(struct i2c_client *client,
 	if (priv->hdl.error)
 		return priv->hdl.error;
 
+	priv->clk = v4l2_clk_get(&client->dev, "mclk");
+	if (IS_ERR(priv->clk)) {
+		ret = PTR_ERR(priv->clk);
+		goto eclkget;
+	}
+
 	ret = ov2640_video_probe(client);
-	if (ret)
+	if (ret) {
+		v4l2_clk_put(priv->clk);
+eclkget:
 		v4l2_ctrl_handler_free(&priv->hdl);
-	else
+	} else {
 		dev_info(&adapter->dev, "OV2640 Probed\n");
+	}
 
 	return ret;
 }
@@ -1126,6 +1138,7 @@ static int ov2640_remove(struct i2c_client *client)
 {
 	struct ov2640_priv       *priv = to_ov2640(client);
 
+	v4l2_clk_put(priv->clk);
 	v4l2_device_unregister_subdev(&priv->subdev);
 	v4l2_ctrl_handler_free(&priv->hdl);
 	return 0;
diff --git a/drivers/media/i2c/soc_camera/ov5642.c b/drivers/media/i2c/soc_camera/ov5642.c
index 9aa56de..8ffc8f9 100644
--- a/drivers/media/i2c/soc_camera/ov5642.c
+++ b/drivers/media/i2c/soc_camera/ov5642.c
@@ -25,6 +25,7 @@
 
 #include <media/soc_camera.h>
 #include <media/v4l2-chip-ident.h>
+#include <media/v4l2-clk.h>
 #include <media/v4l2-subdev.h>
 
 /* OV5642 registers */
@@ -610,6 +611,7 @@ struct ov5642 {
 	struct v4l2_subdev		subdev;
 	const struct ov5642_datafmt	*fmt;
 	struct v4l2_rect                crop_rect;
+	struct v4l2_clk			*clk;
 
 	/* blanking information */
 	int total_width;
@@ -935,12 +937,13 @@ static int ov5642_s_power(struct v4l2_subdev *sd, int on)
 {
 	struct i2c_client *client = v4l2_get_subdevdata(sd);
 	struct soc_camera_subdev_desc *ssdd = soc_camera_i2c_to_desc(client);
+	struct ov5642 *priv = to_ov5642(client);
 	int ret;
 
 	if (!on)
-		return soc_camera_power_off(&client->dev, ssdd);
+		return soc_camera_power_off(&client->dev, ssdd, priv->clk);
 
-	ret = soc_camera_power_on(&client->dev, ssdd);
+	ret = soc_camera_power_on(&client->dev, ssdd, priv->clk);
 	if (ret < 0)
 		return ret;
 
@@ -1021,6 +1024,7 @@ static int ov5642_probe(struct i2c_client *client,
 {
 	struct ov5642 *priv;
 	struct soc_camera_subdev_desc *ssdd = soc_camera_i2c_to_desc(client);
+	int ret;
 
 	if (!ssdd) {
 		dev_err(&client->dev, "OV5642: missing platform data!\n");
@@ -1042,13 +1046,23 @@ static int ov5642_probe(struct i2c_client *client,
 	priv->total_width = OV5642_DEFAULT_WIDTH + BLANKING_EXTRA_WIDTH;
 	priv->total_height = BLANKING_MIN_HEIGHT;
 
-	return ov5642_video_probe(client);
+	priv->clk = v4l2_clk_get(&client->dev, "mclk");
+	if (IS_ERR(priv->clk))
+		return PTR_ERR(priv->clk);
+
+	ret = ov5642_video_probe(client);
+	if (ret < 0)
+		v4l2_clk_put(priv->clk);
+
+	return ret;
 }
 
 static int ov5642_remove(struct i2c_client *client)
 {
 	struct soc_camera_subdev_desc *ssdd = soc_camera_i2c_to_desc(client);
+	struct ov5642 *priv = to_ov5642(client);
 
+	v4l2_clk_put(priv->clk);
 	if (ssdd->free_bus)
 		ssdd->free_bus(ssdd);
 
diff --git a/drivers/media/i2c/soc_camera/ov6650.c b/drivers/media/i2c/soc_camera/ov6650.c
index 991202d..2389aa2 100644
--- a/drivers/media/i2c/soc_camera/ov6650.c
+++ b/drivers/media/i2c/soc_camera/ov6650.c
@@ -33,6 +33,7 @@
 
 #include <media/soc_camera.h>
 #include <media/v4l2-chip-ident.h>
+#include <media/v4l2-clk.h>
 #include <media/v4l2-ctrls.h>
 
 /* Register definitions */
@@ -196,6 +197,7 @@ struct ov6650 {
 		struct v4l2_ctrl *blue;
 		struct v4l2_ctrl *red;
 	};
+	struct v4l2_clk		*clk;
 	bool			half_scale;	/* scale down output by 2 */
 	struct v4l2_rect	rect;		/* sensor cropping window */
 	unsigned long		pclk_limit;	/* from host */
@@ -436,8 +438,9 @@ static int ov6650_s_power(struct v4l2_subdev *sd, int on)
 {
 	struct i2c_client *client = v4l2_get_subdevdata(sd);
 	struct soc_camera_subdev_desc *ssdd = soc_camera_i2c_to_desc(client);
+	struct ov6650 *priv = to_ov6650(client);
 
-	return soc_camera_set_power(&client->dev, ssdd, on);
+	return soc_camera_set_power(&client->dev, ssdd, priv->clk, on);
 }
 
 static int ov6650_g_crop(struct v4l2_subdev *sd, struct v4l2_crop *a)
@@ -1025,9 +1028,18 @@ static int ov6650_probe(struct i2c_client *client,
 	priv->code	  = V4L2_MBUS_FMT_YUYV8_2X8;
 	priv->colorspace  = V4L2_COLORSPACE_JPEG;
 
+	priv->clk = v4l2_clk_get(&client->dev, "mclk");
+	if (IS_ERR(priv->clk)) {
+		ret = PTR_ERR(priv->clk);
+		goto eclkget;
+	}
+
 	ret = ov6650_video_probe(client);
-	if (ret)
+	if (ret) {
+		v4l2_clk_put(priv->clk);
+eclkget:
 		v4l2_ctrl_handler_free(&priv->hdl);
+	}
 
 	return ret;
 }
@@ -1036,6 +1048,7 @@ static int ov6650_remove(struct i2c_client *client)
 {
 	struct ov6650 *priv = to_ov6650(client);
 
+	v4l2_clk_put(priv->clk);
 	v4l2_device_unregister_subdev(&priv->subdev);
 	v4l2_ctrl_handler_free(&priv->hdl);
 	return 0;
diff --git a/drivers/media/i2c/soc_camera/ov772x.c b/drivers/media/i2c/soc_camera/ov772x.c
index 713d62e..d643b69 100644
--- a/drivers/media/i2c/soc_camera/ov772x.c
+++ b/drivers/media/i2c/soc_camera/ov772x.c
@@ -26,6 +26,7 @@
 
 #include <media/ov772x.h>
 #include <media/soc_camera.h>
+#include <media/v4l2-clk.h>
 #include <media/v4l2-ctrls.h>
 #include <media/v4l2-chip-ident.h>
 #include <media/v4l2-subdev.h>
@@ -396,6 +397,7 @@ struct ov772x_win_size {
 struct ov772x_priv {
 	struct v4l2_subdev                subdev;
 	struct v4l2_ctrl_handler	  hdl;
+	struct v4l2_clk			 *clk;
 	struct ov772x_camera_info        *info;
 	const struct ov772x_color_format *cfmt;
 	const struct ov772x_win_size     *win;
@@ -668,8 +670,9 @@ static int ov772x_s_power(struct v4l2_subdev *sd, int on)
 {
 	struct i2c_client *client = v4l2_get_subdevdata(sd);
 	struct soc_camera_subdev_desc *ssdd = soc_camera_i2c_to_desc(client);
+	struct ov772x_priv *priv = to_ov772x(sd);
 
-	return soc_camera_set_power(&client->dev, ssdd, on);
+	return soc_camera_set_power(&client->dev, ssdd, priv->clk, on);
 }
 
 static const struct ov772x_win_size *ov772x_select_win(u32 width, u32 height)
@@ -1088,13 +1091,22 @@ static int ov772x_probe(struct i2c_client *client,
 	if (priv->hdl.error)
 		return priv->hdl.error;
 
+	priv->clk = v4l2_clk_get(&client->dev, "mclk");
+	if (IS_ERR(priv->clk)) {
+		ret = PTR_ERR(priv->clk);
+		goto eclkget;
+	}
+
 	ret = ov772x_video_probe(priv);
 	if (ret < 0) {
+		v4l2_clk_put(priv->clk);
+eclkget:
 		v4l2_ctrl_handler_free(&priv->hdl);
 	} else {
 		priv->cfmt = &ov772x_cfmts[0];
 		priv->win = &ov772x_win_sizes[0];
 	}
+
 	return ret;
 }
 
@@ -1102,6 +1114,7 @@ static int ov772x_remove(struct i2c_client *client)
 {
 	struct ov772x_priv *priv = to_ov772x(i2c_get_clientdata(client));
 
+	v4l2_clk_put(priv->clk);
 	v4l2_device_unregister_subdev(&priv->subdev);
 	v4l2_ctrl_handler_free(&priv->hdl);
 	return 0;
diff --git a/drivers/media/i2c/soc_camera/ov9640.c b/drivers/media/i2c/soc_camera/ov9640.c
index 20ca62d..f4d09f7 100644
--- a/drivers/media/i2c/soc_camera/ov9640.c
+++ b/drivers/media/i2c/soc_camera/ov9640.c
@@ -29,6 +29,7 @@
 
 #include <media/soc_camera.h>
 #include <media/v4l2-chip-ident.h>
+#include <media/v4l2-clk.h>
 #include <media/v4l2-common.h>
 #include <media/v4l2-ctrls.h>
 
@@ -337,8 +338,9 @@ static int ov9640_s_power(struct v4l2_subdev *sd, int on)
 {
 	struct i2c_client *client = v4l2_get_subdevdata(sd);
 	struct soc_camera_subdev_desc *ssdd = soc_camera_i2c_to_desc(client);
+	struct ov9640_priv *priv = to_ov9640_sensor(sd);
 
-	return soc_camera_set_power(&client->dev, ssdd, on);
+	return soc_camera_set_power(&client->dev, ssdd, priv->clk, on);
 }
 
 /* select nearest higher resolution for capture */
@@ -716,10 +718,18 @@ static int ov9640_probe(struct i2c_client *client,
 	if (priv->hdl.error)
 		return priv->hdl.error;
 
-	ret = ov9640_video_probe(client);
+	priv->clk = v4l2_clk_get(&client->dev, "mclk");
+	if (IS_ERR(priv->clk)) {
+		ret = PTR_ERR(priv->clk);
+		goto eclkget;
+	}
 
-	if (ret)
+	ret = ov9640_video_probe(client);
+	if (ret) {
+		v4l2_clk_put(priv->clk);
+eclkget:
 		v4l2_ctrl_handler_free(&priv->hdl);
+	}
 
 	return ret;
 }
@@ -729,6 +739,7 @@ static int ov9640_remove(struct i2c_client *client)
 	struct v4l2_subdev *sd = i2c_get_clientdata(client);
 	struct ov9640_priv *priv = to_ov9640_sensor(sd);
 
+	v4l2_clk_put(priv->clk);
 	v4l2_device_unregister_subdev(&priv->subdev);
 	v4l2_ctrl_handler_free(&priv->hdl);
 	return 0;
diff --git a/drivers/media/i2c/soc_camera/ov9640.h b/drivers/media/i2c/soc_camera/ov9640.h
index 6b33a97..65d13ff 100644
--- a/drivers/media/i2c/soc_camera/ov9640.h
+++ b/drivers/media/i2c/soc_camera/ov9640.h
@@ -199,6 +199,7 @@ struct ov9640_reg {
 struct ov9640_priv {
 	struct v4l2_subdev		subdev;
 	struct v4l2_ctrl_handler	hdl;
+	struct v4l2_clk			*clk;
 
 	int				model;
 	int				revision;
diff --git a/drivers/media/i2c/soc_camera/ov9740.c b/drivers/media/i2c/soc_camera/ov9740.c
index 012bd62..6a5e164 100644
--- a/drivers/media/i2c/soc_camera/ov9740.c
+++ b/drivers/media/i2c/soc_camera/ov9740.c
@@ -18,6 +18,7 @@
 
 #include <media/soc_camera.h>
 #include <media/v4l2-chip-ident.h>
+#include <media/v4l2-clk.h>
 #include <media/v4l2-ctrls.h>
 
 #define to_ov9740(sd)		container_of(sd, struct ov9740_priv, subdev)
@@ -196,6 +197,7 @@ struct ov9740_reg {
 struct ov9740_priv {
 	struct v4l2_subdev		subdev;
 	struct v4l2_ctrl_handler	hdl;
+	struct v4l2_clk			*clk;
 
 	int				ident;
 	u16				model;
@@ -792,7 +794,7 @@ static int ov9740_s_power(struct v4l2_subdev *sd, int on)
 	int ret;
 
 	if (on) {
-		ret = soc_camera_power_on(&client->dev, ssdd);
+		ret = soc_camera_power_on(&client->dev, ssdd, priv->clk);
 		if (ret < 0)
 			return ret;
 
@@ -806,7 +808,7 @@ static int ov9740_s_power(struct v4l2_subdev *sd, int on)
 			priv->current_enable = true;
 		}
 
-		soc_camera_power_off(&client->dev, ssdd);
+		soc_camera_power_off(&client->dev, ssdd, priv->clk);
 	}
 
 	return 0;
@@ -975,9 +977,18 @@ static int ov9740_probe(struct i2c_client *client,
 	if (priv->hdl.error)
 		return priv->hdl.error;
 
+	priv->clk = v4l2_clk_get(&client->dev, "mclk");
+	if (IS_ERR(priv->clk)) {
+		ret = PTR_ERR(priv->clk);
+		goto eclkget;
+	}
+
 	ret = ov9740_video_probe(client);
-	if (ret < 0)
+	if (ret < 0) {
+		v4l2_clk_put(priv->clk);
+eclkget:
 		v4l2_ctrl_handler_free(&priv->hdl);
+	}
 
 	return ret;
 }
@@ -986,6 +997,7 @@ static int ov9740_remove(struct i2c_client *client)
 {
 	struct ov9740_priv *priv = i2c_get_clientdata(client);
 
+	v4l2_clk_put(priv->clk);
 	v4l2_device_unregister_subdev(&priv->subdev);
 	v4l2_ctrl_handler_free(&priv->hdl);
 	return 0;
diff --git a/drivers/media/i2c/soc_camera/rj54n1cb0c.c b/drivers/media/i2c/soc_camera/rj54n1cb0c.c
index 1f9ec3b..93db388 100644
--- a/drivers/media/i2c/soc_camera/rj54n1cb0c.c
+++ b/drivers/media/i2c/soc_camera/rj54n1cb0c.c
@@ -17,6 +17,7 @@
 
 #include <media/rj54n1cb0c.h>
 #include <media/soc_camera.h>
+#include <media/v4l2-clk.h>
 #include <media/v4l2-subdev.h>
 #include <media/v4l2-chip-ident.h>
 #include <media/v4l2-ctrls.h>
@@ -151,6 +152,7 @@ struct rj54n1_clock_div {
 struct rj54n1 {
 	struct v4l2_subdev subdev;
 	struct v4l2_ctrl_handler hdl;
+	struct v4l2_clk *clk;
 	struct rj54n1_clock_div clk_div;
 	const struct rj54n1_datafmt *fmt;
 	struct v4l2_rect rect;	/* Sensor window */
@@ -1184,8 +1186,9 @@ static int rj54n1_s_power(struct v4l2_subdev *sd, int on)
 {
 	struct i2c_client *client = v4l2_get_subdevdata(sd);
 	struct soc_camera_subdev_desc *ssdd = soc_camera_i2c_to_desc(client);
+	struct rj54n1 *rj54n1 = to_rj54n1(client);
 
-	return soc_camera_set_power(&client->dev, ssdd, on);
+	return soc_camera_set_power(&client->dev, ssdd, rj54n1->clk, on);
 }
 
 static int rj54n1_s_ctrl(struct v4l2_ctrl *ctrl)
@@ -1382,9 +1385,18 @@ static int rj54n1_probe(struct i2c_client *client,
 	rj54n1->tgclk_mhz	= (rj54n1_priv->mclk_freq / PLL_L * PLL_N) /
 		(clk_div.ratio_tg + 1) / (clk_div.ratio_t + 1);
 
+	rj54n1->clk = v4l2_clk_get(&client->dev, "mclk");
+	if (IS_ERR(rj54n1->clk)) {
+		ret = PTR_ERR(rj54n1->clk);
+		goto eclkget;
+	}
+
 	ret = rj54n1_video_probe(client, rj54n1_priv);
-	if (ret < 0)
+	if (ret < 0) {
+		v4l2_clk_put(rj54n1->clk);
+eclkget:
 		v4l2_ctrl_handler_free(&rj54n1->hdl);
+	}
 
 	return ret;
 }
@@ -1394,6 +1406,7 @@ static int rj54n1_remove(struct i2c_client *client)
 	struct rj54n1 *rj54n1 = to_rj54n1(client);
 	struct soc_camera_subdev_desc *ssdd = soc_camera_i2c_to_desc(client);
 
+	v4l2_clk_put(rj54n1->clk);
 	v4l2_device_unregister_subdev(&rj54n1->subdev);
 	if (ssdd->free_bus)
 		ssdd->free_bus(ssdd);
diff --git a/drivers/media/i2c/soc_camera/tw9910.c b/drivers/media/i2c/soc_camera/tw9910.c
index bad90b1..fe43591 100644
--- a/drivers/media/i2c/soc_camera/tw9910.c
+++ b/drivers/media/i2c/soc_camera/tw9910.c
@@ -28,6 +28,7 @@
 #include <media/soc_camera.h>
 #include <media/tw9910.h>
 #include <media/v4l2-chip-ident.h>
+#include <media/v4l2-clk.h>
 #include <media/v4l2-subdev.h>
 
 #define GET_ID(val)  ((val & 0xF8) >> 3)
@@ -228,6 +229,7 @@ struct tw9910_scale_ctrl {
 
 struct tw9910_priv {
 	struct v4l2_subdev		subdev;
+	struct v4l2_clk			*clk;
 	struct tw9910_video_info	*info;
 	const struct tw9910_scale_ctrl	*scale;
 	v4l2_std_id			norm;
@@ -570,8 +572,9 @@ static int tw9910_s_power(struct v4l2_subdev *sd, int on)
 {
 	struct i2c_client *client = v4l2_get_subdevdata(sd);
 	struct soc_camera_subdev_desc *ssdd = soc_camera_i2c_to_desc(client);
+	struct tw9910_priv *priv = to_tw9910(client);
 
-	return soc_camera_set_power(&client->dev, ssdd, on);
+	return soc_camera_set_power(&client->dev, ssdd, priv->clk, on);
 }
 
 static int tw9910_set_frame(struct v4l2_subdev *sd, u32 *width, u32 *height)
@@ -912,6 +915,7 @@ static int tw9910_probe(struct i2c_client *client,
 	struct i2c_adapter		*adapter =
 		to_i2c_adapter(client->dev.parent);
 	struct soc_camera_subdev_desc	*ssdd = soc_camera_i2c_to_desc(client);
+	int ret;
 
 	if (!ssdd || !ssdd->drv_priv) {
 		dev_err(&client->dev, "TW9910: missing platform data!\n");
@@ -935,11 +939,21 @@ static int tw9910_probe(struct i2c_client *client,
 
 	v4l2_i2c_subdev_init(&priv->subdev, client, &tw9910_subdev_ops);
 
-	return tw9910_video_probe(client);
+	priv->clk = v4l2_clk_get(&client->dev, "mclk");
+	if (IS_ERR(priv->clk))
+		return PTR_ERR(priv->clk);
+
+	ret = tw9910_video_probe(client);
+	if (ret < 0)
+		v4l2_clk_put(priv->clk);
+
+	return ret;
 }
 
 static int tw9910_remove(struct i2c_client *client)
 {
+	struct tw9910_priv *priv = to_tw9910(client);
+	v4l2_clk_put(priv->clk);
 	return 0;
 }
 
diff --git a/drivers/media/platform/soc_camera/soc_camera.c b/drivers/media/platform/soc_camera/soc_camera.c
index f693817..cfcdabe 100644
--- a/drivers/media/platform/soc_camera/soc_camera.c
+++ b/drivers/media/platform/soc_camera/soc_camera.c
@@ -30,6 +30,7 @@
 #include <linux/vmalloc.h>
 
 #include <media/soc_camera.h>
+#include <media/v4l2-clk.h>
 #include <media/v4l2-common.h>
 #include <media/v4l2-ioctl.h>
 #include <media/v4l2-dev.h>
@@ -50,13 +51,19 @@ static LIST_HEAD(hosts);
 static LIST_HEAD(devices);
 static DEFINE_MUTEX(list_lock);		/* Protects the list of hosts */
 
-int soc_camera_power_on(struct device *dev, struct soc_camera_subdev_desc *ssdd)
+int soc_camera_power_on(struct device *dev, struct soc_camera_subdev_desc *ssdd,
+			struct v4l2_clk *clk)
 {
-	int ret = regulator_bulk_enable(ssdd->num_regulators,
+	int ret = clk ? v4l2_clk_enable(clk) : 0;
+	if (ret < 0) {
+		dev_err(dev, "Cannot enable clock\n");
+		return ret;
+	}
+	ret = regulator_bulk_enable(ssdd->num_regulators,
 					ssdd->regulators);
 	if (ret < 0) {
 		dev_err(dev, "Cannot enable regulators\n");
-		return ret;
+		goto eregenable;;
 	}
 
 	if (ssdd->power) {
@@ -64,16 +71,25 @@ int soc_camera_power_on(struct device *dev, struct soc_camera_subdev_desc *ssdd)
 		if (ret < 0) {
 			dev_err(dev,
 				"Platform failed to power-on the camera.\n");
-			regulator_bulk_disable(ssdd->num_regulators,
-					       ssdd->regulators);
+			goto epwron;
 		}
 	}
 
+	return 0;
+
+epwron:
+	regulator_bulk_disable(ssdd->num_regulators,
+			       ssdd->regulators);
+eregenable:
+	if (clk)
+		v4l2_clk_disable(clk);
+
 	return ret;
 }
 EXPORT_SYMBOL(soc_camera_power_on);
 
-int soc_camera_power_off(struct device *dev, struct soc_camera_subdev_desc *ssdd)
+int soc_camera_power_off(struct device *dev, struct soc_camera_subdev_desc *ssdd,
+			 struct v4l2_clk *clk)
 {
 	int ret = 0;
 	int err;
@@ -94,6 +110,9 @@ int soc_camera_power_off(struct device *dev, struct soc_camera_subdev_desc *ssdd
 		ret = ret ? : err;
 	}
 
+	if (clk)
+		v4l2_clk_disable(clk);
+
 	return ret;
 }
 EXPORT_SYMBOL(soc_camera_power_off);
@@ -513,9 +532,11 @@ static int soc_camera_add_device(struct soc_camera_device *icd)
 	if (ici->icd)
 		return -EBUSY;
 
-	ret = ici->ops->clock_start(ici);
-	if (ret < 0)
-		return ret;
+	if (!icd->clk) {
+		ret = ici->ops->clock_start(ici);
+		if (ret < 0)
+			return ret;
+	}
 
 	if (ici->ops->add) {
 		ret = ici->ops->add(icd);
@@ -528,7 +549,8 @@ static int soc_camera_add_device(struct soc_camera_device *icd)
 	return 0;
 
 eadd:
-	ici->ops->clock_stop(ici);
+	if (!icd->clk)
+		ici->ops->clock_stop(ici);
 	return ret;
 }
 
@@ -541,7 +563,8 @@ static void soc_camera_remove_device(struct soc_camera_device *icd)
 
 	if (ici->ops->remove)
 		ici->ops->remove(icd);
-	ici->ops->clock_stop(ici);
+	if (!icd->clk)
+		ici->ops->clock_stop(ici);
 	ici->icd = NULL;
 }
 
@@ -1124,6 +1147,57 @@ static void scan_add_host(struct soc_camera_host *ici)
 	mutex_unlock(&list_lock);
 }
 
+/*
+ * It is invalid to call v4l2_clk_enable() after a successful probing
+ * asynchronously outside of V4L2 operations, i.e. with .host_lock not held.
+ */
+static int soc_camera_clk_enable(struct v4l2_clk *clk)
+{
+	struct soc_camera_device *icd = clk->priv;
+	struct soc_camera_host *ici;
+
+	if (!icd || !icd->parent)
+		return -ENODEV;
+
+	ici = to_soc_camera_host(icd->parent);
+
+	if (!try_module_get(ici->ops->owner))
+		return -ENODEV;
+
+	/*
+	 * If a different client is currently being probed, the host will tell
+	 * you to go
+	 */
+	return ici->ops->clock_start(ici);
+}
+
+static void soc_camera_clk_disable(struct v4l2_clk *clk)
+{
+	struct soc_camera_device *icd = clk->priv;
+	struct soc_camera_host *ici;
+
+	if (!icd || !icd->parent)
+		return;
+
+	ici = to_soc_camera_host(icd->parent);
+
+	ici->ops->clock_stop(ici);
+
+	module_put(ici->ops->owner);
+}
+
+/*
+ * Eventually, it would be more logical to make the respective host the clock
+ * owner, but then we would have to copy this struct for each ici. Besides, it
+ * would introduce the circular dependency problem, unless we port all client
+ * drivers to release the clock, when not in use.
+ */
+static const struct v4l2_clk_ops soc_camera_clk_ops = {
+	.owner = THIS_MODULE,
+	.enable = soc_camera_clk_enable,
+	.disable = soc_camera_clk_disable,
+};
+
 #ifdef CONFIG_I2C_BOARDINFO
 static int soc_camera_init_i2c(struct soc_camera_device *icd,
 			       struct soc_camera_desc *sdesc)
@@ -1133,19 +1207,32 @@ static int soc_camera_init_i2c(struct soc_camera_device *icd,
 	struct soc_camera_host_desc *shd = &sdesc->host_desc;
 	struct i2c_adapter *adap = i2c_get_adapter(shd->i2c_adapter_id);
 	struct v4l2_subdev *subdev;
+	char clk_name[V4L2_SUBDEV_NAME_SIZE];
+	int ret;
 
 	if (!adap) {
 		dev_err(icd->pdev, "Cannot get I2C adapter #%d. No driver?\n",
 			shd->i2c_adapter_id);
-		goto ei2cga;
+		return -ENODEV;
 	}
 
 	shd->board_info->platform_data = &sdesc->subdev_desc;
 
+	snprintf(clk_name, sizeof(clk_name), "%d-%04x",
+		 shd->i2c_adapter_id, shd->board_info->addr);
+
+	icd->clk = v4l2_clk_register(&soc_camera_clk_ops, clk_name, "mclk", icd);
+	if (IS_ERR(icd->clk)) {
+		ret = PTR_ERR(icd->clk);
+		goto eclkreg;
+	}
+
 	subdev = v4l2_i2c_new_subdev_board(&ici->v4l2_dev, adap,
 				shd->board_info, NULL);
-	if (!subdev)
+	if (!subdev) {
+		ret = -ENODEV;
 		goto ei2cnd;
+	}
 
 	client = v4l2_get_subdevdata(subdev);
 
@@ -1154,9 +1241,11 @@ static int soc_camera_init_i2c(struct soc_camera_device *icd,
 
 	return 0;
 ei2cnd:
+	v4l2_clk_unregister(icd->clk);
+	icd->clk = NULL;
+eclkreg:
 	i2c_put_adapter(adap);
-ei2cga:
-	return -ENODEV;
+	return ret;
 }
 
 static void soc_camera_free_i2c(struct soc_camera_device *icd)
@@ -1169,6 +1258,8 @@ static void soc_camera_free_i2c(struct soc_camera_device *icd)
 	v4l2_device_unregister_subdev(i2c_get_clientdata(client));
 	i2c_unregister_device(client);
 	i2c_put_adapter(adap);
+	v4l2_clk_unregister(icd->clk);
+	icd->clk = NULL;
 }
 #else
 #define soc_camera_init_i2c(icd, sdesc)	(-ENODEV)
@@ -1206,26 +1297,31 @@ static int soc_camera_probe(struct soc_camera_device *icd)
 	if (ssdd->reset)
 		ssdd->reset(icd->pdev);
 
-	mutex_lock(&ici->host_lock);
-	ret = ici->ops->clock_start(ici);
-	mutex_unlock(&ici->host_lock);
-	if (ret < 0)
-		goto eadd;
-
 	/* Must have icd->vdev before registering the device */
 	ret = video_dev_create(icd);
 	if (ret < 0)
 		goto evdc;
 
+	/*
+	 * ..._video_start() will create a device node, video_register_device()
+	 * itself is protected against concurrent open() calls, but we also have
+	 * to protect our data also during client probing.
+	 */
+	mutex_lock(&ici->host_lock);
+
 	/* Non-i2c cameras, e.g., soc_camera_platform, have no board_info */
 	if (shd->board_info) {
 		ret = soc_camera_init_i2c(icd, sdesc);
 		if (ret < 0)
-			goto eadddev;
+			goto eadd;
 	} else if (!shd->add_device || !shd->del_device) {
 		ret = -EINVAL;
-		goto eadddev;
+		goto eadd;
 	} else {
+		ret = ici->ops->clock_start(ici);
+		if (ret < 0)
+			goto eadd;
+
 		if (shd->module_name)
 			ret = request_module(shd->module_name);
 
@@ -1261,13 +1357,6 @@ static int soc_camera_probe(struct soc_camera_device *icd)
 
 	icd->field = V4L2_FIELD_ANY;
 
-	/*
-	 * ..._video_start() will create a device node, video_register_device()
-	 * itself is protected against concurrent open() calls, but we also have
-	 * to protect our data.
-	 */
-	mutex_lock(&ici->host_lock);
-
 	ret = soc_camera_video_start(icd);
 	if (ret < 0)
 		goto evidstart;
@@ -1280,14 +1369,14 @@ static int soc_camera_probe(struct soc_camera_device *icd)
 		icd->field		= mf.field;
 	}
 
-	ici->ops->clock_stop(ici);
+	if (!shd->board_info)
+		ici->ops->clock_stop(ici);
 
 	mutex_unlock(&ici->host_lock);
 
 	return 0;
 
 evidstart:
-	mutex_unlock(&ici->host_lock);
 	soc_camera_free_user_formats(icd);
 eiufmt:
 ectrl:
@@ -1296,16 +1385,15 @@ ectrl:
 	} else {
 		shd->del_device(icd);
 		module_put(control->driver->owner);
-	}
 enodrv:
 eadddev:
+		ici->ops->clock_stop(ici);
+	}
+eadd:
 	video_device_release(icd->vdev);
 	icd->vdev = NULL;
-evdc:
-	mutex_lock(&ici->host_lock);
-	ici->ops->clock_stop(ici);
 	mutex_unlock(&ici->host_lock);
-eadd:
+evdc:
 	v4l2_ctrl_handler_free(&icd->ctrl_handler);
 	return ret;
 }
diff --git a/drivers/media/platform/soc_camera/soc_camera_platform.c b/drivers/media/platform/soc_camera/soc_camera_platform.c
index 1b7a88c..8b7ae85 100644
--- a/drivers/media/platform/soc_camera/soc_camera_platform.c
+++ b/drivers/media/platform/soc_camera/soc_camera_platform.c
@@ -54,7 +54,7 @@ static int soc_camera_platform_s_power(struct v4l2_subdev *sd, int on)
 {
 	struct soc_camera_platform_info *p = v4l2_get_subdevdata(sd);
 
-	return soc_camera_set_power(p->icd->control, &p->icd->sdesc->subdev_desc, on);
+	return soc_camera_set_power(p->icd->control, &p->icd->sdesc->subdev_desc, NULL, on);
 }
 
 static struct v4l2_subdev_core_ops platform_subdev_core_ops = {
diff --git a/include/media/soc_camera.h b/include/media/soc_camera.h
index 64415ee..f8c1ffe 100644
--- a/include/media/soc_camera.h
+++ b/include/media/soc_camera.h
@@ -49,6 +49,7 @@ struct soc_camera_device {
 	/* soc_camera.c private count. Only accessed with .host_lock held */
 	int use_count;
 	struct file *streamer;		/* stream owner */
+	struct v4l2_clk *clk;
 	union {
 		struct videobuf_queue vb_vidq;
 		struct vb2_queue vb2_vidq;
@@ -325,14 +326,16 @@ static inline void soc_camera_limit_side(int *start, int *length,
 unsigned long soc_camera_apply_board_flags(struct soc_camera_subdev_desc *ssdd,
 					   const struct v4l2_mbus_config *cfg);
 
-int soc_camera_power_on(struct device *dev, struct soc_camera_subdev_desc *ssdd);
-int soc_camera_power_off(struct device *dev, struct soc_camera_subdev_desc *ssdd);
+int soc_camera_power_on(struct device *dev, struct soc_camera_subdev_desc *ssdd,
+			struct v4l2_clk *clk);
+int soc_camera_power_off(struct device *dev, struct soc_camera_subdev_desc *ssdd,
+			 struct v4l2_clk *clk);
 
 static inline int soc_camera_set_power(struct device *dev,
-				struct soc_camera_subdev_desc *ssdd, bool on)
+		struct soc_camera_subdev_desc *ssdd, struct v4l2_clk *clk, bool on)
 {
-	return on ? soc_camera_power_on(dev, ssdd)
-		  : soc_camera_power_off(dev, ssdd);
+	return on ? soc_camera_power_on(dev, ssdd, clk)
+		  : soc_camera_power_off(dev, ssdd, clk);
 }
 
 /* This is only temporary here - until v4l2-subdev begins to link to video_device */
-- 
1.7.2.5

