Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([213.167.242.64]:34406 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751488AbeFEIwJ (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 5 Jun 2018 04:52:09 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Nicolas Dufresne <nicolas.dufresne@collabora.com>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] uvcvideo: Also validate buffers in BULK mode
Date: Tue, 05 Jun 2018 11:52:19 +0300
Message-ID: <2206409.jVpTcjFX6j@avalon>
In-Reply-To: <20180605002415.11421-1-nicolas.dufresne@collabora.com>
References: <20180605002415.11421-1-nicolas.dufresne@collabora.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Nicolas,

Thank you for the patch.

On Tuesday, 5 June 2018 03:24:15 EEST Nicolas Dufresne wrote:
> Just like for ISOC, validate the decoded BULK buffer size when possible.
> This avoids sending corrupted or partial buffers to userspace, which may
> lead to application crash or run-time failure.
> 
> Signed-off-by: Nicolas Dufresne <nicolas.dufresne@collabora.com>
> ---
>  drivers/media/usb/uvc/uvc_video.c | 8 ++++++--
>  1 file changed, 6 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/media/usb/uvc/uvc_video.c
> b/drivers/media/usb/uvc/uvc_video.c index aa0082fe5833..46df4d01e31b 100644
> --- a/drivers/media/usb/uvc/uvc_video.c
> +++ b/drivers/media/usb/uvc/uvc_video.c
> @@ -1307,8 +1307,10 @@ static void uvc_video_decode_bulk(struct urb *urb,
> struct uvc_streaming *stream, if (stream->bulk.header_size == 0 &&
> !stream->bulk.skip_payload) { do {
>  			ret = uvc_video_decode_start(stream, buf, mem, len);
> -			if (ret == -EAGAIN)
> +			if (ret == -EAGAIN) {
> +				uvc_video_validate_buffer(stream, buf);
>  				uvc_video_next_buffers(stream, &buf, &meta_buf);

Wouldn't it be simpler to move the uvc_video_validate_buffer() call to 
uvc_video_next_buffers() ?

> +			}
>  		} while (ret == -EAGAIN);
> 
>  		/* If an error occurred skip the rest of the payload. */
> @@ -1342,8 +1344,10 @@ static void uvc_video_decode_bulk(struct urb *urb,
> struct uvc_streaming *stream, if (!stream->bulk.skip_payload && buf !=
> NULL) {
>  			uvc_video_decode_end(stream, buf, stream->bulk.header,
>  				stream->bulk.payload_size);
> -			if (buf->state == UVC_BUF_STATE_READY)
> +			if (buf->state == UVC_BUF_STATE_READY) {
> +				uvc_video_validate_buffer(stream, buf);
>  				uvc_video_next_buffers(stream, &buf, &meta_buf);
> +			}
>  		}
> 
>  		stream->bulk.header_size = 0;

-- 
Regards,

Laurent Pinchart
