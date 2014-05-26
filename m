Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:49826 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752108AbaEZTuH (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 26 May 2014 15:50:07 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: Julien BERAUD <julien.beraud@parrot.com>,
	Boris Todorov <boris.st.todorov@gmail.com>,
	Gary Thomas <gary@mlbassoc.com>,
	Enrico <ebutera@users.berlios.de>,
	Stefan Herbrechtsmeier <sherbrec@cit-ec.uni-bielefeld.de>,
	Javier Martinez Canillas <martinez.javier@gmail.com>,
	Chris Whittenburg <whittenburg@gmail.com>,
	Sakari Ailus <sakari.ailus@iki.fi>
Subject: [PATCH 10/11] omap3isp: ccdc: Support the interlaced field orders at the CCDC output
Date: Mon, 26 May 2014 21:50:11 +0200
Message-Id: <1401133812-8745-11-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1401133812-8745-1-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1401133812-8745-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The CCDC can interleave fields into a single buffer when writing to
memory. Support it.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/media/platform/omap3isp/ispccdc.c  | 132 +++++++++++++++++++----------
 drivers/media/platform/omap3isp/ispreg.h   |  10 +--
 drivers/media/platform/omap3isp/ispvideo.c |  40 +++++++--
 3 files changed, 122 insertions(+), 60 deletions(-)

diff --git a/drivers/media/platform/omap3isp/ispccdc.c b/drivers/media/platform/omap3isp/ispccdc.c
index 49d7256..8d1861d 100644
--- a/drivers/media/platform/omap3isp/ispccdc.c
+++ b/drivers/media/platform/omap3isp/ispccdc.c
@@ -863,52 +863,51 @@ static void ccdc_enable_vp(struct isp_ccdc_device *ccdc, u8 enable)
 /*
  * ccdc_config_outlineoffset - Configure memory saving output line offset
  * @ccdc: Pointer to ISP CCDC device.
- * @offset: Address offset to start a new line. Must be twice the
- *          Output width and aligned on 32 byte boundary
- * @oddeven: Specifies the odd/even line pattern to be chosen to store the
- *           output.
- * @numlines: Set the value 0-3 for +1-4lines, 4-7 for -1-4lines.
+ * @bpl: Number of bytes per line when stored in memory.
+ * @field: Field order when storing interlaced formats in memory.
  *
- * - Configures the output line offset when stored in memory
- * - Sets the odd/even line pattern to store the output
- *    (EVENEVEN (1), ODDEVEN (2), EVENODD (3), ODDODD (4))
- * - Configures the number of even and odd line fields in case of rearranging
- * the lines.
+ * Configure the offsets for the line output control:
+ *
+ * - The horizontal line offset is defined as the number of bytes between the
+ *   start of two consecutive lines in memory. Set it to the given bytes per
+ *   line value.
+ *
+ * - The field offset value is defined as the number of lines to offset the
+ *   start of the field identified by FID = 1. Set it to one.
+ *
+ * - The line offset values are defined as the number of lines (as defined by
+ *   the horizontal line offset) between the start of two consecutive lines for
+ *   all combinations of odd/even lines in odd/even fields. When interleaving
+ *   fields set them all to two lines, and to one line otherwise.
  */
 static void ccdc_config_outlineoffset(struct isp_ccdc_device *ccdc,
-					u32 offset, u8 oddeven, u8 numlines)
+				      unsigned int bpl,
+				      enum v4l2_field field)
 {
 	struct isp_device *isp = to_isp_device(ccdc);
+	u32 sdofst = 0;
 
-	isp_reg_writel(isp, offset & 0xffff,
-		       OMAP3_ISP_IOMEM_CCDC, ISPCCDC_HSIZE_OFF);
-
-	isp_reg_clr(isp, OMAP3_ISP_IOMEM_CCDC, ISPCCDC_SDOFST,
-		    ISPCCDC_SDOFST_FINV);
+	isp_reg_writel(isp, bpl & 0xffff, OMAP3_ISP_IOMEM_CCDC,
+		       ISPCCDC_HSIZE_OFF);
 
-	isp_reg_clr(isp, OMAP3_ISP_IOMEM_CCDC, ISPCCDC_SDOFST,
-		    ISPCCDC_SDOFST_FOFST_4L);
-
-	switch (oddeven) {
-	case EVENEVEN:
-		isp_reg_set(isp, OMAP3_ISP_IOMEM_CCDC, ISPCCDC_SDOFST,
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
+	switch (field) {
+	case V4L2_FIELD_INTERLACED_TB:
+	case V4L2_FIELD_INTERLACED_BT:
+		/* When interleaving fields in memory offset field one by one
+		 * line and set the line offset to two lines.
+		 */
+		sdofst |= (1 << ISPCCDC_SDOFST_LOFST0_SHIFT)
+		       |  (1 << ISPCCDC_SDOFST_LOFST1_SHIFT)
+		       |  (1 << ISPCCDC_SDOFST_LOFST2_SHIFT)
+		       |  (1 << ISPCCDC_SDOFST_LOFST3_SHIFT);
 		break;
+
 	default:
+		/* In all other cases set the line offsets to one line. */
 		break;
 	}
+
+	isp_reg_writel(isp, sdofst, OMAP3_ISP_IOMEM_CCDC, ISPCCDC_SDOFST);
 }
 
 /*
@@ -1204,7 +1203,17 @@ static void ccdc_configure(struct isp_ccdc_device *ccdc)
 			<< ISPCCDC_VERT_LINES_NLV_SHIFT,
 		       OMAP3_ISP_IOMEM_CCDC, ISPCCDC_VERT_LINES);
 
-	ccdc_config_outlineoffset(ccdc, ccdc->video_out.bpl_value, 0, 0);
+	ccdc_config_outlineoffset(ccdc, ccdc->video_out.bpl_value,
+				  format->field);
+
+	/* When interleaving fields enable processing of the field input signal.
+	 * This will cause the line output control module to apply the field
+	 * offset to field 1.
+	 */
+	if (ccdc->formats[CCDC_PAD_SINK].field == V4L2_FIELD_ALTERNATE &&
+	    (format->field == V4L2_FIELD_INTERLACED_TB ||
+	     format->field == V4L2_FIELD_INTERLACED_BT))
+		syn_mode |= ISPCCDC_SYN_MODE_FLDMODE;
 
 	/* The CCDC outputs data in UYVY order by default. Swap bytes to get
 	 * YUYV.
@@ -1484,6 +1493,7 @@ static int ccdc_isr_buffer(struct isp_ccdc_device *ccdc)
 	struct isp_pipeline *pipe = to_isp_pipeline(&ccdc->subdev.entity);
 	struct isp_device *isp = to_isp_device(ccdc);
 	struct isp_buffer *buffer;
+	enum v4l2_field field;
 
 	/* The CCDC generates VD0 interrupts even when disabled (the datasheet
 	 * doesn't explicitly state if that's supposed to happen or not, so it
@@ -1503,17 +1513,12 @@ static int ccdc_isr_buffer(struct isp_ccdc_device *ccdc)
 		return 1;
 	}
 
-	/* When capturing fields in alternate order read the current field
-	 * identifier and store it in the pipeline.
-	 */
-	if (ccdc->formats[CCDC_PAD_SOURCE_OF].field == V4L2_FIELD_ALTERNATE) {
-		u32 syn_mode = isp_reg_readl(isp, OMAP3_ISP_IOMEM_CCDC,
-					     ISPCCDC_SYN_MODE);
-
-		pipe->field = syn_mode & ISPCCDC_SYN_MODE_FLDSTAT
-			    ? V4L2_FIELD_BOTTOM : V4L2_FIELD_TOP;
-	}
+	/* Read the current field identifier. */
+	field = isp_reg_readl(isp, OMAP3_ISP_IOMEM_CCDC, ISPCCDC_SYN_MODE)
+	      & ISPCCDC_SYN_MODE_FLDSTAT
+	      ? V4L2_FIELD_BOTTOM : V4L2_FIELD_TOP;
 
+	/* Wait for the CCDC to become idle. */
 	if (ccdc_sbl_wait_idle(ccdc, 1000)) {
 		dev_info(isp->dev, "CCDC won't become idle!\n");
 		isp->crashed |= 1U << ccdc->subdev.entity.id;
@@ -1521,6 +1526,28 @@ static int ccdc_isr_buffer(struct isp_ccdc_device *ccdc)
 		return 0;
 	}
 
+	switch (ccdc->formats[CCDC_PAD_SOURCE_OF].field) {
+	case V4L2_FIELD_ALTERNATE:
+		/* When capturing fields in alternate order store the current
+		 * field identifier in the pipeline.
+		 */
+		pipe->field = field;
+		break;
+
+	case V4L2_FIELD_INTERLACED_TB:
+		/* When interleaving fields only complete the buffer after
+		 * capturing the second field.
+		 */
+		if (field == V4L2_FIELD_TOP)
+			return 1;
+		break;
+
+	case V4L2_FIELD_INTERLACED_BT:
+		if (field == V4L2_FIELD_BOTTOM)
+			return 1;
+		break;
+	}
+
 	buffer = omap3isp_video_buffer_next(&ccdc->video_out);
 	if (buffer != NULL)
 		ccdc_set_outaddr(ccdc, buffer->dma);
@@ -1829,6 +1856,7 @@ ccdc_try_format(struct isp_ccdc_device *ccdc, struct v4l2_subdev_fh *fh,
 	unsigned int width = fmt->width;
 	unsigned int height = fmt->height;
 	struct v4l2_rect *crop;
+	enum v4l2_field field;
 	unsigned int i;
 
 	switch (pad) {
@@ -1854,6 +1882,7 @@ ccdc_try_format(struct isp_ccdc_device *ccdc, struct v4l2_subdev_fh *fh,
 
 	case CCDC_PAD_SOURCE_OF:
 		pixelcode = fmt->code;
+		field = fmt->field;
 		*fmt = *__ccdc_get_format(ccdc, fh, CCDC_PAD_SINK, which);
 
 		/* YUV formats are converted from 2X8 to 1X16 by the bridge and
@@ -1878,6 +1907,17 @@ ccdc_try_format(struct isp_ccdc_device *ccdc, struct v4l2_subdev_fh *fh,
 		crop = __ccdc_get_crop(ccdc, fh, which);
 		fmt->width = crop->width;
 		fmt->height = crop->height;
+
+		/* When input format is interlaced with alternating fields the
+		 * CCDC can interleave the fields.
+		 */
+		if (fmt->field == V4L2_FIELD_ALTERNATE &&
+		    (field == V4L2_FIELD_INTERLACED_TB ||
+		     field == V4L2_FIELD_INTERLACED_BT)) {
+			fmt->field = field;
+			fmt->height *= 2;
+		}
+
 		break;
 
 	case CCDC_PAD_SOURCE_VP:
diff --git a/drivers/media/platform/omap3isp/ispreg.h b/drivers/media/platform/omap3isp/ispreg.h
index f37a8df..b5ea8da 100644
--- a/drivers/media/platform/omap3isp/ispreg.h
+++ b/drivers/media/platform/omap3isp/ispreg.h
@@ -730,17 +730,13 @@
 
 #define ISPCCDC_HSIZE_OFF_SHIFT			0
 
-#define ISPCCDC_SDOFST_FINV			(1 << 14)
-#define ISPCCDC_SDOFST_FOFST_1L			0
-#define ISPCCDC_SDOFST_FOFST_4L			(3 << 12)
+#define ISPCCDC_SDOFST_FIINV			(1 << 14)
+#define ISPCCDC_SDOFST_FOFST_SHIFT		12
+#define ISPCCDC_SDOFST_FOFST_MASK		(3 << 12)
 #define ISPCCDC_SDOFST_LOFST3_SHIFT		0
 #define ISPCCDC_SDOFST_LOFST2_SHIFT		3
 #define ISPCCDC_SDOFST_LOFST1_SHIFT		6
 #define ISPCCDC_SDOFST_LOFST0_SHIFT		9
-#define EVENEVEN				1
-#define ODDEVEN					2
-#define EVENODD					3
-#define ODDODD					4
 
 #define ISPCCDC_CLAMP_OBGAIN_SHIFT		0
 #define ISPCCDC_CLAMP_OBST_SHIFT		10
diff --git a/drivers/media/platform/omap3isp/ispvideo.c b/drivers/media/platform/omap3isp/ispvideo.c
index c38f1d4..bc38c88 100644
--- a/drivers/media/platform/omap3isp/ispvideo.c
+++ b/drivers/media/platform/omap3isp/ispvideo.c
@@ -637,14 +637,40 @@ isp_video_set_format(struct file *file, void *fh, struct v4l2_format *format)
 	if (format->type != video->type)
 		return -EINVAL;
 
-	/* Default to the progressive field order if the requested value is not
-	 * supported (or set to ANY). The only supported orders are progressive
-	 * (available on all video nodes) and alternate (available on capture
-	 * nodes only).
-	 */
-	if (format->fmt.pix.field != V4L2_FIELD_ALTERNATE ||
-	    video->type == V4L2_BUF_TYPE_VIDEO_OUTPUT)
+	/* Replace unsupported field orders with sane defaults. */
+	switch (format->fmt.pix.field) {
+	case V4L2_FIELD_NONE:
+		/* Progressive is supported everywhere. */
+		break;
+	case V4L2_FIELD_ALTERNATE:
+		/* ALTERNATE is not supported on output nodes. */
+		if (video->type == V4L2_BUF_TYPE_VIDEO_OUTPUT)
+			format->fmt.pix.field = V4L2_FIELD_NONE;
+		break;
+	case V4L2_FIELD_INTERLACED:
+		/* The ISP has no concept of video standard, select the
+		 * top-bottom order when the unqualified interlaced order is
+		 * requested.
+		 */
+		format->fmt.pix.field = V4L2_FIELD_INTERLACED_TB;
+		/* Fall-through */
+	case V4L2_FIELD_INTERLACED_TB:
+	case V4L2_FIELD_INTERLACED_BT:
+		/* Interlaced orders are only supported at the CCDC output. */
+		if (video != &video->isp->isp_ccdc.video_out)
+			format->fmt.pix.field = V4L2_FIELD_NONE;
+		break;
+	case V4L2_FIELD_TOP:
+	case V4L2_FIELD_BOTTOM:
+	case V4L2_FIELD_SEQ_TB:
+	case V4L2_FIELD_SEQ_BT:
+	default:
+		/* All other field orders are currently unsupported, default to
+		 * progressive.
+		 */
 		format->fmt.pix.field = V4L2_FIELD_NONE;
+		break;
+	}
 
 	/* Fill the bytesperline and sizeimage fields by converting to media bus
 	 * format and back to pixel format.
-- 
1.8.5.5

