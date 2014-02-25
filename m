Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr11.xs4all.nl ([194.109.24.31]:4536 "EHLO
	smtp-vbr11.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753156AbaBYKEz (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 25 Feb 2014 05:04:55 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: pawel@osciak.com, s.nawrocki@samsung.com, m.szyprowski@samsung.com,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFCv1 PATCH 15/20] vb2: replace 'write' by 'dma_dir'
Date: Tue, 25 Feb 2014 11:04:20 +0100
Message-Id: <1393322665-29889-16-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1393322665-29889-1-git-send-email-hverkuil@xs4all.nl>
References: <1393322665-29889-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

The 'write' argument is very ambiguous. I first assumed that if it is 1,
then we're doing video output but instead it meant the reverse.

Since it is used to setup the dma_dir value anyway it is now replaced by
the correct dma_dir value which is unambiguous.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/v4l2-core/videobuf2-core.c       | 15 +++++----
 drivers/media/v4l2-core/videobuf2-dma-contig.c | 46 ++++++++++++++------------
 drivers/media/v4l2-core/videobuf2-dma-sg.c     | 46 ++++++++++++--------------
 drivers/media/v4l2-core/videobuf2-vmalloc.c    | 20 ++++++-----
 include/media/videobuf2-core.h                 | 11 +++---
 5 files changed, 73 insertions(+), 65 deletions(-)

diff --git a/drivers/media/v4l2-core/videobuf2-core.c b/drivers/media/v4l2-core/videobuf2-core.c
index 52f38d0..b0d1ed9 100644
--- a/drivers/media/v4l2-core/videobuf2-core.c
+++ b/drivers/media/v4l2-core/videobuf2-core.c
@@ -102,7 +102,8 @@ module_param(debug, int, 0644);
 static int __vb2_buf_mem_alloc(struct vb2_buffer *vb)
 {
 	struct vb2_queue *q = vb->vb2_queue;
-	int write = !V4L2_TYPE_IS_OUTPUT(q->type);
+	enum dma_data_direction dma_dir =
+		V4L2_TYPE_IS_OUTPUT(q->type) ? DMA_TO_DEVICE : DMA_FROM_DEVICE;
 	void *mem_priv;
 	int plane;
 
@@ -114,7 +115,7 @@ static int __vb2_buf_mem_alloc(struct vb2_buffer *vb)
 		unsigned long size = PAGE_ALIGN(q->plane_sizes[plane]);
 
 		mem_priv = call_memop(vb, alloc, q->alloc_ctx[plane],
-				      size, write, q->gfp_flags);
+				      size, dma_dir, q->gfp_flags);
 		if (IS_ERR_OR_NULL(mem_priv))
 			goto free;
 
@@ -1276,7 +1277,8 @@ static int __qbuf_userptr(struct vb2_buffer *vb, const struct v4l2_buffer *b)
 	void *mem_priv;
 	unsigned int plane;
 	int ret;
-	int write = !V4L2_TYPE_IS_OUTPUT(q->type);
+	enum dma_data_direction dma_dir =
+		V4L2_TYPE_IS_OUTPUT(q->type) ? DMA_TO_DEVICE : DMA_FROM_DEVICE;
 	bool reacquired = vb->planes[0].mem_priv == NULL;
 
 	/* Copy relevant information provided by the userspace */
@@ -1316,7 +1318,7 @@ static int __qbuf_userptr(struct vb2_buffer *vb, const struct v4l2_buffer *b)
 		/* Acquire each plane's memory */
 		mem_priv = call_memop(vb, get_userptr, q->alloc_ctx[plane],
 				      planes[plane].m.userptr,
-				      planes[plane].length, write);
+				      planes[plane].length, dma_dir);
 		if (IS_ERR_OR_NULL(mem_priv)) {
 			dprintk(1, "%s: failed acquiring userspace memory for plane %d\n",
 				__func__, plane);
@@ -1389,7 +1391,8 @@ static int __qbuf_dmabuf(struct vb2_buffer *vb, const struct v4l2_buffer *b)
 	void *mem_priv;
 	unsigned int plane;
 	int ret;
-	int write = !V4L2_TYPE_IS_OUTPUT(q->type);
+	enum dma_data_direction dma_dir =
+		V4L2_TYPE_IS_OUTPUT(q->type) ? DMA_TO_DEVICE : DMA_FROM_DEVICE;
 	bool reacquired = vb->planes[0].mem_priv == NULL;
 
 	/* Copy relevant information provided by the userspace */
@@ -1437,7 +1440,7 @@ static int __qbuf_dmabuf(struct vb2_buffer *vb, const struct v4l2_buffer *b)
 
 		/* Acquire each plane's memory */
 		mem_priv = call_memop(vb, attach_dmabuf, q->alloc_ctx[plane],
-			dbuf, planes[plane].length, write);
+			dbuf, planes[plane].length, dma_dir);
 		if (IS_ERR(mem_priv)) {
 			dprintk(1, "%s: failed to attach dmabuf\n", __func__);
 			fail_memop(vb, attach_dmabuf);
diff --git a/drivers/media/v4l2-core/videobuf2-dma-contig.c b/drivers/media/v4l2-core/videobuf2-dma-contig.c
index 604f2f4..e52a1bc 100644
--- a/drivers/media/v4l2-core/videobuf2-dma-contig.c
+++ b/drivers/media/v4l2-core/videobuf2-dma-contig.c
@@ -153,8 +153,8 @@ static void vb2_dc_put(void *buf_priv)
 	kfree(buf);
 }
 
