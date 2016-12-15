Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qk0-f172.google.com ([209.85.220.172]:35678 "EHLO
        mail-qk0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753628AbcLOAIK (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 14 Dec 2016 19:08:10 -0500
Received: by mail-qk0-f172.google.com with SMTP id n204so39702481qke.2
        for <linux-media@vger.kernel.org>; Wed, 14 Dec 2016 16:07:52 -0800 (PST)
From: Laura Abbott <labbott@redhat.com>
To: Sumit Semwal <sumit.semwal@linaro.org>,
        Riley Andrews <riandrews@android.com>, arve@android.com
Cc: Laura Abbott <labbott@redhat.com>, romlem@google.com,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        linaro-mm-sig@lists.linaro.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-arm-kernel@lists.infradead.org,
        Bryan Huntsman <bryanh@codeaurora.org>, pratikp@codeaurora.org,
        linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org,
        Brian Starkey <brian.starkey@arm.com>
Subject: [RFC PATCH 1/4] staging: android: ion: Some cleanup
Date: Wed, 14 Dec 2016 16:07:40 -0800
Message-Id: <1481760463-3515-2-git-send-email-labbott@redhat.com>
In-Reply-To: <1481760463-3515-1-git-send-email-labbott@redhat.com>
References: <1481760463-3515-1-git-send-email-labbott@redhat.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


- dmap_cnt isn't used. Remove it.
- Ion has been using dma apis incorrectly to sync the caches.
  Remove bad usage in preparation for something better.
- The alignment field doesn't actually change the alignment of an
  allocation, it only serves as an error check. This is basically
  pointless. Remove the field.

Not-signed-off-by: Laura Abbott <labbott@redhat.com>
---
 drivers/staging/android/ion/ion-ioctl.c         |  6 --
 drivers/staging/android/ion/ion.c               | 92 ++-----------------------
 drivers/staging/android/ion/ion.h               |  5 +-
 drivers/staging/android/ion/ion_carveout_heap.c | 16 +----
 drivers/staging/android/ion/ion_chunk_heap.c    | 15 +---
 drivers/staging/android/ion/ion_cma_heap.c      |  5 +-
 drivers/staging/android/ion/ion_page_pool.c     |  3 -
 drivers/staging/android/ion/ion_priv.h          |  4 +-
 drivers/staging/android/ion/ion_system_heap.c   | 14 +---
 9 files changed, 16 insertions(+), 144 deletions(-)

diff --git a/drivers/staging/android/ion/ion-ioctl.c b/drivers/staging/android/ion/ion-ioctl.c
index 7e7431d..a27db9d 100644
--- a/drivers/staging/android/ion/ion-ioctl.c
+++ b/drivers/staging/android/ion/ion-ioctl.c
@@ -95,7 +95,6 @@ long ion_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
 		struct ion_handle *handle;
 
 		handle = ion_alloc(client, data.allocation.len,
-						data.allocation.align,
 						data.allocation.heap_id_mask,
 						data.allocation.flags);
 		if (IS_ERR(handle))
@@ -146,11 +145,6 @@ long ion_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
 			data.handle.handle = handle->id;
 		break;
 	}
-	case ION_IOC_SYNC:
-	{
-		ret = ion_sync_for_device(client, data.fd.fd);
-		break;
-	}
 	case ION_IOC_CUSTOM:
 	{
 		if (!dev->custom_ioctl)
diff --git a/drivers/staging/android/ion/ion.c b/drivers/staging/android/ion/ion.c
index d5cc307..8dd0932 100644
--- a/drivers/staging/android/ion/ion.c
+++ b/drivers/staging/android/ion/ion.c
@@ -102,7 +102,6 @@ static void ion_buffer_add(struct ion_device *dev,
 static struct ion_buffer *ion_buffer_create(struct ion_heap *heap,
 					    struct ion_device *dev,
 					    unsigned long len,
-					    unsigned long align,
 					    unsigned long flags)
 {
 	struct ion_buffer *buffer;
@@ -118,15 +117,14 @@ static struct ion_buffer *ion_buffer_create(struct ion_heap *heap,
 	buffer->flags = flags;
 	kref_init(&buffer->ref);
 
-	ret = heap->ops->allocate(heap, buffer, len, align, flags);
+	ret = heap->ops->allocate(heap, buffer, len, flags);
 
 	if (ret) {
 		if (!(heap->flags & ION_HEAP_FLAG_DEFER_FREE))
 			goto err2;
 
 		ion_heap_freelist_drain(heap, 0);
-		ret = heap->ops->allocate(heap, buffer, len, align,
-					  flags);
+		ret = heap->ops->allocate(heap, buffer, len, flags);
 		if (ret)
 			goto err2;
 	}
@@ -400,7 +398,7 @@ static int ion_handle_add(struct ion_client *client, struct ion_handle *handle)
 }
 
 struct ion_handle *ion_alloc(struct ion_client *client, size_t len,
-			     size_t align, unsigned int heap_id_mask,
+			     unsigned int heap_id_mask,
 			     unsigned int flags)
 {
 	struct ion_handle *handle;
@@ -409,8 +407,8 @@ struct ion_handle *ion_alloc(struct ion_client *client, size_t len,
 	struct ion_heap *heap;
 	int ret;
 
-	pr_debug("%s: len %zu align %zu heap_id_mask %u flags %x\n", __func__,
-		 len, align, heap_id_mask, flags);
+	pr_debug("%s: len %zu heap_id_mask %u flags %x\n", __func__,
+		 len, heap_id_mask, flags);
 	/*
 	 * traverse the list of heaps available in this system in priority
 	 * order.  If the heap type is supported by the client, and matches the
@@ -427,7 +425,7 @@ struct ion_handle *ion_alloc(struct ion_client *client, size_t len,
 		/* if the caller didn't specify this heap id */
 		if (!((1 << heap->id) & heap_id_mask))
 			continue;
-		buffer = ion_buffer_create(heap, dev, len, align, flags);
+		buffer = ion_buffer_create(heap, dev, len, flags);
 		if (!IS_ERR(buffer))
 			break;
 	}
@@ -797,17 +795,12 @@ void ion_client_destroy(struct ion_client *client)
 }
 EXPORT_SYMBOL(ion_client_destroy);
 
-static void ion_buffer_sync_for_device(struct ion_buffer *buffer,
-				       struct device *dev,
-				       enum dma_data_direction direction);
-
 static struct sg_table *ion_map_dma_buf(struct dma_buf_attachment *attachment,
 					enum dma_data_direction direction)
 {
 	struct dma_buf *dmabuf = attachment->dmabuf;
 	struct ion_buffer *buffer = dmabuf->priv;
 
-	ion_buffer_sync_for_device(buffer, attachment->dev, direction);
 	return buffer->sg_table;
 }
 
@@ -817,60 +810,11 @@ static void ion_unmap_dma_buf(struct dma_buf_attachment *attachment,
 {
 }
 
-void ion_pages_sync_for_device(struct device *dev, struct page *page,
-			       size_t size, enum dma_data_direction dir)
-{
-	struct scatterlist sg;
-
-	sg_init_table(&sg, 1);
-	sg_set_page(&sg, page, size, 0);
-	/*
-	 * This is not correct - sg_dma_address needs a dma_addr_t that is valid
-	 * for the targeted device, but this works on the currently targeted
-	 * hardware.
-	 */
-	sg_dma_address(&sg) = page_to_phys(page);
-	dma_sync_sg_for_device(dev, &sg, 1, dir);
-}
-
 struct ion_vma_list {
 	struct list_head list;
 	struct vm_area_struct *vma;
 };
 
-static void ion_buffer_sync_for_device(struct ion_buffer *buffer,
-				       struct device *dev,
-				       enum dma_data_direction dir)
-{
-	struct ion_vma_list *vma_list;
-	int pages = PAGE_ALIGN(buffer->size) / PAGE_SIZE;
-	int i;
-
-	pr_debug("%s: syncing for device %s\n", __func__,
-		 dev ? dev_name(dev) : "null");
-
-	if (!ion_buffer_fault_user_mappings(buffer))
-		return;
-
-	mutex_lock(&buffer->lock);
-	for (i = 0; i < pages; i++) {
-		struct page *page = buffer->pages[i];
-
-		if (ion_buffer_page_is_dirty(page))
-			ion_pages_sync_for_device(dev, ion_buffer_page(page),
-						  PAGE_SIZE, dir);
-
-		ion_buffer_page_clean(buffer->pages + i);
-	}
-	list_for_each_entry(vma_list, &buffer->vmas, list) {
-		struct vm_area_struct *vma = vma_list->vma;
-
-		zap_page_range(vma, vma->vm_start, vma->vm_end - vma->vm_start,
-			       NULL);
-	}
-	mutex_unlock(&buffer->lock);
-}
-
 static int ion_vm_fault(struct vm_area_struct *vma, struct vm_fault *vmf)
 {
 	struct ion_buffer *buffer = vma->vm_private_data;
@@ -1135,30 +1079,6 @@ struct ion_handle *ion_import_dma_buf_fd(struct ion_client *client, int fd)
 }
 EXPORT_SYMBOL(ion_import_dma_buf_fd);
 
-int ion_sync_for_device(struct ion_client *client, int fd)
-{
-	struct dma_buf *dmabuf;
-	struct ion_buffer *buffer;
-
-	dmabuf = dma_buf_get(fd);
-	if (IS_ERR(dmabuf))
-		return PTR_ERR(dmabuf);
-
-	/* if this memory came from ion */
-	if (dmabuf->ops != &dma_buf_ops) {
-		pr_err("%s: can not sync dmabuf from another exporter\n",
-		       __func__);
-		dma_buf_put(dmabuf);
-		return -EINVAL;
-	}
-	buffer = dmabuf->priv;
-
-	dma_sync_sg_for_device(NULL, buffer->sg_table->sgl,
-			       buffer->sg_table->nents, DMA_BIDIRECTIONAL);
-	dma_buf_put(dmabuf);
-	return 0;
-}
-
 int ion_query_heaps(struct ion_client *client, struct ion_heap_query *query)
 {
 	struct ion_device *dev = client->dev;
diff --git a/drivers/staging/android/ion/ion.h b/drivers/staging/android/ion/ion.h
index 93dafb4..3b4bff5 100644
--- a/drivers/staging/android/ion/ion.h
+++ b/drivers/staging/android/ion/ion.h
@@ -45,7 +45,6 @@ struct ion_buffer;
  * @name:	used for debug purposes
  * @base:	base address of heap in physical memory if applicable
  * @size:	size of the heap in bytes if applicable
- * @align:	required alignment in physical memory if applicable
  * @priv:	private info passed from the board file
  *
  * Provided by the board file.
@@ -93,8 +92,6 @@ void ion_client_destroy(struct ion_client *client);
  * ion_alloc - allocate ion memory
  * @client:		the client
  * @len:		size of the allocation
- * @align:		requested allocation alignment, lots of hardware blocks
- *			have alignment requirements of some kind
  * @heap_id_mask:	mask of heaps to allocate from, if multiple bits are set
  *			heaps will be tried in order from highest to lowest
  *			id
@@ -106,7 +103,7 @@ void ion_client_destroy(struct ion_client *client);
  * an opaque handle to it.
  */
 struct ion_handle *ion_alloc(struct ion_client *client, size_t len,
-			     size_t align, unsigned int heap_id_mask,
+			     unsigned int heap_id_mask,
 			     unsigned int flags);
 
 /**
diff --git a/drivers/staging/android/ion/ion_carveout_heap.c b/drivers/staging/android/ion/ion_carveout_heap.c
index a8ea973..e0e360f 100644
--- a/drivers/staging/android/ion/ion_carveout_heap.c
+++ b/drivers/staging/android/ion/ion_carveout_heap.c
@@ -34,8 +34,7 @@ struct ion_carveout_heap {
 };
 
 static ion_phys_addr_t ion_carveout_allocate(struct ion_heap *heap,
-					     unsigned long size,
-					     unsigned long align)
+					     unsigned long size)
 {
 	struct ion_carveout_heap *carveout_heap =
 		container_of(heap, struct ion_carveout_heap, heap);
@@ -60,16 +59,13 @@ static void ion_carveout_free(struct ion_heap *heap, ion_phys_addr_t addr,
 
 static int ion_carveout_heap_allocate(struct ion_heap *heap,
 				      struct ion_buffer *buffer,
-				      unsigned long size, unsigned long align,
+				      unsigned long size,
 				      unsigned long flags)
 {
 	struct sg_table *table;
 	ion_phys_addr_t paddr;
 	int ret;
 
-	if (align > PAGE_SIZE)
-		return -EINVAL;
-
 	table = kmalloc(sizeof(*table), GFP_KERNEL);
 	if (!table)
 		return -ENOMEM;
@@ -77,7 +73,7 @@ static int ion_carveout_heap_allocate(struct ion_heap *heap,
 	if (ret)
 		goto err_free;
 
-	paddr = ion_carveout_allocate(heap, size, align);
+	paddr = ion_carveout_allocate(heap, size);
 	if (paddr == ION_CARVEOUT_ALLOCATE_FAIL) {
 		ret = -ENOMEM;
 		goto err_free_table;
@@ -104,10 +100,6 @@ static void ion_carveout_heap_free(struct ion_buffer *buffer)
 
 	ion_heap_buffer_zero(buffer);
 
-	if (ion_buffer_cached(buffer))
-		dma_sync_sg_for_device(NULL, table->sgl, table->nents,
-				       DMA_BIDIRECTIONAL);
-
 	ion_carveout_free(heap, paddr, buffer->size);
 	sg_free_table(table);
 	kfree(table);
@@ -132,8 +124,6 @@ struct ion_heap *ion_carveout_heap_create(struct ion_platform_heap *heap_data)
 	page = pfn_to_page(PFN_DOWN(heap_data->base));
 	size = heap_data->size;
 
-	ion_pages_sync_for_device(NULL, page, size, DMA_BIDIRECTIONAL);
-
 	ret = ion_heap_pages_zero(page, size, pgprot_writecombine(PAGE_KERNEL));
 	if (ret)
 		return ERR_PTR(ret);
diff --git a/drivers/staging/android/ion/ion_chunk_heap.c b/drivers/staging/android/ion/ion_chunk_heap.c
index 70495dc..46e13f6 100644
--- a/drivers/staging/android/ion/ion_chunk_heap.c
+++ b/drivers/staging/android/ion/ion_chunk_heap.c
@@ -35,7 +35,7 @@ struct ion_chunk_heap {
 
 static int ion_chunk_heap_allocate(struct ion_heap *heap,
 				   struct ion_buffer *buffer,
-				   unsigned long size, unsigned long align,
+				   unsigned long size,
 				   unsigned long flags)
 {
 	struct ion_chunk_heap *chunk_heap =
@@ -46,9 +46,6 @@ static int ion_chunk_heap_allocate(struct ion_heap *heap,
 	unsigned long num_chunks;
 	unsigned long allocated_size;
 
-	if (align > chunk_heap->chunk_size)
-		return -EINVAL;
-
 	allocated_size = ALIGN(size, chunk_heap->chunk_size);
 	num_chunks = allocated_size / chunk_heap->chunk_size;
 
@@ -104,10 +101,6 @@ static void ion_chunk_heap_free(struct ion_buffer *buffer)
 
 	ion_heap_buffer_zero(buffer);
 
-	if (ion_buffer_cached(buffer))
-		dma_sync_sg_for_device(NULL, table->sgl, table->nents,
-				       DMA_BIDIRECTIONAL);
-
 	for_each_sg(table->sgl, sg, table->nents, i) {
 		gen_pool_free(chunk_heap->pool, page_to_phys(sg_page(sg)),
 			      sg->length);
@@ -135,8 +128,6 @@ struct ion_heap *ion_chunk_heap_create(struct ion_platform_heap *heap_data)
 	page = pfn_to_page(PFN_DOWN(heap_data->base));
 	size = heap_data->size;
 
-	ion_pages_sync_for_device(NULL, page, size, DMA_BIDIRECTIONAL);
-
 	ret = ion_heap_pages_zero(page, size, pgprot_writecombine(PAGE_KERNEL));
 	if (ret)
 		return ERR_PTR(ret);
@@ -160,8 +151,8 @@ struct ion_heap *ion_chunk_heap_create(struct ion_platform_heap *heap_data)
 	chunk_heap->heap.ops = &chunk_heap_ops;
 	chunk_heap->heap.type = ION_HEAP_TYPE_CHUNK;
 	chunk_heap->heap.flags = ION_HEAP_FLAG_DEFER_FREE;
-	pr_debug("%s: base %lu size %zu align %ld\n", __func__,
-		 chunk_heap->base, heap_data->size, heap_data->align);
+	pr_debug("%s: base %lu size %zu \n", __func__,
+		 chunk_heap->base, heap_data->size);
 
 	return &chunk_heap->heap;
 
diff --git a/drivers/staging/android/ion/ion_cma_heap.c b/drivers/staging/android/ion/ion_cma_heap.c
index 6c7de74..81780ed 100644
--- a/drivers/staging/android/ion/ion_cma_heap.c
+++ b/drivers/staging/android/ion/ion_cma_heap.c
@@ -42,7 +42,7 @@ struct ion_cma_buffer_info {
 
 /* ION CMA heap operations functions */
 static int ion_cma_allocate(struct ion_heap *heap, struct ion_buffer *buffer,
-			    unsigned long len, unsigned long align,
+			    unsigned long len,
 			    unsigned long flags)
 {
 	struct ion_cma_heap *cma_heap = to_cma_heap(heap);
@@ -54,9 +54,6 @@ static int ion_cma_allocate(struct ion_heap *heap, struct ion_buffer *buffer,
 	if (buffer->flags & ION_FLAG_CACHED)
 		return -EINVAL;
 
-	if (align > PAGE_SIZE)
-		return -EINVAL;
-
 	info = kzalloc(sizeof(struct ion_cma_buffer_info), GFP_KERNEL);
 	if (!info)
 		return ION_CMA_ALLOCATE_FAILED;
diff --git a/drivers/staging/android/ion/ion_page_pool.c b/drivers/staging/android/ion/ion_page_pool.c
index aea89c1..532eda7 100644
--- a/drivers/staging/android/ion/ion_page_pool.c
+++ b/drivers/staging/android/ion/ion_page_pool.c
@@ -30,9 +30,6 @@ static void *ion_page_pool_alloc_pages(struct ion_page_pool *pool)
 
 	if (!page)
 		return NULL;
-	if (!pool->cached)
-		ion_pages_sync_for_device(NULL, page, PAGE_SIZE << pool->order,
-					  DMA_BIDIRECTIONAL);
 	return page;
 }
 
diff --git a/drivers/staging/android/ion/ion_priv.h b/drivers/staging/android/ion/ion_priv.h
index 3c3b324..869a948 100644
--- a/drivers/staging/android/ion/ion_priv.h
+++ b/drivers/staging/android/ion/ion_priv.h
@@ -44,7 +44,6 @@
  * @lock:		protects the buffers cnt fields
  * @kmap_cnt:		number of times the buffer is mapped to the kernel
  * @vaddr:		the kernel mapping if kmap_cnt is not zero
- * @dmap_cnt:		number of times the buffer is mapped for dma
  * @sg_table:		the sg table for the buffer if dmap_cnt is not zero
  * @pages:		flat array of pages in the buffer -- used by fault
  *			handler and only valid for buffers that are faulted in
@@ -70,7 +69,6 @@ struct ion_buffer {
 	struct mutex lock;
 	int kmap_cnt;
 	void *vaddr;
-	int dmap_cnt;
 	struct sg_table *sg_table;
 	struct page **pages;
 	struct list_head vmas;
@@ -174,7 +172,7 @@ struct ion_handle {
 struct ion_heap_ops {
 	int (*allocate)(struct ion_heap *heap,
 			struct ion_buffer *buffer, unsigned long len,
-			unsigned long align, unsigned long flags);
+			unsigned long flags);
 	void (*free)(struct ion_buffer *buffer);
 	void * (*map_kernel)(struct ion_heap *heap, struct ion_buffer *buffer);
 	void (*unmap_kernel)(struct ion_heap *heap, struct ion_buffer *buffer);
diff --git a/drivers/staging/android/ion/ion_system_heap.c b/drivers/staging/android/ion/ion_system_heap.c
index 3ebbb75..a33331b 100644
--- a/drivers/staging/android/ion/ion_system_heap.c
+++ b/drivers/staging/android/ion/ion_system_heap.c
@@ -75,9 +75,6 @@ static struct page *alloc_buffer_page(struct ion_system_heap *heap,
 
 	page = ion_page_pool_alloc(pool);
 
-	if (cached)
-		ion_pages_sync_for_device(NULL, page, PAGE_SIZE << order,
-					  DMA_BIDIRECTIONAL);
 	return page;
 }
 
@@ -129,7 +126,7 @@ static struct page *alloc_largest_available(struct ion_system_heap *heap,
 
 static int ion_system_heap_allocate(struct ion_heap *heap,
 				    struct ion_buffer *buffer,
-				    unsigned long size, unsigned long align,
+				    unsigned long size,
 				    unsigned long flags)
 {
 	struct ion_system_heap *sys_heap = container_of(heap,
@@ -143,9 +140,6 @@ static int ion_system_heap_allocate(struct ion_heap *heap,
 	unsigned long size_remaining = PAGE_ALIGN(size);
 	unsigned int max_order = orders[0];
 
-	if (align > PAGE_SIZE)
-		return -EINVAL;
-
 	if (size / PAGE_SIZE > totalram_pages / 2)
 		return -ENOMEM;
 
@@ -372,7 +366,6 @@ void ion_system_heap_destroy(struct ion_heap *heap)
 static int ion_system_contig_heap_allocate(struct ion_heap *heap,
 					   struct ion_buffer *buffer,
 					   unsigned long len,
-					   unsigned long align,
 					   unsigned long flags)
 {
 	int order = get_order(len);
@@ -381,9 +374,6 @@ static int ion_system_contig_heap_allocate(struct ion_heap *heap,
 	unsigned long i;
 	int ret;
 
-	if (align > (PAGE_SIZE << order))
-		return -EINVAL;
-
 	page = alloc_pages(low_order_gfp_flags, order);
 	if (!page)
 		return -ENOMEM;
@@ -408,8 +398,6 @@ static int ion_system_contig_heap_allocate(struct ion_heap *heap,
 
 	buffer->sg_table = table;
 
-	ion_pages_sync_for_device(NULL, page, len, DMA_BIDIRECTIONAL);
-
 	return 0;
 
 free_table:
-- 
2.7.4

