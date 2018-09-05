Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.bootlin.com ([62.4.15.54]:39642 "EHLO mail.bootlin.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726071AbeIENqR (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 5 Sep 2018 09:46:17 -0400
From: Maxime Ripard <maxime.ripard@bootlin.com>
To: Kishon Vijay Abraham I <kishon@ti.com>,
        Boris Brezillon <boris.brezillon@bootlin.com>
Cc: Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        linux-media@vger.kernel.org,
        Archit Taneja <architt@codeaurora.org>,
        Andrzej Hajda <a.hajda@samsung.com>,
        Chen-Yu Tsai <wens@csie.org>, linux-kernel@vger.kernel.org,
        dri-devel@lists.freedesktop.org,
        linux-arm-kernel@lists.infradead.org,
        Krzysztof Witos <kwitos@cadence.com>,
        Rafal Ciepiela <rafalc@cadence.com>,
        Maxime Ripard <maxime.ripard@bootlin.com>
Subject: [PATCH 09/10] phy: Add Cadence D-PHY support
Date: Wed,  5 Sep 2018 11:16:40 +0200
Message-Id: <d50a5f0750647dcc09ef52411641b628161b362e.1536138624.git-series.maxime.ripard@bootlin.com>
In-Reply-To: <cover.ee6158898d563fcc01d45c9652501180bccff0f0.1536138624.git-series.maxime.ripard@bootlin.com>
References: <cover.ee6158898d563fcc01d45c9652501180bccff0f0.1536138624.git-series.maxime.ripard@bootlin.com>
In-Reply-To: <cover.ee6158898d563fcc01d45c9652501180bccff0f0.1536138624.git-series.maxime.ripard@bootlin.com>
References: <cover.ee6158898d563fcc01d45c9652501180bccff0f0.1536138624.git-series.maxime.ripard@bootlin.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Cadence has designed a D-PHY that can be used by the, currently in tree,
DSI bridge (DRM), CSI Transceiver and CSI Receiver (v4l2) drivers.

Only the DSI driver has an ad-hoc driver for that phy at the moment, while
the v4l2 drivers are completely missing any phy support. In order to make
that phy support available to all these drivers, without having to
duplicate that code three times, let's create a generic phy framework
driver.

Signed-off-by: Maxime Ripard <maxime.ripard@bootlin.com>
---
 drivers/phy/Kconfig             |   1 +-
 drivers/phy/Makefile            |   1 +-
 drivers/phy/cadence/Kconfig     |  13 +-
 drivers/phy/cadence/Makefile    |   1 +-
 drivers/phy/cadence/cdns-dphy.c | 499 +++++++++++++++++++++++++++++++++-
 5 files changed, 515 insertions(+)
 create mode 100644 drivers/phy/cadence/Kconfig
 create mode 100644 drivers/phy/cadence/Makefile
 create mode 100644 drivers/phy/cadence/cdns-dphy.c

diff --git a/drivers/phy/Kconfig b/drivers/phy/Kconfig
index 06bd22bd1f4a..a65427fc3fbd 100644
--- a/drivers/phy/Kconfig
+++ b/drivers/phy/Kconfig
@@ -51,6 +51,7 @@ config PHY_XGENE
 source "drivers/phy/allwinner/Kconfig"
 source "drivers/phy/amlogic/Kconfig"
 source "drivers/phy/broadcom/Kconfig"
+source "drivers/phy/cadence/Kconfig"
 source "drivers/phy/hisilicon/Kconfig"
 source "drivers/phy/lantiq/Kconfig"
 source "drivers/phy/marvell/Kconfig"
diff --git a/drivers/phy/Makefile b/drivers/phy/Makefile
index 71c29d2b9af7..9db9c33dcd3f 100644
--- a/drivers/phy/Makefile
+++ b/drivers/phy/Makefile
@@ -16,6 +16,7 @@ obj-$(CONFIG_ARCH_RENESAS)		+= renesas/
 obj-$(CONFIG_ARCH_ROCKCHIP)		+= rockchip/
 obj-$(CONFIG_ARCH_TEGRA)		+= tegra/
 obj-y					+= broadcom/	\
+					   cadence/	\
 					   hisilicon/	\
 					   marvell/	\
 					   motorola/	\
diff --git a/drivers/phy/cadence/Kconfig b/drivers/phy/cadence/Kconfig
new file mode 100644
index 000000000000..fbad4466dd1d
--- /dev/null
+++ b/drivers/phy/cadence/Kconfig
@@ -0,0 +1,13 @@
+#
+# Phy drivers for Cadence IPs
+#
+
+config PHY_CADENCE_DPHY
+	tristate "Cadence D-PHY Support"
+	depends on HAS_IOMEM && OF
+	select GENERIC_PHY
+	select GENERIC_PHY_MIPI_DPHY
+	help
+	  Choose this option if you have a Cadence D-PHY in your
+	  system. If M is selected, the module will be called
+	  cdns-csi.
diff --git a/drivers/phy/cadence/Makefile b/drivers/phy/cadence/Makefile
new file mode 100644
index 000000000000..d7ada8d9d11b
--- /dev/null
+++ b/drivers/phy/cadence/Makefile
@@ -0,0 +1 @@
+obj-$(CONFIG_PHY_CADENCE_DPHY)	+= cdns-dphy.o
diff --git a/drivers/phy/cadence/cdns-dphy.c b/drivers/phy/cadence/cdns-dphy.c
new file mode 100644
index 000000000000..4d7f72f7e78d
--- /dev/null
+++ b/drivers/phy/cadence/cdns-dphy.c
@@ -0,0 +1,499 @@
+// SPDX-License-Identifier: GPL-2.0+
+/*
+ * Copyright: 2017-2018 Cadence Design Systems, Inc.
+ */
+
+#include <linux/bitops.h>
+#include <linux/clk.h>
+#include <linux/io.h>
+#include <linux/module.h>
+#include <linux/of_address.h>
+#include <linux/of_device.h>
+#include <linux/platform_device.h>
+#include <linux/reset.h>
+
+#include <linux/phy/phy.h>
+#include <linux/phy/phy-mipi-dphy.h>
+
+#define REG_WAKEUP_TIME_NS		800
+#define DPHY_PLL_RATE_HZ		108000000
+
+/* DPHY registers */
+#define DPHY_PMA_CMN(reg)		(reg)
+#define DPHY_PMA_LCLK(reg)		(0x100 + (reg))
+#define DPHY_PMA_LDATA(lane, reg)	(0x200 + ((lane) * 0x100) + (reg))
+#define DPHY_PMA_RCLK(reg)		(0x600 + (reg))
+#define DPHY_PMA_RDATA(lane, reg)	(0x700 + ((lane) * 0x100) + (reg))
+#define DPHY_PCS(reg)			(0xb00 + (reg))
+
+#define DPHY_CMN_SSM			DPHY_PMA_CMN(0x20)
+#define DPHY_CMN_SSM_EN			BIT(0)
+#define DPHY_CMN_TX_MODE_EN		BIT(9)
+
+#define DPHY_CMN_PWM			DPHY_PMA_CMN(0x40)
+#define DPHY_CMN_PWM_DIV(x)		((x) << 20)
+#define DPHY_CMN_PWM_LOW(x)		((x) << 10)
+#define DPHY_CMN_PWM_HIGH(x)		(x)
+
+#define DPHY_CMN_FBDIV			DPHY_PMA_CMN(0x4c)
+#define DPHY_CMN_FBDIV_VAL(low, high)	(((high) << 11) | ((low) << 22))
+#define DPHY_CMN_FBDIV_FROM_REG		(BIT(10) | BIT(21))
+
+#define DPHY_CMN_OPIPDIV		DPHY_PMA_CMN(0x50)
+#define DPHY_CMN_IPDIV_FROM_REG		BIT(0)
+#define DPHY_CMN_IPDIV(x)		((x) << 1)
+#define DPHY_CMN_OPDIV_FROM_REG		BIT(6)
+#define DPHY_CMN_OPDIV(x)		((x) << 7)
+
+#define DPHY_PSM_CFG			DPHY_PCS(0x4)
+#define DPHY_PSM_CFG_FROM_REG		BIT(0)
+#define DPHY_PSM_CLK_DIV(x)		((x) << 1)
+
+#define DSI_HBP_FRAME_OVERHEAD		12
+#define DSI_HSA_FRAME_OVERHEAD		14
+#define DSI_HFP_FRAME_OVERHEAD		6
+#define DSI_HSS_VSS_VSE_FRAME_OVERHEAD	4
+#define DSI_BLANKING_FRAME_OVERHEAD	6
+#define DSI_NULL_FRAME_OVERHEAD		6
+#define DSI_EOT_PKT_SIZE		4
+
+struct cdns_dphy_cfg {
+	u8 pll_ipdiv;
+	u8 pll_opdiv;
+	u16 pll_fbdiv;
+	unsigned long lane_bps;
+	unsigned int nlanes;
+};
+
+enum cdns_dphy_clk_lane_cfg {
+	DPHY_CLK_CFG_LEFT_DRIVES_ALL = 0,
+	DPHY_CLK_CFG_LEFT_DRIVES_RIGHT = 1,
+	DPHY_CLK_CFG_LEFT_DRIVES_LEFT = 2,
+	DPHY_CLK_CFG_RIGHT_DRIVES_ALL = 3,
+};
+
+struct cdns_dphy;
+struct cdns_dphy_ops {
+	int (*probe)(struct cdns_dphy *dphy);
+	void (*remove)(struct cdns_dphy *dphy);
+	void (*set_psm_div)(struct cdns_dphy *dphy, u8 div);
+	void (*set_clk_lane_cfg)(struct cdns_dphy *dphy,
+				 enum cdns_dphy_clk_lane_cfg cfg);
+	void (*set_pll_cfg)(struct cdns_dphy *dphy,
+			    const struct cdns_dphy_cfg *cfg);
+	unsigned long (*get_wakeup_time_ns)(struct cdns_dphy *dphy);
+};
+
+struct cdns_dphy {
+	struct cdns_dphy_cfg cfg;
+	void __iomem *regs;
+	struct clk *psm_clk;
+	struct clk *pll_ref_clk;
+	const struct cdns_dphy_ops *ops;
+	struct phy *phy;
+};
+
+static int cdns_dsi_get_dphy_pll_cfg(struct cdns_dphy *dphy,
+				     struct cdns_dphy_cfg *cfg,
+				     struct phy_configure_opts_mipi_dphy *opts,
+				     unsigned int *dsi_hfp_ext)
+{
+	u64 dlane_bps, dlane_bps_max, fbdiv, fbdiv_max, adj_dsi_htotal;
+	unsigned long pll_ref_hz = clk_get_rate(dphy->pll_ref_clk);
+	unsigned long dpi_htotal = opts->timings.hactive +
+		opts->timings.hfront_porch + opts->timings.hback_porch +
+		opts->timings.hsync_len;
+	unsigned long dsi_htotal = opts->timings.hactive +
+		opts->timings.hfront_porch + DSI_HFP_FRAME_OVERHEAD +
+		opts->timings.hback_porch + DSI_HBP_FRAME_OVERHEAD;
+
+	if (opts->modes & MIPI_DPHY_MODE_VIDEO_SYNC_PULSE)
+		dsi_htotal += opts->timings.hsync_len + DSI_HSA_FRAME_OVERHEAD;
+
+	memset(cfg, 0, sizeof(*cfg));
+
+	if (pll_ref_hz < 9600000 || pll_ref_hz >= 150000000)
+		return -EINVAL;
+	else if (pll_ref_hz < 19200000)
+		cfg->pll_ipdiv = 1;
+	else if (pll_ref_hz < 38400000)
+		cfg->pll_ipdiv = 2;
+	else if (pll_ref_hz < 76800000)
+		cfg->pll_ipdiv = 4;
+	else
+		cfg->pll_ipdiv = 8;
+
+	/*
+	 * Make sure DSI htotal is aligned on a lane boundary when calculating
+	 * the expected data rate. This is done by extending HFP in case of
+	 * misalignment.
+	 */
+	adj_dsi_htotal = dsi_htotal;
+	if (dsi_htotal % opts->lanes)
+		adj_dsi_htotal += opts->lanes - (dsi_htotal % opts->lanes);
+
+	dlane_bps = (u64)opts->timings.pixelclock * adj_dsi_htotal;
+
+	/* data rate in bytes/sec is not an integer, refuse the mode. */
+	if (do_div(dlane_bps, opts->lanes * dpi_htotal))
+		return -EINVAL;
+
+	/* data rate was in bytes/sec, convert to bits/sec. */
+	dlane_bps *= 8;
+
+	if (dlane_bps > 2500000000UL || dlane_bps < 160000000UL)
+		return -EINVAL;
+	else if (dlane_bps >= 1250000000)
+		cfg->pll_opdiv = 1;
+	else if (dlane_bps >= 630000000)
+		cfg->pll_opdiv = 2;
+	else if (dlane_bps >= 320000000)
+		cfg->pll_opdiv = 4;
+	else if (dlane_bps >= 160000000)
+		cfg->pll_opdiv = 8;
+
+	/*
+	 * Allow a deviation of 0.2% on the per-lane data rate to try to
+	 * recover a potential mismatch between DPI and PPI clks.
+	 */
+	dlane_bps_max = dlane_bps + DIV_ROUND_DOWN_ULL(dlane_bps, 500);
+	fbdiv_max = DIV_ROUND_DOWN_ULL(dlane_bps_max * 2 *
+				       cfg->pll_opdiv * cfg->pll_ipdiv,
+				       pll_ref_hz);
+	fbdiv = DIV_ROUND_UP_ULL(dlane_bps * 2 * cfg->pll_opdiv *
+				 cfg->pll_ipdiv,
+				 pll_ref_hz);
+
+	/*
+	 * Iterate over all acceptable fbdiv and try to find an adjusted DSI
+	 * htotal length providing an exact match.
+	 *
+	 * Note that we could do something even trickier by relying on the fact
+	 * that a new line is not necessarily aligned on a lane boundary, so,
+	 * by making adj_dsi_htotal non aligned on a dsi_lanes we can improve a
+	 * bit the precision. With this, the step would be
+	 *
+	 *	pll_ref_hz / (2 * opdiv * ipdiv * nlanes)
+	 *
+	 * instead of
+	 *
+	 *	pll_ref_hz / (2 * opdiv * ipdiv)
+	 *
+	 * The drawback of this approach is that we would need to make sure the
+	 * number or lines is a multiple of the realignment periodicity which is
+	 * a function of the number of lanes and the original misalignment. For
+	 * example, for NLANES = 4 and HTOTAL % NLANES = 3, it takes 4 lines
+	 * to realign on a lane:
+	 * LINE 0: expected number of bytes, starts emitting first byte of
+	 *	   LINE 1 on LANE 3
+	 * LINE 1: expected number of bytes, starts emitting first 2 bytes of
+	 *	   LINE 2 on LANES 2 and 3
+	 * LINE 2: expected number of bytes, starts emitting first 3 bytes of
+	 *	   of LINE 3 on LANES 1, 2 and 3
+	 * LINE 3: one byte less, now things are realigned on LANE 0 for LINE 4
+	 *
+	 * I figured this extra complexity was not worth the benefit, but if
+	 * someone really has unfixable mismatch, that would be something to
+	 * investigate.
+	 */
+	for (; fbdiv <= fbdiv_max; fbdiv++) {
+		u32 rem;
+
+		adj_dsi_htotal = (u64)fbdiv * pll_ref_hz * opts->lanes *
+				 dpi_htotal;
+
+		/*
+		 * Do the division in 2 steps to avoid an overflow on the
+		 * divider.
+		 */
+		rem = do_div(adj_dsi_htotal, opts->timings.pixelclock);
+		if (rem)
+			continue;
+
+		rem = do_div(adj_dsi_htotal,
+			     cfg->pll_opdiv * cfg->pll_ipdiv * 2 * 8);
+		if (rem)
+			continue;
+
+		cfg->pll_fbdiv = fbdiv;
+		*dsi_hfp_ext = adj_dsi_htotal - dsi_htotal;
+		break;
+	}
+
+	/* No match, let's just reject the display mode. */
+	if (!cfg->pll_fbdiv)
+		return -EINVAL;
+
+	dlane_bps = DIV_ROUND_DOWN_ULL((u64)opts->timings.pixelclock * adj_dsi_htotal * 8,
+				       opts->lanes * dpi_htotal);
+	cfg->lane_bps = dlane_bps;
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
+				       enum cdns_dphy_clk_lane_cfg cfg)
+{
+	if (dphy->ops->set_clk_lane_cfg)
+		dphy->ops->set_clk_lane_cfg(dphy, cfg);
+}
+
+static void cdns_dphy_set_pll_cfg(struct cdns_dphy *dphy,
+				  const struct cdns_dphy_cfg *cfg)
+{
+	if (dphy->ops->set_pll_cfg)
+		dphy->ops->set_pll_cfg(dphy, cfg);
+}
+
+static unsigned long cdns_dphy_get_wakeup_time_ns(struct cdns_dphy *dphy)
+{
+	return dphy->ops->get_wakeup_time_ns(dphy);
+}
+
+static unsigned long cdns_dphy_ref_get_wakeup_time_ns(struct cdns_dphy *dphy)
+{
+	/* Default wakeup time is 800 ns (in a simulated environment). */
+	return 800;
+}
+
+static void cdns_dphy_ref_set_pll_cfg(struct cdns_dphy *dphy,
+				      const struct cdns_dphy_cfg *cfg)
+{
+	u32 fbdiv_low, fbdiv_high;
+
+	fbdiv_low = (cfg->pll_fbdiv / 4) - 2;
+	fbdiv_high = cfg->pll_fbdiv - fbdiv_low - 2;
+
+	writel(DPHY_CMN_IPDIV_FROM_REG | DPHY_CMN_OPDIV_FROM_REG |
+	       DPHY_CMN_IPDIV(cfg->pll_ipdiv) |
+	       DPHY_CMN_OPDIV(cfg->pll_opdiv),
+	       dphy->regs + DPHY_CMN_OPIPDIV);
+	writel(DPHY_CMN_FBDIV_FROM_REG |
+	       DPHY_CMN_FBDIV_VAL(fbdiv_low, fbdiv_high),
+	       dphy->regs + DPHY_CMN_FBDIV);
+	writel(DPHY_CMN_PWM_HIGH(6) | DPHY_CMN_PWM_LOW(0x101) |
+	       DPHY_CMN_PWM_DIV(0x8),
+	       dphy->regs + DPHY_CMN_PWM);
+}
+
+static void cdns_dphy_ref_set_psm_div(struct cdns_dphy *dphy, u8 div)
+{
+	writel(DPHY_PSM_CFG_FROM_REG | DPHY_PSM_CLK_DIV(div),
+	       dphy->regs + DPHY_PSM_CFG);
+}
+
+/*
+ * This is the reference implementation of DPHY hooks. Specific integration of
+ * this IP may have to re-implement some of them depending on how they decided
+ * to wire things in the SoC.
+ */
+static const struct cdns_dphy_ops ref_dphy_ops = {
+	.get_wakeup_time_ns = cdns_dphy_ref_get_wakeup_time_ns,
+	.set_pll_cfg = cdns_dphy_ref_set_pll_cfg,
+	.set_psm_div = cdns_dphy_ref_set_psm_div,
+};
+
+static int cdns_dphy_config_from_opts(struct phy *phy,
+				      struct phy_configure_opts_mipi_dphy *opts,
+				      struct cdns_dphy_cfg *cfg)
+{
+	struct cdns_dphy *dphy = phy_get_drvdata(phy);
+	unsigned int dsi_hfp_ext = 0;
+	int ret;
+
+	ret = phy_mipi_dphy_config_validate(opts);
+	if (ret)
+		return ret;
+
+	ret = cdns_dsi_get_dphy_pll_cfg(dphy, cfg,
+					opts, &dsi_hfp_ext);
+	if (ret)
+		return ret;
+
+	opts->timings.hfront_porch += dsi_hfp_ext;
+	opts->timings.hsync_len += dsi_hfp_ext;
+	opts->wakeup = cdns_dphy_get_wakeup_time_ns(dphy);
+
+	return 0;
+}
+
+static int cdns_dphy_init(struct phy *phy)
+{
+	struct cdns_dphy *dphy = phy_get_drvdata(phy);
+
+	clk_prepare_enable(dphy->psm_clk);
+	clk_prepare_enable(dphy->pll_ref_clk);
+
+	return 0;
+}
+
+static int cdns_dphy_validate(struct phy *phy, enum phy_mode mode,
+			      union phy_configure_opts *opts)
+{
+	struct cdns_dphy_cfg cfg = { 0 };
+
+	if (mode != PHY_MODE_MIPI_DPHY)
+		return -EINVAL;
+
+	return cdns_dphy_config_from_opts(phy, &opts->mipi_dphy, &cfg);
+}
+
+static int cdns_dphy_configure(struct phy *phy, enum phy_mode mode,
+				union phy_configure_opts *opts)
+{
+	struct cdns_dphy *dphy = phy_get_drvdata(phy);
+	struct cdns_dphy_cfg cfg = { 0 };
+	int ret;
+
+	if (mode != PHY_MODE_MIPI_DPHY)
+		return -EINVAL;
+
+	ret = cdns_dphy_config_from_opts(phy, &opts->mipi_dphy, &cfg);
+	if (ret)
+		return ret;
+
+	/*
+	 * Configure the internal PSM clk divider so that the DPHY has a
+	 * 1MHz clk (or something close).
+	 */
+	ret = cdns_dphy_setup_psm(dphy);
+	if (ret)
+		return ret;
+
+	/*
+	 * Configure attach clk lanes to data lanes: the DPHY has 2 clk lanes
+	 * and 8 data lanes, each clk lane can be attache different set of
+	 * data lanes. The 2 groups are named 'left' and 'right', so here we
+	 * just say that we want the 'left' clk lane to drive the 'left' data
+	 * lanes.
+	 */
+	cdns_dphy_set_clk_lane_cfg(dphy, DPHY_CLK_CFG_LEFT_DRIVES_LEFT);
+
+	/*
+	 * Configure the DPHY PLL that will be used to generate the TX byte
+	 * clk.
+	 */
+	cdns_dphy_set_pll_cfg(dphy, &cfg);
+
+	return 0;
+}
+
+static int cdns_dphy_power_on(struct phy *phy)
+{
+	struct cdns_dphy *dphy = phy_get_drvdata(phy);
+
+	/* Start TX state machine. */
+	writel(DPHY_CMN_SSM_EN | DPHY_CMN_TX_MODE_EN, dphy->regs + DPHY_CMN_SSM);
+
+	return 0;
+}
+
+static int cdns_dphy_exit(struct phy *phy)
+{
+	struct cdns_dphy *dphy = phy_get_drvdata(phy);
+
+	clk_disable_unprepare(dphy->pll_ref_clk);
+	clk_disable_unprepare(dphy->psm_clk);
+
+	return 0;
+}
+
+static struct phy_ops cdns_dphy_ops = {
+	.configure	= cdns_dphy_configure,
+	.validate	= cdns_dphy_validate,
+	.power_on	= cdns_dphy_power_on,
+	.init		= cdns_dphy_init,
+	.exit		= cdns_dphy_exit,
+};
+
+static int cdns_dphy_probe(struct platform_device *pdev)
+{
+	struct phy_provider *phy_provider;
+	struct cdns_dphy *dphy;
+	struct resource *res;
+	int ret;
+
+	dphy = devm_kzalloc(&pdev->dev, sizeof(*dphy), GFP_KERNEL);
+	if (!dphy)
+		return -ENOMEM;
+	dev_set_drvdata(&pdev->dev, dphy);
+
+	dphy->ops = of_device_get_match_data(&pdev->dev);
+	if (!dphy->ops)
+		return -EINVAL;
+
+	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	dphy->regs = devm_ioremap_resource(&pdev->dev, res);
+	if (IS_ERR(dphy->regs))
+		return PTR_ERR(dphy->regs);
+
+	dphy->psm_clk = devm_clk_get(&pdev->dev, "psm");
+	if (IS_ERR(dphy->psm_clk))
+		return PTR_ERR(dphy->psm_clk);
+
+	dphy->pll_ref_clk = devm_clk_get(&pdev->dev, "pll_ref");
+	if (IS_ERR(dphy->pll_ref_clk))
+		return PTR_ERR(dphy->pll_ref_clk);
+
+	if (dphy->ops->probe) {
+		ret = dphy->ops->probe(dphy);
+		if (ret)
+			return ret;
+	}
+
+	dphy->phy = devm_phy_create(&pdev->dev, NULL, &cdns_dphy_ops);
+	if (IS_ERR(dphy->phy)) {
+		dev_err(&pdev->dev, "failed to create PHY\n");
+		return PTR_ERR(dphy->phy);
+	}
+
+	phy_set_drvdata(dphy->phy, dphy);
+	phy_provider = devm_of_phy_provider_register(&pdev->dev, of_phy_simple_xlate);
+
+	return PTR_ERR_OR_ZERO(phy_provider);
+}
+
+static int cdns_dphy_remove(struct platform_device *pdev)
+{
+	struct cdns_dphy *dphy = dev_get_drvdata(&pdev->dev);
+
+	if (dphy->ops->remove)
+		dphy->ops->remove(dphy);
+
+	return 0;
+}
+
+static const struct of_device_id cdns_dphy_of_match[] = {
+	{ .compatible = "cdns,dphy", .data = &ref_dphy_ops },
+	{ /* sentinel */ },
+};
+MODULE_DEVICE_TABLE(of, cdns_dphy_of_match);
+
+static struct platform_driver cdns_dphy_platform_driver = {
+	.probe		= cdns_dphy_probe,
+	.remove		= cdns_dphy_remove,
+	.driver		= {
+		.name		= "cdns-mipi-dphy",
+		.of_match_table	= cdns_dphy_of_match,
+	},
+};
+module_platform_driver(cdns_dphy_platform_driver);
+
+MODULE_AUTHOR("Maxime Ripard <maxime.ripard@bootlin>");
+MODULE_DESCRIPTION("Cadence MIPI D-PHY Driver");
+MODULE_LICENSE("GPL");
-- 
git-series 0.9.1
