Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.samsung.com ([203.254.224.24]:34184 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754504Ab3H1P5g (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 28 Aug 2013 11:57:36 -0400
Received: from epcpsbgm1.samsung.com (epcpsbgm1 [203.254.230.26])
 by mailout1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MS9001500BK8HQ0@mailout1.samsung.com> for
 linux-media@vger.kernel.org; Thu, 29 Aug 2013 00:57:33 +0900 (KST)
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
To: linux-media@vger.kernel.org
Cc: mturquette@linaro.org, g.liakhovetski@gmx.de,
	laurent.pinchart@ideasonboard.com, arun.kk@samsung.com,
	hverkuil@xs4all.nl, sakari.ailus@iki.fi, a.hajda@samsung.com,
	kyungmin.park@samsung.com, t.figa@samsung.com,
	linux-arm-kernel@lists.infradead.org,
	Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [PATCH v2 7/7] exynos4-is: Add support for asynchronous sensor
 subddevs registration
Date: Wed, 28 Aug 2013 17:56:00 +0200
Message-id: <1377705360-12197-8-git-send-email-s.nawrocki@samsung.com>
In-reply-to: <1377705360-12197-1-git-send-email-s.nawrocki@samsung.com>
References: <1377705360-12197-1-git-send-email-s.nawrocki@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add support for registering external sensor subdevs using the v4l2-async
API. The async API is used only for sensor subdevs and only for platforms
instantiated from Device Tree.

Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---

Changes since v1:
 - register clock provider after registering FIMC devices so the clock
   can be actually used right after it is registered.
---
 .../devicetree/bindings/media/samsung-fimc.txt     |    4 +-
 drivers/media/platform/exynos4-is/media-dev.c      |  234 +++++++++++---------
 drivers/media/platform/exynos4-is/media-dev.h      |   13 +-
 3 files changed, 146 insertions(+), 105 deletions(-)

diff --git a/Documentation/devicetree/bindings/media/samsung-fimc.txt b/Documentation/devicetree/bindings/media/samsung-fimc.txt
index 9f4d295..daf145d 100644
--- a/Documentation/devicetree/bindings/media/samsung-fimc.txt
+++ b/Documentation/devicetree/bindings/media/samsung-fimc.txt
@@ -106,8 +106,8 @@ Image sensor nodes
 The sensor device nodes should be added to their control bus controller (e.g.
 I2C0) nodes and linked to a port node in the csis or the parallel-ports node,
 using the common video interfaces bindings, defined in video-interfaces.txt.
-The implementation of this bindings requires clock-frequency property to be
-present in the sensor device nodes.
+An optional clock-frequency property needs to be present in the sensor device
+nodes. Default value when this property is not present is 24 MHz.
 
 Example:
 
diff --git a/drivers/media/platform/exynos4-is/media-dev.c b/drivers/media/platform/exynos4-is/media-dev.c
index 6fba5f6..c10dee2 100644
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
@@ -381,77 +383,18 @@ static void fimc_md_unregister_sensor(struct v4l2_subdev *sd)
 	struct i2c_client *client = v4l2_get_subdevdata(sd);
 	struct i2c_adapter *adapter;
 
-	if (!client)
+	if (!client || client->dev.of_node)
 		return;
 
 	v4l2_device_unregister_subdev(sd);
 
-	if (!client->dev.of_node) {
-		adapter = client->adapter;
-		i2c_unregister_device(client);
-		if (adapter)
-			i2c_put_adapter(adapter);
-	}
+	adapter = client->adapter;
+	i2c_unregister_device(client);
+	if (adapter)
+		i2c_put_adapter(adapter);
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
@@ -460,7 +403,6 @@ static int fimc_md_parse_port_node(struct fimc_md *fmd,
 	struct device_node *rem, *ep, *np;
 	struct fimc_source_info *pd;
 	struct v4l2_of_endpoint endpoint;
-	int ret;
 	u32 val;
 
 	pd = &fmd->sensor[index].pdata;
@@ -488,6 +430,8 @@ static int fimc_md_parse_port_node(struct fimc_md *fmd,
 
 	if (!of_property_read_u32(rem, "clock-frequency", &val))
 		pd->clk_frequency = val;
+	else
+		pd->clk_frequency = DEFAULT_SENSOR_CLK_FREQ;
 
 	if (pd->clk_frequency == 0) {
 		v4l2_err(&fmd->v4l2_dev, "Wrong clock frequency at node %s\n",
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
@@ -886,11 +837,13 @@ static void fimc_md_unregister_entities(struct fimc_md *fmd)
 		v4l2_device_unregister_subdev(fmd->csis[i].sd);
 		fmd->csis[i].sd = NULL;
 	}
-	for (i = 0; i < fmd->num_sensors; i++) {
-		if (fmd->sensor[i].subdev == NULL)
-			continue;
-		fimc_md_unregister_sensor(fmd->sensor[i].subdev);
-		fmd->sensor[i].subdev = NULL;
+	if (fmd->pdev->dev.of_node == NULL) {
+		for (i = 0; i < fmd->num_sensors; i++) {
+			if (fmd->sensor[i].subdev == NULL)
+				continue;
+			fimc_md_unregister_sensor(fmd->sensor[i].subdev);
+			fmd->sensor[i].subdev = NULL;
+		}
 	}
 
 	if (fmd->fimc_is)
@@ -1225,6 +1178,14 @@ static int __fimc_md_set_camclk(struct fimc_md *fmd,
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
 
@@ -1542,6 +1503,56 @@ err:
 #define fimc_md_unregister_clk_provider(fmd) (0)
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
@@ -1569,12 +1580,6 @@ static int fimc_md_probe(struct platform_device *pdev)
 
 	fmd->use_isp = fimc_md_is_isp_available(dev->of_node);
 
-	ret = fimc_md_register_clk_provider(fmd);
-	if (ret < 0) {
-		v4l2_err(v4l2_dev, "clock provider registration failed\n");
-		return ret;
-	}
-
 	ret = v4l2_device_register(dev, &fmd->v4l2_dev);
 	if (ret < 0) {
 		v4l2_err(v4l2_dev, "Failed to register v4l2_device: %d\n", ret);
@@ -1584,64 +1589,86 @@ static int fimc_md_probe(struct platform_device *pdev)
 	ret = media_device_register(&fmd->media_dev);
 	if (ret < 0) {
 		v4l2_err(v4l2_dev, "Failed to register media device: %d\n", ret);
-		goto err_md;
+		goto err_v4l2_dev;
 	}
 
 	ret = fimc_md_get_clocks(fmd);
 	if (ret)
-		goto err_clk;
+		goto err_md;
 
 	fmd->user_subdev_api = (dev->of_node != NULL);
 
-	/* Protect the media graph while we're registering entities */
-	mutex_lock(&fmd->media_dev.graph_mutex);
-
 	ret = fimc_md_get_pinctrl(fmd);
 	if (ret < 0) {
 		if (ret != EPROBE_DEFER)
 			dev_err(dev, "Failed to get pinctrl: %d\n", ret);
-		goto err_unlock;
+		goto err_clk;
 	}
 
+	platform_set_drvdata(pdev, fmd);
+
+	/* Protect the media graph while we're registering entities */
+	mutex_lock(&fmd->media_dev.graph_mutex);
+
 	if (dev->of_node)
 		ret = fimc_md_register_of_platform_entities(fmd, dev->of_node);
 	else
 		ret = bus_for_each_dev(&platform_bus_type, NULL, fmd,
 						fimc_md_pdev_match);
-	if (ret)
-		goto err_unlock;
+	if (ret) {
+		mutex_unlock(&fmd->media_dev.graph_mutex);
+		goto err_clk;
+	}
 
 	if (dev->platform_data || dev->of_node) {
 		ret = fimc_md_register_sensor_entities(fmd);
-		if (ret)
-			goto err_unlock;
+		if (ret) {
+			mutex_unlock(&fmd->media_dev.graph_mutex);
+			goto err_m_ent;
+		}
 	}
 
-	ret = fimc_md_create_links(fmd);
-	if (ret)
-		goto err_unlock;
+	mutex_unlock(&fmd->media_dev.graph_mutex);
 
-	ret = v4l2_device_register_subdev_nodes(&fmd->v4l2_dev);
+	ret = device_create_file(&pdev->dev, &dev_attr_subdev_conf_mode);
 	if (ret)
-		goto err_unlock;
+		goto err_m_ent;
+	/*
+	 * FIMC platform devices need to be registered before the sclk_cam
+	 * clocks provider, as one of these devices needs to be activated
+	 * to enable the clock.
+	 */
+	ret = fimc_md_register_clk_provider(fmd);
+	if (ret < 0) {
+		v4l2_err(v4l2_dev, "clock provider registration failed\n");
+		goto err_attr;
+	}
 
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
+		goto err_clk_p;
 
-	platform_set_drvdata(pdev, fmd);
-	mutex_unlock(&fmd->media_dev.graph_mutex);
 	return 0;
 
-err_unlock:
-	mutex_unlock(&fmd->media_dev.graph_mutex);
+err_clk_p:
+	fimc_md_unregister_clk_provider(fmd);
+err_attr:
+	device_remove_file(&pdev->dev, &dev_attr_subdev_conf_mode);
 err_clk:
 	fimc_md_put_clocks(fmd);
+err_m_ent:
 	fimc_md_unregister_entities(fmd);
-	media_device_unregister(&fmd->media_dev);
 err_md:
+	media_device_unregister(&fmd->media_dev);
+err_v4l2_dev:
 	v4l2_device_unregister(&fmd->v4l2_dev);
-	fimc_md_unregister_clk_provider(fmd);
 	return ret;
 }
 
@@ -1653,12 +1680,15 @@ static int fimc_md_remove(struct platform_device *pdev)
 		return 0;
 
 	fimc_md_unregister_clk_provider(fmd);
+	v4l2_async_notifier_unregister(&fmd->subdev_notifier);
+
 	v4l2_device_unregister(&fmd->v4l2_dev);
 	device_remove_file(&pdev->dev, &dev_attr_subdev_conf_mode);
 	fimc_md_unregister_entities(fmd);
 	fimc_md_pipelines_free(fmd);
 	media_device_unregister(&fmd->media_dev);
 	fimc_md_put_clocks(fmd);
+
 	return 0;
 }
 
diff --git a/drivers/media/platform/exynos4-is/media-dev.h b/drivers/media/platform/exynos4-is/media-dev.h
index 240ca71..169972a 100644
--- a/drivers/media/platform/exynos4-is/media-dev.h
+++ b/drivers/media/platform/exynos4-is/media-dev.h
@@ -32,8 +32,9 @@
 
 #define PINCTRL_STATE_IDLE	"idle"
 
-#define FIMC_MAX_SENSORS	8
+#define FIMC_MAX_SENSORS	4
 #define FIMC_MAX_CAMCLKS	2
+#define DEFAULT_SENSOR_CLK_FREQ	24000000U
 
 /* LCD/ISP Writeback clocks (PIXELASYNCMx) */
 enum {
@@ -79,6 +80,7 @@ struct fimc_camclk_info {
 /**
  * struct fimc_sensor_info - image data source subdev information
  * @pdata: sensor's atrributes passed as media device's platform data
+ * @asd: asynchronous subdev registration data structure
  * @subdev: image sensor v4l2 subdev
  * @host: fimc device the sensor is currently linked to
  *
@@ -86,6 +88,7 @@ struct fimc_camclk_info {
  */
 struct fimc_sensor_info {
 	struct fimc_source_info pdata;
+	struct v4l2_async_subdev asd;
 	struct v4l2_subdev *subdev;
 	struct fimc_dev *host;
 };
@@ -144,6 +147,9 @@ struct fimc_md {
 		struct cam_clk camclk[FIMC_MAX_CAMCLKS];
 	} clk_provider;
 
+	struct v4l2_async_notifier subdev_notifier;
+	struct v4l2_async_subdev *async_subdevs[FIMC_MAX_SENSORS];
+
 	bool user_subdev_api;
 	spinlock_t slock;
 	struct list_head pipelines;
@@ -161,6 +167,11 @@ static inline struct fimc_md *entity_to_fimc_mdev(struct media_entity *me)
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

