Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.w1.samsung.com ([210.118.77.11]:45664 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752633Ab2EWNHs (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 23 May 2012 09:07:48 -0400
Received: from euspt2 (mailout1.w1.samsung.com [210.118.77.11])
 by mailout1.w1.samsung.com
 (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14 2004))
 with ESMTP id <0M4H00EPN8D0GP@mailout1.w1.samsung.com> for
 linux-media@vger.kernel.org; Wed, 23 May 2012 14:05:24 +0100 (BST)
Received: from linux.samsung.com ([106.116.38.10])
 by spt2.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0M4H0099C8GUIP@spt2.w1.samsung.com> for
 linux-media@vger.kernel.org; Wed, 23 May 2012 14:07:43 +0100 (BST)
Date: Wed, 23 May 2012 15:07:27 +0200
From: Tomasz Stanislawski <t.stanislaws@samsung.com>
Subject: [PATCH 04/12] v4l: vb2-dma-contig: add setup of sglist for MMAP buffers
In-reply-to: <1337778455-27912-1-git-send-email-t.stanislaws@samsung.com>
To: linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org
Cc: airlied@redhat.com, m.szyprowski@samsung.com,
	t.stanislaws@samsung.com, kyungmin.park@samsung.com,
	laurent.pinchart@ideasonboard.com, sumit.semwal@ti.com,
	daeinki@gmail.com, daniel.vetter@ffwll.ch, robdclark@gmail.com,
	pawel@osciak.com, linaro-mm-sig@lists.linaro.org,
	hverkuil@xs4all.nl, remi@remlab.net, subashrp@gmail.com,
	mchehab@redhat.com, g.liakhovetski@gmx.de
Message-id: <1337778455-27912-5-git-send-email-t.stanislaws@samsung.com>
MIME-version: 1.0
Content-type: TEXT/PLAIN
Content-transfer-encoding: 7BIT
References: <1337778455-27912-1-git-send-email-t.stanislaws@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch adds the setup of sglist list for MMAP buffers.
It is needed for buffer exporting via DMABUF mechanism.

Signed-off-by: Tomasz Stanislawski <t.stanislaws@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/media/video/videobuf2-dma-contig.c |   70 +++++++++++++++++++++++++++-
 1 file changed, 68 insertions(+), 2 deletions(-)

diff --git a/drivers/media/video/videobuf2-dma-contig.c b/drivers/media/video/videobuf2-dma-contig.c
index 52b4f59..ae656be 100644
--- a/drivers/media/video/videobuf2-dma-contig.c
+++ b/drivers/media/video/videobuf2-dma-contig.c
@@ -32,6 +32,7 @@ struct vb2_dc_buf {
 	/* MMAP related */
 	struct vb2_vmarea_handler	handler;
 	atomic_t			refcount;
+	struct sg_table			*sgt_base;
 
 	/* USERPTR related */
 	struct vm_area_struct		*vma;
@@ -189,14 +190,37 @@ static void vb2_dc_put(void *buf_priv)
 	if (!atomic_dec_and_test(&buf->refcount))
 		return;
 
+	vb2_dc_release_sgtable(buf->sgt_base);
 	dma_free_coherent(buf->dev, buf->size, buf->vaddr, buf->dma_addr);
 	kfree(buf);
 }
 
+static int vb2_dc_kaddr_to_pages(unsigned long kaddr,
+	struct page **pages, unsigned int n_pages)
+{
+	unsigned int i;
+	unsigned long pfn;
+	struct vm_area_struct vma = {
+		.vm_flags = VM_IO | VM_PFNMAP,
+		.vm_mm = current->mm,
+	};
+
+	for (i = 0; i < n_pages; ++i, kaddr += PAGE_SIZE) {
+		if (follow_pfn(&vma, kaddr, &pfn))
+			break;
+		pages[i] = pfn_to_page(pfn);
+	}
+
+	return i;
+}
+
 static void *vb2_dc_alloc(void *alloc_ctx, unsigned long size)
 {
 	struct device *dev = alloc_ctx;
 	struct vb2_dc_buf *buf;
+	int ret = -ENOMEM;
+	int n_pages;
+	struct page **pages = NULL;
 
 	buf = kzalloc(sizeof *buf, GFP_KERNEL);
 	if (!buf)
@@ -205,10 +229,41 @@ static void *vb2_dc_alloc(void *alloc_ctx, unsigned long size)
 	buf->vaddr = dma_alloc_coherent(dev, size, &buf->dma_addr, GFP_KERNEL);
 	if (!buf->vaddr) {
 		dev_err(dev, "dma_alloc_coherent of size %ld failed\n", size);
-		kfree(buf);
-		return ERR_PTR(-ENOMEM);
+		goto fail_buf;
+	}
+
+	WARN_ON((unsigned long)buf->vaddr & ~PAGE_MASK);
+	WARN_ON(buf->dma_addr & ~PAGE_MASK);
+
+	n_pages = PAGE_ALIGN(size) >> PAGE_SHIFT;
+
+	pages = kmalloc(n_pages * sizeof pages[0], GFP_KERNEL);
+	if (!pages) {
+		dev_err(dev, "failed to alloc page table\n");
+		goto fail_dma;
+	}
+
+	ret = vb2_dc_kaddr_to_pages((unsigned long)buf->vaddr, pages, n_pages);
+	if (ret < 0) {
+		dev_err(dev, "failed to get buffer pages from DMA API\n");
+		goto fail_pages;
+	}
+	if (ret != n_pages) {
+		ret = -EFAULT;
+		dev_err(dev, "failed to get all pages from DMA API\n");
+		goto fail_pages;
+	}
+
+	buf->sgt_base = vb2_dc_pages_to_sgt(pages, n_pages, 0, size);
+	if (IS_ERR(buf->sgt_base)) {
+		ret = PTR_ERR(buf->sgt_base);
+		dev_err(dev, "failed to prepare sg table\n");
+		goto fail_pages;
 	}
 
+	/* pages are no longer needed */
+	kfree(pages);
+
 	buf->dev = dev;
 	buf->size = size;
 
@@ -219,6 +274,17 @@ static void *vb2_dc_alloc(void *alloc_ctx, unsigned long size)
 	atomic_inc(&buf->refcount);
 
 	return buf;
+
+fail_pages:
+	kfree(pages);
+
+fail_dma:
+	dma_free_coherent(dev, size, buf->vaddr, buf->dma_addr);
+
+fail_buf:
+	kfree(buf);
+
+	return ERR_PTR(ret);
 }
 
 static int vb2_dc_mmap(void *buf_priv, struct vm_area_struct *vma)
-- 
1.7.9.5

