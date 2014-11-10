Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud6.xs4all.net ([194.109.24.24]:56405 "EHLO
	lb1-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752543AbaKJMti (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 10 Nov 2014 07:49:38 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: m.szyprowski@samsung.com, pawel@osciak.com,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFCv6 PATCH 03/16] vb2: add dma_dir to the alloc memop.
Date: Mon, 10 Nov 2014 13:49:18 +0100
Message-Id: <1415623771-29634-4-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1415623771-29634-1-git-send-email-hverkuil@xs4all.nl>
References: <1415623771-29634-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

This is needed for the next patch where the dma-sg alloc memop needs
to know the dma_dir.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/v4l2-core/videobuf2-core.c       | 4 +++-
 drivers/media/v4l2-core/videobuf2-dma-contig.c | 4 +++-
 drivers/media/v4l2-core/videobuf2-dma-sg.c     | 5 +++--
 drivers/media/v4l2-core/videobuf2-vmalloc.c    | 4 +++-
 include/media/videobuf2-core.h                 | 4 +++-
 5 files changed, 15 insertions(+), 6 deletions(-)

diff --git a/drivers/media/v4l2-core/videobuf2-core.c b/drivers/media/v4l2-core/videobuf2-core.c
index 573f6fb..7aed8f2 100644
--- a/drivers/media/v4l2-core/videobuf2-core.c
+++ b/drivers/media/v4l2-core/videobuf2-core.c
@@ -189,6 +189,8 @@ static void __vb2_queue_cancel(struct vb2_queue *q);
 static int __vb2_buf_mem_alloc(struct vb2_buffer *vb)
 {
 	struct vb2_queue *q = vb->vb2_queue;
+	enum dma_data_direction dma_dir =
+		V4L2_TYPE_IS_OUTPUT(q->type) ? DMA_TO_DEVICE : DMA_FROM_DEVICE;
 	void *mem_priv;
 	int plane;
 
@@ -200,7 +202,7 @@ static int __vb2_buf_mem_alloc(struct vb2_buffer *vb)
 		unsigned long size = PAGE_ALIGN(q->plane_sizes[plane]);
 
 		mem_priv = call_ptr_memop(vb, alloc, q->alloc_ctx[plane],
-				      size, q->gfp_flags);
+				      size, dma_dir, q->gfp_flags);
 		if (IS_ERR_OR_NULL(mem_priv))
 			goto free;
 
diff --git a/drivers/media/v4l2-core/videobuf2-dma-contig.c b/drivers/media/v4l2-core/videobuf2-dma-contig.c
index 2bdffd3..c4305bf 100644
--- a/drivers/media/v4l2-core/videobuf2-dma-contig.c
+++ b/drivers/media/v4l2-core/videobuf2-dma-contig.c
@@ -155,7 +155,8 @@ static void vb2_dc_put(void *buf_priv)
 	kfree(buf);
 }
 
-static void *vb2_dc_alloc(void *alloc_ctx, unsigned long size, gfp_t gfp_flags)
+static void *vb2_dc_alloc(void *alloc_ctx, unsigned long size,
+			  enum dma_data_direction dma_dir, gfp_t gfp_flags)
 {
 	struct vb2_dc_conf *conf = alloc_ctx;
 	struct device *dev = conf->dev;
@@ -176,6 +177,7 @@ static void *vb2_dc_alloc(void *alloc_ctx, unsigned long size, gfp_t gfp_flags)
 	/* Prevent the device from being released while the buffer is used */
 	buf->dev = get_device(dev);
 	buf->size = size;
+	buf->dma_dir = dma_dir;
 
 	buf->handler.refcount = &buf->refcount;
 	buf->handler.put = vb2_dc_put;
diff --git a/drivers/media/v4l2-core/videobuf2-dma-sg.c b/drivers/media/v4l2-core/videobuf2-dma-sg.c
index 6b54a14..2529b83 100644
--- a/drivers/media/v4l2-core/videobuf2-dma-sg.c
+++ b/drivers/media/v4l2-core/videobuf2-dma-sg.c
@@ -86,7 +86,8 @@ static int vb2_dma_sg_alloc_compacted(struct vb2_dma_sg_buf *buf,
 	return 0;
 }
 
-static void *vb2_dma_sg_alloc(void *alloc_ctx, unsigned long size, gfp_t gfp_flags)
+static void *vb2_dma_sg_alloc(void *alloc_ctx, unsigned long size,
+			      enum dma_data_direction dma_dir, gfp_t gfp_flags)
 {
 	struct vb2_dma_sg_buf *buf;
 	int ret;
@@ -97,7 +98,7 @@ static void *vb2_dma_sg_alloc(void *alloc_ctx, unsigned long size, gfp_t gfp_fla
 		return NULL;
 
 	buf->vaddr = NULL;
-	buf->dma_dir = DMA_NONE;
+	buf->dma_dir = dma_dir;
 	buf->offset = 0;
 	buf->size = size;
 	/* size is already page aligned */
diff --git a/drivers/media/v4l2-core/videobuf2-vmalloc.c b/drivers/media/v4l2-core/videobuf2-vmalloc.c
index fc1eb45..bba2460 100644
--- a/drivers/media/v4l2-core/videobuf2-vmalloc.c
+++ b/drivers/media/v4l2-core/videobuf2-vmalloc.c
@@ -35,7 +35,8 @@ struct vb2_vmalloc_buf {
 
 static void vb2_vmalloc_put(void *buf_priv);
 
-static void *vb2_vmalloc_alloc(void *alloc_ctx, unsigned long size, gfp_t gfp_flags)
+static void *vb2_vmalloc_alloc(void *alloc_ctx, unsigned long size,
+			       enum dma_data_direction dma_dir, gfp_t gfp_flags)
 {
 	struct vb2_vmalloc_buf *buf;
 
@@ -45,6 +46,7 @@ static void *vb2_vmalloc_alloc(void *alloc_ctx, unsigned long size, gfp_t gfp_fl
 
 	buf->size = size;
 	buf->vaddr = vmalloc_user(buf->size);
+	buf->dma_dir = dma_dir;
 	buf->handler.refcount = &buf->refcount;
 	buf->handler.put = vb2_vmalloc_put;
 	buf->handler.arg = buf;
diff --git a/include/media/videobuf2-core.h b/include/media/videobuf2-core.h
index d607871..bd2cec2 100644
--- a/include/media/videobuf2-core.h
+++ b/include/media/videobuf2-core.h
@@ -82,7 +82,9 @@ struct vb2_threadio_data;
  *				  unmap_dmabuf.
  */
 struct vb2_mem_ops {
-	void		*(*alloc)(void *alloc_ctx, unsigned long size, gfp_t gfp_flags);
+	void		*(*alloc)(void *alloc_ctx, unsigned long size,
+				  enum dma_data_direction dma_dir,
+				  gfp_t gfp_flags);
 	void		(*put)(void *buf_priv);
 	struct dma_buf *(*get_dmabuf)(void *buf_priv, unsigned long flags);
 
-- 
2.1.1

