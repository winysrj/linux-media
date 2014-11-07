Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud2.xs4all.net ([194.109.24.21]:50514 "EHLO
	lb1-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751399AbaKGIur (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 7 Nov 2014 03:50:47 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: pawel@osciak.com, m.szyprowski@samsung.com,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFCv5 PATCH 11/15] vb2: add begin/end_cpu_access functions
Date: Fri,  7 Nov 2014 09:50:30 +0100
Message-Id: <1415350234-9826-12-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1415350234-9826-1-git-send-email-hverkuil@xs4all.nl>
References: <1415350234-9826-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

The existing vb2_plane_vaddr function is not enough when dealing with
dmabuf. For dmabuf you need to be explicit when the cpu needs access to
the buffer and when that can be stopped.

So add vb2_plane_begin/end_cpu_access as a vaddr replacement. The old
vb2_plane_vaddr function is kept around for a bit so drivers can be
converted in a separate patch.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/v4l2-core/videobuf2-core.c       | 65 ++++++++++++++++++-----
 drivers/media/v4l2-core/videobuf2-dma-contig.c | 56 ++++++++++++++++++++
 drivers/media/v4l2-core/videobuf2-dma-sg.c     | 71 +++++++++++++++++++++++++-
 drivers/media/v4l2-core/videobuf2-vmalloc.c    | 39 +++++++++++++-
 include/media/videobuf2-core.h                 | 16 ++++--
 5 files changed, 228 insertions(+), 19 deletions(-)

diff --git a/drivers/media/v4l2-core/videobuf2-core.c b/drivers/media/v4l2-core/videobuf2-core.c
index 7aed8f2..036b947 100644
--- a/drivers/media/v4l2-core/videobuf2-core.c
+++ b/drivers/media/v4l2-core/videobuf2-core.c
@@ -501,6 +501,7 @@ static int __vb2_queue_free(struct vb2_queue *q, unsigned int buffers)
 				  vb->cnt_mem_get_userptr != vb->cnt_mem_put_userptr ||
 				  vb->cnt_mem_attach_dmabuf != vb->cnt_mem_detach_dmabuf ||
 				  vb->cnt_mem_map_dmabuf != vb->cnt_mem_unmap_dmabuf ||
+				  vb->cnt_mem_begin_cpu_access != vb->cnt_mem_end_cpu_access ||
 				  vb->cnt_buf_queue != vb->cnt_buf_done ||
 				  vb->cnt_buf_prepare != vb->cnt_buf_finish ||
 				  vb->cnt_buf_init != vb->cnt_buf_cleanup;
@@ -522,10 +523,11 @@ static int __vb2_queue_free(struct vb2_queue *q, unsigned int buffers)
 			pr_info("vb2:     attach_dmabuf: %u detach_dmabuf: %u map_dmabuf: %u unmap_dmabuf: %u\n",
 				vb->cnt_mem_attach_dmabuf, vb->cnt_mem_detach_dmabuf,
 				vb->cnt_mem_map_dmabuf, vb->cnt_mem_unmap_dmabuf);
-			pr_info("vb2:     get_dmabuf: %u num_users: %u vaddr: %u cookie: %u\n",
+			pr_info("vb2:     begin_cpu_access: %u end_cpu_access: %u\n",
+				vb->cnt_mem_begin_cpu_access, vb->cnt_mem_end_cpu_access);
+			pr_info("vb2:     get_dmabuf: %u num_users: %u cookie: %u\n",
 				vb->cnt_mem_get_dmabuf,
 				vb->cnt_mem_num_users,
-				vb->cnt_mem_vaddr,
 				vb->cnt_mem_cookie);
 		}
 	}
@@ -791,7 +793,8 @@ static int __verify_dmabuf_ops(struct vb2_queue *q)
 {
 	if (!(q->io_modes & VB2_DMABUF) || !q->mem_ops->attach_dmabuf ||
 	    !q->mem_ops->detach_dmabuf  || !q->mem_ops->map_dmabuf ||
-	    !q->mem_ops->unmap_dmabuf)
+	    !q->mem_ops->unmap_dmabuf || !q->mem_ops->begin_cpu_access ||
+	    !q->mem_ops->end_cpu_access)
 		return -EINVAL;
 
 	return 0;
