Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:51740 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932508AbaJaPVR (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 31 Oct 2014 11:21:17 -0400
Received: from avalon.ideasonboard.com (dsl-hkibrasgw3-50ddcc-40.dhcp.inet.fi [80.221.204.40])
	by galahad.ideasonboard.com (Postfix) with ESMTPSA id 92E1D217D3
	for <linux-media@vger.kernel.org>; Fri, 31 Oct 2014 16:19:05 +0100 (CET)
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Subject: [PATCH 3/4] v4l: omap4iss: csi2: Perform real frame number propagation
Date: Fri, 31 Oct 2014 17:21:21 +0200
Message-Id: <1414768882-16255-4-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1414768882-16255-1-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1414768882-16255-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Compute the pipeline frame number from the frame number sent by the
sensor instead of incrementing the frame number in software. This
improves dropped frames detection.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/staging/media/omap4iss/iss.c      |  5 ++++
 drivers/staging/media/omap4iss/iss_csi2.c | 43 ++++++++++++++++++++++++-------
 drivers/staging/media/omap4iss/iss_csi2.h |  2 +-
 drivers/staging/media/omap4iss/iss_regs.h |  2 ++
 4 files changed, 41 insertions(+), 11 deletions(-)

diff --git a/drivers/staging/media/omap4iss/iss.c b/drivers/staging/media/omap4iss/iss.c
index d548371..fa05908 100644
--- a/drivers/staging/media/omap4iss/iss.c
+++ b/drivers/staging/media/omap4iss/iss.c
@@ -612,7 +612,12 @@ static int iss_pipeline_enable(struct iss_pipeline *pipe,
 		ret = v4l2_subdev_call(subdev, video, s_stream, mode);
 		if (ret < 0 && ret != -ENOIOCTLCMD)
 			return ret;
+
+		if (subdev == &iss->csi2a.subdev ||
+		    subdev == &iss->csi2b.subdev)
+			pipe->do_propagation = true;
 	}
+
 	iss_print_status(pipe->output->iss);
 	return 0;
 }
diff --git a/drivers/staging/media/omap4iss/iss_csi2.c b/drivers/staging/media/omap4iss/iss_csi2.c
index 92c2d5b..8b107ba 100644
--- a/drivers/staging/media/omap4iss/iss_csi2.c
+++ b/drivers/staging/media/omap4iss/iss_csi2.c
@@ -319,6 +319,8 @@ static void csi2_ctx_config(struct iss_csi2_device *csi2,
 {
 	u32 reg = 0;
 
+	ctx->frame = 0;
+
 	/* Set up CSI2_CTx_CTRL1 */
 	if (ctx->eof_enabled)
 		reg = CSI2_CTX_CTRL1_EOF_EN;
@@ -396,21 +398,18 @@ static void csi2_timing_config(struct iss_csi2_device *csi2,
  */
 static void csi2_irq_ctx_set(struct iss_csi2_device *csi2, int enable)
 {
-	u32 reg = CSI2_CTX_IRQ_FE;
+	const u32 mask = CSI2_CTX_IRQ_FE | CSI2_CTX_IRQ_FS;
 	int i;
 
-	if (csi2->use_fs_irq)
-		reg |= CSI2_CTX_IRQ_FS;
-
 	for (i = 0; i < 8; i++) {
 		iss_reg_write(csi2->iss, csi2->regs1, CSI2_CTX_IRQSTATUS(i),
-			      reg);
+			      mask);
 		if (enable)
 			iss_reg_set(csi2->iss, csi2->regs1,
-				    CSI2_CTX_IRQENABLE(i), reg);
+				    CSI2_CTX_IRQENABLE(i), mask);
 		else
 			iss_reg_clr(csi2->iss, csi2->regs1,
-				    CSI2_CTX_IRQENABLE(i), reg);
+				    CSI2_CTX_IRQENABLE(i), mask);
 	}
 }
 
