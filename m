Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud9.xs4all.net ([194.109.24.26]:49076 "EHLO
        lb2-smtp-cloud9.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S933736AbeALOF6 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 12 Jan 2018 09:05:58 -0500
Subject: Re: [PATCH v7 5/6] [media] vb2: add out-fence support to QBUF
To: Gustavo Padovan <gustavo@padovan.org>, linux-media@vger.kernel.org
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
        Shuah Khan <shuahkh@osg.samsung.com>,
        Pawel Osciak <pawel@osciak.com>,
        Alexandre Courbot <acourbot@chromium.org>,
        Sakari Ailus <sakari.ailus@iki.fi>,
        Brian Starkey <brian.starkey@arm.com>,
        Thierry Escande <thierry.escande@collabora.com>,
        linux-kernel@vger.kernel.org,
        Gustavo Padovan <gustavo.padovan@collabora.com>
References: <20180110160732.7722-1-gustavo@padovan.org>
 <20180110160732.7722-6-gustavo@padovan.org>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <f86d9149-59b4-b5a8-d6e3-6a7e220a00aa@xs4all.nl>
Date: Fri, 12 Jan 2018 15:05:53 +0100
MIME-Version: 1.0
In-Reply-To: <20180110160732.7722-6-gustavo@padovan.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 01/10/18 17:07, Gustavo Padovan wrote:
> From: Gustavo Padovan <gustavo.padovan@collabora.com>
> 
> If V4L2_BUF_FLAG_OUT_FENCE flag is present on the QBUF call we create
> an out_fence and send its fd to userspace on the fence_fd field as a
> return arg for the QBUF call.
> 
> The fence is signaled on buffer_done(), when the job on the buffer is
> finished.
> 
> v8:
> 	- return 0 as fence_fd if OUT_FENCE flag not used (Mauro)
> 	- fix crash when checking not using fences in vb2_buffer_done()
> 
> v7:
> 	- merge patch that add the infrastructure to out-fences into
> 	this one (Alex Courbot)
> 	- Do not install the fd if there is no fence. (Alex Courbot)
> 	- do not report error on requeueing, just WARN_ON_ONCE() (Hans)
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
>  drivers/media/common/videobuf/videobuf2-core.c | 101 +++++++++++++++++++++++--
>  drivers/media/common/videobuf/videobuf2-v4l2.c |  28 ++++++-
>  include/media/videobuf2-core.h                 |  22 ++++++
>  3 files changed, 140 insertions(+), 11 deletions(-)
> 
> diff --git a/drivers/media/common/videobuf/videobuf2-core.c b/drivers/media/common/videobuf/videobuf2-core.c
> index 777e3a2bc746..1f30d9efb7c8 100644
> --- a/drivers/media/common/videobuf/videobuf2-core.c
> +++ b/drivers/media/common/videobuf/videobuf2-core.c
> @@ -25,6 +25,7 @@
>  #include <linux/sched.h>
>  #include <linux/freezer.h>
>  #include <linux/kthread.h>
> +#include <linux/sync_file.h>
>  
>  #include <media/videobuf2-core.h>
>  #include <media/v4l2-mc.h>
> @@ -357,6 +358,7 @@ static int __vb2_queue_alloc(struct vb2_queue *q, enum vb2_memory memory,
>  			vb->planes[plane].length = plane_sizes[plane];
>  			vb->planes[plane].min_length = plane_sizes[plane];
>  		}
> +		vb->out_fence_fd = -1;
>  		q->bufs[vb->index] = vb;
>  
>  		/* Allocate video buffer memory for the MMAP type */
> @@ -939,10 +941,22 @@ void vb2_buffer_done(struct vb2_buffer *vb, enum vb2_buffer_state state)
>  	case VB2_BUF_STATE_QUEUED:
>  		break;
>  	case VB2_BUF_STATE_REQUEUEING:
> +		/* Requeuing with explicit synchronization, spit warning */
> +		WARN_ON_ONCE(vb->out_fence);
> +
>  		if (q->start_streaming_called)
>  			__enqueue_in_driver(vb);
> -		return;
> +		break;
>  	default:
> +		if (vb->out_fence) {
> +			if (state == VB2_BUF_STATE_ERROR)
> +				dma_fence_set_error(vb->out_fence, -EFAULT);
> +			dma_fence_signal(vb->out_fence);
> +			dma_fence_put(vb->out_fence);
> +			vb->out_fence = NULL;
> +			vb->out_fence_fd = -1;
> +		}
> +
>  		/* Inform any processes that may be waiting for buffers */
>  		wake_up(&q->done_wq);
>  		break;
> @@ -1341,6 +1355,65 @@ int vb2_core_prepare_buf(struct vb2_queue *q, unsigned int index, void *pb)
>  }
>  EXPORT_SYMBOL_GPL(vb2_core_prepare_buf);
>  
> +static inline const char *vb2_fence_get_driver_name(struct dma_fence *fence)
> +{
> +	return "vb2_fence";
> +}
> +
> +static inline const char *vb2_fence_get_timeline_name(struct dma_fence *fence)
> +{
> +	return "vb2_fence_timeline";
> +}
> +
> +static inline bool vb2_fence_enable_signaling(struct dma_fence *fence)
> +{
> +	return true;
> +}
> +
> +static const struct dma_fence_ops vb2_fence_ops = {
> +	.get_driver_name = vb2_fence_get_driver_name,
> +	.get_timeline_name = vb2_fence_get_timeline_name,
> +	.enable_signaling = vb2_fence_enable_signaling,
> +	.wait = dma_fence_default_wait,
> +};
> +
> +int vb2_setup_out_fence(struct vb2_queue *q, unsigned int index)
> +{
> +	struct vb2_buffer *vb;
> +	u64 context;
> +
> +	vb = q->bufs[index];
> +
> +	vb->out_fence_fd = get_unused_fd_flags(O_CLOEXEC);
> +
> +	if (call_qop(q, is_unordered, q))
> +		context = dma_fence_context_alloc(1);
> +	else
> +		context = q->out_fence_context;
> +
> +	vb->out_fence = kzalloc(sizeof(*vb->out_fence), GFP_KERNEL);
> +	if (!vb->out_fence)
> +		return -ENOMEM;
> +
> +	dma_fence_init(vb->out_fence, &vb2_fence_ops, &q->out_fence_lock,
> +		       context, 1);
> +	if (!vb->out_fence) {
> +		put_unused_fd(vb->out_fence_fd);
> +		return -ENOMEM;
> +	}
> +
> +	vb->sync_file = sync_file_create(vb->out_fence);
> +	if (!vb->sync_file) {
> +		put_unused_fd(vb->out_fence_fd);
> +		dma_fence_put(vb->out_fence);
> +		vb->out_fence = NULL;
> +		return -ENOMEM;
> +	}
> +
> +	return 0;
> +}
> +EXPORT_SYMBOL_GPL(vb2_setup_out_fence);
> +
>  /*
>   * vb2_start_streaming() - Attempt to start streaming.
>   * @q:		videobuf2 queue
> @@ -1489,18 +1562,16 @@ int vb2_core_qbuf(struct vb2_queue *q, unsigned int index, void *pb,

This function is now very confusing. The last argument is a fence, but it is set
for both in and out fences, and the previous patch sets vb->in_fence to fence.
Even though the fence passed in this case is an out fence.

I think it would be much easier to understand if you add both an in_fence and
out_fence argument to this function.

Is it possible to have both and in and out fence for the same buffer? I think
it is and in that case you really need two fences.

>  	if (vb->in_fence) {
>  		ret = dma_fence_add_callback(vb->in_fence, &vb->fence_cb,
>  					     vb2_qbuf_fence_cb);
> -		if (ret == -EINVAL) {
> +		/* is the fence signaled? */
> +		if (ret == -ENOENT) {
> +			dma_fence_put(vb->in_fence);
> +			vb->in_fence = NULL;
> +		} else if (ret) {
>  			spin_unlock_irqrestore(&vb->fence_cb_lock, flags);
>  			goto err;
> -		} else if (!ret) {
> -			goto fill;
>  		}
> -
> -		dma_fence_put(vb->in_fence);
> -		vb->in_fence = NULL;
>  	}
>  
> -fill:
>  	/*
>  	 * If already streaming and there is no fence to wait on
>  	 * give the buffer to driver for processing.
> @@ -1535,6 +1606,11 @@ int vb2_core_qbuf(struct vb2_queue *q, unsigned int index, void *pb,
>  	if (pb)
>  		call_void_bufop(q, fill_user_buffer, vb, pb);
>  
> +	if (vb->out_fence) {
> +		fd_install(vb->out_fence_fd, vb->sync_file->file);
> +		vb->sync_file = NULL;
> +	}
> +
>  	dprintk(2, "qbuf of buffer %d succeeded\n", vb->index);
>  	return 0;
>  
> @@ -1802,6 +1878,12 @@ static void __vb2_queue_cancel(struct vb2_queue *q)
>  		spin_unlock_irqrestore(&vb->fence_cb_lock, flags);
>  	}
>  
> +	/*
> +	 * Renew out-fence context.
> +	 */
> +	if (!call_qop(q, is_unordered, q))
> +		q->out_fence_context = dma_fence_context_alloc(1);

