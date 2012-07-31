Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.186]:61578 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752827Ab2GaJ0e (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 31 Jul 2012 05:26:34 -0400
Date: Tue, 31 Jul 2012 11:26:27 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
cc: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Magnus Damm <magnus.damm@gmail.com>,
	devicetree-discuss <devicetree-discuss@lists.ozlabs.org>
Subject: Re: [RFC] media DT bindings
In-Reply-To: <1537713.eFPuk01afu@avalon>
Message-ID: <Pine.LNX.4.64.1207311058140.27888@axis700.grange>
References: <Pine.LNX.4.64.1207110854290.18999@axis700.grange>
 <Pine.LNX.4.64.1207161257590.18978@axis700.grange> <5006EB9F.5010408@gmail.com>
 <1537713.eFPuk01afu@avalon>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, 27 Jul 2012, Laurent Pinchart wrote:

> Hi Sylwester,
> 
> On Wednesday 18 July 2012 19:00:15 Sylwester Nawrocki wrote:
> > On 07/16/2012 01:41 PM, Guennadi Liakhovetski wrote:

[snip]

> > >>> An sh-mobile CEU DT node could look like
> > >>> 
> > >>> 	ceu0@0xfe910000 = {
> > >>> 	
> > >>> 		compatible = "renesas,sh-mobile-ceu";
> > >>> 		reg =<0xfe910000 0xa0>;
> > >>> 		interrupts =<0x880>;
> > >>> 		bus-width =<16>;		/* #lines routed on the board */
> > >>> 		clock-frequency =<50000000>;	/* max clock */
> > >>> 		#address-cells =<1>;
> > >>> 		#size-cells =<0>;
> > >>> 		...
> > >>> 		ov772x-1 = {
> > >>> 		
> > >>> 			reg =<0>;
> > 
> > This property might be redundant, we already have the "client" phandle
> > pointing to "ov772x@0x21-0", which has all interesting properties inside
> > it. Other than there is probably no reasonable usage for it under
> > "ceu0@0xfe910000" node ?
> > 
> > >>> 			client =<&ov772x@0x21-0>;
> > >>> 			local-pad = "parallel-sink";
> > >>> 			remote-pad = "parallel-source";
> > >> 
> > >> I'm not sure I like that. Is it really needed when we already have
> > >> the child/parent properties around ?
> > > 
> > > I think it is. Both the host and the client can have multiple pads (e.g.,
> > > parallel / serial). These properties specify which pads are used and make
> > > the translation between DT data and our subdev / pad APIs simpler.
> > 
> > OK, sorry, but isn't it all about just specifying what sort of data bus
> > is used ? :-)
> 
> In some (many/most ?) cases probably, but not in all of them.
> 
> What about merging the client and remote-pad properties ? The resulting 
> property would then reference a pad with <&ov772x@0x21-0 0>.

What would the "0" parameter mean then? Pad #0? But aren't these numbers 
device specific? Maybe not a huge deal, but these numbers are defind by 
the driver, right? Not the DT itself. So, drivers then will have to take 
care not to change their pad numbering. Whereas using strings, we can fix 
strings in the common V4L DT spec and keep them standard across devices 
and drivers. Then drivers might be less likely to change these assignments 
randomly;-)

[snip]

> > I'd like just to point one detail here, as sensor subdev drivers control
> > their voltage regulators and RESET/STANDBY (gpio) signals, they should
> > also be able to control the master clock. In order to ensure proper power
> > up/down sequences. It is a bad practice to enable clocks before voltage
> > supplies are switched on and we shouldn't have that as a general
> > assumption at the kernel frameworks.
> > 
> > One possible solution would be to have host/bridge drivers to register
> > a clkdev entry for I2C client device, so it can acquire the clock through
> > just clk_get(). We would have to ensure the clock is not tried to be
> > accessed before it is registered by a bridge. This would require to add
> > clock handling code to all sensor/encoder subdev drivers though..
> 
> I thik it's a good practice to add clock management to subdevs anyway, and the 
> common clock framework should make that easy (or at least not too difficult). 
> We can migrate subdevs one by one as we add DT support for them.

Yes, this would be good.

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
