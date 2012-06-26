Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:51011 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757879Ab2FZBe6 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 25 Jun 2012 21:34:58 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: sakari.ailus@iki.fi
Subject: [PATCH 1/2] omap3isp: Don't access ISP_CTRL directly in the statistics modules
Date: Tue, 26 Jun 2012 03:34:55 +0200
Message-Id: <1340674496-31953-2-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1340674496-31953-1-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1340674496-31953-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Use the existing omap3isp_subclk_enable() and omap3isp_subclk_disable()
functions instead.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/media/video/omap3isp/isp.c         |    4 +++-
 drivers/media/video/omap3isp/isp.h         |    9 +++++----
 drivers/media/video/omap3isp/isph3a_aewb.c |   10 ++--------
 drivers/media/video/omap3isp/isph3a_af.c   |   10 ++--------
 drivers/media/video/omap3isp/isphist.c     |    6 ++----
 5 files changed, 14 insertions(+), 25 deletions(-)

diff --git a/drivers/media/video/omap3isp/isp.c b/drivers/media/video/omap3isp/isp.c
index 1c34763..2e1f322 100644
--- a/drivers/media/video/omap3isp/isp.c
+++ b/drivers/media/video/omap3isp/isp.c
@@ -1281,7 +1281,9 @@ static void __isp_subclk_update(struct isp_device *isp)
 {
 	u32 clk = 0;
 
-	if (isp->subclk_resources & OMAP3_ISP_SUBCLK_H3A)
+	/* AEWB and AF share the same clock. */
+	if (isp->subclk_resources &
+	    (OMAP3_ISP_SUBCLK_AEWB | OMAP3_ISP_SUBCLK_AF))
 		clk |= ISPCTRL_H3A_CLK_EN;
 
 	if (isp->subclk_resources & OMAP3_ISP_SUBCLK_HIST)
diff --git a/drivers/media/video/omap3isp/isp.h b/drivers/media/video/omap3isp/isp.h
index fc7af3e..ba2159b 100644
--- a/drivers/media/video/omap3isp/isp.h
+++ b/drivers/media/video/omap3isp/isp.h
@@ -90,10 +90,11 @@ enum isp_sbl_resource {
 
 enum isp_subclk_resource {
 	OMAP3_ISP_SUBCLK_CCDC		= (1 << 0),
-	OMAP3_ISP_SUBCLK_H3A		= (1 << 1),
-	OMAP3_ISP_SUBCLK_HIST		= (1 << 2),
-	OMAP3_ISP_SUBCLK_PREVIEW	= (1 << 3),
-	OMAP3_ISP_SUBCLK_RESIZER	= (1 << 4),
+	OMAP3_ISP_SUBCLK_AEWB		= (1 << 1),
+	OMAP3_ISP_SUBCLK_AF		= (1 << 2),
+	OMAP3_ISP_SUBCLK_HIST		= (1 << 3),
+	OMAP3_ISP_SUBCLK_PREVIEW	= (1 << 4),
+	OMAP3_ISP_SUBCLK_RESIZER	= (1 << 5),
 };
 
 /* ISP: OMAP 34xx ES 1.0 */
diff --git a/drivers/media/video/omap3isp/isph3a_aewb.c b/drivers/media/video/omap3isp/isph3a_aewb.c
index a3c76bf..036e996 100644
--- a/drivers/media/video/omap3isp/isph3a_aewb.c
+++ b/drivers/media/video/omap3isp/isph3a_aewb.c
@@ -93,17 +93,11 @@ static void h3a_aewb_enable(struct ispstat *aewb, int enable)
 	if (enable) {
 		isp_reg_set(aewb->isp, OMAP3_ISP_IOMEM_H3A, ISPH3A_PCR,
 			    ISPH3A_PCR_AEW_EN);
-		/* This bit is already set if AF is enabled */
-		if (aewb->isp->isp_af.state != ISPSTAT_ENABLED)
-			isp_reg_set(aewb->isp, OMAP3_ISP_IOMEM_MAIN, ISP_CTRL,
-				    ISPCTRL_H3A_CLK_EN);
+		omap3isp_subclk_enable(aewb->isp, OMAP3_ISP_SUBCLK_AEWB);
 	} else {
 		isp_reg_clr(aewb->isp, OMAP3_ISP_IOMEM_H3A, ISPH3A_PCR,
 			    ISPH3A_PCR_AEW_EN);
-		/* This bit can't be cleared if AF is enabled */
-		if (aewb->isp->isp_af.state != ISPSTAT_ENABLED)
-			isp_reg_clr(aewb->isp, OMAP3_ISP_IOMEM_MAIN, ISP_CTRL,
-				    ISPCTRL_H3A_CLK_EN);
+		omap3isp_subclk_disable(aewb->isp, OMAP3_ISP_SUBCLK_AEWB);
 	}
 }
 
diff --git a/drivers/media/video/omap3isp/isph3a_af.c b/drivers/media/video/omap3isp/isph3a_af.c
index 58e0bc4..42ccce3 100644
--- a/drivers/media/video/omap3isp/isph3a_af.c
+++ b/drivers/media/video/omap3isp/isph3a_af.c
@@ -143,17 +143,11 @@ static void h3a_af_enable(struct ispstat *af, int enable)
 	if (enable) {
 		isp_reg_set(af->isp, OMAP3_ISP_IOMEM_H3A, ISPH3A_PCR,
 			    ISPH3A_PCR_AF_EN);
-		/* This bit is already set if AEWB is enabled */
-		if (af->isp->isp_aewb.state != ISPSTAT_ENABLED)
-			isp_reg_set(af->isp, OMAP3_ISP_IOMEM_MAIN, ISP_CTRL,
-				    ISPCTRL_H3A_CLK_EN);
+		omap3isp_subclk_enable(af->isp, OMAP3_ISP_SUBCLK_AF);
 	} else {
 		isp_reg_clr(af->isp, OMAP3_ISP_IOMEM_H3A, ISPH3A_PCR,
 			    ISPH3A_PCR_AF_EN);
-		/* This bit can't be cleared if AEWB is enabled */
-		if (af->isp->isp_aewb.state != ISPSTAT_ENABLED)
-			isp_reg_clr(af->isp, OMAP3_ISP_IOMEM_MAIN, ISP_CTRL,
-				    ISPCTRL_H3A_CLK_EN);
+		omap3isp_subclk_disable(af->isp, OMAP3_ISP_SUBCLK_AF);
 	}
 }
 
