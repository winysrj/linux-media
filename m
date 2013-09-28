Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ea0-f178.google.com ([209.85.215.178]:43269 "EHLO
	mail-ea0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752977Ab3I1Tae (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 28 Sep 2013 15:30:34 -0400
From: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
To: kishon@ti.com
Cc: gregkh@linuxfoundation.org, linux-media@vger.kernel.org,
	kyungmin.park@samsung.com, linux-arm-kernel@lists.infradead.org,
	kgene.kim@samsung.com, dh09.lee@samsung.com, jg1.han@samsung.com,
	tomi.valkeinen@ti.com, plagnioj@jcrosoft.com,
	linux-fbdev@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
	Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [PATCH V5 3/5] [media] exynos4-is: Use the generic MIPI CSIS PHY driver
Date: Sat, 28 Sep 2013 21:27:45 +0200
Message-Id: <1380396467-29278-4-git-send-email-s.nawrocki@samsung.com>
In-Reply-To: <1380396467-29278-1-git-send-email-s.nawrocki@samsung.com>
References: <1380396467-29278-1-git-send-email-s.nawrocki@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Use the generic PHY API instead of the platform callback
to control the MIPI CSIS DPHY.

Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
Acked-by: Felipe Balbi <balbi@ti.com>
Acked-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
Changes since v4:
 - updated to latest version of the PHY framework - removed PHY
   labels.
---
 drivers/media/platform/exynos4-is/Kconfig     |    2 +-
 drivers/media/platform/exynos4-is/mipi-csis.c |   13 ++++++++++---
 include/linux/platform_data/mipi-csis.h       |    9 ---------
 3 files changed, 11 insertions(+), 13 deletions(-)

diff --git a/drivers/media/platform/exynos4-is/Kconfig b/drivers/media/platform/exynos4-is/Kconfig
index 53ad0f0..d2d3b4b 100644
--- a/drivers/media/platform/exynos4-is/Kconfig
+++ b/drivers/media/platform/exynos4-is/Kconfig
@@ -29,7 +29,7 @@ config VIDEO_S5P_FIMC
 config VIDEO_S5P_MIPI_CSIS
 	tristate "S5P/EXYNOS MIPI-CSI2 receiver (MIPI-CSIS) driver"
 	depends on REGULATOR
-	select S5P_SETUP_MIPIPHY
+	select GENERIC_PHY
 	help
 	  This is a V4L2 driver for Samsung S5P and EXYNOS4 SoC MIPI-CSI2
 	  receiver (MIPI-CSIS) devices.
diff --git a/drivers/media/platform/exynos4-is/mipi-csis.c b/drivers/media/platform/exynos4-is/mipi-csis.c
index 0914230..9fc2af6 100644
--- a/drivers/media/platform/exynos4-is/mipi-csis.c
+++ b/drivers/media/platform/exynos4-is/mipi-csis.c
@@ -20,6 +20,7 @@
 #include <linux/memory.h>
 #include <linux/module.h>
 #include <linux/of.h>
+#include <linux/phy/phy.h>
 #include <linux/platform_data/mipi-csis.h>
 #include <linux/platform_device.h>
 #include <linux/pm_runtime.h>
@@ -180,6 +181,7 @@ struct csis_drvdata {
  * @sd: v4l2_subdev associated with CSIS device instance
  * @index: the hardware instance index
  * @pdev: CSIS platform device
+ * @phy: pointer to the CSIS generic PHY
  * @regs: mmaped I/O registers memory
  * @supplies: CSIS regulator supplies
  * @clock: CSIS clocks
@@ -203,6 +205,7 @@ struct csis_state {
 	struct v4l2_subdev sd;
 	u8 index;
 	struct platform_device *pdev;
+	struct phy *phy;
 	void __iomem *regs;
 	struct regulator_bulk_data supplies[CSIS_NUM_SUPPLIES];
 	struct clk *clock[NUM_CSIS_CLOCKS];
@@ -779,8 +782,8 @@ static int s5pcsis_parse_dt(struct platform_device *pdev,
 					"samsung,csis-wclk");
 
 	state->num_lanes = endpoint.bus.mipi_csi2.num_data_lanes;
-
 	of_node_put(node);
+
 	return 0;
 }
 #else
@@ -829,6 +832,10 @@ static int s5pcsis_probe(struct platform_device *pdev)
 		return -EINVAL;
 	}
 
+	state->phy = devm_phy_get(dev, "csis");
+	if (IS_ERR(state->phy))
+		return PTR_ERR(state->phy);
+
 	mem_res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	state->regs = devm_ioremap_resource(dev, mem_res);
 	if (IS_ERR(state->regs))
@@ -922,7 +929,7 @@ static int s5pcsis_pm_suspend(struct device *dev, bool runtime)
 	mutex_lock(&state->lock);
 	if (state->flags & ST_POWERED) {
 		s5pcsis_stop_stream(state);
-		ret = s5p_csis_phy_enable(state->index, false);
+		ret = phy_power_off(state->phy);
 		if (ret)
 			goto unlock;
 		ret = regulator_bulk_disable(CSIS_NUM_SUPPLIES,
@@ -958,7 +965,7 @@ static int s5pcsis_pm_resume(struct device *dev, bool runtime)
 					    state->supplies);
 		if (ret)
 			goto unlock;
-		ret = s5p_csis_phy_enable(state->index, true);
+		ret = phy_power_on(state->phy);
 		if (!ret) {
 			state->flags |= ST_POWERED;
 		} else {
diff --git a/include/linux/platform_data/mipi-csis.h b/include/linux/platform_data/mipi-csis.h
index bf34e17..c2fd902 100644
--- a/include/linux/platform_data/mipi-csis.h
+++ b/include/linux/platform_data/mipi-csis.h
@@ -25,13 +25,4 @@ struct s5p_platform_mipi_csis {
 	u8 hs_settle;
 };
 
-/**
- * s5p_csis_phy_enable - global MIPI-CSI receiver D-PHY control
- * @id:     MIPI-CSIS harware instance index (0...1)
- * @on:     true to enable D-PHY and deassert its reset
- *          false to disable D-PHY
- * @return: 0 on success, or negative error code on failure
- */
-int s5p_csis_phy_enable(int id, bool on);
-
 #endif /* __PLAT_SAMSUNG_MIPI_CSIS_H_ */
-- 
1.7.4.1

