Return-path: <linux-media-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:54143 "EHLO
        atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730659AbeKLGSX (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 12 Nov 2018 01:18:23 -0500
Date: Sun, 11 Nov 2018 21:28:50 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Greg KH <gregkh@linuxfoundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-media@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL for v4.20-rc1] new experimental media request API
Message-ID: <20181111202850.GA9704@amd>
References: <20181030105328.0667ec68@coco.lan>
 <CAHk-=whQKCA18MEi7FT=10c0HVa=kxSyYBJeAQH-C2mA5gBhbg@mail.gmail.com>
 <20181031154030.3fab5a00@coco.lan>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="MGYHOYXEY6WxJCY8"
Content-Disposition: inline
In-Reply-To: <20181031154030.3fab5a00@coco.lan>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--MGYHOYXEY6WxJCY8
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> Em Wed, 31 Oct 2018 11:05:09 -0700
> Linus Torvalds <torvalds@linux-foundation.org> escreveu:
>=20
> > On Tue, Oct 30, 2018 at 6:53 AM Mauro Carvalho Chehab
> > <mchehab+samsung@kernel.org> wrote:
> > >
> > > For a new media API: the request API =20
> >=20
> > Ugh. I don't know how much being in staging matters - if people start
> > using it, they start using it.
> >=20
> > "Staging" does not mean "regressions don't matter".
>=20
> Yes, I know.
>=20
> This shouldn't affect normal cameras and generic V4L2 apps, as this
> is for very advanced use cases. So, we hope that people won't start
> using it for a while.=20
>=20
> The main interested party on this is Google CromeOS. We're working=20
> together with them in order to do upstream first. They are well aware
> that the API may change. So, I don't expect any complaints from their
> side if the API would require further changes.

You may want to simply disable it in Kconfig... ChromeOS people can
enable it easily, and if it never worked in the mainline, you get some
wiggle room :-).
								Pavel
--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--MGYHOYXEY6WxJCY8
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAlvokQIACgkQMOfwapXb+vKjbwCfX7lzV1xlXxakbVOS5zy7DXqz
uXAAnist15Ma7w1F5wTGMB+33/9aBTHG
=Hpny
-----END PGP SIGNATURE-----

--MGYHOYXEY6WxJCY8--
