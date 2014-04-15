Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.samsung.com ([203.254.224.33]:32994 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753617AbaDORgm (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 15 Apr 2014 13:36:42 -0400
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
To: linux-media@vger.kernel.org
Cc: devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	kyungmin.park@samsung.com, kgene.kim@samsung.com,
	linux-samsung-soc@vger.kernel.org,
	Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [PATCH 4/5] exynos4-is: Remove requirement for "simple-bus" compatible
Date: Tue, 15 Apr 2014 19:34:31 +0200
Message-id: <1397583272-28295-5-git-send-email-s.nawrocki@samsung.com>
In-reply-to: <1397583272-28295-1-git-send-email-s.nawrocki@samsung.com>
References: <1397583272-28295-1-git-send-email-s.nawrocki@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch makes the driver instantiating its child devices itself,
rather than relying on an OS to instantiate devices as children
of "simple-bus". This removes an incorrect usage of "simple-bus"
compatible.

Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
---
This patch addresses Mark's review comments:
https://patchwork.linuxtv.org/patch/23008/
---
 .../devicetree/bindings/media/samsung-fimc.txt     |    6 +--
 drivers/media/platform/exynos4-is/common.c         |   47 +++++++++++++++++++-
 drivers/media/platform/exynos4-is/common.h         |    6 ++-
 drivers/media/platform/exynos4-is/fimc-is.c        |   12 ++++-
 drivers/media/platform/exynos4-is/media-dev.c      |   33 ++++++++++----
 5 files changed, 89 insertions(+), 15 deletions(-)

diff --git a/Documentation/devicetree/bindings/media/samsung-fimc.txt b/Documentation/devicetree/bindings/media/samsung-fimc.txt
index 922d6f8..8ce5984 100644
--- a/Documentation/devicetree/bindings/media/samsung-fimc.txt
+++ b/Documentation/devicetree/bindings/media/samsung-fimc.txt
@@ -15,9 +15,9 @@ Common 'camera' node
 
 Required properties:
 
-- compatible: must be "samsung,fimc", "simple-bus"
+- compatible: should be "samsung,fimc",
 - clocks: list of clock specifiers, corresponding to entries in
-  the clock-names property;
+  the clock-names property,
 - clock-names : must contain "sclk_cam0", "sclk_cam1", "pxl_async0",
   "pxl_async1" entries, matching entries in the clocks property.
 
@@ -157,7 +157,7 @@ Example:
 	};
 
 	camera {
-		compatible = "samsung,fimc", "simple-bus";
+		compatible = "samsung,fimc";
 		clocks = <&clock 132>, <&clock 133>, <&clock 351>,
 			 <&clock 352>;
 		clock-names = "sclk_cam0", "sclk_cam1", "pxl_async0",
diff --git a/drivers/media/platform/exynos4-is/common.c b/drivers/media/platform/exynos4-is/common.c
index 0eb34ec..1e50a48 100644
--- a/drivers/media/platform/exynos4-is/common.c
+++ b/drivers/media/platform/exynos4-is/common.c
@@ -1,7 +1,7 @@
 /*
  * Samsung S5P/EXYNOS4 SoC Camera Subsystem driver
  *
- * Copyright (C) 2013 Samsung Electronics Co., Ltd.
+ * Copyright (C) 2013 - 2014 Samsung Electronics Co., Ltd.
  * Author: Sylwester Nawrocki <s.nawrocki@samsung.com>
  *
  * This program is free software; you can redistribute it and/or modify
@@ -11,6 +11,7 @@
 
 #include <linux/module.h>
 #include <media/exynos-fimc.h>
+#include <linux/of_device.h>
 #include "common.h"
 
 /* Called with the media graph mutex held or entity->stream_count > 0. */
@@ -50,4 +51,48 @@ void __fimc_vidioc_querycap(struct device *dev, struct v4l2_capability *cap,
 }
 EXPORT_SYMBOL(__fimc_vidioc_querycap);
 
+static int __remove_child_device(struct device *dev, void *unused)
+{
+        of_device_unregister(to_platform_device(dev));
+        return 0;
+}
+
+void fimc_unregister_child_devices(struct device *parent)
+{
+        device_for_each_child(parent, NULL, __remove_child_device);
+}
+EXPORT_SYMBOL(fimc_unregister_child_devices);
+
+struct platform_device *fimc_register_child_device(struct device_node *child,
+						   struct device *parent)
+{
+	struct platform_device *pdev;
+
+	pdev = of_platform_device_create(child, NULL, parent);
+	if (!pdev)
+		dev_err(parent,
+			"failed to create device for node %s\n",
+			child->full_name);
+	return pdev;
+}
+EXPORT_SYMBOL(fimc_register_child_device);
+
+int fimc_register_child_devices(struct device *parent)
+{
+	struct platform_device *pdev;
+	struct device_node *child;
+
+	for_each_available_child_of_node(parent->of_node, child) {
+		pdev = fimc_register_child_device(child, parent);
+		if (!pdev) {
+			of_node_put(child);
+			fimc_unregister_child_devices(parent);
+			return -ENXIO;
+		}
+
+	}
+	return 0;
+}
+EXPORT_SYMBOL(fimc_register_child_devices);
+
 MODULE_LICENSE("GPL");
diff --git a/drivers/media/platform/exynos4-is/common.h b/drivers/media/platform/exynos4-is/common.h
index 75b9c71..1d06715 100644
--- a/drivers/media/platform/exynos4-is/common.h
+++ b/drivers/media/platform/exynos4-is/common.h
@@ -1,5 +1,5 @@
 /*
- * Copyright (C) 2013 Samsung Electronics Co., Ltd.
+ * Copyright (C) 2013 - 2014 Samsung Electronics Co., Ltd.
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License version 2 as
@@ -14,3 +14,7 @@
 struct v4l2_subdev *fimc_find_remote_sensor(struct media_entity *entity);
 void __fimc_vidioc_querycap(struct device *dev, struct v4l2_capability *cap,
 			    unsigned int caps);
+struct platform_device *fimc_register_child_device(struct device_node *child,
+						   struct device *parent);
+int fimc_register_child_devices(struct device *parent);
+void fimc_unregister_child_devices(struct device *parent);
diff --git a/drivers/media/platform/exynos4-is/fimc-is.c b/drivers/media/platform/exynos4-is/fimc-is.c
index a875090..05eab0f 100644
--- a/drivers/media/platform/exynos4-is/fimc-is.c
+++ b/drivers/media/platform/exynos4-is/fimc-is.c
@@ -33,6 +33,7 @@
 #include <linux/videodev2.h>
 #include <media/videobuf2-dma-contig.h>
 
+#include "common.h"
 #include "media-dev.h"
 #include "fimc-is.h"
 #include "fimc-is-command.h"
@@ -201,6 +202,13 @@ static int fimc_is_register_subdevs(struct fimc_is *is)
 	struct device_node *i2c_bus, *child;
 	int ret, index = 0;
 
+	/* Create child devices (FIMC-LITE, I2C...) */
+	if (!of_device_is_compatible(is->pdev->dev.of_node, "simple-bus")) {
+		ret = fimc_register_child_devices(&is->pdev->dev);
+		if (ret < 0)
+			return ret;
+	}
+
 	ret = fimc_isp_subdev_create(&is->isp);
 	if (ret < 0)
 		return ret;
@@ -222,10 +230,10 @@ static int fimc_is_register_subdevs(struct fimc_is *is)
 	return 0;
 }
 
-static int fimc_is_unregister_subdevs(struct fimc_is *is)
+static void fimc_is_unregister_subdevs(struct fimc_is *is)
 {
 	fimc_isp_subdev_destroy(&is->isp);
-	return 0;
+	fimc_unregister_child_devices(&is->pdev->dev);
 }
 
 static int fimc_is_load_setfile(struct fimc_is *is, char *file_name)
diff --git a/drivers/media/platform/exynos4-is/media-dev.c b/drivers/media/platform/exynos4-is/media-dev.c
index 0b64ec8..975063c 100644
--- a/drivers/media/platform/exynos4-is/media-dev.c
+++ b/drivers/media/platform/exynos4-is/media-dev.c
@@ -33,6 +33,7 @@
 #include <media/media-device.h>
 #include <media/exynos-fimc.h>
 
+#include "common.h"
 #include "media-dev.h"
 #include "fimc-core.h"
 #include "fimc-is.h"
@@ -625,19 +626,28 @@ dev_unlock:
 }
 
 /* Register FIMC, FIMC-LITE and CSIS media entities */
