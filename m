Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.18]:60182 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752348AbeADSz2 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 4 Jan 2018 13:55:28 -0500
Date: Thu, 4 Jan 2018 19:54:28 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Kieran Bingham <kbingham@kernel.org>
cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        laurent.pinchart@ideasonboard.com,
        Olivier BRAUN <olivier.braun@stereolabs.com>,
        kieran.bingham@ideasonboard.com,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Baoyou Xie <baoyou.xie@linaro.org>,
        Jaejoong Kim <climbbb.kim@gmail.com>,
        Kate Stewart <kstewart@linuxfoundation.org>,
        Nicolas Dufresne <nicolas.dufresne@collabora.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Daniel Patrick Johnson <teknotus@teknot.us>,
        Jim Lin <jilin@nvidia.com>
Subject: Re: [RFC/RFT PATCH 6/6] uvcvideo: Move decode processing to process
 context
In-Reply-To: <48e2716d3902214a89aa30f3d1672512f8ea8773.1515010476.git-series.kieran.bingham@ideasonboard.com>
Message-ID: <alpine.DEB.2.20.1801041941320.13441@axis700.grange>
References: <cover.67dff754d6d314373ac0a04777b3b1d785fc5dd4.1515010476.git-series.kieran.bingham@ideasonboard.com> <48e2716d3902214a89aa30f3d1672512f8ea8773.1515010476.git-series.kieran.bingham@ideasonboard.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, 3 Jan 2018, Kieran Bingham wrote:

> From: Kieran Bingham <kieran.bingham@ideasonboard.com>
> 
> Newer high definition cameras, and cameras with multiple lenses such as
> the range of stereovision cameras now available have ever increasing
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
> ---
>  drivers/media/usb/uvc/uvc_queue.c |  12 +++-
>  drivers/media/usb/uvc/uvc_video.c | 114 ++++++++++++++++++++++++++-----
>  drivers/media/usb/uvc/uvcvideo.h  |  24 +++++++-
>  3 files changed, 132 insertions(+), 18 deletions(-)
> 
> diff --git a/drivers/media/usb/uvc/uvc_queue.c b/drivers/media/usb/uvc/uvc_queue.c
> index 204dd91a8526..07fcbfc132c9 100644
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
> index 045ac655313c..b7b32a6bc2dc 100644
> --- a/drivers/media/usb/uvc/uvc_video.c
> +++ b/drivers/media/usb/uvc/uvc_video.c
> @@ -1058,21 +1058,70 @@ static int uvc_video_decode_start(struct uvc_streaming *stream,
>  	return data[0];
>  }
>  
> -static void uvc_video_decode_data(struct uvc_streaming *stream,
> -		struct uvc_buffer *buf, const __u8 *data, int len)
> +/*
> + * uvc_video_decode_data_work: Asynchronous memcpy processing
> + *
> + * Perform memcpy tasks in process context, with completion handlers
> + * to return the URB, and buffer handles.
> + *
> + * The work submitter must pre-determine that the work is safe
> + */
> +static void uvc_video_decode_data_work(struct work_struct *work)
>  {
> -	unsigned int maxlen, nbytes;
> -	void *mem;
> +	struct uvc_urb *uvc_urb = container_of(work, struct uvc_urb, work);
> +	struct uvc_streaming *stream = uvc_urb->stream;
> +	struct uvc_video_queue *queue = &stream->queue;
> +	unsigned int i;
> +	bool stopping;
> +	int ret;
> +
> +	for (i = 0; i < uvc_urb->packets; i++) {
> +		struct uvc_decode_op *op = &uvc_urb->decodes[i];
> +
> +		memcpy(op->dst, op->src, op->len);
> +
> +		/* Release reference taken on this buffer */
> +		uvc_queue_buffer_release(op->buf);
> +	}
> +
> +	/*
> +	 * Prevent resubmitting URBs when shutting down to ensure that no new
> +	 * work item will be scheduled after uvc_stop_streaming() flushes the
> +	 * work queue.
> +	 */
> +	spin_lock_irq(&queue->irqlock);
> +	stopping = queue->flags & UVC_QUEUE_STOPPING;
> +	spin_unlock_irq(&queue->irqlock);

Are you sure this locking really helps? What if uvc_stop_streaming() runs 
here?

Thanks
Guennadi

> +
> +	if (stopping)
> +		return;
> +
> +	ret = usb_submit_urb(uvc_urb->urb, GFP_ATOMIC);
> +	if (ret < 0)
> +		uvc_printk(KERN_ERR, "Failed to resubmit video URB (%d).\n",
> +			   ret);
> +}
