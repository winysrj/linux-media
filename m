Return-path: <linux-media-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:38214 "EHLO
        atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751162AbdFCWRo (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Sat, 3 Jun 2017 18:17:44 -0400
Date: Sun, 4 Jun 2017 00:17:41 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: Steve Longerbeam <slongerbeam@gmail.com>, robh+dt@kernel.org,
        mark.rutland@arm.com, shawnguo@kernel.org, kernel@pengutronix.de,
        fabio.estevam@nxp.com, linux@armlinux.org.uk, mchehab@kernel.org,
        hverkuil@xs4all.nl, nick@shmanahar.org, markus.heiser@darmarIT.de,
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
Subject: Re: [PATCH v7 16/34] [media] add Omnivision OV5640 sensor driver
Message-ID: <20170603221741.GA2379@amd>
References: <1495672189-29164-1-git-send-email-steve_longerbeam@mentor.com>
 <1495672189-29164-17-git-send-email-steve_longerbeam@mentor.com>
 <20170531195821.GA16962@amd>
 <20170601082659.GJ1019@valkosipuli.retiisi.org.uk>
 <755909bf-d1de-e0f3-1569-0d4b16e26817@gmail.com>
 <20170603195139.GA3062@amd>
 <20170603215709.GU1019@valkosipuli.retiisi.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="YiEDa0DAkWCtVeE4"
Content-Disposition: inline
In-Reply-To: <20170603215709.GU1019@valkosipuli.retiisi.org.uk>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--YiEDa0DAkWCtVeE4
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> > > According to the docs V4L2_CID_EXPOSURE_ABSOLUTE is in 100 usec units.
> > >=20
> > >  OTOH V4L2_CID_EXPOSURE has no defined unit, so it's a better fit IMO.
> > > >Way more drivers appear to be using EXPOSURE than EXPOSURE_ABSOLUTE,=
 too.
> > >=20
> > > Done, switched to V4L2_CID_EXPOSURE. It's true, this control is not
> > > taking 100 usec units, so unit-less is better.
> >=20
> > Thanks. If you know the units, it would be of course better to use
> > right units...
>=20
> Steve: what's the unit in this case? Is it lines or something else?
>=20
> Pavel: we do need to make sure the user space will be able to know the un=
it,
> too. It's rather a case with a number of controls: the unit is known but
> there's no API to convey it to the user.
>=20
> The exposure is a bit special, too: granularity matters a lot on small
> values. On most other controls it does not.

Yeah. Basically problem with exposure is that the control is
logarithmic; by using linear scale we got too much resolution at long
times and too little resolution at short times.

(Plus, 100 usec ... n900 can do times _way_ shorter than that.)

Anyway, even u32 gives us enough range, but I so the linear/log
confusion does not matter. But it would be nicer if values were in 10
usec or usec, not 100 usec...=20

								Pavel
--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--YiEDa0DAkWCtVeE4
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAlkzNYUACgkQMOfwapXb+vIJtgCgq9LRaStKASXkFpz4aAJY5FVo
+8QAnjUE8FZwa10zrYMwuHW9oe3Q58oe
=7TFq
-----END PGP SIGNATURE-----

--YiEDa0DAkWCtVeE4--
