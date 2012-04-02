Return-path: <linux-media-owner@vger.kernel.org>
Received: from hermes.mlbassoc.com ([64.234.241.98]:46968 "EHLO
	mail.chez-thomas.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751145Ab2DBNbv (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 2 Apr 2012 09:31:51 -0400
Message-ID: <4F79AA43.3070109@mlbassoc.com>
Date: Mon, 02 Apr 2012 07:31:47 -0600
From: Gary Thomas <gary@mlbassoc.com>
MIME-Version: 1.0
To: Enrico <ebutera@users.berlios.de>
CC: linux-media@vger.kernel.org,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: Re: OMAP3ISP won't start
References: <4F799A99.9010209@mlbassoc.com> <CA+2YH7svJoCnvUPQGPr=YOsEQBZ16J5y9QGjFyfNmdjeLum4cA@mail.gmail.com> <4F799F4F.9020606@mlbassoc.com> <CA+2YH7uesV_085_-LyKCm8zuEROy_6FRQg8XkiRsHubdTXF8ig@mail.gmail.com>
In-Reply-To: <CA+2YH7uesV_085_-LyKCm8zuEROy_6FRQg8XkiRsHubdTXF8ig@mail.gmail.com>
Content-Type: multipart/mixed;
 boundary="------------040208070600040504050002"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is a multi-part message in MIME format.
--------------040208070600040504050002
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

On 2012-04-02 07:15, Enrico wrote:
> On Mon, Apr 2, 2012 at 2:45 PM, Gary Thomas<gary@mlbassoc.com>  wrote:
>> The items you mention are just what I merged from my previous kernel.
>> My changes are still pretty rough but I can send them to you if you'd
>> like.
>
> Post them here and we will try to spot where the problem is, they
> could be useful for Laurent too as a reference.

Attached.

-- 
------------------------------------------------------------
Gary Thomas                 |  Consulting for the
MLB Associates              |    Embedded world
------------------------------------------------------------

--------------040208070600040504050002
Content-Type: text/x-patch;
 name="bt656-3.3.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="bt656-3.3.patch"

diff --git a/drivers/media/video/omap3isp/ispccdc.c b/drivers/media/video/omap3isp/ispccdc.c
index f62a38b..ab2717b 100644
--- a/drivers/media/video/omap3isp/ispccdc.c
+++ b/drivers/media/video/omap3isp/ispccdc.c
@@ -62,6 +62,8 @@ static const unsigned int ccdc_fmts[] = {
 	V4L2_MBUS_FMT_UYVY8_2X8,
 };
 
+static bool ccdc_input_is_bt656(struct isp_ccdc_device *ccdc);
+
 /*
  * ccdc_print_status - Print current CCDC Module register values.
  * @ccdc: Pointer to ISP CCDC device.
@@ -794,11 +796,16 @@ static void ccdc_apply_controls(struct isp_ccdc_device *ccdc)
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
+            (format->code != V4L2_MBUS_FMT_UYVY8_2X8))
+		ccdc->update = OMAP3ISP_CCDC_ALAW | OMAP3ISP_CCDC_LPF |
+			       OMAP3ISP_CCDC_BLCLAMP | OMAP3ISP_CCDC_BCOMP;
 	ccdc_apply_controls(ccdc);
 	ccdc_configure_fpc(ccdc);
 }
@@ -1012,6 +1019,9 @@ static void ccdc_config_sync_if(struct isp_ccdc_device *ccdc,
 	if (pdata && pdata->vs_pol)
 		syn_mode |= ISPCCDC_SYN_MODE_VDPOL;
 
+	if (pdata && pdata->fldmode)
+		syn_mode |= ISPCCDC_SYN_MODE_FLDMODE;
+
 	isp_reg_writel(isp, syn_mode, OMAP3_ISP_IOMEM_CCDC, ISPCCDC_SYN_MODE);
 
 	if (format->code == V4L2_MBUS_FMT_UYVY8_2X8)
@@ -1023,10 +1033,10 @@ static void ccdc_config_sync_if(struct isp_ccdc_device *ccdc,
 
 	if (pdata && pdata->bt656)
 		isp_reg_set(isp, OMAP3_ISP_IOMEM_CCDC, ISPCCDC_REC656IF,
-			    ISPCCDC_REC656IF_R656ON);
+			    ISPCCDC_REC656IF_R656ON | ISPCCDC_REC656IF_ECCFVH);
 	else
 		isp_reg_clr(isp, OMAP3_ISP_IOMEM_CCDC, ISPCCDC_REC656IF,
-			    ISPCCDC_REC656IF_R656ON);
+			    ISPCCDC_REC656IF_R656ON | ISPCCDC_REC656IF_ECCFVH);
 }
 
 /* CCDC formats descriptions */
@@ -1108,6 +1118,7 @@ static void ccdc_configure(struct isp_ccdc_device *ccdc)
 	struct isp_parallel_platform_data *pdata = NULL;
 	struct v4l2_subdev *sensor;
 	struct v4l2_mbus_framefmt *format;
+	struct v4l2_pix_format pix;
 	const struct isp_format_info *fmt_info;
 	struct v4l2_subdev_format fmt_src;
 	unsigned int depth_out;
@@ -1166,6 +1177,10 @@ static void ccdc_configure(struct isp_ccdc_device *ccdc)
 	/* CCDC_PAD_SINK */
 	format = &ccdc->formats[CCDC_PAD_SINK];
 
+	if (format->code == V4L2_MBUS_FMT_UYVY8_2X8)
+		isp_reg_set(isp, OMAP3_ISP_IOMEM_CCDC, ISPCCDC_CFG,
+			    ISPCCDC_CFG_Y8POS);
+
 	/* Mosaic filter */
 	switch (format->code) {
 	case V4L2_MBUS_FMT_SRGGB10_1X10:
@@ -1185,28 +1200,70 @@ static void ccdc_configure(struct isp_ccdc_device *ccdc)
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
-		       ((format->width - 1) << ISPCCDC_HORZ_INFO_NPH_SHIFT),
-		       OMAP3_ISP_IOMEM_CCDC, ISPCCDC_HORZ_INFO);
+	isp_video_mbus_to_pix(&ccdc->video_out, format, &pix);
+
+	/* For BT656 the number of bytes would be width*2 */
+	if (pdata->bt656)
+		isp_reg_writel(isp, (0 << ISPCCDC_HORZ_INFO_SPH_SHIFT) |
+                               ((pix.bytesperline - 1) << ISPCCDC_HORZ_INFO_NPH_SHIFT),
+                               OMAP3_ISP_IOMEM_CCDC, ISPCCDC_HORZ_INFO);
+	else
+		isp_reg_writel(isp, (0 << ISPCCDC_HORZ_INFO_SPH_SHIFT) |
+                               ((format->width - 1) << ISPCCDC_HORZ_INFO_NPH_SHIFT),
+                               OMAP3_ISP_IOMEM_CCDC, ISPCCDC_HORZ_INFO);
 	isp_reg_writel(isp, 0 << ISPCCDC_VERT_START_SLV0_SHIFT,
 		       OMAP3_ISP_IOMEM_CCDC, ISPCCDC_VERT_START);
-	isp_reg_writel(isp, (format->height - 1)
-			<< ISPCCDC_VERT_LINES_NLV_SHIFT,
-		       OMAP3_ISP_IOMEM_CCDC, ISPCCDC_VERT_LINES);
 
-	ccdc_config_outlineoffset(ccdc, ccdc->video_out.bpl_value, 0, 0);
+	if (pdata->bt656)
+		isp_reg_writel(isp, ((format->height >> 1) - 1) << ISPCCDC_VERT_LINES_NLV_SHIFT,
+                               OMAP3_ISP_IOMEM_CCDC, ISPCCDC_VERT_LINES);
+	else
+		isp_reg_writel(isp, (format->height - 1) << ISPCCDC_VERT_LINES_NLV_SHIFT,
+                               OMAP3_ISP_IOMEM_CCDC, ISPCCDC_VERT_LINES);
+
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
+                isp_reg_set(isp, OMAP3_ISP_IOMEM_CCDC, ISPCCDC_SDOFST,
+                            ISPCCDC_SDOFST_FINV);
+	} else {
+		ccdc_config_outlineoffset(ccdc, ccdc->video_out.bpl_value, 0, 0);
+	}
 
 	/* CCDC_PAD_SOURCE_VP */
 	format = &ccdc->formats[CCDC_PAD_SOURCE_VP];
@@ -1253,6 +1310,11 @@ static void ccdc_configure(struct isp_ccdc_device *ccdc)
 unlock:
 	spin_unlock_irqrestore(&ccdc->lsc.req_lock, flags);
 
+	if (pdata->bt656)
+		ccdc->update = OMAP3ISP_CCDC_BLCLAMP;
+	else
+		ccdc->update = 0;
+
 	ccdc_apply_controls(ccdc);
 }
 
