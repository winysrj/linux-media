Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr2.xs4all.nl ([194.109.24.22]:1098 "EHLO
	smtp-vbr2.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755980AbaITMmF (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 20 Sep 2014 08:42:05 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 03/16] cx88: drop videobuf abuse in cx88-alsa
Date: Sat, 20 Sep 2014 14:41:38 +0200
Message-Id: <1411216911-7950-4-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1411216911-7950-1-git-send-email-hverkuil@xs4all.nl>
References: <1411216911-7950-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

The alsa driver uses videobuf low-level functions that are not
available in vb2, so replace them by driver-specific functions.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/pci/cx88/cx88-alsa.c | 107 ++++++++++++++++++++++++++++++-------
 1 file changed, 89 insertions(+), 18 deletions(-)

diff --git a/drivers/media/pci/cx88/cx88-alsa.c b/drivers/media/pci/cx88/cx88-alsa.c
index a72579a..73021a2 100644
--- a/drivers/media/pci/cx88/cx88-alsa.c
+++ b/drivers/media/pci/cx88/cx88-alsa.c
@@ -62,7 +62,10 @@
 struct cx88_audio_buffer {
 	unsigned int               bpl;
 	struct btcx_riscmem        risc;
-	struct videobuf_dmabuf     dma;
+	void			*vaddr;
+	struct scatterlist	*sglist;
+	int                     sglen;
+	int                     nr_pages;
 };
 
 struct cx88_audio_dev {
@@ -84,8 +87,6 @@ struct cx88_audio_dev {
 	unsigned int               period_size;
 	unsigned int               num_periods;
 
-	struct videobuf_dmabuf     *dma_risc;
-
 	struct cx88_audio_buffer   *buf;
 
 	struct snd_pcm_substream   *substream;
@@ -290,19 +291,94 @@ static irqreturn_t cx8801_irq(int irq, void *dev_id)
 	return IRQ_RETVAL(handled);
 }
 
+static int cx88_alsa_dma_init(struct cx88_audio_dev *chip, int nr_pages)
+{
+	struct cx88_audio_buffer *buf = chip->buf;
+	struct page *pg;
+	int i;
+
+	buf->vaddr = vmalloc_32(nr_pages << PAGE_SHIFT);
+	if (NULL == buf->vaddr) {
+		dprintk(1, "vmalloc_32(%d pages) failed\n", nr_pages);
+		return -ENOMEM;
+	}
+
+	dprintk(1, "vmalloc is at addr 0x%08lx, size=%d\n",
+				(unsigned long)buf->vaddr,
+				nr_pages << PAGE_SHIFT);
+
+	memset(buf->vaddr, 0, nr_pages << PAGE_SHIFT);
+	buf->nr_pages = nr_pages;
+
+	buf->sglist = vzalloc(buf->nr_pages * sizeof(*buf->sglist));
+	if (NULL == buf->sglist)
+		goto vzalloc_err;
+
+	sg_init_table(buf->sglist, buf->nr_pages);
+	for (i = 0; i < buf->nr_pages; i++) {
+		pg = vmalloc_to_page(buf->vaddr + i * PAGE_SIZE);
+		if (NULL == pg)
+			goto vmalloc_to_page_err;
+		sg_set_page(&buf->sglist[i], pg, PAGE_SIZE, 0);
+	}
+	return 0;
+
+vmalloc_to_page_err:
+	vfree(buf->sglist);
+	buf->sglist = NULL;
+vzalloc_err:
+	vfree(buf->vaddr);
+	buf->vaddr = NULL;
+	return -ENOMEM;
+}
+
+static int cx88_alsa_dma_map(struct cx88_audio_dev *dev)
+{
+	struct cx88_audio_buffer *buf = dev->buf;
+
+	buf->sglen = dma_map_sg(&dev->pci->dev, buf->sglist,
+			buf->nr_pages, PCI_DMA_FROMDEVICE);
+
+	if (0 == buf->sglen) {
+		pr_warn("%s: cx88_alsa_map_sg failed\n", __func__);
+		return -ENOMEM;
+	}
+	return 0;
+}
+
+static int cx88_alsa_dma_unmap(struct cx88_audio_dev *dev)
+{
+	struct cx88_audio_buffer *buf = dev->buf;
+
+	if (!buf->sglen)
+		return 0;
+
+	dma_unmap_sg(&dev->pci->dev, buf->sglist, buf->sglen, PCI_DMA_FROMDEVICE);
+	buf->sglen = 0;
+	return 0;
+}
+
+static int cx88_alsa_dma_free(struct cx88_audio_buffer *buf)
+{
+	vfree(buf->sglist);
+	buf->sglist = NULL;
+	vfree(buf->vaddr);
+	buf->vaddr = NULL;
+	return 0;
+}
+
 
 static int dsp_buffer_free(snd_cx88_card_t *chip)
 {
 	BUG_ON(!chip->dma_size);
 
 	dprintk(2,"Freeing buffer\n");
-	videobuf_dma_unmap(&chip->pci->dev, chip->dma_risc);
-	videobuf_dma_free(chip->dma_risc);
-	btcx_riscmem_free(chip->pci,&chip->buf->risc);
+	cx88_alsa_dma_unmap(chip);
+	cx88_alsa_dma_free(chip->buf);
+	btcx_riscmem_free(chip->pci, &chip->buf->risc);
 	kfree(chip->buf);
 
-	chip->dma_risc = NULL;
-	chip->dma_size = 0;
+	chip->buf = NULL;
 
 	return 0;
 }
@@ -387,7 +463,6 @@ static int snd_cx88_hw_params(struct snd_pcm_substream * substream,
 			      struct snd_pcm_hw_params * hw_params)
 {
 	snd_cx88_card_t *chip = snd_pcm_substream_chip(substream);
-	struct videobuf_dmabuf *dma;
 
 	struct cx88_audio_buffer *buf;
 	int ret;
@@ -408,20 +483,19 @@ static int snd_cx88_hw_params(struct snd_pcm_substream * substream,
 	if (NULL == buf)
 		return -ENOMEM;
 
+	chip->buf = buf;
 	buf->bpl = chip->period_size;
 
-	dma = &buf->dma;
-	videobuf_dma_init(dma);
-	ret = videobuf_dma_init_kernel(dma, PCI_DMA_FROMDEVICE,
+	ret = cx88_alsa_dma_init(chip,
 			(PAGE_ALIGN(chip->dma_size) >> PAGE_SHIFT));
 	if (ret < 0)
 		goto error;
 
-	ret = videobuf_dma_map(&chip->pci->dev, dma);
+	ret = cx88_alsa_dma_map(chip);
 	if (ret < 0)
 		goto error;
 
-	ret = cx88_risc_databuffer(chip->pci, &buf->risc, dma->sglist,
+	ret = cx88_risc_databuffer(chip->pci, &buf->risc, buf->sglist,
 				   chip->period_size, chip->num_periods, 1);
 	if (ret < 0)
 		goto error;
@@ -430,10 +504,7 @@ static int snd_cx88_hw_params(struct snd_pcm_substream * substream,
 	buf->risc.jmp[0] = cpu_to_le32(RISC_JUMP|RISC_IRQ1|RISC_CNT_INC);
 	buf->risc.jmp[1] = cpu_to_le32(buf->risc.dma);
 
-	chip->buf = buf;
-	chip->dma_risc = dma;
-
-	substream->runtime->dma_area = chip->dma_risc->vaddr;
+	substream->runtime->dma_area = chip->buf->vaddr;
 	substream->runtime->dma_bytes = chip->dma_size;
 	substream->runtime->dma_addr = 0;
 	return 0;
-- 
2.1.0

