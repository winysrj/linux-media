Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.samsung.com ([203.254.224.34]:61811 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751262Ab3F1Nox (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 28 Jun 2013 09:44:53 -0400
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
Subject: [PATCH v4 4/5] [media] exynos4-is: Use the generic MIPI CSIS PHY driver
Date: Fri, 28 Jun 2013 15:43:10 +0200
Message-id: <1372426991-2482-5-git-send-email-s.nawrocki@samsung.com>
In-reply-to: <1372426991-2482-1-git-send-email-s.nawrocki@samsung.com>
References: <1372426991-2482-1-git-send-email-s.nawrocki@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Use the generic PHY API instead of the platform callback to control
the MIPI CSIS DPHY. The 'phy_label' field is added to the platform
data structure to allow PHY lookup on non-dt platforms

Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
Acked-by: Felipe Balbi <balbi@ti.com>
Acked-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/media/platform/exynos4-is/mipi-csis.c |   16 +++++++++++++---
 include/linux/platform_data/mipi-csis.h       |   11 ++---------
 2 files changed, 15 insertions(+), 12 deletions(-)

diff --git a/drivers/media/platform/exynos4-is/mipi-csis.c b/drivers/media/platform/exynos4-is/mipi-csis.c
index a2eda9d..8436254 100644
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
@@ -167,6 +168,7 @@ struct csis_pktbuf {
  * @sd: v4l2_subdev associated with CSIS device instance
  * @index: the hardware instance index
  * @pdev: CSIS platform device
+ * @phy: pointer to the CSIS generic PHY
  * @regs: mmaped I/O registers memory
  * @supplies: CSIS regulator supplies
  * @clock: CSIS clocks
@@ -189,6 +191,8 @@ struct csis_state {
 	struct v4l2_subdev sd;
 	u8 index;
 	struct platform_device *pdev;
+	struct phy *phy;
+	const char *phy_label;
 	void __iomem *regs;
 	struct regulator_bulk_data supplies[CSIS_NUM_SUPPLIES];
 	struct clk *clock[NUM_CSIS_CLOCKS];
@@ -726,6 +730,7 @@ static int s5pcsis_get_platform_data(struct platform_device *pdev,
 	state->index = max(0, pdev->id);
 	state->max_num_lanes = state->index ? CSIS1_MAX_LANES :
 					      CSIS0_MAX_LANES;
+	state->phy_label = pdata->phy_label;
 	return 0;
 }
 
@@ -763,8 +768,9 @@ static int s5pcsis_parse_dt(struct platform_device *pdev,
 					"samsung,csis-wclk");
 
 	state->num_lanes = endpoint.bus.mipi_csi2.num_data_lanes;
-
 	of_node_put(node);
+
+	state->phy_label = "csis";
 	return 0;
 }
 #else
@@ -800,6 +806,10 @@ static int s5pcsis_probe(struct platform_device *pdev)
 		return -EINVAL;
 	}
 
+	state->phy = devm_phy_get(dev, state->phy_label);
+	if (IS_ERR(state->phy))
+		return PTR_ERR(state->phy);
+
 	mem_res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	state->regs = devm_ioremap_resource(dev, mem_res);
 	if (IS_ERR(state->regs))
@@ -893,7 +903,7 @@ static int s5pcsis_pm_suspend(struct device *dev, bool runtime)
 	mutex_lock(&state->lock);
 	if (state->flags & ST_POWERED) {
 		s5pcsis_stop_stream(state);
-		ret = s5p_csis_phy_enable(state->index, false);
+		ret = phy_power_off(state->phy);
 		if (ret)
 			goto unlock;
 		ret = regulator_bulk_disable(CSIS_NUM_SUPPLIES,
@@ -929,7 +939,7 @@ static int s5pcsis_pm_resume(struct device *dev, bool runtime)
 					    state->supplies);
 		if (ret)
 			goto unlock;
-		ret = s5p_csis_phy_enable(state->index, true);
+		ret = phy_power_on(state->phy);
 		if (!ret) {
 			state->flags |= ST_POWERED;
 		} else {
diff --git a/include/linux/platform_data/mipi-csis.h b/include/linux/platform_data/mipi-csis.h
index bf34e17..9214317 100644
--- a/include/linux/platform_data/mipi-csis.h
+++ b/include/linux/platform_data/mipi-csis.h
@@ -17,21 +17,14 @@
  * @wclk_source: CSI wrapper clock selection: 0 - bus clock, 1 - ext. SCLK_CAM
  * @lanes:       number of data lanes used
  * @hs_settle:   HS-RX settle time
+ * @phy_label:	 the generic PHY label
  */
 struct s5p_platform_mipi_csis {
 	unsigned long clk_rate;
 	u8 wclk_source;
 	u8 lanes;
 	u8 hs_settle;
+	const char *phy_label;
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

