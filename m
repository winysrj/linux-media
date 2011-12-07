Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:57344 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755801Ab1LGNqc (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 7 Dec 2011 08:46:32 -0500
Received: from localhost.localdomain (unknown [91.178.3.157])
	by perceval.ideasonboard.com (Postfix) with ESMTPSA id 1D53F35AA7
	for <linux-media@vger.kernel.org>; Wed,  7 Dec 2011 13:46:31 +0000 (UTC)
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Subject: [PATCH] omap3isp: Mark next captured frame as faulty when an SBL overflow occurs
Date: Wed,  7 Dec 2011 14:46:38 +0100
Message-Id: <1323265598-19207-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Instead of trying to propagate errors down the pipeline manually (and
failing to do so properly in all cases), flag SBL errors in the pipeline
to which the entity that triggered the error belongs, and use pipeline
error flags to mark buffers as faulty when completing them.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/media/video/omap3isp/isp.c        |   53 ++++++++++++++++-------------
 drivers/media/video/omap3isp/ispccdc.c    |    7 ++--
 drivers/media/video/omap3isp/ispccdc.h    |    2 -
 drivers/media/video/omap3isp/ispccp2.c    |   20 ++++-------
 drivers/media/video/omap3isp/ispccp2.h    |    3 +-
 drivers/media/video/omap3isp/ispcsi2.c    |   18 ++++------
 drivers/media/video/omap3isp/ispcsi2.h    |    2 +-
 drivers/media/video/omap3isp/isppreview.c |    9 +----
 drivers/media/video/omap3isp/isppreview.h |    2 -
 drivers/media/video/omap3isp/ispresizer.c |    7 +---
 drivers/media/video/omap3isp/ispresizer.h |    1 -
 drivers/media/video/omap3isp/ispvideo.c   |   13 +++++--
 drivers/media/video/omap3isp/ispvideo.h   |    8 +++-
 13 files changed, 68 insertions(+), 77 deletions(-)

diff --git a/drivers/media/video/omap3isp/isp.c b/drivers/media/video/omap3isp/isp.c
index 172e811..09874a7 100644
--- a/drivers/media/video/omap3isp/isp.c
+++ b/drivers/media/video/omap3isp/isp.c
@@ -410,6 +410,7 @@ static inline void isp_isr_dbg(struct isp_device *isp, u32 irqstatus)
 static void isp_isr_sbl(struct isp_device *isp)
 {
 	struct device *dev = isp->dev;
+	struct isp_pipeline *pipe;
 	u32 sbl_pcr;
 
 	/*
@@ -423,27 +424,38 @@ static void isp_isr_sbl(struct isp_device *isp)
 	if (sbl_pcr)
 		dev_dbg(dev, "SBL overflow (PCR = 0x%08x)\n", sbl_pcr);
 
-	if (sbl_pcr & (ISPSBL_PCR_CCDC_WBL_OVF | ISPSBL_PCR_CSIA_WBL_OVF
-		     | ISPSBL_PCR_CSIB_WBL_OVF)) {
-		isp->isp_ccdc.error = 1;
-		if (isp->isp_ccdc.output & CCDC_OUTPUT_PREVIEW)
-			isp->isp_prev.error = 1;
-		if (isp->isp_ccdc.output & CCDC_OUTPUT_RESIZER)
-			isp->isp_res.error = 1;
+	if (sbl_pcr & ISPSBL_PCR_CSIB_WBL_OVF) {
+		pipe = to_isp_pipeline(&isp->isp_ccp2.subdev.entity);
+		if (pipe != NULL)
+			pipe->error = true;
+	}
+
+	if (sbl_pcr & (ISPSBL_PCR_CSIA_WBL_OVF)) {
+		pipe = to_isp_pipeline(&isp->isp_csi2a.subdev.entity);
+		if (pipe != NULL)
+			pipe->error = true;
+	}
+
+	if (sbl_pcr & ISPSBL_PCR_CCDC_WBL_OVF) {
+		pipe = to_isp_pipeline(&isp->isp_ccdc.subdev.entity);
+		if (pipe != NULL)
+			pipe->error = true;
 	}
 
 	if (sbl_pcr & ISPSBL_PCR_PRV_WBL_OVF) {
-		isp->isp_prev.error = 1;
-		if (isp->isp_res.input == RESIZER_INPUT_VP &&
-		    !(isp->isp_ccdc.output & CCDC_OUTPUT_RESIZER))
-			isp->isp_res.error = 1;
+		pipe = to_isp_pipeline(&isp->isp_prev.subdev.entity);
+		if (pipe != NULL)
+			pipe->error = true;
 	}
 
 	if (sbl_pcr & (ISPSBL_PCR_RSZ1_WBL_OVF
 		       | ISPSBL_PCR_RSZ2_WBL_OVF
 		       | ISPSBL_PCR_RSZ3_WBL_OVF
-		       | ISPSBL_PCR_RSZ4_WBL_OVF))
-		isp->isp_res.error = 1;
+		       | ISPSBL_PCR_RSZ4_WBL_OVF)) {
+		pipe = to_isp_pipeline(&isp->isp_res.subdev.entity);
+		if (pipe != NULL)
+			pipe->error = true;
+	}
 
 	if (sbl_pcr & ISPSBL_PCR_H3A_AF_WBL_OVF)
 		omap3isp_stat_sbl_overflow(&isp->isp_af);
@@ -471,24 +483,17 @@ static irqreturn_t isp_isr(int irq, void *_isp)
 				       IRQ0STATUS_HS_VS_IRQ;
 	struct isp_device *isp = _isp;
 	u32 irqstatus;
-	int ret;
 
 	irqstatus = isp_reg_readl(isp, OMAP3_ISP_IOMEM_MAIN, ISP_IRQ0STATUS);
 	isp_reg_writel(isp, irqstatus, OMAP3_ISP_IOMEM_MAIN, ISP_IRQ0STATUS);
 
 	isp_isr_sbl(isp);
 
-	if (irqstatus & IRQ0STATUS_CSIA_IRQ) {
-		ret = omap3isp_csi2_isr(&isp->isp_csi2a);
-		if (ret)
-			isp->isp_ccdc.error = 1;
-	}
+	if (irqstatus & IRQ0STATUS_CSIA_IRQ)
+		omap3isp_csi2_isr(&isp->isp_csi2a);
 
-	if (irqstatus & IRQ0STATUS_CSIB_IRQ) {
-		ret = omap3isp_ccp2_isr(&isp->isp_ccp2);
-		if (ret)
-			isp->isp_ccdc.error = 1;
-	}
+	if (irqstatus & IRQ0STATUS_CSIB_IRQ)
+		omap3isp_ccp2_isr(&isp->isp_ccp2);
 
 	if (irqstatus & IRQ0STATUS_CCDC_VD0_IRQ) {
 		if (isp->isp_ccdc.output & CCDC_OUTPUT_PREVIEW)
diff --git a/drivers/media/video/omap3isp/ispccdc.c b/drivers/media/video/omap3isp/ispccdc.c
index a319281..18e96bd 100644
--- a/drivers/media/video/omap3isp/ispccdc.c
+++ b/drivers/media/video/omap3isp/ispccdc.c
@@ -1424,11 +1424,12 @@ static void ccdc_hs_vs_isr(struct isp_ccdc_device *ccdc)
  */
 static void ccdc_lsc_isr(struct isp_ccdc_device *ccdc, u32 events)
 {
+	struct isp_pipeline *pipe = to_isp_pipeline(&ccdc->subdev.entity);
 	unsigned long flags;
 
 	if (events & IRQ0STATUS_CCDC_LSC_PREF_ERR_IRQ) {
 		ccdc_lsc_error_handler(ccdc);
-		ccdc->error = 1;
+		pipe->error = true;
 		dev_dbg(to_device(ccdc), "lsc prefetch error\n");
 	}
 
@@ -1503,7 +1504,7 @@ static int ccdc_isr_buffer(struct isp_ccdc_device *ccdc)
 		goto done;
 	}
 
-	buffer = omap3isp_video_buffer_next(&ccdc->video_out, ccdc->error);
+	buffer = omap3isp_video_buffer_next(&ccdc->video_out);
 	if (buffer != NULL) {
 		ccdc_set_outaddr(ccdc, buffer->isp_addr);
 		restart = 1;
@@ -1517,7 +1518,6 @@ static int ccdc_isr_buffer(struct isp_ccdc_device *ccdc)
 					ISP_PIPELINE_STREAM_SINGLESHOT);
 
 done:
-	ccdc->error = 0;
 	return restart;
 }
 
@@ -1743,7 +1743,6 @@ static int ccdc_set_stream(struct v4l2_subdev *sd, int enable)
 		 */
 		ccdc_config_vp(ccdc);
 		ccdc_enable_vp(ccdc, 1);
-		ccdc->error = 0;
 		ccdc_print_status(ccdc);
 	}
 
