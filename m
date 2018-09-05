Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.bootlin.com ([62.4.15.54]:39650 "EHLO mail.bootlin.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728110AbeIENqP (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 5 Sep 2018 09:46:15 -0400
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
Subject: [PATCH 06/10] phy: Move Allwinner A31 D-PHY driver to drivers/phy/
Date: Wed,  5 Sep 2018 11:16:37 +0200
Message-Id: <35ddeeef5dd79aba8b13e8fc3501f3355dece1f9.1536138624.git-series.maxime.ripard@bootlin.com>
In-Reply-To: <cover.ee6158898d563fcc01d45c9652501180bccff0f0.1536138624.git-series.maxime.ripard@bootlin.com>
References: <cover.ee6158898d563fcc01d45c9652501180bccff0f0.1536138624.git-series.maxime.ripard@bootlin.com>
In-Reply-To: <cover.ee6158898d563fcc01d45c9652501180bccff0f0.1536138624.git-series.maxime.ripard@bootlin.com>
References: <cover.ee6158898d563fcc01d45c9652501180bccff0f0.1536138624.git-series.maxime.ripard@bootlin.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Now that our MIPI D-PHY driver has been converted to the phy framework,
let's move it into the drivers/phy directory.

Signed-off-by: Maxime Ripard <maxime.ripard@bootlin.com>
---
 drivers/gpu/drm/sun4i/Kconfig               |  10 +-
 drivers/gpu/drm/sun4i/Makefile              |   1 +-
 drivers/gpu/drm/sun4i/sun6i_mipi_dphy.c     | 322 +---------------------
 drivers/phy/allwinner/Kconfig               |  12 +-
 drivers/phy/allwinner/Makefile              |   1 +-
 drivers/phy/allwinner/phy-sun6i-mipi-dphy.c | 322 +++++++++++++++++++++-
 6 files changed, 336 insertions(+), 332 deletions(-)
 delete mode 100644 drivers/gpu/drm/sun4i/sun6i_mipi_dphy.c
 create mode 100644 drivers/phy/allwinner/phy-sun6i-mipi-dphy.c

diff --git a/drivers/gpu/drm/sun4i/Kconfig b/drivers/gpu/drm/sun4i/Kconfig
index 2b8db82c4bab..1dbbc3a1b763 100644
--- a/drivers/gpu/drm/sun4i/Kconfig
+++ b/drivers/gpu/drm/sun4i/Kconfig
@@ -45,20 +45,12 @@ config DRM_SUN6I_DSI
 	default MACH_SUN8I
 	select CRC_CCITT
 	select DRM_MIPI_DSI
-	select DRM_SUN6I_DPHY
+	select PHY_SUN6I_MIPI_DPHY
 	help
 	  Choose this option if you want have an Allwinner SoC with
 	  MIPI-DSI support. If M is selected the module will be called
 	  sun6i_mipi_dsi.
 
-config DRM_SUN6I_DPHY
-	tristate "Allwinner A31 MIPI D-PHY Support"
-	select GENERIC_PHY_MIPI_DPHY
-	help
-	  Choose this option if you have an Allwinner SoC with
-	  MIPI-DSI support. If M is selected, the module will be
-	  called sun6i_mipi_dphy.
-
 config DRM_SUN8I_DW_HDMI
 	tristate "Support for Allwinner version of DesignWare HDMI"
 	depends on DRM_SUN4I
diff --git a/drivers/gpu/drm/sun4i/Makefile b/drivers/gpu/drm/sun4i/Makefile
index 1e2320d824b5..0d04f2447b01 100644
--- a/drivers/gpu/drm/sun4i/Makefile
+++ b/drivers/gpu/drm/sun4i/Makefile
@@ -34,7 +34,6 @@ ifdef CONFIG_DRM_SUN4I_BACKEND
 obj-$(CONFIG_DRM_SUN4I)		+= sun4i-frontend.o
 endif
 obj-$(CONFIG_DRM_SUN4I_HDMI)	+= sun4i-drm-hdmi.o
-obj-$(CONFIG_DRM_SUN6I_DPHY)	+= sun6i_mipi_dphy.o
 obj-$(CONFIG_DRM_SUN6I_DSI)	+= sun6i_mipi_dsi.o
 obj-$(CONFIG_DRM_SUN8I_DW_HDMI)	+= sun8i-drm-hdmi.o
 obj-$(CONFIG_DRM_SUN8I_MIXER)	+= sun8i-mixer.o
diff --git a/drivers/gpu/drm/sun4i/sun6i_mipi_dphy.c b/drivers/gpu/drm/sun4i/sun6i_mipi_dphy.c
deleted file mode 100644
index 37b340044fe1..000000000000
--- a/drivers/gpu/drm/sun4i/sun6i_mipi_dphy.c
+++ /dev/null
@@ -1,322 +0,0 @@
-// SPDX-License-Identifier: GPL-2.0+
-/*
- * Copyright (c) 2016 Allwinnertech Co., Ltd.
- * Copyright (C) 2017-2018 Bootlin
- *
- * Maxime Ripard <maxime.ripard@free-electrons.com>
- */
-
-#include <linux/bitops.h>
-#include <linux/clk.h>
-#include <linux/module.h>
-#include <linux/of_address.h>
-#include <linux/platform_device.h>
-#include <linux/regmap.h>
-#include <linux/reset.h>
-
-#include <linux/phy/phy.h>
-#include <linux/phy/phy-mipi-dphy.h>
-
-#define SUN6I_DPHY_GCTL_REG		0x00
-#define SUN6I_DPHY_GCTL_LANE_NUM(n)		((((n) - 1) & 3) << 4)
-#define SUN6I_DPHY_GCTL_EN			BIT(0)
-
-#define SUN6I_DPHY_TX_CTL_REG		0x04
-#define SUN6I_DPHY_TX_CTL_HS_TX_CLK_CONT	BIT(28)
-
-#define SUN6I_DPHY_TX_TIME0_REG		0x10
-#define SUN6I_DPHY_TX_TIME0_HS_TRAIL(n)		(((n) & 0xff) << 24)
-#define SUN6I_DPHY_TX_TIME0_HS_PREPARE(n)	(((n) & 0xff) << 16)
-#define SUN6I_DPHY_TX_TIME0_LP_CLK_DIV(n)	((n) & 0xff)
-
-#define SUN6I_DPHY_TX_TIME1_REG		0x14
-#define SUN6I_DPHY_TX_TIME1_CLK_POST(n)		(((n) & 0xff) << 24)
-#define SUN6I_DPHY_TX_TIME1_CLK_PRE(n)		(((n) & 0xff) << 16)
-#define SUN6I_DPHY_TX_TIME1_CLK_ZERO(n)		(((n) & 0xff) << 8)
-#define SUN6I_DPHY_TX_TIME1_CLK_PREPARE(n)	((n) & 0xff)
-
-#define SUN6I_DPHY_TX_TIME2_REG		0x18
-#define SUN6I_DPHY_TX_TIME2_CLK_TRAIL(n)	((n) & 0xff)
-
-#define SUN6I_DPHY_TX_TIME3_REG		0x1c
-
-#define SUN6I_DPHY_TX_TIME4_REG		0x20
-#define SUN6I_DPHY_TX_TIME4_HS_TX_ANA1(n)	(((n) & 0xff) << 8)
-#define SUN6I_DPHY_TX_TIME4_HS_TX_ANA0(n)	((n) & 0xff)
-
-#define SUN6I_DPHY_ANA0_REG		0x4c
-#define SUN6I_DPHY_ANA0_REG_PWS			BIT(31)
-#define SUN6I_DPHY_ANA0_REG_DMPC		BIT(28)
-#define SUN6I_DPHY_ANA0_REG_DMPD(n)		(((n) & 0xf) << 24)
-#define SUN6I_DPHY_ANA0_REG_SLV(n)		(((n) & 7) << 12)
-#define SUN6I_DPHY_ANA0_REG_DEN(n)		(((n) & 0xf) << 8)
-
-#define SUN6I_DPHY_ANA1_REG		0x50
-#define SUN6I_DPHY_ANA1_REG_VTTMODE		BIT(31)
-#define SUN6I_DPHY_ANA1_REG_CSMPS(n)		(((n) & 3) << 28)
-#define SUN6I_DPHY_ANA1_REG_SVTT(n)		(((n) & 0xf) << 24)
-
-#define SUN6I_DPHY_ANA2_REG		0x54
-#define SUN6I_DPHY_ANA2_EN_P2S_CPU(n)		(((n) & 0xf) << 24)
-#define SUN6I_DPHY_ANA2_EN_P2S_CPU_MASK		GENMASK(27, 24)
-#define SUN6I_DPHY_ANA2_EN_CK_CPU		BIT(4)
-#define SUN6I_DPHY_ANA2_REG_ENIB		BIT(1)
-
-#define SUN6I_DPHY_ANA3_REG		0x58
-#define SUN6I_DPHY_ANA3_EN_VTTD(n)		(((n) & 0xf) << 28)
-#define SUN6I_DPHY_ANA3_EN_VTTD_MASK		GENMASK(31, 28)
-#define SUN6I_DPHY_ANA3_EN_VTTC			BIT(27)
-#define SUN6I_DPHY_ANA3_EN_DIV			BIT(26)
-#define SUN6I_DPHY_ANA3_EN_LDOC			BIT(25)
-#define SUN6I_DPHY_ANA3_EN_LDOD			BIT(24)
-#define SUN6I_DPHY_ANA3_EN_LDOR			BIT(18)
-
-#define SUN6I_DPHY_ANA4_REG		0x5c
-#define SUN6I_DPHY_ANA4_REG_DMPLVC		BIT(24)
-#define SUN6I_DPHY_ANA4_REG_DMPLVD(n)		(((n) & 0xf) << 20)
-#define SUN6I_DPHY_ANA4_REG_CKDV(n)		(((n) & 0x1f) << 12)
-#define SUN6I_DPHY_ANA4_REG_TMSC(n)		(((n) & 3) << 10)
-#define SUN6I_DPHY_ANA4_REG_TMSD(n)		(((n) & 3) << 8)
-#define SUN6I_DPHY_ANA4_REG_TXDNSC(n)		(((n) & 3) << 6)
-#define SUN6I_DPHY_ANA4_REG_TXDNSD(n)		(((n) & 3) << 4)
-#define SUN6I_DPHY_ANA4_REG_TXPUSC(n)		(((n) & 3) << 2)
-#define SUN6I_DPHY_ANA4_REG_TXPUSD(n)		((n) & 3)
-
-#define SUN6I_DPHY_DBG5_REG		0xf4
-
-struct sun6i_dphy {
-	struct clk				*bus_clk;
-	struct clk				*mod_clk;
-	struct regmap				*regs;
-	struct reset_control			*reset;
-
-	struct phy				*phy;
-	struct phy_configure_opts_mipi_dphy	config;
-};
-
-static int sun6i_dphy_init(struct phy *phy)
-{
-	struct sun6i_dphy *dphy = phy_get_drvdata(phy);
-
-	reset_control_deassert(dphy->reset);
-	clk_prepare_enable(dphy->mod_clk);
-	clk_set_rate_exclusive(dphy->mod_clk, 150000000);
-
-	return 0;
-}
-
-static int sun6i_dphy_configure(struct phy *phy, enum phy_mode mode,
-				union phy_configure_opts *opts)
-{
-	struct sun6i_dphy *dphy = phy_get_drvdata(phy);
-	int ret;
-
-	if (mode != PHY_MODE_MIPI_DPHY)
-		return -EINVAL;
-
-	ret = phy_mipi_dphy_config_validate(&opts->mipi_dphy);
-	if (ret)
-		return ret;
-
-	memcpy(&dphy->config, opts, sizeof(dphy->config));
-
-	return 0;
-}
-
-static int sun6i_dphy_power_on(struct phy *phy)
-{
-	struct sun6i_dphy *dphy = phy_get_drvdata(phy);
-	u8 lanes_mask = GENMASK(dphy->config.lanes - 1, 0);
-
-	regmap_write(dphy->regs, SUN6I_DPHY_TX_CTL_REG,
-		     SUN6I_DPHY_TX_CTL_HS_TX_CLK_CONT);
-
-	regmap_write(dphy->regs, SUN6I_DPHY_TX_TIME0_REG,
-		     SUN6I_DPHY_TX_TIME0_LP_CLK_DIV(14) |
-		     SUN6I_DPHY_TX_TIME0_HS_PREPARE(6) |
-		     SUN6I_DPHY_TX_TIME0_HS_TRAIL(10));
-
-	regmap_write(dphy->regs, SUN6I_DPHY_TX_TIME1_REG,
-		     SUN6I_DPHY_TX_TIME1_CLK_PREPARE(7) |
-		     SUN6I_DPHY_TX_TIME1_CLK_ZERO(50) |
-		     SUN6I_DPHY_TX_TIME1_CLK_PRE(3) |
-		     SUN6I_DPHY_TX_TIME1_CLK_POST(10));
-
-	regmap_write(dphy->regs, SUN6I_DPHY_TX_TIME2_REG,
-		     SUN6I_DPHY_TX_TIME2_CLK_TRAIL(30));
-
-	regmap_write(dphy->regs, SUN6I_DPHY_TX_TIME3_REG, 0);
-
-	regmap_write(dphy->regs, SUN6I_DPHY_TX_TIME4_REG,
-		     SUN6I_DPHY_TX_TIME4_HS_TX_ANA0(3) |
-		     SUN6I_DPHY_TX_TIME4_HS_TX_ANA1(3));
-
-	regmap_write(dphy->regs, SUN6I_DPHY_GCTL_REG,
-		     SUN6I_DPHY_GCTL_LANE_NUM(dphy->config.lanes) |
-		     SUN6I_DPHY_GCTL_EN);
-
-	regmap_write(dphy->regs, SUN6I_DPHY_ANA0_REG,
-		     SUN6I_DPHY_ANA0_REG_PWS |
-		     SUN6I_DPHY_ANA0_REG_DMPC |
-		     SUN6I_DPHY_ANA0_REG_SLV(7) |
-		     SUN6I_DPHY_ANA0_REG_DMPD(lanes_mask) |
-		     SUN6I_DPHY_ANA0_REG_DEN(lanes_mask));
-
-	regmap_write(dphy->regs, SUN6I_DPHY_ANA1_REG,
-		     SUN6I_DPHY_ANA1_REG_CSMPS(1) |
-		     SUN6I_DPHY_ANA1_REG_SVTT(7));
-
-	regmap_write(dphy->regs, SUN6I_DPHY_ANA4_REG,
-		     SUN6I_DPHY_ANA4_REG_CKDV(1) |
-		     SUN6I_DPHY_ANA4_REG_TMSC(1) |
-		     SUN6I_DPHY_ANA4_REG_TMSD(1) |
-		     SUN6I_DPHY_ANA4_REG_TXDNSC(1) |
-		     SUN6I_DPHY_ANA4_REG_TXDNSD(1) |
-		     SUN6I_DPHY_ANA4_REG_TXPUSC(1) |
-		     SUN6I_DPHY_ANA4_REG_TXPUSD(1) |
-		     SUN6I_DPHY_ANA4_REG_DMPLVC |
-		     SUN6I_DPHY_ANA4_REG_DMPLVD(lanes_mask));
-
-	regmap_write(dphy->regs, SUN6I_DPHY_ANA2_REG,
-		     SUN6I_DPHY_ANA2_REG_ENIB);
-	udelay(5);
-
-	regmap_write(dphy->regs, SUN6I_DPHY_ANA3_REG,
-		     SUN6I_DPHY_ANA3_EN_LDOR |
-		     SUN6I_DPHY_ANA3_EN_LDOC |
-		     SUN6I_DPHY_ANA3_EN_LDOD);
-	udelay(1);
-
-	regmap_update_bits(dphy->regs, SUN6I_DPHY_ANA3_REG,
-			   SUN6I_DPHY_ANA3_EN_VTTC |
-			   SUN6I_DPHY_ANA3_EN_VTTD_MASK,
-			   SUN6I_DPHY_ANA3_EN_VTTC |
-			   SUN6I_DPHY_ANA3_EN_VTTD(lanes_mask));
-	udelay(1);
-
-	regmap_update_bits(dphy->regs, SUN6I_DPHY_ANA3_REG,
-			   SUN6I_DPHY_ANA3_EN_DIV,
-			   SUN6I_DPHY_ANA3_EN_DIV);
-	udelay(1);
-
-	regmap_update_bits(dphy->regs, SUN6I_DPHY_ANA2_REG,
-			   SUN6I_DPHY_ANA2_EN_CK_CPU,
-			   SUN6I_DPHY_ANA2_EN_CK_CPU);
-	udelay(1);
-
-	regmap_update_bits(dphy->regs, SUN6I_DPHY_ANA1_REG,
-			   SUN6I_DPHY_ANA1_REG_VTTMODE,
-			   SUN6I_DPHY_ANA1_REG_VTTMODE);
-
-	regmap_update_bits(dphy->regs, SUN6I_DPHY_ANA2_REG,
-			   SUN6I_DPHY_ANA2_EN_P2S_CPU_MASK,
-			   SUN6I_DPHY_ANA2_EN_P2S_CPU(lanes_mask));
-
-	return 0;
-}
-
-static int sun6i_dphy_power_off(struct phy *phy)
-{
-	struct sun6i_dphy *dphy = phy_get_drvdata(phy);
-
-	regmap_update_bits(dphy->regs, SUN6I_DPHY_ANA1_REG,
-			   SUN6I_DPHY_ANA1_REG_VTTMODE, 0);
-
-	return 0;
-}
-
-static int sun6i_dphy_exit(struct phy *phy)
-{
-	struct sun6i_dphy *dphy = phy_get_drvdata(phy);
-
-	clk_rate_exclusive_put(dphy->mod_clk);
-	clk_disable_unprepare(dphy->mod_clk);
-	reset_control_assert(dphy->reset);
-
-	return 0;
-}
-
-
-static struct phy_ops sun6i_dphy_ops = {
-	.configure	= sun6i_dphy_configure,
-	.power_on	= sun6i_dphy_power_on,
-	.power_off	= sun6i_dphy_power_off,
-	.init		= sun6i_dphy_init,
-	.exit		= sun6i_dphy_exit,
-};
-
-static struct regmap_config sun6i_dphy_regmap_config = {
-	.reg_bits	= 32,
-	.val_bits	= 32,
-	.reg_stride	= 4,
-	.max_register	= SUN6I_DPHY_DBG5_REG,
-	.name		= "mipi-dphy",
-};
-
-static int sun6i_dphy_probe(struct platform_device *pdev)
-{
-	struct phy_provider *phy_provider;
-	struct sun6i_dphy *dphy;
-	struct resource *res;
-	void __iomem *regs;
-
-	dphy = devm_kzalloc(&pdev->dev, sizeof(*dphy), GFP_KERNEL);
-	if (!dphy)
-		return -ENOMEM;
-
-	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	regs = devm_ioremap_resource(&pdev->dev, res);
-	if (IS_ERR(regs)) {
-		dev_err(&pdev->dev, "Couldn't map the DPHY encoder registers\n");
-		return PTR_ERR(regs);
-	}
-
-	dphy->regs = devm_regmap_init_mmio_clk(&pdev->dev, "bus",
-					       regs, &sun6i_dphy_regmap_config);
-	if (IS_ERR(dphy->regs)) {
-		dev_err(&pdev->dev, "Couldn't create the DPHY encoder regmap\n");
-		return PTR_ERR(dphy->regs);
-	}
-
-	dphy->reset = devm_reset_control_get_shared(&pdev->dev, NULL);
-	if (IS_ERR(dphy->reset)) {
-		dev_err(&pdev->dev, "Couldn't get our reset line\n");
-		return PTR_ERR(dphy->reset);
-	}
-
-	dphy->mod_clk = devm_clk_get(&pdev->dev, "mod");
-	if (IS_ERR(dphy->mod_clk)) {
-		dev_err(&pdev->dev, "Couldn't get the DPHY mod clock\n");
-		return PTR_ERR(dphy->mod_clk);
-	}
-
-	dphy->phy = devm_phy_create(&pdev->dev, NULL, &sun6i_dphy_ops);
-	if (IS_ERR(dphy->phy)) {
-		dev_err(&pdev->dev, "failed to create PHY\n");
-		return PTR_ERR(dphy->phy);
-	}
-
-	phy_set_drvdata(dphy->phy, dphy);
-	phy_provider = devm_of_phy_provider_register(&pdev->dev, of_phy_simple_xlate);
-
-	return PTR_ERR_OR_ZERO(phy_provider);
-}
-
-static const struct of_device_id sun6i_dphy_of_table[] = {
-	{ .compatible = "allwinner,sun6i-a31-mipi-dphy" },
-	{ }
-};
-MODULE_DEVICE_TABLE(of, sun6i_dphy_of_table);
-
-static struct platform_driver sun6i_dphy_platform_driver = {
-	.probe		= sun6i_dphy_probe,
-	.driver		= {
-		.name		= "sun6i-mipi-dphy",
-		.of_match_table	= sun6i_dphy_of_table,
-	},
-};
-module_platform_driver(sun6i_dphy_platform_driver);
-
-MODULE_AUTHOR("Maxime Ripard <maxime.ripard@bootlin>");
-MODULE_DESCRIPTION("Allwinner A31 MIPI D-PHY Driver");
-MODULE_LICENSE("GPL");
diff --git a/drivers/phy/allwinner/Kconfig b/drivers/phy/allwinner/Kconfig
index cdc1e745ba47..fb1204bcc454 100644
--- a/drivers/phy/allwinner/Kconfig
+++ b/drivers/phy/allwinner/Kconfig
@@ -17,6 +17,18 @@ config PHY_SUN4I_USB
 	  This driver controls the entire USB PHY block, both the USB OTG
 	  parts, as well as the 2 regular USB 2 host PHYs.
 
+config PHY_SUN6I_MIPI_DPHY
+	tristate "Allwinner A31 MIPI D-PHY Support"
+	depends on ARCH_SUNXI && HAS_IOMEM && OF
+	depends on RESET_CONTROLLER
+	select GENERIC_PHY
+	select GENERIC_PHY_MIPI_DPHY
+	select REGMAP_MMIO
+	help
+	  Choose this option if you have an Allwinner SoC with
+	  MIPI-DSI support. If M is selected, the module will be
+	  called sun6i_mipi_dphy.
+
 config PHY_SUN9I_USB
 	tristate "Allwinner sun9i SoC USB PHY driver"
 	depends on ARCH_SUNXI && HAS_IOMEM && OF
diff --git a/drivers/phy/allwinner/Makefile b/drivers/phy/allwinner/Makefile
index 8605529c01a1..7d0053efbfaa 100644
--- a/drivers/phy/allwinner/Makefile
+++ b/drivers/phy/allwinner/Makefile
@@ -1,2 +1,3 @@
 obj-$(CONFIG_PHY_SUN4I_USB)		+= phy-sun4i-usb.o
+obj-$(CONFIG_PHY_SUN6I_MIPI_DPHY)	+= phy-sun6i-mipi-dphy.o
 obj-$(CONFIG_PHY_SUN9I_USB)		+= phy-sun9i-usb.o
diff --git a/drivers/phy/allwinner/phy-sun6i-mipi-dphy.c b/drivers/phy/allwinner/phy-sun6i-mipi-dphy.c
new file mode 100644
index 000000000000..37b340044fe1
--- /dev/null
+++ b/drivers/phy/allwinner/phy-sun6i-mipi-dphy.c
@@ -0,0 +1,322 @@
+// SPDX-License-Identifier: GPL-2.0+
+/*
+ * Copyright (c) 2016 Allwinnertech Co., Ltd.
+ * Copyright (C) 2017-2018 Bootlin
+ *
+ * Maxime Ripard <maxime.ripard@free-electrons.com>
+ */
+
+#include <linux/bitops.h>
+#include <linux/clk.h>
+#include <linux/module.h>
+#include <linux/of_address.h>
+#include <linux/platform_device.h>
+#include <linux/regmap.h>
+#include <linux/reset.h>
+
+#include <linux/phy/phy.h>
+#include <linux/phy/phy-mipi-dphy.h>
+
+#define SUN6I_DPHY_GCTL_REG		0x00
+#define SUN6I_DPHY_GCTL_LANE_NUM(n)		((((n) - 1) & 3) << 4)
+#define SUN6I_DPHY_GCTL_EN			BIT(0)
+
+#define SUN6I_DPHY_TX_CTL_REG		0x04
+#define SUN6I_DPHY_TX_CTL_HS_TX_CLK_CONT	BIT(28)
+
+#define SUN6I_DPHY_TX_TIME0_REG		0x10
+#define SUN6I_DPHY_TX_TIME0_HS_TRAIL(n)		(((n) & 0xff) << 24)
+#define SUN6I_DPHY_TX_TIME0_HS_PREPARE(n)	(((n) & 0xff) << 16)
+#define SUN6I_DPHY_TX_TIME0_LP_CLK_DIV(n)	((n) & 0xff)
+
+#define SUN6I_DPHY_TX_TIME1_REG		0x14
+#define SUN6I_DPHY_TX_TIME1_CLK_POST(n)		(((n) & 0xff) << 24)
+#define SUN6I_DPHY_TX_TIME1_CLK_PRE(n)		(((n) & 0xff) << 16)
+#define SUN6I_DPHY_TX_TIME1_CLK_ZERO(n)		(((n) & 0xff) << 8)
+#define SUN6I_DPHY_TX_TIME1_CLK_PREPARE(n)	((n) & 0xff)
+
+#define SUN6I_DPHY_TX_TIME2_REG		0x18
+#define SUN6I_DPHY_TX_TIME2_CLK_TRAIL(n)	((n) & 0xff)
+
+#define SUN6I_DPHY_TX_TIME3_REG		0x1c
+
+#define SUN6I_DPHY_TX_TIME4_REG		0x20
+#define SUN6I_DPHY_TX_TIME4_HS_TX_ANA1(n)	(((n) & 0xff) << 8)
+#define SUN6I_DPHY_TX_TIME4_HS_TX_ANA0(n)	((n) & 0xff)
+
+#define SUN6I_DPHY_ANA0_REG		0x4c
+#define SUN6I_DPHY_ANA0_REG_PWS			BIT(31)
+#define SUN6I_DPHY_ANA0_REG_DMPC		BIT(28)
+#define SUN6I_DPHY_ANA0_REG_DMPD(n)		(((n) & 0xf) << 24)
+#define SUN6I_DPHY_ANA0_REG_SLV(n)		(((n) & 7) << 12)
+#define SUN6I_DPHY_ANA0_REG_DEN(n)		(((n) & 0xf) << 8)
+
+#define SUN6I_DPHY_ANA1_REG		0x50
+#define SUN6I_DPHY_ANA1_REG_VTTMODE		BIT(31)
+#define SUN6I_DPHY_ANA1_REG_CSMPS(n)		(((n) & 3) << 28)
+#define SUN6I_DPHY_ANA1_REG_SVTT(n)		(((n) & 0xf) << 24)
+
+#define SUN6I_DPHY_ANA2_REG		0x54
+#define SUN6I_DPHY_ANA2_EN_P2S_CPU(n)		(((n) & 0xf) << 24)
+#define SUN6I_DPHY_ANA2_EN_P2S_CPU_MASK		GENMASK(27, 24)
+#define SUN6I_DPHY_ANA2_EN_CK_CPU		BIT(4)
+#define SUN6I_DPHY_ANA2_REG_ENIB		BIT(1)
+
+#define SUN6I_DPHY_ANA3_REG		0x58
+#define SUN6I_DPHY_ANA3_EN_VTTD(n)		(((n) & 0xf) << 28)
+#define SUN6I_DPHY_ANA3_EN_VTTD_MASK		GENMASK(31, 28)
+#define SUN6I_DPHY_ANA3_EN_VTTC			BIT(27)
+#define SUN6I_DPHY_ANA3_EN_DIV			BIT(26)
+#define SUN6I_DPHY_ANA3_EN_LDOC			BIT(25)
+#define SUN6I_DPHY_ANA3_EN_LDOD			BIT(24)
+#define SUN6I_DPHY_ANA3_EN_LDOR			BIT(18)
+
+#define SUN6I_DPHY_ANA4_REG		0x5c
+#define SUN6I_DPHY_ANA4_REG_DMPLVC		BIT(24)
+#define SUN6I_DPHY_ANA4_REG_DMPLVD(n)		(((n) & 0xf) << 20)
+#define SUN6I_DPHY_ANA4_REG_CKDV(n)		(((n) & 0x1f) << 12)
+#define SUN6I_DPHY_ANA4_REG_TMSC(n)		(((n) & 3) << 10)
+#define SUN6I_DPHY_ANA4_REG_TMSD(n)		(((n) & 3) << 8)
+#define SUN6I_DPHY_ANA4_REG_TXDNSC(n)		(((n) & 3) << 6)
+#define SUN6I_DPHY_ANA4_REG_TXDNSD(n)		(((n) & 3) << 4)
+#define SUN6I_DPHY_ANA4_REG_TXPUSC(n)		(((n) & 3) << 2)
+#define SUN6I_DPHY_ANA4_REG_TXPUSD(n)		((n) & 3)
+
+#define SUN6I_DPHY_DBG5_REG		0xf4
+
+struct sun6i_dphy {
+	struct clk				*bus_clk;
+	struct clk				*mod_clk;
+	struct regmap				*regs;
+	struct reset_control			*reset;
+
+	struct phy				*phy;
+	struct phy_configure_opts_mipi_dphy	config;
+};
+
+static int sun6i_dphy_init(struct phy *phy)
+{
+	struct sun6i_dphy *dphy = phy_get_drvdata(phy);
+
+	reset_control_deassert(dphy->reset);
+	clk_prepare_enable(dphy->mod_clk);
+	clk_set_rate_exclusive(dphy->mod_clk, 150000000);
+
+	return 0;
+}
+
+static int sun6i_dphy_configure(struct phy *phy, enum phy_mode mode,
+				union phy_configure_opts *opts)
+{
+	struct sun6i_dphy *dphy = phy_get_drvdata(phy);
+	int ret;
+
+	if (mode != PHY_MODE_MIPI_DPHY)
+		return -EINVAL;
+
+	ret = phy_mipi_dphy_config_validate(&opts->mipi_dphy);
+	if (ret)
+		return ret;
+
+	memcpy(&dphy->config, opts, sizeof(dphy->config));
+
+	return 0;
+}
+
+static int sun6i_dphy_power_on(struct phy *phy)
+{
+	struct sun6i_dphy *dphy = phy_get_drvdata(phy);
+	u8 lanes_mask = GENMASK(dphy->config.lanes - 1, 0);
+
+	regmap_write(dphy->regs, SUN6I_DPHY_TX_CTL_REG,
+		     SUN6I_DPHY_TX_CTL_HS_TX_CLK_CONT);
+
+	regmap_write(dphy->regs, SUN6I_DPHY_TX_TIME0_REG,
+		     SUN6I_DPHY_TX_TIME0_LP_CLK_DIV(14) |
+		     SUN6I_DPHY_TX_TIME0_HS_PREPARE(6) |
+		     SUN6I_DPHY_TX_TIME0_HS_TRAIL(10));
+
+	regmap_write(dphy->regs, SUN6I_DPHY_TX_TIME1_REG,
+		     SUN6I_DPHY_TX_TIME1_CLK_PREPARE(7) |
+		     SUN6I_DPHY_TX_TIME1_CLK_ZERO(50) |
+		     SUN6I_DPHY_TX_TIME1_CLK_PRE(3) |
+		     SUN6I_DPHY_TX_TIME1_CLK_POST(10));
+
+	regmap_write(dphy->regs, SUN6I_DPHY_TX_TIME2_REG,
+		     SUN6I_DPHY_TX_TIME2_CLK_TRAIL(30));
+
+	regmap_write(dphy->regs, SUN6I_DPHY_TX_TIME3_REG, 0);
+
+	regmap_write(dphy->regs, SUN6I_DPHY_TX_TIME4_REG,
+		     SUN6I_DPHY_TX_TIME4_HS_TX_ANA0(3) |
+		     SUN6I_DPHY_TX_TIME4_HS_TX_ANA1(3));
+
+	regmap_write(dphy->regs, SUN6I_DPHY_GCTL_REG,
+		     SUN6I_DPHY_GCTL_LANE_NUM(dphy->config.lanes) |
+		     SUN6I_DPHY_GCTL_EN);
+
+	regmap_write(dphy->regs, SUN6I_DPHY_ANA0_REG,
+		     SUN6I_DPHY_ANA0_REG_PWS |
+		     SUN6I_DPHY_ANA0_REG_DMPC |
+		     SUN6I_DPHY_ANA0_REG_SLV(7) |
+		     SUN6I_DPHY_ANA0_REG_DMPD(lanes_mask) |
+		     SUN6I_DPHY_ANA0_REG_DEN(lanes_mask));
+
+	regmap_write(dphy->regs, SUN6I_DPHY_ANA1_REG,
+		     SUN6I_DPHY_ANA1_REG_CSMPS(1) |
+		     SUN6I_DPHY_ANA1_REG_SVTT(7));
+
+	regmap_write(dphy->regs, SUN6I_DPHY_ANA4_REG,
+		     SUN6I_DPHY_ANA4_REG_CKDV(1) |
+		     SUN6I_DPHY_ANA4_REG_TMSC(1) |
+		     SUN6I_DPHY_ANA4_REG_TMSD(1) |
+		     SUN6I_DPHY_ANA4_REG_TXDNSC(1) |
+		     SUN6I_DPHY_ANA4_REG_TXDNSD(1) |
+		     SUN6I_DPHY_ANA4_REG_TXPUSC(1) |
+		     SUN6I_DPHY_ANA4_REG_TXPUSD(1) |
+		     SUN6I_DPHY_ANA4_REG_DMPLVC |
+		     SUN6I_DPHY_ANA4_REG_DMPLVD(lanes_mask));
+
+	regmap_write(dphy->regs, SUN6I_DPHY_ANA2_REG,
+		     SUN6I_DPHY_ANA2_REG_ENIB);
+	udelay(5);
+
+	regmap_write(dphy->regs, SUN6I_DPHY_ANA3_REG,
+		     SUN6I_DPHY_ANA3_EN_LDOR |
+		     SUN6I_DPHY_ANA3_EN_LDOC |
+		     SUN6I_DPHY_ANA3_EN_LDOD);
+	udelay(1);
+
+	regmap_update_bits(dphy->regs, SUN6I_DPHY_ANA3_REG,
+			   SUN6I_DPHY_ANA3_EN_VTTC |
+			   SUN6I_DPHY_ANA3_EN_VTTD_MASK,
+			   SUN6I_DPHY_ANA3_EN_VTTC |
+			   SUN6I_DPHY_ANA3_EN_VTTD(lanes_mask));
+	udelay(1);
+
+	regmap_update_bits(dphy->regs, SUN6I_DPHY_ANA3_REG,
+			   SUN6I_DPHY_ANA3_EN_DIV,
+			   SUN6I_DPHY_ANA3_EN_DIV);
+	udelay(1);
+
+	regmap_update_bits(dphy->regs, SUN6I_DPHY_ANA2_REG,
+			   SUN6I_DPHY_ANA2_EN_CK_CPU,
+			   SUN6I_DPHY_ANA2_EN_CK_CPU);
+	udelay(1);
+
+	regmap_update_bits(dphy->regs, SUN6I_DPHY_ANA1_REG,
+			   SUN6I_DPHY_ANA1_REG_VTTMODE,
+			   SUN6I_DPHY_ANA1_REG_VTTMODE);
+
+	regmap_update_bits(dphy->regs, SUN6I_DPHY_ANA2_REG,
+			   SUN6I_DPHY_ANA2_EN_P2S_CPU_MASK,
+			   SUN6I_DPHY_ANA2_EN_P2S_CPU(lanes_mask));
+
+	return 0;
+}
+
+static int sun6i_dphy_power_off(struct phy *phy)
+{
+	struct sun6i_dphy *dphy = phy_get_drvdata(phy);
+
+	regmap_update_bits(dphy->regs, SUN6I_DPHY_ANA1_REG,
+			   SUN6I_DPHY_ANA1_REG_VTTMODE, 0);
+
+	return 0;
+}
+
+static int sun6i_dphy_exit(struct phy *phy)
+{
+	struct sun6i_dphy *dphy = phy_get_drvdata(phy);
+
+	clk_rate_exclusive_put(dphy->mod_clk);
+	clk_disable_unprepare(dphy->mod_clk);
+	reset_control_assert(dphy->reset);
+
+	return 0;
+}
+
+
+static struct phy_ops sun6i_dphy_ops = {
+	.configure	= sun6i_dphy_configure,
+	.power_on	= sun6i_dphy_power_on,
+	.power_off	= sun6i_dphy_power_off,
+	.init		= sun6i_dphy_init,
+	.exit		= sun6i_dphy_exit,
+};
+
+static struct regmap_config sun6i_dphy_regmap_config = {
+	.reg_bits	= 32,
+	.val_bits	= 32,
+	.reg_stride	= 4,
+	.max_register	= SUN6I_DPHY_DBG5_REG,
+	.name		= "mipi-dphy",
+};
+
+static int sun6i_dphy_probe(struct platform_device *pdev)
+{
+	struct phy_provider *phy_provider;
+	struct sun6i_dphy *dphy;
+	struct resource *res;
+	void __iomem *regs;
+
+	dphy = devm_kzalloc(&pdev->dev, sizeof(*dphy), GFP_KERNEL);
+	if (!dphy)
+		return -ENOMEM;
+
+	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	regs = devm_ioremap_resource(&pdev->dev, res);
+	if (IS_ERR(regs)) {
+		dev_err(&pdev->dev, "Couldn't map the DPHY encoder registers\n");
+		return PTR_ERR(regs);
+	}
+
+	dphy->regs = devm_regmap_init_mmio_clk(&pdev->dev, "bus",
+					       regs, &sun6i_dphy_regmap_config);
+	if (IS_ERR(dphy->regs)) {
+		dev_err(&pdev->dev, "Couldn't create the DPHY encoder regmap\n");
+		return PTR_ERR(dphy->regs);
+	}
+
+	dphy->reset = devm_reset_control_get_shared(&pdev->dev, NULL);
+	if (IS_ERR(dphy->reset)) {
+		dev_err(&pdev->dev, "Couldn't get our reset line\n");
+		return PTR_ERR(dphy->reset);
+	}
+
+	dphy->mod_clk = devm_clk_get(&pdev->dev, "mod");
+	if (IS_ERR(dphy->mod_clk)) {
+		dev_err(&pdev->dev, "Couldn't get the DPHY mod clock\n");
+		return PTR_ERR(dphy->mod_clk);
+	}
+
+	dphy->phy = devm_phy_create(&pdev->dev, NULL, &sun6i_dphy_ops);
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
+static const struct of_device_id sun6i_dphy_of_table[] = {
+	{ .compatible = "allwinner,sun6i-a31-mipi-dphy" },
+	{ }
+};
+MODULE_DEVICE_TABLE(of, sun6i_dphy_of_table);
+
+static struct platform_driver sun6i_dphy_platform_driver = {
+	.probe		= sun6i_dphy_probe,
+	.driver		= {
+		.name		= "sun6i-mipi-dphy",
+		.of_match_table	= sun6i_dphy_of_table,
+	},
+};
+module_platform_driver(sun6i_dphy_platform_driver);
+
+MODULE_AUTHOR("Maxime Ripard <maxime.ripard@bootlin>");
+MODULE_DESCRIPTION("Allwinner A31 MIPI D-PHY Driver");
+MODULE_LICENSE("GPL");
-- 
git-series 0.9.1
