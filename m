Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:37290 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932095Ab2FZNpm (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 26 Jun 2012 09:45:42 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: sakari.ailus@iki.fi, Enrico <ebutera@users.berlios.de>,
	Jean-Philippe Francois <jp.francois@cynove.com>,
	Abhishek Reddy Kondaveeti <areddykondaveeti@aptina.com>,
	Gary Thomas <gary@mlbassoc.com>,
	Javier Martinez Canillas <martinez.javier@gmail.com>
Subject: [PATCH 4/6] omap3isp: ccdc: Remove support for interlaced data and master HS/VS mode
Date: Tue, 26 Jun 2012 15:45:37 +0200
Message-Id: <1340718339-29915-5-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1340718339-29915-1-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1340718339-29915-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Those features are half-implemented and not used. Remove them.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/media/video/omap3isp/ispccdc.c |   51 +------------------------------
 drivers/media/video/omap3isp/ispccdc.h |   18 -----------
 2 files changed, 2 insertions(+), 67 deletions(-)

diff --git a/drivers/media/video/omap3isp/ispccdc.c b/drivers/media/video/omap3isp/ispccdc.c
index e4231ef..bdd7d72 100644
--- a/drivers/media/video/omap3isp/ispccdc.c
+++ b/drivers/media/video/omap3isp/ispccdc.c
@@ -967,17 +967,8 @@ static void ccdc_config_sync_if(struct isp_ccdc_device *ccdc,
 				struct ispccdc_syncif *syncif)
 {
 	struct isp_device *isp = to_isp_device(ccdc);
-	u32 syn_mode = isp_reg_readl(isp, OMAP3_ISP_IOMEM_CCDC,
-				     ISPCCDC_SYN_MODE);
+	u32 syn_mode = ISPCCDC_SYN_MODE_VDHDEN;
 
-	syn_mode |= ISPCCDC_SYN_MODE_VDHDEN;
-
-	if (syncif->fldstat)
-		syn_mode |= ISPCCDC_SYN_MODE_FLDSTAT;
-	else
-		syn_mode &= ~ISPCCDC_SYN_MODE_FLDSTAT;
-
-	syn_mode &= ~ISPCCDC_SYN_MODE_DATSIZ_MASK;
 	switch (syncif->datsz) {
 	case 8:
 		syn_mode |= ISPCCDC_SYN_MODE_DATSIZ_8;
@@ -993,47 +984,14 @@ static void ccdc_config_sync_if(struct isp_ccdc_device *ccdc,
 		break;
 	}
 
-	if (syncif->fldmode)
-		syn_mode |= ISPCCDC_SYN_MODE_FLDMODE;
-	else
-		syn_mode &= ~ISPCCDC_SYN_MODE_FLDMODE;
-
 	if (syncif->datapol)
 		syn_mode |= ISPCCDC_SYN_MODE_DATAPOL;
-	else
-		syn_mode &= ~ISPCCDC_SYN_MODE_DATAPOL;
-
-	if (syncif->fldpol)
-		syn_mode |= ISPCCDC_SYN_MODE_FLDPOL;
-	else
-		syn_mode &= ~ISPCCDC_SYN_MODE_FLDPOL;
 
 	if (syncif->hdpol)
 		syn_mode |= ISPCCDC_SYN_MODE_HDPOL;
-	else
-		syn_mode &= ~ISPCCDC_SYN_MODE_HDPOL;
 
 	if (syncif->vdpol)
 		syn_mode |= ISPCCDC_SYN_MODE_VDPOL;
-	else
-		syn_mode &= ~ISPCCDC_SYN_MODE_VDPOL;
-
-	if (syncif->ccdc_mastermode) {
-		syn_mode |= ISPCCDC_SYN_MODE_FLDOUT | ISPCCDC_SYN_MODE_VDHDOUT;
-		isp_reg_writel(isp,
-			       syncif->hs_width << ISPCCDC_HD_VD_WID_HDW_SHIFT
-			     | syncif->vs_width << ISPCCDC_HD_VD_WID_VDW_SHIFT,
-			       OMAP3_ISP_IOMEM_CCDC,
-			       ISPCCDC_HD_VD_WID);
-
-		isp_reg_writel(isp,
-			       syncif->ppln << ISPCCDC_PIX_LINES_PPLN_SHIFT
-			     | syncif->hlprf << ISPCCDC_PIX_LINES_HLPRF_SHIFT,
-			       OMAP3_ISP_IOMEM_CCDC,
-			       ISPCCDC_PIX_LINES);
-	} else
-		syn_mode &= ~(ISPCCDC_SYN_MODE_FLDOUT |
-			      ISPCCDC_SYN_MODE_VDHDOUT);
 
 	isp_reg_writel(isp, syn_mode, OMAP3_ISP_IOMEM_CCDC, ISPCCDC_SYN_MODE);
 
@@ -1154,6 +1112,7 @@ static void ccdc_configure(struct isp_ccdc_device *ccdc)
 	omap3isp_configure_bridge(isp, ccdc->input, pdata, shift);
 
 	ccdc->syncif.datsz = depth_out;
+	ccdc->syncif.datapol = 0;
 	ccdc->syncif.hdpol = pdata ? pdata->hs_pol : 0;
 	ccdc->syncif.vdpol = pdata ? pdata->vs_pol : 0;
 	ccdc_config_sync_if(ccdc, &ccdc->syncif);
@@ -2487,13 +2446,7 @@ int omap3isp_ccdc_init(struct isp_device *isp)
 	INIT_LIST_HEAD(&ccdc->lsc.free_queue);
 	spin_lock_init(&ccdc->lsc.req_lock);
 
-	ccdc->syncif.ccdc_mastermode = 0;
-	ccdc->syncif.datapol = 0;
 	ccdc->syncif.datsz = 0;
-	ccdc->syncif.fldmode = 0;
-	ccdc->syncif.fldout = 0;
-	ccdc->syncif.fldpol = 0;
-	ccdc->syncif.fldstat = 0;
 
 	ccdc->clamp.oblen = 0;
 	ccdc->clamp.dcsubval = 0;
diff --git a/drivers/media/video/omap3isp/ispccdc.h b/drivers/media/video/omap3isp/ispccdc.h
index 890f6b3..57007d7 100644
--- a/drivers/media/video/omap3isp/ispccdc.h
+++ b/drivers/media/video/omap3isp/ispccdc.h
@@ -48,35 +48,17 @@ enum ccdc_input_entity {
 
 /*
  * struct ispccdc_syncif - Structure for Sync Interface between sensor and CCDC
- * @ccdc_mastermode: Master mode. 1 - Master, 0 - Slave.
- * @fldstat: Field state. 0 - Odd Field, 1 - Even Field.
  * @datsz: Data size.
- * @fldmode: 0 - Progressive, 1 - Interlaced.
  * @datapol: 0 - Positive, 1 - Negative.
- * @fldpol: 0 - Positive, 1 - Negative.
  * @hdpol: 0 - Positive, 1 - Negative.
  * @vdpol: 0 - Positive, 1 - Negative.
- * @fldout: 0 - Input, 1 - Output.
- * @hs_width: Width of the Horizontal Sync pulse, used for HS/VS Output.
- * @vs_width: Width of the Vertical Sync pulse, used for HS/VS Output.
- * @ppln: Number of pixels per line, used for HS/VS Output.
- * @hlprf: Number of half lines per frame, used for HS/VS Output.
  * @bt_r656_en: 1 - Enable ITU-R BT656 mode, 0 - Sync mode.
  */
 struct ispccdc_syncif {
-	u8 ccdc_mastermode;
-	u8 fldstat;
 	u8 datsz;
-	u8 fldmode;
 	u8 datapol;
-	u8 fldpol;
 	u8 hdpol;
 	u8 vdpol;
-	u8 fldout;
-	u8 hs_width;
-	u8 vs_width;
-	u8 ppln;
-	u8 hlprf;
 	u8 bt_r656_en;
 };
 
-- 
1.7.3.4

