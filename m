Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud2.xs4all.net ([194.109.24.29]:37576 "EHLO
	lb3-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751696AbcF0NcP (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 27 Jun 2016 09:32:15 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>,
	Sakari Ailus <sakari.ailus@iki.fi>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Subject: [PATCHv5 01/13] vb2: move dma_attrs to vb2_queue
Date: Mon, 27 Jun 2016 15:31:52 +0200
Message-Id: <1467034324-37626-2-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1467034324-37626-1-git-send-email-hverkuil@xs4all.nl>
References: <1467034324-37626-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Make the dma attributes struct part of vb2_queue. This greatly simplifies
the remainder of the patch series since the dma_contig alloc context is
now (as before) just a struct device pointer.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Sakari Ailus <sakari.ailus@iki.fi>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
---
 drivers/media/v4l2-core/videobuf2-core.c       |  2 +-
 drivers/media/v4l2-core/videobuf2-dma-contig.c | 16 +++++++---------
 drivers/media/v4l2-core/videobuf2-dma-sg.c     |  5 +++--
 drivers/media/v4l2-core/videobuf2-vmalloc.c    |  5 +++--
 include/media/videobuf2-core.h                 |  7 ++++---
 include/media/videobuf2-dma-contig.h           |  9 +--------
 6 files changed, 19 insertions(+), 25 deletions(-)

diff --git a/drivers/media/v4l2-core/videobuf2-core.c b/drivers/media/v4l2-core/videobuf2-core.c
index 633fc1a..36f4392 100644
--- a/drivers/media/v4l2-core/videobuf2-core.c
+++ b/drivers/media/v4l2-core/videobuf2-core.c
@@ -207,7 +207,7 @@ static int __vb2_buf_mem_alloc(struct vb2_buffer *vb)
 		unsigned long size = PAGE_ALIGN(vb->planes[plane].length);
 
 		mem_priv = call_ptr_memop(vb, alloc, q->alloc_ctx[plane],
-				      size, dma_dir, q->gfp_flags);
+				q->dma_attrs, size, dma_dir, q->gfp_flags);
 		if (IS_ERR_OR_NULL(mem_priv))
 			goto free;
 
diff --git a/drivers/media/v4l2-core/videobuf2-dma-contig.c b/drivers/media/v4l2-core/videobuf2-dma-contig.c
index e3e47ac..a7825c6 100644
--- a/drivers/media/v4l2-core/videobuf2-dma-contig.c
+++ b/drivers/media/v4l2-core/videobuf2-dma-contig.c
@@ -23,7 +23,6 @@
 
 struct vb2_dc_conf {
 	struct device		*dev;
-	struct dma_attrs	attrs;
 };
 
 struct vb2_dc_buf {
@@ -140,8 +139,9 @@ static void vb2_dc_put(void *buf_priv)
 	kfree(buf);
 }
 
-static void *vb2_dc_alloc(void *alloc_ctx, unsigned long size,
-			  enum dma_data_direction dma_dir, gfp_t gfp_flags)
+static void *vb2_dc_alloc(void *alloc_ctx, const struct dma_attrs *attrs,
+			  unsigned long size, enum dma_data_direction dma_dir,
+			  gfp_t gfp_flags)
 {
 	struct vb2_dc_conf *conf = alloc_ctx;
 	struct device *dev = conf->dev;
@@ -151,7 +151,8 @@ static void *vb2_dc_alloc(void *alloc_ctx, unsigned long size,
 	if (!buf)
 		return ERR_PTR(-ENOMEM);
 
-	buf->attrs = conf->attrs;
+	if (attrs)
+		buf->attrs = *attrs;
 	buf->cookie = dma_alloc_attrs(dev, size, &buf->dma_addr,
 					GFP_KERNEL | gfp_flags, &buf->attrs);
 	if (!buf->cookie) {
@@ -729,8 +730,7 @@ const struct vb2_mem_ops vb2_dma_contig_memops = {
 };
 EXPORT_SYMBOL_GPL(vb2_dma_contig_memops);
 
-void *vb2_dma_contig_init_ctx_attrs(struct device *dev,
-				    struct dma_attrs *attrs)
+void *vb2_dma_contig_init_ctx(struct device *dev)
 {
 	struct vb2_dc_conf *conf;
 
@@ -739,12 +739,10 @@ void *vb2_dma_contig_init_ctx_attrs(struct device *dev,
 		return ERR_PTR(-ENOMEM);
 
 	conf->dev = dev;
-	if (attrs)
-		conf->attrs = *attrs;
 
 	return conf;
 }
-EXPORT_SYMBOL_GPL(vb2_dma_contig_init_ctx_attrs);
+EXPORT_SYMBOL_GPL(vb2_dma_contig_init_ctx);
 
 void vb2_dma_contig_cleanup_ctx(void *alloc_ctx)
 {
diff --git a/drivers/media/v4l2-core/videobuf2-dma-sg.c b/drivers/media/v4l2-core/videobuf2-dma-sg.c
index 9985c89..e7153f7 100644
--- a/drivers/media/v4l2-core/videobuf2-dma-sg.c
+++ b/drivers/media/v4l2-core/videobuf2-dma-sg.c
@@ -99,8 +99,9 @@ static int vb2_dma_sg_alloc_compacted(struct vb2_dma_sg_buf *buf,
 	return 0;
 }
 
-static void *vb2_dma_sg_alloc(void *alloc_ctx, unsigned long size,
-			      enum dma_data_direction dma_dir, gfp_t gfp_flags)
+static void *vb2_dma_sg_alloc(void *alloc_ctx, const struct dma_attrs *dma_attrs,
+			      unsigned long size, enum dma_data_direction dma_dir,
+			      gfp_t gfp_flags)
 {
 	struct vb2_dma_sg_conf *conf = alloc_ctx;
 	struct vb2_dma_sg_buf *buf;
diff --git a/drivers/media/v4l2-core/videobuf2-vmalloc.c b/drivers/media/v4l2-core/videobuf2-vmalloc.c
index 1c30274..fb94c80 100644
--- a/drivers/media/v4l2-core/videobuf2-vmalloc.c
+++ b/drivers/media/v4l2-core/videobuf2-vmalloc.c
@@ -33,8 +33,9 @@ struct vb2_vmalloc_buf {
 
 static void vb2_vmalloc_put(void *buf_priv);
 
-static void *vb2_vmalloc_alloc(void *alloc_ctx, unsigned long size,
-			       enum dma_data_direction dma_dir, gfp_t gfp_flags)
+static void *vb2_vmalloc_alloc(void *alloc_ctx, const struct dma_attrs *attrs,
+			       unsigned long size, enum dma_data_direction dma_dir,
+			       gfp_t gfp_flags)
 {
 	struct vb2_vmalloc_buf *buf;
 
diff --git a/include/media/videobuf2-core.h b/include/media/videobuf2-core.h
index 88e3ab4..444ef3b 100644
--- a/include/media/videobuf2-core.h
+++ b/include/media/videobuf2-core.h
@@ -27,7 +27,6 @@ enum vb2_memory {
 	VB2_MEMORY_DMABUF	= 4,
 };
 
-struct vb2_alloc_ctx;
 struct vb2_fileio_data;
 struct vb2_threadio_data;
 
@@ -93,8 +92,8 @@ struct vb2_threadio_data;
  *				  unmap_dmabuf.
  */
 struct vb2_mem_ops {
-	void		*(*alloc)(void *alloc_ctx, unsigned long size,
-				  enum dma_data_direction dma_dir,
+	void		*(*alloc)(void *alloc_ctx, const struct dma_attrs *attrs,
+				  unsigned long size, enum dma_data_direction dma_dir,
 				  gfp_t gfp_flags);
 	void		(*put)(void *buf_priv);
 	struct dma_buf *(*get_dmabuf)(void *buf_priv, unsigned long flags);
@@ -401,6 +400,7 @@ struct vb2_buf_ops {
  *		caller. For example, for V4L2, it should match
  *		the V4L2_BUF_TYPE_* in include/uapi/linux/videodev2.h
  * @io_modes:	supported io methods (see vb2_io_modes enum)
+ * @dma_attrs:	DMA attributes to use for the DMA. May be NULL.
  * @fileio_read_once:		report EOF after reading the first buffer
  * @fileio_write_immediately:	queue buffer after each write() call
  * @allow_zero_bytesused:	allow bytesused == 0 to be passed to the driver
@@ -467,6 +467,7 @@ struct vb2_buf_ops {
 struct vb2_queue {
 	unsigned int			type;
 	unsigned int			io_modes;
+	const struct dma_attrs		*dma_attrs;
 	unsigned			fileio_read_once:1;
 	unsigned			fileio_write_immediately:1;
 	unsigned			allow_zero_bytesused:1;
diff --git a/include/media/videobuf2-dma-contig.h b/include/media/videobuf2-dma-contig.h
index f7dc840..5bdd4a4 100644
--- a/include/media/videobuf2-dma-contig.h
+++ b/include/media/videobuf2-dma-contig.h
@@ -26,14 +26,7 @@ vb2_dma_contig_plane_dma_addr(struct vb2_buffer *vb, unsigned int plane_no)
 	return *addr;
 }
 
-void *vb2_dma_contig_init_ctx_attrs(struct device *dev,
-				    struct dma_attrs *attrs);
-
-static inline void *vb2_dma_contig_init_ctx(struct device *dev)
-{
-	return vb2_dma_contig_init_ctx_attrs(dev, NULL);
-}
-
+void *vb2_dma_contig_init_ctx(struct device *dev);
 void vb2_dma_contig_cleanup_ctx(void *alloc_ctx);
 int vb2_dma_contig_set_max_seg_size(struct device *dev, unsigned int size);
 void vb2_dma_contig_clear_max_seg_size(struct device *dev);
-- 
2.8.1

