Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.bootlin.com ([62.4.15.54]:48263 "EHLO mail.bootlin.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1422717AbeCBIYM (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 2 Mar 2018 03:24:12 -0500
Date: Fri, 2 Mar 2018 09:24:00 +0100
From: Maxime Ripard <maxime.ripard@bootlin.com>
To: Niklas =?utf-8?Q?S=C3=B6derlund?= <niklas.soderlund@ragnatech.se>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Rob Herring <robh+dt@kernel.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        linux-media@vger.kernel.org, devicetree@vger.kernel.org,
        Richard Sproul <sproul@cadence.com>,
        Alan Douglas <adouglas@cadence.com>,
        Steve Creaney <screaney@cadence.com>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Boris Brezillon <boris.brezillon@bootlin.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Benoit Parrot <bparrot@ti.com>, nm@ti.com,
        Simon Hatliff <hatliff@cadence.com>
Subject: Re: [PATCH v5 2/2] v4l: cadence: Add Cadence MIPI-CSI2 TX driver
Message-ID: <20180302082400.52a3p7nbk4lbjk6x@flea.lan>
References: <20180301113049.16470-1-maxime.ripard@bootlin.com>
 <20180301113049.16470-3-maxime.ripard@bootlin.com>
 <20180301162658.GB12470@bigcity.dyn.berto.se>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="gl2crj2bjpb5ol5j"
Content-Disposition: inline
In-Reply-To: <20180301162658.GB12470@bigcity.dyn.berto.se>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--gl2crj2bjpb5ol5j
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Thu, Mar 01, 2018 at 05:26:58PM +0100, Niklas S=F6derlund wrote:
> I did not do a full review on this series, I only browsed it to check=20
> how you handled some CSI-2 related problems. While doing so I noticed a=
=20
> few small issues.

Thanks for your review :)

The comment I stripped out will be addressed.

> > +	/*
> > +	 * Create a static mapping between the CSI virtual channels
> > +	 * and the input streams.
> > +	 *
> > +	 * This should be enhanced, but v4l2 lacks the support for
> > +	 * changing that mapping dynamically at the moment.
>=20
> Sakaris work will help with this in the kernel and I have some RFC=20
> patches for v4l-utils which can be used to configure it from user-space.
>=20
> https://www.spinics.net/lists/linux-media/msg126128.html

So my vision for this was this would come as a second step. I'd really
like to get the base driver merged, and then build on top of that to
get extra features. The mapping is definitely on my radar, and like I
was saying in my other mail, I even started to work on it.

> > +static int csi2tx_probe(struct platform_device *pdev)
> > +{
> > +	struct csi2tx_priv *csi2tx;
> > +	unsigned int i;
> > +	int ret;
> > +
> > +	csi2tx =3D kzalloc(sizeof(*csi2tx), GFP_KERNEL);
>=20
> No real issue I'm just curious, why not use devm_kzalloc() here? You=20
> free csi2tx in the remove() callback so not using devm_ will not help=20
> with (the potential) v4l2 related lifetime management issues.

Laurent asked me to do this in an earlier iteration:
https://patchwork.linuxtv.org/patch/42683/

I'm fine with both, but he seemed to say that it would be later for a
later cleanup to not use the devm variant here.

> > +MODULE_DEVICE_TABLE(of, csi2tx_of_table);
> > +
> > +static struct platform_driver csi2tx_driver =3D {
> > +	.probe	=3D csi2tx_probe,
> > +	.remove	=3D csi2tx_remove,
> > +
> > +	.driver	=3D {
> > +		.name		=3D "cdns-csi2tx",
> > +		.of_match_table	=3D csi2tx_of_table,
> > +	},
> > +};
> > +module_platform_driver(csi2tx_driver);
>=20
> Are MODULE_LICENSE() not needed anymore with the introduction of the=20
> SPDX headers?

This is definitely missing, I'll add it.

Thanks!
Maxime

--=20
Maxime Ripard, Bootlin (formerly Free Electrons)
Embedded Linux and Kernel engineering
https://bootlin.com

--gl2crj2bjpb5ol5j
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEE0VqZU19dR2zEVaqr0rTAlCFNr3QFAlqZCh8ACgkQ0rTAlCFN
r3ScEA/9FZMN+nhSVsvywrRNnJeT9WUT9FgY7ZiCKPVmGY+MX7BypC/E5vBdtrH2
5o9ecITRLEEmXyytJTMHh6cLDU7+Ng00KFK+DLpmApdDzzOSbz+Aky1RBPE5fr9c
/+bL4zpn/ugdfaz6XmBh8fVoX85y1/TTNHVFE0iu5+CNI+IyfgDehENOIRTtmq3g
MxQ5sw7EPplUzTobinwxTmaXj4ltYgAdLwzrTm0QZdzFA1u+jhXPKxDOck20BB7/
9TFfXxeC+XKvkIzZkfzNoOHEsmbiLvLtx7ufucI4LUywwEF/WZQtVMYi+Dv44gHJ
1HQXDScwBUO0ujKEKie15NncdZD/r+gqpsdTzXtntKda3w+TUUSC2bc6MswWgi1t
bHbSQJGfAdn1ui12bMAtaROeYCUmo4lJOKdJQh0gzgWYcmWO0R1alWIel30clPF6
mkbaDJPrBqbq3zZUOqF/ietap+ccspZppLbQkGs/pp95hI9ZoOrB7aAkl5M1pthJ
dj+UuMbZ9r8jBkNOCp5fE8n4rKgFU1DS4Fo+ZbLE51zUFIC2z+iSQ7Vjv/rvR+Ml
/kTL9NAkJyG0NObMB5eapVSyYLCI0a/Ftu4FJt1ffUzbcF2mkqGtxlQoMtwLqK1C
4J4zK5AphaDQo9TfydpI721j21R9Tr+zUaOpI1dNipxDYZV+Y2A=
=aBYP
-----END PGP SIGNATURE-----

--gl2crj2bjpb5ol5j--