-static int fimc_md_register_platform_entities(struct fimc_md *fmd,
-					      struct device_node *parent)
+static int fimc_md_register_platform_entities(struct fimc_md *fmd)
 {
+	struct device *parent = &fmd->pdev->dev;
+	bool create_devices = !of_device_is_compatible(parent->of_node,
+						       "simple-bus");
 	struct device_node *node;
 	int ret = 0;
 
-	for_each_available_child_of_node(parent, node) {
+	for_each_available_child_of_node(parent->of_node, node) {
 		struct platform_device *pdev;
 		int plat_entity = -1;
 
-		pdev = of_find_device_by_node(node);
-		if (!pdev)
-			continue;
+		if (create_devices) {
+			pdev = fimc_register_child_device(node, parent);
+			if (!pdev)
+				return -ENXIO;
+		} else {
+			/* For backward compatibility with old dtb only */
+			pdev = of_find_device_by_node(node);
+			if (!pdev)
+				continue;
+		}
 
 		/* If driver of any entity isn't ready try all again later. */
 		if (!strcmp(node->name, CSIS_OF_NODE_NAME))
@@ -653,7 +663,9 @@ static int fimc_md_register_platform_entities(struct fimc_md *fmd,
 		if (plat_entity >= 0)
 			ret = fimc_md_register_platform_entity(fmd, pdev,
 							plat_entity);
-		put_device(&pdev->dev);
+		if (!create_devices)
+			put_device(&pdev->dev);
+
 		if (ret < 0)
 			break;
 	}
@@ -690,6 +702,11 @@ static void fimc_md_unregister_entities(struct fimc_md *fmd)
 
 	if (fmd->fimc_is)
 		v4l2_device_unregister_subdev(&fmd->fimc_is->isp.subdev);
+	/*
+	 * Free any registered devices corresponding to the camera node
+	 * child nodes.
+	 */
+	fimc_unregister_child_devices(&fmd->pdev->dev);
 
 	v4l2_info(&fmd->v4l2_dev, "Unregistered all entities\n");
 }
@@ -1374,7 +1391,7 @@ static int fimc_md_probe(struct platform_device *pdev)
 	/* Protect the media graph while we're registering entities */
 	mutex_lock(&fmd->media_dev.graph_mutex);
 
-	ret = fimc_md_register_platform_entities(fmd, dev->of_node);
+	ret = fimc_md_register_platform_entities(fmd);
 	if (ret) {
 		mutex_unlock(&fmd->media_dev.graph_mutex);
 		goto err_clk;
-- 
1.7.9.5

