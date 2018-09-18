Return-path: <linux-media-owner@vger.kernel.org>
Received: from relay1.mentorg.com ([192.94.38.131]:48803 "EHLO
        relay1.mentorg.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729928AbeIRWcN (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 18 Sep 2018 18:32:13 -0400
Subject: Re: [PATCH] media: imx: use well defined 32-bit RGB pixel format
To: Philipp Zabel <p.zabel@pengutronix.de>,
        <linux-media@vger.kernel.org>
CC: Steve Longerbeam <slongerbeam@gmail.com>, <kernel@pengutronix.de>
References: <20180918094231.20815-1-p.zabel@pengutronix.de>
From: Steve Longerbeam <steve_longerbeam@mentor.com>
Message-ID: <f6fd645a-b68d-9619-4a52-031ca7955aff@mentor.com>
Date: Tue, 18 Sep 2018 09:58:10 -0700
MIME-Version: 1.0
In-Reply-To: <20180918094231.20815-1-p.zabel@pengutronix.de>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



On 09/18/2018 02:42 AM, Philipp Zabel wrote:
> The documentation in Documentation/media/uapi/v4l/pixfmt-packed-rgb.rst
> tells us that the V4L2_PIX_FMT_RGB32 format is deprecated and must not
> be used by new drivers. Replace it with V4L2_PIX_FMT_XRGB32.
>
> Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>

Acked-by: Steve Longerbeam <steve_longerbeam@mentor.com>

> ---
>   drivers/staging/media/imx/imx-media-utils.c | 4 ++--
>   1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/staging/media/imx/imx-media-utils.c b/drivers/staging/media/imx/imx-media-utils.c
> index 8aa13403b09d..0eaa353d5cb3 100644
> --- a/drivers/staging/media/imx/imx-media-utils.c
> +++ b/drivers/staging/media/imx/imx-media-utils.c
> @@ -88,7 +88,7 @@ static const struct imx_media_pixfmt rgb_formats[] = {
>   		.cs     = IPUV3_COLORSPACE_RGB,
>   		.bpp    = 24,
>   	}, {
> -		.fourcc	= V4L2_PIX_FMT_RGB32,
> +		.fourcc	= V4L2_PIX_FMT_XRGB32,
>   		.codes  = {MEDIA_BUS_FMT_ARGB8888_1X32},
>   		.cs     = IPUV3_COLORSPACE_RGB,
>   		.bpp    = 32,
> @@ -212,7 +212,7 @@ static const struct imx_media_pixfmt ipu_yuv_formats[] = {
>   
>   static const struct imx_media_pixfmt ipu_rgb_formats[] = {
>   	{
> -		.fourcc	= V4L2_PIX_FMT_RGB32,
> +		.fourcc	= V4L2_PIX_FMT_XRGB32,
>   		.codes  = {MEDIA_BUS_FMT_ARGB8888_1X32},
>   		.cs     = IPUV3_COLORSPACE_RGB,
>   		.bpp    = 32,
