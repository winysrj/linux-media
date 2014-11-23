Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:52671 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751183AbaKWNiz (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 23 Nov 2014 08:38:55 -0500
From: Hans de Goede <hdegoede@redhat.com>
To: Emilio Lopez <emilio@elopez.com.ar>,
	Maxime Ripard <maxime.ripard@free-electrons.com>,
	Mike Turquette <mturquette@linaro.org>,
	Lee Jones <lee.jones@linaro.org>,
	Samuel Ortiz <sameo@linux.intel.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	linux-arm-kernel@lists.infradead.org,
	devicetree <devicetree@vger.kernel.org>,
	linux-sunxi@googlegroups.com, Hans de Goede <hdegoede@redhat.com>
Subject: [PATCH v2 3/9] clk: sunxi: Add prcm mod0 clock driver
Date: Sun, 23 Nov 2014 14:38:09 +0100
Message-Id: <1416749895-25013-4-git-send-email-hdegoede@redhat.com>
In-Reply-To: <1416749895-25013-1-git-send-email-hdegoede@redhat.com>
References: <1416749895-25013-1-git-send-email-hdegoede@redhat.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add a driver for mod0 clocks found in the prcm. Currently there is only
one mod0 clocks in the prcm, the ir clock.

Signed-off-by: Hans de Goede <hdegoede@redhat.com>
---
 Documentation/devicetree/bindings/clock/sunxi.txt |  1 +
 drivers/clk/sunxi/Makefile                        |  2 +-
 drivers/clk/sunxi/clk-sun6i-prcm-mod0.c           | 63 +++++++++++++++++++++++
 drivers/mfd/sun6i-prcm.c                          | 14 +++++
 4 files changed, 79 insertions(+), 1 deletion(-)
 create mode 100644 drivers/clk/sunxi/clk-sun6i-prcm-mod0.c

diff --git a/Documentation/devicetree/bindings/clock/sunxi.txt b/Documentation/devicetree/bindings/clock/sunxi.txt
index ed116df..342c75a 100644
--- a/Documentation/devicetree/bindings/clock/sunxi.txt
+++ b/Documentation/devicetree/bindings/clock/sunxi.txt
@@ -56,6 +56,7 @@ Required properties:
 	"allwinner,sun4i-a10-usb-clk" - for usb gates + resets on A10 / A20
 	"allwinner,sun5i-a13-usb-clk" - for usb gates + resets on A13
 	"allwinner,sun6i-a31-usb-clk" - for usb gates + resets on A31
+	"allwinner,sun6i-a31-ir-clk" - for the ir clock on A31
 
 Required properties for all clocks:
 - reg : shall be the control register address for the clock.
diff --git a/drivers/clk/sunxi/Makefile b/drivers/clk/sunxi/Makefile
index 7ddc2b5..daf8b1c 100644
--- a/drivers/clk/sunxi/Makefile
+++ b/drivers/clk/sunxi/Makefile
@@ -10,4 +10,4 @@ obj-y += clk-sun8i-mbus.o
 
 obj-$(CONFIG_MFD_SUN6I_PRCM) += \
 	clk-sun6i-ar100.o clk-sun6i-apb0.o clk-sun6i-apb0-gates.o \
-	clk-sun8i-apb0.o
+	clk-sun8i-apb0.o clk-sun6i-prcm-mod0.o
diff --git a/drivers/clk/sunxi/clk-sun6i-prcm-mod0.c b/drivers/clk/sunxi/clk-sun6i-prcm-mod0.c
new file mode 100644
index 0000000..e80f18e
--- /dev/null
+++ b/drivers/clk/sunxi/clk-sun6i-prcm-mod0.c
@@ -0,0 +1,63 @@
+/*
+ * Allwinner A31 PRCM mod0 clock driver
+ *
+ * Copyright (C) 2014 Hans de Goede <hdegoede@redhat.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+#include <linux/clk-provider.h>
+#include <linux/clkdev.h>
+#include <linux/module.h>
+#include <linux/of_address.h>
+#include <linux/platform_device.h>
+
+#include "clk-factors.h"
+#include "clk-mod0.h"
+
+static const struct of_device_id sun6i_a31_prcm_mod0_clk_dt_ids[] = {
+	{ .compatible = "allwinner,sun6i-a31-ir-clk" },
+	{ /* sentinel */ }
+};
+
+static DEFINE_SPINLOCK(sun6i_prcm_mod0_lock);
+
+static int sun6i_a31_prcm_mod0_clk_probe(struct platform_device *pdev)
+{
+	struct device_node *np = pdev->dev.of_node;
+	struct resource *r;
+	void __iomem *reg;
+
+	if (!np)
+		return -ENODEV;
+
+	r = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	reg = devm_ioremap_resource(&pdev->dev, r);
+	if (IS_ERR(reg))
+		return PTR_ERR(reg);
+
+	sunxi_factors_register(np, &sun4i_a10_mod0_data,
+			       &sun6i_prcm_mod0_lock, reg);
+	return 0;
+}
+
+static struct platform_driver sun6i_a31_prcm_mod0_clk_driver = {
+	.driver = {
+		.name = "sun6i-a31-prcm-mod0-clk",
+		.of_match_table = sun6i_a31_prcm_mod0_clk_dt_ids,
+	},
+	.probe = sun6i_a31_prcm_mod0_clk_probe,
+};
+module_platform_driver(sun6i_a31_prcm_mod0_clk_driver);
+
+MODULE_DESCRIPTION("Allwinner A31 PRCM mod0 clock driver");
+MODULE_AUTHOR("Hans de Goede <hdegoede@redhat.com>");
+MODULE_LICENSE("GPL");
diff --git a/drivers/mfd/sun6i-prcm.c b/drivers/mfd/sun6i-prcm.c
index 283ab8d..ff1254f 100644
--- a/drivers/mfd/sun6i-prcm.c
+++ b/drivers/mfd/sun6i-prcm.c
@@ -41,6 +41,14 @@ static const struct resource sun6i_a31_apb0_gates_clk_res[] = {
 	},
 };
 
+static const struct resource sun6i_a31_ir_clk_res[] = {
+	{
+		.start = 0x54,
+		.end = 0x57,
+		.flags = IORESOURCE_MEM,
+	},
+};
+
 static const struct resource sun6i_a31_apb0_rstc_res[] = {
 	{
 		.start = 0xb0,
@@ -69,6 +77,12 @@ static const struct mfd_cell sun6i_a31_prcm_subdevs[] = {
 		.resources = sun6i_a31_apb0_gates_clk_res,
 	},
 	{
+		.name = "sun6i-a31-ir-clk",
+		.of_compatible = "allwinner,sun6i-a31-ir-clk",
+		.num_resources = ARRAY_SIZE(sun6i_a31_ir_clk_res),
+		.resources = sun6i_a31_ir_clk_res,
+	},
+	{
 		.name = "sun6i-a31-apb0-clock-reset",
 		.of_compatible = "allwinner,sun6i-a31-clock-reset",
 		.num_resources = ARRAY_SIZE(sun6i_a31_apb0_rstc_res),
-- 
2.1.0

