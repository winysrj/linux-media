Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([85.220.165.71]:59973 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752876AbeDSNi3 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 19 Apr 2018 09:38:29 -0400
Message-ID: <1524145101.3416.7.camel@pengutronix.de>
Subject: Re: [PATCH 07/15] media: staging/imx: add 10 bit bayer support
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Rui Miguel Silva <rui.silva@linaro.org>, mchehab@kernel.org,
        sakari.ailus@linux.intel.com,
        Steve Longerbeam <slongerbeam@gmail.com>,
        Rob Herring <robh+dt@kernel.org>
Cc: linux-media@vger.kernel.org, devel@driverdev.osuosl.org,
        Shawn Guo <shawnguo@kernel.org>,
        Fabio Estevam <fabio.estevam@nxp.com>,
        devicetree@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ryan Harkin <ryan.harkin@linaro.org>
Date: Thu, 19 Apr 2018 15:38:21 +0200
In-Reply-To: <20180419101812.30688-8-rui.silva@linaro.org>
References: <20180419101812.30688-1-rui.silva@linaro.org>
         <20180419101812.30688-8-rui.silva@linaro.org>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, 2018-04-19 at 11:18 +0100, Rui Miguel Silva wrote:
> Some sensors can only output 10 bit bayer formats, like the OV2680. Add support
> for that in imx-media.
> 
> Signed-off-by: Rui Miguel Silva <rui.silva@linaro.org>
> ---
>  drivers/staging/media/imx/imx-media-utils.c | 24 +++++++++++++++++++++
>  1 file changed, 24 insertions(+)
> 
> diff --git a/drivers/staging/media/imx/imx-media-utils.c b/drivers/staging/media/imx/imx-media-utils.c
> index fab98fc0d6a0..99527daba29a 100644
> --- a/drivers/staging/media/imx/imx-media-utils.c
> +++ b/drivers/staging/media/imx/imx-media-utils.c
> @@ -118,6 +118,30 @@ static const struct imx_media_pixfmt rgb_formats[] = {
>  		.cs     = IPUV3_COLORSPACE_RGB,
>  		.bpp    = 8,
>  		.bayer  = true,
> +	}, {
> +		.fourcc = V4L2_PIX_FMT_SBGGR10,
> +		.codes  = {MEDIA_BUS_FMT_SBGGR10_1X10},
> +		.cs     = IPUV3_COLORSPACE_RGB,
> +		.bpp    = 16,
> +		.bayer  = true,
> +	}, {
> +		.fourcc = V4L2_PIX_FMT_SGBRG10,
> +		.codes  = {MEDIA_BUS_FMT_SGBRG10_1X10},
> +		.cs     = IPUV3_COLORSPACE_RGB,
> +		.bpp    = 16,
> +		.bayer  = true,
> +	}, {
> +		.fourcc = V4L2_PIX_FMT_SGRBG10,
> +		.codes  = {MEDIA_BUS_FMT_SGRBG10_1X10},
> +		.cs     = IPUV3_COLORSPACE_RGB,
> +		.bpp    = 16,
> +		.bayer  = true,
> +	}, {
> +		.fourcc = V4L2_PIX_FMT_SRGGB10,
> +		.codes  = {MEDIA_BUS_FMT_SRGGB10_1X10},
> +		.cs     = IPUV3_COLORSPACE_RGB,
> +		.bpp    = 16,
> +		.bayer  = true,

This will break 10-bit bayer formats on i.MX6, which currently stores
them in memory expanded to 16-bit, as listed in the entries below:

>  	}, {
>  		.fourcc = V4L2_PIX_FMT_SBGGR16,
>  		.codes  = {

regards
Philipp
