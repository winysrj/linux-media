Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.samsung.com ([203.254.224.25]:30707 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933577Ab3GWSlh (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 23 Jul 2013 14:41:37 -0400
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
To: linux-media@vger.kernel.org
Cc: kyungmin.park@samsung.com, linux-samsung-soc@vger.kernel.org,
	arun.kk@samsung.com, Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [REVIEW PATCH 6/6] exynos4-is: Add support for asynchronous sensor
 subddevs registration
Date: Tue, 23 Jul 2013 20:39:37 +0200
Message-id: <1374604777-15523-7-git-send-email-s.nawrocki@samsung.com>
In-reply-to: <1374604777-15523-1-git-send-email-s.nawrocki@samsung.com>
References: <1374604777-15523-1-git-send-email-s.nawrocki@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add support registering external sensor subdevs using the v4l2-async API.
The async API is used only for sensor subdevs and only for platforms
instatiated from Device Tree.

Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/media/platform/exynos4-is/media-dev.c |  163 ++++++++++++++-----------
 drivers/media/platform/exynos4-is/media-dev.h |   12 +-
 2 files changed, 100 insertions(+), 75 deletions(-)

diff --git a/drivers/media/platform/exynos4-is/media-dev.c b/drivers/media/platform/exynos4-is/media-dev.c
index 346e1e0..280e819 100644
--- a/drivers/media/platform/exynos4-is/media-dev.c
+++ b/drivers/media/platform/exynos4-is/media-dev.c
@@ -27,6 +27,7 @@
 #include <linux/pm_runtime.h>
 #include <linux/types.h>
 #include <linux/slab.h>
+#include <media/v4l2-async.h>
 #include <media/v4l2-ctrls.h>
 #include <media/v4l2-of.h>
 #include <media/media-device.h>
@@ -221,6 +222,7 @@ static int __fimc_pipeline_open(struct exynos_media_pipeline *ep,
 		if (ret < 0)
 			return ret;
 	}
+
 	ret = fimc_md_set_camclk(sd, true);
 	if (ret < 0)
 		goto err_wbclk;
@@ -395,63 +397,6 @@ static void fimc_md_unregister_sensor(struct v4l2_subdev *sd)
 }
 
 #ifdef CONFIG_OF
-/* Register I2C client subdev associated with @node. */
-static int fimc_md_of_add_sensor(struct fimc_md *fmd,
-				 struct device_node *node, int index)
-{
-	struct fimc_sensor_info *si;
-	struct i2c_client *client;
-	struct v4l2_subdev *sd;
-	int ret;
-
-	if (WARN_ON(index >= ARRAY_SIZE(fmd->sensor)))
-		return -EINVAL;
-	si = &fmd->sensor[index];
-
-	client = of_find_i2c_device_by_node(node);
-	if (!client)
-		return -EPROBE_DEFER;
-
-	device_lock(&client->dev);
-
-	if (!client->driver ||
-	    !try_module_get(client->driver->driver.owner)) {
-		ret = -EPROBE_DEFER;
-		v4l2_info(&fmd->v4l2_dev, "No driver found for %s\n",
-						node->full_name);
-		goto dev_put;
-	}
-
-	/* Enable sensor's master clock */
-	ret = __fimc_md_set_camclk(fmd, &si->pdata, true);
-	if (ret < 0)
-		goto mod_put;
-	sd = i2c_get_clientdata(client);
-
-	ret = v4l2_device_register_subdev(&fmd->v4l2_dev, sd);
-	__fimc_md_set_camclk(fmd, &si->pdata, false);
-	if (ret < 0)
-		goto mod_put;
-
-	v4l2_set_subdev_hostdata(sd, &si->pdata);
-	if (si->pdata.fimc_bus_type == FIMC_BUS_TYPE_ISP_WRITEBACK)
-		sd->grp_id = GRP_ID_FIMC_IS_SENSOR;
-	else
-		sd->grp_id = GRP_ID_SENSOR;
-
-	si->subdev = sd;
-	v4l2_info(&fmd->v4l2_dev, "Registered sensor subdevice: %s (%d)\n",
-		  sd->name, fmd->num_sensors);
-	fmd->num_sensors++;
-
-mod_put:
-	module_put(client->driver->driver.owner);
-dev_put:
-	device_unlock(&client->dev);
-	put_device(&client->dev);
-	return ret;
-}
-
 /* Parse port node and register as a sub-device any sensor specified there. */
 static int fimc_md_parse_port_node(struct fimc_md *fmd,
 				   struct device_node *port,
@@ -460,7 +405,6 @@ static int fimc_md_parse_port_node(struct fimc_md *fmd,
 	struct device_node *rem, *ep, *np;
 	struct fimc_source_info *pd;
 	struct v4l2_of_endpoint endpoint;
-	int ret;
 	u32 val;
 
 	pd = &fmd->sensor[index].pdata;
@@ -527,10 +471,17 @@ static int fimc_md_parse_port_node(struct fimc_md *fmd,
 	else
 		pd->fimc_bus_type = pd->sensor_bus_type;
 
-	ret = fimc_md_of_add_sensor(fmd, rem, index);
-	of_node_put(rem);
+	if (WARN_ON(index >= ARRAY_SIZE(fmd->sensor)))
+		return -EINVAL;
 
-	return ret;
+	fmd->sensor[index].asd.match_type = V4L2_ASYNC_MATCH_OF;
+	fmd->sensor[index].asd.match.of.node = rem;
+	fmd->async_subdevs[index] = &fmd->sensor[index].asd;
+
+	fmd->num_sensors++;
+
+	of_node_put(rem);
+	return 0;
 }
 
 /* Register all SoC external sub-devices */
@@ -1225,6 +1176,14 @@ static int __fimc_md_set_camclk(struct fimc_md *fmd,
 	struct fimc_camclk_info *camclk;
 	int ret = 0;
 
+	/*
+	 * When device tree is used the sensor drivers are supposed to
+	 * control the clock themselves. This whole function will be
+	 * removed once S5PV210 platform is converted to the device tree.
+	 */
+	if (fmd->pdev->dev.of_node)
+		return 0;
+
 	if (WARN_ON(si->clk_id >= FIMC_MAX_CAMCLKS) || !fmd || !fmd->pmf)
 		return -EINVAL;
 
@@ -1520,6 +1479,56 @@ static int fimc_md_register_clk_provider(struct fimc_md *fmd)
 #define fimc_md_register_clk_provider(fmd) (0)
 #endif
 
+static int subdev_notifier_bound(struct v4l2_async_notifier *notifier,
+				 struct v4l2_subdev *subdev,
+				 struct v4l2_async_subdev *asd)
+{
+	struct fimc_md *fmd = notifier_to_fimc_md(notifier);
+	struct fimc_sensor_info *si = NULL;
+	int i;
+
+	/* Find platform data for this sensor subdev */
+	for (i = 0; i < ARRAY_SIZE(fmd->sensor); i++)
+		if (fmd->sensor[i].asd.match.of.node == subdev->dev->of_node)
+			si = &fmd->sensor[i];
+
+	if (si == NULL)
+		return -EINVAL;
+
+	v4l2_set_subdev_hostdata(subdev, &si->pdata);
+
+	if (si->pdata.fimc_bus_type == FIMC_BUS_TYPE_ISP_WRITEBACK)
+		subdev->grp_id = GRP_ID_FIMC_IS_SENSOR;
+	else
+		subdev->grp_id = GRP_ID_SENSOR;
+
+	si->subdev = subdev;
+
+	v4l2_info(&fmd->v4l2_dev, "Registered sensor subdevice: %s (%d)\n",
+		  subdev->name, fmd->num_sensors);
+
+	fmd->num_sensors++;
+
+	return 0;
+}
+
+static int subdev_notifier_complete(struct v4l2_async_notifier *notifier)
+{
+	struct fimc_md *fmd = notifier_to_fimc_md(notifier);
+	int ret;
+
+	mutex_lock(&fmd->media_dev.graph_mutex);
+
+	ret = fimc_md_create_links(fmd);
+	if (ret < 0)
+		goto unlock;
+
+	ret = v4l2_device_register_subdev_nodes(&fmd->v4l2_dev);
+unlock:
+	mutex_unlock(&fmd->media_dev.graph_mutex);
+	return ret;
+}
+
 static int fimc_md_probe(struct platform_device *pdev)
 {
 	struct device *dev = &pdev->dev;
@@ -1571,9 +1580,6 @@ static int fimc_md_probe(struct platform_device *pdev)
 
 	fmd->user_subdev_api = (dev->of_node != NULL);
 
-	/* Protect the media graph while we're registering entities */
-	mutex_lock(&fmd->media_dev.graph_mutex);
-
 	ret = fimc_md_get_pinctrl(fmd);
 	if (ret < 0) {
 		if (ret != EPROBE_DEFER)
@@ -1581,6 +1587,11 @@ static int fimc_md_probe(struct platform_device *pdev)
 		goto err_unlock;
 	}
 
+	platform_set_drvdata(pdev, fmd);
+
+	/* Protect the media graph while we're registering entities */
+	mutex_lock(&fmd->media_dev.graph_mutex);
+
 	if (dev->of_node)
 		ret = fimc_md_register_of_platform_entities(fmd, dev->of_node);
 	else
@@ -1595,20 +1606,23 @@ static int fimc_md_probe(struct platform_device *pdev)
 			goto err_unlock;
 	}
 
-	ret = fimc_md_create_links(fmd);
+	ret = device_create_file(&pdev->dev, &dev_attr_subdev_conf_mode);
 	if (ret)
 		goto err_unlock;
 
-	ret = v4l2_device_register_subdev_nodes(&fmd->v4l2_dev);
-	if (ret)
-		goto err_unlock;
+	mutex_unlock(&fmd->media_dev.graph_mutex);
 
-	ret = device_create_file(&pdev->dev, &dev_attr_subdev_conf_mode);
+	fmd->subdev_notifier.subdevs = fmd->async_subdevs;
+	fmd->subdev_notifier.num_subdevs = fmd->num_sensors;
+	fmd->subdev_notifier.bound = subdev_notifier_bound;
+	fmd->subdev_notifier.complete = subdev_notifier_complete;
+	fmd->num_sensors = 0;
+
+	ret = v4l2_async_notifier_register(&fmd->v4l2_dev,
+					   &fmd->subdev_notifier);
 	if (ret)
-		goto err_unlock;
+		goto err_clk;
 
-	platform_set_drvdata(pdev, fmd);
-	mutex_unlock(&fmd->media_dev.graph_mutex);
 	return 0;
 
 err_unlock:
@@ -1627,13 +1641,14 @@ static int fimc_md_remove(struct platform_device *pdev)
 {
 	struct fimc_md *fmd = platform_get_drvdata(pdev);
 
-	if (!fmd)
-		return 0;
+	v4l2_async_notifier_unregister(&fmd->subdev_notifier);
+
 	device_remove_file(&pdev->dev, &dev_attr_subdev_conf_mode);
 	fimc_md_unregister_entities(fmd);
 	fimc_md_pipelines_free(fmd);
 	media_device_unregister(&fmd->media_dev);
 	fimc_md_put_clocks(fmd);
+
 	return 0;
 }
 
diff --git a/drivers/media/platform/exynos4-is/media-dev.h b/drivers/media/platform/exynos4-is/media-dev.h
index 09cc6ca..276ad80 100644
--- a/drivers/media/platform/exynos4-is/media-dev.h
+++ b/drivers/media/platform/exynos4-is/media-dev.h
@@ -32,7 +32,7 @@
 
 #define PINCTRL_STATE_IDLE	"idle"
 
-#define FIMC_MAX_SENSORS	8
+#define FIMC_MAX_SENSORS	4
 #define FIMC_MAX_CAMCLKS	2
 
 /* LCD/ISP Writeback clocks (PIXELASYNCMx) */
@@ -79,6 +79,7 @@ struct fimc_camclk_info {
 /**
  * struct fimc_sensor_info - image data source subdev information
  * @pdata: sensor's atrributes passed as media device's platform data
+ * @asd: asynchronous subdev registration data structure
  * @subdev: image sensor v4l2 subdev
  * @host: fimc device the sensor is currently linked to
  *
@@ -86,6 +87,7 @@ struct fimc_camclk_info {
  */
 struct fimc_sensor_info {
 	struct fimc_source_info pdata;
+	struct v4l2_async_subdev asd;
 	struct v4l2_subdev *subdev;
 	struct fimc_dev *host;
 };
@@ -137,6 +139,9 @@ struct fimc_md {
 		struct device_node *of_node;
 	} clk_provider;
 
+	struct v4l2_async_notifier subdev_notifier;
+	struct v4l2_async_subdev *async_subdevs[FIMC_MAX_SENSORS];
+
 	bool user_subdev_api;
 	spinlock_t slock;
 	struct list_head pipelines;
@@ -154,6 +159,11 @@ static inline struct fimc_md *entity_to_fimc_mdev(struct media_entity *me)
 		container_of(me->parent, struct fimc_md, media_dev);
 }
 
+static inline struct fimc_md *notifier_to_fimc_md(struct v4l2_async_notifier *n)
+{
+	return container_of(n, struct fimc_md, subdev_notifier);
+}
+
 static inline void fimc_md_graph_lock(struct exynos_video_entity *ve)
 {
 	mutex_lock(&ve->vdev.entity.parent->graph_mutex);
-- 
1.7.9.5

