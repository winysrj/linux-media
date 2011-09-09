Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.171]:64573 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758672Ab1IIRna (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 9 Sep 2011 13:43:30 -0400
Received: from localhost (localhost [127.0.0.1])
	by axis700.grange (Postfix) with ESMTP id D0C3D18B03B
	for <linux-media@vger.kernel.org>; Fri,  9 Sep 2011 19:43:27 +0200 (CEST)
Date: Fri, 9 Sep 2011 19:43:27 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 1/4] V4L: soc-camera: start removing struct soc_camera_device
 from client drivers
In-Reply-To: <Pine.LNX.4.64.1109091917260.915@axis700.grange>
Message-ID: <Pine.LNX.4.64.1109091920320.915@axis700.grange>
References: <Pine.LNX.4.64.1109091917260.915@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Remove most trivial uses of struct soc_camera_device from most client
drivers, abstracting some of them inside inline functions. Next steps
will eliminate remaining uses and modify inline functions to not use
struct soc_camera_device.

Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
---
 drivers/media/video/imx074.c     |   17 +++-----------
 drivers/media/video/mt9m001.c    |   39 +++++++++-----------------------
 drivers/media/video/mt9m111.c    |   21 +++--------------
 drivers/media/video/mt9t031.c    |   22 ++++++-----------
 drivers/media/video/mt9t112.c    |   45 +++++++++++++------------------------
 drivers/media/video/mt9v022.c    |   44 +++++++++---------------------------
 drivers/media/video/ov2640.c     |   27 ++++++----------------
 drivers/media/video/ov5642.c     |   17 +++-----------
 drivers/media/video/ov6650.c     |   20 ++++------------
 drivers/media/video/ov772x.c     |   31 ++++++++-----------------
 drivers/media/video/ov9640.c     |   21 +++--------------
 drivers/media/video/ov9740.c     |   21 +++--------------
 drivers/media/video/rj54n1cb0c.c |   27 +++++-----------------
 drivers/media/video/tw9910.c     |   32 ++++++++------------------
 include/media/soc_camera.h       |   25 +++++++++++++++++---
 15 files changed, 125 insertions(+), 284 deletions(-)

diff --git a/drivers/media/video/imx074.c b/drivers/media/video/imx074.c
index 3f5d4de..4f3ce7f 100644
--- a/drivers/media/video/imx074.c
+++ b/drivers/media/video/imx074.c
@@ -298,8 +298,7 @@ static struct v4l2_subdev_ops imx074_subdev_ops = {
 	.video	= &imx074_subdev_video_ops,
 };
 
