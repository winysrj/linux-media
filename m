Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.samsung.com ([203.254.224.33]:43873 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752619AbaCFQWK (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 6 Mar 2014 11:22:10 -0500
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
To: linux-media@vger.kernel.org, devicetree@vger.kernel.org
Cc: linux-samsung-soc@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, robh+dt@kernel.org,
	mark.rutland@arm.com, galak@codeaurora.org,
	kyungmin.park@samsung.com, kgene.kim@samsung.com,
	a.hajda@samsung.com, Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [PATCH v6 05/10] V4L: s5c73m3: Add device tree support
Date: Thu, 06 Mar 2014 17:20:14 +0100
Message-id: <1394122819-9582-6-git-send-email-s.nawrocki@samsung.com>
In-reply-to: <1394122819-9582-1-git-send-email-s.nawrocki@samsung.com>
References: <1394122819-9582-1-git-send-email-s.nawrocki@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch adds the V4L2 asynchronous subdev registration and
device tree support. Common clock API is used to control the
sensor master clock from within the subdev.

Signed-off-by: Andrzej Hajda <a.hajda@samsung.com>
Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
---
Changes since v5:
  - none.

Changes since v3:
 - move clk_get from subdev s_power() to driver probe() callback and
   make it devm_clk_get(),
 - pass any errors from dev_clk_get() through, rather than overwriting
   with EPROBE_DEFER. Patch [1] is required for things to work correctly
   after this change.

   [1] http://www.spinics.net/lists/arm-kernel/msg306072.html
---
 drivers/media/i2c/s5c73m3/s5c73m3-core.c |  207 ++++++++++++++++++++++--------
 drivers/media/i2c/s5c73m3/s5c73m3-spi.c  |    6 +
 drivers/media/i2c/s5c73m3/s5c73m3.h      |    4 +
 3 files changed, 167 insertions(+), 50 deletions(-)

diff --git a/drivers/media/i2c/s5c73m3/s5c73m3-core.c b/drivers/media/i2c/s5c73m3/s5c73m3-core.c
index e7f555c..a445930 100644
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
@@ -1355,9 +1360,20 @@ static int __s5c73m3_power_on(struct s5c73m3 *state)
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
 
@@ -1365,7 +1381,8 @@ static int __s5c73m3_power_on(struct s5c73m3 *state)
 	usleep_range(50, 100);
 
 	return 0;
-err:
+
+err_reg_dis:
 	for (--i; i >= 0; i--)
 		regulator_disable(state->supplies[i].consumer);
 	return ret;
@@ -1380,6 +1397,9 @@ static int __s5c73m3_power_off(struct s5c73m3 *state)
 
 	if (s5c73m3_gpio_assert(state, STBY))
 		usleep_range(100, 200);
+
+	clk_disable_unprepare(state->clock);
+
 	state->streaming = 0;
 	state->isp_ready = 0;
 
@@ -1388,6 +1408,7 @@ static int __s5c73m3_power_off(struct s5c73m3 *state)
 		if (ret)
 			goto err;
 	}
+
 	return 0;
 err:
 	for (++i; i < S5C73M3_MAX_SUPPLIES; i++) {
@@ -1396,6 +1417,8 @@ err:
 			v4l2_err(&state->oif_sd, "Failed to reenable %s: %d\n",
 				 state->supplies[i].supply, r);
 	}
+
+	clk_prepare_enable(state->clock);
 	return ret;
 }
 
@@ -1451,17 +1474,6 @@ static int s5c73m3_oif_registered(struct v4l2_subdev *sd)
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
-		 __func__, ret ? "failed" : "succeeded", ret);
-
 	return ret;
 }
 
@@ -1519,41 +1531,112 @@ static const struct v4l2_subdev_ops oif_subdev_ops = {
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
+
+	state->clock = devm_clk_get(dev, S5C73M3_CLK_NAME);
+	if (IS_ERR(state->clock))
+		return PTR_ERR(state->clock);
 
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
 
@@ -1561,21 +1644,20 @@ static int s5c73m3_probe(struct i2c_client *client,
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
@@ -1613,11 +1695,7 @@ static int s5c73m3_probe(struct i2c_client *client,
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
 
@@ -1651,9 +1729,29 @@ static int s5c73m3_probe(struct i2c_client *client,
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
 	v4l2_info(sd, "%s: completed successfully\n", __func__);
 	return 0;
 
+out_err1:
+	s5c73m3_unregister_spi_driver(state);
 out_err:
 	media_entity_cleanup(&sd->entity);
 	return ret;
@@ -1665,7 +1763,7 @@ static int s5c73m3_remove(struct i2c_client *client)
 	struct s5c73m3 *state = oif_sd_to_s5c73m3(oif_sd);
 	struct v4l2_subdev *sensor_sd = &state->sensor_sd;
 
-	v4l2_device_unregister_subdev(oif_sd);
+	v4l2_async_unregister_subdev(oif_sd);
 
 	v4l2_ctrl_handler_free(oif_sd->ctrl_handler);
 	media_entity_cleanup(&oif_sd->entity);
@@ -1684,8 +1782,17 @@ static const struct i2c_device_id s5c73m3_id[] = {
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
index 9dfa516..9656b67 100644
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
 	/* Video bus type - MIPI-CSI2/parallel */
-- 
1.7.9.5

