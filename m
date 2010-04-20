Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.uni-paderborn.de ([131.234.142.9]:47072 "EHLO
	mail.uni-paderborn.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752471Ab0DTGvq (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 20 Apr 2010 02:51:46 -0400
Cc: g.liakhovetski@gmx.de, jic23@cam.ac.uk,
	Stefan Herbrechtsmeier <hbmeier@hni.uni-paderborn.de>
Subject: [PATCH] pxa_camera: move fifo reset direct before dma start
In-Reply-To: <>
Date: Tue, 20 Apr 2010 08:51:29 +0200
References: <>
Message-Id: <1271746289-14849-1-git-send-email-hbmeier@hni.uni-paderborn.de>
To: linux-media@vger.kernel.org
From: Stefan Herbrechtsmeier <hbmeier@hni.uni-paderborn.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Move the fifo reset from pxa_camera_start_capture to pxa_camera_irq direct
before the dma start after an end of frame interrupt to prevent images from
shifting because of old data at the begin of the frame.

Signed-off-by: Stefan Herbrechtsmeier <hbmeier@hni.uni-paderborn.de>
---
 drivers/media/video/pxa_camera.c |   11 ++++++-----
 1 files changed, 6 insertions(+), 5 deletions(-)

diff --git a/drivers/media/video/pxa_camera.c b/drivers/media/video/pxa_camera.c
index 5ecc30d..04bf5c1 100644
--- a/drivers/media/video/pxa_camera.c
+++ b/drivers/media/video/pxa_camera.c
@@ -609,12 +609,9 @@ static void pxa_dma_add_tail_buf(struct pxa_camera_dev *pcdev,
  */
 static void pxa_camera_start_capture(struct pxa_camera_dev *pcdev)
 {
-	unsigned long cicr0, cifr;
+	unsigned long cicr0;
 
 	dev_dbg(pcdev->soc_host.v4l2_dev.dev, "%s\n", __func__);
-	/* Reset the FIFOs */
-	cifr = __raw_readl(pcdev->base + CIFR) | CIFR_RESET_F;
-	__raw_writel(cifr, pcdev->base + CIFR);
 	/* Enable End-Of-Frame Interrupt */
 	cicr0 = __raw_readl(pcdev->base + CICR0) | CICR0_ENB;
 	cicr0 &= ~CICR0_EOFM;
@@ -935,7 +932,7 @@ static void pxa_camera_deactivate(struct pxa_camera_dev *pcdev)
 static irqreturn_t pxa_camera_irq(int irq, void *data)
 {
 	struct pxa_camera_dev *pcdev = data;
-	unsigned long status, cicr0;
+	unsigned long status, cifr, cicr0;
 	struct pxa_buffer *buf;
 	struct videobuf_buffer *vb;
 
@@ -949,6 +946,10 @@ static irqreturn_t pxa_camera_irq(int irq, void *data)
 	__raw_writel(status, pcdev->base + CISR);
 
 	if (status & CISR_EOF) {
+		/* Reset the FIFOs */
+		cifr = __raw_readl(pcdev->base + CIFR) | CIFR_RESET_F;
+		__raw_writel(cifr, pcdev->base + CIFR);
+
 		pcdev->active = list_first_entry(&pcdev->capture,
 					   struct pxa_buffer, vb.queue);
 		vb = &pcdev->active->vb;
-- 
1.5.4.3

