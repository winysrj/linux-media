Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([213.167.242.64]:44418 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726378AbeG3WPR (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 30 Jul 2018 18:15:17 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Kieran Bingham <kieran.bingham@ideasonboard.com>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Olivier BRAUN <olivier.braun@stereolabs.com>,
        Troy Kisky <troy.kisky@boundarydevices.com>
Subject: Re: [RFT PATCH v3 5/6] uvcvideo: queue: Support asynchronous buffer handling
Date: Mon, 30 Jul 2018 23:39:11 +0300
Message-ID: <3798015.Xi7JQnpzAg@avalon>
In-Reply-To: <2758747.xKSIVS8Vp6@avalon>
References: <cover.30aaad9a6abac5e92d4a1a0e6634909d97cc54d8.1515748369.git-series.kieran.bingham@ideasonboard.com> <f72afd5e873791800bc9d5aba52c2a1952b6b770.1515748369.git-series.kieran.bingham@ideasonboard.com> <2758747.xKSIVS8Vp6@avalon>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Kieran

I think your v4 doesn't take the review comments below into account.

On Wednesday, 17 January 2018 01:45:33 EEST Laurent Pinchart wrote:
> On Friday, 12 January 2018 11:19:26 EET Kieran Bingham wrote:
> > The buffer queue interface currently operates sequentially, processing
> > buffers after they have fully completed.
> > 
> > In preparation for supporting parallel tasks operating on the buffers,
> > we will need to support buffers being processed on multiple CPUs.
> > 
> > Adapt the uvc_queue_next_buffer() such that a reference count tracks the
> > active use of the buffer, returning the buffer to the VB2 stack at
> > completion.
> > 
> > Signed-off-by: Kieran Bingham <kieran.bingham@ideasonboard.com>
> > ---
> > 
> >  drivers/media/usb/uvc/uvc_queue.c | 61 ++++++++++++++++++++++++++------
> >  drivers/media/usb/uvc/uvcvideo.h  |  4 ++-
> >  2 files changed, 54 insertions(+), 11 deletions(-)
> > 
> > diff --git a/drivers/media/usb/uvc/uvc_queue.c
> > b/drivers/media/usb/uvc/uvc_queue.c index ddac4d89a291..5a9987e547d3
> > 100644
> > --- a/drivers/media/usb/uvc/uvc_queue.c
> > +++ b/drivers/media/usb/uvc/uvc_queue.c
> > @@ -131,6 +131,7 @@ static void uvc_buffer_queue(struct vb2_buffer *vb)
> > 
> >  	spin_lock_irqsave(&queue->irqlock, flags);
> >  	if (likely(!(queue->flags & UVC_QUEUE_DISCONNECTED))) {
> > 
> > +		kref_init(&buf->ref);
> > 
> >  		list_add_tail(&buf->queue, &queue->irqqueue);
> >  	
> >  	} else {
> >  	
> >  		/* If the device is disconnected return the buffer to userspace
> > 
> > @@ -424,28 +425,66 @@ struct uvc_buffer
> > *uvc_queue_get_current_buffer(struct uvc_video_queue *queue) return
> > nextbuf;
> > 
> >  }
> > 
> > -struct uvc_buffer *uvc_queue_next_buffer(struct uvc_video_queue *queue,
> > +/*
> > + * uvc_queue_requeue: Requeue a buffer on our internal irqqueue
> > + *
> > + * Reuse a buffer through our internal queue without the need to
> > 'prepare'
> > + * The buffer will be returned to userspace through the uvc_buffer_queue
> > call if
> > + * the device has been disconnected

Additionally, periods are messing at the end of sentences.

> > + */
> > +static void uvc_queue_requeue(struct uvc_video_queue *queue,
> > 
> >  		struct uvc_buffer *buf)
> >  
> >  {
> > 
> > -	struct uvc_buffer *nextbuf;
> > -	unsigned long flags;
> > +	buf->error = 0;
> > +	buf->state = UVC_BUF_STATE_QUEUED;
> > +	buf->bytesused = 0;
> > +	vb2_set_plane_payload(&buf->buf.vb2_buf, 0, 0);
> > +
> > +	uvc_buffer_queue(&buf->buf.vb2_buf);
> > +}
> 
> You could have inlined this in uvc_queue_buffer_complete(), but the above
> documentation is useful, so I'm fine if you prefer keeping it as a separate
> function. Maybe you could call it uvc_queue_buffer_requeue() to be
> consistent with the other functions ?
> 
> > +static void uvc_queue_buffer_complete(struct kref *ref)
> > +{
> > +	struct uvc_buffer *buf = container_of(ref, struct uvc_buffer, ref);
> > +	struct vb2_buffer *vb = &buf->buf.vb2_buf;
> > +	struct uvc_video_queue *queue = vb2_get_drv_priv(vb->vb2_queue);
> > 
> >  	if ((queue->flags & UVC_QUEUE_DROP_CORRUPTED) && buf->error) {
> > 
> > -		buf->error = 0;
> > -		buf->state = UVC_BUF_STATE_QUEUED;
> > -		buf->bytesused = 0;
> > -		vb2_set_plane_payload(&buf->buf.vb2_buf, 0, 0);
> > -		return buf;
> > +		uvc_queue_requeue(queue, buf);
> > +		return;
> 
> This changes the behaviour of the driver. Currently when an erroneous buffer
> is encountered, it will be immediately reused. With this patch applied it
> will be pushed to the back of the queue for later reuse. This will result
> in buffers being reordered, possibly causing issues later when we'll
> implement fences support (or possibly even today).
> 
> I think the whole drop corrupted buffers mechanism was a bad idea in the
> first place and I'd like to remove it at some point, buffers in the error
> state should be handled by applications. However, until that's done, I
> wonder whether it would be possible to keep the current order. I
> unfortunately don't see an easy option to do so at the moment, but maybe
> you would. Otherwise I suppose we'll have to leave it as is.
> 
> I'm tempted to flip the driver to not drop corrupted buffers by default.
> I've done so on my computer, I'll see if I run into any issue. It could be
> useful if you could set the nodrop parameter to 1 on your systems too when
> performing tests.
> 
> >  	}
> > 
> > +	buf->state = buf->error ? UVC_BUF_STATE_ERROR : UVC_BUF_STATE_DONE;
> > +	vb2_set_plane_payload(&buf->buf.vb2_buf, 0, buf->bytesused);
> > +	vb2_buffer_done(&buf->buf.vb2_buf, VB2_BUF_STATE_DONE);
> > +}
> > +
> > +/*
> > + * Release a reference on the buffer. Complete the buffer when the last
> > + * reference is released
> > + */
> > +void uvc_queue_buffer_release(struct uvc_buffer *buf)
> > +{
> > +	kref_put(&buf->ref, uvc_queue_buffer_complete);
> > +}
> > +
> > +/*
> > + * Remove this buffer from the queue. Lifetime will persist while async
> > actions
> > + * are still running (if any), and uvc_queue_buffer_release will give the
> > buffer
> > + * back to VB2 when all users have completed.
> > + */
> > +struct uvc_buffer *uvc_queue_next_buffer(struct uvc_video_queue *queue,
> > +		struct uvc_buffer *buf)
> > +{
> > +	struct uvc_buffer *nextbuf;
> > +	unsigned long flags;
> > +
> > 
> >  	spin_lock_irqsave(&queue->irqlock, flags);
> >  	list_del(&buf->queue);
> >  	nextbuf = __uvc_queue_get_current_buffer(queue);
> >  	spin_unlock_irqrestore(&queue->irqlock, flags);
> > 
> > -	buf->state = buf->error ? UVC_BUF_STATE_ERROR : UVC_BUF_STATE_DONE;
> > -	vb2_set_plane_payload(&buf->buf.vb2_buf, 0, buf->bytesused);
> > -	vb2_buffer_done(&buf->buf.vb2_buf, VB2_BUF_STATE_DONE);
> > +	uvc_queue_buffer_release(buf);
> > 
> >  	return nextbuf;
> >  
> >  }
> > 
> > diff --git a/drivers/media/usb/uvc/uvcvideo.h
> > b/drivers/media/usb/uvc/uvcvideo.h index 5caa1f4de3cb..6a18dbfc3e5b 100644
> > --- a/drivers/media/usb/uvc/uvcvideo.h
> > +++ b/drivers/media/usb/uvc/uvcvideo.h
> > @@ -404,6 +404,9 @@ struct uvc_buffer {
> > 
> >  	unsigned int bytesused;
> >  	
> >  	u32 pts;
> > 
> > +
> > +	/* asynchronous buffer handling */
> 
> Please capitalize the first word to match other comments in the driver.
> 
> > +	struct kref ref;
> > 
> >  };
> >  
> >  #define UVC_QUEUE_DISCONNECTED		(1 << 0)
> > 
> > @@ -696,6 +699,7 @@ extern struct uvc_buffer *
> > 
> >  		uvc_queue_get_current_buffer(struct uvc_video_queue *queue);
> >  
> >  extern struct uvc_buffer *uvc_queue_next_buffer(struct uvc_video_queue
> > 
> > *queue, struct uvc_buffer *buf);
> > +extern void uvc_queue_buffer_release(struct uvc_buffer *buf);
> 
> No need for the extern keyboard. I'll submit a patch to drop it for all
> functions.
> 
> >  extern int uvc_queue_mmap(struct uvc_video_queue *queue,
> >  
> >  		struct vm_area_struct *vma);
> >  
> >  extern unsigned int uvc_queue_poll(struct uvc_video_queue *queue,

-- 
Regards,

Laurent Pinchart
