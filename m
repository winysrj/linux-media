Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:41602 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S966984AbeEXLi1 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 24 May 2018 07:38:27 -0400
Date: Thu, 24 May 2018 14:38:24 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Philipp Zabel <p.zabel@pengutronix.de>
Cc: linux-media@vger.kernel.org,
        Rui Miguel Silva <rui.silva@linaro.org>,
        kernel@pengutronix.de
Subject: Re: [PATCH v2] media: video-mux: fix compliance failures
Message-ID: <20180524113824.3znoltw3yfj2ngrd@valkosipuli.retiisi.org.uk>
References: <20180523092423.4386-1-p.zabel@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180523092423.4386-1-p.zabel@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Philipp,

Thanks for the patch.

On Wed, May 23, 2018 at 11:24:23AM +0200, Philipp Zabel wrote:
> Limit frame sizes to the [1, 65536] interval, media bus formats to
> the available list of formats, and initialize pad and try formats.
> 
> Reported-by: Rui Miguel Silva <rui.silva@linaro.org>
> Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
> ---
> Changes since v1:
>  - Limit to [1, 65536] instead of [1, UINT_MAX - 1]
>  - Add missing break in default case
>  - Use .init_cfg pad op instead of .open internal op
> ---
>  drivers/media/platform/video-mux.c | 108 +++++++++++++++++++++++++++++
>  1 file changed, 108 insertions(+)
> 
> diff --git a/drivers/media/platform/video-mux.c b/drivers/media/platform/video-mux.c
> index 1fb887293337..d27cb42ce6b1 100644
> --- a/drivers/media/platform/video-mux.c
> +++ b/drivers/media/platform/video-mux.c
> @@ -180,6 +180,88 @@ static int video_mux_set_format(struct v4l2_subdev *sd,
>  	if (!source_mbusformat)
>  		return -EINVAL;
>  
> +	/* No size limitations except V4L2 compliance requirements */
> +	v4l_bound_align_image(&sdformat->format.width, 1, 65536, 0,
> +			      &sdformat->format.height, 1, 65536, 0, 0);

Why 65536? And not e.g. U32_MAX?

> +
> +	/* All formats except LVDS and vendor specific formats are acceptable */
> +	switch (sdformat->format.code) {
> +	case MEDIA_BUS_FMT_RGB444_1X12:
> +	case MEDIA_BUS_FMT_RGB444_2X8_PADHI_BE:
> +	case MEDIA_BUS_FMT_RGB444_2X8_PADHI_LE:
> +	case MEDIA_BUS_FMT_RGB555_2X8_PADHI_BE:
> +	case MEDIA_BUS_FMT_RGB555_2X8_PADHI_LE:
> +	case MEDIA_BUS_FMT_RGB565_1X16:
> +	case MEDIA_BUS_FMT_BGR565_2X8_BE:
> +	case MEDIA_BUS_FMT_BGR565_2X8_LE:
> +	case MEDIA_BUS_FMT_RGB565_2X8_BE:
> +	case MEDIA_BUS_FMT_RGB565_2X8_LE:
> +	case MEDIA_BUS_FMT_RGB666_1X18:
> +	case MEDIA_BUS_FMT_RBG888_1X24:
> +	case MEDIA_BUS_FMT_RGB666_1X24_CPADHI:
> +	case MEDIA_BUS_FMT_BGR888_1X24:
> +	case MEDIA_BUS_FMT_GBR888_1X24:
> +	case MEDIA_BUS_FMT_RGB888_1X24:
> +	case MEDIA_BUS_FMT_RGB888_2X12_BE:
> +	case MEDIA_BUS_FMT_RGB888_2X12_LE:
> +	case MEDIA_BUS_FMT_ARGB8888_1X32:
> +	case MEDIA_BUS_FMT_RGB888_1X32_PADHI:
> +	case MEDIA_BUS_FMT_RGB101010_1X30:
> +	case MEDIA_BUS_FMT_RGB121212_1X36:
> +	case MEDIA_BUS_FMT_RGB161616_1X48:
> +	case MEDIA_BUS_FMT_Y8_1X8:
> +	case MEDIA_BUS_FMT_UV8_1X8:
> +	case MEDIA_BUS_FMT_UYVY8_1_5X8:
> +	case MEDIA_BUS_FMT_VYUY8_1_5X8:
> +	case MEDIA_BUS_FMT_YUYV8_1_5X8:
> +	case MEDIA_BUS_FMT_YVYU8_1_5X8:
> +	case MEDIA_BUS_FMT_UYVY8_2X8:
> +	case MEDIA_BUS_FMT_VYUY8_2X8:
> +	case MEDIA_BUS_FMT_YUYV8_2X8:
> +	case MEDIA_BUS_FMT_YVYU8_2X8:
> +	case MEDIA_BUS_FMT_Y10_1X10:
> +	case MEDIA_BUS_FMT_UYVY10_2X10:
> +	case MEDIA_BUS_FMT_VYUY10_2X10:
> +	case MEDIA_BUS_FMT_YUYV10_2X10:
> +	case MEDIA_BUS_FMT_YVYU10_2X10:
> +	case MEDIA_BUS_FMT_Y12_1X12:
> +	case MEDIA_BUS_FMT_UYVY12_2X12:
> +	case MEDIA_BUS_FMT_VYUY12_2X12:
> +	case MEDIA_BUS_FMT_YUYV12_2X12:
> +	case MEDIA_BUS_FMT_YVYU12_2X12:
> +	case MEDIA_BUS_FMT_UYVY8_1X16:
> +	case MEDIA_BUS_FMT_VYUY8_1X16:
> +	case MEDIA_BUS_FMT_YUYV8_1X16:
> +	case MEDIA_BUS_FMT_YVYU8_1X16:
> +	case MEDIA_BUS_FMT_YDYUYDYV8_1X16:
> +	case MEDIA_BUS_FMT_UYVY10_1X20:
> +	case MEDIA_BUS_FMT_VYUY10_1X20:
> +	case MEDIA_BUS_FMT_YUYV10_1X20:
> +	case MEDIA_BUS_FMT_YVYU10_1X20:
> +	case MEDIA_BUS_FMT_VUY8_1X24:
> +	case MEDIA_BUS_FMT_YUV8_1X24:
> +	case MEDIA_BUS_FMT_UYYVYY8_0_5X24:
> +	case MEDIA_BUS_FMT_UYVY12_1X24:
> +	case MEDIA_BUS_FMT_VYUY12_1X24:
> +	case MEDIA_BUS_FMT_YUYV12_1X24:
> +	case MEDIA_BUS_FMT_YVYU12_1X24:
> +	case MEDIA_BUS_FMT_YUV10_1X30:
> +	case MEDIA_BUS_FMT_UYYVYY10_0_5X30:
> +	case MEDIA_BUS_FMT_AYUV8_1X32:
> +	case MEDIA_BUS_FMT_UYYVYY12_0_5X36:
> +	case MEDIA_BUS_FMT_YUV12_1X36:
> +	case MEDIA_BUS_FMT_YUV16_1X48:
> +	case MEDIA_BUS_FMT_UYYVYY16_0_5X48:
> +	case MEDIA_BUS_FMT_JPEG_1X8:
> +	case MEDIA_BUS_FMT_AHSV8888_1X32:
> +		break;
> +	default:
> +		sdformat->format.code = MEDIA_BUS_FMT_Y8_1X8;
> +		break;
> +	}
> +	if (sdformat->format.field == V4L2_FIELD_ANY)
> +		sdformat->format.field = V4L2_FIELD_NONE;
> +
>  	mutex_lock(&vmux->lock);
>  
>  	/* Source pad mirrors active sink pad, no limitations on sink pads */
> @@ -197,7 +279,27 @@ static int video_mux_set_format(struct v4l2_subdev *sd,
>  	return 0;
>  }
>  
> +static int video_mux_init_cfg(struct v4l2_subdev *sd,
> +			      struct v4l2_subdev_pad_config *cfg)
> +{
> +	struct video_mux *vmux = v4l2_subdev_to_video_mux(sd);
> +	struct v4l2_mbus_framefmt *mbusformat;
> +	int i;

unsigned int i

> +
> +	mutex_lock(&vmux->lock);
> +
> +	for (i = 0; i < sd->entity.num_pads; i++) {
> +		mbusformat = v4l2_subdev_get_try_format(sd, cfg, i);
> +		*mbusformat = vmux->format_mbus[i];

The initial format is the default one, not the current configured format.

With these addressed,

Acked-by: Sakari Ailus <sakari.ailus@linux.intel.com>

> +	}
> +
> +	mutex_unlock(&vmux->lock);
> +
> +	return 0;
> +}
> +
>  static const struct v4l2_subdev_pad_ops video_mux_pad_ops = {
> +	.init_cfg = video_mux_init_cfg,
>  	.get_fmt = video_mux_get_format,
>  	.set_fmt = video_mux_set_format,
>  };
> @@ -263,6 +365,12 @@ static int video_mux_probe(struct platform_device *pdev)
>  	for (i = 0; i < num_pads - 1; i++)
>  		vmux->pads[i].flags = MEDIA_PAD_FL_SINK;
>  	vmux->pads[num_pads - 1].flags = MEDIA_PAD_FL_SOURCE;
> +	for (i = 0; i < num_pads; i++) {
> +		vmux->format_mbus[i].width = 1;
> +		vmux->format_mbus[i].height = 1;
> +		vmux->format_mbus[i].code = MEDIA_BUS_FMT_Y8_1X8;
> +		vmux->format_mbus[i].field = V4L2_FIELD_NONE;
> +	}
>  
>  	vmux->subdev.entity.function = MEDIA_ENT_F_VID_MUX;
>  	ret = media_entity_pads_init(&vmux->subdev.entity, num_pads,
> -- 
> 2.17.0
> 

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi
