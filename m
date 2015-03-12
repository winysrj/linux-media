Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:53815 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751403AbbCLXD5 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 12 Mar 2015 19:03:57 -0400
Date: Fri, 13 Mar 2015 01:03:21 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: linux-media@vger.kernel.org, devicetree@vger.kernel.org,
	pali.rohar@gmail.com
Subject: Re: [RFC 14/18] dt: bindings: Add bindings for omap3isp
Message-ID: <20150312230320.GO11954@valkosipuli.retiisi.org.uk>
References: <1425764475-27691-1-git-send-email-sakari.ailus@iki.fi>
 <1425764475-27691-15-git-send-email-sakari.ailus@iki.fi>
 <1429813.xCjhlUaUXi@avalon>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1429813.xCjhlUaUXi@avalon>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

On Thu, Mar 12, 2015 at 01:39:07AM +0200, Laurent Pinchart wrote:
> Hi Sakari,
> 
> Thank you for the patch.
> 
> On Saturday 07 March 2015 23:41:11 Sakari Ailus wrote:
> > Signed-off-by: Sakari Ailus <sakari.ailus@iki.fi>
> > ---
> >  .../devicetree/bindings/media/ti,omap3isp.txt      |   64 +++++++++++++++++
> >  MAINTAINERS                                        |    1 +
> >  2 files changed, 65 insertions(+)
> >  create mode 100644 Documentation/devicetree/bindings/media/ti,omap3isp.txt
> > 
> > diff --git a/Documentation/devicetree/bindings/media/ti,omap3isp.txt
> > b/Documentation/devicetree/bindings/media/ti,omap3isp.txt new file mode
> > 100644
> > index 0000000..2059524
> > --- /dev/null
> > +++ b/Documentation/devicetree/bindings/media/ti,omap3isp.txt
> > @@ -0,0 +1,64 @@
> > +OMAP 3 ISP Device Tree bindings
> > +===============================
> > +
> > +More documentation on these bindings is available in
> > +video-interfaces.txt in the same directory.
> > +
> > +Required properties
> > +===================
> > +
> > +compatible	: "ti,omap3-isp"
> 
> I would rephrase that using the usual wording as "compatible: Must contain 
> "ti,omap3-isp".

Fixed.

> > +reg		: a set of two register block physical addresses and
> > +		  lengths
> 
> We should describe what each set represents and contains.

As discussed:

reg             : the two registers sets (physical address and length) for the
                  ISP. The first set contains the core ISP registers up to
                  the end of the SBL block. The second set contains the
                  CSI PHYs and receivers registers.

> > +interrupts	: the interrupt number
> 
> I would keep the wording generic and refer to interrupt specifier instead of 
> interrupt number.
> 
> "interrupts: the ISP interrupt specifier"

Fixed.

> > +iommus		: phandle of the IOMMU
> 
> Similarly,
> 
> "iommus: phandle and IOMMU specifier for the IOMMU that serves the ISP"

Ditto.

> > +syscon		: syscon phandle and register offset
> 
> We should document what the register offset is.

This is SoC specific as is the base address. I'm not sure that would be
relevant here. If you think so, shouldn't we also add the device base
addresses and register block lengths?

> > +ti,phy-type	: 0 -- 3430; 1 -- 3630
> 
> Would it make sense to add #define's for this ?

I'll use OMAP3ISP_PHY_TYPE_COMPLEX_IO and OMAP3ISP_PHY_TYPE_CSIPHY as
discussed.

> It could also make sense to document/name them "Complex I/O" and "CSIPHY" to 
> avoid referring to the SoC that implements them, as the ISP is also found in 
> SoCs other than 3430 and 3630.
> 
> Could the PHY type be derived from the ES revision that we query at runtime ?

I think this would work on 3430 and 3630 but I'm not certain about others.

> We should also take into account the fact that the DM3730 has officially no 
> CSIPHY, but still seems to implement them in practice.

The DT sources are for 36xx, but I'd guess it works on 37xx as well, doesn't
it?

> > +#clock-cells	: Must be 1 --- the ISP provides two external clocks,
> > +		  cam_xclka and cam_xclkb, at indices 0 and 1,
> > +		  respectively. Please find more information on common
> > +		  clock bindings in ../clock/clock-bindings.txt.
> > +
> > +Port nodes (optional)
> > +---------------------
> 
> This should refer to Documentation/devicetree/bindings/media/video-
> interfaces.txt.

There's a reference to video-interfaces.txt in the beginning of the file. Do
you think that'd be enough?

> > +reg		: The interface:
> > +		  0 - parallel (CCDC)
> > +		  1 - CSIPHY1 -- CSI2C / CCP2B on 3630;
> > +		      CSI1 -- CSIb on 3430
> > +		  2 - CSIPHY2 -- CSI2A / CCP2B on 3630;
> > +		      CSI2 -- CSIa on 3430
> > +
> > +Optional properties
> > +===================
> > +
> > +vdd-csiphy1-supply : voltage supply of the CSI-2 PHY 1
> > +vdd-csiphy2-supply : voltage supply of the CSI-2 PHY 2
> > +
> > +Endpoint nodes
> > +--------------
> > +
> > +lane-polarity	: lane polarity (required on CSI-2)
> > +		  0 -- not inverted; 1 -- inverted
> > +data-lanes	: an array of data lanes from 1 to 3. The length can
> > +		  be either 1 or 2. (required CSI-2)
> 
> s/required/required on/ ?

Fixed.

> > +clock-lanes	: the clock lane (from 1 to 3). (required on CSI-2)
> > +
> > +
> > +Example
> > +=======
> > +
> > +		omap3_isp: omap3_isp@480bc000 {
> 
> DT node names traditionally use - as a separator. Furthermore the phandle 
> isn't needed. This should thus probably be
> 
> 	omap3-isp@480bc000 {

Fixed.

> > +			compatible = "ti,omap3-isp";
> > +			reg = <0x480bc000 0x12fc
> > +			       0x480bd800 0x0600>;
> > +			interrupts = <24>;
> > +			iommus = <&mmu_isp>;
> > +			syscon = <&omap3_scm_general 0x2f0>;
> > +			ti,phy-type = <1>;
> > +			#clock-cells = <1>;
> > +			ports {
> > +				#address-cells = <1>;
> > +				#size-cells = <0>;
> > +			};
> > +		};
> > diff --git a/MAINTAINERS b/MAINTAINERS
> > index ddc5a8c..cdeef39 100644
> > --- a/MAINTAINERS
> > +++ b/MAINTAINERS
> > @@ -7079,6 +7079,7 @@ L:	linux-media@vger.kernel.org
> >  S:	Maintained
> >  F:	drivers/media/platform/omap3isp/
> >  F:	drivers/staging/media/omap4iss/
> > +F:	Documentation/devicetree/bindings/media/ti,omap3isp.txt
> 
> I would move this line before the other F: entries to keep them alphabetically 
> sorted.

Fixed.

> >  OMAP USB SUPPORT
> >  M:	Felipe Balbi <balbi@ti.com>
> 

-- 
Kind regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
