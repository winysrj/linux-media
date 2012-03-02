Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.nokia.com ([147.243.1.48]:28025 "EHLO mgw-sa02.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932404Ab2CBRc4 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 2 Mar 2012 12:32:56 -0500
From: Sakari Ailus <sakari.ailus@iki.fi>
To: linux-media@vger.kernel.org
Cc: laurent.pinchart@ideasonboard.com, dacohen@gmail.com,
	snjw23@gmail.com, andriy.shevchenko@linux.intel.com,
	t.stanislaws@samsung.com, tuukkat76@gmail.com,
	k.debski@samsung.com, riverful@gmail.com, hverkuil@xs4all.nl,
	teturtia@gmail.com
Subject: [PATCH v4 28/34] omap3isp: Use external rate instead of vpcfg
Date: Fri,  2 Mar 2012 19:30:36 +0200
Message-Id: <1330709442-16654-28-git-send-email-sakari.ailus@iki.fi>
In-Reply-To: <20120302173219.GA15695@valkosipuli.localdomain>
References: <20120302173219.GA15695@valkosipuli.localdomain>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>

Access pipe->external_rate instead of isp_ccdc.vpcfg.pixelclk. Also remove
means to set the value for isp_ccdc_vpcfg.pixelclk.

Signed-off-by: Sakari Ailus <sakari.ailus@iki.fi>
---
 drivers/media/video/omap3isp/isp.c      |   14 --------------
 drivers/media/video/omap3isp/isp.h      |    1 -
 drivers/media/video/omap3isp/ispccdc.c  |    6 ++----
 drivers/media/video/omap3isp/ispccdc.h  |   10 ----------
 drivers/media/video/omap3isp/ispvideo.c |    2 +-
 5 files changed, 3 insertions(+), 30 deletions(-)

diff --git a/drivers/media/video/omap3isp/isp.c b/drivers/media/video/omap3isp/isp.c
index 12d5f92..f54953d 100644
--- a/drivers/media/video/omap3isp/isp.c
+++ b/drivers/media/video/omap3isp/isp.c
@@ -329,19 +329,6 @@ void omap3isp_configure_bridge(struct isp_device *isp,
 	isp_reg_writel(isp, ispctrl_val, OMAP3_ISP_IOMEM_MAIN, ISP_CTRL);
 }
 
-/**
- * isp_set_pixel_clock - Configures the ISP pixel clock
- * @isp: OMAP3 ISP device
- * @pixelclk: Average pixel clock in Hz
- *
- * Set the average pixel clock required by the sensor. The ISP will use the
- * lowest possible memory bandwidth settings compatible with the clock.
- **/
-static void isp_set_pixel_clock(struct isp_device *isp, unsigned int pixelclk)
-{
-	isp->isp_ccdc.vpcfg.pixelclk = pixelclk;
-}
-
 void omap3isp_hist_dma_done(struct isp_device *isp)
 {
 	if (omap3isp_ccdc_busy(&isp->isp_ccdc) ||
@@ -2068,7 +2055,6 @@ static int isp_probe(struct platform_device *pdev)
 
 	isp->autoidle = autoidle;
 	isp->platform_cb.set_xclk = isp_set_xclk;
-	isp->platform_cb.set_pixel_clock = isp_set_pixel_clock;
 
 	mutex_init(&isp->isp_mutex);
 	spin_lock_init(&isp->stat_lock);
diff --git a/drivers/media/video/omap3isp/isp.h b/drivers/media/video/omap3isp/isp.h
index 2e78041..964ab1b 100644
--- a/drivers/media/video/omap3isp/isp.h
+++ b/drivers/media/video/omap3isp/isp.h
@@ -129,7 +129,6 @@ struct isp_platform_callback {
 	int (*csiphy_config)(struct isp_csiphy *phy,
 			     struct isp_csiphy_dphy_cfg *dphy,
 			     struct isp_csiphy_lanes_cfg *lanes);
-	void (*set_pixel_clock)(struct isp_device *isp, unsigned int pixelclk);
 };
 
 /*
diff --git a/drivers/media/video/omap3isp/ispccdc.c b/drivers/media/video/omap3isp/ispccdc.c
index a74a797..cd1bf6d 100644
--- a/drivers/media/video/omap3isp/ispccdc.c
+++ b/drivers/media/video/omap3isp/ispccdc.c
@@ -836,8 +836,8 @@ static void ccdc_config_vp(struct isp_ccdc_device *ccdc)
 
 	if (pipe->input)
 		div = DIV_ROUND_UP(l3_ick, pipe->max_rate);
-	else if (ccdc->vpcfg.pixelclk)
-		div = l3_ick / ccdc->vpcfg.pixelclk;
+	else if (pipe->external_rate)
+		div = l3_ick / pipe->external_rate;
 
 	div = clamp(div, 2U, max_div);
 	fmtcfg_vp |= (div - 2) << ISPCCDC_FMTCFG_VPIF_FRQ_SHIFT;
@@ -2276,8 +2276,6 @@ int omap3isp_ccdc_init(struct isp_device *isp)
 	ccdc->clamp.oblen = 0;
 	ccdc->clamp.dcsubval = 0;
 
-	ccdc->vpcfg.pixelclk = 0;
-
 	ccdc->update = OMAP3ISP_CCDC_BLCLAMP;
 	ccdc_apply_controls(ccdc);
 
diff --git a/drivers/media/video/omap3isp/ispccdc.h b/drivers/media/video/omap3isp/ispccdc.h
index 6d0264b..e570abe 100644
--- a/drivers/media/video/omap3isp/ispccdc.h
+++ b/drivers/media/video/omap3isp/ispccdc.h
@@ -80,14 +80,6 @@ struct ispccdc_syncif {
 	u8 bt_r656_en;
 };
 
-/*
- * struct ispccdc_vp - Structure for Video Port parameters
- * @pixelclk: Input pixel clock in Hz
- */
-struct ispccdc_vp {
-	unsigned int pixelclk;
-};
-
 enum ispccdc_lsc_state {
 	LSC_STATE_STOPPED = 0,
 	LSC_STATE_STOPPING = 1,
@@ -161,7 +153,6 @@ struct ispccdc_lsc {
  * @update: Bitmask of controls to update during the next interrupt
  * @shadow_update: Controls update in progress by userspace
  * @syncif: Interface synchronization configuration
- * @vpcfg: Video port configuration
  * @underrun: A buffer underrun occurred and a new buffer has been queued
  * @state: Streaming state
  * @lock: Serializes shadow_update with interrupt handler
@@ -190,7 +181,6 @@ struct isp_ccdc_device {
 	unsigned int shadow_update;
 
 	struct ispccdc_syncif syncif;
-	struct ispccdc_vp vpcfg;
 
 	unsigned int underrun:1;
 	enum isp_pipeline_stream_state state;
diff --git a/drivers/media/video/omap3isp/ispvideo.c b/drivers/media/video/omap3isp/ispvideo.c
index 4ec781a..564e16d 100644
--- a/drivers/media/video/omap3isp/ispvideo.c
+++ b/drivers/media/video/omap3isp/ispvideo.c
@@ -334,7 +334,7 @@ static int isp_video_validate_pipeline(struct isp_pipeline *pipe)
 			unsigned int rate = UINT_MAX;
 
 			omap3isp_ccdc_max_rate(&isp->isp_ccdc, &rate);
-			if (isp->isp_ccdc.vpcfg.pixelclk > rate)
+			if (pipe->external_rate > rate)
 				return -ENOSPC;
 		}
 
-- 
1.7.2.5

