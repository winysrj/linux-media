Return-path: <linux-media-owner@vger.kernel.org>
Received: from bues.ch ([80.190.117.144]:44494 "EHLO bues.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752875Ab2DBRUY (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 2 Apr 2012 13:20:24 -0400
Date: Mon, 2 Apr 2012 19:20:11 +0200
From: Michael =?UTF-8?B?QsO8c2No?= <m@bues.ch>
To: Antti Palosaari <crope@iki.fi>
Cc: linux-media <linux-media@vger.kernel.org>
Subject: Re: [PATCH] Add fc0011 tuner driver
Message-ID: <20120402192011.4edc82ff@milhouse>
In-Reply-To: <4F79DA52.2050907@iki.fi>
References: <20120402181432.74e8bd50@milhouse>
	<4F79DA52.2050907@iki.fi>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/TaOxuL2sUeFi=Y1/It7Y.ZX"; protocol="application/pgp-signature"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

--Sig_/TaOxuL2sUeFi=Y1/It7Y.ZX
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Mon, 02 Apr 2012 19:56:50 +0300
Antti Palosaari <crope@iki.fi> wrote:

> On 02.04.2012 19:14, Michael B=C3=BCsch wrote:
> > This adds support for the Fitipower fc0011 DVB-t tuner.
> >
> > Signed-off-by: Michael Buesch<m@bues.ch>
>=20
> Applied, thanks!
> http://git.linuxtv.org/anttip/media_tree.git/shortlog/refs/heads/af9035_e=
xperimental
>=20
> I looked it through quickly, no big issues. Anyhow, when I ran=20
> checkpatch.pl and it complains rather much. All Kernel developers must=20
> use checkpatch.pl before sent patches and fix findings if possible,=20
> errors must be fixed and warnings too if there is no good reason to=20
> leave as it is.

Well, I _did_ run it on the patch.
There is no error. Only (IMO bogus) warnings. Most of them
are about the 80 char limit. Which isn't really a hard limit. And those lin=
es
only exceed the 80 char limit by a few chars (one, two or such). Splitting
those line serves no readability purpose. In fact, it just worsens it.

> And one note about tuner driver, my AF9035 + FC0011 device founds only 1=
=20
> mux of 4. Looks like some performance issues still to resolve.

I have no idea what this means.
So I have no remote idea of what could possibly be wrong here.
Is this a bug on af903x or the tuner driver?

--=20
Greetings, Michael.

PGP encryption is encouraged / 908D8B0E

--Sig_/TaOxuL2sUeFi=Y1/It7Y.ZX
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJPed/LAAoJEPUyvh2QjYsOln4QAIrjHBhFzZ5bVHQmHA5BUhoj
6bgZwU06Mdh0Fk4q8Y5XweIp14wsOGTriNfaJ/+7tsEisyZuQ/fnhnYrtyZxL2fu
c1JRFVhcWQZvDGe+GGYf6DXVsmT5Ef+jsPWBNp72/iHkG0f5GeyxRr7Iur/XKXTl
3XKZoon7PBTxtqWFhV0LUjcaO/pyXnrZL0icNLQ+Zk6Pmewgu82dT1/dXXtQRhFv
a4czlNMGb7k3CtP27K8H7Fd6mlAnx8v7rDmExc3jQR5W+Y36uld9ksp9WOAxdxIY
u3qKz8xghnZ3HJfXJscblzGShtE9Q3v8wC1TgTGqBUb7HTRNziUaWqMa56h+Xd8X
IBHYPwP0nsPw8fz9bjR5jH3LfR3oD586eLuwu4JC7GinNkSlo6SkS+tVd2Trg+zD
D15V0m7iazSaOAamCVWyrl22mZ2l8NJKLZQsI1Jq20txajFPII9ip5Yl4rffLimZ
ktXbDmi0suYVR9WatOT2yWelsvpzBbTrToby9P7fnixzk+tYOaER0HXx1s5e3TF9
kHSHs+BCAQdBP7J9ljPk+PFEuXTrFpqJfKUcLtUQWGv5zHL8EDwsZAekU0rKVla9
50tX6QbNkKd/K6xcY1vq4bUicT2Aj1c50gn2wV00wVh+L/oW3eFGVC6di5VV8pMC
FF3630MnLmBZAxOzMMgA
=UwB0
-----END PGP SIGNATURE-----

--Sig_/TaOxuL2sUeFi=Y1/It7Y.ZX--
