Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.186]:55838 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755448Ab2GaK6w (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 31 Jul 2012 06:58:52 -0400
Date: Tue, 31 Jul 2012 12:58:50 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
cc: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	linux-media@vger.kernel.org, kyungmin.park@samsung.com,
	m.szyprowski@samsung.com, riverful.kim@samsung.com,
	sw0312.kim@samsung.com, devicetree-discuss@lists.ozlabs.org,
	linux-samsung-soc@vger.kernel.org, b.zolnierkie@samsung.com
Subject: Re: [RFC/PATCH 02/13] media: s5p-csis: Add device tree support
In-Reply-To: <24452426.AaRH9zzLOy@avalon>
Message-ID: <Pine.LNX.4.64.1207311257020.27888@axis700.grange>
References: <4FBFE1EC.9060209@samsung.com> <24426306.kyhKLGOJzl@avalon>
 <50119FC2.7090908@gmail.com> <24452426.AaRH9zzLOy@avalon>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, 27 Jul 2012, Laurent Pinchart wrote:

> Hi Sylwester,
> 
> On Thursday 26 July 2012 21:51:30 Sylwester Nawrocki wrote:
> > On 07/26/2012 04:38 PM, Laurent Pinchart wrote:
> > >>>> --- /dev/null
> > >>>> +++ b/Documentation/devicetree/bindings/video/mipi.txt
> > >>>> @@ -0,0 +1,5 @@
> > >>>> +Common properties of MIPI-CSI1 and MIPI-CSI2 receivers and
> > >>>> transmitters
> > >>>> +
> > >>>> + - data-lanes : number of differential data lanes wired and actively
> > >>>> used in
> > >>>> +		communication between the transmitter and the receiver, this
> > >>>> +		excludes the clock lane;
> > >>> 
> > >>> Wouldn't it be better to use the standard "bus-width" DT property?
> > >> 
> > >> I can't see any problems with using "bus-width". It seems sufficient
> > >> and could indeed be better, without a need to invent new MIPI-CSI
> > >> specific names. That was my first RFC on that and my perspective
> > >> wasn't probably broad enough. :)
> > > 
> > > What about CSI receivers that can reroute the lanes internally ? We would
> > > need to specify lane indices for each lane then, maybe with something
> > > like
> > > 
> > > clock-lane =<0>;
> > > data-lanes =<2 3 1>;
> > 
> > Sounds good to me. And the clock-lane could be made optional, as not all
> > devices would need it.
> > 
> > However, as far as I can see, there is currently no generic API for handling
> > this kind of data structure. E.g. number of cells for the "interrupts"
> > property is specified with an additional "#interrupt-cells" property.
> > 
> > It would have been much easier to handle something like:
> > 
> > data-lanes = <2>, <3>, <1>;
> > 
> > i.e. an array of the lane indexes.
> 
> I'm fine with that.

...on a second thought: shouldn't this be handled by pinctrl? Or is it 
some CSI-2 module internal lane switching, not the global SoC pin function 
configuration?

Thanks
Guennadi

> > > For receivers that can't reroute lanes internally, the data-lanes property
> > > would be need to specify lanes in sequence.
> > > 
> > > data-lanes =<1 2 3>;
> > 
> > In this case we would be only interested in the number of cells in this
> > property, but how it could be retrieved ? With an array, it could have been
> > calculated from property length returned by of_property_find() (divided by
> > sizof(u32)).
> 
> Agreed.
> 
> -- 
> Regards,
> 
> Laurent Pinchart
> 

---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
