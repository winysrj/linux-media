Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:41825 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751950AbbCNAdv (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 13 Mar 2015 20:33:51 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Sebastian Reichel <sre@kernel.org>
Cc: Sakari Ailus <sakari.ailus@iki.fi>, linux-media@vger.kernel.org,
	devicetree@vger.kernel.org, pali.rohar@gmail.com
Subject: Re: [RFC 14/18] dt: bindings: Add bindings for omap3isp
Date: Sat, 14 Mar 2015 02:33:47 +0200
Message-ID: <2883656.UJCkXlITYW@avalon>
In-Reply-To: <20150313093453.GA4980@earth>
References: <1425764475-27691-1-git-send-email-sakari.ailus@iki.fi> <20150312230320.GO11954@valkosipuli.retiisi.org.uk> <20150313093453.GA4980@earth>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sebastian,

Thank you for the review.

On Friday 13 March 2015 10:34:53 Sebastian Reichel wrote:
> On Fri, Mar 13, 2015 at 01:03:21AM +0200, Sakari Ailus wrote:
> > [...]
> > 
> > > > +Required properties
> > > > +===================
> > > > +
> > > > +compatible	: "ti,omap3-isp"
> > > 
> > > I would rephrase that using the usual wording as "compatible: Must
> > > contain
> > > "ti,omap3-isp".
> > 
> > [...]
> > 
> > > > +ti,phy-type	: 0 -- 3430; 1 -- 3630
> > > 
> > > Would it make sense to add #define's for this ?
> > 
> > I'll use OMAP3ISP_PHY_TYPE_COMPLEX_IO and OMAP3ISP_PHY_TYPE_CSIPHY as
> > discussed.
> > 
> > > It could also make sense to document/name them "Complex I/O" and
> > > "CSIPHY" to avoid referring to the SoC that implements them, as the ISP
> > > is also found in SoCs other than 3430 and 3630.
> > > 
> > > Could the PHY type be derived from the ES revision that we query at
> > > runtime ?
> >
> > I think this would work on 3430 and 3630 but I'm not certain about others.
> > 
> > > We should also take into account the fact that the DM3730 has officially
> > > no CSIPHY, but still seems to implement them in practice.
> > 
> > The DT sources are for 36xx, but I'd guess it works on 37xx as well,
> > doesn't it?
> 
> In other drivers this kind of information is often extracted from the
> compatible string. For example:
> 
> { .compatible = "ti,omap34xx-isp", .data = OMAP3ISP_PHY_TYPE_COMPLEX_IO, },
> { .compatible = "ti,omap36xx-isp", .data = OMAP3ISP_PHY_TYPE_CSIPHY, },
> ...

That's an option too, which I've discussed with Sakari before. The reason why 
we have decided to go for a separate property is that the PHY type seems to be 
more an SoC integration property than an ISP model property. I'm open to 
reconsidering that though.

Another option that has been discussed was to infer the PHY type from the ISP 
revision number queried at runtime. That would be fine for the 3430, 3630 and 
3730, but it remains unclear at this point whether this scheme would work with 
other SoCs. It should also be noted that some OMAP3-based SoCs that 
incorporate the ISP officially don't include the CSI PHYs, but seem to have 
them in practice.

> > [...]
> > 
> > > > +Example
> > > > +=======
> > > > +
> > > > +		omap3_isp: omap3_isp@480bc000 {
> > > 
> > > DT node names traditionally use - as a separator. Furthermore the
> > > phandle isn't needed. This should thus probably be
> > > 
> > > 	omap3-isp@480bc000 {
> > 
> > Fixed.
> 
> According to ePAPR this should be a generic name (page 19); For
> example the i2c node name should be "i2c@address" instead of
> "omap3-i2c@address". There is no recommended generic term for an
> image signal processor, "isp" looks ok to me and seems to be
> already used in NVIDIA Tegra's device tree files. So maybe:
> 
> isp@480bc000 {

"isp" sounds good to me.

-- 
Regards,

Laurent Pinchart

