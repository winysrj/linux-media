Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.samsung.com ([203.254.224.34]:46653 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756457Ab3FSM5J (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 19 Jun 2013 08:57:09 -0400
Received: from epcpsbgm2.samsung.com (epcpsbgm2 [203.254.230.27])
 by mailout4.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MON002O85B3HME0@mailout4.samsung.com> for
 linux-media@vger.kernel.org; Wed, 19 Jun 2013 21:57:07 +0900 (KST)
From: Marek Szyprowski <m.szyprowski@samsung.com>
To: linux-media@vger.kernel.org, linaro-mm-sig@lists.linaro.org
Cc: Marek Szyprowski <m.szyprowski@samsung.com>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	Tomasz Stanislawski <t.stanislaws@samsung.com>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Kamil Debski <k.debski@samsung.com>, lonsn2005@gmail.com,
	sachin.kamat@linaro.org
Subject: [PATCH] v4l2: videobuf2-dc: fix support for mappings without struct
 page in userptr mode
Date: Wed, 19 Jun 2013 14:56:46 +0200
Message-id: <1371646607-23321-1-git-send-email-m.szyprowski@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Earlier version of dma-contig allocator in user ptr mode assumed that in
all cases DMA address equals physical address. This was just a special case.
Commit e15dab752d4c588544ccabdbe020a7cc092e23c8 introduced correct support
for converting userpage to dma address, but unfortunately it broke the
support for simple dma address = physical address for the case, when given
physical frame has no struct page associated with it (this happens if one
use for example dma_declare_coherent api or other reserved memory approach).
This commit restores support for such cases.

Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
---
 drivers/media/v4l2-core/videobuf2-dma-contig.c |   87 ++++++++++++++++++++++--
 1 file changed, 82 insertions(+), 5 deletions(-)

diff --git a/drivers/media/v4l2-core/videobuf2-dma-contig.c b/drivers/media/v4l2-core/videobuf2-dma-contig.c
index fd56f25..1382749 100644
--- a/drivers/media/v4l2-core/videobuf2-dma-contig.c
+++ b/drivers/media/v4l2-core/videobuf2-dma-contig.c
@@ -423,6 +423,39 @@ static inline int vma_is_io(struct vm_area_struct *vma)
 	return !!(vma->vm_flags & (VM_IO | VM_PFNMAP));
 }
 
+static int vb2_dc_get_user_pfn(unsigned long start, int n_pages,
+	struct vm_area_struct *vma, unsigned long *res)
+{
+	unsigned long pfn, start_pfn, prev_pfn;
+	unsigned int i;
+	int ret;
+
+	if (!vma_is_io(vma))
+		return -EFAULT;
+
+	ret = follow_pfn(vma, start, &pfn);
+	if (ret)
+		return ret;
+
+	start_pfn = pfn;
+	start += PAGE_SIZE;
+
+	for (i = 1; i < n_pages; ++i, start += PAGE_SIZE) {
+		prev_pfn = pfn;
+		ret = follow_pfn(vma, start, &pfn);
+
+		if (ret) {
+			pr_err("no page for address %lu\n", start);
+			return ret;
+		}
+		if (pfn != prev_pfn + 1)
+			return -EINVAL;
+	}
+
+	*res = start_pfn;
+	return 0;
+}
+
 static int vb2_dc_get_user_pages(unsigned long start, struct page **pages,
 	int n_pages, struct vm_area_struct *vma, int write)
 {
@@ -433,6 +466,9 @@ static int vb2_dc_get_user_pages(unsigned long start, struct page **pages,
 			unsigned long pfn;
 			int ret = follow_pfn(vma, start, &pfn);
 
+			if (!pfn_valid(pfn))
+				return -EINVAL;
+
 			if (ret) {
 				pr_err("no page for address %lu\n", start);
 				return ret;
@@ -468,16 +504,49 @@ static void vb2_dc_put_userptr(void *buf_priv)
 	struct vb2_dc_buf *buf = buf_priv;
 	struct sg_table *sgt = buf->dma_sgt;
 
-	dma_unmap_sg(buf->dev, sgt->sgl, sgt->orig_nents, buf->dma_dir);
-	if (!vma_is_io(buf->vma))
-		vb2_dc_sgt_foreach_page(sgt, vb2_dc_put_dirty_page);
+	if (sgt) {
+		dma_unmap_sg(buf->dev, sgt->sgl, sgt->orig_nents, buf->dma_dir);
+		if (!vma_is_io(buf->vma))
+			vb2_dc_sgt_foreach_page(sgt, vb2_dc_put_dirty_page);
 
-	sg_free_table(sgt);
-	kfree(sgt);
+		sg_free_table(sgt);
+		kfree(sgt);
+	}
 	vb2_put_vma(buf->vma);
 	kfree(buf);
 }
 
+/*
+ * For some kind of reserved memory there might be no struct page available,
+ * so all that can be done to support such 'pages' is to try to convert
+ * pfn to dma address or at the last resort just assume that
+ * dma address == physical address (like it has been assumed in earlier version
+ * of videobuf2-dma-contig
+ */
+
+#ifdef __arch_pfn_to_dma
+static inline dma_addr_t vb2_dc_pfn_to_dma(struct device *dev, unsigned long pfn)
+{
+	return (dma_addr_t)__arch_pfn_to_dma(dev, pfn);
+}
+#elsif defined(__pfn_to_bus)
+static inline dma_addr_t vb2_dc_pfn_to_dma(struct device *dev, unsigned long pfn)
+{
+	return (dma_addr_t)__pfn_to_bus(pfn);
+}
+#elsif defined(__pfn_to_phys)
+static inline dma_addr_t vb2_dc_pfn_to_dma(struct device *dev, unsigned long pfn)
+{
+	return (dma_addr_t)__pfn_to_phys(pfn);
+}
+#else
+static inline dma_addr_t vb2_dc_pfn_to_dma(struct device *dev, unsigned long pfn)
+{
+	/* really, we cannot do anything better at this point */
+	return (dma_addr_t)(pfn) << PAGE_SHIFT;
+}
+#endif
+
 static void *vb2_dc_get_userptr(void *alloc_ctx, unsigned long vaddr,
 	unsigned long size, int write)
 {
@@ -548,6 +617,14 @@ static void *vb2_dc_get_userptr(void *alloc_ctx, unsigned long vaddr,
 	/* extract page list from userspace mapping */
 	ret = vb2_dc_get_user_pages(start, pages, n_pages, vma, write);
 	if (ret) {
+		unsigned long pfn;
+		if (vb2_dc_get_user_pfn(start, n_pages, vma, &pfn) == 0) {
+			buf->dma_addr = vb2_dc_pfn_to_dma(buf->dev, pfn);
+			buf->size = size;
+			kfree(pages);
+			return buf;
+		}
+
 		pr_err("failed to get user pages\n");
 		goto fail_vma;
 	}
-- 
1.7.9.5

