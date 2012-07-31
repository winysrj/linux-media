Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:60800 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751789Ab2GaVhP (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 31 Jul 2012 17:37:15 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Sylwester Nawrocki <s.nawrocki@samsung.com>
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Sylwester Nawrocki <sylvester.nawrocki@gmail.com>,
	linux-media@vger.kernel.org, kyungmin.park@samsung.com,
	m.szyprowski@samsung.com, riverful.kim@samsung.com,
	sw0312.kim@samsung.com, devicetree-discuss@lists.ozlabs.org,
	linux-samsung-soc@vger.kernel.org, b.zolnierkie@samsung.com
Subject: Re: [RFC/PATCH 02/13] media: s5p-csis: Add device tree support
Date: Tue, 31 Jul 2012 23:37:20 +0200
Message-ID: <1964196.hivxX7VrnL@avalon>
In-Reply-To: <5017D1CB.80709@samsung.com>
References: <4FBFE1EC.9060209@samsung.com> <4835930.8zRiqxUPR0@avalon> <5017D1CB.80709@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sylwester,

On Tuesday 31 July 2012 14:38:35 Sylwester Nawrocki wrote:
> On 07/31/2012 01:05 PM, Laurent Pinchart wrote:
> >>>>> What about CSI receivers that can reroute the lanes internally ? We
> >>>>> would need to specify lane indices for each lane then, maybe with
> >>>>> something like
> >>>>> 
> >>>>> clock-lane =<0>;
> >>>>> data-lanes =<2 3 1>;
> >>>> 
> >>>> Sounds good to me. And the clock-lane could be made optional, as not
> >>>> all devices would need it.
> >>>> 
> >>>> However, as far as I can see, there is currently no generic API for
> >>>> handling this kind of data structure. E.g. number of cells for the
> >>>> "interrupts" property is specified with an additional
> >>>> "#interrupt-cells" property.
> >>>> 
> >>>> It would have been much easier to handle something like:
> >>>> 
> >>>> data-lanes = <2>, <3>, <1>;
> >>>> 
> >>>> i.e. an array of the lane indexes.
> >>> 
> >>> I'm fine with that.
> >> 
> >> ...on a second thought: shouldn't this be handled by pinctrl? Or is it
> >> some CSI-2 module internal lane switching, not the global SoC pin
> >> function configuration?
> > 
> > On the hardware I came across, it's handled by the CSI2 receiver, not the
> > SoC pinmux feature.
> 
> Same here. Is there any hardware known to mux those MIPI-CSI
> D-PHY high speed differential signals with general purpose IO pins ?
> 
> Or are there mostly dedicated pins used ?

The OMAP3 multiplexes the CSI pins with other functions.

> However, if there are cases the lane configuration is done solely at CSI2
> receiver level, there seems little point in involving the pinctrl API.

The OMAP3 handles lane routing in the CSI2 receiver.

-- 
Regards,

Laurent Pinchart

