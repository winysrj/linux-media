Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.irobotique.be ([92.243.18.41]:43079 "EHLO
	perceval.irobotique.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757204Ab0EKNfi (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 11 May 2010 09:35:38 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: p.osciak@samsung.com, hverkuil@xs4all.nl
Subject: [PATCH 3/7] v4l: videobuf: Remove the videobuf_sg_dma_map/unmap functions
Date: Tue, 11 May 2010 15:36:30 +0200
Message-Id: <1273584994-14211-4-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1273584994-14211-1-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1273584994-14211-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Instead of creating dirty wrappers around videobuf_dma_map/unmap that
create a dummy videobuf_queue structure, modify videobuf_dma_map/unmap
to take a device pointer argument and use it directly. The
videobuf_sg_dma_map/unmap then become unused and can be removed.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/media/common/saa7146_fops.c        |    2 +-
 drivers/media/video/bt8xx/bttv-risc.c      |    2 +-
 drivers/media/video/cx23885/cx23885-core.c |    2 +-
 drivers/media/video/cx88/cx88-alsa.c       |    4 +-
 drivers/media/video/cx88/cx88-core.c       |    2 +-
 drivers/media/video/omap24xxcam.c          |    2 +-
 drivers/media/video/pxa_camera.c           |    2 +-
 drivers/media/video/saa7134/saa7134-alsa.c |   10 ++++----
 drivers/media/video/saa7134/saa7134-core.c |    2 +-
 drivers/media/video/videobuf-dma-sg.c      |   32 ++++-----------------------
 drivers/staging/cx25821/cx25821-alsa.c     |    4 +-
 drivers/staging/cx25821/cx25821-core.c     |    2 +-
 include/media/videobuf-dma-sg.h            |   20 ++++++++++-------
 13 files changed, 34 insertions(+), 52 deletions(-)

diff --git a/drivers/media/common/saa7146_fops.c b/drivers/media/common/saa7146_fops.c
index fd8e1f4..3e5498b 100644
--- a/drivers/media/common/saa7146_fops.c
+++ b/drivers/media/common/saa7146_fops.c
@@ -57,7 +57,7 @@ void saa7146_dma_free(struct saa7146_dev *dev,struct videobuf_queue *q,
 	BUG_ON(in_interrupt());
 
 	videobuf_waiton(&buf->vb,0,0);
-	videobuf_dma_unmap(q, dma);
+	videobuf_dma_unmap(q->dev, dma);
 	videobuf_dma_free(dma);
 	buf->vb.state = VIDEOBUF_NEEDS_INIT;
 }
diff --git a/drivers/media/video/bt8xx/bttv-risc.c b/drivers/media/video/bt8xx/bttv-risc.c
index d16af28..47cdfaa 100644
--- a/drivers/media/video/bt8xx/bttv-risc.c
+++ b/drivers/media/video/bt8xx/bttv-risc.c
@@ -582,7 +582,7 @@ bttv_dma_free(struct videobuf_queue *q,struct bttv *btv, struct bttv_buffer *buf
 
 	BUG_ON(in_interrupt());
 	videobuf_waiton(&buf->vb,0,0);
-	videobuf_dma_unmap(q, dma);
+	videobuf_dma_unmap(q->dev, dma);
 	videobuf_dma_free(dma);
 	btcx_riscmem_free(btv->c.pci,&buf->bottom);
 	btcx_riscmem_free(btv->c.pci,&buf->top);
diff --git a/drivers/media/video/cx23885/cx23885-core.c b/drivers/media/video/cx23885/cx23885-core.c
index 0dde57e..161ae73 100644
--- a/drivers/media/video/cx23885/cx23885-core.c
+++ b/drivers/media/video/cx23885/cx23885-core.c
@@ -1142,7 +1142,7 @@ void cx23885_free_buffer(struct videobuf_queue *q, struct cx23885_buffer *buf)
 
 	BUG_ON(in_interrupt());
 	videobuf_waiton(&buf->vb, 0, 0);
-	videobuf_dma_unmap(q, dma);
+	videobuf_dma_unmap(q->dev, dma);
 	videobuf_dma_free(dma);
 	btcx_riscmem_free(to_pci_dev(q->dev), &buf->risc);
 	buf->vb.state = VIDEOBUF_NEEDS_INIT;
diff --git a/drivers/media/video/cx88/cx88-alsa.c b/drivers/media/video/cx88/cx88-alsa.c
index 64b350d..5ddd45d 100644
--- a/drivers/media/video/cx88/cx88-alsa.c
+++ b/drivers/media/video/cx88/cx88-alsa.c
@@ -282,7 +282,7 @@ static int dsp_buffer_free(snd_cx88_card_t *chip)
 	BUG_ON(!chip->dma_size);
 
 	dprintk(2,"Freeing buffer\n");
-	videobuf_sg_dma_unmap(&chip->pci->dev, chip->dma_risc);
+	videobuf_dma_unmap(&chip->pci->dev, chip->dma_risc);
 	videobuf_dma_free(chip->dma_risc);
 	btcx_riscmem_free(chip->pci,&chip->buf->risc);
 	kfree(chip->buf);
@@ -408,7 +408,7 @@ static int snd_cx88_hw_params(struct snd_pcm_substream * substream,
 	if (ret < 0)
 		goto error;
 
-	ret = videobuf_sg_dma_map(&chip->pci->dev, dma);
+	ret = videobuf_dma_map(&chip->pci->dev, dma);
 	if (ret < 0)
 		goto error;
 
diff --git a/drivers/media/video/cx88/cx88-core.c b/drivers/media/video/cx88/cx88-core.c
index 8b21457..85eb266 100644
--- a/drivers/media/video/cx88/cx88-core.c
+++ b/drivers/media/video/cx88/cx88-core.c
@@ -218,7 +218,7 @@ cx88_free_buffer(struct videobuf_queue *q, struct cx88_buffer *buf)
 
 	BUG_ON(in_interrupt());
 	videobuf_waiton(&buf->vb,0,0);
-	videobuf_dma_unmap(q, dma);
+	videobuf_dma_unmap(q->dev, dma);
 	videobuf_dma_free(dma);
 	btcx_riscmem_free(to_pci_dev(q->dev), &buf->risc);
 	buf->vb.state = VIDEOBUF_NEEDS_INIT;
diff --git a/drivers/media/video/omap24xxcam.c b/drivers/media/video/omap24xxcam.c
index 50df8ca..3c11580 100644
--- a/drivers/media/video/omap24xxcam.c
+++ b/drivers/media/video/omap24xxcam.c
@@ -425,7 +425,7 @@ static void omap24xxcam_vbq_release(struct videobuf_queue *vbq,
 			     dma->direction);
 		dma->direction = DMA_NONE;
 	} else {
-		videobuf_dma_unmap(vbq, videobuf_to_dma(vb));
+		videobuf_dma_unmap(vbq->dev, videobuf_to_dma(vb));
 		videobuf_dma_free(videobuf_to_dma(vb));
 	}
 
diff --git a/drivers/media/video/pxa_camera.c b/drivers/media/video/pxa_camera.c
index 520a35b..dc3c61c 100644
--- a/drivers/media/video/pxa_camera.c
+++ b/drivers/media/video/pxa_camera.c
@@ -275,7 +275,7 @@ static void free_buffer(struct videobuf_queue *vq, struct pxa_buffer *buf)
 	 * longer in STATE_QUEUED or STATE_ACTIVE
 	 */
 	videobuf_waiton(&buf->vb, 0, 0);
-	videobuf_dma_unmap(vq, dma);
+	videobuf_dma_unmap(vq->dev, dma);
 	videobuf_dma_free(dma);
 
 	for (i = 0; i < ARRAY_SIZE(buf->dmas); i++) {
diff --git a/drivers/media/video/saa7134/saa7134-alsa.c b/drivers/media/video/saa7134/saa7134-alsa.c
index d3bd82a..5bca2ab 100644
--- a/drivers/media/video/saa7134/saa7134-alsa.c
+++ b/drivers/media/video/saa7134/saa7134-alsa.c
@@ -630,7 +630,7 @@ static int snd_card_saa7134_hw_params(struct snd_pcm_substream * substream,
 	/* release the old buffer */
 	if (substream->runtime->dma_area) {
 		saa7134_pgtable_free(dev->pci, &dev->dmasound.pt);
-		videobuf_sg_dma_unmap(&dev->pci->dev, &dev->dmasound.dma);
+		videobuf_dma_unmap(&dev->pci->dev, &dev->dmasound.dma);
 		dsp_buffer_free(dev);
 		substream->runtime->dma_area = NULL;
 	}
@@ -646,12 +646,12 @@ static int snd_card_saa7134_hw_params(struct snd_pcm_substream * substream,
 		return err;
 	}
 
-	if (0 != (err = videobuf_sg_dma_map(&dev->pci->dev, &dev->dmasound.dma))) {
+	if (0 != (err = videobuf_dma_map(&dev->pci->dev, &dev->dmasound.dma))) {
 		dsp_buffer_free(dev);
 		return err;
 	}
 	if (0 != (err = saa7134_pgtable_alloc(dev->pci,&dev->dmasound.pt))) {
-		videobuf_sg_dma_unmap(&dev->pci->dev, &dev->dmasound.dma);
+		videobuf_dma_unmap(&dev->pci->dev, &dev->dmasound.dma);
 		dsp_buffer_free(dev);
 		return err;
 	}
@@ -660,7 +660,7 @@ static int snd_card_saa7134_hw_params(struct snd_pcm_substream * substream,
 						dev->dmasound.dma.sglen,
 						0))) {
 		saa7134_pgtable_free(dev->pci, &dev->dmasound.pt);
-		videobuf_sg_dma_unmap(&dev->pci->dev, &dev->dmasound.dma);
+		videobuf_dma_unmap(&dev->pci->dev, &dev->dmasound.dma);
 		dsp_buffer_free(dev);
 		return err;
 	}
@@ -696,7 +696,7 @@ static int snd_card_saa7134_hw_free(struct snd_pcm_substream * substream)
 
 	if (substream->runtime->dma_area) {
 		saa7134_pgtable_free(dev->pci, &dev->dmasound.pt);
-		videobuf_sg_dma_unmap(&dev->pci->dev, &dev->dmasound.dma);
+		videobuf_dma_unmap(&dev->pci->dev, &dev->dmasound.dma);
 		dsp_buffer_free(dev);
 		substream->runtime->dma_area = NULL;
 	}
diff --git a/drivers/media/video/saa7134/saa7134-core.c b/drivers/media/video/saa7134/saa7134-core.c
index 90f2318..40bc635 100644
--- a/drivers/media/video/saa7134/saa7134-core.c
+++ b/drivers/media/video/saa7134/saa7134-core.c
@@ -256,7 +256,7 @@ void saa7134_dma_free(struct videobuf_queue *q,struct saa7134_buf *buf)
 	BUG_ON(in_interrupt());
 
 	videobuf_waiton(&buf->vb,0,0);
-	videobuf_dma_unmap(q, dma);
+	videobuf_dma_unmap(q->dev, dma);
 	videobuf_dma_free(dma);
 	buf->vb.state = VIDEOBUF_NEEDS_INIT;
 }
diff --git a/drivers/media/video/videobuf-dma-sg.c b/drivers/media/video/videobuf-dma-sg.c
index a9b1091..17b1f89 100644
--- a/drivers/media/video/videobuf-dma-sg.c
+++ b/drivers/media/video/videobuf-dma-sg.c
@@ -235,7 +235,7 @@ int videobuf_dma_init_overlay(struct videobuf_dmabuf *dma, int direction,
 }
 EXPORT_SYMBOL_GPL(videobuf_dma_init_overlay);
 
-int videobuf_dma_map(struct videobuf_queue *q, struct videobuf_dmabuf *dma)
+int videobuf_dma_map(struct device *dev, struct videobuf_dmabuf *dma)
 {
 	MAGIC_CHECK(dma->magic, MAGIC_DMABUF);
 	BUG_ON(0 == dma->nr_pages);
@@ -263,7 +263,7 @@ int videobuf_dma_map(struct videobuf_queue *q, struct videobuf_dmabuf *dma)
 		return -ENOMEM;
 	}
 	if (!dma->bus_addr) {
-		dma->sglen = dma_map_sg(q->dev, dma->sglist,
+		dma->sglen = dma_map_sg(dev, dma->sglist,
 					dma->nr_pages, dma->direction);
 		if (0 == dma->sglen) {
 			printk(KERN_WARNING
@@ -279,14 +279,14 @@ int videobuf_dma_map(struct videobuf_queue *q, struct videobuf_dmabuf *dma)
 }
 EXPORT_SYMBOL_GPL(videobuf_dma_map);
 
-int videobuf_dma_unmap(struct videobuf_queue *q, struct videobuf_dmabuf *dma)
+int videobuf_dma_unmap(struct device *dev, struct videobuf_dmabuf *dma)
 {
 	MAGIC_CHECK(dma->magic, MAGIC_DMABUF);
 
 	if (!dma->sglen)
 		return 0;
 
-	dma_unmap_sg(q->dev, dma->sglist, dma->sglen, dma->direction);
+	dma_unmap_sg(dev, dma->sglist, dma->sglen, dma->direction);
 
 	vfree(dma->sglist);
 	dma->sglist = NULL;
@@ -322,28 +322,6 @@ EXPORT_SYMBOL_GPL(videobuf_dma_free);
 
 /* --------------------------------------------------------------------- */
 
-int videobuf_sg_dma_map(struct device *dev, struct videobuf_dmabuf *dma)
-{
-	struct videobuf_queue q;
-
-	q.dev = dev;
-
-	return videobuf_dma_map(&q, dma);
-}
-EXPORT_SYMBOL_GPL(videobuf_sg_dma_map);
-
-int videobuf_sg_dma_unmap(struct device *dev, struct videobuf_dmabuf *dma)
-{
-	struct videobuf_queue q;
-
-	q.dev = dev;
-
-	return videobuf_dma_unmap(&q, dma);
-}
-EXPORT_SYMBOL_GPL(videobuf_sg_dma_unmap);
-
-/* --------------------------------------------------------------------- */
-
 static void videobuf_vm_open(struct vm_area_struct *vma)
 {
 	struct videobuf_mapping *map = vma->vm_private_data;
@@ -520,7 +498,7 @@ static int __videobuf_iolock(struct videobuf_queue *q,
 	default:
 		BUG();
 	}
-	err = videobuf_dma_map(q, &mem->dma);
+	err = videobuf_dma_map(q->dev, &mem->dma);
 	if (0 != err)
 		return err;
 
diff --git a/drivers/staging/cx25821/cx25821-alsa.c b/drivers/staging/cx25821/cx25821-alsa.c
index f696521..f3407fd 100644
--- a/drivers/staging/cx25821/cx25821-alsa.c
+++ b/drivers/staging/cx25821/cx25821-alsa.c
@@ -330,7 +330,7 @@ static int dsp_buffer_free(struct cx25821_audio_dev *chip)
 	BUG_ON(!chip->dma_size);
 
 	dprintk(2, "Freeing buffer\n");
-	videobuf_sg_dma_unmap(&chip->pci->dev, chip->dma_risc);
+	videobuf_dma_unmap(&chip->pci->dev, chip->dma_risc);
 	videobuf_dma_free(chip->dma_risc);
 	btcx_riscmem_free(chip->pci, &chip->buf->risc);
 	kfree(chip->buf);
@@ -469,7 +469,7 @@ static int snd_cx25821_hw_params(struct snd_pcm_substream *substream,
 	if (ret < 0)
 		goto error;
 
-	ret = videobuf_sg_dma_map(&chip->pci->dev, dma);
+	ret = videobuf_dma_map(&chip->pci->dev, dma);
 	if (ret < 0)
 		goto error;
 
diff --git a/drivers/staging/cx25821/cx25821-core.c b/drivers/staging/cx25821/cx25821-core.c
index 6093ed3..b8d3f23 100644
--- a/drivers/staging/cx25821/cx25821-core.c
+++ b/drivers/staging/cx25821/cx25821-core.c
@@ -1348,7 +1348,7 @@ void cx25821_free_buffer(struct videobuf_queue *q, struct cx25821_buffer *buf)
 
 	BUG_ON(in_interrupt());
 	videobuf_waiton(&buf->vb, 0, 0);
-	videobuf_dma_unmap(q, dma);
+	videobuf_dma_unmap(q->dev, dma);
 	videobuf_dma_free(dma);
 	btcx_riscmem_free(to_pci_dev(q->dev), &buf->risc);
 	buf->vb.state = VIDEOBUF_NEEDS_INIT;
diff --git a/include/media/videobuf-dma-sg.h b/include/media/videobuf-dma-sg.h
index a195f3b..8013010 100644
--- a/include/media/videobuf-dma-sg.h
+++ b/include/media/videobuf-dma-sg.h
@@ -87,6 +87,16 @@ struct videobuf_dma_sg_memory {
 	struct videobuf_dmabuf  dma;
 };
 
+/*
+ * Scatter-gather DMA buffer API.
+ *
+ * These functions provide a simple way to create a page list and a
+ * scatter-gather list from a kernel, userspace of physical address and map the
+ * memory for DMA operation.
+ *
+ * Despite the name, this is totally unrelated to videobuf, except that
+ * videobuf-dma-sg uses the same API internally.
+ */
 void videobuf_dma_init(struct videobuf_dmabuf *dma);
 int videobuf_dma_init_user(struct videobuf_dmabuf *dma, int direction,
 			   unsigned long data, unsigned long size);
@@ -96,8 +106,8 @@ int videobuf_dma_init_overlay(struct videobuf_dmabuf *dma, int direction,
 			      dma_addr_t addr, int nr_pages);
 int videobuf_dma_free(struct videobuf_dmabuf *dma);
 
-int videobuf_dma_map(struct videobuf_queue *q, struct videobuf_dmabuf *dma);
-int videobuf_dma_unmap(struct videobuf_queue *q, struct videobuf_dmabuf *dma);
+int videobuf_dma_map(struct device *dev, struct videobuf_dmabuf *dma);
+int videobuf_dma_unmap(struct device *dev, struct videobuf_dmabuf *dma);
 struct videobuf_dmabuf *videobuf_to_dma(struct videobuf_buffer *buf);
 
 void *videobuf_sg_alloc(size_t size);
@@ -111,11 +121,5 @@ void videobuf_queue_sg_init(struct videobuf_queue *q,
 			 unsigned int msize,
 			 void *priv);
 
-/*FIXME: these variants are used only on *-alsa code, where videobuf is
- * used without queue
- */
-int videobuf_sg_dma_map(struct device *dev, struct videobuf_dmabuf *dma);
-int videobuf_sg_dma_unmap(struct device *dev, struct videobuf_dmabuf *dma);
-
 #endif /* _VIDEOBUF_DMA_SG_H */
 
-- 
1.6.4.4

