Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.bootlin.com ([62.4.15.54]:47512 "EHLO mail.bootlin.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726808AbeK1CSO (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 27 Nov 2018 21:18:14 -0500
Date: Tue, 27 Nov 2018 16:19:48 +0100
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
Message-ID: <20181127151948.gaqodlnkiuh3vkud@flea>
References: <cover.71b0f9855c251f9dc389ee77ee6f0e1fad91fb0b.1542097288.git-series.maxime.ripard@bootlin.com>
 <12093630fdd7d8b43ebcb0340691e0f2200e26c6.1542097288.git-series.maxime.ripard@bootlin.com>
 <CAMty3ZBO6B=vgduv5u28zC8P1DOm1TYGFAVjDtJOpU8dozrk=A@mail.gmail.com>
 <20181127103106.vykudp36vkyy5vme@flea>
 <CAMty3ZAhGAN2nEJkiRLHqFHz9Oi1WboiyqLL4ox+-0z7NhbG8w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="7kvhaimtko2tapu3"
Content-Disposition: inline
In-Reply-To: <CAMty3ZAhGAN2nEJkiRLHqFHz9Oi1WboiyqLL4ox+-0z7NhbG8w@mail.gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--7kvhaimtko2tapu3
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Nov 27, 2018 at 04:30:55PM +0530, Jagan Teki wrote:
> > > > +&i2c1 {
> > > > +       pinctrl-names =3D "default";
> > > > +       pinctrl-0 =3D <&i2c1_pins_a>;
> > > > +       status =3D "okay";
> > > > +
> > > > +       camera: camera@21 {
> > > > +               compatible =3D "ovti,ov5640";
> > > > +               reg =3D <0x21>;
> > > > +                clocks =3D <&ccu CLK_CSI0>;
> > > > +                clock-names =3D "xclk";
> > > > +               assigned-clocks =3D <&ccu CLK_CSI0>;
> > > > +               assigned-clock-rates =3D <24000000>;
> > > > +
> > > > +                reset-gpios =3D <&pio 7 14 GPIO_ACTIVE_LOW>;
> > > > +                powerdown-gpios =3D <&pio 7 19 GPIO_ACTIVE_HIGH>;
> > > > +                AVDD-supply =3D <&reg_cam_avdd>;
> > > > +                DOVDD-supply =3D <&reg_cam_dovdd>;
> > > > +                DVDD-supply =3D <&reg_cam_dvdd>;
> > > > +
> > > > +                port {
> > > > +                        ov5640_to_csi: endpoint {
> > > > +                                remote-endpoint =3D <&csi_from_ov5=
640>;
> > > > +                                bus-width =3D <8>;
> > > > +                                data-shift =3D <2>;
> > > > +                                hsync-active =3D <1>; /* Active hi=
gh */
> > > > +                                vsync-active =3D <0>; /* Active lo=
w */
> > > > +                                data-active =3D <1>;  /* Active hi=
gh */
> > > > +                                pclk-sample =3D <1>;  /* Rising */
> > > > +                        };
> > > > +                };
> > > > +       };
> > >
> > > Does ov5640 need any further patches, wrt linux-next? I'm trying to
> > > test this on top of linux-next but the slave id seems not detecting.
> > >
> > > [    2.304711] ov5640 1-0021: Linked as a consumer to regulator.5
> > > [    2.310639] ov5640 1-0021: Linked as a consumer to regulator.6
> > > [    2.316592] ov5640 1-0021: Linked as a consumer to regulator.4
> > > [    2.351540] ov5640 1-0021: ov5640_init_slave_id: failed with -6
> > > [    2.357543] ov5640 1-0021: Dropping the link to regulator.5
> > > [    2.363224] ov5640 1-0021: Dropping the link to regulator.6
> > > [    2.368829] ov5640 1-0021: Dropping the link to regulator.4
> > >
> > > Here is the full log [1], please let me know if I miss anything, I
> > > even tried to remove MCLK pin
> >
> > You seem to have made local modifications to your tree, what are they?
> > This indicates that the communication over i2c doesn't work, what is
> > your setup?
>=20
> I just used your commits on linux-next [2], with the setup similar in
> Page 5 on datasheet[3]. The only difference is csi build issue, I have
> updated similar fix you mentioned on sun6i_csi [4]
>=20
> [2] https://github.com/amarula/linux-amarula/commits/CSI-A20
> [3] https://www.tme.eu/gb/Document/187887186b98a8f78b47da2774a34f4c/BPI-C=
AMERA.pdf
> [4] https://github.com/amarula/linux-amarula/commit/a6762ecd38f000e2bd02d=
d255f6fd0c1ae755429#diff-0809a7f97ca58771c1cda186e73ec657

That branch doesn't have any commit with the same ID that you have in
your boot log.

Maxime

--=20
Maxime Ripard, Bootlin
Embedded Linux and Kernel engineering
https://bootlin.com

--7kvhaimtko2tapu3
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQRcEzekXsqa64kGDp7j7w1vZxhRxQUCW/1glAAKCRDj7w1vZxhR
xQPFAQCORfq8rEIh8lqEKA8obv0BQ2hSg0qXBI81KifgMKGiqgEAoIT3nDy7NRaQ
Cj/6IxkSTP4ZdQEtr4bfvhcqdn7aeAw=
=3CHx
-----END PGP SIGNATURE-----

--7kvhaimtko2tapu3--
