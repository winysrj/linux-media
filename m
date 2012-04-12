Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bk0-f46.google.com ([209.85.214.46]:39343 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757801Ab2DLQgz (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 12 Apr 2012 12:36:55 -0400
From: Federico Vaga <federico.vaga@gmail.com>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
	Alan Cox <alan@linux.intel.com>,
	Giancarlo Asnaghi <giancarlo.asnaghi@st.com>,
	Federico Vaga <federico.vaga@gmail.com>
Subject: [PATCH 2/3] videobuf-dma-contig: add cache support
Date: Thu, 12 Apr 2012 18:39:37 +0200
Message-Id: <1334248778-16625-2-git-send-email-federico.vaga@gmail.com>
In-Reply-To: <1334248778-16625-1-git-send-email-federico.vaga@gmail.com>
References: <1334248778-16625-1-git-send-email-federico.vaga@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Federico Vaga <federico.vaga@gmail.com>
Acked-by: Giancarlo Asnaghi <giancarlo.asnaghi@st.com>
Cc: Alan Cox <alan@linux.intel.com>
---
 drivers/media/video/videobuf-dma-contig.c |  199 +++++++++++++++++++++-------
 include/media/videobuf-dma-contig.h       |   10 ++
 2 files changed, 159 insertions(+), 50 deletions(-)

diff --git a/drivers/media/video/videobuf-dma-contig.c b/drivers/media/video/videobuf-dma-contig.c
index c969111..b6b5cc1 100644
--- a/drivers/media/video/videobuf-dma-contig.c
+++ b/drivers/media/video/videobuf-dma-contig.c
@@ -27,6 +27,7 @@ struct videobuf_dma_contig_memory {
 	u32 magic;
 	void *vaddr;
 	dma_addr_t dma_handle;
+	bool cached;
 	unsigned long size;
 };
 
@@ -37,8 +38,58 @@ struct videobuf_dma_contig_memory {
 		BUG();							    \
 	}
 
-static void
-videobuf_vm_open(struct vm_area_struct *vma)
+static int __videobuf_dc_alloc(struct device *dev,
+			       struct videobuf_dma_contig_memory *mem,
+			       unsigned long size, unsigned long flags)
+{
+	mem->size = size;
+	if (mem->cached) {
+		mem->vaddr = alloc_pages_exact(mem->size, flags | GFP_DMA);
+		if (mem->vaddr) {
+			int err;
+
+			mem->dma_handle = dma_map_single(dev, mem->vaddr,
+							 mem->size,
+							 DMA_FROM_DEVICE);
+			err = dma_mapping_error(dev, mem->dma_handle);
+			if (err) {
+				dev_err(dev, "dma_map_single failed\n");
+
+				free_pages_exact(mem->vaddr, mem->size);
+				mem->vaddr = 0;
+				return err;
+			}
+		}
+	} else
+		mem->vaddr = dma_alloc_coherent(dev, mem->size,
+						&mem->dma_handle, flags);
+
+	if (!mem->vaddr) {
+		dev_err(dev, "memory alloc size %ld failed\n", mem->size);
+		return -ENOMEM;
+	}
+
+	dev_dbg(dev, "dma mapped data is at %p (%ld)\n", mem->vaddr, mem->size);
+
+	return 0;
+}
+
+static void __videobuf_dc_free(struct device *dev,
+			       struct videobuf_dma_contig_memory *mem)
+{
+	if (mem->cached) {
+		if (!mem->vaddr)
+			return;
+		dma_unmap_single(dev, mem->dma_handle, mem->size,
+				 DMA_FROM_DEVICE);
+		free_pages_exact(mem->vaddr, mem->size);
+	} else
+		dma_free_coherent(dev, mem->size, mem->vaddr, mem->dma_handle);
+
+	mem->vaddr = NULL;
+}
+
+static void videobuf_vm_open(struct vm_area_struct *vma)
 {
 	struct videobuf_mapping *map = vma->vm_private_data;
 
@@ -91,12 +142,11 @@ static void videobuf_vm_close(struct vm_area_struct *vma)
 				dev_dbg(q->dev, "buf[%d] freeing %p\n",
 					i, mem->vaddr);
 
-				dma_free_coherent(q->dev, mem->size,
-						  mem->vaddr, mem->dma_handle);
+				__videobuf_dc_free(q->dev, mem);
 				mem->vaddr = NULL;
 			}
 
-			q->bufs[i]->map   = NULL;
+			q->bufs[i]->map = NULL;
 			q->bufs[i]->baddr = 0;
 		}
 
@@ -107,8 +157,8 @@ static void videobuf_vm_close(struct vm_area_struct *vma)
 }
 
 static const struct vm_operations_struct videobuf_vm_ops = {
-	.open     = videobuf_vm_open,
-	.close    = videobuf_vm_close,
+	.open	= videobuf_vm_open,
+	.close	= videobuf_vm_close,
 };
 
 /**
@@ -178,26 +228,38 @@ static int videobuf_dma_contig_user_get(struct videobuf_dma_contig_memory *mem,
 		pages_done++;
 	}
 
- out_up:
+out_up:
 	up_read(&current->mm->mmap_sem);
 
 	return ret;
 }
 
-static struct videobuf_buffer *__videobuf_alloc_vb(size_t size)
+static struct videobuf_buffer *__videobuf_alloc_vb(size_t size, bool cached)
 {
 	struct videobuf_dma_contig_memory *mem;
 	struct videobuf_buffer *vb;
 
 	vb = kzalloc(size + sizeof(*mem), GFP_KERNEL);
 	if (vb) {
-		mem = vb->priv = ((char *)vb) + size;
+		vb->priv = ((char *)vb) + size;
+		mem = vb->priv;
 		mem->magic = MAGIC_DC_MEM;
+		mem->cached = cached;
 	}
 
 	return vb;
 }
 
+static struct videobuf_buffer *__videobuf_alloc_uncached(size_t size)
+{
+	return __videobuf_alloc_vb(size, false);
+}
+
+static struct videobuf_buffer *__videobuf_alloc_cached(size_t size)
+{
+	return __videobuf_alloc_vb(size, true);
+}
+
 static void *__videobuf_to_vaddr(struct videobuf_buffer *buf)
 {
 	struct videobuf_dma_contig_memory *mem = buf->priv;
@@ -235,28 +297,32 @@ static int __videobuf_iolock(struct videobuf_queue *q,
 			return videobuf_dma_contig_user_get(mem, vb);
 
 		/* allocate memory for the read() method */
