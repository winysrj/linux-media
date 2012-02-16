Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.nokia.com ([147.243.1.48]:27386 "EHLO mgw-sa02.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752650Ab2BPWpI (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 16 Feb 2012 17:45:08 -0500
Message-ID: <4F3D86E5.9020809@iki.fi>
Date: Fri, 17 Feb 2012 00:44:53 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
MIME-Version: 1.0
To: Sylwester Nawrocki <s.nawrocki@samsung.com>
CC: linux-media@vger.kernel.org, g.liakhovetski@gmx.de,
	laurent.pinchart@ideasonboard.com, m.szyprowski@samsung.com,
	riverful.kim@samsung.com, sw0312.kim@samsung.com,
	Kyungmin Park <kyungmin.park@samsung.com>
Subject: Re: [RFC/PATCH 4/6] V4L: Add get/set_frame_config subdev callbacks
References: <1329416639-19454-1-git-send-email-s.nawrocki@samsung.com> <1329416639-19454-5-git-send-email-s.nawrocki@samsung.com>
In-Reply-To: <1329416639-19454-5-git-send-email-s.nawrocki@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sylwester,

Thanks for the patch.

Sylwester Nawrocki wrote:
> Add subdev callbacks for setting up parameters of frame on media bus that
> are not exposed to user space directly. This is more a stub containing
> only parameters needed to setup V4L2_MBUS_FMT_VYUY_JPEG_I1_1X8 data
> transmision and the associated frame embedded data.
> 
> The @length field of struct v4l2_frame_config determines maximum number
> of frame samples per frame, excluding embedded non-image data.
> 
> @header_length and @footer length determine the size in bytes of data
> embedded at frame beginning and end respectively.
> 
> Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
> ---
>  include/media/v4l2-subdev.h |   18 ++++++++++++++++++
>  1 files changed, 18 insertions(+), 0 deletions(-)
> 
> diff --git a/include/media/v4l2-subdev.h b/include/media/v4l2-subdev.h
> index be74061..bd95f00 100644
> --- a/include/media/v4l2-subdev.h
> +++ b/include/media/v4l2-subdev.h
> @@ -21,6 +21,7 @@
>  #ifndef _V4L2_SUBDEV_H
>  #define _V4L2_SUBDEV_H
>  
> +#include <linux/types.h>
>  #include <linux/v4l2-subdev.h>
>  #include <media/media-entity.h>
>  #include <media/v4l2-common.h>
> @@ -45,6 +46,7 @@ struct v4l2_fh;
>  struct v4l2_subdev;
>  struct v4l2_subdev_fh;
>  struct tuner_setup;
> +struct v4l2_frame_config;
>  
>  /* decode_vbi_line */
>  struct v4l2_decode_vbi_line {
> @@ -476,6 +478,10 @@ struct v4l2_subdev_pad_ops {
>  		       struct v4l2_subdev_crop *crop);
>  	int (*get_crop)(struct v4l2_subdev *sd, struct v4l2_subdev_fh *fh,
>  		       struct v4l2_subdev_crop *crop);
> +	int (*set_frame_config)(struct v4l2_subdev *sd, unsigned int pad,
> +				struct v4l2_frame_config *fc);
> +	int (*get_frame_config)(struct v4l2_subdev *sd, unsigned int pad,
> +				struct v4l2_frame_config *fc);
>  };
>  
>  struct v4l2_subdev_ops {
> @@ -567,6 +573,18 @@ struct v4l2_subdev_fh {
>  #define to_v4l2_subdev_fh(fh)	\
>  	container_of(fh, struct v4l2_subdev_fh, vfh)
>  
> +/**
> + * struct v4l2_frame_config - media bus data frame configuration
> + * @length: maximum number of media bus samples per frame
> + * @header_length: size of embedded data at frame start (header)
> + * @footer_length: size of embedded data at frame end (footer)
> + */
> +struct v4l2_frame_config {
> +	size_t length;
> +	size_t header_length;
> +	size_t footer_length;
> +};
> +
>  #if defined(CONFIG_VIDEO_V4L2_SUBDEV_API)
>  static inline struct v4l2_mbus_framefmt *
>  v4l2_subdev_get_try_format(struct v4l2_subdev_fh *fh, unsigned int pad)

I think we need something a little more expressive to describe the
metadata. Preferrably the structure of the whole frame.

Is the size of your metadata measured in just bytes? If we have a frame
that has width and height the metadata is just spread to a number of
lines. That's the case on the SMIA(++) driver, for example.

Is the length field intended to be what once was planned in
v4l2_mbus_framefmt and later on as a control?

Also, only some receivers will be able to separate the metadata from the
rest of the frame. The above struct doesn't have information on the
format of the metadata either.

I admit that I should have written an RFC on this but it's my general
lack of time that has prevented me from doing that. :-I

Cheers,

-- 
Sakari Ailus
sakari.ailus@iki.fi
