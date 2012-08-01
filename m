Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:46363 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754239Ab2HAHS6 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 1 Aug 2012 03:18:58 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Magnus Damm <magnus.damm@gmail.com>,
	devicetree-discuss <devicetree-discuss@lists.ozlabs.org>
Subject: Re: [RFC] media DT bindings
Date: Wed, 01 Aug 2012 09:19:04 +0200
Message-ID: <4037827.9ZKAOTeRMD@avalon>
In-Reply-To: <Pine.LNX.4.64.1208010828030.5406@axis700.grange>
References: <Pine.LNX.4.64.1207110854290.18999@axis700.grange> <1853410.hC8HZhzZI6@avalon> <Pine.LNX.4.64.1208010828030.5406@axis700.grange>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Guennadi,

On Wednesday 01 August 2012 08:47:20 Guennadi Liakhovetski wrote:
> On Tue, 31 Jul 2012, Laurent Pinchart wrote:
> > On Tuesday 31 July 2012 14:39:07 Guennadi Liakhovetski wrote:
> > > On Tue, 31 Jul 2012, Laurent Pinchart wrote:
> > > > On Tuesday 31 July 2012 11:26:27 Guennadi Liakhovetski wrote:
> > > > > On Fri, 27 Jul 2012, Laurent Pinchart wrote:
> > > > > > On Wednesday 18 July 2012 19:00:15 Sylwester Nawrocki wrote:
> > > > > > > On 07/16/2012 01:41 PM, Guennadi Liakhovetski wrote:
> > > > > [snip]
> > > > > 
> > > > > > > >>> An sh-mobile CEU DT node could look like
> > > > > > > >>> 
> > > > > > > >>> 	ceu0@0xfe910000 = {
> > > > > > > >>> 	
> > > > > > > >>> 		compatible = "renesas,sh-mobile-ceu";
> > > > > > > >>> 		reg =<0xfe910000 0xa0>;
> > > > > > > >>> 		interrupts =<0x880>;
> > > > > > > >>> 		bus-width =<16>;		/* #lines routed on the board */
> > > > > > > >>> 		clock-frequency =<50000000>;	/* max clock */
> > > > > > > >>> 		#address-cells =<1>;
> > > > > > > >>> 		#size-cells =<0>;
> > > > > > > >>> 		...
> > > > > > > >>> 		ov772x-1 = {
> > > > > > > >>> 		
> > > > > > > >>> 			reg =<0>;
> > > > > > > 
> > > > > > > This property might be redundant, we already have the "client"
> > > > > > > phandle pointing to "ov772x@0x21-0", which has all interesting
> > > > > > > properties inside it. Other than there is probably no reasonable
> > > > > > > usage for it under "ceu0@0xfe910000" node ?
> > > > > > > 
> > > > > > > >>> 			client =<&ov772x@0x21-0>;
> > > > > > > >>> 			local-pad = "parallel-sink";
> > > > > > > >>> 			remote-pad = "parallel-source";
> > > > > > > >> 
> > > > > > > >> I'm not sure I like that. Is it really needed when we already
> > > > > > > >> have the child/parent properties around ?
> > > > > > > > 
> > > > > > > > I think it is. Both the host and the client can have multiple
> > > > > > > > pads (e.g., parallel / serial). These properties specify which
> > > > > > > > pads are used and make the translation between DT data and our
> > > > > > > > subdev / pad APIs simpler.
> > > > > > > 
> > > > > > > OK, sorry, but isn't it all about just specifying what sort of
> > > > > > > data bus is used ? :-)
> > > > > > 
> > > > > > In some (many/most ?) cases probably, but not in all of them.
> > > > > > 
> > > > > > What about merging the client and remote-pad properties ? The
> > > > > > resulting property would then reference a pad with <&ov772x@0x21-0
> > > > > > 0>.
> > > > > 
> > > > > What would the "0" parameter mean then? Pad #0?
> > > > 
> > > > Yes.
> > > > 
> > > > > But aren't these numbers device specific? Maybe not a huge deal, but
> > > > > these numbers are defind by the driver, right? Not the DT itself.
> > > > > So, drivers then will have to take care not to change their pad
> > > > > numbering. Whereas using strings, we can fix strings in the common
> > > > > V4L DT spec and keep them standard across devices and drivers. Then
> > > > > drivers might be less likely to change these assignments randomly
> > > > > ;-)
> > > > 
> > > > Userspace applications usually rely on pad numbers as well, so I
> > > > consider them as more or less part of the ABI. If we really need to,
> > > > we could add a DT pad number -> media controller pad number conversion
> > > > in the driver, that would be less expensive than pad name -> pad
> > > > number conversion (especially since it would be skipped in most
> > > > cases).
> > > 
> > > Ok, then, how about
> > > 
> > > 		#address-cells = <1>;
> > > 		#size-cells = <0>;
> > > 		...
> > > 		ov772x-1 = {
> > > 		
> > > 			reg = <1>;			/* local pad # */
> > > 			client = <&ov772x@0x21-0 0>;	/* remote phandle and pad */
> > 
> > The client property looks good, but isn't such a usage of the reg property
> > an abuse ?
> 
> Don't know, is it?
> 
> > Maybe the local pad # should be a device-specific property. Many hosts
> > won't need it, and on others it would actually need to reference a subdev,
> > not just a pad.
> 
> Wait, the correspondence cannot be one pad to many subdevs, right?
> So, we always can assign at least 1 pad to each subdev. Hm, or you mean
> subdevs like flash, that don't access data, in which case they don't need
> pads? but then we also don't need links to them. Those child nodes are
> links, and links always run between 2 pads, right? So, in the above
> representation child devices are pads of the parent node, to which other
> entities are linked.
> 
> But while writing this, another question occurred to me: what if several
> entities are connected to one pad (activated selectively by a switch)? We
> cannot have several child nodes with the same address. But in such a case
> we could use
> 
> 	#address-cells = <2>;
> 	...
> 	subdev1 = {
> 		reg = <1 1>; /* first client on pad 1 */
> 	};
> 
> 	subdev2 = {
> 		reg = <1 2>; /* second client on pad 1 */
> 	};
> 
> But I'm not particularly attached to this idea. If we decide, that it's an
> abuse, we can switch back to some property.

I think that would be an abuse :-)

My point was that a host represented by a single DT node might contain several 
media entities. For instance the OMAP3 ISP contains two CSI2 receivers. Each 
of them has a single sink pad, both numbered 0. The DT link representation 
thus needs to mention which sink entity the sensor is connected to, in 
addition to the pad number in that entity (and in the OMAP3 ISP case the pad 
number could be omitted completely, as the CSI2 receivers have a single sink 
pad).

-- 
Regards,

Laurent Pinchart

