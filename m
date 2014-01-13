Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr1.xs4all.nl ([194.109.24.21]:2485 "EHLO
	smtp-vbr1.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750991AbaAMJzC (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 13 Jan 2014 04:55:02 -0500
Message-ID: <52D3B7E3.4030901@xs4all.nl>
Date: Mon, 13 Jan 2014 10:54:43 +0100
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Marek Szyprowski <m.szyprowski@samsung.com>
CC: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	Pawel Osciak <pawel@osciak.com>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	Ismael Luceno <ismael.luceno@corp.bluecherry.net>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	linux-media <linux-media@vger.kernel.org>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: Re: [PATCH v4 2/2] videobuf2-dma-sg: Replace vb2_dma_sg_desc with
 sg_table
References: <1375453200-28459-1-git-send-email-ricardo.ribalda@gmail.com> <1375453200-28459-3-git-send-email-ricardo.ribalda@gmail.com> <52C6CEC6.8020602@xs4all.nl> <CAPybu_1ABrgBGYNicL37cBE_A2-eYq4=7Cwa-nfEJWndVqq2EQ@mail.gmail.com> <52C6D90D.9010906@xs4all.nl> <CAPybu_2NAyE+Os9NJSSRY0n1+6ObWYpfH1m9Nj0c+B-xj+KVYg@mail.gmail.com> <52CD5BB2.2080305@samsung.com>
In-Reply-To: <52CD5BB2.2080305@samsung.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Marek, Ricardo,

On 01/08/2014 03:07 PM, Marek Szyprowski wrote:
> Hello All,
> 
> On 2014-01-03 16:51, Ricardo Ribalda Delgado wrote:
>> Hello Hans
>>
>> What if we move the dma_map_sg and dma_unmap_sg to the vb2 interface,
>> and there do something like:
>>
>> n_sg= dma_map_sg()
>> if (n_sg=-ENOMEM){
>>     split_table() //Breaks down the sg_table into monopages sg
>>     n_sg= dma_map_sg()

This is not a good approach. Remember that if swiotbl needs to allocate
e.g. 17 contiguous pages it will round up to the next power of two, so it
allocates 32 pages. So even if dma_map_sg succeeds, it might waste a lot
of memory.

>> }
>> if (n_sg=-ENOMEM)
>>    return -ENOMEM
> 
> dma_map_sg/dma_unmap_sg should be moved to vb2-dma-sg memory allocator. 
> The best place for calling them is buf_prepare() and buf_finish() 
> callbacks. I think that I've already pointed this some time ago, but 
> unfortunately I didn't find enough time to convert existing code.

That would be nice, but this is a separate issue.

> For solving the problem described by Hans, I think that vb2-dma-sg 
> memory allocator should check dma mask of the client device and add 
> appropriate GFP_DMA or GFP_DMA32 flags to alloc_pages(). This should fix 
> the issues with failed dma_map_sg due to lack of bouncing buffers.

Those GFP flags are for the scatterlist itself, and that can be placed
anywhere in memory (frankly, I'm not sure why sg_alloc_table_from_pages
has a gfp_flags argument at all and I think it is used incorrectly in
videobuf2-dma-sg.c as well).

I see two options. The first is the patch I included below: this adds a
bool to sg_alloc_table_from_pages() that tells it whether or not page
combining should be enabled. It also adds the vb2 queue's gfp_flags as
an argument to the get_userptr operation. In videobuf2-dma-sg.c that is
checked to see whether or not sg_alloc_table_from_pages() should enable
page-combining.

The alternative would be to have vb2_queue_init check if the use of
V4L2_MEMORY_USERPTR would lead to dma bouncing based on the q->io_modes
and q->gfp_flags and if so, remove USERPTR support from io_modes. Do
we really want to have page bouncing for video capture?

Feedback would be welcome as I am not sure what the best solution is.

Regards,

	Hans

PS: for a final version this patch would be split up in 2 or 3 patches.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>

diff --git a/arch/arm/mm/dma-mapping.c b/arch/arm/mm/dma-mapping.c
index 79f8b39..404716f 100644
--- a/arch/arm/mm/dma-mapping.c
+++ b/arch/arm/mm/dma-mapping.c
@@ -1468,7 +1468,7 @@ static int arm_iommu_get_sgtable(struct device *dev, struct sg_table *sgt,
 		return -ENXIO;
 
 	return sg_alloc_table_from_pages(sgt, pages, count, 0, size,
-					 GFP_KERNEL);
+					 true, GFP_KERNEL);
 }
 
 static int __dma_direction_to_prot(enum dma_data_direction dir)
diff --git a/drivers/gpu/drm/drm_prime.c b/drivers/gpu/drm/drm_prime.c
index 56805c3..4c56338 100644
--- a/drivers/gpu/drm/drm_prime.c
+++ b/drivers/gpu/drm/drm_prime.c
@@ -617,7 +617,7 @@ struct sg_table *drm_prime_pages_to_sg(struct page **pages, int nr_pages)
 	}
 
 	ret = sg_alloc_table_from_pages(sg, pages, nr_pages, 0,
-				nr_pages << PAGE_SHIFT, GFP_KERNEL);
+				nr_pages << PAGE_SHIFT, true, GFP_KERNEL);
 	if (ret)
 		goto out;
 
