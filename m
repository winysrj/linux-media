Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.samsung.com ([203.254.224.25]:36520 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753653Ab2JBO2T (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 2 Oct 2012 10:28:19 -0400
Received: from epcpsbgm1.samsung.com (epcpsbgm1 [203.254.230.26])
 by mailout2.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MB9006CTS6X0Z40@mailout2.samsung.com> for
 linux-media@vger.kernel.org; Tue, 02 Oct 2012 23:28:17 +0900 (KST)
Received: from mcdsrvbld02.digital.local ([106.116.37.23])
 by mmp2.samsung.com (Oracle Communications Messaging Server 7u4-24.01
 (7.0.4.24.0) 64bit (built Nov 17 2011))
 with ESMTPA id <0MB9005A7S65K790@mmp2.samsung.com> for
 linux-media@vger.kernel.org; Tue, 02 Oct 2012 23:28:17 +0900 (KST)
From: Tomasz Stanislawski <t.stanislaws@samsung.com>
To: linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org
Cc: airlied@redhat.com, m.szyprowski@samsung.com,
	t.stanislaws@samsung.com, kyungmin.park@samsung.com,
	laurent.pinchart@ideasonboard.com, sumit.semwal@ti.com,
	daeinki@gmail.com, daniel.vetter@ffwll.ch, robdclark@gmail.com,
	pawel@osciak.com, linaro-mm-sig@lists.linaro.org,
	hverkuil@xs4all.nl, remi@remlab.net, subashrp@gmail.com,
	mchehab@redhat.com, zhangfei.gao@gmail.com, s.nawrocki@samsung.com,
	k.debski@samsung.com, Sumit Semwal <sumit.semwal@linaro.org>
Subject: [PATCHv9 03/25] v4l: vb2: add support for shared buffer (dma_buf)
Date: Tue, 02 Oct 2012 16:27:14 +0200
Message-id: <1349188056-4886-4-git-send-email-t.stanislaws@samsung.com>
In-reply-to: <1349188056-4886-1-git-send-email-t.stanislaws@samsung.com>
References: <1349188056-4886-1-git-send-email-t.stanislaws@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Sumit Semwal <sumit.semwal@ti.com>

This patch adds support for DMABUF memory type in videobuf2. It calls relevant
APIs of dma_buf for v4l reqbuf / qbuf / dqbuf operations.

For this version, the support is for videobuf2 as a user of the shared buffer;
so the allocation of the buffer is done outside of V4L2. [A sample allocator of
dma-buf shared buffer is given at [1]]

[1]: Rob Clark's DRM:
   https://github.com/robclark/kernel-omap4/commits/drmplane-dmabuf

Signed-off-by: Tomasz Stanislawski <t.stanislaws@samsung.com>
   [original work in the PoC for buffer sharing]
Signed-off-by: Sumit Semwal <sumit.semwal@ti.com>
Signed-off-by: Sumit Semwal <sumit.semwal@linaro.org>
Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/media/video/Kconfig          |    1 +
 drivers/media/video/videobuf2-core.c |  207 +++++++++++++++++++++++++++++++++-
 include/media/videobuf2-core.h       |   27 +++++
 3 files changed, 232 insertions(+), 3 deletions(-)

diff --git a/drivers/media/video/Kconfig b/drivers/media/video/Kconfig
index c128fac..c558d37 100644
--- a/drivers/media/video/Kconfig
+++ b/drivers/media/video/Kconfig
@@ -45,6 +45,7 @@ config V4L2_MEM2MEM_DEV
 	depends on VIDEOBUF2_CORE
 
 config VIDEOBUF2_CORE
+	select DMA_SHARED_BUFFER
 	tristate
 
 config VIDEOBUF2_MEMOPS
diff --git a/drivers/media/video/videobuf2-core.c b/drivers/media/video/videobuf2-core.c
index 268c7dd..901bc56 100644
--- a/drivers/media/video/videobuf2-core.c
+++ b/drivers/media/video/videobuf2-core.c
@@ -109,6 +109,36 @@ static void __vb2_buf_userptr_put(struct vb2_buffer *vb)
 }
 
 /**
+ * __vb2_plane_dmabuf_put() - release memory associated with
+ * a DMABUF shared plane
+ */
+static void __vb2_plane_dmabuf_put(struct vb2_queue *q, struct vb2_plane *p)
+{
+	if (!p->mem_priv)
+		return;
+
+	if (p->dbuf_mapped)
+		call_memop(q, unmap_dmabuf, p->mem_priv);
+
+	call_memop(q, detach_dmabuf, p->mem_priv);
+	dma_buf_put(p->dbuf);
+	memset(p, 0, sizeof(*p));
+}
+
+/**
+ * __vb2_buf_dmabuf_put() - release memory associated with
+ * a DMABUF shared buffer
+ */
+static void __vb2_buf_dmabuf_put(struct vb2_buffer *vb)
+{
+	struct vb2_queue *q = vb->vb2_queue;
+	unsigned int plane;
+
+	for (plane = 0; plane < vb->num_planes; ++plane)
+		__vb2_plane_dmabuf_put(q, &vb->planes[plane]);
+}
+
+/**
  * __setup_offsets() - setup unique offsets ("cookies") for every plane in
  * every buffer on the queue
  */
@@ -230,6 +260,8 @@ static void __vb2_free_mem(struct vb2_queue *q, unsigned int buffers)
 		/* Free MMAP buffers or release USERPTR buffers */
 		if (q->memory == V4L2_MEMORY_MMAP)
 			__vb2_buf_mem_free(vb);
+		else if (q->memory == V4L2_MEMORY_DMABUF)
+			__vb2_buf_dmabuf_put(vb);
 		else
 			__vb2_buf_userptr_put(vb);
 	}
