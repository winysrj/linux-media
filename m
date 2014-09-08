Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr4.xs4all.nl ([194.109.24.24]:4397 "EHLO
	smtp-vbr4.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753795AbaIHOPE (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 8 Sep 2014 10:15:04 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: pawel@osciak.com, laurent.pinchart@ideasonboard.com,
	m.szyprowski@samsung.com, Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFC PATCH 02/12] vb2-dma-sg: add allocation context to dma-sg
Date: Mon,  8 Sep 2014 16:14:31 +0200
Message-Id: <1410185681-20111-3-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1410185681-20111-1-git-send-email-hverkuil@xs4all.nl>
References: <1410185681-20111-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Require that dma-sg also uses an allocation context. This is in preparation
for adding prepare/finish memops to sync the memory between DMA and CPU.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/pci/saa7134/saa7134-core.c        | 18 +++++++---
 drivers/media/pci/saa7134/saa7134-ts.c          |  1 +
 drivers/media/pci/saa7134/saa7134-vbi.c         |  1 +
 drivers/media/pci/saa7134/saa7134-video.c       |  1 +
 drivers/media/pci/saa7134/saa7134.h             |  1 +
 drivers/media/pci/solo6x10/solo6x10-v4l2-enc.c  | 10 ++++++
 drivers/media/pci/solo6x10/solo6x10.h           |  1 +
 drivers/media/platform/marvell-ccic/mcam-core.c |  7 ++++
 drivers/media/platform/marvell-ccic/mcam-core.h |  1 +
 drivers/media/v4l2-core/videobuf2-core.c        |  3 +-
 drivers/media/v4l2-core/videobuf2-dma-contig.c  |  4 ++-
 drivers/media/v4l2-core/videobuf2-dma-sg.c      | 44 +++++++++++++++++++++++--
 drivers/media/v4l2-core/videobuf2-vmalloc.c     |  3 +-
 include/media/videobuf2-core.h                  |  3 +-
 include/media/videobuf2-dma-sg.h                |  3 ++
 15 files changed, 90 insertions(+), 11 deletions(-)

diff --git a/drivers/media/pci/saa7134/saa7134-core.c b/drivers/media/pci/saa7134/saa7134-core.c
index 9ff03a6..b63529a 100644
--- a/drivers/media/pci/saa7134/saa7134-core.c
+++ b/drivers/media/pci/saa7134/saa7134-core.c
@@ -995,13 +995,18 @@ static int saa7134_initdev(struct pci_dev *pci_dev,
 	saa7134_board_init1(dev);
 	saa7134_hwinit1(dev);
 
+	dev->alloc_ctx = vb2_dma_sg_init_ctx(&pci_dev->dev);
+	if (IS_ERR(dev->alloc_ctx)) {
+		err = -ENOMEM;
+		goto fail3;
+	}
 	/* get irq */
 	err = request_irq(pci_dev->irq, saa7134_irq,
 			  IRQF_SHARED, dev->name, dev);
 	if (err < 0) {
 		printk(KERN_ERR "%s: can't get IRQ %d\n",
 		       dev->name,pci_dev->irq);
-		goto fail3;
+		goto fail4;
 	}
 
 	/* wait a bit, register i2c bus */
@@ -1059,7 +1064,7 @@ static int saa7134_initdev(struct pci_dev *pci_dev,
 	if (err < 0) {
 		printk(KERN_INFO "%s: can't register video device\n",
 		       dev->name);
-		goto fail4;
+		goto fail5;
 	}
 	printk(KERN_INFO "%s: registered device %s [v4l2]\n",
 	       dev->name, video_device_node_name(dev->video_dev));
@@ -1072,7 +1077,7 @@ static int saa7134_initdev(struct pci_dev *pci_dev,
 	err = video_register_device(dev->vbi_dev,VFL_TYPE_VBI,
 				    vbi_nr[dev->nr]);
 	if (err < 0)
-		goto fail4;
+		goto fail5;
 	printk(KERN_INFO "%s: registered device %s\n",
 	       dev->name, video_device_node_name(dev->vbi_dev));
 
@@ -1083,7 +1088,7 @@ static int saa7134_initdev(struct pci_dev *pci_dev,
 		err = video_register_device(dev->radio_dev,VFL_TYPE_RADIO,
 					    radio_nr[dev->nr]);
 		if (err < 0)
-			goto fail4;
+			goto fail5;
 		printk(KERN_INFO "%s: registered device %s\n",
 		       dev->name, video_device_node_name(dev->radio_dev));
 	}
@@ -1097,10 +1102,12 @@ static int saa7134_initdev(struct pci_dev *pci_dev,
 	request_submodules(dev);
 	return 0;
 
- fail4:
+ fail5:
 	saa7134_unregister_video(dev);
 	saa7134_i2c_unregister(dev);
 	free_irq(pci_dev->irq, dev);
+ fail4:
+	vb2_dma_sg_cleanup_ctx(dev->alloc_ctx);
  fail3:
 	saa7134_hwfini(dev);
 	iounmap(dev->lmmio);
@@ -1167,6 +1174,7 @@ static void saa7134_finidev(struct pci_dev *pci_dev)
 
 	/* release resources */
 	free_irq(pci_dev->irq, dev);
+	vb2_dma_sg_cleanup_ctx(dev->alloc_ctx);
 	iounmap(dev->lmmio);
 	release_mem_region(pci_resource_start(pci_dev,0),
 			   pci_resource_len(pci_dev,0));
diff --git a/drivers/media/pci/saa7134/saa7134-ts.c b/drivers/media/pci/saa7134/saa7134-ts.c
index bd25323..8eff4a7 100644
--- a/drivers/media/pci/saa7134/saa7134-ts.c
+++ b/drivers/media/pci/saa7134/saa7134-ts.c
@@ -142,6 +142,7 @@ int saa7134_ts_queue_setup(struct vb2_queue *q, const struct v4l2_format *fmt,
 		*nbuffers = 3;
 	*nplanes = 1;
 	sizes[0] = size;
+	alloc_ctxs[0] = dev->alloc_ctx;
 	return 0;
 }
 EXPORT_SYMBOL_GPL(saa7134_ts_queue_setup);
diff --git a/drivers/media/pci/saa7134/saa7134-vbi.c b/drivers/media/pci/saa7134/saa7134-vbi.c
index c06dbe1..803e7df 100644
--- a/drivers/media/pci/saa7134/saa7134-vbi.c
+++ b/drivers/media/pci/saa7134/saa7134-vbi.c
@@ -156,6 +156,7 @@ static int queue_setup(struct vb2_queue *q, const struct v4l2_format *fmt,
 	*nbuffers = saa7134_buffer_count(size, *nbuffers);
 	*nplanes = 1;
 	sizes[0] = size;
+	alloc_ctxs[0] = dev->alloc_ctx;
 	return 0;
 }
 
diff --git a/drivers/media/pci/saa7134/saa7134-video.c b/drivers/media/pci/saa7134/saa7134-video.c
index 0cfa2ca..5e3c48d 100644
--- a/drivers/media/pci/saa7134/saa7134-video.c
+++ b/drivers/media/pci/saa7134/saa7134-video.c
@@ -932,6 +932,7 @@ static int queue_setup(struct vb2_queue *q, const struct v4l2_format *fmt,
 	*nbuffers = saa7134_buffer_count(size, *nbuffers);
 	*nplanes = 1;
 	sizes[0] = size;
+	alloc_ctxs[0] = dev->alloc_ctx;
 	return 0;
 }
 
diff --git a/drivers/media/pci/saa7134/saa7134.h b/drivers/media/pci/saa7134/saa7134.h
index e47edd4..1c21c47 100644
--- a/drivers/media/pci/saa7134/saa7134.h
+++ b/drivers/media/pci/saa7134/saa7134.h
@@ -583,6 +583,7 @@ struct saa7134_dev {
 
 
 	/* video+ts+vbi capture */
+	void			   *alloc_ctx;
 	struct saa7134_dmaqueue    video_q;
 	struct vb2_queue           video_vbq;
 	struct saa7134_dmaqueue    vbi_q;
diff --git a/drivers/media/pci/solo6x10/solo6x10-v4l2-enc.c b/drivers/media/pci/solo6x10/solo6x10-v4l2-enc.c
index 28023f9..0517fc9 100644
--- a/drivers/media/pci/solo6x10/solo6x10-v4l2-enc.c
+++ b/drivers/media/pci/solo6x10/solo6x10-v4l2-enc.c
@@ -720,7 +720,10 @@ static int solo_enc_queue_setup(struct vb2_queue *q,
 				unsigned int *num_planes, unsigned int sizes[],
 				void *alloc_ctxs[])
 {
+	struct solo_enc_dev *solo_enc = vb2_get_drv_priv(q);
+
 	sizes[0] = FRAME_BUF_SIZE;
+	alloc_ctxs[0] = solo_enc->alloc_ctx;
 	*num_planes = 1;
 
 	if (*num_buffers < MIN_VID_BUFFERS)
@@ -1263,6 +1266,11 @@ static struct solo_enc_dev *solo_enc_alloc(struct solo_dev *solo_dev,
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
@@ -1366,6 +1374,7 @@ pci_free:
 			solo_enc->desc_items, solo_enc->desc_dma);
 hdl_free:
 	v4l2_ctrl_handler_free(hdl);
+	vb2_dma_sg_cleanup_ctx(solo_enc->alloc_ctx);
 	kfree(solo_enc);
 	return ERR_PTR(ret);
 }
@@ -1377,6 +1386,7 @@ static void solo_enc_free(struct solo_enc_dev *solo_enc)
 
 	video_unregister_device(solo_enc->vfd);
 	v4l2_ctrl_handler_free(&solo_enc->hdl);
+	vb2_dma_sg_cleanup_ctx(solo_enc->alloc_ctx);
 	kfree(solo_enc);
 }
 
diff --git a/drivers/media/pci/solo6x10/solo6x10.h b/drivers/media/pci/solo6x10/solo6x10.h
index 72017b7..bd8edfa 100644
--- a/drivers/media/pci/solo6x10/solo6x10.h
+++ b/drivers/media/pci/solo6x10/solo6x10.h
@@ -180,6 +180,7 @@ struct solo_enc_dev {
 	u32			sequence;
 	struct vb2_queue	vidq;
 	struct list_head	vidq_active;
+	void			*alloc_ctx;
 	int			desc_count;
 	int			desc_nelts;
 	struct solo_p2m_desc	*desc_items;
diff --git a/drivers/media/platform/marvell-ccic/mcam-core.c b/drivers/media/platform/marvell-ccic/mcam-core.c
index 7a86c77..20d53b6 100644
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
index e5247a4..087cd62 100644
--- a/drivers/media/v4l2-core/videobuf2-core.c
+++ b/drivers/media/v4l2-core/videobuf2-core.c
@@ -189,6 +189,7 @@ static void __vb2_queue_cancel(struct vb2_queue *q);
 static int __vb2_buf_mem_alloc(struct vb2_buffer *vb)
 {
 	struct vb2_queue *q = vb->vb2_queue;
+	int write = !V4L2_TYPE_IS_OUTPUT(q->type);
 	void *mem_priv;
 	int plane;
 
@@ -200,7 +201,7 @@ static int __vb2_buf_mem_alloc(struct vb2_buffer *vb)
 		unsigned long size = PAGE_ALIGN(q->plane_sizes[plane]);
 
 		mem_priv = call_ptr_memop(vb, alloc, q->alloc_ctx[plane],
-				      size, q->gfp_flags);
+				      size, write, q->gfp_flags);
 		if (IS_ERR_OR_NULL(mem_priv))
 			goto free;
 
diff --git a/drivers/media/v4l2-core/videobuf2-dma-contig.c b/drivers/media/v4l2-core/videobuf2-dma-contig.c
index 4a02ade..6675f12 100644
--- a/drivers/media/v4l2-core/videobuf2-dma-contig.c
+++ b/drivers/media/v4l2-core/videobuf2-dma-contig.c
@@ -155,7 +155,8 @@ static void vb2_dc_put(void *buf_priv)
 	kfree(buf);
 }
 
-static void *vb2_dc_alloc(void *alloc_ctx, unsigned long size, gfp_t gfp_flags)
+static void *vb2_dc_alloc(void *alloc_ctx, unsigned long size, int write,
+			  gfp_t gfp_flags)
 {
 	struct vb2_dc_conf *conf = alloc_ctx;
 	struct device *dev = conf->dev;
@@ -176,6 +177,7 @@ static void *vb2_dc_alloc(void *alloc_ctx, unsigned long size, gfp_t gfp_flags)
 	/* Prevent the device from being released while the buffer is used */
 	buf->dev = get_device(dev);
 	buf->size = size;
+	buf->dma_dir = write ? DMA_FROM_DEVICE : DMA_TO_DEVICE;
 
 	buf->handler.refcount = &buf->refcount;
 	buf->handler.put = vb2_dc_put;
diff --git a/drivers/media/v4l2-core/videobuf2-dma-sg.c b/drivers/media/v4l2-core/videobuf2-dma-sg.c
index adefc31..9b7a041 100644
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
 
diff --git a/include/media/videobuf2-core.h b/include/media/videobuf2-core.h
index fff159c..02b96ef 100644
--- a/include/media/videobuf2-core.h
+++ b/include/media/videobuf2-core.h
@@ -82,7 +82,8 @@ struct vb2_threadio_data;
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
2.1.0

