Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:45939 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754565Ab1JKPJa (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 11 Oct 2011 11:09:30 -0400
Received: by mail-wy0-f174.google.com with SMTP id 34so7130346wyg.19
        for <linux-media@vger.kernel.org>; Tue, 11 Oct 2011 08:09:30 -0700 (PDT)
From: Enrico Butera <ebutera@users.berlios.de>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Enrico Butera <ebutera@users.berlios.de>,
	linux-media@vger.kernel.org
Subject: [RFC 3/3] omap3isp: ispccdc: configure CCDC registers and add BT656 support
Date: Tue, 11 Oct 2011 17:08:55 +0200
Message-Id: <1318345735-16778-4-git-send-email-ebutera@users.berlios.de>
In-Reply-To: <1318345735-16778-1-git-send-email-ebutera@users.berlios.de>
References: <1318345735-16778-1-git-send-email-ebutera@users.berlios.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is a port of the following Deepthy Ravi patches:

[PATCH 5/8] ispccdc: Configure CCDC registers
[PATCH 6/8] ispccdc: Add support for BT656 interface

Signed-off-by: Enrico Butera <ebutera@users.berlios.de>
---
 drivers/media/video/omap3isp/ispccdc.c |  143 ++++++++++++++++++++++++++-----
 drivers/media/video/omap3isp/ispccdc.h |    1 +
 drivers/media/video/omap3isp/ispreg.h  |    1 +
 3 files changed, 122 insertions(+), 23 deletions(-)

diff --git a/drivers/media/video/omap3isp/ispccdc.c b/drivers/media/video/omap3isp/ispccdc.c
index c25db54..fde3268 100644
--- a/drivers/media/video/omap3isp/ispccdc.c
+++ b/drivers/media/video/omap3isp/ispccdc.c
@@ -59,8 +59,11 @@ static const unsigned int ccdc_fmts[] = {
 	V4L2_MBUS_FMT_SGBRG12_1X12,
 	V4L2_MBUS_FMT_YUYV8_2X8,
 	V4L2_MBUS_FMT_UYVY8_2X8,
+	V4L2_MBUS_FMT_YUYV8_2X8,
 };
 
+static bool ccdc_input_is_bt656(struct isp_ccdc_device *ccdc);
+
 /*
  * ccdc_print_status - Print current CCDC Module register values.
  * @ccdc: Pointer to ISP CCDC device.
@@ -792,11 +795,16 @@ static void ccdc_apply_controls(struct isp_ccdc_device *ccdc)
 void omap3isp_ccdc_restore_context(struct isp_device *isp)
 {
 	struct isp_ccdc_device *ccdc = &isp->isp_ccdc;
+	struct v4l2_mbus_framefmt *format;
 
 	isp_reg_set(isp, OMAP3_ISP_IOMEM_CCDC, ISPCCDC_CFG, ISPCCDC_CFG_VDLC);
 
-	ccdc->update = OMAP3ISP_CCDC_ALAW | OMAP3ISP_CCDC_LPF
-		     | OMAP3ISP_CCDC_BLCLAMP | OMAP3ISP_CCDC_BCOMP;
+	/* CCDC_PAD_SINK */
+	format = &ccdc->formats[CCDC_PAD_SINK];
+	if ((format->code != V4L2_MBUS_FMT_UYVY8_2X8) &&
+			(format->code != V4L2_MBUS_FMT_UYVY8_2X8))
+		ccdc->update = OMAP3ISP_CCDC_ALAW | OMAP3ISP_CCDC_LPF
+				| OMAP3ISP_CCDC_BLCLAMP | OMAP3ISP_CCDC_BCOMP;
 	ccdc_apply_controls(ccdc);
 	ccdc_configure_fpc(ccdc);
 }
@@ -1010,6 +1018,9 @@ static void ccdc_config_sync_if(struct isp_ccdc_device *ccdc,
 	if (pdata && pdata->vs_pol)
 		syn_mode |= ISPCCDC_SYN_MODE_VDPOL;
 
+	if (pdata && pdata->fldmode)
+		syn_mode |= ISPCCDC_SYN_MODE_FLDMODE;
+
 	isp_reg_writel(isp, syn_mode, OMAP3_ISP_IOMEM_CCDC, ISPCCDC_SYN_MODE);
 
 	if (format->code == V4L2_MBUS_FMT_UYVY8_2X8)
@@ -1021,10 +1032,11 @@ static void ccdc_config_sync_if(struct isp_ccdc_device *ccdc,
 
 	if (pdata && pdata->bt656)
 		isp_reg_set(isp, OMAP3_ISP_IOMEM_CCDC, ISPCCDC_REC656IF,
-			    ISPCCDC_REC656IF_R656ON);
+			    ISPCCDC_REC656IF_R656ON | ISPCCDC_REC656IF_ECCFVH);
 	else
 		isp_reg_clr(isp, OMAP3_ISP_IOMEM_CCDC, ISPCCDC_REC656IF,
-			    ISPCCDC_REC656IF_R656ON);
+			    ISPCCDC_REC656IF_R656ON | ISPCCDC_REC656IF_ECCFVH);
+
 }
 
 /* CCDC formats descriptions */