I don't think this is the right place. If a driver implements is_unordered, then
the return value depends on the format. And that isn't locked in until buffers
are allocated (i.e. reqbufs or create_bufs is called). So that's the moment that
you can set this up.

BTW: I noticed is_unordered() returned an int instead of a bool. I think a bool
makes more sense.

> +
>  	/*
>  	 * Remove all buffers from videobuf's list...
>  	 */
> @@ -2134,6 +2216,9 @@ int vb2_core_queue_init(struct vb2_queue *q)
>  	spin_lock_init(&q->done_lock);
>  	mutex_init(&q->mmap_lock);
>  	init_waitqueue_head(&q->done_wq);
> +	if (!call_qop(q, is_unordered, q))
> +		q->out_fence_context = dma_fence_context_alloc(1);

Same here: at this moment you do not know if the queue is ordered or
unordered.

> +	spin_lock_init(&q->out_fence_lock);
>  
>  	q->memory = VB2_MEMORY_UNKNOWN;
>  
> diff --git a/drivers/media/common/videobuf/videobuf2-v4l2.c b/drivers/media/common/videobuf/videobuf2-v4l2.c
> index 0a41e3bb7733..f1291c25323f 100644
> --- a/drivers/media/common/videobuf/videobuf2-v4l2.c
> +++ b/drivers/media/common/videobuf/videobuf2-v4l2.c
> @@ -179,12 +179,16 @@ static int vb2_queue_or_prepare_buf(struct vb2_queue *q, struct v4l2_buffer *b,
>  		return -EINVAL;
>  	}
>  
> -	if ((b->fence_fd != 0 && b->fence_fd != -1) &&
> -	    !(b->flags & V4L2_BUF_FLAG_IN_FENCE)) {
> +	if (b->fence_fd > 0 && !(b->flags & V4L2_BUF_FLAG_IN_FENCE)) {
>  		dprintk(1, "%s: fence_fd set without IN_FENCE flag\n", opname);
>  		return -EINVAL;
>  	}
>  
> +	if (b->fence_fd == -1 && (b->flags & V4L2_BUF_FLAG_IN_FENCE)) {

Shouldn't this be b->fence_fd <= 0?

> +		dprintk(1, "%s: IN_FENCE flag set but no fence_fd\n", opname);
> +		return -EINVAL;
> +	}
> +
>  	return __verify_planes_array(q->bufs[b->index], b);
>  }
>  
> @@ -212,7 +216,12 @@ static void __fill_v4l2_buffer(struct vb2_buffer *vb, void *pb)
>  	b->sequence = vbuf->sequence;
>  	b->reserved = 0;
>  
> -	b->fence_fd = 0;
> +	if (b->flags & V4L2_BUF_FLAG_OUT_FENCE) {
> +		b->fence_fd = vb->out_fence_fd;
> +	} else {
> +		b->fence_fd = 0;
> +	}
> +
>  	if (vb->in_fence)
>  		b->flags |= V4L2_BUF_FLAG_IN_FENCE;
>  	else
> @@ -491,6 +500,10 @@ int vb2_querybuf(struct vb2_queue *q, struct v4l2_buffer *b)
>  	ret = __verify_planes_array(vb, b);
>  	if (!ret)
>  		vb2_core_querybuf(q, b->index, b);
> +
> +	/* Do not return the out-fence fd on querybuf */
> +	if (vb->out_fence)
> +		b->fence_fd = -1;

