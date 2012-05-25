Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.w1.samsung.com ([210.118.77.11]:46844 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932866Ab2EYTxM (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 25 May 2012 15:53:12 -0400
Date: Fri, 25 May 2012 21:52:51 +0200
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [RFC/PATCH 12/13] media: s5p-fimc: Add device tree based sensors
 registration
In-reply-to: <1337975573-27117-1-git-send-email-s.nawrocki@samsung.com>
To: linux-media@vger.kernel.org
Cc: kyungmin.park@samsung.com, m.szyprowski@samsung.com,
	riverful.kim@samsung.com, sw0312.kim@samsung.com,
	s.nawrocki@samsung.com, devicetree-discuss@lists.ozlabs.org,
	linux-samsung-soc@vger.kernel.org, b.zolnierkie@samsung.com
Message-id: <1337975573-27117-12-git-send-email-s.nawrocki@samsung.com>
Content-transfer-encoding: 7BIT
References: <4FBFE1EC.9060209@samsung.com>
 <1337975573-27117-1-git-send-email-s.nawrocki@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add parsing of 'sensor' nodes specified as 'camera' child nodes.
Each 'sensor' node should contain a phandle indicating sensor I2C
client device. Sensors with SPI control bus are not yet supported.

Additionally it is required that the I2C client node (child node
of I2C bus controller node) contains 'clock-frequency' and
'video-bus-type' properties. These properties allow the host
controller to switch to proper video bus and set proper master
clock frequency for a sensor.

Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---

We might need something like this as a V4L2 core function.
But I wanted to have something settled first until proposing
any addtions to the V4L2 core modules.
---
 .../bindings/camera/soc/samsung-fimc.txt           |   22 ++++
 drivers/media/video/s5p-fimc/fimc-mdevice.c        |  114 +++++++++++++++++++-
 2 files changed, 133 insertions(+), 3 deletions(-)

diff --git a/Documentation/devicetree/bindings/camera/soc/samsung-fimc.txt b/Documentation/devicetree/bindings/camera/soc/samsung-fimc.txt
index b459da2..ffe09ac 100644
--- a/Documentation/devicetree/bindings/camera/soc/samsung-fimc.txt
+++ b/Documentation/devicetree/bindings/camera/soc/samsung-fimc.txt
@@ -54,6 +54,28 @@ Required properties:
 - cell-index : FIMC-LITE IP instance index;
 
 
+The 'sensor' nodes
+------------------
+
+Required properties:
+
+ - i2c-client : a phandle to an image sensor I2C client device;
+
+Optional properties:
+
+- samsung,camif-mux-id : FIMC video multiplexer input index; for camera
+			 port A, B, C the indexes are 0, 1, 0 respectively.
+			 If this property is not specified a default 0
+			 value will be used by driver.
+
+- samsung,fimc-camclk-id : the SoC CAM_MCLK clock output index. These clocks
+			   are master clocks for external image processors.
+			   If this property is not specified a default 0 value
+			   will be used by driver.
+
+ "video-bus-type" and "clock-frequency" properties must be specified at the
+ node referenced by 'i2c-client' phandle.
+
 Example:
 
 	fimc0: fimc@11800000 {
diff --git a/drivers/media/video/s5p-fimc/fimc-mdevice.c b/drivers/media/video/s5p-fimc/fimc-mdevice.c
index 1b3b13c..faf5665 100644
--- a/drivers/media/video/s5p-fimc/fimc-mdevice.c
+++ b/drivers/media/video/s5p-fimc/fimc-mdevice.c
@@ -19,6 +19,9 @@
 #include <linux/module.h>
 #include <linux/of.h>
 #include <linux/of_platform.h>
+#include <linux/of_device.h>
+#include <linux/of_gpio.h>
+#include <linux/of_i2c.h>
 #include <linux/platform_device.h>
 #include <linux/pm_runtime.h>
 #include <linux/types.h>
@@ -278,10 +281,109 @@ static void fimc_md_unregister_sensor(struct v4l2_subdev *sd)
 	v4l2_device_unregister_subdev(sd);
 	adapter = client->adapter;
 	i2c_unregister_device(client);
-	if (adapter)
+	if (adapter && client->dev.of_node == NULL)
 		i2c_put_adapter(adapter);
 }
 
+#ifdef CONFIG_OF
+static struct v4l2_subdev *fimc_md_create_sensor_subdev(struct fimc_md *fmd,
+						struct i2c_client *client,
+						struct fimc_sensor_info *sensor)
+{
+	struct v4l2_subdev *sd;
+	int ret;
+
+	if (!client->driver)
+		return ERR_PTR(-EAGAIN);
+
+	if (!try_module_get(client->driver->driver.owner))
+		return ERR_PTR(-EAGAIN);
+
+	/* Enable sensor's master clock */
+	ret = __fimc_md_set_camclk(fmd, sensor, true);
+	if (ret < 0)
+		return ERR_PTR(ret);
+
+	sd = i2c_get_clientdata(client);
+
+	ret = v4l2_device_register_subdev(&fmd->v4l2_dev, sd);
+	module_put(client->driver->driver.owner);
+	__fimc_md_set_camclk(fmd, sensor, false);
+	if (ret)
+		return ERR_PTR(ret);
+
+	v4l2_set_subdev_hostdata(sd, sensor);
+	sd->grp_id = SENSOR_GROUP_ID;
+	v4l2_info(&fmd->v4l2_dev, "Registered sensor subdevice: %s\n",
+		  sd->name);
+
+	return sd;
+}
+
+static int fimc_md_of_sensors_register(struct fimc_md *fmd,
+				       struct device_node *np)
+{
+	struct device_node *i2c_node, *node = NULL;
+	struct s5p_fimc_isp_info *pdata;
+	struct fimc_sensor_info *sensor;
+	int ret, sensor_index = 0;
+	const char *bt;
+	u32 id, freq;
+
+	for_each_child_of_node(np, node) {
+		struct i2c_client *client = NULL;
+		struct v4l2_subdev *sd;
+
+		sensor = &fmd->sensor[sensor_index];
+		pdata = &sensor->pdata;
+
+		i2c_node = of_parse_phandle(node, "i2c-client", 0);
+		if (i2c_node)
+			client = of_find_i2c_device_by_node(i2c_node);
+		if (client == NULL) {
+			of_node_put(i2c_node);
+			return -EPROBE_DEFER;
+		}
+
+		ret = of_property_read_u32(node, "samsung,fimc-camclk-id", &id);
+		pdata->clk_id = ret ? 0 : id;
+
+		ret = of_property_read_u32(i2c_node, "clock-frequency", &freq);
+		pdata->clk_frequency = ret ? 12000000UL : freq;
+
+		ret = of_property_read_u32(node, "samsung,fimc-mux-id", &id);
+		pdata->mux_id = ret ? 0 : id;
+
+		if(!of_property_read_string(node, "video-bus-type", &bt)) {
+			if (!strcmp(bt, "itu-601"))
+				pdata->bus_type = FIMC_ITU_601;
+			else if (!strcmp(bt, "mipi-csi2"))
+				pdata->bus_type = FIMC_MIPI_CSI2;
+			else if (!strcmp(bt, "itu-656"))
+				pdata->bus_type = FIMC_ITU_656;
+		}
+
+		of_node_put(node);
+		put_device(&client->dev);
+		if (WARN_ON(pdata->bus_type == 0))
+			continue;
+
+		sd = fimc_md_create_sensor_subdev(fmd, client, sensor);
+
+		if (IS_ERR(sd)) {
+			sensor->subdev = NULL;
+			return PTR_ERR(sd);
+		}
+
+		sensor->subdev = sd;
+		sensor_index++;
+
+		fmd->num_sensors++;
+	}
+	return 0;
+}
+#endif /* CONFIG_OF */
+
 static int fimc_md_register_sensor_entities(struct fimc_md *fmd)
 {
 	struct s5p_platform_fimc *pdata = fmd->pdev->dev.platform_data;
@@ -300,7 +402,13 @@ static int fimc_md_register_sensor_entities(struct fimc_md *fmd)
 	ret = pm_runtime_get_sync(&fd->pdev->dev);
 	if (ret < 0)
 		return ret;
-
+#ifdef CONFIG_OF
+	if (fmd->pdev->dev.of_node) {
+		ret = fimc_md_of_sensors_register(fmd, fmd->pdev->dev.of_node);
+		pm_runtime_put(&fd->pdev->dev);
+		return ret;
+	}
+#endif
 	WARN_ON(pdata->num_clients > ARRAY_SIZE(fmd->sensor));
 	num_clients = min_t(u32, pdata->num_clients, ARRAY_SIZE(fmd->sensor));
 
@@ -1047,7 +1155,7 @@ static int fimc_md_probe(struct platform_device *pdev)
 	if (ret)
 		goto err_unlock;
 
-	if (pdev->dev.platform_data) {
+	if (pdev->dev.platform_data || pdev->dev.of_node) {
 		ret = fimc_md_register_sensor_entities(fmd);
 		if (ret)
 			goto err_unlock;
-- 
1.7.10

