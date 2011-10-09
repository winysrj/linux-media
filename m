Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:57608 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751520Ab1JICht (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 8 Oct 2011 22:37:49 -0400
Received: by mail-wy0-f174.google.com with SMTP id 34so4947103wyg.19
        for <linux-media@vger.kernel.org>; Sat, 08 Oct 2011 19:37:48 -0700 (PDT)
From: Javier Martinez Canillas <martinez.javier@gmail.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Sakari Ailus <sakari.ailus@iki.fi>,
	Enrico <ebutera@users.berlios.de>,
	Gary Thomas <gary@mlbassoc.com>,
	Adam Pledger <a.pledger@thermoteknix.com>,
	Deepthy Ravi <deepthy.ravi@ti.com>,
	linux-media@vger.kernel.org,
	Javier Martinez Canillas <martinez.javier@gmail.com>
Subject: [PATCH 2/2] omap3isp: ccdc: Add support to ITU-R BT.656 video data format
Date: Sun,  9 Oct 2011 04:37:33 +0200
Message-Id: <1318127853-1879-3-git-send-email-martinez.javier@gmail.com>
In-Reply-To: <1318127853-1879-1-git-send-email-martinez.javier@gmail.com>
References: <1318127853-1879-1-git-send-email-martinez.javier@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The ITU-R BT.656 standard data format provides interlaced video data.

This patch adds to the ISP CCDC driver the ability to deinterlace the
video data and send progressive frames to user-space applications.

The changes are:
    - Maintain two buffers (struct isp_buffer), current and last.
    - Decouple next buffer obtaining from last buffer releasing.
    - Move most of the logic to the VD1 interrupt handler since the
      ISP is not busy there.

Signed-off-by: Javier Martinez Canillas <martinez.javier@gmail.com>
---
 drivers/media/video/omap3isp/ispccdc.c |  195 ++++++++++++++++++++++----------
 drivers/media/video/omap3isp/ispccdc.h |    6 +
 include/media/omap3isp.h               |    3 +
 3 files changed, 146 insertions(+), 58 deletions(-)

diff --git a/drivers/media/video/omap3isp/ispccdc.c b/drivers/media/video/omap3isp/ispccdc.c
index c25db54..fff1ae1 100644
--- a/drivers/media/video/omap3isp/ispccdc.c
+++ b/drivers/media/video/omap3isp/ispccdc.c
@@ -40,6 +40,7 @@
 static struct v4l2_mbus_framefmt *
 __ccdc_get_format(struct isp_ccdc_device *ccdc, struct v4l2_subdev_fh *fh,
 		  unsigned int pad, enum v4l2_subdev_format_whence which);
+static bool ccdc_input_is_bt656(struct isp_ccdc_device *ccdc);
 
 static const unsigned int ccdc_fmts[] = {
 	V4L2_MBUS_FMT_Y8_1X8,
@@ -893,7 +894,7 @@ static void ccdc_config_outlineoffset(struct isp_ccdc_device *ccdc,
 		    ISPCCDC_SDOFST_FINV);
 
 	isp_reg_clr(isp, OMAP3_ISP_IOMEM_CCDC, ISPCCDC_SDOFST,
-		    ISPCCDC_SDOFST_FOFST_4L);
+		    ISPCCDC_SDOFST_FOFST_1L);
 
 	switch (oddeven) {
 	case EVENEVEN:
@@ -1010,6 +1011,9 @@ static void ccdc_config_sync_if(struct isp_ccdc_device *ccdc,
 	if (pdata && pdata->vs_pol)
 		syn_mode |= ISPCCDC_SYN_MODE_VDPOL;
 
+	if (pdata && pdata->fldmode)
+		syn_mode |= ISPCCDC_SYN_MODE_FLDMODE;
+
 	isp_reg_writel(isp, syn_mode, OMAP3_ISP_IOMEM_CCDC, ISPCCDC_SYN_MODE);
 
 	if (format->code == V4L2_MBUS_FMT_UYVY8_2X8)
@@ -1115,6 +1119,10 @@ static void ccdc_configure(struct isp_ccdc_device *ccdc)
 	unsigned int shift;
 	u32 syn_mode;
 	u32 ccdc_pattern;
+	u32 nph;
+	u32 nlv;
+	u32 vd0;
+	u32 vd1;
 
 	pad = media_entity_remote_source(&ccdc->pads[CCDC_PAD_SINK]);
 	sensor = media_entity_to_v4l2_subdev(pad->entity);
@@ -1185,26 +1193,44 @@ static void ccdc_configure(struct isp_ccdc_device *ccdc)
 	}
 	ccdc_config_imgattr(ccdc, ccdc_pattern);
 
+	if (pdata->bt656) {
+		vd0 = nlv = format->height / 2 - 1;
+		vd1 = format->height / 3 - 1;
+		nph = format->width * 2 - 1;
+	} else {
+		vd0 = nlv = format->height - 2;
+		vd1 = format->height * 2 / 3;
+		nph = format->width - 1;
+	}
+
 	/* Generate VD0 on the last line of the image and VD1 on the
 	 * 2/3 height line.
 	 */
-	isp_reg_writel(isp, ((format->height - 2) << ISPCCDC_VDINT_0_SHIFT) |
-		       ((format->height * 2 / 3) << ISPCCDC_VDINT_1_SHIFT),
+	isp_reg_writel(isp, (vd0 << ISPCCDC_VDINT_0_SHIFT) |
+		       (vd1 << ISPCCDC_VDINT_1_SHIFT),
 		       OMAP3_ISP_IOMEM_CCDC, ISPCCDC_VDINT);
 
 	/* CCDC_PAD_SOURCE_OF */
 	format = &ccdc->formats[CCDC_PAD_SOURCE_OF];
 
 	isp_reg_writel(isp, (0 << ISPCCDC_HORZ_INFO_SPH_SHIFT) |
-		       ((format->width - 1) << ISPCCDC_HORZ_INFO_NPH_SHIFT),
+		       (nph << ISPCCDC_HORZ_INFO_NPH_SHIFT),
 		       OMAP3_ISP_IOMEM_CCDC, ISPCCDC_HORZ_INFO);
+	isp_reg_writel(isp, nlv << ISPCCDC_VERT_LINES_NLV_SHIFT,
+		       OMAP3_ISP_IOMEM_CCDC, ISPCCDC_VERT_LINES);
 	isp_reg_writel(isp, 0 << ISPCCDC_VERT_START_SLV0_SHIFT,
 		       OMAP3_ISP_IOMEM_CCDC, ISPCCDC_VERT_START);
-	isp_reg_writel(isp, (format->height - 1)
-			<< ISPCCDC_VERT_LINES_NLV_SHIFT,
-		       OMAP3_ISP_IOMEM_CCDC, ISPCCDC_VERT_LINES);
+	isp_reg_writel(isp, 0 << ISPCCDC_VERT_START_SLV1_SHIFT,
+		       OMAP3_ISP_IOMEM_CCDC, ISPCCDC_VERT_START);
 
-	ccdc_config_outlineoffset(ccdc, ccdc->video_out.bpl_value, 0, 0);
+
+	if (pdata->bt656) {
+		ccdc_config_outlineoffset(ccdc, nph, EVENEVEN, 1);
+		ccdc_config_outlineoffset(ccdc, nph, EVENODD, 1);
+		ccdc_config_outlineoffset(ccdc, nph, ODDEVEN, 1);
+		ccdc_config_outlineoffset(ccdc, nph, ODDODD, 1);
+	} else
+		ccdc_config_outlineoffset(ccdc, ccdc->video_out.bpl_value, 0, 0);
 
 	/* CCDC_PAD_SOURCE_VP */
 	format = &ccdc->formats[CCDC_PAD_SOURCE_VP];
@@ -1212,13 +1238,12 @@ static void ccdc_configure(struct isp_ccdc_device *ccdc)
 	isp_reg_writel(isp, (0 << ISPCCDC_FMT_HORZ_FMTSPH_SHIFT) |
 		       (format->width << ISPCCDC_FMT_HORZ_FMTLNH_SHIFT),
 		       OMAP3_ISP_IOMEM_CCDC, ISPCCDC_FMT_HORZ);
-	isp_reg_writel(isp, (0 << ISPCCDC_FMT_VERT_FMTSLV_SHIFT) |
-		       ((format->height + 1) << ISPCCDC_FMT_VERT_FMTLNV_SHIFT),
-		       OMAP3_ISP_IOMEM_CCDC, ISPCCDC_FMT_VERT);
-
 	isp_reg_writel(isp, (format->width << ISPCCDC_VP_OUT_HORZ_NUM_SHIFT) |
 		       (format->height << ISPCCDC_VP_OUT_VERT_NUM_SHIFT),
 		       OMAP3_ISP_IOMEM_CCDC, ISPCCDC_VP_OUT);
+	isp_reg_writel(isp, (0 << ISPCCDC_FMT_VERT_FMTSLV_SHIFT) |
+		       ((format->height + 1) << ISPCCDC_FMT_VERT_FMTLNV_SHIFT),
+		       OMAP3_ISP_IOMEM_CCDC, ISPCCDC_FMT_VERT);
 
 	/* Use PACK8 mode for 1byte per pixel formats. */
 	if (omap3isp_video_format_info(format->code)->width <= 8)
@@ -1464,6 +1489,19 @@ done:
 	spin_unlock_irqrestore(&ccdc->lsc.req_lock, flags);
 }
 
+static void ccdc_release_buffer(struct isp_buffer *buffer, int error)
+{
+	buffer->buffer.state = error ? ISP_BUF_STATE_ERROR : ISP_BUF_STATE_DONE;
+	wake_up(&buffer->buffer.wait);
+}
+
+static void ccdc_release_last_buffer(struct isp_ccdc_device *ccdc)
+{
+	struct isp_buffer *buffer = ccdc->last_buffer;
+	ccdc->last_buffer = NULL;
+	ccdc_release_buffer(buffer, ccdc->error);
+}
+
 static int ccdc_isr_buffer(struct isp_ccdc_device *ccdc)
 {
 	struct isp_pipeline *pipe = to_isp_pipeline(&ccdc->subdev.entity);
@@ -1495,11 +1533,19 @@ static int ccdc_isr_buffer(struct isp_ccdc_device *ccdc)
 		goto done;
 	}
 
-	buffer = omap3isp_video_buffer_next(&ccdc->video_out, ccdc->error);
-	if (buffer != NULL) {
-		ccdc_set_outaddr(ccdc, buffer->isp_addr);
+	if (!ccdc_input_is_bt656(ccdc)) {
+		ccdc->last_buffer = ccdc->current_buffer;
+		buffer = omap3isp_video_buffer_next(&ccdc->video_out,
+						    ccdc->error);
+		if (buffer != NULL) {
+			ccdc_set_outaddr(ccdc, buffer->isp_addr);
+			restart = 1;
+		}
+		ccdc->current_buffer = buffer;
+		if (ccdc->last_buffer)
+			ccdc_release_last_buffer(ccdc);
+	} else
 		restart = 1;
-	}
 
 	pipe->state |= ISP_PIPELINE_IDLE_OUTPUT;
 
@@ -1541,6 +1587,16 @@ static void ccdc_vd0_isr(struct isp_ccdc_device *ccdc)
 		ccdc_enable(ccdc);
 }
 
+static inline struct isp_buffer *ccdc_getbuffer(struct isp_ccdc_device *ccdc)
+{
+	return omap3isp_video_buffer_next(&ccdc->video_out, ccdc->error);
+}
+
+static inline void ccdc_set_next_buffer(struct isp_ccdc_device *ccdc)
+{
+	ccdc_set_outaddr(ccdc, ccdc->current_buffer->isp_addr);
+}
+
 /*
  * ccdc_vd1_isr - Handle VD1 event
  * @ccdc: Pointer to ISP CCDC device.
@@ -1549,57 +1605,77 @@ static void ccdc_vd1_isr(struct isp_ccdc_device *ccdc)
 {
 	unsigned long flags;
 
-	spin_lock_irqsave(&ccdc->lsc.req_lock, flags);
+	if (ccdc_input_is_bt656(ccdc)) {
+		if (ccdc->interlaced_cnt) {
+			ccdc->interlaced_cnt = 0;
+			ccdc->last_buffer = ccdc->current_buffer;
+			if (!list_empty(&ccdc->video_out.dmaqueue)) {
+				ccdc->current_buffer =
+					ccdc_getbuffer(ccdc);
+				if (ccdc->current_buffer != NULL)
+					ccdc_set_next_buffer(ccdc);
+			} else
+				ccdc->current_buffer = NULL;
+		} else {
+			ccdc->interlaced_cnt = 1;
+			if (ccdc->last_buffer)
+				ccdc_release_last_buffer(ccdc);
+		}
+	} else {
 
-	/*
-	 * Depending on the CCDC pipeline state, CCDC stopping should be
-	 * handled differently. In SINGLESHOT we emulate an internal CCDC
-	 * stopping because the CCDC hw works only in continuous mode.
-	 * When CONTINUOUS pipeline state is used and the CCDC writes it's
-	 * data to memory the CCDC and LSC are stopped immediately but
-	 * without change the CCDC stopping state machine. The CCDC
-	 * stopping state machine should be used only when user request
-	 * for stopping is received (SINGLESHOT is an exeption).
-	 */
-	switch (ccdc->state) {
-	case ISP_PIPELINE_STREAM_SINGLESHOT:
-		ccdc->stopping = CCDC_STOP_REQUEST;
-		break;
+		spin_lock_irqsave(&ccdc->lsc.req_lock, flags);
 
-	case ISP_PIPELINE_STREAM_CONTINUOUS:
-		if (ccdc->output & CCDC_OUTPUT_MEMORY) {
-			if (ccdc->lsc.state != LSC_STATE_STOPPED)
-				__ccdc_lsc_enable(ccdc, 0);
-			__ccdc_enable(ccdc, 0);
-		}
-		break;
+		/*
+		 * Depending on the CCDC pipeline state, CCDC stopping should be
+		 * handled differently. In SINGLESHOT we emulate an internal CCDC
+		 * stopping because the CCDC hw works only in continuous mode.
+		 * When CONTINUOUS pipeline state is used and the CCDC writes it's
+		 * data to memory the CCDC and LSC are stopped immediately but
+		 * without change the CCDC stopping state machine. The CCDC
+		 * stopping state machine should be used only when user request
+		 * for stopping is received (SINGLESHOT is an exeption).
+		 */
+		switch (ccdc->state) {
+		case ISP_PIPELINE_STREAM_SINGLESHOT:
+			ccdc->stopping = CCDC_STOP_REQUEST;
+			break;
 
-	case ISP_PIPELINE_STREAM_STOPPED:
-		break;
-	}
+		case ISP_PIPELINE_STREAM_CONTINUOUS:
+			if (ccdc->output & CCDC_OUTPUT_MEMORY) {
+				if (ccdc->lsc.state != LSC_STATE_STOPPED)
+					__ccdc_lsc_enable(ccdc, 0);
+				__ccdc_enable(ccdc, 0);
+			}
+			break;
 
-	if (__ccdc_handle_stopping(ccdc, CCDC_EVENT_VD1))
-		goto done;
+		case ISP_PIPELINE_STREAM_STOPPED:
+			break;
+		}
 
-	if (ccdc->lsc.request == NULL)
-		goto done;
+		if (__ccdc_handle_stopping(ccdc, CCDC_EVENT_VD1))
+			goto done;
 
-	/*
-	 * LSC need to be reconfigured. Stop it here and on next LSC_DONE IRQ
-	 * do the appropriate changes in registers
-	 */
-	if (ccdc->lsc.state == LSC_STATE_RUNNING) {
-		__ccdc_lsc_enable(ccdc, 0);
-		ccdc->lsc.state = LSC_STATE_RECONFIG;
-		goto done;
-	}
+		if (ccdc->lsc.request == NULL)
+			goto done;
 
-	/* LSC has been in STOPPED state, enable it */
-	if (ccdc->lsc.state == LSC_STATE_STOPPED)
-		ccdc_lsc_enable(ccdc);
+		/*
+		 * LSC need to be reconfigured. Stop it here and on next
+		 * LSC_DONE IRQ do the appropriate changes in registers
+		 */
+		if (ccdc->lsc.state == LSC_STATE_RUNNING) {
+			__ccdc_lsc_enable(ccdc, 0);
+			ccdc->lsc.state = LSC_STATE_RECONFIG;
+			goto done;
+		}
+
+		/* LSC has been in STOPPED state, enable it */
+		if (ccdc->lsc.state == LSC_STATE_STOPPED)
+			ccdc_lsc_enable(ccdc);
 
 done:
-	spin_unlock_irqrestore(&ccdc->lsc.req_lock, flags);
+		spin_unlock_irqrestore(&ccdc->lsc.req_lock, flags);
+
+	}
 }
 
 /*
@@ -1638,6 +1714,7 @@ static int ccdc_video_queue(struct isp_video *video, struct isp_buffer *buffer)
 		return -ENODEV;
 
 	ccdc_set_outaddr(ccdc, buffer->isp_addr);
+	ccdc->current_buffer = buffer;
 
 	/* We now have a buffer queued on the output, restart the pipeline
 	 * on the next CCDC interrupt if running in continuous mode (or when
@@ -1764,6 +1841,8 @@ static int ccdc_set_stream(struct v4l2_subdev *sd, int enable)
 			omap3isp_sbl_disable(isp, OMAP3_ISP_SBL_CCDC_WRITE);
 		omap3isp_subclk_disable(isp, OMAP3_ISP_SUBCLK_CCDC);
 		ccdc->underrun = 0;
+		ccdc->current_buffer = NULL;
+		ccdc->interlaced_cnt = 0;
 		break;
 	}
 
diff --git a/drivers/media/video/omap3isp/ispccdc.h b/drivers/media/video/omap3isp/ispccdc.h
index 54811ce..dad021c 100644
--- a/drivers/media/video/omap3isp/ispccdc.h
+++ b/drivers/media/video/omap3isp/ispccdc.h
@@ -134,6 +134,9 @@ struct ispccdc_lsc {
  * @wait: Wait queue used to stop the module
  * @stopping: Stopping state
  * @ioctl_lock: Serializes ioctl calls and LSC requests freeing
+ * @current_buffer: Buffer for current frame
+ * @last_buffer: Buffer used for the last frame
+ * @interlaced_cnt: Sub-frame count for an interlaced video frame
  */
 struct isp_ccdc_device {
 	struct v4l2_subdev subdev;
@@ -164,6 +167,9 @@ struct isp_ccdc_device {
 	wait_queue_head_t wait;
 	unsigned int stopping;
 	struct mutex ioctl_lock;
+	struct isp_buffer *current_buffer;
+	struct isp_buffer *last_buffer;
+	unsigned int interlaced_cnt;
 };
 
 struct isp_device;
diff --git a/include/media/omap3isp.h b/include/media/omap3isp.h
index 3b2d2b7..0f215de 100644
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
-- 
1.7.4.1

