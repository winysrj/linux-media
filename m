Return-path: <linux-media-owner@vger.kernel.org>
Received: from bues.ch ([80.190.117.144]:54549 "EHLO bues.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757352Ab2EGVCx (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 7 May 2012 17:02:53 -0400
Date: Mon, 7 May 2012 23:02:48 +0200
From: Michael =?UTF-8?B?QsO8c2No?= <m@bues.ch>
To: Antti Palosaari <crope@iki.fi>
Cc: linux-media <linux-media@vger.kernel.org>
Subject: Re: [PATCH] fc0011: Reduce number of retries
Message-ID: <20120507230248.5c211f8d@milhouse>
In-Reply-To: <4FA81A23.4000102@iki.fi>
References: <20120403110503.392c8432@milhouse>
	<4F7B1624.8020401@iki.fi>
	<20120403173320.2d3df3f8@milhouse>
	<4FA81A23.4000102@iki.fi>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/c/3g1U5uLo5qO=E9BWw8gag"; protocol="application/pgp-signature"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

--Sig_/c/3g1U5uLo5qO=E9BWw8gag
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Mon, 07 May 2012 21:53:23 +0300
Antti Palosaari <crope@iki.fi> wrote:

> On 03.04.2012 18:33, Michael B=C3=BCsch wrote:
> > On another thing:
> > The af9035 driver doesn't look multi-device safe. There are lots of sta=
tic
> > variables around that keep device state. So it looks like this will
> > blow up if multiple devices are present in the system. Unlikely, but st=
ill... .
> > Are there any plans to fix this up?
> > If not, I'll probably take a look at this. But don't hold your breath.
>=20
> I fixed what was possible by moving af9033 and af9035 configurations for=
=20
> the state. That at least resolves most significant issues - like your=20
> fc0011 tuner callback.

Cool, thanks a lot!

> But there is still some stuff in "static struct=20
> dvb_usb_device_properties" which cannot be fixed. Like dynamic remote=20
> configuration, dual mode, etc. I am going to make RFC for those maybe=20
> even this week after some analysis is done.

Thanks. I'm currently lacking the time to do this kind of intrusive changes,
so I'm happy to see you looking into this.

--=20
Greetings, Michael.

PGP encryption is encouraged / 908D8B0E

--Sig_/c/3g1U5uLo5qO=E9BWw8gag
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJPqDh4AAoJEPUyvh2QjYsOGZMP/jFgJHpG4EPzm00Cy8G4sSz2
8lfBO0WaVasnzVAuxfxzpY9ioq9+17ioQoEFjL71FNBjFBL32AFYQ62aEhC0cRTV
X0bDbHopAjcVh2Ux/MdLpPpNLH48OGDqe8By5sE9bF9fK9o0u4yWR+h9+LYiVmBL
t5QMlkaOJ/mxpTKAH5I6WiJ7AUuv3erBZw8NKE+R5/76pqA6V4h8W1/1CxbnJkor
/fd2zL4FzbdfN5PYz1/DtOXSxuJG1NNxZuYur05eUNKpeoWReNjW91zum3iFV0GE
rYfNKVFJYQol4tZGlmaRA+Nqefzf+Lmsr91cHb6ZTl5xQnVZoPlPRlG23AFGNaeb
xE2W8wKShjKhihNJJkleYnOu1/xmC8e53qPGcMtxRd5tOVQ1i2qpjaysYHX2u2xB
hZ7CaEl/3aXtRphKdF6Yf+8qad/dhgr31465EyEAOYy5ah2r9UuXGJzU7RdZXQGt
TttYovPStxP4CUvrm00qqMMK21LDwzFBHP8kuIZt+83k0d4SYS1m8f0iMletThPw
jwhD2MNzuCv/QdF/wahWfXOjqQsEoK3us20JhzeJYtxO64tV2Uu8viB6oYesX8dH
0uCFvUiFhvpqYLzNkKn4iwHvLFnRWuK/w9Zc7anZWFkrIVTQYO0Jy+ITw/cVYwOm
2xxYBKY8ufrBGYq69WiH
=q5JP
-----END PGP SIGNATURE-----

--Sig_/c/3g1U5uLo5qO=E9BWw8gag--
