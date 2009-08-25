Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:50555 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752234AbZHYLFt (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 25 Aug 2009 07:05:49 -0400
Received: from lyakh (helo=localhost)
	by axis700.grange with local-esmtp (Exim 4.63)
	(envelope-from <g.liakhovetski@gmx.de>)
	id 1Mftqd-0001mi-Sr
	for linux-media@vger.kernel.org; Tue, 25 Aug 2009 13:05:55 +0200
Date: Tue, 25 Aug 2009 13:05:55 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 1/3] soc-camera: remove .init() and .release() methods from
 struct soc_camera_ops
In-Reply-To: <Pine.LNX.4.64.0908251258410.4810@axis700.grange>
Message-ID: <Pine.LNX.4.64.0908251302140.4810@axis700.grange>
References: <Pine.LNX.4.64.0908251258410.4810@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Remove unneeded soc-camera operations, this also makes the soc-camera API to
v4l2 subdevices thinner.

Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
---
 drivers/media/video/mt9m001.c    |   22 ++++++--------------
 drivers/media/video/mt9m111.c    |   40 +++++++------------------------------
 drivers/media/video/mt9t031.c    |   23 +++++----------------
 drivers/media/video/mt9v022.c    |    8 ++++--
 drivers/media/video/soc_camera.c |   11 ----------
 include/media/soc_camera.h       |    4 ---
 6 files changed, 26 insertions(+), 82 deletions(-)

diff --git a/drivers/media/video/mt9m001.c b/drivers/media/video/mt9m001.c
index e8cf561..4b39479 100644
--- a/drivers/media/video/mt9m001.c
+++ b/drivers/media/video/mt9m001.c
@@ -122,9 +122,8 @@ static int reg_clear(struct i2c_client *client, const u8 reg,
 	return reg_write(client, reg, ret & ~data);
 }
 
-static int mt9m001_init(struct soc_camera_device *icd)
+static int mt9m001_init(struct i2c_client *client)
 {
-	struct i2c_client *client = to_i2c_client(to_soc_camera_control(icd));
 	int ret;
 
 	dev_dbg(&client->dev, "%s\n", __func__);
@@ -144,16 +143,6 @@ static int mt9m001_init(struct soc_camera_device *icd)
 	return ret;
 }
 
