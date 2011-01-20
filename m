Return-path: <mchehab@pedra>
Received: from moutng.kundenserver.de ([212.227.17.10]:59528 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755869Ab1ATXnu (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 20 Jan 2011 18:43:50 -0500
From: Martin Hostettler <martin@neutronstar.dyndns.org>
To: linux-media@vger.kernel.org,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Martin Hostettler <martin@neutronstar.dyndns.org>
Subject: [PATCH V3] v4l: OMAP3 ISP CCDC: Add support for 8bit greyscale sensors
Date: Fri, 21 Jan 2011 00:43:31 +0100
Message-Id: <1295567011-6395-1-git-send-email-martin@neutronstar.dyndns.org>
In-Reply-To: <20110120230246.GE13173@neutronstar.dyndns.org>
References: <20110120230246.GE13173@neutronstar.dyndns.org>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Adds support for V4L2_MBUS_FMT_Y8_1X8 format and 8bit data width in
synchronous interface.

When using V4L2_MBUS_FMT_Y8_1X8 (or possibly another 8bit per pixel) mode
set the CDCC to output 8bit per pixel instead of 16bit.

Signed-off-by: Martin Hostettler <martin@neutronstar.dyndns.org>
---
 drivers/media/video/isp/ispccdc.c  |   15 ++++++++++++---
 drivers/media/video/isp/ispvideo.c |    2 ++
 2 files changed, 14 insertions(+), 3 deletions(-)

Changes since first version:
	- forward ported to current media.git
Changes since second version:
	- remove ccdc->clamp.dcsubval related changes

diff --git a/drivers/media/video/isp/ispccdc.c b/drivers/media/video/isp/ispccdc.c
index 578c8bf..7632bc1 100644
--- a/drivers/media/video/isp/ispccdc.c
+++ b/drivers/media/video/isp/ispccdc.c
@@ -43,6 +43,7 @@ __ccdc_get_format(struct isp_ccdc_device *ccdc, struct v4l2_subdev_fh *fh,
 		  unsigned int pad, enum v4l2_subdev_format_whence which);
 
 static const unsigned int ccdc_fmts[] = {
+	V4L2_MBUS_FMT_Y8_1X8,
 	V4L2_MBUS_FMT_SGRBG10_1X10,
 	V4L2_MBUS_FMT_SRGGB10_1X10,
 	V4L2_MBUS_FMT_SBGGR10_1X10,
@@ -1127,6 +1128,9 @@ static void ccdc_configure(struct isp_ccdc_device *ccdc)
 	ccdc->syncif.datsz = pdata ? pdata->width : 10;
 	ispccdc_config_sync_if(ccdc, &ccdc->syncif);
 
+	/* CCDC_PAD_SINK */
+	format = &ccdc->formats[CCDC_PAD_SINK];
+
 	syn_mode = isp_reg_readl(isp, OMAP3_ISP_IOMEM_CCDC, ISPCCDC_SYN_MODE);
 
 	/* Use the raw, unprocessed data when writing to memory. The H3A and
@@ -1144,10 +1148,15 @@ static void ccdc_configure(struct isp_ccdc_device *ccdc)
 	else
 		syn_mode &= ~ISPCCDC_SYN_MODE_SDR2RSZ;
 
-	isp_reg_writel(isp, syn_mode, OMAP3_ISP_IOMEM_CCDC, ISPCCDC_SYN_MODE);
+	/* Use PACK8 mode for 1byte per pixel formats */
 
-	/* CCDC_PAD_SINK */
-	format = &ccdc->formats[CCDC_PAD_SINK];
+	if (isp_video_format_info(format->code)->bpp <= 8)
+		syn_mode |= ISPCCDC_SYN_MODE_PACK8;
+	else
+		syn_mode &= ~ISPCCDC_SYN_MODE_PACK8;
+
+
+	isp_reg_writel(isp, syn_mode, OMAP3_ISP_IOMEM_CCDC, ISPCCDC_SYN_MODE);
 
 	/* Mosaic filter */
 	switch (format->code) {
diff --git a/drivers/media/video/isp/ispvideo.c b/drivers/media/video/isp/ispvideo.c
index 5f984e4..cd3d331 100644
--- a/drivers/media/video/isp/ispvideo.c
+++ b/drivers/media/video/isp/ispvideo.c
@@ -221,6 +221,8 @@ isp_video_check_format(struct isp_video *video, struct isp_video_fh *vfh)
 }
 
 static struct isp_format_info formats[] = {
+	{ V4L2_MBUS_FMT_Y8_1X8, V4L2_MBUS_FMT_Y8_1X8,
+	  V4L2_MBUS_FMT_Y8_1X8, V4L2_PIX_FMT_GREY, 8, },
 	{ V4L2_MBUS_FMT_SGRBG10_DPCM8_1X8, V4L2_MBUS_FMT_SGRBG10_DPCM8_1X8,
 	  V4L2_MBUS_FMT_SGRBG10_1X10, V4L2_PIX_FMT_SGRBG10DPCM8, 8, },
 	{ V4L2_MBUS_FMT_SBGGR10_1X10, V4L2_MBUS_FMT_SBGGR10_1X10,
-- 
1.7.1

