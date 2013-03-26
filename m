Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.samsung.com ([203.254.224.25]:16892 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965733Ab3CZQkS (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 26 Mar 2013 12:40:18 -0400
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
To: linux-media@vger.kernel.org
Cc: kyungmin.park@samsung.com, myungjoo.ham@samsung.com,
	dh09.lee@samsung.com, shaik.samsung@gmail.com, arun.kk@samsung.com,
	a.hajda@samsung.com, linux-samsung-soc@vger.kernel.org,
	devicetree-discuss@lists.ozlabs.org,
	Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [PATCH v5 1/6] s5p-csis: Add device tree support
Date: Tue, 26 Mar 2013 17:39:53 +0100
Message-id: <1364315998-19372-2-git-send-email-s.nawrocki@samsung.com>
In-reply-to: <1364315998-19372-1-git-send-email-s.nawrocki@samsung.com>
References: <1364315998-19372-1-git-send-email-s.nawrocki@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch support for binding the driver to the MIPI-CSIS
devices instantiated from device tree and parsing the SoC
and board specific properties. The MIPI CSI-2 channel is
determined by the value of reg property placed in csis'
port subnode.

Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---

Changes since v5:
 - added clocks/clock-names properties to the binding documentation.

Changes since v4:
 - dropped node aliases, the IP instances are now identified
   by the port's node reg property value; as a side effect this
   introduces dependency on the s5p_fimc.h header,
 - re-added bus-width property, so the number of data lanes
   supported per each IP instance can be specified in the
   device tree,
 - the bindings documentation moved to Documentation/
   devicetree/bindings/media/samsung-mipi-csis.txt.
 - "samsung,exynos3110-csis" renamed to "samsung,s5pv210-csis",
   updated the bindings documentation.

Changes since v3:
 - dropped 'bus-width' property, hard coded the number of supported
   data lanes per device also in dt case, it can be derived from the
   compatible property if required;
 - "samsung,s5pv210-csis" renamed to "samsung,exynos3110-csis",
   updated the bindings description.
---
 .../bindings/media/samsung-mipi-csis.txt           |   81 ++++++++++
 drivers/media/platform/s5p-fimc/mipi-csis.c        |  155 +++++++++++++++-----
 drivers/media/platform/s5p-fimc/mipi-csis.h        |    1 +
 include/media/s5p_fimc.h                           |   13 ++
 4 files changed, 215 insertions(+), 35 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/media/samsung-mipi-csis.txt

diff --git a/Documentation/devicetree/bindings/media/samsung-mipi-csis.txt b/Documentation/devicetree/bindings/media/samsung-mipi-csis.txt
new file mode 100644
index 0000000..5f8e28e
--- /dev/null
+++ b/Documentation/devicetree/bindings/media/samsung-mipi-csis.txt
@@ -0,0 +1,81 @@
+Samsung S5P/EXYNOS SoC series MIPI CSI-2 receiver (MIPI CSIS)
+-------------------------------------------------------------
+
+Required properties:
+
+- compatible	  : "samsung,s5pv210-csis" for S5PV210 (S5PC110),
+		    "samsung,exynos4210-csis" for Exynos4210 (S5PC210),
+		    "samsung,exynos4212-csis" for Exynos4212/Exynos4412
+		    SoC series;
+- reg		  : offset and length of the register set for the device;
+- interrupts      : should contain MIPI CSIS interrupt; the format of the
+		    interrupt specifier depends on the interrupt controller;
+- bus-width	  : maximum number of data lanes supported (SoC specific);
+- vddio-supply    : MIPI CSIS I/O and PLL voltage supply (e.g. 1.8V);
+- vddcore-supply  : MIPI CSIS Core voltage supply (e.g. 1.1V);
+- clocks	  : list of clock specifiers, corresponding to entries in
+		    clock-names property;
+- clock-names	  : must contain "csis", "sclk_csis" entries, matching entries
+		    in the clocks property.
+
+Optional properties:
+
+- clock-frequency : The IP's main (system bus) clock frequency in Hz, default
+		    value when this property is not specified is 166 MHz;
+- samsung,csis-wclk : CSI-2 wrapper clock selection. If this property is present
+		    external clock from CMU will be used, or the bus clock if
+		    if it's not specified.
+
+The device node should contain one 'port' child node with one child 'endpoint'
+node, according to the bindings defined in Documentation/devicetree/bindings/
+media/video-interfaces.txt. The following are properties specific to those nodes.
+
+port node
+---------
+
+- reg		  : (required) must be 3 for camera C input (CSIS0) or 4 for
+		    camera D input (CSIS1);
+
+endpoint node
+-------------
+
+- data-lanes	  : (required) an array specifying active physical MIPI-CSI2
+		    data input lanes and their mapping to logical lanes; the
+		    array's content is unused, only its length is meaningful;
+
+- samsung,csis-hs-settle : (optional) differential receiver (HS-RX) settle time;
+
+
+Example:
+
+	reg0: regulator@0 {
+	};
+
+	reg1: regulator@1 {
+	};
+
+/* SoC properties */
+
+	csis_0: csis@11880000 {
+		compatible = "samsung,exynos4210-csis";
+		reg = <0x11880000 0x1000>;
+		interrupts = <0 78 0>;
+		#address-cells = <1>;
+		#size-cells = <0>;
+	};
+
+/* Board properties */
+
+	csis_0: csis@11880000 {
+		clock-frequency = <166000000>;
+		vddio-supply = <&reg0>;
+		vddcore-supply = <&reg1>;
+		port {
+			reg = <3>; /* 3 - CSIS0, 4 - CSIS1 */
+			csis0_ep: endpoint {
+				remote-endpoint = <...>;
+				data-lanes = <1>, <2>;
+				samsung,csis-hs-settle = <12>;
+			};
+		};
+	};
diff --git a/drivers/media/platform/s5p-fimc/mipi-csis.c b/drivers/media/platform/s5p-fimc/mipi-csis.c
index 981863d..8636bcd 100644
--- a/drivers/media/platform/s5p-fimc/mipi-csis.c
+++ b/drivers/media/platform/s5p-fimc/mipi-csis.c
@@ -19,14 +19,18 @@
 #include <linux/kernel.h>
 #include <linux/memory.h>
 #include <linux/module.h>
+#include <linux/of.h>
+#include <linux/platform_data/mipi-csis.h>
 #include <linux/platform_device.h>
 #include <linux/pm_runtime.h>
 #include <linux/regulator/consumer.h>
 #include <linux/slab.h>
 #include <linux/spinlock.h>
 #include <linux/videodev2.h>
+#include <media/s5p_fimc.h>
+#include <media/v4l2-of.h>
 #include <media/v4l2-subdev.h>
-#include <linux/platform_data/mipi-csis.h>
+
 #include "mipi-csis.h"
 
 static int debug;
@@ -113,6 +117,7 @@ static char *csi_clock_name[] = {
 	[CSIS_CLK_GATE] = "csis",
 };
 #define NUM_CSIS_CLOCKS	ARRAY_SIZE(csi_clock_name)
+#define DEFAULT_SCLK_CSIS_FREQ	166000000UL
 
 static const char * const csis_supply_name[] = {
 	"vddcore",  /* CSIS Core (1.0V, 1.1V or 1.2V) suppply */
@@ -167,6 +172,11 @@ struct csis_pktbuf {
  * @clock: CSIS clocks
  * @irq: requested s5p-mipi-csis irq number
  * @flags: the state variable for power and streaming control
+ * @clock_frequency: device bus clock frequency
+ * @hs_settle: HS-RX settle time
+ * @num_lanes: number of MIPI-CSI data lanes used
+ * @max_num_lanes: maximum number of MIPI-CSI data lanes supported
+ * @wclk_ext: CSI wrapper clock: 0 - bus clock, 1 - external SCLK_CAM
  * @csis_fmt: current CSIS pixel format
  * @format: common media bus format for the source and sink pad
  * @slock: spinlock protecting structure members below
@@ -184,6 +194,13 @@ struct csis_state {
 	struct clk *clock[NUM_CSIS_CLOCKS];
 	int irq;
 	u32 flags;
+
+	u32 clk_frequency;
+	u32 hs_settle;
+	u32 num_lanes;
+	u32 max_num_lanes;
+	u8 wclk_ext;
+
 	const struct csis_pix_format *csis_fmt;
 	struct v4l2_mbus_framefmt format;
 
@@ -273,7 +290,6 @@ static void s5pcsis_reset(struct csis_state *state)
 
 static void s5pcsis_system_enable(struct csis_state *state, int on)
 {
-	struct s5p_platform_mipi_csis *pdata = state->pdev->dev.platform_data;
 	u32 val, mask;
 
 	val = s5pcsis_read(state, S5PCSIS_CTRL);
@@ -286,7 +302,7 @@ static void s5pcsis_system_enable(struct csis_state *state, int on)
 	val = s5pcsis_read(state, S5PCSIS_DPHYCTRL);
 	val &= ~S5PCSIS_DPHYCTRL_ENABLE;
 	if (on) {
-		mask = (1 << (pdata->lanes + 1)) - 1;
+		mask = (1 << (state->num_lanes + 1)) - 1;
 		val |= (mask & S5PCSIS_DPHYCTRL_ENABLE);
 	}
 	s5pcsis_write(state, S5PCSIS_DPHYCTRL, val);
@@ -321,15 +337,14 @@ static void s5pcsis_set_hsync_settle(struct csis_state *state, int settle)
 
 static void s5pcsis_set_params(struct csis_state *state)
 {
-	struct s5p_platform_mipi_csis *pdata = state->pdev->dev.platform_data;
 	u32 val;
 
 	val = s5pcsis_read(state, S5PCSIS_CONFIG);
-	val = (val & ~S5PCSIS_CFG_NR_LANE_MASK) | (pdata->lanes - 1);
+	val = (val & ~S5PCSIS_CFG_NR_LANE_MASK) | (state->num_lanes - 1);
 	s5pcsis_write(state, S5PCSIS_CONFIG, val);
 
 	__s5pcsis_set_format(state);
-	s5pcsis_set_hsync_settle(state, pdata->hs_settle);
+	s5pcsis_set_hsync_settle(state, state->hs_settle);
 
 	val = s5pcsis_read(state, S5PCSIS_CTRL);
 	if (state->csis_fmt->data_alignment == 32)
@@ -338,7 +353,7 @@ static void s5pcsis_set_params(struct csis_state *state)
 		val &= ~S5PCSIS_CTRL_ALIGN_32BIT;
 
 	val &= ~S5PCSIS_CTRL_WCLK_EXTCLK;
-	if (pdata->wclk_source)
+	if (state->wclk_ext)
 		val |= S5PCSIS_CTRL_WCLK_EXTCLK;
 	s5pcsis_write(state, S5PCSIS_CTRL, val);
 
@@ -701,52 +716,111 @@ static irqreturn_t s5pcsis_irq_handler(int irq, void *dev_id)
 	return IRQ_HANDLED;
 }
 
+static int s5pcsis_get_platform_data(struct platform_device *pdev,
+				     struct csis_state *state)
+{
+	struct s5p_platform_mipi_csis *pdata = pdev->dev.platform_data;
+
+	if (pdata == NULL) {
+		dev_err(&pdev->dev, "Platform data not specified\n");
+		return -EINVAL;
+	}
+
+	state->clk_frequency = pdata->clk_rate;
+	state->num_lanes = pdata->lanes;
+	state->hs_settle = pdata->hs_settle;
+	state->index = max(0, pdev->id);
+	state->max_num_lanes = state->index ? CSIS1_MAX_LANES :
+					      CSIS0_MAX_LANES;
+	return 0;
+}
+
+#ifdef CONFIG_OF
+static int s5pcsis_parse_dt(struct platform_device *pdev,
+			    struct csis_state *state)
+{
+	struct device_node *node = pdev->dev.of_node;
+	struct v4l2_of_endpoint endpoint;
+
+	if (of_property_read_u32(node, "clock-frequency",
+				 &state->clk_frequency))
+		state->clk_frequency = DEFAULT_SCLK_CSIS_FREQ;
+	if (of_property_read_u32(node, "bus-width",
+				 &state->max_num_lanes))
+		return -EINVAL;
+
+	node = v4l2_of_get_next_endpoint(node, NULL);
+	if (!node) {
+		dev_err(&pdev->dev, "No port node at %s\n",
+					node->full_name);
+		return -EINVAL;
+	}
+	/* Get port node and validate MIPI-CSI channel id. */
+	v4l2_of_parse_endpoint(node, &endpoint);
+
+	state->index = endpoint.port - FIMC_INPUT_MIPI_CSI2_0;
+	if (state->index < 0 || state->index >= CSIS_MAX_ENTITIES)
+		return -ENXIO;
+
+	/* Get MIPI CSI-2 bus configration from the endpoint node. */
+	of_property_read_u32(node, "samsung,csis-hs-settle",
+					&state->hs_settle);
+	state->wclk_ext = of_property_read_bool(node,
+					"samsung,csis-wclk");
+
+	state->num_lanes = endpoint.bus.mipi_csi2.num_data_lanes;
+
+	of_node_put(node);
+	return 0;
+}
+#else
+#define s5pcsis_parse_dt(pdev, state) (-ENOSYS)
+#endif
+
 static int s5pcsis_probe(struct platform_device *pdev)
 {
-	struct s5p_platform_mipi_csis *pdata;
+	struct device *dev = &pdev->dev;
 	struct resource *mem_res;
 	struct csis_state *state;
 	int ret = -ENOMEM;
 	int i;
 
-	state = devm_kzalloc(&pdev->dev, sizeof(*state), GFP_KERNEL);
+	state = devm_kzalloc(dev, sizeof(*state), GFP_KERNEL);
 	if (!state)
 		return -ENOMEM;
 
 	mutex_init(&state->lock);
 	spin_lock_init(&state->slock);
-
 	state->pdev = pdev;
-	state->index = max(0, pdev->id);
 
-	pdata = pdev->dev.platform_data;
-	if (pdata == NULL) {
-		dev_err(&pdev->dev, "Platform data not fully specified\n");
-		return -EINVAL;
-	}
+	if (dev->of_node)
+		ret = s5pcsis_parse_dt(pdev, state);
+	else
+		ret = s5pcsis_get_platform_data(pdev, state);
+	if (ret < 0)
+		return ret;
 
-	if ((state->index == 1 && pdata->lanes > CSIS1_MAX_LANES) ||
-	    pdata->lanes > CSIS0_MAX_LANES) {
-		dev_err(&pdev->dev, "Unsupported number of data lanes: %d\n",
-			pdata->lanes);
+	if (state->num_lanes == 0 || state->num_lanes > state->max_num_lanes) {
+		dev_err(dev, "Unsupported number of data lanes: %d (max. %d)\n",
+			state->num_lanes, state->max_num_lanes);
 		return -EINVAL;
 	}
 
 	mem_res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	state->regs = devm_ioremap_resource(&pdev->dev, mem_res);
+	state->regs = devm_ioremap_resource(dev, mem_res);
 	if (IS_ERR(state->regs))
 		return PTR_ERR(state->regs);
 
 	state->irq = platform_get_irq(pdev, 0);
 	if (state->irq < 0) {
-		dev_err(&pdev->dev, "Failed to get irq\n");
+		dev_err(dev, "Failed to get irq\n");
 		return state->irq;
 	}
 
 	for (i = 0; i < CSIS_NUM_SUPPLIES; i++)
 		state->supplies[i].supply = csis_supply_name[i];
 
-	ret = devm_regulator_bulk_get(&pdev->dev, CSIS_NUM_SUPPLIES,
+	ret = devm_regulator_bulk_get(dev, CSIS_NUM_SUPPLIES,
 				 state->supplies);
 	if (ret)
 		return ret;
@@ -755,11 +829,11 @@ static int s5pcsis_probe(struct platform_device *pdev)
 	if (ret < 0)
 		return ret;
 
-	if (pdata->clk_rate)
+	if (state->clk_frequency)
 		ret = clk_set_rate(state->clock[CSIS_CLK_MUX],
-				   pdata->clk_rate);
+				   state->clk_frequency);
 	else
-		dev_WARN(&pdev->dev, "No clock frequency specified!\n");
+		dev_WARN(dev, "No clock frequency specified!\n");
 	if (ret < 0)
 		goto e_clkput;
 
@@ -767,16 +841,17 @@ static int s5pcsis_probe(struct platform_device *pdev)
 	if (ret < 0)
 		goto e_clkput;
 
-	ret = devm_request_irq(&pdev->dev, state->irq, s5pcsis_irq_handler,
-			       0, dev_name(&pdev->dev), state);
+	ret = devm_request_irq(dev, state->irq, s5pcsis_irq_handler,
+			       0, dev_name(dev), state);
 	if (ret) {
-		dev_err(&pdev->dev, "Interrupt request failed\n");
+		dev_err(dev, "Interrupt request failed\n");
 		goto e_clkdis;
 	}
 
 	v4l2_subdev_init(&state->sd, &s5pcsis_subdev_ops);
 	state->sd.owner = THIS_MODULE;
-	strlcpy(state->sd.name, dev_name(&pdev->dev), sizeof(state->sd.name));
+	snprintf(state->sd.name, sizeof(state->sd.name), "%s.%d",
+		 CSIS_SUBDEV_NAME, state->index);
 	state->sd.flags |= V4L2_SUBDEV_FL_HAS_DEVNODE;
 	state->csis_fmt = &s5pcsis_formats[0];
 
@@ -796,10 +871,12 @@ static int s5pcsis_probe(struct platform_device *pdev)
 
 	/* .. and a pointer to the subdev. */
 	platform_set_drvdata(pdev, &state->sd);
-
 	memcpy(state->events, s5pcsis_events, sizeof(state->events));
+	pm_runtime_enable(dev);
 
-	pm_runtime_enable(&pdev->dev);
+	dev_info(&pdev->dev, "lanes: %d, hs_settle: %d, wclk: %d, freq: %u\n",
+		 state->num_lanes, state->hs_settle, state->wclk_ext,
+		 state->clk_frequency);
 	return 0;
 
 e_clkdis:
@@ -923,13 +1000,21 @@ static const struct dev_pm_ops s5pcsis_pm_ops = {
 	SET_SYSTEM_SLEEP_PM_OPS(s5pcsis_suspend, s5pcsis_resume)
 };
 
+static const struct of_device_id s5pcsis_of_match[] = {
+	{ .compatible = "samsung,s5pv210-csis" },
+	{ .compatible = "samsung,exynos4210-csis" },
+	{ /* sentinel */ },
+};
+MODULE_DEVICE_TABLE(of, s5pcsis_of_match);
+
 static struct platform_driver s5pcsis_driver = {
 	.probe		= s5pcsis_probe,
 	.remove		= s5pcsis_remove,
 	.driver		= {
-		.name	= CSIS_DRIVER_NAME,
-		.owner	= THIS_MODULE,
-		.pm	= &s5pcsis_pm_ops,
+		.of_match_table = s5pcsis_of_match,
+		.name		= CSIS_DRIVER_NAME,
+		.owner		= THIS_MODULE,
+		.pm		= &s5pcsis_pm_ops,
 	},
 };
 
diff --git a/drivers/media/platform/s5p-fimc/mipi-csis.h b/drivers/media/platform/s5p-fimc/mipi-csis.h
index 2709286..28c11c4 100644
--- a/drivers/media/platform/s5p-fimc/mipi-csis.h
+++ b/drivers/media/platform/s5p-fimc/mipi-csis.h
@@ -11,6 +11,7 @@
 #define S5P_MIPI_CSIS_H_
 
 #define CSIS_DRIVER_NAME	"s5p-mipi-csis"
+#define CSIS_SUBDEV_NAME	CSIS_DRIVER_NAME
 #define CSIS_MAX_ENTITIES	2
 #define CSIS0_MAX_LANES		4
 #define CSIS1_MAX_LANES		2
diff --git a/include/media/s5p_fimc.h b/include/media/s5p_fimc.h
index 28f3590..d6dbb79 100644
--- a/include/media/s5p_fimc.h
+++ b/include/media/s5p_fimc.h
@@ -15,6 +15,19 @@
 #include <media/media-entity.h>
 
 /*
+ * Enumeration of data inputs to the camera subsystem.
+ */
+enum fimc_input {
+	FIMC_INPUT_PARALLEL_0	= 1,
+	FIMC_INPUT_PARALLEL_1,
+	FIMC_INPUT_MIPI_CSI2_0	= 3,
+	FIMC_INPUT_MIPI_CSI2_1,
+	FIMC_INPUT_WRITEBACK_A	= 5,
+	FIMC_INPUT_WRITEBACK_B,
+	FIMC_INPUT_WRITEBACK_ISP = 5,
+};
+
+/*
  * Enumeration of the FIMC data bus types.
  */
 enum fimc_bus_type {
-- 
1.7.9.5

