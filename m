Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.w1.samsung.com ([210.118.77.14]:39587 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759241Ab2CTKjM (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 20 Mar 2012 06:39:12 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN
Received: from euspt2 ([210.118.77.14]) by mailout4.w1.samsung.com
 (Sun Java(tm) System Messaging Server 6.3-8.04 (built Jul 29 2009; 32bit))
 with ESMTP id <0M1600FCHIXBPL70@mailout4.w1.samsung.com> for
 linux-media@vger.kernel.org; Tue, 20 Mar 2012 10:39:11 +0000 (GMT)
Received: from linux.samsung.com ([106.116.38.10])
 by spt2.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0M1600964IX770@spt2.w1.samsung.com> for
 linux-media@vger.kernel.org; Tue, 20 Mar 2012 10:39:07 +0000 (GMT)
Date: Tue, 20 Mar 2012 11:39:05 +0100
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [PATCH 6/6] s5p-fimc: Handle sub-device interdependencies using
 deferred probing
In-reply-to: <1332239945-32711-1-git-send-email-s.nawrocki@samsung.com>
To: linux-media@vger.kernel.org
Cc: m.szyprowski@samsung.com, riverful.kim@samsung.com,
	sw0312.kim@samsung.com, s.nawrocki@samsung.com,
	Kyungmin Park <kyungmin.park@samsung.com>
Message-id: <1332239945-32711-7-git-send-email-s.nawrocki@samsung.com>
References: <1332239945-32711-1-git-send-email-s.nawrocki@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

In this driver there are several entities associated with separate
platform or I2C client devices, which may get probed in random order.

When the platform device bound to the media device driver is probed
all other entity drivers need to be already in place and initialized.
If any of them is not, fail the media device probe and return an error
indicating we need to be retried once any new driver gets registered.
The media device driver probe will not succeed until there are all
needed sub-drivers available, as specified in the platform data.

While at it, make sure the s5p-csis module (MIPI-CSI receiver driver)
does not get unloaded when in use, by guarding its usage with
try_module_get/module_put.

This patch is a prerequisite for adding the device tree support.
It also allows to unbind/bind the driver at runtime from user space
via sysfs.

Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/media/video/s5p-fimc/fimc-core.c    |    4 +-
 drivers/media/video/s5p-fimc/fimc-mdevice.c |   70 +++++++++++++++++++++------
 drivers/media/video/s5p-fimc/mipi-csis.c    |   15 +-----
 3 files changed, 58 insertions(+), 31 deletions(-)

diff --git a/drivers/media/video/s5p-fimc/fimc-core.c b/drivers/media/video/s5p-fimc/fimc-core.c
index 4d6b867..34cfa30 100644
--- a/drivers/media/video/s5p-fimc/fimc-core.c
+++ b/drivers/media/video/s5p-fimc/fimc-core.c
@@ -1628,7 +1628,7 @@ static int fimc_m2m_resume(struct fimc_dev *fimc)
 	return 0;
 }
 
-static int fimc_probe(struct platform_device *pdev)
+static int __devinit fimc_probe(struct platform_device *pdev)
 {
 	struct fimc_dev *fimc;
 	struct resource *res;
@@ -1992,7 +1992,7 @@ static struct platform_driver fimc_driver = {
 
 int __init fimc_register_driver(void)
 {
-	return platform_driver_probe(&fimc_driver, fimc_probe);
+	return platform_driver_register(&fimc_driver);
 }
 
 void __exit fimc_unregister_driver(void)
diff --git a/drivers/media/video/s5p-fimc/fimc-mdevice.c b/drivers/media/video/s5p-fimc/fimc-mdevice.c
index 087ea09..720e9ae 100644
--- a/drivers/media/video/s5p-fimc/fimc-mdevice.c
+++ b/drivers/media/video/s5p-fimc/fimc-mdevice.c
@@ -214,14 +214,20 @@ static struct v4l2_subdev *fimc_md_register_sensor(struct fimc_md *fmd,
 		return NULL;
 
 	adapter = i2c_get_adapter(s_info->pdata->i2c_bus_num);
-	if (!adapter)
-		return NULL;
+	if (!adapter) {
+		v4l2_warn(&fmd->v4l2_dev,
+			  "Failed to get I2C adapter %d, deferring probe\n",
+			  s_info->pdata->i2c_bus_num);
+		return ERR_PTR(-EPROBE_DEFER);
+	}
 	sd = v4l2_i2c_new_subdev_board(&fmd->v4l2_dev, adapter,
 				       s_info->pdata->board_info, NULL);
 	if (IS_ERR_OR_NULL(sd)) {
 		i2c_put_adapter(adapter);
-		v4l2_err(&fmd->v4l2_dev, "Failed to acquire subdev\n");
-		return NULL;
+		v4l2_warn(&fmd->v4l2_dev,
+			  "Failed to acquire subdev %s, deferring probe\n",
+			  s_info->pdata->board_info->type);
+		return ERR_PTR(-EPROBE_DEFER);
 	}
 	v4l2_set_subdev_hostdata(sd, s_info);
 	sd->grp_id = SENSOR_GROUP_ID;
@@ -269,13 +275,22 @@ static int fimc_md_register_sensor_entities(struct fimc_md *fmd)
 
 	fmd->num_sensors = num_clients;
 	for (i = 0; i < num_clients; i++) {
+		struct v4l2_subdev *sd;
+
 		fmd->sensor[i].pdata = &pdata->isp_info[i];
 		ret = __fimc_md_set_camclk(fmd, &fmd->sensor[i], true);
 		if (ret)
 			break;
-		fmd->sensor[i].subdev =
-			fimc_md_register_sensor(fmd, &fmd->sensor[i]);
+		sd = fimc_md_register_sensor(fmd, &fmd->sensor[i]);
 		ret = __fimc_md_set_camclk(fmd, &fmd->sensor[i], false);
+
+		if (!IS_ERR(sd)) {
+			fmd->sensor[i].subdev = sd;
+		} else {
+			fmd->sensor[i].subdev = NULL;
+			ret = PTR_ERR(sd);
+			break;
+		}
 		if (ret)
 			break;
 	}
@@ -336,24 +351,47 @@ static int csis_register_callback(struct device *dev, void *p)
  */
 static int fimc_md_register_platform_entities(struct fimc_md *fmd)
 {
+	struct s5p_platform_fimc *pdata = fmd->pdev->dev.platform_data;
 	struct device_driver *driver;
-	int ret;
+	int ret, i;
 
 	driver = driver_find(FIMC_MODULE_NAME, &platform_bus_type);
-	if (!driver)
-		return -ENODEV;
+	if (!driver) {
+		v4l2_warn(&fmd->v4l2_dev,
+			 "%s driver not found, deffering probe\n",
+			 FIMC_MODULE_NAME);
+		return -EPROBE_DEFER;
+	}
+
 	ret = driver_for_each_device(driver, NULL, fmd,
 				     fimc_register_callback);
 	put_driver(driver);
 	if (ret)
 		return ret;
+	/*
+	 * Check if there is any sensor on the MIPI-CSI2 bus and
+	 * if not skip the s5p-csis module loading.
+	 */
+	for (i = 0; i < pdata->num_clients; i++) {
+		if (pdata->isp_info[i].bus_type == FIMC_MIPI_CSI2) {
+			ret = 1;
+			break;
+		}
+	}
+	if (!ret)
+		return 0;
 
 	driver = driver_find(CSIS_DRIVER_NAME, &platform_bus_type);
-	if (driver) {
-		ret = driver_for_each_device(driver, NULL, fmd,
-					     csis_register_callback);
-		put_driver(driver);
+	if (!driver || !try_module_get(driver->owner)) {
+		v4l2_warn(&fmd->v4l2_dev,
+			 "%s driver not found, deffering probe\n",
+			 CSIS_DRIVER_NAME);
+		return -EPROBE_DEFER;
 	}
+
+	ret = driver_for_each_device(driver, NULL, fmd,
+				      csis_register_callback);
+	put_driver(driver);
 	return ret;
 }
 
@@ -372,6 +410,7 @@ static void fimc_md_unregister_entities(struct fimc_md *fmd)
 		if (fmd->csis[i].sd == NULL)
 			continue;
 		v4l2_device_unregister_subdev(fmd->csis[i].sd);
+		module_put(fmd->csis[i].sd->owner);
 		fmd->csis[i].sd = NULL;
 	}
 	for (i = 0; i < fmd->num_sensors; i++) {
@@ -843,11 +882,10 @@ static struct platform_driver fimc_md_driver = {
 
 int __init fimc_md_init(void)
 {
-	int ret;
-	request_module("s5p-csis");
-	ret = fimc_register_driver();
+	int ret = fimc_register_driver();
 	if (ret)
 		return ret;
+
 	return platform_driver_register(&fimc_md_driver);
 }
 void __exit fimc_md_exit(void)
diff --git a/drivers/media/video/s5p-fimc/mipi-csis.c b/drivers/media/video/s5p-fimc/mipi-csis.c
index 1cd6b6b..2f73d9e 100644
--- a/drivers/media/video/s5p-fimc/mipi-csis.c
+++ b/drivers/media/video/s5p-fimc/mipi-csis.c
@@ -715,19 +715,8 @@ static struct platform_driver s5pcsis_driver = {
 	},
 };
 
-static int __init s5pcsis_init(void)
-{
-	return platform_driver_probe(&s5pcsis_driver, s5pcsis_probe);
-}
-
-static void __exit s5pcsis_exit(void)
-{
-	platform_driver_unregister(&s5pcsis_driver);
-}
-
-module_init(s5pcsis_init);
-module_exit(s5pcsis_exit);
+module_platform_driver(s5pcsis_driver);
 
 MODULE_AUTHOR("Sylwester Nawrocki <s.nawrocki@samsung.com>");
-MODULE_DESCRIPTION("S5P/EXYNOS4 MIPI CSI receiver driver");
+MODULE_DESCRIPTION("Samsung S5P/EXYNOS SoC MIPI-CSI2 receiver driver");
 MODULE_LICENSE("GPL");
-- 
1.7.9.2

