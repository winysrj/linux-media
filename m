Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:33456 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752131AbaIIWvw (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 9 Sep 2014 18:51:52 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH] V4L2: UVC: allow using larger buffers
Date: Wed, 10 Sep 2014 01:51:55 +0300
Message-ID: <1489636.2fkWtbAiXo@avalon>
In-Reply-To: <Pine.LNX.4.64.1409090941280.1402@axis700.grange>
References: <Pine.LNX.4.64.1409090941280.1402@axis700.grange>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Guennadi,

Thank you for the patch.

On Tuesday 09 September 2014 09:42:43 Guennadi Liakhovetski wrote:
> A test in uvc_video_decode_isoc() checks whether an image has been
> received from the camera completely. For this the data amount is compared
> to the buffer length, which, however, doesn't have to be equal to the
> image size. Switch to using formats .sizeimage field for an exact
> expected image size.
> 
> Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
> ---
> 
> Thanks to Laurent for the idea
> 
>  drivers/media/usb/uvc/uvc_v4l2.c  | 1 +
>  drivers/media/usb/uvc/uvc_video.c | 2 +-
>  drivers/media/usb/uvc/uvcvideo.h  | 1 +
>  3 files changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/media/usb/uvc/uvc_v4l2.c
> b/drivers/media/usb/uvc/uvc_v4l2.c index 3b548b8..87d15c2 100644
> --- a/drivers/media/usb/uvc/uvc_v4l2.c
> +++ b/drivers/media/usb/uvc/uvc_v4l2.c
> @@ -318,6 +318,7 @@ static int uvc_v4l2_set_format(struct uvc_streaming
> *stream, stream->ctrl = probe;
>  	stream->cur_format = format;
>  	stream->cur_frame = frame;
> +	stream->image_size = fmt->fmt.pix.sizeimage;
> 
>  done:
>  	mutex_unlock(&stream->mutex);
> diff --git a/drivers/media/usb/uvc/uvc_video.c
> b/drivers/media/usb/uvc/uvc_video.c index e568e07..60abf6f 100644
> --- a/drivers/media/usb/uvc/uvc_video.c
> +++ b/drivers/media/usb/uvc/uvc_video.c
> @@ -1172,7 +1172,7 @@ static void uvc_video_decode_isoc(struct urb *urb,
> struct uvc_streaming *stream, urb->iso_frame_desc[i].actual_length);
> 
>  		if (buf->state == UVC_BUF_STATE_READY) {
> -			if (buf->length != buf->bytesused &&
> +			if (stream->image_size != buf->bytesused &&
>  			    !(stream->cur_format->flags &
>  			      UVC_FMT_FLAG_COMPRESSED))
>  				buf->error = 1;
> diff --git a/drivers/media/usb/uvc/uvcvideo.h
> b/drivers/media/usb/uvc/uvcvideo.h index 404793b..d3a3b71 100644
> --- a/drivers/media/usb/uvc/uvcvideo.h
> +++ b/drivers/media/usb/uvc/uvcvideo.h
> @@ -480,6 +480,7 @@ struct uvc_streaming {
>  	struct uvc_format *def_format;
>  	struct uvc_format *cur_format;
>  	struct uvc_frame *cur_frame;
> +	size_t image_size;

As UVC uses the term frame size instead of image size, would you mind renaming 
that field ? I can do that while applying the patch, there's no need to 
resubmit if you're fine with the change.

>  	/* Protect access to ctrl, cur_format, cur_frame and hardware video
>  	 * probe control.
>  	 */

-- 
Regards,

Laurent Pinchart

