Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga07.intel.com ([134.134.136.100]:14409 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727611AbeINSkM (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 14 Sep 2018 14:40:12 -0400
Date: Fri, 14 Sep 2018 16:25:38 +0300
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: Marco Felsch <m.felsch@pengutronix.de>
Cc: mchehab@kernel.org, robh+dt@kernel.org, mark.rutland@arm.com,
        kernel@pengutronix.de, devicetree@vger.kernel.org,
        p.zabel@pengutronix.de, javierm@redhat.com,
        laurent.pinchart@ideasonboard.com, afshin.nasser@gmail.com,
        linux-media@vger.kernel.org
Subject: Re: [PATCH v2 4/7] [media] v4l2-subdev: fix v4l2_subdev_get_try_*
 dependency
Message-ID: <20180914132538.5anptpaqt6cgkxow@paasikivi.fi.intel.com>
References: <20180813092508.1334-1-m.felsch@pengutronix.de>
 <20180813092508.1334-5-m.felsch@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180813092508.1334-5-m.felsch@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Marco,

On Mon, Aug 13, 2018 at 11:25:05AM +0200, Marco Felsch wrote:
> These helpers make us of the media-controller entity which is only
> available if the CONFIG_MEDIA_CONTROLLER is enabled.
> 
> Signed-off-by: Marco Felsch <m.felsch@pengutronix.de>
> ---
>  include/media/v4l2-subdev.h | 100 ++++++++++++++++++------------------
>  1 file changed, 50 insertions(+), 50 deletions(-)
> 
> diff --git a/include/media/v4l2-subdev.h b/include/media/v4l2-subdev.h
> index ce48f1fcf295..79c066934ad2 100644
> --- a/include/media/v4l2-subdev.h
> +++ b/include/media/v4l2-subdev.h
> @@ -912,6 +912,56 @@ struct v4l2_subdev_fh {
>  #define to_v4l2_subdev_fh(fh)	\
>  	container_of(fh, struct v4l2_subdev_fh, vfh)
>  
> +extern const struct v4l2_file_operations v4l2_subdev_fops;
> +
> +/**
> + * v4l2_set_subdevdata - Sets V4L2 dev private device data
> + *
> + * @sd: pointer to &struct v4l2_subdev
> + * @p: pointer to the private device data to be stored.
> + */
> +static inline void v4l2_set_subdevdata(struct v4l2_subdev *sd, void *p)
> +{
> +	sd->dev_priv = p;
> +}
> +
> +/**
> + * v4l2_get_subdevdata - Gets V4L2 dev private device data
> + *
> + * @sd: pointer to &struct v4l2_subdev
> + *
> + * Returns the pointer to the private device data to be stored.
> + */
> +static inline void *v4l2_get_subdevdata(const struct v4l2_subdev *sd)
> +{
> +	return sd->dev_priv;
> +}
> +
> +/**
> + * v4l2_set_subdev_hostdata - Sets V4L2 dev private host data
> + *
> + * @sd: pointer to &struct v4l2_subdev
> + * @p: pointer to the private data to be stored.
> + */
> +static inline void v4l2_set_subdev_hostdata(struct v4l2_subdev *sd, void *p)
> +{
> +	sd->host_priv = p;
> +}
> +
> +/**
> + * v4l2_get_subdev_hostdata - Gets V4L2 dev private data
> + *
> + * @sd: pointer to &struct v4l2_subdev
> + *
> + * Returns the pointer to the private host data to be stored.
> + */
> +static inline void *v4l2_get_subdev_hostdata(const struct v4l2_subdev *sd)
> +{
> +	return sd->host_priv;
> +}

Could you leave the functions dealing with host_priv where they are? I'd
like to avoid expanding their use; rather reduce it. The field is
problematic in some cases and generally not really needed either.

> +
> +#ifdef CONFIG_MEDIA_CONTROLLER
> +
>  /**
>   * v4l2_subdev_get_try_format - ancillary routine to call
>   *	&struct v4l2_subdev_pad_config->try_fmt
> @@ -978,56 +1028,6 @@ static inline struct v4l2_rect
>  #endif
>  }
>  
> -extern const struct v4l2_file_operations v4l2_subdev_fops;
> -
> -/**
> - * v4l2_set_subdevdata - Sets V4L2 dev private device data
> - *
> - * @sd: pointer to &struct v4l2_subdev
> - * @p: pointer to the private device data to be stored.
> - */
> -static inline void v4l2_set_subdevdata(struct v4l2_subdev *sd, void *p)
> -{
> -	sd->dev_priv = p;
> -}
> -
> -/**
> - * v4l2_get_subdevdata - Gets V4L2 dev private device data
> - *
> - * @sd: pointer to &struct v4l2_subdev
> - *
> - * Returns the pointer to the private device data to be stored.
> - */
> -static inline void *v4l2_get_subdevdata(const struct v4l2_subdev *sd)
> -{
> -	return sd->dev_priv;
> -}
> -
> -/**
> - * v4l2_set_subdev_hostdata - Sets V4L2 dev private host data
> - *
> - * @sd: pointer to &struct v4l2_subdev
> - * @p: pointer to the private data to be stored.
> - */
> -static inline void v4l2_set_subdev_hostdata(struct v4l2_subdev *sd, void *p)
> -{
> -	sd->host_priv = p;
> -}
> -
> -/**
> - * v4l2_get_subdev_hostdata - Gets V4L2 dev private data
> - *
> - * @sd: pointer to &struct v4l2_subdev
> - *
> - * Returns the pointer to the private host data to be stored.
> - */
> -static inline void *v4l2_get_subdev_hostdata(const struct v4l2_subdev *sd)
> -{
> -	return sd->host_priv;
> -}
> -
> -#ifdef CONFIG_MEDIA_CONTROLLER
> -
>  /**
>   * v4l2_subdev_link_validate_default - validates a media link
>   *

-- 
Kind regards,

Sakari Ailus
sakari.ailus@linux.intel.com
