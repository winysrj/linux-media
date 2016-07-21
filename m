Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud3.xs4all.net ([194.109.24.26]:50081 "EHLO
	lb2-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751906AbcGUMOO (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 21 Jul 2016 08:14:14 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Sakari Ailus <sakari.ailus@linux.intel.com>,
	laurent.pinchart@ideasonboard.com,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCHv2 1/2] vb2: don't return NULL for alloc and get_userptr ops
Date: Thu, 21 Jul 2016 14:14:02 +0200
Message-Id: <1469103243-5296-2-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1469103243-5296-1-git-send-email-hverkuil@xs4all.nl>
References: <1469103243-5296-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Always return an ERR_PTR() instead of NULL.

This makes the behavior of alloc, get_userptr and attach_dmabuf the
same.

Update the documentation in videobuf2-core.h as well.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/v4l2-core/videobuf2-core.c    | 12 ++++++++----
 drivers/media/v4l2-core/videobuf2-dma-sg.c  | 13 +++++++------
 drivers/media/v4l2-core/videobuf2-vmalloc.c | 13 ++++++++-----
 include/media/videobuf2-core.h              |  6 +++---
 4 files changed, 26 insertions(+), 18 deletions(-)

diff --git a/drivers/media/v4l2-core/videobuf2-core.c b/drivers/media/v4l2-core/videobuf2-core.c
index ca8ffeb..4d60bdb 100644
--- a/drivers/media/v4l2-core/videobuf2-core.c
+++ b/drivers/media/v4l2-core/videobuf2-core.c
@@ -198,6 +198,7 @@ static int __vb2_buf_mem_alloc(struct vb2_buffer *vb)
 		q->is_output ? DMA_TO_DEVICE : DMA_FROM_DEVICE;
 	void *mem_priv;
 	int plane;
+	int ret = -ENOMEM;
 
 	/*
 	 * Allocate memory for all planes in this buffer
@@ -209,8 +210,11 @@ static int __vb2_buf_mem_alloc(struct vb2_buffer *vb)
 		mem_priv = call_ptr_memop(vb, alloc,
 				q->alloc_devs[plane] ? : q->dev,
 				q->dma_attrs, size, dma_dir, q->gfp_flags);
-		if (IS_ERR_OR_NULL(mem_priv))
+		if (IS_ERR(mem_priv)) {
+			if (mem_priv)
+				ret = PTR_ERR(mem_priv);
 			goto free;
+		}
 
 		/* Associate allocator private data with this plane */
 		vb->planes[plane].mem_priv = mem_priv;
@@ -224,7 +228,7 @@ free:
 		vb->planes[plane - 1].mem_priv = NULL;
 	}
 
