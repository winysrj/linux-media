Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:51781 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965209Ab2EWP12 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 23 May 2012 11:27:28 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: linux-media@vger.kernel.org
Subject: [PATCH 8/8] soc-camera: Push probe-time power management to drivers
Date: Wed, 23 May 2012 17:27:35 +0200
Message-Id: <1337786855-28759-9-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1337786855-28759-1-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1337786855-28759-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Several client drivers access the hardware at probe time, for instance
to read the probe chip ID. Such chips need to be powered up when being
probed.

soc-camera handles this by powering chips up in the soc-camera probe
implementation. However, this will break with non soc-camera hosts that
don't perform the same operations.

Fix the problem by pushing the power up/down from the soc-camera core
down to individual drivers on a needs basis.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/media/video/imx074.c     |   21 ++++++++--
 drivers/media/video/mt9m001.c    |   17 +++++++-
 drivers/media/video/mt9m111.c    |   80 +++++++++++++++++++++----------------
 drivers/media/video/mt9t031.c    |   18 ++++++---
 drivers/media/video/mt9t112.c    |   12 +++++-
 drivers/media/video/mt9v022.c    |    5 ++
 drivers/media/video/ov2640.c     |   11 ++++-
 drivers/media/video/ov5642.c     |   21 ++++++++--
 drivers/media/video/ov6650.c     |   19 ++++++---
 drivers/media/video/ov772x.c     |   14 ++++++-
 drivers/media/video/ov9640.c     |   17 ++++++--
 drivers/media/video/ov9740.c     |   23 +++++++----
 drivers/media/video/rj54n1cb0c.c |   18 ++++++--
 drivers/media/video/soc_camera.c |   14 -------
 drivers/media/video/tw9910.c     |   12 +++++-
 15 files changed, 201 insertions(+), 101 deletions(-)

diff --git a/drivers/media/video/imx074.c b/drivers/media/video/imx074.c
index 1166c89..fc86e68 100644
--- a/drivers/media/video/imx074.c
+++ b/drivers/media/video/imx074.c
@@ -313,26 +313,33 @@ static struct v4l2_subdev_ops imx074_subdev_ops = {
 
 static int imx074_video_probe(struct i2c_client *client)
 {
+	struct v4l2_subdev *subdev = i2c_get_clientdata(client);
 	int ret;
 	u16 id;
 
+	ret = imx074_s_power(subdev, 1);
+	if (ret < 0)
+		return ret;
+
 	/* Read sensor Model ID */
 	ret = reg_read(client, 0);
 	if (ret < 0)
-		return ret;
+		goto done;
 
 	id = ret << 8;
 
 	ret = reg_read(client, 1);
 	if (ret < 0)
-		return ret;
+		goto done;
 
 	id |= ret;
 
 	dev_info(&client->dev, "Chip ID 0x%04x detected\n", id);
 
-	if (id != 0x74)
-		return -ENODEV;
+	if (id != 0x74) {
+		ret = -ENODEV;
+		goto done;
+	}
 
 	/* PLL Setting EXTCLK=24MHz, 22.5times */
 	reg_write(client, PLL_MULTIPLIER, 0x2D);
@@ -414,7 +421,11 @@ static int imx074_video_probe(struct i2c_client *client)
 
 	reg_write(client, GROUPED_PARAMETER_HOLD, 0x00);	/* off */
 
-	return 0;
+	ret = 0;
+
+done:
+	imx074_s_power(subdev, 0);
+	return ret;
 }
 
 static int imx074_probe(struct i2c_client *client,
diff --git a/drivers/media/video/mt9m001.c b/drivers/media/video/mt9m001.c
index cf2aa00..b69bb91 100644
--- a/drivers/media/video/mt9m001.c
+++ b/drivers/media/video/mt9m001.c
@@ -493,6 +493,10 @@ static int mt9m001_video_probe(struct soc_camera_link *icl,
 	unsigned long flags;
 	int ret;
 
+	ret = mt9m001_s_power(&mt9m001->subdev, 1);
+	if (ret < 0)
+		return ret;
+
 	/* Enable the chip */
 	data = reg_write(client, MT9M001_CHIP_ENABLE, 1);
 	dev_dbg(&client->dev, "write: %d\n", data);
@@ -514,7 +518,8 @@ static int mt9m001_video_probe(struct soc_camera_link *icl,
 	default:
 		dev_err(&client->dev,
 			"No MT9M001 chip detected, register read %x\n", data);
-		return -ENODEV;
+		ret = -ENODEV;
+		goto done;
 	}
 
 	mt9m001->num_fmts = 0;
@@ -543,11 +548,17 @@ static int mt9m001_video_probe(struct soc_camera_link *icl,
 		 data == 0x8431 ? "C12STM" : "C12ST");
 
 	ret = mt9m001_init(client);
-	if (ret < 0)
+	if (ret < 0) {
 		dev_err(&client->dev, "Failed to initialise the camera\n");
+		goto done;
+	}
 
 	/* mt9m001_init() has reset the chip, returning registers to defaults */
-	return v4l2_ctrl_handler_setup(&mt9m001->hdl);
+	ret = v4l2_ctrl_handler_setup(&mt9m001->hdl);
+
+done:
+	mt9m001_s_power(&mt9m001->subdev, 0);
+	return ret;
 }
 
 static void mt9m001_video_remove(struct soc_camera_link *icl)
diff --git a/drivers/media/video/mt9m111.c b/drivers/media/video/mt9m111.c
index b9bfb4f..36dd39f 100644
--- a/drivers/media/video/mt9m111.c
+++ b/drivers/media/video/mt9m111.c
@@ -797,41 +797,6 @@ static int mt9m111_init(struct mt9m111 *mt9m111)
 	return ret;
 }
 
-/*
- * Interface active, can use i2c. If it fails, it can indeed mean, that
- * this wasn't our capture interface, so, we wait for the right one
- */
-static int mt9m111_video_probe(struct i2c_client *client)
-{
-	struct mt9m111 *mt9m111 = to_mt9m111(client);
-	s32 data;
-	int ret;
-
-	data = reg_read(CHIP_VERSION);
-
-	switch (data) {
-	case 0x143a: /* MT9M111 or MT9M131 */
-		mt9m111->model = V4L2_IDENT_MT9M111;
-		dev_info(&client->dev,
-			"Detected a MT9M111/MT9M131 chip ID %x\n", data);
-		break;
-	case 0x148c: /* MT9M112 */
-		mt9m111->model = V4L2_IDENT_MT9M112;
-		dev_info(&client->dev, "Detected a MT9M112 chip ID %x\n", data);
-		break;
-	default:
-		dev_err(&client->dev,
-			"No MT9M111/MT9M112/MT9M131 chip detected register read %x\n",
-			data);
-		return -ENODEV;
-	}
-
-	ret = mt9m111_init(mt9m111);
-	if (ret)
-		return ret;
-	return v4l2_ctrl_handler_setup(&mt9m111->hdl);
-}
-
 static int mt9m111_power_on(struct mt9m111 *mt9m111)
 {
 	struct i2c_client *client = v4l2_get_subdevdata(&mt9m111->subdev);
@@ -940,6 +905,51 @@ static struct v4l2_subdev_ops mt9m111_subdev_ops = {
 	.video	= &mt9m111_subdev_video_ops,
 };
 
+/*
+ * Interface active, can use i2c. If it fails, it can indeed mean, that
+ * this wasn't our capture interface, so, we wait for the right one
+ */
+static int mt9m111_video_probe(struct i2c_client *client)
+{
+	struct mt9m111 *mt9m111 = to_mt9m111(client);
+	s32 data;
+	int ret;
+
+	ret = mt9m111_s_power(&mt9m111->subdev, 1);
+	if (ret < 0)
+		return ret;
+
+	data = reg_read(CHIP_VERSION);
+
+	switch (data) {
+	case 0x143a: /* MT9M111 or MT9M131 */
+		mt9m111->model = V4L2_IDENT_MT9M111;
+		dev_info(&client->dev,
+			"Detected a MT9M111/MT9M131 chip ID %x\n", data);
+		break;
+	case 0x148c: /* MT9M112 */
+		mt9m111->model = V4L2_IDENT_MT9M112;
+		dev_info(&client->dev, "Detected a MT9M112 chip ID %x\n", data);
+		break;
+	default:
+		dev_err(&client->dev,
+			"No MT9M111/MT9M112/MT9M131 chip detected register read %x\n",
+			data);
+		ret = -ENODEV;
+		goto done;
+	}
+
+	ret = mt9m111_init(mt9m111);
+	if (ret)
+		goto done;
+
+	ret = v4l2_ctrl_handler_setup(&mt9m111->hdl);
+
+done:
+	ret = mt9m111_s_power(&mt9m111->subdev, 0);
+	return ret;
+}
+
 static int mt9m111_probe(struct i2c_client *client,
 			 const struct i2c_device_id *did)
 {
diff --git a/drivers/media/video/mt9t031.c b/drivers/media/video/mt9t031.c
index 9666e20..56dd31c 100644
--- a/drivers/media/video/mt9t031.c
+++ b/drivers/media/video/mt9t031.c
@@ -643,6 +643,12 @@ static int mt9t031_video_probe(struct i2c_client *client)
 	s32 data;
 	int ret;
 
+	ret = mt9t031_s_power(&mt9t031->subdev, 1);
+	if (ret < 0)
+		return ret;
+
+	mt9t031_idle(client);
+
 	/* Enable the chip */
 	data = reg_write(client, MT9T031_CHIP_ENABLE, 1);
 	dev_dbg(&client->dev, "write: %d\n", data);
@@ -657,7 +663,8 @@ static int mt9t031_video_probe(struct i2c_client *client)
 	default:
 		dev_err(&client->dev,
 			"No MT9T031 chip detected, register read %x\n", data);
-		return -ENODEV;
+		ret = -ENODEV;
+		goto done;
 	}
 
 	dev_info(&client->dev, "Detected a MT9T031 chip ID %x\n", data);
@@ -668,6 +675,10 @@ static int mt9t031_video_probe(struct i2c_client *client)
 	else
 		v4l2_ctrl_handler_setup(&mt9t031->hdl);
 
+done:
+	mt9t031_disable(client);
+	mt9t031_s_power(&mt9t031->subdev, 0);
+
 	return ret;
 }
 
@@ -817,12 +828,7 @@ static int mt9t031_probe(struct i2c_client *client,
 	mt9t031->xskip = 1;
 	mt9t031->yskip = 1;
 
-	mt9t031_idle(client);
-
 	ret = mt9t031_video_probe(client);
-
-	mt9t031_disable(client);
-
 	if (ret) {
 		v4l2_ctrl_handler_free(&mt9t031->hdl);
 		kfree(mt9t031);
diff --git a/drivers/media/video/mt9t112.c b/drivers/media/video/mt9t112.c
index a78242a..ef15375 100644
--- a/drivers/media/video/mt9t112.c
+++ b/drivers/media/video/mt9t112.c
@@ -1044,6 +1044,11 @@ static int mt9t112_camera_probe(struct i2c_client *client)
 	struct mt9t112_priv *priv = to_mt9t112(client);
 	const char          *devname;
 	int                  chipid;
+	int		     ret;
+
+	ret = mt9t112_s_power(&priv->subdev, 1);
+	if (ret < 0)
+		return ret;
 
 	/*
 	 * check and show chip ID
@@ -1061,12 +1066,15 @@ static int mt9t112_camera_probe(struct i2c_client *client)
 		break;
 	default:
 		dev_err(&client->dev, "Product ID error %04x\n", chipid);
-		return -ENODEV;
+		ret = -ENODEV;
+		goto done;
 	}
 
 	dev_info(&client->dev, "%s chip ID %04x\n", devname, chipid);
 
-	return 0;
+done:
+	mt9t112_s_power(&priv->subdev, 0);
+	return ret;
 }
 
 static int mt9t112_probe(struct i2c_client *client,
diff --git a/drivers/media/video/mt9v022.c b/drivers/media/video/mt9v022.c
index 5715231..0698754 100644
--- a/drivers/media/video/mt9v022.c
+++ b/drivers/media/video/mt9v022.c
@@ -581,6 +581,10 @@ static int mt9v022_video_probe(struct i2c_client *client)
 	int ret;
 	unsigned long flags;
 
+	ret = mt9v022_s_power(&mt9v022->subdev, 1);
+	if (ret < 0)
+		return ret;
+
 	/* Read out the chip version register */
 	data = reg_read(client, MT9V022_CHIP_VERSION);
 
@@ -651,6 +655,7 @@ static int mt9v022_video_probe(struct i2c_client *client)
 		dev_err(&client->dev, "Failed to initialise the camera\n");
 
 ei2c:
+	mt9v022_s_power(&mt9v022->subdev, 0);
 	return ret;
 }
 
diff --git a/drivers/media/video/ov2640.c b/drivers/media/video/ov2640.c
index cc3da57..d948367 100644
--- a/drivers/media/video/ov2640.c
+++ b/drivers/media/video/ov2640.c
@@ -957,6 +957,10 @@ static int ov2640_video_probe(struct i2c_client *client)
 	const char *devname;
 	int ret;
 
+	ret = ov2640_s_power(&priv->subdev, 1);
+	if (ret < 0)
+		return ret;
+
 	/*
 	 * check and show product ID and manufacturer ID
 	 */
@@ -975,16 +979,17 @@ static int ov2640_video_probe(struct i2c_client *client)
 		dev_err(&client->dev,
 			"Product ID error %x:%x\n", pid, ver);
 		ret = -ENODEV;
-		goto err;
+		goto done;
 	}
 
 	dev_info(&client->dev,
 		 "%s Product ID %0x:%0x Manufacturer ID %x:%x\n",
 		 devname, pid, ver, midh, midl);
 
-	return v4l2_ctrl_handler_setup(&priv->hdl);
+	ret = v4l2_ctrl_handler_setup(&priv->hdl);
 
-err:
+done:
+	ov2640_s_power(&priv->subdev, 0);
 	return ret;
 }
 