-		mem->size = PAGE_ALIGN(vb->size);
-		mem->vaddr = dma_alloc_coherent(q->dev, mem->size,
-						&mem->dma_handle, GFP_KERNEL);
-		if (!mem->vaddr) {
-			dev_err(q->dev, "dma_alloc_coherent %ld failed\n",
-					 mem->size);
+		if (__videobuf_dc_alloc(q->dev, mem, PAGE_ALIGN(vb->size),
+					GFP_KERNEL))
 			return -ENOMEM;
-		}
-
-		dev_dbg(q->dev, "dma_alloc_coherent data is at %p (%ld)\n",
-			mem->vaddr, mem->size);
 		break;
 	case V4L2_MEMORY_OVERLAY:
 	default:
-		dev_dbg(q->dev, "%s memory method OVERLAY/unknown\n",
-			__func__);
+		dev_dbg(q->dev, "%s memory method OVERLAY/unknown\n", __func__);
 		return -EINVAL;
 	}
 
 	return 0;
 }
 
+static int __videobuf_sync(struct videobuf_queue *q,
+			   struct videobuf_buffer *buf)
+{
+	struct videobuf_dma_contig_memory *mem = buf->priv;
+	BUG_ON(!mem);
+	MAGIC_CHECK(mem->magic, MAGIC_DC_MEM);
+
+	dma_sync_single_for_cpu(q->dev, mem->dma_handle, mem->size,
+				DMA_FROM_DEVICE);
+
+	return 0;
+}
+
 static int __videobuf_mmap_mapper(struct videobuf_queue *q,
 				  struct videobuf_buffer *buf,
 				  struct vm_area_struct *vma)
