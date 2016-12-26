Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.web.de ([212.227.15.3]:65275 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751918AbcLZUtc (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 26 Dec 2016 15:49:32 -0500
Subject: [PATCH 4/8] [media] videobuf-dma-sg: Adjust 24 checks for null values
To: linux-media@vger.kernel.org,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Jan Kara <jack@suse.cz>,
        Javier Martinez Canillas <javier@osg.samsung.com>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Lorenzo Stoakes <lstoakes@gmail.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Michal Hocko <mhocko@suse.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>
References: <9268b60d-08ba-c64e-1848-f84679d64f80@users.sourceforge.net>
Cc: LKML <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org
From: SF Markus Elfring <elfring@users.sourceforge.net>
Message-ID: <7b963ec7-1ec7-5e44-e9ff-9385bc41aa48@users.sourceforge.net>
Date: Mon, 26 Dec 2016 21:48:19 +0100
MIME-Version: 1.0
In-Reply-To: <9268b60d-08ba-c64e-1848-f84679d64f80@users.sourceforge.net>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Mon, 26 Dec 2016 20:30:19 +0100

Convert comparisons with the preprocessor symbol "NULL" or the value "0"
to condition checks without it.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 drivers/media/v4l2-core/videobuf-dma-sg.c | 48 +++++++++++++++----------------
 1 file changed, 24 insertions(+), 24 deletions(-)

diff --git a/drivers/media/v4l2-core/videobuf-dma-sg.c b/drivers/media/v4l2-core/videobuf-dma-sg.c
index ab3c1f6a2ca1..9ccdc11aa016 100644
--- a/drivers/media/v4l2-core/videobuf-dma-sg.c
+++ b/drivers/media/v4l2-core/videobuf-dma-sg.c
@@ -70,12 +70,12 @@ static struct scatterlist *videobuf_vmalloc_to_sg(unsigned char *virt,
 	int i;
 
 	sglist = vzalloc(nr_pages * sizeof(*sglist));
-	if (NULL == sglist)
+	if (!sglist)
 		return NULL;
 	sg_init_table(sglist, nr_pages);
 	for (i = 0; i < nr_pages; i++, virt += PAGE_SIZE) {
 		pg = vmalloc_to_page(virt);
-		if (NULL == pg)
+		if (!pg)
 			goto err;
 		BUG_ON(PageHighMem(pg));
 		sg_set_page(&sglist[i], pg, PAGE_SIZE, 0);
@@ -98,10 +98,10 @@ static struct scatterlist *videobuf_pages_to_sg(struct page **pages,
 	struct scatterlist *sglist;
 	int i;
 
-	if (NULL == pages[0])
+	if (!pages[0])
 		return NULL;
 	sglist = vmalloc(nr_pages * sizeof(*sglist));
-	if (NULL == sglist)
+	if (!sglist)
 		return NULL;
 	sg_init_table(sglist, nr_pages);
 
@@ -112,7 +112,7 @@ static struct scatterlist *videobuf_pages_to_sg(struct page **pages,
 			min_t(size_t, PAGE_SIZE - offset, size), offset);
 	size -= min_t(size_t, PAGE_SIZE - offset, size);
 	for (i = 1; i < nr_pages; i++) {
-		if (NULL == pages[i])
+		if (!pages[i])
 			goto nopage;
 		if (PageHighMem(pages[i]))
 			goto highmem;
@@ -178,7 +178,7 @@ static int videobuf_dma_init_user_locked(struct videobuf_dmabuf *dma,
 	dma->pages = kmalloc_array(dma->nr_pages,
 				   sizeof(*dma->pages),
 				   GFP_KERNEL);
-	if (NULL == dma->pages)
+	if (!dma->pages)
 		return -ENOMEM;
 
 	if (rw == READ)
@@ -233,14 +233,14 @@ static int videobuf_dma_init_kernel(struct videobuf_dmabuf *dma, int direction,
 
 		addr = dma_alloc_coherent(dma->dev, PAGE_SIZE,
 					  &(dma->dma_addr[i]), GFP_KERNEL);
-		if (addr == NULL)
+		if (!addr)
 			goto out_free_pages;
 
 		dma->vaddr_pages[i] = virt_to_page(addr);
 	}
 	dma->vaddr = vmap(dma->vaddr_pages, nr_pages, VM_MAP | VM_IOREMAP,
 			  PAGE_KERNEL);
-	if (NULL == dma->vaddr) {
+	if (!dma->vaddr) {
 		dprintk(1, "vmalloc_32(%d pages) failed\n", nr_pages);
 		goto out_free_pages;
 	}
@@ -277,7 +277,7 @@ static int videobuf_dma_init_overlay(struct videobuf_dmabuf *dma, int direction,
 		nr_pages, (unsigned long)addr);
 	dma->direction = direction;
 
-	if (0 == addr)
+	if (!addr)
 		return -EINVAL;
 
 	dma->bus_addr = addr;
@@ -289,7 +289,7 @@ static int videobuf_dma_init_overlay(struct videobuf_dmabuf *dma, int direction,
 static int videobuf_dma_map(struct device *dev, struct videobuf_dmabuf *dma)
 {
 	MAGIC_CHECK(dma->magic, MAGIC_DMABUF);
-	BUG_ON(0 == dma->nr_pages);
+	BUG_ON(!dma->nr_pages);
 
 	if (dma->pages) {
 		dma->sglist = videobuf_pages_to_sg(dma->pages, dma->nr_pages,
@@ -301,7 +301,7 @@ static int videobuf_dma_map(struct device *dev, struct videobuf_dmabuf *dma)
 	}
 	if (dma->bus_addr) {
 		dma->sglist = vmalloc(sizeof(*dma->sglist));
-		if (NULL != dma->sglist) {
+		if (dma->sglist) {
 			dma->sglen = 1;
 			sg_dma_address(&dma->sglist[0])	= dma->bus_addr
 							& PAGE_MASK;
@@ -309,14 +309,14 @@ static int videobuf_dma_map(struct device *dev, struct videobuf_dmabuf *dma)
 			sg_dma_len(&dma->sglist[0]) = dma->nr_pages * PAGE_SIZE;
 		}
 	}
-	if (NULL == dma->sglist) {
+	if (!dma->sglist) {
 		dprintk(1, "scatterlist is NULL\n");
 		return -ENOMEM;
 	}
 	if (!dma->bus_addr) {
 		dma->sglen = dma_map_sg(dev, dma->sglist,
 					dma->nr_pages, dma->direction);
-		if (0 == dma->sglen) {
+		if (!dma->sglen) {
 			printk(KERN_WARNING
 			       "%s: videobuf_map_sg failed\n", __func__);
 			vfree(dma->sglist);
@@ -406,11 +406,11 @@ static void videobuf_vm_close(struct vm_area_struct *vma)
 		map->count, vma->vm_start, vma->vm_end);
 
 	map->count--;
-	if (0 == map->count) {
+	if (!map->count) {
 		dprintk(1, "munmap %p q=%p\n", map, q);
 		videobuf_queue_lock(q);
 		for (i = 0; i < VIDEO_MAX_FRAME; i++) {
-			if (NULL == q->bufs[i])
+			if (!q->bufs[i])
 				continue;
 			mem = q->bufs[i]->priv;
 			if (!mem)
@@ -518,20 +518,20 @@ static int __videobuf_iolock(struct videobuf_queue *q,
 	switch (vb->memory) {
 	case V4L2_MEMORY_MMAP:
 	case V4L2_MEMORY_USERPTR:
-		if (0 == vb->baddr) {
+		if (!vb->baddr) {
 			/* no userspace addr -- kernel bounce buffer */
 			pages = PAGE_ALIGN(vb->size) >> PAGE_SHIFT;
 			err = videobuf_dma_init_kernel(&mem->dma,
 						       DMA_FROM_DEVICE,
 						       pages);
-			if (0 != err)
+			if (err)
 				return err;
 		} else if (vb->memory == V4L2_MEMORY_USERPTR) {
 			/* dma directly to userspace */
 			err = videobuf_dma_init_user(&mem->dma,
 						     DMA_FROM_DEVICE,
 						     vb->baddr, vb->bsize);
-			if (0 != err)
+			if (err)
 				return err;
 		} else {
 			/* NOTE: HACK: videobuf_iolock on V4L2_MEMORY_MMAP
@@ -542,12 +542,12 @@ static int __videobuf_iolock(struct videobuf_queue *q,
 			err = videobuf_dma_init_user_locked(&mem->dma,
 						      DMA_FROM_DEVICE,
 						      vb->baddr, vb->bsize);
-			if (0 != err)
+			if (err)
 				return err;
 		}
 		break;
 	case V4L2_MEMORY_OVERLAY:
-		if (NULL == fbuf)
+		if (!fbuf)
 			return -EINVAL;
 		/* FIXME: need sanity checks for vb->boff */
 		/*
@@ -559,14 +559,14 @@ static int __videobuf_iolock(struct videobuf_queue *q,
 		pages = PAGE_ALIGN(vb->size) >> PAGE_SHIFT;
 		err = videobuf_dma_init_overlay(&mem->dma, DMA_FROM_DEVICE,
 						bus, pages);
-		if (0 != err)
+		if (err)
 			return err;
 		break;
 	default:
 		BUG();
 	}
 	err = videobuf_dma_map(q->dev, &mem->dma);
-	if (0 != err)
+	if (err)
 		return err;
 
 	return 0;
@@ -621,12 +621,12 @@ static int __videobuf_mmap_mapper(struct videobuf_queue *q,
 	/* create mapping + update buffer list */
 	retval = -ENOMEM;
 	map = kmalloc(sizeof(struct videobuf_mapping), GFP_KERNEL);
-	if (NULL == map)
+	if (!map)
 		goto done;
 
 	size = 0;
 	for (i = first; i <= last; i++) {
-		if (NULL == q->bufs[i])
+		if (!q->bufs[i])
 			continue;
 		q->bufs[i]->map   = map;
 		q->bufs[i]->baddr = vma->vm_start + size;
-- 
2.11.0

