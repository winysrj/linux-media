Return-path: <mchehab@pedra>
Received: from arroyo.ext.ti.com ([192.94.94.40]:49844 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755400Ab0KLVSf (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 12 Nov 2010 16:18:35 -0500
From: Sergio Aguirre <saaguirre@ti.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: linux-media@vger.kernel.org, Sergio Aguirre <saaguirre@ti.com>
Subject: [omap3isp RFC][PATCH 02/10] omap3isp: ccdc: Write SYN_MODE.INPMOD based on fmt
Date: Fri, 12 Nov 2010 15:18:05 -0600
Message-Id: <1289596693-27660-3-git-send-email-saaguirre@ti.com>
In-Reply-To: <1289596693-27660-1-git-send-email-saaguirre@ti.com>
References: <1289596693-27660-1-git-send-email-saaguirre@ti.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

This takes into account the input format to select the
adequate configuration for SYNC mode.

Also, change bitmask ISPCCDC_SYN_MODE_INPMOD_MASK to be
more consistent with other bitmasks.

Signed-off-by: Sergio Aguirre <saaguirre@ti.com>
---
 drivers/media/video/isp/ispccdc.c |   12 +++++++++---
 1 files changed, 9 insertions(+), 3 deletions(-)

diff --git a/drivers/media/video/isp/ispccdc.c b/drivers/media/video/isp/ispccdc.c
index bee2bbe..c3d1d7a 100644
--- a/drivers/media/video/isp/ispccdc.c
+++ b/drivers/media/video/isp/ispccdc.c
@@ -1071,6 +1071,9 @@ static void ccdc_configure(struct isp_ccdc_device *ccdc)
 	isp_configure_bridge(isp, ccdc->input, pdata);
 	ispccdc_config_sync_if(ccdc, &ccdc->syncif);
 
+	/* CCDC_PAD_SINK */
+	format = &ccdc->formats[CCDC_PAD_SINK];
+
 	syn_mode = isp_reg_readl(isp, OMAP3_ISP_IOMEM_CCDC, ISPCCDC_SYN_MODE);
 
 	/* Use the raw, unprocessed data when writing to memory. The H3A and
@@ -1088,10 +1091,13 @@ static void ccdc_configure(struct isp_ccdc_device *ccdc)
 	else
 		syn_mode &= ~ISPCCDC_SYN_MODE_SDR2RSZ;
 
-	isp_reg_writel(isp, syn_mode, OMAP3_ISP_IOMEM_CCDC, ISPCCDC_SYN_MODE);
+	if ((format->code == V4L2_MBUS_FMT_YUYV8_1X16) ||
+	    (format->code == V4L2_MBUS_FMT_UYVY8_1X16))
+		syn_mode |= ISPCCDC_SYN_MODE_INPMOD_YCBCR16;
+	else
+		syn_mode &= ~ISPCCDC_SYN_MODE_INPMOD_MASK;
 
-	/* CCDC_PAD_SINK */
-	format = &ccdc->formats[CCDC_PAD_SINK];
+	isp_reg_writel(isp, syn_mode, OMAP3_ISP_IOMEM_CCDC, ISPCCDC_SYN_MODE);
 
 	/* Mosaic filter */
 	switch (format->code) {
-- 
1.7.0.4

