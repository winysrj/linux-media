Return-path: <linux-media-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:58489 "EHLO
        atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751797AbdFJHfP (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 10 Jun 2017 03:35:15 -0400
Date: Sat, 10 Jun 2017 09:35:12 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Steve Longerbeam <slongerbeam@gmail.com>, robh+dt@kernel.org,
        mark.rutland@arm.com, shawnguo@kernel.org, kernel@pengutronix.de,
        fabio.estevam@nxp.com, linux@armlinux.org.uk, mchehab@kernel.org,
        nick@shmanahar.org, markus.heiser@darmarIT.de,
        p.zabel@pengutronix.de, laurent.pinchart+renesas@ideasonboard.com,
        bparrot@ti.com, geert@linux-m68k.org, arnd@arndb.de,
        sudipm.mukherjee@gmail.com, minghsiu.tsai@mediatek.com,
        tiffany.lin@mediatek.com, jean-christophe.trotin@st.com,
        horms+renesas@verge.net.au, niklas.soderlund+renesas@ragnatech.se,
        robert.jarzmik@free.fr, songjun.wu@microchip.com,
        andrew-ct.chen@mediatek.com, gregkh@linuxfoundation.org,
        shuah@kernel.org, sakari.ailus@linux.intel.com,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org,
        devel@driverdev.osuosl.org,
        Steve Longerbeam <steve_longerbeam@mentor.com>
Subject: Re: [PATCH v8 00/34] i.MX Media Driver
Message-ID: <20170610073512.GA15980@amd>
References: <1496860453-6282-1-git-send-email-steve_longerbeam@mentor.com>
 <e7e4669c-2963-b9e1-edd7-02731a6e0f9c@xs4all.nl>
 <c0b69c93-b9cd-25e8-ea36-fc0600efdb69@gmail.com>
 <e4f152de-6e75-7654-178e-e6dcf9ad12f3@xs4all.nl>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="lrZ03NoBR/3+SXJZ"
Content-Disposition: inline
In-Reply-To: <e4f152de-6e75-7654-178e-e6dcf9ad12f3@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--lrZ03NoBR/3+SXJZ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> >> Other than that everything is ready AFAICT.
> >>
> >=20
> > But as Pavel pointed out, in fact we are missing many
> > Acks still, for all of the dts source changes (patches
> > 4-14), as well as really everything else (imx-media staging
> > driver patches).
>=20
> No Acks needed for the staging part. It's staging, so not held
> to the same standards as non-staging parts. That doesn't mean
> Acks aren't welcome, of course.
>=20
> You don't need Greg's Ack for staging/media either, patches there
> go in via us (generally at least) and we handle those, not Greg.

Ok, good.

Can you just apply the patches? This is staging, they can be
reviewed/fixed there -- as expected for staging. They are already way
beyond staging quality, we don't want to get to "series v17"
here, and repeatedly sending them over the email does not really do
them any good.

Thanks,
								Pavel
--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--lrZ03NoBR/3+SXJZ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAlk7oTAACgkQMOfwapXb+vImTQCfQfqcjsZm/fd/uQuMKvk3x7js
LGYAn0rpCrS/+9RhDB+RhR2HHtrx3dUy
=5HU1
-----END PGP SIGNATURE-----

--lrZ03NoBR/3+SXJZ--
