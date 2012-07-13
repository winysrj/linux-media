Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:58835 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753201Ab2GMLhk (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 13 Jul 2012 07:37:40 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: Jean-Philippe Francois <jp.francois@cynove.com>,
	Sakari Ailus <sakari.ailus@iki.fi>
Subject: [PATCH v3 2/6] omap3isp: preview: Remove lens shading compensation support
Date: Fri, 13 Jul 2012 13:37:34 +0200
Message-Id: <1342179458-1037-3-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1342179458-1037-1-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1342179458-1037-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The feature isn't fully implemented and doesn't work, remove it.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/media/video/omap3isp/isppreview.c |   18 +-----------------
 1 files changed, 1 insertions(+), 17 deletions(-)

diff --git a/drivers/media/video/omap3isp/isppreview.c b/drivers/media/video/omap3isp/isppreview.c
index a06af90..75eeafa 100644
--- a/drivers/media/video/omap3isp/isppreview.c
+++ b/drivers/media/video/omap3isp/isppreview.c
@@ -215,22 +215,6 @@ preview_enable_drkframe(struct isp_prev_device *prev, u8 enable)
 }
 
 /*
- * preview_config_drkf_shadcomp - Configures shift value in shading comp.
- * @scomp_shtval: 3bit value of shift used in shading compensation.
- */
-static void
-preview_config_drkf_shadcomp(struct isp_prev_device *prev,
-			     const void *scomp_shtval)
-{
-	struct isp_device *isp = to_isp_device(prev);
-	const u32 *shtval = scomp_shtval;
-
-	isp_reg_clr_set(isp, OMAP3_ISP_IOMEM_PREV, ISPPRV_PCR,
-			ISPPRV_PCR_SCOMP_SFT_MASK,
-			*shtval << ISPPRV_PCR_SCOMP_SFT_SHIFT);
-}
-
-/*
  * preview_enable_hmed - Enables/Disables of the Horizontal Median Filter.
  * @enable: 1 - Enables Horizontal Median Filter.
  */
@@ -870,7 +854,7 @@ static const struct preview_update update_attrs[] = {
 		NULL,
 		preview_enable_drkframe,
 	}, /* OMAP3ISP_PREV_LENS_SHADING */ {
-		preview_config_drkf_shadcomp,
+		NULL,
 		preview_enable_drkframe,
 	}, /* OMAP3ISP_PREV_NF */ {
 		preview_config_noisefilter,
-- 
1.7.8.6

