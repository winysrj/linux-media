Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.187]:55151 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932982Ab3AIUhW (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 9 Jan 2013 15:37:22 -0500
Date: Wed, 9 Jan 2013 21:37:05 +0100
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Steffen Trumtrar <s.trumtrar@pengutronix.de>
Cc: devicetree-discuss@lists.ozlabs.org,
	Rob Herring <robherring2@gmail.com>,
	linux-fbdev@vger.kernel.org, dri-devel@lists.freedesktop.org,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Guennady Liakhovetski <g.liakhovetski@gmx.de>,
	linux-media@vger.kernel.org,
	Tomi Valkeinen <tomi.valkeinen@ti.com>,
	Stephen Warren <swarren@wwwdotorg.org>, kernel@pengutronix.de,
	Florian Tobias Schandinat <FlorianSchandinat@gmx.de>,
	David Airlie <airlied@linux.ie>,
	Rob Clark <robdclark@gmail.com>,
	Leela Krishna Amudala <leelakrishna.a@gmail.com>
Subject: Re: [PATCHv16 0/7] of: add display helper
Message-ID: <20130109203705.GA12241@avionic-0098.adnet.avionic-design.de>
References: <1355850256-16135-1-git-send-email-s.trumtrar@pengutronix.de>
 <20130109201541.GB4780@pengutronix.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="yrj/dFKFPuw6o+aM"
Content-Disposition: inline
In-Reply-To: <20130109201541.GB4780@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--yrj/dFKFPuw6o+aM
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jan 09, 2013 at 09:15:41PM +0100, Steffen Trumtrar wrote:
> On Tue, Dec 18, 2012 at 06:04:09PM +0100, Steffen Trumtrar wrote:
> > Hi!
> >=20
> > Finally, right in time before the end of the world on friday, v16 of the
> > display helpers.
> >=20
>=20
> So, any more criticism on the series? Any takers for the series as is?
> I guess it could be merged via the fbdev-tree if David Airlie can agree
> to the DRM patches ?! Does that sound about right?
>=20
> I think the series was tested at least with
> 	- imx6q: sabrelite, sabresd
> 	- imx53: tqma53/mba53
> 	- omap: DA850 EVM, AM335x EVM, EVM-SK
>=20
> I don't know what Laurent Pinchart, Marek Vasut and Leela Krishna Amudala
> are using. Those are the people I know from the top of my head, that use
> or at least did use the patches in one of its iterations. If I forgot
> anyone, please speak up and possibly add your new HW to the list of tested
> devices.

I tested earlier versions on Tegra. The latest one was v15 I think.

Thierry

--yrj/dFKFPuw6o+aM
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJQ7dTxAAoJEN0jrNd/PrOh5lQQAI8l7hnwRQDo8iK0z/dLI5O7
yKKZX3m4zB1AQhusMQmBNIrRpVjOHwmrf7O6nDdIzCK+Rx8jirT//n11JpxZt3ys
2YhNddAE+tMjUq/T/Bnud+WJFX/5sXk/KNZUXP9V6KqUHV0AJUCZAgkR9Q1XBAhU
UuwC4x3d/FTv1ITXqUxoJQZ6M1sPKKJP3saDaufeYVunuy5JrUiNxQZkxw5PcyAk
SdVi8dkTYzt/MPFWgwJ9afQ3zlxT0+Tk9oX/7unEs+91SuA8NjgCXPKgtgIn46+V
sEDdd0W0iAR/Fc7+mxBVubRxhMTx1Qz65XJXxeeIjOzyRwMlYV8Ze1zTXPV1jfZz
gIdWKbMbtMAPUq1g0GM1xyR543CRwN5uF4HbcNoM5ERD83r1Qk2oECNN+58p7Vsg
qTA+4kk4cSd9h0ADLFD0LRS34EFFqtoWPbo8SknZXcgjm2T9JlGrd3pSWpaN3NnU
tuOjeze+krqt+nf8NHtJXBepB9WTo8YkNRvCA8tSmn2ONpGBhqoS3rX7rW3NXL20
vS6RUf+HRxtsRhTFeC1OrYnB1jA7EhlxLU4GLqsNFUopgkrMn1olbM8d2hj4/wal
N11OQfe3ACXHm9mpRP0o3jK+3w3Ozg5EAMsGGk+z9YEywYzIBScowa28MYdmCbF2
0ajONkatxHNnwBjpVuw5
=r8SB
-----END PGP SIGNATURE-----

--yrj/dFKFPuw6o+aM--
