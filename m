Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:43506 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752419Ab3KJXnN (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 10 Nov 2013 18:43:13 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Pawel Osciak <posciak@chromium.org>
Cc: linux-media@vger.kernel.org
Subject: Re: [PATCH v1 12/19] uvcvideo: Reorganize next buffer handling.
Date: Mon, 11 Nov 2013 00:43:47 +0100
Message-ID: <60181878.dWS8ipb516@avalon>
In-Reply-To: <1377829038-4726-13-git-send-email-posciak@chromium.org>
References: <1377829038-4726-1-git-send-email-posciak@chromium.org> <1377829038-4726-13-git-send-email-posciak@chromium.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Pawel,

Thank you for the patch.

On Friday 30 August 2013 11:17:11 Pawel Osciak wrote:
> Move getting the first buffer from the current queue to a uvc_queue function
> and out of the USB completion handler.

Could you please add a sentence explaining why the patch is needed ?

> Signed-off-by: Pawel Osciak <posciak@chromium.org>
> ---
>  drivers/media/usb/uvc/uvc_isight.c |  6 ++++--
>  drivers/media/usb/uvc/uvc_queue.c  | 14 ++++++++++++++
>  drivers/media/usb/uvc/uvc_video.c  | 29 ++++++++++++-----------------
>  drivers/media/usb/uvc/uvcvideo.h   |  7 +++----
>  4 files changed, 33 insertions(+), 23 deletions(-)
> 
> diff --git a/drivers/media/usb/uvc/uvc_isight.c
> b/drivers/media/usb/uvc/uvc_isight.c index 8510e72..ab01286 100644
> --- a/drivers/media/usb/uvc/uvc_isight.c
> +++ b/drivers/media/usb/uvc/uvc_isight.c
> @@ -99,10 +99,12 @@ static int isight_decode(struct uvc_video_queue *queue,
> struct uvc_buffer *buf, return 0;
>  }
> 
> -void uvc_video_decode_isight(struct urb *urb, struct uvc_streaming *stream,
> -		struct uvc_buffer *buf)
> +void uvc_video_decode_isight(struct urb *urb, struct uvc_streaming *stream)
> {
>  	int ret, i;
> +	struct uvc_buffer *buf;

Could you please move this on top of the previous line ?

> +
> +	buf = uvc_queue_get_first_buf(&stream->queue);
> 
>  	for (i = 0; i < urb->number_of_packets; ++i) {
>  		if (urb->iso_frame_desc[i].status < 0) {
> diff --git a/drivers/media/usb/uvc/uvc_queue.c
> b/drivers/media/usb/uvc/uvc_queue.c index cd962be..55d2670 100644
> --- a/drivers/media/usb/uvc/uvc_queue.c
> +++ b/drivers/media/usb/uvc/uvc_queue.c
> @@ -352,6 +352,20 @@ void uvc_queue_cancel(struct uvc_video_queue *queue,
> int disconnect) spin_unlock_irqrestore(&queue->irqlock, flags);
>  }
> 
> +struct uvc_buffer *uvc_queue_get_first_buf(struct uvc_video_queue *queue)
> +{
> +	struct uvc_buffer *buf = NULL;
> +	unsigned long flags;
> +
> +	spin_lock_irqsave(&queue->irqlock, flags);
> +	if (!list_empty(&queue->irqqueue))
> +		buf = list_first_entry(&queue->irqqueue, struct uvc_buffer,
> +					queue);
> +	spin_unlock_irqrestore(&queue->irqlock, flags);
> +
> +	return buf;
> +}
> +
>  struct uvc_buffer *uvc_queue_next_buffer(struct uvc_video_queue *queue,
>  		struct uvc_buffer *buf)
>  {
> diff --git a/drivers/media/usb/uvc/uvc_video.c
> b/drivers/media/usb/uvc/uvc_video.c index b4ebccd..2f9a5fa 100644
> --- a/drivers/media/usb/uvc/uvc_video.c
> +++ b/drivers/media/usb/uvc/uvc_video.c
> @@ -1193,11 +1193,11 @@ static int uvc_video_encode_data(struct
> uvc_streaming *stream, /*
>   * Completion handler for video URBs.
>   */
> -static void uvc_video_decode_isoc(struct urb *urb, struct uvc_streaming
> *stream, -	struct uvc_buffer *buf)
> +static void uvc_video_decode_isoc(struct urb *urb, struct uvc_streaming
> *stream) {
>  	u8 *mem;
>  	int ret, i;
> +	struct uvc_buffer *buf = NULL;

Same here (and below).

>  	for (i = 0; i < urb->number_of_packets; ++i) {
>  		if (urb->iso_frame_desc[i].status < 0) {
> @@ -1211,6 +1211,7 @@ static void uvc_video_decode_isoc(struct urb *urb,
> struct uvc_streaming *stream,
> 
>  		/* Decode the payload header. */
>  		mem = urb->transfer_buffer + urb->iso_frame_desc[i].offset;
> +		buf = uvc_queue_get_first_buf(&stream->queue);

Can't this call be moved outside of the loop ?

>  		do {
>  			ret = uvc_video_decode_start(stream, buf, mem,
>  				urb->iso_frame_desc[i].actual_length);
> @@ -1241,11 +1242,11 @@ static void uvc_video_decode_isoc(struct urb *urb,
> struct uvc_streaming *stream, }
>  }
> 
> -static void uvc_video_decode_bulk(struct urb *urb, struct uvc_streaming
> *stream, -	struct uvc_buffer *buf)
> +static void uvc_video_decode_bulk(struct urb *urb, struct uvc_streaming
> *stream) {
>  	u8 *mem;
>  	int len, ret;
> +	struct uvc_buffer *buf;
> 
>  	/*
>  	 * Ignore ZLPs if they're not part of a frame, otherwise process them
> @@ -1258,6 +1259,8 @@ static void uvc_video_decode_bulk(struct urb *urb,
> struct uvc_streaming *stream, len = urb->actual_length;
>  	stream->bulk.payload_size += len;
> 
> +	buf = uvc_queue_get_first_buf(&stream->queue);
> +
>  	/* If the URB is the first of its payload, decode and save the
>  	 * header.
>  	 */
> @@ -1309,12 +1312,13 @@ static void uvc_video_decode_bulk(struct urb *urb,
> struct uvc_streaming *stream, }
>  }
> 
> -static void uvc_video_encode_bulk(struct urb *urb, struct uvc_streaming
> *stream, -	struct uvc_buffer *buf)
> +static void uvc_video_encode_bulk(struct urb *urb, struct uvc_streaming
> *stream) {
>  	u8 *mem = urb->transfer_buffer;
>  	int len = stream->urb_size, ret;
> +	struct uvc_buffer *buf;
> 
> +	buf = uvc_queue_get_first_buf(&stream->queue);
>  	if (buf == NULL) {
>  		urb->transfer_buffer_length = 0;
>  		return;
> @@ -1355,9 +1359,6 @@ static void uvc_video_encode_bulk(struct urb *urb,
> struct uvc_streaming *stream, static void uvc_video_complete(struct urb
> *urb)
>  {
>  	struct uvc_streaming *stream = urb->context;
> -	struct uvc_video_queue *queue = &stream->queue;
> -	struct uvc_buffer *buf = NULL;
> -	unsigned long flags;
>  	int ret;
> 
>  	switch (urb->status) {
> @@ -1374,17 +1375,11 @@ static void uvc_video_complete(struct urb *urb)
> 
>  	case -ECONNRESET:	/* usb_unlink_urb() called. */
>  	case -ESHUTDOWN:	/* The endpoint is being disabled. */
> -		uvc_queue_cancel(queue, urb->status == -ESHUTDOWN);
> +		uvc_queue_cancel(&stream->queue, urb->status == -ESHUTDOWN);
>  		return;
>  	}
> 
> -	spin_lock_irqsave(&queue->irqlock, flags);
> -	if (!list_empty(&queue->irqqueue))
> -		buf = list_first_entry(&queue->irqqueue, struct uvc_buffer,
> -				       queue);
> -	spin_unlock_irqrestore(&queue->irqlock, flags);
> -
> -	stream->decode(urb, stream, buf);
> +	stream->decode(urb, stream);
> 
>  	if ((ret = usb_submit_urb(urb, GFP_ATOMIC)) < 0) {
>  		uvc_printk(KERN_ERR, "Failed to resubmit video URB (%d).\n",
> diff --git a/drivers/media/usb/uvc/uvcvideo.h
> b/drivers/media/usb/uvc/uvcvideo.h index 46ffd92..bca8715 100644
> --- a/drivers/media/usb/uvc/uvcvideo.h
> +++ b/drivers/media/usb/uvc/uvcvideo.h
> @@ -482,8 +482,7 @@ struct uvc_streaming {
>  	/* Buffers queue. */
>  	unsigned int frozen : 1;
>  	struct uvc_video_queue queue;
> -	void (*decode) (struct urb *urb, struct uvc_streaming *video,
> -			struct uvc_buffer *buf);
> +	void (*decode) (struct urb *urb, struct uvc_streaming *video);
> 
>  	/* Context data used by the bulk completion handler. */
>  	struct {
> @@ -659,6 +658,7 @@ extern int uvc_dequeue_buffer(struct uvc_video_queue
> *queue, struct v4l2_buffer *v4l2_buf, int nonblocking);
>  extern int uvc_queue_enable(struct uvc_video_queue *queue, int enable);
>  extern void uvc_queue_cancel(struct uvc_video_queue *queue, int
> disconnect); +struct uvc_buffer *uvc_queue_get_first_buf(struct
> uvc_video_queue *queue); extern struct uvc_buffer
> *uvc_queue_next_buffer(struct uvc_video_queue *queue, struct uvc_buffer
> *buf);
>  extern int uvc_queue_mmap(struct uvc_video_queue *queue,
> @@ -751,8 +751,7 @@ extern struct usb_host_endpoint *uvc_find_endpoint(
>  		struct usb_host_interface *alts, __u8 epaddr);
> 
>  /* Quirks support */
> -void uvc_video_decode_isight(struct urb *urb, struct uvc_streaming *stream,
> -		struct uvc_buffer *buf);
> +void uvc_video_decode_isight(struct urb *urb, struct uvc_streaming
> *stream);
> 
>  /* debugfs and statistics */
>  int uvc_debugfs_init(void);
-- 
Regards,

Laurent Pinchart

