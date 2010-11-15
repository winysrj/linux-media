Return-path: <mchehab@pedra>
Received: from devils.ext.ti.com ([198.47.26.153]:54879 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757347Ab0KOOaD (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 15 Nov 2010 09:30:03 -0500
From: Sergio Aguirre <saaguirre@ti.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: linux-media@vger.kernel.org, Sergio Aguirre <saaguirre@ti.com>
Subject: [omap3isp][PATCH v2 7/9] omap3isp: Cleanup isp_power_settings
Date: Mon, 15 Nov 2010 08:29:59 -0600
Message-Id: <1289831401-593-8-git-send-email-saaguirre@ti.com>
In-Reply-To: <1289831401-593-1-git-send-email-saaguirre@ti.com>
References: <1289831401-593-1-git-send-email-saaguirre@ti.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

1. Get rid of CSI2 / CCP2 power settings, as they are controlled
   in the receivers code anyways.
2. Avoid code duplication.

Signed-off-by: Sergio Aguirre <saaguirre@ti.com>
---
 drivers/media/video/isp/isp.c |   49 ++++++-----------------------------------
 1 files changed, 7 insertions(+), 42 deletions(-)

diff --git a/drivers/media/video/isp/isp.c b/drivers/media/video/isp/isp.c
index de9352b..30bdc48 100644
--- a/drivers/media/video/isp/isp.c
+++ b/drivers/media/video/isp/isp.c
@@ -254,48 +254,13 @@ EXPORT_SYMBOL(isp_set_xclk);
  */
 static void isp_power_settings(struct isp_device *isp, int idle)
 {
-	if (idle) {
-		isp_reg_writel(isp,
-			       (ISP_SYSCONFIG_MIDLEMODE_SMARTSTANDBY <<
-				ISP_SYSCONFIG_MIDLEMODE_SHIFT),
-			       OMAP3_ISP_IOMEM_MAIN, ISP_SYSCONFIG);
-		if (omap_rev() == OMAP3430_REV_ES1_0) {
-			isp_reg_writel(isp, ISPCSI1_AUTOIDLE |
-				       (ISPCSI1_MIDLEMODE_SMARTSTANDBY <<
-					ISPCSI1_MIDLEMODE_SHIFT),
-				       OMAP3_ISP_IOMEM_CSI2A_REGS1,
-				       ISPCSI2_SYSCONFIG);
-			isp_reg_writel(isp, ISPCSI1_AUTOIDLE |
-				       (ISPCSI1_MIDLEMODE_SMARTSTANDBY <<
-					ISPCSI1_MIDLEMODE_SHIFT),
-				       OMAP3_ISP_IOMEM_CCP2,
-				       ISPCCP2_SYSCONFIG);
-		}
-		isp_reg_writel(isp, ISPCTRL_SBL_AUTOIDLE, OMAP3_ISP_IOMEM_MAIN,
-			       ISP_CTRL);
-
-	} else {
-		isp_reg_writel(isp,
-			       (ISP_SYSCONFIG_MIDLEMODE_FORCESTANDBY <<
-				ISP_SYSCONFIG_MIDLEMODE_SHIFT),
-			       OMAP3_ISP_IOMEM_MAIN, ISP_SYSCONFIG);
-		if (omap_rev() == OMAP3430_REV_ES1_0) {
-			isp_reg_writel(isp, ISPCSI1_AUTOIDLE |
-				       (ISPCSI1_MIDLEMODE_FORCESTANDBY <<
-					ISPCSI1_MIDLEMODE_SHIFT),
-				       OMAP3_ISP_IOMEM_CSI2A_REGS1,
-				       ISPCSI2_SYSCONFIG);
-
-			isp_reg_writel(isp, ISPCSI1_AUTOIDLE |
-				       (ISPCSI1_MIDLEMODE_FORCESTANDBY <<
-					ISPCSI1_MIDLEMODE_SHIFT),
-				       OMAP3_ISP_IOMEM_CCP2,
-				       ISPCCP2_SYSCONFIG);
-		}
-
-		isp_reg_writel(isp, ISPCTRL_SBL_AUTOIDLE, OMAP3_ISP_IOMEM_MAIN,
-			       ISP_CTRL);
-	}
+	isp_reg_writel(isp,
+		       ((idle ? ISP_SYSCONFIG_MIDLEMODE_SMARTSTANDBY :
+				ISP_SYSCONFIG_MIDLEMODE_FORCESTANDBY) <<
+			ISP_SYSCONFIG_MIDLEMODE_SHIFT),
+		       OMAP3_ISP_IOMEM_MAIN, ISP_SYSCONFIG);
+	isp_reg_writel(isp, ISPCTRL_SBL_AUTOIDLE, OMAP3_ISP_IOMEM_MAIN,
+		       ISP_CTRL);
 }
 
 /*
-- 
1.7.0.4

