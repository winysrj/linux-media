Return-path: <mchehab@gaivota>
Received: from moutng.kundenserver.de ([212.227.126.171]:53195 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752752Ab0LNOn6 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 14 Dec 2010 09:43:58 -0500
From: Martin Hostettler <martin@neutronstar.dyndns.org>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	linux-media@vger.kernel.org
Cc: Martin Hostettler <martin@neutronstar.dyndns.org>
Subject: [PATCH] v4l: OMAP3 ISP CCDC: Add support for 8bit greyscale sensors
Date: Tue, 14 Dec 2010 15:43:43 +0100
Message-Id: <1292337823-15994-1-git-send-email-martin@neutronstar.dyndns.org>
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

Adds support for V4L2_MBUS_FMT_Y8_1X8 format and 8bit data width in
syncronous interface.

The data width is configured in the parallel interface part of the isp platform
data, defaulting to 10bit as before this commit. When i 8bit mode don't apply
DC substraction of 64 per default as this would remove 1/4 of the sensor range.

When using V4L2_MBUS_FMT_Y8_1X8 (or possibly another 8bit per pixel) mode
set the CDCC to output 8bit per pixel instead of 16bit.

Signed-off-by: Martin Hostettler <martin@neutronstar.dyndns.org>
---
 drivers/media/video/isp/isp.h      |    2 ++
 drivers/media/video/isp/ispccdc.c  |   21 ++++++++++++++++-----
 drivers/media/video/isp/ispvideo.c |    7 +++++++
 3 files changed, 25 insertions(+), 5 deletions(-)

diff --git a/drivers/media/video/isp/isp.h b/drivers/media/video/isp/isp.h
index edc029c..76c09ed 100644
--- a/drivers/media/video/isp/isp.h
+++ b/drivers/media/video/isp/isp.h
@@ -132,11 +132,13 @@ struct isp_reg {
  *		ISPCTRL_PAR_BRIDGE_DISABLE - Disable
  *		ISPCTRL_PAR_BRIDGE_LENDIAN - Little endian
  *		ISPCTRL_PAR_BRIDGE_BENDIAN - Big endian
+ * @datsz: Width of the data-bus in bits (8, 10, 11, 12, 13) or 0 for default (10bit)
  */
 struct isp_parallel_platform_data {
 	unsigned int data_lane_shift:2;
 	unsigned int clk_pol:1;
 	unsigned int bridge:4;
+	unsigned int data_bus_width;
 };
 
 /**
diff --git a/drivers/media/video/isp/ispccdc.c b/drivers/media/video/isp/ispccdc.c
index be4581e..bff217a 100644
--- a/drivers/media/video/isp/ispccdc.c
+++ b/drivers/media/video/isp/ispccdc.c
@@ -45,6 +45,7 @@ static const unsigned int ccdc_fmts[] = {
 	V4L2_MBUS_FMT_SRGGB10_1X10,
 	V4L2_MBUS_FMT_SBGGR10_1X10,
 	V4L2_MBUS_FMT_SGBRG10_1X10,
+	V4L2_MBUS_FMT_Y8_1X8,
 };
 
 /*
@@ -1069,6 +1070,10 @@ static void ccdc_configure(struct isp_ccdc_device *ccdc)
 	isp_configure_bridge(isp, ccdc->input, pdata);
 	ispccdc_config_sync_if(ccdc, &ccdc->syncif);
 
+	/* CCDC_PAD_SINK */
+	format = &ccdc->formats[CCDC_PAD_SINK];
+	isp_video_mbus_to_pix(&ccdc->video_out, format, &pix);
+
 	syn_mode = isp_reg_readl(isp, OMAP3_ISP_IOMEM_CCDC, ISPCCDC_SYN_MODE);
 
 	/* Use the raw, unprocessed data when writing to memory. The H3A and
@@ -1086,10 +1091,14 @@ static void ccdc_configure(struct isp_ccdc_device *ccdc)
 	else
 		syn_mode &= ~ISPCCDC_SYN_MODE_SDR2RSZ;
 
-	isp_reg_writel(isp, syn_mode, OMAP3_ISP_IOMEM_CCDC, ISPCCDC_SYN_MODE);
+	/* Use PACK8 mode for 1byte per pixel formats */
+	if (pix.bytesperline < format->width * 2)
+		syn_mode |= ISPCCDC_SYN_MODE_PACK8;
+	else
+		syn_mode &= ~ISPCCDC_SYN_MODE_PACK8;
 
-	/* CCDC_PAD_SINK */
-	format = &ccdc->formats[CCDC_PAD_SINK];
+
+	isp_reg_writel(isp, syn_mode, OMAP3_ISP_IOMEM_CCDC, ISPCCDC_SYN_MODE);
 
 	/* Mosaic filter */
 	switch (format->code) {
@@ -1128,7 +1137,6 @@ static void ccdc_configure(struct isp_ccdc_device *ccdc)
 			<< ISPCCDC_VERT_LINES_NLV_SHIFT,
 		       OMAP3_ISP_IOMEM_CCDC, ISPCCDC_VERT_LINES);
 
-	isp_video_mbus_to_pix(&ccdc->video_out, format, &pix);
 	ispccdc_config_outlineoffset(ccdc, pix.bytesperline, 0, 0);
 
 	/* CCDC_PAD_SOURCE_VP */
@@ -2164,6 +2172,9 @@ int isp_ccdc_init(struct isp_device *isp)
 	ccdc->syncif.ccdc_mastermode = 0;
 	ccdc->syncif.datapol = 0;
 	ccdc->syncif.datsz = 10;
+	if (isp->pdata->subdevs->interface == ISP_INTERFACE_PARALLEL
+	    && isp->pdata->subdevs->bus.parallel.data_bus_width != 0)
+		ccdc->syncif.datsz = isp->pdata->subdevs->bus.parallel.data_bus_width;
 	ccdc->syncif.fldmode = 0;
 	ccdc->syncif.fldout = 0;
 	ccdc->syncif.fldpol = 0;
@@ -2172,7 +2183,7 @@ int isp_ccdc_init(struct isp_device *isp)
 	ccdc->syncif.vdpol = 0;
 
 	ccdc->clamp.oblen = 0;
-	ccdc->clamp.dcsubval = 64;
+	ccdc->clamp.dcsubval = (ccdc->syncif.datsz == 8) ? 0 : 64;
 
 	ccdc->vpcfg.pixelclk = 0;
 
diff --git a/drivers/media/video/isp/ispvideo.c b/drivers/media/video/isp/ispvideo.c
index 64068ff..35e8c72 100644
--- a/drivers/media/video/isp/ispvideo.c
+++ b/drivers/media/video/isp/ispvideo.c
@@ -228,6 +228,10 @@ void isp_video_mbus_to_pix(const struct isp_video *video,
 		pix->pixelformat = V4L2_PIX_FMT_YUYV;
 		pix->bytesperline = pix->width * 2;
 		break;
+	case V4L2_MBUS_FMT_Y8_1X8:
+		pix->pixelformat = V4L2_PIX_FMT_GREY;
+		pix->bytesperline = pix->width;
+		break;
 	case V4L2_MBUS_FMT_UYVY8_1X16:
 	default:
 		pix->pixelformat = V4L2_PIX_FMT_UYVY;
@@ -261,6 +265,9 @@ void isp_video_pix_to_mbus(const struct v4l2_pix_format *pix,
 	case V4L2_PIX_FMT_YUYV:
 		mbus->code = V4L2_MBUS_FMT_YUYV8_1X16;
 		break;
+	case V4L2_PIX_FMT_GREY:
+		mbus->code = V4L2_MBUS_FMT_Y8_1X8;
+		break;
 	case V4L2_PIX_FMT_UYVY:
 	default:
 		mbus->code = V4L2_MBUS_FMT_UYVY8_1X16;
-- 
1.7.1

