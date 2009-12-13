Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.irobotique.be ([92.243.18.41]:32815 "HELO
	perceval.irobotique.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752536AbZLMQGA (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 13 Dec 2009 11:06:00 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: "lcostantino@gmail.com" <lcostantino@gmail.com>
Subject: Re: uvcvideo kernel panic when using libv4l
Date: Sun, 13 Dec 2009 17:07:50 +0100
Cc: Pablo Baena <pbaena@gmail.com>, linux-media@vger.kernel.org,
	Hans de Goede <hdegoede@redhat.com>
References: <36be2c7a0912070918h23cee33bia26c85b13d242ca9@mail.gmail.com> <200912101646.26333.laurent.pinchart@ideasonboard.com> <alpine.DEB.2.00.0912130447360.13585@localhost.localdomain>
In-Reply-To: <alpine.DEB.2.00.0912130447360.13585@localhost.localdomain>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <200912131707.50289.laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Costantino,

thanks for investigating the problem.

On Sunday 13 December 2009 08:48:24 lcostantino@gmail.com wrote:
> There seems to be a 'kind of race', when queue and dequeue buffer as in
> capture.c (attached on the first mail) it's used.
> 
> This could be easily detected on a kernel with DEBUG_LIST enabled. The
> poison values will be shown on the oops.

Indeed, your analysis seems correct.

> This is a test patch only......
> 
> The oops its triggered when something like this happens:
> 
>    suppose X=1 (v4l2_buf->index)
>    uvc_queue_next_buffer->
>                   buf = [buf_index_X]
>    * in the middle, the same buffer is attached to the list...

How would that happen ? I can see a tiny race condition in the code, but I'm 
not sure it could get triggered in practice.

When the interrupt handler marks the buffer as done, a userspace application 
could then dequeue and requeue the buffer before the interrupt handler calls 
uvc_queue_next_buffer() to remove from the irqqueue list. That would require 
an SMP system, and a userspace application running fast enough to call both 
DQBUF and QBUF between the time the buffer is marked as done and the time the 
buffer is removed from the list. Theoretically possible, but highly 
improbable.

>    * uvc_queue_next_buffer  calls  list_del(&buf->queue)
>    * Now prev and next from buf->queue are "poisoned"
>    * next uvc_queue_next_buffer will fetch the same buffer index, and
>      call list_del again, triggering the oops.

If the buffer can indeed end up back in the list before being dequeued, I 
agree with your analysis.

> I can only reproduce this using the capture.c attached, that should
> return 0 after an -EAGAIN and not 'continue the loop'. In fact, after
> this little thest patch , the capture.c shouldn't work anymore, but
> svv.c (from jmoinef) , will work as expected using the read method.

I can't reproduce the problem here so I can't investigate. Could you find out 
how the race condition is triggered ?

> I really, didn't have time to like if this can be fixed getting some
> of the lokcs earlier, so , this patch it just for testing if the oops
> still happens with you. It just added a new 'state' , if a buffer is
> marked as done but , ihave not been "dequeued", in the sense of
> list_del have been called, then -EINVAL will be returned. This should
> the the common behavior, but for those reasons, it's not ben returned.
> 
> Also, trace shouldn't be used to trigger the buf, since it's during
> interrupt context, the delays added by the printk, make it more
> difficult to trigger.
> 
> Laurent, could you check if something of this make sense, or i am just
> talking bs?

States are not bit flags, so UVC_BUF_STATE_DONE|UVC_BUF_STATE_UNQUEUED will 
actually be equal to UVC_BUF_STATE_UNQUEUED. No sure if that's what you 
wanted.

> I tested it on ID 064e:a101 Suyin Corp. Laptop integrated WebCam (acer 5420)
> 
> PD: Note that this patch apply only to isoc decode. In case of a
> proposed apply, decode_bulk, and isight should be taken in account too
> when checking the buf->state.
> 
> Signed-off-by: Costantino Leandro <lcostantino@gmail.com>
> ---
> 
> diff -Nru gspca-e16961fe157d/linux/drivers/media/video/uvc/uvc_queue.c
>  gspca-dev//linux/drivers/media/video/uvc/uvc_queue.c ---
>  gspca-e16961fe157d/linux/drivers/media/video/uvc/uvc_queue.c	2009-12-02
>  12:39:53.000000000 -0500 +++
>  gspca-dev//linux/drivers/media/video/uvc/uvc_queue.c	2009-12-13
>  04:06:44.000000000 -0500 @@ -197,6 +197,7 @@
>  	switch (buf->state) {
>  	case UVC_BUF_STATE_ERROR:
>  	case UVC_BUF_STATE_DONE:
> +	case (UVC_BUF_STATE_DONE | UVC_BUF_STATE_UNQUEUED):
>  		v4l2_buf->flags |= V4L2_BUF_FLAG_DONE;
>  		break;
>  	case UVC_BUF_STATE_QUEUED:
> @@ -341,10 +342,13 @@
>  		uvc_trace(UVC_TRACE_CAPTURE, "[W] Corrupted data "
>  			"(transmission error).\n");
>  		ret = -EIO;
> -	case UVC_BUF_STATE_DONE:
> +	case (UVC_BUF_STATE_DONE|UVC_BUF_STATE_UNQUEUED):
> +		uvc_trace(UVC_TRACE_CAPTURE, "[I] Buffer %u completed."
> +			" Ready for 'reuse'.\n", v4l2_buf->index);
>  		buf->state = UVC_BUF_STATE_IDLE;
>  		break;
> -
> +	case UVC_BUF_STATE_DONE:
> +		break;;
>  	case UVC_BUF_STATE_IDLE:
>  	case UVC_BUF_STATE_QUEUED:
>  	case UVC_BUF_STATE_ACTIVE:
> @@ -383,8 +387,8 @@
>  	buf = list_first_entry(&queue->mainqueue, struct uvc_buffer, stream);
> 
>  	poll_wait(file, &buf->wait, wait);
> -	if (buf->state == UVC_BUF_STATE_DONE ||
> -	    buf->state == UVC_BUF_STATE_ERROR)
> +	if (buf->state == (UVC_BUF_STATE_DONE | UVC_BUF_STATE_UNQUEUED)
> +	    || buf->state == UVC_BUF_STATE_ERROR)
>  		mask |= POLLIN | POLLRDNORM;
> 
>  done:
> @@ -489,7 +493,9 @@
> 
>  	spin_lock_irqsave(&queue->irqlock, flags);
>  	list_del(&buf->queue);
> -	if (!list_empty(&queue->irqqueue))
> +
> +	buf->state = (UVC_BUF_STATE_DONE | UVC_BUF_STATE_UNQUEUED);
> +	if (!list_empty(&queue->irqqueue))
>  		nextbuf = list_first_entry(&queue->irqqueue, struct uvc_buffer,
>  					   queue);
>  	else
> diff -Nru gspca-e16961fe157d/linux/drivers/media/video/uvc/uvc_video.c
>  gspca-dev//linux/drivers/media/video/uvc/uvc_video.c ---
>  gspca-e16961fe157d/linux/drivers/media/video/uvc/uvc_video.c	2009-12-02
>  12:39:53.000000000 -0500 +++
>  gspca-dev//linux/drivers/media/video/uvc/uvc_video.c	2009-12-13
>  04:05:52.000000000 -0500 @@ -553,7 +553,7 @@
>  			ret = uvc_video_decode_start(stream, buf, mem,
>  				urb->iso_frame_desc[i].actual_length);
>  			if (ret == -EAGAIN)
> -				buf = uvc_queue_next_buffer(&stream->queue,
> +				buf = uvc_queue_next_buffer(&stream->queue,
>  							    buf);
>  		} while (ret == -EAGAIN);
> 
> @@ -568,8 +568,8 @@
>  		uvc_video_decode_end(stream, buf, mem,
>  			urb->iso_frame_desc[i].actual_length);
> 
> -		if (buf->state == UVC_BUF_STATE_DONE ||
> -		    buf->state == UVC_BUF_STATE_ERROR)
> +		if (buf->state == (UVC_BUF_STATE_DONE|UVC_BUF_STATE_UNQUEUED)
> +		    || buf->state == UVC_BUF_STATE_ERROR)
>  			buf = uvc_queue_next_buffer(&stream->queue, buf);
>  	}
>  }
> diff -Nru gspca-e16961fe157d/linux/drivers/media/video/uvc/uvcvideo.h
>  gspca-dev//linux/drivers/media/video/uvc/uvcvideo.h ---
>  gspca-e16961fe157d/linux/drivers/media/video/uvc/uvcvideo.h	2009-12-02
>  12:39:53.000000000 -0500 +++
>  gspca-dev//linux/drivers/media/video/uvc/uvcvideo.h	2009-12-13
>  03:15:22.000000000 -0500 @@ -368,6 +368,7 @@
>  	UVC_BUF_STATE_ACTIVE	= 2,
>  	UVC_BUF_STATE_DONE	= 3,
>  	UVC_BUF_STATE_ERROR	= 4,
> +	 UVC_BUF_STATE_UNQUEUED	= 5
>  };
> 
>  struct uvc_buffer {
> 
> On Thu, 10 Dec 2009, Laurent Pinchart wrote:
> > On Thursday 10 December 2009 16:26:19 Pablo Baena wrote:
> > > Can you tell me how to obtain such backtrace? This is a hard panic and
> > > I don't know how to obtain a backtrace, since the keyboard gets
> > > unresponsive.
> >
> > Once the kernel crashes in interrupt context there's not much you can do.
> > One solution would be to write the backtrace down, but that's a bit
> > tedious :-)
> >
> > Another solution, if your computer has a serial port, is to activate a
> > serial console and hook it up to another computer where you will be able
> > to capture the oops.
> 

-- 
Laurent Pinchart
