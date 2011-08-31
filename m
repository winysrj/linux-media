Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:48448 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756868Ab1HaQbi (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 31 Aug 2011 12:31:38 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: sakari.ailus@iki.fi, gary@mlbassoc.com
Subject: [HACK v2 4/4] omap3isp: ccdc: Add YUV input formats support
Date: Wed, 31 Aug 2011 18:32:02 +0200
Message-Id: <1314808322-30069-5-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1314808322-30069-1-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1314808322-30069-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/media/video/omap3isp/ispccdc.c  |   33 +++++++++++++++++++++++++++++-
 drivers/media/video/omap3isp/ispvideo.c |    6 +++++
 include/media/omap3isp.h                |    3 ++
 3 files changed, 40 insertions(+), 2 deletions(-)

diff --git a/drivers/media/video/omap3isp/ispccdc.c b/drivers/media/video/omap3isp/ispccdc.c
index 9efb703..3bc9b7d 100644
--- a/drivers/media/video/omap3isp/ispccdc.c
+++ b/drivers/media/video/omap3isp/ispccdc.c
@@ -57,6 +57,10 @@ static const unsigned int ccdc_fmts[] = {
 	V4L2_MBUS_FMT_SRGGB12_1X12,
 	V4L2_MBUS_FMT_SBGGR12_1X12,
 	V4L2_MBUS_FMT_SGBRG12_1X12,
+	V4L2_MBUS_FMT_YUYV8_1X16,
+	V4L2_MBUS_FMT_UYVY8_1X16,
+	V4L2_MBUS_FMT_YUYV8_2X8,
+	V4L2_MBUS_FMT_UYVY8_2X8,
 };
 
 /*
@@ -628,7 +632,7 @@ static void ccdc_configure_alaw(struct isp_ccdc_device *ccdc)
 
 	info = omap3isp_video_format_info(ccdc->formats[CCDC_PAD_SINK].code);
 
-	switch (info->bpp) {
+	switch (info->width) {
 	case 8:
 		return;
 
@@ -822,7 +826,7 @@ static void ccdc_config_vp(struct isp_ccdc_device *ccdc)
 
 	info = omap3isp_video_format_info(ccdc->formats[CCDC_PAD_SINK].code);
 
-	switch (info->bpp) {
+	switch (info->width) {
 	case 8:
 	case 10:
 		fmtcfg_vp |= ISPCCDC_FMTCFG_VPIN_9_0;
@@ -968,6 +972,7 @@ static void ccdc_config_sync_if(struct isp_ccdc_device *ccdc,
 				unsigned int data_size)
 {
 	struct isp_device *isp = to_isp_device(ccdc);
+	struct v4l2_mbus_framefmt *format;
 	u32 syn_mode = isp_reg_readl(isp, OMAP3_ISP_IOMEM_CCDC,
 				     ISPCCDC_SYN_MODE);
 
@@ -976,6 +981,16 @@ static void ccdc_config_sync_if(struct isp_ccdc_device *ccdc,
 		      ISPCCDC_SYN_MODE_FLDOUT | ISPCCDC_SYN_MODE_VDHDOUT);
 	syn_mode |= ISPCCDC_SYN_MODE_VDHDEN;
 
+	format = &ccdc->formats[CCDC_PAD_SINK];
+
+	syn_mode &= ~ISPCCDC_SYN_MODE_INPMOD_MASK;
+	if (format->code == V4L2_MBUS_FMT_YUYV8_2X8 ||
+	    format->code == V4L2_MBUS_FMT_UYVY8_2X8)
+		syn_mode |= ISPCCDC_SYN_MODE_INPMOD_YCBCR8;
+	else if (format->code == V4L2_MBUS_FMT_YUYV8_1X16 ||
+		 format->code == V4L2_MBUS_FMT_UYVY8_1X16)
+		syn_mode |= ISPCCDC_SYN_MODE_INPMOD_YCBCR16;
+
 	syn_mode &= ~ISPCCDC_SYN_MODE_DATSIZ_MASK;
 	switch (data_size) {
 	case 8:
@@ -1008,6 +1023,20 @@ static void ccdc_config_sync_if(struct isp_ccdc_device *ccdc,
 		syn_mode &= ~ISPCCDC_SYN_MODE_VDPOL;
 
 	isp_reg_writel(isp, syn_mode, OMAP3_ISP_IOMEM_CCDC, ISPCCDC_SYN_MODE);
+
+	if (format->code == V4L2_MBUS_FMT_UYVY8_2X8)
+		isp_reg_set(isp, OMAP3_ISP_IOMEM_CCDC, ISPCCDC_CFG,
+			    ISPCCDC_CFG_Y8POS);
+	else
+		isp_reg_clr(isp, OMAP3_ISP_IOMEM_CCDC, ISPCCDC_CFG,
+			    ISPCCDC_CFG_Y8POS);
+
+	if (pdata && pdata->bt656)
+		isp_reg_set(isp, OMAP3_ISP_IOMEM_CCDC, ISPCCDC_REC656IF,
+			    ISPCCDC_REC656IF_R656ON);
+	else
+		isp_reg_clr(isp, OMAP3_ISP_IOMEM_CCDC, ISPCCDC_REC656IF,
+			    ISPCCDC_REC656IF_R656ON);
 }
 
 /* CCDC formats descriptions */
diff --git a/drivers/media/video/omap3isp/ispvideo.c b/drivers/media/video/omap3isp/ispvideo.c
index 1fd15c8..f88b8af 100644
--- a/drivers/media/video/omap3isp/ispvideo.c
+++ b/drivers/media/video/omap3isp/ispvideo.c
@@ -100,6 +100,12 @@ static struct isp_format_info formats[] = {
 	{ V4L2_MBUS_FMT_YUYV8_1X16, V4L2_MBUS_FMT_YUYV8_1X16,
 	  V4L2_MBUS_FMT_YUYV8_1X16, 0,
 	  V4L2_PIX_FMT_YUYV, 16, 16, },
+	{ V4L2_MBUS_FMT_UYVY8_2X8, V4L2_MBUS_FMT_UYVY8_2X8,
+	  V4L2_MBUS_FMT_UYVY8_2X8, 0,
+	  V4L2_PIX_FMT_UYVY, 8, 16, },
+	{ V4L2_MBUS_FMT_YUYV8_2X8, V4L2_MBUS_FMT_YUYV8_2X8,
+	  V4L2_MBUS_FMT_YUYV8_2X8, 0,
+	  V4L2_PIX_FMT_YUYV, 8, 16, },
 };
 
 const struct isp_format_info *
diff --git a/include/media/omap3isp.h b/include/media/omap3isp.h
index 5291665..2cedd44 100644
--- a/include/media/omap3isp.h
+++ b/include/media/omap3isp.h
@@ -69,6 +69,8 @@ enum {
  *		ISP_BRIDGE_DISABLE - Disable
  *		ISP_BRIDGE_LITTLE_ENDIAN - Little endian
  *		ISP_BRIDGE_BIG_ENDIAN - Big endian
+ * @bt656: ITU-R BT656 embedded synchronization
+ *		0 - HS/VS sync, 1 - BT656 sync
  */
 struct isp_parallel_platform_data {
 	unsigned int data_lane_shift:2;
@@ -77,6 +79,7 @@ struct isp_parallel_platform_data {
 	unsigned int vs_pol:1;
 	unsigned int data_pol:1;
 	unsigned int bridge:2;
+	unsigned int bt656:1;
 };
 
 enum {
-- 
1.7.3.4

