Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.free-electrons.com ([62.4.15.54]:55681 "EHLO
        mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752843AbeBEN4k (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 5 Feb 2018 08:56:40 -0500
Date: Mon, 5 Feb 2018 14:56:38 +0100
From: Maxime Ripard <maxime.ripard@bootlin.com>
To: Fabrizio Castro <fabrizio.castro@bp.renesas.com>
Cc: Hugues Fruchet <hugues.fruchet@st.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        Benjamin Gaignard <benjamin.gaignard@linaro.org>,
        Ramesh Shanmugasundaram <ramesh.shanmugasundaram@bp.renesas.com>,
        Chris Paterson <Chris.Paterson2@renesas.com>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Sakari Ailus <sakari.ailus@iki.fi>,
        Steve Longerbeam <slongerbeam@gmail.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Rob Herring <robh+dt@kernel.org>
Subject: Re: [PATCH v5 4/5] media: ov5640: add support of DVP parallel
 interface
Message-ID: <20180205135638.vkuotmeks5k76iud@flea>
References: <1514973452-10464-1-git-send-email-hugues.fruchet@st.com>
 <1514973452-10464-5-git-send-email-hugues.fruchet@st.com>
 <TY1PR06MB089512437228BAFF910B133FC0FA0@TY1PR06MB0895.apcprd06.prod.outlook.com>
 <20180202185045.vvhmj5wtagalkucf@flea.lan>
 <TY1PR06MB08954787E362BF24C7FD41DBC0FE0@TY1PR06MB0895.apcprd06.prod.outlook.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="ilbt4aunkczvniud"
Content-Disposition: inline
In-Reply-To: <TY1PR06MB08954787E362BF24C7FD41DBC0FE0@TY1PR06MB0895.apcprd06.prod.outlook.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--ilbt4aunkczvniud
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Feb 05, 2018 at 11:42:11AM +0000, Fabrizio Castro wrote:
> Hello Maxime,
>=20
> thank you for your feedback.
>=20
> > > > +/*
> > > > + * configure parallel port control lines polarity
> > > > + *
> > > > + * POLARITY CTRL0
> > > > + * - [5]:PCLK polarity (0: active low, 1: active high)
> > > > + * - [1]:HREF polarity (0: active low, 1: active high)
> > > > + * - [0]:VSYNC polarity (mismatch here between
> > > > + *datasheet and hardware, 0 is active high
> > > > + *and 1 is active low...)
> > >
> > > I know that yourself and Maxime have both confirmed that VSYNC
> > > polarity is inverted, but I am looking at HSYNC and VSYNC with a
> > > logic analyser and I am dumping the values written to
> > > OV5640_REG_POLARITY_CTRL00 and to me it looks like that HSYNC is
> > > active HIGH when hsync_pol =3D=3D 0, and VSYNC is active HIGH when
> > > vsync_pol =3D=3D 1.
> >
> > Which mode are you testing this on?
>=20
> My testing environment is made of the sensor connected to a SoC with
> 8 data lines, vsync, hsync, and pclk, and of course I am specifying
> hsync-active, vsync-active, and pclk-sample in the device tree on
> both ends so that they configure themselves accordingly to work in
> DVP mode (V4L2_MBUS_PARALLEL), with the correct polarities.
>
> Between the sensor and the SoC there is a noninverting bus
> transceiver (voltage translator), for my experiments I have plugged
> myself onto the outputs of this transceiver only to be compliant
> with the voltage level of my logic analyser.

Sorry, my question was more about the resolution, refresh rate, etc.

> > The non-active periods are insanely high in most modes (1896 for an
> > active horizontal length of 640 in 640x480 for example), especially
> > hsync, and it's really easy to invert the two.
>=20
> I am looking at all the data lines, so that I don't confuse the
> non-active periods with the active periods, and with my setup what I
> reported is what I get. I wonder if this difference comes from the
> sensor revision at all? Unfortunately I can only test the one camera
> I have got.

I don't really know then. I've had issues with the polarities on my
side, but it was on the receiver side and the sensor part looked like
what is documented.

Maxime

--=20
Maxime Ripard, Bootlin (formerly Free Electrons)
Embedded Linux and Kernel engineering
http://bootlin.com

--ilbt4aunkczvniud
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEE0VqZU19dR2zEVaqr0rTAlCFNr3QFAlp4YpUACgkQ0rTAlCFN
r3TIWw//aGZ5MjQRoWi1F753l0C6BMtobEx8utifF5v9IRwekB3R/TIjllXdXwXO
Ev4qj21YrO1SjanFk6UTccJ/tqa9v0/cLJ9LCOc1Og+psBJgSBOtDVUyV8U7lTrf
8Ta9YtZmEBuLb8CHPcRKZozkBta3E23wO8xD3nGnLKN0In5knglZFmGgJTNbzAlM
5vCmBOBXeflcYWY2CpqAAbR86cNGPaPDI5KZLGysPHEBOU66CdJ1ykUOSEGtJJhV
Q2O4NqbbL2Xm80woP34EGgNvov7etZuorvQbdhVTbRWsP8cMPkcSWpSJLxjSNpf/
qe5L1fQwjZqNmVGXq5ZIJKUDUumH3hGWHWgnQCvaImU17aXeR9UUG8djhNdxNP3v
syxUNzszOrC63zjSqPXTDNx/UzDtTbXKakal9kKByW1ijFeaL1LVNj6M04BljA1J
51Rl+7wGTxTSm4bD1qUcmmbi8rkaF2rxN6IInZ4urp9ACuuFTy1+P7F9TnEsM+70
GOvxqvX9vL4ZZV3q6qi6GyfATiQLmD5gDLodwvpAfrI3xr3qctalThzg0NsaEKU6
xCRlpDm/fm2W5ch4fqSUsXfbcmGSEM6JXXFTcBrdP72GcTwyAbH7xbjc4fXimoU3
1XpdEMTCENFSX6XBANExQLmZlYlJsKB8RvOvm5WjXt4e+DP9yFM=
=wUfz
-----END PGP SIGNATURE-----

--ilbt4aunkczvniud--
