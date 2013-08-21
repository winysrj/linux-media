Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ee0-f48.google.com ([74.125.83.48]:43583 "EHLO
	mail-ee0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752515Ab3HUUnE (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 21 Aug 2013 16:43:04 -0400
Received: by mail-ee0-f48.google.com with SMTP id l10so510876eei.21
        for <linux-media@vger.kernel.org>; Wed, 21 Aug 2013 13:43:03 -0700 (PDT)
From: =?UTF-8?q?Frank=20Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>
To: g.liakhovetski@gmx.de
Cc: m.chehab@samsung.com, hans.verkuil@cisco.com,
	laurent.pinchart@ideasonboard.com, linux-media@vger.kernel.org,
	=?UTF-8?q?Frank=20Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>
Subject: [PATCH RFC] soc_camera: sensors: make v4l2_clk optional
Date: Wed, 21 Aug 2013 22:45:17 +0200
Message-Id: <1377117917-3891-1-git-send-email-fschaefer.oss@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

commit 9aea470b "soc-camera: switch I2C subdevice drivers to use v4l2-clk"
made a v4l2_clk mandatory for each sensor.
While this isn't necessary, it also broke the em28xx driver in connection
with ov2640 subdevices and maybe other drivers outside soc_camera as well.

Signed-off-by: Frank Schäfer <fschaefer.oss@googlemail.com>
---
 drivers/media/i2c/soc_camera/imx074.c     |   12 ++++++------
 drivers/media/i2c/soc_camera/mt9m001.c    |   13 ++++++-------
 drivers/media/i2c/soc_camera/mt9m111.c    |    8 +++++---
 drivers/media/i2c/soc_camera/mt9t031.c    |   13 ++++++-------
 drivers/media/i2c/soc_camera/mt9t112.c    |    7 ++++---
 drivers/media/i2c/soc_camera/mt9v022.c    |   13 ++++++-------
 drivers/media/i2c/soc_camera/ov2640.c     |   13 ++++++-------
 drivers/media/i2c/soc_camera/ov5642.c     |    7 ++++---
 drivers/media/i2c/soc_camera/ov6650.c     |   13 ++++++-------
 drivers/media/i2c/soc_camera/ov772x.c     |   13 ++++++-------
 drivers/media/i2c/soc_camera/ov9640.c     |   13 ++++++-------
 drivers/media/i2c/soc_camera/ov9740.c     |   13 ++++++-------
 drivers/media/i2c/soc_camera/rj54n1cb0c.c |   13 ++++++-------
 drivers/media/i2c/soc_camera/tw9910.c     |    7 ++++---
 14 Dateien geändert, 77 Zeilen hinzugefügt(+), 81 Zeilen entfernt(-)

diff --git a/drivers/media/i2c/soc_camera/imx074.c b/drivers/media/i2c/soc_camera/imx074.c
index 1d384a3..e7b6124 100644
--- a/drivers/media/i2c/soc_camera/imx074.c
+++ b/drivers/media/i2c/soc_camera/imx074.c
@@ -438,10 +438,8 @@ static int imx074_probe(struct i2c_client *client,
 	priv->fmt	= &imx074_colour_fmts[0];
 
 	priv->clk = v4l2_clk_get(&client->dev, "mclk");
-	if (IS_ERR(priv->clk)) {
-		dev_info(&client->dev, "Error %ld getting clock\n", PTR_ERR(priv->clk));
-		return -EPROBE_DEFER;
-	}
+	if (IS_ERR(priv->clk))
+		priv->clk = NULL;
 
 	ret = soc_camera_power_init(&client->dev, ssdd);
 	if (ret < 0)
@@ -455,7 +453,8 @@ static int imx074_probe(struct i2c_client *client,
 
 epwrinit:
 eprobe:
-	v4l2_clk_put(priv->clk);
+	if (priv->clk)
+		v4l2_clk_put(priv->clk);
 	return ret;
 }
 
@@ -465,7 +464,8 @@ static int imx074_remove(struct i2c_client *client)
 	struct imx074 *priv = to_imx074(client);
 
 	v4l2_async_unregister_subdev(&priv->subdev);
-	v4l2_clk_put(priv->clk);
+	if (priv->clk)
+		v4l2_clk_put(priv->clk);
 
 	if (ssdd->free_bus)
 		ssdd->free_bus(ssdd);
diff --git a/drivers/media/i2c/soc_camera/mt9m001.c b/drivers/media/i2c/soc_camera/mt9m001.c
index df97033..07af1bc 100644
--- a/drivers/media/i2c/soc_camera/mt9m001.c
+++ b/drivers/media/i2c/soc_camera/mt9m001.c
@@ -685,15 +685,13 @@ static int mt9m001_probe(struct i2c_client *client,
 	mt9m001->rect.height	= MT9M001_MAX_HEIGHT;
 
 	mt9m001->clk = v4l2_clk_get(&client->dev, "mclk");
-	if (IS_ERR(mt9m001->clk)) {
-		ret = PTR_ERR(mt9m001->clk);
-		goto eclkget;
-	}
+	if (IS_ERR(mt9m001->clk))
+		mt9m001->clk = NULL;
 
 	ret = mt9m001_video_probe(ssdd, client);
 	if (ret) {
-		v4l2_clk_put(mt9m001->clk);
-eclkget:
+		if (mt9m001->clk)
+			v4l2_clk_put(mt9m001->clk);
 		v4l2_ctrl_handler_free(&mt9m001->hdl);
 	}
 
@@ -705,7 +703,8 @@ static int mt9m001_remove(struct i2c_client *client)
 	struct mt9m001 *mt9m001 = to_mt9m001(client);
 	struct soc_camera_subdev_desc *ssdd = soc_camera_i2c_to_desc(client);
 
-	v4l2_clk_put(mt9m001->clk);
+	if (mt9m001->clk)
+		v4l2_clk_put(mt9m001->clk);
 	v4l2_device_unregister_subdev(&mt9m001->subdev);
 	v4l2_ctrl_handler_free(&mt9m001->hdl);
 	mt9m001_video_remove(ssdd);
diff --git a/drivers/media/i2c/soc_camera/mt9m111.c b/drivers/media/i2c/soc_camera/mt9m111.c
index 6f40566..498f22e 100644
--- a/drivers/media/i2c/soc_camera/mt9m111.c
+++ b/drivers/media/i2c/soc_camera/mt9m111.c
@@ -948,7 +948,7 @@ static int mt9m111_probe(struct i2c_client *client,
 
 	mt9m111->clk = v4l2_clk_get(&client->dev, "mclk");
 	if (IS_ERR(mt9m111->clk))
-		return -EPROBE_DEFER;
+		mt9m111->clk = NULL;
 
 	/* Default HIGHPOWER context */
 	mt9m111->ctx = &context_b;
@@ -999,7 +999,8 @@ static int mt9m111_probe(struct i2c_client *client,
 out_hdlfree:
 	v4l2_ctrl_handler_free(&mt9m111->hdl);
 out_clkput:
-	v4l2_clk_put(mt9m111->clk);
+	if (mt9m111->clk)
+		v4l2_clk_put(mt9m111->clk);
 
 	return ret;
 }
@@ -1009,7 +1010,8 @@ static int mt9m111_remove(struct i2c_client *client)
 	struct mt9m111 *mt9m111 = to_mt9m111(client);
 
 	v4l2_async_unregister_subdev(&mt9m111->subdev);
-	v4l2_clk_put(mt9m111->clk);
+	if (mt9m111->clk)
+		v4l2_clk_put(mt9m111->clk);
 	v4l2_device_unregister_subdev(&mt9m111->subdev);
 	v4l2_ctrl_handler_free(&mt9m111->hdl);
 
diff --git a/drivers/media/i2c/soc_camera/mt9t031.c b/drivers/media/i2c/soc_camera/mt9t031.c
index ee7bb0f..3131d36 100644
--- a/drivers/media/i2c/soc_camera/mt9t031.c
+++ b/drivers/media/i2c/soc_camera/mt9t031.c
@@ -792,15 +792,13 @@ static int mt9t031_probe(struct i2c_client *client,
 	mt9t031->yskip = 1;
 
 	mt9t031->clk = v4l2_clk_get(&client->dev, "mclk");
-	if (IS_ERR(mt9t031->clk)) {
-		ret = PTR_ERR(mt9t031->clk);
-		goto eclkget;
-	}
+	if (IS_ERR(mt9t031->clk))
+		mt9t031->clk = NULL;
 
 	ret = mt9t031_video_probe(client);
 	if (ret) {
-		v4l2_clk_put(mt9t031->clk);
-eclkget:
+		if (mt9t031->clk)
+			v4l2_clk_put(mt9t031->clk);
 		v4l2_ctrl_handler_free(&mt9t031->hdl);
 	}
 
@@ -811,7 +809,8 @@ static int mt9t031_remove(struct i2c_client *client)
 {
 	struct mt9t031 *mt9t031 = to_mt9t031(client);
 
-	v4l2_clk_put(mt9t031->clk);
+	if (mt9t031->clk)
+		v4l2_clk_put(mt9t031->clk);
 	v4l2_device_unregister_subdev(&mt9t031->subdev);
 	v4l2_ctrl_handler_free(&mt9t031->hdl);
 
diff --git a/drivers/media/i2c/soc_camera/mt9t112.c b/drivers/media/i2c/soc_camera/mt9t112.c
index 46f431a..0a7d6e7 100644
--- a/drivers/media/i2c/soc_camera/mt9t112.c
+++ b/drivers/media/i2c/soc_camera/mt9t112.c
@@ -1097,14 +1097,14 @@ static int mt9t112_probe(struct i2c_client *client,
 
 	priv->clk = v4l2_clk_get(&client->dev, "mclk");
 	if (IS_ERR(priv->clk))
-		return PTR_ERR(priv->clk);
+		priv->clk = NULL;
 
 	ret = mt9t112_camera_probe(client);
 
 	/* Cannot fail: using the default supported pixel code */
 	if (!ret)
 		mt9t112_set_params(priv, &rect, V4L2_MBUS_FMT_UYVY8_2X8);
-	else
+	else if (priv->clk)
 		v4l2_clk_put(priv->clk);
 
 	return ret;
@@ -1114,7 +1114,8 @@ static int mt9t112_remove(struct i2c_client *client)
 {
 	struct mt9t112_priv *priv = to_mt9t112(client);
 
-	v4l2_clk_put(priv->clk);
+	if (priv->clk)
+		v4l2_clk_put(priv->clk);
 	return 0;
 }
 
diff --git a/drivers/media/i2c/soc_camera/mt9v022.c b/drivers/media/i2c/soc_camera/mt9v022.c
index f9f95f8..bd0f3947 100644
--- a/drivers/media/i2c/soc_camera/mt9v022.c
+++ b/drivers/media/i2c/soc_camera/mt9v022.c
@@ -940,15 +940,13 @@ static int mt9v022_probe(struct i2c_client *client,
 	mt9v022->rect.height	= MT9V022_MAX_HEIGHT;
 
 	mt9v022->clk = v4l2_clk_get(&client->dev, "mclk");
-	if (IS_ERR(mt9v022->clk)) {
-		ret = PTR_ERR(mt9v022->clk);
-		goto eclkget;
-	}
+	if (IS_ERR(mt9v022->clk))
+		mt9v022->clk = NULL;
 
 	ret = mt9v022_video_probe(client);
 	if (ret) {
-		v4l2_clk_put(mt9v022->clk);
-eclkget:
+		if (mt9v022->clk)
+			v4l2_clk_put(mt9v022->clk);
 		v4l2_ctrl_handler_free(&mt9v022->hdl);
 	}
 
@@ -960,7 +958,8 @@ static int mt9v022_remove(struct i2c_client *client)
 	struct mt9v022 *mt9v022 = to_mt9v022(client);
 	struct soc_camera_subdev_desc *ssdd = soc_camera_i2c_to_desc(client);
 
-	v4l2_clk_put(mt9v022->clk);
+	if (mt9v022->clk)
+		v4l2_clk_put(mt9v022->clk);
 	v4l2_device_unregister_subdev(&mt9v022->subdev);
 	if (ssdd->free_bus)
 		ssdd->free_bus(ssdd);
diff --git a/drivers/media/i2c/soc_camera/ov2640.c b/drivers/media/i2c/soc_camera/ov2640.c
index 6c6b1c3..b015c4d 100644
--- a/drivers/media/i2c/soc_camera/ov2640.c
+++ b/drivers/media/i2c/soc_camera/ov2640.c
@@ -1101,15 +1101,13 @@ static int ov2640_probe(struct i2c_client *client,
 		return priv->hdl.error;
 
 	priv->clk = v4l2_clk_get(&client->dev, "mclk");
-	if (IS_ERR(priv->clk)) {
-		ret = PTR_ERR(priv->clk);
-		goto eclkget;
-	}
+	if (IS_ERR(priv->clk))
+		priv->clk = NULL;
 
 	ret = ov2640_video_probe(client);
 	if (ret) {
-		v4l2_clk_put(priv->clk);
-eclkget:
+		if (priv->clk)
+			v4l2_clk_put(priv->clk);
 		v4l2_ctrl_handler_free(&priv->hdl);
 	} else {
 		dev_info(&adapter->dev, "OV2640 Probed\n");
@@ -1122,7 +1120,8 @@ static int ov2640_remove(struct i2c_client *client)
 {
 	struct ov2640_priv       *priv = to_ov2640(client);
 
-	v4l2_clk_put(priv->clk);
+	if (priv->clk)
+		v4l2_clk_put(priv->clk);
 	v4l2_device_unregister_subdev(&priv->subdev);
 	v4l2_ctrl_handler_free(&priv->hdl);
 	return 0;
diff --git a/drivers/media/i2c/soc_camera/ov5642.c b/drivers/media/i2c/soc_camera/ov5642.c
index 0a5c5d4..86802c9 100644
--- a/drivers/media/i2c/soc_camera/ov5642.c
+++ b/drivers/media/i2c/soc_camera/ov5642.c
@@ -1029,10 +1029,10 @@ static int ov5642_probe(struct i2c_client *client,
 
 	priv->clk = v4l2_clk_get(&client->dev, "mclk");
 	if (IS_ERR(priv->clk))
-		return PTR_ERR(priv->clk);
+		priv->clk = NULL;
 
 	ret = ov5642_video_probe(client);
-	if (ret < 0)
+	if (ret < 0 && priv->clk)
 		v4l2_clk_put(priv->clk);
 
 	return ret;
@@ -1043,7 +1043,8 @@ static int ov5642_remove(struct i2c_client *client)
 	struct soc_camera_subdev_desc *ssdd = soc_camera_i2c_to_desc(client);
 	struct ov5642 *priv = to_ov5642(client);
 
-	v4l2_clk_put(priv->clk);
+	if (priv->clk)
+		v4l2_clk_put(priv->clk);
 	if (ssdd->free_bus)
 		ssdd->free_bus(ssdd);
 
diff --git a/drivers/media/i2c/soc_camera/ov6650.c b/drivers/media/i2c/soc_camera/ov6650.c
index ab01598..2bbd82c 100644
--- a/drivers/media/i2c/soc_camera/ov6650.c
+++ b/drivers/media/i2c/soc_camera/ov6650.c
@@ -1017,15 +1017,13 @@ static int ov6650_probe(struct i2c_client *client,
 	priv->colorspace  = V4L2_COLORSPACE_JPEG;
 
 	priv->clk = v4l2_clk_get(&client->dev, "mclk");
-	if (IS_ERR(priv->clk)) {
-		ret = PTR_ERR(priv->clk);
-		goto eclkget;
-	}
+	if (IS_ERR(priv->clk))
+		priv->clk = NULL;
 
 	ret = ov6650_video_probe(client);
 	if (ret) {
-		v4l2_clk_put(priv->clk);
-eclkget:
+		if (priv->clk)
+			v4l2_clk_put(priv->clk);
 		v4l2_ctrl_handler_free(&priv->hdl);
 	}
 
@@ -1036,7 +1034,8 @@ static int ov6650_remove(struct i2c_client *client)
 {
 	struct ov6650 *priv = to_ov6650(client);
 
-	v4l2_clk_put(priv->clk);
+	if (priv->clk)
+		v4l2_clk_put(priv->clk);
 	v4l2_device_unregister_subdev(&priv->subdev);
 	v4l2_ctrl_handler_free(&priv->hdl);
 	return 0;
diff --git a/drivers/media/i2c/soc_camera/ov772x.c b/drivers/media/i2c/soc_camera/ov772x.c
index 7f2b3c8..60eea93 100644
--- a/drivers/media/i2c/soc_camera/ov772x.c
+++ b/drivers/media/i2c/soc_camera/ov772x.c
@@ -1076,15 +1076,13 @@ static int ov772x_probe(struct i2c_client *client,
 		return priv->hdl.error;
 
 	priv->clk = v4l2_clk_get(&client->dev, "mclk");
-	if (IS_ERR(priv->clk)) {
-		ret = PTR_ERR(priv->clk);
-		goto eclkget;
-	}
+	if (IS_ERR(priv->clk))
+		priv->clk = NULL;
 
 	ret = ov772x_video_probe(priv);
 	if (ret < 0) {
-		v4l2_clk_put(priv->clk);
-eclkget:
+		if (priv->clk)
+			v4l2_clk_put(priv->clk);
 		v4l2_ctrl_handler_free(&priv->hdl);
 	} else {
 		priv->cfmt = &ov772x_cfmts[0];
@@ -1098,7 +1096,8 @@ static int ov772x_remove(struct i2c_client *client)
 {
 	struct ov772x_priv *priv = to_ov772x(i2c_get_clientdata(client));
 
-	v4l2_clk_put(priv->clk);
+	if (priv->clk)
+		v4l2_clk_put(priv->clk);
 	v4l2_device_unregister_subdev(&priv->subdev);
 	v4l2_ctrl_handler_free(&priv->hdl);
 	return 0;
diff --git a/drivers/media/i2c/soc_camera/ov9640.c b/drivers/media/i2c/soc_camera/ov9640.c
index e968c3f..8a5830f 100644
--- a/drivers/media/i2c/soc_camera/ov9640.c
+++ b/drivers/media/i2c/soc_camera/ov9640.c
@@ -703,15 +703,13 @@ static int ov9640_probe(struct i2c_client *client,
 		return priv->hdl.error;
 
 	priv->clk = v4l2_clk_get(&client->dev, "mclk");
-	if (IS_ERR(priv->clk)) {
-		ret = PTR_ERR(priv->clk);
-		goto eclkget;
-	}
+	if (IS_ERR(priv->clk))
+		priv->clk = NULL;
 
 	ret = ov9640_video_probe(client);
 	if (ret) {
-		v4l2_clk_put(priv->clk);
-eclkget:
+		if (priv->clk)
+			v4l2_clk_put(priv->clk);
 		v4l2_ctrl_handler_free(&priv->hdl);
 	}
 
@@ -723,7 +721,8 @@ static int ov9640_remove(struct i2c_client *client)
 	struct v4l2_subdev *sd = i2c_get_clientdata(client);
 	struct ov9640_priv *priv = to_ov9640_sensor(sd);
 
-	v4l2_clk_put(priv->clk);
+	if (priv->clk)
+		v4l2_clk_put(priv->clk);
 	v4l2_device_unregister_subdev(&priv->subdev);
 	v4l2_ctrl_handler_free(&priv->hdl);
 	return 0;
diff --git a/drivers/media/i2c/soc_camera/ov9740.c b/drivers/media/i2c/soc_camera/ov9740.c
index ea76863..3906681 100644
--- a/drivers/media/i2c/soc_camera/ov9740.c
+++ b/drivers/media/i2c/soc_camera/ov9740.c
@@ -961,15 +961,13 @@ static int ov9740_probe(struct i2c_client *client,
 		return priv->hdl.error;
 
 	priv->clk = v4l2_clk_get(&client->dev, "mclk");
-	if (IS_ERR(priv->clk)) {
-		ret = PTR_ERR(priv->clk);
-		goto eclkget;
-	}
+	if (IS_ERR(priv->clk))
+		priv->clk = NULL;
 
 	ret = ov9740_video_probe(client);
 	if (ret < 0) {
-		v4l2_clk_put(priv->clk);
-eclkget:
+		if (priv->clk)
+			v4l2_clk_put(priv->clk);
 		v4l2_ctrl_handler_free(&priv->hdl);
 	}
 
@@ -980,7 +978,8 @@ static int ov9740_remove(struct i2c_client *client)
 {
 	struct ov9740_priv *priv = i2c_get_clientdata(client);
 
-	v4l2_clk_put(priv->clk);
+	if (priv->clk)
+		v4l2_clk_put(priv->clk);
 	v4l2_device_unregister_subdev(&priv->subdev);
 	v4l2_ctrl_handler_free(&priv->hdl);
 	return 0;
diff --git a/drivers/media/i2c/soc_camera/rj54n1cb0c.c b/drivers/media/i2c/soc_camera/rj54n1cb0c.c
index 7e6d978..47a8c76 100644
--- a/drivers/media/i2c/soc_camera/rj54n1cb0c.c
+++ b/drivers/media/i2c/soc_camera/rj54n1cb0c.c
@@ -1359,15 +1359,13 @@ static int rj54n1_probe(struct i2c_client *client,
 		(clk_div.ratio_tg + 1) / (clk_div.ratio_t + 1);
 
 	rj54n1->clk = v4l2_clk_get(&client->dev, "mclk");
-	if (IS_ERR(rj54n1->clk)) {
-		ret = PTR_ERR(rj54n1->clk);
-		goto eclkget;
-	}
+	if (IS_ERR(rj54n1->clk))
+		rj54n1->clk = NULL;
 
 	ret = rj54n1_video_probe(client, rj54n1_priv);
 	if (ret < 0) {
-		v4l2_clk_put(rj54n1->clk);
-eclkget:
+		if (rj54n1->clk)
+			v4l2_clk_put(rj54n1->clk);
 		v4l2_ctrl_handler_free(&rj54n1->hdl);
 	}
 
@@ -1379,7 +1377,8 @@ static int rj54n1_remove(struct i2c_client *client)
 	struct rj54n1 *rj54n1 = to_rj54n1(client);
 	struct soc_camera_subdev_desc *ssdd = soc_camera_i2c_to_desc(client);
 
-	v4l2_clk_put(rj54n1->clk);
+	if (rj54n1->clk)
+		v4l2_clk_put(rj54n1->clk);
 	v4l2_device_unregister_subdev(&rj54n1->subdev);
 	if (ssdd->free_bus)
 		ssdd->free_bus(ssdd);
diff --git a/drivers/media/i2c/soc_camera/tw9910.c b/drivers/media/i2c/soc_camera/tw9910.c
index ab54628..2fabae3 100644
--- a/drivers/media/i2c/soc_camera/tw9910.c
+++ b/drivers/media/i2c/soc_camera/tw9910.c
@@ -928,10 +928,10 @@ static int tw9910_probe(struct i2c_client *client,
 
 	priv->clk = v4l2_clk_get(&client->dev, "mclk");
 	if (IS_ERR(priv->clk))
-		return PTR_ERR(priv->clk);
+		priv->clk = NULL;
 
 	ret = tw9910_video_probe(client);
-	if (ret < 0)
+	if (ret < 0 && priv->clk)
 		v4l2_clk_put(priv->clk);
 
 	return ret;
@@ -940,7 +940,8 @@ static int tw9910_probe(struct i2c_client *client,
 static int tw9910_remove(struct i2c_client *client)
 {
 	struct tw9910_priv *priv = to_tw9910(client);
-	v4l2_clk_put(priv->clk);
+	if (priv->clk)
+		v4l2_clk_put(priv->clk);
 	return 0;
 }
 
-- 
1.7.10.4