diff --git a/drivers/gpu/drm/exynos/exynos_drm_g2d.c b/drivers/gpu/drm/exynos/exynos_drm_g2d.c
index 7bccedc..0236f9b 100644
--- a/drivers/gpu/drm/exynos/exynos_drm_g2d.c
+++ b/drivers/gpu/drm/exynos/exynos_drm_g2d.c
@@ -505,7 +505,7 @@ static dma_addr_t *g2d_userptr_get_dma_addr(struct drm_device *drm_dev,
 	}
 
 	ret = sg_alloc_table_from_pages(sgt, pages, npages, offset,
-					size, GFP_KERNEL);
+					size, true, GFP_KERNEL);
 	if (ret < 0) {
 		DRM_ERROR("failed to get sgt from pages.\n");
 		goto err_free_sgt;
diff --git a/drivers/gpu/drm/vmwgfx/vmwgfx_buffer.c b/drivers/gpu/drm/vmwgfx/vmwgfx_buffer.c
index 7776e6f..7ee560c 100644
--- a/drivers/gpu/drm/vmwgfx/vmwgfx_buffer.c
+++ b/drivers/gpu/drm/vmwgfx/vmwgfx_buffer.c
@@ -348,6 +348,7 @@ static int vmw_ttm_map_dma(struct vmw_ttm_tt *vmw_tt)
 						vsgt->num_pages, 0,
 						(unsigned long)
 						vsgt->num_pages << PAGE_SHIFT,
+						true,
 						GFP_KERNEL);
 		if (unlikely(ret != 0))
 			goto out_sg_alloc_fail;
