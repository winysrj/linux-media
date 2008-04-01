Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m31Axqjl013500
	for <video4linux-list@redhat.com>; Tue, 1 Apr 2008 06:59:52 -0400
Received: from mxout10.netvision.net.il (mxout10.netvision.net.il
	[194.90.6.38])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m31Axd36030798
	for <video4linux-list@redhat.com>; Tue, 1 Apr 2008 06:59:40 -0400
Received: from mail.linux-boards.com ([62.90.235.247])
	by mxout10.netvision.net.il
	(Sun Java System Messaging Server 6.2-8.04 (built Feb 28 2007))
	with ESMTP id <0JYN00GEL7YUBM30@mxout10.netvision.net.il> for
	video4linux-list@redhat.com; Tue, 01 Apr 2008 14:01:43 +0300 (IDT)
Date: Tue, 01 Apr 2008 13:59:31 +0300
From: Mike Rapoport <mike@compulab.co.il>
To: g.liakhovetski@pengutronix.de
Message-id: <47F21593.7080507@compulab.co.il>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7BIT
Cc: video4linux-list@redhat.com
Subject: [PATCH] pxa_camera: Add support for YUV modes
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <video4linux-list@redhat.com>

This patch adds support for YUV packed and planar capture for pxa_camera.

-- 
Sincerely yours,
Mike.

Signed-off-by: Mike Rapoport <mike@compulab.co.il>

diff -r 0776e4801991 linux/drivers/media/video/pxa_camera.c
--- a/linux/drivers/media/video/pxa_camera.c	Fri Mar 28 14:52:44 2008 -0300
+++ b/linux/drivers/media/video/pxa_camera.c	Tue Apr 01 13:53:47 2008 +0300
@@ -67,9 +67,24 @@

 static DEFINE_MUTEX(camera_lock);

+#define BUFFER_TIMEOUT     msecs_to_jiffies(1000)  /* 0.5 seconds */
+
 /*
  * Structures
  */