@@ -1113,24 +1116,48 @@ int vb2_create_bufs(struct vb2_queue *q, struct v4l2_create_buffers *create)
 EXPORT_SYMBOL_GPL(vb2_create_bufs);
 
 /**
- * vb2_plane_vaddr() - Return a kernel virtual address of a given plane
+ * vb2_plane_begin_cpu_access() - Return a kernel virtual address of a given plane
  * @vb:		vb2_buffer to which the plane in question belongs to
  * @plane_no:	plane number for which the address is to be returned
  *
- * This function returns a kernel virtual address of a given plane if
- * such a mapping exist, NULL otherwise.
+ * This function returns a kernel virtual address of a given plane synced for
+ * cpu access if such a mapping exist, NULL otherwise.
  */
-void *vb2_plane_vaddr(struct vb2_buffer *vb, unsigned int plane_no)
+void *vb2_plane_begin_cpu_access(struct vb2_buffer *vb, unsigned int plane_no)
 {
 	if (plane_no > vb->num_planes || !vb->planes[plane_no].mem_priv)
 		return NULL;
 
-	return call_ptr_memop(vb, vaddr, vb->planes[plane_no].mem_priv);
+	return call_ptr_memop(vb, begin_cpu_access, vb->planes[plane_no].mem_priv);
+}
+EXPORT_SYMBOL_GPL(vb2_plane_begin_cpu_access);
 
+/* Keep this for backwards compatibility. Will be removed soon. */
+void *vb2_plane_vaddr(struct vb2_buffer *vb, unsigned int plane_no)
+{
+	return vb2_plane_begin_cpu_access(vb, plane_no);
 }
 EXPORT_SYMBOL_GPL(vb2_plane_vaddr);
 
 /**
+ * vb2_plane_end_cpu_access() - Return a kernel virtual address of a given plane
+ * @vb:		vb2_buffer to which the plane in question belongs to
+ * @plane_no:	plane number for which the address is to be returned
+ *
+ * This function ends the cpu access of the mapping earlier returned by
+ * @vb2_plane_begin_cpu_access.
+ */
+void vb2_plane_end_cpu_access(struct vb2_buffer *vb, unsigned int plane_no)
+{
+	if (plane_no > vb->num_planes || !vb->planes[plane_no].mem_priv)
+		return;
+
+	call_void_memop(vb, end_cpu_access, vb->planes[plane_no].mem_priv);
+
+}
+EXPORT_SYMBOL_GPL(vb2_plane_end_cpu_access);
+
+/**
  * vb2_plane_cookie() - Return allocator specific cookie for the given plane
  * @vb:		vb2_buffer to which the plane in question belongs to
  * @plane_no:	plane number for which the cookie is to be returned
@@ -1558,7 +1585,8 @@ static int __qbuf_dmabuf(struct vb2_buffer *vb, const struct v4l2_buffer *b)
 		}
 	}
 
-	ret = call_vb_qop(vb, buf_prepare, vb);
+	if (!ret)
+		ret = call_vb_qop(vb, buf_prepare, vb);
 	if (ret) {
 		dprintk(1, "buffer preparation failed\n");
 		call_void_vb_qop(vb, buf_cleanup, vb);
@@ -2537,8 +2565,16 @@ unsigned long vb2_get_unmapped_area(struct vb2_queue *q,
 
 	vb = q->bufs[buffer];
 
-	vaddr = vb2_plane_vaddr(vb, plane);
-	return vaddr ? (unsigned long)vaddr : -EINVAL;
+	/*
+	 * vb2_get_unmapped_area is used only with V4L2_MEMORY_MMAP. For
+	 * that memory model the vb2_plane_end_cpu_access() call is always
+	 * a NOP. The only reason it is called here is to keep the begin/end
+	 * calls balanced.
+	 */
+	vaddr = vb2_plane_begin_cpu_access(vb, plane);
+	if (vaddr)
+		vb2_plane_end_cpu_access(vb, plane);
+	return vaddr ? (unsigned long)vaddr : -ENOMEM;
 }
 EXPORT_SYMBOL_GPL(vb2_get_unmapped_area);
 #endif
