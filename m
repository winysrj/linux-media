Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.samsung.com ([203.254.224.34]:49203 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932259Ab2JJPAd (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 10 Oct 2012 11:00:33 -0400
Received: from epcpsbgm1.samsung.com (epcpsbgm1 [203.254.230.26])
 by mailout4.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MBO00BEBN0MK980@mailout4.samsung.com> for
 linux-media@vger.kernel.org; Thu, 11 Oct 2012 00:00:32 +0900 (KST)
Received: from mcdsrvbld02.digital.local ([106.116.37.23])
 by mmp1.samsung.com (Oracle Communications Messaging Server 7u4-24.01
 (7.0.4.24.0) 64bit (built Nov 17 2011))
 with ESMTPA id <0MBO002YDME0EC70@mmp1.samsung.com> for
 linux-media@vger.kernel.org; Thu, 11 Oct 2012 00:00:32 +0900 (KST)
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
Subject: [PATCHv10 19/26] v4l: vb2: add buffer exporting via dmabuf
Date: Wed, 10 Oct 2012 16:46:38 +0200
Message-id: <1349880405-26049-20-git-send-email-t.stanislaws@samsung.com>
In-reply-to: <1349880405-26049-1-git-send-email-t.stanislaws@samsung.com>
References: <1349880405-26049-1-git-send-email-t.stanislaws@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch adds extension to videobuf2-core. It allow to export a mmap buffer
as a file descriptor.

Signed-off-by: Tomasz Stanislawski <t.stanislaws@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Acked-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/v4l2-core/v4l2-mem2mem.c   |   13 +++++
 drivers/media/v4l2-core/videobuf2-core.c |   83 ++++++++++++++++++++++++++++++
 include/media/v4l2-mem2mem.h             |    3 ++
 include/media/videobuf2-core.h           |    4 ++
 4 files changed, 103 insertions(+)

diff --git a/drivers/media/v4l2-core/v4l2-mem2mem.c b/drivers/media/v4l2-core/v4l2-mem2mem.c
index 3ac8358..9aa7cc7 100644
--- a/drivers/media/v4l2-core/v4l2-mem2mem.c
+++ b/drivers/media/v4l2-core/v4l2-mem2mem.c
@@ -369,6 +369,19 @@ int v4l2_m2m_dqbuf(struct file *file, struct v4l2_m2m_ctx *m2m_ctx,
 EXPORT_SYMBOL_GPL(v4l2_m2m_dqbuf);
 
 /**
+ * v4l2_m2m_expbuf() - export a source or destination buffer, depending on
+ * the type
+ */
+int v4l2_m2m_expbuf(struct file *file, struct v4l2_m2m_ctx *m2m_ctx,
+		  struct v4l2_exportbuffer *eb)
+{
+	struct vb2_queue *vq;
+
+	vq = v4l2_m2m_get_vq(m2m_ctx, eb->type);
+	return vb2_expbuf(vq, eb);
+}
+EXPORT_SYMBOL_GPL(v4l2_m2m_expbuf);
+/**
  * v4l2_m2m_streamon() - turn on streaming for a video queue
  */
 int v4l2_m2m_streamon(struct file *file, struct v4l2_m2m_ctx *m2m_ctx,
diff --git a/drivers/media/v4l2-core/videobuf2-core.c b/drivers/media/v4l2-core/videobuf2-core.c
index 613dea1..9f81be2 100644
--- a/drivers/media/v4l2-core/videobuf2-core.c
+++ b/drivers/media/v4l2-core/videobuf2-core.c
@@ -1751,6 +1751,79 @@ static int __find_plane_by_offset(struct vb2_queue *q, unsigned long off,
 }
 
 /**
+ * vb2_expbuf() - Export a buffer as a file descriptor
+ * @q:		videobuf2 queue
+ * @eb:		export buffer structure passed from userspace to vidioc_expbuf
+ *		handler in driver
+ *
+ * The return values from this function are intended to be directly returned
+ * from vidioc_expbuf handler in driver.
+ */
+int vb2_expbuf(struct vb2_queue *q, struct v4l2_exportbuffer *eb)
+{
+	struct vb2_buffer *vb = NULL;
+	struct vb2_plane *vb_plane;
+	int ret;
+	struct dma_buf *dbuf;
+
+	if (q->memory != V4L2_MEMORY_MMAP) {
+		dprintk(1, "Queue is not currently set up for mmap\n");
+		return -EINVAL;
+	}
+
+	if (!q->mem_ops->get_dmabuf) {
+		dprintk(1, "Queue does not support DMA buffer exporting\n");
+		return -EINVAL;
+	}
+
+	if (eb->flags & ~O_CLOEXEC) {
+		dprintk(1, "Queue does support only O_CLOEXEC flag\n");
+		return -EINVAL;
+	}
+
+	if (eb->type != q->type) {
+		dprintk(1, "qbuf: invalid buffer type\n");
+		return -EINVAL;
+	}
+
+	if (eb->index >= q->num_buffers) {
+		dprintk(1, "buffer index out of range\n");
+		return -EINVAL;
+	}
+
+	vb = q->bufs[eb->index];
+
+	if (eb->plane >= vb->num_planes) {
+		dprintk(1, "buffer plane out of range\n");
+		return -EINVAL;
+	}
+
+	vb_plane = &vb->planes[eb->plane];
+
+	dbuf = call_memop(q, get_dmabuf, vb_plane->mem_priv);
+	if (IS_ERR_OR_NULL(dbuf)) {
+		dprintk(1, "Failed to export buffer %d, plane %d\n",
+			eb->index, eb->plane);
+		return -EINVAL;
+	}
+
+	ret = dma_buf_fd(dbuf, eb->flags);
+	if (ret < 0) {
+		dprintk(3, "buffer %d, plane %d failed to export (%d)\n",
+			eb->index, eb->plane, ret);
+		dma_buf_put(dbuf);
+		return ret;
+	}
+
+	dprintk(3, "buffer %d, plane %d exported as %d descriptor\n",
+		eb->index, eb->plane, ret);
+	eb->fd = ret;
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(vb2_expbuf);
+
+/**
  * vb2_mmap() - map video buffers into application address space
  * @q:		videobuf2 queue
  * @vma:	vma passed to the mmap file operation handler in the driver
@@ -2456,6 +2529,16 @@ int vb2_ioctl_streamoff(struct file *file, void *priv, enum v4l2_buf_type i)
 }
 EXPORT_SYMBOL_GPL(vb2_ioctl_streamoff);
 
+int vb2_ioctl_expbuf(struct file *file, void *priv, struct v4l2_exportbuffer *p)
+{
+	struct video_device *vdev = video_devdata(file);
+
+	if (vb2_queue_is_busy(vdev, file))
+		return -EBUSY;
+	return vb2_expbuf(vdev->queue, p);
+}
+EXPORT_SYMBOL_GPL(vb2_ioctl_expbuf);
+
 /* v4l2_file_operations helpers */
 
 int vb2_fop_mmap(struct file *file, struct vm_area_struct *vma)
diff --git a/include/media/v4l2-mem2mem.h b/include/media/v4l2-mem2mem.h
index 131cc4a..7e82d2b 100644
--- a/include/media/v4l2-mem2mem.h
+++ b/include/media/v4l2-mem2mem.h
@@ -111,6 +111,9 @@ int v4l2_m2m_qbuf(struct file *file, struct v4l2_m2m_ctx *m2m_ctx,
 int v4l2_m2m_dqbuf(struct file *file, struct v4l2_m2m_ctx *m2m_ctx,
 		   struct v4l2_buffer *buf);
 
+int v4l2_m2m_expbuf(struct file *file, struct v4l2_m2m_ctx *m2m_ctx,
+		   struct v4l2_exportbuffer *eb);
+
 int v4l2_m2m_streamon(struct file *file, struct v4l2_m2m_ctx *m2m_ctx,
 		      enum v4l2_buf_type type);
 int v4l2_m2m_streamoff(struct file *file, struct v4l2_m2m_ctx *m2m_ctx,
diff --git a/include/media/videobuf2-core.h b/include/media/videobuf2-core.h
index 24b9c90..9cfd4ee 100644
--- a/include/media/videobuf2-core.h
+++ b/include/media/videobuf2-core.h
@@ -81,6 +81,7 @@ struct vb2_fileio_data;
 struct vb2_mem_ops {
 	void		*(*alloc)(void *alloc_ctx, unsigned long size);
 	void		(*put)(void *buf_priv);
+	struct dma_buf *(*get_dmabuf)(void *buf_priv);
 
 	void		*(*get_userptr)(void *alloc_ctx, unsigned long vaddr,
 					unsigned long size, int write);
@@ -363,6 +364,7 @@ int __must_check vb2_queue_init(struct vb2_queue *q);
 void vb2_queue_release(struct vb2_queue *q);
 
 int vb2_qbuf(struct vb2_queue *q, struct v4l2_buffer *b);
+int vb2_expbuf(struct vb2_queue *q, struct v4l2_exportbuffer *eb);
 int vb2_dqbuf(struct vb2_queue *q, struct v4l2_buffer *b, bool nonblocking);
 
 int vb2_streamon(struct vb2_queue *q, enum v4l2_buf_type type);
@@ -472,6 +474,8 @@ int vb2_ioctl_qbuf(struct file *file, void *priv, struct v4l2_buffer *p);
 int vb2_ioctl_dqbuf(struct file *file, void *priv, struct v4l2_buffer *p);
 int vb2_ioctl_streamon(struct file *file, void *priv, enum v4l2_buf_type i);
 int vb2_ioctl_streamoff(struct file *file, void *priv, enum v4l2_buf_type i);
+int vb2_ioctl_expbuf(struct file *file, void *priv,
+	struct v4l2_exportbuffer *p);
 
 /* struct v4l2_file_operations helpers */
 
-- 
1.7.9.5

