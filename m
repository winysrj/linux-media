Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pg0-f66.google.com ([74.125.83.66]:41950 "EHLO
        mail-pg0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751594AbeEUBkz (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 20 May 2018 21:40:55 -0400
Received: by mail-pg0-f66.google.com with SMTP id d14-v6so2049242pgv.8
        for <linux-media@vger.kernel.org>; Sun, 20 May 2018 18:40:54 -0700 (PDT)
Subject: Re: [PATCH v3 1/2] media: imx: capture: refactor enum_/try_fmt
To: Jan Luebbe <jlu@pengutronix.de>, linux-media@vger.kernel.org
Cc: p.zabel@pengutronix.de, kernel@pengutronix.de
References: <20180518135639.19889-1-jlu@pengutronix.de>
 <20180518135639.19889-2-jlu@pengutronix.de>
From: Steve Longerbeam <slongerbeam@gmail.com>
Message-ID: <9a5510f2-ce10-257f-580d-d057299721b8@gmail.com>
Date: Sun, 20 May 2018 18:40:52 -0700
MIME-Version: 1.0
In-Reply-To: <20180518135639.19889-2-jlu@pengutronix.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Reviewed-by: Steve Longerbeam <steve_longerbeam@mentor.com>


On 05/18/2018 06:56 AM, Jan Luebbe wrote:
> By checking and handling the internal IPU formats (ARGB or AYUV) first,
> we don't need to check whether it's a bayer format, as we can default to
> passing the input format on in all other cases.
>
> This simplifies handling the different configurations for RGB565 between
> parallel and MIPI CSI-2, as we don't need to check the details of the
> format anymore.
>
> Signed-off-by: Jan Luebbe <jlu@pengutronix.de>
> ---
>   drivers/staging/media/imx/imx-media-capture.c | 38 +++++++++----------
>   1 file changed, 18 insertions(+), 20 deletions(-)
>
> diff --git a/drivers/staging/media/imx/imx-media-capture.c b/drivers/staging/media/imx/imx-media-capture.c
> index 0ccabe04b0e1..64c23ef92931 100644
> --- a/drivers/staging/media/imx/imx-media-capture.c
> +++ b/drivers/staging/media/imx/imx-media-capture.c
> @@ -170,23 +170,22 @@ static int capture_enum_fmt_vid_cap(struct file *file, void *fh,
>   	}
>   
>   	cc_src = imx_media_find_ipu_format(fmt_src.format.code, CS_SEL_ANY);
> -	if (!cc_src)
> -		cc_src = imx_media_find_mbus_format(fmt_src.format.code,
> -						    CS_SEL_ANY, true);
> -	if (!cc_src)
> -		return -EINVAL;
> -
> -	if (cc_src->bayer) {
> -		if (f->index != 0)
> -			return -EINVAL;
> -		fourcc = cc_src->fourcc;
> -	} else {
> +	if (cc_src) {
>   		u32 cs_sel = (cc_src->cs == IPUV3_COLORSPACE_YUV) ?
>   			CS_SEL_YUV : CS_SEL_RGB;
>   
>   		ret = imx_media_enum_format(&fourcc, f->index, cs_sel);
>   		if (ret)
>   			return ret;
> +	} else {
> +		cc_src = imx_media_find_mbus_format(fmt_src.format.code,
> +						    CS_SEL_ANY, true);
> +		if (WARN_ON(!cc_src))
> +			return -EINVAL;
> +
> +		if (f->index != 0)
> +			return -EINVAL;
> +		fourcc = cc_src->fourcc;
>   	}
>   
>   	f->pixelformat = fourcc;
> @@ -219,15 +218,7 @@ static int capture_try_fmt_vid_cap(struct file *file, void *fh,
>   		return ret;
>   
>   	cc_src = imx_media_find_ipu_format(fmt_src.format.code, CS_SEL_ANY);
> -	if (!cc_src)
> -		cc_src = imx_media_find_mbus_format(fmt_src.format.code,
> -						    CS_SEL_ANY, true);
> -	if (!cc_src)
> -		return -EINVAL;
> -
> -	if (cc_src->bayer) {
> -		cc = cc_src;
> -	} else {
> +	if (cc_src) {
>   		u32 fourcc, cs_sel;
>   
>   		cs_sel = (cc_src->cs == IPUV3_COLORSPACE_YUV) ?
> @@ -239,6 +230,13 @@ static int capture_try_fmt_vid_cap(struct file *file, void *fh,
>   			imx_media_enum_format(&fourcc, 0, cs_sel);
>   			cc = imx_media_find_format(fourcc, cs_sel, false);
>   		}
> +	} else {
> +		cc_src = imx_media_find_mbus_format(fmt_src.format.code,
> +						    CS_SEL_ANY, true);
> +		if (WARN_ON(!cc_src))
> +			return -EINVAL;
> +
> +		cc = cc_src;
>   	}
>   
>   	imx_media_mbus_fmt_to_pix_fmt(&f->fmt.pix, &fmt_src.format, cc);
