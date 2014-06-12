Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp1.bendigoit.com.au ([203.16.224.4]:45601 "EHLO
	smtp1.bendigoit.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932878AbaFLKEB (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 12 Jun 2014 06:04:01 -0400
From: James Harper <james.harper@ejbdigital.com.au>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [PATCH] vmalloc_sg: make sure all pages in vmalloc area are really DMA-ready
Date: Thu, 12 Jun 2014 20:03:57 +1000
Message-Id: <1402567437-5140-1-git-send-email-james.harper@ejbdigital.com.au>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Patch originally written by Konrad. Rebased on current linux media tree.

Under Xen, vmalloc_32() isn't guaranteed to return pages which are really
under 4G in machine physical addresses (only in virtual pseudo-physical
addresses).  To work around this, implement a vmalloc variant which
allocates each page with dma_alloc_coherent() to guarantee that each
page is suitable for the device in question.

Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Signed-off-by: James Harper <james.harper@ejbdigital.com.au>
---
 drivers/media/v4l2-core/videobuf-dma-sg.c | 62 +++++++++++++++++++++++++++++--
 include/media/videobuf-dma-sg.h           |  3 ++
 2 files changed, 61 insertions(+), 4 deletions(-)

diff --git a/drivers/media/v4l2-core/videobuf-dma-sg.c b/drivers/media/v4l2-core/videobuf-dma-sg.c
index 828e7c1..3c8cc02 100644
--- a/drivers/media/v4l2-core/videobuf-dma-sg.c
+++ b/drivers/media/v4l2-core/videobuf-dma-sg.c
@@ -211,13 +211,36 @@ EXPORT_SYMBOL_GPL(videobuf_dma_init_user);
 int videobuf_dma_init_kernel(struct videobuf_dmabuf *dma, int direction,
 			     int nr_pages)
 {
+	int i;
+
 	dprintk(1, "init kernel [%d pages]\n", nr_pages);
 
 	dma->direction = direction;
-	dma->vaddr = vmalloc_32(nr_pages << PAGE_SHIFT);
+	dma->vaddr_pages = kcalloc(nr_pages, sizeof(*dma->vaddr_pages),
+				   GFP_KERNEL);
+	if (!dma->vaddr_pages)
+		return -ENOMEM;
+
+	dma->dma_addr = kcalloc(nr_pages, sizeof(*dma->dma_addr), GFP_KERNEL);
+	if (!dma->dma_addr) {
+		kfree(dma->vaddr_pages);
+		return -ENOMEM;
+	}
+	for (i = 0; i < nr_pages; i++) {
+		void *addr;
+
+		addr = dma_alloc_coherent(dma->dev, PAGE_SIZE,
+					  &(dma->dma_addr[i]), GFP_KERNEL);
+		if (addr == NULL)
+			goto out_free_pages;
+
+		dma->vaddr_pages[i] = virt_to_page(addr);
+	}
+	dma->vaddr = vmap(dma->vaddr_pages, nr_pages, VM_MAP | VM_IOREMAP,
+			  PAGE_KERNEL);
 	if (NULL == dma->vaddr) {
 		dprintk(1, "vmalloc_32(%d pages) failed\n", nr_pages);
-		return -ENOMEM;
+		goto out_free_pages;
 	}
 
 	dprintk(1, "vmalloc is at addr 0x%08lx, size=%d\n",
@@ -228,6 +251,19 @@ int videobuf_dma_init_kernel(struct videobuf_dmabuf *dma, int direction,
 	dma->nr_pages = nr_pages;
 
 	return 0;
+out_free_pages:
+	while (i > 0) {
+		void *addr = page_address(dma->vaddr_pages[i]);
+		dma_free_coherent(dma->dev, PAGE_SIZE, addr, dma->dma_addr[i]);
+		i--;
+	}
+	kfree(dma->dma_addr);
+	dma->dma_addr = NULL;
+	kfree(dma->vaddr_pages);
+	dma->vaddr_pages = NULL;
+
+	return -ENOMEM;
+
 }
 EXPORT_SYMBOL_GPL(videobuf_dma_init_kernel);
 
@@ -322,8 +358,21 @@ int videobuf_dma_free(struct videobuf_dmabuf *dma)
 		dma->pages = NULL;
 	}
 
-	vfree(dma->vaddr);
-	dma->vaddr = NULL;
+	if (dma->dma_addr) {
+		for (i = 0; i < dma->nr_pages; i++) {
+			void *addr;
+
+			addr = page_address(dma->vaddr_pages[i]);
+			dma_free_coherent(dma->dev, PAGE_SIZE, addr,
+					  dma->dma_addr[i]);
+		}
+		kfree(dma->dma_addr);
+		dma->dma_addr = NULL;
+		kfree(dma->vaddr_pages);
+		dma->vaddr_pages = NULL;
+		vunmap(dma->vaddr);
+		dma->vaddr = NULL;
+	}
 
 	if (dma->bus_addr)
 		dma->bus_addr = 0;
@@ -461,6 +510,11 @@ static int __videobuf_iolock(struct videobuf_queue *q,
 
 	MAGIC_CHECK(mem->magic, MAGIC_SG_MEM);
 
+	if (!mem->dma.dev)
+		mem->dma.dev = q->dev;
+	else
+		WARN_ON(mem->dma.dev != q->dev);
+
 	switch (vb->memory) {
 	case V4L2_MEMORY_MMAP:
 	case V4L2_MEMORY_USERPTR:
diff --git a/include/media/videobuf-dma-sg.h b/include/media/videobuf-dma-sg.h
index d8fb601..fb6fd4d8 100644
--- a/include/media/videobuf-dma-sg.h
+++ b/include/media/videobuf-dma-sg.h
@@ -53,6 +53,9 @@ struct videobuf_dmabuf {
 
 	/* for kernel buffers */
 	void                *vaddr;
+	struct page         **vaddr_pages;
+	dma_addr_t          *dma_addr;
+	struct device       *dev;
 
 	/* for overlay buffers (pci-pci dma) */
 	dma_addr_t          bus_addr;
-- 
2.0.0

