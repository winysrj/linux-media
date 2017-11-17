Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qt0-f196.google.com ([209.85.216.196]:32884 "EHLO
        mail-qt0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751418AbdKQRuK (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 17 Nov 2017 12:50:10 -0500
Date: Fri, 17 Nov 2017 15:50:03 -0200
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
Subject: Re: [RFC v5 07/11] [media] vb2: add in-fence support to QBUF
Message-ID: <20171117175003.GL19033@jade>
References: <20171115171057.17340-1-gustavo@padovan.org>
 <20171115171057.17340-8-gustavo@padovan.org>
 <185d8656-dacd-5e94-d93a-979a1acb2f66@xs4all.nl>
 <20171117174021.GK19033@jade>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20171117174021.GK19033@jade>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

2017-11-17 Gustavo Padovan <gustavo@padovan.org>:

> 2017-11-17 Hans Verkuil <hverkuil@xs4all.nl>:
> 
> > On 15/11/17 18:10, Gustavo Padovan wrote:
> > > From: Gustavo Padovan <gustavo.padovan@collabora.com>
> > > 
> > > Receive in-fence from userspace and add support for waiting on them
> > > before queueing the buffer to the driver. Buffers can't be queued to the
> > > driver before its fences signal. And a buffer can't be queue to the driver
> > > out of the order they were queued from userspace. That means that even if
> > > it fence signal it must wait all other buffers, ahead of it in the queue,
> > > to signal first.
> > > 
> > > To make that possible we use fence_array to keep that ordering. Basically
> > > we create a fence_array that contains both the current fence and the fence
> > > from the previous buffer (which might be a fence array as well). The base
> > > fence class for the fence_array becomes the new buffer fence, waiting on
> > > that one guarantees that it won't be queued out of order.
> > > 
> > > v6:
> > > 	- With fences always keep the order userspace queues the buffers.
> > > 	- Protect in_fence manipulation with a lock (Brian Starkey)
> > > 	- check if fences have the same context before adding a fence array
> > > 	- Fix last_fence ref unbalance in __set_in_fence() (Brian Starkey)
> > > 	- Clean up fence if __set_in_fence() fails (Brian Starkey)
> > > 	- treat -EINVAL from dma_fence_add_callback() (Brian Starkey)
> > > 
> > > v5:	- use fence_array to keep buffers ordered in vb2 core when
> > > 	needed (Brian Starkey)
> > > 	- keep backward compat on the reserved2 field (Brian Starkey)
> > > 	- protect fence callback removal with lock (Brian Starkey)
> > > 
> > > v4:
> > > 	- Add a comment about dma_fence_add_callback() not returning a
> > > 	error (Hans)
> > > 	- Call dma_fence_put(vb->in_fence) if fence signaled (Hans)
> > > 	- select SYNC_FILE under config VIDEOBUF2_CORE (Hans)
> > > 	- Move dma_fence_is_signaled() check to __enqueue_in_driver() (Hans)
> > > 	- Remove list_for_each_entry() in __vb2_core_qbuf() (Hans)
> > > 	-  Remove if (vb->state != VB2_BUF_STATE_QUEUED) from
> > > 	vb2_start_streaming() (Hans)
> > > 	- set IN_FENCE flags on __fill_v4l2_buffer (Hans)
> > > 	- Queue buffers to the driver as soon as they are ready (Hans)
> > > 	- call fill_user_buffer() after queuing the buffer (Hans)
> > > 	- add err: label to clean up fence
> > > 	- add dma_fence_wait() before calling vb2_start_streaming()
> > > 
> > > v3:	- document fence parameter
> > > 	- remove ternary if at vb2_qbuf() return (Mauro)
> > > 	- do not change if conditions behaviour (Mauro)
> > > 
> > > v2:
> > > 	- fix vb2_queue_or_prepare_buf() ret check
> > > 	- remove check for VB2_MEMORY_DMABUF only (Javier)
> > > 	- check num of ready buffers to start streaming
> > > 	- when queueing, start from the first ready buffer
> > > 	- handle queue cancel
> > > 
> > > Signed-off-by: Gustavo Padovan <gustavo.padovan@collabora.com>
> > > ---
> > >  drivers/media/v4l2-core/Kconfig          |   1 +
> > >  drivers/media/v4l2-core/videobuf2-core.c | 202 ++++++++++++++++++++++++++++---
> > >  drivers/media/v4l2-core/videobuf2-v4l2.c |  29 ++++-
> > >  include/media/videobuf2-core.h           |  17 ++-
> > >  4 files changed, 231 insertions(+), 18 deletions(-)
> > > 
> > > diff --git a/drivers/media/v4l2-core/Kconfig b/drivers/media/v4l2-core/Kconfig
> > > index a35c33686abf..3f988c407c80 100644
> > > --- a/drivers/media/v4l2-core/Kconfig
> > > +++ b/drivers/media/v4l2-core/Kconfig
> > > @@ -83,6 +83,7 @@ config VIDEOBUF_DVB
> > >  # Used by drivers that need Videobuf2 modules
> > >  config VIDEOBUF2_CORE
> > >  	select DMA_SHARED_BUFFER
> > > +	select SYNC_FILE
> > >  	tristate
> > >  
> > >  config VIDEOBUF2_MEMOPS
> > > diff --git a/drivers/media/v4l2-core/videobuf2-core.c b/drivers/media/v4l2-core/videobuf2-core.c
> > > index 60f8b582396a..26de4c80717d 100644
> > > --- a/drivers/media/v4l2-core/videobuf2-core.c
> > > +++ b/drivers/media/v4l2-core/videobuf2-core.c
> > > @@ -23,6 +23,7 @@
> > >  #include <linux/sched.h>
> > >  #include <linux/freezer.h>
> > >  #include <linux/kthread.h>
> > > +#include <linux/dma-fence-array.h>
> > >  
> > >  #include <media/videobuf2-core.h>
> > >  #include <media/v4l2-mc.h>
> > > @@ -346,6 +347,7 @@ static int __vb2_queue_alloc(struct vb2_queue *q, enum vb2_memory memory,
> > >  		vb->index = q->num_buffers + buffer;
> > >  		vb->type = q->type;
> > >  		vb->memory = memory;
> > > +		spin_lock_init(&vb->fence_cb_lock);
> > >  		for (plane = 0; plane < num_planes; ++plane) {
> > >  			vb->planes[plane].length = plane_sizes[plane];
> > >  			vb->planes[plane].min_length = plane_sizes[plane];
> > > @@ -1222,6 +1224,9 @@ static void __enqueue_in_driver(struct vb2_buffer *vb)
> > >  {
> > >  	struct vb2_queue *q = vb->vb2_queue;
> > >  
> > > +	if (vb->in_fence && !dma_fence_is_signaled(vb->in_fence))
> > > +		return;
> > > +
> > >  	vb->state = VB2_BUF_STATE_ACTIVE;
> > >  	atomic_inc(&q->owned_by_drv_count);
> > >  
> > > @@ -1273,6 +1278,23 @@ static int __buf_prepare(struct vb2_buffer *vb, const void *pb)
> > >  	return 0;
> > >  }
> > >  
> > > +static int __get_num_ready_buffers(struct vb2_queue *q)
> > > +{
> > > +	struct vb2_buffer *vb;
> > > +	int ready_count = 0;
> > > +	unsigned long flags;
> > > +
> > > +	/* count num of buffers ready in front of the queued_list */
> > > +	list_for_each_entry(vb, &q->queued_list, queued_entry) {
> > > +		spin_lock_irqsave(&vb->fence_cb_lock, flags);
> > > +		if (!vb->in_fence || dma_fence_is_signaled(vb->in_fence))
> > > +			ready_count++;
> > 
> > Shouldn't there be a:
> > 
> > 		else
> > 			break;
> > 
> > here? You're counting the number of available (i.e. no fence or signaled
> > fence) buffers at the start of the queued buffer list.
> 
> Sure.

Actually, by using the fence_array machinery the fence won't be
signaling out of order, so the 'else break' isn't strictly necessary
here.

Gustavo
