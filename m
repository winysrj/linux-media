Return-path: <linux-media-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:35863 "EHLO
        atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750991AbdFCTvm (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Sat, 3 Jun 2017 15:51:42 -0400
Date: Sat, 3 Jun 2017 21:51:39 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Steve Longerbeam <slongerbeam@gmail.com>
Cc: Sakari Ailus <sakari.ailus@iki.fi>, robh+dt@kernel.org,
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
Message-ID: <20170603195139.GA3062@amd>
References: <1495672189-29164-1-git-send-email-steve_longerbeam@mentor.com>
 <1495672189-29164-17-git-send-email-steve_longerbeam@mentor.com>
 <20170531195821.GA16962@amd>
 <20170601082659.GJ1019@valkosipuli.retiisi.org.uk>
 <755909bf-d1de-e0f3-1569-0d4b16e26817@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="opJtzjQTFsWo+cga"
Content-Disposition: inline
In-Reply-To: <755909bf-d1de-e0f3-1569-0d4b16e26817@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--opJtzjQTFsWo+cga
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> >>>+	/* Auto/manual exposure */
> >>>+	ctrls->auto_exp =3D v4l2_ctrl_new_std_menu(hdl, ops,
> >>>+						 V4L2_CID_EXPOSURE_AUTO,
> >>>+						 V4L2_EXPOSURE_MANUAL, 0,
> >>>+						 V4L2_EXPOSURE_AUTO);
> >>>+	ctrls->exposure =3D v4l2_ctrl_new_std(hdl, ops,
> >>>+					    V4L2_CID_EXPOSURE_ABSOLUTE,
> >>>+					    0, 65535, 1, 0);
> >>
> >>Is exposure_absolute supposed to be in microseconds...?
> >
> >Yes.
>=20
> According to the docs V4L2_CID_EXPOSURE_ABSOLUTE is in 100 usec units.
>=20
>  OTOH V4L2_CID_EXPOSURE has no defined unit, so it's a better fit IMO.
> >Way more drivers appear to be using EXPOSURE than EXPOSURE_ABSOLUTE, too.
>=20
> Done, switched to V4L2_CID_EXPOSURE. It's true, this control is not
> taking 100 usec units, so unit-less is better.

Thanks. If you know the units, it would be of course better to use
right units...

Best regards,
									Pavel
--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--opJtzjQTFsWo+cga
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAlkzE0sACgkQMOfwapXb+vJeTQCdF9aH5BvEXWZ5xpMOhFiSkPP7
dUsAn1qJEWtiQpHhNWQiWi6JuiAD9VsK
=VXOJ
-----END PGP SIGNATURE-----

--opJtzjQTFsWo+cga--
