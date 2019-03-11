Return-Path: <SRS0=G3Vt=RO=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A7776C43381
	for <linux-media@archiver.kernel.org>; Mon, 11 Mar 2019 21:46:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 63ACF2147C
	for <linux-media@archiver.kernel.org>; Mon, 11 Mar 2019 21:46:05 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=ragnatech-se.20150623.gappssmtp.com header.i=@ragnatech-se.20150623.gappssmtp.com header.b="QOcEiDCF"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728008AbfCKVqF (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Mon, 11 Mar 2019 17:46:05 -0400
Received: from mail-lf1-f65.google.com ([209.85.167.65]:42845 "EHLO
        mail-lf1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727904AbfCKVqE (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 11 Mar 2019 17:46:04 -0400
Received: by mail-lf1-f65.google.com with SMTP id p1so434703lfk.9
        for <linux-media@vger.kernel.org>; Mon, 11 Mar 2019 14:46:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ragnatech-se.20150623.gappssmtp.com; s=20150623;
        h=from:date:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to
         :user-agent;
        bh=VV9hBYbs1BApnw3/CPAxiPoFba2/CpyS1KgFbzAv4Hs=;
        b=QOcEiDCF2H5wKgIpUU0PKNCncuKhGUn7CMjfR3vj7i/gwS4eRbxXjjG0TSfVLkFOZA
         8/HFEntx/58322gZoHx6OjVgxHiLEUMmOJslNL3puF0CaBsKp2r7NdgPPEd/OSmy2vfU
         l05bGOx5eU2JJZNGeoOpF18xBVahB66agDuVfW9n7L0SBKEPsfB3jgrBmCug9oRP+02s
         ray7sSBed+52yAMbUSwTf7H2iDm/a2m4XcdcbU54Lq+jzAJt7vM+uqPvx/8eC2ALhs5+
         NaoxDpF7kAvwXo9Ns9UCTtzkgn5KSePtgx7XcQqMelU103a8gGxQecUjyD3A5/HbQ8OC
         /zCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:date:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        bh=VV9hBYbs1BApnw3/CPAxiPoFba2/CpyS1KgFbzAv4Hs=;
        b=RyPh33+cwRXAWHQDoaqd7pBwkGdRvlT591JdEo244NG8Z9NfsNnEfzPT2SdXJVOKym
         hYQGWzLBosEgaGIN7kh5G6kf/VWggn5CpgSWC7kTY+yYnfsSeqHX46aGEFFnNfAZcShk
         +/yy9lEpsGKFOHCheFb4CeejapDO/GOkVIFdznPQjI995EK2SmQbYhqtQyKSBs5A6ijq
         kKzlH4X2rQZfnJ1E7dviE8Fn2biDq5dWcY5nNuMFueBDvYDZGKsvD/8K725au3Lqb1YK
         bliE4O4vsZNur3uxx6Y5fUfDT/hIB3XvYHCnTKxBpx3QCGvV/nqcBOhgdreZoJQN2Z6+
         7PAw==
X-Gm-Message-State: APjAAAVc0Tm1kZqZaMxqj6Ex6W2u5ail7lK25SoJNw8WQq4U+MQLD+FB
        FAJFTClo0BBTJOMuUIUKd//3EXS4j6U=
X-Google-Smtp-Source: APXvYqycpKanLWPsigRKxSaiHYOBE2gbXyGsBalXKq3CgzVdmVc+wJlu0bOnfJ9+8oh2yg882me93g==
X-Received: by 2002:a19:d3c2:: with SMTP id k185mr12004610lfg.24.1552340760973;
        Mon, 11 Mar 2019 14:46:00 -0700 (PDT)
Received: from localhost (89-233-230-99.cust.bredband2.com. [89.233.230.99])
        by smtp.gmail.com with ESMTPSA id i15sm1092046ljb.48.2019.03.11.14.45.59
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 11 Mar 2019 14:46:00 -0700 (PDT)
From:   "Niklas =?iso-8859-1?Q?S=F6derlund?=" <niklas.soderlund@ragnatech.se>
X-Google-Original-From: Niklas =?iso-8859-1?Q?S=F6derlund?= <niklas.soderlund+renesas@ragnatech.se>
Date:   Mon, 11 Mar 2019 22:45:59 +0100
To:     Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc:     linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org
Subject: Re: [PATCH v2] rcar-csi2: Propagate the FLD signal for NTSC and PAL
Message-ID: <20190311214559.GI5281@bigcity.dyn.berto.se>
References: <20190308235157.26357-1-niklas.soderlund+renesas@ragnatech.se>
 <20190311090901.GG4775@pendragon.ideasonboard.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20190311090901.GG4775@pendragon.ideasonboard.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hi Laurent,

Thanks for your feedback.

On 2019-03-11 11:09:01 +0200, Laurent Pinchart wrote:
> Hi Niklas,
> 
> Thank you for the patch.
> 
> On Sat, Mar 09, 2019 at 12:51:57AM +0100, Niklas Söderlund wrote:
> > Depending on which video standard is used the driver needs to setup the
> > hardware to correctly handle fields. If stream is identified as NTSC
> > or PAL setup field detection and propagate the field detection signal.
> > 
> > Later versions of the datasheet have been updated to make it clear
> > that FLD register should be set to 0 when dealing with non-interlaced
> > field formats.
> > 
> > Signed-off-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
> > ---
> >  drivers/media/platform/rcar-vin/rcar-csi2.c | 15 ++++++++++++---
> >  1 file changed, 12 insertions(+), 3 deletions(-)
> > 
> > ---
> > 
> > Hi,
> > 
> > This patch depends on [PATCH v2 0/2] rcar-csi2: Use standby mode instead of resetting
> > 
> > 
> > diff --git a/drivers/media/platform/rcar-vin/rcar-csi2.c b/drivers/media/platform/rcar-vin/rcar-csi2.c
> > index 7a1c9b549e0fffc6..d9b29dbbcc2949de 100644
> > --- a/drivers/media/platform/rcar-vin/rcar-csi2.c
> > +++ b/drivers/media/platform/rcar-vin/rcar-csi2.c
> > @@ -475,7 +475,7 @@ static int rcsi2_calc_mbps(struct rcar_csi2 *priv, unsigned int bpp)
> >  static int rcsi2_start_receiver(struct rcar_csi2 *priv)
> >  {
> >  	const struct rcar_csi2_format *format;
> > -	u32 phycnt, vcdt = 0, vcdt2 = 0;
> > +	u32 phycnt, vcdt = 0, vcdt2 = 0, fld = 0;
> >  	unsigned int i;
> >  	int mbps, ret;
> >  
> > @@ -507,6 +507,16 @@ static int rcsi2_start_receiver(struct rcar_csi2 *priv)
> >  			vcdt2 |= vcdt_part << ((i % 2) * 16);
> >  	}
> >  
> > +	if (priv->mf.field != V4L2_FIELD_NONE &&
> 
> Shouldn't this be
> 
> 	if (priv->mf.field == V4L2_FIELD_ALTERNATE) {
> 
> If the CSI-2 receiver gets a top/bottom-only or sequential field order I
> would expect it not to toggle the field signal.

For some reason I mixed all interlaced formats in to the mix while now 
it's clear ALTERNATE is the only one which make sens, thanks!

> 
> > +	    (priv->mf.height == 240 || priv->mf.height == 288)) {
> 
> I think you can drop this part of the check.

I added it to guard so this special case only would trigger for PAL and 
NTSC resolutions. But I think I agree with you that I might be over 
cautious.

> 
> > +		fld =  FLD_FLD_EN4 | FLD_FLD_EN3 | FLD_FLD_EN2 | FLD_FLD_EN;
> > +
> > +		if (priv->mf.height == 240)
> > +			fld |= FLD_FLD_NUM(2);
> > +		else
> > +			fld |= FLD_FLD_NUM(1);
> 
> How does this work ? Looking at the datasheet, I was expecting
> FLD_DET_SEL field to be set to 01 in order for the field signal to
> toggle every frame.

I thought so too then I read 26.4.5 FLD Signal which fits what is done 
in the BSP code and fits with how the hardware behaves.

> 
> >+	}
> > +
> >  	phycnt = PHYCNT_ENABLECLK;
> >  	phycnt |= (1 << priv->lanes) - 1;
> >  
> > @@ -519,8 +529,7 @@ static int rcsi2_start_receiver(struct rcar_csi2 *priv)
> >  	rcsi2_write(priv, PHTC_REG, 0);
> >  
> >  	/* Configure */
> > -	rcsi2_write(priv, FLD_REG, FLD_FLD_NUM(2) | FLD_FLD_EN4 |
> > -		    FLD_FLD_EN3 | FLD_FLD_EN2 | FLD_FLD_EN);
> > +	rcsi2_write(priv, FLD_REG, fld);
> >  	rcsi2_write(priv, VCDT_REG, vcdt);
> >  	if (vcdt2)
> >  		rcsi2_write(priv, VCDT2_REG, vcdt2);
> 
> -- 
> Regards,
> 
> Laurent Pinchart

-- 
Regards,
Niklas Söderlund
