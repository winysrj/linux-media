Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.samsung.com ([203.254.224.24]:40977 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753236Ab3FNRss (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 14 Jun 2013 13:48:48 -0400
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
To: kishon@ti.com
Cc: linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org,
	linux-samsung-soc@vger.kernel.org, kyungmin.park@samsung.com,
	sw0312.kim@samsung.com, devicetree-discuss@lists.ozlabs.org,
	kgene.kim@samsung.com, dh09.lee@samsung.com, jg1.han@samsung.com,
	linux-fbdev@vger.kernel.org,
	Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [RFC PATCH 4/5] exynos4-is: Use generic MIPI CSIS PHY driver
Date: Fri, 14 Jun 2013 19:45:50 +0200
Message-id: <1371231951-1969-5-git-send-email-s.nawrocki@samsung.com>
In-reply-to: <1371231951-1969-1-git-send-email-s.nawrocki@samsung.com>
References: <1371231951-1969-1-git-send-email-s.nawrocki@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Use the generic PHY API instead of the platform callback to control
the MIPI CSIS DPHY.

Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/media/platform/exynos4-is/mipi-csis.c |   11 +++++++++--
 include/linux/platform_data/mipi-csis.h       |    9 ---------
 2 files changed, 9 insertions(+), 11 deletions(-)

diff --git a/drivers/media/platform/exynos4-is/mipi-csis.c b/drivers/media/platform/exynos4-is/mipi-csis.c
index 0fe80e3..88d0d61 100644
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
@@ -184,6 +185,7 @@ struct csis_drvdata {
  * @sd: v4l2_subdev associated with CSIS device instance
  * @index: the hardware instance index
  * @pdev: CSIS platform device
+ * @phy: pointer to the CSIS generic PHY
  * @regs: mmaped I/O registers memory
  * @supplies: CSIS regulator supplies
  * @clock: CSIS clocks
@@ -207,6 +209,7 @@ struct csis_state {
 	struct v4l2_subdev sd;
 	u8 index;
 	struct platform_device *pdev;
+	struct phy *phy;
 	void __iomem *regs;
 	struct regulator_bulk_data supplies[CSIS_NUM_SUPPLIES];
 	struct clk *clock[NUM_CSIS_CLOCKS];
@@ -861,6 +864,10 @@ static int s5pcsis_probe(struct platform_device *pdev)
 		return -EINVAL;
 	}
 
+	state->phy = devm_phy_get(dev, "csis");
+	if (IS_ERR(state->phy))
+		return PTR_ERR(state->phy);
+
 	mem_res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	state->regs = devm_ioremap_resource(dev, mem_res);
 	if (IS_ERR(state->regs))
@@ -946,7 +953,7 @@ static int s5pcsis_pm_suspend(struct device *dev, bool runtime)
 	mutex_lock(&state->lock);
 	if (state->flags & ST_POWERED) {
 		s5pcsis_stop_stream(state);
-		ret = s5p_csis_phy_enable(state->index, false);
+		ret = phy_power_off(state->phy);
 		if (ret)
 			goto unlock;
 		ret = regulator_bulk_disable(CSIS_NUM_SUPPLIES,
@@ -982,7 +989,7 @@ static int s5pcsis_pm_resume(struct device *dev, bool runtime)
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
1.7.9.5

