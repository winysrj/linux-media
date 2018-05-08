Return-path: <linux-media-owner@vger.kernel.org>
Received: from bhuna.collabora.co.uk ([46.235.227.227]:50306 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752146AbeEHTR3 (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 8 May 2018 15:17:29 -0400
Message-ID: <5541e08b048b932789db1c58438c2a2c2b6da7ce.camel@collabora.com>
Subject: Re: [PATCH v9 11/15] vb2: add in-fence support to QBUF
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
Date: Tue, 08 May 2018 16:16:05 -0300
In-Reply-To: <5fd5d7a9-5b74-fe2a-6148-59b90cabb9e8@xs4all.nl>
References: <20180504200612.8763-1-ezequiel@collabora.com>
         <20180504200612.8763-12-ezequiel@collabora.com>
         <5fd5d7a9-5b74-fe2a-6148-59b90cabb9e8@xs4all.nl>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, 2018-05-07 at 14:07 +0200, Hans Verkuil wrote:
> On 04/05/18 22:06, Ezequiel Garcia wrote:
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
> >  drivers/media/common/videobuf2/videobuf2-core.c | 197 ++++++++++++++++++++----
> >  drivers/media/common/videobuf2/videobuf2-v4l2.c |  34 +++-
> >  drivers/media/dvb-core/dvb_vb2.c                |   2 +-
> >  drivers/media/v4l2-core/Kconfig                 |  33 ++++
> >  include/media/videobuf2-core.h                  |  14 +-
> >  5 files changed, 249 insertions(+), 31 deletions(-)
> > 
> > diff --git a/drivers/media/common/videobuf2/videobuf2-core.c b/drivers/media/common/videobuf2/videobuf2-core.c
> > index 6b8e083893ad..996b99497a98 100644
> > --- a/drivers/media/common/videobuf2/videobuf2-core.c
> > +++ b/drivers/media/common/videobuf2/videobuf2-core.c
> > @@ -352,6 +352,7 @@ static int __vb2_queue_alloc(struct vb2_queue *q, enum vb2_memory memory,
> >  		vb->index = q->num_buffers + buffer;
> >  		vb->type = q->type;
> >  		vb->memory = memory;
> > +		spin_lock_init(&vb->fence_cb_lock);
> >  		for (plane = 0; plane < num_planes; ++plane) {
> >  			vb->planes[plane].length = plane_sizes[plane];
> >  			vb->planes[plane].min_length = plane_sizes[plane];
> > @@ -905,20 +906,12 @@ void *vb2_plane_cookie(struct vb2_buffer *vb, unsigned int plane_no)
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
> >  
> >  #ifdef CONFIG_VIDEO_ADV_DEBUG
> >  	/*
> > @@ -935,6 +928,9 @@ void vb2_buffer_done(struct vb2_buffer *vb, enum vb2_buffer_state state)
> >  		call_void_memop(vb, finish, vb->planes[plane].mem_priv);
> >  
> >  	spin_lock_irqsave(&q->done_lock, flags);
> > +	if (vb->state == VB2_BUF_STATE_ACTIVE)
> > +		atomic_dec(&q->owned_by_drv_count);
> > +
> >  	if (state == VB2_BUF_STATE_QUEUED ||
> >  	    state == VB2_BUF_STATE_REQUEUEING) {
> >  		vb->state = VB2_BUF_STATE_QUEUED;
> > @@ -943,7 +939,7 @@ void vb2_buffer_done(struct vb2_buffer *vb, enum vb2_buffer_state state)
> >  		list_add_tail(&vb->done_entry, &q->done_list);
> >  		vb->state = state;
> >  	}
> > -	atomic_dec(&q->owned_by_drv_count);
> > +
> >  	spin_unlock_irqrestore(&q->done_lock, flags);
> >  
> >  	trace_vb2_buf_done(q, vb);
> > @@ -960,6 +956,36 @@ void vb2_buffer_done(struct vb2_buffer *vb, enum vb2_buffer_state state)
> >  		wake_up(&q->done_wq);
> >  		break;
> >  	}
> > +
> > +}
> > +
> > +void vb2_buffer_done(struct vb2_buffer *vb, enum vb2_buffer_state state)
> > +{
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
> > +	 * Check if there is any buffer with error in the next position of the queue,
> > +	 * buffers whose in-fence signaled with error are not queued to the driver
> > +	 * and kept on the queue until the buffer before them is done, so to not
> > +	 * deliver buffers back to userspace in the wrong order. Here we process
> > +	 * any existing buffers with errors and wake up userspace.
> > +	 */
> > +	for (;;) {
> 
> I think this should test if the list is empty before calling list_next_entry().
> 
> > +		vb = list_next_entry(vb, queued_entry);
> > +		if (!vb || vb->state != VB2_BUF_STATE_ERROR)
> 
> The !vb check makes no sense. list_next_entry won't return NULL if there is no
> next entry, you need to call list_empty() first.
> 

Got it.

> > +			break;
> > +
> > +		vb2_process_buffer_done(vb, VB2_BUF_STATE_ERROR);
> > +        }
> >  }
> >  EXPORT_SYMBOL_GPL(vb2_buffer_done);
> >  
> > @@ -1244,6 +1270,9 @@ static void __enqueue_in_driver(struct vb2_buffer *vb)
> >  {
> >  	struct vb2_queue *q = vb->vb2_queue;
> >  
> > +	if (vb->in_fence && !dma_fence_is_signaled(vb->in_fence))
> > +		return;
> > +
> >  	vb->state = VB2_BUF_STATE_ACTIVE;
> >  	atomic_inc(&q->owned_by_drv_count);
> >  
> > @@ -1295,6 +1324,24 @@ static int __buf_prepare(struct vb2_buffer *vb, const void *pb)
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
> > @@ -1383,9 +1430,43 @@ static int vb2_start_streaming(struct vb2_queue *q)
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
> > +	 * If the fence signals with an error we mark the buffer as such
> > +	 * and avoid using it by setting it to VB2_BUF_STATE_ERROR and
> > +	 * not queueing it to the driver. However we can't notify the error
> > +	 * to userspace right now because, at the time this callback run, QBUF
> > +	 * has returned already.
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
> 
> I'd change this to:
> 
> 	if (q->start_streaming_called &&
> 	    vb->state != VB2_BUF_STATE_ERROR)
> 
> Then you can drop the previous 'if'.
> 

OK.

> > +		__enqueue_in_driver(vb);
> > +	spin_unlock_irqrestore(&vb->fence_cb_lock, flags);
> > +}
> > +
> > +int vb2_core_qbuf(struct vb2_queue *q, unsigned int index, void *pb,
> > +		  struct dma_fence *in_fence)
> >  {
> >  	struct vb2_buffer *vb;
> > +	unsigned long flags;
> >  	int ret;
> >  
> >  	vb = q->bufs[index];
> > @@ -1394,16 +1475,18 @@ int vb2_core_qbuf(struct vb2_queue *q, unsigned int index, void *pb)
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
> > @@ -1414,6 +1497,7 @@ int vb2_core_qbuf(struct vb2_queue *q, unsigned int index, void *pb)
> >  	q->queued_count++;
> >  	q->waiting_for_buffers = false;
> >  	vb->state = VB2_BUF_STATE_QUEUED;
> > +	vb->in_fence = in_fence;
> >  
> >  	if (pb)
> >  		call_void_bufop(q, copy_timestamp, vb, pb);
> > @@ -1421,15 +1505,40 @@ int vb2_core_qbuf(struct vb2_queue *q, unsigned int index, void *pb)
> >  	trace_vb2_qbuf(q, vb);
> >  
> >  	/*
> > -	 * If already streaming, give the buffer to driver for processing.
> > -	 * If not, the buffer will be given to driver on next streamon.
> > +	 * For explicit synchronization: If the fence didn't signal
> > +	 * yet we setup a callback to queue the buffer once the fence
> > +	 * signals and then return successfully. But if the fence
> > +	 * already signaled we lose the reference we held and queue the
> > +	 * buffer to the driver.
> 
> What happens if the fence signaled an error? Is that error returned to userspace?
> (i.e. VIDIOC_QBUF will fail in that case)
> 

Hm, good question. If the fence signals with an error, we won't catch it apparently.
We should fix dma_fence_add_callback to know about signaled vs. error signaled.

> >  	 */
> > -	if (q->start_streaming_called)
> > -		__enqueue_in_driver(vb);
> > +	spin_lock_irqsave(&vb->fence_cb_lock, flags);
> > +	if (vb->in_fence) {
> > +		ret = dma_fence_add_callback(vb->in_fence, &vb->fence_cb,
> > +					     vb2_qbuf_fence_cb);
> > +		/* is the fence signaled? */
> > +		if (ret == -ENOENT) {
> > +			dma_fence_put(vb->in_fence);
> > +			vb->in_fence = NULL;
> > +		} else if (ret) {
> > +			goto unlock;
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
> > +				continue;
> > +			if (b->in_fence)
> > +				break;
> > +			__enqueue_in_driver(b);
> > +		}
> > +	}
> >  
> >  	/*
> >  	 * If streamon has been called, and we haven't yet called
> > @@ -1438,14 +1547,36 @@ int vb2_core_qbuf(struct vb2_queue *q, unsigned int index, void *pb)
> >  	 * then we can finally call start_streaming().
> >  	 */
> >  	if (q->streaming && !q->start_streaming_called &&
> > -	    q->queued_count >= q->min_buffers_needed) {
> > +	    __get_num_ready_buffers(q) >= q->min_buffers_needed) {
> >  		ret = vb2_start_streaming(q);
> >  		if (ret)
> > -			return ret;
> > +			goto unlock;
> >  	}
> >  
> > +	spin_unlock_irqrestore(&vb->fence_cb_lock, flags);
> > +
> > +	/* Fill buffer information for the userspace */
> 
> s/the//
> 
> > +	if (pb)
> > +		call_void_bufop(q, fill_user_buffer, vb, pb);
> > +
> >  	dprintk(2, "qbuf of buffer %d succeeded\n", vb->index);
> >  	return 0;
> > +
> > +unlock:
> > +	spin_unlock_irqrestore(&vb->fence_cb_lock, flags);
> > +
> > +err:
> > +	/* Fill buffer information for the userspace */
> 
> s/the//
> 
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
> > @@ -1656,6 +1787,8 @@ EXPORT_SYMBOL_GPL(vb2_core_dqbuf);
> >  static void __vb2_queue_cancel(struct vb2_queue *q)
> >  {
> >  	unsigned int i;
> > +	struct vb2_buffer *vb;
> > +	unsigned long flags;
> >  
> >  	/*
> >  	 * Tell driver to stop all transactions and release all queued
> > @@ -1686,6 +1819,16 @@ static void __vb2_queue_cancel(struct vb2_queue *q)
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
> > @@ -1756,7 +1899,7 @@ int vb2_core_streamon(struct vb2_queue *q, unsigned int type)
> >  	 * Tell driver to start streaming provided sufficient buffers
> >  	 * are available.
> >  	 */
> > -	if (q->queued_count >= q->min_buffers_needed) {
> > +	if (__get_num_ready_buffers(q) >= q->min_buffers_needed) {
> >  		ret = v4l_vb2q_enable_media_source(q);
> >  		if (ret)
> >  			return ret;
> > @@ -2278,7 +2421,7 @@ static int __vb2_init_fileio(struct vb2_queue *q, int read)
> >  		 * Queue all buffers.
> >  		 */
> >  		for (i = 0; i < q->num_buffers; i++) {
> > -			ret = vb2_core_qbuf(q, i, NULL);
> > +			ret = vb2_core_qbuf(q, i, NULL, NULL);
> >  			if (ret)
> >  				goto err_reqbufs;
> >  			fileio->bufs[i].queued = 1;
> > @@ -2457,7 +2600,7 @@ static size_t __vb2_perform_fileio(struct vb2_queue *q, char __user *data, size_
> >  
> >  		if (copy_timestamp)
> >  			b->timestamp = ktime_get_ns();
> > -		ret = vb2_core_qbuf(q, index, NULL);
> > +		ret = vb2_core_qbuf(q, index, NULL, NULL);
> >  		dprintk(5, "vb2_dbuf result: %d\n", ret);
> >  		if (ret)
> >  			return ret;
> > @@ -2560,7 +2703,7 @@ static int vb2_thread(void *data)
> >  		if (copy_timestamp)
> >  			vb->timestamp = ktime_get_ns();
> >  		if (!threadio->stop)
> > -			ret = vb2_core_qbuf(q, vb->index, NULL);
> > +			ret = vb2_core_qbuf(q, vb->index, NULL, NULL);
> >  		call_void_qop(q, wait_prepare, q);
> >  		if (ret || threadio->stop)
> >  			break;
> > diff --git a/drivers/media/common/videobuf2/videobuf2-v4l2.c b/drivers/media/common/videobuf2/videobuf2-v4l2.c
> > index b1c0fa2b0b88..74d7062e5285 100644
> > --- a/drivers/media/common/videobuf2/videobuf2-v4l2.c
> > +++ b/drivers/media/common/videobuf2/videobuf2-v4l2.c
> > @@ -23,6 +23,7 @@
> >  #include <linux/sched.h>
> >  #include <linux/freezer.h>
> >  #include <linux/kthread.h>
> > +#include <linux/sync_file.h>
> >  
> >  #include <media/v4l2-dev.h>
> >  #include <media/v4l2-fh.h>
> > @@ -178,6 +179,17 @@ static int vb2_queue_or_prepare_buf(struct vb2_queue *q, struct v4l2_buffer *b,
> >  		return -EINVAL;
> >  	}
> >  
> > +	if ((b->fence_fd != 0 && b->fence_fd != -1) &&
> > +	    !(b->flags & V4L2_BUF_FLAG_IN_FENCE)) {
> > +		dprintk(1, "%s: fence_fd set without IN_FENCE flag\n", opname);
> > +		return -EINVAL;
> > +	}
> > +
> > +	if (b->fence_fd < 0 && (b->flags & V4L2_BUF_FLAG_IN_FENCE)) {
> > +		dprintk(1, "%s: IN_FENCE flag set but no fence_fd\n", opname);
> > +		return -EINVAL;
> > +	}
> > +
> >  	return __verify_planes_array(q->bufs[b->index], b);
> >  }
> >  
> > @@ -203,9 +215,14 @@ static void __fill_v4l2_buffer(struct vb2_buffer *vb, void *pb)
> >  	b->timestamp = ns_to_timeval(vb->timestamp);
> >  	b->timecode = vbuf->timecode;
> >  	b->sequence = vbuf->sequence;
> > -	b->fence_fd = 0;
> >  	b->reserved = 0;
> >  
> > +	b->fence_fd = 0;
> > +	if (vb->in_fence)
> > +		b->flags |= V4L2_BUF_FLAG_IN_FENCE;
> > +	else
> > +		b->flags &= ~V4L2_BUF_FLAG_IN_FENCE;
> > +
> >  	if (q->is_multiplanar) {
> >  		/*
> >  		 * Fill in plane-related data if userspace provided an array
> > @@ -562,6 +579,7 @@ EXPORT_SYMBOL_GPL(vb2_create_bufs);
> >  
> >  int vb2_qbuf(struct vb2_queue *q, struct v4l2_buffer *b)
> >  {
> > +	struct dma_fence *in_fence = NULL;
> >  	int ret;
> >  
> >  	if (vb2_fileio_is_active(q)) {
> > @@ -570,7 +588,19 @@ int vb2_qbuf(struct vb2_queue *q, struct v4l2_buffer *b)
> >  	}
> >  
> >  	ret = vb2_queue_or_prepare_buf(q, b, "qbuf");
> > -	return ret ? ret : vb2_core_qbuf(q, b->index, b);
> > +	if (ret)
> > +		return ret;
> > +
> > +	if (b->flags & V4L2_BUF_FLAG_IN_FENCE) {
> > +		in_fence = sync_file_get_fence(b->fence_fd);
> > +		if (!in_fence) {
> > +			dprintk(1, "failed to get in-fence from fd %d\n",
> > +				b->fence_fd);
> > +			return -EINVAL;
> > +		}
> > +	}
> > +
> > +	return vb2_core_qbuf(q, b->index, b, in_fence);
> >  }
> >  EXPORT_SYMBOL_GPL(vb2_qbuf);
> >  
> > diff --git a/drivers/media/dvb-core/dvb_vb2.c b/drivers/media/dvb-core/dvb_vb2.c
> > index b811adf88afa..7da53f10db1a 100644
> > --- a/drivers/media/dvb-core/dvb_vb2.c
> > +++ b/drivers/media/dvb-core/dvb_vb2.c
> > @@ -385,7 +385,7 @@ int dvb_vb2_qbuf(struct dvb_vb2_ctx *ctx, struct dmx_buffer *b)
> >  {
> >  	int ret;
> >  
> > -	ret = vb2_core_qbuf(&ctx->vb_q, b->index, b);
> > +	ret = vb2_core_qbuf(&ctx->vb_q, b->index, b, NULL);
> >  	if (ret) {
> >  		dprintk(1, "[%s] index=%d errno=%d\n", ctx->name,
> >  			b->index, ret);
> > diff --git a/drivers/media/v4l2-core/Kconfig b/drivers/media/v4l2-core/Kconfig
> > index 8e37e7c5e0f7..79dfb5dfd1fc 100644
> > --- a/drivers/media/v4l2-core/Kconfig
> > +++ b/drivers/media/v4l2-core/Kconfig
> > @@ -80,3 +80,36 @@ config VIDEOBUF_DMA_CONTIG
> >  config VIDEOBUF_DVB
> >  	tristate
> >  	select VIDEOBUF_GEN
> > +
> > +# Used by drivers that need Videobuf2 modules
> > +config VIDEOBUF2_CORE
> > +	select DMA_SHARED_BUFFER
> > +	select SYNC_FILE
> > +	tristate
> > +
> > +config VIDEOBUF2_MEMOPS
> > +	tristate
> > +	select FRAME_VECTOR
> > +
> > +config VIDEOBUF2_DMA_CONTIG
> > +	tristate
> > +	depends on HAS_DMA
> > +	select VIDEOBUF2_CORE
> > +	select VIDEOBUF2_MEMOPS
> > +	select DMA_SHARED_BUFFER
> > +
> > +config VIDEOBUF2_VMALLOC
> > +	tristate
> > +	select VIDEOBUF2_CORE
> > +	select VIDEOBUF2_MEMOPS
> > +	select DMA_SHARED_BUFFER
> > +
> > +config VIDEOBUF2_DMA_SG
> > +	tristate
> > +	depends on HAS_DMA
> > +	select VIDEOBUF2_CORE
> > +	select VIDEOBUF2_MEMOPS
> > +
> > +config VIDEOBUF2_DVB
> > +	tristate
> > +	select VIDEOBUF2_CORE
> 
> This chunk doesn't really belong here. Should be a separate patch with an explanation
> why.
> 

OK.

> > diff --git a/include/media/videobuf2-core.h b/include/media/videobuf2-core.h
> > index 364e4cb41b10..28ce8f66882e 100644
> > --- a/include/media/videobuf2-core.h
> > +++ b/include/media/videobuf2-core.h
> > @@ -17,6 +17,7 @@
> >  #include <linux/poll.h>
> >  #include <linux/dma-buf.h>
> >  #include <linux/bitops.h>
> > +#include <linux/dma-fence.h>
> >  
> >  #define VB2_MAX_FRAME	(32)
> >  #define VB2_MAX_PLANES	(8)
> > @@ -255,12 +256,21 @@ struct vb2_buffer {
> >  	 * done_entry:		entry on the list that stores all buffers ready
> >  	 *			to be dequeued to userspace
> >  	 * vb2_plane:		per-plane information; do not change
> > +	 * in_fence:		fence received from vb2 client to wait on before
> > +	 *			using the buffer (queueing to the driver)
> > +	 * fence_cb:		fence callback information
> > +	 * fence_cb_lock:	protect callback signal/remove
> >  	 */
> >  	enum vb2_buffer_state	state;
> >  
> >  	struct vb2_plane	planes[VB2_MAX_PLANES];
> >  	struct list_head	queued_entry;
> >  	struct list_head	done_entry;
> > +
> > +	struct dma_fence	*in_fence;
> > +	struct dma_fence_cb	fence_cb;
> > +	spinlock_t              fence_cb_lock;
> > +
> 
> So for the _MPLANE formats this is one fence for all planes. Which makes sense, but how
> does drm handle that? Also one fence for all planes?
> 

In drm we have one fence per plane, where as on this proposal
we support one fence per vb2_buffer (one for all planes).

I guess this means we only support single-planar formats por now.
Multi-planar support can be added as a follow-up patch.

> I think there should be a comment about this somewhere.
> 

Agreed.

> >  #ifdef CONFIG_VIDEO_ADV_DEBUG
> >  	/*
> >  	 * Counters for how often these buffer-related ops are
> > @@ -773,6 +783,7 @@ int vb2_core_prepare_buf(struct vb2_queue *q, unsigned int index, void *pb);
> >   * @index:	id number of the buffer
> >   * @pb:		buffer structure passed from userspace to
> >   *		v4l2_ioctl_ops->vidioc_qbuf handler in driver
> > + * @in_fence:	in-fence to wait on before queueing the buffer
> >   *
> >   * Videobuf2 core helper to implement VIDIOC_QBUF() operation. It is called
> >   * internally by VB2 by an API-specific handler, like ``videobuf2-v4l2.h``.
> > @@ -787,7 +798,8 @@ int vb2_core_prepare_buf(struct vb2_queue *q, unsigned int index, void *pb);
> >   *
> >   * Return: returns zero on success; an error code otherwise.
> >   */
> > -int vb2_core_qbuf(struct vb2_queue *q, unsigned int index, void *pb);
> > +int vb2_core_qbuf(struct vb2_queue *q, unsigned int index, void *pb,
> > +		  struct dma_fence *in_fence);
> >  
> >  /**
> >   * vb2_core_dqbuf() - Dequeue a buffer to the userspace
> > 
> 
> Regards,
> 
> 	Hans
