Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.w1.samsung.com ([210.118.77.12]:17798 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758727Ab2DJNKz (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 10 Apr 2012 09:10:55 -0400
Received: from euspt2 (mailout2.w1.samsung.com [210.118.77.12])
 by mailout2.w1.samsung.com
 (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14 2004))
 with ESMTP id <0M29008RKLXYH0@mailout2.w1.samsung.com> for
 linux-media@vger.kernel.org; Tue, 10 Apr 2012 14:10:47 +0100 (BST)
Received: from linux.samsung.com ([106.116.38.10])
 by spt2.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0M2900G94LY0GU@spt2.w1.samsung.com> for
 linux-media@vger.kernel.org; Tue, 10 Apr 2012 14:10:48 +0100 (BST)
Date: Tue, 10 Apr 2012 15:10:38 +0200
From: Tomasz Stanislawski <t.stanislaws@samsung.com>
Subject: [RFC 04/13] v4l: vb2-dma-contig: add setup of sglist for MMAP buffers
In-reply-to: <1334063447-16824-1-git-send-email-t.stanislaws@samsung.com>
To: linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org
Cc: airlied@redhat.com, m.szyprowski@samsung.com,
	t.stanislaws@samsung.com, kyungmin.park@samsung.com,
	laurent.pinchart@ideasonboard.com, sumit.semwal@ti.com,
	daeinki@gmail.com, daniel.vetter@ffwll.ch, robdclark@gmail.com,
	pawel@osciak.com, linaro-mm-sig@lists.linaro.org,
	subashrp@gmail.com, mchehab@redhat.com
Message-id: <1334063447-16824-5-git-send-email-t.stanislaws@samsung.com>
MIME-version: 1.0
Content-type: TEXT/PLAIN
Content-transfer-encoding: 7BIT
References: <1334063447-16824-1-git-send-email-t.stanislaws@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch adds the setup of sglist list for MMAP buffers.
It is needed for buffer exporting via DMABUF mechanism.

This patch depends on dma_get_pages extension to DMA api.

Signed-off-by: Tomasz Stanislawski <t.stanislaws@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/media/video/videobuf2-dma-contig.c |   51 ++++++++++++++++++++++++++-
 1 files changed, 49 insertions(+), 2 deletions(-)

diff --git a/drivers/media/video/videobuf2-dma-contig.c b/drivers/media/video/videobuf2-dma-contig.c
index f4df9e2..0cdcd2b 100644
--- a/drivers/media/video/videobuf2-dma-contig.c
+++ b/drivers/media/video/videobuf2-dma-contig.c
@@ -31,6 +31,7 @@ struct vb2_dc_buf {
 	/* MMAP related */
 	struct vb2_vmarea_handler	handler;
 	atomic_t			refcount;
+	struct sg_table			*sgt_base;
 
 	/* USERPTR related */
 	struct vm_area_struct		*vma;
@@ -189,6 +190,7 @@ static void vb2_dc_put(void *buf_priv)
 	if (!atomic_dec_and_test(&buf->refcount))
 		return;
 
+	vb2_dc_release_sgtable(buf->sgt_base);
 	dma_free_coherent(buf->dev, buf->size, buf->vaddr, buf->dma_addr);
 	kfree(buf);
 }
@@ -197,6 +199,9 @@ static void *vb2_dc_alloc(void *alloc_ctx, unsigned long size)
 {
 	struct device *dev = alloc_ctx;
 	struct vb2_dc_buf *buf;
+	int ret = -ENOMEM;
+	int n_pages;
+	struct page **pages = NULL;
 
 	buf = kzalloc(sizeof *buf, GFP_KERNEL);
 	if (!buf)
@@ -205,10 +210,41 @@ static void *vb2_dc_alloc(void *alloc_ctx, unsigned long size)
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
+	ret = dma_get_pages(dev, buf->vaddr, buf->dma_addr, pages, n_pages);
+	if (ret < 0) {
+		dev_err(dev, "failed to get buffer pages from DMA API\n");
+		goto fail_pages;
+	}
+	if (ret != n_pages) {
+		ret = -EFAULT;
+		dev_err(dev, "failed to get all pages from DMA API\n");
+		goto fail_pages;
 	}
 
+	buf->sgt_base = vb2_dc_pages_to_sgt(pages, n_pages, 0, 0);
+	if (IS_ERR(buf->sgt_base)) {
+		ret = PTR_ERR(buf->sgt_base);
+		dev_err(dev, "failed to prepare sg table\n");
+		goto fail_pages;
+	}
+
+	/* pages are no longer needed */
+	kfree(pages);
+
 	buf->dev = dev;
 	buf->size = size;
 
@@ -219,6 +255,17 @@ static void *vb2_dc_alloc(void *alloc_ctx, unsigned long size)
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
1.7.5.4

