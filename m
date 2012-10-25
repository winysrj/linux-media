Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:33319 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751387Ab2JYVi4 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 25 Oct 2012 17:38:56 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: sakari.ailus@iki.fi
Subject: [PATCH 1/2] omap3isp: Prepare/unprepare clocks before/after enable/disable
Date: Thu, 25 Oct 2012 23:39:42 +0200
Message-Id: <1351201183-21036-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Clock enable (disable) is split in two operations, prepare and enable
(disable and unprepare). Perform both when enabling/disabling the ISP
clocks.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/media/platform/omap3isp/isp.c |   25 +++++++++++++------------
 1 files changed, 13 insertions(+), 12 deletions(-)

diff --git a/drivers/media/platform/omap3isp/isp.c b/drivers/media/platform/omap3isp/isp.c
index e8e724e..7da622e 100644
--- a/drivers/media/platform/omap3isp/isp.c
+++ b/drivers/media/platform/omap3isp/isp.c
@@ -1332,7 +1332,8 @@ void omap3isp_subclk_disable(struct isp_device *isp,
  * isp_enable_clocks - Enable ISP clocks
  * @isp: OMAP3 ISP device
  *
- * Return 0 if successful, or clk_enable return value if any of tthem fails.
+ * Return 0 if successful, or clk_prepare_enable return value if any of them
+ * fails.
  */
 static int isp_enable_clocks(struct isp_device *isp)
 {
@@ -1354,9 +1355,9 @@ static int isp_enable_clocks(struct isp_device *isp)
 	else
 		divisor = 2;
 
-	r = clk_enable(isp->clock[ISP_CLK_CAM_ICK]);
+	r = clk_prepare_enable(isp->clock[ISP_CLK_CAM_ICK]);
 	if (r) {
-		dev_err(isp->dev, "clk_enable cam_ick failed\n");
+		dev_err(isp->dev, "failed to enable cam_ick clock\n");
 		goto out_clk_enable_ick;
 	}
 	r = clk_set_rate(isp->clock[ISP_CLK_DPLL4_M5_CK],
@@ -1365,9 +1366,9 @@ static int isp_enable_clocks(struct isp_device *isp)
 		dev_err(isp->dev, "clk_set_rate for dpll4_m5_ck failed\n");
 		goto out_clk_enable_mclk;
 	}
-	r = clk_enable(isp->clock[ISP_CLK_CAM_MCLK]);
+	r = clk_prepare_enable(isp->clock[ISP_CLK_CAM_MCLK]);
 	if (r) {
-		dev_err(isp->dev, "clk_enable cam_mclk failed\n");
+		dev_err(isp->dev, "failed to enable cam_mclk clock\n");
 		goto out_clk_enable_mclk;
 	}
 	rate = clk_get_rate(isp->clock[ISP_CLK_CAM_MCLK]);
@@ -1375,17 +1376,17 @@ static int isp_enable_clocks(struct isp_device *isp)
 		dev_warn(isp->dev, "unexpected cam_mclk rate:\n"
 				   " expected : %d\n"
 				   " actual   : %ld\n", CM_CAM_MCLK_HZ, rate);
-	r = clk_enable(isp->clock[ISP_CLK_CSI2_FCK]);
+	r = clk_prepare_enable(isp->clock[ISP_CLK_CSI2_FCK]);
 	if (r) {
-		dev_err(isp->dev, "clk_enable csi2_fck failed\n");
+		dev_err(isp->dev, "failed to enable csi2_fck clock\n");
 		goto out_clk_enable_csi2_fclk;
 	}
 	return 0;
 
 out_clk_enable_csi2_fclk:
-	clk_disable(isp->clock[ISP_CLK_CAM_MCLK]);
+	clk_disable_unprepare(isp->clock[ISP_CLK_CAM_MCLK]);
 out_clk_enable_mclk:
-	clk_disable(isp->clock[ISP_CLK_CAM_ICK]);
+	clk_disable_unprepare(isp->clock[ISP_CLK_CAM_ICK]);
 out_clk_enable_ick:
 	return r;
 }
@@ -1396,9 +1397,9 @@ out_clk_enable_ick:
  */
 static void isp_disable_clocks(struct isp_device *isp)
 {
-	clk_disable(isp->clock[ISP_CLK_CAM_ICK]);
-	clk_disable(isp->clock[ISP_CLK_CAM_MCLK]);
-	clk_disable(isp->clock[ISP_CLK_CSI2_FCK]);
+	clk_disable_unprepare(isp->clock[ISP_CLK_CAM_ICK]);
+	clk_disable_unprepare(isp->clock[ISP_CLK_CAM_MCLK]);
+	clk_disable_unprepare(isp->clock[ISP_CLK_CSI2_FCK]);
 }
 
 static const char *isp_clocks[] = {
-- 
1.7.8.6

