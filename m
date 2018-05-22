Return-path: <linux-media-owner@vger.kernel.org>
Received: from bhuna.collabora.co.uk ([46.235.227.227]:33516 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751268AbeEVQYX (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 22 May 2018 12:24:23 -0400
Message-ID: <062e8128491e63927f4669ad08c40d29dfbb4141.camel@collabora.com>
Subject: Re: [PATCH v10 12/16] vb2: add in-fence support to QBUF
From: Ezequiel Garcia <ezequiel@collabora.com>
To: Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org
Cc: kernel@collabora.com,
        Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
        Shuah Khan <shuahkh@osg.samsung.com>,
        Pawel Osciak <pawel@osciak.com>,
        Alexandre Courbot <acourbot@chromium.org>,
        Sakari Ailus <sakari.ailus@iki.fi>,
        Brian Starkey <brian.starkey@arm.com>,
        linux-kernel@vger.kernel.org,
        Gustavo Padovan <gustavo.padovan@collabora.com>
Date: Tue, 22 May 2018 13:22:57 -0300
In-Reply-To: <7462919b-ad6f-eb8c-7389-ef0ff6e9d1a2@xs4all.nl>
References: <20180521165946.11778-1-ezequiel@collabora.com>
         <20180521165946.11778-13-ezequiel@collabora.com>
         <7462919b-ad6f-eb8c-7389-ef0ff6e9d1a2@xs4all.nl>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, 2018-05-22 at 14:37 +0200, Hans Verkuil wrote:
> On 21/05/18 18:59, Ezequiel Garcia wrote:
> > From: Gustavo Padovan <gustavo.padovan@collabora.com>
> > 
> > Receive in-fence from userspace and add support for waiting on them
> > before queueing the buffer to the driver. Buffers can't be queued to the
> > driver before its fences signal. And a buffer can't be queued to the driver
> > out of the order they were queued from userspace. That means that even if
> > its fence signals it must wait for all other buffers, ahead of it in the queue,
> > to signal first.
> > 
> > If the fence for some buffer fails we do not queue it to the driver,
> > instead we mark it as error and wait until the previous buffer is done
> > to notify userspace of the error. We wait here to deliver the buffers back
> > to userspace in order.
> > 
> > v13: - cleanup implementation.
> >      - remove wrong Kconfig changes.
> >      - print noisy warning on unexpected enqueue conditioin
> >      - schedule a vb2_start_streaming work from the fence callback
> > 
> > v12: fixed dvb_vb2.c usage of vb2_core_qbuf.
> > 
> > v11: - minor doc/comments fixes (Hans Verkuil)
> >      - reviewed the in-fence path at __fill_v4l2_buffer()
> > 
> > v10: - rename fence to in_fence in many places
> >      - handle fences signalling with error better (Hans Verkuil)
> > 
> > v9: - improve comments and docs (Hans Verkuil)
> >     - fix unlocking of vb->fence_cb_lock on vb2_core_qbuf (Hans Verkuil)
> >     - move in-fences code that was in the out-fences patch here (Alex)
> > 
> > v8: - improve comments about fences with errors
> > 
> > v7: - get rid of the fence array stuff for ordering and just use
> >       get_num_buffers_ready() (Hans)
> >     - fix issue of queuing the buffer twice (Hans)
> >     - avoid the dma_fence_wait() in core_qbuf() (Alex)
> >     - merge preparation commit in
> > 
> > v6: - With fences always keep the order userspace queues the buffers.
> >     - Protect in_fence manipulation with a lock (Brian Starkey)
> >     - check if fences have the same context before adding a fence array
> >     - Fix last_fence ref unbalance in __set_in_fence() (Brian Starkey)
> >     - Clean up fence if __set_in_fence() fails (Brian Starkey)
> >     - treat -EINVAL from dma_fence_add_callback() (Brian Starkey)
> > 
> > v5: - use fence_array to keep buffers ordered in vb2 core when
> >       needed (Brian Starkey)
> >     - keep backward compat on the reserved2 field (Brian Starkey)
> >     - protect fence callback removal with lock (Brian Starkey)
> > 
> > v4: - Add a comment about dma_fence_add_callback() not returning a
> >       error (Hans)
> >     - Call dma_fence_put(vb->in_fence) if fence signaled (Hans)
> >     - select SYNC_FILE under config VIDEOBUF2_CORE (Hans)
> >     - Move dma_fence_is_signaled() check to __enqueue_in_driver() (Hans)
> >     - Remove list_for_each_entry() in __vb2_core_qbuf() (Hans)
> >     - Remove if (vb->state != VB2_BUF_STATE_QUEUED) from
> >       vb2_start_streaming() (Hans)
> >     - set IN_FENCE flags on __fill_v4l2_buffer (Hans)
> >     - Queue buffers to the driver as soon as they are ready (Hans)
> >     - call fill_user_buffer() after queuing the buffer (Hans)
> >     - add err: label to clean up fence
> >     - add dma_fence_wait() before calling vb2_start_streaming()
> > 
> > v3: - document fence parameter
> >     - remove ternary if at vb2_qbuf() return (Mauro)
> >     - do not change if conditions behaviour (Mauro)
> > 
> > v2: - fix vb2_queue_or_prepare_buf() ret check
> >     - remove check for VB2_MEMORY_DMABUF only (Javier)
> >     - check num of ready buffers to start streaming
> >     - when queueing, start from the first ready buffer
> >     - handle queue cancel
> > 
> > Signed-off-by: Gustavo Padovan <gustavo.padovan@collabora.com>
> > Signed-off-by: Ezequiel Garcia <ezequiel@collabora.com>
> > ---
> >  drivers/media/common/videobuf2/Kconfig          |   1 +
> >  drivers/media/common/videobuf2/videobuf2-core.c | 224 ++++++++++++++++++++----
> >  drivers/media/common/videobuf2/videobuf2-v4l2.c |  37 +++-
> >  drivers/media/dvb-core/dvb_vb2.c                |   2 +-
> >  include/media/videobuf2-core.h                  |  19 +-
> >  5 files changed, 242 insertions(+), 41 deletions(-)
> > 
> > diff --git a/drivers/media/common/videobuf2/Kconfig b/drivers/media/common/videobuf2/Kconfig
> > index 17c32ea58395..27ad9e8a268b 100644
> > --- a/drivers/media/common/videobuf2/Kconfig
> > +++ b/drivers/media/common/videobuf2/Kconfig
> > @@ -1,6 +1,7 @@
> >  # Used by drivers that need Videobuf2 modules
> >  config VIDEOBUF2_CORE
> >  	select DMA_SHARED_BUFFER
> > +	select SYNC_FILE
> >  	tristate
> >  
> >  config VIDEOBUF2_V4L2
> > diff --git a/drivers/media/common/videobuf2/videobuf2-core.c b/drivers/media/common/videobuf2/videobuf2-core.c
> > index a9a0a9d1decb..86b5ebe25263 100644
> > --- a/drivers/media/common/videobuf2/videobuf2-core.c
> > +++ b/drivers/media/common/videobuf2/videobuf2-core.c
> > @@ -27,6 +27,7 @@
> >  #include <linux/kthread.h>
> >  
> >  #include <media/videobuf2-core.h>
> > +#include <media/v4l2-ioctl.h>
> >  #include <media/v4l2-mc.h>
> >  
> >  #include <trace/events/vb2.h>
> > @@ -189,6 +190,7 @@ module_param(debug, int, 0644);
> >  
> >  static void __vb2_queue_cancel(struct vb2_queue *q);
> >  static void __enqueue_in_driver(struct vb2_buffer *vb);
> > +static void __qbuf_work(struct work_struct *work);
> >  
> >  static void __vb2_buffer_free(struct kref *kref)
> >  {
> > @@ -373,6 +375,7 @@ static int __vb2_queue_alloc(struct vb2_queue *q, enum vb2_memory memory,
> >  		vb->index = q->num_buffers + buffer;
> >  		vb->type = q->type;
> >  		vb->memory = memory;
> > +		INIT_WORK(&vb->qbuf_work, __qbuf_work);
> >  		for (plane = 0; plane < num_planes; ++plane) {
> >  			vb->planes[plane].length = plane_sizes[plane];
> >  			vb->planes[plane].min_length = plane_sizes[plane];
> > @@ -932,21 +935,12 @@ void *vb2_plane_cookie(struct vb2_buffer *vb, unsigned int plane_no)
> >  }
> >  EXPORT_SYMBOL_GPL(vb2_plane_cookie);
> >  
> > -void vb2_buffer_done(struct vb2_buffer *vb, enum vb2_buffer_state state)
> > +static void vb2_process_buffer_done(struct vb2_buffer *vb, enum vb2_buffer_state state)
> >  {
> >  	struct vb2_queue *q = vb->vb2_queue;
> >  	unsigned long flags;
> >  	unsigned int plane;
> >  
> > -	if (WARN_ON(vb->state != VB2_BUF_STATE_ACTIVE))
> > -		return;
> > -
> > -	if (WARN_ON(state != VB2_BUF_STATE_DONE &&
> > -		    state != VB2_BUF_STATE_ERROR &&
> > -		    state != VB2_BUF_STATE_QUEUED &&
> > -		    state != VB2_BUF_STATE_REQUEUEING))
> > -		state = VB2_BUF_STATE_ERROR;
> > -
> >  #ifdef CONFIG_VIDEO_ADV_DEBUG
> >  	/*
> >  	 * Although this is not a callback, it still does have to balance
> > @@ -962,6 +956,9 @@ void vb2_buffer_done(struct vb2_buffer *vb, enum vb2_buffer_state state)
> >  		call_void_memop(vb, finish, vb->planes[plane].mem_priv);
> >  
> >  	spin_lock_irqsave(&q->done_lock, flags);
> > +	if (vb->state == VB2_BUF_STATE_ACTIVE)
> > +		atomic_dec(&q->owned_by_drv_count);
> > +
> >  	if (state == VB2_BUF_STATE_QUEUED ||
> >  	    state == VB2_BUF_STATE_REQUEUEING) {
> >  		vb->state = VB2_BUF_STATE_QUEUED;
> > @@ -970,7 +967,7 @@ void vb2_buffer_done(struct vb2_buffer *vb, enum vb2_buffer_state state)
> >  		list_add_tail(&vb->done_entry, &q->done_list);
> >  		vb->state = state;
> >  	}
> > -	atomic_dec(&q->owned_by_drv_count);
> > +
> >  	spin_unlock_irqrestore(&q->done_lock, flags);
> >  
> >  	trace_vb2_buf_done(q, vb);
> > @@ -987,6 +984,47 @@ void vb2_buffer_done(struct vb2_buffer *vb, enum vb2_buffer_state state)
> >  		wake_up(&q->done_wq);
> >  		break;
> >  	}
> > +
> > +}
> > +
> > +void vb2_buffer_done(struct vb2_buffer *vb, enum vb2_buffer_state state)
> > +{
> > +	struct vb2_buffer *next;
> > +	struct vb2_queue *q;
> > +
> > +	dprintk(4, "called done on buffer %d state: %d -> %d\n",
> > +			vb->index, vb->state, state);
> > +
> > +	if (vb->state == VB2_BUF_STATE_ERROR)
> > +		return;
> > +	if (WARN_ON(vb->state != VB2_BUF_STATE_ACTIVE))
> > +		return;
> > +
> > +	if (WARN_ON(state != VB2_BUF_STATE_DONE &&
> > +		    state != VB2_BUF_STATE_ERROR &&
> > +		    state != VB2_BUF_STATE_QUEUED &&
> > +		    state != VB2_BUF_STATE_REQUEUEING))
> > +		state = VB2_BUF_STATE_ERROR;
> > +
> > +	vb2_process_buffer_done(vb, state);
> > +
> > +	/*
> > +	 * Check if there is any buffer with an in-fence error in the next
> > +	 * position of the queue. Buffers whose in-fence signaled with error
> > +	 * are not queued to the driver and kept on the queue until the buffer
> > +	 * before them is done.
> > +	 * So here we process any existing buffers with in-fence errors and
> > +	 * wake up userspace.
> > +	 */
> > +	q = vb->vb2_queue;
> > +	next = list_next_entry(vb, queued_entry);
> > +	list_for_each_entry_from(next, &q->queued_list, queued_entry) {
> > +		if (!next->in_fence || !next->in_fence->error)
> > +			break;
> > +		if (next->in_fence && next->in_fence->error &&
> > +		    vb->state != VB2_BUF_STATE_ERROR)
> > +			vb2_process_buffer_done(next, VB2_BUF_STATE_ERROR);
> > +	}
> >  }
> >  EXPORT_SYMBOL_GPL(vb2_buffer_done);
> >  
> > @@ -1271,6 +1309,8 @@ static void __enqueue_in_driver(struct vb2_buffer *vb)
> >  {
> >  	struct vb2_queue *q = vb->vb2_queue;
> >  
> > +	if (WARN_ON(vb->state == VB2_BUF_STATE_ACTIVE))
> > +		return;
> >  	vb->state = VB2_BUF_STATE_ACTIVE;
> >  	atomic_inc(&q->owned_by_drv_count);
> >  
> > @@ -1322,6 +1362,25 @@ static int __buf_prepare(struct vb2_buffer *vb, const void *pb)
> >  	return 0;
> >  }
> >  
> > +static int __get_num_ready_buffers(struct vb2_queue *q)
> > +{
> > +	struct vb2_buffer *vb;
> > +	int ready_count = 0;
> > +
> > +	/*
> > +	 * Count num of buffers ready in front of the queued_list.
> > +	 * We want to stop counting when we find a buffer with an
> > +	 * unsignaled fence.
> > +	 */
> > +	list_for_each_entry(vb, &q->queued_list, queued_entry) {
> > +		if (vb->in_fence && dma_fence_get_status(vb->in_fence) == 0)
> > +			break;
> > +		ready_count++;
> > +	}
> > +
> > +	return ready_count;
> > +}
> > +
> >  int vb2_core_prepare_buf(struct vb2_queue *q, unsigned int index, void *pb)
> >  {
> >  	struct vb2_buffer *vb;
> > @@ -1338,7 +1397,7 @@ int vb2_core_prepare_buf(struct vb2_queue *q, unsigned int index, void *pb)
> >  	if (ret)
> >  		return ret;
> >  
> > -	/* Fill buffer information for the userspace */
> > +	/* Fill buffer information for userspace */
> >  	call_void_bufop(q, fill_user_buffer, vb, pb);
> >  
> >  	dprintk(2, "prepare of buffer %d succeeded\n", vb->index);
> > @@ -1364,11 +1423,16 @@ static int vb2_start_streaming(struct vb2_queue *q)
> >  	int ret;
> >  
> >  	/*
> > -	 * If any buffers were queued before streamon,
> > -	 * we can now pass them to driver for processing.
> > +	 * Activate all buffers currently queued,
> > +	 * until we get an unsignaled fence.
> >  	 */
> > -	list_for_each_entry(vb, &q->queued_list, queued_entry)
> > +	list_for_each_entry(vb, &q->queued_list, queued_entry) {
> > +		if (vb->state != VB2_BUF_STATE_QUEUED)
> 
> I prefer: if (vb->state == VB2_BUF_STATE_ERROR)
> 
> It also needs a comment.
> 


> > +			continue;
> > +		if (vb->in_fence && dma_fence_get_status(vb->in_fence) == 0)
> > +			break;
> >  		__enqueue_in_driver(vb);
> > +	}
> >  
> >  	/* Tell the driver to start streaming */
> >  	q->start_streaming_called = 1;
> > @@ -1410,7 +1474,41 @@ static int vb2_start_streaming(struct vb2_queue *q)
> >  	return ret;
> >  }
> >  
> > -int vb2_core_qbuf(struct vb2_queue *q, unsigned int index, void *pb)
> > +static void __qbuf_work(struct work_struct *work)
> > +{
> > +	struct vb2_buffer *vb;
> > +	struct vb2_queue *q;
> > +
> > +	vb = container_of(work, struct vb2_buffer, qbuf_work);
> > +	q = vb->vb2_queue;
> > +
> > +	if (q->lock)
> > +		mutex_lock(q->lock);
> > +	/* By the time we run, the buffer state could have changed,
> > +	 * so we need to check it's in the queued state.
> > +	 * This is the only valid state.
> > +	 */
> > +	if (q->start_streaming_called && vb->state == VB2_BUF_STATE_QUEUED)
> > +		__enqueue_in_driver(vb);
> > +
> > +	if (q->streaming && !q->start_streaming_called &&
> > +	    __get_num_ready_buffers(q) >= q->min_buffers_needed)
> > +		vb2_start_streaming(q);
> 
> What happens if vb2_start_streaming fails?
> 
> > +
> > +	if (q->lock)
> > +		mutex_unlock(q->lock);
> > +	__vb2_buffer_put(vb);
> > +}
> > +
> > +static void vb2_qbuf_fence_cb(struct dma_fence *f, struct dma_fence_cb *cb)
> > +{
> > +	struct vb2_buffer *vb = container_of(cb, struct vb2_buffer, fence_cb);
> > +
> > +	schedule_work(&vb->qbuf_work);
> > +}
> > +
> > +int vb2_core_qbuf(struct vb2_queue *q, unsigned int index, void *pb,
> > +		  struct dma_fence *in_fence)
> >  {
> >  	struct vb2_buffer *vb;
> >  	int ret;
> > @@ -1421,16 +1519,18 @@ int vb2_core_qbuf(struct vb2_queue *q, unsigned int index, void *pb)
> >  	case VB2_BUF_STATE_DEQUEUED:
> >  		ret = __buf_prepare(vb, pb);
> >  		if (ret)
> > -			return ret;
> > +			goto err_release;
> >  		break;
> >  	case VB2_BUF_STATE_PREPARED:
> >  		break;
> >  	case VB2_BUF_STATE_PREPARING:
> >  		dprintk(1, "buffer still being prepared\n");
> > -		return -EINVAL;
> > +		ret = -EINVAL;
> > +		goto err_release;
> >  	default:
> >  		dprintk(1, "invalid buffer state %d\n", vb->state);
> > -		return -EINVAL;
> > +		ret = -EINVAL;
> > +		goto err_release;
> >  	}
> >  
> >  	/*
> > @@ -1448,15 +1548,44 @@ int vb2_core_qbuf(struct vb2_queue *q, unsigned int index, void *pb)
> >  	trace_vb2_qbuf(q, vb);
> >  
> >  	/*
> > -	 * If already streaming, give the buffer to driver for processing.
> > -	 * If not, the buffer will be given to driver on next streamon.
> > +	 * If the fence didn't signal yet, we setup a callback to queue
> > +	 * the buffer once the fence signals. If the fence already signaled,
> > +	 * then we lose the reference and queue the buffer.
> >  	 */
> > -	if (q->start_streaming_called)
> > -		__enqueue_in_driver(vb);
> > +	if (in_fence) {
> > +		WARN_ON(vb->in_fence);
> > +		vb->in_fence = in_fence;
> > +		__vb2_buffer_get(vb);
> > +		ret = dma_fence_add_callback(in_fence, &vb->fence_cb,
> > +					     vb2_qbuf_fence_cb);
> > +		/* is the fence signaled? */
> > +		if (ret == -ENOENT) {
> > +			if (in_fence->error)
> > +				/* error-signaled fence, reject this buffer */
> > +				goto err_release;
> > +			dma_fence_put(in_fence);
> > +			vb->in_fence = NULL;
> > +			__vb2_buffer_put(vb);
> > +		} else if (ret) {
> > +			goto err_release;
> > +		}
> > +	}
> >  
> > -	/* Fill buffer information for the userspace */
> > -	if (pb)
> > -		call_void_bufop(q, fill_user_buffer, vb, pb);
> > +	/*
> > +	 * If already streaming and there is no fence to wait on
> > +	 * give the buffer to driver for processing.
> > +	 */
> > +	if (q->start_streaming_called) {
> > +		struct vb2_buffer *b;
> > +
> > +		list_for_each_entry(b, &q->queued_list, queued_entry) {
> > +			if (b->state != VB2_BUF_STATE_QUEUED)
> 
> b->state == VB2_BUF_STATE_ERROR
> 
> > +				continue;
> > +			if (b->in_fence && dma_fence_get_status(b->in_fence) == 0)
> > +				break;
> > +			__enqueue_in_driver(b);
> > +		}
> > +	}
> >  
> >  	/*
> >  	 * If streamon has been called, and we haven't yet called
> > @@ -1465,14 +1594,32 @@ int vb2_core_qbuf(struct vb2_queue *q, unsigned int index, void *pb)
> >  	 * then we can finally call start_streaming().
> >  	 */
> >  	if (q->streaming && !q->start_streaming_called &&
> > -	    q->queued_count >= q->min_buffers_needed) {
> > +	    __get_num_ready_buffers(q) >= q->min_buffers_needed) {
> >  		ret = vb2_start_streaming(q);
> >  		if (ret)
> > -			return ret;
> > +			goto err_release;
> >  	}
> >  
> > +	/* Fill buffer information for userspace */
> > +	if (pb)
> > +		call_void_bufop(q, fill_user_buffer, vb, pb);
> > +
> >  	dprintk(2, "qbuf of buffer %d succeeded\n", vb->index);
> >  	return 0;
> > +
> > +err_release:
> > +	/* Fill buffer information for userspace */
> > +	if (pb)
> > +		call_void_bufop(q, fill_user_buffer, vb, pb);
> > +
> > +	if (in_fence) {
> > +		dma_fence_put(in_fence);
> > +		vb->in_fence = NULL;
> > +		__vb2_buffer_put(vb);
> > +	}
> > +
> > +	return ret;
> > +
> >  }
> >  EXPORT_SYMBOL_GPL(vb2_core_qbuf);
> >  
> > @@ -1615,7 +1762,12 @@ static void __vb2_dqbuf(struct vb2_buffer *vb)
> >  		return;
> >  
> >  	vb->state = VB2_BUF_STATE_DEQUEUED;
> > -
> > +	if (vb->in_fence) {
> > +		if (dma_fence_remove_callback(vb->in_fence, &vb->fence_cb))
> > +			__vb2_buffer_put(vb);
> > +		dma_fence_put(vb->in_fence);
> > +		vb->in_fence = NULL;
> > +	}
> >  	/* unmap DMABUF buffer */
> >  	if (q->memory == VB2_MEMORY_DMABUF)
> >  		for (i = 0; i < vb->num_planes; ++i) {
> > @@ -1653,7 +1805,7 @@ int vb2_core_dqbuf(struct vb2_queue *q, unsigned int *pindex, void *pb,
> >  	if (pindex)
> >  		*pindex = vb->index;
> >  
> > -	/* Fill buffer information for the userspace */
> > +	/* Fill buffer information for userspace */
> >  	if (pb)
> >  		call_void_bufop(q, fill_user_buffer, vb, pb);
> >  
> > @@ -1700,8 +1852,8 @@ static void __vb2_queue_cancel(struct vb2_queue *q)
> >  	if (WARN_ON(atomic_read(&q->owned_by_drv_count))) {
> >  		for (i = 0; i < q->num_buffers; ++i)
> >  			if (q->bufs[i]->state == VB2_BUF_STATE_ACTIVE) {
> > -				pr_warn("driver bug: stop_streaming operation is leaving buf %p in active state\n",
> > -					q->bufs[i]);
> > +				pr_warn("driver bug: stop_streaming operation is leaving buf[%d] 0x%p in active
> > state\n",
> > +					q->bufs[i]->index, q->bufs[i]);
> >  				vb2_buffer_done(q->bufs[i], VB2_BUF_STATE_ERROR);
> >  			}
> 
> Shouldn't any pending fences be canceled here?
> 

No, we don't have to flush -- that's the reason of the refcount :)
The qbuf_work won't do anything if all the buffers are returned
by the driver (with error or done state), and if !streaming.

Also, note that's why qbuf_work checks for the queued state, and not
for the error state.

> I feel uncomfortable with the refcounting of buffers, I'd rather that when we
> cancel the queue all fences for buffers are removed/canceled/whatever.
> 
> Is there any reason for refcounting if we cancel all pending fences here?
> 
> Note that besides canceling fences you also need to cancel/flush __qbuf_work.
> 
> 

Like I said above, I'm trying to avoid cancel/flushing the workqueue.
Currently, I believe it works fine without any flushing, provided we refcount
the buffers.

The problem with cancelling the workqueue, is that you need to unlock the queue
lock, to avoid a deadlock. It seemed to me that having a refcount is more natural.

Thoughts?