-static void *vb2_dc_alloc(void *alloc_ctx, unsigned long size, int write,
-			  gfp_t gfp_flags)
+static void *vb2_dc_alloc(void *alloc_ctx, unsigned long size,
+			  enum dma_data_direction dma_dir, gfp_t gfp_flags)
 {
 	struct vb2_dc_conf *conf = alloc_ctx;
 	struct device *dev = conf->dev;
@@ -175,7 +175,7 @@ static void *vb2_dc_alloc(void *alloc_ctx, unsigned long size, int write,
 	/* Prevent the device from being released while the buffer is used */
 	buf->dev = get_device(dev);
 	buf->size = size;
-	buf->dma_dir = write ? DMA_FROM_DEVICE : DMA_TO_DEVICE;
+	buf->dma_dir = dma_dir;
 
 	buf->handler.refcount = &buf->refcount;
 	buf->handler.put = vb2_dc_put;
@@ -229,7 +229,7 @@ static int vb2_dc_mmap(void *buf_priv, struct vm_area_struct *vma)
 
 struct vb2_dc_attachment {
 	struct sg_table sgt;
-	enum dma_data_direction dir;
+	enum dma_data_direction dma_dir;
 };
 
 static int vb2_dc_dmabuf_ops_attach(struct dma_buf *dbuf, struct device *dev,
@@ -264,7 +264,7 @@ static int vb2_dc_dmabuf_ops_attach(struct dma_buf *dbuf, struct device *dev,
 		wr = sg_next(wr);
 	}
 
-	attach->dir = DMA_NONE;
+	attach->dma_dir = DMA_NONE;
 	dbuf_attach->priv = attach;
 
 	return 0;
@@ -282,16 +282,16 @@ static void vb2_dc_dmabuf_ops_detach(struct dma_buf *dbuf,
 	sgt = &attach->sgt;
 
 	/* release the scatterlist cache */
-	if (attach->dir != DMA_NONE)
+	if (attach->dma_dir != DMA_NONE)
 		dma_unmap_sg(db_attach->dev, sgt->sgl, sgt->orig_nents,
-			attach->dir);
+			attach->dma_dir);
 	sg_free_table(sgt);
 	kfree(attach);
 	db_attach->priv = NULL;
 }
 
 static struct sg_table *vb2_dc_dmabuf_ops_map(
-	struct dma_buf_attachment *db_attach, enum dma_data_direction dir)
+	struct dma_buf_attachment *db_attach, enum dma_data_direction dma_dir)
 {
 	struct vb2_dc_attachment *attach = db_attach->priv;
 	/* stealing dmabuf mutex to serialize map/unmap operations */
@@ -303,27 +303,27 @@ static struct sg_table *vb2_dc_dmabuf_ops_map(
 
 	sgt = &attach->sgt;
 	/* return previously mapped sg table */
-	if (attach->dir == dir) {
+	if (attach->dma_dir == dma_dir) {
 		mutex_unlock(lock);
 		return sgt;
 	}
 
 	/* release any previous cache */
-	if (attach->dir != DMA_NONE) {
+	if (attach->dma_dir != DMA_NONE) {
 		dma_unmap_sg(db_attach->dev, sgt->sgl, sgt->orig_nents,
-			attach->dir);
-		attach->dir = DMA_NONE;
+			attach->dma_dir);
+		attach->dma_dir = DMA_NONE;
 	}
 
 	/* mapping to the client with new direction */
-	ret = dma_map_sg(db_attach->dev, sgt->sgl, sgt->orig_nents, dir);
+	ret = dma_map_sg(db_attach->dev, sgt->sgl, sgt->orig_nents, dma_dir);
 	if (ret <= 0) {
 		pr_err("failed to map scatterlist\n");
 		mutex_unlock(lock);
 		return ERR_PTR(-EIO);
 	}
 
-	attach->dir = dir;
+	attach->dma_dir = dma_dir;
 
 	mutex_unlock(lock);
 
@@ -331,7 +331,7 @@ static struct sg_table *vb2_dc_dmabuf_ops_map(
 }
 
 static void vb2_dc_dmabuf_ops_unmap(struct dma_buf_attachment *db_attach,
-	struct sg_table *sgt, enum dma_data_direction dir)
+	struct sg_table *sgt, enum dma_data_direction dma_dir)
 {
 	/* nothing to be done here */
 }
@@ -460,7 +460,8 @@ static int vb2_dc_get_user_pfn(unsigned long start, int n_pages,
 }
 
 static int vb2_dc_get_user_pages(unsigned long start, struct page **pages,
-	int n_pages, struct vm_area_struct *vma, int write)
+	int n_pages, struct vm_area_struct *vma,
+	enum dma_data_direction dma_dir)
 {
 	if (vma_is_io(vma)) {
 		unsigned int i;
@@ -482,7 +483,7 @@ static int vb2_dc_get_user_pages(unsigned long start, struct page **pages,
 		int n;
 
 		n = get_user_pages(current, current->mm, start & PAGE_MASK,
-			n_pages, write, 1, pages, NULL);
+			n_pages, dma_dir == DMA_FROM_DEVICE, 1, pages, NULL);
 		/* negative error means that no page was pinned */
 		n = max(n, 0);
 		if (n != n_pages) {
@@ -551,7 +552,7 @@ static inline dma_addr_t vb2_dc_pfn_to_dma(struct device *dev, unsigned long pfn
 #endif
 
 static void *vb2_dc_get_userptr(void *alloc_ctx, unsigned long vaddr,
-	unsigned long size, int write)
+	unsigned long size, enum dma_data_direction dma_dir)
 {
 	struct vb2_dc_conf *conf = alloc_ctx;
 	struct vb2_dc_buf *buf;
@@ -582,7 +583,7 @@ static void *vb2_dc_get_userptr(void *alloc_ctx, unsigned long vaddr,
 		return ERR_PTR(-ENOMEM);
 
 	buf->dev = conf->dev;
-	buf->dma_dir = write ? DMA_FROM_DEVICE : DMA_TO_DEVICE;
+	buf->dma_dir = dma_dir;
 
 	start = vaddr & PAGE_MASK;
 	offset = vaddr & ~PAGE_MASK;
@@ -618,7 +619,8 @@ static void *vb2_dc_get_userptr(void *alloc_ctx, unsigned long vaddr,
 	}
 
 	/* extract page list from userspace mapping */
-	ret = vb2_dc_get_user_pages(start, pages, n_pages, vma, write);
+	ret = vb2_dc_get_user_pages(start, pages, n_pages, vma,
+				    dma_dir == DMA_FROM_DEVICE);
 	if (ret) {
 		unsigned long pfn;
 		if (vb2_dc_get_user_pfn(start, n_pages, vma, &pfn) == 0) {
@@ -777,7 +779,7 @@ static void vb2_dc_detach_dmabuf(void *mem_priv)
 }
 
 static void *vb2_dc_attach_dmabuf(void *alloc_ctx, struct dma_buf *dbuf,
-	unsigned long size, int write)
+	unsigned long size, enum dma_data_direction dma_dir)
 {
 	struct vb2_dc_conf *conf = alloc_ctx;
 	struct vb2_dc_buf *buf;
@@ -799,7 +801,7 @@ static void *vb2_dc_attach_dmabuf(void *alloc_ctx, struct dma_buf *dbuf,
 		return dba;
 	}
 
-	buf->dma_dir = write ? DMA_FROM_DEVICE : DMA_TO_DEVICE;
+	buf->dma_dir = dma_dir;
 	buf->size = size;
 	buf->db_attach = dba;
 
diff --git a/drivers/media/v4l2-core/videobuf2-dma-sg.c b/drivers/media/v4l2-core/videobuf2-dma-sg.c
index 3efa27c..9afe8e0 100644
--- a/drivers/media/v4l2-core/videobuf2-dma-sg.c
+++ b/drivers/media/v4l2-core/videobuf2-dma-sg.c
@@ -38,7 +38,6 @@ struct vb2_dma_sg_buf {
 	struct device			*dev;
 	void				*vaddr;
 	struct page			**pages;
-	int				write;
 	int				offset;
 	enum dma_data_direction		dma_dir;
 	struct sg_table			sg_table;
@@ -96,8 +95,8 @@ static int vb2_dma_sg_alloc_compacted(struct vb2_dma_sg_buf *buf,
 	return 0;
 }
 
-static void *vb2_dma_sg_alloc(void *alloc_ctx, unsigned long size, int write,
-			      gfp_t gfp_flags)
+static void *vb2_dma_sg_alloc(void *alloc_ctx, unsigned long size,
+			      enum dma_data_direction dma_dir, gfp_t gfp_flags)
 {
 	struct vb2_dma_sg_conf *conf = alloc_ctx;
 	struct vb2_dma_sg_buf *buf;
@@ -111,12 +110,11 @@ static void *vb2_dma_sg_alloc(void *alloc_ctx, unsigned long size, int write,
 		return NULL;
 
 	buf->vaddr = NULL;
-	buf->write = write;
 	buf->offset = 0;
 	buf->size = size;
 	/* size is already page aligned */
 	buf->num_pages = size >> PAGE_SHIFT;
-	buf->dma_dir = write ? DMA_FROM_DEVICE : DMA_TO_DEVICE;
+	buf->dma_dir = dma_dir;
 	buf->dma_sgt = &buf->sg_table;
 
 	buf->pages = kzalloc(buf->num_pages * sizeof(struct page *),
@@ -205,7 +203,8 @@ static inline int vma_is_io(struct vm_area_struct *vma)
 }
 
 static void *vb2_dma_sg_get_userptr(void *alloc_ctx, unsigned long vaddr,
-				    unsigned long size, int write)
+				    unsigned long size,
+				    enum dma_data_direction dma_dir)
 {
 	struct vb2_dma_sg_conf *conf = alloc_ctx;
 	struct vb2_dma_sg_buf *buf;
@@ -218,10 +217,9 @@ static void *vb2_dma_sg_get_userptr(void *alloc_ctx, unsigned long vaddr,
 		return NULL;
 
 	buf->vaddr = NULL;
-	buf->write = write;
 	buf->offset = vaddr & ~PAGE_MASK;
 	buf->size = size;
-	buf->dma_dir = write ? DMA_FROM_DEVICE : DMA_TO_DEVICE;
+	buf->dma_dir = dma_dir;
 	buf->dma_sgt = &buf->sg_table;
 
 	first = (vaddr           & PAGE_MASK) >> PAGE_SHIFT;
@@ -267,7 +265,7 @@ static void *vb2_dma_sg_get_userptr(void *alloc_ctx, unsigned long vaddr,
 		num_pages_from_user = get_user_pages(current, current->mm,
 					     vaddr & PAGE_MASK,
 					     buf->num_pages,
-					     write,
+					     buf->dma_dir == DMA_FROM_DEVICE,
 					     1, /* force */
 					     buf->pages,
 					     NULL);
@@ -313,7 +311,7 @@ static void vb2_dma_sg_put_userptr(void *buf_priv)
 		vm_unmap_ram(buf->vaddr, buf->num_pages);
 	sg_free_table(buf->dma_sgt);
 	while (--i >= 0) {
-		if (buf->write)
+		if (buf->dma_dir == DMA_FROM_DEVICE)
 			set_page_dirty_lock(buf->pages[i]);
 		if (!vma_is_io(buf->vma))
 			put_page(buf->pages[i]);
@@ -390,7 +388,7 @@ static int vb2_dma_sg_mmap(void *buf_priv, struct vm_area_struct *vma)
 
 struct vb2_dma_sg_attachment {
 	struct sg_table sgt;
-	enum dma_data_direction dir;
+	enum dma_data_direction dma_dir;
 };
 
 static int vb2_dma_sg_dmabuf_ops_attach(struct dma_buf *dbuf, struct device *dev,
@@ -425,7 +423,7 @@ static int vb2_dma_sg_dmabuf_ops_attach(struct dma_buf *dbuf, struct device *dev
 		wr = sg_next(wr);
 	}
 
-	attach->dir = DMA_NONE;
+	attach->dma_dir = DMA_NONE;
 	dbuf_attach->priv = attach;
 
 	return 0;
@@ -443,16 +441,16 @@ static void vb2_dma_sg_dmabuf_ops_detach(struct dma_buf *dbuf,
 	sgt = &attach->sgt;
 
 	/* release the scatterlist cache */
-	if (attach->dir != DMA_NONE)
+	if (attach->dma_dir != DMA_NONE)
 		dma_unmap_sg(db_attach->dev, sgt->sgl, sgt->orig_nents,
-			attach->dir);
+			attach->dma_dir);
 	sg_free_table(sgt);
 	kfree(attach);
 	db_attach->priv = NULL;
 }
 
 static struct sg_table *vb2_dma_sg_dmabuf_ops_map(
-	struct dma_buf_attachment *db_attach, enum dma_data_direction dir)
+	struct dma_buf_attachment *db_attach, enum dma_data_direction dma_dir)
 {
 	struct vb2_dma_sg_attachment *attach = db_attach->priv;
 	/* stealing dmabuf mutex to serialize map/unmap operations */
@@ -464,27 +462,27 @@ static struct sg_table *vb2_dma_sg_dmabuf_ops_map(
 
 	sgt = &attach->sgt;
 	/* return previously mapped sg table */
-	if (attach->dir == dir) {
+	if (attach->dma_dir == dma_dir) {
 		mutex_unlock(lock);
 		return sgt;
 	}
 
 	/* release any previous cache */
-	if (attach->dir != DMA_NONE) {
+	if (attach->dma_dir != DMA_NONE) {
 		dma_unmap_sg(db_attach->dev, sgt->sgl, sgt->orig_nents,
-			attach->dir);
-		attach->dir = DMA_NONE;
+			attach->dma_dir);
+		attach->dma_dir = DMA_NONE;
 	}
 
 	/* mapping to the client with new direction */
-	ret = dma_map_sg(db_attach->dev, sgt->sgl, sgt->orig_nents, dir);
+	ret = dma_map_sg(db_attach->dev, sgt->sgl, sgt->orig_nents, dma_dir);
 	if (ret <= 0) {
 		pr_err("failed to map scatterlist\n");
 		mutex_unlock(lock);
 		return ERR_PTR(-EIO);
 	}
 
-	attach->dir = dir;
+	attach->dma_dir = dma_dir;
 
 	mutex_unlock(lock);
 
@@ -492,7 +490,7 @@ static struct sg_table *vb2_dma_sg_dmabuf_ops_map(
 }
 
 static void vb2_dma_sg_dmabuf_ops_unmap(struct dma_buf_attachment *db_attach,
-	struct sg_table *sgt, enum dma_data_direction dir)
+	struct sg_table *sgt, enum dma_data_direction dma_dir)
 {
 	/* nothing to be done here */
 }
@@ -617,7 +615,7 @@ static void vb2_dma_sg_detach_dmabuf(void *mem_priv)
 }
 
 static void *vb2_dma_sg_attach_dmabuf(void *alloc_ctx, struct dma_buf *dbuf,
-	unsigned long size, int write)
+	unsigned long size, enum dma_data_direction dma_dir)
 {
 	struct vb2_dma_sg_conf *conf = alloc_ctx;
 	struct vb2_dma_sg_buf *buf;
@@ -639,7 +637,7 @@ static void *vb2_dma_sg_attach_dmabuf(void *alloc_ctx, struct dma_buf *dbuf,
 		return dba;
 	}
 
-	buf->dma_dir = write ? DMA_FROM_DEVICE : DMA_TO_DEVICE;
+	buf->dma_dir = dma_dir;
 	buf->size = size;
 	buf->db_attach = dba;
 
diff --git a/drivers/media/v4l2-core/videobuf2-vmalloc.c b/drivers/media/v4l2-core/videobuf2-vmalloc.c
index 4baa11a..daf7779 100644
--- a/drivers/media/v4l2-core/videobuf2-vmalloc.c
+++ b/drivers/media/v4l2-core/videobuf2-vmalloc.c
@@ -25,7 +25,7 @@ struct vb2_vmalloc_buf {
 	void				*vaddr;
 	struct page			**pages;
 	struct vm_area_struct		*vma;
-	int				write;
+	enum dma_data_direction		dma_dir;
 	unsigned long			size;
 	unsigned int			n_pages;
 	atomic_t			refcount;
@@ -38,8 +38,8 @@ struct vb2_vmalloc_buf {
 
 static void vb2_vmalloc_put(void *buf_priv);
 
-static void *vb2_vmalloc_alloc(void *alloc_ctx, unsigned long size, int write,
-			       gfp_t gfp_flags)
+static void *vb2_vmalloc_alloc(void *alloc_ctx, unsigned long size,
+			       enum dma_data_direction dma_dir, gfp_t gfp_flags)
 {
 	struct vb2_vmalloc_buf *buf;
 
@@ -74,7 +74,8 @@ static void vb2_vmalloc_put(void *buf_priv)
 }
 
 static void *vb2_vmalloc_get_userptr(void *alloc_ctx, unsigned long vaddr,
-				     unsigned long size, int write)
+				     unsigned long size,
+				     enum dma_data_direction dma_dir)
 {
 	struct vb2_vmalloc_buf *buf;
 	unsigned long first, last;
@@ -86,7 +87,7 @@ static void *vb2_vmalloc_get_userptr(void *alloc_ctx, unsigned long vaddr,
 	if (!buf)
 		return NULL;
 
-	buf->write = write;
+	buf->dma_dir = dma_dir;
 	offset = vaddr & ~PAGE_MASK;
 	buf->size = size;
 
@@ -111,7 +112,8 @@ static void *vb2_vmalloc_get_userptr(void *alloc_ctx, unsigned long vaddr,
 		/* current->mm->mmap_sem is taken by videobuf2 core */
 		n_pages = get_user_pages(current, current->mm,
 					 vaddr & PAGE_MASK, buf->n_pages,
-					 write, 1, /* force */
+					 dma_dir == DMA_FROM_DEVICE,
+					 1, /* force */
 					 buf->pages, NULL);
 		if (n_pages != buf->n_pages)
 			goto fail_get_user_pages;
@@ -148,7 +150,7 @@ static void vb2_vmalloc_put_userptr(void *buf_priv)
 		if (vaddr)
 			vm_unmap_ram((void *)vaddr, buf->n_pages);
 		for (i = 0; i < buf->n_pages; ++i) {
-			if (buf->write)
+			if (buf->dma_dir == DMA_FROM_DEVICE)
 				set_page_dirty_lock(buf->pages[i]);
 			put_page(buf->pages[i]);
 		}
@@ -414,7 +416,7 @@ static void vb2_vmalloc_detach_dmabuf(void *mem_priv)
 }
 
 static void *vb2_vmalloc_attach_dmabuf(void *alloc_ctx, struct dma_buf *dbuf,
-	unsigned long size, int write)
+	unsigned long size, enum dma_data_direction dma_dir)
 {
 	struct vb2_vmalloc_buf *buf;
 
@@ -426,7 +428,7 @@ static void *vb2_vmalloc_attach_dmabuf(void *alloc_ctx, struct dma_buf *dbuf,
 		return ERR_PTR(-ENOMEM);
 
 	buf->dbuf = dbuf;
-	buf->write = write;
+	buf->dma_dir = dma_dir;
 	buf->size = size;
 
 	return buf;
diff --git a/include/media/videobuf2-core.h b/include/media/videobuf2-core.h
index 169e111..df5e75a 100644
--- a/include/media/videobuf2-core.h
+++ b/include/media/videobuf2-core.h
@@ -81,20 +81,23 @@ struct vb2_fileio_data;
  *				  unmap_dmabuf.
  */
 struct vb2_mem_ops {
-	void		*(*alloc)(void *alloc_ctx, unsigned long size, int write,
-				  gfp_t gfp_flags);
+	void		*(*alloc)(void *alloc_ctx, unsigned long size,
+				enum dma_data_direction dma_dir,
+				gfp_t gfp_flags);
 	void		(*put)(void *buf_priv);
 	struct dma_buf *(*get_dmabuf)(void *buf_priv, unsigned long flags);
 
 	void		*(*get_userptr)(void *alloc_ctx, unsigned long vaddr,
-					unsigned long size, int write);
+					unsigned long size,
+					enum dma_data_direction dma_dir);
 	void		(*put_userptr)(void *buf_priv);
 
 	int		(*prepare)(void *buf_priv);
 	void		(*finish)(void *buf_priv);
 
 	void		*(*attach_dmabuf)(void *alloc_ctx, struct dma_buf *dbuf,
-				unsigned long size, int write);
+					  unsigned long size,
+					  enum dma_data_direction dma_dir);
 	void		(*detach_dmabuf)(void *buf_priv);
 	int		(*map_dmabuf)(void *buf_priv);
 	void		(*unmap_dmabuf)(void *buf_priv);
-- 
1.9.0

