Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.samsung.com ([203.254.224.34]:62500 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753209Ab3CZRaa (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 26 Mar 2013 13:30:30 -0400
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
To: linux-media@vger.kernel.org
Cc: kyungmin.park@samsung.com, myungjoo.ham@samsung.com,
	dh09.lee@samsung.com, shaik.samsung@gmail.com, arun.kk@samsung.com,
	a.hajda@samsung.com, linux-samsung-soc@vger.kernel.org,
	Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [PATCH v2 06/10] s5p-fimc: Ensure CAMCLK clock can be enabled by
 FIMC-LITE devices
Date: Tue, 26 Mar 2013 18:29:48 +0100
Message-id: <1364318992-20562-7-git-send-email-s.nawrocki@samsung.com>
In-reply-to: <1364318992-20562-1-git-send-email-s.nawrocki@samsung.com>
References: <1364318992-20562-1-git-send-email-s.nawrocki@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

In configurations where FIMC-LITE is used to capture image signal
from an external sensor only we need to ensure one of FIMC devices
is in active power state and the "fimc" gate clock is enabled.
Otherwise the CAMCLK clock output signal will be masked off
preventing an external sensor's operation.
This affect processing pipelines like:

 - sensor -> FIMC-LITE -> memory
 - sensor -> MIPI-CSIS -> FIMC-LITE -> memory

Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/media/platform/s5p-fimc/fimc-mdevice.c |   18 ++++++++++--------
 drivers/media/platform/s5p-fimc/fimc-mdevice.h |    2 ++
 2 files changed, 12 insertions(+), 8 deletions(-)

diff --git a/drivers/media/platform/s5p-fimc/fimc-mdevice.c b/drivers/media/platform/s5p-fimc/fimc-mdevice.c
index 5b11e39..d519ee7 100644
--- a/drivers/media/platform/s5p-fimc/fimc-mdevice.c
+++ b/drivers/media/platform/s5p-fimc/fimc-mdevice.c
@@ -507,7 +507,6 @@ static int fimc_md_register_sensor_entities(struct fimc_md *fmd)
 {
 	struct s5p_platform_fimc *pdata = fmd->pdev->dev.platform_data;
 	struct device_node *of_node = fmd->pdev->dev.of_node;
-	struct fimc_dev *fd = NULL;
 	int num_clients = 0;
 	int ret, i;
 
@@ -515,13 +514,10 @@ static int fimc_md_register_sensor_entities(struct fimc_md *fmd)
 	 * Runtime resume one of the FIMC entities to make sure
 	 * the sclk_cam clocks are not globally disabled.
 	 */
-	for (i = 0; !fd && i < ARRAY_SIZE(fmd->fimc); i++)
-		if (fmd->fimc[i])
-			fd = fmd->fimc[i];
-	if (!fd)
+	if (!fmd->pmf)
 		return -ENXIO;
 
-	ret = pm_runtime_get_sync(&fd->pdev->dev);
+	ret = pm_runtime_get_sync(fmd->pmf);
 	if (ret < 0)
 		return ret;
 
@@ -555,7 +551,7 @@ static int fimc_md_register_sensor_entities(struct fimc_md *fmd)
 		}
 	}
 
-	pm_runtime_put(&fd->pdev->dev);
+	pm_runtime_put(fmd->pmf);
 	return ret;
 }
 
@@ -600,6 +596,8 @@ static int register_fimc_entity(struct fimc_md *fmd, struct fimc_dev *fimc)
 
 	ret = v4l2_device_register_subdev(&fmd->v4l2_dev, sd);
 	if (!ret) {
+		if (!fmd->pmf && fimc->pdev)
+			fmd->pmf = &fimc->pdev->dev;
 		fmd->fimc[fimc->id] = fimc;
 		fimc->vid_cap.user_subdev_api = fmd->user_subdev_api;
 	} else {
@@ -1083,7 +1081,7 @@ static int __fimc_md_set_camclk(struct fimc_md *fmd,
 	struct fimc_camclk_info *camclk;
 	int ret = 0;
 
-	if (WARN_ON(pdata->clk_id >= FIMC_MAX_CAMCLKS) || fmd == NULL)
+	if (WARN_ON(pdata->clk_id >= FIMC_MAX_CAMCLKS) || !fmd || !fmd->pmf)
 		return -EINVAL;
 
 	camclk = &fmd->camclk[pdata->clk_id];
@@ -1099,6 +1097,9 @@ static int __fimc_md_set_camclk(struct fimc_md *fmd,
 		if (camclk->use_count++ == 0) {
 			clk_set_rate(camclk->clock, pdata->clk_frequency);
 			camclk->frequency = pdata->clk_frequency;
+			ret = pm_runtime_get_sync(fmd->pmf);
+			if (ret < 0)
+				return ret;
 			ret = clk_enable(camclk->clock);
 			dbg("Enabled camclk %d: f: %lu", pdata->clk_id,
 			    clk_get_rate(camclk->clock));
@@ -1111,6 +1112,7 @@ static int __fimc_md_set_camclk(struct fimc_md *fmd,
 
 	if (--camclk->use_count == 0) {
 		clk_disable(camclk->clock);
+		pm_runtime_put(fmd->pmf);
 		dbg("Disabled camclk %d", pdata->clk_id);
 	}
 	return ret;
diff --git a/drivers/media/platform/s5p-fimc/fimc-mdevice.h b/drivers/media/platform/s5p-fimc/fimc-mdevice.h
index 46f3b82..1d5cea5 100644
--- a/drivers/media/platform/s5p-fimc/fimc-mdevice.h
+++ b/drivers/media/platform/s5p-fimc/fimc-mdevice.h
@@ -81,6 +81,7 @@ struct fimc_sensor_info {
  * @camclk: external sensor clock information
  * @fimc: array of registered fimc devices
  * @use_isp: set to true when FIMC-IS subsystem is used
+ * @pmf: handle to the CAMCLK clock control FIMC helper device
  * @media_dev: top level media device
  * @v4l2_dev: top level v4l2_device holding up the subdevs
  * @pdev: platform device this media device is hooked up into
@@ -99,6 +100,7 @@ struct fimc_md {
 	struct fimc_lite *fimc_lite[FIMC_LITE_MAX_DEVS];
 	struct fimc_dev *fimc[FIMC_MAX_DEVS];
 	bool use_isp;
+	struct device *pmf;
 	struct media_device media_dev;
 	struct v4l2_device v4l2_dev;
 	struct platform_device *pdev;
-- 
1.7.9.5

