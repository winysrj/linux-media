Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud9.xs4all.net ([194.109.24.22]:58230 "EHLO
        lb1-smtp-cloud9.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751102AbeCIPZZ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 9 Mar 2018 10:25:25 -0500
Subject: Re: [PATCH v12 11/33] rcar-vin: set a default field to fallback on
To: =?UTF-8?Q?Niklas_S=c3=b6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        linux-media@vger.kernel.org
Cc: linux-renesas-soc@vger.kernel.org, tomoharu.fukawa.eb@renesas.com,
        Kieran Bingham <kieran.bingham@ideasonboard.com>
References: <20180307220511.9826-1-niklas.soderlund+renesas@ragnatech.se>
 <20180307220511.9826-12-niklas.soderlund+renesas@ragnatech.se>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <4181fb92-5ac9-9ad8-a60d-65c57f5baaa0@xs4all.nl>
Date: Fri, 9 Mar 2018 16:25:23 +0100
MIME-Version: 1.0
In-Reply-To: <20180307220511.9826-12-niklas.soderlund+renesas@ragnatech.se>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 07/03/18 23:04, Niklas Söderlund wrote:
> If the field is not supported by the driver it should not try to keep
> the current field. Instead it should set it to a default fallback. Since
> trying a format should always result in the same state regardless of the
> current state of the device.
> 
> Signed-off-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
> Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> ---
>  drivers/media/platform/rcar-vin/rcar-v4l2.c | 9 +++------
>  1 file changed, 3 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/media/platform/rcar-vin/rcar-v4l2.c b/drivers/media/platform/rcar-vin/rcar-v4l2.c
> index c2265324c7c96308..ebcd78b1bb6e8cb6 100644
> --- a/drivers/media/platform/rcar-vin/rcar-v4l2.c
> +++ b/drivers/media/platform/rcar-vin/rcar-v4l2.c
> @@ -23,6 +23,7 @@
>  #include "rcar-vin.h"
>  
>  #define RVIN_DEFAULT_FORMAT	V4L2_PIX_FMT_YUYV
> +#define RVIN_DEFAULT_FIELD	V4L2_FIELD_NONE
>  
>  /* -----------------------------------------------------------------------------
>   * Format Conversions
> @@ -143,7 +144,7 @@ static int rvin_reset_format(struct rvin_dev *vin)
>  	case V4L2_FIELD_INTERLACED:
>  		break;
>  	default:
> -		vin->format.field = V4L2_FIELD_NONE;
> +		vin->format.field = RVIN_DEFAULT_FIELD;
>  		break;
>  	}
>  
> @@ -213,10 +214,6 @@ static int __rvin_try_format(struct rvin_dev *vin,
>  	u32 walign;
>  	int ret;
>  
> -	/* Keep current field if no specific one is asked for */
> -	if (pix->field == V4L2_FIELD_ANY)
> -		pix->field = vin->format.field;
> -
>  	/* If requested format is not supported fallback to the default */
>  	if (!rvin_format_from_pixel(pix->pixelformat)) {
>  		vin_dbg(vin, "Format 0x%x not found, using default 0x%x\n",
> @@ -246,7 +243,7 @@ static int __rvin_try_format(struct rvin_dev *vin,
>  	case V4L2_FIELD_INTERLACED:
>  		break;
>  	default:
> -		pix->field = V4L2_FIELD_NONE;
> +		pix->field = RVIN_DEFAULT_FIELD;
>  		break;
>  	}
>  
> 

I wonder if this code is correct. What if the adv7180 is the source? Does that even
support FIELD_NONE? I suspect that the default field should actually depend on the
source. FIELD_NONE for dv_timings based or sensor based subdevs and FIELD_INTERLACED
for SDTV (g/s_std) subdevs.

I might very well be missing something here but it looks suspicious.

Regards,

	Hans
