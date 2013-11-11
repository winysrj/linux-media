Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:44153 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750959Ab3KKBss (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 10 Nov 2013 20:48:48 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Pawel Osciak <posciak@chromium.org>
Cc: linux-media@vger.kernel.org
Subject: Re: [PATCH v1 15/19] uvcvideo: Add support for VP8 special frame flags.
Date: Mon, 11 Nov 2013 02:49:23 +0100
Message-ID: <1422068.tIH6xFQx9B@avalon>
In-Reply-To: <1377829038-4726-16-git-send-email-posciak@chromium.org>
References: <1377829038-4726-1-git-send-email-posciak@chromium.org> <1377829038-4726-16-git-send-email-posciak@chromium.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Pawel,

Thank you for the patch.

On Friday 30 August 2013 11:17:14 Pawel Osciak wrote:

Commit message missing :-)

> Signed-off-by: Pawel Osciak <posciak@chromium.org>
> ---
>  drivers/media/usb/uvc/uvc_video.c | 18 +++++++++++++++++-
>  drivers/media/usb/uvc/uvcvideo.h  | 10 ++++++++++
>  2 files changed, 27 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/media/usb/uvc/uvc_video.c
> b/drivers/media/usb/uvc/uvc_video.c index 59f57a2..0291817 100644
> --- a/drivers/media/usb/uvc/uvc_video.c
> +++ b/drivers/media/usb/uvc/uvc_video.c
> @@ -1136,6 +1136,8 @@ static int uvc_video_parse_header(struct uvc_streaming
> *stream, if (header->has_scr)
>  		header->length += 6;
> 
> +	header->buf_flags = 0;
> +

I would have moved this initialization line above right after header->length, 
to keep it before the conditional checks, but that's up to you.

>  	if (stream->cur_format->fcc == V4L2_PIX_FMT_VP8) {
>  		/* VP8 payload has 2 additional bytes of BFH. */
>  		header->length += 2;
> @@ -1147,6 +1149,16 @@ static int uvc_video_parse_header(struct
> uvc_streaming *stream, header->has_sli = data[1] & UVC_STREAM_SLI;
>  		if (header->has_sli)
>  			header->length += 2;
> +
> +		/* Codec-specific flags for v4l2_buffer. */
> +		header->buf_flags |= (data[1] & UVC_STREAM_STI) ?
> +					V4L2_BUF_FLAG_KEYFRAME : 0;

Is a keyframe the same thing as an intraframe ?

> +		header->buf_flags |= (data[2] & UVC_STREAM_VP8_PRF) ?
> +					V4L2_BUF_FLAG_PREV_FRAME : 0;
> +		header->buf_flags |= (data[2] & UVC_STREAM_VP8_ARF) ?
> +					V4L2_BUF_FLAG_ALTREF_FRAME : 0;
> +		header->buf_flags |= (data[2] & UVC_STREAM_VP8_GRF) ?
> +					V4L2_BUF_FLAG_GOLDEN_FRAME : 0;
>  	}
> 
>  	/* - bHeaderLength value can't be larger than the packet size. */
> @@ -1222,6 +1234,8 @@ static void uvc_video_decode_isoc(struct urb *urb,
> struct uvc_streaming *stream) if (ret < 0)
>  			continue;
> 
> +		buf->buf.v4l2_buf.flags |= header.buf_flags;

What about moving this line to the end of uvc_video_decode_data(), right 
before it returns successfully ?

> +
>  		/* Decode the payload data. */
>  		uvc_video_decode_data(stream, buf, mem + header.length,
>  			urb->iso_frame_desc[i].actual_length - header.length);
> @@ -1293,8 +1307,10 @@ static void uvc_video_decode_bulk(struct urb *urb,
> struct uvc_streaming *stream) */
> 
>  	/* Process video data. */
> -	if (!stream->bulk.skip_payload && buf != NULL)
> +	if (!stream->bulk.skip_payload && buf != NULL) {
>  		uvc_video_decode_data(stream, buf, mem, len);
> +		buf->buf.v4l2_buf.flags |= header.buf_flags;
> +	}
> 
>  	/* Detect the payload end by a URB smaller than the maximum size (or
>  	 * a payload size equal to the maximum) and process the header again.
> diff --git a/drivers/media/usb/uvc/uvcvideo.h
> b/drivers/media/usb/uvc/uvcvideo.h index b355b2c..fb21459 100644
> --- a/drivers/media/usb/uvc/uvcvideo.h
> +++ b/drivers/media/usb/uvc/uvcvideo.h
> @@ -145,6 +145,14 @@
>  #define UVC_FMT_FLAG_COMPRESSED		0x00000001
>  #define UVC_FMT_FLAG_STREAM		0x00000002
> 
> +/* v4l2_buffer codec flags */
> +#define UVC_V4L2_BUFFER_CODEC_FLAGS	(V4L2_BUF_FLAG_KEYFRAME | \
> +					 V4L2_BUF_FLAG_PFRAME | \
> +					 V4L2_BUF_FLAG_BFRAME | \
> +					 V4L2_BUF_FLAG_PREV_FRAME | \
> +					 V4L2_BUF_FLAG_GOLDEN_FRAME | \
> +					 V4L2_BUF_FLAG_ALTREF_FRAME)

This isn't used in this patch, could you move it to the patch that needs it ?

> +
>  /* ------------------------------------------------------------------------
> * Structures.
>   */
> @@ -472,6 +480,8 @@ struct uvc_payload_header {
> 
>  	int length;
>  	int payload_size;
> +
> +	__u32 buf_flags; /* v4l2_buffer flags */
>  };
> 
>  struct uvc_streaming {
-- 
Regards,

Laurent Pinchart

