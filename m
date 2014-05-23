Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:53581 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751435AbaEWJYQ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 23 May 2014 05:24:16 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: linux-media@vger.kernel.org
Subject: Re: [PATCH 1/1] v4l: Check pad arguments for [gs]_frame_interval
Date: Fri, 23 May 2014 11:24:28 +0200
Message-ID: <26941099.67PAgQvcPC@avalon>
In-Reply-To: <1396254188-7277-1-git-send-email-sakari.ailus@linux.intel.com>
References: <1396254188-7277-1-git-send-email-sakari.ailus@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

Thank you for the patch.

On Monday 31 March 2014 11:23:08 Sakari Ailus wrote:
> VIDIOC_SUBDEV_[GS]_FRAME_INTERVAL IOCTLs argument structs contain the pad
> field but the validity check was missing. There should be no implications
> security-wise from this since no driver currently uses the pad field in the
> struct.
> 
> Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>

Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

> ---
>  drivers/media/v4l2-core/v4l2-subdev.c | 16 ++++++++++++++--
>  1 file changed, 14 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/media/v4l2-core/v4l2-subdev.c
> b/drivers/media/v4l2-core/v4l2-subdev.c index aea84ac..0ed4c5b 100644
> --- a/drivers/media/v4l2-core/v4l2-subdev.c
> +++ b/drivers/media/v4l2-core/v4l2-subdev.c
> @@ -305,11 +305,23 @@ static long subdev_do_ioctl(struct file *file,
> unsigned int cmd, void *arg) fse);
>  	}
> 
> -	case VIDIOC_SUBDEV_G_FRAME_INTERVAL:
> +	case VIDIOC_SUBDEV_G_FRAME_INTERVAL: {
> +		struct v4l2_subdev_frame_interval *fi = arg;
> +
> +		if (fi->pad >= sd->entity.num_pads)
> +			return -EINVAL;
> +
>  		return v4l2_subdev_call(sd, video, g_frame_interval, arg);
> +	}
> +
> +	case VIDIOC_SUBDEV_S_FRAME_INTERVAL: {
> +		struct v4l2_subdev_frame_interval *fi = arg;
> +
> +		if (fi->pad >= sd->entity.num_pads)
> +			return -EINVAL;
> 
> -	case VIDIOC_SUBDEV_S_FRAME_INTERVAL:
>  		return v4l2_subdev_call(sd, video, s_frame_interval, arg);
> +	}
> 
>  	case VIDIOC_SUBDEV_ENUM_FRAME_INTERVAL: {
>  		struct v4l2_subdev_frame_interval_enum *fie = arg;

-- 
Regards,

Laurent Pinchart

