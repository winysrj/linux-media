Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.logicpd.com ([174.46.170.145]:51779 "HELO smtp.logicpd.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751737AbbCJThf (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 10 Mar 2015 15:37:35 -0400
From: Tim Nordell <tim.nordell@logicpd.com>
To: <linux-media@vger.kernel.org>
CC: <laurent.pinchart@ideasonboard.com>, <sakari.ailus@iki.fi>,
	Tim Nordell <tim.nordell@logicpd.com>
Subject: [PATCH 2/3] omap3isp: Disable CCDC's VD0 and VD1 interrupts when stream is not enabled
Date: Tue, 10 Mar 2015 14:24:53 -0500
Message-ID: <1426015494-16799-3-git-send-email-tim.nordell@logicpd.com>
In-Reply-To: <1426015494-16799-1-git-send-email-tim.nordell@logicpd.com>
References: <1426015494-16799-1-git-send-email-tim.nordell@logicpd.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

During testing there appeared to be a race condition where the IRQs
for VD0 and VD1 could be triggered while enabling the CCDC module
before the pipeline status was updated.  Simply modify the trigger
conditions for VD0 and VD1 so they won't occur when the CCDC module
is not enabled.

(When this occurred during testing, the VD0 interrupt was occurring
over and over again starving the rest of the system.)

Signed-off-by: Tim Nordell <tim.nordell@logicpd.com>
---
 drivers/media/platform/omap3isp/ispccdc.c | 25 ++++++++++++++++++-------
 1 file changed, 18 insertions(+), 7 deletions(-)

diff --git a/drivers/media/platform/omap3isp/ispccdc.c b/drivers/media/platform/omap3isp/ispccdc.c
index 587489a..d5de843 100644
--- a/drivers/media/platform/omap3isp/ispccdc.c
+++ b/drivers/media/platform/omap3isp/ispccdc.c
@@ -1218,13 +1218,6 @@ static void ccdc_configure(struct isp_ccdc_device *ccdc)
 	}
 	ccdc_config_imgattr(ccdc, ccdc_pattern);
 
-	/* Generate VD0 on the last line of the image and VD1 on the
-	 * 2/3 height line.
-	 */
-	isp_reg_writel(isp, ((format->height - 2) << ISPCCDC_VDINT_0_SHIFT) |
-		       ((format->height * 2 / 3) << ISPCCDC_VDINT_1_SHIFT),
-		       OMAP3_ISP_IOMEM_CCDC, ISPCCDC_VDINT);
-
 	/* CCDC_PAD_SOURCE_OF */
 	format = &ccdc->formats[CCDC_PAD_SOURCE_OF];
 	crop = &ccdc->crop;
@@ -1316,11 +1309,29 @@ unlock:
 
 static void __ccdc_enable(struct isp_ccdc_device *ccdc, int enable)
 {
+	struct v4l2_mbus_framefmt *format = &ccdc->formats[CCDC_PAD_SINK];
 	struct isp_device *isp = to_isp_device(ccdc);
+	int vd0, vd1;
 
 	isp_reg_clr_set(isp, OMAP3_ISP_IOMEM_CCDC, ISPCCDC_PCR,
 			ISPCCDC_PCR_EN, enable ? ISPCCDC_PCR_EN : 0);
 
+	/* Generate VD0 on the last line of the image and VD1 on the
+	* 2/3 height line when enabled.  Otherwise, set VD0 and VD1
+	* interrupts high enough that they won't be generated.
+	*/
+	if (enable) {
+		vd0 = format->height - 2;
+		vd1 = format->height * 2 / 3;
+	} else {
+		vd0 = 0xffff;
+		vd1 = 0xffff;
+	}
+
+	isp_reg_writel(isp, (vd0 << ISPCCDC_VDINT_0_SHIFT) |
+		(vd1 << ISPCCDC_VDINT_1_SHIFT),
+		OMAP3_ISP_IOMEM_CCDC, ISPCCDC_VDINT);
+
 	ccdc->running = enable;
 }
 
-- 
2.0.4