diff --git a/drivers/media/video/omap3isp/ispccdc.h b/drivers/media/video/omap3isp/ispccdc.h
index 483a19c..6d0264b 100644
--- a/drivers/media/video/omap3isp/ispccdc.h
+++ b/drivers/media/video/omap3isp/ispccdc.h
@@ -150,7 +150,6 @@ struct ispccdc_lsc {
  * @input: Active input
  * @output: Active outputs
  * @video_out: Output video node
- * @error: A hardware error occurred during capture
  * @alaw: A-law compression enabled (1) or disabled (0)
  * @lpf: Low pass filter enabled (1) or disabled (0)
  * @obclamp: Optical-black clamp enabled (1) or disabled (0)
@@ -178,7 +177,6 @@ struct isp_ccdc_device {
 	enum ccdc_input_entity input;
 	unsigned int output;
 	struct isp_video video_out;
-	unsigned int error;
 
 	unsigned int alaw:1,
 		     lpf:1,
diff --git a/drivers/media/video/omap3isp/ispccp2.c b/drivers/media/video/omap3isp/ispccp2.c
index 904ca8c..177880a 100644
--- a/drivers/media/video/omap3isp/ispccp2.c
+++ b/drivers/media/video/omap3isp/ispccp2.c
@@ -556,7 +556,7 @@ static void ccp2_isr_buffer(struct isp_ccp2_device *ccp2)
 	struct isp_pipeline *pipe = to_isp_pipeline(&ccp2->subdev.entity);
 	struct isp_buffer *buffer;
 
-	buffer = omap3isp_video_buffer_next(&ccp2->video_in, ccp2->error);
+	buffer = omap3isp_video_buffer_next(&ccp2->video_in);
 	if (buffer != NULL)
 		ccp2_set_inaddr(ccp2, buffer->isp_addr);
 
@@ -567,8 +567,6 @@ static void ccp2_isr_buffer(struct isp_ccp2_device *ccp2)
 			omap3isp_pipeline_set_stream(pipe,
 						ISP_PIPELINE_STREAM_SINGLESHOT);
 	}
-
-	ccp2->error = 0;
 }
 
 /*
@@ -579,10 +577,10 @@ static void ccp2_isr_buffer(struct isp_ccp2_device *ccp2)
  *
  * Returns -EIO in case of error, or 0 on success.
  */
