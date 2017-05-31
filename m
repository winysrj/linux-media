Return-path: <linux-media-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:40138 "EHLO
        atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751029AbdEaULJ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 31 May 2017 16:11:09 -0400
Date: Wed, 31 May 2017 22:11:07 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Steve Longerbeam <slongerbeam@gmail.com>
Cc: Sakari Ailus <sakari.ailus@iki.fi>,
        Hans Verkuil <hverkuil@xs4all.nl>, robh+dt@kernel.org,
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
Subject: Re: [PATCH v7 00/34] i.MX Media Driver
Message-ID: <20170531201107.GB16962@amd>
References: <1495672189-29164-1-git-send-email-steve_longerbeam@mentor.com>
 <dd82968a-4c0b-12a4-f43b-7e63a255812d@xs4all.nl>
 <20170529153637.GH29527@valkosipuli.retiisi.org.uk>
 <08dcd6f6-e0ef-a6a0-cfc3-4fcd55624169@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="KFztAG8eRSV9hGtP"
Content-Disposition: inline
In-Reply-To: <08dcd6f6-e0ef-a6a0-cfc3-4fcd55624169@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--KFztAG8eRSV9hGtP
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> >If there's a need for this (there should not be, as the controls are exp=
osed
> >to the user space through the sub-device nodes as the other drivers do),=
 the
> >framework APIs need to be extended.
>=20
> Right, this gets back to the media framework usability arguments. At least
> myself, Philipp, and Russell feel that automatic inheritance of a configu=
red
> pipeline's controls to a video device adds to the usability.

For the record, usability can be pretty much fixed in v4l-utils... I
have patches that try ioctls on a list of fd's. Now we need a way to
find out which /dev/video* files belong to single camera. I believe
kernel already has required APIs, we just need to apply v4l-utils
patch to use them...

									Pavel
--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--KFztAG8eRSV9hGtP
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAlkvI1sACgkQMOfwapXb+vLfEgCfe4WFiqKmIIhFCORleJixmS6S
V/EAn0APxvTmxHyOU+IpJUkFFYcKPjqx
=Zw9u
-----END PGP SIGNATURE-----

--KFztAG8eRSV9hGtP--
