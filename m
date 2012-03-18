Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f178.google.com ([209.85.212.178]:48573 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756811Ab2CRXU2 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 18 Mar 2012 19:20:28 -0400
Received: by wibhq7 with SMTP id hq7so3127344wib.1
        for <linux-media@vger.kernel.org>; Sun, 18 Mar 2012 16:20:26 -0700 (PDT)
From: Daniel Vetter <daniel.vetter@ffwll.ch>
To: linaro-mm-sig@lists.linaro.org,
	LKML <linux-kernel@vger.kernel.org>,
	DRI Development <dri-devel@lists.freedesktop.org>,
	linux-media@vger.kernel.org
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>
Subject: [PATCH 2/4] dma-buf: add support for kernel cpu access
Date: Mon, 19 Mar 2012 00:34:26 +0100
Message-Id: <1332113668-4364-2-git-send-email-daniel.vetter@ffwll.ch>
In-Reply-To: <1332113668-4364-1-git-send-email-daniel.vetter@ffwll.ch>
References: <1332113668-4364-1-git-send-email-daniel.vetter@ffwll.ch>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Big differences to other contenders in the field (like ion) is
that this also supports highmem, so we have to split up the cpu
access from the kernel side into a prepare and a kmap step.

Prepare is allowed to fail and should do everything required so that
the kmap calls can succeed (like swapin/backing storage allocation,
flushing, ...).

More in-depth explanations will follow in the follow-up documentation
patch.

Changes in v2:

- Clear up begin_cpu_access confusion noticed by Sumit Semwal.
- Don't automatically fallback from the _atomic variants to the
  non-atomic variants. The _atomic callbacks are not allowed to
  sleep, so we want exporters to make this decision explicit. The
  function signatures are explicit, so simpler exporters can still
  use the same function for both.
- Make the unmap functions optional. Simpler exporters with permanent
  mappings don't need to do anything at unmap time.

Changes in v3:

- Adjust the WARN_ON checks for the new ->ops functions as suggested
  by Rob Clark and Sumit Semwal.
- Rebased on top of latest dma-buf-next git.

Signed-Off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
---
 drivers/base/dma-buf.c  |  124 ++++++++++++++++++++++++++++++++++++++++++++++-
 include/linux/dma-buf.h |   59 ++++++++++++++++++++++
 2 files changed, 182 insertions(+), 1 deletions(-)

diff --git a/drivers/base/dma-buf.c b/drivers/base/dma-buf.c
index 5641b9c..2226511 100644
--- a/drivers/base/dma-buf.c
+++ b/drivers/base/dma-buf.c
@@ -80,7 +80,9 @@ struct dma_buf *dma_buf_export(void *priv, const struct dma_buf_ops *ops,
 	if (WARN_ON(!priv || !ops
 			  || !ops->map_dma_buf
 			  || !ops->unmap_dma_buf
-			  || !ops->release)) {
+			  || !ops->release
+			  || !ops->kmap_atomic
+			  || !ops->kmap)) {
 		return ERR_PTR(-EINVAL);
 	}
 
@@ -284,3 +286,123 @@ void dma_buf_unmap_attachment(struct dma_buf_attachment *attach,
 						direction);
 }
 EXPORT_SYMBOL_GPL(dma_buf_unmap_attachment);
+
+
+/**
+ * dma_buf_begin_cpu_access - Must be called before accessing a dma_buf from the
+ * cpu in the kernel context. Calls begin_cpu_access to allow exporter-specific
+ * preparations. Coherency is only guaranteed in the specified range for the
+ * specified access direction.
+ * @dma_buf:	[in]	buffer to prepare cpu access for.
+ * @start:	[in]	start of range for cpu access.
+ * @len:	[in]	length of range for cpu access.
+ * @direction:	[in]	length of range for cpu access.
+ *
+ * Can return negative error values, returns 0 on success.
+ */
+int dma_buf_begin_cpu_access(struct dma_buf *dmabuf, size_t start, size_t len,
+			     enum dma_data_direction direction)
+{
+	int ret = 0;
+
+	if (WARN_ON(!dmabuf))
+		return EINVAL;
+
+	if (dmabuf->ops->begin_cpu_access)
+		ret = dmabuf->ops->begin_cpu_access(dmabuf, start, len, direction);
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(dma_buf_begin_cpu_access);
+
+/**
+ * dma_buf_end_cpu_access - Must be called after accessing a dma_buf from the
+ * cpu in the kernel context. Calls end_cpu_access to allow exporter-specific
+ * actions. Coherency is only guaranteed in the specified range for the
+ * specified access direction.
+ * @dma_buf:	[in]	buffer to complete cpu access for.
+ * @start:	[in]	start of range for cpu access.
+ * @len:	[in]	length of range for cpu access.
+ * @direction:	[in]	length of range for cpu access.
+ *
+ * This call must always succeed.
+ */
+void dma_buf_end_cpu_access(struct dma_buf *dmabuf, size_t start, size_t len,
+			    enum dma_data_direction direction)
+{
+	WARN_ON(!dmabuf);
+
+	if (dmabuf->ops->end_cpu_access)
+		dmabuf->ops->end_cpu_access(dmabuf, start, len, direction);
+}
+EXPORT_SYMBOL_GPL(dma_buf_end_cpu_access);
+
+/**
+ * dma_buf_kmap_atomic - Map a page of the buffer object into kernel address
+ * space. The same restrictions as for kmap_atomic and friends apply.
+ * @dma_buf:	[in]	buffer to map page from.
+ * @page_num:	[in]	page in PAGE_SIZE units to map.
+ *
+ * This call must always succeed, any necessary preparations that might fail
+ * need to be done in begin_cpu_access.
+ */
+void *dma_buf_kmap_atomic(struct dma_buf *dmabuf, unsigned long page_num)
+{
+	WARN_ON(!dmabuf);
+
+	return dmabuf->ops->kmap_atomic(dmabuf, page_num);
+}
+EXPORT_SYMBOL_GPL(dma_buf_kmap_atomic);
+
+/**
+ * dma_buf_kunmap_atomic - Unmap a page obtained by dma_buf_kmap_atomic.
+ * @dma_buf:	[in]	buffer to unmap page from.
+ * @page_num:	[in]	page in PAGE_SIZE units to unmap.
+ * @vaddr:	[in]	kernel space pointer obtained from dma_buf_kmap_atomic.
+ *
+ * This call must always succeed.
+ */
+void dma_buf_kunmap_atomic(struct dma_buf *dmabuf, unsigned long page_num,
+			   void *vaddr)
+{
+	WARN_ON(!dmabuf);
+
+	if (dmabuf->ops->kunmap_atomic)
+		dmabuf->ops->kunmap_atomic(dmabuf, page_num, vaddr);
+}
+EXPORT_SYMBOL_GPL(dma_buf_kunmap_atomic);
+
+/**
+ * dma_buf_kmap - Map a page of the buffer object into kernel address space. The
+ * same restrictions as for kmap and friends apply.
+ * @dma_buf:	[in]	buffer to map page from.
+ * @page_num:	[in]	page in PAGE_SIZE units to map.
+ *
+ * This call must always succeed, any necessary preparations that might fail
+ * need to be done in begin_cpu_access.
+ */
+void *dma_buf_kmap(struct dma_buf *dmabuf, unsigned long page_num)
+{
+	WARN_ON(!dmabuf);
+
+	return dmabuf->ops->kmap(dmabuf, page_num);
+}
+EXPORT_SYMBOL_GPL(dma_buf_kmap);
+
+/**
+ * dma_buf_kunmap - Unmap a page obtained by dma_buf_kmap.
+ * @dma_buf:	[in]	buffer to unmap page from.
+ * @page_num:	[in]	page in PAGE_SIZE units to unmap.
+ * @vaddr:	[in]	kernel space pointer obtained from dma_buf_kmap.
+ *
+ * This call must always succeed.
+ */
+void dma_buf_kunmap(struct dma_buf *dmabuf, unsigned long page_num,
+		    void *vaddr)
+{
+	WARN_ON(!dmabuf);
+
+	if (dmabuf->ops->kunmap)
+		dmabuf->ops->kunmap(dmabuf, page_num, vaddr);
+}
+EXPORT_SYMBOL_GPL(dma_buf_kunmap);
diff --git a/include/linux/dma-buf.h b/include/linux/dma-buf.h
index 24e0f48..ee7ef99 100644
--- a/include/linux/dma-buf.h
+++ b/include/linux/dma-buf.h
@@ -50,6 +50,17 @@ struct dma_buf_attachment;
  * @unmap_dma_buf: decreases usecount of buffer, might deallocate scatter
  *		   pages.
  * @release: release this buffer; to be called after the last dma_buf_put.
+ * @begin_cpu_access: [optional] called before cpu access to invalidate cpu
+ * 		      caches and allocate backing storage (if not yet done)
+ * 		      respectively pin the objet into memory.
+ * @end_cpu_access: [optional] called after cpu access to flush cashes.
+ * @kmap_atomic: maps a page from the buffer into kernel address
+ * 		 space, users may not block until the subsequent unmap call.
+ * 		 This callback must not sleep.
+ * @kunmap_atomic: [optional] unmaps a atomically mapped page from the buffer.
+ * 		   This Callback must not sleep.
+ * @kmap: maps a page from the buffer into kernel address space.
+ * @kunmap: [optional] unmaps a page from the buffer.
  */
 struct dma_buf_ops {
 	int (*attach)(struct dma_buf *, struct device *,
@@ -73,6 +84,14 @@ struct dma_buf_ops {
 	/* after final dma_buf_put() */
 	void (*release)(struct dma_buf *);
 
+	int (*begin_cpu_access)(struct dma_buf *, size_t, size_t,
+				enum dma_data_direction);
+	void (*end_cpu_access)(struct dma_buf *, size_t, size_t,
+			       enum dma_data_direction);
+	void *(*kmap_atomic)(struct dma_buf *, unsigned long);
+	void (*kunmap_atomic)(struct dma_buf *, unsigned long, void *);
+	void *(*kmap)(struct dma_buf *, unsigned long);
+	void (*kunmap)(struct dma_buf *, unsigned long, void *);
 };
 
 /**
@@ -140,6 +159,14 @@ struct sg_table *dma_buf_map_attachment(struct dma_buf_attachment *,
 					enum dma_data_direction);
 void dma_buf_unmap_attachment(struct dma_buf_attachment *, struct sg_table *,
 				enum dma_data_direction);
+int dma_buf_begin_cpu_access(struct dma_buf *dma_buf, size_t start, size_t len,
+			     enum dma_data_direction dir);
+void dma_buf_end_cpu_access(struct dma_buf *dma_buf, size_t start, size_t len,
+			    enum dma_data_direction dir);
+void *dma_buf_kmap_atomic(struct dma_buf *, unsigned long);
+void dma_buf_kunmap_atomic(struct dma_buf *, unsigned long, void *);
+void *dma_buf_kmap(struct dma_buf *, unsigned long);
+void dma_buf_kunmap(struct dma_buf *, unsigned long, void *);
 #else
 
 static inline struct dma_buf_attachment *dma_buf_attach(struct dma_buf *dmabuf,
@@ -188,6 +215,38 @@ static inline void dma_buf_unmap_attachment(struct dma_buf_attachment *attach,
 	return;
 }
 
+static inline int dma_buf_begin_cpu_access(struct dma_buf *,
+					   size_t, size_t,
+					   enum dma_data_direction)
+{
+	return -ENODEV;
+}
+
+static inline void dma_buf_end_cpu_access(struct dma_buf *,
+					  size_t, size_t,
+					  enum dma_data_direction)
+{
+}
+
+static inline void *dma_buf_kmap_atomic(struct dma_buf *, unsigned long)
+{
+	return NULL;
+}
+
+static inline void dma_buf_kunmap_atomic(struct dma_buf *, unsigned long,
+					 void *)
+{
+}
+
+static inline void *dma_buf_kmap(struct dma_buf *, unsigned long)
+{
+	return NULL;
+}
+
+static inline void dma_buf_kunmap(struct dma_buf *, unsigned long,
+				  void *)
+{
+}
 #endif /* CONFIG_DMA_SHARED_BUFFER */
 
 #endif /* __DMA_BUF_H__ */
-- 
1.7.7.5

