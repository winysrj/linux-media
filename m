Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr4.xs4all.nl ([194.109.24.24]:4229 "EHLO
	smtp-vbr4.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933331Ab3CHJWR (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 8 Mar 2013 04:22:17 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Marek Szyprowski <m.szyprowski@samsung.com>,
	Federico Vaga <federico.vaga@gmail.com>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [REVIEW PATCH 1/2] videobuf2: add gfp_flags.
Date: Fri,  8 Mar 2013 10:21:56 +0100
Message-Id: <6b64252b870ca5f3433b1d5ed2a2d1f977cd8f48.1362734097.git.hans.verkuil@cisco.com>
In-Reply-To: <1362734517-9420-1-git-send-email-hverkuil@xs4all.nl>
References: <1362734517-9420-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Some drivers have special memory requirements for their buffers, usually
related to DMA (e.g. GFP_DMA or __GFP_DMA32). Make it possible to specify
additional GFP flags for those buffers by adding a gfp_flags field to
vb2_queue.

Note that this field will be replaced in the future with a different
mechanism, but that is still work in progress and we need this feature
now so we won't be able to convert drivers with such requirements to vb2.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/v4l2-core/videobuf2-core.c       |    2 +-
 drivers/media/v4l2-core/videobuf2-dma-contig.c |    5 +++--
 drivers/media/v4l2-core/videobuf2-dma-sg.c     |    5 +++--
 drivers/media/v4l2-core/videobuf2-vmalloc.c    |    4 ++--
 include/media/videobuf2-core.h                 |   10 ++++++++--
 5 files changed, 17 insertions(+), 9 deletions(-)

diff --git a/drivers/media/v4l2-core/videobuf2-core.c b/drivers/media/v4l2-core/videobuf2-core.c
index be04481..70827fe 100644
--- a/drivers/media/v4l2-core/videobuf2-core.c
+++ b/drivers/media/v4l2-core/videobuf2-core.c
@@ -57,7 +57,7 @@ static int __vb2_buf_mem_alloc(struct vb2_buffer *vb)
 	/* Allocate memory for all planes in this buffer */
 	for (plane = 0; plane < vb->num_planes; ++plane) {
 		mem_priv = call_memop(q, alloc, q->alloc_ctx[plane],
-				      q->plane_sizes[plane]);
+				      q->plane_sizes[plane], q->gfp_flags);
 		if (IS_ERR_OR_NULL(mem_priv))
 			goto free;
 
diff --git a/drivers/media/v4l2-core/videobuf2-dma-contig.c b/drivers/media/v4l2-core/videobuf2-dma-contig.c
index 10beaee..ae35d25 100644
--- a/drivers/media/v4l2-core/videobuf2-dma-contig.c
+++ b/drivers/media/v4l2-core/videobuf2-dma-contig.c
@@ -152,7 +152,7 @@ static void vb2_dc_put(void *buf_priv)
 	kfree(buf);
 }
 
-static void *vb2_dc_alloc(void *alloc_ctx, unsigned long size)
+static void *vb2_dc_alloc(void *alloc_ctx, unsigned long size, gfp_t gfp_flags)
 {
 	struct vb2_dc_conf *conf = alloc_ctx;
 	struct device *dev = conf->dev;
@@ -165,7 +165,8 @@ static void *vb2_dc_alloc(void *alloc_ctx, unsigned long size)
 	/* align image size to PAGE_SIZE */
 	size = PAGE_ALIGN(size);
 
-	buf->vaddr = dma_alloc_coherent(dev, size, &buf->dma_addr, GFP_KERNEL);
+	buf->vaddr = dma_alloc_coherent(dev, size, &buf->dma_addr,
+						GFP_KERNEL | gfp_flags);
 	if (!buf->vaddr) {
 		dev_err(dev, "dma_alloc_coherent of size %ld failed\n", size);
 		kfree(buf);
diff --git a/drivers/media/v4l2-core/videobuf2-dma-sg.c b/drivers/media/v4l2-core/videobuf2-dma-sg.c
index 25c3b36..952776f 100644
--- a/drivers/media/v4l2-core/videobuf2-dma-sg.c
+++ b/drivers/media/v4l2-core/videobuf2-dma-sg.c
@@ -33,7 +33,7 @@ struct vb2_dma_sg_buf {
 
 static void vb2_dma_sg_put(void *buf_priv);
 
-static void *vb2_dma_sg_alloc(void *alloc_ctx, unsigned long size)
+static void *vb2_dma_sg_alloc(void *alloc_ctx, unsigned long size, gfp_t gfp_flags)
 {
 	struct vb2_dma_sg_buf *buf;
 	int i;
@@ -60,7 +60,8 @@ static void *vb2_dma_sg_alloc(void *alloc_ctx, unsigned long size)
 		goto fail_pages_array_alloc;
 
 	for (i = 0; i < buf->sg_desc.num_pages; ++i) {
-		buf->pages[i] = alloc_page(GFP_KERNEL | __GFP_ZERO | __GFP_NOWARN);
+		buf->pages[i] = alloc_page(GFP_KERNEL | __GFP_ZERO |
+					   __GFP_NOWARN | gfp_flags);
 		if (NULL == buf->pages[i])
 			goto fail_pages_alloc;
 		sg_set_page(&buf->sg_desc.sglist[i],
diff --git a/drivers/media/v4l2-core/videobuf2-vmalloc.c b/drivers/media/v4l2-core/videobuf2-vmalloc.c
index a47fd4f..313d977 100644
--- a/drivers/media/v4l2-core/videobuf2-vmalloc.c
+++ b/drivers/media/v4l2-core/videobuf2-vmalloc.c
@@ -35,11 +35,11 @@ struct vb2_vmalloc_buf {
 
 static void vb2_vmalloc_put(void *buf_priv);
 
-static void *vb2_vmalloc_alloc(void *alloc_ctx, unsigned long size)
+static void *vb2_vmalloc_alloc(void *alloc_ctx, unsigned long size, gfp_t gfp_flags)
 {
 	struct vb2_vmalloc_buf *buf;
 
-	buf = kzalloc(sizeof(*buf), GFP_KERNEL);
+	buf = kzalloc(sizeof(*buf), GFP_KERNEL | gfp_flags);
 	if (!buf)
 		return NULL;
 
diff --git a/include/media/videobuf2-core.h b/include/media/videobuf2-core.h
index a2d4274..d88a098 100644
--- a/include/media/videobuf2-core.h
+++ b/include/media/videobuf2-core.h
@@ -27,7 +27,9 @@ struct vb2_fileio_data;
  *		return NULL on failure or a pointer to allocator private,
  *		per-buffer data on success; the returned private structure
  *		will then be passed as buf_priv argument to other ops in this
- *		structure
+ *		structure. Additional gfp_flags to use when allocating the
+ *		are also passed to this operation. These flags are from the
+ *		gfp_flags field of vb2_queue.
  * @put:	inform the allocator that the buffer will no longer be used;
  *		usually will result in the allocator freeing the buffer (if
  *		no other users of this buffer are present); the buf_priv
@@ -79,7 +81,7 @@ struct vb2_fileio_data;
  *				  unmap_dmabuf.
  */
 struct vb2_mem_ops {
-	void		*(*alloc)(void *alloc_ctx, unsigned long size);
+	void		*(*alloc)(void *alloc_ctx, unsigned long size, gfp_t gfp_flags);
 	void		(*put)(void *buf_priv);
 	struct dma_buf *(*get_dmabuf)(void *buf_priv);
 
@@ -302,6 +304,9 @@ struct v4l2_fh;
  * @buf_struct_size: size of the driver-specific buffer structure;
  *		"0" indicates the driver doesn't want to use a custom buffer
  *		structure type, so sizeof(struct vb2_buffer) will is used
+ * @gfp_flags:	additional gfp flags used when allocating the buffers.
+ *		Typically this is 0, but it may be e.g. GFP_DMA or __GFP_DMA32
+ *		to force the buffer allocation to a specific memory zone.
  *
  * @memory:	current memory type used
  * @bufs:	videobuf buffer structures
@@ -327,6 +332,7 @@ struct vb2_queue {
 	void				*drv_priv;
 	unsigned int			buf_struct_size;
 	u32				timestamp_type;
+	gfp_t				gfp_flags;
 
 /* private: internal use only */
 	enum v4l2_memory		memory;
-- 
1.7.10.4

