Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:38623 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755862Ab2CBKsr (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 2 Mar 2012 05:48:47 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: Kruno Mrak <kruno.mrak@matrix-vision.de>,
	Sakari Ailus <sakari.ailus@iki.fi>
Subject: [PATCH] omap3isp: Fix frame number propagation
Date: Fri,  2 Mar 2012 11:49:02 +0100
Message-Id: <1330685342-15139-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

When propagating the frame number through the pipeline, the frame number
must be incremented at frame start by the appropriate IRQ handler. This
was properly handled for the CSI2 and CCP2 receivers, but not when the
CCDC parallel interface is used.

ADD frame number incrementation to the HS/VS interrupt handler. As the
HS/VS interrupt is also generated for frames received by the CSI2 and
CCP2 receivers, remove explicit propagation handling from the serial
receivers.

Reported-by: Kruno Mrak <kruno.mrak@matrix-vision.de>
Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/media/video/omap3isp/isp.c     |    8 --------
 drivers/media/video/omap3isp/ispccdc.c |    3 +++
 drivers/media/video/omap3isp/ispccp2.c |   23 -----------------------
 drivers/media/video/omap3isp/ispcsi2.c |   20 +++-----------------
 drivers/media/video/omap3isp/ispcsi2.h |    1 -
 5 files changed, 6 insertions(+), 49 deletions(-)

diff --git a/drivers/media/video/omap3isp/isp.c b/drivers/media/video/omap3isp/isp.c
index 06afbc1..df6416c 100644
--- a/drivers/media/video/omap3isp/isp.c
+++ b/drivers/media/video/omap3isp/isp.c
@@ -785,14 +785,6 @@ static int isp_pipeline_enable(struct isp_pipeline *pipe,
 		}
 	}
 
-	/* Frame number propagation. In continuous streaming mode the number
-	 * is incremented in the frame start ISR. In mem-to-mem mode
-	 * singleshot is used and frame start IRQs are not available.
-	 * Thus we have to increment the number here.
-	 */
-	if (pipe->do_propagation && mode == ISP_PIPELINE_STREAM_SINGLESHOT)
-		atomic_inc(&pipe->frame_number);
-
 	return 0;
 }
 
diff --git a/drivers/media/video/omap3isp/ispccdc.c b/drivers/media/video/omap3isp/ispccdc.c
index eaabc27..8d8d6f3 100644
--- a/drivers/media/video/omap3isp/ispccdc.c
+++ b/drivers/media/video/omap3isp/ispccdc.c
@@ -1410,6 +1410,9 @@ static void ccdc_hs_vs_isr(struct isp_ccdc_device *ccdc)
 	struct video_device *vdev = ccdc->subdev.devnode;
 	struct v4l2_event event;
 
+	/* Frame number propagation */
+	atomic_inc(&pipe->frame_number);
+
 	memset(&event, 0, sizeof(event));
 	event.type = V4L2_EVENT_FRAME_SYNC;
 	event.u.frame_sync.frame_sequence = atomic_read(&pipe->frame_number);
diff --git a/drivers/media/video/omap3isp/ispccp2.c b/drivers/media/video/omap3isp/ispccp2.c
index 70ddbf3..ee7dcda 100644
--- a/drivers/media/video/omap3isp/ispccp2.c
+++ b/drivers/media/video/omap3isp/ispccp2.c
@@ -161,7 +161,6 @@ static void ccp2_pwr_cfg(struct isp_ccp2_device *ccp2)
 static void ccp2_if_enable(struct isp_ccp2_device *ccp2, u8 enable)
 {
 	struct isp_device *isp = to_isp_device(ccp2);
-	struct isp_pipeline *pipe = to_isp_pipeline(&ccp2->subdev.entity);
 	int i;
 
 	if (enable && ccp2->vdds_csib)
@@ -178,19 +177,6 @@ static void ccp2_if_enable(struct isp_ccp2_device *ccp2, u8 enable)
 			ISPCCP2_CTRL_MODE | ISPCCP2_CTRL_IF_EN,
 			enable ? (ISPCCP2_CTRL_MODE | ISPCCP2_CTRL_IF_EN) : 0);
 
-	/* For frame count propagation */
-	if (pipe->do_propagation) {
-		/* We may want the Frame Start IRQ from LC0 */
-		if (enable)
-			isp_reg_set(isp, OMAP3_ISP_IOMEM_CCP2,
-				    ISPCCP2_LC01_IRQENABLE,
-				    ISPCCP2_LC01_IRQSTATUS_LC0_FS_IRQ);
-		else
-			isp_reg_clr(isp, OMAP3_ISP_IOMEM_CCP2,
-				    ISPCCP2_LC01_IRQENABLE,
-				    ISPCCP2_LC01_IRQSTATUS_LC0_FS_IRQ);
-	}
-
 	if (!enable && ccp2->vdds_csib)
 		regulator_disable(ccp2->vdds_csib);
 }
