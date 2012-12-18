Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pa0-f53.google.com ([209.85.220.53]:39780 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752691Ab2LRCTA (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 17 Dec 2012 21:19:00 -0500
Received: by mail-pa0-f53.google.com with SMTP id hz1so157842pad.26
        for <linux-media@vger.kernel.org>; Mon, 17 Dec 2012 18:19:00 -0800 (PST)
From: William Swanson <swansontec@gmail.com>
To: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Cc: William Swanson <william.swanson@fuel7.com>
Subject: [PATCH] omap3isp: Add support for interlaced input data
Date: Mon, 17 Dec 2012 18:12:19 -0800
Message-Id: <1355796739-2580-1-git-send-email-william.swanson@fuel7.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

If the remote video sensor reports an interlaced video mode, the CCDC block
should configure itself appropriately.
---
 drivers/media/platform/omap3isp/ispccdc.c |   16 ++++++++++++++--
 include/media/omap3isp.h                  |    3 +++
 2 files changed, 17 insertions(+), 2 deletions(-)

diff --git a/drivers/media/platform/omap3isp/ispccdc.c b/drivers/media/platform/omap3isp/ispccdc.c
index 60e60aa..5443ef4 100644
--- a/drivers/media/platform/omap3isp/ispccdc.c
+++ b/drivers/media/platform/omap3isp/ispccdc.c
@@ -970,10 +970,11 @@ void omap3isp_ccdc_max_rate(struct isp_ccdc_device *ccdc,
  * @ccdc: Pointer to ISP CCDC device.
  * @pdata: Parallel interface platform data (may be NULL)
  * @data_size: Data size
+ * @interlaced: Use interlaced mode instead of progressive mode
  */
 static void ccdc_config_sync_if(struct isp_ccdc_device *ccdc,
 				struct isp_parallel_platform_data *pdata,
-				unsigned int data_size)
+				unsigned int data_size, bool interlaced)
 {
 	struct isp_device *isp = to_isp_device(ccdc);
 	const struct v4l2_mbus_framefmt *format;
@@ -1004,9 +1005,15 @@ static void ccdc_config_sync_if(struct isp_ccdc_device *ccdc,
 		break;
 	}
 
+	if (interlaced)
+		syn_mode |= ISPCCDC_SYN_MODE_FLDMODE;
+
 	if (pdata && pdata->data_pol)
 		syn_mode |= ISPCCDC_SYN_MODE_DATAPOL;
 
+	if (pdata && pdata->fld_pol)
+		syn_mode |= ISPCCDC_SYN_MODE_FLDPOL;
+
 	if (pdata && pdata->hs_pol)
 		syn_mode |= ISPCCDC_SYN_MODE_HDPOL;
 
@@ -1111,6 +1118,7 @@ static void ccdc_configure(struct isp_ccdc_device *ccdc)
 	const struct v4l2_rect *crop;
 	const struct isp_format_info *fmt_info;
 	struct v4l2_subdev_format fmt_src;
+	bool src_interlaced = false;
 	unsigned int depth_out;
 	unsigned int depth_in = 0;
 	struct media_pad *pad;
@@ -1132,6 +1140,10 @@ static void ccdc_configure(struct isp_ccdc_device *ccdc)
 	fmt_src.pad = pad->index;
 	fmt_src.which = V4L2_SUBDEV_FORMAT_ACTIVE;
 	if (!v4l2_subdev_call(sensor, pad, get_fmt, NULL, &fmt_src)) {
+		if (fmt_src.format.field == V4L2_FIELD_INTERLACED ||
+		    fmt_src.format.field == V4L2_FIELD_INTERLACED_TB ||
+		    fmt_src.format.field == V4L2_FIELD_INTERLACED_BT)
+			src_interlaced = true;
 		fmt_info = omap3isp_video_format_info(fmt_src.format.code);
 		depth_in = fmt_info->width;
 	}
@@ -1150,7 +1162,7 @@ static void ccdc_configure(struct isp_ccdc_device *ccdc)
 
 	omap3isp_configure_bridge(isp, ccdc->input, pdata, shift, bridge);
 
-	ccdc_config_sync_if(ccdc, pdata, depth_out);
+	ccdc_config_sync_if(ccdc, pdata, depth_out, src_interlaced);
 
 	syn_mode = isp_reg_readl(isp, OMAP3_ISP_IOMEM_CCDC, ISPCCDC_SYN_MODE);
 
diff --git a/include/media/omap3isp.h b/include/media/omap3isp.h
index 9584269..32d85c2 100644
--- a/include/media/omap3isp.h
+++ b/include/media/omap3isp.h
@@ -57,6 +57,8 @@ enum {
  *		ISP_LANE_SHIFT_6 - CAMEXT[13:6] -> CAM[7:0]
  * @clk_pol: Pixel clock polarity
  *		0 - Sample on rising edge, 1 - Sample on falling edge
+ * @fld_pol: Field identification signal polarity
+ *		0 - Active high, 1 - Active low
  * @hs_pol: Horizontal synchronization polarity
  *		0 - Active high, 1 - Active low
  * @vs_pol: Vertical synchronization polarity
@@ -67,6 +69,7 @@ enum {
 struct isp_parallel_platform_data {
 	unsigned int data_lane_shift:2;
 	unsigned int clk_pol:1;
+	unsigned int fld_pol:1;
 	unsigned int hs_pol:1;
 	unsigned int vs_pol:1;
 	unsigned int data_pol:1;
-- 
1.7.9.5

