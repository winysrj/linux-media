Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud2.xs4all.net ([194.109.24.21]:49029 "EHLO
	lb1-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751307AbaKGJAD (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 7 Nov 2014 04:00:03 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: pawel@osciak.com, m.szyprowski@samsung.com,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFCv5 PATCH 14/15] vb2: drop the unused vb2_plane_vaddr function.
Date: Fri,  7 Nov 2014 09:50:33 +0100
Message-Id: <1415350234-9826-15-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1415350234-9826-1-git-send-email-hverkuil@xs4all.nl>
References: <1415350234-9826-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Now that all drivers have been converted, this function can be dropped.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/v4l2-core/videobuf2-core.c       |  8 +-------
 drivers/media/v4l2-core/videobuf2-dma-contig.c | 11 -----------
 drivers/media/v4l2-core/videobuf2-dma-sg.c     |  1 -
 drivers/media/v4l2-core/videobuf2-vmalloc.c    |  1 -
 include/media/videobuf2-core.h                 |  6 +-----
 5 files changed, 2 insertions(+), 25 deletions(-)

diff --git a/drivers/media/v4l2-core/videobuf2-core.c b/drivers/media/v4l2-core/videobuf2-core.c
index 036b947..5138a9f 100644
--- a/drivers/media/v4l2-core/videobuf2-core.c
+++ b/drivers/media/v4l2-core/videobuf2-core.c
@@ -1129,15 +1129,9 @@ void *vb2_plane_begin_cpu_access(struct vb2_buffer *vb, unsigned int plane_no)
 		return NULL;
 
 	return call_ptr_memop(vb, begin_cpu_access, vb->planes[plane_no].mem_priv);
-}
-EXPORT_SYMBOL_GPL(vb2_plane_begin_cpu_access);
 
-/* Keep this for backwards compatibility. Will be removed soon. */
-void *vb2_plane_vaddr(struct vb2_buffer *vb, unsigned int plane_no)
-{
-	return vb2_plane_begin_cpu_access(vb, plane_no);
 }
