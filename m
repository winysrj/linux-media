Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:51012 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757862Ab2FZBe7 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 25 Jun 2012 21:34:59 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: sakari.ailus@iki.fi
Subject: [PATCH 2/2] omap3isp: Configure HS/VS interrupt source before enabling interrupts
Date: Tue, 26 Jun 2012 03:34:56 +0200
Message-Id: <1340674496-31953-3-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1340674496-31953-1-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1340674496-31953-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This needs to be performed before enabling interrupts as the sensor
might be free-running and the ISP default setting (HS edge) would put an
unnecessary burden on the CPU.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/media/video/omap3isp/isp.c |   43 +++++++++++++++++++++--------------
 1 files changed, 26 insertions(+), 17 deletions(-)

diff --git a/drivers/media/video/omap3isp/isp.c b/drivers/media/video/omap3isp/isp.c
index 2e1f322..36805ca 100644
--- a/drivers/media/video/omap3isp/isp.c
+++ b/drivers/media/video/omap3isp/isp.c
@@ -252,13 +252,18 @@ static u32 isp_set_xclk(struct isp_device *isp, u32 xclk, u8 xclksel)
 }
 
 /*
- * isp_power_settings - Sysconfig settings, for Power Management.
+ * isp_core_init - ISP core settings
  * @isp: OMAP3 ISP device
  * @idle: Consider idle state.
  *
- * Sets the power settings for the ISP, and SBL bus.
+ * Set the power settings for the ISP and SBL bus and cConfigure the HS/VS
+ * interrupt source.
+ *
+ * We need to configure the HS/VS interrupt source before interrupts get
+ * enabled, as the sensor might be free-running and the ISP default setting
+ * (HS edge) would put an unnecessary burden on the CPU.
  */
-static void isp_power_settings(struct isp_device *isp, int idle)
+static void isp_core_init(struct isp_device *isp, int idle)
 {
 	isp_reg_writel(isp,
 		       ((idle ? ISP_SYSCONFIG_MIDLEMODE_SMARTSTANDBY :
@@ -268,9 +273,10 @@ static void isp_power_settings(struct isp_device *isp, int idle)
 			  ISP_SYSCONFIG_AUTOIDLE : 0),
 		       OMAP3_ISP_IOMEM_MAIN, ISP_SYSCONFIG);
 
-	if (isp->autoidle)
-		isp_reg_writel(isp, ISPCTRL_SBL_AUTOIDLE, OMAP3_ISP_IOMEM_MAIN,
-			       ISP_CTRL);
+	isp_reg_writel(isp,
+		       (isp->autoidle ? ISPCTRL_SBL_AUTOIDLE : 0) |
+		       ISPCTRL_SYNC_DETECT_VSRISE,
+		       OMAP3_ISP_IOMEM_MAIN, ISP_CTRL);
 }
 
 /*
@@ -323,9 +329,6 @@ void omap3isp_configure_bridge(struct isp_device *isp,
 
 	ispctrl_val |= ((shift/2) << ISPCTRL_SHIFT_SHIFT) & ISPCTRL_SHIFT_MASK;
 
-	ispctrl_val &= ~ISPCTRL_SYNC_DETECT_MASK;
-	ispctrl_val |= ISPCTRL_SYNC_DETECT_VSRISE;
-
 	isp_reg_writel(isp, ispctrl_val, OMAP3_ISP_IOMEM_MAIN, ISP_CTRL);
 }
 
@@ -1443,7 +1446,7 @@ static int isp_get_clocks(struct isp_device *isp)
  *
  * Return a pointer to the ISP device structure, or NULL if an error occurred.
  */
-struct isp_device *omap3isp_get(struct isp_device *isp)
+static struct isp_device *__omap3isp_get(struct isp_device *isp, bool irq)
 {
 	struct isp_device *__isp = isp;
 
@@ -1462,10 +1465,9 @@ struct isp_device *omap3isp_get(struct isp_device *isp)
 	/* We don't want to restore context before saving it! */
 	if (isp->has_context)
 		isp_restore_ctx(isp);
-	else
-		isp->has_context = 1;
 
-	isp_enable_interrupts(isp);
+	if (irq)
+		isp_enable_interrupts(isp);
 
 out:
 	if (__isp != NULL)
@@ -1475,6 +1477,11 @@ out:
 	return __isp;
 }
 
+struct isp_device *omap3isp_get(struct isp_device *isp)
+{
+	return __omap3isp_get(isp, true);
+}
+
 /*
  * omap3isp_put - Release the ISP
  *
@@ -1490,8 +1497,10 @@ void omap3isp_put(struct isp_device *isp)
 	BUG_ON(isp->ref_count == 0);
 	if (--isp->ref_count == 0) {
 		isp_disable_interrupts(isp);
-		if (isp->domain)
+		if (isp->domain) {
 			isp_save_ctx(isp);
+			isp->has_context = 1;
+		}
 		/* Reset the ISP if an entity has failed to stop. This is the
 		 * only way to recover from such conditions.
 		 */
@@ -1975,7 +1984,7 @@ static int __devexit isp_remove(struct platform_device *pdev)
 	isp_unregister_entities(isp);
 	isp_cleanup_modules(isp);
 
-	omap3isp_get(isp);
+	__omap3isp_get(isp, false);
 	iommu_detach_device(isp->domain, &pdev->dev);
 	iommu_domain_free(isp->domain);
 	isp->domain = NULL;
@@ -2093,7 +2102,7 @@ static int __devinit isp_probe(struct platform_device *pdev)
 	if (ret < 0)
 		goto error;
 
-	if (omap3isp_get(isp) == NULL)
+	if (__omap3isp_get(isp, false) == NULL)
 		goto error;
 
 	ret = isp_reset(isp);
@@ -2160,7 +2169,7 @@ static int __devinit isp_probe(struct platform_device *pdev)
 	if (ret < 0)
 		goto error_modules;
 
-	isp_power_settings(isp, 1);
+	isp_core_init(isp, 1);
 	omap3isp_put(isp);
 
 	return 0;
-- 
1.7.3.4

