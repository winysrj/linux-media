Return-path: <mchehab@gaivota>
Received: from bear.ext.ti.com ([192.94.94.41]:34964 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756840Ab0KSXYA (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 19 Nov 2010 18:24:00 -0500
From: Sergio Aguirre <saaguirre@ti.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: linux-media@vger.kernel.org, Sergio Aguirre <saaguirre@ti.com>
Subject: [omap3isp RFC][PATCH 3/4] omap3isp: sbl: Abstract SBL busy check
Date: Fri, 19 Nov 2010 17:23:50 -0600
Message-Id: <1290209031-12817-4-git-send-email-saaguirre@ti.com>
In-Reply-To: <1290209031-12817-1-git-send-email-saaguirre@ti.com>
References: <1290209031-12817-1-git-send-email-saaguirre@ti.com>
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

Make a nicer interface that can be used by anyone accessing the isp.

Signed-off-by: Sergio Aguirre <saaguirre@ti.com>
---
 drivers/media/video/isp/isp.c     |   17 +++++++++++++++++
 drivers/media/video/isp/isp.h     |    2 ++
 drivers/media/video/isp/ispccdc.c |   10 +---------
 3 files changed, 20 insertions(+), 9 deletions(-)

diff --git a/drivers/media/video/isp/isp.c b/drivers/media/video/isp/isp.c
index ee45eb6..9db2145 100644
--- a/drivers/media/video/isp/isp.c
+++ b/drivers/media/video/isp/isp.c
@@ -362,6 +362,23 @@ int ispccdc_lsc_wait_prefetch(struct isp_device *isp)
 	return -ETIMEDOUT;
 }
 
+int isp_sbl_busy(struct isp_device *isp, enum isp_sbl_resource res)
+{
+	int ret = 0;
+
+	if (res & OMAP3_ISP_SBL_CCDC_WRITE) {
+		ret |= (isp_reg_readl(isp, OMAP3_ISP_IOMEM_SBL, ISPSBL_CCDC_WR_0) &
+			ISPSBL_CCDC_WR_0_DATA_READY)
+		     | (isp_reg_readl(isp, OMAP3_ISP_IOMEM_SBL, ISPSBL_CCDC_WR_1) &
+			ISPSBL_CCDC_WR_0_DATA_READY)
+		     | (isp_reg_readl(isp, OMAP3_ISP_IOMEM_SBL, ISPSBL_CCDC_WR_2) &
+			ISPSBL_CCDC_WR_0_DATA_READY)
+		     | (isp_reg_readl(isp, OMAP3_ISP_IOMEM_SBL, ISPSBL_CCDC_WR_3) &
+			ISPSBL_CCDC_WR_0_DATA_READY);
+	}
+
+	return ret;
+}
 
 static inline void isp_isr_dbg(struct isp_device *isp, u32 irqstatus)
 {
diff --git a/drivers/media/video/isp/isp.h b/drivers/media/video/isp/isp.h
index d0b7b0f..1948e23 100644
--- a/drivers/media/video/isp/isp.h
+++ b/drivers/media/video/isp/isp.h
@@ -282,6 +282,8 @@ void isphist_dma_done(struct isp_device *isp);
 
 int ispccdc_lsc_wait_prefetch(struct isp_device *isp);
 
+int isp_sbl_busy(struct isp_device *isp, enum isp_sbl_resource res);
+
 void isp_flush(struct isp_device *isp);
 
 int isp_pipeline_set_stream(struct isp_pipeline *pipe,
diff --git a/drivers/media/video/isp/ispccdc.c b/drivers/media/video/isp/ispccdc.c
index b039bce..9220d09 100644
--- a/drivers/media/video/isp/ispccdc.c
+++ b/drivers/media/video/isp/ispccdc.c
@@ -1217,15 +1217,7 @@ static int ispccdc_sbl_busy(struct isp_ccdc_device *ccdc)
 {
 	struct isp_device *isp = to_isp_device(ccdc);
 
-	return ispccdc_busy(ccdc)
-		| (isp_reg_readl(isp, OMAP3_ISP_IOMEM_SBL, ISPSBL_CCDC_WR_0) &
-		   ISPSBL_CCDC_WR_0_DATA_READY)
-		| (isp_reg_readl(isp, OMAP3_ISP_IOMEM_SBL, ISPSBL_CCDC_WR_1) &
-		   ISPSBL_CCDC_WR_0_DATA_READY)
-		| (isp_reg_readl(isp, OMAP3_ISP_IOMEM_SBL, ISPSBL_CCDC_WR_2) &
-		   ISPSBL_CCDC_WR_0_DATA_READY)
-		| (isp_reg_readl(isp, OMAP3_ISP_IOMEM_SBL, ISPSBL_CCDC_WR_3) &
-		   ISPSBL_CCDC_WR_0_DATA_READY);
+	return ispccdc_busy(ccdc) | isp_sbl_busy(isp, OMAP3_ISP_SBL_CCDC_WRITE);
 }
 
 /*
-- 
1.7.0.4