-int omap3isp_ccp2_isr(struct isp_ccp2_device *ccp2)
+void omap3isp_ccp2_isr(struct isp_ccp2_device *ccp2)
 {
+	struct isp_pipeline *pipe = to_isp_pipeline(&ccp2->subdev.entity);
 	struct isp_device *isp = to_isp_device(ccp2);
-	int ret = 0;
 	static const u32 ISPCCP2_LC01_ERROR =
 		ISPCCP2_LC01_IRQSTATUS_LC0_FIFO_OVF_IRQ |
 		ISPCCP2_LC01_IRQSTATUS_LC0_CRC_IRQ |
@@ -604,19 +602,18 @@ int omap3isp_ccp2_isr(struct isp_ccp2_device *ccp2)
 		       ISPCCP2_LCM_IRQSTATUS);
 	/* Errors */
 	if (lcx_irqstatus & ISPCCP2_LC01_ERROR) {
-		ccp2->error = 1;
+		pipe->error = true;
 		dev_dbg(isp->dev, "CCP2 err:%x\n", lcx_irqstatus);
-		return -EIO;
+		return;
 	}
 
 	if (lcm_irqstatus & ISPCCP2_LCM_IRQSTATUS_OCPERROR_IRQ) {
-		ccp2->error = 1;
+		pipe->error = true;
 		dev_dbg(isp->dev, "CCP2 OCP err:%x\n", lcm_irqstatus);
-		ret = -EIO;
 	}
 
 	if (omap3isp_module_sync_is_stopping(&ccp2->wait, &ccp2->stopping))
