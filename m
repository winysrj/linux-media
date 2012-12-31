Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.samsung.com ([203.254.224.25]:15686 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750958Ab2LaQDy (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 31 Dec 2012 11:03:54 -0500
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
To: linux-media@vger.kernel.org
Cc: g.liakhovetski@gmx.de, grant.likely@secretlab.ca,
	rob.herring@calxeda.com, thomas.abraham@linaro.org,
	t.figa@samsung.com, sw0312.kim@samsung.com,
	kyungmin.park@samsung.com, devicetree-discuss@lists.ozlabs.org,
	linux-samsung-soc@vger.kernel.org,
	Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [PATCH RFC v2 06/15] s5p-fimc: Change platform subdevs registration
 method
Date: Mon, 31 Dec 2012 17:03:04 +0100
Message-id: <1356969793-27268-7-git-send-email-s.nawrocki@samsung.com>
In-reply-to: <1356969793-27268-1-git-send-email-s.nawrocki@samsung.com>
References: <1356969793-27268-1-git-send-email-s.nawrocki@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The previous method of registering platform entities into the main
driver using driver_find() and then iterating over devices bound to
a driver was racy and is being removed here. Nothing was preventing
module from unloading during a call to try_module_get(driver->owner).
Instead, we look up a device first and then check for its driver while
holding device lock.

The platform sub-devices are looked up and registered to the top
level driver. When any sub-device is not yet initialized and ready
the main driver's probe() will be deferred.

Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/media/platform/s5p-fimc/fimc-mdevice.c |  206 +++++++++++++-----------
 1 file changed, 109 insertions(+), 97 deletions(-)

diff --git a/drivers/media/platform/s5p-fimc/fimc-mdevice.c b/drivers/media/platform/s5p-fimc/fimc-mdevice.c
index 80d8fd1..bb73d17 100644
--- a/drivers/media/platform/s5p-fimc/fimc-mdevice.c
+++ b/drivers/media/platform/s5p-fimc/fimc-mdevice.c
@@ -1,8 +1,8 @@
 /*
  * S5P/EXYNOS4 SoC series camera host interface media device driver
  *
- * Copyright (C) 2011 Samsung Electronics Co., Ltd.
- * Contact: Sylwester Nawrocki, <s.nawrocki@samsung.com>
+ * Copyright (C) 2011 - 2012 Samsung Electronics Co., Ltd.
+ * Sylwester Nawrocki <s.nawrocki@samsung.com>
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License as published
@@ -312,138 +312,148 @@ static int fimc_md_register_sensor_entities(struct fimc_md *fmd)
 }
 
 /*
- * MIPI CSIS and FIMC platform devices registration.
+ * MIPI-CSIS, FIMC and FIMC-LITE platform devices registration.
  */
-static int fimc_register_callback(struct device *dev, void *p)
+
+static int register_fimc_lite_entity(struct fimc_md *fmd,
+				     struct fimc_lite *fimc_lite)
 {
-	struct fimc_dev *fimc = dev_get_drvdata(dev);
 	struct v4l2_subdev *sd;
-	struct fimc_md *fmd = p;
 	int ret;
 
-	if (fimc == NULL || fimc->id >= FIMC_MAX_DEVS)
-		return 0;
+	if (WARN_ON(fimc_lite->index >= FIMC_LITE_MAX_DEVS ||
+		    fmd->fimc_lite[fimc_lite->index]))
+		return -EBUSY;
 
-	sd = &fimc->vid_cap.subdev;
-	sd->grp_id = GRP_ID_FIMC;
+	sd = &fimc_lite->subdev;
+	sd->grp_id = GRP_ID_FLITE;
 	v4l2_set_subdev_hostdata(sd, (void *)&fimc_pipeline_ops);
 
 	ret = v4l2_device_register_subdev(&fmd->v4l2_dev, sd);
-	if (ret) {
-		v4l2_err(&fmd->v4l2_dev, "Failed to register FIMC.%d (%d)\n",
-			 fimc->id, ret);
-		return ret;
-	}
-
-	fmd->fimc[fimc->id] = fimc;
-	return 0;
+	if (!ret)
+		fmd->fimc_lite[fimc_lite->index] = fimc_lite;
+	else
+		v4l2_err(&fmd->v4l2_dev, "Failed to register FIMC.LITE%d\n",
+			 fimc_lite->index);
+	return ret;
 }
 
-static int fimc_lite_register_callback(struct device *dev, void *p)
+static int register_fimc_entity(struct fimc_md *fmd, struct fimc_dev *fimc)
 {
-	struct fimc_lite *fimc = dev_get_drvdata(dev);
-	struct fimc_md *fmd = p;
+	struct v4l2_subdev *sd;
 	int ret;
 
-	if (fimc == NULL || fimc->index >= FIMC_LITE_MAX_DEVS)
-		return 0;
-
-	fimc->subdev.grp_id = GRP_ID_FLITE;
-	v4l2_set_subdev_hostdata(&fimc->subdev, (void *)&fimc_pipeline_ops);
+	if (WARN_ON(fimc->id >= FIMC_MAX_DEVS || fmd->fimc[fimc->id]))
+		return -EBUSY;
 
-	ret = v4l2_device_register_subdev(&fmd->v4l2_dev, &fimc->subdev);
-	if (ret) {
-		v4l2_err(&fmd->v4l2_dev,
-			 "Failed to register FIMC-LITE.%d (%d)\n",
-			 fimc->index, ret);
-		return ret;
-	}
+	sd = &fimc->vid_cap.subdev;
+	sd->grp_id = GRP_ID_FIMC;
+	v4l2_set_subdev_hostdata(sd, (void *)&fimc_pipeline_ops);
 
-	fmd->fimc_lite[fimc->index] = fimc;
-	return 0;
+	ret = v4l2_device_register_subdev(&fmd->v4l2_dev, sd);
+	if (!ret)
+		fmd->fimc[fimc->id] = fimc;
+	else
+		v4l2_err(&fmd->v4l2_dev, "Failed to register FIMC.%d (%d)\n",
+			 fimc->id, ret);
+	return ret;
 }
 
-static int csis_register_callback(struct device *dev, void *p)
+static int register_csis_entity(struct fimc_md *fmd,
+				struct platform_device *pdev,
+				struct v4l2_subdev *sd)
 {
-	struct v4l2_subdev *sd = dev_get_drvdata(dev);
-	struct platform_device *pdev;
-	struct fimc_md *fmd = p;
-	int id, ret;
+	struct device_node *node = pdev->dev.of_node;
+	int id = 0;
+	int ret;
 
-	if (!sd)
-		return 0;
-	pdev = v4l2_get_subdevdata(sd);
-	if (!pdev || pdev->id < 0 || pdev->id >= CSIS_MAX_ENTITIES)
+	if (WARN_ON(id >= CSIS_MAX_ENTITIES || fmd->csis[id].sd))
+		return -EBUSY;
+
+	id = node ? of_alias_get_id(node, "csis") : max(0, pdev->id);
+
+	if (WARN_ON(id >= CSIS_MAX_ENTITIES))
 		return 0;
-	v4l2_info(sd, "csis%d sd: %s\n", pdev->id, sd->name);
 
-	id = pdev->id < 0 ? 0 : pdev->id;
 	sd->grp_id = GRP_ID_CSIS;
-
 	ret = v4l2_device_register_subdev(&fmd->v4l2_dev, sd);
 	if (!ret)
 		fmd->csis[id].sd = sd;
 	else
 		v4l2_err(&fmd->v4l2_dev,
-			 "Failed to register CSIS subdevice: %d\n", ret);
+			 "Failed to register MIPI-CSIS.%d (%d)\n", id, ret);
 	return ret;
 }
 
-/**
- * fimc_md_register_platform_entities - register FIMC and CSIS media entities
- */
-static int fimc_md_register_platform_entities(struct fimc_md *fmd)
+static int fimc_md_register_platform_entity(struct fimc_md *fmd,
+					    struct platform_device *pdev,
+					    int plat_entity)
 {
-	struct s5p_platform_fimc *pdata = fmd->pdev->dev.platform_data;
-	struct device_driver *driver;
-	int ret, i;
-
-	driver = driver_find(FIMC_MODULE_NAME, &platform_bus_type);
-	if (!driver) {
-		v4l2_warn(&fmd->v4l2_dev,
-			 "%s driver not found, deffering probe\n",
-			 FIMC_MODULE_NAME);
-		return -EPROBE_DEFER;
-	}
-
-	ret = driver_for_each_device(driver, NULL, fmd,
-				     fimc_register_callback);
-	if (ret)
-		return ret;
-
-	driver = driver_find(FIMC_LITE_DRV_NAME, &platform_bus_type);
-	if (driver && try_module_get(driver->owner)) {
-		ret = driver_for_each_device(driver, NULL, fmd,
-					     fimc_lite_register_callback);
-		if (ret)
-			return ret;
-		module_put(driver->owner);
-	}
-	/*
-	 * Check if there is any sensor on the MIPI-CSI2 bus and
-	 * if not skip the s5p-csis module loading.
-	 */
-	if (pdata == NULL)
-		return 0;
-	for (i = 0; i < pdata->num_clients; i++) {
-		if (pdata->isp_info[i].bus_type == FIMC_MIPI_CSI2) {
-			ret = 1;
+	struct device *dev = &pdev->dev;
+	int ret = -EPROBE_DEFER;
+	void *drvdata;
+
+	/* Lock to ensure dev->driver won't change. */
+	device_lock(dev);
+
+	if (!dev->driver || !try_module_get(dev->driver->owner))
+		goto dev_unlock;
+
+	drvdata = dev_get_drvdata(dev);
+	/* Some subdev didn't probe succesfully id drvdata is NULL */
+	if (drvdata) {
+		switch (plat_entity) {
+		case IDX_FIMC:
+			ret = register_fimc_entity(fmd, drvdata);
 			break;
+		case IDX_FLITE:
+			ret = register_fimc_lite_entity(fmd, drvdata);
+			break;
+		case IDX_CSIS:
+			ret = register_csis_entity(fmd, pdev, drvdata);
+			break;
+		default:
+			ret = -ENODEV;
 		}
 	}
-	if (!ret)
-		return 0;
 
-	driver = driver_find(CSIS_DRIVER_NAME, &platform_bus_type);
-	if (!driver || !try_module_get(driver->owner)) {
-		v4l2_warn(&fmd->v4l2_dev,
-			 "%s driver not found, deffering probe\n",
-			 CSIS_DRIVER_NAME);
-		return -EPROBE_DEFER;
+	module_put(dev->driver->owner);
+dev_unlock:
+	device_unlock(dev);
+	if (ret == -EPROBE_DEFER)
+		dev_info(&fmd->pdev->dev, "deferring %s device registration\n",
+			dev_name(dev));
+	else if (ret < 0)
+		dev_err(&fmd->pdev->dev, "%s device registration failed (%d)\n",
+			dev_name(dev), ret);
+	return ret;
+}
+
+static int fimc_md_pdev_match(struct device *dev, void *data)
+{
+	struct platform_device *pdev = to_platform_device(dev);
+	int plat_entity = -1;
+	int ret;
+	char *p;
+
+	if (!get_device(dev))
+		return -ENODEV;
+
+	if (!strcmp(pdev->name, CSIS_DRIVER_NAME)) {
+		plat_entity = IDX_CSIS;
+	} else if (!strcmp(pdev->name, FIMC_LITE_DRV_NAME)) {
+		plat_entity = IDX_FLITE;
+	} else {
+		p = strstr(pdev->name, "fimc");
+		if (p && *(p + 4) == 0)
+			plat_entity = IDX_FIMC;
 	}
 
-	return driver_for_each_device(driver, NULL, fmd,
-				      csis_register_callback);
+	if (plat_entity >= 0)
+		ret = fimc_md_register_platform_entity(data, pdev,
+						       plat_entity);
+	put_device(dev);
+	return 0;
 }
 
 static void fimc_md_unregister_entities(struct fimc_md *fmd)
@@ -477,6 +487,7 @@ static void fimc_md_unregister_entities(struct fimc_md *fmd)
 		fimc_md_unregister_sensor(fmd->sensor[i].subdev);
 		fmd->sensor[i].subdev = NULL;
 	}
+	v4l2_info(&fmd->v4l2_dev, "Unregistered all entities\n");
 }
 
 /**
@@ -939,7 +950,8 @@ static int fimc_md_probe(struct platform_device *pdev)
 	/* Protect the media graph while we're registering entities */
 	mutex_lock(&fmd->media_dev.graph_mutex);
 
-	ret = fimc_md_register_platform_entities(fmd);
+	ret = bus_for_each_dev(&platform_bus_type, NULL, fmd,
+					fimc_md_pdev_match);
 	if (ret)
 		goto err_unlock;
 
-- 
1.7.9.5

