Return-path: <mchehab@gaivota>
Received: from smtp-vbr1.xs4all.nl ([194.109.24.21]:2389 "EHLO
	smtp-vbr1.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755657Ab0KUVXs (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 21 Nov 2010 16:23:48 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: Re: [PATCH 4/5] uvcvideo: Lock stream mutex when accessing format-related information
Date: Sun, 21 Nov 2010 22:23:38 +0100
Cc: linux-media@vger.kernel.org
References: <1290371573-14907-1-git-send-email-laurent.pinchart@ideasonboard.com> <1290371573-14907-5-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1290371573-14907-5-git-send-email-laurent.pinchart@ideasonboard.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201011212223.38557.hverkuil@xs4all.nl>
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

Another comment:

On Sunday, November 21, 2010 21:32:52 Laurent Pinchart wrote:
> The stream mutex protects access to the struct uvc_streaming ctrl,
> cur_format and cur_frame fields as well as to the hardware probe
> control. Lock it appropriately.
> 
> Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> ---
>  drivers/media/video/uvc/uvc_v4l2.c  |   76 +++++++++++++++++++++++++----------
>  drivers/media/video/uvc/uvc_video.c |    3 -
>  drivers/media/video/uvc/uvcvideo.h  |    4 +-
>  3 files changed, 57 insertions(+), 26 deletions(-)
> 
> diff --git a/drivers/media/video/uvc/uvc_v4l2.c b/drivers/media/video/uvc/uvc_v4l2.c
> index 07dd235..b4615e2 100644
> --- a/drivers/media/video/uvc/uvc_v4l2.c
> +++ b/drivers/media/video/uvc/uvc_v4l2.c
> @@ -226,12 +226,14 @@ static int uvc_v4l2_try_format(struct uvc_streaming *stream,
>  	 * developers test their webcams with the Linux driver as well as with
>  	 * the Windows driver).
>  	 */
> +	mutex_lock(&stream->mutex);
>  	if (stream->dev->quirks & UVC_QUIRK_PROBE_EXTRAFIELDS)
>  		probe->dwMaxVideoFrameSize =
>  			stream->ctrl.dwMaxVideoFrameSize;
>  
>  	/* Probe the device. */
>  	ret = uvc_probe_video(stream, probe);
> +	mutex_unlock(&stream->mutex);
>  	if (ret < 0)
>  		goto done;
>  
> @@ -255,14 +257,21 @@ done:
>  static int uvc_v4l2_get_format(struct uvc_streaming *stream,
>  	struct v4l2_format *fmt)
>  {
> -	struct uvc_format *format = stream->cur_format;
> -	struct uvc_frame *frame = stream->cur_frame;
> +	struct uvc_format *format;
> +	struct uvc_frame *frame;
> +	int ret = 0;
>  
>  	if (fmt->type != stream->type)
>  		return -EINVAL;
>  
> -	if (format == NULL || frame == NULL)
> -		return -EINVAL;
> +	mutex_lock(&stream->mutex);
> +	format = stream->cur_format;
> +	frame = stream->cur_frame;
> +
> +	if (format == NULL || frame == NULL) {
> +		ret = -EINVAL;

ret is set...

> +		goto done;
> +	}
>  
>  	fmt->fmt.pix.pixelformat = format->fcc;
>  	fmt->fmt.pix.width = frame->wWidth;
> @@ -273,6 +282,8 @@ static int uvc_v4l2_get_format(struct uvc_streaming *stream,
>  	fmt->fmt.pix.colorspace = format->colorspace;
>  	fmt->fmt.pix.priv = 0;
>  
> +done:
> +	mutex_unlock(&stream->mutex);
>  	return 0;

But not returned?!

>  }

<snip>

-- 
Hans Verkuil - video4linux developer - sponsored by Cisco
