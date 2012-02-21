Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:54159 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754354Ab2BUOmr (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 21 Feb 2012 09:42:47 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: linux-media@vger.kernel.org, hverkuil@xs4all.nl,
	teturtia@gmail.com, dacohen@gmail.com, snjw23@gmail.com,
	andriy.shevchenko@linux.intel.com, t.stanislaws@samsung.com,
	tuukkat76@gmail.com, k.debski@gmail.com, riverful@gmail.com
Subject: Re: [PATCH v3 06/33] v4l: Check pad number in get try pointer functions
Date: Tue, 21 Feb 2012 15:42:46 +0100
Message-ID: <13169127.hYcu4cXEAL@avalon>
In-Reply-To: <1329703032-31314-6-git-send-email-sakari.ailus@iki.fi>
References: <20120220015605.GI7784@valkosipuli.localdomain> <1329703032-31314-6-git-send-email-sakari.ailus@iki.fi>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

Thanks for the patch.

On Monday 20 February 2012 03:56:45 Sakari Ailus wrote:
> Unify functions to get try pointers and validate the pad number accessed by
> the user.
> 
> Signed-off-by: Sakari Ailus <sakari.ailus@iki.fi>
> ---
>  include/media/v4l2-subdev.h |   31 ++++++++++++++-----------------
>  1 files changed, 14 insertions(+), 17 deletions(-)
> 
> diff --git a/include/media/v4l2-subdev.h b/include/media/v4l2-subdev.h
> index bcaf6b8..d48dae5 100644
> --- a/include/media/v4l2-subdev.h
> +++ b/include/media/v4l2-subdev.h
> @@ -565,23 +565,20 @@ struct v4l2_subdev_fh {
>  	container_of(fh, struct v4l2_subdev_fh, vfh)
> 
>  #if defined(CONFIG_VIDEO_V4L2_SUBDEV_API)
> -static inline struct v4l2_mbus_framefmt *
> -v4l2_subdev_get_try_format(struct v4l2_subdev_fh *fh, unsigned int pad)
> -{
> -	return &fh->pad[pad].try_fmt;
> -}
> -
> -static inline struct v4l2_rect *
> -v4l2_subdev_get_try_crop(struct v4l2_subdev_fh *fh, unsigned int pad)
> -{
> -	return &fh->pad[pad].try_crop;
> -}
> -
> -static inline struct v4l2_rect *
> -v4l2_subdev_get_try_compose(struct v4l2_subdev_fh *fh, unsigned int pad)
> -{
> -	return &fh->pad[pad].try_compose;
> -}
> +#define __V4L2_SUBDEV_MK_GET_TRY(rtype, fun_name, field_name)		\
> +	static inline struct rtype *					\
> +	v4l2_subdev_get_try_##fun_name(struct v4l2_subdev_fh *fh,	\
> +				       unsigned int pad)		\
> +	{								\
> +		if (unlikely(pad > vdev_to_v4l2_subdev(			\
> +				     fh->vfh.vdev->entity.num_pads)	\
> +			return NULL;					\
> +		return &fh->pad[pad].field_name;			\
> +	}
> +
> +__V4L2_SUBDEV_MK_GET_TRY(v4l2_mbus_framefmt, format, try_fmt)
> +__V4L2_SUBDEV_MK_GET_TRY(v4l2_rect, crop, try_compose)
> +__V4L2_SUBDEV_MK_GET_TRY(v4l2_rect, compose, try_compose)
>  #endif
> 
>  extern const struct v4l2_file_operations v4l2_subdev_fops;

I'm not sure if this is a good idea. Drivers usually access the active and try 
formats/rectangles through a single function that checks the which argument 
and returns the active format/rectangle from the driver-specific device 
structure, or calls v4l2_subdev_get_try_*. The pad number should be checked 
for both active and try formats/rectangles, as both can result in accessing a 
wrong memory location.

Furthermore, only in-kernel access to the active/try formats/rectangles need 
to be checked, as the pad argument to subdev ioctls are already checked in 
v4l2-subdev.c. If your goal is to catch buggy kernel code here, a BUG_ON might 
be more suitable (although accessing the NULL pointer would result in an oops 
anyway).

-- 
Regards,

Laurent Pinchart
