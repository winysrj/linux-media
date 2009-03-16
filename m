Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp5-g21.free.fr ([212.27.42.5]:51104 "EHLO smtp5-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755574AbZCPWQv (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 16 Mar 2009 18:16:51 -0400
From: Robert Jarzmik <robert.jarzmik@free.fr>
To: g.liakhovetski@gmx.de
Cc: linux-media@vger.kernel.org,
	Robert Jarzmik <robert.jarzmik@free.fr>
Subject: [PATCH v3 3/4] pxa_camera: Redesign DMA handling
Date: Mon, 16 Mar 2009 23:16:36 +0100
Message-Id: <1237241797-381-4-git-send-email-robert.jarzmik@free.fr>
In-Reply-To: <1237241797-381-3-git-send-email-robert.jarzmik@free.fr>
References: <1237241797-381-1-git-send-email-robert.jarzmik@free.fr>
 <1237241797-381-2-git-send-email-robert.jarzmik@free.fr>
 <1237241797-381-3-git-send-email-robert.jarzmik@free.fr>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The DMA transfers in pxa_camera showed some weaknesses in
multiple queued buffers context :
 - poll/select problem
   The bug shows up with capture_example tool from v4l2 hg
   tree. The process just "stalls" on a "select timeout".

 - multiple buffers DMA starting
   When multiple buffers were queued, the DMA channels were
   always started right away. This is not optimal, as a
   special case appears when the first EOF was not yet
   reached, and the DMA channels were prematurely started.

 - Maintainability
   DMA code was a bit obfuscated. Rationalize the code to be
   easily maintainable by anyone.

 - DMA hot chaining
   DMA is not stopped anymore to queue a buffer, the buffer
   is queued with DMA running. As a tribute, a corner case
   exists where chaining happens while DMA finishes the
   chain, and the capture is restarted to deal with the
   missed link buffer.

This patch attemps to address these issues / improvements.

Signed-off-by: Robert Jarzmik <robert.jarzmik@free.fr>
---
 Documentation/video4linux/pxa_camera.txt |  125 ++++++++++++
 drivers/media/video/pxa_camera.c         |  319 ++++++++++++++++++------------
 2 files changed, 316 insertions(+), 128 deletions(-)
 create mode 100644 Documentation/video4linux/pxa_camera.txt

diff --git a/Documentation/video4linux/pxa_camera.txt b/Documentation/video4linux/pxa_camera.txt
new file mode 100644
index 0000000..b1137f9
--- /dev/null
+++ b/Documentation/video4linux/pxa_camera.txt
@@ -0,0 +1,125 @@
+                              PXA-Camera Host Driver
+                              ======================
+
+Constraints
+-----------
+  a) Image size for YUV422P format
+     All YUV422P images are enforced to have width x height % 16 = 0.
+     This is due to DMA constraints, which transfers only planes of 8 byte
+     multiples.
+
+
+Global video workflow
+---------------------
+  a) QCI stopped
+     Initialy, the QCI interface is stopped.
+     When a buffer is queued (pxa_videobuf_ops->buf_queue), the QCI starts.
+
+  b) QCI started
+     More buffers can be queued while the QCI is started without halting the
+     capture.  The new buffers are "appended" at the tail of the DMA chain, and
+     smoothly captured one frame after the other.
+
+     Once a buffer is filled in the QCI interface, it is marked as "DONE" and
+     removed from the active buffers list. It can be then requeud or dequeued by
+     userland application.
+
+     Once the last buffer is filled in, the QCI interface stops.
+
+
+DMA usage
+---------
+  a) DMA flow
+     - first buffer queued for capture
+       Once a first buffer is queued for capture, the QCI is started, but data
+       transfer is not started. On "End Of Frame" interrupt, the irq handler
+       starts the DMA chain.
+     - capture of one videobuffer
+       The DMA chain starts transfering data into videobuffer RAM pages.
+       When all pages are transfered, the DMA irq is raised on "ENDINTR" status
+     - finishing one videobuffer
+       The DMA irq handler marks the videobuffer as "done", and removes it from
+       the active running queue
+       Meanwhile, the next videobuffer (if there is one), is transfered by DMA
+     - finishing the last videobuffer
+       On the DMA irq of the last videobuffer, the QCI is stopped.
+
+  b) DMA prepared buffer will have this structure
+
+     +------------+-----+---------------+-----------------+
+     | desc-sg[0] | ... | desc-sg[last] | finisher/linker |
+     +------------+-----+---------------+-----------------+
+
+     This structure is pointed by dma->sg_cpu.
+     The descriptors are used as follows :
+      - desc-sg[i]: i-th descriptor, transfering the i-th sg
+        element to the video buffer scatter gather
+      - finisher: has ddadr=DADDR_STOP, dcmd=ENDIRQEN
+      - linker: has ddadr= desc-sg[0] of next video buffer, dcmd=0
+
+     For the next schema, let's assume d0=desc-sg[0] .. dN=desc-sg[N],
+     "f" stands for finisher and "l" for linker.
+     A typical running chain is :
+
+         Videobuffer 1         Videobuffer 2
+     +---------+----+---+  +----+----+----+---+
+     | d0 | .. | dN | l |  | d0 | .. | dN | f |
+     +---------+----+-|-+  ^----+----+----+---+
+                      |    |
+                      +----+
+
+     After the chaining is finished, the chain looks like :
+
+         Videobuffer 1         Videobuffer 2         Videobuffer 3
+     +---------+----+---+  +----+----+----+---+  +----+----+----+---+
+     | d0 | .. | dN | l |  | d0 | .. | dN | l |  | d0 | .. | dN | f |
+     +---------+----+-|-+  ^----+----+----+-|-+  ^----+----+----+---+
+                      |    |                |    |
+                      +----+                +----+
+                                           new_link
+
+  c) DMA hot chaining timeslice issue
+
+     As DMA chaining is done while DMA _is_ running, the linking may be done
+     while the DMA jumps from one Videobuffer to another. On the schema, that
+     would be a problem if the following sequence is encountered :
+
+      - DMA chain is Videobuffer1 + Videobuffer2
+      - pxa_videobuf_queue() is called to queue Videobuffer3
+      - DMA controller finishes Videobuffer2, and DMA stops
+      =>
+         Videobuffer 1         Videobuffer 2
+     +---------+----+---+  +----+----+----+---+
+     | d0 | .. | dN | l |  | d0 | .. | dN | f |
+     +---------+----+-|-+  ^----+----+----+-^-+
+                      |    |                |
+                      +----+                +-- DMA DDADR loads DDADR_STOP
+
+      - pxa_dma_add_tail_buf() is called, the Videobuffer2 "finisher" is
+        replaced by a "linker" to Videobuffer3 (creation of new_link)
+      - pxa_videobuf_queue() finishes
+      - the DMA irq handler is called, which terminates Videobuffer2
+      - Videobuffer3 capture is not scheduled on DMA chain (as it stopped !!!)
+
+         Videobuffer 1         Videobuffer 2         Videobuffer 3
+     +---------+----+---+  +----+----+----+---+  +----+----+----+---+
+     | d0 | .. | dN | l |  | d0 | .. | dN | l |  | d0 | .. | dN | f |
+     +---------+----+-|-+  ^----+----+----+-|-+  ^----+----+----+---+
+                      |    |                |    |
+                      +----+                +----+
+                                           new_link
+                                          DMA DDADR still is DDADR_STOP
+
+      - pxa_camera_check_link_miss() is called
+        This checks if the DMA is finished and a buffer is still on the
+        pcdev->capture list. If that's the case, the capture will be restarted,
+        and Videobuffer3 is scheduled on DMA chain.
+      - the DMA irq handler finishes
+
+     Note: if DMA stops just after pxa_camera_check_link_miss() reads DDADR()
+     value, we have the guarantee that the DMA irq handler will be called back
+     when the DMA will finish the buffer, and pxa_camera_check_link_miss() will
+     be called again, to reschedule Videobuffer3.
+
+--
+Author: Robert Jarzmik <robert.jarzmik@free.fr>
diff --git a/drivers/media/video/pxa_camera.c b/drivers/media/video/pxa_camera.c
index 3155c5c..a6aa7de 100644
--- a/drivers/media/video/pxa_camera.c
+++ b/drivers/media/video/pxa_camera.c
@@ -369,6 +369,10 @@ static int pxa_init_dma_channel(struct pxa_camera_dev *pcdev,
 		pxa_dma->sg_cpu[i].dtadr = sg_dma_address(sg) + offset;
 		pxa_dma->sg_cpu[i].dcmd =
 			DCMD_FLOWSRC | DCMD_BURST8 | DCMD_INCTRGADDR | xfer_len;
+#ifdef DEBUG
+		if (!i)
+			pxa_dma->sg_cpu[i].dcmd |= DCMD_STARTIRQEN;
+#endif
 		pxa_dma->sg_cpu[i].ddadr =
 			pxa_dma->sg_dma + (i + 1) * sizeof(struct pxa_dma_desc);
 
@@ -381,8 +385,8 @@ static int pxa_init_dma_channel(struct pxa_camera_dev *pcdev,
 			break;
 	}
 
-	pxa_dma->sg_cpu[sglen - 1].ddadr = DDADR_STOP;
-	pxa_dma->sg_cpu[sglen - 1].dcmd |= DCMD_ENDIRQEN;
+	pxa_dma->sg_cpu[sglen].ddadr = DDADR_STOP;
+	pxa_dma->sg_cpu[sglen].dcmd  = DCMD_FLOWSRC | DCMD_BURST8 | DCMD_ENDIRQEN;
 
 	/*
 	 * Handle 1 special case :
@@ -402,6 +406,20 @@ static int pxa_init_dma_channel(struct pxa_camera_dev *pcdev,
 	return 0;
 }
 
+static void pxa_videobuf_set_actdma(struct pxa_camera_dev *pcdev,
+				    struct pxa_buffer *buf)
+{
+	buf->active_dma = DMA_Y;
+	if (pcdev->channels == 3)
+		buf->active_dma |= DMA_U | DMA_V;
+}
+
+/*
+ * Please check the DMA prepared buffer structure in :
+ *   Documentation/video4linux/pxa_camera.txt
+ * Please check also in pxa_camera_check_link_miss() to understand why DMA chain
+ * modification while DMA chain is running will work anyway.
+ */
 static int pxa_videobuf_prepare(struct videobuf_queue *vq,
 		struct videobuf_buffer *vb, enum v4l2_field field)
 {
@@ -499,9 +517,7 @@ static int pxa_videobuf_prepare(struct videobuf_queue *vq,
 	}
 
 	buf->inwork = 0;
-	buf->active_dma = DMA_Y;
-	if (pcdev->channels == 3)
-		buf->active_dma |= DMA_U | DMA_V;
+	pxa_videobuf_set_actdma(pcdev, buf);
 
 	return 0;
 
@@ -518,6 +534,99 @@ out:
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
+	for (i = 0; i < pcdev->channels; i++)
+		pcdev->sg_tail[i] = buf->dmas[i].sg_cpu + buf->dmas[i].sglen;
+}
+
+static void pxa_dma_add_tail_buf(struct pxa_camera_dev *pcdev,
+				 struct pxa_buffer *buf)
+{
+	int i;
+	struct pxa_dma_desc *buf_last_desc;
+
+	for (i = 0; i < pcdev->channels; i++) {
+		buf_last_desc = buf->dmas[i].sg_cpu + buf->dmas[i].sglen;
+		buf_last_desc->ddadr = DDADR_STOP;
+
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
+	/* Reset the FIFOs */
+	cifr = __raw_readl(pcdev->base + CIFR) | CIFR_RESET_F;
+	__raw_writel(cifr, pcdev->base + CIFR);
+	/* Enable End-Of-Frame Interrupt */
+	cicr0 = __raw_readl(pcdev->base + CICR0) | CICR0_ENB;
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
@@ -525,81 +634,20 @@ static void pxa_videobuf_queue(struct videobuf_queue *vq,
 	struct soc_camera_host *ici = to_soc_camera_host(icd->dev.parent);
 	struct pxa_camera_dev *pcdev = ici->priv;
 	struct pxa_buffer *buf = container_of(vb, struct pxa_buffer, vb);
-	struct pxa_buffer *active;
 	unsigned long flags;
-	int i;
 
-	dev_dbg(&icd->dev, "%s (vb=0x%p) 0x%08lx %d\n", __func__,
-		vb, vb->baddr, vb->bsize);
+	dev_dbg(&icd->dev, "%s (vb=0x%p) 0x%08lx %d active=%p\n", __func__,
+		vb, vb->baddr, vb->bsize, pcdev->active);
+
 	spin_lock_irqsave(&pcdev->lock, flags);
 
 	list_add_tail(&vb->queue, &pcdev->capture);
 
 	vb->state = VIDEOBUF_ACTIVE;
-	active = pcdev->active;
+	pxa_dma_add_tail_buf(pcdev, buf);
 
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
-
-		pcdev->active = buf;
-
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
 
 	spin_unlock_irqrestore(&pcdev->lock, flags);
 }
@@ -637,7 +685,7 @@ static void pxa_camera_wakeup(struct pxa_camera_dev *pcdev,
 			      struct videobuf_buffer *vb,
 			      struct pxa_buffer *buf)
 {
-	unsigned long cicr0;
+	int i;
 
 	/* _init is used to debug races, see comment in pxa_camera_reqbufs() */
 	list_del_init(&vb->queue);
@@ -645,15 +693,13 @@ static void pxa_camera_wakeup(struct pxa_camera_dev *pcdev,
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
 
@@ -661,6 +707,35 @@ static void pxa_camera_wakeup(struct pxa_camera_dev *pcdev,
 				   struct pxa_buffer, vb.queue);
 }
 
+/**
+ * pxa_camera_check_link_miss - check missed DMA linking
+ * @pcdev: camera device
+ *
+ * The DMA chaining is done with DMA running. This means a tiny temporal window
+ * remains, where a buffer is queued on the chain, while the chain is already
+ * stopped. This means the tailed buffer would never be transfered by DMA.
+ * This function restarts the capture for this corner case, where :
+ *  - DADR() == DADDR_STOP
+ *  - a videobuffer is queued on the pcdev->capture list
+ *
+ * Please check the "DMA hot chaining timeslice issue" in
+ *   Documentation/video4linux/pxa_camera.txt
+ *
+ * Context: should only be called within the dma irq handler
+ */
+static void pxa_camera_check_link_miss(struct pxa_camera_dev *pcdev)
+{
+	int i, is_dma_stopped = 1;
+
+	for (i = 0; i < pcdev->channels; i++)
+		if (DDADR(pcdev->dma_chans[i]) != DDADR_STOP)
+			is_dma_stopped = 0;
+	dev_dbg(pcdev->dev, "%s : top queued buffer=%p, dma_stopped=%d\n",
+		__func__, pcdev->active, is_dma_stopped);
+	if (pcdev->active && is_dma_stopped)
+		pxa_camera_start_capture(pcdev);
+}
+
 static void pxa_camera_dma_irq(int channel, struct pxa_camera_dev *pcdev,
 			       enum pxa_camera_active_dma act_dma)
 {
@@ -668,19 +743,23 @@ static void pxa_camera_dma_irq(int channel, struct pxa_camera_dev *pcdev,
 	unsigned long flags;
 	u32 status, camera_status, overrun;
 	struct videobuf_buffer *vb;
-	unsigned long cifr, cicr0;
 
 	spin_lock_irqsave(&pcdev->lock, flags);
 
 	status = DCSR(channel);
-	DCSR(channel) = status | DCSR_ENDINTR;
+	DCSR(channel) = status;
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
@@ -691,38 +770,28 @@ static void pxa_camera_dma_irq(int channel, struct pxa_camera_dev *pcdev,
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
+		buf->active_dma &= ~act_dma;
+		if (!buf->active_dma) {
+			pxa_camera_wakeup(pcdev, vb, buf);
+			pxa_camera_check_link_miss(pcdev);
+		}
+	}
 
 out:
 	spin_unlock_irqrestore(&pcdev->lock, flags);
@@ -851,6 +920,8 @@ static irqreturn_t pxa_camera_irq(int irq, void *data)
 {
 	struct pxa_camera_dev *pcdev = data;
 	unsigned long status, cicr0;
+	struct pxa_buffer *buf;
+	struct videobuf_buffer *vb;
 
 	status = __raw_readl(pcdev->base + CISR);
 	dev_dbg(pcdev->dev, "Camera interrupt status 0x%lx\n", status);
@@ -861,12 +932,14 @@ static irqreturn_t pxa_camera_irq(int irq, void *data)
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
+		vb = &pcdev->active->vb;
+		buf = container_of(vb, struct pxa_buffer, vb);
+		pxa_videobuf_set_actdma(pcdev, buf);
+
+		pxa_dma_start_channels(pcdev);
+
 		cicr0 = __raw_readl(pcdev->base + CICR0) | CICR0_EOFM;
 		__raw_writel(cicr0, pcdev->base + CICR0);
 	}
@@ -1418,18 +1491,8 @@ static int pxa_camera_resume(struct soc_camera_device *icd)
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

