Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:36540 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752356AbbDDMyJ (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 4 Apr 2015 08:54:09 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH] uvc: fix cropcap v4l2-compliance failure
Date: Sat, 04 Apr 2015 15:54:32 +0300
Message-ID: <1940034.2TTMDxlMKr@avalon>
In-Reply-To: <551E6326.5030409@xs4all.nl>
References: <551E6326.5030409@xs4all.nl>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

Thank you for the patch.

On Friday 03 April 2015 11:53:42 Hans Verkuil wrote:
> The v4l2-compliance tool expects that if VIDIOC_CROPCAP is defined, then
> VIDIOC_G_SELECTION for TGT_CROP_BOUNDS/DEFAULT is also defined (or COMPOSE
> in the case of an output device).
> 
> In fact, all that a driver has to do to implement cropcap is to support
> those two targets since the v4l2 core will implement cropcap and fill in
> the pixelaspect to 1/1 by default.
> 
> Implementing cropcap is only needed if the pixelaspect isn't square.
> 
> So implement g_selection instead of cropcap in uvc to fix the
> v4l2-compliance failure.
> 
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>

Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

and applied to my tree with a cosmetic change (please see below).

> ---
> diff --git a/drivers/media/usb/uvc/uvc_v4l2.c
> b/drivers/media/usb/uvc/uvc_v4l2.c index 43e953f..7078d3e 100644
> --- a/drivers/media/usb/uvc/uvc_v4l2.c
> +++ b/drivers/media/usb/uvc/uvc_v4l2.c
> @@ -1018,26 +1018,35 @@ static int uvc_ioctl_querymenu(struct file *file,
> void *fh, return uvc_query_v4l2_menu(chain, qm);
>  }
> 
> -static int uvc_ioctl_cropcap(struct file *file, void *fh,
> -			     struct v4l2_cropcap *ccap)
> +static int uvc_ioctl_g_selection(struct file *file, void *fh,
> +				 struct v4l2_selection *sel)
>  {
>  	struct uvc_fh *handle = fh;
>  	struct uvc_streaming *stream = handle->stream;
> 
> -	if (ccap->type != stream->type)
> +	if (sel->type != stream->type)
>  		return -EINVAL;
> 
> -	ccap->bounds.left = 0;
> -	ccap->bounds.top = 0;
> +	switch (sel->target) {
> +	case V4L2_SEL_TGT_CROP_DEFAULT:
> +	case V4L2_SEL_TGT_CROP_BOUNDS:
> +		if (stream->type != V4L2_BUF_TYPE_VIDEO_CAPTURE)
> +			return -EINVAL;
> +		break;
> +	case V4L2_SEL_TGT_COMPOSE_DEFAULT:
> +	case V4L2_SEL_TGT_COMPOSE_BOUNDS:
> +		if (stream->type != V4L2_BUF_TYPE_VIDEO_OUTPUT)
> +			return -EINVAL;
> +		break;
> +	default:
> +		return -EINVAL;
> +	}

I've added a blank line here for improved readability.

> +	sel->r.left = 0;
> +	sel->r.top = 0;
>  	mutex_lock(&stream->mutex);
> -	ccap->bounds.width = stream->cur_frame->wWidth;
> -	ccap->bounds.height = stream->cur_frame->wHeight;
> +	sel->r.width = stream->cur_frame->wWidth;
> +	sel->r.height = stream->cur_frame->wHeight;
>  	mutex_unlock(&stream->mutex);
> -
> -	ccap->defrect = ccap->bounds;
> -
> -	ccap->pixelaspect.numerator = 1;
> -	ccap->pixelaspect.denominator = 1;

And here too.

>  	return 0;
>  }
> 
> @@ -1449,7 +1458,7 @@ const struct v4l2_ioctl_ops uvc_ioctl_ops = {
>  	.vidioc_s_ext_ctrls = uvc_ioctl_s_ext_ctrls,
>  	.vidioc_try_ext_ctrls = uvc_ioctl_try_ext_ctrls,
>  	.vidioc_querymenu = uvc_ioctl_querymenu,
> -	.vidioc_cropcap = uvc_ioctl_cropcap,
> +	.vidioc_g_selection = uvc_ioctl_g_selection,
>  	.vidioc_g_parm = uvc_ioctl_g_parm,
>  	.vidioc_s_parm = uvc_ioctl_s_parm,
>  	.vidioc_enum_framesizes = uvc_ioctl_enum_framesizes,

-- 
Regards,

Laurent Pinchart

