Return-path: <mchehab@pedra>
Received: from d1.icnet.pl ([212.160.220.21]:52793 "EHLO d1.icnet.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757701Ab1EXAZK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 23 May 2011 20:25:10 -0400
From: Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: Re: [PATCH 2/5] V4L: omap1-camera: fix huge lookup array
Date: Tue, 24 May 2011 01:48:23 +0200
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
References: <Pine.LNX.4.64.1105181558440.16324@axis700.grange> <Pine.LNX.4.64.1105181607510.16324@axis700.grange>
In-Reply-To: <Pine.LNX.4.64.1105181607510.16324@axis700.grange>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201105240148.23468.jkrzyszt@tis.icnet.pl>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Dnia środa 18 maj 2011 o 16:11:30 Guennadi Liakhovetski napisał(a):
> Since V4L2_MBUS_FMT_* codes have become large and sparse, they cannot
> be used as array indices anymore.

Hi Guennadi,
Thanks for taking care of this.

Regards,
Janusz

> Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
> ---
>  drivers/media/video/omap1_camera.c |   41
> ++++++++++++++++++++++++++--------- 1 files changed, 30
> insertions(+), 11 deletions(-)
> 
> diff --git a/drivers/media/video/omap1_camera.c b/drivers/media/video/omap1_camera.c
> index 5954b93..fe577a9 100644
> --- a/drivers/media/video/omap1_camera.c
> +++ b/drivers/media/video/omap1_camera.c
> @@ -990,63 +990,80 @@ static void omap1_cam_remove_device(struct soc_camera_device *icd) }
> 
>  /* Duplicate standard formats based on host capability of byte swapping */
> -static const struct soc_mbus_pixelfmt omap1_cam_formats[] = {
> -	[V4L2_MBUS_FMT_UYVY8_2X8] = {
> +static const struct soc_mbus_lookup omap1_cam_formats[] = {
> +{
> +	.code = V4L2_MBUS_FMT_UYVY8_2X8,
> +	.fmt = {
>  		.fourcc			= V4L2_PIX_FMT_YUYV,
>  		.name			= "YUYV",
>  		.bits_per_sample	= 8,
>  		.packing		= SOC_MBUS_PACKING_2X8_PADHI,
>  		.order			= SOC_MBUS_ORDER_BE,
>  	},
> -	[V4L2_MBUS_FMT_VYUY8_2X8] = {
> +}, {
> +	.code = V4L2_MBUS_FMT_VYUY8_2X8,
> +	.fmt = {
>  		.fourcc			= V4L2_PIX_FMT_YVYU,
>  		.name			= "YVYU",
>  		.bits_per_sample	= 8,
>  		.packing		= SOC_MBUS_PACKING_2X8_PADHI,
>  		.order			= SOC_MBUS_ORDER_BE,
>  	},
> -	[V4L2_MBUS_FMT_YUYV8_2X8] = {
> +}, {
> +	.code = V4L2_MBUS_FMT_YUYV8_2X8,
> +	.fmt = {
>  		.fourcc			= V4L2_PIX_FMT_UYVY,
>  		.name			= "UYVY",
>  		.bits_per_sample	= 8,
>  		.packing		= SOC_MBUS_PACKING_2X8_PADHI,
>  		.order			= SOC_MBUS_ORDER_BE,
>  	},
> -	[V4L2_MBUS_FMT_YVYU8_2X8] = {
> +}, {
> +	.code = V4L2_MBUS_FMT_YVYU8_2X8,
> +	.fmt = {
>  		.fourcc			= V4L2_PIX_FMT_VYUY,
>  		.name			= "VYUY",
>  		.bits_per_sample	= 8,
>  		.packing		= SOC_MBUS_PACKING_2X8_PADHI,
>  		.order			= SOC_MBUS_ORDER_BE,
>  	},
> -	[V4L2_MBUS_FMT_RGB555_2X8_PADHI_BE] = {
> +}, {
> +	.code = V4L2_MBUS_FMT_RGB555_2X8_PADHI_BE,
> +	.fmt = {
>  		.fourcc			= V4L2_PIX_FMT_RGB555,
>  		.name			= "RGB555",
>  		.bits_per_sample	= 8,
>  		.packing		= SOC_MBUS_PACKING_2X8_PADHI,
>  		.order			= SOC_MBUS_ORDER_BE,
>  	},
> -	[V4L2_MBUS_FMT_RGB555_2X8_PADHI_LE] = {
> +}, {
> +	.code = V4L2_MBUS_FMT_RGB555_2X8_PADHI_LE,
> +	.fmt = {
>  		.fourcc			= V4L2_PIX_FMT_RGB555X,
>  		.name			= "RGB555X",
>  		.bits_per_sample	= 8,
>  		.packing		= SOC_MBUS_PACKING_2X8_PADHI,
>  		.order			= SOC_MBUS_ORDER_BE,
>  	},
> -	[V4L2_MBUS_FMT_RGB565_2X8_BE] = {
> +}, {
> +	.code = V4L2_MBUS_FMT_RGB565_2X8_BE,
> +	.fmt = {
>  		.fourcc			= V4L2_PIX_FMT_RGB565,
>  		.name			= "RGB565",
>  		.bits_per_sample	= 8,
>  		.packing		= SOC_MBUS_PACKING_2X8_PADHI,
>  		.order			= SOC_MBUS_ORDER_BE,
>  	},
> -	[V4L2_MBUS_FMT_RGB565_2X8_LE] = {
> +}, {
> +	.code = V4L2_MBUS_FMT_RGB565_2X8_LE,
> +	.fmt = {
>  		.fourcc			= V4L2_PIX_FMT_RGB565X,
>  		.name			= "RGB565X",
>  		.bits_per_sample	= 8,
>  		.packing		= SOC_MBUS_PACKING_2X8_PADHI,
>  		.order			= SOC_MBUS_ORDER_BE,
>  	},
> +},
>  };
> 
>  static int omap1_cam_get_formats(struct soc_camera_device *icd,
> @@ -1085,12 +1102,14 @@ static int omap1_cam_get_formats(struct
> soc_camera_device *icd, case V4L2_MBUS_FMT_RGB565_2X8_LE:
>  		formats++;
>  		if (xlate) {
> -			xlate->host_fmt	= &omap1_cam_formats[code];
> +			xlate->host_fmt	= soc_mbus_find_fmtdesc(code,
> +						omap1_cam_formats,
> +						ARRAY_SIZE(omap1_cam_formats));
>  			xlate->code	= code;
>  			xlate++;
>  			dev_dbg(dev,
>  				"%s: providing format %s as byte swapped code #%d\n",
> -				__func__, omap1_cam_formats[code].name, code);
> +				__func__, xlate->host_fmt->name, code);
>  		}
>  	default:
>  		if (xlate)
