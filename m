Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qt0-f193.google.com ([209.85.216.193]:33773 "EHLO
        mail-qt0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752233AbdGCSQc (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 3 Jul 2017 14:16:32 -0400
Received: by mail-qt0-f193.google.com with SMTP id c20so24351955qte.0
        for <linux-media@vger.kernel.org>; Mon, 03 Jul 2017 11:16:32 -0700 (PDT)
Date: Mon, 3 Jul 2017 15:16:27 -0300
From: Gustavo Padovan <gustavo@padovan.org>
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: linux-media@vger.kernel.org, Hans Verkuil <hverkuil@xs4all.nl>,
        Javier Martinez Canillas <javier@osg.samsung.com>,
        Shuah Khan <shuahkh@osg.samsung.com>,
        Gustavo Padovan <gustavo.padovan@collabora.com>
Subject: Re: [PATCH 03/12] [media] vb2: add in-fence support to QBUF
Message-ID: <20170703181627.GA3337@jade>
References: <20170616073915.5027-1-gustavo@padovan.org>
 <20170616073915.5027-4-gustavo@padovan.org>
 <20170630085354.2a76bb4a@vento.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170630085354.2a76bb4a@vento.lan>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

2017-06-30 Mauro Carvalho Chehab <mchehab@osg.samsung.com>:

> Em Fri, 16 Jun 2017 16:39:06 +0900
> Gustavo Padovan <gustavo@padovan.org> escreveu:
> 
> > From: Gustavo Padovan <gustavo.padovan@collabora.com>
> > 
> > Receive in-fence from userspace and add support for waiting on them
> > before queueing the buffer to the driver. Buffers are only queued
> > to the driver once they are ready. A buffer is ready when its
> > in-fence signals.
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
> >  drivers/media/Kconfig                    |  1 +
> >  drivers/media/v4l2-core/videobuf2-core.c | 97 +++++++++++++++++++++++++-------
> >  drivers/media/v4l2-core/videobuf2-v4l2.c | 15 ++++-
> >  include/media/videobuf2-core.h           |  7 ++-
> >  4 files changed, 99 insertions(+), 21 deletions(-)
> > 
> > diff --git a/drivers/media/Kconfig b/drivers/media/Kconfig
> > index 55d9c2b..3cd1d3d 100644
> > --- a/drivers/media/Kconfig
> > +++ b/drivers/media/Kconfig
> > @@ -11,6 +11,7 @@ config CEC_NOTIFIER
> >  menuconfig MEDIA_SUPPORT
> >  	tristate "Multimedia support"
> >  	depends on HAS_IOMEM
> > +	select SYNC_FILE
> >  	help
> >  	  If you want to use Webcams, Video grabber devices and/or TV devices
> >  	  enable this option and other options below.
> > diff --git a/drivers/media/v4l2-core/videobuf2-core.c b/drivers/media/v4l2-core/videobuf2-core.c
> > index ea83126..29aa9d4 100644
> > --- a/drivers/media/v4l2-core/videobuf2-core.c
> > +++ b/drivers/media/v4l2-core/videobuf2-core.c
> > @@ -1279,6 +1279,22 @@ static int __buf_prepare(struct vb2_buffer *vb, const void *pb)
> >  	return 0;
> >  }
> >  
> > +static int __get_num_ready_buffers(struct vb2_queue *q)
> > +{
> > +	struct vb2_buffer *vb;
> > +	int ready_count = 0;
> > +
> > +	/* count num of buffers ready in front of the queued_list */
> > +	list_for_each_entry(vb, &q->queued_list, queued_entry) {
> > +		if (vb->in_fence && !dma_fence_is_signaled(vb->in_fence))
> > +			break;
> > +
> > +		ready_count++;
> 
> Hmm... maybe that's one of the reasons why out of order explicit fences is not
> working. With the current logic, if explicit fences is enabled, this function
> will always return 0 or 1, even if more buffers are ready.
> 
> IMHO, the correct logic here should be, instead:
> 
> 		if (!vb->in_fence || dma_fence_is_signaled(vb->in_fence))
> 			ready_count++;

If we do like you propose then we will be getting the wrong ready_count
and queue buffers unordered (in the next two places this code snipet
appears.

In this function I want to know how many ready buffers are in the front
of the buffer. A buffer will be ready if:

* it has no fence
* it has a fence but it was signaled already

Then we start walking the queue looking for such buffers in order and
stop as soon as we find a buffer that doesn't meet these criteria. Hence
the 'break' command to interrupt the loop. If we don't break we may
queue the next buffer on the queue (if it matches the criteria) without
queueing the current one. So we really need break out from the loop
here.

> 
> > +	}
> > +
> > +	return ready_count;
> > +}
> > +
> >  int vb2_core_prepare_buf(struct vb2_queue *q, unsigned int index, void *pb)
> >  {
> >  	struct vb2_buffer *vb;
> > @@ -1324,8 +1340,15 @@ static int vb2_start_streaming(struct vb2_queue *q)
> >  	 * If any buffers were queued before streamon,
> >  	 * we can now pass them to driver for processing.
> >  	 */
> > -	list_for_each_entry(vb, &q->queued_list, queued_entry)
> > +	list_for_each_entry(vb, &q->queued_list, queued_entry) {
> > +		if (vb->state != VB2_BUF_STATE_QUEUED)
> > +			continue;
> > +
> > +		if (vb->in_fence && !dma_fence_is_signaled(vb->in_fence))
> > +			break;
> > +
> >  		__enqueue_in_driver(vb);
> 
> Same as before, the correct logic here seems to be:
> 
> 		if (!vb->in_fence || dma_fence_is_signaled(vb->in_fence))
> 			__enqueue_in_driver(vb);	
> 
> > +	}
> >  
> >  	/* Tell the driver to start streaming */
> >  	q->start_streaming_called = 1;
> > @@ -1369,33 +1392,55 @@ static int vb2_start_streaming(struct vb2_queue *q)
> >  
> >  static int __vb2_core_qbuf(struct vb2_buffer *vb, struct vb2_queue *q)
> >  {
> > +	struct vb2_buffer *b;
> >  	int ret;
> >  
> >  	/*
> >  	 * If already streaming, give the buffer to driver for processing.
> >  	 * If not, the buffer will be given to driver on next streamon.
> >  	 */
> > -	if (q->start_streaming_called)
> > -		__enqueue_in_driver(vb);
> >  
> > -	/*
> > -	 * If streamon has been called, and we haven't yet called
> > -	 * start_streaming() since not enough buffers were queued, and
> > -	 * we now have reached the minimum number of queued buffers,
> > -	 * then we can finally call start_streaming().
> > -	 */
> > -	if (q->streaming && !q->start_streaming_called &&
> > -	    q->queued_count >= q->min_buffers_needed) {
> > -		ret = vb2_start_streaming(q);
> > -		if (ret)
> > -			return ret;
> > +	if (q->start_streaming_called) {
> > +		list_for_each_entry(b, &q->queued_list, queued_entry) {
> > +			if (b->state != VB2_BUF_STATE_QUEUED)
> > +				continue;
> > +
> > +			if (b->in_fence && !dma_fence_is_signaled(b->in_fence))
> > +				break;
> > +
> > +			__enqueue_in_driver(b);
> 
> Same here:
> 
> 		if (!vb->in_fence || dma_fence_is_signaled(vb->in_fence))
> 			__enqueue_in_driver(vb);	
> 
> 
> There is, however, a behavior change here (even without the above
> proposal.
> 
> Before this patch, if fences is not used (for example, for DVB or
> for some other mechanism at V4L2), the driver would be doing:
> 
> 	if (q->start_streaming_called)
> 		__enqueue_in_driver(vb);
> 
> So, __enqueue_in_driver() would be called just once. Now, after
> the change, it will be doing, instead:
> 
> 	list_for_each_entry(vb, &q->queued_list, queued_entry)
> 		__enqueue_in_driver(vb);
> 
> With can queue several buffers at once.
> 
> I've no idea how this will affect non-fences behavior for V4L2
> and for DVB. More tests are required to check if this badly affect
> drivers, or if it would bring some performance or latency change.

I don't believe it affects the behaviour at all, without fences the
queue will never have more than one buffer in the queue. The queue will
only have more buffers on the queue when fences are used and fences for
the buffers in front of the queue didn't signal yet.

> 
> > +		}
> > +	} else {
> 
> Why did you add an else here? I guess there was a very strong reason
> to not have an else at the original code - just can't remember why, and
> I' too lazy today to dig into VB2 changeset descriptions :-)
> 
> Please don't change the behavior together with a patch that add new
> features as it can cause regressions, and it would be a way harder
> to track if you fold different changes at the same patch.
> 
> If this behavior change is due to some bug, it should be submitted
> in a separate, patch, provided with a very detailed description.
> 
> If otherwise, this is a requiement just for fences, you should first
> test if fences is enabled before changing the behavior.

Rigth. This should have been put in a separated patch, but it is not
changing the behaviour at all. The 'if' above this one was

	if (q->start_streaming_called)


and the 'if' below had a !q->start_streaming_called condition, so it
was a sort of else already.

> 
> > +		/*
> > +		 * If streamon has been called, and we haven't yet called
> > +		 * start_streaming() since not enough buffers were queued, and
> > +		 * we now have reached the minimum number of queued buffers
> > +		 * that are ready, then we can finally call start_streaming().
> > +		 */
> > +		if (q->streaming &&
> > +		    __get_num_ready_buffers(q) >= q->min_buffers_needed) {
> > +			ret = vb2_start_streaming(q);
> > +			if (ret)
> > +				return ret;
> > +		}
> >  	}
> >  
> >  	dprintk(1, "qbuf of buffer %d succeeded\n", vb->index);
> >  	return 0;
> >  }
> >  
> > -int vb2_core_qbuf(struct vb2_queue *q, unsigned int index, void *pb)
> > +static void vb2_qbuf_fence_cb(struct dma_fence *f, struct dma_fence_cb *cb)
> > +{
> > +	struct vb2_buffer *vb = container_of(cb, struct vb2_buffer, fence_cb);
> > +
> > +	dma_fence_put(vb->in_fence);
> > +	vb->in_fence = NULL;
> > +
> > +	__vb2_core_qbuf(vb, vb->vb2_queue);
> > +}
> > +
> > +int vb2_core_qbuf(struct vb2_queue *q, unsigned int index, void *pb,
> > +		  struct dma_fence *fence)
> >  {
> >  	struct vb2_buffer *vb;
> >  	int ret;
> > @@ -1436,6 +1481,11 @@ int vb2_core_qbuf(struct vb2_queue *q, unsigned int index, void *pb)
> >  	if (pb)
> >  		call_void_bufop(q, fill_user_buffer, vb, pb);
> >  
> > +	vb->in_fence = fence;
> > +	if (fence && !dma_fence_add_callback(fence, &vb->fence_cb,
> > +					     vb2_qbuf_fence_cb))
> > +		return 0;
> 
> Maybe we should provide some error or debug log here or a WARN_ON(), if 
> dma_fence_add_callback() fails instead of silently ignore any errors.

This is not an error. If the if succeeds it mean we have installed a
callback for the fence. If not, it means the fence signaled already and
we don't can call __vb2_core_qbuf right away.

> 
> > +
> >  	return __vb2_core_qbuf(vb, q);
> >  }
> >  EXPORT_SYMBOL_GPL(vb2_core_qbuf);
> > @@ -1647,6 +1697,7 @@ EXPORT_SYMBOL_GPL(vb2_core_dqbuf);
> >  static void __vb2_queue_cancel(struct vb2_queue *q)
> >  {
> >  	unsigned int i;
> > +	struct vb2_buffer *vb;
> >  
> >  	/*
> >  	 * Tell driver to stop all transactions and release all queued
> > @@ -1669,6 +1720,14 @@ static void __vb2_queue_cancel(struct vb2_queue *q)
> >  		WARN_ON(atomic_read(&q->owned_by_drv_count));
> >  	}
> >  
> > +	list_for_each_entry(vb, &q->queued_list, queued_entry) {
> > +		if (vb->in_fence) {
> > +			dma_fence_remove_callback(vb->in_fence, &vb->fence_cb);
> > +			dma_fence_put(vb->in_fence);
> > +			vb->in_fence = NULL;
> > +		}
> > +	}
> > +
> >  	q->streaming = 0;
> >  	q->start_streaming_called = 0;
> >  	q->queued_count = 0;
> > @@ -1735,7 +1794,7 @@ int vb2_core_streamon(struct vb2_queue *q, unsigned int type)
> >  	 * Tell driver to start streaming provided sufficient buffers
> >  	 * are available.
> >  	 */
> > -	if (q->queued_count >= q->min_buffers_needed) {
> > +	if (__get_num_ready_buffers(q) >= q->min_buffers_needed) {
> >  		ret = v4l_vb2q_enable_media_source(q);
> >  		if (ret)
> >  			return ret;
> > @@ -2250,7 +2309,7 @@ static int __vb2_init_fileio(struct vb2_queue *q, int read)
> >  		 * Queue all buffers.
> >  		 */
> >  		for (i = 0; i < q->num_buffers; i++) {
> > -			ret = vb2_core_qbuf(q, i, NULL);
> > +			ret = vb2_core_qbuf(q, i, NULL, NULL);
> >  			if (ret)
> >  				goto err_reqbufs;
> >  			fileio->bufs[i].queued = 1;
> > @@ -2429,7 +2488,7 @@ static size_t __vb2_perform_fileio(struct vb2_queue *q, char __user *data, size_
> >  
> >  		if (copy_timestamp)
> >  			b->timestamp = ktime_get_ns();
> > -		ret = vb2_core_qbuf(q, index, NULL);
> > +		ret = vb2_core_qbuf(q, index, NULL, NULL);
> >  		dprintk(5, "vb2_dbuf result: %d\n", ret);
> >  		if (ret)
> >  			return ret;
> > @@ -2532,7 +2591,7 @@ static int vb2_thread(void *data)
> >  		if (copy_timestamp)
> >  			vb->timestamp = ktime_get_ns();;
> >  		if (!threadio->stop)
> > -			ret = vb2_core_qbuf(q, vb->index, NULL);
> > +			ret = vb2_core_qbuf(q, vb->index, NULL, NULL);
> >  		call_void_qop(q, wait_prepare, q);
> >  		if (ret || threadio->stop)
> >  			break;
> > diff --git a/drivers/media/v4l2-core/videobuf2-v4l2.c b/drivers/media/v4l2-core/videobuf2-v4l2.c
> > index 110fb45..e6ad77f 100644
> > --- a/drivers/media/v4l2-core/videobuf2-v4l2.c
> > +++ b/drivers/media/v4l2-core/videobuf2-v4l2.c
> > @@ -23,6 +23,7 @@
> >  #include <linux/sched.h>
> >  #include <linux/freezer.h>
> >  #include <linux/kthread.h>
> > +#include <linux/sync_file.h>
> >  
> >  #include <media/v4l2-dev.h>
> >  #include <media/v4l2-fh.h>
> > @@ -560,6 +561,7 @@ EXPORT_SYMBOL_GPL(vb2_create_bufs);
> >  
> >  int vb2_qbuf(struct vb2_queue *q, struct v4l2_buffer *b)
> >  {
> > +	struct dma_fence *fence = NULL;
> >  	int ret;
> >  
> >  	if (vb2_fileio_is_active(q)) {
> > @@ -568,7 +570,18 @@ int vb2_qbuf(struct vb2_queue *q, struct v4l2_buffer *b)
> >  	}
> >  
> >  	ret = vb2_queue_or_prepare_buf(q, b, "qbuf");
> > -	return ret ? ret : vb2_core_qbuf(q, b->index, b);
> > +	if (ret)
> > +		return ret;
> > +
> > +	if (b->flags & V4L2_BUF_FLAG_IN_FENCE) {
> > +		fence = sync_file_get_fence(b->fence_fd);
> > +		if (!fence) {
> > +			dprintk(1, "failed to get in-fence from fd\n");
> > +			return -EINVAL;
> > +		}
> > +	}
> > +
> > +	return ret ? ret : vb2_core_qbuf(q, b->index, b, fence);
> 
> No need to check for ret again. You could just do:
> 
> 	return vb2_core_qbuf(q, b->index, b, fence);

Sure.

Gustavo