-		return 0;
+		return;
 
 	/* Frame number propagation */
 	if (lcx_irqstatus & ISPCCP2_LC01_IRQSTATUS_LC0_FS_IRQ) {
@@ -629,8 +626,6 @@ int omap3isp_ccp2_isr(struct isp_ccp2_device *ccp2)
 	/* Handle queued buffers on frame end interrupts */
 	if (lcm_irqstatus & ISPCCP2_LCM_IRQSTATUS_EOF_IRQ)
 		ccp2_isr_buffer(ccp2);
-
-	return ret;
 }
 
 /* -----------------------------------------------------------------------------
@@ -867,7 +862,6 @@ static int ccp2_s_stream(struct v4l2_subdev *sd, int enable)
 		if (enable == ISP_PIPELINE_STREAM_STOPPED)
 			return 0;
 		atomic_set(&ccp2->stopping, 0);
-		ccp2->error = 0;
 	}
 
 	switch (enable) {
diff --git a/drivers/media/video/omap3isp/ispccp2.h b/drivers/media/video/omap3isp/ispccp2.h
index 6674e9d..76d65f4 100644
--- a/drivers/media/video/omap3isp/ispccp2.h
+++ b/drivers/media/video/omap3isp/ispccp2.h
@@ -82,7 +82,6 @@ struct isp_ccp2_device {
 	struct isp_video video_in;
 	struct isp_csiphy *phy;
 	struct regulator *vdds_csib;
-	unsigned int error;
 	enum isp_pipeline_stream_state state;
 	wait_queue_head_t wait;
 	atomic_t stopping;
@@ -94,6 +93,6 @@ void omap3isp_ccp2_cleanup(struct isp_device *isp);
 int omap3isp_ccp2_register_entities(struct isp_ccp2_device *ccp2,
 			struct v4l2_device *vdev);
 void omap3isp_ccp2_unregister_entities(struct isp_ccp2_device *ccp2);
-int omap3isp_ccp2_isr(struct isp_ccp2_device *ccp2);
+void omap3isp_ccp2_isr(struct isp_ccp2_device *ccp2);
 
 #endif	/* OMAP3_ISP_CCP2_H */
diff --git a/drivers/media/video/omap3isp/ispcsi2.c b/drivers/media/video/omap3isp/ispcsi2.c
index 0c5f1cb..fcb5168 100644
--- a/drivers/media/video/omap3isp/ispcsi2.c
+++ b/drivers/media/video/omap3isp/ispcsi2.c
@@ -667,7 +667,7 @@ static void csi2_isr_buffer(struct isp_csi2_device *csi2)
 
 	csi2_ctx_enable(isp, csi2, 0, 0);
 
-	buffer = omap3isp_video_buffer_next(&csi2->video_out, 0);
+	buffer = omap3isp_video_buffer_next(&csi2->video_out);
 
 	/*
 	 * Let video queue operation restart engine if there is an underrun
@@ -727,17 +727,15 @@ static void csi2_isr_ctx(struct isp_csi2_device *csi2,
 
 /*
  * omap3isp_csi2_isr - CSI2 interrupt handling.
- *
- * Return -EIO on Transmission error
  */
