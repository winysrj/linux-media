Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.fuel7.com ([74.222.0.51]:34059 "EHLO mail.fuel7.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758497Ab3ANWYg (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 14 Jan 2013 17:24:36 -0500
From: William Swanson <william.swanson@fuel7.com>
To: linux-media@vger.kernel.org
Cc: William Swanson <william.swanson@fuel7.com>
Subject: [PATCH] omap3isp: Add support for interlaced input data
Date: Mon, 14 Jan 2013 14:23:56 -0800
Message-Id: <1358202236-13327-1-git-send-email-william.swanson@fuel7.com>
In-Reply-To: <50F484E9.9060103@fuel7.com>
References: <50F484E9.9060103@fuel7.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

If the remote video sensor reports an interlaced video mode, the CCDC block
should configure itself appropriately.

This patch reintroduces code with was removed in commit
cf7a3d91ade6c56bfd860b377f84bd58132f7a81, but in a way that is compatible
with the new media pipeline work.

This patch also cleans up the ccdc_config_outlineoffset function, which was
exposing too may low-level configuration bits. The only useful register
settings correspond to deinterlacing the video and flipping the image
vertically. Vertical flipping isn't used, so the function simply exposes
a boolean flag to enable deinterlacing. A flag for vertical flipping could
be added later.

Signed-off-by: William Swanson <william.swanson@fuel7.com>
---
 drivers/media/platform/omap3isp/ispccdc.c |   57 +++++++++++++++--------------
 drivers/media/platform/omap3isp/ispreg.h  |    4 --
 include/media/omap3isp.h                  |    3 ++
 3 files changed, 32 insertions(+), 32 deletions(-)

diff --git a/drivers/media/platform/omap3isp/ispccdc.c b/drivers/media/platform/omap3isp/ispccdc.c
index 60e60aa..7b795e6e 100644
--- a/drivers/media/platform/omap3isp/ispccdc.c
+++ b/drivers/media/platform/omap3isp/ispccdc.c
@@ -876,19 +876,15 @@ static void ccdc_enable_vp(struct isp_ccdc_device *ccdc, u8 enable)
  * ccdc_config_outlineoffset - Configure memory saving output line offset
  * @ccdc: Pointer to ISP CCDC device.
  * @offset: Address offset to start a new line. Must be twice the
- *          Output width and aligned on 32 byte boundary
- * @oddeven: Specifies the odd/even line pattern to be chosen to store the
- *           output.
- * @numlines: Set the value 0-3 for +1-4lines, 4-7 for -1-4lines.
+ *          output width and aligned on 32 byte boundary
+ * @interlaced: Write alternate frames to memory with an even/odd pattern.
  *
  * - Configures the output line offset when stored in memory
- * - Sets the odd/even line pattern to store the output
- *    (EVENEVEN (1), ODDEVEN (2), EVENODD (3), ODDODD (4))
  * - Configures the number of even and odd line fields in case of rearranging
  * the lines.
  */
 static void ccdc_config_outlineoffset(struct isp_ccdc_device *ccdc,
-					u32 offset, u8 oddeven, u8 numlines)
+					u32 offset, bool interlaced)
 {
 	struct isp_device *isp = to_isp_device(ccdc);
 
@@ -901,25 +897,18 @@ static void ccdc_config_outlineoffset(struct isp_ccdc_device *ccdc,
 	isp_reg_clr(isp, OMAP3_ISP_IOMEM_CCDC, ISPCCDC_SDOFST,
 		    ISPCCDC_SDOFST_FOFST_4L);
 
-	switch (oddeven) {
-	case EVENEVEN:
+	if (interlaced) {
 		isp_reg_set(isp, OMAP3_ISP_IOMEM_CCDC, ISPCCDC_SDOFST,
-			    (numlines & 0x7) << ISPCCDC_SDOFST_LOFST0_SHIFT);
-		break;
-	case ODDEVEN:
-		isp_reg_set(isp, OMAP3_ISP_IOMEM_CCDC, ISPCCDC_SDOFST,
-			    (numlines & 0x7) << ISPCCDC_SDOFST_LOFST1_SHIFT);
-		break;
-	case EVENODD:
-		isp_reg_set(isp, OMAP3_ISP_IOMEM_CCDC, ISPCCDC_SDOFST,
-			    (numlines & 0x7) << ISPCCDC_SDOFST_LOFST2_SHIFT);
-		break;
-	case ODDODD:
-		isp_reg_set(isp, OMAP3_ISP_IOMEM_CCDC, ISPCCDC_SDOFST,
-			    (numlines & 0x7) << ISPCCDC_SDOFST_LOFST3_SHIFT);
-		break;
-	default:
-		break;
+			    1 << ISPCCDC_SDOFST_LOFST0_SHIFT |
+			    1 << ISPCCDC_SDOFST_LOFST1_SHIFT |
+			    1 << ISPCCDC_SDOFST_LOFST2_SHIFT |
+			    1 << ISPCCDC_SDOFST_LOFST3_SHIFT );
+	} else {
+		isp_reg_clr(isp, OMAP3_ISP_IOMEM_CCDC, ISPCCDC_SDOFST,
+			    0x7 << ISPCCDC_SDOFST_LOFST0_SHIFT |
+			    0x7 << ISPCCDC_SDOFST_LOFST1_SHIFT |
+			    0x7 << ISPCCDC_SDOFST_LOFST2_SHIFT |
+			    0x7 << ISPCCDC_SDOFST_LOFST3_SHIFT );
 	}
 }
 
@@ -970,10 +959,11 @@ void omap3isp_ccdc_max_rate(struct isp_ccdc_device *ccdc,
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
@@ -1004,9 +994,15 @@ static void ccdc_config_sync_if(struct isp_ccdc_device *ccdc,
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
 
@@ -1111,6 +1107,7 @@ static void ccdc_configure(struct isp_ccdc_device *ccdc)
 	const struct v4l2_rect *crop;
 	const struct isp_format_info *fmt_info;
 	struct v4l2_subdev_format fmt_src;
+	bool interlaced = false;
 	unsigned int depth_out;
 	unsigned int depth_in = 0;
 	struct media_pad *pad;
@@ -1132,6 +1129,10 @@ static void ccdc_configure(struct isp_ccdc_device *ccdc)
 	fmt_src.pad = pad->index;
 	fmt_src.which = V4L2_SUBDEV_FORMAT_ACTIVE;
 	if (!v4l2_subdev_call(sensor, pad, get_fmt, NULL, &fmt_src)) {
+		if (fmt_src.format.field == V4L2_FIELD_INTERLACED ||
+		    fmt_src.format.field == V4L2_FIELD_INTERLACED_TB ||
+		    fmt_src.format.field == V4L2_FIELD_INTERLACED_BT)
+			interlaced = true;
 		fmt_info = omap3isp_video_format_info(fmt_src.format.code);
 		depth_in = fmt_info->width;
 	}
@@ -1150,7 +1151,7 @@ static void ccdc_configure(struct isp_ccdc_device *ccdc)
 
 	omap3isp_configure_bridge(isp, ccdc->input, pdata, shift, bridge);
 
-	ccdc_config_sync_if(ccdc, pdata, depth_out);
+	ccdc_config_sync_if(ccdc, pdata, depth_out, interlaced);
 
 	syn_mode = isp_reg_readl(isp, OMAP3_ISP_IOMEM_CCDC, ISPCCDC_SYN_MODE);
 
@@ -1213,7 +1214,7 @@ static void ccdc_configure(struct isp_ccdc_device *ccdc)
 			<< ISPCCDC_VERT_LINES_NLV_SHIFT,
 		       OMAP3_ISP_IOMEM_CCDC, ISPCCDC_VERT_LINES);
 
-	ccdc_config_outlineoffset(ccdc, ccdc->video_out.bpl_value, 0, 0);
+	ccdc_config_outlineoffset(ccdc, ccdc->video_out.bpl_value, interlaced);
 
 	/* The CCDC outputs data in UYVY order by default. Swap bytes to get
 	 * YUYV.
diff --git a/drivers/media/platform/omap3isp/ispreg.h b/drivers/media/platform/omap3isp/ispreg.h
index b7d90e6..956df24a 100644
--- a/drivers/media/platform/omap3isp/ispreg.h
+++ b/drivers/media/platform/omap3isp/ispreg.h
@@ -747,10 +747,6 @@
 #define ISPCCDC_SDOFST_LOFST2_SHIFT		3
 #define ISPCCDC_SDOFST_LOFST1_SHIFT		6
 #define ISPCCDC_SDOFST_LOFST0_SHIFT		9
-#define EVENEVEN				1
-#define ODDEVEN					2
-#define EVENODD					3
-#define ODDODD					4
 
 #define ISPCCDC_CLAMP_OBGAIN_SHIFT		0
 #define ISPCCDC_CLAMP_OBST_SHIFT		10
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

