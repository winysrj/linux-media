Return-path: <linux-media-owner@vger.kernel.org>
Received: from comal.ext.ti.com ([198.47.26.152]:38602 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754872Ab2CWPtp (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 23 Mar 2012 11:49:45 -0400
From: Sumit Semwal <sumit.semwal@ti.com>
To: <daniel.vetter@ffwll.ch>
CC: <dri-devel@lists.freedesktop.org>,
	<linaro-mm-sig@lists.linaro.org>, <linux-media@vger.kernel.org>,
	Sumit Semwal <sumit.semwal@ti.com>,
	Sumit Semwal <sumit.semwal@linaro.org>
Subject: [PATCH] dma-buf: Correct dummy function declarations.
Date: Fri, 23 Mar 2012 21:19:17 +0530
Message-ID: <1332517757-25532-1-git-send-email-sumit.semwal@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

While testing, I found that we need to correct some of the dummy declarations. When I send my pull request to Linus, I wish to squash these changes into the original patches from Daniel. Could you please review?

Best regards,
~Sumit

=========

Dummy functions for the newly added cpu access ops are needed for compilation
when dma-buf framework is not compiled-in.

Also, the introduction of flags in dma_buf_fd  needs to be added to dummy
functions as well.

Signed-off-by: Sumit Semwal <sumit.semwal@linaro.org>
---
 include/linux/dma-buf.h |   26 +++++++++++++-------------
 1 files changed, 13 insertions(+), 13 deletions(-)

diff --git a/include/linux/dma-buf.h b/include/linux/dma-buf.h
index f08028e..779aaf9 100644
--- a/include/linux/dma-buf.h
+++ b/include/linux/dma-buf.h
@@ -189,7 +189,7 @@ static inline struct dma_buf *dma_buf_export(void *priv,
 	return ERR_PTR(-ENODEV);
 }
 
-static inline int dma_buf_fd(struct dma_buf *dmabuf)
+static inline int dma_buf_fd(struct dma_buf *dmabuf, int flags)
 {
 	return -ENODEV;
 }
@@ -216,36 +216,36 @@ static inline void dma_buf_unmap_attachment(struct dma_buf_attachment *attach,
 	return;
 }
 
-static inline int dma_buf_begin_cpu_access(struct dma_buf *,
-					   size_t, size_t,
-					   enum dma_data_direction)
+static inline int dma_buf_begin_cpu_access(struct dma_buf *dmabuf,
+					   size_t start, size_t len,
+					   enum dma_data_direction dir)
 {
 	return -ENODEV;
 }
 
-static inline void dma_buf_end_cpu_access(struct dma_buf *,
-					  size_t, size_t,
-					  enum dma_data_direction)
+static inline void dma_buf_end_cpu_access(struct dma_buf *dmabuf,
+					  size_t start, size_t len,
+					  enum dma_data_direction dir)
 {
 }
 
-static inline void *dma_buf_kmap_atomic(struct dma_buf *, unsigned long)
+static inline void *dma_buf_kmap_atomic(struct dma_buf *db, unsigned long pnum)
 {
 	return NULL;
 }
 
-static inline void dma_buf_kunmap_atomic(struct dma_buf *, unsigned long,
-					 void *)
+static inline void dma_buf_kunmap_atomic(struct dma_buf *db, unsigned long pnum,
+					 void *vaddr)
 {
 }
 
-static inline void *dma_buf_kmap(struct dma_buf *, unsigned long)
+static inline void *dma_buf_kmap(struct dma_buf *db, unsigned long pnum)
 {
 	return NULL;
 }
 
-static inline void dma_buf_kunmap(struct dma_buf *, unsigned long,
-				  void *)
+static inline void dma_buf_kunmap(struct dma_buf *db, unsigned long pnum,
+				  void *vaddr)
 {
 }
 #endif /* CONFIG_DMA_SHARED_BUFFER */
-- 
1.7.5.4

