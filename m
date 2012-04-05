Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.w1.samsung.com ([210.118.77.14]:52733 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753118Ab2DEOAe (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 5 Apr 2012 10:00:34 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN
Received: from euspt2 ([210.118.77.14]) by mailout4.w1.samsung.com
 (Sun Java(tm) System Messaging Server 6.3-8.04 (built Jul 29 2009; 32bit))
 with ESMTP id <0M2000M80EX0E670@mailout4.w1.samsung.com> for
 linux-media@vger.kernel.org; Thu, 05 Apr 2012 15:00:36 +0100 (BST)
Received: from linux.samsung.com ([106.116.38.10])
 by spt2.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0M2000FDUEWSTE@spt2.w1.samsung.com> for
 linux-media@vger.kernel.org; Thu, 05 Apr 2012 15:00:29 +0100 (BST)
Date: Thu, 05 Apr 2012 16:00:00 +0200
From: Tomasz Stanislawski <t.stanislaws@samsung.com>
Subject: [PATCH 03/11] v4l: vb2: add support for shared buffer (dma_buf)
In-reply-to: <1333634408-4960-1-git-send-email-t.stanislaws@samsung.com>
To: linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org
Cc: airlied@redhat.com, m.szyprowski@samsung.com,
	t.stanislaws@samsung.com, kyungmin.park@samsung.com,
	laurent.pinchart@ideasonboard.com, sumit.semwal@ti.com,
	daeinki@gmail.com, daniel.vetter@ffwll.ch, robdclark@gmail.com,
	pawel@osciak.com, linaro-mm-sig@lists.linaro.org,
	subashrp@gmail.com, Sumit Semwal <sumit.semwal@linaro.org>
Message-id: <1333634408-4960-4-git-send-email-t.stanislaws@samsung.com>
References: <1333634408-4960-1-git-send-email-t.stanislaws@samsung.com>
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
---
 drivers/media/video/videobuf2-core.c |  184 +++++++++++++++++++++++++++++++++-
 include/media/videobuf2-core.h       |   31 ++++++
 2 files changed, 214 insertions(+), 1 deletions(-)

diff --git a/drivers/media/video/videobuf2-core.c b/drivers/media/video/videobuf2-core.c
index 2e8f1df..b37feea 100644
--- a/drivers/media/video/videobuf2-core.c
+++ b/drivers/media/video/videobuf2-core.c
@@ -106,6 +106,27 @@ static void __vb2_buf_userptr_put(struct vb2_buffer *vb)
 }
 
 /**
+ * __vb2_buf_dmabuf_put() - release memory associated with
+ * a DMABUF shared buffer
+ */
+static void __vb2_buf_dmabuf_put(struct vb2_buffer *vb)
+{
+	struct vb2_queue *q = vb->vb2_queue;
+	unsigned int plane;
+
+	for (plane = 0; plane < vb->num_planes; ++plane) {
+		void *mem_priv = vb->planes[plane].mem_priv;
+
+		if (mem_priv) {
+			call_memop(q, detach_dmabuf, mem_priv);
+			dma_buf_put(vb->planes[plane].dbuf);
+			vb->planes[plane].dbuf = NULL;
+			vb->planes[plane].mem_priv = NULL;
+		}
+	}
+}
+
+/**
  * __setup_offsets() - setup unique offsets ("cookies") for every plane in
  * every buffer on the queue
  */
@@ -227,6 +248,8 @@ static void __vb2_free_mem(struct vb2_queue *q, unsigned int buffers)
 		/* Free MMAP buffers or release USERPTR buffers */
 		if (q->memory == V4L2_MEMORY_MMAP)
 			__vb2_buf_mem_free(vb);
+		if (q->memory == V4L2_MEMORY_DMABUF)
+			__vb2_buf_dmabuf_put(vb);
 		else
 			__vb2_buf_userptr_put(vb);
 	}
@@ -349,6 +372,12 @@ static int __fill_v4l2_buffer(struct vb2_buffer *vb, struct v4l2_buffer *b)
 		 */
 		memcpy(b->m.planes, vb->v4l2_planes,
 			b->length * sizeof(struct v4l2_plane));