@@ -1264,6 +1326,7 @@ static void __ccdc_enable(struct isp_ccdc_device *ccdc, int enable)
 			ISPCCDC_PCR_EN, enable ? ISPCCDC_PCR_EN : 0);
 }
 
+static int __ccdc_handle_stopping(struct isp_ccdc_device *ccdc, u32 event);
 static int ccdc_disable(struct isp_ccdc_device *ccdc)
 {
 	unsigned long flags;
@@ -1274,6 +1337,11 @@ static int ccdc_disable(struct isp_ccdc_device *ccdc)
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
@@ -1529,9 +1597,31 @@ static void ccdc_vd0_isr(struct isp_ccdc_device *ccdc)
 {
 	unsigned long flags;
 	int restart = 0;
-
-	if (ccdc->output & CCDC_OUTPUT_MEMORY)
-		restart = ccdc_isr_buffer(ccdc);
+	struct isp_device *isp = to_isp_device(ccdc);
+ 
+	if (ccdc->output & CCDC_OUTPUT_MEMORY) {
+		if (ccdc_input_is_bt656(ccdc)) {
+			u32 fid;
+			u32 syn_mode = isp_reg_readl(isp, OMAP3_ISP_IOMEM_CCDC,
+					ISPCCDC_SYN_MODE);
+
+			fid = (syn_mode & ISPCCDC_SYN_MODE_FLDSTAT) == 0;
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
@@ -1618,7 +1708,8 @@ int omap3isp_ccdc_isr(struct isp_ccdc_device *ccdc, u32 events)
 	if (ccdc->state == ISP_PIPELINE_STREAM_STOPPED)
 		return 0;
 
-	if (events & IRQ0STATUS_CCDC_VD1_IRQ)
+	if (!ccdc_input_is_bt656(ccdc) &&
+            (events & IRQ0STATUS_CCDC_VD1_IRQ))
 		ccdc_vd1_isr(ccdc);
 
 	ccdc_lsc_isr(ccdc, events);
@@ -1626,7 +1717,8 @@ int omap3isp_ccdc_isr(struct isp_ccdc_device *ccdc, u32 events)
 	if (events & IRQ0STATUS_CCDC_VD0_IRQ)
 		ccdc_vd0_isr(ccdc);
 
-	if (events & IRQ0STATUS_HS_VS_IRQ)
+	if (!ccdc_input_is_bt656(ccdc) &&
+            (events & IRQ0STATUS_HS_VS_IRQ))
 		ccdc_hs_vs_isr(ccdc);
 
 	return 0;
@@ -1740,7 +1832,7 @@ static int ccdc_set_stream(struct v4l2_subdev *sd, int enable)
 		 * links are inactive.
 		 */
 		ccdc_config_vp(ccdc);
-		ccdc_enable_vp(ccdc, 1);
+		ccdc_enable_vp(ccdc, 0);
 		ccdc_print_status(ccdc);
 	}
 
@@ -2289,7 +2381,7 @@ int omap3isp_ccdc_init(struct isp_device *isp)
 
 	ccdc->vpcfg.pixelclk = 0;
 
-	ccdc->update = OMAP3ISP_CCDC_BLCLAMP;
+	ccdc->update = 0;
 	ccdc_apply_controls(ccdc);
 
 	ret = ccdc_init_entities(ccdc);
diff --git a/drivers/media/video/omap3isp/ispccdc.h b/drivers/media/video/omap3isp/ispccdc.h
index 836439a..2d31250 100644
--- a/drivers/media/video/omap3isp/ispccdc.h
+++ b/drivers/media/video/omap3isp/ispccdc.h
@@ -157,6 +157,7 @@ struct isp_ccdc_device {
 	struct ispccdc_vp vpcfg;
 
 	unsigned int underrun:1;
+	unsigned int fldstat:1;
 	enum isp_pipeline_stream_state state;
 	spinlock_t lock;
 	wait_queue_head_t wait;
diff --git a/drivers/media/video/omap3isp/ispreg.h b/drivers/media/video/omap3isp/ispreg.h
index 084ea77..f9c2e47 100644
--- a/drivers/media/video/omap3isp/ispreg.h
+++ b/drivers/media/video/omap3isp/ispreg.h
@@ -824,6 +824,7 @@
 #define ISPCCDC_SDOFST_LOFST2_SHIFT		3
 #define ISPCCDC_SDOFST_LOFST1_SHIFT		6
 #define ISPCCDC_SDOFST_LOFST0_SHIFT		9
+#define ISPCCDC_SDOFST_LOFST_MASK               0x7
 #define EVENEVEN				1
 #define ODDEVEN					2
 #define EVENODD					3
diff --git a/drivers/media/video/omap3isp/ispvideo.c b/drivers/media/video/omap3isp/ispvideo.c
index d1526ab..9ee0a80 100644
--- a/drivers/media/video/omap3isp/ispvideo.c
+++ b/drivers/media/video/omap3isp/ispvideo.c
@@ -165,9 +165,9 @@ static bool isp_video_is_shiftable(enum v4l2_mbus_pixelcode in,
  *
  * Return the number of padding bytes at end of line.
  */
-static unsigned int isp_video_mbus_to_pix(const struct isp_video *video,
-					  const struct v4l2_mbus_framefmt *mbus,
-					  struct v4l2_pix_format *pix)
+unsigned int isp_video_mbus_to_pix(const struct isp_video *video,
+                                   const struct v4l2_mbus_framefmt *mbus,
+                                   struct v4l2_pix_format *pix)
 {
 	unsigned int bpl = pix->bytesperline;
 	unsigned int min_bpl;
diff --git a/drivers/media/video/omap3isp/ispvideo.h b/drivers/media/video/omap3isp/ispvideo.h
index 8572e64..8bab73f 100644
--- a/drivers/media/video/omap3isp/ispvideo.h
+++ b/drivers/media/video/omap3isp/ispvideo.h
@@ -206,6 +206,9 @@ void omap3isp_video_unregister(struct isp_video *video);
 struct isp_buffer *omap3isp_video_buffer_next(struct isp_video *video);
 void omap3isp_video_resume(struct isp_video *video, int continuous);
 struct media_pad *omap3isp_video_remote_pad(struct isp_video *video);
+extern unsigned int isp_video_mbus_to_pix(const struct isp_video *video,
+                                          const struct v4l2_mbus_framefmt *mbus,
+                                          struct v4l2_pix_format *pix);
 
 const struct isp_format_info *
 omap3isp_video_format_info(enum v4l2_mbus_pixelcode code);
diff --git a/drivers/media/video/tvp5150.c b/drivers/media/video/tvp5150.c
index 1326e11..0551e72 100644
--- a/drivers/media/video/tvp5150.c
+++ b/drivers/media/video/tvp5150.c
@@ -14,6 +14,8 @@
 #include <media/tvp5150.h>
 #include <media/v4l2-chip-ident.h>
 #include <media/v4l2-ctrls.h>
+#include <media/v4l2-subdev.h>
+#include <media/v4l2-mediabus.h>
 
 #include "tvp5150_reg.h"
 
@@ -37,8 +39,10 @@ struct tvp5150 {
 	struct v4l2_subdev sd;
 	struct v4l2_ctrl_handler hdl;
 	struct v4l2_rect rect;
+	struct media_pad pad;
 
 	v4l2_std_id norm;	/* Current set standard */
+        struct v4l2_mbus_framefmt *format;
 	u32 input;
 	u32 output;
 	int enable;
@@ -822,7 +826,7 @@ static int tvp5150_enum_mbus_fmt(struct v4l2_subdev *sd, unsigned index,
 	if (index)
 		return -EINVAL;
 
-	*code = V4L2_MBUS_FMT_YUYV8_2X8;
+	*code = V4L2_MBUS_FMT_UYVY8_2X8;
 	return 0;
 }
 
@@ -846,7 +850,7 @@ static int tvp5150_mbus_fmt(struct v4l2_subdev *sd,
 	f->width = decoder->rect.width;
 	f->height = decoder->rect.height;
 
-	f->code = V4L2_MBUS_FMT_YUYV8_2X8;
+	f->code = V4L2_MBUS_FMT_UYVY8_2X8;
 	f->field = V4L2_FIELD_SEQ_TB;
 	f->colorspace = V4L2_COLORSPACE_SMPTE170M;
 
@@ -855,6 +859,29 @@ static int tvp5150_mbus_fmt(struct v4l2_subdev *sd,
 	return 0;
 }
 
+/*
+ * tvp515x_s_stream() - V4L2 decoder i/f handler for s_stream
+ * @sd: pointer to standard V4L2 sub-device structure
+ * @enable: streaming enable or disable
+ *
+ * Sets streaming to enable or disable, if possible.
+ */
+static int tvp5150_s_stream(struct v4l2_subdev *subdev, int enable)
+{
+
+	/* Initializes TVP5150 to its default values */
+	/* # set PCLK (27MHz) */
+	tvp5150_write(subdev, TVP5150_CONF_SHARED_PIN, 0x00);
+
+	/* Output format: 8-bit ITU-R BT.656 with embedded syncs */
+	if (enable)
+		tvp5150_write(subdev, TVP5150_MISC_CTL, 0x09);
+	else
+		tvp5150_write(subdev, TVP5150_MISC_CTL, 0x00);
+        tvp5150_log_status(subdev);
+	return 0;
+}
+
 static int tvp5150_s_crop(struct v4l2_subdev *sd, struct v4l2_crop *a)
 {
 	struct v4l2_rect rect = a->c;
@@ -1094,12 +1121,143 @@ static const struct v4l2_subdev_core_ops tvp5150_core_ops = {
 #endif
 };
 
+
+static int tvp5150_enum_mbus_code(struct v4l2_subdev *subdev,
+				  struct v4l2_subdev_fh *fh,
+				  struct v4l2_subdev_mbus_code_enum *code)
+{
+	code->code = V4L2_MBUS_FMT_UYVY8_2X8;
+
+	return 0;
+}
+
+static int tvp5150_enum_frame_size(struct v4l2_subdev *subdev,
+				   struct v4l2_subdev_fh *fh,
+				   struct v4l2_subdev_frame_size_enum *fse)
+{
+	struct tvp5150 *decoder = to_tvp5150(subdev);
+
+	if (fse->code != V4L2_MBUS_FMT_UYVY8_2X8)
+		return -EINVAL;
+
+        fse->min_width = decoder->rect.width;
+        fse->min_height = decoder->rect.height;
+	fse->max_width = fse->min_width;
+	fse->max_height = fse->min_height;
+	return 0;
+}
+
+static struct v4l2_mbus_framefmt *
+__tvp5150_get_pad_format(struct tvp5150 *tvp5150, struct v4l2_subdev_fh *fh,
+			 unsigned int pad, enum v4l2_subdev_format_whence which)
+{
+	switch (which) {
+	case V4L2_SUBDEV_FORMAT_TRY:
+		return v4l2_subdev_get_try_format(fh, pad);
+	case V4L2_SUBDEV_FORMAT_ACTIVE:
+		return tvp5150->format;
+	default:
+		return NULL;
+	}
+}
+
+static int tvp5150_get_pad_format(struct v4l2_subdev *subdev,
+                                  struct v4l2_subdev_fh *fh,
+                                  struct v4l2_subdev_format *format)
+{
+	struct tvp5150 *tvp5150 = to_tvp5150(subdev);
+
+	format->format = *__tvp5150_get_pad_format(tvp5150, fh, format->pad,
+						   format->which);
+	return 0;
+}
+
+static int tvp5150_set_pad_format(struct v4l2_subdev *subdev,
+                                  struct v4l2_subdev_fh *fh,
+                                  struct v4l2_subdev_format *format)
+{
+        return tvp5150_mbus_fmt(subdev, &format->format);
+}
+
+/**
+ * tvp5150_g_parm() - V4L2 decoder interface handler for g_parm
+ * @sd: pointer to standard V4L2 sub-device structure
+ * @a: pointer to standard V4L2 VIDIOC_G_PARM ioctl structure
+ *
+ * Returns the decoder's video CAPTURE parameters.
+ */
+static int
+tvp5150_g_parm(struct v4l2_subdev *sd, struct v4l2_streamparm *a)
+{
+	struct v4l2_captureparm *cparm;
+
+	if (a == NULL)
+		return -EINVAL;
+
+	if (a->type != V4L2_BUF_TYPE_VIDEO_CAPTURE)
+		/* only capture is supported */
+		return -EINVAL;
+
+	cparm = &a->parm.capture;
+	cparm->capability = V4L2_CAP_TIMEPERFRAME;
+	cparm->timeperframe = a->parm.capture.timeperframe;
+
+	return 0;
+}
+
+/**
+ * tvp5150_s_parm() - V4L2 decoder interface handler for s_parm
+ * @sd: pointer to standard V4L2 sub-device structure
+ * @a: pointer to standard V4L2 VIDIOC_S_PARM ioctl structure
+ *
+ * Configures the decoder to use the input parameters, if possible. If
+ * not possible, returns the appropriate error code.
+ */
+static int
+tvp5150_s_parm(struct v4l2_subdev *sd, struct v4l2_streamparm *a)
+{
+	struct v4l2_fract *timeperframe;
+
+	if (a == NULL)
+		return -EINVAL;
+
+	if (a->type != V4L2_BUF_TYPE_VIDEO_CAPTURE)
+		/* only capture is supported */
+		return -EINVAL;
+
+	timeperframe = &a->parm.capture.timeperframe;
+
+	return 0;
+}
+
+static int tvp5150_open(struct v4l2_subdev *subdev, struct v4l2_subdev_fh *fh)
+{
+	struct tvp5150 *decoder = to_tvp5150(subdev);
+
+        if (decoder->format == NULL) {
+                static struct v4l2_mbus_framefmt default_format;
+                decoder->format = &default_format;
+        }
+        return tvp5150_mbus_fmt(subdev, decoder->format);
+}
+
+static int tvp5150_close(struct v4l2_subdev *subdev, struct v4l2_subdev_fh *fh)
+{
+	return 0;
+}
+
+static struct v4l2_subdev_internal_ops tvp5150_subdev_internal_ops = {
+	.open		= tvp5150_open,
+	.close		= tvp5150_close,
+};
+
 static const struct v4l2_subdev_tuner_ops tvp5150_tuner_ops = {
 	.g_tuner = tvp5150_g_tuner,
 };
 
 static const struct v4l2_subdev_video_ops tvp5150_video_ops = {
 	.s_routing = tvp5150_s_routing,
+	.s_stream = tvp5150_s_stream,
 	.enum_mbus_fmt = tvp5150_enum_mbus_fmt,
 	.s_mbus_fmt = tvp5150_mbus_fmt,
 	.try_mbus_fmt = tvp5150_mbus_fmt,
@@ -1107,6 +1265,8 @@ static const struct v4l2_subdev_video_ops tvp5150_video_ops = {
 	.s_crop = tvp5150_s_crop,
 	.g_crop = tvp5150_g_crop,
 	.cropcap = tvp5150_cropcap,
+	.s_parm = tvp5150_s_parm,
+	.g_parm = tvp5150_g_parm,
 };
 
 static const struct v4l2_subdev_vbi_ops tvp5150_vbi_ops = {
@@ -1116,11 +1276,19 @@ static const struct v4l2_subdev_vbi_ops tvp5150_vbi_ops = {
 	.s_raw_fmt = tvp5150_s_raw_fmt,
 };
 
+static struct v4l2_subdev_pad_ops tvp5150_pad_ops = {
+	.enum_mbus_code = tvp5150_enum_mbus_code,
+	.enum_frame_size = tvp5150_enum_frame_size,
+	.get_fmt = tvp5150_get_pad_format,
+	.set_fmt = tvp5150_set_pad_format,
+};
+
 static const struct v4l2_subdev_ops tvp5150_ops = {
 	.core = &tvp5150_core_ops,
 	.tuner = &tvp5150_tuner_ops,
 	.video = &tvp5150_video_ops,
 	.vbi = &tvp5150_vbi_ops,
+	.pad = &tvp5150_pad_ops,
 };
 
 
@@ -1134,6 +1302,7 @@ static int tvp5150_probe(struct i2c_client *c,
 	struct tvp5150 *core;
 	struct v4l2_subdev *sd;
 	u8 msb_id, lsb_id, msb_rom, lsb_rom;
+        int ret;
 
 	/* Check if the adapter supports the needed features */
 	if (!i2c_check_functionality(c->adapter,
@@ -1171,6 +1340,7 @@ static int tvp5150_probe(struct i2c_client *c,
 
 	core->norm = V4L2_STD_ALL;	/* Default is autodetect */
 	core->input = TVP5150_COMPOSITE1;
+	core->input = TVP5150_COMPOSITE0;  // FIXME
 	core->enable = 1;
 
 	v4l2_ctrl_handler_init(&core->hdl, 4);
@@ -1201,6 +1371,14 @@ static int tvp5150_probe(struct i2c_client *c,
 	core->rect.left = 0;
 	core->rect.width = TVP5150_H_MAX;
 
+        /* Register media pads */
+	core->sd.flags |= V4L2_SUBDEV_FL_HAS_DEVNODE;
+	core->sd.internal_ops = &tvp5150_subdev_internal_ops;
+	core->pad.flags = MEDIA_PAD_FL_SOURCE;
+	ret = media_entity_init(&core->sd.entity, 1, &core->pad, 0);
+	if (ret < 0)
+		kfree(core);
+
 	if (debug > 1)
 		tvp5150_log_status(sd);
 	return 0;
diff --git a/include/media/omap3isp.h b/include/media/omap3isp.h
index f67b8c1..e1feb13 100644
--- a/include/media/omap3isp.h
+++ b/include/media/omap3isp.h
@@ -61,6 +61,8 @@ enum {
  *		0 - Normal, 1 - One's complement
  * @bt656: ITU-R BT656 embedded synchronization
  *		0 - HS/VS sync, 1 - BT656 sync
+ * @fldmode: Field mode
+ *             0 - progressive, 1 - Interlaced
  */
 struct isp_parallel_platform_data {
 	unsigned int data_lane_shift:2;
@@ -69,6 +71,7 @@ struct isp_parallel_platform_data {
 	unsigned int vs_pol:1;
 	unsigned int data_pol:1;
 	unsigned int bt656:1;
+	unsigned int fldmode:1;
 };
 
 enum {

--------------040208070600040504050002--
