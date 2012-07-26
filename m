Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:51586 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751040Ab2GZOi3 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 26 Jul 2012 10:38:29 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	linux-media@vger.kernel.org, kyungmin.park@samsung.com,
	m.szyprowski@samsung.com, riverful.kim@samsung.com,
	sw0312.kim@samsung.com, devicetree-discuss@lists.ozlabs.org,
	linux-samsung-soc@vger.kernel.org, b.zolnierkie@samsung.com
Subject: Re: [RFC/PATCH 02/13] media: s5p-csis: Add device tree support
Date: Thu, 26 Jul 2012 16:38:35 +0200
Message-ID: <24426306.kyhKLGOJzl@avalon>
In-Reply-To: <5005ABF7.6020008@gmail.com>
References: <4FBFE1EC.9060209@samsung.com> <Pine.LNX.4.64.1207161031000.12302@axis700.grange> <5005ABF7.6020008@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sylwester,

On Tuesday 17 July 2012 20:16:23 Sylwester Nawrocki wrote:
> On 07/16/2012 10:55 AM, Guennadi Liakhovetski wrote:
> > Hi Sylwester
> > 
> > Thanks for your comments to my RFC and for pointing out to this your
> > earlier patch series. Unfortunately, I missed in in May, let me try to
> > provide some thoughts about this, we should really try to converge our
> > proposals. Maybe a discussion at KS would help too.
> 
> Thank you for the review. I was happy to see your RFC, as previously
> there seemed to be not much interest in DT among the media guys.
> Certainly, we need to work on a common approach to ensure interoperability
> of existing drivers and to avoid having people inventing different
> bindings for common features. I would also expect some share of device
> specific bindings, as diversity of media devices is significant.
> 
> I'd be great to discuss these things at KS, especially support for
> proper suspend/resume sequences. Also having common sessions with
> other subsystems folks, like ASoC, for example, might be a good idea.
> 
> I'm not sure if I'll be travelling to the KS though. :)
> 
> > On Fri, 25 May 2012, Sylwester Nawrocki wrote:
> >> s5p-csis is platform device driver for MIPI-CSI frontend to the FIMC
> >> (camera host interface DMA engine and image processor). This patch
> >> adds support for instantiating the MIPI-CSIS devices from DT and
> >> parsing all SoC and board specific properties from device tree.
> >> The MIPI DPHY control callback is now called directly from within
> >> the driver, the platform code must ensure this callback does the
> >> right thing for each SoC.
> >> 
> >> The cell-index property is used to ensure proper signal routing,
> >> from physical camera port, through MIPI-CSI2 receiver to the DMA
> >> engine (FIMC?). It's also helpful in exposing the device topology
> >> in user space at /dev/media? devnode (Media Controller API).
> >> 
> >> This patch also defines a common property ("data-lanes") for MIPI-CSI
> >> receivers and transmitters.
> >> 
> >> Signed-off-by: Sylwester Nawrocki<s.nawrocki@samsung.com>
> >> Signed-off-by: Kyungmin Park<kyungmin.park@samsung.com>
> >> ---
> >> 
> >>   Documentation/devicetree/bindings/video/mipi.txt   |    5 +
> >>   .../bindings/video/samsung-mipi-csis.txt           |   47 ++++++++++
> >>   drivers/media/video/s5p-fimc/mipi-csis.c           |   97
> >>   +++++++++++++++----- drivers/media/video/s5p-fimc/mipi-csis.h         
> >>    |    1 +
> >>   4 files changed, 126 insertions(+), 24 deletions(-)
> >>   create mode 100644 Documentation/devicetree/bindings/video/mipi.txt
> >>   create mode 100644
> >>   Documentation/devicetree/bindings/video/samsung-mipi-csis.txt>> 
> >> diff --git a/Documentation/devicetree/bindings/video/mipi.txt
> >> b/Documentation/devicetree/bindings/video/mipi.txt new file mode 100644
> >> index 0000000..5aed285
> >> --- /dev/null
> >> +++ b/Documentation/devicetree/bindings/video/mipi.txt
> >> @@ -0,0 +1,5 @@
> >> +Common properties of MIPI-CSI1 and MIPI-CSI2 receivers and transmitters
> >> +
> >> + - data-lanes : number of differential data lanes wired and actively
> >> used in
> >> +		communication between the transmitter and the receiver, this
> >> +		excludes the clock lane;
> > 
> > Wouldn't it be better to use the standard "bus-width" DT property?
> 
> I can't see any problems with using "bus-width". It seems sufficient
> and could indeed be better, without a need to invent new MIPI-CSI
> specific names. That was my first RFC on that and my perspective
> wasn't probably broad enough. :)

What about CSI receivers that can reroute the lanes internally ? We would need 
to specify lane indices for each lane then, maybe with something like

clock-lane = <0>;
data-lanes = <2 3 1>;

For receivers that can't reroute lanes internally, the data-lanes property 
would be need to specify lanes in sequence.

data-lanes = <1 2 3>;

-- 
Regards,

Laurent Pinchart

