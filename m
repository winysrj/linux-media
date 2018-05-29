Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx3-rdu2.redhat.com ([66.187.233.73]:36598 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S934764AbeE2N7h (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 29 May 2018 09:59:37 -0400
From: Gerd Hoffmann <kraxel@redhat.com>
To: dri-devel@lists.freedesktop.org
Cc: Gerd Hoffmann <kraxel@redhat.com>, Daniel Vetter <daniel@ffwll.ch>,
        Sumit Semwal <sumit.semwal@linaro.org>,
        linux-media@vger.kernel.org (open list:DMA BUFFER SHARING FRAMEWORK),
        linaro-mm-sig@lists.linaro.org (moderated list:DMA BUFFER SHARING
        FRAMEWORK), linux-kernel@vger.kernel.org (open list)
Subject: [PATCH] dma-buf: make map_atomic and map function pointers optional
Date: Tue, 29 May 2018 15:59:18 +0200
Message-Id: <20180529135918.19729-1-kraxel@redhat.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

So drivers don't need dummy functions just returning NULL.

Cc: Daniel Vetter <daniel@ffwll.ch>
Signed-off-by: Gerd Hoffmann <kraxel@redhat.com>
---
 include/linux/dma-buf.h   | 4 ++--
 drivers/dma-buf/dma-buf.c | 4 ++++
 2 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/include/linux/dma-buf.h b/include/linux/dma-buf.h
index 085db2fee2..88917fa796 100644
--- a/include/linux/dma-buf.h
+++ b/include/linux/dma-buf.h
@@ -39,12 +39,12 @@ struct dma_buf_attachment;
 
 /**
  * struct dma_buf_ops - operations possible on struct dma_buf
- * @map_atomic: maps a page from the buffer into kernel address
+ * @map_atomic: [optional] maps a page from the buffer into kernel address
  *		space, users may not block until the subsequent unmap call.
  *		This callback must not sleep.
  * @unmap_atomic: [optional] unmaps a atomically mapped page from the buffer.
  *		  This Callback must not sleep.
- * @map: maps a page from the buffer into kernel address space.
+ * @map: [optional] maps a page from the buffer into kernel address space.
  * @unmap: [optional] unmaps a page from the buffer.
  * @vmap: [optional] creates a virtual mapping for the buffer into kernel
  *	  address space. Same restrictions as for vmap and friends apply.
diff --git a/drivers/dma-buf/dma-buf.c b/drivers/dma-buf/dma-buf.c
index d78d5fc173..4c45e31258 100644
--- a/drivers/dma-buf/dma-buf.c
+++ b/drivers/dma-buf/dma-buf.c
@@ -872,6 +872,8 @@ void *dma_buf_kmap_atomic(struct dma_buf *dmabuf, unsigned long page_num)
 {
 	WARN_ON(!dmabuf);
 
+	if (!dmabuf->ops->map_atomic)
+		return NULL;
 	return dmabuf->ops->map_atomic(dmabuf, page_num);
 }
 EXPORT_SYMBOL_GPL(dma_buf_kmap_atomic);
@@ -907,6 +909,8 @@ void *dma_buf_kmap(struct dma_buf *dmabuf, unsigned long page_num)
 {
 	WARN_ON(!dmabuf);
 
+	if (!dmabuf->ops->map)
+		return NULL;
 	return dmabuf->ops->map(dmabuf, page_num);
 }
 EXPORT_SYMBOL_GPL(dma_buf_kmap);
-- 
2.9.3
