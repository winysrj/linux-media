Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:48329 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751488Ab3KDAG0 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 3 Nov 2013 19:06:26 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: Sergio Aguirre <sergio.a.aguirre@gmail.com>,
	Sakari Ailus <sakari.ailus@iki.fi>
Subject: [PATCH v2 08/18] v4l: omap4iss: Move common code out of switch...case
Date: Mon,  4 Nov 2013 01:06:33 +0100
Message-Id: <1383523603-3907-9-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1383523603-3907-1-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1383523603-3907-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Code common to all cases can be moved out of the switch...case
statement.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/staging/media/omap4iss/iss.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/media/omap4iss/iss.c b/drivers/staging/media/omap4iss/iss.c
index 1a5cac9..243fcb8 100644
--- a/drivers/staging/media/omap4iss/iss.c
+++ b/drivers/staging/media/omap4iss/iss.c
@@ -178,12 +178,10 @@ void omap4iss_configure_bridge(struct iss_device *iss,
 	switch (input) {
 	case IPIPEIF_INPUT_CSI2A:
 		issctrl_val |= ISS_CTRL_INPUT_SEL_CSI2A;
-		isp5ctrl_val |= ISP5_CTRL_VD_PULSE_EXT;
 		break;
 
 	case IPIPEIF_INPUT_CSI2B:
 		issctrl_val |= ISS_CTRL_INPUT_SEL_CSI2B;
-		isp5ctrl_val |= ISP5_CTRL_VD_PULSE_EXT;
 		break;
 
 	default:
@@ -192,7 +190,8 @@ void omap4iss_configure_bridge(struct iss_device *iss,
 
 	issctrl_val |= ISS_CTRL_SYNC_DETECT_VS_RAISING;
 
-	isp5ctrl_val |= ISP5_CTRL_PSYNC_CLK_SEL | ISP5_CTRL_SYNC_ENABLE;
+	isp5ctrl_val |= ISP5_CTRL_VD_PULSE_EXT | ISP5_CTRL_PSYNC_CLK_SEL |
+			ISP5_CTRL_SYNC_ENABLE;
 
 	writel(issctrl_val, iss->regs[OMAP4_ISS_MEM_TOP] + ISS_CTRL);
 	writel(isp5ctrl_val, iss->regs[OMAP4_ISS_MEM_ISP_SYS1] + ISP5_CTRL);
-- 
1.8.1.5