@@ -350,7 +336,6 @@ static void ccp2_lcx_config(struct isp_ccp2_device *ccp2,
 	      ISPCCP2_LC01_IRQSTATUS_LC0_CRC_IRQ |
 	      ISPCCP2_LC01_IRQSTATUS_LC0_FSP_IRQ |
 	      ISPCCP2_LC01_IRQSTATUS_LC0_FW_IRQ |
-	      ISPCCP2_LC01_IRQSTATUS_LC0_FS_IRQ |
 	      ISPCCP2_LC01_IRQSTATUS_LC0_FSC_IRQ |
 	      ISPCCP2_LC01_IRQSTATUS_LC0_SSC_IRQ;
 
@@ -613,14 +598,6 @@ void omap3isp_ccp2_isr(struct isp_ccp2_device *ccp2)
 	if (omap3isp_module_sync_is_stopping(&ccp2->wait, &ccp2->stopping))
 		return;
 
-	/* Frame number propagation */
-	if (lcx_irqstatus & ISPCCP2_LC01_IRQSTATUS_LC0_FS_IRQ) {
-		struct isp_pipeline *pipe =
-			to_isp_pipeline(&ccp2->subdev.entity);
-		if (pipe->do_propagation)
-			atomic_inc(&pipe->frame_number);
-	}
-
 	/* Handle queued buffers on frame end interrupts */
 	if (lcm_irqstatus & ISPCCP2_LCM_IRQSTATUS_EOF_IRQ)
 		ccp2_isr_buffer(ccp2);
diff --git a/drivers/media/video/omap3isp/ispcsi2.c b/drivers/media/video/omap3isp/ispcsi2.c
index fcb5168..75ac6d4 100644
--- a/drivers/media/video/omap3isp/ispcsi2.c
+++ b/drivers/media/video/omap3isp/ispcsi2.c
@@ -378,21 +378,17 @@ static void csi2_timing_config(struct isp_device *isp,
 static void csi2_irq_ctx_set(struct isp_device *isp,
 			     struct isp_csi2_device *csi2, int enable)
 {
-	u32 reg = ISPCSI2_CTX_IRQSTATUS_FE_IRQ;
 	int i;
 
-	if (csi2->use_fs_irq)
-		reg |= ISPCSI2_CTX_IRQSTATUS_FS_IRQ;
-
 	for (i = 0; i < 8; i++) {
-		isp_reg_writel(isp, reg, csi2->regs1,
+		isp_reg_writel(isp, ISPCSI2_CTX_IRQSTATUS_FE_IRQ, csi2->regs1,
 			       ISPCSI2_CTX_IRQSTATUS(i));
 		if (enable)
 			isp_reg_set(isp, csi2->regs1, ISPCSI2_CTX_IRQENABLE(i),
-				    reg);
+				    ISPCSI2_CTX_IRQSTATUS_FE_IRQ);
 		else
 			isp_reg_clr(isp, csi2->regs1, ISPCSI2_CTX_IRQENABLE(i),
-				    reg);
+				    ISPCSI2_CTX_IRQSTATUS_FE_IRQ);
 	}
 }
 
@@ -690,14 +686,6 @@ static void csi2_isr_ctx(struct isp_csi2_device *csi2,
 	status = isp_reg_readl(isp, csi2->regs1, ISPCSI2_CTX_IRQSTATUS(n));
 	isp_reg_writel(isp, status, csi2->regs1, ISPCSI2_CTX_IRQSTATUS(n));
 
-	/* Propagate frame number */
-	if (status & ISPCSI2_CTX_IRQSTATUS_FS_IRQ) {
-		struct isp_pipeline *pipe =
-				     to_isp_pipeline(&csi2->subdev.entity);
-		if (pipe->do_propagation)
-			atomic_inc(&pipe->frame_number);
-	}
-
 	if (!(status & ISPCSI2_CTX_IRQSTATUS_FE_IRQ))
 		return;
 
@@ -1047,14 +1035,12 @@ static int csi2_set_stream(struct v4l2_subdev *sd, int enable)
 {
 	struct isp_csi2_device *csi2 = v4l2_get_subdevdata(sd);
 	struct isp_device *isp = csi2->isp;
-	struct isp_pipeline *pipe = to_isp_pipeline(&csi2->subdev.entity);
 	struct isp_video *video_out = &csi2->video_out;
 
 	switch (enable) {
 	case ISP_PIPELINE_STREAM_CONTINUOUS:
 		if (omap3isp_csiphy_acquire(csi2->phy) < 0)
 			return -ENODEV;
-		csi2->use_fs_irq = pipe->do_propagation;
 		if (csi2->output & CSI2_OUTPUT_MEMORY)
 			omap3isp_sbl_enable(isp, OMAP3_ISP_SBL_CSI2A_WRITE);
 		csi2_configure(csi2);
diff --git a/drivers/media/video/omap3isp/ispcsi2.h b/drivers/media/video/omap3isp/ispcsi2.h
index 885ad79..c57729b 100644
--- a/drivers/media/video/omap3isp/ispcsi2.h
+++ b/drivers/media/video/omap3isp/ispcsi2.h
@@ -145,7 +145,6 @@ struct isp_csi2_device {
 	u32 output; /* output to CCDC, memory or both? */
 	bool dpcm_decompress;
 	unsigned int frame_skip;
-	bool use_fs_irq;
 
 	struct isp_csiphy *phy;
 	struct isp_csi2_ctx_cfg contexts[ISP_CSI2_MAX_CTX_NUM + 1];
-- 
Regards,

Laurent Pinchart