-	return -ENOMEM;
+	return ret;
 }
 
 /**
@@ -1136,10 +1140,10 @@ static int __qbuf_userptr(struct vb2_buffer *vb, const void *pb)
 				q->alloc_devs[plane] ? : q->dev,
 				planes[plane].m.userptr,
 				planes[plane].length, dma_dir);
-		if (IS_ERR_OR_NULL(mem_priv)) {
+		if (IS_ERR(mem_priv)) {
 			dprintk(1, "failed acquiring userspace "
 						"memory for plane %d\n", plane);
-			ret = mem_priv ? PTR_ERR(mem_priv) : -EINVAL;
+			ret = PTR_ERR(mem_priv);
 			goto err;
 		}
 		vb->planes[plane].mem_priv = mem_priv;
diff --git a/drivers/media/v4l2-core/videobuf2-dma-sg.c b/drivers/media/v4l2-core/videobuf2-dma-sg.c
index a39db8a..e2afd2c 100644
--- a/drivers/media/v4l2-core/videobuf2-dma-sg.c
+++ b/drivers/media/v4l2-core/videobuf2-dma-sg.c
@@ -107,11 +107,12 @@ static void *vb2_dma_sg_alloc(struct device *dev, const struct dma_attrs *dma_at
 
 	dma_set_attr(DMA_ATTR_SKIP_CPU_SYNC, &attrs);
 
-	if (WARN_ON(dev == NULL))
-		return NULL;
+	if (WARN_ON(!dev))
+		return ERR_PTR(-EINVAL);
+
 	buf = kzalloc(sizeof *buf, GFP_KERNEL);
 	if (!buf)
-		return NULL;
+		return ERR_PTR(-ENOMEM);
 
 	buf->vaddr = NULL;
 	buf->dma_dir = dma_dir;
@@ -169,7 +170,7 @@ fail_pages_alloc:
 	kfree(buf->pages);
 fail_pages_array_alloc:
 	kfree(buf);
-	return NULL;
+	return ERR_PTR(-ENOMEM);
 }
 
 static void vb2_dma_sg_put(void *buf_priv)
@@ -234,7 +235,7 @@ static void *vb2_dma_sg_get_userptr(struct device *dev, unsigned long vaddr,
 	dma_set_attr(DMA_ATTR_SKIP_CPU_SYNC, &attrs);
 	buf = kzalloc(sizeof *buf, GFP_KERNEL);
 	if (!buf)
-		return NULL;
+		return ERR_PTR(-ENOMEM);
 
 	buf->vaddr = NULL;
 	buf->dev = dev;
@@ -274,7 +275,7 @@ userptr_fail_sgtable:
 	vb2_destroy_framevec(vec);
 userptr_fail_pfnvec:
 	kfree(buf);
-	return NULL;
+	return ERR_PTR(-ENOMEM);
 }
 
 /*
diff --git a/drivers/media/v4l2-core/videobuf2-vmalloc.c b/drivers/media/v4l2-core/videobuf2-vmalloc.c
index 7e8a07e..4fdfefd 100644
--- a/drivers/media/v4l2-core/videobuf2-vmalloc.c
+++ b/drivers/media/v4l2-core/videobuf2-vmalloc.c
@@ -41,7 +41,7 @@ static void *vb2_vmalloc_alloc(struct device *dev, const struct dma_attrs *attrs
 
 	buf = kzalloc(sizeof(*buf), GFP_KERNEL | gfp_flags);
 	if (!buf)
-		return NULL;
+		return ERR_PTR(-ENOMEM);
 
 	buf->size = size;
 	buf->vaddr = vmalloc_user(buf->size);
@@ -53,7 +53,7 @@ static void *vb2_vmalloc_alloc(struct device *dev, const struct dma_attrs *attrs
 	if (!buf->vaddr) {
 		pr_debug("vmalloc of size %ld failed\n", buf->size);
 		kfree(buf);
-		return NULL;
+		return ERR_PTR(-ENOMEM);
 	}
 
 	atomic_inc(&buf->refcount);
@@ -77,17 +77,20 @@ static void *vb2_vmalloc_get_userptr(struct device *dev, unsigned long vaddr,
 	struct vb2_vmalloc_buf *buf;
 	struct frame_vector *vec;
 	int n_pages, offset, i;
+	int ret = -ENOMEM;
 
 	buf = kzalloc(sizeof(*buf), GFP_KERNEL);
 	if (!buf)
-		return NULL;
+		return ERR_PTR(-ENOMEM);
 
 	buf->dma_dir = dma_dir;
 	offset = vaddr & ~PAGE_MASK;
 	buf->size = size;
 	vec = vb2_create_framevec(vaddr, size, dma_dir == DMA_FROM_DEVICE);
-	if (IS_ERR(vec))
+	if (IS_ERR(vec)) {
+		ret = PTR_ERR(vec);
 		goto fail_pfnvec_create;
+	}
 	buf->vec = vec;
 	n_pages = frame_vector_count(vec);
 	if (frame_vector_to_pages(vec) < 0) {
@@ -117,7 +120,7 @@ fail_map:
 fail_pfnvec_create:
 	kfree(buf);
 
-	return NULL;
+	return ERR_PTR(ret);
 }
 
 static void vb2_vmalloc_put_userptr(void *buf_priv)
diff --git a/include/media/videobuf2-core.h b/include/media/videobuf2-core.h
index bea81c9e..b4e8826 100644
--- a/include/media/videobuf2-core.h
+++ b/include/media/videobuf2-core.h
@@ -33,7 +33,7 @@ struct vb2_threadio_data;
 /**
  * struct vb2_mem_ops - memory handling/memory allocator operations
  * @alloc:	allocate video memory and, optionally, allocator private data,
- *		return NULL on failure or a pointer to allocator private,
+ *		return ERR_PTR() on failure or a pointer to allocator private,
  *		per-buffer data on success; the returned private structure
  *		will then be passed as buf_priv argument to other ops in this
  *		structure. Additional gfp_flags to use when allocating the
@@ -50,14 +50,14 @@ struct vb2_threadio_data;
  *		 USERPTR memory types; vaddr is the address passed to the
  *		 videobuf layer when queuing a video buffer of USERPTR type;
  *		 should return an allocator private per-buffer structure
- *		 associated with the buffer on success, NULL on failure;
+ *		 associated with the buffer on success, ERR_PTR() on failure;
  *		 the returned private structure will then be passed as buf_priv
  *		 argument to other ops in this structure.
  * @put_userptr: inform the allocator that a USERPTR buffer will no longer
  *		 be used.
  * @attach_dmabuf: attach a shared struct dma_buf for a hardware operation;
  *		   used for DMABUF memory types; dev is the alloc device
- *		   dbuf is the shared dma_buf; returns NULL on failure;
+ *		   dbuf is the shared dma_buf; returns ERR_PTR() on failure;
  *		   allocator private per-buffer structure on success;
  *		   this needs to be used for further accesses to the buffer.
  * @detach_dmabuf: inform the exporter of the buffer that the current DMABUF
-- 
2.8.1

