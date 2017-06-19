Return-path: <linux-media-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:56666 "EHLO
        atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751897AbdFSKs1 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 19 Jun 2017 06:48:27 -0400
Date: Mon, 19 Jun 2017 12:48:24 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Pali =?iso-8859-1?Q?Roh=E1r?= <pali.rohar@gmail.com>,
        Ramiro Oliveira <Ramiro.Oliveira@synopsys.com>,
        Todor Tomov <todor.tomov@linaro.org>,
        Robert Jarzmik <robert.jarzmik@free.fr>,
        Steve Longerbeam <slongerbeam@gmail.com>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Hugues Fruchet <hugues.fruchet@st.com>,
        Bhumika Goyal <bhumirks@gmail.com>
Subject: Re: [PATCH] [media] ov2640: make GPIOLIB an optional dependency
Message-ID: <20170619104824.GA31643@amd>
References: <a463ea990d2138ca93027b006be96a0324b77fe4.1492602584.git.mchehab@s-opensource.com>
 <20170419132339.GA31747@amd>
 <20170419110300.2dbbf784@vento.lan>
 <20170421063312.GA21434@amd>
 <153c35bf-b6bd-eb97-d72e-bab05e96e267@xs4all.nl>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="2oS5YaxWCcQjTEyO"
Content-Disposition: inline
In-Reply-To: <153c35bf-b6bd-eb97-d72e-bab05e96e267@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--2oS5YaxWCcQjTEyO
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> I'm dropping this from patchwork since this no longer applies now that ov=
2640
> has been moved out of soc_camera.
>=20
> If you still want this (it is a reasonable patch), then please
> respin.

If I'm not mistaken, equivalent fix is already in
drivers/media/i2c/ov2640.c .

Thanks,
								Pavel

--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--2oS5YaxWCcQjTEyO
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAllHq/gACgkQMOfwapXb+vLHbACfYX0OJySuHvfuRmN08Vf9rMjO
tf0AoJ/dd03ToHLX7/jLiEAHl3ijpeCH
=W1Cr
-----END PGP SIGNATURE-----

--2oS5YaxWCcQjTEyO--