-EXPORT_SYMBOL_GPL(vb2_plane_vaddr);
+EXPORT_SYMBOL_GPL(vb2_plane_begin_cpu_access);
 
 /**
  * vb2_plane_end_cpu_access() - Return a kernel virtual address of a given plane
diff --git a/drivers/media/v4l2-core/videobuf2-dma-contig.c b/drivers/media/v4l2-core/videobuf2-dma-contig.c
index 58a4bf2..629ca2e 100644
--- a/drivers/media/v4l2-core/videobuf2-dma-contig.c
+++ b/drivers/media/v4l2-core/videobuf2-dma-contig.c
@@ -94,16 +94,6 @@ static void *vb2_dc_cookie(void *buf_priv)
 	return &buf->dma_addr;
 }
 
-static void *vb2_dc_vaddr(void *buf_priv)
-{
-	struct vb2_dc_buf *buf = buf_priv;
-
-	if (!buf->vaddr && buf->db_attach)
-		buf->vaddr = dma_buf_vmap(buf->db_attach->dmabuf);
-
-	return buf->vaddr;
-}
-
 static unsigned int vb2_dc_num_users(void *buf_priv)
 {
 	struct vb2_dc_buf *buf = buf_priv;
@@ -895,7 +885,6 @@ const struct vb2_mem_ops vb2_dma_contig_memops = {
 	.put		= vb2_dc_put,
 	.get_dmabuf	= vb2_dc_get_dmabuf,
 	.cookie		= vb2_dc_cookie,
-	.vaddr		= vb2_dc_vaddr,
 	.mmap		= vb2_dc_mmap,
 	.get_userptr	= vb2_dc_get_userptr,
 	.put_userptr	= vb2_dc_put_userptr,
diff --git a/drivers/media/v4l2-core/videobuf2-dma-sg.c b/drivers/media/v4l2-core/videobuf2-dma-sg.c
index 954ce74..0281a85 100644
--- a/drivers/media/v4l2-core/videobuf2-dma-sg.c
+++ b/drivers/media/v4l2-core/videobuf2-dma-sg.c
@@ -769,7 +769,6 @@ const struct vb2_mem_ops vb2_dma_sg_memops = {
 	.put_userptr	= vb2_dma_sg_put_userptr,
 	.prepare	= vb2_dma_sg_prepare,
 	.finish		= vb2_dma_sg_finish,
-	.vaddr		= vb2_dma_sg_vaddr,
 	.mmap		= vb2_dma_sg_mmap,
 	.num_users	= vb2_dma_sg_num_users,
 	.get_dmabuf	= vb2_dma_sg_get_dmabuf,
diff --git a/drivers/media/v4l2-core/videobuf2-vmalloc.c b/drivers/media/v4l2-core/videobuf2-vmalloc.c
index 8623752..5c21190 100644
--- a/drivers/media/v4l2-core/videobuf2-vmalloc.c
+++ b/drivers/media/v4l2-core/videobuf2-vmalloc.c
@@ -478,7 +478,6 @@ const struct vb2_mem_ops vb2_vmalloc_memops = {
 	.unmap_dmabuf	= vb2_vmalloc_unmap_dmabuf,
 	.attach_dmabuf	= vb2_vmalloc_attach_dmabuf,
 	.detach_dmabuf	= vb2_vmalloc_detach_dmabuf,
-	.vaddr		= vb2_vmalloc_vaddr,
 	.begin_cpu_access = vb2_vmalloc_begin_cpu_access,
 	.end_cpu_access = vb2_vmalloc_end_cpu_access,
 	.mmap		= vb2_vmalloc_mmap,
diff --git a/include/media/videobuf2-core.h b/include/media/videobuf2-core.h
index 91c1216..4632341 100644
--- a/include/media/videobuf2-core.h
+++ b/include/media/videobuf2-core.h
@@ -63,7 +63,6 @@ struct vb2_threadio_data;
  *		driver, useful for cache synchronisation, optional.
  * @finish:	called every time the buffer is passed back from the driver
  *		to the userspace, also optional.
- * @vaddr:	return a kernel virtual address to a given memory buffer
  * @begin_cpu_access: return a kernel virtual address to a given memory buffer
  *		associated with the passed private structure or NULL if no
  *		such mapping exists. This memory buffer can be written by the
@@ -80,7 +79,7 @@ struct vb2_threadio_data;
  *
  * Required ops for USERPTR types: get_userptr, put_userptr.
  * Required ops for MMAP types: alloc, put, num_users, mmap.
- * Required ops for read/write access types: alloc, put, num_users, vaddr,
+ * Required ops for read/write access types: alloc, put, num_users,
  * 			begin_cpu_access, end_cpu_access.
  * Required ops for DMABUF types: attach_dmabuf, detach_dmabuf, map_dmabuf,
  *			unmap_dmabuf, begin_cpu_access, end_cpu_access.
@@ -109,7 +108,6 @@ struct vb2_mem_ops {
 	void		*(*begin_cpu_access)(void *buf_priv);
 	void		(*end_cpu_access)(void *buf_priv);
 
-	void		*(*vaddr)(void *buf_priv);
 	void		*(*cookie)(void *buf_priv);
 
 	unsigned int	(*num_users)(void *buf_priv);
@@ -231,7 +229,6 @@ struct vb2_buffer {
 	u32		cnt_mem_detach_dmabuf;
 	u32		cnt_mem_map_dmabuf;
 	u32		cnt_mem_unmap_dmabuf;
-	u32		cnt_mem_vaddr;
 	u32		cnt_mem_begin_cpu_access;
 	u32		cnt_mem_end_cpu_access;
 	u32		cnt_mem_cookie;
@@ -454,7 +451,6 @@ struct vb2_queue {
 #endif
 };
 
-void *vb2_plane_vaddr(struct vb2_buffer *vb, unsigned int plane_no);
 void *vb2_plane_begin_cpu_access(struct vb2_buffer *vb, unsigned int plane_no);
 void vb2_plane_end_cpu_access(struct vb2_buffer *vb, unsigned int plane_no);
 void *vb2_plane_cookie(struct vb2_buffer *vb, unsigned int plane_no);
-- 
2.1.1

