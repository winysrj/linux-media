Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.w1.samsung.com ([210.118.77.12]:19391 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758522Ab2EYTxJ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 25 May 2012 15:53:09 -0400
Date: Fri, 25 May 2012 21:52:41 +0200
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [RFC/PATCH 02/13] media: s5p-csis: Add device tree support
In-reply-to: <1337975573-27117-1-git-send-email-s.nawrocki@samsung.com>
To: linux-media@vger.kernel.org
Cc: kyungmin.park@samsung.com, m.szyprowski@samsung.com,
	riverful.kim@samsung.com, sw0312.kim@samsung.com,
	s.nawrocki@samsung.com, devicetree-discuss@lists.ozlabs.org,
	linux-samsung-soc@vger.kernel.org, b.zolnierkie@samsung.com
Message-id: <1337975573-27117-2-git-send-email-s.nawrocki@samsung.com>
MIME-version: 1.0
Content-type: TEXT/PLAIN
Content-transfer-encoding: 7BIT
References: <4FBFE1EC.9060209@samsung.com>
 <1337975573-27117-1-git-send-email-s.nawrocki@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

s5p-csis is platform device driver for MIPI-CSI frontend to the FIMC
(camera host interface DMA engine and image processor). This patch
adds support for instantiating the MIPI-CSIS devices from DT and
parsing all SoC and board specific properties from device tree.
The MIPI DPHY control callback is now called directly from within
the driver, the platform code must ensure this callback does the
right thing for each SoC.

The cell-index property is used to ensure proper signal routing,
from physical camera port, through MIPI-CSI2 receiver to the DMA
engine (FIMC?). It's also helpful in exposing the device topology
in user space at /dev/media? devnode (Media Controller API).

This patch also defines a common property ("data-lanes") for MIPI-CSI
receivers and transmitters.

Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 Documentation/devicetree/bindings/video/mipi.txt   |    5 +
 .../bindings/video/samsung-mipi-csis.txt           |   47 ++++++++++
 drivers/media/video/s5p-fimc/mipi-csis.c           |   97 +++++++++++++++-----
 drivers/media/video/s5p-fimc/mipi-csis.h           |    1 +
 4 files changed, 126 insertions(+), 24 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/video/mipi.txt
 create mode 100644 Documentation/devicetree/bindings/video/samsung-mipi-csis.txt

diff --git a/Documentation/devicetree/bindings/video/mipi.txt b/Documentation/devicetree/bindings/video/mipi.txt
new file mode 100644
index 0000000..5aed285
--- /dev/null
+++ b/Documentation/devicetree/bindings/video/mipi.txt
@@ -0,0 +1,5 @@
+Common properties of MIPI-CSI1 and MIPI-CSI2 receivers and transmitters
+
+ - data-lanes : number of differential data lanes wired and actively used in
+		communication between the transmitter and the receiver, this
+		excludes the clock lane;
diff --git a/Documentation/devicetree/bindings/video/samsung-mipi-csis.txt b/Documentation/devicetree/bindings/video/samsung-mipi-csis.txt
new file mode 100644
index 0000000..7bce6f4
--- /dev/null
+++ b/Documentation/devicetree/bindings/video/samsung-mipi-csis.txt
@@ -0,0 +1,47 @@
+Samsung S5P/EXYNOS SoC MIPI-CSI2 receiver (MIPI CSIS)
+-----------------------------------------------------
+
+Required properties:
+
+- compatible - one of :
+		"samsung,s5pv210-csis",
+		"samsung,exynos4210-csis",
+		"samsung,exynos4212-csis",
+		"samsung,exynos4412-csis";
+- reg : physical base address and size of the device memory mapped registers;
+- interrupts      : should contain MIPI CSIS interrupt; the format of the
+		    interrupt specifier depends on the interrupt controller;
+- cell-index      : the hardware instance index;
+- clock-frequency : The IP's main (system bus) clock frequency in Hz, the default
+		    value when this property is not specified is 166 MHz;
+- data-lanes      : number of physical MIPI-CSI2 lanes used;
+- samsung,csis-hs-settle : differential receiver (HS-RX) settle time;
+- vddio-supply    : MIPI CSIS I/O and PLL voltage supply (e.g. 1.8V);
+- vddcore-supply  : MIPI CSIS Core voltage supply (e.g. 1.1V).
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
+	csis@11880000 {
+		compatible = "samsung,exynos4210-csis";
+		reg = <0x11880000 0x1000>;
+		interrupts = <0 78 0>;
+		cell-index = <0>;
+	};
+
+/* Board properties */
+
+	csis@11880000 {
+		clock-frequency = <166000000>;
+		data-lanes = <2>;
+		samsung,csis-hs-settle = <12>;
+		vddio-supply = <&reg0>;
+		vddcore-supply = <&reg1>;
+	};
diff --git a/drivers/media/video/s5p-fimc/mipi-csis.c b/drivers/media/video/s5p-fimc/mipi-csis.c
index 2f73d9e..ffb820e 100644
--- a/drivers/media/video/s5p-fimc/mipi-csis.c
+++ b/drivers/media/video/s5p-fimc/mipi-csis.c
@@ -19,6 +19,7 @@
 #include <linux/kernel.h>
 #include <linux/memory.h>
 #include <linux/module.h>
+#include <linux/of.h>
 #include <linux/platform_device.h>
 #include <linux/pm_runtime.h>
 #include <linux/regulator/consumer.h>
@@ -80,10 +81,11 @@ static char *csi_clock_name[] = {
 	[CSIS_CLK_GATE] = "csis",
 };
 #define NUM_CSIS_CLOCKS	ARRAY_SIZE(csi_clock_name)
+#define DEFAULT_SCLK_CSIS_FREQ	166000000UL
 
 static const char * const csis_supply_name[] = {
-	"vdd11", /* 1.1V or 1.2V (s5pc100) MIPI CSI suppply */
-	"vdd18", /* VDD 1.8V and MIPI CSI PLL supply */
+	"vddcore",  /* CSIS Core (1.0V, 1.1V or 1.2V) suppply */
+	"vddio",    /* CSIS I/O and PLL (1.8V) supply */
 };
 #define CSIS_NUM_SUPPLIES ARRAY_SIZE(csis_supply_name)
 
@@ -99,11 +101,15 @@ enum {
  *        protecting @format and @flags members
  * @pads: CSIS pads array
  * @sd: v4l2_subdev associated with CSIS device instance
+ * @index: the hardware instance index
  * @pdev: CSIS platform device
  * @regs: mmaped I/O registers memory
  * @clock: CSIS clocks
  * @irq: requested s5p-mipi-csis irq number
  * @flags: the state variable for power and streaming control
+ * @clock_freq: device main clock frequency
+ * @num_lanes: number of MIPI-CSI data lanes used
+ * @hs_settle: HS-RX settle time
  * @csis_fmt: current CSIS pixel format
  * @format: common media bus format for the source and sink pad
  */
@@ -111,12 +117,18 @@ struct csis_state {
 	struct mutex lock;
 	struct media_pad pads[CSIS_PADS_NUM];
 	struct v4l2_subdev sd;
+	int index;
 	struct platform_device *pdev;
 	void __iomem *regs;
 	struct regulator_bulk_data supplies[CSIS_NUM_SUPPLIES];
 	struct clk *clock[NUM_CSIS_CLOCKS];
 	int irq;
 	u32 flags;
+
+	u32 clk_frequency;
+	u32 hs_settle;
+	u32 num_lanes;
+
 	const struct csis_pix_format *csis_fmt;
 	struct v4l2_mbus_framefmt format;
 };
@@ -232,15 +244,14 @@ static void s5pcsis_set_hsync_settle(struct csis_state *state, int settle)
 
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
@@ -488,9 +499,38 @@ static irqreturn_t s5pcsis_irq_handler(int irq, void *dev_id)
 	return IRQ_HANDLED;
 }
 
+static int s5pcsis_get_platform_data(struct platform_device *pdev,
+				     struct csis_state *state)
+{
+	struct s5p_platform_mipi_csis *pdata = pdev->dev.platform_data;
+	struct device_node *np = pdev->dev.of_node;
+
+	if (np != NULL) {
+		if (of_property_read_u32(np, "clock-frequency",
+					 &state->clk_frequency))
+			state->clk_frequency = DEFAULT_SCLK_CSIS_FREQ;
+
+		if (of_property_read_u32(np, "data-lanes", &state->num_lanes))
+			state->num_lanes = 2;
+		of_property_read_u32(np, "cell-index", &state->index);
+
+		of_property_read_u32(np, "samsung,csis-hs-settle",
+				     &state->hs_settle);
+	} else {
+		if (pdata == NULL) {
+			dev_err(&pdev->dev, "Platform data not specified\n");
+			return -EINVAL;
+		}
+		state->clk_frequency = pdata->clk_rate;
+		state->num_lanes = pdata->lanes;
+		state->hs_settle = pdata->hs_settle;
+		state->index = max(0, pdev->id);
+	}
+	return 0;
+}
+
 static int __devinit s5pcsis_probe(struct platform_device *pdev)
 {
-	struct s5p_platform_mipi_csis *pdata;
 	struct resource *mem_res;
 	struct csis_state *state;
 	int ret = -ENOMEM;
@@ -503,16 +543,14 @@ static int __devinit s5pcsis_probe(struct platform_device *pdev)
 	mutex_init(&state->lock);
 	state->pdev = pdev;
 
-	pdata = pdev->dev.platform_data;
-	if (pdata == NULL || pdata->phy_enable == NULL) {
-		dev_err(&pdev->dev, "Platform data not fully specified\n");
-		return -EINVAL;
-	}
+	ret = s5pcsis_get_platform_data(pdev, state);
+	if (ret < 0)
+		return ret;
 
-	if ((pdev->id == 1 && pdata->lanes > CSIS1_MAX_LANES) ||
-	    pdata->lanes > CSIS0_MAX_LANES) {
+	if ((state->index == 1 && state->num_lanes > CSIS1_MAX_LANES) ||
+	     state->num_lanes > CSIS0_MAX_LANES) {
 		dev_err(&pdev->dev, "Unsupported number of data lanes: %d\n",
-			pdata->lanes);
+			state->num_lanes);
 		return -EINVAL;
 	}
 
@@ -542,8 +580,8 @@ static int __devinit s5pcsis_probe(struct platform_device *pdev)
 		goto e_clkput;
 
 	clk_enable(state->clock[CSIS_CLK_MUX]);
-	if (pdata->clk_rate)
-		clk_set_rate(state->clock[CSIS_CLK_MUX], pdata->clk_rate);
+	if (state->clk_frequency)
+		clk_set_rate(state->clock[CSIS_CLK_MUX], state->clk_frequency);
 	else
 		dev_WARN(&pdev->dev, "No clock frequency specified!\n");
 
@@ -556,7 +594,8 @@ static int __devinit s5pcsis_probe(struct platform_device *pdev)
 
 	v4l2_subdev_init(&state->sd, &s5pcsis_subdev_ops);
 	state->sd.owner = THIS_MODULE;
-	strlcpy(state->sd.name, dev_name(&pdev->dev), sizeof(state->sd.name));
+	snprintf(state->sd.name, sizeof(state->sd.name), "%s.%d",
+		 CSIS_SUBDEV_NAME, state->index);
 	state->sd.flags |= V4L2_SUBDEV_FL_HAS_DEVNODE;
 	state->csis_fmt = &s5pcsis_formats[0];
 
@@ -590,7 +629,6 @@ e_clkput:
 
 static int s5pcsis_pm_suspend(struct device *dev, bool runtime)
 {
-	struct s5p_platform_mipi_csis *pdata = dev->platform_data;
 	struct platform_device *pdev = to_platform_device(dev);
 	struct v4l2_subdev *sd = platform_get_drvdata(pdev);
 	struct csis_state *state = sd_to_csis_state(sd);
@@ -602,7 +640,7 @@ static int s5pcsis_pm_suspend(struct device *dev, bool runtime)
 	mutex_lock(&state->lock);
 	if (state->flags & ST_POWERED) {
 		s5pcsis_stop_stream(state);
-		ret = pdata->phy_enable(state->pdev, false);
+		ret = s5p_csis_phy_enable(state->pdev, state->index, false);
 		if (ret)
 			goto unlock;
 		ret = regulator_bulk_disable(CSIS_NUM_SUPPLIES,
@@ -621,7 +659,6 @@ static int s5pcsis_pm_suspend(struct device *dev, bool runtime)
 
 static int s5pcsis_pm_resume(struct device *dev, bool runtime)
 {
-	struct s5p_platform_mipi_csis *pdata = dev->platform_data;
 	struct platform_device *pdev = to_platform_device(dev);
 	struct v4l2_subdev *sd = platform_get_drvdata(pdev);
 	struct csis_state *state = sd_to_csis_state(sd);
@@ -639,7 +676,7 @@ static int s5pcsis_pm_resume(struct device *dev, bool runtime)
 					    state->supplies);
 		if (ret)
 			goto unlock;
-		ret = pdata->phy_enable(state->pdev, true);
+		ret = s5p_csis_phy_enable(state->pdev, state->index, true);
 		if (!ret) {
 			state->flags |= ST_POWERED;
 		} else {
@@ -705,13 +742,25 @@ static const struct dev_pm_ops s5pcsis_pm_ops = {
 	SET_SYSTEM_SLEEP_PM_OPS(s5pcsis_suspend, s5pcsis_resume)
 };
 
+#ifdef CONFIG_OF
+static const struct of_device_id s5pcsis_of_match[] __devinitconst = {
+	{ .compatible = "samsung,s5pv210-csis" },
+	{ .compatible = "samsung,exynos4210-csis" },
+	{ .compatible = "samsung,exynos4212-csis" },
+	{ .compatible = "samsung,exynos4412-csis" },
+	{ /* sentinel */ },
+};
+MODULE_DEVICE_TABLE(of, s5pcsis_of_match);
+#endif
+
 static struct platform_driver s5pcsis_driver = {
 	.probe		= s5pcsis_probe,
 	.remove		= __devexit_p(s5pcsis_remove),
 	.driver		= {
-		.name	= CSIS_DRIVER_NAME,
-		.owner	= THIS_MODULE,
-		.pm	= &s5pcsis_pm_ops,
+		.of_match_table = of_match_ptr(s5pcsis_of_match),
+		.name		= CSIS_DRIVER_NAME,
+		.owner		= THIS_MODULE,
+		.pm		= &s5pcsis_pm_ops,
 	},
 };
 
diff --git a/drivers/media/video/s5p-fimc/mipi-csis.h b/drivers/media/video/s5p-fimc/mipi-csis.h
index 2709286..8f71e84 100644
--- a/drivers/media/video/s5p-fimc/mipi-csis.h
+++ b/drivers/media/video/s5p-fimc/mipi-csis.h
@@ -11,6 +11,7 @@
 #define S5P_MIPI_CSIS_H_
 
 #define CSIS_DRIVER_NAME	"s5p-mipi-csis"
+#define CSIS_SUBDEV_NAME	"MIPI-CSIS"
 #define CSIS_MAX_ENTITIES	2
 #define CSIS0_MAX_LANES		4
 #define CSIS1_MAX_LANES		2
-- 
1.7.10

