Return-path: <mchehab@pedra>
Received: from bear.ext.ti.com ([192.94.94.41]:60870 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756897Ab0KOOaC (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 15 Nov 2010 09:30:02 -0500
From: Sergio Aguirre <saaguirre@ti.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: linux-media@vger.kernel.org, Sergio Aguirre <saaguirre@ti.com>
Subject: [omap3isp][PATCH v2 1/9] omap3isp: ccdc: Add support for YUV format
Date: Mon, 15 Nov 2010 08:29:53 -0600
Message-Id: <1289831401-593-2-git-send-email-saaguirre@ti.com>
In-Reply-To: <1289831401-593-1-git-send-email-saaguirre@ti.com>
References: <1289831401-593-1-git-send-email-saaguirre@ti.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

We were just supporting RAW10 formats, and we really support more
options.

Strictly speaking, CCDC needs at least to distinguish between RAW
and YUV formats for proper configuration.

Signed-off-by: Sergio Aguirre <saaguirre@ti.com>
---
 drivers/media/video/isp/ispccdc.c |   14 +++++++++++---
 1 files changed, 11 insertions(+), 3 deletions(-)

diff --git a/drivers/media/video/isp/ispccdc.c b/drivers/media/video/isp/ispccdc.c
index be4581e..c3d1d7a 100644
--- a/drivers/media/video/isp/ispccdc.c
+++ b/drivers/media/video/isp/ispccdc.c
@@ -45,6 +45,8 @@ static const unsigned int ccdc_fmts[] = {
 	V4L2_MBUS_FMT_SRGGB10_1X10,
 	V4L2_MBUS_FMT_SBGGR10_1X10,
 	V4L2_MBUS_FMT_SGBRG10_1X10,
+	V4L2_MBUS_FMT_YUYV8_1X16,
+	V4L2_MBUS_FMT_UYVY8_1X16,
 };
 
 /*
@@ -1069,6 +1071,9 @@ static void ccdc_configure(struct isp_ccdc_device *ccdc)
 	isp_configure_bridge(isp, ccdc->input, pdata);
 	ispccdc_config_sync_if(ccdc, &ccdc->syncif);
 
+	/* CCDC_PAD_SINK */
+	format = &ccdc->formats[CCDC_PAD_SINK];
+
 	syn_mode = isp_reg_readl(isp, OMAP3_ISP_IOMEM_CCDC, ISPCCDC_SYN_MODE);
 
 	/* Use the raw, unprocessed data when writing to memory. The H3A and
@@ -1086,10 +1091,13 @@ static void ccdc_configure(struct isp_ccdc_device *ccdc)
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