+
+		if (q->memory == V4L2_MEMORY_DMABUF) {
+			unsigned int plane;
+			for (plane = 0; plane < vb->num_planes; ++plane)
+				b->m.planes[plane].m.fd = 0;
+		}
 	} else {
 		/*
 		 * We use length and offset in v4l2_planes array even for
@@ -360,6 +389,8 @@ static int __fill_v4l2_buffer(struct vb2_buffer *vb, struct v4l2_buffer *b)
 			b->m.offset = vb->v4l2_planes[0].m.mem_offset;
 		else if (q->memory == V4L2_MEMORY_USERPTR)
 			b->m.userptr = vb->v4l2_planes[0].m.userptr;
+		else if (q->memory == V4L2_MEMORY_DMABUF)
+			b->m.fd = 0;
 	}
 
 	/*
@@ -451,6 +482,21 @@ static int __verify_mmap_ops(struct vb2_queue *q)
 }
 
 /**
+ * __verify_dmabuf_ops() - verify that all memory operations required for
+ * DMABUF queue type have been provided
+ */
+static int __verify_dmabuf_ops(struct vb2_queue *q)
+{
+	if (!(q->io_modes & VB2_DMABUF) || !q->mem_ops->attach_dmabuf
+			|| !q->mem_ops->detach_dmabuf
+			|| !q->mem_ops->map_dmabuf
+			|| !q->mem_ops->unmap_dmabuf)
+		return -EINVAL;
+
+	return 0;
+}
+
+/**
  * vb2_reqbufs() - Initiate streaming
  * @q:		videobuf2 queue
  * @req:	struct passed from userspace to vidioc_reqbufs handler in driver
@@ -484,6 +530,7 @@ int vb2_reqbufs(struct vb2_queue *q, struct v4l2_requestbuffers *req)
 	}
 
 	if (req->memory != V4L2_MEMORY_MMAP
+			&& req->memory != V4L2_MEMORY_DMABUF
 			&& req->memory != V4L2_MEMORY_USERPTR) {
 		dprintk(1, "reqbufs: unsupported memory type\n");
 		return -EINVAL;
@@ -513,6 +560,11 @@ int vb2_reqbufs(struct vb2_queue *q, struct v4l2_requestbuffers *req)
 		return -EINVAL;
 	}
 
+	if (req->memory == V4L2_MEMORY_DMABUF && __verify_dmabuf_ops(q)) {
+		dprintk(1, "reqbufs: DMABUF for current setup unsupported\n");
+		return -EINVAL;
+	}
+
 	if (req->count == 0 || q->num_buffers != 0 || q->memory != req->memory) {
 		/*
 		 * We already have buffers allocated, so first check if they
@@ -620,7 +672,8 @@ int vb2_create_bufs(struct vb2_queue *q, struct v4l2_create_buffers *create)
 	}
 
 	if (create->memory != V4L2_MEMORY_MMAP
-			&& create->memory != V4L2_MEMORY_USERPTR) {
+			&& create->memory != V4L2_MEMORY_USERPTR
+			&& create->memory != V4L2_MEMORY_DMABUF) {
 		dprintk(1, "%s(): unsupported memory type\n", __func__);
 		return -EINVAL;
 	}
@@ -644,6 +697,11 @@ int vb2_create_bufs(struct vb2_queue *q, struct v4l2_create_buffers *create)
 		return -EINVAL;
 	}
 
+	if (create->memory == V4L2_MEMORY_DMABUF && __verify_dmabuf_ops(q)) {
+		dprintk(1, "%s(): DMABUF for current setup unsupported\n", __func__);
+		return -EINVAL;
+	}
+
 	if (q->num_buffers == VIDEO_MAX_FRAME) {
 		dprintk(1, "%s(): maximum number of buffers already allocated\n",
 			__func__);
@@ -839,6 +897,14 @@ static int __fill_vb2_buffer(struct vb2_buffer *vb, const struct v4l2_buffer *b,
 					b->m.planes[plane].length;
 			}
 		}
+		if (b->memory == V4L2_MEMORY_DMABUF) {
+			for (plane = 0; plane < vb->num_planes; ++plane) {
+				v4l2_planes[plane].bytesused =
+					b->m.planes[plane].bytesused;
+				v4l2_planes[plane].m.fd =
+					b->m.planes[plane].m.fd;
+			}
+		}
 	} else {
 		/*
 		 * Single-planar buffers do not use planes array,
@@ -853,6 +919,10 @@ static int __fill_vb2_buffer(struct vb2_buffer *vb, const struct v4l2_buffer *b,
 			v4l2_planes[0].m.userptr = b->m.userptr;
 			v4l2_planes[0].length = b->length;
 		}
+
+		if (b->memory == V4L2_MEMORY_DMABUF)
+			v4l2_planes[0].m.fd = b->m.fd;
+
 	}
 
 	vb->v4l2_buf.field = b->field;
@@ -957,6 +1027,105 @@ static int __qbuf_mmap(struct vb2_buffer *vb, const struct v4l2_buffer *b)
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
+			dprintk(1, "qbuf: invalid dmabuf fd for "
+				"plane %d\n", plane);
+			ret = -EINVAL;
+			goto err;
+		}
+
+		/* Skip the plane if already verified */
+		if (dbuf == vb->planes[plane].dbuf) {
+			planes[plane].length = dbuf->size;
+			dma_buf_put(dbuf);
+			continue;
+		}
+
+		dprintk(3, "qbuf: buffer description for plane %d changed, "
+			"reattaching dma buf\n", plane);
+
+		/* Release previously acquired memory if present */
+		if (vb->planes[plane].mem_priv) {
+			call_memop(q, detach_dmabuf,
+				vb->planes[plane].mem_priv);
+			dma_buf_put(vb->planes[plane].dbuf);
+		}
+
+		vb->planes[plane].mem_priv = NULL;
+
+		/* Acquire each plane's memory */
+		mem_priv = call_memop(q, attach_dmabuf, q->alloc_ctx[plane],
+			dbuf, q->plane_sizes[plane], write);
+		if (IS_ERR(mem_priv)) {
+			dprintk(1, "qbuf: failed acquiring dmabuf "
+				"memory for plane %d\n", plane);
+			ret = PTR_ERR(mem_priv);
+			goto err;
+		}
+
+		planes[plane].length = dbuf->size;
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
+			dprintk(1, "qbuf: failed mapping dmabuf "
+				"memory for plane %d\n", plane);
+			goto err;
+		}
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
@@ -980,6 +1149,9 @@ static int __buf_prepare(struct vb2_buffer *vb, const struct v4l2_buffer *b)
 	case V4L2_MEMORY_USERPTR:
 		ret = __qbuf_userptr(vb, b);
 		break;
