Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:39859 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756035Ab2GaMIZ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 31 Jul 2012 08:08:25 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Magnus Damm <magnus.damm@gmail.com>,
	devicetree-discuss <devicetree-discuss@lists.ozlabs.org>
Subject: Re: [RFC] media DT bindings
Date: Tue, 31 Jul 2012 14:08:29 +0200
Message-ID: <2642313.6bQqiyFNFL@avalon>
In-Reply-To: <Pine.LNX.4.64.1207311058140.27888@axis700.grange>
References: <Pine.LNX.4.64.1207110854290.18999@axis700.grange> <1537713.eFPuk01afu@avalon> <Pine.LNX.4.64.1207311058140.27888@axis700.grange>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Guennadi,

On Tuesday 31 July 2012 11:26:27 Guennadi Liakhovetski wrote:
> On Fri, 27 Jul 2012, Laurent Pinchart wrote:
> > Hi Sylwester,
> > 
> > On Wednesday 18 July 2012 19:00:15 Sylwester Nawrocki wrote:
> > > On 07/16/2012 01:41 PM, Guennadi Liakhovetski wrote:
> [snip]
> 
> > > >>> An sh-mobile CEU DT node could look like
> > > >>> 
> > > >>> 	ceu0@0xfe910000 = {
> > > >>> 	
> > > >>> 		compatible = "renesas,sh-mobile-ceu";
> > > >>> 		reg =<0xfe910000 0xa0>;
> > > >>> 		interrupts =<0x880>;
> > > >>> 		bus-width =<16>;		/* #lines routed on the board */
> > > >>> 		clock-frequency =<50000000>;	/* max clock */
> > > >>> 		#address-cells =<1>;
> > > >>> 		#size-cells =<0>;
> > > >>> 		...
> > > >>> 		ov772x-1 = {
> > > >>> 		
> > > >>> 			reg =<0>;
> > > 
> > > This property might be redundant, we already have the "client" phandle
> > > pointing to "ov772x@0x21-0", which has all interesting properties inside
> > > it. Other than there is probably no reasonable usage for it under
> > > "ceu0@0xfe910000" node ?
> > > 
> > > >>> 			client =<&ov772x@0x21-0>;
> > > >>> 			local-pad = "parallel-sink";
> > > >>> 			remote-pad = "parallel-source";
> > > >> 
> > > >> I'm not sure I like that. Is it really needed when we already have
> > > >> the child/parent properties around ?
> > > > 
> > > > I think it is. Both the host and the client can have multiple pads
> > > > (e.g.,
> > > > parallel / serial). These properties specify which pads are used and
> > > > make
> > > > the translation between DT data and our subdev / pad APIs simpler.
> > > 
> > > OK, sorry, but isn't it all about just specifying what sort of data bus
> > > is used ? :-)
> > 
> > In some (many/most ?) cases probably, but not in all of them.
> > 
> > What about merging the client and remote-pad properties ? The resulting
> > property would then reference a pad with <&ov772x@0x21-0 0>.
> 
> What would the "0" parameter mean then? Pad #0?

Yes.

> But aren't these numbers device specific? Maybe not a huge deal, but these
> numbers are defind by the driver, right? Not the DT itself. So, drivers then
> will have to take care not to change their pad numbering. Whereas using
> strings, we can fix strings in the common V4L DT spec and keep them standard
> across devices and drivers. Then drivers might be less likely to change
> these assignments randomly ;-)

Userspace applications usually rely on pad numbers as well, so I consider them 
as more or less part of the ABI. If we really need to, we could add a DT pad 
number -> media controller pad number conversion in the driver, that would be 
less expensive than pad name -> pad number conversion (especially since it 
would be skipped in most cases).

> [snip]
> 
> > > I'd like just to point one detail here, as sensor subdev drivers control
> > > their voltage regulators and RESET/STANDBY (gpio) signals, they should
> > > also be able to control the master clock. In order to ensure proper
> > > power
> > > up/down sequences. It is a bad practice to enable clocks before voltage
> > > supplies are switched on and we shouldn't have that as a general
> > > assumption at the kernel frameworks.
> > > 
> > > One possible solution would be to have host/bridge drivers to register
> > > a clkdev entry for I2C client device, so it can acquire the clock
> > > through
> > > just clk_get(). We would have to ensure the clock is not tried to be
> > > accessed before it is registered by a bridge. This would require to add
> > > clock handling code to all sensor/encoder subdev drivers though..
> > 
> > I thik it's a good practice to add clock management to subdevs anyway, and
> > the common clock framework should make that easy (or at least not too
> > difficult). We can migrate subdevs one by one as we add DT support for
> > them.
> 
> Yes, this would be good.

-- 
Regards,

Laurent Pinchart

