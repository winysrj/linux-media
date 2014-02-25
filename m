Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr6.xs4all.nl ([194.109.24.26]:3801 "EHLO
	smtp-vbr6.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753081AbaBYKEo (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 25 Feb 2014 05:04:44 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: pawel@osciak.com, s.nawrocki@samsung.com, m.szyprowski@samsung.com,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFCv1 PATCH 04/20] vb2-dma-sg: add allocation context to dma-sg
Date: Tue, 25 Feb 2014 11:04:09 +0100
Message-Id: <1393322665-29889-5-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1393322665-29889-1-git-send-email-hverkuil@xs4all.nl>
References: <1393322665-29889-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Require that dma-sg also uses an allocation context. This is in preparation
for adding prepare/finish memops to sync the memory between DMA and CPU.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/platform/marvell-ccic/mcam-core.c    |  7 ++++
 drivers/media/platform/marvell-ccic/mcam-core.h    |  1 +
 drivers/media/v4l2-core/videobuf2-core.c           |  3 +-
 drivers/media/v4l2-core/videobuf2-dma-contig.c     |  4 +-
 drivers/media/v4l2-core/videobuf2-dma-sg.c         | 44 +++++++++++++++++++++-
 drivers/media/v4l2-core/videobuf2-vmalloc.c        |  3 +-
 drivers/staging/media/solo6x10/solo6x10-v4l2-enc.c | 10 +++++
 drivers/staging/media/solo6x10/solo6x10.h          |  1 +
 include/media/videobuf2-core.h                     |  3 +-
 include/media/videobuf2-dma-sg.h                   |  3 ++
 10 files changed, 73 insertions(+), 6 deletions(-)

diff --git a/drivers/media/platform/marvell-ccic/mcam-core.c b/drivers/media/platform/marvell-ccic/mcam-core.c
index be4b512..99961bf 100644
--- a/drivers/media/platform/marvell-ccic/mcam-core.c
+++ b/drivers/media/platform/marvell-ccic/mcam-core.c
@@ -1080,6 +1080,8 @@ static int mcam_vb_queue_setup(struct vb2_queue *vq,
 		*nbufs = minbufs;
 	if (cam->buffer_mode == B_DMA_contig)
 		alloc_ctxs[0] = cam->vb_alloc_ctx;
+	else if (cam->buffer_mode == B_DMA_sg)
+		alloc_ctxs[0] = cam->vb_alloc_ctx_sg;
 	return 0;
 }
 
@@ -1298,6 +1300,7 @@ static int mcam_setup_vb2(struct mcam_camera *cam)
 		vq->ops = &mcam_vb2_sg_ops;
 		vq->mem_ops = &vb2_dma_sg_memops;
 		vq->buf_struct_size = sizeof(struct mcam_vb_buffer);
+		cam->vb_alloc_ctx_sg = vb2_dma_sg_init_ctx(cam->dev);
 		vq->io_modes = VB2_MMAP | VB2_USERPTR;
 		cam->dma_setup = mcam_ctlr_dma_sg;
 		cam->frame_complete = mcam_dma_sg_done;
@@ -1326,6 +1329,10 @@ static void mcam_cleanup_vb2(struct mcam_camera *cam)
 	if (cam->buffer_mode == B_DMA_contig)
 		vb2_dma_contig_cleanup_ctx(cam->vb_alloc_ctx);
 #endif
+#ifdef MCAM_MODE_DMA_SG
+	if (cam->buffer_mode == B_DMA_sg)
+		vb2_dma_sg_cleanup_ctx(cam->vb_alloc_ctx_sg);
+#endif
 }
 
 