-int omap3isp_csi2_isr(struct isp_csi2_device *csi2)
+void omap3isp_csi2_isr(struct isp_csi2_device *csi2)
 {
+	struct isp_pipeline *pipe = to_isp_pipeline(&csi2->subdev.entity);
 	u32 csi2_irqstatus, cpxio1_irqstatus;
 	struct isp_device *isp = csi2->isp;
-	int retval = 0;
 
 	if (!csi2->available)
-		return -ENODEV;
+		return;
 
 	csi2_irqstatus = isp_reg_readl(isp, csi2->regs1, ISPCSI2_IRQSTATUS);
 	isp_reg_writel(isp, csi2_irqstatus, csi2->regs1, ISPCSI2_IRQSTATUS);
@@ -750,7 +748,7 @@ int omap3isp_csi2_isr(struct isp_csi2_device *csi2)
 			       csi2->regs1, ISPCSI2_PHY_IRQSTATUS);
 		dev_dbg(isp->dev, "CSI2: ComplexIO Error IRQ "
 			"%x\n", cpxio1_irqstatus);
-		retval = -EIO;
+		pipe->error = true;
 	}
 
 	if (csi2_irqstatus & (ISPCSI2_IRQSTATUS_OCP_ERR_IRQ |
@@ -775,11 +773,11 @@ int omap3isp_csi2_isr(struct isp_csi2_device *csi2)
 			 ISPCSI2_IRQSTATUS_COMPLEXIO2_ERR_IRQ) ? 1 : 0,
 			(csi2_irqstatus &
 			 ISPCSI2_IRQSTATUS_FIFO_OVF_IRQ) ? 1 : 0);
-		retval = -EIO;
+		pipe->error = true;
 	}
 
 	if (omap3isp_module_sync_is_stopping(&csi2->wait, &csi2->stopping))
-		return 0;
+		return;
 
 	/* Successful cases */
 	if (csi2_irqstatus & ISPCSI2_IRQSTATUS_CONTEXT(0))
@@ -787,8 +785,6 @@ int omap3isp_csi2_isr(struct isp_csi2_device *csi2)
 
 	if (csi2_irqstatus & ISPCSI2_IRQSTATUS_ECC_CORRECTION_IRQ)
 		dev_dbg(isp->dev, "CSI2: ECC correction done\n");
