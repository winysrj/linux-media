Return-Path: <SRS0=8Y7M=QS=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 589A8C169C4
	for <linux-media@archiver.kernel.org>; Mon, 11 Feb 2019 09:58:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2DEBC20863
	for <linux-media@archiver.kernel.org>; Mon, 11 Feb 2019 09:58:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726079AbfBKJ6j (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Mon, 11 Feb 2019 04:58:39 -0500
Received: from metis.ext.pengutronix.de ([85.220.165.71]:60387 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726045AbfBKJ6j (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 11 Feb 2019 04:58:39 -0500
Received: from lupine.hi.pengutronix.de ([2001:67c:670:100:3ad5:47ff:feaf:1a17] helo=lupine)
        by metis.ext.pengutronix.de with esmtp (Exim 4.89)
        (envelope-from <p.zabel@pengutronix.de>)
        id 1gt8MH-0007WF-JF; Mon, 11 Feb 2019 10:58:37 +0100
Message-ID: <1549879117.7687.2.camel@pengutronix.de>
Subject: Re: [PATCH v4 1/4] gpu: ipu-v3: ipu-ic: Rename yuv2rgb encoding
 matrices
From:   Philipp Zabel <p.zabel@pengutronix.de>
To:     Steve Longerbeam <slongerbeam@gmail.com>,
        linux-media@vger.kernel.org
Cc:     Tim Harvey <tharvey@gateworks.com>,
        "open list:DRM DRIVERS FOR FREESCALE IMX" 
        <dri-devel@lists.freedesktop.org>,
        open list <linux-kernel@vger.kernel.org>
Date:   Mon, 11 Feb 2019 10:58:37 +0100
In-Reply-To: <20190209014748.10427-2-slongerbeam@gmail.com>
References: <20190209014748.10427-1-slongerbeam@gmail.com>
         <20190209014748.10427-2-slongerbeam@gmail.com>
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
> The ycbcr2rgb and inverse rgb2ycbcr matrices define the BT.601 encoding
> coefficients, so rename them to indicate that. And add some comments
> to make clear these are BT.601 coefficients encoding between YUV limited
> range and RGB full range. The ic_csc_rgb2rgb matrix is just an identity
> matrix, so rename to ic_csc_identity. No functional changes.
> 
> Signed-off-by: Steve Longerbeam <slongerbeam@gmail.com>
> ---
> Changes in v2:
> - rename ic_csc_rgb2rgb matrix to ic_csc_identity.
> ---
>  drivers/gpu/ipu-v3/ipu-ic.c | 21 ++++++++++++++-------
>  1 file changed, 14 insertions(+), 7 deletions(-)
> 
> diff --git a/drivers/gpu/ipu-v3/ipu-ic.c b/drivers/gpu/ipu-v3/ipu-ic.c
> index 594c3cbc8291..3ef61f0b509b 100644
> --- a/drivers/gpu/ipu-v3/ipu-ic.c
> +++ b/drivers/gpu/ipu-v3/ipu-ic.c
> @@ -183,11 +183,13 @@ struct ic_csc_params {
>  };
>  
>  /*
> + * BT.601 encoding from RGB full range to YUV limited range:
> + *
>   * Y = R *  .299 + G *  .587 + B *  .114;
>   * U = R * -.169 + G * -.332 + B *  .500 + 128.;
>   * V = R *  .500 + G * -.419 + B * -.0813 + 128.;

Hm, this is a conversion to full range BT.601. For limited range, the
matrix coefficients

   0.2990  0.5870  0.1140
  -0.1687 -0.3313  0.5000
   0.5000 -0.4187 -0.0813

should be multiplied with 219/255 (Y) and 224/255 (U,V), respectively:

  Y = R *  .2568 + G *  .5041 + B *  .0979 + 16;
  U = R * -.1482 + G * -.2910 + B *  .4392 + 128;
  V = R *  .4392 + G * -.3678 + B * -.0714 + 128;

>   */
> -static const struct ic_csc_params ic_csc_rgb2ycbcr = {
> +static const struct ic_csc_params ic_csc_rgb2ycbcr_bt601 = {
>  	.coeff = {
>  		{ 77, 150, 29 },
>  		{ 469, 427, 128 },
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
> +static const struct ic_csc_params ic_csc_identity = {
>  	.coeff = {
>  		{ 128, 0, 0 },
>  		{ 0, 128, 0 },
> @@ -208,11 +213,13 @@ static const struct ic_csc_params ic_csc_rgb2rgb = {
>  };
>  
>  /*
> + * Inverse BT.601 encoding from YUV limited range to RGB full range:
> + *
>   * R = (1.164 * (Y - 16)) + (1.596 * (Cr - 128));
>   * G = (1.164 * (Y - 16)) - (0.392 * (Cb - 128)) - (0.813 * (Cr - 128));
>   * B = (1.164 * (Y - 16)) + (2.017 * (Cb - 128);
>   */

This looks correct.

> -static const struct ic_csc_params ic_csc_ycbcr2rgb = {
> +static const struct ic_csc_params ic_csc_ycbcr2rgb_bt601 = {
>  	.coeff = {
>  		{ 149, 0, 204 },
>  		{ 149, 462, 408 },
> @@ -238,11 +245,11 @@ static int init_csc(struct ipu_ic *ic,
>  		(priv->tpmem_base + ic->reg->tpmem_csc[csc_index]);
>  
>  	if (inf == IPUV3_COLORSPACE_YUV && outf == IPUV3_COLORSPACE_RGB)
> -		params = &ic_csc_ycbcr2rgb;
> +		params = &ic_csc_ycbcr2rgb_bt601;
>  	else if (inf == IPUV3_COLORSPACE_RGB && outf == IPUV3_COLORSPACE_YUV)
> -		params = &ic_csc_rgb2ycbcr;
> +		params = &ic_csc_rgb2ycbcr_bt601;
>  	else if (inf == IPUV3_COLORSPACE_RGB && outf == IPUV3_COLORSPACE_RGB)
> -		params = &ic_csc_rgb2rgb;
> +		params = &ic_csc_identity;
>  	else {
>  		dev_err(priv->ipu->dev, "Unsupported color space conversion\n");
>  		return -EINVAL;

regards
Philipp
