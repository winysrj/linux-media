Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud9.xs4all.net ([194.109.24.26]:47326 "EHLO
        lb2-smtp-cloud9.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752212AbeCNPze (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 14 Mar 2018 11:55:34 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
Subject: Re: [PATCH v8 09/13] [media] vb2: add in-fence support to QBUF
To: Gustavo Padovan <gustavo@padovan.org>, linux-media@vger.kernel.org
Cc: kernel@collabora.com,
        Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
        Shuah Khan <shuahkh@osg.samsung.com>,
        Pawel Osciak <pawel@osciak.com>,
        Alexandre Courbot <acourbot@chromium.org>,
        Sakari Ailus <sakari.ailus@iki.fi>,
        Brian Starkey <brian.starkey@arm.com>,
        linux-kernel@vger.kernel.org,
        Gustavo Padovan <gustavo.padovan@collabora.com>
References: <20180309174920.22373-1-gustavo@padovan.org>
 <20180309174920.22373-10-gustavo@padovan.org>
Message-ID: <c053b011-4273-7b32-71f0-f6b6054a7be2@xs4all.nl>
Date: Wed, 14 Mar 2018 08:55:17 -0700
MIME-Version: 1.0
In-Reply-To: <20180309174920.22373-10-gustavo@padovan.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 03/09/2018 09:49 AM, Gustavo Padovan wrote:
> From: Gustavo Padovan <gustavo.padovan@collabora.com>
> 
> Receive in-fence from userspace and add support for waiting on them
> before queueing the buffer to the driver. Buffers can't be queued to the
> driver before its fences signal. And a buffer can't be queue to the driver

queue -> queued

> out of the order they were queued from userspace. That means that even if
> it fence signal it must wait all other buffers, ahead of it in the queue,

it fence signal -> its fence signals
wait all -> wait for all

> to signal first.
> 
> If the fence for some buffer fails we do not queue it to the driver,
> instead we mark it as error and wait until the previous buffer is done
> to notify userspace of the error. We wait here to deliver the buffers back
> to userspace in order.
> 
> v9:	- rename fence to in_fence in many places
> 	- handle fences signalling with error better (Hans Verkuil)
> 
> v8:	- improve comments and docs (Hans Verkuil)
> 	- fix unlocking of vb->fence_cb_lock on vb2_core_qbuf (Hans Verkuil)
> 	- move in-fences code that was in the out-fences patch here (Alex)
> 
> v8:	- improve comments about fences with errors

v9? Two v8 entries?

> 
> v7:
> 	- get rid of the fence array stuff for ordering and just use
> 	get_num_buffers_ready() (Hans)
> 	- fix issue of queuing the buffer twice (Hans)
> 	- avoid the dma_fence_wait() in core_qbuf() (Alex)
> 	- merge preparation commit in
> 
> v6:
> 	- With fences always keep the order userspace queues the buffers.
> 	- Protect in_fence manipulation with a lock (Brian Starkey)
> 	- check if fences have the same context before adding a fence array
> 	- Fix last_fence ref unbalance in __set_in_fence() (Brian Starkey)
> 	- Clean up fence if __set_in_fence() fails (Brian Starkey)
> 	- treat -EINVAL from dma_fence_add_callback() (Brian Starkey)
> 
> v5:	- use fence_array to keep buffers ordered in vb2 core when
> 	needed (Brian Starkey)
> 	- keep backward compat on the reserved2 field (Brian Starkey)
> 	- protect fence callback removal with lock (Brian Starkey)
> 
> v4:
> 	- Add a comment about dma_fence_add_callback() not returning a
> 	error (Hans)
> 	- Call dma_fence_put(vb->in_fence) if fence signaled (Hans)
> 	- select SYNC_FILE under config VIDEOBUF2_CORE (Hans)
> 	- Move dma_fence_is_signaled() check to __enqueue_in_driver() (Hans)
> 	- Remove list_for_each_entry() in __vb2_core_qbuf() (Hans)
> 	-  Remove if (vb->state != VB2_BUF_STATE_QUEUED) from
> 	vb2_start_streaming() (Hans)
> 	- set IN_FENCE flags on __fill_v4l2_buffer (Hans)
> 	- Queue buffers to the driver as soon as they are ready (Hans)
> 	- call fill_user_buffer() after queuing the buffer (Hans)
> 	- add err: label to clean up fence
> 	- add dma_fence_wait() before calling vb2_start_streaming()
> 
> v3:	- document fence parameter
> 	- remove ternary if at vb2_qbuf() return (Mauro)
> 	- do not change if conditions behaviour (Mauro)
> 
> v2:
> 	- fix vb2_queue_or_prepare_buf() ret check
> 	- remove check for VB2_MEMORY_DMABUF only (Javier)
> 	- check num of ready buffers to start streaming
> 	- when queueing, start from the first ready buffer
> 	- handle queue cancel
> 
> Signed-off-by: Gustavo Padovan <gustavo.padovan@collabora.com>
> ---
>  drivers/media/common/videobuf2/videobuf2-core.c | 197 ++++++++++++++++++++----
>  drivers/media/common/videobuf2/videobuf2-v4l2.c |  34 +++-
>  drivers/media/v4l2-core/Kconfig                 |  33 ++++
>  include/media/videobuf2-core.h                  |  14 +-
>  4 files changed, 248 insertions(+), 30 deletions(-)
> 
> diff --git a/drivers/media/common/videobuf2/videobuf2-core.c b/drivers/media/common/videobuf2/videobuf2-core.c
> index d3f7bb33a54d..5de5e35cfc40 100644
> --- a/drivers/media/common/videobuf2/videobuf2-core.c
> +++ b/drivers/media/common/videobuf2/videobuf2-core.c
> @@ -352,6 +352,7 @@ static int __vb2_queue_alloc(struct vb2_queue *q, enum vb2_memory memory,
>  		vb->index = q->num_buffers + buffer;
>  		vb->type = q->type;
>  		vb->memory = memory;
> +		spin_lock_init(&vb->fence_cb_lock);
>  		for (plane = 0; plane < num_planes; ++plane) {
>  			vb->planes[plane].length = plane_sizes[plane];
>  			vb->planes[plane].min_length = plane_sizes[plane];
> @@ -891,20 +892,12 @@ void *vb2_plane_cookie(struct vb2_buffer *vb, unsigned int plane_no)
>  }
>  EXPORT_SYMBOL_GPL(vb2_plane_cookie);
>  
> -void vb2_buffer_done(struct vb2_buffer *vb, enum vb2_buffer_state state)
> +static void vb2_process_buffer_done(struct vb2_buffer *vb, enum vb2_buffer_state state)
>  {
>  	struct vb2_queue *q = vb->vb2_queue;
>  	unsigned long flags;
>  	unsigned int plane;
>  
> -	if (WARN_ON(vb->state != VB2_BUF_STATE_ACTIVE))
> -		return;
> -
> -	if (WARN_ON(state != VB2_BUF_STATE_DONE &&
> -		    state != VB2_BUF_STATE_ERROR &&
> -		    state != VB2_BUF_STATE_QUEUED &&
> -		    state != VB2_BUF_STATE_REQUEUEING))
> -		state = VB2_BUF_STATE_ERROR;
>  
>  #ifdef CONFIG_VIDEO_ADV_DEBUG
>  	/*
> @@ -921,6 +914,9 @@ void vb2_buffer_done(struct vb2_buffer *vb, enum vb2_buffer_state state)
>  		call_void_memop(vb, finish, vb->planes[plane].mem_priv);
>  
>  	spin_lock_irqsave(&q->done_lock, flags);
> +	if (vb->state == VB2_BUF_STATE_ACTIVE)
> +		atomic_dec(&q->owned_by_drv_count);
> +
>  	if (state == VB2_BUF_STATE_QUEUED ||
>  	    state == VB2_BUF_STATE_REQUEUEING) {
>  		vb->state = VB2_BUF_STATE_QUEUED;
> @@ -929,7 +925,7 @@ void vb2_buffer_done(struct vb2_buffer *vb, enum vb2_buffer_state state)
>  		list_add_tail(&vb->done_entry, &q->done_list);
>  		vb->state = state;
>  	}
> -	atomic_dec(&q->owned_by_drv_count);
> +
>  	spin_unlock_irqrestore(&q->done_lock, flags);
>  
>  	trace_vb2_buf_done(q, vb);
> @@ -946,6 +942,36 @@ void vb2_buffer_done(struct vb2_buffer *vb, enum vb2_buffer_state state)
>  		wake_up(&q->done_wq);
>  		break;
>  	}
> +
> +}
> +
> +void vb2_buffer_done(struct vb2_buffer *vb, enum vb2_buffer_state state)
> +{
> +	if (WARN_ON(vb->state != VB2_BUF_STATE_ACTIVE))
> +		return;
> +
> +	if (WARN_ON(state != VB2_BUF_STATE_DONE &&
> +		    state != VB2_BUF_STATE_ERROR &&
> +		    state != VB2_BUF_STATE_QUEUED &&
> +		    state != VB2_BUF_STATE_REQUEUEING))
> +		state = VB2_BUF_STATE_ERROR;
> +
> +	vb2_process_buffer_done(vb, state);
> +
> +	/*
> +	 * Check if there is any buffer with error in the next position of the queue,
> +	 * buffers whose in-fence signaled with error are not queued to the driver
> +	 * and kept on the queue until the buffer before them is done, so to not
> +	 * delivery buffers back to userspace in the wrong order. Here we process

delivery -> deliver

> +	 * any existing buffers with errors and wake up userspace.
> +	 */
> +	for (;;) {
> +		vb = list_next_entry(vb, queued_entry);
> +		if (!vb || vb->state != VB2_BUF_STATE_ERROR)
> +			break;
> +
> +		vb2_process_buffer_done(vb, VB2_BUF_STATE_ERROR);
> +        }
>  }
>  EXPORT_SYMBOL_GPL(vb2_buffer_done);
>  
> @@ -1230,6 +1256,9 @@ static void __enqueue_in_driver(struct vb2_buffer *vb)
>  {
>  	struct vb2_queue *q = vb->vb2_queue;
>  
> +	if (vb->in_fence && !dma_fence_is_signaled(vb->in_fence))
> +		return;
> +
>  	vb->state = VB2_BUF_STATE_ACTIVE;
>  	atomic_inc(&q->owned_by_drv_count);
>  
> @@ -1281,6 +1310,24 @@ static int __buf_prepare(struct vb2_buffer *vb, const void *pb)
>  	return 0;
>  }
>  
> +static int __get_num_ready_buffers(struct vb2_queue *q)
> +{
> +	struct vb2_buffer *vb;
> +	int ready_count = 0;
> +	unsigned long flags;
> +
> +	/* count num of buffers ready in front of the queued_list */
> +	list_for_each_entry(vb, &q->queued_list, queued_entry) {
> +		spin_lock_irqsave(&vb->fence_cb_lock, flags);
> +		if (vb->in_fence && !dma_fence_is_signaled(vb->in_fence))
> +			break;
> +		ready_count++;
> +		spin_unlock_irqrestore(&vb->fence_cb_lock, flags);
> +	}
> +
> +	return ready_count;
> +}
> +
>  int vb2_core_prepare_buf(struct vb2_queue *q, unsigned int index, void *pb)
>  {
>  	struct vb2_buffer *vb;
> @@ -1369,9 +1416,43 @@ static int vb2_start_streaming(struct vb2_queue *q)
>  	return ret;
>  }
>  
> -int vb2_core_qbuf(struct vb2_queue *q, unsigned int index, void *pb)
> +static void vb2_qbuf_fence_cb(struct dma_fence *f, struct dma_fence_cb *cb)
> +{
> +	struct vb2_buffer *vb = container_of(cb, struct vb2_buffer, fence_cb);
> +	struct vb2_queue *q = vb->vb2_queue;
> +	unsigned long flags;
> +
> +	spin_lock_irqsave(&vb->fence_cb_lock, flags);
> +	/*
> +	 * If the fence signals with an error we mark the buffer as such
> +	 * and avoid using it by setting it to VB2_BUF_STATE_ERROR and
> +	 * not queueing it to the driver. However we can't notify the error
> +	 * to userspace right now because, at the time this callback run, QBUF
> +	 * returned already.

returned -> has returned

> +	 * So we delay that to DQBUF time. See comments in vb2_buffer_done()
> +	 * as well.
> +	 */
> +	if (vb->in_fence->error)
> +		vb->state = VB2_BUF_STATE_ERROR;
> +
> +	dma_fence_put(vb->in_fence);
> +	vb->in_fence = NULL;
> +
> +	if (vb->state == VB2_BUF_STATE_ERROR) {
> +		spin_unlock_irqrestore(&vb->fence_cb_lock, flags);
> +		return;
> +	}
> +
> +	if (q->start_streaming_called)
> +		__enqueue_in_driver(vb);
> +	spin_unlock_irqrestore(&vb->fence_cb_lock, flags);
> +}
> +
> +int vb2_core_qbuf(struct vb2_queue *q, unsigned int index, void *pb,
> +		  struct dma_fence *in_fence)
>  {
>  	struct vb2_buffer *vb;
> +	unsigned long flags;
>  	int ret;
>  
>  	vb = q->bufs[index];
> @@ -1380,16 +1461,18 @@ int vb2_core_qbuf(struct vb2_queue *q, unsigned int index, void *pb)
>  	case VB2_BUF_STATE_DEQUEUED:
>  		ret = __buf_prepare(vb, pb);
>  		if (ret)
> -			return ret;
> +			goto err;
>  		break;
>  	case VB2_BUF_STATE_PREPARED:
>  		break;
>  	case VB2_BUF_STATE_PREPARING:
>  		dprintk(1, "buffer still being prepared\n");
> -		return -EINVAL;
> +		ret = -EINVAL;
> +		goto err;
>  	default:
>  		dprintk(1, "invalid buffer state %d\n", vb->state);
> -		return -EINVAL;
> +		ret = -EINVAL;
> +		goto err;
>  	}
>  
>  	/*
> @@ -1400,6 +1483,7 @@ int vb2_core_qbuf(struct vb2_queue *q, unsigned int index, void *pb)
>  	q->queued_count++;
>  	q->waiting_for_buffers = false;
>  	vb->state = VB2_BUF_STATE_QUEUED;
> +	vb->in_fence = in_fence;
>  
>  	if (pb)
>  		call_void_bufop(q, copy_timestamp, vb, pb);
> @@ -1407,15 +1491,40 @@ int vb2_core_qbuf(struct vb2_queue *q, unsigned int index, void *pb)
>  	trace_vb2_qbuf(q, vb);
>  
>  	/*
> -	 * If already streaming, give the buffer to driver for processing.
> -	 * If not, the buffer will be given to driver on next streamon.
> +	 * For explicit synchronization: If the fence didn't signal
> +	 * yet we setup a callback to queue the buffer once the fence
> +	 * signals, and then, return successfully. But if the fence

, and then, -> and then (no commas)

> +	 * already signaled we lose the reference we held and queue the
> +	 * buffer to the driver.
>  	 */
> -	if (q->start_streaming_called)
> -		__enqueue_in_driver(vb);
> +	spin_lock_irqsave(&vb->fence_cb_lock, flags);
> +	if (vb->in_fence) {
> +		ret = dma_fence_add_callback(vb->in_fence, &vb->fence_cb,
> +					     vb2_qbuf_fence_cb);
> +		/* is the fence signaled? */
> +		if (ret == -ENOENT) {
> +			dma_fence_put(vb->in_fence);
> +			vb->in_fence = NULL;
> +		} else if (ret) {
> +			goto unlock;
> +		}
> +	}
>  
> -	/* Fill buffer information for the userspace */
> -	if (pb)
> -		call_void_bufop(q, fill_user_buffer, vb, pb);
> +	/*
> +	 * If already streaming and there is no fence to wait on
> +	 * give the buffer to driver for processing.
> +	 */
> +	if (q->start_streaming_called) {
> +		struct vb2_buffer *b;
> +
> +		list_for_each_entry(b, &q->queued_list, queued_entry) {
> +			if (b->state != VB2_BUF_STATE_QUEUED)
> +				continue;
> +			if (b->in_fence)
> +				break;
> +			__enqueue_in_driver(b);
> +		}
> +	}
>  
>  	/*
>  	 * If streamon has been called, and we haven't yet called
> @@ -1424,14 +1533,36 @@ int vb2_core_qbuf(struct vb2_queue *q, unsigned int index, void *pb)
>  	 * then we can finally call start_streaming().
>  	 */
>  	if (q->streaming && !q->start_streaming_called &&
> -	    q->queued_count >= q->min_buffers_needed) {
> +	    __get_num_ready_buffers(q) >= q->min_buffers_needed) {
>  		ret = vb2_start_streaming(q);
>  		if (ret)
> -			return ret;
> +			goto unlock;
>  	}
>  
> +	spin_unlock_irqrestore(&vb->fence_cb_lock, flags);
> +
> +	/* Fill buffer information for the userspace */
> +	if (pb)
> +		call_void_bufop(q, fill_user_buffer, vb, pb);
> +
>  	dprintk(2, "qbuf of buffer %d succeeded\n", vb->index);
>  	return 0;
> +
> +unlock:
> +	spin_unlock_irqrestore(&vb->fence_cb_lock, flags);
> +
> +err:
> +	/* Fill buffer information for the userspace */
> +	if (pb)
> +		call_void_bufop(q, fill_user_buffer, vb, pb);
> +
> +	if (vb->in_fence) {
> +		dma_fence_put(vb->in_fence);
> +		vb->in_fence = NULL;
> +	}
> +
> +	return ret;
> +
>  }
>  EXPORT_SYMBOL_GPL(vb2_core_qbuf);
>  
> @@ -1642,6 +1773,8 @@ EXPORT_SYMBOL_GPL(vb2_core_dqbuf);
>  static void __vb2_queue_cancel(struct vb2_queue *q)
>  {
>  	unsigned int i;
> +	struct vb2_buffer *vb;
> +	unsigned long flags;
>  
>  	/*
>  	 * Tell driver to stop all transactions and release all queued
> @@ -1672,6 +1805,16 @@ static void __vb2_queue_cancel(struct vb2_queue *q)
>  	q->queued_count = 0;
>  	q->error = 0;
>  
> +	list_for_each_entry(vb, &q->queued_list, queued_entry) {
> +		spin_lock_irqsave(&vb->fence_cb_lock, flags);
> +		if (vb->in_fence) {
> +			dma_fence_remove_callback(vb->in_fence, &vb->fence_cb);
> +			dma_fence_put(vb->in_fence);
> +			vb->in_fence = NULL;
> +		}
> +		spin_unlock_irqrestore(&vb->fence_cb_lock, flags);
> +	}
> +
>  	/*
>  	 * Remove all buffers from videobuf's list...
>  	 */
> @@ -1742,7 +1885,7 @@ int vb2_core_streamon(struct vb2_queue *q, unsigned int type)
>  	 * Tell driver to start streaming provided sufficient buffers
>  	 * are available.
>  	 */
> -	if (q->queued_count >= q->min_buffers_needed) {
> +	if (__get_num_ready_buffers(q) >= q->min_buffers_needed) {
>  		ret = v4l_vb2q_enable_media_source(q);
>  		if (ret)
>  			return ret;
> @@ -2264,7 +2407,7 @@ static int __vb2_init_fileio(struct vb2_queue *q, int read)
>  		 * Queue all buffers.
>  		 */
>  		for (i = 0; i < q->num_buffers; i++) {
> -			ret = vb2_core_qbuf(q, i, NULL);
> +			ret = vb2_core_qbuf(q, i, NULL, NULL);
>  			if (ret)
>  				goto err_reqbufs;
>  			fileio->bufs[i].queued = 1;
> @@ -2443,7 +2586,7 @@ static size_t __vb2_perform_fileio(struct vb2_queue *q, char __user *data, size_
>  
>  		if (copy_timestamp)
>  			b->timestamp = ktime_get_ns();
> -		ret = vb2_core_qbuf(q, index, NULL);
> +		ret = vb2_core_qbuf(q, index, NULL, NULL);
>  		dprintk(5, "vb2_dbuf result: %d\n", ret);
>  		if (ret)
>  			return ret;
> @@ -2546,7 +2689,7 @@ static int vb2_thread(void *data)
>  		if (copy_timestamp)
>  			vb->timestamp = ktime_get_ns();
>  		if (!threadio->stop)
> -			ret = vb2_core_qbuf(q, vb->index, NULL);
> +			ret = vb2_core_qbuf(q, vb->index, NULL, NULL);
>  		call_void_qop(q, wait_prepare, q);
>  		if (ret || threadio->stop)
>  			break;
> diff --git a/drivers/media/common/videobuf2/videobuf2-v4l2.c b/drivers/media/common/videobuf2/videobuf2-v4l2.c
> index ad1e032c3bf5..1df5dd01c0cd 100644
> --- a/drivers/media/common/videobuf2/videobuf2-v4l2.c
> +++ b/drivers/media/common/videobuf2/videobuf2-v4l2.c
> @@ -23,6 +23,7 @@
>  #include <linux/sched.h>
>  #include <linux/freezer.h>
>  #include <linux/kthread.h>
> +#include <linux/sync_file.h>
>  
>  #include <media/v4l2-dev.h>
>  #include <media/v4l2-fh.h>
> @@ -178,6 +179,17 @@ static int vb2_queue_or_prepare_buf(struct vb2_queue *q, struct v4l2_buffer *b,
>  		return -EINVAL;
>  	}
>  
> +	if ((b->fence_fd != 0 && b->fence_fd != -1) &&
> +	    !(b->flags & V4L2_BUF_FLAG_IN_FENCE)) {
> +		dprintk(1, "%s: fence_fd set without IN_FENCE flag\n", opname);
> +		return -EINVAL;
> +	}
> +
> +	if (b->fence_fd < 0 && (b->flags & V4L2_BUF_FLAG_IN_FENCE)) {
> +		dprintk(1, "%s: IN_FENCE flag set but no fence_fd\n", opname);
> +		return -EINVAL;
> +	}
> +
>  	return __verify_planes_array(q->bufs[b->index], b);
>  }
>  
> @@ -203,9 +215,14 @@ static void __fill_v4l2_buffer(struct vb2_buffer *vb, void *pb)
>  	b->timestamp = ns_to_timeval(vb->timestamp);
>  	b->timecode = vbuf->timecode;
>  	b->sequence = vbuf->sequence;
> -	b->fence_fd = 0;
>  	b->reserved = 0;
>  
> +	b->fence_fd = 0;
> +	if (vb->in_fence)
> +		b->flags |= V4L2_BUF_FLAG_IN_FENCE;
> +	else
> +		b->flags &= ~V4L2_BUF_FLAG_IN_FENCE;
> +

I was wondering: if the in-fence was already triggered this flag is not set because
vb->in_fence will be NULL. Would it be useful to add a vb2 flag that is set when the
in-fence triggered and report that here somehow? It might be useful for debugging.

Just wondering.

>  	if (q->is_multiplanar) {
>  		/*
>  		 * Fill in plane-related data if userspace provided an array
> @@ -562,6 +579,7 @@ EXPORT_SYMBOL_GPL(vb2_create_bufs);
>  
>  int vb2_qbuf(struct vb2_queue *q, struct v4l2_buffer *b)
>  {
> +	struct dma_fence *in_fence = NULL;
>  	int ret;
>  
>  	if (vb2_fileio_is_active(q)) {
> @@ -570,7 +588,19 @@ int vb2_qbuf(struct vb2_queue *q, struct v4l2_buffer *b)
>  	}
>  
>  	ret = vb2_queue_or_prepare_buf(q, b, "qbuf");
> -	return ret ? ret : vb2_core_qbuf(q, b->index, b);
> +	if (ret)
> +		return ret;
> +
> +	if (b->flags & V4L2_BUF_FLAG_IN_FENCE) {
> +		in_fence = sync_file_get_fence(b->fence_fd);
> +		if (!in_fence) {
> +			dprintk(1, "failed to get in-fence from fd %d\n",
> +				b->fence_fd);
> +			return -EINVAL;
> +		}
> +	}
> +
> +	return vb2_core_qbuf(q, b->index, b, in_fence);
>  }
>  EXPORT_SYMBOL_GPL(vb2_qbuf);
>  
> diff --git a/drivers/media/v4l2-core/Kconfig b/drivers/media/v4l2-core/Kconfig
> index 8e37e7c5e0f7..79dfb5dfd1fc 100644
> --- a/drivers/media/v4l2-core/Kconfig
> +++ b/drivers/media/v4l2-core/Kconfig
> @@ -80,3 +80,36 @@ config VIDEOBUF_DMA_CONTIG
>  config VIDEOBUF_DVB
>  	tristate
>  	select VIDEOBUF_GEN
> +
> +# Used by drivers that need Videobuf2 modules
> +config VIDEOBUF2_CORE
> +	select DMA_SHARED_BUFFER
> +	select SYNC_FILE
> +	tristate
> +
> +config VIDEOBUF2_MEMOPS
> +	tristate
> +	select FRAME_VECTOR
> +
> +config VIDEOBUF2_DMA_CONTIG
> +	tristate
> +	depends on HAS_DMA
> +	select VIDEOBUF2_CORE
> +	select VIDEOBUF2_MEMOPS
> +	select DMA_SHARED_BUFFER
> +
> +config VIDEOBUF2_VMALLOC
> +	tristate
> +	select VIDEOBUF2_CORE
> +	select VIDEOBUF2_MEMOPS
> +	select DMA_SHARED_BUFFER
> +
> +config VIDEOBUF2_DMA_SG
> +	tristate
> +	depends on HAS_DMA
> +	select VIDEOBUF2_CORE
> +	select VIDEOBUF2_MEMOPS
> +
> +config VIDEOBUF2_DVB
> +	tristate
> +	select VIDEOBUF2_CORE
> diff --git a/include/media/videobuf2-core.h b/include/media/videobuf2-core.h
> index 46a9e674f7e1..59cd9a6ac168 100644
> --- a/include/media/videobuf2-core.h
> +++ b/include/media/videobuf2-core.h
> @@ -17,6 +17,7 @@
>  #include <linux/poll.h>
>  #include <linux/dma-buf.h>
>  #include <linux/bitops.h>
> +#include <linux/dma-fence.h>
>  
>  #define VB2_MAX_FRAME	(32)
>  #define VB2_MAX_PLANES	(8)
> @@ -255,12 +256,21 @@ struct vb2_buffer {
>  	 * done_entry:		entry on the list that stores all buffers ready
>  	 *			to be dequeued to userspace
>  	 * vb2_plane:		per-plane information; do not change
> +	 * in_fence:		fence received from vb2 client to wait on before
> +	 *			using the buffer (queueing to the driver)
> +	 * fence_cb:		fence callback information
> +	 * fence_cb_lock:	protect callback signal/remove
>  	 */
>  	enum vb2_buffer_state	state;
>  
>  	struct vb2_plane	planes[VB2_MAX_PLANES];
>  	struct list_head	queued_entry;
>  	struct list_head	done_entry;
> +
> +	struct dma_fence	*in_fence;
> +	struct dma_fence_cb	fence_cb;
> +	spinlock_t              fence_cb_lock;
> +
>  #ifdef CONFIG_VIDEO_ADV_DEBUG
>  	/*
>  	 * Counters for how often these buffer-related ops are
> @@ -751,6 +761,7 @@ int vb2_core_prepare_buf(struct vb2_queue *q, unsigned int index, void *pb);
>   * @index:	id number of the buffer
>   * @pb:		buffer structure passed from userspace to
>   *		v4l2_ioctl_ops->vidioc_qbuf handler in driver
> + * @in_fence:	in-fence to wait on before queueing the buffer
>   *
>   * Videobuf2 core helper to implement VIDIOC_QBUF() operation. It is called
>   * internally by VB2 by an API-specific handler, like ``videobuf2-v4l2.h``.
> @@ -765,7 +776,8 @@ int vb2_core_prepare_buf(struct vb2_queue *q, unsigned int index, void *pb);
>   *
>   * Return: returns zero on success; an error code otherwise.
>   */
> -int vb2_core_qbuf(struct vb2_queue *q, unsigned int index, void *pb);
> +int vb2_core_qbuf(struct vb2_queue *q, unsigned int index, void *pb,
> +		  struct dma_fence *in_fence);
>  
>  /**
>   * vb2_core_dqbuf() - Dequeue a buffer to the userspace
> 

Looks good!

Regards,

	Hans
