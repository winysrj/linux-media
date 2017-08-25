Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:41075 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934471AbdHYQeY (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 25 Aug 2017 12:34:24 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Maxime Ripard <maxime.ripard@free-electrons.com>
Cc: Cyprian Wronka <cwronka@cadence.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Rob Herring <robh+dt@kernel.org>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
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
Date: Fri, 25 Aug 2017 19:34:55 +0300
Message-ID: <1955840.czSnNPfaK8@avalon>
In-Reply-To: <20170825144440.beettgwsynics3hs@flea.lan>
References: <20170720092302.2982-1-maxime.ripard@free-electrons.com> <2518768.foDtbh9bhx@avalon> <20170825144440.beettgwsynics3hs@flea.lan>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Maxime,

On Friday, 25 August 2017 17:44:40 EEST Maxime Ripard wrote:
> On Wed, Aug 23, 2017 at 12:03:32AM +0300, Laurent Pinchart wrote:
> >>>>>> +  - phys: phandle to the external D-PHY
> >>>>>> +  - phy-names: must contain dphy, if the implementation uses an
> >>>>>> +     external D-PHY
> >>>>> 
> >>>>> I would move the last two properties in an optional category as
> >>>>> they're effectively optional. I think you should also explain a bit
> >>>>> more clearly that the phys property must not be present if the phy-
> >>>>> names property is not present.
> >>>> 
> >>>> It's not really optional. The IP has a configuration register that
> >>>> allows you to see if it's been synthesized with or without a PHY. If
> >>>> the right bit is set, that property will be mandatory, if not, it's
> >>>> useless.
> >>> 
> >>> Just to confirm, the PHY is a separate IP core, right ? Is the CSI-2
> >>> receiver input interface different when used with a PHY and when used
> >>> without one ? Could a third-party PHY be used as well ? If so, would
> >>> the PHY synthesis bit be set or not ?
> >> 
> >> The PHY (in our case a D-PHY) is a separate entity, it can be from a 3rd
> >> party as the IP interface is standard, the SoC integrator would set the
> >> bit accordingly based on whether any PHY is present or not. There is also
> >> an option of routing digital output from a CSI-TX to a CSI-RX and in such
> >> case a PHY would not need to be used (as in the case of our current
> >> platform).
> > 
> > OK, thank you for the clarification.
> > 
> > Maxime mentioned that a bit can be read from a register to notify whether
> > a PHY has been synthesized or not. Does it influence the CSI-2 RX input
> > interface at all, or is the CSI-2 RX IP core synthesized the same way
> > regardless of whether a PHY is present or not ?
> 
> So we got an answer to this, and the physical interface remains the
> same.
> 
> However, the PHY bit is set only when there's an internal D-PHY, which
> means we have basically three cases:
>   - No D-PHY at all, D-PHY presence bit not set
>   - Internal D-PHY, D-PHY presence bit set
>   - External D-PHY, D-PHY presence bit not set
> 
> I guess that solves our discussion about whether the phys property
> should be marked optional or not. It should indeed be optional, and
> when it's not there, the D-PHY presence bit will tell whether we have
> to program the internal D-PHY or not.

Is the internal D-PHY programmed through the register space of the CSI2-RX ? 
If so I agree with you.

-- 
Regards,

Laurent Pinchart
