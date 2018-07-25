Return-path: <linux-media-owner@vger.kernel.org>
Received: from ns.mm-sol.com ([37.157.136.199]:35615 "EHLO extserv.mm-sol.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729937AbeGYRv1 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 25 Jul 2018 13:51:27 -0400
From: Todor Tomov <todor.tomov@linaro.org>
To: mchehab@kernel.org, sakari.ailus@linux.intel.com,
        hans.verkuil@cisco.com, laurent.pinchart+renesas@ideasonboard.com,
        linux-media@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Todor Tomov <todor.tomov@linaro.org>
Subject: [PATCH v4 21/34] media: camss: csiphy: Add support for 8x96
Date: Wed, 25 Jul 2018 19:38:30 +0300
Message-Id: <1532536723-19062-22-git-send-email-todor.tomov@linaro.org>
In-Reply-To: <1532536723-19062-1-git-send-email-todor.tomov@linaro.org>
References: <1532536723-19062-1-git-send-email-todor.tomov@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add CSIPHY hardware dependent part for 8x96.

Signed-off-by: Todor Tomov <todor.tomov@linaro.org>
---
 drivers/media/platform/qcom/camss/Makefile         |   1 +
 .../platform/qcom/camss/camss-csiphy-3ph-1-0.c     | 256 +++++++++++++++++++++
 drivers/media/platform/qcom/camss/camss-csiphy.c   |   2 +
 drivers/media/platform/qcom/camss/camss-csiphy.h   |   1 +
 4 files changed, 260 insertions(+)
 create mode 100644 drivers/media/platform/qcom/camss/camss-csiphy-3ph-1-0.c

diff --git a/drivers/media/platform/qcom/camss/Makefile b/drivers/media/platform/qcom/camss/Makefile
index 0446b24..36b9f7c 100644
--- a/drivers/media/platform/qcom/camss/Makefile
+++ b/drivers/media/platform/qcom/camss/Makefile
@@ -4,6 +4,7 @@ qcom-camss-objs += \
 		camss.o \
 		camss-csid.o \
 		camss-csiphy-2ph-1-0.o \
+		camss-csiphy-3ph-1-0.o \
 		camss-csiphy.o \
 		camss-ispif.o \
 		camss-vfe.o \
diff --git a/drivers/media/platform/qcom/camss/camss-csiphy-3ph-1-0.c b/drivers/media/platform/qcom/camss/camss-csiphy-3ph-1-0.c
new file mode 100644
index 0000000..bcd0dfd
--- /dev/null
+++ b/drivers/media/platform/qcom/camss/camss-csiphy-3ph-1-0.c
@@ -0,0 +1,256 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * camss-csiphy-3ph-1-0.c
+ *
+ * Qualcomm MSM Camera Subsystem - CSIPHY Module 3phase v1.0
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
+#define CSIPHY_3PH_LNn_CFG1(n)			(0x000 + 0x100 * (n))
+#define CSIPHY_3PH_LNn_CFG1_SWI_REC_DLY_PRG	(BIT(7) | BIT(6))
+#define CSIPHY_3PH_LNn_CFG2(n)			(0x004 + 0x100 * (n))
+#define CSIPHY_3PH_LNn_CFG2_LP_REC_EN_INT	BIT(3)
+#define CSIPHY_3PH_LNn_CFG3(n)			(0x008 + 0x100 * (n))
+#define CSIPHY_3PH_LNn_CFG4(n)			(0x00c + 0x100 * (n))
+#define CSIPHY_3PH_LNn_CFG4_T_HS_CLK_MISS	0xa4
+#define CSIPHY_3PH_LNn_CFG5(n)			(0x010 + 0x100 * (n))
+#define CSIPHY_3PH_LNn_CFG5_T_HS_DTERM		0x02
+#define CSIPHY_3PH_LNn_CFG5_HS_REC_EQ_FQ_INT	0x50
+#define CSIPHY_3PH_LNn_TEST_IMP(n)		(0x01c + 0x100 * (n))
+#define CSIPHY_3PH_LNn_TEST_IMP_HS_TERM_IMP	0xa
+#define CSIPHY_3PH_LNn_MISC1(n)			(0x028 + 0x100 * (n))
+#define CSIPHY_3PH_LNn_MISC1_IS_CLKLANE		BIT(2)
+#define CSIPHY_3PH_LNn_CFG6(n)			(0x02c + 0x100 * (n))
+#define CSIPHY_3PH_LNn_CFG6_SWI_FORCE_INIT_EXIT	BIT(0)
+#define CSIPHY_3PH_LNn_CFG7(n)			(0x030 + 0x100 * (n))
+#define CSIPHY_3PH_LNn_CFG7_SWI_T_INIT		0x2
+#define CSIPHY_3PH_LNn_CFG8(n)			(0x034 + 0x100 * (n))
+#define CSIPHY_3PH_LNn_CFG8_SWI_SKIP_WAKEUP	BIT(0)
+#define CSIPHY_3PH_LNn_CFG8_SKEW_FILTER_ENABLE	BIT(1)
+#define CSIPHY_3PH_LNn_CFG9(n)			(0x038 + 0x100 * (n))
+#define CSIPHY_3PH_LNn_CFG9_SWI_T_WAKEUP	0x1
+#define CSIPHY_3PH_LNn_CSI_LANE_CTRL15(n)	(0x03c + 0x100 * (n))
+#define CSIPHY_3PH_LNn_CSI_LANE_CTRL15_SWI_SOT_SYMBOL	0xb8
+
+#define CSIPHY_3PH_CMN_CSI_COMMON_CTRLn(n)	(0x800 + 0x4 * (n))
+#define CSIPHY_3PH_CMN_CSI_COMMON_CTRL6_COMMON_PWRDN_B	BIT(0)
+#define CSIPHY_3PH_CMN_CSI_COMMON_CTRL6_SHOW_REV_ID	BIT(1)
+#define CSIPHY_3PH_CMN_CSI_COMMON_STATUSn(n)	(0x8b0 + 0x4 * (n))
+
+static void csiphy_hw_version_read(struct csiphy_device *csiphy,
+				   struct device *dev)
+{
+	u32 hw_version;
+
+	writel(CSIPHY_3PH_CMN_CSI_COMMON_CTRL6_SHOW_REV_ID,
+	       csiphy->base + CSIPHY_3PH_CMN_CSI_COMMON_CTRLn(6));
+
+	hw_version = readl_relaxed(csiphy->base +
+				   CSIPHY_3PH_CMN_CSI_COMMON_STATUSn(12));
+	hw_version |= readl_relaxed(csiphy->base +
+				   CSIPHY_3PH_CMN_CSI_COMMON_STATUSn(13)) << 8;
+	hw_version |= readl_relaxed(csiphy->base +
+				   CSIPHY_3PH_CMN_CSI_COMMON_STATUSn(14)) << 16;
+	hw_version |= readl_relaxed(csiphy->base +
+				   CSIPHY_3PH_CMN_CSI_COMMON_STATUSn(15)) << 24;
+
+	dev_err(dev, "CSIPHY 3PH HW Version = 0x%08x\n", hw_version);
+}
+
+/*
+ * csiphy_reset - Perform software reset on CSIPHY module
+ * @csiphy: CSIPHY device
+ */
+static void csiphy_reset(struct csiphy_device *csiphy)
+{
+	writel_relaxed(0x1, csiphy->base + CSIPHY_3PH_CMN_CSI_COMMON_CTRLn(0));
+	usleep_range(5000, 8000);
+	writel_relaxed(0x0, csiphy->base + CSIPHY_3PH_CMN_CSI_COMMON_CTRLn(0));
+}
+
+static irqreturn_t csiphy_isr(int irq, void *dev)
+{
+	struct csiphy_device *csiphy = dev;
+	int i;
+
+	for (i = 0; i < 11; i++) {
+		int c = i + 22;
+		u8 val = readl_relaxed(csiphy->base +
+				       CSIPHY_3PH_CMN_CSI_COMMON_STATUSn(i));
+
+		writel_relaxed(val, csiphy->base +
+				    CSIPHY_3PH_CMN_CSI_COMMON_CTRLn(c));
+	}
+
+	writel_relaxed(0x1, csiphy->base + CSIPHY_3PH_CMN_CSI_COMMON_CTRLn(10));
+	writel_relaxed(0x0, csiphy->base + CSIPHY_3PH_CMN_CSI_COMMON_CTRLn(10));
+
+	for (i = 22; i < 33; i++)
+		writel_relaxed(0x0, csiphy->base +
+				    CSIPHY_3PH_CMN_CSI_COMMON_CTRLn(i));
+
+	return IRQ_HANDLED;
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
+	u32 t_hs_settle; /* ps */
+	u8 settle_cnt;
+
+	mipi_clock = pixel_clock * bpp / (2 * num_lanes);
+	ui = div_u64(1000000000000LL, mipi_clock);
+	ui /= 2;
+	t_hs_prepare_max = 85000 + 6 * ui;
+	t_hs_settle = t_hs_prepare_max;
+
+	timer_period = div_u64(1000000000000LL, timer_clk_rate);
+	settle_cnt = t_hs_settle / timer_period - 6;
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
+	u8 val, l = 0;
+	int i;
+
+	settle_cnt = csiphy_settle_cnt_calc(pixel_clock, bpp, c->num_data,
+					    csiphy->timer_clk_rate);
+
+	val = BIT(c->clk.pos);
+	for (i = 0; i < c->num_data; i++)
+		val |= BIT(c->data[i].pos * 2);
+
+	writel_relaxed(val, csiphy->base + CSIPHY_3PH_CMN_CSI_COMMON_CTRLn(5));
+
+	val = CSIPHY_3PH_CMN_CSI_COMMON_CTRL6_COMMON_PWRDN_B;
+	writel_relaxed(val, csiphy->base + CSIPHY_3PH_CMN_CSI_COMMON_CTRLn(6));
+
+	for (i = 0; i <= c->num_data; i++) {
+		if (i == c->num_data)
+			l = 7;
+		else
+			l = c->data[i].pos * 2;
+
+		val = CSIPHY_3PH_LNn_CFG1_SWI_REC_DLY_PRG;
+		val |= 0x17;
+		writel_relaxed(val, csiphy->base + CSIPHY_3PH_LNn_CFG1(l));
+
+		val = CSIPHY_3PH_LNn_CFG2_LP_REC_EN_INT;
+		writel_relaxed(val, csiphy->base + CSIPHY_3PH_LNn_CFG2(l));
+
+		val = settle_cnt;
+		writel_relaxed(val, csiphy->base + CSIPHY_3PH_LNn_CFG3(l));
+
+		val = CSIPHY_3PH_LNn_CFG5_T_HS_DTERM |
+			CSIPHY_3PH_LNn_CFG5_HS_REC_EQ_FQ_INT;
+		writel_relaxed(val, csiphy->base + CSIPHY_3PH_LNn_CFG5(l));
+
+		val = CSIPHY_3PH_LNn_CFG6_SWI_FORCE_INIT_EXIT;
+		writel_relaxed(val, csiphy->base + CSIPHY_3PH_LNn_CFG6(l));
+
+		val = CSIPHY_3PH_LNn_CFG7_SWI_T_INIT;
+		writel_relaxed(val, csiphy->base + CSIPHY_3PH_LNn_CFG7(l));
+
+		val = CSIPHY_3PH_LNn_CFG8_SWI_SKIP_WAKEUP |
+			CSIPHY_3PH_LNn_CFG8_SKEW_FILTER_ENABLE;
+		writel_relaxed(val, csiphy->base + CSIPHY_3PH_LNn_CFG8(l));
+
+		val = CSIPHY_3PH_LNn_CFG9_SWI_T_WAKEUP;
+		writel_relaxed(val, csiphy->base + CSIPHY_3PH_LNn_CFG9(l));
+
+		val = CSIPHY_3PH_LNn_TEST_IMP_HS_TERM_IMP;
+		writel_relaxed(val, csiphy->base + CSIPHY_3PH_LNn_TEST_IMP(l));
+
+		val = CSIPHY_3PH_LNn_CSI_LANE_CTRL15_SWI_SOT_SYMBOL;
+		writel_relaxed(val, csiphy->base +
+				    CSIPHY_3PH_LNn_CSI_LANE_CTRL15(l));
+	}
+
+	val = CSIPHY_3PH_LNn_CFG1_SWI_REC_DLY_PRG;
+	writel_relaxed(val, csiphy->base + CSIPHY_3PH_LNn_CFG1(l));
+
+	val = CSIPHY_3PH_LNn_CFG4_T_HS_CLK_MISS;
+	writel_relaxed(val, csiphy->base + CSIPHY_3PH_LNn_CFG4(l));
+
+	val = CSIPHY_3PH_LNn_MISC1_IS_CLKLANE;
+	writel_relaxed(val, csiphy->base + CSIPHY_3PH_LNn_MISC1(l));
+
+	val = 0xff;
+	writel_relaxed(val, csiphy->base + CSIPHY_3PH_CMN_CSI_COMMON_CTRLn(11));
+
+	val = 0xff;
+	writel_relaxed(val, csiphy->base + CSIPHY_3PH_CMN_CSI_COMMON_CTRLn(12));
+
+	val = 0xfb;
+	writel_relaxed(val, csiphy->base + CSIPHY_3PH_CMN_CSI_COMMON_CTRLn(13));
+
+	val = 0xff;
+	writel_relaxed(val, csiphy->base + CSIPHY_3PH_CMN_CSI_COMMON_CTRLn(14));
+
+	val = 0x7f;
+	writel_relaxed(val, csiphy->base + CSIPHY_3PH_CMN_CSI_COMMON_CTRLn(15));
+
+	val = 0xff;
+	writel_relaxed(val, csiphy->base + CSIPHY_3PH_CMN_CSI_COMMON_CTRLn(16));
+
+	val = 0xff;
+	writel_relaxed(val, csiphy->base + CSIPHY_3PH_CMN_CSI_COMMON_CTRLn(17));
+
+	val = 0xef;
+	writel_relaxed(val, csiphy->base + CSIPHY_3PH_CMN_CSI_COMMON_CTRLn(18));
+
+	val = 0xff;
+	writel_relaxed(val, csiphy->base + CSIPHY_3PH_CMN_CSI_COMMON_CTRLn(19));
+
+	val = 0xff;
+	writel_relaxed(val, csiphy->base + CSIPHY_3PH_CMN_CSI_COMMON_CTRLn(20));
+
+	val = 0xff;
+	writel_relaxed(val, csiphy->base + CSIPHY_3PH_CMN_CSI_COMMON_CTRLn(21));
+}
+
+static void csiphy_lanes_disable(struct csiphy_device *csiphy,
+				 struct csiphy_config *cfg)
+{
+	writel_relaxed(0, csiphy->base +
+			  CSIPHY_3PH_CMN_CSI_COMMON_CTRLn(5));
+
+	writel_relaxed(0, csiphy->base +
+			  CSIPHY_3PH_CMN_CSI_COMMON_CTRLn(6));
+}
+
+const struct csiphy_hw_ops csiphy_ops_3ph_1_0 = {
+	.hw_version_read = csiphy_hw_version_read,
+	.reset = csiphy_reset,
+	.lanes_enable = csiphy_lanes_enable,
+	.lanes_disable = csiphy_lanes_disable,
+	.isr = csiphy_isr,
+};
diff --git a/drivers/media/platform/qcom/camss/camss-csiphy.c b/drivers/media/platform/qcom/camss/camss-csiphy.c
index d35eea0..7da7051 100644
--- a/drivers/media/platform/qcom/camss/camss-csiphy.c
+++ b/drivers/media/platform/qcom/camss/camss-csiphy.c
@@ -565,6 +565,8 @@ int msm_csiphy_subdev_init(struct camss *camss,
 
 	if (camss->version == CAMSS_8x16)
 		csiphy->ops = &csiphy_ops_2ph_1_0;
+	else if (camss->version == CAMSS_8x96)
+		csiphy->ops = &csiphy_ops_3ph_1_0;
 	else
 		return -EINVAL;
 
diff --git a/drivers/media/platform/qcom/camss/camss-csiphy.h b/drivers/media/platform/qcom/camss/camss-csiphy.h
index e3dd257..5debe46 100644
--- a/drivers/media/platform/qcom/camss/camss-csiphy.h
+++ b/drivers/media/platform/qcom/camss/camss-csiphy.h
@@ -85,5 +85,6 @@ int msm_csiphy_register_entity(struct csiphy_device *csiphy,
 void msm_csiphy_unregister_entity(struct csiphy_device *csiphy);
 
 extern const struct csiphy_hw_ops csiphy_ops_2ph_1_0;
+extern const struct csiphy_hw_ops csiphy_ops_3ph_1_0;
 
 #endif /* QC_MSM_CAMSS_CSIPHY_H */
-- 
2.7.4
