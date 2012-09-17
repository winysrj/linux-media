Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.samsung.com ([203.254.224.24]:42517 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754914Ab2IQKyq (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 17 Sep 2012 06:54:46 -0400
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
To: linux-media@vger.kernel.org
Cc: kyungmin.park@samsung.com, sw0312.kim@samsung.com,
	linux-samsung-soc@vger.kernel.org,
	Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [PATCH 4/7] s5p-csis: Replace phy_enable platform data callback with
 direct call
Date: Mon, 17 Sep 2012 12:54:30 +0200
Message-id: <1347879273-30463-1-git-send-email-s.nawrocki@samsung.com>
In-reply-to: <1347878888-30001-1-git-send-email-s.nawrocki@samsung.com>
References: <1347878888-30001-1-git-send-email-s.nawrocki@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The phy_enable callback is common for all Samsung SoC platforms,
replace it with direct function call so the MIPI-CSI2 DPHY control
is also possible on device tree instantiated platforms.

Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/media/video/s5p-fimc/mipi-csis.c | 13 +++++++------
 include/linux/platform_data/mipi-csis.h  | 11 +++++------
 2 files changed, 12 insertions(+), 12 deletions(-)

diff --git a/drivers/media/video/s5p-fimc/mipi-csis.c b/drivers/media/video/s5p-fimc/mipi-csis.c
index c9afb05..1a2db5d 100644
--- a/drivers/media/video/s5p-fimc/mipi-csis.c
+++ b/drivers/media/video/s5p-fimc/mipi-csis.c
@@ -150,6 +150,7 @@ static const struct s5pcsis_event s5pcsis_events[] = {
  *        protecting @format and @flags members
  * @pads: CSIS pads array
  * @sd: v4l2_subdev associated with CSIS device instance
+ * @index: the hardware instance index
  * @pdev: CSIS platform device
  * @regs: mmaped I/O registers memory
  * @supplies: CSIS regulator supplies
@@ -165,6 +166,7 @@ struct csis_state {
 	struct mutex lock;
 	struct media_pad pads[CSIS_PADS_NUM];
 	struct v4l2_subdev sd;
+	u8 index;
 	struct platform_device *pdev;
 	void __iomem *regs;
 	struct regulator_bulk_data supplies[CSIS_NUM_SUPPLIES];
@@ -619,14 +621,15 @@ static int __devinit s5pcsis_probe(struct platform_device *pdev)
 	spin_lock_init(&state->slock);

 	state->pdev = pdev;
+	state->index = max(0, pdev->id);

 	pdata = pdev->dev.platform_data;
-	if (pdata == NULL || pdata->phy_enable == NULL) {
+	if (pdata == NULL) {
 		dev_err(&pdev->dev, "Platform data not fully specified\n");
 		return -EINVAL;
 	}

-	if ((pdev->id == 1 && pdata->lanes > CSIS1_MAX_LANES) ||
+	if ((state->index == 1 && pdata->lanes > CSIS1_MAX_LANES) ||
 	    pdata->lanes > CSIS0_MAX_LANES) {
 		dev_err(&pdev->dev, "Unsupported number of data lanes: %d\n",
 			pdata->lanes);
@@ -709,7 +712,6 @@ e_clkput:

 static int s5pcsis_pm_suspend(struct device *dev, bool runtime)
 {
-	struct s5p_platform_mipi_csis *pdata = dev->platform_data;
 	struct platform_device *pdev = to_platform_device(dev);
 	struct v4l2_subdev *sd = platform_get_drvdata(pdev);
 	struct csis_state *state = sd_to_csis_state(sd);
@@ -721,7 +723,7 @@ static int s5pcsis_pm_suspend(struct device *dev, bool runtime)
 	mutex_lock(&state->lock);
 	if (state->flags & ST_POWERED) {
 		s5pcsis_stop_stream(state);
-		ret = pdata->phy_enable(state->pdev, false);
+		ret = s5p_csis_phy_enable(state->index, false);
 		if (ret)
 			goto unlock;
 		ret = regulator_bulk_disable(CSIS_NUM_SUPPLIES,
@@ -740,7 +742,6 @@ static int s5pcsis_pm_suspend(struct device *dev, bool runtime)

 static int s5pcsis_pm_resume(struct device *dev, bool runtime)
 {
-	struct s5p_platform_mipi_csis *pdata = dev->platform_data;
 	struct platform_device *pdev = to_platform_device(dev);
 	struct v4l2_subdev *sd = platform_get_drvdata(pdev);
 	struct csis_state *state = sd_to_csis_state(sd);
@@ -758,7 +759,7 @@ static int s5pcsis_pm_resume(struct device *dev, bool runtime)
 					    state->supplies);
 		if (ret)
 			goto unlock;
-		ret = pdata->phy_enable(state->pdev, true);
+		ret = s5p_csis_phy_enable(state->index, true);
 		if (!ret) {
 			state->flags |= ST_POWERED;
 		} else {
diff --git a/include/linux/platform_data/mipi-csis.h b/include/linux/platform_data/mipi-csis.h
index c45b1e8..2e59e43 100644
--- a/include/linux/platform_data/mipi-csis.h
+++ b/include/linux/platform_data/mipi-csis.h
@@ -11,8 +11,6 @@
 #ifndef __PLAT_SAMSUNG_MIPI_CSIS_H_
 #define __PLAT_SAMSUNG_MIPI_CSIS_H_ __FILE__

-struct platform_device;
-
 /**
  * struct s5p_platform_mipi_csis - platform data for S5P MIPI-CSIS driver
  * @clk_rate: bus clock frequency
@@ -34,10 +32,11 @@ struct s5p_platform_mipi_csis {

 /**
  * s5p_csis_phy_enable - global MIPI-CSI receiver D-PHY control
- * @pdev: MIPI-CSIS platform device
- * @on: true to enable D-PHY and deassert its reset
- *	false to disable D-PHY
+ * @id:     MIPI-CSIS harware instance index (0...1)
+ * @on:     true to enable D-PHY and deassert its reset
+ *          false to disable D-PHY
+ * @return: 0 on success, or negative error code on failure
  */
-int s5p_csis_phy_enable(struct platform_device *pdev, bool on);
+int s5p_csis_phy_enable(int id, bool on);

 #endif /* __PLAT_SAMSUNG_MIPI_CSIS_H_ */
--
1.7.11.3

