Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.samsung.com ([203.254.224.25]:15296 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758355Ab3JQSIV (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 17 Oct 2013 14:08:21 -0400
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
To: linux-media@vger.kernel.org
Cc: kyungmin.park@samsung.com, linux-samsung-soc@vger.kernel.org,
	devicetree@vger.kernel.org,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Andrzej Hajda <a.hajda@samsung.com>
Subject: [PATCH v3 3/6] V4L: s5c73m3: Add device tree support
Date: Thu, 17 Oct 2013 20:06:48 +0200
Message-id: <1382033211-32329-4-git-send-email-s.nawrocki@samsung.com>
In-reply-to: <1382033211-32329-1-git-send-email-s.nawrocki@samsung.com>
References: <1382033211-32329-1-git-send-email-s.nawrocki@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch adds the V4L2 asynchronous subdev registration and
device tree support. Common clock API is used to control the
sensor master clock from within the subdev.

Signed-off-by: Andrzej Hajda <a.hajda@samsung.com>
Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
--
Changes since v2:
 - call clk_get() before enabling the clock and clk_put() after
   each clk_disable().
---
 .../devicetree/bindings/media/samsung-s5c73m3.txt  |   95 +++++++++
 drivers/media/i2c/s5c73m3/s5c73m3-core.c           |  208 +++++++++++++++-----
 drivers/media/i2c/s5c73m3/s5c73m3-spi.c            |    6 +
 drivers/media/i2c/s5c73m3/s5c73m3.h                |    4 +
 4 files changed, 263 insertions(+), 50 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/media/samsung-s5c73m3.txt

diff --git a/Documentation/devicetree/bindings/media/samsung-s5c73m3.txt b/Documentation/devicetree/bindings/media/samsung-s5c73m3.txt
new file mode 100644
index 0000000..d419e4e
--- /dev/null
+++ b/Documentation/devicetree/bindings/media/samsung-s5c73m3.txt
@@ -0,0 +1,95 @@
+Samsung S5C73M3 8Mp camera ISP
+------------------------------
+
+The S5C73M3 camera ISP supports MIPI CSI-2 and parallel (ITU-R BT.656) video
+data busses. The I2C bus is the main control bus and additionally the SPI bus
+is used, mostly for transferring the firmware to and from the device. Two
+slave device nodes corresponding to these control bus interfaces are required
+and should be placed under respective bus controller nodes.
+
+I2C slave device node
+---------------------
+
+Required properties:
+
+- compatible	    : "samsung,s5c73m3";
+- reg		    : I2C slave address of the sensor;
+- vdd-int-supply    : digital power supply (1.2V);
+- vdda-supply	    : analog power supply (1.2V);
+- vdd-reg-supply    : regulator input power supply (2.8V);
+- vddio-host-supply : host I/O power supply (1.8V to 2.8V);
+- vddio-cis-supply  : CIS I/O power supply (1.2V to 1.8V);
+- vdd-af-supply	    : lens power supply (2.8V);
+- xshutdown-gpios   : specifier of GPIO connected to the XSHUTDOWN pin;
+- standby-gpios     : specifier of GPIO connected to the STANDBY pin;
+- clocks	    : should contain the sensor's CIS_EXTCLK clock specifier;
+- clock-names	    : should contain "cis_extclk" entry;
+
+Optional properties:
+
+- clock-frequency   : the frequency at which the "cis_extclk" clock should be
+		      configured to operate, in Hz; if this property is not
+		      specified default 24 MHz value will be used.
+
+The common video interfaces bindings (see video-interfaces.txt) should be used
+to specify link from the S5C73M3 to an external image data receiver. The S5C73M3
+device node should contain one 'port' child node with an 'endpoint' subnode for
+this purpose. The data link from a raw image sensor to the S5C73M3 can be
+similarly specified, but it is optional since the S5C73M3 ISP and a raw image
+sensor are usually inseparable and form a hybrid module.
+
+Following properties are valid for the endpoint node(s):
+
+endpoint subnode
+----------------
+
+- data-lanes : (optional) specifies MIPI CSI-2 data lanes as covered in
+  video-interfaces.txt. This sensor doesn't support data lane remapping
+  and physical lane indexes in subsequent elements of the array should
+  be only consecutive ascending values.
+
+SPI device node
+---------------
+
+Required properties:
+
+- compatible	    : "samsung,s5c73m3";
+
+For more details see description of the SPI busses bindings
+(../spi/spi-bus.txt) and bindings of a specific bus controller.
+
+Example:
+
+i2c@138A000000 {
+	...
+	s5c73m3@3c {
+		compatible = "samsung,s5c73m3";
+		reg = <0x3c>;
+		vdd-int-supply = <&buck9_reg>;
+		vdda-supply = <&ldo17_reg>;
+		vdd-reg-supply = <&cam_io_reg>;
+		vddio-host-supply = <&ldo18_reg>;
+		vddio-cis-supply = <&ldo9_reg>;
+		vdd-af-supply = <&cam_af_reg>;
+		clock-frequency = <24000000>;
+		clocks = <&clk 0>;
+		clock-names = "cis_extclk";
+		reset-gpios = <&gpf1 3 1>;
+		standby-gpios = <&gpm0 1 1>;
+		port {
+			s5c73m3_ep: endpoint {
+				remote-endpoint = <&csis0_ep>;
+				data-lanes = <1 2 3 4>;
+			};
+		};
+	};
+};
+
+spi@1392000 {
+	...
+	s5c73m3_spi: s5c73m3 {
+		compatible = "samsung,s5c73m3";
+		reg = <0>;
+		...
+	};
+};
diff --git a/drivers/media/i2c/s5c73m3/s5c73m3-core.c b/drivers/media/i2c/s5c73m3/s5c73m3-core.c
index b76ec0e..9ea10c7 100644
--- a/drivers/media/i2c/s5c73m3/s5c73m3-core.c
+++ b/drivers/media/i2c/s5c73m3/s5c73m3-core.c
@@ -15,7 +15,7 @@
  * GNU General Public License for more details.
  */
 
-#include <linux/sizes.h>
+#include <linux/clk.h>
 #include <linux/delay.h>
 #include <linux/firmware.h>
 #include <linux/gpio.h>
@@ -23,7 +23,9 @@
 #include <linux/init.h>
 #include <linux/media.h>
 #include <linux/module.h>
+#include <linux/of_gpio.h>
 #include <linux/regulator/consumer.h>
+#include <linux/sizes.h>
 #include <linux/slab.h>
 #include <linux/spi/spi.h>
 #include <linux/videodev2.h>
@@ -33,6 +35,7 @@
 #include <media/v4l2-subdev.h>
 #include <media/v4l2-mediabus.h>
 #include <media/s5c73m3.h>
+#include <media/v4l2-of.h>
 
 #include "s5c73m3.h"
 
@@ -46,6 +49,8 @@ static int update_fw;
 module_param(update_fw, int, 0644);
 
 #define S5C73M3_EMBEDDED_DATA_MAXLEN	SZ_4K
+#define S5C73M3_MIPI_DATA_LANES		4
+#define S5C73M3_CLK_NAME		"cis_extclk"
 
 static const char * const s5c73m3_supply_names[S5C73M3_MAX_SUPPLIES] = {
 	"vdd-int",	/* Digital Core supply (1.2V), CAM_ISP_CORE_1.2V */
@@ -1352,12 +1357,27 @@ static int __s5c73m3_power_on(struct s5c73m3 *state)
 {
 	int i, ret;
 
+	state->clock = clk_get(&state->i2c_client->dev, S5C73M3_CLK_NAME);
+	if (IS_ERR(state->clock))
+		return -EPROBE_DEFER;
+
 	for (i = 0; i < S5C73M3_MAX_SUPPLIES; i++) {
 		ret = regulator_enable(state->supplies[i].consumer);
 		if (ret)
-			goto err;
+			goto err_reg_dis;
 	}
 
+	ret = clk_set_rate(state->clock, state->mclk_frequency);
+	if (ret < 0)
+		goto err_reg_dis;
+
+	ret = clk_prepare_enable(state->clock);
+	if (ret < 0)
+		goto err_reg_dis;
+
+	v4l2_dbg(1, s5c73m3_dbg, &state->oif_sd, "clock frequency: %ld\n",
+					clk_get_rate(state->clock));
+
 	s5c73m3_gpio_deassert(state, STBY);
 	usleep_range(100, 200);
 
@@ -1365,7 +1385,8 @@ static int __s5c73m3_power_on(struct s5c73m3 *state)
 	usleep_range(50, 100);
 
 	return 0;
-err:
+
+err_reg_dis:
 	for (--i; i >= 0; i--)
 		regulator_disable(state->supplies[i].consumer);
 	return ret;
@@ -1380,6 +1401,9 @@ static int __s5c73m3_power_off(struct s5c73m3 *state)
 
 	if (s5c73m3_gpio_assert(state, STBY))
 		usleep_range(100, 200);
+
+	clk_disable_unprepare(state->clock);
+
 	state->streaming = 0;
 	state->isp_ready = 0;
 
@@ -1388,6 +1412,8 @@ static int __s5c73m3_power_off(struct s5c73m3 *state)
 		if (ret)
 			goto err;
 	}
+
+	clk_put(state->clock);
 	return 0;
 err:
 	for (++i; i < S5C73M3_MAX_SUPPLIES; i++) {
@@ -1396,6 +1422,8 @@ err:
 			v4l2_err(&state->oif_sd, "Failed to reenable %s: %d\n",
 				 state->supplies[i].supply, r);
 	}
+
+	clk_prepare_enable(state->clock);
 	return ret;
 }
 
@@ -1451,17 +1479,6 @@ static int s5c73m3_oif_registered(struct v4l2_subdev *sd)
 			S5C73M3_JPEG_PAD, &state->oif_sd.entity, OIF_JPEG_PAD,
 			MEDIA_LNK_FL_IMMUTABLE | MEDIA_LNK_FL_ENABLED);
 
-	mutex_lock(&state->lock);
-	ret = __s5c73m3_power_on(state);
-	if (ret == 0)
-		s5c73m3_get_fw_version(state);
-
-	__s5c73m3_power_off(state);
-	mutex_unlock(&state->lock);
-
-	v4l2_dbg(1, s5c73m3_dbg, sd, "%s: Booting %s (%d)\n",
-		 __func__, ret ? "failed" : "succeded", ret);
-
 	return ret;
 }
 
