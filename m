Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:38542 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751934AbbCNOKP (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 14 Mar 2015 10:10:15 -0400
Date: Sat, 14 Mar 2015 16:10:11 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Sebastian Reichel <sre@kernel.org>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	linux-media@vger.kernel.org, devicetree@vger.kernel.org,
	pali.rohar@gmail.com
Subject: Re: [RFC 14/18] dt: bindings: Add bindings for omap3isp
Message-ID: <20150314141010.GU11954@valkosipuli.retiisi.org.uk>
References: <1425764475-27691-1-git-send-email-sakari.ailus@iki.fi>
 <1425764475-27691-15-git-send-email-sakari.ailus@iki.fi>
 <1429813.xCjhlUaUXi@avalon>
 <20150312230320.GO11954@valkosipuli.retiisi.org.uk>
 <20150313093453.GA4980@earth>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150313093453.GA4980@earth>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sebastian,

Thanks for the comments!

On Fri, Mar 13, 2015 at 10:34:53AM +0100, Sebastian Reichel wrote:
> Hi,
> 
> On Fri, Mar 13, 2015 at 01:03:21AM +0200, Sakari Ailus wrote:
> > [...]
> >
> > > > +Required properties
> > > > +===================
> > > > +
> > > > +compatible	: "ti,omap3-isp"
> > > 
> > > I would rephrase that using the usual wording as "compatible: Must contain 
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
> > > It could also make sense to document/name them "Complex I/O" and "CSIPHY" to 
> > > avoid referring to the SoC that implements them, as the ISP is also found in 
> > > SoCs other than 3430 and 3630.
> > > 
> > > Could the PHY type be derived from the ES revision that we query at runtime ?
> > 
> > I think this would work on 3430 and 3630 but I'm not certain about others.
> > 
> > > We should also take into account the fact that the DM3730 has officially no 
> > > CSIPHY, but still seems to implement them in practice.
> > 
> > The DT sources are for 36xx, but I'd guess it works on 37xx as well, doesn't
> > it?
> 
> In other drivers this kind of information is often extracted from the
> compatible string. For example:
> 
> { .compatible = "ti,omap34xx-isp", .data = OMAP3ISP_PHY_TYPE_COMPLEX_IO, },
> { .compatible = "ti,omap36xx-isp", .data = OMAP3ISP_PHY_TYPE_CSIPHY, },
> ...

As Laurent said, I'd prefer to keep it as it is now; they phy selection
isn't really a part of the ISP in hardware either. It just happens to be
that the first phy selection logic can be found in 3430 (isp rev 2.0) and
latter in 3630 (isp rev 15.0).

> > [...]
> >
> > > > +Example
> > > > +=======
> > > > +
> > > > +		omap3_isp: omap3_isp@480bc000 {
> > > 
> > > DT node names traditionally use - as a separator. Furthermore the phandle 
> > > isn't needed. This should thus probably be
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

Thanks for the suggestion. I'll fix that.

-- 
Kind regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
