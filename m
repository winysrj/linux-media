Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:56428 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932244AbbGJNLt (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 10 Jul 2015 09:11:49 -0400
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Mats Randgaard <matrandg@cisco.com>
Cc: linux-media@vger.kernel.org, devicetree@vger.kernel.org,
	kernel@pengutronix.de, Philipp Zabel <p.zabel@pengutronix.de>
Subject: [PATCH 3/5] [media] tc358743: support probe from device tree
Date: Fri, 10 Jul 2015 15:11:35 +0200
Message-Id: <1436533897-3060-3-git-send-email-p.zabel@pengutronix.de>
In-Reply-To: <1436533897-3060-1-git-send-email-p.zabel@pengutronix.de>
References: <1436533897-3060-1-git-send-email-p.zabel@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add support for probing the TC358743 subdevice from device tree.
The reference clock must be supplied using the common clock bindings.
MIPI CSI-2 specific properties are parsed from the OF graph endpoint
node and support for a non-continuous MIPI CSI-2 clock is added.

Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
---
 .../devicetree/bindings/media/i2c/tc358743.txt     |  48 +++++++
 drivers/media/i2c/tc358743.c                       | 153 ++++++++++++++++++++-
 2 files changed, 195 insertions(+), 6 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/media/i2c/tc358743.txt

diff --git a/Documentation/devicetree/bindings/media/i2c/tc358743.txt b/Documentation/devicetree/bindings/media/i2c/tc358743.txt
new file mode 100644
index 0000000..5218921
--- /dev/null
+++ b/Documentation/devicetree/bindings/media/i2c/tc358743.txt
@@ -0,0 +1,48 @@
+* Toshiba TC358743 HDMI-RX to MIPI CSI2-TX Bridge
+
+The Toshiba TC358743 HDMI-RX to MIPI CSI2-TX (H2C) is a bridge that converts
+a HDMI stream to MIPI CSI-2 TX. It is programmable through I2C.
+
+Required Properties:
+
+- compatible: value should be "toshiba,tc358743"
+- clocks, clock-names: should contain a phandle link to the reference clock
+		       source, the clock input is named "refclk".
+
+Optional Properties:
+
+- reset-gpios: gpio phandle GPIO connected to the reset pin
+- interrupts, interrupt-parent: GPIO connected to the interrupt pin
+- data-lanes: should be <1 2 3 4> for four-lane operation,
+	      or <1 2> for two-lane operation
+- clock-lanes: should be <0>
+- clock-noncontinuous: Presence of this boolean property decides whether the
+		       MIPI CSI-2 clock is continuous or non-continuous.
+- link-frequencies: List of allowed link frequencies in Hz. Each frequency is
+		    expressed as a 64-bit big-endian integer. The frequency
+		    is half of the bps per lane due to DDR transmission.
+
+For further information on the MIPI CSI-2 endpoint node properties, see
+Documentation/devicetree/bindings/media/video-interfaces.txt.
+
+Example:
+
+	tc358743@0f {
+		compatible = "toshiba,tc358743";
+		reg = <0x0f>;
+		clocks = <&hdmi_osc>;
+		clock-names = "refclk";
+		reset-gpios = <&gpio6 9 GPIO_ACTIVE_LOW>;
+		interrupt-parent = <&gpio2>;
+		interrupts = <5 IRQ_TYPE_LEVEL_HIGH>;
+
+		port {
+			tc358743_out: endpoint {
+				remote-endpoint = <&mipi_csi2_in>;
+				data-lanes = <1 2 3 4>;
+				clock-lanes = <0>;
+				clock-noncontinuous;
+				link-frequencies = /bits/ 64 <297000000>;
+			};
+		};
+	};
diff --git a/drivers/media/i2c/tc358743.c b/drivers/media/i2c/tc358743.c
index 0be6d9f..02c60b3 100644
--- a/drivers/media/i2c/tc358743.c
+++ b/drivers/media/i2c/tc358743.c
@@ -29,7 +29,9 @@
 #include <linux/module.h>
 #include <linux/slab.h>
 #include <linux/i2c.h>
+#include <linux/clk.h>
 #include <linux/delay.h>
+#include <linux/gpio/consumer.h>
 #include <linux/videodev2.h>
 #include <linux/workqueue.h>
 #include <linux/v4l2-dv-timings.h>
@@ -37,6 +39,7 @@
 #include <media/v4l2-dv-timings.h>
 #include <media/v4l2-device.h>
 #include <media/v4l2-ctrls.h>
+#include <media/v4l2-of.h>
 #include <media/tc358743.h>
 
 #include "tc358743_regs.h"
@@ -69,6 +72,7 @@ static const struct v4l2_dv_timings_cap tc358743_timings_cap = {
 
 struct tc358743_state {
 	struct tc358743_platform_data pdata;
+	struct v4l2_of_bus_mipi_csi2 bus;
 	struct v4l2_subdev sd;
 	struct media_pad pad;
 	struct v4l2_ctrl_handler hdl;
@@ -90,6 +94,8 @@ struct tc358743_state {
 
 	struct v4l2_dv_timings timings;
 	u32 mbus_fmt_code;
+
+	struct gpio_desc *reset_gpio;
 };
 
 static void tc358743_enable_interrupts(struct v4l2_subdev *sd,
@@ -700,7 +706,8 @@ static void tc358743_set_csi(struct v4l2_subdev *sd)
 			((lanes > 2) ? MASK_D2M_HSTXVREGEN : 0x0) |
 			((lanes > 3) ? MASK_D3M_HSTXVREGEN : 0x0));
 
-	i2c_wr32(sd, TXOPTIONCNTRL, MASK_CONTCLKMODE);
+	i2c_wr32(sd, TXOPTIONCNTRL, (state->bus.flags &
+		 V4L2_MBUS_CSI2_CONTINUOUS_CLOCK) ? MASK_CONTCLKMODE : 0);
 	i2c_wr32(sd, STARTCNTRL, MASK_START);
 	i2c_wr32(sd, CSI_START, MASK_STRT);
 
@@ -1638,6 +1645,135 @@ static const struct v4l2_ctrl_config tc358743_ctrl_audio_present = {
 
 /* --------------- PROBE / REMOVE --------------- */
 
+#if CONFIG_OF
+static void tc358743_gpio_reset(struct tc358743_state *state)
+{
+	gpiod_set_value(state->reset_gpio, 0);
+	usleep_range(5000, 10000);
+	gpiod_set_value(state->reset_gpio, 1);
+	usleep_range(1000, 2000);
+	gpiod_set_value(state->reset_gpio, 0);
+	msleep(20);
+}
+
+static int tc358743_probe_of(struct tc358743_state *state)
+{
+	struct device *dev = &state->i2c_client->dev;
+	struct device_node *np = dev->of_node;
+	struct v4l2_of_endpoint *endpoint;
+	struct device_node *ep;
+	struct clk *refclk;
+	u32 bps_pr_lane;
+	int ret = -EINVAL;
+
+	refclk = devm_clk_get(dev, "refclk");
+	if (IS_ERR(refclk)) {
+		if (PTR_ERR(refclk) != -EPROBE_DEFER)
+			dev_err(dev, "failed to get refclk: %ld\n",
+				PTR_ERR(refclk));
+		return PTR_ERR(refclk);
+	}
+
+	ep = of_graph_get_next_endpoint(dev->of_node, NULL);
+	if (!ep) {
+		dev_err(dev, "missing endpoint node\n");
+		return -EINVAL;
+	}
+
+	endpoint = v4l2_of_alloc_parse_endpoint(ep);
+	if (IS_ERR(endpoint)) {
+		dev_err(dev, "failed to parse endpoint\n");
+		return PTR_ERR(endpoint);
+	}
+
+	if (endpoint->bus_type != V4L2_MBUS_CSI2 ||
+	    endpoint->bus.mipi_csi2.num_data_lanes == 0 ||
+	    endpoint->nr_of_link_frequencies == 0) {
+		dev_err(dev, "missing CSI-2 properties in endpoint\n");
+		goto free_endpoint;
+	}
+
+	clk_prepare_enable(refclk);
+
+	state->pdata.refclk_hz = clk_get_rate(refclk);
+	state->pdata.ddc5v_delay = DDC5V_DELAY_100_MS;
+	state->pdata.enable_hdcp = false;
+	/* A FIFO level of 16 should be enough for 2-lane 720p60 at 594 MHz. */
+	state->pdata.fifo_level = 16;
+	/*
+	 * The PLL input clock is obtained by dividing refclk by pll_prd.
+	 * It must be between 6 MHz and 40 MHz, lower frequency is better.
+	 */
+	switch (state->pdata.refclk_hz) {
+	case 26000000:
+	case 27000000:
+	case 42000000:
+		state->pdata.pll_prd = state->pdata.refclk_hz / 6000000;
+		break;
+	default:
+		dev_err(dev, "unsupported refclk rate: %u Hz\n",
+			state->pdata.refclk_hz);
+		goto disable_clk;
+	}
+
+	/*
+	 * The CSI bps per lane must be between 62.5 Mbps and 1 Gbps.
+	 * The default is 594 Mbps for 4-lane 1080p60 or 2-lane 720p60.
+	 */
+	bps_pr_lane = 2 * endpoint->link_frequencies[0];
+	if (bps_pr_lane < 62500000U || bps_pr_lane > 1000000000U) {
+		dev_err(dev, "unsupported bps per lane: %u bps\n", bps_pr_lane);
+		goto disable_clk;
+	}
+
+	/* The CSI speed per lane is refclk / pll_prd * pll_fbd */
+	state->pdata.pll_fbd = bps_pr_lane /
+			       state->pdata.refclk_hz * state->pdata.pll_prd;
+
+	/*
+	 * FIXME: These timings are from REF_02 for 594 Mbps per lane (297 MHz
+	 * link frequency). In principle it should be possible to calculate
+	 * them based on link frequency and resolution.
+	 */
+	if (bps_pr_lane != 594000000U)
+		dev_warn(dev, "untested bps per lane: %u bps\n", bps_pr_lane);
+	state->pdata.lineinitcnt = 0xe80;
+	state->pdata.lptxtimecnt = 0x003;
+	/* tclk-preparecnt: 3, tclk-zerocnt: 20 */
+	state->pdata.tclk_headercnt = 0x1403;
+	state->pdata.tclk_trailcnt = 0x00;
+	/* ths-preparecnt: 3, ths-zerocnt: 1 */
+	state->pdata.ths_headercnt = 0x0103;
+	state->pdata.twakeup = 0x4882;
+	state->pdata.tclk_postcnt = 0x008;
+	state->pdata.ths_trailcnt = 0x2;
+	state->pdata.hstxvregcnt = 0;
+
+	state->reset_gpio = devm_gpiod_get(dev, "reset");
+	if (IS_ERR(state->reset_gpio)) {
+		dev_err(dev, "failed to get reset gpio\n");
+		ret = PTR_ERR(state->reset_gpio);
+		goto disable_clk;
+	}
+
+	tc358743_gpio_reset(state);
+
+	ret = 0;
+	goto free_endpoint;
+
+disable_clk:
+	clk_disable_unprepare(refclk);
+free_endpoint:
+	v4l2_of_free_endpoint(endpoint);
+	return ret;
+}
+#else
+static inline int tc358743_probe_of(struct tc358743_state *state)
+{
+	return -ENODEV;
+}
+#endif
+
 static int tc358743_probe(struct i2c_client *client,
 			  const struct i2c_device_id *id)
 {
@@ -1658,14 +1794,19 @@ static int tc358743_probe(struct i2c_client *client,
 	if (!state)
 		return -ENOMEM;
 
+	state->i2c_client = client;
+
 	/* platform data */
-	if (!pdata) {
-		v4l_err(client, "No platform data!\n");
-		return -ENODEV;
+	if (pdata) {
+		state->pdata = *pdata;
+	} else {
+		err = tc358743_probe_of(state);
+		if (err == -ENODEV)
+			v4l_err(client, "No platform data!\n");
+		if (err)
+			return err;
 	}
-	state->pdata = *pdata;
 
-	state->i2c_client = client;
 	sd = &state->sd;
 	v4l2_i2c_subdev_init(sd, client, &tc358743_ops);
 	sd->flags |= V4L2_SUBDEV_FL_HAS_DEVNODE | V4L2_SUBDEV_FL_HAS_EVENTS;
-- 
2.1.4

