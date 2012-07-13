Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:58837 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756422Ab2GMLhm (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 13 Jul 2012 07:37:42 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: Jean-Philippe Francois <jp.francois@cynove.com>,
	Sakari Ailus <sakari.ailus@iki.fi>
Subject: [PATCH v3 5/6] omap3isp: preview: Merge gamma correction and gamma bypass
Date: Fri, 13 Jul 2012 13:37:37 +0200
Message-Id: <1342179458-1037-6-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1342179458-1037-1-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1342179458-1037-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Enabling gamma bypass disables gamma correction and vice versa. Merge
the two parameters.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/media/video/omap3isp/isppreview.c |   44 ++++++++++++++--------------
 include/linux/omap3isp.h                  |    2 +-
 2 files changed, 23 insertions(+), 23 deletions(-)

diff --git a/drivers/media/video/omap3isp/isppreview.c b/drivers/media/video/omap3isp/isppreview.c
index 50be9e2..5b6f636 100644
--- a/drivers/media/video/omap3isp/isppreview.c
+++ b/drivers/media/video/omap3isp/isppreview.c
@@ -481,25 +481,6 @@ static void preview_enable_dcor(struct isp_prev_device *prev, bool enable)
 }
 
 /*
- * preview_enable_gammabypass - Enable/disable Gamma Bypass
- *
- * When gamma bypass is enabled, the output of the gamma correction is the 8 MSB
- * of the 10-bit input .
- */
-static void
-preview_enable_gammabypass(struct isp_prev_device *prev, bool enable)
-{
-	struct isp_device *isp = to_isp_device(prev);
-
-	if (enable)
-		isp_reg_set(isp, OMAP3_ISP_IOMEM_PREV, ISPPRV_PCR,
-			    ISPPRV_PCR_GAMMA_BYPASS);
-	else
-		isp_reg_clr(isp, OMAP3_ISP_IOMEM_PREV, ISPPRV_PCR,
-			    ISPPRV_PCR_GAMMA_BYPASS);
-}
-
-/*
  * preview_enable_drkframe_capture - Enable/disable Dark Frame Capture
  */
 static void
@@ -597,6 +578,25 @@ preview_config_gammacorrn(struct isp_prev_device *prev,
 }
 
 /*
+ * preview_enable_gammacorrn - Enable/disable Gamma Correction
+ *
+ * When gamma correction is disabled, the module is bypassed and its output is
+ * the 8 MSB of the 10-bit input .
+ */
+static void
+preview_enable_gammacorrn(struct isp_prev_device *prev, bool enable)
+{
+	struct isp_device *isp = to_isp_device(prev);
+
+	if (enable)
+		isp_reg_clr(isp, OMAP3_ISP_IOMEM_PREV, ISPPRV_PCR,
+			    ISPPRV_PCR_GAMMA_BYPASS);
+	else
+		isp_reg_set(isp, OMAP3_ISP_IOMEM_PREV, ISPPRV_PCR,
+			    ISPPRV_PCR_GAMMA_BYPASS);
+}
+
+/*
  * preview_config_contrast - Configure the Contrast
  *
  * Value should be programmed before enabling the module.
@@ -815,9 +815,9 @@ static const struct preview_update update_attrs[] = {
 		offsetof(struct prev_params, dcor),
 		FIELD_SIZEOF(struct prev_params, dcor),
 		offsetof(struct omap3isp_prev_update_config, dcor),
-	}, /* OMAP3ISP_PREV_GAMMABYPASS */ {
+	}, /* Previously OMAP3ISP_PREV_GAMMABYPASS, not used anymore */ {
+		NULL,
 		NULL,
-		preview_enable_gammabypass,
 	}, /* OMAP3ISP_PREV_DRK_FRM_CAPTURE */ {
 		NULL,
 		preview_enable_drkframe_capture,
@@ -835,7 +835,7 @@ static const struct preview_update update_attrs[] = {
 		offsetof(struct omap3isp_prev_update_config, nf),
 	}, /* OMAP3ISP_PREV_GAMMA */ {
 		preview_config_gammacorrn,
-		NULL,
+		preview_enable_gammacorrn,
 		offsetof(struct prev_params, gamma),
 		FIELD_SIZEOF(struct prev_params, gamma),
 		offsetof(struct omap3isp_prev_update_config, gamma),
diff --git a/include/linux/omap3isp.h b/include/linux/omap3isp.h
index c73a34c..79af5c4 100644
--- a/include/linux/omap3isp.h
+++ b/include/linux/omap3isp.h
@@ -427,7 +427,7 @@ struct omap3isp_ccdc_update_config {
 #define OMAP3ISP_PREV_COLOR_CONV	(1 << 8)
 #define OMAP3ISP_PREV_YC_LIMIT		(1 << 9)
 #define OMAP3ISP_PREV_DEFECT_COR	(1 << 10)
-#define OMAP3ISP_PREV_GAMMABYPASS	(1 << 11)
+/* Bit 11 was OMAP3ISP_PREV_GAMMABYPASS, now merged with OMAP3ISP_PREV_GAMMA */
 #define OMAP3ISP_PREV_DRK_FRM_CAPTURE	(1 << 12)
 #define OMAP3ISP_PREV_DRK_FRM_SUBTRACT	(1 << 13)
 #define OMAP3ISP_PREV_LENS_SHADING	(1 << 14)
-- 
1.7.8.6

