Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.17.8]:64784 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757858Ab3DXVJY (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 24 Apr 2013 17:09:24 -0400
Date: Wed, 24 Apr 2013 23:09:22 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Phil Edworthy <phil.edworthy@renesas.com>
cc: linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: Re: [PATCH] soc_camera: Add V4L2_MBUS_FMT_YUYV10_2X10 format
In-Reply-To: <1366202619-4511-1-git-send-email-phil.edworthy@renesas.com>
Message-ID: <Pine.LNX.4.64.1304242249410.16970@axis700.grange>
References: <1366202619-4511-1-git-send-email-phil.edworthy@renesas.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Phil

Thanks for the patch.

On Wed, 17 Apr 2013, Phil Edworthy wrote:

> The V4L2_MBUS_FMT_YUYV10_2X10 format has already been added to mediabus, so
> this patch just adds SoC camera support.
> 
> Signed-off-by: Phil Edworthy <phil.edworthy@renesas.com>
> ---
>  drivers/media/platform/soc_camera/soc_mediabus.c |   15 +++++++++++++++
>  include/media/soc_mediabus.h                     |    3 +++
>  2 files changed, 18 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/media/platform/soc_camera/soc_mediabus.c b/drivers/media/platform/soc_camera/soc_mediabus.c
> index 7569e77..be47d41 100644
> --- a/drivers/media/platform/soc_camera/soc_mediabus.c
> +++ b/drivers/media/platform/soc_camera/soc_mediabus.c
> @@ -57,6 +57,15 @@ static const struct soc_mbus_lookup mbus_fmt[] = {
>  		.layout			= SOC_MBUS_LAYOUT_PACKED,
>  	},
>  }, {
> +	.code = V4L2_MBUS_FMT_YUYV10_2X10,
> +	.fmt = {
> +		.fourcc			= V4L2_PIX_FMT_YUYV,
> +		.name			= "YUYV",
> +		.bits_per_sample	= 10,
> +		.packing		= SOC_MBUS_PACKING_2X10_PADHI,

Wow, what kind of host can pack two 10-bit samples into 3 bytes and write 
3-byte pixels to memory?

> +		.order			= SOC_MBUS_ORDER_LE,
> +	},
> +}, {
>  	.code = V4L2_MBUS_FMT_RGB555_2X8_PADHI_LE,
>  	.fmt = {
>  		.fourcc			= V4L2_PIX_FMT_RGB555,
> @@ -403,6 +412,10 @@ int soc_mbus_samples_per_pixel(const struct soc_mbus_pixelfmt *mf,
>  		*numerator = 2;
>  		*denominator = 1;
>  		return 0;
> +	case SOC_MBUS_PACKING_2X10_PADHI:
> +		*numerator = 3;
> +		*denominator = 1;

Why 3? it's 2 samples per pixel, right? Should be *numerator = 2 above?

> +		return 0;
>  	case SOC_MBUS_PACKING_1_5X8:
>  		*numerator = 3;
>  		*denominator = 2;
> @@ -428,6 +441,8 @@ s32 soc_mbus_bytes_per_line(u32 width, const struct soc_mbus_pixelfmt *mf)
>  	case SOC_MBUS_PACKING_2X8_PADLO:
>  	case SOC_MBUS_PACKING_EXTEND16:
>  		return width * 2;
> +	case SOC_MBUS_PACKING_2X10_PADHI:
> +		return width * 3;
>  	case SOC_MBUS_PACKING_1_5X8:
>  		return width * 3 / 2;
>  	case SOC_MBUS_PACKING_VARIABLE:
> diff --git a/include/media/soc_mediabus.h b/include/media/soc_mediabus.h
> index d33f6d0..b131a47 100644
> --- a/include/media/soc_mediabus.h
> +++ b/include/media/soc_mediabus.h
> @@ -21,6 +21,8 @@
>   * @SOC_MBUS_PACKING_2X8_PADHI:	16 bits transferred in 2 8-bit samples, in the
>   *				possibly incomplete byte high bits are padding
>   * @SOC_MBUS_PACKING_2X8_PADLO:	as above, but low bits are padding
> + * @SOC_MBUS_PACKING_2X10_PADHI:20 bits transferred in 2 10-bit samples. The

A TAB is missing after ":"?

> + *				high bits are padding
>   * @SOC_MBUS_PACKING_EXTEND16:	sample width (e.g., 10 bits) has to be extended
>   *				to 16 bits
>   * @SOC_MBUS_PACKING_VARIABLE:	compressed formats with variable packing
> @@ -33,6 +35,7 @@ enum soc_mbus_packing {
>  	SOC_MBUS_PACKING_NONE,
>  	SOC_MBUS_PACKING_2X8_PADHI,
>  	SOC_MBUS_PACKING_2X8_PADLO,
> +	SOC_MBUS_PACKING_2X10_PADHI,
>  	SOC_MBUS_PACKING_EXTEND16,
>  	SOC_MBUS_PACKING_VARIABLE,
>  	SOC_MBUS_PACKING_1_5X8,
> -- 
> 1.7.5.4
> 

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