@@ -2784,7 +2820,7 @@ static int __vb2_init_fileio(struct vb2_queue *q, int read)
 	/*
 	 * Check if device supports mapping buffers to kernel virtual space.
 	 */
-	if (!q->mem_ops->vaddr)
+	if (!q->mem_ops->begin_cpu_access)
 		return -EBUSY;
 
 	/*
@@ -2832,7 +2868,7 @@ static int __vb2_init_fileio(struct vb2_queue *q, int read)
 	 * Get kernel address of each buffer.
 	 */
 	for (i = 0; i < q->num_buffers; i++) {
-		fileio->bufs[i].vaddr = vb2_plane_vaddr(q->bufs[i], 0);
+		fileio->bufs[i].vaddr = vb2_plane_begin_cpu_access(q->bufs[i], 0);
 		if (fileio->bufs[i].vaddr == NULL) {
 			ret = -EINVAL;
 			goto err_reqbufs;
@@ -2900,9 +2936,12 @@ err_kfree:
 static int __vb2_cleanup_fileio(struct vb2_queue *q)
 {
 	struct vb2_fileio_data *fileio = q->fileio;
+	int i;
 
 	if (fileio) {
 		vb2_internal_streamoff(q, q->type);
+		for (i = 0; i < q->num_buffers; i++)
+			vb2_plane_end_cpu_access(q->bufs[i], 0);
 		q->fileio = NULL;
 		fileio->req.count = 0;
 		vb2_reqbufs(q, &fileio->req);
diff --git a/drivers/media/v4l2-core/videobuf2-dma-contig.c b/drivers/media/v4l2-core/videobuf2-dma-contig.c
index 27f5926..58a4bf2 100644
--- a/drivers/media/v4l2-core/videobuf2-dma-contig.c
+++ b/drivers/media/v4l2-core/videobuf2-dma-contig.c
@@ -348,17 +348,37 @@ static void vb2_dc_dmabuf_ops_release(struct dma_buf *dbuf)
 static void *vb2_dc_dmabuf_ops_kmap(struct dma_buf *dbuf, unsigned long pgnum)
 {
 	struct vb2_dc_buf *buf = dbuf->priv;
+	struct sg_table *sgt = buf->sgt_base;
 
+	dma_sync_sg_for_cpu(buf->dev, sgt->sgl, sgt->nents, buf->dma_dir);
 	return buf->vaddr + pgnum * PAGE_SIZE;
 }
 
 static void *vb2_dc_dmabuf_ops_vmap(struct dma_buf *dbuf)
 {
 	struct vb2_dc_buf *buf = dbuf->priv;
+	struct sg_table *sgt = buf->sgt_base;
 
+	dma_sync_sg_for_cpu(buf->dev, sgt->sgl, sgt->nents, buf->dma_dir);
 	return buf->vaddr;
 }
 
+static void vb2_dc_dmabuf_ops_kunmap(struct dma_buf *dbuf, unsigned long pgnum, void *vaddr)
+{
+	struct vb2_dc_buf *buf = dbuf->priv;
+	struct sg_table *sgt = buf->sgt_base;
+
+	dma_sync_sg_for_device(buf->dev, sgt->sgl, sgt->nents, buf->dma_dir);
+}
+
+static void vb2_dc_dmabuf_ops_vunmap(struct dma_buf *dbuf, void *vaddr)
+{
+	struct vb2_dc_buf *buf = dbuf->priv;
+	struct sg_table *sgt = buf->sgt_base;
+
+	dma_sync_sg_for_device(buf->dev, sgt->sgl, sgt->nents, buf->dma_dir);
+}
+
 static int vb2_dc_dmabuf_ops_mmap(struct dma_buf *dbuf,
 	struct vm_area_struct *vma)
 {
@@ -372,7 +392,10 @@ static struct dma_buf_ops vb2_dc_dmabuf_ops = {
 	.unmap_dma_buf = vb2_dc_dmabuf_ops_unmap,
 	.kmap = vb2_dc_dmabuf_ops_kmap,
 	.kmap_atomic = vb2_dc_dmabuf_ops_kmap,
+	.kunmap = vb2_dc_dmabuf_ops_kunmap,
+	.kunmap_atomic = vb2_dc_dmabuf_ops_kunmap,
 	.vmap = vb2_dc_dmabuf_ops_vmap,
+	.vunmap = vb2_dc_dmabuf_ops_vunmap,
 	.mmap = vb2_dc_dmabuf_ops_mmap,
 	.release = vb2_dc_dmabuf_ops_release,
 };
@@ -832,6 +855,37 @@ static void *vb2_dc_attach_dmabuf(void *alloc_ctx, struct dma_buf *dbuf,
 	return buf;
 }
 
+static void *vb2_dc_begin_cpu_access(void *mem_priv)
+{
+	struct vb2_dc_buf *buf = mem_priv;
+	int ret;
+
+	if (buf->db_attach) {
+		ret = dma_buf_begin_cpu_access(buf->db_attach->dmabuf,
+				0, buf->size, buf->dma_dir);
+		if (ret)
+			return NULL;
+		buf->vaddr = dma_buf_vmap(buf->db_attach->dmabuf);
+		if (buf->vaddr == NULL)
+			dma_buf_end_cpu_access(buf->db_attach->dmabuf,
+					0, buf->size, buf->dma_dir);
+	}
+
+	return buf->vaddr;
+}
+
+static void vb2_dc_end_cpu_access(void *mem_priv)
+{
+	struct vb2_dc_buf *buf = mem_priv;
+
+	if (!buf->db_attach)
+		return;
+	dma_buf_vunmap(buf->db_attach->dmabuf, buf->vaddr);
+	buf->vaddr = NULL;
+	dma_buf_end_cpu_access(buf->db_attach->dmabuf,
+			0, buf->size, buf->dma_dir);
+}
+
 /*********************************************/
 /*       DMA CONTIG exported functions       */
 /*********************************************/
@@ -851,6 +905,8 @@ const struct vb2_mem_ops vb2_dma_contig_memops = {
 	.unmap_dmabuf	= vb2_dc_unmap_dmabuf,
 	.attach_dmabuf	= vb2_dc_attach_dmabuf,
 	.detach_dmabuf	= vb2_dc_detach_dmabuf,
+	.begin_cpu_access = vb2_dc_begin_cpu_access,
+	.end_cpu_access = vb2_dc_end_cpu_access,
 	.num_users	= vb2_dc_num_users,
 };
 EXPORT_SYMBOL_GPL(vb2_dma_contig_memops);
diff --git a/drivers/media/v4l2-core/videobuf2-dma-sg.c b/drivers/media/v4l2-core/videobuf2-dma-sg.c
index 4d0e552..954ce74 100644
--- a/drivers/media/v4l2-core/videobuf2-dma-sg.c
+++ b/drivers/media/v4l2-core/videobuf2-dma-sg.c
@@ -544,18 +544,51 @@ static void vb2_dma_sg_dmabuf_ops_release(struct dma_buf *dbuf)
 	vb2_dma_sg_put(dbuf->priv);
 }
 
+static int vb2_dma_sg_dmabuf_begin_cpu_access(struct dma_buf *dbuf,
+		size_t start, size_t len, enum dma_data_direction dir)
+{
+	struct vb2_dma_sg_buf *buf = dbuf->priv;
+
+	vb2_dma_sg_vaddr(buf);
+	return 0;
+}
+
 static void *vb2_dma_sg_dmabuf_ops_kmap(struct dma_buf *dbuf, unsigned long pgnum)
 {
 	struct vb2_dma_sg_buf *buf = dbuf->priv;
+	struct sg_table *sgt = buf->dma_sgt;
 
+	if (WARN_ON(!buf->vaddr))
+		return NULL;
+	dma_sync_sg_for_cpu(buf->dev, sgt->sgl, sgt->nents, buf->dma_dir);
 	return buf->vaddr + pgnum * PAGE_SIZE;
 }
 
 static void *vb2_dma_sg_dmabuf_ops_vmap(struct dma_buf *dbuf)
 {
 	struct vb2_dma_sg_buf *buf = dbuf->priv;
+	struct sg_table *sgt = buf->dma_sgt;
 
-	return vb2_dma_sg_vaddr(buf);
+	if (WARN_ON(!buf->vaddr))
+		return NULL;
+	dma_sync_sg_for_cpu(buf->dev, sgt->sgl, sgt->nents, buf->dma_dir);
+	return buf->vaddr;
+}
+
+static void vb2_dma_sg_dmabuf_ops_kunmap(struct dma_buf *dbuf, unsigned long pgnum, void *vaddr)
+{
+	struct vb2_dma_sg_buf *buf = dbuf->priv;
+	struct sg_table *sgt = buf->dma_sgt;
+
+	dma_sync_sg_for_device(buf->dev, sgt->sgl, sgt->nents, buf->dma_dir);
+}
+
+static void vb2_dma_sg_dmabuf_ops_vunmap(struct dma_buf *dbuf, void *vaddr)
+{
+	struct vb2_dma_sg_buf *buf = dbuf->priv;
+	struct sg_table *sgt = buf->dma_sgt;
+
+	dma_sync_sg_for_device(buf->dev, sgt->sgl, sgt->nents, buf->dma_dir);
 }
 
 static int vb2_dma_sg_dmabuf_ops_mmap(struct dma_buf *dbuf,
@@ -569,9 +602,13 @@ static struct dma_buf_ops vb2_dma_sg_dmabuf_ops = {
 	.detach = vb2_dma_sg_dmabuf_ops_detach,
 	.map_dma_buf = vb2_dma_sg_dmabuf_ops_map,
 	.unmap_dma_buf = vb2_dma_sg_dmabuf_ops_unmap,
+	.begin_cpu_access = vb2_dma_sg_dmabuf_begin_cpu_access,
 	.kmap = vb2_dma_sg_dmabuf_ops_kmap,
 	.kmap_atomic = vb2_dma_sg_dmabuf_ops_kmap,
+	.kunmap = vb2_dma_sg_dmabuf_ops_kunmap,
+	.kunmap_atomic = vb2_dma_sg_dmabuf_ops_kunmap,
 	.vmap = vb2_dma_sg_dmabuf_ops_vmap,
+	.vunmap = vb2_dma_sg_dmabuf_ops_vunmap,
 	.mmap = vb2_dma_sg_dmabuf_ops_mmap,
 	.release = vb2_dma_sg_dmabuf_ops_release,
 };
@@ -688,6 +725,36 @@ static void *vb2_dma_sg_attach_dmabuf(void *alloc_ctx, struct dma_buf *dbuf,
 	return buf;
 }
 
+static void *vb2_dma_sg_begin_cpu_access(void *mem_priv)
+{
+	struct vb2_dma_sg_buf *buf = mem_priv;
+	int ret;
+
+	if (!buf->db_attach)
+		return vb2_dma_sg_vaddr(buf);
+
+	ret = dma_buf_begin_cpu_access(buf->db_attach->dmabuf,
+			0, buf->size, buf->dma_dir);
+	if (ret)
+		return NULL;
+	buf->vaddr = dma_buf_vmap(buf->db_attach->dmabuf);
+	if (buf->vaddr == NULL)
+		dma_buf_end_cpu_access(buf->db_attach->dmabuf,
+				0, buf->size, buf->dma_dir);
+	return buf->vaddr;
+}
+
+static void vb2_dma_sg_end_cpu_access(void *mem_priv)
+{
+	struct vb2_dma_sg_buf *buf = mem_priv;
+
+	if (!buf->db_attach)
+		return;
+	dma_buf_vunmap(buf->db_attach->dmabuf, buf->vaddr);
+	dma_buf_end_cpu_access(buf->db_attach->dmabuf,
+			0, buf->size, buf->dma_dir);
+}
+
 static void *vb2_dma_sg_cookie(void *buf_priv)
 {
 	struct vb2_dma_sg_buf *buf = buf_priv;
@@ -710,6 +777,8 @@ const struct vb2_mem_ops vb2_dma_sg_memops = {
 	.unmap_dmabuf	= vb2_dma_sg_unmap_dmabuf,
 	.attach_dmabuf	= vb2_dma_sg_attach_dmabuf,
 	.detach_dmabuf	= vb2_dma_sg_detach_dmabuf,
+	.begin_cpu_access = vb2_dma_sg_begin_cpu_access,
+	.end_cpu_access = vb2_dma_sg_end_cpu_access,
 	.cookie		= vb2_dma_sg_cookie,
 };
 EXPORT_SYMBOL_GPL(vb2_dma_sg_memops);
diff --git a/drivers/media/v4l2-core/videobuf2-vmalloc.c b/drivers/media/v4l2-core/videobuf2-vmalloc.c
index 0f79f8d..8623752 100644
--- a/drivers/media/v4l2-core/videobuf2-vmalloc.c
+++ b/drivers/media/v4l2-core/videobuf2-vmalloc.c
@@ -337,15 +337,16 @@ static void vb2_vmalloc_dmabuf_ops_release(struct dma_buf *dbuf)
 static void *vb2_vmalloc_dmabuf_ops_kmap(struct dma_buf *dbuf, unsigned long pgnum)
 {
 	struct vb2_vmalloc_buf *buf = dbuf->priv;
+	void *vaddr = vb2_vmalloc_vaddr(buf);
 
-	return buf->vaddr + pgnum * PAGE_SIZE;
+	return vaddr ? vaddr + pgnum * PAGE_SIZE : NULL;
 }
 
 static void *vb2_vmalloc_dmabuf_ops_vmap(struct dma_buf *dbuf)
 {
 	struct vb2_vmalloc_buf *buf = dbuf->priv;
 
-	return buf->vaddr;
+	return vb2_vmalloc_vaddr(buf);
 }
 
 static int vb2_vmalloc_dmabuf_ops_mmap(struct dma_buf *dbuf,
@@ -434,6 +435,38 @@ static void *vb2_vmalloc_attach_dmabuf(void *alloc_ctx, struct dma_buf *dbuf,
 	return buf;
 }
 
+static void *vb2_vmalloc_begin_cpu_access(void *mem_priv)
+{
+	struct vb2_vmalloc_buf *buf = mem_priv;
+	int ret;
+
+	if (!buf->db_attach)
+		return vb2_vmalloc_vaddr(buf);
+
+	ret = dma_buf_begin_cpu_access(buf->db_attach->dmabuf,
+			0, buf->size, buf->dma_dir);
+	if (ret)
+		return NULL;
+	buf->vaddr = dma_buf_vmap(buf->db_attach->dmabuf);
+	if (buf->vaddr == NULL)
+		dma_buf_end_cpu_access(buf->db_attach->dmabuf,
+				0, buf->size, buf->dma_dir);
+
+	return buf->vaddr;
+}
+
+static void vb2_vmalloc_end_cpu_access(void *mem_priv)
+{
+	struct vb2_vmalloc_buf *buf = mem_priv;
+
+	if (!buf->db_attach)
+		return;
+	dma_buf_vunmap(buf->db_attach->dmabuf, buf->vaddr);
+	buf->vaddr = NULL;
+	dma_buf_end_cpu_access(buf->db_attach->dmabuf,
+			0, buf->size, buf->dma_dir);
+}
+
 
 const struct vb2_mem_ops vb2_vmalloc_memops = {
 	.alloc		= vb2_vmalloc_alloc,
@@ -446,6 +479,8 @@ const struct vb2_mem_ops vb2_vmalloc_memops = {
 	.attach_dmabuf	= vb2_vmalloc_attach_dmabuf,
 	.detach_dmabuf	= vb2_vmalloc_detach_dmabuf,
 	.vaddr		= vb2_vmalloc_vaddr,
+	.begin_cpu_access = vb2_vmalloc_begin_cpu_access,
+	.end_cpu_access = vb2_vmalloc_end_cpu_access,
 	.mmap		= vb2_vmalloc_mmap,
 	.num_users	= vb2_vmalloc_num_users,
 };
diff --git a/include/media/videobuf2-core.h b/include/media/videobuf2-core.h
index fcd2af6..91c1216 100644
--- a/include/media/videobuf2-core.h
+++ b/include/media/videobuf2-core.h
@@ -64,8 +64,11 @@ struct vb2_threadio_data;
  * @finish:	called every time the buffer is passed back from the driver
  *		to the userspace, also optional.
  * @vaddr:	return a kernel virtual address to a given memory buffer
+ * @begin_cpu_access: return a kernel virtual address to a given memory buffer
  *		associated with the passed private structure or NULL if no
- *		such mapping exists.
+ *		such mapping exists. This memory buffer can be written by the
+ *		cpu.
+ * @end_cpu_access: call this when you are done writing to the memory buffer.
  * @cookie:	return allocator specific cookie for a given memory buffer
  *		associated with the passed private structure or NULL if not
  *		available.
@@ -77,9 +80,10 @@ struct vb2_threadio_data;
  *
  * Required ops for USERPTR types: get_userptr, put_userptr.
  * Required ops for MMAP types: alloc, put, num_users, mmap.
- * Required ops for read/write access types: alloc, put, num_users, vaddr.
+ * Required ops for read/write access types: alloc, put, num_users, vaddr,
+ * 			begin_cpu_access, end_cpu_access.
  * Required ops for DMABUF types: attach_dmabuf, detach_dmabuf, map_dmabuf,
- *				  unmap_dmabuf.
+ *			unmap_dmabuf, begin_cpu_access, end_cpu_access.
  */
 struct vb2_mem_ops {
 	void		*(*alloc)(void *alloc_ctx, unsigned long size,
@@ -102,6 +106,8 @@ struct vb2_mem_ops {
 	void		(*detach_dmabuf)(void *buf_priv);
 	int		(*map_dmabuf)(void *buf_priv);
 	void		(*unmap_dmabuf)(void *buf_priv);
+	void		*(*begin_cpu_access)(void *buf_priv);
+	void		(*end_cpu_access)(void *buf_priv);
 
 	void		*(*vaddr)(void *buf_priv);
 	void		*(*cookie)(void *buf_priv);
@@ -226,6 +232,8 @@ struct vb2_buffer {
 	u32		cnt_mem_map_dmabuf;
 	u32		cnt_mem_unmap_dmabuf;
 	u32		cnt_mem_vaddr;
+	u32		cnt_mem_begin_cpu_access;
+	u32		cnt_mem_end_cpu_access;
 	u32		cnt_mem_cookie;
 	u32		cnt_mem_num_users;
 	u32		cnt_mem_mmap;
@@ -447,6 +455,8 @@ struct vb2_queue {
 };
 
 void *vb2_plane_vaddr(struct vb2_buffer *vb, unsigned int plane_no);
+void *vb2_plane_begin_cpu_access(struct vb2_buffer *vb, unsigned int plane_no);
+void vb2_plane_end_cpu_access(struct vb2_buffer *vb, unsigned int plane_no);
 void *vb2_plane_cookie(struct vb2_buffer *vb, unsigned int plane_no);
 
 void vb2_buffer_done(struct vb2_buffer *vb, enum vb2_buffer_state state);
-- 
2.1.1