This does not hurt. We also return dmabuf fds in the same way in querybuf.

I would drop this.

>  	return ret;
>  }
>  EXPORT_SYMBOL(vb2_querybuf);
> @@ -595,6 +608,15 @@ int vb2_qbuf(struct vb2_queue *q, struct v4l2_buffer *b)
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

Hmm. So if vb2_core_qbuf returns an error, we still have created the out fence?
As mentioned above, it is very confusing that the same vb2_core_qbuf 'fence'
argument is used for both in and out fences.

>  }
>  EXPORT_SYMBOL_GPL(vb2_qbuf);
> diff --git a/include/media/videobuf2-core.h b/include/media/videobuf2-core.h
> index 0a2b1ac12dd0..260435dfc301 100644
> --- a/include/media/videobuf2-core.h
> +++ b/include/media/videobuf2-core.h
> @@ -260,6 +260,10 @@ struct vb2_buffer {
>  	 *			using the buffer (queueing to the driver)
>  	 * fence_cb:		fence callback information
>  	 * fence_cb_lock:	protect callback signal/remove
> +	 * out_fence_fd:	the out_fence_fd to be shared with userspace.
> +	 * out_fence:		the out-fence associated with the buffer once
> +	 *			it is queued to the driver.
> +	 * sync_file:		the sync file to wrap the out fence
>  	 */
>  	enum vb2_buffer_state	state;
>  
> @@ -271,6 +275,10 @@ struct vb2_buffer {
>  	struct dma_fence_cb	fence_cb;
>  	spinlock_t              fence_cb_lock;
>  
> +	int			out_fence_fd;
> +	struct dma_fence	*out_fence;
> +	struct sync_file	*sync_file;
> +
>  #ifdef CONFIG_VIDEO_ADV_DEBUG
>  	/*
>  	 * Counters for how often these buffer-related ops are
> @@ -514,6 +522,7 @@ struct vb2_buf_ops {
>   * @last_buffer_dequeued: used in poll() and DQBUF to immediately return if the
>   *		last decoded buffer was already dequeued. Set for capture queues
>   *		when a buffer with the %V4L2_BUF_FLAG_LAST is dequeued.
> + * @out_fence_context: the fence context for the out fences
>   * @fileio:	file io emulator internal data, used only if emulator is active
>   * @threadio:	thread io internal data, used only if thread is active
>   */
> @@ -567,6 +576,9 @@ struct vb2_queue {
>  	unsigned int			copy_timestamp:1;
>  	unsigned int			last_buffer_dequeued:1;
>  
> +	u64				out_fence_context;
> +	spinlock_t			out_fence_lock;
> +
>  	struct vb2_fileio_data		*fileio;
>  	struct vb2_threadio_data	*threadio;
>  
> @@ -753,6 +765,16 @@ int vb2_core_create_bufs(struct vb2_queue *q, enum vb2_memory memory,
>   */
>  int vb2_core_prepare_buf(struct vb2_queue *q, unsigned int index, void *pb);
>  
> +/**
> + * vb2_setup_out_fence() - setup new out-fence
> + * @q:		The vb2_queue where to setup it
> + * @index:	index of the buffer
> + *
> + * Setup the file descriptor, the fence and the sync_file for the next
> + * buffer to be queued and add everything to the tail of the q->out_fence_list.
> + */
> +int vb2_setup_out_fence(struct vb2_queue *q, unsigned int index);
> +
>  /**
>   * vb2_core_qbuf() - Queue a buffer from userspace
>   *
> 

Regards,

	Hans
