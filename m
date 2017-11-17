Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pg0-f66.google.com ([74.125.83.66]:39470 "EHLO
        mail-pg0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934270AbdKQHiJ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 17 Nov 2017 02:38:09 -0500
Received: by mail-pg0-f66.google.com with SMTP id 70so1356349pgf.6
        for <linux-media@vger.kernel.org>; Thu, 16 Nov 2017 23:38:09 -0800 (PST)
From: Alexandre Courbot <acourbot@chromium.org>
To: Gustavo Padovan <gustavo@padovan.org>
Cc: <linux-media@vger.kernel.org>, Hans Verkuil <hverkuil@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
        Shuah Khan <shuahkh@osg.samsung.com>,
        Pawel Osciak <pawel@osciak.com>,
        Sakari Ailus <sakari.ailus@iki.fi>,
        Brian Starkey <brian.starkey@arm.com>,
        Thierry Escande <thierry.escande@collabora.com>,
        <linux-kernel@vger.kernel.org>,
        Gustavo Padovan <gustavo.padovan@collabora.com>
Subject: Re: [RFC v5 10/11] [media] vb2: add out-fence support to QBUF
Date: Fri, 17 Nov 2017 16:38:04 +0900
MIME-Version: 1.0
Message-ID: <4c1a4932-87af-4593-94f5-94739cc61084@chromium.org>
In-Reply-To: <20171115171057.17340-11-gustavo@padovan.org>
References: <20171115171057.17340-1-gustavo@padovan.org>
 <20171115171057.17340-11-gustavo@padovan.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thursday, November 16, 2017 2:10:56 AM JST, Gustavo Padovan wrote:
> From: Gustavo Padovan <gustavo.padovan@collabora.com>
>
> If V4L2_BUF_FLAG_OUT_FENCE flag is present on the QBUF call we create
> an out_fence and send its fd to userspace on the fence_fd field as a
> return arg for the QBUF call.
>
> The fence is signaled on buffer_done(), when the job on the buffer is
> finished.
>
> With out-fences we do not allow drivers to requeue buffers through vb2,
> instead we flag an error on the buffer, signals it fence with error and

s/it/its

> return it to userspace.
>
> v6
> 	- get rid of the V4L2_EVENT_OUT_FENCE event. We always keep the
> 	ordering in vb2 for queueing in the driver, so the event is not
> 	necessary anymore and the out_fence_fd is sent back to userspace
> 	on QBUF call return arg
> 	- do not allow requeueing with out-fences, instead mark the buffer
> 	with an error and wake up to userspace.
> 	- send the out_fence_fd back to userspace on the fence_fd field
>
> v5:
> 	- delay fd_install to DQ_EVENT (Hans)
> 	- if queue is fully ordered send OUT_FENCE event right away
> 	(Brian)
> 	- rename 'q->ordered' to 'q->ordered_in_driver'
> 	- merge change to implement OUT_FENCE event here
>
> v4:
> 	- return the out_fence_fd in the BUF_QUEUED event(Hans)
>
> v3:	- add WARN_ON_ONCE(q->ordered) on requeueing (Hans)
> 	- set the OUT_FENCE flag if there is a fence pending (Hans)
> 	- call fd_install() after vb2_core_qbuf() (Hans)
> 	- clean up fence if vb2_core_qbuf() fails (Hans)
> 	- add list to store sync_file and fence for the next queued buffer
>
> v2: check if the queue is ordered.
>
> Signed-off-by: Gustavo Padovan <gustavo.padovan@collabora.com>
> ---
>  drivers/media/v4l2-core/videobuf2-core.c | 42 
> +++++++++++++++++++++++++++++---
>  drivers/media/v4l2-core/videobuf2-v4l2.c | 21 +++++++++++++++-
>  2 files changed, 58 insertions(+), 5 deletions(-)
>
> diff --git a/drivers/media/v4l2-core/videobuf2-core.c 
> b/drivers/media/v4l2-core/videobuf2-core.c
> index 8b4f0e9bcb36..2eb5ffa8e028 100644
> --- a/drivers/media/v4l2-core/videobuf2-core.c
> +++ b/drivers/media/v4l2-core/videobuf2-core.c
> @@ -354,6 +354,7 @@ static int __vb2_queue_alloc(struct 
> vb2_queue *q, enum vb2_memory memory,
>  			vb->planes[plane].length = plane_sizes[plane];
>  			vb->planes[plane].min_length = plane_sizes[plane];
>  		}
> +		vb->out_fence_fd = -1;
>  		q->bufs[vb->index] = vb;
>  
>  		/* Allocate video buffer memory for the MMAP type */
> @@ -934,10 +935,26 @@ void vb2_buffer_done(struct vb2_buffer 
> *vb, enum vb2_buffer_state state)
>  	case VB2_BUF_STATE_QUEUED:
>  		return;
>  	case VB2_BUF_STATE_REQUEUEING:
> -		if (q->start_streaming_called)
> -			__enqueue_in_driver(vb);
> -		return;
> +
> +		if (!vb->out_fence) {
> +			if (q->start_streaming_called)
> +				__enqueue_in_driver(vb);
> +			return;
> +		}
> +
> +		/* Do not allow requeuing with explicit synchronization,
> +		 * report it as an error to userspace */
> +		state = VB2_BUF_STATE_ERROR;
> +
> +		/* fall through */
>  	default:
> +		if (state == VB2_BUF_STATE_ERROR)
> +			dma_fence_set_error(vb->out_fence, -EFAULT);
> +		dma_fence_signal(vb->out_fence);
> +		dma_fence_put(vb->out_fence);
> +		vb->out_fence = NULL;
> +		vb->out_fence_fd = -1;
> +
>  		/* Inform any processes that may be waiting for buffers */
>  		wake_up(&q->done_wq);
>  		break;
> @@ -1325,12 +1342,18 @@ EXPORT_SYMBOL_GPL(vb2_core_prepare_buf);
>  int vb2_setup_out_fence(struct vb2_queue *q, unsigned int index)
>  {
>  	struct vb2_buffer *vb;
> +	u64 context;
>  
>  	vb = q->bufs[index];
>  
>  	vb->out_fence_fd = get_unused_fd_flags(O_CLOEXEC);
>  
> -	vb->out_fence = vb2_fence_alloc(q->out_fence_context);
> +	if (q->ordered_in_driver)
> +		context = q->out_fence_context;
> +	else
> +		context = dma_fence_context_alloc(1);
> +
> +	vb->out_fence = vb2_fence_alloc(context);
>  	if (!vb->out_fence) {
>  		put_unused_fd(vb->out_fence_fd);
>  		return -ENOMEM;
> @@ -1594,6 +1617,9 @@ int vb2_core_qbuf(struct vb2_queue *q, 
> unsigned int index, void *pb,
>  	if (pb)
>  		call_void_bufop(q, fill_user_buffer, vb, pb);
>  
> +	fd_install(vb->out_fence_fd, vb->sync_file->file);

What happens if the buffer does not have an output fence? Shouldn't this be 
protected by a check on whether the buffer has been queued with 
V4L2_BUF_FLAG_OUT_FENCE?

(... or maybe move this to vb2_setup_out_fence() after all, where we know 
for sure an output fence exists).

> +	vb->sync_file = NULL;
> +
>  	dprintk(2, "qbuf of buffer %d succeeded\n", vb->index);
>  	return 0;
>  
> @@ -1860,6 +1886,12 @@ static void __vb2_queue_cancel(struct vb2_queue *q)
>  	}
>  
>  	/*
> +	 * Renew out-fence context.
> +	 */
> +	if (q->ordered_in_driver)
> +		q->out_fence_context = dma_fence_context_alloc(1);
> +
> +	/*
>  	 * Remove all buffers from videobuf's list...
>  	 */
>  	INIT_LIST_HEAD(&q->queued_list);
> @@ -2191,6 +2223,8 @@ int vb2_core_queue_init(struct vb2_queue *q)
>  	spin_lock_init(&q->done_lock);
>  	mutex_init(&q->mmap_lock);
>  	init_waitqueue_head(&q->done_wq);
> +	if (q->ordered_in_driver)
> +		q->out_fence_context = dma_fence_context_alloc(1);
>  
>  	if (q->buf_struct_size == 0)
>  		q->buf_struct_size = sizeof(struct vb2_buffer);
> diff --git a/drivers/media/v4l2-core/videobuf2-v4l2.c 
> b/drivers/media/v4l2-core/videobuf2-v4l2.c
> index 4c09ea007d90..f2e60d2908ae 100644
> --- a/drivers/media/v4l2-core/videobuf2-v4l2.c
> +++ b/drivers/media/v4l2-core/videobuf2-v4l2.c
> @@ -212,7 +212,13 @@ static void __fill_v4l2_buffer(struct 
> vb2_buffer *vb, void *pb)
>  	b->sequence = vbuf->sequence;
>  	b->reserved = 0;
>  
> -	b->fence_fd = -1;
> +	if (vb->out_fence) {
> +		b->flags |= V4L2_BUF_FLAG_OUT_FENCE;
> +		b->fence_fd = vb->out_fence_fd;
> +	} else {
> +		b->fence_fd = -1;
> +	}
> +
>  	if (vb->in_fence)
>  		b->flags |= V4L2_BUF_FLAG_IN_FENCE;
>  	else
> @@ -489,6 +495,10 @@ int vb2_querybuf(struct vb2_queue *q, 
> struct v4l2_buffer *b)
>  	ret = __verify_planes_array(vb, b);
>  	if (!ret)
>  		vb2_core_querybuf(q, b->index, b);
> +
> +	/* Do not return the out-fence fd on querybuf */
> +	if (vb->out_fence)
> +		b->fence_fd = -1;
>  	return ret;
>  }
>  EXPORT_SYMBOL(vb2_querybuf);
> @@ -593,6 +603,15 @@ int vb2_qbuf(struct vb2_queue *q, struct 
> v4l2_buffer *b)
>  		}
>  	}
>  
> +	if (b->flags & V4L2_BUF_FLAG_OUT_FENCE) {
> +		ret = vb2_setup_out_fence(q, b->index);
> +		if (ret) {
> +			dprintk(1, "failed to set up out-fence\n");
> +			dma_fence_put(fence);
> +			return ret;
> +		}
> +	}
> +
>  	return vb2_core_qbuf(q, b->index, b, fence);
>  }
>  EXPORT_SYMBOL_GPL(vb2_qbuf);
