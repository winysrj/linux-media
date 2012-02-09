Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:32994 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754312Ab2BJDxt (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 9 Feb 2012 22:53:49 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Kruno Mrak <kruno.mrak@matrix-vision.de>
Cc: linux-media@vger.kernel.org, sakari.ailus@iki.fi
Subject: Re: omap3isp: sequence number in v4l2 buffer not incremented
Date: Thu, 09 Feb 2012 17:08:28 +0100
Message-ID: <3002082.9RrLpdpVPL@avalon>
In-Reply-To: <4F202102.5070701@matrix-vision.de>
References: <4F202102.5070701@matrix-vision.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Kruno,

On Wednesday 25 January 2012 16:34:26 Kruno Mrak wrote:
> Hello,
> 
> we have an omap based intelligent camera and image sensor is connected to
> camera parallel interface. Image capturing via "CCDC output" works fine.
> When streaming is on and reading "sequence" variable, it shows always -1.
> Looking at kernel-source ispvideo.c, i found following if-else statement:
> 
> /* Do frame number propagation only if this is the output video node.
>   * Frame number either comes from the CSI receivers or it gets
>   * incremented here if H3A is not active.
>   * Note: There is no guarantee that the output buffer will finish
>   * first, so the input number might lag behind by 1 in some cases.
>   */
> if (video == pipe->output && !pipe->do_propagation)
> 	buf->vbuf.sequence = atomic_inc_return(&pipe->frame_number);
> else
> 	buf->vbuf.sequence = atomic_read(&pipe->frame_number);
> 
> When i change to
> if (video == pipe->output && pipe->do_propagation)
> ...
> the sequence variable is incremented.
> 
> So my question:
> Could it be that "pipe->do_propagation" should be tested on true and not on
> false?

No, the code is correct here. When do_propagation is true, the pipeline's
frame number is incremented in the frame start interrupt handler. This allows
synchronization of buffer sequence numbers with the statistics engine frame
counts.

> If this change is wrong, how can i achieve that the sequence number is
> incremented?

The driver increments the frame number in the CCP2 and CSI2 receivers
interrupt handlers. The frame number will thus not be incremented when using
the CCDC parallel input, which is wrong.

Does the following patch fix your problem ? I haven't been able to test it
yet with the CCP2 and CSI2 receivers, I might ask you to test a second
version. Sakari, could you test the patch on the N900 with the CCP2 receiver ?
I'm currently travelling and haven't brought mine with me.

>From c0d23bfa38fc91f33f39bab9328eda3a4481f152 Mon Sep 17 00:00:00 2001
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Date: Thu, 9 Feb 2012 17:00:45 +0100
Subject: [PATCH] omap3isp: Fix frame number propagation

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
 drivers/media/video/omap3isp/ispccp2.c |   22 ----------------------
 drivers/media/video/omap3isp/ispcsi2.c |   19 +++----------------
 drivers/media/video/omap3isp/ispcsi2.h |    1 -
 5 files changed, 6 insertions(+), 47 deletions(-)

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
index 70ddbf3..84014b9 100644
--- a/drivers/media/video/omap3isp/ispccp2.c
+++ b/drivers/media/video/omap3isp/ispccp2.c
@@ -178,19 +178,6 @@ static void ccp2_if_enable(struct isp_ccp2_device *ccp2, u8 enable)
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
@@ -350,7 +337,6 @@ static void ccp2_lcx_config(struct isp_ccp2_device *ccp2,
 	      ISPCCP2_LC01_IRQSTATUS_LC0_CRC_IRQ |
 	      ISPCCP2_LC01_IRQSTATUS_LC0_FSP_IRQ |
 	      ISPCCP2_LC01_IRQSTATUS_LC0_FW_IRQ |
-	      ISPCCP2_LC01_IRQSTATUS_LC0_FS_IRQ |
 	      ISPCCP2_LC01_IRQSTATUS_LC0_FSC_IRQ |
 	      ISPCCP2_LC01_IRQSTATUS_LC0_SSC_IRQ;
 
@@ -613,14 +599,6 @@ void omap3isp_ccp2_isr(struct isp_ccp2_device *ccp2)
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
index fcb5168..3026215 100644
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
 
@@ -1054,7 +1042,6 @@ static int csi2_set_stream(struct v4l2_subdev *sd, int enable)
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
