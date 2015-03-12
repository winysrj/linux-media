Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:40723 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752397AbbCLXLD (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 12 Mar 2015 19:11:03 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: linux-media@vger.kernel.org, devicetree@vger.kernel.org,
	pali.rohar@gmail.com
Subject: Re: [RFC 14/18] dt: bindings: Add bindings for omap3isp
Date: Fri, 13 Mar 2015 01:11:03 +0200
Message-ID: <2648615.8gSgjdUuiM@avalon>
In-Reply-To: <20150312230320.GO11954@valkosipuli.retiisi.org.uk>
References: <1425764475-27691-1-git-send-email-sakari.ailus@iki.fi> <1429813.xCjhlUaUXi@avalon> <20150312230320.GO11954@valkosipuli.retiisi.org.uk>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

On Friday 13 March 2015 01:03:21 Sakari Ailus wrote:
> On Thu, Mar 12, 2015 at 01:39:07AM +0200, Laurent Pinchart wrote:
> > On Saturday 07 March 2015 23:41:11 Sakari Ailus wrote:
> > > Signed-off-by: Sakari Ailus <sakari.ailus@iki.fi>
> > > ---
> > > 
> > >  .../devicetree/bindings/media/ti,omap3isp.txt      |   64 +++++++++++++
> > >  MAINTAINERS                                        |    1 +
> > >  2 files changed, 65 insertions(+)
> > >  create mode 100644
> > >  Documentation/devicetree/bindings/media/ti,omap3isp.txt
> > > 
> > > diff --git a/Documentation/devicetree/bindings/media/ti,omap3isp.txt
> > > b/Documentation/devicetree/bindings/media/ti,omap3isp.txt new file mode
> > > 100644
> > > index 0000000..2059524
> > > --- /dev/null
> > > +++ b/Documentation/devicetree/bindings/media/ti,omap3isp.txt

[snip]

> > > +syscon		: syscon phandle and register offset
> > 
> > We should document what the register offset is.
> 
> This is SoC specific as is the base address. I'm not sure that would be
> relevant here. If you think so, shouldn't we also add the device base
> addresses and register block lengths?

I meant something like

syscon:	the phandle and register offset to the Complex I/O or CSI-PHY 
register.

> > > +ti,phy-type	: 0 -- 3430; 1 -- 3630
> > 
> > Would it make sense to add #define's for this ?
> 
> I'll use OMAP3ISP_PHY_TYPE_COMPLEX_IO and OMAP3ISP_PHY_TYPE_CSIPHY as
> discussed.
> 
> > It could also make sense to document/name them "Complex I/O" and "CSIPHY"
> > to avoid referring to the SoC that implements them, as the ISP is also
> > found in SoCs other than 3430 and 3630.
> > 
> > Could the PHY type be derived from the ES revision that we query at
> > runtime ?
>
> I think this would work on 3430 and 3630 but I'm not certain about others.
> 
> > We should also take into account the fact that the DM3730 has officially
> > no CSIPHY, but still seems to implement them in practice.
> 
> The DT sources are for 36xx, but I'd guess it works on 37xx as well, doesn't
> it?

I think so.

> > > +#clock-cells	: Must be 1 --- the ISP provides two external clocks,
> > > +		  cam_xclka and cam_xclkb, at indices 0 and 1,
> > > +		  respectively. Please find more information on common
> > > +		  clock bindings in ../clock/clock-bindings.txt.
> > > +
> > > +Port nodes (optional)
> > > +---------------------
> > 
> > This should refer to Documentation/devicetree/bindings/media/video-
> > interfaces.txt.
> 
> There's a reference to video-interfaces.txt in the beginning of the file. Do
> you think that'd be enough?

I've missed that. I think you could move the reference here.

> > > +reg		: The interface:
> > > +		  0 - parallel (CCDC)
> > > +		  1 - CSIPHY1 -- CSI2C / CCP2B on 3630;
> > > +		      CSI1 -- CSIb on 3430
> > > +		  2 - CSIPHY2 -- CSI2A / CCP2B on 3630;
> > > +		      CSI2 -- CSIa on 3430

-- 
Regards,

Laurent Pinchart

