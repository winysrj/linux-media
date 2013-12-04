Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:44098 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755846Ab3LDA4b (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 3 Dec 2013 19:56:31 -0500
Received: from avalon.ideasonboard.com (unknown [91.177.177.98])
	by perceval.ideasonboard.com (Postfix) with ESMTPSA id A7E6335A6D
	for <linux-media@vger.kernel.org>; Wed,  4 Dec 2013 01:55:39 +0100 (CET)
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Subject: [PATCH 11/25] v4l: omap4iss: ipipeif: Shift input data according to the input format
Date: Wed,  4 Dec 2013 01:56:11 +0100
Message-Id: <1386118585-12449-12-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1386118585-12449-1-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1386118585-12449-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Input samples must be left-aligned on the ISIF 16-bit data bus.
Configure the 16-to-16-bit selector to shift data according to the input
format.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/staging/media/omap4iss/iss_ipipeif.c | 4 +++-
 drivers/staging/media/omap4iss/iss_regs.h    | 2 +-
 2 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/media/omap4iss/iss_ipipeif.c b/drivers/staging/media/omap4iss/iss_ipipeif.c
index 47fb1d6..2853851 100644
--- a/drivers/staging/media/omap4iss/iss_ipipeif.c
+++ b/drivers/staging/media/omap4iss/iss_ipipeif.c
@@ -129,6 +129,7 @@ static void ipipeif_set_outaddr(struct iss_ipipeif_device *ipipeif, u32 addr)
 static void ipipeif_configure(struct iss_ipipeif_device *ipipeif)
 {
 	struct iss_device *iss = to_iss_device(ipipeif);
+	const struct iss_format_info *info;
 	struct v4l2_mbus_framefmt *format;
 	u32 isif_ccolp = 0;
 
@@ -194,9 +195,10 @@ cont_raw:
 			ISIF_MODESET_INPMOD_RAW | ISIF_MODESET_CCDW_2BIT,
 			iss->regs[OMAP4_ISS_MEM_ISP_ISIF] + ISIF_MODESET);
 
+		info = omap4iss_video_format_info(format->code);
 		writel((readl(iss->regs[OMAP4_ISS_MEM_ISP_ISIF] + ISIF_CGAMMAWD) &
 			~ISIF_CGAMMAWD_GWDI_MASK) |
-			ISIF_CGAMMAWD_GWDI_BIT11,
+			ISIF_CGAMMAWD_GWDI(info->bpp),
 			iss->regs[OMAP4_ISS_MEM_ISP_ISIF] + ISIF_CGAMMAWD);
 
 		/* Set RAW Bayer pattern */
diff --git a/drivers/staging/media/omap4iss/iss_regs.h b/drivers/staging/media/omap4iss/iss_regs.h
index d969351..5995e62 100644
--- a/drivers/staging/media/omap4iss/iss_regs.h
+++ b/drivers/staging/media/omap4iss/iss_regs.h
@@ -368,7 +368,7 @@
 
 #define ISIF_CGAMMAWD					(0x0080)
 #define ISIF_CGAMMAWD_GWDI_MASK				(0xF << 1)
-#define ISIF_CGAMMAWD_GWDI_BIT11			(0x4 << 1)
+#define ISIF_CGAMMAWD_GWDI(bpp)				((16 - (bpp)) << 1)
 
 #define ISIF_CCDCFG					(0x0088)
 #define ISIF_CCDCFG_Y8POS				(1 << 11)
-- 
1.8.3.2

