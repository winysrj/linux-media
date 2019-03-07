Return-Path: <SRS0=yxRx=RK=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CA762C43381
	for <linux-media@archiver.kernel.org>; Thu,  7 Mar 2019 00:12:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 979DC20675
	for <linux-media@archiver.kernel.org>; Thu,  7 Mar 2019 00:12:57 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=ragnatech-se.20150623.gappssmtp.com header.i=@ragnatech-se.20150623.gappssmtp.com header.b="VVmpWc4c"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726277AbfCGAM4 (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 6 Mar 2019 19:12:56 -0500
Received: from mail-lj1-f195.google.com ([209.85.208.195]:45166 "EHLO
        mail-lj1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726121AbfCGAM4 (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 6 Mar 2019 19:12:56 -0500
Received: by mail-lj1-f195.google.com with SMTP id d24so12554101ljc.12
        for <linux-media@vger.kernel.org>; Wed, 06 Mar 2019 16:12:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ragnatech-se.20150623.gappssmtp.com; s=20150623;
        h=from:date:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to
         :user-agent;
        bh=sZqlgLKlj3NrWAwfsN4qNOid0E7eEWrVFdQeg4HlhRg=;
        b=VVmpWc4c+aDaJa1k4mXSi/5W6YFuKu4vLtVR7Pfb+JCkpkDfl/dUSiR+jdcGWKMKRk
         agpOgUzDrwa1z92N1lSTT/ugssuCexC8n5Ok/FAd2CYfDEDq3hQoYAVHY6MxXu0OUOma
         MCjG3OvRMX2TwkGMjfOcBgREeiOk7boKU/Eh5ACVPVsVe0V2OZA33ilj9u4qvfwsQdNr
         tL0BO3vto93vfZ0HvKKvIWB4jnLniwZGCq/NXGSrC3RXSiVanlR6/tqAlT+hur2/UJx7
         DoyWf1wNkD/ASybkQVOp+ZAIPSNDePvRra2eONG7RnNDktTVhlIGUSdff/sNZm29wTjT
         nYmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:date:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        bh=sZqlgLKlj3NrWAwfsN4qNOid0E7eEWrVFdQeg4HlhRg=;
        b=qS9Zh2G4UFXNDzPli8r3n7MZkRBIbFtgRE9HUWhfOa8FJFTi8REZm1697B8BBmUq/z
         5fPAUh6SRIQWrNdI54VLb0WaHTgcpN+eozhXRrrspZF3iTKWul/9vBgTztDPkBQa2eiE
         1MM/jMBbzzqBjsUl1ZCzS/bD2wWaBOVLR8lkaoJD2qP7DxUGY3MfTQRP83MKI89EvLGG
         7GbGo9S241BxKFht+NKQZV3JYUnCX8DZcMw5O4pQ0yuYywz8lOHQ28NWXOT7SbUvzluK
         tsPsm3uxL2ORKGnr+v4BmFaJKSqAi7CSIg4uR0c1EhwaBfIg//Z9FPT1omDBPNe6kEQZ
         SGyw==
X-Gm-Message-State: APjAAAVTzvOC+Lf5X7Z+f+UBWV8gWvqeYP3i6eaTfg0D4NMjnj/KjNLu
        ie3JzcymIarzQXRJDU616H+XAg==
X-Google-Smtp-Source: APXvYqyB7bogpZwMrIVtwEU7sJhWkPc2WTKOXIZl3zlidEt9C87XI+dfzWHCSpOpWrjJqXYq+H2iVg==
X-Received: by 2002:a2e:6d02:: with SMTP id i2mr4036302ljc.6.1551917574840;
        Wed, 06 Mar 2019 16:12:54 -0800 (PST)
Received: from localhost (89-233-230-99.cust.bredband2.com. [89.233.230.99])
        by smtp.gmail.com with ESMTPSA id d3sm546208lfj.39.2019.03.06.16.12.54
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 06 Mar 2019 16:12:54 -0800 (PST)
From:   "Niklas =?iso-8859-1?Q?S=F6derlund?=" <niklas.soderlund@ragnatech.se>
X-Google-Original-From: Niklas =?iso-8859-1?Q?S=F6derlund?= <niklas.soderlund+renesas@ragnatech.se>
Date:   Thu, 7 Mar 2019 01:12:54 +0100
To:     Geert Uytterhoeven <geert@linux-m68k.org>
Cc:     Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Linux-Renesas <linux-renesas-soc@vger.kernel.org>
Subject: Re: [PATCH] rcar-csi2: Use standby mode instead of resetting
Message-ID: <20190307001254.GI9239@bigcity.dyn.berto.se>
References: <20190216225638.7159-1-niklas.soderlund+renesas@ragnatech.se>
 <CAMuHMdUcGeffyxgZ2eBU2A=t-8c2Mo2eqvr-czSMRJy13AyYJA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAMuHMdUcGeffyxgZ2eBU2A=t-8c2Mo2eqvr-czSMRJy13AyYJA@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hi Geert,

Thanks for your feedback.

On 2019-02-18 10:07:04 +0100, Geert Uytterhoeven wrote:
> Hi Niklas,
> 
> On Sun, Feb 17, 2019 at 8:54 AM Niklas Söderlund
> <niklas.soderlund+renesas@ragnatech.se> wrote:
> > Later versions of the datasheet updates the reset procedure to more
> > closely resemble the standby mode. Update the driver to enter and exit
> > the standby mode instead of resetting the hardware before and after
> > streaming is started and stopped.
> >
> > While at it break out the full start and stop procedures from
> > rcsi2_s_stream() into the existing helper functions.
> >
> > Signed-off-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
> 
> Thanks for your patch!
> 
> > --- a/drivers/media/platform/rcar-vin/rcar-csi2.c
> > +++ b/drivers/media/platform/rcar-vin/rcar-csi2.c
> 
> > @@ -936,6 +947,10 @@ static int rcsi2_probe_resources(struct rcar_csi2 *priv,
> >         if (irq < 0)
> >                 return irq;
> >
> > +       priv->rstc = devm_reset_control_get(&pdev->dev, NULL);
> > +       if (IS_ERR(priv->rstc))
> > +               return PTR_ERR(priv->rstc);
> > +
> >         return 0;
> 
> Does the driver Kconfig option need "select RESET_CONTROLLER"?
> If the option is not enabled, devm_reset_control_get() will return -ENOTSUPP.

Yes it does, thanks for pointing this out, will add this in v2.

> 
> Gr{oetje,eeting}s,
> 
>                         Geert
> 
> -- 
> Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org
> 
> In personal conversations with technical people, I call myself a hacker. But
> when I'm talking to journalists I just say "programmer" or something like that.
>                                 -- Linus Torvalds

-- 
Regards,
Niklas Söderlund
