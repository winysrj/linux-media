Return-path: <linux-media-owner@vger.kernel.org>
Received: from ring0.de ([91.143.88.219]:40313 "EHLO smtp.ring0.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753497AbaATX13 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 20 Jan 2014 18:27:29 -0500
Date: Tue, 21 Jan 2014 00:27:21 +0100
From: Sebastian Reichel <sre@debian.org>
To: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
Cc: Sakari Ailus <sakari.ailus@iki.fi>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	linux-media@vger.kernel.org, devicetree@vger.kernel.org,
	Rob Herring <rob.herring@calxeda.com>,
	Pawel Moll <pawel.moll@arm.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Ian Campbell <ijc+devicetree@hellion.org.uk>
Subject: Re: [RFCv2] Device Tree bindings for OMAP3 Camera System
Message-ID: <20140120232719.GA30894@earth.universe>
References: <20131103220315.GA11659@earth.universe>
 <20140115194127.GA30988@earth.universe>
 <20140120041904.GH9997@valkosipuli.retiisi.org.uk>
 <52DDA04B.90809@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="45Z9DzgjV8m4Oswq"
Content-Disposition: inline
In-Reply-To: <52DDA04B.90809@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--45Z9DzgjV8m4Oswq
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Mon, Jan 20, 2014 at 11:16:43PM +0100, Sylwester Nawrocki wrote:
> On 01/20/2014 05:19 AM, Sakari Ailus wrote:
> >I've also been working on this (besides others); what I have however are
> >mostly experimental patches. [...]

Thanks. I will have a look at it.

> [...]
> >
> >Over 80 characters per line.

Will be fixed in the next revision.

> >>can be found in Documentation/devicetree/bindings/media/video-interface=
s.txt
> >>
> >>omap3isp node
> >>-------------
> >>
> >>Required properties:
> >>
> >>- compatible    : should be "ti,omap3isp" for OMAP3.
> >>- reg       : physical addresses and length of the registers set.
> >>- clocks    : list of clock specifiers, corresponding to entries in
> >>           clock-names property.
> >>- clock-names   : must contain "cam_ick", "cam_mclk", "csi2_96m_fck",
> >>           "l3_ick" entries, matching entries in the clocks property.
> >>- interrupts    : must contain mmu interrupt.
> >>- ti,iommu  : phandle to isp mmu.
> >
> >Is the TI specific? I'd assume not. Hiroshi's patches assume that
> >at least.

I did not see any iommu standard in Documentation/devicetree/bindings,
so I added the vendor prefix, for now. I don't have strong feelings for
this. I saw you used iommus instead, which sounds reasonable for me.

> >>- #address-cells: Should be set to<1>.
> >>- #size-cells   : Should be set to<0>.
> >
> >The ISP also exports clocks. Shouldn't you add
> >
> >#clock-cells =3D<1>;

Ok. I already though about that possibility, but wasn't sure which
way is the cleaner one. Thanks for clarifying.

> [...]
>=20
> This doesn't seem to follow the common clock bindings.

I think it does follow common clock bindings at least. Clocks can
referenced with the following statement:

camera-sensor-0 {
    clocks =3D <&isp_xclk1>;
    clock-names =3D ...
};

> Instead, you could define value of #clock-cells to be 1 and allow clocks
> consumers to reference the provider node in a standard way, e.g.:

This also works and probably better. I will merge clock provider
into the main omap3isp node.

> [...]
> >>endpoint subnode for serial interfaces
> >>--------------------------------------
> >>
> >>Required properties:
> >>  - ti,isp-interface-type    : should be one of the following values
> >
> >I think the interface type should be standardised at V4L2 level. We
> >currently do not do that, but instead do a little bit of guessing.
>=20
> I'm all for such a standard property. It seems much more clear to use such
> a property. And I already run into issues with deriving the bus interface
> type from existing properties, please see https://linuxtv.org/patch/19937
>=20
> I assume it would be fine to add a string type property like
> "interface-type"
> or "bus-type".
>=20
> >>   *<0>  to use the phy in CSI mode
> >>   *<1>  to use the phy in CCP mode
> >>   *<2>  to use the phy in CCP mode, but configured for MIPI CSI2

mh... from what I understand a port can be configured to be either
CSI2 or CPP2 type. If CCP2 type is chosen the port can be configured
to be CSI1 mode instead of actually being CPP2. See

see "struct isp_ccp2_platform_data" in include/media/omap3isp.h.

But actually I made a typo above. This is what I meant:

*<0>  to use the phy in MIPI CSI2 mode
*<1>  to use the phy in SMIA CCP2 mode
*<2>  to use the phy in SMIA CCP2 mode, but configured for MIPI CSI1

I'm not sure if this can be properly be described in a standardized
type property.

> >Hmm. I'm not entirely sure what does this last option mean. I could be
> >forgetting something, though.

I hope the above description helped.

> >>  - ti,isp-clock-divisor     : integer used for configuration of the
> >>                   video port output clock control.
> >>
> >>Optional properties:
> >>  - ti,disable-crc       : boolean, which disables crc checking.
> >
> >I think crc should be standardised as well.
>
> Definitely something we should have a common definition for.

ok.

> >>  - ti,strobe-mode       : boolean, which setups data/strobe physical
> >>                   layer instead of data/clock physical layer.
> >>  - pclk-sample          : integer describing if clk should be interpre=
ted on
> >>                   rising (<1>) or falling edge (<0>). Default is<1>.
> >
> >I see different values on the N9 platform data for CCP2 and CSI2 (front =
and
> >back camera). I'm not sure the bus type is related to this or not.

Not sure, what you mean here.

I merged (isp_ccp2_platform_data.phy_layer) into the bus-type
property described above.

> >>- data-lanes: an array of physical data lane indexes. Position of an en=
try
> >>   determines the logical lane number, while the value of an entry indi=
cates
> >>   physical lane, e.g. for 2-lane MIPI CSI-2 bus we could have
> >>   "data-lanes =3D<1 2>;", assuming the clock lane is on hardware lane =
0.
> >>   This property is valid for serial busses only (e.g. MIPI CSI-2).
> >>- clock-lanes: an array of physical clock lane indexes. Position of an =
entry
> >>   determines the logical lane number, while the value of an entry indi=
cates
> >>   physical lane, e.g. for a MIPI CSI-2 bus we could have "clock-lanes =
=3D<0>;",
> >>   which places the clock lane on hardware lane 0. This property is val=
id for
> >>   serial busses only (e.g. MIPI CSI-2). Note that for the MIPI CSI-2 b=
us this
> >>   array contains only one entry.
> >
> >I'd rather refer to
> >Documentation/devicetree/bindings/media/video-interfaces.txt than copy f=
rom
> >it. It's important that there's a single definition for the standard
> >properties. Just mentioning the property by name should be enough. What =
do
> >you think?
>=20
> +1

sounds fine to me. Something like this?

- data-lanes: see [0]
- clock-lanes: see [0]

[0] Documentation/devicetree/bindings/media/video-interfaces.txt

> >>Example for Nokia N900
> >>----------------------
> >>
> >>omap3isp: isp@480BC000 {
> >>     compatible =3D "ti,omap3isp";
> >>     reg =3D<0x480BC000 0x070>, /* base */
> >>         <0x480BC100 0x078>, /* cbuf */
> >>         <0x480BC400 0x1F0>, /* cpp2 */
> >>         <0x480BC600 0x0A8>, /* ccdc */
> >>         <0x480BCA00 0x048>, /* hist */
> >>         <0x480BCC00 0x060>, /* h3a  */
> >>         <0x480BCE00 0x0A0>, /* prev */
> >>         <0x480BD000 0x0AC>, /* resz */
> >>         <0x480BD200 0x0FC>, /* sbl  */
> >>         <0x480BD400 0x070>; /* mmu  */
> >
> >Mmu is a separate device. (Please see my patches.)

Ok.

I simply took over the memory ranges currently defined in the
omap3isp driver.

> >>     clocks =3D<&cam_ick>,
> >>          <&cam_mclk>,
> >>          <&csi2_96m_fck>,
> >>          <&l3_ick>;
> >>     clock-names =3D "cam_ick",
> >>               "cam_mclk",
> >>               "csi2_96m_fck",
> >>               "l3_ick";
> >>
> >>     interrupts =3D<24>;
> >>
> >>     ti,iommu =3D<&mmu_isp>;
>=20
>=20
> >>     isp_xclk1: isp-xclk@0 {
> >>         compatible =3D "ti,omap3-isp-xclk";
> >>         reg =3D<0>;
> >>         #clock-cells =3D<0>;
> >>     };
> >>
> >>     isp_xclk2: isp-xclk@1 {
> >>         compatible =3D "ti,omap3-isp-xclk";
> >>         reg =3D<1>;
> >>         #clock-cells =3D<0>;
> >>     };
>=20
> I think these whole 2 nodes could be omitted...
>=20
> >>     #address-cells =3D<1>;
> >>     #size-cells =3D<0>;
>=20
> .. if you add here:
>=20
> 	#clock-cells =3D<1>;

will do.

> >>     port@0 {
> >>         reg =3D<0>;
> >>
> >>         /* parallel interface is not used on Nokia N900 */
> >>         parallel_ep: endpoint {};
> >>     };
> >>
> >>     port@1 {
> >>         reg =3D<1>;
> >>
> >>         csi1_ep: endpoint {
> >>             remote-endpoint =3D<&switch_in>;
> >>             ti,isp-clock-divisor =3D<1>;
> >>             ti,strobe-mode;
> >>         };
> >>     }
> >>
> >>     port@2 {
> >>         reg =3D<2>;
> >>
> >>         /* second serial interface is not used on Nokia N900 */
> >>         csi2_ep: endpoint {};
> >>     }
> >>};
> >>
> >>camera-switch {
> >>     /*
> >>      * TODO:
> >>      *  - check if the switching code is generic enough to use a
> >>      *    more generic name like "gpio-camera-switch".
> >>      *  - document the camera-switch binding
> >>      */
> >>     compatible =3D "nokia,n900-camera-switch";
> >
> >Indeed. I don't think the hardware engineers realised what kind of a long
> >standing issue they created for us when they chose that solution. ;)
> >
> >Writing a small driver for this that exports a sub-device would probably=
 be
> >the best option as this is hardly very generic. Should this be shown to =
the
> >user space or not? Probably it'd be nice to avoid showing the related su=
b-device
> >if there would be one.
>
> Probably we should avoid exposing such a hardware detail to user space.
> OTOH it would be easy to handle as a media entity through the media
> controller API.

If this is exposed to the userspace, then a userspace application
"knows", that it cannot use both cameras at the same time. Otherwise
it can just react to error messages when it tries to use the second
camera.

> >I'm still trying to get N9 support working first, the drivers are in a
> >better shape and there are no such hardware hacks.
> >
> >>     gpios =3D<&gpio4 1>; /* 97 */
>=20
> I think the binding should be defining how state of the GPIO corresponds
> to state of the mux.

Obviously it should be mentioned in the n900-camera-switch binding
Documentation. This document was just the proposal for the omap3isp
node :)