@@ -1519,41 +1536,108 @@ static const struct v4l2_subdev_ops oif_subdev_ops = {
 	.video	= &s5c73m3_oif_video_ops,
 };
 
-static int s5c73m3_configure_gpios(struct s5c73m3 *state,
-				   const struct s5c73m3_platform_data *pdata)
+static int s5c73m3_configure_gpios(struct s5c73m3 *state)
+{
+	static const char * const gpio_names[] = {
+		"S5C73M3_STBY", "S5C73M3_RST"
+	};
+	struct i2c_client *c = state->i2c_client;
+	struct s5c73m3_gpio *g = state->gpio;
+	int ret, i;
+
+	for (i = 0; i < GPIO_NUM; ++i) {
+		unsigned int flags = GPIOF_DIR_OUT;
+		if (g[i].level)
+			flags |= GPIOF_INIT_HIGH;
+		ret = devm_gpio_request_one(&c->dev, g[i].gpio, flags,
+					    gpio_names[i]);
+		if (ret) {
+			v4l2_err(c, "failed to request gpio %s\n",
+				 gpio_names[i]);
+			return ret;
+		}
+	}
+	return 0;
+}
+
+static int s5c73m3_parse_gpios(struct s5c73m3 *state)
+{
+	static const char * const prop_names[] = {
+		"standby-gpios", "xshutdown-gpios",
+	};
+	struct device *dev = &state->i2c_client->dev;
+	struct device_node *node = dev->of_node;
+	int ret, i;
+
+	for (i = 0; i < GPIO_NUM; ++i) {
+		enum of_gpio_flags of_flags;
+
+		ret = of_get_named_gpio_flags(node, prop_names[i],
+					      0, &of_flags);
+		if (ret < 0) {
+			dev_err(dev, "failed to parse %s DT property\n",
+				prop_names[i]);
+			return -EINVAL;
+		}
+		state->gpio[i].gpio = ret;
+		state->gpio[i].level = !(of_flags & OF_GPIO_ACTIVE_LOW);
+	}
+	return 0;
+}
+
+static int s5c73m3_get_platform_data(struct s5c73m3 *state)
 {
 	struct device *dev = &state->i2c_client->dev;
-	const struct s5c73m3_gpio *gpio;
-	unsigned long flags;
+	const struct s5c73m3_platform_data *pdata = dev->platform_data;
+	struct device_node *node = dev->of_node;
+	struct device_node *node_ep;
+	struct v4l2_of_endpoint ep;
 	int ret;
 
-	state->gpio[STBY].gpio = -EINVAL;
-	state->gpio[RST].gpio  = -EINVAL;
+	if (!node) {
+		if (!pdata) {
+			dev_err(dev, "Platform data not specified\n");
+			return -EINVAL;
+		}
 
-	gpio = &pdata->gpio_stby;
-	if (gpio_is_valid(gpio->gpio)) {
-		flags = (gpio->level ? GPIOF_OUT_INIT_HIGH : GPIOF_OUT_INIT_LOW)
-		      | GPIOF_EXPORT;
-		ret = devm_gpio_request_one(dev, gpio->gpio, flags,
-					    "S5C73M3_STBY");
-		if (ret < 0)
-			return ret;
+		state->mclk_frequency = pdata->mclk_frequency;
+		state->gpio[STBY] = pdata->gpio_stby;
+		state->gpio[RST] = pdata->gpio_reset;
+		return 0;
+	}
 
-		state->gpio[STBY] = *gpio;
+	if (of_property_read_u32(node, "clock-frequency",
+				 &state->mclk_frequency)) {
+		state->mclk_frequency = S5C73M3_DEFAULT_MCLK_FREQ;
+		dev_info(dev, "using default %u Hz clock frequency\n",
+					state->mclk_frequency);
 	}
 
-	gpio = &pdata->gpio_reset;
-	if (gpio_is_valid(gpio->gpio)) {
-		flags = (gpio->level ? GPIOF_OUT_INIT_HIGH : GPIOF_OUT_INIT_LOW)
-		      | GPIOF_EXPORT;
-		ret = devm_gpio_request_one(dev, gpio->gpio, flags,
-					    "S5C73M3_RST");
-		if (ret < 0)
-			return ret;
+	ret = s5c73m3_parse_gpios(state);
+	if (ret < 0)
+		return -EINVAL;
 
-		state->gpio[RST] = *gpio;
+	node_ep = v4l2_of_get_next_endpoint(node, NULL);
+	if (!node_ep) {
+		dev_warn(dev, "no endpoint defined for node: %s\n",
+						node->full_name);
+		return 0;
 	}
 
+	v4l2_of_parse_endpoint(node_ep, &ep);
+	of_node_put(node_ep);
+
+	if (ep.bus_type != V4L2_MBUS_CSI2) {
+		dev_err(dev, "unsupported bus type\n");
+		return -EINVAL;
+	}
+	/*
+	 * Number of MIPI CSI-2 data lanes is currently not configurable,
+	 * always a default value of 4 lanes is used.
+	 */
+	if (ep.bus.mipi_csi2.num_data_lanes != S5C73M3_MIPI_DATA_LANES)
+		dev_info(dev, "falling back to 4 MIPI CSI-2 data lanes\n");
+
 	return 0;
 }
 
@@ -1561,21 +1645,20 @@ static int s5c73m3_probe(struct i2c_client *client,
 				const struct i2c_device_id *id)
 {
 	struct device *dev = &client->dev;
-	const struct s5c73m3_platform_data *pdata = client->dev.platform_data;
 	struct v4l2_subdev *sd;
 	struct v4l2_subdev *oif_sd;
 	struct s5c73m3 *state;
 	int ret, i;
 
-	if (pdata == NULL) {
-		dev_err(&client->dev, "Platform data not specified\n");
-		return -EINVAL;
-	}
-
 	state = devm_kzalloc(dev, sizeof(*state), GFP_KERNEL);
 	if (!state)
 		return -ENOMEM;
 
+	state->i2c_client = client;
+	ret = s5c73m3_get_platform_data(state);
+	if (ret < 0)
+		return ret;
+
 	mutex_init(&state->lock);
 	sd = &state->sensor_sd;
 	oif_sd = &state->oif_sd;
@@ -1613,11 +1696,7 @@ static int s5c73m3_probe(struct i2c_client *client,
 	if (ret < 0)
 		return ret;
 
-	state->mclk_frequency = pdata->mclk_frequency;
-	state->bus_type = pdata->bus_type;
-	state->i2c_client = client;
-
-	ret = s5c73m3_configure_gpios(state, pdata);
+	ret = s5c73m3_configure_gpios(state);
 	if (ret)
 		goto out_err;
 
@@ -1651,9 +1730,29 @@ static int s5c73m3_probe(struct i2c_client *client,
 	if (ret < 0)
 		goto out_err;
 
+	oif_sd->dev = dev;
+
+	ret = __s5c73m3_power_on(state);
+	if (ret < 0)
+		goto out_err1;
+
+	ret = s5c73m3_get_fw_version(state);
+	__s5c73m3_power_off(state);
+
+	if (ret < 0) {
+		dev_err(dev, "Device detection failed: %d\n", ret);
+		goto out_err1;
+	}
+
+	ret = v4l2_async_register_subdev(oif_sd);
+	if (ret < 0)
+		goto out_err1;
+
 	v4l2_info(sd, "%s: completed succesfully\n", __func__);
 	return 0;
 
+out_err1:
+	s5c73m3_unregister_spi_driver(state);
 out_err:
 	media_entity_cleanup(&sd->entity);
 	return ret;
@@ -1665,7 +1764,7 @@ static int s5c73m3_remove(struct i2c_client *client)
 	struct s5c73m3 *state = oif_sd_to_s5c73m3(oif_sd);
 	struct v4l2_subdev *sensor_sd = &state->sensor_sd;
 
-	v4l2_device_unregister_subdev(oif_sd);
+	v4l2_async_unregister_subdev(oif_sd);
 
 	v4l2_ctrl_handler_free(oif_sd->ctrl_handler);
 	media_entity_cleanup(&oif_sd->entity);
@@ -1684,8 +1783,17 @@ static const struct i2c_device_id s5c73m3_id[] = {
 };
 MODULE_DEVICE_TABLE(i2c, s5c73m3_id);
 
+#ifdef CONFIG_OF
+static const struct of_device_id s5c73m3_of_match[] = {
+	{ .compatible = "samsung,s5c73m3" },
+	{ }
+};
+MODULE_DEVICE_TABLE(of, s5c73m3_of_match);
+#endif
+
 static struct i2c_driver s5c73m3_i2c_driver = {
 	.driver = {
+		.of_match_table = of_match_ptr(s5c73m3_of_match),
 		.name	= DRIVER_NAME,
 	},
 	.probe		= s5c73m3_probe,
diff --git a/drivers/media/i2c/s5c73m3/s5c73m3-spi.c b/drivers/media/i2c/s5c73m3/s5c73m3-spi.c
index 8079e26..f60b265 100644
--- a/drivers/media/i2c/s5c73m3/s5c73m3-spi.c
+++ b/drivers/media/i2c/s5c73m3/s5c73m3-spi.c
@@ -27,6 +27,11 @@
 
 #define S5C73M3_SPI_DRV_NAME "S5C73M3-SPI"
 
+static const struct of_device_id s5c73m3_spi_ids[] = {
+	{ .compatible = "samsung,s5c73m3" },
+	{ }
+};
+
 enum spi_direction {
 	SPI_DIR_RX,
 	SPI_DIR_TX
@@ -146,6 +151,7 @@ int s5c73m3_register_spi_driver(struct s5c73m3 *state)
 	spidrv->driver.name = S5C73M3_SPI_DRV_NAME;
 	spidrv->driver.bus = &spi_bus_type;
 	spidrv->driver.owner = THIS_MODULE;
+	spidrv->driver.of_match_table = s5c73m3_spi_ids;
 
 	return spi_register_driver(spidrv);
 }
diff --git a/drivers/media/i2c/s5c73m3/s5c73m3.h b/drivers/media/i2c/s5c73m3/s5c73m3.h
index 9d2c086..2917857 100644
--- a/drivers/media/i2c/s5c73m3/s5c73m3.h
+++ b/drivers/media/i2c/s5c73m3/s5c73m3.h
@@ -17,6 +17,7 @@
 #ifndef S5C73M3_H_
 #define S5C73M3_H_
 
+#include <linux/clk.h>
 #include <linux/kernel.h>
 #include <linux/regulator/consumer.h>
 #include <media/v4l2-common.h>
@@ -321,6 +322,7 @@ enum s5c73m3_oif_pads {
 
 
 #define S5C73M3_MAX_SUPPLIES			6
+#define S5C73M3_DEFAULT_MCLK_FREQ		24000000U
 
 struct s5c73m3_ctrls {
 	struct v4l2_ctrl_handler handler;
@@ -391,6 +393,8 @@ struct s5c73m3 {
 	struct regulator_bulk_data supplies[S5C73M3_MAX_SUPPLIES];
 	struct s5c73m3_gpio gpio[GPIO_NUM];
 
+	struct clk *clock;
+
 	/* External master clock frequency */
 	u32 mclk_frequency;
 	/* Video bus type - MIPI-CSI2/paralell */
-- 
1.7.9.5

