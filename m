Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:44099 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755873Ab3LDA4k (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 3 Dec 2013 19:56:40 -0500
Received: from avalon.ideasonboard.com (unknown [91.177.177.98])
	by perceval.ideasonboard.com (Postfix) with ESMTPSA id 4A039366AB
	for <linux-media@vger.kernel.org>; Wed,  4 Dec 2013 01:55:41 +0100 (CET)
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Subject: [PATCH 21/25] v4l: omap4iss: Enable/disabling the ISP interrupts globally
Date: Wed,  4 Dec 2013 01:56:21 +0100
Message-Id: <1386118585-12449-22-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1386118585-12449-1-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1386118585-12449-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

ISP interrupts are enabled/disabled when starting/stopping the IPIPEIF
or resizer. This doesn't permit using the two modules in separate
pipelines. Fix it by enabling/disabling the ISP interrupts at the same
time as the ISS interrupts, in the ISS device get/put operations.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/staging/media/omap4iss/iss.c         | 54 +++++++++++++++-------------
 drivers/staging/media/omap4iss/iss.h         |  3 --
 drivers/staging/media/omap4iss/iss_ipipe.c   |  3 --
 drivers/staging/media/omap4iss/iss_ipipeif.c |  3 --
 drivers/staging/media/omap4iss/iss_resizer.c |  3 --
 5 files changed, 30 insertions(+), 36 deletions(-)

diff --git a/drivers/staging/media/omap4iss/iss.c b/drivers/staging/media/omap4iss/iss.c
index a0bf2f3..dffa31e 100644
--- a/drivers/staging/media/omap4iss/iss.c
+++ b/drivers/staging/media/omap4iss/iss.c
@@ -67,53 +67,59 @@ void omap4iss_flush(struct iss_device *iss)
 }
 
 /*
- * iss_enable_interrupts - Enable ISS interrupts.
+ * iss_isp_enable_interrupts - Enable ISS ISP interrupts.
  * @iss: OMAP4 ISS device
  */
-static void iss_enable_interrupts(struct iss_device *iss)
+static void omap4iss_isp_enable_interrupts(struct iss_device *iss)
 {
-	static const u32 hl_irq = ISS_HL_IRQ_CSIA | ISS_HL_IRQ_CSIB | ISS_HL_IRQ_ISP(0);
-
-	/* Enable HL interrupts */
-	iss_reg_write(iss, OMAP4_ISS_MEM_TOP, ISS_HL_IRQSTATUS(5), hl_irq);
-	iss_reg_write(iss, OMAP4_ISS_MEM_TOP, ISS_HL_IRQENABLE_SET(5), hl_irq);
+	static const u32 isp_irq = ISP5_IRQ_OCP_ERR |
+				   ISP5_IRQ_RSZ_FIFO_IN_BLK_ERR |
+				   ISP5_IRQ_RSZ_FIFO_OVF |
+				   ISP5_IRQ_RSZ_INT_DMA |
+				   ISP5_IRQ_ISIF_INT(0);
 
+	/* Enable ISP interrupts */
+	iss_reg_write(iss, OMAP4_ISS_MEM_ISP_SYS1, ISP5_IRQSTATUS(0), isp_irq);
+	iss_reg_write(iss, OMAP4_ISS_MEM_ISP_SYS1, ISP5_IRQENABLE_SET(0),
+		      isp_irq);
 }
 
 /*
- * iss_disable_interrupts - Disable ISS interrupts.
+ * iss_isp_disable_interrupts - Disable ISS interrupts.
  * @iss: OMAP4 ISS device
  */
-static void iss_disable_interrupts(struct iss_device *iss)
+static void omap4iss_isp_disable_interrupts(struct iss_device *iss)
 {
-	iss_reg_write(iss, OMAP4_ISS_MEM_TOP, ISS_HL_IRQENABLE_CLR(5), -1);
+	iss_reg_write(iss, OMAP4_ISS_MEM_ISP_SYS1, ISP5_IRQENABLE_CLR(0), ~0);
 }
 
 /*
- * iss_isp_enable_interrupts - Enable ISS ISP interrupts.
+ * iss_enable_interrupts - Enable ISS interrupts.
  * @iss: OMAP4 ISS device
  */
-void omap4iss_isp_enable_interrupts(struct iss_device *iss)
+static void iss_enable_interrupts(struct iss_device *iss)
 {
-	static const u32 isp_irq = ISP5_IRQ_OCP_ERR |
-				   ISP5_IRQ_RSZ_FIFO_IN_BLK_ERR |
-				   ISP5_IRQ_RSZ_FIFO_OVF |
-				   ISP5_IRQ_RSZ_INT_DMA |
-				   ISP5_IRQ_ISIF_INT(0);
+	static const u32 hl_irq = ISS_HL_IRQ_CSIA | ISS_HL_IRQ_CSIB
+				| ISS_HL_IRQ_ISP(0);
 
-	/* Enable ISP interrupts */
-	iss_reg_write(iss, OMAP4_ISS_MEM_ISP_SYS1, ISP5_IRQSTATUS(0), isp_irq);
-	iss_reg_write(iss, OMAP4_ISS_MEM_ISP_SYS1, ISP5_IRQENABLE_SET(0),
-		      isp_irq);
+	/* Enable HL interrupts */
+	iss_reg_write(iss, OMAP4_ISS_MEM_TOP, ISS_HL_IRQSTATUS(5), hl_irq);
+	iss_reg_write(iss, OMAP4_ISS_MEM_TOP, ISS_HL_IRQENABLE_SET(5), hl_irq);
+
+	if (iss->regs[OMAP4_ISS_MEM_ISP_SYS1])
+		omap4iss_isp_enable_interrupts(iss);
 }
 
 /*
- * iss_isp_disable_interrupts - Disable ISS interrupts.
+ * iss_disable_interrupts - Disable ISS interrupts.
  * @iss: OMAP4 ISS device
  */
