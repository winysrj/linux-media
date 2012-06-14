Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.w1.samsung.com ([210.118.77.11]:21916 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755876Ab2FNOcn (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 14 Jun 2012 10:32:43 -0400
Received: from euspt1 (mailout1.w1.samsung.com [210.118.77.11])
 by mailout1.w1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0M5M001TQ3398Z70@mailout1.w1.samsung.com> for
 linux-media@vger.kernel.org; Thu, 14 Jun 2012 15:33:09 +0100 (BST)
Received: from linux.samsung.com ([106.116.38.10])
 by spt1.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0M5M00I7V32DBI@spt1.w1.samsung.com> for
 linux-media@vger.kernel.org; Thu, 14 Jun 2012 15:32:38 +0100 (BST)
Date: Thu, 14 Jun 2012 16:32:29 +0200
From: Tomasz Stanislawski <t.stanislaws@samsung.com>
Subject: [PATCHv2 9/9] v4l: vb2-dma-contig: use dma_get_sgtable
In-reply-to: <1339684349-28882-1-git-send-email-t.stanislaws@samsung.com>
To: linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org
Cc: airlied@redhat.com, m.szyprowski@samsung.com,
	t.stanislaws@samsung.com, kyungmin.park@samsung.com,
	laurent.pinchart@ideasonboard.com, sumit.semwal@ti.com,
	daeinki@gmail.com, daniel.vetter@ffwll.ch, robdclark@gmail.com,
	pawel@osciak.com, linaro-mm-sig@lists.linaro.org,
	hverkuil@xs4all.nl, remi@remlab.net, subashrp@gmail.com,
	mchehab@redhat.com, g.liakhovetski@gmx.de
Message-id: <1339684349-28882-10-git-send-email-t.stanislaws@samsung.com>
Content-transfer-encoding: 7BIT
References: <1339684349-28882-1-git-send-email-t.stanislaws@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch removes a workaround for extraction of struct pages
from DMA buffer. The method of using follow_pfn for artificial
VMA is dropped in favour of dma_get_sgtable function.

Signed-off-by: Tomasz Stanislawski <t.stanislaws@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/media/video/videobuf2-dma-contig.c |   60 ++--------------------------
 1 file changed, 4 insertions(+), 56 deletions(-)

diff --git a/drivers/media/video/videobuf2-dma-contig.c b/drivers/media/video/videobuf2-dma-contig.c
index a845ff7..73297b7 100644
--- a/drivers/media/video/videobuf2-dma-contig.c
+++ b/drivers/media/video/videobuf2-dma-contig.c
@@ -361,73 +361,21 @@ static struct dma_buf_ops vb2_dc_dmabuf_ops = {
 	.release = vb2_dc_dmabuf_ops_release,
 };
 
-/**
- * vb2_dc_kaddr_to_pages() - extract list of struct pages from a kernel
- * pointer.  This function is a workaround to extract pages from a pointer
- * returned by dma_alloc_coherent. The pages are obtained by creating an
- * artificial vma and using follow_pfn to do a page walk to find a PFN
- */
-static int vb2_dc_kaddr_to_pages(unsigned long kaddr,
-	struct page **pages, unsigned int n_pages)
-{
-	unsigned int i;
-	unsigned long pfn;
-	/* create an artificial VMA */
-	struct vm_area_struct vma = {
-		.vm_flags = VM_IO | VM_PFNMAP,
-		.vm_mm = &init_mm,
-	};
-
-	for (i = 0; i < n_pages; ++i, kaddr += PAGE_SIZE) {
-		if (follow_pfn(&vma, kaddr, &pfn))
-			break;
-		pages[i] = pfn_to_page(pfn);
-	}
-
-	return i;
-}
-
 static struct sg_table *vb2_dc_get_base_sgt(struct vb2_dc_buf *buf)
 {
-	int n_pages;
-	struct page **pages = NULL;
 	int ret;
 	struct sg_table *sgt;
 
-	n_pages = PAGE_ALIGN(buf->size) >> PAGE_SHIFT;
-
-	pages = kmalloc(n_pages * sizeof pages[0], GFP_KERNEL);
-	if (!pages) {
-		dev_err(buf->dev, "failed to alloc page table\n");
-		return ERR_PTR(-ENOMEM);
-	}
-
-	ret = vb2_dc_kaddr_to_pages((unsigned long)buf->vaddr, pages, n_pages);
-	if (ret < 0) {
-		dev_err(buf->dev, "failed to get buffer pages from DMA API\n");
-		kfree(pages);
-		return ERR_PTR(ret);
-	}
-	if (ret != n_pages) {
-		dev_err(buf->dev, "got only %d of %d pages from DMA API\n",
-			ret, n_pages);
-		kfree(pages);
-		return ERR_PTR(-EFAULT);
-	}
-
 	sgt = kmalloc(sizeof *sgt, GFP_KERNEL);
 	if (!sgt) {
 		dev_err(buf->dev, "failed to alloc sg table\n");
-		kfree(pages);
 		return ERR_PTR(-ENOMEM);
 	}
 
-	ret = sg_alloc_table_from_pages(sgt, pages, n_pages, 0,
-		buf->size, GFP_KERNEL);
-	/* failure or not, pages are no longer needed */
-	kfree(pages);
-	if (ret) {
-		dev_err(buf->dev, "failed to covert pages to sg table\n");
+	ret = dma_get_sgtable(buf->dev, sgt, buf->vaddr, buf->dma_addr,
+		buf->size, NULL);
+	if (ret < 0) {
+		dev_err(buf->dev, "failed to get scatterlist from DMA API\n");
 		kfree(sgt);
 		return ERR_PTR(ret);
 	}
-- 
1.7.9.5