@@ -265,6 +331,8 @@ static int __videobuf_mmap_mapper(struct videobuf_queue *q,
 	struct videobuf_mapping *map;
 	int retval;
 	unsigned long size;
+	unsigned long pos, start = vma->vm_start;
+	struct page *page;
 
 	dev_dbg(q->dev, "%s\n", __func__);
 
@@ -282,41 +350,50 @@ static int __videobuf_mmap_mapper(struct videobuf_queue *q,
 	BUG_ON(!mem);
 	MAGIC_CHECK(mem->magic, MAGIC_DC_MEM);
 
-	mem->size = PAGE_ALIGN(buf->bsize);
-	mem->vaddr = dma_alloc_coherent(q->dev, mem->size,
-					&mem->dma_handle, GFP_KERNEL);
-	if (!mem->vaddr) {
-		dev_err(q->dev, "dma_alloc_coherent size %ld failed\n",
-			mem->size);
+	if (__videobuf_dc_alloc(q->dev, mem, PAGE_ALIGN(buf->bsize),
+				GFP_KERNEL | __GFP_COMP))
 		goto error;
-	}
-	dev_dbg(q->dev, "dma_alloc_coherent data is at addr %p (size %ld)\n",
-		mem->vaddr, mem->size);
 
 	/* Try to remap memory */
 
 	size = vma->vm_end - vma->vm_start;
 	size = (size < mem->size) ? size : mem->size;
 
-	vma->vm_page_prot = pgprot_noncached(vma->vm_page_prot);
-	retval = remap_pfn_range(vma, vma->vm_start,
-				 mem->dma_handle >> PAGE_SHIFT,
-				 size, vma->vm_page_prot);
-	if (retval) {
-		dev_err(q->dev, "mmap: remap failed with error %d. ", retval);
-		dma_free_coherent(q->dev, mem->size,
-				  mem->vaddr, mem->dma_handle);
-		goto error;
+	if (!mem->cached)
+		vma->vm_page_prot = pgprot_noncached(vma->vm_page_prot);
+
+	pos = (unsigned long)mem->vaddr;
+
+	while (size > 0) {
+		page = virt_to_page((void *)pos);
+		if (NULL == page) {
+			dev_err(q->dev, "mmap: virt_to_page failed\n");
+			__videobuf_dc_free(q->dev, mem);
+			goto error;
+		}
+		retval = vm_insert_page(vma, start, page);
+		if (retval) {
+			dev_err(q->dev, "mmap: insert failed with error %d\n",
+				retval);
+			__videobuf_dc_free(q->dev, mem);
+			goto error;
+		}
+		start += PAGE_SIZE;
+		pos += PAGE_SIZE;
+
+		if (size > PAGE_SIZE)
+			size -= PAGE_SIZE;
+		else
+			size = 0;
 	}
 
-	vma->vm_ops          = &videobuf_vm_ops;
-	vma->vm_flags       |= VM_DONTEXPAND;
+	vma->vm_ops = &videobuf_vm_ops;
+	vma->vm_flags |= VM_DONTEXPAND;
 	vma->vm_private_data = map;
 
 	dev_dbg(q->dev, "mmap %p: q=%p %08lx-%08lx (%lx) pgoff %08lx buf %d\n",
 		map, q, vma->vm_start, vma->vm_end,
-		(long int)buf->bsize,
-		vma->vm_pgoff, buf->i);
+		(long int)buf->bsize, vma->vm_pgoff, buf->i);
 
 	videobuf_vm_open(vma);
 
@@ -328,12 +405,20 @@ error:
 }
 
 static struct videobuf_qtype_ops qops = {
-	.magic        = MAGIC_QTYPE_OPS,
+	.magic		= MAGIC_QTYPE_OPS,
+	.alloc_vb	= __videobuf_alloc_uncached,
+	.iolock		= __videobuf_iolock,
+	.mmap_mapper	= __videobuf_mmap_mapper,
+	.vaddr		= __videobuf_to_vaddr,
+};
 
-	.alloc_vb     = __videobuf_alloc_vb,
-	.iolock       = __videobuf_iolock,
-	.mmap_mapper  = __videobuf_mmap_mapper,
-	.vaddr        = __videobuf_to_vaddr,
+static struct videobuf_qtype_ops qops_cached = {
+	.magic		= MAGIC_QTYPE_OPS,
+	.alloc_vb	= __videobuf_alloc_cached,
+	.iolock		= __videobuf_iolock,
+	.sync		= __videobuf_sync,
+	.mmap_mapper	= __videobuf_mmap_mapper,
+	.vaddr		= __videobuf_to_vaddr,
 };
 
 void videobuf_queue_dma_contig_init(struct videobuf_queue *q,
@@ -351,6 +436,20 @@ void videobuf_queue_dma_contig_init(struct videobuf_queue *q,
 }
 EXPORT_SYMBOL_GPL(videobuf_queue_dma_contig_init);
 
+void videobuf_queue_dma_contig_init_cached(struct videobuf_queue *q,
+					   const struct videobuf_queue_ops *ops,
+					   struct device *dev,
+					   spinlock_t *irqlock,
+					   enum v4l2_buf_type type,
+					   enum v4l2_field field,
+					   unsigned int msize,
+					   void *priv, struct mutex *ext_lock)
+{
+	videobuf_queue_core_init(q, ops, dev, irqlock, type, field, msize,
+				 priv, &qops_cached, ext_lock);
+}
+EXPORT_SYMBOL_GPL(videobuf_queue_dma_contig_init_cached);
+
 dma_addr_t videobuf_to_dma_contig(struct videobuf_buffer *buf)
 {
 	struct videobuf_dma_contig_memory *mem = buf->priv;
@@ -389,7 +488,7 @@ void videobuf_dma_contig_free(struct videobuf_queue *q,
 
 	/* read() method */
 	if (mem->vaddr) {
-		dma_free_coherent(q->dev, mem->size, mem->vaddr, mem->dma_handle);
+		__videobuf_dc_free(q->dev, mem);
 		mem->vaddr = NULL;
 	}
 }
diff --git a/include/media/videobuf-dma-contig.h b/include/media/videobuf-dma-contig.h
index f0ed825..f473aeb 100644
--- a/include/media/videobuf-dma-contig.h
+++ b/include/media/videobuf-dma-contig.h
@@ -26,6 +26,16 @@ void videobuf_queue_dma_contig_init(struct videobuf_queue *q,
 				    void *priv,
 				    struct mutex *ext_lock);
 
+void videobuf_queue_dma_contig_init_cached(struct videobuf_queue *q,
+					   const struct videobuf_queue_ops *ops,
+					   struct device *dev,
+					   spinlock_t *irqlock,
+					   enum v4l2_buf_type type,
+					   enum v4l2_field field,
+					   unsigned int msize,
+					   void *priv,
+					   struct mutex *ext_lock);
+
 dma_addr_t videobuf_to_dma_contig(struct videobuf_buffer *buf);
 void videobuf_dma_contig_free(struct videobuf_queue *q,
 			      struct videobuf_buffer *buf);
-- 
1.7.7.6

