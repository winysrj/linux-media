Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.15]:57177 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754403AbeALJin (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 12 Jan 2018 04:38:43 -0500
Date: Fri, 12 Jan 2018 10:37:54 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Kieran Bingham <kieran.bingham@ideasonboard.com>
cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Olivier BRAUN <olivier.braun@stereolabs.com>,
        Troy Kisky <troy.kisky@boundarydevices.com>
Subject: Re: [RFT PATCH v3 6/6] uvcvideo: Move decode processing to process
 context
In-Reply-To: <c857652f179fbc083a16029affefbde83a8932dc.1515748369.git-series.kieran.bingham@ideasonboard.com>
Message-ID: <alpine.DEB.2.20.1801121025210.4338@axis700.grange>
References: <cover.30aaad9a6abac5e92d4a1a0e6634909d97cc54d8.1515748369.git-series.kieran.bingham@ideasonboard.com> <c857652f179fbc083a16029affefbde83a8932dc.1515748369.git-series.kieran.bingham@ideasonboard.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Kieran,

On Fri, 12 Jan 2018, Kieran Bingham wrote:

> Newer high definition cameras, and cameras with multiple lenses such as
> the range of stereo-vision cameras now available have ever increasing
> data rates.
> 
> The inclusion of a variable length packet header in URB packets mean
> that we must memcpy the frame data out to our destination 'manually'.
> This can result in data rates of up to 2 gigabits per second being
> processed.
> 
> To improve efficiency, and maximise throughput, handle the URB decode
> processing through a work queue to move it from interrupt context, and
> allow multiple processors to work on URBs in parallel.
> 
> Signed-off-by: Kieran Bingham <kieran.bingham@ideasonboard.com>
> 
> ---
> v2:
>  - Lock full critical section of usb_submit_urb()
> 
> v3:
>  - Fix race on submitting uvc_video_decode_data_work() to work queue.
>  - Rename uvc_decode_op -> uvc_copy_op (Generic to encode/decode)
>  - Rename decodes -> copy_operations
>  - Don't queue work if there is no async task
>  - obtain copy op structure directly in uvc_video_decode_data()
>  - uvc_video_decode_data_work() -> uvc_video_copy_data_work()
> ---
>  drivers/media/usb/uvc/uvc_queue.c |  12 +++-
>  drivers/media/usb/uvc/uvc_video.c | 116 +++++++++++++++++++++++++++----
>  drivers/media/usb/uvc/uvcvideo.h  |  24 ++++++-
>  3 files changed, 138 insertions(+), 14 deletions(-)
> 
> diff --git a/drivers/media/usb/uvc/uvc_queue.c b/drivers/media/usb/uvc/uvc_queue.c
> index 5a9987e547d3..598087eeb5c2 100644
> --- a/drivers/media/usb/uvc/uvc_queue.c
> +++ b/drivers/media/usb/uvc/uvc_queue.c
> @@ -179,10 +179,22 @@ static void uvc_stop_streaming(struct vb2_queue *vq)
>  	struct uvc_video_queue *queue = vb2_get_drv_priv(vq);
>  	struct uvc_streaming *stream = uvc_queue_to_stream(queue);
>  
> +	/* Prevent new buffers coming in. */
> +	spin_lock_irq(&queue->irqlock);
> +	queue->flags |= UVC_QUEUE_STOPPING;
> +	spin_unlock_irq(&queue->irqlock);
> +
> +	/*
> +	 * All pending work should be completed before disabling the stream, as
> +	 * all URBs will be free'd during uvc_video_enable(s, 0).
> +	 */
> +	flush_workqueue(stream->async_wq);

What if we manage to get one last URB here, then...

> +
>  	uvc_video_enable(stream, 0);
>  
>  	spin_lock_irq(&queue->irqlock);
>  	uvc_queue_return_buffers(queue, UVC_BUF_STATE_ERROR);
> +	queue->flags &= ~UVC_QUEUE_STOPPING;
>  	spin_unlock_irq(&queue->irqlock);
>  }
>  
> diff --git a/drivers/media/usb/uvc/uvc_video.c b/drivers/media/usb/uvc/uvc_video.c
> index 3878bec3276e..fb6b5af17380 100644
> --- a/drivers/media/usb/uvc/uvc_video.c
> +++ b/drivers/media/usb/uvc/uvc_video.c

[snip]

> +	/*
> +	 * When the stream is stopped, all URBs are freed as part of the call to
> +	 * uvc_stop_streaming() and must not be handled asynchronously. In that
> +	 * event we can safely complete the packet work directly in this
> +	 * context, without resubmitting the URB.
> +	 */
> +	spin_lock_irqsave(&queue->irqlock, flags);
> +	if (!(queue->flags & UVC_QUEUE_STOPPING)) {
> +		INIT_WORK(&uvc_urb->work, uvc_video_copy_data_work);
> +		queue_work(stream->async_wq, &uvc_urb->work);
> +	} else {
> +		uvc_video_copy_packets(uvc_urb);

Can it not happen, that if the stream is currently being stopped, the 
queue has been flushed, possibly the previous URB or a couple of them 
don't get decoded, but you do decode this one, creating a corrupted frame? 
Wouldn't it be better to just drop this URB too?

>  	}
> +	spin_unlock_irqrestore(&queue->irqlock, flags);
>  }
>  
>  /*

Thanks
Guennadi
