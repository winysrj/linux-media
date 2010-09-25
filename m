Return-path: <mchehab@pedra>
Received: from smtp-vbr6.xs4all.nl ([194.109.24.26]:1533 "EHLO
	smtp-vbr6.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751878Ab0IYOvc (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 25 Sep 2010 10:51:32 -0400
To: linux-media@vger.kernel.org
Subject: Re: [PATCH v1 1/7] v4l: add videobuf2 Video for Linux 2 driver framework (retry)
Cc: kyungmin.park@samsung.com, m.szyprowski@samsung.com,
	t.fujak@samsung.com, pawel@osciak.com
From: Hans Verkuil <hverkuil@xs4all.nl>
Date: Sat, 25 Sep 2010 16:51:13 +0200
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201009251651.13560.hverkuil@xs4all.nl>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

(Resending: fixing Pawel's email address and adding an extra code review
comment regarding the mem ops)


Hi Pawel,

I finally had some time for a code review:

On Thursday, September 09, 2010 11:19:42 Pawel Osciak wrote:
> Videobuf2 is a Video for Linux 2 API-compatible driver framework for
> multimedia devices. It acts as an intermediate layer between userspace
> applications and device drivers. It also provides low-level, modular
> memory management functions for drivers.
> 
> Videobuf2 eases driver development, reduces drivers' code size and aids in
> proper and consistent implementation of V4L2 API in drivers.
> 
> Videobuf2 memory management backend is fully modular. This allows custom
> memory management routines for devices and platforms with non-standard
> memory management requirements to be plugged in, without changing the
> high-level buffer management functions and API.
> 
> The framework provides:
> - implementations of streaming I/O V4L2 ioctls and file operations
> - high-level video buffer, video queue and state management functions
> - video buffer memory allocation and management
> 
> Signed-off-by: Pawel Osciak <p.osciak@samsung.com>
> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
> ---
>  drivers/media/video/Kconfig          |    3 +
>  drivers/media/video/Makefile         |    2 +
>  drivers/media/video/videobuf2-core.c | 1457 ++++++++++++++++++++++++++++++++++
>  include/media/videobuf2-core.h       |  337 ++++++++
>  4 files changed, 1799 insertions(+), 0 deletions(-)
>  create mode 100644 drivers/media/video/videobuf2-core.c
>  create mode 100644 include/media/videobuf2-core.h
> 

<snip>

> +/**
> + * vb2_reqbufs() - Initiate streaming
> + * @q:		videobuf2 queue
> + * @req:	struct passed from userspace to vidioc_reqbufs handler in driver
> + *
> + * Should be called from vidioc_reqbufs ioctl handler of a driver.
> + * This function:
> + * 1) verifies streaming parameters passed from the userspace,
> + * 2) sets up the queue,
> + * 3) negotiates number of buffers and planes per buffer with the driver
> + *    to be used during streaming,
> + * 4) allocates internal buffer structures (struct vb2_buffer), according to
> + *    the agreed parameters,
> + * 5) for MMAP memory type, allocates actual video memory, using the
> + *    memory handling/allocation routines provided during queue initialization
> + *
> + * If req->count is 0, all the memory will be freed instead.
> + * If the queue has been allocated previously (by a previous vb2_reqbufs) call
> + * and the queue is not busy, memory will be reallocated.
> + *
> + * The return values from this function are intended to be directly returned
> + * from vidioc_reqbufs handler in driver.
> + */
> +int vb2_reqbufs(struct vb2_queue *q, struct v4l2_requestbuffers *req)
> +{
> +	unsigned int num_buffers, num_planes;
> +	int ret = 0;
> +
> +	if (req->memory != V4L2_MEMORY_MMAP
> +			&& req->memory != V4L2_MEMORY_USERPTR) {
> +		dprintk(1, "reqbufs: unsupported memory type\n");
> +		return -EINVAL;
> +	}
> +
> +	mutex_lock(&q->vb_lock);
> +
> +	if (req->type != q->type) {
> +		dprintk(1, "reqbufs: queue type invalid\n");
> +		ret = -EINVAL;
> +		goto end;
> +	}
> +
> +	if (q->streaming) {
> +		dprintk(1, "reqbufs: streaming active\n");
> +		ret = -EBUSY;
> +		goto end;
> +	}
> +
> +	if (req->count == 0) {
> +		/* Free/release memory for count = 0, but only if unused */
> +		if (q->memory == V4L2_MEMORY_MMAP && __buffers_in_use(q)) {
> +			dprintk(1, "reqbufs: memory in use, cannot free\n");
> +			ret = -EBUSY;
> +			goto end;
> +		}
> +
> +		ret = __vb2_queue_free(q);
> +		goto end;
> +	}
> +
> +	if (q->num_buffers != 0) {
> +		/*
> +		 * We already have buffers allocated, so a reallocation is
> +		 * required, but only if the buffers are not in use.
> +		 */
> +		if (q->memory == V4L2_MEMORY_MMAP && __buffers_in_use(q)) {
> +			dprintk(1, "reqbufs: memory in use, "
> +					"cannot reallocate\n");
> +			ret = -EBUSY;
> +			goto end;
> +		}
> +
> +		ret = __vb2_queue_free(q);

Hmmm, __vb2_queue_free can't fail: it always returns 0. If you make __vb2_queue_free
a void function, then there is no need to test for any error code.

> +		if (ret)
> +			goto end;
> +	}
> +
> +	num_buffers = min_t(unsigned int, req->count, VIDEO_MAX_FRAME);
> +
> +	/* Ask the driver how many buffers and planes per buffer it requires */
> +	ret = q->ops->queue_negotiate(q, &num_buffers, &num_planes);
> +	if (ret)
> +		goto end;
> +
> +	/*
> +	 * Make sure all the required memory ops for given memory type
> +	 * are available.
> +	 */
> +	if (req->memory == V4L2_MEMORY_MMAP
> +			&& __verify_mmap_ops(q, num_planes)) {
> +		dprintk(1, "reqbufs: MMAP for current setup unsupported\n");
> +		ret = -EINVAL;
> +		goto end;
> +	} else if (req->memory == V4L2_MEMORY_USERPTR
> +			&& __verify_userptr_ops(q, num_planes)) {
> +		dprintk(1, "reqbufs: USERPTR for current setup unsupported\n");
> +		ret = -EINVAL;
> +		goto end;
> +	}
> +
> +	/* Finally, allocate buffers and video memory */
> +	ret = __vb2_queue_alloc(q, req->memory, num_buffers, num_planes);
> +	if (ret < 0) {
> +		dprintk(1, "Memory allocation failed with error: %d\n", ret);
> +	} else {
> +		/*
> +		 * Return the number of successfully allocated buffers
> +		 * to the userspace.
> +		 */
> +		req->count = ret;
> +		ret = 0;
> +	}
> +
> +	q->memory = req->memory;
> +
> +end:
> +	mutex_unlock(&q->vb_lock);
> +	return ret;
> +}
> +EXPORT_SYMBOL_GPL(vb2_reqbufs);
> +
> +/**
> + * vb2_plane_vaddr() - Return a kernel virtual address of a given plane
> + * @vb:		vb2_buffer to which the plane in question belongs to
> + * @plane_no:	plane number for which the address is to be returned
> + *
> + * This function returns a kernel virtual address of a given plane if
> + * such a mapping exist, NULL otherwise.
> + */
> +void *vb2_plane_vaddr(struct vb2_buffer *vb, unsigned int plane_no)
> +{
> +	struct vb2_queue *q = vb->vb2_queue;
> +
> +	if (plane_no > vb->num_planes)
> +		return NULL;
> +
> +	return call_memop(q, plane_no, vaddr, vb->planes[plane_no].mem_priv);
> +
> +}
> +EXPORT_SYMBOL_GPL(vb2_plane_vaddr);
> +
> +/**
> + * vb2_plane_paddr() - Return the physical address of a given plane
> + * @vb:		vb2_buffer to which the plane in question belongs to
> + * @plane_no:	plane number for which the address is to be returned
> + *
> + * This function returns a physical address of a given plane if available,
> + * NULL otherwise.
> + */
> +unsigned long vb2_plane_paddr(struct vb2_buffer *vb, unsigned int plane_no)

Shouldn't this return phys_addr_t? That seems more appropriate.

> +{
> +	struct vb2_queue *q = vb->vb2_queue;
> +
> +	if (plane_no > vb->num_planes)
> +		return 0UL;
> +
> +	return call_memop(q, plane_no, paddr, vb->planes[plane_no].mem_priv);
> +}
> +EXPORT_SYMBOL_GPL(vb2_plane_paddr);
> +
> +/**
> + * vb2_buffer_done() - inform videobuf that an operation on a buffer is finished
> + * @vb:		vb2_buffer returned from the driver
> + * @state:	either VB2_BUF_STATE_DONE if the operation finished successfully
> + *		or VB2_BUF_STATE_ERROR if the operation finished with an error
> + *
> + * This function should be called by the driver after a hardware operation on
> + * a buffer is finished and the buffer may be returned to userspace. The driver
> + * cannot use this buffer anymore until it is queued back to it by videobuf
> + * by the means of buf_queue callback. Only buffers previously queued to the
> + * driver by buf_queue can be passed to this function.
> + */
> +void vb2_buffer_done(struct vb2_buffer *vb, enum vb2_buffer_state state)
> +{
> +	struct vb2_queue *q = vb->vb2_queue;
> +	unsigned long flags;
> +
> +	if (vb->state != VB2_BUF_STATE_ACTIVE)
> +		return;
> +
> +	if (state != VB2_BUF_STATE_DONE && state != VB2_BUF_STATE_ERROR)
> +		return;

These two checks should call WARN() to clearly signal a driver bug.

> +
> +	dprintk(4, "Done processing on buffer %d, state: %d\n",
> +			vb->v4l2_buf.index, vb->state);
> +
> +	/* Add the buffer to the done buffers list */
> +	spin_lock_irqsave(&q->done_lock, flags);
> +	vb->state = state;
> +	list_add_tail(&vb->done_entry, &q->done_list);
> +	spin_unlock_irqrestore(&q->done_lock, flags);
> +
> +	/* Inform any processes that may be waiting for buffers */
> +	wake_up_interruptible(&q->done_wq);
> +}
> +EXPORT_SYMBOL_GPL(vb2_buffer_done);
> +
> +/**
> + * __fill_vb2_buffer() - fill a vb2_buffer with information provided in
> + * a v4l2_buffer by the userspace
> + */
> +static int __fill_vb2_buffer(struct vb2_buffer *vb, struct v4l2_buffer *b,
> +				struct v4l2_plane *v4l2_planes)
> +{
> +	unsigned int plane;
> +	int ret;
> +
> +	if (V4L2_TYPE_IS_MULTIPLANAR(b->type)) {
> +		/*
> +		 * Verify that the userspace gave us a valid array for
> +		 * plane information.
> +		 */
> +		ret = __verify_planes_array(vb, b);
> +		if (ret)
> +			return ret;
> +
> +		/* Fill in driver-provided information for OUTPUT types */
> +		if (V4L2_TYPE_IS_OUTPUT(b->type)) {
> +			/*
> +			 * Will have to go up to b->length when API starts
> +			 * accepting variable number of planes.
> +			 */
> +			for (plane = 0; plane < vb->num_planes; ++plane) {
> +				v4l2_planes[plane].bytesused =
> +					b->m.planes[plane].bytesused;
> +				v4l2_planes[plane].data_offset =
> +					b->m.planes[plane].data_offset;
> +			}
> +		}
> +
> +		if (b->memory == V4L2_MEMORY_USERPTR) {
> +			for (plane = 0; plane < vb->num_planes; ++plane) {
> +				v4l2_planes[plane].m.userptr =
> +					b->m.planes[plane].m.userptr;
> +				v4l2_planes[plane].length =
> +					b->m.planes[plane].length;
> +			}
> +		}
> +	} else {
> +		/*
> +		 * Single-planar buffers do not use planes array,
> +		 * so fill in relevant v4l2_buffer struct fields instead.
> +		 * In videobuf we use our internal V4l2_planes struct for
> +		 * single-planar buffers as well, for simplicity.
> +		 */
> +		if (V4L2_TYPE_IS_OUTPUT(b->type))
> +			v4l2_planes[0].bytesused = b->bytesused;
> +
> +		if (b->memory == V4L2_MEMORY_USERPTR) {
> +			v4l2_planes[0].m.userptr = b->m.userptr;
> +			v4l2_planes[0].length = b->length;
> +		}
> +	}
> +
> +	vb->v4l2_buf.field = b->field;
> +	vb->v4l2_buf.timestamp = b->timestamp;
> +
> +	return 0;
> +}
> +
> +/**
> + * __qbuf_userptr() - handle qbuf of a USERPTR buffer
> + */
> +static int __qbuf_userptr(struct vb2_buffer *vb, struct v4l2_buffer *b)
> +{
> +	struct v4l2_plane planes[VIDEO_MAX_PLANES];
> +	struct vb2_queue *q = vb->vb2_queue;
> +	void *mem_priv = NULL;
> +	unsigned int plane;
> +	int ret;
> +
> +	/* Verify and copy relevant information provided by the userspace */
> +	ret = __fill_vb2_buffer(vb, b, planes);
> +	if (ret)
> +		return ret;
> +
> +	for (plane = 0; plane < vb->num_planes; ++plane) {
> +		/* Skip the plane if already verified */
> +		if (vb->v4l2_planes[plane].m.userptr == planes[plane].m.userptr
> +		    && vb->v4l2_planes[plane].length == planes[plane].length)
> +			continue;
> +
> +		dprintk(3, "qbuf: userspace address for plane %d changed, "
> +				"reacquiring memory\n", plane);
> +
> +		/* Release previously acquired memory if present */
> +		if (vb->planes[plane].mem_priv)
> +			call_memop(q, plane, put_userptr,
> +					vb->planes[plane].mem_priv);
> +
> +		vb->planes[plane].mem_priv = NULL;
> +
> +		/* Acquire each plane's memory */
> +		if (mem_ops(q, plane)->get_userptr) {
> +			mem_priv = mem_ops(q, plane)->get_userptr(
> +							planes[plane].m.userptr,
> +							planes[plane].length);
> +			if (IS_ERR(mem_priv)) {
> +				dprintk(1, "qbuf: failed acquiring userspace "
> +						"memory for plane %d\n", plane);
> +				goto err;
> +			}

Just to verify my understanding: get_userptr is responsible for locking the
pages into memory and to increase a use count on that memory. So if the app
would do a QBUF, then free the memory and allocate a new buffer, then the
original buffer memory is not released until put_userptr is called, and the
pointer of the new buffer that the app allocated will always be different from
the original buffer (since it was still in use when the app allocated the new
one).

I've always wondered if something nasty like this was handled correctly. I never
had the time to dive into the mm core, though.

> +
> +			vb->planes[plane].mem_priv = mem_priv;
> +		}
> +	}
> +
> +	/*
> +	 * Call driver-specific initialization on the newly acquired buffer,
> +	 * if provided.
> +	 */
> +	if (q->ops->buf_init) {
> +		ret = q->ops->buf_init(vb);
> +		if (ret) {
> +			dprintk(1, "qbuf: buffer initialization failed\n");
> +			goto err;
> +		}
> +	}
> +
> +	/*
> +	 * Now that everything is in order, copy relevant information
> +	 * provided by userspace.
> +	 */
> +	for (plane = 0; plane < vb->num_planes; ++plane)
> +		vb->v4l2_planes[plane] = planes[plane];
> +
> +	return 0;
> +err:
> +	/* In case of errors, release planes that were already acquired */
> +	for (; plane > 0; --plane) {
> +		call_memop(q, plane, put_userptr,
> +				vb->planes[plane - 1].mem_priv);
> +		vb->planes[plane - 1].mem_priv = NULL;
> +	}
> +
> +	return ret;
> +}
> +
> +/**
> + * __qbuf_mmap() - handle qbuf of an MMAP buffer
> + */
> +static int __qbuf_mmap(struct vb2_buffer *vb, struct v4l2_buffer *b)
> +{
> +	return __fill_vb2_buffer(vb, b, vb->v4l2_planes);
> +}
> +
> +/**
> + * __enqueue_in_driver() - enqueue a vb2_buffer in driver for processing
> + */
> +static void __enqueue_in_driver(struct vb2_buffer *vb)
> +{
> +	struct vb2_queue *q = vb->vb2_queue;
> +	unsigned long flags;
> +
> +	spin_lock_irqsave(q->drv_lock, flags);
> +	vb->state = VB2_BUF_STATE_ACTIVE;
> +	q->ops->buf_queue(vb);
> +	spin_unlock_irqrestore(q->drv_lock, flags);
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
> + * 2) calls buf_prepare callback in the driver (if provided), in which
> + *    driver-specific buffer initialization can be performed,
> + * 3) if streaming is on, queues the buffer in driver by the means of buf_queue
> + *    callback for processing.
> + *
> + * The return values from this function are intended to be directly returned
> + * from vidioc_qbuf handler in driver.
> + */
> +int vb2_qbuf(struct vb2_queue *q, struct v4l2_buffer *b)
> +{
> +	struct vb2_buffer *vb;
> +	int ret;
> +
> +	mutex_lock(&q->vb_lock);
> +
> +	ret = -EINVAL;
> +	if (b->type != q->type) {
> +		dprintk(1, "qbuf: invalid buffer type\n");
> +		goto done;
> +	}
> +	if (b->index >= q->num_buffers) {
> +		dprintk(1, "qbuf: buffer index out of range\n");
> +		goto done;
> +	}
> +
> +	vb = q->bufs[b->index];
> +	if (NULL == vb) {
> +		/* Should never happen */
> +		dprintk(1, "qbuf: buffer is NULL\n");
> +		goto done;
> +	}
> +
> +	if (b->memory != q->memory) {
> +		dprintk(1, "qbuf: invalid memory type\n");
> +		goto done;
> +	}
> +
> +	if (vb->state != VB2_BUF_STATE_DEQUEUED) {
> +		dprintk(1, "qbuf: buffer already in use\n");
> +		goto done;
> +	}
> +
> +	if (q->memory == V4L2_MEMORY_MMAP)
> +		ret = __qbuf_mmap(vb, b);
> +	else if (q->memory == V4L2_MEMORY_USERPTR)
> +		ret = __qbuf_userptr(vb, b);
> +	if (ret)
> +		goto done;
> +
> +	if (q->ops->buf_prepare) {
> +		ret = q->ops->buf_prepare(vb);
> +		if (ret) {
> +			dprintk(1, "qbuf: buffer preparation failed\n");
> +			goto done;
> +		}
> +	}
> +
> +	/*
> +	 * Add to the queued buffers list, a buffer will stay on it until
> +	 * dequeued in dqbuf.
> +	 */
> +	list_add_tail(&vb->queued_entry, &q->queued_list);
> +	vb->state = VB2_BUF_STATE_QUEUED;
> +
> +	/*
> +	 * If already streaming, give the buffer to driver for processing.
> +	 * If not, the buffer will be given to driver on next streamon.
> +	 */
> +	if (q->streaming)
> +		__enqueue_in_driver(vb);
> +
> +	dprintk(1, "qbuf of buffer %d succeeded\n", vb->v4l2_buf.index);
> +	ret = 0;
> +done:
> +	mutex_unlock(&q->vb_lock);
> +	return ret;
> +}
> +EXPORT_SYMBOL_GPL(vb2_qbuf);
> +
> +/**
> + * __vb2_wait_for_done_vb() - wait for a buffer to become available
> + * for dequeuing
> + *
> + * Will sleep if required for nonblocking == false.
> + */
> +static int __vb2_wait_for_done_vb(struct vb2_queue *q, int nonblocking)
> +{
> +	int retval = 0;
> +
> +checks:
> +	if (!q->streaming) {
> +		dprintk(1, "Streaming off, will not wait for buffers\n");
> +		retval = -EINVAL;
> +		goto end;
> +	}
> +
> +	/*
> +	 * Buffers may be added to vb_done_list without holding the vb_lock,
> +	 * but removal is performed only while holding both vb_lock and the
> +	 * vb_done_lock spinlock. Thus we can be sure that as long as we hold
> +	 * vb_lock, the list will remain not empty if this check succeeds.
> +	 */
> +	if (list_empty(&q->done_list)) {
> +		if (nonblocking) {
> +			dprintk(1, "Nonblocking and no buffers to dequeue, "
> +					"will not wait\n");
> +			retval = -EAGAIN;
> +			goto end;
> +		}
> +
> +		/*
> +		 * We are streaming and nonblocking, wait for another buffer to
> +		 * become ready or for streamoff. vb_lock is released to allow
> +		 * streamoff or qbuf to be called while waiting.
> +		 */
> +		mutex_unlock(&q->vb_lock);
> +		/*
> +		 * Although the mutex is released here, we will be reevaluating
> +		 * both conditions again after reacquiring it.
> +		 */
> +		dprintk(3, "Will sleep waiting for buffers\n");
> +		retval = wait_event_interruptible(q->done_wq,
> +				!list_empty(&q->done_list) || !q->streaming);
> +		mutex_lock(&q->vb_lock);
> +
> +		if (retval)
> +			goto end;
> +
> +		goto checks;
> +	}
> +
> +end:
> +	return retval;
> +}
> +
> +/**
> + * __vb2_get_done_vb() - get a buffer ready for dequeuing
> + *
> + * Will sleep if required for nonblocking == false.
> + */
> +static int __vb2_get_done_vb(struct vb2_queue *q, struct vb2_buffer **vb,
> +				int nonblocking)
> +{
> +	unsigned long flags;
> +	int ret = 0;
> +
> +	/*
> +	 * Wait for at least one buffer to become available on the done_list.
> +	 */
> +	ret = __vb2_wait_for_done_vb(q, nonblocking);
> +	if (ret)
> +		goto end;
> +
> +	/*
> +	 * vb_lock has been held since we last verified that done_list is
> +	 * not empty, so no need for another list_empty(done_list) check.
> +	 */
> +	spin_lock_irqsave(&q->done_lock, flags);
> +	*vb = list_first_entry(&q->done_list, struct vb2_buffer, done_entry);
> +	list_del(&(*vb)->done_entry);
> +	spin_unlock_irqrestore(&q->done_lock, flags);
> +
> +end:
> +	return ret;
> +}
> +
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
> +	struct vb2_buffer *vb = NULL;
> +	int ret;
> +
> +	mutex_lock(&q->vb_lock);
> +
> +	if (b->type != q->type) {
> +		dprintk(1, "dqbuf: invalid buffer type\n");
> +		ret = -EINVAL;
> +		goto done;
> +	}
> +
> +	ret = __vb2_get_done_vb(q, &vb, nonblocking);
> +	if (ret < 0) {
> +		dprintk(1, "dqbuf: error getting next done buffer\n");
> +		goto done;
> +	}
> +
> +	if (q->ops->buf_finish) {
> +		ret = q->ops->buf_finish(vb);
> +		if (ret) {
> +			dprintk(1, "dqbuf: buffer finish failed\n");
> +			goto done;
> +		}
> +	}
> +
> +	switch (vb->state) {
> +	case VB2_BUF_STATE_DONE:
> +		dprintk(3, "dqbuf: Returning done buffer\n");
> +		break;
> +	case VB2_BUF_STATE_ERROR:
> +		dprintk(3, "dqbuf: Returning done buffer with errors\n");
> +		break;
> +	default:
> +		dprintk(1, "dqbuf: Invalid buffer state\n");

Isn't it a driver bug if we get here? In that case we need a WARN.

> +		ret = -EINVAL;
> +		goto done;
> +	}
> +
> +	/* Fill buffer information for the userspace */
> +	__fill_v4l2_buffer(vb, b);
> +	/* Remove from videobuf queue */
> +	list_del(&vb->queued_entry);
> +
> +	dprintk(1, "dqbuf of buffer %d, with state %d\n",
> +			vb->v4l2_buf.index, vb->state);
> +
> +	vb->state = VB2_BUF_STATE_DEQUEUED;
> +
> +done:
> +	mutex_unlock(&q->vb_lock);
> +	return ret;
> +}
> +EXPORT_SYMBOL_GPL(vb2_dqbuf);
> +
> +/**
> + * vb2_streamon - start streaming
> + * @q:		videobuf2 queue
> + * @type:	type argument passed from userspace to vidioc_streamon handler
> + *
> + * Should be called from vidioc_streamon handler of a driver.
> + * This function:
> + * 1) verifies current state
> + * 2) starts streaming and passes any previously queued buffers to the driver
> + *
> + * The return values from this function are intended to be directly returned
> + * from vidioc_streamon handler in the driver.
> + */
> +int vb2_streamon(struct vb2_queue *q, enum v4l2_buf_type type)
> +{
> +	struct vb2_buffer *vb;
> +	int ret = 0;
> +
> +	mutex_lock(&q->vb_lock);
> +
> +	if (type != q->type) {
> +		dprintk(1, "streamon: invalid stream type\n");
> +		ret = -EINVAL;
> +		goto done;
> +	}
> +
> +	if (q->streaming) {
> +		dprintk(1, "streamon: already streaming\n");
> +		ret = -EBUSY;
> +		goto done;
> +	}
> +
> +	/*
> +	 * Cannot start streaming on an OUTPUT device if no buffers have
> +	 * been queued yet.
> +	 */
> +	if (V4L2_TYPE_IS_OUTPUT(q->type)) {
> +		if (list_empty(&q->queued_list)) {
> +			dprintk(1, "streamon: no output buffers queued\n");
> +			ret = -EINVAL;
> +			goto done;
> +		}
> +	}
> +
> +	q->streaming = 1;
> +
> +	/*
> +	 * If any buffers were queued before streamon,
> +	 * we can now pass them to driver for processing.
> +	 */
> +	list_for_each_entry(vb, &q->queued_list, queued_entry)
> +		__enqueue_in_driver(vb);
> +
> +	dprintk(3, "Streamon successful\n");
> +done:
> +	mutex_unlock(&q->vb_lock);
> +	return ret;
> +}
> +EXPORT_SYMBOL_GPL(vb2_streamon);
> +
> +/**
> + * __vb2_queue_cancel() - cancel and stop (pause) streaming
> + *
> + * Removes all queued buffers from driver's queue and all buffers queued by
> + * userspace from videobuf's queue. Returns to state after reqbufs.
> + */
> +static void __vb2_queue_cancel(struct vb2_queue *q)
> +{
> +	unsigned long flags = 0;
> +	int i;
> +
> +	q->streaming = 0;
> +
> +	/*
> +	 * Remove buffers from driver's queue. If a hardware operation
> +	 * is currently underway, drv_lock should be claimed and we will
> +	 * have to wait for it to finish before taking back buffers.
> +	 */
> +	spin_lock_irqsave(q->drv_lock, flags);
> +	for (i = 0; i < q->num_buffers; ++i) {
> +		if (q->bufs[i]->state == VB2_BUF_STATE_ACTIVE)
> +			list_del(&q->bufs[i]->drv_entry);
> +		q->bufs[i]->state = VB2_BUF_STATE_DEQUEUED;
> +	}
> +	spin_unlock_irqrestore(q->drv_lock, flags);

I feel that this spinlock is too simplistic. I think we need a new op:
stop_streaming() or something like that. The driver will stop any streaming
and dequeue any active buffers. And if necessary it has to wait for any DMA
in progress to finish first.

That will also make it possible to remove the drv_lock altogether and make the
driver responsible for proper locking in buf_queue and stop_streaming.

Actually, it might also be an idea to implement a start_streaming op for symmetry.

> +
> +	/*
> +	 * Remove all buffers from videobuf's list...
> +	 */
> +	INIT_LIST_HEAD(&q->queued_list);
> +	/*
> +	 * ...and done list; userspace will not receive any buffers it
> +	 * has not already dequeued before initiating cancel.
> +	 */
> +	INIT_LIST_HEAD(&q->done_list);

Is this correct? Shouldn't put_userptr be called for all queued and done buffers?

> +	wake_up_interruptible_all(&q->done_wq);
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
> +	int ret = 0;
> +
> +	mutex_lock(&q->vb_lock);
> +
> +	if (type != q->type) {
> +		dprintk(1, "streamoff: invalid stream type\n");
> +		ret = -EINVAL;
> +		goto end;
> +	}
> +
> +	if (!q->streaming) {
> +		dprintk(1, "streamoff: not streaming\n");
> +		ret = -EINVAL;
> +		goto end;
> +	}
> +
> +	/*
> +	 * Cancel will pause streaming and remove all buffers from the driver
> +	 * and videobuf, effectively returning control over them to userspace.
> +	 */
> +	__vb2_queue_cancel(q);
> +
> +	dprintk(3, "Streamoff successful\n");
> +end:
> +	mutex_unlock(&q->vb_lock);
> +	return ret;
> +}
> +EXPORT_SYMBOL_GPL(vb2_streamoff);

