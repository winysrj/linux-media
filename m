Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:54170 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752710AbbCLXnz (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 12 Mar 2015 19:43:55 -0400
Date: Fri, 13 Mar 2015 01:43:51 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: linux-media@vger.kernel.org, devicetree@vger.kernel.org,
	pali.rohar@gmail.com
Subject: Re: [RFC 14/18] dt: bindings: Add bindings for omap3isp
Message-ID: <20150312234350.GP11954@valkosipuli.retiisi.org.uk>
References: <1425764475-27691-1-git-send-email-sakari.ailus@iki.fi>
 <1429813.xCjhlUaUXi@avalon>
 <20150312230320.GO11954@valkosipuli.retiisi.org.uk>
 <2648615.8gSgjdUuiM@avalon>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2648615.8gSgjdUuiM@avalon>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

On Fri, Mar 13, 2015 at 01:11:03AM +0200, Laurent Pinchart wrote:
> Hi Sakari,
> 
> On Friday 13 March 2015 01:03:21 Sakari Ailus wrote:
> > On Thu, Mar 12, 2015 at 01:39:07AM +0200, Laurent Pinchart wrote:
> > > On Saturday 07 March 2015 23:41:11 Sakari Ailus wrote:
> > > > Signed-off-by: Sakari Ailus <sakari.ailus@iki.fi>
> > > > ---
> > > > 
> > > >  .../devicetree/bindings/media/ti,omap3isp.txt      |   64 +++++++++++++
> > > >  MAINTAINERS                                        |    1 +
> > > >  2 files changed, 65 insertions(+)
> > > >  create mode 100644
> > > >  Documentation/devicetree/bindings/media/ti,omap3isp.txt
> > > > 
> > > > diff --git a/Documentation/devicetree/bindings/media/ti,omap3isp.txt
> > > > b/Documentation/devicetree/bindings/media/ti,omap3isp.txt new file mode
> > > > 100644
> > > > index 0000000..2059524
> > > > --- /dev/null
> > > > +++ b/Documentation/devicetree/bindings/media/ti,omap3isp.txt
> 
> [snip]
> 
> > > > +syscon		: syscon phandle and register offset
> > > 
> > > We should document what the register offset is.
> > 
> > This is SoC specific as is the base address. I'm not sure that would be
> > relevant here. If you think so, shouldn't we also add the device base
> > addresses and register block lengths?
> 
> I meant something like
> 
> syscon:	the phandle and register offset to the Complex I/O or CSI-PHY 
> register.

Oh, I misunderstood you. I'll use that text.

> > > > +ti,phy-type	: 0 -- 3430; 1 -- 3630
> > > 
> > > Would it make sense to add #define's for this ?
> > 
> > I'll use OMAP3ISP_PHY_TYPE_COMPLEX_IO and OMAP3ISP_PHY_TYPE_CSIPHY as
> > discussed.
> > 
> > > It could also make sense to document/name them "Complex I/O" and "CSIPHY"
> > > to avoid referring to the SoC that implements them, as the ISP is also
> > > found in SoCs other than 3430 and 3630.
> > > 
> > > Could the PHY type be derived from the ES revision that we query at
> > > runtime ?
> >
> > I think this would work on 3430 and 3630 but I'm not certain about others.
> > 
> > > We should also take into account the fact that the DM3730 has officially
> > > no CSIPHY, but still seems to implement them in practice.
> > 
> > The DT sources are for 36xx, but I'd guess it works on 37xx as well, doesn't
> > it?
> 
> I think so.
> 
> > > > +#clock-cells	: Must be 1 --- the ISP provides two external clocks,
> > > > +		  cam_xclka and cam_xclkb, at indices 0 and 1,
> > > > +		  respectively. Please find more information on common
> > > > +		  clock bindings in ../clock/clock-bindings.txt.
> > > > +
> > > > +Port nodes (optional)
> > > > +---------------------
> > > 
> > > This should refer to Documentation/devicetree/bindings/media/video-
> > > interfaces.txt.
> > 
> > There's a reference to video-interfaces.txt in the beginning of the file. Do
> > you think that'd be enough?
> 
> I've missed that. I think you could move the reference here.

Done.

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