-static int imx074_video_probe(struct soc_camera_device *icd,
-			      struct i2c_client *client)
+static int imx074_video_probe(struct i2c_client *client)
 {
 	int ret;
 	u16 id;
@@ -409,17 +408,10 @@ static int imx074_probe(struct i2c_client *client,
 			const struct i2c_device_id *did)
 {
 	struct imx074 *priv;
-	struct soc_camera_device *icd = client->dev.platform_data;
 	struct i2c_adapter *adapter = to_i2c_adapter(client->dev.parent);
-	struct soc_camera_link *icl;
+	struct soc_camera_link *icl = soc_camera_i2c_to_link(client);
 	int ret;
 
-	if (!icd) {
-		dev_err(&client->dev, "IMX074: missing soc-camera data!\n");
-		return -EINVAL;
-	}
-
-	icl = to_soc_camera_link(icd);
 	if (!icl) {
 		dev_err(&client->dev, "IMX074: missing platform data!\n");
 		return -EINVAL;
@@ -439,7 +431,7 @@ static int imx074_probe(struct i2c_client *client,
 
 	priv->fmt	= &imx074_colour_fmts[0];
 
-	ret = imx074_video_probe(icd, client);
+	ret = imx074_video_probe(client);
 	if (ret < 0) {
 		kfree(priv);
 		return ret;
@@ -451,8 +443,7 @@ static int imx074_probe(struct i2c_client *client,
 static int imx074_remove(struct i2c_client *client)
 {
 	struct imx074 *priv = to_imx074(client);
-	struct soc_camera_device *icd = client->dev.platform_data;
-	struct soc_camera_link *icl = to_soc_camera_link(icd);
+	struct soc_camera_link *icl = soc_camera_i2c_to_link(client);
 
 	if (icl->free_bus)
 		icl->free_bus(icl);
diff --git a/drivers/media/video/mt9m001.c b/drivers/media/video/mt9m001.c
index 42bb3c8..58cdced 100644
--- a/drivers/media/video/mt9m001.c
+++ b/drivers/media/video/mt9m001.c
@@ -205,7 +205,7 @@ static int mt9m001_s_crop(struct v4l2_subdev *sd, struct v4l2_crop *a)
 
 	/*
 	 * The caller provides a supported format, as verified per
-	 * call to icd->try_fmt()
+	 * call to .try_mbus_fmt()
 	 */
 	if (!ret)
 		ret = reg_write(client, MT9M001_COLUMN_START, rect.left);
@@ -474,19 +474,14 @@ static int mt9m001_s_ctrl(struct v4l2_ctrl *ctrl)
  * Interface active, can use i2c. If it fails, it can indeed mean, that
  * this wasn't our capture interface, so, we wait for the right one
  */
-static int mt9m001_video_probe(struct soc_camera_device *icd,
+static int mt9m001_video_probe(struct soc_camera_link *icl,
 			       struct i2c_client *client)
 {
 	struct mt9m001 *mt9m001 = to_mt9m001(client);
-	struct soc_camera_link *icl = to_soc_camera_link(icd);
 	s32 data;
 	unsigned long flags;
 	int ret;
 
-	/* We must have a parent by now. And it cannot be a wrong one. */
-	BUG_ON(!icd->parent ||
-	       to_soc_camera_host(icd->parent)->nr != icd->iface);
-
 	/* Enable the chip */
 	data = reg_write(client, MT9M001_CHIP_ENABLE, 1);
 	dev_dbg(&client->dev, "write: %d\n", data);
@@ -544,12 +539,8 @@ static int mt9m001_video_probe(struct soc_camera_device *icd,
 	return v4l2_ctrl_handler_setup(&mt9m001->hdl);
 }
 
-static void mt9m001_video_remove(struct soc_camera_device *icd)
+static void mt9m001_video_remove(struct soc_camera_link *icl)
 {
-	struct soc_camera_link *icl = to_soc_camera_link(icd);
-
-	dev_dbg(icd->pdev, "Video removed: %p, %p\n",
-		icd->parent, icd->vdev);
 	if (icl->free_bus)
 		icl->free_bus(icl);
 }
@@ -594,8 +585,7 @@ static int mt9m001_g_mbus_config(struct v4l2_subdev *sd,
 				struct v4l2_mbus_config *cfg)
 {
 	struct i2c_client *client = v4l2_get_subdevdata(sd);
-	struct soc_camera_device *icd = client->dev.platform_data;
-	struct soc_camera_link *icl = to_soc_camera_link(icd);
+	struct soc_camera_link *icl = soc_camera_i2c_to_link(client);
 
 	/* MT9M001 has all capture_format parameters fixed */
 	cfg->flags = V4L2_MBUS_PCLK_SAMPLE_FALLING |
@@ -610,9 +600,9 @@ static int mt9m001_g_mbus_config(struct v4l2_subdev *sd,
 static int mt9m001_s_mbus_config(struct v4l2_subdev *sd,
 				const struct v4l2_mbus_config *cfg)
 {
-	struct i2c_client *client = v4l2_get_subdevdata(sd);
-	struct soc_camera_device *icd = client->dev.platform_data;
-	struct soc_camera_link *icl = to_soc_camera_link(icd);
+	const struct i2c_client *client = v4l2_get_subdevdata(sd);
+	struct soc_camera_device *icd = soc_camera_from_i2c(client);
+	struct soc_camera_link *icl = soc_camera_i2c_to_link(client);
 	/*
 	 * Cannot use icd->current_fmt->host_fmt->bits_per_sample, because that
 	 * is the number of bits, that the host has to sample, not the number of
@@ -658,17 +648,10 @@ static int mt9m001_probe(struct i2c_client *client,
 			 const struct i2c_device_id *did)
 {
 	struct mt9m001 *mt9m001;
-	struct soc_camera_device *icd = client->dev.platform_data;
 	struct i2c_adapter *adapter = to_i2c_adapter(client->dev.parent);
-	struct soc_camera_link *icl;
+	struct soc_camera_link *icl = soc_camera_i2c_to_link(client);
 	int ret;
 
-	if (!icd) {
-		dev_err(&client->dev, "MT9M001: missing soc-camera data!\n");
-		return -EINVAL;
-	}
-
-	icl = to_soc_camera_link(icd);
 	if (!icl) {
 		dev_err(&client->dev, "MT9M001 driver needs platform data\n");
 		return -EINVAL;
@@ -716,7 +699,7 @@ static int mt9m001_probe(struct i2c_client *client,
 	mt9m001->rect.width	= MT9M001_MAX_WIDTH;
 	mt9m001->rect.height	= MT9M001_MAX_HEIGHT;
 
-	ret = mt9m001_video_probe(icd, client);
+	ret = mt9m001_video_probe(icl, client);
 	if (ret) {
 		v4l2_ctrl_handler_free(&mt9m001->hdl);
 		kfree(mt9m001);
@@ -728,11 +711,11 @@ static int mt9m001_probe(struct i2c_client *client,
 static int mt9m001_remove(struct i2c_client *client)
 {
 	struct mt9m001 *mt9m001 = to_mt9m001(client);
-	struct soc_camera_device *icd = client->dev.platform_data;
+	struct soc_camera_link *icl = soc_camera_i2c_to_link(client);
 
 	v4l2_device_unregister_subdev(&mt9m001->subdev);
 	v4l2_ctrl_handler_free(&mt9m001->hdl);
-	mt9m001_video_remove(icd);
+	mt9m001_video_remove(icl);
 	kfree(mt9m001);
 
 	return 0;
diff --git a/drivers/media/video/mt9m111.c b/drivers/media/video/mt9m111.c
index f3138f8..9feeb0c 100644
--- a/drivers/media/video/mt9m111.c
+++ b/drivers/media/video/mt9m111.c
@@ -784,17 +784,12 @@ static int mt9m111_init(struct mt9m111 *mt9m111)
  * Interface active, can use i2c. If it fails, it can indeed mean, that
  * this wasn't our capture interface, so, we wait for the right one
  */
-static int mt9m111_video_probe(struct soc_camera_device *icd,
-			       struct i2c_client *client)
+static int mt9m111_video_probe(struct i2c_client *client)
 {
 	struct mt9m111 *mt9m111 = to_mt9m111(client);
 	s32 data;
 	int ret;
 
-	/* We must have a parent by now. And it cannot be a wrong one. */
-	BUG_ON(!icd->parent ||
-	       to_soc_camera_host(icd->parent)->nr != icd->iface);
-
 	data = reg_read(CHIP_VERSION);
 
 	switch (data) {
@@ -881,8 +876,7 @@ static int mt9m111_g_mbus_config(struct v4l2_subdev *sd,
 				struct v4l2_mbus_config *cfg)
 {
 	struct i2c_client *client = v4l2_get_subdevdata(sd);
-	struct soc_camera_device *icd = client->dev.platform_data;
-	struct soc_camera_link *icl = to_soc_camera_link(icd);
+	struct soc_camera_link *icl = soc_camera_i2c_to_link(client);
 
 	cfg->flags = V4L2_MBUS_MASTER | V4L2_MBUS_PCLK_SAMPLE_RISING |
 		V4L2_MBUS_HSYNC_ACTIVE_HIGH | V4L2_MBUS_VSYNC_ACTIVE_HIGH |
@@ -913,17 +907,10 @@ static int mt9m111_probe(struct i2c_client *client,
 			 const struct i2c_device_id *did)
 {
 	struct mt9m111 *mt9m111;
-	struct soc_camera_device *icd = client->dev.platform_data;
 	struct i2c_adapter *adapter = to_i2c_adapter(client->dev.parent);
-	struct soc_camera_link *icl;
+	struct soc_camera_link *icl = soc_camera_i2c_to_link(client);
 	int ret;
 
-	if (!icd) {
-		dev_err(&client->dev, "mt9m111: soc-camera data missing!\n");
-		return -EINVAL;
-	}
-
-	icl = to_soc_camera_link(icd);
 	if (!icl) {
 		dev_err(&client->dev, "mt9m111: driver needs platform data\n");
 		return -EINVAL;
@@ -968,7 +955,7 @@ static int mt9m111_probe(struct i2c_client *client,
 	mt9m111->fmt		= &mt9m111_colour_fmts[0];
 	mt9m111->lastpage	= -1;
 
-	ret = mt9m111_video_probe(icd, client);
+	ret = mt9m111_video_probe(client);
 	if (ret) {
 		v4l2_ctrl_handler_free(&mt9m111->hdl);
 		kfree(mt9m111);
diff --git a/drivers/media/video/mt9t031.c b/drivers/media/video/mt9t031.c
index 7ce3799..95cd602 100644
--- a/drivers/media/video/mt9t031.c
+++ b/drivers/media/video/mt9t031.c
@@ -265,7 +265,7 @@ static int mt9t031_set_params(struct i2c_client *client,
 
 	/*
 	 * The caller provides a supported format, as guaranteed by
-	 * icd->try_fmt_cap(), soc_camera_s_crop() and soc_camera_cropcap()
+	 * .try_mbus_fmt(), soc_camera_s_crop() and soc_camera_cropcap()
 	 */
 	if (ret >= 0)
 		ret = reg_write(client, MT9T031_COLUMN_START, rect->left);
@@ -573,8 +573,7 @@ static int mt9t031_runtime_suspend(struct device *dev)
 static int mt9t031_runtime_resume(struct device *dev)
 {
 	struct video_device *vdev = to_video_device(dev);
-	struct soc_camera_device *icd = dev_get_drvdata(vdev->parent);
-	struct v4l2_subdev *sd = soc_camera_to_subdev(icd);
+	struct v4l2_subdev *sd = soc_camera_vdev_to_subdev(vdev);
 	struct i2c_client *client = v4l2_get_subdevdata(sd);
 	struct mt9t031 *mt9t031 = to_mt9t031(client);
 
@@ -684,8 +683,7 @@ static int mt9t031_g_mbus_config(struct v4l2_subdev *sd,
 				struct v4l2_mbus_config *cfg)
 {
 	struct i2c_client *client = v4l2_get_subdevdata(sd);
-	struct soc_camera_device *icd = client->dev.platform_data;
-	struct soc_camera_link *icl = to_soc_camera_link(icd);
+	struct soc_camera_link *icl = soc_camera_i2c_to_link(client);
 
 	cfg->flags = V4L2_MBUS_MASTER | V4L2_MBUS_PCLK_SAMPLE_RISING |
 		V4L2_MBUS_PCLK_SAMPLE_FALLING | V4L2_MBUS_HSYNC_ACTIVE_HIGH |
@@ -700,8 +698,7 @@ static int mt9t031_s_mbus_config(struct v4l2_subdev *sd,
 				const struct v4l2_mbus_config *cfg)
 {
 	struct i2c_client *client = v4l2_get_subdevdata(sd);
-	struct soc_camera_device *icd = client->dev.platform_data;
-	struct soc_camera_link *icl = to_soc_camera_link(icd);
+	struct soc_camera_link *icl = soc_camera_i2c_to_link(client);
 
 	if (soc_camera_apply_board_flags(icl, cfg) &
 	    V4L2_MBUS_PCLK_SAMPLE_FALLING)
@@ -737,16 +734,13 @@ static int mt9t031_probe(struct i2c_client *client,
 			 const struct i2c_device_id *did)
 {
 	struct mt9t031 *mt9t031;
-	struct soc_camera_device *icd = client->dev.platform_data;
+	struct soc_camera_link *icl = soc_camera_i2c_to_link(client);
 	struct i2c_adapter *adapter = to_i2c_adapter(client->dev.parent);
 	int ret;
 
-	if (icd) {
-		struct soc_camera_link *icl = to_soc_camera_link(icd);
-		if (!icl) {
-			dev_err(&client->dev, "MT9T031 driver needs platform data\n");
-			return -EINVAL;
-		}
+	if (!icl) {
+		dev_err(&client->dev, "MT9T031 driver needs platform data\n");
+		return -EINVAL;
 	}
 
 	if (!i2c_check_functionality(adapter, I2C_FUNC_SMBUS_WORD_DATA)) {
diff --git a/drivers/media/video/mt9t112.c b/drivers/media/video/mt9t112.c
index b8da7fe..5b045a1 100644
--- a/drivers/media/video/mt9t112.c
+++ b/drivers/media/video/mt9t112.c
@@ -89,7 +89,6 @@ struct mt9t112_priv {
 	struct v4l2_subdev		 subdev;
 	struct mt9t112_camera_info	*info;
 	struct i2c_client		*client;
-	struct soc_camera_device	 icd;
 	struct v4l2_rect		 frame;
 	const struct mt9t112_format	*format;
 	int				 model;
@@ -306,38 +305,38 @@ static int mt9t112_clock_info(const struct i2c_client *client, u32 ext)
 	n = (n >> 8) & 0x003f;
 
 	enable = ((6000 > ext) || (54000 < ext)) ? "X" : "";
-	dev_info(&client->dev, "EXTCLK          : %10u K %s\n", ext, enable);
+	dev_dbg(&client->dev, "EXTCLK          : %10u K %s\n", ext, enable);
 
 	vco = 2 * m * ext / (n+1);
 	enable = ((384000 > vco) || (768000 < vco)) ? "X" : "";
-	dev_info(&client->dev, "VCO             : %10u K %s\n", vco, enable);
+	dev_dbg(&client->dev, "VCO             : %10u K %s\n", vco, enable);
 
 	clk = vco / (p1+1) / (p2+1);
 	enable = (96000 < clk) ? "X" : "";
-	dev_info(&client->dev, "PIXCLK          : %10u K %s\n", clk, enable);
+	dev_dbg(&client->dev, "PIXCLK          : %10u K %s\n", clk, enable);
 
 	clk = vco / (p3+1);
 	enable = (768000 < clk) ? "X" : "";
-	dev_info(&client->dev, "MIPICLK         : %10u K %s\n", clk, enable);
+	dev_dbg(&client->dev, "MIPICLK         : %10u K %s\n", clk, enable);
 
 	clk = vco / (p6+1);
 	enable = (96000 < clk) ? "X" : "";
-	dev_info(&client->dev, "MCU CLK         : %10u K %s\n", clk, enable);
+	dev_dbg(&client->dev, "MCU CLK         : %10u K %s\n", clk, enable);
 
 	clk = vco / (p5+1);
 	enable = (54000 < clk) ? "X" : "";
-	dev_info(&client->dev, "SOC CLK         : %10u K %s\n", clk, enable);
+	dev_dbg(&client->dev, "SOC CLK         : %10u K %s\n", clk, enable);
 
 	clk = vco / (p4+1);
 	enable = (70000 < clk) ? "X" : "";
-	dev_info(&client->dev, "Sensor CLK      : %10u K %s\n", clk, enable);
+	dev_dbg(&client->dev, "Sensor CLK      : %10u K %s\n", clk, enable);
 
 	clk = vco / (p7+1);
-	dev_info(&client->dev, "External sensor : %10u K\n", clk);
+	dev_dbg(&client->dev, "External sensor : %10u K\n", clk);
 
 	clk = ext / (n+1);
 	enable = ((2000 > clk) || (24000 < clk)) ? "X" : "";
-	dev_info(&client->dev, "PFD             : %10u K %s\n", clk, enable);
+	dev_dbg(&client->dev, "PFD             : %10u K %s\n", clk, enable);
 
 	return 0;
 }
@@ -982,8 +981,7 @@ static int mt9t112_g_mbus_config(struct v4l2_subdev *sd,
 				 struct v4l2_mbus_config *cfg)
 {
 	struct i2c_client *client = v4l2_get_subdevdata(sd);
-	struct soc_camera_device *icd = client->dev.platform_data;
-	struct soc_camera_link *icl = to_soc_camera_link(icd);
+	struct soc_camera_link *icl = soc_camera_i2c_to_link(client);
 
 	cfg->flags = V4L2_MBUS_MASTER | V4L2_MBUS_VSYNC_ACTIVE_HIGH |
 		V4L2_MBUS_HSYNC_ACTIVE_HIGH | V4L2_MBUS_DATA_ACTIVE_HIGH |
@@ -998,8 +996,7 @@ static int mt9t112_s_mbus_config(struct v4l2_subdev *sd,
 				 const struct v4l2_mbus_config *cfg)
 {
 	struct i2c_client *client = v4l2_get_subdevdata(sd);
-	struct soc_camera_device *icd = client->dev.platform_data;
-	struct soc_camera_link *icl = to_soc_camera_link(icd);
+	struct soc_camera_link *icl = soc_camera_i2c_to_link(client);
 	struct mt9t112_priv *priv = to_mt9t112(client);
 
 	if (soc_camera_apply_board_flags(icl, cfg) & V4L2_MBUS_PCLK_SAMPLE_RISING)
@@ -1029,17 +1026,12 @@ static struct v4l2_subdev_ops mt9t112_subdev_ops = {
 	.video	= &mt9t112_subdev_video_ops,
 };
 
-static int mt9t112_camera_probe(struct soc_camera_device *icd,
-				struct i2c_client *client)
+static int mt9t112_camera_probe(struct i2c_client *client)
 {
 	struct mt9t112_priv *priv = to_mt9t112(client);
 	const char          *devname;
 	int                  chipid;
 
-	/* We must have a parent by now. And it cannot be a wrong one. */
-	BUG_ON(!icd->parent ||
-	       to_soc_camera_host(icd->parent)->nr != icd->iface);
-
 	/*
 	 * check and show chip ID
 	 */
@@ -1068,8 +1060,7 @@ static int mt9t112_probe(struct i2c_client *client,
 			 const struct i2c_device_id *did)
 {
 	struct mt9t112_priv *priv;
-	struct soc_camera_device *icd = client->dev.platform_data;
-	struct soc_camera_link *icl;
+	struct soc_camera_link *icl = soc_camera_i2c_to_link(client);
 	struct v4l2_rect rect = {
 		.width = VGA_WIDTH,
 		.height = VGA_HEIGHT,
@@ -1078,15 +1069,11 @@ static int mt9t112_probe(struct i2c_client *client,
 	};
 	int ret;
 
-	if (!icd) {
-		dev_err(&client->dev, "mt9t112: missing soc-camera data!\n");
+	if (!icl || !icl->priv) {
+		dev_err(&client->dev, "mt9t112: missing platform data!\n");
 		return -EINVAL;
 	}
 
-	icl = to_soc_camera_link(icd);
-	if (!icl || !icl->priv)
-		return -EINVAL;
-
 	priv = kzalloc(sizeof(*priv), GFP_KERNEL);
 	if (!priv)
 		return -ENOMEM;
@@ -1095,7 +1082,7 @@ static int mt9t112_probe(struct i2c_client *client,
 
 	v4l2_i2c_subdev_init(&priv->subdev, client, &mt9t112_subdev_ops);
 
-	ret = mt9t112_camera_probe(icd, client);
+	ret = mt9t112_camera_probe(client);
 	if (ret)
 		kfree(priv);
 
diff --git a/drivers/media/video/mt9v022.c b/drivers/media/video/mt9v022.c
index 7e2aeda..72b179b 100644
--- a/drivers/media/video/mt9v022.c
+++ b/drivers/media/video/mt9v022.c
@@ -332,7 +332,7 @@ static int mt9v022_s_fmt(struct v4l2_subdev *sd,
 
 	/*
 	 * The caller provides a supported format, as verified per call to
-	 * icd->try_fmt(), datawidth is from our supported format list
+	 * .try_mbus_fmt(), datawidth is from our supported format list
 	 */
 	switch (mf->code) {
 	case V4L2_MBUS_FMT_Y8_1X8:
@@ -562,19 +562,14 @@ static int mt9v022_s_ctrl(struct v4l2_ctrl *ctrl)
  * Interface active, can use i2c. If it fails, it can indeed mean, that
  * this wasn't our capture interface, so, we wait for the right one
  */
-static int mt9v022_video_probe(struct soc_camera_device *icd,
-			       struct i2c_client *client)
+static int mt9v022_video_probe(struct i2c_client *client)
 {
 	struct mt9v022 *mt9v022 = to_mt9v022(client);
-	struct soc_camera_link *icl = to_soc_camera_link(icd);
+	struct soc_camera_link *icl = soc_camera_i2c_to_link(client);
 	s32 data;
 	int ret;
 	unsigned long flags;
 
-	/* We must have a parent by now. And it cannot be a wrong one. */
-	BUG_ON(!icd->parent ||
-	       to_soc_camera_host(icd->parent)->nr != icd->iface);
-
 	/* Read out the chip version register */
 	data = reg_read(client, MT9V022_CHIP_VERSION);
 
@@ -648,16 +643,6 @@ ei2c:
 	return ret;
 }
 
-static void mt9v022_video_remove(struct soc_camera_device *icd)
-{
-	struct soc_camera_link *icl = to_soc_camera_link(icd);
-
-	dev_dbg(icd->pdev, "Video removed: %p, %p\n",
-		icd->parent, icd->vdev);
-	if (icl->free_bus)
-		icl->free_bus(icl);
-}
-
 static int mt9v022_g_skip_top_lines(struct v4l2_subdev *sd, u32 *lines)
 {
 	struct i2c_client *client = v4l2_get_subdevdata(sd);
@@ -698,8 +683,7 @@ static int mt9v022_g_mbus_config(struct v4l2_subdev *sd,
 				struct v4l2_mbus_config *cfg)
 {
 	struct i2c_client *client = v4l2_get_subdevdata(sd);
-	struct soc_camera_device *icd = client->dev.platform_data;
-	struct soc_camera_link *icl = to_soc_camera_link(icd);
+	struct soc_camera_link *icl = soc_camera_i2c_to_link(client);
 
 	cfg->flags = V4L2_MBUS_MASTER | V4L2_MBUS_SLAVE |
 		V4L2_MBUS_PCLK_SAMPLE_RISING | V4L2_MBUS_PCLK_SAMPLE_FALLING |
@@ -730,8 +714,8 @@ static int mt9v022_s_mbus_config(struct v4l2_subdev *sd,
 	int ret;
 	u16 pixclk = 0;
 
-	dev_info(icd->pdev, "set %d: %s, %dbps\n", icd->current_fmt->code,
-		 icd->current_fmt->host_fmt->name, bps);
+	dev_dbg(icd->pdev, "set %d: %s, %dbps\n", icd->current_fmt->code,
+		icd->current_fmt->host_fmt->name, bps);
 
 	if (icl->set_bus_param) {
 		ret = icl->set_bus_param(icl, 1 << (bps - 1));
@@ -798,17 +782,10 @@ static int mt9v022_probe(struct i2c_client *client,
 			 const struct i2c_device_id *did)
 {
 	struct mt9v022 *mt9v022;
-	struct soc_camera_device *icd = client->dev.platform_data;
+	struct soc_camera_link *icl = soc_camera_i2c_to_link(client);
 	struct i2c_adapter *adapter = to_i2c_adapter(client->dev.parent);
-	struct soc_camera_link *icl;
 	int ret;
 
-	if (!icd) {
-		dev_err(&client->dev, "MT9V022: missing soc-camera data!\n");
-		return -EINVAL;
-	}
-
-	icl = to_soc_camera_link(icd);
 	if (!icl) {
 		dev_err(&client->dev, "MT9V022 driver needs platform data\n");
 		return -EINVAL;
@@ -868,7 +845,7 @@ static int mt9v022_probe(struct i2c_client *client,
 	mt9v022->rect.width	= MT9V022_MAX_WIDTH;
 	mt9v022->rect.height	= MT9V022_MAX_HEIGHT;
 
-	ret = mt9v022_video_probe(icd, client);
+	ret = mt9v022_video_probe(client);
 	if (ret) {
 		v4l2_ctrl_handler_free(&mt9v022->hdl);
 		kfree(mt9v022);
@@ -880,10 +857,11 @@ static int mt9v022_probe(struct i2c_client *client,
 static int mt9v022_remove(struct i2c_client *client)
 {
 	struct mt9v022 *mt9v022 = to_mt9v022(client);
-	struct soc_camera_device *icd = client->dev.platform_data;
+	struct soc_camera_link *icl = soc_camera_i2c_to_link(client);
 
 	v4l2_device_unregister_subdev(&mt9v022->subdev);
-	mt9v022_video_remove(icd);
+	if (icl->free_bus)
+		icl->free_bus(icl);
 	v4l2_ctrl_handler_free(&mt9v022->hdl);
 	kfree(mt9v022);
 
diff --git a/drivers/media/video/ov2640.c b/drivers/media/video/ov2640.c
index 981767f..d37a5cc 100644
--- a/drivers/media/video/ov2640.c
+++ b/drivers/media/video/ov2640.c
@@ -942,18 +942,13 @@ static int ov2640_cropcap(struct v4l2_subdev *sd, struct v4l2_cropcap *a)
 	return 0;
 }
 
-static int ov2640_video_probe(struct soc_camera_device *icd,
-			      struct i2c_client *client)
+static int ov2640_video_probe(struct i2c_client *client)
 {
 	struct ov2640_priv *priv = to_ov2640(client);
 	u8 pid, ver, midh, midl;
 	const char *devname;
 	int ret;
 
-	/* We must have a parent by now. And it cannot be a wrong one. */
-	BUG_ON(!icd->parent ||
-	       to_soc_camera_host(icd->parent)->nr != icd->iface);
-
 	/*
 	 * check and show product ID and manufacturer ID
 	 */
@@ -1001,8 +996,7 @@ static int ov2640_g_mbus_config(struct v4l2_subdev *sd,
 				struct v4l2_mbus_config *cfg)
 {
 	struct i2c_client *client = v4l2_get_subdevdata(sd);
-	struct soc_camera_device *icd = client->dev.platform_data;
-	struct soc_camera_link *icl = to_soc_camera_link(icd);
+	struct soc_camera_link *icl = soc_camera_i2c_to_link(client);
 
 	cfg->flags = V4L2_MBUS_PCLK_SAMPLE_RISING | V4L2_MBUS_MASTER |
 		V4L2_MBUS_VSYNC_ACTIVE_HIGH | V4L2_MBUS_HSYNC_ACTIVE_HIGH |
@@ -1035,18 +1029,11 @@ static struct v4l2_subdev_ops ov2640_subdev_ops = {
 static int ov2640_probe(struct i2c_client *client,
 			const struct i2c_device_id *did)
 {
-	struct ov2640_priv        *priv;
-	struct soc_camera_device  *icd = client->dev.platform_data;
-	struct i2c_adapter        *adapter = to_i2c_adapter(client->dev.parent);
-	struct soc_camera_link    *icl;
-	int                        ret;
-
-	if (!icd) {
-		dev_err(&adapter->dev, "OV2640: missing soc-camera data!\n");
-		return -EINVAL;
-	}
+	struct ov2640_priv	*priv;
+	struct soc_camera_link	*icl = soc_camera_i2c_to_link(client);
+	struct i2c_adapter	*adapter = to_i2c_adapter(client->dev.parent);
+	int			ret;
 
-	icl = to_soc_camera_link(icd);
 	if (!icl) {
 		dev_err(&adapter->dev,
 			"OV2640: Missing platform_data for driver\n");
@@ -1080,7 +1067,7 @@ static int ov2640_probe(struct i2c_client *client,
 		return err;
 	}
 
-	ret = ov2640_video_probe(icd, client);
+	ret = ov2640_video_probe(client);
 	if (ret) {
 		v4l2_ctrl_handler_free(&priv->hdl);
 		kfree(priv);
diff --git a/drivers/media/video/ov5642.c b/drivers/media/video/ov5642.c
index 163a6f7..2a26602 100644
--- a/drivers/media/video/ov5642.c
+++ b/drivers/media/video/ov5642.c
@@ -889,8 +889,7 @@ static struct v4l2_subdev_ops ov5642_subdev_ops = {
 	.video	= &ov5642_subdev_video_ops,
 };
 
-static int ov5642_video_probe(struct soc_camera_device *icd,
-			      struct i2c_client *client)
+static int ov5642_video_probe(struct i2c_client *client)
 {
 	int ret;
 	u8 id_high, id_low;
@@ -921,16 +920,9 @@ static int ov5642_probe(struct i2c_client *client,
 			const struct i2c_device_id *did)
 {
 	struct ov5642 *priv;
-	struct soc_camera_device *icd = client->dev.platform_data;
-	struct soc_camera_link *icl;
+	struct soc_camera_link *icl = soc_camera_i2c_to_link(client);
 	int ret;
 
-	if (!icd) {
-		dev_err(&client->dev, "OV5642: missing soc-camera data!\n");
-		return -EINVAL;
-	}
-
-	icl = to_soc_camera_link(icd);
 	if (!icl) {
 		dev_err(&client->dev, "OV5642: missing platform data!\n");
 		return -EINVAL;
@@ -944,7 +936,7 @@ static int ov5642_probe(struct i2c_client *client,
 
 	priv->fmt	= &ov5642_colour_fmts[0];
 
-	ret = ov5642_video_probe(icd, client);
+	ret = ov5642_video_probe(client);
 	if (ret < 0)
 		goto error;
 
@@ -958,8 +950,7 @@ error:
 static int ov5642_remove(struct i2c_client *client)
 {
 	struct ov5642 *priv = to_ov5642(client);
-	struct soc_camera_device *icd = client->dev.platform_data;
-	struct soc_camera_link *icl = to_soc_camera_link(icd);
+	struct soc_camera_link *icl = soc_camera_i2c_to_link(client);
 
 	if (icl->free_bus)
 		icl->free_bus(icl);
diff --git a/drivers/media/video/ov6650.c b/drivers/media/video/ov6650.c
index 089a4aa..8323536 100644
--- a/drivers/media/video/ov6650.c
+++ b/drivers/media/video/ov6650.c
@@ -820,8 +820,7 @@ static int ov6650_prog_dflt(struct i2c_client *client)
 	return ret;
 }
 
-static int ov6650_video_probe(struct soc_camera_device *icd,
-				struct i2c_client *client)
+static int ov6650_video_probe(struct i2c_client *client)
 {
 	u8		pidh, pidl, midh, midl;
 	int		ret = 0;
@@ -875,8 +874,7 @@ static int ov6650_g_mbus_config(struct v4l2_subdev *sd,
 				struct v4l2_mbus_config *cfg)
 {
 	struct i2c_client *client = v4l2_get_subdevdata(sd);
-	struct soc_camera_device *icd = client->dev.platform_data;
-	struct soc_camera_link *icl = to_soc_camera_link(icd);
+	struct soc_camera_link *icl = soc_camera_i2c_to_link(client);
 
 	cfg->flags = V4L2_MBUS_MASTER |
 		V4L2_MBUS_PCLK_SAMPLE_RISING | V4L2_MBUS_PCLK_SAMPLE_FALLING |
@@ -894,8 +892,7 @@ static int ov6650_s_mbus_config(struct v4l2_subdev *sd,
 				const struct v4l2_mbus_config *cfg)
 {
 	struct i2c_client *client = v4l2_get_subdevdata(sd);
-	struct soc_camera_device *icd = client->dev.platform_data;
-	struct soc_camera_link *icl = to_soc_camera_link(icd);
+	struct soc_camera_link *icl = soc_camera_i2c_to_link(client);
 	unsigned long flags = soc_camera_apply_board_flags(icl, cfg);
 	int ret;
 
@@ -948,16 +945,9 @@ static int ov6650_probe(struct i2c_client *client,
 			const struct i2c_device_id *did)
 {
 	struct ov6650 *priv;
-	struct soc_camera_device *icd = client->dev.platform_data;
-	struct soc_camera_link *icl;
+	struct soc_camera_link *icl = soc_camera_i2c_to_link(client);
 	int ret;
 
-	if (!icd) {
-		dev_err(&client->dev, "Missing soc-camera data!\n");
-		return -EINVAL;
-	}
-
-	icl = to_soc_camera_link(icd);
 	if (!icl) {
 		dev_err(&client->dev, "Missing platform_data for driver\n");
 		return -EINVAL;
@@ -1020,7 +1010,7 @@ static int ov6650_probe(struct i2c_client *client,
 	priv->code	  = V4L2_MBUS_FMT_YUYV8_2X8;
 	priv->colorspace  = V4L2_COLORSPACE_JPEG;
 
-	ret = ov6650_video_probe(icd, client);
+	ret = ov6650_video_probe(client);
 	if (!ret)
 		ret = v4l2_ctrl_handler_setup(&priv->hdl);
 
diff --git a/drivers/media/video/ov772x.c b/drivers/media/video/ov772x.c
index 9b54042..a2146c3 100644
--- a/drivers/media/video/ov772x.c
+++ b/drivers/media/video/ov772x.c
@@ -953,17 +953,12 @@ static int ov772x_try_fmt(struct v4l2_subdev *sd,
 	return 0;
 }
 
-static int ov772x_video_probe(struct soc_camera_device *icd,
-			      struct i2c_client *client)
+static int ov772x_video_probe(struct i2c_client *client)
 {
 	struct ov772x_priv *priv = to_ov772x(client);
 	u8                  pid, ver;
 	const char         *devname;
 
-	/* We must have a parent by now. And it cannot be a wrong one. */
-	BUG_ON(!icd->parent ||
-	       to_soc_camera_host(icd->parent)->nr != icd->iface);
-
 	/*
 	 * check and show product ID and manufacturer ID
 	 */
@@ -1021,8 +1016,7 @@ static int ov772x_g_mbus_config(struct v4l2_subdev *sd,
 				struct v4l2_mbus_config *cfg)
 {
 	struct i2c_client *client = v4l2_get_subdevdata(sd);
-	struct soc_camera_device *icd = client->dev.platform_data;
-	struct soc_camera_link *icl = to_soc_camera_link(icd);
+	struct soc_camera_link *icl = soc_camera_i2c_to_link(client);
 
 	cfg->flags = V4L2_MBUS_PCLK_SAMPLE_RISING | V4L2_MBUS_MASTER |
 		V4L2_MBUS_VSYNC_ACTIVE_HIGH | V4L2_MBUS_HSYNC_ACTIVE_HIGH |
@@ -1056,20 +1050,15 @@ static struct v4l2_subdev_ops ov772x_subdev_ops = {
 static int ov772x_probe(struct i2c_client *client,
 			const struct i2c_device_id *did)
 {
-	struct ov772x_priv        *priv;
-	struct soc_camera_device  *icd = client->dev.platform_data;
-	struct i2c_adapter        *adapter = to_i2c_adapter(client->dev.parent);
-	struct soc_camera_link    *icl;
-	int                        ret;
-
-	if (!icd) {
-		dev_err(&client->dev, "OV772X: missing soc-camera data!\n");
-		return -EINVAL;
-	}
+	struct ov772x_priv	*priv;
+	struct soc_camera_link	*icl = soc_camera_i2c_to_link(client);
+	struct i2c_adapter	*adapter = to_i2c_adapter(client->dev.parent);
+	int			ret;
 
-	icl = to_soc_camera_link(icd);
-	if (!icl || !icl->priv)
+	if (!icl || !icl->priv) {
+		dev_err(&client->dev, "OV772X: missing platform data!\n");
 		return -EINVAL;
+	}
 
 	if (!i2c_check_functionality(adapter, I2C_FUNC_SMBUS_BYTE_DATA)) {
 		dev_err(&adapter->dev,
@@ -1100,7 +1089,7 @@ static int ov772x_probe(struct i2c_client *client,
 		return err;
 	}
 
-	ret = ov772x_video_probe(icd, client);
+	ret = ov772x_video_probe(client);
 	if (ret) {
 		v4l2_ctrl_handler_free(&priv->hdl);
 		kfree(priv);
diff --git a/drivers/media/video/ov9640.c b/drivers/media/video/ov9640.c
index 12d33a9..f9babf3 100644
--- a/drivers/media/video/ov9640.c
+++ b/drivers/media/video/ov9640.c
@@ -578,8 +578,7 @@ static int ov9640_cropcap(struct v4l2_subdev *sd, struct v4l2_cropcap *a)
 	return 0;
 }
 
-static int ov9640_video_probe(struct soc_camera_device *icd,
-				struct i2c_client *client)
+static int ov9640_video_probe(struct i2c_client *client)
 {
 	struct v4l2_subdev *sd = i2c_get_clientdata(client);
 	struct ov9640_priv *priv = to_ov9640_sensor(sd);
@@ -587,10 +586,6 @@ static int ov9640_video_probe(struct soc_camera_device *icd,
 	const char	*devname;
 	int		ret = 0;
 
-	/* We must have a parent by now. And it cannot be a wrong one. */
-	BUG_ON(!icd->parent ||
-	       to_soc_camera_host(icd->parent)->nr != icd->iface);
-
 	/*
 	 * check and show product ID and manufacturer ID
 	 */
@@ -644,8 +639,7 @@ static int ov9640_g_mbus_config(struct v4l2_subdev *sd,
 				struct v4l2_mbus_config *cfg)
 {
 	struct i2c_client *client = v4l2_get_subdevdata(sd);
-	struct soc_camera_device *icd = client->dev.platform_data;
-	struct soc_camera_link *icl = to_soc_camera_link(icd);
+	struct soc_camera_link *icl = soc_camera_i2c_to_link(client);
 
 	cfg->flags = V4L2_MBUS_PCLK_SAMPLE_RISING | V4L2_MBUS_MASTER |
 		V4L2_MBUS_VSYNC_ACTIVE_HIGH | V4L2_MBUS_HSYNC_ACTIVE_HIGH |
@@ -678,16 +672,9 @@ static int ov9640_probe(struct i2c_client *client,
 			const struct i2c_device_id *did)
 {
 	struct ov9640_priv *priv;
-	struct soc_camera_device *icd	= client->dev.platform_data;
-	struct soc_camera_link *icl;
+	struct soc_camera_link *icl = soc_camera_i2c_to_link(client);
 	int ret;
 
-	if (!icd) {
-		dev_err(&client->dev, "Missing soc-camera data!\n");
-		return -EINVAL;
-	}
-
-	icl = to_soc_camera_link(icd);
 	if (!icl) {
 		dev_err(&client->dev, "Missing platform_data for driver\n");
 		return -EINVAL;
@@ -715,7 +702,7 @@ static int ov9640_probe(struct i2c_client *client,
 		return err;
 	}
 
-	ret = ov9640_video_probe(icd, client);
+	ret = ov9640_video_probe(client);
 
 	if (ret) {
 		v4l2_ctrl_handler_free(&priv->hdl);
diff --git a/drivers/media/video/ov9740.c b/drivers/media/video/ov9740.c
index 3dd910d..9558aca 100644
--- a/drivers/media/video/ov9740.c
+++ b/drivers/media/video/ov9740.c
@@ -836,18 +836,13 @@ static int ov9740_set_register(struct v4l2_subdev *sd,
 }
 #endif
 
-static int ov9740_video_probe(struct soc_camera_device *icd,
-			      struct i2c_client *client)
+static int ov9740_video_probe(struct i2c_client *client)
 {
 	struct v4l2_subdev *sd = i2c_get_clientdata(client);
 	struct ov9740_priv *priv = to_ov9740(sd);
 	u8 modelhi, modello;
 	int ret;
 
-	/* We must have a parent by now. And it cannot be a wrong one. */
-	BUG_ON(!icd->parent ||
-	       to_soc_camera_host(icd->parent)->nr != icd->iface);
-
 	/*
 	 * check and show product ID and manufacturer ID
 	 */
@@ -893,8 +888,7 @@ static int ov9740_g_mbus_config(struct v4l2_subdev *sd,
 				struct v4l2_mbus_config *cfg)
 {
 	struct i2c_client *client = v4l2_get_subdevdata(sd);
-	struct soc_camera_device *icd = client->dev.platform_data;
-	struct soc_camera_link *icl = to_soc_camera_link(icd);
+	struct soc_camera_link *icl = soc_camera_i2c_to_link(client);
 
 	cfg->flags = V4L2_MBUS_PCLK_SAMPLE_RISING | V4L2_MBUS_MASTER |
 		V4L2_MBUS_VSYNC_ACTIVE_HIGH | V4L2_MBUS_HSYNC_ACTIVE_HIGH |
@@ -940,16 +934,9 @@ static int ov9740_probe(struct i2c_client *client,
 			const struct i2c_device_id *did)
 {
 	struct ov9740_priv *priv;
-	struct soc_camera_device *icd = client->dev.platform_data;
-	struct soc_camera_link *icl;
+	struct soc_camera_link *icl = soc_camera_i2c_to_link(client);
 	int ret;
 
-	if (!icd) {
-		dev_err(&client->dev, "Missing soc-camera data!\n");
-		return -EINVAL;
-	}
-
-	icl = to_soc_camera_link(icd);
 	if (!icl) {
 		dev_err(&client->dev, "Missing platform_data for driver\n");
 		return -EINVAL;
@@ -975,7 +962,7 @@ static int ov9740_probe(struct i2c_client *client,
 		return err;
 	}
 
-	ret = ov9740_video_probe(icd, client);
+	ret = ov9740_video_probe(client);
 	if (!ret)
 		ret = v4l2_ctrl_handler_setup(&priv->hdl);
 	if (ret < 0) {
diff --git a/drivers/media/video/rj54n1cb0c.c b/drivers/media/video/rj54n1cb0c.c
index 9a87153..fcb14d9 100644
--- a/drivers/media/video/rj54n1cb0c.c
+++ b/drivers/media/video/rj54n1cb0c.c
@@ -1235,8 +1235,7 @@ static int rj54n1_g_mbus_config(struct v4l2_subdev *sd,
 				struct v4l2_mbus_config *cfg)
 {
 	struct i2c_client *client = v4l2_get_subdevdata(sd);
-	struct soc_camera_device *icd = client->dev.platform_data;
-	struct soc_camera_link *icl = to_soc_camera_link(icd);
+	struct soc_camera_link *icl = soc_camera_i2c_to_link(client);
 
 	cfg->flags =
 		V4L2_MBUS_PCLK_SAMPLE_RISING | V4L2_MBUS_PCLK_SAMPLE_FALLING |
@@ -1252,8 +1251,7 @@ static int rj54n1_s_mbus_config(struct v4l2_subdev *sd,
 				const struct v4l2_mbus_config *cfg)
 {
 	struct i2c_client *client = v4l2_get_subdevdata(sd);
-	struct soc_camera_device *icd = client->dev.platform_data;
-	struct soc_camera_link *icl = to_soc_camera_link(icd);
+	struct soc_camera_link *icl = soc_camera_i2c_to_link(client);
 
 	/* Figures 2.5-1 to 2.5-3 - default falling pixclk edge */
 	if (soc_camera_apply_board_flags(icl, cfg) &
@@ -1285,17 +1283,12 @@ static struct v4l2_subdev_ops rj54n1_subdev_ops = {
  * Interface active, can use i2c. If it fails, it can indeed mean, that
  * this wasn't our capture interface, so, we wait for the right one
  */
-static int rj54n1_video_probe(struct soc_camera_device *icd,
-			      struct i2c_client *client,
+static int rj54n1_video_probe(struct i2c_client *client,
 			      struct rj54n1_pdata *priv)
 {
 	int data1, data2;
 	int ret;
 
-	/* We must have a parent by now. And it cannot be a wrong one. */
-	BUG_ON(!icd->parent ||
-	       to_soc_camera_host(icd->parent)->nr != icd->iface);
-
 	/* Read out the chip version register */
 	data1 = reg_read(client, RJ54N1_DEV_CODE);
 	data2 = reg_read(client, RJ54N1_DEV_CODE2);
@@ -1323,18 +1316,11 @@ static int rj54n1_probe(struct i2c_client *client,
 			const struct i2c_device_id *did)
 {
 	struct rj54n1 *rj54n1;
-	struct soc_camera_device *icd = client->dev.platform_data;
+	struct soc_camera_link *icl = soc_camera_i2c_to_link(client);
 	struct i2c_adapter *adapter = to_i2c_adapter(client->dev.parent);
-	struct soc_camera_link *icl;
 	struct rj54n1_pdata *rj54n1_priv;
 	int ret;
 
-	if (!icd) {
-		dev_err(&client->dev, "RJ54N1CB0C: missing soc-camera data!\n");
-		return -EINVAL;
-	}
-
-	icl = to_soc_camera_link(icd);
 	if (!icl || !icl->priv) {
 		dev_err(&client->dev, "RJ54N1CB0C: missing platform data!\n");
 		return -EINVAL;
@@ -1382,7 +1368,7 @@ static int rj54n1_probe(struct i2c_client *client,
 	rj54n1->tgclk_mhz	= (rj54n1_priv->mclk_freq / PLL_L * PLL_N) /
 		(clk_div.ratio_tg + 1) / (clk_div.ratio_t + 1);
 
-	ret = rj54n1_video_probe(icd, client, rj54n1_priv);
+	ret = rj54n1_video_probe(client, rj54n1_priv);
 	if (ret < 0) {
 		v4l2_ctrl_handler_free(&rj54n1->hdl);
 		kfree(rj54n1);
@@ -1394,8 +1380,7 @@ static int rj54n1_probe(struct i2c_client *client,
 static int rj54n1_remove(struct i2c_client *client)
 {
 	struct rj54n1 *rj54n1 = to_rj54n1(client);
-	struct soc_camera_device *icd = client->dev.platform_data;
-	struct soc_camera_link *icl = to_soc_camera_link(icd);
+	struct soc_camera_link *icl = soc_camera_i2c_to_link(client);
 
 	v4l2_device_unregister_subdev(&rj54n1->subdev);
 	if (icl->free_bus)
diff --git a/drivers/media/video/tw9910.c b/drivers/media/video/tw9910.c
index 2fddd1f..5a3722b 100644
--- a/drivers/media/video/tw9910.c
+++ b/drivers/media/video/tw9910.c
@@ -764,10 +764,6 @@ static int tw9910_video_probe(struct soc_camera_device *icd,
 	struct tw9910_priv *priv = to_tw9910(client);
 	s32 id;
 
-	/* We must have a parent by now. And it cannot be a wrong one. */
-	BUG_ON(!icd->parent ||
-	       to_soc_camera_host(icd->parent)->nr != icd->iface);
-
 	/*
 	 * tw9910 only use 8 or 16 bit bus width
 	 */
@@ -825,8 +821,7 @@ static int tw9910_g_mbus_config(struct v4l2_subdev *sd,
 				struct v4l2_mbus_config *cfg)
 {
 	struct i2c_client *client = v4l2_get_subdevdata(sd);
-	struct soc_camera_device *icd = client->dev.platform_data;
-	struct soc_camera_link *icl = to_soc_camera_link(icd);
+	struct soc_camera_link *icl = soc_camera_i2c_to_link(client);
 
 	cfg->flags = V4L2_MBUS_PCLK_SAMPLE_RISING | V4L2_MBUS_MASTER |
 		V4L2_MBUS_VSYNC_ACTIVE_HIGH | V4L2_MBUS_VSYNC_ACTIVE_LOW |
@@ -842,8 +837,7 @@ static int tw9910_s_mbus_config(struct v4l2_subdev *sd,
 				const struct v4l2_mbus_config *cfg)
 {
 	struct i2c_client *client = v4l2_get_subdevdata(sd);
-	struct soc_camera_device *icd = client->dev.platform_data;
-	struct soc_camera_link *icl = to_soc_camera_link(icd);
+	struct soc_camera_link *icl = soc_camera_i2c_to_link(client);
 	u8 val = VSSL_VVALID | HSSL_DVALID;
 	unsigned long flags = soc_camera_apply_board_flags(icl, cfg);
 
@@ -887,23 +881,19 @@ static int tw9910_probe(struct i2c_client *client,
 			const struct i2c_device_id *did)
 
 {
-	struct tw9910_priv             *priv;
-	struct tw9910_video_info       *info;
-	struct soc_camera_device       *icd = client->dev.platform_data;
-	struct i2c_adapter             *adapter =
+	struct tw9910_priv		*priv;
+	struct tw9910_video_info	*info;
+	struct soc_camera_device	*icd = client->dev.platform_data;
+	struct i2c_adapter		*adapter =
 		to_i2c_adapter(client->dev.parent);
-	struct soc_camera_link         *icl;
-	int                             ret;
+	struct soc_camera_link		*icl = soc_camera_i2c_to_link(client);
+	int				ret;
 
-	if (!icd) {
-		dev_err(&client->dev, "TW9910: missing soc-camera data!\n");
+	if (!icl || !icl->priv) {
+		dev_err(&client->dev, "TW9910: missing platform data!\n");
 		return -EINVAL;
 	}
 
-	icl = to_soc_camera_link(icd);
-	if (!icl || !icl->priv)
-		return -EINVAL;
-
 	info = icl->priv;
 
 	if (!i2c_check_functionality(adapter, I2C_FUNC_SMBUS_BYTE_DATA)) {
@@ -921,8 +911,6 @@ static int tw9910_probe(struct i2c_client *client,
 
 	v4l2_i2c_subdev_init(&priv->subdev, client, &tw9910_subdev_ops);
 
-	icd->iface   = icl->bus_id;
-
 	ret = tw9910_video_probe(icd, client);
 	if (ret)
 		kfree(priv);
diff --git a/include/media/soc_camera.h b/include/media/soc_camera.h
index 6398ff0..67a52c7 100644
--- a/include/media/soc_camera.h
+++ b/include/media/soc_camera.h
@@ -251,18 +251,35 @@ unsigned long soc_camera_apply_board_flags(struct soc_camera_link *icl,
 
 /* This is only temporary here - until v4l2-subdev begins to link to video_device */
 #include <linux/i2c.h>
-static inline struct video_device *soc_camera_i2c_to_vdev(struct i2c_client *client)
+static inline struct video_device *soc_camera_i2c_to_vdev(const struct i2c_client *client)
 {
 	struct soc_camera_device *icd = client->dev.platform_data;
-	return icd->vdev;
+	return icd ? icd->vdev : NULL;
 }
 
-static inline struct soc_camera_device *soc_camera_from_vb2q(struct vb2_queue *vq)
+static inline struct soc_camera_link *soc_camera_i2c_to_link(const struct i2c_client *client)
+{
+	struct soc_camera_device *icd = client->dev.platform_data;
+	return icd ? to_soc_camera_link(icd) : NULL;
+}
+
+static inline struct v4l2_subdev *soc_camera_vdev_to_subdev(const struct video_device *vdev)
+{
+	struct soc_camera_device *icd = dev_get_drvdata(vdev->parent);
+	return soc_camera_to_subdev(icd);
+}
+
+static inline struct soc_camera_device *soc_camera_from_i2c(const struct i2c_client *client)
+{
+	return client->dev.platform_data;
+}
+
+static inline struct soc_camera_device *soc_camera_from_vb2q(const struct vb2_queue *vq)
 {
 	return container_of(vq, struct soc_camera_device, vb2_vidq);
 }
 
-static inline struct soc_camera_device *soc_camera_from_vbq(struct videobuf_queue *vq)
+static inline struct soc_camera_device *soc_camera_from_vbq(const struct videobuf_queue *vq)
 {
 	return container_of(vq, struct soc_camera_device, vb_vidq);
 }
-- 
1.7.2.5

