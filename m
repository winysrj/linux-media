Return-Path: <SRS0=NzSx=OO=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	URIBL_RHS_DOB autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 399F0C04EBF
	for <linux-media@archiver.kernel.org>; Wed,  5 Dec 2018 09:54:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 04C9A213A2
	for <linux-media@archiver.kernel.org>; Wed,  5 Dec 2018 09:54:15 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 04C9A213A2
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=bootlin.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-media-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729907AbeLEJyN (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 5 Dec 2018 04:54:13 -0500
Received: from mail.bootlin.com ([62.4.15.54]:43177 "EHLO mail.bootlin.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730086AbeLEJyK (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 5 Dec 2018 04:54:10 -0500
Received: by mail.bootlin.com (Postfix, from userid 110)
        id D2CB320A63; Wed,  5 Dec 2018 10:54:07 +0100 (CET)
Received: from aptenodytes (aaubervilliers-681-1-79-44.w90-88.abo.wanadoo.fr [90.88.21.44])
        by mail.bootlin.com (Postfix) with ESMTPSA id 7CA2D20726;
        Wed,  5 Dec 2018 10:53:57 +0100 (CET)
Message-ID: <f2fd100fd4f0fa66f437b6b3cc80ed3f7da6ba3a.camel@bootlin.com>
Subject: Re: [PATCH v2 07/15] arm64: dts: allwinner: h5: Add system-control
 node with SRAM C1
From:   Paul Kocialkowski <paul.kocialkowski@bootlin.com>
To:     Chen-Yu Tsai <wens@csie.org>
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
Date:   Wed, 05 Dec 2018 10:53:57 +0100
In-Reply-To: <CAGb2v67tgp_tD_Pkx1Qkc=d__saZUMwwmE44uCCeLgVM2HWmUQ@mail.gmail.com>
References: <20181205092444.29497-1-paul.kocialkowski@bootlin.com>
         <20181205092444.29497-8-paul.kocialkowski@bootlin.com>
         <CAGb2v66JwZ_RkEdk6sz-0Z7EJx7ieG3zBT6yr-95X6guxUkKTg@mail.gmail.com>
         <edf44a24633ecaf59a7d5bea1f4acffdd0ae01a3.camel@bootlin.com>
         <CAGb2v67tgp_tD_Pkx1Qkc=d__saZUMwwmE44uCCeLgVM2HWmUQ@mail.gmail.com>
Organization: Bootlin
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.30.2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hi,

On Wed, 2018-12-05 at 17:49 +0800, Chen-Yu Tsai wrote:
> On Wed, Dec 5, 2018 at 5:48 PM Paul Kocialkowski
> <paul.kocialkowski@bootlin.com> wrote:
> > Hi,
> > 
> > On Wed, 2018-12-05 at 17:45 +0800, Chen-Yu Tsai wrote:
> > > On Wed, Dec 5, 2018 at 5:25 PM Paul Kocialkowski
> > > <paul.kocialkowski@bootlin.com> wrote:
> > > > Add the H5-specific system control node description to its device-tree
> > > > with support for the SRAM C1 section, that will be used by the video
> > > > codec node later on.
> > > > 
> > > > The CPU-side SRAM address was obtained empirically while the size was
> > > > taken from the documentation. They may not be entirely accurate.
> > > > 
> > > > Signed-off-by: Paul Kocialkowski <paul.kocialkowski@bootlin.com>
> > > > ---
> > > >  arch/arm64/boot/dts/allwinner/sun50i-h5.dtsi | 22 ++++++++++++++++++++
> > > >  1 file changed, 22 insertions(+)
> > > > 
> > > > diff --git a/arch/arm64/boot/dts/allwinner/sun50i-h5.dtsi b/arch/arm64/boot/dts/allwinner/sun50i-h5.dtsi
> > > > index b41dc1aab67d..42bfb560b367 100644
> > > > --- a/arch/arm64/boot/dts/allwinner/sun50i-h5.dtsi
> > > > +++ b/arch/arm64/boot/dts/allwinner/sun50i-h5.dtsi
> > > > @@ -94,6 +94,28 @@
> > > >         };
> > > > 
> > > >         soc {
> > > > +               system-control@1c00000 {
> > > > +                       compatible = "allwinner,sun50i-h5-system-control";
> > > > +                       reg = <0x01c00000 0x1000>;
> > > > +                       #address-cells = <1>;
> > > > +                       #size-cells = <1>;
> > > > +                       ranges;
> > > > +
> > > > +                       sram_c1: sram@1d00000 {
> > > > +                               compatible = "mmio-sram";
> > > > +                               reg = <0x00018000 0x1c000>;
> > > 
> > > 0x1d00000 or 0x18000?
> > 
> > For the H5, I found the VE SRAM area to be mapped to 0x18000 on the CPU
> > side (when testing with devmem), unlike the A64, H3 and others. I was
> > rather surprised about this as well!
> 
> I'm actually referring to the node name that still says 1d00000.

Oh I totally missed that, sorry. Thanks for pointing it out!

Cheers,

Paul

> ChenYu
> 
> > > > +                               #address-cells = <1>;
> > > > +                               #size-cells = <1>;
> > > > +                               ranges = <0 0x00018000 0x1c000>;
> > > 
> > > Same here.
> > > 
> > > > +
> > > > +                               ve_sram: sram-section@0 {
> > > > +                                       compatible = "allwinner,sun50i-h5-sram-c1",
> > > > +                                                    "allwinner,sun4i-a10-sram-c1";
> > > > +                                       reg = <0x000000 0x1c000>;
> > > > +                               };
> > > > +                       };
> > > > +               };
> > > > +
> > > >                 mali: gpu@1e80000 {
> > > >                         compatible = "allwinner,sun50i-h5-mali", "arm,mali-450";
> > > >                         reg = <0x01e80000 0x30000>;
> > > > --
> > > > 2.19.2
> > 
> > Cheers,
> > 
> > Paul
> > 
> > --
> > Paul Kocialkowski, Bootlin (formerly Free Electrons)
> > Embedded Linux and kernel engineering
> > https://bootlin.com
> > 
-- 
Paul Kocialkowski, Bootlin (formerly Free Electrons)
Embedded Linux and kernel engineering
https://bootlin.com

