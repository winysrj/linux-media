Return-path: <linux-media-owner@vger.kernel.org>
Received: from ring0.de ([91.143.88.219]:43751 "EHLO smtp.ring0.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751473AbaAOTlh (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 15 Jan 2014 14:41:37 -0500
Date: Wed, 15 Jan 2014 20:41:28 +0100
From: Sebastian Reichel <sre@debian.org>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	linux-media@vger.kernel.org
Cc: devicetree@vger.kernel.org, Rob Herring <rob.herring@calxeda.com>,
	Pawel Moll <pawel.moll@arm.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Ian Campbell <ijc+devicetree@hellion.org.uk>
Subject: [RFCv2] Device Tree bindings for OMAP3 Camera System
Message-ID: <20140115194127.GA30988@earth.universe>
References: <20131103220315.GA11659@earth.universe>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="PEIAKu/WMn1b1Hv9"
Content-Disposition: inline
In-Reply-To: <20131103220315.GA11659@earth.universe>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--PEIAKu/WMn1b1Hv9
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

I finally found some time to update the proposed binding
documentation for omap3isp according to the comments on RFCv1.

Changes since v1:
 * Use common DT clock bindings to provide isp-xclk
 * Use common DT video-interface bindings to specify device connections
 * Apply style updates suggested by Mark Rutland
 * I renamed ti,enable-crc to ti,disable-crc, since I think its supposed
   to be used for remote hw adding broken crc values. I can't see other
   reasons for disabling it :)
 * I've kept the clocks the same for now. I think somebody else should look
   over them. Changing the actual referenced clocks / renaming them is just
   a small change and can be done at a later time in the omap3isp DT process
   IMHO.
 * I've kept the reg reference as a list for now, since that's how the
   omap3isp driver currently works and I can't see any disadvantages
   in making the memory segmentation visible in the DTS file.

So here is the proposed DT binding documentation:

Binding for the OMAP3 Camera subsystem with the image signal processor (ISP)
feature. The binding follows the common video-interfaces Device Tree bindin=
g,
so it is recommended to read the common binding description first. This des=
cription
can be found in Documentation/devicetree/bindings/media/video-interfaces.txt

omap3isp node
-------------

Required properties:

- compatible    : should be "ti,omap3isp" for OMAP3.
- reg       : physical addresses and length of the registers set.
- clocks    : list of clock specifiers, corresponding to entries in
          clock-names property.
- clock-names   : must contain "cam_ick", "cam_mclk", "csi2_96m_fck",
          "l3_ick" entries, matching entries in the clocks property.
- interrupts    : must contain mmu interrupt.
- ti,iommu  : phandle to isp mmu.
- #address-cells: Should be set to <1>.
- #size-cells   : Should be set to <0>.

Optional properties:

- vdd-csiphy1-supply    : regulator for csi phy1
- vdd-csiphy2-supply    : regulator for csi phy2

isp-xclk subnode
----------------

The omap3 ISP provides two external clocks, which are available as subnodes=
 of
the omap3isp node. Devices using one of these clock devices are supposed to=
 follow
the common Device Tree clock bindings described in

Documentation/devicetree/bindings/clock/clock-bindings.txt

Required properties:
 - compatible   : should contain "ti,omap3-cam-xclk"
 - reg      : should be set to
  * <0> for cam_xclka
  * <1> for cam_xclkb
 - #clock-cells : should be set to <0>

port subnode
------------

The omap3 ISP provides three different physical interfaces for camera
connections. Each of them is described using a port node.

Required properties:
 - reg : Should be set to one of the following values
   * <0> for the parallel interface (CPI)
   * <1> for the first serial interface (CSI1)
   * <2> for the second serial interface (CSI2)

endpoint subnode for parallel interface
---------------------------------------

The endpoint subnode describes the connection between the port and the remo=
te
camera device.

Required properties:
 - remote-endpoint  : phandle to remote device

Optional properties:
 - data-shift       : integer describing how far the data lanes are shifted.
 - pclk-sample      : integer describing if clk should be interpreted on
              rising (<1>) or falling edge (<0>). Default is <1>.
 - hsync-active     : integer describing if hsync is active high (<1>) or
              active low (<0>). Default is <1>.
 - vsync-active     : integer describing if vsync is active high (<1>) or
              active low (<0>). Default is <1>.
 - ti,data-ones-complement : boolean, describing that the data's polarity is
                 one's complement.

endpoint subnode for serial interfaces
--------------------------------------

Required properties:
 - ti,isp-interface-type    : should be one of the following values
  * <0> to use the phy in CSI mode
  * <1> to use the phy in CCP mode
  * <2> to use the phy in CCP mode, but configured for MIPI CSI2
 - ti,isp-clock-divisor     : integer used for configuration of the
                  video port output clock control.

Optional properties:
 - ti,disable-crc       : boolean, which disables crc checking.
 - ti,strobe-mode       : boolean, which setups data/strobe physical
                  layer instead of data/clock physical layer.
 - pclk-sample          : integer describing if clk should be interpreted on
                  rising (<1>) or falling edge (<0>). Default is <1>.