diff --git a/drivers/media/v4l2-core/videobuf2-core.c b/drivers/media/v4l2-core/videobuf2-core.c
index c203b9c..9dd2149 100644
--- a/drivers/media/v4l2-core/videobuf2-core.c
+++ b/drivers/media/v4l2-core/videobuf2-core.c
@@ -1081,7 +1081,8 @@ static int __qbuf_userptr(struct vb2_buffer *vb, const struct v4l2_buffer *b)
 		/* Acquire each plane's memory */
 		mem_priv = call_memop(q, get_userptr, q->alloc_ctx[plane],
 				      planes[plane].m.userptr,
-				      planes[plane].length, write);
+				      planes[plane].length, write,
+				      q->gfp_flags);
 		if (IS_ERR_OR_NULL(mem_priv)) {
 			dprintk(1, "qbuf: failed acquiring userspace "
 						"memory for plane %d\n", plane);
diff --git a/drivers/media/v4l2-core/videobuf2-dma-contig.c b/drivers/media/v4l2-core/videobuf2-dma-contig.c
index 33d3871d..0a6c079 100644
--- a/drivers/media/v4l2-core/videobuf2-dma-contig.c
+++ b/drivers/media/v4l2-core/videobuf2-dma-contig.c
@@ -548,7 +548,7 @@ static inline dma_addr_t vb2_dc_pfn_to_dma(struct device *dev, unsigned long pfn
 #endif
 
 static void *vb2_dc_get_userptr(void *alloc_ctx, unsigned long vaddr,
-	unsigned long size, int write)
+	unsigned long size, int write, unsigned gfp_flags)
 {
 	struct vb2_dc_conf *conf = alloc_ctx;
 	struct vb2_dc_buf *buf;
@@ -637,7 +637,7 @@ static void *vb2_dc_get_userptr(void *alloc_ctx, unsigned long vaddr,
 	}
 
 	ret = sg_alloc_table_from_pages(sgt, pages, n_pages,
-		offset, size, GFP_KERNEL);
+		offset, size, true, GFP_KERNEL);
 	if (ret) {
 		pr_err("failed to initialize sg table\n");
 		goto fail_sgt;
diff --git a/drivers/media/v4l2-core/videobuf2-dma-sg.c b/drivers/media/v4l2-core/videobuf2-dma-sg.c
index c779f21..3603f36 100644
--- a/drivers/media/v4l2-core/videobuf2-dma-sg.c
+++ b/drivers/media/v4l2-core/videobuf2-dma-sg.c
@@ -113,7 +113,7 @@ static void *vb2_dma_sg_alloc(void *alloc_ctx, unsigned long size, gfp_t gfp_fla
 		goto fail_pages_alloc;
 
 	ret = sg_alloc_table_from_pages(&buf->sg_table, buf->pages,
-			buf->num_pages, 0, size, gfp_flags);
+			buf->num_pages, 0, size, true, GFP_KERNEL);
 	if (ret)
 		goto fail_table_alloc;
 
@@ -162,12 +162,14 @@ static inline int vma_is_io(struct vm_area_struct *vma)
 }
 
 static void *vb2_dma_sg_get_userptr(void *alloc_ctx, unsigned long vaddr,
-				    unsigned long size, int write)
+				    unsigned long size, int write,
+				    unsigned gfp_flags)
 {
 	struct vb2_dma_sg_buf *buf;
 	unsigned long first, last;
 	int num_pages_from_user;
 	struct vm_area_struct *vma;
+	bool combine_pages = true;
 
 	buf = kzalloc(sizeof *buf, GFP_KERNEL);
 	if (!buf)
@@ -229,8 +231,24 @@ static void *vb2_dma_sg_get_userptr(void *alloc_ctx, unsigned long vaddr,
 	if (num_pages_from_user != buf->num_pages)
 		goto userptr_fail_get_user_pages;
 
+	/*
+	 * Do not attempt to combine pages if bounce buffers
+	 * have to be involved: allocating a bounce buffer of multiple
+	 * pages will easily fail due to memory fragmentation of the
+	 * DMA-able memory zone.
+	 */
+#ifdef CONFIG_ZONE_DMA
+	if (gfp_flags & GFP_DMA)
+		combine_pages = false;
+#endif
+#ifdef CONFIG_ZONE_DMA32
+	if (gfp_flags & GFP_DMA32)
+		combine_pages = false;
+#endif
+
 	if (sg_alloc_table_from_pages(&buf->sg_table, buf->pages,
-			buf->num_pages, buf->offset, size, 0))
+			buf->num_pages, buf->offset, size,
+			combine_pages, GFP_KERNEL))
 		goto userptr_fail_alloc_table_from_pages;
 
 	return buf;
diff --git a/drivers/media/v4l2-core/videobuf2-vmalloc.c b/drivers/media/v4l2-core/videobuf2-vmalloc.c
index 313d977..12569bc 100644
--- a/drivers/media/v4l2-core/videobuf2-vmalloc.c
+++ b/drivers/media/v4l2-core/videobuf2-vmalloc.c
@@ -70,7 +70,8 @@ static void vb2_vmalloc_put(void *buf_priv)
 }
 
 static void *vb2_vmalloc_get_userptr(void *alloc_ctx, unsigned long vaddr,
-				     unsigned long size, int write)
+				     unsigned long size, int write,
+				     unsigned gfp_flags)
 {
 	struct vb2_vmalloc_buf *buf;
 	unsigned long first, last;
diff --git a/include/linux/scatterlist.h b/include/linux/scatterlist.h
index adae88f..eb30306 100644
--- a/include/linux/scatterlist.h
+++ b/include/linux/scatterlist.h
@@ -237,7 +237,7 @@ int sg_alloc_table(struct sg_table *, unsigned int, gfp_t);
 int sg_alloc_table_from_pages(struct sg_table *sgt,
 	struct page **pages, unsigned int n_pages,
 	unsigned long offset, unsigned long size,
-	gfp_t gfp_mask);
+	bool combine_pages, gfp_t gfp_mask);
 
 size_t sg_copy_from_buffer(struct scatterlist *sgl, unsigned int nents,
 			   void *buf, size_t buflen);