<snip>

> +struct vb2_mem_ops {
> +       void            *(*alloc)(const struct vb2_alloc_ctx *alloc_ctx,
> +                                       unsigned long size);
> +       void            (*put)(void *buf_priv);
> +       void            *(*get_userptr)(unsigned long vaddr,
> +                                               unsigned long size);
> +       void            (*put_userptr)(void *buf_priv);

This doesn't feel right. 'get_userptr' and 'put_userptr' assumes refcounting, but
does that even make sense in the userptr case? Would 'lock_userptr' and 'unlock_userptr'
or something like that make more sense?

> +
> +       void            *(*vaddr)(void *buf_priv);
> +       unsigned long   (*paddr)(void *buf_priv);
> +       unsigned int    (*num_users)(void *buf_priv);
> +
> +       int             (*mmap)(void *buf_priv, struct vm_area_struct *vma);
> +};


Some general remarks:

1) It is probably useful to add a simply inline function like this:

static inline bool vb2_is_streaming(struct vb2_queue *q)
{
       return q->streaming;
}

2) We need very clear documentation detailing:

   - where the struct vb2_queue has to be stored (it should be associated with the
     video_device struct or the v4l2_device struct if there is only one queue).
   - when to call vb2_queue_init (before registering the device node, I think).
   - when to call vb2_queue_release (after unregistering the device node? Does that
     also work well with USB devices after a disconnect? I think it is OK, but I'm
     not 100% certain.)
   - how does it work if multiple file handles are open? If fh A calls REQBUFS, is fh
     B allowed to call it again? My feeling is that once a fh calls REQBUFS, the
     queue is associated with that fh until REQBUFS with count == 0 is called, or
     until the fh is closed. All the other streaming ioctls should be called from
     that fh. To implement this reqbufs should be passed a struct file (or a v4l2_fh?).
     And for the others we either need this as well or we add a simple inline function
     checking this that drivers can call.

3) Read/write will have its own issues: if the driver supports read/write, then
   some internal checks are needed: once reqbufs was called on a fh, read/write
   should not be allowed (until REQBUFS(0), that is). The same is true vice versa,
   except that once you've started reading or writing the only way to go back to
   streaming I/O is by closing the fh first.

4) If poll is called without a preceding reqbufs or read, then it should initiate
   streaming and mark the queue as being in read (or write) mode. It's the way poll
   is supposed to work for read or write.
  
5) Allowing mixing of read/write and streaming I/O. I am very much opposed to this.
   First of all it will cause skipped frames since read will steal from dqbuf (or
   vice versa, depending on how you look at it). Once you start to read it will also
   be impossible to use REQBUFS(0), and the internal administration will be a nightmare.
   Frankly, I don't think there is a way to implement this in a way that makes sense.
   We should probably investigate those utilities that are supposed to do this.
   I understand that they are xawtv and xdtv.

6) Don't forget to update your email address in these files! :-)

Regards,

	Hans

-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG, part of Cisco
