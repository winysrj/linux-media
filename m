Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud6.xs4all.net ([194.109.24.31]:47804 "EHLO
	lb3-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751028AbcGUJTQ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 21 Jul 2016 05:19:16 -0400
To: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>,
	Sakari Ailus <sakari.ailus@iki.fi>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH] vb2: check for NULL device pointer
Message-ID: <8a2effdb-355f-de34-b4c7-7c9eaa3c7873@xs4all.nl>
Date: Thu, 21 Jul 2016 11:19:11 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Check whether the struct device pointer is NULL and return -EINVAL in that
case.

This also required a small change to vb2-core where it didn't call PTR_ERR to
get the real error code.

I have seen several new driver submissions that forgot to set the vb2_queue
dev field, so add these checks to prevent this from happening again.

The dev field is passed on to the dma-contig/sg drivers in the alloc, get_userptr
and attach_dmabuf callbacks, so this check has to be done in those three places.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
diff --git a/drivers/media/v4l2-core/videobuf2-core.c b/drivers/media/v4l2-core/videobuf2-core.c
index ca8ffeb..6470819 100644
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
+		if (IS_ERR_OR_NULL(mem_priv)) {
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
diff --git a/drivers/media/v4l2-core/videobuf2-dma-contig.c b/drivers/media/v4l2-core/videobuf2-dma-contig.c
index 863f658..22b34cf 100644
--- a/drivers/media/v4l2-core/videobuf2-dma-contig.c
+++ b/drivers/media/v4l2-core/videobuf2-dma-contig.c
@@ -141,6 +141,11 @@ static void *vb2_dc_alloc(struct device *dev, const struct dma_attrs *attrs,
 {
 	struct vb2_dc_buf *buf;

+	if (WARN_ON(!dev)) {
+		pr_debug("dev is NULL\n");
+		return ERR_PTR(-EINVAL);
+	}
+
 	buf = kzalloc(sizeof *buf, GFP_KERNEL);
 	if (!buf)
 		return ERR_PTR(-ENOMEM);
@@ -499,6 +504,11 @@ static void *vb2_dc_get_userptr(struct device *dev, unsigned long vaddr,
 		return ERR_PTR(-EINVAL);
 	}

+	if (WARN_ON(!dev)) {
+		pr_debug("dev is NULL\n");
+		return ERR_PTR(-EINVAL);
+	}
+
 	buf = kzalloc(sizeof *buf, GFP_KERNEL);
 	if (!buf)
 		return ERR_PTR(-ENOMEM);
@@ -679,6 +689,11 @@ static void *vb2_dc_attach_dmabuf(struct device *dev, struct dma_buf *dbuf,
 	if (dbuf->size < size)
 		return ERR_PTR(-EFAULT);

+	if (WARN_ON(!dev)) {
+		pr_debug("dev is NULL\n");
+		return ERR_PTR(-EINVAL);
+	}
+
 	buf = kzalloc(sizeof(*buf), GFP_KERNEL);
 	if (!buf)
 		return ERR_PTR(-ENOMEM);
diff --git a/drivers/media/v4l2-core/videobuf2-dma-sg.c b/drivers/media/v4l2-core/videobuf2-dma-sg.c
index a39db8a..3766942 100644
--- a/drivers/media/v4l2-core/videobuf2-dma-sg.c
+++ b/drivers/media/v4l2-core/videobuf2-dma-sg.c
@@ -107,11 +107,14 @@ static void *vb2_dma_sg_alloc(struct device *dev, const struct dma_attrs *dma_at

 	dma_set_attr(DMA_ATTR_SKIP_CPU_SYNC, &attrs);

-	if (WARN_ON(dev == NULL))
-		return NULL;
+	if (WARN_ON(!dev)) {
+		pr_debug("dev is NULL\n");
+		return ERR_PTR(-EINVAL);
+	}
+
 	buf = kzalloc(sizeof *buf, GFP_KERNEL);
 	if (!buf)
-		return NULL;
+		return ERR_PTR(-ENOMEM);

 	buf->vaddr = NULL;
 	buf->dma_dir = dma_dir;
@@ -169,7 +172,7 @@ fail_pages_alloc:
 	kfree(buf->pages);
 fail_pages_array_alloc:
 	kfree(buf);
-	return NULL;
+	return ERR_PTR(-ENOMEM);
 }

 static void vb2_dma_sg_put(void *buf_priv)
@@ -231,10 +234,15 @@ static void *vb2_dma_sg_get_userptr(struct device *dev, unsigned long vaddr,
 	DEFINE_DMA_ATTRS(attrs);
 	struct frame_vector *vec;

+	if (WARN_ON(!dev)) {
+		pr_debug("dev is NULL\n");
+		return ERR_PTR(-EINVAL);
+	}
+
 	dma_set_attr(DMA_ATTR_SKIP_CPU_SYNC, &attrs);
 	buf = kzalloc(sizeof *buf, GFP_KERNEL);
 	if (!buf)
-		return NULL;
+		return ERR_PTR(-ENOMEM);

 	buf->vaddr = NULL;
 	buf->dev = dev;
@@ -274,7 +282,7 @@ userptr_fail_sgtable:
 	vb2_destroy_framevec(vec);
 userptr_fail_pfnvec:
 	kfree(buf);
-	return NULL;
+	return ERR_PTR(-ENOMEM);
 }

 /*
@@ -617,6 +625,11 @@ static void *vb2_dma_sg_attach_dmabuf(struct device *dev, struct dma_buf *dbuf,
 	struct vb2_dma_sg_buf *buf;
 	struct dma_buf_attachment *dba;

+	if (WARN_ON(!dev)) {
+		pr_debug("dev is NULL\n");
+		return ERR_PTR(-EINVAL);
+	}
+
 	if (dbuf->size < size)
 		return ERR_PTR(-EFAULT);

