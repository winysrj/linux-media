Return-path: <mchehab@pedra>
Received: from perceval.ideasonboard.com ([95.142.166.194]:43021 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753148Ab1DEH5P (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 5 Apr 2011 03:57:15 -0400
Received: from localhost.localdomain (unknown [91.178.236.143])
	by perceval.ideasonboard.com (Postfix) with ESMTPSA id CD24035B70
	for <linux-media@vger.kernel.org>; Tue,  5 Apr 2011 07:57:11 +0000 (UTC)
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Subject: [PATCH 09/14] omap3isp: Use isp xclk defines
Date: Tue,  5 Apr 2011 09:57:31 +0200
Message-Id: <1301990256-6963-10-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1301990256-6963-1-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1301990256-6963-1-git-send-email-laurent.pinchart@ideasonboard.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

From: Stanimir Varbanov <svarbanov@mm-sol.com>

Use isp defines for isp xclk selection in isp_set_xclk().

Signed-off-by: Stanimir Varbanov <svarbanov@mm-sol.com>
---
 drivers/media/video/omap3isp/isp.c |   12 +++++++-----
 drivers/media/video/omap3isp/isp.h |    6 +++---
 2 files changed, 10 insertions(+), 8 deletions(-)

diff --git a/drivers/media/video/omap3isp/isp.c b/drivers/media/video/omap3isp/isp.c
index f380f09..78240c0 100644
--- a/drivers/media/video/omap3isp/isp.c
+++ b/drivers/media/video/omap3isp/isp.c
@@ -215,20 +215,21 @@ static u32 isp_set_xclk(struct isp_device *isp, u32 xclk, u8 xclksel)
 	}
 
 	switch (xclksel) {
-	case 0:
+	case ISP_XCLK_A:
 		isp_reg_clr_set(isp, OMAP3_ISP_IOMEM_MAIN, ISP_TCTRL_CTRL,
 				ISPTCTRL_CTRL_DIVA_MASK,
 				divisor << ISPTCTRL_CTRL_DIVA_SHIFT);
 		dev_dbg(isp->dev, "isp_set_xclk(): cam_xclka set to %d Hz\n",
 			currentxclk);
 		break;
-	case 1:
+	case ISP_XCLK_B:
 		isp_reg_clr_set(isp, OMAP3_ISP_IOMEM_MAIN, ISP_TCTRL_CTRL,
 				ISPTCTRL_CTRL_DIVB_MASK,
 				divisor << ISPTCTRL_CTRL_DIVB_SHIFT);
 		dev_dbg(isp->dev, "isp_set_xclk(): cam_xclkb set to %d Hz\n",
 			currentxclk);
 		break;
+	case ISP_XCLK_NONE:
 	default:
 		omap3isp_put(isp);
 		dev_dbg(isp->dev, "ISP_ERR: isp_set_xclk(): Invalid requested "
@@ -237,13 +238,13 @@ static u32 isp_set_xclk(struct isp_device *isp, u32 xclk, u8 xclksel)
 	}
 
 	/* Do we go from stable whatever to clock? */
-	if (divisor >= 2 && isp->xclk_divisor[xclksel] < 2)
+	if (divisor >= 2 && isp->xclk_divisor[xclksel - 1] < 2)
 		omap3isp_get(isp);
 	/* Stopping the clock. */
-	else if (divisor < 2 && isp->xclk_divisor[xclksel] >= 2)
+	else if (divisor < 2 && isp->xclk_divisor[xclksel - 1] >= 2)
 		omap3isp_put(isp);
 
-	isp->xclk_divisor[xclksel] = divisor;
+	isp->xclk_divisor[xclksel - 1] = divisor;
 
 	omap3isp_put(isp);
 
diff --git a/drivers/media/video/omap3isp/isp.h b/drivers/media/video/omap3isp/isp.h
index 5f87645..00075c6 100644
--- a/drivers/media/video/omap3isp/isp.h
+++ b/drivers/media/video/omap3isp/isp.h
@@ -314,9 +314,9 @@ void omap3isp_configure_bridge(struct isp_device *isp,
 			       enum ccdc_input_entity input,
 			       const struct isp_parallel_platform_data *pdata);
 
-#define ISP_XCLK_NONE			-1
-#define ISP_XCLK_A			0
-#define ISP_XCLK_B			1
+#define ISP_XCLK_NONE			0
+#define ISP_XCLK_A			1
+#define ISP_XCLK_B			2
 
 struct isp_device *omap3isp_get(struct isp_device *isp);
 void omap3isp_put(struct isp_device *isp);
-- 
1.7.3.4