> >>     port@0 {
> >>         switch_in: endpoint {
> >>             remote-endpoint =3D<&csi1_ep>;
> >>         };
> >>
> >>         switch_out1: endpoint {
> >>             remote-endpoint =3D<&et8ek8>;
> >>         };
> >>
> >>         switch_out2: endpoint {
> >>             remote-endpoint =3D<&smiapp_dfl>;
> >>         };
> >>     };
>=20
> This won't work, since names of the nodes are identical they will be
> combined
> by the dtc into a single 'endpoint' node with single
> 'remote-endpoint' property
> - might not be exactly something that you want.
> So it could be rewritten like:

right.

> [...]
> However, simplifying a bit, the 'endpoint' nodes are supposed to describe
> the configuration of a bus interface (port) for a specific remote device.
> Then what you need might be something like:
>=20
>  camera-switch {
> 	compatible =3D "nokia,n900-camera-switch";
>=20
> 	#address-cells =3D <1>;
> 	#size-cells =3D <0>;
>=20
> 	switch_in: port@0 {
> 		reg =3D <0>;
> 		endpoint {
> 			remote-endpoint =3D<&csi1_ep>;
> 		};
> 	};
>=20
>         switch_out1: port@1 {
> 		reg =3D <1>;
> 		endpoint {
> 			remote-endpoint =3D<&et8ek8>;
> 		};
> 	};
>=20
> 	switch_out2: port@2 {
> 		endpoint {
> 			reg =3D <2>;
> 			remote-endpoint =3D<&smiapp_dfl>;
> 		};
> 	};
>  };

