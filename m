Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud8.xs4all.net ([194.109.24.21]:54757 "EHLO
        lb1-smtp-cloud8.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726618AbeINOBQ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 14 Sep 2018 10:01:16 -0400
Subject: Re: [PATCH 1/3] rcar-vin: align format width with hardware limits
To: =?UTF-8?Q?Niklas_S=c3=b6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        linux-media@vger.kernel.org
Cc: linux-renesas-soc@vger.kernel.org
References: <20180914021345.9277-1-niklas.soderlund+renesas@ragnatech.se>
 <20180914021345.9277-2-niklas.soderlund+renesas@ragnatech.se>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <6676e7fa-5548-7c3e-25f0-19bf6b03ed42@xs4all.nl>
Date: Fri, 14 Sep 2018 10:47:41 +0200
MIME-Version: 1.0
In-Reply-To: <20180914021345.9277-2-niklas.soderlund+renesas@ragnatech.se>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 09/14/2018 04:13 AM, Niklas Söderlund wrote:
> The Gen3 datasheets lists specific alignment restrictions compared to
> Gen2. This was overlooked when adding Gen3 support as no problematic
> configuration was encountered. However when adding support for Gen3 Up
> Down Scaler (UDS) strange issues could be observed for odd widths
> without taking this limit into consideration.
> 
> Signed-off-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
> ---
>  drivers/media/platform/rcar-vin/rcar-v4l2.c | 15 +++++++++++++++
>  1 file changed, 15 insertions(+)
> 
> diff --git a/drivers/media/platform/rcar-vin/rcar-v4l2.c b/drivers/media/platform/rcar-vin/rcar-v4l2.c
> index dc77682b47857c97..2fc2a05eaeacb134 100644
> --- a/drivers/media/platform/rcar-vin/rcar-v4l2.c
> +++ b/drivers/media/platform/rcar-vin/rcar-v4l2.c
> @@ -673,6 +673,21 @@ static void rvin_mc_try_format(struct rvin_dev *vin,
>  	pix->quantization = V4L2_MAP_QUANTIZATION_DEFAULT(true, pix->colorspace,
>  							  pix->ycbcr_enc);
>  
> +	switch (vin->format.pixelformat) {
> +	case V4L2_PIX_FMT_NV16:
> +		pix->width = ALIGN(pix->width, 0x80);
> +		break;
> +	case V4L2_PIX_FMT_YUYV:
> +	case V4L2_PIX_FMT_UYVY:
> +	case V4L2_PIX_FMT_RGB565:
> +	case V4L2_PIX_FMT_XRGB555:
> +		pix->width = ALIGN(pix->width, 0x40);
> +		break;
> +	default:
> +		pix->width = ALIGN(pix->width, 0x20);
> +		break;
> +	}
> +
>  	rvin_format_align(vin, pix);
>  }
>  
> 

This looks weird. So for NV16 the width must be a multiple of 128,
do I read that correctly?

Are you sure you don't mean bytesperline?

And if it really is the width, doesn't this place very big constraints
on the vin driver? If you don't want/need the UDS, then I can imagine
that you don't want these alignments.

Regards,

	Hans
