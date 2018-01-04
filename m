Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:50670 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751829AbeADVmJ (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 4 Jan 2018 16:42:09 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Philipp Zabel <philipp.zabel@gmail.com>
Cc: linux-media@vger.kernel.org,
        Nicolas Dufresne <nicolas.dufresne@collabora.com>
Subject: Re: [PATCH] media: uvcvideo: support multiple frame descriptors with the same dimensions
Date: Thu, 04 Jan 2018 23:42:32 +0200
Message-ID: <1926180.iWD88b28mP@avalon>
In-Reply-To: <20171219081735.4384-1-philipp.zabel@gmail.com>
References: <20171219081735.4384-1-philipp.zabel@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Philipp,

Thank you for the patch.

On Tuesday, 19 December 2017 10:17:35 EET Philipp Zabel wrote:
> The Microsoft HoloLens Sensors device has two separate frame descriptors
> with the same dimensions, each with a single different frame interval:

Why, oh why ? :-(

>       VideoStreaming Interface Descriptor:
>         bLength                            30
>         bDescriptorType                    36
>         bDescriptorSubtype                  5 (FRAME_UNCOMPRESSED)
>         bFrameIndex                         1
>         bmCapabilities                   0x00
>           Still image unsupported
>         wWidth                           1280
>         wHeight                           481
>         dwMinBitRate                147763200
>         dwMaxBitRate                147763200
>         dwMaxVideoFrameBufferSize      615680
>         dwDefaultFrameInterval         333333
>         bFrameIntervalType                  1
>         dwFrameInterval( 0)            333333
>       VideoStreaming Interface Descriptor:
>         bLength                            30
>         bDescriptorType                    36
>         bDescriptorSubtype                  5 (FRAME_UNCOMPRESSED)
>         bFrameIndex                         2
>         bmCapabilities                   0x00
>           Still image unsupported
>         wWidth                           1280
>         wHeight                           481
>         dwMinBitRate                443289600
>         dwMaxBitRate                443289600
>         dwMaxVideoFrameBufferSize      615680
>         dwDefaultFrameInterval         111111
>         bFrameIntervalType                  1
>         dwFrameInterval( 0)            111111
> 
> Skip duplicate dimensions in enum_framesizes, let enum_frameintervals list
> the intervals from both frame descriptors. Change set_streamparm to switch
> to the correct frame index when changing the interval. This enables 90 fps
> capture on a Lenovo Explorer Windows Mixed Reality headset.
>
> Signed-off-by: Philipp Zabel <philipp.zabel@gmail.com>
> ---
>  drivers/media/usb/uvc/uvc_v4l2.c | 66 +++++++++++++++++++++++++++----------
>  1 file changed, 50 insertions(+), 16 deletions(-)
> 
> diff --git a/drivers/media/usb/uvc/uvc_v4l2.c
> b/drivers/media/usb/uvc/uvc_v4l2.c index 3e7e283a44a8..7d5bf8d56a99 100644
> --- a/drivers/media/usb/uvc/uvc_v4l2.c
> +++ b/drivers/media/usb/uvc/uvc_v4l2.c
> @@ -373,8 +373,11 @@ static int uvc_v4l2_set_streamparm(struct uvc_streaming
> *stream, {
>  	struct uvc_streaming_control probe;
>  	struct v4l2_fract timeperframe;
> -	uint32_t interval;
> +	struct uvc_format *format;
> +	struct uvc_frame *frame;
> +	__u32 interval, tmp, d, maxd;

You can declare tmp and d inside the loop, it should simplify the code 
slightly. Please also avoid naming the variable tmp.

>  	int ret;
> +	int i;

i can be unsigned.

>  	if (parm->type != stream->type)
>  		return -EINVAL;
> @@ -396,9 +399,31 @@ static int uvc_v4l2_set_streamparm(struct uvc_streaming
> *stream, return -EBUSY;
>  	}
> 
> +	format = stream->cur_format;
> +	frame = stream->cur_frame;
>  	probe = stream->ctrl;
> -	probe.dwFrameInterval =
> -		uvc_try_frame_interval(stream->cur_frame, interval);
> +	probe.dwFrameInterval = uvc_try_frame_interval(frame, interval);
> +	maxd = abs((__s32)probe.dwFrameInterval - interval);
> +
> +	/* Try frames with matching size to find the best frame interval. */
> +	for (i = 0; i < format->nframes; i++) {

As a small optimization you can also stop when maxd == 0.

> +		if (&format->frame[i] == stream->cur_frame)
> +			continue;
> +
> +		if (format->frame[i].wWidth != stream->cur_frame->wWidth ||
> +		    format->frame[i].wHeight != stream->cur_frame->wHeight)
> +			continue;
> +
> +		tmp = uvc_try_frame_interval(&format->frame[i], interval);
> +		d = abs((__s32)tmp - interval);
> +		if (d >= maxd)
> +			continue;
> +
> +		frame = &format->frame[i];
> +		probe.bFrameIndex = frame->bFrameIndex;
> +		probe.dwFrameInterval = tmp;
> +		maxd = d;
> +	}
> 
>  	/* Probe the device with the new settings. */
>  	ret = uvc_probe_video(stream, &probe);
> @@ -408,6 +433,7 @@ static int uvc_v4l2_set_streamparm(struct uvc_streaming
> *stream, }
> 
>  	stream->ctrl = probe;
> +	stream->cur_frame = frame;
>  	mutex_unlock(&stream->mutex);
> 
>  	/* Return the actual frame period. */
> @@ -1150,7 +1176,7 @@ static int uvc_ioctl_enum_framesizes(struct file
> *file, void *fh, struct uvc_streaming *stream = handle->stream;
>  	struct uvc_format *format = NULL;
>  	struct uvc_frame *frame;
> -	int i;
> +	int i, index;

Could you declare unrelated variables on separate lines ?

I think index can be unsigned (and it seems i can be as well for that matter).

>  	/* Look for the given pixel format */
>  	for (i = 0; i < stream->nformats; i++) {
> @@ -1162,10 +1188,20 @@ static int uvc_ioctl_enum_framesizes(struct file
> *file, void *fh, if (format == NULL)
>  		return -EINVAL;
> 
> -	if (fsize->index >= format->nframes)
> +	/* Skip duplicate frame sizes */
> +	for (i = 0, index = 0; i < format->nframes; i++) {
> +		if (i && frame->wWidth == format->frame[i].wWidth &&
> +		    frame->wHeight == format->frame[i].wHeight)
> +			continue;
> +		frame = &format->frame[i];
> +		if (index == fsize->index)
> +			break;
> +		index++;
> +	}
> +
> +	if (i == format->nframes)
>  		return -EINVAL;
> 
> -	frame = &format->frame[fsize->index];
>  	fsize->type = V4L2_FRMSIZE_TYPE_DISCRETE;
>  	fsize->discrete.width = frame->wWidth;
>  	fsize->discrete.height = frame->wHeight;
> @@ -1179,7 +1215,7 @@ static int uvc_ioctl_enum_frameintervals(struct file
> *file, void *fh, struct uvc_streaming *stream = handle->stream;
>  	struct uvc_format *format = NULL;
>  	struct uvc_frame *frame = NULL;
> -	int i;
> +	int i, index, nintervals;

Same comments here.

>  	/* Look for the given pixel format and frame size */
>  	for (i = 0; i < stream->nformats; i++) {
> @@ -1191,30 +1227,28 @@ static int uvc_ioctl_enum_frameintervals(struct file
> *file, void *fh, if (format == NULL)
>  		return -EINVAL;
> 
> +	index = fival->index;
>  	for (i = 0; i < format->nframes; i++) {
>  		if (format->frame[i].wWidth == fival->width &&
>  		    format->frame[i].wHeight == fival->height) {
>  			frame = &format->frame[i];
> -			break;
> +			nintervals = frame->bFrameIntervalType ?: 1;
> +			if (index < nintervals)
> +				break;
> +			index -= nintervals;
>  		}
>  	}
> -	if (frame == NULL)
> +	if (i == format->nframes)
>  		return -EINVAL;
> 
>  	if (frame->bFrameIntervalType) {
> -		if (fival->index >= frame->bFrameIntervalType)
> -			return -EINVAL;
> -
>  		fival->type = V4L2_FRMIVAL_TYPE_DISCRETE;
>  		fival->discrete.numerator =
> -			frame->dwFrameInterval[fival->index];
> +			frame->dwFrameInterval[index];
>  		fival->discrete.denominator = 10000000;
>  		uvc_simplify_fraction(&fival->discrete.numerator,
>  			&fival->discrete.denominator, 8, 333);
>  	} else {
> -		if (fival->index)
> -			return -EINVAL;
> -
>  		fival->type = V4L2_FRMIVAL_TYPE_STEPWISE;
>  		fival->stepwise.min.numerator = frame->dwFrameInterval[0];
>  		fival->stepwise.min.denominator = 10000000;

I have to say I dislike the complexity added by this patch, but it's not your 
fault. The code itself is probably as clean as it can be :)

-- 
Regards,

Laurent Pinchart
