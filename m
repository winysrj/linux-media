Return-path: <linux-media-owner@vger.kernel.org>
Received: from ns.mm-sol.com ([37.157.136.199]:41339 "EHLO extserv.mm-sol.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753778AbeGENdW (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 5 Jul 2018 09:33:22 -0400
From: Todor Tomov <todor.tomov@linaro.org>
To: mchehab@kernel.org, sakari.ailus@linux.intel.com,
        hans.verkuil@cisco.com, laurent.pinchart+renesas@ideasonboard.com,
        linux-media@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Todor Tomov <todor.tomov@linaro.org>
Subject: [PATCH v2 18/34] media: camss: csiphy: Split to hardware dependent and independent parts
Date: Thu,  5 Jul 2018 16:32:49 +0300
Message-Id: <1530797585-8555-19-git-send-email-todor.tomov@linaro.org>
In-Reply-To: <1530797585-8555-1-git-send-email-todor.tomov@linaro.org>
References: <1530797585-8555-1-git-send-email-todor.tomov@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This will allow to add support for different hardware.

Signed-off-by: Todor Tomov <todor.tomov@linaro.org>
---
 drivers/media/platform/qcom/camss/Makefile         |   1 +
 .../platform/qcom/camss/camss-csiphy-2ph-1-0.c     | 173 +++++++++++++++++++++
 drivers/media/platform/qcom/camss/camss-csiphy.c   | 171 +++-----------------
 drivers/media/platform/qcom/camss/camss-csiphy.h   |  15 ++
 4 files changed, 213 insertions(+), 147 deletions(-)
 create mode 100644 drivers/media/platform/qcom/camss/camss-csiphy-2ph-1-0.c

diff --git a/drivers/media/platform/qcom/camss/Makefile b/drivers/media/platform/qcom/camss/Makefile
index 3c4024f..0446b24 100644
--- a/drivers/media/platform/qcom/camss/Makefile
+++ b/drivers/media/platform/qcom/camss/Makefile
@@ -3,6 +3,7 @@
 qcom-camss-objs += \
 		camss.o \
 		camss-csid.o \
+		camss-csiphy-2ph-1-0.o \
 		camss-csiphy.o \
 		camss-ispif.o \
 		camss-vfe.o \
diff --git a/drivers/media/platform/qcom/camss/camss-csiphy-2ph-1-0.c b/drivers/media/platform/qcom/camss/camss-csiphy-2ph-1-0.c
new file mode 100644
index 0000000..7325906
--- /dev/null
+++ b/drivers/media/platform/qcom/camss/camss-csiphy-2ph-1-0.c
@@ -0,0 +1,173 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * camss-csiphy-2ph-1-0.c
+ *
+ * Qualcomm MSM Camera Subsystem - CSIPHY Module 2phase v1.0
+ *
+ * Copyright (c) 2011-2015, The Linux Foundation. All rights reserved.
+ * Copyright (C) 2016-2018 Linaro Ltd.
+ */
+
+#include "camss-csiphy.h"
+
+#include <linux/delay.h>
+#include <linux/interrupt.h>
+
+#define CAMSS_CSI_PHY_LNn_CFG2(n)		(0x004 + 0x40 * (n))
+#define CAMSS_CSI_PHY_LNn_CFG3(n)		(0x008 + 0x40 * (n))
+#define CAMSS_CSI_PHY_GLBL_RESET		0x140
+#define CAMSS_CSI_PHY_GLBL_PWR_CFG		0x144
+#define CAMSS_CSI_PHY_GLBL_IRQ_CMD		0x164
+#define CAMSS_CSI_PHY_HW_VERSION		0x188
+#define CAMSS_CSI_PHY_INTERRUPT_STATUSn(n)	(0x18c + 0x4 * (n))
+#define CAMSS_CSI_PHY_INTERRUPT_MASKn(n)	(0x1ac + 0x4 * (n))
+#define CAMSS_CSI_PHY_INTERRUPT_CLEARn(n)	(0x1cc + 0x4 * (n))
+#define CAMSS_CSI_PHY_GLBL_T_INIT_CFG0		0x1ec
+#define CAMSS_CSI_PHY_T_WAKEUP_CFG0		0x1f4
+
+static void csiphy_hw_version_read(struct csiphy_device *csiphy,
+				   struct device *dev)
+{
+	u8 hw_version = readl_relaxed(csiphy->base +
+				      CAMSS_CSI_PHY_HW_VERSION);
+
+	dev_dbg(dev, "CSIPHY HW Version = 0x%02x\n", hw_version);
+}
+
+/*
+ * csiphy_reset - Perform software reset on CSIPHY module
+ * @csiphy: CSIPHY device
+ */
+static void csiphy_reset(struct csiphy_device *csiphy)
+{
+	writel_relaxed(0x1, csiphy->base + CAMSS_CSI_PHY_GLBL_RESET);
+	usleep_range(5000, 8000);
+	writel_relaxed(0x0, csiphy->base + CAMSS_CSI_PHY_GLBL_RESET);
+}
+
+/*
+ * csiphy_settle_cnt_calc - Calculate settle count value
+ *
+ * Helper function to calculate settle count value. This is
+ * based on the CSI2 T_hs_settle parameter which in turn
+ * is calculated based on the CSI2 transmitter pixel clock
+ * frequency.
+ *
+ * Return settle count value or 0 if the CSI2 pixel clock
+ * frequency is not available
+ */
+static u8 csiphy_settle_cnt_calc(u32 pixel_clock, u8 bpp, u8 num_lanes,
+				 u32 timer_clk_rate)
+{
+	u32 mipi_clock; /* Hz */
+	u32 ui; /* ps */
+	u32 timer_period; /* ps */
+	u32 t_hs_prepare_max; /* ps */
+	u32 t_hs_prepare_zero_min; /* ps */
+	u32 t_hs_settle; /* ps */
+	u8 settle_cnt;
+
+	mipi_clock = pixel_clock * bpp / (2 * num_lanes);
+	ui = div_u64(1000000000000LL, mipi_clock);
+	ui /= 2;
+	t_hs_prepare_max = 85000 + 6 * ui;
+	t_hs_prepare_zero_min = 145000 + 10 * ui;
+	t_hs_settle = (t_hs_prepare_max + t_hs_prepare_zero_min) / 2;
+
+	timer_period = div_u64(1000000000000LL, timer_clk_rate);
+	settle_cnt = t_hs_settle / timer_period - 1;
+
+	return settle_cnt;
+}
+
+static void csiphy_lanes_enable(struct csiphy_device *csiphy,
+				struct csiphy_config *cfg,
+				u32 pixel_clock, u8 bpp, u8 lane_mask)
+{
+	struct csiphy_lanes_cfg *c = &cfg->csi2->lane_cfg;
+	u8 settle_cnt;
+	u8 val;
+	int i = 0;
+
+	settle_cnt = csiphy_settle_cnt_calc(pixel_clock, bpp, c->num_data,
+					    csiphy->timer_clk_rate);
+
+	writel_relaxed(0x1, csiphy->base +
+		       CAMSS_CSI_PHY_GLBL_T_INIT_CFG0);
+	writel_relaxed(0x1, csiphy->base +
+		       CAMSS_CSI_PHY_T_WAKEUP_CFG0);
+
+	val = 0x1;
+	val |= lane_mask << 1;
+	writel_relaxed(val, csiphy->base + CAMSS_CSI_PHY_GLBL_PWR_CFG);
+
+	val = cfg->combo_mode << 4;
+	writel_relaxed(val, csiphy->base + CAMSS_CSI_PHY_GLBL_RESET);
+
+	while (lane_mask) {
+		if (lane_mask & 0x1) {
+			writel_relaxed(0x10, csiphy->base +
+				       CAMSS_CSI_PHY_LNn_CFG2(i));
+			writel_relaxed(settle_cnt, csiphy->base +
+				       CAMSS_CSI_PHY_LNn_CFG3(i));
+			writel_relaxed(0x3f, csiphy->base +
+				       CAMSS_CSI_PHY_INTERRUPT_MASKn(i));
+			writel_relaxed(0x3f, csiphy->base +
+				       CAMSS_CSI_PHY_INTERRUPT_CLEARn(i));
+		}
+
+		lane_mask >>= 1;
+		i++;
+	}
+}
+
+static void csiphy_lanes_disable(struct csiphy_device *csiphy, u8 lane_mask)
+{
+	int i = 0;
+
+	while (lane_mask) {
+		if (lane_mask & 0x1)
+			writel_relaxed(0x0, csiphy->base +
+				       CAMSS_CSI_PHY_LNn_CFG2(i));
+
+		lane_mask >>= 1;
+		i++;
+	}
+
+	writel_relaxed(0x0, csiphy->base + CAMSS_CSI_PHY_GLBL_PWR_CFG);
+}
+
+/*
+ * csiphy_isr - CSIPHY module interrupt handler
+ * @irq: Interrupt line
+ * @dev: CSIPHY device
+ *
+ * Return IRQ_HANDLED on success
+ */
+static irqreturn_t csiphy_isr(int irq, void *dev)
+{
+	struct csiphy_device *csiphy = dev;
+	u8 i;
+
+	for (i = 0; i < 8; i++) {
+		u8 val = readl_relaxed(csiphy->base +
+				       CAMSS_CSI_PHY_INTERRUPT_STATUSn(i));
+		writel_relaxed(val, csiphy->base +
+			       CAMSS_CSI_PHY_INTERRUPT_CLEARn(i));
+		writel_relaxed(0x1, csiphy->base + CAMSS_CSI_PHY_GLBL_IRQ_CMD);
+		writel_relaxed(0x0, csiphy->base + CAMSS_CSI_PHY_GLBL_IRQ_CMD);
+		writel_relaxed(0x0, csiphy->base +
+			       CAMSS_CSI_PHY_INTERRUPT_CLEARn(i));
+	}
+
+	return IRQ_HANDLED;
+}
+
+const struct csiphy_hw_ops csiphy_ops_2ph_1_0 = {
+	.hw_version_read = csiphy_hw_version_read,
+	.reset = csiphy_reset,
+	.lanes_enable = csiphy_lanes_enable,
+	.lanes_disable = csiphy_lanes_disable,
+	.isr = csiphy_isr,
+};
+
diff --git a/drivers/media/platform/qcom/camss/camss-csiphy.c b/drivers/media/platform/qcom/camss/camss-csiphy.c
index 2db78791..14a9a66 100644
--- a/drivers/media/platform/qcom/camss/camss-csiphy.c
+++ b/drivers/media/platform/qcom/camss/camss-csiphy.c
@@ -23,17 +23,7 @@
 
 #define MSM_CSIPHY_NAME "msm_csiphy"
 
-#define CAMSS_CSI_PHY_LNn_CFG2(n)		(0x004 + 0x40 * (n))
-#define CAMSS_CSI_PHY_LNn_CFG3(n)		(0x008 + 0x40 * (n))
-#define CAMSS_CSI_PHY_GLBL_RESET		0x140
-#define CAMSS_CSI_PHY_GLBL_PWR_CFG		0x144
-#define CAMSS_CSI_PHY_GLBL_IRQ_CMD		0x164
-#define CAMSS_CSI_PHY_HW_VERSION		0x188
-#define CAMSS_CSI_PHY_INTERRUPT_STATUSn(n)	(0x18c + 0x4 * (n))
-#define CAMSS_CSI_PHY_INTERRUPT_MASKn(n)	(0x1ac + 0x4 * (n))
-#define CAMSS_CSI_PHY_INTERRUPT_CLEARn(n)	(0x1cc + 0x4 * (n))
-#define CAMSS_CSI_PHY_GLBL_T_INIT_CFG0		0x1ec
-#define CAMSS_CSI_PHY_T_WAKEUP_CFG0		0x1f4
+extern struct csiphy_hw_ops csiphy_ops_2ph_1_0;
 
 static const struct {
 	u32 code;
@@ -125,32 +115,6 @@ static u8 csiphy_get_bpp(u32 code)
 }
 
 /*
- * csiphy_isr - CSIPHY module interrupt handler
- * @irq: Interrupt line
- * @dev: CSIPHY device
- *
- * Return IRQ_HANDLED on success
- */
-static irqreturn_t csiphy_isr(int irq, void *dev)
-{
-	struct csiphy_device *csiphy = dev;
-	u8 i;
-
-	for (i = 0; i < 8; i++) {
-		u8 val = readl_relaxed(csiphy->base +
-				       CAMSS_CSI_PHY_INTERRUPT_STATUSn(i));
-		writel_relaxed(val, csiphy->base +
-			       CAMSS_CSI_PHY_INTERRUPT_CLEARn(i));
-		writel_relaxed(0x1, csiphy->base + CAMSS_CSI_PHY_GLBL_IRQ_CMD);
-		writel_relaxed(0x0, csiphy->base + CAMSS_CSI_PHY_GLBL_IRQ_CMD);
-		writel_relaxed(0x0, csiphy->base +
-			       CAMSS_CSI_PHY_INTERRUPT_CLEARn(i));
-	}
-
-	return IRQ_HANDLED;
-}
-
-/*
  * csiphy_set_clock_rates - Calculate and set clock rates on CSIPHY module
  * @csiphy: CSIPHY device
  */
@@ -215,17 +179,6 @@ static int csiphy_set_clock_rates(struct csiphy_device *csiphy)
 }
 
 /*
- * csiphy_reset - Perform software reset on CSIPHY module
- * @csiphy: CSIPHY device
- */
-static void csiphy_reset(struct csiphy_device *csiphy)
-{
-	writel_relaxed(0x1, csiphy->base + CAMSS_CSI_PHY_GLBL_RESET);
-	usleep_range(5000, 8000);
-	writel_relaxed(0x0, csiphy->base + CAMSS_CSI_PHY_GLBL_RESET);
-}
-
-/*
  * csiphy_set_power - Power on/off CSIPHY module
  * @sd: CSIPHY V4L2 subdevice
  * @on: Requested power state
@@ -238,7 +191,6 @@ static int csiphy_set_power(struct v4l2_subdev *sd, int on)
 	struct device *dev = csiphy->camss->dev;
 
 	if (on) {
-		u8 hw_version;
 		int ret;
 
 		pm_runtime_get_sync(dev);
@@ -253,11 +205,9 @@ static int csiphy_set_power(struct v4l2_subdev *sd, int on)
 
 		enable_irq(csiphy->irq);
 
-		csiphy_reset(csiphy);
+		csiphy->ops->reset(csiphy);
 
-		hw_version = readl_relaxed(csiphy->base +
-					   CAMSS_CSI_PHY_HW_VERSION);
-		dev_dbg(dev, "CSIPHY HW Version = 0x%02x\n", hw_version);
+		csiphy->ops->hw_version_read(csiphy, dev);
 	} else {
 		disable_irq(csiphy->irq);
 
@@ -289,77 +239,34 @@ static u8 csiphy_get_lane_mask(struct csiphy_lanes_cfg *lane_cfg)
 }
 
 /*
- * csiphy_settle_cnt_calc - Calculate settle count value
+ * csiphy_stream_on - Enable streaming on CSIPHY module
  * @csiphy: CSIPHY device
  *
- * Helper function to calculate settle count value. This is
- * based on the CSI2 T_hs_settle parameter which in turn
- * is calculated based on the CSI2 transmitter pixel clock
- * frequency.
+ * Helper function to enable streaming on CSIPHY module.
+ * Main configuration of CSIPHY module is also done here.
  *
- * Return settle count value or 0 if the CSI2 pixel clock
- * frequency is not available
+ * Return 0 on success or a negative error code otherwise
  */
