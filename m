Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.samsung.com ([203.254.224.25]:55650 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751473Ab3AWTcd (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 23 Jan 2013 14:32:33 -0500
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
To: linux-media@vger.kernel.org
Cc: hverkuil@xs4all.nl, g.liakhovetski@gmx.de,
	laurent.pinchart@ideasonboard.com, kyungmin.park@samsung.com,
	kgene.kim@samsung.com, grant.likely@secretlab.ca,
	rob.herring@calxeda.com, thomas.abraham@linaro.org,
	t.figa@samsung.com, myungjoo.ham@samsung.com,
	sw0312.kim@samsung.com, prabhakar.lad@ti.com,
	devicetree-discuss@lists.ozlabs.org,
	linux-samsung-soc@vger.kernel.org,
	Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [PATCH RFC v3 07/14] s5p-fimc: Add device tree support for the main
 media device driver
Date: Wed, 23 Jan 2013 20:31:22 +0100
Message-id: <1358969489-20420-8-git-send-email-s.nawrocki@samsung.com>
In-reply-to: <1358969489-20420-1-git-send-email-s.nawrocki@samsung.com>
References: <1358969489-20420-1-git-send-email-s.nawrocki@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch adds changes required for the main camera media device
driver to be initialized on systems instantiated from the device tree.

The platform devices corresponding to child nodes of the 'camera'
node are looked up and and registered as sub-devices to the common
media device. The main driver's probing is deferred if any of the
sub-device drivers is not yet initialized and ready.

An OF matching table is added for the main driver associated with
the 'camera' node.

Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/media/platform/s5p-fimc/fimc-core.c    |    1 -
 drivers/media/platform/s5p-fimc/fimc-mdevice.c |   77 +++++++++++++++++++++---
 drivers/media/platform/s5p-fimc/fimc-mdevice.h |    4 ++
 include/media/s5p_fimc.h                       |    1 +
 4 files changed, 75 insertions(+), 8 deletions(-)

diff --git a/drivers/media/platform/s5p-fimc/fimc-core.c b/drivers/media/platform/s5p-fimc/fimc-core.c
index 5a5d44b..720ffee 100644
--- a/drivers/media/platform/s5p-fimc/fimc-core.c
+++ b/drivers/media/platform/s5p-fimc/fimc-core.c
@@ -1284,7 +1284,6 @@ static const struct platform_device_id fimc_driver_ids[] = {
 	},
 	{ },
 };
-MODULE_DEVICE_TABLE(platform, fimc_driver_ids);
 
 static const struct of_device_id fimc_of_match[] = {
 	{
diff --git a/drivers/media/platform/s5p-fimc/fimc-mdevice.c b/drivers/media/platform/s5p-fimc/fimc-mdevice.c
index abf6000..3cd2b31 100644
--- a/drivers/media/platform/s5p-fimc/fimc-mdevice.c
+++ b/drivers/media/platform/s5p-fimc/fimc-mdevice.c
@@ -17,6 +17,8 @@
 #include <linux/kernel.h>
 #include <linux/list.h>
 #include <linux/module.h>
+#include <linux/of.h>
+#include <linux/of_platform.h>
 #include <linux/platform_device.h>
 #include <linux/pm_runtime.h>
 #include <linux/types.h>
@@ -457,6 +459,51 @@ static int fimc_md_pdev_match(struct device *dev, void *data)
 	return 0;
 }
 
+/* Register FIMC, FIMC-LITE and CSIS media entities */
+#ifdef CONFIG_OF
+static int fimc_md_register_of_platform_entities(struct fimc_md *fmd,
+						 struct device_node *parent)
+{
+	struct device_node *node;
+	int ret = 0;
+
+	for_each_available_child_of_node(parent, node) {
+		struct platform_device *pdev;
+		int plat_entity = -1;
+
+		pdev = of_find_device_by_node(node);
+		if (!pdev)
+			continue;
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
+			break;
+
+		/* FIMC-IS child devices */
+		if (plat_entity == IDX_IS_ISP) {
+			ret = fimc_md_register_of_platform_entities(fmd, node);
+			if (ret < 0)
+				break;
+		}
+	}
+
+	return ret;
+}
+#else
+#define fimc_md_register_platform_entities(fmd) (-ENOSYS)
+#endif
+
 static void fimc_md_unregister_entities(struct fimc_md *fmd)
 {
 	int i;
@@ -931,8 +978,8 @@ static int fimc_md_probe(struct platform_device *pdev)
 	v4l2_dev = &fmd->v4l2_dev;
 	v4l2_dev->mdev = &fmd->media_dev;
 	v4l2_dev->notify = fimc_sensor_notify;
-	snprintf(v4l2_dev->name, sizeof(v4l2_dev->name), "%s",
-		 dev_name(&pdev->dev));
+	strlcpy(v4l2_dev->name, "s5p-fimc-md", sizeof(v4l2_dev->name));
+
 
 	ret = v4l2_device_register(&pdev->dev, &fmd->v4l2_dev);
 	if (ret < 0) {
@@ -948,13 +995,16 @@ static int fimc_md_probe(struct platform_device *pdev)
 	if (ret)
 		goto err_clk;
 
-	fmd->user_subdev_api = false;
+	fmd->user_subdev_api = (dev->of_node != NULL);
 
 	/* Protect the media graph while we're registering entities */
 	mutex_lock(&fmd->media_dev.graph_mutex);
 
-	ret = bus_for_each_dev(&platform_bus_type, NULL, fmd,
-					fimc_md_pdev_match);
+	if (fmd->pdev->dev.of_node)
+		ret = fimc_md_register_of_platform_entities(fmd, dev->of_node);
+	else
+		ret = bus_for_each_dev(&platform_bus_type, NULL, fmd,
+						fimc_md_pdev_match);
 	if (ret)
 		goto err_unlock;
 
@@ -1002,12 +1052,25 @@ static int __devexit fimc_md_remove(struct platform_device *pdev)
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
index da7d992..38006ba 100644
--- a/drivers/media/platform/s5p-fimc/fimc-mdevice.h
+++ b/drivers/media/platform/s5p-fimc/fimc-mdevice.h
@@ -21,6 +21,10 @@
 #include "fimc-lite.h"
 #include "mipi-csis.h"
 
+#define FIMC_OF_NODE_NAME	"fimc"
+#define FIMC_LITE_OF_NODE_NAME	"fimc-lite"
+#define CSIS_OF_NODE_NAME	"csis"
+
 /* Group IDs of sensor, MIPI-CSIS, FIMC-LITE and the writeback subdevs. */
 #define GRP_ID_SENSOR		(1 << 8)
 #define GRP_ID_FIMC_IS_SENSOR	(1 << 9)
diff --git a/include/media/s5p_fimc.h b/include/media/s5p_fimc.h
index eaea62a..fab66ed 100644
--- a/include/media/s5p_fimc.h
+++ b/include/media/s5p_fimc.h
@@ -68,6 +68,7 @@ enum fimc_subdev_index {
 	IDX_SENSOR,
 	IDX_CSIS,
 	IDX_FLITE,
+	IDX_IS_ISP,
 	IDX_FIMC,
 	IDX_MAX,
 };
-- 
1.7.9.5

