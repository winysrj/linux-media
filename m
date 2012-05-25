Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.w1.samsung.com ([210.118.77.14]:25307 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758530Ab2EYTxJ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 25 May 2012 15:53:09 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN
Date: Fri, 25 May 2012 21:52:46 +0200
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [RFC/PATCH 07/13] media: s5p-fimc: Enable device tree based media
 device instantiation
In-reply-to: <1337975573-27117-1-git-send-email-s.nawrocki@samsung.com>
To: linux-media@vger.kernel.org
Cc: kyungmin.park@samsung.com, m.szyprowski@samsung.com,
	riverful.kim@samsung.com, sw0312.kim@samsung.com,
	s.nawrocki@samsung.com, devicetree-discuss@lists.ozlabs.org,
	linux-samsung-soc@vger.kernel.org, b.zolnierkie@samsung.com
Message-id: <1337975573-27117-7-git-send-email-s.nawrocki@samsung.com>
References: <4FBFE1EC.9060209@samsung.com>
 <1337975573-27117-1-git-send-email-s.nawrocki@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Enable device tree based instantiation of the common platform device
associated with the top level media device driver. Handling of the
image sensor related properties, like video port pins configuration,
is not included in this patch.

Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/media/video/s5p-fimc/fimc-core.h    |    2 +-
 drivers/media/video/s5p-fimc/fimc-mdevice.c |  104 +++++++++++++++++++++++++--
 2 files changed, 101 insertions(+), 5 deletions(-)

diff --git a/drivers/media/video/s5p-fimc/fimc-core.h b/drivers/media/video/s5p-fimc/fimc-core.h
index a1df84d..8c5c03f 100644
--- a/drivers/media/video/s5p-fimc/fimc-core.h
+++ b/drivers/media/video/s5p-fimc/fimc-core.h
@@ -431,7 +431,7 @@ struct fimc_dev {
 	struct mutex			lock;
 	struct platform_device		*pdev;
 	struct fimc_variant		*variant;
-	u16				id;
+	u32				id;
 	struct clk			*clock[MAX_FIMC_CLOCKS];
 	void __iomem			*regs;
 	wait_queue_head_t		irq_queue;
diff --git a/drivers/media/video/s5p-fimc/fimc-mdevice.c b/drivers/media/video/s5p-fimc/fimc-mdevice.c
index 3ffc4f5e..92c9887 100644
--- a/drivers/media/video/s5p-fimc/fimc-mdevice.c
+++ b/drivers/media/video/s5p-fimc/fimc-mdevice.c
@@ -17,6 +17,8 @@
 #include <linux/kernel.h>
 #include <linux/list.h>
 #include <linux/module.h>
+#include <linux/of.h>
+#include <linux/of_platform.h>
 #include <linux/platform_device.h>
 #include <linux/pm_runtime.h>
 #include <linux/types.h>
@@ -404,6 +406,87 @@ static int csis_register_callback(struct device *dev, void *p)
 	return ret;
 }
 
+static int fimc_md_register_of_plat_entities(struct fimc_md *fmd)
+{
+#ifdef CONFIG_OF
+	struct device_node *np = fmd->pdev->dev.of_node;
+	struct device_node *node;
+	struct platform_device *pdev;
+	struct v4l2_subdev *sd;
+	struct fimc_dev *fimc;
+	u32 index;
+	int ret;
+
+	for (index = 0; index < FIMC_MAX_DEVS; index++) {
+		node = of_parse_phandle(np, "fimc-controllers", index);
+		if (node == NULL)
+			break;
+
+		pdev = of_find_device_by_node(node);
+		of_node_put(node);
+
+		fimc = dev_get_drvdata(&pdev->dev);
+		if (fimc == NULL)
+			return -EPROBE_DEFER;
+
+		if (WARN_ON(fimc->id >= FIMC_MAX_DEVS || fmd->fimc[fimc->id]))
+			continue;
+
+		fmd->fimc[fimc->id] = fimc;
+		sd = &fimc->vid_cap.subdev;
+		sd->grp_id = FIMC_GROUP_ID;
+
+		ret = v4l2_device_register_subdev(&fmd->v4l2_dev, sd);
+		if (ret) {
+			v4l2_err(&fmd->v4l2_dev, "Failed to register FIMC.%d\n",
+				 fimc->id);
+			return ret;
+		}
+
+		pr_notice("%s:%d succedded to register %s\n", __FILE__, __LINE__, node->full_name);
+	}
+
+	for (index = 0; index < CSIS_MAX_ENTITIES; index++) {
+		unsigned int id = 0;
+
+		node = of_parse_phandle(np, "csi-rx-controllers", index);
+		if (node == NULL)
+			break;
+
+		pdev = of_find_device_by_node(node);
+		if (pdev == NULL)
+			return -ENODEV;
+
+		of_property_read_u32(node, "cell-index", &id);
+		of_node_put(node);
+
+		if (!try_module_get(pdev->dev.driver->owner))
+			return -ENODEV;
+
+		sd = dev_get_drvdata(&pdev->dev);
+		if (sd == NULL) {
+			module_put(pdev->dev.driver->owner);
+			return -EPROBE_DEFER;
+		}
+
+		if (id < CSIS_MAX_ENTITIES && fmd->csis[id].sd == NULL) {
+			sd->grp_id = CSIS_GROUP_ID;
+			fmd->csis[id].sd = sd;
+
+			ret = v4l2_device_register_subdev(&fmd->v4l2_dev, sd);
+			if (ret)
+				v4l2_err(&fmd->v4l2_dev,
+					 "Failed to register CSIS.%d\n", index);
+		}
+		module_put(pdev->dev.driver->owner);
+
+		if (ret)
+			return ret;
+	}
+#endif
+	return 0;
+}
+
 /**
  * fimc_md_register_platform_entities - register FIMC and CSIS media entities
  */
@@ -413,6 +496,9 @@ static int fimc_md_register_platform_entities(struct fimc_md *fmd)
 	struct device_driver *driver;
 	int ret, i;
 
+	if (fmd->pdev->dev.of_node)
+		return fimc_md_register_of_plat_entities(fmd);
+
 	driver = driver_find(FIMC_MODULE_NAME, &platform_bus_type);
 	if (!driver) {
 		v4l2_warn(&fmd->v4l2_dev,
@@ -490,6 +576,7 @@ static void fimc_md_unregister_entities(struct fimc_md *fmd)
 		fimc_md_unregister_sensor(fmd->sensor[i].subdev);
 		fmd->sensor[i].subdev = NULL;
 	}
+	v4l2_info(&fmd->v4l2_dev, "Unregistered all entities\n");
 }
 
 /**
@@ -934,8 +1021,8 @@ static int fimc_md_probe(struct platform_device *pdev)
 	v4l2_dev = &fmd->v4l2_dev;
 	v4l2_dev->mdev = &fmd->media_dev;
 	v4l2_dev->notify = fimc_sensor_notify;
-	snprintf(v4l2_dev->name, sizeof(v4l2_dev->name), "%s",
-		 dev_name(&pdev->dev));
+	strlcpy(v4l2_dev->name, "s5p-fimc-md", sizeof(v4l2_dev->name));
+
 
 	ret = v4l2_device_register(&pdev->dev, &fmd->v4l2_dev);
 	if (ret < 0) {
@@ -1004,12 +1091,21 @@ static int __devexit fimc_md_remove(struct platform_device *pdev)
 	return 0;
 }
 
+#ifdef CONFIG_OF
+static const struct of_device_id fimc_of_match[] __devinitconst = {
+	{ .compatible = "samsung,fimc" },
+	{ /* sentinel */ },
+};
+MODULE_DEVICE_TABLE(of, fimc_of_match);
+#endif
+
 static struct platform_driver fimc_md_driver = {
 	.probe		= fimc_md_probe,
 	.remove		= __devexit_p(fimc_md_remove),
 	.driver = {
-		.name	= "s5p-fimc-md",
-		.owner	= THIS_MODULE,
+		.of_match_table = of_match_ptr(fimc_of_match),
+		.name		= "s5p-fimc-md",
+		.owner		= THIS_MODULE,
 	}
 };
 
-- 
1.7.10

