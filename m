Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([213.167.242.64]:48812 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726622AbeG3XsQ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 30 Jul 2018 19:48:16 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Kieran Bingham <kieran.bingham@ideasonboard.com>
Cc: linux-media@vger.kernel.org,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Olivier BRAUN <olivier.braun@stereolabs.com>,
        Troy Kisky <troy.kisky@boundarydevices.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Philipp Zabel <philipp.zabel@gmail.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v4 6/6] media: uvcvideo: Move decode processing to process context
Date: Tue, 31 Jul 2018 01:11:51 +0300
Message-ID: <2606200.TATdTEd0YG@avalon>
In-Reply-To: <cae511f90085701e7093ce39dc8dabf8fc16b844.1522168131.git-series.kieran.bingham@ideasonboard.com>
References: <cover.3cb9065dabdf5d455da508fb4109201e626d5ee7.1522168131.git-series.kieran.bingham@ideasonboard.com> <cae511f90085701e7093ce39dc8dabf8fc16b844.1522168131.git-series.kieran.bingham@ideasonboard.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Kieran,

Thank you for the patch.

On Tuesday, 27 March 2018 19:46:03 EEST Kieran Bingham wrote:
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
> 
> v4:
>  - Provide for_each_uvc_urb()
>  - Simplify fix for shutdown race to flush queue before freeing URBs

Indeed, v4 looks simpler, I like it.

>  - Rebase to v4.16-rc4 (linux-media/master) adjusting for metadata
>    conflicts.
> 
>  drivers/media/usb/uvc/uvc_video.c | 107 ++++++++++++++++++++++++-------
>  drivers/media/usb/uvc/uvcvideo.h  |  28 ++++++++-
>  2 files changed, 111 insertions(+), 24 deletions(-)
> 
> diff --git a/drivers/media/usb/uvc/uvc_video.c
> b/drivers/media/usb/uvc/uvc_video.c index 7dd0dcb457f3..a62e8caf367c 100644
> --- a/drivers/media/usb/uvc/uvc_video.c
> +++ b/drivers/media/usb/uvc/uvc_video.c
> @@ -1042,21 +1042,54 @@ static int uvc_video_decode_start(struct
> uvc_streaming *stream, return data[0];
>  }
> 
> -static void uvc_video_decode_data(struct uvc_streaming *stream,
> +/*
> + * uvc_video_decode_data_work: Asynchronous memcpy processing
> + *
> + * Perform memcpy tasks in process context, with completion handlers
> + * to return the URB, and buffer handles.

By "and buffer handles" do you mean you release the buffer reference ? I'd 
then write this as

"Copy URB data to video buffers in process context, releasing buffer 
references and requeuing the URB when done."

> + */
> +static void uvc_video_copy_data_work(struct work_struct *work)
> +{
> +	struct uvc_urb *uvc_urb = container_of(work, struct uvc_urb, work);
> +	unsigned int i;
> +	int ret;
> +
> +	for (i = 0; i < uvc_urb->async_operations; i++) {
> +		struct uvc_copy_op *op = &uvc_urb->copy_operations[i];
> +
> +		memcpy(op->dst, op->src, op->len);
> +
> +		/* Release reference taken on this buffer */

Missing period at the end of the sentence, here and in other locations in this 
patch.

> +		uvc_queue_buffer_release(op->buf);
> +	}
> +
> +	ret = usb_submit_urb(uvc_urb->urb, GFP_ATOMIC);
> +	if (ret < 0)
> +		uvc_printk(KERN_ERR, "Failed to resubmit video URB (%d).\n",
> +			   ret);
> +}
> +
> +static void uvc_video_decode_data(struct uvc_urb *uvc_urb,
>  		struct uvc_buffer *buf, const u8 *data, int len)
>  {
> -	unsigned int maxlen, nbytes;
> -	void *mem;
> +	unsigned int active_op = uvc_urb->async_operations;
> +	struct uvc_copy_op *decode = &uvc_urb->copy_operations[active_op];

How about calling the variable "op" as it's a copy operation ?

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
> @@ -1064,6 +1097,8 @@ static void uvc_video_decode_data(struct uvc_streaming
> *stream, buf->error = 1;
>  		buf->state = UVC_BUF_STATE_READY;
>  	}
> +
> +	uvc_urb->async_operations++;
>  }
> 
>  static void uvc_video_decode_end(struct uvc_streaming *stream,
> @@ -1272,7 +1307,7 @@ static void uvc_video_decode_isoc(struct uvc_urb
> *uvc_urb, uvc_video_decode_meta(stream, meta_buf, mem, ret);
> 
>  		/* Decode the payload data. */
> -		uvc_video_decode_data(stream, buf, mem + ret,
> +		uvc_video_decode_data(uvc_urb, buf, mem + ret,
>  			urb->iso_frame_desc[i].actual_length - ret);
> 
>  		/* Process the header again. */
> @@ -1334,9 +1369,9 @@ static void uvc_video_decode_bulk(struct uvc_urb
> *uvc_urb, * sure buf is never dereferenced if NULL.
>  	 */
> 
> -	/* Process video data. */
> +	/* Prepare video data for processing. */
>  	if (!stream->bulk.skip_payload && buf != NULL)
> -		uvc_video_decode_data(stream, buf, mem, len);
> +		uvc_video_decode_data(uvc_urb, buf, mem, len);
> 
>  	/* Detect the payload end by a URB smaller than the maximum size (or
>  	 * a payload size equal to the maximum) and process the header again.
> @@ -1422,7 +1457,7 @@ static void uvc_video_complete(struct urb *urb)
>  		uvc_printk(KERN_WARNING, "Non-zero status (%d) in video "
>  			"completion handler.\n", urb->status);
>  		/* fall through */
> -	case -ENOENT:		/* usb_kill_urb() called. */
> +	case -ENOENT:		/* usb_poison_urb() called. */
>  		if (stream->frozen)
>  			return;
>  		/* fall through */
> @@ -1436,6 +1471,9 @@ static void uvc_video_complete(struct urb *urb)
> 
>  	buf = uvc_queue_get_current_buffer(queue);
> 
> +	/* Re-initialise the URB async work. */
> +	uvc_urb->async_operations = 0;
> +

I'd move this just after the vb2_qmeta block to keep the buf and buf_meta code 
together.

>  	if (vb2_qmeta) {
>  		spin_lock_irqsave(&qmeta->irqlock, flags);
>  		if (!list_empty(&qmeta->irqqueue))
> @@ -1444,12 +1482,24 @@ static void uvc_video_complete(struct urb *urb)
>  		spin_unlock_irqrestore(&qmeta->irqlock, flags);
>  	}
> 
> +	/*
> +	 * Process the URB headers, and optionally queue expensive memcpy tasks
> +	 * to be deferred to a work queue.
> +	 */
>  	stream->decode(uvc_urb, buf, buf_meta);
> 
> -	if ((ret = usb_submit_urb(urb, GFP_ATOMIC)) < 0) {
> -		uvc_printk(KERN_ERR, "Failed to resubmit video URB (%d).\n",
> -			ret);
> +	/* If no async work is needed, resubmit the URB immediately. */
> +	if (!uvc_urb->async_operations) {
> +		ret = usb_submit_urb(uvc_urb->urb, GFP_ATOMIC);
> +		if (ret < 0)
> +			uvc_printk(KERN_ERR,
> +				   "Failed to resubmit video URB (%d).\n",
> +				   ret);
> +		return;
>  	}
> +
> +	INIT_WORK(&uvc_urb->work, uvc_video_copy_data_work);

Do you need to reinit the work every time ? I thought that once after 
allocating it was enough. I could be wrong though.

> +	queue_work(stream->async_wq, &uvc_urb->work);
>  }
> 
>  /*
> @@ -1544,25 +1594,29 @@ static int uvc_alloc_urb_buffers(struct
> uvc_streaming *stream, */
>  static void uvc_uninit_video(struct uvc_streaming *stream, int
> free_buffers) {
> -	struct urb *urb;
> -	unsigned int i;
> +	struct uvc_urb *uvc_urb;
> 
>  	uvc_video_stats_stop(stream);
> 
> -	for (i = 0; i < UVC_URBS; ++i) {
> -		struct uvc_urb *uvc_urb = &stream->uvc_urb[i];
> +	/*
> +	 * We must poison the URBs rather than kill them to ensure that even
> +	 * after the completion handler returns, any asynchronous workqueues
> +	 * will be prevented from resubmitting the URBs

Missing period.

> +	 */
> +	for_each_uvc_urb(uvc_urb, stream)
> +		usb_poison_urb(uvc_urb->urb);
> 
> -		urb = uvc_urb->urb;
> -		if (urb == NULL)
> -			continue;
> +	flush_workqueue(stream->async_wq);
> 
> -		usb_kill_urb(urb);
> -		usb_free_urb(urb);
> +	for_each_uvc_urb(uvc_urb, stream) {
> +		usb_free_urb(uvc_urb->urb);
>  		uvc_urb->urb = NULL;
>  	}
> 
>  	if (free_buffers)
>  		uvc_free_urb_buffers(stream);
> +
> +	destroy_workqueue(stream->async_wq);
>  }
> 
>  /*
> @@ -1720,6 +1774,11 @@ static int uvc_init_video(struct uvc_streaming
> *stream, gfp_t gfp_flags)
> 
>  	uvc_video_stats_start(stream);
> 
> +	stream->async_wq = alloc_workqueue("uvcvideo", WQ_UNBOUND | WQ_HIGHPRI,
> +			0);
> +	if (!stream->async_wq)
> +		return -ENOMEM;
> +

Is there a reason to allocate the workqueue at stream on time and destroy it 
at stream off time ? Does it consume resources if we keep it allocated without 
work queued ?

>  	if (intf->num_altsetting > 1) {
>  		struct usb_host_endpoint *best_ep = NULL;
>  		unsigned int best_psize = UINT_MAX;
> diff --git a/drivers/media/usb/uvc/uvcvideo.h
> b/drivers/media/usb/uvc/uvcvideo.h index 112eed49bf50..27c230430eda 100644
> --- a/drivers/media/usb/uvc/uvcvideo.h
> +++ b/drivers/media/usb/uvc/uvcvideo.h
> @@ -485,12 +485,30 @@ struct uvc_stats_stream {
>  #define UVC_METATADA_BUF_SIZE 1024
> 
>  /**
> + * struct uvc_copy_op: Context structure to schedule asynchronous memcpy
> + *
> + * @buf: active buf object for this operation
> + * @dst: copy destination address
> + * @src: copy source address
> + * @len: copy length
> + */
> +struct uvc_copy_op {
> +	struct uvc_buffer *buf;
> +	void *dst;
> +	const __u8 *src;
> +	size_t len;
> +};
> +
> +/**
>   * struct uvc_urb - URB context management structure
>   *
>   * @urb: the URB described by this context structure
>   * @stream: UVC streaming context
>   * @buffer: memory storage for the URB
>   * @dma: DMA coherent addressing for the urb_buffer
> + * @async_operations: counter to indicate the number of copy operations
> + * @copy_operations: work descriptors for asynchronous copy operations
> + * @work: work queue entry for asynchronous decode
>   */
>  struct uvc_urb {
>  	struct urb *urb;
> @@ -498,6 +516,10 @@ struct uvc_urb {
> 
>  	char *buffer;
>  	dma_addr_t dma;
> +
> +	unsigned int async_operations;
> +	struct uvc_copy_op copy_operations[UVC_MAX_PACKETS];
> +	struct work_struct work;
>  };
> 
>  struct uvc_streaming {
> @@ -530,6 +552,7 @@ struct uvc_streaming {
>  	/* Buffers queue. */
>  	unsigned int frozen : 1;
>  	struct uvc_video_queue queue;
> +	struct workqueue_struct *async_wq;
>  	void (*decode)(struct uvc_urb *uvc_urb, struct uvc_buffer *buf,
>  		       struct uvc_buffer *meta_buf);
> 
> @@ -583,6 +606,11 @@ struct uvc_streaming {
>  	} clock;
>  };
> 
> +#define for_each_uvc_urb(uvc_urb, uvc_streaming) \
> +	for (uvc_urb = &uvc_streaming->uvc_urb[0]; \
> +	     uvc_urb < &uvc_streaming->uvc_urb[UVC_URBS]; \
> +	     ++uvc_urb)
> +
>  struct uvc_device {
>  	struct usb_device *udev;
>  	struct usb_interface *intf;

-- 
Regards,

Laurent Pinchart
