Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.w1.samsung.com ([210.118.77.12]:58994 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753216Ab2DEOAg (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 5 Apr 2012 10:00:36 -0400
Received: from euspt1 (mailout2.w1.samsung.com [210.118.77.12])
 by mailout2.w1.samsung.com
 (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14 2004))
 with ESMTP id <0M200021BEWSKP@mailout2.w1.samsung.com> for
 linux-media@vger.kernel.org; Thu, 05 Apr 2012 15:00:29 +0100 (BST)
Received: from linux.samsung.com ([106.116.38.10])
 by spt1.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0M2000D6FEWVUI@spt1.w1.samsung.com> for
 linux-media@vger.kernel.org; Thu, 05 Apr 2012 15:00:32 +0100 (BST)
Date: Thu, 05 Apr 2012 16:00:04 +0200
From: Tomasz Stanislawski <t.stanislaws@samsung.com>
Subject: [PATCH 07/11] v4l: vb2-dma-contig: Reorder functions
In-reply-to: <1333634408-4960-1-git-send-email-t.stanislaws@samsung.com>
To: linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org
Cc: airlied@redhat.com, m.szyprowski@samsung.com,
	t.stanislaws@samsung.com, kyungmin.park@samsung.com,
	laurent.pinchart@ideasonboard.com, sumit.semwal@ti.com,
	daeinki@gmail.com, daniel.vetter@ffwll.ch, robdclark@gmail.com,
	pawel@osciak.com, linaro-mm-sig@lists.linaro.org,
	subashrp@gmail.com
Message-id: <1333634408-4960-8-git-send-email-t.stanislaws@samsung.com>
MIME-version: 1.0
Content-type: TEXT/PLAIN
Content-transfer-encoding: 7BIT
References: <1333634408-4960-1-git-send-email-t.stanislaws@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

Group functions by buffer type.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/media/video/videobuf2-dma-contig.c |   92 ++++++++++++++++-----------
 1 files changed, 54 insertions(+), 38 deletions(-)

diff --git a/drivers/media/video/videobuf2-dma-contig.c b/drivers/media/video/videobuf2-dma-contig.c
index ff0a662..476e536 100644
--- a/drivers/media/video/videobuf2-dma-contig.c
+++ b/drivers/media/video/videobuf2-dma-contig.c
@@ -20,14 +20,56 @@
 struct vb2_dc_buf {
 	struct device			*dev;
 	void				*vaddr;
-	dma_addr_t			dma_addr;
 	unsigned long			size;
-	struct vm_area_struct		*vma;
-	atomic_t			refcount;
+	dma_addr_t			dma_addr;
+
+	/* MMAP related */
 	struct vb2_vmarea_handler	handler;
+	atomic_t			refcount;
+
+	/* USERPTR related */
+	struct vm_area_struct		*vma;
 };
 
-static void vb2_dc_put(void *buf_priv);
+/*********************************************/
+/*         callbacks for all buffers         */
+/*********************************************/
+
+static void *vb2_dc_cookie(void *buf_priv)
+{
+	struct vb2_dc_buf *buf = buf_priv;
+
+	return &buf->dma_addr;
+}
+
+static void *vb2_dc_vaddr(void *buf_priv)
+{
+	struct vb2_dc_buf *buf = buf_priv;
+
+	return buf->vaddr;
+}
+
+static unsigned int vb2_dc_num_users(void *buf_priv)
+{
+	struct vb2_dc_buf *buf = buf_priv;
+
+	return atomic_read(&buf->refcount);
+}
+
+/*********************************************/
+/*        callbacks for MMAP buffers         */
+/*********************************************/
+
+static void vb2_dc_put(void *buf_priv)
+{
+	struct vb2_dc_buf *buf = buf_priv;
+
+	if (!atomic_dec_and_test(&buf->refcount))
+		return;
+
+	dma_free_coherent(buf->dev, buf->size, buf->vaddr, buf->dma_addr);
+	kfree(buf);
+}
 
 static void *vb2_dc_alloc(void *alloc_ctx, unsigned long size)
 {
@@ -57,40 +99,6 @@ static void *vb2_dc_alloc(void *alloc_ctx, unsigned long size)
 	return buf;
 }
 
-static void vb2_dc_put(void *buf_priv)
-{
-	struct vb2_dc_buf *buf = buf_priv;
-
-	if (atomic_dec_and_test(&buf->refcount)) {
-		dma_free_coherent(buf->dev, buf->size, buf->vaddr,
-				  buf->dma_addr);
-		kfree(buf);
-	}
-}
-
-static void *vb2_dc_cookie(void *buf_priv)
-{
-	struct vb2_dc_buf *buf = buf_priv;
-
-	return &buf->dma_addr;
-}
-
-static void *vb2_dc_vaddr(void *buf_priv)
-{
-	struct vb2_dc_buf *buf = buf_priv;
-	if (!buf)
-		return 0;
-
-	return buf->vaddr;
-}
-
-static unsigned int vb2_dc_num_users(void *buf_priv)
-{
-	struct vb2_dc_buf *buf = buf_priv;
-
-	return atomic_read(&buf->refcount);
-}
-
 static int vb2_dc_mmap(void *buf_priv, struct vm_area_struct *vma)
 {
 	struct vb2_dc_buf *buf = buf_priv;
@@ -104,6 +112,10 @@ static int vb2_dc_mmap(void *buf_priv, struct vm_area_struct *vma)
 				  &vb2_common_vm_ops, &buf->handler);
 }
 
+/*********************************************/
+/*       callbacks for USERPTR buffers       */
+/*********************************************/
+
 static void *vb2_dc_get_userptr(void *alloc_ctx, unsigned long vaddr,
 					unsigned long size, int write)
 {
@@ -142,6 +154,10 @@ static void vb2_dc_put_userptr(void *mem_priv)
 	kfree(buf);
 }
 
+/*********************************************/
+/*       DMA CONTIG exported functions       */
+/*********************************************/
+
 const struct vb2_mem_ops vb2_dma_contig_memops = {
 	.alloc		= vb2_dc_alloc,
 	.put		= vb2_dc_put,
-- 
1.7.5.4

