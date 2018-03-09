Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr0-f193.google.com ([209.85.128.193]:42167 "EHLO
        mail-wr0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932183AbeCITKp (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 9 Mar 2018 14:10:45 -0500
Received: by mail-wr0-f193.google.com with SMTP id k9so9988350wre.9
        for <linux-media@vger.kernel.org>; Fri, 09 Mar 2018 11:10:44 -0800 (PST)
From: "=?UTF-8?q?Christian=20K=C3=B6nig?="
        <ckoenig.leichtzumerken@gmail.com>
To: linaro-mm-sig@lists.linaro.org, linux-media@vger.kernel.org,
        dri-devel@lists.freedesktop.org, amd-gfx@lists.freedesktop.org
Cc: sumit.semwal@linaro.org
Subject: [PATCH 1/4] dma-buf: add optional invalidate_mappings callback
Date: Fri,  9 Mar 2018 20:10:39 +0100
Message-Id: <20180309191042.1769-1-christian.koenig@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Each importer can now provide an invalidate_mappings callback.

This allows the exporter to provide the mappings without the need to pin
the backing store.

Signed-off-by: Christian König <christian.koenig@amd.com>
---
 drivers/dma-buf/dma-buf.c | 25 +++++++++++++++++++++++++
 include/linux/dma-buf.h   | 36 ++++++++++++++++++++++++++++++++++++
 2 files changed, 61 insertions(+)

diff --git a/drivers/dma-buf/dma-buf.c b/drivers/dma-buf/dma-buf.c
index d78d5fc173dc..ed8d5844ae74 100644
--- a/drivers/dma-buf/dma-buf.c
+++ b/drivers/dma-buf/dma-buf.c
@@ -629,6 +629,9 @@ struct sg_table *dma_buf_map_attachment(struct dma_buf_attachment *attach,
 
 	might_sleep();
 
+	if (attach->invalidate_mappings)
+		reservation_object_assert_held(attach->dmabuf->resv);
+
 	if (WARN_ON(!attach || !attach->dmabuf))
 		return ERR_PTR(-EINVAL);
 
@@ -656,6 +659,9 @@ void dma_buf_unmap_attachment(struct dma_buf_attachment *attach,
 {
 	might_sleep();
 
+	if (attach->invalidate_mappings)
+		reservation_object_assert_held(attach->dmabuf->resv);
+
 	if (WARN_ON(!attach || !attach->dmabuf || !sg_table))
 		return;
 
@@ -664,6 +670,25 @@ void dma_buf_unmap_attachment(struct dma_buf_attachment *attach,
 }
 EXPORT_SYMBOL_GPL(dma_buf_unmap_attachment);
 
+/**
+ * dma_buf_invalidate_mappings - invalidate all mappings of this dma_buf
+ *
+ * @dmabuf:	[in]	buffer which mappings should be invalidated
+ *
+ * Informs all attachmenst that they need to destroy and recreated all their
+ * mappings.
+ */
+void dma_buf_invalidate_mappings(struct dma_buf *dmabuf)
+{
+	struct dma_buf_attachment *attach;
+
+	reservation_object_assert_held(dmabuf->resv);
+
+	list_for_each_entry(attach, &dmabuf->attachments, node)
+		attach->invalidate_mappings(attach);
+}
+EXPORT_SYMBOL_GPL(dma_buf_invalidate_mappings);
+
 /**
  * DOC: cpu access
  *
diff --git a/include/linux/dma-buf.h b/include/linux/dma-buf.h
index 085db2fee2d7..c1e2f7d93509 100644
--- a/include/linux/dma-buf.h
+++ b/include/linux/dma-buf.h
@@ -91,6 +91,18 @@ struct dma_buf_ops {
 	 */
 	void (*detach)(struct dma_buf *, struct dma_buf_attachment *);
 
+	/**
+	 * @supports_mapping_invalidation:
+	 *
+	 * True for exporters which supports unpinned DMA-buf operation using
+	 * the reservation lock.
+	 *
+	 * When attachment->invalidate_mappings is set the @map_dma_buf and
+	 * @unmap_dma_buf callbacks can be called with the reservation lock
+	 * held.
+	 */
+	bool supports_mapping_invalidation;
+
 	/**
 	 * @map_dma_buf:
 	 *
@@ -326,6 +338,29 @@ struct dma_buf_attachment {
 	struct device *dev;
 	struct list_head node;
 	void *priv;
+
+	/**
+	 * @invalidate_mappings:
+	 *
+	 * Optional callback provided by the importer of the attachment which
+	 * must be set before mappings are created.
+	 *
+	 * If provided the exporter can avoid pinning the backing store while
+	 * mappings exists.
+	 *
+	 * The function is called with the lock of the reservation object
+	 * associated with the dma_buf held and the mapping function must be
+	 * called with this lock held as well. This makes sure that no mapping
+	 * is created concurrently with an ongoing invalidation.
+	 *
+	 * After the callback all existing mappings are still valid until all
+	 * fences in the dma_bufs reservation object are signaled, but should be
+	 * destroyed by the importer as soon as possible.
+	 *
+	 * New mappings can be created immediately, but can't be used before the
+	 * exclusive fence in the dma_bufs reservation object is signaled.
+	 */
+	void (*invalidate_mappings)(struct dma_buf_attachment *attach);
 };
 
 /**
@@ -391,6 +426,7 @@ struct sg_table *dma_buf_map_attachment(struct dma_buf_attachment *,
 					enum dma_data_direction);
 void dma_buf_unmap_attachment(struct dma_buf_attachment *, struct sg_table *,
 				enum dma_data_direction);
+void dma_buf_invalidate_mappings(struct dma_buf *dma_buf);
 int dma_buf_begin_cpu_access(struct dma_buf *dma_buf,
 			     enum dma_data_direction dir);
 int dma_buf_end_cpu_access(struct dma_buf *dma_buf,
-- 
2.14.1
