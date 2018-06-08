Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-sn1nam01on0052.outbound.protection.outlook.com ([104.47.32.52]:47902
        "EHLO NAM01-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752674AbeFHKdm (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 8 Jun 2018 06:33:42 -0400
From: Krzysztof Witos <kwitos@cadence.com>
CC: Krzysztof Witos <kwitos@cadence.com>,
        Maxime Ripard <maxime.ripard@bootlin.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        "Rob Herring" <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        "open list:CADENCE MIPI-CSI2 BRIDGES" <linux-media@vger.kernel.org>,
        "open list:OPEN FIRMWARE AND FLATTENED DEVICE TREE BINDINGS"
        <devicetree@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: [PATCH 2/2] added support for csirx dphy
Date: Fri, 8 Jun 2018 11:33:04 +0100
Message-ID: <20180608103304.16054-3-kwitos@cadence.com>
In-Reply-To: <20180608103304.16054-1-kwitos@cadence.com>
References: <20180608103304.16054-1-kwitos@cadence.com>
MIME-Version: 1.0
Content-Type: text/plain
To: unlisted-recipients:; (no To-header on input)@bombadil.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Krzysztof Witos <kwitos@cadence.com>
---
 drivers/media/platform/cadence/cdns-csi2rx.c | 342 ++++++++++++++++++++++++---
 1 file changed, 313 insertions(+), 29 deletions(-)

diff --git a/drivers/media/platform/cadence/cdns-csi2rx.c b/drivers/media/platform/cadence/cdns-csi2rx.c
index a0f02916006b..9251ea6015f0 100644
--- a/drivers/media/platform/cadence/cdns-csi2rx.c
+++ b/drivers/media/platform/cadence/cdns-csi2rx.c
@@ -2,14 +2,16 @@
 /*
  * Driver for Cadence MIPI-CSI2 RX Controller v1.3
  *
- * Copyright (C) 2017 Cadence Design Systems Inc.
+ * Copyright (C) 2017,2018 Cadence Design Systems Inc.
  */
 
 #include <linux/clk.h>
+#include <linux/iopoll.h>
 #include <linux/delay.h>
 #include <linux/io.h>
 #include <linux/module.h>
 #include <linux/of.h>
+#include <linux/of_address.h>
 #include <linux/of_graph.h>
 #include <linux/phy/phy.h>
 #include <linux/platform_device.h>
@@ -44,6 +46,33 @@
 #define CSI2RX_LANES_MAX	4
 #define CSI2RX_STREAMS_MAX	4
 
+/* DPHY registers */
+#define DPHY_PMA_CMN(reg)       (reg)
+#define DPHY_PMA_LCLK(reg)      (0x100 + (reg))
+#define DPHY_PMA_LDATA(lane, reg)   (0x200 + ((lane) * 0x100) + (reg))
+#define DPHY_PMA_RCLK(reg)      (0x600 + (reg))
+#define DPHY_PMA_RDATA(lane, reg)   (0x700 + ((lane) * 0x100) + (reg))
+#define DPHY_PCS(reg)           (0xb00 + (reg))
+
+#define DPHY_CMN_SSM            DPHY_PMA_CMN(0x20)
+#define DPHY_CMN_SSM_EN         BIT(0)
+#define DPHY_CMN_RX_MODE_EN     BIT(10)
+
+#define DPHY_CMN_PWM            DPHY_PMA_CMN(0x40)
+#define DPHY_CMN_PWM_DIV(x)     ((x) << 20)
+#define DPHY_CMN_PWM_LOW(x)     ((x) << 10)
+#define DPHY_CMN_PWM_HIGH(x)        (x)
+
+#define DPHY_CMN_PLL_CFG	DPHY_PMA_CMN(0xE8)
+#define PLL_LOCKED		BIT(2)
+
+#define DPHY_PSM_CFG            DPHY_PCS(0x4)
+#define DPHY_PSM_CFG_FROM_REG       BIT(0)
+#define DPHY_PSM_CLK_DIV(x)     ((x) << 1)
+
+#define DPHY_BAND_CTRL          DPHY_PCS(0x0)
+#define DPHY_BAND_LEFT_VAL(x)	(x)
+
 enum csi2rx_pads {
 	CSI2RX_PAD_SINK,
 	CSI2RX_PAD_SOURCE_STREAM0,
@@ -67,7 +96,7 @@ struct csi2rx_priv {
 	struct clk			*sys_clk;
 	struct clk			*p_clk;
 	struct clk			*pixel_clk[CSI2RX_STREAMS_MAX];
-	struct phy			*dphy;
+	struct clk			*hs_clk;
 
 	u8				lanes[CSI2RX_LANES_MAX];
 	u8				num_lanes;
@@ -83,8 +112,175 @@ struct csi2rx_priv {
 	struct v4l2_async_subdev	asd;
 	struct v4l2_subdev		*source_subdev;
 	int				source_pad;
+	struct cdns_dphy		*dphy;
+};
+
+struct cdns_dphy_cfg {
+	unsigned int nlanes;
+};
+
+struct cdns_dphy;
+
+enum cdns_dphy_clk_lane_cfg {
+	DPHY_CLK_CFG_LEFT_DRIVES_ALL = 0,
+	DPHY_CLK_CFG_LEFT_DRIVES_RIGHT = 1,
+	DPHY_CLK_CFG_LEFT_DRIVES_LEFT = 2,
+	DPHY_CLK_CFG_RIGHT_DRIVES_ALL = 3
+};
+
+struct cdns_dphy_ops {
+	int (*probe)(struct cdns_dphy *dphy);
+	void (*remove)(struct cdns_dphy *dphy);
+	void (*set_psm_div)(struct cdns_dphy *dphy, u8 div);
+	void (*set_pll_cfg)(struct cdns_dphy *dphy);
+	void (*set_clk_lane_cfg)(struct cdns_dphy *dphy,
+		enum cdns_dphy_clk_lane_cfg cfg);
+	void (*is_pll_locked)(struct cdns_dphy *dphy);
+	void (*set_band_ctrl)(struct cdns_dphy *dphy, u8 value);
+};
+
+struct cdns_dphy {
+	struct cdns_dphy_cfg cfg;
+	void __iomem *regs;
+	struct clk *psm_clk;
+	const struct cdns_dphy_ops *ops;
 };
 
+static int cdns_dphy_set_band_ctrl(struct cdns_dphy *dphy,
+	struct csi2rx_priv *csirx)
+{
+	u8 band_value;
+	u32 hs_freq_mhz = clk_get_rate(csirx->hs_clk);
+
+	if (hs_freq_mhz >= 80 && hs_freq_mhz < 100)
+		band_value = 0;
+	else if (hs_freq_mhz >= 100 && hs_freq_mhz < 120)
+		band_value = 1;
+	else if (hs_freq_mhz >= 120 && hs_freq_mhz < 160)
+		band_value = 2;
+	else if (hs_freq_mhz >= 160 && hs_freq_mhz < 200)
+		band_value = 3;
+	else if (hs_freq_mhz >= 200 && hs_freq_mhz < 240)
+		band_value = 4;
+	else if (hs_freq_mhz >= 240 && hs_freq_mhz < 280)
+		band_value = 5;
+	else if (hs_freq_mhz >= 280 && hs_freq_mhz < 320)
+		band_value = 6;
+	else if (hs_freq_mhz >= 320 && hs_freq_mhz < 360)
+		band_value = 7;
+	else if (hs_freq_mhz >= 360 && hs_freq_mhz < 400)
+		band_value = 8;
+	else if (hs_freq_mhz >= 400 && hs_freq_mhz < 480)
+		band_value = 9;
+	else if (hs_freq_mhz >= 480 && hs_freq_mhz < 560)
+		band_value = 10;
+	else if (hs_freq_mhz >= 560 && hs_freq_mhz < 640)
+		band_value = 11;
+	else if (hs_freq_mhz >= 640 && hs_freq_mhz < 720)
+		band_value = 12;
+	else if (hs_freq_mhz >= 720 && hs_freq_mhz < 800)
+		band_value = 13;
+	else if (hs_freq_mhz >= 800 && hs_freq_mhz < 880)
+		band_value = 14;
+	else if (hs_freq_mhz >= 880 && hs_freq_mhz < 1040)
+		band_value = 15;
+	else if (hs_freq_mhz >= 1040 && hs_freq_mhz < 1200)
+		band_value = 16;
+	else if (hs_freq_mhz >= 1200 && hs_freq_mhz < 1350)
+		band_value = 17;
+	else if (hs_freq_mhz >= 1350 && hs_freq_mhz < 1500)
+		band_value = 18;
+	else if (hs_freq_mhz >= 1500 && hs_freq_mhz < 1750)
+		band_value = 19;
+	else if (hs_freq_mhz >= 1750 && hs_freq_mhz < 2000)
+		band_value = 20;
+	else if (hs_freq_mhz >= 2000 && hs_freq_mhz < 2250)
+		band_value = 21;
+	else if (hs_freq_mhz >= 2250 && hs_freq_mhz <= 2500)
+		band_value = 22;
+	else
+		return -EINVAL;
+
+	if (dphy->ops->set_band_ctrl)
+		dphy->ops->set_band_ctrl(dphy, band_value);
+
+	return 0;
+}
+
+static int cdns_dphy_setup_psm(struct cdns_dphy *dphy)
+{
+	unsigned long psm_clk_hz = clk_get_rate(dphy->psm_clk);
+	unsigned long psm_div;
+
+	if (!psm_clk_hz || psm_clk_hz > 100000000)
+		return -EINVAL;
+
+	psm_div = DIV_ROUND_CLOSEST(psm_clk_hz, 1000000);
+	if (dphy->ops->set_psm_div)
+		dphy->ops->set_psm_div(dphy, psm_div);
+
+	return 0;
+}
+
+static void cdns_dphy_set_clk_lane_cfg(struct cdns_dphy *dphy,
+	enum cdns_dphy_clk_lane_cfg cfg)
+{
+	if (dphy->ops->set_clk_lane_cfg)
+		dphy->ops->set_clk_lane_cfg(dphy, cfg);
+}
+
+static void cdns_dphy_set_pll_cfg(struct cdns_dphy *dphy)
+{
+	if (dphy->ops->set_pll_cfg)
+		dphy->ops->set_pll_cfg(dphy);
+}
+
+static void cdns_dphy_is_pll_locked(struct cdns_dphy *dphy)
+{
+	if (dphy->ops->is_pll_locked)
+		dphy->ops->is_pll_locked(dphy);
+}
+
+static void cdns_csirx_dphy_init(struct csi2rx_priv *csi2rx,
+	const struct cdns_dphy_cfg *dphy_cfg)
+{
+
+	/*
+	 * Configure the band control settings.
+	 */
+	cdns_dphy_set_band_ctrl(csi2rx->dphy, csi2rx);
+
+	/*
+	 * Configure the internal PSM clk divider so that the DPHY has a
+	 * 1MHz clk (or something close).
+	 */
+	WARN_ON_ONCE(cdns_dphy_setup_psm(csi2rx->dphy));
+
+	/*
+	 * Configure attach clk lanes to data lanes: the DPHY has 2 clk lanes
+	 * and 8 data lanes, each clk lane can be attache different set of
+	 * data lanes. The 2 groups are named 'left' and 'right', so here we
+	 * just say that we want the 'left' clk lane to drive the 'left' data
+	 * lanes.
+	 */
+	cdns_dphy_set_clk_lane_cfg(csi2rx->dphy,
+		DPHY_CLK_CFG_LEFT_DRIVES_LEFT);
+
+	/*
+	 * Configure the DPHY PLL that will be used to generate the TX byte
+	 * clk.
+	 */
+	cdns_dphy_set_pll_cfg(csi2rx->dphy);
+
+	/*  Start RX state machine. */
+	writel(DPHY_CMN_SSM_EN | DPHY_CMN_RX_MODE_EN,
+		csi2rx->dphy->regs + DPHY_CMN_SSM);
+
+	/* Checking if PLL is locked */
+	cdns_dphy_is_pll_locked(csi2rx->dphy);
+
+}
+
 static inline
 struct csi2rx_priv *v4l2_subdev_to_csi2rx(struct v4l2_subdev *subdev)
 {
@@ -103,6 +299,7 @@ static void csi2rx_reset(struct csi2rx_priv *csi2rx)
 
 static int csi2rx_start(struct csi2rx_priv *csi2rx)
 {
+	struct cdns_dphy_cfg dphy_cfg;
 	unsigned int i;
 	unsigned long lanes_used = 0;
 	u32 reg;
@@ -135,6 +332,8 @@ static int csi2rx_start(struct csi2rx_priv *csi2rx)
 
 	writel(reg, csi2rx->base + CSI2RX_STATIC_CFG_REG);
 
+	cdns_csirx_dphy_init(csi2rx, &dphy_cfg);
+
 	ret = v4l2_subdev_call(csi2rx->source_subdev, video, s_stream, true);
 	if (ret)
 		goto err_disable_pclk;
@@ -300,19 +499,10 @@ static int csi2rx_get_resources(struct csi2rx_priv *csi2rx,
 		return PTR_ERR(csi2rx->p_clk);
 	}
 
-	csi2rx->dphy = devm_phy_optional_get(&pdev->dev, "dphy");
-	if (IS_ERR(csi2rx->dphy)) {
-		dev_err(&pdev->dev, "Couldn't get external D-PHY\n");
-		return PTR_ERR(csi2rx->dphy);
-	}
-
-	/*
-	 * FIXME: Once we'll have external D-PHY support, the check
-	 * will need to be removed.
-	 */
-	if (csi2rx->dphy) {
-		dev_err(&pdev->dev, "External D-PHY not supported yet\n");
-		return -EINVAL;
+	csi2rx->hs_clk = devm_clk_get(&pdev->dev, "hs_clk");
+	if (IS_ERR(csi2rx->hs_clk)) {
+		dev_err(&pdev->dev, "Couldn't get hs clock\n");
+		return PTR_ERR(csi2rx->hs_clk);
 	}
 
 	clk_prepare_enable(csi2rx->p_clk);
@@ -333,17 +523,6 @@ static int csi2rx_get_resources(struct csi2rx_priv *csi2rx,
 		return -EINVAL;
 	}
 
-	csi2rx->has_internal_dphy = dev_cfg & BIT(3) ? true : false;
-
-	/*
-	 * FIXME: Once we'll have internal D-PHY support, the check
-	 * will need to be removed.
-	 */
-	if (csi2rx->has_internal_dphy) {
-		dev_err(&pdev->dev, "Internal D-PHY not supported yet\n");
-		return -EINVAL;
-	}
-
 	for (i = 0; i < csi2rx->max_streams; i++) {
 		char clk_name[16];
 
@@ -412,6 +591,107 @@ static int csi2rx_parse_dt(struct csi2rx_priv *csi2rx)
 						   &csi2rx->notifier);
 }
 
+static void cdns_dphy_ref_set_pll_cfg(struct cdns_dphy *dphy)
+{
+	writel(DPHY_CMN_PWM_HIGH(6) | DPHY_CMN_PWM_LOW(0x101) |
+		DPHY_CMN_PWM_DIV(0x8),
+		dphy->regs + DPHY_CMN_PWM);
+}
+
+static void cdns_dphy_ref_set_band_ctrl(struct cdns_dphy *dphy, u8 value)
+{
+	writel(DPHY_BAND_LEFT_VAL(value),
+		dphy->regs + DPHY_BAND_CTRL);
+}
+
+static void cdns_dphy_ref_set_psm_div(struct cdns_dphy *dphy, u8 div)
+{
+	writel(DPHY_PSM_CFG_FROM_REG | DPHY_PSM_CLK_DIV(div),
+		dphy->regs + DPHY_PSM_CFG);
+}
+
+static void cdns_dphy_ref_is_pll_locked(struct cdns_dphy *dphy)
+{
+	u32 status;
+
+	WARN_ON_ONCE(readl_poll_timeout(dphy->regs + DPHY_CMN_PLL_CFG, status,
+					status & PLL_LOCKED, 100, 100));
+}
+
+/*
+ * This is the reference implementation of DPHY hooks. Specific integration of
+ * this IP may have to re-implement some of them depending on how they decided
+ * to wire things in the SoC.
+ */
+static const struct cdns_dphy_ops ref_dphy_ops = {
+	.set_pll_cfg = cdns_dphy_ref_set_pll_cfg,
+	.set_psm_div = cdns_dphy_ref_set_psm_div,
+	.set_band_ctrl = cdns_dphy_ref_set_band_ctrl,
+	.is_pll_locked = cdns_dphy_ref_is_pll_locked
+};
+
+static const struct of_device_id cdns_dphy_of_match[] = {
+	{ .compatible = "cdns,dphy", .data = &ref_dphy_ops },
+	{ /* sentinel */ },
+};
+
+static struct cdns_dphy *cdns_dphy_probe(struct platform_device *pdev)
+{
+	const struct of_device_id *match;
+	struct cdns_dphy *dphy;
+	struct of_phandle_args args;
+	struct resource res;
+	int ret;
+
+	ret = of_parse_phandle_with_args(pdev->dev.of_node, "phys",
+		"#phy-cells", 0, &args);
+	if (ret)
+		return ERR_PTR(-ENOENT);
+
+	match = of_match_node(cdns_dphy_of_match, args.np);
+	if (!match || !match->data)
+		return ERR_PTR(-EINVAL);
+
+	dphy = devm_kzalloc(&pdev->dev, sizeof(*dphy), GFP_KERNEL);
+	if (!dphy)
+		return ERR_PTR(-ENOMEM);
+
+	dphy->ops = match->data;
+
+	ret = of_address_to_resource(args.np, 0, &res);
+	if (ret)
+		return ERR_PTR(ret);
+
+	dphy->regs = devm_ioremap_resource(&pdev->dev, &res);
+	if (IS_ERR(dphy->regs))
+		return ERR_CAST(dphy->regs);
+
+	dphy->psm_clk = of_clk_get_by_name(args.np, "psm");
+	if (IS_ERR(dphy->psm_clk))
+		return ERR_CAST(dphy->psm_clk);
+
+	if (dphy->ops->probe) {
+		ret = dphy->ops->probe(dphy);
+	if (ret)
+		goto err_put_psm_clk;
+	}
+
+	return dphy;
+
+err_put_psm_clk:
+	clk_put(dphy->psm_clk);
+
+	return ERR_PTR(ret);
+}
+
+static void cdns_dphy_remove(struct cdns_dphy *dphy)
+{
+	if (dphy->ops->remove)
+		dphy->ops->remove(dphy);
+
+	clk_put(dphy->psm_clk);
+}
+
 static int csi2rx_probe(struct platform_device *pdev)
 {
 	struct csi2rx_priv *csi2rx;
@@ -455,10 +735,13 @@ static int csi2rx_probe(struct platform_device *pdev)
 	if (ret < 0)
 		goto err_free_priv;
 
+	csi2rx->dphy = cdns_dphy_probe(pdev);
+	if (IS_ERR(csi2rx->dphy))
+		return PTR_ERR(csi2rx->dphy);
+
 	dev_info(&pdev->dev,
-		 "Probed CSI2RX with %u/%u lanes, %u streams, %s D-PHY\n",
-		 csi2rx->num_lanes, csi2rx->max_lanes, csi2rx->max_streams,
-		 csi2rx->has_internal_dphy ? "internal" : "no");
+		 "Probed CSI2RX with %u/%u lanes, %u streams\n",
+		 csi2rx->num_lanes, csi2rx->max_lanes, csi2rx->max_streams);
 
 	return 0;
 
@@ -472,6 +755,7 @@ static int csi2rx_remove(struct platform_device *pdev)
 	struct csi2rx_priv *csi2rx = platform_get_drvdata(pdev);
 
 	v4l2_async_unregister_subdev(&csi2rx->subdev);
+	cdns_dphy_remove(csi2rx->dphy);
 	kfree(csi2rx);
 
 	return 0;
-- 
2.15.0
