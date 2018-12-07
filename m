Return-Path: <SRS0=1NWX=OQ=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B2224C07E85
	for <linux-media@archiver.kernel.org>; Fri,  7 Dec 2018 13:56:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 70E0E20837
	for <linux-media@archiver.kernel.org>; Fri,  7 Dec 2018 13:56:44 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 70E0E20837
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=bootlin.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-media-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726273AbeLGN4h (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Fri, 7 Dec 2018 08:56:37 -0500
Received: from mail.bootlin.com ([62.4.15.54]:58720 "EHLO mail.bootlin.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726159AbeLGN4D (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 7 Dec 2018 08:56:03 -0500
Received: by mail.bootlin.com (Postfix, from userid 110)
        id 8202A20E2C; Fri,  7 Dec 2018 14:56:01 +0100 (CET)
Received: from localhost (aaubervilliers-681-1-79-44.w90-88.abo.wanadoo.fr [90.88.21.44])
        by mail.bootlin.com (Postfix) with ESMTPSA id 199DB20CDF;
        Fri,  7 Dec 2018 14:55:43 +0100 (CET)
From:   Maxime Ripard <maxime.ripard@bootlin.com>
To:     Kishon Vijay Abraham I <kishon@ti.com>,
        Boris Brezillon <boris.brezillon@bootlin.com>
Cc:     Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
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
Subject: [PATCH v3 04/10] phy: dphy: Add configuration helpers
Date:   Fri,  7 Dec 2018 14:55:31 +0100
Message-Id: <0dffe403b8df150746c57c067afe1f4a8c262200.1544190837.git-series.maxime.ripard@bootlin.com>
X-Mailer: git-send-email 2.19.2
In-Reply-To: <cover.ad7c4feb3905658f10b022df4756a5ade280011f.1544190837.git-series.maxime.ripard@bootlin.com>
References: <cover.ad7c4feb3905658f10b022df4756a5ade280011f.1544190837.git-series.maxime.ripard@bootlin.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

The MIPI D-PHY spec defines default values and boundaries for most of the
parameters it defines. Introduce helpers to help drivers get meaningful
values based on their current parameters, and validate the boundaries of
these parameters if needed.

Signed-off-by: Maxime Ripard <maxime.ripard@bootlin.com>
---
 drivers/phy/Kconfig               |   8 +-
 drivers/phy/Makefile              |   1 +-
 drivers/phy/phy-core-mipi-dphy.c  | 166 +++++++++++++++++++++++++++++++-
 include/linux/phy/phy-mipi-dphy.h |   6 +-
 4 files changed, 181 insertions(+)
 create mode 100644 drivers/phy/phy-core-mipi-dphy.c

diff --git a/drivers/phy/Kconfig b/drivers/phy/Kconfig
index 60f949e2a684..c87a7d49eaab 100644
--- a/drivers/phy/Kconfig
+++ b/drivers/phy/Kconfig
@@ -15,6 +15,14 @@ config GENERIC_PHY
 	  phy users can obtain reference to the PHY. All the users of this
 	  framework should select this config.
 
+config GENERIC_PHY_MIPI_DPHY
+	bool
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
index 0301e25d07c1..baec59cebbab 100644
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
index 000000000000..465fa1b91a5f
--- /dev/null
+++ b/drivers/phy/phy-core-mipi-dphy.c
@@ -0,0 +1,166 @@
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
+#define PSEC_PER_SEC	1000000000000LL
+
+/*
+ * Minimum D-PHY timings based on MIPI D-PHY specification. Derived
+ * from the valid ranges specified in Section 6.9, Table 14, Page 41
+ * of the D-PHY specification (v2.1).
+ */
+int phy_mipi_dphy_get_default_config(unsigned long pixel_clock,
+				     unsigned int bpp,
+				     unsigned int lanes,
+				     struct phy_configure_opts_mipi_dphy *cfg)
+{
+	unsigned long long hs_clk_rate;
+	unsigned long long ui;
+
+	if (!cfg)
+		return -EINVAL;
+
+	hs_clk_rate = pixel_clock * bpp;
+	do_div(hs_clk_rate, lanes);
+
+	ui = ALIGN(PSEC_PER_SEC, hs_clk_rate);
+	do_div(ui, hs_clk_rate);
+
+	cfg->clk_miss = 0;
+	cfg->clk_post = 60000 + 52 * ui;
+	cfg->clk_pre = 8000;
+	cfg->clk_prepare = 38000;
+	cfg->clk_settle = 95000;
+	cfg->clk_term_en = 0;
+	cfg->clk_trail = 60000;
+	cfg->clk_zero = 262000;
+	cfg->d_term_en = 0;
+	cfg->eot = 0;
+	cfg->hs_exit = 100000;
+	cfg->hs_prepare = 40000 + 4 * ui;
+	cfg->hs_zero = 105000 + 6 * ui;
+	cfg->hs_settle = 85000 + 6 * ui;
+	cfg->hs_skip = 40000;
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
+	cfg->hs_trail = max(4 * 8 * ui, 60000 + 4 * 4 * ui);
+
+	cfg->init = 100000000;
+	cfg->lpx = 60000;
+	cfg->ta_get = 5 * cfg->lpx;
+	cfg->ta_go = 4 * cfg->lpx;
+	cfg->ta_sure = 2 * cfg->lpx;
+	cfg->wakeup = 1000000000;
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
+	unsigned long long ui;
+
+	if (!cfg)
+		return -EINVAL;
+
+	ui = ALIGN(PSEC_PER_SEC, cfg->hs_clk_rate);
+	do_div(ui, cfg->hs_clk_rate);
+
+	if (cfg->clk_miss > 60000)
+		return -EINVAL;
+
+	if (cfg->clk_post < (60000 + 52 * ui))
+		return -EINVAL;
+
+	if (cfg->clk_pre < 8000)
+		return -EINVAL;
+
+	if (cfg->clk_prepare < 38000 || cfg->clk_prepare > 95000)
+		return -EINVAL;
+
+	if (cfg->clk_settle < 95000 || cfg->clk_settle > 300000)
+		return -EINVAL;
+
+	if (cfg->clk_term_en > 38000)
+		return -EINVAL;
+
+	if (cfg->clk_trail < 60000)
+		return -EINVAL;
+
+	if ((cfg->clk_prepare + cfg->clk_zero) < 300000)
+		return -EINVAL;
+
+	if (cfg->d_term_en > (35000 + 4 * ui))
+		return -EINVAL;
+
+	if (cfg->eot > (105000 + 12 * ui))
+		return -EINVAL;
+
+	if (cfg->hs_exit < 100000)
+		return -EINVAL;
+
+	if (cfg->hs_prepare < (40000 + 4 * ui) ||
+	    cfg->hs_prepare > (85000 + 6 * ui))
+		return -EINVAL;
+
+	if ((cfg->hs_prepare + cfg->hs_zero) < (145000 + 10 * ui))
+		return -EINVAL;
+
+	if ((cfg->hs_settle < (85000 + 6 * ui)) ||
+	    (cfg->hs_settle > (145000 + 10 * ui)))
+		return -EINVAL;
+
+	if (cfg->hs_skip < 40000 || cfg->hs_skip > (55000 + 4 * ui))
+		return -EINVAL;
+
+	if (cfg->hs_trail < max(8 * ui, 60000 + 4 * ui))
+		return -EINVAL;
+
+	if (cfg->init < 100000000)
+		return -EINVAL;
+
+	if (cfg->lpx < 50000)
+		return -EINVAL;
+
+	if (cfg->ta_get != (5 * cfg->lpx))
+		return -EINVAL;
+
+	if (cfg->ta_go != (4 * cfg->lpx))
+		return -EINVAL;
+
+	if (cfg->ta_sure < cfg->lpx || cfg->ta_sure > (2 * cfg->lpx))
+		return -EINVAL;
+
+	if (cfg->wakeup < 1000000000)
+		return -EINVAL;
+
+	return 0;
+}
+EXPORT_SYMBOL(phy_mipi_dphy_config_validate);
diff --git a/include/linux/phy/phy-mipi-dphy.h b/include/linux/phy/phy-mipi-dphy.h
index 29bf94db88ad..c08aacc0ac35 100644
--- a/include/linux/phy/phy-mipi-dphy.h
+++ b/include/linux/phy/phy-mipi-dphy.h
@@ -276,4 +276,10 @@ struct phy_configure_opts_mipi_dphy {
 	unsigned char		lanes;
 };
 
+int phy_mipi_dphy_get_default_config(unsigned long pixel_clock,
+				     unsigned int bpp,
+				     unsigned int lanes,
+				     struct phy_configure_opts_mipi_dphy *cfg);
+int phy_mipi_dphy_config_validate(struct phy_configure_opts_mipi_dphy *cfg);
+
 #endif /* __PHY_MIPI_DPHY_H_ */
-- 
git-series 0.9.1
