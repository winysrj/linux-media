Return-path: <linux-media-owner@vger.kernel.org>
Received: from kirsty.vergenet.net ([202.4.237.240]:35282 "EHLO
	kirsty.vergenet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757115AbaGWIkm (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 23 Jul 2014 04:40:42 -0400
Date: Wed, 23 Jul 2014 17:40:38 +0900
From: Simon Horman <horms@verge.net.au>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Ben Dooks <ben.dooks@codethink.co.uk>, linux-media@vger.kernel.org,
	linux-sh@vger.kernel.org, magnus.damm@opensource.se,
	linux-kernel@lists.codethink.co.uk
Subject: Re: [PATCH 5/6] r8a7790.dtsi: add vin[0-3] nodes
Message-ID: <20140723084034.GA12177@verge.net.au>
References: <1404599185-12353-1-git-send-email-ben.dooks@codethink.co.uk>
 <1404599185-12353-6-git-send-email-ben.dooks@codethink.co.uk>
 <Pine.LNX.4.64.1407231007370.30243@axis700.grange>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.1407231007370.30243@axis700.grange>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Jul 23, 2014 at 10:09:46AM +0200, Guennadi Liakhovetski wrote:
> Hi Ben,
> 
> Who is going to take this patch? Simon? It can go in independently from 
> the V4L part, right? We just have to be sure, that bindings don't have to 
> change, and this is likely to be the case. Doesn't it have to be Cc'ed to 
> DT maintainers and the list?

Hi Guennadi,

my expectation is that I will take this and patch once the bindings have
been accepted by the subsystem maintainer.

For the board DT change my expectation is as above plus that
someone has independently tested that the device is initialised
and usable (for some definition of usable).

With regards to CCing DT maintainers, I believe that they like to be CCed
on driver changes that add or update bindings. I'm unsure if they also like
to be CCed on DT file changes. Its not something I've blocked on in the
past with regards to DT file changes.

> Thanks
> Guennadi
> 
> On Sat, 5 Jul 2014, Ben Dooks wrote:
> 
> > Add nodes for the four video input channels on the R8A7790.
> > 
> > Signed-off-by: Ben Dooks <ben.dooks@codethink.co.uk>
> > ---
> >  arch/arm/boot/dts/r8a7790.dtsi | 36 ++++++++++++++++++++++++++++++++++++
> >  1 file changed, 36 insertions(+)
> > 
> > diff --git a/arch/arm/boot/dts/r8a7790.dtsi b/arch/arm/boot/dts/r8a7790.dtsi
> > index 7ff2960..a6f083d 100644
> > --- a/arch/arm/boot/dts/r8a7790.dtsi
> > +++ b/arch/arm/boot/dts/r8a7790.dtsi
> > @@ -33,6 +33,10 @@
> >  		spi2 = &msiof1;
> >  		spi3 = &msiof2;
> >  		spi4 = &msiof3;
> > +		vin0 = &vin0;
> > +		vin1 = &vin1;
> > +		vin2 = &vin2;
> > +		vin3 = &vin3;
> >  	};
> >  
> >  	cpus {
> > @@ -462,6 +466,38 @@
> >  		status = "disabled";
> >  	};
> >  
> > +	vin0: vin@e6ef0000 {
> > +		compatible = "renesas,vin-r8a7790";
> > +		clocks = <&mstp8_clks R8A7790_CLK_VIN0>;
> > +		reg = <0 0xe6ef0000 0 0x1000>;
> > +		interrupts = <0 188 IRQ_TYPE_LEVEL_HIGH>;
> > +		status = "disabled";
> > +	};
> > +
> > +	vin1: vin@e6ef1000 {
> > +		compatible = "renesas,vin-r8a7790";
> > +		clocks = <&mstp8_clks R8A7790_CLK_VIN1>;
> > +		reg = <0 0xe6ef1000 0 0x1000>;
> > +		interrupts = <0 189 IRQ_TYPE_LEVEL_HIGH>;
> > +		status = "disabled";
> > +	};
> > +
> > +	vin2: vin@e6ef2000 {
> > +		compatible = "renesas,vin-r8a7790";
> > +		clocks = <&mstp8_clks R8A7790_CLK_VIN2>;
> > +		reg = <0 0xe6ef2000 0 0x1000>;
> > +		interrupts = <0 190 IRQ_TYPE_LEVEL_HIGH>;
> > +		status = "disabled";
> > +	};
> > +
> > +	vin3: vin@e6ef3000 {
> > +		compatible = "renesas,vin-r8a7790";
> > +		clocks = <&mstp8_clks R8A7790_CLK_VIN3>;
> > +		reg = <0 0xe6ef3000 0 0x1000>;
> > +		interrupts = <0 191 IRQ_TYPE_LEVEL_HIGH>;
> > +		status = "disabled";
> > +	};
> > +
> >  	clocks {
> >  		#address-cells = <2>;
> >  		#size-cells = <2>;
> > -- 
> > 2.0.0
> > 
> 
