Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pa0-f50.google.com ([209.85.220.50]:55559 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753018AbbBBIGr (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 2 Feb 2015 03:06:47 -0500
Received: by mail-pa0-f50.google.com with SMTP id rd3so79283877pab.9
        for <linux-media@vger.kernel.org>; Mon, 02 Feb 2015 00:06:46 -0800 (PST)
From: Kassey Li <kassey1216@gmail.com>
To: g.liakhovetski@gmx.de
Cc: linux-media@vger.kernel.org, kasseyl@nvidia.com
Subject: [PATCH V2] [media] V4L: soc-camera: add SPI device support
Date: Mon,  2 Feb 2015 16:06:57 +0800
Message-Id: <1422864417-7296-1-git-send-email-kassey1216@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Kassey Li <kasseyl@nvidia.com>

This adds support for spi interface sub device for
soc_camera.

Signed-off-by: Kassey Li <kasseyl@nvidia.com>
---
 drivers/media/platform/soc_camera/soc_camera.c |   94 ++++++++++++++++++++++++
 include/media/soc_camera.h                     |    4 +
 2 files changed, 98 insertions(+)

diff --git a/drivers/media/platform/soc_camera/soc_camera.c b/drivers/media/platform/soc_camera/soc_camera.c
index b3db51c..b01c075 100644
--- a/drivers/media/platform/soc_camera/soc_camera.c
+++ b/drivers/media/platform/soc_camera/soc_camera.c
@@ -27,6 +27,7 @@
 #include <linux/pm_runtime.h>
 #include <linux/regulator/consumer.h>
 #include <linux/slab.h>
+#include <linux/spi/spi.h>
 #include <linux/vmalloc.h>
 
 #include <media/soc_camera.h>
@@ -1430,6 +1431,91 @@ static void soc_camera_i2c_free(struct soc_camera_device *icd)
 	icd->clk = NULL;
 }
 
+static int soc_camera_spi_init(struct soc_camera_device *icd,
+			       struct soc_camera_desc *sdesc)
+{
+	struct soc_camera_subdev_desc *ssdd;
+	struct spi_device *spi;
+	struct soc_camera_host *ici;
+	struct soc_camera_host_desc *shd = &sdesc->host_desc;
+	struct spi_master *spi_master;
+	struct v4l2_subdev *subdev;
+	char clk_name[V4L2_SUBDEV_NAME_SIZE];
+	int ret;
+
+	/* First find out how we link the main client */
+	if (icd->sasc) {
+		/* Async non-OF probing handled by the subdevice list */
+		return -EPROBE_DEFER;
+	}
+
+	ici = to_soc_camera_host(icd->parent);
+	spi_master = spi_busnum_to_master(shd->spi_bus_id);
+	if (!spi_master) {
+		dev_err(icd->pdev, "Cannot get SPI master #%d. No driver?\n",
+			shd->spi_bus_id);
+		return -ENODEV;
+	}
+
+	ssdd = kmemdup(&sdesc->subdev_desc, sizeof(*ssdd), GFP_KERNEL);
+	if (!ssdd)
+		return -ENOMEM;
+	/*
+	 * In synchronous case we request regulators ourselves in
+	 * soc_camera_pdrv_probe(), make sure the subdevice driver doesn't try
+	 * to allocate them again.
+	 */
+	ssdd->sd_pdata.num_regulators = 0;
+	ssdd->sd_pdata.regulators = NULL;
+	shd->board_info_spi->platform_data = ssdd;
+
+	snprintf(clk_name, sizeof(clk_name), "%d",
+		 shd->spi_bus_id);
+
+	icd->clk = v4l2_clk_register(&soc_camera_clk_ops, clk_name, "mclk", icd);
+	if (IS_ERR(icd->clk)) {
+		ret = PTR_ERR(icd->clk);
+		goto eclkreg;
+	}
+
+	subdev = v4l2_spi_new_subdev(&ici->v4l2_dev, spi_master,
+				shd->board_info_spi);
+	if (!subdev) {
+		ret = -ENODEV;
+		goto espind;
+	}
+
+	spi = v4l2_get_subdevdata(subdev);
+
+	icd->control = &spi->dev;
+
+	return 0;
+espind:
+	v4l2_clk_unregister(icd->clk);
+	icd->clk = NULL;
+eclkreg:
+	kfree(ssdd);
+	return ret;
+}
+
+static void soc_camera_spi_free(struct soc_camera_device *icd)
+{
+	struct spi_device *spi =
+		to_spi_device(to_soc_camera_control(icd));
+	struct soc_camera_subdev_desc *ssdd;
+	struct v4l2_subdev *sd = soc_camera_to_subdev(icd);
+
+	icd->control = NULL;
+	if (icd->sasc)
+		return;
+	ssdd = spi->dev.platform_data;
+	v4l2_device_unregister_subdev(sd);
+	spi_unregister_device(spi);
+	kfree(ssdd);
+	v4l2_clk_unregister(icd->clk);
+	icd->clk = NULL;
+}
+
 /*
  * V4L2 asynchronous notifier callbacks. They are all called under a v4l2-async
  * internal global mutex, therefore cannot race against other asynchronous
@@ -1762,6 +1848,10 @@ static int soc_camera_probe(struct soc_camera_host *ici,
 		ret = soc_camera_i2c_init(icd, sdesc);
 		if (ret < 0 && ret != -EPROBE_DEFER)
 			goto eadd;
+	} else if (shd->board_info_spi) {
+		ret = soc_camera_spi_init(icd, sdesc);
+		if (ret < 0)
+			goto eadd;
 	} else if (!shd->add_device || !shd->del_device) {
 		ret = -EINVAL;
 		goto eadd;
@@ -1803,6 +1893,8 @@ static int soc_camera_probe(struct soc_camera_host *ici,
 efinish:
 	if (shd->board_info) {
 		soc_camera_i2c_free(icd);
+	} else if (shd->board_info_spi) {
+		soc_camera_spi_free(icd);
 	} else {
 		shd->del_device(icd);
 		module_put(control->driver->owner);
@@ -1843,6 +1935,8 @@ static int soc_camera_remove(struct soc_camera_device *icd)
 
 	if (sdesc->host_desc.board_info) {
 		soc_camera_i2c_free(icd);
+	} else if (sdesc->host_desc.board_info_spi) {
+		soc_camera_spi_free(icd);
 	} else {
 		struct device *dev = to_soc_camera_control(icd);
 		struct device_driver *drv = dev ? dev->driver : NULL;
diff --git a/include/media/soc_camera.h b/include/media/soc_camera.h
index 2f6261f..a948ff6 100644
--- a/include/media/soc_camera.h
+++ b/include/media/soc_camera.h
@@ -178,6 +178,8 @@ struct soc_camera_host_desc {
 	int i2c_adapter_id;
 	struct i2c_board_info *board_info;
 	const char *module_name;
+	struct spi_board_info *board_info_spi;
+	int spi_bus_id;
 
 	/*
 	 * For non-I2C devices platform has to provide methods to add a device
@@ -243,6 +245,8 @@ struct soc_camera_link {
 	int i2c_adapter_id;
 	struct i2c_board_info *board_info;
 	const char *module_name;
+	struct spi_board_info *board_info_spi;
+	int spi_bus_id;
 
 	/*
 	 * For non-I2C devices platform has to provide methods to add a device
-- 
1.7.9.5

