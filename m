Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.samsung.com ([203.254.224.33]:49885 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751262Ab3F1Noj (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 28 Jun 2013 09:44:39 -0400
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
To: linux-arm-kernel@lists.infradead.org,
	linux-samsung-soc@vger.kernel.org
Cc: kishon@ti.com, linux-media@vger.kernel.org,
	kyungmin.park@samsung.com, balbi@ti.com, t.figa@samsung.com,
	devicetree-discuss@lists.ozlabs.org, kgene.kim@samsung.com,
	dh09.lee@samsung.com, jg1.han@samsung.com, inki.dae@samsung.com,
	tomi.valkeinen@ti.com, plagnioj@jcrosoft.com,
	jason77.wang@gmail.com, linux-fbdev@vger.kernel.org,
	Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [PATCH v4 2/5] phy: Add driver for Exynos MIPI CSIS/DSIM DPHYs
Date: Fri, 28 Jun 2013 15:43:08 +0200
Message-id: <1372426991-2482-3-git-send-email-s.nawrocki@samsung.com>
In-reply-to: <1372426991-2482-1-git-send-email-s.nawrocki@samsung.com>
References: <1372426991-2482-1-git-send-email-s.nawrocki@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add a PHY provider driver for the Samsung S5P/Exynos SoC MIPI CSI-2
receiver and MIPI DSI transmitter DPHYs.

Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
Acked-by: Felipe Balbi <balbi@ti.com>
---
Changes since v3:
 - replaced spin_(un)lock_irq_{save,restore} with spin_{lock,unlock}.
 - DT binding file renamed to samsung-phy.txt, so it can be used for
   other PHYs as well,
 - removed <linux/delay.h> inclusion,
 - added missing spin_lock_init().
---
 .../devicetree/bindings/phy/samsung-phy.txt        |   14 ++
 drivers/phy/Kconfig                                |    9 ++
 drivers/phy/Makefile                               |    3 +-
 drivers/phy/phy-exynos-mipi-video.c                |  169 ++++++++++++++++++++
 4 files changed, 194 insertions(+), 1 deletion(-)
 create mode 100644 Documentation/devicetree/bindings/phy/samsung-phy.txt
 create mode 100644 drivers/phy/phy-exynos-mipi-video.c

diff --git a/Documentation/devicetree/bindings/phy/samsung-phy.txt b/Documentation/devicetree/bindings/phy/samsung-phy.txt
new file mode 100644
index 0000000..5ff208c
--- /dev/null
+++ b/Documentation/devicetree/bindings/phy/samsung-phy.txt
@@ -0,0 +1,14 @@
+Samsung S5P/EXYNOS SoC series MIPI CSIS/DSIM DPHY
+-------------------------------------------------
+
+Required properties:
+- compatible : should be "samsung,s5pv210-mipi-video-phy";
+- reg : offset and length of the MIPI DPHY register set;
+- #phy-cells : from the generic phy bindings, must be 1;
+
+For "samsung,s5pv210-mipi-video-phy" compatible PHYs the second cell in
+the PHY specifier identifies the PHY and its meaning is as follows:
+  0 - MIPI CSIS 0,
+  1 - MIPI DSIM 0,
+  2 - MIPI CSIS 1,
+  3 - MIPI DSIM 1.
diff --git a/drivers/phy/Kconfig b/drivers/phy/Kconfig
index 5f85909..6f446d0 100644
--- a/drivers/phy/Kconfig
+++ b/drivers/phy/Kconfig
@@ -11,3 +11,12 @@ menuconfig GENERIC_PHY
 	  devices present in the kernel. This layer will have the generic
 	  API by which phy drivers can create PHY using the phy framework and
 	  phy users can obtain reference to the PHY.
+
+if GENERIC_PHY
+
+config PHY_EXYNOS_MIPI_VIDEO
+	tristate "S5P/EXYNOS SoC series MIPI CSI-2/DSI PHY driver"
+	help
+	  Support for MIPI CSI-2 and MIPI DSI DPHY found on Samsung
+	  S5P and EXYNOS SoCs.
+endif
diff --git a/drivers/phy/Makefile b/drivers/phy/Makefile
index 9e9560f..71d8841 100644
--- a/drivers/phy/Makefile
+++ b/drivers/phy/Makefile
@@ -2,4 +2,5 @@
 # Makefile for the phy drivers.
 #
 
-obj-$(CONFIG_GENERIC_PHY)	+= phy-core.o
+obj-$(CONFIG_GENERIC_PHY)		+= phy-core.o
+obj-$(CONFIG_PHY_EXYNOS_MIPI_VIDEO)	+= phy-exynos-mipi-video.o
diff --git a/drivers/phy/phy-exynos-mipi-video.c b/drivers/phy/phy-exynos-mipi-video.c
new file mode 100644
index 0000000..7e7fcd7
--- /dev/null
+++ b/drivers/phy/phy-exynos-mipi-video.c
@@ -0,0 +1,169 @@
+/*
+ * Samsung S5P/EXYNOS SoC series MIPI CSIS/DSIM DPHY driver
+ *
+ * Copyright (C) 2013 Samsung Electronics Co., Ltd.
+ * Author: Sylwester Nawrocki <s.nawrocki@samsung.com>
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
+#include <linux/spinlock.h>
+
+/* MIPI_PHYn_CONTROL register offset: n = 0..1 */
+#define EXYNOS_MIPI_PHY_CONTROL(n)	((n) * 4)
+#define EXYNOS_MIPI_PHY_ENABLE		(1 << 0)
+#define EXYNOS_MIPI_PHY_SRESETN		(1 << 1)
+#define EXYNOS_MIPI_PHY_MRESETN		(1 << 2)
+#define EXYNOS_MIPI_PHY_RESET_MASK	(3 << 1)
+
+enum exynos_mipi_phy_id {
+	EXYNOS_MIPI_PHY_ID_CSIS0,
+	EXYNOS_MIPI_PHY_ID_DSIM0,
+	EXYNOS_MIPI_PHY_ID_CSIS1,
+	EXYNOS_MIPI_PHY_ID_DSIM1,
+	EXYNOS_MIPI_PHYS_NUM
+};
+
+#define IS_EXYNOS_MIPI_DSIM_PHY_ID(id) \
+	((id) == EXYNOS_MIPI_PHY_ID_DSIM0 || (id) == EXYNOS_MIPI_PHY_ID_DSIM0)
+
+struct exynos_mipi_video_phy {
+	spinlock_t slock;
+	struct phy *phys[EXYNOS_MIPI_PHYS_NUM];
+	void __iomem *regs;
+};
+
+static int __set_phy_state(struct exynos_mipi_video_phy *state,
+			enum exynos_mipi_phy_id id, unsigned int on)
+{
+	void __iomem *addr;
+	u32 reg, reset;
+
+	addr = state->regs + EXYNOS_MIPI_PHY_CONTROL(id / 2);
+
+	if (IS_EXYNOS_MIPI_DSIM_PHY_ID(id))
+		reset = EXYNOS_MIPI_PHY_MRESETN;
+	else
+		reset = EXYNOS_MIPI_PHY_SRESETN;
+
+	spin_lock(&state->slock);
+	reg = readl(addr);
+	if (on)
+		reg |= reset;
+	else
+		reg &= ~reset;
+	writel(reg, addr);
+
+	/* Clear ENABLE bit only if MRESETN, SRESETN bits are not set. */
+	if (on)
+		reg |= EXYNOS_MIPI_PHY_ENABLE;
+	else if (!(reg & EXYNOS_MIPI_PHY_RESET_MASK))
+		reg &= ~EXYNOS_MIPI_PHY_ENABLE;
+
+	writel(reg, addr);
+	spin_unlock(&state->slock);
+	return 0;
+}
+
+static int exynos_mipi_video_phy_power_on(struct phy *phy)
+{
+	struct exynos_mipi_video_phy *state = phy_get_drvdata(phy);
+	return __set_phy_state(state, phy->id, 1);
+}
+
+static int exynos_mipi_video_phy_power_off(struct phy *phy)
+{
+	struct exynos_mipi_video_phy *state = phy_get_drvdata(phy);
+	return __set_phy_state(state, phy->id, 0);
+}
+
+static struct phy *exynos_mipi_video_phy_xlate(struct device *dev,
+					struct of_phandle_args *args)
+{
+	struct exynos_mipi_video_phy *state = dev_get_drvdata(dev);
+
+	if (WARN_ON(args->args[0] > EXYNOS_MIPI_PHYS_NUM))
+		return ERR_PTR(-ENODEV);
+
+	return state->phys[args->args[0]];
+}
+
+static struct phy_ops exynos_mipi_video_phy_ops = {
+	.power_on	= exynos_mipi_video_phy_power_on,
+	.power_off	= exynos_mipi_video_phy_power_off,
+	.owner		= THIS_MODULE,
+};
+
+static int exynos_mipi_video_phy_probe(struct platform_device *pdev)
+{
+	struct exynos_mipi_video_phy *state;
+	struct device *dev = &pdev->dev;
+	struct resource *res;
+	struct phy_provider *phy_provider;
+	int i;
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
+	dev_set_drvdata(dev, state);
+	spin_lock_init(&state->slock);
+
+	phy_provider = devm_of_phy_provider_register(dev,
+					exynos_mipi_video_phy_xlate);
+	if (IS_ERR(phy_provider))
+		return PTR_ERR(phy_provider);
+
+	for (i = 0; i < EXYNOS_MIPI_PHYS_NUM; i++) {
+		char label[8];
+
+		snprintf(label, sizeof(label), "%s.%d",
+				IS_EXYNOS_MIPI_DSIM_PHY_ID(i) ?
+				"dsim" : "csis", i / 2);
+
+		state->phys[i] = devm_phy_create(dev, i,
+				&exynos_mipi_video_phy_ops, label);
+		if (IS_ERR(state->phys[i])) {
+			dev_err(dev, "failed to create PHY %s\n", label);
+			return PTR_ERR(state->phys[i]);
+		}
+		phy_set_drvdata(state->phys[i], state);
+	}
+
+	return 0;
+}
+
+static const struct of_device_id exynos_mipi_video_phy_of_match[] = {
+	{ .compatible = "samsung,s5pv210-mipi-video-phy" },
+	{ },
+};
+MODULE_DEVICE_TABLE(of, exynos_mipi_video_phy_of_match);
+
+static struct platform_driver exynos_mipi_video_phy_driver = {
+	.probe	= exynos_mipi_video_phy_probe,
+	.driver = {
+		.of_match_table	= exynos_mipi_video_phy_of_match,
+		.name  = "exynos-mipi-video-phy",
+		.owner = THIS_MODULE,
+	}
+};
+module_platform_driver(exynos_mipi_video_phy_driver);
+
+MODULE_DESCRIPTION("Samsung S5P/EXYNOS SoC MIPI CSI-2/DSI PHY driver");
+MODULE_LICENSE("GPL v2");
+MODULE_AUTHOR("Sylwester Nawrocki <s.nawrocki@samsung.com>");
-- 
1.7.9.5