-
-	return retval;
 }
 
 /* -----------------------------------------------------------------------------
diff --git a/drivers/media/video/omap3isp/ispcsi2.h b/drivers/media/video/omap3isp/ispcsi2.h
index 456fb7f..885ad79 100644
--- a/drivers/media/video/omap3isp/ispcsi2.h
+++ b/drivers/media/video/omap3isp/ispcsi2.h
@@ -156,7 +156,7 @@ struct isp_csi2_device {
 	atomic_t stopping;
 };
 
-int omap3isp_csi2_isr(struct isp_csi2_device *csi2);
+void omap3isp_csi2_isr(struct isp_csi2_device *csi2);
 int omap3isp_csi2_reset(struct isp_csi2_device *csi2);
 int omap3isp_csi2_init(struct isp_device *isp);
 void omap3isp_csi2_cleanup(struct isp_device *isp);
diff --git a/drivers/media/video/omap3isp/isppreview.c b/drivers/media/video/omap3isp/isppreview.c
index 28a1232..6d0fb2c 100644
--- a/drivers/media/video/omap3isp/isppreview.c
+++ b/drivers/media/video/omap3isp/isppreview.c
@@ -1404,16 +1404,14 @@ static void preview_isr_buffer(struct isp_prev_device *prev)
 	int restart = 0;
 
 	if (prev->input == PREVIEW_INPUT_MEMORY) {
-		buffer = omap3isp_video_buffer_next(&prev->video_in,
-						    prev->error);
+		buffer = omap3isp_video_buffer_next(&prev->video_in);
 		if (buffer != NULL)
 			preview_set_inaddr(prev, buffer->isp_addr);
 		pipe->state |= ISP_PIPELINE_IDLE_INPUT;
 	}
 
 	if (prev->output & PREVIEW_OUTPUT_MEMORY) {
-		buffer = omap3isp_video_buffer_next(&prev->video_out,
-						    prev->error);
+		buffer = omap3isp_video_buffer_next(&prev->video_out);
 		if (buffer != NULL) {
 			preview_set_outaddr(prev, buffer->isp_addr);
 			restart = 1;
@@ -1440,8 +1438,6 @@ static void preview_isr_buffer(struct isp_prev_device *prev)
 	default:
 		return;
 	}
-
-	prev->error = 0;
 }
 
 /*
@@ -1565,7 +1561,6 @@ static int preview_set_stream(struct v4l2_subdev *sd, int enable)
 		omap3isp_subclk_enable(isp, OMAP3_ISP_SUBCLK_PREVIEW);
 		preview_configure(prev);
 		atomic_set(&prev->stopping, 0);
-		prev->error = 0;
 		preview_print_status(prev);
 	}
 
diff --git a/drivers/media/video/omap3isp/isppreview.h b/drivers/media/video/omap3isp/isppreview.h
index f54e775..0968660 100644
--- a/drivers/media/video/omap3isp/isppreview.h
+++ b/drivers/media/video/omap3isp/isppreview.h
@@ -157,7 +157,6 @@ struct isptables_update {
  * @output: Bitmask of the active output
  * @video_in: Input video entity
  * @video_out: Output video entity
- * @error: A hardware error occurred during capture
  * @params: Module configuration data
  * @shadow_update: If set, update the hardware configured in the next interrupt
  * @underrun: Whether the preview entity has queued buffers on the output
@@ -179,7 +178,6 @@ struct isp_prev_device {
 	unsigned int output;
 	struct isp_video video_in;
 	struct isp_video video_out;
-	unsigned int error;
 
 	struct prev_params params;
 	unsigned int shadow_update:1;
diff --git a/drivers/media/video/omap3isp/ispresizer.c b/drivers/media/video/omap3isp/ispresizer.c
index 50e593b..6958a9e 100644
--- a/drivers/media/video/omap3isp/ispresizer.c
+++ b/drivers/media/video/omap3isp/ispresizer.c
@@ -1038,7 +1038,7 @@ static void resizer_isr_buffer(struct isp_res_device *res)
 	/* Complete the output buffer and, if reading from memory, the input
 	 * buffer.
 	 */
-	buffer = omap3isp_video_buffer_next(&res->video_out, res->error);
+	buffer = omap3isp_video_buffer_next(&res->video_out);
 	if (buffer != NULL) {
 		resizer_set_outaddr(res, buffer->isp_addr);
 		restart = 1;
@@ -1047,7 +1047,7 @@ static void resizer_isr_buffer(struct isp_res_device *res)
 	pipe->state |= ISP_PIPELINE_IDLE_OUTPUT;
 
 	if (res->input == RESIZER_INPUT_MEMORY) {
-		buffer = omap3isp_video_buffer_next(&res->video_in, 0);
+		buffer = omap3isp_video_buffer_next(&res->video_in);
 		if (buffer != NULL)
 			resizer_set_inaddr(res, buffer->isp_addr);
 		pipe->state |= ISP_PIPELINE_IDLE_INPUT;
@@ -1064,8 +1064,6 @@ static void resizer_isr_buffer(struct isp_res_device *res)
 		if (restart)
 			resizer_enable_oneshot(res);
 	}
-
-	res->error = 0;
 }
 
 /*
@@ -1154,7 +1152,6 @@ static int resizer_set_stream(struct v4l2_subdev *sd, int enable)
 
 		omap3isp_subclk_enable(isp, OMAP3_ISP_SUBCLK_RESIZER);
 		resizer_configure(res);
-		res->error = 0;
 		resizer_print_status(res);
 	}
 
diff --git a/drivers/media/video/omap3isp/ispresizer.h b/drivers/media/video/omap3isp/ispresizer.h
index 76abc2e..70c1c0e 100644
--- a/drivers/media/video/omap3isp/ispresizer.h
+++ b/drivers/media/video/omap3isp/ispresizer.h
@@ -107,7 +107,6 @@ struct isp_res_device {
 	enum resizer_input_entity input;
 	struct isp_video video_in;
 	struct isp_video video_out;
-	unsigned int error;
 
 	u32 addr_base;   /* stored source buffer address in memory mode */
 	u32 crop_offset; /* additional offset for crop in memory mode */