+	case V4L2_MEMORY_DMABUF:
+		ret = __qbuf_dmabuf(vb, b);
+		break;
 	default:
 		WARN(1, "Invalid queue type\n");
 		ret = -EINVAL;
@@ -1312,6 +1484,7 @@ int vb2_dqbuf(struct vb2_queue *q, struct v4l2_buffer *b, bool nonblocking)
 {
 	struct vb2_buffer *vb = NULL;
 	int ret;
+	unsigned int plane;
 
 	if (q->fileio) {
 		dprintk(1, "dqbuf: file io in progress\n");
@@ -1335,6 +1508,15 @@ int vb2_dqbuf(struct vb2_queue *q, struct v4l2_buffer *b, bool nonblocking)
 		return ret;
 	}
 
+	/* TODO: this unpins the buffer(dma_buf_unmap_attachment()).. but
+	 * really we want tot do this just after DMA, not when the
+	 * buffer is dequeued..
+	 */
+	if (q->memory == V4L2_MEMORY_DMABUF)
+		for (plane = 0; plane < vb->num_planes; ++plane)
+			call_memop(q, unmap_dmabuf,
+				vb->planes[plane].mem_priv);
+
 	switch (vb->state) {
 	case VB2_BUF_STATE_DONE:
 		dprintk(3, "dqbuf: Returning done buffer\n");
diff --git a/include/media/videobuf2-core.h b/include/media/videobuf2-core.h
index a15d1f1..665e846 100644
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
@@ -65,6 +82,17 @@ struct vb2_mem_ops {
 					unsigned long size, int write);
 	void		(*put_userptr)(void *buf_priv);
 
+	/*
+	 * Comment from Rob Clark: XXX: I think the attach / detach could be
+	 * handled in the vb2 core, and vb2_mem_ops really just need to get/put
+	 * the sglist (and make sure that the sglist fits it's needs..)
+	 */
+	void		*(*attach_dmabuf)(void *alloc_ctx, struct dma_buf *dbuf,
+				unsigned long size, int write);
+	void		(*detach_dmabuf)(void *buf_priv);
+	int		(*map_dmabuf)(void *buf_priv);
+	void		(*unmap_dmabuf)(void *buf_priv);
+
 	void		*(*vaddr)(void *buf_priv);
 	void		*(*cookie)(void *buf_priv);
 
@@ -75,6 +103,7 @@ struct vb2_mem_ops {
 
 struct vb2_plane {
 	void			*mem_priv;
+	struct dma_buf		*dbuf;
 };
 
 /**
@@ -83,12 +112,14 @@ struct vb2_plane {
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
1.7.5.4

