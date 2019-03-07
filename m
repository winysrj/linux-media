Return-Path: <SRS0=yxRx=RK=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 186E4C43381
	for <linux-media@archiver.kernel.org>; Thu,  7 Mar 2019 00:30:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D5C35206DD
	for <linux-media@archiver.kernel.org>; Thu,  7 Mar 2019 00:30:09 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=ragnatech-se.20150623.gappssmtp.com header.i=@ragnatech-se.20150623.gappssmtp.com header.b="tHjLnClW"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726161AbfCGAaJ (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 6 Mar 2019 19:30:09 -0500
Received: from mail-lf1-f68.google.com ([209.85.167.68]:43648 "EHLO
        mail-lf1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726104AbfCGAaJ (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 6 Mar 2019 19:30:09 -0500
Received: by mail-lf1-f68.google.com with SMTP id a130so2424174lfa.10
        for <linux-media@vger.kernel.org>; Wed, 06 Mar 2019 16:30:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ragnatech-se.20150623.gappssmtp.com; s=20150623;
        h=from:date:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to
         :user-agent;
        bh=Ll1ATQEXlaI3xu9YC5F1cCE73NOgY6DpmBaIi1j7wNI=;
        b=tHjLnClWWY5A+MA3rLz9j02QBmbTxFN/sa+phbFkzUL3sK24WZTlN44CW+zHZKX1Rc
         jQeYmj4JzPdTuAJ6/+u8nt2TqgOr3BCNlAoFR6ke6d4Y21VY2nneoPo/GxeE6dbnf3Ni
         TmLAaNU0rZ0lrGAatlt9oPhYWcByruezv2rfD7JPcbKV7lN8T0d5G+iuwgPoXwfYkdWu
         P3psZ3qgSUXSyWuQQ0juM0sW6yIkjWQeCpwu6y3zIaG4oUnUjQQdlyavP0Gd03j9F9Mx
         csJhrNAZSx0VvVZqnOn/Rrq117svO2ffIJK318Yz3nZXQrtJjJGPnK5icIPjrTTP44pz
         guaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:date:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        bh=Ll1ATQEXlaI3xu9YC5F1cCE73NOgY6DpmBaIi1j7wNI=;
        b=FSkQlIyp1PiE7LgxVHOw8PzhlJ/Qt8HX3WWnf5e752dHnjZ9DohkQGrr56C0CYlF0k
         u5Ke4ciYaDjQPdYobyCHC1XZBeN9DhCApZ4oj/gvVEClKbe3VcHMKGlX4nuoCl3fahJ/
         oG7ujtGdvX9g+XXObIUftHNLl+gZzy2qwaN6iauFri5lb7S9UxKx7WgTKSR/jIWVsrjf
         hAZv92acnPQmogRqvtKtJ3ast9p/rcL//TfA8aPGSagoNJ1NSswgn2ehhXQ1XPaO88Xd
         KbMqt1sGkTi6WuOOXRwTOvsMSzwP50XSn/GCon0pdNA3tPw67NQSptGu/b34vUkltqMF
         t+/g==
X-Gm-Message-State: APjAAAX28f3SpG1216Y8v9IEGY0a5PSujfFDssA9D7XrD8tHvArFZcup
        MfRJQwZM9gAob2khngwgfeFqLw==
X-Google-Smtp-Source: APXvYqyd7ggLCHQl+RZJKV81FeQd2EkR4i7QoIsgOI9gmm58mTw6EYe61TOst0utnSS4t0iT49wNxw==
X-Received: by 2002:a19:6806:: with SMTP id d6mr5397343lfc.48.1551918607239;
        Wed, 06 Mar 2019 16:30:07 -0800 (PST)
Received: from localhost (89-233-230-99.cust.bredband2.com. [89.233.230.99])
        by smtp.gmail.com with ESMTPSA id l21sm557938lfh.30.2019.03.06.16.30.06
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 06 Mar 2019 16:30:06 -0800 (PST)
From:   "Niklas =?iso-8859-1?Q?S=F6derlund?=" <niklas.soderlund@ragnatech.se>
X-Google-Original-From: Niklas =?iso-8859-1?Q?S=F6derlund?= <niklas.soderlund+renesas@ragnatech.se>
Date:   Thu, 7 Mar 2019 01:30:06 +0100
To:     Kieran Bingham <kieran.bingham@ideasonboard.com>
Cc:     Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org
Subject: Re: [PATCH 2/3] rcar-csi2: Update start procedure for H3 ES2
Message-ID: <20190307003006.GL9239@bigcity.dyn.berto.se>
References: <20190218100313.14529-1-niklas.soderlund+renesas@ragnatech.se>
 <20190218100313.14529-3-niklas.soderlund+renesas@ragnatech.se>
 <e00ba393-0c42-36ff-e491-e24d83913385@ideasonboard.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <e00ba393-0c42-36ff-e491-e24d83913385@ideasonboard.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hi Kieran,

Thanks for your feedback.

On 2019-02-18 11:01:51 +0000, Kieran Bingham wrote:
> Hi Niklas,
> 
> On 18/02/2019 10:03, Niklas Söderlund wrote:
> > Latest information from hardware engineers reveals that H3 ES2 and ES3
> > of behaves differently when working with link speeds bellow 250 Mpbs.
> 
> of? "of the rcar-csi2?"

s/of// :-)

> 
> > Add a SoC match for H3 ES2.* and use the correct startup sequence.
> > 
> > Signed-off-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
> 
> Assuming the step1 table is accurate, which I have not yet been able to
> validate:
> 
> Reviewed-by: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>

I have collected your tag with the spelling fixes bellow, thanks!

> 
> > ---
> >  drivers/media/platform/rcar-vin/rcar-csi2.c | 39 ++++++++++++++++++---
> >  1 file changed, 35 insertions(+), 4 deletions(-)
> > 
> > diff --git a/drivers/media/platform/rcar-vin/rcar-csi2.c b/drivers/media/platform/rcar-vin/rcar-csi2.c
> > index fbbe86a7a0fe14ab..50486301c21b4bae 100644
> > --- a/drivers/media/platform/rcar-vin/rcar-csi2.c
> > +++ b/drivers/media/platform/rcar-vin/rcar-csi2.c
> > @@ -932,6 +932,25 @@ static int rcsi2_init_phtw_h3_v3h_m3n(struct rcar_csi2 *priv, unsigned int mbps)
> >  	return rcsi2_phtw_write_array(priv, step2);
> >  }
> >  
> > +static int rcsi2_init_phtw_h3es2(struct rcar_csi2 *priv, unsigned int mbps)
> > +{
> > +	static const struct phtw_value step1[] = {
> > +		{ .data = 0xcc, .code = 0xe2 },
> > +		{ .data = 0x01, .code = 0xe3 },
> > +		{ .data = 0x11, .code = 0xe4 },
> > +		{ .data = 0x01, .code = 0xe5 },
> > +		{ .data = 0x10, .code = 0x04 },
> > +		{ .data = 0x38, .code = 0x08 },
> > +		{ .data = 0x01, .code = 0x00 },
> > +		{ .data = 0x4b, .code = 0xac },
> > +		{ .data = 0x03, .code = 0x00 },
> > +		{ .data = 0x80, .code = 0x07 },
> > +		{ /* sentinel */ },
> > +	};
> > +
> 
> This looks reasonable - but I can't identify a table to verify these values.
> 
> Is this generated from the flow charts in section 25.3.9?

Yes.

> 
> 
> > +	return rcsi2_phtw_write_array(priv, step1);
> > +}
> > +
> >  static int rcsi2_init_phtw_v3m_e3(struct rcar_csi2 *priv, unsigned int mbps)
> >  {
> >  	return rcsi2_phtw_write_mbps(priv, mbps, phtw_mbps_v3m_e3, 0x44);
> > @@ -994,6 +1013,14 @@ static const struct rcar_csi2_info rcar_csi2_info_r8a7795es1 = {
> >  	.num_channels = 4,
> >  };
> >  
> > +static const struct rcar_csi2_info rcar_csi2_info_r8a7795es2 = {
> > +	.init_phtw = rcsi2_init_phtw_h3es2,
> > +	.hsfreqrange = hsfreqrange_h3_v3h_m3n,
> > +	.csi0clkfreqrange = 0x20,
> > +	.num_channels = 4,
> > +	.clear_ulps = true,
> > +};
> > +
> >  static const struct rcar_csi2_info rcar_csi2_info_r8a7796 = {
> >  	.hsfreqrange = hsfreqrange_m3w_h3es1,
> >  	.num_channels = 4,
> > @@ -1059,11 +1086,15 @@ static const struct of_device_id rcar_csi2_of_table[] = {
> >  };
> >  MODULE_DEVICE_TABLE(of, rcar_csi2_of_table);
> >  
> > -static const struct soc_device_attribute r8a7795es1[] = {
> > +static const struct soc_device_attribute r8a7795[] = {
> >  	{
> >  		.soc_id = "r8a7795", .revision = "ES1.*",
> >  		.data = &rcar_csi2_info_r8a7795es1,
> >  	},
> > +	{
> > +		.soc_id = "r8a7795", .revision = "ES2.*",
> > +		.data = &rcar_csi2_info_r8a7795es2,
> > +	},
> >  	{ /* sentinel */ },
> >  };
> >  
> > @@ -1081,10 +1112,10 @@ static int rcsi2_probe(struct platform_device *pdev)
> >  	priv->info = of_device_get_match_data(&pdev->dev);
> >  
> >  	/*
> > -	 * r8a7795 ES1.x behaves differently than the ES2.0+ but doesn't
> > -	 * have it's own compatible string.
> > +	 * The different ES versions of r8a7795 (H3) behaves differently but
> 
> s/behaves/behave/
> 
> > +	 * shares the same compatible string.
> 
> s/shares/share/
> 
> >  	 */
> > -	attr = soc_device_match(r8a7795es1);
> > +	attr = soc_device_match(r8a7795);
> >  	if (attr)
> >  		priv->info = attr->data;
> >  
> > 
> 
> 
> -- 
> Regards
> --
> Kieran

-- 
Regards,
Niklas Söderlund
