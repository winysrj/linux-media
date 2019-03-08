Return-Path: <SRS0=k2dg=RL=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 24BDFC43381
	for <linux-media@archiver.kernel.org>; Fri,  8 Mar 2019 10:24:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F1D352081B
	for <linux-media@archiver.kernel.org>; Fri,  8 Mar 2019 10:24:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726352AbfCHKYB (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Fri, 8 Mar 2019 05:24:01 -0500
Received: from metis.ext.pengutronix.de ([85.220.165.71]:49213 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725789AbfCHKYB (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 8 Mar 2019 05:24:01 -0500
Received: from lupine.hi.pengutronix.de ([2001:67c:670:100:3ad5:47ff:feaf:1a17] helo=lupine)
        by metis.ext.pengutronix.de with esmtp (Exim 4.89)
        (envelope-from <p.zabel@pengutronix.de>)
        id 1h2CfX-0001hZ-GE; Fri, 08 Mar 2019 11:23:59 +0100
Message-ID: <1552040639.4009.1.camel@pengutronix.de>
Subject: Re: [PATCH v6 2/7] gpu: ipu-v3: ipu-ic: Fix BT.601 coefficients
From:   Philipp Zabel <p.zabel@pengutronix.de>
To:     Steve Longerbeam <slongerbeam@gmail.com>,
        linux-media@vger.kernel.org
Cc:     Tim Harvey <tharvey@gateworks.com>, stable@vger.kernel.org,
        "open list:DRM DRIVERS FOR FREESCALE IMX" 
        <dri-devel@lists.freedesktop.org>,
        open list <linux-kernel@vger.kernel.org>
Date:   Fri, 08 Mar 2019 11:23:59 +0100
In-Reply-To: <20190307233356.23748-3-slongerbeam@gmail.com>
References: <20190307233356.23748-1-slongerbeam@gmail.com>
         <20190307233356.23748-3-slongerbeam@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.22.6-1+deb9u1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 2001:67c:670:100:3ad5:47ff:feaf:1a17
X-SA-Exim-Mail-From: p.zabel@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-media@vger.kernel.org
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hi Steve,

On Thu, 2019-03-07 at 15:33 -0800, Steve Longerbeam wrote:
> The ycbcr2rgb and inverse rgb2ycbcr tables define the BT.601 Y'CbCr
> encoding coefficients.
> 
> The rgb2ycbcr table specifically describes the BT.601 encoding from
> full range RGB to full range YUV. Add table comments to make this more
> clear.
> 
> The ycbcr2rgb inverse table describes encoding YUV limited range to RGB
> full range. To be consistent with the rgb2ycbcr table, convert this to
> YUV full range to RGB full range, and adjust/expand on the comments.
> 
> The ic_csc_rgb2rgb table is just an identity matrix, so rename to
> ic_encode_identity.
> 
> Fixes: 1aa8ea0d2bd5d ("gpu: ipu-v3: Add Image Converter unit")
> 
> Suggested-by: Philipp Zabel <p.zabel@pengutronix.de>
> Signed-off-by: Steve Longerbeam <slongerbeam@gmail.com>
> Cc: stable@vger.kernel.org
> ---
>  drivers/gpu/ipu-v3/ipu-ic.c | 61 ++++++++++++++++++++++---------------
>  1 file changed, 37 insertions(+), 24 deletions(-)
> 
> diff --git a/drivers/gpu/ipu-v3/ipu-ic.c b/drivers/gpu/ipu-v3/ipu-ic.c
> index 18816ccf600e..b63a2826b629 100644
> --- a/drivers/gpu/ipu-v3/ipu-ic.c
> +++ b/drivers/gpu/ipu-v3/ipu-ic.c
> @@ -175,7 +175,7 @@ static inline void ipu_ic_write(struct ipu_ic *ic, u32 value, unsigned offset)
>  	writel(value, ic->priv->base + offset);
>  }
>  
> -struct ic_csc_params {
> +struct ic_encode_coeff {

This less accurate. These are called IC (Task) Parameters in the
reference manual, the 64-bit aligned words are called CSC words. Beside
the coefficients, this structure also contains the coefficient scale,
the offsets, and the saturation mode flag.

>  	s16 coeff[3][3];	/* signed 9-bit integer coefficients */
>  	s16 offset[3];		/* signed 11+2-bit fixed point offset */
>  	u8 scale:2;		/* scale coefficients * 2^(scale-1) */
> @@ -183,13 +183,15 @@ struct ic_csc_params {
>  };
>  
>  /*
> - * Y = R *  .299 + G *  .587 + B *  .114;
> - * U = R * -.169 + G * -.332 + B *  .500 + 128.;
> - * V = R *  .500 + G * -.419 + B * -.0813 + 128.;
> + * BT.601 encoding from RGB full range to YUV full range:
> + *
> + * Y =  .2990 * R + .5870 * G + .1140 * B
> + * U = -.1687 * R - .3313 * G + .5000 * B + 128
> + * V =  .5000 * R - .4187 * G - .0813 * B + 128
>   */
> -static const struct ic_csc_params ic_csc_rgb2ycbcr = {
> +static const struct ic_encode_coeff ic_encode_rgb2ycbcr_601 = {
>  	.coeff = {
> -		{ 77, 150, 29 },
> +		{  77, 150,  29 },
>  		{ 469, 427, 128 },
>  		{ 128, 405, 491 },

We could subtract 512 from the negative values, to improve readability.

>  	},
> @@ -197,8 +199,11 @@ static const struct ic_csc_params ic_csc_rgb2ycbcr = {
>  	.scale = 1,
>  };
>  
> -/* transparent RGB->RGB matrix for graphics combining */
> -static const struct ic_csc_params ic_csc_rgb2rgb = {
> +/*
> + * identity matrix, used for transparent RGB->RGB graphics
> + * combining.
> + */
> +static const struct ic_encode_coeff ic_encode_identity = {
>  	.coeff = {
>  		{ 128, 0, 0 },
>  		{ 0, 128, 0 },
> @@ -208,17 +213,25 @@ static const struct ic_csc_params ic_csc_rgb2rgb = {
>  };
>  
>  /*
> - * R = (1.164 * (Y - 16)) + (1.596 * (Cr - 128));
> - * G = (1.164 * (Y - 16)) - (0.392 * (Cb - 128)) - (0.813 * (Cr - 128));
> - * B = (1.164 * (Y - 16)) + (2.017 * (Cb - 128);
> + * Inverse BT.601 encoding from YUV full range to RGB full range:
> + *
> + * R = 1. * Y +      0 * (Cb - 128) + 1.4020 * (Cr - 128)
> + * G = 1. * Y -  .3442 * (Cb - 128) - 0.7142 * (Cr - 128)

Should that be      ^^^^^ .3441   and     ^^^^^ .7141 ?
The coefficients and offsets after rounding should end up the same.

Also, let's consistently either add the leading zero, or leave it out.

> + * B = 1. * Y + 1.7720 * (Cb - 128) +      0 * (Cr - 128)
> + *
> + * equivalently (factoring out the offsets):
> + *
> + * R = 1. * Y  +      0 * Cb + 1.4020 * Cr - 179.456
> + * G = 1. * Y  -  .3442 * Cb - 0.7142 * Cr + 135.475
> + * B = 1. * Y  + 1.7720 * Cb +      0 * Cr - 226.816
>   */
> -static const struct ic_csc_params ic_csc_ycbcr2rgb = {
> +static const struct ic_encode_coeff ic_encode_ycbcr2rgb_601 = {
>  	.coeff = {
> -		{ 149, 0, 204 },
> -		{ 149, 462, 408 },
> -		{ 149, 255, 0 },
> +		{ 128,   0, 179 },
> +		{ 128, 468, 421 },
> +		{ 128, 227,   0 },
>  	},
> -	.offset = { -446, 266, -554 },
> +	.offset = { -359, 271, -454 },

These seem to be correct. Again, I think this would be easier to read if
the negative coefficients were written with a sign as well.

>  	.scale = 2,
>  };
>  
> @@ -228,7 +241,7 @@ static int init_csc(struct ipu_ic *ic,
>  		    int csc_index)
>  {
>  	struct ipu_ic_priv *priv = ic->priv;
> -	const struct ic_csc_params *params;
> +	const struct ic_encode_coeff *coeff;
>  	u32 __iomem *base;
>  	const u16 (*c)[3];
>  	const u16 *a;
> @@ -238,26 +251,26 @@ static int init_csc(struct ipu_ic *ic,
>  		(priv->tpmem_base + ic->reg->tpmem_csc[csc_index]);
>  
>  	if (inf == IPUV3_COLORSPACE_YUV && outf == IPUV3_COLORSPACE_RGB)
> -		params = &ic_csc_ycbcr2rgb;
> +		coeff = &ic_encode_ycbcr2rgb_601;
>  	else if (inf == IPUV3_COLORSPACE_RGB && outf == IPUV3_COLORSPACE_YUV)
> -		params = &ic_csc_rgb2ycbcr;
> +		coeff = &ic_encode_rgb2ycbcr_601;
>  	else if (inf == IPUV3_COLORSPACE_RGB && outf == IPUV3_COLORSPACE_RGB)
> -		params = &ic_csc_rgb2rgb;
> +		coeff = &ic_encode_identity;
>  	else {
>  		dev_err(priv->ipu->dev, "Unsupported color space conversion\n");
>  		return -EINVAL;
>  	}
>  
>  	/* Cast to unsigned */
> -	c = (const u16 (*)[3])params->coeff;
> -	a = (const u16 *)params->offset;
> +	c = (const u16 (*)[3])coeff->coeff;
> +	a = (const u16 *)coeff->offset;

This looks weird to me. I'd be in favor of not renaming the type.

regards
Philipp
