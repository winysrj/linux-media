Return-path: <linux-media-owner@vger.kernel.org>
Received: from hqemgate04.nvidia.com ([216.228.121.35]:12084 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752426Ab2JJP5I (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 10 Oct 2012 11:57:08 -0400
From: Robert Morell <rmorell@nvidia.com>
To: Sumit Semwal <sumit.semwal@linaro.org>
CC: <rob@ti.com>, <linux-media@vger.kernel.org>,
	<dri-devel@lists.freedesktop.org>,
	<linaro-mm-sig@lists.linaro.org>,
	Robert Morell <rmorell@nvidia.com>
Subject: [PATCH] dma-buf: Use EXPORT_SYMBOL
Date: Wed, 10 Oct 2012 08:56:32 -0700
Message-ID: <1349884592-32485-1-git-send-email-rmorell@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

EXPORT_SYMBOL_GPL is intended to be used for "an internal implementation
issue, and not really an interface".  The dma-buf infrastructure is
explicitly intended as an interface between modules/drivers, so it
should use EXPORT_SYMBOL instead.

Signed-off-by: Robert Morell <rmorell@nvidia.com>
---
This patch is based on Linus's master branch.

We held a discussion at ELC, and agreed that EXPORT_SYMBOL is more appropriate
for this interface than EXPORT_SYMBOL_GPL.

 drivers/base/dma-buf.c |   34 +++++++++++++++++-----------------
 1 files changed, 17 insertions(+), 17 deletions(-)

diff --git a/drivers/base/dma-buf.c b/drivers/base/dma-buf.c
index 460e22d..24c28be 100644
--- a/drivers/base/dma-buf.c
+++ b/drivers/base/dma-buf.c
@@ -122,7 +122,7 @@ struct dma_buf *dma_buf_export(void *priv, const struct dma_buf_ops *ops,
 
 	return dmabuf;
 }
-EXPORT_SYMBOL_GPL(dma_buf_export);
+EXPORT_SYMBOL(dma_buf_export);
 
 
 /**
@@ -148,7 +148,7 @@ int dma_buf_fd(struct dma_buf *dmabuf, int flags)
 
 	return fd;
 }
-EXPORT_SYMBOL_GPL(dma_buf_fd);
+EXPORT_SYMBOL(dma_buf_fd);
 
 /**
  * dma_buf_get - returns the dma_buf structure related to an fd
@@ -174,7 +174,7 @@ struct dma_buf *dma_buf_get(int fd)
 
 	return file->private_data;
 }
-EXPORT_SYMBOL_GPL(dma_buf_get);
+EXPORT_SYMBOL(dma_buf_get);
 
 /**
  * dma_buf_put - decreases refcount of the buffer
@@ -189,7 +189,7 @@ void dma_buf_put(struct dma_buf *dmabuf)
 
 	fput(dmabuf->file);
 }
-EXPORT_SYMBOL_GPL(dma_buf_put);
+EXPORT_SYMBOL(dma_buf_put);
 
 /**
  * dma_buf_attach - Add the device to dma_buf's attachments list; optionally,
@@ -234,7 +234,7 @@ err_attach:
 	mutex_unlock(&dmabuf->lock);
 	return ERR_PTR(ret);
 }
-EXPORT_SYMBOL_GPL(dma_buf_attach);
+EXPORT_SYMBOL(dma_buf_attach);
 
 /**
  * dma_buf_detach - Remove the given attachment from dmabuf's attachments list;
@@ -256,7 +256,7 @@ void dma_buf_detach(struct dma_buf *dmabuf, struct dma_buf_attachment *attach)
 	mutex_unlock(&dmabuf->lock);
 	kfree(attach);
 }
-EXPORT_SYMBOL_GPL(dma_buf_detach);
+EXPORT_SYMBOL(dma_buf_detach);
 
 /**
  * dma_buf_map_attachment - Returns the scatterlist table of the attachment;
@@ -283,7 +283,7 @@ struct sg_table *dma_buf_map_attachment(struct dma_buf_attachment *attach,
 
 	return sg_table;
 }
-EXPORT_SYMBOL_GPL(dma_buf_map_attachment);
+EXPORT_SYMBOL(dma_buf_map_attachment);
 
 /**
  * dma_buf_unmap_attachment - unmaps and decreases usecount of the buffer;might
@@ -304,7 +304,7 @@ void dma_buf_unmap_attachment(struct dma_buf_attachment *attach,
 	attach->dmabuf->ops->unmap_dma_buf(attach, sg_table,
 						direction);
 }
-EXPORT_SYMBOL_GPL(dma_buf_unmap_attachment);
+EXPORT_SYMBOL(dma_buf_unmap_attachment);
 
 
 /**
@@ -332,7 +332,7 @@ int dma_buf_begin_cpu_access(struct dma_buf *dmabuf, size_t start, size_t len,
 
 	return ret;
 }
-EXPORT_SYMBOL_GPL(dma_buf_begin_cpu_access);
+EXPORT_SYMBOL(dma_buf_begin_cpu_access);
 
 /**
  * dma_buf_end_cpu_access - Must be called after accessing a dma_buf from the
@@ -354,7 +354,7 @@ void dma_buf_end_cpu_access(struct dma_buf *dmabuf, size_t start, size_t len,
 	if (dmabuf->ops->end_cpu_access)
 		dmabuf->ops->end_cpu_access(dmabuf, start, len, direction);
 }
-EXPORT_SYMBOL_GPL(dma_buf_end_cpu_access);
+EXPORT_SYMBOL(dma_buf_end_cpu_access);
 
 /**
  * dma_buf_kmap_atomic - Map a page of the buffer object into kernel address
@@ -371,7 +371,7 @@ void *dma_buf_kmap_atomic(struct dma_buf *dmabuf, unsigned long page_num)
 
 	return dmabuf->ops->kmap_atomic(dmabuf, page_num);
 }
-EXPORT_SYMBOL_GPL(dma_buf_kmap_atomic);
+EXPORT_SYMBOL(dma_buf_kmap_atomic);
 
 /**
  * dma_buf_kunmap_atomic - Unmap a page obtained by dma_buf_kmap_atomic.
@@ -389,7 +389,7 @@ void dma_buf_kunmap_atomic(struct dma_buf *dmabuf, unsigned long page_num,
 	if (dmabuf->ops->kunmap_atomic)
 		dmabuf->ops->kunmap_atomic(dmabuf, page_num, vaddr);
 }
-EXPORT_SYMBOL_GPL(dma_buf_kunmap_atomic);
+EXPORT_SYMBOL(dma_buf_kunmap_atomic);
 
 /**
  * dma_buf_kmap - Map a page of the buffer object into kernel address space. The
@@ -406,7 +406,7 @@ void *dma_buf_kmap(struct dma_buf *dmabuf, unsigned long page_num)
 
 	return dmabuf->ops->kmap(dmabuf, page_num);
 }
-EXPORT_SYMBOL_GPL(dma_buf_kmap);
+EXPORT_SYMBOL(dma_buf_kmap);
 
 /**
  * dma_buf_kunmap - Unmap a page obtained by dma_buf_kmap.
@@ -424,7 +424,7 @@ void dma_buf_kunmap(struct dma_buf *dmabuf, unsigned long page_num,
 	if (dmabuf->ops->kunmap)
 		dmabuf->ops->kunmap(dmabuf, page_num, vaddr);
 }
-EXPORT_SYMBOL_GPL(dma_buf_kunmap);
+EXPORT_SYMBOL(dma_buf_kunmap);
 
 
 /**
@@ -466,7 +466,7 @@ int dma_buf_mmap(struct dma_buf *dmabuf, struct vm_area_struct *vma,
 
 	return dmabuf->ops->mmap(dmabuf, vma);
 }
-EXPORT_SYMBOL_GPL(dma_buf_mmap);
+EXPORT_SYMBOL(dma_buf_mmap);
 
 /**
  * dma_buf_vmap - Create virtual mapping for the buffer object into kernel
@@ -487,7 +487,7 @@ void *dma_buf_vmap(struct dma_buf *dmabuf)
 		return dmabuf->ops->vmap(dmabuf);
 	return NULL;
 }
-EXPORT_SYMBOL_GPL(dma_buf_vmap);
+EXPORT_SYMBOL(dma_buf_vmap);
 
 /**
  * dma_buf_vunmap - Unmap a vmap obtained by dma_buf_vmap.
@@ -502,4 +502,4 @@ void dma_buf_vunmap(struct dma_buf *dmabuf, void *vaddr)
 	if (dmabuf->ops->vunmap)
 		dmabuf->ops->vunmap(dmabuf, vaddr);
 }
-EXPORT_SYMBOL_GPL(dma_buf_vunmap);
+EXPORT_SYMBOL(dma_buf_vunmap);
-- 
1.7.8.6

