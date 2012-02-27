Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:46201 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753027Ab2B0Ad3 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 26 Feb 2012 19:33:29 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: linux-media@vger.kernel.org, hverkuil@xs4all.nl,
	teturtia@gmail.com, dacohen@gmail.com, snjw23@gmail.com,
	andriy.shevchenko@linux.intel.com, t.stanislaws@samsung.com,
	tuukkat76@gmail.com, k.debski@gmail.com, riverful@gmail.com
Subject: Re: [PATCH v3 06/33] v4l: Check pad number in get try pointer functions
Date: Mon, 27 Feb 2012 01:33:37 +0100
Message-ID: <1369718.FBzRs8PirJ@avalon>
In-Reply-To: <4F45D562.9070705@iki.fi>
References: <20120220015605.GI7784@valkosipuli.localdomain> <13169127.hYcu4cXEAL@avalon> <4F45D562.9070705@iki.fi>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

On Thursday 23 February 2012 07:57:54 Sakari Ailus wrote:
> Laurent Pinchart wrote:
> > On Monday 20 February 2012 03:56:45 Sakari Ailus wrote:
> >> Unify functions to get try pointers and validate the pad number accessed
> >> by
> >> the user.
> >> 
> >> Signed-off-by: Sakari Ailus <sakari.ailus@iki.fi>
> >> ---
> >> 
> >>  include/media/v4l2-subdev.h |   31 ++++++++++++++-----------------
> >>  1 files changed, 14 insertions(+), 17 deletions(-)
> >> 
> >> diff --git a/include/media/v4l2-subdev.h b/include/media/v4l2-subdev.h
> >> index bcaf6b8..d48dae5 100644
> >> --- a/include/media/v4l2-subdev.h
> >> +++ b/include/media/v4l2-subdev.h
> >> @@ -565,23 +565,20 @@ struct v4l2_subdev_fh {
> >> 
> >>  	container_of(fh, struct v4l2_subdev_fh, vfh)
> >>  
> >>  #if defined(CONFIG_VIDEO_V4L2_SUBDEV_API)
> >> 
> >> -static inline struct v4l2_mbus_framefmt *
> >> -v4l2_subdev_get_try_format(struct v4l2_subdev_fh *fh, unsigned int pad)
> >> -{
> >> -	return &fh->pad[pad].try_fmt;
> >> -}
> >> -
> >> -static inline struct v4l2_rect *
> >> -v4l2_subdev_get_try_crop(struct v4l2_subdev_fh *fh, unsigned int pad)
> >> -{
> >> -	return &fh->pad[pad].try_crop;
> >> -}
> >> -
> >> -static inline struct v4l2_rect *
> >> -v4l2_subdev_get_try_compose(struct v4l2_subdev_fh *fh, unsigned int pad)
> >> -{
> >> -	return &fh->pad[pad].try_compose;
> >> -}
> >> +#define __V4L2_SUBDEV_MK_GET_TRY(rtype, fun_name, field_name)		\
> >> +	static inline struct rtype *					\
> >> +	v4l2_subdev_get_try_##fun_name(struct v4l2_subdev_fh *fh,	\
> >> +				       unsigned int pad)		\
> >> +	{								\
> >> +		if (unlikely(pad > vdev_to_v4l2_subdev(			\
> >> +				     fh->vfh.vdev->entity.num_pads)	\
> >> +			return NULL;					\
> >> +		return &fh->pad[pad].field_name;			\
> >> +	}
> >> +
> >> +__V4L2_SUBDEV_MK_GET_TRY(v4l2_mbus_framefmt, format, try_fmt)
> >> +__V4L2_SUBDEV_MK_GET_TRY(v4l2_rect, crop, try_compose)
> >> +__V4L2_SUBDEV_MK_GET_TRY(v4l2_rect, compose, try_compose)
> >> 
> >>  #endif
> >>  
> >>  extern const struct v4l2_file_operations v4l2_subdev_fops;
> > 
> > I'm not sure if this is a good idea. Drivers usually access the active and
> > try formats/rectangles through a single function that checks the which
> > argument and returns the active format/rectangle from the driver-specific
> > device structure, or calls v4l2_subdev_get_try_*. The pad number should
> > be checked for both active and try formats/rectangles, as both can result
> > in accessing a wrong memory location.
> > 
> > Furthermore, only in-kernel access to the active/try formats/rectangles
> > need to be checked, as the pad argument to subdev ioctls are already
> > checked in v4l2-subdev.c. If your goal is to catch buggy kernel code
> > here, a BUG_ON might be more suitable (although accessing the NULL
> > pointer would result in an oops anyway).
> 
> This was basically the reason for the memory corryption issue I had some
> time ago with the driver. The drivers (typically, I guess) need to
> access this data also to validate the following selection rectangles
> inside the subdev.
> 
> The active rectangles are also driver's own property so it's the matter
> of driver to access them properly. In principle the same goes for the
> try rectangles, but the fact still is that this patch would have caught
> the bad accesses right at the time they were made. I feel it's just too
> easy to give the function a faulty pad number --- see the SMIA++ driver
> for an example.
> 
> I'd prefer to keep this change, and also I'm fine with doing BUG()
> instead of returning NULL.

I think I would prefer a BUG() as well. I'm OK with keeping the check. If 
drivers were bug-free this wouldn't be needed at all of course :-)

-- 
Regards,

Laurent Pinchart
