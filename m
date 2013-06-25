Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.samsung.com ([203.254.224.33]:8770 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751059Ab3FYOWl (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 25 Jun 2013 10:22:41 -0400
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
To: linux-arm-kernel@lists.infradead.org,
	linux-samsung-soc@vger.kernel.org
Cc: kishon@ti.com, linux-media@vger.kernel.org,
	kyungmin.park@samsung.com, balbi@ti.com, t.figa@samsung.com,
	devicetree-discuss@lists.ozlabs.org, kgene.kim@samsung.com,
	dh09.lee@samsung.com, jg1.han@samsung.com, inki.dae@samsung.com,
	plagnioj@jcrosoft.com, linux-fbdev@vger.kernel.org,
	Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [PATCH v2 3/5] video: exynos_mipi_dsim: Use generic PHY driver
Date: Tue, 25 Jun 2013 16:21:48 +0200
Message-id: <1372170110-12993-3-git-send-email-s.nawrocki@samsung.com>
In-reply-to: <1372170110-12993-1-git-send-email-s.nawrocki@samsung.com>
References: <1372170110-12993-1-git-send-email-s.nawrocki@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Use the generic PHY API instead of the platform callback to control
the MIPI DSIM DPHY. The 'phy_label' field is added to the platform
data structure to allow PHY lookup on non-dt platforms.

Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/video/exynos/exynos_mipi_dsi.c |   18 +++++++++---------
 include/video/exynos_mipi_dsim.h       |    6 ++++--
 2 files changed, 13 insertions(+), 11 deletions(-)

diff --git a/drivers/video/exynos/exynos_mipi_dsi.c b/drivers/video/exynos/exynos_mipi_dsi.c
index 32e5406..1f96004 100644
--- a/drivers/video/exynos/exynos_mipi_dsi.c
+++ b/drivers/video/exynos/exynos_mipi_dsi.c
@@ -156,8 +156,7 @@ static int exynos_mipi_dsi_blank_mode(struct mipi_dsim_device *dsim, int power)
 		exynos_mipi_regulator_enable(dsim);
 
 		/* enable MIPI-DSI PHY. */
-		if (dsim->pd->phy_enable)
-			dsim->pd->phy_enable(pdev, true);
+		phy_power_on(dsim->phy);
 
 		clk_enable(dsim->clock);
 
@@ -373,6 +372,10 @@ static int exynos_mipi_dsi_probe(struct platform_device *pdev)
 		return ret;
 	}
 
+	dsim->phy = devm_phy_get(&pdev->dev, dsim_pd->phy_label);
+	if (IS_ERR(dsim->phy))
+		return PTR_ERR(dsim->phy);
+
 	dsim->clock = devm_clk_get(&pdev->dev, "dsim0");
 	if (IS_ERR(dsim->clock)) {
 		dev_err(&pdev->dev, "failed to get dsim clock source\n");
@@ -439,8 +442,7 @@ static int exynos_mipi_dsi_probe(struct platform_device *pdev)
 	exynos_mipi_regulator_enable(dsim);
 
 	/* enable MIPI-DSI PHY. */
-	if (dsim->pd->phy_enable)
-		dsim->pd->phy_enable(pdev, true);
+	phy_power_on(dsim->phy);
 
 	exynos_mipi_update_cfg(dsim);
 
@@ -504,9 +506,8 @@ static int exynos_mipi_dsi_suspend(struct device *dev)
 	if (client_drv && client_drv->suspend)
 		client_drv->suspend(client_dev);
 
-	/* enable MIPI-DSI PHY. */
-	if (dsim->pd->phy_enable)
-		dsim->pd->phy_enable(pdev, false);
+	/* disable MIPI-DSI PHY. */
+	phy_power_off(dsim->phy);
 
 	clk_disable(dsim->clock);
 
@@ -536,8 +537,7 @@ static int exynos_mipi_dsi_resume(struct device *dev)
 	exynos_mipi_regulator_enable(dsim);
 
 	/* enable MIPI-DSI PHY. */
-	if (dsim->pd->phy_enable)
-		dsim->pd->phy_enable(pdev, true);
+	phy_power_on(dsim->phy);
 
 	clk_enable(dsim->clock);
 
diff --git a/include/video/exynos_mipi_dsim.h b/include/video/exynos_mipi_dsim.h
index 89dc88a..fd69beb 100644
--- a/include/video/exynos_mipi_dsim.h
+++ b/include/video/exynos_mipi_dsim.h
@@ -216,6 +216,7 @@ struct mipi_dsim_config {
  *	automatically.
  * @e_clk_src: select byte clock source.
  * @pd: pointer to MIPI-DSI driver platform data.
+ * @phy: pointer to the generic PHY
  */
 struct mipi_dsim_device {
 	struct device			*dev;
@@ -236,6 +237,7 @@ struct mipi_dsim_device {
 	bool				suspended;
 
 	struct mipi_dsim_platform_data	*pd;
+	struct phy			*phy;
 };
 
 /*
@@ -248,7 +250,7 @@ struct mipi_dsim_device {
  * @enabled: indicate whether mipi controller got enabled or not.
  * @lcd_panel_info: pointer for lcd panel specific structure.
  *	this structure specifies width, height, timing and polarity and so on.
- * @phy_enable: pointer to a callback controlling D-PHY enable/reset
+ * @phy_label: the generic PHY label
  */
 struct mipi_dsim_platform_data {
 	char				lcd_panel_name[PANEL_NAME_SIZE];
@@ -257,7 +259,7 @@ struct mipi_dsim_platform_data {
 	unsigned int			enabled;
 	void				*lcd_panel_info;
 
-	int (*phy_enable)(struct platform_device *pdev, bool on);
+	const char 			*phy_label;
 };
 
 /*
-- 
1.7.9.5

