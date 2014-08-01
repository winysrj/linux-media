Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:59955 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753396AbaHANzr (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 1 Aug 2014 09:55:47 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: Sakari Ailus <sakari.ailus@iki.fi>,
	Enric Balletbo Serra <eballetbo@gmail.com>
Subject: [PATCH 1/8] omap3isp: ccdc: Disable the video port when unused
Date: Fri,  1 Aug 2014 15:46:27 +0200
Message-Id: <1406900794-9871-2-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1406900794-9871-1-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1406900794-9871-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The video port doesn't support YUV formats. Disable it when the CCDC
sink pad format is set to YUV instead of leaving it enabled and relying
on downstream modules not to process data they receive from the video
port.

Experiments showed that this fixes some of the CCDC failures to stop,
especially in BT.656 mode.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/media/platform/omap3isp/ispccdc.c | 70 +++++++++++++------------------
 1 file changed, 29 insertions(+), 41 deletions(-)

diff --git a/drivers/media/platform/omap3isp/ispccdc.c b/drivers/media/platform/omap3isp/ispccdc.c
index 150bbf0..ecc37f2 100644
--- a/drivers/media/platform/omap3isp/ispccdc.c
+++ b/drivers/media/platform/omap3isp/ispccdc.c
@@ -808,29 +808,48 @@ static void ccdc_config_vp(struct isp_ccdc_device *ccdc)
 	struct isp_pipeline *pipe = to_isp_pipeline(&ccdc->subdev.entity);
 	struct isp_device *isp = to_isp_device(ccdc);
 	const struct isp_format_info *info;
+	struct v4l2_mbus_framefmt *format;
 	unsigned long l3_ick = pipe->l3_ick;
 	unsigned int max_div = isp->revision == ISP_REVISION_15_0 ? 64 : 8;
 	unsigned int div = 0;
-	u32 fmtcfg_vp;
+	u32 fmtcfg = ISPCCDC_FMTCFG_VPEN;
+
+	format = &ccdc->formats[CCDC_PAD_SOURCE_VP];
+
+	if (!format->code) {
+		/* Disable the video port when the input format isn't supported.
+		 * This is indicated by a pixel code set to 0.
+		 */
+		isp_reg_writel(isp, 0, OMAP3_ISP_IOMEM_CCDC, ISPCCDC_FMTCFG);
+		return;
+	}
+
+	isp_reg_writel(isp, (0 << ISPCCDC_FMT_HORZ_FMTSPH_SHIFT) |
+		       (format->width << ISPCCDC_FMT_HORZ_FMTLNH_SHIFT),
+		       OMAP3_ISP_IOMEM_CCDC, ISPCCDC_FMT_HORZ);
+	isp_reg_writel(isp, (0 << ISPCCDC_FMT_VERT_FMTSLV_SHIFT) |
+		       ((format->height + 1) << ISPCCDC_FMT_VERT_FMTLNV_SHIFT),
+		       OMAP3_ISP_IOMEM_CCDC, ISPCCDC_FMT_VERT);
 
-	fmtcfg_vp = isp_reg_readl(isp, OMAP3_ISP_IOMEM_CCDC, ISPCCDC_FMTCFG)
-		  & ~(ISPCCDC_FMTCFG_VPIN_MASK | ISPCCDC_FMTCFG_VPIF_FRQ_MASK);
+	isp_reg_writel(isp, (format->width << ISPCCDC_VP_OUT_HORZ_NUM_SHIFT) |
+		       (format->height << ISPCCDC_VP_OUT_VERT_NUM_SHIFT),
+		       OMAP3_ISP_IOMEM_CCDC, ISPCCDC_VP_OUT);
 
 	info = omap3isp_video_format_info(ccdc->formats[CCDC_PAD_SINK].code);
 
 	switch (info->width) {
 	case 8:
 	case 10:
-		fmtcfg_vp |= ISPCCDC_FMTCFG_VPIN_9_0;
+		fmtcfg |= ISPCCDC_FMTCFG_VPIN_9_0;
 		break;
 	case 11:
-		fmtcfg_vp |= ISPCCDC_FMTCFG_VPIN_10_1;
+		fmtcfg |= ISPCCDC_FMTCFG_VPIN_10_1;
 		break;
 	case 12:
-		fmtcfg_vp |= ISPCCDC_FMTCFG_VPIN_11_2;
+		fmtcfg |= ISPCCDC_FMTCFG_VPIN_11_2;
 		break;
 	case 13:
-		fmtcfg_vp |= ISPCCDC_FMTCFG_VPIN_12_3;
+		fmtcfg |= ISPCCDC_FMTCFG_VPIN_12_3;
 		break;
 	}
 
@@ -840,24 +859,9 @@ static void ccdc_config_vp(struct isp_ccdc_device *ccdc)
 		div = l3_ick / pipe->external_rate;
 
 	div = clamp(div, 2U, max_div);
-	fmtcfg_vp |= (div - 2) << ISPCCDC_FMTCFG_VPIF_FRQ_SHIFT;
+	fmtcfg |= (div - 2) << ISPCCDC_FMTCFG_VPIF_FRQ_SHIFT;
 
-	isp_reg_writel(isp, fmtcfg_vp, OMAP3_ISP_IOMEM_CCDC, ISPCCDC_FMTCFG);
-}
-
-/*
- * ccdc_enable_vp - Enable Video Port.
- * @ccdc: Pointer to ISP CCDC device.
- * @enable: 0 Disables VP, 1 Enables VP
- *
- * This is needed for outputting image to Preview, H3A and HIST ISP submodules.
- */
-static void ccdc_enable_vp(struct isp_ccdc_device *ccdc, u8 enable)
-{
-	struct isp_device *isp = to_isp_device(ccdc);
-
-	isp_reg_clr_set(isp, OMAP3_ISP_IOMEM_CCDC, ISPCCDC_FMTCFG,
-			ISPCCDC_FMTCFG_VPEN, enable ? ISPCCDC_FMTCFG_VPEN : 0);
+	isp_reg_writel(isp, fmtcfg, OMAP3_ISP_IOMEM_CCDC, ISPCCDC_FMTCFG);
 }
 
 /*
@@ -1282,18 +1286,7 @@ static void ccdc_configure(struct isp_ccdc_device *ccdc)
 	isp_reg_writel(isp, syn_mode, OMAP3_ISP_IOMEM_CCDC, ISPCCDC_SYN_MODE);
 
 	/* CCDC_PAD_SOURCE_VP */
