Return-path: <mchehab@pedra>
Received: from proofpoint-cluster.metrocast.net ([65.175.128.136]:54692 "EHLO
	proofpoint-cluster.metrocast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751515Ab0KRM0G (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 18 Nov 2010 07:26:06 -0500
Subject: Re: [PATCH 1/7] v4l: add videobuf2 Video for Linux 2 driver
 framework
From: Andy Walls <awalls@md.metrocast.net>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>,
	linux-media@vger.kernel.org, pawel@osciak.com,
	kyungmin.park@samsung.com
In-Reply-To: <201011181017.39379.hverkuil@xs4all.nl>
References: <1289983174-2835-1-git-send-email-m.szyprowski@samsung.com>
	 <1289983174-2835-2-git-send-email-m.szyprowski@samsung.com>
	 <201011181017.39379.hverkuil@xs4all.nl>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 18 Nov 2010 07:26:30 -0500
Message-ID: <1290083190.2070.24.camel@morgan.silverblock.net>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Hans and Marek,

Some meta-comments below... ;)

On Thu, 2010-11-18 at 10:17 +0100, Hans Verkuil wrote:
> Hi Marek!
> 
> Some comments below...
> 
> On Wednesday, November 17, 2010 09:39:28 Marek Szyprowski wrote:
> > From: Pawel Osciak <p.osciak@samsung.com>
> > 
> > Videobuf2 is a Video for Linux 2 API-compatible driver framework for
> > multimedia devices. It acts as an intermediate layer between userspace
> > applications and device drivers. It also provides low-level, modular
> > memory management functions for drivers.
> > 
> > Videobuf2 eases driver development, reduces drivers' code size and aids in
> > proper and consistent implementation of V4L2 API in drivers.
> > 
> > Videobuf2 memory management backend is fully modular. This allows custom
> > memory management routines for devices and platforms with non-standard
> > memory management requirements to be plugged in, without changing the
> > high-level buffer management functions and API.
> > 
> > The framework provides:
> > - implementations of streaming I/O V4L2 ioctls and file operations
> > - high-level video buffer, video queue and state management functions
> > - video buffer memory allocation and management
> > 
> > Signed-off-by: Pawel Osciak <p.osciak@samsung.com>
> > Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
> > Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
> > CC: Pawel Osciak <pawel@osciak.com>
> > ---
> >  drivers/media/video/Kconfig          |    3 +
> >  drivers/media/video/Makefile         |    2 +
> >  drivers/media/video/videobuf2-core.c | 1434 ++++++++++++++++++++++++++++++++++
> >  include/media/videobuf2-core.h       |  373 +++++++++
> >  4 files changed, 1812 insertions(+), 0 deletions(-)
> >  create mode 100644 drivers/media/video/videobuf2-core.c
> >  create mode 100644 include/media/videobuf2-core.h
> > 
> > diff --git a/drivers/media/video/Kconfig b/drivers/media/video/Kconfig
> > index ac16e81..fef6a14 100644
> > --- a/drivers/media/video/Kconfig
> > +++ b/drivers/media/video/Kconfig
> > @@ -49,6 +49,9 @@ config V4L2_MEM2MEM_DEV
> >  	tristate
> >  	depends on VIDEOBUF_GEN
> >  
> > +config VIDEOBUF2_CORE
> > +	tristate
> > +
> >  #
> >  # Multimedia Video device configuration
> >  #
> > diff --git a/drivers/media/video/Makefile b/drivers/media/video/Makefile
> > index af79d47..77c4f85 100644
> > --- a/drivers/media/video/Makefile
> > +++ b/drivers/media/video/Makefile
> > @@ -114,6 +114,8 @@ obj-$(CONFIG_VIDEOBUF_VMALLOC) += videobuf-vmalloc.o
> >  obj-$(CONFIG_VIDEOBUF_DVB) += videobuf-dvb.o
> >  obj-$(CONFIG_VIDEO_BTCX)  += btcx-risc.o
> >  
> > +obj-$(CONFIG_VIDEOBUF2_CORE)		+= videobuf2-core.o
> > +
> >  obj-$(CONFIG_V4L2_MEM2MEM_DEV) += v4l2-mem2mem.o
> >  
> >  obj-$(CONFIG_VIDEO_M32R_AR_M64278) += arv.o
> > diff --git a/drivers/media/video/videobuf2-core.c b/drivers/media/video/videobuf2-core.c
> > new file mode 100644
> > index 0000000..5c9d3d8
> > --- /dev/null
> > +++ b/drivers/media/video/videobuf2-core.c
> > @@ -0,0 +1,1434 @@
> > +/*
> > + * videobuf2-core.c - V4L2 driver helper framework
> > + *
> > + * Copyright (C) 2010 Samsung Electronics
> > + *
> > + * Author: Pawel Osciak <p.osciak@samsung.com>
> > + *	   Marek Szyprowski <m.szyprowski@samsung.com>
> > + *
> > + * This program is free software; you can redistribute it and/or modify
> > + * it under the terms of the GNU General Public License as published by
> > + * the Free Software Foundation.
> > + */
> > +
> > +#include <linux/kernel.h>
> > +#include <linux/mm.h>
> > +#include <linux/module.h>
> > +#include <linux/slab.h>
> > +#include <linux/sched.h>
> > +#include <linux/err.h>
> > +#include <linux/poll.h>
> > +
> > +#include <media/videobuf2-core.h>
> > +
> > +static int debug;
> > +module_param(debug, int, 0644);
> > +
> > +#define dprintk(level, fmt, arg...)					\
> > +	do {								\
> > +		if (debug >= level)					\
> > +			printk(KERN_DEBUG "vb2: " fmt, ## arg);		\
> > +	} while (0)
> > +
> > +#define mem_ops(q, plane) ((q)->alloc_ctx[plane]->mem_ops)
> > +
> > +#define call_memop(q, plane, op, args...)				\
> > +	(((q)->alloc_ctx[plane]->mem_ops->op) ?				\
> > +		((q)->alloc_ctx[plane]->mem_ops->op(args)) : 0)
> 
> Why not use mem_ops in the call_memop macro? That would simplify it a bit.

I think you meant

"Why not use the the mem_ops macro in the call_memop macro?" 

Asking the user to pass in a mem_ops pointer as an argument to the
call_memop() macro isn't a simplification, but that's how I first read
your comment.

> > +
> > +#define call_qop(q, op, args...)					\
> > +	(((q)->ops->op) ? ((q)->ops->op(args)) : 0)
> > +
> > +/**
> > + * __vb2_buf_mem_alloc() - allocate video memory for the given buffer
> > + */
> > +static int __vb2_buf_mem_alloc(struct vb2_buffer *vb,
> > +				unsigned long *plane_sizes)
> > +{
> > +	struct vb2_queue *q = vb->vb2_queue;
> > +	void *mem_priv;
> > +	int plane;
> > +
> > +	/* Allocate memory for all planes in this buffer */
> > +	for (plane = 0; plane < vb->num_planes; ++plane) {
> > +		mem_priv = call_memop(q, plane, alloc, q->alloc_ctx[plane],
> > +					plane_sizes[plane]);
> > +		if (!mem_priv)
> > +			goto free;
> > +
> > +		/* Associate allocator private data with this plane */
> > +		vb->planes[plane].mem_priv = mem_priv;
> > +		vb->v4l2_planes[plane].length = plane_sizes[plane];
> > +	}
> > +
> > +	return 0;
> > +free:
> > +	/* Free already allocated memory if one of the allocations failed */
> > +	for (; plane > 0; --plane)
> > +		call_memop(q, plane, put, vb->planes[plane - 1].mem_priv);
> > +
> > +	return -ENOMEM;
> > +}
> > +
> > +/**
> > + * __vb2_buf_mem_free() - free memory of the given buffer
> > + */
> > +static void __vb2_buf_mem_free(struct vb2_buffer *vb)
> > +{
> > +	struct vb2_queue *q = vb->vb2_queue;
> > +	unsigned int plane;
> > +
> > +	for (plane = 0; plane < vb->num_planes; ++plane) {
> > +		call_memop(q, plane, put, vb->planes[plane].mem_priv);
> > +		dprintk(3, "Freed plane %d of buffer %d\n",
> > +				plane, vb->v4l2_buf.index);
> > +	}
> > +}
> > +
> > +/**
> > + * __vb2_buf_userptr_put() - release userspace memory associated associated
> > + * with a USERPTR buffer
> > + */
> > +static void __vb2_buf_userptr_put(struct vb2_buffer *vb)
> > +{
> > +	struct vb2_queue *q = vb->vb2_queue;
> > +	unsigned int plane;
> > +
> > +	for (plane = 0; plane < vb->num_planes; ++plane) {
> > +		call_memop(q, plane, put_userptr, vb->planes[plane].mem_priv);
> > +		vb->planes[plane].mem_priv = NULL;
> > +	}
> > +}
> > +
> > +/**
> > + * __setup_offsets() - setup unique offsets ("cookies") for every plane in
> > + * every buffer on the queue
> > + */
> > +static void __setup_offsets(struct vb2_queue *q)
> > +{
> > +	unsigned int buffer, plane;
> > +	struct vb2_buffer *vb;
> > +	unsigned long off = 0;
> > +
> > +	for (buffer = 0; buffer < q->num_buffers; ++buffer) {
> > +		vb = q->bufs[buffer];
> > +		if (!vb)
> > +			continue;
> > +
> > +		for (plane = 0; plane < vb->num_planes; ++plane) {
> > +			vb->v4l2_planes[plane].m.mem_offset = off;
> > +
> > +			dprintk(3, "Buffer %d, plane %d offset 0x%08lx\n",
> > +					buffer, plane, off);
> > +
> > +			off += vb->v4l2_planes[plane].length;
> > +			off = PAGE_ALIGN(off);
> > +		}
> > +	}
> > +}
> > +
> > +/**
> > + * __vb2_buf_alloc() - allocate a singe vb2_buffer structure
> > + *
> > + * Returns the pointer to the allocated structure.
> > + */
> > +void *__vb2_buf_alloc(struct vb2_queue *q)
> > +{
> > +	struct vb2_buffer *vb;
> > +	if (q->ops->buf_alloc)
> > +		vb = q->ops->buf_alloc(q);
> > +	else
> > +		vb = kzalloc(sizeof(struct vb2_buffer), GFP_KERNEL);
> > +	return vb;
> > +}
> > +
> > +/**
> > + * __vb2_buf_free() - free a singe vb2_buffer structure
> > + *
> > + * Frees memory used by the vb2_buffer structure.
> > + */
> > +void __vb2_buf_free(struct vb2_queue *q, struct vb2_buffer *vb)
> > +{
> > +	if (q->ops->buf_free)
> > +		q->ops->buf_free(q, vb);
> > +	else
> > +		kfree(vb);
> > +}
> > +
> > +/**
> > + * __vb2_queue_alloc() - allocate videobuf buffer structures and (for MMAP type)
> > + * video buffer memory for all buffers/planes on the queue and initializes the
> > + * queue
> > + *
> > + * Returns the number of buffers successfully allocated.
> > + */
> > +static int __vb2_queue_alloc(struct vb2_queue *q, enum v4l2_memory memory,
> > +			     unsigned int num_buffers, unsigned int num_planes)
> > +{
> > +	unsigned long plane_sizes[VIDEO_MAX_PLANES];
> > +	unsigned int buffer, plane;
> > +	struct vb2_buffer *vb;
> > +	int ret;
> > +
> > +	/* Get requested plane sizes from the driver */
> > +	for (plane = 0; plane < num_planes; ++plane) {
> > +		ret = call_qop(q, plane_setup, q, plane, &plane_sizes[plane]);
> > +		if (ret) {
> > +			dprintk(1, "Plane setup failed\n");
> > +			return ret;
> > +		}
> > +	}
> > +
> > +	for (buffer = 0; buffer < num_buffers; ++buffer) {
> > +		/* Allocate videobuf buffer structures */
> > +		vb = __vb2_buf_alloc(q);
> > +		if (!vb) {
> > +			dprintk(1, "Memory alloc for buffer struct failed\n");
> > +			break;
> > +		}
> > +
> > +		/* Length stores number of planes for multiplanar buffers */
> > +		if (V4L2_TYPE_IS_MULTIPLANAR(q->type))
> > +			vb->v4l2_buf.length = num_planes;
> > +
> > +		vb->state = VB2_BUF_STATE_DEQUEUED;
> > +		vb->vb2_queue = q;
> > +		vb->num_planes = num_planes;
> > +		vb->v4l2_buf.index = buffer;
> > +		vb->v4l2_buf.type = q->type;
> > +		vb->v4l2_buf.memory = memory;
> > +
> > +		/* Allocate video buffer memory for the MMAP type */
> > +		if (memory == V4L2_MEMORY_MMAP) {
> > +			ret = __vb2_buf_mem_alloc(vb, plane_sizes);
> > +			if (ret) {
> > +				dprintk(1, "Failed allocating memory for "
> > +						"buffer %d\n", buffer);
> > +				__vb2_buf_free(q, vb);
> > +				break;
> > +			}
> > +			/*
> > +			 * Call the driver-provided buffer initialization
> > +			 * callback, if given. An error in initialization
> > +			 * results in queue setup failure.
> > +			 */
> > +			ret = call_qop(q, buf_init, vb);
> > +			if (ret) {
> > +				dprintk(1, "Buffer %d %p initialization"
> > +					" failed\n", buffer, vb);
> > +				__vb2_buf_mem_free(vb);
> > +				__vb2_buf_free(q, vb);
> > +				break;
> > +			}
> > +		}
> > +
> > +		q->bufs[buffer] = vb;
> > +	}
> > +
> > +	q->num_buffers = buffer;
> > +
> > +	__setup_offsets(q);
> > +
> > +	dprintk(1, "Allocated %d buffers, %d plane(s) each\n",
> > +			q->num_buffers, num_planes);
> > +
> > +	return buffer;
> > +}
> > +
> > +/**
> > + * __vb2_free_mem() - release all video buffer memory for a given queue
> > + */
> > +static void __vb2_free_mem(struct vb2_queue *q)
> > +{
> > +	unsigned int buffer;
> > +	struct vb2_buffer *vb;
> > +
> > +	for (buffer = 0; buffer < q->num_buffers; ++buffer) {
> > +		vb = q->bufs[buffer];
> > +		if (!vb)
> > +			continue;
> > +
> > +		/* Free MMAP buffers or release USERPTR buffers */
> > +		if (q->memory == V4L2_MEMORY_MMAP)
> > +			__vb2_buf_mem_free(vb);
> > +		else
> > +			__vb2_buf_userptr_put(vb);
> > +	}
> > +}
> > +
> > +/**
> > + * __vb2_queue_free() - free the queue - video memory and related information
> > + * and return the queue to an uninitialized state
> > + */
> > +static int __vb2_queue_free(struct vb2_queue *q)
> > +{
> > +	unsigned int buffer;
> > +
> > +	/* Call driver-provided cleanup function for each buffer, if provided */
> > +	if (q->ops->buf_cleanup) {
> > +		for (buffer = 0; buffer < q->num_buffers; ++buffer) {
> > +			if (NULL == q->bufs[buffer])
> > +				continue;
> > +			q->ops->buf_cleanup(q->bufs[buffer]);
> > +		}
> > +	}
> > +
> > +	/* Release video buffer memory */
> > +	__vb2_free_mem(q);
> > +
> > +	/* Free videobuf buffers */
> > +	for (buffer = 0; buffer < q->num_buffers; ++buffer) {
> > +		if (NULL == q->bufs[buffer])
> > +			continue;
> > +		__vb2_buf_free(q, q->bufs[buffer]);
> > +		q->bufs[buffer] = NULL;
> > +	}
> > +
> > +	q->num_buffers = 0;
> > +	q->memory = 0;
> > +
> > +	return 0;
> > +}
> > +
> > +/**
> > + * __verify_planes_array() - verify that the planes array passed in struct
> > + * v4l2_buffer from userspace can be safely used
> > + */
> > +static int __verify_planes_array(struct vb2_buffer *vb, struct v4l2_buffer *b)
> > +{
> > +	/* Is memory for copying plane information present? */
> > +	if (NULL == b->m.planes) {
> > +		dprintk(1, "Multi-planar buffer passed but "
> > +			   "planes array not provided\n");
> > +		return -EINVAL;
> > +	}
> > +
> > +	if (b->length < vb->num_planes || b->length > VIDEO_MAX_PLANES) {
> > +		dprintk(1, "Incorrect planes array length, "
> > +			   "expected %d, got %d\n", vb->num_planes, b->length);
> > +		return -EINVAL;
> > +	}
> > +
> > +	return 0;
> > +}
> > +
> > +/**
> > + * __fill_v4l2_buffer() - fill in a struct v4l2_buffer with information to be
> > + * returned to userspace
> > + */
> > +static int __fill_v4l2_buffer(struct vb2_buffer *vb, struct v4l2_buffer *b)
> > +{
> > +	struct vb2_queue *q = vb->vb2_queue;
> > +	int ret = 0;
> > +
> > +	/* Copy back data such as timestamp, input, etc. */
> > +	memcpy(b, &vb->v4l2_buf, offsetof(struct v4l2_buffer, m));
> > +	b->input = vb->v4l2_buf.input;
> > +	b->reserved = vb->v4l2_buf.reserved;
> > +
> > +	if (V4L2_TYPE_IS_MULTIPLANAR(q->type)) {
> > +		ret = __verify_planes_array(vb, b);
> > +		if (ret)
> > +			return ret;
> > +
> > +		/*
> > +		 * Fill in plane-related data if userspace provided an array
> > +		 * for it. The memory and size is verified above.
> > +		 */
> > +		memcpy(b->m.planes, vb->v4l2_planes,
> > +			b->length * sizeof(struct v4l2_plane));
> > +	} else {
> > +		/*
> > +		 * We use length and offset in v4l2_planes array even for
> > +		 * single-planar buffers, but userspace does not.
> > +		 */
> > +		b->length = vb->v4l2_planes[0].length;
> > +		b->bytesused = vb->v4l2_planes[0].bytesused;
> > +		if (q->memory == V4L2_MEMORY_MMAP)
> > +			b->m.offset = vb->v4l2_planes[0].m.mem_offset;
> > +	}
> > +
> > +	b->flags = 0;
> > +
> > +	switch (vb->state) {
> > +	case VB2_BUF_STATE_QUEUED:
> > +	case VB2_BUF_STATE_ACTIVE:
> > +		b->flags |= V4L2_BUF_FLAG_QUEUED;
> > +		break;
> > +	case VB2_BUF_STATE_ERROR:
> > +		b->flags |= V4L2_BUF_FLAG_ERROR;
> > +		/* fall through */
> > +	case VB2_BUF_STATE_DONE:
> > +		b->flags |= V4L2_BUF_FLAG_DONE;
> > +		break;
> > +	case VB2_BUF_STATE_DEQUEUED:
> > +		/* nothing */
> > +		break;
> > +	}
> > +
> > +	if (vb->num_planes_mapped == vb->num_planes)
> > +		b->flags |= V4L2_BUF_FLAG_MAPPED;
> > +
> > +	return ret;
> > +}
> > +
> > +/**
> > + * vb2_querybuf() - query video buffer information
> > + * @q:		videobuf queue
> > + * @b:		buffer struct passed from userspace to vidioc_querybuf handler
> > + *		in driver
> > + *
> > + * Should be called from vidioc_querybuf ioctl handler in driver.
> > + * This function will verify the passed v4l2_buffer structure and fill the
> > + * relevant information for the userspace.
> > + *
> > + * The return values from this function are intended to be directly returned
> > + * from vidioc_querybuf handler in driver.
> > + */
> > +int vb2_querybuf(struct vb2_queue *q, struct v4l2_buffer *b)
> > +{
> > +	struct vb2_buffer *vb;
> > +	int ret = -EINVAL;
> > +
> > +	if (b->type != q->type) {
> > +		dprintk(1, "querybuf: wrong buffer type\n");
> > +		goto done;
> 
> Just to return -EINVAL;
> 
> > +	}
> > +
> > +	if (b->index >= q->num_buffers) {
> > +		dprintk(1, "querybuf: buffer index out of range\n");
> > +		goto done;
> 
> ditto
> 
> > +	}
> > +	vb = q->bufs[b->index];
> > +	if (NULL == vb) {
> > +		/* Should never happen */
> > +		dprintk(1, "querybuf: no such buffer\n");
> > +		goto done;
> 
> ditto
> 
> > +	}
> > +
> > +	ret = __fill_v4l2_buffer(vb, b);
> 
> Just do return __file_v4l2_buffer(vb, b);
> 
> > +done:
> > +	return ret;
> > +}
> > +EXPORT_SYMBOL(vb2_querybuf);
> > +
> > +/**
> > + * __verify_userptr_ops() - verify that all memory operations required for
> > + * USERPTR queue type have been provided
> > + */
> > +static int __verify_userptr_ops(struct vb2_queue *q, unsigned int num_planes)
> > +{
> > +	unsigned int i;
> > +
> > +	for (i = 0; i < num_planes; ++i)
> > +		if (!mem_ops(q, i)->get_userptr || !mem_ops(q, i)->put_userptr)
> > +			return -EINVAL;
> > +
> > +	return 0;
> > +}
> > +
> > +/**
> > + * __verify_mmap_ops() - verify that all memory operations required for
> > + * MMAP queue type have been provided
> > + */
> > +static int __verify_mmap_ops(struct vb2_queue *q, unsigned int num_planes)
> > +{
> > +	unsigned int i;
> > +
> > +	for (i = 0; i < num_planes; ++i)
> > +		if (!mem_ops(q, i)->alloc || !mem_ops(q, i)->put
> > +				|| !mem_ops(q, i)->mmap)
> > +			return -EINVAL;
> > +
> > +	return 0;
> > +}
> > +
> > +/**
> > + * __buffers_in_use() - return true if any buffers on the queue are in use and
> > + * the queue cannot be freed (by the means of REQBUFS(0)) call
> > + */
> > +static bool __buffers_in_use(struct vb2_queue *q)
> > +{
> > +	unsigned int buffer, plane;
> > +	struct vb2_buffer *vb;
> > +
> > +	for (buffer = 0; buffer < q->num_buffers; ++buffer) {
> > +		vb = q->bufs[buffer];
> > +		for (plane = 0; plane < vb->num_planes; ++plane) {
> > +			/*
> > +			 * If num_users() has not been provided, apparently
> > +			 * nobody cares.
> > +			 */
> > +			if (!mem_ops(q, plane)->num_users)
> > +				continue;
> > +
> > +			/*
> > +			 * If num_users() returns more than 1, we are not the
> > +			 * only user of the plane's memory.
> > +			 */
> > +			if (call_memop(q, plane, num_users,
> > +					vb->planes[plane].mem_priv) > 1)
> > +				return true;
> > +		}
> > +	}
> > +
> > +	return false;
> > +}
> > +
> > +/**
> > + * vb2_reqbufs() - Initiate streaming
> > + * @q:		videobuf2 queue
> > + * @req:	struct passed from userspace to vidioc_reqbufs handler in driver
> > + *
> > + * Should be called from vidioc_reqbufs ioctl handler of a driver.
> > + * This function:
> > + * 1) verifies streaming parameters passed from the userspace,
> > + * 2) sets up the queue,
> > + * 3) negotiates number of buffers and planes per buffer with the driver
> > + *    to be used during streaming,
> > + * 4) allocates internal buffer structures (struct vb2_buffer), according to
> > + *    the agreed parameters,
> > + * 5) for MMAP memory type, allocates actual video memory, using the
> > + *    memory handling/allocation routines provided during queue initialization
> > + *
> > + * If req->count is 0, all the memory will be freed instead.
> > + * If the queue has been allocated previously (by a previous vb2_reqbufs) call
> > + * and the queue is not busy, memory will be reallocated.
> > + *
> > + * The return values from this function are intended to be directly returned
> > + * from vidioc_reqbufs handler in driver.
> > + */
> > +int vb2_reqbufs(struct vb2_queue *q, struct v4l2_requestbuffers *req)
> > +{
> > +	unsigned int num_buffers, num_planes;
> > +	int ret = 0;
> > +
> > +	if (req->memory != V4L2_MEMORY_MMAP
> > +			&& req->memory != V4L2_MEMORY_USERPTR) {
> > +		dprintk(1, "reqbufs: unsupported memory type\n");
> > +		return -EINVAL;
> > +	}
> > +
> > +	if (req->type != q->type) {
> > +		dprintk(1, "reqbufs: queue type invalid\n");
> > +		return -EINVAL;
> > +	}
> > +
> > +	if (q->streaming) {
> > +		dprintk(1, "reqbufs: streaming active\n");
> > +		return -EBUSY;
> > +	}
> > +
> > +	if (req->count == 0) {
> > +		/* Free/release memory for count = 0, but only if unused */
> > +		if (q->memory == V4L2_MEMORY_MMAP && __buffers_in_use(q)) {
> > +			dprintk(1, "reqbufs: memory in use, cannot free\n");
> > +			ret = -EBUSY;
> > +			goto end;
> > +		}
> > +
> > +		ret = __vb2_queue_free(q);
> 
> OK, I have a problem here. How do I detect as an application whether a driver
> supports MMAP and/or USERPTR?
> 
> What I am using in qv4l2 (and it doesn't work properly with videobuf) is that
> I call REQBUFS with count == 0 for MMAP and for USERPTR and I check whether it
> returns 0 or -EINVAL.


> It seems a reasonable test since it doesn't allocate anything. It would be nice
> if vb2 can check for the memory field here based on what the driver supports.
> 
> Ideally we should make this an official part of the spec (or have some other
> mechanism to find out what it supported).

Well it seems to be documented, just not clearly:

First paragraph here:
http://linuxtv.org/downloads/v4l-dvb-apis/mmap.html

First & second Paragraph here:
http://linuxtv.org/downloads/v4l-dvb-apis/userp.html
(which mentions not allocating things.)

And in the description here:
http://linuxtv.org/downloads/v4l-dvb-apis/vidioc-reqbufs.html


I suppose  adding flags to VIDIOC_QUERYCAP results would remove all the
hokey algorithmic probing of what the driver should already know.
 http://linuxtv.org/downloads/v4l-dvb-apis/vidioc-querycap.html

V4L2_CAP_STREAMING            0x04000000
V4L2_CAP_STREAMING_MMAP       0x08000000 
V4L2_CAP_STREAMING_USER_PTR   0x10000000

> > +		goto end;
> > +	}
> > +
> > +	if (q->num_buffers != 0) {
> > +		/*
> > +		 * We already have buffers allocated, so a reallocation is
> > +		 * required, but only if the buffers are not in use.
> > +		 */
> > +		if (q->memory == V4L2_MEMORY_MMAP && __buffers_in_use(q)) {
> > +			dprintk(1, "reqbufs: memory in use, "
> > +					"cannot reallocate\n");
> > +			ret = -EBUSY;
> > +			goto end;
> > +		}
> > +
> > +		ret = __vb2_queue_free(q);
> > +		if (ret)
> > +			goto end;
> > +	}
> > +
> > +	num_buffers = min_t(unsigned int, req->count, VIDEO_MAX_FRAME);
> > +
> > +	/* Ask the driver how many buffers and planes per buffer it requires */
> > +	ret = q->ops->queue_negotiate(q, &num_buffers, &num_planes);
> > +	if (ret)
> > +		goto end;
> > +
> > +	/*
> > +	 * Make sure all the required memory ops for given memory type
> > +	 * are available.
> > +	 */
> > +	if (req->memory == V4L2_MEMORY_MMAP
> > +			&& __verify_mmap_ops(q, num_planes)) {
> > +		dprintk(1, "reqbufs: MMAP for current setup unsupported\n");
> > +		ret = -EINVAL;
> > +		goto end;
> > +	} else if (req->memory == V4L2_MEMORY_USERPTR
> > +			&& __verify_userptr_ops(q, num_planes)) {
> > +		dprintk(1, "reqbufs: USERPTR for current setup unsupported\n");
> > +		ret = -EINVAL;
> > +		goto end;
> > +	}
> > +
> > +	/* Finally, allocate buffers and video memory */
> > +	ret = __vb2_queue_alloc(q, req->memory, num_buffers, num_planes);
> > +	if (ret < 0) {
> > +		dprintk(1, "Memory allocation failed with error: %d\n", ret);
> > +	} else {
> > +		/*
> > +		 * Return the number of successfully allocated buffers
> > +		 * to the userspace.
> > +		 */
> > +		req->count = ret;
> > +		ret = 0;
> > +	}
> > +
> > +	q->memory = req->memory;
> > +
> > +end:
> > +	return ret;
> > +}
> > +EXPORT_SYMBOL_GPL(vb2_reqbufs);
> > +
> > +/**
> > + * vb2_plane_vaddr() - Return a kernel virtual address of a given plane
> > + * @vb:		vb2_buffer to which the plane in question belongs to
> > + * @plane_no:	plane number for which the address is to be returned
> > + *
> > + * This function returns a kernel virtual address of a given plane if
> > + * such a mapping exist, NULL otherwise.
> > + */
> > +void *vb2_plane_vaddr(struct vb2_buffer *vb, unsigned int plane_no)
> > +{
> > +	struct vb2_queue *q = vb->vb2_queue;
> > +
> > +	if (plane_no > vb->num_planes)
> > +		return NULL;
> > +
> > +	return call_memop(q, plane_no, vaddr, vb->planes[plane_no].mem_priv);
> > +
> > +}
> > +EXPORT_SYMBOL_GPL(vb2_plane_vaddr);
> > +
> > +/**
> > + * vb2_plane_cookie() - Return allocator specific cookie for the given plane
> > + * @vb:		vb2_buffer to which the plane in question belongs to
> > + * @plane_no:	plane number for which the address is to be returned
> > + *
> > + * This function returns a physical address of a given plane if available,
> > + * NULL otherwise.
> 
> This comment should be extended since it now returns a cookie instead of a
> physical address. Some explanation would be useful here.
> 
> > + */
> > +void *vb2_plane_cookie(struct vb2_buffer *vb, unsigned int plane_no)
> > +{
> > +	struct vb2_queue *q = vb->vb2_queue;
> > +
> > +	if (plane_no > vb->num_planes)
> > +		return 0UL;
> > +
> > +	return call_memop(q, plane_no, cookie, vb->planes[plane_no].mem_priv);
> > +}
> > +EXPORT_SYMBOL_GPL(vb2_plane_cookie);
> > +
> > +/**
> > + * vb2_buffer_done() - inform videobuf that an operation on a buffer is finished
> > + * @vb:		vb2_buffer returned from the driver
> > + * @state:	either VB2_BUF_STATE_DONE if the operation finished successfully
> > + *		or VB2_BUF_STATE_ERROR if the operation finished with an error
> > + *
> > + * This function should be called by the driver after a hardware operation on
> > + * a buffer is finished and the buffer may be returned to userspace. The driver
> > + * cannot use this buffer anymore until it is queued back to it by videobuf
> > + * by the means of buf_queue callback. Only buffers previously queued to the
> > + * driver by buf_queue can be passed to this function.
> > + */
> > +void vb2_buffer_done(struct vb2_buffer *vb, enum vb2_buffer_state state)
> > +{
> > +	struct vb2_queue *q = vb->vb2_queue;
> > +	unsigned long flags;
> > +
> > +	if (vb->state != VB2_BUF_STATE_ACTIVE)
> > +		return;
> > +
> > +	if (state != VB2_BUF_STATE_DONE && state != VB2_BUF_STATE_ERROR)
> > +		return;
> > +
> > +	dprintk(4, "Done processing on buffer %d, state: %d\n",
> > +			vb->v4l2_buf.index, vb->state);
> > +
> > +	/* Add the buffer to the done buffers list */
> > +	spin_lock_irqsave(&q->done_lock, flags);
> > +	vb->state = state;
> > +	list_add_tail(&vb->done_entry, &q->done_list);
> > +	spin_unlock_irqrestore(&q->done_lock, flags);
> > +
> > +	/* Inform any processes that may be waiting for buffers */
> > +	wake_up(&q->done_wq);
> > +}
> > +EXPORT_SYMBOL_GPL(vb2_buffer_done);
> > +
> > +/**
> > + * __fill_vb2_buffer() - fill a vb2_buffer with information provided in
> > + * a v4l2_buffer by the userspace
> > + */
> > +static int __fill_vb2_buffer(struct vb2_buffer *vb, struct v4l2_buffer *b,
> > +				struct v4l2_plane *v4l2_planes)
> > +{
> > +	unsigned int plane;
> > +	int ret;
> > +
> > +	if (V4L2_TYPE_IS_MULTIPLANAR(b->type)) {
> > +		/*
> > +		 * Verify that the userspace gave us a valid array for
> > +		 * plane information.
> > +		 */
> > +		ret = __verify_planes_array(vb, b);
> > +		if (ret)
> > +			return ret;
> > +
> > +		/* Fill in driver-provided information for OUTPUT types */
> > +		if (V4L2_TYPE_IS_OUTPUT(b->type)) {
> > +			/*
> > +			 * Will have to go up to b->length when API starts
> > +			 * accepting variable number of planes.
> > +			 */
> > +			for (plane = 0; plane < vb->num_planes; ++plane) {
> > +				v4l2_planes[plane].bytesused =
> > +					b->m.planes[plane].bytesused;
> > +				v4l2_planes[plane].data_offset =
> > +					b->m.planes[plane].data_offset;
> > +			}
> > +		}
> > +
> > +		if (b->memory == V4L2_MEMORY_USERPTR) {
> > +			for (plane = 0; plane < vb->num_planes; ++plane) {
> > +				v4l2_planes[plane].m.userptr =
> > +					b->m.planes[plane].m.userptr;
> > +				v4l2_planes[plane].length =
> > +					b->m.planes[plane].length;
> > +			}
> > +		}
> > +	} else {
> > +		/*
> > +		 * Single-planar buffers do not use planes array,
> > +		 * so fill in relevant v4l2_buffer struct fields instead.
> > +		 * In videobuf we use our internal V4l2_planes struct for
> > +		 * single-planar buffers as well, for simplicity.
> > +		 */
> > +		if (V4L2_TYPE_IS_OUTPUT(b->type))
> > +			v4l2_planes[0].bytesused = b->bytesused;
> > +
> > +		if (b->memory == V4L2_MEMORY_USERPTR) {
> > +			v4l2_planes[0].m.userptr = b->m.userptr;
> > +			v4l2_planes[0].length = b->length;
> > +		}
> > +	}
> > +
> > +	vb->v4l2_buf.field = b->field;
> > +	vb->v4l2_buf.timestamp = b->timestamp;
> > +
> > +	return 0;
> > +}
> > +
> > +/**
> > + * __qbuf_userptr() - handle qbuf of a USERPTR buffer
> > + */
> > +static int __qbuf_userptr(struct vb2_buffer *vb, struct v4l2_buffer *b)
> > +{
> > +	struct v4l2_plane planes[VIDEO_MAX_PLANES];
> > +	struct vb2_queue *q = vb->vb2_queue;
> > +	void *mem_priv = NULL;
> > +	unsigned int plane;
> > +	int ret;
> > +
> > +	/* Verify and copy relevant information provided by the userspace */
> > +	ret = __fill_vb2_buffer(vb, b, planes);
> > +	if (ret)
> > +		return ret;
> > +
> > +	for (plane = 0; plane < vb->num_planes; ++plane) {
> > +		/* Skip the plane if already verified */
> > +		if (vb->v4l2_planes[plane].m.userptr == planes[plane].m.userptr
> > +		    && vb->v4l2_planes[plane].length == planes[plane].length)
> > +			continue;
> > +
> > +		dprintk(3, "qbuf: userspace address for plane %d changed, "
> > +				"reacquiring memory\n", plane);
> > +
> > +		/* Release previously acquired memory if present */
> > +		if (vb->planes[plane].mem_priv)
> > +			call_memop(q, plane, put_userptr,
> > +					vb->planes[plane].mem_priv);
> > +
> > +		vb->planes[plane].mem_priv = NULL;
> > +
> > +		/* Acquire each plane's memory */
> > +		if (mem_ops(q, plane)->get_userptr) {
> > +			mem_priv = mem_ops(q, plane)->get_userptr(
> > +							planes[plane].m.userptr,
> > +							planes[plane].length);
> > +			if (IS_ERR(mem_priv)) {
> > +				dprintk(1, "qbuf: failed acquiring userspace "
> > +						"memory for plane %d\n", plane);
> > +				goto err;
> > +			}
> > +
> > +			vb->planes[plane].mem_priv = mem_priv;
> > +		}
> > +	}
> > +
> > +	/*
> > +	 * Call driver-specific initialization on the newly acquired buffer,
> > +	 * if provided.
> > +	 */
> > +	ret = call_qop(q, buf_init, vb);
> > +	if (ret) {
> > +		dprintk(1, "qbuf: buffer initialization failed\n");
> > +		goto err;
> > +	}
> > +
> > +	/*
> > +	 * Now that everything is in order, copy relevant information
> > +	 * provided by userspace.
> > +	 */
> > +	for (plane = 0; plane < vb->num_planes; ++plane)
> > +		vb->v4l2_planes[plane] = planes[plane];
> > +
> > +	return 0;
> > +err:
> > +	/* In case of errors, release planes that were already acquired */
> > +	for (; plane > 0; --plane) {
> > +		call_memop(q, plane, put_userptr,
> > +				vb->planes[plane - 1].mem_priv);
> > +		vb->planes[plane - 1].mem_priv = NULL;
> > +	}
> > +
> > +	return ret;
> > +}
> > +
> > +/**
> > + * __qbuf_mmap() - handle qbuf of an MMAP buffer
> > + */
> > +static int __qbuf_mmap(struct vb2_buffer *vb, struct v4l2_buffer *b)
> > +{
> > +	return __fill_vb2_buffer(vb, b, vb->v4l2_planes);
> > +}
> > +
> > +/**
> > + * __enqueue_in_driver() - enqueue a vb2_buffer in driver for processing
> > + */
> > +static void __enqueue_in_driver(struct vb2_buffer *vb)
> > +{
> > +	struct vb2_queue *q = vb->vb2_queue;
> > +	vb->state = VB2_BUF_STATE_ACTIVE;
> > +	q->ops->buf_queue(vb);
> > +}
> > +
> > +/**
> > + * vb2_qbuf() - Queue a buffer from userspace
> > + * @q:		videobuf2 queue
> > + * @b:		buffer structure passed from userspace to vidioc_qbuf handler
> > + *		in driver
> > + *
> > + * Should be called from vidioc_qbuf ioctl handler of a driver.
> > + * This function:
> > + * 1) verifies the passed buffer,
> > + * 2) calls buf_prepare callback in the driver (if provided), in which
> > + *    driver-specific buffer initialization can be performed,
> > + * 3) if streaming is on, queues the buffer in driver by the means of buf_queue
> > + *    callback for processing.
> > + *
> > + * The return values from this function are intended to be directly returned
> > + * from vidioc_qbuf handler in driver.
> > + */
> > +int vb2_qbuf(struct vb2_queue *q, struct v4l2_buffer *b)
> > +{
> > +	struct vb2_buffer *vb;
> > +	int ret = 0;
> > +
> > +
> > +	if (b->type != q->type) {
> > +		dprintk(1, "qbuf: invalid buffer type\n");
> > +		return -EINVAL;
> > +	}
> > +
> > +	if (b->index >= q->num_buffers) {
> > +		dprintk(1, "qbuf: buffer index out of range\n");
> > +		return -EINVAL;
> > +	}
> > +
> > +	vb = q->bufs[b->index];
> > +	if (NULL == vb) {
> > +		/* Should never happen */
> > +		dprintk(1, "qbuf: buffer is NULL\n");
> > +		return -EINVAL;
> > +	}
> > +
> > +	if (b->memory != q->memory) {
> > +		dprintk(1, "qbuf: invalid memory type\n");
> > +		return -EINVAL;
> > +	}
> > +
> > +	if (vb->state != VB2_BUF_STATE_DEQUEUED) {
> > +		dprintk(1, "qbuf: buffer already in use\n");
> > +		return -EINVAL;
> > +	}
> > +
> > +	if (q->memory == V4L2_MEMORY_MMAP)
> > +		ret = __qbuf_mmap(vb, b);
> > +	else if (q->memory == V4L2_MEMORY_USERPTR)
> > +		ret = __qbuf_userptr(vb, b);
> > +	if (ret)
> > +		goto done;
> > +
> > +	ret = call_qop(q, buf_prepare, vb);
> > +	if (ret) {
> > +		dprintk(1, "qbuf: buffer preparation failed\n");
> > +		goto done;
> > +	}
> > +
> > +	/*
> > +	 * Add to the queued buffers list, a buffer will stay on it until
> > +	 * dequeued in dqbuf.
> > +	 */
> > +	list_add_tail(&vb->queued_entry, &q->queued_list);
> > +	vb->state = VB2_BUF_STATE_QUEUED;
> > +
> > +	/*
> > +	 * If already streaming, give the buffer to driver for processing.
> > +	 * If not, the buffer will be given to driver on next streamon.
> > +	 */
> > +	if (q->streaming)
> > +		__enqueue_in_driver(vb);
> > +
> > +	dprintk(1, "qbuf of buffer %d succeeded\n", vb->v4l2_buf.index);
> > +	ret = 0;
> > +done:
> > +	return ret;
> > +}
> > +EXPORT_SYMBOL_GPL(vb2_qbuf);
> > +
> > +/**
> > + * __vb2_wait_for_done_vb() - wait for a buffer to become available
> > + * for dequeuing
> > + *
> > + * Will sleep if required for nonblocking == false.
> > + */
> > +static int __vb2_wait_for_done_vb(struct vb2_queue *q, int nonblocking)
> > +{
> > +checks:
> > +	if (!q->streaming) {
> > +		dprintk(1, "Streaming off, will not wait for buffers\n");
> > +		return -EINVAL;
> > +	}
> > +
> > +	/*
> > +	 * Buffers may be added to vb_done_list without holding the driver's
> > +	 * lock, but removal is performed only while holding both driver's
> > +	 * lock and the vb_done_lock spinlock. Thus we can be sure that as
> > +	 * long as we hold lock, the list will remain not empty if this
> > +	 * check succeeds.
> > +	 */
> > +	if (list_empty(&q->done_list)) {
> > +		int retval;
> > +		if (nonblocking) {
> > +			dprintk(1, "Nonblocking and no buffers to dequeue, "
> > +					"will not wait\n");
> > +			return -EAGAIN;
> > +		}
> > +
> > +		/*
> > +		 * We are streaming and nonblocking, wait for another buffer to
> > +		 * become ready or for streamoff. Driver's lock is released to
> > +		 * allow streamoff or qbuf to be called while waiting.
> > +		 */
> > +		call_qop(q, unlock, q);
> > +
> > +		/*
> > +		 * Although the mutex is released here, we will be reevaluating
> > +		 * both conditions again after reacquiring it.
> > +		 */
> > +		dprintk(3, "Will sleep waiting for buffers\n");
> > +		retval = wait_event_interruptible(q->done_wq,
> > +				!list_empty(&q->done_list) || !q->streaming);
> > +		call_qop(q, lock, q);
> > +
> > +		if (retval)
> > +			return -EINTR;
> > +
> > +		goto checks;
> > +	}
> > +	return 0;
> > +}
> > +
> > +/**
> > + * __vb2_get_done_vb() - get a buffer ready for dequeuing
> > + *
> > + * Will sleep if required for nonblocking == false.
> > + */
> > +static int __vb2_get_done_vb(struct vb2_queue *q, struct vb2_buffer **vb,
> > +				int nonblocking)
> > +{
> > +	unsigned long flags;
> > +	int ret = 0;
> > +
> > +	/*
> > +	 * Wait for at least one buffer to become available on the done_list.
> > +	 */
> > +	ret = __vb2_wait_for_done_vb(q, nonblocking);
> > +	if (ret)
> > +		goto end;
> > +
> > +	/*
> > +	 * Drivers lock has been held since we last verified that done_list is
> > +	 * not empty, so no need for another list_empty(done_list) check.
> > +	 */
> > +	spin_lock_irqsave(&q->done_lock, flags);
> > +	*vb = list_first_entry(&q->done_list, struct vb2_buffer, done_entry);
> > +	list_del(&(*vb)->done_entry);
> > +	spin_unlock_irqrestore(&q->done_lock, flags);
> > +
> > +end:
> > +	return ret;
> > +}
> > +
> > +
> > +/**
> > + * vb2_dqbuf() - Dequeue a buffer to the userspace
> > + * @q:		videobuf2 queue
> > + * @b:		buffer structure passed from userspace to vidioc_dqbuf handler
> > + *		in driver
> > + * @nonblocking: if true, this call will not sleep waiting for a buffer if no
> > + *		 buffers ready for dequeuing are present. Normally the driver
> > + *		 would be passing (file->f_flags & O_NONBLOCK) here
> > + *
> > + * Should be called from vidioc_dqbuf ioctl handler of a driver.
> > + * This function:
> > + * 1) verifies the passed buffer,
> > + * 2) calls buf_finish callback in the driver (if provided), in which
> > + *    driver can perform any additional operations that may be required before
> > + *    returning the buffer to userspace, such as cache sync,
> > + * 3) the buffer struct members are filled with relevant information for
> > + *    the userspace.
> > + *
> > + * The return values from this function are intended to be directly returned
> > + * from vidioc_dqbuf handler in driver.
> > + */
> > +int vb2_dqbuf(struct vb2_queue *q, struct v4l2_buffer *b, bool nonblocking)
> > +{
> > +	struct vb2_buffer *vb = NULL;
> > +	int ret;
> > +
> > +
> > +	if (b->type != q->type) {
> > +		dprintk(1, "dqbuf: invalid buffer type\n");
> > +		return -EINVAL;
> > +	}
> > +
> > +	ret = __vb2_get_done_vb(q, &vb, nonblocking);
> > +	if (ret < 0) {
> > +		dprintk(1, "dqbuf: error getting next done buffer\n");
> > +		goto done;
> > +	}
> > +
> > +	ret = call_qop(q, buf_finish, vb);
> > +	if (ret) {
> > +		dprintk(1, "dqbuf: buffer finish failed\n");
> > +		goto done;
> > +	}
> > +
> > +	switch (vb->state) {
> > +	case VB2_BUF_STATE_DONE:
> > +		dprintk(3, "dqbuf: Returning done buffer\n");
> > +		break;
> > +	case VB2_BUF_STATE_ERROR:
> > +		dprintk(3, "dqbuf: Returning done buffer with errors\n");
> > +		break;
> > +	default:
> > +		dprintk(1, "dqbuf: Invalid buffer state\n");
> > +		ret = -EINVAL;
> > +		goto done;
> > +	}
> > +
> > +	/* Fill buffer information for the userspace */
> > +	__fill_v4l2_buffer(vb, b);
> > +	/* Remove from videobuf queue */
> > +	list_del(&vb->queued_entry);
> > +
> > +	dprintk(1, "dqbuf of buffer %d, with state %d\n",
> > +			vb->v4l2_buf.index, vb->state);
> > +
> > +	vb->state = VB2_BUF_STATE_DEQUEUED;
> > +
> > +done:
> > +	return ret;
> > +}
> > +EXPORT_SYMBOL_GPL(vb2_dqbuf);
> > +
> > +/**
> > + * vb2_streamon - start streaming
> > + * @q:		videobuf2 queue
> > + * @type:	type argument passed from userspace to vidioc_streamon handler
> > + *
> > + * Should be called from vidioc_streamon handler of a driver.
> > + * This function:
> > + * 1) verifies current state
> > + * 2) starts streaming and passes any previously queued buffers to the driver
> > + *
> > + * The return values from this function are intended to be directly returned
> > + * from vidioc_streamon handler in the driver.
> > + */
> > +int vb2_streamon(struct vb2_queue *q, enum v4l2_buf_type type)
> > +{
> > +	struct vb2_buffer *vb;
> > +	int ret = 0;
> > +
> > +
> > +	if (type != q->type) {
> > +		dprintk(1, "streamon: invalid stream type\n");
> > +		return -EINVAL;
> > +	}
> > +
> > +	if (q->streaming) {
> > +		dprintk(1, "streamon: already streaming\n");
> > +		return -EBUSY;
> > +	}
> > +
> > +	/*
> > +	 * Cannot start streaming on an OUTPUT device if no buffers have
> > +	 * been queued yet.
> > +	 */
> > +	if (V4L2_TYPE_IS_OUTPUT(q->type)) {
> > +		if (list_empty(&q->queued_list)) {
> > +			dprintk(1, "streamon: no output buffers queued\n");
> > +			ret = -EINVAL;
> > +			goto done;
> > +		}
> > +	}
> > +
> > +	q->streaming = 1;
> > +
> > +	/*
> > +	 * Let driver notice that streaming state has been enabled.
> > +	 */
> > +	call_qop(q, start_streaming, q);
> > +
> > +	/*
> > +	 * If any buffers were queued before streamon,
> > +	 * we can now pass them to driver for processing.
> > +	 */
> > +	list_for_each_entry(vb, &q->queued_list, queued_entry)
> > +		__enqueue_in_driver(vb);
> > +
> > +	dprintk(3, "Streamon successful\n");
> > +done:
> > +	return ret;
> > +}
> > +EXPORT_SYMBOL_GPL(vb2_streamon);
> > +
> > +/**
> > + * __vb2_queue_cancel() - cancel and stop (pause) streaming
> > + *
> > + * Removes all queued buffers from driver's queue and all buffers queued by
> > + * userspace from videobuf's queue. Returns to state after reqbufs.
> > + */
> > +static void __vb2_queue_cancel(struct vb2_queue *q)
> > +{
> > +	/*
> > +	 * Tell driver to stop all dma transactions and release all queued
> > +	 * buffers
> > +	 */
> > +
> > +	if (q->streaming)
> > +		call_qop(q, stop_streaming, q);
> > +	q->streaming = 0;
> > +
> > +	/*
> > +	 * Remove all buffers from videobuf's list...
> > +	 */
> > +	INIT_LIST_HEAD(&q->queued_list);
> > +	/*
> > +	 * ...and done list; userspace will not receive any buffers it
> > +	 * has not already dequeued before initiating cancel.
> > +	 */
> > +	INIT_LIST_HEAD(&q->done_list);
> > +	wake_up_all(&q->done_wq);
> > +}
> > +
> > +/**
> > + * vb2_streamoff - stop streaming
> > + * @q:		videobuf2 queue
> > + * @type:	type argument passed from userspace to vidioc_streamoff handler
> > + *
> > + * Should be called from vidioc_streamoff handler of a driver.
> > + * This function:
> > + * 1) verifies current state,
> > + * 2) stop streaming and dequeues any queued buffers, including those previously
> > + *    passed to the driver (after waiting for the driver to finish).
> > + *
> > + * This call can be used for pausing playback.
> > + * The return values from this function are intended to be directly returned
> > + * from vidioc_streamoff handler in the driver
> > + */
> > +int vb2_streamoff(struct vb2_queue *q, enum v4l2_buf_type type)
> > +{
> > +	int ret = 0;
> > +
> > +
> > +	if (type != q->type) {
> > +		dprintk(1, "streamoff: invalid stream type\n");
> > +		return -EINVAL;
> > +	}
> > +
> > +	if (!q->streaming) {
> > +		dprintk(1, "streamoff: not streaming\n");
> > +		return -EINVAL;
> > +	}
> > +
> > +	/*
> > +	 * Cancel will pause streaming and remove all buffers from the driver
> > +	 * and videobuf, effectively returning control over them to userspace.
> > +	 */
> > +	__vb2_queue_cancel(q);
> > +
> > +	dprintk(3, "Streamoff successful\n");
> > +	return ret;
> > +}
> > +EXPORT_SYMBOL_GPL(vb2_streamoff);
> > +
> > +/**
> > + * __find_plane_by_off() - find plane associated with the given offset off
> > + */
> > +int __find_plane_by_off(struct vb2_queue *q, unsigned long off,
> > +			unsigned int *_buffer, unsigned int *_plane)
> > +{
> > +	struct vb2_buffer *vb;
> > +	unsigned int buffer, plane;
> > +
> > +	/*
> > +	 * Go over all buffers and their planes, comparing the given offset
> > +	 * with an offset assigned to each plane. If a match is found,
> > +	 * return its buffer and plane numbers.
> > +	 */
> > +	for (buffer = 0; buffer < q->num_buffers; ++buffer) {
> > +		vb = q->bufs[buffer];
> > +
> > +		for (plane = 0; plane < vb->num_planes; ++plane) {
> > +			if (vb->v4l2_planes[plane].m.mem_offset == off) {
> > +				*_buffer = buffer;
> > +				*_plane = plane;
> > +				return 0;
> > +			}
> > +		}
> > +	}
> > +
> > +	return -EINVAL;
> > +}
> > +
> > +/**
> > + * vb2_mmap() - map video buffers into application address space
> > + * @q:		videobuf2 queue
> > + * @vma:	vma passed to the mmap file operation handler in the driver
> > + *
> > + * Should be called from mmap file operation handler of a driver.
> > + * This function maps one plane of one of the available video buffers to
> > + * userspace. To map whole video memory allocated on reqbufs, this function
> > + * has to be called once per each plane per each buffer previously allocated.
> > + *
> > + * When the userspace application calls mmap, it passes to it an offset returned
> > + * to it earlier by the means of vidioc_querybuf handler. That offset acts as
> > + * a "cookie", which is then used to identify the plane to be mapped.
> > + * This function finds a plane with a matching offset and a mapping is performed
> > + * by the means of a provided memory operation.
> > + *
> > + * The return values from this function are intended to be directly returned
> > + * from the mmap handler in driver.
> > + */
> > +int vb2_mmap(struct vb2_queue *q, struct vm_area_struct *vma)
> > +{
> > +	unsigned long off = vma->vm_pgoff << PAGE_SHIFT;
> > +	struct vb2_plane *vb_plane;
> > +	struct vb2_buffer *vb;
> > +	unsigned int buffer, plane;
> > +	int ret = -EINVAL;
> > +
> > +	if (q->memory != V4L2_MEMORY_MMAP) {
> > +		dprintk(1, "Queue is not currently set up for mmap\n");
> > +		return ret;
> > +	}
> > +
> > +	if (V4L2_TYPE_IS_OUTPUT(q->type) &&
> > +	   (!(vma->vm_flags & VM_WRITE) || !(vma->vm_flags & VM_SHARED))) {
> > +		dprintk(1, "Invalid vma flags (need VM_WRITE | VM_SHARED)\n");
> > +		return ret;
> > +	} else if (!(vma->vm_flags & VM_READ) || !(vma->vm_flags & VM_SHARED)) {
> > +		dprintk(1, "Invalid vma flags (need VM_READ | VM_SHARED)\n");
> > +		return ret;
> > +	}
> > +
> > +	/*
> > +	 * Find the plane corresponding to the offset passed by userspace.
> > +	 */
> > +	ret = __find_plane_by_off(q, off, &buffer, &plane);
> > +	if (ret)
> > +		goto end;
> > +
> > +	vb = q->bufs[buffer];
> > +	vb_plane = &vb->planes[plane];
> > +
> > +	if (vb_plane->mapped) {
> > +		dprintk(1, "Plane already mapped\n");
> > +		goto end;
> > +	}
> > +
> > +	if (!mem_ops(q, plane)->mmap) {
> > +		dprintk(1, "mmap not supported\n");
> > +		goto end;
> > +	}
> > +
> > +	ret = mem_ops(q, plane)->mmap(vb_plane->mem_priv, vma);
> > +	if (ret)
> > +		goto end;
> > +
> > +	vb_plane->mapped = 1;
> > +	vb->num_planes_mapped++;
> > +
> > +	dprintk(3, "Buffer %d, plane %d successfully mapped\n", buffer, plane);
> > +end:
> > +	return ret;
> > +}
> > +EXPORT_SYMBOL_GPL(vb2_mmap);
> > +
> > +/**
> > + * vb2_has_consumers() - return true if the userspace is waiting for a buffer
> > + * @q:		videobuf2 queue
> > + *
> > + * This function returns true if a userspace application is waiting for a buffer
> > + * to be ready to dequeue (on which a hardware operation has been finished).
> > + */
> > +bool vb2_has_consumers(struct vb2_queue *q)
> > +{
> > +	return waitqueue_active(&q->done_wq);
> > +}
> > +EXPORT_SYMBOL_GPL(vb2_has_consumers);
> > +
> > +/**
> > + * vb2_poll() - implements poll userspace operation
> > + * @q:		videobuf2 queue
> > + * @file:	file argument passed to the poll file operation handler
> > + * @wait:	wait argument passed to the poll file operation handler
> > + *
> > + * This function implements poll file operation handler for a driver.
> > + * For CAPTURE queues, if a buffer is ready to be dequeued, the userspace will
> > + * be informed that the file descriptor of a video device is available for
> > + * reading.
> > + * For OUTPUT queues, if a buffer is ready to be dequeued, the file descriptor
> > + * will be reported as available for writing.
> > + *
> > + * The return values from this function are intended to be directly returned
> > + * from poll handler in driver.
> > + */
> > +unsigned int vb2_poll(struct vb2_queue *q, struct file *file, poll_table *wait)
> > +{
> > +	unsigned long flags = 0;
> > +	unsigned int ret = 0;
> > +	struct vb2_buffer *vb = NULL;
> > +
> > +
> > +	/*
> > +	 * There is nothing to wait for if no buffers have already been queued.
> > +	 */
> > +	if (list_empty(&q->queued_list)) {
> > +		ret = POLLERR;
> > +		goto end;
> 
> Just do return POLLERR;
> 
> > +	}
> > +
> > +	poll_wait(file, &q->done_wq, wait);
> > +
> > +	/*
> > +	 * Take first buffer available for dequeuing.
> > +	 */
> > +	spin_lock_irqsave(&q->done_lock, flags);
> > +	if (!list_empty(&q->done_list))
> > +		vb = list_first_entry(&q->done_list, struct vb2_buffer,
> > +					done_entry);
> > +	spin_unlock_irqrestore(&q->done_lock, flags);
> > +
> > +	if (!vb)
> > +		goto end;
> 
> Just do return 0;
> 
> > +
> > +	if (vb->state == VB2_BUF_STATE_DONE
> > +			|| vb->state == VB2_BUF_STATE_ERROR) {
> > +		if (V4L2_TYPE_IS_OUTPUT(q->type))
> > +			ret = POLLOUT | POLLWRNORM;
> > +		else
> > +			ret = POLLIN | POLLRDNORM;
> 
> Again just return.
> 
> > +	}
> > +end:
> > +	return ret;
> 
> return 0;
> 
> > +}
> > +EXPORT_SYMBOL_GPL(vb2_poll);
> > +
> > +/**
> > + * vb2_queue_init() - initialize a videobuf2 queue
> > + * @q:		videobuf2 queue; this structure should be allocated in driver
> > + * @ops:	driver-specific callbacks
> > + * @alloc_ctx:	memory handler/allocator-specific context to be used;
> > + *		the given context will be used for memory allocation on all
> > + *		planes and buffers; it is possible to assign different contexts
> > + *		per plane, use vb2_set_alloc_ctx() for that
> > + * @type:	queue type
> > + * @drv_priv:	driver private data, may be NULL; it can be used by driver in
> > + *		driver-specific callbacks when issued
> > + */
> > +int vb2_queue_init(struct vb2_queue *q, const struct vb2_ops *ops,
> > +			const struct vb2_alloc_ctx *alloc_ctx,
> > +			enum v4l2_buf_type type, void *drv_priv)
> > +{
> > +	unsigned int i;
> > +
> > +	BUG_ON(!q);
> > +	BUG_ON(!ops);
> > +	BUG_ON(!ops->queue_negotiate);
> > +	BUG_ON(!ops->plane_setup);
> > +	BUG_ON(!ops->buf_queue);
> > +
> > +	BUG_ON(!alloc_ctx);
> > +	BUG_ON(!alloc_ctx->mem_ops);
> > +
> > +	memset(q, 0, sizeof *q);
> > +	q->ops = ops;
> > +
> > +	for (i = 0; i < VIDEO_MAX_PLANES; ++i)
> > +		q->alloc_ctx[i] = alloc_ctx;
> > +
> > +	q->type = type;
> > +	q->drv_priv = drv_priv;
> > +
> > +	INIT_LIST_HEAD(&q->queued_list);
> > +	INIT_LIST_HEAD(&q->done_list);
> > +	spin_lock_init(&q->done_lock);
> > +	init_waitqueue_head(&q->done_wq);
> > +
> > +	return 0;
> > +}
> > +EXPORT_SYMBOL_GPL(vb2_queue_init);
> > +
> > +/**
> > + * vb2_queue_release() - stop streaming, release the queue and free memory
> > + * @q:		videobuf2 queue
> > + *
> > + * This function stops streaming and performs necessary clean ups, including
> > + * freeing video buffer memory. The driver is responsible for freeing
> > + * the vb2_queue structure itself.
> > + */
> > +void vb2_queue_release(struct vb2_queue *q)
> > +{
> > +	__vb2_queue_cancel(q);
> > +	__vb2_queue_free(q);
> > +}
> > +EXPORT_SYMBOL_GPL(vb2_queue_release);
> > +
> > +MODULE_DESCRIPTION("Driver helper framework for Video for Linux 2");
> > +MODULE_AUTHOR("Pawel Osciak");
> > +MODULE_LICENSE("GPL");
> > diff --git a/include/media/videobuf2-core.h b/include/media/videobuf2-core.h
> > new file mode 100644
> > index 0000000..98bc743
> > --- /dev/null
> > +++ b/include/media/videobuf2-core.h
> > @@ -0,0 +1,373 @@
> > +/*
> > + * videobuf2-core.h - V4L2 driver helper framework
> > + *
> > + * Copyright (C) 2010 Samsung Electronics
> > + *
> > + * Author: Pawel Osciak <p.osciak@samsung.com>
> > + *
> > + * This program is free software; you can redistribute it and/or modify
> > + * it under the terms of the GNU General Public License as published by
> > + * the Free Software Foundation.
> > + */
> > +#ifndef _MEDIA_VIDEOBUF2_CORE_H
> > +#define _MEDIA_VIDEOBUF2_CORE_H
> > +
> > +#include <linux/mutex.h>
> > +#include <linux/mm_types.h>
> > +#include <linux/videodev2.h>
> > +#include <linux/poll.h>
> > +
> > +struct vb2_alloc_ctx;
> > +
> > +/**
> > + * struct vb2_mem_ops - memory handling/memory allocator operations
> > + * @alloc:	allocate video memory and, optionally, allocator private data,
> > + *		return NULL on failure or a pointer to allocator private,
> > + *		per-buffer data on success, NULL on failure; the returned
> > + *		private structure will then be passed as buf_priv argument
> > + *		to other ops in this structure
> > + * @put:	inform the allocator that the buffer will no longer be used;
> > + *		usually will result in the allocator freeing the buffer (if
> > + *		no other users of this buffer are present); the buf_priv
> > + *		argument is the allocator private per-buffer structure
> > + *		previously returned from the alloc callback
> > + * @get_userptr: acquire userspace memory for a hardware operation; used for
> > + *		 USERPTR memory types; vaddr is the address passed to the
> > + *		 videobuf layer when queuing a video buffer of USERPTR type;
> > + *		 should return an allocator private per-buffer structure
> > + *		 associated with the buffer on success, NULL on failure;
> > + *		 the returned private structure will then be passed as buf_priv
> > + *		 argument to other ops in this structure
> > + * @put_userptr: inform the allocator that a USERPTR buffer will no longer
> > + *		 be used
> 
> 'get' and 'put' imply reference counting. However, I don't believe that's the
> case for USERPTR. If I am right, then I would like to see different names for
> these callbacks.
> 
> > + * @vaddr:	return a kernel virtual address to a given memory buffer
> > + *		associated with the passed private structure or NULL if no
> > + *		such mapping exists
> > + * @paddr:	return a physical address to a given memory buffer associated
> > + *		with the passed private structure or NULL if not available
> 
> Outdated comment, replaced by cookie.
> 
> > + * @num_users:	return the current number of users of a memory buffer;
> > + *		return 1 if the videobuf layer (or actually the driver using
> > + *		it) is the only user
> > + * @mmap:	setup a userspace mapping for a given memory buffer under
> > + *		the provided virtual memory region
> 
> Mention that mmap increases the refcount for the memory (it's effectively
> a 'get', the counterpart of the 'put' callback).
> 
> Perhaps mmap should be renamed get_mmap and put renamed to put_mmap?
> 
> > + *
> > + * Required ops for USERPTR types: get_userptr, put_userptr.
> > + * Required ops for MMAP types: alloc, put, num_users, mmap.
> > + */
> > +struct vb2_mem_ops {
> > +	void		*(*alloc)(const struct vb2_alloc_ctx *alloc_ctx,
> > +					unsigned long size);
> > +	void		(*put)(void *buf_priv);
> > +
> > +	void		*(*get_userptr)(unsigned long vaddr,
> > +						unsigned long size);
> > +	void		(*put_userptr)(void *buf_priv);
> > +
> > +	void		*(*vaddr)(void *buf_priv);
> > +	void		*(*cookie)(void *buf_priv);
> > +
> > +	unsigned int	(*num_users)(void *buf_priv);
> > +
> > +	int		(*mmap)(void *buf_priv, struct vm_area_struct *vma);
> > +};
> > +
> > +/**
> > + * struct vb2_alloc_ctx - allocator/memory handler-specific context
> > + * @mem_ops:	memory operations used by the current context
> > + *
> > + * This structure is passed to the alloc() call and can be used to store
> > + * additional allocator private data. In such case it can be embedded in
> > + * a allocator private structure as its first member.
> > + * In more complicated cases, separate contexts can be assigned to each plane,
> > + * if required. This would allow separate memory allocation/handling strategies
> > + * for each plane, which is useful for drivers requiring different memory types
> > + * and/or handling for each plane.
> > + *
> > + * See videobuf2-vmalloc.c and videobuf2-dma-coherent.c for example usage.
> > + */
> > +struct vb2_alloc_ctx {
> > +	const struct vb2_mem_ops	*mem_ops;
> > +};
> > +
> > +struct vb2_plane {
> > +	void			*mem_priv;
> > +	int			mapped:1;
> > +};
> > +
> > +/**
> > + * enum vb2_buffer_state - current video buffer state
> > + * @VB2_BUF_STATE_DEQUEUED:	buffer under userspace control
> > + * @VB2_BUF_STATE_QUEUED:	buffer queued in videobuf, but not in driver
> > + * @VB2_BUF_STATE_ACTIVE:	buffer queued in driver and possibly used
> > + *				in a hardware operation
> > + * @VB2_BUF_STATE_DONE:		buffer returned from driver to videobuf, but
> > + *				not yet dequeued to userspace
> > + * @VB2_BUF_STATE_ERROR:	same as above, but the operation on the buffer
> > + *				has ended with an error, which will be reported
> > + *				to the userspace when it is dequeued
> > + */
> > +enum vb2_buffer_state {
> > +	VB2_BUF_STATE_DEQUEUED,
> > +	VB2_BUF_STATE_QUEUED,
> > +	VB2_BUF_STATE_ACTIVE,
> > +	VB2_BUF_STATE_DONE,
> > +	VB2_BUF_STATE_ERROR,
> > +};
> > +
> > +struct vb2_queue;
> > +
> > +/**
> > + * struct vb2_buffer - represents a video buffer
> > + * @v4l2_buf:		struct v4l2_buffer associated with this buffer; can
> > + *			be read by the driver and relevant entries can be
> > + *			changed by the driver in case of CAPTURE types
> > + *			(such as timestamp)
> > + * @v4l2_planes:	struct v4l2_planes associated with this buffer; can
> > + *			be read by the driver and relevant entries can be
> > + *			changed by the driver in case of CAPTURE types
> > + *			(such as bytesused); NOTE that even for single-planar
> > + *			types, the v4l2_planes[0] struct should be used
> > + *			instead of v4l2_buf for filling bytesused - drivers
> > + *			should use the vb2_set_plane_payload() function for that
> > + * @vb2_queue:		the queue to which this driver belongs
> > + * @drv_entry:		list entry to be used by driver for storing the buffer
> > + * @num_planes:		number of planes in the buffer
> > + *			on an internal driver queue
> > + * @state:		current buffer state; do not change
> > + * @queued_entry:	entry on the queued buffers list, which holds all
> > + *			buffers queued from userspace
> > + * @done_entry:		entry on the list that stores all buffers ready to
> > + *			be dequeued to userspace
> > + * @planes:		private per-plane information; do not change
> > + * @num_planes_mapped:	number of mapped planes; do not change
> > + */
> > +struct vb2_buffer {
> > +	struct v4l2_buffer	v4l2_buf;
> > +	struct v4l2_plane	v4l2_planes[VIDEO_MAX_PLANES];
> > +
> > +	struct vb2_queue	*vb2_queue;
> > +
> > +	unsigned int		num_planes;
> > +
> > +/* Private: internal use only */
> > +	enum vb2_buffer_state	state;
> > +
> > +	struct list_head	queued_entry;
> > +	struct list_head	done_entry;
> > +
> > +	struct vb2_plane	planes[VIDEO_MAX_PLANES];
> > +	unsigned int		num_planes_mapped;
> > +};
> > +
> > +/**
> > + * struct vb2_ops - driver-specific callbacks
> > + *
> > + * @queue_negotiate:	called from a VIDIOC_REQBUFS handler, before
> > + *			memory allocation; driver should return the required
> > + *			number of buffers in num_buffers and the required number
> > + *			of planes per buffer in num_planes
> > + * @plane_setup:	called before memory allocation num_planes times;
> > + *			driver should return the required size of plane number
> > + *			plane_no
> > + * @lock:		aquire all locks taken before any other calls to vb2;
> 
> typo: acquire. Actually, I'd probably say 'reacquire'.
> 
> > + *			required after sleeing in poll_wait function
> 
> typo: sleeing -> sleeping
> 
> > + * @unlock:		release any locks taken before calling vb2 function;
> > + *			required for a safe to call poll_wait function
> 
> I would swap the unlock and lock comments since unlock will be called before
> lock. Some more background info might help as well.
> 
> > + * @buf_alloc:		called to allocate a struct vb2_buffer; driver usually
> > + *			embeds it in its own custom buffer structure; returns
> > + *			a pointer to vb2_buffer or NULL if failed; if not
> > + *			provided kmalloc(sizeof(struct vb2_buffer, GFP_KERNEL)
> > + *			is used
> > + * @buf_free:		called to free the structure allocated by @buf_alloc;
> > + *			if not provided kfree(vb) is used
> > + * @buf_init:		called once after allocating a buffer (in MMAP case)
> > + *			or after acquiring a new USERPTR buffer; drivers may
> > + *			perform additional buffer-related initialization;
> > + *			initialization failure (return != 0) will prevent
> > + *			queue setup from completing successfully; optional
> > + * @buf_prepare:	called every time the buffer is queued from userspace;
> > + *			drivers may perform any initialization required before
> > + *			each hardware operation in this callback;
> > + *			if an error is returned, the buffer will not be queued
> > + *			in driver; optional
> > + * @buf_finish:		called before every dequeue of the buffer back to
> > + *			userspace; drivers may perform any operations required
> > + *			before userspace accesses the buffer; optional
> > + * @buf_cleanup:	called once before the buffer is freed; drivers may
> > + *			perform any additional cleanup; optional
> > + * @start_streaming:	called once before entering 'streaming' state; enables
> > + *			driver to recieve buffers over buf_queue() callback
> > + * @stop_streaming:	called when 'streaming' state must be disabled; driver
> > + *			should stop any dma transactions or wait until they
> > + *			finish and give back all buffers it got from buf_queue()
> > + *			callback
> > + * @buf_queue:		passes buffer vb to the driver; driver may start
> > + *			hardware operation on this buffer; driver should give
> > + *			the buffer back by calling vb2_buffer_done() function
> > + */
> > +struct vb2_ops {
> > +	int (*queue_negotiate)(struct vb2_queue *q, unsigned int *num_buffers,
> > +				unsigned int *num_planes);
> > +	int (*plane_setup)(struct vb2_queue *q,
> > +			   unsigned int plane_no, unsigned long *plane_size);
> > +
> > +	void (*lock)(struct vb2_queue *q);
> > +	void (*unlock)(struct vb2_queue *q);
> > +
> > +	struct vb2_buffer *(*buf_alloc)(struct vb2_queue *q);
> > +	void (*buf_free)(struct vb2_queue *q, struct vb2_buffer *vb);
> > +	int (*buf_init)(struct vb2_buffer *vb);
> > +	int (*buf_prepare)(struct vb2_buffer *vb);
> > +	int (*buf_finish)(struct vb2_buffer *vb);
> > +	void (*buf_cleanup)(struct vb2_buffer *vb);
> > +
> > +	int (*start_streaming)(struct vb2_queue *q);
> > +	int (*stop_streaming)(struct vb2_queue *q);
> > +
> > +	void (*buf_queue)(struct vb2_buffer *vb);
> > +};
> > +
> > +/**
> > + * struct vb2_queue - a videobuf queue
> > + *
> > + * @type:	current queue type
> > + * @memory:	current memory type used
> > + * @drv_priv:	driver private data, passed on vb2_queue_init
> > + * @bufs:	videobuf buffer structures
> > + * @num_buffers: number of allocated/used buffers
> > + * @vb_lock:	for ioctl handler and queue state changes synchronization
> > + * @queued_list: list of buffers currently queued from userspace
> > + * @done_list:	list of buffers ready to be dequeued to userspace
> > + * @done_lock:	lock to protect done_list list
> > + * @done_wq:	waitqueue for processes waiting for buffers ready to be dequeued
> > + * @ops:	driver-specific callbacks
> > + * @alloc_ctx:	memory type/allocator-specific callbacks
> > + * @streaming:	current streaming state
> > + * @userptr_supported: true if queue supports USERPTR types
> > + * @mmap_supported: true if queue supports MMAP types
> > + */
> > +struct vb2_queue {
> > +	enum v4l2_buf_type		type;
> > +	enum v4l2_memory		memory;
> > +	void				*drv_priv;
> > +
> > +/* private: internal use only */
> > +	struct vb2_buffer		*bufs[VIDEO_MAX_FRAME];
> > +	unsigned int			num_buffers;
> > +
> > +	struct list_head		queued_list;
> > +
> > +	struct list_head		done_list;
> > +	spinlock_t			done_lock;
> > +	wait_queue_head_t		done_wq;
> > +
> > +	const struct vb2_ops		*ops;
> > +	const struct vb2_alloc_ctx	*alloc_ctx[VIDEO_MAX_PLANES];
> > +
> > +	int				streaming:1;
> > +	int				userptr_supported:1;
> > +	int				mmap_supported:1;
> > +};
> > +
> > +void *vb2_plane_vaddr(struct vb2_buffer *vb, unsigned int plane_no);
> > +void *vb2_plane_cookie(struct vb2_buffer *vb, unsigned int plane_no);
> > +
> > +void vb2_buffer_done(struct vb2_buffer *vb, enum vb2_buffer_state state);
> > +bool vb2_has_consumers(struct vb2_queue *q);
> > +
> > +int vb2_querybuf(struct vb2_queue *q, struct v4l2_buffer *b);
> > +int vb2_reqbufs(struct vb2_queue *q, struct v4l2_requestbuffers *req);
> > +
> > +int vb2_queue_init(struct vb2_queue *q, const struct vb2_ops *ops,
> > +			const struct vb2_alloc_ctx *alloc_ctx,
> > +			enum v4l2_buf_type type, void *drv_priv);
> > +void vb2_queue_release(struct vb2_queue *q);
> > +
> > +int vb2_qbuf(struct vb2_queue *q, struct v4l2_buffer *b);
> > +int vb2_dqbuf(struct vb2_queue *q, struct v4l2_buffer *b, bool nonblocking);
> > +
> > +int vb2_streamon(struct vb2_queue *q, enum v4l2_buf_type type);
> > +int vb2_streamoff(struct vb2_queue *q, enum v4l2_buf_type type);
> > +
> > +int vb2_mmap(struct vb2_queue *q, struct vm_area_struct *vma);
> > +unsigned int vb2_poll(struct vb2_queue *q, struct file *file, poll_table *wait);
> > +
> > +/**
> > + * vb2_is_streaming() - return streaming status of the queue
> > + * @q:		videobuf queue
> > + */
> > +static inline bool vb2_is_streaming(struct vb2_queue *q)
> > +{
> > +	return q->streaming;
> > +}
> > +
> > +/**
> > + * vb2_get_drv_priv() - return driver private data associated with the queue
> > + * @q:		videobuf queue
> > + */
> > +static inline void *vb2_get_drv_priv(struct vb2_queue *q)
> > +{
> > +	return q->drv_priv;
> > +}
> > +
> > +/**
> > + * vb2_set_plane_payload() - set bytesused for the plane plane_no
> > + * @vb:		buffer for which plane payload should be set
> > + * @plane_no:	plane number for which payload should be set
> > + * @size:	payload in bytes
> > + */
> > +static inline void vb2_set_plane_payload(struct vb2_buffer *vb,
> > +				 unsigned int plane_no, unsigned long size)
> > +{
> > +	vb->v4l2_planes[plane_no].bytesused = size;
> > +}
> > +
> > +/**
> > + * vb2_get_plane_payload() - set bytesused for the plane plane_no
> > + * @vb:		buffer for which plane payload should be set
> > + * @plane_no:	plane number for which payload should be set
> > + * @size:	payload in bytes
> > + */
> > +static inline unsigned long vb2_get_plane_payload(struct vb2_buffer *vb,
> > +				 unsigned int plane_no)
> > +{
> > +	return vb->v4l2_planes[plane_no].bytesused;
> > +}
> > +
> > +/**
> > + * vb2_plane_size() - return plane size in bytes
> > + * @vb:		buffer for which plane size should be returned
> > + * @plane_no:	plane number for which size should be returned
> > + */
> > +static inline unsigned long
> > +vb2_plane_size(struct vb2_buffer *vb, unsigned int plane_no)
> > +{
> > +	if (plane_no < vb->num_planes)
> > +		return vb->v4l2_planes[plane_no].length;
> > +	else
> 
> else is not needed.
> 
> > +		return 0;
> > +}
> > +
> > +/**
> > + * vb2_set_alloc_ctx() - use to assign a allocator context for a plane
> > + * @q:		videobuf queue
> > + * @alloc_ctx:	allocator context to be assigned
> > + * @plane_no:	plane number to which the context is to be assigned
> > + *
> > + * This function can be used to assign additional allocator contexts
> > + * on a per-plane basis, if a driver requires such feature.
> > + * When a driver passes an allocator context to the vb2_queue_init call,
> > + * it is initially assigned to all planes. Driver can then use this call
> > + * to selectively assign additional contexts to particular planes.
> > + * A context assigned to plane_no will be used for memory operations
> > + * on plane number plane_no for all buffers.
> > + */
> > +static inline void
> > +vb2_set_alloc_ctx(struct vb2_queue *q, struct vb2_alloc_ctx *alloc_ctx,
> > +			unsigned int plane_no)
> > +{
> > +	if (plane_no < VIDEO_MAX_PLANES)
> > +		q->alloc_ctx[plane_no] = alloc_ctx;
> > +}
> > +
> > +#endif /* _MEDIA_VIDEOBUF2_CORE_H */
> > 
> 
> Great job! Thanks for all the hard work!

Ditto!

R,
Andy

> 	Hans
> 



