Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.w1.samsung.com ([210.118.77.14]:58802 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756222Ab2DJKLm (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 10 Apr 2012 06:11:42 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN
Received: from euspt2 ([210.118.77.14]) by mailout4.w1.samsung.com
 (Sun Java(tm) System Messaging Server 6.3-8.04 (built Jul 29 2009; 32bit))
 with ESMTP id <0M29005R9DNMM040@mailout4.w1.samsung.com> for
 linux-media@vger.kernel.org; Tue, 10 Apr 2012 11:11:46 +0100 (BST)
Received: from linux.samsung.com ([106.116.38.10])
 by spt2.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0M2900H3NDNCK7@spt2.w1.samsung.com> for
 linux-media@vger.kernel.org; Tue, 10 Apr 2012 11:11:37 +0100 (BST)
Date: Tue, 10 Apr 2012 12:11:29 +0200
From: Tomasz Stanislawski <t.stanislaws@samsung.com>
Subject: [PATCH 1/3] dma-buf: add vmap interface
In-reply-to: <1334052691-5145-1-git-send-email-t.stanislaws@samsung.com>
To: linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org
Cc: airlied@redhat.com, m.szyprowski@samsung.com,
	t.stanislaws@samsung.com, kyungmin.park@samsung.com,
	laurent.pinchart@ideasonboard.com, sumit.semwal@ti.com,
	daeinki@gmail.com, daniel.vetter@ffwll.ch, robdclark@gmail.com,
	pawel@osciak.com, linaro-mm-sig@lists.linaro.org,
	subashrp@gmail.com, mchehab@redhat.com
Message-id: <1334052691-5145-2-git-send-email-t.stanislaws@samsung.com>
References: <1334052691-5145-1-git-send-email-t.stanislaws@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Dave Airlie <airlied@redhat.com>

Add vmap to dmabuf interface.

Signed-off-by: Dave Airlie <airlied@redhat.com>
---
 drivers/base/dma-buf.c  |   29 +++++++++++++++++++++++++++++
 include/linux/dma-buf.h |   16 ++++++++++++++++
 2 files changed, 45 insertions(+), 0 deletions(-)

diff --git a/drivers/base/dma-buf.c b/drivers/base/dma-buf.c
index 07cbbc6..3068258 100644
--- a/drivers/base/dma-buf.c
+++ b/drivers/base/dma-buf.c
@@ -406,3 +406,32 @@ void dma_buf_kunmap(struct dma_buf *dmabuf, unsigned long page_num,
 		dmabuf->ops->kunmap(dmabuf, page_num, vaddr);
 }
 EXPORT_SYMBOL_GPL(dma_buf_kunmap);
+
+/**
+ * dma_buf_vmap - Create virtual mapping for the buffer object into kernel address space. The same restrictions as for vmap and friends apply.
+ * @dma_buf:	[in]	buffer to vmap
+ *
+ * This call may fail due to lack of virtual mapping address space.
+ */
+void *dma_buf_vmap(struct dma_buf *dmabuf)
+{
+	WARN_ON(!dmabuf);
+
+	if (dmabuf->ops->vmap)
+		return dmabuf->ops->vmap(dmabuf);
+	return NULL;
+}
+EXPORT_SYMBOL(dma_buf_vmap);
+
+/**
+ * dma_buf_vunmap - Unmap a page obtained by dma_buf_vmap.
+ * @dma_buf:	[in]	buffer to vmap
+ */
+void dma_buf_vunmap(struct dma_buf *dmabuf, void *vaddr)
+{
+	WARN_ON(!dmabuf);
+
+	if (dmabuf->ops->vunmap)
+		dmabuf->ops->vunmap(dmabuf, vaddr);
+}
+EXPORT_SYMBOL(dma_buf_vunmap);
diff --git a/include/linux/dma-buf.h b/include/linux/dma-buf.h
index 3efbfc2..4a6b371 100644
--- a/include/linux/dma-buf.h
+++ b/include/linux/dma-buf.h
@@ -92,6 +92,9 @@ struct dma_buf_ops {
 	void (*kunmap_atomic)(struct dma_buf *, unsigned long, void *);
 	void *(*kmap)(struct dma_buf *, unsigned long);
 	void (*kunmap)(struct dma_buf *, unsigned long, void *);
+
+	void *(*vmap)(struct dma_buf *);
+	void (*vunmap)(struct dma_buf *, void *vaddr);
 };
 
 /**
@@ -167,6 +170,9 @@ void *dma_buf_kmap_atomic(struct dma_buf *, unsigned long);
 void dma_buf_kunmap_atomic(struct dma_buf *, unsigned long, void *);
 void *dma_buf_kmap(struct dma_buf *, unsigned long);
 void dma_buf_kunmap(struct dma_buf *, unsigned long, void *);
+
+void *dma_buf_vmap(struct dma_buf *);
+void dma_buf_vunmap(struct dma_buf *, void *vaddr);
 #else
 
 static inline struct dma_buf_attachment *dma_buf_attach(struct dma_buf *dmabuf,
@@ -248,6 +254,16 @@ static inline void dma_buf_kunmap(struct dma_buf *dmabuf,
 				  unsigned long pnum, void *vaddr)
 {
 }
+
+static inline void *dma_buf_vmap(struct dma_buf *dmabuf)
+{
+	return NULL;
+}
+
+static inline void dma_buf_vunmap(struct dma_buf *dmabuf, void *vaddr)
+{
+}
+
 #endif /* CONFIG_DMA_SHARED_BUFFER */
 
 #endif /* __DMA_BUF_H__ */
-- 
1.7.5.4

