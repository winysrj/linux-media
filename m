Return-path: <linux-media-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:47301 "EHLO
        atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751058AbdFYJS7 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 25 Jun 2017 05:18:59 -0400
Date: Sun, 25 Jun 2017 11:18:56 +0200
From: Pavel Machek <pavel@ucw.cz>
To: "H. Nikolaus Schaller" <hns@goldelico.com>
Cc: Hugues Fruchet <hugues.fruchet@st.com>,
        Mark Rutland <mark.rutland@arm.com>,
        devicetree <devicetree@vger.kernel.org>,
        Benjamin Gaignard <benjamin.gaignard@linaro.org>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Rob Herring <robh+dt@kernel.org>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Yannick Fertre <yannick.fertre@st.com>,
        Sylwester Nawrocki <sylvester.nawrocki@gmail.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        linux-media@vger.kernel.org,
        Discussions about the Letux Kernel
        <letux-kernel@openphoenux.org>
Subject: omap3isp camera was Re: [PATCH v1 0/6] Add support of OV9655 camera
Message-ID: <20170625091856.GA22791@amd>
References: <1498143942-12682-1-git-send-email-hugues.fruchet@st.com>
 <385A82AC-CC23-41BD-9F57-0232F713FED9@goldelico.com>
 <1E453955-0C1A-414B-BBB2-C64B6D0EF378@goldelico.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="pf9I7BMVVzbSWLtt"
Content-Disposition: inline
In-Reply-To: <1E453955-0C1A-414B-BBB2-C64B6D0EF378@goldelico.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--pf9I7BMVVzbSWLtt
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> * unfortunately we still get no image :(
>=20
> The latter is likely a setup issue of our camera interface (OMAP3 ISP =3D=
 Image Signal Processor) which
> we were not yet able to solve. Oscilloscoping signals on the interface in=
dicated that signals and
> sync are correct. But we do not know since mplayer only shows a green scr=
een.

What mplayer command line do you use? How did you set up the pipeline
with media-ctl?

On kernel.org, I have tree called camera-fw5-6 , where camera works
for me on n900. On gitlab, there's modifed fcam-dev, which can be used
for testing.

Best regards,
									Pavel
--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--pf9I7BMVVzbSWLtt
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAllPgAAACgkQMOfwapXb+vJTAQCgwZ7HMGVaCoeKt4tzcR+qbKym
0WQAniWT609o3JHGvEBsl51g7se8b9FP
=ZOxj
-----END PGP SIGNATURE-----

--pf9I7BMVVzbSWLtt--
