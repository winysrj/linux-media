Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud9.xs4all.net ([194.109.24.22]:47422 "EHLO
        lb1-smtp-cloud9.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1032814AbeBOOnv (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 15 Feb 2018 09:43:51 -0500
Subject: Re: [PATCH] media: imx: add 8-bit grayscale support
To: Philipp Zabel <p.zabel@pengutronix.de>, linux-media@vger.kernel.org
Cc: kernel@pengutronix.de,
        =?UTF-8?Q?Jan_L=c3=bcbbe?= <jlu@pengutronix.de>
References: <20180122161632.16915-1-p.zabel@pengutronix.de>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <773d7cd2-5372-e1db-5605-82dcdee5453c@xs4all.nl>
Date: Thu, 15 Feb 2018 15:43:50 +0100
MIME-Version: 1.0
In-Reply-To: <20180122161632.16915-1-p.zabel@pengutronix.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Philipp,

Can you let me know if/when I can merge this? It looks good, so when the other
patch is merged, then this can be merged as well.

Regards,

	Hans

On 22/01/18 17:16, Philipp Zabel wrote:
> The IPUv3 code has 8-bit grayscale capture support.
> Enable imx-media to use it.
> 
> Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
> ---
> This patch depends on https://patchwork.kernel.org/patch/10178777/
> to work, otherwise STREAMON will fail with -EINVAL.
> ---
>  drivers/staging/media/imx/imx-media-csi.c   | 1 +
>  drivers/staging/media/imx/imx-media-utils.c | 8 +++++++-
>  2 files changed, 8 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/staging/media/imx/imx-media-csi.c b/drivers/staging/media/imx/imx-media-csi.c
> index eb7be5093a9d5..e280ba31262a8 100644
> --- a/drivers/staging/media/imx/imx-media-csi.c
> +++ b/drivers/staging/media/imx/imx-media-csi.c
> @@ -400,6 +400,7 @@ static int csi_idmac_setup_channel(struct csi_priv *priv)
>  	case V4L2_PIX_FMT_SGBRG8:
>  	case V4L2_PIX_FMT_SGRBG8:
>  	case V4L2_PIX_FMT_SRGGB8:
> +	case V4L2_PIX_FMT_GREY:
>  		burst_size = 16;
>  		passthrough = true;
>  		passthrough_bits = 8;
> diff --git a/drivers/staging/media/imx/imx-media-utils.c b/drivers/staging/media/imx/imx-media-utils.c
> index 13dafa77a2eba..5f61eecb81f1e 100644
> --- a/drivers/staging/media/imx/imx-media-utils.c
> +++ b/drivers/staging/media/imx/imx-media-utils.c
> @@ -93,7 +93,7 @@ static const struct imx_media_pixfmt rgb_formats[] = {
>  		.bpp    = 32,
>  		.ipufmt = true,
>  	},
> -	/*** raw bayer formats start here ***/
> +	/*** raw bayer and grayscale formats start here ***/
>  	{
>  		.fourcc = V4L2_PIX_FMT_SBGGR8,
>  		.codes  = {MEDIA_BUS_FMT_SBGGR8_1X8},
> @@ -162,6 +162,12 @@ static const struct imx_media_pixfmt rgb_formats[] = {
>  		.cs     = IPUV3_COLORSPACE_RGB,
>  		.bpp    = 16,
>  		.bayer  = true,
> +	}, {
> +		.fourcc = V4L2_PIX_FMT_GREY,
> +		.codes = {MEDIA_BUS_FMT_Y8_1X8},
> +		.cs     = IPUV3_COLORSPACE_RGB,
> +		.bpp    = 8,
> +		.bayer  = true,
>  	},
>  	/***
>  	 * non-mbus RGB formats start here. NOTE! when adding non-mbus
> 
