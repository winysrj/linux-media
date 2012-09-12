Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.17.9]:64519 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750737Ab2ILT2l (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 12 Sep 2012 15:28:41 -0400
Date: Wed, 12 Sep 2012 21:28:34 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Stephen Warren <swarren@wwwdotorg.org>
cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Magnus Damm <magnus.damm@gmail.com>,
	devicetree-discuss <devicetree-discuss@lists.ozlabs.org>,
	linux-sh@vger.kernel.org,
	Mark Brown <broonie@opensource.wolfsonmicro.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Arnd Bergmann <arnd@arndb.de>,
	linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] media: add V4L2 DT binding documentation
In-Reply-To: <5050DA40.8050105@wwwdotorg.org>
Message-ID: <Pine.LNX.4.64.1209122111100.28968@axis700.grange>
References: <Pine.LNX.4.64.1209111746420.22084@axis700.grange>
 <5050DA40.8050105@wwwdotorg.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Stephen

On Wed, 12 Sep 2012, Stephen Warren wrote:

> On 09/11/2012 09:51 AM, Guennadi Liakhovetski wrote:
> > This patch adds a document, describing common V4L2 device tree bindings.
> > 
> > Co-authored-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
> > Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
> 
> Overall, I think this looks pretty reasonable, so:

Good, thanks!

> Acked-by: Stephen Warren <swarren@wwwdotorg.org>
> 
> Just a couple comments:
> 
> > +++ b/Documentation/devicetree/bindings/media/v4l2.txt
> 
> > +	ceu0: ceu@0xfe910000 {
> 
> > +		mclk: master_clock {
> > +			compatible = "renesas,ceu-clock";
> > +			#clock-cells = <1>;
> 
> Why 1? If there's only 1 clock output from this provider, I don't see a
> need for any cells, unless there are some configuration flags?

Yes, indeed, that's also what's suggested in the clock bindings 
documentation, thanks for pointing out.

> 
> > +			clock-frequency = <50000000>;	/* max clock frequency */
> > +			clock-output-names = "mclk";
> > +		};
> > +
> > +		port {
> ...
> > +			ceu0_0: link@0 {
> > +				reg = <0>;
> > +				remote = <&csi2_2>;
> > +				immutable;
> 
> Did we decide "immutable" was actually needed? Presumably the driver for
> the HW in question knows the HW isn't configurable, and would simply not
> attempt to apply any configuration even if the .dts author erroneously
> provided some?

Well, I've been thinking about this today. I think, bridge drivers will 
call centrally provided helper functions to enumerate links inside ports. 
While doing that they will want to differentiate between links to external 
devices with explicit configuration, and links to internal devices, whose 
configuration drivers might be able to figure out themselves. How should a 
driver find out what device this link is pointing to? Should it follow the 
"remote" phandle and then check the "compatible" property? The word 
"immutable" is a hint, that this is a link to an internal device, but it 
might either be unneeded or be transformed into something more 
informative.

> > +			};
> > +		};
> > +	};
> > +
> > +	i2c0: i2c@0xfff20000 {
> ...
> > +		ov772x_1: camera@0x21 {
> ...
> > +			clocks = <&mclk 0>;
> 
> So presumably that could just be "clocks = <&mclk>;"?

Right.

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
