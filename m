Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.bootlin.com ([62.4.15.54]:39638 "EHLO mail.bootlin.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728031AbeIENqN (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 5 Sep 2018 09:46:13 -0400
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
Subject: [PATCH 04/10] phy: dphy: Add configuration helpers
Date: Wed,  5 Sep 2018 11:16:35 +0200
Message-Id: <aa491b814100a670ad16b646765005efbdae05d9.1536138624.git-series.maxime.ripard@bootlin.com>
In-Reply-To: <cover.ee6158898d563fcc01d45c9652501180bccff0f0.1536138624.git-series.maxime.ripard@bootlin.com>
References: <cover.ee6158898d563fcc01d45c9652501180bccff0f0.1536138624.git-series.maxime.ripard@bootlin.com>
In-Reply-To: <cover.ee6158898d563fcc01d45c9652501180bccff0f0.1536138624.git-series.maxime.ripard@bootlin.com>
References: <cover.ee6158898d563fcc01d45c9652501180bccff0f0.1536138624.git-series.maxime.ripard@bootlin.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The MIPI D-PHY spec defines default values and boundaries for most of the
parameters it defines. Introduce helpers to help drivers get meaningful
values based on their current parameters, and validate the boundaries of
these parameters if needed.

Signed-off-by: Maxime Ripard <maxime.ripard@bootlin.com>
---
 drivers/phy/Kconfig               |   8 ++-
 drivers/phy/Makefile              |   1 +-
 drivers/phy/phy-core-mipi-dphy.c  | 160 +++++++++++++++++++++++++++++++-
 include/linux/phy/phy-mipi-dphy.h |   6 +-
 4 files changed, 175 insertions(+)
 create mode 100644 drivers/phy/phy-core-mipi-dphy.c

diff --git a/drivers/phy/Kconfig b/drivers/phy/Kconfig
index 5c8d452e35e2..06bd22bd1f4a 100644
--- a/drivers/phy/Kconfig
+++ b/drivers/phy/Kconfig
@@ -15,6 +15,14 @@ config GENERIC_PHY
 	  phy users can obtain reference to the PHY. All the users of this
 	  framework should select this config.
 
+config GENERIC_PHY_MIPI_DPHY
+	bool "MIPI D-PHY support"
+	help
+	  Generic MIPI D-PHY support.
+
+	  Provides a number of helpers a core functions for MIPI D-PHY
+	  drivers to us.
+
 config PHY_LPC18XX_USB_OTG
 	tristate "NXP LPC18xx/43xx SoC USB OTG PHY driver"
 	depends on OF && (ARCH_LPC18XX || COMPILE_TEST)
diff --git a/drivers/phy/Makefile b/drivers/phy/Makefile
index 84e3bd9c5665..71c29d2b9af7 100644
--- a/drivers/phy/Makefile
+++ b/drivers/phy/Makefile
@@ -4,6 +4,7 @@
 #
 
 obj-$(CONFIG_GENERIC_PHY)		+= phy-core.o
+obj-$(CONFIG_GENERIC_PHY_MIPI_DPHY)	+= phy-core-mipi-dphy.o
 obj-$(CONFIG_PHY_LPC18XX_USB_OTG)	+= phy-lpc18xx-usb-otg.o
 obj-$(CONFIG_PHY_XGENE)			+= phy-xgene.o
 obj-$(CONFIG_PHY_PISTACHIO_USB)		+= phy-pistachio-usb.o
diff --git a/drivers/phy/phy-core-mipi-dphy.c b/drivers/phy/phy-core-mipi-dphy.c
new file mode 100644
index 000000000000..6c1ddc7734a2
--- /dev/null
+++ b/drivers/phy/phy-core-mipi-dphy.c
@@ -0,0 +1,160 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * Copyright (C) 2013 NVIDIA Corporation
+ * Copyright (C) 2018 Cadence Design Systems Inc.
+ */
+
+#include <linux/errno.h>
+#include <linux/export.h>
+#include <linux/kernel.h>
+#include <linux/time64.h>
+
+#include <linux/phy/phy.h>
+#include <linux/phy/phy-mipi-dphy.h>
+
+/*
+ * Default D-PHY timings based on MIPI D-PHY specification. Derived from the
+ * valid ranges specified in Section 6.9, Table 14, Page 40 of the D-PHY
+ * specification (v1.2) with minor adjustments.
+ */
+int phy_mipi_dphy_get_default_config(unsigned long pixel_clock,
+				     unsigned int bpp,
+				     unsigned int lanes,
+				     struct phy_configure_opts_mipi_dphy *cfg)
+{
+	unsigned long hs_clk_rate;
+	unsigned long ui;
+
+	if (!cfg)
+		return -EINVAL;
+
+	hs_clk_rate = pixel_clock * bpp / lanes;
+	ui = DIV_ROUND_UP(NSEC_PER_SEC, hs_clk_rate);
+
+	cfg->clk_miss = 0;
+	cfg->clk_post = 70 + 52 * ui;
+	cfg->clk_pre = 8;
+	cfg->clk_prepare = 65;
+	cfg->clk_settle = 95;
+	cfg->clk_term_en = 0;
+	cfg->clk_trail = 80;
+	cfg->clk_zero = 260;
+	cfg->d_term_en = 0;
+	cfg->eot = 0;
+	cfg->hs_exit = 120;
+	cfg->hs_prepare = 65 + 5 * ui;
+	cfg->hs_zero = 145 + 5 * ui;
+	cfg->hs_settle = 85 + 6 * ui;
+	cfg->hs_skip = 40;
+
+	/*
+	 * The MIPI D-PHY specification (Section 6.9, v1.2, Table 14, Page 40)
+	 * contains this formula as:
+	 *
+	 *     T_HS-TRAIL = max(n * 8 * ui, 60 + n * 4 * ui)
+	 *
+	 * where n = 1 for forward-direction HS mode and n = 4 for reverse-
+	 * direction HS mode. There's only one setting and this function does
+	 * not parameterize on anything other that ui, so this code will
+	 * assumes that reverse-direction HS mode is supported and uses n = 4.
+	 */
+	cfg->hs_trail = max(4 * 8 * ui, 60 + 4 * 4 * ui);
+
+	cfg->init = 100000;
+	cfg->lpx = 60;
+	cfg->ta_get = 5 * cfg->lpx;
+	cfg->ta_go = 4 * cfg->lpx;
+	cfg->ta_sure = 2 * cfg->lpx;
+	cfg->wakeup = 1000000;
+
+	cfg->hs_clk_rate = hs_clk_rate;
+	cfg->lanes = lanes;
+
+	return 0;
+}
+EXPORT_SYMBOL(phy_mipi_dphy_get_default_config);
+
+/*
+ * Validate D-PHY configuration according to MIPI D-PHY specification
+ * (v1.2, Section Section 6.9 "Global Operation Timing Parameters").
+ */
+int phy_mipi_dphy_config_validate(struct phy_configure_opts_mipi_dphy *cfg)
+{
+	unsigned long ui;
+
+	if (!cfg)
+		return -EINVAL;
+
+	ui = DIV_ROUND_UP(NSEC_PER_SEC, cfg->hs_clk_rate);
+
+	if (cfg->clk_miss > 60)
+		return -EINVAL;
+
+	if (cfg->clk_post < (60 + 52 * ui))
+		return -EINVAL;
+
+	if (cfg->clk_pre < 8)
+		return -EINVAL;
+
+	if (cfg->clk_prepare < 38 || cfg->clk_prepare > 95)
+		return -EINVAL;
+
+	if (cfg->clk_settle < 95 || cfg->clk_settle > 300)
+		return -EINVAL;
+
+	if (cfg->clk_term_en > 38)
+		return -EINVAL;
+
+	if (cfg->clk_trail < 60)
+		return -EINVAL;
+
+	if (cfg->clk_prepare + cfg->clk_zero < 300)
+		return -EINVAL;
+
+	if (cfg->d_term_en > 35 + 4 * ui)
+		return -EINVAL;
+
+	if (cfg->eot > 105 + 12 * ui)
+		return -EINVAL;
+
+	if (cfg->hs_exit < 100)
+		return -EINVAL;
+
+	if (cfg->hs_prepare < 40 + 4 * ui ||
+	    cfg->hs_prepare > 85 + 6 * ui)
+		return -EINVAL;
+
+	if (cfg->hs_prepare + cfg->hs_zero < 145 + 10 * ui)
+		return -EINVAL;
+
+	if ((cfg->hs_settle < 85 + 6 * ui) ||
+	    (cfg->hs_settle > 145 + 10 * ui))
+		return -EINVAL;
+
+	if (cfg->hs_skip < 40 || cfg->hs_skip > 55 + 4 * ui)
+		return -EINVAL;
+
+	if (cfg->hs_trail < max(8 * ui, 60 + 4 * ui))
+		return -EINVAL;
+
+	if (cfg->init < 100000)
+		return -EINVAL;
+
+	if (cfg->lpx < 50)
+		return -EINVAL;
+
+	if (cfg->ta_get != 5 * cfg->lpx)
+		return -EINVAL;
+
+	if (cfg->ta_go != 4 * cfg->lpx)
+		return -EINVAL;
+
+	if (cfg->ta_sure < cfg->lpx || cfg->ta_sure > 2 * cfg->lpx)
+		return -EINVAL;
+
+	if (cfg->wakeup < 1000000)
+		return -EINVAL;
+
+	return 0;
+}
+EXPORT_SYMBOL(phy_mipi_dphy_config_validate);
diff --git a/include/linux/phy/phy-mipi-dphy.h b/include/linux/phy/phy-mipi-dphy.h
index 792724145290..7656d057198f 100644
--- a/include/linux/phy/phy-mipi-dphy.h
+++ b/include/linux/phy/phy-mipi-dphy.h
@@ -238,4 +238,10 @@ struct phy_configure_opts_mipi_dphy {
 /* TODO: Add other modes (burst, commands, etc) */
 #define MIPI_DPHY_MODE_VIDEO_SYNC_PULSE		BIT(0)
 
+int phy_mipi_dphy_get_default_config(unsigned long pixel_clock,
+				     unsigned int bpp,
+				     unsigned int lanes,
+				     struct phy_configure_opts_mipi_dphy *cfg);
+int phy_mipi_dphy_config_validate(struct phy_configure_opts_mipi_dphy *cfg);
+
 #endif /* __PHY_MIPI_DPHY_H_ */
-- 
git-series 0.9.1