@@ -363,6 +395,8 @@ static int __fill_v4l2_buffer(struct vb2_buffer *vb, struct v4l2_buffer *b)
 			b->m.offset = vb->v4l2_planes[0].m.mem_offset;
 		else if (q->memory == V4L2_MEMORY_USERPTR)
 			b->m.userptr = vb->v4l2_planes[0].m.userptr;
+		else if (q->memory == V4L2_MEMORY_DMABUF)
+			b->m.fd = vb->v4l2_planes[0].m.fd;
 	}
 
 	/*
@@ -454,13 +488,28 @@ static int __verify_mmap_ops(struct vb2_queue *q)
 }
 
 /**
+ * __verify_dmabuf_ops() - verify that all memory operations required for
+ * DMABUF queue type have been provided
+ */
+static int __verify_dmabuf_ops(struct vb2_queue *q)
+{
+	if (!(q->io_modes & VB2_DMABUF) || !q->mem_ops->attach_dmabuf ||
+	    !q->mem_ops->detach_dmabuf  || !q->mem_ops->map_dmabuf ||
+	    !q->mem_ops->unmap_dmabuf)
+		return -EINVAL;
+
+	return 0;
+}
+
+/**
  * __verify_memory_type() - Check whether the memory type and buffer type
  * passed to a buffer operation are compatible with the queue.
  */
 static int __verify_memory_type(struct vb2_queue *q,
 		enum v4l2_memory memory, enum v4l2_buf_type type)
 {
-	if (memory != V4L2_MEMORY_MMAP && memory != V4L2_MEMORY_USERPTR) {
+	if (memory != V4L2_MEMORY_MMAP && memory != V4L2_MEMORY_USERPTR &&
+	    memory != V4L2_MEMORY_DMABUF) {
 		dprintk(1, "reqbufs: unsupported memory type\n");
 		return -EINVAL;
 	}
@@ -484,6 +533,11 @@ static int __verify_memory_type(struct vb2_queue *q,
 		return -EINVAL;
 	}
 
+	if (memory == V4L2_MEMORY_DMABUF && __verify_dmabuf_ops(q)) {
+		dprintk(1, "reqbufs: DMABUF for current setup unsupported\n");
+		return -EINVAL;
+	}
+
 	/*
 	 * Place the busy tests at the end: -EBUSY can be ignored when
 	 * create_bufs is called with count == 0, but count == 0 should still
@@ -853,6 +907,16 @@ static int __fill_vb2_buffer(struct vb2_buffer *vb, const struct v4l2_buffer *b,
 					b->m.planes[plane].length;
 			}
 		}
+		if (b->memory == V4L2_MEMORY_DMABUF) {
+			for (plane = 0; plane < vb->num_planes; ++plane) {
+				v4l2_planes[plane].m.fd =
+					b->m.planes[plane].m.fd;
+				v4l2_planes[plane].length =
+					b->m.planes[plane].length;
+				v4l2_planes[plane].data_offset =
+					b->m.planes[plane].data_offset;
+			}
+		}
 	} else {
 		/*
 		 * Single-planar buffers do not use planes array,
@@ -867,6 +931,12 @@ static int __fill_vb2_buffer(struct vb2_buffer *vb, const struct v4l2_buffer *b,
 			v4l2_planes[0].m.userptr = b->m.userptr;
 			v4l2_planes[0].length = b->length;
 		}
+
+		if (b->memory == V4L2_MEMORY_DMABUF) {
+			v4l2_planes[0].m.fd = b->m.fd;
+			v4l2_planes[0].length = b->length;
+		}
+
 	}
 
 	vb->v4l2_buf.field = b->field;
@@ -970,6 +1040,109 @@ static int __qbuf_mmap(struct vb2_buffer *vb, const struct v4l2_buffer *b)
 }
 
 /**
+ * __qbuf_dmabuf() - handle qbuf of a DMABUF buffer
+ */
+static int __qbuf_dmabuf(struct vb2_buffer *vb, const struct v4l2_buffer *b)
+{
+	struct v4l2_plane planes[VIDEO_MAX_PLANES];
+	struct vb2_queue *q = vb->vb2_queue;
+	void *mem_priv;
+	unsigned int plane;
+	int ret;
+	int write = !V4L2_TYPE_IS_OUTPUT(q->type);
+
+	/* Verify and copy relevant information provided by the userspace */
+	ret = __fill_vb2_buffer(vb, b, planes);
+	if (ret)
+		return ret;
+
+	for (plane = 0; plane < vb->num_planes; ++plane) {
+		struct dma_buf *dbuf = dma_buf_get(planes[plane].m.fd);
+
+		if (IS_ERR_OR_NULL(dbuf)) {
+			dprintk(1, "qbuf: invalid dmabuf fd for plane %d\n",
+				plane);
+			ret = -EINVAL;
+			goto err;
+		}
+
+		/* use DMABUF size if length is not provided */
+		if (planes[plane].length == 0)
+			planes[plane].length = dbuf->size;
+
+		if (planes[plane].length < planes[plane].data_offset +
+		    q->plane_sizes[plane]) {
+			ret = -EINVAL;
+			goto err;
+		}
+
+		/* Skip the plane if already verified */
+		if (dbuf == vb->planes[plane].dbuf &&
+		    vb->v4l2_planes[plane].length == planes[plane].length) {
+			dma_buf_put(dbuf);
+			continue;
+		}
+
+		dprintk(1, "qbuf: buffer for plane %d changed\n", plane);
+
+		/* Release previously acquired memory if present */
+		__vb2_plane_dmabuf_put(q, &vb->planes[plane]);
+		memset(&vb->v4l2_planes[plane], 0, sizeof(struct v4l2_plane));
+
+		/* Acquire each plane's memory */
+		mem_priv = call_memop(q, attach_dmabuf, q->alloc_ctx[plane],
+			dbuf, planes[plane].length, write);
+		if (IS_ERR(mem_priv)) {
+			dprintk(1, "qbuf: failed to attach dmabuf\n");
+			ret = PTR_ERR(mem_priv);
+			dma_buf_put(dbuf);
+			goto err;
+		}
+
+		vb->planes[plane].dbuf = dbuf;
+		vb->planes[plane].mem_priv = mem_priv;
+	}
+
+	/* TODO: This pins the buffer(s) with  dma_buf_map_attachment()).. but
+	 * really we want to do this just before the DMA, not while queueing
+	 * the buffer(s)..
+	 */
+	for (plane = 0; plane < vb->num_planes; ++plane) {
+		ret = call_memop(q, map_dmabuf, vb->planes[plane].mem_priv);
+		if (ret) {
+			dprintk(1, "qbuf: failed to map dmabuf for plane %d\n",
+				plane);
+			goto err;
+		}
+		vb->planes[plane].dbuf_mapped = 1;
+	}
+
+	/*
+	 * Call driver-specific initialization on the newly acquired buffer,
+	 * if provided.
+	 */
+	ret = call_qop(q, buf_init, vb);
+	if (ret) {
+		dprintk(1, "qbuf: buffer initialization failed\n");
+		goto err;
+	}
+
+	/*
+	 * Now that everything is in order, copy relevant information
+	 * provided by userspace.
+	 */
+	for (plane = 0; plane < vb->num_planes; ++plane)
+		vb->v4l2_planes[plane] = planes[plane];
+
+	return 0;
+err:
+	/* In case of errors, release planes that were already acquired */
+	__vb2_buf_dmabuf_put(vb);
+
+	return ret;
+}
+
+/**
  * __enqueue_in_driver() - enqueue a vb2_buffer in driver for processing
  */
 static void __enqueue_in_driver(struct vb2_buffer *vb)
@@ -993,6 +1166,9 @@ static int __buf_prepare(struct vb2_buffer *vb, const struct v4l2_buffer *b)
 	case V4L2_MEMORY_USERPTR:
 		ret = __qbuf_userptr(vb, b);
 		break;
+	case V4L2_MEMORY_DMABUF:
+		ret = __qbuf_dmabuf(vb, b);
+		break;
 	default:
 		WARN(1, "Invalid queue type\n");
 		ret = -EINVAL;
@@ -1301,6 +1477,30 @@ int vb2_wait_for_all_buffers(struct vb2_queue *q)
 EXPORT_SYMBOL_GPL(vb2_wait_for_all_buffers);
 
 /**
+ * __vb2_dqbuf() - bring back the buffer to the DEQUEUED state
+ */
+static void __vb2_dqbuf(struct vb2_buffer *vb)
+{
+	struct vb2_queue *q = vb->vb2_queue;
+	unsigned int i;
+
+	/* nothing to do if the buffer is already dequeued */
+	if (vb->state == VB2_BUF_STATE_DEQUEUED)
+		return;
+
+	vb->state = VB2_BUF_STATE_DEQUEUED;
+
+	/* unmap DMABUF buffer */
+	if (q->memory == V4L2_MEMORY_DMABUF)
+		for (i = 0; i < vb->num_planes; ++i) {
+			if (!vb->planes[i].dbuf_mapped)
+				continue;
+			call_memop(q, unmap_dmabuf, vb->planes[i].mem_priv);
+			vb->planes[i].dbuf_mapped = 0;
+		}
+}
+
+/**
  * vb2_dqbuf() - Dequeue a buffer to the userspace
  * @q:		videobuf2 queue
  * @b:		buffer structure passed from userspace to vidioc_dqbuf handler
@@ -1364,11 +1564,12 @@ int vb2_dqbuf(struct vb2_queue *q, struct v4l2_buffer *b, bool nonblocking)
 	__fill_v4l2_buffer(vb, b);
 	/* Remove from videobuf queue */
 	list_del(&vb->queued_entry);
+	/* go back to dequeued state */
+	__vb2_dqbuf(vb);
 
 	dprintk(1, "dqbuf of buffer %d, with state %d\n",
 			vb->v4l2_buf.index, vb->state);
 
-	vb->state = VB2_BUF_STATE_DEQUEUED;
 	return 0;
 }
 EXPORT_SYMBOL_GPL(vb2_dqbuf);
@@ -1407,7 +1608,7 @@ static void __vb2_queue_cancel(struct vb2_queue *q)
 	 * Reinitialize all buffers for next use.
 	 */
 	for (i = 0; i < q->num_buffers; ++i)
-		q->bufs[i]->state = VB2_BUF_STATE_DEQUEUED;
+		__vb2_dqbuf(q->bufs[i]);
 }
 
 /**
diff --git a/include/media/videobuf2-core.h b/include/media/videobuf2-core.h
index 8dd9b6c..84f11f2 100644
--- a/include/media/videobuf2-core.h
+++ b/include/media/videobuf2-core.h
@@ -16,6 +16,7 @@
 #include <linux/mutex.h>
 #include <linux/poll.h>
 #include <linux/videodev2.h>
+#include <linux/dma-buf.h>
 
 struct vb2_alloc_ctx;
 struct vb2_fileio_data;
@@ -41,6 +42,20 @@ struct vb2_fileio_data;
  *		 argument to other ops in this structure
  * @put_userptr: inform the allocator that a USERPTR buffer will no longer
  *		 be used
+ * @attach_dmabuf: attach a shared struct dma_buf for a hardware operation;
+ *		   used for DMABUF memory types; alloc_ctx is the alloc context
+ *		   dbuf is the shared dma_buf; returns NULL on failure;
+ *		   allocator private per-buffer structure on success;
+ *		   this needs to be used for further accesses to the buffer
+ * @detach_dmabuf: inform the exporter of the buffer that the current DMABUF
+ *		   buffer is no longer used; the buf_priv argument is the
+ *		   allocator private per-buffer structure previously returned
+ *		   from the attach_dmabuf callback
+ * @map_dmabuf: request for access to the dmabuf from allocator; the allocator
+ *		of dmabuf is informed that this driver is going to use the
+ *		dmabuf
+ * @unmap_dmabuf: releases access control to the dmabuf - allocator is notified
+ *		  that this driver is done using the dmabuf for now
  * @vaddr:	return a kernel virtual address to a given memory buffer
  *		associated with the passed private structure or NULL if no
  *		such mapping exists
@@ -56,6 +71,8 @@ struct vb2_fileio_data;
  * Required ops for USERPTR types: get_userptr, put_userptr.
  * Required ops for MMAP types: alloc, put, num_users, mmap.
  * Required ops for read/write access types: alloc, put, num_users, vaddr
+ * Required ops for DMABUF types: attach_dmabuf, detach_dmabuf, map_dmabuf,
+ *				  unmap_dmabuf.
  */
 struct vb2_mem_ops {
 	void		*(*alloc)(void *alloc_ctx, unsigned long size);
@@ -65,6 +82,12 @@ struct vb2_mem_ops {
 					unsigned long size, int write);
 	void		(*put_userptr)(void *buf_priv);
 
+	void		*(*attach_dmabuf)(void *alloc_ctx, struct dma_buf *dbuf,
+				unsigned long size, int write);
+	void		(*detach_dmabuf)(void *buf_priv);
+	int		(*map_dmabuf)(void *buf_priv);
+	void		(*unmap_dmabuf)(void *buf_priv);
+
 	void		*(*vaddr)(void *buf_priv);
 	void		*(*cookie)(void *buf_priv);
 
@@ -75,6 +98,8 @@ struct vb2_mem_ops {
 
 struct vb2_plane {
 	void			*mem_priv;
+	struct dma_buf		*dbuf;
+	unsigned int		dbuf_mapped;
 };
 
 /**
@@ -83,12 +108,14 @@ struct vb2_plane {
  * @VB2_USERPTR:	driver supports USERPTR with streaming API
  * @VB2_READ:		driver supports read() style access
  * @VB2_WRITE:		driver supports write() style access
+ * @VB2_DMABUF:		driver supports DMABUF with streaming API
  */
 enum vb2_io_modes {
 	VB2_MMAP	= (1 << 0),
 	VB2_USERPTR	= (1 << 1),
 	VB2_READ	= (1 << 2),
 	VB2_WRITE	= (1 << 3),
+	VB2_DMABUF	= (1 << 4),
 };
 
 /**
-- 
1.7.9.5

