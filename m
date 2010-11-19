Return-path: <mchehab@gaivota>
Received: from devils.ext.ti.com ([198.47.26.153]:52313 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754300Ab0KSXYB (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 19 Nov 2010 18:24:01 -0500
From: Sergio Aguirre <saaguirre@ti.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: linux-media@vger.kernel.org, Sergio Aguirre <saaguirre@ti.com>
Subject: [omap3isp RFC][PATCH 2/4] omap3isp: Move CCDC LSC prefetch wait to main isp code
Date: Fri, 19 Nov 2010 17:23:49 -0600
Message-Id: <1290209031-12817-3-git-send-email-saaguirre@ti.com>
In-Reply-To: <1290209031-12817-1-git-send-email-saaguirre@ti.com>
References: <1290209031-12817-1-git-send-email-saaguirre@ti.com>
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

Since this sequence strictly touches ISP global registers, it's
not really part of the same register address space than the CCDC.

Do this check in main isp code instead.

Signed-off-by: Sergio Aguirre <saaguirre@ti.com>
---
 drivers/media/video/isp/isp.c     |   24 ++++++++++++++++++++++++
 drivers/media/video/isp/isp.h     |    2 ++
 drivers/media/video/isp/ispccdc.c |   26 +-------------------------
 3 files changed, 27 insertions(+), 25 deletions(-)

diff --git a/drivers/media/video/isp/isp.c b/drivers/media/video/isp/isp.c
index 2e5030f..ee45eb6 100644
--- a/drivers/media/video/isp/isp.c
+++ b/drivers/media/video/isp/isp.c
@@ -339,6 +339,30 @@ void isphist_dma_done(struct isp_device *isp)
 	}
 }
 
+int ispccdc_lsc_wait_prefetch(struct isp_device *isp)
+{
+	unsigned int wait;
+
+	isp_reg_writel(isp, IRQ0STATUS_CCDC_LSC_PREF_COMP_IRQ,
+		       OMAP3_ISP_IOMEM_MAIN, ISP_IRQ0STATUS);
+
+	/* timeout 1 ms */
+	for (wait = 0; wait < 1000; wait++) {
+		if (isp_reg_readl(isp, OMAP3_ISP_IOMEM_MAIN, ISP_IRQ0STATUS) &
+				  IRQ0STATUS_CCDC_LSC_PREF_COMP_IRQ) {
+			isp_reg_writel(isp, IRQ0STATUS_CCDC_LSC_PREF_COMP_IRQ,
+				       OMAP3_ISP_IOMEM_MAIN, ISP_IRQ0STATUS);
+			return 0;
+		}
+
+		rmb();
+		udelay(1);
+	}
+
+	return -ETIMEDOUT;
+}
+
+
 static inline void isp_isr_dbg(struct isp_device *isp, u32 irqstatus)
 {
 	static const char *name[] = {
diff --git a/drivers/media/video/isp/isp.h b/drivers/media/video/isp/isp.h
index 1260e9f..d0b7b0f 100644
--- a/drivers/media/video/isp/isp.h
+++ b/drivers/media/video/isp/isp.h
@@ -280,6 +280,8 @@ struct isp_device {
 
 void isphist_dma_done(struct isp_device *isp);
 
+int ispccdc_lsc_wait_prefetch(struct isp_device *isp);
+
 void isp_flush(struct isp_device *isp);
 
 int isp_pipeline_set_stream(struct isp_pipeline *pipe,
diff --git a/drivers/media/video/isp/ispccdc.c b/drivers/media/video/isp/ispccdc.c
index 4244edf..b039bce 100644
--- a/drivers/media/video/isp/ispccdc.c
+++ b/drivers/media/video/isp/ispccdc.c
@@ -223,30 +223,6 @@ static void ispccdc_lsc_setup_regs(struct isp_ccdc_device *ccdc,
 		       ISPCCDC_LSC_INITIAL);
 }
 
-static int ispccdc_lsc_wait_prefetch(struct isp_ccdc_device *ccdc)
-{
-	struct isp_device *isp = to_isp_device(ccdc);
-	unsigned int wait;
-
-	isp_reg_writel(isp, IRQ0STATUS_CCDC_LSC_PREF_COMP_IRQ,
-		       OMAP3_ISP_IOMEM_MAIN, ISP_IRQ0STATUS);
-
-	/* timeout 1 ms */
-	for (wait = 0; wait < 1000; wait++) {
-		if (isp_reg_readl(isp, OMAP3_ISP_IOMEM_MAIN, ISP_IRQ0STATUS) &
-				  IRQ0STATUS_CCDC_LSC_PREF_COMP_IRQ) {
-			isp_reg_writel(isp, IRQ0STATUS_CCDC_LSC_PREF_COMP_IRQ,
-				       OMAP3_ISP_IOMEM_MAIN, ISP_IRQ0STATUS);
-			return 0;
-		}
-
-		rmb();
-		udelay(1);
-	}
-
-	return -ETIMEDOUT;
-}
-
 /*
  * __ispccdc_lsc_enable - Enables/Disables the Lens Shading Compensation module.
  * @ccdc: Pointer to ISP CCDC device.
@@ -272,7 +248,7 @@ static int __ispccdc_lsc_enable(struct isp_ccdc_device *ccdc, int enable)
 			ISPCCDC_LSC_ENABLE, enable ? ISPCCDC_LSC_ENABLE : 0);
 
 	if (enable) {
-		if (ispccdc_lsc_wait_prefetch(ccdc) < 0) {
+		if (ispccdc_lsc_wait_prefetch(isp) < 0) {
 			isp_reg_clr(isp, OMAP3_ISP_IOMEM_CCDC,
 				    ISPCCDC_LSC_CONFIG, ISPCCDC_LSC_ENABLE);
 			ccdc->lsc.state = LSC_STATE_STOPPED;
-- 
1.7.0.4

