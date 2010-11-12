Return-path: <mchehab@pedra>
Received: from devils.ext.ti.com ([198.47.26.153]:52896 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932397Ab0KLVSJ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 12 Nov 2010 16:18:09 -0500
From: Sergio Aguirre <saaguirre@ti.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: linux-media@vger.kernel.org, Sergio Aguirre <saaguirre@ti.com>
Subject: [omap3isp RFC][PATCH 07/10] omap3isp: Remove CSIA/B register abstraction
Date: Fri, 12 Nov 2010 15:18:10 -0600
Message-Id: <1289596693-27660-8-git-send-email-saaguirre@ti.com>
In-Reply-To: <1289596693-27660-1-git-send-email-saaguirre@ti.com>
References: <1289596693-27660-1-git-send-email-saaguirre@ti.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Signed-off-by: Sergio Aguirre <saaguirre@ti.com>
---
 drivers/media/video/isp/isp.c     |    8 ++++----
 drivers/media/video/isp/ispccp2.c |    2 +-
 drivers/media/video/isp/ispreg.h  |    3 ---
 3 files changed, 5 insertions(+), 8 deletions(-)

diff --git a/drivers/media/video/isp/isp.c b/drivers/media/video/isp/isp.c
index f266e7c..de9352b 100644
--- a/drivers/media/video/isp/isp.c
+++ b/drivers/media/video/isp/isp.c
@@ -264,12 +264,12 @@ static void isp_power_settings(struct isp_device *isp, int idle)
 				       (ISPCSI1_MIDLEMODE_SMARTSTANDBY <<
 					ISPCSI1_MIDLEMODE_SHIFT),
 				       OMAP3_ISP_IOMEM_CSI2A_REGS1,
-				       ISP_CSIA_SYSCONFIG);
+				       ISPCSI2_SYSCONFIG);
 			isp_reg_writel(isp, ISPCSI1_AUTOIDLE |
 				       (ISPCSI1_MIDLEMODE_SMARTSTANDBY <<
 					ISPCSI1_MIDLEMODE_SHIFT),
 				       OMAP3_ISP_IOMEM_CCP2,
-				       ISP_CSIB_SYSCONFIG);
+				       ISPCCP2_SYSCONFIG);
 		}
 		isp_reg_writel(isp, ISPCTRL_SBL_AUTOIDLE, OMAP3_ISP_IOMEM_MAIN,
 			       ISP_CTRL);
@@ -284,13 +284,13 @@ static void isp_power_settings(struct isp_device *isp, int idle)
 				       (ISPCSI1_MIDLEMODE_FORCESTANDBY <<
 					ISPCSI1_MIDLEMODE_SHIFT),
 				       OMAP3_ISP_IOMEM_CSI2A_REGS1,
-				       ISP_CSIA_SYSCONFIG);
+				       ISPCSI2_SYSCONFIG);
 
 			isp_reg_writel(isp, ISPCSI1_AUTOIDLE |
 				       (ISPCSI1_MIDLEMODE_FORCESTANDBY <<
 					ISPCSI1_MIDLEMODE_SHIFT),
 				       OMAP3_ISP_IOMEM_CCP2,
-				       ISP_CSIB_SYSCONFIG);
+				       ISPCCP2_SYSCONFIG);
 		}
 
 		isp_reg_writel(isp, ISPCTRL_SBL_AUTOIDLE, OMAP3_ISP_IOMEM_MAIN,
diff --git a/drivers/media/video/isp/ispccp2.c b/drivers/media/video/isp/ispccp2.c
index 45506a7..fa23394 100644
--- a/drivers/media/video/isp/ispccp2.c
+++ b/drivers/media/video/isp/ispccp2.c
@@ -421,7 +421,7 @@ static void ispccp2_mem_configure(struct isp_ccp2_device *ccp2,
 
 	isp_reg_writel(isp, (ISPCSI1_MIDLEMODE_SMARTSTANDBY <<
 		       ISPCSI1_MIDLEMODE_SHIFT),
-		       OMAP3_ISP_IOMEM_CCP2, ISP_CSIB_SYSCONFIG);
+		       OMAP3_ISP_IOMEM_CCP2, ISPCCP2_SYSCONFIG);
 
 	/* Hsize, Skip */
 	isp_reg_writel(isp, ISPCCP2_LCM_HSIZE_SKIP_MIN |
diff --git a/drivers/media/video/isp/ispreg.h b/drivers/media/video/isp/ispreg.h
index c080980..d885541 100644
--- a/drivers/media/video/isp/ispreg.h
+++ b/drivers/media/video/isp/ispreg.h
@@ -236,9 +236,6 @@
 #define ISPCCP2_LCM_DST_ADDR		(0x1E8)
 #define ISPCCP2_LCM_DST_OFST		(0x1EC)
 
-#define ISP_CSIB_SYSCONFIG		ISPCCP2_SYSCONFIG
-#define ISP_CSIA_SYSCONFIG		ISPCSI2_SYSCONFIG
-
 /* CCDC module register offset */
 
 #define ISPCCDC_PID			(0x000)
-- 
1.7.0.4

