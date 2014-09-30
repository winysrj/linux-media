Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:50799 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753258AbaI3WAK (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 30 Sep 2014 18:00:10 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: linux-media@vger.kernel.org
Subject: Re: [PATCH] v4l: uvcvideo: Fix buffer completion size check
Date: Wed, 01 Oct 2014 01:00:06 +0300
Message-ID: <4601787.gRim91NFsA@avalon>
In-Reply-To: <1412113371-11485-1-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1412113371-11485-1-git-send-email-laurent.pinchart@ideasonboard.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wednesday 01 October 2014 00:42:51 Laurent Pinchart wrote:
> Commit e93e7fd9f5a3fffec7792dbcc4c3574653effda7 ("v4l2: uvcvideo: Allow
> using larger buffers") reworked the buffer size sanity check at buffer
> completion time to use the frame size instead of the allocated buffer
> size. However, it introduced two bugs in doing so:
> 
> - it assigned the allocated buffer size to the frame_size field, instead
>   of assigning the correct frame size
> 
> - it performed the assignment in the S_FMT handler, resulting in the
>   frame_size field being uninitialized if the userspace application
>   doesn't call S_FMT.
> 
> Fix both issues by removing the frame_size field and validating the
> buffer size against the UVC video control dwMaxFrameSize.
> 
> Fixes: e93e7fd9f5a3 ("v4l2: uvcvideo: Allow using larger buffers")
> Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> ---
>  drivers/media/usb/uvc/uvc_v4l2.c  | 1 -
>  drivers/media/usb/uvc/uvc_video.c | 2 +-
>  drivers/media/usb/uvc/uvcvideo.h  | 1 -
>  3 files changed, 1 insertion(+), 3 deletions(-)
> 
> Guennadi, could you please test and ack this ASAP, as the bug needs to be
> fixed for v3.18-rc1 if possible ?

And, while we're at it, are you aware that the uvcvideo driver ignores the 
sizeimage field in its S_FMT handler ? :-)

> diff --git a/drivers/media/usb/uvc/uvc_v4l2.c
> b/drivers/media/usb/uvc/uvc_v4l2.c index f205934..f33a067 100644
> --- a/drivers/media/usb/uvc/uvc_v4l2.c
> +++ b/drivers/media/usb/uvc/uvc_v4l2.c
> @@ -318,7 +318,6 @@ static int uvc_v4l2_set_format(struct uvc_streaming
> *stream, stream->ctrl = probe;
>  	stream->cur_format = format;
>  	stream->cur_frame = frame;
> -	stream->frame_size = fmt->fmt.pix.sizeimage;
> 
>  done:
>  	mutex_unlock(&stream->mutex);
> diff --git a/drivers/media/usb/uvc/uvc_video.c
> b/drivers/media/usb/uvc/uvc_video.c index 9ace520..df81b9c 100644
> --- a/drivers/media/usb/uvc/uvc_video.c
> +++ b/drivers/media/usb/uvc/uvc_video.c
> @@ -1143,7 +1143,7 @@ static int uvc_video_encode_data(struct uvc_streaming
> *stream, static void uvc_video_validate_buffer(const struct uvc_streaming
> *stream, struct uvc_buffer *buf)
>  {
> -	if (stream->frame_size != buf->bytesused &&
> +	if (stream->ctrl.dwMaxVideoFrameSize != buf->bytesused &&
>  	    !(stream->cur_format->flags & UVC_FMT_FLAG_COMPRESSED))
>  		buf->error = 1;
>  }
> diff --git a/drivers/media/usb/uvc/uvcvideo.h
> b/drivers/media/usb/uvc/uvcvideo.h index f585c08..897cfd8 100644
> --- a/drivers/media/usb/uvc/uvcvideo.h
> +++ b/drivers/media/usb/uvc/uvcvideo.h
> @@ -458,7 +458,6 @@ struct uvc_streaming {
>  	struct uvc_format *def_format;
>  	struct uvc_format *cur_format;
>  	struct uvc_frame *cur_frame;
> -	size_t frame_size;
> 
>  	/* Protect access to ctrl, cur_format, cur_frame and hardware video
>  	 * probe control.

-- 
Regards,

Laurent Pinchart

