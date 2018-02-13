Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.free-electrons.com ([62.4.15.54]:60104 "EHLO
        mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S965091AbeBMRFp (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 13 Feb 2018 12:05:45 -0500
Date: Tue, 13 Feb 2018 18:05:43 +0100
From: Maxime Ripard <maxime.ripard@bootlin.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Rob Herring <robh+dt@kernel.org>, linux-media@vger.kernel.org,
        devicetree@vger.kernel.org, Richard Sproul <sproul@cadence.com>,
        Alan Douglas <adouglas@cadence.com>,
        Steve Creaney <screaney@cadence.com>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Boris Brezillon <boris.brezillon@bootlin.com>,
        Niklas =?iso-8859-1?Q?S=F6derlund?=
        <niklas.soderlund@ragnatech.se>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Benoit Parrot <bparrot@ti.com>, nm@ti.com,
        Simon Hatliff <hatliff@cadence.com>
Subject: Re: [PATCH v3 2/2] v4l: cadence: Add Cadence MIPI-CSI2 TX driver
Message-ID: <20180213170543.cj4n2deyn2rqbixh@flea.lan>
References: <20180207142643.15746-1-maxime.ripard@bootlin.com>
 <20180207142643.15746-3-maxime.ripard@bootlin.com>
 <5149915.u4chh53YoO@avalon>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="kwq3qdy3pmt5hjhl"
Content-Disposition: inline
In-Reply-To: <5149915.u4chh53YoO@avalon>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--kwq3qdy3pmt5hjhl
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Laurent,

On Thu, Feb 08, 2018 at 10:05:05PM +0200, Laurent Pinchart wrote:
> On Wednesday, 7 February 2018 16:26:43 EET Maxime Ripard wrote:
> > The Cadence MIPI-CSI2 TX controller is an hardware block meant to be us=
ed
> > as a bridge between pixel interfaces and a CSI-2 bus.
> >=20
> > It supports operating with an internal or external D-PHY, with up to 4
> > lanes, or without any D-PHY. The current code only supports the former
> > case.
> >=20
> > While the virtual channel input on the pixel interface can be directly
> > mapped to CSI2, the datatype input is actually a selection signal (3-bi=
ts)
> > mapping to a table of up to 8 preconfigured datatypes/formats (programm=
ed
> > at start-up)
> >=20
> > The block supports up to 8 input datatypes.
>=20
> The DT bindings document four input streams. Does this mean that, to use =
more=20
> than 4 data types, a system would need to transmit multiplexed streams on=
 a=20
> single input stream with the 3 selection bits qualifying each sample ? Th=
at=20
> would be an interesting setup.

My understanding is that each input stream has an additional signal
that defines a data type encoded on 3 bits. So yeah, I guess that
would be possible if the upstream device is able to synchronize its
stream generation and the datatype sent.

> > Signed-off-by: Maxime Ripard <maxime.ripard@bootlin.com>
> > ---
> >  drivers/media/platform/cadence/Kconfig       |   6 +
> >  drivers/media/platform/cadence/Makefile      |   1 +
> >  drivers/media/platform/cadence/cdns-csi2tx.c | 582 +++++++++++++++++++=
+++++
> >  3 files changed, 589 insertions(+)
> >  create mode 100644 drivers/media/platform/cadence/cdns-csi2tx.c
> >=20
> > diff --git a/drivers/media/platform/cadence/Kconfig
> > b/drivers/media/platform/cadence/Kconfig index d1b6bbb6a0eb..db49328ee8=
b2
> > 100644
> > --- a/drivers/media/platform/cadence/Kconfig
> > +++ b/drivers/media/platform/cadence/Kconfig
> > @@ -9,4 +9,10 @@ config VIDEO_CADENCE_CSI2RX
> >  	depends on VIDEO_V4L2_SUBDEV_API
> >  	select V4L2_FWNODE
> >=20
> > +config VIDEO_CADENCE_CSI2TX
> > +	tristate "Cadence MIPI-CSI2 TX Controller"
> > +	depends on MEDIA_CONTROLLER
> > +	depends on VIDEO_V4L2_SUBDEV_API
> > +	select V4L2_FWNODE
>=20
> A bit of documentation maybe ?

Yeah, it was already queued for the next iteration :)

> > +static const struct v4l2_mbus_framefmt fmt_default =3D {
> > +	.width		=3D 320,
> > +	.height		=3D 180,
>=20
> That's a pretty small default resolution. Is there any reason for not usi=
ng a=20
> more common format ?

What would be your suggestion?

> > +static int csi2tx_init_cfg(struct v4l2_subdev *subdev,
> > +			   struct v4l2_subdev_pad_config *cfg)
> > +{
> > +	struct csi2tx_priv *csi2tx =3D v4l2_subdev_to_csi2tx(subdev);
> > +	unsigned int i;
> > +
> > +	for (i =3D 0; i < subdev->entity.num_pads; i++)
> > +		csi2tx->pad_fmts[i] =3D fmt_default;
>=20
> .init_cfg() should initialize the formats stored in the cfg structure. Th=
e=20
> active formats stored in your driver-specific structure should be initial=
ized=20
> at probe time.

Ok, I'll change it.

> > +static int csi2tx_set_pad_format(struct v4l2_subdev *subdev,
> > +				 struct v4l2_subdev_pad_config *cfg,
> > +				 struct v4l2_subdev_format *fmt)
> > +{
> > +	struct csi2tx_priv *csi2tx =3D v4l2_subdev_to_csi2tx(subdev);
> > +
> > +	csi2tx->pad_fmts[fmt->pad] =3D fmt->format;
>=20
> Doesn't the IP have frame width or height limitations ? Or format
> limitations ?

In its current state, not really. There's also no clear limitations
=66rom the registers on the formats / resolution used, since it's not
configured at all in the device.

The only constraint is that there's no buffer in the IP, so the input
data rate and the output data rate should match. However, the way to
do that is currently uncertain, so I guess we can address that later
on.

> > +static void csi2tx_reset(struct csi2tx_priv *csi2tx)
> > +{
> > +	writel(CSI2TX_CONFIG_SRST_REQ, csi2tx->base + CSI2TX_CONFIG_REG);
> > +
> > +	usleep_range(10, 20);
>=20
> As for the RX driver, udelay() might be better. Same comment for the othe=
r=20
> small delays below.

I was asked by Benoit to change it to usleep_range in an earlier
iteration, which one should I use?

I'll change the driver according to your other comments.
Thanks!
Maxime

--=20
Maxime Ripard, Bootlin (formerly Free Electrons)
Embedded Linux and Kernel engineering
http://bootlin.com

--kwq3qdy3pmt5hjhl
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEE0VqZU19dR2zEVaqr0rTAlCFNr3QFAlqDGuIACgkQ0rTAlCFN
r3SRBA/+Jw6l94Ppm+jCLXSr+yctG7JdlY0Of24MCh871CYGD+eSw9zX7Ku5DA8n
p8cYkTO5zL+gbOVocqPs1uVKb0dr/kLiHsroulg4auGcY/eNUAu2dQ5k5fMzugo1
cxsyr8qFnthEfF9dkpcwwoEtEpX27egU+4YqvDU0yGhQ836HEw4c9QQU1Vl5K+Em
Bx1vpxpvUDE1pk/yvmplIAT52V3kMg6AQdcz40wnhMtW2+zGfOWZHC3eEnNK72pc
q5RQo74i2oDMRVZvvQuxolh3Wz+CLxIDd6Ti8YOz40hfc6fMKF/EPMU5FST//JEn
0HfVtekGrUjMn6qfXGPNhgFh48jXlECRC01T04Im7a4KWpdZ8kk2l3BpUHTqGQaG
W2qEGsN9CWxFjzrQ6wV88r8EhXnTIUFlafrO0IlXQrdro1xRqjWAPL02fsZ0FE7c
gigN+mJaySSYOsCbME22004B+QEsBS2SGhvDjwAC28yxGYEo0LOv5okar3+47zhb
KpPPIo1GmS/bt0PB1eFcsggtjzbdcAyeAK6lQOqMPsGLAlpSW/N0RgWvvgmQSOYQ
t9Ndre2g90ZVChZ1u3sEz5RJiA+LgyH0Fv1ISfam1Q2ObBqRrvgdw0q/3F8r7QRf
15XwWNSo+V59Gt3HoUjKF5L2Z379ja+lJtNgAI1zRv9byGPV2Q0=
=FFYx
-----END PGP SIGNATURE-----

--kwq3qdy3pmt5hjhl--
