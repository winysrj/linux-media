Return-path: <linux-media-owner@vger.kernel.org>
Received: from arroyo.ext.ti.com ([192.94.94.40]:52822 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760949Ab3JPQ2w (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 16 Oct 2013 12:28:52 -0400
From: Kishon Vijay Abraham I <kishon@ti.com>
To: <gregkh@linuxfoundation.org>
CC: <linux-media@vger.kernel.org>,
	<linux-arm-kernel@lists.infradead.org>,
	<linux-fbdev@vger.kernel.org>, <linux-samsung-soc@vger.kernel.org>,
	<kishon@ti.com>
Subject: [PATCH 3/7] video: exynos_mipi_dsim: Use the generic PHY driver
Date: Wed, 16 Oct 2013 21:58:12 +0530
Message-ID: <1381940896-9355-4-git-send-email-kishon@ti.com>
In-Reply-To: <1381940896-9355-1-git-send-email-kishon@ti.com>
References: <1381940896-9355-1-git-send-email-kishon@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>

Use the generic PHY API instead of the platform callback
for the MIPI DSIM DPHY enable/reset control.

Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
Acked-by: Felipe Balbi <balbi@ti.com>
Acked-by: Donghwa Lee <dh09.lee@samsung.com>
Acked-by: Tomi Valkeinen <tomi.valkeinen@ti.com>
Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
---
 drivers/video/exynos/Kconfig           |    1 +
 drivers/video/exynos/exynos_mipi_dsi.c |   19 ++++++++++---------
 include/video/exynos_mipi_dsim.h       |    5 ++---
 3 files changed, 13 insertions(+), 12 deletions(-)

diff --git a/drivers/video/exynos/Kconfig b/drivers/video/exynos/Kconfig
index 1b035b2..976594d 100644
--- a/drivers/video/exynos/Kconfig
+++ b/drivers/video/exynos/Kconfig
@@ -16,6 +16,7 @@ if EXYNOS_VIDEO
 config EXYNOS_MIPI_DSI
 	bool "EXYNOS MIPI DSI driver support."
 	depends on ARCH_S5PV210 || ARCH_EXYNOS
+	select GENERIC_PHY
 	help
 	  This enables support for MIPI-DSI device.
 
diff --git a/drivers/video/exynos/exynos_mipi_dsi.c b/drivers/video/exynos/exynos_mipi_dsi.c
index 32e5406..00b3a52 100644
--- a/drivers/video/exynos/exynos_mipi_dsi.c
+++ b/drivers/video/exynos/exynos_mipi_dsi.c
@@ -30,6 +30,7 @@
 #include <linux/interrupt.h>
 #include <linux/kthread.h>
 #include <linux/notifier.h>
+#include <linux/phy/phy.h>
 #include <linux/regulator/consumer.h>
 #include <linux/pm_runtime.h>
 #include <linux/err.h>
@@ -156,8 +157,7 @@ static int exynos_mipi_dsi_blank_mode(struct mipi_dsim_device *dsim, int power)
 		exynos_mipi_regulator_enable(dsim);
 
 		/* enable MIPI-DSI PHY. */
-		if (dsim->pd->phy_enable)
-			dsim->pd->phy_enable(pdev, true);
+		phy_power_on(dsim->phy);
 
 		clk_enable(dsim->clock);
 
@@ -373,6 +373,10 @@ static int exynos_mipi_dsi_probe(struct platform_device *pdev)
 		return ret;
 	}
 
+	dsim->phy = devm_phy_get(&pdev->dev, "dsim");
+	if (IS_ERR(dsim->phy))
+		return PTR_ERR(dsim->phy);
+
 	dsim->clock = devm_clk_get(&pdev->dev, "dsim0");
 	if (IS_ERR(dsim->clock)) {
 		dev_err(&pdev->dev, "failed to get dsim clock source\n");
@@ -439,8 +443,7 @@ static int exynos_mipi_dsi_probe(struct platform_device *pdev)
 	exynos_mipi_regulator_enable(dsim);
 
 	/* enable MIPI-DSI PHY. */
-	if (dsim->pd->phy_enable)
-		dsim->pd->phy_enable(pdev, true);
+	phy_power_on(dsim->phy);
 
 	exynos_mipi_update_cfg(dsim);
 
@@ -504,9 +507,8 @@ static int exynos_mipi_dsi_suspend(struct device *dev)
 	if (client_drv && client_drv->suspend)
 		client_drv->suspend(client_dev);
 
-	/* enable MIPI-DSI PHY. */
-	if (dsim->pd->phy_enable)
-		dsim->pd->phy_enable(pdev, false);
+	/* disable MIPI-DSI PHY. */
+	phy_power_off(dsim->phy);
 
 	clk_disable(dsim->clock);
 
@@ -536,8 +538,7 @@ static int exynos_mipi_dsi_resume(struct device *dev)
 	exynos_mipi_regulator_enable(dsim);
 
 	/* enable MIPI-DSI PHY. */
-	if (dsim->pd->phy_enable)
-		dsim->pd->phy_enable(pdev, true);
+	phy_power_on(dsim->phy);
 
 	clk_enable(dsim->clock);
 
diff --git a/include/video/exynos_mipi_dsim.h b/include/video/exynos_mipi_dsim.h
index 89dc88a..6a578f8 100644
--- a/include/video/exynos_mipi_dsim.h
+++ b/include/video/exynos_mipi_dsim.h
@@ -216,6 +216,7 @@ struct mipi_dsim_config {
  *	automatically.
  * @e_clk_src: select byte clock source.
  * @pd: pointer to MIPI-DSI driver platform data.
+ * @phy: pointer to the MIPI-DSI PHY
  */
 struct mipi_dsim_device {
 	struct device			*dev;
@@ -236,6 +237,7 @@ struct mipi_dsim_device {
 	bool				suspended;
 
 	struct mipi_dsim_platform_data	*pd;
+	struct phy			*phy;
 };
 
 /*
@@ -248,7 +250,6 @@ struct mipi_dsim_device {
  * @enabled: indicate whether mipi controller got enabled or not.
  * @lcd_panel_info: pointer for lcd panel specific structure.
  *	this structure specifies width, height, timing and polarity and so on.
- * @phy_enable: pointer to a callback controlling D-PHY enable/reset
  */
 struct mipi_dsim_platform_data {
 	char				lcd_panel_name[PANEL_NAME_SIZE];
@@ -256,8 +257,6 @@ struct mipi_dsim_platform_data {
 	struct mipi_dsim_config		*dsim_config;
 	unsigned int			enabled;
 	void				*lcd_panel_info;
-
-	int (*phy_enable)(struct platform_device *pdev, bool on);
 };
 
 /*
-- 
1.7.10.4

