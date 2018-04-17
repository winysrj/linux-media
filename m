Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.bootlin.com ([62.4.15.54]:58505 "EHLO mail.bootlin.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752915AbeDQNKu (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 17 Apr 2018 09:10:50 -0400
Date: Tue, 17 Apr 2018 15:10:24 +0200
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
Message-ID: <20180417131024.kc6smxh4mbd44nst@flea>
References: <20180404122025.8726-1-maxime.ripard@bootlin.com>
 <20180404122025.8726-3-maxime.ripard@bootlin.com>
 <20180413121437.slsv2ef2j5k2aihw@valkosipuli.retiisi.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="fpsima7u2besgle5"
Content-Disposition: inline
In-Reply-To: <20180413121437.slsv2ef2j5k2aihw@valkosipuli.retiisi.org.uk>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--fpsima7u2besgle5
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Sakari,

On Fri, Apr 13, 2018 at 03:14:37PM +0300, Sakari Ailus wrote:
> > +static int csi2tx_set_pad_format(struct v4l2_subdev *subdev,
> > +				 struct v4l2_subdev_pad_config *cfg,
> > +				 struct v4l2_subdev_format *fmt)
> > +{
> > +	struct csi2tx_priv *csi2tx =3D v4l2_subdev_to_csi2tx(subdev);
> > +
> > +	if (fmt->pad >=3D CSI2TX_PAD_MAX)
> > +		return -EINVAL;
> > +
> > +	csi2tx->pad_fmts[fmt->pad] =3D fmt->format;
>=20
> Have I asked previously if there are any limitations with this?
>=20
> The CSI-2 TX link has multiple formats so I wouldn't support formats on
> that pad in order to be compatible with the planned VC/data type support
> patchset. Or do you see issues with that?

It's not just about the CSI-2 link, but more about the input pads as
well, that can be configured (and we need to know the format in order
to configure the IP properly).

Maybe we can simply prevent the format change on the CSI-2 pad, but
not the others?

Maxime

--=20
Maxime Ripard, Bootlin (formerly Free Electrons)
Embedded Linux and Kernel engineering
https://bootlin.com

--fpsima7u2besgle5
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEE0VqZU19dR2zEVaqr0rTAlCFNr3QFAlrV8j8ACgkQ0rTAlCFN
r3TARA/+K32TEb7Ja/DpbaWx2/aVUlR/S4Zm21SGE/K81JriCEle8sBwZ6kpAxqj
3KkiyjxnfPeHUErZ6pkF7QcOoZ2Ci/auMrZ5ty31QXqDYwIWUz12yN9vZQ6+QByT
0ntZYHMpATINqb8Ot/vCFE2aImN6p0pIWBYHkgzJvdcPnCo8XTETw4i8CmZ8ByC+
saYzTpRLiNCum0Yyqe1w1MZXj1klNNE4Nq9gR/0lBk4g+bPlbGx1+qgpGyqWNDQL
2kSF72yAQzJVqxPTj0vDG/LRjOTEre5gzRNJAYR2+LIG1bKkeUUljxlYZxKQjKT3
2HPLCC5azBPe0RXaKneN7r1Wcm88iQdFmRHOlCLKOdJJ5rigrIQlnMQAkOvnYGFI
nWqPA+Oic2KvQn3oJU6coeoAYKEXwk3LJF/SIXmGqC50GxUB2PNGe+LOM36xsV5a
FE2R54WsFwG5DrYKeY55k3WI5No3EB50GZ/k6dV7Bpa43QS8MIYdsbQYUqbpzEHf
ru0VfdJT5vGN2M6azjAN51SBP1R4M8jIcibTYK9DUKOuRjFi9RoHA+JsZxrjUk93
/OoKOo4/x882zktRpcqpjmGez5LbmYrPBPkz/eIL3zhP3l1T8WqtQVQrcE0uaTD7
pLW/boyjEbsOjRigfkJus8vt+U14zf5q08+Xb0wnm2vfM5WK0do=
=C2WO
-----END PGP SIGNATURE-----

--fpsima7u2besgle5--