diff --git a/include/media/videobuf2-core.h b/include/media/videobuf2-core.h
index cf870e5..5bd8446 100644
--- a/include/media/videobuf2-core.h
+++ b/include/media/videobuf2-core.h
@@ -87,7 +87,8 @@ struct vb2_mem_ops {
 	struct dma_buf *(*get_dmabuf)(void *buf_priv, unsigned long flags);
 
 	void		*(*get_userptr)(void *alloc_ctx, unsigned long vaddr,
-					unsigned long size, int write);
+					unsigned long size, int write,
+					unsigned gfp_flags);
 	void		(*put_userptr)(void *buf_priv);
 
 	void		(*prepare)(void *buf_priv);
diff --git a/lib/scatterlist.c b/lib/scatterlist.c
index d16fa29..7c5a96a 100644
--- a/lib/scatterlist.c
+++ b/lib/scatterlist.c
@@ -340,14 +340,15 @@ EXPORT_SYMBOL(sg_alloc_table);
  * @n_pages:	Number of pages in the pages array
  * @offset:     Offset from start of the first page to the start of a buffer
  * @size:       Number of valid bytes in the buffer (after offset)
+ * @combine_pages: If true, then combine consecutive pages into one chunk
  * @gfp_mask:	GFP allocation mask
  *
  *  Description:
  *    Allocate and initialize an sg table from a list of pages. Contiguous
- *    ranges of the pages are squashed into a single scatterlist node. A user
- *    may provide an offset at a start and a size of valid data in a buffer
- *    specified by the page array. The returned sg table is released by
- *    sg_free_table.
+ *    ranges of the pages are squashed into a single scatterlist node if
+ *    @combine_pages is true. A user may provide an offset at a start and a
+ *    size of valid data in a buffer specified by the page array. The returned
+ *    sg table is released by sg_free_table.
  *
  * Returns:
  *   0 on success, negative error on failure
@@ -355,7 +356,7 @@ EXPORT_SYMBOL(sg_alloc_table);
 int sg_alloc_table_from_pages(struct sg_table *sgt,
 	struct page **pages, unsigned int n_pages,
 	unsigned long offset, unsigned long size,
-	gfp_t gfp_mask)
+	bool combine_pages, gfp_t gfp_mask)
 {
 	unsigned int chunks;
 	unsigned int i;
@@ -366,7 +367,8 @@ int sg_alloc_table_from_pages(struct sg_table *sgt,
 	/* compute number of contiguous chunks */
 	chunks = 1;
 	for (i = 1; i < n_pages; ++i)
-		if (page_to_pfn(pages[i]) != page_to_pfn(pages[i - 1]) + 1)
+		if (!combine_pages ||
+		    page_to_pfn(pages[i]) != page_to_pfn(pages[i - 1]) + 1)
 			++chunks;
 
 	ret = sg_alloc_table(sgt, chunks, gfp_mask);
@@ -381,8 +383,8 @@ int sg_alloc_table_from_pages(struct sg_table *sgt,
 
 		/* look for the end of the current chunk */
 		for (j = cur_page + 1; j < n_pages; ++j)
-			if (page_to_pfn(pages[j]) !=
-			    page_to_pfn(pages[j - 1]) + 1)
+			if (!combine_pages ||
+			    page_to_pfn(pages[j]) != page_to_pfn(pages[j - 1]) + 1)
 				break;
 
 		chunk_size = ((j - cur_page) << PAGE_SHIFT) - offset;

