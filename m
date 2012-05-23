Return-path: <linux-media-owner@vger.kernel.org>
Received: from devils.ext.ti.com ([198.47.26.153]:38986 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750930Ab2EWKJE (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 23 May 2012 06:09:04 -0400
From: Sumit Semwal <sumit.semwal@ti.com>
To: <linux-media@vger.kernel.org>, <dri-devel@lists.freedesktop.org>,
	<linaro-mm-sig@lists.linaro.org>
CC: Sumit Semwal <sumit.semwal@ti.com>
Subject: [PATCH] dma-buf: minor documentation fixes.
Date: Wed, 23 May 2012 15:38:48 +0530
Message-ID: <1337767728-32236-1-git-send-email-sumit.semwal@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Some minor inline documentation fixes for gaps resulting from new patches.

Signed-off-by: Sumit Semwal <sumit.semwal@ti.com>
---
 drivers/base/dma-buf.c  |    9 +++++----
 include/linux/dma-buf.h |    3 +++
 2 files changed, 8 insertions(+), 4 deletions(-)

diff --git a/drivers/base/dma-buf.c b/drivers/base/dma-buf.c
index c3c88b0..24e88fe 100644
--- a/drivers/base/dma-buf.c
+++ b/drivers/base/dma-buf.c
@@ -429,7 +429,7 @@ EXPORT_SYMBOL_GPL(dma_buf_kunmap);
 
 /**
  * dma_buf_mmap - Setup up a userspace mmap with the given vma
- * @dma_buf:	[in]	buffer that should back the vma
+ * @dmabuf:	[in]	buffer that should back the vma
  * @vma:	[in]	vma for the mmap
  * @pgoff:	[in]	offset in pages where this mmap should start within the
  * 			dma-buf buffer.
@@ -470,8 +470,9 @@ int dma_buf_mmap(struct dma_buf *dmabuf, struct vm_area_struct *vma,
 EXPORT_SYMBOL_GPL(dma_buf_mmap);
 
 /**
- * dma_buf_vmap - Create virtual mapping for the buffer object into kernel address space. Same restrictions as for vmap and friends apply.
- * @dma_buf:	[in]	buffer to vmap
+ * dma_buf_vmap - Create virtual mapping for the buffer object into kernel
+ * address space. Same restrictions as for vmap and friends apply.
+ * @dmabuf:	[in]	buffer to vmap
  *
  * This call may fail due to lack of virtual mapping address space.
  * These calls are optional in drivers. The intended use for them
@@ -491,7 +492,7 @@ EXPORT_SYMBOL_GPL(dma_buf_vmap);
 
 /**
  * dma_buf_vunmap - Unmap a vmap obtained by dma_buf_vmap.
- * @dma_buf:	[in]	buffer to vmap
+ * @dmabuf:	[in]	buffer to vunmap
  */
 void dma_buf_vunmap(struct dma_buf *dmabuf, void *vaddr)
 {
diff --git a/include/linux/dma-buf.h b/include/linux/dma-buf.h
index a02b1ff..eb48f38 100644
--- a/include/linux/dma-buf.h
+++ b/include/linux/dma-buf.h
@@ -65,6 +65,9 @@ struct dma_buf_attachment;
  * 	  mapping needs to be coherent - if the exporter doesn't directly
  * 	  support this, it needs to fake coherency by shooting down any ptes
  * 	  when transitioning away from the cpu domain.
+ * @vmap: [optional] creates a virtual mapping for the buffer into kernel
+ *	  address space. Same restrictions as for vmap and friends apply.
+ * @vunmap: [optional] unmaps a vmap from the buffer
  */
 struct dma_buf_ops {
 	int (*attach)(struct dma_buf *, struct device *,
-- 
1.7.9.5

