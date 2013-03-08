Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.samsung.com ([203.254.224.24]:15138 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933517Ab3CHQqj (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 8 Mar 2013 11:46:39 -0500
Received: from epcpsbgm1.samsung.com (epcpsbgm1 [203.254.230.26])
 by mailout1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MJC00IWEP98S540@mailout1.samsung.com> for
 linux-media@vger.kernel.org; Sat, 09 Mar 2013 01:46:38 +0900 (KST)
Received: from amdc1344.digital.local ([106.116.147.32])
 by mmp1.samsung.com (Oracle Communications Messaging Server 7u4-24.01
 (7.0.4.24.0) 64bit (built Nov 17 2011))
 with ESMTPA id <0MJC00BU5P8ZM870@mmp1.samsung.com> for
 linux-media@vger.kernel.org; Sat, 09 Mar 2013 01:46:37 +0900 (KST)
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
To: linux-media@vger.kernel.org
Cc: devicetree-discuss@lists.ozlabs.org, swarren@wwwdotorg.org,
	shaik.samsung@gmail.com, arun.kk@samsung.com, a.hajda@samsung.com,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Kyungmin Park <kyungmin.park@samsung.com>
Subject: [PATCH RFC v5 4/6] s5p-fimc: Add device tree support for the media
 device driver
Date: Fri, 08 Mar 2013 17:46:04 +0100
Message-id: <1362761166-5285-6-git-send-email-s.nawrocki@samsung.com>
In-reply-to: <1362761166-5285-1-git-send-email-s.nawrocki@samsung.com>
References: <1362761166-5285-1-git-send-email-s.nawrocki@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch adds changes required for the main camera media device
driver corresponding to the top level 'camera' device node.

The drivers of devices corresponding to child nodes of the 'camera'
node are looked up and and registered as sub-devices to the top
level driver. The main driver's probing is deferred if any of the
sub-device drivers is not yet initialized and ready.

Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Signed-off-by: Andrzej Hajda <a.hajda@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---

Changes since v4:
 - fimc-lite device nodes are not fimc-is children any more,
   fimc_md_of_register_platform entities() function has been
   updated accordingly, i.e. removed recursive call.

---
 drivers/media/platform/s5p-fimc/fimc-core.c    |    1 -
 drivers/media/platform/s5p-fimc/fimc-mdevice.c |  107 ++++++++++++++++++++----
 drivers/media/platform/s5p-fimc/fimc-mdevice.h |    5 ++
 include/media/s5p_fimc.h                       |    1 +
 4 files changed, 97 insertions(+), 17 deletions(-)

diff --git a/drivers/media/platform/s5p-fimc/fimc-core.c b/drivers/media/platform/s5p-fimc/fimc-core.c
index 27796e9..d7fe332 100644
--- a/drivers/media/platform/s5p-fimc/fimc-core.c
+++ b/drivers/media/platform/s5p-fimc/fimc-core.c
@@ -1285,7 +1285,6 @@ static const struct platform_device_id fimc_driver_ids[] = {
 	},
 	{ },
 };
-MODULE_DEVICE_TABLE(platform, fimc_driver_ids);
 
 static const struct of_device_id fimc_of_match[] = {
 	{
diff --git a/drivers/media/platform/s5p-fimc/fimc-mdevice.c b/drivers/media/platform/s5p-fimc/fimc-mdevice.c
index c800129..7fae4c9 100644
--- a/drivers/media/platform/s5p-fimc/fimc-mdevice.c
+++ b/drivers/media/platform/s5p-fimc/fimc-mdevice.c
@@ -17,11 +17,16 @@
 #include <linux/kernel.h>
 #include <linux/list.h>
 #include <linux/module.h>
+#include <linux/of.h>
+#include <linux/of_platform.h>
+#include <linux/of_device.h>
+#include <linux/of_i2c.h>
 #include <linux/platform_device.h>
 #include <linux/pm_runtime.h>
 #include <linux/types.h>
 #include <linux/slab.h>
 #include <media/v4l2-ctrls.h>
+#include <media/v4l2-of.h>
 #include <media/media-device.h>
 #include <media/s5p_fimc.h>
 
@@ -264,6 +269,21 @@ static void fimc_md_unregister_sensor(struct v4l2_subdev *sd)
 		i2c_put_adapter(adapter);
 }
 
+#ifdef CONFIG_OF
+static int __of_get_csis_id(struct device_node *np)
+{
+	u32 reg = 0;
+
+	np = of_get_child_by_name(np, "port");
+	if (!np)
+		return -EINVAL;
+	of_property_read_u32(np, "reg", &reg);
+	return reg - FIMC_INPUT_MIPI_CSI2_0;
+}
+#else
+#define __of_get_csis_id(np) (-ENOSYS)
+#endif
+
 static int fimc_md_register_sensor_entities(struct fimc_md *fmd)
 {
 	struct s5p_platform_fimc *pdata = fmd->pdev->dev.platform_data;
@@ -368,13 +388,13 @@ static int register_csis_entity(struct fimc_md *fmd,
 	struct device_node *node = pdev->dev.of_node;
 	int id, ret;
 
-	id = node ? of_alias_get_id(node, "csis") : max(0, pdev->id);
+	id = node ? __of_get_csis_id(node) : max(0, pdev->id);
 
-	if (WARN_ON(id >= CSIS_MAX_ENTITIES || fmd->csis[id].sd))
-		return -EBUSY;
+	if (WARN_ON(id < 0 || id >= CSIS_MAX_ENTITIES))
+		return -ENOENT;
 
-	if (WARN_ON(id >= CSIS_MAX_ENTITIES))
-		return 0;
+	if (WARN_ON(fmd->csis[id].sd))
+		return -EBUSY;
 
 	sd->grp_id = GRP_ID_CSIS;
 	ret = v4l2_device_register_subdev(&fmd->v4l2_dev, sd);
@@ -457,6 +477,44 @@ static int fimc_md_pdev_match(struct device *dev, void *data)
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
+	}
+
+	return ret;
+}
+#else
+#define fimc_md_register_of_platform_entities(fmd, node) (-ENOSYS)
+#endif
+
 static void fimc_md_unregister_entities(struct fimc_md *fmd)
 {
 	int i;
@@ -931,11 +989,12 @@ static DEVICE_ATTR(subdev_conf_mode, S_IWUSR | S_IRUGO,
 
 static int fimc_md_probe(struct platform_device *pdev)
 {
+	struct device *dev = &pdev->dev;
 	struct v4l2_device *v4l2_dev;
 	struct fimc_md *fmd;
 	int ret;
 
-	fmd = devm_kzalloc(&pdev->dev, sizeof(*fmd), GFP_KERNEL);
+	fmd = devm_kzalloc(dev, sizeof(*fmd), GFP_KERNEL);
 	if (!fmd)
 		return -ENOMEM;
 
@@ -945,15 +1004,14 @@ static int fimc_md_probe(struct platform_device *pdev)
 	strlcpy(fmd->media_dev.model, "SAMSUNG S5P FIMC",
 		sizeof(fmd->media_dev.model));
 	fmd->media_dev.link_notify = fimc_md_link_notify;
-	fmd->media_dev.dev = &pdev->dev;
+	fmd->media_dev.dev = dev;
 
 	v4l2_dev = &fmd->v4l2_dev;
 	v4l2_dev->mdev = &fmd->media_dev;
 	v4l2_dev->notify = fimc_sensor_notify;
-	snprintf(v4l2_dev->name, sizeof(v4l2_dev->name), "%s",
-		 dev_name(&pdev->dev));
+	strlcpy(v4l2_dev->name, "s5p-fimc-md", sizeof(v4l2_dev->name));
 
-	ret = v4l2_device_register(&pdev->dev, &fmd->v4l2_dev);
+	ret = v4l2_device_register(dev, &fmd->v4l2_dev);
 	if (ret < 0) {
 		v4l2_err(v4l2_dev, "Failed to register v4l2_device: %d\n", ret);
 		return ret;
@@ -967,21 +1025,25 @@ static int fimc_md_probe(struct platform_device *pdev)
 	if (ret)
 		goto err_clk;
 
-	fmd->user_subdev_api = false;
+	fmd->user_subdev_api = (dev->of_node != NULL);
 
 	/* Protect the media graph while we're registering entities */
 	mutex_lock(&fmd->media_dev.graph_mutex);
 
-	ret = bus_for_each_dev(&platform_bus_type, NULL, fmd,
-					fimc_md_pdev_match);
+	if (dev->of_node)
+		ret = fimc_md_register_of_platform_entities(fmd, dev->of_node);
+	else
+		ret = bus_for_each_dev(&platform_bus_type, NULL, fmd,
+						fimc_md_pdev_match);
 	if (ret)
 		goto err_unlock;
 
-	if (pdev->dev.platform_data) {
+	if (dev->platform_data) {
 		ret = fimc_md_register_sensor_entities(fmd);
 		if (ret)
 			goto err_unlock;
 	}
+
 	ret = fimc_md_create_links(fmd);
 	if (ret)
 		goto err_unlock;
@@ -1021,12 +1083,25 @@ static int fimc_md_remove(struct platform_device *pdev)
 	return 0;
 }
 
+static struct platform_device_id fimc_driver_ids[] __always_unused = {
+	{ .name = "s5p-fimc-md" },
+	{ },
+};
+MODULE_DEVICE_TABLE(platform, fimc_driver_ids);
+
+static const struct of_device_id fimc_md_of_match[] = {
+	{ .compatible = "samsung,fimc" },
+	{ },
+};
+MODULE_DEVICE_TABLE(of, fimc_md_of_match);
+
 static struct platform_driver fimc_md_driver = {
 	.probe		= fimc_md_probe,
 	.remove		= fimc_md_remove,
 	.driver = {
-		.name	= "s5p-fimc-md",
-		.owner	= THIS_MODULE,
+		.of_match_table = of_match_ptr(fimc_md_of_match),
+		.name		= "s5p-fimc-md",
+		.owner		= THIS_MODULE,
 	}
 };
 
diff --git a/drivers/media/platform/s5p-fimc/fimc-mdevice.h b/drivers/media/platform/s5p-fimc/fimc-mdevice.h
index 06b0d82..b6ceb59 100644
--- a/drivers/media/platform/s5p-fimc/fimc-mdevice.h
+++ b/drivers/media/platform/s5p-fimc/fimc-mdevice.h
@@ -21,6 +21,11 @@
 #include "fimc-lite.h"
 #include "mipi-csis.h"
 
+#define FIMC_OF_NODE_NAME	"fimc"
+#define FIMC_LITE_OF_NODE_NAME	"fimc-lite"
+#define FIMC_IS_OF_NODE_NAME	"fimc-is"
+#define CSIS_OF_NODE_NAME	"csis"
+
 /* Group IDs of sensor, MIPI-CSIS, FIMC-LITE and the writeback subdevs. */
 #define GRP_ID_SENSOR		(1 << 8)
 #define GRP_ID_FIMC_IS_SENSOR	(1 << 9)
diff --git a/include/media/s5p_fimc.h b/include/media/s5p_fimc.h
index d6dbb79..e2c5989 100644
--- a/include/media/s5p_fimc.h
+++ b/include/media/s5p_fimc.h
@@ -94,6 +94,7 @@ enum fimc_subdev_index {
 	IDX_SENSOR,
 	IDX_CSIS,
 	IDX_FLITE,
+	IDX_IS_ISP,
 	IDX_FIMC,
 	IDX_MAX,
 };
-- 
1.7.9.5

