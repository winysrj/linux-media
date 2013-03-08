Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.171]:58571 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932327Ab3CHNai (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 8 Mar 2013 08:30:38 -0500
Date: Fri, 8 Mar 2013 14:30:19 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Phil Edworthy <phil.edworthy@renesas.com>
cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	linux-media@vger.kernel.org
Subject: Re: [PATCH] soc_camera: Add RGB666 & RGB888 formats
In-Reply-To: <1360834509-1228-1-git-send-email-phil.edworthy@renesas.com>
Message-ID: <Pine.LNX.4.64.1303081228050.24912@axis700.grange>
References: <1360834509-1228-1-git-send-email-phil.edworthy@renesas.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Phil

On Thu, 14 Feb 2013, Phil Edworthy wrote:

> Based on work done by Katsuya Matsubara.
> 
> Signed-off-by: Phil Edworthy <phil.edworthy@renesas.com>

Looks mostly good to me, but please also provide format descriptions for 
Documentation/DocBook/media/v4l/pixfmt-packed-rgb.xml, also see a couple 
of minor notes below

> ---
>  drivers/media/platform/soc_camera/soc_mediabus.c |   42 ++++++++++++++++++++++
>  include/media/soc_camera.h                       |    6 +++-
>  include/media/soc_mediabus.h                     |    3 ++
>  include/uapi/linux/v4l2-mediabus.h               |    6 +++-
>  4 files changed, 55 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/media/platform/soc_camera/soc_mediabus.c b/drivers/media/platform/soc_camera/soc_mediabus.c
> index a397812..d8acfd3 100644
> --- a/drivers/media/platform/soc_camera/soc_mediabus.c
> +++ b/drivers/media/platform/soc_camera/soc_mediabus.c
> @@ -97,6 +97,42 @@ static const struct soc_mbus_lookup mbus_fmt[] = {
>  		.layout			= SOC_MBUS_LAYOUT_PACKED,
>  	},
>  }, {
> +	.code = V4L2_MBUS_FMT_RGB666_1X18,
> +	.fmt = {
> +		.fourcc			= V4L2_PIX_FMT_RGB32,
> +		.name			= "RGB666/32bpp",
> +		.bits_per_sample	= 18,
> +		.packing		= SOC_MBUS_PACKING_EXTEND32,
> +		.order			= SOC_MBUS_ORDER_LE,
> +	},
> +}, {
> +	.code = V4L2_MBUS_FMT_RGB888_1X24,
> +	.fmt = {
> +		.fourcc			= V4L2_PIX_FMT_RGB32,
> +		.name			= "RGB888/32bpp",
> +		.bits_per_sample	= 24,
> +		.packing		= SOC_MBUS_PACKING_EXTEND32,
> +		.order			= SOC_MBUS_ORDER_LE,
> +	},
> +}, {
> +	.code = V4L2_MBUS_FMT_RGB888_2X12_BE,
> +	.fmt = {
> +		.fourcc			= V4L2_PIX_FMT_RGB32,
> +		.name			= "RGB888/32bpp",
> +		.bits_per_sample	= 12,
> +		.packing		= SOC_MBUS_PACKING_EXTEND32,
> +		.order			= SOC_MBUS_ORDER_BE,
> +	},
> +}, {
> +	.code = V4L2_MBUS_FMT_RGB888_2X12_LE,
> +	.fmt = {
> +		.fourcc			= V4L2_PIX_FMT_RGB32,
> +		.name			= "RGB888/32bpp",
> +		.bits_per_sample	= 12,
> +		.packing		= SOC_MBUS_PACKING_EXTEND32,
> +		.order			= SOC_MBUS_ORDER_LE,
> +	},
> +}, {
>  	.code = V4L2_MBUS_FMT_SBGGR8_1X8,
>  	.fmt = {
>  		.fourcc			= V4L2_PIX_FMT_SBGGR8,
> @@ -358,6 +394,10 @@ int soc_mbus_samples_per_pixel(const struct soc_mbus_pixelfmt *mf,
>  		*numerator = 1;
>  		*denominator = 1;
>  		return 0;
> +	case SOC_MBUS_PACKING_EXTEND32:
> +		*numerator = 1;
> +		*denominator = 1;
> +		return 0;
>  	case SOC_MBUS_PACKING_2X8_PADHI:
>  	case SOC_MBUS_PACKING_2X8_PADLO:
>  		*numerator = 2;
> @@ -395,6 +435,8 @@ s32 soc_mbus_bytes_per_line(u32 width, const struct soc_mbus_pixelfmt *mf)
>  		return width * 3 / 2;
>  	case SOC_MBUS_PACKING_VARIABLE:
>  		return 0;
> +	case SOC_MBUS_PACKING_EXTEND32:
> +		return width * 4;
>  	}
>  	return -EINVAL;
>  }
> diff --git a/include/media/soc_camera.h b/include/media/soc_camera.h
> index 6442edc..c820be2 100644
> --- a/include/media/soc_camera.h
> +++ b/include/media/soc_camera.h
> @@ -231,10 +231,14 @@ struct soc_camera_sense {
>  #define SOCAM_DATAWIDTH_10	SOCAM_DATAWIDTH(10)

Didn't you forget to define SOCAM_DATAWIDTH_12 here?

>  #define SOCAM_DATAWIDTH_15	SOCAM_DATAWIDTH(15)
>  #define SOCAM_DATAWIDTH_16	SOCAM_DATAWIDTH(16)
> +#define SOCAM_DATAWIDTH_18	SOCAM_DATAWIDTH(18)
> +#define SOCAM_DATAWIDTH_24	SOCAM_DATAWIDTH(24)
>  
>  #define SOCAM_DATAWIDTH_MASK (SOCAM_DATAWIDTH_4 | SOCAM_DATAWIDTH_8 | \
>  			      SOCAM_DATAWIDTH_9 | SOCAM_DATAWIDTH_10 | \
> -			      SOCAM_DATAWIDTH_15 | SOCAM_DATAWIDTH_16)
> +			      SOCAM_DATAWIDTH_12 | SOCAM_DATAWIDTH_15 | \
> +			      SOCAM_DATAWIDTH_16 | SOCAM_DATAWIDTH_18 | \
> +			      SOCAM_DATAWIDTH_24)
>  
>  static inline void soc_camera_limit_side(int *start, int *length,
>  		unsigned int start_min,
> diff --git a/include/media/soc_mediabus.h b/include/media/soc_mediabus.h
> index 0dc6f46..eea98d1 100644
> --- a/include/media/soc_mediabus.h
> +++ b/include/media/soc_mediabus.h
> @@ -26,6 +26,8 @@
>   * @SOC_MBUS_PACKING_VARIABLE:	compressed formats with variable packing
>   * @SOC_MBUS_PACKING_1_5X8:	used for packed YUV 4:2:0 formats, where 4
>   *				pixels occupy 6 bytes in RAM
> + * @SOC_MBUS_PACKING_EXTEND32:  sample width (e.g., 24 bits) has to be extended

Please, use a TAB above

Thanks
Guennadi

> + *				to 32 bits
>   */
>  enum soc_mbus_packing {
>  	SOC_MBUS_PACKING_NONE,
> @@ -34,6 +36,7 @@ enum soc_mbus_packing {
>  	SOC_MBUS_PACKING_EXTEND16,
>  	SOC_MBUS_PACKING_VARIABLE,
>  	SOC_MBUS_PACKING_1_5X8,
> +	SOC_MBUS_PACKING_EXTEND32,
>  };
>  
>  /**
> diff --git a/include/uapi/linux/v4l2-mediabus.h b/include/uapi/linux/v4l2-mediabus.h
> index 7d64e0e..e300e8e 100644
> --- a/include/uapi/linux/v4l2-mediabus.h
> +++ b/include/uapi/linux/v4l2-mediabus.h
> @@ -37,7 +37,7 @@
>  enum v4l2_mbus_pixelcode {
>  	V4L2_MBUS_FMT_FIXED = 0x0001,
>  
> -	/* RGB - next is 0x1009 */
> +	/* RGB - next is 0x100d */
>  	V4L2_MBUS_FMT_RGB444_2X8_PADHI_BE = 0x1001,
>  	V4L2_MBUS_FMT_RGB444_2X8_PADHI_LE = 0x1002,
>  	V4L2_MBUS_FMT_RGB555_2X8_PADHI_BE = 0x1003,
> @@ -46,6 +46,10 @@ enum v4l2_mbus_pixelcode {
>  	V4L2_MBUS_FMT_BGR565_2X8_LE = 0x1006,
>  	V4L2_MBUS_FMT_RGB565_2X8_BE = 0x1007,
>  	V4L2_MBUS_FMT_RGB565_2X8_LE = 0x1008,
> +	V4L2_MBUS_FMT_RGB666_1X18 = 0x1009,
> +	V4L2_MBUS_FMT_RGB888_1X24 = 0x100a,
> +	V4L2_MBUS_FMT_RGB888_2X12_BE = 0x100b,
> +	V4L2_MBUS_FMT_RGB888_2X12_LE = 0x100c,
>  
>  	/* YUV (including grey) - next is 0x2014 */
>  	V4L2_MBUS_FMT_Y8_1X8 = 0x2001,
> -- 
> 1.7.5.4
> 

---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
