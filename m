Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud2.xs4all.net ([194.109.24.29]:49443 "EHLO
        lb3-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1754031AbdEHLU5 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 8 May 2017 07:20:57 -0400
Subject: Re: [PATCH v2 4/7] [media] vimc: sen: Support several image formats
To: Helen Koike <helen.koike@collabora.com>,
        linux-media@vger.kernel.org
Cc: jgebben@codeaurora.org, mchehab@osg.samsung.com,
        Sakari Ailus <sakari.ailus@iki.fi>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>
References: <cover.1438891530.git.helen.fornazier@gmail.com>
 <1491604632-23544-1-git-send-email-helen.koike@collabora.com>
 <1491604632-23544-5-git-send-email-helen.koike@collabora.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <37c8b98a-f61a-7032-db30-6a3c1887b513@xs4all.nl>
Date: Mon, 8 May 2017 13:20:52 +0200
MIME-Version: 1.0
In-Reply-To: <1491604632-23544-5-git-send-email-helen.koike@collabora.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 04/08/2017 12:37 AM, Helen Koike wrote:
> Allow user space to change the image format as the frame size, the
> media bus pixel format, colorspace, quantization, field YCbCr encoding
> and the transfer function
> 
> Signed-off-by: Helen Koike <helen.koike@collabora.com>
> 
> ---
> 
> Changes in v2:
> [media] vimc: sen: Support several image formats
> 	- this is a new commit in the serie (the old one was splitted in two)
> 	- add init_cfg to initialize try_fmt
> 	- reorder code in vimc_sen_set_fmt
> 	- allow user space to change all fields from struct v4l2_mbus_framefmt
> 	  (e.g. colospace, quantization, field, xfer_func, ycbcr_enc)
> 	- merge with patch for the enum_mbus_code and enum_frame_size
> 	- change commit message
> 	- add vimc_pix_map_by_index
> 	- rename MIN/MAX macros
> 	- check set_fmt default parameters for quantization, colorspace ...
> 
> 
> ---
>  drivers/media/platform/vimc/vimc-core.c   |   8 ++
>  drivers/media/platform/vimc/vimc-core.h   |  12 +++
>  drivers/media/platform/vimc/vimc-sensor.c | 143 ++++++++++++++++++++++++------
>  3 files changed, 134 insertions(+), 29 deletions(-)
> 
> diff --git a/drivers/media/platform/vimc/vimc-core.c b/drivers/media/platform/vimc/vimc-core.c
> index 7c23735..bc4b1bb 100644
> --- a/drivers/media/platform/vimc/vimc-core.c
> +++ b/drivers/media/platform/vimc/vimc-core.c
> @@ -324,6 +324,14 @@ static const struct vimc_pix_map vimc_pix_map_list[] = {
>  	},
>  };
>  
> +const struct vimc_pix_map *vimc_pix_map_by_index(unsigned int i)
> +{
> +	if (i >= ARRAY_SIZE(vimc_pix_map_list))
> +		return NULL;
> +
> +	return &vimc_pix_map_list[i];
> +}
> +
>  const struct vimc_pix_map *vimc_pix_map_by_code(u32 code)
>  {
>  	unsigned int i;
> diff --git a/drivers/media/platform/vimc/vimc-core.h b/drivers/media/platform/vimc/vimc-core.h
> index 8c3d401..2146672 100644
> --- a/drivers/media/platform/vimc/vimc-core.h
> +++ b/drivers/media/platform/vimc/vimc-core.h
> @@ -21,6 +21,11 @@
>  #include <linux/slab.h>
>  #include <media/v4l2-device.h>
>  
> +#define VIMC_FRAME_MAX_WIDTH 4096
> +#define VIMC_FRAME_MAX_HEIGHT 2160
> +#define VIMC_FRAME_MIN_WIDTH 16
> +#define VIMC_FRAME_MIN_HEIGHT 16
> +
>  /**
>   * struct vimc_pix_map - maps media bus code with v4l2 pixel format
>   *
> @@ -107,6 +112,13 @@ static inline void vimc_pads_cleanup(struct media_pad *pads)
>  int vimc_pipeline_s_stream(struct media_entity *ent, int enable);
>  
>  /**
> + * vimc_pix_map_by_index - get vimc_pix_map struct by its index
> + *
> + * @i:			index of the vimc_pix_map struct in vimc_pix_map_list
> + */
> +const struct vimc_pix_map *vimc_pix_map_by_index(unsigned int i);
> +
> +/**
>   * vimc_pix_map_by_code - get vimc_pix_map struct by media bus code
>   *
>   * @code:		media bus format code defined by MEDIA_BUS_FMT_* macros
> diff --git a/drivers/media/platform/vimc/vimc-sensor.c b/drivers/media/platform/vimc/vimc-sensor.c
> index abb2172..c86b4e6 100644
> --- a/drivers/media/platform/vimc/vimc-sensor.c
> +++ b/drivers/media/platform/vimc/vimc-sensor.c
> @@ -24,8 +24,6 @@
>  
>  #include "vimc-sensor.h"
>  
> -#define VIMC_SEN_FRAME_MAX_WIDTH 4096
> -
>  struct vimc_sen_device {
>  	struct vimc_ent_device ved;
>  	struct v4l2_subdev sd;
> @@ -37,18 +35,41 @@ struct vimc_sen_device {
>  	int frame_size;
>  };
>  
> +static const struct v4l2_mbus_framefmt fmt_default = {
> +	.width = 640,
> +	.height = 480,
> +	.code = MEDIA_BUS_FMT_RGB888_1X24,
> +	.field = V4L2_FIELD_NONE,
> +	.colorspace = V4L2_COLORSPACE_SRGB,
> +	.quantization = V4L2_QUANTIZATION_FULL_RANGE,
> +	.xfer_func = V4L2_XFER_FUNC_SRGB,
> +};
> +
> +static int vimc_sen_init_cfg(struct v4l2_subdev *sd,
> +			     struct v4l2_subdev_pad_config *cfg)
> +{
> +	unsigned int i;
> +
> +	for (i = 0; i < sd->entity.num_pads; i++) {
> +		struct v4l2_mbus_framefmt *mf;
> +
> +		mf = v4l2_subdev_get_try_format(sd, cfg, i);
> +		*mf = fmt_default;
> +	}
> +
> +	return 0;
> +}
> +
>  static int vimc_sen_enum_mbus_code(struct v4l2_subdev *sd,
>  				   struct v4l2_subdev_pad_config *cfg,
>  				   struct v4l2_subdev_mbus_code_enum *code)
>  {
> -	struct vimc_sen_device *vsen =
> -				container_of(sd, struct vimc_sen_device, sd);
> +	const struct vimc_pix_map *vpix = vimc_pix_map_by_index(code->index);
>  
> -	/* TODO: Add support for other codes */
> -	if (code->index)
> +	if (!vpix)
>  		return -EINVAL;
>  
> -	code->code = vsen->mbus_format.code;
> +	code->code = vpix->code;
>  
>  	return 0;
>  }
> @@ -57,33 +78,34 @@ static int vimc_sen_enum_frame_size(struct v4l2_subdev *sd,
>  				    struct v4l2_subdev_pad_config *cfg,
>  				    struct v4l2_subdev_frame_size_enum *fse)
>  {
> -	struct vimc_sen_device *vsen =
> -				container_of(sd, struct vimc_sen_device, sd);
> +	const struct vimc_pix_map *vpix;
>  
> -	/* TODO: Add support to other formats */
>  	if (fse->index)
>  		return -EINVAL;
>  
> -	/* TODO: Add support for other codes */
> -	if (fse->code != vsen->mbus_format.code)
> +	/* Only accept code in the pix map table */
> +	vpix = vimc_pix_map_by_code(fse->code);
> +	if (!vpix)
>  		return -EINVAL;
>  
> -	fse->min_width = vsen->mbus_format.width;
> -	fse->max_width = vsen->mbus_format.width;
> -	fse->min_height = vsen->mbus_format.height;
> -	fse->max_height = vsen->mbus_format.height;
> +	fse->min_width = VIMC_FRAME_MIN_WIDTH;
> +	fse->max_width = VIMC_FRAME_MAX_WIDTH;
> +	fse->min_height = VIMC_FRAME_MIN_HEIGHT;
> +	fse->max_height = VIMC_FRAME_MAX_HEIGHT;
>  
>  	return 0;
>  }
>  
>  static int vimc_sen_get_fmt(struct v4l2_subdev *sd,
>  			    struct v4l2_subdev_pad_config *cfg,
> -			    struct v4l2_subdev_format *format)
> +			    struct v4l2_subdev_format *fmt)
>  {
>  	struct vimc_sen_device *vsen =
>  				container_of(sd, struct vimc_sen_device, sd);
>  
> -	format->format = vsen->mbus_format;
> +	fmt->format = fmt->which == V4L2_SUBDEV_FORMAT_TRY ?
> +		      *v4l2_subdev_get_try_format(sd, cfg, fmt->pad) :
> +		      vsen->mbus_format;
>  
>  	return 0;
>  }
> @@ -110,12 +132,81 @@ static void vimc_sen_tpg_s_format(struct vimc_sen_device *vsen)
>  	tpg_s_xfer_func(&vsen->tpg, vsen->mbus_format.xfer_func);
>  }
>  
> +static void vimc_sen_adjust_fmt(struct v4l2_mbus_framefmt *fmt)
> +{
> +	const struct vimc_pix_map *vpix;
> +
> +	/* Only accept code in the pix map table */
> +	vpix = vimc_pix_map_by_code(fmt->code);
> +	if (!vpix)
> +		fmt->code = fmt_default.code;
> +
> +	fmt->width = clamp_t(u32, fmt->width, VIMC_FRAME_MIN_WIDTH,
> +			     VIMC_FRAME_MAX_WIDTH);
> +	fmt->height = clamp_t(u32, fmt->height, VIMC_FRAME_MIN_HEIGHT,
> +			      VIMC_FRAME_MAX_HEIGHT);

I would expect that width and height need to be multiple of some value.
Height needs to be a multiple of 2 (otherwise you can never support
interlaced formats). Width needs to be a multiple of 2 at minimum as
well.

> +
> +	if (fmt->field == V4L2_FIELD_ANY)
> +		fmt->field = fmt_default.field;
> +
> +	/* Check if values are out of range */
> +	if (fmt->colorspace == V4L2_COLORSPACE_DEFAULT
> +	    || fmt->colorspace > V4L2_COLORSPACE_DCI_P3)
> +		fmt->colorspace = fmt_default.colorspace;

If the colorspace is invalid, then set all four fields to their defaults.

> +	if (fmt->ycbcr_enc == V4L2_YCBCR_ENC_DEFAULT
> +	    || fmt->ycbcr_enc > V4L2_YCBCR_ENC_SMPTE240M)
> +		fmt->ycbcr_enc = fmt_default.ycbcr_enc;
> +	if (fmt->quantization == V4L2_QUANTIZATION_DEFAULT
> +	    || fmt->quantization > V4L2_QUANTIZATION_LIM_RANGE)
> +		fmt->quantization = fmt_default.quantization;
> +	if (fmt->xfer_func == V4L2_XFER_FUNC_DEFAULT
> +	    || fmt->xfer_func > V4L2_XFER_FUNC_SMPTE2084)
> +		fmt->xfer_func = fmt_default.xfer_func;

The _DEFAULT values are all valid for these three fields. If they
have an unknown value, then just reset them to the _DEFAULT value.

> +}
> +
> +static int vimc_sen_set_fmt(struct v4l2_subdev *sd,
> +			    struct v4l2_subdev_pad_config *cfg,
> +			    struct v4l2_subdev_format *fmt)
> +{
> +	struct vimc_sen_device *vsen = v4l2_get_subdevdata(sd);
> +	struct v4l2_mbus_framefmt *mf;
> +
> +	if (fmt->which == V4L2_SUBDEV_FORMAT_ACTIVE) {
> +		/* Do not change the format while stream is on */
> +		if (vsen->frame)
> +			return -EBUSY;
> +
> +		mf = &vsen->mbus_format;
> +	} else {
> +		mf = v4l2_subdev_get_try_format(sd, cfg, fmt->pad);
> +	}
> +
> +	/* Set the new format */
> +	vimc_sen_adjust_fmt(&fmt->format);
> +
> +	dev_dbg(vsen->sd.v4l2_dev->mdev->dev, "%s: format update: "
> +		"old:%dx%d (0x%x, %d, %d, %d, %d) "
> +		"new:%dx%d (0x%x, %d, %d, %d, %d)\n", vsen->sd.name,
> +		/* old */
> +		mf->width, mf->height, mf->code,
> +		mf->colorspace,	mf->quantization,
> +		mf->xfer_func, mf->ycbcr_enc,
> +		/* new */
> +		fmt->format.width, fmt->format.height, fmt->format.code,
> +		fmt->format.colorspace, fmt->format.quantization,
> +		fmt->format.xfer_func, fmt->format.ycbcr_enc);
> +
> +	*mf = fmt->format;
> +
> +	return 0;
> +}
> +
>  static const struct v4l2_subdev_pad_ops vimc_sen_pad_ops = {
> +	.init_cfg		= vimc_sen_init_cfg,
>  	.enum_mbus_code		= vimc_sen_enum_mbus_code,
>  	.enum_frame_size	= vimc_sen_enum_frame_size,
>  	.get_fmt		= vimc_sen_get_fmt,
> -	/* TODO: Add support to other formats */
> -	.set_fmt		= vimc_sen_get_fmt,
> +	.set_fmt		= vimc_sen_set_fmt,
>  };
>  
>  static int vimc_thread_sen(void *data)
> @@ -248,19 +339,13 @@ struct vimc_ent_device *vimc_sen_create(struct v4l2_device *v4l2_dev,
>  	if (ret)
>  		goto err_free_vsen;
>  
> -	/* Set the active frame format (this is hardcoded for now) */
> -	vsen->mbus_format.width = 640;
> -	vsen->mbus_format.height = 480;
> -	vsen->mbus_format.code = MEDIA_BUS_FMT_RGB888_1X24;
> -	vsen->mbus_format.field = V4L2_FIELD_NONE;
> -	vsen->mbus_format.colorspace = V4L2_COLORSPACE_SRGB;
> -	vsen->mbus_format.quantization = V4L2_QUANTIZATION_FULL_RANGE;
> -	vsen->mbus_format.xfer_func = V4L2_XFER_FUNC_SRGB;
> +	/* Initialize the frame format */
> +	vsen->mbus_format = fmt_default;
>  
>  	/* Initialize the test pattern generator */
>  	tpg_init(&vsen->tpg, vsen->mbus_format.width,
>  		 vsen->mbus_format.height);
> -	ret = tpg_alloc(&vsen->tpg, VIMC_SEN_FRAME_MAX_WIDTH);
> +	ret = tpg_alloc(&vsen->tpg, VIMC_FRAME_MAX_WIDTH);
>  	if (ret)
>  		goto err_unregister_ent_sd;
>  
> 

Regards,

	Hans
