Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:48333 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751558Ab3KDAG3 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 3 Nov 2013 19:06:29 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: Sergio Aguirre <sergio.a.aguirre@gmail.com>,
	Sakari Ailus <sakari.ailus@iki.fi>
Subject: [PATCH v2 15/18] v4l: omap4iss: Make omap4iss_isp_subclk_(en|dis)able() functions void
Date: Mon,  4 Nov 2013 01:06:40 +0100
Message-Id: <1383523603-3907-16-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1383523603-3907-1-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1383523603-3907-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The functions always succeed, there's no need to return an error value.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/staging/media/omap4iss/iss.c | 14 ++++++--------
 drivers/staging/media/omap4iss/iss.h |  6 +++---
 2 files changed, 9 insertions(+), 11 deletions(-)

diff --git a/drivers/staging/media/omap4iss/iss.c b/drivers/staging/media/omap4iss/iss.c
index 3103093..043a3f3 100644
--- a/drivers/staging/media/omap4iss/iss.c
+++ b/drivers/staging/media/omap4iss/iss.c
@@ -836,7 +836,7 @@ int omap4iss_subclk_disable(struct iss_device *iss,
 				 ISP5_CTRL_IPIPE_CLK_ENABLE |\
 				 ISP5_CTRL_IPIPEIF_CLK_ENABLE)
 
-static int __iss_isp_subclk_update(struct iss_device *iss)
+static void __iss_isp_subclk_update(struct iss_device *iss)
 {
 	u32 clk = 0;
 
@@ -861,24 +861,22 @@ static int __iss_isp_subclk_update(struct iss_device *iss)
 	writel((readl(iss->regs[OMAP4_ISS_MEM_ISP_SYS1] + ISP5_CTRL) &
 		~ISS_ISP5_CLKCTRL_MASK) | clk,
 		iss->regs[OMAP4_ISS_MEM_ISP_SYS1] + ISP5_CTRL);
-
-	return 0;
 }
 
-int omap4iss_isp_subclk_enable(struct iss_device *iss,
+void omap4iss_isp_subclk_enable(struct iss_device *iss,
 				enum iss_isp_subclk_resource res)
 {
 	iss->isp_subclk_resources |= res;
 
-	return __iss_isp_subclk_update(iss);
+	__iss_isp_subclk_update(iss);
 }
 
-int omap4iss_isp_subclk_disable(struct iss_device *iss,
-				enum iss_isp_subclk_resource res)
+void omap4iss_isp_subclk_disable(struct iss_device *iss,
+				 enum iss_isp_subclk_resource res)
 {
 	iss->isp_subclk_resources &= ~res;
 
-	return __iss_isp_subclk_update(iss);
+	__iss_isp_subclk_update(iss);
 }
 
 /*
diff --git a/drivers/staging/media/omap4iss/iss.h b/drivers/staging/media/omap4iss/iss.h
index cc24f1a..f33664d 100644
--- a/drivers/staging/media/omap4iss/iss.h
+++ b/drivers/staging/media/omap4iss/iss.h
@@ -136,10 +136,10 @@ int omap4iss_subclk_enable(struct iss_device *iss,
 			   enum iss_subclk_resource res);
 int omap4iss_subclk_disable(struct iss_device *iss,
 			    enum iss_subclk_resource res);
-int omap4iss_isp_subclk_enable(struct iss_device *iss,
-				enum iss_isp_subclk_resource res);
-int omap4iss_isp_subclk_disable(struct iss_device *iss,
+void omap4iss_isp_subclk_enable(struct iss_device *iss,
 				enum iss_isp_subclk_resource res);
+void omap4iss_isp_subclk_disable(struct iss_device *iss,
+				 enum iss_isp_subclk_resource res);
 
 void omap4iss_isp_enable_interrupts(struct iss_device *iss);
 void omap4iss_isp_disable_interrupts(struct iss_device *iss);
-- 
1.8.1.5

