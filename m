Return-Path: <SRS0=Ztfs=PX=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.0 required=3.0
	tests=HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BD42EC43387
	for <linux-media@archiver.kernel.org>; Tue, 15 Jan 2019 08:38:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 80B3720645
	for <linux-media@archiver.kernel.org>; Tue, 15 Jan 2019 08:38:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728043AbfAOIi3 (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 15 Jan 2019 03:38:29 -0500
Received: from shell.v3.sk ([90.176.6.54]:51201 "EHLO shell.v3.sk"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725869AbfAOIi3 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 15 Jan 2019 03:38:29 -0500
Received: from localhost (localhost [127.0.0.1])
        by zimbra.v3.sk (Postfix) with ESMTP id B48C94470A;
        Tue, 15 Jan 2019 09:38:24 +0100 (CET)
Received: from shell.v3.sk ([127.0.0.1])
        by localhost (zimbra.v3.sk [127.0.0.1]) (amavisd-new, port 10032)
        with ESMTP id FjfMjTgxyuuq; Tue, 15 Jan 2019 09:38:19 +0100 (CET)
Received: from localhost (localhost [127.0.0.1])
        by zimbra.v3.sk (Postfix) with ESMTP id D454441D00;
        Tue, 15 Jan 2019 09:38:18 +0100 (CET)
X-Virus-Scanned: amavisd-new at zimbra.v3.sk
Received: from shell.v3.sk ([127.0.0.1])
        by localhost (zimbra.v3.sk [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id vFX_oqXmYkfG; Tue, 15 Jan 2019 09:38:17 +0100 (CET)
Received: from belphegor (nat-pool-brq-t.redhat.com [213.175.37.10])
        by zimbra.v3.sk (Postfix) with ESMTPSA id 789B744824;
        Tue, 15 Jan 2019 09:30:34 +0100 (CET)
Message-ID: <f6807e8ec5900b07bbaf6bb7e969b3da9be30f14.camel@v3.sk>
Subject: Re: [PATCH v3 02/14] media: ov7670: split register setting from
 set_framerate() logic
From:   Lubomir Rintel <lkundrak@v3.sk>
To:     Sakari Ailus <sakari.ailus@iki.fi>
Cc:     Mauro Carvalho Chehab <mchehab@kernel.org>,
        Jonathan Corbet <corbet@lwn.net>, linux-media@vger.kernel.org,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        James Cameron <quozl@laptop.org>, Pavel Machek <pavel@ucw.cz>,
        Libin Yang <lbyang@marvell.com>,
        Albert Wang <twang13@marvell.com>
Date:   Tue, 15 Jan 2019 09:30:31 +0100
In-Reply-To: <20190114230307.h5poc22jfs32hly3@valkosipuli.retiisi.org.uk>
References: <20181120100318.367987-1-lkundrak@v3.sk>
         <20181120100318.367987-3-lkundrak@v3.sk>
         <20190114230307.h5poc22jfs32hly3@valkosipuli.retiisi.org.uk>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.30.3 (3.30.3-1.fc29) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

On Tue, 2019-01-15 at 01:03 +0200, Sakari Ailus wrote:
> On Tue, Nov 20, 2018 at 11:03:07AM +0100, Lubomir Rintel wrote:
> > This will allow us to restore the last set frame rate after the device
> > returns from a power off.
> > 
> > Signed-off-by: Lubomir Rintel <lkundrak@v3.sk>
> > 
> > ---
> > Changes since v2:
> > - This patch was added to the series
> > 
> >  drivers/media/i2c/ov7670.c | 30 ++++++++++++++----------------
> >  1 file changed, 14 insertions(+), 16 deletions(-)
> > 
> > diff --git a/drivers/media/i2c/ov7670.c b/drivers/media/i2c/ov7670.c
> > index ee2302fbdeee..ead0c360df33 100644
> > --- a/drivers/media/i2c/ov7670.c
> > +++ b/drivers/media/i2c/ov7670.c
> > @@ -810,13 +810,24 @@ static void ov7675_get_framerate(struct v4l2_subdev *sd,
> >  			(4 * clkrc);
> >  }
> >  
> > +static int ov7675_apply_framerate(struct v4l2_subdev *sd)
> > +{
> > +	struct ov7670_info *info = to_state(sd);
> > +	int ret;
> > +
> > +	ret = ov7670_write(sd, REG_CLKRC, info->clkrc);
> > +	if (ret < 0)
> > +		return ret;
> > +
> > +	return ov7670_write(sd, REG_DBLV, info->pll_bypass ? DBLV_BYPASS : DBLV_X4);
> > +}
> > +
> >  static int ov7675_set_framerate(struct v4l2_subdev *sd,
> >  				 struct v4l2_fract *tpf)
> >  {
> >  	struct ov7670_info *info = to_state(sd);
> >  	u32 clkrc;
> >  	int pll_factor;
> > -	int ret;
> >  
> >  	/*
> >  	 * The formula is fps = 5/4*pixclk for YUV/RGB and
> > @@ -825,19 +836,10 @@ static int ov7675_set_framerate(struct v4l2_subdev *sd,
> >  	 * pixclk = clock_speed / (clkrc + 1) * PLLfactor
> >  	 *
> >  	 */
> > -	if (info->pll_bypass) {
> > -		pll_factor = 1;
> > -		ret = ov7670_write(sd, REG_DBLV, DBLV_BYPASS);
> > -	} else {
> > -		pll_factor = PLL_FACTOR;
> > -		ret = ov7670_write(sd, REG_DBLV, DBLV_X4);
> > -	}
> > -	if (ret < 0)
> > -		return ret;
> > -
> >  	if (tpf->numerator == 0 || tpf->denominator == 0) {
> >  		clkrc = 0;
> >  	} else {
> > +		pll_factor = info->pll_bypass ? 1 : PLL_FACTOR;
> >  		clkrc = (5 * pll_factor * info->clock_speed * tpf->numerator) /
> >  			(4 * tpf->denominator);
> >  		if (info->fmt->mbus_code == MEDIA_BUS_FMT_SBGGR8_1X8)
> > @@ -859,11 +861,7 @@ static int ov7675_set_framerate(struct v4l2_subdev *sd,
> >  	/* Recalculate frame rate */
> >  	ov7675_get_framerate(sd, tpf);
> >  
> > -	ret = ov7670_write(sd, REG_CLKRC, info->clkrc);
> > -	if (ret < 0)
> > -		return ret;
> > -
> > -	return ov7670_write(sd, REG_DBLV, DBLV_X4);
> > +	return ov7675_apply_framerate(sd);
> >  }
> >  
> >  static void ov7670_get_framerate_legacy(struct v4l2_subdev *sd,
> 
> Unfortunately this one no longer applies due to Jacopo's patch "v4l2: i2c:
> ov7670: Fix PLL bypass register values" in my tree. Could you resend it if
> you still think it's useful, please?
> 
> My tree is here:
> 
> <URL:https://git.linuxtv.org/sailus/media_tree.git/log/>
> 
> I've applied the rest there, with a trivial patch I'll send briefly.

Thank you.

It seems that you've accidentally attached the hunks of that patch to a
previous one though ("media: ov7670: split register setting from
set_fmt() logic"). There's just one conflicted line to resolve left.

I have a branch based on your tree that reverts the patch first and
then applies the two cleanly:

 git pull https://github.com/hackerspace/olpc-xo175-linux.git lr/ov7670

Feel free to pull, or, if you're fine with rebasing your tree, remove
the patch from your tree and then just pick the two.

Alternatively, if you prefer a patch by e-mail, please just let me know
when you've fixed things up in your tree.

Cheers
Lubo

> 
> Thanks.
> 

