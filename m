Return-path: <linux-media-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:54064 "EHLO
        atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751407AbdFZLQZ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 26 Jun 2017 07:16:25 -0400
Date: Mon, 26 Jun 2017 13:16:21 +0200
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
Subject: Re: omap3isp camera was Re: [PATCH v1 0/6] Add support of OV9655
 camera
Message-ID: <20170626111621.GC11688@amd>
References: <1498143942-12682-1-git-send-email-hugues.fruchet@st.com>
 <385A82AC-CC23-41BD-9F57-0232F713FED9@goldelico.com>
 <1E453955-0C1A-414B-BBB2-C64B6D0EF378@goldelico.com>
 <20170625091856.GA22791@amd>
 <EDFD663F-37F9-42C2-92A9-66C2508B361E@goldelico.com>
 <20170626083927.GB9621@amd>
 <5364AD62-5000-451E-B3F7-93D49A91EED5@goldelico.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="4jXrM3lyYWu4nBt5"
Content-Disposition: inline
In-Reply-To: <5364AD62-5000-451E-B3F7-93D49A91EED5@goldelico.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--4jXrM3lyYWu4nBt5
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> > You may want to try this one:
> >=20
> > commit 0eae9d2a8f096f703cbc8f9a0ab155cd3cc14cef
> > Author: Pavel <pavel@ucw.cz>
> > Date:   Mon Feb 13 21:26:51 2017 +0100
> >=20
> >    omap3isp: fix VP2SDR bit so capture (not preview) works
> >=20
> >    This is neccessary for capture (not preview) to work properly on
> >        N900. Why is unknown.
>=20
> Ah, interesting. I will give it a try.
>=20
> Do you please have a link to the repo where this commit can be
> > found?

This branch, as mentioned before:

https://git.kernel.org/pub/scm/linux/kernel/git/pavel/linux-n900.git/log/?h=
=3Dcamera-fw5-6

									Pavel
								=09

--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--4jXrM3lyYWu4nBt5
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAllQ7QUACgkQMOfwapXb+vKIcwCgg3ewjLvWvqSo3rWAi+dadBJ5
058AnRVDYSBMAYco7NYUW9hsoS6MnU00
=Keaa
-----END PGP SIGNATURE-----

--4jXrM3lyYWu4nBt5--
