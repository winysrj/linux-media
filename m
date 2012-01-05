Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:37060 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757613Ab2AEQNk (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 5 Jan 2012 11:13:40 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>
Subject: Re: [RFC 05/17] v4l: Support s_crop and g_crop through s/g_selection
Date: Thu, 5 Jan 2012 17:13:57 +0100
Cc: linux-media@vger.kernel.org, dacohen@gmail.com, snjw23@gmail.com
References: <4EF0EFC9.6080501@maxwell.research.nokia.com> <1324412889-17961-5-git-send-email-sakari.ailus@maxwell.research.nokia.com>
In-Reply-To: <1324412889-17961-5-git-send-email-sakari.ailus@maxwell.research.nokia.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201201051713.58513.laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

Thanks for the patch.

On Tuesday 20 December 2011 21:27:57 Sakari Ailus wrote:
> From: Sakari Ailus <sakari.ailus@iki.fi>
> 
> Revert to s_selection if s_crop isn't implemented by a driver. Same for
> g_selection / g_crop.

Shouldn't this say "Fall back" instead of "Revert" ?

> Signed-off-by: Sakari Ailus <sakari.ailus@iki.fi>
> ---
>  drivers/media/video/v4l2-subdev.c |   37
> +++++++++++++++++++++++++++++++++++-- 1 files changed, 35 insertions(+), 2
> deletions(-)
> 
> diff --git a/drivers/media/video/v4l2-subdev.c
> b/drivers/media/video/v4l2-subdev.c index e8ae098..f8de551 100644
> --- a/drivers/media/video/v4l2-subdev.c
> +++ b/drivers/media/video/v4l2-subdev.c
> @@ -226,6 +226,8 @@ static long subdev_do_ioctl(struct file *file, unsigned
> int cmd, void *arg)
> 
>  	case VIDIOC_SUBDEV_G_CROP: {
>  		struct v4l2_subdev_crop *crop = arg;
> +		struct v4l2_subdev_selection sel;
> +		int rval;
> 
>  		if (crop->which != V4L2_SUBDEV_FORMAT_TRY &&
>  		    crop->which != V4L2_SUBDEV_FORMAT_ACTIVE)
> @@ -234,11 +236,27 @@ static long subdev_do_ioctl(struct file *file,
> unsigned int cmd, void *arg) if (crop->pad >= sd->entity.num_pads)
>  			return -EINVAL;
> 
> -		return v4l2_subdev_call(sd, pad, get_crop, subdev_fh, crop);
> +		rval = v4l2_subdev_call(sd, pad, get_crop, subdev_fh, crop);
> +		if (rval != -ENOIOCTLCMD)
> +			return rval;
> +
> +		memset(&sel, 0, sizeof(sel));
> +		sel.which = V4L2_SUBDEV_FORMAT_ACTIVE;

Shouldn't sel.which be set to crop->which ?

> +		sel.pad = crop->pad;
> +		sel.target = V4L2_SUBDEV_SEL_TGT_CROP_ACTIVE;
> +
> +		rval = v4l2_subdev_call(
> +			sd, pad, get_selection, subdev_fh, &sel);
> +
> +		crop->rect = sel.r;
> +
> +		return rval;
>  	}
> 
>  	case VIDIOC_SUBDEV_S_CROP: {
>  		struct v4l2_subdev_crop *crop = arg;
> +		struct v4l2_subdev_selection sel;
> +		int rval;
> 
>  		if (crop->which != V4L2_SUBDEV_FORMAT_TRY &&
>  		    crop->which != V4L2_SUBDEV_FORMAT_ACTIVE)
> @@ -247,7 +265,22 @@ static long subdev_do_ioctl(struct file *file,
> unsigned int cmd, void *arg) if (crop->pad >= sd->entity.num_pads)
>  			return -EINVAL;
> 
> -		return v4l2_subdev_call(sd, pad, set_crop, subdev_fh, crop);
> +		rval = v4l2_subdev_call(sd, pad, set_crop, subdev_fh, crop);
> +		if (rval != -ENOIOCTLCMD)
> +			return rval;
> +
> +		memset(&sel, 0, sizeof(sel));
> +		sel.which = V4L2_SUBDEV_FORMAT_ACTIVE;

Same here.

> +		sel.pad = crop->pad;
> +		sel.target = V4L2_SUBDEV_SEL_TGT_CROP_ACTIVE;
> +		sel.r = crop->rect;
> +
> +		rval = v4l2_subdev_call(
> +			sd, pad, set_selection, subdev_fh, &sel);
> +
> +		crop->rect = sel.r;
> +
> +		return rval;
>  	}
> 
>  	case VIDIOC_SUBDEV_ENUM_MBUS_CODE: {

-- 
Regards,

Laurent Pinchart
