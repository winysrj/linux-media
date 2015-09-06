Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp07.smtpout.orange.fr ([80.12.242.129]:34953 "EHLO
	smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752266AbbIFLrF (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 6 Sep 2015 07:47:05 -0400
From: Robert Jarzmik <robert.jarzmik@free.fr>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Jiri Kosina <trivial@kernel.org>
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
	Robert Jarzmik <robert.jarzmik@free.fr>
Subject: [PATCH v5 2/4] media: pxa_camera: move interrupt to tasklet
Date: Sun,  6 Sep 2015 13:42:11 +0200
Message-Id: <1441539733-19201-2-git-send-email-robert.jarzmik@free.fr>
In-Reply-To: <1441539733-19201-1-git-send-email-robert.jarzmik@free.fr>
References: <1441539733-19201-1-git-send-email-robert.jarzmik@free.fr>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

In preparation for dmaengine conversion, move the camera interrupt
handling into a tasklet. This won't change the global flow, as this
interrupt is only used to detect the end of frame and activate DMA fifos
handling.

Signed-off-by: Robert Jarzmik <robert.jarzmik@free.fr>
---
 drivers/media/platform/soc_camera/pxa_camera.c | 44 +++++++++++++++++---------
 1 file changed, 29 insertions(+), 15 deletions(-)

diff --git a/drivers/media/platform/soc_camera/pxa_camera.c b/drivers/media/platform/soc_camera/pxa_camera.c
index d4e887841372..db041a5ed444 100644
--- a/drivers/media/platform/soc_camera/pxa_camera.c
+++ b/drivers/media/platform/soc_camera/pxa_camera.c
@@ -223,6 +223,7 @@ struct pxa_camera_dev {
 
 	struct pxa_buffer	*active;
 	struct pxa_dma_desc	*sg_tail[3];
+	struct tasklet_struct	task_eof;
 
 	u32			save_cicr[5];
 };
@@ -597,6 +598,7 @@ static void pxa_camera_start_capture(struct pxa_camera_dev *pcdev)
 	unsigned long cicr0;
 
 	dev_dbg(pcdev->soc_host.v4l2_dev.dev, "%s\n", __func__);
+	__raw_writel(__raw_readl(pcdev->base + CISR), pcdev->base + CISR);
 	/* Enable End-Of-Frame Interrupt */
 	cicr0 = __raw_readl(pcdev->base + CICR0) | CICR0_ENB;
 	cicr0 &= ~CICR0_EOFM;
@@ -914,13 +916,35 @@ static void pxa_camera_deactivate(struct pxa_camera_dev *pcdev)
 	clk_disable_unprepare(pcdev->clk);
 }
 
-static irqreturn_t pxa_camera_irq(int irq, void *data)
+static void pxa_camera_eof(unsigned long arg)
 {
-	struct pxa_camera_dev *pcdev = data;
-	unsigned long status, cifr, cicr0;
+	struct pxa_camera_dev *pcdev = (struct pxa_camera_dev *)arg;
+	unsigned long cifr;
 	struct pxa_buffer *buf;
 	struct videobuf_buffer *vb;
 
+	dev_dbg(pcdev->soc_host.v4l2_dev.dev,
+		"Camera interrupt status 0x%x\n",
+		__raw_readl(pcdev->base + CISR));
+
+	/* Reset the FIFOs */
+	cifr = __raw_readl(pcdev->base + CIFR) | CIFR_RESET_F;
+	__raw_writel(cifr, pcdev->base + CIFR);
+
+	pcdev->active = list_first_entry(&pcdev->capture,
+					 struct pxa_buffer, vb.queue);
+	vb = &pcdev->active->vb;
+	buf = container_of(vb, struct pxa_buffer, vb);
+	pxa_videobuf_set_actdma(pcdev, buf);
+
+	pxa_dma_start_channels(pcdev);
+}
+
+static irqreturn_t pxa_camera_irq(int irq, void *data)
+{
+	struct pxa_camera_dev *pcdev = data;
+	unsigned long status, cicr0;
+
 	status = __raw_readl(pcdev->base + CISR);
 	dev_dbg(pcdev->soc_host.v4l2_dev.dev,
 		"Camera interrupt status 0x%lx\n", status);
@@ -931,20 +955,9 @@ static irqreturn_t pxa_camera_irq(int irq, void *data)
 	__raw_writel(status, pcdev->base + CISR);
 
 	if (status & CISR_EOF) {
-		/* Reset the FIFOs */
-		cifr = __raw_readl(pcdev->base + CIFR) | CIFR_RESET_F;
-		__raw_writel(cifr, pcdev->base + CIFR);
-
-		pcdev->active = list_first_entry(&pcdev->capture,
-					   struct pxa_buffer, vb.queue);
-		vb = &pcdev->active->vb;
-		buf = container_of(vb, struct pxa_buffer, vb);
-		pxa_videobuf_set_actdma(pcdev, buf);
-
-		pxa_dma_start_channels(pcdev);
-
 		cicr0 = __raw_readl(pcdev->base + CICR0) | CICR0_EOFM;
 		__raw_writel(cicr0, pcdev->base + CICR0);
+		tasklet_schedule(&pcdev->task_eof);
 	}
 
 	return IRQ_HANDLED;
@@ -1839,6 +1852,7 @@ static int pxa_camera_probe(struct platform_device *pdev)
 	pcdev->soc_host.priv		= pcdev;
 	pcdev->soc_host.v4l2_dev.dev	= &pdev->dev;
 	pcdev->soc_host.nr		= pdev->id;
+	tasklet_init(&pcdev->task_eof, pxa_camera_eof, (unsigned long)pcdev);
 
 	err = soc_camera_host_register(&pcdev->soc_host);
 	if (err)
-- 
2.1.4

