Return-path: <linux-media-owner@vger.kernel.org>
Received: from relay3-d.mail.gandi.net ([217.70.183.195]:37756 "EHLO
        relay3-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752570AbeABPEK (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 2 Jan 2018 10:04:10 -0500
From: Jacopo Mondi <jacopo+renesas@jmondi.org>
To: corbet@lwn.net, mchehab@kernel.org
Cc: Jacopo Mondi <jacopo+renesas@jmondi.org>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] v4l2: i2c: ov7670: Implement OF mbus configuration
Date: Tue,  2 Jan 2018 16:03:53 +0100
Message-Id: <1514905433-10977-1-git-send-email-jacopo+renesas@jmondi.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

ov7670 driver supports two optional properties supplied through platform
data, but currently does not support any standard video interface
property.

Add support through OF parsing for 2 generic properties (vsync and hsync
polarities) and for two custom properties already supported by platform
data.

Signed-off-by: Jacopo Mondi <jacopo+renesas@jmondi.org>
---

I have made sure signal polarities gets properly changed using a scope and
capturing images with negative polarities using CEU capture interface.
Also verified with a scope that pixel clock gets suppressed on horizontal
blankings as well when "ov7670,pclk-hb-disable" property is specified.

Thanks
   j
---

 .../devicetree/bindings/media/i2c/ov7670.txt       |  12 +++
 drivers/media/i2c/ov7670.c                         | 101 +++++++++++++++++++--
 2 files changed, 106 insertions(+), 7 deletions(-)

diff --git a/Documentation/devicetree/bindings/media/i2c/ov7670.txt b/Documentation/devicetree/bindings/media/i2c/ov7670.txt
index 826b656..c005453 100644
--- a/Documentation/devicetree/bindings/media/i2c/ov7670.txt
+++ b/Documentation/devicetree/bindings/media/i2c/ov7670.txt
@@ -9,11 +9,20 @@ Required Properties:
 - clocks: reference to the xclk input clock.
 - clock-names: should be "xclk".

+The following properties, as defined by "video-interfaces.txt", are supported:
+- hsync-active: active state of the HSYNC signal, 0/1 for LOW/HIGH respectively.
+- vsync-active: active state of the VSYNC signal, 0/1 for LOW/HIGH respectively.
+
+Default is high active state for both vsync and hsync signals.
+
 Optional Properties:
 - reset-gpios: reference to the GPIO connected to the resetb pin, if any.
   Active is low.
 - powerdown-gpios: reference to the GPIO connected to the pwdn pin, if any.
   Active is high.
+- ov7670,pll-bypass: set to 1 to bypass PLL for pixel clock generation.
+- ov7670,pclk-hb-disable: set to 1 to suppress pixel clock output signal during
+  horizontal blankings.

 The device node must contain one 'port' child node for its digital output
 video port, in accordance with the video interface bindings defined in
@@ -34,6 +43,9 @@ Example:
 			assigned-clocks = <&pck0>;
 			assigned-clock-rates = <25000000>;

+			vsync-active = <0>;
+			pclk-sample = <1>;
+
 			port {
 				ov7670_0: endpoint {
 					remote-endpoint = <&isi_0>;
diff --git a/drivers/media/i2c/ov7670.c b/drivers/media/i2c/ov7670.c
index 950a0ac..a42bee7 100644
--- a/drivers/media/i2c/ov7670.c
+++ b/drivers/media/i2c/ov7670.c
@@ -11,6 +11,7 @@
  * Public License, version 2.
  */
 #include <linux/clk.h>
+#include <linux/fwnode.h>
 #include <linux/init.h>
 #include <linux/module.h>
 #include <linux/slab.h>
@@ -21,6 +22,7 @@
 #include <linux/gpio/consumer.h>
 #include <media/v4l2-device.h>
 #include <media/v4l2-ctrls.h>
+#include <media/v4l2-fwnode.h>
 #include <media/v4l2-mediabus.h>
 #include <media/v4l2-image-sizes.h>
 #include <media/i2c/ov7670.h>
@@ -237,6 +239,7 @@ struct ov7670_info {
 	struct clk *clk;
 	struct gpio_desc *resetb_gpio;
 	struct gpio_desc *pwdn_gpio;
+	unsigned int mbus_config;	/* Media bus configuration flags */
 	int min_width;			/* Filter out smaller sizes */
 	int min_height;			/* Filter out smaller sizes */
 	int clock_speed;		/* External clock speed (MHz) */
@@ -995,7 +998,7 @@ static int ov7670_set_fmt(struct v4l2_subdev *sd,
 #ifdef CONFIG_VIDEO_V4L2_SUBDEV_API
 	struct v4l2_mbus_framefmt *mbus_fmt;
 #endif
-	unsigned char com7;
+	unsigned char com7, com10 = 0;
 	int ret;

 	if (format->pad)
@@ -1027,6 +1030,18 @@ static int ov7670_set_fmt(struct v4l2_subdev *sd,
 	com7 = ovfmt->regs[0].value;
 	com7 |= wsize->com7_bit;
 	ov7670_write(sd, REG_COM7, com7);
+
+	/*
+	 * Configure the media bus through COM10 register
+	 */
+	if (info->mbus_config & V4L2_MBUS_VSYNC_ACTIVE_LOW)
+		com10 |= COM10_VS_NEG;
+	if (info->mbus_config & V4L2_MBUS_HSYNC_ACTIVE_LOW)
+		com10 |= COM10_HREF_REV;
+	if (info->pclk_hb_disable)
+		com10 |= COM10_PCLK_HB;
+	ov7670_write(sd, REG_COM10, com10);
+
 	/*
 	 * Now write the rest of the array.  Also store start/stops
 	 */
@@ -1036,6 +1051,9 @@ static int ov7670_set_fmt(struct v4l2_subdev *sd,
 	ret = 0;
 	if (wsize->regs)
 		ret = ov7670_write_array(sd, wsize->regs);
+	if (ret)
+		return ret;
+
 	info->fmt = ovfmt;

 	/*
@@ -1048,8 +1066,10 @@ static int ov7670_set_fmt(struct v4l2_subdev *sd,
 	 * to write it unconditionally, and that will make the frame
 	 * rate persistent too.
 	 */
-	if (ret == 0)
-		ret = ov7670_write(sd, REG_CLKRC, info->clkrc);
+	ret = ov7670_write(sd, REG_CLKRC, info->clkrc);
+	if (ret)
+		return ret;
+
 	return 0;
 }

@@ -1658,6 +1678,71 @@ static int ov7670_init_gpio(struct i2c_client *client, struct ov7670_info *info)
 	return 0;
 }

+/*
+ * ov7670_parse_dt() - Parse device tree to collect mbus configuration
+ *			properties
+ */
+static int ov7670_parse_dt(struct device *dev,
+			   struct ov7670_info *info)
+{
+	struct fwnode_handle *fwnode = dev_fwnode(dev);
+	struct v4l2_fwnode_endpoint bus_cfg;
+	struct fwnode_handle *ep;
+	struct device_node *dep;
+	u32 propval;
+	int ret;
+
+	if (!fwnode)
+		return -EINVAL;
+
+	ep = fwnode_graph_get_next_endpoint(fwnode, NULL);
+	if (!ep)
+		return -EINVAL;
+
+	ret = v4l2_fwnode_endpoint_parse(ep, &bus_cfg);
+	if (ret) {
+		fwnode_handle_put(fwnode);
+		return ret;
+	}
+
+	/* Any CSI-2 property set? */
+	if (bus_cfg.bus_type != V4L2_MBUS_PARALLEL) {
+		fwnode_handle_put(fwnode);
+		return -EINVAL;
+	}
+	info->mbus_config = bus_cfg.bus.parallel.flags;
+	fwnode_handle_put(fwnode);
+
+	/* Parse custom OF properties. */
+	dep = to_of_node(ep);
+	ret = of_property_read_u32(dep, "ov7670,pclk-hb-disable", &propval);
+	if (ret < 0 && ret != -EINVAL) {
+		dev_err(dev,
+			"Unable to parse property \"ov7670,pclk-hb-disable\"\n");
+		fwnode_handle_put(ep);
+		return ret;
+	}
+	if (ret == 0 && propval)
+		info->pclk_hb_disable = true;
+	else
+		info->pclk_hb_disable = false;
+
+	ret = of_property_read_u32(dep, "ov7670,pll-bypass", &propval);
+	if (ret < 0 && ret != -EINVAL) {
+		dev_err(dev,
+			"Unable to parse property \"ov7670,pll-bypass\"\n");
+		fwnode_handle_put(ep);
+		return ret;
+	}
+	if (ret == 0 && propval)
+		info->pll_bypass = true;
+	else
+		info->pll_bypass = false;
+
+	fwnode_handle_put(ep);
+	return 0;
+}
+
 static int ov7670_probe(struct i2c_client *client,
 			const struct i2c_device_id *id)
 {
@@ -1678,7 +1763,12 @@ static int ov7670_probe(struct i2c_client *client,
 #endif

 	info->clock_speed = 30; /* default: a guess */
-	if (client->dev.platform_data) {
+
+	if (IS_ENABLED(CONFIG_OF) && client->dev.of_node) {
+		ret = ov7670_parse_dt(&client->dev, info);
+		if (ret)
+			return ret;
+	} else if (client->dev.platform_data) {
 		struct ov7670_config *config = client->dev.platform_data;

 		/*
@@ -1745,9 +1835,6 @@ static int ov7670_probe(struct i2c_client *client,
 	tpf.denominator = 30;
 	info->devtype->set_framerate(sd, &tpf);

-	if (info->pclk_hb_disable)
-		ov7670_write(sd, REG_COM10, COM10_PCLK_HB);
-
 	v4l2_ctrl_handler_init(&info->hdl, 10);
 	v4l2_ctrl_new_std(&info->hdl, &ov7670_ctrl_ops,
 			V4L2_CID_BRIGHTNESS, 0, 255, 1, 128);
--
2.7.4
