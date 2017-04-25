Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga07.intel.com ([134.134.136.100]:62638 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1428438AbdDYL5E (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 25 Apr 2017 07:57:04 -0400
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Cc: linux-acpi@vger.kernel.org, devicetree@vger.kernel.org,
        laurent.pinchart@ideasonboard.com, hverkuil@xs4all.nl
Subject: [PATCH v3.1 4/7] v4l: Switch from V4L2 OF not V4L2 fwnode API
Date: Tue, 25 Apr 2017 14:56:14 +0300
Message-Id: <1493121374-13298-1-git-send-email-sakari.ailus@linux.intel.com>
In-Reply-To: <1491829376-14791-5-git-send-email-sakari.ailus@linux.intel.com>
References: <1491829376-14791-5-git-send-email-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Switch users of the v4l2_of_ APIs to the more generic v4l2_fwnode_ APIs.
Async OF matching is replaced by fwnode matching and OF matching support
is removed.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Acked-by: Benoit Parrot <bparrot@ti.com> # i2c/ov2569.c, am437x/am437x-vpfe.c and ti-vpe/cal.c
Tested-by: Hans Verkuil <hans.verkuil@cisco.com> # Atmel sama5d3 board + ov2640 sensor
---
 drivers/media/i2c/Kconfig                      | 11 +++++
 drivers/media/i2c/adv7604.c                    |  7 +--
 drivers/media/i2c/mt9v032.c                    |  7 +--
 drivers/media/i2c/ov2659.c                     |  8 ++--
 drivers/media/i2c/ov5645.c                     |  7 +--
 drivers/media/i2c/ov5647.c                     |  7 +--
 drivers/media/i2c/s5c73m3/s5c73m3-core.c       |  7 +--
 drivers/media/i2c/s5k5baf.c                    |  6 +--
 drivers/media/i2c/smiapp/Kconfig               |  1 +
 drivers/media/i2c/smiapp/smiapp-core.c         | 29 ++++++------
 drivers/media/i2c/tc358743.c                   | 11 +++--
 drivers/media/i2c/tvp514x.c                    |  6 +--
 drivers/media/i2c/tvp5150.c                    |  7 +--
 drivers/media/i2c/tvp7002.c                    |  6 +--
 drivers/media/platform/Kconfig                 |  3 ++
 drivers/media/platform/am437x/Kconfig          |  1 +
 drivers/media/platform/am437x/am437x-vpfe.c    | 15 +++---
 drivers/media/platform/atmel/Kconfig           |  2 +
 drivers/media/platform/atmel/atmel-isc.c       | 13 ++++--
 drivers/media/platform/atmel/atmel-isi.c       | 11 +++--
 drivers/media/platform/exynos4-is/Kconfig      |  2 +
 drivers/media/platform/exynos4-is/media-dev.c  | 13 +++---
 drivers/media/platform/exynos4-is/mipi-csis.c  |  6 +--
 drivers/media/platform/omap3isp/isp.c          | 49 ++++++++++----------
 drivers/media/platform/pxa_camera.c            | 11 +++--
 drivers/media/platform/rcar-vin/Kconfig        |  1 +
 drivers/media/platform/rcar-vin/rcar-core.c    | 19 ++++----
 drivers/media/platform/soc_camera/soc_camera.c |  7 +--
 drivers/media/platform/ti-vpe/cal.c            | 15 +++---
 drivers/media/platform/xilinx/Kconfig          |  1 +
 drivers/media/platform/xilinx/xilinx-vipp.c    | 63 ++++++++++++++------------
 drivers/media/v4l2-core/v4l2-async.c           | 14 +-----
 include/media/v4l2-async.h                     |  5 --
 33 files changed, 204 insertions(+), 167 deletions(-)

diff --git a/drivers/media/i2c/Kconfig b/drivers/media/i2c/Kconfig
index b358d1a..aeb7485 100644
--- a/drivers/media/i2c/Kconfig
+++ b/drivers/media/i2c/Kconfig
@@ -210,6 +210,7 @@ config VIDEO_ADV7604
 	depends on GPIOLIB || COMPILE_TEST
 	select HDMI
 	select MEDIA_CEC_EDID
+	select V4L2_FWNODE
 	---help---
 	  Support for the Analog Devices ADV7604 video decoder.
 
@@ -324,6 +325,7 @@ config VIDEO_TC358743
 	tristate "Toshiba TC358743 decoder"
 	depends on VIDEO_V4L2 && I2C && VIDEO_V4L2_SUBDEV_API
 	select HDMI
+	select V4L2_FWNODE
 	---help---
 	  Support for the Toshiba TC358743 HDMI to MIPI CSI-2 bridge.
 
@@ -333,6 +335,7 @@ config VIDEO_TC358743
 config VIDEO_TVP514X
 	tristate "Texas Instruments TVP514x video decoder"
 	depends on VIDEO_V4L2 && I2C
+	select V4L2_FWNODE
 	---help---
 	  This is a Video4Linux2 sensor-level driver for the TI TVP5146/47
 	  decoder. It is currently working with the TI OMAP3 camera
@@ -344,6 +347,7 @@ config VIDEO_TVP514X
 config VIDEO_TVP5150
 	tristate "Texas Instruments TVP5150 video decoder"
 	depends on VIDEO_V4L2 && I2C
+	select V4L2_FWNODE
 	---help---
 	  Support for the Texas Instruments TVP5150 video decoder.
 
@@ -353,6 +357,7 @@ config VIDEO_TVP5150
 config VIDEO_TVP7002
 	tristate "Texas Instruments TVP7002 video decoder"
 	depends on VIDEO_V4L2 && I2C
+	select V4L2_FWNODE
 	---help---
 	  Support for the Texas Instruments TVP7002 video decoder.
 
@@ -535,6 +540,7 @@ config VIDEO_OV2659
 	tristate "OmniVision OV2659 sensor support"
 	depends on VIDEO_V4L2 && I2C
 	depends on MEDIA_CAMERA_SUPPORT
+	select V4L2_FWNODE
 	---help---
 	  This is a Video4Linux2 sensor-level driver for the OmniVision
 	  OV2659 camera.
@@ -547,6 +553,7 @@ config VIDEO_OV5645
 	depends on OF
 	depends on I2C && VIDEO_V4L2 && VIDEO_V4L2_SUBDEV_API
 	depends on MEDIA_CAMERA_SUPPORT
+	select V4L2_FWNODE
 	---help---
 	  This is a Video4Linux2 sensor-level driver for the OmniVision
 	  OV5645 camera.
@@ -558,6 +565,7 @@ config VIDEO_OV5647
 	tristate "OmniVision OV5647 sensor support"
 	depends on I2C && VIDEO_V4L2 && VIDEO_V4L2_SUBDEV_API
 	depends on MEDIA_CAMERA_SUPPORT
+	select V4L2_FWNODE
 	---help---
 	  This is a Video4Linux2 sensor-level driver for the OmniVision
 	  OV5647 camera.
@@ -650,6 +658,7 @@ config VIDEO_MT9V032
 	depends on I2C && VIDEO_V4L2 && VIDEO_V4L2_SUBDEV_API
 	depends on MEDIA_CAMERA_SUPPORT
 	select REGMAP_I2C
+	select V4L2_FWNODE
 	---help---
 	  This is a Video4Linux2 sensor-level driver for the Micron
 	  MT9V032 752x480 CMOS sensor.
@@ -697,6 +706,7 @@ config VIDEO_S5K4ECGX
 config VIDEO_S5K5BAF
 	tristate "Samsung S5K5BAF sensor support"
 	depends on I2C && VIDEO_V4L2 && VIDEO_V4L2_SUBDEV_API
+	select V4L2_FWNODE
 	---help---
 	  This is a V4L2 sensor-level driver for Samsung S5K5BAF 2M
 	  camera sensor with an embedded SoC image signal processor.
@@ -707,6 +717,7 @@ source "drivers/media/i2c/et8ek8/Kconfig"
 config VIDEO_S5C73M3
 	tristate "Samsung S5C73M3 sensor support"
 	depends on I2C && SPI && VIDEO_V4L2 && VIDEO_V4L2_SUBDEV_API
+	select V4L2_FWNODE
 	---help---
 	  This is a V4L2 sensor-level driver for Samsung S5C73M3
 	  8 Mpixel camera.
diff --git a/drivers/media/i2c/adv7604.c b/drivers/media/i2c/adv7604.c
index f1fa9ce..660bacb 100644
--- a/drivers/media/i2c/adv7604.c
+++ b/drivers/media/i2c/adv7604.c
@@ -33,6 +33,7 @@
 #include <linux/i2c.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
+#include <linux/of_graph.h>
 #include <linux/slab.h>
 #include <linux/v4l2-dv-timings.h>
 #include <linux/videodev2.h>
@@ -45,7 +46,7 @@
 #include <media/v4l2-device.h>
 #include <media/v4l2-event.h>
 #include <media/v4l2-dv-timings.h>
-#include <media/v4l2-of.h>
+#include <media/v4l2-fwnode.h>
 
 static int debug;
 module_param(debug, int, 0644);
@@ -3069,7 +3070,7 @@ MODULE_DEVICE_TABLE(of, adv76xx_of_id);
 
 static int adv76xx_parse_dt(struct adv76xx_state *state)
 {
-	struct v4l2_of_endpoint bus_cfg;
+	struct v4l2_fwnode_endpoint bus_cfg;
 	struct device_node *endpoint;
 	struct device_node *np;
 	unsigned int flags;
@@ -3083,7 +3084,7 @@ static int adv76xx_parse_dt(struct adv76xx_state *state)
 	if (!endpoint)
 		return -EINVAL;
 
-	ret = v4l2_of_parse_endpoint(endpoint, &bus_cfg);
+	ret = v4l2_fwnode_endpoint_parse(of_fwnode_handle(endpoint), &bus_cfg);
 	if (ret) {
 		of_node_put(endpoint);
 		return ret;
diff --git a/drivers/media/i2c/mt9v032.c b/drivers/media/i2c/mt9v032.c
index 2e7a6e6..8a43064 100644
--- a/drivers/media/i2c/mt9v032.c
+++ b/drivers/media/i2c/mt9v032.c
@@ -19,6 +19,7 @@
 #include <linux/log2.h>
 #include <linux/mutex.h>
 #include <linux/of.h>
+#include <linux/of_graph.h>
 #include <linux/regmap.h>
 #include <linux/slab.h>
 #include <linux/videodev2.h>
@@ -28,7 +29,7 @@
 #include <media/i2c/mt9v032.h>
 #include <media/v4l2-ctrls.h>
 #include <media/v4l2-device.h>
-#include <media/v4l2-of.h>
+#include <media/v4l2-fwnode.h>
 #include <media/v4l2-subdev.h>
 
 /* The first four rows are black rows. The active area spans 753x481 pixels. */
@@ -979,7 +980,7 @@ static struct mt9v032_platform_data *
 mt9v032_get_pdata(struct i2c_client *client)
 {
 	struct mt9v032_platform_data *pdata = NULL;
-	struct v4l2_of_endpoint endpoint;
+	struct v4l2_fwnode_endpoint endpoint;
 	struct device_node *np;
 	struct property *prop;
 
@@ -990,7 +991,7 @@ mt9v032_get_pdata(struct i2c_client *client)
 	if (!np)
 		return NULL;
 
-	if (v4l2_of_parse_endpoint(np, &endpoint) < 0)
+	if (v4l2_fwnode_endpoint_parse(of_fwnode_handle(np), &endpoint) < 0)
 		goto done;
 
 	pdata = devm_kzalloc(&client->dev, sizeof(*pdata), GFP_KERNEL);
diff --git a/drivers/media/i2c/ov2659.c b/drivers/media/i2c/ov2659.c
index 6e63672..545ca3f 100644
--- a/drivers/media/i2c/ov2659.c
+++ b/drivers/media/i2c/ov2659.c
@@ -42,9 +42,9 @@
 #include <media/v4l2-ctrls.h>
 #include <media/v4l2-device.h>
 #include <media/v4l2-event.h>
+#include <media/v4l2-fwnode.h>
 #include <media/v4l2-image-sizes.h>
 #include <media/v4l2-mediabus.h>
-#include <media/v4l2-of.h>
 #include <media/v4l2-subdev.h>
 
 #define DRIVER_NAME "ov2659"
@@ -1346,7 +1346,7 @@ static struct ov2659_platform_data *
 ov2659_get_pdata(struct i2c_client *client)
 {
 	struct ov2659_platform_data *pdata;
-	struct v4l2_of_endpoint *bus_cfg;
+	struct v4l2_fwnode_endpoint *bus_cfg;
 	struct device_node *endpoint;
 
 	if (!IS_ENABLED(CONFIG_OF) || !client->dev.of_node)
@@ -1356,7 +1356,7 @@ ov2659_get_pdata(struct i2c_client *client)
 	if (!endpoint)
 		return NULL;
 
-	bus_cfg = v4l2_of_alloc_parse_endpoint(endpoint);
+	bus_cfg = v4l2_fwnode_endpoint_alloc_parse(of_fwnode_handle(endpoint));
 	if (IS_ERR(bus_cfg)) {
 		pdata = NULL;
 		goto done;
@@ -1376,7 +1376,7 @@ ov2659_get_pdata(struct i2c_client *client)
 	pdata->link_frequency = bus_cfg->link_frequencies[0];
 
 done:
-	v4l2_of_free_endpoint(bus_cfg);
+	v4l2_fwnode_endpoint_free(bus_cfg);
 	of_node_put(endpoint);
 	return pdata;
 }
diff --git a/drivers/media/i2c/ov5645.c b/drivers/media/i2c/ov5645.c
index 57bd591..d1e844f 100644
--- a/drivers/media/i2c/ov5645.c
+++ b/drivers/media/i2c/ov5645.c
@@ -39,7 +39,7 @@
 #include <linux/slab.h>
 #include <linux/types.h>
 #include <media/v4l2-ctrls.h>
-#include <media/v4l2-of.h>
+#include <media/v4l2-fwnode.h>
 #include <media/v4l2-subdev.h>
 
 #define OV5645_VOLTAGE_ANALOG               2800000
@@ -87,7 +87,7 @@ struct ov5645 {
 	struct device *dev;
 	struct v4l2_subdev sd;
 	struct media_pad pad;
-	struct v4l2_of_endpoint ep;
+	struct v4l2_fwnode_endpoint ep;
 	struct v4l2_mbus_framefmt fmt;
 	struct v4l2_rect crop;
 	struct clk *xclk;
@@ -1102,7 +1102,8 @@ static int ov5645_probe(struct i2c_client *client,
 		return -EINVAL;
 	}
 
-	ret = v4l2_of_parse_endpoint(endpoint, &ov5645->ep);
+	ret = v4l2_fwnode_endpoint_parse(of_fwnode_handle(endpoint),
+					 &ov5645->ep);
 	if (ret < 0) {
 		dev_err(dev, "parsing endpoint node failed\n");
 		return ret;
diff --git a/drivers/media/i2c/ov5647.c b/drivers/media/i2c/ov5647.c
index f57a0b3..95ce90f 100644
--- a/drivers/media/i2c/ov5647.c
+++ b/drivers/media/i2c/ov5647.c
@@ -25,12 +25,13 @@
 #include <linux/init.h>
 #include <linux/io.h>
 #include <linux/module.h>
+#include <linux/of_graph.h>
 #include <linux/slab.h>
 #include <linux/videodev2.h>
 #include <media/v4l2-device.h>
+#include <media/v4l2-fwnode.h>
 #include <media/v4l2-image-sizes.h>
 #include <media/v4l2-mediabus.h>
-#include <media/v4l2-of.h>
 
 #define SENSOR_NAME "ov5647"
 
@@ -510,7 +511,7 @@ static const struct v4l2_subdev_internal_ops ov5647_subdev_internal_ops = {
 
 static int ov5647_parse_dt(struct device_node *np)
 {
-	struct v4l2_of_endpoint bus_cfg;
+	struct v4l2_fwnode_endpoint bus_cfg;
 	struct device_node *ep;
 
 	int ret;
@@ -519,7 +520,7 @@ static int ov5647_parse_dt(struct device_node *np)
 	if (!ep)
 		return -EINVAL;
 
-	ret = v4l2_of_parse_endpoint(ep, &bus_cfg);
+	ret = v4l2_fwnode_endpoint_parse(of_fwnode_handle(ep), &bus_cfg);
 
 	of_node_put(ep);
 	return ret;
diff --git a/drivers/media/i2c/s5c73m3/s5c73m3-core.c b/drivers/media/i2c/s5c73m3/s5c73m3-core.c
index 3844853..f434fb2 100644
--- a/drivers/media/i2c/s5c73m3/s5c73m3-core.c
+++ b/drivers/media/i2c/s5c73m3/s5c73m3-core.c
@@ -24,6 +24,7 @@
 #include <linux/media.h>
 #include <linux/module.h>
 #include <linux/of_gpio.h>
+#include <linux/of_graph.h>
 #include <linux/regulator/consumer.h>
 #include <linux/sizes.h>
 #include <linux/slab.h>
@@ -35,7 +36,7 @@
 #include <media/v4l2-subdev.h>
 #include <media/v4l2-mediabus.h>
 #include <media/i2c/s5c73m3.h>
-#include <media/v4l2-of.h>
+#include <media/v4l2-fwnode.h>
 
 #include "s5c73m3.h"
 
@@ -1602,7 +1603,7 @@ static int s5c73m3_get_platform_data(struct s5c73m3 *state)
 	const struct s5c73m3_platform_data *pdata = dev->platform_data;
 	struct device_node *node = dev->of_node;
 	struct device_node *node_ep;
-	struct v4l2_of_endpoint ep;
+	struct v4l2_fwnode_endpoint ep;
 	int ret;
 
 	if (!node) {
@@ -1639,7 +1640,7 @@ static int s5c73m3_get_platform_data(struct s5c73m3 *state)
 		return 0;
 	}
 
-	ret = v4l2_of_parse_endpoint(node_ep, &ep);
+	ret = v4l2_fwnode_endpoint_parse(of_fwnode_handle(node_ep), &ep);
 	of_node_put(node_ep);
 	if (ret)
 		return ret;
diff --git a/drivers/media/i2c/s5k5baf.c b/drivers/media/i2c/s5k5baf.c
index db82ed0..962051b 100644
--- a/drivers/media/i2c/s5k5baf.c
+++ b/drivers/media/i2c/s5k5baf.c
@@ -30,7 +30,7 @@
 #include <media/v4l2-device.h>
 #include <media/v4l2-subdev.h>
 #include <media/v4l2-mediabus.h>
-#include <media/v4l2-of.h>
+#include <media/v4l2-fwnode.h>
 
 static int debug;
 module_param(debug, int, 0644);
@@ -1841,7 +1841,7 @@ static int s5k5baf_parse_device_node(struct s5k5baf *state, struct device *dev)
 {
 	struct device_node *node = dev->of_node;
 	struct device_node *node_ep;
-	struct v4l2_of_endpoint ep;
+	struct v4l2_fwnode_endpoint ep;
 	int ret;
 
 	if (!node) {
@@ -1868,7 +1868,7 @@ static int s5k5baf_parse_device_node(struct s5k5baf *state, struct device *dev)
 		return -EINVAL;
 	}
 
-	ret = v4l2_of_parse_endpoint(node_ep, &ep);
+	ret = v4l2_fwnode_endpoint_parse(of_fwnode_handle(node_ep), &ep);
 	of_node_put(node_ep);
 	if (ret)
 		return ret;
diff --git a/drivers/media/i2c/smiapp/Kconfig b/drivers/media/i2c/smiapp/Kconfig
index 3149cda..f59718d 100644
--- a/drivers/media/i2c/smiapp/Kconfig
+++ b/drivers/media/i2c/smiapp/Kconfig
@@ -3,5 +3,6 @@ config VIDEO_SMIAPP
 	depends on I2C && VIDEO_V4L2 && VIDEO_V4L2_SUBDEV_API && HAVE_CLK
 	depends on MEDIA_CAMERA_SUPPORT
 	select VIDEO_SMIAPP_PLL
+	select V4L2_FWNODE
 	---help---
 	  This is a generic driver for SMIA++/SMIA camera modules.
diff --git a/drivers/media/i2c/smiapp/smiapp-core.c b/drivers/media/i2c/smiapp/smiapp-core.c
index f4e92bd..e0b0c03 100644
--- a/drivers/media/i2c/smiapp/smiapp-core.c
+++ b/drivers/media/i2c/smiapp/smiapp-core.c
@@ -27,12 +27,13 @@
 #include <linux/gpio/consumer.h>
 #include <linux/module.h>
 #include <linux/pm_runtime.h>
+#include <linux/property.h>
 #include <linux/regulator/consumer.h>
 #include <linux/slab.h>
 #include <linux/smiapp.h>
 #include <linux/v4l2-mediabus.h>
+#include <media/v4l2-fwnode.h>
 #include <media/v4l2-device.h>
-#include <media/v4l2-of.h>
 
 #include "smiapp.h"
 
@@ -2784,19 +2785,20 @@ static int __maybe_unused smiapp_resume(struct device *dev)
 static struct smiapp_hwconfig *smiapp_get_hwconfig(struct device *dev)
 {
 	struct smiapp_hwconfig *hwcfg;
-	struct v4l2_of_endpoint *bus_cfg;
-	struct device_node *ep;
+	struct v4l2_fwnode_endpoint *bus_cfg;
+	struct fwnode_handle *ep;
+	struct fwnode_handle *fwnode = dev_fwnode(dev);
 	int i;
 	int rval;
 
-	if (!dev->of_node)
+	if (!fwnode)
 		return dev->platform_data;
 
-	ep = of_graph_get_next_endpoint(dev->of_node, NULL);
+	ep = fwnode_graph_get_next_endpoint(fwnode, NULL);
 	if (!ep)
 		return NULL;
 
-	bus_cfg = v4l2_of_alloc_parse_endpoint(ep);
+	bus_cfg = v4l2_fwnode_endpoint_alloc_parse(ep);
 	if (IS_ERR(bus_cfg))
 		goto out_err;
 
@@ -2817,11 +2819,10 @@ static struct smiapp_hwconfig *smiapp_get_hwconfig(struct device *dev)
 	dev_dbg(dev, "lanes %u\n", hwcfg->lanes);
 
 	/* NVM size is not mandatory */
-	of_property_read_u32(dev->of_node, "nokia,nvm-size",
-				    &hwcfg->nvm_size);
+	fwnode_property_read_u32(fwnode, "nokia,nvm-size", &hwcfg->nvm_size);
 
-	rval = of_property_read_u32(dev->of_node, "clock-frequency",
-				    &hwcfg->ext_clk);
+	rval = fwnode_property_read_u32(fwnode, "clock-frequency",
+					&hwcfg->ext_clk);
 	if (rval) {
 		dev_warn(dev, "can't get clock-frequency\n");
 		goto out_err;
@@ -2846,13 +2847,13 @@ static struct smiapp_hwconfig *smiapp_get_hwconfig(struct device *dev)
 		dev_dbg(dev, "freq %d: %lld\n", i, hwcfg->op_sys_clock[i]);
 	}
 
-	v4l2_of_free_endpoint(bus_cfg);
-	of_node_put(ep);
+	v4l2_fwnode_endpoint_free(bus_cfg);
+	fwnode_handle_put(ep);
 	return hwcfg;
 
 out_err:
-	v4l2_of_free_endpoint(bus_cfg);
-	of_node_put(ep);
+	v4l2_fwnode_endpoint_free(bus_cfg);
+	fwnode_handle_put(ep);
 	return NULL;
 }
 
diff --git a/drivers/media/i2c/tc358743.c b/drivers/media/i2c/tc358743.c
index acef4ec..052d164 100644
--- a/drivers/media/i2c/tc358743.c
+++ b/drivers/media/i2c/tc358743.c
@@ -33,6 +33,7 @@
 #include <linux/delay.h>
 #include <linux/gpio/consumer.h>
 #include <linux/interrupt.h>
+#include <linux/of_graph.h>
 #include <linux/videodev2.h>
 #include <linux/workqueue.h>
 #include <linux/v4l2-dv-timings.h>
@@ -41,7 +42,7 @@
 #include <media/v4l2-device.h>
 #include <media/v4l2-ctrls.h>
 #include <media/v4l2-event.h>
-#include <media/v4l2-of.h>
+#include <media/v4l2-fwnode.h>
 #include <media/i2c/tc358743.h>
 
 #include "tc358743_regs.h"
@@ -76,7 +77,7 @@ static const struct v4l2_dv_timings_cap tc358743_timings_cap = {
 
 struct tc358743_state {
 	struct tc358743_platform_data pdata;
-	struct v4l2_of_bus_mipi_csi2 bus;
+	struct v4l2_fwnode_bus_mipi_csi2 bus;
 	struct v4l2_subdev sd;
 	struct media_pad pad;
 	struct v4l2_ctrl_handler hdl;
@@ -1695,7 +1696,7 @@ static void tc358743_gpio_reset(struct tc358743_state *state)
 static int tc358743_probe_of(struct tc358743_state *state)
 {
 	struct device *dev = &state->i2c_client->dev;
-	struct v4l2_of_endpoint *endpoint;
+	struct v4l2_fwnode_endpoint *endpoint;
 	struct device_node *ep;
 	struct clk *refclk;
 	u32 bps_pr_lane;
@@ -1715,7 +1716,7 @@ static int tc358743_probe_of(struct tc358743_state *state)
 		return -EINVAL;
 	}
 
-	endpoint = v4l2_of_alloc_parse_endpoint(ep);
+	endpoint = v4l2_fwnode_endpoint_alloc_parse(of_fwnode_handle(ep));
 	if (IS_ERR(endpoint)) {
 		dev_err(dev, "failed to parse endpoint\n");
 		return PTR_ERR(endpoint);
@@ -1803,7 +1804,7 @@ static int tc358743_probe_of(struct tc358743_state *state)
 disable_clk:
 	clk_disable_unprepare(refclk);
 free_endpoint:
-	v4l2_of_free_endpoint(endpoint);
+	v4l2_fwnode_endpoint_free(endpoint);
 	return ret;
 }
 #else
diff --git a/drivers/media/i2c/tvp514x.c b/drivers/media/i2c/tvp514x.c
index 07853d2..ad2df99 100644
--- a/drivers/media/i2c/tvp514x.c
+++ b/drivers/media/i2c/tvp514x.c
@@ -38,7 +38,7 @@
 #include <media/v4l2-device.h>
 #include <media/v4l2-common.h>
 #include <media/v4l2-mediabus.h>
-#include <media/v4l2-of.h>
+#include <media/v4l2-fwnode.h>
 #include <media/v4l2-ctrls.h>
 #include <media/i2c/tvp514x.h>
 #include <media/media-entity.h>
@@ -998,7 +998,7 @@ static struct tvp514x_platform_data *
 tvp514x_get_pdata(struct i2c_client *client)
 {
 	struct tvp514x_platform_data *pdata = NULL;
-	struct v4l2_of_endpoint bus_cfg;
+	struct v4l2_fwnode_endpoint bus_cfg;
 	struct device_node *endpoint;
 	unsigned int flags;
 
@@ -1009,7 +1009,7 @@ tvp514x_get_pdata(struct i2c_client *client)
 	if (!endpoint)
 		return NULL;
 
-	if (v4l2_of_parse_endpoint(endpoint, &bus_cfg))
+	if (v4l2_fwnode_endpoint_parse(of_fwnode_handle(endpoint), &bus_cfg))
 		goto done;
 
 	pdata = devm_kzalloc(&client->dev, sizeof(*pdata), GFP_KERNEL);
diff --git a/drivers/media/i2c/tvp5150.c b/drivers/media/i2c/tvp5150.c
index 04e96b3..9da4bf4 100644
--- a/drivers/media/i2c/tvp5150.c
+++ b/drivers/media/i2c/tvp5150.c
@@ -12,10 +12,11 @@
 #include <linux/delay.h>
 #include <linux/gpio/consumer.h>
 #include <linux/module.h>
+#include <linux/of_graph.h>
 #include <media/v4l2-async.h>
 #include <media/v4l2-device.h>
 #include <media/v4l2-ctrls.h>
-#include <media/v4l2-of.h>
+#include <media/v4l2-fwnode.h>
 #include <media/v4l2-mc.h>
 
 #include "tvp5150_reg.h"
@@ -1358,7 +1359,7 @@ static int tvp5150_init(struct i2c_client *c)
 
 static int tvp5150_parse_dt(struct tvp5150 *decoder, struct device_node *np)
 {
-	struct v4l2_of_endpoint bus_cfg;
+	struct v4l2_fwnode_endpoint bus_cfg;
 	struct device_node *ep;
 #ifdef CONFIG_MEDIA_CONTROLLER
 	struct device_node *connectors, *child;
@@ -1373,7 +1374,7 @@ static int tvp5150_parse_dt(struct tvp5150 *decoder, struct device_node *np)
 	if (!ep)
 		return -EINVAL;
 
-	ret = v4l2_of_parse_endpoint(ep, &bus_cfg);
+	ret = v4l2_fwnode_endpoint_parse(of_fwnode_handle(ep), &bus_cfg);
 	if (ret)
 		goto err;
 
diff --git a/drivers/media/i2c/tvp7002.c b/drivers/media/i2c/tvp7002.c
index 4c11901..a26c1a3 100644
--- a/drivers/media/i2c/tvp7002.c
+++ b/drivers/media/i2c/tvp7002.c
@@ -33,7 +33,7 @@
 #include <media/v4l2-device.h>
 #include <media/v4l2-common.h>
 #include <media/v4l2-ctrls.h>
-#include <media/v4l2-of.h>
+#include <media/v4l2-fwnode.h>
 
 #include "tvp7002_reg.h"
 
@@ -889,7 +889,7 @@ static const struct v4l2_subdev_ops tvp7002_ops = {
 static struct tvp7002_config *
 tvp7002_get_pdata(struct i2c_client *client)
 {
-	struct v4l2_of_endpoint bus_cfg;
+	struct v4l2_fwnode_endpoint bus_cfg;
 	struct tvp7002_config *pdata = NULL;
 	struct device_node *endpoint;
 	unsigned int flags;
@@ -901,7 +901,7 @@ tvp7002_get_pdata(struct i2c_client *client)
 	if (!endpoint)
 		return NULL;
 
-	if (v4l2_of_parse_endpoint(endpoint, &bus_cfg))
+	if (v4l2_fwnode_endpoint_parse(of_fwnode_handle(endpoint), &bus_cfg))
 		goto done;
 
 	pdata = devm_kzalloc(&client->dev, sizeof(*pdata), GFP_KERNEL);
diff --git a/drivers/media/platform/Kconfig b/drivers/media/platform/Kconfig
index 73c3bc5..4150b2c 100644
--- a/drivers/media/platform/Kconfig
+++ b/drivers/media/platform/Kconfig
@@ -82,6 +82,7 @@ config VIDEO_OMAP3
 	select ARM_DMA_USE_IOMMU
 	select VIDEOBUF2_DMA_CONTIG
 	select MFD_SYSCON
+	select V4L2_FWNODE
 	---help---
 	  Driver for an OMAP 3 camera controller.
 
@@ -97,6 +98,7 @@ config VIDEO_PXA27x
 	depends on PXA27x || COMPILE_TEST
 	select VIDEOBUF2_DMA_SG
 	select SG_SPLIT
+	select V4L2_FWNODE
 	---help---
 	  This is a v4l2 driver for the PXA27x Quick Capture Interface
 
@@ -127,6 +129,7 @@ config VIDEO_TI_CAL
 	depends on SOC_DRA7XX || COMPILE_TEST
 	depends on HAS_DMA
 	select VIDEOBUF2_DMA_CONTIG
+	select V4L2_FWNODE
 	default n
 	---help---
 	  Support for the TI CAL (Camera Adaptation Layer) block
diff --git a/drivers/media/platform/am437x/Kconfig b/drivers/media/platform/am437x/Kconfig
index 42d9c18..160e77e 100644
--- a/drivers/media/platform/am437x/Kconfig
+++ b/drivers/media/platform/am437x/Kconfig
@@ -3,6 +3,7 @@ config VIDEO_AM437X_VPFE
 	depends on VIDEO_V4L2 && VIDEO_V4L2_SUBDEV_API && HAS_DMA
 	depends on SOC_AM43XX || COMPILE_TEST
 	select VIDEOBUF2_DMA_CONTIG
+	select V4L2_FWNODE
 	help
 	   Support for AM437x Video Processing Front End based Video
 	   Capture Driver.
diff --git a/drivers/media/platform/am437x/am437x-vpfe.c b/drivers/media/platform/am437x/am437x-vpfe.c
index 05489a4..466aba8 100644
--- a/drivers/media/platform/am437x/am437x-vpfe.c
+++ b/drivers/media/platform/am437x/am437x-vpfe.c
@@ -26,6 +26,7 @@
 #include <linux/interrupt.h>
 #include <linux/io.h>
 #include <linux/module.h>
+#include <linux/of_graph.h>
 #include <linux/pinctrl/consumer.h>
 #include <linux/platform_device.h>
 #include <linux/pm_runtime.h>
@@ -36,7 +37,7 @@
 #include <media/v4l2-common.h>
 #include <media/v4l2-ctrls.h>
 #include <media/v4l2-event.h>
-#include <media/v4l2-of.h>
+#include <media/v4l2-fwnode.h>
 
 #include "am437x-vpfe.h"
 
@@ -2303,7 +2304,8 @@ vpfe_async_bound(struct v4l2_async_notifier *notifier,
 	vpfe_dbg(1, vpfe, "vpfe_async_bound\n");
 
 	for (i = 0; i < ARRAY_SIZE(vpfe->cfg->asd); i++) {
-		if (vpfe->cfg->asd[i]->match.of.node == asd[i].match.of.node) {
+		if (vpfe->cfg->asd[i]->match.fwnode.fwnode ==
+		    asd[i].match.fwnode.fwnode) {
 			sdinfo = &vpfe->cfg->sub_devs[i];
 			vpfe->sd[i] = subdev;
 			vpfe->sd[i]->grp_id = sdinfo->grp_id;
@@ -2419,7 +2421,7 @@ static struct vpfe_config *
 vpfe_get_pdata(struct platform_device *pdev)
 {
 	struct device_node *endpoint = NULL;
-	struct v4l2_of_endpoint bus_cfg;
+	struct v4l2_fwnode_endpoint bus_cfg;
 	struct vpfe_subdev_info *sdinfo;
 	struct vpfe_config *pdata;
 	unsigned int flags;
@@ -2463,7 +2465,8 @@ vpfe_get_pdata(struct platform_device *pdev)
 			sdinfo->vpfe_param.if_type = VPFE_RAW_BAYER;
 		}
 
-		err = v4l2_of_parse_endpoint(endpoint, &bus_cfg);
+		err = v4l2_fwnode_endpoint_parse(of_fwnode_handle(endpoint),
+						 &bus_cfg);
 		if (err) {
 			dev_err(&pdev->dev, "Could not parse the endpoint\n");
 			goto done;
@@ -2501,8 +2504,8 @@ vpfe_get_pdata(struct platform_device *pdev)
 			goto done;
 		}
 
-		pdata->asd[i]->match_type = V4L2_ASYNC_MATCH_OF;
-		pdata->asd[i]->match.of.node = rem;
+		pdata->asd[i]->match_type = V4L2_ASYNC_MATCH_FWNODE;
+		pdata->asd[i]->match.fwnode.fwnode = of_fwnode_handle(rem);
 		of_node_put(rem);
 	}
 
diff --git a/drivers/media/platform/atmel/Kconfig b/drivers/media/platform/atmel/Kconfig
index 9bd0f19..55de751 100644
--- a/drivers/media/platform/atmel/Kconfig
+++ b/drivers/media/platform/atmel/Kconfig
@@ -4,6 +4,7 @@ config VIDEO_ATMEL_ISC
 	depends on ARCH_AT91 || COMPILE_TEST
 	select VIDEOBUF2_DMA_CONTIG
 	select REGMAP_MMIO
+	select V4L2_FWNODE
 	help
 	   This module makes the ATMEL Image Sensor Controller available
 	   as a v4l2 device.
@@ -13,6 +14,7 @@ config VIDEO_ATMEL_ISI
 	depends on VIDEO_V4L2 && OF && HAS_DMA
 	depends on ARCH_AT91 || COMPILE_TEST
 	select VIDEOBUF2_DMA_CONTIG
+	select V4L2_FWNODE
 	---help---
 	  This module makes the ATMEL Image Sensor Interface available
 	  as a v4l2 device.
diff --git a/drivers/media/platform/atmel/atmel-isc.c b/drivers/media/platform/atmel/atmel-isc.c
index 7dacf8c..380a95e 100644
--- a/drivers/media/platform/atmel/atmel-isc.c
+++ b/drivers/media/platform/atmel/atmel-isc.c
@@ -32,6 +32,7 @@
 #include <linux/math64.h>
 #include <linux/module.h>
 #include <linux/of.h>
+#include <linux/of_graph.h>
 #include <linux/platform_device.h>
 #include <linux/pm_runtime.h>
 #include <linux/regmap.h>
@@ -42,7 +43,7 @@
 #include <media/v4l2-event.h>
 #include <media/v4l2-image-sizes.h>
 #include <media/v4l2-ioctl.h>
-#include <media/v4l2-of.h>
+#include <media/v4l2-fwnode.h>
 #include <media/v4l2-subdev.h>
 #include <media/videobuf2-dma-contig.h>
 
@@ -1683,7 +1684,7 @@ static int isc_parse_dt(struct device *dev, struct isc_device *isc)
 {
 	struct device_node *np = dev->of_node;
 	struct device_node *epn = NULL, *rem;
-	struct v4l2_of_endpoint v4l2_epn;
+	struct v4l2_fwnode_endpoint v4l2_epn;
 	struct isc_subdev_entity *subdev_entity;
 	unsigned int flags;
 	int ret;
@@ -1702,7 +1703,8 @@ static int isc_parse_dt(struct device *dev, struct isc_device *isc)
 			continue;
 		}
 
-		ret = v4l2_of_parse_endpoint(epn, &v4l2_epn);
+		ret = v4l2_fwnode_endpoint_parse(of_fwnode_handle(epn),
+						 &v4l2_epn);
 		if (ret) {
 			of_node_put(rem);
 			ret = -EINVAL;
@@ -1737,8 +1739,9 @@ static int isc_parse_dt(struct device *dev, struct isc_device *isc)
 		if (flags & V4L2_MBUS_PCLK_SAMPLE_FALLING)
 			subdev_entity->pfe_cfg0 |= ISC_PFE_CFG0_PPOL_LOW;
 
-		subdev_entity->asd->match_type = V4L2_ASYNC_MATCH_OF;
-		subdev_entity->asd->match.of.node = rem;
+		subdev_entity->asd->match_type = V4L2_ASYNC_MATCH_FWNODE;
+		subdev_entity->asd->match.fwnode.fwnode =
+			of_fwnode_handle(rem);
 		list_add_tail(&subdev_entity->list, &isc->subdev_entities);
 	}
 
diff --git a/drivers/media/platform/atmel/atmel-isi.c b/drivers/media/platform/atmel/atmel-isi.c
index e4867f8..ef482cc 100644
--- a/drivers/media/platform/atmel/atmel-isi.c
+++ b/drivers/media/platform/atmel/atmel-isi.c
@@ -19,6 +19,7 @@
 #include <linux/interrupt.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
+#include <linux/of_graph.h>
 #include <linux/platform_device.h>
 #include <linux/pm_runtime.h>
 #include <linux/slab.h>
@@ -30,7 +31,7 @@
 #include <media/v4l2-dev.h>
 #include <media/v4l2-ioctl.h>
 #include <media/v4l2-event.h>
-#include <media/v4l2-of.h>
+#include <media/v4l2-fwnode.h>
 #include <media/videobuf2-dma-contig.h>
 #include <media/v4l2-image-sizes.h>
 
@@ -801,7 +802,7 @@ static int atmel_isi_parse_dt(struct atmel_isi *isi,
 			struct platform_device *pdev)
 {
 	struct device_node *np = pdev->dev.of_node;
-	struct v4l2_of_endpoint ep;
+	struct v4l2_fwnode_endpoint ep;
 	int err;
 
 	/* Default settings for ISI */
@@ -814,7 +815,7 @@ static int atmel_isi_parse_dt(struct atmel_isi *isi,
 		return -EINVAL;
 	}
 
-	err = v4l2_of_parse_endpoint(np, &ep);
+	err = v4l2_fwnode_endpoint_parse(of_fwnode_handle(np), &ep);
 	of_node_put(np);
 	if (err) {
 		dev_err(&pdev->dev, "Could not parse the endpoint\n");
@@ -1126,8 +1127,8 @@ static int isi_graph_parse(struct atmel_isi *isi, struct device_node *node)
 
 		/* Remote node to connect */
 		isi->entity.node = remote;
-		isi->entity.asd.match_type = V4L2_ASYNC_MATCH_OF;
-		isi->entity.asd.match.of.node = remote;
+		isi->entity.asd.match_type = V4L2_ASYNC_MATCH_FWNODE;
+		isi->entity.asd.match.fwnode.fwnode = of_fwnode_handle(remote);
 		return 0;
 	}
 }
diff --git a/drivers/media/platform/exynos4-is/Kconfig b/drivers/media/platform/exynos4-is/Kconfig
index 57d42c6..c480efb 100644
--- a/drivers/media/platform/exynos4-is/Kconfig
+++ b/drivers/media/platform/exynos4-is/Kconfig
@@ -4,6 +4,7 @@ config VIDEO_SAMSUNG_EXYNOS4_IS
 	depends on VIDEO_V4L2 && VIDEO_V4L2_SUBDEV_API
 	depends on ARCH_S5PV210 || ARCH_EXYNOS || COMPILE_TEST
 	depends on OF && COMMON_CLK
+	select V4L2_FWNODE
 	help
 	  Say Y here to enable camera host interface devices for
 	  Samsung S5P and EXYNOS SoC series.
@@ -32,6 +33,7 @@ config VIDEO_S5P_MIPI_CSIS
 	tristate "S5P/EXYNOS MIPI-CSI2 receiver (MIPI-CSIS) driver"
 	depends on REGULATOR
 	select GENERIC_PHY
+	select V4L2_FWNODE
 	help
 	  This is a V4L2 driver for Samsung S5P and EXYNOS4 SoC MIPI-CSI2
 	  receiver (MIPI-CSIS) devices.
diff --git a/drivers/media/platform/exynos4-is/media-dev.c b/drivers/media/platform/exynos4-is/media-dev.c
index e82450e9..7d1cf78 100644
--- a/drivers/media/platform/exynos4-is/media-dev.c
+++ b/drivers/media/platform/exynos4-is/media-dev.c
@@ -29,7 +29,7 @@
 #include <linux/slab.h>
 #include <media/v4l2-async.h>
 #include <media/v4l2-ctrls.h>
-#include <media/v4l2-of.h>
+#include <media/v4l2-fwnode.h>
 #include <media/media-device.h>
 #include <media/drv-intf/exynos-fimc.h>
 
@@ -388,7 +388,7 @@ static int fimc_md_parse_port_node(struct fimc_md *fmd,
 {
 	struct fimc_source_info *pd = &fmd->sensor[index].pdata;
 	struct device_node *rem, *ep, *np;
-	struct v4l2_of_endpoint endpoint;
+	struct v4l2_fwnode_endpoint endpoint;
 	int ret;
 
 	/* Assume here a port node can have only one endpoint node. */
@@ -396,7 +396,7 @@ static int fimc_md_parse_port_node(struct fimc_md *fmd,
 	if (!ep)
 		return 0;
 
-	ret = v4l2_of_parse_endpoint(ep, &endpoint);
+	ret = v4l2_fwnode_endpoint_parse(of_fwnode_handle(ep), &endpoint);
 	if (ret) {
 		of_node_put(ep);
 		return ret;
@@ -453,8 +453,8 @@ static int fimc_md_parse_port_node(struct fimc_md *fmd,
 		return -EINVAL;
 	}
 
-	fmd->sensor[index].asd.match_type = V4L2_ASYNC_MATCH_OF;
-	fmd->sensor[index].asd.match.of.node = rem;
+	fmd->sensor[index].asd.match_type = V4L2_ASYNC_MATCH_FWNODE;
+	fmd->sensor[index].asd.match.fwnode.fwnode = of_fwnode_handle(rem);
 	fmd->async_subdevs[index] = &fmd->sensor[index].asd;
 
 	fmd->num_sensors++;
@@ -1361,7 +1361,8 @@ static int subdev_notifier_bound(struct v4l2_async_notifier *notifier,
 
 	/* Find platform data for this sensor subdev */
 	for (i = 0; i < ARRAY_SIZE(fmd->sensor); i++)
-		if (fmd->sensor[i].asd.match.of.node == subdev->dev->of_node)
+		if (fmd->sensor[i].asd.match.fwnode.fwnode ==
+		    of_fwnode_handle(subdev->dev->of_node))
 			si = &fmd->sensor[i];
 
 	if (si == NULL)
diff --git a/drivers/media/platform/exynos4-is/mipi-csis.c b/drivers/media/platform/exynos4-is/mipi-csis.c
index f819b29..98c8987 100644
--- a/drivers/media/platform/exynos4-is/mipi-csis.c
+++ b/drivers/media/platform/exynos4-is/mipi-csis.c
@@ -30,7 +30,7 @@
 #include <linux/spinlock.h>
 #include <linux/videodev2.h>
 #include <media/drv-intf/exynos-fimc.h>
-#include <media/v4l2-of.h>
+#include <media/v4l2-fwnode.h>
 #include <media/v4l2-subdev.h>
 
 #include "mipi-csis.h"
@@ -718,7 +718,7 @@ static int s5pcsis_parse_dt(struct platform_device *pdev,
 			    struct csis_state *state)
 {
 	struct device_node *node = pdev->dev.of_node;
-	struct v4l2_of_endpoint endpoint;
+	struct v4l2_fwnode_endpoint endpoint;
 	int ret;
 
 	if (of_property_read_u32(node, "clock-frequency",
@@ -735,7 +735,7 @@ static int s5pcsis_parse_dt(struct platform_device *pdev,
 		return -EINVAL;
 	}
 	/* Get port node and validate MIPI-CSI channel id. */
-	ret = v4l2_of_parse_endpoint(node, &endpoint);
+	ret = v4l2_fwnode_endpoint_parse(of_fwnode_handle(node), &endpoint);
 	if (ret)
 		goto err;
 
diff --git a/drivers/media/platform/omap3isp/isp.c b/drivers/media/platform/omap3isp/isp.c
index 084ecf4a..d8fba9c 100644
--- a/drivers/media/platform/omap3isp/isp.c
+++ b/drivers/media/platform/omap3isp/isp.c
@@ -55,6 +55,7 @@
 #include <linux/module.h>
 #include <linux/omap-iommu.h>
 #include <linux/platform_device.h>
+#include <linux/property.h>
 #include <linux/regulator/consumer.h>
 #include <linux/slab.h>
 #include <linux/sched.h>
@@ -63,9 +64,9 @@
 #include <asm/dma-iommu.h>
 
 #include <media/v4l2-common.h>
+#include <media/v4l2-fwnode.h>
 #include <media/v4l2-device.h>
 #include <media/v4l2-mc.h>
-#include <media/v4l2-of.h>
 
 #include "isp.h"
 #include "ispreg.h"
@@ -2024,20 +2025,20 @@ enum isp_of_phy {
 	ISP_OF_PHY_CSIPHY2,
 };
 
-static int isp_of_parse_node(struct device *dev, struct device_node *node,
-			     struct isp_async_subdev *isd)
+static int isp_fwnode_parse(struct device *dev, struct fwnode_handle *fwnode,
+			    struct isp_async_subdev *isd)
 {
 	struct isp_bus_cfg *buscfg = &isd->bus;
-	struct v4l2_of_endpoint vep;
+	struct v4l2_fwnode_endpoint vep;
 	unsigned int i;
 	int ret;
 
-	ret = v4l2_of_parse_endpoint(node, &vep);
+	ret = v4l2_fwnode_endpoint_parse(fwnode, &vep);
 	if (ret)
 		return ret;
 
-	dev_dbg(dev, "parsing endpoint %s, interface %u\n", node->full_name,
-		vep.base.port);
+	dev_dbg(dev, "parsing endpoint %s, interface %u\n",
+		to_of_node(fwnode)->full_name, vep.base.port);
 
 	switch (vep.base.port) {
 	case ISP_OF_PHY_PARALLEL:
@@ -2094,18 +2095,18 @@ static int isp_of_parse_node(struct device *dev, struct device_node *node,
 		break;
 
 	default:
-		dev_warn(dev, "%s: invalid interface %u\n", node->full_name,
-			 vep.base.port);
+		dev_warn(dev, "%s: invalid interface %u\n",
+			 to_of_node(fwnode)->full_name, vep.base.port);
 		break;
 	}
 
 	return 0;
 }
 
-static int isp_of_parse_nodes(struct device *dev,
-			      struct v4l2_async_notifier *notifier)
+static int isp_fwnodes_parse(struct device *dev,
+			     struct v4l2_async_notifier *notifier)
 {
-	struct device_node *node = NULL;
+	struct fwnode_handle *fwnode = NULL;
 
 	notifier->subdevs = devm_kcalloc(
 		dev, ISP_MAX_SUBDEVS, sizeof(*notifier->subdevs), GFP_KERNEL);
@@ -2113,7 +2114,8 @@ static int isp_of_parse_nodes(struct device *dev,
 		return -ENOMEM;
 
 	while (notifier->num_subdevs < ISP_MAX_SUBDEVS &&
-	       (node = of_graph_get_next_endpoint(dev->of_node, node))) {
+	       (fwnode = fwnode_graph_get_next_endpoint(
+			of_fwnode_handle(dev->of_node), fwnode))) {
 		struct isp_async_subdev *isd;
 
 		isd = devm_kzalloc(dev, sizeof(*isd), GFP_KERNEL);
@@ -2122,23 +2124,24 @@ static int isp_of_parse_nodes(struct device *dev,
 
 		notifier->subdevs[notifier->num_subdevs] = &isd->asd;
 
-		if (isp_of_parse_node(dev, node, isd))
+		if (isp_fwnode_parse(dev, fwnode, isd))
 			goto error;
 
-		isd->asd.match.of.node = of_graph_get_remote_port_parent(node);
-		if (!isd->asd.match.of.node) {
+		isd->asd.match.fwnode.fwnode =
+			fwnode_graph_get_remote_port_parent(fwnode);
+		if (!isd->asd.match.fwnode.fwnode) {
 			dev_warn(dev, "bad remote port parent\n");
 			goto error;
 		}
 
-		isd->asd.match_type = V4L2_ASYNC_MATCH_OF;
+		isd->asd.match_type = V4L2_ASYNC_MATCH_FWNODE;
 		notifier->num_subdevs++;
 	}
 
 	return notifier->num_subdevs;
 
 error:
-	of_node_put(node);
+	fwnode_handle_put(fwnode);
 	return -EINVAL;
 }
 
@@ -2209,8 +2212,8 @@ static int isp_probe(struct platform_device *pdev)
 		return -ENOMEM;
 	}
 
-	ret = of_property_read_u32(pdev->dev.of_node, "ti,phy-type",
-				   &isp->phy_type);
+	ret = fwnode_property_read_u32(of_fwnode_handle(pdev->dev.of_node),
+				       "ti,phy-type", &isp->phy_type);
 	if (ret)
 		return ret;
 
@@ -2219,12 +2222,12 @@ static int isp_probe(struct platform_device *pdev)
 	if (IS_ERR(isp->syscon))
 		return PTR_ERR(isp->syscon);
 
-	ret = of_property_read_u32_index(pdev->dev.of_node, "syscon", 1,
-					 &isp->syscon_offset);
+	ret = of_property_read_u32_index(pdev->dev.of_node,
+					 "syscon", 1, &isp->syscon_offset);
 	if (ret)
 		return ret;
 
-	ret = isp_of_parse_nodes(&pdev->dev, &isp->notifier);
+	ret = isp_fwnodes_parse(&pdev->dev, &isp->notifier);
 	if (ret < 0)
 		return ret;
 
diff --git a/drivers/media/platform/pxa_camera.c b/drivers/media/platform/pxa_camera.c
index 929006f..ebf9ea9 100644
--- a/drivers/media/platform/pxa_camera.c
+++ b/drivers/media/platform/pxa_camera.c
@@ -25,6 +25,7 @@
 #include <linux/mm.h>
 #include <linux/moduleparam.h>
 #include <linux/of.h>
+#include <linux/of_graph.h>
 #include <linux/time.h>
 #include <linux/platform_device.h>
 #include <linux/clk.h>
@@ -39,7 +40,7 @@
 #include <media/v4l2-common.h>
 #include <media/v4l2-device.h>
 #include <media/v4l2-ioctl.h>
-#include <media/v4l2-of.h>
+#include <media/v4l2-fwnode.h>
 
 #include <media/videobuf2-dma-sg.h>
 
@@ -2236,7 +2237,7 @@ static int pxa_camera_pdata_from_dt(struct device *dev,
 {
 	u32 mclk_rate;
 	struct device_node *remote, *np = dev->of_node;
-	struct v4l2_of_endpoint ep;
+	struct v4l2_fwnode_endpoint ep;
 	int err = of_property_read_u32(np, "clock-frequency",
 				       &mclk_rate);
 	if (!err) {
@@ -2250,7 +2251,7 @@ static int pxa_camera_pdata_from_dt(struct device *dev,
 		return -EINVAL;
 	}
 
-	err = v4l2_of_parse_endpoint(np, &ep);
+	err = v4l2_fwnode_endpoint_parse(of_fwnode_handle(np), &ep);
 	if (err) {
 		dev_err(dev, "could not parse endpoint\n");
 		goto out;
@@ -2287,10 +2288,10 @@ static int pxa_camera_pdata_from_dt(struct device *dev,
 	if (ep.bus.parallel.flags & V4L2_MBUS_PCLK_SAMPLE_FALLING)
 		pcdev->platform_flags |= PXA_CAMERA_PCLK_EN;
 
-	asd->match_type = V4L2_ASYNC_MATCH_OF;
+	asd->match_type = V4L2_ASYNC_MATCH_FWNODE;
 	remote = of_graph_get_remote_port(np);
 	if (remote) {
-		asd->match.of.node = remote;
+		asd->match.fwnode.fwnode = of_fwnode_handle(remote);
 		of_node_put(remote);
 	} else {
 		dev_notice(dev, "no remote for %s\n", of_node_full_name(np));
diff --git a/drivers/media/platform/rcar-vin/Kconfig b/drivers/media/platform/rcar-vin/Kconfig
index 111d2a1..af4c98b 100644
--- a/drivers/media/platform/rcar-vin/Kconfig
+++ b/drivers/media/platform/rcar-vin/Kconfig
@@ -3,6 +3,7 @@ config VIDEO_RCAR_VIN
 	depends on VIDEO_V4L2 && VIDEO_V4L2_SUBDEV_API && OF && HAS_DMA && MEDIA_CONTROLLER
 	depends on ARCH_RENESAS || COMPILE_TEST
 	select VIDEOBUF2_DMA_CONTIG
+	select V4L2_FWNODE
 	---help---
 	  Support for Renesas R-Car Video Input (VIN) driver.
 	  Supports R-Car Gen2 SoCs.
diff --git a/drivers/media/platform/rcar-vin/rcar-core.c b/drivers/media/platform/rcar-vin/rcar-core.c
index 098a0b1..264604a 100644
--- a/drivers/media/platform/rcar-vin/rcar-core.c
+++ b/drivers/media/platform/rcar-vin/rcar-core.c
@@ -21,7 +21,7 @@
 #include <linux/platform_device.h>
 #include <linux/pm_runtime.h>
 
-#include <media/v4l2-of.h>
+#include <media/v4l2-fwnode.h>
 
 #include "rcar-vin.h"
 
@@ -104,7 +104,8 @@ static int rvin_digital_notify_bound(struct v4l2_async_notifier *notifier,
 
 	v4l2_set_subdev_hostdata(subdev, vin);
 
-	if (vin->digital.asd.match.of.node == subdev->dev->of_node) {
+	if (vin->digital.asd.match.fwnode.fwnode ==
+	    of_fwnode_handle(subdev->dev->of_node)) {
 		vin_dbg(vin, "bound digital subdev %s\n", subdev->name);
 		vin->digital.subdev = subdev;
 		return 0;
@@ -118,10 +119,10 @@ static int rvin_digitial_parse_v4l2(struct rvin_dev *vin,
 				    struct device_node *ep,
 				    struct v4l2_mbus_config *mbus_cfg)
 {
-	struct v4l2_of_endpoint v4l2_ep;
+	struct v4l2_fwnode_endpoint v4l2_ep;
 	int ret;
 
-	ret = v4l2_of_parse_endpoint(ep, &v4l2_ep);
+	ret = v4l2_fwnode_endpoint_parse(of_fwnode_handle(ep), &v4l2_ep);
 	if (ret) {
 		vin_err(vin, "Could not parse v4l2 endpoint\n");
 		return -EINVAL;
@@ -151,7 +152,7 @@ static int rvin_digital_graph_parse(struct rvin_dev *vin)
 	struct device_node *ep, *np;
 	int ret;
 
-	vin->digital.asd.match.of.node = NULL;
+	vin->digital.asd.match.fwnode.fwnode = NULL;
 	vin->digital.subdev = NULL;
 
 	/*
@@ -175,8 +176,8 @@ static int rvin_digital_graph_parse(struct rvin_dev *vin)
 	if (ret)
 		return ret;
 
-	vin->digital.asd.match.of.node = np;
-	vin->digital.asd.match_type = V4L2_ASYNC_MATCH_OF;
+	vin->digital.asd.match.fwnode.fwnode = of_fwnode_handle(np);
+	vin->digital.asd.match_type = V4L2_ASYNC_MATCH_FWNODE;
 
 	return 0;
 }
@@ -190,7 +191,7 @@ static int rvin_digital_graph_init(struct rvin_dev *vin)
 	if (ret)
 		return ret;
 
-	if (!vin->digital.asd.match.of.node) {
+	if (!vin->digital.asd.match.fwnode.fwnode) {
 		vin_dbg(vin, "No digital subdevice found\n");
 		return -ENODEV;
 	}
@@ -203,7 +204,7 @@ static int rvin_digital_graph_init(struct rvin_dev *vin)
 	subdevs[0] = &vin->digital.asd;
 
 	vin_dbg(vin, "Found digital subdevice %s\n",
-		of_node_full_name(subdevs[0]->match.of.node));
+		of_node_full_name(to_of_node(subdevs[0]->match.fwnode.fwnode)));
 
 	vin->notifier.num_subdevs = 1;
 	vin->notifier.subdevs = subdevs;
diff --git a/drivers/media/platform/soc_camera/soc_camera.c b/drivers/media/platform/soc_camera/soc_camera.c
index 3c9421f..45a0429 100644
--- a/drivers/media/platform/soc_camera/soc_camera.c
+++ b/drivers/media/platform/soc_camera/soc_camera.c
@@ -23,6 +23,7 @@
 #include <linux/list.h>
 #include <linux/module.h>
 #include <linux/mutex.h>
+#include <linux/of_graph.h>
 #include <linux/platform_device.h>
 #include <linux/pm_runtime.h>
 #include <linux/regulator/consumer.h>
@@ -36,7 +37,7 @@
 #include <media/v4l2-common.h>
 #include <media/v4l2-ioctl.h>
 #include <media/v4l2-dev.h>
-#include <media/v4l2-of.h>
+#include <media/v4l2-fwnode.h>
 #include <media/videobuf2-v4l2.h>
 
 /* Default to VGA resolution */
@@ -1512,8 +1513,8 @@ static int soc_of_bind(struct soc_camera_host *ici,
 	if (!info)
 		return -ENOMEM;
 
-	info->sasd.asd.match.of.node = remote;
-	info->sasd.asd.match_type = V4L2_ASYNC_MATCH_OF;
+	info->sasd.asd.match.fwnode.fwnode = of_fwnode_handle(remote);
+	info->sasd.asd.match_type = V4L2_ASYNC_MATCH_FWNODE;
 	info->subdev = &info->sasd.asd;
 
 	/* Or shall this be managed by the soc-camera device? */
diff --git a/drivers/media/platform/ti-vpe/cal.c b/drivers/media/platform/ti-vpe/cal.c
index 7a058b6..177faa3 100644
--- a/drivers/media/platform/ti-vpe/cal.c
+++ b/drivers/media/platform/ti-vpe/cal.c
@@ -21,7 +21,7 @@
 #include <linux/of_device.h>
 #include <linux/of_graph.h>
 
-#include <media/v4l2-of.h>
+#include <media/v4l2-fwnode.h>
 #include <media/v4l2-async.h>
 #include <media/v4l2-common.h>
 #include <media/v4l2-ctrls.h>
@@ -270,7 +270,7 @@ struct cal_ctx {
 	struct video_device	vdev;
 	struct v4l2_async_notifier notifier;
 	struct v4l2_subdev	*sensor;
-	struct v4l2_of_endpoint	endpoint;
+	struct v4l2_fwnode_endpoint	endpoint;
 
 	struct v4l2_async_subdev asd;
 	struct v4l2_async_subdev *asd_list[1];
@@ -608,7 +608,8 @@ static void csi2_lane_config(struct cal_ctx *ctx)
 	u32 val = reg_read(ctx->dev, CAL_CSI2_COMPLEXIO_CFG(ctx->csi2_port));
 	u32 lane_mask = CAL_CSI2_COMPLEXIO_CFG_CLOCK_POSITION_MASK;
 	u32 polarity_mask = CAL_CSI2_COMPLEXIO_CFG_CLOCK_POL_MASK;
-	struct v4l2_of_bus_mipi_csi2 *mipi_csi2 = &ctx->endpoint.bus.mipi_csi2;
+	struct v4l2_fwnode_bus_mipi_csi2 *mipi_csi2 =
+		&ctx->endpoint.bus.mipi_csi2;
 	int lane;
 
 	set_field(&val, mipi_csi2->clock_lane + 1, lane_mask);
@@ -1643,7 +1644,7 @@ static int of_cal_create_instance(struct cal_ctx *ctx, int inst)
 	struct platform_device *pdev = ctx->dev->pdev;
 	struct device_node *ep_node, *port, *remote_ep,
 			*sensor_node, *parent;
-	struct v4l2_of_endpoint *endpoint;
+	struct v4l2_fwnode_endpoint *endpoint;
 	struct v4l2_async_subdev *asd;
 	u32 regval = 0;
 	int ret, index, found_port = 0, lane;
@@ -1698,15 +1699,15 @@ static int of_cal_create_instance(struct cal_ctx *ctx, int inst)
 		ctx_dbg(3, ctx, "can't get remote parent\n");
 		goto cleanup_exit;
 	}
-	asd->match_type = V4L2_ASYNC_MATCH_OF;
-	asd->match.of.node = sensor_node;
+	asd->match_type = V4L2_ASYNC_MATCH_FWNODE;
+	asd->match.fwnode.fwnode = of_fwnode_handle(sensor_node);
 
 	remote_ep = of_parse_phandle(ep_node, "remote-endpoint", 0);
 	if (!remote_ep) {
 		ctx_dbg(3, ctx, "can't get remote-endpoint\n");
 		goto cleanup_exit;
 	}
-	v4l2_of_parse_endpoint(remote_ep, endpoint);
+	v4l2_fwnode_endpoint_parse(of_fwnode_handle(remote_ep), endpoint);
 
 	if (endpoint->bus_type != V4L2_MBUS_CSI2) {
 		ctx_err(ctx, "Port:%d sub-device %s is not a CSI2 device\n",
diff --git a/drivers/media/platform/xilinx/Kconfig b/drivers/media/platform/xilinx/Kconfig
index 84bae79..a5d21b7 100644
--- a/drivers/media/platform/xilinx/Kconfig
+++ b/drivers/media/platform/xilinx/Kconfig
@@ -2,6 +2,7 @@ config VIDEO_XILINX
 	tristate "Xilinx Video IP (EXPERIMENTAL)"
 	depends on VIDEO_V4L2 && VIDEO_V4L2_SUBDEV_API && OF && HAS_DMA
 	select VIDEOBUF2_DMA_CONTIG
+	select V4L2_FWNODE
 	---help---
 	  Driver for Xilinx Video IP Pipelines
 
diff --git a/drivers/media/platform/xilinx/xilinx-vipp.c b/drivers/media/platform/xilinx/xilinx-vipp.c
index feb3b2f..ac47043 100644
--- a/drivers/media/platform/xilinx/xilinx-vipp.c
+++ b/drivers/media/platform/xilinx/xilinx-vipp.c
@@ -22,7 +22,7 @@
 #include <media/v4l2-async.h>
 #include <media/v4l2-common.h>
 #include <media/v4l2-device.h>
-#include <media/v4l2-of.h>
+#include <media/v4l2-fwnode.h>
 
 #include "xilinx-dma.h"
 #include "xilinx-vipp.h"
@@ -74,7 +74,7 @@ static int xvip_graph_build_one(struct xvip_composite_device *xdev,
 	struct media_pad *local_pad;
 	struct media_pad *remote_pad;
 	struct xvip_graph_entity *ent;
-	struct v4l2_of_link link;
+	struct v4l2_fwnode_link link;
 	struct device_node *ep = NULL;
 	struct device_node *next;
 	int ret = 0;
@@ -92,7 +92,7 @@ static int xvip_graph_build_one(struct xvip_composite_device *xdev,
 
 		dev_dbg(xdev->dev, "processing endpoint %s\n", ep->full_name);
 
-		ret = v4l2_of_parse_link(ep, &link);
+		ret = v4l2_fwnode_parse_link(of_fwnode_handle(ep), &link);
 		if (ret < 0) {
 			dev_err(xdev->dev, "failed to parse link for %s\n",
 				ep->full_name);
@@ -103,9 +103,10 @@ static int xvip_graph_build_one(struct xvip_composite_device *xdev,
 		 * the link.
 		 */
 		if (link.local_port >= local->num_pads) {
-			dev_err(xdev->dev, "invalid port number %u on %s\n",
-				link.local_port, link.local_node->full_name);
-			v4l2_of_put_link(&link);
+			dev_err(xdev->dev, "invalid port number %u for %s\n",
+				link.local_port,
+				to_of_node(link.local_node)->full_name);
+			v4l2_fwnode_put_link(&link);
 			ret = -EINVAL;
 			break;
 		}
@@ -114,25 +115,28 @@ static int xvip_graph_build_one(struct xvip_composite_device *xdev,
 
 		if (local_pad->flags & MEDIA_PAD_FL_SINK) {
 			dev_dbg(xdev->dev, "skipping sink port %s:%u\n",
-				link.local_node->full_name, link.local_port);
-			v4l2_of_put_link(&link);
+				to_of_node(link.local_node)->full_name,
+				link.local_port);
+			v4l2_fwnode_put_link(&link);
 			continue;
 		}
 
 		/* Skip DMA engines, they will be processed separately. */
-		if (link.remote_node == xdev->dev->of_node) {
+		if (link.remote_node == of_fwnode_handle(xdev->dev->of_node)) {
 			dev_dbg(xdev->dev, "skipping DMA port %s:%u\n",
-				link.local_node->full_name, link.local_port);
-			v4l2_of_put_link(&link);
+				to_of_node(link.local_node)->full_name,
+				link.local_port);
+			v4l2_fwnode_put_link(&link);
 			continue;
 		}
 
 		/* Find the remote entity. */
-		ent = xvip_graph_find_entity(xdev, link.remote_node);
+		ent = xvip_graph_find_entity(xdev,
+					     to_of_node(link.remote_node));
 		if (ent == NULL) {
 			dev_err(xdev->dev, "no entity found for %s\n",
-				link.remote_node->full_name);
-			v4l2_of_put_link(&link);
+				to_of_node(link.remote_node)->full_name);
+			v4l2_fwnode_put_link(&link);
 			ret = -ENODEV;
 			break;
 		}
@@ -141,15 +145,16 @@ static int xvip_graph_build_one(struct xvip_composite_device *xdev,
 
 		if (link.remote_port >= remote->num_pads) {
 			dev_err(xdev->dev, "invalid port number %u on %s\n",
-				link.remote_port, link.remote_node->full_name);
-			v4l2_of_put_link(&link);
+				link.remote_port,
+				to_of_node(link.remote_node)->full_name);
+			v4l2_fwnode_put_link(&link);
 			ret = -EINVAL;
 			break;
 		}
 
 		remote_pad = &remote->pads[link.remote_port];
 
-		v4l2_of_put_link(&link);
+		v4l2_fwnode_put_link(&link);
 
 		/* Create the media link. */
 		dev_dbg(xdev->dev, "creating %s:%u -> %s:%u link\n",
@@ -194,7 +199,7 @@ static int xvip_graph_build_dma(struct xvip_composite_device *xdev)
 	struct media_pad *source_pad;
 	struct media_pad *sink_pad;
 	struct xvip_graph_entity *ent;
-	struct v4l2_of_link link;
+	struct v4l2_fwnode_link link;
 	struct device_node *ep = NULL;
 	struct device_node *next;
 	struct xvip_dma *dma;
@@ -213,7 +218,7 @@ static int xvip_graph_build_dma(struct xvip_composite_device *xdev)
 
 		dev_dbg(xdev->dev, "processing endpoint %s\n", ep->full_name);
 
-		ret = v4l2_of_parse_link(ep, &link);
+		ret = v4l2_fwnode_parse_link(of_fwnode_handle(ep), &link);
 		if (ret < 0) {
 			dev_err(xdev->dev, "failed to parse link for %s\n",
 				ep->full_name);
@@ -225,7 +230,7 @@ static int xvip_graph_build_dma(struct xvip_composite_device *xdev)
 		if (dma == NULL) {
 			dev_err(xdev->dev, "no DMA engine found for port %u\n",
 				link.local_port);
-			v4l2_of_put_link(&link);
+			v4l2_fwnode_put_link(&link);
 			ret = -EINVAL;
 			break;
 		}
@@ -234,19 +239,21 @@ static int xvip_graph_build_dma(struct xvip_composite_device *xdev)
 			dma->video.name);
 
 		/* Find the remote entity. */
-		ent = xvip_graph_find_entity(xdev, link.remote_node);
+		ent = xvip_graph_find_entity(xdev,
+					     to_of_node(link.remote_node));
 		if (ent == NULL) {
 			dev_err(xdev->dev, "no entity found for %s\n",
-				link.remote_node->full_name);
-			v4l2_of_put_link(&link);
+				to_of_node(link.remote_node)->full_name);
+			v4l2_fwnode_put_link(&link);
 			ret = -ENODEV;
 			break;
 		}
 
 		if (link.remote_port >= ent->entity->num_pads) {
 			dev_err(xdev->dev, "invalid port number %u on %s\n",
-				link.remote_port, link.remote_node->full_name);
-			v4l2_of_put_link(&link);
+				link.remote_port,
+				to_of_node(link.remote_node)->full_name);
+			v4l2_fwnode_put_link(&link);
 			ret = -EINVAL;
 			break;
 		}
@@ -263,7 +270,7 @@ static int xvip_graph_build_dma(struct xvip_composite_device *xdev)
 			sink_pad = &dma->pad;
 		}
 
-		v4l2_of_put_link(&link);
+		v4l2_fwnode_put_link(&link);
 
 		/* Create the media link. */
 		dev_dbg(xdev->dev, "creating %s:%u -> %s:%u link\n",
@@ -383,8 +390,8 @@ static int xvip_graph_parse_one(struct xvip_composite_device *xdev,
 		}
 
 		entity->node = remote;
-		entity->asd.match_type = V4L2_ASYNC_MATCH_OF;
-		entity->asd.match.of.node = remote;
+		entity->asd.match_type = V4L2_ASYNC_MATCH_FWNODE;
+		entity->asd.match.fwnode.fwnode = of_fwnode_handle(remote);
 		list_add_tail(&entity->list, &xdev->entities);
 		xdev->num_subdevs++;
 	}
diff --git a/drivers/media/v4l2-core/v4l2-async.c b/drivers/media/v4l2-core/v4l2-async.c
index ff32f95..cbd919d 100644
--- a/drivers/media/v4l2-core/v4l2-async.c
+++ b/drivers/media/v4l2-core/v4l2-async.c
@@ -41,12 +41,6 @@ static bool match_devname(struct v4l2_subdev *sd,
 	return !strcmp(asd->match.device_name.name, dev_name(sd->dev));
 }
 
-static bool match_of(struct v4l2_subdev *sd, struct v4l2_async_subdev *asd)
-{
-	return !of_node_cmp(of_node_full_name(sd->of_node),
-			    of_node_full_name(asd->match.of.node));
-}
-
 static bool match_fwnode(struct v4l2_subdev *sd, struct v4l2_async_subdev *asd)
 {
 	if (!is_of_node(sd->fwnode) || !is_of_node(asd->match.fwnode.fwnode))
@@ -88,9 +82,6 @@ static struct v4l2_async_subdev *v4l2_async_belongs(struct v4l2_async_notifier *
 		case V4L2_ASYNC_MATCH_I2C:
 			match = match_i2c;
 			break;
-		case V4L2_ASYNC_MATCH_OF:
-			match = match_of;
-			break;
 		case V4L2_ASYNC_MATCH_FWNODE:
 			match = match_fwnode;
 			break;
@@ -171,7 +162,6 @@ int v4l2_async_notifier_register(struct v4l2_device *v4l2_dev,
 		case V4L2_ASYNC_MATCH_CUSTOM:
 		case V4L2_ASYNC_MATCH_DEVNAME:
 		case V4L2_ASYNC_MATCH_I2C:
-		case V4L2_ASYNC_MATCH_OF:
 		case V4L2_ASYNC_MATCH_FWNODE:
 			break;
 		default:
@@ -295,8 +285,8 @@ int v4l2_async_register_subdev(struct v4l2_subdev *sd)
 	 * (struct v4l2_subdev.dev), and async sub-device does not
 	 * exist independently of the device at any point of time.
 	 */
-	if (!sd->of_node && sd->dev)
-		sd->of_node = sd->dev->of_node;
+	if (!sd->fwnode && sd->dev)
+		sd->fwnode = dev_fwnode(sd->dev);
 
 	mutex_lock(&list_lock);
 
diff --git a/include/media/v4l2-async.h b/include/media/v4l2-async.h
index c3695fa..c69d8c8 100644
--- a/include/media/v4l2-async.h
+++ b/include/media/v4l2-async.h
@@ -31,7 +31,6 @@ struct v4l2_async_notifier;
  * 	v4l2_async_subdev.match ops
  * @V4L2_ASYNC_MATCH_DEVNAME: Match will use the device name
  * @V4L2_ASYNC_MATCH_I2C: Match will check for I2C adapter ID and address
- * @V4L2_ASYNC_MATCH_OF: Match will use OF node
  * @V4L2_ASYNC_MATCH_FWNODE: Match will use firmware node
  *
  * This enum is used by the asyncrhronous sub-device logic to define the
@@ -41,7 +40,6 @@ enum v4l2_async_match_type {
 	V4L2_ASYNC_MATCH_CUSTOM,
 	V4L2_ASYNC_MATCH_DEVNAME,
 	V4L2_ASYNC_MATCH_I2C,
-	V4L2_ASYNC_MATCH_OF,
 	V4L2_ASYNC_MATCH_FWNODE,
 };
 
@@ -57,9 +55,6 @@ struct v4l2_async_subdev {
 	enum v4l2_async_match_type match_type;
 	union {
 		struct {
-			const struct device_node *node;
-		} of;
-		struct {
 			struct fwnode_handle *fwnode;
 		} fwnode;
 		struct {
-- 
2.7.4
