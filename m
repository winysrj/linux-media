Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([85.220.165.71]:33567 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932742AbeBUKQI (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 21 Feb 2018 05:16:08 -0500
Message-ID: <1519208166.3405.6.camel@pengutronix.de>
Subject: Re: [PATCH v2] media: staging/imx: Implement init_cfg subdev pad op
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Steve Longerbeam <slongerbeam@gmail.com>,
        Hans Verkuil <hans.verkuil@cisco.com>
Cc: linux-media@vger.kernel.org,
        Steve Longerbeam <steve_longerbeam@mentor.com>
Date: Wed, 21 Feb 2018 11:16:06 +0100
In-Reply-To: <1518373774-3520-1-git-send-email-steve_longerbeam@mentor.com>
References: <1518373774-3520-1-git-send-email-steve_longerbeam@mentor.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, 2018-02-11 at 10:29 -0800, Steve Longerbeam wrote:
> Implement the init_cfg pad op in all imx-media subdevices. The try
> formats are initialized to the current active formats on all pads.
> 
> Signed-off-by: Steve Longerbeam <steve_longerbeam@mentor.com>
> ---
> Changes since v1:
> - It isn't necessary to acquire the subdev locks in the init_cfg pad
>   op, the op only writes the try_fmt in cfg, and cfg is private to every
>   open subdev fh. Without the need for the lock, init_cfg can be made
>   generic. So this version moves the op to imx-media-utils.c for all
>   subdevs to call. It initializes try_fmt's to the current active formats.
> 
>  drivers/staging/media/imx/imx-ic-prp.c      |  1 +
>  drivers/staging/media/imx/imx-ic-prpencvf.c |  1 +
>  drivers/staging/media/imx/imx-media-csi.c   |  1 +
>  drivers/staging/media/imx/imx-media-utils.c | 29 +++++++++++++++++++++++++++++
>  drivers/staging/media/imx/imx-media-vdic.c  |  1 +
>  drivers/staging/media/imx/imx-media.h       |  2 ++
>  drivers/staging/media/imx/imx6-mipi-csi2.c  |  1 +
>  7 files changed, 36 insertions(+)
> 
> diff --git a/drivers/staging/media/imx/imx-ic-prp.c b/drivers/staging/media/imx/imx-ic-prp.c
> index c6d7e80..98923fc 100644
> --- a/drivers/staging/media/imx/imx-ic-prp.c
> +++ b/drivers/staging/media/imx/imx-ic-prp.c
> @@ -462,6 +462,7 @@ static int prp_registered(struct v4l2_subdev *sd)
>  }
>  
>  static const struct v4l2_subdev_pad_ops prp_pad_ops = {
> +	.init_cfg = imx_media_init_cfg,
>  	.enum_mbus_code = prp_enum_mbus_code,
>  	.get_fmt = prp_get_fmt,
>  	.set_fmt = prp_set_fmt,
> diff --git a/drivers/staging/media/imx/imx-ic-prpencvf.c b/drivers/staging/media/imx/imx-ic-prpencvf.c
> index 143038c..72de7f6 100644
> --- a/drivers/staging/media/imx/imx-ic-prpencvf.c
> +++ b/drivers/staging/media/imx/imx-ic-prpencvf.c
> @@ -1253,6 +1253,7 @@ static void prp_unregistered(struct v4l2_subdev *sd)
>  }
>  
>  static const struct v4l2_subdev_pad_ops prp_pad_ops = {
> +	.init_cfg = imx_media_init_cfg,
>  	.enum_mbus_code = prp_enum_mbus_code,
>  	.enum_frame_size = prp_enum_frame_size,
>  	.get_fmt = prp_get_fmt,
> diff --git a/drivers/staging/media/imx/imx-media-csi.c b/drivers/staging/media/imx/imx-media-csi.c
> index eb7be50..4ef6e7a 100644
> --- a/drivers/staging/media/imx/imx-media-csi.c
> +++ b/drivers/staging/media/imx/imx-media-csi.c
> @@ -1715,6 +1715,7 @@ static const struct v4l2_subdev_video_ops csi_video_ops = {
>  };
>  
>  static const struct v4l2_subdev_pad_ops csi_pad_ops = {
> +	.init_cfg = imx_media_init_cfg,
>  	.enum_mbus_code = csi_enum_mbus_code,
>  	.enum_frame_size = csi_enum_frame_size,
>  	.enum_frame_interval = csi_enum_frame_interval,
> diff --git a/drivers/staging/media/imx/imx-media-utils.c b/drivers/staging/media/imx/imx-media-utils.c
> index 13dafa7..8920f9b 100644
> --- a/drivers/staging/media/imx/imx-media-utils.c
> +++ b/drivers/staging/media/imx/imx-media-utils.c
> @@ -465,6 +465,35 @@ int imx_media_init_mbus_fmt(struct v4l2_mbus_framefmt *mbus,
>  EXPORT_SYMBOL_GPL(imx_media_init_mbus_fmt);
>  
>  /*
> + * Initializes the TRY format to the ACTIVE format on all pads
> + * of a subdev. Can be used as the .init_cfg pad operation.
> + */
> +int imx_media_init_cfg(struct v4l2_subdev *sd,
> +		       struct v4l2_subdev_pad_config *cfg)
> +{
> +	struct v4l2_mbus_framefmt *mf_try;
> +	struct v4l2_subdev_format format;
> +	unsigned int pad;
> +	int ret;
> +
> +	for (pad = 0; pad < sd->entity.num_pads; pad++) {
> +		memset(&format, 0, sizeof(format));
> +
> +		format.pad = pad;
> +		format.which = V4L2_SUBDEV_FORMAT_ACTIVE;
> +		ret = v4l2_subdev_call(sd, pad, get_fmt, NULL, &format);
> +		if (ret)
> +			continue;
> +
> +		mf_try = v4l2_subdev_get_try_format(sd, cfg, pad);
> +		*mf_try = format.format;
> +	}
> +
> +	return 0;
> +}
> +EXPORT_SYMBOL_GPL(imx_media_init_cfg);
> +
> +/*
>   * Check whether the field and colorimetry parameters in tryfmt are
>   * uninitialized, and if so fill them with the values from fmt,
>   * or if tryfmt->colorspace has been initialized, all the default
> diff --git a/drivers/staging/media/imx/imx-media-vdic.c b/drivers/staging/media/imx/imx-media-vdic.c
> index 433474d..2246963 100644
> --- a/drivers/staging/media/imx/imx-media-vdic.c
> +++ b/drivers/staging/media/imx/imx-media-vdic.c
> @@ -909,6 +909,7 @@ static void vdic_unregistered(struct v4l2_subdev *sd)
>  }
>  
>  static const struct v4l2_subdev_pad_ops vdic_pad_ops = {
> +	.init_cfg = imx_media_init_cfg,
>  	.enum_mbus_code = vdic_enum_mbus_code,
>  	.get_fmt = vdic_get_fmt,
>  	.set_fmt = vdic_set_fmt,
> diff --git a/drivers/staging/media/imx/imx-media.h b/drivers/staging/media/imx/imx-media.h
> index 2fd6dfd..e945e0e 100644
> --- a/drivers/staging/media/imx/imx-media.h
> +++ b/drivers/staging/media/imx/imx-media.h
> @@ -172,6 +172,8 @@ int imx_media_enum_ipu_format(u32 *code, u32 index, enum codespace_sel cs_sel);
>  int imx_media_init_mbus_fmt(struct v4l2_mbus_framefmt *mbus,
>  			    u32 width, u32 height, u32 code, u32 field,
>  			    const struct imx_media_pixfmt **cc);
> +int imx_media_init_cfg(struct v4l2_subdev *sd,
> +		       struct v4l2_subdev_pad_config *cfg);
>  void imx_media_fill_default_mbus_fields(struct v4l2_mbus_framefmt *tryfmt,
>  					struct v4l2_mbus_framefmt *fmt,
>  					bool ic_route);
> diff --git a/drivers/staging/media/imx/imx6-mipi-csi2.c b/drivers/staging/media/imx/imx6-mipi-csi2.c
> index 477d191..f74c610 100644
> --- a/drivers/staging/media/imx/imx6-mipi-csi2.c
> +++ b/drivers/staging/media/imx/imx6-mipi-csi2.c
> @@ -531,6 +531,7 @@ static const struct v4l2_subdev_video_ops csi2_video_ops = {
>  };
>  
>  static const struct v4l2_subdev_pad_ops csi2_pad_ops = {
> +	.init_cfg = imx_media_init_cfg,
>  	.get_fmt = csi2_get_fmt,
>  	.set_fmt = csi2_set_fmt,
>  };

Reviewed-by: Philipp Zabel <p.zabel@pengutronix.de>

regards
Philipp
