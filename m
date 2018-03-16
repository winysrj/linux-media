Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr0-f195.google.com ([209.85.128.195]:33585 "EHLO
        mail-wr0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752489AbeCPNUy (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 16 Mar 2018 09:20:54 -0400
Received: by mail-wr0-f195.google.com with SMTP id z73so7443976wrb.0
        for <linux-media@vger.kernel.org>; Fri, 16 Mar 2018 06:20:53 -0700 (PDT)
From: "=?UTF-8?q?Christian=20K=C3=B6nig?="
        <ckoenig.leichtzumerken@gmail.com>
To: linaro-mm-sig@lists.linaro.org, linux-media@vger.kernel.org,
        dri-devel@lists.freedesktop.org, amd-gfx@lists.freedesktop.org
Subject: [PATCH 1/5] dma-buf: add optional invalidate_mappings callback v2
Date: Fri, 16 Mar 2018 14:20:45 +0100
Message-Id: <20180316132049.1748-2-christian.koenig@amd.com>
In-Reply-To: <20180316132049.1748-1-christian.koenig@amd.com>
References: <20180316132049.1748-1-christian.koenig@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Each importer can now provide an invalidate_mappings callback.

This allows the exporter to provide the mappings without the need to pin
the backing store.

v2: don't try to invalidate mappings when the callback is NULL,
    lock the reservation obj while using the attachments,
    add helper to set the callback

Signed-off-by: Christian König <christian.koenig@amd.com>
---
 drivers/dma-buf/dma-buf.c | 60 +++++++++++++++++++++++++++++++++++++++++++++++
 include/linux/dma-buf.h   | 38 ++++++++++++++++++++++++++++++
 2 files changed, 98 insertions(+)

diff --git a/drivers/dma-buf/dma-buf.c b/drivers/dma-buf/dma-buf.c
index d78d5fc173dc..ed2b3559ba25 100644
--- a/drivers/dma-buf/dma-buf.c
+++ b/drivers/dma-buf/dma-buf.c
@@ -572,7 +572,9 @@ struct dma_buf_attachment *dma_buf_attach(struct dma_buf *dmabuf,
 		if (ret)
 			goto err_attach;
 	}
+	reservation_object_lock(dmabuf->resv, NULL);
 	list_add(&attach->node, &dmabuf->attachments);
+	reservation_object_unlock(dmabuf->resv);
 
 	mutex_unlock(&dmabuf->lock);
 	return attach;
@@ -598,7 +600,9 @@ void dma_buf_detach(struct dma_buf *dmabuf, struct dma_buf_attachment *attach)
 		return;
 
 	mutex_lock(&dmabuf->lock);
+	reservation_object_lock(dmabuf->resv, NULL);
 	list_del(&attach->node);
+	reservation_object_unlock(dmabuf->resv);
 	if (dmabuf->ops->detach)
 		dmabuf->ops->detach(dmabuf, attach);
 
@@ -632,10 +636,23 @@ struct sg_table *dma_buf_map_attachment(struct dma_buf_attachment *attach,
 	if (WARN_ON(!attach || !attach->dmabuf))
 		return ERR_PTR(-EINVAL);
 
+	/*
+	 * Mapping a DMA-buf can trigger its invalidation, prevent sending this
+	 * event to the caller by temporary removing this attachment from the
+	 * list.
+	 */
+	if (attach->invalidate_mappings) {
+		reservation_object_assert_held(attach->dmabuf->resv);
+		list_del(&attach->node);
+	}
+
 	sg_table = attach->dmabuf->ops->map_dma_buf(attach, direction);
 	if (!sg_table)
 		sg_table = ERR_PTR(-ENOMEM);
 
+	if (attach->invalidate_mappings)
+		list_add(&attach->node, &attach->dmabuf->attachments);
+
 	return sg_table;
 }
 EXPORT_SYMBOL_GPL(dma_buf_map_attachment);
@@ -656,6 +673,9 @@ void dma_buf_unmap_attachment(struct dma_buf_attachment *attach,
 {
 	might_sleep();
 
+	if (attach->invalidate_mappings)
+		reservation_object_assert_held(attach->dmabuf->resv);
+
 	if (WARN_ON(!attach || !attach->dmabuf || !sg_table))
 		return;
 
@@ -664,6 +684,44 @@ void dma_buf_unmap_attachment(struct dma_buf_attachment *attach,
 }
 EXPORT_SYMBOL_GPL(dma_buf_unmap_attachment);
 
+/**
+ * dma_buf_set_invalidate_callback - set the invalidate_mappings callback
+ *
+ * @attach:	[in]	attachment where to set the callback
+ * @cb:		[in]	the callback to set
+ *
+ * Makes sure to take the appropriate locks when updating the invalidate
+ * mappings callback.
+ */
+void dma_buf_set_invalidate_callback(struct dma_buf_attachment *attach,
+				     void (*cb)(struct dma_buf_attachment *))
+{
+	reservation_object_lock(attach->dmabuf->resv, NULL);
+	attach->invalidate_mappings = cb;
+	reservation_object_unlock(attach->dmabuf->resv);
+}
+EXPORT_SYMBOL_GPL(dma_buf_set_invalidate_callback);
+
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
+		if (attach->invalidate_mappings)
+			attach->invalidate_mappings(attach);
+}
+EXPORT_SYMBOL_GPL(dma_buf_invalidate_mappings);
+
 /**
  * DOC: cpu access
  *
@@ -1121,10 +1179,12 @@ static int dma_buf_debug_show(struct seq_file *s, void *unused)
 		seq_puts(s, "\tAttached Devices:\n");
 		attach_count = 0;
 
+		reservation_object_lock(buf_obj->resv, NULL);
 		list_for_each_entry(attach_obj, &buf_obj->attachments, node) {
 			seq_printf(s, "\t%s\n", dev_name(attach_obj->dev));
 			attach_count++;
 		}
+		reservation_object_unlock(buf_obj->resv);
 
 		seq_printf(s, "Total %d devices attached\n\n",
 				attach_count);
diff --git a/include/linux/dma-buf.h b/include/linux/dma-buf.h
index 085db2fee2d7..70c65fcfe1e3 100644
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
@@ -391,6 +426,9 @@ struct sg_table *dma_buf_map_attachment(struct dma_buf_attachment *,
 					enum dma_data_direction);
 void dma_buf_unmap_attachment(struct dma_buf_attachment *, struct sg_table *,
 				enum dma_data_direction);
+void dma_buf_set_invalidate_callback(struct dma_buf_attachment *attach,
+				     void (*cb)(struct dma_buf_attachment *));
+void dma_buf_invalidate_mappings(struct dma_buf *dma_buf);
 int dma_buf_begin_cpu_access(struct dma_buf *dma_buf,
 			     enum dma_data_direction dir);
 int dma_buf_end_cpu_access(struct dma_buf *dma_buf,
-- 
2.14.1