-void omap4iss_isp_disable_interrupts(struct iss_device *iss)
+static void iss_disable_interrupts(struct iss_device *iss)
 {
-	iss_reg_write(iss, OMAP4_ISS_MEM_ISP_SYS1, ISP5_IRQENABLE_CLR(0), -1);
+	if (iss->regs[OMAP4_ISS_MEM_ISP_SYS1])
+		omap4iss_isp_disable_interrupts(iss);
+
+	iss_reg_write(iss, OMAP4_ISS_MEM_TOP, ISS_HL_IRQENABLE_CLR(5), ~0);
 }
 
 int omap4iss_get_external_info(struct iss_pipeline *pipe,
diff --git a/drivers/staging/media/omap4iss/iss.h b/drivers/staging/media/omap4iss/iss.h
index 660809e..f63caaf 100644
--- a/drivers/staging/media/omap4iss/iss.h
+++ b/drivers/staging/media/omap4iss/iss.h
@@ -141,9 +141,6 @@ void omap4iss_isp_subclk_enable(struct iss_device *iss,
 void omap4iss_isp_subclk_disable(struct iss_device *iss,
 				 enum iss_isp_subclk_resource res);
 
-void omap4iss_isp_enable_interrupts(struct iss_device *iss);
-void omap4iss_isp_disable_interrupts(struct iss_device *iss);
-
 int omap4iss_pipeline_pm_use(struct media_entity *entity, int use);
 
 int omap4iss_register_entities(struct platform_device *pdev,
diff --git a/drivers/staging/media/omap4iss/iss_ipipe.c b/drivers/staging/media/omap4iss/iss_ipipe.c
index c013f83..6eaafc5 100644
--- a/drivers/staging/media/omap4iss/iss_ipipe.c
+++ b/drivers/staging/media/omap4iss/iss_ipipe.c
@@ -116,8 +116,6 @@ static void ipipe_configure(struct iss_ipipe_device *ipipe)
 	/* IPIPE_PAD_SOURCE_VP */
 	format = &ipipe->formats[IPIPE_PAD_SOURCE_VP];
 	/* Do nothing? */
-
-	omap4iss_isp_enable_interrupts(iss);
 }
 
 /* -----------------------------------------------------------------------------
@@ -169,7 +167,6 @@ static int ipipe_set_stream(struct v4l2_subdev *sd, int enable)
 			ret = -ETIMEDOUT;
 
 		ipipe_enable(ipipe, 0);
-		omap4iss_isp_disable_interrupts(iss);
 		omap4iss_isp_subclk_disable(iss, OMAP4_ISS_ISP_SUBCLK_IPIPE);
 		break;
 	}
diff --git a/drivers/staging/media/omap4iss/iss_ipipeif.c b/drivers/staging/media/omap4iss/iss_ipipeif.c
index 00bc937..7bc1457 100644
--- a/drivers/staging/media/omap4iss/iss_ipipeif.c
+++ b/drivers/staging/media/omap4iss/iss_ipipeif.c
@@ -213,8 +213,6 @@ cont_raw:
 
 	/* IPIPEIF_PAD_SOURCE_VP */
 	/* Do nothing? */
-
-	omap4iss_isp_enable_interrupts(iss);
 }
 
 /* -----------------------------------------------------------------------------
@@ -368,7 +366,6 @@ static int ipipeif_set_stream(struct v4l2_subdev *sd, int enable)
 		if (ipipeif->output & IPIPEIF_OUTPUT_MEMORY)
 			ipipeif_write_enable(ipipeif, 0);
 		ipipeif_enable(ipipeif, 0);
-		omap4iss_isp_disable_interrupts(iss);
 		omap4iss_isp_subclk_disable(iss, IPIPEIF_DRV_SUBCLK_MASK);
 		iss_video_dmaqueue_flags_clr(video_out);
 		break;
diff --git a/drivers/staging/media/omap4iss/iss_resizer.c b/drivers/staging/media/omap4iss/iss_resizer.c
index 9dbf018..4673c05 100644
--- a/drivers/staging/media/omap4iss/iss_resizer.c
+++ b/drivers/staging/media/omap4iss/iss_resizer.c
@@ -256,8 +256,6 @@ static void resizer_configure(struct iss_resizer_device *resizer)
 	} else {
 		iss_reg_write(iss, OMAP4_ISS_MEM_ISP_RESIZER, RZA_420, 0);
 	}
-
-	omap4iss_isp_enable_interrupts(iss);
 }
 
 /* -----------------------------------------------------------------------------
@@ -419,7 +417,6 @@ static int resizer_set_stream(struct v4l2_subdev *sd, int enable)
 			ret = -ETIMEDOUT;
 
 		resizer_enable(resizer, 0);
-		omap4iss_isp_disable_interrupts(iss);
 		iss_reg_clr(iss, OMAP4_ISS_MEM_ISP_RESIZER, RSZ_SYSCONFIG,
 			    RSZ_SYSCONFIG_RSZA_CLK_EN);
 		iss_reg_clr(iss, OMAP4_ISS_MEM_ISP_RESIZER, RSZ_GCK_SDR,
-- 
1.8.3.2

