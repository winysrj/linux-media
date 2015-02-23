Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:49253 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752241AbbBWQjX (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 23 Feb 2015 11:39:23 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org, Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [PATCH 4/7] v4l2-subdev: support new 'which' field in enum_mbus_code
Date: Mon, 23 Feb 2015 18:40:24 +0200
Message-ID: <12179225.3WovhtQKna@avalon>
In-Reply-To: <1423827006-32878-5-git-send-email-hverkuil@xs4all.nl>
References: <1423827006-32878-1-git-send-email-hverkuil@xs4all.nl> <1423827006-32878-5-git-send-email-hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

Thank you for the patch.

On Friday 13 February 2015 12:30:03 Hans Verkuil wrote:
> From: Hans Verkuil <hans.verkuil@cisco.com>
> 
> Support the new 'which' field in the enum_mbus_code ops. Most drivers do not
> need to be changed since they always returns the same enumeration
> regardless of the 'which' field.
> 
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>

Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

> ---
>  drivers/media/platform/omap3isp/ispccdc.c    | 4 ++--
>  drivers/media/platform/omap3isp/ispccp2.c    | 2 +-
>  drivers/media/platform/omap3isp/ispcsi2.c    | 2 +-
>  drivers/media/platform/omap3isp/ispresizer.c | 2 +-
>  drivers/media/platform/vsp1/vsp1_bru.c       | 4 +++-
>  drivers/media/platform/vsp1/vsp1_lif.c       | 4 +++-
>  drivers/media/platform/vsp1/vsp1_lut.c       | 4 +++-
>  drivers/media/platform/vsp1/vsp1_sru.c       | 4 +++-
>  drivers/media/platform/vsp1/vsp1_uds.c       | 4 +++-
>  drivers/staging/media/omap4iss/iss_csi2.c    | 2 +-
>  drivers/staging/media/omap4iss/iss_ipipeif.c | 2 +-
>  drivers/staging/media/omap4iss/iss_resizer.c | 2 +-
>  12 files changed, 23 insertions(+), 13 deletions(-)
> 
> diff --git a/drivers/media/platform/omap3isp/ispccdc.c
> b/drivers/media/platform/omap3isp/ispccdc.c index b0431a9..818aa52 100644
> --- a/drivers/media/platform/omap3isp/ispccdc.c
> +++ b/drivers/media/platform/omap3isp/ispccdc.c
> @@ -2133,7 +2133,7 @@ static int ccdc_enum_mbus_code(struct v4l2_subdev *sd,
> 
>  	case CCDC_PAD_SOURCE_OF:
>  		format = __ccdc_get_format(ccdc, cfg, code->pad,
> -					   V4L2_SUBDEV_FORMAT_TRY);
> +					   code->which);
> 
>  		if (format->code == MEDIA_BUS_FMT_YUYV8_2X8 ||
>  		    format->code == MEDIA_BUS_FMT_UYVY8_2X8) {
> @@ -2164,7 +2164,7 @@ static int ccdc_enum_mbus_code(struct v4l2_subdev *sd,
> return -EINVAL;
> 
>  		format = __ccdc_get_format(ccdc, cfg, code->pad,
> -					   V4L2_SUBDEV_FORMAT_TRY);
> +					   code->which);
> 
>  		/* A pixel code equal to 0 means that the video port doesn't
>  		 * support the input format. Don't enumerate any pixel code.
> diff --git a/drivers/media/platform/omap3isp/ispccp2.c
> b/drivers/media/platform/omap3isp/ispccp2.c index 3f10c3a..1d79368 100644
> --- a/drivers/media/platform/omap3isp/ispccp2.c
> +++ b/drivers/media/platform/omap3isp/ispccp2.c
> @@ -703,7 +703,7 @@ static int ccp2_enum_mbus_code(struct v4l2_subdev *sd,
>  			return -EINVAL;
> 
>  		format = __ccp2_get_format(ccp2, cfg, CCP2_PAD_SINK,
> -					      V4L2_SUBDEV_FORMAT_TRY);
> +					      code->which);
>  		code->code = format->code;
>  	}
> 
> diff --git a/drivers/media/platform/omap3isp/ispcsi2.c
> b/drivers/media/platform/omap3isp/ispcsi2.c index 12ca63f..bde734c 100644
> --- a/drivers/media/platform/omap3isp/ispcsi2.c
> +++ b/drivers/media/platform/omap3isp/ispcsi2.c
> @@ -909,7 +909,7 @@ static int csi2_enum_mbus_code(struct v4l2_subdev *sd,
>  		code->code = csi2_input_fmts[code->index];
>  	} else {
>  		format = __csi2_get_format(csi2, cfg, CSI2_PAD_SINK,
> -					   V4L2_SUBDEV_FORMAT_TRY);
> +					   code->which);
>  		switch (code->index) {
>  		case 0:
>  			/* Passthrough sink pad code */
> diff --git a/drivers/media/platform/omap3isp/ispresizer.c
> b/drivers/media/platform/omap3isp/ispresizer.c index 3ede27b..02549fa8
> 100644
> --- a/drivers/media/platform/omap3isp/ispresizer.c
> +++ b/drivers/media/platform/omap3isp/ispresizer.c
> @@ -1431,7 +1431,7 @@ static int resizer_enum_mbus_code(struct v4l2_subdev
> *sd, return -EINVAL;
> 
>  		format = __resizer_get_format(res, cfg, RESZ_PAD_SINK,
> -					      V4L2_SUBDEV_FORMAT_TRY);
> +					      code->which);
>  		code->code = format->code;
>  	}
> 
> diff --git a/drivers/media/platform/vsp1/vsp1_bru.c
> b/drivers/media/platform/vsp1/vsp1_bru.c index 31ad0b6..7dd7633 100644
> --- a/drivers/media/platform/vsp1/vsp1_bru.c
> +++ b/drivers/media/platform/vsp1/vsp1_bru.c
> @@ -190,6 +190,7 @@ static int bru_enum_mbus_code(struct v4l2_subdev
> *subdev, MEDIA_BUS_FMT_ARGB8888_1X32,
>  		MEDIA_BUS_FMT_AYUV8_1X32,
>  	};
> +	struct vsp1_bru *bru = to_bru(subdev);
>  	struct v4l2_mbus_framefmt *format;
> 
>  	if (code->pad == BRU_PAD_SINK(0)) {
> @@ -201,7 +202,8 @@ static int bru_enum_mbus_code(struct v4l2_subdev
> *subdev, if (code->index)
>  			return -EINVAL;
> 
> -		format = v4l2_subdev_get_try_format(subdev, cfg, BRU_PAD_SINK(0));
> +		format = vsp1_entity_get_pad_format(&bru->entity, cfg,
> +						    BRU_PAD_SINK(0), code->which);
>  		code->code = format->code;
>  	}
> 
> diff --git a/drivers/media/platform/vsp1/vsp1_lif.c
> b/drivers/media/platform/vsp1/vsp1_lif.c index b91c925..60f1bd8 100644
> --- a/drivers/media/platform/vsp1/vsp1_lif.c
> +++ b/drivers/media/platform/vsp1/vsp1_lif.c
> @@ -81,6 +81,7 @@ static int lif_enum_mbus_code(struct v4l2_subdev *subdev,
>  		MEDIA_BUS_FMT_ARGB8888_1X32,
>  		MEDIA_BUS_FMT_AYUV8_1X32,
>  	};
> +	struct vsp1_lif *lif = to_lif(subdev);
> 
>  	if (code->pad == LIF_PAD_SINK) {
>  		if (code->index >= ARRAY_SIZE(codes))
> @@ -96,7 +97,8 @@ static int lif_enum_mbus_code(struct v4l2_subdev *subdev,
>  		if (code->index)
>  			return -EINVAL;
> 
> -		format = v4l2_subdev_get_try_format(subdev, cfg, LIF_PAD_SINK);
> +		format = vsp1_entity_get_pad_format(&lif->entity, cfg,
> +						    LIF_PAD_SINK, code->which);
>  		code->code = format->code;
>  	}
> 
> diff --git a/drivers/media/platform/vsp1/vsp1_lut.c
> b/drivers/media/platform/vsp1/vsp1_lut.c index 003363d..8aa8c11 100644
> --- a/drivers/media/platform/vsp1/vsp1_lut.c
> +++ b/drivers/media/platform/vsp1/vsp1_lut.c
> @@ -90,6 +90,7 @@ static int lut_enum_mbus_code(struct v4l2_subdev *subdev,
>  		MEDIA_BUS_FMT_AHSV8888_1X32,
>  		MEDIA_BUS_FMT_AYUV8_1X32,
>  	};
> +	struct vsp1_lut *lut = to_lut(subdev);
>  	struct v4l2_mbus_framefmt *format;
> 
>  	if (code->pad == LUT_PAD_SINK) {
> @@ -104,7 +105,8 @@ static int lut_enum_mbus_code(struct v4l2_subdev
> *subdev, if (code->index)
>  			return -EINVAL;
> 
> -		format = v4l2_subdev_get_try_format(subdev, cfg, LUT_PAD_SINK);
> +		format = vsp1_entity_get_pad_format(&lut->entity, cfg,
> +						    LUT_PAD_SINK, code->which);
>  		code->code = format->code;
>  	}
> 
> diff --git a/drivers/media/platform/vsp1/vsp1_sru.c
> b/drivers/media/platform/vsp1/vsp1_sru.c index c51dcee..554340d 100644
> --- a/drivers/media/platform/vsp1/vsp1_sru.c
> +++ b/drivers/media/platform/vsp1/vsp1_sru.c
> @@ -173,6 +173,7 @@ static int sru_enum_mbus_code(struct v4l2_subdev
> *subdev, MEDIA_BUS_FMT_ARGB8888_1X32,
>  		MEDIA_BUS_FMT_AYUV8_1X32,
>  	};
> +	struct vsp1_sru *sru = to_sru(subdev);
>  	struct v4l2_mbus_framefmt *format;
> 
>  	if (code->pad == SRU_PAD_SINK) {
> @@ -187,7 +188,8 @@ static int sru_enum_mbus_code(struct v4l2_subdev
> *subdev, if (code->index)
>  			return -EINVAL;
> 
> -		format = v4l2_subdev_get_try_format(subdev, cfg, SRU_PAD_SINK);
> +		format = vsp1_entity_get_pad_format(&sru->entity, cfg,
> +						    SRU_PAD_SINK, code->which);
>  		code->code = format->code;
>  	}
> 
> diff --git a/drivers/media/platform/vsp1/vsp1_uds.c
> b/drivers/media/platform/vsp1/vsp1_uds.c index 08d916d..ef4d307 100644
> --- a/drivers/media/platform/vsp1/vsp1_uds.c
> +++ b/drivers/media/platform/vsp1/vsp1_uds.c
> @@ -176,6 +176,7 @@ static int uds_enum_mbus_code(struct v4l2_subdev
> *subdev, MEDIA_BUS_FMT_ARGB8888_1X32,
>  		MEDIA_BUS_FMT_AYUV8_1X32,
>  	};
> +	struct vsp1_uds *uds = to_uds(subdev);
> 
>  	if (code->pad == UDS_PAD_SINK) {
>  		if (code->index >= ARRAY_SIZE(codes))
> @@ -191,7 +192,8 @@ static int uds_enum_mbus_code(struct v4l2_subdev
> *subdev, if (code->index)
>  			return -EINVAL;
> 
> -		format = v4l2_subdev_get_try_format(subdev, cfg, UDS_PAD_SINK);
> +		format = vsp1_entity_get_pad_format(&uds->entity, cfg,
> +						    UDS_PAD_SINK, code->which);
>  		code->code = format->code;
>  	}
> 
> diff --git a/drivers/staging/media/omap4iss/iss_csi2.c
> b/drivers/staging/media/omap4iss/iss_csi2.c index e404ad4..2d5079d 100644
> --- a/drivers/staging/media/omap4iss/iss_csi2.c
> +++ b/drivers/staging/media/omap4iss/iss_csi2.c
> @@ -908,7 +908,7 @@ static int csi2_enum_mbus_code(struct v4l2_subdev *sd,
>  		code->code = csi2_input_fmts[code->index];
>  	} else {
>  		format = __csi2_get_format(csi2, cfg, CSI2_PAD_SINK,
> -					   V4L2_SUBDEV_FORMAT_TRY);
> +					   code->which);
>  		switch (code->index) {
>  		case 0:
>  			/* Passthrough sink pad code */
> diff --git a/drivers/staging/media/omap4iss/iss_ipipeif.c
> b/drivers/staging/media/omap4iss/iss_ipipeif.c index 948edcc..b8e7277
> 100644
> --- a/drivers/staging/media/omap4iss/iss_ipipeif.c
> +++ b/drivers/staging/media/omap4iss/iss_ipipeif.c
> @@ -467,7 +467,7 @@ static int ipipeif_enum_mbus_code(struct v4l2_subdev
> *sd, return -EINVAL;
> 
>  		format = __ipipeif_get_format(ipipeif, cfg, IPIPEIF_PAD_SINK,
> -					      V4L2_SUBDEV_FORMAT_TRY);
> +					      code->which);
> 
>  		code->code = format->code;
>  		break;
> diff --git a/drivers/staging/media/omap4iss/iss_resizer.c
> b/drivers/staging/media/omap4iss/iss_resizer.c index f9b0aac..075b876
> 100644
> --- a/drivers/staging/media/omap4iss/iss_resizer.c
> +++ b/drivers/staging/media/omap4iss/iss_resizer.c
> @@ -513,7 +513,7 @@ static int resizer_enum_mbus_code(struct v4l2_subdev
> *sd,
> 
>  	case RESIZER_PAD_SOURCE_MEM:
>  		format = __resizer_get_format(resizer, cfg, RESIZER_PAD_SINK,
> -					      V4L2_SUBDEV_FORMAT_TRY);
> +					      code->which);
> 
>  		if (code->index == 0) {
>  			code->code = format->code;

-- 
Regards,

Laurent Pinchart

