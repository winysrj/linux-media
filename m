Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:36954 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1754076AbdJIUYA (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 9 Oct 2017 16:24:00 -0400
Date: Mon, 9 Oct 2017 23:23:56 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Linux Doc Mailing List <linux-doc@vger.kernel.org>
Subject: Re: [PATCH 15/24] media: v4l2-subdev: get rid of
 __V4L2_SUBDEV_MK_GET_TRY() macro
Message-ID: <20171009202355.ckhaf5xcba5z4tvh@valkosipuli.retiisi.org.uk>
References: <cover.1507544011.git.mchehab@s-opensource.com>
 <63937cedcefd1c56b211ec115b717510c470bd1a.1507544011.git.mchehab@s-opensource.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <63937cedcefd1c56b211ec115b717510c470bd1a.1507544011.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

On Mon, Oct 09, 2017 at 07:19:21AM -0300, Mauro Carvalho Chehab wrote:
> The __V4L2_SUBDEV_MK_GET_TRY() macro is used to define
> 3 functions that have the same arguments. The code of those
> functions is simple enough to just declare them, de-obfuscating
> the code.
> 
> While here, replace BUG_ON() by WARN_ON() as there's no reason
> why to panic the Kernel if this fails.

BUG_ON() might actually be a better idea as this will lead to memory
corruption. I presume it's not been hit often.

That said, I, too, favour WARN_ON() in this case. In case pad exceeds the
number of pads, then zero could be used, for instance. The only real
problem comes if there were no pads to begin with. The callers of these
functions also don't expect to receive NULL. Another option would be to
define a static, dummy variable for the purpose that would be at least safe
to access. Or we could just use the dummy entry whenever the pad isn't
valid.

This will make the functions more complex and I might just keep the
original macro. Even grep works on it nowadays.

> 
> Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
> ---
>  include/media/v4l2-subdev.h | 37 +++++++++++++++++++++++++------------
>  1 file changed, 25 insertions(+), 12 deletions(-)
> 
> diff --git a/include/media/v4l2-subdev.h b/include/media/v4l2-subdev.h
> index 1f34045f07ce..35c4476c56ee 100644
> --- a/include/media/v4l2-subdev.h
> +++ b/include/media/v4l2-subdev.h
> @@ -897,19 +897,32 @@ struct v4l2_subdev_fh {
>  	container_of(fh, struct v4l2_subdev_fh, vfh)
>  
>  #if defined(CONFIG_VIDEO_V4L2_SUBDEV_API)
> -#define __V4L2_SUBDEV_MK_GET_TRY(rtype, fun_name, field_name)		\
> -	static inline struct rtype *					\
> -	fun_name(struct v4l2_subdev *sd,				\
> -		 struct v4l2_subdev_pad_config *cfg,			\
> -		 unsigned int pad)					\
> -	{								\
> -		BUG_ON(pad >= sd->entity.num_pads);			\
> -		return &cfg[pad].field_name;				\
> -	}
> +static inline struct v4l2_mbus_framefmt
> +*v4l2_subdev_get_try_format(struct v4l2_subdev *sd,
> +			    struct v4l2_subdev_pad_config *cfg,
> +			    unsigned int pad)
> +{
> +	WARN_ON(pad >= sd->entity.num_pads);
> +	return &cfg[pad].try_fmt;
> +}
>  
> -__V4L2_SUBDEV_MK_GET_TRY(v4l2_mbus_framefmt, v4l2_subdev_get_try_format, try_fmt)
> -__V4L2_SUBDEV_MK_GET_TRY(v4l2_rect, v4l2_subdev_get_try_crop, try_crop)
> -__V4L2_SUBDEV_MK_GET_TRY(v4l2_rect, v4l2_subdev_get_try_compose, try_compose)
> +static inline struct v4l2_rect
> +*v4l2_subdev_get_try_crop(struct v4l2_subdev *sd,
> +			  struct v4l2_subdev_pad_config *cfg,
> +			  unsigned int pad)
> +{
> +	WARN_ON(pad >= sd->entity.num_pads);
> +	return &cfg[pad].try_crop;
> +}
> +
> +static inline struct v4l2_rect
> +*v4l2_subdev_get_try_compose(struct v4l2_subdev *sd,
> +			     struct v4l2_subdev_pad_config *cfg,
> +			     unsigned int pad)
> +{
> +	WARN_ON(pad >= sd->entity.num_pads);
> +	return &cfg[pad].try_compose;
> +}
>  #endif
>  
>  extern const struct v4l2_file_operations v4l2_subdev_fops;

-- 
Kind regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi
