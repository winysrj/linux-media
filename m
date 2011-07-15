Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:33601 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751084Ab1GOSYP (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 15 Jul 2011 14:24:15 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: linux-omap@vger.kernel.org, sakari.ailus@maxwell.research.nokia.com
Subject: [PATCH 3/3] omap3isp: Support configurable HS/VS polarities
Date: Fri, 15 Jul 2011 20:24:10 +0200
Message-Id: <1310754250-28788-4-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1310754250-28788-1-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1310754250-28788-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add two fields to the ISP parallel platform data to set the HS and VS
signals polarities.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/media/video/omap3isp/isp.h     |    6 ++++++
 drivers/media/video/omap3isp/ispccdc.c |    4 ++--
 2 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/media/video/omap3isp/isp.h b/drivers/media/video/omap3isp/isp.h
index 2620c40..529e582 100644
--- a/drivers/media/video/omap3isp/isp.h
+++ b/drivers/media/video/omap3isp/isp.h
@@ -139,6 +139,10 @@ struct isp_reg {
  *		3 - CAMEXT[13:6] -> CAM[7:0]
  * @clk_pol: Pixel clock polarity
  *		0 - Non Inverted, 1 - Inverted
+ * @hs_pol: Horizontal synchronization polarity
+ *		0 - Active high, 1 - Active low
+ * @vs_pol: Vertical synchronization polarity
+ *		0 - Active high, 1 - Active low
  * @bridge: CCDC Bridge input control
  *		ISPCTRL_PAR_BRIDGE_DISABLE - Disable
  *		ISPCTRL_PAR_BRIDGE_LENDIAN - Little endian
@@ -147,6 +151,8 @@ struct isp_reg {
 struct isp_parallel_platform_data {
 	unsigned int data_lane_shift:2;
 	unsigned int clk_pol:1;
+	unsigned int hs_pol:1;
+	unsigned int vs_pol:1;
 	unsigned int bridge:4;
 };
 
diff --git a/drivers/media/video/omap3isp/ispccdc.c b/drivers/media/video/omap3isp/ispccdc.c
index 6766247..b8cb7dd 100644
--- a/drivers/media/video/omap3isp/ispccdc.c
+++ b/drivers/media/video/omap3isp/ispccdc.c
@@ -1148,6 +1148,8 @@ static void ccdc_configure(struct isp_ccdc_device *ccdc)
 	omap3isp_configure_bridge(isp, ccdc->input, pdata, shift);
 
 	ccdc->syncif.datsz = depth_out;
+	ccdc->syncif.hdpol = pdata ? pdata->hs_pol : 0;
+	ccdc->syncif.vdpol = pdata ? pdata->vs_pol : 0;
 	ccdc_config_sync_if(ccdc, &ccdc->syncif);
 
 	/* CCDC_PAD_SINK */
@@ -2256,8 +2258,6 @@ int omap3isp_ccdc_init(struct isp_device *isp)
 	ccdc->syncif.fldout = 0;
 	ccdc->syncif.fldpol = 0;
 	ccdc->syncif.fldstat = 0;
-	ccdc->syncif.hdpol = 0;
-	ccdc->syncif.vdpol = 0;
 
 	ccdc->clamp.oblen = 0;
 	ccdc->clamp.dcsubval = 0;
-- 
1.7.3.4

