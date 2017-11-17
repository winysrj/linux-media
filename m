Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qt0-f194.google.com ([209.85.216.194]:40633 "EHLO
        mail-qt0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750878AbdKQNMz (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 17 Nov 2017 08:12:55 -0500
Date: Fri, 17 Nov 2017 11:12:48 -0200
From: Gustavo Padovan <gustavo@padovan.org>
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: linux-media@vger.kernel.org, Hans Verkuil <hverkuil@xs4all.nl>,
        Shuah Khan <shuahkh@osg.samsung.com>,
        Pawel Osciak <pawel@osciak.com>,
        Alexandre Courbot <acourbot@chromium.org>,
        Sakari Ailus <sakari.ailus@iki.fi>,
        Brian Starkey <brian.starkey@arm.com>,
        Thierry Escande <thierry.escande@collabora.com>,
        linux-kernel@vger.kernel.org,
        Gustavo Padovan <gustavo.padovan@collabora.com>
Subject: Re: [RFC v5 07/11] [media] vb2: add in-fence support to QBUF
Message-ID: <20171117131248.GI19033@jade>
References: <20171115171057.17340-1-gustavo@padovan.org>
 <20171115171057.17340-8-gustavo@padovan.org>
 <20171117105351.3bb0af32@vento.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20171117105351.3bb0af32@vento.lan>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

2017-11-17 Mauro Carvalho Chehab <mchehab@osg.samsung.com>:

> Em Wed, 15 Nov 2017 15:10:53 -0200
> Gustavo Padovan <gustavo@padovan.org> escreveu:
> 
> > From: Gustavo Padovan <gustavo.padovan@collabora.com>
> > 
> > Receive in-fence from userspace and add support for waiting on them
> > before queueing the buffer to the driver. Buffers can't be queued to the
> > driver before its fences signal. And a buffer can't be queue to the driver
> > out of the order they were queued from userspace. That means that even if
> > it fence signal it must wait all other buffers, ahead of it in the queue,
> > to signal first.
> > 
> > To make that possible we use fence_array to keep that ordering. Basically
> > we create a fence_array that contains both the current fence and the fence
> > from the previous buffer (which might be a fence array as well). The base
> > fence class for the fence_array becomes the new buffer fence, waiting on
> > that one guarantees that it won't be queued out of order.
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
> >  drivers/media/v4l2-core/Kconfig          |   1 +
> >  drivers/media/v4l2-core/videobuf2-core.c | 202 ++++++++++++++++++++++++++++---
> >  drivers/media/v4l2-core/videobuf2-v4l2.c |  29 ++++-
> >  include/media/videobuf2-core.h           |  17 ++-
> >  4 files changed, 231 insertions(+), 18 deletions(-)
> > 
> > diff --git a/drivers/media/v4l2-core/Kconfig b/drivers/media/v4l2-core/Kconfig
> > index a35c33686abf..3f988c407c80 100644
> > --- a/drivers/media/v4l2-core/Kconfig
> > +++ b/drivers/media/v4l2-core/Kconfig
> > @@ -83,6 +83,7 @@ config VIDEOBUF_DVB
> >  # Used by drivers that need Videobuf2 modules
> >  config VIDEOBUF2_CORE
> >  	select DMA_SHARED_BUFFER
> > +	select SYNC_FILE
> >  	tristate
> >  
> >  config VIDEOBUF2_MEMOPS
> > diff --git a/drivers/media/v4l2-core/videobuf2-core.c b/drivers/media/v4l2-core/videobuf2-core.c
> > index 60f8b582396a..26de4c80717d 100644
> > --- a/drivers/media/v4l2-core/videobuf2-core.c
> > +++ b/drivers/media/v4l2-core/videobuf2-core.c
> > @@ -23,6 +23,7 @@
> >  #include <linux/sched.h>
> >  #include <linux/freezer.h>
> >  #include <linux/kthread.h>
> > +#include <linux/dma-fence-array.h>
> >  
> >  #include <media/videobuf2-core.h>
> >  #include <media/v4l2-mc.h>
> > @@ -346,6 +347,7 @@ static int __vb2_queue_alloc(struct vb2_queue *q, enum vb2_memory memory,
> >  		vb->index = q->num_buffers + buffer;
> >  		vb->type = q->type;
> >  		vb->memory = memory;
> > +		spin_lock_init(&vb->fence_cb_lock);
> >  		for (plane = 0; plane < num_planes; ++plane) {
> >  			vb->planes[plane].length = plane_sizes[plane];
> >  			vb->planes[plane].min_length = plane_sizes[plane];
> > @@ -1222,6 +1224,9 @@ static void __enqueue_in_driver(struct vb2_buffer *vb)
> >  {
> >  	struct vb2_queue *q = vb->vb2_queue;
> >  
> > +	if (vb->in_fence && !dma_fence_is_signaled(vb->in_fence))
> > +		return;
> > +
> >  	vb->state = VB2_BUF_STATE_ACTIVE;
> >  	atomic_inc(&q->owned_by_drv_count);
> >  
> > @@ -1273,6 +1278,23 @@ static int __buf_prepare(struct vb2_buffer *vb, const void *pb)
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
> > +		if (!vb->in_fence || dma_fence_is_signaled(vb->in_fence))
> > +			ready_count++;
> > +		spin_unlock_irqrestore(&vb->fence_cb_lock, flags);
> > +	}
> > +
> > +	return ready_count;
> > +}
> > +
> >  int vb2_core_prepare_buf(struct vb2_queue *q, unsigned int index, void *pb)
> >  {
> >  	struct vb2_buffer *vb;
> > @@ -1361,9 +1383,87 @@ static int vb2_start_streaming(struct vb2_queue *q)
> >  	return ret;
> >  }
> >  
> > -int vb2_core_qbuf(struct vb2_queue *q, unsigned int index, void *pb)
> > +static struct dma_fence *__set_in_fence(struct vb2_queue *q,
> > +					struct vb2_buffer *vb,
> > +					struct dma_fence *fence)
> > +{
> > +	if (q->last_fence && dma_fence_is_signaled(q->last_fence)) {
> > +		dma_fence_put(q->last_fence);
> > +		q->last_fence = NULL;
> > +	}
> > +
> > +	/*
> > +	 * We always guarantee the ordering of buffers queued from
> > +	 * userspace to be the same it is queued to the driver. For that
> > +	 * we create a fence array with the fence from the last queued
> > +	 * buffer and this one, that way the fence for this buffer can't
> > +	 * signal before the last one.
> > +	 */
> > +	if (fence && q->last_fence) {
> > +		struct dma_fence **fences;
> > +		struct dma_fence_array *arr;
> > +
> > +		if (fence->context == q->last_fence->context) {
> > +			if (fence->seqno - q->last_fence->seqno <= INT_MAX) {
> > +				dma_fence_put(q->last_fence);
> > +				q->last_fence = dma_fence_get(fence);
> > +			} else {
> > +				dma_fence_put(fence);
> > +				fence = dma_fence_get(q->last_fence);
> > +			}
> > +			return fence;
> > +		}
> > +
> > +		fences = kcalloc(2, sizeof(*fences), GFP_KERNEL);
> > +		if (!fences)
> > +			return ERR_PTR(-ENOMEM);
> > +
> > +		fences[0] = fence;
> > +		fences[1] = q->last_fence;
> > +
> > +		arr = dma_fence_array_create(2, fences,
> > +					     dma_fence_context_alloc(1),
> > +					     1, false);
> > +		if (!arr) {
> > +			kfree(fences);
> > +			return ERR_PTR(-ENOMEM);
> > +		}
> > +
> > +		fence = &arr->base;
> > +
> > +		q->last_fence = dma_fence_get(fence);
> > +	} else if (!fence && q->last_fence) {
> > +		fence = dma_fence_get(q->last_fence);
> > +	}
> > +
> > +	return fence;
> > +}
> > +
> > +static void vb2_qbuf_fence_cb(struct dma_fence *f, struct dma_fence_cb *cb)
> > +{
> > +	struct vb2_buffer *vb = container_of(cb, struct vb2_buffer, fence_cb);
> > +	struct vb2_queue *q = vb->vb2_queue;
> > +	unsigned long flags;
> > +
> > +	spin_lock_irqsave(&vb->fence_cb_lock, flags);
> > +	if (!vb->in_fence) {
> > +		spin_unlock_irqrestore(&vb->fence_cb_lock, flags);
> > +		return;
> > +	}
> > +
> > +	dma_fence_put(vb->in_fence);
> > +	vb->in_fence = NULL;
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
> > @@ -1372,16 +1472,18 @@ int vb2_core_qbuf(struct vb2_queue *q, unsigned int index, void *pb)
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
> > @@ -1398,30 +1500,83 @@ int vb2_core_qbuf(struct vb2_queue *q, unsigned int index, void *pb)
> >  
> >  	trace_vb2_qbuf(q, vb);
> >  
> > +	vb->in_fence = __set_in_fence(q, vb, fence);
> > +	if (IS_ERR(vb->in_fence)) {
> > +		dma_fence_put(fence);
> > +		ret = PTR_ERR(vb->in_fence);
> > +		goto err;
> > +	}
> > +	fence = NULL;
> > +
> > +	/*
> > +	 * If it is time to call vb2_start_streaming() wait for the fence
> > +	 * to signal first. Of course, this happens only once per streaming.
> > +	 * We want to run any step that might fail before we set the callback
> > +	 * to queue the fence when it signals.
> > +	 */
> > +	if (vb->in_fence && !q->start_streaming_called &&
> > +	    __get_num_ready_buffers(q) == q->min_buffers_needed - 1)
> > +		dma_fence_wait(vb->in_fence, true);
> > +
> 
> The above code sounds weird: it is called even if the user is not
> using fences.
> 
> You should probably be doing something like:
> 
> 	if (fence || q->last_fence) {
> 		vb->in_fence = __set_in_fence(q, vb, fence);
> 		...
> 	}
> 

Sure.

> >  	/*
> >  	 * If streamon has been called, and we haven't yet called
> >  	 * start_streaming() since not enough buffers were queued, and
> >  	 * we now have reached the minimum number of queued buffers,
> >  	 * then we can finally call start_streaming().
> > -	 *
> > -	 * If already streaming, give the buffer to driver for processing.
> > -	 * If not, the buffer will be given to driver on next streamon.
> >  	 */
> >  	if (q->streaming && !q->start_streaming_called &&
> > -	    q->queued_count >= q->min_buffers_needed) {
> > +	    __get_num_ready_buffers(q) >= q->min_buffers_needed) {
> 
> I guess the case where fences is not used is not covered here.
> 
> You probably should add a check at __get_num_ready_buffers(q)
> as well, making it just return q->queued_count if fences isn't
> used.

We can't know that beforehand, some buffer ahead may have a fence,
but there is already a check for !fence for each buffer. If none of
them have fences the return will be equal to q->queued_count.

Gustavo
