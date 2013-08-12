Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.w1.samsung.com ([210.118.77.13]:44391 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755679Ab3HLIkz (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 12 Aug 2013 04:40:55 -0400
Received: from eucpsbgm2.samsung.com (unknown [203.254.199.245])
 by mailout3.w1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MRE00L13TG6QU80@mailout3.w1.samsung.com> for
 linux-media@vger.kernel.org; Mon, 12 Aug 2013 09:40:54 +0100 (BST)
Message-id: <52089F94.3050405@samsung.com>
Date: Mon, 12 Aug 2013 10:40:52 +0200
From: Marek Szyprowski <m.szyprowski@samsung.com>
MIME-version: 1.0
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: linux-media@vger.kernel.org, Pawel Osciak <pawel@osciak.com>
Subject: Re: [PATCH 2/2] media: vb2: Share code between vb2_prepare_buf and
 vb2_qbuf
References: <1376050286-8201-1-git-send-email-laurent.pinchart@ideasonboard.com>
 <1376050286-8201-3-git-send-email-laurent.pinchart@ideasonboard.com>
In-reply-to: <1376050286-8201-3-git-send-email-laurent.pinchart@ideasonboard.com>
Content-type: text/plain; charset=UTF-8; format=flowed
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

On 8/9/2013 2:11 PM, Laurent Pinchart wrote:
> The two operations are very similar, refactor most of the code in a
> helper function.
>
> Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

Acked-by: Marek Szyprowski <m.szyprowski@samsung.com>

> ---
>   drivers/media/v4l2-core/videobuf2-core.c | 202 ++++++++++++-------------------
>   1 file changed, 79 insertions(+), 123 deletions(-)
>
> diff --git a/drivers/media/v4l2-core/videobuf2-core.c b/drivers/media/v4l2-core/videobuf2-core.c
> index 7c2a8ce..c9f8c3f 100644
> --- a/drivers/media/v4l2-core/videobuf2-core.c
> +++ b/drivers/media/v4l2-core/videobuf2-core.c
> @@ -1231,42 +1231,31 @@ static int __buf_prepare(struct vb2_buffer *vb, const struct v4l2_buffer *b)
>   	return ret;
>   }
>   
> -/**
> - * vb2_prepare_buf() - Pass ownership of a buffer from userspace to the kernel
> - * @q:		videobuf2 queue
> - * @b:		buffer structure passed from userspace to vidioc_prepare_buf
> - *		handler in driver
> - *
> - * Should be called from vidioc_prepare_buf ioctl handler of a driver.
> - * This function:
> - * 1) verifies the passed buffer,
> - * 2) calls buf_prepare callback in the driver (if provided), in which
> - *    driver-specific buffer initialization can be performed,
> - *
> - * The return values from this function are intended to be directly returned
> - * from vidioc_prepare_buf handler in driver.
> - */
> -int vb2_prepare_buf(struct vb2_queue *q, struct v4l2_buffer *b)
> +static int vb2_queue_or_prepare_buf(struct vb2_queue *q, struct v4l2_buffer *b,
> +				    const char *opname,
> +				    int (*handler)(struct vb2_queue *,
> +						   struct v4l2_buffer *,
> +						   struct vb2_buffer *))
>   {
>   	struct rw_semaphore *mmap_sem = NULL;
>   	struct vb2_buffer *vb;
>   	int ret;
>   
>   	/*
> -	 * In case of user pointer buffers vb2 allocator needs to get direct
> -	 * access to userspace pages. This requires getting read access on
> -	 * mmap semaphore in the current process structure. The same
> -	 * semaphore is taken before calling mmap operation, while both mmap
> -	 * and prepare_buf are called by the driver or v4l2 core with driver's
> -	 * lock held. To avoid a AB-BA deadlock (mmap_sem then driver's lock in
> -	 * mmap and driver's lock then mmap_sem in prepare_buf) the videobuf2
> -	 * core release driver's lock, takes mmap_sem and then takes again
> -	 * driver's lock.
> +	 * In case of user pointer buffers vb2 allocators need to get direct
> +	 * access to userspace pages. This requires getting the mmap semaphore
> +	 * for read access in the current process structure. The same semaphore
> +	 * is taken before calling mmap operation, while both qbuf/prepare_buf
> +	 * and mmap are called by the driver or v4l2 core with the driver's lock
> +	 * held. To avoid an AB-BA deadlock (mmap_sem then driver's lock in mmap
> +	 * and driver's lock then mmap_sem in qbuf/prepare_buf) the videobuf2
> +	 * core releases the driver's lock, takes mmap_sem and then takes the
> +	 * driver's lock again.
>   	 *
> -	 * To avoid race with other vb2 calls, which might be called after
> -	 * releasing driver's lock, this operation is performed at the
> -	 * beggining of prepare_buf processing. This way the queue status is
> -	 * consistent after getting driver's lock back.
> +	 * To avoid racing with other vb2 calls, which might be called after
> +	 * releasing the driver's lock, this operation is performed at the
> +	 * beginning of qbuf/prepare_buf processing. This way the queue status
> +	 * is consistent after getting the driver's lock back.
>   	 */
>   	if (q->memory == V4L2_MEMORY_USERPTR) {
>   		mmap_sem = &current->mm->mmap_sem;
> @@ -1276,19 +1265,19 @@ int vb2_prepare_buf(struct vb2_queue *q, struct v4l2_buffer *b)
>   	}
>   
>   	if (q->fileio) {
> -		dprintk(1, "%s(): file io in progress\n", __func__);
> +		dprintk(1, "%s(): file io in progress\n", opname);
>   		ret = -EBUSY;
>   		goto unlock;
>   	}
>   
>   	if (b->type != q->type) {
> -		dprintk(1, "%s(): invalid buffer type\n", __func__);
> +		dprintk(1, "%s(): invalid buffer type\n", opname);
>   		ret = -EINVAL;
>   		goto unlock;
>   	}
>   
>   	if (b->index >= q->num_buffers) {
> -		dprintk(1, "%s(): buffer index out of range\n", __func__);
> +		dprintk(1, "%s(): buffer index out of range\n", opname);
>   		ret = -EINVAL;
>   		goto unlock;
>   	}
> @@ -1296,131 +1285,83 @@ int vb2_prepare_buf(struct vb2_queue *q, struct v4l2_buffer *b)
>   	vb = q->bufs[b->index];
>   	if (NULL == vb) {
>   		/* Should never happen */
> -		dprintk(1, "%s(): buffer is NULL\n", __func__);
> +		dprintk(1, "%s(): buffer is NULL\n", opname);
>   		ret = -EINVAL;
>   		goto unlock;
>   	}
>   
>   	if (b->memory != q->memory) {
> -		dprintk(1, "%s(): invalid memory type\n", __func__);
> +		dprintk(1, "%s(): invalid memory type\n", opname);
>   		ret = -EINVAL;
>   		goto unlock;
>   	}
>   
> -	if (vb->state != VB2_BUF_STATE_DEQUEUED) {
> -		dprintk(1, "%s(): invalid buffer state %d\n", __func__, vb->state);
> -		ret = -EINVAL;
> -		goto unlock;
> -	}
>   	ret = __verify_planes_array(vb, b);
> -	if (ret < 0)
> +	if (ret)
>   		goto unlock;
>   
> -	ret = __buf_prepare(vb, b);
> -	if (ret < 0)
> +	ret = handler(q, b, vb);
> +	if (ret)
>   		goto unlock;
>   
> +	/* Fill buffer information for the userspace */
>   	__fill_v4l2_buffer(vb, b);
>   
> +	dprintk(1, "%s() of buffer %d succeeded\n", opname, vb->v4l2_buf.index);
>   unlock:
>   	if (mmap_sem)
>   		up_read(mmap_sem);
>   	return ret;
>   }
> -EXPORT_SYMBOL_GPL(vb2_prepare_buf);
> +
> +static int __vb2_prepare_buf(struct vb2_queue *q, struct v4l2_buffer *b,
> +			     struct vb2_buffer *vb)
> +{
> +	if (vb->state != VB2_BUF_STATE_DEQUEUED) {
> +		dprintk(1, "%s(): invalid buffer state %d\n", __func__,
> +			vb->state);
> +		return -EINVAL;
> +	}
> +
> +	return __buf_prepare(vb, b);
> +}
>   
>   /**
> - * vb2_qbuf() - Queue a buffer from userspace
> + * vb2_prepare_buf() - Pass ownership of a buffer from userspace to the kernel
>    * @q:		videobuf2 queue
> - * @b:		buffer structure passed from userspace to vidioc_qbuf handler
> - *		in driver
> + * @b:		buffer structure passed from userspace to vidioc_prepare_buf
> + *		handler in driver
>    *
> - * Should be called from vidioc_qbuf ioctl handler of a driver.
> + * Should be called from vidioc_prepare_buf ioctl handler of a driver.
>    * This function:
>    * 1) verifies the passed buffer,
> - * 2) if necessary, calls buf_prepare callback in the driver (if provided), in
> - *    which driver-specific buffer initialization can be performed,
> - * 3) if streaming is on, queues the buffer in driver by the means of buf_queue
> - *    callback for processing.
> + * 2) calls buf_prepare callback in the driver (if provided), in which
> + *    driver-specific buffer initialization can be performed,
>    *
>    * The return values from this function are intended to be directly returned
> - * from vidioc_qbuf handler in driver.
> + * from vidioc_prepare_buf handler in driver.
>    */
> -int vb2_qbuf(struct vb2_queue *q, struct v4l2_buffer *b)
> +int vb2_prepare_buf(struct vb2_queue *q, struct v4l2_buffer *b)
>   {
> -	struct rw_semaphore *mmap_sem = NULL;
> -	struct vb2_buffer *vb;
> -	int ret = 0;
> -
> -	/*
> -	 * In case of user pointer buffers vb2 allocator needs to get direct
> -	 * access to userspace pages. This requires getting read access on
> -	 * mmap semaphore in the current process structure. The same
> -	 * semaphore is taken before calling mmap operation, while both mmap
> -	 * and qbuf are called by the driver or v4l2 core with driver's lock
> -	 * held. To avoid a AB-BA deadlock (mmap_sem then driver's lock in
> -	 * mmap and driver's lock then mmap_sem in qbuf) the videobuf2 core
> -	 * release driver's lock, takes mmap_sem and then takes again driver's
> -	 * lock.
> -	 *
> -	 * To avoid race with other vb2 calls, which might be called after
> -	 * releasing driver's lock, this operation is performed at the
> -	 * beggining of qbuf processing. This way the queue status is
> -	 * consistent after getting driver's lock back.
> -	 */
> -	if (q->memory == V4L2_MEMORY_USERPTR) {
> -		mmap_sem = &current->mm->mmap_sem;
> -		call_qop(q, wait_prepare, q);
> -		down_read(mmap_sem);
> -		call_qop(q, wait_finish, q);
> -	}
> -
> -	if (q->fileio) {
> -		dprintk(1, "qbuf: file io in progress\n");
> -		ret = -EBUSY;
> -		goto unlock;
> -	}
> -
> -	if (b->type != q->type) {
> -		dprintk(1, "qbuf: invalid buffer type\n");
> -		ret = -EINVAL;
> -		goto unlock;
> -	}
> -
> -	if (b->index >= q->num_buffers) {
> -		dprintk(1, "qbuf: buffer index out of range\n");
> -		ret = -EINVAL;
> -		goto unlock;
> -	}
> -
> -	vb = q->bufs[b->index];
> -	if (NULL == vb) {
> -		/* Should never happen */
> -		dprintk(1, "qbuf: buffer is NULL\n");
> -		ret = -EINVAL;
> -		goto unlock;
> -	}
> +	return vb2_queue_or_prepare_buf(q, b, "prepare_buf", __vb2_prepare_buf);
> +}
> +EXPORT_SYMBOL_GPL(vb2_prepare_buf);
>   
> -	if (b->memory != q->memory) {
> -		dprintk(1, "qbuf: invalid memory type\n");
> -		ret = -EINVAL;
> -		goto unlock;
> -	}
> -	ret = __verify_planes_array(vb, b);
> -	if (ret)
> -		goto unlock;
> +static int __vb2_qbuf(struct vb2_queue *q, struct v4l2_buffer *b,
> +		      struct vb2_buffer *vb)
> +{
> +	int ret;
>   
>   	switch (vb->state) {
>   	case VB2_BUF_STATE_DEQUEUED:
>   		ret = __buf_prepare(vb, b);
>   		if (ret)
> -			goto unlock;
> +			return ret;
>   	case VB2_BUF_STATE_PREPARED:
>   		break;
>   	default:
>   		dprintk(1, "qbuf: buffer already in use\n");
> -		ret = -EINVAL;
> -		goto unlock;
> +		return -EINVAL;
>   	}
>   
>   	/*
> @@ -1437,14 +1378,29 @@ int vb2_qbuf(struct vb2_queue *q, struct v4l2_buffer *b)
>   	if (q->streaming)
>   		__enqueue_in_driver(vb);
>   
> -	/* Fill buffer information for the userspace */
> -	__fill_v4l2_buffer(vb, b);
> +	return 0;
> +}
>   
> -	dprintk(1, "qbuf of buffer %d succeeded\n", vb->v4l2_buf.index);
> -unlock:
> -	if (mmap_sem)
> -		up_read(mmap_sem);
> -	return ret;
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
> +	return vb2_queue_or_prepare_buf(q, b, "qbuf", __vb2_qbuf);
>   }
>   EXPORT_SYMBOL_GPL(vb2_qbuf);
>   

Best regards
-- 
Marek Szyprowski
Samsung R&D Institute Poland