@@ -1106,6 +1118,7 @@ static void ccdc_configure(struct isp_ccdc_device *ccdc)
 	struct isp_parallel_platform_data *pdata = NULL;
 	struct v4l2_subdev *sensor;
 	struct v4l2_mbus_framefmt *format;
+	struct v4l2_pix_format pix;
 	const struct isp_format_info *fmt_info;
 	struct v4l2_subdev_format fmt_src;
 	unsigned int depth_out;
@@ -1164,6 +1177,9 @@ static void ccdc_configure(struct isp_ccdc_device *ccdc)
 	/* CCDC_PAD_SINK */
 	format = &ccdc->formats[CCDC_PAD_SINK];
 
+	if (format->code == V4L2_MBUS_FMT_UYVY8_2X8)
+		isp_reg_set(isp, OMAP3_ISP_IOMEM_CCDC, ISPCCDC_CFG,
+			    ISPCCDC_CFG_Y8POS);
 	/* Mosaic filter */
 	switch (format->code) {
 	case V4L2_MBUS_FMT_SRGGB10_1X10:
@@ -1183,28 +1199,70 @@ static void ccdc_configure(struct isp_ccdc_device *ccdc)
 		ccdc_pattern = ccdc_sgrbg_pattern;
 		break;
 	}
-	ccdc_config_imgattr(ccdc, ccdc_pattern);
 
-	/* Generate VD0 on the last line of the image and VD1 on the
-	 * 2/3 height line.
-	 */
-	isp_reg_writel(isp, ((format->height - 2) << ISPCCDC_VDINT_0_SHIFT) |
-		       ((format->height * 2 / 3) << ISPCCDC_VDINT_1_SHIFT),
-		       OMAP3_ISP_IOMEM_CCDC, ISPCCDC_VDINT);
+	if ((format->code != V4L2_MBUS_FMT_YUYV8_2X8) &&
+			(format->code != V4L2_MBUS_FMT_UYVY8_2X8))
+		ccdc_config_imgattr(ccdc, ccdc_pattern);
+
+	/* BT656: Generate VD0 on the last line of each field, and we
+	* don't use VD1.
+	* Non BT656: Generate VD0 on the last line of the image and VD1 on the
+	* 2/3 height line.
+	*/
+	if (pdata->bt656)
+		isp_reg_writel(isp,
+			(format->height/2 - 2) << ISPCCDC_VDINT_0_SHIFT,
+			OMAP3_ISP_IOMEM_CCDC, ISPCCDC_VDINT);
+	else
+		isp_reg_writel(isp,
+			((format->height - 2) << ISPCCDC_VDINT_0_SHIFT) |
+			((format->height * 2 / 3) << ISPCCDC_VDINT_1_SHIFT),
+			OMAP3_ISP_IOMEM_CCDC, ISPCCDC_VDINT);
 
 	/* CCDC_PAD_SOURCE_OF */
 	format = &ccdc->formats[CCDC_PAD_SOURCE_OF];
 
