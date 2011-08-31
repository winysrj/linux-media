Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:36501 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755787Ab1HaPOX (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 31 Aug 2011 11:14:23 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: sakari.ailus@iki.fi, gary@mlbassoc.com
Subject: [HACK 2/3] omap3isp: ccdc: Remove ispccdc_syncif structure
Date: Wed, 31 Aug 2011 17:14:47 +0200
Message-Id: <1314803688-29566-3-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1314803688-29566-1-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1314803688-29566-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The structure is only used to store configuration data and pass it to
CCDC configuration functions. Access the data directly from the
locations that needs it.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/media/video/omap3isp/ispccdc.c |   38 ++++++++++++++-----------------
 drivers/media/video/omap3isp/ispccdc.h |   18 ---------------
 include/media/omap3isp.h               |    3 ++
 3 files changed, 20 insertions(+), 39 deletions(-)

diff --git a/drivers/media/video/omap3isp/ispccdc.c b/drivers/media/video/omap3isp/ispccdc.c
index 8865741..9efb703 100644
--- a/drivers/media/video/omap3isp/ispccdc.c
+++ b/drivers/media/video/omap3isp/ispccdc.c
@@ -623,9 +623,12 @@ static void ccdc_configure_lpf(struct isp_ccdc_device *ccdc)
 static void ccdc_configure_alaw(struct isp_ccdc_device *ccdc)
 {
 	struct isp_device *isp = to_isp_device(ccdc);
+	const struct isp_format_info *info;
 	u32 alaw = 0;
 
-	switch (ccdc->syncif.datsz) {
+	info = omap3isp_video_format_info(ccdc->formats[CCDC_PAD_SINK].code);
+
+	switch (info->bpp) {
 	case 8:
 		return;
 
@@ -808,6 +811,7 @@ static void ccdc_config_vp(struct isp_ccdc_device *ccdc)
 {
 	struct isp_pipeline *pipe = to_isp_pipeline(&ccdc->subdev.entity);
 	struct isp_device *isp = to_isp_device(ccdc);
+	const struct isp_format_info *info;
 	unsigned long l3_ick = pipe->l3_ick;
 	unsigned int max_div = isp->revision == ISP_REVISION_15_0 ? 64 : 8;
 	unsigned int div = 0;
@@ -816,7 +820,9 @@ static void ccdc_config_vp(struct isp_ccdc_device *ccdc)
 	fmtcfg_vp = isp_reg_readl(isp, OMAP3_ISP_IOMEM_CCDC, ISPCCDC_FMTCFG)
 		  & ~(ISPCCDC_FMTCFG_VPIN_MASK | ISPCCDC_FMTCFG_VPIF_FRQ_MASK);
 
-	switch (ccdc->syncif.datsz) {
+	info = omap3isp_video_format_info(ccdc->formats[CCDC_PAD_SINK].code);
+
+	switch (info->bpp) {
 	case 8:
 	case 10:
 		fmtcfg_vp |= ISPCCDC_FMTCFG_VPIN_9_0;
@@ -954,12 +960,12 @@ void omap3isp_ccdc_max_rate(struct isp_ccdc_device *ccdc,
 /*
  * ccdc_config_sync_if - Set CCDC sync interface configuration
  * @ccdc: Pointer to ISP CCDC device.
- * @syncif: Structure containing the sync parameters like field state, CCDC in
- *          master/slave mode, raw/yuv data, polarity of data, field, hs, vs
- *          signals.
+ * @pdata: Parallel interface platform data (may be NULL)
+ * @data_size: Data size
  */
 static void ccdc_config_sync_if(struct isp_ccdc_device *ccdc,
-				struct ispccdc_syncif *syncif)
+				struct isp_parallel_platform_data *pdata,
+				unsigned int data_size)
 {
 	struct isp_device *isp = to_isp_device(ccdc);
 	u32 syn_mode = isp_reg_readl(isp, OMAP3_ISP_IOMEM_CCDC,
@@ -971,7 +977,7 @@ static void ccdc_config_sync_if(struct isp_ccdc_device *ccdc,
 	syn_mode |= ISPCCDC_SYN_MODE_VDHDEN;
 
 	syn_mode &= ~ISPCCDC_SYN_MODE_DATSIZ_MASK;
-	switch (syncif->datsz) {
+	switch (data_size) {
 	case 8:
 		syn_mode |= ISPCCDC_SYN_MODE_DATSIZ_8;
 		break;
@@ -986,26 +992,22 @@ static void ccdc_config_sync_if(struct isp_ccdc_device *ccdc,
 		break;
 	};
 
-	if (syncif->datapol)
+	if (pdata && pdata->data_pol)
 		syn_mode |= ISPCCDC_SYN_MODE_DATAPOL;
 	else
 		syn_mode &= ~ISPCCDC_SYN_MODE_DATAPOL;
 
-	if (syncif->hdpol)
+	if (pdata && pdata->hs_pol)
 		syn_mode |= ISPCCDC_SYN_MODE_HDPOL;
 	else
 		syn_mode &= ~ISPCCDC_SYN_MODE_HDPOL;
 
-	if (syncif->vdpol)
+	if (pdata && pdata->vs_pol)
 		syn_mode |= ISPCCDC_SYN_MODE_VDPOL;
 	else
 		syn_mode &= ~ISPCCDC_SYN_MODE_VDPOL;
 
 	isp_reg_writel(isp, syn_mode, OMAP3_ISP_IOMEM_CCDC, ISPCCDC_SYN_MODE);
-
-	if (!syncif->bt_r656_en)
-		isp_reg_clr(isp, OMAP3_ISP_IOMEM_CCDC, ISPCCDC_REC656IF,
-			    ISPCCDC_REC656IF_R656ON);
 }
 
 /* CCDC formats descriptions */
@@ -1118,11 +1120,7 @@ static void ccdc_configure(struct isp_ccdc_device *ccdc)
 	shift = depth_in - depth_out;
 	omap3isp_configure_bridge(isp, ccdc->input, pdata, shift);
 
-	ccdc->syncif.datsz = depth_out;
-	ccdc->syncif.datapol = 0;
-	ccdc->syncif.hdpol = pdata ? pdata->hs_pol : 0;
-	ccdc->syncif.vdpol = pdata ? pdata->vs_pol : 0;
-	ccdc_config_sync_if(ccdc, &ccdc->syncif);
+	ccdc_config_sync_if(ccdc, pdata, depth_out);
 
 	/* CCDC_PAD_SINK */
 	format = &ccdc->formats[CCDC_PAD_SINK];
@@ -2230,8 +2228,6 @@ int omap3isp_ccdc_init(struct isp_device *isp)
 	INIT_LIST_HEAD(&ccdc->lsc.free_queue);
 	spin_lock_init(&ccdc->lsc.req_lock);
 
-	ccdc->syncif.datsz = 0;
-
 	ccdc->clamp.oblen = 0;
 	ccdc->clamp.dcsubval = 0;
 
diff --git a/drivers/media/video/omap3isp/ispccdc.h b/drivers/media/video/omap3isp/ispccdc.h
index 0e98f10..54811ce 100644
--- a/drivers/media/video/omap3isp/ispccdc.h
+++ b/drivers/media/video/omap3isp/ispccdc.h
@@ -47,22 +47,6 @@ enum ccdc_input_entity {
 #define	OMAP3ISP_CCDC_NEVENTS	16
 
 /*
- * struct ispccdc_syncif - Structure for Sync Interface between sensor and CCDC
- * @datsz: Data size.
- * @datapol: 0 - Positive, 1 - Negative.
- * @hdpol: 0 - Positive, 1 - Negative.
- * @vdpol: 0 - Positive, 1 - Negative.
- * @bt_r656_en: 1 - Enable ITU-R BT656 mode, 0 - Sync mode.
- */
-struct ispccdc_syncif {
-	u8 datsz;
-	u8 datapol;
-	u8 hdpol;
-	u8 vdpol;
-	u8 bt_r656_en;
-};
-
-/*
  * struct ispccdc_vp - Structure for Video Port parameters
  * @pixelclk: Input pixel clock in Hz
  */
@@ -143,7 +127,6 @@ struct ispccdc_lsc {
  * @lsc: Lens shading compensation configuration
  * @update: Bitmask of controls to update during the next interrupt
  * @shadow_update: Controls update in progress by userspace
- * @syncif: Interface synchronization configuration
  * @vpcfg: Video port configuration
  * @underrun: A buffer underrun occurred and a new buffer has been queued
  * @state: Streaming state
@@ -173,7 +156,6 @@ struct isp_ccdc_device {
 	unsigned int update;
 	unsigned int shadow_update;
 
-	struct ispccdc_syncif syncif;
 	struct ispccdc_vp vpcfg;
 
 	unsigned int underrun:1;
diff --git a/include/media/omap3isp.h b/include/media/omap3isp.h
index e917b1d..5291665 100644
--- a/include/media/omap3isp.h
+++ b/include/media/omap3isp.h
@@ -63,6 +63,8 @@ enum {
  *		0 - Active high, 1 - Active low
  * @vs_pol: Vertical synchronization polarity
  *		0 - Active high, 1 - Active low
+ * @data_pol: Data polarity
+ *		0 - Normal, 1 - One's complement
  * @bridge: CCDC Bridge input control
  *		ISP_BRIDGE_DISABLE - Disable
  *		ISP_BRIDGE_LITTLE_ENDIAN - Little endian
@@ -73,6 +75,7 @@ struct isp_parallel_platform_data {
 	unsigned int clk_pol:1;
 	unsigned int hs_pol:1;
 	unsigned int vs_pol:1;
+	unsigned int data_pol:1;
 	unsigned int bridge:2;
 };
 
-- 
1.7.3.4

