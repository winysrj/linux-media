Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:47311 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932621AbeAKRyu (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 11 Jan 2018 12:54:50 -0500
Subject: Re: [RFT PATCH v2 6/6] uvcvideo: Move decode processing to process
 context
To: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        Kieran Bingham <kieran.bingham@ideasonboard.com>
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Olivier BRAUN <olivier.braun@stereolabs.com>,
        Troy Kisky <troy.kisky@boundarydevices.com>
References: <cover.99b809a1c1f6238bb8c0a2c8b0bc7b49dd777d94.1515501206.git-series.kieran.bingham@ideasonboard.com>
 <79ae0dc6fea7ffb39125f3c2956dc101a3dacb9f.1515501206.git-series.kieran.bingham@ideasonboard.com>
From: Kieran Bingham <kieran.bingham@ideasonboard.com>
Message-ID: <e6a61ab6-d115-6fbb-4a7d-d88b87c0d4d1@ideasonboard.com>
Date: Thu, 11 Jan 2018 17:54:45 +0000
MIME-Version: 1.0
In-Reply-To: <79ae0dc6fea7ffb39125f3c2956dc101a3dacb9f.1515501206.git-series.kieran.bingham@ideasonboard.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Kieran !

Thanking you for the patch might be rather self serving here :D

On 09/01/18 13:09, Kieran Bingham wrote:
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
>  drivers/media/usb/uvc/uvc_queue.c |  12 +++-
>  drivers/media/usb/uvc/uvc_video.c | 111 +++++++++++++++++++++++++------
>  drivers/media/usb/uvc/uvcvideo.h  |  24 +++++++-
>  3 files changed, 129 insertions(+), 18 deletions(-)
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
> index 3878bec3276e..a9ddc4f27012 100644
> --- a/drivers/media/usb/uvc/uvc_video.c
> +++ b/drivers/media/usb/uvc/uvc_video.c
> @@ -1058,21 +1058,67 @@ static int uvc_video_decode_start(struct uvc_streaming *stream,
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

This handles asynchronous memory copy work - which could equally be encode work
- so _decode_ might not be an appropriate name here.

>  {
> -	unsigned int maxlen, nbytes;
> -	void *mem;
> +	struct uvc_urb *uvc_urb = container_of(work, struct uvc_urb, work);
> +	struct uvc_streaming *stream = uvc_urb->stream;
> +	struct uvc_video_queue *queue = &stream->queue;
> +	unsigned int i;
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
> +	if (!(queue->flags & UVC_QUEUE_STOPPING)) {
> +		ret = usb_submit_urb(uvc_urb->urb, GFP_ATOMIC);
> +		if (ret < 0)
> +			uvc_printk(KERN_ERR,
> +				   "Failed to resubmit video URB (%d).\n",
> +				   ret);
> +	}
> +	spin_unlock_irq(&queue->irqlock);
> +}
> +
> +static void uvc_video_decode_data(struct uvc_decode_op *decode,
> +		struct uvc_urb *uvc_urb, struct uvc_buffer *buf,
> +		const __u8 *data, int len)
> +{
> +	unsigned int maxlen;
>  
>  	if (len <= 0)
>  		return;
>  
> -	/* Copy the video data to the buffer. */
>  	maxlen = buf->length - buf->bytesused;
> -	mem = buf->mem + buf->bytesused;
> -	nbytes = min((unsigned int)len, maxlen);
> -	memcpy(mem, data, nbytes);
> -	buf->bytesused += nbytes;
> +
> +	/* Take a buffer reference for async work */
> +	kref_get(&buf->ref);
> +
> +	decode->buf = buf;
> +	decode->src = data;
> +	decode->dst = buf->mem + buf->bytesused;
> +	decode->len = min_t(unsigned int, len, maxlen);
> +
> +	buf->bytesused += decode->len;
>  
>  	/* Complete the current frame if the buffer size was exceeded. */
>  	if (len > maxlen) {
> @@ -1080,6 +1126,8 @@ static void uvc_video_decode_data(struct uvc_streaming *stream,
>  		buf->error = 1;
>  		buf->state = UVC_BUF_STATE_READY;
>  	}
> +
> +	uvc_urb->packets++;
>  }
>  
>  static void uvc_video_decode_end(struct uvc_streaming *stream,
> @@ -1162,6 +1210,8 @@ static void uvc_video_decode_isoc(struct uvc_urb *uvc_urb,
>  	int ret, i;
>  
>  	for (i = 0; i < urb->number_of_packets; ++i) {
> +		struct uvc_decode_op *op = &uvc_urb->decodes[uvc_urb->packets];
> +

This structure is only ever used by the uvc_video_decode_data() function, and it
could be obtained in there directly.


>  		if (urb->iso_frame_desc[i].status < 0) {
>  			uvc_trace(UVC_TRACE_FRAME, "USB isochronous frame "
>  				"lost (%d).\n", urb->iso_frame_desc[i].status);
> @@ -1187,7 +1237,7 @@ static void uvc_video_decode_isoc(struct uvc_urb *uvc_urb,
>  			continue;
>  
>  		/* Decode the payload data. */
> -		uvc_video_decode_data(stream, buf, mem + ret,
> +		uvc_video_decode_data(op, uvc_urb, buf, mem + ret,
>  			urb->iso_frame_desc[i].actual_length - ret);
>  
>  		/* Process the header again. */
> @@ -1248,9 +1298,12 @@ static void uvc_video_decode_bulk(struct uvc_urb *uvc_urb,
>  	 * sure buf is never dereferenced if NULL.
>  	 */
>  
> -	/* Process video data. */
> -	if (!stream->bulk.skip_payload && buf != NULL)
> -		uvc_video_decode_data(stream, buf, mem, len);
> +	/* Prepare video data for processing. */
> +	if (!stream->bulk.skip_payload && buf != NULL) {
> +		struct uvc_decode_op *op = &uvc_urb->decodes[0];

Again - no reason to obtain this op here.


> +
> +		uvc_video_decode_data(op, uvc_urb, buf, mem, len);
> +	}
>  
>  	/* Detect the payload end by a URB smaller than the maximum size (or
>  	 * a payload size equal to the maximum) and process the header again.
> @@ -1322,7 +1375,8 @@ static void uvc_video_complete(struct urb *urb)
>  	struct uvc_streaming *stream = uvc_urb->stream;
>  	struct uvc_video_queue *queue = &stream->queue;
>  	struct uvc_buffer *buf = NULL;
> -	int ret;
> +	unsigned long flags;
> +	bool stopping;
>  
>  	switch (urb->status) {
>  	case 0:
> @@ -1342,14 +1396,30 @@ static void uvc_video_complete(struct urb *urb)
>  		return;
>  	}
>  
> +	/*
> +	 * Simply accept and discard completed URBs without processing when the
> +	 * stream is being shutdown. URBs will be freed as part of the
> +	 * uvc_video_enable(s, 0) action, so we must not queue asynchronous
> +	 * work based upon them.
> +	 */
> +	spin_lock_irqsave(&queue->irqlock, flags);
> +	stopping = queue->flags & UVC_QUEUE_STOPPING;
> +	spin_unlock_irqrestore(&queue->irqlock, flags);
> +
> +	if (stopping)
> +		return;
> +

We can race here if the stream gets stopped at this point...! (Thanks Laurent)


>  	buf = uvc_queue_get_current_buffer(queue);
>  
> +	/* Re-initialise the URB packet work */
> +	uvc_urb->packets = 0;
> +
> +	/* Process the URB headers, but work is deferred to a work queue */
>  	stream->decode(uvc_urb, buf);
>  
> -	if ((ret = usb_submit_urb(urb, GFP_ATOMIC)) < 0) {
> -		uvc_printk(KERN_ERR, "Failed to resubmit video URB (%d).\n",
> -			ret);
> -	}
> +	/* Handle any heavy lifting required */
> +	INIT_WORK(&uvc_urb->work, uvc_video_decode_data_work);> +	queue_work(stream->async_wq, &uvc_urb->work);

The encode operations don't currently schedule any work to be done - but the URB
isn't submitted until the work queue runs, which adds unnecessary latency to
non-async functionality.!

>  }
>  
>  /*
> @@ -1620,6 +1690,11 @@ static int uvc_init_video(struct uvc_streaming *stream, gfp_t gfp_flags)
>  
>  	uvc_video_stats_start(stream);
>  
> +	stream->async_wq = alloc_workqueue("uvcvideo", WQ_UNBOUND | WQ_HIGHPRI,
> +			0);
> +	if (!stream->async_wq)
> +		return -ENOMEM;
> +
>  	if (intf->num_altsetting > 1) {
>  		struct usb_host_endpoint *best_ep = NULL;
>  		unsigned int best_psize = UINT_MAX;
> diff --git a/drivers/media/usb/uvc/uvcvideo.h b/drivers/media/usb/uvc/uvcvideo.h
> index 6a18dbfc3e5b..13dc0b2bb8b9 100644
> --- a/drivers/media/usb/uvc/uvcvideo.h
> +++ b/drivers/media/usb/uvc/uvcvideo.h
> @@ -411,6 +411,7 @@ struct uvc_buffer {
>  
>  #define UVC_QUEUE_DISCONNECTED		(1 << 0)
>  #define UVC_QUEUE_DROP_CORRUPTED	(1 << 1)
> +#define UVC_QUEUE_STOPPING		(1 << 2)
>  
>  struct uvc_video_queue {
>  	struct vb2_queue queue;
> @@ -483,12 +484,30 @@ struct uvc_stats_stream {
>  };
>  
>  /**
> + * struct uvc_decode_op: Context structure to schedule asynchronous memcpy
> + *
> + * @buf: active buf object for this decode
> + * @dst: copy destination address
> + * @src: copy source address
> + * @len: copy length
> + */
> +struct uvc_decode_op {
> +	struct uvc_buffer *buf;
> +	void *dst;
> +	const __u8 *src;
> +	int len;
> +};
> +
> +/**
>   * struct uvc_urb - URB context management structure
>   *
>   * @urb: the URB described by this context structure
>   * @stream: UVC streaming context
>   * @buffer: memory storage for the URB
>   * @dma: DMA coherent addressing for the urb_buffer
> + * @packets: counter to indicate the number of copy operations
> + * @decodes: work descriptors for asynchronous copy operations
> + * @work: work queue entry for asynchronous decode
>   */
>  struct uvc_urb {
>  	struct urb *urb;
> @@ -496,6 +515,10 @@ struct uvc_urb {
>  
>  	char *buffer;
>  	dma_addr_t dma;
> +
> +	unsigned int packets;
> +	struct uvc_decode_op decodes[UVC_MAX_PACKETS];

Whilst not currently, the encode functions could also use this system - so
perhaps decodes isn't the right name here.

	struct uvc_copy_op copy_operations[UVC_MAX_PACKETS];

might be a better description

> +	struct work_struct work;
>  };
>  
>  struct uvc_streaming {
> @@ -528,6 +551,7 @@ struct uvc_streaming {
>  	/* Buffers queue. */
>  	unsigned int frozen : 1;
>  	struct uvc_video_queue queue;
> +	struct workqueue_struct *async_wq;
>  	void (*decode)(struct uvc_urb *uvc_urb, struct uvc_buffer *buf);
>  
>  	/* Context data used by the bulk completion handler. */
> 
