Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qt0-f196.google.com ([209.85.216.196]:37728 "EHLO
        mail-qt0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754865AbeARRiZ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 18 Jan 2018 12:38:25 -0500
Date: Thu, 18 Jan 2018 15:38:14 -0200
From: Gustavo Padovan <gustavo@padovan.org>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org,
        Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
        Shuah Khan <shuahkh@osg.samsung.com>,
        Pawel Osciak <pawel@osciak.com>,
        Alexandre Courbot <acourbot@chromium.org>,
        Sakari Ailus <sakari.ailus@iki.fi>,
        Brian Starkey <brian.starkey@arm.com>,
        Thierry Escande <thierry.escande@collabora.com>,
        linux-kernel@vger.kernel.org,
        Gustavo Padovan <gustavo.padovan@collabora.com>
Subject: Re: [PATCH v7 4/6] [media] vb2: add in-fence support to QBUF
Message-ID: <20180118173814.GC9598@jade>
References: <20180110160732.7722-1-gustavo@padovan.org>
 <20180110160732.7722-5-gustavo@padovan.org>
 <9a581c51-53b2-8832-9fce-684882135476@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9a581c51-53b2-8832-9fce-684882135476@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

2018-01-12 Hans Verkuil <hverkuil@xs4all.nl>:

> On 01/10/18 17:07, Gustavo Padovan wrote:
> > From: Gustavo Padovan <gustavo.padovan@collabora.com>
> > 
> > Receive in-fence from userspace and add support for waiting on them
> > before queueing the buffer to the driver. Buffers can't be queued to the
> > driver before its fences signal. And a buffer can't be queue to the driver
> > out of the order they were queued from userspace. That means that even if
> > it fence signal it must wait all other buffers, ahead of it in the queue,
> > to signal first.
> > 
> > If the fence for some buffer fails we do not queue it to the driver,
> > instead we mark it as error and wait until the previous buffer is done
> > to notify userspace of the error. We wait here to deliver the buffers back
> > to userspace in order.
> > 
> > v8:	- improve comments about fences with errors
> > 
> > v7:
> > 	- get rid of the fence array stuff for ordering and just use
> > 	get_num_buffers_ready() (Hans)
> > 	- fix issue of queuing the buffer twice (Hans)
> > 	- avoid the dma_fence_wait() in core_qbuf() (Alex)
> > 	- merge preparation commit in
> > 
> > v6:
> > 	- With fences always keep the order userspace queues the buffers.
> > 	- Protect in_fence manipulation with a lock (Brian Starkey)
> > 	- check if fences have the same context before adding a fence array
> > 	- Fix last_fence ref unbalance in __set_in_fence() (Brian Starkey)
> > 	- Clean up fence if __set_in_fence() fails (Brian Starkey)
> > 	- treat -EINVAL from dma_fence_add_callback() (Brian Starkey)
> > 
> > v5:	- use fence_array to keep buffers ordered in vb2 core when
> > 	needed (Brian Starkey)
> > 	- keep backward compat on the reserved2 field (Brian Starkey)
> > 	- protect fence callback removal with lock (Brian Starkey)
> > 
> > v4:
> > 	- Add a comment about dma_fence_add_callback() not returning a
> > 	error (Hans)
> > 	- Call dma_fence_put(vb->in_fence) if fence signaled (Hans)
> > 	- select SYNC_FILE under config VIDEOBUF2_CORE (Hans)
> > 	- Move dma_fence_is_signaled() check to __enqueue_in_driver() (Hans)
> > 	- Remove list_for_each_entry() in __vb2_core_qbuf() (Hans)
> > 	-  Remove if (vb->state != VB2_BUF_STATE_QUEUED) from
> > 	vb2_start_streaming() (Hans)
> > 	- set IN_FENCE flags on __fill_v4l2_buffer (Hans)
> > 	- Queue buffers to the driver as soon as they are ready (Hans)
> > 	- call fill_user_buffer() after queuing the buffer (Hans)
> > 	- add err: label to clean up fence
> > 	- add dma_fence_wait() before calling vb2_start_streaming()
> > 
> > v3:	- document fence parameter
> > 	- remove ternary if at vb2_qbuf() return (Mauro)
> > 	- do not change if conditions behaviour (Mauro)
> > 
> > v2:
> > 	- fix vb2_queue_or_prepare_buf() ret check
> > 	- remove check for VB2_MEMORY_DMABUF only (Javier)
> > 	- check num of ready buffers to start streaming
> > 	- when queueing, start from the first ready buffer
> > 	- handle queue cancel
> > 
> > Signed-off-by: Gustavo Padovan <gustavo.padovan@collabora.com>
> > ---
> >  drivers/media/common/videobuf/videobuf2-core.c | 166 ++++++++++++++++++++++---
> >  drivers/media/common/videobuf/videobuf2-v4l2.c |  29 ++++-
> >  drivers/media/v4l2-core/Kconfig                |  33 +++++
> >  include/media/videobuf2-core.h                 |  14 ++-
> >  4 files changed, 221 insertions(+), 21 deletions(-)
> > 
> > diff --git a/drivers/media/common/videobuf/videobuf2-core.c b/drivers/media/common/videobuf/videobuf2-core.c
> > index f7109f827f6e..777e3a2bc746 100644
> > --- a/drivers/media/common/videobuf/videobuf2-core.c
> > +++ b/drivers/media/common/videobuf/videobuf2-core.c
> > @@ -352,6 +352,7 @@ static int __vb2_queue_alloc(struct vb2_queue *q, enum vb2_memory memory,
> >  		vb->index = q->num_buffers + buffer;
> >  		vb->type = q->type;
> >  		vb->memory = memory;
> > +		spin_lock_init(&vb->fence_cb_lock);
> >  		for (plane = 0; plane < num_planes; ++plane) {
> >  			vb->planes[plane].length = plane_sizes[plane];
> >  			vb->planes[plane].min_length = plane_sizes[plane];
> > @@ -936,7 +937,7 @@ void vb2_buffer_done(struct vb2_buffer *vb, enum vb2_buffer_state state)
> >  
> >  	switch (state) {
> >  	case VB2_BUF_STATE_QUEUED:
> > -		return;
> > +		break;
> >  	case VB2_BUF_STATE_REQUEUEING:
> >  		if (q->start_streaming_called)
> >  			__enqueue_in_driver(vb);
> > @@ -946,6 +947,19 @@ void vb2_buffer_done(struct vb2_buffer *vb, enum vb2_buffer_state state)
> >  		wake_up(&q->done_wq);
> >  		break;
> >  	}
> > +
> > +	/*
> > +	 * The check below verifies if there is a buffer in queue with an
> 
> s/in/in the/
> 
> > +	 * error state. They are added to queue in the error state when
> > +	 * their in-fence fails to signal.
> > +	 * To not mess with buffer ordering we wait until the previous buffer
> > +	 * is done to mark the buffer in the error state as done and notify
> > +	 * userspace. So everytime a buffer is done we check the next one for
> 
> s/everytime/every time/
> 
> > +	 * VB2_BUF_STATE_ERROR.
> > +	 */
> > +	vb = list_next_entry(vb, queued_entry);
> > +	if (vb && vb->state == VB2_BUF_STATE_ERROR)
> > +		vb2_buffer_done(vb, vb->state);
> 
> Hmm. I'm not sure this is correct. Please test this and make sure you have
> enabled CONFIG_VIDEO_ADV_DEBUG. This enables additional instrumentation that
> will warn if the internal vb2 state becomes unbalanced.
> 
> An additional problem I have with this recursive call is what happens when
> a whole bunch of in fences signal an error, so you have e.g. 10 consecutive
> buffers with state ERROR. You'd recurse 10 times in that case.
> 
> I think you are better off handling this corner case explicitly, e.g. something
> like this:
> 
> 	for (;;) {
> 		vb = list_next_entry(vb, queued_entry);
> 		if (!vb || vb->state != VB2_BUF_STATE_ERROR)
> 			break;
> 
> 	        dprintk(4, "done processing on buffer %d, state: %d\n",
>         	        vb->index, vb->state);
> 
> 		if (state == VB2_BUF_STATE_QUEUED) {
> 			vb->state = state;
> 		} else {
> 		        spin_lock_irqsave(&q->done_lock, flags);
>                 	/* Add the buffer to the done buffers list */
>         	        list_add_tail(&vb->done_entry, &q->done_list);
> 		        spin_unlock_irqrestore(&q->done_lock, flags);
> 
> 	                /* Inform any processes that may be waiting for buffers */
>         	        wake_up(&q->done_wq);
> 		}
> 
>         	trace_vb2_buf_done(q, vb);
> 	}
> 
> I *think* this ensures all counters remain balanced, but this really needs
> to be tested. I haven't compiled this code, so I hope I got it right.

I'll play with this and make sure I get it right.

> 
> >  }
> >  EXPORT_SYMBOL_GPL(vb2_buffer_done);
> >  
> > @@ -1230,6 +1244,9 @@ static void __enqueue_in_driver(struct vb2_buffer *vb)
> >  {
> >  	struct vb2_queue *q = vb->vb2_queue;
> >  
> > +	if (vb->in_fence && !dma_fence_is_signaled(vb->in_fence))
> > +		return;
> > +
> >  	vb->state = VB2_BUF_STATE_ACTIVE;
> >  	atomic_inc(&q->owned_by_drv_count);
> >  
> > @@ -1281,6 +1298,24 @@ static int __buf_prepare(struct vb2_buffer *vb, const void *pb)
> >  	return 0;
> >  }
> >  
> > +static int __get_num_ready_buffers(struct vb2_queue *q)
> > +{
> > +	struct vb2_buffer *vb;
> > +	int ready_count = 0;
> > +	unsigned long flags;
> > +
> > +	/* count num of buffers ready in front of the queued_list */
> > +	list_for_each_entry(vb, &q->queued_list, queued_entry) {
> > +		spin_lock_irqsave(&vb->fence_cb_lock, flags);
> > +		if (vb->in_fence && !dma_fence_is_signaled(vb->in_fence))
> > +			break;
> > +		ready_count++;
> > +		spin_unlock_irqrestore(&vb->fence_cb_lock, flags);
> > +	}
> > +
> > +	return ready_count;
> > +}
> > +
> >  int vb2_core_prepare_buf(struct vb2_queue *q, unsigned int index, void *pb)
> >  {
> >  	struct vb2_buffer *vb;
> > @@ -1369,9 +1404,43 @@ static int vb2_start_streaming(struct vb2_queue *q)
> >  	return ret;
> >  }
> >  
> > -int vb2_core_qbuf(struct vb2_queue *q, unsigned int index, void *pb)
> > +static void vb2_qbuf_fence_cb(struct dma_fence *f, struct dma_fence_cb *cb)
> > +{
> > +	struct vb2_buffer *vb = container_of(cb, struct vb2_buffer, fence_cb);
> > +	struct vb2_queue *q = vb->vb2_queue;
> > +	unsigned long flags;
> > +
> > +	spin_lock_irqsave(&vb->fence_cb_lock, flags);
> > +	/*
> > +	 * If the fence signal with an error we mark the buffer as such
> 
> s/signal/signals/
> 
> > +	 * and avoid using it by setting it to VB2_BUF_STATE_ERROR and
> > +	 * not queueing it to the driver. However we can't notify the error
> > +	 * to userspace right now because, at the time this callback run, QBUF
> > +	 * returned already.
> > +	 * So we delay that to DQBUF time. See comments in vb2_buffer_done()
> > +	 * as well.
> > +	 */
> > +	if (vb->in_fence->error)
> > +		vb->state = VB2_BUF_STATE_ERROR;
> > +
> > +	dma_fence_put(vb->in_fence);
> > +	vb->in_fence = NULL;
> > +
> > +	if (vb->state == VB2_BUF_STATE_ERROR) {
> > +		spin_unlock_irqrestore(&vb->fence_cb_lock, flags);
> > +		return;
> > +	}
> > +
> > +	if (q->start_streaming_called)
> > +		__enqueue_in_driver(vb);
> > +	spin_unlock_irqrestore(&vb->fence_cb_lock, flags);
> > +}
> > +
> > +int vb2_core_qbuf(struct vb2_queue *q, unsigned int index, void *pb,
> > +		  struct dma_fence *fence)
> >  {
> >  	struct vb2_buffer *vb;
> > +	unsigned long flags;
> >  	int ret;
> >  
> >  	vb = q->bufs[index];
> > @@ -1380,16 +1449,18 @@ int vb2_core_qbuf(struct vb2_queue *q, unsigned int index, void *pb)
> >  	case VB2_BUF_STATE_DEQUEUED:
> >  		ret = __buf_prepare(vb, pb);
> >  		if (ret)
> > -			return ret;
> > +			goto err;
> >  		break;
> >  	case VB2_BUF_STATE_PREPARED:
> >  		break;
> >  	case VB2_BUF_STATE_PREPARING:
> >  		dprintk(1, "buffer still being prepared\n");
> > -		return -EINVAL;
> > +		ret = -EINVAL;
> > +		goto err;
> >  	default:
> >  		dprintk(1, "invalid buffer state %d\n", vb->state);
> > -		return -EINVAL;
> > +		ret = -EINVAL;
> > +		goto err;
> >  	}
> >  
> >  	/*
> > @@ -1400,6 +1471,7 @@ int vb2_core_qbuf(struct vb2_queue *q, unsigned int index, void *pb)
> >  	q->queued_count++;
> >  	q->waiting_for_buffers = false;
> >  	vb->state = VB2_BUF_STATE_QUEUED;
> > +	vb->in_fence = fence;
> >  
> >  	if (pb)
> >  		call_void_bufop(q, copy_timestamp, vb, pb);
> > @@ -1407,15 +1479,42 @@ int vb2_core_qbuf(struct vb2_queue *q, unsigned int index, void *pb)
> >  	trace_vb2_qbuf(q, vb);
> >  
> >  	/*
> > -	 * If already streaming, give the buffer to driver for processing.
> > -	 * If not, the buffer will be given to driver on next streamon.
> > +	 * For explicit synchronization: If the fence didn't signal
> > +	 * yet we setup a callback to queue the buffer once the fence
> > +	 * signals, and then, return successfully. But if the fence
> > +	 * already signaled we lose the reference we held and queue the
> > +	 * buffer to the driver.
> >  	 */
> > -	if (q->start_streaming_called)
> > -		__enqueue_in_driver(vb);
> > +	spin_lock_irqsave(&vb->fence_cb_lock, flags);
> > +	if (vb->in_fence) {
> > +		ret = dma_fence_add_callback(vb->in_fence, &vb->fence_cb,
> > +					     vb2_qbuf_fence_cb);
> > +		if (ret == -EINVAL) {
> > +			spin_unlock_irqrestore(&vb->fence_cb_lock, flags);
> > +			goto err;
> > +		} else if (!ret) {
> > +			goto fill;
> > +		}
> >  
> > -	/* Fill buffer information for the userspace */
> > -	if (pb)
> > -		call_void_bufop(q, fill_user_buffer, vb, pb);
> > +		dma_fence_put(vb->in_fence);
> > +		vb->in_fence = NULL;
> > +	}
> > +
> > +fill:
> > +	/*
> > +	 * If already streaming and there is no fence to wait on
> > +	 * give the buffer to driver for processing.
> > +	 */
> > +	if (q->start_streaming_called) {
> > +		struct vb2_buffer *b;
> 
> Add empty line.
> 
> > +		list_for_each_entry(b, &q->queued_list, queued_entry) {
> > +			if (b->state != VB2_BUF_STATE_QUEUED)
> > +				continue;
> > +			if (b->in_fence)
> > +				break;
> > +			__enqueue_in_driver(b);
> > +		}
> > +	}
> >  
> >  	/*
> >  	 * If streamon has been called, and we haven't yet called
> > @@ -1424,14 +1523,33 @@ int vb2_core_qbuf(struct vb2_queue *q, unsigned int index, void *pb)
> >  	 * then we can finally call start_streaming().
> >  	 */
> >  	if (q->streaming && !q->start_streaming_called &&
> > -	    q->queued_count >= q->min_buffers_needed) {
> > +	    __get_num_ready_buffers(q) >= q->min_buffers_needed) {
> >  		ret = vb2_start_streaming(q);
> >  		if (ret)
> > -			return ret;
> > +			goto err;
> 
> You're missing a spin_unlock_irqrestore() call in this error path.
> 
> >  	}
> >  
> > +	spin_unlock_irqrestore(&vb->fence_cb_lock, flags);
> > +
> > +	/* Fill buffer information for the userspace */
> > +	if (pb)
> > +		call_void_bufop(q, fill_user_buffer, vb, pb);
> > +
> >  	dprintk(2, "qbuf of buffer %d succeeded\n", vb->index);
> >  	return 0;
> > +
> > +err:
> > +	/* Fill buffer information for the userspace */
> > +	if (pb)
> > +		call_void_bufop(q, fill_user_buffer, vb, pb);
> > +
> > +	if (vb->in_fence) {
> > +		dma_fence_put(vb->in_fence);
> > +		vb->in_fence = NULL;
> > +	}
> > +
> > +	return ret;
> > +
> >  }
> >  EXPORT_SYMBOL_GPL(vb2_core_qbuf);
> >  
> > @@ -1642,6 +1760,8 @@ EXPORT_SYMBOL_GPL(vb2_core_dqbuf);
> >  static void __vb2_queue_cancel(struct vb2_queue *q)
> >  {
> >  	unsigned int i;
> > +	struct vb2_buffer *vb;
> > +	unsigned long flags;
> >  
> >  	/*
> >  	 * Tell driver to stop all transactions and release all queued
> > @@ -1672,6 +1792,16 @@ static void __vb2_queue_cancel(struct vb2_queue *q)
> >  	q->queued_count = 0;
> >  	q->error = 0;
> >  
> > +	list_for_each_entry(vb, &q->queued_list, queued_entry) {
> > +		spin_lock_irqsave(&vb->fence_cb_lock, flags);
> > +		if (vb->in_fence) {
> > +			dma_fence_remove_callback(vb->in_fence, &vb->fence_cb);
> > +			dma_fence_put(vb->in_fence);
> > +			vb->in_fence = NULL;
> > +		}
> > +		spin_unlock_irqrestore(&vb->fence_cb_lock, flags);
> > +	}
> > +
> >  	/*
> >  	 * Remove all buffers from videobuf's list...
> >  	 */
> > @@ -1733,7 +1863,7 @@ int vb2_core_streamon(struct vb2_queue *q, unsigned int type)
> >  	 * Tell driver to start streaming provided sufficient buffers
> >  	 * are available.
> >  	 */
> > -	if (q->queued_count >= q->min_buffers_needed) {
> > +	if (__get_num_ready_buffers(q) >= q->min_buffers_needed) {
> >  		ret = v4l_vb2q_enable_media_source(q);
> >  		if (ret)
> >  			return ret;
> > @@ -2255,7 +2385,7 @@ static int __vb2_init_fileio(struct vb2_queue *q, int read)
> >  		 * Queue all buffers.
> >  		 */
> >  		for (i = 0; i < q->num_buffers; i++) {
> > -			ret = vb2_core_qbuf(q, i, NULL);
> > +			ret = vb2_core_qbuf(q, i, NULL, NULL);
> >  			if (ret)
> >  				goto err_reqbufs;
> >  			fileio->bufs[i].queued = 1;
> > @@ -2434,7 +2564,7 @@ static size_t __vb2_perform_fileio(struct vb2_queue *q, char __user *data, size_
> >  
> >  		if (copy_timestamp)
> >  			b->timestamp = ktime_get_ns();
> > -		ret = vb2_core_qbuf(q, index, NULL);
> > +		ret = vb2_core_qbuf(q, index, NULL, NULL);
> >  		dprintk(5, "vb2_dbuf result: %d\n", ret);
> >  		if (ret)
> >  			return ret;
> > @@ -2537,7 +2667,7 @@ static int vb2_thread(void *data)
> >  		if (copy_timestamp)
> >  			vb->timestamp = ktime_get_ns();
> >  		if (!threadio->stop)
> > -			ret = vb2_core_qbuf(q, vb->index, NULL);
> > +			ret = vb2_core_qbuf(q, vb->index, NULL, NULL);
> >  		call_void_qop(q, wait_prepare, q);
> >  		if (ret || threadio->stop)
> >  			break;
> > diff --git a/drivers/media/common/videobuf/videobuf2-v4l2.c b/drivers/media/common/videobuf/videobuf2-v4l2.c
> > index d838524a459e..0a41e3bb7733 100644
> > --- a/drivers/media/common/videobuf/videobuf2-v4l2.c
> > +++ b/drivers/media/common/videobuf/videobuf2-v4l2.c
> > @@ -23,6 +23,7 @@
> >  #include <linux/sched.h>
> >  #include <linux/freezer.h>
> >  #include <linux/kthread.h>
> > +#include <linux/sync_file.h>
> >  
> >  #include <media/v4l2-dev.h>
> >  #include <media/v4l2-fh.h>
> > @@ -178,6 +179,12 @@ static int vb2_queue_or_prepare_buf(struct vb2_queue *q, struct v4l2_buffer *b,
> >  		return -EINVAL;
> >  	}
> >  
> > +	if ((b->fence_fd != 0 && b->fence_fd != -1) &&
> 
> Wouldn't 'b->fence_fd > 0' be more sensible?

This is the case where the in fence flag is not set, I think we also
want to cover < -1 values userspace may set.

Gustavo