@@ -679,8 +678,34 @@ static void csi2_isr_ctx(struct iss_csi2_device *csi2,
 	if (status & CSI2_CTX_IRQ_FS) {
 		struct iss_pipeline *pipe =
 				     to_iss_pipeline(&csi2->subdev.entity);
-		if (pipe->do_propagation)
+		u16 frame;
+		u16 delta;
+
+		frame = iss_reg_read(csi2->iss, csi2->regs1,
+				     CSI2_CTX_CTRL2(ctx->ctxnum))
+		      >> CSI2_CTX_CTRL2_FRAME_SHIFT;
+
+		if (frame == 0) {
+			/* A zero value means that the counter isn't implemented
+			 * by the source. Increment the frame number in software
+			 * in that case.
+			 */
 			atomic_inc(&pipe->frame_number);
+		} else {
+			/* Extend the 16 bit frame number to 32 bits by
+			 * computing the delta between two consecutive CSI2
+			 * frame numbers and adding it to the software frame
+			 * number. The hardware counter starts at 1 and wraps
+			 * from 0xffff to 1 without going through 0, so subtract
+			 * 1 when the counter wraps.
+			 */
+			delta = frame - ctx->frame;
+			if (frame < ctx->frame)
+				delta--;
+			ctx->frame = frame;
+
+			atomic_add(delta, &pipe->frame_number);
+		}
 	}
 
 	if (!(status & CSI2_CTX_IRQ_FE))
@@ -1039,7 +1064,6 @@ static int csi2_set_stream(struct v4l2_subdev *sd, int enable)
 {
 	struct iss_csi2_device *csi2 = v4l2_get_subdevdata(sd);
 	struct iss_device *iss = csi2->iss;
-	struct iss_pipeline *pipe = to_iss_pipeline(&csi2->subdev.entity);
 	struct iss_video *video_out = &csi2->video_out;
 	int ret = 0;
 
@@ -1058,7 +1082,6 @@ static int csi2_set_stream(struct v4l2_subdev *sd, int enable)
 
 		if (omap4iss_csiphy_acquire(csi2->phy) < 0)
 			return -ENODEV;
-		csi2->use_fs_irq = pipe->do_propagation;
 		csi2_configure(csi2);
 		csi2_print_status(csi2);
 
diff --git a/drivers/staging/media/omap4iss/iss_csi2.h b/drivers/staging/media/omap4iss/iss_csi2.h
index 971aa7b..3b37978 100644
--- a/drivers/staging/media/omap4iss/iss_csi2.h
+++ b/drivers/staging/media/omap4iss/iss_csi2.h
@@ -82,6 +82,7 @@ struct iss_csi2_ctx_cfg {
 	u8 virtual_id;
 	u16 format_id;		/* as in CSI2_CTx_CTRL2[9:0] */
 	u8 dpcm_predictor;	/* 1: simple, 0: advanced */
+	u16 frame;
 
 	/* Fields in CSI2_CTx_CTRL1/3 - Shadowed */
 	u16 alpha;
@@ -137,7 +138,6 @@ struct iss_csi2_device {
 	u32 output; /* output to IPIPEIF, memory or both? */
 	bool dpcm_decompress;
 	unsigned int frame_skip;
-	bool use_fs_irq;
 
 	struct iss_csiphy *phy;
 	struct iss_csi2_ctx_cfg contexts[ISS_CSI2_MAX_CTX_NUM + 1];
diff --git a/drivers/staging/media/omap4iss/iss_regs.h b/drivers/staging/media/omap4iss/iss_regs.h
index efd0291..d2b6b6a 100644
--- a/drivers/staging/media/omap4iss/iss_regs.h
+++ b/drivers/staging/media/omap4iss/iss_regs.h
@@ -215,6 +215,8 @@
 #define CSI2_CTX_CTRL1_CTX_EN				(1 << 0)
 
 #define CSI2_CTX_CTRL2(i)				(0x74 + (0x20 * i))
+#define CSI2_CTX_CTRL2_FRAME_MASK			(0xffff << 16)
+#define CSI2_CTX_CTRL2_FRAME_SHIFT			16
 #define CSI2_CTX_CTRL2_USER_DEF_MAP_SHIFT		13
 #define CSI2_CTX_CTRL2_USER_DEF_MAP_MASK		\
 		(0x3 << CSI2_CTX_CTRL2_USER_DEF_MAP_SHIFT)
-- 
2.0.4