diff --git a/drivers/media/platform/marvell-ccic/mcam-core.h b/drivers/media/platform/marvell-ccic/mcam-core.h
index e0e628c..7b8c201 100644
--- a/drivers/media/platform/marvell-ccic/mcam-core.h
+++ b/drivers/media/platform/marvell-ccic/mcam-core.h
@@ -176,6 +176,7 @@ struct mcam_camera {
 	/* DMA buffers - DMA modes */
 	struct mcam_vb_buffer *vb_bufs[MAX_DMA_BUFS];
 	struct vb2_alloc_ctx *vb_alloc_ctx;
+	struct vb2_alloc_ctx *vb_alloc_ctx_sg;
 
 	/* Mode-specific ops, set at open time */
 	void (*dma_setup)(struct mcam_camera *cam);
diff --git a/drivers/media/v4l2-core/videobuf2-core.c b/drivers/media/v4l2-core/videobuf2-core.c
index 8070ccc..bb36fe5 100644
--- a/drivers/media/v4l2-core/videobuf2-core.c
+++ b/drivers/media/v4l2-core/videobuf2-core.c
@@ -102,6 +102,7 @@ module_param(debug, int, 0644);
 static int __vb2_buf_mem_alloc(struct vb2_buffer *vb)
 {
 	struct vb2_queue *q = vb->vb2_queue;
+	int write = !V4L2_TYPE_IS_OUTPUT(q->type);
 	void *mem_priv;
 	int plane;
 
@@ -113,7 +114,7 @@ static int __vb2_buf_mem_alloc(struct vb2_buffer *vb)
 		unsigned long size = PAGE_ALIGN(q->plane_sizes[plane]);
 
 		mem_priv = call_memop(vb, alloc, q->alloc_ctx[plane],
-				      size, q->gfp_flags);
+				      size, write, q->gfp_flags);
 		if (IS_ERR_OR_NULL(mem_priv))
 			goto free;
 
diff --git a/drivers/media/v4l2-core/videobuf2-dma-contig.c b/drivers/media/v4l2-core/videobuf2-dma-contig.c
index 33d3871d..1e994a9 100644
--- a/drivers/media/v4l2-core/videobuf2-dma-contig.c
+++ b/drivers/media/v4l2-core/videobuf2-dma-contig.c
@@ -152,7 +152,8 @@ static void vb2_dc_put(void *buf_priv)
 	kfree(buf);
 }
 
