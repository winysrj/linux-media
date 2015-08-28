Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud3.xs4all.net ([194.109.24.26]:37548 "EHLO
	lb2-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752332AbbH1Nvi (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 28 Aug 2015 09:51:38 -0400
Message-ID: <55E06734.9010009@xs4all.nl>
Date: Fri, 28 Aug 2015 15:50:44 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Junghak Sung <jh1009.sung@samsung.com>,
	linux-media@vger.kernel.org, mchehab@osg.samsung.com,
	laurent.pinchart@ideasonboard.com, sakari.ailus@iki.fi,
	pawel@osciak.com
CC: inki.dae@samsung.com, sw0312.kim@samsung.com,
	nenggun.kim@samsung.com, sangbae90.lee@samsung.com,
	rany.kwon@samsung.com
Subject: Re: [RFC PATCH v3 5/5] media: videobuf2: Divide videobuf2-core into
 2 parts
References: <1440590372-2377-1-git-send-email-jh1009.sung@samsung.com> <1440590372-2377-6-git-send-email-jh1009.sung@samsung.com>
In-Reply-To: <1440590372-2377-6-git-send-email-jh1009.sung@samsung.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 08/26/2015 01:59 PM, Junghak Sung wrote:
> Divide videobuf2-core into core part and v4l2-specific part
> - core part: videobuf2 core related with buffer management & memory
>  allocation
> - v4l2-specific part: v4l2-specific stuff
> 
> Signed-off-by: Junghak Sung <jh1009.sung@samsung.com>
> Signed-off-by: Geunyoung Kim <nenggun.kim@samsung.com>
> Acked-by: Seung-Woo Kim <sw0312.kim@samsung.com>
> Acked-by: Inki Dae <inki.dae@samsung.com>

As Mauro also noted, this patch is very hard to review. I think you can reduce
the changes to some extent: the creation of the videobuf2-internal.h header
can certainly be done first.

After that you can make a patch that just moves functions from core.c to v4l2.c.
E.g. a function like vb2_ioctl_prepare_buf() isn't changed, just moved. And there
are lots of those.

Patches that just move things around without doing any functional changes are
easy to review and they reduce the size of the patch that actually does make
functional changes and thus needs a much more careful review.

There may well be more ways of splitting up this large patch, but I think the
two suggestions I made above will already go a long way to making this more
manageable.

Regards,

	Hans

> ---
>  drivers/media/v4l2-core/videobuf2-core.c     | 1933 +++-----------------------
>  drivers/media/v4l2-core/videobuf2-internal.h |  184 +++
>  drivers/media/v4l2-core/videobuf2-v4l2.c     | 1640 ++++++++++++++++++++++
>  include/media/videobuf2-core.h               |  157 +--
>  include/media/videobuf2-v4l2.h               |  116 ++
>  include/trace/events/v4l2.h                  |    4 +-
>  6 files changed, 2154 insertions(+), 1880 deletions(-)
>  create mode 100644 drivers/media/v4l2-core/videobuf2-internal.h
> 
> diff --git a/drivers/media/v4l2-core/videobuf2-core.c b/drivers/media/v4l2-core/videobuf2-core.c
> index 9266d50..2cd4241 100644
> --- a/drivers/media/v4l2-core/videobuf2-core.c
> +++ b/drivers/media/v4l2-core/videobuf2-core.c
> @@ -6,9 +6,6 @@
>   * Author: Pawel Osciak <pawel@osciak.com>
>   *	   Marek Szyprowski <m.szyprowski@samsung.com>
>   *
> - * The vb2_thread implementation was based on code from videobuf-dvb.c:
> - *	(c) 2004 Gerd Knorr <kraxel@bytesex.org> [SUSE Labs]
> - *
>   * This program is free software; you can redistribute it and/or modify
>   * it under the terms of the GNU General Public License as published by
>   * the Free Software Foundation.
> @@ -24,164 +21,14 @@
>  #include <linux/freezer.h>
>  #include <linux/kthread.h>
>  
> -#include <media/v4l2-dev.h>
> -#include <media/v4l2-fh.h>
> -#include <media/v4l2-event.h>
> -#include <media/v4l2-common.h>
> -#include <media/videobuf2-v4l2.h>
> +#include <media/videobuf2-core.h>
> +#include "videobuf2-internal.h"
>  
>  #include <trace/events/v4l2.h>
>  
> -static int debug;
> -module_param(debug, int, 0644);
> -
> -#define dprintk(level, fmt, arg...)					\
> -	do {								\
> -		if (debug >= level)					\
> -			pr_info("vb2: %s: " fmt, __func__, ## arg);	\
> -	} while (0)
> -
> -#ifdef CONFIG_VIDEO_ADV_DEBUG
> -
> -/*
> - * If advanced debugging is on, then count how often each op is called
> - * successfully, which can either be per-buffer or per-queue.
> - *
> - * This makes it easy to check that the 'init' and 'cleanup'
> - * (and variations thereof) stay balanced.
> - */
> -
> -#define log_memop(vb, op)						\
> -	dprintk(2, "call_memop(%p, %d, %s)%s\n",			\
> -		(vb)->vb2_queue, (vb)->index, #op,			\
> -		(vb)->vb2_queue->mem_ops->op ? "" : " (nop)")
> -
> -#define call_memop(vb, op, args...)					\
> -({									\
> -	struct vb2_queue *_q = (vb)->vb2_queue;				\
> -	int err;							\
> -									\
> -	log_memop(vb, op);						\
> -	err = _q->mem_ops->op ? _q->mem_ops->op(args) : 0;		\
> -	if (!err)							\
> -		(vb)->cnt_mem_ ## op++;					\
> -	err;								\
> -})
> -
> -#define call_ptr_memop(vb, op, args...)					\
> -({									\
> -	struct vb2_queue *_q = (vb)->vb2_queue;				\
> -	void *ptr;							\
> -									\
> -	log_memop(vb, op);						\
> -	ptr = _q->mem_ops->op ? _q->mem_ops->op(args) : NULL;		\
> -	if (!IS_ERR_OR_NULL(ptr))					\
> -		(vb)->cnt_mem_ ## op++;					\
> -	ptr;								\
> -})
> -
> -#define call_void_memop(vb, op, args...)				\
> -({									\
> -	struct vb2_queue *_q = (vb)->vb2_queue;				\
> -									\
> -	log_memop(vb, op);						\
> -	if (_q->mem_ops->op)						\
> -		_q->mem_ops->op(args);					\
> -	(vb)->cnt_mem_ ## op++;						\
> -})
> -
> -#define log_qop(q, op)							\
> -	dprintk(2, "call_qop(%p, %s)%s\n", q, #op,			\
> -		(q)->ops->op ? "" : " (nop)")
> -
> -#define call_qop(q, op, args...)					\
> -({									\
> -	int err;							\
> -									\
> -	log_qop(q, op);							\
> -	err = (q)->ops->op ? (q)->ops->op(args) : 0;			\
> -	if (!err)							\
> -		(q)->cnt_ ## op++;					\
> -	err;								\
> -})
> -
> -#define call_void_qop(q, op, args...)					\
> -({									\
> -	log_qop(q, op);							\
> -	if ((q)->ops->op)						\
> -		(q)->ops->op(args);					\
> -	(q)->cnt_ ## op++;						\
> -})
> -
> -#define log_vb_qop(vb, op, args...)					\
> -	dprintk(2, "call_vb_qop(%p, %d, %s)%s\n",			\
> -		(vb)->vb2_queue, (vb)->index, #op,			\
> -		(vb)->vb2_queue->ops->op ? "" : " (nop)")
> -
> -#define call_vb_qop(vb, op, args...)					\
> -({									\
> -	int err;							\
> -									\
> -	log_vb_qop(vb, op);						\
> -	err = (vb)->vb2_queue->ops->op ?				\
> -		(vb)->vb2_queue->ops->op(args) : 0;			\
> -	if (!err)							\
> -		(vb)->cnt_ ## op++;					\
> -	err;								\
> -})
> -
> -#define call_void_vb_qop(vb, op, args...)				\
> -({									\
> -	log_vb_qop(vb, op);						\
> -	if ((vb)->vb2_queue->ops->op)					\
> -		(vb)->vb2_queue->ops->op(args);				\
> -	(vb)->cnt_ ## op++;						\
> -})
> -
> -#else
> -
> -#define call_memop(vb, op, args...)					\
> -	((vb)->vb2_queue->mem_ops->op ?					\
> -		(vb)->vb2_queue->mem_ops->op(args) : 0)
> -
> -#define call_ptr_memop(vb, op, args...)					\
> -	((vb)->vb2_queue->mem_ops->op ?					\
> -		(vb)->vb2_queue->mem_ops->op(args) : NULL)
> -
> -#define call_void_memop(vb, op, args...)				\
> -	do {								\
> -		if ((vb)->vb2_queue->mem_ops->op)			\
> -			(vb)->vb2_queue->mem_ops->op(args);		\
> -	} while (0)
> -
> -#define call_qop(q, op, args...)					\
> -	((q)->ops->op ? (q)->ops->op(args) : 0)
> -
> -#define call_void_qop(q, op, args...)					\
> -	do {								\
> -		if ((q)->ops->op)					\
> -			(q)->ops->op(args);				\
> -	} while (0)
> -
> -#define call_vb_qop(vb, op, args...)					\
> -	((vb)->vb2_queue->ops->op ? (vb)->vb2_queue->ops->op(args) : 0)
> -
> -#define call_void_vb_qop(vb, op, args...)				\
> -	do {								\
> -		if ((vb)->vb2_queue->ops->op)				\
> -			(vb)->vb2_queue->ops->op(args);			\
> -	} while (0)
> -
> -#endif
> -
> -/* Flags that are set by the vb2 core */
> -#define V4L2_BUFFER_MASK_FLAGS	(V4L2_BUF_FLAG_MAPPED | V4L2_BUF_FLAG_QUEUED | \
> -				 V4L2_BUF_FLAG_DONE | V4L2_BUF_FLAG_ERROR | \
> -				 V4L2_BUF_FLAG_PREPARED | \
> -				 V4L2_BUF_FLAG_TIMESTAMP_MASK)
> -/* Output buffer flags that should be passed on to the driver */
> -#define V4L2_BUFFER_OUT_FLAGS	(V4L2_BUF_FLAG_PFRAME | V4L2_BUF_FLAG_BFRAME | \
> -				 V4L2_BUF_FLAG_KEYFRAME | V4L2_BUF_FLAG_TIMECODE)
> +int vb2_debug;
> +module_param_named(debug, vb2_debug, int, 0644);
> +EXPORT_SYMBOL_GPL(vb2_debug);
>  
>  static void __vb2_queue_cancel(struct vb2_queue *q);
>  static void __enqueue_in_driver(struct vb2_buffer *vb);
> @@ -193,7 +40,7 @@ static int __vb2_buf_mem_alloc(struct vb2_buffer *vb)
>  {
>  	struct vb2_queue *q = vb->vb2_queue;
>  	enum dma_data_direction dma_dir =
> -		V4L2_TYPE_IS_OUTPUT(q->type) ? DMA_TO_DEVICE : DMA_FROM_DEVICE;
> +			q->is_output ? DMA_TO_DEVICE : DMA_FROM_DEVICE;
>  	void *mem_priv;
>  	int plane;
>  
> @@ -249,7 +96,8 @@ static void __vb2_buf_userptr_put(struct vb2_buffer *vb)
>  
>  	for (plane = 0; plane < vb->num_planes; ++plane) {
>  		if (vb->planes[plane].mem_priv)
> -			call_void_memop(vb, put_userptr, vb->planes[plane].mem_priv);
> +			call_void_memop(vb, put_userptr,
> +					vb->planes[plane].mem_priv);
>  		vb->planes[plane].mem_priv = NULL;
>  	}
>  }
> @@ -347,7 +195,7 @@ static void __setup_offsets(struct vb2_queue *q, unsigned int n)
>   *
>   * Returns the number of buffers successfully allocated.
>   */
> -static int __vb2_queue_alloc(struct vb2_queue *q, enum v4l2_memory memory,
> +static int __vb2_queue_alloc(struct vb2_queue *q, unsigned int memory,
>  			unsigned int num_buffers, unsigned int num_planes)
>  {
>  	unsigned int buffer;
> @@ -370,7 +218,7 @@ static int __vb2_queue_alloc(struct vb2_queue *q, enum v4l2_memory memory,
>  		vb->memory = memory;
>  
>  		/* Allocate video buffer memory for the MMAP type */
> -		if (memory == V4L2_MEMORY_MMAP) {
> +		if (memory == VB2_MEMORY_MMAP) {
>  			ret = __vb2_buf_mem_alloc(vb);
>  			if (ret) {
>  				dprintk(1, "failed allocating memory for "
> @@ -397,7 +245,7 @@ static int __vb2_queue_alloc(struct vb2_queue *q, enum v4l2_memory memory,
>  	}
>  
>  	__setup_lengths(q, buffer);
> -	if (memory == V4L2_MEMORY_MMAP)
> +	if (memory == VB2_MEMORY_MMAP)
>  		__setup_offsets(q, buffer);
>  
>  	dprintk(1, "allocated %d buffers, %d plane(s) each\n",
> @@ -421,9 +269,9 @@ static void __vb2_free_mem(struct vb2_queue *q, unsigned int buffers)
>  			continue;
>  
>  		/* Free MMAP buffers or release USERPTR buffers */
> -		if (q->memory == V4L2_MEMORY_MMAP)
> +		if (q->memory == VB2_MEMORY_MMAP)
>  			__vb2_buf_mem_free(vb);
> -		else if (q->memory == V4L2_MEMORY_DMABUF)
> +		else if (q->memory == VB2_MEMORY_DMABUF)
>  			__vb2_buf_dmabuf_put(vb);
>  		else
>  			__vb2_buf_userptr_put(vb);
> @@ -547,75 +395,10 @@ static int __vb2_queue_free(struct vb2_queue *q, unsigned int buffers)
>  }
>  
>  /**
> - * __verify_planes_array() - verify that the planes array passed in struct
> - * v4l2_buffer from userspace can be safely used
> - */
> -static int __verify_planes_array(struct vb2_buffer *vb, const struct v4l2_buffer *b)
> -{
> -	if (!V4L2_TYPE_IS_MULTIPLANAR(b->type))
> -		return 0;
> -
> -	/* Is memory for copying plane information present? */
> -	if (NULL == b->m.planes) {
> -		dprintk(1, "multi-planar buffer passed but "
> -			   "planes array not provided\n");
> -		return -EINVAL;
> -	}
> -
> -	if (b->length < vb->num_planes || b->length > VIDEO_MAX_PLANES) {
> -		dprintk(1, "incorrect planes array length, "
> -			   "expected %d, got %d\n", vb->num_planes, b->length);
> -		return -EINVAL;
> -	}
> -
> -	return 0;
> -}
> -
> -/**
> - * __verify_length() - Verify that the bytesused value for each plane fits in
> - * the plane length and that the data offset doesn't exceed the bytesused value.
> - */
> -static int __verify_length(struct vb2_buffer *vb, const struct v4l2_buffer *b)
> -{
> -	unsigned int length;
> -	unsigned int bytesused;
> -	unsigned int plane;
> -
> -	if (!V4L2_TYPE_IS_OUTPUT(b->type))
> -		return 0;
> -
> -	if (V4L2_TYPE_IS_MULTIPLANAR(b->type)) {
> -		for (plane = 0; plane < vb->num_planes; ++plane) {
> -			length = (b->memory == V4L2_MEMORY_USERPTR ||
> -				b->memory == V4L2_MEMORY_DMABUF)
> -				? b->m.planes[plane].length
> -				: vb->planes[plane].length;
> -			bytesused = b->m.planes[plane].bytesused
> -				? b->m.planes[plane].bytesused : length;
> -
> -			if (b->m.planes[plane].bytesused > length)
> -				return -EINVAL;
> -
> -			if (b->m.planes[plane].data_offset > 0 &&
> -				b->m.planes[plane].data_offset >= bytesused)
> -				return -EINVAL;
> -		}
> -	} else {
> -		length = (b->memory == V4L2_MEMORY_USERPTR)
> -			? b->length : vb->planes[0].length;
> -
> -		if (b->bytesused > length)
> -			return -EINVAL;
> -	}
> -
> -	return 0;
> -}
> -
> -/**
> - * __buffer_in_use() - return true if the buffer is in use and
> + * vb2_buffer_in_use() - return true if the buffer is in use and
>   * the queue cannot be freed (by the means of REQBUFS(0)) call
>   */
> -static bool __buffer_in_use(struct vb2_queue *q, struct vb2_buffer *vb)
> +bool vb2_buffer_in_use(struct vb2_queue *q, struct vb2_buffer *vb)
>  {
>  	unsigned int plane;
>  	for (plane = 0; plane < vb->num_planes; ++plane) {
> @@ -631,6 +414,7 @@ static bool __buffer_in_use(struct vb2_queue *q, struct vb2_buffer *vb)
>  	}
>  	return false;
>  }
> +EXPORT_SYMBOL_GPL(vb2_buffer_in_use);
>  
>  /**
>   * __buffers_in_use() - return true if any buffers on the queue are in use and
> @@ -640,142 +424,26 @@ static bool __buffers_in_use(struct vb2_queue *q)
>  {
>  	unsigned int buffer;
>  	for (buffer = 0; buffer < q->num_buffers; ++buffer) {
> -		if (__buffer_in_use(q, q->bufs[buffer]))
> +		if (vb2_buffer_in_use(q, q->bufs[buffer]))
>  			return true;
>  	}
>  	return false;
>  }
>  
>  /**
> - * __fill_v4l2_buffer() - fill in a struct v4l2_buffer with information to be
> - * returned to userspace
> - */
> -static void __fill_v4l2_buffer(struct vb2_buffer *vb, struct v4l2_buffer *b)
> -{
> -	struct vb2_v4l2_buffer *vbuf = to_vb2_v4l2_buffer(vb);
> -	struct vb2_queue *q = vb->vb2_queue;
> -	unsigned int plane;
> -
> -	/* Copy back data such as timestamp, flags, etc. */
> -	b->index = vb->index;
> -	b->type = vb->type;
> -	b->memory = vb->memory;
> -	b->bytesused = 0;
> -
> -	b->flags = vbuf->flags;
> -	b->field = vbuf->field;
> -	b->timestamp = vbuf->timestamp;
> -	b->timecode = vbuf->timecode;
> -	b->sequence = vbuf->sequence;
> -
> -	if (V4L2_TYPE_IS_MULTIPLANAR(q->type)) {
> -		/*
> -		 * Fill in plane-related data if userspace provided an array
> -		 * for it. The caller has already verified memory and size.
> -		 */
> -		b->length = vb->num_planes;
> -		for (plane = 0; plane < vb->num_planes; ++plane) {
> -			struct v4l2_plane *pdst = &b->m.planes[plane];
> -			struct vb2_plane *psrc = &vb->planes[plane];
> -
> -			pdst->bytesused = psrc->bytesused;
> -			pdst->length = psrc->length;
> -			if (q->memory == V4L2_MEMORY_MMAP)
> -				pdst->m.mem_offset = psrc->m.offset;
> -			else if (q->memory == V4L2_MEMORY_USERPTR)
> -				pdst->m.userptr = psrc->m.userptr;
> -			else if (q->memory == V4L2_MEMORY_DMABUF)
> -				pdst->m.fd = psrc->m.fd;
> -			pdst->data_offset = psrc->data_offset;
> -		}
> -	} else {
> -		/*
> -		 * We use length and offset in v4l2_planes array even for
> -		 * single-planar buffers, but userspace does not.
> -		 */
> -		b->length = vb->planes[0].length;
> -		b->bytesused = vb->planes[0].bytesused;
> -		if (q->memory == V4L2_MEMORY_MMAP)
> -			b->m.offset = vb->planes[0].m.offset;
> -		else if (q->memory == V4L2_MEMORY_USERPTR)
> -			b->m.userptr = vb->planes[0].m.userptr;
> -		else if (q->memory == V4L2_MEMORY_DMABUF)
> -			b->m.fd = vb->planes[0].m.fd;
> -	}
> -
> -	/*
> -	 * Clear any buffer state related flags.
> -	 */
> -	b->flags &= ~V4L2_BUFFER_MASK_FLAGS;
> -	b->flags |= q->timestamp_flags & V4L2_BUF_FLAG_TIMESTAMP_MASK;
> -	if ((q->timestamp_flags & V4L2_BUF_FLAG_TIMESTAMP_MASK) !=
> -			V4L2_BUF_FLAG_TIMESTAMP_COPY) {
> -		/*
> -		 * For non-COPY timestamps, drop timestamp source bits
> -		 * and obtain the timestamp source from the queue.
> -		 */
> -		b->flags &= ~V4L2_BUF_FLAG_TSTAMP_SRC_MASK;
> -		b->flags |= q->timestamp_flags & V4L2_BUF_FLAG_TSTAMP_SRC_MASK;
> -	}
> -
> -	switch (vb->state) {
> -	case VB2_BUF_STATE_QUEUED:
> -	case VB2_BUF_STATE_ACTIVE:
> -		b->flags |= V4L2_BUF_FLAG_QUEUED;
> -		break;
> -	case VB2_BUF_STATE_ERROR:
> -		b->flags |= V4L2_BUF_FLAG_ERROR;
> -		/* fall through */
> -	case VB2_BUF_STATE_DONE:
> -		b->flags |= V4L2_BUF_FLAG_DONE;
> -		break;
> -	case VB2_BUF_STATE_PREPARED:
> -		b->flags |= V4L2_BUF_FLAG_PREPARED;
> -		break;
> -	case VB2_BUF_STATE_PREPARING:
> -	case VB2_BUF_STATE_DEQUEUED:
> -		/* nothing */
> -		break;
> -	}
> -
> -	if (__buffer_in_use(q, vb))
> -		b->flags |= V4L2_BUF_FLAG_MAPPED;
> -}
> -
> -/**
> - * vb2_querybuf() - query video buffer information
> + * vb2_core_querybuf() - query video buffer information
>   * @q:		videobuf queue
> + * @index:	id number of the buffer
>   * @b:		buffer struct passed from userspace to vidioc_querybuf handler
>   *		in driver
> - *
> - * Should be called from vidioc_querybuf ioctl handler in driver.
> - * This function will verify the passed v4l2_buffer structure and fill the
> - * relevant information for the userspace.
> - *
> - * The return values from this function are intended to be directly returned
> - * from vidioc_querybuf handler in driver.
>   */
> -int vb2_querybuf(struct vb2_queue *q, struct v4l2_buffer *b)
> +int vb2_core_querybuf(struct vb2_queue *q, unsigned int index, void *pb)
>  {
> -	struct vb2_buffer *vb;
> -	int ret;
> -
> -	if (b->type != q->type) {
> -		dprintk(1, "wrong buffer type\n");
> -		return -EINVAL;
> -	}
> +	call_bufop(q, fill_user_buffer, q->bufs[index], pb);
>  
> -	if (b->index >= q->num_buffers) {
> -		dprintk(1, "buffer index out of range\n");
> -		return -EINVAL;
> -	}
> -	vb = q->bufs[b->index];
> -	ret = __verify_planes_array(vb, b);
> -	if (!ret)
> -		__fill_v4l2_buffer(vb, b);
> -	return ret;
> +	return 0;
>  }
> -EXPORT_SYMBOL(vb2_querybuf);
> +EXPORT_SYMBOL_GPL(vb2_core_querybuf);
>  
>  /**
>   * __verify_userptr_ops() - verify that all memory operations required for
> @@ -818,14 +486,14 @@ static int __verify_dmabuf_ops(struct vb2_queue *q)
>  }
>  
>  /**
> - * __verify_memory_type() - Check whether the memory type and buffer type
> + * vb2_verify_memory_type() - Check whether the memory type and buffer type
>   * passed to a buffer operation are compatible with the queue.
>   */
> -static int __verify_memory_type(struct vb2_queue *q,
> -		enum v4l2_memory memory, enum v4l2_buf_type type)
> +int vb2_verify_memory_type(struct vb2_queue *q,
> +		unsigned int memory, unsigned int type)
>  {
> -	if (memory != V4L2_MEMORY_MMAP && memory != V4L2_MEMORY_USERPTR &&
> -			memory != V4L2_MEMORY_DMABUF) {
> +	if (memory != VB2_MEMORY_MMAP && memory != VB2_MEMORY_USERPTR &&
> +		memory != VB2_MEMORY_DMABUF) {
>  		dprintk(1, "unsupported memory type\n");
>  		return -EINVAL;
>  	}
> @@ -839,37 +507,30 @@ static int __verify_memory_type(struct vb2_queue *q,
>  	 * Make sure all the required memory ops for given memory type
>  	 * are available.
>  	 */
> -	if (memory == V4L2_MEMORY_MMAP && __verify_mmap_ops(q)) {
> +	if (memory == VB2_MEMORY_MMAP && __verify_mmap_ops(q)) {
>  		dprintk(1, "MMAP for current setup unsupported\n");
>  		return -EINVAL;
>  	}
>  
> -	if (memory == V4L2_MEMORY_USERPTR && __verify_userptr_ops(q)) {
> +	if (memory == VB2_MEMORY_USERPTR && __verify_userptr_ops(q)) {
>  		dprintk(1, "USERPTR for current setup unsupported\n");
>  		return -EINVAL;
>  	}
>  
> -	if (memory == V4L2_MEMORY_DMABUF && __verify_dmabuf_ops(q)) {
> +	if (memory == VB2_MEMORY_DMABUF && __verify_dmabuf_ops(q)) {
>  		dprintk(1, "DMABUF for current setup unsupported\n");
>  		return -EINVAL;
>  	}
>  
> -	/*
> -	 * Place the busy tests at the end: -EBUSY can be ignored when
> -	 * create_bufs is called with count == 0, but count == 0 should still
> -	 * do the memory and type validation.
> -	 */
> -	if (vb2_fileio_is_active(q)) {
> -		dprintk(1, "file io in progress\n");
> -		return -EBUSY;
> -	}
>  	return 0;
>  }
> +EXPORT_SYMBOL_GPL(vb2_verify_memory_type);
>  
>  /**
> - * __reqbufs() - Initiate streaming
> + * vb2_core_reqbufs() - Initiate streaming
>   * @q:		videobuf2 queue
> - * @req:	struct passed from userspace to vidioc_reqbufs handler in driver
> + * @memory:
> + * @count:
>   *
>   * Should be called from vidioc_reqbufs ioctl handler of a driver.
>   * This function:
> @@ -889,7 +550,8 @@ static int __verify_memory_type(struct vb2_queue *q,
>   * The return values from this function are intended to be directly returned
>   * from vidioc_reqbufs handler in driver.
>   */
> -static int __reqbufs(struct vb2_queue *q, struct v4l2_requestbuffers *req)
> +int vb2_core_reqbufs(struct vb2_queue *q, unsigned int memory,
> +		unsigned int *count)
>  {
>  	unsigned int num_buffers, allocated_buffers, num_planes = 0;
>  	int ret;
> @@ -899,13 +561,13 @@ static int __reqbufs(struct vb2_queue *q, struct v4l2_requestbuffers *req)
>  		return -EBUSY;
>  	}
>  
> -	if (req->count == 0 || q->num_buffers != 0 || q->memory != req->memory) {
> +	if (*count == 0 || q->num_buffers != 0 || q->memory != memory) {
>  		/*
>  		 * We already have buffers allocated, so first check if they
>  		 * are not in use and can be freed.
>  		 */
>  		mutex_lock(&q->mmap_lock);
> -		if (q->memory == V4L2_MEMORY_MMAP && __buffers_in_use(q)) {
> +		if (q->memory == VB2_MEMORY_MMAP && __buffers_in_use(q)) {
>  			mutex_unlock(&q->mmap_lock);
>  			dprintk(1, "memory in use, cannot free\n");
>  			return -EBUSY;
> @@ -926,18 +588,18 @@ static int __reqbufs(struct vb2_queue *q, struct v4l2_requestbuffers *req)
>  		 * In case of REQBUFS(0) return immediately without calling
>  		 * driver's queue_setup() callback and allocating resources.
>  		 */
> -		if (req->count == 0)
> +		if (*count == 0)
>  			return 0;
>  	}
>  
>  	/*
>  	 * Make sure the requested values and current defaults are sane.
>  	 */
> -	num_buffers = min_t(unsigned int, req->count, VIDEO_MAX_FRAME);
> +	num_buffers = min_t(unsigned int, *count, VB2_MAX_FRAME);
>  	num_buffers = max_t(unsigned int, num_buffers, q->min_buffers_needed);
>  	memset(q->plane_sizes, 0, sizeof(q->plane_sizes));
>  	memset(q->alloc_ctx, 0, sizeof(q->alloc_ctx));
> -	q->memory = req->memory;
> +	q->memory = memory;
>  
>  	/*
>  	 * Ask the driver how many buffers and planes per buffer it requires.
> @@ -949,7 +611,8 @@ static int __reqbufs(struct vb2_queue *q, struct v4l2_requestbuffers *req)
>  		return ret;
>  
>  	/* Finally, allocate buffers and video memory */
> -	allocated_buffers = __vb2_queue_alloc(q, req->memory, num_buffers, num_planes);
> +	allocated_buffers =
> +		__vb2_queue_alloc(q, memory, num_buffers, num_planes);
>  	if (allocated_buffers == 0) {
>  		dprintk(1, "memory allocation failed\n");
>  		return -ENOMEM;
> @@ -998,28 +661,15 @@ static int __reqbufs(struct vb2_queue *q, struct v4l2_requestbuffers *req)
>  	 * Return the number of successfully allocated buffers
>  	 * to the userspace.
>  	 */
> -	req->count = allocated_buffers;
> -	q->waiting_for_buffers = !V4L2_TYPE_IS_OUTPUT(q->type);
> +	*count = allocated_buffers;
> +	q->waiting_for_buffers = !q->is_output;
>  
>  	return 0;
>  }
> +EXPORT_SYMBOL_GPL(vb2_core_reqbufs);
>  
>  /**
> - * vb2_reqbufs() - Wrapper for __reqbufs() that also verifies the memory and
> - * type values.
> - * @q:		videobuf2 queue
> - * @req:	struct passed from userspace to vidioc_reqbufs handler in driver
> - */
> -int vb2_reqbufs(struct vb2_queue *q, struct v4l2_requestbuffers *req)
> -{
> -	int ret = __verify_memory_type(q, req->memory, req->type);
> -
> -	return ret ? ret : __reqbufs(q, req);
> -}
> -EXPORT_SYMBOL_GPL(vb2_reqbufs);
> -
> -/**
> - * __create_bufs() - Allocate buffers and any required auxiliary structs
> + * vb2_core_create_bufs() - Allocate buffers and any required auxiliary structs
>   * @q:		videobuf2 queue
>   * @create:	creation parameters, passed from userspace to vidioc_create_bufs
>   *		handler in driver
> @@ -1033,12 +683,13 @@ EXPORT_SYMBOL_GPL(vb2_reqbufs);
>   * The return values from this function are intended to be directly returned
>   * from vidioc_create_bufs handler in driver.
>   */
> -static int __create_bufs(struct vb2_queue *q, struct v4l2_create_buffers *create)
> +int vb2_core_create_bufs(struct vb2_queue *q, unsigned int memory,
> +		unsigned int *count, void *parg)
>  {
>  	unsigned int num_planes = 0, num_buffers, allocated_buffers;
>  	int ret;
>  
> -	if (q->num_buffers == VIDEO_MAX_FRAME) {
> +	if (q->num_buffers == VB2_MAX_FRAME) {
>  		dprintk(1, "maximum number of buffers already allocated\n");
>  		return -ENOBUFS;
>  	}
> @@ -1046,23 +697,23 @@ static int __create_bufs(struct vb2_queue *q, struct v4l2_create_buffers *create
>  	if (!q->num_buffers) {
>  		memset(q->plane_sizes, 0, sizeof(q->plane_sizes));
>  		memset(q->alloc_ctx, 0, sizeof(q->alloc_ctx));
> -		q->memory = create->memory;
> -		q->waiting_for_buffers = !V4L2_TYPE_IS_OUTPUT(q->type);
> +		q->memory = memory;
> +		q->waiting_for_buffers = !q->is_output;
>  	}
>  
> -	num_buffers = min(create->count, VIDEO_MAX_FRAME - q->num_buffers);
> +	num_buffers = min(*count, VB2_MAX_FRAME - q->num_buffers);
>  
>  	/*
>  	 * Ask the driver, whether the requested number of buffers, planes per
>  	 * buffer and their sizes are acceptable
>  	 */
> -	ret = call_qop(q, queue_setup, q, &create->format, &num_buffers,
> +	ret = call_qop(q, queue_setup, q, parg, &num_buffers,
>  			&num_planes, q->plane_sizes, q->alloc_ctx);
>  	if (ret)
>  		return ret;
>  
>  	/* Finally, allocate buffers and video memory */
> -	allocated_buffers = __vb2_queue_alloc(q, create->memory, num_buffers,
> +	allocated_buffers = __vb2_queue_alloc(q, memory, num_buffers,
>  				num_planes);
>  	if (allocated_buffers == 0) {
>  		dprintk(1, "memory allocation failed\n");
> @@ -1079,7 +730,7 @@ static int __create_bufs(struct vb2_queue *q, struct v4l2_create_buffers *create
>  		 * q->num_buffers contains the total number of buffers, that the
>  		 * queue driver has set up
>  		 */
> -		ret = call_qop(q, queue_setup, q, &create->format, &num_buffers,
> +		ret = call_qop(q, queue_setup, q, parg, &num_buffers,
>  				&num_planes, q->plane_sizes, q->alloc_ctx);
>  
>  		if (!ret && allocated_buffers < num_buffers)
> @@ -1109,28 +760,11 @@ static int __create_bufs(struct vb2_queue *q, struct v4l2_create_buffers *create
>  	 * Return the number of successfully allocated buffers
>  	 * to the userspace.
>  	 */
> -	create->count = allocated_buffers;
> +	*count = allocated_buffers;
>  
>  	return 0;
>  }
> -
> -/**
> - * vb2_create_bufs() - Wrapper for __create_bufs() that also verifies the
> - * memory and type values.
> - * @q:		videobuf2 queue
> - * @create:	creation parameters, passed from userspace to vidioc_create_bufs
> - *		handler in driver
> - */
> -int vb2_create_bufs(struct vb2_queue *q, struct v4l2_create_buffers *create)
> -{
> -	int ret = __verify_memory_type(q, create->memory, create->format.type);
> -
> -	create->index = q->num_buffers;
> -	if (create->count == 0)
> -		return ret != -EBUSY ? ret : 0;
> -	return ret ? ret : __create_bufs(q, create);
> -}
> -EXPORT_SYMBOL_GPL(vb2_create_bufs);
> +EXPORT_SYMBOL_GPL(vb2_core_create_bufs);
>  
>  /**
>   * vb2_plane_vaddr() - Return a kernel virtual address of a given plane
> @@ -1263,7 +897,7 @@ void vb2_discard_done(struct vb2_queue *q)
>  }
>  EXPORT_SYMBOL_GPL(vb2_discard_done);
>  
> -static void vb2_warn_zero_bytesused(struct vb2_buffer *vb)
> +void vb2_warn_zero_bytesused(struct vb2_buffer *vb)
>  {
>  	static bool __check_once __read_mostly;
>  
> @@ -1279,162 +913,34 @@ static void vb2_warn_zero_bytesused(struct vb2_buffer *vb)
>  	else
>  		pr_warn_once("use the actual size instead.\n");
>  }
> -
> -/**
> - * __fill_vb2_buffer() - fill a vb2_buffer with information provided in a
> - * v4l2_buffer by the userspace. The caller has already verified that struct
> - * v4l2_buffer has a valid number of planes.
> - */
> -static void __fill_vb2_buffer(struct vb2_buffer *vb,
> -		const struct v4l2_buffer *b, struct vb2_plane *planes)
> -{
> -	struct vb2_v4l2_buffer *vbuf = to_vb2_v4l2_buffer(vb);
> -	unsigned int plane;
> -
> -	if (V4L2_TYPE_IS_MULTIPLANAR(b->type)) {
> -		if (b->memory == V4L2_MEMORY_USERPTR) {
> -			for (plane = 0; plane < vb->num_planes; ++plane) {
> -				planes[plane].m.userptr =
> -					b->m.planes[plane].m.userptr;
> -				planes[plane].length =
> -					b->m.planes[plane].length;
> -			}
> -		}
> -		if (b->memory == V4L2_MEMORY_DMABUF) {
> -			for (plane = 0; plane < vb->num_planes; ++plane) {
> -				planes[plane].m.fd =
> -					b->m.planes[plane].m.fd;
> -				planes[plane].length =
> -					b->m.planes[plane].length;
> -			}
> -		}
> -
> -		/* Fill in driver-provided information for OUTPUT types */
> -		if (V4L2_TYPE_IS_OUTPUT(b->type)) {
> -			/*
> -			 * Will have to go up to b->length when API starts
> -			 * accepting variable number of planes.
> -			 *
> -			 * If bytesused == 0 for the output buffer, then fall
> -			 * back to the full buffer size. In that case
> -			 * userspace clearly never bothered to set it and
> -			 * it's a safe assumption that they really meant to
> -			 * use the full plane sizes.
> -			 *
> -			 * Some drivers, e.g. old codec drivers, use bytesused == 0
> -			 * as a way to indicate that streaming is finished.
> -			 * In that case, the driver should use the
> -			 * allow_zero_bytesused flag to keep old userspace
> -			 * applications working.
> -			 */
> -			for (plane = 0; plane < vb->num_planes; ++plane) {
> -				struct vb2_plane *pdst = &planes[plane];
> -				struct v4l2_plane *psrc = &b->m.planes[plane];
> -
> -				if (psrc->bytesused == 0)
> -					vb2_warn_zero_bytesused(vb);
> -
> -				if (vb->vb2_queue->allow_zero_bytesused)
> -					pdst->bytesused = psrc->bytesused;
> -				else
> -					pdst->bytesused = psrc->bytesused ?
> -						psrc->bytesused : pdst->length;
> -				pdst->data_offset = psrc->data_offset;
> -			}
> -		}
> -	} else {
> -		/*
> -		 * Single-planar buffers do not use planes array,
> -		 * so fill in relevant v4l2_buffer struct fields instead.
> -		 * In videobuf we use our internal V4l2_planes struct for
> -		 * single-planar buffers as well, for simplicity.
> -		 *
> -		 * If bytesused == 0 for the output buffer, then fall back
> -		 * to the full buffer size as that's a sensible default.
> -		 *
> -		 * Some drivers, e.g. old codec drivers, use bytesused == 0 as
> -		 * a way to indicate that streaming is finished. In that case,
> -		 * the driver should use the allow_zero_bytesused flag to keep
> -		 * old userspace applications working.
> -		 */
> -		if (b->memory == V4L2_MEMORY_USERPTR) {
> -			planes[0].m.userptr = b->m.userptr;
> -			planes[0].length = b->length;
> -		}
> -
> -		if (b->memory == V4L2_MEMORY_DMABUF) {
> -			planes[0].m.fd = b->m.fd;
> -			planes[0].length = b->length;
> -		}
> -
> -		if (V4L2_TYPE_IS_OUTPUT(b->type)) {
> -			if (b->bytesused == 0)
> -				vb2_warn_zero_bytesused(vb);
> -
> -			if (vb->vb2_queue->allow_zero_bytesused)
> -				planes[0].bytesused = b->bytesused;
> -			else
> -				planes[0].bytesused = b->bytesused ?
> -					b->bytesused : planes[0].length;
> -		} else
> -			planes[0].bytesused = 0;
> -
> -	}
> -
> -	/* Zero flags that the vb2 core handles */
> -	vbuf->flags = b->flags & ~V4L2_BUFFER_MASK_FLAGS;
> -	if ((vb->vb2_queue->timestamp_flags & V4L2_BUF_FLAG_TIMESTAMP_MASK) !=
> -			V4L2_BUF_FLAG_TIMESTAMP_COPY ||
> -			!V4L2_TYPE_IS_OUTPUT(b->type)) {
> -		/*
> -		 * Non-COPY timestamps and non-OUTPUT queues will get
> -		 * their timestamp and timestamp source flags from the
> -		 * queue.
> -		 */
> -		vbuf->flags &= ~V4L2_BUF_FLAG_TSTAMP_SRC_MASK;
> -	}
> -
> -	if (V4L2_TYPE_IS_OUTPUT(b->type)) {
> -		/*
> -		 * For output buffers mask out the timecode flag:
> -		 * this will be handled later in vb2_internal_qbuf().
> -		 * The 'field' is valid metadata for this output buffer
> -		 * and so that needs to be copied here.
> -		 */
> -		vbuf->flags &= ~V4L2_BUF_FLAG_TIMECODE;
> -		vbuf->field = b->field;
> -	} else {
> -		/* Zero any output buffer flags as this is a capture buffer */
> -		vbuf->flags &= ~V4L2_BUFFER_OUT_FLAGS;
> -	}
> -}
> +EXPORT_SYMBOL_GPL(vb2_warn_zero_bytesused);
>  
>  /**
>   * __qbuf_mmap() - handle qbuf of an MMAP buffer
>   */
> -static int __qbuf_mmap(struct vb2_buffer *vb, const struct v4l2_buffer *b)
> +static int __qbuf_mmap(struct vb2_buffer *vb, void *pb)
>  {
> -	__fill_vb2_buffer(vb, b, vb->planes);
> +	call_bufop(vb->vb2_queue, fill_vb2_buffer, vb, pb, vb->planes);
>  	return call_vb_qop(vb, buf_prepare, vb);
>  }
>  
>  /**
>   * __qbuf_userptr() - handle qbuf of a USERPTR buffer
>   */
> -static int __qbuf_userptr(struct vb2_buffer *vb, const struct v4l2_buffer *b)
> +static int __qbuf_userptr(struct vb2_buffer *vb, void *pb)
>  {
> -	struct vb2_plane planes[VIDEO_MAX_PLANES];
> +	struct vb2_plane planes[VB2_MAX_PLANES];
>  	struct vb2_queue *q = vb->vb2_queue;
>  	void *mem_priv;
>  	unsigned int plane;
>  	int ret;
>  	enum dma_data_direction dma_dir =
> -		V4L2_TYPE_IS_OUTPUT(q->type) ? DMA_TO_DEVICE : DMA_FROM_DEVICE;
> +		q->is_output ? DMA_TO_DEVICE : DMA_FROM_DEVICE;
>  	bool reacquired = vb->planes[0].mem_priv == NULL;
>  
>  	memset(planes, 0, sizeof(planes[0]) * vb->num_planes);
>  	/* Copy relevant information provided by the userspace */
> -	__fill_vb2_buffer(vb, b, planes);
> +	call_bufop(vb->vb2_queue, fill_vb2_buffer, vb, pb, planes);
>  
>  	for (plane = 0; plane < vb->num_planes; ++plane) {
>  		/* Skip the plane if already verified */
> @@ -1462,7 +968,8 @@ static int __qbuf_userptr(struct vb2_buffer *vb, const struct v4l2_buffer *b)
>  				reacquired = true;
>  				call_void_vb_qop(vb, buf_cleanup, vb);
>  			}
> -			call_void_memop(vb, put_userptr, vb->planes[plane].mem_priv);
> +			call_void_memop(vb, put_userptr,
> +					vb->planes[plane].mem_priv);
>  		}
>  
>  		vb->planes[plane].mem_priv = NULL;
> @@ -1533,20 +1040,20 @@ err:
>  /**
>   * __qbuf_dmabuf() - handle qbuf of a DMABUF buffer
>   */
> -static int __qbuf_dmabuf(struct vb2_buffer *vb, const struct v4l2_buffer *b)
> +static int __qbuf_dmabuf(struct vb2_buffer *vb, void *pb)
>  {
> -	struct vb2_plane planes[VIDEO_MAX_PLANES];
> +	struct vb2_plane planes[VB2_MAX_PLANES];
>  	struct vb2_queue *q = vb->vb2_queue;
>  	void *mem_priv;
>  	unsigned int plane;
>  	int ret;
>  	enum dma_data_direction dma_dir =
> -		V4L2_TYPE_IS_OUTPUT(q->type) ? DMA_TO_DEVICE : DMA_FROM_DEVICE;
> +		q->is_output ? DMA_TO_DEVICE : DMA_FROM_DEVICE;
>  	bool reacquired = vb->planes[0].mem_priv == NULL;
>  
>  	memset(planes, 0, sizeof(planes[0]) * vb->num_planes);
>  	/* Copy relevant information provided by the userspace */
> -	__fill_vb2_buffer(vb, b, planes);
> +	call_bufop(vb->vb2_queue, fill_vb2_buffer, vb, pb, planes);
>  
>  	for (plane = 0; plane < vb->num_planes; ++plane) {
>  		struct dma_buf *dbuf = dma_buf_get(planes[plane].m.fd);
> @@ -1591,9 +1098,8 @@ static int __qbuf_dmabuf(struct vb2_buffer *vb, const struct v4l2_buffer *b)
>  		vb->planes[plane].data_offset = 0;
>  
>  		/* Acquire each plane's memory */
> -		mem_priv = call_ptr_memop(vb, attach_dmabuf,
> -			q->alloc_ctx[plane], dbuf, planes[plane].length,
> -			dma_dir);
> +		mem_priv = call_ptr_memop(vb, attach_dmabuf, q->alloc_ctx[plane],
> +			dbuf, planes[plane].length, dma_dir);
>  		if (IS_ERR(mem_priv)) {
>  			dprintk(1, "failed to attach dmabuf\n");
>  			ret = PTR_ERR(mem_priv);
> @@ -1626,7 +1132,7 @@ static int __qbuf_dmabuf(struct vb2_buffer *vb, const struct v4l2_buffer *b)
>  	for (plane = 0; plane < vb->num_planes; ++plane) {
>  		vb->planes[plane].bytesused = planes[plane].bytesused;
>  		vb->planes[plane].length = planes[plane].length;
> -		vb->planes[plane].m.fd = planes[plane].m.userptr;
> +		vb->planes[plane].m.fd = planes[plane].m.fd;
>  		vb->planes[plane].data_offset = planes[plane].data_offset;
>  	}
>  
> @@ -1677,52 +1183,27 @@ static void __enqueue_in_driver(struct vb2_buffer *vb)
>  	call_void_vb_qop(vb, buf_queue, vb);
>  }
>  
> -static int __buf_prepare(struct vb2_buffer *vb, const struct v4l2_buffer *b)
> +static int __buf_prepare(struct vb2_buffer *vb, void *pb)
>  {
> -	struct vb2_v4l2_buffer *vbuf = to_vb2_v4l2_buffer(vb);
>  	struct vb2_queue *q = vb->vb2_queue;
>  	int ret;
>  
> -	ret = __verify_length(vb, b);
> -	if (ret < 0) {
> -		dprintk(1, "plane parameters verification failed: %d\n", ret);
> -		return ret;
> -	}
> -	if (b->field == V4L2_FIELD_ALTERNATE && V4L2_TYPE_IS_OUTPUT(q->type)) {
> -		/*
> -		 * If the format's field is ALTERNATE, then the buffer's field
> -		 * should be either TOP or BOTTOM, not ALTERNATE since that
> -		 * makes no sense. The driver has to know whether the
> -		 * buffer represents a top or a bottom field in order to
> -		 * program any DMA correctly. Using ALTERNATE is wrong, since
> -		 * that just says that it is either a top or a bottom field,
> -		 * but not which of the two it is.
> -		 */
> -		dprintk(1, "the field is incorrectly set to ALTERNATE for an output buffer\n");
> -		return -EINVAL;
> -	}
> -
>  	if (q->error) {
>  		dprintk(1, "fatal error occurred on queue\n");
>  		return -EIO;
>  	}
>  
> -	vb->state = VB2_BUF_STATE_PREPARING;
> -	vbuf->timestamp.tv_sec = 0;
> -	vbuf->timestamp.tv_usec = 0;
> -	vbuf->sequence = 0;
> -
>  	switch (q->memory) {
> -	case V4L2_MEMORY_MMAP:
> -		ret = __qbuf_mmap(vb, b);
> +	case VB2_MEMORY_MMAP:
> +		ret = __qbuf_mmap(vb, pb);
>  		break;
> -	case V4L2_MEMORY_USERPTR:
> +	case VB2_MEMORY_USERPTR:
>  		down_read(&current->mm->mmap_sem);
> -		ret = __qbuf_userptr(vb, b);
> +		ret = __qbuf_userptr(vb, pb);
>  		up_read(&current->mm->mmap_sem);
>  		break;
> -	case V4L2_MEMORY_DMABUF:
> -		ret = __qbuf_dmabuf(vb, b);
> +	case VB2_MEMORY_DMABUF:
> +		ret = __qbuf_dmabuf(vb, pb);
>  		break;
>  	default:
>  		WARN(1, "Invalid queue type\n");
> @@ -1736,35 +1217,56 @@ static int __buf_prepare(struct vb2_buffer *vb, const struct v4l2_buffer *b)
>  	return ret;
>  }
>  
> -static int vb2_queue_or_prepare_buf(struct vb2_queue *q, struct v4l2_buffer *b,
> -					const char *opname)
> +int vb2_verify_buffer(struct vb2_queue *q,
> +			unsigned int memory, unsigned int type,
> +			unsigned int index, unsigned int nplanes,
> +			void *pplane, const char *opname)
>  {
> -	if (b->type != q->type) {
> +	if (type != q->type) {
>  		dprintk(1, "%s: invalid buffer type\n", opname);
>  		return -EINVAL;
>  	}
>  
> -	if (b->index >= q->num_buffers) {
> +	if (index >= q->num_buffers) {
>  		dprintk(1, "%s: buffer index out of range\n", opname);
>  		return -EINVAL;
>  	}
>  
> -	if (q->bufs[b->index] == NULL) {
> +	if (q->bufs[index] == NULL) {
>  		/* Should never happen */
>  		dprintk(1, "%s: buffer is NULL\n", opname);
>  		return -EINVAL;
>  	}
>  
> -	if (b->memory != q->memory) {
> +	if (memory != VB2_MEMORY_UNKNOWN && memory != q->memory) {
>  		dprintk(1, "%s: invalid memory type\n", opname);
>  		return -EINVAL;
>  	}
>  
> -	return __verify_planes_array(q->bufs[b->index], b);
> +	if (q->is_multiplanar) {
> +		struct vb2_buffer *vb = q->bufs[index];
> +
> +		/* Is memory for copying plane information present? */
> +		if (NULL == pplane) {
> +			dprintk(1, "%s: multi-planar buffer passed but "
> +				"planes array not provided\n", opname);
> +			return -EINVAL;
> +		}
> +
> +		if (nplanes < vb->num_planes || nplanes > VB2_MAX_PLANES) {
> +			dprintk(1, "%s: incorrect planes array length, "
> +				"expected %d, got %d\n",
> +				opname, vb->num_planes, nplanes);
> +			return -EINVAL;
> +		}
> +	}
> +
> +	return 0;
>  }
> +EXPORT_SYMBOL_GPL(vb2_verify_buffer);
>  
>  /**
> - * vb2_prepare_buf() - Pass ownership of a buffer from userspace to the kernel
> + * vb2_core_prepare_buf() - Pass ownership of a buffer from userspace to the kernel
>   * @q:		videobuf2 queue
>   * @b:		buffer structure passed from userspace to vidioc_prepare_buf
>   *		handler in driver
> @@ -1778,37 +1280,28 @@ static int vb2_queue_or_prepare_buf(struct vb2_queue *q, struct v4l2_buffer *b,
>   * The return values from this function are intended to be directly returned
>   * from vidioc_prepare_buf handler in driver.
>   */
> -int vb2_prepare_buf(struct vb2_queue *q, struct v4l2_buffer *b)
> +int vb2_core_prepare_buf(struct vb2_queue *q, unsigned int index, void *pb)
>  {
>  	struct vb2_buffer *vb;
>  	int ret;
>  
> -	if (vb2_fileio_is_active(q)) {
> -		dprintk(1, "file io in progress\n");
> -		return -EBUSY;
> -	}
> -
> -	ret = vb2_queue_or_prepare_buf(q, b, "prepare_buf");
> -	if (ret)
> -		return ret;
> -
> -	vb = q->bufs[b->index];
> +	vb = q->bufs[index];
>  	if (vb->state != VB2_BUF_STATE_DEQUEUED) {
>  		dprintk(1, "invalid buffer state %d\n",
>  			vb->state);
>  		return -EINVAL;
>  	}
>  
> -	ret = __buf_prepare(vb, b);
> +	ret = __buf_prepare(vb, pb);
>  	if (!ret) {
>  		/* Fill buffer information for the userspace */
> -		__fill_v4l2_buffer(vb, b);
> +		call_bufop(q, fill_user_buffer, vb, pb);
>  
>  		dprintk(1, "prepare of buffer %d succeeded\n", vb->index);
>  	}
>  	return ret;
>  }
> -EXPORT_SYMBOL_GPL(vb2_prepare_buf);
> +EXPORT_SYMBOL_GPL(vb2_core_prepare_buf);
>  
>  /**
>   * vb2_start_streaming() - Attempt to start streaming.
> @@ -1873,21 +1366,16 @@ static int vb2_start_streaming(struct vb2_queue *q)
>  	return ret;
>  }
>  
> -static int vb2_internal_qbuf(struct vb2_queue *q, struct v4l2_buffer *b)
> +int vb2_core_qbuf(struct vb2_queue *q, unsigned int index, void *pb)
>  {
> -	int ret = vb2_queue_or_prepare_buf(q, b, "qbuf");
> +	int ret;
>  	struct vb2_buffer *vb;
> -	struct vb2_v4l2_buffer *vbuf;
> -
> -	if (ret)
> -		return ret;
>  
> -	vb = q->bufs[b->index];
> -	vbuf = to_vb2_v4l2_buffer(vb);
> +	vb = q->bufs[index];
>  
>  	switch (vb->state) {
>  	case VB2_BUF_STATE_DEQUEUED:
> -		ret = __buf_prepare(vb, b);
> +		ret = __buf_prepare(vb, pb);
>  		if (ret)
>  			return ret;
>  		break;
> @@ -1909,18 +1397,9 @@ static int vb2_internal_qbuf(struct vb2_queue *q, struct v4l2_buffer *b)
>  	q->queued_count++;
>  	q->waiting_for_buffers = false;
>  	vb->state = VB2_BUF_STATE_QUEUED;
> -	if (V4L2_TYPE_IS_OUTPUT(q->type)) {
> -		/*
> -		 * For output buffers copy the timestamp if needed,
> -		 * and the timecode field and flag if needed.
> -		 */
> -		if ((q->timestamp_flags & V4L2_BUF_FLAG_TIMESTAMP_MASK) ==
> -				V4L2_BUF_FLAG_TIMESTAMP_COPY)
> -			vbuf->timestamp = b->timestamp;
> -		vbuf->flags |= b->flags & V4L2_BUF_FLAG_TIMECODE;
> -		if (b->flags & V4L2_BUF_FLAG_TIMECODE)
> -			vbuf->timecode = b->timecode;
> -	}
> +
> +	if (q->is_output)
> +		call_bufop(q, fill_vb2_timestamp, vb, pb);
>  
>  	trace_vb2_qbuf(q, vb);
>  
> @@ -1932,7 +1411,7 @@ static int vb2_internal_qbuf(struct vb2_queue *q, struct v4l2_buffer *b)
>  		__enqueue_in_driver(vb);
>  
>  	/* Fill buffer information for the userspace */
> -	__fill_v4l2_buffer(vb, b);
> +	call_bufop(q, fill_user_buffer, vb, pb);
>  
>  	/*
>  	 * If streamon has been called, and we haven't yet called
> @@ -1950,34 +1429,7 @@ static int vb2_internal_qbuf(struct vb2_queue *q, struct v4l2_buffer *b)
>  	dprintk(1, "qbuf of buffer %d succeeded\n", vb->index);
>  	return 0;
>  }
> -
> -/**
> - * vb2_qbuf() - Queue a buffer from userspace
> - * @q:		videobuf2 queue
> - * @b:		buffer structure passed from userspace to vidioc_qbuf handler
> - *		in driver
> - *
> - * Should be called from vidioc_qbuf ioctl handler of a driver.
> - * This function:
> - * 1) verifies the passed buffer,
> - * 2) if necessary, calls buf_prepare callback in the driver (if provided), in
> - *    which driver-specific buffer initialization can be performed,
> - * 3) if streaming is on, queues the buffer in driver by the means of buf_queue
> - *    callback for processing.
> - *
> - * The return values from this function are intended to be directly returned
> - * from vidioc_qbuf handler in driver.
> - */
> -int vb2_qbuf(struct vb2_queue *q, struct v4l2_buffer *b)
> -{
> -	if (vb2_fileio_is_active(q)) {
> -		dprintk(1, "file io in progress\n");
> -		return -EBUSY;
> -	}
> -
> -	return vb2_internal_qbuf(q, b);
> -}
> -EXPORT_SYMBOL_GPL(vb2_qbuf);
> +EXPORT_SYMBOL_GPL(vb2_core_qbuf);
>  
>  /**
>   * __vb2_wait_for_done_vb() - wait for a buffer to become available
> @@ -2061,7 +1513,7 @@ static int __vb2_wait_for_done_vb(struct vb2_queue *q, int nonblocking)
>   * Will sleep if required for nonblocking == false.
>   */
>  static int __vb2_get_done_vb(struct vb2_queue *q, struct vb2_buffer **vb,
> -				struct v4l2_buffer *b, int nonblocking)
> +				int nonblocking)
>  {
>  	unsigned long flags;
>  	int ret;
> @@ -2082,10 +1534,11 @@ static int __vb2_get_done_vb(struct vb2_queue *q, struct vb2_buffer **vb,
>  	/*
>  	 * Only remove the buffer from done_list if v4l2_buffer can handle all
>  	 * the planes.
> +	 * ret = __verify_planes_array(*vb, pb);
> +	 * But, actually that's unnecessary since this is checked already
> +	 * before the buffer is queued/prepared. So it can never fails
>  	 */
> -	ret = __verify_planes_array(*vb, b);
> -	if (!ret)
> -		list_del(&(*vb)->done_entry);
> +	list_del(&(*vb)->done_entry);
>  	spin_unlock_irqrestore(&q->done_lock, flags);
>  
>  	return ret;
> @@ -2128,27 +1581,22 @@ static void __vb2_dqbuf(struct vb2_buffer *vb)
>  	vb->state = VB2_BUF_STATE_DEQUEUED;
>  
>  	/* unmap DMABUF buffer */
> -	if (q->memory == V4L2_MEMORY_DMABUF)
> +	if (q->memory == VB2_MEMORY_DMABUF)
>  		for (i = 0; i < vb->num_planes; ++i) {
>  			if (!vb->planes[i].dbuf_mapped)
>  				continue;
> -			call_void_memop(vb, unmap_dmabuf, vb->planes[i].mem_priv);
> +			call_void_memop(vb, unmap_dmabuf,
> +					vb->planes[i].mem_priv);
>  			vb->planes[i].dbuf_mapped = 0;
>  		}
>  }
>  
> -static int vb2_internal_dqbuf(struct vb2_queue *q, struct v4l2_buffer *b,
> -		bool nonblocking)
> +int vb2_core_dqbuf(struct vb2_queue *q, void *pb, bool nonblocking)
>  {
>  	struct vb2_buffer *vb = NULL;
> -	struct vb2_v4l2_buffer *vbuf = NULL;
>  	int ret;
>  
> -	if (b->type != q->type) {
> -		dprintk(1, "invalid buffer type\n");
> -		return -EINVAL;
> -	}
> -	ret = __vb2_get_done_vb(q, &vb, b, nonblocking);
> +	ret = __vb2_get_done_vb(q, &vb, nonblocking);
>  	if (ret < 0)
>  		return ret;
>  
> @@ -2167,16 +1615,15 @@ static int vb2_internal_dqbuf(struct vb2_queue *q, struct v4l2_buffer *b,
>  	call_void_vb_qop(vb, buf_finish, vb);
>  
>  	/* Fill buffer information for the userspace */
> -	__fill_v4l2_buffer(vb, b);
> +	call_bufop(q, fill_user_buffer, vb, pb);
>  	/* Remove from videobuf queue */
>  	list_del(&vb->queued_entry);
>  	q->queued_count--;
>  
>  	trace_vb2_dqbuf(q, vb);
>  
> -	vbuf = to_vb2_v4l2_buffer(vb);
> -	if (!V4L2_TYPE_IS_OUTPUT(q->type) &&
> -			vbuf->flags & V4L2_BUF_FLAG_LAST)
> +	if (!q->is_output &&
> +			call_bufop(q, is_last, vb))
>  		q->last_buffer_dequeued = true;
>  	/* go back to dequeued state */
>  	__vb2_dqbuf(vb);
> @@ -2186,37 +1633,7 @@ static int vb2_internal_dqbuf(struct vb2_queue *q, struct v4l2_buffer *b,
>  
>  	return 0;
>  }
> -
> -/**
> - * vb2_dqbuf() - Dequeue a buffer to the userspace
> - * @q:		videobuf2 queue
> - * @b:		buffer structure passed from userspace to vidioc_dqbuf handler
> - *		in driver
> - * @nonblocking: if true, this call will not sleep waiting for a buffer if no
> - *		 buffers ready for dequeuing are present. Normally the driver
> - *		 would be passing (file->f_flags & O_NONBLOCK) here
> - *
> - * Should be called from vidioc_dqbuf ioctl handler of a driver.
> - * This function:
> - * 1) verifies the passed buffer,
> - * 2) calls buf_finish callback in the driver (if provided), in which
> - *    driver can perform any additional operations that may be required before
> - *    returning the buffer to userspace, such as cache sync,
> - * 3) the buffer struct members are filled with relevant information for
> - *    the userspace.
> - *
> - * The return values from this function are intended to be directly returned
> - * from vidioc_dqbuf handler in driver.
> - */
> -int vb2_dqbuf(struct vb2_queue *q, struct v4l2_buffer *b, bool nonblocking)
> -{
> -	if (vb2_fileio_is_active(q)) {
> -		dprintk(1, "file io in progress\n");
> -		return -EBUSY;
> -	}
> -	return vb2_internal_dqbuf(q, b, nonblocking);
> -}
> -EXPORT_SYMBOL_GPL(vb2_dqbuf);
> +EXPORT_SYMBOL_GPL(vb2_core_dqbuf);
>  
>  /**
>   * __vb2_queue_cancel() - cancel and stop (pause) streaming
> @@ -2286,15 +1703,10 @@ static void __vb2_queue_cancel(struct vb2_queue *q)
>  	}
>  }
>  
> -static int vb2_internal_streamon(struct vb2_queue *q, enum v4l2_buf_type type)
> +int vb2_core_streamon(struct vb2_queue *q)
>  {
>  	int ret;
>  
> -	if (type != q->type) {
> -		dprintk(1, "invalid stream type\n");
> -		return -EINVAL;
> -	}
> -
>  	if (q->streaming) {
>  		dprintk(3, "already streaming\n");
>  		return 0;
> @@ -2328,6 +1740,7 @@ static int vb2_internal_streamon(struct vb2_queue *q, enum v4l2_buf_type type)
>  	dprintk(3, "successful\n");
>  	return 0;
>  }
> +EXPORT_SYMBOL_GPL(vb2_core_streamon);
>  
>  /**
>   * vb2_queue_error() - signal a fatal error on the queue
> @@ -2350,36 +1763,8 @@ void vb2_queue_error(struct vb2_queue *q)
>  }
>  EXPORT_SYMBOL_GPL(vb2_queue_error);
>  
> -/**
> - * vb2_streamon - start streaming
> - * @q:		videobuf2 queue
> - * @type:	type argument passed from userspace to vidioc_streamon handler
> - *
> - * Should be called from vidioc_streamon handler of a driver.
> - * This function:
> - * 1) verifies current state
> - * 2) passes any previously queued buffers to the driver and starts streaming
> - *
> - * The return values from this function are intended to be directly returned
> - * from vidioc_streamon handler in the driver.
> - */
> -int vb2_streamon(struct vb2_queue *q, enum v4l2_buf_type type)
> -{
> -	if (vb2_fileio_is_active(q)) {
> -		dprintk(1, "file io in progress\n");
> -		return -EBUSY;
> -	}
> -	return vb2_internal_streamon(q, type);
> -}
> -EXPORT_SYMBOL_GPL(vb2_streamon);
> -
> -static int vb2_internal_streamoff(struct vb2_queue *q, enum v4l2_buf_type type)
> +int vb2_core_streamoff(struct vb2_queue *q)
>  {
> -	if (type != q->type) {
> -		dprintk(1, "invalid stream type\n");
> -		return -EINVAL;
> -	}
> -
>  	/*
>  	 * Cancel will pause streaming and remove all buffers from the driver
>  	 * and videobuf, effectively returning control over them to userspace.
> @@ -2390,37 +1775,13 @@ static int vb2_internal_streamoff(struct vb2_queue *q, enum v4l2_buf_type type)
>  	 * their normal dequeued state.
>  	 */
>  	__vb2_queue_cancel(q);
> -	q->waiting_for_buffers = !V4L2_TYPE_IS_OUTPUT(q->type);
> +	q->waiting_for_buffers = !q->is_output;
>  	q->last_buffer_dequeued = false;
>  
>  	dprintk(3, "successful\n");
>  	return 0;
>  }
> -
> -/**
> - * vb2_streamoff - stop streaming
> - * @q:		videobuf2 queue
> - * @type:	type argument passed from userspace to vidioc_streamoff handler
> - *
> - * Should be called from vidioc_streamoff handler of a driver.
> - * This function:
> - * 1) verifies current state,
> - * 2) stop streaming and dequeues any queued buffers, including those previously
> - *    passed to the driver (after waiting for the driver to finish).
> - *
> - * This call can be used for pausing playback.
> - * The return values from this function are intended to be directly returned
> - * from vidioc_streamoff handler in the driver
> - */
> -int vb2_streamoff(struct vb2_queue *q, enum v4l2_buf_type type)
> -{
> -	if (vb2_fileio_is_active(q)) {
> -		dprintk(1, "file io in progress\n");
> -		return -EBUSY;
> -	}
> -	return vb2_internal_streamoff(q, type);
> -}
> -EXPORT_SYMBOL_GPL(vb2_streamoff);
> +EXPORT_SYMBOL_GPL(vb2_core_streamoff);
>  
>  /**
>   * __find_plane_by_offset() - find plane associated with the given offset off
> @@ -2452,7 +1813,7 @@ static int __find_plane_by_offset(struct vb2_queue *q, unsigned long off,
>  }
>  
>  /**
> - * vb2_expbuf() - Export a buffer as a file descriptor
> + * vb2_core_expbuf() - Export a buffer as a file descriptor
>   * @q:		videobuf2 queue
>   * @eb:		export buffer structure passed from userspace to vidioc_expbuf
>   *		handler in driver
> @@ -2460,14 +1821,15 @@ static int __find_plane_by_offset(struct vb2_queue *q, unsigned long off,
>   * The return values from this function are intended to be directly returned
>   * from vidioc_expbuf handler in driver.
>   */
> -int vb2_expbuf(struct vb2_queue *q, struct v4l2_exportbuffer *eb)
> +int vb2_core_expbuf(struct vb2_queue *q, int *fd, unsigned int type,
> +		unsigned int index, unsigned int plane, unsigned int flags)
>  {
>  	struct vb2_buffer *vb = NULL;
>  	struct vb2_plane *vb_plane;
>  	int ret;
>  	struct dma_buf *dbuf;
>  
> -	if (q->memory != V4L2_MEMORY_MMAP) {
> +	if (q->memory != VB2_MEMORY_MMAP) {
>  		dprintk(1, "queue is not currently set up for mmap\n");
>  		return -EINVAL;
>  	}
> @@ -2477,78 +1839,60 @@ int vb2_expbuf(struct vb2_queue *q, struct v4l2_exportbuffer *eb)
>  		return -EINVAL;
>  	}
>  
> -	if (eb->flags & ~(O_CLOEXEC | O_ACCMODE)) {
> +	if (flags & ~(O_CLOEXEC | O_ACCMODE)) {
>  		dprintk(1, "queue does support only O_CLOEXEC and access mode flags\n");
>  		return -EINVAL;
>  	}
>  
> -	if (eb->type != q->type) {
> +	if (type != q->type) {
>  		dprintk(1, "invalid buffer type\n");
>  		return -EINVAL;
>  	}
>  
> -	if (eb->index >= q->num_buffers) {
> +	if (index >= q->num_buffers) {
>  		dprintk(1, "buffer index out of range\n");
>  		return -EINVAL;
>  	}
>  
> -	vb = q->bufs[eb->index];
> +	vb = q->bufs[index];
>  
> -	if (eb->plane >= vb->num_planes) {
> +	if (plane >= vb->num_planes) {
>  		dprintk(1, "buffer plane out of range\n");
>  		return -EINVAL;
>  	}
>  
> -	if (vb2_fileio_is_active(q)) {
> -		dprintk(1, "expbuf: file io in progress\n");
> -		return -EBUSY;
> -	}
> +	vb_plane = &vb->planes[plane];
>  
> -	vb_plane = &vb->planes[eb->plane];
> -
> -	dbuf = call_ptr_memop(vb, get_dmabuf, vb_plane->mem_priv, eb->flags & O_ACCMODE);
> +	dbuf = call_ptr_memop(vb, get_dmabuf, vb_plane->mem_priv,
> +				flags & O_ACCMODE);
>  	if (IS_ERR_OR_NULL(dbuf)) {
>  		dprintk(1, "failed to export buffer %d, plane %d\n",
> -			eb->index, eb->plane);
> +			index, plane);
>  		return -EINVAL;
>  	}
>  
> -	ret = dma_buf_fd(dbuf, eb->flags & ~O_ACCMODE);
> +	ret = dma_buf_fd(dbuf, flags & ~O_ACCMODE);
>  	if (ret < 0) {
>  		dprintk(3, "buffer %d, plane %d failed to export (%d)\n",
> -			eb->index, eb->plane, ret);
> +			index, plane, ret);
>  		dma_buf_put(dbuf);
>  		return ret;
>  	}
>  
>  	dprintk(3, "buffer %d, plane %d exported as %d descriptor\n",
> -		eb->index, eb->plane, ret);
> -	eb->fd = ret;
> +		index, plane, ret);
> +	*fd = ret;
>  
>  	return 0;
>  }
> -EXPORT_SYMBOL_GPL(vb2_expbuf);
> +EXPORT_SYMBOL_GPL(vb2_core_expbuf);
>  
>  /**
> - * vb2_mmap() - map video buffers into application address space
> + * vb2_core_mmap() - map video buffers into application address space
>   * @q:		videobuf2 queue
>   * @vma:	vma passed to the mmap file operation handler in the driver
> - *
> - * Should be called from mmap file operation handler of a driver.
> - * This function maps one plane of one of the available video buffers to
> - * userspace. To map whole video memory allocated on reqbufs, this function
> - * has to be called once per each plane per each buffer previously allocated.
> - *
> - * When the userspace application calls mmap, it passes to it an offset returned
> - * to it earlier by the means of vidioc_querybuf handler. That offset acts as
> - * a "cookie", which is then used to identify the plane to be mapped.
> - * This function finds a plane with a matching offset and a mapping is performed
> - * by the means of a provided memory operation.
> - *
> - * The return values from this function are intended to be directly returned
> - * from the mmap handler in driver.
>   */
> -int vb2_mmap(struct vb2_queue *q, struct vm_area_struct *vma)
> +int vb2_core_mmap(struct vb2_queue *q, struct vm_area_struct *vma)
>  {
>  	unsigned long off = vma->vm_pgoff << PAGE_SHIFT;
>  	struct vb2_buffer *vb;
> @@ -2556,7 +1900,7 @@ int vb2_mmap(struct vb2_queue *q, struct vm_area_struct *vma)
>  	int ret;
>  	unsigned long length;
>  
> -	if (q->memory != V4L2_MEMORY_MMAP) {
> +	if (q->memory != VB2_MEMORY_MMAP) {
>  		dprintk(1, "queue is not currently set up for mmap\n");
>  		return -EINVAL;
>  	}
> @@ -2568,7 +1912,7 @@ int vb2_mmap(struct vb2_queue *q, struct vm_area_struct *vma)
>  		dprintk(1, "invalid vma flags, VM_SHARED needed\n");
>  		return -EINVAL;
>  	}
> -	if (V4L2_TYPE_IS_OUTPUT(q->type)) {
> +	if (q->is_output) {
>  		if (!(vma->vm_flags & VM_WRITE)) {
>  			dprintk(1, "invalid vma flags, VM_WRITE needed\n");
>  			return -EINVAL;
> @@ -2579,10 +1923,6 @@ int vb2_mmap(struct vb2_queue *q, struct vm_area_struct *vma)
>  			return -EINVAL;
>  		}
>  	}
> -	if (vb2_fileio_is_active(q)) {
> -		dprintk(1, "mmap: file io in progress\n");
> -		return -EBUSY;
> -	}
>  
>  	/*
>  	 * Find the plane corresponding to the offset passed by userspace.
> @@ -2614,7 +1954,7 @@ int vb2_mmap(struct vb2_queue *q, struct vm_area_struct *vma)
>  	dprintk(3, "buffer %d, plane %d successfully mapped\n", buffer, plane);
>  	return 0;
>  }
> -EXPORT_SYMBOL_GPL(vb2_mmap);
> +EXPORT_SYMBOL_GPL(vb2_core_mmap);
>  
>  #ifndef CONFIG_MMU
>  unsigned long vb2_get_unmapped_area(struct vb2_queue *q,
> @@ -2629,7 +1969,7 @@ unsigned long vb2_get_unmapped_area(struct vb2_queue *q,
>  	void *vaddr;
>  	int ret;
>  
> -	if (q->memory != V4L2_MEMORY_MMAP) {
> +	if (q->memory != VB2_MEMORY_MMAP) {
>  		dprintk(1, "queue is not currently set up for mmap\n");
>  		return -EINVAL;
>  	}
> @@ -2649,123 +1989,8 @@ unsigned long vb2_get_unmapped_area(struct vb2_queue *q,
>  EXPORT_SYMBOL_GPL(vb2_get_unmapped_area);
>  #endif
>  
> -static int __vb2_init_fileio(struct vb2_queue *q, int read);
> -static int __vb2_cleanup_fileio(struct vb2_queue *q);
> -
> -/**
> - * vb2_poll() - implements poll userspace operation
> - * @q:		videobuf2 queue
> - * @file:	file argument passed to the poll file operation handler
> - * @wait:	wait argument passed to the poll file operation handler
> - *
> - * This function implements poll file operation handler for a driver.
> - * For CAPTURE queues, if a buffer is ready to be dequeued, the userspace will
> - * be informed that the file descriptor of a video device is available for
> - * reading.
> - * For OUTPUT queues, if a buffer is ready to be dequeued, the file descriptor
> - * will be reported as available for writing.
> - *
> - * If the driver uses struct v4l2_fh, then vb2_poll() will also check for any
> - * pending events.
> - *
> - * The return values from this function are intended to be directly returned
> - * from poll handler in driver.
> - */
> -unsigned int vb2_poll(struct vb2_queue *q, struct file *file, poll_table *wait)
> -{
> -	struct video_device *vfd = video_devdata(file);
> -	unsigned long req_events = poll_requested_events(wait);
> -	struct vb2_buffer *vb = NULL;
> -	unsigned int res = 0;
> -	unsigned long flags;
> -
> -	if (test_bit(V4L2_FL_USES_V4L2_FH, &vfd->flags)) {
> -		struct v4l2_fh *fh = file->private_data;
> -
> -		if (v4l2_event_pending(fh))
> -			res = POLLPRI;
> -		else if (req_events & POLLPRI)
> -			poll_wait(file, &fh->wait, wait);
> -	}
> -
> -	if (!V4L2_TYPE_IS_OUTPUT(q->type) && !(req_events & (POLLIN | POLLRDNORM)))
> -		return res;
> -	if (V4L2_TYPE_IS_OUTPUT(q->type) && !(req_events & (POLLOUT | POLLWRNORM)))
> -		return res;
> -
> -	/*
> -	 * Start file I/O emulator only if streaming API has not been used yet.
> -	 */
> -	if (q->num_buffers == 0 && !vb2_fileio_is_active(q)) {
> -		if (!V4L2_TYPE_IS_OUTPUT(q->type) && (q->io_modes & VB2_READ) &&
> -				(req_events & (POLLIN | POLLRDNORM))) {
> -			if (__vb2_init_fileio(q, 1))
> -				return res | POLLERR;
> -		}
> -		if (V4L2_TYPE_IS_OUTPUT(q->type) && (q->io_modes & VB2_WRITE) &&
> -				(req_events & (POLLOUT | POLLWRNORM))) {
> -			if (__vb2_init_fileio(q, 0))
> -				return res | POLLERR;
> -			/*
> -			 * Write to OUTPUT queue can be done immediately.
> -			 */
> -			return res | POLLOUT | POLLWRNORM;
> -		}
> -	}
> -
> -	/*
> -	 * There is nothing to wait for if the queue isn't streaming, or if the
> -	 * error flag is set.
> -	 */
> -	if (!vb2_is_streaming(q) || q->error)
> -		return res | POLLERR;
> -	/*
> -	 * For compatibility with vb1: if QBUF hasn't been called yet, then
> -	 * return POLLERR as well. This only affects capture queues, output
> -	 * queues will always initialize waiting_for_buffers to false.
> -	 */
> -	if (q->waiting_for_buffers)
> -		return res | POLLERR;
> -
> -	/*
> -	 * For output streams you can write as long as there are fewer buffers
> -	 * queued than there are buffers available.
> -	 */
> -	if (V4L2_TYPE_IS_OUTPUT(q->type) && q->queued_count < q->num_buffers)
> -		return res | POLLOUT | POLLWRNORM;
> -
> -	if (list_empty(&q->done_list)) {
> -		/*
> -		 * If the last buffer was dequeued from a capture queue,
> -		 * return immediately. DQBUF will return -EPIPE.
> -		 */
> -		if (q->last_buffer_dequeued)
> -			return res | POLLIN | POLLRDNORM;
> -
> -		poll_wait(file, &q->done_wq, wait);
> -	}
> -
> -	/*
> -	 * Take first buffer available for dequeuing.
> -	 */
> -	spin_lock_irqsave(&q->done_lock, flags);
> -	if (!list_empty(&q->done_list))
> -		vb = list_first_entry(&q->done_list, struct vb2_buffer,
> -					done_entry);
> -	spin_unlock_irqrestore(&q->done_lock, flags);
> -
> -	if (vb && (vb->state == VB2_BUF_STATE_DONE
> -			|| vb->state == VB2_BUF_STATE_ERROR)) {
> -		return (V4L2_TYPE_IS_OUTPUT(q->type)) ?
> -				res | POLLOUT | POLLWRNORM :
> -				res | POLLIN | POLLRDNORM;
> -	}
> -	return res;
> -}
> -EXPORT_SYMBOL_GPL(vb2_poll);
> -
>  /**
> - * vb2_queue_init() - initialize a videobuf2 queue
> + * vb2_core_queue_init() - initialize a videobuf2 queue
>   * @q:		videobuf2 queue; this structure should be allocated in driver
>   *
>   * The vb2_queue structure should be allocated by the driver. The driver is
> @@ -2775,7 +2000,7 @@ EXPORT_SYMBOL_GPL(vb2_poll);
>   * to the struct vb2_queue description in include/media/videobuf2-core.h
>   * for more information.
>   */
> -int vb2_queue_init(struct vb2_queue *q)
> +int vb2_core_queue_init(struct vb2_queue *q)
>  {
>  	/*
>  	 * Sanity check
> @@ -2783,19 +2008,13 @@ int vb2_queue_init(struct vb2_queue *q)
>  	if (WARN_ON(!q)				||
>  		WARN_ON(!q->ops)		||
>  		WARN_ON(!q->mem_ops)		||
> +		WARN_ON(!q->buf_ops)		||
>  		WARN_ON(!q->type)		||
>  		WARN_ON(!q->io_modes)		||
>  		WARN_ON(!q->ops->queue_setup)	||
> -		WARN_ON(!q->ops->buf_queue)	||
> -		WARN_ON(q->timestamp_flags &
> -			~(V4L2_BUF_FLAG_TIMESTAMP_MASK |
> -			V4L2_BUF_FLAG_TSTAMP_SRC_MASK)))
> +		WARN_ON(!q->ops->buf_queue))
>  		return -EINVAL;
>  
> -	/* Warn that the driver should choose an appropriate timestamp type */
> -	WARN_ON((q->timestamp_flags & V4L2_BUF_FLAG_TIMESTAMP_MASK) ==
> -		V4L2_BUF_FLAG_TIMESTAMP_UNKNOWN);
> -
>  	INIT_LIST_HEAD(&q->queued_list);
>  	INIT_LIST_HEAD(&q->done_list);
>  	spin_lock_init(&q->done_lock);
> @@ -2807,822 +2026,24 @@ int vb2_queue_init(struct vb2_queue *q)
>  
>  	return 0;
>  }
> -EXPORT_SYMBOL_GPL(vb2_queue_init);
> +EXPORT_SYMBOL_GPL(vb2_core_queue_init);
>  
>  /**
> - * vb2_queue_release() - stop streaming, release the queue and free memory
> + * vb2_core_queue_release() - stop streaming, release the queue and free memory
>   * @q:		videobuf2 queue
>   *
>   * This function stops streaming and performs necessary clean ups, including
>   * freeing video buffer memory. The driver is responsible for freeing
>   * the vb2_queue structure itself.
>   */
> -void vb2_queue_release(struct vb2_queue *q)
> +void vb2_core_queue_release(struct vb2_queue *q)
>  {
> -	__vb2_cleanup_fileio(q);
>  	__vb2_queue_cancel(q);
>  	mutex_lock(&q->mmap_lock);
>  	__vb2_queue_free(q, q->num_buffers);
>  	mutex_unlock(&q->mmap_lock);
>  }
> -EXPORT_SYMBOL_GPL(vb2_queue_release);
> -
> -/**
> - * struct vb2_fileio_buf - buffer context used by file io emulator
> - *
> - * vb2 provides a compatibility layer and emulator of file io (read and
> - * write) calls on top of streaming API. This structure is used for
> - * tracking context related to the buffers.
> - */
> -struct vb2_fileio_buf {
> -	void *vaddr;
> -	unsigned int size;
> -	unsigned int pos;
> -	unsigned int queued:1;
> -};
> -
> -/**
> - * struct vb2_fileio_data - queue context used by file io emulator
> - *
> - * @cur_index:	the index of the buffer currently being read from or
> - *		written to. If equal to q->num_buffers then a new buffer
> - *		must be dequeued.
> - * @initial_index: in the read() case all buffers are queued up immediately
> - *		in __vb2_init_fileio() and __vb2_perform_fileio() just cycles
> - *		buffers. However, in the write() case no buffers are initially
> - *		queued, instead whenever a buffer is full it is queued up by
> - *		__vb2_perform_fileio(). Only once all available buffers have
> - *		been queued up will __vb2_perform_fileio() start to dequeue
> - *		buffers. This means that initially __vb2_perform_fileio()
> - *		needs to know what buffer index to use when it is queuing up
> - *		the buffers for the first time. That initial index is stored
> - *		in this field. Once it is equal to q->num_buffers all
> - *		available buffers have been queued and __vb2_perform_fileio()
> - *		should start the normal dequeue/queue cycle.
> - *
> - * vb2 provides a compatibility layer and emulator of file io (read and
> - * write) calls on top of streaming API. For proper operation it required
> - * this structure to save the driver state between each call of the read
> - * or write function.
> - */
> -struct vb2_fileio_data {
> -	struct v4l2_requestbuffers req;
> -	struct v4l2_plane p;
> -	struct v4l2_buffer b;
> -	struct vb2_fileio_buf bufs[VIDEO_MAX_FRAME];
> -	unsigned int cur_index;
> -	unsigned int initial_index;
> -	unsigned int q_count;
> -	unsigned int dq_count;
> -	unsigned read_once:1;
> -	unsigned write_immediately:1;
> -};
> -
> -/**
> - * __vb2_init_fileio() - initialize file io emulator
> - * @q:		videobuf2 queue
> - * @read:	mode selector (1 means read, 0 means write)
> - */
> -static int __vb2_init_fileio(struct vb2_queue *q, int read)
> -{
> -	struct vb2_fileio_data *fileio;
> -	int i, ret;
> -	unsigned int count = 0;
> -
> -	/*
> -	 * Sanity check
> -	 */
> -	if (WARN_ON((read && !(q->io_modes & VB2_READ)) ||
> -			(!read && !(q->io_modes & VB2_WRITE))))
> -		return -EINVAL;
> -
> -	/*
> -	 * Check if device supports mapping buffers to kernel virtual space.
> -	 */
> -	if (!q->mem_ops->vaddr)
> -		return -EBUSY;
> -
> -	/*
> -	 * Check if streaming api has not been already activated.
> -	 */
> -	if (q->streaming || q->num_buffers > 0)
> -		return -EBUSY;
> -
> -	/*
> -	 * Start with count 1, driver can increase it in queue_setup()
> -	 */
> -	count = 1;
> -
> -	dprintk(3, "setting up file io: mode %s, count %d, read_once %d, write_immediately %d\n",
> -		(read) ? "read" : "write", count, q->fileio_read_once,
> -		q->fileio_write_immediately);
> -
> -	fileio = kzalloc(sizeof(struct vb2_fileio_data), GFP_KERNEL);
> -	if (fileio == NULL)
> -		return -ENOMEM;
> -
> -	fileio->read_once = q->fileio_read_once;
> -	fileio->write_immediately = q->fileio_write_immediately;
> -
> -	/*
> -	 * Request buffers and use MMAP type to force driver
> -	 * to allocate buffers by itself.
> -	 */
> -	fileio->req.count = count;
> -	fileio->req.memory = V4L2_MEMORY_MMAP;
> -	fileio->req.type = q->type;
> -	q->fileio = fileio;
> -	ret = __reqbufs(q, &fileio->req);
> -	if (ret)
> -		goto err_kfree;
> -
> -	/*
> -	 * Check if plane_count is correct
> -	 * (multiplane buffers are not supported).
> -	 */
> -	if (q->bufs[0]->num_planes != 1) {
> -		ret = -EBUSY;
> -		goto err_reqbufs;
> -	}
> -
> -	/*
> -	 * Get kernel address of each buffer.
> -	 */
> -	for (i = 0; i < q->num_buffers; i++) {
> -		fileio->bufs[i].vaddr = vb2_plane_vaddr(q->bufs[i], 0);
> -		if (fileio->bufs[i].vaddr == NULL) {
> -			ret = -EINVAL;
> -			goto err_reqbufs;
> -		}
> -		fileio->bufs[i].size = vb2_plane_size(q->bufs[i], 0);
> -	}
> -
> -	/*
> -	 * Read mode requires pre queuing of all buffers.
> -	 */
> -	if (read) {
> -		bool is_multiplanar = V4L2_TYPE_IS_MULTIPLANAR(q->type);
> -
> -		/*
> -		 * Queue all buffers.
> -		 */
> -		for (i = 0; i < q->num_buffers; i++) {
> -			struct v4l2_buffer *b = &fileio->b;
> -
> -			memset(b, 0, sizeof(*b));
> -			b->type = q->type;
> -			if (is_multiplanar) {
> -				memset(&fileio->p, 0, sizeof(fileio->p));
> -				b->m.planes = &fileio->p;
> -				b->length = 1;
> -			}
> -			b->memory = q->memory;
> -			b->index = i;
> -			ret = vb2_internal_qbuf(q, b);
> -			if (ret)
> -				goto err_reqbufs;
> -			fileio->bufs[i].queued = 1;
> -		}
> -		/*
> -		 * All buffers have been queued, so mark that by setting
> -		 * initial_index to q->num_buffers
> -		 */
> -		fileio->initial_index = q->num_buffers;
> -		fileio->cur_index = q->num_buffers;
> -	}
> -
> -	/*
> -	 * Start streaming.
> -	 */
> -	ret = vb2_internal_streamon(q, q->type);
> -	if (ret)
> -		goto err_reqbufs;
> -
> -	return ret;
> -
> -err_reqbufs:
> -	fileio->req.count = 0;
> -	__reqbufs(q, &fileio->req);
> -
> -err_kfree:
> -	q->fileio = NULL;
> -	kfree(fileio);
> -	return ret;
> -}
> -
> -/**
> - * __vb2_cleanup_fileio() - free resourced used by file io emulator
> - * @q:		videobuf2 queue
> - */
> -static int __vb2_cleanup_fileio(struct vb2_queue *q)
> -{
> -	struct vb2_fileio_data *fileio = q->fileio;
> -
> -	if (fileio) {
> -		vb2_internal_streamoff(q, q->type);
> -		q->fileio = NULL;
> -		fileio->req.count = 0;
> -		vb2_reqbufs(q, &fileio->req);
> -		kfree(fileio);
> -		dprintk(3, "file io emulator closed\n");
> -	}
> -	return 0;
> -}
> -
> -/**
> - * __vb2_perform_fileio() - perform a single file io (read or write) operation
> - * @q:		videobuf2 queue
> - * @data:	pointed to target userspace buffer
> - * @count:	number of bytes to read or write
> - * @ppos:	file handle position tracking pointer
> - * @nonblock:	mode selector (1 means blocking calls, 0 means nonblocking)
> - * @read:	access mode selector (1 means read, 0 means write)
> - */
> -static size_t __vb2_perform_fileio(struct vb2_queue *q, char __user *data, size_t count,
> -		loff_t *ppos, int nonblock, int read)
> -{
> -	struct vb2_fileio_data *fileio;
> -	struct vb2_fileio_buf *buf;
> -	bool is_multiplanar = V4L2_TYPE_IS_MULTIPLANAR(q->type);
> -	/*
> -	 * When using write() to write data to an output video node the vb2 core
> -	 * should set timestamps if V4L2_BUF_FLAG_TIMESTAMP_COPY is set. Nobody
> -	 * else is able to provide this information with the write() operation.
> -	 */
> -	bool set_timestamp = !read &&
> -		(q->timestamp_flags & V4L2_BUF_FLAG_TIMESTAMP_MASK) ==
> -		V4L2_BUF_FLAG_TIMESTAMP_COPY;
> -	int ret, index;
> -
> -	dprintk(3, "mode %s, offset %ld, count %zd, %sblocking\n",
> -		read ? "read" : "write", (long)*ppos, count,
> -		nonblock ? "non" : "");
> -
> -	if (!data)
> -		return -EINVAL;
> -
> -	/*
> -	 * Initialize emulator on first call.
> -	 */
> -	if (!vb2_fileio_is_active(q)) {
> -		ret = __vb2_init_fileio(q, read);
> -		dprintk(3, "vb2_init_fileio result: %d\n", ret);
> -		if (ret)
> -			return ret;
> -	}
> -	fileio = q->fileio;
> -
> -	/*
> -	 * Check if we need to dequeue the buffer.
> -	 */
> -	index = fileio->cur_index;
> -	if (index >= q->num_buffers) {
> -		/*
> -		 * Call vb2_dqbuf to get buffer back.
> -		 */
> -		memset(&fileio->b, 0, sizeof(fileio->b));
> -		fileio->b.type = q->type;
> -		fileio->b.memory = q->memory;
> -		if (is_multiplanar) {
> -			memset(&fileio->p, 0, sizeof(fileio->p));
> -			fileio->b.m.planes = &fileio->p;
> -			fileio->b.length = 1;
> -		}
> -		ret = vb2_internal_dqbuf(q, &fileio->b, nonblock);
> -		dprintk(5, "vb2_dqbuf result: %d\n", ret);
> -		if (ret)
> -			return ret;
> -		fileio->dq_count += 1;
> -
> -		fileio->cur_index = index = fileio->b.index;
> -		buf = &fileio->bufs[index];
> -
> -		/*
> -		 * Get number of bytes filled by the driver
> -		 */
> -		buf->pos = 0;
> -		buf->queued = 0;
> -		buf->size = read ? vb2_get_plane_payload(q->bufs[index], 0)
> -				 : vb2_plane_size(q->bufs[index], 0);
> -		/*
> -		 * Compensate for data_offset on read
> -		 * in the multiplanar case
> -		 */
> -		if (is_multiplanar && read &&
> -			fileio->b.m.planes[0].data_offset < buf->size) {
> -			buf->pos = fileio->b.m.planes[0].data_offset;
> -			buf->size -= buf->pos;
> -		}
> -	} else {
> -		buf = &fileio->bufs[index];
> -	}
> -
> -	/*
> -	 * Limit count on last few bytes of the buffer.
> -	 */
> -	if (buf->pos + count > buf->size) {
> -		count = buf->size - buf->pos;
> -		dprintk(5, "reducing read count: %zd\n", count);
> -	}
> -
> -	/*
> -	 * Transfer data to userspace.
> -	 */
> -	dprintk(3, "copying %zd bytes - buffer %d, offset %u\n",
> -		count, index, buf->pos);
> -	if (read)
> -		ret = copy_to_user(data, buf->vaddr + buf->pos, count);
> -	else
> -		ret = copy_from_user(buf->vaddr + buf->pos, data, count);
> -	if (ret) {
> -		dprintk(3, "error copying data\n");
> -		return -EFAULT;
> -	}
> -
> -	/*
> -	 * Update counters.
> -	 */
> -	buf->pos += count;
> -	*ppos += count;
> -
> -	/*
> -	 * Queue next buffer if required.
> -	 */
> -	if (buf->pos == buf->size || (!read && fileio->write_immediately)) {
> -		/*
> -		 * Check if this is the last buffer to read.
> -		 */
> -		if (read && fileio->read_once && fileio->dq_count == 1) {
> -			dprintk(3, "read limit reached\n");
> -			return __vb2_cleanup_fileio(q);
> -		}
> -
> -		/*
> -		 * Call vb2_qbuf and give buffer to the driver.
> -		 */
> -		memset(&fileio->b, 0, sizeof(fileio->b));
> -		fileio->b.type = q->type;
> -		fileio->b.memory = q->memory;
> -		fileio->b.index = index;
> -		fileio->b.bytesused = buf->pos;
> -		if (is_multiplanar) {
> -			memset(&fileio->p, 0, sizeof(fileio->p));
> -			fileio->p.bytesused = buf->pos;
> -			fileio->b.m.planes = &fileio->p;
> -			fileio->b.length = 1;
> -		}
> -		if (set_timestamp)
> -			v4l2_get_timestamp(&fileio->b.timestamp);
> -		ret = vb2_internal_qbuf(q, &fileio->b);
> -		dprintk(5, "vb2_dbuf result: %d\n", ret);
> -		if (ret)
> -			return ret;
> -
> -		/*
> -		 * Buffer has been queued, update the status
> -		 */
> -		buf->pos = 0;
> -		buf->queued = 1;
> -		buf->size = vb2_plane_size(q->bufs[index], 0);
> -		fileio->q_count += 1;
> -		/*
> -		 * If we are queuing up buffers for the first time, then
> -		 * increase initial_index by one.
> -		 */
> -		if (fileio->initial_index < q->num_buffers)
> -			fileio->initial_index++;
> -		/*
> -		 * The next buffer to use is either a buffer that's going to be
> -		 * queued for the first time (initial_index < q->num_buffers)
> -		 * or it is equal to q->num_buffers, meaning that the next
> -		 * time we need to dequeue a buffer since we've now queued up
> -		 * all the 'first time' buffers.
> -		 */
> -		fileio->cur_index = fileio->initial_index;
> -	}
> -
> -	/*
> -	 * Return proper number of bytes processed.
> -	 */
> -	if (ret == 0)
> -		ret = count;
> -	return ret;
> -}
> -
> -size_t vb2_read(struct vb2_queue *q, char __user *data, size_t count,
> -		loff_t *ppos, int nonblocking)
> -{
> -	return __vb2_perform_fileio(q, data, count, ppos, nonblocking, 1);
> -}
> -EXPORT_SYMBOL_GPL(vb2_read);
> -
> -size_t vb2_write(struct vb2_queue *q, const char __user *data, size_t count,
> -		loff_t *ppos, int nonblocking)
> -{
> -	return __vb2_perform_fileio(q, (char __user *) data, count,
> -							ppos, nonblocking, 0);
> -}
> -EXPORT_SYMBOL_GPL(vb2_write);
> -
> -struct vb2_threadio_data {
> -	struct task_struct *thread;
> -	vb2_thread_fnc fnc;
> -	void *priv;
> -	bool stop;
> -};
> -
> -static int vb2_thread(void *data)
> -{
> -	struct vb2_queue *q = data;
> -	struct vb2_threadio_data *threadio = q->threadio;
> -	struct vb2_fileio_data *fileio = q->fileio;
> -	bool set_timestamp = false;
> -	int prequeue = 0;
> -	int index = 0;
> -	int ret = 0;
> -
> -	if (V4L2_TYPE_IS_OUTPUT(q->type)) {
> -		prequeue = q->num_buffers;
> -		set_timestamp =
> -			(q->timestamp_flags & V4L2_BUF_FLAG_TIMESTAMP_MASK) ==
> -			V4L2_BUF_FLAG_TIMESTAMP_COPY;
> -	}
> -
> -	set_freezable();
> -
> -	for (;;) {
> -		struct vb2_buffer *vb;
> -
> -		/*
> -		 * Call vb2_dqbuf to get buffer back.
> -		 */
> -		memset(&fileio->b, 0, sizeof(fileio->b));
> -		fileio->b.type = q->type;
> -		fileio->b.memory = q->memory;
> -		if (prequeue) {
> -			fileio->b.index = index++;
> -			prequeue--;
> -		} else {
> -			call_void_qop(q, wait_finish, q);
> -			if (!threadio->stop)
> -				ret = vb2_internal_dqbuf(q, &fileio->b, 0);
> -			call_void_qop(q, wait_prepare, q);
> -			dprintk(5, "file io: vb2_dqbuf result: %d\n", ret);
> -		}
> -		if (ret || threadio->stop)
> -			break;
> -		try_to_freeze();
> -
> -		vb = q->bufs[fileio->b.index];
> -		if (!(fileio->b.flags & V4L2_BUF_FLAG_ERROR))
> -			if (threadio->fnc(vb, threadio->priv))
> -				break;
> -		call_void_qop(q, wait_finish, q);
> -		if (set_timestamp)
> -			v4l2_get_timestamp(&fileio->b.timestamp);
> -		if (!threadio->stop)
> -			ret = vb2_internal_qbuf(q, &fileio->b);
> -		call_void_qop(q, wait_prepare, q);
> -		if (ret || threadio->stop)
> -			break;
> -	}
> -
> -	/* Hmm, linux becomes *very* unhappy without this ... */
> -	while (!kthread_should_stop()) {
> -		set_current_state(TASK_INTERRUPTIBLE);
> -		schedule();
> -	}
> -	return 0;
> -}
> -
> -/*
> - * This function should not be used for anything else but the videobuf2-dvb
> - * support. If you think you have another good use-case for this, then please
> - * contact the linux-media mailinglist first.
> - */
> -int vb2_thread_start(struct vb2_queue *q, vb2_thread_fnc fnc, void *priv,
> -			const char *thread_name)
> -{
> -	struct vb2_threadio_data *threadio;
> -	int ret = 0;
> -
> -	if (q->threadio)
> -		return -EBUSY;
> -	if (vb2_is_busy(q))
> -		return -EBUSY;
> -	if (WARN_ON(q->fileio))
> -		return -EBUSY;
> -
> -	threadio = kzalloc(sizeof(*threadio), GFP_KERNEL);
> -	if (threadio == NULL)
> -		return -ENOMEM;
> -	threadio->fnc = fnc;
> -	threadio->priv = priv;
> -
> -	ret = __vb2_init_fileio(q, !V4L2_TYPE_IS_OUTPUT(q->type));
> -	dprintk(3, "file io: vb2_init_fileio result: %d\n", ret);
> -	if (ret)
> -		goto nomem;
> -	q->threadio = threadio;
> -	threadio->thread = kthread_run(vb2_thread, q, "vb2-%s", thread_name);
> -	if (IS_ERR(threadio->thread)) {
> -		ret = PTR_ERR(threadio->thread);
> -		threadio->thread = NULL;
> -		goto nothread;
> -	}
> -	return 0;
> -
> -nothread:
> -	__vb2_cleanup_fileio(q);
> -nomem:
> -	kfree(threadio);
> -	return ret;
> -}
> -EXPORT_SYMBOL_GPL(vb2_thread_start);
> -
> -int vb2_thread_stop(struct vb2_queue *q)
> -{
> -	struct vb2_threadio_data *threadio = q->threadio;
> -	int err;
> -
> -	if (threadio == NULL)
> -		return 0;
> -	threadio->stop = true;
> -	/* Wake up all pending sleeps in the thread */
> -	vb2_queue_error(q);
> -	err = kthread_stop(threadio->thread);
> -	__vb2_cleanup_fileio(q);
> -	threadio->thread = NULL;
> -	kfree(threadio);
> -	q->threadio = NULL;
> -	return err;
> -}
> -EXPORT_SYMBOL_GPL(vb2_thread_stop);
> -
> -/*
> - * The following functions are not part of the vb2 core API, but are helper
> - * functions that plug into struct v4l2_ioctl_ops, struct v4l2_file_operations
> - * and struct vb2_ops.
> - * They contain boilerplate code that most if not all drivers have to do
> - * and so they simplify the driver code.
> - */
> -
> -/* The queue is busy if there is a owner and you are not that owner. */
> -static inline bool vb2_queue_is_busy(struct video_device *vdev, struct file *file)
> -{
> -	return vdev->queue->owner && vdev->queue->owner != file->private_data;
> -}
> -
> -/* vb2 ioctl helpers */
> -
> -int vb2_ioctl_reqbufs(struct file *file, void *priv,
> -			  struct v4l2_requestbuffers *p)
> -{
> -	struct video_device *vdev = video_devdata(file);
> -	int res = __verify_memory_type(vdev->queue, p->memory, p->type);
> -
> -	if (res)
> -		return res;
> -	if (vb2_queue_is_busy(vdev, file))
> -		return -EBUSY;
> -	res = __reqbufs(vdev->queue, p);
> -	/* If count == 0, then the owner has released all buffers and he
> -	   is no longer owner of the queue. Otherwise we have a new owner. */
> -	if (res == 0)
> -		vdev->queue->owner = p->count ? file->private_data : NULL;
> -	return res;
> -}
> -EXPORT_SYMBOL_GPL(vb2_ioctl_reqbufs);
> -
> -int vb2_ioctl_create_bufs(struct file *file, void *priv,
> -			  struct v4l2_create_buffers *p)
> -{
> -	struct video_device *vdev = video_devdata(file);
> -	int res = __verify_memory_type(vdev->queue, p->memory, p->format.type);
> -
> -	p->index = vdev->queue->num_buffers;
> -	/* If count == 0, then just check if memory and type are valid.
> -	   Any -EBUSY result from __verify_memory_type can be mapped to 0. */
> -	if (p->count == 0)
> -		return res != -EBUSY ? res : 0;
> -	if (res)
> -		return res;
> -	if (vb2_queue_is_busy(vdev, file))
> -		return -EBUSY;
> -	res = __create_bufs(vdev->queue, p);
> -	if (res == 0)
> -		vdev->queue->owner = file->private_data;
> -	return res;
> -}
> -EXPORT_SYMBOL_GPL(vb2_ioctl_create_bufs);
> -
> -int vb2_ioctl_prepare_buf(struct file *file, void *priv,
> -			  struct v4l2_buffer *p)
> -{
> -	struct video_device *vdev = video_devdata(file);
> -
> -	if (vb2_queue_is_busy(vdev, file))
> -		return -EBUSY;
> -	return vb2_prepare_buf(vdev->queue, p);
> -}
> -EXPORT_SYMBOL_GPL(vb2_ioctl_prepare_buf);
> -
> -int vb2_ioctl_querybuf(struct file *file, void *priv, struct v4l2_buffer *p)
> -{
> -	struct video_device *vdev = video_devdata(file);
> -
> -	/* No need to call vb2_queue_is_busy(), anyone can query buffers. */
> -	return vb2_querybuf(vdev->queue, p);
> -}
> -EXPORT_SYMBOL_GPL(vb2_ioctl_querybuf);
> -
> -int vb2_ioctl_qbuf(struct file *file, void *priv, struct v4l2_buffer *p)
> -{
> -	struct video_device *vdev = video_devdata(file);
> -
> -	if (vb2_queue_is_busy(vdev, file))
> -		return -EBUSY;
> -	return vb2_qbuf(vdev->queue, p);
> -}
> -EXPORT_SYMBOL_GPL(vb2_ioctl_qbuf);
> -
> -int vb2_ioctl_dqbuf(struct file *file, void *priv, struct v4l2_buffer *p)
> -{
> -	struct video_device *vdev = video_devdata(file);
> -
> -	if (vb2_queue_is_busy(vdev, file))
> -		return -EBUSY;
> -	return vb2_dqbuf(vdev->queue, p, file->f_flags & O_NONBLOCK);
> -}
> -EXPORT_SYMBOL_GPL(vb2_ioctl_dqbuf);
> -
> -int vb2_ioctl_streamon(struct file *file, void *priv, enum v4l2_buf_type i)
> -{
> -	struct video_device *vdev = video_devdata(file);
> -
> -	if (vb2_queue_is_busy(vdev, file))
> -		return -EBUSY;
> -	return vb2_streamon(vdev->queue, i);
> -}
> -EXPORT_SYMBOL_GPL(vb2_ioctl_streamon);
> -
> -int vb2_ioctl_streamoff(struct file *file, void *priv, enum v4l2_buf_type i)
> -{
> -	struct video_device *vdev = video_devdata(file);
> -
> -	if (vb2_queue_is_busy(vdev, file))
> -		return -EBUSY;
> -	return vb2_streamoff(vdev->queue, i);
> -}
> -EXPORT_SYMBOL_GPL(vb2_ioctl_streamoff);
> -
> -int vb2_ioctl_expbuf(struct file *file, void *priv, struct v4l2_exportbuffer *p)
> -{
> -	struct video_device *vdev = video_devdata(file);
> -
> -	if (vb2_queue_is_busy(vdev, file))
> -		return -EBUSY;
> -	return vb2_expbuf(vdev->queue, p);
> -}
> -EXPORT_SYMBOL_GPL(vb2_ioctl_expbuf);
> -
> -/* v4l2_file_operations helpers */
> -
> -int vb2_fop_mmap(struct file *file, struct vm_area_struct *vma)
> -{
> -	struct video_device *vdev = video_devdata(file);
> -
> -	return vb2_mmap(vdev->queue, vma);
> -}
> -EXPORT_SYMBOL_GPL(vb2_fop_mmap);
> -
> -int _vb2_fop_release(struct file *file, struct mutex *lock)
> -{
> -	struct video_device *vdev = video_devdata(file);
> -
> -	if (lock)
> -		mutex_lock(lock);
> -	if (file->private_data == vdev->queue->owner) {
> -		vb2_queue_release(vdev->queue);
> -		vdev->queue->owner = NULL;
> -	}
> -	if (lock)
> -		mutex_unlock(lock);
> -	return v4l2_fh_release(file);
> -}
> -EXPORT_SYMBOL_GPL(_vb2_fop_release);
> -
> -int vb2_fop_release(struct file *file)
> -{
> -	struct video_device *vdev = video_devdata(file);
> -	struct mutex *lock = vdev->queue->lock ? vdev->queue->lock : vdev->lock;
> -
> -	return _vb2_fop_release(file, lock);
> -}
> -EXPORT_SYMBOL_GPL(vb2_fop_release);
> -
> -ssize_t vb2_fop_write(struct file *file, const char __user *buf,
> -		size_t count, loff_t *ppos)
> -{
> -	struct video_device *vdev = video_devdata(file);
> -	struct mutex *lock = vdev->queue->lock ? vdev->queue->lock : vdev->lock;
> -	int err = -EBUSY;
> -
> -	if (!(vdev->queue->io_modes & VB2_WRITE))
> -		return -EINVAL;
> -	if (lock && mutex_lock_interruptible(lock))
> -		return -ERESTARTSYS;
> -	if (vb2_queue_is_busy(vdev, file))
> -		goto exit;
> -	err = vb2_write(vdev->queue, buf, count, ppos,
> -			file->f_flags & O_NONBLOCK);
> -	if (vdev->queue->fileio)
> -		vdev->queue->owner = file->private_data;
> -exit:
> -	if (lock)
> -		mutex_unlock(lock);
> -	return err;
> -}
> -EXPORT_SYMBOL_GPL(vb2_fop_write);
> -
> -ssize_t vb2_fop_read(struct file *file, char __user *buf,
> -		size_t count, loff_t *ppos)
> -{
> -	struct video_device *vdev = video_devdata(file);
> -	struct mutex *lock = vdev->queue->lock ? vdev->queue->lock : vdev->lock;
> -	int err = -EBUSY;
> -
> -	if (!(vdev->queue->io_modes & VB2_READ))
> -		return -EINVAL;
> -	if (lock && mutex_lock_interruptible(lock))
> -		return -ERESTARTSYS;
> -	if (vb2_queue_is_busy(vdev, file))
> -		goto exit;
> -	err = vb2_read(vdev->queue, buf, count, ppos,
> -			file->f_flags & O_NONBLOCK);
> -	if (vdev->queue->fileio)
> -		vdev->queue->owner = file->private_data;
> -exit:
> -	if (lock)
> -		mutex_unlock(lock);
> -	return err;
> -}
> -EXPORT_SYMBOL_GPL(vb2_fop_read);
> -
> -unsigned int vb2_fop_poll(struct file *file, poll_table *wait)
> -{
> -	struct video_device *vdev = video_devdata(file);
> -	struct vb2_queue *q = vdev->queue;
> -	struct mutex *lock = q->lock ? q->lock : vdev->lock;
> -	unsigned res;
> -	void *fileio;
> -
> -	/*
> -	 * If this helper doesn't know how to lock, then you shouldn't be using
> -	 * it but you should write your own.
> -	 */
> -	WARN_ON(!lock);
> -
> -	if (lock && mutex_lock_interruptible(lock))
> -		return POLLERR;
> -
> -	fileio = q->fileio;
> -
> -	res = vb2_poll(vdev->queue, file, wait);
> -
> -	/* If fileio was started, then we have a new queue owner. */
> -	if (!fileio && q->fileio)
> -		q->owner = file->private_data;
> -	if (lock)
> -		mutex_unlock(lock);
> -	return res;
> -}
> -EXPORT_SYMBOL_GPL(vb2_fop_poll);
> -
> -#ifndef CONFIG_MMU
> -unsigned long vb2_fop_get_unmapped_area(struct file *file, unsigned long addr,
> -		unsigned long len, unsigned long pgoff, unsigned long flags)
> -{
> -	struct video_device *vdev = video_devdata(file);
> -
> -	return vb2_get_unmapped_area(vdev->queue, addr, len, pgoff, flags);
> -}
> -EXPORT_SYMBOL_GPL(vb2_fop_get_unmapped_area);
> -#endif
> -
> -/* vb2_ops helpers. Only use if vq->lock is non-NULL. */
> -
> -void vb2_ops_wait_prepare(struct vb2_queue *vq)
> -{
> -	mutex_unlock(vq->lock);
> -}
> -EXPORT_SYMBOL_GPL(vb2_ops_wait_prepare);
> -
> -void vb2_ops_wait_finish(struct vb2_queue *vq)
> -{
> -	mutex_lock(vq->lock);
> -}
> -EXPORT_SYMBOL_GPL(vb2_ops_wait_finish);
> +EXPORT_SYMBOL_GPL(vb2_core_queue_release);
>  
>  MODULE_DESCRIPTION("Driver helper framework for Video for Linux 2");
>  MODULE_AUTHOR("Pawel Osciak <pawel@osciak.com>, Marek Szyprowski");
> diff --git a/drivers/media/v4l2-core/videobuf2-internal.h b/drivers/media/v4l2-core/videobuf2-internal.h
> new file mode 100644
> index 0000000..3998ac9
> --- /dev/null
> +++ b/drivers/media/v4l2-core/videobuf2-internal.h
> @@ -0,0 +1,184 @@
> +#ifndef _MEDIA_VIDEOBUF2_INTERNAL_H
> +#define _MEDIA_VIDEOBUF2_INTERNAL_H
> +
> +#include <linux/err.h>
> +#include <linux/kernel.h>
> +#include <linux/module.h>
> +#include <media/videobuf2-core.h>
> +
> +extern int vb2_debug;
> +
> +#define dprintk(level, fmt, arg...)					\
> +	do {								\
> +		if (vb2_debug >= level)					\
> +			pr_info("vb2: %s: " fmt, __func__, ## arg);	\
> +	} while (0)
> +
> +#ifdef CONFIG_VIDEO_ADV_DEBUG
> +
> +/*
> + * If advanced debugging is on, then count how often each op is called
> + * successfully, which can either be per-buffer or per-queue.
> + *
> + * This makes it easy to check that the 'init' and 'cleanup'
> + * (and variations thereof) stay balanced.
> + */
> +
> +#define log_memop(vb, op)						\
> +	dprintk(2, "call_memop(%p, %d, %s)%s\n",			\
> +		(vb)->vb2_queue, (vb)->index, #op,			\
> +		(vb)->vb2_queue->mem_ops->op ? "" : " (nop)")
> +
> +#define call_memop(vb, op, args...)					\
> +({									\
> +	struct vb2_queue *_q = (vb)->vb2_queue;				\
> +	int err;							\
> +									\
> +	log_memop(vb, op);						\
> +	err = _q->mem_ops->op ? _q->mem_ops->op(args) : 0;		\
> +	if (!err)							\
> +		(vb)->cnt_mem_ ## op++;					\
> +	err;								\
> +})
> +
> +#define call_ptr_memop(vb, op, args...)					\
> +({									\
> +	struct vb2_queue *_q = (vb)->vb2_queue;				\
> +	void *ptr;							\
> +									\
> +	log_memop(vb, op);						\
> +	ptr = _q->mem_ops->op ? _q->mem_ops->op(args) : NULL;		\
> +	if (!IS_ERR_OR_NULL(ptr))					\
> +		(vb)->cnt_mem_ ## op++;					\
> +	ptr;								\
> +})
> +
> +#define call_void_memop(vb, op, args...)				\
> +({									\
> +	struct vb2_queue *_q = (vb)->vb2_queue;				\
> +									\
> +	log_memop(vb, op);						\
> +	if (_q->mem_ops->op)						\
> +		_q->mem_ops->op(args);					\
> +	(vb)->cnt_mem_ ## op++;						\
> +})
> +
> +#define log_qop(q, op)							\
> +	dprintk(2, "call_qop(%p, %s)%s\n", q, #op,			\
> +		(q)->ops->op ? "" : " (nop)")
> +
> +#define call_qop(q, op, args...)					\
> +({									\
> +	int err;							\
> +									\
> +	log_qop(q, op);							\
> +	err = (q)->ops->op ? (q)->ops->op(args) : 0;			\
> +	if (!err)							\
> +		(q)->cnt_ ## op++;					\
> +	err;								\
> +})
> +
> +#define call_void_qop(q, op, args...)					\
> +({									\
> +	log_qop(q, op);							\
> +	if ((q)->ops->op)						\
> +		(q)->ops->op(args);					\
> +	(q)->cnt_ ## op++;						\
> +})
> +
> +#define log_vb_qop(vb, op, args...)					\
> +	dprintk(2, "call_vb_qop(%p, %d, %s)%s\n",			\
> +		(vb)->vb2_queue, (vb)->index, #op,			\
> +		(vb)->vb2_queue->ops->op ? "" : " (nop)")
> +
> +#define call_vb_qop(vb, op, args...)					\
> +({									\
> +	int err;							\
> +									\
> +	log_vb_qop(vb, op);						\
> +	err = (vb)->vb2_queue->ops->op ?				\
> +		(vb)->vb2_queue->ops->op(args) : 0;			\
> +	if (!err)							\
> +		(vb)->cnt_ ## op++;					\
> +	err;								\
> +})
> +
> +#define call_void_vb_qop(vb, op, args...)				\
> +({									\
> +	log_vb_qop(vb, op);						\
> +	if ((vb)->vb2_queue->ops->op)					\
> +		(vb)->vb2_queue->ops->op(args);				\
> +	(vb)->cnt_ ## op++;						\
> +})
> +
> +#else
> +
> +#define call_memop(vb, op, args...)					\
> +	((vb)->vb2_queue->mem_ops->op ?					\
> +		(vb)->vb2_queue->mem_ops->op(args) : 0)
> +
> +#define call_ptr_memop(vb, op, args...)					\
> +	((vb)->vb2_queue->mem_ops->op ?					\
> +		(vb)->vb2_queue->mem_ops->op(args) : NULL)
> +
> +#define call_void_memop(vb, op, args...)				\
> +	do {								\
> +		if ((vb)->vb2_queue->mem_ops->op)			\
> +			(vb)->vb2_queue->mem_ops->op(args);		\
> +	} while (0)
> +
> +#define call_qop(q, op, args...)					\
> +	((q)->ops->op ? (q)->ops->op(args) : 0)
> +
> +#define call_void_qop(q, op, args...)					\
> +	do {								\
> +		if ((q)->ops->op)					\
> +			(q)->ops->op(args);				\
> +	} while (0)
> +
> +#define call_vb_qop(vb, op, args...)					\
> +	((vb)->vb2_queue->ops->op ? (vb)->vb2_queue->ops->op(args) : 0)
> +
> +#define call_void_vb_qop(vb, op, args...)				\
> +	do {								\
> +		if ((vb)->vb2_queue->ops->op)				\
> +			(vb)->vb2_queue->ops->op(args);			\
> +	} while (0)
> +
> +#endif
> +
> +#define call_bufop(q, op, args...)					\
> +({									\
> +	int ret = 0;							\
> +	if (q && q->buf_ops && q->buf_ops->op)				\
> +		ret = q->buf_ops->op(args);				\
> +	ret;								\
> +})
> +
> +bool vb2_buffer_in_use(struct vb2_queue *q, struct vb2_buffer *vb);
> +int vb2_verify_memory_type(struct vb2_queue *q,
> +		unsigned int memory, unsigned int type);
> +int vb2_verify_buffer(struct vb2_queue *q,
> +			unsigned int memory, unsigned int type,
> +			unsigned int index, unsigned int nplanes,
> +			void *pplane, const char *opname);
> +void vb2_warn_zero_bytesused(struct vb2_buffer *vb);
> +
> +int vb2_core_querybuf(struct vb2_queue *q, unsigned int index, void *pb);
> +int vb2_core_reqbufs(struct vb2_queue *q, unsigned int memory,
> +		unsigned int *count);
> +int vb2_core_create_bufs(struct vb2_queue *q, unsigned int memory,
> +		unsigned int *count, void *parg);
> +int vb2_core_prepare_buf(struct vb2_queue *q, unsigned int index, void *pb);
> +int vb2_core_qbuf(struct vb2_queue *q, unsigned int index, void *pb);
> +int vb2_core_dqbuf(struct vb2_queue *q, void *pb, bool nonblock);
> +int vb2_core_expbuf(struct vb2_queue *q, int *fd, unsigned int type,
> +		unsigned int index, unsigned int plane, unsigned int flags);
> +int vb2_core_streamon(struct vb2_queue *q);
> +int vb2_core_streamoff(struct vb2_queue *q);
> +int vb2_core_mmap(struct vb2_queue *q, struct vm_area_struct *vma);
> +
> +int __must_check vb2_core_queue_init(struct vb2_queue *q);
> +void vb2_core_queue_release(struct vb2_queue *q);
> +
> +#endif /* _MEDIA_VIDEOBUF2_INTERNAL_H */
> diff --git a/drivers/media/v4l2-core/videobuf2-v4l2.c b/drivers/media/v4l2-core/videobuf2-v4l2.c
> index 2f2b738..9fc6bef 100644
> --- a/drivers/media/v4l2-core/videobuf2-v4l2.c
> +++ b/drivers/media/v4l2-core/videobuf2-v4l2.c
> @@ -24,8 +24,1648 @@
>  #include <linux/freezer.h>
>  #include <linux/kthread.h>
>  
> +#include <media/v4l2-dev.h>
> +#include <media/v4l2-fh.h>
> +#include <media/v4l2-event.h>
> +#include <media/v4l2-common.h>
>  #include <media/videobuf2-v4l2.h>
>  
> +#include "videobuf2-internal.h"
> +
> +/* Flags that are set by the vb2 core */
> +#define V4L2_BUFFER_MASK_FLAGS	(V4L2_BUF_FLAG_MAPPED | \
> +				V4L2_BUF_FLAG_QUEUED | \
> +				V4L2_BUF_FLAG_DONE | \
> +				V4L2_BUF_FLAG_ERROR | \
> +				V4L2_BUF_FLAG_PREPARED | \
> +				V4L2_BUF_FLAG_TIMESTAMP_MASK)
> +
> +/* Output buffer flags that should be passed on to the driver */
> +#define V4L2_BUFFER_OUT_FLAGS	(V4L2_BUF_FLAG_PFRAME | \
> +				V4L2_BUF_FLAG_BFRAME | \
> +				V4L2_BUF_FLAG_KEYFRAME | \
> +				V4L2_BUF_FLAG_TIMECODE)
> +
> +/**
> + * __fill_v4l2_buffer() - fill in a struct v4l2_buffer with information to be
> + * returned to userspace
> + */
> +static int __fill_v4l2_buffer(struct vb2_buffer *vb, void *pb)
> +{
> +	struct v4l2_buffer *b = (struct v4l2_buffer *)pb;
> +	struct vb2_v4l2_buffer *vbuf = to_vb2_v4l2_buffer(vb);
> +	struct vb2_queue *q = vb->vb2_queue;
> +	unsigned int plane;
> +
> +	/* Copy back data such as timestamp, flags, etc. */
> +	b->index = vb->index;
> +	b->type = vb->type;
> +	b->memory = vb->memory;
> +	b->bytesused = 0;
> +
> +	b->flags = vbuf->flags;
> +	b->field = vbuf->field;
> +	b->timestamp = vbuf->timestamp;
> +	b->timecode = vbuf->timecode;
> +	b->sequence = vbuf->sequence;
> +
> +	if (V4L2_TYPE_IS_MULTIPLANAR(q->type)) {
> +		/*
> +		 * Fill in plane-related data if userspace provided an array
> +		 * for it. The caller has already verified memory and size.
> +		 */
> +		b->length = vb->num_planes;
> +		for (plane = 0; plane < vb->num_planes; ++plane) {
> +			struct v4l2_plane *pdst = &b->m.planes[plane];
> +			struct vb2_plane *psrc = &vb->planes[plane];
> +
> +			pdst->bytesused = psrc->bytesused;
> +			pdst->length = psrc->length;
> +			if (q->memory == V4L2_MEMORY_MMAP)
> +				pdst->m.mem_offset = psrc->m.offset;
> +			else if (q->memory == V4L2_MEMORY_USERPTR)
> +				pdst->m.userptr = psrc->m.userptr;
> +			else if (q->memory == V4L2_MEMORY_DMABUF)
> +				pdst->m.fd = psrc->m.fd;
> +			pdst->data_offset = psrc->data_offset;
> +		}
> +	} else {
> +		/*
> +		 * We use length and offset in v4l2_planes array even for
> +		 * single-planar buffers, but userspace does not.
> +		 */
> +		b->length = vb->planes[0].length;
> +		b->bytesused = vb->planes[0].bytesused;
> +		if (q->memory == V4L2_MEMORY_MMAP)
> +			b->m.offset = vb->planes[0].m.offset;
> +		else if (q->memory == V4L2_MEMORY_USERPTR)
> +			b->m.userptr = vb->planes[0].m.userptr;
> +		else if (q->memory == V4L2_MEMORY_DMABUF)
> +			b->m.fd = vb->planes[0].m.fd;
> +	}
> +
> +	/*
> +	 * Clear any buffer state related flags.
> +	 */
> +	b->flags &= ~V4L2_BUFFER_MASK_FLAGS;
> +	b->flags |= q->timestamp_flags & V4L2_BUF_FLAG_TIMESTAMP_MASK;
> +	if ((q->timestamp_flags & V4L2_BUF_FLAG_TIMESTAMP_MASK) !=
> +			V4L2_BUF_FLAG_TIMESTAMP_COPY) {
> +		/*
> +		 * For non-COPY timestamps, drop timestamp source bits
> +		 * and obtain the timestamp source from the queue.
> +		 */
> +		b->flags &= ~V4L2_BUF_FLAG_TSTAMP_SRC_MASK;
> +		b->flags |= q->timestamp_flags & V4L2_BUF_FLAG_TSTAMP_SRC_MASK;
> +	}
> +
> +	switch (vb->state) {
> +	case VB2_BUF_STATE_QUEUED:
> +	case VB2_BUF_STATE_ACTIVE:
> +		b->flags |= V4L2_BUF_FLAG_QUEUED;
> +		break;
> +	case VB2_BUF_STATE_ERROR:
> +		b->flags |= V4L2_BUF_FLAG_ERROR;
> +		/* fall through */
> +	case VB2_BUF_STATE_DONE:
> +		b->flags |= V4L2_BUF_FLAG_DONE;
> +		break;
> +	case VB2_BUF_STATE_PREPARED:
> +		b->flags |= V4L2_BUF_FLAG_PREPARED;
> +		break;
> +	case VB2_BUF_STATE_PREPARING:
> +	case VB2_BUF_STATE_DEQUEUED:
> +		/* nothing */
> +		break;
> +	}
> +
> +	if (vb2_buffer_in_use(q, vb))
> +		b->flags |= V4L2_BUF_FLAG_MAPPED;
> +
> +	return 0;
> +}
> +
> +/**
> + * __verify_length() - Verify that the bytesused value for each plane fits in
> + * the plane length and that the data offset doesn't exceed the bytesused value.
> + */
> +static int __verify_length(struct vb2_buffer *vb, const struct v4l2_buffer *b)
> +{
> +	unsigned int length;
> +	unsigned int bytesused;
> +	unsigned int plane;
> +
> +	if (!V4L2_TYPE_IS_OUTPUT(b->type))
> +		return 0;
> +
> +	if (V4L2_TYPE_IS_MULTIPLANAR(b->type)) {
> +		for (plane = 0; plane < vb->num_planes; ++plane) {
> +			length = (b->memory == V4L2_MEMORY_USERPTR ||
> +				b->memory == V4L2_MEMORY_DMABUF)
> +				? b->m.planes[plane].length
> +				: vb->planes[plane].length;
> +			bytesused = b->m.planes[plane].bytesused
> +				? b->m.planes[plane].bytesused : length;
> +
> +			if (b->m.planes[plane].bytesused > length)
> +				return -EINVAL;
> +
> +			if (b->m.planes[plane].data_offset > 0 &&
> +				b->m.planes[plane].data_offset >= bytesused)
> +				return -EINVAL;
> +		}
> +	} else {
> +		length = (b->memory == V4L2_MEMORY_USERPTR)
> +			? b->length : vb->planes[0].length;
> +
> +		if (b->bytesused > length)
> +			return -EINVAL;
> +	}
> +
> +	return 0;
> +}
> +
> +/**
> + * __fill_vb2_buffer() - fill a vb2_buffer with information provided in a
> + * v4l2_buffer by the userspace. It also verifies that struct
> + * v4l2_buffer has a valid number of planes.
> + */
> +static int __fill_vb2_buffer(struct vb2_buffer *vb, void *pb,
> +				struct vb2_plane *planes)
> +{
> +	struct v4l2_buffer *b = (struct v4l2_buffer *)pb;
> +	struct vb2_v4l2_buffer *vbuf = to_vb2_v4l2_buffer(vb);
> +	unsigned int plane;
> +	int ret;
> +
> +	ret = __verify_length(vb, b);
> +	if (ret < 0) {
> +		dprintk(1, "plane parameters verification failed: %d\n", ret);
> +		return ret;
> +	}
> +	vb->state = VB2_BUF_STATE_PREPARING;
> +	vbuf->timestamp.tv_sec = 0;
> +	vbuf->timestamp.tv_usec = 0;
> +	vbuf->sequence = 0;
> +
> +	if (V4L2_TYPE_IS_MULTIPLANAR(b->type)) {
> +		if (b->memory == V4L2_MEMORY_USERPTR) {
> +			for (plane = 0; plane < vb->num_planes; ++plane) {
> +				planes[plane].m.userptr =
> +					b->m.planes[plane].m.userptr;
> +				planes[plane].length =
> +					b->m.planes[plane].length;
> +			}
> +		}
> +		if (b->memory == V4L2_MEMORY_DMABUF) {
> +			for (plane = 0; plane < vb->num_planes; ++plane) {
> +				planes[plane].m.fd =
> +					b->m.planes[plane].m.fd;
> +				planes[plane].length =
> +					b->m.planes[plane].length;
> +			}
> +		}
> +
> +		/* Fill in driver-provided information for OUTPUT types */
> +		if (V4L2_TYPE_IS_OUTPUT(b->type)) {
> +			/*
> +			 * Will have to go up to b->length when API starts
> +			 * accepting variable number of planes.
> +			 *
> +			 * If bytesused == 0 for the output buffer, then fall
> +			 * back to the full buffer size. In that case
> +			 * userspace clearly never bothered to set it and
> +			 * it's a safe assumption that they really meant to
> +			 * use the full plane sizes.
> +			 *
> +			 * Some drivers, e.g. old codec drivers, use bytesused == 0
> +			 * as a way to indicate that streaming is finished.
> +			 * In that case, the driver should use the
> +			 * allow_zero_bytesused flag to keep old userspace
> +			 * applications working.
> +			 */
> +			for (plane = 0; plane < vb->num_planes; ++plane) {
> +				struct vb2_plane *pdst = &planes[plane];
> +				struct v4l2_plane *psrc = &b->m.planes[plane];
> +
> +				if (psrc->bytesused == 0)
> +					vb2_warn_zero_bytesused(vb);
> +
> +				if (vb->vb2_queue->allow_zero_bytesused)
> +					pdst->bytesused = psrc->bytesused;
> +				else
> +					pdst->bytesused = psrc->bytesused ?
> +						psrc->bytesused : pdst->length;
> +				pdst->data_offset = psrc->data_offset;
> +			}
> +		}
> +	} else {
> +		/*
> +		 * Single-planar buffers do not use planes array,
> +		 * so fill in relevant v4l2_buffer struct fields instead.
> +		 * In videobuf we use our internal V4l2_planes struct for
> +		 * single-planar buffers as well, for simplicity.
> +		 *
> +		 * If bytesused == 0 for the output buffer, then fall back
> +		 * to the full buffer size as that's a sensible default.
> +		 *
> +		 * Some drivers, e.g. old codec drivers, use bytesused == 0 as
> +		 * a way to indicate that streaming is finished. In that case,
> +		 * the driver should use the allow_zero_bytesused flag to keep
> +		 * old userspace applications working.
> +		 */
> +		if (b->memory == V4L2_MEMORY_USERPTR) {
> +			planes[0].m.userptr = b->m.userptr;
> +			planes[0].length = b->length;
> +		}
> +
> +		if (b->memory == V4L2_MEMORY_DMABUF) {
> +			planes[0].m.fd = b->m.fd;
> +			planes[0].length = b->length;
> +		}
> +
> +		if (V4L2_TYPE_IS_OUTPUT(b->type)) {
> +			if (b->bytesused == 0)
> +				vb2_warn_zero_bytesused(vb);
> +
> +			if (vb->vb2_queue->allow_zero_bytesused)
> +				planes[0].bytesused = b->bytesused;
> +			else
> +				planes[0].bytesused = b->bytesused ?
> +					b->bytesused : planes[0].length;
> +		} else
> +			planes[0].bytesused = 0;
> +
> +	}
> +
> +	/* Zero flags that the vb2 core handles */
> +	vbuf->flags = b->flags & ~V4L2_BUFFER_MASK_FLAGS;
> +	if ((vb->vb2_queue->timestamp_flags & V4L2_BUF_FLAG_TIMESTAMP_MASK) !=
> +			V4L2_BUF_FLAG_TIMESTAMP_COPY ||
> +			!V4L2_TYPE_IS_OUTPUT(b->type)) {
> +		/*
> +		 * Non-COPY timestamps and non-OUTPUT queues will get
> +		 * their timestamp and timestamp source flags from the
> +		 * queue.
> +		 */
> +		vbuf->flags &= ~V4L2_BUF_FLAG_TSTAMP_SRC_MASK;
> +	}
> +
> +	if (V4L2_TYPE_IS_OUTPUT(b->type)) {
> +		/*
> +		 * For output buffers mask out the timecode flag:
> +		 * this will be handled later in vb2_internal_qbuf().
> +		 * The 'field' is valid metadata for this output buffer
> +		 * and so that needs to be copied here.
> +		 */
> +		vbuf->flags &= ~V4L2_BUF_FLAG_TIMECODE;
> +		vbuf->field = b->field;
> +	} else {
> +		/* Zero any output buffer flags as this is a capture buffer */
> +		vbuf->flags &= ~V4L2_BUFFER_OUT_FLAGS;
> +	}
> +
> +	return 0;
> +}
> +
> +static int __fill_vb2_timestamp(struct vb2_buffer *vb, void *pb)
> +{
> +	struct v4l2_buffer *b = (struct v4l2_buffer *)pb;
> +	struct vb2_v4l2_buffer *vbuf = to_vb2_v4l2_buffer(vb);
> +	struct vb2_queue *q = vb->vb2_queue;
> +
> +	/*
> +	 * For output buffers copy the timestamp if needed,
> +	 * and the timecode field and flag if needed.
> +	 */
> +	if ((q->timestamp_flags & V4L2_BUF_FLAG_TIMESTAMP_MASK) ==
> +			V4L2_BUF_FLAG_TIMESTAMP_COPY)
> +		vbuf->timestamp = b->timestamp;
> +	vbuf->flags |= b->flags & V4L2_BUF_FLAG_TIMECODE;
> +	if (b->flags & V4L2_BUF_FLAG_TIMECODE)
> +		vbuf->timecode = b->timecode;
> +
> +	return 0;
> +};
> +
> +static int __is_last(struct vb2_buffer *vb)
> +{
> +	struct vb2_v4l2_buffer *vbuf = to_vb2_v4l2_buffer(vb);
> +
> +	return (vbuf->flags & V4L2_BUF_FLAG_LAST);
> +}
> +
> +const struct vb2_buf_ops v4l2_buf_ops = {
> +	.fill_user_buffer	= __fill_v4l2_buffer,
> +	.fill_vb2_buffer	= __fill_vb2_buffer,
> +	.fill_vb2_timestamp	= __fill_vb2_timestamp,
> +	.is_last		= __is_last,
> +};
> +
> +/**
> + * vb2_querybuf() - query video buffer information
> + * @q:		videobuf queue
> + * @b:		buffer struct passed from userspace to vidioc_querybuf handler
> + *		in driver
> + *
> + * Should be called from vidioc_querybuf ioctl handler in driver.
> + * This function will verify the passed v4l2_buffer structure and fill the
> + * relevant information for the userspace.
> + *
> + * The return values from this function are intended to be directly returned
> + * from vidioc_querybuf handler in driver.
> + */
> +int vb2_querybuf(struct vb2_queue *q, struct v4l2_buffer *b)
> +{
> +	int ret = vb2_verify_buffer(q, b->memory, b->type, b->index,
> +			b->length, b->m.planes, "querybuf");
> +
> +	return ret ? ret : vb2_core_querybuf(q, b->index, b);
> +}
> +EXPORT_SYMBOL(vb2_querybuf);
> +
> +/**
> + * vb2_reqbufs() - Wrapper for vb2_core_reqbufs() that also verifies
> + * the memory and type values.
> + * @q:		videobuf2 queue
> + * @req:	struct passed from userspace to vidioc_reqbufs handler
> + *		in driver
> + */
> +int vb2_reqbufs(struct vb2_queue *q, struct v4l2_requestbuffers *req)
> +{
> +	int ret = vb2_verify_memory_type(q, req->memory, req->type);
> +
> +	if (ret)
> +		return ret;
> +	if (vb2_fileio_is_active(q)) {
> +		dprintk(1, "file io in progress\n");
> +		return -EBUSY;
> +	}
> +
> +	return vb2_core_reqbufs(q, req->memory, &req->count);
> +}
> +EXPORT_SYMBOL_GPL(vb2_reqbufs);
> +
> +/**
> + * vb2_create_bufs() - Wrapper for vb2_core_create_bufs() that also verifies
> + * the memory and type values.
> + * @q:		videobuf2 queue
> + * @create:	creation parameters, passed from userspace to vidioc_create_bufs
> + *		handler in driver
> + */
> +int vb2_create_bufs(struct vb2_queue *q, struct v4l2_create_buffers *create)
> +{
> +	int ret = vb2_verify_memory_type(q, create->memory, create->format.type);
> +
> +	if (ret)
> +		return ret;
> +	if (create->count && vb2_fileio_is_active(q)) {
> +		dprintk(1, "file io in progress\n");
> +		return -EBUSY;
> +	}
> +	return vb2_core_create_bufs(q, create->memory, &create->count, &create->format);
> +}
> +EXPORT_SYMBOL_GPL(vb2_create_bufs);
> +
> +/**
> + * vb2_prepare_buf() - Pass ownership of a buffer from userspace to the kernel
> + * @q:		videobuf2 queue
> + * @b:		buffer structure passed from userspace to vidioc_prepare_buf
> + *		handler in driver
> + *
> + * Should be called from vidioc_prepare_buf ioctl handler of a driver.
> + * This function:
> + * 1) verifies the passed buffer,
> + * 2) calls buf_prepare callback in the driver (if provided), in which
> + *    driver-specific buffer initialization can be performed,
> + *
> + * The return values from this function are intended to be directly returned
> + * from vidioc_prepare_buf handler in driver.
> + */
> +int vb2_prepare_buf(struct vb2_queue *q, struct v4l2_buffer *b)
> +{
> +	int ret;
> +
> +	if (vb2_fileio_is_active(q)) {
> +		dprintk(1, "file io in progress\n");
> +		return -EBUSY;
> +	}
> +
> +	ret = vb2_verify_buffer(q, b->memory, b->type, b->index,
> +			b->length, b->m.planes, "prepare_buf");
> +	if (ret)
> +		return ret;
> +
> +	if (b->field == V4L2_FIELD_ALTERNATE && q->is_output) {
> +		/*
> +		 * If the format's field is ALTERNATE, then the buffer's field
> +		 * should be either TOP or BOTTOM, not ALTERNATE since that
> +		 * makes no sense. The driver has to know whether the
> +		 * buffer represents a top or a bottom field in order to
> +		 * program any DMA correctly. Using ALTERNATE is wrong, since
> +		 * that just says that it is either a top or a bottom field,
> +		 * but not which of the two it is.
> +		 */
> +		dprintk(1, "the field is incorrectly set to ALTERNATE "
> +				"for an output buffer\n");
> +		return -EINVAL;
> +	}
> +
> +	return vb2_core_prepare_buf(q, b->index, b);
> +}
> +EXPORT_SYMBOL_GPL(vb2_prepare_buf);
> +
> +static int vb2_internal_qbuf(struct vb2_queue *q, struct v4l2_buffer *b)
> +{
> +	int ret = vb2_verify_buffer(q, b->memory, b->type, b->index,
> +			b->length, b->m.planes, "qbuf");
> +	struct vb2_buffer *vb;
> +
> +	if (ret)
> +		return ret;
> +
> +	vb = q->bufs[b->index];
> +
> +	if (vb->state == VB2_BUF_STATE_DEQUEUED
> +			&& b->field == V4L2_FIELD_ALTERNATE && q->is_output) {
> +		dprintk(1, "the field is incorrectly set to ALTERNATE "
> +				"for an output buffer\n");
> +		return -EINVAL;
> +	}
> +
> +	return ret ? ret : vb2_core_qbuf(q, b->index, b);
> +}
> +
> +/**
> + * vb2_qbuf() - Queue a buffer from userspace
> + * @q:		videobuf2 queue
> + * @b:		buffer structure passed from userspace to vidioc_qbuf handler
> + *		in driver
> + *
> + * Should be called from vidioc_qbuf ioctl handler of a driver.
> + * This function:
> + * 1) verifies the passed buffer,
> + * 2) if necessary, calls buf_prepare callback in the driver (if provided), in
> + *    which driver-specific buffer initialization can be performed,
> + * 3) if streaming is on, queues the buffer in driver by the means of buf_queue
> + *    callback for processing.
> + *
> + * The return values from this function are intended to be directly returned
> + * from vidioc_qbuf handler in driver.
> + */
> +int vb2_qbuf(struct vb2_queue *q, struct v4l2_buffer *b)
> +{
> +	if (vb2_fileio_is_active(q)) {
> +		dprintk(1, "file io in progress\n");
> +		return -EBUSY;
> +	}
> +
> +	return vb2_internal_qbuf(q, b);
> +}
> +EXPORT_SYMBOL_GPL(vb2_qbuf);
> +
> +static int vb2_internal_dqbuf(struct vb2_queue *q, struct v4l2_buffer *b,
> +			bool nonblocking)
> +{
> +	if (b->type != q->type) {
> +		dprintk(1, "invalid buffer type\n");
> +		return -EINVAL;
> +	}
> +	return vb2_core_dqbuf(q, b, nonblocking);
> +}
> +
> +/**
> + * vb2_dqbuf() - Dequeue a buffer to the userspace
> + * @q:		videobuf2 queue
> + * @b:		buffer structure passed from userspace to vidioc_dqbuf handler
> + *		in driver
> + * @nonblocking: if true, this call will not sleep waiting for a buffer if no
> + *		 buffers ready for dequeuing are present. Normally the driver
> + *		 would be passing (file->f_flags & O_NONBLOCK) here
> + *
> + * Should be called from vidioc_dqbuf ioctl handler of a driver.
> + * This function:
> + * 1) verifies the passed buffer,
> + * 2) calls buf_finish callback in the driver (if provided), in which
> + *    driver can perform any additional operations that may be required before
> + *    returning the buffer to userspace, such as cache sync,
> + * 3) the buffer struct members are filled with relevant information for
> + *    the userspace.
> + *
> + * The return values from this function are intended to be directly returned
> + * from vidioc_dqbuf handler in driver.
> + */
> +int vb2_dqbuf(struct vb2_queue *q, struct v4l2_buffer *b, bool nonblocking)
> +{
> +	if (vb2_fileio_is_active(q)) {
> +		dprintk(1, "file io in progress\n");
> +		return -EBUSY;
> +	}
> +	return vb2_internal_dqbuf(q, b, nonblocking);
> +}
> +EXPORT_SYMBOL_GPL(vb2_dqbuf);
> +
> +/**
> + * vb2_expbuf() - Export a buffer as a file descriptor
> + * @q:		videobuf2 queue
> + * @eb:		export buffer structure passed from userspace to vidioc_expbuf
> + *		handler in driver
> + *
> + * The return values from this function are intended to be directly returned
> + * from vidioc_expbuf handler in driver.
> + */
> +int vb2_expbuf(struct vb2_queue *q, struct v4l2_exportbuffer *eb)
> +{
> +	if (vb2_fileio_is_active(q)) {
> +		dprintk(1, "file io in progress\n");
> +		return -EBUSY;
> +	}
> +
> +	return vb2_core_expbuf(q, &eb->fd, eb->type, eb->index,
> +				eb->plane, eb->flags);
> +}
> +EXPORT_SYMBOL_GPL(vb2_expbuf);
> +
> +static int vb2_internal_streamon(struct vb2_queue *q, enum v4l2_buf_type type)
> +{
> +	if (type != q->type) {
> +		dprintk(1, "invalid stream type\n");
> +		return -EINVAL;
> +	}
> +	return vb2_core_streamon(q);
> +}
> +
> +/**
> + * vb2_streamon - start streaming
> + * @q:		videobuf2 queue
> + * @type:	type argument passed from userspace to vidioc_streamon handler
> + *
> + * Should be called from vidioc_streamon handler of a driver.
> + * This function:
> + * 1) verifies current state
> + * 2) passes any previously queued buffers to the driver and starts streaming
> + *
> + * The return values from this function are intended to be directly returned
> + * from vidioc_streamon handler in the driver.
> + */
> +int vb2_streamon(struct vb2_queue *q, enum v4l2_buf_type type)
> +{
> +	if (vb2_fileio_is_active(q)) {
> +		dprintk(1, "file io in progress\n");
> +		return -EBUSY;
> +	}
> +	return vb2_internal_streamon(q, type);
> +}
> +EXPORT_SYMBOL_GPL(vb2_streamon);
> +
> +static int vb2_internal_streamoff(struct vb2_queue *q, enum v4l2_buf_type type)
> +{
> +	if (type != q->type) {
> +		dprintk(1, "invalid stream type\n");
> +		return -EINVAL;
> +	}
> +	return vb2_core_streamoff(q);
> +}
> +
> +/**
> + * vb2_streamoff - stop streaming
> + * @q:		videobuf2 queue
> + * @type:	type argument passed from userspace to vidioc_streamoff handler
> + *
> + * Should be called from vidioc_streamoff handler of a driver.
> + * This function:
> + * 1) verifies current state,
> + * 2) stop streaming and dequeues any queued buffers, including those previously
> + *    passed to the driver (after waiting for the driver to finish).
> + *
> + * This call can be used for pausing playback.
> + * The return values from this function are intended to be directly returned
> + * from vidioc_streamoff handler in the driver
> + */
> +int vb2_streamoff(struct vb2_queue *q, enum v4l2_buf_type type)
> +{
> +	if (vb2_fileio_is_active(q)) {
> +		dprintk(1, "file io in progress\n");
> +		return -EBUSY;
> +	}
> +	return vb2_internal_streamoff(q, type);
> +}
> +EXPORT_SYMBOL_GPL(vb2_streamoff);
> +
> +/**
> + * vb2_mmap() - map video buffers into application address space
> + * @q:		videobuf2 queue
> + * @vma:	vma passed to the mmap file operation handler in the driver
> + *
> + * Should be called from mmap file operation handler of a driver.
> + * This function maps one plane of one of the available video buffers to
> + * userspace. To map whole video memory allocated on reqbufs, this function
> + * has to be called once per each plane per each buffer previously allocated.
> + *
> + * When the userspace application calls mmap, it passes to it an offset returned
> + * to it earlier by the means of vidioc_querybuf handler. That offset acts as
> + * a "cookie", which is then used to identify the plane to be mapped.
> + * This function finds a plane with a matching offset and a mapping is performed
> + * by the means of a provided memory operation.
> + *
> + * The return values from this function are intended to be directly returned
> + * from the mmap handler in driver.
> + */
> +int vb2_mmap(struct vb2_queue *q, struct vm_area_struct *vma)
> +{
> +	if (vb2_fileio_is_active(q)) {
> +		dprintk(1, "mmap: file io in progress\n");
> +		return -EBUSY;
> +	}
> +
> +	return vb2_core_mmap(q, vma);
> +}
> +EXPORT_SYMBOL_GPL(vb2_mmap);
> +
> +static int __vb2_init_fileio(struct vb2_queue *q, int read);
> +static int __vb2_cleanup_fileio(struct vb2_queue *q);
> +
> +/**
> + * vb2_poll() - implements poll userspace operation
> + * @q:		videobuf2 queue
> + * @file:	file argument passed to the poll file operation handler
> + * @wait:	wait argument passed to the poll file operation handler
> + *
> + * This function implements poll file operation handler for a driver.
> + * For CAPTURE queues, if a buffer is ready to be dequeued, the userspace will
> + * be informed that the file descriptor of a video device is available for
> + * reading.
> + * For OUTPUT queues, if a buffer is ready to be dequeued, the file descriptor
> + * will be reported as available for writing.
> + *
> + * If the driver uses struct v4l2_fh, then vb2_poll() will also check for any
> + * pending events.
> + *
> + * The return values from this function are intended to be directly returned
> + * from poll handler in driver.
> + */
> +unsigned int vb2_poll(struct vb2_queue *q, struct file *file, poll_table *wait)
> +{
> +	struct video_device *vfd = video_devdata(file);
> +	unsigned long req_events = poll_requested_events(wait);
> +	struct vb2_buffer *vb = NULL;
> +	unsigned int res = 0;
> +	unsigned long flags;
> +
> +	if (test_bit(V4L2_FL_USES_V4L2_FH, &vfd->flags)) {
> +		struct v4l2_fh *fh = file->private_data;
> +
> +		if (v4l2_event_pending(fh))
> +			res = POLLPRI;
> +		else if (req_events & POLLPRI)
> +			poll_wait(file, &fh->wait, wait);
> +	}
> +
> +	if (!q->is_output && !(req_events & (POLLIN | POLLRDNORM)))
> +		return res;
> +	if (q->is_output && !(req_events & (POLLOUT | POLLWRNORM)))
> +		return res;
> +
> +	/*
> +	 * Start file I/O emulator only if streaming API has not been used yet.
> +	 */
> +	if (q->num_buffers == 0 && !vb2_fileio_is_active(q)) {
> +		if (!q->is_output && (q->io_modes & VB2_READ) &&
> +				(req_events & (POLLIN | POLLRDNORM))) {
> +			if (__vb2_init_fileio(q, 1))
> +				return res | POLLERR;
> +		}
> +		if (q->is_output && (q->io_modes & VB2_WRITE) &&
> +				(req_events & (POLLOUT | POLLWRNORM))) {
> +			if (__vb2_init_fileio(q, 0))
> +				return res | POLLERR;
> +			/*
> +			 * Write to OUTPUT queue can be done immediately.
> +			 */
> +			return res | POLLOUT | POLLWRNORM;
> +		}
> +	}
> +
> +	/*
> +	 * There is nothing to wait for if the queue isn't streaming, or if the
> +	 * error flag is set.
> +	 */
> +	if (!vb2_is_streaming(q) || q->error)
> +		return res | POLLERR;
> +	/*
> +	 * For compatibility with vb1: if QBUF hasn't been called yet, then
> +	 * return POLLERR as well. This only affects capture queues, output
> +	 * queues will always initialize waiting_for_buffers to false.
> +	 */
> +	if (q->waiting_for_buffers)
> +		return res | POLLERR;
> +
> +	/*
> +	 * For output streams you can write as long as there are fewer buffers
> +	 * queued than there are buffers available.
> +	 */
> +	if (q->is_output && q->queued_count < q->num_buffers)
> +		return res | POLLOUT | POLLWRNORM;
> +
> +	if (list_empty(&q->done_list)) {
> +		/*
> +		 * If the last buffer was dequeued from a capture queue,
> +		 * return immediately. DQBUF will return -EPIPE.
> +		 */
> +		if (q->last_buffer_dequeued)
> +			return res | POLLIN | POLLRDNORM;
> +
> +		poll_wait(file, &q->done_wq, wait);
> +	}
> +
> +	/*
> +	 * Take first buffer available for dequeuing.
> +	 */
> +	spin_lock_irqsave(&q->done_lock, flags);
> +	if (!list_empty(&q->done_list))
> +		vb = list_first_entry(&q->done_list, struct vb2_buffer,
> +					done_entry);
> +	spin_unlock_irqrestore(&q->done_lock, flags);
> +
> +	if (vb && (vb->state == VB2_BUF_STATE_DONE
> +			|| vb->state == VB2_BUF_STATE_ERROR)) {
> +		return (q->is_output) ?
> +				res | POLLOUT | POLLWRNORM :
> +				res | POLLIN | POLLRDNORM;
> +	}
> +	return res;
> +}
> +EXPORT_SYMBOL_GPL(vb2_poll);
> +
> +/**
> + * vb2_queue_init() - initialize a videobuf2 queue
> + * @q:		videobuf2 queue; this structure should be allocated in driver
> + *
> + * The vb2_queue structure should be allocated by the driver. The driver is
> + * responsible of clearing it's content and setting initial values for some
> + * required entries before calling this function.
> + * q->ops, q->mem_ops, q->type and q->io_modes are mandatory. Please refer
> + * to the struct vb2_queue description in include/media/videobuf2-core.h
> + * for more information.
> + */
> +int vb2_queue_init(struct vb2_queue *q)
> +{
> +	if (WARN_ON(VB2_MEMORY_MMAP != (int)V4L2_MEMORY_MMAP)
> +		|| WARN_ON(VB2_MEMORY_USERPTR != (int)V4L2_MEMORY_USERPTR)
> +		|| WARN_ON(VB2_MEMORY_DMABUF != (int)V4L2_MEMORY_DMABUF))
> +		return -EINVAL;
> +	/*
> +	 * Sanity check
> +	 */
> +	if (WARN_ON(!q)	|| WARN_ON(!q->type))
> +		return -EINVAL;
> +
> +	if (WARN_ON(q->timestamp_flags &
> +		    ~(V4L2_BUF_FLAG_TIMESTAMP_MASK |
> +		      V4L2_BUF_FLAG_TSTAMP_SRC_MASK)))
> +		return -EINVAL;
> +
> +	/* Warn that the driver should choose an appropriate timestamp type */
> +	WARN_ON((q->timestamp_flags & V4L2_BUF_FLAG_TIMESTAMP_MASK) ==
> +		V4L2_BUF_FLAG_TIMESTAMP_UNKNOWN);
> +
> +	if (q->buf_struct_size == 0)
> +		q->buf_struct_size = sizeof(struct vb2_v4l2_buffer);
> +
> +	q->buf_ops = &v4l2_buf_ops;
> +	q->is_multiplanar = V4L2_TYPE_IS_MULTIPLANAR(q->type);
> +	q->is_output = V4L2_TYPE_IS_OUTPUT(q->type);
> +
> +	return vb2_core_queue_init(q);
> +}
> +EXPORT_SYMBOL_GPL(vb2_queue_init);
> +
> +/**
> + * vb2_queue_release() - stop streaming, release the queue and free memory
> + * @q:		videobuf2 queue
> + *
> + * This function stops streaming and performs necessary clean ups, including
> + * freeing video buffer memory. The driver is responsible for freeing
> + * the vb2_queue structure itself.
> + */
> +void vb2_queue_release(struct vb2_queue *q)
> +{
> +	__vb2_cleanup_fileio(q);
> +	vb2_core_queue_release(q);
> +}
> +EXPORT_SYMBOL_GPL(vb2_queue_release);
> +
> +/**
> + * struct vb2_fileio_buf - buffer context used by file io emulator
> + *
> + * vb2 provides a compatibility layer and emulator of file io (read and
> + * write) calls on top of streaming API. This structure is used for
> + * tracking context related to the buffers.
> + */
> +struct vb2_fileio_buf {
> +	void *vaddr;
> +	unsigned int size;
> +	unsigned int pos;
> +	unsigned int queued:1;
> +};
> +
> +/**
> + * struct vb2_fileio_data - queue context used by file io emulator
> + *
> + * @cur_index:	the index of the buffer currently being read from or
> + *		written to. If equal to q->num_buffers then a new buffer
> + *		must be dequeued.
> + * @initial_index: in the read() case all buffers are queued up immediately
> + *		in __vb2_init_fileio() and __vb2_perform_fileio() just cycles
> + *		buffers. However, in the write() case no buffers are initially
> + *		queued, instead whenever a buffer is full it is queued up by
> + *		__vb2_perform_fileio(). Only once all available buffers have
> + *		been queued up will __vb2_perform_fileio() start to dequeue
> + *		buffers. This means that initially __vb2_perform_fileio()
> + *		needs to know what buffer index to use when it is queuing up
> + *		the buffers for the first time. That initial index is stored
> + *		in this field. Once it is equal to q->num_buffers all
> + *		available buffers have been queued and __vb2_perform_fileio()
> + *		should start the normal dequeue/queue cycle.
> + *
> + * vb2 provides a compatibility layer and emulator of file io (read and
> + * write) calls on top of streaming API. For proper operation it required
> + * this structure to save the driver state between each call of the read
> + * or write function.
> + */
> +struct vb2_fileio_data {
> +	struct v4l2_requestbuffers req;
> +	struct v4l2_plane p;
> +	struct v4l2_buffer b;
> +	struct vb2_fileio_buf bufs[VIDEO_MAX_FRAME];
> +	unsigned int cur_index;
> +	unsigned int initial_index;
> +	unsigned int q_count;
> +	unsigned int dq_count;
> +	unsigned read_once:1;
> +	unsigned write_immediately:1;
> +};
> +
> +/**
> + * __vb2_init_fileio() - initialize file io emulator
> + * @q:		videobuf2 queue
> + * @read:	mode selector (1 means read, 0 means write)
> + */
> +static int __vb2_init_fileio(struct vb2_queue *q, int read)
> +{
> +	struct vb2_fileio_data *fileio;
> +	int i, ret;
> +	unsigned int count = 0;
> +
> +	/*
> +	 * Sanity check
> +	 */
> +	if (WARN_ON((read && !(q->io_modes & VB2_READ)) ||
> +			(!read && !(q->io_modes & VB2_WRITE))))
> +		return -EINVAL;
> +
> +	/*
> +	 * Check if device supports mapping buffers to kernel virtual space.
> +	 */
> +	if (!q->mem_ops->vaddr)
> +		return -EBUSY;
> +
> +	/*
> +	 * Check if streaming api has not been already activated.
> +	 */
> +	if (q->streaming || q->num_buffers > 0)
> +		return -EBUSY;
> +
> +	/*
> +	 * Start with count 1, driver can increase it in queue_setup()
> +	 */
> +	count = 1;
> +
> +	dprintk(3, "setting up file io: mode %s, count %d, read_once %d, "
> +		"write_immediately %d\n",
> +		(read) ? "read" : "write", count, q->fileio_read_once,
> +		q->fileio_write_immediately);
> +
> +	fileio = kzalloc(sizeof(struct vb2_fileio_data), GFP_KERNEL);
> +	if (fileio == NULL)
> +		return -ENOMEM;
> +
> +	fileio->read_once = q->fileio_read_once;
> +	fileio->write_immediately = q->fileio_write_immediately;
> +
> +	/*
> +	 * Request buffers and use MMAP type to force driver
> +	 * to allocate buffers by itself.
> +	 */
> +	fileio->req.count = count;
> +	fileio->req.memory = V4L2_MEMORY_MMAP;
> +	fileio->req.type = q->type;
> +	q->fileio = fileio;
> +	ret = vb2_core_reqbufs(q, fileio->req.memory, &fileio->req.count);
> +	if (ret)
> +		goto err_kfree;
> +
> +	/*
> +	 * Check if plane_count is correct
> +	 * (multiplane buffers are not supported).
> +	 */
> +	if (q->bufs[0]->num_planes != 1) {
> +		ret = -EBUSY;
> +		goto err_reqbufs;
> +	}
> +
> +	/*
> +	 * Get kernel address of each buffer.
> +	 */
> +	for (i = 0; i < q->num_buffers; i++) {
> +		fileio->bufs[i].vaddr = vb2_plane_vaddr(q->bufs[i], 0);
> +		if (fileio->bufs[i].vaddr == NULL) {
> +			ret = -EINVAL;
> +			goto err_reqbufs;
> +		}
> +		fileio->bufs[i].size = vb2_plane_size(q->bufs[i], 0);
> +	}
> +
> +	/*
> +	 * Read mode requires pre queuing of all buffers.
> +	 */
> +	if (read) {
> +		bool is_multiplanar = q->is_multiplanar;
> +
> +		/*
> +		 * Queue all buffers.
> +		 */
> +		for (i = 0; i < q->num_buffers; i++) {
> +			struct v4l2_buffer *b = &fileio->b;
> +
> +			memset(b, 0, sizeof(*b));
> +			b->type = q->type;
> +			if (is_multiplanar) {
> +				memset(&fileio->p, 0, sizeof(fileio->p));
> +				b->m.planes = &fileio->p;
> +				b->length = 1;
> +			}
> +			b->memory = q->memory;
> +			b->index = i;
> +			ret = vb2_internal_qbuf(q, b);
> +			if (ret)
> +				goto err_reqbufs;
> +			fileio->bufs[i].queued = 1;
> +		}
> +		/*
> +		 * All buffers have been queued, so mark that by setting
> +		 * initial_index to q->num_buffers
> +		 */
> +		fileio->initial_index = q->num_buffers;
> +		fileio->cur_index = q->num_buffers;
> +	}
> +
> +	/*
> +	 * Start streaming.
> +	 */
> +	ret = vb2_internal_streamon(q, q->type);
> +	if (ret)
> +		goto err_reqbufs;
> +
> +	return ret;
> +
> +err_reqbufs:
> +	fileio->req.count = 0;
> +	vb2_core_reqbufs(q, fileio->req.memory, &fileio->req.count);
> +
> +err_kfree:
> +	q->fileio = NULL;
> +	kfree(fileio);
> +	return ret;
> +}
> +
> +/**
> + * __vb2_cleanup_fileio() - free resourced used by file io emulator
> + * @q:		videobuf2 queue
> + */
> +static int __vb2_cleanup_fileio(struct vb2_queue *q)
> +{
> +	struct vb2_fileio_data *fileio = q->fileio;
> +
> +	if (fileio) {
> +		vb2_internal_streamoff(q, q->type);
> +		q->fileio = NULL;
> +		fileio->req.count = 0;
> +		vb2_reqbufs(q, &fileio->req);
> +		kfree(fileio);
> +		dprintk(3, "file io emulator closed\n");
> +	}
> +	return 0;
> +}
> +
> +/**
> + * __vb2_perform_fileio() - perform a single file io (read or write) operation
> + * @q:		videobuf2 queue
> + * @data:	pointed to target userspace buffer
> + * @count:	number of bytes to read or write
> + * @ppos:	file handle position tracking pointer
> + * @nonblock:	mode selector (1 means blocking calls, 0 means nonblocking)
> + * @read:	access mode selector (1 means read, 0 means write)
> + */
> +static size_t __vb2_perform_fileio(struct vb2_queue *q, char __user *data,
> +		size_t count, loff_t *ppos, int nonblock, int read)
> +{
> +	struct vb2_fileio_data *fileio;
> +	struct vb2_fileio_buf *buf;
> +	bool is_multiplanar = q->is_multiplanar;
> +	/*
> +	 * When using write() to write data to an output video node the vb2 core
> +	 * should set timestamps if V4L2_BUF_FLAG_TIMESTAMP_COPY is set. Nobody
> +	 * else is able to provide this information with the write() operation.
> +	 */
> +	bool set_timestamp = !read &&
> +		(q->timestamp_flags & V4L2_BUF_FLAG_TIMESTAMP_MASK) ==
> +		V4L2_BUF_FLAG_TIMESTAMP_COPY;
> +	int ret, index;
> +
> +	dprintk(3, "mode %s, offset %ld, count %zd, %sblocking\n",
> +		read ? "read" : "write", (long)*ppos, count,
> +		nonblock ? "non" : "");
> +
> +	if (!data)
> +		return -EINVAL;
> +
> +	/*
> +	 * Initialize emulator on first call.
> +	 */
> +	if (!vb2_fileio_is_active(q)) {
> +		ret = __vb2_init_fileio(q, read);
> +		dprintk(3, "vb2_init_fileio result: %d\n", ret);
> +		if (ret)
> +			return ret;
> +	}
> +	fileio = q->fileio;
> +
> +	/*
> +	 * Check if we need to dequeue the buffer.
> +	 */
> +	index = fileio->cur_index;
> +	if (index >= q->num_buffers) {
> +		/*
> +		 * Call vb2_dqbuf to get buffer back.
> +		 */
> +		memset(&fileio->b, 0, sizeof(fileio->b));
> +		fileio->b.type = q->type;
> +		fileio->b.memory = q->memory;
> +		if (is_multiplanar) {
> +			memset(&fileio->p, 0, sizeof(fileio->p));
> +			fileio->b.m.planes = &fileio->p;
> +			fileio->b.length = 1;
> +		}
> +		ret = vb2_internal_dqbuf(q, &fileio->b, nonblock);
> +		dprintk(5, "vb2_dqbuf result: %d\n", ret);
> +		if (ret)
> +			return ret;
> +		fileio->dq_count += 1;
> +
> +		fileio->cur_index = index = fileio->b.index;
> +		buf = &fileio->bufs[index];
> +
> +		/*
> +		 * Get number of bytes filled by the driver
> +		 */
> +		buf->pos = 0;
> +		buf->queued = 0;
> +		buf->size = read ? vb2_get_plane_payload(q->bufs[index], 0)
> +				 : vb2_plane_size(q->bufs[index], 0);
> +
> +		/*
> +		 * Compensate for data_offset on read
> +		 * in the multiplanar case.
> +		 */
> +		if (is_multiplanar && read &&
> +			fileio->b.m.planes[0].data_offset < buf->size) {
> +			buf->pos = fileio->b.m.planes[0].data_offset;
> +			buf->size -= buf->pos;
> +		}
> +	} else {
> +		buf = &fileio->bufs[index];
> +	}
> +
> +	/*
> +	 * Limit count on last few bytes of the buffer.
> +	 */
> +	if (buf->pos + count > buf->size) {
> +		count = buf->size - buf->pos;
> +		dprintk(5, "reducing read count: %zd\n", count);
> +	}
> +
> +	/*
> +	 * Transfer data to userspace.
> +	 */
> +	dprintk(3, "copying %zd bytes - buffer %d, offset %u\n",
> +		count, index, buf->pos);
> +	if (read)
> +		ret = copy_to_user(data, buf->vaddr + buf->pos, count);
> +	else
> +		ret = copy_from_user(buf->vaddr + buf->pos, data, count);
> +	if (ret) {
> +		dprintk(3, "error copying data\n");
> +		return -EFAULT;
> +	}
> +
> +	/*
> +	 * Update counters.
> +	 */
> +	buf->pos += count;
> +	*ppos += count;
> +
> +	/*
> +	 * Queue next buffer if required.
> +	 */
> +	if (buf->pos == buf->size || (!read && fileio->write_immediately)) {
> +		/*
> +		 * Check if this is the last buffer to read.
> +		 */
> +		if (read && fileio->read_once && fileio->dq_count == 1) {
> +			dprintk(3, "read limit reached\n");
> +			return __vb2_cleanup_fileio(q);
> +		}
> +
> +		/*
> +		 * Call vb2_qbuf and give buffer to the driver.
> +		 */
> +		memset(&fileio->b, 0, sizeof(fileio->b));
> +		fileio->b.type = q->type;
> +		fileio->b.memory = q->memory;
> +		fileio->b.index = index;
> +		fileio->b.bytesused = buf->pos;
> +		if (is_multiplanar) {
> +			memset(&fileio->p, 0, sizeof(fileio->p));
> +			fileio->p.bytesused = buf->pos;
> +			fileio->b.m.planes = &fileio->p;
> +			fileio->b.length = 1;
> +		}
> +		if (set_timestamp)
> +			v4l2_get_timestamp(&fileio->b.timestamp);
> +		ret = vb2_internal_qbuf(q, &fileio->b);
> +		dprintk(5, "vb2_dbuf result: %d\n", ret);
> +		if (ret)
> +			return ret;
> +
> +		/*
> +		 * Buffer has been queued, update the status
> +		 */
> +		buf->pos = 0;
> +		buf->queued = 1;
> +		buf->size = vb2_plane_size(q->bufs[index], 0);
> +		fileio->q_count += 1;
> +		/*
> +		 * If we are queuing up buffers for the first time, then
> +		 * increase initial_index by one.
> +		 */
> +		if (fileio->initial_index < q->num_buffers)
> +			fileio->initial_index++;
> +		/*
> +		 * The next buffer to use is either a buffer that's going to be
> +		 * queued for the first time (initial_index < q->num_buffers)
> +		 * or it is equal to q->num_buffers, meaning that the next
> +		 * time we need to dequeue a buffer since we've now queued up
> +		 * all the 'first time' buffers.
> +		 */
> +		fileio->cur_index = fileio->initial_index;
> +	}
> +
> +	/*
> +	 * Return proper number of bytes processed.
> +	 */
> +	if (ret == 0)
> +		ret = count;
> +	return ret;
> +}
> +
> +size_t vb2_read(struct vb2_queue *q, char __user *data, size_t count,
> +		loff_t *ppos, int nonblocking)
> +{
> +	return __vb2_perform_fileio(q, data, count, ppos, nonblocking, 1);
> +}
> +EXPORT_SYMBOL_GPL(vb2_read);
> +
> +size_t vb2_write(struct vb2_queue *q, const char __user *data, size_t count,
> +		loff_t *ppos, int nonblocking)
> +{
> +	return __vb2_perform_fileio(q, (char __user *) data, count,
> +							ppos, nonblocking, 0);
> +}
> +EXPORT_SYMBOL_GPL(vb2_write);
> +
> +struct vb2_threadio_data {
> +	struct task_struct *thread;
> +	vb2_thread_fnc fnc;
> +	void *priv;
> +	bool stop;
> +};
> +
> +static int vb2_thread(void *data)
> +{
> +	struct vb2_queue *q = data;
> +	struct vb2_threadio_data *threadio = q->threadio;
> +	struct vb2_fileio_data *fileio = q->fileio;
> +	bool set_timestamp = false;
> +	int prequeue = 0;
> +	int index = 0;
> +	int ret = 0;
> +
> +	if (q->is_output) {
> +		prequeue = q->num_buffers;
> +		set_timestamp =
> +			(q->timestamp_flags & V4L2_BUF_FLAG_TIMESTAMP_MASK) ==
> +			V4L2_BUF_FLAG_TIMESTAMP_COPY;
> +	}
> +
> +	set_freezable();
> +
> +	for (;;) {
> +		struct vb2_buffer *vb;
> +
> +		/*
> +		 * Call vb2_dqbuf to get buffer back.
> +		 */
> +		memset(&fileio->b, 0, sizeof(fileio->b));
> +		fileio->b.type = q->type;
> +		fileio->b.memory = q->memory;
> +		if (prequeue) {
> +			fileio->b.index = index++;
> +			prequeue--;
> +		} else {
> +			call_void_qop(q, wait_finish, q);
> +			if (!threadio->stop)
> +				ret = vb2_internal_dqbuf(q, &fileio->b, 0);
> +			call_void_qop(q, wait_prepare, q);
> +			dprintk(5, "file io: vb2_dqbuf result: %d\n", ret);
> +		}
> +		if (ret || threadio->stop)
> +			break;
> +		try_to_freeze();
> +
> +		vb = q->bufs[fileio->b.index];
> +		if (!(fileio->b.flags & V4L2_BUF_FLAG_ERROR))
> +			if (threadio->fnc(vb, threadio->priv))
> +				break;
> +		call_void_qop(q, wait_finish, q);
> +		if (set_timestamp)
> +			v4l2_get_timestamp(&fileio->b.timestamp);
> +		if (!threadio->stop)
> +			ret = vb2_internal_qbuf(q, &fileio->b);
> +		call_void_qop(q, wait_prepare, q);
> +		if (ret || threadio->stop)
> +			break;
> +	}
> +
> +	/* Hmm, linux becomes *very* unhappy without this ... */
> +	while (!kthread_should_stop()) {
> +		set_current_state(TASK_INTERRUPTIBLE);
> +		schedule();
> +	}
> +	return 0;
> +}
> +
> +/*
> + * This function should not be used for anything else but the videobuf2-dvb
> + * support. If you think you have another good use-case for this, then please
> + * contact the linux-media mailinglist first.
> + */
> +int vb2_thread_start(struct vb2_queue *q, vb2_thread_fnc fnc, void *priv,
> +			const char *thread_name)
> +{
> +	struct vb2_threadio_data *threadio;
> +	int ret = 0;
> +
> +	if (q->threadio)
> +		return -EBUSY;
> +	if (vb2_is_busy(q))
> +		return -EBUSY;
> +	if (WARN_ON(q->fileio))
> +		return -EBUSY;
> +
> +	threadio = kzalloc(sizeof(*threadio), GFP_KERNEL);
> +	if (threadio == NULL)
> +		return -ENOMEM;
> +	threadio->fnc = fnc;
> +	threadio->priv = priv;
> +
> +	ret = __vb2_init_fileio(q, !q->is_output);
> +	dprintk(3, "file io: vb2_init_fileio result: %d\n", ret);
> +	if (ret)
> +		goto nomem;
> +	q->threadio = threadio;
> +	threadio->thread = kthread_run(vb2_thread, q, "vb2-%s", thread_name);
> +	if (IS_ERR(threadio->thread)) {
> +		ret = PTR_ERR(threadio->thread);
> +		threadio->thread = NULL;
> +		goto nothread;
> +	}
> +	return 0;
> +
> +nothread:
> +	__vb2_cleanup_fileio(q);
> +nomem:
> +	kfree(threadio);
> +	return ret;
> +}
> +EXPORT_SYMBOL_GPL(vb2_thread_start);
> +
> +int vb2_thread_stop(struct vb2_queue *q)
> +{
> +	struct vb2_threadio_data *threadio = q->threadio;
> +	int err;
> +
> +	if (threadio == NULL)
> +		return 0;
> +	threadio->stop = true;
> +	/* Wake up all pending sleeps in the thread */
> +	vb2_queue_error(q);
> +	err = kthread_stop(threadio->thread);
> +	__vb2_cleanup_fileio(q);
> +	threadio->thread = NULL;
> +	kfree(threadio);
> +	q->threadio = NULL;
> +	return err;
> +}
> +EXPORT_SYMBOL_GPL(vb2_thread_stop);
> +
> +/*
> + * The following functions are not part of the vb2 core API, but are helper
> + * functions that plug into struct v4l2_ioctl_ops, struct v4l2_file_operations
> + * and struct vb2_ops.
> + * They contain boilerplate code that most if not all drivers have to do
> + * and so they simplify the driver code.
> + */
> +
> +/* The queue is busy if there is a owner and you are not that owner. */
> +static inline
> +bool vb2_queue_is_busy(struct video_device *vdev, struct file *file)
> +{
> +	return vdev->queue->owner && vdev->queue->owner != file->private_data;
> +}
> +
> +/* vb2 ioctl helpers */
> +
> +int vb2_ioctl_reqbufs(struct file *file, void *priv,
> +			  struct v4l2_requestbuffers *p)
> +{
> +	struct video_device *vdev = video_devdata(file);
> +	int res = vb2_verify_memory_type(vdev->queue, p->memory, p->type);
> +
> +	if (res)
> +		return res;
> +	if (vb2_fileio_is_active(vdev->queue))
> +		return -EBUSY;
> +	if (vb2_queue_is_busy(vdev, file))
> +		return -EBUSY;
> +	res = vb2_core_reqbufs(vdev->queue, p->memory, &p->count);
> +	/* If count == 0, then the owner has released all buffers and he
> +	   is no longer owner of the queue. Otherwise we have a new owner. */
> +	if (res == 0)
> +		vdev->queue->owner = p->count ? file->private_data : NULL;
> +	return res;
> +}
> +EXPORT_SYMBOL_GPL(vb2_ioctl_reqbufs);
> +
> +int vb2_ioctl_create_bufs(struct file *file, void *priv,
> +			  struct v4l2_create_buffers *p)
> +{
> +	struct video_device *vdev = video_devdata(file);
> +	int res = vb2_verify_memory_type(vdev->queue,
> +				p->memory, p->format.type);
> +
> +	if (vb2_fileio_is_active(vdev->queue))
> +		return -EBUSY;
> +	p->index = vdev->queue->num_buffers;
> +	/* If count == 0, then just check if memory and type are valid.
> +	   Any -EBUSY result from vb2_verify_memory_type can be mapped to 0. */
> +	if (p->count == 0)
> +		return res != -EBUSY ? res : 0;
> +	if (res)
> +		return res;
> +	if (vb2_queue_is_busy(vdev, file))
> +		return -EBUSY;
> +	res = vb2_core_create_bufs(vdev->queue,
> +				p->memory, &p->count, &p->format);
> +	if (res == 0)
> +		vdev->queue->owner = file->private_data;
> +	return res;
> +}
> +EXPORT_SYMBOL_GPL(vb2_ioctl_create_bufs);
> +
> +int vb2_ioctl_prepare_buf(struct file *file, void *priv,
> +			  struct v4l2_buffer *p)
> +{
> +	struct video_device *vdev = video_devdata(file);
> +
> +	if (vb2_queue_is_busy(vdev, file))
> +		return -EBUSY;
> +	return vb2_prepare_buf(vdev->queue, p);
> +}
> +EXPORT_SYMBOL_GPL(vb2_ioctl_prepare_buf);
> +
> +int vb2_ioctl_querybuf(struct file *file, void *priv, struct v4l2_buffer *p)
> +{
> +	struct video_device *vdev = video_devdata(file);
> +
> +	/* No need to call vb2_queue_is_busy(), anyone can query buffers. */
> +	return vb2_querybuf(vdev->queue, p);
> +}
> +EXPORT_SYMBOL_GPL(vb2_ioctl_querybuf);
> +
> +int vb2_ioctl_qbuf(struct file *file, void *priv, struct v4l2_buffer *p)
> +{
> +	struct video_device *vdev = video_devdata(file);
> +
> +	if (vb2_queue_is_busy(vdev, file))
> +		return -EBUSY;
> +	return vb2_qbuf(vdev->queue, p);
> +}
> +EXPORT_SYMBOL_GPL(vb2_ioctl_qbuf);
> +
> +int vb2_ioctl_dqbuf(struct file *file, void *priv, struct v4l2_buffer *p)
> +{
> +	struct video_device *vdev = video_devdata(file);
> +
> +	if (vb2_queue_is_busy(vdev, file))
> +		return -EBUSY;
> +	return vb2_dqbuf(vdev->queue, p, file->f_flags & O_NONBLOCK);
> +}
> +EXPORT_SYMBOL_GPL(vb2_ioctl_dqbuf);
> +
> +int vb2_ioctl_streamon(struct file *file, void *priv, enum v4l2_buf_type i)
> +{
> +	struct video_device *vdev = video_devdata(file);
> +
> +	if (vb2_queue_is_busy(vdev, file))
> +		return -EBUSY;
> +	return vb2_streamon(vdev->queue, i);
> +}
> +EXPORT_SYMBOL_GPL(vb2_ioctl_streamon);
> +
> +int vb2_ioctl_streamoff(struct file *file, void *priv, enum v4l2_buf_type i)
> +{
> +	struct video_device *vdev = video_devdata(file);
> +
> +	if (vb2_queue_is_busy(vdev, file))
> +		return -EBUSY;
> +	return vb2_streamoff(vdev->queue, i);
> +}
> +EXPORT_SYMBOL_GPL(vb2_ioctl_streamoff);
> +
> +int vb2_ioctl_expbuf(struct file *file, void *priv, struct v4l2_exportbuffer *p)
> +{
> +	struct video_device *vdev = video_devdata(file);
> +
> +	if (vb2_queue_is_busy(vdev, file))
> +		return -EBUSY;
> +	return vb2_expbuf(vdev->queue, p);
> +}
> +EXPORT_SYMBOL_GPL(vb2_ioctl_expbuf);
> +
> +/* v4l2_file_operations helpers */
> +
> +int vb2_fop_mmap(struct file *file, struct vm_area_struct *vma)
> +{
> +	struct video_device *vdev = video_devdata(file);
> +
> +	if (vb2_fileio_is_active(vdev->queue)) {
> +		dprintk(1, "mmap: file io in progress\n");
> +		return -EBUSY;
> +	}
> +
> +	return vb2_mmap(vdev->queue, vma);
> +}
> +EXPORT_SYMBOL_GPL(vb2_fop_mmap);
> +
> +int _vb2_fop_release(struct file *file, struct mutex *lock)
> +{
> +	struct video_device *vdev = video_devdata(file);
> +
> +	if (lock)
> +		mutex_lock(lock);
> +	if (file->private_data == vdev->queue->owner) {
> +		vb2_queue_release(vdev->queue);
> +		vdev->queue->owner = NULL;
> +	}
> +	if (lock)
> +		mutex_unlock(lock);
> +	return v4l2_fh_release(file);
> +}
> +EXPORT_SYMBOL_GPL(_vb2_fop_release);
> +
> +int vb2_fop_release(struct file *file)
> +{
> +	struct video_device *vdev = video_devdata(file);
> +	struct mutex *lock = vdev->queue->lock ? vdev->queue->lock : vdev->lock;
> +
> +	return _vb2_fop_release(file, lock);
> +}
> +EXPORT_SYMBOL_GPL(vb2_fop_release);
> +
> +ssize_t vb2_fop_write(struct file *file, const char __user *buf,
> +		size_t count, loff_t *ppos)
> +{
> +	struct video_device *vdev = video_devdata(file);
> +	struct mutex *lock = vdev->queue->lock ? vdev->queue->lock : vdev->lock;
> +	int err = -EBUSY;
> +
> +	if (!(vdev->queue->io_modes & VB2_WRITE))
> +		return -EINVAL;
> +	if (lock && mutex_lock_interruptible(lock))
> +		return -ERESTARTSYS;
> +	if (vb2_queue_is_busy(vdev, file))
> +		goto exit;
> +	err = vb2_write(vdev->queue, buf, count, ppos,
> +			file->f_flags & O_NONBLOCK);
> +	if (vdev->queue->fileio)
> +		vdev->queue->owner = file->private_data;
> +exit:
> +	if (lock)
> +		mutex_unlock(lock);
> +	return err;
> +}
> +EXPORT_SYMBOL_GPL(vb2_fop_write);
> +
> +ssize_t vb2_fop_read(struct file *file, char __user *buf,
> +		size_t count, loff_t *ppos)
> +{
> +	struct video_device *vdev = video_devdata(file);
> +	struct mutex *lock = vdev->queue->lock ? vdev->queue->lock : vdev->lock;
> +	int err = -EBUSY;
> +
> +	if (!(vdev->queue->io_modes & VB2_READ))
> +		return -EINVAL;
> +	if (lock && mutex_lock_interruptible(lock))
> +		return -ERESTARTSYS;
> +	if (vb2_queue_is_busy(vdev, file))
> +		goto exit;
> +	err = vb2_read(vdev->queue, buf, count, ppos,
> +			file->f_flags & O_NONBLOCK);
> +	if (vdev->queue->fileio)
> +		vdev->queue->owner = file->private_data;
> +exit:
> +	if (lock)
> +		mutex_unlock(lock);
> +	return err;
> +}
> +EXPORT_SYMBOL_GPL(vb2_fop_read);
> +
> +unsigned int vb2_fop_poll(struct file *file, poll_table *wait)
> +{
> +	struct video_device *vdev = video_devdata(file);
> +	struct vb2_queue *q = vdev->queue;
> +	struct mutex *lock = q->lock ? q->lock : vdev->lock;
> +	unsigned res;
> +	void *fileio;
> +
> +	/*
> +	 * If this helper doesn't know how to lock, then you shouldn't be using
> +	 * it but you should write your own.
> +	 */
> +	WARN_ON(!lock);
> +
> +	if (lock && mutex_lock_interruptible(lock))
> +		return POLLERR;
> +
> +	fileio = q->fileio;
> +
> +	res = vb2_poll(vdev->queue, file, wait);
> +
> +	/* If fileio was started, then we have a new queue owner. */
> +	if (!fileio && q->fileio)
> +		q->owner = file->private_data;
> +	if (lock)
> +		mutex_unlock(lock);
> +	return res;
> +}
> +EXPORT_SYMBOL_GPL(vb2_fop_poll);
> +
> +#ifndef CONFIG_MMU
> +unsigned long vb2_fop_get_unmapped_area(struct file *file, unsigned long addr,
> +		unsigned long len, unsigned long pgoff, unsigned long flags)
> +{
> +	struct video_device *vdev = video_devdata(file);
> +
> +	return vb2_get_unmapped_area(vdev->queue, addr, len, pgoff, flags);
> +}
> +EXPORT_SYMBOL_GPL(vb2_fop_get_unmapped_area);
> +#endif
> +
> +/* vb2_ops helpers. Only use if vq->lock is non-NULL. */
> +
> +void vb2_ops_wait_prepare(struct vb2_queue *vq)
> +{
> +	mutex_unlock(vq->lock);
> +}
> +EXPORT_SYMBOL_GPL(vb2_ops_wait_prepare);
> +
> +void vb2_ops_wait_finish(struct vb2_queue *vq)
> +{
> +	mutex_lock(vq->lock);
> +}
> +EXPORT_SYMBOL_GPL(vb2_ops_wait_finish);
> +
>  MODULE_DESCRIPTION("Driver helper framework for Video for Linux 2");
>  MODULE_AUTHOR("Pawel Osciak <pawel@osciak.com>, Marek Szyprowski");
>  MODULE_LICENSE("GPL");
> diff --git a/include/media/videobuf2-core.h b/include/media/videobuf2-core.h
> index 09d7529..4044bed 100644
> --- a/include/media/videobuf2-core.h
> +++ b/include/media/videobuf2-core.h
> @@ -15,9 +15,18 @@
>  #include <linux/mm_types.h>
>  #include <linux/mutex.h>
>  #include <linux/poll.h>
> -#include <linux/videodev2.h>
>  #include <linux/dma-buf.h>
>  
> +#define VB2_MAX_FRAME	(32)
> +#define VB2_MAX_PLANES	(8)
> +
> +enum vb2_memory {
> +	VB2_MEMORY_UNKNOWN	= 0,
> +	VB2_MEMORY_MMAP		= 1,
> +	VB2_MEMORY_USERPTR	= 2,
> +	VB2_MEMORY_DMABUF	= 4,
> +};
> +
>  struct vb2_alloc_ctx;
>  struct vb2_fileio_data;
>  struct vb2_threadio_data;
> @@ -198,7 +207,7 @@ struct vb2_buffer {
>  	unsigned int		type;
>  	unsigned int		memory;
>  	unsigned int		num_planes;
> -	struct vb2_plane	planes[VIDEO_MAX_PLANES];
> +	struct vb2_plane	planes[VB2_MAX_PLANES];
>  
>  #ifdef CONFIG_VIDEO_ADV_DEBUG
>  	/*
> @@ -330,18 +339,24 @@ struct vb2_ops {
>  	void (*buf_queue)(struct vb2_buffer *vb);
>  };
>  
> -struct v4l2_fh;
> +struct vb2_buf_ops {
> +	int (*fill_user_buffer)(struct vb2_buffer *vb, void *pb);
> +	int (*fill_vb2_buffer)(struct vb2_buffer *vb, void *pb,
> +				struct vb2_plane *planes);
> +	int (*fill_vb2_timestamp)(struct vb2_buffer *vb, void *pb);
> +	int (*is_last)(struct vb2_buffer *vb);
> +};
>  
>  /**
>   * struct vb2_queue - a videobuf queue
>   *
> - * @type:	queue type (see V4L2_BUF_TYPE_* in linux/videodev2.h
> + * @type:	queue type (see VB2_BUF_TYPE_*)
>   * @io_modes:	supported io methods (see vb2_io_modes enum)
>   * @fileio_read_once:		report EOF after reading the first buffer
>   * @fileio_write_immediately:	queue buffer after each write() call
>   * @allow_zero_bytesused:	allow bytesused == 0 to be passed to the driver
>   * @lock:	pointer to a mutex that protects the vb2_queue struct. The
> - *		driver can set this to a mutex to let the v4l2 core serialize
> + *		driver can set this to a mutex to let the vb2 core serialize
>   *		the queuing ioctls. If the driver wants to handle locking
>   *		itself, then this should be set to NULL. This lock is not used
>   *		by the videobuf2 core API.
> @@ -351,10 +366,13 @@ struct v4l2_fh;
>   *		drivers to easily associate an owner filehandle with the queue.
>   * @ops:	driver-specific callbacks
>   * @mem_ops:	memory allocator specific callbacks
> + * @buf_ops:	callbacks to deliver buffer information
> + *		between user-space and kernel-space
>   * @drv_priv:	driver private data
>   * @buf_struct_size: size of the driver-specific buffer structure;
>   *		"0" indicates the driver doesn't want to use a custom buffer
> - *		structure type, so sizeof(struct vb2_buffer) will is used
> + *		structure type, so, sizeof(struct vb2_v4l2_buffer) will is used
> + *		in case of v4l2.
>   * @timestamp_flags: Timestamp flags; V4L2_BUF_FLAG_TIMESTAMP_* and
>   *		V4L2_BUF_FLAG_TSTAMP_SRC_*
>   * @gfp_flags:	additional gfp flags used when allocating the buffers.
> @@ -385,6 +403,8 @@ struct v4l2_fh;
>   * @waiting_for_buffers: used in poll() to check if vb2 is still waiting for
>   *		buffers. Only set for capture queues if qbuf has not yet been
>   *		called since poll() needs to return POLLERR in that situation.
> + * @is_multiplanar: set if buffer type is multiplanar
> + * @is_output:	set if buffer type is output
>   * @last_buffer_dequeued: used in poll() and DQBUF to immediately return if the
>   *		last decoded buffer was already dequeued. Set for capture queues
>   *		when a buffer with the V4L2_BUF_FLAG_LAST is dequeued.
> @@ -399,10 +419,12 @@ struct vb2_queue {
>  	unsigned			allow_zero_bytesused:1;
>  
>  	struct mutex			*lock;
> -	struct v4l2_fh			*owner;
> +	void				*owner;
>  
>  	const struct vb2_ops		*ops;
>  	const struct vb2_mem_ops	*mem_ops;
> +	const struct vb2_buf_ops	*buf_ops;
> +
>  	void				*drv_priv;
>  	unsigned int			buf_struct_size;
>  	u32				timestamp_flags;
> @@ -412,7 +434,7 @@ struct vb2_queue {
>  	/* private: internal use only */
>  	struct mutex			mmap_lock;
>  	unsigned int			memory;
> -	struct vb2_buffer		*bufs[VIDEO_MAX_FRAME];
> +	struct vb2_buffer		*bufs[VB2_MAX_FRAME];
>  	unsigned int			num_buffers;
>  
>  	struct list_head		queued_list;
> @@ -423,13 +445,15 @@ struct vb2_queue {
>  	spinlock_t			done_lock;
>  	wait_queue_head_t		done_wq;
>  
> -	void				*alloc_ctx[VIDEO_MAX_PLANES];
> -	unsigned int			plane_sizes[VIDEO_MAX_PLANES];
> +	void				*alloc_ctx[VB2_MAX_PLANES];
> +	unsigned int			plane_sizes[VB2_MAX_PLANES];
>  
>  	unsigned int			streaming:1;
>  	unsigned int			start_streaming_called:1;
>  	unsigned int			error:1;
>  	unsigned int			waiting_for_buffers:1;
> +	unsigned int			is_multiplanar:1;
> +	unsigned int			is_output:1;
>  	unsigned int			last_buffer_dequeued:1;
>  
>  	struct vb2_fileio_data		*fileio;
> @@ -455,25 +479,7 @@ void vb2_buffer_done(struct vb2_buffer *vb, enum vb2_buffer_state state);
>  void vb2_discard_done(struct vb2_queue *q);
>  int vb2_wait_for_all_buffers(struct vb2_queue *q);
>  
> -int vb2_querybuf(struct vb2_queue *q, struct v4l2_buffer *b);
> -int vb2_reqbufs(struct vb2_queue *q, struct v4l2_requestbuffers *req);
> -
> -int vb2_create_bufs(struct vb2_queue *q, struct v4l2_create_buffers *create);
> -int vb2_prepare_buf(struct vb2_queue *q, struct v4l2_buffer *b);
> -
> -int __must_check vb2_queue_init(struct vb2_queue *q);
> -
> -void vb2_queue_release(struct vb2_queue *q);
>  void vb2_queue_error(struct vb2_queue *q);
> -
> -int vb2_qbuf(struct vb2_queue *q, struct v4l2_buffer *b);
> -int vb2_expbuf(struct vb2_queue *q, struct v4l2_exportbuffer *eb);
> -int vb2_dqbuf(struct vb2_queue *q, struct v4l2_buffer *b, bool nonblocking);
> -
> -int vb2_streamon(struct vb2_queue *q, enum v4l2_buf_type type);
> -int vb2_streamoff(struct vb2_queue *q, enum v4l2_buf_type type);
> -
> -int vb2_mmap(struct vb2_queue *q, struct vm_area_struct *vma);
>  #ifndef CONFIG_MMU
>  unsigned long vb2_get_unmapped_area(struct vb2_queue *q,
>  				    unsigned long addr,
> @@ -481,41 +487,6 @@ unsigned long vb2_get_unmapped_area(struct vb2_queue *q,
>  				    unsigned long pgoff,
>  				    unsigned long flags);
>  #endif
> -unsigned int vb2_poll(struct vb2_queue *q, struct file *file, poll_table *wait);
> -size_t vb2_read(struct vb2_queue *q, char __user *data, size_t count,
> -		loff_t *ppos, int nonblock);
> -size_t vb2_write(struct vb2_queue *q, const char __user *data, size_t count,
> -		loff_t *ppos, int nonblock);
> -
> -/*
> - * vb2_thread_fnc - callback function for use with vb2_thread
> - *
> - * This is called whenever a buffer is dequeued in the thread.
> - */
> -typedef int (*vb2_thread_fnc)(struct vb2_buffer *vb, void *priv);
> -
> -/**
> - * vb2_thread_start() - start a thread for the given queue.
> - * @q:		videobuf queue
> - * @fnc:	callback function
> - * @priv:	priv pointer passed to the callback function
> - * @thread_name:the name of the thread. This will be prefixed with "vb2-".
> - *
> - * This starts a thread that will queue and dequeue until an error occurs
> - * or @vb2_thread_stop is called.
> - *
> - * This function should not be used for anything else but the videobuf2-dvb
> - * support. If you think you have another good use-case for this, then please
> - * contact the linux-media mailinglist first.
> - */
> -int vb2_thread_start(struct vb2_queue *q, vb2_thread_fnc fnc, void *priv,
> -		     const char *thread_name);
> -
> -/**
> - * vb2_thread_stop() - stop the thread for the given queue.
> - * @q:		videobuf queue
> - */
> -int vb2_thread_stop(struct vb2_queue *q);
>  
>  /**
>   * vb2_is_streaming() - return streaming status of the queue
> @@ -527,23 +498,6 @@ static inline bool vb2_is_streaming(struct vb2_queue *q)
>  }
>  
>  /**
> - * vb2_fileio_is_active() - return true if fileio is active.
> - * @q:		videobuf queue
> - *
> - * This returns true if read() or write() is used to stream the data
> - * as opposed to stream I/O. This is almost never an important distinction,
> - * except in rare cases. One such case is that using read() or write() to
> - * stream a format using V4L2_FIELD_ALTERNATE is not allowed since there
> - * is no way you can pass the field information of each buffer to/from
> - * userspace. A driver that supports this field format should check for
> - * this in the queue_setup op and reject it if this function returns true.
> - */
> -static inline bool vb2_fileio_is_active(struct vb2_queue *q)
> -{
> -	return q->fileio;
> -}
> -
> -/**
>   * vb2_is_busy() - return busy status of the queue
>   * @q:		videobuf queue
>   *
> @@ -620,47 +574,4 @@ static inline void vb2_clear_last_buffer_dequeued(struct vb2_queue *q)
>  	q->last_buffer_dequeued = false;
>  }
>  
> -/*
> - * The following functions are not part of the vb2 core API, but are simple
> - * helper functions that you can use in your struct v4l2_file_operations,
> - * struct v4l2_ioctl_ops and struct vb2_ops. They will serialize if vb2_queue->lock
> - * or video_device->lock is set, and they will set and test vb2_queue->owner
> - * to check if the calling filehandle is permitted to do the queuing operation.
> - */
> -
> -/* struct v4l2_ioctl_ops helpers */
> -
> -int vb2_ioctl_reqbufs(struct file *file, void *priv,
> -			  struct v4l2_requestbuffers *p);
> -int vb2_ioctl_create_bufs(struct file *file, void *priv,
> -			  struct v4l2_create_buffers *p);
> -int vb2_ioctl_prepare_buf(struct file *file, void *priv,
> -			  struct v4l2_buffer *p);
> -int vb2_ioctl_querybuf(struct file *file, void *priv, struct v4l2_buffer *p);
> -int vb2_ioctl_qbuf(struct file *file, void *priv, struct v4l2_buffer *p);
> -int vb2_ioctl_dqbuf(struct file *file, void *priv, struct v4l2_buffer *p);
> -int vb2_ioctl_streamon(struct file *file, void *priv, enum v4l2_buf_type i);
> -int vb2_ioctl_streamoff(struct file *file, void *priv, enum v4l2_buf_type i);
> -int vb2_ioctl_expbuf(struct file *file, void *priv,
> -	struct v4l2_exportbuffer *p);
> -
> -/* struct v4l2_file_operations helpers */
> -
> -int vb2_fop_mmap(struct file *file, struct vm_area_struct *vma);
> -int vb2_fop_release(struct file *file);
> -int _vb2_fop_release(struct file *file, struct mutex *lock);
> -ssize_t vb2_fop_write(struct file *file, const char __user *buf,
> -		size_t count, loff_t *ppos);
> -ssize_t vb2_fop_read(struct file *file, char __user *buf,
> -		size_t count, loff_t *ppos);
> -unsigned int vb2_fop_poll(struct file *file, poll_table *wait);
> -#ifndef CONFIG_MMU
> -unsigned long vb2_fop_get_unmapped_area(struct file *file, unsigned long addr,
> -		unsigned long len, unsigned long pgoff, unsigned long flags);
> -#endif
> -
> -/* struct vb2_ops helpers, only use if vq->lock is non-NULL. */
> -
> -void vb2_ops_wait_prepare(struct vb2_queue *vq);
> -void vb2_ops_wait_finish(struct vb2_queue *vq);
>  #endif /* _MEDIA_VIDEOBUF2_CORE_H */
> diff --git a/include/media/videobuf2-v4l2.h b/include/media/videobuf2-v4l2.h
> index fc2dbe9..790cb7a 100644
> --- a/include/media/videobuf2-v4l2.h
> +++ b/include/media/videobuf2-v4l2.h
> @@ -40,4 +40,120 @@ struct vb2_v4l2_buffer {
>  #define to_vb2_v4l2_buffer(vb) \
>  	(container_of(vb, struct vb2_v4l2_buffer, vb2_buf))
>  
> +
> +int vb2_querybuf(struct vb2_queue *q, struct v4l2_buffer *b);
> +int vb2_reqbufs(struct vb2_queue *q, struct v4l2_requestbuffers *req);
> +
> +int vb2_create_bufs(struct vb2_queue *q, struct v4l2_create_buffers *create);
> +int vb2_prepare_buf(struct vb2_queue *q, struct v4l2_buffer *b);
> +
> +int __must_check vb2_queue_init(struct vb2_queue *q);
> +
> +void vb2_queue_release(struct vb2_queue *q);
> +
> +int vb2_qbuf(struct vb2_queue *q, struct v4l2_buffer *b);
> +int vb2_expbuf(struct vb2_queue *q, struct v4l2_exportbuffer *eb);
> +int vb2_dqbuf(struct vb2_queue *q, struct v4l2_buffer *b, bool nonblocking);
> +
> +int vb2_streamon(struct vb2_queue *q, enum v4l2_buf_type type);
> +int vb2_streamoff(struct vb2_queue *q, enum v4l2_buf_type type);
> +int vb2_mmap(struct vb2_queue *q, struct vm_area_struct *vma);
> +unsigned int vb2_poll(struct vb2_queue *q, struct file *file, poll_table *wait);
> +size_t vb2_read(struct vb2_queue *q, char __user *data, size_t count,
> +		loff_t *ppos, int nonblock);
> +size_t vb2_write(struct vb2_queue *q, const char __user *data, size_t count,
> +		loff_t *ppos, int nonblock);
> +
> +/*
> + * vb2_thread_fnc - callback function for use with vb2_thread
> + *
> + * This is called whenever a buffer is dequeued in the thread.
> + */
> +typedef int (*vb2_thread_fnc)(struct vb2_buffer *vb, void *priv);
> +
> +/**
> + * vb2_thread_start() - start a thread for the given queue.
> + * @q:		videobuf queue
> + * @fnc:	callback function
> + * @priv:	priv pointer passed to the callback function
> + * @thread_name:the name of the thread. This will be prefixed with "vb2-".
> + *
> + * This starts a thread that will queue and dequeue until an error occurs
> + * or @vb2_thread_stop is called.
> + *
> + * This function should not be used for anything else but the videobuf2-dvb
> + * support. If you think you have another good use-case for this, then please
> + * contact the linux-media mailinglist first.
> + */
> +int vb2_thread_start(struct vb2_queue *q, vb2_thread_fnc fnc, void *priv,
> +		     const char *thread_name);
> +
> +/**
> + * vb2_thread_stop() - stop the thread for the given queue.
> + * @q:		videobuf queue
> + */
> +int vb2_thread_stop(struct vb2_queue *q);
> +
> +/**
> + * vb2_fileio_is_active() - return true if fileio is active.
> + * @q:		videobuf queue
> + *
> + * This returns true if read() or write() is used to stream the data
> + * as opposed to stream I/O. This is almost never an important distinction,
> + * except in rare cases. One such case is that using read() or write() to
> + * stream a format using V4L2_FIELD_ALTERNATE is not allowed since there
> + * is no way you can pass the field information of each buffer to/from
> + * userspace. A driver that supports this field format should check for
> + * this in the queue_setup op and reject it if this function returns true.
> + */
> +static inline bool vb2_fileio_is_active(struct vb2_queue *q)
> +{
> +	return q->fileio;
> +}
> +
> +/*
> + * The following functions are not part of the vb2 core API, but are simple
> + * helper functions that you can use in your struct v4l2_file_operations,
> + * struct v4l2_ioctl_ops and struct vb2_ops. They will serialize
> + * if vb2_queue->lock or video_device->lock is set, and they will set
> + * and test vb2_queue->owner to check if the calling filehandle is permitted
> + * to do the queuing operation.
> + */
> +
> +/* struct v4l2_ioctl_ops helpers */
> +
> +int vb2_ioctl_reqbufs(struct file *file, void *priv,
> +			  struct v4l2_requestbuffers *p);
> +int vb2_ioctl_create_bufs(struct file *file, void *priv,
> +			  struct v4l2_create_buffers *p);
> +int vb2_ioctl_prepare_buf(struct file *file, void *priv,
> +			  struct v4l2_buffer *p);
> +int vb2_ioctl_querybuf(struct file *file, void *priv, struct v4l2_buffer *p);
> +int vb2_ioctl_qbuf(struct file *file, void *priv, struct v4l2_buffer *p);
> +int vb2_ioctl_dqbuf(struct file *file, void *priv, struct v4l2_buffer *p);
> +int vb2_ioctl_streamon(struct file *file, void *priv, enum v4l2_buf_type i);
> +int vb2_ioctl_streamoff(struct file *file, void *priv, enum v4l2_buf_type i);
> +int vb2_ioctl_expbuf(struct file *file, void *priv,
> +	struct v4l2_exportbuffer *p);
> +
> +/* struct v4l2_file_operations helpers */
> +
> +int vb2_fop_mmap(struct file *file, struct vm_area_struct *vma);
> +int vb2_fop_release(struct file *file);
> +int _vb2_fop_release(struct file *file, struct mutex *lock);
> +ssize_t vb2_fop_write(struct file *file, const char __user *buf,
> +		size_t count, loff_t *ppos);
> +ssize_t vb2_fop_read(struct file *file, char __user *buf,
> +		size_t count, loff_t *ppos);
> +unsigned int vb2_fop_poll(struct file *file, poll_table *wait);
> +#ifndef CONFIG_MMU
> +unsigned long vb2_fop_get_unmapped_area(struct file *file, unsigned long addr,
> +		unsigned long len, unsigned long pgoff, unsigned long flags);
> +#endif
> +
> +/* struct vb2_ops helpers, only use if vq->lock is non-NULL. */
> +
> +void vb2_ops_wait_prepare(struct vb2_queue *vq);
> +void vb2_ops_wait_finish(struct vb2_queue *vq);
> +
>  #endif /* _MEDIA_VIDEOBUF2_V4L2_H */
> diff --git a/include/trace/events/v4l2.h b/include/trace/events/v4l2.h
> index b015b38..f31b258 100644
> --- a/include/trace/events/v4l2.h
> +++ b/include/trace/events/v4l2.h
> @@ -5,6 +5,7 @@
>  #define _TRACE_V4L2_H
>  
>  #include <linux/tracepoint.h>
> +#include <media/videobuf2-v4l2.h>
>  
>  /* Enums require being exported to userspace, for user tool parsing */
>  #undef EM
> @@ -203,7 +204,8 @@ DECLARE_EVENT_CLASS(vb2_event_class,
>  
>  	TP_fast_assign(
>  		struct vb2_v4l2_buffer *vbuf = to_vb2_v4l2_buffer(vb);
> -		__entry->minor = q->owner ? q->owner->vdev->minor : -1;
> +		struct v4l2_fh *owner = (struct v4l2_fh *) q->owner;
> +		__entry->minor = owner ? owner->vdev->minor : -1;
>  		__entry->queued_count = q->queued_count;
>  		__entry->owned_by_drv_count =
>  			atomic_read(&q->owned_by_drv_count);
> 

