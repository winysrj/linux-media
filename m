Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:57158 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754082AbdLNWZl (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 14 Dec 2017 17:25:41 -0500
Reply-To: kieran.bingham@ideasonboard.com
Subject: Re: [PATCH/RFC v2 10/15] adv748x: csi2: add translation from
 pixelcode to CSI-2 datatype
To: =?UTF-8?Q?Niklas_S=c3=b6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>,
        linux-media@vger.kernel.org,
        Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: linux-renesas-soc@vger.kernel.org,
        Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        Jacopo Mondi <jacopo+renesas@jmondi.org>,
        Benoit Parrot <bparrot@ti.com>,
        Maxime Ripard <maxime.ripard@free-electrons.com>
References: <20171214190835.7672-1-niklas.soderlund+renesas@ragnatech.se>
 <20171214190835.7672-11-niklas.soderlund+renesas@ragnatech.se>
From: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
Message-ID: <a41181ea-30a2-7b0d-d836-f4e5c8eba4f6@ideasonboard.com>
Date: Thu, 14 Dec 2017 22:25:36 +0000
MIME-Version: 1.0
In-Reply-To: <20171214190835.7672-11-niklas.soderlund+renesas@ragnatech.se>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Niklas,

On 14/12/17 19:08, Niklas Söderlund wrote:
> This will be needed to fill out the frame descriptor information
> correctly.
> 
> Signed-off-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
> ---
>  drivers/media/i2c/adv748x/adv748x-csi2.c | 22 ++++++++++++++++++++++
>  1 file changed, 22 insertions(+)
> 
> diff --git a/drivers/media/i2c/adv748x/adv748x-csi2.c b/drivers/media/i2c/adv748x/adv748x-csi2.c
> index 2a5dff8c571013bf..a2a6d93077204731 100644
> --- a/drivers/media/i2c/adv748x/adv748x-csi2.c
> +++ b/drivers/media/i2c/adv748x/adv748x-csi2.c
> @@ -18,6 +18,28 @@
>  
>  #include "adv748x.h"
>  
> +struct adv748x_csi2_format {
> +	unsigned int code;
> +	unsigned int datatype;
> +};
> +
> +static const struct adv748x_csi2_format adv748x_csi2_formats[] = {
> +	{ .code = MEDIA_BUS_FMT_RGB888_1X24,    .datatype = 0x24, },
> +	{ .code = MEDIA_BUS_FMT_UYVY8_1X16,     .datatype = 0x1e, },
> +	{ .code = MEDIA_BUS_FMT_UYVY8_2X8,      .datatype = 0x1e, },
> +	{ .code = MEDIA_BUS_FMT_YUYV10_2X10,    .datatype = 0x1e, },
> +};

Is the datatype mapping specific to the ADV748x here?
or are these generic/common CSI2 mappings?

What do those datatype magic numbers represent?

--
Kieran

> +
> +static unsigned int adv748x_csi2_code_to_datatype(unsigned int code)
> +{
> +	unsigned int i;
> +
> +	for (i = 0; i < ARRAY_SIZE(adv748x_csi2_formats); i++)
> +		if (adv748x_csi2_formats[i].code == code)
> +			return adv748x_csi2_formats[i].datatype;
> +	return 0;
> +}
> +
>  static bool is_txa(struct adv748x_csi2 *tx)
>  {
>  	return tx == &tx->state->txa;
> 
