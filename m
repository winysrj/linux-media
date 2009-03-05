Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp5-g21.free.fr ([212.27.42.5]:43934 "EHLO smtp5-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754740AbZCETqG (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 5 Mar 2009 14:46:06 -0500
From: Robert Jarzmik <robert.jarzmik@free.fr>
To: g.liakhovetski@gmx.de, mike@compulab.co.il
Cc: linux-media@vger.kernel.org,
	Robert Jarzmik <robert.jarzmik@free.fr>
Subject: [PATCH 2/4] pxa_camera: Redesign DMA handling
Date: Thu,  5 Mar 2009 20:45:49 +0100
Message-Id: <1236282351-28471-3-git-send-email-robert.jarzmik@free.fr>
In-Reply-To: <1236282351-28471-2-git-send-email-robert.jarzmik@free.fr>
References: <1236282351-28471-1-git-send-email-robert.jarzmik@free.fr>
 <1236282351-28471-2-git-send-email-robert.jarzmik@free.fr>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The DMA transfers in pxa_camera showed some weaknesses in
multiple queued buffers context :
 - poll/select problem
   The order between list pcdev->capture and DMA chain was
   not the same. This creates a discrepancy between video
   buffers marked as "done" by the IRQ handler, and the
   really finished video buffer.

   The bug shows up with capture_example tool from v4l2 hg
   tree. The process just "stalls" on a "select timeout".

   The key problem is in pxa_videobuf_queue(), where the
   queued buffer is chained before the active buffer, while
   it should have been the active buffer first, and queued
   buffer tailed after.

 - multiple buffers DMA starting
   When multiple buffers were queued, the DMA channels were
   always started right away. This is not optimal, as a
   special case appears when the first EOF was not yet
   reached, and the DMA channels were prematurely started.

 - Maintainability
   DMA code was a bit obfuscated. Rationalize the code to be
   easily maintainable by anyone.

This patch attemps to address these issues.

Signed-off-by: Robert Jarzmik <robert.jarzmik@free.fr>
---
 drivers/media/video/pxa_camera.c |  264 ++++++++++++++++++++------------------
 1 files changed, 139 insertions(+), 125 deletions(-)

diff --git a/drivers/media/video/pxa_camera.c b/drivers/media/video/pxa_camera.c
index 54df071..2d79ded 100644
--- a/drivers/media/video/pxa_camera.c
+++ b/drivers/media/video/pxa_camera.c
@@ -325,7 +325,7 @@ static int calculate_dma_sglen(struct scatterlist *sglist, int sglen,
  * Prepares the pxa dma descriptors to transfer one camera channel.
  * Beware sg_first and sg_first_ofs are both input and output parameters.
  *
- * Returns 0
+ * Returns 0 or -ENOMEM si no coherent memory is available
  */
 static int pxa_init_dma_channel(struct pxa_camera_dev *pcdev,
 				struct pxa_buffer *buf,
@@ -369,7 +369,8 @@ static int pxa_init_dma_channel(struct pxa_camera_dev *pcdev,
 		pxa_dma->sg_cpu[i].dsadr = pcdev->res->start + cibr;
 		pxa_dma->sg_cpu[i].dtadr = sg_dma_address(sg) + offset;
 		pxa_dma->sg_cpu[i].dcmd =
-			DCMD_FLOWSRC | DCMD_BURST8 | DCMD_INCTRGADDR | xfer_len;
+			DCMD_FLOWSRC | DCMD_BURST8 | DCMD_INCTRGADDR | xfer_len
+			| ((i == 0) ? DCMD_STARTIRQEN : 0);
 		pxa_dma->sg_cpu[i].ddadr =
 			pxa_dma->sg_dma + (i + 1) * sizeof(struct pxa_dma_desc);
 
@@ -516,6 +517,97 @@ out:
 	return ret;
 }
 
+/**
+ * pxa_dma_start_channels - start DMA channel for active buffer
+ * @pcdev: pxa camera device
+ *
+ * Initialize DMA channels to the beginning of the active video buffer, and
+ * start these channels.
+ */
+static void pxa_dma_start_channels(struct pxa_camera_dev *pcdev)
+{
+	int i;
+	struct pxa_buffer *active;
+
+	active = pcdev->active;
+
+	for (i = 0; i < pcdev->channels; i++) {
+		dev_dbg(pcdev->dev, "%s (channel=%d) ddadr=%08x\n", __func__,
+			i, active->dmas[i].sg_dma);
+		DDADR(pcdev->dma_chans[i]) = active->dmas[i].sg_dma;
+		DCSR(pcdev->dma_chans[i]) = DCSR_RUN;
+	}
+}
+
+static void pxa_dma_stop_channels(struct pxa_camera_dev *pcdev)
+{
+	int i;
+
+	for (i = 0; i < pcdev->channels; i++) {
+		dev_dbg(pcdev->dev, "%s (channel=%d)\n", __func__, i);
+		DCSR(pcdev->dma_chans[i]) = 0;
+	}
+}
+
+static void pxa_dma_update_sg_tail(struct pxa_camera_dev *pcdev,
+				   struct pxa_buffer *buf)
+{
+	int i;
+
+	for (i = 0; i < pcdev->channels; i++) {
+		pcdev->sg_tail[i] = buf->dmas[i].sg_cpu + buf->dmas[i].sglen;
+		pcdev->sg_tail[i]->ddadr = DDADR_STOP;
+	}
+}
+
+static void pxa_dma_add_tail_buf(struct pxa_camera_dev *pcdev,
+				 struct pxa_buffer *buf)
+{
+	int i;
+
+	for (i = 0; i < pcdev->channels; i++) {
+		if (!pcdev->sg_tail[i])
+			continue;
+		pcdev->sg_tail[i]->ddadr = buf->dmas[i].sg_dma;
+	}
+
+	pxa_dma_update_sg_tail(pcdev, buf);
+}
+
+/**
+ * pxa_camera_start_capture - start video capturing
+ * @pcdev: camera device
+ *
+ * Launch capturing. DMA channels should not be active yet. They should get
+ * activated at the end of frame interrupt, to capture only whole frames, and
+ * never begin the capture of a partial frame.
+ */
+static void pxa_camera_start_capture(struct pxa_camera_dev *pcdev)
+{
+	unsigned long cicr0, cifr;
+
+	dev_dbg(pcdev->dev, "%s\n", __func__);
+	cifr = __raw_readl(pcdev->base + CIFR) | CIFR_RESET_F;
+	__raw_writel(cifr, pcdev->base + CIFR);
+
+	cicr0 = __raw_readl(pcdev->base + CICR0) | CICR0_ENB | CISR_IFO_0
+		| CISR_IFO_1 | CISR_IFO_2;
+	cicr0 &= ~CICR0_EOFM;
+	__raw_writel(cicr0, pcdev->base + CICR0);
+}
+
+static void pxa_camera_stop_capture(struct pxa_camera_dev *pcdev)
+{
+	unsigned long cicr0;
+
+	pxa_dma_stop_channels(pcdev);
+
+	cicr0 = __raw_readl(pcdev->base + CICR0) & ~CICR0_ENB;
+	__raw_writel(cicr0, pcdev->base + CICR0);
+
+	dev_dbg(pcdev->dev, "%s\n", __func__);
+}
+
 static void pxa_videobuf_queue(struct videobuf_queue *vq,
 			       struct videobuf_buffer *vb)
 {
@@ -523,81 +615,23 @@ static void pxa_videobuf_queue(struct videobuf_queue *vq,
 	struct soc_camera_host *ici = to_soc_camera_host(icd->dev.parent);
 	struct pxa_camera_dev *pcdev = ici->priv;
 	struct pxa_buffer *buf = container_of(vb, struct pxa_buffer, vb);
-	struct pxa_buffer *active;
 	unsigned long flags;
-	int i;
 
-	dev_dbg(&icd->dev, "%s (vb=0x%p) 0x%08lx %d\n", __func__,
-		vb, vb->baddr, vb->bsize);
-	spin_lock_irqsave(&pcdev->lock, flags);
+	dev_dbg(&icd->dev, "%s (vb=0x%p) 0x%08lx %d active=%p\n", __func__,
+		vb, vb->baddr, vb->bsize, pcdev->active);
 
+	spin_lock_irqsave(&pcdev->lock, flags);
 	list_add_tail(&vb->queue, &pcdev->capture);
 
 	vb->state = VIDEOBUF_ACTIVE;
-	active = pcdev->active;
-
-	if (!active) {
-		unsigned long cifr, cicr0;
-
-		cifr = __raw_readl(pcdev->base + CIFR) | CIFR_RESET_F;
-		__raw_writel(cifr, pcdev->base + CIFR);
-
-		for (i = 0; i < pcdev->channels; i++) {
-			DDADR(pcdev->dma_chans[i]) = buf->dmas[i].sg_dma;
-			DCSR(pcdev->dma_chans[i]) = DCSR_RUN;
-			pcdev->sg_tail[i] = buf->dmas[i].sg_cpu + buf->dmas[i].sglen - 1;
-		}
 
-		pcdev->active = buf;
+	pxa_dma_stop_channels(pcdev);
+	pxa_dma_add_tail_buf(pcdev, buf);
 
-		cicr0 = __raw_readl(pcdev->base + CICR0) | CICR0_ENB;
-		__raw_writel(cicr0, pcdev->base + CICR0);
-	} else {
-		struct pxa_cam_dma *buf_dma;
-		struct pxa_cam_dma *act_dma;
-		int nents;
-
-		for (i = 0; i < pcdev->channels; i++) {
-			buf_dma = &buf->dmas[i];
-			act_dma = &active->dmas[i];
-			nents = buf_dma->sglen;
-
-			/* Stop DMA engine */
-			DCSR(pcdev->dma_chans[i]) = 0;
-
-			/* Add the descriptors we just initialized to
-			   the currently running chain */
-			pcdev->sg_tail[i]->ddadr = buf_dma->sg_dma;
-			pcdev->sg_tail[i] = buf_dma->sg_cpu + buf_dma->sglen - 1;
-
-			/* Setup a dummy descriptor with the DMA engines current
-			 * state
-			 */
-			buf_dma->sg_cpu[nents].dsadr =
-				pcdev->res->start + 0x28 + i*8; /* CIBRx */
-			buf_dma->sg_cpu[nents].dtadr =
-				DTADR(pcdev->dma_chans[i]);
-			buf_dma->sg_cpu[nents].dcmd =
-				DCMD(pcdev->dma_chans[i]);
-
-			if (DDADR(pcdev->dma_chans[i]) == DDADR_STOP) {
-				/* The DMA engine is on the last
-				   descriptor, set the next descriptors
-				   address to the descriptors we just
-				   initialized */
-				buf_dma->sg_cpu[nents].ddadr = buf_dma->sg_dma;
-			} else {
-				buf_dma->sg_cpu[nents].ddadr =
-					DDADR(pcdev->dma_chans[i]);
-			}
-
-			/* The next descriptor is the dummy descriptor */
-			DDADR(pcdev->dma_chans[i]) = buf_dma->sg_dma + nents *
-				sizeof(struct pxa_dma_desc);
-
-			DCSR(pcdev->dma_chans[i]) = DCSR_RUN;
-		}
-	}
+	if (!pcdev->active)
+		pxa_camera_start_capture(pcdev);
+	else
+		pxa_dma_start_channels(pcdev);
 
 	spin_unlock_irqrestore(&pcdev->lock, flags);
 }
@@ -635,7 +669,7 @@ static void pxa_camera_wakeup(struct pxa_camera_dev *pcdev,
 			      struct videobuf_buffer *vb,
 			      struct pxa_buffer *buf)
 {
-	unsigned long cicr0;
+	int i;
 
 	/* _init is used to debug races, see comment in pxa_camera_reqbufs() */
 	list_del_init(&vb->queue);
@@ -643,15 +677,13 @@ static void pxa_camera_wakeup(struct pxa_camera_dev *pcdev,
 	do_gettimeofday(&vb->ts);
 	vb->field_count++;
 	wake_up(&vb->done);
+	dev_dbg(pcdev->dev, "%s dequeud buffer (vb=0x%p)\n", __func__, vb);
 
 	if (list_empty(&pcdev->capture)) {
+		pxa_camera_stop_capture(pcdev);
 		pcdev->active = NULL;
-		DCSR(pcdev->dma_chans[0]) = 0;
-		DCSR(pcdev->dma_chans[1]) = 0;
-		DCSR(pcdev->dma_chans[2]) = 0;
-
-		cicr0 = __raw_readl(pcdev->base + CICR0) & ~CICR0_ENB;
-		__raw_writel(cicr0, pcdev->base + CICR0);
+		for (i = 0; i < pcdev->channels; i++)
+			pcdev->sg_tail[i] = NULL;
 		return;
 	}
 
@@ -666,19 +698,23 @@ static void pxa_camera_dma_irq(int channel, struct pxa_camera_dev *pcdev,
 	unsigned long flags;
 	u32 status, camera_status, overrun;
 	struct videobuf_buffer *vb;
-	unsigned long cifr, cicr0;
 
 	spin_lock_irqsave(&pcdev->lock, flags);
 
 	status = DCSR(channel);
-	DCSR(channel) = status | DCSR_ENDINTR;
+	DCSR(channel) = status | DCSR_STARTINTR | DCSR_ENDINTR;
+
+	camera_status = __raw_readl(pcdev->base + CISR);
+	overrun = CISR_IFO_0;
+	if (pcdev->channels == 3)
+		overrun |= CISR_IFO_1 | CISR_IFO_2;
 
 	if (status & DCSR_BUSERR) {
 		dev_err(pcdev->dev, "DMA Bus Error IRQ!\n");
 		goto out;
 	}
 
-	if (!(status & DCSR_ENDINTR)) {
+	if (!(status & (DCSR_ENDINTR | DCSR_STARTINTR))) {
 		dev_err(pcdev->dev, "Unknown DMA IRQ source, "
 			"status: 0x%08x\n", status);
 		goto out;
@@ -689,38 +725,27 @@ static void pxa_camera_dma_irq(int channel, struct pxa_camera_dev *pcdev,
 		goto out;
 	}
 
-	camera_status = __raw_readl(pcdev->base + CISR);
-	overrun = CISR_IFO_0;
-	if (pcdev->channels == 3)
-		overrun |= CISR_IFO_1 | CISR_IFO_2;
-	if (camera_status & overrun) {
-		dev_dbg(pcdev->dev, "FIFO overrun! CISR: %x\n", camera_status);
-		/* Stop the Capture Interface */
-		cicr0 = __raw_readl(pcdev->base + CICR0) & ~CICR0_ENB;
-		__raw_writel(cicr0, pcdev->base + CICR0);
-
-		/* Stop DMA */
-		DCSR(channel) = 0;
-		/* Reset the FIFOs */
-		cifr = __raw_readl(pcdev->base + CIFR) | CIFR_RESET_F;
-		__raw_writel(cifr, pcdev->base + CIFR);
-		/* Enable End-Of-Frame Interrupt */
-		cicr0 &= ~CICR0_EOFM;
-		__raw_writel(cicr0, pcdev->base + CICR0);
-		/* Restart the Capture Interface */
-		__raw_writel(cicr0 | CICR0_ENB, pcdev->base + CICR0);
-		goto out;
-	}
-
 	vb = &pcdev->active->vb;
 	buf = container_of(vb, struct pxa_buffer, vb);
 	WARN_ON(buf->inwork || list_empty(&vb->queue));
-	dev_dbg(pcdev->dev, "%s (vb=0x%p) 0x%08lx %d\n", __func__,
-		vb, vb->baddr, vb->bsize);
 
-	buf->active_dma &= ~act_dma;
-	if (!buf->active_dma)
-		pxa_camera_wakeup(pcdev, vb, buf);
+	dev_dbg(pcdev->dev, "%s channel=%d %s%s(vb=0x%p) dma.desc=%x\n",
+		__func__, channel, status & DCSR_STARTINTR ? "SOF " : "",
+		status & DCSR_ENDINTR ? "EOF " : "", vb, DDADR(channel));
+
+	if (status & DCSR_ENDINTR) {
+		if (camera_status & overrun) {
+			dev_dbg(pcdev->dev, "FIFO overrun! CISR: %x\n",
+				camera_status);
+			pxa_camera_stop_capture(pcdev);
+			pxa_camera_start_capture(pcdev);
+			goto out;
+		}
+
+		buf->active_dma &= ~act_dma;
+		if (!buf->active_dma)
+			pxa_camera_wakeup(pcdev, vb, buf);
+	}
 
 out:
 	spin_unlock_irqrestore(&pcdev->lock, flags);
@@ -859,12 +884,11 @@ static irqreturn_t pxa_camera_irq(int irq, void *data)
 	__raw_writel(status, pcdev->base + CISR);
 
 	if (status & CISR_EOF) {
-		int i;
-		for (i = 0; i < pcdev->channels; i++) {
-			DDADR(pcdev->dma_chans[i]) =
-				pcdev->active->dmas[i].sg_dma;
-			DCSR(pcdev->dma_chans[i]) = DCSR_RUN;
-		}
+		pcdev->active = list_first_entry(&pcdev->capture,
+					   struct pxa_buffer, vb.queue);
+
+		pxa_dma_start_channels(pcdev);
+
 		cicr0 = __raw_readl(pcdev->base + CICR0) | CICR0_EOFM;
 		__raw_writel(cicr0, pcdev->base + CICR0);
 	}
@@ -1404,18 +1428,8 @@ static int pxa_camera_resume(struct soc_camera_device *icd)
 		ret = pcdev->icd->ops->resume(pcdev->icd);
 
 	/* Restart frame capture if active buffer exists */
-	if (!ret && pcdev->active) {
-		unsigned long cifr, cicr0;
-
-		/* Reset the FIFOs */
-		cifr = __raw_readl(pcdev->base + CIFR) | CIFR_RESET_F;
-		__raw_writel(cifr, pcdev->base + CIFR);
-
-		cicr0 = __raw_readl(pcdev->base + CICR0);
-		cicr0 &= ~CICR0_EOFM;	/* Enable End-Of-Frame Interrupt */
-		cicr0 |= CICR0_ENB;	/* Restart the Capture Interface */
-		__raw_writel(cicr0, pcdev->base + CICR0);
-	}
+	if (!ret && pcdev->active)
+		pxa_camera_start_capture(pcdev);
 
 	return ret;
 }
-- 
1.5.6.5

