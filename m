Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.bootlin.com ([62.4.15.54]:35544 "EHLO mail.bootlin.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726369AbeK0V3d (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 27 Nov 2018 16:29:33 -0500
Date: Tue, 27 Nov 2018 11:31:06 +0100
From: Maxime Ripard <maxime.ripard@bootlin.com>
To: Jagan Teki <jagan@amarulasolutions.com>
Cc: Hans Verkuil <hans.verkuil@cisco.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        laurent.pinchart@ideasonboard.com,
        linux-media <linux-media@vger.kernel.org>, a.hajda@samsung.com,
        Chen-Yu Tsai <wens@csie.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        devicetree <devicetree@vger.kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Rob Herring <robh+dt@kernel.org>, frowand.list@gmail.com
Subject: Re: [PATCH 5/5] DO NOT MERGE: ARM: dts: bananapi: Add Camera support
Message-ID: <20181127103106.vykudp36vkyy5vme@flea>
References: <cover.71b0f9855c251f9dc389ee77ee6f0e1fad91fb0b.1542097288.git-series.maxime.ripard@bootlin.com>
 <12093630fdd7d8b43ebcb0340691e0f2200e26c6.1542097288.git-series.maxime.ripard@bootlin.com>
 <CAMty3ZBO6B=vgduv5u28zC8P1DOm1TYGFAVjDtJOpU8dozrk=A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="mwaf2j32zrljcsge"
Content-Disposition: inline
In-Reply-To: <CAMty3ZBO6B=vgduv5u28zC8P1DOm1TYGFAVjDtJOpU8dozrk=A@mail.gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--mwaf2j32zrljcsge
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Nov 27, 2018 at 12:26:09PM +0530, Jagan Teki wrote:
> On Tue, Nov 13, 2018 at 1:54 PM Maxime Ripard <maxime.ripard@bootlin.com>=
 wrote:
> >
> > Signed-off-by: Maxime Ripard <maxime.ripard@bootlin.com>
> > ---
> >  arch/arm/boot/dts/sun7i-a20-bananapi.dts | 98 ++++++++++++++++++++++++=
+-
> >  1 file changed, 98 insertions(+)
> >
> > diff --git a/arch/arm/boot/dts/sun7i-a20-bananapi.dts b/arch/arm/boot/d=
ts/sun7i-a20-bananapi.dts
> > index 70dfc4ac0bb5..18dbff9f1ce9 100644
> > --- a/arch/arm/boot/dts/sun7i-a20-bananapi.dts
> > +++ b/arch/arm/boot/dts/sun7i-a20-bananapi.dts
> > @@ -54,6 +54,9 @@
> >         compatible =3D "lemaker,bananapi", "allwinner,sun7i-a20";
> >
> >         aliases {
> > +               i2c0 =3D &i2c0;
> > +               i2c1 =3D &i2c1;
> > +               i2c2 =3D &i2c2;
> >                 serial0 =3D &uart0;
> >                 serial1 =3D &uart3;
> >                 serial2 =3D &uart7;
> > @@ -63,6 +66,41 @@
> >                 stdout-path =3D "serial0:115200n8";
> >         };
> >
> > +       reg_cam: cam {
> > +               compatible =3D "regulator-fixed";
> > +               regulator-name =3D "cam";
> > +               regulator-min-microvolt =3D <5000000>;
> > +               regulator-max-microvolt =3D <5000000>;
> > +               vin-supply =3D <&reg_vcc5v0>;
> > +               gpio =3D <&pio 7 16 GPIO_ACTIVE_HIGH>;
> > +               enable-active-high;
> > +               regulator-always-on;
> > +       };
> > +
> > +        reg_cam_avdd: cam-avdd {
> > +                compatible =3D "regulator-fixed";
> > +                regulator-name =3D "cam500b-avdd";
> > +                regulator-min-microvolt =3D <2800000>;
> > +                regulator-max-microvolt =3D <2800000>;
> > +                vin-supply =3D <&reg_cam>;
> > +        };
> > +
> > +        reg_cam_dovdd: cam-dovdd {
> > +                compatible =3D "regulator-fixed";
> > +                regulator-name =3D "cam500b-dovdd";
> > +                regulator-min-microvolt =3D <1800000>;
> > +                regulator-max-microvolt =3D <1800000>;
> > +                vin-supply =3D <&reg_cam>;
> > +        };
> > +
> > +        reg_cam_dvdd: cam-dvdd {
> > +                compatible =3D "regulator-fixed";
> > +                regulator-name =3D "cam500b-dvdd";
> > +                regulator-min-microvolt =3D <1500000>;
> > +                regulator-max-microvolt =3D <1500000>;
> > +                vin-supply =3D <&reg_cam>;
> > +        };
> > +
> >         hdmi-connector {
> >                 compatible =3D "hdmi-connector";
> >                 type =3D "a";
> > @@ -120,6 +158,27 @@
> >                 >;
> >  };
> >
> > +&csi0 {
> > +       pinctrl-names =3D "default";
> > +       pinctrl-0 =3D <&csi0_pins_a>;
> > +       status =3D "okay";
> > +
> > +       port {
> > +               #address-cells =3D <1>;
> > +               #size-cells =3D <0>;
> > +
> > +               csi_from_ov5640: endpoint {
> > +                        remote-endpoint =3D <&ov5640_to_csi>;
> > +                        bus-width =3D <8>;
> > +                        data-shift =3D <2>;
> > +                        hsync-active =3D <1>; /* Active high */
> > +                        vsync-active =3D <0>; /* Active low */
> > +                        data-active =3D <1>;  /* Active high */
> > +                        pclk-sample =3D <1>;  /* Rising */
> > +                };
> > +       };
> > +};
> > +
> >  &de {
> >         status =3D "okay";
> >  };
> > @@ -167,6 +226,39 @@
> >         };
> >  };
> >
> > +&i2c1 {
> > +       pinctrl-names =3D "default";
> > +       pinctrl-0 =3D <&i2c1_pins_a>;
> > +       status =3D "okay";
> > +
> > +       camera: camera@21 {
> > +               compatible =3D "ovti,ov5640";
> > +               reg =3D <0x21>;
> > +                clocks =3D <&ccu CLK_CSI0>;
> > +                clock-names =3D "xclk";
> > +               assigned-clocks =3D <&ccu CLK_CSI0>;
> > +               assigned-clock-rates =3D <24000000>;
> > +
> > +                reset-gpios =3D <&pio 7 14 GPIO_ACTIVE_LOW>;
> > +                powerdown-gpios =3D <&pio 7 19 GPIO_ACTIVE_HIGH>;
> > +                AVDD-supply =3D <&reg_cam_avdd>;
> > +                DOVDD-supply =3D <&reg_cam_dovdd>;
> > +                DVDD-supply =3D <&reg_cam_dvdd>;
> > +
> > +                port {
> > +                        ov5640_to_csi: endpoint {
> > +                                remote-endpoint =3D <&csi_from_ov5640>;
> > +                                bus-width =3D <8>;
> > +                                data-shift =3D <2>;
> > +                                hsync-active =3D <1>; /* Active high */
> > +                                vsync-active =3D <0>; /* Active low */
> > +                                data-active =3D <1>;  /* Active high */
> > +                                pclk-sample =3D <1>;  /* Rising */
> > +                        };
> > +                };
> > +       };
>=20
> Does ov5640 need any further patches, wrt linux-next? I'm trying to
> test this on top of linux-next but the slave id seems not detecting.
>=20
> [    2.304711] ov5640 1-0021: Linked as a consumer to regulator.5
> [    2.310639] ov5640 1-0021: Linked as a consumer to regulator.6
> [    2.316592] ov5640 1-0021: Linked as a consumer to regulator.4
> [    2.351540] ov5640 1-0021: ov5640_init_slave_id: failed with -6
> [    2.357543] ov5640 1-0021: Dropping the link to regulator.5
> [    2.363224] ov5640 1-0021: Dropping the link to regulator.6
> [    2.368829] ov5640 1-0021: Dropping the link to regulator.4
>=20
> Here is the full log [1], please let me know if I miss anything, I
> even tried to remove MCLK pin

You seem to have made local modifications to your tree, what are they?
This indicates that the communication over i2c doesn't work, what is
your setup?

Maxime

--=20
Maxime Ripard, Bootlin
Embedded Linux and Kernel engineering
https://bootlin.com

--mwaf2j32zrljcsge
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQRcEzekXsqa64kGDp7j7w1vZxhRxQUCW/0c6gAKCRDj7w1vZxhR
xdPkAP47Cz7G1Yps9F1YMfXGn1UocnEmP7KZe3329Fq28MwkbAD+NiXMTD4QZhCx
WPSXMTCFC6XcTEEPINbZJkVed+M1sgU=
=G4H5
-----END PGP SIGNATURE-----

--mwaf2j32zrljcsge--
