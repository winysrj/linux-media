Return-path: <linux-media-owner@vger.kernel.org>
Received: from kirsty.vergenet.net ([202.4.237.240]:39254 "EHLO
        kirsty.vergenet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752419AbeDZIxF (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 26 Apr 2018 04:53:05 -0400
Date: Thu, 26 Apr 2018 10:53:00 +0200
From: Simon Horman <horms@verge.net.au>
To: jacopo mondi <jacopo@jmondi.org>
Cc: Jacopo Mondi <jacopo+renesas@jmondi.org>, geert@linux-m68k.org,
        robh+dt@kernel.org, mark.rutland@arm.com,
        linux-renesas-soc@vger.kernel.org, linux-media@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] ARM: dts: r8a7740: Enable CEU0
Message-ID: <20180426085259.lqxr4emk75oz7vug@verge.net.au>
References: <1524654920-18749-1-git-send-email-jacopo+renesas@jmondi.org>
 <1524654920-18749-3-git-send-email-jacopo+renesas@jmondi.org>
 <20180426061124.hvgl3ijf6ulrdkmn@verge.net.au>
 <20180426072609.GH17088@w540>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180426072609.GH17088@w540>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Apr 26, 2018 at 09:26:09AM +0200, jacopo mondi wrote:
> Hi Simon,
> 
> On Thu, Apr 26, 2018 at 08:11:30AM +0200, Simon Horman wrote:
> > Thanks Jacopo,
> >
> > I'm very pleased to see this series.
> 
> Credits to Geert that pointed out to me R-Mobile A1 comes with a CEU.
> I should mention him in next iteration actually, sorry about that.
> 
> >
> > On Wed, Apr 25, 2018 at 01:15:20PM +0200, Jacopo Mondi wrote:
> > > Enable CEU0 peripheral for Renesas R-Mobile A1 R8A7740.
> >
> > Given 'status = "disabled"' below I think you
> > are describing but not enabling CEU0. Also in the subject.
> 
> Right.
> 
> >
> > Should we also describe CEU1?
> 
> Armadillo board file only describe CEU0. If there are R-Mobile A1
> board files where I can steal informations from I can do that. If
> there's a public datasheet, that would be even better.

I have the datasheet, so perhaps I can add CEU1 after you have added CEU0.

> > > Signed-off-by: Jacopo Mondi <jacopo+renesas@jmondi.org>
> > > ---
> > >  arch/arm/boot/dts/r8a7740.dtsi | 10 ++++++++++
> > >  1 file changed, 10 insertions(+)
> > >
> > > diff --git a/arch/arm/boot/dts/r8a7740.dtsi b/arch/arm/boot/dts/r8a7740.dtsi
> > > index afd3bc5..05ec41e 100644
> > > --- a/arch/arm/boot/dts/r8a7740.dtsi
> > > +++ b/arch/arm/boot/dts/r8a7740.dtsi
> > > @@ -67,6 +67,16 @@
> > >  		power-domains = <&pd_d4>;
> > >  	};
> > >
> > > +	ceu0: ceu@fe910000 {
> > > +		reg = <0xfe910000 0x100>;
> >
> > Should the size of the range be 0x3000 ?
> > That would seem to match my reading of table 32.3
> > and also be consistent with r7s72100.dtsi.
> 
> I got this from
> 
> static struct resource ceu0_resources[] = {
> 	[0] = {
> 		.name	= "CEU",
> 		.start	= 0xfe910000,
> 		.end	= 0xfe91009f,
> 		.flags	= IORESOURCE_MEM,
> 	},
> but I also noticed the r7s72100 one was bigger.
> I'm fine enlarging this, if that's what the manual reports too.

I think that would be best.

> > > +		compatible = "renesas,r8a7740-ceu";
> > > +		interrupts = <GIC_SPI 160 IRQ_TYPE_LEVEL_HIGH>;
> > > +		clocks = <&mstp1_clks R8A7740_CLK_CEU20>;
> > > +		clock-names = "ceu20";
> > > +		power-domains = <&pd_a4mp>;
> >
> > My reading of table 1.7 is that the power domain should be A4R (&pd_a4r).
> 
> Ah yes, my bad.
> 
> The long time goal would be describe the camera module (mt9t112) which
> is installed on armadillo. Unfortunately that would probably require
> some more work on the CEU side.

Thanks, understood.
