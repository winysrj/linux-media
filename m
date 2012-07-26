Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:57109 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752311Ab2GZWfz (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 26 Jul 2012 18:35:55 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	linux-media@vger.kernel.org, kyungmin.park@samsung.com,
	m.szyprowski@samsung.com, riverful.kim@samsung.com,
	sw0312.kim@samsung.com, devicetree-discuss@lists.ozlabs.org,
	linux-samsung-soc@vger.kernel.org, b.zolnierkie@samsung.com
Subject: Re: [RFC/PATCH 02/13] media: s5p-csis: Add device tree support
Date: Fri, 27 Jul 2012 00:35:59 +0200
Message-ID: <24452426.AaRH9zzLOy@avalon>
In-Reply-To: <50119FC2.7090908@gmail.com>
References: <4FBFE1EC.9060209@samsung.com> <24426306.kyhKLGOJzl@avalon> <50119FC2.7090908@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sylwester,

On Thursday 26 July 2012 21:51:30 Sylwester Nawrocki wrote:
> On 07/26/2012 04:38 PM, Laurent Pinchart wrote:
> >>>> --- /dev/null
> >>>> +++ b/Documentation/devicetree/bindings/video/mipi.txt
> >>>> @@ -0,0 +1,5 @@
> >>>> +Common properties of MIPI-CSI1 and MIPI-CSI2 receivers and
> >>>> transmitters
> >>>> +
> >>>> + - data-lanes : number of differential data lanes wired and actively
> >>>> used in
> >>>> +		communication between the transmitter and the receiver, this
> >>>> +		excludes the clock lane;
> >>> 
> >>> Wouldn't it be better to use the standard "bus-width" DT property?
> >> 
> >> I can't see any problems with using "bus-width". It seems sufficient
> >> and could indeed be better, without a need to invent new MIPI-CSI
> >> specific names. That was my first RFC on that and my perspective
> >> wasn't probably broad enough. :)
> > 
> > What about CSI receivers that can reroute the lanes internally ? We would
> > need to specify lane indices for each lane then, maybe with something
> > like
> > 
> > clock-lane =<0>;
> > data-lanes =<2 3 1>;
> 
> Sounds good to me. And the clock-lane could be made optional, as not all
> devices would need it.
> 
> However, as far as I can see, there is currently no generic API for handling
> this kind of data structure. E.g. number of cells for the "interrupts"
> property is specified with an additional "#interrupt-cells" property.
> 
> It would have been much easier to handle something like:
> 
> data-lanes = <2>, <3>, <1>;
> 
> i.e. an array of the lane indexes.

I'm fine with that.

> > For receivers that can't reroute lanes internally, the data-lanes property
> > would be need to specify lanes in sequence.
> > 
> > data-lanes =<1 2 3>;
> 
> In this case we would be only interested in the number of cells in this
> property, but how it could be retrieved ? With an array, it could have been
> calculated from property length returned by of_property_find() (divided by
> sizof(u32)).

Agreed.

-- 
Regards,

Laurent Pinchart

