Return-path: <linux-media-owner@vger.kernel.org>
Received: from comal.ext.ti.com ([198.47.26.152]:45505 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751769Ab2A0Jno (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 27 Jan 2012 04:43:44 -0500
From: Sumit Semwal <sumit.semwal@ti.com>
To: <dri-devel@lists.freedesktop.org>,
	<linaro-mm-sig@lists.linaro.org>, <linux-media@vger.kernel.org>
CC: <t.stanislaws@samsung.com>, Sumit Semwal <sumit.semwal@ti.com>
Subject: [PATCH] dma-buf: add dma_data_direction to unmap dma_buf_op
Date: Fri, 27 Jan 2012 15:13:28 +0530
Message-ID: <1327657408-15234-1-git-send-email-sumit.semwal@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Some exporters may use DMA map/unmap APIs in dma-buf ops, which require
enum dma_data_direction for both map and unmap operations.

Thus, the unmap dma_buf_op also needs to have enum dma_data_direction as
a parameter.

Reported-by: Tomasz Stanislawski <t.stanislaws@samsung.com>
Signed-off-by: Sumit Semwal <sumit.semwal@ti.com>
---
 drivers/base/dma-buf.c  |    7 +++++--
 include/linux/dma-buf.h |    8 +++++---
 2 files changed, 10 insertions(+), 5 deletions(-)

diff --git a/drivers/base/dma-buf.c b/drivers/base/dma-buf.c
index 8afe2dd..c9a945f 100644
--- a/drivers/base/dma-buf.c
+++ b/drivers/base/dma-buf.c
@@ -271,16 +271,19 @@ EXPORT_SYMBOL_GPL(dma_buf_map_attachment);
  * dma_buf_ops.
  * @attach:	[in]	attachment to unmap buffer from
  * @sg_table:	[in]	scatterlist info of the buffer to unmap
+ * @direction:  [in]    direction of DMA transfer
  *
  */
 void dma_buf_unmap_attachment(struct dma_buf_attachment *attach,
-				struct sg_table *sg_table)
+				struct sg_table *sg_table,
+				enum dma_data_direction direction)
 {
 	if (WARN_ON(!attach || !attach->dmabuf || !sg_table))
 		return;
 
 	mutex_lock(&attach->dmabuf->lock);
-	attach->dmabuf->ops->unmap_dma_buf(attach, sg_table);
+	attach->dmabuf->ops->unmap_dma_buf(attach, sg_table,
+						direction);
 	mutex_unlock(&attach->dmabuf->lock);
 
 }
diff --git a/include/linux/dma-buf.h b/include/linux/dma-buf.h
index 86f6241..847b026 100644
--- a/include/linux/dma-buf.h
+++ b/include/linux/dma-buf.h
@@ -63,7 +63,8 @@ struct dma_buf_ops {
 	struct sg_table * (*map_dma_buf)(struct dma_buf_attachment *,
 						enum dma_data_direction);
 	void (*unmap_dma_buf)(struct dma_buf_attachment *,
-						struct sg_table *);
+						struct sg_table *,
+						enum dma_data_direction);
 	/* TODO: Add try_map_dma_buf version, to return immed with -EBUSY
 	 * if the call would block.
 	 */
@@ -122,7 +123,8 @@ void dma_buf_put(struct dma_buf *dmabuf);
 
 struct sg_table *dma_buf_map_attachment(struct dma_buf_attachment *,
 					enum dma_data_direction);
-void dma_buf_unmap_attachment(struct dma_buf_attachment *, struct sg_table *);
+void dma_buf_unmap_attachment(struct dma_buf_attachment *, struct sg_table *,
+				enum dma_data_direction);
 #else
 
 static inline struct dma_buf_attachment *dma_buf_attach(struct dma_buf *dmabuf,
@@ -166,7 +168,7 @@ static inline struct sg_table *dma_buf_map_attachment(
 }
 
 static inline void dma_buf_unmap_attachment(struct dma_buf_attachment *attach,
-						struct sg_table *sg)
+			struct sg_table *sg, enum dma_data_direction write)
 {
 	return;
 }
-- 
1.7.5.4

