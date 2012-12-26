Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.17.9]:56946 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752287Ab2LZRgD (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 26 Dec 2012 12:36:03 -0500
Received: from 6a.grange (6a.grange [192.168.1.11])
	by axis700.grange (Postfix) with ESMTPS id 61E2A40BDA
	for <linux-media@vger.kernel.org>; Wed, 26 Dec 2012 18:35:59 +0100 (CET)
Received: from lyakh by 6a.grange with local (Exim 4.72)
	(envelope-from <g.liakhovetski@gmx.de>)
	id 1Tnutb-0001cU-0o
	for linux-media@vger.kernel.org; Wed, 26 Dec 2012 18:35:59 +0100
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: linux-media@vger.kernel.org
Subject: [PATCH 5/6] media: soc-camera: use devm_kzalloc in subdevice drivers
Date: Wed, 26 Dec 2012 18:35:57 +0100
Message-Id: <1356543358-6180-6-git-send-email-g.liakhovetski@gmx.de>
In-Reply-To: <1356543358-6180-1-git-send-email-g.liakhovetski@gmx.de>
References: <1356543358-6180-1-git-send-email-g.liakhovetski@gmx.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I2C drivers can use devm_kzalloc() too in their .probe() methods. Doing so
simplifies their clean up paths.

Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
---
 drivers/media/i2c/soc_camera/imx074.c              |   13 +----------
 drivers/media/i2c/soc_camera/mt9m001.c             |   14 +++---------
 drivers/media/i2c/soc_camera/mt9m111.c             |   15 +++----------
 drivers/media/i2c/soc_camera/mt9t031.c             |   14 +++---------
 drivers/media/i2c/soc_camera/mt9t112.c             |    9 +------
 drivers/media/i2c/soc_camera/mt9v022.c             |    8 +-----
 drivers/media/i2c/soc_camera/ov2640.c              |   17 ++++----------
 drivers/media/i2c/soc_camera/ov5642.c              |   15 +-----------
 drivers/media/i2c/soc_camera/ov6650.c              |   14 +++---------
 drivers/media/i2c/soc_camera/ov772x.c              |   22 ++++++-------------
 drivers/media/i2c/soc_camera/ov9640.c              |   15 +++----------
 drivers/media/i2c/soc_camera/ov9740.c              |   15 +++----------
 drivers/media/i2c/soc_camera/rj54n1cb0c.c          |   15 +++----------
 drivers/media/i2c/soc_camera/tw9910.c              |   12 +---------
 .../platform/soc_camera/soc_camera_platform.c      |    4 +--
 15 files changed, 51 insertions(+), 151 deletions(-)

diff --git a/drivers/media/i2c/soc_camera/imx074.c b/drivers/media/i2c/soc_camera/imx074.c
index 1c06571..a2a5cbb 100644
--- a/drivers/media/i2c/soc_camera/imx074.c
+++ b/drivers/media/i2c/soc_camera/imx074.c
@@ -431,7 +431,6 @@ static int imx074_probe(struct i2c_client *client,
 	struct imx074 *priv;
 	struct i2c_adapter *adapter = to_i2c_adapter(client->dev.parent);
 	struct soc_camera_subdev_desc *ssdd = soc_camera_i2c_to_desc(client);
-	int ret;
 
 	if (!ssdd) {
 		dev_err(&client->dev, "IMX074: missing platform data!\n");
@@ -444,7 +443,7 @@ static int imx074_probe(struct i2c_client *client,
 		return -EIO;
 	}
 
-	priv = kzalloc(sizeof(struct imx074), GFP_KERNEL);
+	priv = devm_kzalloc(&client->dev, sizeof(struct imx074), GFP_KERNEL);
 	if (!priv)
 		return -ENOMEM;
 
@@ -452,23 +451,15 @@ static int imx074_probe(struct i2c_client *client,
 
 	priv->fmt	= &imx074_colour_fmts[0];
 
-	ret = imx074_video_probe(client);
-	if (ret < 0) {
-		kfree(priv);
-		return ret;
-	}
-
-	return ret;
+	return imx074_video_probe(client);
 }
 
 static int imx074_remove(struct i2c_client *client)
 {
-	struct imx074 *priv = to_imx074(client);
 	struct soc_camera_subdev_desc *ssdd = soc_camera_i2c_to_desc(client);
 
 	if (ssdd->free_bus)
 		ssdd->free_bus(ssdd);
-	kfree(priv);
 
 	return 0;
 }
diff --git a/drivers/media/i2c/soc_camera/mt9m001.c b/drivers/media/i2c/soc_camera/mt9m001.c
index 9ae7066..bcdc861 100644
--- a/drivers/media/i2c/soc_camera/mt9m001.c
+++ b/drivers/media/i2c/soc_camera/mt9m001.c
@@ -677,7 +677,7 @@ static int mt9m001_probe(struct i2c_client *client,
 		return -EIO;
 	}
 
-	mt9m001 = kzalloc(sizeof(struct mt9m001), GFP_KERNEL);
+	mt9m001 = devm_kzalloc(&client->dev, sizeof(struct mt9m001), GFP_KERNEL);
 	if (!mt9m001)
 		return -ENOMEM;
 
@@ -697,12 +697,9 @@ static int mt9m001_probe(struct i2c_client *client,
 			&mt9m001_ctrl_ops, V4L2_CID_EXPOSURE_AUTO, 1, 0,
 			V4L2_EXPOSURE_AUTO);
 	mt9m001->subdev.ctrl_handler = &mt9m001->hdl;
-	if (mt9m001->hdl.error) {
-		int err = mt9m001->hdl.error;
+	if (mt9m001->hdl.error)
+		return mt9m001->hdl.error;
 
-		kfree(mt9m001);
-		return err;
-	}
 	v4l2_ctrl_auto_cluster(2, &mt9m001->autoexposure,
 					V4L2_EXPOSURE_MANUAL, true);
 
@@ -714,10 +711,8 @@ static int mt9m001_probe(struct i2c_client *client,
 	mt9m001->rect.height	= MT9M001_MAX_HEIGHT;
 
 	ret = mt9m001_video_probe(ssdd, client);
-	if (ret) {
+	if (ret)
 		v4l2_ctrl_handler_free(&mt9m001->hdl);
-		kfree(mt9m001);
-	}
 
 	return ret;
 }
@@ -730,7 +725,6 @@ static int mt9m001_remove(struct i2c_client *client)
 	v4l2_device_unregister_subdev(&mt9m001->subdev);
 	v4l2_ctrl_handler_free(&mt9m001->hdl);
 	mt9m001_video_remove(ssdd);
-	kfree(mt9m001);
 
 	return 0;
 }
diff --git a/drivers/media/i2c/soc_camera/mt9m111.c b/drivers/media/i2c/soc_camera/mt9m111.c
index 7851166..bbc4ff9 100644
--- a/drivers/media/i2c/soc_camera/mt9m111.c
+++ b/drivers/media/i2c/soc_camera/mt9m111.c
@@ -971,7 +971,7 @@ static int mt9m111_probe(struct i2c_client *client,
 		return -EIO;
 	}
 
-	mt9m111 = kzalloc(sizeof(struct mt9m111), GFP_KERNEL);
+	mt9m111 = devm_kzalloc(&client->dev, sizeof(struct mt9m111), GFP_KERNEL);
 	if (!mt9m111)
 		return -ENOMEM;
 
@@ -989,12 +989,8 @@ static int mt9m111_probe(struct i2c_client *client,
 			&mt9m111_ctrl_ops, V4L2_CID_EXPOSURE_AUTO, 1, 0,
 			V4L2_EXPOSURE_AUTO);
 	mt9m111->subdev.ctrl_handler = &mt9m111->hdl;
-	if (mt9m111->hdl.error) {
-		int err = mt9m111->hdl.error;
-
-		kfree(mt9m111);
-		return err;
-	}
+	if (mt9m111->hdl.error)
+		return mt9m111->hdl.error;
 
 	/* Second stage probe - when a capture adapter is there */
 	mt9m111->rect.left	= MT9M111_MIN_DARK_COLS;
@@ -1006,10 +1002,8 @@ static int mt9m111_probe(struct i2c_client *client,
 	mutex_init(&mt9m111->power_lock);
 
 	ret = mt9m111_video_probe(client);
-	if (ret) {
+	if (ret)
 		v4l2_ctrl_handler_free(&mt9m111->hdl);
-		kfree(mt9m111);
-	}
 
 	return ret;
 }
@@ -1020,7 +1014,6 @@ static int mt9m111_remove(struct i2c_client *client)
 
 	v4l2_device_unregister_subdev(&mt9m111->subdev);
 	v4l2_ctrl_handler_free(&mt9m111->hdl);
-	kfree(mt9m111);
 
 	return 0;
 }
diff --git a/drivers/media/i2c/soc_camera/mt9t031.c b/drivers/media/i2c/soc_camera/mt9t031.c
index 9ca6d65..d80d044 100644
--- a/drivers/media/i2c/soc_camera/mt9t031.c
+++ b/drivers/media/i2c/soc_camera/mt9t031.c
@@ -773,7 +773,7 @@ static int mt9t031_probe(struct i2c_client *client,
 		return -EIO;
 	}
 
-	mt9t031 = kzalloc(sizeof(struct mt9t031), GFP_KERNEL);
+	mt9t031 = devm_kzalloc(&client->dev, sizeof(struct mt9t031), GFP_KERNEL);
 	if (!mt9t031)
 		return -ENOMEM;
 
@@ -797,12 +797,9 @@ static int mt9t031_probe(struct i2c_client *client,
 			V4L2_CID_EXPOSURE, 1, 255, 1, 255);
 
 	mt9t031->subdev.ctrl_handler = &mt9t031->hdl;
-	if (mt9t031->hdl.error) {
-		int err = mt9t031->hdl.error;
+	if (mt9t031->hdl.error)
+		return mt9t031->hdl.error;
 
-		kfree(mt9t031);
-		return err;
-	}
 	v4l2_ctrl_auto_cluster(2, &mt9t031->autoexposure,
 				V4L2_EXPOSURE_MANUAL, true);
 
@@ -816,10 +813,8 @@ static int mt9t031_probe(struct i2c_client *client,
 	mt9t031->yskip = 1;
 
 	ret = mt9t031_video_probe(client);
-	if (ret) {
+	if (ret)
 		v4l2_ctrl_handler_free(&mt9t031->hdl);
-		kfree(mt9t031);
-	}
 
 	return ret;
 }
@@ -830,7 +825,6 @@ static int mt9t031_remove(struct i2c_client *client)
 
 	v4l2_device_unregister_subdev(&mt9t031->subdev);
 	v4l2_ctrl_handler_free(&mt9t031->hdl);
-	kfree(mt9t031);
 
 	return 0;
 }