-	format = &ccdc->formats[CCDC_PAD_SOURCE_VP];
-
-	isp_reg_writel(isp, (0 << ISPCCDC_FMT_HORZ_FMTSPH_SHIFT) |
-		       (format->width << ISPCCDC_FMT_HORZ_FMTLNH_SHIFT),
-		       OMAP3_ISP_IOMEM_CCDC, ISPCCDC_FMT_HORZ);
-	isp_reg_writel(isp, (0 << ISPCCDC_FMT_VERT_FMTSLV_SHIFT) |
-		       ((format->height + 1) << ISPCCDC_FMT_VERT_FMTLNV_SHIFT),
-		       OMAP3_ISP_IOMEM_CCDC, ISPCCDC_FMT_VERT);
-
-	isp_reg_writel(isp, (format->width << ISPCCDC_VP_OUT_HORZ_NUM_SHIFT) |
-		       (format->height << ISPCCDC_VP_OUT_VERT_NUM_SHIFT),
-		       OMAP3_ISP_IOMEM_CCDC, ISPCCDC_VP_OUT);
+	ccdc_config_vp(ccdc);
 
 	/* Lens shading correction. */
 	spin_lock_irqsave(&ccdc->lsc.req_lock, flags);
@@ -1837,11 +1830,6 @@ static int ccdc_set_stream(struct v4l2_subdev *sd, int enable)
 
 		ccdc_configure(ccdc);
 
-		/* TODO: Don't configure the video port if all of its output
-		 * links are inactive.
-		 */
-		ccdc_config_vp(ccdc);
-		ccdc_enable_vp(ccdc, 1);
 		ccdc_print_status(ccdc);
 	}
 
-- 
1.8.5.5