-static u8 csiphy_settle_cnt_calc(struct csiphy_device *csiphy)
+static int csiphy_stream_on(struct csiphy_device *csiphy)
 {
-	u8 bpp = csiphy_get_bpp(
-			csiphy->fmt[MSM_CSIPHY_PAD_SINK].code);
-	u8 num_lanes = csiphy->cfg.csi2->lane_cfg.num_data;
-	u32 pixel_clock; /* Hz */
-	u32 mipi_clock; /* Hz */
-	u32 ui; /* ps */
-	u32 timer_period; /* ps */
-	u32 t_hs_prepare_max; /* ps */
-	u32 t_hs_prepare_zero_min; /* ps */
-	u32 t_hs_settle; /* ps */
-	u8 settle_cnt;
+	struct csiphy_config *cfg = &csiphy->cfg;
+	u32 pixel_clock;
+	u8 lane_mask = csiphy_get_lane_mask(&cfg->csi2->lane_cfg);
+	u8 bpp = csiphy_get_bpp(csiphy->fmt[MSM_CSIPHY_PAD_SINK].code);
+	u8 val;
 	int ret;
 
 	ret = camss_get_pixel_clock(&csiphy->subdev.entity, &pixel_clock);
 	if (ret) {
 		dev_err(csiphy->camss->dev,
 			"Cannot get CSI2 transmitter's pixel clock\n");
-		return 0;
+		return -EINVAL;
 	}
 	if (!pixel_clock) {
 		dev_err(csiphy->camss->dev,
 			"Got pixel clock == 0, cannot continue\n");
-		return 0;
-	}
-
-	mipi_clock = pixel_clock * bpp / (2 * num_lanes);
-	ui = div_u64(1000000000000LL, mipi_clock);
-	ui /= 2;
-	t_hs_prepare_max = 85000 + 6 * ui;
-	t_hs_prepare_zero_min = 145000 + 10 * ui;
-	t_hs_settle = (t_hs_prepare_max + t_hs_prepare_zero_min) / 2;
-
-	timer_period = div_u64(1000000000000LL, csiphy->timer_clk_rate);
-	settle_cnt = t_hs_settle / timer_period - 1;
-
-	return settle_cnt;
-}
-
-/*
- * csiphy_stream_on - Enable streaming on CSIPHY module
- * @csiphy: CSIPHY device
- *
- * Helper function to enable streaming on CSIPHY module.
- * Main configuration of CSIPHY module is also done here.
- *
- * Return 0 on success or a negative error code otherwise
- */
-static int csiphy_stream_on(struct csiphy_device *csiphy)
-{
-	struct csiphy_config *cfg = &csiphy->cfg;
-	u8 lane_mask = csiphy_get_lane_mask(&cfg->csi2->lane_cfg);
-	u8 settle_cnt;
-	u8 val;
-	int i = 0;
-
-	settle_cnt = csiphy_settle_cnt_calc(csiphy);
-	if (!settle_cnt)
 		return -EINVAL;
+	}
 
 	val = readl_relaxed(csiphy->base_clk_mux);
 	if (cfg->combo_mode && (lane_mask & 0x18) == 0x18) {
@@ -372,33 +279,7 @@ static int csiphy_stream_on(struct csiphy_device *csiphy)
 	writel_relaxed(val, csiphy->base_clk_mux);
 	wmb();
 
-	writel_relaxed(0x1, csiphy->base +
-		       CAMSS_CSI_PHY_GLBL_T_INIT_CFG0);
-	writel_relaxed(0x1, csiphy->base +
-		       CAMSS_CSI_PHY_T_WAKEUP_CFG0);
-
-	val = 0x1;
-	val |= lane_mask << 1;
-	writel_relaxed(val, csiphy->base + CAMSS_CSI_PHY_GLBL_PWR_CFG);
-
-	val = cfg->combo_mode << 4;
-	writel_relaxed(val, csiphy->base + CAMSS_CSI_PHY_GLBL_RESET);
-
-	while (lane_mask) {
-		if (lane_mask & 0x1) {
-			writel_relaxed(0x10, csiphy->base +
-				       CAMSS_CSI_PHY_LNn_CFG2(i));
-			writel_relaxed(settle_cnt, csiphy->base +
-				       CAMSS_CSI_PHY_LNn_CFG3(i));
-			writel_relaxed(0x3f, csiphy->base +
-				       CAMSS_CSI_PHY_INTERRUPT_MASKn(i));
-			writel_relaxed(0x3f, csiphy->base +
-				       CAMSS_CSI_PHY_INTERRUPT_CLEARn(i));
-		}
-
-		lane_mask >>= 1;
-		i++;
-	}
+	csiphy->ops->lanes_enable(csiphy, cfg, pixel_clock, bpp, lane_mask);
 
 	return 0;
 }
