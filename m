Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f65.google.com ([74.125.82.65]:35082 "EHLO
        mail-wm0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753197AbeDKNkD (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 11 Apr 2018 09:40:03 -0400
Received: by mail-wm0-f65.google.com with SMTP id r82so3940285wme.0
        for <linux-media@vger.kernel.org>; Wed, 11 Apr 2018 06:40:03 -0700 (PDT)
From: "=?UTF-8?q?Christian=20K=C3=B6nig?="
        <ckoenig.leichtzumerken@gmail.com>
To: linaro-mm-sig@lists.linaro.org, linux-media@vger.kernel.org,
        dri-devel@lists.freedesktop.org, amd-gfx@lists.freedesktop.org
Subject: [PATCH 2/5] dma-buf: add optional invalidate_mappings callback v3
Date: Wed, 11 Apr 2018 15:39:56 +0200
Message-Id: <20180411133959.4257-2-christian.koenig@amd.com>
In-Reply-To: <20180411133959.4257-1-christian.koenig@amd.com>
References: <20180411133959.4257-1-christian.koenig@amd.com>
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
v3: move flag for invalidation support into the DMA-buf,
    use new attach_info structure to set the callback
v4: use importer_priv field instead of mangling exporter priv.

Signed-off-by: Christian König <christian.koenig@amd.com>
---
 drivers/dma-buf/dma-buf.c | 44 ++++++++++++++++++++++++++++++++++++++++++++
 include/linux/dma-buf.h   | 36 ++++++++++++++++++++++++++++++++++--
 2 files changed, 78 insertions(+), 2 deletions(-)

diff --git a/drivers/dma-buf/dma-buf.c b/drivers/dma-buf/dma-buf.c
index 4b46982c6d9c..ffdaab10e2f2 100644
--- a/drivers/dma-buf/dma-buf.c
+++ b/drivers/dma-buf/dma-buf.c
@@ -565,6 +565,8 @@ struct dma_buf_attachment *dma_buf_attach(const struct dma_buf_attach_info *info
 
 	attach->dev = info->dev;
 	attach->dmabuf = dmabuf;
+	attach->importer_priv = info->importer_priv;
+	attach->invalidate = info->invalidate;
 
 	mutex_lock(&dmabuf->lock);
 
@@ -573,7 +575,9 @@ struct dma_buf_attachment *dma_buf_attach(const struct dma_buf_attach_info *info
 		if (ret)
 			goto err_attach;
 	}
+	reservation_object_lock(dmabuf->resv, NULL);
 	list_add(&attach->node, &dmabuf->attachments);
+	reservation_object_unlock(dmabuf->resv);
 
 	mutex_unlock(&dmabuf->lock);
 	return attach;
@@ -599,7 +603,9 @@ void dma_buf_detach(struct dma_buf *dmabuf, struct dma_buf_attachment *attach)
 		return;
 
 	mutex_lock(&dmabuf->lock);
+	reservation_object_lock(dmabuf->resv, NULL);
 	list_del(&attach->node);
+	reservation_object_unlock(dmabuf->resv);
 	if (dmabuf->ops->detach)
 		dmabuf->ops->detach(dmabuf, attach);
 
@@ -633,10 +639,23 @@ struct sg_table *dma_buf_map_attachment(struct dma_buf_attachment *attach,
 	if (WARN_ON(!attach || !attach->dmabuf))
 		return ERR_PTR(-EINVAL);
 
+	/*
+	 * Mapping a DMA-buf can trigger its invalidation, prevent sending this
+	 * event to the caller by temporary removing this attachment from the
+	 * list.
+	 */
+	if (attach->invalidate) {
+		reservation_object_assert_held(attach->dmabuf->resv);
+		list_del(&attach->node);
+	}
+
 	sg_table = attach->dmabuf->ops->map_dma_buf(attach, direction);
 	if (!sg_table)
 		sg_table = ERR_PTR(-ENOMEM);
 
+	if (attach->invalidate)
+		list_add(&attach->node, &attach->dmabuf->attachments);
+
 	return sg_table;
 }
 EXPORT_SYMBOL_GPL(dma_buf_map_attachment);
@@ -657,6 +676,9 @@ void dma_buf_unmap_attachment(struct dma_buf_attachment *attach,
 {
 	might_sleep();
 
+	if (attach->invalidate)
+		reservation_object_assert_held(attach->dmabuf->resv);
+
 	if (WARN_ON(!attach || !attach->dmabuf || !sg_table))
 		return;
 
@@ -665,6 +687,26 @@ void dma_buf_unmap_attachment(struct dma_buf_attachment *attach,
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
+		if (attach->invalidate)
+			attach->invalidate(attach);
+}
+EXPORT_SYMBOL_GPL(dma_buf_invalidate_mappings);
+
 /**
  * DOC: cpu access
  *
@@ -1122,10 +1164,12 @@ static int dma_buf_debug_show(struct seq_file *s, void *unused)
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
index 414b4dde5eb7..566503dd2b4f 100644
--- a/include/linux/dma-buf.h
+++ b/include/linux/dma-buf.h
@@ -270,6 +270,8 @@ struct dma_buf_ops {
  * @poll: for userspace poll support
  * @cb_excl: for userspace poll support
  * @cb_shared: for userspace poll support
+ * @invalidation_supported: True when the exporter supports unpinned operation
+ *                          using the reservation lock.
  *
  * This represents a shared buffer, created by calling dma_buf_export(). The
  * userspace representation is a normal file descriptor, which can be created by
@@ -293,6 +295,7 @@ struct dma_buf {
 	struct list_head list_node;
 	void *priv;
 	struct reservation_object *resv;
+	bool invalidation_supported;
 
 	/* poll support */
 	wait_queue_head_t poll;
@@ -311,6 +314,7 @@ struct dma_buf {
  * @dev: device attached to the buffer.
  * @node: list of dma_buf_attachment.
  * @priv: exporter specific attachment data.
+ * @importer_priv: importer specific attachment data.
  *
  * This structure holds the attachment information between the dma_buf buffer
  * and its user device(s). The list contains one attachment struct per device
@@ -326,6 +330,29 @@ struct dma_buf_attachment {
 	struct device *dev;
 	struct list_head node;
 	void *priv;
+	void *importer_priv;
+
+	/**
+	 * @invalidate:
+	 *
+	 * Optional callback provided by the importer of the dma-buf.
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
+	void (*invalidate)(struct dma_buf_attachment *attach);
 };
 
 /**
@@ -364,8 +391,10 @@ struct dma_buf_export_info {
 
 /**
  * struct dma_buf_attach_info - holds information needed to attach to a dma_buf
- * @dmabuf:	the exported dma_buf
- * @dev:	the device which wants to import the attachment
+ * @dmabuf:		the exported dma_buf
+ * @dev:		the device which wants to import the attachment
+ * @importer_priv:	private data of importer to this attachment
+ * @invalidate:		callback to use for invalidating mappings
  *
  * This structure holds the information required to attach to a buffer. Used
  * with dma_buf_attach() only.
@@ -373,6 +402,8 @@ struct dma_buf_export_info {
 struct dma_buf_attach_info {
 	struct dma_buf *dmabuf;
 	struct device *dev;
+	void *importer_priv;
+	void (*invalidate)(struct dma_buf_attachment *attach);
 };
 
 /**
@@ -404,6 +435,7 @@ struct sg_table *dma_buf_map_attachment(struct dma_buf_attachment *,
 					enum dma_data_direction);
 void dma_buf_unmap_attachment(struct dma_buf_attachment *, struct sg_table *,
 				enum dma_data_direction);
+void dma_buf_invalidate_mappings(struct dma_buf *dma_buf);
 int dma_buf_begin_cpu_access(struct dma_buf *dma_buf,
 			     enum dma_data_direction dir);
 int dma_buf_end_cpu_access(struct dma_buf *dma_buf,
-- 
2.14.1
