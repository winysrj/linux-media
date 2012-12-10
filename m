Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.samsung.com ([203.254.224.34]:20763 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752273Ab2LJTqg (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 10 Dec 2012 14:46:36 -0500
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
To: linux-media@vger.kernel.org
Cc: g.liakhovetski@gmx.de, grant.likely@secretlab.ca,
	rob.herring@calxeda.com, thomas.abraham@linaro.org,
	t.figa@samsung.com, sw0312.kim@samsung.com,
	kyungmin.park@samsung.com, devicetree-discuss@lists.ozlabs.org,
	linux-samsung-soc@vger.kernel.org,
	Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [PATCH RFC 04/12] s5p-fimc: Instantiate media device from device tree
Date: Mon, 10 Dec 2012 20:45:58 +0100
Message-id: <1355168766-6068-5-git-send-email-s.nawrocki@samsung.com>
In-reply-to: <1355168766-6068-1-git-send-email-s.nawrocki@samsung.com>
References: <1355168766-6068-1-git-send-email-s.nawrocki@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The platform sub-devices are looked up and registered to the top
level driver, similarly as it is done in non-dt case. When any
sub-device is not yet initialized and ready the main driver's
probe() will be deferred.

This patch adds matching table for the common media device driver
associated with the 'camera' dt node.

The previous method of registering platform entities into top
level driver using driver_find() and then iterating over devices
bound to a driver was racy and is being removed here. Instead,
we lookup a device first and then check for its driver, while
holding the device's mutex.

Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/media/platform/s5p-fimc/fimc-mdevice.c |  261 +++++++++++++++---------
 drivers/media/platform/s5p-fimc/fimc-mdevice.h |    4 +
 2 files changed, 167 insertions(+), 98 deletions(-)

diff --git a/drivers/media/platform/s5p-fimc/fimc-mdevice.c b/drivers/media/platform/s5p-fimc/fimc-mdevice.c
index 80d8fd1..2657e90 100644
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
@@ -17,6 +17,8 @@
 #include <linux/kernel.h>
 #include <linux/list.h>
 #include <linux/module.h>
+#include <linux/of.h>
+#include <linux/of_platform.h>
 #include <linux/platform_device.h>
 #include <linux/pm_runtime.h>
 #include <linux/types.h>
@@ -312,138 +314,187 @@ static int fimc_md_register_sensor_entities(struct fimc_md *fmd)
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
 
+static int fimc_md_register_platform_entity(struct fimc_md *fmd,
+					    struct platform_device *pdev,
+					    int plat_entity)
+{
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
+			break;
+		case IDX_FLITE:
+			ret = register_fimc_lite_entity(fmd, drvdata);
+			break;
+		case IDX_CSIS:
+			ret = register_csis_entity(fmd, pdev, drvdata);
+			break;
+		default:
+			ret = -ENODEV;
+		}
+	}
+
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
+	}
+
+	if (plat_entity >= 0)
+		ret = fimc_md_register_platform_entity(data, pdev,
+						       plat_entity);
+	put_device(dev);
+	return 0;
+}
+
 /**
  * fimc_md_register_platform_entities - register FIMC and CSIS media entities
  */
 static int fimc_md_register_platform_entities(struct fimc_md *fmd)
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
+	struct device_node *node;
+	int ret = 0;
 
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
+	if (fmd->pdev->dev.of_node == NULL)
+		return bus_for_each_dev(&platform_bus_type, NULL,
+					fmd, fimc_md_pdev_match);
+
+	for_each_available_child_of_node(fmd->pdev->dev.of_node, node) {
+		struct platform_device *pdev;
+		int plat_entity = -1;
+
+		pdev = of_find_device_by_node(node);
+		if (!pdev)
+			return -ENODEV;
+
+		/* If driver of any entity isn't ready try all again later. */
+		if (!strcmp(node->name, CSIS_OF_NODE_NAME))
+			plat_entity = IDX_CSIS;
+		else if (!strcmp(node->name, FIMC_LITE_OF_NODE_NAME))
+			plat_entity = IDX_FLITE;
+		else if	(!strcmp(node->name, FIMC_OF_NODE_NAME))
+			plat_entity = IDX_FIMC;
+
+		if (plat_entity >= 0)
+			ret = fimc_md_register_platform_entity(fmd, pdev,
+							plat_entity);
+		put_device(&pdev->dev);
+		if (ret < 0)
 			break;
-		}
-	}
-	if (!ret)
-		return 0;
-
-	driver = driver_find(CSIS_DRIVER_NAME, &platform_bus_type);
-	if (!driver || !try_module_get(driver->owner)) {
-		v4l2_warn(&fmd->v4l2_dev,
-			 "%s driver not found, deffering probe\n",
-			 CSIS_DRIVER_NAME);
-		return -EPROBE_DEFER;
 	}
 
