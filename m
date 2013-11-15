Return-path: <linux-media-owner@vger.kernel.org>
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:58190 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751808Ab3KORSh (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 15 Nov 2013 12:18:37 -0500
Date: Fri, 15 Nov 2013 17:18:10 +0000
From: Mark Rutland <mark.rutland@arm.com>
To: Sebastian Reichel <sre@debian.org>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	"devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
	"rob.herring@calxeda.com" <rob.herring@calxeda.com>,
	Pawel Moll <Pawel.Moll@arm.com>,
	Stephen Warren <swarren@wwwdotorg.org>,
	Ian Campbell <ijc+devicetree@hellion.org.uk>
Subject: Re: [early RFC] Device Tree bindings for OMAP3 Camera Subsystem
Message-ID: <20131115171809.GJ24831@e106331-lin.cambridge.arm.com>
References: <20131103220315.GA11659@earth.universe>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131103220315.GA11659@earth.universe>
Content-Language: en-US
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, Nov 03, 2013 at 10:03:15PM +0000, Sebastian Reichel wrote:
> Hi,
> 
> This is an early RFC for omap3isp DT support. For now i just created a potential DT
> binding documentation based on the existing platform data:
> 
> Binding for the OMAP3 Camera subsystem with the image signal processor (ISP) feature.
> 
> omap3isp node
> -------------
> 
> Required properties:
> 
> - compatible	: should be "ti,omap3isp" for OMAP3;
> - reg		: physical addresses and length of the registers set;
> - clocks	: list of clock specifiers, corresponding to entries in
> 		  clock-names property;
> - clock-names	: must contain "cam_ick", "cam_mclk", "csi2_96m_fck",
> 		  "l3_ick" entries, matching entries in the clocks property;
> - interrupts	: must contain mmu interrupt;
> - ti,iommu	: phandle to isp mmu;

s/;/./ (or s/;//)

> 
> Optional properties:
> 
> - VDD_CSIPHY1-supply	: regulator for csi phy1
> - VDD_CSIPHY2-supply	: regulator for csi phy2

I'd make these lower-case. Upper case is unusual, and lower-case is
preferred.

> - ti,isp-xclk-1		: device(s) attached to ISP's first external clock
> - ti,isp-xclk-2		: device(s) attached to ISP's second external clock

If the ISP is acting as a clock controller, it should have #clock-cells,
and export clocks to the consumers. They can in turn refer to th ISP via
the standard clocks property.

> 
> device-group subnode
> --------------------
> 
> Required properties:
> - ti,isp-interface-type	: Integer describing the interface type, one of the following
>    * 0 = ISP_INTERFACE_PARALLEL
>    * 1 = ISP_INTERFACE_CSI2A_PHY2
>    * 2 = ISP_INTERFACE_CCP2B_PHY1
>    * 3 = ISP_INTERFACE_CCP2B_PHY2
>    * 4 = ISP_INTERFACE_CSI2C_PHY1

Are these PHYs always present?

Are they external to the ISP?

It's not possible for several of these to be valid simultaneously?

> - ti,isp-devices	: Array of phandles to devices connected via the interface

Which devices are these? This looks backwards to me...

> - One of the following configuration nodes (depending on ti,isp-interface-type)
>  - ti,ccp2-bus-cfg	: CCP2 bus configuration (needed for ISP_INTERFACE_CCP*)
>  - ti,parallel-bus-cfg	: PARALLEL bus configuration (needed for ISP_INTERFACE_PARALLEL)
>  - ti,csi2-bus-cfg	: CSI bus configuration (needed for ISP_INTERFACE_CSI*)
> 
> ccp2-bus-cfg subnode
> --------------------
> 
> Required properties:
> - ti,video-port-clock-divisor	: integer; used for video port output clock control
> 
> Optional properties:
> - ti,inverted-clock		: boolean; clock/strobe signal is inverted
> - ti,enable-crc			: boolean; enable crc checking

Why can't this be a run-time option?

> - ti,ccp2-mode-mipi		: boolean; port is used in MIPI-CSI1 mode (default: CCP2 mode)
> - ti,phy-layer-is-strobe	: boolean; use data/strobe physical layer (default: data/clock physical layer)
> - ti,data-lane-configuration	: integer array with position and polarity information for lane 1 and 2
> - ti,clock-lane-configuration	: integer array with position and polarity information for clock lane

In what precise format?

> 
> parallel-bus-cfg subnode
> ------------------------
> 
> Required properties:
> - ti,data-lane-shift				: integer; shift data lanes by this amount
> 
> Optional properties:
> - ti,clock-falling-edge				: boolean; sample on falling edge (default: rising edge)
> - ti,horizontal-synchronization-active-low	: boolean; default: active high
> - ti,vertical-synchronization-active-low	: boolean; default: active high
> - ti,data-polarity-ones-complement		: boolean; data polarity is one's complement
> 
> csi2-bus-cfg subnode
> --------------------
> 
> Required properties:
> - ti,video-port-clock-divisor	: integer; used for video port output clock control
> 
> Optional properties:
> - ti,data-lane-configuration	: integer array with position and polarity information for lane 1 and 2
> - ti,clock-lane-configuration	: integer array with position and polarity information for clock lane
> - ti,enable-crc			: boolean; enable crc checking

Similarly, run-time selectable?

> 
> Example for Nokia N900
> ----------------------
> 
> omap3isp: isp@480BC000 {
> 	compatible = "ti,omap3isp";
> 	reg = <
> 		/* OMAP3430+ */
> 		0x480BC000 0x070	/* base */
> 		0x480BC100 0x078	/* cbuf */
> 		0x480BC400 0x1F0 	/* cpp2 */
> 		0x480BC600 0x0A8	/* ccdc */
> 		0x480BCA00 0x048	/* hist */
> 		0x480BCC00 0x060	/* h3a  */
> 		0x480BCE00 0x0A0	/* prev */
> 		0x480BD000 0x0AC	/* resz */
> 		0x480BD200 0x0FC	/* sbl  */
> 		0x480BD400 0x070	/* mmu  */
> 	>;

The binding implied a single contiguous reg entry. These look like they
are in a contiguous register space, is it not possible to describe them
via a single large contiguous entry?

Also, please bracket individual entries in a list like so:

reg = <0x0 0x4>,
      <0x44 0x27>,
      <0x800 0x63>;

It's far easier to read arbitrary lists when they're bracketed
consistently.

> 
> 	clocks = < &cam_ick &cam_mclk &csi2_96m_fck &l3_ick >;

Similarly here.

> 	clock-names = "cam_ick", "cam_mclk", "csi2_96m_fck", "l3_ick";
> 
> 	interrupts = <24>;
> 
> 	ti,iommu = <&mmu_isp>;
> 
> 	ti,isp-xclk-1 = <
> 		&et8ek8
> 		&smiapp_dfl
> 	>;

And here (though I think this property is unnecessary).

Thanks,
Mark.