@@ -412,18 +293,8 @@ static int csiphy_stream_on(struct csiphy_device *csiphy)
 static void csiphy_stream_off(struct csiphy_device *csiphy)
 {
 	u8 lane_mask = csiphy_get_lane_mask(&csiphy->cfg.csi2->lane_cfg);
-	int i = 0;
 
-	while (lane_mask) {
-		if (lane_mask & 0x1)
-			writel_relaxed(0x0, csiphy->base +
-				       CAMSS_CSI_PHY_LNn_CFG2(i));
-
-		lane_mask >>= 1;
-		i++;
-	}
-
-	writel_relaxed(0x0, csiphy->base + CAMSS_CSI_PHY_GLBL_PWR_CFG);
+	csiphy->ops->lanes_disable(csiphy, lane_mask);
 }
 
 
@@ -690,6 +561,11 @@ int msm_csiphy_subdev_init(struct camss *camss,
 	csiphy->id = id;
 	csiphy->cfg.combo_mode = 0;
 
+	if (camss->version == CAMSS_8x16)
+		csiphy->ops = &csiphy_ops_2ph_1_0;
+	else
+		return -EINVAL;
+
 	/* Memory */
 
 	r = platform_get_resource_byname(pdev, IORESOURCE_MEM, res->reg[0]);
@@ -718,7 +594,8 @@ int msm_csiphy_subdev_init(struct camss *camss,
 	csiphy->irq = r->start;
 	snprintf(csiphy->irq_name, sizeof(csiphy->irq_name), "%s_%s%d",
 		 dev_name(dev), MSM_CSIPHY_NAME, csiphy->id);
-	ret = devm_request_irq(dev, csiphy->irq, csiphy_isr,
+
+	ret = devm_request_irq(dev, csiphy->irq, csiphy->ops->isr,
 			       IRQF_TRIGGER_RISING, csiphy->irq_name, csiphy);
 	if (ret < 0) {
 		dev_err(dev, "request_irq failed: %d\n", ret);
diff --git a/drivers/media/platform/qcom/camss/camss-csiphy.h b/drivers/media/platform/qcom/camss/camss-csiphy.h
index 728dfef..8f61b7d 100644
--- a/drivers/media/platform/qcom/camss/camss-csiphy.h
+++ b/drivers/media/platform/qcom/camss/camss-csiphy.h
@@ -11,6 +11,7 @@
 #define QC_MSM_CAMSS_CSIPHY_H
 
 #include <linux/clk.h>
+#include <linux/interrupt.h>
 #include <media/media-entity.h>
 #include <media/v4l2-device.h>
 #include <media/v4l2-mediabus.h>
@@ -41,6 +42,19 @@ struct csiphy_config {
 	struct csiphy_csi2_cfg *csi2;
 };
 
+struct csiphy_device;
+
+struct csiphy_hw_ops {
+	void (*hw_version_read)(struct csiphy_device *csiphy,
+				struct device *dev);
+	void (*reset)(struct csiphy_device *csiphy);
+	void (*lanes_enable)(struct csiphy_device *csiphy,
+			     struct csiphy_config *cfg,
+			     u32 pixel_clock, u8 bpp, u8 lane_mask);
+	void (*lanes_disable)(struct csiphy_device *csiphy, u8 lane_mask);
+	irqreturn_t (*isr)(int irq, void *dev);
+};
+
 struct csiphy_device {
 	struct camss *camss;
 	u8 id;
@@ -55,6 +69,7 @@ struct csiphy_device {
 	u32 timer_clk_rate;
 	struct csiphy_config cfg;
 	struct v4l2_mbus_framefmt fmt[MSM_CSIPHY_PADS_NUM];
+	struct csiphy_hw_ops *ops;
 };
 
 struct resources;
-- 
2.7.4
