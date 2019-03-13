Return-Path: <SRS0=adTL=RQ=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_MUTT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A0C48C4360F
	for <linux-media@archiver.kernel.org>; Wed, 13 Mar 2019 00:14:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7058F2177E
	for <linux-media@archiver.kernel.org>; Wed, 13 Mar 2019 00:14:03 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=ideasonboard.com header.i=@ideasonboard.com header.b="iZ2K5seT"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726411AbfCMAOC (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 12 Mar 2019 20:14:02 -0400
Received: from perceval.ideasonboard.com ([213.167.242.64]:42378 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726008AbfCMAOC (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 12 Mar 2019 20:14:02 -0400
Received: from pendragon.ideasonboard.com (81-175-216-236.bb.dnainternet.fi [81.175.216.236])
        by perceval.ideasonboard.com (Postfix) with ESMTPSA id 686B322;
        Wed, 13 Mar 2019 01:14:00 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ideasonboard.com;
        s=mail; t=1552436040;
        bh=KXOo5x6UlG2EqjP4fRxoIoLHGijb4d2W60fZrtsVnTI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=iZ2K5seTt46f6Vj7t+T75mRqRBlhUn0t5JX9IabW/YGkfLxLOP0CxZVzP4tKQtKsA
         oirMuMh7GW9LkxrC/4TGcOBu3w2Bvu20MYxgors5oIxP93U/U/h/WoJLlluDbGZKna
         zEK/6pibjhJdJfvPWTDMpBBcAIa1nTVV/Qqrk2Pg=
Date:   Wed, 13 Mar 2019 02:13:53 +0200
From:   Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To:     Niklas =?utf-8?Q?S=C3=B6derlund?= 
        <niklas.soderlund+renesas@ragnatech.se>
Cc:     linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org
Subject: Re: [PATCH v3] rcar-csi2: Propagate the FLD signal for NTSC and PAL
Message-ID: <20190313001353.GF891@pendragon.ideasonboard.com>
References: <20190312234955.23310-1-niklas.soderlund+renesas@ragnatech.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20190312234955.23310-1-niklas.soderlund+renesas@ragnatech.se>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hi Niklas,

Thank you for the patch.

On Wed, Mar 13, 2019 at 12:49:55AM +0100, Niklas Söderlund wrote:
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
>  drivers/media/platform/rcar-vin/rcar-csi2.c | 16 +++++++++++++---
>  1 file changed, 13 insertions(+), 3 deletions(-)
> ---
> Hi,
> 
> This patch depends on '[PATCH v3 0/2] rcar-csi2: Use standby mode 
> instead of resetting'.
> 
> * Changes since v2
> - Set FLD_DET_SEL = 01
> 
> diff --git a/drivers/media/platform/rcar-vin/rcar-csi2.c b/drivers/media/platform/rcar-vin/rcar-csi2.c
> index 10f1b4978ed7dcc6..6c7c7e6072ffb09e 100644
> --- a/drivers/media/platform/rcar-vin/rcar-csi2.c
> +++ b/drivers/media/platform/rcar-vin/rcar-csi2.c
> @@ -68,6 +68,7 @@ struct rcar_csi2;
>  /* Field Detection Control */
>  #define FLD_REG				0x1c
>  #define FLD_FLD_NUM(n)			(((n) & 0xff) << 16)
> +#define FLD_DET_SEL(n)			(((n) & 0x3) << 4)
>  #define FLD_FLD_EN4			BIT(3)
>  #define FLD_FLD_EN3			BIT(2)
>  #define FLD_FLD_EN2			BIT(1)
> @@ -475,7 +476,7 @@ static int rcsi2_calc_mbps(struct rcar_csi2 *priv, unsigned int bpp)
>  static int rcsi2_start_receiver(struct rcar_csi2 *priv)
>  {
>  	const struct rcar_csi2_format *format;
> -	u32 phycnt, vcdt = 0, vcdt2 = 0;
> +	u32 phycnt, vcdt = 0, vcdt2 = 0, fld = 0;
>  	unsigned int i;
>  	int mbps, ret;
>  
> @@ -507,6 +508,16 @@ static int rcsi2_start_receiver(struct rcar_csi2 *priv)
>  			vcdt2 |= vcdt_part << ((i % 2) * 16);
>  	}
>  
> +	if (priv->mf.field == V4L2_FIELD_ALTERNATE) {
> +		fld = FLD_DET_SEL(1) | FLD_FLD_EN4 | FLD_FLD_EN3 | FLD_FLD_EN2
> +			| FLD_FLD_EN;
> +
> +		if (priv->mf.height == 240)
> +			fld |= FLD_FLD_NUM(2);

Should this be FLD_FLD_NUM(0) ? It won't make a difference in practice
as FLD_DET_SEL(1) ensures that only bit 0 is taken into account, but I
think the intent would be clearer (and the compiler will optimize it out
as FLD_FLD_NUM(0) == 0).

> +		else
> +			fld |= FLD_FLD_NUM(1);
> +	}
> +
>  	phycnt = PHYCNT_ENABLECLK;
>  	phycnt |= (1 << priv->lanes) - 1;
>  
> @@ -519,8 +530,7 @@ static int rcsi2_start_receiver(struct rcar_csi2 *priv)
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
