Return-path: <mchehab@gaivota>
Received: from mailout4.w1.samsung.com ([210.118.77.14]:14089 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756178Ab0LPOYX (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 16 Dec 2010 09:24:23 -0500
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN
Received: from eu_spt1 ([210.118.77.14]) by mailout4.w1.samsung.com
 (Sun Java(tm) System Messaging Server 6.3-8.04 (built Jul 29 2009; 32bit))
 with ESMTP id <0LDI00L0OYOF1A00@mailout4.w1.samsung.com> for
 linux-media@vger.kernel.org; Thu, 16 Dec 2010 14:24:16 +0000 (GMT)
Received: from linux.samsung.com ([106.116.38.10])
 by spt1.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0LDI00LFYYOETQ@spt1.w1.samsung.com> for
 linux-media@vger.kernel.org; Thu, 16 Dec 2010 14:24:15 +0000 (GMT)
Date: Thu, 16 Dec 2010 15:23:58 +0100
From: Marek Szyprowski <m.szyprowski@samsung.com>
Subject: [PATCH 1/8] v4l: add videobuf2 Video for Linux 2 driver framework
In-reply-to: <1292509445-15100-1-git-send-email-m.szyprowski@samsung.com>
To: linux-media@vger.kernel.org
Cc: m.szyprowski@samsung.com, pawel@osciak.com,
	kyungmin.park@samsung.com, andrzej.p@samsung.com
Message-id: <1292509445-15100-2-git-send-email-m.szyprowski@samsung.com>
References: <1292509445-15100-1-git-send-email-m.szyprowski@samsung.com>
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

From: Pawel Osciak <p.osciak@samsung.com>

Videobuf2 is a Video for Linux 2 API-compatible driver framework for
multimedia devices. It acts as an intermediate layer between userspace
applications and device drivers. It also provides low-level, modular
memory management functions for drivers.

Videobuf2 eases driver development, reduces drivers' code size and aids in
proper and consistent implementation of V4L2 API in drivers.

Videobuf2 memory management backend is fully modular. This allows custom
memory management routines for devices and platforms with non-standard
memory management requirements to be plugged in, without changing the
high-level buffer management functions and API.

The framework provides:
- implementations of streaming I/O V4L2 ioctls and file operations
- high-level video buffer, video queue and state management functions
- video buffer memory allocation and management

Signed-off-by: Pawel Osciak <p.osciak@samsung.com>
Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
CC: Pawel Osciak <pawel@osciak.com>
---
 drivers/media/video/Kconfig          |    3 +
 drivers/media/video/Makefile         |    2 +
 drivers/media/video/videobuf2-core.c | 1407 ++++++++++++++++++++++++++++++++++
 include/media/videobuf2-core.h       |  368 +++++++++
 4 files changed, 1780 insertions(+), 0 deletions(-)
 create mode 100644 drivers/media/video/videobuf2-core.c
 create mode 100644 include/media/videobuf2-core.h

diff --git a/drivers/media/video/Kconfig b/drivers/media/video/Kconfig
index 6830d28..4a81a00 100644
--- a/drivers/media/video/Kconfig
+++ b/drivers/media/video/Kconfig
@@ -49,6 +49,9 @@ config V4L2_MEM2MEM_DEV
 	tristate
 	depends on VIDEOBUF_GEN
 
+config VIDEOBUF2_CORE
+	tristate
+
 #
 # Multimedia Video device configuration
 #
diff --git a/drivers/media/video/Makefile b/drivers/media/video/Makefile
index af79d47..77c4f85 100644
--- a/drivers/media/video/Makefile
+++ b/drivers/media/video/Makefile
@@ -114,6 +114,8 @@ obj-$(CONFIG_VIDEOBUF_VMALLOC) += videobuf-vmalloc.o
 obj-$(CONFIG_VIDEOBUF_DVB) += videobuf-dvb.o
 obj-$(CONFIG_VIDEO_BTCX)  += btcx-risc.o
 
+obj-$(CONFIG_VIDEOBUF2_CORE)		+= videobuf2-core.o
+
 obj-$(CONFIG_V4L2_MEM2MEM_DEV) += v4l2-mem2mem.o
 
 obj-$(CONFIG_VIDEO_M32R_AR_M64278) += arv.o
diff --git a/drivers/media/video/videobuf2-core.c b/drivers/media/video/videobuf2-core.c
new file mode 100644
index 0000000..ae1c817
--- /dev/null
+++ b/drivers/media/video/videobuf2-core.c
@@ -0,0 +1,1407 @@
+/*
+ * videobuf2-core.c - V4L2 driver helper framework
+ *
+ * Copyright (C) 2010 Samsung Electronics
+ *
+ * Author: Pawel Osciak <p.osciak@samsung.com>
+ *	   Marek Szyprowski <m.szyprowski@samsung.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation.
+ */
+
+#include <linux/err.h>
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/mm.h>
+#include <linux/poll.h>
+#include <linux/slab.h>
+#include <linux/sched.h>
+
+#include <media/videobuf2-core.h>
+
+static int debug;
+module_param(debug, int, 0644);
+
+#define dprintk(level, fmt, arg...)					\
+	do {								\
+		if (debug >= level)					\
+			printk(KERN_DEBUG "vb2: " fmt, ## arg);		\
+	} while (0)
+
+#define call_memop(q, plane, op, args...)				\
+	(((q)->mem_ops->op) ?						\
+		((q)->mem_ops->op(args)) : 0)
+
+#define call_qop(q, op, args...)					\
+	(((q)->ops->op) ? ((q)->ops->op(args)) : 0)
+
+/**
+ * __vb2_buf_mem_alloc() - allocate video memory for the given buffer
+ */
+static int __vb2_buf_mem_alloc(struct vb2_buffer *vb,
+				unsigned long *plane_sizes)
+{
+	struct vb2_queue *q = vb->vb2_queue;
+	void *mem_priv;
+	int plane;
+
+	/* Allocate memory for all planes in this buffer */
+	for (plane = 0; plane < vb->num_planes; ++plane) {
+		mem_priv = call_memop(q, plane, alloc, q->alloc_ctx[plane],
+					plane_sizes[plane]);
+		if (!mem_priv)
+			goto free;
+
+		/* Associate allocator private data with this plane */
+		vb->planes[plane].mem_priv = mem_priv;
+		vb->v4l2_planes[plane].length = plane_sizes[plane];
+	}
+
+	return 0;
+free:
+	/* Free already allocated memory if one of the allocations failed */
+	for (; plane > 0; --plane)
+		call_memop(q, plane, put, vb->planes[plane - 1].mem_priv);
+
+	return -ENOMEM;
+}
+
+/**
+ * __vb2_buf_mem_free() - free memory of the given buffer
+ */
+static void __vb2_buf_mem_free(struct vb2_buffer *vb)
+{
+	struct vb2_queue *q = vb->vb2_queue;
+	unsigned int plane;
+
+	for (plane = 0; plane < vb->num_planes; ++plane) {
+		call_memop(q, plane, put, vb->planes[plane].mem_priv);
+		vb->planes[plane].mem_priv = NULL;
+		dprintk(3, "Freed plane %d of buffer %d\n",
+				plane, vb->v4l2_buf.index);
+	}
+}
+
+/**
+ * __vb2_buf_userptr_put() - release userspace memory associated associated
+ * with a USERPTR buffer
+ */
+static void __vb2_buf_userptr_put(struct vb2_buffer *vb)
+{
+	struct vb2_queue *q = vb->vb2_queue;
+	unsigned int plane;
+
+	for (plane = 0; plane < vb->num_planes; ++plane) {
+		void *mem_priv = vb->planes[plane].mem_priv;
+
+		if (mem_priv) {
+			call_memop(q, plane, put_userptr, mem_priv);
+			vb->planes[plane].mem_priv = NULL;
+		}
+	}
+}
+
+/**
+ * __setup_offsets() - setup unique offsets ("cookies") for every plane in
+ * every buffer on the queue
+ */
+static void __setup_offsets(struct vb2_queue *q)
+{
+	unsigned int buffer, plane;
+	struct vb2_buffer *vb;
+	unsigned long off = 0;
+
+	for (buffer = 0; buffer < q->num_buffers; ++buffer) {
+		vb = q->bufs[buffer];
+		if (!vb)
+			continue;
+
+		for (plane = 0; plane < vb->num_planes; ++plane) {
+			vb->v4l2_planes[plane].m.mem_offset = off;
+
+			dprintk(3, "Buffer %d, plane %d offset 0x%08lx\n",
+					buffer, plane, off);
+
+			off += vb->v4l2_planes[plane].length;
+			off = PAGE_ALIGN(off);
+		}
+	}
+}
+
+/**
+ * __vb2_queue_alloc() - allocate videobuf buffer structures and (for MMAP type)
+ * video buffer memory for all buffers/planes on the queue and initializes the
+ * queue
+ *
+ * Returns the number of buffers successfully allocated.
+ */
+static int __vb2_queue_alloc(struct vb2_queue *q, enum v4l2_memory memory,
+			     unsigned int num_buffers, unsigned int num_planes,
+			     unsigned long plane_sizes[])
+{
+	unsigned int buffer;
+	struct vb2_buffer *vb;
+	int ret;
+
+	for (buffer = 0; buffer < num_buffers; ++buffer) {
+		/* Allocate videobuf buffer structures */
+		vb = kzalloc(q->buf_struct_size, GFP_KERNEL);
+		if (!vb) {
+			dprintk(1, "Memory alloc for buffer struct failed\n");
+			break;
+		}
+
+		/* Length stores number of planes for multiplanar buffers */
+		if (V4L2_TYPE_IS_MULTIPLANAR(q->type))
+			vb->v4l2_buf.length = num_planes;
+
+		vb->state = VB2_BUF_STATE_DEQUEUED;
+		vb->vb2_queue = q;
+		vb->num_planes = num_planes;
+		vb->v4l2_buf.index = buffer;
+		vb->v4l2_buf.type = q->type;
+		vb->v4l2_buf.memory = memory;
+
+		/* Allocate video buffer memory for the MMAP type */
+		if (memory == V4L2_MEMORY_MMAP) {
+			ret = __vb2_buf_mem_alloc(vb, plane_sizes);
+			if (ret) {
+				dprintk(1, "Failed allocating memory for "
+						"buffer %d\n", buffer);
+				kfree(vb);
+				break;
+			}
+			/*
+			 * Call the driver-provided buffer initialization
+			 * callback, if given. An error in initialization
+			 * results in queue setup failure.
+			 */
+			ret = call_qop(q, buf_init, vb);
+			if (ret) {
+				dprintk(1, "Buffer %d %p initialization"
+					" failed\n", buffer, vb);
+				__vb2_buf_mem_free(vb);
+				kfree(vb);
+				break;
+			}
+		}
+
+		q->bufs[buffer] = vb;
+	}
+
+	q->num_buffers = buffer;
+
+	__setup_offsets(q);
+
+	dprintk(1, "Allocated %d buffers, %d plane(s) each\n",
+			q->num_buffers, num_planes);
+
+	return buffer;
+}
+
+/**
+ * __vb2_free_mem() - release all video buffer memory for a given queue
+ */
+static void __vb2_free_mem(struct vb2_queue *q)
+{
+	unsigned int buffer;
+	struct vb2_buffer *vb;
+
+	for (buffer = 0; buffer < q->num_buffers; ++buffer) {
+		vb = q->bufs[buffer];
+		if (!vb)
+			continue;
+
+		/* Free MMAP buffers or release USERPTR buffers */
+		if (q->memory == V4L2_MEMORY_MMAP)
+			__vb2_buf_mem_free(vb);
+		else
+			__vb2_buf_userptr_put(vb);
+	}
+}
+
+/**
+ * __vb2_queue_free() - free the queue - video memory and related information
+ * and return the queue to an uninitialized state. Might be called even if the
+ * queue has been already freed.
+ */
+static int __vb2_queue_free(struct vb2_queue *q)
+{
+	unsigned int buffer;
+
+	/* Call driver-provided cleanup function for each buffer, if provided */
+	if (q->ops->buf_cleanup) {
+		for (buffer = 0; buffer < q->num_buffers; ++buffer) {
+			if (NULL == q->bufs[buffer])
+				continue;
+			q->ops->buf_cleanup(q->bufs[buffer]);
+		}
+	}
+
+	/* Release video buffer memory */
+	__vb2_free_mem(q);
+
+	/* Free videobuf buffers */
+	for (buffer = 0; buffer < q->num_buffers; ++buffer) {
+		kfree(q->bufs[buffer]);
+		q->bufs[buffer] = NULL;
+	}
+
+	q->num_buffers = 0;
+	q->memory = 0;
+
+	return 0;
+}
+
+/**
+ * __verify_planes_array() - verify that the planes array passed in struct
+ * v4l2_buffer from userspace can be safely used
+ */
+static int __verify_planes_array(struct vb2_buffer *vb, struct v4l2_buffer *b)
+{
+	/* Is memory for copying plane information present? */
+	if (NULL == b->m.planes) {
+		dprintk(1, "Multi-planar buffer passed but "
+			   "planes array not provided\n");
+		return -EINVAL;
+	}
+
+	if (b->length < vb->num_planes || b->length > VIDEO_MAX_PLANES) {
+		dprintk(1, "Incorrect planes array length, "
+			   "expected %d, got %d\n", vb->num_planes, b->length);
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+/**
+ * __fill_v4l2_buffer() - fill in a struct v4l2_buffer with information to be
+ * returned to userspace
+ */
+static int __fill_v4l2_buffer(struct vb2_buffer *vb, struct v4l2_buffer *b)
+{
+	struct vb2_queue *q = vb->vb2_queue;
+	int ret = 0;
+
+	/* Copy back data such as timestamp, input, etc. */
+	memcpy(b, &vb->v4l2_buf, offsetof(struct v4l2_buffer, m));
+	b->input = vb->v4l2_buf.input;
+	b->reserved = vb->v4l2_buf.reserved;
+
+	if (V4L2_TYPE_IS_MULTIPLANAR(q->type)) {
+		ret = __verify_planes_array(vb, b);
+		if (ret)
+			return ret;
+
+		/*
+		 * Fill in plane-related data if userspace provided an array
+		 * for it. The memory and size is verified above.
+		 */
+		memcpy(b->m.planes, vb->v4l2_planes,
+			b->length * sizeof(struct v4l2_plane));
+	} else {
+		/*
+		 * We use length and offset in v4l2_planes array even for
+		 * single-planar buffers, but userspace does not.
+		 */
+		b->length = vb->v4l2_planes[0].length;
+		b->bytesused = vb->v4l2_planes[0].bytesused;
+		if (q->memory == V4L2_MEMORY_MMAP)
+			b->m.offset = vb->v4l2_planes[0].m.mem_offset;
+		else if (q->memory == V4L2_MEMORY_USERPTR)
+			b->m.userptr = vb->v4l2_planes[0].m.userptr;
+	}
+
+	b->flags = 0;
+
+	switch (vb->state) {
+	case VB2_BUF_STATE_QUEUED:
+	case VB2_BUF_STATE_ACTIVE:
+		b->flags |= V4L2_BUF_FLAG_QUEUED;
+		break;
+	case VB2_BUF_STATE_ERROR:
+		b->flags |= V4L2_BUF_FLAG_ERROR;
+		/* fall through */
+	case VB2_BUF_STATE_DONE:
+		b->flags |= V4L2_BUF_FLAG_DONE;
+		break;
+	case VB2_BUF_STATE_DEQUEUED:
+		/* nothing */
+		break;
+	}
+
+	if (vb->num_planes_mapped == vb->num_planes)
+		b->flags |= V4L2_BUF_FLAG_MAPPED;
+
+	return ret;
+}
+
+/**
+ * vb2_querybuf() - query video buffer information
+ * @q:		videobuf queue
+ * @b:		buffer struct passed from userspace to vidioc_querybuf handler
+ *		in driver
+ *
+ * Should be called from vidioc_querybuf ioctl handler in driver.
+ * This function will verify the passed v4l2_buffer structure and fill the
+ * relevant information for the userspace.
+ *
+ * The return values from this function are intended to be directly returned
+ * from vidioc_querybuf handler in driver.
+ */
+int vb2_querybuf(struct vb2_queue *q, struct v4l2_buffer *b)
+{
+	struct vb2_buffer *vb;
+
+	if (b->type != q->type) {
+		dprintk(1, "querybuf: wrong buffer type\n");
+		return -EINVAL;
+	}
+
+	if (b->index >= q->num_buffers) {
+		dprintk(1, "querybuf: buffer index out of range\n");
+		return -EINVAL;
+	}
+	vb = q->bufs[b->index];
+
+	return __fill_v4l2_buffer(vb, b);
+}
+EXPORT_SYMBOL(vb2_querybuf);
+
+/**
+ * __verify_userptr_ops() - verify that all memory operations required for
+ * USERPTR queue type have been provided
+ */
+static int __verify_userptr_ops(struct vb2_queue *q)
+{
+	if (!(q->io_modes & VB2_USERPTR) || !q->mem_ops->get_userptr ||
+	    !q->mem_ops->put_userptr)
+		return -EINVAL;
+
+	return 0;
+}
+
+/**
+ * __verify_mmap_ops() - verify that all memory operations required for
+ * MMAP queue type have been provided
+ */
+static int __verify_mmap_ops(struct vb2_queue *q)
+{
+	if (!(q->io_modes & VB2_MMAP) || !q->mem_ops->alloc ||
+	    !q->mem_ops->put || !q->mem_ops->mmap)
+		return -EINVAL;
+
+	return 0;
+}
+
+/**
+ * __buffers_in_use() - return true if any buffers on the queue are in use and
+ * the queue cannot be freed (by the means of REQBUFS(0)) call
+ */
+static bool __buffers_in_use(struct vb2_queue *q)
+{
+	unsigned int buffer, plane;
+	struct vb2_buffer *vb;
+
+	for (buffer = 0; buffer < q->num_buffers; ++buffer) {
+		vb = q->bufs[buffer];
+		for (plane = 0; plane < vb->num_planes; ++plane) {
+			/*
+			 * If num_users() has not been provided, call_memop will
+			 * return 0, apparently nobody cares of this case anyway.
+			 * If num_users() returns more than 1, we are not the
+			 * only user of the plane's memory.
+			 */
+			if (call_memop(q, plane, num_users,
+					vb->planes[plane].mem_priv) > 1)
+				return true;
+		}
+	}
+
+	return false;
+}
+
+/**
+ * vb2_reqbufs() - Initiate streaming
+ * @q:		videobuf2 queue
+ * @req:	struct passed from userspace to vidioc_reqbufs handler in driver
+ *
+ * Should be called from vidioc_reqbufs ioctl handler of a driver.
+ * This function:
+ * 1) verifies streaming parameters passed from the userspace,
+ * 2) sets up the queue,
+ * 3) negotiates number of buffers and planes per buffer with the driver
+ *    to be used during streaming,
+ * 4) allocates internal buffer structures (struct vb2_buffer), according to
+ *    the agreed parameters,
+ * 5) for MMAP memory type, allocates actual video memory, using the
+ *    memory handling/allocation routines provided during queue initialization
+ *
+ * If req->count is 0, all the memory will be freed instead.
+ * If the queue has been allocated previously (by a previous vb2_reqbufs) call
+ * and the queue is not busy, memory will be reallocated.
+ *
+ * The return values from this function are intended to be directly returned
+ * from vidioc_reqbufs handler in driver.
+ */
+int vb2_reqbufs(struct vb2_queue *q, struct v4l2_requestbuffers *req)
+{
+	unsigned int num_buffers, num_planes;
+	unsigned long plane_sizes[VIDEO_MAX_PLANES];
+	int ret = 0;
+
+	if (req->memory != V4L2_MEMORY_MMAP
+			&& req->memory != V4L2_MEMORY_USERPTR) {
+		dprintk(1, "reqbufs: unsupported memory type\n");
+		return -EINVAL;
+	}
+
+	if (req->type != q->type) {
+		dprintk(1, "reqbufs: requested type is incorrect\n");
+		return -EINVAL;
+	}
+
+	if (q->streaming) {
+		dprintk(1, "reqbufs: streaming active\n");
+		return -EBUSY;
+	}
+
+	/*
+	 * Make sure all the required memory ops for given memory type
+	 * are available.
+	 */
+	if (req->memory == V4L2_MEMORY_MMAP && __verify_mmap_ops(q)) {
+		dprintk(1, "reqbufs: MMAP for current setup unsupported\n");
+		return -EINVAL;
+	}
+
+	if (req->memory == V4L2_MEMORY_USERPTR && __verify_userptr_ops(q)) {
+		dprintk(1, "reqbufs: USERPTR for current setup unsupported\n");
+		return -EINVAL;
+	}
+
+	if (req->count == 0 || q->num_buffers != 0) {
+		/*
+		 * We already have buffers allocated, so first check if they
+		 * are not in use and can be freed.
+		 */
+		if (q->memory == V4L2_MEMORY_MMAP && __buffers_in_use(q)) {
+			dprintk(1, "reqbufs: memory in use, cannot free\n");
+			return -EBUSY;
+		}
+
+		ret = __vb2_queue_free(q);
+		if (ret != 0)
+			return ret;
+	}
+
+	/*
+	 * Make sure the requested values and current defaults are sane.
+	 */
+	num_buffers = min_t(unsigned int, req->count, VIDEO_MAX_FRAME);
+	memset(plane_sizes, 0, sizeof(plane_sizes));
+	memset(q->alloc_ctx, 0, sizeof(q->alloc_ctx));
+
+	/*
+	 * Ask the driver how many buffers and planes per buffer it requires.
+	 * Driver also sets the size and allocator context for each plane.
+	 */
+	ret = call_qop(q, queue_setup, q, &num_buffers, &num_planes,
+		       plane_sizes, q->alloc_ctx);
+	if (ret)
+		return ret;
+
+	/* Finally, allocate buffers and video memory */
+	ret = __vb2_queue_alloc(q, req->memory, num_buffers, num_planes,
+				plane_sizes);
+	if (ret < 0) {
+		dprintk(1, "Memory allocation failed with error: %d\n", ret);
+		return ret;
+	}
+
+	/*
+	 * Check if driver can handle the allocated number of buffers.
+	 */
+	if (ret < num_buffers) {
+		unsigned int num_buffers2;
+
+		num_buffers = num_buffers2 = ret;
+		ret = call_qop(q, queue_setup, q, &num_buffers, &num_planes,
+			       plane_sizes, q->alloc_ctx);
+		if (ret)
+			goto free_mem;
+
+		if (num_buffers2 < num_buffers) {
+			ret = -ENOMEM;
+			goto free_mem;
+		}
+
+		/*
+		 * Ok, driver accepted smaller number of buffers.
+		 */
+		ret = num_buffers;
+	}
+
+	q->memory = req->memory;
+
+	/*
+	 * Return the number of successfully allocated buffers
+	 * to the userspace.
+	 */
+	req->count = ret;
+
+	return 0;
+
+free_mem:
+	__vb2_queue_free(q);
+	return ret;
+}
+EXPORT_SYMBOL_GPL(vb2_reqbufs);
+
+/**
+ * vb2_plane_vaddr() - Return a kernel virtual address of a given plane
+ * @vb:		vb2_buffer to which the plane in question belongs to
+ * @plane_no:	plane number for which the address is to be returned
+ *
+ * This function returns a kernel virtual address of a given plane if
+ * such a mapping exist, NULL otherwise.
+ */
+void *vb2_plane_vaddr(struct vb2_buffer *vb, unsigned int plane_no)
+{
+	struct vb2_queue *q = vb->vb2_queue;
+
+	if (plane_no > vb->num_planes)
+		return NULL;
+
+	return call_memop(q, plane_no, vaddr, vb->planes[plane_no].mem_priv);
+
+}
+EXPORT_SYMBOL_GPL(vb2_plane_vaddr);
+
+/**
+ * vb2_plane_cookie() - Return allocator specific cookie for the given plane
+ * @vb:		vb2_buffer to which the plane in question belongs to
+ * @plane_no:	plane number for which the address is to be returned
+ *
+ * This function returns an allocator specific cookie for a given plane if
+ * available, NULL otherwise. The allocator should provide some simple static
+ * inline function which converts this cookie to the allocator specific type
+ * that can be used directly by the driver to access the buffer. This can be
+ * for example physical address, pointer to scatter list or iommu mapping.
+ */
+void *vb2_plane_cookie(struct vb2_buffer *vb, unsigned int plane_no)
+{
+	struct vb2_queue *q = vb->vb2_queue;
+
+	if (plane_no > vb->num_planes)
+		return NULL;
+
+	return call_memop(q, plane_no, cookie, vb->planes[plane_no].mem_priv);
+}
+EXPORT_SYMBOL_GPL(vb2_plane_cookie);
+
+/**
+ * vb2_buffer_done() - inform videobuf that an operation on a buffer is finished
+ * @vb:		vb2_buffer returned from the driver
+ * @state:	either VB2_BUF_STATE_DONE if the operation finished successfully
+ *		or VB2_BUF_STATE_ERROR if the operation finished with an error
+ *
+ * This function should be called by the driver after a hardware operation on
+ * a buffer is finished and the buffer may be returned to userspace. The driver
+ * cannot use this buffer anymore until it is queued back to it by videobuf
+ * by the means of buf_queue callback. Only buffers previously queued to the
+ * driver by buf_queue can be passed to this function.
+ */
+void vb2_buffer_done(struct vb2_buffer *vb, enum vb2_buffer_state state)
+{
+	struct vb2_queue *q = vb->vb2_queue;
+	unsigned long flags;
+
+	if (vb->state != VB2_BUF_STATE_ACTIVE)
+		return;
+
+	if (state != VB2_BUF_STATE_DONE && state != VB2_BUF_STATE_ERROR)
+		return;
+
+	dprintk(4, "Done processing on buffer %d, state: %d\n",
+			vb->v4l2_buf.index, vb->state);
+
+	/* Add the buffer to the done buffers list */
+	spin_lock_irqsave(&q->done_lock, flags);
+	vb->state = state;
+	list_add_tail(&vb->done_entry, &q->done_list);
+	atomic_dec(&q->queued_count);
+	spin_unlock_irqrestore(&q->done_lock, flags);
+
+	/* Inform any processes that may be waiting for buffers */
+	wake_up(&q->done_wq);
+}
+EXPORT_SYMBOL_GPL(vb2_buffer_done);
+
+/**
+ * __fill_vb2_buffer() - fill a vb2_buffer with information provided in
+ * a v4l2_buffer by the userspace
+ */
+static int __fill_vb2_buffer(struct vb2_buffer *vb, struct v4l2_buffer *b,
+				struct v4l2_plane *v4l2_planes)
+{
+	unsigned int plane;
+	int ret;
+
+	if (V4L2_TYPE_IS_MULTIPLANAR(b->type)) {
+		/*
+		 * Verify that the userspace gave us a valid array for
+		 * plane information.
+		 */
+		ret = __verify_planes_array(vb, b);
+		if (ret)
+			return ret;
+
+		/* Fill in driver-provided information for OUTPUT types */
+		if (V4L2_TYPE_IS_OUTPUT(b->type)) {
+			/*
+			 * Will have to go up to b->length when API starts
+			 * accepting variable number of planes.
+			 */
+			for (plane = 0; plane < vb->num_planes; ++plane) {
+				v4l2_planes[plane].bytesused =
+					b->m.planes[plane].bytesused;
+				v4l2_planes[plane].data_offset =
+					b->m.planes[plane].data_offset;
+			}
+		}
+
+		if (b->memory == V4L2_MEMORY_USERPTR) {
+			for (plane = 0; plane < vb->num_planes; ++plane) {
+				v4l2_planes[plane].m.userptr =
+					b->m.planes[plane].m.userptr;
+				v4l2_planes[plane].length =
+					b->m.planes[plane].length;
+			}
+		}
+	} else {
+		/*
+		 * Single-planar buffers do not use planes array,
+		 * so fill in relevant v4l2_buffer struct fields instead.
+		 * In videobuf we use our internal V4l2_planes struct for
+		 * single-planar buffers as well, for simplicity.
+		 */
+		if (V4L2_TYPE_IS_OUTPUT(b->type))
+			v4l2_planes[0].bytesused = b->bytesused;
+
+		if (b->memory == V4L2_MEMORY_USERPTR) {
+			v4l2_planes[0].m.userptr = b->m.userptr;
+			v4l2_planes[0].length = b->length;
+		}
+	}
+
+	vb->v4l2_buf.field = b->field;
+	vb->v4l2_buf.timestamp = b->timestamp;
+
+	return 0;
+}
+
+/**
+ * __qbuf_userptr() - handle qbuf of a USERPTR buffer
+ */
+static int __qbuf_userptr(struct vb2_buffer *vb, struct v4l2_buffer *b)
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
+		/* Skip the plane if already verified */
+		if (vb->v4l2_planes[plane].m.userptr == planes[plane].m.userptr
+		    && vb->v4l2_planes[plane].length == planes[plane].length)
+			continue;
+
+		dprintk(3, "qbuf: userspace address for plane %d changed, "
+				"reacquiring memory\n", plane);
+
+		/* Release previously acquired memory if present */
+		if (vb->planes[plane].mem_priv)
+			call_memop(q, plane, put_userptr,
+					vb->planes[plane].mem_priv);
+
+		vb->planes[plane].mem_priv = NULL;
+
+		/* Acquire each plane's memory */
+		if (q->mem_ops->get_userptr) {
+			mem_priv = q->mem_ops->get_userptr(q->alloc_ctx[plane],
+							planes[plane].m.userptr,
+							planes[plane].length,
+							write);
+			if (IS_ERR(mem_priv)) {
+				dprintk(1, "qbuf: failed acquiring userspace "
+						"memory for plane %d\n", plane);
+				ret = PTR_ERR(mem_priv);
+				goto err;
+			}
+			vb->planes[plane].mem_priv = mem_priv;
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
+	for (; plane > 0; --plane) {
+		call_memop(q, plane, put_userptr,
+				vb->planes[plane - 1].mem_priv);
+		vb->planes[plane - 1].mem_priv = NULL;
+	}
+
+	return ret;
+}
+
+/**
+ * __qbuf_mmap() - handle qbuf of an MMAP buffer
+ */
+static int __qbuf_mmap(struct vb2_buffer *vb, struct v4l2_buffer *b)
+{
+	return __fill_vb2_buffer(vb, b, vb->v4l2_planes);
+}
+
+/**
+ * __enqueue_in_driver() - enqueue a vb2_buffer in driver for processing
+ */
+static void __enqueue_in_driver(struct vb2_buffer *vb)
+{
+	struct vb2_queue *q = vb->vb2_queue;
+
+	vb->state = VB2_BUF_STATE_ACTIVE;
+	atomic_inc(&q->queued_count);
+	q->ops->buf_queue(vb);
+}
+
+/**
+ * vb2_qbuf() - Queue a buffer from userspace
+ * @q:		videobuf2 queue
+ * @b:		buffer structure passed from userspace to vidioc_qbuf handler
+ *		in driver
+ *
+ * Should be called from vidioc_qbuf ioctl handler of a driver.
+ * This function:
+ * 1) verifies the passed buffer,
+ * 2) calls buf_prepare callback in the driver (if provided), in which
+ *    driver-specific buffer initialization can be performed,
+ * 3) if streaming is on, queues the buffer in driver by the means of buf_queue
+ *    callback for processing.
+ *
+ * The return values from this function are intended to be directly returned
+ * from vidioc_qbuf handler in driver.
+ */
+int vb2_qbuf(struct vb2_queue *q, struct v4l2_buffer *b)
+{
+	struct vb2_buffer *vb;
+	int ret = 0;
+
+	if (b->type != q->type) {
+		dprintk(1, "qbuf: invalid buffer type\n");
+		return -EINVAL;
+	}
+
+	if (b->index >= q->num_buffers) {
+		dprintk(1, "qbuf: buffer index out of range\n");
+		return -EINVAL;
+	}
+
+	vb = q->bufs[b->index];
+	if (NULL == vb) {
+		/* Should never happen */
+		dprintk(1, "qbuf: buffer is NULL\n");
+		return -EINVAL;
+	}
+
+	if (b->memory != q->memory) {
+		dprintk(1, "qbuf: invalid memory type\n");
+		return -EINVAL;
+	}
+
+	if (vb->state != VB2_BUF_STATE_DEQUEUED) {
+		dprintk(1, "qbuf: buffer already in use\n");
+		return -EINVAL;
+	}
+
+	if (q->memory == V4L2_MEMORY_MMAP)
+		ret = __qbuf_mmap(vb, b);
+	else if (q->memory == V4L2_MEMORY_USERPTR)
+		ret = __qbuf_userptr(vb, b);
+	else {
+		WARN(1, "Invalid queue type\n");
+		return -EINVAL;
+	}	
+
+	if (ret)
+		return ret;
+
+	ret = call_qop(q, buf_prepare, vb);
+	if (ret) {
+		dprintk(1, "qbuf: buffer preparation failed\n");
+		return ret;
+	}
+
+	/*
+	 * Add to the queued buffers list, a buffer will stay on it until
+	 * dequeued in dqbuf.
+	 */
+	list_add_tail(&vb->queued_entry, &q->queued_list);
+	vb->state = VB2_BUF_STATE_QUEUED;
+
+	/*
+	 * If already streaming, give the buffer to driver for processing.
+	 * If not, the buffer will be given to driver on next streamon.
+	 */
+	if (q->streaming)
+		__enqueue_in_driver(vb);
+
+	dprintk(1, "qbuf of buffer %d succeeded\n", vb->v4l2_buf.index);
+	return 0;
+}
+EXPORT_SYMBOL_GPL(vb2_qbuf);
+
+/**
+ * __vb2_wait_for_done_vb() - wait for a buffer to become available
+ * for dequeuing
+ *
+ * Will sleep if required for nonblocking == false.
+ */
+static int __vb2_wait_for_done_vb(struct vb2_queue *q, int nonblocking)
+{
+	/*
+	 * All operation on vb_done_list is performed under vb_done_lock
+	 * spinlock protection. However buffers may must be removed from
+	 * it and returned to userspace only while holding both driver's
+	 * lock and the vb_done_lock spinlock. Thus we can be sure that as
+	 * long as we hold lock, the list will remain not empty if this
+	 * check succeeds.
+	 */
+
+	for (;;) {
+		int ret;
+
+		if (!q->streaming) {
+			dprintk(1, "Streaming off, will not wait for buffers\n");
+			return -EINVAL;
+		}
+
+		if (!list_empty(&q->done_list)) {
+			/*
+			 * Found a buffer that we were waiting for.
+			 */
+			break;
+		}
+
+		if (nonblocking) {
+			dprintk(1, "Nonblocking and no buffers to dequeue, "
+								"will not wait\n");
+			return -EAGAIN;
+		}
+
+		/*
+		 * We are streaming and blocking, wait for another buffer to
+		 * become ready or for streamoff. Driver's lock is released to
+		 * allow streamoff or qbuf to be called while waiting.
+		 */
+		call_qop(q, wait_prepare, q);
+
+		/*
+		 * All locks has been released, it is safe to sleep now.
+		 */
+		dprintk(3, "Will sleep waiting for buffers\n");
+		ret = wait_event_interruptible(q->done_wq,
+				!list_empty(&q->done_list) || !q->streaming);
+
+		/*
+		 * We need to reevaluate both conditions again after reacquiring
+		 * the locks or return an error if it occured. In case of error
+		 * we return -EINTR, because -ERESTARTSYS should not be returned
+		 * to userspace.
+		 */
+		call_qop(q, wait_finish, q);
+		if (ret)
+			return -ERESTARTSYS;
+	}
+	return 0;
+}
+
+/**
+ * __vb2_get_done_vb() - get a buffer ready for dequeuing
+ *
+ * Will sleep if required for nonblocking == false.
+ */
+static int __vb2_get_done_vb(struct vb2_queue *q, struct vb2_buffer **vb,
+				int nonblocking)
+{
+	unsigned long flags;
+	int ret;
+
+	/*
+	 * Wait for at least one buffer to become available on the done_list.
+	 */
+	ret = __vb2_wait_for_done_vb(q, nonblocking);
+	if (ret)
+		return ret;
+
+	/*
+	 * Drivers lock has been held since we last verified that done_list is
+	 * not empty, so no need for another list_empty(done_list) check.
+	 */
+	spin_lock_irqsave(&q->done_lock, flags);
+	*vb = list_first_entry(&q->done_list, struct vb2_buffer, done_entry);
+	list_del(&(*vb)->done_entry);
+	spin_unlock_irqrestore(&q->done_lock, flags);
+
+	return 0;
+}
+
+/**
+ * vb2_wait_for_all_buffers() - wait until all buffers will be given back to vb2
+ * @q:		videobuf2 queue
+ *
+ * This function will wait until all buffers that have been given to the driver
+ * by buf_queue() are given back to vb2 with vb2_buffer_done(). It doesn't call
+ * wait_prepare, wait_finish pair. It is intended to call it with all locks
+ * taken, from stop_steaming() callback.
+ */
+int vb2_wait_for_all_buffers(struct vb2_queue *q)
+{
+	if (!q->streaming) {
+		dprintk(1, "Streaming off, will not wait for buffers\n");
+		return -EINVAL;
+	}
+
+	wait_event(q->done_wq, !atomic_read(&q->queued_count));
+	return 0;
+}
+EXPORT_SYMBOL_GPL(vb2_wait_for_all_buffers);
+
+/**
+ * vb2_dqbuf() - Dequeue a buffer to the userspace
+ * @q:		videobuf2 queue
+ * @b:		buffer structure passed from userspace to vidioc_dqbuf handler
+ *		in driver
+ * @nonblocking: if true, this call will not sleep waiting for a buffer if no
+ *		 buffers ready for dequeuing are present. Normally the driver
+ *		 would be passing (file->f_flags & O_NONBLOCK) here
+ *
+ * Should be called from vidioc_dqbuf ioctl handler of a driver.
+ * This function:
+ * 1) verifies the passed buffer,
+ * 2) calls buf_finish callback in the driver (if provided), in which
+ *    driver can perform any additional operations that may be required before
+ *    returning the buffer to userspace, such as cache sync,
+ * 3) the buffer struct members are filled with relevant information for
+ *    the userspace.
+ *
+ * The return values from this function are intended to be directly returned
+ * from vidioc_dqbuf handler in driver.
+ */
+int vb2_dqbuf(struct vb2_queue *q, struct v4l2_buffer *b, bool nonblocking)
+{
+	struct vb2_buffer *vb = NULL;
+	int ret;
+
+	if (b->type != q->type) {
+		dprintk(1, "dqbuf: invalid buffer type\n");
+		return -EINVAL;
+	}
+
+	ret = __vb2_get_done_vb(q, &vb, nonblocking);
+	if (ret < 0) {
+		dprintk(1, "dqbuf: error getting next done buffer\n");
+		return ret;
+	}
+
+	ret = call_qop(q, buf_finish, vb);
+	if (ret) {
+		dprintk(1, "dqbuf: buffer finish failed\n");
+		return ret;
+	}
+
+	switch (vb->state) {
+	case VB2_BUF_STATE_DONE:
+		dprintk(3, "dqbuf: Returning done buffer\n");
+		break;
+	case VB2_BUF_STATE_ERROR:
+		dprintk(3, "dqbuf: Returning done buffer with errors\n");
+		break;
+	default:
+		dprintk(1, "dqbuf: Invalid buffer state\n");
+		return -EINVAL;
+	}
+
+	/* Fill buffer information for the userspace */
+	__fill_v4l2_buffer(vb, b);
+	/* Remove from videobuf queue */
+	list_del(&vb->queued_entry);
+
+	dprintk(1, "dqbuf of buffer %d, with state %d\n",
+			vb->v4l2_buf.index, vb->state);
+
+	vb->state = VB2_BUF_STATE_DEQUEUED;
+	return 0;
+}
+EXPORT_SYMBOL_GPL(vb2_dqbuf);
+
+/**
+ * vb2_streamon - start streaming
+ * @q:		videobuf2 queue
+ * @type:	type argument passed from userspace to vidioc_streamon handler
+ *
+ * Should be called from vidioc_streamon handler of a driver.
+ * This function:
+ * 1) verifies current state
+ * 2) starts streaming and passes any previously queued buffers to the driver
+ *
+ * The return values from this function are intended to be directly returned
+ * from vidioc_streamon handler in the driver.
+ */
+int vb2_streamon(struct vb2_queue *q, enum v4l2_buf_type type)
+{
+	struct vb2_buffer *vb;
+
+	if (type != q->type) {
+		dprintk(1, "streamon: invalid stream type\n");
+		return -EINVAL;
+	}
+
+	if (q->streaming) {
+		dprintk(1, "streamon: already streaming\n");
+		return -EBUSY;
+	}
+
+	/*
+	 * Cannot start streaming on an OUTPUT device if no buffers have
+	 * been queued yet.
+	 */
+	if (V4L2_TYPE_IS_OUTPUT(q->type)) {
+		if (list_empty(&q->queued_list)) {
+			dprintk(1, "streamon: no output buffers queued\n");
+			return -EINVAL;
+		}
+	}
+
+	q->streaming = 1;
+
+	/*
+	 * Let driver notice that streaming state has been enabled.
+	 */
+	call_qop(q, start_streaming, q);
+
+	/*
+	 * If any buffers were queued before streamon,
+	 * we can now pass them to driver for processing.
+	 */
+	list_for_each_entry(vb, &q->queued_list, queued_entry)
+		__enqueue_in_driver(vb);
+
+	dprintk(3, "Streamon successful\n");
+	return 0;
+}
+EXPORT_SYMBOL_GPL(vb2_streamon);
+
+/**
+ * __vb2_queue_cancel() - cancel and stop (pause) streaming
+ *
+ * Removes all queued buffers from driver's queue and all buffers queued by
+ * userspace from videobuf's queue. Returns to state after reqbufs.
+ */
+static void __vb2_queue_cancel(struct vb2_queue *q)
+{
+	unsigned int i;
+
+	/*
+	 * Tell driver to stop all transactions and release all queued
+	 * buffers.
+	 */
+	if (q->streaming)
+		call_qop(q, stop_streaming, q);
+	q->streaming = 0;
+
+	/*
+	 * Remove all buffers from videobuf's list...
+	 */
+	INIT_LIST_HEAD(&q->queued_list);
+	/*
+	 * ...and done list; userspace will not receive any buffers it
+	 * has not already dequeued before initiating cancel.
+	 */
+	INIT_LIST_HEAD(&q->done_list);
+	wake_up_all(&q->done_wq);
+
+	/*
+	 * Reinitialize all buffers for next use.
+	 */
+	for (i = 0; i < q->num_buffers; ++i)
+		q->bufs[i]->state = VB2_BUF_STATE_DEQUEUED;
+}
+
+/**
+ * vb2_streamoff - stop streaming
+ * @q:		videobuf2 queue
+ * @type:	type argument passed from userspace to vidioc_streamoff handler
+ *
+ * Should be called from vidioc_streamoff handler of a driver.
+ * This function:
+ * 1) verifies current state,
+ * 2) stop streaming and dequeues any queued buffers, including those previously
+ *    passed to the driver (after waiting for the driver to finish).
+ *
+ * This call can be used for pausing playback.
+ * The return values from this function are intended to be directly returned
+ * from vidioc_streamoff handler in the driver
+ */
+int vb2_streamoff(struct vb2_queue *q, enum v4l2_buf_type type)
+{
+	if (type != q->type) {
+		dprintk(1, "streamoff: invalid stream type\n");
+		return -EINVAL;
+	}
+
+	if (!q->streaming) {
+		dprintk(1, "streamoff: not streaming\n");
+		return -EINVAL;
+	}
+
+	/*
+	 * Cancel will pause streaming and remove all buffers from the driver
+	 * and videobuf, effectively returning control over them to userspace.
+	 */
+	__vb2_queue_cancel(q);
+
+	dprintk(3, "Streamoff successful\n");
+	return 0;
+}
+EXPORT_SYMBOL_GPL(vb2_streamoff);
+
+/**
+ * __find_plane_by_offset() - find plane associated with the given offset off
+ */
+static int __find_plane_by_offset(struct vb2_queue *q, unsigned long off,
+			unsigned int *_buffer, unsigned int *_plane)
+{
+	struct vb2_buffer *vb;
+	unsigned int buffer, plane;
+
+	/*
+	 * Go over all buffers and their planes, comparing the given offset
+	 * with an offset assigned to each plane. If a match is found,
+	 * return its buffer and plane numbers.
+	 */
+	for (buffer = 0; buffer < q->num_buffers; ++buffer) {
+		vb = q->bufs[buffer];
+
+		for (plane = 0; plane < vb->num_planes; ++plane) {
+			if (vb->v4l2_planes[plane].m.mem_offset == off) {
+				*_buffer = buffer;
+				*_plane = plane;
+				return 0;
+			}
+		}
+	}
+
+	return -EINVAL;
+}
+
+/**
+ * vb2_mmap() - map video buffers into application address space
+ * @q:		videobuf2 queue
+ * @vma:	vma passed to the mmap file operation handler in the driver
+ *
+ * Should be called from mmap file operation handler of a driver.
+ * This function maps one plane of one of the available video buffers to
+ * userspace. To map whole video memory allocated on reqbufs, this function
+ * has to be called once per each plane per each buffer previously allocated.
+ *
+ * When the userspace application calls mmap, it passes to it an offset returned
+ * to it earlier by the means of vidioc_querybuf handler. That offset acts as
+ * a "cookie", which is then used to identify the plane to be mapped.
+ * This function finds a plane with a matching offset and a mapping is performed
+ * by the means of a provided memory operation.
+ *
+ * The return values from this function are intended to be directly returned
+ * from the mmap handler in driver.
+ */
+int vb2_mmap(struct vb2_queue *q, struct vm_area_struct *vma)
+{
+	unsigned long off = vma->vm_pgoff << PAGE_SHIFT;
+	struct vb2_plane *vb_plane;
+	struct vb2_buffer *vb;
+	unsigned int buffer, plane;
+	int ret;
+
+	if (q->memory != V4L2_MEMORY_MMAP) {
+		dprintk(1, "Queue is not currently set up for mmap\n");
+		return -EINVAL;
+	}
+
+	/*
+	 * Check memory area access mode.
+	 */
+	if (!(vma->vm_flags & VM_SHARED)) {
+		dprintk(1, "Invalid vma flags, VM_SHARED needed\n");
+		return -EINVAL;
+	}
+	if (V4L2_TYPE_IS_OUTPUT(q->type)) {
+		if (!(vma->vm_flags & VM_WRITE)) {
+			dprintk(1, "Invalid vma flags, VM_WRITE needed\n");
+			return -EINVAL;
+		}
+	} else {
+		if (!(vma->vm_flags & VM_READ)) {
+			dprintk(1, "Invalid vma flags, VM_READ needed\n");
+			return -EINVAL;
+		}
+	}
+
+	/*
+	 * Find the plane corresponding to the offset passed by userspace.
+	 */
+	ret = __find_plane_by_offset(q, off, &buffer, &plane);
+	if (ret)
+		return ret;
+
+	vb = q->bufs[buffer];
+	vb_plane = &vb->planes[plane];
+
+	ret = q->mem_ops->mmap(vb_plane->mem_priv, vma);
+	if (ret)
+		return ret;
+
+	vb_plane->mapped = 1;
+	vb->num_planes_mapped++;
+
+	dprintk(3, "Buffer %d, plane %d successfully mapped\n", buffer, plane);
+	return 0;
+}
+EXPORT_SYMBOL_GPL(vb2_mmap);
+
+
+/**
+ * vb2_poll() - implements poll userspace operation
+ * @q:		videobuf2 queue
+ * @file:	file argument passed to the poll file operation handler
+ * @wait:	wait argument passed to the poll file operation handler
+ *
+ * This function implements poll file operation handler for a driver.
+ * For CAPTURE queues, if a buffer is ready to be dequeued, the userspace will
+ * be informed that the file descriptor of a video device is available for
+ * reading.
+ * For OUTPUT queues, if a buffer is ready to be dequeued, the file descriptor
+ * will be reported as available for writing.
+ *
+ * The return values from this function are intended to be directly returned
+ * from poll handler in driver.
+ */
+unsigned int vb2_poll(struct vb2_queue *q, struct file *file, poll_table *wait)
+{
+	unsigned long flags;
+	struct vb2_buffer *vb = NULL;
+
+	/*
+	 * There is nothing to wait for if no buffers have already been queued.
+	 */
+	if (list_empty(&q->queued_list))
+		return POLLERR;
+
+	poll_wait(file, &q->done_wq, wait);
+
+	/*
+	 * Take first buffer available for dequeuing.
+	 */
+	spin_lock_irqsave(&q->done_lock, flags);
+	if (!list_empty(&q->done_list))
+		vb = list_first_entry(&q->done_list, struct vb2_buffer,
+					done_entry);
+	spin_unlock_irqrestore(&q->done_lock, flags);
+
+	if (vb && (vb->state == VB2_BUF_STATE_DONE
+			|| vb->state == VB2_BUF_STATE_ERROR)) {
+		return (V4L2_TYPE_IS_OUTPUT(q->type)) ? POLLOUT | POLLWRNORM :
+			POLLIN | POLLRDNORM;
+	}
+	return 0;
+}
+EXPORT_SYMBOL_GPL(vb2_poll);
+
+/**
+ * vb2_queue_init() - initialize a videobuf2 queue
+ * @q:		videobuf2 queue; this structure should be allocated in driver
+ * @ops:	driver-specific callbacks
+ * @alloc_ctx:	memory handler/allocator-specific context to be used;
+ *		the given context will be used for memory allocation on all
+ *		planes and buffers; it is possible to assign different contexts
+ *		per plane, use vb2_set_alloc_ctx() for that
+ * @type:	queue type
+ * @drv_priv:	driver private data, may be NULL; it can be used by driver in
+ *		driver-specific callbacks when issued
+ */
+int vb2_queue_init(struct vb2_queue *q)
+{
+	BUG_ON(!q);
+	BUG_ON(!q->ops);
+	BUG_ON(!q->mem_ops);
+	BUG_ON(!q->io_modes);
+
+	BUG_ON(!q->ops->queue_setup);
+	BUG_ON(!q->ops->buf_queue);
+
+	INIT_LIST_HEAD(&q->queued_list);
+	INIT_LIST_HEAD(&q->done_list);
+	spin_lock_init(&q->done_lock);
+	init_waitqueue_head(&q->done_wq);
+
+	if (q->buf_struct_size == 0)
+		q->buf_struct_size = sizeof(struct vb2_buffer);
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(vb2_queue_init);
+
+/**
+ * vb2_queue_release() - stop streaming, release the queue and free memory
+ * @q:		videobuf2 queue
+ *
+ * This function stops streaming and performs necessary clean ups, including
+ * freeing video buffer memory. The driver is responsible for freeing
+ * the vb2_queue structure itself.
+ */
+void vb2_queue_release(struct vb2_queue *q)
+{
+	__vb2_queue_cancel(q);
+	__vb2_queue_free(q);
+}
+EXPORT_SYMBOL_GPL(vb2_queue_release);
+
+MODULE_DESCRIPTION("Driver helper framework for Video for Linux 2");
+MODULE_AUTHOR("Pawel Osciak, Marek Szyprowski");
+MODULE_LICENSE("GPL");
diff --git a/include/media/videobuf2-core.h b/include/media/videobuf2-core.h
new file mode 100644
index 0000000..a44903a
--- /dev/null
+++ b/include/media/videobuf2-core.h
@@ -0,0 +1,368 @@
+/*
+ * videobuf2-core.h - V4L2 driver helper framework
+ *
+ * Copyright (C) 2010 Samsung Electronics
+ *
+ * Author: Pawel Osciak <p.osciak@samsung.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation.
+ */
+#ifndef _MEDIA_VIDEOBUF2_CORE_H
+#define _MEDIA_VIDEOBUF2_CORE_H
+
+#include <linux/mm_types.h>
+#include <linux/mutex.h>
+#include <linux/poll.h>
+#include <linux/videodev2.h>
+
+struct vb2_alloc_ctx;
+
+/**
+ * struct vb2_mem_ops - memory handling/memory allocator operations
+ * @alloc:	allocate video memory and, optionally, allocator private data,
+ *		return NULL on failure or a pointer to allocator private,
+ *		per-buffer data on success; the returned private structure
+ *		will then be passed as buf_priv argument to other ops in this
+ *		structure
+ * @put:	inform the allocator that the buffer will no longer be used;
+ *		usually will result in the allocator freeing the buffer (if
+ *		no other users of this buffer are present); the buf_priv
+ *		argument is the allocator private per-buffer structure
+ *		previously returned from the alloc callback
+ * @get_userptr: acquire userspace memory for a hardware operation; used for
+ *		 USERPTR memory types; vaddr is the address passed to the
+ *		 videobuf layer when queuing a video buffer of USERPTR type;
+ *		 should return an allocator private per-buffer structure
+ *		 associated with the buffer on success, NULL on failure;
+ *		 the returned private structure will then be passed as buf_priv
+ *		 argument to other ops in this structure
+ * @put_userptr: inform the allocator that a USERPTR buffer will no longer
+ *		 be used
+ * @vaddr:	return a kernel virtual address to a given memory buffer
+ *		associated with the passed private structure or NULL if no
+ *		such mapping exists
+ * @cookie:	return allocator specific cookie for a given memory buffer
+ *		associated with the passed private structure or NULL if not
+ *		available
+ * @num_users:	return the current number of users of a memory buffer;
+ *		return 1 if the videobuf layer (or actually the driver using
+ *		it) is the only user
+ * @mmap:	setup a userspace mapping for a given memory buffer under
+ *		the provided virtual memory region
+ *
+ * Required ops for USERPTR types: get_userptr, put_userptr.
+ * Required ops for MMAP types: alloc, put, num_users, mmap.
+ */
+struct vb2_mem_ops {
+	void		*(*alloc)(void *alloc_ctx, unsigned long size);
+	void		(*put)(void *buf_priv);
+
+	void		*(*get_userptr)(void *alloc_ctx, unsigned long vaddr,
+					unsigned long size, int write);
+	void		(*put_userptr)(void *buf_priv);
+
+	void		*(*vaddr)(void *buf_priv);
+	void		*(*cookie)(void *buf_priv);
+
+	unsigned int	(*num_users)(void *buf_priv);
+
+	int		(*mmap)(void *buf_priv, struct vm_area_struct *vma);
+};
+
+struct vb2_plane {
+	void			*mem_priv;
+	int			mapped:1;
+};
+
+/**
+ * enum vb2_io_modes - queue access methods
+ * @VB2_MMAP:		driver supports MMAP with streaming api
+ * @VB2_USERPTR:	driver supports USERPTR with streaming api
+ * @VB2_READ:		driver supports read() style access
+ * @VB2_WRITE:		driver supports write() style access
+ */
+enum vb2_io_modes {
+	VB2_MMAP	= (1 << 0),
+	VB2_USERPTR	= (1 << 1),
+	VB2_READ	= (1 << 2),
+	VB2_WRITE	= (1 << 3),
+};
+
+/**
+ * enum vb2_fileio_flags - flags for selecting a mode of the file io emulator,
+ * by default the 'streaming' style is used by the file io emulator
+ * @VB2_FILEIO_READ_ONCE:	report EOF after reading the first buffer
+ * @VB2_FILEIO_WRITE_IMMEDIATE:	queue buffer after each write() call
+ */
+enum vb2_fileio_flags {
+	VB2_FILEIO_READ_ONCE		= (1 << 0),
+	VB2_FILEIO_WRITE_IMMEDIATE	= (1 << 1),
+};
+
+/**
+ * enum vb2_buffer_state - current video buffer state
+ * @VB2_BUF_STATE_DEQUEUED:	buffer under userspace control
+ * @VB2_BUF_STATE_QUEUED:	buffer queued in videobuf, but not in driver
+ * @VB2_BUF_STATE_ACTIVE:	buffer queued in driver and possibly used
+ *				in a hardware operation
+ * @VB2_BUF_STATE_DONE:		buffer returned from driver to videobuf, but
+ *				not yet dequeued to userspace
+ * @VB2_BUF_STATE_ERROR:	same as above, but the operation on the buffer
+ *				has ended with an error, which will be reported
+ *				to the userspace when it is dequeued
+ */
+enum vb2_buffer_state {
+	VB2_BUF_STATE_DEQUEUED,
+	VB2_BUF_STATE_QUEUED,
+	VB2_BUF_STATE_ACTIVE,
+	VB2_BUF_STATE_DONE,
+	VB2_BUF_STATE_ERROR,
+};
+
+struct vb2_queue;
+
+/**
+ * struct vb2_buffer - represents a video buffer
+ * @v4l2_buf:		struct v4l2_buffer associated with this buffer; can
+ *			be read by the driver and relevant entries can be
+ *			changed by the driver in case of CAPTURE types
+ *			(such as timestamp)
+ * @v4l2_planes:	struct v4l2_planes associated with this buffer; can
+ *			be read by the driver and relevant entries can be
+ *			changed by the driver in case of CAPTURE types
+ *			(such as bytesused); NOTE that even for single-planar
+ *			types, the v4l2_planes[0] struct should be used
+ *			instead of v4l2_buf for filling bytesused - drivers
+ *			should use the vb2_set_plane_payload() function for that
+ * @vb2_queue:		the queue to which this driver belongs
+ * @num_planes:		number of planes in the buffer
+ *			on an internal driver queue
+ * @state:		current buffer state; do not change
+ * @queued_entry:	entry on the queued buffers list, which holds all
+ *			buffers queued from userspace
+ * @done_entry:		entry on the list that stores all buffers ready to
+ *			be dequeued to userspace
+ * @planes:		private per-plane information; do not change
+ * @num_planes_mapped:	number of mapped planes; do not change
+ */
+struct vb2_buffer {
+	struct v4l2_buffer	v4l2_buf;
+	struct v4l2_plane	v4l2_planes[VIDEO_MAX_PLANES];
+
+	struct vb2_queue	*vb2_queue;
+
+	unsigned int		num_planes;
+
+/* Private: internal use only */
+	enum vb2_buffer_state	state;
+
+	struct list_head	queued_entry;
+	struct list_head	done_entry;
+
+	struct vb2_plane	planes[VIDEO_MAX_PLANES];
+	unsigned int		num_planes_mapped;
+};
+
+/**
+ * struct vb2_ops - driver-specific callbacks
+ *
+ * @queue_setup:	called from a VIDIOC_REQBUFS handler, before
+ *			memory allocation; driver should return the required
+ *			number of buffers in num_buffers, the required number
+ *			of planes per buffer in num_planes and the required
+ *			sizes of planes in size_planes array
+ * @wait_prepare:	release any locks taken while calling vb2 functions;
+ *			it is called before ioctl needs to wait for a new buffer to
+ *			arrive; required to avoid deadlock in blocking access type
+ * @wait_finish:	reacquire all locks released in the previous callback;
+ *			required to continue operation after sleeping while
+ *			waiting for a new buffer to arrive
+ * @buf_init:		called once after allocating a buffer (in MMAP case)
+ *			or after acquiring a new USERPTR buffer; drivers may
+ *			perform additional buffer-related initialization;
+ *			initialization failure (return != 0) will prevent
+ *			queue setup from completing successfully; optional
+ * @buf_prepare:	called every time the buffer is queued from userspace;
+ *			drivers may perform any initialization required before
+ *			each hardware operation in this callback;
+ *			if an error is returned, the buffer will not be queued
+ *			in driver; optional
+ * @buf_finish:		called before every dequeue of the buffer back to
+ *			userspace; drivers may perform any operations required
+ *			before userspace accesses the buffer; optional
+ * @buf_cleanup:	called once before the buffer is freed; drivers may
+ *			perform any additional cleanup; optional
+ * @start_streaming:	called once before entering 'streaming' state; enables
+ *			driver to receive buffers over buf_queue() callback
+ * @stop_streaming:	called when 'streaming' state must be disabled; driver
+ *			should stop any dma transactions or wait until they
+ *			finish and give back all buffers it got from buf_queue()
+ *			callback
+ * @buf_queue:		passes buffer vb to the driver; driver may start
+ *			hardware operation on this buffer; driver should give
+ *			the buffer back by calling vb2_buffer_done() function
+ */
+struct vb2_ops {
+	int (*queue_setup)(struct vb2_queue *q, unsigned int *num_buffers,
+			   unsigned int *num_planes, unsigned long sizes[],
+			   void *alloc_ctxs[]);
+
+	void (*wait_prepare)(struct vb2_queue *q);
+	void (*wait_finish)(struct vb2_queue *q);
+
+	int (*buf_init)(struct vb2_buffer *vb);
+	int (*buf_prepare)(struct vb2_buffer *vb);
+	int (*buf_finish)(struct vb2_buffer *vb);
+	void (*buf_cleanup)(struct vb2_buffer *vb);
+
+	int (*start_streaming)(struct vb2_queue *q);
+	int (*stop_streaming)(struct vb2_queue *q);
+
+	void (*buf_queue)(struct vb2_buffer *vb);
+};
+
+/**
+ * struct vb2_queue - a videobuf queue
+ *
+ * @type:	queue type (see V4L2_BUF_TYPE_* in linux/videodev2.h
+ * @io_modes:	supported io methods (see vb2_io_modes enum)
+ * @io_flags:	additional io flags (see vb2_fileio_flags enum)
+ * @ops:	driver-specific callbacks
+ * @mem_ops:	memory allocator specific callbacks
+ * @drv_priv:	driver private data
+ * @buf_struct_size: size of the driver specific buffer structure; zero means
+ *		the driver doesn't want to use custom buffer structure type,
+ *		so sizeof(struct vb2_buffer) is used instead
+ *
+ * @memory:	current memory type used
+ * @bufs:	videobuf buffer structures
+ * @num_buffers: number of allocated/used buffers
+ * @queued_list: list of buffers currently queued from userspace
+ * @queued_count: number of buffers owned by the driver
+ * @done_list:	list of buffers ready to be dequeued to userspace
+ * @done_lock:	lock to protect done_list list
+ * @done_wq:	waitqueue for processes waiting for buffers ready to be dequeued
+ * @alloc_ctx:	memory type/allocator-specific contexts for each plane
+ * @streaming:	current streaming state
+ */
+struct vb2_queue {
+	enum v4l2_buf_type		type;
+	unsigned int			io_modes;
+	unsigned int			io_flags;
+
+	const struct vb2_ops		*ops;
+	const struct vb2_mem_ops	*mem_ops;
+	void				*drv_priv;
+	unsigned int			buf_struct_size;
+
+/* private: internal use only */
+	enum v4l2_memory		memory;
+	struct vb2_buffer		*bufs[VIDEO_MAX_FRAME];
+	unsigned int			num_buffers;
+
+	struct list_head		queued_list;
+
+	atomic_t			queued_count;
+	struct list_head		done_list;
+	spinlock_t			done_lock;
+	wait_queue_head_t		done_wq;
+
+	void				*alloc_ctx[VIDEO_MAX_PLANES];
+
+	unsigned int			streaming:1;
+};
+
+void *vb2_plane_vaddr(struct vb2_buffer *vb, unsigned int plane_no);
+void *vb2_plane_cookie(struct vb2_buffer *vb, unsigned int plane_no);
+
+void vb2_buffer_done(struct vb2_buffer *vb, enum vb2_buffer_state state);
+int vb2_wait_for_all_buffers(struct vb2_queue *q);
+
+int vb2_querybuf(struct vb2_queue *q, struct v4l2_buffer *b);
+int vb2_reqbufs(struct vb2_queue *q, struct v4l2_requestbuffers *req);
+
+int vb2_queue_init(struct vb2_queue *q);
+
+void vb2_queue_release(struct vb2_queue *q);
+
+int vb2_qbuf(struct vb2_queue *q, struct v4l2_buffer *b);
+int vb2_dqbuf(struct vb2_queue *q, struct v4l2_buffer *b, bool nonblocking);
+
+int vb2_streamon(struct vb2_queue *q, enum v4l2_buf_type type);
+int vb2_streamoff(struct vb2_queue *q, enum v4l2_buf_type type);
+
+int vb2_mmap(struct vb2_queue *q, struct vm_area_struct *vma);
+unsigned int vb2_poll(struct vb2_queue *q, struct file *file, poll_table *wait);
+
+/**
+ * vb2_is_streaming() - return streaming status of the queue
+ * @q:		videobuf queue
+ */
+static inline bool vb2_is_streaming(struct vb2_queue *q)
+{
+	return q->streaming;
+}
+
+/**
+ * vb2_is_busy() - return busy status of the queue
+ * @q:		videobuf queue
+ *
+ * This function checks if queue has any buffers allocated.
+ */
+static inline bool vb2_is_busy(struct vb2_queue *q)
+{
+	return (q->num_buffers > 0);
+}
+
+/**
+ * vb2_get_drv_priv() - return driver private data associated with the queue
+ * @q:		videobuf queue
+ */
+static inline void *vb2_get_drv_priv(struct vb2_queue *q)
+{
+	return q->drv_priv;
+}
+
+/**
+ * vb2_set_plane_payload() - set bytesused for the plane plane_no
+ * @vb:		buffer for which plane payload should be set
+ * @plane_no:	plane number for which payload should be set
+ * @size:	payload in bytes
+ */
+static inline void vb2_set_plane_payload(struct vb2_buffer *vb,
+				 unsigned int plane_no, unsigned long size)
+{
+	if (plane_no < vb->num_planes)
+		vb->v4l2_planes[plane_no].bytesused = size;
+}
+
+/**
+ * vb2_get_plane_payload() - set bytesused for the plane plane_no
+ * @vb:		buffer for which plane payload should be set
+ * @plane_no:	plane number for which payload should be set
+ * @size:	payload in bytes
+ */
+static inline unsigned long vb2_get_plane_payload(struct vb2_buffer *vb,
+				 unsigned int plane_no)
+{
+	if (plane_no < vb->num_planes)
+		return vb->v4l2_planes[plane_no].bytesused;
+	return 0;
+}
+
+/**
+ * vb2_plane_size() - return plane size in bytes
+ * @vb:		buffer for which plane size should be returned
+ * @plane_no:	plane number for which size should be returned
+ */
+static inline unsigned long
+vb2_plane_size(struct vb2_buffer *vb, unsigned int plane_no)
+{
+	if (plane_no < vb->num_planes)
+		return vb->v4l2_planes[plane_no].length;
+	return 0;
+}
+
+#endif /* _MEDIA_VIDEOBUF2_CORE_H */
-- 
1.7.1.569.g6f426

