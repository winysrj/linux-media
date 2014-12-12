Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud2.xs4all.net ([194.109.24.21]:47214 "EHLO
	lb1-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S967722AbaLLN2r (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 12 Dec 2014 08:28:47 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 4/7] cx28521: drop videobuf abuse in cx25821-alsa
Date: Fri, 12 Dec 2014 14:27:57 +0100
Message-Id: <1418390880-39009-5-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1418390880-39009-1-git-send-email-hverkuil@xs4all.nl>
References: <1418390880-39009-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

The alsa driver uses videobuf low-level functions that are not
available in vb2, so replace them by driver-specific functions.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/pci/cx25821/cx25821-alsa.c | 107 ++++++++++++++++++++++++++-----
 1 file changed, 90 insertions(+), 17 deletions(-)

diff --git a/drivers/media/pci/cx25821/cx25821-alsa.c b/drivers/media/pci/cx25821/cx25821-alsa.c
index 27e6493..24f964b 100644
--- a/drivers/media/pci/cx25821/cx25821-alsa.c
+++ b/drivers/media/pci/cx25821/cx25821-alsa.c
@@ -64,7 +64,10 @@ static int devno;
 struct cx25821_audio_buffer {
 	unsigned int bpl;
 	struct cx25821_riscmem risc;
-	struct videobuf_dmabuf dma;
+	void			*vaddr;
+	struct scatterlist	*sglist;
+	int                     sglen;
+	int                     nr_pages;
 };
 
 struct cx25821_audio_dev {
@@ -87,8 +90,6 @@ struct cx25821_audio_dev {
 	unsigned int period_size;
 	unsigned int num_periods;
 
-	struct videobuf_dmabuf *dma_risc;
-
 	struct cx25821_audio_buffer *buf;
 
 	struct snd_pcm_substream *substream;
@@ -142,6 +143,83 @@ MODULE_PARM_DESC(debug, "enable debug messages");
 
 #define PCI_MSK_AUD_EXT   (1 <<  4)
 #define PCI_MSK_AUD_INT   (1 <<  3)
+
+static int cx25821_alsa_dma_init(struct cx25821_audio_dev *chip, int nr_pages)
+{
+	struct cx25821_audio_buffer *buf = chip->buf;
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
+static int cx25821_alsa_dma_map(struct cx25821_audio_dev *dev)
+{
+	struct cx25821_audio_buffer *buf = dev->buf;
+
+	buf->sglen = dma_map_sg(&dev->pci->dev, buf->sglist,
+			buf->nr_pages, PCI_DMA_FROMDEVICE);
+
+	if (0 == buf->sglen) {
+		pr_warn("%s: cx25821_alsa_map_sg failed\n", __func__);
+		return -ENOMEM;
+	}
+	return 0;
+}
+
+static int cx25821_alsa_dma_unmap(struct cx25821_audio_dev *dev)
+{
+	struct cx25821_audio_buffer *buf = dev->buf;
+
+	if (!buf->sglen)
+		return 0;
+
+	dma_unmap_sg(&dev->pci->dev, buf->sglist, buf->sglen, PCI_DMA_FROMDEVICE);
+	buf->sglen = 0;
+	return 0;
+}
+
+static int cx25821_alsa_dma_free(struct cx25821_audio_buffer *buf)
+{
+	vfree(buf->sglist);
+	buf->sglist = NULL;
+	vfree(buf->vaddr);
+	buf->vaddr = NULL;
+	return 0;
+}
+
 /*
  * BOARD Specific: Sets audio DMA
  */
@@ -335,12 +413,12 @@ static int dsp_buffer_free(struct cx25821_audio_dev *chip)
 	BUG_ON(!chip->dma_size);
 
 	dprintk(2, "Freeing buffer\n");
-	videobuf_dma_unmap(&chip->pci->dev, chip->dma_risc);
-	videobuf_dma_free(chip->dma_risc);
+	cx25821_alsa_dma_unmap(chip);
+	cx25821_alsa_dma_free(chip->buf);
 	pci_free_consistent(chip->pci, risc->size, risc->cpu, risc->dma);
 	kfree(chip->buf);
 
-	chip->dma_risc = NULL;
+	chip->buf = NULL;
 	chip->dma_size = 0;
 
 	return 0;
@@ -432,8 +510,6 @@ static int snd_cx25821_hw_params(struct snd_pcm_substream *substream,
 				 struct snd_pcm_hw_params *hw_params)
 {
 	struct cx25821_audio_dev *chip = snd_pcm_substream_chip(substream);
-	struct videobuf_dmabuf *dma;
-
 	struct cx25821_audio_buffer *buf;
 	int ret;
 
@@ -457,19 +533,18 @@ static int snd_cx25821_hw_params(struct snd_pcm_substream *substream,
 		chip->period_size = AUDIO_LINE_SIZE;
 
 	buf->bpl = chip->period_size;
+	chip->buf = buf;
 
-	dma = &buf->dma;
-	videobuf_dma_init(dma);
-	ret = videobuf_dma_init_kernel(dma, PCI_DMA_FROMDEVICE,
+	ret = cx25821_alsa_dma_init(chip,
 			(PAGE_ALIGN(chip->dma_size) >> PAGE_SHIFT));
 	if (ret < 0)
 		goto error;
 
-	ret = videobuf_dma_map(&chip->pci->dev, dma);
+	ret = cx25821_alsa_dma_map(chip);
 	if (ret < 0)
 		goto error;
 
-	ret = cx25821_risc_databuffer_audio(chip->pci, &buf->risc, dma->sglist,
+	ret = cx25821_risc_databuffer_audio(chip->pci, &buf->risc, buf->sglist,
 			chip->period_size, chip->num_periods, 1);
 	if (ret < 0) {
 		pr_info("DEBUG: ERROR after cx25821_risc_databuffer_audio()\n");
@@ -481,16 +556,14 @@ static int snd_cx25821_hw_params(struct snd_pcm_substream *substream,
 	buf->risc.jmp[1] = cpu_to_le32(buf->risc.dma);
 	buf->risc.jmp[2] = cpu_to_le32(0);	/* bits 63-32 */
 
-	chip->buf = buf;
-	chip->dma_risc = dma;
-
-	substream->runtime->dma_area = chip->dma_risc->vaddr;
+	substream->runtime->dma_area = chip->buf->vaddr;
 	substream->runtime->dma_bytes = chip->dma_size;
 	substream->runtime->dma_addr = 0;
 
 	return 0;
 
 error:
+	chip->buf = NULL;
 	kfree(buf);
 	return ret;
 }
-- 
2.1.3

