Return-Path: <SRS0=l98e=O4=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.7 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_MUTT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9E5CEC43387
	for <linux-media@archiver.kernel.org>; Wed, 19 Dec 2018 15:58:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6B140217D9
	for <linux-media@archiver.kernel.org>; Wed, 19 Dec 2018 15:58:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1545235108;
	bh=WFjmUESCuYzgG5fu+T0BncSymYl5O7PV1e0RRELZmgc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=0W1M5HlDKfP/ZVtrtc704CwcfE59kYJARYQa2eh8K6Zj79uyGOHQzGxojLoyGMFg8
	 Yg1Sfx/rRXhDIBotPqNl+cNCsFpBigzW4QYSdpOGSdNava7RchYyspqi2VSfReNgFz
	 lB1239XSlTyiuc7nE26NjRWeXYywDyT2EwBhjp2k=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728827AbeLSP6W (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 19 Dec 2018 10:58:22 -0500
Received: from mail-oi1-f195.google.com ([209.85.167.195]:33667 "EHLO
        mail-oi1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728095AbeLSP6V (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 19 Dec 2018 10:58:21 -0500
Received: by mail-oi1-f195.google.com with SMTP id c206so2004259oib.0;
        Wed, 19 Dec 2018 07:58:21 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=CZ6helZFIbNZWd2xpX2RWEIGe/GgpkbWYhxxRVvlPGY=;
        b=ds3aEwrJvLvJSQwAviAWVEMJ+EL8DpRWFRjkJmypflAyMB05Hf5r/Il7804f7uK4QW
         USHQqSfMCZFhF1fMsZNzGAkU16kco+7PMpJ3sGmZwiJIqXXE9qQ/vSvLuU9IelSzJE32
         KPIFfokkCPFneX/4m7zSviNEiCVNbn//Pj5d/yb8+ocEmejLXBCLu2L9i6ssYESLWW6F
         oH6MMtv1uRGBg9A95SLnP4slo7j85A/l9VTv42awQ+svp8H+D0HhIeEcI8SHvKYo2BNL
         P3jnTpEK9ACy+7HsMD3JMqbzUcG79liEDuZ4prhvrZEbgi+O408KlBk5wYZJIhIQLlKC
         00jg==
X-Gm-Message-State: AA+aEWZHFR8lUbIh2C7lqDXrxMOFg/bqcEeDEJHlDcLEmgF3vVcevA7u
        judrG/76aqhwD5uYT2T4bdlb2yc=
X-Google-Smtp-Source: AFSGD/W9GXq5kAsnWs/Xnz7z663VsKaUGUVw1RXyP8zm6/ltLOF3fLAu87v6trOzW/o02sT4ob4rFQ==
X-Received: by 2002:aca:f244:: with SMTP id q65mr1333524oih.50.1545235100970;
        Wed, 19 Dec 2018 07:58:20 -0800 (PST)
Received: from localhost (24-155-109-49.dyn.grandenetworks.net. [24.155.109.49])
        by smtp.gmail.com with ESMTPSA id 75sm8770634otc.67.2018.12.19.07.58.20
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 19 Dec 2018 07:58:20 -0800 (PST)
Date:   Wed, 19 Dec 2018 09:58:19 -0600
From:   Rob Herring <robh@kernel.org>
To:     Jagan Teki <jagan@amarulasolutions.com>
Cc:     Chen-Yu Tsai <wens@csie.org>, Yong Deng <yong.deng@magewell.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Maxime Ripard <maxime.ripard@bootlin.com>,
        Mark Rutland <mark.rutland@arm.com>,
        linux-media <linux-media@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        devicetree <devicetree@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Michael Trimarchi <michael@amarulasolutions.com>
Subject: Re: [PATCH 5/5] arm64: dts: allwinner: a64-amarula-relic: Add OV5640
 camera node
Message-ID: <20181219155819.GA22708@bogus>
References: <20181203100747.16442-1-jagan@amarulasolutions.com>
 <20181203100747.16442-6-jagan@amarulasolutions.com>
 <CAGb2v6441wV7PM6q=vF2cpJtP9BGdYjQQqNU54rqELNJ5YcmdQ@mail.gmail.com>
 <CAMty3ZBBcum5CF1xQ_ePNUkcMoBPXngbiwf2V7hWHrH7-k3xuQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMty3ZBBcum5CF1xQ_ePNUkcMoBPXngbiwf2V7hWHrH7-k3xuQ@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

On Thu, Dec 06, 2018 at 04:43:33PM +0530, Jagan Teki wrote:
> On Mon, Dec 3, 2018 at 3:55 PM Chen-Yu Tsai <wens@csie.org> wrote:
> >
> > On Mon, Dec 3, 2018 at 6:08 PM Jagan Teki <jagan@amarulasolutions.com> wrote:
> > >
> > > Amarula A64-Relic board by default bound with OV5640 camera,
> > > so add support for it with below pin information.
> > >
> > > - PE13, PE12 via i2c-gpio bitbanging
> > > - CLK_CSI_MCLK as external clock
> > > - PE1 as external clock pin muxing
> > > - DLDO3 as vcc-csi supply
> > > - DLDO3 as AVDD supply
> > > - ALDO1 as DOVDD supply
> > > - ELDO3 as DVDD supply
> > > - PE14 gpio for reset pin
> > > - PE15 gpio for powerdown pin
> > >
> > > Signed-off-by: Jagan Teki <jagan@amarulasolutions.com>
> > > ---
> > >  .../allwinner/sun50i-a64-amarula-relic.dts    | 54 +++++++++++++++++++
> > >  arch/arm64/boot/dts/allwinner/sun50i-a64.dtsi |  5 ++
> > >  2 files changed, 59 insertions(+)
> > >
> > > diff --git a/arch/arm64/boot/dts/allwinner/sun50i-a64-amarula-relic.dts b/arch/arm64/boot/dts/allwinner/sun50i-a64-amarula-relic.dts
> > > index 6cb2b7f0c817..9ac6d773188b 100644
> > > --- a/arch/arm64/boot/dts/allwinner/sun50i-a64-amarula-relic.dts
> > > +++ b/arch/arm64/boot/dts/allwinner/sun50i-a64-amarula-relic.dts
> > > @@ -22,6 +22,41 @@
> > >                 stdout-path = "serial0:115200n8";
> > >         };
> > >
> > > +       i2c-csi {
> > > +               compatible = "i2c-gpio";
> > > +               sda-gpios = <&pio 4 13 (GPIO_ACTIVE_HIGH|GPIO_OPEN_DRAIN)>;
> > > +               scl-gpios = <&pio 4 12 (GPIO_ACTIVE_HIGH|GPIO_OPEN_DRAIN)>;
> >
> > FYI our hardware doesn't do open drain.
> 
> True, but the kernel is enforcing it seems, from the change from [1].
> does that mean Linux use open drain even though hardware doens't have?
> or did I miss anything?

It's forced because you can't do I2C without open drain. Things like the 
slave doing clock stretching won't work.

Rob