diff --git a/drivers/media/video/omap3isp/isphist.c b/drivers/media/video/omap3isp/isphist.c
index 1163907..d1a8dee 100644
--- a/drivers/media/video/omap3isp/isphist.c
+++ b/drivers/media/video/omap3isp/isphist.c
@@ -167,13 +167,11 @@ static void hist_enable(struct ispstat *hist, int enable)
 	if (enable) {
 		isp_reg_set(hist->isp, OMAP3_ISP_IOMEM_HIST, ISPHIST_PCR,
 			    ISPHIST_PCR_ENABLE);
-		isp_reg_set(hist->isp, OMAP3_ISP_IOMEM_MAIN, ISP_CTRL,
-			    ISPCTRL_HIST_CLK_EN);
+		omap3isp_subclk_enable(hist->isp, OMAP3_ISP_SUBCLK_HIST);
 	} else {
 		isp_reg_clr(hist->isp, OMAP3_ISP_IOMEM_HIST, ISPHIST_PCR,
 			    ISPHIST_PCR_ENABLE);
-		isp_reg_clr(hist->isp, OMAP3_ISP_IOMEM_MAIN, ISP_CTRL,
-			    ISPCTRL_HIST_CLK_EN);
+		omap3isp_subclk_disable(hist->isp, OMAP3_ISP_SUBCLK_HIST);
 	}
 }
 
-- 
1.7.3.4

