Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:35435 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755373Ab3KFAsQ (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 5 Nov 2013 19:48:16 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Sebastian Reichel <sre@debian.org>
Cc: linux-media@vger.kernel.org, devicetree@vger.kernel.org,
	Rob Herring <rob.herring@calxeda.com>,
	Pawel Moll <pawel.moll@arm.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Stephen Warren <swarren@wwwdotorg.org>,
	Ian Campbell <ijc+devicetree@hellion.org.uk>
Subject: Re: [early RFC] Device Tree bindings for OMAP3 Camera Subsystem
Date: Wed, 06 Nov 2013 01:48:38 +0100
Message-ID: <2721178.kPBqiMNVyq@avalon>
In-Reply-To: <20131103220315.GA11659@earth.universe>
References: <20131103220315.GA11659@earth.universe>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart3889507.KlpueUuOIH"; micalg="pgp-sha1"; protocol="application/pgp-signature"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--nextPart3889507.KlpueUuOIH
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"

Hi Sebastian,

Thank you for the aptch.

On Sunday 03 November 2013 23:03:15 Sebastian Reichel wrote:
> Hi,
> 
> This is an early RFC for omap3isp DT support. For now i just created a
> potential DT binding documentation based on the existing platform data:
> 
> Binding for the OMAP3 Camera subsystem with the image signal processor (ISP)
> feature.
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

According to the OMAP36xx TRM, the ISP functional and interface clocks are 
called CAM_FCLK and CAM_ICLK. They are driven by L3_ICLK and L4_ICLK 
respectively, and both gated through a single bit.

The OMAP platform code instantiates a cam_ick clock for CAM_ICLK but doesn't 
create any clock for CAM_FCLK. The reason is probably that such a clock wasn't 
really needed, as enabling the interface clock enables the functional clock 
anyway.

Now that we're moving to DT the clock names will be set in stone, so maybe we 
should think about them a bit. Would it make sense to rename the clocks 
according to the names used in the OMAP36xx TRM ? We should probably check the 
documentation of the other SoCs in which the ISP is used to verify whether the 
names match. Would it also make sense to create an FCLK clock and use it 
instead of l3_ick ?

> - interrupts	: must contain mmu interrupt;
> - ti,iommu	: phandle to isp mmu;

Are there DT bindings for the IOMMU ? They don't seem to be present in 
mainline.

> Optional properties:
> 
> - VDD_CSIPHY1-supply	: regulator for csi phy1
> - VDD_CSIPHY2-supply	: regulator for csi phy2

Should the regulators be renamed to lower-case ?

> - ti,isp-xclk-1		: device(s) attached to ISP's first external clock
> - ti,isp-xclk-2		: device(s) attached to ISP's second external clock

That information should be present in the clock client node, not the ISP node.

> device-group subnode
> --------------------
>
> Required properties:
> - ti,isp-interface-type	: Integer describing the interface type, one of the
> following * 0 = ISP_INTERFACE_PARALLEL
>    * 1 = ISP_INTERFACE_CSI2A_PHY2
>    * 2 = ISP_INTERFACE_CCP2B_PHY1
>    * 3 = ISP_INTERFACE_CCP2B_PHY2
>    * 4 = ISP_INTERFACE_CSI2C_PHY1
> - ti,isp-devices	: Array of phandles to devices connected via the interface

Is there any reason why you don't use the V4L2 DT bindings to describe the 
pipeline ?

> - One of the following configuration nodes (depending on
> ti,isp-interface-type) - ti,ccp2-bus-cfg	: CCP2 bus configuration (needed
> for ISP_INTERFACE_CCP*) - ti,parallel-bus-cfg	: PARALLEL bus configuration
> (needed for ISP_INTERFACE_PARALLEL) - ti,csi2-bus-cfg	: CSI bus
> configuration (needed for ISP_INTERFACE_CSI*)
> 
> ccp2-bus-cfg subnode
> --------------------
> 
> Required properties:
> - ti,video-port-clock-divisor	: integer; used for video port output clock
> control
> 
> Optional properties:
> - ti,inverted-clock		: boolean; clock/strobe signal is inverted
> - ti,enable-crc			: boolean; enable crc checking
> - ti,ccp2-mode-mipi		: boolean; port is used in MIPI-CSI1 mode (default:
> CCP2 mode) - ti,phy-layer-is-strobe	: boolean; use data/strobe physical
> layer (default: data/clock physical layer) - ti,data-lane-configuration	:
> integer array with position and polarity information for lane 1 and 2 -
> ti,clock-lane-configuration	: integer array with position and polarity
> information for clock lane
> 
> parallel-bus-cfg subnode
> ------------------------
> 
> Required properties:
> - ti,data-lane-shift				: integer; shift data lanes by this amount
> 
> Optional properties:
> - ti,clock-falling-edge				: boolean; sample on falling edge 
(default:
> rising edge) - ti,horizontal-synchronization-active-low	: boolean; default:
> active high - ti,vertical-synchronization-active-low	: boolean; default:
> active high - ti,data-polarity-ones-complement		: boolean; data polarity 
is
> one's complement
> 
> csi2-bus-cfg subnode
> --------------------
> 
> Required properties:
> - ti,video-port-clock-divisor	: integer; used for video port output clock
> control
> 
> Optional properties:
> - ti,data-lane-configuration	: integer array with position and polarity
> information for lane 1 and 2 - ti,clock-lane-configuration	: integer 
array
> with position and polarity information for clock lane - ti,enable-crc			
:
> boolean; enable crc checking
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
> 
> 	clocks = < &cam_ick &cam_mclk &csi2_96m_fck &l3_ick >;
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
> 
> 	group1: device-group@0 {
> 		ti,isp-interface-type = <2>;
> 
> 		ti,isp-devices = <
> 			&et8ek8
> 			&ad5820
> 			&adp1653
> 		>;
> 
> 		ti,ccp2-bus-cfg {
> 			ti,enable-crc;
> 			ti,phy-layer-is-strobe;
> 			ti,video-port-clock-divisor = <1>;
> 		};
> 	};
> 
> 	group2: device-group@1 {
> 		ti,isp-interface-type = <2>;
> 
> 		ti,isp-devices = <
> 			&smiapp_dfl
> 		>;
> 
> 		ti,ccp2-bus-cfg {
> 			ti,enable-crc;
> 			ti,phy-layer-is-strobe;
> 			ti,video-port-clock-divisor = <1>;
> 		};
> 	};
> };
-- 
Regards,

Laurent Pinchart

--nextPart3889507.KlpueUuOIH
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.
Content-Transfer-Encoding: 7Bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQEcBAABAgAGBQJSeZHtAAoJEIkPb2GL7hl1kpIH/0CYEF1jKGHXZSNBDofthQ2h
zWja0g+MieKJxdodRRiDsX20h9015O2QTm6qB3Pfk8v5rTdmJvpYWRFIE78yNk7i
mOre9lGRGJz/HCoExacJrSriIYVMqvYTs5d7hbkN7Zg9Wve5Z08wwV7jeuvu1DhC
MfIRVpWGjYoiDO+FNNI5kVExbfZszDwuR1kaRfL7ZM1xX6Ja5gOR69l8HqjAybSv
UFqthJ3bYNfcMEv6X4OjleslHT2SHWMp+4fm/WomvqDNKvOul7Pluvjtl3OWv9dz
H88twitmVCInN+U4CscBQh1jJKQw/UxHFlSzkt1eiDQ0ThcHqRzZf67ljyPWe4A=
=+VH2
-----END PGP SIGNATURE-----

--nextPart3889507.KlpueUuOIH--

