Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:48027 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755028Ab0CEKpu (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 5 Mar 2010 05:45:50 -0500
From: =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?=
	<u.kleine-koenig@pengutronix.de>
To: linux-media@vger.kernel.org
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Antonio Ospite <ospite@studenti.unina.it>,
	Sascha Hauer <s.hauer@pengutronix.de>,
	Hans Verkuil <hverkuil@xs4all.nl>, linux-kernel@vger.kernel.org
Subject: [PATCH v2] V4L/DVB: mx1-camera: compile fix
Date: Fri,  5 Mar 2010 11:45:24 +0100
Message-Id: <1267785924-16167-1-git-send-email-u.kleine-koenig@pengutronix.de>
In-Reply-To: <20100304194241.GG19843@pengutronix.de>
References: <20100304194241.GG19843@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is a regression of

	7d58289 (mx1: prefix SOC specific defines with MX1_ and deprecate old names)

Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
---
 drivers/media/video/mx1_camera.c |   12 +++++++-----
 1 files changed, 7 insertions(+), 5 deletions(-)

diff --git a/drivers/media/video/mx1_camera.c b/drivers/media/video/mx1_camera.c
index 2ba14fb..29c2833 100644
--- a/drivers/media/video/mx1_camera.c
+++ b/drivers/media/video/mx1_camera.c
@@ -45,11 +45,13 @@
 #include <mach/hardware.h>
 #include <mach/mx1_camera.h>
 
+#define __DMAREG(offset)	(MX1_IO_ADDRESS(MX1_DMA_BASE_ADDR) + offset)
+
 /*
  * CSI registers
  */
-#define DMA_CCR(x)	(0x8c + ((x) << 6))	/* Control Registers */
-#define DMA_DIMR	0x08			/* Interrupt mask Register */
+#define DMA_CCR(x)	__DMAREG(0x8c + ((x) << 6))	/* Control Registers */
+#define DMA_DIMR	__DMAREG(0x08)		/* Interrupt mask Register */
 #define CSICR1		0x00			/* CSI Control Register 1 */
 #define CSISR		0x08			/* CSI Status Register */
 #define CSIRXR		0x10			/* CSI RxFIFO Register */
@@ -783,7 +785,7 @@ static int __init mx1_camera_probe(struct platform_device *pdev)
 			       pcdev);
 
 	imx_dma_config_channel(pcdev->dma_chan, IMX_DMA_TYPE_FIFO,
-			       IMX_DMA_MEMSIZE_32, DMA_REQ_CSI_R, 0);
+			       IMX_DMA_MEMSIZE_32, MX1_DMA_REQ_CSI_R, 0);
 	/* burst length : 16 words = 64 bytes */
 	imx_dma_config_burstlen(pcdev->dma_chan, 0);
 
@@ -797,8 +799,8 @@ static int __init mx1_camera_probe(struct platform_device *pdev)
 	set_fiq_handler(&mx1_camera_sof_fiq_start, &mx1_camera_sof_fiq_end -
 						   &mx1_camera_sof_fiq_start);
 
-	regs.ARM_r8 = DMA_BASE + DMA_DIMR;
-	regs.ARM_r9 = DMA_BASE + DMA_CCR(pcdev->dma_chan);
+	regs.ARM_r8 = (long)DMA_DIMR;
+	regs.ARM_r9 = (long)DMA_CCR(pcdev->dma_chan);
 	regs.ARM_r10 = (long)pcdev->base + CSICR1;
 	regs.ARM_fp = (long)pcdev->base + CSISR;
 	regs.ARM_sp = 1 << pcdev->dma_chan;
-- 
1.7.0

