Return-Path: <SRS0=ZIWa=RP=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 11DB1C4360F
	for <linux-media@archiver.kernel.org>; Tue, 12 Mar 2019 18:44:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CB3BD214D8
	for <linux-media@archiver.kernel.org>; Tue, 12 Mar 2019 18:44:21 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=ragnatech-se.20150623.gappssmtp.com header.i=@ragnatech-se.20150623.gappssmtp.com header.b="GX4wCRY/"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727191AbfCLSoU (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 12 Mar 2019 14:44:20 -0400
Received: from mail-lf1-f66.google.com ([209.85.167.66]:36162 "EHLO
        mail-lf1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726490AbfCLSoT (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 12 Mar 2019 14:44:19 -0400
Received: by mail-lf1-f66.google.com with SMTP id d18so2196858lfn.3
        for <linux-media@vger.kernel.org>; Tue, 12 Mar 2019 11:44:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ragnatech-se.20150623.gappssmtp.com; s=20150623;
        h=from:date:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to
         :user-agent;
        bh=fYySe7ySL1mPl4Rm88gZiz9LhLV0NQAh0R2LEfwoG5Q=;
        b=GX4wCRY/hRBbdmLIQh1r5BPIJj9qlJLuHrqTReWkivVI1GA1DHh6cfUPU8Jj+uzSHi
         SO5rNR+tKANCWIka/c1ceNLFHXZTy6hw2eP9KRb9bpvRXo4wb0xXfffybrUIDA2JelVA
         ibGnhDWuV7vyOR19Sx98pj6YDCP1SFnkqLXB1buJwFO1a/J+2OuGcJIxCpyaAahgBLRb
         KuMlRUdw5zh69ZfE0M+QxmTdEDQuR8bHSQEFWAtbM3Gp7RhfCoCSoTBvVgWWmH+VJ56G
         rq6fzQ/OBscmt/31SZRGHHcAHQIm3eeQ72H2fo9HzDemNgN6zA/7nbPQ42qEjS5HaQho
         0KRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:date:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        bh=fYySe7ySL1mPl4Rm88gZiz9LhLV0NQAh0R2LEfwoG5Q=;
        b=tHqKeCjOGjjsSmD8lGem8rRZ3p8XJYC/BXpotpqRZjLL+OYUzq2XB9qkhQlhKfl1xX
         kYn1sp0W7rV5litPH1qeOLNFz+4Nm20pn9dyxIifJccCiVuJ9sxKrYaAeZmeMs/KSOe6
         2qSQ7WnTMTjVmLq6/8Z3QYyDrGBKvrOdrpSqQo/nbrxNZx7VEWT39H0f+UANFVXmQobr
         fcYk1nM3cfiFo1NFRaqQL2dZOLo0GMEI1aeQsQ5+AUiIWpKTFkp4Fe9txIJ19dPxKUJr
         NGTGht1tNqxuYiwvVHOirP0Iz+nU1fVdyrbjrdk4xZUxEJTpOl8QaQ9gN3WjkCjcDwor
         wlCg==
X-Gm-Message-State: APjAAAUYU1qARMGzpipQ0RVylXBJJYLlIivnoo0SHf6BFjh4PaVeZ/yf
        33vkG7GxRBZ+US0Dcro2Dxy4pa5ZHns=
X-Google-Smtp-Source: APXvYqxbGCirvUDZOxf6ctLGrmBDEhhXcOBy9d2Vr1AnGI0dupAsFGSLJV0TcNSRnPzgbkGepEr6Zg==
X-Received: by 2002:ac2:4424:: with SMTP id w4mr7905318lfl.148.1552416257299;
        Tue, 12 Mar 2019 11:44:17 -0700 (PDT)
Received: from localhost (89-233-230-99.cust.bredband2.com. [89.233.230.99])
        by smtp.gmail.com with ESMTPSA id x10sm889548lff.45.2019.03.12.11.44.16
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 12 Mar 2019 11:44:16 -0700 (PDT)
From:   "Niklas =?iso-8859-1?Q?S=F6derlund?=" <niklas.soderlund@ragnatech.se>
X-Google-Original-From: Niklas =?iso-8859-1?Q?S=F6derlund?= <niklas.soderlund+renesas@ragnatech.se>
Date:   Tue, 12 Mar 2019 19:44:16 +0100
To:     Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc:     linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
Subject: Re: [PATCH v2 2/3] rcar-csi2: Update start procedure for H3 ES2
Message-ID: <20190312184416.GC1776@bigcity.dyn.berto.se>
References: <20190308235702.27057-1-niklas.soderlund+renesas@ragnatech.se>
 <20190308235702.27057-3-niklas.soderlund+renesas@ragnatech.se>
 <20190311092725.GI4775@pendragon.ideasonboard.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20190311092725.GI4775@pendragon.ideasonboard.com>
User-Agent: Mutt/1.11.3 (2019-02-01)
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hi Laurent,

Thanks for your feedback.

On 2019-03-11 11:27:25 +0200, Laurent Pinchart wrote:
> Hi Niklas,
> 
> Thank you for the patch.
> 
> On Sat, Mar 09, 2019 at 12:57:01AM +0100, Niklas Söderlund wrote:
> > Latest information from hardware engineers reveals that H3 ES2 and ES3
> > behave differently when working with link speeds bellow 250 Mpbs.
> > Add a SoC match for H3 ES2.* and use the correct startup sequence.
> > 
> > Signed-off-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
> > Reviewed-by: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
> > ---
> >  drivers/media/platform/rcar-vin/rcar-csi2.c | 39 ++++++++++++++++++---
> >  1 file changed, 35 insertions(+), 4 deletions(-)
> > 
> > diff --git a/drivers/media/platform/rcar-vin/rcar-csi2.c b/drivers/media/platform/rcar-vin/rcar-csi2.c
> > index 6be81d4839f35a0e..07d5c8c66b7cd382 100644
> > --- a/drivers/media/platform/rcar-vin/rcar-csi2.c
> > +++ b/drivers/media/platform/rcar-vin/rcar-csi2.c
> > @@ -914,6 +914,25 @@ static int rcsi2_init_phtw_h3_v3h_m3n(struct rcar_csi2 *priv, unsigned int mbps)
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
> > +	return rcsi2_phtw_write_array(priv, step1);
> 
> Another option would have been to condition the mbps check in
> rcsi2_init_phtw_h3_v3h_m3n() to the ES version, which would save a bit
> of memory as we could remove the above table, but we would need to add a
> field to the rcar_csi2_info structure so we may not save much in the
> end.

I agree this would not be my preferred solution.

> 
> I wonder, however, if you could move the step1 and step2 tables out of
> rcsi2_init_phtw_h3_v3h_m3n() and reuse them here, or possibly create a
> __rcsi2_init_phtw_h3_v3h_m3n() with two rcsi2_init_phtw_h3_v3h_m3n() and
> wrappers rcsi2_init_phtw_h3es2() wrappers.

This feels like a nicer solution, will use it in next version. Thanks 
for the good suggestion.

> 
> > +}
> > +
> >  static int rcsi2_init_phtw_v3m_e3(struct rcar_csi2 *priv, unsigned int mbps)
> >  {
> >  	return rcsi2_phtw_write_mbps(priv, mbps, phtw_mbps_v3m_e3, 0x44);
> > @@ -976,6 +995,14 @@ static const struct rcar_csi2_info rcar_csi2_info_r8a7795es1 = {
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
> > @@ -1041,11 +1068,15 @@ static const struct of_device_id rcar_csi2_of_table[] = {
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
> > @@ -1063,10 +1094,10 @@ static int rcsi2_probe(struct platform_device *pdev)
> >  	priv->info = of_device_get_match_data(&pdev->dev);
> >  
> >  	/*
> > -	 * r8a7795 ES1.x behaves differently than the ES2.0+ but doesn't
> > -	 * have it's own compatible string.
> > +	 * The different ES versions of r8a7795 (H3) behave differently but
> > +	 * share the same compatible string.
> >  	 */
> > -	attr = soc_device_match(r8a7795es1);
> > +	attr = soc_device_match(r8a7795);
> >  	if (attr)
> >  		priv->info = attr->data;
> >  
> 
> -- 
> Regards,
> 
> Laurent Pinchart

-- 
Regards,
Niklas Söderlund
