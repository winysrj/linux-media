Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:40428 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751864AbdL0Vb2 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 27 Dec 2017 16:31:28 -0500
Date: Wed, 27 Dec 2017 23:31:24 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [PATCH v2 6/8] media: v4l2-subdev: get rid of
 __V4L2_SUBDEV_MK_GET_TRY() macro
Message-ID: <20171227213124.gn6vzyyrkxmq3ziq@valkosipuli.retiisi.org.uk>
References: <cover.1513682135.git.mchehab@s-opensource.com>
 <e1a835c0f4c43a61bdee2950e1752051c92ca73d.1513682135.git.mchehab@s-opensource.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e1a835c0f4c43a61bdee2950e1752051c92ca73d.1513682135.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

Thanks for the patch. Please see my comments below.

On Tue, Dec 19, 2017 at 09:18:22AM -0200, Mauro Carvalho Chehab wrote:
> The __V4L2_SUBDEV_MK_GET_TRY() macro is used to define
> 3 functions that have the same arguments. The code of those
> functions is simple enough to just declare them, de-obfuscating
> the code.
> 
> While here, replace BUG_ON() by WARN_ON() as there's no reason
> why to panic the Kernel if this fails.
> 
> Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
> ---
>  include/media/v4l2-subdev.h | 40 ++++++++++++++++++++++++++++------------
>  1 file changed, 28 insertions(+), 12 deletions(-)
> 
> diff --git a/include/media/v4l2-subdev.h b/include/media/v4l2-subdev.h
> index 71b8ff4b2e0e..443e5e019006 100644
> --- a/include/media/v4l2-subdev.h
> +++ b/include/media/v4l2-subdev.h
> @@ -896,19 +896,35 @@ struct v4l2_subdev_fh {
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
> +	if (WARN_ON(pad >= sd->entity.num_pads))
> +		pad = 0;
> +	return &cfg[pad].try_fmt;

After I suggested this I came to think what happens if there are no pads?

How about adding, before the first check:

if (WARN_ON(!sd->entity.num_pads))
	return NULL;

Instead of copying the code, you could still use a macro while having the
function declaration itself separate from the macro. Up to you.

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
> +	if (WARN_ON(pad >= sd->entity.num_pads))
> +		pad = 0;
> +	return &cfg[pad].try_crop;
> +}
> +
> +static inline struct v4l2_rect
> +*v4l2_subdev_get_try_compose(struct v4l2_subdev *sd,
> +			     struct v4l2_subdev_pad_config *cfg,
> +			     unsigned int pad)
> +{
> +	if (WARN_ON(pad >= sd->entity.num_pads))
> +		pad = 0;
> +	return &cfg[pad].try_compose;
> +}
>  #endif
>  
>  extern const struct v4l2_file_operations v4l2_subdev_fops;
> -- 
> 2.14.3
> 

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi
