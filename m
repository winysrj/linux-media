Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:60437 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754384Ab2GEUis (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 5 Jul 2012 16:38:48 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: linux-media@vger.kernel.org
Subject: [PATCH v2 9/9] soc-camera: Push probe-time power management to drivers
Date: Thu,  5 Jul 2012 22:38:48 +0200
Message-Id: <1341520728-2707-10-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1341520728-2707-1-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1341520728-2707-1-git-send-email-laurent.pinchart@ideasonboard.com>
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
 drivers/media/video/mt9t031.c    |   37 +++++++----------
 drivers/media/video/mt9t112.c    |   12 +++++-
 drivers/media/video/mt9v022.c    |    5 ++
 drivers/media/video/ov2640.c     |   11 ++++-
 drivers/media/video/ov5642.c     |   21 ++++++++--
 drivers/media/video/ov6650.c     |   19 ++++++---
 drivers/media/video/ov772x.c     |   14 ++++++-
 drivers/media/video/ov9640.c     |   17 ++++++--
 drivers/media/video/ov9740.c     |   23 +++++++----
 drivers/media/video/rj54n1cb0c.c |   18 ++++++--
 drivers/media/video/soc_camera.c |   20 ---------
 drivers/media/video/tw9910.c     |   12 +++++-
 15 files changed, 204 insertions(+), 123 deletions(-)

diff --git a/drivers/media/video/imx074.c b/drivers/media/video/imx074.c
index ade1987..f8534ee 100644
--- a/drivers/media/video/imx074.c
+++ b/drivers/media/video/imx074.c
@@ -310,26 +310,33 @@ static struct v4l2_subdev_ops imx074_subdev_ops = {
 
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
@@ -411,7 +418,11 @@ static int imx074_video_probe(struct i2c_client *client)
 
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
index cd71230..d85be41 100644
--- a/drivers/media/video/mt9m001.c
+++ b/drivers/media/video/mt9m001.c
@@ -490,6 +490,10 @@ static int mt9m001_video_probe(struct soc_camera_link *icl,
 	unsigned long flags;
 	int ret;
 
+	ret = mt9m001_s_power(&mt9m001->subdev, 1);
+	if (ret < 0)
+		return ret;
+
 	/* Enable the chip */
 	data = reg_write(client, MT9M001_CHIP_ENABLE, 1);
 	dev_dbg(&client->dev, "write: %d\n", data);
@@ -511,7 +515,8 @@ static int mt9m001_video_probe(struct soc_camera_link *icl,
 	default:
 		dev_err(&client->dev,
 			"No MT9M001 chip detected, register read %x\n", data);
-		return -ENODEV;
+		ret = -ENODEV;
+		goto done;
 	}
 
 	mt9m001->num_fmts = 0;
@@ -540,11 +545,17 @@ static int mt9m001_video_probe(struct soc_camera_link *icl,
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
index a7a649a..8a10729 100644
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
@@ -942,6 +907,51 @@ static struct v4l2_subdev_ops mt9m111_subdev_ops = {
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
+	mt9m111_s_power(&mt9m111->subdev, 0);
+	return ret;
+}
+
 static int mt9m111_probe(struct i2c_client *client,
 			 const struct i2c_device_id *did)
 {
diff --git a/drivers/media/video/mt9t031.c b/drivers/media/video/mt9t031.c
index 9666e20..4f12177 100644
--- a/drivers/media/video/mt9t031.c
+++ b/drivers/media/video/mt9t031.c
@@ -161,14 +161,6 @@ static int mt9t031_idle(struct i2c_client *client)
 	return ret >= 0 ? 0 : -EIO;
 }
 
-static int mt9t031_disable(struct i2c_client *client)
-{
-	/* Disable the chip */
-	reg_clear(client, MT9T031_OUTPUT_CONTROL, 2);
-
-	return 0;
-}
-
 static int mt9t031_s_stream(struct v4l2_subdev *sd, int enable)
 {
 	struct i2c_client *client = v4l2_get_subdevdata(sd);
@@ -643,9 +635,15 @@ static int mt9t031_video_probe(struct i2c_client *client)
 	s32 data;
 	int ret;
 
-	/* Enable the chip */
-	data = reg_write(client, MT9T031_CHIP_ENABLE, 1);
-	dev_dbg(&client->dev, "write: %d\n", data);
+	ret = mt9t031_s_power(&mt9t031->subdev, 1);
+	if (ret < 0)
+		return ret;
+
+	ret = mt9t031_idle(client);
+	if (ret < 0) {
+		dev_err(&client->dev, "Failed to initialise the camera\n");
+		return ret;
+	}
 
 	/* Read out the chip version register */
 	data = reg_read(client, MT9T031_CHIP_VERSION);
@@ -657,16 +655,16 @@ static int mt9t031_video_probe(struct i2c_client *client)
 	default:
 		dev_err(&client->dev,
 			"No MT9T031 chip detected, register read %x\n", data);
-		return -ENODEV;
+		ret = -ENODEV;
+		goto done;
 	}
 
 	dev_info(&client->dev, "Detected a MT9T031 chip ID %x\n", data);
 
-	ret = mt9t031_idle(client);
-	if (ret < 0)
-		dev_err(&client->dev, "Failed to initialise the camera\n");
-	else
-		v4l2_ctrl_handler_setup(&mt9t031->hdl);
+	ret = v4l2_ctrl_handler_setup(&mt9t031->hdl);
+
+done:
+	mt9t031_s_power(&mt9t031->subdev, 0);
 
 	return ret;
 }
@@ -817,12 +815,7 @@ static int mt9t031_probe(struct i2c_client *client,
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
index 624ceec..9ba428e 100644
--- a/drivers/media/video/mt9t112.c
+++ b/drivers/media/video/mt9t112.c
@@ -1041,6 +1041,11 @@ static int mt9t112_camera_probe(struct i2c_client *client)
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
@@ -1058,12 +1063,15 @@ static int mt9t112_camera_probe(struct i2c_client *client)
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
index 5f09cb7..2edea84 100644
--- a/drivers/media/video/mt9v022.c
+++ b/drivers/media/video/mt9v022.c
@@ -578,6 +578,10 @@ static int mt9v022_video_probe(struct i2c_client *client)
 	int ret;
 	unsigned long flags;
 
+	ret = mt9v022_s_power(&mt9v022->subdev, 1);
+	if (ret < 0)
+		return ret;
+
 	/* Read out the chip version register */
 	data = reg_read(client, MT9V022_CHIP_VERSION);
 
@@ -648,6 +652,7 @@ static int mt9v022_video_probe(struct i2c_client *client)
 		dev_err(&client->dev, "Failed to initialise the camera\n");
 
 ei2c:
+	mt9v022_s_power(&mt9v022->subdev, 0);
 	return ret;
 }
 
diff --git a/drivers/media/video/ov2640.c b/drivers/media/video/ov2640.c
index 16ed091..78ac574 100644
--- a/drivers/media/video/ov2640.c
+++ b/drivers/media/video/ov2640.c
@@ -955,6 +955,10 @@ static int ov2640_video_probe(struct i2c_client *client)
 	const char *devname;
 	int ret;
 
+	ret = ov2640_s_power(&priv->subdev, 1);
+	if (ret < 0)
+		return ret;
+
 	/*
 	 * check and show product ID and manufacturer ID
 	 */
@@ -973,16 +977,17 @@ static int ov2640_video_probe(struct i2c_client *client)
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
index 61824c6..d886c0b 100644
--- a/drivers/media/video/ov5642.c
+++ b/drivers/media/video/ov5642.c
@@ -980,29 +980,40 @@ static struct v4l2_subdev_ops ov5642_subdev_ops = {
 
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
index 12d57a5..65b031f 100644
--- a/drivers/media/video/ov6650.c
+++ b/drivers/media/video/ov6650.c
@@ -829,8 +829,13 @@ static int ov6650_prog_dflt(struct i2c_client *client)
 
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
@@ -844,12 +849,13 @@ static int ov6650_video_probe(struct i2c_client *client)
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
@@ -859,7 +865,11 @@ static int ov6650_video_probe(struct i2c_client *client)
 	ret = ov6650_reset(client);
 	if (!ret)
 		ret = ov6650_prog_dflt(client);
+	if (!ret)
+		ret = v4l2_ctrl_handler_setup(&priv->hdl);
 
+done:
+	ov6650_s_power(&priv->subdev, 0);
 	return ret;
 }
 
@@ -1019,9 +1029,6 @@ static int ov6650_probe(struct i2c_client *client,
 	priv->colorspace  = V4L2_COLORSPACE_JPEG;
 
 	ret = ov6650_video_probe(client);
-	if (!ret)
-		ret = v4l2_ctrl_handler_setup(&priv->hdl);
-
 	if (ret) {
 		v4l2_ctrl_handler_free(&priv->hdl);
 		kfree(priv);
diff --git a/drivers/media/video/ov772x.c b/drivers/media/video/ov772x.c
index a022662..641f6f4 100644
--- a/drivers/media/video/ov772x.c
+++ b/drivers/media/video/ov772x.c
@@ -962,6 +962,11 @@ static int ov772x_video_probe(struct i2c_client *client)
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
@@ -981,7 +986,8 @@ static int ov772x_video_probe(struct i2c_client *client)
 	default:
 		dev_err(&client->dev,
 			"Product ID error %x:%x\n", pid, ver);
-		return -ENODEV;
+		ret = -ENODEV;
+		goto done;
 	}
 
 	dev_info(&client->dev,
@@ -991,7 +997,11 @@ static int ov772x_video_probe(struct i2c_client *client)
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
index 8c13b3b..8f3ef23 100644
--- a/drivers/media/video/ov9640.c
+++ b/drivers/media/video/ov9640.c
@@ -592,7 +592,11 @@ static int ov9640_video_probe(struct i2c_client *client)
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
@@ -606,7 +610,7 @@ static int ov9640_video_probe(struct i2c_client *client)
 	if (!ret)
 		ret = ov9640_reg_read(client, OV9640_MIDL, &midl);
 	if (ret)
-		return ret;
+		goto done;
 
 	switch (VERSION(pid, ver)) {
 	case OV9640_V2:
@@ -620,13 +624,18 @@ static int ov9640_video_probe(struct i2c_client *client)
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
index ca1cee7..32226c9 100644
--- a/drivers/media/video/rj54n1cb0c.c
+++ b/drivers/media/video/rj54n1cb0c.c
@@ -1296,9 +1296,14 @@ static struct v4l2_subdev_ops rj54n1_subdev_ops = {
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
@@ -1307,18 +1312,21 @@ static int rj54n1_video_probe(struct i2c_client *client,
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
 
@@ -1382,9 +1390,9 @@ static int rj54n1_probe(struct i2c_client *client,
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
index 576146e..d485d32 100644
--- a/drivers/media/video/soc_camera.c
+++ b/drivers/media/video/soc_camera.c
@@ -1068,22 +1068,6 @@ static int soc_camera_probe(struct soc_camera_device *icd)
 	if (ret < 0)
 		goto eadd;
 
-	/*
-	 * This will not yet call v4l2_subdev_core_ops::s_power(1), because the
-	 * subdevice has not been initialised yet. We'll have to call it once
-	 * again after initialisation, even though it shouldn't be needed, we
-	 * don't do any IO here.
-	 *
-	 * The device pointer passed to soc_camera_power_on(), and ultimately to
-	 * the platform callback, should be the subdev physical device. However,
-	 * we have no way to retrieve a pointer to that device here. This isn't
-	 * a real issue, as no platform currently uses the device pointer, and
-	 * this soc_camera_power_on() call will be removed in the next commit.
-	 */
-	ret = soc_camera_power_on(icd->pdev, icl);
-	if (ret < 0)
-		goto epower;
-
 	/* Must have icd->vdev before registering the device */
 	ret = video_dev_create(icd);
 	if (ret < 0)
@@ -1153,8 +1137,6 @@ static int soc_camera_probe(struct soc_camera_device *icd)
 
 	ici->ops->remove(icd);
 
-	__soc_camera_power_off(icd);
-
 	mutex_unlock(&icd->video_lock);
 
 	return 0;
@@ -1175,8 +1157,6 @@ eadddev:
 	video_device_release(icd->vdev);
 	icd->vdev = NULL;
 evdc:
-	__soc_camera_power_off(icd);
-epower:
 	ici->ops->remove(icd);
 eadd:
 	regulator_bulk_free(icl->num_regulators, icl->regulators);
diff --git a/drivers/media/video/tw9910.c b/drivers/media/video/tw9910.c
index f283650..140716e 100644
--- a/drivers/media/video/tw9910.c
+++ b/drivers/media/video/tw9910.c
@@ -780,6 +780,7 @@ static int tw9910_video_probe(struct i2c_client *client)
 {
 	struct tw9910_priv *priv = to_tw9910(client);
 	s32 id;
+	int ret;
 
 	/*
 	 * tw9910 only use 8 or 16 bit bus width
@@ -790,6 +791,10 @@ static int tw9910_video_probe(struct i2c_client *client)
 		return -ENODEV;
 	}
 
+	ret = tw9910_s_power(&priv->subdev, 1);
+	if (ret < 0)
+		return ret;
+
 	/*
 	 * check and show Product ID
 	 * So far only revisions 0 and 1 have been seen
@@ -803,7 +808,8 @@ static int tw9910_video_probe(struct i2c_client *client)
 		dev_err(&client->dev,
 			"Product ID error %x:%x\n",
 			id, priv->revision);
-		return -ENODEV;
+		ret = -ENODEV;
+		goto done;
 	}
 
 	dev_info(&client->dev,
@@ -811,7 +817,9 @@ static int tw9910_video_probe(struct i2c_client *client)
 
 	priv->norm = V4L2_STD_NTSC;
 
-	return 0;
+done:
+	tw9910_s_power(&priv->subdev, 0);
+	return ret;
 }
 
 static struct v4l2_subdev_core_ops tw9910_subdev_core_ops = {
-- 
1.7.8.6