-	isp_reg_writel(isp, (0 << ISPCCDC_HORZ_INFO_SPH_SHIFT) |
+	isp_video_mbus_to_pix(&ccdc->video_out, format, &pix);
+
+	/* For BT656 the number of bytes would be width*2 */
+	if (pdata->bt656)
+		isp_reg_writel(isp, (0 << ISPCCDC_HORZ_INFO_SPH_SHIFT) |
+			((pix.bytesperline - 1) << ISPCCDC_HORZ_INFO_NPH_SHIFT),
+			OMAP3_ISP_IOMEM_CCDC, ISPCCDC_HORZ_INFO);
+	else
+		isp_reg_writel(isp, (0 << ISPCCDC_HORZ_INFO_SPH_SHIFT) |
 		       ((format->width - 1) << ISPCCDC_HORZ_INFO_NPH_SHIFT),
 		       OMAP3_ISP_IOMEM_CCDC, ISPCCDC_HORZ_INFO);
 	isp_reg_writel(isp, 0 << ISPCCDC_VERT_START_SLV0_SHIFT,
 		       OMAP3_ISP_IOMEM_CCDC, ISPCCDC_VERT_START);
-	isp_reg_writel(isp, (format->height - 1)
+
+	if (pdata->bt656)
+		isp_reg_writel(isp, ((format->height >> 1) - 1)
+			<< ISPCCDC_VERT_LINES_NLV_SHIFT,
+			OMAP3_ISP_IOMEM_CCDC, ISPCCDC_VERT_LINES);
+	else
+		isp_reg_writel(isp, (format->height - 1)
 			<< ISPCCDC_VERT_LINES_NLV_SHIFT,
 		       OMAP3_ISP_IOMEM_CCDC, ISPCCDC_VERT_LINES);
 
-	ccdc_config_outlineoffset(ccdc, ccdc->video_out.bpl_value, 0, 0);
+	isp_reg_clr(isp, OMAP3_ISP_IOMEM_CCDC, ISPCCDC_SDOFST,
+		    ISPCCDC_SDOFST_LOFST_MASK << ISPCCDC_SDOFST_LOFST0_SHIFT);
+	isp_reg_clr(isp, OMAP3_ISP_IOMEM_CCDC, ISPCCDC_SDOFST,
+		    ISPCCDC_SDOFST_LOFST_MASK << ISPCCDC_SDOFST_LOFST1_SHIFT);
+	isp_reg_clr(isp, OMAP3_ISP_IOMEM_CCDC, ISPCCDC_SDOFST,
+		    ISPCCDC_SDOFST_LOFST_MASK << ISPCCDC_SDOFST_LOFST2_SHIFT);
+	isp_reg_clr(isp, OMAP3_ISP_IOMEM_CCDC, ISPCCDC_SDOFST,
+		    ISPCCDC_SDOFST_LOFST_MASK << ISPCCDC_SDOFST_LOFST3_SHIFT);
+
+	/* In case of BT656 each alternate line must be stored into memory */
+	if (pdata->bt656) {
+		ccdc_config_outlineoffset(ccdc, pix.bytesperline, EVENEVEN, 1);
+		ccdc_config_outlineoffset(ccdc, pix.bytesperline, EVENODD, 1);
+		ccdc_config_outlineoffset(ccdc, pix.bytesperline, ODDEVEN, 1);
+		ccdc_config_outlineoffset(ccdc, pix.bytesperline, ODDODD, 1);
+	} else {
+		ccdc_config_outlineoffset(ccdc, ccdc->video_out.bpl_value, 0, 0);
+	}
 
 	/* CCDC_PAD_SOURCE_VP */
 	format = &ccdc->formats[CCDC_PAD_SOURCE_VP];
@@ -1223,8 +1281,14 @@ static void ccdc_configure(struct isp_ccdc_device *ccdc)
 	/* Use PACK8 mode for 1byte per pixel formats. */
 	if (omap3isp_video_format_info(format->code)->width <= 8)
 		syn_mode |= ISPCCDC_SYN_MODE_PACK8;
-	else
-		syn_mode &= ~ISPCCDC_SYN_MODE_PACK8;
+
+	if ((format->code == V4L2_MBUS_FMT_YUYV8_2X8) ||
+		(format->code == V4L2_MBUS_FMT_UYVY8_2X8)) {
+		if (pdata->bt656)
+			syn_mode |= ISPCCDC_SYN_MODE_INPMOD_YCBCR8;
+		else
+			syn_mode |= ISPCCDC_SYN_MODE_INPMOD_YCBCR16;
+	}
 
 	isp_reg_writel(isp, syn_mode, OMAP3_ISP_IOMEM_CCDC, ISPCCDC_SYN_MODE);
 
@@ -1251,6 +1315,11 @@ static void ccdc_configure(struct isp_ccdc_device *ccdc)
 unlock:
 	spin_unlock_irqrestore(&ccdc->lsc.req_lock, flags);
 
+	if (pdata->bt656)
+		ccdc->update = OMAP3ISP_CCDC_BLCLAMP;
+	else
+		ccdc->update = 0;
+
 	ccdc_apply_controls(ccdc);
 }
 
@@ -1262,6 +1331,7 @@ static void __ccdc_enable(struct isp_ccdc_device *ccdc, int enable)
 			ISPCCDC_PCR_EN, enable ? ISPCCDC_PCR_EN : 0);
 }
 
