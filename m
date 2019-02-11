Return-Path: <SRS0=8Y7M=QS=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3B309C169C4
	for <linux-media@archiver.kernel.org>; Mon, 11 Feb 2019 10:12:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0FBEC20838
	for <linux-media@archiver.kernel.org>; Mon, 11 Feb 2019 10:12:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726061AbfBKKMg (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Mon, 11 Feb 2019 05:12:36 -0500
Received: from metis.ext.pengutronix.de ([85.220.165.71]:33883 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725931AbfBKKMg (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 11 Feb 2019 05:12:36 -0500
Received: from lupine.hi.pengutronix.de ([2001:67c:670:100:3ad5:47ff:feaf:1a17] helo=lupine)
        by metis.ext.pengutronix.de with esmtp (Exim 4.89)
        (envelope-from <p.zabel@pengutronix.de>)
        id 1gt8Zm-0000aN-V5; Mon, 11 Feb 2019 11:12:34 +0100
Message-ID: <1549879951.7687.6.camel@pengutronix.de>
Subject: Re: [PATCH v4 3/4] gpu: ipu-v3: ipu-ic: Add support for BT.709
 encoding
From:   Philipp Zabel <p.zabel@pengutronix.de>
To:     Steve Longerbeam <slongerbeam@gmail.com>,
        linux-media@vger.kernel.org
Cc:     Tim Harvey <tharvey@gateworks.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        "open list:DRM DRIVERS FOR FREESCALE IMX" 
        <dri-devel@lists.freedesktop.org>,
        open list <linux-kernel@vger.kernel.org>,
        "open list:STAGING SUBSYSTEM" <devel@driverdev.osuosl.org>,
        "open list:FRAMEBUFFER LAYER" <linux-fbdev@vger.kernel.org>
Date:   Mon, 11 Feb 2019 11:12:31 +0100
In-Reply-To: <20190209014748.10427-4-slongerbeam@gmail.com>
References: <20190209014748.10427-1-slongerbeam@gmail.com>
         <20190209014748.10427-4-slongerbeam@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.22.6-1+deb9u1 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:100:3ad5:47ff:feaf:1a17
X-SA-Exim-Mail-From: p.zabel@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-media@vger.kernel.org
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

On Fri, 2019-02-08 at 17:47 -0800, Steve Longerbeam wrote:
> Pass v4l2 encoding enum to the ipu_ic task init functions, and add
> support for the BT.709 encoding and inverse encoding matrices.
> 
> Reported-by: Tim Harvey <tharvey@gateworks.com>
> Signed-off-by: Steve Longerbeam <slongerbeam@gmail.com>
> ---
> Changes in v4:
> - fix compile error.
> Chnges in v3:
> - none.
> Changes in v2:
> - only return "Unsupported YCbCr encoding" error if inf != outf,
>   since if inf == outf, the identity matrix can be used. Reported
>   by Tim Harvey.
> ---
>  drivers/gpu/ipu-v3/ipu-ic.c                 | 71 +++++++++++++++++++--
>  drivers/gpu/ipu-v3/ipu-image-convert.c      |  1 +
>  drivers/staging/media/imx/imx-ic-prpencvf.c |  4 +-
>  include/video/imx-ipu-v3.h                  |  5 +-
>  4 files changed, 71 insertions(+), 10 deletions(-)
> 
> diff --git a/drivers/gpu/ipu-v3/ipu-ic.c b/drivers/gpu/ipu-v3/ipu-ic.c
> index e459615a49a1..c5f83d7e357f 100644
> --- a/drivers/gpu/ipu-v3/ipu-ic.c
> +++ b/drivers/gpu/ipu-v3/ipu-ic.c
> @@ -212,6 +212,23 @@ static const struct ic_csc_params ic_csc_identity = {
>  	.scale = 2,
>  };
>  
> +/*
> + * BT.709 encoding from RGB full range to YUV limited range:
> + *
> + * Y = R *  .2126 + G *  .7152 + B *  .0722;
> + * U = R * -.1146 + G * -.3854 + B *  .5000 + 128.;
> + * V = R *  .5000 + G * -.4542 + B * -.0458 + 128.;

This is a conversion to YUV full range. Limited range should be:

Y   R *  .1826 + G *  .6142 + B *  .0620 + 16;
U = R * -.1007 + G * -.3385 + B *  .4392 + 128;
V   R *  .4392 + G * -.3990 + B * -.0402 + 128;

> + */
> +static const struct ic_csc_params ic_csc_rgb2ycbcr_bt709 = {
> +	.coeff = {
> +		{ 54, 183, 18 },
> +		{ 483, 413, 128 },
> +		{ 128, 396, 500 },
> +	},
> +	.offset = { 0, 512, 512 },
> +	.scale = 1,
> +};
> +
>  /*
>   * Inverse BT.601 encoding from YUV limited range to RGB full range:
>   *
> @@ -229,12 +246,31 @@ static const struct ic_csc_params ic_csc_ycbcr2rgb_bt601 = {
>  	.scale = 2,
>  };
>  
> +/*
> + * Inverse BT.709 encoding from YUV limited range to RGB full range:
> + *
> + * R = (1. * (Y - 16)) + (1.5748 * (Cr - 128));
> + * G = (1. * (Y - 16)) - (0.1873 * (Cb - 128)) - (0.4681 * (Cr - 128));
> + * B = (1. * (Y - 16)) + (1.8556 * (Cb - 128);

The coefficients look like full range again, conversion from limited
range YUV should look like:

  R = (1.1644 * (Y - 16)) + (1.7927 * (Cr - 128));
  G = (1.1644 * (Y - 16)) - (0.2132 * (Cb - 128)) - (0.5329 * (Cr - 128));
  B = (1.1644 * (Y - 16)) + (2.1124 * (Cb - 128);

> + */
> +static const struct ic_csc_params ic_csc_ycbcr2rgb_bt709 = {
> +	.coeff = {
> +		{ 128, 0, 202 },
> +		{ 128, 488, 452 },
> +		{ 128, 238, 0 },
> +	},
> +	.offset = { -435, 136, -507 },
> +	.scale = 2,
> +};
> +
>  static int init_csc(struct ipu_ic *ic,
>  		    enum ipu_color_space inf,
>  		    enum ipu_color_space outf,
> +		    enum v4l2_ycbcr_encoding encoding,

Should we support YUV BT.601 <-> YUV REC.709 conversions? That would
require separate encodings for input and output. Also, this might be a
good time to think about adding quantization range parameters as well.

regards
Philipp
