Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.samsung.com ([203.254.224.33]:63034 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751020Ab2LaQD6 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 31 Dec 2012 11:03:58 -0500
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
To: linux-media@vger.kernel.org
Cc: g.liakhovetski@gmx.de, grant.likely@secretlab.ca,
	rob.herring@calxeda.com, thomas.abraham@linaro.org,
	t.figa@samsung.com, sw0312.kim@samsung.com,
	kyungmin.park@samsung.com, devicetree-discuss@lists.ozlabs.org,
	linux-samsung-soc@vger.kernel.org,
	Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [PATCH RFC v2 07/15] s5p-fimc: Support camera media device
 initialization on DT systems
Date: Mon, 31 Dec 2012 17:03:05 +0100
Message-id: <1356969793-27268-8-git-send-email-s.nawrocki@samsung.com>
In-reply-to: <1356969793-27268-1-git-send-email-s.nawrocki@samsung.com>
References: <1356969793-27268-1-git-send-email-s.nawrocki@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch add changes required for the main camera media device
driver to be initialized on systems booted from the device tree.

The platform devices corresponding to child dt nodes of the 'camera'
node are looked up and and registered as sub-devices to the common
media device. The main driver's probing is deferred if any of the
sub-device drivers is not yet initialized and ready.

An OF matching table is added for the main driver associated with
the 'camera' node.

Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/media/platform/s5p-fimc/fimc-core.c    |    1 -
 drivers/media/platform/s5p-fimc/fimc-mdevice.c |   67 +++++++++++++++++++++---
 drivers/media/platform/s5p-fimc/fimc-mdevice.h |    4 ++
 3 files changed, 65 insertions(+), 7 deletions(-)

diff --git a/drivers/media/platform/s5p-fimc/fimc-core.c b/drivers/media/platform/s5p-fimc/fimc-core.c
index e7eabb7..b02edac 100644
--- a/drivers/media/platform/s5p-fimc/fimc-core.c
+++ b/drivers/media/platform/s5p-fimc/fimc-core.c
@@ -1280,7 +1280,6 @@ static const struct platform_device_id fimc_driver_ids[] = {
 	},
 	{ },
 };
-MODULE_DEVICE_TABLE(platform, fimc_driver_ids);
 
 static const struct of_device_id fimc_of_match[] __devinitconst = {
 	{
diff --git a/drivers/media/platform/s5p-fimc/fimc-mdevice.c b/drivers/media/platform/s5p-fimc/fimc-mdevice.c
index bb73d17..105bb91 100644
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
@@ -456,6 +458,43 @@ static int fimc_md_pdev_match(struct device *dev, void *data)
 	return 0;
 }
 
+/* Register FIMC, FIMC-LITE and CSIS media entities */
+#ifdef CONFIG_OF
+static int fimc_md_register_of_platform_entities(struct fimc_md *fmd)
+{
+	struct device_node *node;
+	int ret = 0;
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
+			break;
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
@@ -928,8 +967,8 @@ static int fimc_md_probe(struct platform_device *pdev)
 	v4l2_dev = &fmd->v4l2_dev;
 	v4l2_dev->mdev = &fmd->media_dev;
 	v4l2_dev->notify = fimc_sensor_notify;
-	snprintf(v4l2_dev->name, sizeof(v4l2_dev->name), "%s",
-		 dev_name(&pdev->dev));
+	strlcpy(v4l2_dev->name, "s5p-fimc-md", sizeof(v4l2_dev->name));
+
 
 	ret = v4l2_device_register(&pdev->dev, &fmd->v4l2_dev);
 	if (ret < 0) {
@@ -950,8 +989,11 @@ static int fimc_md_probe(struct platform_device *pdev)
 	/* Protect the media graph while we're registering entities */
 	mutex_lock(&fmd->media_dev.graph_mutex);
 
-	ret = bus_for_each_dev(&platform_bus_type, NULL, fmd,
-					fimc_md_pdev_match);
+	if (fmd->pdev->dev.of_node)
+		ret = fimc_md_register_of_platform_entities(fmd);
+	else
+		ret = bus_for_each_dev(&platform_bus_type, NULL, fmd,
+						fimc_md_pdev_match);
 	if (ret)
 		goto err_unlock;
 
@@ -999,12 +1041,25 @@ static int __devexit fimc_md_remove(struct platform_device *pdev)
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

