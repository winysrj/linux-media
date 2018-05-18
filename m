Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([85.220.165.71]:49387 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750763AbeEROVX (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 18 May 2018 10:21:23 -0400
Message-ID: <1526653281.3948.12.camel@pengutronix.de>
Subject: Re: [PATCH v3 2/2] media: imx: add support for RGB565_2X8 on
 parallel bus
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Jan Luebbe <jlu@pengutronix.de>, linux-media@vger.kernel.org
Cc: slongerbeam@gmail.com, kernel@pengutronix.de,
        Steve Longerbeam <steve_longerbeam@mentor.com>
Date: Fri, 18 May 2018 16:21:21 +0200
In-Reply-To: <20180518135639.19889-3-jlu@pengutronix.de>
References: <20180518135639.19889-1-jlu@pengutronix.de>
         <20180518135639.19889-3-jlu@pengutronix.de>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, 2018-05-18 at 15:56 +0200, Jan Luebbe wrote:
> The IPU can only capture RGB565 with two 8-bit cycles in bayer/generic
> mode on the parallel bus, compared to a specific mode on MIPI CSI-2.
> To handle this, we extend imx_media_pixfmt with a cycles per pixel
> field, which is used for generic formats on the parallel bus.
> 
> Based on the selected format and bus, we then update the width to
> account for the multiple cycles per pixel.
> 
> Signed-off-by: Jan Luebbe <jlu@pengutronix.de>
> Signed-off-by: Steve Longerbeam <steve_longerbeam@mentor.com>

I only have a small suggestion below, either way:

Reviewed-by: Philipp Zabel <p.zabel@pengutronix.de>

> ---
>  drivers/staging/media/imx/imx-media-csi.c   | 101 +++++++++++++-------
>  drivers/staging/media/imx/imx-media-utils.c |   1 +
>  drivers/staging/media/imx/imx-media.h       |   2 +
>  3 files changed, 71 insertions(+), 33 deletions(-)
> 
> diff --git a/drivers/staging/media/imx/imx-media-csi.c b/drivers/staging/media/imx/imx-media-csi.c
> index 08b636084286..64e795b0bdae 100644
> --- a/drivers/staging/media/imx/imx-media-csi.c
> +++ b/drivers/staging/media/imx/imx-media-csi.c
[...]
> @@ -389,12 +414,9 @@ static int csi_idmac_setup_channel(struct csi_priv *priv)
>  	image.phys0 = phys[0];
>  	image.phys1 = phys[1];
>  
> -	/*
> -	 * Check for conditions that require the IPU to handle the
> -	 * data internally as generic data, aka passthrough mode:
> -	 * - raw bayer formats
> -	 * - the CSI is receiving from a 16-bit parallel bus
> -	 */
> +	passthrough = requires_passthrough(&priv->upstream_ep, infmt, incc);
> +	passthrough_cycles = 1;

To localize the passthrough cycles handling a bit, I'd remove this line,
...

> +
>  	switch (image.pix.pixelformat) {
>  	case V4L2_PIX_FMT_SBGGR8:
>  	case V4L2_PIX_FMT_SGBRG8:
[...]
> @@ -428,18 +447,25 @@ static int csi_idmac_setup_channel(struct csi_priv *priv)
>  	case V4L2_PIX_FMT_UYVY:
>  		burst_size = (image.pix.width & 0x1f) ?
>  			     ((image.pix.width & 0xf) ? 8 : 16) : 32;
> -		passthrough = is_parallel_16bit_bus(&priv->upstream_ep);
>  		passthrough_bits = 16;
>  		break;
> +	case V4L2_PIX_FMT_RGB565:
> +		if (passthrough) {
> +			burst_size = 16;
> +			passthrough_bits = 8;
> +			passthrough_cycles = incc->cycles;

... remove this line ...

> +			break;
> +		}
> +		/* fallthrough for non-passthrough RGB565 (CSI-2 bus) */
>  	default:
>  		burst_size = (image.pix.width & 0xf) ? 8 : 16;
> -		passthrough = is_parallel_16bit_bus(&priv->upstream_ep);
>  		passthrough_bits = 16;
>  		break;
>  	}
>  
>  	if (passthrough) {

... and then set
		passthrough_cycles = incc->cycles ?: 1;
here.

regards
Philipp
