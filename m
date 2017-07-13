Return-path: <linux-media-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:44696 "EHLO
        atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750966AbdGMH5I (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 13 Jul 2017 03:57:08 -0400
Date: Thu, 13 Jul 2017 09:57:06 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        pali.rohar@gmail.com, sre@kernel.org,
        kernel list <linux-kernel@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        linux-omap@vger.kernel.org, tony@atomide.com, khilman@kernel.org,
        aaro.koskinen@iki.fi, patrikbachan@gmail.com, serge@hallyn.com,
        abcloriens@gmail.com, Sakari Ailus <sakari.ailus@iki.fi>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        linux-media@vger.kernel.org
Subject: Re: [patch] autogain support for bayer10 format (was Re: [patch]
 propagating controls in libv4l2)
Message-ID: <20170713075706.GB1363@amd>
References: <20170424093059.GA20427@amd>
 <20170424103802.00d3b554@vento.lan>
 <20170424212914.GA20780@amd>
 <20170424224724.5bb52382@vento.lan>
 <20170426105300.GA857@amd>
 <20170426081330.6ca10e42@vento.lan>
 <20170426132337.GA6482@amd>
 <cedfd68d-d0fe-6fa8-2676-b61f3ddda652@gmail.com>
 <20170426225150.GA4188@amd>
 <8a129dca-69c2-366f-1a81-c64dbabc1983@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="l76fUT7nc3MelDdI"
Content-Disposition: inline
In-Reply-To: <8a129dca-69c2-366f-1a81-c64dbabc1983@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--l76fUT7nc3MelDdI
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> Oh, somehow I got confused that this is kernel code :)
>=20
> >But I'd say NEON conversion is not neccessary anytime soon. First,
> >this is just trying to get average luminosity. We can easily skip
> >quite a lot of pixels, and still get reasonable answer.
> >
> >Second, omap3isp actually has a hardware block computing statistics
> >for us. We just don't use it for simplicity.
> >
>=20
> Right, I forgot about that.
>=20
> >(But if you want to play with camera, I'll get you patches; there's
> >ton of work to be done, both kernel and userspace :-).
>=20
> Well, I saw a low hanging fruit I thought I can convert to NEON in a day =
or
> two, while having some rest from the huge "project" I am devoting all my
> spare time recently (rebasing hildon/maemo 5 on top of devuan Jessie).
> Still, if there is something relatively small to be done, just email me a=
nd
> I'll have a look.

Well, there's a ton of work on camera, and some work on
libcmtspeechdata. The later is rather self-contained.
									Pavel
--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--l76fUT7nc3MelDdI
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAllnJ9IACgkQMOfwapXb+vLwLACeKB6N8oWUnTUjQgZaJ94QkMic
CNgAn177IBqBxeyO0DDHUAGGUrZdoWvx
=IlMZ
-----END PGP SIGNATURE-----

--l76fUT7nc3MelDdI--
