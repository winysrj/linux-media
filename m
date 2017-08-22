Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:51265 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932205AbdHVJAl (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 22 Aug 2017 05:00:41 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Maxime Ripard <maxime.ripard@free-electrons.com>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Rob Herring <robh+dt@kernel.org>, linux-media@vger.kernel.org,
        devicetree@vger.kernel.org, Cyprian Wronka <cwronka@cadence.com>,
        Neil Webb <neilw@cadence.com>,
        Richard Sproul <sproul@cadence.com>,
        Alan Douglas <adouglas@cadence.com>,
        Steve Creaney <screaney@cadence.com>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Boris Brezillon <boris.brezillon@free-electrons.com>,
        Niklas =?ISO-8859-1?Q?S=F6derlund?=
        <niklas.soderlund@ragnatech.se>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>
Subject: Re: [PATCH v2 1/2] dt-bindings: media: Add Cadence MIPI-CSI2 RX Device Tree bindings
Date: Tue, 22 Aug 2017 12:01:11 +0300
Message-ID: <6400552.TlCMAsqn3H@avalon>
In-Reply-To: <20170822085320.pdxbxfv53rb75btu@flea.lan>
References: <20170720092302.2982-1-maxime.ripard@free-electrons.com> <2362756.VjbdGaYBzu@avalon> <20170822085320.pdxbxfv53rb75btu@flea.lan>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Maxime,

On Tuesday, 22 August 2017 11:53:20 EEST Maxime Ripard wrote:
> On Mon, Aug 07, 2017 at 11:18:03PM +0300, Laurent Pinchart wrote:
> > On Thursday 20 Jul 2017 11:23:01 Maxime Ripard wrote:
> >> The Cadence MIPI-CSI2 RX controller is a CSI2RX bridge that supports up
> >> to 4 CSI-2 lanes, and can route the frames to up to 4 streams, depending
> >> on the hardware implementation.
> >> 
> >> It can operate with an external D-PHY, an internal one or no D-PHY at
> >> all in some configurations.
> > 
> > Without any PHY ? I'm curious, how does that work ?
> 
> We're currently working on an FPGA exactly with that configuration. So
> I guess the answer would be "it doesn't on an ASIC" :)

What's connected to the input of the CSI-2 receiver ?

> >> Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>
> >> ---
> >> 
> >>  .../devicetree/bindings/media/cdns-csi2rx.txt      | 87 ++++++++++++++++
> >>  1 file changed, 87 insertions(+)
> >>  create mode 100644
> >>  Documentation/devicetree/bindings/media/cdns-csi2rx.txt
> >> 
> >> diff --git a/Documentation/devicetree/bindings/media/cdns-csi2rx.txt
> >> b/Documentation/devicetree/bindings/media/cdns-csi2rx.txt new file mode
> >> 100644
> >> index 000000000000..e08547abe885
> >> --- /dev/null
> >> +++ b/Documentation/devicetree/bindings/media/cdns-csi2rx.txt
> >> @@ -0,0 +1,87 @@
> >> +Cadence MIPI-CSI2 RX controller
> >> +===============================
> >> +
> >> +The Cadence MIPI-CSI2 RX controller is a CSI-2 bridge supporting up to
> >> 4> CSI
> >> +lanes in input, and 4 different pixel streams in output.
> >> +
> >> +Required properties:
> >> +  - compatible: must be set to "cdns,csi2rx" and an SoC-specific
> >> compatible
> >> +  - reg: base address and size of the memory mapped region
> >> +  - clocks: phandles to the clocks driving the controller
> >> +  - clock-names: must contain:
> >> +    * sys_clk: main clock
> >> +    * p_clk: register bank clock
> >> +    * p_free_clk: free running register bank clock
> >> +    * pixel_ifX_clk: pixel stream output clock, one for each stream
> >> +                     implemented in hardware, between 0 and 3
> > 
> > Nitpicking, I would write the name is pixel_if[0-3]_clk, it took me a few
> > seconds to see that the X was a placeholder.
> 
> Ok.
> 
> >> +    * dphy_rx_clk: D-PHY byte clock, if implemented in hardware
> >> +  - phys: phandle to the external D-PHY
> >> +  - phy-names: must contain dphy, if the implementation uses an
> >> +               external D-PHY
> > 
> > I would move the last two properties in an optional category as they're
> > effectively optional. I think you should also explain a bit more clearly
> > that the phys property must not be present if the phy-names property is
> > not present.
> 
> It's not really optional. The IP has a configuration register that
> allows you to see if it's been synthesized with or without a PHY. If
> the right bit is set, that property will be mandatory, if not, it's
> useless.

Just to confirm, the PHY is a separate IP core, right ? Is the CSI-2 receiver 
input interface different when used with a PHY and when used without one ? 
Could a third-party PHY be used as well ? If so, would the PHY synthesis bit 
be set or not ?

> Maybe it's just semantics, but to me, optional means that it can
> operate with or without it under any circumstances. It's not really
> the case here.

It'sa semantic issue, but documenting a property as required when it can be 
ommitted under some circumstances seems even weirder to me :-) I understand 
the optional category as "can be ommitted in certain circumstances".

> >> +
> >> +Required subnodes:
> >> +  - ports: A ports node with endpoint definitions as defined in
> >> +          
> >> Documentation/devicetree/bindings/media/video-interfaces.txt.
> >> The
> >> +           first port subnode should be the input endpoint, the second
> >> one the
> >> +           outputs
> >> +
> >> +  The output port should have as many endpoints as stream supported by
> >> +  the hardware implementation, between 1 and 4, their ID being the
> >> +  stream output number used in the implementation.
> > 
> > I don't think that's correct. The IP has four independent outputs, it
> > should have 4 output ports for a total for 5 ports. Multiple endpoints
> > per port would describe multiple connections from the same output to
> > different sinks.
>
> Ok.

-- 
Regards,

Laurent Pinchart