+enum pxa_camera_active_dma {
+	DMA_Y = 0x1,
+	DMA_U = 0x2,
+	DMA_V = 0x4,
+};
+
+/* descriptor needed for the PXA DMA engine */
+struct pxa_cam_dma {
+	dma_addr_t		sg_dma;
+	struct pxa_dma_desc	*sg_cpu;
+	size_t			sg_size;
+	int			sglen;
+};

 /* buffer for one video frame */
 struct pxa_buffer {
@@ -78,11 +93,12 @@ struct pxa_buffer {

 	const struct soc_camera_data_format        *fmt;

-	/* our descriptor list needed for the PXA DMA engine */
-	dma_addr_t		sg_dma;
-	struct pxa_dma_desc	*sg_cpu;
-	size_t			sg_size;
+	/* our descriptor lists for Y, U and V channels */
+	struct pxa_cam_dma dmas[3];
+
 	int			inwork;
+
+	enum pxa_camera_active_dma active_dma;
 };

 struct pxa_framebuffer_queue {
@@ -100,7 +116,8 @@ struct pxa_camera_dev {

 	unsigned int		irq;
 	void __iomem		*base;
-	unsigned int		dma_chan_y;
+
+	unsigned int		dma_chans[3];

 	struct pxacamera_platform_data *pdata;
 	struct resource		*res;
@@ -108,6 +125,8 @@ struct pxa_camera_dev {
 	unsigned long		platform_mclk_10khz;

 	struct list_head	capture;
+
+	struct timer_list	timeout;

 	spinlock_t		lock;

@@ -128,7 +147,15 @@ static int pxa_videobuf_setup(struct vid

 	dev_dbg(&icd->dev, "count=%d, size=%d\n", *count, *size);

-	*size = icd->width * icd->height * ((icd->current_fmt->depth + 7) >> 3);
+	/* planar capture requires Y, U and V buffers to be page aligned */
+	if (icd->current_fmt->fourcc == V4L2_PIX_FMT_YUV422P) {
+		*size = PAGE_ALIGN(icd->width * icd->height); /* Y pages */
+		*size += PAGE_ALIGN(icd->width * icd->height / 2); /* U pages */
+		*size += PAGE_ALIGN(icd->width * icd->height / 2); /* V pages */
+	} else {
+		*size = icd->width * icd->height *
+			((icd->current_fmt->depth + 7) >> 3);
+	}

 	if (0 == *count)
 		*count = 32;
@@ -145,6 +172,7 @@ static void free_buffer(struct videobuf_
 		to_soc_camera_host(icd->dev.parent);
 	struct pxa_camera_dev *pcdev = ici->priv;
 	struct videobuf_dmabuf *dma = videobuf_to_dma(&buf->vb);
+	int i;

 	BUG_ON(in_interrupt());

@@ -157,12 +185,60 @@ static void free_buffer(struct videobuf_
 	videobuf_dma_unmap(vq, dma);
 	videobuf_dma_free(dma);

-	if (buf->sg_cpu)
-		dma_free_coherent(pcdev->dev, buf->sg_size, buf->sg_cpu,
-				  buf->sg_dma);
-	buf->sg_cpu = NULL;
+	for (i = 0; i < ARRAY_SIZE(buf->dmas); i++) {
+		if (buf->dmas[i].sg_cpu)
+			dma_free_coherent(pcdev->dev, buf->dmas[i].sg_size,
+					  buf->dmas[i].sg_cpu,
+					  buf->dmas[i].sg_dma);
+		buf->dmas[i].sg_cpu = NULL;
+	}

 	buf->vb.state = VIDEOBUF_NEEDS_INIT;
+}
+
+static int pxa_init_dma_channel(struct pxa_camera_dev *pcdev,
+				struct pxa_buffer *buf,
+				struct videobuf_dmabuf *dma, int channel,
+				int sglen, int sg_start, int cibr, int size)
+{
+	struct pxa_cam_dma *pxa_dma = &buf->dmas[channel];
+	int i;
+
+	if (pxa_dma->sg_cpu)
+		dma_free_coherent(pcdev->dev, pxa_dma->sg_size,
+				  pxa_dma->sg_cpu, pxa_dma->sg_dma);
+
+	pxa_dma->sg_size = (sglen + 1) * sizeof(struct pxa_dma_desc);
+	pxa_dma->sg_cpu = dma_alloc_coherent(pcdev->dev, pxa_dma->sg_size,
+					     &pxa_dma->sg_dma, GFP_KERNEL);
+	if (!pxa_dma->sg_cpu)
+		return -ENOMEM;
+
+	pxa_dma->sglen = sglen;
+
+	/* DMA for Y buffers */
+	for (i = 0; i < sglen; i++) {
+		int sg_i = sg_start + i;
+		struct scatterlist *sg = dma->sglist;
+		unsigned int dma_len = sg_dma_len(&sg[sg_i]), xfer_len;
+
+		pxa_dma->sg_cpu[i].dsadr = pcdev->res->start + cibr;
+		pxa_dma->sg_cpu[i].dtadr = sg_dma_address(&sg[sg_i]);
+
+		/* PXA27x Developer's Manual 27.4.4.1: round up to 8 bytes */
+		xfer_len = (min(dma_len, size) + 7) & ~7;
+
+		pxa_dma->sg_cpu[i].dcmd =
+			DCMD_FLOWSRC | DCMD_BURST8 | DCMD_INCTRGADDR | xfer_len;
+		size -= dma_len;
+		pxa_dma->sg_cpu[i].ddadr =
+			pxa_dma->sg_dma + (i + 1) * sizeof(struct pxa_dma_desc);
+	}
+	/* end of Y pages */
+	pxa_dma->sg_cpu[sglen - 1].ddadr = DDADR_STOP;
+	pxa_dma->sg_cpu[sglen - 1].dcmd |= DCMD_ENDIRQEN;
+
+	return 0;
 }

 static int pxa_videobuf_prepare(struct videobuf_queue *vq,
@@ -173,7 +249,8 @@ static int pxa_videobuf_prepare(struct v
 		to_soc_camera_host(icd->dev.parent);
 	struct pxa_camera_dev *pcdev = ici->priv;
 	struct pxa_buffer *buf = container_of(vb, struct pxa_buffer, vb);
-	int i, ret;
+	int ret;
+	int sglen_y, sglen_u, sglen_v, sglen_yu, size_y, size_uv;

 	dev_dbg(&icd->dev, "%s (vb=0x%p) 0x%08lx %d\n", __FUNCTION__,
 		vb, vb->baddr, vb->bsize);
@@ -218,49 +295,61 @@ static int pxa_videobuf_prepare(struct v
 		if (ret)
 			goto fail;

-		if (buf->sg_cpu)
-			dma_free_coherent(pcdev->dev, buf->sg_size, buf->sg_cpu,
-					  buf->sg_dma);
-
-		buf->sg_size = (dma->sglen + 1) * sizeof(struct pxa_dma_desc);
-		buf->sg_cpu = dma_alloc_coherent(pcdev->dev, buf->sg_size,
-						 &buf->sg_dma, GFP_KERNEL);
-		if (!buf->sg_cpu) {
-			ret = -ENOMEM;
+		if (buf->fmt->fourcc == V4L2_PIX_FMT_YUV422P) {
+			/* FIXME the calculations should be more precise */
+			sglen_y = dma->sglen / 2;
+			sglen_u = sglen_v = dma->sglen / 4 + 1;
+			sglen_yu = sglen_y + dma->sglen / 4 + 1;
+			size_y = size / 2;
+			size_uv = size / 4;
+		} else {
+			sglen_y = dma->sglen;
+			size_y = size;
+		}
+
+		ret = pxa_init_dma_channel(pcdev, buf, dma, 0, sglen_y,
+					   0, 0x28, size_y);
+
+		if (ret) {
+			dev_err(pcdev->dev,
+				"DMA initialization for Y/RGB failed\n");
 			goto fail;
 		}

-		dev_dbg(&icd->dev, "nents=%d size: %d sg=0x%p\n",
-			dma->sglen, size, dma->sglist);
-		for (i = 0; i < dma->sglen; i++) {
-			struct scatterlist *sg = dma->sglist;
-			unsigned int dma_len = sg_dma_len(&sg[i]), xfer_len;
-
-			/* CIBR0 */
-			buf->sg_cpu[i].dsadr = pcdev->res->start + 0x28;
-			buf->sg_cpu[i].dtadr = sg_dma_address(&sg[i]);
-			/* PXA270 Developer's Manual 27.4.4.1:
-			 * round up to 8 bytes */
-			xfer_len = (min(dma_len, size) + 7) & ~7;
-			if (xfer_len & 7)
-				dev_err(&icd->dev, "Unaligned buffer: "
-					"dma_len %u, size %u\n", dma_len, size);
-			buf->sg_cpu[i].dcmd = DCMD_FLOWSRC | DCMD_BURST8 |
-				DCMD_INCTRGADDR | xfer_len;
-			size -= dma_len;
-			buf->sg_cpu[i].ddadr = buf->sg_dma + (i + 1) *
-					sizeof(struct pxa_dma_desc);
+		if (buf->fmt->fourcc == V4L2_PIX_FMT_YUV422P) {
+			ret = pxa_init_dma_channel(pcdev, buf, dma, 1, sglen_y,
+						   sglen_y, 0x30, size_uv);
+			if (ret) {
+				dev_err(pcdev->dev,
+					"DMA initialization for U failed\n");
+				goto fail_u;
+			}
+
+			ret = pxa_init_dma_channel(pcdev, buf, dma, 2, sglen_y,
+						   sglen_yu, 0x38, size_uv);
+			if (ret) {
+				dev_err(pcdev->dev,
+					"DMA initialization for V failed\n");
+				goto fail_v;
+			}
 		}
-		buf->sg_cpu[dma->sglen - 1].ddadr = DDADR_STOP;
-		buf->sg_cpu[dma->sglen - 1].dcmd |= DCMD_ENDIRQEN;

 		vb->state = VIDEOBUF_PREPARED;
 	}

 	buf->inwork = 0;
+	buf->active_dma = DMA_Y;
+	if (buf->fmt->fourcc == V4L2_PIX_FMT_YUV422P)
+		buf->active_dma |= DMA_U | DMA_V;

 	return 0;

+fail_v:
+	dma_free_coherent(pcdev->dev, buf->dmas[1].sg_size,
+			  buf->dmas[1].sg_cpu, buf->dmas[1].sg_dma);
+fail_u:
+	dma_free_coherent(pcdev->dev, buf->dmas[0].sg_size,
+			  buf->dmas[0].sg_cpu, buf->dmas[0].sg_dma);
 fail:
 	free_buffer(vq, buf);
 out:
@@ -277,8 +366,6 @@ static void pxa_videobuf_queue(struct vi
 	struct pxa_camera_dev *pcdev = ici->priv;
 	struct pxa_buffer *buf = container_of(vb, struct pxa_buffer, vb);
 	struct pxa_buffer *active;
-	struct videobuf_dmabuf *dma = videobuf_to_dma(vb);
-	int nents = dma->sglen;
 	unsigned long flags;

 	dev_dbg(&icd->dev, "%s (vb=0x%p) 0x%08lx %d\n", __FUNCTION__,
@@ -292,59 +379,90 @@ static void pxa_videobuf_queue(struct vi

 	if (!active) {
 		CIFR |= CIFR_RESET_F;
-		DDADR(pcdev->dma_chan_y) = buf->sg_dma;
-		DCSR(pcdev->dma_chan_y) = DCSR_RUN;
+		DDADR(pcdev->dma_chans[0]) = buf->dmas[0].sg_dma;
+		DCSR(pcdev->dma_chans[0]) = DCSR_RUN;
+
+		if (buf->fmt->fourcc == V4L2_PIX_FMT_YUV422P) {
+			DDADR(pcdev->dma_chans[1]) = buf->dmas[1].sg_dma;
+			DCSR(pcdev->dma_chans[1]) = DCSR_RUN;
+
+			DDADR(pcdev->dma_chans[2]) = buf->dmas[2].sg_dma;
+			DCSR(pcdev->dma_chans[2]) = DCSR_RUN;
+		}
+
 		pcdev->active = buf;
 		CICR0 |= CICR0_ENB;
+		mod_timer(&pcdev->timeout, jiffies + BUFFER_TIMEOUT);
 	} else {
-		struct videobuf_dmabuf *active_dma =
-			videobuf_to_dma(&active->vb);
-		/* Stop DMA engine */
-		DCSR(pcdev->dma_chan_y) = 0;
-
-		/* Add the descriptors we just initialized to the currently
-		 * running chain
-		 */
-		active->sg_cpu[active_dma->sglen - 1].ddadr = buf->sg_dma;
-
-		/* Setup a dummy descriptor with the DMA engines current
-		 * state
-		 */
-		/* CIBR0 */
-		buf->sg_cpu[nents].dsadr = pcdev->res->start + 0x28;
-		buf->sg_cpu[nents].dtadr = DTADR(pcdev->dma_chan_y);
-		buf->sg_cpu[nents].dcmd = DCMD(pcdev->dma_chan_y);
-
-		if (DDADR(pcdev->dma_chan_y) == DDADR_STOP) {
-			/* The DMA engine is on the last descriptor, set the
-			 * next descriptors address to the descriptors
-			 * we just initialized
+		struct pxa_cam_dma *buf_dma;
+		struct pxa_cam_dma *act_dma;
+		int channels = 1;
+		int nents;
+		int i;
+
+		if (buf->fmt->fourcc == V4L2_PIX_FMT_YUV422P)
+			channels = 3;
+
+		for (i = 0; i < channels; i++) {
+			buf_dma = &buf->dmas[i];
+			act_dma = &active->dmas[0];
+			nents = buf_dma->sglen;
+
+			/* Stop DMA engine */
+			DCSR(pcdev->dma_chans[i]) = 0;
+
+			/* Add the descriptors we just initialized to
+			   the currently running chain */
+			act_dma->sg_cpu[act_dma->sglen - 1].ddadr =
+				buf_dma->sg_dma;
+
+			/* Setup a dummy descriptor with the DMA engines current
+			 * state
 			 */
-			buf->sg_cpu[nents].ddadr = buf->sg_dma;
-		} else {
-			buf->sg_cpu[nents].ddadr = DDADR(pcdev->dma_chan_y);
+			buf_dma->sg_cpu[nents].dsadr =
+				pcdev->res->start + 0x28 + i*8; /* CIBRx */
+			buf_dma->sg_cpu[nents].dtadr =
+				DTADR(pcdev->dma_chans[i]);
+			buf_dma->sg_cpu[nents].dcmd =
+				DCMD(pcdev->dma_chans[i]);
+
+			if (DDADR(pcdev->dma_chans[i]) == DDADR_STOP) {
+				/* The DMA engine is on the last
+				   descriptor, set the next descriptors
+				   address to the descriptors we just
+				   initialized */
+				buf_dma->sg_cpu[nents].ddadr = buf_dma->sg_dma;
+			} else {
+				buf_dma->sg_cpu[nents].ddadr =
+					DDADR(pcdev->dma_chans[i]);
+			}
+
+			/* The next descriptor is the dummy descriptor */
+			DDADR(pcdev->dma_chans[i]) = buf_dma->sg_dma + nents *
+				sizeof(struct pxa_dma_desc);
+
+			DCSR(pcdev->dma_chans[i]) = DCSR_RUN;
+#ifdef DEBUG
+			if (CISR & CISR_IFO_0) {
+				dev_warn(pcdev->dev, "FIFO overrun\n");
+				for (i = 0; i < channels; i++)
+					DDADR(pcdev->dma_chans[i]) =
+						pcdev->active->dmas[i].sg_dma;
+
+				CICR0 &= ~CICR0_ENB;
+				CIFR |= CIFR_RESET_F;
+				for (i = 0; i < channels; i++)
+					DCSR(pcdev->dma_chans[0]) = DCSR_RUN;
+				CICR0 |= CICR0_ENB;
+			} else {
+				for (i = 0; i < channels; i++)
+					DCSR(pcdev->dma_chans[0]) = DCSR_RUN;
+			}
+#endif
 		}
-
-		/* The next descriptor is the dummy descriptor */
-		DDADR(pcdev->dma_chan_y) = buf->sg_dma + nents *
-			sizeof(struct pxa_dma_desc);
-
-#ifdef DEBUG
-		if (CISR & CISR_IFO_0) {
-			dev_warn(pcdev->dev, "FIFO overrun\n");
-			DDADR(pcdev->dma_chan_y) = pcdev->active->sg_dma;
-
-			CICR0 &= ~CICR0_ENB;
-			CIFR |= CIFR_RESET_F;
-			DCSR(pcdev->dma_chan_y) = DCSR_RUN;
-			CICR0 |= CICR0_ENB;
-		} else
-#endif
-			DCSR(pcdev->dma_chan_y) = DCSR_RUN;
 	}

 	spin_unlock_irqrestore(&pcdev->lock, flags);
-
 }

 static void pxa_videobuf_release(struct videobuf_queue *vq,
@@ -376,41 +494,10 @@ static void pxa_videobuf_release(struct
 	free_buffer(vq, buf);
 }

-static void pxa_camera_dma_irq_y(int channel, void *data)
-{
-	struct pxa_camera_dev *pcdev = data;
-	struct pxa_buffer *buf;
-	unsigned long flags;
-	unsigned int status;
-	struct videobuf_buffer *vb;
-
-	spin_lock_irqsave(&pcdev->lock, flags);
-
-	status = DCSR(pcdev->dma_chan_y);
-	DCSR(pcdev->dma_chan_y) = status;
-
-	if (status & DCSR_BUSERR) {
-		dev_err(pcdev->dev, "DMA Bus Error IRQ!\n");
-		goto out;
-	}
-
-	if (!(status & DCSR_ENDINTR)) {
-		dev_err(pcdev->dev, "Unknown DMA IRQ source, "
-			"status: 0x%08x\n", status);
-		goto out;
-	}
-
-	if (!pcdev->active) {
-		dev_err(pcdev->dev, "DMA End IRQ with no active buffer!\n");
-		goto out;
-	}
-
-	vb = &pcdev->active->vb;
-	buf = container_of(vb, struct pxa_buffer, vb);
-	WARN_ON(buf->inwork || list_empty(&vb->queue));
-	dev_dbg(pcdev->dev, "%s (vb=0x%p) 0x%08lx %d\n", __FUNCTION__,
-		vb, vb->baddr, vb->bsize);
-
+static void pxa_camera_wakeup(struct pxa_camera_dev *pcdev,
+			      struct videobuf_buffer *vb,
+			      struct pxa_buffer *buf)
+{
 	/* _init is used to debug races, see comment in pxa_camera_reqbufs() */
 	list_del_init(&vb->queue);
 	vb->state = VIDEOBUF_DONE;
@@ -420,16 +507,76 @@ static void pxa_camera_dma_irq_y(int cha

 	if (list_empty(&pcdev->capture)) {
 		pcdev->active = NULL;
-		DCSR(pcdev->dma_chan_y) = 0;
+		DCSR(pcdev->dma_chans[0]) = 0;
+		DCSR(pcdev->dma_chans[1]) = 0;
+		DCSR(pcdev->dma_chans[2]) = 0;
 		CICR0 &= ~CICR0_ENB;
+		return;
+	}
+
+	pcdev->active = list_entry(pcdev->capture.next,
+				   struct pxa_buffer, vb.queue);
+}
+
+static void pxa_camera_dma_irq(int channel, struct pxa_camera_dev *pcdev,
+			       enum pxa_camera_active_dma act_dma)
+{
+	struct pxa_buffer *buf;
+	unsigned long flags;
+	unsigned int status;
+	struct videobuf_buffer *vb;
+
+	spin_lock_irqsave(&pcdev->lock, flags);
+
+	status = DCSR(channel);
+	DCSR(channel) |= DCSR_ENDINTR;
+
+	if (status & DCSR_BUSERR) {
+		dev_err(pcdev->dev, "DMA Bus Error IRQ!\n");
 		goto out;
 	}

-	pcdev->active = list_entry(pcdev->capture.next, struct pxa_buffer,
-				   vb.queue);
+	if (!(status & DCSR_ENDINTR)) {
+		dev_err(pcdev->dev, "Unknown DMA IRQ source, "
+			"status: 0x%08x\n", status);
+		goto out;
+	}
+
+	if (!pcdev->active) {
+		dev_err(pcdev->dev, "DMA End IRQ with no active buffer!\n");
+		goto out;
+	}
+
+	vb = &pcdev->active->vb;
+	buf = container_of(vb, struct pxa_buffer, vb);
+	WARN_ON(buf->inwork || list_empty(&vb->queue));
+	dev_dbg(pcdev->dev, "%s (vb=0x%p) 0x%08lx %d\n", __FUNCTION__,
+		vb, vb->baddr, vb->bsize);
+
+	buf->active_dma &= ~act_dma;
+	if (!buf->active_dma)
+		pxa_camera_wakeup(pcdev, vb, buf);

 out:
 	spin_unlock_irqrestore(&pcdev->lock, flags);
+}
+
+static void pxa_camera_dma_irq_y(int channel, void *data)
+{
+	struct pxa_camera_dev *pcdev = data;
+	pxa_camera_dma_irq(channel, pcdev, DMA_Y);
+}
+
+static void pxa_camera_dma_irq_u(int channel, void *data)
+{
+	struct pxa_camera_dev *pcdev = data;
+	pxa_camera_dma_irq(channel, pcdev, DMA_U);
+}
+
+static void pxa_camera_dma_irq_v(int channel, void *data)
+{
+	struct pxa_camera_dev *pcdev = data;
+	pxa_camera_dma_irq(channel, pcdev, DMA_V);
 }

 static struct videobuf_queue_ops pxa_videobuf_ops = {
@@ -525,8 +672,39 @@ static irqreturn_t pxa_camera_irq(int ir
 	dev_dbg(pcdev->dev, "Camera interrupt status 0x%x\n", status);

 	CISR = status;
-
 	return IRQ_HANDLED;
+}
+
+static void pxa_camera_timeout(unsigned long data)
+{
+	struct pxa_camera_dev *pcdev = (struct pxa_camera_dev *)data;
+	struct pxa_buffer *buf;
+	unsigned long flags;
+
+	spin_lock_irqsave(&pcdev->lock, flags);
+	if (pcdev->active) {
+		buf = pcdev->active;
+		list_del_init(&buf->vb.queue);
+		buf->vb.state = VIDEOBUF_ERROR;
+		wake_up(&buf->vb.done);
+		pcdev->active = NULL;
+	}
+
+	while (!list_empty(&pcdev->capture)) {
+		buf = list_entry(pcdev->capture.next,
+				 struct pxa_buffer, vb.queue);
+		list_del_init(&buf->vb.queue);
+		buf->vb.state = VIDEOBUF_ERROR;
+		wake_up(&buf->vb.done);
+		printk("[%p/%d] timeout\n", buf, buf->vb.i);
+	}
+
+	DCSR(pcdev->dma_chans[0]) = 0;
+	DCSR(pcdev->dma_chans[1]) = 0;
+	DCSR(pcdev->dma_chans[2]) = 0;
+	CICR0 &= ~CICR0_ENB;
+
+	spin_unlock_irqrestore(&pcdev->lock, flags);
 }

 /* The following two functions absolutely depend on the fact, that
@@ -572,7 +750,7 @@ static void pxa_camera_remove_device(str
 	/* disable capture, disable interrupts */
 	CICR0 = 0x3ff;
 	/* Stop DMA engine */
-	DCSR(pcdev->dma_chan_y) = 0;
+	DCSR(pcdev->dma_chans[0]) = 0;

 	icd->ops->release(icd);

@@ -625,7 +803,7 @@ static int pxa_camera_set_bus_param(stru
 		to_soc_camera_host(icd->dev.parent);
 	struct pxa_camera_dev *pcdev = ici->priv;
 	unsigned long dw, bpp, bus_flags, camera_flags, common_flags;
-	u32 cicr0, cicr4 = 0;
+	u32 cicr0, cicr1, cicr4 = 0;
 	int ret = test_platform_param(pcdev, icd->buswidth, &bus_flags);

 	if (ret < 0)
@@ -702,7 +880,25 @@ static int pxa_camera_set_bus_param(stru
 	cicr0 = CICR0;
 	if (cicr0 & CICR0_ENB)
 		CICR0 = cicr0 & ~CICR0_ENB;
-	CICR1 = CICR1_PPL_VAL(icd->width - 1) | bpp | dw;
+
+	cicr1 = CICR1_PPL_VAL(icd->width - 1) | bpp | dw;
+
+	switch (pixfmt) {
+	case V4L2_PIX_FMT_YUV422P:
+		cicr1 |= CICR1_YCBCR_F;
+	case V4L2_PIX_FMT_YUYV:
+		cicr1 |= CICR1_COLOR_SP_VAL(2);
+		break;
+	case V4L2_PIX_FMT_RGB555:
+		cicr1 |= CICR1_RGB_BPP_VAL(1) | CICR1_RGBT_CONV_VAL(2) |
+			CICR1_TBIT | CICR1_COLOR_SP_VAL(1);
+		break;
+	case V4L2_PIX_FMT_RGB565:
+		cicr1 |= CICR1_COLOR_SP_VAL(1) | CICR1_RGB_BPP_VAL(2);
+		break;
+	}
+
+	CICR1 = cicr1;
 	CICR2 = 0;
 	CICR3 = CICR3_LPF_VAL(icd->height - 1) |
 		CICR3_BFW_VAL(min((unsigned short)255, icd->y_skip_top));
@@ -871,6 +1067,10 @@ static int pxa_camera_probe(struct platf
 	INIT_LIST_HEAD(&pcdev->capture);
 	spin_lock_init(&pcdev->lock);

+	pcdev->timeout.function = pxa_camera_timeout;
+	pcdev->timeout.data = (unsigned long)pcdev;
+	init_timer(&pcdev->timeout);
+
 	/*
 	 * Request the regions.
 	 */
@@ -890,16 +1090,36 @@ static int pxa_camera_probe(struct platf
 	pcdev->dev = &pdev->dev;

 	/* request dma */
-	pcdev->dma_chan_y = pxa_request_dma("CI_Y", DMA_PRIO_HIGH,
-					    pxa_camera_dma_irq_y, pcdev);
-	if (pcdev->dma_chan_y < 0) {
+	pcdev->dma_chans[0] = pxa_request_dma("CI_Y", DMA_PRIO_HIGH,
+					      pxa_camera_dma_irq_y, pcdev);
+	if (pcdev->dma_chans[0] < 0) {
 		dev_err(pcdev->dev, "Can't request DMA for Y\n");
 		err = -ENOMEM;
 		goto exit_iounmap;
 	}
-	dev_dbg(pcdev->dev, "got DMA channel %d\n", pcdev->dma_chan_y);
-
-	DRCMR68 = pcdev->dma_chan_y  | DRCMR_MAPVLD;
+	dev_dbg(pcdev->dev, "got DMA channel %d\n", pcdev->dma_chans[0]);
+
+	pcdev->dma_chans[1] = pxa_request_dma("CI_U", DMA_PRIO_HIGH,
+					      pxa_camera_dma_irq_u, pcdev);
+	if (pcdev->dma_chans[1] < 0) {
+		dev_err(pcdev->dev, "Can't request DMA for U\n");
+		err = -ENOMEM;
+		goto exit_free_dma_y;
+	}
+	dev_dbg(pcdev->dev, "got DMA channel (U) %d\n", pcdev->dma_chans[1]);
+
+	pcdev->dma_chans[2] = pxa_request_dma("CI_V", DMA_PRIO_HIGH,
+					      pxa_camera_dma_irq_v, pcdev);
+	if (pcdev->dma_chans[0] < 0) {
+		dev_err(pcdev->dev, "Can't request DMA for V\n");
+		err = -ENOMEM;
+		goto exit_free_dma_u;
+	}
+	dev_dbg(pcdev->dev, "got DMA channel (V) %d\n", pcdev->dma_chans[2]);
+
+	DRCMR68 = pcdev->dma_chans[0] | DRCMR_MAPVLD;
+	DRCMR69 = pcdev->dma_chans[1] | DRCMR_MAPVLD;
+	DRCMR70 = pcdev->dma_chans[2] | DRCMR_MAPVLD;

 	/* request irq */
 	err = request_irq(pcdev->irq, pxa_camera_irq, 0, PXA_CAM_DRV_NAME,
@@ -921,7 +1141,11 @@ exit_free_irq:
 exit_free_irq:
 	free_irq(pcdev->irq, pcdev);
 exit_free_dma:
-	pxa_free_dma(pcdev->dma_chan_y);
+	pxa_free_dma(pcdev->dma_chans[2]);
+exit_free_dma_u:
+	pxa_free_dma(pcdev->dma_chans[1]);
+exit_free_dma_y:
+	pxa_free_dma(pcdev->dma_chans[0]);
 exit_iounmap:
 	iounmap(base);
 exit_release:
@@ -941,7 +1165,9 @@ static int __devexit pxa_camera_remove(s

 	clk_put(pcdev->clk);

-	pxa_free_dma(pcdev->dma_chan_y);
+	pxa_free_dma(pcdev->dma_chans[0]);
+	pxa_free_dma(pcdev->dma_chans[1]);
+	pxa_free_dma(pcdev->dma_chans[2]);
 	free_irq(pcdev->irq, pcdev);

 	soc_camera_host_unregister(&pxa_soc_camera_host);

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
