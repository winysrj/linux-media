Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([213.167.242.64]:59626 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726403AbeKGI0J (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 7 Nov 2018 03:26:09 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Kieran Bingham <kieran@ksquared.org.uk>
Cc: linux-media@vger.kernel.org,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Olivier BRAUN <olivier.braun@stereolabs.com>,
        Troy Kisky <troy.kisky@boundarydevices.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Philipp Zabel <philipp.zabel@gmail.com>,
        Ezequiel Garcia <ezequiel@collabora.com>,
        Kieran Bingham <kieran.bingham@ideasonboard.com>
Subject: Re: [PATCH v5 6/9] media: uvcvideo: Move decode processing to process context
Date: Wed, 07 Nov 2018 00:58:44 +0200
Message-ID: <1846515.Q7q4NJXYHb@avalon>
In-Reply-To: <926c5590f922810b52851415803c01e32ebeae7b.1541534872.git-series.kieran.bingham@ideasonboard.com>
References: <cover.dd42d667a7f7505b3639149635ef3a0b1431f280.1541534872.git-series.kieran.bingham@ideasonboard.com> <926c5590f922810b52851415803c01e32ebeae7b.1541534872.git-series.kieran.bingham@ideasonboard.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Kieran,

Thank you for the patch.

On Tuesday, 6 November 2018 23:27:17 EET Kieran Bingham wrote:
> From: Kieran Bingham <kieran.bingham@ideasonboard.com>
> 
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

Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

I wonder if we shouldn't, as a future improvement, only queue async work when 
the quantity of data to be copied is above a certain threshold.

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
>  - Rebase to v4.16-rc4 (linux-media/master) adjusting for metadata
>    conflicts.
> 
> v5:
>  - Rebase to media/v4.20-2
>  - Use GFP_KERNEL allocation in uvc_video_copy_data_work()
>  - Fix function documentation for uvc_video_copy_data_work()
>  - Add periods to the end of sentences
>  - Rename 'decode' variable to 'op' in uvc_video_decode_data()
>  - Move uvc_urb->async_operations initialisation to before use
>  - Move async workqueue to match uvc_streaming lifetime instead of
>    streamon/streamoff
> 
>  drivers/media/usb/uvc/uvc_driver.c |   2 +-
>  drivers/media/usb/uvc/uvc_video.c  | 110 +++++++++++++++++++++++-------
>  drivers/media/usb/uvc/uvcvideo.h   |  28 ++++++++-
>  3 files changed, 116 insertions(+), 24 deletions(-)
> 
> diff --git a/drivers/media/usb/uvc/uvc_driver.c
> b/drivers/media/usb/uvc/uvc_driver.c index bc369a0934a3..e61a6d26e812
> 100644
> --- a/drivers/media/usb/uvc/uvc_driver.c
> +++ b/drivers/media/usb/uvc/uvc_driver.c
> @@ -1883,6 +1883,8 @@ static void uvc_unregister_video(struct uvc_device
> *dev) video_unregister_device(&stream->vdev);
>  		video_unregister_device(&stream->meta.vdev);
> 
> +		destroy_workqueue(stream->async_wq);
> +
>  		uvc_debugfs_cleanup_stream(stream);
>  	}
>  }
> diff --git a/drivers/media/usb/uvc/uvc_video.c
> b/drivers/media/usb/uvc/uvc_video.c index 7a7779e1b466..ce9e40444507 100644
> --- a/drivers/media/usb/uvc/uvc_video.c
> +++ b/drivers/media/usb/uvc/uvc_video.c
> @@ -1094,21 +1094,54 @@ static int uvc_video_decode_start(struct
> uvc_streaming *stream, return data[0];
>  }
> 
> -static void uvc_video_decode_data(struct uvc_streaming *stream,
> +/*
> + * uvc_video_decode_data_work: Asynchronous memcpy processing
> + *
> + * Copy URB data to video buffers in process context, releasing buffer
> + * references and requeuing the URB when done.
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
> +		/* Release reference taken on this buffer. */
> +		uvc_queue_buffer_release(op->buf);
> +	}
> +
> +	ret = usb_submit_urb(uvc_urb->urb, GFP_KERNEL);
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
> +	struct uvc_copy_op *op = &uvc_urb->copy_operations[active_op];
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
> +	/* Take a buffer reference for async work. */
> +	kref_get(&buf->ref);
> +
> +	op->buf = buf;
> +	op->src = data;
> +	op->dst = buf->mem + buf->bytesused;
> +	op->len = min_t(unsigned int, len, maxlen);
> +
> +	buf->bytesused += op->len;
> 
>  	/* Complete the current frame if the buffer size was exceeded. */
>  	if (len > maxlen) {
> @@ -1116,6 +1149,8 @@ static void uvc_video_decode_data(struct uvc_streaming
> *stream, buf->error = 1;
>  		buf->state = UVC_BUF_STATE_READY;
>  	}
> +
> +	uvc_urb->async_operations++;
>  }
> 
>  static void uvc_video_decode_end(struct uvc_streaming *stream,
> @@ -1324,7 +1359,7 @@ static void uvc_video_decode_isoc(struct uvc_urb
> *uvc_urb, uvc_video_decode_meta(stream, meta_buf, mem, ret);
> 
>  		/* Decode the payload data. */
> -		uvc_video_decode_data(stream, buf, mem + ret,
> +		uvc_video_decode_data(uvc_urb, buf, mem + ret,
>  			urb->iso_frame_desc[i].actual_length - ret);
> 
>  		/* Process the header again. */
> @@ -1384,9 +1419,9 @@ static void uvc_video_decode_bulk(struct uvc_urb
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
> @@ -1472,7 +1507,7 @@ static void uvc_video_complete(struct urb *urb)
>  		uvc_printk(KERN_WARNING, "Non-zero status (%d) in video "
>  			"completion handler.\n", urb->status);
>  		/* fall through */
> -	case -ENOENT:		/* usb_kill_urb() called. */
> +	case -ENOENT:		/* usb_poison_urb() called. */
>  		if (stream->frozen)
>  			return;
>  		/* fall through */
> @@ -1494,12 +1529,26 @@ static void uvc_video_complete(struct urb *urb)
>  		spin_unlock_irqrestore(&qmeta->irqlock, flags);
>  	}
> 
> +	/* Re-initialise the URB async work. */
> +	uvc_urb->async_operations = 0;
> +
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
> +	queue_work(stream->async_wq, &uvc_urb->work);
>  }
> 
>  /*
> @@ -1594,20 +1643,22 @@ static int uvc_alloc_urb_buffers(struct
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
> +	 * will be prevented from resubmitting the URBs.
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
> @@ -1932,6 +1983,7 @@ int uvc_video_init(struct uvc_streaming *stream)
>  	struct uvc_streaming_control *probe = &stream->ctrl;
>  	struct uvc_format *format = NULL;
>  	struct uvc_frame *frame = NULL;
> +	struct uvc_urb *uvc_urb;
>  	unsigned int i;
>  	int ret;
> 
> @@ -2017,6 +2069,16 @@ int uvc_video_init(struct uvc_streaming *stream)
>  		}
>  	}
> 
> +	/* Allocate a stream specific work queue for asynchronous tasks. */
> +	stream->async_wq = alloc_workqueue("uvcvideo", WQ_UNBOUND | WQ_HIGHPRI,
> +					   0);
> +	if (!stream->async_wq)
> +		return -ENOMEM;
> +
> +	/* Prepare asynchronous work items. */
> +	for_each_uvc_urb(uvc_urb, stream)
> +		INIT_WORK(&uvc_urb->work, uvc_video_copy_data_work);
> +
>  	return 0;
>  }
> 
> diff --git a/drivers/media/usb/uvc/uvcvideo.h
> b/drivers/media/usb/uvc/uvcvideo.h index 1bc17da7f3d4..0953e2e59a79 100644
> --- a/drivers/media/usb/uvc/uvcvideo.h
> +++ b/drivers/media/usb/uvc/uvcvideo.h
> @@ -491,12 +491,30 @@ struct uvc_stats_stream {
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
> @@ -504,6 +522,10 @@ struct uvc_urb {
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
> @@ -536,6 +558,7 @@ struct uvc_streaming {
>  	/* Buffers queue. */
>  	unsigned int frozen : 1;
>  	struct uvc_video_queue queue;
> +	struct workqueue_struct *async_wq;
>  	void (*decode)(struct uvc_urb *uvc_urb, struct uvc_buffer *buf,
>  		       struct uvc_buffer *meta_buf);
> 
> @@ -589,6 +612,11 @@ struct uvc_streaming {
>  	} clock;
>  };
> 
> +#define for_each_uvc_urb(uvc_urb, uvc_streaming) \
> +	for ((uvc_urb) = &(uvc_streaming)->uvc_urb[0]; \
> +	     (uvc_urb) < &(uvc_streaming)->uvc_urb[UVC_URBS]; \
> +	     ++(uvc_urb))
> +
>  struct uvc_device_info {
>  	u32	quirks;
>  	u32	meta_format;


-- 
Regards,

Laurent Pinchart