diff --git a/drivers/media/i2c/soc_camera/mt9t112.c b/drivers/media/i2c/soc_camera/mt9t112.c
index 92bb65d..c75d831 100644
--- a/drivers/media/i2c/soc_camera/mt9t112.c
+++ b/drivers/media/i2c/soc_camera/mt9t112.c
@@ -1092,7 +1092,7 @@ static int mt9t112_probe(struct i2c_client *client,
 		return -EINVAL;
 	}
 
-	priv = kzalloc(sizeof(*priv), GFP_KERNEL);
+	priv = devm_kzalloc(&client->dev, sizeof(*priv), GFP_KERNEL);
 	if (!priv)
 		return -ENOMEM;
 
@@ -1101,10 +1101,8 @@ static int mt9t112_probe(struct i2c_client *client,
 	v4l2_i2c_subdev_init(&priv->subdev, client, &mt9t112_subdev_ops);
 
 	ret = mt9t112_camera_probe(client);
-	if (ret) {
-		kfree(priv);
+	if (ret)
 		return ret;
-	}
 
 	/* Cannot fail: using the default supported pixel code */
 	mt9t112_set_params(priv, &rect, V4L2_MBUS_FMT_UYVY8_2X8);
@@ -1114,9 +1112,6 @@ static int mt9t112_probe(struct i2c_client *client,
 
 static int mt9t112_remove(struct i2c_client *client)
 {
-	struct mt9t112_priv *priv = to_mt9t112(client);
-
-	kfree(priv);
 	return 0;
 }
 
diff --git a/drivers/media/i2c/soc_camera/mt9v022.c b/drivers/media/i2c/soc_camera/mt9v022.c
index 33fb5c3..a5e65d6 100644
--- a/drivers/media/i2c/soc_camera/mt9v022.c
+++ b/drivers/media/i2c/soc_camera/mt9v022.c
@@ -889,7 +889,7 @@ static int mt9v022_probe(struct i2c_client *client,
 		return -EIO;
 	}
 
-	mt9v022 = kzalloc(sizeof(struct mt9v022), GFP_KERNEL);
+	mt9v022 = devm_kzalloc(&client->dev, sizeof(struct mt9v022), GFP_KERNEL);
 	if (!mt9v022)
 		return -ENOMEM;
 
@@ -930,7 +930,6 @@ static int mt9v022_probe(struct i2c_client *client,
 		int err = mt9v022->hdl.error;
 
 		dev_err(&client->dev, "control initialisation err %d\n", err);
-		kfree(mt9v022);
 		return err;
 	}
 	v4l2_ctrl_auto_cluster(2, &mt9v022->autoexposure,
@@ -950,10 +949,8 @@ static int mt9v022_probe(struct i2c_client *client,
 	mt9v022->rect.height	= MT9V022_MAX_HEIGHT;
 
 	ret = mt9v022_video_probe(client);
-	if (ret) {
+	if (ret)
 		v4l2_ctrl_handler_free(&mt9v022->hdl);
-		kfree(mt9v022);
-	}
 
 	return ret;
 }
@@ -967,7 +964,6 @@ static int mt9v022_remove(struct i2c_client *client)
 	if (ssdd->free_bus)
 		ssdd->free_bus(ssdd);
 	v4l2_ctrl_handler_free(&mt9v022->hdl);
-	kfree(mt9v022);
 
 	return 0;
 }
diff --git a/drivers/media/i2c/soc_camera/ov2640.c b/drivers/media/i2c/soc_camera/ov2640.c
index c57a509..0f520f6 100644
--- a/drivers/media/i2c/soc_camera/ov2640.c
+++ b/drivers/media/i2c/soc_camera/ov2640.c
@@ -1096,7 +1096,7 @@ static int ov2640_probe(struct i2c_client *client,
 		return -EIO;
 	}
 
-	priv = kzalloc(sizeof(struct ov2640_priv), GFP_KERNEL);
+	priv = devm_kzalloc(&client->dev, sizeof(struct ov2640_priv), GFP_KERNEL);
 	if (!priv) {
 		dev_err(&adapter->dev,
 			"Failed to allocate memory for private data!\n");
@@ -1110,20 +1110,14 @@ static int ov2640_probe(struct i2c_client *client,
 	v4l2_ctrl_new_std(&priv->hdl, &ov2640_ctrl_ops,
 			V4L2_CID_HFLIP, 0, 1, 1, 0);
 	priv->subdev.ctrl_handler = &priv->hdl;
-	if (priv->hdl.error) {
-		int err = priv->hdl.error;
-
-		kfree(priv);
-		return err;
-	}
+	if (priv->hdl.error)
+		return priv->hdl.error;
 
 	ret = ov2640_video_probe(client);
-	if (ret) {
+	if (ret)
 		v4l2_ctrl_handler_free(&priv->hdl);
-		kfree(priv);
-	} else {
+	else
 		dev_info(&adapter->dev, "OV2640 Probed\n");
-	}
 
 	return ret;
 }
@@ -1134,7 +1128,6 @@ static int ov2640_remove(struct i2c_client *client)
 
 	v4l2_device_unregister_subdev(&priv->subdev);
 	v4l2_ctrl_handler_free(&priv->hdl);
-	kfree(priv);
 	return 0;
 }
 
diff --git a/drivers/media/i2c/soc_camera/ov5642.c b/drivers/media/i2c/soc_camera/ov5642.c
index b892d01..9d53309 100644
--- a/drivers/media/i2c/soc_camera/ov5642.c
+++ b/drivers/media/i2c/soc_camera/ov5642.c
@@ -1021,14 +1021,13 @@ static int ov5642_probe(struct i2c_client *client,
 {
 	struct ov5642 *priv;
 	struct soc_camera_subdev_desc *ssdd = soc_camera_i2c_to_desc(client);
-	int ret;
 
 	if (!ssdd) {
 		dev_err(&client->dev, "OV5642: missing platform data!\n");
 		return -EINVAL;
 	}
 
-	priv = kzalloc(sizeof(struct ov5642), GFP_KERNEL);
+	priv = devm_kzalloc(&client->dev, sizeof(struct ov5642), GFP_KERNEL);
 	if (!priv)
 		return -ENOMEM;
 
@@ -1043,25 +1042,15 @@ static int ov5642_probe(struct i2c_client *client,
 	priv->total_width = OV5642_DEFAULT_WIDTH + BLANKING_EXTRA_WIDTH;
 	priv->total_height = BLANKING_MIN_HEIGHT;
 
-	ret = ov5642_video_probe(client);
-	if (ret < 0)
-		goto error;
-
-	return 0;
-
-error:
-	kfree(priv);
-	return ret;
+	return ov5642_video_probe(client);
 }
 
 static int ov5642_remove(struct i2c_client *client)
 {
-	struct ov5642 *priv = to_ov5642(client);
 	struct soc_camera_subdev_desc *ssdd = soc_camera_i2c_to_desc(client);
 
 	if (ssdd->free_bus)
 		ssdd->free_bus(ssdd);
-	kfree(priv);
 
 	return 0;
 }
diff --git a/drivers/media/i2c/soc_camera/ov6650.c b/drivers/media/i2c/soc_camera/ov6650.c
index 1ae8b8d..dbe4f56 100644
--- a/drivers/media/i2c/soc_camera/ov6650.c
+++ b/drivers/media/i2c/soc_camera/ov6650.c
@@ -971,7 +971,7 @@ static int ov6650_probe(struct i2c_client *client,
 		return -EINVAL;
 	}
 
-	priv = kzalloc(sizeof(*priv), GFP_KERNEL);
+	priv = devm_kzalloc(&client->dev, sizeof(*priv), GFP_KERNEL);
 	if (!priv) {
 		dev_err(&client->dev,
 			"Failed to allocate memory for private data!\n");
@@ -1009,12 +1009,9 @@ static int ov6650_probe(struct i2c_client *client,
 			V4L2_CID_GAMMA, 0, 0xff, 1, 0x12);
 
 	priv->subdev.ctrl_handler = &priv->hdl;
-	if (priv->hdl.error) {
-		int err = priv->hdl.error;
+	if (priv->hdl.error)
+		return priv->hdl.error;
 
-		kfree(priv);
-		return err;
-	}
 	v4l2_ctrl_auto_cluster(2, &priv->autogain, 0, true);
 	v4l2_ctrl_auto_cluster(3, &priv->autowb, 0, true);
 	v4l2_ctrl_auto_cluster(2, &priv->autoexposure,
@@ -1029,10 +1026,8 @@ static int ov6650_probe(struct i2c_client *client,
 	priv->colorspace  = V4L2_COLORSPACE_JPEG;
 
 	ret = ov6650_video_probe(client);
-	if (ret) {
+	if (ret)
 		v4l2_ctrl_handler_free(&priv->hdl);
-		kfree(priv);
-	}
 
 	return ret;
 }
@@ -1043,7 +1038,6 @@ static int ov6650_remove(struct i2c_client *client)
 
 	v4l2_device_unregister_subdev(&priv->subdev);
 	v4l2_ctrl_handler_free(&priv->hdl);
-	kfree(priv);
 	return 0;
 }
 
diff --git a/drivers/media/i2c/soc_camera/ov772x.c b/drivers/media/i2c/soc_camera/ov772x.c
index 5172ce9..fbeb5b2 100644
--- a/drivers/media/i2c/soc_camera/ov772x.c
+++ b/drivers/media/i2c/soc_camera/ov772x.c
@@ -1070,7 +1070,7 @@ static int ov772x_probe(struct i2c_client *client,
 		return -EIO;
 	}
 
-	priv = kzalloc(sizeof(*priv), GFP_KERNEL);
+	priv = devm_kzalloc(&client->dev, sizeof(*priv), GFP_KERNEL);
 	if (!priv)
 		return -ENOMEM;
 
@@ -1085,22 +1085,15 @@ static int ov772x_probe(struct i2c_client *client,
 	v4l2_ctrl_new_std(&priv->hdl, &ov772x_ctrl_ops,
 			V4L2_CID_BAND_STOP_FILTER, 0, 256, 1, 0);
 	priv->subdev.ctrl_handler = &priv->hdl;
-	if (priv->hdl.error) {
-		ret = priv->hdl.error;
-		goto done;
-	}
+	if (priv->hdl.error)
+		return priv->hdl.error;
 
 	ret = ov772x_video_probe(priv);
-	if (ret < 0)
-		goto done;
-
-	priv->cfmt = &ov772x_cfmts[0];
-	priv->win = &ov772x_win_sizes[0];
-
-done:
-	if (ret) {
+	if (ret < 0) {
 		v4l2_ctrl_handler_free(&priv->hdl);
-		kfree(priv);
+	} else {
+		priv->cfmt = &ov772x_cfmts[0];
+		priv->win = &ov772x_win_sizes[0];
 	}
 	return ret;
 }
@@ -1111,7 +1104,6 @@ static int ov772x_remove(struct i2c_client *client)
 
 	v4l2_device_unregister_subdev(&priv->subdev);
 	v4l2_ctrl_handler_free(&priv->hdl);
-	kfree(priv);
 	return 0;
 }
 
diff --git a/drivers/media/i2c/soc_camera/ov9640.c b/drivers/media/i2c/soc_camera/ov9640.c
index 0ce2124..0599304 100644
--- a/drivers/media/i2c/soc_camera/ov9640.c
+++ b/drivers/media/i2c/soc_camera/ov9640.c
@@ -698,7 +698,7 @@ static int ov9640_probe(struct i2c_client *client,
 		return -EINVAL;
 	}
 
-	priv = kzalloc(sizeof(struct ov9640_priv), GFP_KERNEL);
+	priv = devm_kzalloc(&client->dev, sizeof(struct ov9640_priv), GFP_KERNEL);
 	if (!priv) {
 		dev_err(&client->dev,
 			"Failed to allocate memory for private data!\n");
@@ -713,19 +713,13 @@ static int ov9640_probe(struct i2c_client *client,
 	v4l2_ctrl_new_std(&priv->hdl, &ov9640_ctrl_ops,
 			V4L2_CID_HFLIP, 0, 1, 1, 0);
 	priv->subdev.ctrl_handler = &priv->hdl;
-	if (priv->hdl.error) {
-		int err = priv->hdl.error;
-
-		kfree(priv);
-		return err;
-	}
+	if (priv->hdl.error)
+		return priv->hdl.error;
 
 	ret = ov9640_video_probe(client);
 
-	if (ret) {
+	if (ret)
 		v4l2_ctrl_handler_free(&priv->hdl);
-		kfree(priv);
-	}
 
 	return ret;
 }
@@ -737,7 +731,6 @@ static int ov9640_remove(struct i2c_client *client)
 
 	v4l2_device_unregister_subdev(&priv->subdev);
 	v4l2_ctrl_handler_free(&priv->hdl);
-	kfree(priv);
 	return 0;
 }
 
diff --git a/drivers/media/i2c/soc_camera/ov9740.c b/drivers/media/i2c/soc_camera/ov9740.c
index cdaaf5e..2f236da 100644
--- a/drivers/media/i2c/soc_camera/ov9740.c
+++ b/drivers/media/i2c/soc_camera/ov9740.c
@@ -959,7 +959,7 @@ static int ov9740_probe(struct i2c_client *client,
 		return -EINVAL;
 	}
 
-	priv = kzalloc(sizeof(struct ov9740_priv), GFP_KERNEL);
+	priv = devm_kzalloc(&client->dev, sizeof(struct ov9740_priv), GFP_KERNEL);
 	if (!priv) {
 		dev_err(&client->dev, "Failed to allocate private data!\n");
 		return -ENOMEM;
@@ -972,18 +972,12 @@ static int ov9740_probe(struct i2c_client *client,
 	v4l2_ctrl_new_std(&priv->hdl, &ov9740_ctrl_ops,
 			V4L2_CID_HFLIP, 0, 1, 1, 0);
 	priv->subdev.ctrl_handler = &priv->hdl;
-	if (priv->hdl.error) {
-		int err = priv->hdl.error;
-
-		kfree(priv);
-		return err;
-	}
+	if (priv->hdl.error)
+		return priv->hdl.error;
 
 	ret = ov9740_video_probe(client);
-	if (ret < 0) {
+	if (ret < 0)
 		v4l2_ctrl_handler_free(&priv->hdl);
-		kfree(priv);
-	}
 
 	return ret;
 }
@@ -994,7 +988,6 @@ static int ov9740_remove(struct i2c_client *client)
 
 	v4l2_device_unregister_subdev(&priv->subdev);
 	v4l2_ctrl_handler_free(&priv->hdl);
-	kfree(priv);
 	return 0;
 }
 
diff --git a/drivers/media/i2c/soc_camera/rj54n1cb0c.c b/drivers/media/i2c/soc_camera/rj54n1cb0c.c
index 297e288..5c92679 100644
--- a/drivers/media/i2c/soc_camera/rj54n1cb0c.c
+++ b/drivers/media/i2c/soc_camera/rj54n1cb0c.c
@@ -1352,7 +1352,7 @@ static int rj54n1_probe(struct i2c_client *client,
 		return -EIO;
 	}
 
-	rj54n1 = kzalloc(sizeof(struct rj54n1), GFP_KERNEL);
+	rj54n1 = devm_kzalloc(&client->dev, sizeof(struct rj54n1), GFP_KERNEL);
 	if (!rj54n1)
 		return -ENOMEM;
 
@@ -1367,12 +1367,8 @@ static int rj54n1_probe(struct i2c_client *client,
 	v4l2_ctrl_new_std(&rj54n1->hdl, &rj54n1_ctrl_ops,
 			V4L2_CID_AUTO_WHITE_BALANCE, 0, 1, 1, 1);
 	rj54n1->subdev.ctrl_handler = &rj54n1->hdl;
-	if (rj54n1->hdl.error) {
-		int err = rj54n1->hdl.error;
-
-		kfree(rj54n1);
-		return err;
-	}
+	if (rj54n1->hdl.error)
+		return rj54n1->hdl.error;
 
 	rj54n1->clk_div		= clk_div;
 	rj54n1->rect.left	= RJ54N1_COLUMN_SKIP;
@@ -1387,10 +1383,8 @@ static int rj54n1_probe(struct i2c_client *client,
 		(clk_div.ratio_tg + 1) / (clk_div.ratio_t + 1);
 
 	ret = rj54n1_video_probe(client, rj54n1_priv);
-	if (ret < 0) {
+	if (ret < 0)
 		v4l2_ctrl_handler_free(&rj54n1->hdl);
-		kfree(rj54n1);
-	}
 
 	return ret;
 }
@@ -1404,7 +1398,6 @@ static int rj54n1_remove(struct i2c_client *client)
 	if (ssdd->free_bus)
 		ssdd->free_bus(ssdd);
 	v4l2_ctrl_handler_free(&rj54n1->hdl);
-	kfree(rj54n1);
 
 	return 0;
 }
diff --git a/drivers/media/i2c/soc_camera/tw9910.c b/drivers/media/i2c/soc_camera/tw9910.c
index cc34c59..7d20746 100644
--- a/drivers/media/i2c/soc_camera/tw9910.c
+++ b/drivers/media/i2c/soc_camera/tw9910.c
@@ -912,7 +912,6 @@ static int tw9910_probe(struct i2c_client *client,
 	struct i2c_adapter		*adapter =
 		to_i2c_adapter(client->dev.parent);
 	struct soc_camera_subdev_desc	*ssdd = soc_camera_i2c_to_desc(client);
-	int				ret;
 
 	if (!ssdd || !ssdd->drv_priv) {
 		dev_err(&client->dev, "TW9910: missing platform data!\n");
@@ -928,7 +927,7 @@ static int tw9910_probe(struct i2c_client *client,
 		return -EIO;
 	}
 
-	priv = kzalloc(sizeof(*priv), GFP_KERNEL);
+	priv = devm_kzalloc(&client->dev, sizeof(*priv), GFP_KERNEL);
 	if (!priv)
 		return -ENOMEM;
 
@@ -936,18 +935,11 @@ static int tw9910_probe(struct i2c_client *client,
 
 	v4l2_i2c_subdev_init(&priv->subdev, client, &tw9910_subdev_ops);
 
-	ret = tw9910_video_probe(client);
-	if (ret)
-		kfree(priv);
-
-	return ret;
+	return tw9910_video_probe(client);
 }
 
 static int tw9910_remove(struct i2c_client *client)
 {
-	struct tw9910_priv *priv = to_tw9910(client);
-
-	kfree(priv);
 	return 0;
 }
 
diff --git a/drivers/media/platform/soc_camera/soc_camera_platform.c b/drivers/media/platform/soc_camera/soc_camera_platform.c
index 51e29d1..ce3b1d6 100644
--- a/drivers/media/platform/soc_camera/soc_camera_platform.c
+++ b/drivers/media/platform/soc_camera/soc_camera_platform.c
@@ -148,7 +148,7 @@ static int soc_camera_platform_probe(struct platform_device *pdev)
 		return -EINVAL;
 	}
 
-	priv = kzalloc(sizeof(*priv), GFP_KERNEL);
+	priv = devm_kzalloc(&pdev->dev, sizeof(*priv), GFP_KERNEL);
 	if (!priv)
 		return -ENOMEM;
 
@@ -173,7 +173,6 @@ static int soc_camera_platform_probe(struct platform_device *pdev)
 
 evdrs:
 	platform_set_drvdata(pdev, NULL);
-	kfree(priv);
 	return ret;
 }
 
@@ -185,7 +184,6 @@ static int soc_camera_platform_remove(struct platform_device *pdev)
 	p->icd->control = NULL;
 	v4l2_device_unregister_subdev(&priv->subdev);
 	platform_set_drvdata(pdev, NULL);
-	kfree(priv);
 	return 0;
 }
 
-- 
1.7.2.5

