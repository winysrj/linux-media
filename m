Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:47217 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756389Ab3AHNmY (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 8 Jan 2013 08:42:24 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org, linux-omap@vger.kernel.org
Cc: Sakari Ailus <sakari.ailus@iki.fi>,
	Mike Turquette <mturquette@linaro.org>
Subject: [PATCH 2/2] omap3isp: Set cam_mclk rate directly
Date: Tue,  8 Jan 2013 14:43:54 +0100
Message-Id: <1357652634-17668-3-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1357652634-17668-1-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1357652634-17668-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Now that the cam_mclk rate changes are back-propagated to dpll4_m5_ck we
can set the cam_mclk rate directly instead of manually setting the rate
of the parent clock.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/media/platform/omap3isp/isp.c |   18 ++----------------
 drivers/media/platform/omap3isp/isp.h |    8 +++-----
 2 files changed, 5 insertions(+), 21 deletions(-)

diff --git a/drivers/media/platform/omap3isp/isp.c b/drivers/media/platform/omap3isp/isp.c
index 07eea5b..63a583f 100644
--- a/drivers/media/platform/omap3isp/isp.c
+++ b/drivers/media/platform/omap3isp/isp.c
@@ -1338,28 +1338,15 @@ static int isp_enable_clocks(struct isp_device *isp)
 {
 	int r;
 	unsigned long rate;
-	int divisor;
-
-	/*
-	 * cam_mclk clock chain:
-	 *   dpll4 -> dpll4_m5 -> dpll4_m5x2 -> cam_mclk
-	 *
-	 * In OMAP3630 dpll4_m5x2 != 2 x dpll4_m5 but both are
-	 * set to the same value. Hence the rate set for dpll4_m5
-	 * has to be twice of what is set on OMAP3430 to get
-	 * the required value for cam_mclk
-	 */
-	divisor = isp->revision == ISP_REVISION_15_0 ? 1 : 2;
 
 	r = clk_prepare_enable(isp->clock[ISP_CLK_CAM_ICK]);
 	if (r) {
 		dev_err(isp->dev, "failed to enable cam_ick clock\n");
 		goto out_clk_enable_ick;
 	}
-	r = clk_set_rate(isp->clock[ISP_CLK_DPLL4_M5_CK],
-			 CM_CAM_MCLK_HZ/divisor);
+	r = clk_set_rate(isp->clock[ISP_CLK_CAM_MCLK], CM_CAM_MCLK_HZ);
 	if (r) {
-		dev_err(isp->dev, "clk_set_rate for dpll4_m5_ck failed\n");
+		dev_err(isp->dev, "clk_set_rate for cam_mclk failed\n");
 		goto out_clk_enable_mclk;
 	}
 	r = clk_prepare_enable(isp->clock[ISP_CLK_CAM_MCLK]);
@@ -1401,7 +1388,6 @@ static void isp_disable_clocks(struct isp_device *isp)
 static const char *isp_clocks[] = {
 	"cam_ick",
 	"cam_mclk",
-	"dpll4_m5_ck",
 	"csi2_96m_fck",
 	"l3_ick",
 };
diff --git a/drivers/media/platform/omap3isp/isp.h b/drivers/media/platform/omap3isp/isp.h
index 517d348..c77e1f2 100644
--- a/drivers/media/platform/omap3isp/isp.h
+++ b/drivers/media/platform/omap3isp/isp.h
@@ -147,7 +147,6 @@ struct isp_platform_callback {
  * @ref_count: Reference count for handling multiple ISP requests.
  * @cam_ick: Pointer to camera interface clock structure.
  * @cam_mclk: Pointer to camera functional clock structure.
- * @dpll4_m5_ck: Pointer to DPLL4 M5 clock structure.
  * @csi2_fck: Pointer to camera CSI2 complexIO clock structure.
  * @l3_ick: Pointer to OMAP3 L3 bus interface clock.
  * @irq: Currently attached ISP ISR callbacks information structure.
@@ -189,10 +188,9 @@ struct isp_device {
 	u32 xclk_divisor[2];	/* Two clocks, a and b. */
 #define ISP_CLK_CAM_ICK		0
 #define ISP_CLK_CAM_MCLK	1
-#define ISP_CLK_DPLL4_M5_CK	2
-#define ISP_CLK_CSI2_FCK	3
-#define ISP_CLK_L3_ICK		4
-	struct clk *clock[5];
+#define ISP_CLK_CSI2_FCK	2
+#define ISP_CLK_L3_ICK		3
+	struct clk *clock[4];
 
 	/* ISP modules */
 	struct ispstat isp_af;
-- 
1.7.8.6

