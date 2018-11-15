Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.bootlin.com ([62.4.15.54]:55382 "EHLO mail.bootlin.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725875AbeKPHAn (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 16 Nov 2018 02:00:43 -0500
Date: Thu, 15 Nov 2018 21:51:06 +0100
From: Maxime Ripard <maxime.ripard@bootlin.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Hans Verkuil <hans.verkuil@cisco.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        linux-media@vger.kernel.org, Andrzej Hajda <a.hajda@samsung.com>,
        Chen-Yu Tsai <wens@csie.org>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        Mark Rutland <mark.rutland@arm.com>,
        Rob Herring <robh+dt@kernel.org>,
        Frank Rowand <frowand.list@gmail.com>
Subject: Re: [PATCH 3/5] media: sunxi: Add A10 CSI driver
Message-ID: <20181115205106.thbkojnzdwmaeui3@flea>
References: <cover.71b0f9855c251f9dc389ee77ee6f0e1fad91fb0b.1542097288.git-series.maxime.ripard@bootlin.com>
 <c53e1cdc3b139382b00ee06bf3980d3fd1742ec0.1542097288.git-series.maxime.ripard@bootlin.com>
 <f34c79f5-66d6-2c2f-5616-020ad2b96400@xs4all.nl>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="i43yylcxwdmh6fzi"
Content-Disposition: inline
In-Reply-To: <f34c79f5-66d6-2c2f-5616-020ad2b96400@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--i43yylcxwdmh6fzi
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Hans,

Thanks for your review! I'll address the other comments you made.

On Tue, Nov 13, 2018 at 01:24:47PM +0100, Hans Verkuil wrote:
> > +static int csi_probe(struct platform_device *pdev)
> > +{
> > +	struct sun4i_csi *csi;
> > +	struct resource *res;
> > +	int ret;
> > +	int irq;
> > +
> > +	csi =3D devm_kzalloc(&pdev->dev, sizeof(*csi), GFP_KERNEL);
>=20
> devm_kzalloc is not recommended: all devm_ memory is freed when the driver
> is unbound, but a filehandle might still have a reference open.

How would a !devm variant with a kfree in the remove help? We would
still fall in the same case, right?

Thanks!
Maxime

--=20
Maxime Ripard, Bootlin
Embedded Linux and Kernel engineering
https://bootlin.com

--i43yylcxwdmh6fzi
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQRcEzekXsqa64kGDp7j7w1vZxhRxQUCW+3cOgAKCRDj7w1vZxhR
xV+oAP9nvGAFGsjofaPgBIoiu7YLqY9AwaWzhDFI7MH/Z+4j4gEA9Q/7d+BgUz1T
NV6gRwThQqyyU/nCrI4qaOItr7V89QI=
=j6qY
-----END PGP SIGNATURE-----

--i43yylcxwdmh6fzi--