-static int mt9m001_release(struct soc_camera_device *icd)
-{
-	struct i2c_client *client = to_i2c_client(to_soc_camera_control(icd));
-
-	/* Disable the chip */
-	reg_write(client, MT9M001_OUTPUT_CONTROL, 0);
-
-	return 0;
-}
-
 static int mt9m001_s_stream(struct v4l2_subdev *sd, int enable)
 {
 	struct i2c_client *client = sd->priv;
@@ -446,8 +435,6 @@ static const struct v4l2_queryctrl mt9m001_controls[] = {
 };
 
 static struct soc_camera_ops mt9m001_ops = {
-	.init			= mt9m001_init,
-	.release		= mt9m001_release,
 	.set_bus_param		= mt9m001_set_bus_param,
 	.query_bus_param	= mt9m001_query_bus_param,
 	.controls		= mt9m001_controls,
@@ -581,6 +568,7 @@ static int mt9m001_video_probe(struct soc_camera_device *icd,
 	struct soc_camera_link *icl = to_soc_camera_link(icd);
 	s32 data;
 	unsigned long flags;
+	int ret;
 
 	/* We must have a parent by now. And it cannot be a wrong one.
 	 * So this entire test is completely redundant. */
@@ -637,7 +625,11 @@ static int mt9m001_video_probe(struct soc_camera_device *icd,
 	dev_info(&client->dev, "Detected a MT9M001 chip ID %x (%s)\n", data,
 		 data == 0x8431 ? "C12STM" : "C12ST");
 
-	return 0;
+	ret = mt9m001_init(client);
+	if (ret < 0)
+		dev_err(&client->dev, "Failed to initialise the camera\n");
+
+	return ret;
 }
 
 static void mt9m001_video_remove(struct soc_camera_device *icd)
diff --git a/drivers/media/video/mt9m111.c b/drivers/media/video/mt9m111.c
index 920dd53..186902f 100644
--- a/drivers/media/video/mt9m111.c
+++ b/drivers/media/video/mt9m111.c
@@ -672,13 +672,9 @@ static const struct v4l2_queryctrl mt9m111_controls[] = {
 };
 
 static int mt9m111_resume(struct soc_camera_device *icd);
-static int mt9m111_init(struct soc_camera_device *icd);
-static int mt9m111_release(struct soc_camera_device *icd);
 
 static struct soc_camera_ops mt9m111_ops = {
-	.init			= mt9m111_init,
 	.resume			= mt9m111_resume,
-	.release		= mt9m111_release,
 	.query_bus_param	= mt9m111_query_bus_param,
 	.set_bus_param		= mt9m111_set_bus_param,
 	.controls		= mt9m111_controls,
@@ -880,9 +876,8 @@ static int mt9m111_resume(struct soc_camera_device *icd)
 	return ret;
 }
 
-static int mt9m111_init(struct soc_camera_device *icd)
+static int mt9m111_init(struct i2c_client *client)
 {
-	struct i2c_client *client = to_i2c_client(to_soc_camera_control(icd));
 	struct mt9m111 *mt9m111 = to_mt9m111(client);
 	int ret;
 
@@ -899,22 +894,6 @@ static int mt9m111_init(struct soc_camera_device *icd)
 	return ret;
 }
 
-static int mt9m111_release(struct soc_camera_device *icd)
-{
-	struct i2c_client *client = to_i2c_client(to_soc_camera_control(icd));
-	struct mt9m111 *mt9m111 = to_mt9m111(client);
-	int ret;
-
-	ret = reg_clear(RESET, MT9M111_RESET_CHIP_ENABLE);
-	if (!ret)
-		mt9m111->powered = 0;
-
-	if (ret < 0)
-		dev_err(&client->dev, "mt9m11x release failed: %d\n", ret);
-
-	return ret;
-}
-
 /*
  * Interface active, can use i2c. If it fails, it can indeed mean, that
  * this wasn't our capture interface, so, we wait for the right one
@@ -934,10 +913,13 @@ static int mt9m111_video_probe(struct soc_camera_device *icd,
 	    to_soc_camera_host(icd->dev.parent)->nr != icd->iface)
 		return -ENODEV;
 
-	ret = mt9m111_enable(client);
-	if (ret)
-		goto ei2c;
-	ret = mt9m111_reset(client);
+	mt9m111->autoexposure = 1;
+	mt9m111->autowhitebalance = 1;
+
+	mt9m111->swap_rgb_even_odd = 1;
+	mt9m111->swap_rgb_red_blue = 1;
+
+	ret = mt9m111_init(client);
 	if (ret)
 		goto ei2c;
 
@@ -962,12 +944,6 @@ static int mt9m111_video_probe(struct soc_camera_device *icd,
 
 	dev_info(&client->dev, "Detected a MT9M11x chip ID %x\n", data);
 
-	mt9m111->autoexposure = 1;
-	mt9m111->autowhitebalance = 1;
-
-	mt9m111->swap_rgb_even_odd = 1;
-	mt9m111->swap_rgb_red_blue = 1;
-
 ei2c:
 	return ret;
 }
diff --git a/drivers/media/video/mt9t031.c b/drivers/media/video/mt9t031.c
index f234ba6..9a64896 100644
--- a/drivers/media/video/mt9t031.c
+++ b/drivers/media/video/mt9t031.c
@@ -163,20 +163,6 @@ static int mt9t031_disable(struct i2c_client *client)
 	return 0;
 }
 
-static int mt9t031_init(struct soc_camera_device *icd)
-{
-	struct i2c_client *client = to_i2c_client(to_soc_camera_control(icd));
-
-	return mt9t031_idle(client);
-}
-
-static int mt9t031_release(struct soc_camera_device *icd)
-{
-	struct i2c_client *client = to_i2c_client(to_soc_camera_control(icd));
-
-	return mt9t031_disable(client);
-}
-
 static int mt9t031_s_stream(struct v4l2_subdev *sd, int enable)
 {
 	struct i2c_client *client = sd->priv;
@@ -539,8 +525,6 @@ static const struct v4l2_queryctrl mt9t031_controls[] = {
 };
 
 static struct soc_camera_ops mt9t031_ops = {
-	.init			= mt9t031_init,
-	.release		= mt9t031_release,
 	.set_bus_param		= mt9t031_set_bus_param,
 	.query_bus_param	= mt9t031_query_bus_param,
 	.controls		= mt9t031_controls,
@@ -689,6 +673,7 @@ static int mt9t031_video_probe(struct i2c_client *client)
 	struct soc_camera_device *icd = client->dev.platform_data;
 	struct mt9t031 *mt9t031 = to_mt9t031(client);
 	s32 data;
+	int ret;
 
 	/* Enable the chip */
 	data = reg_write(client, MT9T031_CHIP_ENABLE, 1);
@@ -711,7 +696,11 @@ static int mt9t031_video_probe(struct i2c_client *client)
 
 	dev_info(&client->dev, "Detected a MT9T031 chip ID %x\n", data);
 
-	return 0;
+	ret = mt9t031_idle(client);
+	if (ret < 0)
+		dev_err(&client->dev, "Failed to initialise the camera\n");
+
+	return ret;
 }
 
 static struct v4l2_subdev_core_ops mt9t031_subdev_core_ops = {
diff --git a/drivers/media/video/mt9v022.c b/drivers/media/video/mt9v022.c
index 35ea0dd..5c47b55 100644
--- a/drivers/media/video/mt9v022.c
+++ b/drivers/media/video/mt9v022.c
@@ -138,9 +138,8 @@ static int reg_clear(struct i2c_client *client, const u8 reg,
 	return reg_write(client, reg, ret & ~data);
 }
 
-static int mt9v022_init(struct soc_camera_device *icd)
+static int mt9v022_init(struct i2c_client *client)
 {
-	struct i2c_client *client = to_i2c_client(to_soc_camera_control(icd));
 	struct mt9v022 *mt9v022 = to_mt9v022(client);
 	int ret;
 
@@ -532,7 +531,6 @@ static const struct v4l2_queryctrl mt9v022_controls[] = {
 };
 
 static struct soc_camera_ops mt9v022_ops = {
-	.init			= mt9v022_init,
 	.set_bus_param		= mt9v022_set_bus_param,
 	.query_bus_param	= mt9v022_query_bus_param,
 	.controls		= mt9v022_controls,
@@ -751,6 +749,10 @@ static int mt9v022_video_probe(struct soc_camera_device *icd,
 		 data, mt9v022->model == V4L2_IDENT_MT9V022IX7ATM ?
 		 "monochrome" : "colour");
 
+	ret = mt9v022_init(client);
+	if (ret < 0)
+		dev_err(&client->dev, "Failed to initialise the camera\n");
+
 ei2c:
 	return ret;
 }
diff --git a/drivers/media/video/soc_camera.c b/drivers/media/video/soc_camera.c
index 86e0648..2792116 100644
--- a/drivers/media/video/soc_camera.c
+++ b/drivers/media/video/soc_camera.c
@@ -385,12 +385,6 @@ static int soc_camera_open(struct file *file)
 			goto eiciadd;
 		}
 
-		if (icd->ops->init) {
-			ret = icd->ops->init(icd);
-			if (ret < 0)
-				goto einit;
-		}
-
 		/* Try to configure with default parameters */
 		ret = soc_camera_set_fmt(icf, &f);
 		if (ret < 0)
@@ -411,9 +405,6 @@ static int soc_camera_open(struct file *file)
 	 * and use_count == 1
 	 */
 esfmt:
-	if (icd->ops->release)
-		icd->ops->release(icd);
-einit:
 	ici->ops->remove(icd);
 eiciadd:
 	if (icl->power)
@@ -438,8 +429,6 @@ static int soc_camera_close(struct file *file)
 	if (!icd->use_count) {
 		struct soc_camera_link *icl = to_soc_camera_link(icd);
 
-		if (icd->ops->release)
-			icd->ops->release(icd);
 		ici->ops->remove(icd);
 		if (icl->power)
 			icl->power(icd->pdev, 0);
diff --git a/include/media/soc_camera.h b/include/media/soc_camera.h
index 3185e8d..f95cc4a 100644
--- a/include/media/soc_camera.h
+++ b/include/media/soc_camera.h
@@ -191,12 +191,8 @@ struct soc_camera_format_xlate {
 struct soc_camera_ops {
 	int (*suspend)(struct soc_camera_device *, pm_message_t state);
 	int (*resume)(struct soc_camera_device *);
-	int (*init)(struct soc_camera_device *);
-	int (*release)(struct soc_camera_device *);
 	unsigned long (*query_bus_param)(struct soc_camera_device *);
 	int (*set_bus_param)(struct soc_camera_device *, unsigned long);
-	int (*get_chip_id)(struct soc_camera_device *,
-			   struct v4l2_dbg_chip_ident *);
 	int (*enum_input)(struct soc_camera_device *, struct v4l2_input *);
 	const struct v4l2_queryctrl *controls;
 	int num_controls;
-- 
1.6.2.4

