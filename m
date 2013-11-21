Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:39051 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753177Ab3KUTEB (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 21 Nov 2013 14:04:01 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org, m.szyprowski@samsung.com,
	pawel@osciak.com, awalls@md.metrocast.net,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [RFC PATCH 1/8] vb2: push the mmap semaphore down to __buf_prepare()
Date: Thu, 21 Nov 2013 20:04:45 +0100
Message-ID: <6539252.6X3kkSkupS@avalon>
In-Reply-To: <1385047326-23099-2-git-send-email-hverkuil@xs4all.nl>
References: <1385047326-23099-1-git-send-email-hverkuil@xs4all.nl> <1385047326-23099-2-git-send-email-hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

Thank you for the patch.

On Thursday 21 November 2013 16:21:59 Hans Verkuil wrote:
> From: Hans Verkuil <hans.verkuil@cisco.com>
> 
> Rather than taking the mmap semaphore at a relatively high-level function,
> push it down to the place where it is really needed.
> 
> It was placed in vb2_queue_or_prepare_buf() to prevent racing with other
> vb2 calls, however, I see no way that any race can happen.

What about the following scenario ? Both QBUF calls are performed on the same 
buffer.

	CPU 0							CPU 1
	-------------------------------------------------------------------------
	QBUF								QBUF
		locks the queue mutex				waits for the queue mutex
	vb2_qbuf
	vb2_queue_or_prepare_buf
	__vb2_qbuf
		checks vb->state, calls
	__buf_prepare
	call_qop(q, wait_prepare, q);
		unlocks the queue mutex
										locks the queue mutex
									vb2_qbuf
									vb2_queue_or_prepare_buf
									__vb2_qbuf
										checks vb->state, calls
									__buf_prepare
									call_qop(q, wait_prepare, q);
										unlocks the queue mutex

									queue the buffer, set buffer
									 state to queue

	queue the buffer, set buffer
	 state to queue


We would thus end up queueing the buffer twice. The vb->state check needs to 
be performed after the brief release of the queue mutex.

> Moving it down offers opportunities to simplify the code.
> 
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> ---
>  drivers/media/v4l2-core/videobuf2-core.c | 74 +++++++++++-----------------
>  1 file changed, 30 insertions(+), 44 deletions(-)
> 
> diff --git a/drivers/media/v4l2-core/videobuf2-core.c
> b/drivers/media/v4l2-core/videobuf2-core.c index 91412d4..d2b2efb 100644
> --- a/drivers/media/v4l2-core/videobuf2-core.c
> +++ b/drivers/media/v4l2-core/videobuf2-core.c
> @@ -1205,6 +1205,7 @@ static void __enqueue_in_driver(struct vb2_buffer *vb)
> static int __buf_prepare(struct vb2_buffer *vb, const struct v4l2_buffer
> *b) {
>  	struct vb2_queue *q = vb->vb2_queue;
> +	struct rw_semaphore *mmap_sem;
>  	int ret;
> 
>  	ret = __verify_length(vb, b);
> @@ -1219,7 +1220,25 @@ static int __buf_prepare(struct vb2_buffer *vb, const
> struct v4l2_buffer *b) ret = __qbuf_mmap(vb, b);
>  		break;
>  	case V4L2_MEMORY_USERPTR:
> +		/*
> +		 * In case of user pointer buffers vb2 allocators need to get direct
> +		 * access to userspace pages. This requires getting the mmap 
semaphore
> +		 * for read access in the current process structure. The same 
semaphore
> +		 * is taken before calling mmap operation, while both 
qbuf/prepare_buf
> +		 * and mmap are called by the driver or v4l2 core with the driver's 
lock
> +		 * held. To avoid an AB-BA deadlock (mmap_sem then driver's lock in 
mmap
> +		 * and driver's lock then mmap_sem in qbuf/prepare_buf) the videobuf2
> +		 * core releases the driver's lock, takes mmap_sem and then takes the
> +		 * driver's lock again.
> +		 */
> +		mmap_sem = &current->mm->mmap_sem;
> +		call_qop(q, wait_prepare, q);
> +		down_read(mmap_sem);
> +		call_qop(q, wait_finish, q);
> +
>  		ret = __qbuf_userptr(vb, b);
> +
> +		up_read(mmap_sem);
>  		break;
>  	case V4L2_MEMORY_DMABUF:
>  		ret = __qbuf_dmabuf(vb, b);
> @@ -1245,80 +1264,47 @@ static int vb2_queue_or_prepare_buf(struct vb2_queue
> *q, struct v4l2_buffer *b, struct v4l2_buffer *,
>  						   struct vb2_buffer *))
>  {
> -	struct rw_semaphore *mmap_sem = NULL;
>  	struct vb2_buffer *vb;
>  	int ret;
> 
> -	/*
> -	 * In case of user pointer buffers vb2 allocators need to get direct
> -	 * access to userspace pages. This requires getting the mmap semaphore
> -	 * for read access in the current process structure. The same semaphore
> -	 * is taken before calling mmap operation, while both qbuf/prepare_buf
> -	 * and mmap are called by the driver or v4l2 core with the driver's lock
> -	 * held. To avoid an AB-BA deadlock (mmap_sem then driver's lock in mmap
> -	 * and driver's lock then mmap_sem in qbuf/prepare_buf) the videobuf2
> -	 * core releases the driver's lock, takes mmap_sem and then takes the
> -	 * driver's lock again.
> -	 *
> -	 * To avoid racing with other vb2 calls, which might be called after
> -	 * releasing the driver's lock, this operation is performed at the
> -	 * beginning of qbuf/prepare_buf processing. This way the queue status
> -	 * is consistent after getting the driver's lock back.
> -	 */
> -	if (q->memory == V4L2_MEMORY_USERPTR) {
> -		mmap_sem = &current->mm->mmap_sem;
> -		call_qop(q, wait_prepare, q);
> -		down_read(mmap_sem);
> -		call_qop(q, wait_finish, q);
> -	}
> -
>  	if (q->fileio) {
>  		dprintk(1, "%s(): file io in progress\n", opname);
> -		ret = -EBUSY;
> -		goto unlock;
> +		return -EBUSY;
>  	}
> 
>  	if (b->type != q->type) {
>  		dprintk(1, "%s(): invalid buffer type\n", opname);
> -		ret = -EINVAL;
> -		goto unlock;
> +		return -EINVAL;
>  	}
> 
>  	if (b->index >= q->num_buffers) {
>  		dprintk(1, "%s(): buffer index out of range\n", opname);
> -		ret = -EINVAL;
> -		goto unlock;
> +		return -EINVAL;
>  	}
> 
>  	vb = q->bufs[b->index];
>  	if (NULL == vb) {
>  		/* Should never happen */
>  		dprintk(1, "%s(): buffer is NULL\n", opname);
> -		ret = -EINVAL;
> -		goto unlock;
> +		return -EINVAL;
>  	}
> 
>  	if (b->memory != q->memory) {
>  		dprintk(1, "%s(): invalid memory type\n", opname);
> -		ret = -EINVAL;
> -		goto unlock;
> +		return -EINVAL;
>  	}
> 
>  	ret = __verify_planes_array(vb, b);
>  	if (ret)
> -		goto unlock;
> +		return ret;
> 
>  	ret = handler(q, b, vb);
> -	if (ret)
> -		goto unlock;
> -
> -	/* Fill buffer information for the userspace */
> -	__fill_v4l2_buffer(vb, b);
> +	if (!ret) {
> +		/* Fill buffer information for the userspace */
> +		__fill_v4l2_buffer(vb, b);
> 
> -	dprintk(1, "%s() of buffer %d succeeded\n", opname, vb->v4l2_buf.index);
> -unlock:
> -	if (mmap_sem)
> -		up_read(mmap_sem);
> +		dprintk(1, "%s() of buffer %d succeeded\n", opname, vb-
>v4l2_buf.index);
> +	}
>  	return ret;
>  }
-- 
Regards,

Laurent Pinchart

