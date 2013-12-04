Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:44098 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755832Ab3LDA42 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 3 Dec 2013 19:56:28 -0500
Received: from avalon.ideasonboard.com (unknown [91.177.177.98])
	by perceval.ideasonboard.com (Postfix) with ESMTPSA id D881B363E8
	for <linux-media@vger.kernel.org>; Wed,  4 Dec 2013 01:55:38 +0100 (CET)
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Subject: [PATCH 06/25] v4l: omap4iss: isif: Define more VDINT registers
Date: Wed,  4 Dec 2013 01:56:06 +0100
Message-Id: <1386118585-12449-7-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1386118585-12449-1-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1386118585-12449-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/staging/media/omap4iss/iss_ipipeif.c | 4 ++--
 drivers/staging/media/omap4iss/iss_regs.h    | 4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/media/omap4iss/iss_ipipeif.c b/drivers/staging/media/omap4iss/iss_ipipeif.c
index e96040f..5464742 100644
--- a/drivers/staging/media/omap4iss/iss_ipipeif.c
+++ b/drivers/staging/media/omap4iss/iss_ipipeif.c
@@ -67,7 +67,7 @@ static void ipipeif_print_status(struct iss_ipipeif_device *ipipeif)
 	ISIF_PRINT_REGISTER(iss, SPH);
 	ISIF_PRINT_REGISTER(iss, LNH);
 	ISIF_PRINT_REGISTER(iss, LNV);
-	ISIF_PRINT_REGISTER(iss, VDINT0);
+	ISIF_PRINT_REGISTER(iss, VDINT(0));
 	ISIF_PRINT_REGISTER(iss, HSIZE);
 
 	ISP5_PRINT_REGISTER(iss, SYSCONFIG);
@@ -213,7 +213,7 @@ cont_raw:
 
 	/* Generate ISIF0 on the last line of the image */
 	writel(format->height - 1,
-		iss->regs[OMAP4_ISS_MEM_ISP_ISIF] + ISIF_VDINT0);
+		iss->regs[OMAP4_ISS_MEM_ISP_ISIF] + ISIF_VDINT(0));
 
 	/* IPIPEIF_PAD_SOURCE_ISIF_SF */
 	format = &ipipeif->formats[IPIPEIF_PAD_SOURCE_ISIF_SF];
diff --git a/drivers/staging/media/omap4iss/iss_regs.h b/drivers/staging/media/omap4iss/iss_regs.h
index 16975ca..d969351 100644
--- a/drivers/staging/media/omap4iss/iss_regs.h
+++ b/drivers/staging/media/omap4iss/iss_regs.h
@@ -363,8 +363,8 @@
 #define ISIF_CCOLP_CP3_F0_B				(3 << 0)
 #define ISIF_CCOLP_CP3_F0_GB				(2 << 0)
 
-#define ISIF_VDINT0					(0x0070)
-#define ISIF_VDINT0_MASK				(0x7FFF)
+#define ISIF_VDINT(i)					(0x0070 + (i) * 4)
+#define ISIF_VDINT_MASK					(0x7fff)
 
 #define ISIF_CGAMMAWD					(0x0080)
 #define ISIF_CGAMMAWD_GWDI_MASK				(0xF << 1)
-- 
1.8.3.2

