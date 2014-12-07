Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:38375 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752606AbaLGXhK (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 7 Dec 2014 18:37:10 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org, g.liakhovetski@gmx.de,
	prabhakar.csengg@gmail.com, Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [RFC PATCH 4/8] v4l2-subdev: replace v4l2_subdev_fh by v4l2_subdev_pad_config
Date: Mon, 08 Dec 2014 01:37:51 +0200
Message-ID: <3480496.b0HjEnlpTN@avalon>
In-Reply-To: <1417686899-30149-5-git-send-email-hverkuil@xs4all.nl>
References: <1417686899-30149-1-git-send-email-hverkuil@xs4all.nl> <1417686899-30149-5-git-send-email-hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

Thank you for the patch.

On Thursday 04 December 2014 10:54:55 Hans Verkuil wrote:
> From: Hans Verkuil <hans.verkuil@cisco.com>
> 
> If a subdevice pad op is called from a bridge driver, then there is
> no v4l2_subdev_fh struct that can be passed to the subdevice. This
> made it hard to use such subdevs from a bridge driver.
> 
> This patch replaces the v4l2_subdev_fh pointer by a v4l2_subdev_pad_config
> pointer in the pad ops. This allows bridge drivers to use the various
> try_ pad ops by creating a v4l2_subdev_pad_config struct and passing it
> along to the pad op.
> 
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> ---
>  drivers/media/i2c/adv7511.c                        | 16 +++--
>  drivers/media/i2c/adv7604.c                        | 12 ++--
>  drivers/media/i2c/m5mols/m5mols_core.c             | 16 ++---
>  drivers/media/i2c/mt9m032.c                        | 34 ++++-----
>  drivers/media/i2c/mt9p031.c                        | 36 +++++-----
>  drivers/media/i2c/mt9t001.c                        | 36 +++++-----
>  drivers/media/i2c/mt9v032.c                        | 36 +++++-----
>  drivers/media/i2c/noon010pc30.c                    | 17 ++---
>  drivers/media/i2c/ov9650.c                         | 16 ++---
>  drivers/media/i2c/s5c73m3/s5c73m3-core.c           | 51 +++++++-------
>  drivers/media/i2c/s5k4ecgx.c                       | 16 ++---
>  drivers/media/i2c/s5k5baf.c                        | 38 +++++-----
>  drivers/media/i2c/s5k6a3.c                         | 18 ++---
>  drivers/media/i2c/s5k6aa.c                         | 34 ++++-----
>  drivers/media/i2c/smiapp/smiapp-core.c             | 80 +++++++++----------
>  drivers/media/i2c/tvp514x.c                        | 12 ++--
>  drivers/media/i2c/tvp7002.c                        | 14 ++--
>  drivers/media/platform/exynos4-is/fimc-capture.c   | 22 +++---
>  drivers/media/platform/exynos4-is/fimc-isp.c       | 28 ++++----
>  drivers/media/platform/exynos4-is/fimc-lite.c      | 33 ++++-----
>  drivers/media/platform/exynos4-is/mipi-csis.c      | 16 ++---
>  drivers/media/platform/omap3isp/ispccdc.c          | 82  +++++++++---------
>  drivers/media/platform/omap3isp/ispccp2.c          | 44 ++++++------
>  drivers/media/platform/omap3isp/ispcsi2.c          | 40 +++++------
>  drivers/media/platform/omap3isp/isppreview.c       | 70 +++++++++---------
>  drivers/media/platform/omap3isp/ispresizer.c       | 78 ++++++++++---------
>  drivers/media/platform/s3c-camif/camif-capture.c   | 18 ++---
>  drivers/media/platform/vsp1/vsp1_bru.c             | 40 +++++------
>  drivers/media/platform/vsp1/vsp1_entity.c          | 16 ++---
>  drivers/media/platform/vsp1/vsp1_entity.h          |  4 +-
>  drivers/media/platform/vsp1/vsp1_hsit.c            | 16 ++---
>  drivers/media/platform/vsp1/vsp1_lif.c             | 18 ++---
>  drivers/media/platform/vsp1/vsp1_lut.c             | 18 ++---
>  drivers/media/platform/vsp1/vsp1_rwpf.c            | 36 +++++-----
>  drivers/media/platform/vsp1/vsp1_rwpf.h            | 12 ++--
>  drivers/media/platform/vsp1/vsp1_sru.c             | 26 +++----
>  drivers/media/platform/vsp1/vsp1_uds.c             | 26 +++----
>  drivers/media/v4l2-core/v4l2-subdev.c              | 18 ++---
>  drivers/staging/media/davinci_vpfe/dm365_ipipe.c   | 49 +++++++------
>  drivers/staging/media/davinci_vpfe/dm365_ipipeif.c | 47 ++++++-------
>  drivers/staging/media/davinci_vpfe/dm365_isif.c    | 79 +++++++++----------
>  drivers/staging/media/davinci_vpfe/dm365_resizer.c | 59 ++++++++--------
>  drivers/staging/media/omap4iss/iss_csi2.c          | 48 ++++++-------
>  drivers/staging/media/omap4iss/iss_ipipe.c         | 50 ++++++-------
>  drivers/staging/media/omap4iss/iss_ipipeif.c       | 56 +++++++--------
>  drivers/staging/media/omap4iss/iss_resizer.c       | 50 ++++++-------
>  include/media/v4l2-subdev.h                        | 58 ++++++++-------
>  47 files changed, 825 insertions(+), 814 deletions(-)

I've quickly reviewed the Aptina sensor drivers and the OMAP3 ISP, VSP1 and 
OMAP4 ISS drivers. The changes look good to me.

[snip]

> diff --git a/include/media/v4l2-subdev.h b/include/media/v4l2-subdev.h
> index 5beeb87..175dc4f 100644
> --- a/include/media/v4l2-subdev.h
> +++ b/include/media/v4l2-subdev.h

[snip]

> @@ -619,37 +633,31 @@ struct v4l2_subdev {
>  #define vdev_to_v4l2_subdev(vdev) \
>  	((struct v4l2_subdev *)video_get_drvdata(vdev))
> 
> +#define to_v4l2_subdev_fh(fh)	\
> +	container_of(fh, struct v4l2_subdev_fh, vfh)
> +
Is there a reason to move this macro here ?

>  /*
>   * Used for storing subdev information per file handle
>   */
>  struct v4l2_subdev_fh {
>  	struct v4l2_fh vfh;
> -#if defined(CONFIG_VIDEO_V4L2_SUBDEV_API)
> -	struct {
> -		struct v4l2_mbus_framefmt try_fmt;
> -		struct v4l2_rect try_crop;
> -		struct v4l2_rect try_compose;
> -	} *pad;
> -#endif
> +	struct v4l2_subdev_pad_config *pad;
>  };
> 
> -#define to_v4l2_subdev_fh(fh)	\
> -	container_of(fh, struct v4l2_subdev_fh, vfh)
> -
>  #if defined(CONFIG_VIDEO_V4L2_SUBDEV_API)

I think you can drop the CONFIG_VIDEO_V4L2_SUBDEV_API dependency. That could 
be part of a separate patch though.

>  #define __V4L2_SUBDEV_MK_GET_TRY(rtype, fun_name, field_name)		\
>  	static inline struct rtype *					\
> -	v4l2_subdev_get_try_##fun_name(struct v4l2_subdev_fh *fh,	\
> -				       unsigned int pad)		\
> +	fun_name(struct v4l2_subdev *sd,				\
> +		 struct v4l2_subdev_pad_config *cfg,			\
> +		 unsigned int pad)					\
>  	{								\
> -		BUG_ON(pad >= vdev_to_v4l2_subdev(			\
> -					fh->vfh.vdev)->entity.num_pads); \
> -		return &fh->pad[pad].field_name;			\
> +		BUG_ON((pad) >= (sd)->entity.num_pads);			\

No need for the extra parentheses here, pad and sd are function arguments, not 
macro arguments.

> +		return &cfg[pad].field_name;				\
>  	}
> 
> -__V4L2_SUBDEV_MK_GET_TRY(v4l2_mbus_framefmt, format, try_fmt)
> -__V4L2_SUBDEV_MK_GET_TRY(v4l2_rect, crop, try_crop)
> -__V4L2_SUBDEV_MK_GET_TRY(v4l2_rect, compose, try_compose)
> +__V4L2_SUBDEV_MK_GET_TRY(v4l2_mbus_framefmt, v4l2_subdev_get_try_format,
> try_fmt)
> +__V4L2_SUBDEV_MK_GET_TRY(v4l2_rect, v4l2_subdev_get_try_crop,
> try_crop)
> +__V4L2_SUBDEV_MK_GET_TRY(v4l2_rect, v4l2_subdev_get_try_compose,
> try_compose)
> #endif
> 
>  extern const struct v4l2_file_operations v4l2_subdev_fops;

-- 
Regards,

Laurent Pinchart

