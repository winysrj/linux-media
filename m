Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:44140 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750959Ab3KKBqV (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 10 Nov 2013 20:46:21 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Pawel Osciak <posciak@chromium.org>
Cc: linux-media@vger.kernel.org
Subject: Re: [PATCH v1 13/19] uvcvideo: Unify UVC payload header parsing.
Date: Mon, 11 Nov 2013 02:46:56 +0100
Message-ID: <1600750.WaPL0fB8vI@avalon>
In-Reply-To: <1377829038-4726-14-git-send-email-posciak@chromium.org>
References: <1377829038-4726-1-git-send-email-posciak@chromium.org> <1377829038-4726-14-git-send-email-posciak@chromium.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Pawel,

One more comment.

On Friday 30 August 2013 11:17:12 Pawel Osciak wrote:
> Create a separate function for parsing UVC payload headers and extract code
> from other functions into it. Store the parsed values in a header struct.
> 
> Signed-off-by: Pawel Osciak <posciak@chromium.org>
> ---
>  drivers/media/usb/uvc/uvc_video.c | 270 +++++++++++++++++------------------
>  drivers/media/usb/uvc/uvcvideo.h  |  21 +++
>  2 files changed, 157 insertions(+), 134 deletions(-)
> 
> diff --git a/drivers/media/usb/uvc/uvc_video.c
> b/drivers/media/usb/uvc/uvc_video.c index 2f9a5fa..59f57a2 100644
> --- a/drivers/media/usb/uvc/uvc_video.c
> +++ b/drivers/media/usb/uvc/uvc_video.c

[snip]

> @@ -1246,6 +1244,7 @@ static void uvc_video_decode_bulk(struct urb *urb,
> struct uvc_streaming *stream) {
>  	u8 *mem;
>  	int len, ret;
> +	struct uvc_payload_header header;
>  	struct uvc_buffer *buf;
> 
>  	/*
> @@ -1259,6 +1258,10 @@ static void uvc_video_decode_bulk(struct urb *urb,
> struct uvc_streaming *stream) len = urb->actual_length;
>  	stream->bulk.payload_size += len;
> 
> +	ret = uvc_video_parse_header(stream, mem, len, &header);
> +	if (ret < 0)
> +		return;
> +

This won't work. UVC transmits a single header per payload and splits the 
payload to multiple URBs in the case of bulk transfers. Only the first URB 
will thus have a header. You should parse the payload inside the if { ... } in 
the next hunk, and save the header (or at least the needed fields) in stream-
>bulk for the uvc_video_decode_end() call.

>  	buf = uvc_queue_get_first_buf(&stream->queue);
> 
>  	/* If the URB is the first of its payload, decode and save the
> @@ -1266,7 +1269,7 @@ static void uvc_video_decode_bulk(struct urb *urb,
> struct uvc_streaming *stream) */
>  	if (stream->bulk.header_size == 0 && !stream->bulk.skip_payload) {
>  		do {
> -			ret = uvc_video_decode_start(stream, buf, mem, len);
> +			ret = uvc_video_decode_start(stream, buf, &header);
>  			if (ret == -EAGAIN)
>  				buf = uvc_queue_next_buffer(&stream->queue,
>  							    buf);
> @@ -1276,11 +1279,11 @@ static void uvc_video_decode_bulk(struct urb *urb,
> struct uvc_streaming *stream) if (ret < 0 || buf == NULL) {
>  			stream->bulk.skip_payload = 1;
>  		} else {
> -			memcpy(stream->bulk.header, mem, ret);
> -			stream->bulk.header_size = ret;
> +			memcpy(stream->bulk.header, mem, header.length);
> +			stream->bulk.header_size = header.length;
> 
> -			mem += ret;
> -			len -= ret;
> +			mem += header.length;
> +			len -= header.length;
>  		}
>  	}
> 
> @@ -1299,8 +1302,7 @@ static void uvc_video_decode_bulk(struct urb *urb,
> struct uvc_streaming *stream) if (urb->actual_length <
> urb->transfer_buffer_length ||
>  	    stream->bulk.payload_size >= stream->bulk.max_payload_size) {
>  		if (!stream->bulk.skip_payload && buf != NULL) {
> -			uvc_video_decode_end(stream, buf, stream->bulk.header,
> -				stream->bulk.payload_size);
> +			uvc_video_decode_end(stream, buf, &header);
>  			if (buf->state == UVC_BUF_STATE_READY)
>  				buf = uvc_queue_next_buffer(&stream->queue,
>  							    buf);

-- 
Regards,

Laurent Pinchart