-	return driver_for_each_device(driver, NULL, fmd,
-				      csis_register_callback);
+	return ret;
 }
 
 static void fimc_md_unregister_entities(struct fimc_md *fmd)
@@ -477,6 +528,7 @@ static void fimc_md_unregister_entities(struct fimc_md *fmd)
 		fimc_md_unregister_sensor(fmd->sensor[i].subdev);
 		fmd->sensor[i].subdev = NULL;
 	}
+	v4l2_info(&fmd->v4l2_dev, "Unregistered all entities\n");
 }
 
 /**
@@ -917,8 +969,8 @@ static int fimc_md_probe(struct platform_device *pdev)
 	v4l2_dev = &fmd->v4l2_dev;
 	v4l2_dev->mdev = &fmd->media_dev;
 	v4l2_dev->notify = fimc_sensor_notify;
-	snprintf(v4l2_dev->name, sizeof(v4l2_dev->name), "%s",
-		 dev_name(&pdev->dev));
+	strlcpy(v4l2_dev->name, "s5p-fimc-md", sizeof(v4l2_dev->name));
+
 
 	ret = v4l2_device_register(&pdev->dev, &fmd->v4l2_dev);
 	if (ret < 0) {
@@ -987,12 +1039,25 @@ static int __devexit fimc_md_remove(struct platform_device *pdev)
 	return 0;
 }
 
+static struct platform_device_id fimc_driver_ids[] __always_unused = {
+	{ .name = "s5p-fimc-md" },
+	{ },
+};
+MODULE_DEVICE_TABLE(platform, fimc_driver_ids);
+
+static const struct of_device_id fimc_md_of_match[] __initconst = {
+	{ .compatible = "samsung,fimc" },
+	{ },
+};
+MODULE_DEVICE_TABLE(of, fimc_md_of_match);
+
 static struct platform_driver fimc_md_driver = {
 	.probe		= fimc_md_probe,
 	.remove		= __devexit_p(fimc_md_remove),
 	.driver = {
-		.name	= "s5p-fimc-md",
-		.owner	= THIS_MODULE,
+		.of_match_table = fimc_md_of_match,
+		.name		= "s5p-fimc-md",
+		.owner		= THIS_MODULE,
 	}
 };
 
diff --git a/drivers/media/platform/s5p-fimc/fimc-mdevice.h b/drivers/media/platform/s5p-fimc/fimc-mdevice.h
index da7d992..1b7850c 100644
--- a/drivers/media/platform/s5p-fimc/fimc-mdevice.h
+++ b/drivers/media/platform/s5p-fimc/fimc-mdevice.h
@@ -21,6 +21,10 @@
 #include "fimc-lite.h"
 #include "mipi-csis.h"
 
+#define FIMC_OF_NODE_NAME	"fimc"
+#define FIMC_LITE_OF_NODE_NAME	"fimc_lite"
+#define CSIS_OF_NODE_NAME	"csis"
+
 /* Group IDs of sensor, MIPI-CSIS, FIMC-LITE and the writeback subdevs. */
 #define GRP_ID_SENSOR		(1 << 8)
 #define GRP_ID_FIMC_IS_SENSOR	(1 << 9)
-- 
1.7.9.5

