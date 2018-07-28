Return-path: <linux-media-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:58663 "EHLO
        atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728296AbeG1VEN (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 28 Jul 2018 17:04:13 -0400
Date: Sat, 28 Jul 2018 21:36:32 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Cc: pali.rohar@gmail.com, sre@kernel.org,
        kernel list <linux-kernel@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        linux-omap@vger.kernel.org, tony@atomide.com, khilman@kernel.org,
        aaro.koskinen@iki.fi, ivo.g.dimitrov.75@gmail.com,
        patrikbachan@gmail.com, serge@hallyn.com, abcloriens@gmail.com,
        clayton@craftyguy.net, martijn@brixit.nl,
        sakari.ailus@linux.intel.com,
        Filip =?utf-8?Q?Matijevi=C4=87?= <filip.matijevic.pz@gmail.com>,
        mchehab@s-opensource.com, sakari.ailus@iki.fi,
        linux-media@vger.kernel.org, hans.verkuil@cisco.com
Subject: Re: [PATCH, libv4l]: Make libv4l2 usable on devices with complex
 pipeline
Message-ID: <20180728193632.GB29593@amd>
References: <20180708213258.GA18217@amd>
 <20180719205344.GA12098@amd>
 <20180723153649.73337c0f@coco.lan>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="QRj9sO5tAVLaXnSD"
Content-Disposition: inline
In-Reply-To: <20180723153649.73337c0f@coco.lan>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--QRj9sO5tAVLaXnSD
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> > > Add support for opening multiple devices in v4l2_open(), and for
> > > mapping controls between devices.
> > >=20
> > > This is necessary for complex devices, such as Nokia N900.
> > >=20
> > > Signed-off-by: Pavel Machek <pavel@ucw.cz> =20
> >=20
> > Ping?
> >=20
> > There's a lot of work to do on libv4l2... timely patch handling would
> > be nice.
>=20
> As we're be start working at the new library in order to support
> complex cameras, and I don't want to prevent you keeping doing your
> work, IMHO the best way to keep doing it would be to create two
> libv4l2 forks:
>=20
> 	- one to be used by you - meant to support N900 camera;
> 	- another one to be used by Google/Intel people that will
> 	  be working at the Complex camera.

Actually, I guess it would be better to share branches. N900 really
has Complex camera :-). Yes, there are some details that are different
(IPU3 will need to pass data between sensor and processing pipeline),
but it

1) will probably need to "propagate controls"
2) will need autofocus
3) would benefit from same autogain improvements
4) [probably most difficult] figure out how to support more than
8-bits depth.

> So, please send me, in priv, a .ssh key for me to add you an
> account at linuxtv.org. I'll send you instructions about how to
> use the new account.

Done, you should have key in your inbox.

Best regards,
									Pavel
--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--QRj9sO5tAVLaXnSD
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAltcxcAACgkQMOfwapXb+vJApwCfQyG3CEdJ6KlUH7AhFLUYDo+X
D3AAmwQzndzK2wARwniCevlN8Vtjdy9R
=A45F
-----END PGP SIGNATURE-----

--QRj9sO5tAVLaXnSD--
