Return-path: <linux-media-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:54127 "EHLO
        atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751054AbdFAInY (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 1 Jun 2017 04:43:24 -0400
Date: Thu, 1 Jun 2017 10:43:20 +0200
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
Subject: exposure vs. exposure_absolute was Re: [PATCH v7 16/34] [media] add
 Omnivision OV5640 sensor driver
Message-ID: <20170601084320.GA16038@amd>
References: <1495672189-29164-1-git-send-email-steve_longerbeam@mentor.com>
 <1495672189-29164-17-git-send-email-steve_longerbeam@mentor.com>
 <20170531195821.GA16962@amd>
 <20170601082659.GJ1019@valkosipuli.retiisi.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="AqsLC8rIMeq19msA"
Content-Disposition: inline
In-Reply-To: <20170601082659.GJ1019@valkosipuli.retiisi.org.uk>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--AqsLC8rIMeq19msA
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> > > +	/* Auto/manual exposure */
> > > +	ctrls->auto_exp =3D v4l2_ctrl_new_std_menu(hdl, ops,
> > > +						 V4L2_CID_EXPOSURE_AUTO,
> > > +						 V4L2_EXPOSURE_MANUAL, 0,
> > > +						 V4L2_EXPOSURE_AUTO);
> > > +	ctrls->exposure =3D v4l2_ctrl_new_std(hdl, ops,
> > > +					    V4L2_CID_EXPOSURE_ABSOLUTE,
> > > +					    0, 65535, 1, 0);
> >=20
> > Is exposure_absolute supposed to be in microseconds...?
>=20
> Yes. OTOH V4L2_CID_EXPOSURE has no defined unit, so it's a better fit IMO.
> Way more drivers appear to be using EXPOSURE than EXPOSURE_ABSOLUTE, too.
>=20
> Ideally we should have only one control for exposure.

No. N-o. No no no. NO! No. N-o. NONONO. No. NooooooooooOOO!!!!!!!!!!!!!

Sorry, no.

Userspace needs to know exposure times. It is not so important for a
webcam, but it is mandatory for digital camera. As it gets darker,
autogain wants to scale exposure to cca 1/100 sec, then it wants to
scale gain up to maximum, and only then it wants to continue scaling
exposure. (Threshold will be shorter in "sports" mode, perhaps
1/300sec?)

Plus, we want user to be able to manually set exposure parameters.

So... _this_ driver probably should use V4L2_CID_EXPOSURE. (If the
units are not known). But in general we'd prefer drivers using
V4L2_CID_EXPOSURE_ABSOLUTE. Your car has speedometer calibrated in
km/h or mph, not in "% of max", right?

									Pavel
--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--AqsLC8rIMeq19msA
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAlkv06gACgkQMOfwapXb+vICfgCeMAkZtS+dSZiIkxkVr86gjRq8
YxQAn3ECZOtpiTRU+5/M9tAD4g0C5lLu
=qV/J
-----END PGP SIGNATURE-----

--AqsLC8rIMeq19msA--
