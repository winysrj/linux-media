Return-path: <linux-media-owner@vger.kernel.org>
Received: from ring0.de ([91.143.88.219]:36938 "EHLO smtp.ring0.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754181Ab3KCWDW (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 3 Nov 2013 17:03:22 -0500
Date: Sun, 3 Nov 2013 23:03:15 +0100
From: Sebastian Reichel <sre@debian.org>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	linux-media@vger.kernel.org
Cc: devicetree@vger.kernel.org, Rob Herring <rob.herring@calxeda.com>,
	Pawel Moll <pawel.moll@arm.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Stephen Warren <swarren@wwwdotorg.org>,
	Ian Campbell <ijc+devicetree@hellion.org.uk>,
	Sebastian Reichel <sre@debian.org>
Subject: [early RFC] Device Tree bindings for OMAP3 Camera Subsystem
Message-ID: <20131103220315.GA11659@earth.universe>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="mYCpIKhGyMATD0i+"
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--mYCpIKhGyMATD0i+
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi,

This is an early RFC for omap3isp DT support. For now i just created a potential DT
binding documentation based on the existing platform data:

Binding for the OMAP3 Camera subsystem with the image signal processor (ISP) feature.

omap3isp node
-------------

Required properties:

- compatible	: should be "ti,omap3isp" for OMAP3;
- reg		: physical addresses and length of the registers set;
- clocks	: list of clock specifiers, corresponding to entries in
		  clock-names property;
- clock-names	: must contain "cam_ick", "cam_mclk", "csi2_96m_fck",
		  "l3_ick" entries, matching entries in the clocks property;
- interrupts	: must contain mmu interrupt;
- ti,iommu	: phandle to isp mmu;

Optional properties:

- VDD_CSIPHY1-supply	: regulator for csi phy1
- VDD_CSIPHY2-supply	: regulator for csi phy2
- ti,isp-xclk-1		: device(s) attached to ISP's first external clock
- ti,isp-xclk-2		: device(s) attached to ISP's second external clock

device-group subnode
--------------------

Required properties:
- ti,isp-interface-type	: Integer describing the interface type, one of the following
   * 0 = ISP_INTERFACE_PARALLEL
   * 1 = ISP_INTERFACE_CSI2A_PHY2
   * 2 = ISP_INTERFACE_CCP2B_PHY1
   * 3 = ISP_INTERFACE_CCP2B_PHY2
   * 4 = ISP_INTERFACE_CSI2C_PHY1
- ti,isp-devices	: Array of phandles to devices connected via the interface
- One of the following configuration nodes (depending on ti,isp-interface-type)
 - ti,ccp2-bus-cfg	: CCP2 bus configuration (needed for ISP_INTERFACE_CCP*)
 - ti,parallel-bus-cfg	: PARALLEL bus configuration (needed for ISP_INTERFACE_PARALLEL)
 - ti,csi2-bus-cfg	: CSI bus configuration (needed for ISP_INTERFACE_CSI*)

ccp2-bus-cfg subnode
--------------------

Required properties:
- ti,video-port-clock-divisor	: integer; used for video port output clock control

Optional properties:
- ti,inverted-clock		: boolean; clock/strobe signal is inverted
- ti,enable-crc			: boolean; enable crc checking
- ti,ccp2-mode-mipi		: boolean; port is used in MIPI-CSI1 mode (default: CCP2 mode)
- ti,phy-layer-is-strobe	: boolean; use data/strobe physical layer (default: data/clock physical layer)
- ti,data-lane-configuration	: integer array with position and polarity information for lane 1 and 2
- ti,clock-lane-configuration	: integer array with position and polarity information for clock lane

parallel-bus-cfg subnode
------------------------

Required properties:
- ti,data-lane-shift				: integer; shift data lanes by this amount

Optional properties:
- ti,clock-falling-edge				: boolean; sample on falling edge (default: rising edge)
- ti,horizontal-synchronization-active-low	: boolean; default: active high
- ti,vertical-synchronization-active-low	: boolean; default: active high
- ti,data-polarity-ones-complement		: boolean; data polarity is one's complement

csi2-bus-cfg subnode
--------------------

Required properties:
- ti,video-port-clock-divisor	: integer; used for video port output clock control

Optional properties:
- ti,data-lane-configuration	: integer array with position and polarity information for lane 1 and 2
- ti,clock-lane-configuration	: integer array with position and polarity information for clock lane
- ti,enable-crc			: boolean; enable crc checking

Example for Nokia N900
----------------------

omap3isp: isp@480BC000 {
	compatible = "ti,omap3isp";
	reg = <
		/* OMAP3430+ */
		0x480BC000 0x070	/* base */
		0x480BC100 0x078	/* cbuf */
		0x480BC400 0x1F0 	/* cpp2 */
		0x480BC600 0x0A8	/* ccdc */
		0x480BCA00 0x048	/* hist */
		0x480BCC00 0x060	/* h3a  */
		0x480BCE00 0x0A0	/* prev */
		0x480BD000 0x0AC	/* resz */
		0x480BD200 0x0FC	/* sbl  */
		0x480BD400 0x070	/* mmu  */
	>;

	clocks = < &cam_ick &cam_mclk &csi2_96m_fck &l3_ick >;
	clock-names = "cam_ick", "cam_mclk", "csi2_96m_fck", "l3_ick";

	interrupts = <24>;

	ti,iommu = <&mmu_isp>;

	ti,isp-xclk-1 = <
		&et8ek8
		&smiapp_dfl
	>;

	group1: device-group@0 {
		ti,isp-interface-type = <2>;

		ti,isp-devices = <
			&et8ek8
			&ad5820
			&adp1653
		>;

		ti,ccp2-bus-cfg {
			ti,enable-crc;
			ti,phy-layer-is-strobe;
			ti,video-port-clock-divisor = <1>;
		};
	};

	group2: device-group@1 {
		ti,isp-interface-type = <2>;

		ti,isp-devices = <
			&smiapp_dfl
		>;

		ti,ccp2-bus-cfg {
			ti,enable-crc;
			ti,phy-layer-is-strobe;
			ti,video-port-clock-divisor = <1>;
		};
	};
};

--mYCpIKhGyMATD0i+
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.15 (GNU/Linux)

iQIcBAEBCAAGBQJSdsgjAAoJENju1/PIO/qafpMP/jOXdgXl+zA65bgciO8avCi+
054BddL+YKj0gpFg5VUQEfvHhTVOrTzlDkXFsdutXXyhCkXuINX3X9F1ckywpJKn
7a+cfkxWugBmknYRKVAU8BQKksmziuZQGKiA/7dTFMxSuAT32v+kJSG6YBanjbPj
sABfMZW/cxTcgWyNG947Le+LiiCJpgvERSSSHzVJ6wY+CuaqDGFwVtYpwO0KultY
ny18AbUYCFQXiQ4+TfScHeg4gsB9UAXoJvz+HCP6GSV3iZ84SVcrLv7hf/GlwkYB
vT0GBdCKPdjrx3K2Zr210D3J0kkoCHIqqojYhUs18rACEEh2O/8bmyIn5mEqlzSW
Ypz04NBg3XzuGLdd1PN9IMDPegyEF/WOvRhTEaE58aOQxo3rqdhS1T6B8HMSxTIl
SCRNf9M10sw2cOu6aBOYPtwMusytaprTltlovzIY3TCedwnkjTYtWzqXG8qv8a6U
w7e9zftF34p1HiRWx1IQG/Ue+TKEmA4EkLC81GAA6kCy2oQcdAXqLaq0X1PCwFor
e5Cf7jHjrVGVM/RjwrgffrUkEDMMDCArTH+0Kgh5EO1fgHD1BzSvow8QCJaijStB
sj1qDpbA2Xb83Gn72s7kQQifHoMdGp4USlamkEbxvQax9QUbZkqZpCTThet/Sl/z
7t9syETUyJXR5rlMafGp
=TBRJ
-----END PGP SIGNATURE-----

--mYCpIKhGyMATD0i+--