- data-lanes: an array of physical data lane indexes. Position of an entry
  determines the logical lane number, while the value of an entry indicates
  physical lane, e.g. for 2-lane MIPI CSI-2 bus we could have
  "data-lanes =3D <1 2>;", assuming the clock lane is on hardware lane 0.
  This property is valid for serial busses only (e.g. MIPI CSI-2).
- clock-lanes: an array of physical clock lane indexes. Position of an entry
  determines the logical lane number, while the value of an entry indicates
  physical lane, e.g. for a MIPI CSI-2 bus we could have "clock-lanes =3D <=
0>;",
  which places the clock lane on hardware lane 0. This property is valid for
  serial busses only (e.g. MIPI CSI-2). Note that for the MIPI CSI-2 bus th=
is
  array contains only one entry.

Example for Nokia N900
----------------------

omap3isp: isp@480BC000 {
    compatible =3D "ti,omap3isp";
    reg =3D   <0x480BC000 0x070>, /* base */
        <0x480BC100 0x078>, /* cbuf */
        <0x480BC400 0x1F0>, /* cpp2 */
        <0x480BC600 0x0A8>, /* ccdc */
        <0x480BCA00 0x048>, /* hist */
        <0x480BCC00 0x060>, /* h3a  */
        <0x480BCE00 0x0A0>, /* prev */
        <0x480BD000 0x0AC>, /* resz */
        <0x480BD200 0x0FC>, /* sbl  */
        <0x480BD400 0x070>; /* mmu  */

    clocks =3D <&cam_ick>,
         <&cam_mclk>,
         <&csi2_96m_fck>,
         <&l3_ick>;
    clock-names =3D "cam_ick",
              "cam_mclk",
              "csi2_96m_fck",
              "l3_ick";

    interrupts =3D <24>;

    ti,iommu =3D <&mmu_isp>;

    isp_xclk1: isp-xclk@0 {
        compatible =3D "ti,omap3-isp-xclk";
        reg =3D <0>;
        #clock-cells =3D <0>;
    };

    isp_xclk2: isp-xclk@1 {
        compatible =3D "ti,omap3-isp-xclk";
        reg =3D <1>;
        #clock-cells =3D <0>;
    };

    #address-cells =3D <1>;
    #size-cells =3D <0>;

    port@0 {
        reg =3D <0>;

        /* parallel interface is not used on Nokia N900 */
        parallel_ep: endpoint {};
    };

    port@1 {
        reg =3D <1>;

        csi1_ep: endpoint {
            remote-endpoint =3D <&switch_in>;
            ti,isp-clock-divisor =3D <1>;
            ti,strobe-mode;
        };
    }

    port@2 {
        reg =3D <2>;

        /* second serial interface is not used on Nokia N900 */
        csi2_ep: endpoint {};
    }
};

camera-switch {
    /*
     * TODO:=20
     *  - check if the switching code is generic enough to use a
     *    more generic name like "gpio-camera-switch".
     *  - document the camera-switch binding
     */
    compatible =3D "nokia,n900-camera-switch";

    gpios =3D <&gpio4 1>; /* 97 */

    port@0 {
        switch_in: endpoint {
            remote-endpoint =3D <&csi1_ep>;
        };

        switch_out1: endpoint {
            remote-endpoint =3D <&et8ek8>;
        };

        switch_out2: endpoint {
            remote-endpoint =3D <&smiapp_dfl>;
        };
    };
};

--PEIAKu/WMn1b1Hv9
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBCAAGBQJS1uRnAAoJENju1/PIO/qaQjoQAJWEoHr/IcIgbzZCXLVbPBWq
g80S5aEyv6GRvZ7uVmwk/atOrT6Zp+2ewEuC6zR7HU5sbun5Yr7Ry1huHJdtRMpF
bkuJsZIjX9MnfAj0i49c2YZrlTifjtsqSKsAPH3ks84Sv8QXUfh6/IBrlZLqNtbR
gzXiUc6neilY2IBi72+atiwRuTprF2Tul8xFCzqXu+mLfO0xdvHhfaTC/8QmW5e3
45HG/kqEkZ7wBU/fDBE5llIGJYYKlpsycJbTiW2eIaQrsvSmaYrZX8EZ+rnZIsgA
3on3Kjc2+vu/bRCyxEUf+SzRjfbv5HWgRPq5jIeFpGWkds1AW6YAE/WT6/2ifyRf
hkDTCbMhoQGFXctRQR+4M2Hgp5uaJrf4RWhbLgHBctLuooQWpdPLOnSFP84PaAD5
mzd5rIUtYsjo5RDy3nYXvn9uSOr2EX+4jVv9QILvBAOtljifdDQaFZw8939An9az
LcAwJWi2d1YOOOOoGbuH/DRZ3IN4VTbDBEQwHulnvaZJ00G334mV80Ep/tUlYC6X
Jg+QrgzSclTVVXUJ27UL9kF88d2UH1LkHSus1wDRJr5CF6jqR6NGbjKWA6uQp7xz
j5GVOr0U4YDbr4aDDnZYzNpZrf4iQdRcJzddL+xw4PpjQLEEkpes62e2LUpWHNss
azaxq0i+LdRsRIt/Wk5U
=528f
-----END PGP SIGNATURE-----

--PEIAKu/WMn1b1Hv9--
