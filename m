Return-path: <linux-media-owner@vger.kernel.org>
Received: from arroyo.ext.ti.com ([192.94.94.40]:52823 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760988Ab3JPQ2w (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 16 Oct 2013 12:28:52 -0400
From: Kishon Vijay Abraham I <kishon@ti.com>
To: <gregkh@linuxfoundation.org>
CC: <linux-media@vger.kernel.org>,
	<linux-arm-kernel@lists.infradead.org>,
	<linux-fbdev@vger.kernel.org>, <linux-samsung-soc@vger.kernel.org>,
	<kishon@ti.com>
Subject: [PATCH 5/7] phy: Add driver for Exynos DP PHY
Date: Wed, 16 Oct 2013 21:58:14 +0530
Message-ID: <1381940896-9355-6-git-send-email-kishon@ti.com>
In-Reply-To: <1381940896-9355-1-git-send-email-kishon@ti.com>
References: <1381940896-9355-1-git-send-email-kishon@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Jingoo Han <jg1.han@samsung.com>

Add a PHY provider driver for the Samsung Exynos SoC Display Port PHY.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
Reviewed-by: Tomasz Figa <t.figa@samsung.com>
Cc: Sylwester Nawrocki <s.nawrocki@samsung.com>
Acked-by: Felipe Balbi <balbi@ti.com>
Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
---
 .../devicetree/bindings/phy/samsung-phy.txt        |    8 ++
 drivers/phy/Kconfig                                |    7 ++
 drivers/phy/Makefile                               |    1 +
 drivers/phy/phy-exynos-dp-video.c                  |  111 ++++++++++++++++++++
 4 files changed, 127 insertions(+)
 create mode 100644 drivers/phy/phy-exynos-dp-video.c

diff --git a/Documentation/devicetree/bindings/phy/samsung-phy.txt b/Documentation/devicetree/bindings/phy/samsung-phy.txt
index 5ff208c..c0fccaa 100644
--- a/Documentation/devicetree/bindings/phy/samsung-phy.txt
+++ b/Documentation/devicetree/bindings/phy/samsung-phy.txt
@@ -12,3 +12,11 @@ the PHY specifier identifies the PHY and its meaning is as follows:
   1 - MIPI DSIM 0,
   2 - MIPI CSIS 1,
   3 - MIPI DSIM 1.
+
+Samsung EXYNOS SoC series Display Port PHY
+-------------------------------------------------
+
+Required properties:
+- compatible : should be "samsung,exynos5250-dp-video-phy";
+- reg : offset and length of the Display Port PHY register set;
+- #phy-cells : from the generic PHY bindings, must be 0;
diff --git a/drivers/phy/Kconfig b/drivers/phy/Kconfig
index 0062d7e..a344f3d 100644
--- a/drivers/phy/Kconfig
+++ b/drivers/phy/Kconfig
@@ -44,4 +44,11 @@ config TWL4030_USB
 	  This transceiver supports high and full speed devices plus,
 	  in host mode, low speed.
 
+config PHY_EXYNOS_DP_VIDEO
+	tristate "EXYNOS SoC series Display Port PHY driver"
+	depends on OF
+	select GENERIC_PHY
+	help
+	  Support for Display Port PHY found on Samsung EXYNOS SoCs.
+
 endmenu
diff --git a/drivers/phy/Makefile b/drivers/phy/Makefile
index 6344053..d0caae9 100644
--- a/drivers/phy/Makefile
+++ b/drivers/phy/Makefile
@@ -3,6 +3,7 @@
 #
 
 obj-$(CONFIG_GENERIC_PHY)		+= phy-core.o
+obj-$(CONFIG_PHY_EXYNOS_DP_VIDEO)	+= phy-exynos-dp-video.o
 obj-$(CONFIG_PHY_EXYNOS_MIPI_VIDEO)	+= phy-exynos-mipi-video.o
 obj-$(CONFIG_OMAP_USB2)			+= phy-omap-usb2.o
 obj-$(CONFIG_TWL4030_USB)		+= phy-twl4030-usb.o
diff --git a/drivers/phy/phy-exynos-dp-video.c b/drivers/phy/phy-exynos-dp-video.c
new file mode 100644
index 0000000..1dbe6ce
--- /dev/null
+++ b/drivers/phy/phy-exynos-dp-video.c
@@ -0,0 +1,111 @@
+/*
+ * Samsung EXYNOS SoC series Display Port PHY driver
+ *
+ * Copyright (C) 2013 Samsung Electronics Co., Ltd.
+ * Author: Jingoo Han <jg1.han@samsung.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <linux/io.h>
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/of.h>
+#include <linux/of_address.h>
+#include <linux/phy/phy.h>
+#include <linux/platform_device.h>
+
+/* DPTX_PHY_CONTROL register */
+#define EXYNOS_DPTX_PHY_ENABLE		(1 << 0)
+
+struct exynos_dp_video_phy {
+	void __iomem *regs;
+};
+
+static int __set_phy_state(struct exynos_dp_video_phy *state, unsigned int on)
+{
+	u32 reg;
+
+	reg = readl(state->regs);
+	if (on)
+		reg |= EXYNOS_DPTX_PHY_ENABLE;
+	else
+		reg &= ~EXYNOS_DPTX_PHY_ENABLE;
+	writel(reg, state->regs);
+
+	return 0;
+}
+
+static int exynos_dp_video_phy_power_on(struct phy *phy)
+{
+	struct exynos_dp_video_phy *state = phy_get_drvdata(phy);
+
+	return __set_phy_state(state, 1);
+}
+
+static int exynos_dp_video_phy_power_off(struct phy *phy)
+{
+	struct exynos_dp_video_phy *state = phy_get_drvdata(phy);
+
+	return __set_phy_state(state, 0);
+}
+
+static struct phy_ops exynos_dp_video_phy_ops = {
+	.power_on	= exynos_dp_video_phy_power_on,
+	.power_off	= exynos_dp_video_phy_power_off,
+	.owner		= THIS_MODULE,
+};
+
+static int exynos_dp_video_phy_probe(struct platform_device *pdev)
+{
+	struct exynos_dp_video_phy *state;
+	struct device *dev = &pdev->dev;
+	struct resource *res;
+	struct phy_provider *phy_provider;
+	struct phy *phy;
+
+	state = devm_kzalloc(dev, sizeof(*state), GFP_KERNEL);
+	if (!state)
+		return -ENOMEM;
+
+	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+
+	state->regs = devm_ioremap_resource(dev, res);
+	if (IS_ERR(state->regs))
+		return PTR_ERR(state->regs);
+
+	phy_provider = devm_of_phy_provider_register(dev, of_phy_simple_xlate);
+	if (IS_ERR(phy_provider))
+		return PTR_ERR(phy_provider);
+
+	phy = devm_phy_create(dev, &exynos_dp_video_phy_ops, NULL);
+	if (IS_ERR(phy)) {
+		dev_err(dev, "failed to create Display Port PHY\n");
+		return PTR_ERR(phy);
+	}
+	phy_set_drvdata(phy, state);
+
+	return 0;
+}
+
+static const struct of_device_id exynos_dp_video_phy_of_match[] = {
+	{ .compatible = "samsung,exynos5250-dp-video-phy" },
+	{ },
+};
+MODULE_DEVICE_TABLE(of, exynos_dp_video_phy_of_match);
+
+static struct platform_driver exynos_dp_video_phy_driver = {
+	.probe	= exynos_dp_video_phy_probe,
+	.driver = {
+		.name	= "exynos-dp-video-phy",
+		.owner	= THIS_MODULE,
+		.of_match_table	= exynos_dp_video_phy_of_match,
+	}
+};
+module_platform_driver(exynos_dp_video_phy_driver);
+
+MODULE_AUTHOR("Jingoo Han <jg1.han@samsung.com>");
+MODULE_DESCRIPTION("Samsung EXYNOS SoC DP PHY driver");
+MODULE_LICENSE("GPL v2");
-- 
1.7.10.4

