Return-Path: <SRS0=G3Vt=RO=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 58A48C10F0C
	for <linux-media@archiver.kernel.org>; Mon, 11 Mar 2019 09:09:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 27FEB2084F
	for <linux-media@archiver.kernel.org>; Mon, 11 Mar 2019 09:09:11 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=ideasonboard.com header.i=@ideasonboard.com header.b="nWmHPFwL"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727079AbfCKJJK (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Mon, 11 Mar 2019 05:09:10 -0400
Received: from perceval.ideasonboard.com ([213.167.242.64]:49852 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725850AbfCKJJJ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 11 Mar 2019 05:09:09 -0400
Received: from pendragon.ideasonboard.com (dfj612yhrgyx302h3jwwy-3.rev.dnainternet.fi [IPv6:2001:14ba:21f5:5b00:ce28:277f:58d7:3ca4])
        by perceval.ideasonboard.com (Postfix) with ESMTPSA id 5394D304;
        Mon, 11 Mar 2019 10:09:07 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ideasonboard.com;
        s=mail; t=1552295347;
        bh=nWxTor5ivP5rc1xDjyeIHxjOButKmPATDbP5+d1f5Sw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=nWmHPFwL/pSy9dpOssPUZhcpw1p5iS0DM3ChH1repv+Yr4QUbxZglTmO148aF+rjW
         2h9YRvtO5SQ6PG9QhoKbkme4pE32/QmsW8kw1mnCWDco2ifl022vVfZON7RGQMoyQZ
         JnI85hTlFTV8LVesC0ofDAr5cNLzFcV3bPwnsvn0=
Date:   Mon, 11 Mar 2019 11:09:01 +0200
From:   Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To:     Niklas =?utf-8?Q?S=C3=B6derlund?= 
        <niklas.soderlund+renesas@ragnatech.se>
Cc:     linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org
Subject: Re: [PATCH v2] rcar-csi2: Propagate the FLD signal for NTSC and PAL
Message-ID: <20190311090901.GG4775@pendragon.ideasonboard.com>
References: <20190308235157.26357-1-niklas.soderlund+renesas@ragnatech.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20190308235157.26357-1-niklas.soderlund+renesas@ragnatech.se>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hi Niklas,

Thank you for the patch.

On Sat, Mar 09, 2019 at 12:51:57AM +0100, Niklas Söderlund wrote:
> Depending on which video standard is used the driver needs to setup the
> hardware to correctly handle fields. If stream is identified as NTSC
> or PAL setup field detection and propagate the field detection signal.
> 
> Later versions of the datasheet have been updated to make it clear
> that FLD register should be set to 0 when dealing with non-interlaced
> field formats.
> 
> Signed-off-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
> ---
>  drivers/media/platform/rcar-vin/rcar-csi2.c | 15 ++++++++++++---
>  1 file changed, 12 insertions(+), 3 deletions(-)
> 
> ---
> 
> Hi,
> 
> This patch depends on [PATCH v2 0/2] rcar-csi2: Use standby mode instead of resetting
> 
> 
> diff --git a/drivers/media/platform/rcar-vin/rcar-csi2.c b/drivers/media/platform/rcar-vin/rcar-csi2.c
> index 7a1c9b549e0fffc6..d9b29dbbcc2949de 100644
> --- a/drivers/media/platform/rcar-vin/rcar-csi2.c
> +++ b/drivers/media/platform/rcar-vin/rcar-csi2.c
> @@ -475,7 +475,7 @@ static int rcsi2_calc_mbps(struct rcar_csi2 *priv, unsigned int bpp)
>  static int rcsi2_start_receiver(struct rcar_csi2 *priv)
>  {
>  	const struct rcar_csi2_format *format;
> -	u32 phycnt, vcdt = 0, vcdt2 = 0;
> +	u32 phycnt, vcdt = 0, vcdt2 = 0, fld = 0;
>  	unsigned int i;
>  	int mbps, ret;
>  
> @@ -507,6 +507,16 @@ static int rcsi2_start_receiver(struct rcar_csi2 *priv)
>  			vcdt2 |= vcdt_part << ((i % 2) * 16);
>  	}
>  
> +	if (priv->mf.field != V4L2_FIELD_NONE &&

Shouldn't this be

	if (priv->mf.field == V4L2_FIELD_ALTERNATE) {

If the CSI-2 receiver gets a top/bottom-only or sequential field order I
would expect it not to toggle the field signal.

> +	    (priv->mf.height == 240 || priv->mf.height == 288)) {

I think you can drop this part of the check.

> +		fld =  FLD_FLD_EN4 | FLD_FLD_EN3 | FLD_FLD_EN2 | FLD_FLD_EN;
> +
> +		if (priv->mf.height == 240)
> +			fld |= FLD_FLD_NUM(2);
> +		else
> +			fld |= FLD_FLD_NUM(1);

How does this work ? Looking at the datasheet, I was expecting
FLD_DET_SEL field to be set to 01 in order for the field signal to
toggle every frame.

>+	}
> +
>  	phycnt = PHYCNT_ENABLECLK;
>  	phycnt |= (1 << priv->lanes) - 1;
>  
> @@ -519,8 +529,7 @@ static int rcsi2_start_receiver(struct rcar_csi2 *priv)
>  	rcsi2_write(priv, PHTC_REG, 0);
>  
>  	/* Configure */
> -	rcsi2_write(priv, FLD_REG, FLD_FLD_NUM(2) | FLD_FLD_EN4 |
> -		    FLD_FLD_EN3 | FLD_FLD_EN2 | FLD_FLD_EN);
> +	rcsi2_write(priv, FLD_REG, fld);
>  	rcsi2_write(priv, VCDT_REG, vcdt);
>  	if (vcdt2)
>  		rcsi2_write(priv, VCDT2_REG, vcdt2);

-- 
Regards,

Laurent Pinchart