diff --git a/drivers/media/video/ov5642.c b/drivers/media/video/ov5642.c
index 98de102..f5acc87 100644
--- a/drivers/media/video/ov5642.c
+++ b/drivers/media/video/ov5642.c
@@ -983,29 +983,40 @@ static struct v4l2_subdev_ops ov5642_subdev_ops = {
 
 static int ov5642_video_probe(struct i2c_client *client)
 {
+	struct v4l2_subdev *subdev = i2c_get_clientdata(client);
 	int ret;
 	u8 id_high, id_low;
 	u16 id;
 
+	ret = ov5642_s_power(subdev, 1);
+	if (ret < 0)
+		return ret;
+
 	/* Read sensor Model ID */
 	ret = reg_read(client, REG_CHIP_ID_HIGH, &id_high);
 	if (ret < 0)
-		return ret;
+		goto done;
 
 	id = id_high << 8;
 
 	ret = reg_read(client, REG_CHIP_ID_LOW, &id_low);
 	if (ret < 0)
-		return ret;
+		goto done;
 
 	id |= id_low;
 
 	dev_info(&client->dev, "Chip ID 0x%04x detected\n", id);
 
-	if (id != 0x5642)
-		return -ENODEV;
+	if (id != 0x5642) {
+		ret = -ENODEV;
+		goto done;
+	}
 
-	return 0;
+	ret = 0;
+
+done:
+	ov5642_s_power(subdev, 0);
+	return ret;
 }
 
 static int ov5642_probe(struct i2c_client *client,
diff --git a/drivers/media/video/ov6650.c b/drivers/media/video/ov6650.c
index 2264c8f..3c0a711 100644
--- a/drivers/media/video/ov6650.c
+++ b/drivers/media/video/ov6650.c
@@ -832,8 +832,13 @@ static int ov6650_prog_dflt(struct i2c_client *client)
 
 static int ov6650_video_probe(struct i2c_client *client)
 {
+	struct ov6650 *priv = to_ov6650(client);
 	u8		pidh, pidl, midh, midl;
-	int		ret = 0;
+	int		ret;
+
+	ret = ov6650_s_power(&priv->subdev, 1);
+	if (ret < 0)
+		return ret;
 
 	/*
 	 * check and show product ID and manufacturer ID
@@ -847,12 +852,13 @@ static int ov6650_video_probe(struct i2c_client *client)
 		ret = ov6650_reg_read(client, REG_MIDL, &midl);
 
 	if (ret)
-		return ret;
+		goto done;
 
 	if ((pidh != OV6650_PIDH) || (pidl != OV6650_PIDL)) {
 		dev_err(&client->dev, "Product ID error 0x%02x:0x%02x\n",
 				pidh, pidl);
-		return -ENODEV;
+		ret = -ENODEV;
+		goto done;
 	}
 
 	dev_info(&client->dev,
@@ -862,7 +868,11 @@ static int ov6650_video_probe(struct i2c_client *client)
 	ret = ov6650_reset(client);
 	if (!ret)
 		ret = ov6650_prog_dflt(client);
+	if (!ret)
+		ret = v4l2_ctrl_handler_setup(&priv->hdl);
 
+done:
+	ov6650_s_power(&priv->subdev, 0);
 	return ret;
 }
 
@@ -1022,9 +1032,6 @@ static int ov6650_probe(struct i2c_client *client,
 	priv->colorspace  = V4L2_COLORSPACE_JPEG;
 
 	ret = ov6650_video_probe(client);
-	if (!ret)
-		ret = v4l2_ctrl_handler_setup(&priv->hdl);
-
 	if (ret) {
 		v4l2_ctrl_handler_free(&priv->hdl);
 		kfree(priv);
diff --git a/drivers/media/video/ov772x.c b/drivers/media/video/ov772x.c
index 3f37369..300ae73 100644
--- a/drivers/media/video/ov772x.c
+++ b/drivers/media/video/ov772x.c
@@ -965,6 +965,11 @@ static int ov772x_video_probe(struct i2c_client *client)
 	struct ov772x_priv *priv = to_ov772x(client);
 	u8                  pid, ver;
 	const char         *devname;
+	int		    ret;
+
+	ret = ov772x_s_power(&priv->subdev, 1);
+	if (ret < 0)
+		return ret;
 
 	/*
 	 * check and show product ID and manufacturer ID
@@ -984,7 +989,8 @@ static int ov772x_video_probe(struct i2c_client *client)
 	default:
 		dev_err(&client->dev,
 			"Product ID error %x:%x\n", pid, ver);
-		return -ENODEV;
+		ret = -ENODEV;
+		goto done;
 	}
 
 	dev_info(&client->dev,
@@ -994,7 +1000,11 @@ static int ov772x_video_probe(struct i2c_client *client)
 		 ver,
 		 i2c_smbus_read_byte_data(client, MIDH),
 		 i2c_smbus_read_byte_data(client, MIDL));
-	return v4l2_ctrl_handler_setup(&priv->hdl);
+	ret = v4l2_ctrl_handler_setup(&priv->hdl);
+
+done:
+	ov772x_s_power(&priv->subdev, 0);
+	return ret;
 }
 
 static const struct v4l2_ctrl_ops ov772x_ctrl_ops = {
diff --git a/drivers/media/video/ov9640.c b/drivers/media/video/ov9640.c
index 712cf6f..22fb14e 100644
--- a/drivers/media/video/ov9640.c
+++ b/drivers/media/video/ov9640.c
@@ -595,7 +595,11 @@ static int ov9640_video_probe(struct i2c_client *client)
 	struct ov9640_priv *priv = to_ov9640_sensor(sd);
 	u8		pid, ver, midh, midl;
 	const char	*devname;
-	int		ret = 0;
+	int		ret;
+
+	ret = ov9640_s_power(&priv->subdev, 1);
+	if (ret < 0)
+		return ret;
 
 	/*
 	 * check and show product ID and manufacturer ID
@@ -609,7 +613,7 @@ static int ov9640_video_probe(struct i2c_client *client)
 	if (!ret)
 		ret = ov9640_reg_read(client, OV9640_MIDL, &midl);
 	if (ret)
-		return ret;
+		goto done;
 
 	switch (VERSION(pid, ver)) {
 	case OV9640_V2:
@@ -623,13 +627,18 @@ static int ov9640_video_probe(struct i2c_client *client)
 		break;
 	default:
 		dev_err(&client->dev, "Product ID error %x:%x\n", pid, ver);
-		return -ENODEV;
+		ret = -ENODEV;
+		goto done;
 	}
 
 	dev_info(&client->dev, "%s Product ID %0x:%0x Manufacturer ID %x:%x\n",
 		 devname, pid, ver, midh, midl);
 
-	return v4l2_ctrl_handler_setup(&priv->hdl);
+	ret = v4l2_ctrl_handler_setup(&priv->hdl);
+
+done:
+	ov9640_s_power(&priv->subdev, 0);
+	return ret;
 }
 
 static const struct v4l2_ctrl_ops ov9640_ctrl_ops = {
diff --git a/drivers/media/video/ov9740.c b/drivers/media/video/ov9740.c
index effd0f1..a3b02f7 100644
--- a/drivers/media/video/ov9740.c
+++ b/drivers/media/video/ov9740.c
@@ -856,34 +856,38 @@ static int ov9740_video_probe(struct i2c_client *client)
 	u8 modelhi, modello;
 	int ret;
 
+	ret = ov9740_s_power(&priv->subdev, 1);
+	if (ret < 0)
+		return ret;
+
 	/*
 	 * check and show product ID and manufacturer ID
 	 */
 	ret = ov9740_reg_read(client, OV9740_MODEL_ID_HI, &modelhi);
 	if (ret < 0)
-		goto err;
+		goto done;
 
 	ret = ov9740_reg_read(client, OV9740_MODEL_ID_LO, &modello);
 	if (ret < 0)
-		goto err;
+		goto done;
 
 	priv->model = (modelhi << 8) | modello;
 
 	ret = ov9740_reg_read(client, OV9740_REVISION_NUMBER, &priv->revision);
 	if (ret < 0)
-		goto err;
+		goto done;
 
 	ret = ov9740_reg_read(client, OV9740_MANUFACTURER_ID, &priv->manid);
 	if (ret < 0)
-		goto err;
+		goto done;
 
 	ret = ov9740_reg_read(client, OV9740_SMIA_VERSION, &priv->smiaver);
 	if (ret < 0)
-		goto err;
+		goto done;
 
 	if (priv->model != 0x9740) {
 		ret = -ENODEV;
-		goto err;
+		goto done;
 	}
 
 	priv->ident = V4L2_IDENT_OV9740;
@@ -892,7 +896,10 @@ static int ov9740_video_probe(struct i2c_client *client)
 		 "Manufacturer 0x%02x, SMIA Version 0x%02x\n",
 		 priv->model, priv->revision, priv->manid, priv->smiaver);
 
-err:
+	ret = v4l2_ctrl_handler_setup(&priv->hdl);
+
+done:
+	ov9740_s_power(&priv->subdev, 0);
 	return ret;
 }
 
@@ -976,8 +983,6 @@ static int ov9740_probe(struct i2c_client *client,
 	}
 
 	ret = ov9740_video_probe(client);
-	if (!ret)
-		ret = v4l2_ctrl_handler_setup(&priv->hdl);
 	if (ret < 0) {
 		v4l2_ctrl_handler_free(&priv->hdl);
 		kfree(priv);
diff --git a/drivers/media/video/rj54n1cb0c.c b/drivers/media/video/rj54n1cb0c.c
index f0c3c64..ab74764 100644
--- a/drivers/media/video/rj54n1cb0c.c
+++ b/drivers/media/video/rj54n1cb0c.c
@@ -1299,9 +1299,14 @@ static struct v4l2_subdev_ops rj54n1_subdev_ops = {
 static int rj54n1_video_probe(struct i2c_client *client,
 			      struct rj54n1_pdata *priv)
 {
+	struct rj54n1 *rj54n1 = to_rj54n1(client);
 	int data1, data2;
 	int ret;
 
+	ret = rj54n1_s_power(&rj54n1->subdev, 1);
+	if (ret < 0)
+		return ret;
+
 	/* Read out the chip version register */
 	data1 = reg_read(client, RJ54N1_DEV_CODE);
 	data2 = reg_read(client, RJ54N1_DEV_CODE2);
@@ -1310,18 +1315,21 @@ static int rj54n1_video_probe(struct i2c_client *client,
 		ret = -ENODEV;
 		dev_info(&client->dev, "No RJ54N1CB0C found, read 0x%x:0x%x\n",
 			 data1, data2);
-		goto ei2c;
+		goto done;
 	}
 
 	/* Configure IOCTL polarity from the platform data: 0 or 1 << 7. */
 	ret = reg_write(client, RJ54N1_IOC, priv->ioctl_high << 7);
 	if (ret < 0)
-		goto ei2c;
+		goto done;
 
 	dev_info(&client->dev, "Detected a RJ54N1CB0C chip ID 0x%x:0x%x\n",
 		 data1, data2);
 
-ei2c:
+	ret = v4l2_ctrl_handler_setup(&rj54n1->hdl);
+
+done:
+	rj54n1_s_power(&rj54n1->subdev, 0);
 	return ret;
 }
 
@@ -1385,9 +1393,9 @@ static int rj54n1_probe(struct i2c_client *client,
 	if (ret < 0) {
 		v4l2_ctrl_handler_free(&rj54n1->hdl);
 		kfree(rj54n1);
-		return ret;
 	}
-	return v4l2_ctrl_handler_setup(&rj54n1->hdl);
+
+	return ret;
 }
 
 static int rj54n1_remove(struct i2c_client *client)
diff --git a/drivers/media/video/soc_camera.c b/drivers/media/video/soc_camera.c
index 6c50032..1ca5642 100644
--- a/drivers/media/video/soc_camera.c
+++ b/drivers/media/video/soc_camera.c
@@ -1070,16 +1070,6 @@ static int soc_camera_probe(struct soc_camera_device *icd)
 	if (ret < 0)
 		goto eadd;
 
-	/*
-	 * This will not yet call v4l2_subdev_core_ops::s_power(1), because the
-	 * subdevice has not been initialised yet. We'll have to call it once
-	 * again after initialisation, even though it shouldn't be needed, we
-	 * don't do any IO here.
-	 */
-	ret = soc_camera_power_on(NULL, icl);
-	if (ret < 0)
-		goto epower;
-
 	/* Must have icd->vdev before registering the device */
 	ret = video_dev_create(icd);
 	if (ret < 0)
@@ -1149,8 +1139,6 @@ static int soc_camera_probe(struct soc_camera_device *icd)
 
 	ici->ops->remove(icd);
 
-	__soc_camera_power_off(icd);
-
 	mutex_unlock(&icd->video_lock);
 
 	return 0;
@@ -1171,8 +1159,6 @@ eadddev:
 	video_device_release(icd->vdev);
 	icd->vdev = NULL;
 evdc:
-	__soc_camera_power_off(icd);
-epower:
 	ici->ops->remove(icd);
 eadd:
 	regulator_bulk_free(icl->num_regulators, icl->regulators);
diff --git a/drivers/media/video/tw9910.c b/drivers/media/video/tw9910.c
index 61a445f..9cad41e 100644
--- a/drivers/media/video/tw9910.c
+++ b/drivers/media/video/tw9910.c
@@ -783,6 +783,7 @@ static int tw9910_video_probe(struct i2c_client *client)
 {
 	struct tw9910_priv *priv = to_tw9910(client);
 	s32 id;
+	int ret;
 
 	/*
 	 * tw9910 only use 8 or 16 bit bus width
@@ -793,6 +794,10 @@ static int tw9910_video_probe(struct i2c_client *client)
 		return -ENODEV;
 	}
 
+	ret = tw9910_s_power(&priv->subdev, 1);
+	if (ret < 0)
+		return ret;
+
 	/*
 	 * check and show Product ID
 	 * So far only revisions 0 and 1 have been seen
@@ -806,7 +811,8 @@ static int tw9910_video_probe(struct i2c_client *client)
 		dev_err(&client->dev,
 			"Product ID error %x:%x\n",
 			id, priv->revision);
-		return -ENODEV;
+		ret = -ENODEV;
+		goto done;
 	}
 
 	dev_info(&client->dev,
@@ -814,7 +820,9 @@ static int tw9910_video_probe(struct i2c_client *client)
 
 	priv->norm = V4L2_STD_NTSC;
 
-	return 0;
+done:
+	tw9910_s_power(&priv->subdev, 0);
+	return ret;
 }
 
 static struct v4l2_subdev_core_ops tw9910_subdev_core_ops = {
-- 
1.7.3.4

