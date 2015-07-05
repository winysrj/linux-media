Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp02.smtpout.orange.fr ([80.12.242.124]:41559 "EHLO
	smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752368AbbGESaj (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 5 Jul 2015 14:30:39 -0400
From: Robert Jarzmik <robert.jarzmik@free.fr>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Jiri Kosina <trivial@kernel.org>
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
	Robert Jarzmik <robert.jarzmik@intel.com>
Subject: [PATCH v2 2/4] media: pxa_camera: move interrupt to tasklet
Date: Sun,  5 Jul 2015 20:27:50 +0200
Message-Id: <1436120872-24484-3-git-send-email-robert.jarzmik@free.fr>
In-Reply-To: <1436120872-24484-1-git-send-email-robert.jarzmik@free.fr>
References: <1436120872-24484-1-git-send-email-robert.jarzmik@free.fr>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Robert Jarzmik <robert.jarzmik@intel.com>

In preparation for dmaengine conversion, move the camera interrupt
handling into a tasklet. This won't change the global flow, as this
interrupt is only used to detect the end of frame and activate DMA fifos
handling.

Signed-off-by: Robert Jarzmik <robert.jarzmik@intel.com>
---
 drivers/media/platform/soc_camera/pxa_camera.c | 44 +++++++++++++++++---------
 1 file changed, 29 insertions(+), 15 deletions(-)

diff --git a/drivers/media/platform/soc_camera/pxa_camera.c b/drivers/media/platform/soc_camera/pxa_camera.c
index 3ca33f0..c0c0f0f 100644
--- a/drivers/media/platform/soc_camera/pxa_camera.c
+++ b/drivers/media/platform/soc_camera/pxa_camera.c
@@ -223,6 +223,7 @@ struct pxa_camera_dev {
 
 	struct pxa_buffer	*active;
 	struct pxa_dma_desc	*sg_tail[3];
+	struct tasklet_struct	task_eof;
 
 	u32			save_cicr[5];
 };
@@ -605,6 +606,7 @@ static void pxa_camera_start_capture(struct pxa_camera_dev *pcdev)
 	unsigned long cicr0;
 
 	dev_dbg(pcdev->soc_host.v4l2_dev.dev, "%s\n", __func__);
+	__raw_writel(__raw_readl(pcdev->base + CISR), pcdev->base + CISR);
 	/* Enable End-Of-Frame Interrupt */
 	cicr0 = __raw_readl(pcdev->base + CICR0) | CICR0_ENB;
 	cicr0 &= ~CICR0_EOFM;
@@ -922,13 +924,35 @@ static void pxa_camera_deactivate(struct pxa_camera_dev *pcdev)
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
@@ -939,20 +963,9 @@ static irqreturn_t pxa_camera_irq(int irq, void *data)
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
@@ -1834,6 +1847,7 @@ static int pxa_camera_probe(struct platform_device *pdev)
 	pcdev->soc_host.priv		= pcdev;
 	pcdev->soc_host.v4l2_dev.dev	= &pdev->dev;
 	pcdev->soc_host.nr		= pdev->id;
+	tasklet_init(&pcdev->task_eof, pxa_camera_eof, (unsigned long)pcdev);
 
 	err = soc_camera_host_register(&pcdev->soc_host);
 	if (err)
-- 
2.1.4

