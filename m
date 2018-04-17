Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.bootlin.com ([62.4.15.54]:36952 "EHLO mail.bootlin.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751836AbeDQP7s (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 17 Apr 2018 11:59:48 -0400
Date: Tue, 17 Apr 2018 17:59:47 +0200
From: Maxime Ripard <maxime.ripard@bootlin.com>
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Rob Herring <robh+dt@kernel.org>,
        Frank Rowand <frowand.list@gmail.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        linux-media@vger.kernel.org, devicetree@vger.kernel.org,
        Richard Sproul <sproul@cadence.com>,
        Alan Douglas <adouglas@cadence.com>,
        Steve Creaney <screaney@cadence.com>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Boris Brezillon <boris.brezillon@bootlin.com>,
        Niklas =?utf-8?Q?S=C3=B6derlund?= <niklas.soderlund@ragnatech.se>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Benoit Parrot <bparrot@ti.com>, nm@ti.com,
        Simon Hatliff <hatliff@cadence.com>
Subject: Re: [PATCH v8 2/2] v4l: cadence: Add Cadence MIPI-CSI2 TX driver
Message-ID: <20180417155947.5hv74hbpmtfzv32l@flea>
References: <20180404122025.8726-1-maxime.ripard@bootlin.com>
 <20180404122025.8726-3-maxime.ripard@bootlin.com>
 <20180413121437.slsv2ef2j5k2aihw@valkosipuli.retiisi.org.uk>
 <20180417131024.kc6smxh4mbd44nst@flea>
 <20180417132010.zhr3nrigeqzeorg3@valkosipuli.retiisi.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="g5bnsscojaeep5gk"
Content-Disposition: inline
In-Reply-To: <20180417132010.zhr3nrigeqzeorg3@valkosipuli.retiisi.org.uk>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--g5bnsscojaeep5gk
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Apr 17, 2018 at 04:20:10PM +0300, Sakari Ailus wrote:
> On Tue, Apr 17, 2018 at 03:10:24PM +0200, Maxime Ripard wrote:
> > Hi Sakari,
> >=20
> > On Fri, Apr 13, 2018 at 03:14:37PM +0300, Sakari Ailus wrote:
> > > > +static int csi2tx_set_pad_format(struct v4l2_subdev *subdev,
> > > > +				 struct v4l2_subdev_pad_config *cfg,
> > > > +				 struct v4l2_subdev_format *fmt)
> > > > +{
> > > > +	struct csi2tx_priv *csi2tx =3D v4l2_subdev_to_csi2tx(subdev);
> > > > +
> > > > +	if (fmt->pad >=3D CSI2TX_PAD_MAX)
> > > > +		return -EINVAL;
> > > > +
> > > > +	csi2tx->pad_fmts[fmt->pad] =3D fmt->format;
> > >=20
> > > Have I asked previously if there are any limitations with this?
> > >=20
> > > The CSI-2 TX link has multiple formats so I wouldn't support formats =
on
> > > that pad in order to be compatible with the planned VC/data type supp=
ort
> > > patchset. Or do you see issues with that?
> >=20
> > It's not just about the CSI-2 link, but more about the input pads as
> > well, that can be configured (and we need to know the format in order
> > to configure the IP properly).
> >=20
> > Maybe we can simply prevent the format change on the CSI-2 pad, but
> > not the others?
>=20
> Yes, that was what I wanted to suggest. It's in line with the intended way
> to support multiplexed pads.
>=20
> The latest set is here:
>=20
> <URL:https://git.linuxtv.org/sailus/media_tree.git/log/?h=3Dvc>

Thanks for the pointer.

I've looked at the smiapp set_format hook, and especially:
https://git.linuxtv.org/sailus/media_tree.git/tree/drivers/media/i2c/smiapp=
/smiapp-core.c?h=3Dvc&id=3Dcb864a1d8e2d19b793d8f550b026dcf8d2f78f11#n1817

After reading this, I'm not quite sure to get what I should do for the
CSI-2 pad. Should I ignore all formats change (and thus return 0), or
should I return EINVAL (which would probably be a bit confusing to the
userspace)?

Maxime

--=20
Maxime Ripard, Bootlin (formerly Free Electrons)
Embedded Linux and Kernel engineering
https://bootlin.com

--g5bnsscojaeep5gk
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEE0VqZU19dR2zEVaqr0rTAlCFNr3QFAlrWGfIACgkQ0rTAlCFN
r3TOJw/8DXYbgoS+Jfn9ALWQbiQxFtMwCtEJusCnh9s+V9hF3L1YYGF7EFRwMmXL
jVYS/JQdTWbqoOL0p7rXnnqKDS6jqWRqXmOvcM4ftZlAmcSy8Mu0R4AsT2qfEa4O
XDFrVnlpm+v1bt9E6LPr3rACT7LLJJwOtWXxJ5pd0VD2G9QrQBu83w6cWAjc9R+0
X2Il475upCU7Dul05A5WE5h95A9ZfmyJ7OY7vFC8yHEI3VAhS62JHVtaQ1RP/GT9
ddRP/hVQDtKNbmRN/h3Rn2g/wkCmESDfCd/8qlPukcf12YTaZkd3nTln2sinAeTt
jwe9gXsxpNtl/Gv1VpOuGQBsf0SnPIhV6OTkNObZemjaPfFgrIgzvGkUlDm0fcOp
QSZJ5/cqOfanKtOrxrrw/MxSLxDtUK5hLmsgdsU8afVRgQwi9EI2fGwxGPLKOWQO
TMSAWeUtwA1hyalY3VK4gdFaAHTWQukbNOTI8MpmJnynkwclVeMxcMbwr84Uo8u2
inJRiCay9b/JRMnFC4hUT+abinxnXpivaRNEeRvNZJhS1oqVkpNkQVEel/T8nSIs
OgxBy/5/6/Ks5CjVbd8o2Q+yPoEIxOAKCucOOpJv5Nk5wg5JSW24IvYRWwnZJq3I
9I97rP/JQrshaa9gOOLzBxuaGAamfQge2ICgBiaJPL2UL3znDSU=
=Wehw
-----END PGP SIGNATURE-----

--g5bnsscojaeep5gk--
