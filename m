Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qt0-f195.google.com ([209.85.216.195]:39723 "EHLO
        mail-qt0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752789AbdLUUl5 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 21 Dec 2017 15:41:57 -0500
Date: Thu, 21 Dec 2017 18:41:49 -0200
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
Subject: Re: [PATCH v6 4/6] [media] vb2: add in-fence support to QBUF
Message-ID: <20171221204149.GD12003@jade>
References: <20171211182741.29712-1-gustavo@padovan.org>
 <20171211182741.29712-5-gustavo@padovan.org>
 <20171221165756.56ef55b0@vento.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20171221165756.56ef55b0@vento.lan>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

2017-12-21 Mauro Carvalho Chehab <mchehab@osg.samsung.com>:

> Em Mon, 11 Dec 2017 16:27:39 -0200
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
> > If the fence for some buffer fails we do not queue it to the driver,
> > instead we mark it as error and wait until the previous buffer is done
> > to notify userspace of the error. We wait here to deliver the buffers back
> > to userspace in order.
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
> >  drivers/media/v4l2-core/Kconfig          |   1 +
> >  drivers/media/v4l2-core/videobuf2-core.c | 154 +++++++++++++++++++++++++++----
> >  drivers/media/v4l2-core/videobuf2-v4l2.c |  29 +++++-
> >  include/media/videobuf2-core.h           |  14 ++-
> >  4 files changed, 177 insertions(+), 21 deletions(-)
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
> > index a8589d96ef72..520aa3c7d9f0 100644
> > --- a/drivers/media/v4l2-core/videobuf2-core.c
> > +++ b/drivers/media/v4l2-core/videobuf2-core.c
> > @@ -346,6 +346,7 @@ static int __vb2_queue_alloc(struct vb2_queue *q, enum vb2_memory memory,
> >  		vb->index = q->num_buffers + buffer;
> >  		vb->type = q->type;
> >  		vb->memory = memory;
> > +		spin_lock_init(&vb->fence_cb_lock);
> >  		for (plane = 0; plane < num_planes; ++plane) {
> >  			vb->planes[plane].length = plane_sizes[plane];
> >  			vb->planes[plane].min_length = plane_sizes[plane];
> > @@ -928,7 +929,7 @@ void vb2_buffer_done(struct vb2_buffer *vb, enum vb2_buffer_state state)
> >  
> >  	switch (state) {
> >  	case VB2_BUF_STATE_QUEUED:
> > -		return;
> > +		break;
> >  	case VB2_BUF_STATE_REQUEUEING:
> >  		if (q->start_streaming_called)
> >  			__enqueue_in_driver(vb);
> > @@ -938,6 +939,16 @@ void vb2_buffer_done(struct vb2_buffer *vb, enum vb2_buffer_state state)
> >  		wake_up(&q->done_wq);
> >  		break;
> >  	}
> > +
> > +	/*
> > +	 * If the in-fence fails the buffer is not queued to the driver
> > +	 * and we have to wait until the previous buffer is done before
> > +	 * we notify userspace that the buffer with error can be dequeued.
> > +	 * That way we maintain the ordering from userspace point of view.
> > +	 */
> > +	vb = list_next_entry(vb, queued_entry);
> > +	if (vb && vb->state == VB2_BUF_STATE_ERROR)
> > +		vb2_buffer_done(vb, vb->state);
> 
> This is not a comment for this specific hunk itself, but for all
> similar occurrences on patches 4 and 5.

It in related to the this piece, but it seems I need to improve the
quality of the comment.

> 
> I really don't like the idea of unconditionally execute things at the
> core without checking if fences will be used or not. It seems risky, and,
> from my quick tests with dvb_vb2, at least one of such hunks seem
> broken for the case where either the VB2 API-specific interface doesn't
> implement fences or fences is not being used by the userspace application.

Yeah, I'll have this in mind for the next iteration of this patchset.

> 
> I'm also wandering about the performance impacts for those things when
> fences aren't used/implemented at the API-specific interfaces (currently,
> videobuf2-v4l2 and dvb_vb2).

I'm writing a DRM <-> V4L2 tool at the moment to start playing with a
full pipeline and performance.

Gustavo