sounds fine to me.

> I'm just wondering if we need to be describing this in DT in such
> detail.

Do you have an alternative suggestion for the N900's bus switch
hack?

-- Sebastian

--45Z9DzgjV8m4Oswq
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBCAAGBQJS3bDXAAoJENju1/PIO/qalBUP/RMZB9HIUlZt9Wy8OteH+bT6
XMS/QKnLWuFNUhJ4vqQvMiZSH1Noi0+5u4QRKTUSAW0jiAXJCZqa4mqnZTHOfhaH
7WQPY9EE/79RQvs1Dsrmi0Wn581zA7wWoz/UJVGmGUz0CezmATw7u+Ok3S7YA/01
lKt3zrUdtU7Jw7BPuytNA0KoJU2wusQ21TDhYWUAS/sbbE4yrM/GQcVG8BflmnfQ
eliPJF6aWYa8kUFLO0L9kI08Q2708YtxgcXthWxYelZBcVsmQUakcOf9C3mlvK+Q
QqfhvDzOhN1glM3HEoxGgDcRWqEhpB8C7L9rw3Kxo42kSjum3rChh/diKoyMJ3jk
zlWQYExxhmoo0UvRmAWILwG5YZEdoUht6igzyRD1gb0YWkIO51beN6g4YDDKzjpe
4qGRmts6wNo2wGxIioEnmgzRN0SBPCd0c92uHjpKTXemEVv5T9pYXx6xRBeHsq1b
35puCWPWoUeQZHNEoNKEZUIjM8rtzlJxrje29gJ1zFT+pXTQsE5QClPf8/RzJiER
dywdHDNyhAIhptzfEtgprkRltDxAz9Zw5ci258AohlxC/a90KmaGGD6lSm7XO++m
ALl8suX99loYkXnje3oxE5qkz+y1igs2fPb27Oeaw2D+iZV3DaejjZj0s9iCSgZk
Tzam0JLPL9WOISmE6p65
=B6XD
-----END PGP SIGNATURE-----

--45Z9DzgjV8m4Oswq--
