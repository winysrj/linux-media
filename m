Return-Path: <SRS0=G3Vt=RO=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C258EC10F06
	for <linux-media@archiver.kernel.org>; Mon, 11 Mar 2019 22:10:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5E531214AE
	for <linux-media@archiver.kernel.org>; Mon, 11 Mar 2019 22:10:35 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=ideasonboard.com header.i=@ideasonboard.com header.b="IiL+NKU5"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728438AbfCKWKd (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Mon, 11 Mar 2019 18:10:33 -0400
Received: from perceval.ideasonboard.com ([213.167.242.64]:37826 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727138AbfCKWKd (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 11 Mar 2019 18:10:33 -0400
Received: from pendragon.ideasonboard.com (81-175-216-236.bb.dnainternet.fi [81.175.216.236])
        by perceval.ideasonboard.com (Postfix) with ESMTPSA id 33EA99B8;
        Mon, 11 Mar 2019 23:10:30 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ideasonboard.com;
        s=mail; t=1552342230;
        bh=LXHb1CWiAzGvfZt6yqW+mvavpjZoJE6zQDFhFpejwCA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=IiL+NKU5tNvC5kMVVa7gj1bGE+IfPx8v/yUJJ1grUYEcHEYvz/Y8dnB5d/682XxFt
         ZfXXA1GftyyoRPN1tMjlgP2IhHVw8GDycavKxiJQpULHUVl2C1VkkBfFIzD5M3vDsB
         xzJjxrMKjNQj7RUN5pP0rgrzUVSuqCi1oc9XcKp8=
Date:   Tue, 12 Mar 2019 00:10:23 +0200
From:   Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To:     Niklas =?utf-8?Q?S=C3=B6derlund?= <niklas.soderlund@ragnatech.se>
Cc:     linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org
Subject: Re: [PATCH v2] rcar-csi2: Propagate the FLD signal for NTSC and PAL
Message-ID: <20190311221023.GA12319@pendragon.ideasonboard.com>
References: <20190308235157.26357-1-niklas.soderlund+renesas@ragnatech.se>
 <20190311090901.GG4775@pendragon.ideasonboard.com>
 <20190311214559.GI5281@bigcity.dyn.berto.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20190311214559.GI5281@bigcity.dyn.berto.se>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hi Niklas,

On Mon, Mar 11, 2019 at 10:45:59PM +0100, Niklas Söderlund wrote:
> On 2019-03-11 11:09:01 +0200, Laurent Pinchart wrote:
> > On Sat, Mar 09, 2019 at 12:51:57AM +0100, Niklas Söderlund wrote:
> >> Depending on which video standard is used the driver needs to setup the
> >> hardware to correctly handle fields. If stream is identified as NTSC
> >> or PAL setup field detection and propagate the field detection signal.
> >> 
> >> Later versions of the datasheet have been updated to make it clear
> >> that FLD register should be set to 0 when dealing with non-interlaced
> >> field formats.
> >> 
> >> Signed-off-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
> >> ---
> >>  drivers/media/platform/rcar-vin/rcar-csi2.c | 15 ++++++++++++---
> >>  1 file changed, 12 insertions(+), 3 deletions(-)
> >> 
> >> ---
> >> 
> >> Hi,
> >> 
> >> This patch depends on [PATCH v2 0/2] rcar-csi2: Use standby mode instead of resetting
> >> 
> >> 
> >> diff --git a/drivers/media/platform/rcar-vin/rcar-csi2.c b/drivers/media/platform/rcar-vin/rcar-csi2.c
> >> index 7a1c9b549e0fffc6..d9b29dbbcc2949de 100644
> >> --- a/drivers/media/platform/rcar-vin/rcar-csi2.c
> >> +++ b/drivers/media/platform/rcar-vin/rcar-csi2.c
> >> @@ -475,7 +475,7 @@ static int rcsi2_calc_mbps(struct rcar_csi2 *priv, unsigned int bpp)
> >>  static int rcsi2_start_receiver(struct rcar_csi2 *priv)
> >>  {
> >>  	const struct rcar_csi2_format *format;
> >> -	u32 phycnt, vcdt = 0, vcdt2 = 0;
> >> +	u32 phycnt, vcdt = 0, vcdt2 = 0, fld = 0;
> >>  	unsigned int i;
> >>  	int mbps, ret;
> >>  
> >> @@ -507,6 +507,16 @@ static int rcsi2_start_receiver(struct rcar_csi2 *priv)
> >>  			vcdt2 |= vcdt_part << ((i % 2) * 16);
> >>  	}
> >>  
> >> +	if (priv->mf.field != V4L2_FIELD_NONE &&
> > 
> > Shouldn't this be
> > 
> > 	if (priv->mf.field == V4L2_FIELD_ALTERNATE) {
> > 
> > If the CSI-2 receiver gets a top/bottom-only or sequential field order I
> > would expect it not to toggle the field signal.
> 
> For some reason I mixed all interlaced formats in to the mix while now 
> it's clear ALTERNATE is the only one which make sens, thanks!
> 
> > 
> >> +	    (priv->mf.height == 240 || priv->mf.height == 288)) {
> > 
> > I think you can drop this part of the check.
> 
> I added it to guard so this special case only would trigger for PAL and 
> NTSC resolutions. But I think I agree with you that I might be over 
> cautious.
> 
> > 
> >> +		fld =  FLD_FLD_EN4 | FLD_FLD_EN3 | FLD_FLD_EN2 | FLD_FLD_EN;
> >> +
> >> +		if (priv->mf.height == 240)
> >> +			fld |= FLD_FLD_NUM(2);
> >> +		else
> >> +			fld |= FLD_FLD_NUM(1);
> > 
> > How does this work ? Looking at the datasheet, I was expecting
> > FLD_DET_SEL field to be set to 01 in order for the field signal to
> > toggle every frame.
> 
> I thought so too then I read 26.4.5 FLD Signal which fits what is done 
> in the BSP code and fits with how the hardware behaves.

Do we have a guarantee that all alternate sources will cycle the frame
number between 1 and 2 ? If not I think you should select based on the
LSB.

> > >+	}
> >> +
> >>  	phycnt = PHYCNT_ENABLECLK;
> >>  	phycnt |= (1 << priv->lanes) - 1;
> >>  
> >> @@ -519,8 +529,7 @@ static int rcsi2_start_receiver(struct rcar_csi2 *priv)
> >>  	rcsi2_write(priv, PHTC_REG, 0);
> >>  
> >>  	/* Configure */
> >> -	rcsi2_write(priv, FLD_REG, FLD_FLD_NUM(2) | FLD_FLD_EN4 |
> >> -		    FLD_FLD_EN3 | FLD_FLD_EN2 | FLD_FLD_EN);
> >> +	rcsi2_write(priv, FLD_REG, fld);
> >>  	rcsi2_write(priv, VCDT_REG, vcdt);
> >>  	if (vcdt2)
> >>  		rcsi2_write(priv, VCDT2_REG, vcdt2);

-- 
Regards,

Laurent Pinchart
