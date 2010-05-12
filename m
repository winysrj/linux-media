Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.w1.samsung.com ([210.118.77.11]:12839 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754612Ab0ELIhA (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 12 May 2010 04:37:00 -0400
Received: from eu_spt1 (mailout1.w1.samsung.com [210.118.77.11])
 by mailout1.w1.samsung.com
 (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14 2004))
 with ESMTP id <0L2A00LW4T9KUG@mailout1.w1.samsung.com> for
 linux-media@vger.kernel.org; Wed, 12 May 2010 09:36:57 +0100 (BST)
Received: from linux.samsung.com ([106.116.38.10])
 by spt1.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0L2A007O5T9KSD@spt1.w1.samsung.com> for
 linux-media@vger.kernel.org; Wed, 12 May 2010 09:36:56 +0100 (BST)
Date: Wed, 12 May 2010 10:36:24 +0200
From: Pawel Osciak <p.osciak@samsung.com>
Subject: RE: [PATCH 7/7] v4l: videobuf: Rename vmalloc fields to vaddr
In-reply-to: <1273584994-14211-8-git-send-email-laurent.pinchart@ideasonboard.com>
To: 'Laurent Pinchart' <laurent.pinchart@ideasonboard.com>,
	linux-media@vger.kernel.org
Cc: hverkuil@xs4all.nl, kyungmin.park@samsung.com
Message-id: <000e01caf1ae$34f0f2d0$9ed2d870$%osciak@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=utf-8
Content-language: pl
Content-transfer-encoding: 7BIT
References: <1273584994-14211-1-git-send-email-laurent.pinchart@ideasonboard.com>
 <1273584994-14211-8-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

> Laurent Pinchart <laurent.pinchart@ideasonboard.com>
>
>The videobuf_dmabuf and videobuf_vmalloc_memory fields have a vmalloc
>field to store the kernel virtual address of vmalloc'ed buffers. Rename
>the field to vaddr.
>
>Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
>---
> drivers/media/video/cx88/cx88-alsa.c       |    2 +-
> drivers/media/video/saa7134/saa7134-alsa.c |    2 +-
> drivers/media/video/videobuf-dma-sg.c      |   18 ++++++++--------
> drivers/media/video/videobuf-vmalloc.c     |   30 ++++++++++++++------------
>--
> drivers/staging/cx25821/cx25821-alsa.c     |    2 +-
> include/media/videobuf-dma-sg.h            |    2 +-
> include/media/videobuf-vmalloc.h           |    2 +-
> 7 files changed, 29 insertions(+), 29 deletions(-)
>
>diff --git a/drivers/media/video/cx88/cx88-alsa.c
>b/drivers/media/video/cx88/cx88-alsa.c
>index ebeb9a6..771406f 100644
>--- a/drivers/media/video/cx88/cx88-alsa.c
>+++ b/drivers/media/video/cx88/cx88-alsa.c
>@@ -425,7 +425,7 @@ static int snd_cx88_hw_params(struct snd_pcm_substream *
>substream,
> 	chip->buf = buf;
> 	chip->dma_risc = dma;
>
>-	substream->runtime->dma_area = chip->dma_risc->vmalloc;
>+	substream->runtime->dma_area = chip->dma_risc->vaddr;
> 	substream->runtime->dma_bytes = chip->dma_size;
> 	substream->runtime->dma_addr = 0;
> 	return 0;
>diff --git a/drivers/media/video/saa7134/saa7134-alsa.c
>b/drivers/media/video/saa7134/saa7134-alsa.c
>index 5bca2ab..68b7e8d 100644
>--- a/drivers/media/video/saa7134/saa7134-alsa.c
>+++ b/drivers/media/video/saa7134/saa7134-alsa.c
>@@ -669,7 +669,7 @@ static int snd_card_saa7134_hw_params(struct
>snd_pcm_substream * substream,
> 	   byte, but it doesn't work. So I allocate the DMA using the
> 	   V4L functions, and force ALSA to use that as the DMA area */
>
>-	substream->runtime->dma_area = dev->dmasound.dma.vmalloc;
>+	substream->runtime->dma_area = dev->dmasound.dma.vaddr;
> 	substream->runtime->dma_bytes = dev->dmasound.bufsize;
> 	substream->runtime->dma_addr = 0;
>
>diff --git a/drivers/media/video/videobuf-dma-sg.c
>b/drivers/media/video/videobuf-dma-sg.c
>index 2d64040..06f9a9c 100644
>--- a/drivers/media/video/videobuf-dma-sg.c
>+++ b/drivers/media/video/videobuf-dma-sg.c
>@@ -211,17 +211,17 @@ int videobuf_dma_init_kernel(struct videobuf_dmabuf
>*dma, int direction,
> 	dprintk(1, "init kernel [%d pages]\n", nr_pages);
>
> 	dma->direction = direction;
>-	dma->vmalloc = vmalloc_32(nr_pages << PAGE_SHIFT);
>-	if (NULL == dma->vmalloc) {
>+	dma->vaddr = vmalloc_32(nr_pages << PAGE_SHIFT);
>+	if (NULL == dma->vaddr) {
> 		dprintk(1, "vmalloc_32(%d pages) failed\n", nr_pages);
> 		return -ENOMEM;
> 	}
>
> 	dprintk(1, "vmalloc is at addr 0x%08lx, size=%d\n",
>-				(unsigned long)dma->vmalloc,
>+				(unsigned long)dma->vaddr,
> 				nr_pages << PAGE_SHIFT);
>
>-	memset(dma->vmalloc, 0, nr_pages << PAGE_SHIFT);
>+	memset(dma->vaddr, 0, nr_pages << PAGE_SHIFT);
> 	dma->nr_pages = nr_pages;
>
> 	return 0;
>@@ -254,8 +254,8 @@ int videobuf_dma_map(struct device *dev, struct
>videobuf_dmabuf *dma)
> 		dma->sglist = videobuf_pages_to_sg(dma->pages, dma->nr_pages,
> 						   dma->offset);
> 	}
>-	if (dma->vmalloc) {
>-		dma->sglist = videobuf_vmalloc_to_sg(dma->vmalloc,
>+	if (dma->vaddr) {
>+		dma->sglist = videobuf_vmalloc_to_sg(dma->vaddr,
> 						     dma->nr_pages);
> 	}
> 	if (dma->bus_addr) {
>@@ -319,8 +319,8 @@ int videobuf_dma_free(struct videobuf_dmabuf *dma)
> 		dma->pages = NULL;
> 	}
>
>-	vfree(dma->vmalloc);
>-	dma->vmalloc = NULL;
>+	vfree(dma->vaddr);
>+	dma->vaddr = NULL;
>
> 	if (dma->bus_addr)
> 		dma->bus_addr = 0;
>@@ -444,7 +444,7 @@ static void *__videobuf_to_vaddr(struct videobuf_buffer
>*buf)
>
> 	MAGIC_CHECK(mem->magic, MAGIC_SG_MEM);
>
>-	return mem->dma.vmalloc;
>+	return mem->dma.vaddr;
> }
>
> static int __videobuf_iolock(struct videobuf_queue *q,
>diff --git a/drivers/media/video/videobuf-vmalloc.c
>b/drivers/media/video/videobuf-vmalloc.c
>index f0d7cb8..ea08b5d 100644
>--- a/drivers/media/video/videobuf-vmalloc.c
>+++ b/drivers/media/video/videobuf-vmalloc.c
>@@ -102,10 +102,10 @@ static void videobuf_vm_close(struct vm_area_struct
>*vma)
> 				   called with IRQ's disabled
> 				 */
> 				dprintk(1, "%s: buf[%d] freeing (%p)\n",
>-					__func__, i, mem->vmalloc);
>+					__func__, i, mem->vaddr);
>
>-				vfree(mem->vmalloc);
>-				mem->vmalloc = NULL;
>+				vfree(mem->vaddr);
>+				mem->vaddr = NULL;
> 			}
>
> 			q->bufs[i]->map   = NULL;
>@@ -170,7 +170,7 @@ static int __videobuf_iolock(struct videobuf_queue *q,
> 		dprintk(1, "%s memory method MMAP\n", __func__);
>
> 		/* All handling should be done by __videobuf_mmap_mapper() */
>-		if (!mem->vmalloc) {
>+		if (!mem->vaddr) {
> 			printk(KERN_ERR "memory is not alloced/mmapped.\n");
> 			return -EINVAL;
> 		}
>@@ -189,13 +189,13 @@ static int __videobuf_iolock(struct videobuf_queue *q,
> 		 * read() method.
> 		 */
>
>-		mem->vmalloc = vmalloc_user(pages);
>-		if (!mem->vmalloc) {
>+		mem->vaddr = vmalloc_user(pages);
>+		if (!mem->vaddr) {
> 			printk(KERN_ERR "vmalloc (%d pages) failed\n", pages);
> 			return -ENOMEM;
> 		}
> 		dprintk(1, "vmalloc is at addr %p (%d pages)\n",
>-			mem->vmalloc, pages);
>+			mem->vaddr, pages);
>
> #if 0
> 		int rc;
>@@ -254,18 +254,18 @@ static int __videobuf_mmap_mapper(struct videobuf_queue
>*q,
> 	MAGIC_CHECK(mem->magic, MAGIC_VMAL_MEM);
>
> 	pages = PAGE_ALIGN(vma->vm_end - vma->vm_start);
>-	mem->vmalloc = vmalloc_user(pages);
>-	if (!mem->vmalloc) {
>+	mem->vaddr = vmalloc_user(pages);
>+	if (!mem->vaddr) {
> 		printk(KERN_ERR "vmalloc (%d pages) failed\n", pages);
> 		goto error;
> 	}
>-	dprintk(1, "vmalloc is at addr %p (%d pages)\n", mem->vmalloc, pages);
>+	dprintk(1, "vmalloc is at addr %p (%d pages)\n", mem->vaddr, pages);
>
> 	/* Try to remap memory */
>-	retval = remap_vmalloc_range(vma, mem->vmalloc, 0);
>+	retval = remap_vmalloc_range(vma, mem->vaddr, 0);
> 	if (retval < 0) {
> 		printk(KERN_ERR "mmap: remap failed with error %d. ", retval);
>-		vfree(mem->vmalloc);
>+		vfree(mem->vaddr);
> 		goto error;
> 	}
>
>@@ -317,7 +317,7 @@ void *videobuf_to_vmalloc(struct videobuf_buffer *buf)
> 	BUG_ON(!mem);
> 	MAGIC_CHECK(mem->magic, MAGIC_VMAL_MEM);
>
>-	return mem->vmalloc;
>+	return mem->vaddr;
> }
> EXPORT_SYMBOL_GPL(videobuf_to_vmalloc);
>
>@@ -339,8 +339,8 @@ void videobuf_vmalloc_free(struct videobuf_buffer *buf)
>
> 	MAGIC_CHECK(mem->magic, MAGIC_VMAL_MEM);
>
>-	vfree(mem->vmalloc);
>-	mem->vmalloc = NULL;
>+	vfree(mem->addr);
>+	mem->vaddr = NULL;
>
> 	return;
> }
>diff --git a/drivers/staging/cx25821/cx25821-alsa.c
>b/drivers/staging/cx25821/cx25821-alsa.c
>index 14fd3cb..1a7ed9b 100644
>--- a/drivers/staging/cx25821/cx25821-alsa.c
>+++ b/drivers/staging/cx25821/cx25821-alsa.c
>@@ -491,7 +491,7 @@ static int snd_cx25821_hw_params(struct snd_pcm_substream
>*substream,
> 	chip->buf = buf;
> 	chip->dma_risc = dma;
>
>-	substream->runtime->dma_area = chip->dma_risc->vmalloc;
>+	substream->runtime->dma_area = chip->dma_risc->vaddr;
> 	substream->runtime->dma_bytes = chip->dma_size;
> 	substream->runtime->dma_addr = 0;
>
>diff --git a/include/media/videobuf-dma-sg.h b/include/media/videobuf-dma-
>sg.h
>index 913860e..97e07f4 100644
>--- a/include/media/videobuf-dma-sg.h
>+++ b/include/media/videobuf-dma-sg.h
>@@ -51,7 +51,7 @@ struct videobuf_dmabuf {
> 	struct page         **pages;
>
> 	/* for kernel buffers */
>-	void                *vmalloc;
>+	void                *vaddr;
>
> 	/* for overlay buffers (pci-pci dma) */
> 	dma_addr_t          bus_addr;
>diff --git a/include/media/videobuf-vmalloc.h b/include/media/videobuf-
>vmalloc.h
>index 851eb1a..e19403c 100644
>--- a/include/media/videobuf-vmalloc.h
>+++ b/include/media/videobuf-vmalloc.h
>@@ -22,7 +22,7 @@
> struct videobuf_vmalloc_memory {
> 	u32                 magic;
>
>-	void                *vmalloc;
>+	void                *vaddr;
>
> 	/* remap_vmalloc_range seems to need to run
> 	 * after mmap() on some cases */
>--
>1.6.4.4

I am not 100% sure about this, it is a bit different from the rename
of vmalloc to vaddr for functions made by Hans earlier. Those functions
were supposed to return kernel addresses to buffers and callers did not
need to know where did those pointers had come from, but keeping that
information here might be useful/prevent confusion...


Best regards
--
Pawel Osciak
Linux Platform Group
Samsung Poland R&D Center





