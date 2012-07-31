Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:44840 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755746Ab2GaLFQ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 31 Jul 2012 07:05:16 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	linux-media@vger.kernel.org, kyungmin.park@samsung.com,
	m.szyprowski@samsung.com, riverful.kim@samsung.com,
	sw0312.kim@samsung.com, devicetree-discuss@lists.ozlabs.org,
	linux-samsung-soc@vger.kernel.org, b.zolnierkie@samsung.com
Subject: Re: [RFC/PATCH 02/13] media: s5p-csis: Add device tree support
Date: Tue, 31 Jul 2012 13:05:23 +0200
Message-ID: <4835930.8zRiqxUPR0@avalon>
In-Reply-To: <Pine.LNX.4.64.1207311257020.27888@axis700.grange>
References: <4FBFE1EC.9060209@samsung.com> <24452426.AaRH9zzLOy@avalon> <Pine.LNX.4.64.1207311257020.27888@axis700.grange>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Guennadi,

On Tuesday 31 July 2012 12:58:50 Guennadi Liakhovetski wrote:
> On Fri, 27 Jul 2012, Laurent Pinchart wrote:
> > On Thursday 26 July 2012 21:51:30 Sylwester Nawrocki wrote:
> > > On 07/26/2012 04:38 PM, Laurent Pinchart wrote:
> > > >>>> --- /dev/null
> > > >>>> +++ b/Documentation/devicetree/bindings/video/mipi.txt
> > > >>>> @@ -0,0 +1,5 @@
> > > >>>> +Common properties of MIPI-CSI1 and MIPI-CSI2 receivers and
> > > >>>> transmitters
> > > >>>> +
> > > >>>> + - data-lanes : number of differential data lanes wired and
> > > >>>> actively
> > > >>>> used in
> > > >>>> +		communication between the transmitter and the receiver, this
> > > >>>> +		excludes the clock lane;
> > > >>> 
> > > >>> Wouldn't it be better to use the standard "bus-width" DT property?
> > > >> 
> > > >> I can't see any problems with using "bus-width". It seems sufficient
> > > >> and could indeed be better, without a need to invent new MIPI-CSI
> > > >> specific names. That was my first RFC on that and my perspective
> > > >> wasn't probably broad enough. :)
> > > > 
> > > > What about CSI receivers that can reroute the lanes internally ? We
> > > > would
> > > > need to specify lane indices for each lane then, maybe with something
> > > > like
> > > > 
> > > > clock-lane =<0>;
> > > > data-lanes =<2 3 1>;
> > > 
> > > Sounds good to me. And the clock-lane could be made optional, as not all
> > > devices would need it.
> > > 
> > > However, as far as I can see, there is currently no generic API for
> > > handling this kind of data structure. E.g. number of cells for the
> > > "interrupts" property is specified with an additional
> > > "#interrupt-cells" property.
> > > 
> > > It would have been much easier to handle something like:
> > > 
> > > data-lanes = <2>, <3>, <1>;
> > > 
> > > i.e. an array of the lane indexes.
> > 
> > I'm fine with that.
> 
> ...on a second thought: shouldn't this be handled by pinctrl? Or is it
> some CSI-2 module internal lane switching, not the global SoC pin function
> configuration?

On the hardware I came across, it's handled by the CSI2 receiver, not the SoC 
pinmux feature.

-- 
Regards,

Laurent Pinchart

