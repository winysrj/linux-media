Return-Path: <SRS0=CLae=PW=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.0 required=3.0
	tests=HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_NEOMUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3B7CDC43387
	for <linux-media@archiver.kernel.org>; Mon, 14 Jan 2019 23:04:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F417A20659
	for <linux-media@archiver.kernel.org>; Mon, 14 Jan 2019 23:04:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727138AbfANXEt (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Mon, 14 Jan 2019 18:04:49 -0500
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:37766 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726776AbfANXEt (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 14 Jan 2019 18:04:49 -0500
Received: from valkosipuli.localdomain (valkosipuli.retiisi.org.uk [IPv6:2001:1bc8:1a6:d3d5::80:2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by hillosipuli.retiisi.org.uk (Postfix) with ESMTPS id 1D1E3634C85;
        Tue, 15 Jan 2019 01:03:08 +0200 (EET)
Received: from sailus by valkosipuli.localdomain with local (Exim 4.89)
        (envelope-from <sakari.ailus@retiisi.org.uk>)
        id 1gjBG7-0004Fk-FH; Tue, 15 Jan 2019 01:03:07 +0200
Date:   Tue, 15 Jan 2019 01:03:07 +0200
From:   Sakari Ailus <sakari.ailus@iki.fi>
To:     Lubomir Rintel <lkundrak@v3.sk>
Cc:     Mauro Carvalho Chehab <mchehab@kernel.org>,
        Jonathan Corbet <corbet@lwn.net>, linux-media@vger.kernel.org,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        James Cameron <quozl@laptop.org>, Pavel Machek <pavel@ucw.cz>,
        Libin Yang <lbyang@marvell.com>,
        Albert Wang <twang13@marvell.com>
Subject: Re: [PATCH v3 02/14] media: ov7670: split register setting from
 set_framerate() logic
Message-ID: <20190114230307.h5poc22jfs32hly3@valkosipuli.retiisi.org.uk>
References: <20181120100318.367987-1-lkundrak@v3.sk>
 <20181120100318.367987-3-lkundrak@v3.sk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181120100318.367987-3-lkundrak@v3.sk>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

On Tue, Nov 20, 2018 at 11:03:07AM +0100, Lubomir Rintel wrote:
> This will allow us to restore the last set frame rate after the device
> returns from a power off.
> 
> Signed-off-by: Lubomir Rintel <lkundrak@v3.sk>
> 
> ---
> Changes since v2:
> - This patch was added to the series
> 
>  drivers/media/i2c/ov7670.c | 30 ++++++++++++++----------------
>  1 file changed, 14 insertions(+), 16 deletions(-)
> 
> diff --git a/drivers/media/i2c/ov7670.c b/drivers/media/i2c/ov7670.c
> index ee2302fbdeee..ead0c360df33 100644
> --- a/drivers/media/i2c/ov7670.c
> +++ b/drivers/media/i2c/ov7670.c
> @@ -810,13 +810,24 @@ static void ov7675_get_framerate(struct v4l2_subdev *sd,
>  			(4 * clkrc);
>  }
>  
> +static int ov7675_apply_framerate(struct v4l2_subdev *sd)
> +{
> +	struct ov7670_info *info = to_state(sd);
> +	int ret;
> +
> +	ret = ov7670_write(sd, REG_CLKRC, info->clkrc);
> +	if (ret < 0)
> +		return ret;
> +
> +	return ov7670_write(sd, REG_DBLV, info->pll_bypass ? DBLV_BYPASS : DBLV_X4);
> +}
> +
>  static int ov7675_set_framerate(struct v4l2_subdev *sd,
>  				 struct v4l2_fract *tpf)
>  {
>  	struct ov7670_info *info = to_state(sd);
>  	u32 clkrc;
>  	int pll_factor;
> -	int ret;
>  
>  	/*
>  	 * The formula is fps = 5/4*pixclk for YUV/RGB and
> @@ -825,19 +836,10 @@ static int ov7675_set_framerate(struct v4l2_subdev *sd,
>  	 * pixclk = clock_speed / (clkrc + 1) * PLLfactor
>  	 *
>  	 */
> -	if (info->pll_bypass) {
> -		pll_factor = 1;
> -		ret = ov7670_write(sd, REG_DBLV, DBLV_BYPASS);
> -	} else {
> -		pll_factor = PLL_FACTOR;
> -		ret = ov7670_write(sd, REG_DBLV, DBLV_X4);
> -	}
> -	if (ret < 0)
> -		return ret;
> -
>  	if (tpf->numerator == 0 || tpf->denominator == 0) {
>  		clkrc = 0;
>  	} else {
> +		pll_factor = info->pll_bypass ? 1 : PLL_FACTOR;
>  		clkrc = (5 * pll_factor * info->clock_speed * tpf->numerator) /
>  			(4 * tpf->denominator);
>  		if (info->fmt->mbus_code == MEDIA_BUS_FMT_SBGGR8_1X8)
> @@ -859,11 +861,7 @@ static int ov7675_set_framerate(struct v4l2_subdev *sd,
>  	/* Recalculate frame rate */
>  	ov7675_get_framerate(sd, tpf);
>  
> -	ret = ov7670_write(sd, REG_CLKRC, info->clkrc);
> -	if (ret < 0)
> -		return ret;
> -
> -	return ov7670_write(sd, REG_DBLV, DBLV_X4);
> +	return ov7675_apply_framerate(sd);
>  }
>  
>  static void ov7670_get_framerate_legacy(struct v4l2_subdev *sd,

Unfortunately this one no longer applies due to Jacopo's patch "v4l2: i2c:
ov7670: Fix PLL bypass register values" in my tree. Could you resend it if
you still think it's useful, please?

My tree is here:

<URL:https://git.linuxtv.org/sailus/media_tree.git/log/>

I've applied the rest there, with a trivial patch I'll send briefly.

Thanks.

-- 
Sakari Ailus
