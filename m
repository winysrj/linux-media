Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr14.xs4all.nl ([194.109.24.34]:1830 "EHLO
	smtp-vbr14.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751413AbaDQKja (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 17 Apr 2014 06:39:30 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [REVIEWv2 PATCH 03/11] saa7134: drop abuse of low-level videobuf functions
Date: Thu, 17 Apr 2014 12:39:06 +0200
Message-Id: <1397731154-34337-4-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1397731154-34337-1-git-send-email-hverkuil@xs4all.nl>
References: <1397731154-34337-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

saa7134-alsa used low-level videobuf functions to allocate and sync
DMA buffers. Replace this with saa7134-specific code. These functions
will not be available when we convert to vb2.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/pci/saa7134/saa7134-alsa.c | 95 ++++++++++++++++++++++++++++----
 drivers/media/pci/saa7134/saa7134.h      |  5 +-
 2 files changed, 89 insertions(+), 11 deletions(-)

diff --git a/drivers/media/pci/saa7134/saa7134-alsa.c b/drivers/media/pci/saa7134/saa7134-alsa.c
index ff6f373..cf48987 100644
--- a/drivers/media/pci/saa7134/saa7134-alsa.c
+++ b/drivers/media/pci/saa7134/saa7134-alsa.c
@@ -274,6 +274,82 @@ static int snd_card_saa7134_capture_trigger(struct snd_pcm_substream * substream
 	return err;
 }
 
+static int saa7134_alsa_dma_init(struct saa7134_dev *dev, int nr_pages)
+{
+	struct saa7134_dmasound *dma = &dev->dmasound;
+	struct page *pg;
+	int i;
+
+	dma->vaddr = vmalloc_32(nr_pages << PAGE_SHIFT);
+	if (NULL == dma->vaddr) {
+		dprintk("vmalloc_32(%d pages) failed\n", nr_pages);
+		return -ENOMEM;
+	}
+
+	dprintk("vmalloc is at addr 0x%08lx, size=%d\n",
+				(unsigned long)dma->vaddr,
+				nr_pages << PAGE_SHIFT);
+
+	memset(dma->vaddr, 0, nr_pages << PAGE_SHIFT);
+	dma->nr_pages = nr_pages;
+
+	dma->sglist = vzalloc(dma->nr_pages * sizeof(*dma->sglist));
+	if (NULL == dma->sglist)
+		goto vzalloc_err;
+
+	sg_init_table(dma->sglist, dma->nr_pages);
+	for (i = 0; i < dma->nr_pages; i++) {
+		pg = vmalloc_to_page(dma->vaddr + i * PAGE_SIZE);
+		if (NULL == pg)
+			goto vmalloc_to_page_err;
+		sg_set_page(&dma->sglist[i], pg, PAGE_SIZE, 0);
+	}
+	return 0;
+
+vmalloc_to_page_err:
+	vfree(dma->sglist);
+	dma->sglist = NULL;
+vzalloc_err:
+	vfree(dma->vaddr);
+	dma->vaddr = NULL;
+	return -ENOMEM;
+}
+
+static int saa7134_alsa_dma_map(struct saa7134_dev *dev)
+{
+	struct saa7134_dmasound *dma = &dev->dmasound;
+
+	dma->sglen = dma_map_sg(&dev->pci->dev, dma->sglist,
+			dma->nr_pages, PCI_DMA_FROMDEVICE);
+
+	if (0 == dma->sglen) {
+		pr_warn("%s: saa7134_alsa_map_sg failed\n", __func__);
+		return -ENOMEM;
+	}
+	return 0;
+}
+
+static int saa7134_alsa_dma_unmap(struct saa7134_dev *dev)
+{
+	struct saa7134_dmasound *dma = &dev->dmasound;
+
+	if (!dma->sglen)
+		return 0;
+
+	dma_unmap_sg(&dev->pci->dev, dma->sglist, dma->sglen, PCI_DMA_FROMDEVICE);
+	dma->sglen = 0;
+	return 0;
+}
+
+static int saa7134_alsa_dma_free(struct saa7134_dmasound *dma)
+{
+	vfree(dma->sglist);
+	dma->sglist = NULL;
+	vfree(dma->vaddr);
+	dma->vaddr = NULL;
+	return 0;
+}
+
 /*
  * DMA buffer initialization
  *
@@ -291,9 +367,8 @@ static int dsp_buffer_init(struct saa7134_dev *dev)
 
 	BUG_ON(!dev->dmasound.bufsize);
 
-	videobuf_dma_init(&dev->dmasound.dma);
-	err = videobuf_dma_init_kernel(&dev->dmasound.dma, PCI_DMA_FROMDEVICE,
-				       (dev->dmasound.bufsize + PAGE_SIZE) >> PAGE_SHIFT);
+	err = saa7134_alsa_dma_init(dev,
+			       (dev->dmasound.bufsize + PAGE_SIZE) >> PAGE_SHIFT);
 	if (0 != err)
 		return err;
 	return 0;
@@ -310,7 +385,7 @@ static int dsp_buffer_free(struct saa7134_dev *dev)
 {
 	BUG_ON(!dev->dmasound.blksize);
 
-	videobuf_dma_free(&dev->dmasound.dma);
+	saa7134_alsa_dma_free(&dev->dmasound);
 
 	dev->dmasound.blocks  = 0;
 	dev->dmasound.blksize = 0;
@@ -632,7 +707,7 @@ static int snd_card_saa7134_hw_params(struct snd_pcm_substream * substream,
 	/* release the old buffer */
 	if (substream->runtime->dma_area) {
 		saa7134_pgtable_free(dev->pci, &dev->dmasound.pt);
-		videobuf_dma_unmap(&dev->pci->dev, &dev->dmasound.dma);
+		saa7134_alsa_dma_unmap(dev);
 		dsp_buffer_free(dev);
 		substream->runtime->dma_area = NULL;
 	}
@@ -648,14 +723,14 @@ static int snd_card_saa7134_hw_params(struct snd_pcm_substream * substream,
 		return err;
 	}
 
-	err = videobuf_dma_map(&dev->pci->dev, &dev->dmasound.dma);
+	err = saa7134_alsa_dma_map(dev);
 	if (err) {
 		dsp_buffer_free(dev);
 		return err;
 	}
 	err = saa7134_pgtable_alloc(dev->pci, &dev->dmasound.pt);
 	if (err) {
-		videobuf_dma_unmap(&dev->pci->dev, &dev->dmasound.dma);
+		saa7134_alsa_dma_unmap(dev);
 		dsp_buffer_free(dev);
 		return err;
 	}
@@ -663,7 +738,7 @@ static int snd_card_saa7134_hw_params(struct snd_pcm_substream * substream,
 				dev->dmasound.sglist, dev->dmasound.sglen, 0);
 	if (err) {
 		saa7134_pgtable_free(dev->pci, &dev->dmasound.pt);
-		videobuf_dma_unmap(&dev->pci->dev, &dev->dmasound.dma);
+		saa7134_alsa_dma_unmap(dev);
 		dsp_buffer_free(dev);
 		return err;
 	}
@@ -672,7 +747,7 @@ static int snd_card_saa7134_hw_params(struct snd_pcm_substream * substream,
 	   byte, but it doesn't work. So I allocate the DMA using the
 	   V4L functions, and force ALSA to use that as the DMA area */
 
-	substream->runtime->dma_area = dev->dmasound.dma.vaddr;
+	substream->runtime->dma_area = dev->dmasound.vaddr;
 	substream->runtime->dma_bytes = dev->dmasound.bufsize;
 	substream->runtime->dma_addr = 0;
 
@@ -699,7 +774,7 @@ static int snd_card_saa7134_hw_free(struct snd_pcm_substream * substream)
 
 	if (substream->runtime->dma_area) {
 		saa7134_pgtable_free(dev->pci, &dev->dmasound.pt);
-		videobuf_dma_unmap(&dev->pci->dev, &dev->dmasound.dma);
+		saa7134_alsa_dma_unmap(dev);
 		dsp_buffer_free(dev);
 		substream->runtime->dma_area = NULL;
 	}
diff --git a/drivers/media/pci/saa7134/saa7134.h b/drivers/media/pci/saa7134/saa7134.h
index 2474e84..419f5f8 100644
--- a/drivers/media/pci/saa7134/saa7134.h
+++ b/drivers/media/pci/saa7134/saa7134.h
@@ -504,7 +504,10 @@ struct saa7134_dmasound {
 	unsigned int               blksize;
 	unsigned int               bufsize;
 	struct saa7134_pgtable     pt;
-	struct videobuf_dmabuf     dma;
+	void			   *vaddr;
+	struct scatterlist	   *sglist;
+	int                        sglen;
+	int                        nr_pages;
 	unsigned int               dma_blk;
 	unsigned int               read_offset;
 	unsigned int               read_count;
-- 
1.9.2

