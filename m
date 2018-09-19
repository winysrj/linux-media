Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:50318 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727948AbeISQWY (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 19 Sep 2018 12:22:24 -0400
Date: Wed, 19 Sep 2018 13:45:02 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Marco Felsch <m.felsch@pengutronix.de>
Cc: mchehab@kernel.org, robh+dt@kernel.org, mark.rutland@arm.com,
        kernel@pengutronix.de, devicetree@vger.kernel.org,
        p.zabel@pengutronix.de, javierm@redhat.com,
        laurent.pinchart@ideasonboard.com, sakari.ailus@linux.intel.com,
        afshin.nasser@gmail.com, linux-media@vger.kernel.org
Subject: Re: [PATCH v3 6/9] media: v4l2-subdev: fix v4l2_subdev_get_try_*
 dependency
Message-ID: <20180919104502.2ex2yhwf7fltmnco@valkosipuli.retiisi.org.uk>
References: <20180918131453.21031-1-m.felsch@pengutronix.de>
 <20180918131453.21031-7-m.felsch@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180918131453.21031-7-m.felsch@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Marco,

On Tue, Sep 18, 2018 at 03:14:50PM +0200, Marco Felsch wrote:
> These helpers make us of the media-controller entity which is only
> available if the CONFIG_MEDIA_CONTROLLER is enabled.
> 
> Signed-off-by: Marco Felsch <m.felsch@pengutronix.de>
> ---
> Changelog:
> 
> v3:
> - add CONFIG_MEDIA_CONTROLLER switch instead of moving the
>   v4l2_subdev_get_try_* APIs into the existing one.
> 
> v2:
> - Initial commit
> 
>  include/media/v4l2-subdev.h | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/include/media/v4l2-subdev.h b/include/media/v4l2-subdev.h
> index ce48f1fcf295..d2479d5ebca8 100644
> --- a/include/media/v4l2-subdev.h
> +++ b/include/media/v4l2-subdev.h
> @@ -912,6 +912,8 @@ struct v4l2_subdev_fh {
>  #define to_v4l2_subdev_fh(fh)	\
>  	container_of(fh, struct v4l2_subdev_fh, vfh)
>  
> +#ifdef CONFIG_MEDIA_CONTROLLER

VIDEO_V4L2_SUBDEV_API (used below) depends on MEDIA_CONTROLLER. Either this
or the previous patch would be meaningful but not both.

Considering a driver wouldn't use the functions below if it did not need or
could use VIDEO_V4L2_SUBDEV_API, I'd suggest retaining the other patch.

> +
>  /**
>   * v4l2_subdev_get_try_format - ancillary routine to call
>   *	&struct v4l2_subdev_pad_config->try_fmt
> @@ -978,6 +980,8 @@ static inline struct v4l2_rect
>  #endif
>  }
>  
> +#endif
> +
>  extern const struct v4l2_file_operations v4l2_subdev_fops;
>  
>  /**

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi
