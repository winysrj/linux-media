Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:41000 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751416AbaLQRTI (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 17 Dec 2014 12:19:08 -0500
From: Hans de Goede <hdegoede@redhat.com>
To: Linus Walleij <linus.walleij@linaro.org>,
	Maxime Ripard <maxime.ripard@free-electrons.com>,
	Lee Jones <lee.jones@linaro.org>,
	Samuel Ortiz <sameo@linux.intel.com>
Cc: Mike Turquette <mturquette@linaro.org>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	linux-arm-kernel@lists.infradead.org,
	devicetree <devicetree@vger.kernel.org>,
	linux-sunxi@googlegroups.com, Hans de Goede <hdegoede@redhat.com>
Subject: [PATCH v2 06/13] clk: sunxi: Make the mod0 clk driver also a platform driver
Date: Wed, 17 Dec 2014 18:18:17 +0100
Message-Id: <1418836704-15689-7-git-send-email-hdegoede@redhat.com>
In-Reply-To: <1418836704-15689-1-git-send-email-hdegoede@redhat.com>
References: <1418836704-15689-1-git-send-email-hdegoede@redhat.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

With the prcm in sun6i (and some later SoCs) some mod0 clocks are instantiated
through the mfd framework, and as such do not work with of_clk_declare, since
they do not have registers assigned to them yet at of_clk_declare init time.

Silence the error on not finding registers in the of_clk_declare mod0 clk
setup method, and also register mod0-clk support as a platform driver to work
properly with mfd instantiated mod0 clocks.

Signed-off-by: Hans de Goede <hdegoede@redhat.com>
---
 drivers/clk/sunxi/clk-mod0.c | 41 ++++++++++++++++++++++++++++++++++++-----
 1 file changed, 36 insertions(+), 5 deletions(-)

diff --git a/drivers/clk/sunxi/clk-mod0.c b/drivers/clk/sunxi/clk-mod0.c
index 658d74f..7ddab6f 100644
--- a/drivers/clk/sunxi/clk-mod0.c
+++ b/drivers/clk/sunxi/clk-mod0.c
@@ -17,6 +17,7 @@
 #include <linux/clk-provider.h>
 #include <linux/clkdev.h>
 #include <linux/of_address.h>
+#include <linux/platform_device.h>
 
 #include "clk-factors.h"
 
@@ -67,7 +68,7 @@ static struct clk_factors_config sun4i_a10_mod0_config = {
 	.pwidth = 2,
 };
 
-static const struct factors_data sun4i_a10_mod0_data __initconst = {
+static const struct factors_data sun4i_a10_mod0_data = {
 	.enable = 31,
 	.mux = 24,
 	.muxmask = BIT(1) | BIT(0),
@@ -82,17 +83,47 @@ static void __init sun4i_a10_mod0_setup(struct device_node *node)
 	void __iomem *reg;
 
 	reg = of_iomap(node, 0);
-	if (!reg) {
-		pr_err("Could not get registers for mod0-clk: %s\n",
-		       node->name);
+	if (!reg)
 		return;
-	}
 
 	sunxi_factors_register(node, &sun4i_a10_mod0_data,
 			       &sun4i_a10_mod0_lock, reg);
 }
 CLK_OF_DECLARE(sun4i_a10_mod0, "allwinner,sun4i-a10-mod0-clk", sun4i_a10_mod0_setup);
 
+static int sun4i_a10_mod0_clk_probe(struct platform_device *pdev)
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
+			       &sun4i_a10_mod0_lock, reg);
+	return 0;
+}
+
+static const struct of_device_id sun4i_a10_mod0_clk_dt_ids[] = {
+	{ .compatible = "allwinner,sun4i-a10-mod0-clk" },
+	{ /* sentinel */ }
+};
+
+static struct platform_driver sun4i_a10_mod0_clk_driver = {
+	.driver = {
+		.name = "sun4i-a10-mod0-clk",
+		.of_match_table = sun4i_a10_mod0_clk_dt_ids,
+	},
+	.probe = sun4i_a10_mod0_clk_probe,
+};
+module_platform_driver(sun4i_a10_mod0_clk_driver);
+
 static DEFINE_SPINLOCK(sun5i_a13_mbus_lock);
 
 static void __init sun5i_a13_mbus_setup(struct device_node *node)
-- 
2.1.0