-static void *vb2_dc_alloc(void *alloc_ctx, unsigned long size, gfp_t gfp_flags)
+static void *vb2_dc_alloc(void *alloc_ctx, unsigned long size, int write,
+			  gfp_t gfp_flags)
 {
 	struct vb2_dc_conf *conf = alloc_ctx;
 	struct device *dev = conf->dev;
@@ -173,6 +174,7 @@ static void *vb2_dc_alloc(void *alloc_ctx, unsigned long size, gfp_t gfp_flags)
 	/* Prevent the device from being released while the buffer is used */
 	buf->dev = get_device(dev);
 	buf->size = size;
+	buf->dma_dir = write ? DMA_FROM_DEVICE : DMA_TO_DEVICE;
 
 	buf->handler.refcount = &buf->refcount;
 	buf->handler.put = vb2_dc_put;
diff --git a/drivers/media/v4l2-core/videobuf2-dma-sg.c b/drivers/media/v4l2-core/videobuf2-dma-sg.c
index c779f21..92b54fa 100644
--- a/drivers/media/v4l2-core/videobuf2-dma-sg.c
+++ b/drivers/media/v4l2-core/videobuf2-dma-sg.c
@@ -30,11 +30,17 @@ module_param(debug, int, 0644);
 			printk(KERN_DEBUG "vb2-dma-sg: " fmt, ## arg);	\
 	} while (0)
 
+struct vb2_dma_sg_conf {
+	struct device		*dev;
+};
+
 struct vb2_dma_sg_buf {
+	struct device			*dev;
 	void				*vaddr;
 	struct page			**pages;
 	int				write;
 	int				offset;
+	enum dma_data_direction		dma_dir;
 	struct sg_table			sg_table;
 	size_t				size;
 	unsigned int			num_pages;
@@ -86,22 +92,27 @@ static int vb2_dma_sg_alloc_compacted(struct vb2_dma_sg_buf *buf,
 	return 0;
 }
 
-static void *vb2_dma_sg_alloc(void *alloc_ctx, unsigned long size, gfp_t gfp_flags)
+static void *vb2_dma_sg_alloc(void *alloc_ctx, unsigned long size, int write,
+			      gfp_t gfp_flags)
 {
+	struct vb2_dma_sg_conf *conf = alloc_ctx;
 	struct vb2_dma_sg_buf *buf;
 	int ret;
 	int num_pages;
 
+	if (WARN_ON(alloc_ctx == NULL))
+		return NULL;
 	buf = kzalloc(sizeof *buf, GFP_KERNEL);
 	if (!buf)
 		return NULL;
 
 	buf->vaddr = NULL;
-	buf->write = 0;
+	buf->write = write;
 	buf->offset = 0;
 	buf->size = size;
 	/* size is already page aligned */
 	buf->num_pages = size >> PAGE_SHIFT;
+	buf->dma_dir = write ? DMA_FROM_DEVICE : DMA_TO_DEVICE;
 
 	buf->pages = kzalloc(buf->num_pages * sizeof(struct page *),
 			     GFP_KERNEL);
@@ -117,6 +128,8 @@ static void *vb2_dma_sg_alloc(void *alloc_ctx, unsigned long size, gfp_t gfp_fla
 	if (ret)
 		goto fail_table_alloc;
 
+	/* Prevent the device from being released while the buffer is used */
+	buf->dev = get_device(conf->dev);
 	buf->handler.refcount = &buf->refcount;
 	buf->handler.put = vb2_dma_sg_put;
 	buf->handler.arg = buf;
@@ -152,6 +165,7 @@ static void vb2_dma_sg_put(void *buf_priv)
 		while (--i >= 0)
 			__free_page(buf->pages[i]);
 		kfree(buf->pages);
+		put_device(buf->dev);
 		kfree(buf);
 	}
 }
@@ -164,6 +178,7 @@ static inline int vma_is_io(struct vm_area_struct *vma)
 static void *vb2_dma_sg_get_userptr(void *alloc_ctx, unsigned long vaddr,
 				    unsigned long size, int write)
 {
+	struct vb2_dma_sg_conf *conf = alloc_ctx;
 	struct vb2_dma_sg_buf *buf;
 	unsigned long first, last;
 	int num_pages_from_user;
@@ -177,6 +192,7 @@ static void *vb2_dma_sg_get_userptr(void *alloc_ctx, unsigned long vaddr,
 	buf->write = write;
 	buf->offset = vaddr & ~PAGE_MASK;
 	buf->size = size;
+	buf->dma_dir = write ? DMA_FROM_DEVICE : DMA_TO_DEVICE;
 
 	first = (vaddr           & PAGE_MASK) >> PAGE_SHIFT;
 	last  = ((vaddr + size - 1) & PAGE_MASK) >> PAGE_SHIFT;
@@ -233,6 +249,8 @@ static void *vb2_dma_sg_get_userptr(void *alloc_ctx, unsigned long vaddr,
 			buf->num_pages, buf->offset, size, 0))
 		goto userptr_fail_alloc_table_from_pages;
 
+	/* Prevent the device from being released while the buffer is used */
+	buf->dev = get_device(conf->dev);
 	return buf;
 
 userptr_fail_alloc_table_from_pages:
@@ -272,6 +290,7 @@ static void vb2_dma_sg_put_userptr(void *buf_priv)
 	}
 	kfree(buf->pages);
 	vb2_put_vma(buf->vma);
+	put_device(buf->dev);
 	kfree(buf);
 }
 
@@ -354,6 +373,27 @@ const struct vb2_mem_ops vb2_dma_sg_memops = {
 };
 EXPORT_SYMBOL_GPL(vb2_dma_sg_memops);
 
+void *vb2_dma_sg_init_ctx(struct device *dev)
+{
+	struct vb2_dma_sg_conf *conf;
+
+	conf = kzalloc(sizeof(*conf), GFP_KERNEL);
+	if (!conf)
+		return ERR_PTR(-ENOMEM);
+
+	conf->dev = dev;
+
+	return conf;
+}
+EXPORT_SYMBOL_GPL(vb2_dma_sg_init_ctx);
+
+void vb2_dma_sg_cleanup_ctx(void *alloc_ctx)
+{
+	if (!IS_ERR_OR_NULL(alloc_ctx))
+		kfree(alloc_ctx);
+}
+EXPORT_SYMBOL_GPL(vb2_dma_sg_cleanup_ctx);
+
 MODULE_DESCRIPTION("dma scatter/gather memory handling routines for videobuf2");
 MODULE_AUTHOR("Andrzej Pietrasiewicz");
 MODULE_LICENSE("GPL");
diff --git a/drivers/media/v4l2-core/videobuf2-vmalloc.c b/drivers/media/v4l2-core/videobuf2-vmalloc.c
index 313d977..d77e397 100644
--- a/drivers/media/v4l2-core/videobuf2-vmalloc.c
+++ b/drivers/media/v4l2-core/videobuf2-vmalloc.c
@@ -35,7 +35,8 @@ struct vb2_vmalloc_buf {
 
 static void vb2_vmalloc_put(void *buf_priv);
 
-static void *vb2_vmalloc_alloc(void *alloc_ctx, unsigned long size, gfp_t gfp_flags)
+static void *vb2_vmalloc_alloc(void *alloc_ctx, unsigned long size, int write,
+			       gfp_t gfp_flags)
 {
 	struct vb2_vmalloc_buf *buf;
 
diff --git a/drivers/staging/media/solo6x10/solo6x10-v4l2-enc.c b/drivers/staging/media/solo6x10/solo6x10-v4l2-enc.c
index 5008b0f..efa6772 100644
--- a/drivers/staging/media/solo6x10/solo6x10-v4l2-enc.c
+++ b/drivers/staging/media/solo6x10/solo6x10-v4l2-enc.c
@@ -684,7 +684,10 @@ static int solo_enc_queue_setup(struct vb2_queue *q, const struct v4l2_format *f
 			   unsigned int *num_buffers, unsigned int *num_planes,
 			   unsigned int sizes[], void *alloc_ctxs[])
 {
+	struct solo_enc_dev *solo_enc = vb2_get_drv_priv(q);
+
 	sizes[0] = FRAME_BUF_SIZE;
+	alloc_ctxs[0] = solo_enc->alloc_ctx;
 	*num_planes = 1;
 
 	if (*num_buffers < MIN_VID_BUFFERS)
@@ -1241,6 +1244,11 @@ static struct solo_enc_dev *solo_enc_alloc(struct solo_dev *solo_dev,
 		return ERR_PTR(-ENOMEM);
 
 	hdl = &solo_enc->hdl;
+	solo_enc->alloc_ctx = vb2_dma_sg_init_ctx(&solo_dev->pdev->dev);
+	if (IS_ERR(solo_enc->alloc_ctx)) {
+		ret = -ENOMEM;
+		goto hdl_free;
+	}
 	v4l2_ctrl_handler_init(hdl, 10);
 	v4l2_ctrl_new_std(hdl, &solo_ctrl_ops,
 			V4L2_CID_BRIGHTNESS, 0, 255, 1, 128);
@@ -1340,6 +1348,7 @@ pci_free:
 			solo_enc->desc_items, solo_enc->desc_dma);
 hdl_free:
 	v4l2_ctrl_handler_free(hdl);
+	vb2_dma_sg_cleanup_ctx(solo_enc->alloc_ctx);
 	kfree(solo_enc);
 	return ERR_PTR(ret);
 }
@@ -1351,6 +1360,7 @@ static void solo_enc_free(struct solo_enc_dev *solo_enc)
 
 	video_unregister_device(solo_enc->vfd);
 	v4l2_ctrl_handler_free(&solo_enc->hdl);
+	vb2_dma_sg_cleanup_ctx(solo_enc->alloc_ctx);
 	kfree(solo_enc);
 }
 
diff --git a/drivers/staging/media/solo6x10/solo6x10.h b/drivers/staging/media/solo6x10/solo6x10.h
index 8964f8b..06bfee5 100644
--- a/drivers/staging/media/solo6x10/solo6x10.h
+++ b/drivers/staging/media/solo6x10/solo6x10.h
@@ -198,6 +198,7 @@ struct solo_enc_dev {
 	u32			sequence;
 	struct vb2_queue	vidq;
 	struct list_head	vidq_active;
+	void			*alloc_ctx;
 	int			desc_count;
 	int			desc_nelts;
 	struct solo_p2m_desc	*desc_items;
diff --git a/include/media/videobuf2-core.h b/include/media/videobuf2-core.h
index cb14c1a..4b7fed0 100644
--- a/include/media/videobuf2-core.h
+++ b/include/media/videobuf2-core.h
@@ -81,7 +81,8 @@ struct vb2_fileio_data;
  *				  unmap_dmabuf.
  */
 struct vb2_mem_ops {
-	void		*(*alloc)(void *alloc_ctx, unsigned long size, gfp_t gfp_flags);
+	void		*(*alloc)(void *alloc_ctx, unsigned long size, int write,
+				  gfp_t gfp_flags);
 	void		(*put)(void *buf_priv);
 	struct dma_buf *(*get_dmabuf)(void *buf_priv, unsigned long flags);
 
diff --git a/include/media/videobuf2-dma-sg.h b/include/media/videobuf2-dma-sg.h
index 7b89852..14ce306 100644
--- a/include/media/videobuf2-dma-sg.h
+++ b/include/media/videobuf2-dma-sg.h
@@ -21,6 +21,9 @@ static inline struct sg_table *vb2_dma_sg_plane_desc(
 	return (struct sg_table *)vb2_plane_cookie(vb, plane_no);
 }
 
+void *vb2_dma_sg_init_ctx(struct device *dev);
+void vb2_dma_sg_cleanup_ctx(void *alloc_ctx);
+
 extern const struct vb2_mem_ops vb2_dma_sg_memops;
 
 #endif
-- 
1.9.0

