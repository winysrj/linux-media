Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.samsung.com ([203.254.224.34]:48602 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932253Ab2JJOvG (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 10 Oct 2012 10:51:06 -0400
Received: from epcpsbgm1.samsung.com (epcpsbgm1 [203.254.230.26])
 by mailout4.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MBO00ACOML5Q580@mailout4.samsung.com> for
 linux-media@vger.kernel.org; Wed, 10 Oct 2012 23:51:05 +0900 (KST)
Received: from mcdsrvbld02.digital.local ([106.116.37.23])
 by mmp1.samsung.com (Oracle Communications Messaging Server 7u4-24.01
 (7.0.4.24.0) 64bit (built Nov 17 2011))
 with ESMTPA id <0MBO002YDME0EC70@mmp1.samsung.com> for
 linux-media@vger.kernel.org; Wed, 10 Oct 2012 23:51:04 +0900 (KST)
From: Tomasz Stanislawski <t.stanislaws@samsung.com>
To: linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org
Cc: airlied@redhat.com, m.szyprowski@samsung.com,
	t.stanislaws@samsung.com, kyungmin.park@samsung.com,
	laurent.pinchart@ideasonboard.com, sumit.semwal@ti.com,
	daeinki@gmail.com, daniel.vetter@ffwll.ch, robdclark@gmail.com,
	pawel@osciak.com, linaro-mm-sig@lists.linaro.org,
	hverkuil@xs4all.nl, remi@remlab.net, subashrp@gmail.com,
	mchehab@redhat.com, zhangfei.gao@gmail.com, s.nawrocki@samsung.com,
	k.debski@samsung.com
Subject: [PATCHv10 07/26] v4l: vb2-dma-contig: reorder functions
Date: Wed, 10 Oct 2012 16:46:26 +0200
Message-id: <1349880405-26049-8-git-send-email-t.stanislaws@samsung.com>
In-reply-to: <1349880405-26049-1-git-send-email-t.stanislaws@samsung.com>
References: <1349880405-26049-1-git-send-email-t.stanislaws@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

Group functions by buffer type.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Acked-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/v4l2-core/videobuf2-dma-contig.c |   92 ++++++++++++++----------
 1 file changed, 54 insertions(+), 38 deletions(-)

diff --git a/drivers/media/v4l2-core/videobuf2-dma-contig.c b/drivers/media/v4l2-core/videobuf2-dma-contig.c
index 20c95da..daac2b2 100644
--- a/drivers/media/v4l2-core/videobuf2-dma-contig.c
+++ b/drivers/media/v4l2-core/videobuf2-dma-contig.c
@@ -25,14 +25,56 @@ struct vb2_dc_conf {
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
@@ -63,40 +105,6 @@ static void *vb2_dc_alloc(void *alloc_ctx, unsigned long size)
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
-		return NULL;
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
@@ -110,6 +118,10 @@ static int vb2_dc_mmap(void *buf_priv, struct vm_area_struct *vma)
 				  &vb2_common_vm_ops, &buf->handler);
 }
 
+/*********************************************/
+/*       callbacks for USERPTR buffers       */
+/*********************************************/
+
 static void *vb2_dc_get_userptr(void *alloc_ctx, unsigned long vaddr,
 					unsigned long size, int write)
 {
@@ -148,6 +160,10 @@ static void vb2_dc_put_userptr(void *mem_priv)
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
1.7.9.5

