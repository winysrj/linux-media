Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr14.xs4all.nl ([194.109.24.34]:1390 "EHLO
	smtp-vbr14.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753308AbaHNJyZ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 14 Aug 2014 05:54:25 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: stoth@kernellabs.com, Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCHv2 13/20] cx23885: drop videobuf abuse in cx23885-alsa
Date: Thu, 14 Aug 2014 11:53:58 +0200
Message-Id: <1408010045-24016-14-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1408010045-24016-1-git-send-email-hverkuil@xs4all.nl>
References: <1408010045-24016-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

The alsa driver uses videobuf low-level functions that are not
available in vb2, so replace them by driver-specific functions.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/pci/cx23885/cx23885-alsa.c | 96 ++++++++++++++++++++++++++++----
 drivers/media/pci/cx23885/cx23885.h      |  7 ++-
 2 files changed, 88 insertions(+), 15 deletions(-)

diff --git a/drivers/media/pci/cx23885/cx23885-alsa.c b/drivers/media/pci/cx23885/cx23885-alsa.c
index 554798d..31dbf0c 100644
--- a/drivers/media/pci/cx23885/cx23885-alsa.c
+++ b/drivers/media/pci/cx23885/cx23885-alsa.c
@@ -84,6 +84,82 @@ MODULE_PARM_DESC(audio_debug, "enable debug messages [analog audio]");
 #define AUD_INT_MCHG_IRQ        (1 << 21)
 #define GP_COUNT_CONTROL_RESET	0x3
 
+static int cx23885_alsa_dma_init(struct cx23885_audio_dev *chip, int nr_pages)
+{
+	struct cx23885_audio_buffer *buf = chip->buf;
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
+static int cx23885_alsa_dma_map(struct cx23885_audio_dev *dev)
+{
+	struct cx23885_audio_buffer *buf = dev->buf;
+
+	buf->sglen = dma_map_sg(&dev->pci->dev, buf->sglist,
+			buf->nr_pages, PCI_DMA_FROMDEVICE);
+
+	if (0 == buf->sglen) {
+		pr_warn("%s: cx23885_alsa_map_sg failed\n", __func__);
+		return -ENOMEM;
+	}
+	return 0;
+}
+
+static int cx23885_alsa_dma_unmap(struct cx23885_audio_dev *dev)
+{
+	struct cx23885_audio_buffer *buf = dev->buf;
+
+	if (!buf->sglen)
+		return 0;
+
+	dma_unmap_sg(&dev->pci->dev, buf->sglist, buf->sglen, PCI_DMA_FROMDEVICE);
+	buf->sglen = 0;
+	return 0;
+}
+
+static int cx23885_alsa_dma_free(struct cx23885_audio_buffer *buf)
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
@@ -201,12 +277,12 @@ static int dsp_buffer_free(struct cx23885_audio_dev *chip)
 	BUG_ON(!chip->dma_size);
 
 	dprintk(2, "Freeing buffer\n");
-	videobuf_dma_unmap(&chip->pci->dev, chip->dma_risc);
-	videobuf_dma_free(chip->dma_risc);
+	cx23885_alsa_dma_unmap(chip);
+	cx23885_alsa_dma_free(chip->buf);
 	btcx_riscmem_free(chip->pci, &chip->buf->risc);
 	kfree(chip->buf);
 
-	chip->dma_risc = NULL;
+	chip->buf = NULL;
 	chip->dma_size = 0;
 
 	return 0;
@@ -289,6 +365,7 @@ static int snd_cx23885_close(struct snd_pcm_substream *substream)
 	return 0;
 }
 
+
 /*
  * hw_params callback
  */
@@ -296,8 +373,6 @@ static int snd_cx23885_hw_params(struct snd_pcm_substream *substream,
 			      struct snd_pcm_hw_params *hw_params)
 {
 	struct cx23885_audio_dev *chip = snd_pcm_substream_chip(substream);
-	struct videobuf_dmabuf *dma;
-
 	struct cx23885_audio_buffer *buf;
 	int ret;
 
@@ -319,18 +394,16 @@ static int snd_cx23885_hw_params(struct snd_pcm_substream *substream,
 
 	buf->bpl = chip->period_size;
 
-	dma = &buf->dma;
-	videobuf_dma_init(dma);
-	ret = videobuf_dma_init_kernel(dma, PCI_DMA_FROMDEVICE,
+	ret = cx23885_alsa_dma_init(chip,
 			(PAGE_ALIGN(chip->dma_size) >> PAGE_SHIFT));
 	if (ret < 0)
 		goto error;
 
-	ret = videobuf_dma_map(&chip->pci->dev, dma);
+	ret = cx23885_alsa_dma_map(chip);
 	if (ret < 0)
 		goto error;
 
-	ret = cx23885_risc_databuffer(chip->pci, &buf->risc, dma->sglist,
+	ret = cx23885_risc_databuffer(chip->pci, &buf->risc, buf->sglist,
 				   chip->period_size, chip->num_periods, 1);
 	if (ret < 0)
 		goto error;
@@ -341,9 +414,8 @@ static int snd_cx23885_hw_params(struct snd_pcm_substream *substream,
 	buf->risc.jmp[2] = cpu_to_le32(0); /* bits 63-32 */
 
 	chip->buf = buf;
-	chip->dma_risc = dma;
 
-	substream->runtime->dma_area = chip->dma_risc->vaddr;
+	substream->runtime->dma_area = chip->buf->vaddr;
 	substream->runtime->dma_bytes = chip->dma_size;
 	substream->runtime->dma_addr = 0;
 
diff --git a/drivers/media/pci/cx23885/cx23885.h b/drivers/media/pci/cx23885/cx23885.h
index 260d177..9cd2b1b 100644
--- a/drivers/media/pci/cx23885/cx23885.h
+++ b/drivers/media/pci/cx23885/cx23885.h
@@ -324,7 +324,10 @@ struct cx23885_kernel_ir {
 struct cx23885_audio_buffer {
 	unsigned int		bpl;
 	struct btcx_riscmem	risc;
-	struct videobuf_dmabuf	dma;
+	void			*vaddr;
+	struct scatterlist	*sglist;
+	int                     sglen;
+	int                     nr_pages;
 };
 
 struct cx23885_audio_dev {
@@ -342,8 +345,6 @@ struct cx23885_audio_dev {
 	unsigned int		period_size;
 	unsigned int		num_periods;
 
-	struct videobuf_dmabuf	*dma_risc;
-
 	struct cx23885_audio_buffer   *buf;
 
 	struct snd_pcm_substream *substream;
-- 
2.1.0.rc1