+static int __ccdc_handle_stopping(struct isp_ccdc_device *ccdc, u32 event);
 static int ccdc_disable(struct isp_ccdc_device *ccdc)
 {
 	unsigned long flags;
@@ -1272,6 +1342,11 @@ static int ccdc_disable(struct isp_ccdc_device *ccdc)
 		ccdc->stopping = CCDC_STOP_REQUEST;
 	spin_unlock_irqrestore(&ccdc->lock, flags);
 
+	__ccdc_lsc_enable(ccdc, 0);
+	__ccdc_enable(ccdc, 0);
+	ccdc->stopping = CCDC_STOP_EXECUTED;
+	__ccdc_handle_stopping(ccdc, CCDC_STOP_FINISHED);
+
 	ret = wait_event_timeout(ccdc->wait,
 				 ccdc->stopping == CCDC_STOP_FINISHED,
 				 msecs_to_jiffies(2000));
@@ -1523,10 +1598,30 @@ static void ccdc_vd0_isr(struct isp_ccdc_device *ccdc)
 {
 	unsigned long flags;
 	int restart = 0;
+	struct isp_device *isp = to_isp_device(ccdc);
 
-	if (ccdc->output & CCDC_OUTPUT_MEMORY)
-		restart = ccdc_isr_buffer(ccdc);
-
+	if (ccdc->output & CCDC_OUTPUT_MEMORY) {
+		if (ccdc_input_is_bt656(ccdc)) {
+			u32 fid;
+			u32 syn_mode = isp_reg_readl(isp, OMAP3_ISP_IOMEM_CCDC,
+					ISPCCDC_SYN_MODE);
+			fid = syn_mode & ISPCCDC_SYN_MODE_FLDSTAT;
+			/* toggle the software maintained fid */
+			ccdc->fldstat ^= 1;
+
+			if (fid == ccdc->fldstat) {
+				if (fid == 0) {
+					restart = ccdc_isr_buffer(ccdc);
+					goto done;
+				}
+			} else if (fid == 0) {
+				ccdc->fldstat = fid;
+			}
+		} else {
+			restart = ccdc_isr_buffer(ccdc);
+		}
+	}
+done:
 	spin_lock_irqsave(&ccdc->lock, flags);
 	if (__ccdc_handle_stopping(ccdc, CCDC_EVENT_VD0)) {
 		spin_unlock_irqrestore(&ccdc->lock, flags);
@@ -1612,7 +1707,8 @@ int omap3isp_ccdc_isr(struct isp_ccdc_device *ccdc, u32 events)
 	if (ccdc->state == ISP_PIPELINE_STREAM_STOPPED)
 		return 0;
 
-	if (events & IRQ0STATUS_CCDC_VD1_IRQ)
+	if (!ccdc_input_is_bt656(ccdc) &&
+			(events & IRQ0STATUS_CCDC_VD1_IRQ))
 		ccdc_vd1_isr(ccdc);
 
 	ccdc_lsc_isr(ccdc, events);
@@ -1620,7 +1716,8 @@ int omap3isp_ccdc_isr(struct isp_ccdc_device *ccdc, u32 events)
 	if (events & IRQ0STATUS_CCDC_VD0_IRQ)
 		ccdc_vd0_isr(ccdc);
 
-	if (events & IRQ0STATUS_HS_VS_IRQ)
+	if (!ccdc_input_is_bt656(ccdc) &&
+			(events & IRQ0STATUS_HS_VS_IRQ))
 		ccdc_hs_vs_isr(ccdc);
 
 	return 0;
@@ -1734,7 +1831,7 @@ static int ccdc_set_stream(struct v4l2_subdev *sd, int enable)
 		 * links are inactive.
 		 */
 		ccdc_config_vp(ccdc);
-		ccdc_enable_vp(ccdc, 1);
+		ccdc_enable_vp(ccdc, 0);
 		ccdc->error = 0;
 		ccdc_print_status(ccdc);
 	}
@@ -2284,7 +2381,7 @@ int omap3isp_ccdc_init(struct isp_device *isp)
 
 	ccdc->vpcfg.pixelclk = 0;
 
-	ccdc->update = OMAP3ISP_CCDC_BLCLAMP;
+	ccdc->update = 0;
 	ccdc_apply_controls(ccdc);
 
 	ret = ccdc_init_entities(ccdc);
diff --git a/drivers/media/video/omap3isp/ispccdc.h b/drivers/media/video/omap3isp/ispccdc.h
index 54811ce..7f933b2 100644
--- a/drivers/media/video/omap3isp/ispccdc.h
+++ b/drivers/media/video/omap3isp/ispccdc.h
@@ -159,6 +159,7 @@ struct isp_ccdc_device {
 	struct ispccdc_vp vpcfg;
 
 	unsigned int underrun:1;
+	unsigned int fldstat:1;
 	enum isp_pipeline_stream_state state;
 	spinlock_t lock;
 	wait_queue_head_t wait;
diff --git a/drivers/media/video/omap3isp/ispreg.h b/drivers/media/video/omap3isp/ispreg.h
index 69f6af6..ada39c6 100644
--- a/drivers/media/video/omap3isp/ispreg.h
+++ b/drivers/media/video/omap3isp/ispreg.h
@@ -827,6 +827,7 @@
 #define ISPCCDC_SDOFST_LOFST2_SHIFT		3
 #define ISPCCDC_SDOFST_LOFST1_SHIFT		6
 #define ISPCCDC_SDOFST_LOFST0_SHIFT		9
+#define ISPCCDC_SDOFST_LOFST_MASK              0x7
 #define EVENEVEN				1
 #define ODDEVEN					2
 #define EVENODD					3
-- 
1.7.4.1