diff --git a/drivers/media/video/omap3isp/ispvideo.c b/drivers/media/video/omap3isp/ispvideo.c
index d100072..8d43b99 100644
--- a/drivers/media/video/omap3isp/ispvideo.c
+++ b/drivers/media/video/omap3isp/ispvideo.c
@@ -593,8 +593,7 @@ static const struct isp_video_queue_operations isp_video_queue_ops = {
  * Return a pointer to the next buffer in the DMA queue, or NULL if the queue is
  * empty.
  */
-struct isp_buffer *omap3isp_video_buffer_next(struct isp_video *video,
-					      unsigned int error)
+struct isp_buffer *omap3isp_video_buffer_next(struct isp_video *video)
 {
 	struct isp_pipeline *pipe = to_isp_pipeline(&video->video.entity);
 	struct isp_video_queue *queue = video->queue;
@@ -629,7 +628,13 @@ struct isp_buffer *omap3isp_video_buffer_next(struct isp_video *video,
 	else
 		buf->vbuf.sequence = atomic_read(&pipe->frame_number);
 
-	buf->state = error ? ISP_BUF_STATE_ERROR : ISP_BUF_STATE_DONE;
+	/* Report pipeline errors to userspace on the capture device side. */
+	if (queue->type == V4L2_BUF_TYPE_VIDEO_CAPTURE && pipe->error) {
+		buf->state = ISP_BUF_STATE_ERROR;
+		pipe->error = false;
+	} else {
+		buf->state = ISP_BUF_STATE_DONE;
+	}
 
 	wake_up(&buf->wait);
 
@@ -1015,6 +1020,8 @@ isp_video_streamon(struct file *file, void *fh, enum v4l2_buf_type type)
 	if (ret < 0)
 		goto error;
 
+	pipe->error = false;
+
 	spin_lock_irqsave(&pipe->lock, flags);
 	pipe->state &= ~ISP_PIPELINE_STREAM;
 	pipe->state |= state;
diff --git a/drivers/media/video/omap3isp/ispvideo.h b/drivers/media/video/omap3isp/ispvideo.h
index 08cbfa1..d91bdb91 100644
--- a/drivers/media/video/omap3isp/ispvideo.h
+++ b/drivers/media/video/omap3isp/ispvideo.h
@@ -85,6 +85,10 @@ enum isp_pipeline_state {
 	ISP_PIPELINE_STREAM = 64,
 };
 
+/*
+ * struct isp_pipeline - An ISP hardware pipeline
+ * @error: A hardware error occurred during capture
+ */
 struct isp_pipeline {
 	struct media_pipeline pipe;
 	spinlock_t lock;		/* Pipeline state and queue flags */
@@ -96,6 +100,7 @@ struct isp_pipeline {
 	unsigned int max_rate;
 	atomic_t frame_number;
 	bool do_propagation; /* of frame number */
+	bool error;
 	struct v4l2_fract max_timeperframe;
 };
 
@@ -194,8 +199,7 @@ void omap3isp_video_cleanup(struct isp_video *video);
 int omap3isp_video_register(struct isp_video *video,
 			    struct v4l2_device *vdev);
 void omap3isp_video_unregister(struct isp_video *video);
-struct isp_buffer *omap3isp_video_buffer_next(struct isp_video *video,
-					      unsigned int error);
+struct isp_buffer *omap3isp_video_buffer_next(struct isp_video *video);
 void omap3isp_video_resume(struct isp_video *video, int continuous);
 struct media_pad *omap3isp_video_remote_pad(struct isp_video *video);
 
-- 
1.7.3.4

