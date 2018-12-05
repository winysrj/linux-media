Return-Path: <SRS0=NzSx=OO=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	URIBL_RHS_DOB autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 70750C04EBF
	for <linux-media@archiver.kernel.org>; Wed,  5 Dec 2018 10:00:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 25C0920989
	for <linux-media@archiver.kernel.org>; Wed,  5 Dec 2018 10:00:34 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 25C0920989
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=csie.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-media-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729660AbeLEJuM (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 5 Dec 2018 04:50:12 -0500
Received: from mail-ed1-f65.google.com ([209.85.208.65]:36504 "EHLO
        mail-ed1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729617AbeLEJuM (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 5 Dec 2018 04:50:12 -0500
Received: by mail-ed1-f65.google.com with SMTP id f23so16475357edb.3;
        Wed, 05 Dec 2018 01:50:10 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=z/cbHVmOnR4ssoA0Bz+FRdDV0r+8venf015r/nDfnhU=;
        b=ENN6TNi74Mub0yMwoDMN5ILIcY7YNLDf1gQ4nDbIgkg64gSNVRbGsG7mOJJmmP4jJi
         1uiFN1skohwl+D1x3Q0pc1eAFCVwn8r9HKZFJlAsGuad0uYdjb1XETCNCx1RUQpFHG7B
         V05ZvBUv944up7ENhyopx7strGgBy2LCzPXlWeJjGUt3pZ6KUrLX4jZiE8ZdIP/A8hqL
         jDL9BvKJvpjO6NsudO7TX9MbvLeafqcI6CG+vjlXPw1KC88MgyIFFFMNelnwf3LAl//R
         TRwik1Q2Cf7qncb6AmWc+KDVA/671SBt929NTi44fjU0hF0hN2roytyHWmETbIQzNGUv
         ob3Q==
X-Gm-Message-State: AA+aEWZUQv6dXFtr3Bncbv1l89rV5Y+b20d1KDUoFJZ9LzF4QDyU+jsX
        lY6RjfyQZOnW9eq3D8YKdj/wEDeK/24=
X-Google-Smtp-Source: AFSGD/XwX9bg+xrOas/8A2jiafEZmA7SOjVQuZ+a9cX4xm4/wvnDMFCxLQz/92qhpBnAOU694vlYeQ==
X-Received: by 2002:aa7:c5d0:: with SMTP id h16mr20976757eds.107.1544003409743;
        Wed, 05 Dec 2018 01:50:09 -0800 (PST)
Received: from mail-wr1-f49.google.com (mail-wr1-f49.google.com. [209.85.221.49])
        by smtp.gmail.com with ESMTPSA id e26-v6sm3050901ejb.29.2018.12.05.01.50.09
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 05 Dec 2018 01:50:09 -0800 (PST)
Received: by mail-wr1-f49.google.com with SMTP id z5so18937579wrt.11;
        Wed, 05 Dec 2018 01:50:09 -0800 (PST)
X-Received: by 2002:a5d:4f10:: with SMTP id c16mr21994267wru.177.1544003408999;
 Wed, 05 Dec 2018 01:50:08 -0800 (PST)
MIME-Version: 1.0
References: <20181205092444.29497-1-paul.kocialkowski@bootlin.com>
 <20181205092444.29497-8-paul.kocialkowski@bootlin.com> <CAGb2v66JwZ_RkEdk6sz-0Z7EJx7ieG3zBT6yr-95X6guxUkKTg@mail.gmail.com>
 <edf44a24633ecaf59a7d5bea1f4acffdd0ae01a3.camel@bootlin.com>
In-Reply-To: <edf44a24633ecaf59a7d5bea1f4acffdd0ae01a3.camel@bootlin.com>
From:   Chen-Yu Tsai <wens@csie.org>
Date:   Wed, 5 Dec 2018 17:49:57 +0800
X-Gmail-Original-Message-ID: <CAGb2v67tgp_tD_Pkx1Qkc=d__saZUMwwmE44uCCeLgVM2HWmUQ@mail.gmail.com>
Message-ID: <CAGb2v67tgp_tD_Pkx1Qkc=d__saZUMwwmE44uCCeLgVM2HWmUQ@mail.gmail.com>
Subject: Re: [PATCH v2 07/15] arm64: dts: allwinner: h5: Add system-control
 node with SRAM C1
To:     Paul Kocialkowski <paul.kocialkowski@bootlin.com>
Cc:     Linux Media Mailing List <linux-media@vger.kernel.org>,
        devicetree <devicetree@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        devel@driverdev.osuosl.org,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Maxime Ripard <maxime.ripard@bootlin.com>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        linux-sunxi <linux-sunxi@googlegroups.com>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Sakari Ailus <sakari.ailus@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

On Wed, Dec 5, 2018 at 5:48 PM Paul Kocialkowski
<paul.kocialkowski@bootlin.com> wrote:
>
> Hi,
>
> On Wed, 2018-12-05 at 17:45 +0800, Chen-Yu Tsai wrote:
> > On Wed, Dec 5, 2018 at 5:25 PM Paul Kocialkowski
> > <paul.kocialkowski@bootlin.com> wrote:
> > > Add the H5-specific system control node description to its device-tree
> > > with support for the SRAM C1 section, that will be used by the video
> > > codec node later on.
> > >
> > > The CPU-side SRAM address was obtained empirically while the size was
> > > taken from the documentation. They may not be entirely accurate.
> > >
> > > Signed-off-by: Paul Kocialkowski <paul.kocialkowski@bootlin.com>
> > > ---
> > >  arch/arm64/boot/dts/allwinner/sun50i-h5.dtsi | 22 ++++++++++++++++++++
> > >  1 file changed, 22 insertions(+)
> > >
> > > diff --git a/arch/arm64/boot/dts/allwinner/sun50i-h5.dtsi b/arch/arm64/boot/dts/allwinner/sun50i-h5.dtsi
> > > index b41dc1aab67d..42bfb560b367 100644
> > > --- a/arch/arm64/boot/dts/allwinner/sun50i-h5.dtsi
> > > +++ b/arch/arm64/boot/dts/allwinner/sun50i-h5.dtsi
> > > @@ -94,6 +94,28 @@
> > >         };
> > >
> > >         soc {
> > > +               system-control@1c00000 {
> > > +                       compatible = "allwinner,sun50i-h5-system-control";
> > > +                       reg = <0x01c00000 0x1000>;
> > > +                       #address-cells = <1>;
> > > +                       #size-cells = <1>;
> > > +                       ranges;
> > > +
> > > +                       sram_c1: sram@1d00000 {
> > > +                               compatible = "mmio-sram";
> > > +                               reg = <0x00018000 0x1c000>;
> >
> > 0x1d00000 or 0x18000?
>
> For the H5, I found the VE SRAM area to be mapped to 0x18000 on the CPU
> side (when testing with devmem), unlike the A64, H3 and others. I was
> rather surprised about this as well!

I'm actually referring to the node name that still says 1d00000.

ChenYu

>
> > > +                               #address-cells = <1>;
> > > +                               #size-cells = <1>;
> > > +                               ranges = <0 0x00018000 0x1c000>;
> >
> > Same here.
> >
> > > +
> > > +                               ve_sram: sram-section@0 {
> > > +                                       compatible = "allwinner,sun50i-h5-sram-c1",
> > > +                                                    "allwinner,sun4i-a10-sram-c1";
> > > +                                       reg = <0x000000 0x1c000>;
> > > +                               };
> > > +                       };
> > > +               };
> > > +
> > >                 mali: gpu@1e80000 {
> > >                         compatible = "allwinner,sun50i-h5-mali", "arm,mali-450";
> > >                         reg = <0x01e80000 0x30000>;
> > > --
> > > 2.19.2
>
> Cheers,
>
> Paul
>
> --
> Paul Kocialkowski, Bootlin (formerly Free Electrons)
> Embedded Linux and kernel engineering
> https://bootlin.com
>
