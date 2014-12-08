Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud2.xs4all.net ([194.109.24.25]:53108 "EHLO
	lb2-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753901AbaLHI2Y (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 8 Dec 2014 03:28:24 -0500
Message-ID: <5485611D.2000005@xs4all.nl>
Date: Mon, 08 Dec 2014 09:28:13 +0100
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Linux Media Mailing List <linux-media@vger.kernel.org>
CC: Chris Lee <updatelee@gmail.com>
Subject: [PATCH for 3.19] cx88: add missing alloc_ctx support
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The cx88 vb2 conversion and the vb2 dma_sg improvements were developed separately and
were merged separately. Unfortunately, the patch updating drivers to the dma_sg
improvements didn't take the updated cx88 driver into account. Basically two ships
passing in the night, unaware of one another even though both ships have the same
owner, i.e. me :-)

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
Reported-by: Chris Lee <updatelee@gmail.com>

--
diff --git a/drivers/media/pci/cx88/cx88-blackbird.c b/drivers/media/pci/cx88/cx88-blackbird.c
index 4160ca4..d3c79d9 100644
--- a/drivers/media/pci/cx88/cx88-blackbird.c
+++ b/drivers/media/pci/cx88/cx88-blackbird.c
@@ -647,6 +647,7 @@ static int queue_setup(struct vb2_queue *q, const struct v4l2_format *fmt,
 	dev->ts_packet_size  = 188 * 4;
 	dev->ts_packet_count  = 32;
 	sizes[0] = dev->ts_packet_size * dev->ts_packet_count;
+	alloc_ctxs[0] = dev->alloc_ctx;
 	return 0;
 }
 
@@ -662,14 +663,11 @@ static void buffer_finish(struct vb2_buffer *vb)
 {
 	struct cx8802_dev *dev = vb->vb2_queue->drv_priv;
 	struct cx88_buffer *buf = container_of(vb, struct cx88_buffer, vb);
-	struct sg_table *sgt = vb2_dma_sg_plane_desc(vb, 0);
 	struct cx88_riscmem *risc = &buf->risc;
 
 	if (risc->cpu)
 		pci_free_consistent(dev->pci, risc->size, risc->cpu, risc->dma);
 	memset(risc, 0, sizeof(*risc));
-
-	dma_unmap_sg(&dev->pci->dev, sgt->sgl, sgt->nents, DMA_FROM_DEVICE);
 }
 
 static void buffer_queue(struct vb2_buffer *vb)
diff --git a/drivers/media/pci/cx88/cx88-dvb.c b/drivers/media/pci/cx88/cx88-dvb.c
index c344bfd..5780e2f 100644
--- a/drivers/media/pci/cx88/cx88-dvb.c
+++ b/drivers/media/pci/cx88/cx88-dvb.c
@@ -92,6 +92,7 @@ static int queue_setup(struct vb2_queue *q, const struct v4l2_format *fmt,
 	dev->ts_packet_size  = 188 * 4;
 	dev->ts_packet_count = dvb_buf_tscnt;
 	sizes[0] = dev->ts_packet_size * dev->ts_packet_count;
+	alloc_ctxs[0] = dev->alloc_ctx;
 	*num_buffers = dvb_buf_tscnt;
 	return 0;
 }
@@ -108,14 +109,11 @@ static void buffer_finish(struct vb2_buffer *vb)
 {
 	struct cx8802_dev *dev = vb->vb2_queue->drv_priv;
 	struct cx88_buffer *buf = container_of(vb, struct cx88_buffer, vb);
-	struct sg_table *sgt = vb2_dma_sg_plane_desc(vb, 0);
 	struct cx88_riscmem *risc = &buf->risc;
 
 	if (risc->cpu)
 		pci_free_consistent(dev->pci, risc->size, risc->cpu, risc->dma);
 	memset(risc, 0, sizeof(*risc));
-
-	dma_unmap_sg(&dev->pci->dev, sgt->sgl, sgt->nents, DMA_FROM_DEVICE);
 }
 
 static void buffer_queue(struct vb2_buffer *vb)
diff --git a/drivers/media/pci/cx88/cx88-mpeg.c b/drivers/media/pci/cx88/cx88-mpeg.c
index f181a3a..1c1f69e 100644
--- a/drivers/media/pci/cx88/cx88-mpeg.c
+++ b/drivers/media/pci/cx88/cx88-mpeg.c
@@ -235,10 +235,6 @@ int cx8802_buf_prepare(struct vb2_queue *q, struct cx8802_dev *dev,
 		return -EINVAL;
 	vb2_set_plane_payload(&buf->vb, 0, size);
 
-	rc = dma_map_sg(&dev->pci->dev, sgt->sgl, sgt->nents, DMA_FROM_DEVICE);
-	if (!rc)
-		return -EIO;
-
 	rc = cx88_risc_databuffer(dev->pci, risc, sgt->sgl,
 			     dev->ts_packet_size, dev->ts_packet_count, 0);
 	if (rc) {
@@ -733,6 +729,11 @@ static int cx8802_probe(struct pci_dev *pci_dev,
 	if (NULL == dev)
 		goto fail_core;
 	dev->pci = pci_dev;
+	dev->alloc_ctx = vb2_dma_sg_init_ctx(&pci_dev->dev);
+	if (IS_ERR(dev->alloc_ctx)) {
+		err = PTR_ERR(dev->alloc_ctx);
+		goto fail_core;
+	}
 	dev->core = core;
 
 	/* Maintain a reference so cx88-video can query the 8802 device. */
@@ -752,6 +753,7 @@ static int cx8802_probe(struct pci_dev *pci_dev,
 	return 0;
 
  fail_free:
+	vb2_dma_sg_cleanup_ctx(dev->alloc_ctx);
 	kfree(dev);
  fail_core:
 	core->dvbdev = NULL;
@@ -798,6 +800,7 @@ static void cx8802_remove(struct pci_dev *pci_dev)
 	/* common */
 	cx8802_fini_common(dev);
 	cx88_core_put(dev->core,dev->pci);
+	vb2_dma_sg_cleanup_ctx(dev->alloc_ctx);
 	kfree(dev);
 }
 
diff --git a/drivers/media/pci/cx88/cx88-vbi.c b/drivers/media/pci/cx88/cx88-vbi.c
index 6ab6e27..32eb7fd 100644
--- a/drivers/media/pci/cx88/cx88-vbi.c
+++ b/drivers/media/pci/cx88/cx88-vbi.c
@@ -120,6 +120,7 @@ static int queue_setup(struct vb2_queue *q, const struct v4l2_format *fmt,
 		sizes[0] = VBI_LINE_NTSC_COUNT * VBI_LINE_LENGTH * 2;
 	else
 		sizes[0] = VBI_LINE_PAL_COUNT * VBI_LINE_LENGTH * 2;
+	alloc_ctxs[0] = dev->alloc_ctx;
 	return 0;
 }
 
@@ -131,7 +132,6 @@ static int buffer_prepare(struct vb2_buffer *vb)
 	struct sg_table *sgt = vb2_dma_sg_plane_desc(vb, 0);
 	unsigned int lines;
 	unsigned int size;
-	int rc;
 
 	if (dev->core->tvnorm & V4L2_STD_525_60)
 		lines = VBI_LINE_NTSC_COUNT;
@@ -142,10 +142,6 @@ static int buffer_prepare(struct vb2_buffer *vb)
 		return -EINVAL;
 	vb2_set_plane_payload(vb, 0, size);
 
-	rc = dma_map_sg(&dev->pci->dev, sgt->sgl, sgt->nents, DMA_FROM_DEVICE);
-	if (!rc)
-		return -EIO;
-
 	cx88_risc_buffer(dev->pci, &buf->risc, sgt->sgl,
 			 0, VBI_LINE_LENGTH * lines,
 			 VBI_LINE_LENGTH, 0,
@@ -157,14 +153,11 @@ static void buffer_finish(struct vb2_buffer *vb)
 {
 	struct cx8800_dev *dev = vb->vb2_queue->drv_priv;
 	struct cx88_buffer *buf = container_of(vb, struct cx88_buffer, vb);
-	struct sg_table *sgt = vb2_dma_sg_plane_desc(vb, 0);
 	struct cx88_riscmem *risc = &buf->risc;
 
 	if (risc->cpu)
 		pci_free_consistent(dev->pci, risc->size, risc->cpu, risc->dma);
 	memset(risc, 0, sizeof(*risc));
-
-	dma_unmap_sg(&dev->pci->dev, sgt->sgl, sgt->nents, DMA_FROM_DEVICE);
 }
 
 static void buffer_queue(struct vb2_buffer *vb)
diff --git a/drivers/media/pci/cx88/cx88-video.c b/drivers/media/pci/cx88/cx88-video.c
index a64ae31..f616e0d 100644
--- a/drivers/media/pci/cx88/cx88-video.c
+++ b/drivers/media/pci/cx88/cx88-video.c
@@ -440,6 +440,7 @@ static int queue_setup(struct vb2_queue *q, const struct v4l2_format *fmt,
 
 	*num_planes = 1;
 	sizes[0] = (dev->fmt->depth * core->width * core->height) >> 3;
+	alloc_ctxs[0] = dev->alloc_ctx;
 	return 0;
 }
 
@@ -1345,6 +1346,12 @@ static int cx8800_initdev(struct pci_dev *pci_dev,
 		err = -EIO;
 		goto fail_core;
 	}
+	dev->alloc_ctx = vb2_dma_sg_init_ctx(&pci_dev->dev);
+	if (IS_ERR(dev->alloc_ctx)) {
+		err = PTR_ERR(dev->alloc_ctx);
+		goto fail_core;
+	}
+
 
 	/* initialize driver struct */
 	spin_lock_init(&dev->slock);
@@ -1549,6 +1556,7 @@ fail_unreg:
 	free_irq(pci_dev->irq, dev);
 	mutex_unlock(&core->lock);
 fail_core:
+	vb2_dma_sg_cleanup_ctx(dev->alloc_ctx);
 	core->v4ldev = NULL;
 	cx88_core_put(core,dev->pci);
 fail_free:
@@ -1582,6 +1590,7 @@ static void cx8800_finidev(struct pci_dev *pci_dev)
 
 	/* free memory */
 	cx88_core_put(core,dev->pci);
+	vb2_dma_sg_cleanup_ctx(dev->alloc_ctx);
 	kfree(dev);
 }
 
diff --git a/drivers/media/pci/cx88/cx88.h b/drivers/media/pci/cx88/cx88.h
index 3b0ae75..7748ca9 100644
--- a/drivers/media/pci/cx88/cx88.h
+++ b/drivers/media/pci/cx88/cx88.h
@@ -485,6 +485,7 @@ struct cx8800_dev {
 	/* pci i/o */
 	struct pci_dev             *pci;
 	unsigned char              pci_rev,pci_lat;
+	void			   *alloc_ctx;
 
 	const struct cx8800_fmt    *fmt;
 
@@ -548,6 +549,7 @@ struct cx8802_dev {
 	/* pci i/o */
 	struct pci_dev             *pci;
 	unsigned char              pci_rev,pci_lat;
+	void			   *alloc_ctx;
 
 	/* dma queues */
 	struct cx88_dmaqueue       mpegq;
